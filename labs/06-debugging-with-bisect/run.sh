#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
sandbox="$(${repo_root}/scripts/new-sandbox.sh)"

cleanup() {
  "${repo_root}/scripts/remove-sandbox.sh" "${sandbox}" >/dev/null
}
trap cleanup EXIT

printf 'HEALTHY\n' > "${sandbox}/application.state"
git -C "${sandbox}" add application.state
git -C "${sandbox}" commit --quiet -m "Add healthy application state"
known_good="$(git -C "${sandbox}" rev-parse HEAD)"

for number in 1 2; do
  printf 'safe-change-%s\n' "${number}" >> "${sandbox}/history.txt"
  git -C "${sandbox}" add history.txt
  git -C "${sandbox}" commit --quiet -m "Add safe change ${number}"
done

printf 'BROKEN\n' > "${sandbox}/application.state"
git -C "${sandbox}" add application.state
git -C "${sandbox}" commit --quiet -m "Introduce regression"
expected_bad="$(git -C "${sandbox}" rev-parse HEAD)"

for number in 3 4 5; do
  printf 'later-change-%s\n' "${number}" >> "${sandbox}/history.txt"
  git -C "${sandbox}" add history.txt
  git -C "${sandbox}" commit --quiet -m "Add later change ${number}"
done

cat > "${sandbox}/test-regression.sh" <<'TEST'
#!/usr/bin/env bash
set -euo pipefail
test "$(cat application.state)" = "HEALTHY"
TEST
chmod +x "${sandbox}/test-regression.sh"

git -C "${sandbox}" bisect start >/dev/null
git -C "${sandbox}" bisect bad >/dev/null
git -C "${sandbox}" bisect good "${known_good}" >/dev/null
(
  cd "${sandbox}"
  git bisect run ./test-regression.sh >/dev/null
)
found_bad="$(git -C "${sandbox}" rev-parse refs/bisect/bad)"
git -C "${sandbox}" bisect reset >/dev/null

if [[ "${found_bad}" != "${expected_bad}" ]]; then
  echo "Bisect found ${found_bad}; expected ${expected_bad}." >&2
  exit 1
fi

echo "Bisect located the first bad commit:"
git -C "${sandbox}" show --no-patch --oneline "${found_bad}"
