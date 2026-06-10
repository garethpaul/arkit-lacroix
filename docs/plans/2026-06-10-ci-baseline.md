# ARKit LaCroix CI Baseline

## Status: Completed

## Context

`arkit-lacroix` has an SDK-free Unity source baseline behind `make check`.
The repository needs a lightweight GitHub Actions gate so scene, asset, spawn,
and ambient-light contracts run before review.

## Objectives

- Run the existing Unity source baseline in GitHub Actions.
- Keep the workflow useful without Unity, Xcode, or ARKit hardware.
- Minimize workflow token access and pin third-party action code by commit.
- Make the CI workflow presence part of the SDK-free baseline contract.

## Work Completed

- Added `.github/workflows/check.yml` to run `make check` on pushes, pull
  requests, and manual dispatches.
- Pinned `actions/checkout` to a reviewed commit, limited the workflow token to
  read-only repository access, and bounded execution with a timeout and
  concurrency cancellation.
- Reused the existing Makefile targets, which report the Unity requirement
  while keeping the source baseline executable on Linux.
- Extended `scripts/check-baseline.sh` to require the CI workflow and this
  completed plan.
- Updated README, VISION, SECURITY, and CHANGES with the CI baseline.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`

## Follow-Up Candidates

- Add a Unity batchmode job after the legacy Unity version and export method
  are documented for CI.
