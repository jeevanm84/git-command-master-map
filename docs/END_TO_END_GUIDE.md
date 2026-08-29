# End-to-end Git guide

This is the primary learning path. Every exercise uses a disposable repository and can be completed without GitHub or network access.

## Progress map

| Module | Capability | Risk level |
|---:|---|---|
| 0 | Verify the repository and create a sandbox | Safe/local |
| 1 | Inspect working directory, index, and commit state | Safe/local |
| 2 | Create and merge branches | Safe/local |
| 3 | Investigate and resolve conflicts | Isolated sandbox |
| 4 | Rebase and cherry-pick | Isolated sandbox |
| 5 | Undo and recover work | Isolated sandbox |
| 6 | Find a regression with bisect | Isolated sandbox |
| 7 | Design a protected team workflow | Scenario only |

## Module 0 — verify and create a sandbox

```bash
git clone https://github.com/jeevanm84/git-command-master-map.git
cd git-command-master-map
./scripts/check.sh
./scripts/new-sandbox.sh
```

Copy the printed sandbox path and change into it. Confirm the practice identity is local:

```bash
git config --local --get user.name
git config --local --get user.email
git status
```

Expected identity: `Git Learner <learner@example.invalid>`.

## Module 1 — observe the three local states

Inside the sandbox:

```bash
printf 'first change\n' >> notes.txt
git status --short
git diff
git add notes.txt
git status --short
git diff --staged
git commit -m "Add first learning note"
git log --oneline --decorate --graph --all
```

Checkpoint:

- Before `add`, the working directory differs from the index.
- After `add`, the index differs from `HEAD`.
- After `commit`, the new snapshot is reachable through the current branch.

Read [Git Data Model](GIT_DATA_MODEL.md) before continuing.

## Module 2 — branch and merge

Follow [Lab 02](../labs/02-branching-and-merging/README.md). Create two independent branches, inspect their commit graph, and merge them.

Checkpoint: explain why a fast-forward merge has no merge commit and how `--no-ff` changes the graph.

## Module 3 — conflict resolution

Run:

```bash
./labs/03-conflict-resolution/setup.sh
```

Change into the printed sandbox. The repository is intentionally left with a conflict.

Investigation sequence:

```bash
git status
git diff --name-only --diff-filter=U
git diff
git ls-files --unmerged
```

Edit `service.conf`, choose the desired value, remove conflict markers, then:

```bash
git add service.conf
git commit -m "Resolve service configuration conflict"
git log --oneline --graph --decorate --all
```

Recovery option: `git merge --abort` returns to the pre-merge state.

## Module 4 — rebase and cherry-pick

Follow [Lab 04](../labs/04-rebase-and-cherry-pick/README.md).

Checkpoint: compare commit IDs before and after rebase. Explain why rebasing a shared branch can disrupt collaborators.

## Module 5 — undo and recover

Run the executable demonstration:

```bash
./labs/05-undo-and-recovery/run.sh
```

The script creates a commit, moves the branch backward with `reset --hard`, locates the displaced commit through the reflog, and restores it under a recovery branch—all inside a temporary repository.

Then practice the safer shared-history operation:

```bash
git revert <commit>
```

Checkpoint: explain why revert adds history while reset moves a reference.

## Module 6 — regression debugging

Run:

```bash
./labs/06-debugging-with-bisect/run.sh
```

The lab generates a short history containing one regression and uses `git bisect run` to locate the first bad commit automatically.

Checkpoint: state the assumptions a reliable bisect test must satisfy.

## Module 7 — production collaboration

Complete [Lab 07](../labs/07-team-workflow/README.md). Design a protected-main workflow with focused branches, pull requests, automated checks, review, squash/rebase policy, releases, and incident hotfix handling.

## Completion checklist

- [ ] I can distinguish working-tree, staged, committed, and remote-tracking state.
- [ ] I inspect `status`, `diff`, and `log` before undoing work.
- [ ] I can resolve or abort a merge conflict.
- [ ] I understand when rebase is safe and when revert is preferable.
- [ ] I have recovered a displaced commit through the reflog.
- [ ] I have found a regression with an automated bisect.
- [ ] I can explain a protected pull-request workflow.

Next: review [Troubleshooting](TROUBLESHOOTING.md) and test yourself with [Interview Questions](INTERVIEW_QUESTIONS.md).
