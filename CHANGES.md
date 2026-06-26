# Changes

## 2026-06-26 - P1 - Bound Unity point-marker allocation

### Summary

Prevented malformed scene serialization or runtime assignments from making
`UnityPointCloudExample` instantiate an unbounded number of marker objects.
UnityPointCloudExample repairs invalid marker counts before allocation so malformed serialization cannot create more than 1,000 owned markers.

### Work completed

- Preserved the public serialized `uint` and all checked-in scene values.
- Added startup and inspector-time repair for zero or values above 1,000.
- Added source, documentation, and implementation-plan contracts.

### Validation

- Test-first baseline failed on the missing default point-count constant.
- `scripts/check-baseline.sh` passed after the bounded repair.
- `make check` and external-directory `make check` passed.
- Official .NET SDK 8 container compiled and ran eleven production native-interface contracts with zero warnings or errors.
- Three isolated upper-bound, startup-repair, and ceiling mutations failed for the intended reasons.
- Unity 5.6.1p1 editor, iOS/Xcode export, ARKit session, camera, and physical-device execution remain unverified locally.

## 2026-06-26 - P2 - Release ColorPickerTester listener

### Summary

Replaced the picker test scene's anonymous color callback with a named listener
and removed it during destruction so a longer-lived picker cannot retain a
callback targeting the destroyed tester component.
ColorPickerTester removes its runtime color listener during teardown while
preserving the existing renderer color updates during the component lifetime.

### Validation

- Test-first baseline failed on the missing removable named listener.
- `make check`
- External-directory `make check`
- Official .NET SDK 8 container compiled and ran eleven production native-interface contracts with zero warnings or errors.
- Three isolated listener-identity and teardown mutations failed for the intended reason.
- Unity 5.6.1p1 editor, iOS export, camera, and physical-device behavior remain unverified locally.
- Exact-head Check runs `28250864796` and `28250867946` passed in 20 and 17
  seconds; CodeQL run `28250865522` passed Actions and C# analysis.
- Codex review was blocked before analysis by repeated OpenAI API HTTP 401
  failures; immutable exact-head manual review found no actionable findings.

## 2026-06-26 - P1 - Remove tracked Unity password material

### Summary

Cleared the unused PSP2 package-password value from the tracked Unity project
settings and added a repository gate that rejects any future nonblank value.

### Validation

- `make check`
- A hostile nonblank-value mutation must fail the baseline gate.
- Gitleaks current-tree scan must report no findings.

### Follow-up

- Treat the historical value as potentially exposed and revoke or rotate it if
  it was ever active; this repository change does not rewrite public history.

## 2026-06-25 22:08 PDT - P2 - Release ColorPresets listener

### Summary

Closed a UnityEvent ownership gap in the HSV picker so destroying
`ColorPresets` no longer leaves its runtime color callback registered on a
longer-lived picker.
ColorPresets removes its runtime color listener during teardown while
preserving the legacy component's active-lifetime behavior.

### Work completed

- Added a null-safe matching `onValueChanged.RemoveListener(ColorChanged)` teardown.
- Added test-first source, documentation, plan, and ownership contracts.
- Recorded the narrow design decision and Unity 5.6 API evidence.

### Threads

- Started: None.
- Continued: None.
- Stopped: None.

### Files changed

- `Assets/HSVPicker/UI/ColorPresets.cs` — safely releases the owned runtime listener even when the picker is destroyed first.
- `scripts/check-baseline.sh` — rejects missing, mismatched, or duplicate pairs.
- `docs/plans/2026-06-25-unity-color-presets-listener-teardown*.md` — records design and completion evidence.
- `AGENTS.md`, `README.md`, `SECURITY.md`, `VISION.md` — document ownership.

### Validation

- Test-first baseline — failed before implementation with the expected missing-removal error.
- Initial completed-evidence gate — failed because this entry lacked the canonical ownership phrase; corrected before final validation.
- `make check` — passed; host dotnet and Unity remained unavailable as reported.
- `make -f "$PWD/Makefile" check` — passed from the external invocation path.
- `/bin/sh -n scripts/*.sh` and `git diff --check` — passed.
- Official .NET SDK 8 container — compiled and ran eleven production native-interface contracts with zero warnings or errors.
- Four isolated hostile mutations — rejected; restored fixture passed.

### Bugs / findings

- P2: `ColorPresets` registered a runtime UnityEvent callback without releasing it during teardown; teardown also needs to tolerate picker-first destruction.

### Blockers

- Unity 5.6.1p1 editor, iOS/Xcode export, camera, and physical-device checks were not executable locally.

### Next action

- Run hosted verification, review the exact PR diff, and merge if green.

## 2026-06-25

- Revalidated idempotent AR anchor event teardown and early plane-generator
  destruction with the repository lifecycle gate and an independent Codex review.

## 2026-06-16

- Added a .NET 8 compiler and executable ABI-contract gate for eleven production
  ARKit native-interface structs and enums that do not depend on Unity
  assemblies.
- Kept the portable compiler evidence separate from the unexecuted Unity 5.6,
  Xcode export, camera, and physical-device verification boundary.

- Point-cloud renderers omit non-finite AR coordinates before writing Unity positions.
- AR hit-test interactions reject non-finite spawn and movement coordinates before writing Unity transforms.

- Cleared pending point-cloud frame state on disable so re-enabled components
  wait for a frame from the new enabled lifetime.
- Point-cloud examples clear pending AR frame data when disabled before accepting a new enabled-lifetime frame.
- Particle point-cloud output hides during disabled frame reset instead of
  leaving the last emitted cloud visible.

## 2026-06-15

- Point-cloud markers hide when they are not represented by the current AR frame.
- Point-cloud examples release AR frame listeners and owned scene objects during lifecycle teardown.
- Corrected the particle point-cloud loop to honor its configured maximum.

## 2026-06-14

- HexColorField removes its end-edit listener from the matching event during
  teardown instead of removing an unrelated value-change listener.
- UnityARVideo detaches and releases its command buffer on disable
  and destroy while preserving re-enable initialization.
- Added an exact-commit ARKit Lacroix device verification matrix for editor and
  Xcode export, camera permission, tracking, textures, ambient light, bounded
  scene ownership, interruption, long sessions, and privacy-safe evidence, with every runtime row explicitly unexecuted.
- UnityARBallz BallMover releases its tracked object before replacement and when disabled.
- UnityARVideo reuses its external texture pair and releases it on teardown.
- Bounded UnityARBallz BallMaker ownership with stale-reference pruning,
  oldest-first eviction, missing-prefab guards, and disable cleanup.

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
