# Lab 04 — rebase and cherry-pick

## Objective

Observe that rebase and cherry-pick recreate commits rather than moving existing commit objects.

## Rebase experiment

```bash
sandbox="$(./scripts/new-sandbox.sh)"
cd "${sandbox}"

git switch -c feature/payments
printf 'payment validation\n' > payments.txt
git add payments.txt
git commit -m "Add payment validation"
before="$(git rev-parse HEAD)"

git switch main
printf 'main advancement\n' >> README.md
git add README.md
git commit -m "Advance main"

git switch feature/payments
git rebase main
after="$(git rev-parse HEAD)"
printf 'before: %s\nafter:  %s\n' "${before}" "${after}"
```

The IDs differ because the rebased commit has a different parent.

## Cherry-pick experiment

```bash
source_commit="$(git rev-parse HEAD)"
git switch main
git switch -c release/hotfix
git cherry-pick "${source_commit}"
git log --oneline --graph --decorate --all
```

The release branch contains equivalent changes under a new commit ID.

## Safety rule

Rebase unpublished local work freely when it improves clarity. Coordinate before rewriting any history another person may have based work on. Prefer revert for undoing a shared production commit.

## Cleanup

```bash
./scripts/remove-sandbox.sh "${sandbox}"
```
