# Changes

## 2026-06-08

- Added `SodaSpawn.OnDisable` cleanup so tracked spawned cans are destroyed when
  the spawner component is disabled or the scene exits.
- Hardened `SodaSpawn` against invalid inspector caps and duplicate Rigidbody
  components on spawned can prefabs.
- Added `make check` as the SDK-free Unity baseline wrapper.
- Restored README verification notes for the Unity source baseline after the
  generated project overview refresh.
- Corrected Unity build settings to use the checked-in `Assets/GameScene.unity`
  scene.
- Added a repository baseline check for Unity version, active scene metadata,
  LaCroix prefab references, and generated-directory ignore policy.
- Documented the legacy Unity 5.6.1p1 ARKit toolchain and local verification
  limits.
