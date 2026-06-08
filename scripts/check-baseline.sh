#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PROJECT_VERSION="$ROOT_DIR/ProjectSettings/ProjectVersion.txt"
BUILD_SETTINGS="$ROOT_DIR/ProjectSettings/EditorBuildSettings.asset"
GAME_SCENE="$ROOT_DIR/Assets/GameScene.unity"
README="$ROOT_DIR/README.md"

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
  "CHANGES.md" \
  "docs/plans/2026-06-08-unity-arkit-scene-baseline.md" \
  "ProjectSettings/ProjectVersion.txt" \
  "ProjectSettings/EditorBuildSettings.asset" \
  "Assets/GameScene.unity" \
  "Assets/GameScene.unity.meta" \
  "Assets/SodaSpawn.cs" \
  "Assets/SodaSpawn.cs.meta" \
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
require_contains "Assets/Models/LaCroix.prefab.meta" "guid: 58d1050948cdd4bfeb2ee58ee3093988" \
  "LaCroix prefab GUID must remain stable for scene references."
require_contains "Assets/GameScene.unity" "guid: 5699d7c94266d45358e93a1669d14431" \
  "GameScene must reference SodaSpawn."
require_contains "Assets/GameScene.unity" "guid: 58d1050948cdd4bfeb2ee58ee3093988" \
  "GameScene must reference the LaCroix prefab."
require_contains "Assets/SodaSpawn.cs" "public int maxSodas = 1000;" \
  "SodaSpawn must keep the explicit 1000 object cap."
require_contains "Assets/SodaSpawn.cs" "if (sodaObject == null)" \
  "SodaSpawn must not instantiate when the prefab reference is missing."
require_contains "Assets/SodaSpawn.cs" "sodas.Clear ();" \
  "SodaSpawn must clear tracked object references after cleanup."
require_contains ".gitignore" "/[Ll]ibrary/" "Unity Library directory must stay ignored."
require_contains ".gitignore" "/[Tt]emp/" "Unity Temp directory must stay ignored."
require_contains ".gitignore" "/[Oo]bj/" "Unity Obj directory must stay ignored."
require_contains ".gitignore" "/[Bb]uild/" "Unity Build directory must stay ignored."
require_contains ".gitignore" "/[Bb]uilds/" "Unity Builds directory must stay ignored."
require_contains "README.md" "Unity editor version: 5.6.1p1" \
  "README must document the Unity editor version."
require_contains "README.md" "scripts/check-baseline.sh" \
  "README must document the baseline check."
require_contains "README.md" "keeps the original 1000-can cleanup cap explicit" \
  "README must document the SodaSpawn safety baseline."

if [ -d "$ROOT_DIR/Library" ] || [ -d "$ROOT_DIR/Temp" ] || [ -d "$ROOT_DIR/Obj" ]; then
  printf '%s\n' "Generated Unity directories must not be present in the repository root." >&2
  exit 1
fi

printf '%s\n' "Unity ARKit scene baseline checks passed."
