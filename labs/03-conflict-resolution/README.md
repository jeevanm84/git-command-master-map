# Lab 03 — conflict investigation and resolution

## Incident

Two branches changed the same `worker_count` line. Git cannot determine which value represents the intended configuration.

## Create the incident

From the repository root:

```bash
./labs/03-conflict-resolution/setup.sh
```

Change into the printed sandbox path.

## Investigation

```bash
git status
git diff --name-only --diff-filter=U
git ls-files --unmerged
git diff
```

Inspect the three index stages:

```bash
git show :1:service.conf   # common ancestor
git show :2:service.conf   # current branch / ours
git show :3:service.conf   # merged branch / theirs
```

## Resolution

Decide the correct production value using requirements—not by automatically choosing ours or theirs. Edit the file, remove all conflict markers, and run:

```bash
git add service.conf
git diff --staged
git commit -m "Resolve worker-count conflict"
```

## Alternative mitigation

To abandon the operation safely:

```bash
git merge --abort
```

## Prevention

- Keep branches focused and short-lived.
- Integrate frequently.
- Assign clear ownership to high-conflict files.
- Validate generated configuration rather than resolving only syntax.

## Cleanup

Use the exact cleanup command printed by the setup script.
