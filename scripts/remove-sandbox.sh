#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /absolute/path/to/git-master-map.XXXXXX" >&2
  exit 2
fi

target="$1"

if [[ ! -d "${target}/.git" ]]; then
  echo "Refusing cleanup: target is not a Git sandbox." >&2
  exit 1
fi

case "$(basename "${target}")" in
  git-master-map.*) ;;
  *)
    echo "Refusing cleanup: unexpected sandbox directory name." >&2
    exit 1
    ;;
esac

if [[ "$(git -C "${target}" config --local --get user.email || true)" != "learner@example.invalid" ]]; then
  echo "Refusing cleanup: practice identity marker is missing." >&2
  exit 1
fi

rm -rf -- "${target}"
echo "Removed practice sandbox: ${target}"
