---
title: Unity SodaSpawn Safety Baseline
type: fix
status: completed
date: 2026-06-08
---

# Unity SodaSpawn Safety Baseline

## Summary

Raise the runtime safety baseline for the LaCroix AR scene by making the soda
spawn cap explicit, avoiding prefab-null instantiation, and clearing tracked
object references after cleanup.

---

## Problem Frame

`SodaSpawn` instantiates a new soda object every frame and destroys all tracked
objects after reaching a hard-coded count of 1000. That behavior is central to
the raining-can demo, but the cap is hidden in method logic, a missing prefab
reference would throw every frame, and replacing the list after cleanup is less
explicit than clearing the tracked references.

Unity is not installed on this host, so verification must remain a source and
project-provenance check rather than an editor build.

---

## Requirements

- R1. Preserve the existing 1000 spawned-object cleanup threshold by default.
- R2. Avoid instantiating when `sodaObject` is not assigned.
- R3. Keep cleanup explicit and clear tracked references after destroying old cans.
- R4. Extend the SDK-free baseline check to guard the spawn safety behavior.
- R5. Do not rewrite Unity scene, prefab, model, or generated project assets.

---

## Key Technical Decisions

- **Use a public cap field:** `maxSodas` keeps the default behavior at 1000 while making the cap visible in the Unity inspector.
- **Return on missing prefab:** A null prefab reference should no-op instead of repeatedly throwing from `Instantiate`.
- **Clear the existing list:** `sodas.Clear()` preserves the list object and makes reference cleanup explicit.

---

## Scope Boundaries

- This pass does not change spawn cadence, physics behavior, can model assets, or scene references.
- This pass does not open or resave the project in Unity.
- This pass does not add Unity edit-mode or play-mode tests because Unity 5.6.1p1 is unavailable here.

---

## Verification

- `scripts/check-baseline.sh`
- `git diff --check`

---

## Sources / Research

- `Assets/SodaSpawn.cs` owns per-frame can instantiation and cleanup behavior.
- `Assets/GameScene.unity` references `SodaSpawn` and the LaCroix prefab by stable GUIDs.
- `ProjectSettings/ProjectVersion.txt` pins Unity `5.6.1p1`.
