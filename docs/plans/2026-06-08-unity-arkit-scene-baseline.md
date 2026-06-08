---
title: Unity ARKit Scene Baseline
type: fix
status: completed
date: 2026-06-08
---

# Unity ARKit Scene Baseline

## Summary

Raise the baseline for the Unity ARKit LaCroix demo by correcting the active
build scene to the checked-in scene, documenting the legacy Unity toolchain, and
adding an SDK-free source/provenance check.

## Problem Frame

`ProjectSettings/EditorBuildSettings.asset` enabled `Assets/UnityARKitScene.unity`,
but that scene file is not present in the repository. The checked-in scene with
the same GUID is `Assets/GameScene.unity`, which references the AR camera manager,
`SodaSpawn`, and the LaCroix prefab. Unity is not installed on this host, so this
pass should not attempt to export an iOS project.

## Requirements

- R1. The active Unity build scene must point to an existing checked-in scene.
- R2. The Unity editor version and ARKit project shape must be documented.
- R3. The baseline check must verify the active scene, scene metadata, LaCroix
  prefab, spawn script, screenshot, and generated-directory ignore policy.
- R4. The pass must not modify generated Unity folders or asset binaries.
- R5. Full Unity/iOS export and device verification must remain follow-up work
  until Unity 5.6.1p1 is available.

## Key Technical Decisions

- **Correct the scene path only:** `Assets/GameScene.unity.meta` has the same
  GUID referenced by the build settings, so the issue is stale path metadata.
- **Use SDK-free checks:** Shell checks can guard the Unity project structure
  without requiring the Unity editor.
- **Avoid asset rewrites:** Opening or resaving this project in a newer Unity
  editor could rewrite many serialized assets, so this pass keeps asset edits
  limited to build settings and documentation.

## Scope Boundaries

- This pass does not upgrade Unity, ARKit bridge code, or iOS signing settings.
- This pass does not export or build an Xcode project.
- This pass does not change `SodaSpawn` behavior or LaCroix model assets.

## Verification

- `scripts/check-baseline.sh`
- `git diff --check`

## Sources / Research

- `ProjectSettings/ProjectVersion.txt` pins Unity `5.6.1p1`.
- `ProjectSettings/EditorBuildSettings.asset` referenced missing
  `Assets/UnityARKitScene.unity` before this baseline.
- `Assets/GameScene.unity.meta` has GUID `c159f2591a9b5c843b0a0442451f78f8`,
  matching the active scene entry.
- `Assets/GameScene.unity` references the `SodaSpawn` script and LaCroix prefab.
