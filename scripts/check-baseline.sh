#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PROJECT_VERSION="$ROOT_DIR/ProjectSettings/ProjectVersion.txt"
BUILD_SETTINGS="$ROOT_DIR/ProjectSettings/EditorBuildSettings.asset"
GAME_SCENE="$ROOT_DIR/Assets/GameScene.unity"
README="$ROOT_DIR/README.md"
SODA_SPAWN="$ROOT_DIR/Assets/SodaSpawn.cs"
PARTICLE_PAINTER="$ROOT_DIR/Assets/ParticlePainter.cs"
RUNTIME_CAP_PLAN="docs/plans/2026-06-09-unity-sodaspawn-runtime-cap-repair.md"
UPPER_CAP_PLAN="docs/plans/2026-06-09-unity-sodaspawn-upper-cap-repair.md"
MISSING_REFERENCE_PLAN="docs/plans/2026-06-09-unity-sodaspawn-missing-reference-prune.md"
CAP_EVICTION_PLAN="docs/plans/2026-06-12-unity-sodaspawn-cap-eviction.md"
MAKE_GATE_PLAN="docs/plans/2026-06-09-unity-make-gate-targets.md"
AMBIENT_GUARD_PLAN="docs/plans/2026-06-09-unity-ambient-light-null-guard.md"
AMBIENT_DEPENDENCY_PLAN="docs/plans/2026-06-09-unity-ambient-light-dependency-refresh.md"
AMBIENT_VALUE_PLAN="docs/plans/2026-06-09-unity-ambient-intensity-value-guard.md"
AMBIENT_UPPER_PLAN="docs/plans/2026-06-09-unity-ambient-intensity-upper-bound.md"
CI_PLAN="docs/plans/2026-06-10-ci-baseline.md"
PARTICLE_PAINTER_PLAN="docs/plans/2026-06-10-unity-particle-painter-lifecycle.md"
PARTICLE_DISTANCE_PLAN="docs/plans/2026-06-11-unity-particle-painter-distance-guard.md"
PARTICLE_BUFFER_PLAN="docs/plans/2026-06-13-unity-particle-painter-buffer.md"
PARTICLE_SYSTEM_PLAN="docs/plans/2026-06-13-particle-painter-system-bound.md"
CODEQL_PLAN="docs/plans/2026-06-12-codeql-baseline.md"
SPAWN_CADENCE_PLAN="docs/plans/2026-06-13-unity-sodaspawn-cadence.md"
CHECK_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file is missing: $path" >&2
    exit 1
  fi
}

require_contains() {
  path=$1
  pattern=$2
  message=$3

  if ! grep -Fq "$pattern" "$ROOT_DIR/$path"; then
    printf '%s\n' "$message" >&2
    exit 1
  fi
}

for path in \
  "README.md" \
  ".github/workflows/check.yml" \
  "CHANGES.md" \
  "docs/plans/2026-06-08-unity-arkit-scene-baseline.md" \
  "docs/plans/2026-06-08-unity-sodaspawn-disable-cleanup.md" \
  "$RUNTIME_CAP_PLAN" \
  "$UPPER_CAP_PLAN" \
  "$MISSING_REFERENCE_PLAN" \
  "$CAP_EVICTION_PLAN" \
  "$MAKE_GATE_PLAN" \
  "$AMBIENT_GUARD_PLAN" \
  "$AMBIENT_DEPENDENCY_PLAN" \
  "$AMBIENT_VALUE_PLAN" \
  "$AMBIENT_UPPER_PLAN" \
  "$CI_PLAN" \
  "$PARTICLE_PAINTER_PLAN" \
  "$PARTICLE_DISTANCE_PLAN" \
  "$PARTICLE_BUFFER_PLAN" \
  "$PARTICLE_SYSTEM_PLAN" \
  "$CODEQL_PLAN" \
  "$SPAWN_CADENCE_PLAN" \
  "ProjectSettings/ProjectVersion.txt" \
  "ProjectSettings/EditorBuildSettings.asset" \
  "Assets/GameScene.unity" \
  "Assets/GameScene.unity.meta" \
  "Assets/SodaSpawn.cs" \
  "Assets/SodaSpawn.cs.meta" \
  "Assets/UnityARAmbient.cs" \
  "Assets/UnityARAmbient.cs.meta" \
  "Assets/ParticlePainter.cs" \
  "Assets/ParticlePainter.cs.meta" \
  "Assets/Models/LaCroix.prefab" \
  "Assets/Models/LaCroix.prefab.meta" \
  "Assets/Models/can4.obj" \
  "Screenshots/demo01.png"; do
  require_file "$path"
done

require_contains "ProjectSettings/ProjectVersion.txt" "m_EditorVersion: 5.6.1p1" \
  "Unity editor version must stay documented as 5.6.1p1."
require_contains "ProjectSettings/EditorBuildSettings.asset" "path: Assets/GameScene.unity" \
  "Active build scene must point to Assets/GameScene.unity."

