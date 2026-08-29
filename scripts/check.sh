#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Checking shell syntax"
while IFS= read -r script; do
  bash -n "${script}"
done < <(find "${repo_root}" -type f -name '*.sh' -not -path '*/.git/*' | sort)

echo "==> Checking documentation and visual map"
python3 "${repo_root}/scripts/check.py"

echo "==> Testing sandbox lifecycle"
"${repo_root}/tests/test-sandbox.sh"

echo "All Git learning checks passed. Existing repositories were not modified."
