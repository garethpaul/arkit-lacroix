---
title: Unity SodaSpawn Inspector Guard
type: fix
status: completed
date: 2026-06-08
---

# Unity SodaSpawn Inspector Guard

## Summary

Keep the existing raining-can behavior while protecting `SodaSpawn` from
invalid inspector values and prefab Rigidbody drift.

## Requirements

- R1. Preserve the default 1000-can cleanup cap.
- R2. Repair `maxSodas` values below 1 back to the default cap.
- R3. Preserve the null-prefab guard.
- R4. Add a Rigidbody only when the spawned prefab does not already have one.
- R5. Expose `make check` as the root SDK-free verification command.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`

Unity 5.6.1p1 is not installed in this environment, so editor, iOS export, and
device verification remain follow-up work on a matching legacy toolchain.