if grep -Fq "Assets/UnityARKitScene.unity" "$BUILD_SETTINGS"; then
  printf '%s\n' "Build settings must not reference the missing UnityARKitScene scene." >&2
  exit 1
fi

require_contains "Assets/GameScene.unity.meta" "guid: c159f2591a9b5c843b0a0442451f78f8" \
  "GameScene metadata GUID must match the active scene entry."
require_contains "Assets/SodaSpawn.cs.meta" "guid: 5699d7c94266d45358e93a1669d14431" \
  "SodaSpawn script GUID must remain stable for scene references."
require_contains "Assets/UnityARAmbient.cs.meta" "guid: 5587c957048494a2f96db36e0995449e" \
  "UnityARAmbient script GUID must remain stable for scene references."
require_contains "Assets/Models/LaCroix.prefab.meta" "guid: 58d1050948cdd4bfeb2ee58ee3093988" \
  "LaCroix prefab GUID must remain stable for scene references."
require_contains "Assets/GameScene.unity" "guid: 5699d7c94266d45358e93a1669d14431" \
  "GameScene must reference SodaSpawn."
require_contains "Assets/GameScene.unity" "guid: 5587c957048494a2f96db36e0995449e" \
  "GameScene must reference UnityARAmbient."
require_contains "Assets/GameScene.unity" "guid: 58d1050948cdd4bfeb2ee58ee3093988" \
  "GameScene must reference the LaCroix prefab."
require_contains "Assets/UnityARAmbient.cs" "GetComponent<Light>()" \
  "UnityARAmbient must read the scene Light component before applying ARKit intensity."
require_contains "Assets/UnityARAmbient.cs" "UnityARSessionNativeInterface.GetARSessionNativeInterface" \
  "UnityARAmbient must read the ARKit session before applying ambient intensity."
require_contains "Assets/UnityARAmbient.cs" "private bool EnsureAmbientDependencies ()" \
  "UnityARAmbient must keep ambient dependency refresh in a reusable helper."
require_contains "Assets/UnityARAmbient.cs" "if (l == null)" \
  "UnityARAmbient must retry missing Light component lookup before updating intensity."
require_contains "Assets/UnityARAmbient.cs" "if (m_Session == null)" \
  "UnityARAmbient must retry missing AR session lookup before updating intensity."
require_contains "Assets/UnityARAmbient.cs" "if (!EnsureAmbientDependencies ())" \
  "UnityARAmbient must guard updates through the dependency refresh helper."
require_contains "Assets/UnityARAmbient.cs" "GetARAmbientIntensity()" \
  "UnityARAmbient must keep using ARKit ambient intensity."
require_contains "Assets/UnityARAmbient.cs" "private bool IsRenderableAmbientIntensity (float ambientIntensity)" \
  "UnityARAmbient must isolate AR ambient intensity value validation."
require_contains "Assets/UnityARAmbient.cs" "float.IsNaN (ambientIntensity)" \
  "UnityARAmbient must reject NaN AR ambient intensity values."
require_contains "Assets/UnityARAmbient.cs" "float.IsInfinity (ambientIntensity)" \
  "UnityARAmbient must reject infinite AR ambient intensity values."
require_contains "Assets/UnityARAmbient.cs" "ambientIntensity < 0.0f" \
  "UnityARAmbient must reject negative AR ambient intensity values."
require_contains "Assets/UnityARAmbient.cs" "private const float MaxRenderableAmbientIntensity = 8000.0f;" \
  "UnityARAmbient must keep the Unity over-bright ambient intensity bound explicit."
require_contains "Assets/UnityARAmbient.cs" "ambientIntensity > MaxRenderableAmbientIntensity" \
  "UnityARAmbient must reject AR ambient intensity values above the Unity over-bright range."
require_contains "Assets/UnityARAmbient.cs" "if (!IsRenderableAmbientIntensity (newai))" \
  "UnityARAmbient must guard intensity writes with value validation."
require_contains "Assets/UnityARAmbient.cs" "l.intensity = newai / 1000.0f;" \
  "UnityARAmbient must keep the ARKit-to-Unity intensity conversion."
require_contains "Assets/SodaSpawn.cs" "public int maxSodas = 1000;" \
  "SodaSpawn must keep the explicit 1000 object cap."
require_contains "Assets/SodaSpawn.cs" "[Range (1, 1000)]" \
  "SodaSpawn maxSodas must expose the original cap as a Unity inspector range."
require_contains "Assets/SodaSpawn.cs" "private const int DefaultMaxSodas = 1000;" \
  "SodaSpawn must keep the default cap available for inspector-value repair."
require_contains "Assets/SodaSpawn.cs" "maxSodas < 1 || maxSodas > DefaultMaxSodas" \
  "SodaSpawn must repair invalid maxSodas inspector values above or below the original cap."
require_contains "Assets/SodaSpawn.cs" "private void RepairMaxSodas ()" \
  "SodaSpawn must keep cap repair in a reusable helper."
