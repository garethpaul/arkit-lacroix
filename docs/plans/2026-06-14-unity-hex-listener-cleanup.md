# Unity Hex Listener Cleanup

Status: Completed

## Problem

`HexColorField.Awake` subscribes `UpdateColor` to
`InputField.onEndEdit`, but `OnDestroy` removes the callback from
`onValueChanged`. The actual end-edit listener therefore remains registered
through teardown and can retain or invoke a destroyed component.

## Requirements

1. Remove `UpdateColor` from the same `onEndEdit` event used during
   registration.
2. Preserve the color-picker listener, hex parsing, display formatting, and
   Unity 5.6.1p1-compatible API surface.
3. Add a fail-closed source contract that rejects the mismatched event and a
   hostile mutation proving the guard is effective.
4. Record the lifecycle correction in maintenance guidance and this completed
   plan without claiming Unity editor or device execution.

## Implementation

- Correct the single teardown event in `Assets/HSVPicker/UI/HexColorField.cs`.
- Extend `scripts/check-baseline.sh` with matched add/remove listener contracts.
- Update `AGENTS.md` and `CHANGES.md` with the ownership rule.

## Validation

- Run `sh -n scripts/check-baseline.sh`.
- Run `make check` from the repository and an external directory.
- Run isolated hostile mutations for the wrong event, missing removal, stale
  plan status, and missing documentation.
- Audit the exact diff, Unity generated paths, and credential patterns before
  commit and push.

## Scope

- Do not alter hex parsing, color formatting, picker events, scene assets, or
  Unity project settings.
- Unity editor, Xcode export, and ARKit device execution remain unavailable and
  unclaimed.

## Completed Work

- Corrected `HexColorField.OnDestroy` to remove `UpdateColor` from
  `onEndEdit`, matching the registration performed in `Awake`.
- Added fail-closed contracts for the exact add/remove pair, the absence of the
  mismatched event, one listener pair, documentation, and completed evidence.
- Recorded the listener ownership rule in contributor guidance and the
  changelog.

## Verification

- Repository-root and external-directory `make check` both passed portable
  scene, source, lifecycle, workflow, documentation, and plan contracts.
- Four isolated hostile mutations were rejected for restoring the mismatched
  event, removing listener cleanup, reverting plan status, or removing the
  ownership documentation.
- Unity editor, Xcode export, and ARKit device execution were not run.
