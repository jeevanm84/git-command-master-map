#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
sandbox="$(${repo_root}/scripts/new-sandbox.sh)"

cleanup() {
  "${repo_root}/scripts/remove-sandbox.sh" "${sandbox}" >/dev/null
}
trap cleanup EXIT

printf 'important recovery target\n' > "${sandbox}/recovery.txt"
git -C "${sandbox}" add recovery.txt
git -C "${sandbox}" commit --quiet -m "Add recovery target"
target_commit="$(git -C "${sandbox}" rev-parse HEAD)"

git -C "${sandbox}" reset --hard HEAD~1 >/dev/null

if [[ -e "${sandbox}/recovery.txt" ]]; then
  echo "Expected recovery.txt to disappear after reset." >&2
  exit 1
fi

reflog_commit="$(git -C "${sandbox}" reflog --format='%H %gs' | awk '/commit: Add recovery target/ { print $1; exit }')"
if [[ "${reflog_commit}" != "${target_commit}" ]]; then
  echo "Could not locate the displaced commit in the reflog." >&2
  exit 1
fi

git -C "${sandbox}" branch recovered-work "${reflog_commit}"
git -C "${sandbox}" switch --quiet recovered-work

if [[ "$(cat "${sandbox}/recovery.txt")" != "important recovery target" ]]; then
  echo "Recovered content does not match." >&2
  exit 1
fi

echo "Recovery successful."
echo "Displaced commit: ${target_commit}"
echo "Recovered branch: recovered-work"
git -C "${sandbox}" log --oneline --decorate --graph --all
