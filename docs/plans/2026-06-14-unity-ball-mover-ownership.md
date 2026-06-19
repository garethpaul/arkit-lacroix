# Unity BallMover Ownership Cleanup

Status: Completed

## Problem

The checked-in `UnityARBallz` example tracks one movable physics object, but a
new touch overwrites that reference without releasing the prior object and
component disablement performs no cleanup. Repeated or interrupted gestures can
therefore leave untracked scene objects behind, while a missing prefab can still
reach `Instantiate`.

## Requirements

1. Return before instantiation when the movable-ball prefab is missing.
2. Release any previously tracked object before creating its replacement.
3. Reuse one cleanup helper for replacement, touch completion, and component
   disablement.
4. Clear the tracked reference immediately after scheduling destruction.
5. Preserve touch phases, AR plane hit testing, movement speed, prefab,
   physics, scene serialization, and public component fields.
6. Add mutation-sensitive source, documentation, and completed-plan contracts.

## Implementation Units

### U1: Centralize BallMover Ownership

**File:** `Assets/Examples/BallMover.cs`

Guard the prefab, clear prior ownership before replacement, and use the same
cleanup helper for gesture completion and disable-time teardown.

### U2: Protect Ordering And Cleanup

**File:** `scripts/check-baseline.sh`

Require guard-before-clear-before-instantiate ordering, singular cleanup
ownership, all three helper call sites, documentation, and completed evidence.

### U3: Document Verification

**Files:** `AGENTS.md`, `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`,
this plan

Record the object ownership boundary and truthful portable verification.

## Scope Boundaries

- Do not change touch gestures, hit-test mode, movement, materials, physics,
  scene files, metadata GUIDs, Unity version, dependencies, or UI.
- Do not claim Unity editor, iOS export, simulator, physical-device, ARKit, or
  gesture runtime verification.
- Do not merge or close stacked pull requests without explicit authorization.

## Verification

- Root and external-directory `make check` passed the complete source, scene,
  workflow, documentation, and plan contract gate; Unity 5.6.1p1 and an iOS
  export host remain unavailable.
- Eight hostile mutations were rejected for missing prefab guard, missing or
  late replacement cleanup, missing disable cleanup, direct gesture teardown,
  retained destroyed references, reopened plan status, and removed
  documentation.
- Final verification covered exact diff, shell syntax, scene/meta preservation,
  whitespace, conflict markers, credential-shaped additions, and generated
  artifacts.
- No claim is made for Unity editor, Xcode export, simulator, physical-device,
  ARKit, physics, or gesture runtime execution.