require_contains "Assets/SodaSpawn.cs" "void OnValidate ()" \
  "SodaSpawn must repair invalid caps during Unity inspector validation."
require_contains "Assets/SodaSpawn.cs" "if (sodaObject == null)" \
  "SodaSpawn must not instantiate when the prefab reference is missing."
require_contains "Assets/SodaSpawn.cs" "soda.GetComponent<Rigidbody> () == null" \
  "SodaSpawn must avoid adding duplicate Rigidbody components."
require_contains "Assets/SodaSpawn.cs" "sodas.Clear ();" \
  "SodaSpawn must clear tracked object references after cleanup."
require_contains "Assets/SodaSpawn.cs" "private void PruneMissingSodas ()" \
  "SodaSpawn must keep missing spawned-object pruning in a reusable helper."
require_contains "Assets/SodaSpawn.cs" "for (int i = sodas.Count - 1; i >= 0; i--)" \
  "SodaSpawn must prune missing spawned-object references safely from the end of the list."
require_contains "Assets/SodaSpawn.cs" "sodas.RemoveAt (i);" \
  "SodaSpawn must remove missing spawned-object references from the tracked list."
require_contains "Assets/SodaSpawn.cs" "PruneMissingSodas ();" \
  "SodaSpawn must prune missing spawned-object references before cap enforcement."
require_contains "Assets/SodaSpawn.cs" "private void TrimSodasToLimit ()" \
  "SodaSpawn must keep cap eviction in a reusable helper."
require_contains "Assets/SodaSpawn.cs" "while (sodas.Count > maxSodas)" \
  "SodaSpawn must evict only when the live count exceeds the configured cap."
require_contains "Assets/SodaSpawn.cs" "GameObject oldestSoda = sodas [0];" \
  "SodaSpawn must evict the oldest tracked can first."
require_contains "Assets/SodaSpawn.cs" "sodas.RemoveAt (0);" \
  "SodaSpawn must remove evicted cans from the tracked list."
require_contains "Assets/SodaSpawn.cs" "TrimSodasToLimit ();" \
  "SodaSpawn must enforce the live-object cap after each spawn."
require_contains "Assets/SodaSpawn.cs" "void OnDisable ()" \
  "SodaSpawn must clean up spawned cans when disabled."
require_contains "Assets/SodaSpawn.cs" "ClearSodas ();" \
  "SodaSpawn disable cleanup must reuse the tracked cleanup path."

for cadence_contract in \
  "private const float DefaultSpawnIntervalSeconds = 0.1f;" \
  "private const float MinSpawnIntervalSeconds = 0.05f;" \
  "private const float MaxSpawnIntervalSeconds = 5.0f;" \
  "[Range (MinSpawnIntervalSeconds, MaxSpawnIntervalSeconds)]" \
  "public float spawnIntervalSeconds = DefaultSpawnIntervalSeconds;" \
  "private void RepairSpawnInterval ()" \
  "float.IsNaN (spawnIntervalSeconds)" \
  "float.IsInfinity (spawnIntervalSeconds)" \
  "spawnIntervalSeconds < MinSpawnIntervalSeconds" \
  "spawnIntervalSeconds > MaxSpawnIntervalSeconds"; do
  require_contains "Assets/SodaSpawn.cs" "$cadence_contract" \
    "SodaSpawn must keep the bounded spawn cadence contract: $cadence_contract"
done

on_enable_body=$(sed -n '/void OnEnable ()/,/^\t}/p' "$SODA_SPAWN")
if ! printf '%s\n' "$on_enable_body" | grep -Fq "RepairSpawnInterval ();" || \
   ! printf '%s\n' "$on_enable_body" | grep -Fq "nextSpawnTime = Time.time;"; then
  printf '%s\n' "SodaSpawn must repair cadence and allow an immediate first spawn when enabled." >&2
  exit 1
fi

update_body=$(sed -n '/void Update ()/,/^\t}/p' "$SODA_SPAWN")
for update_contract in \
  "RepairSpawnInterval ();" \
  "float currentTime = Time.time;" \
  "if (currentTime < nextSpawnTime)" \
  "nextSpawnTime = currentTime + spawnIntervalSeconds;" \
  "Instantiate (sodaObject"; do
  if ! printf '%s\n' "$update_body" | grep -Fq "$update_contract"; then
    printf '%s\n' "SodaSpawn update is missing cadence contract: $update_contract" >&2
    exit 1
  fi
done

cadence_gate_line=$(grep -nF "if (currentTime < nextSpawnTime)" "$SODA_SPAWN" | cut -d: -f1)
cadence_schedule_line=$(grep -nF "nextSpawnTime = currentTime + spawnIntervalSeconds;" "$SODA_SPAWN" | cut -d: -f1)
spawn_line=$(grep -nF "Instantiate (sodaObject" "$SODA_SPAWN" | cut -d: -f1)
if [ -z "$cadence_gate_line" ] || [ -z "$cadence_schedule_line" ] || [ -z "$spawn_line" ] || \
   [ "$cadence_gate_line" -ge "$cadence_schedule_line" ] || \
   [ "$cadence_schedule_line" -ge "$spawn_line" ]; then
  printf '%s\n' "SodaSpawn must gate and schedule the next interval before instantiation." >&2
  exit 1
