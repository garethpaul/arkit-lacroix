# Unity Color Presets Listener Teardown Design

## Problem

`ColorPresets.Awake` registers `ColorChanged` with the color picker's runtime
`onValueChanged` event, but the component never removes that listener. A picker
that outlives the presets component can therefore retain a callback targeting a
destroyed component during scene or prefab teardown.

Unity 5.6 documents `OnDestroy` as the lifecycle callback used when a
`MonoBehaviour` is destroyed, and `UnityEvent.RemoveListener` as the API for
removing callbacks added at runtime with `AddListener`.

## Options

1. Move registration to `OnEnable` and removal to `OnDisable`.
   This changes whether disabled preset controls continue to mirror picker
   state and introduces re-enable behavior that the legacy sample never had.
2. Clear every picker listener during teardown.
   This would remove callbacks owned by other components.
3. Remove only `ColorChanged` from `onValueChanged` in `OnDestroy`.
   This preserves the existing active-lifetime behavior and matches the exact
   runtime listener owned by `ColorPresets`.

## Decision

Use option 3. Add one `OnDestroy` method with the matching
`RemoveListener(ColorChanged)` call, guarded for picker-first destruction. Keep
preset creation, selection, scene serialization, and picker behavior unchanged.

## Evidence

- Unity 5.6 `MonoBehaviour.OnDestroy`:
  https://docs.unity3d.com/ja/560/ScriptReference/MonoBehaviour.OnDestroy.html
- Unity `UnityEvent.RemoveListener`:
  https://docs.unity3d.com/es/530/ScriptReference/Events.UnityEvent.RemoveListener.html
