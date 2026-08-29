#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
sandbox="$(${repo_root}/scripts/new-sandbox.sh)"

printf 'worker_count=2\n' > "${sandbox}/service.conf"
git -C "${sandbox}" add service.conf
git -C "${sandbox}" commit --quiet -m "Add service configuration"

git -C "${sandbox}" switch --quiet -c feature/scale-up
printf 'worker_count=6\n' > "${sandbox}/service.conf"
git -C "${sandbox}" add service.conf
git -C "${sandbox}" commit --quiet -m "Scale feature workers"

git -C "${sandbox}" switch --quiet main
printf 'worker_count=4\n' > "${sandbox}/service.conf"
git -C "${sandbox}" add service.conf
git -C "${sandbox}" commit --quiet -m "Tune main workers"

set +e
git -C "${sandbox}" merge feature/scale-up >/dev/null 2>&1
merge_status=$?
set -e

if [[ ${merge_status} -eq 0 ]]; then
  echo "Expected merge conflict was not created." >&2
  "${repo_root}/scripts/remove-sandbox.sh" "${sandbox}" >/dev/null
  exit 1
fi

echo "Conflict sandbox: ${sandbox}"
echo "Next: cd '${sandbox}' && git status"
echo "Cleanup later: '${repo_root}/scripts/remove-sandbox.sh' '${sandbox}'"
