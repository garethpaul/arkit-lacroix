---
title: CodeQL Baseline
date: 2026-06-12
status: completed
execution: code
---

# CodeQL Baseline

## Summary

Add canonical static analysis for the repository's GitHub Actions, Unity C#,
and native Objective-C++ surfaces without requiring the unavailable Unity
5.6.1p1 editor or changing scene/runtime behavior.

## Requirements

- Analyze `actions`, `csharp`, and `c-cpp` with CodeQL's supported no-build
  mode on pushes, pull requests, scheduled runs, and manual dispatches.
- Pin checkout and CodeQL actions to immutable reviewed commits.
- Keep checkout credentials disabled, permissions exact and least-privilege,
  jobs bounded, and superseded runs cancelled.
- Extend SDK-free contracts for workflow inventory, languages, pins,
  permissions, bypasses, documentation, and completed evidence.
- Preserve the current Check workflow, Unity project files, C#/native source,
  scenes, metadata, and runtime behavior.
- Pass local contracts and exact-head hosted Check and CodeQL gates.

## Scope And Verification

This unit changes only the CodeQL workflow, static checker, repository guidance,
and evidence. Verification includes the untouched baseline, external-working-
directory execution, YAML parsing, focused hostile mutations, and bounded
exact-head hosted queries.

## Sources

- [GitHub CodeQL build options for compiled languages](https://docs.github.com/code-security/reference/code-scanning/codeql/codeql-build-options-and-steps-for-compiled-languages)

## Work Completed

- Added pinned no-build CodeQL analysis for Actions, C#, and C/C++ source.
- Limited CodeQL permissions exactly to read-only contents and security result
  upload, disabled checkout credential persistence in both workflows, bounded
  runtime, and cancelled superseded runs.
- Extended the SDK-free checker and guidance without changing Unity assets,
  project settings, scene metadata, or runtime source.

## Verification Completed

- The untouched baseline passed from the repository and an external working directory
  before implementation.
- `make check` passed after implementation with the documented unavailable
  Unity 5.6.1p1 editor limitation.
- YAML parsing and focused hostile mutations rejected language, action pin,
  permission, checkout credential, bypass, documentation, and plan drift.
- `sh -n scripts/check-baseline.sh`, `git diff --check`, and the secret-pattern
  scan passed.

## Hosted Verification

Exact-head Check and CodeQL evidence will be recorded after push. Tracker
reconciliation remains pending until both canonical events are terminal green
on the same final head.
