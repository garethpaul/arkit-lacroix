# Unity Color Presets Listener Teardown

Status: Completed

## Goal

Release the runtime color-picker listener owned by `ColorPresets` when the
component is destroyed, without changing preset or picker behavior.

## Requirements

1. Keep the existing `picker.onValueChanged.AddListener(ColorChanged)` call.
2. Add exactly one matching
   `picker.onValueChanged.RemoveListener(ColorChanged)` call in `OnDestroy`.
3. Tolerate the picker being destroyed before the presets component.
4. Do not clear unrelated listeners or move registration to enable/disable
   callbacks.
5. Add a fail-closed source contract and hostile mutation evidence.
6. Record the lifecycle ownership rule and validation limits in maintained
   documentation and `CHANGES.md`.

## Implementation

1. Extend `scripts/check-baseline.sh` with the exact matched-listener contract.
2. Run the contract before production changes and retain the expected failure.
3. Add the narrow teardown method to `Assets/HSVPicker/UI/ColorPresets.cs`.
4. Update lifecycle guidance and the maintenance log.
5. Run focused, repository-root, and external-directory verification.
6. Mutate the removal event, remove teardown, remove the null-owner guard, and
   duplicate the listener to prove the contract rejects each regression.

## Scope

- Do not change color conversion, preset creation, preset selection, prefab
  serialization, Unity project settings, or other HSV picker components.
- Do not claim Unity editor, Xcode export, camera, or device execution.

## Completion Evidence

- Added one matching `RemoveListener(ColorChanged)` call in `OnDestroy` while
  preserving the existing `Awake` registration and preset behavior, with a
  picker-first destruction guard.
- The source contract failed before implementation with the expected missing
  teardown message.
- Repository-root and external-directory `make check`, shell syntax, and diff
  checks passed.
- Four isolated hostile mutations were rejected for missing removal, removing
  from the wrong event, missing picker-first guard, and duplicate registration;
  the restored fixture passed.
- The official .NET SDK 8 container compiled and executed all eleven portable
  ARKit native-interface production contracts with zero warnings or errors.
- Unity 5.6.1p1 editor, Xcode export, camera, and physical-device execution were
  not run and remain covered by the maintained device checklist.
