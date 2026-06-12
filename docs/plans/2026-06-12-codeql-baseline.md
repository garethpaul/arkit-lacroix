---
title: CodeQL Baseline
date: 2026-06-12
status: completed
execution: code
---

# CodeQL Baseline

## Summary

Document and guard the repository's existing GitHub CodeQL default setup for
GitHub Actions and Unity C# without requiring the unavailable Unity 5.6.1p1
editor or changing scene/runtime behavior.

## Requirements

- Preserve GitHub default setup analysis for `actions` and `csharp` as the
  repository-owned external security setting.
- Do not add an advanced CodeQL workflow while default setup is active because
  GitHub rejects the conflicting configuration modes.
- Keep checkout credentials disabled and the existing Check workflow pinned,
  read-only, bounded, and cancellation-aware.
- Extend SDK-free contracts to reject extra and advanced CodeQL workflows and
  require truthful documentation of the native analysis boundary.
- Preserve the current Check workflow, Unity project files, C#/native source,
  scenes, metadata, and runtime behavior.
- Pass local contracts and exact-head hosted Check and CodeQL gates.

## Scope And Verification

This unit changes only checkout credential handling, static contracts,
repository guidance, and evidence. Verification includes the untouched
baseline, external-working-directory execution, YAML parsing, focused hostile
mutations, and bounded exact-head hosted queries.

## Sources

- [GitHub CodeQL build options for compiled languages](https://docs.github.com/code-security/reference/code-scanning/codeql/codeql-build-options-and-steps-for-compiled-languages)

## Work Completed

- Recorded that GitHub default setup already analyzes Actions and C#.
- Removed the conflicting advanced CodeQL workflow after all three advanced
  jobs failed while matching default-setup Actions and C# jobs succeeded.
- Disabled checkout credential persistence in the Check workflow and extended
  the SDK-free checker without changing Unity assets, project settings, scene
  metadata, or runtime source.
- Recorded the single Objective-C++ bridge as an uncovered analysis risk; the
  failed C/C++ job did not establish native coverage.

## Verification Completed

- The untouched baseline passed from the repository and an external working directory
  before implementation.
- `make check` passed after implementation with the documented unavailable
  Unity 5.6.1p1 editor limitation.
- YAML parsing and focused hostile mutations rejected duplicate CodeQL and
  extra workflows, restored checkout credentials, documentation drift, and
  incomplete plan evidence.
- `sh -n scripts/check-baseline.sh`, `git diff --check`, and the secret-pattern
  scan passed.

## Hosted Verification

On head `6daf8bdbd32c62a6437a6c5ee77718eadef730cd`, push and pull-request
Check runs `27441864211` and `27441869263` passed. Default-setup CodeQL run
`27441867729` passed for Actions and C#, while duplicate advanced run
`27441869267` failed for Actions, C#, and C/C++. The conflicting workflow was
removed without reducing successful coverage. Exact-head replacement evidence
remains pending until the remediation commit is pushed and terminal green.
