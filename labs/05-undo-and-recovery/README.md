# Lab 05 — undo and reflog recovery

## Objective

Compare scope-specific undo commands and prove that a commit displaced by `reset` can remain recoverable.

## Automated demonstration

```bash
./labs/05-undo-and-recovery/run.sh
```

The script:

1. Creates a disposable repository.
2. Commits a recovery target.
3. Executes `git reset --hard HEAD~1` only inside that sandbox.
4. Finds the displaced commit through `git reflog`.
5. Creates `recovered-work` at that commit.
6. Verifies the recovered content and removes the sandbox.

## Choose by scope

| Situation | Preferred starting point |
|---|---|
| Discard one unstaged file change | `git restore <file>` |
| Unstage while keeping file content | `git restore --staged <file>` |
| Correct the latest unpublished commit | `git commit --amend` |
| Undo a shared commit | `git revert <commit>` |
| Move an unpublished branch while keeping changes staged | `git reset --soft <target>` |
| Investigate a moved/deleted local reference | `git reflog` |

## Production scenario

A faulty change has already reached `main` and triggered a deployment. Create a revert through the protected pull-request path instead of resetting and force-pushing `main`. Investigate the root cause separately from the immediate mitigation.
