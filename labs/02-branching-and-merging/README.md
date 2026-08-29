# Lab 02 — branching and merging

## Objective

Compare fast-forward, three-way, and explicit merge-commit histories.

## Setup

Create a sandbox and one feature branch:

```bash
sandbox="$(./scripts/new-sandbox.sh)"
cd "${sandbox}"
git switch -c feature/catalog
printf 'catalog feature\n' > catalog.txt
git add catalog.txt
git commit -m "Add catalog feature"
```

## Fast-forward experiment

```bash
git switch main
git merge feature/catalog
git log --oneline --graph --decorate --all
```

Because `main` did not advance independently, Git can move its reference directly to the feature commit.

## Diverged-history experiment

```bash
git switch -c feature/orders
printf 'orders feature\n' > orders.txt
git add orders.txt
git commit -m "Add orders feature"

git switch main
printf 'main documentation\n' >> README.md
git add README.md
git commit -m "Update main documentation"
git merge --no-ff feature/orders -m "Merge orders feature"
git log --oneline --graph --decorate --all
```

## Verification

```bash
git show --no-patch --format='%P' HEAD
```

The merge commit displays two parent commit IDs.

## Production question

Would your team preserve the merge topology, squash the pull request, or rebase individual commits? Explain the audit, rollback, and readability trade-offs.

## Cleanup

```bash
./scripts/remove-sandbox.sh "${sandbox}"
```
