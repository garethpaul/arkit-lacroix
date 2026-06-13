---
title: Unity SodaSpawn Cadence Guard
type: performance
status: completed
date: 2026-06-13
---

# Unity SodaSpawn Cadence Guard

## Status: Completed

## Problem Frame

`SodaSpawn.Update()` instantiates a can every rendered frame. Once the existing
1,000-object cap is full, every frame also destroys the oldest can. Spawn rate,
allocation pressure, physics-body creation, and steady-state destruction are
therefore tied to device frame rate instead of an explicit gameplay cadence.

## Scope Boundaries

- Preserve the LaCroix prefab, rigid-body attachment, oldest-first eviction,
  configurable object cap, missing-prefab no-op, and disable-time cleanup.
- Do not resave Unity scenes or prefabs.
- Do not add catch-up spawning after a delayed frame.
- Keep the cadence inspector-configurable while bounding unsafe values.
- Unity 5.6.1p1 editor, Xcode export, and device execution remain unavailable on
  this Linux host.

## Implementation Units

### U1: Add A Repaired Spawn Interval

Files:

- Modify `Assets/SodaSpawn.cs`

Approach:

- Add a serialized interval with a 0.1-second default and 0.05-5-second range.
- Repair NaN, infinity, non-positive, and out-of-range values to the default in
  startup, enable, validation, and update paths.
- Keep cap repair independent from cadence repair.

### U2: Schedule At Most One Spawn Per Interval

Files:

- Modify `Assets/SodaSpawn.cs`

Approach:

- Initialize the next spawn time on enable so the first eligible update can
  spawn immediately.
- Return before instantiation until the interval elapses.
- Schedule the next spawn from the current `Time.time` value, preventing a
  delayed frame from replaying missed intervals.
- Preserve pruning and all existing spawn/eviction behavior for eligible ticks.

### U3: Extend Source And Documentation Contracts

Files:

- Modify `scripts/check-baseline.sh`
- Modify `README.md`
- Modify `CHANGES.md`
- Modify `VISION.md`

Approach:

- Require interval constants, validation, enable-time initialization, gated
  instantiation ordering, no catch-up scheduling, documentation, and completed
  plan evidence.
- Record the runtime-toolchain limitation without claiming Unity execution.

## Verification

- `make check` passed the SDK-free scene/source baseline, lint wrapper, test
  wrapper, and build wrapper.
- Absolute-path `make check` passed from `/tmp`.
- `sh -n scripts/check-baseline.sh` and `git diff --check` passed.
- Ten isolated hostile mutations were rejected across interval bounds, NaN and
  infinity repair, enable initialization, cadence comparison, non-catch-up
  scheduling, and README evidence.
- Unity 5.6.1p1 is not installed, no automated Unity editor runner is checked
  in, and no claim is made for editor, Xcode export, or ARKit device execution.