fi

if ! grep -Fq "0.1-second default cadence" "$README" || \
   ! grep -Fq "2026-06-13-unity-sodaspawn-cadence.md" "$README"; then
  printf '%s\n' "README must document the bounded SodaSpawn cadence and plan." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ROOT_DIR/$SPAWN_CADENCE_PLAN" || \
   ! grep -Fq "## Status: Completed" "$ROOT_DIR/$SPAWN_CADENCE_PLAN" || \
   ! grep -Fq "make check" "$ROOT_DIR/$SPAWN_CADENCE_PLAN" || \
   ! grep -Fq "Ten isolated hostile mutations were rejected" "$ROOT_DIR/$SPAWN_CADENCE_PLAN" || \
   ! grep -Fq "no claim is made for editor, Xcode export, or ARKit device execution" "$ROOT_DIR/$SPAWN_CADENCE_PLAN"; then
  printf '%s\n' "SodaSpawn cadence plan must record completed status and limited verification." >&2
  exit 1
fi

if grep -Fq "if (sodas.Count >= maxSodas)" "$ROOT_DIR/Assets/SodaSpawn.cs"; then
  printf '%s\n' "SodaSpawn must not clear every live can when the cap is reached." >&2
  exit 1
fi
require_contains "Assets/ParticlePainter.cs" "if (painterParticlePrefab == null)" \
  "ParticlePainter must reject a missing particle prefab before initialization."
require_contains "Assets/ParticlePainter.cs" "if (colorPicker == null)" \
  "ParticlePainter must reject a missing color picker before initialization."
require_contains "Assets/ParticlePainter.cs" "private void SubscribeToEvents ()" \
  "ParticlePainter must keep event registration in a reusable helper."
require_contains "Assets/ParticlePainter.cs" "private void UnsubscribeFromEvents ()" \
  "ParticlePainter must keep event teardown in a reusable helper."
require_contains "Assets/ParticlePainter.cs" "UnityARSessionNativeInterface.ARFrameUpdatedEvent -= ARFrameUpdated;" \
  "ParticlePainter must unsubscribe from global AR frame updates."
require_contains "Assets/ParticlePainter.cs" "colorPicker.onValueChanged.RemoveListener (HandleColorChanged);" \
  "ParticlePainter must remove its color picker listener during teardown."
require_contains "Assets/ParticlePainter.cs" "if (!isInitialized || currentPaintVertices == null)" \
  "ParticlePainter must ignore AR callbacks before successful initialization."
require_contains "Assets/ParticlePainter.cs" "if (mainCamera == null)" \
  "ParticlePainter must tolerate a missing tagged main camera."
require_contains "Assets/ParticlePainter.cs" "DefaultMinDistanceThreshold = 0.05f" \
  "ParticlePainter must preserve the scene's default minimum sample distance."
require_contains "Assets/ParticlePainter.cs" "DefaultMaxDistanceThreshold = 1.0f" \
  "ParticlePainter must preserve the scene's default maximum sample distance."
require_contains "Assets/ParticlePainter.cs" "private void RepairDistanceThresholds ()" \
  "ParticlePainter must centralize distance-threshold repair."
require_contains "Assets/ParticlePainter.cs" "float.IsNaN (value)" \
  "ParticlePainter must reject NaN distance thresholds."
require_contains "Assets/ParticlePainter.cs" "float.IsInfinity (value)" \
  "ParticlePainter must reject infinite distance thresholds."
require_contains "Assets/ParticlePainter.cs" "maxDistanceThreshold <= minDistanceThreshold" \
  "ParticlePainter must repair inverted distance thresholds."
require_contains "Assets/ParticlePainter.cs" "void OnValidate ()" \
  "ParticlePainter must repair distance thresholds during editor validation."
require_contains "Assets/ParticlePainter.cs" "private bool hasPreviousPosition = false;" \
  "ParticlePainter must track whether the first AR position has been anchored."
require_contains "Assets/ParticlePainter.cs" "if (!hasPreviousPosition)" \
  "ParticlePainter must anchor the first valid AR frame without painting."
require_contains "Assets/ParticlePainter.cs" "if (distance < minDistanceThreshold)" \
  "ParticlePainter must ignore movement below the minimum sample distance."
require_contains "Assets/ParticlePainter.cs" "if (distance > maxDistanceThreshold)" \
  "ParticlePainter must reject tracking jumps above the maximum sample distance."
require_contains "Assets/ParticlePainter.cs" "previousPosition = currentPosition;" \
  "ParticlePainter must advance its anchor for accepted samples and tracking jumps."
