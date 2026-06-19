---
title: Unity Particle Painter Buffer Bound
type: performance
status: completed
date: 2026-06-13
---

# Unity Particle Painter Buffer Bound

## Status: Completed

## Problem Frame

`ParticlePainter.Update()` allocates a new particle array sized to the entire
current stroke whenever an accepted AR frame arrives. The corresponding vertex
list has no upper bound, so a long painting session continuously increases both
retained memory and the cost of rebuilding the particle array.

## Scope Boundaries

- Preserve paint modes, color selection, movement-window sampling, particle
  size, pen distance, and completed-stroke retention.
- Bound only the current stroke's retained samples; do not resave Unity scenes,
  prefabs, or metadata.
- Keep the limit inspector-configurable while repairing unsafe serialized or
  runtime values.
- Reuse one particle array per current stroke instead of allocating one on each
  rendered update.
- Unity 5.6.1p1 editor, Xcode export, and device execution remain unavailable on
  this Linux host.

## Implementation Units

### U1: Add A Repaired Per-Stroke Sample Limit

Files:

- Modify `Assets/ParticlePainter.cs`

Approach:

- Add a serialized maximum with a conservative default and explicit range.
- Repair out-of-range values during validation, startup, and runtime updates.
- Stop accepting additional points once the current stroke reaches the repaired
  limit while continuing to advance the movement anchor.

### U2: Reuse The Current Stroke Particle Buffer

Files:

- Modify `Assets/ParticlePainter.cs`

Approach:

- Allocate the particle array when a stroke starts or its repaired limit
  changes, not once per frame.
- Populate only the active prefix and pass the accepted vertex count to
  `SetParticles`.
- Preserve the zero-size placeholder used for an empty stroke.

### U3: Extend Source And Documentation Contracts

Files:

- Modify `scripts/check-baseline.sh`
- Modify `README.md`
- Modify `CHANGES.md`
- Modify `VISION.md`

Approach:

- Require the limit constants, repair paths, bounded append, reusable-buffer
  allocation, and completed plan evidence.
- Add isolated hostile mutations for limit repair, append bounding, and buffer
  reuse so the static gate proves that each contract is necessary.
- Record the runtime-toolchain limitation without claiming Unity execution.

## Verification

- `make check` passed the SDK-free scene/source baseline, lint wrapper, test
  wrapper, and build wrapper.
- Absolute-path `make check` passed from `/tmp`.
- `sh -n scripts/check-baseline.sh` and `git diff --check` passed.
- Ten isolated hostile mutations were rejected across the default cap,
  inspector range, upper-bound repair, buffer resize condition, repaired
  allocation size, runtime trim, bounded append, populated-prefix submission,
  per-frame allocation regression, and README evidence.
- Unity 5.6.1p1 is not installed, no automated Unity editor runner is checked
  in, and no claim is made for editor, Xcode export, or ARKit device execution.
