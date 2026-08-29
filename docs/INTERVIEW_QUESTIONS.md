# Git interview questions

Strong answers explain state, risk, collaboration impact, and recovery—not only a command name.

## Fundamentals

1. What are the working directory, index, local repository, and remote repository?
2. Compare `git diff`, `git diff --staged`, and `git show`.
3. What does a commit contain?
4. What is the difference between a branch and a tag?
5. What does `HEAD` represent?
6. Compare `git fetch` and `git pull`.

## Intermediate

1. Compare fast-forward, three-way, and squash merges.
2. What causes a merge conflict, and what information exists in index stages 1, 2, and 3?
3. Compare `restore`, `revert`, and the three common reset modes.
4. What does rebase change, and why do commit IDs change?
5. When would you cherry-pick rather than merge?
6. What is a remote-tracking branch?
7. When is `git stash` useful, and why should it not become long-term storage?

## Advanced

1. How does the reflog make a reset commit recoverable?
2. How would you diagnose a detached HEAD containing unreferenced work?
3. Explain `--force-with-lease` and the race it helps prevent.
4. How does `git bisect` reduce the search space, and what makes a good automated test?
5. Compare `git log -S` and `git log -G`.
6. How would you split, reorder, or combine unpublished commits safely?
7. What are shallow clones and partial clones, and what trade-offs do they introduce?

## Production

1. A faulty commit is on protected `main` and has already deployed. What is your mitigation and permanent-fix process?
2. CI passed, but a newer untested commit was merged. Which branch rule was missing or misconfigured?
3. A developer force-pushed a shared feature branch. How do you assess and recover collaborators' commits?
4. A secret was committed and then removed in the next commit. Why is the incident unresolved?
5. How would you design a release and hotfix strategy for two maintained versions?
6. Which repository paths require CODEOWNERS and additional scrutiny?

## Senior engineer

1. Define a history policy for a team of 40 engineers. What do you optimize for?
2. How do you migrate from long-lived branches to trunk-based development without disrupting releases?
3. How do you make large mechanical changes reviewable and safely reversible?
4. When should a repository be split, and how would you preserve useful history?
5. How do signed commits, signed tags, artifact provenance, and protected environments relate?
6. What Git metrics are useful, and which are likely to encourage harmful behavior?

## Architect and SRE scenarios

### Scenario: emergency rollback

A release includes a database migration and application changes. Reverting only the application commit may not restore compatibility. Explain how you determine the mitigation sequence, preserve evidence, coordinate database recovery, and prevent a repeated failure.

### Scenario: supply-chain compromise

A privileged workflow file changed in a pull request that otherwise looks routine. Design ownership, approval, workflow-token, action-pinning, environment, and audit controls that limit impact.

### Scenario: repository-scale incident

A migration rewrote years of history and developers have open branches against the old graph. Explain communication, reference preservation, cutover, verification, and recovery strategy.

### Scenario: monorepo delivery

Several independently deployed services share one repository. Design change detection, ownership, test selection, versioning, releases, and rollback without making unrelated teams wait unnecessarily.

## Answer framework

For scenario questions, structure the answer as:

```text
Impact → Evidence preservation → Investigation → Immediate mitigation
→ Collaboration and communication → Permanent fix → Prevention
```

Connect answers to the executable labs rather than relying only on memorized definitions.