require_contains "Assets/ParticlePainter.cs" "private const int DefaultMaxPaintVertices = 10000;" \
  "ParticlePainter must keep a bounded default sample count per stroke."
require_contains "Assets/ParticlePainter.cs" "[Range (1, DefaultMaxPaintVertices)]" \
  "ParticlePainter must expose the bounded stroke sample count in the inspector."
require_contains "Assets/ParticlePainter.cs" "maxPaintVertices < 1 || maxPaintVertices > DefaultMaxPaintVertices" \
  "ParticlePainter must repair unsafe stroke sample limits."
require_contains "Assets/ParticlePainter.cs" "private void EnsureParticleBuffer ()" \
  "ParticlePainter must centralize reusable particle-buffer allocation."
require_contains "Assets/ParticlePainter.cs" "particles == null || particles.Length != maxPaintVertices" \
  "ParticlePainter must resize the reusable buffer when the repaired limit changes."
require_contains "Assets/ParticlePainter.cs" "particles = new ParticleSystem.Particle[maxPaintVertices];" \
  "ParticlePainter must allocate its buffer from the repaired stroke limit."
require_contains "Assets/ParticlePainter.cs" "private void TrimCurrentPaintVerticesToLimit ()" \
  "ParticlePainter must safely trim a stroke when its runtime limit is lowered."
require_contains "Assets/ParticlePainter.cs" "currentPaintVertices.Count < maxPaintVertices" \
  "ParticlePainter must stop retaining samples at the repaired per-stroke limit."
require_contains "Assets/ParticlePainter.cs" "currentPS.SetParticles (particles, numParticles);" \
  "ParticlePainter must submit only the populated prefix of the reusable buffer."
require_contains "Assets/ParticlePainter.cs" "private const int DefaultMaxPaintSystems = 32;" \
  "ParticlePainter must keep a bounded default total paint-system count."
require_contains "Assets/ParticlePainter.cs" "[Range (1, DefaultMaxPaintSystems)]" \
  "ParticlePainter must expose the total paint-system bound in the inspector."
require_contains "Assets/ParticlePainter.cs" "maxPaintSystems < 1 || maxPaintSystems > DefaultMaxPaintSystems" \
  "ParticlePainter must repair unsafe paint-system limits."
require_contains "Assets/ParticlePainter.cs" "while (paintSystems.Count >= maxPaintSystems)" \
  "ParticlePainter must reserve one bounded slot for the active paint system."
require_contains "Assets/ParticlePainter.cs" "ParticleSystem oldestPaintSystem = paintSystems [0];" \
  "ParticlePainter must evict completed paint systems oldest first."
require_contains "Assets/ParticlePainter.cs" "Destroy (oldestPaintSystem.gameObject);" \
  "ParticlePainter must destroy evicted paint-system objects."
require_contains "Assets/ParticlePainter.cs" "private void ClearPaintSystems ()" \
  "ParticlePainter must centralize owned-system destruction."
require_contains "Assets/ParticlePainter.cs" "Destroy (currentPS.gameObject);" \
  "ParticlePainter must destroy its active system during teardown."
if [ "$(grep -Fc "RepairMaxPaintSystems ();" "$PARTICLE_PAINTER")" -ne 4 ] || \
   [ "$(grep -Fc "TrimPaintSystemsToLimit ();" "$PARTICLE_PAINTER")" -ne 2 ]; then
  printf '%s\n' "ParticlePainter must repair at validation/start/restart/update and trim at restart/update." >&2
  exit 1
fi

particle_on_validate_body=$(sed -n '/void OnValidate ()/,/^    }/p' "$PARTICLE_PAINTER")
if ! printf '%s\n' "$particle_on_validate_body" | grep -Fq "RepairMaxPaintVertices ();"; then
  printf '%s\n' "ParticlePainter must repair its stroke sample limit during editor validation." >&2
  exit 1
fi

particle_start_body=$(sed -n '/void Start ()/,/^	}/p' "$PARTICLE_PAINTER")
for start_contract in "RepairMaxPaintVertices ();" "EnsureParticleBuffer ();"; do
  if ! printf '%s\n' "$particle_start_body" | grep -Fq "$start_contract"; then
    printf '%s\n' "ParticlePainter startup must initialize its bounded buffer: $start_contract" >&2
    exit 1
  fi
done

particle_frame_body=$(sed -n '/public void ARFrameUpdated/,/^    }/p' "$PARTICLE_PAINTER")
if ! printf '%s\n' "$particle_frame_body" | grep -Fq "currentPaintVertices.Count < maxPaintVertices"; then
  printf '%s\n' "ParticlePainter AR sampling must enforce the per-stroke sample limit." >&2
  exit 1
fi

particle_restart_body=$(sed -n '/void RestartPainting()/,/^    }/p' "$PARTICLE_PAINTER")
if ! printf '%s\n' "$particle_restart_body" | grep -Fq "EnsureParticleBuffer ();"; then
  printf '%s\n' "ParticlePainter must initialize the reusable buffer for each active stroke." >&2
  exit 1
