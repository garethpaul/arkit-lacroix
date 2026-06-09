# Unity Make Gate Targets

Status: Completed
Date: 2026-06-09

## Goal

Expose standard root verification targets for the legacy Unity sample without
claiming a full editor or iOS export can run on hosts that do not have Unity
5.6.1p1 installed.

## Changes

- Added root `make lint`, `make test`, `make build`, `make verify`, and
  `make check` targets.
- Kept each gate tied to the SDK-free source baseline so scene, prefab, GUID,
  ignore-policy, and `SodaSpawn` guardrails still run without Unity.
- Made `make build` report the missing Unity/batch-build limitation instead of
  silently implying an iOS player was exported.
- Extended README, changelog, vision, and source-baseline checks for the new
  gate contract.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Unity editor, iOS export, and ARKit device verification still require a machine
with Unity 5.6.1p1 and the matching legacy iOS toolchain.
