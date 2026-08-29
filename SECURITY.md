# Security policy

## Report privately

Use GitHub private vulnerability reporting for security defects in scripts, workflows, or published Pages content. Do not publish exploit details, credentials, tokens, private repository data, or sensitive history in an issue.

## Learning safety

Lab scripts create repositories under the operating system's temporary directory and mark them with a local practice identity. Cleanup refuses targets without the expected directory name, Git metadata, and identity marker.

Review every command before running it. The safety guards reduce risk but do not replace understanding the target and scope of a destructive operation.

Security fixes target the latest commit on `main` on a best-effort basis.
