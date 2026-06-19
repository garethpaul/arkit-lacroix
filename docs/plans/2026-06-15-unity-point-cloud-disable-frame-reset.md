# Reset Point-Cloud Frame State On Disable

Status: Completed

## Summary

Prevent both Unity ARKit point-cloud examples from processing frame data that
was captured before a disable and re-enable lifecycle transition.

## Problem

The components now unsubscribe from the static AR frame event in `OnDisable`,
but they retain their last point-cloud data. `PointCloudParticleExample` can
also retain a pending `frameUpdated` flag. If a component is disabled after a
callback and re-enabled before the next AR frame, `Update` can consume stale
data from the previous enabled lifetime.

## Requirements

- Clear retained point-cloud frame data whenever either component is disabled.
- Clear the particle example's pending-frame flag in the same lifecycle path.
- Preserve listener ownership, instantiated render objects, point limits, and
  destruction cleanup.
- Add ordered, mutation-sensitive portable contracts and matching maintenance
  documentation.
- Do not claim Unity editor, Xcode, simulator, or physical-device execution.

## Implementation

- Add a small frame-state reset helper to each point-cloud component.
- Route `OnDisable` and `OnDestroy` through the helper after listener removal.
- Extend `scripts/check-baseline.sh` to require disable-time reset ordering in
  both components and completed-plan evidence.
- Update repository guidance and the changelog with the lifecycle boundary.

## Verification

- Run repository and external-directory `make check`.
- Reject isolated mutations removing either reset helper, the particle pending
  flag reset, disable-time ordering, documentation, or completed-plan status.
- Audit the exact diff, POSIX shell syntax, generated artifacts, whitespace,
  conflict markers, and changed-line credential patterns.

## Risks

- Unity 5.6.1p1 and live AR frame timing are unavailable in this Linux
  environment, so runtime lifecycle behavior remains unexecuted.
- PR stacking must retain the existing point-cloud lifecycle PR as the base;
  neither pull request may be merged or closed without owner authorization.

## Verification Results

- Repository and external-directory `make check` passed the portable Unity
  source, lifecycle, documentation, and completed-plan contracts.
- Six hostile mutations were rejected for the two disable-time resets, the
  particle pending-frame flag, unsubscribe/reset ordering, documentation, and
  completed-plan status.
- POSIX shell syntax, exact-diff, whitespace, generated-artifact, conflict-marker,
  and changed-line credential-pattern audits passed.
- No Unity 5.6.1p1 editor, Xcode export, iOS simulator, physical ARKit device,
  or live frame-timing scenario was executed.
