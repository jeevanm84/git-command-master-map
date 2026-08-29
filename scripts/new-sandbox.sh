#!/usr/bin/env bash
set -euo pipefail

sandbox_root="${TMPDIR:-/tmp}"
sandbox_root="${sandbox_root%/}"
sandbox="$(mktemp -d "${sandbox_root}/git-master-map.XXXXXX")"

git -C "${sandbox}" init -b main --quiet
git -C "${sandbox}" config user.name "Git Learner"
git -C "${sandbox}" config user.email "learner@example.invalid"
git -C "${sandbox}" config commit.gpgsign false

printf '# Git practice sandbox\n' > "${sandbox}/README.md"
printf 'safe practice repository\n' > "${sandbox}/notes.txt"
git -C "${sandbox}" add README.md notes.txt
git -C "${sandbox}" commit --quiet -m "Create safe practice sandbox"

printf '%s\n' "${sandbox}"
