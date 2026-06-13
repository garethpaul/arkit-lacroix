# Changes

## 2026-06-13

- ParticlePainter caps active and completed paint systems and releases owned systems on destruction.
- Bounded `ParticlePainter` to 10,000 retained samples per stroke and reused the
  active particle buffer instead of reallocating the full stroke every update.
- Replaced per-frame can creation with a repaired, inspector-configurable
  0.05-5 second cadence and a 0.1-second default.
- Scheduled from the current frame time so delayed frames do not trigger
  catch-up spawn bursts.

## 2026-06-12

- Documented GitHub CodeQL default setup for Actions and Unity C#, rejected a
  conflicting advanced workflow, recorded the native bridge analysis gap, and
  disabled checkout credential persistence in the existing Check workflow.
- Repaired invalid particle-painting distance thresholds, anchored the first AR
  frame without painting, and rejected tracking jumps above the configured
  maximum while advancing the sampling anchor.
- Replaced `SodaSpawn` cap-triggered full cleanup with oldest-first eviction so
  the configured cap remains populated without periodic destruction bursts.
- Extended the SDK-free baseline and maintenance notes for the oldest tracked can
  eviction contract.

## 2026-06-10

- Hardened `ParticlePainter` initialization against missing prefab and color
  picker references, and guarded AR callbacks when the main camera is absent.
- Added idempotent `ParticlePainter` event registration and teardown so disabled
  or destroyed components no longer retain global AR frame or color listeners.
- Made root Makefile checks location-independent and pinned CI to the stable
  Ubuntu 24.04 runner image.
- Added a lightweight GitHub Actions workflow that runs `make check` for the
  Unity ARKit source baseline.
- Pinned the workflow's checkout action and limited its token to read-only
  repository access with bounded execution.
- Extended the SDK-free baseline to require the CI workflow and completed CI
  plan.

## 2026-06-09

- Guarded `UnityARAmbient` against AR ambient intensity values above Unity's
  over-bright light range before writing scene light intensity.
- Guarded `UnityARAmbient` against non-finite or negative AR ambient intensity
  values before writing scene light intensity.
- Refreshed `UnityARAmbient` ambient light dependency lookup during device
  updates so late `Light` or AR session availability can recover.
- Guarded `UnityARAmbient` device updates so a missing scene `Light` component
  or unavailable AR session does not throw during ambient intensity updates.
- Added root `make lint`, `make test`, `make build`, and `make check` gates
  around the SDK-free Unity baseline and documented the Unity build limit.
- Pruned missing spawned-can references before `SodaSpawn` enforces the runtime
  cap so externally destroyed cans do not count against the live cleanup limit.
- Bounded `SodaSpawn.maxSodas` so values above the original 1000-can cap repair
  back to the default cleanup limit.
- Added reusable `SodaSpawn.maxSodas` repair so invalid cap values are corrected
  during startup, Unity inspector validation, and spawn updates.
- Extended the SDK-free baseline and README notes for the runtime cap repair
  contract.

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
