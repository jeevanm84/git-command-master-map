#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sandbox="$(${repo_root}/scripts/new-sandbox.sh)"

if [[ ! -d "${sandbox}/.git" ]]; then
  echo "Sandbox Git repository was not created." >&2
  exit 1
fi

if [[ "$(git -C "${sandbox}" branch --show-current)" != "main" ]]; then
  echo "Sandbox did not start on main." >&2
  exit 1
fi

if [[ -n "$(git -C "${sandbox}" status --porcelain)" ]]; then
  echo "Sandbox did not start clean." >&2
  exit 1
fi

"${repo_root}/scripts/remove-sandbox.sh" "${sandbox}" >/dev/null

if [[ -e "${sandbox}" ]]; then
  echo "Sandbox cleanup failed." >&2
  exit 1
fi

echo "Sandbox create/verify/remove lifecycle passed."
