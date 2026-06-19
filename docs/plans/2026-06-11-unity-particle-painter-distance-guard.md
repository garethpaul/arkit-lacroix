# Unity Particle Painter Distance Guard

Status: Completed

## Context

`UnityParticlePainter.unity` serializes `minDistanceThreshold` as `0.05` and
`maxDistanceThreshold` as `1`, but `ParticlePainter` only used the minimum.
ARKit tracking relocalization or a transient pose jump could therefore be
accepted as a paint sample even when it exceeded the scene's configured maximum
distance. Invalid inspector values could also invert or disable the intended
sampling window.

## Requirements

- Keep the existing paint mode, color picker, particle rendering, and event
  lifecycle behavior.
- Repair non-finite, non-positive, or inverted distance thresholds to bounded
  defaults during startup and editor validation.
- Treat the first valid AR frame as an anchor without painting from the world
  origin.
- Ignore movement below the minimum threshold.
- Accept paint samples within the configured minimum/maximum window.
- Treat movement above the maximum threshold as a tracking jump: advance the
  anchor without adding a paint vertex.
- Keep verification available without requiring a local Unity installation.

## Implementation

- Add default minimum and maximum distance constants plus a threshold repair
  helper.
- Track whether a previous AR position has been established.
- Compute frame distance once and split initial, below-minimum, above-maximum,
  and accepted movement paths explicitly.
- Extend the SDK-free baseline and project documentation with the bounded
  sampling contract.

## Verification

- Focused source ordering confirmed minimum rejection, anchor advancement,
  maximum rejection, and accepted painting occur in the intended sequence.
- `sh -n scripts/check-baseline.sh` passed.
- `make lint`, `make test`, `make build`, `make verify`, and `make check`
  passed through the SDK-free baseline; Unity execution reported its documented
  unavailable-toolchain limitation.
- Static mutations for removed maximum-distance rejection, removed initial
  anchor handling, and removed threshold repair were rejected.
- `git diff --check` passed.

Unity is not installed on this host, so device-level AR relocalization behavior
still requires validation in the pinned Unity/ARKit toolchain.
