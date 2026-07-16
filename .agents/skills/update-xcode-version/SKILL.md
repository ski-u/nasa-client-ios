---
name: update-xcode-version
description: Update the Xcode version used by this NASAClient iOS repository. Use when asked to change the desired Xcode version in GitHub Actions and the README, including requests such as "update to Xcode 26.6" or "bump the project Xcode version".
---

# Update Xcode Version

Update the repository's declared Xcode version from one `X.Y` input. Keep CI and documentation aligned without changing unrelated runner, Swift, or dependency versions.

## Workflow

1. Confirm the requested version is a non-empty `X.Y`-style value (for example, `26.6`).
2. Start from a clean understanding of the worktree with `git status --short` and inspect the existing values.
3. Change only the Xcode version portions in these files to the requested input:
   - `DEVELOPER_DIR` in both workflows to be `/Applications/Xcode_<version>.app/Contents/Developer`.
   - the README Environment bullet to be `Xcode <version>`.
4. Inspect `git diff -- .github/workflows/format.yml .github/workflows/tests.yml README.md`. Expect only those three version replacements.
5. Do not alter `runs-on`, Swift versions, package versions, or other files unless explicitly requested.
6. Run `git diff --check` and validate YAML syntax if an available repository tool supports it. No Swift source is changed, so do not run Swift formatting solely for this update. Commit or open a PR only when requested.

## Failure handling

If any target is absent or already inconsistent, stop and inspect the files. Update only after confirming the repository's intended layout; do not make partial blind replacements.