fi
restart_add_line=$(printf '%s\n' "$particle_restart_body" | grep -nF "paintSystems.Add (currentPS);" | cut -d: -f1)
restart_trim_line=$(printf '%s\n' "$particle_restart_body" | grep -nF "TrimPaintSystemsToLimit ();" | cut -d: -f1)
restart_create_line=$(printf '%s\n' "$particle_restart_body" | grep -nF "currentPS = Instantiate (painterParticlePrefab);" | cut -d: -f1)
if [ -z "$restart_add_line" ] || [ -z "$restart_trim_line" ] || \
   [ -z "$restart_create_line" ] || [ "$restart_add_line" -ge "$restart_trim_line" ] || \
   [ "$restart_trim_line" -ge "$restart_create_line" ]; then
  printf '%s\n' "ParticlePainter must retain, trim, then create each replacement stroke in order." >&2
  exit 1
fi

particle_destroy_body=$(sed -n '/void OnDestroy ()/,/^    }/p' "$PARTICLE_PAINTER")
if ! printf '%s\n' "$particle_destroy_body" | grep -Fq "UnsubscribeFromEvents ();" || \
   ! printf '%s\n' "$particle_destroy_body" | grep -Fq "ClearPaintSystems ();"; then
  printf '%s\n' "ParticlePainter destruction must release events and all owned systems." >&2
  exit 1
fi

particle_update_body=$(sed -n '/void Update ()/,/^	}/p' "$PARTICLE_PAINTER")
for update_contract in \
  "RepairMaxPaintVertices ();" \
  "TrimCurrentPaintVerticesToLimit ();" \
  "EnsureParticleBuffer ();" \
  "currentPS.SetParticles (particles, numParticles);"; do
  if ! printf '%s\n' "$particle_update_body" | grep -Fq "$update_contract"; then
    printf '%s\n' "ParticlePainter update must maintain its bounded reusable buffer: $update_contract" >&2
    exit 1
  fi
done

if grep -Fq "new ParticleSystem.Particle[numParticles]" "$ROOT_DIR/Assets/ParticlePainter.cs"; then
  printf '%s\n' "ParticlePainter must not allocate a full stroke buffer on every update." >&2
  exit 1
fi

if grep -Fq "newColor =>" "$ROOT_DIR/Assets/ParticlePainter.cs"; then
  printf '%s\n' "ParticlePainter must use a removable named color listener." >&2
  exit 1
fi
require_contains ".gitignore" "/[Ll]ibrary/" "Unity Library directory must stay ignored."
require_contains ".gitignore" "/[Tt]emp/" "Unity Temp directory must stay ignored."
require_contains ".gitignore" "/[Oo]bj/" "Unity Obj directory must stay ignored."
require_contains ".gitignore" "/[Bb]uild/" "Unity Build directory must stay ignored."
require_contains ".gitignore" "/[Bb]uilds/" "Unity Builds directory must stay ignored."
require_contains "README.md" "Unity editor version: 5.6.1p1" \
  "README must document the Unity editor version."
require_contains "README.md" "scripts/check-baseline.sh" \
  "README must document the baseline check."
require_contains "README.md" "make check" \
  "README must document the make check wrapper."
require_contains "README.md" "GitHub Actions" \
  "README must document the GitHub Actions check."
require_contains "README.md" "make lint" \
  "README must document the lint gate."
require_contains "README.md" "make test" \
  "README must document the test gate."
require_contains "README.md" "make build" \
  "README must document the build gate."
require_contains "README.md" "keeps the original 1000-can cleanup cap explicit" \
  "README must document the SodaSpawn safety baseline."
require_contains "README.md" "repairs invalid spawn caps" \
  "README must document the SodaSpawn inspector-value guard."
require_contains "README.md" "bounds spawn caps to the original 1000-can limit" \
  "README must document the SodaSpawn upper-cap guard."
require_contains "README.md" "runtime cap repair" \
  "README must document the SodaSpawn runtime cap repair."
require_contains "README.md" "prunes missing spawned-can references" \
  "README must document the SodaSpawn missing-reference pruning guard."
require_contains "README.md" "cleans up tracked cans when the spawner is disabled" \
  "README must document the SodaSpawn disable cleanup."
require_contains "README.md" "guards AR ambient light updates" \
  "README must document the UnityARAmbient null guard."
require_contains "README.md" "refreshes missing AR ambient light dependencies" \
  "README must document the UnityARAmbient dependency refresh guard."
require_contains "README.md" "rejects non-finite or negative AR ambient intensity values" \
  "README must document the UnityARAmbient value guard."
require_contains "README.md" "over-bright range before writing" \
  "README must document the UnityARAmbient upper-bound guard."
require_contains "README.md" "unsubscribes from AR frame and color-picker events" \
  "README must document the ParticlePainter lifecycle guard."
require_contains "README.md" "bounding paint samples to the configured movement window" \
  "README must document the ParticlePainter distance window."
