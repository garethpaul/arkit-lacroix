#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PROJECT_VERSION="$ROOT_DIR/ProjectSettings/ProjectVersion.txt"
BUILD_SETTINGS="$ROOT_DIR/ProjectSettings/EditorBuildSettings.asset"
GAME_SCENE="$ROOT_DIR/Assets/GameScene.unity"
README="$ROOT_DIR/README.md"
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
CODEQL_PLAN="docs/plans/2026-06-12-codeql-baseline.md"
CHECK_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
CODEQL_WORKFLOW="$ROOT_DIR/.github/workflows/codeql.yml"

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
  ".github/workflows/codeql.yml" \
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
  "$CODEQL_PLAN" \
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

workflow_paths=$(find "$ROOT_DIR/.github/workflows" -type f \( -name '*.yml' -o -name '*.yaml' \) -print | LC_ALL=C sort)
expected_workflow_paths=$(printf '%s\n' "$CHECK_WORKFLOW" "$CODEQL_WORKFLOW" | LC_ALL=C sort)
if [ "$workflow_paths" != "$expected_workflow_paths" ]; then
  printf '%s\n' "Only the canonical Check and CodeQL workflows are allowed." >&2
  exit 1
fi

if grep -E '^[[:space:]]*(-[[:space:]]+)?uses:' "$CHECK_WORKFLOW" "$CODEQL_WORKFLOW" | \
   grep -Ev '@[0-9a-f]{40}([[:space:]]+#.*)?$' >/dev/null; then
  printf '%s\n' "GitHub Actions must use immutable commit SHAs." >&2
  exit 1
fi

for codeql_contract in \
  "- master" \
  "pull_request:" \
  "schedule:" \
  "cron: '37 5 * * 2'" \
  "workflow_dispatch:" \
  "contents: read" \
  "security-events: write" \
  "cancel-in-progress: true" \
  "runs-on: ubuntu-24.04" \
  "timeout-minutes: 10" \
  "fail-fast: false" \
  "language: [actions, csharp, c-cpp]" \
  "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" \
  "persist-credentials: false" \
  "github/codeql-action/init@8aad20d150bbac5944a9f9d289da16a4b0d87c1e" \
  'languages: ${{ matrix.language }}' \
  "build-mode: none" \
  "github/codeql-action/analyze@8aad20d150bbac5944a9f9d289da16a4b0d87c1e"; do
  if ! grep -Fq -- "$codeql_contract" "$CODEQL_WORKFLOW"; then
    printf '%s\n' "CodeQL workflow must keep contract: $codeql_contract" >&2
    exit 1
  fi
done

codeql_permissions=$(awk '
  /^permissions:$/ { capture = 1; next }
  capture && /^  [a-z-]+:/ { print; next }
  capture { exit }
' "$CODEQL_WORKFLOW")
expected_codeql_permissions=$(printf '%s\n' '  contents: read' '  security-events: write')
if [ "$codeql_permissions" != "$expected_codeql_permissions" ] || \
   grep -Eq 'continue-on-error:[[:space:]]*true|if:[[:space:]]*false|run:' "$CODEQL_WORKFLOW"; then
  printf '%s\n' "CodeQL must keep exact permissions and the reviewed action-only pipeline." >&2
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
require_contains "README.md" "CodeQL analyzes" \
  "README must document CodeQL coverage."
require_contains "SECURITY.md" "CodeQL results" \
  "SECURITY must document CodeQL triage."
require_contains "VISION.md" "CodeQL coverage" \
  "VISION must preserve CodeQL coverage."
require_contains "CHANGES.md" "CodeQL analysis" \
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
