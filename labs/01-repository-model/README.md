# Lab 01 — repository model and inspection

## Objective

Observe the working directory, index, current commit, and branch reference as separate states.

## Setup

```bash
sandbox="$(./scripts/new-sandbox.sh)"
cd "${sandbox}"
```

## Exercise

```bash
printf 'working change\n' >> notes.txt
git status --short
git diff

git add notes.txt
git status --short
git diff --staged

git commit -m "Record repository-model observation"
git show --stat --oneline HEAD
git log --oneline --decorate --graph --all
```

## Expected observations

1. `git diff` shows the change before staging.
2. `git diff --staged` shows it after staging.
3. After commit, both diffs are empty and the branch points to a new commit.

## Verification

```bash
test -z "$(git status --porcelain)"
test "$(git rev-list --count HEAD)" -eq 2
```

## Cleanup

Return to the cloned learning repository and run:

```bash
./scripts/remove-sandbox.sh "${sandbox}"
```

## Extension

Modify two files, stage only one, and explain both sections of `git status` before committing.
