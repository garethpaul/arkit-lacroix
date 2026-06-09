# Unity Ambient Light Null Guard

Status: Completed
Date: 2026-06-09

## Goal

Keep ARKit ambient-light updates from throwing when the Unity scene is missing a
`Light` component or the AR session is unavailable on device startup.

## Changes

- Added a device-update guard before `UnityARAmbient` reads ARKit ambient
  intensity and writes Unity light intensity.
- Preserved the existing ARKit-to-Unity intensity conversion.
- Extended the SDK-free baseline to require the ambient script, scene GUID, and
  null guard.
- Documented the ambient-light guard in the README, changelog, and vision.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Unity editor, iOS export, and ARKit device verification still require a machine
with Unity 5.6.1p1 and the matching legacy iOS toolchain.
