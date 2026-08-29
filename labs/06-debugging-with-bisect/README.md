# Lab 06 — regression debugging with bisect

## Incident

The current application state fails, an older revision passed, and several commits lie between them.

## Automated investigation

```bash
./labs/06-debugging-with-bisect/run.sh
```

The lab creates a seven-commit history and runs a deterministic test at each midpoint. `git bisect` narrows the search to the first commit that changed the application from healthy to broken.

## Production requirements for a useful bisect test

- It exits `0` for good and nonzero for bad.
- It is deterministic.
- It is fast enough to run repeatedly.
- It distinguishes environment failure from product regression.
- It can return `125` when a commit cannot be tested.

## Investigation extensions

After identifying a candidate commit, use:

```bash
git show <commit>
git diff <commit>^ <commit>
git blame <file>
git log -S'<changed text>' --oneline
git log -G'<pattern>' --oneline
```

`blame` identifies the most recent commit for lines; it does not establish fault or intent.
