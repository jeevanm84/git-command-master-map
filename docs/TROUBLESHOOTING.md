# Git troubleshooting handbook

Investigate before applying a destructive command. Start with:

```bash
git status
git log --oneline --decorate --graph --all -20
git reflog -20
git diff
git diff --staged
```

## Incident 1 — committed on the wrong branch

**Symptoms:** A valid local commit appears on `main` instead of the intended feature branch.

**Investigation:** Confirm the commit has not been pushed and record its ID.

```bash
git branch --show-current
git log -3 --oneline
git status
```

**Immediate mitigation:** Preserve the commit first.

```bash
git branch feature/recovered-work HEAD
git switch main
git reset --hard HEAD~1
git switch feature/recovered-work
```

Use the reset only for unpublished local history. If the commit is already shared, create the feature branch and revert the commit on `main` through the normal review process.

**Prevention:** Show the branch in the shell prompt and run `git status --short --branch` before committing.

## Incident 2 — reset removed a commit

**Symptoms:** A commit no longer appears in the normal branch log after reset.

**Investigation:** Stop creating additional history and inspect the reflog.

```bash
git reflog --date=local
git show <candidate-commit>
```

**Recovery:** Create a new reference before doing anything else.

```bash
git branch recovered-work <candidate-commit>
```

**Root cause:** Reset moved the branch reference; it did not immediately erase the commit object.

**Prevention:** Create a backup branch before risky local history operations.

## Incident 3 — push rejected as non-fast-forward

**Symptoms:** The remote rejects a normal push because the remote branch contains commits absent locally.

**Investigation:** Fetch, then compare both sides.

```bash
git fetch origin
git log --oneline --left-right --graph HEAD...origin/main
```

**Mitigation:** Integrate according to team policy:

```bash
git rebase origin/main
# or
git merge origin/main
```

Do not solve an unexplained rejection with `--force`. If rewriting an explicitly coordinated feature branch is required, use `--force-with-lease` after fetching and reviewing divergence.

## Incident 4 — conflict during merge or rebase

**Symptoms:** Git stops and reports unmerged paths.

**Investigation:**

```bash
git status
git diff --name-only --diff-filter=U
git diff
```

**Mitigation:** Resolve based on intended behavior, stage the result, run tests, then continue:

```bash
git add <resolved-files>
git merge --continue
# or
git rebase --continue
```

Abort when the operation or resolution is no longer understood:

```bash
git merge --abort
# or
git rebase --abort
```

## Incident 5 — detached HEAD contains useful work

**Symptoms:** Commits exist, but `git branch --show-current` is empty.

**Investigation:** Record `HEAD` and inspect the graph.

```bash
git rev-parse HEAD
git log --oneline --decorate --graph --all
```

**Recovery:** Attach the work to a new branch:

```bash
git switch -c recovered-detached-work
```

## Incident 6 — secret committed to history

**Symptoms:** A credential or sensitive value appears in a commit.

**Immediate mitigation:**

1. Revoke or rotate the credential immediately; deleting the file is not revocation.
2. Determine repositories, forks, caches, artifacts, logs, and deployments that received it.
3. Notify the authorized security channel.
4. Remove the secret from current code and add preventive scanning.
5. Coordinate history rewriting only if policy requires it; rewriting does not invalidate an exposed credential.

**Prevention:** Secret scanning, push protection, short-lived identity, ignored local configuration, and code review.

## Incident 7 — `git pull` created an unexpected merge

**Symptoms:** Local history contains a merge commit after pulling.

**Investigation:** Inspect pull configuration and reflog.

```bash
git config --show-origin --get-regexp '^pull\.'
git reflog -10
git show --summary HEAD
```

**Permanent fix:** Agree on and configure an explicit strategy:

```bash
git config pull.rebase true
# or
git config pull.rebase false
# or require fast-forward only
git config pull.ff only
```

The correct choice is a team history policy, not a universal command preference.
