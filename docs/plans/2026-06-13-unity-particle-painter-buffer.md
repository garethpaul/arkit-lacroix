---
title: Unity Particle Painter Buffer Bound
type: performance
status: planned
date: 2026-06-13
---

# Unity Particle Painter Buffer Bound

## Status: Planned

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

## Verification Plan

- Run `make check` from the repository and by absolute path from `/tmp`.
- Run `sh -n scripts/check-baseline.sh` and `git diff --check`.
- Run isolated hostile mutations against each new source and documentation
  contract and require every mutation to fail the checker.
- Record Unity editor, Xcode export, and ARKit device verification as unavailable
  rather than inferred.
