# Unity Ambient Intensity Value Guard

## Status: Completed

## Context

`UnityARAmbient` already skips device updates when the scene `Light` component
or AR session is unavailable. Once dependencies are present, it still applies
the raw ARKit ambient intensity to the Unity `Light`; non-finite or negative
values should not be written into scene lighting.

## Objectives

- Preserve the existing ARKit ambient intensity source and Unity conversion.
- Reject `NaN`, infinite, or negative ambient intensity values before writing
  to the `Light`.
- Keep the guard SDK-free because Unity is unavailable in this environment.

## Work Completed

- Added `IsRenderableAmbientIntensity` to isolate value validation.
- Guarded `Update()` before the ARKit-to-Unity intensity conversion.
- Extended `scripts/check-baseline.sh`.
- Updated README, VISION, and CHANGES notes.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
