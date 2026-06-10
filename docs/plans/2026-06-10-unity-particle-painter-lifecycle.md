# Unity Particle Painter Lifecycle Guard

## Status: Completed

## Context

`ParticlePainter` registered a global AR frame callback and an anonymous color
picker listener during `Start`, but never removed either listener. Disabled or
destroyed components could therefore continue receiving callbacks and retain
scene objects. The script also dereferenced required scene references and the
tagged main camera without checking availability.

## Objectives

- Validate required particle prefab and color picker references before setup.
- Register callbacks only after successful initialization.
- Remove global AR frame and color picker listeners when inactive or destroyed.
- Make disable, destroy, and re-enable transitions idempotent.
- Skip AR frame work safely when the tagged main camera is unavailable.
- Preserve compatibility with the checked-in Unity 5.6.1p1 project.

## Work Completed

- Added guarded initialization for the particle prefab, instantiated particle
  system, and color picker.
- Replaced the anonymous color callback with a named listener that can be
  removed during teardown.
- Added shared, idempotent subscription helpers used by startup, re-enable,
  disable, and destroy lifecycle hooks.
- Guarded AR frame, GUI, restart, and update paths against incomplete setup.
- Extended the SDK-free source baseline to enforce the lifecycle contract.
- Made Makefile baseline commands repository-rooted and fixed the hosted CI
  runner image to Ubuntu 24.04.

## Verification

- `make check`
- `make -f /tmp/arkit-lacroix-second-pass/Makefile check`
- `scripts/check-baseline.sh`
- Baseline mutation checks for each new dependency, subscription, teardown,
  camera, workflow, and Makefile contract
- `sh -n scripts/check-baseline.sh`
- `git diff --check`

The current host does not provide Unity 5.6.1p1, Xcode, or ARKit hardware, so
editor compilation and device behavior remain manual follow-up checks on the
documented legacy toolchain.

## Follow-Up Candidates

- Add Unity editor tests after a reproducible legacy editor runner is available.
- Validate inspector reference assignments and paint-mode transitions on an
  ARKit-capable device.