require_contains "README.md" "bounds each paint stroke to 10,000 retained samples" \
  "README must document the ParticlePainter stroke sample bound."
require_contains "README.md" "reuses one particle buffer per active stroke" \
  "README must document ParticlePainter buffer reuse."
require_contains "CHANGES.md" "SodaSpawn.OnDisable" \
  "CHANGES must document the SodaSpawn disable cleanup."
require_contains "CHANGES.md" "SodaSpawn.maxSodas" \
  "CHANGES must document the SodaSpawn runtime cap repair."
require_contains "CHANGES.md" "above the original 1000-can cap" \
  "CHANGES must document the SodaSpawn upper-cap repair."
require_contains "CHANGES.md" "missing spawned-can references" \
  "CHANGES must document the SodaSpawn missing-reference pruning guard."
require_contains "CHANGES.md" "oldest tracked can" \
  "CHANGES must document SodaSpawn oldest-first cap eviction."
require_contains "CHANGES.md" "UnityARAmbient" \
  "CHANGES must document the UnityARAmbient null guard."
require_contains "CHANGES.md" "ambient light dependency lookup" \
  "CHANGES must document the UnityARAmbient dependency refresh guard."
require_contains "CHANGES.md" "non-finite or negative AR ambient intensity" \
  "CHANGES must document the UnityARAmbient value guard."
require_contains "CHANGES.md" "over-bright light range" \
  "CHANGES must document the UnityARAmbient upper-bound guard."
require_contains "CHANGES.md" "ParticlePainter" \
  "CHANGES must document the ParticlePainter lifecycle guard."
require_contains "CHANGES.md" "10,000 retained samples per stroke" \
  "CHANGES must record the ParticlePainter stroke sample bound."
require_contains ".github/workflows/check.yml" "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" \
  "CI workflow must pin actions/checkout to the reviewed commit."
require_contains ".github/workflows/check.yml" "persist-credentials: false" \
  "CI checkout must not persist repository credentials."
require_contains ".github/workflows/check.yml" "permissions:" \
  "CI workflow must declare token permissions."
require_contains ".github/workflows/check.yml" "contents: read" \
  "CI workflow must keep repository access read-only."
require_contains ".github/workflows/check.yml" "workflow_dispatch:" \
  "CI workflow must support manual verification."
require_contains ".github/workflows/check.yml" "timeout-minutes: 5" \
  "CI workflow must bound the baseline runtime."
require_contains ".github/workflows/check.yml" "runs-on: ubuntu-24.04" \
  "CI workflow must use a stable hosted runner image."
require_contains ".github/workflows/check.yml" "cancel-in-progress: true" \
  "CI workflow must cancel superseded runs."
require_contains ".github/workflows/check.yml" "make check" \
  "CI workflow must run make check."

if find "$ROOT_DIR/.github/workflows" -type f \( -name '*codeql*.yml' -o -name '*codeql*.yaml' \) -print -quit | grep -q .; then
  printf '%s\n' "GitHub default CodeQL setup must not be duplicated by an advanced workflow." >&2
  exit 1
fi

workflow_paths=$(find "$ROOT_DIR/.github/workflows" -type f \( -name '*.yml' -o -name '*.yaml' \) -print | LC_ALL=C sort)
if [ "$workflow_paths" != "$CHECK_WORKFLOW" ]; then
  printf '%s\n' "Only the canonical Check workflow is allowed." >&2
  exit 1
fi

if grep -E '^[[:space:]]*(-[[:space:]]+)?uses:' "$CHECK_WORKFLOW" | \
   grep -Ev '@[0-9a-f]{40}([[:space:]]+#.*)?$' >/dev/null; then
  printf '%s\n' "GitHub Actions must use immutable commit SHAs." >&2
  exit 1
fi

require_contains "$CODEQL_PLAN" "status: completed" \
  "CodeQL plan must record completed status."
require_contains "$CODEQL_PLAN" "make check" \
  "CodeQL plan must record make check verification."
require_contains "$CODEQL_PLAN" "external working directory" \
  "CodeQL plan must record location-independent verification."
require_contains "$CODEQL_PLAN" "hostile mutations rejected" \
  "CodeQL plan must record negative contract verification."
require_contains "$CODEQL_PLAN" "default setup" \
  "CodeQL plan must document the external configuration authority."
require_contains "$CODEQL_PLAN" "Objective-C++ bridge" \
  "CodeQL plan must record the uncovered native bridge risk."
require_contains "README.md" "CodeQL default setup analyzes" \
  "README must document CodeQL coverage."
require_contains "SECURITY.md" "CodeQL default-setup results" \
  "SECURITY must document CodeQL triage."
require_contains "VISION.md" "CodeQL default-setup coverage" \
  "VISION must preserve CodeQL coverage."
require_contains "CHANGES.md" "CodeQL default setup" \
  "CHANGES must record CodeQL analysis."
