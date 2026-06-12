# Unity SodaSpawn Cap Eviction

## Status: Completed

## Goal

Keep the raining-can demo bounded without destroying every live can when the
configured cap is reached.

## Problem

`SodaSpawn` currently calls `ClearSodas` as soon as the tracked count reaches
`maxSodas`. A cap of one therefore destroys the can created in the same frame,
and the default cap periodically replaces a full scene with an empty one. That
creates avoidable destruction bursts and makes the configured value behave as
a reset threshold rather than a maximum live-object count.

## Scope

- Preserve the existing per-frame spawn cadence and default 1000-can cap.
- Remove the oldest tracked cans only when the live count exceeds `maxSodas`.
- Retain `ClearSodas` for component-disable and scene-exit cleanup.
- Extend the SDK-free baseline and maintenance documentation for the eviction
  contract.

## Out Of Scope

- Changing the prefab, Rigidbody behavior, scene references, or Unity assets.
- Adding object pooling or a time-based spawn interval.
- Opening or resaving the project in Unity.

## Verification

- `make check`
- `sh -n scripts/check-baseline.sh`
- `git diff --check`

Unity 5.6.1p1 is unavailable on this host, so editor, iOS export, and ARKit
device verification remain deferred to a matching legacy toolchain.
