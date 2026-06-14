# Unity Ball Maker Ownership Bound

Status: In Progress

## Problem

The checked-in `UnityARBallz` example scene references `BallMaker`, which
instantiates a new physics ball for every accepted touch hit but never retains
or releases ownership. Repeated interaction can therefore grow active physics
objects without a scene-local bound, and missing prefab configuration can
attempt invalid instantiation.

## Requirements

1. Retain every successfully created ball in creation order.
2. Cap retained balls at a repaired serialized limit with a conservative
   default and fixed upper bound.
3. Prune externally destroyed Unity objects before enforcing the cap.
4. Evict and destroy the oldest retained ball after successful creation when
   the limit is exceeded.
5. Release all retained balls when the component is disabled.
6. Return without instantiation when the prefab is missing and do not retain a
   failed instantiation result.
7. Preserve touch handling, AR plane hit testing, colors, physics behavior,
   script GUID, scene reference, Unity version, and all existing resource
   bounds.
8. Add mutation-sensitive source, scene, documentation, and completed-plan
   contracts.

## Implementation Units

### U1: Own And Bound Spawned Balls

**File:** `Assets/Examples/BallMaker.cs`

Add a bounded serialized count, retained creation-order list, configuration
repair, stale-reference pruning, oldest-first eviction, and disable cleanup.

### U2: Protect The Scene Contract

**File:** `scripts/check-baseline.sh`

Require the `UnityARBallz` scene and stable script GUID, then protect the
creation, ownership, pruning, eviction, cleanup, and plan-evidence ordering.

### U3: Document Verification

**Files:** `AGENTS.md`, `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`,
this plan

Document the example-scene ownership bound and record truthful portable
verification without claiming Unity or device execution.

## Scope Boundaries

- Do not change the active build scene, touch gestures, hit-test mode, ball
  prefab, materials, physics, ARKit plugin, Unity version, dependencies, or UI.
- Do not edit Unity scene serialization merely to introduce the new field;
  retain the source initializer and runtime repair as the backward-compatible
  default for the existing component.
- Do not claim Unity editor, iOS export, simulator, physical-device, ARKit, or
  long-duration interaction verification.
- Do not merge or close stacked pull requests without explicit authorization.

## Verification

- Pending implementation and bounded validation.