require_contains "$RUNTIME_CAP_PLAN" "Status: Completed" \
  "Runtime cap repair plan must record completed status."
require_contains "$RUNTIME_CAP_PLAN" "make check" \
  "Runtime cap repair plan must record make check verification."
require_contains "$UPPER_CAP_PLAN" "Status: Completed" \
  "Upper cap repair plan must record completed status."
require_contains "$UPPER_CAP_PLAN" "make check" \
  "Upper cap repair plan must record make check verification."
require_contains "$MISSING_REFERENCE_PLAN" "Status: Completed" \
  "Missing-reference pruning plan must record completed status."
require_contains "$MISSING_REFERENCE_PLAN" "make check" \
  "Missing-reference pruning plan must record make check verification."
require_contains "$AMBIENT_GUARD_PLAN" "Status: Completed" \
  "Ambient light null guard plan must record completed status."
require_contains "$AMBIENT_GUARD_PLAN" "make check" \
  "Ambient light null guard plan must record make check verification."
require_contains "$AMBIENT_DEPENDENCY_PLAN" "Status: Completed" \
  "Ambient light dependency refresh plan must record completed status."
require_contains "$AMBIENT_DEPENDENCY_PLAN" "make check" \
  "Ambient light dependency refresh plan must record make check verification."
require_contains "$AMBIENT_VALUE_PLAN" "Status: Completed" \
  "Ambient light value guard plan must record completed status."
require_contains "$AMBIENT_VALUE_PLAN" "make check" \
  "Ambient light value guard plan must record make check verification."
require_contains "$AMBIENT_UPPER_PLAN" "Status: Completed" \
  "Ambient intensity upper-bound plan must record completed status."
require_contains "$AMBIENT_UPPER_PLAN" "make check" \
  "Ambient intensity upper-bound plan must record make check verification."
require_contains "$CI_PLAN" "Status: Completed" \
  "CI baseline plan must record completed status."
require_contains "$CI_PLAN" "make check" \
  "CI baseline plan must record make check verification."
require_contains "$PARTICLE_PAINTER_PLAN" "Status: Completed" \
  "ParticlePainter lifecycle plan must record completed status."
require_contains "$PARTICLE_PAINTER_PLAN" "make check" \
  "ParticlePainter lifecycle plan must record make check verification."
require_contains "$PARTICLE_DISTANCE_PLAN" "Status: Completed" \
  "ParticlePainter distance plan must record completed status."
require_contains "$PARTICLE_DISTANCE_PLAN" "make check" \
  "ParticlePainter distance plan must record make check verification."
require_contains "$PARTICLE_BUFFER_PLAN" "Status: Completed" \
  "ParticlePainter buffer plan must record completed status."
require_contains "$PARTICLE_BUFFER_PLAN" "make check" \
  "ParticlePainter buffer plan must record make check verification."
require_contains "$PARTICLE_BUFFER_PLAN" "isolated hostile mutations were rejected" \
  "ParticlePainter buffer plan must record negative contract verification."
require_contains "$PARTICLE_BUFFER_PLAN" "no claim is made for editor, Xcode export, or ARKit device execution" \
  "ParticlePainter buffer plan must record limited runtime verification."
require_contains "$PARTICLE_SYSTEM_PLAN" "Status: Completed" \
  "ParticlePainter system-bound plan must record completed status."
require_contains "$PARTICLE_SYSTEM_PLAN" "make check" \
  "ParticlePainter system-bound plan must record make check verification."
require_contains "$PARTICLE_SYSTEM_PLAN" "hostile mutations" \
  "ParticlePainter system-bound plan must record negative contract verification."

for painter_system_doc in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  require_contains "$painter_system_doc" \
    "ParticlePainter caps active and completed paint systems and releases owned systems on destruction." \
    "$painter_system_doc must document the total paint-system ownership bound."
done

require_file "Makefile"
require_contains "Makefile" 'ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))' \
  "Makefile must resolve repository-root commands from its own location."
require_contains "Makefile" '$(ROOT)scripts/check-baseline.sh' \
  "Makefile must run the SDK-free baseline check."
require_contains "Makefile" "lint:" \
  "Makefile must expose a lint gate."
require_contains "Makefile" "test:" \
  "Makefile must expose a test gate."
require_contains "Makefile" "build:" \
  "Makefile must expose a build gate."
require_contains "Makefile" "verify: lint test build" \
  "Makefile must expose a combined verify gate."
require_contains "$MAKE_GATE_PLAN" "Status: Completed" \
  "Make gate plan must record completed status."
require_contains "$MAKE_GATE_PLAN" "make check" \
  "Make gate plan must record make check verification."

if [ -d "$ROOT_DIR/Library" ] || [ -d "$ROOT_DIR/Temp" ] || [ -d "$ROOT_DIR/Obj" ]; then
  printf '%s\n' "Generated Unity directories must not be present in the repository root." >&2
  exit 1
fi

printf '%s\n' "Unity ARKit scene baseline checks passed."
