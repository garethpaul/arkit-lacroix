---
title: ARKit Native Interface Compiler Contracts
type: testing
date: 2026-06-16
status: completed
execution: code
---

# ARKit Native Interface Compiler Contracts

## Status: Completed

## Summary

Compile the production ARKit ABI declarations that depend only on `System` and
execute their portable layout and value contracts on every hosted change.

## Requirements

- Compile eleven production ARKit native-interface sources directly rather
  than copying their declarations into a test fixture.
- Verify native struct sizes, enum backing types and numeric values, and
  composable hit-test flags.
- Redirect all .NET CLI, NuGet, intermediate, and output state to a temporary
  directory so verification does not dirty the Unity checkout.
- Pin hosted .NET setup to an immutable action commit and retain read-only
  repository permissions.
- State clearly that this does not compile the full Unity project, Objective-C++
  bridge, Xcode export, or device runtime.

## Work Completed

- Added an SDK-style executable contract project linked to eleven production
  ARKit native-interface sources.
- Added ABI assertions for points, sizes, rectangles, light estimates, texture
  handles, error codes, tracking states, and hit-test flags.
- Wired the isolated runner into `make test` and the canonical hosted
  `make check` path through pinned .NET 8 setup.
- Extended the static baseline and repository guidance to preserve the compiler
  boundary and its runtime non-claims.

## Verification Completed

- The native-interface project compiled and all executable contracts passed.
- `make lint`, `make test`, `make build`, `make verify`, and `make check` passed.
- The absolute-Makefile invocation passed outside the repository.
- Hostile mutations to source linkage, ABI assertions, Make wiring, hosted .NET
  setup, temporary output isolation, and plan evidence were rejected.
- The full Unity 5.6.1p1 editor project and iOS export remain manual and were not
  claimed by this work.
