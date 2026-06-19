# Unity Hit-Test Finite Coordinates

Status: Completed

## Problem

Point-cloud and ambient AR inputs reject non-finite values, but the ball
interaction examples still write AR hit-test coordinates directly into Unity
object transforms. A transient `NaN` or infinity can reach `Instantiate` or
`Vector3.MoveTowards`, contaminating spawned or moved object state. BallMaker's
height adjustment can also turn an otherwise finite hit into a non-finite final
spawn position.

## Priorities

1. Reject non-finite final spawn positions before creating balls.
2. Reject non-finite initial and moved target positions before mutating the
   tracked mover object.
3. Preserve touch phases, hit-test type/order, object ownership, scene assets,
   and legacy Unity compatibility.
4. Add mutation-sensitive source and completed-plan contracts.

## Requirements

- Validate all three `Vector3` coordinates with `float.IsNaN` and
  `float.IsInfinity` in both interaction components.
- `BallMaker.CreateBall` must reject the final adjusted position before prefab
  validation or instantiation.
- `BallMover.CreateMoveBall` must reject an invalid initial position before
  clearing its currently owned object or instantiating a replacement.
- The moved-touch path must reject an invalid target before
  `Vector3.MoveTowards` writes the transform.
- Preserve the first-valid-hit behavior and existing cleanup paths.
- Synchronize maintained guidance and completed verification evidence.

## Implementation Units

### 1. Guard ball creation

**File:** `Assets/Examples/BallMaker.cs`

Add a dependency-free finite-vector predicate and reject invalid final spawn
positions at the `CreateBall` ownership boundary.

### 2. Guard ball movement

**File:** `Assets/Examples/BallMover.cs`

Use the same legacy-compatible predicate before initial replacement and before
applying a moved target.

### 3. Enforce and document the boundary

**Files:** `scripts/check-baseline.sh`, `AGENTS.md`, `README.md`, `SECURITY.md`,
`VISION.md`, `CHANGES.md`, and this plan.

Require both predicates, guard ordering, movement protection, maintained
guidance, and completed-plan evidence.

## Verification

- Run repository-root and external-directory `make check`.
- Reject isolated BallMaker predicate/guard, BallMover predicate/create guard,
  moved-target guard, guidance, and reopened-plan mutations.
- Audit exact paths, generated artifacts, binary/scene/project/workflow drift,
  conflict markers, file modes, whitespace, and credential-shaped additions.

## Risks

- BallMover must not destroy a valid currently owned ball when a replacement
  hit is invalid; the guard therefore precedes `ClearMoveBall`.
- Source/static validation cannot reproduce an ARKit transform or render the
  scene; real tracking behavior remains in the device verification matrix.
- This PR is stacked on PR #15 and must retain base-first merge ordering.

## Out Of Scope

- Camera/session nullability, hit-test result ordering, touch UX, physics,
  object limits, materials, prefabs, scenes, packages, and project settings.
- Unity, Xcode, ARKit, SDK, dependency, or workflow upgrades.
- Editor, simulator, or physical-device execution.

## Completion Evidence

- Source inspection confirms both `IsFinitePosition` predicates validate XYZ
  with `float.IsNaN` and `float.IsInfinity` before transform mutation.
- BallMaker validates the final height-adjusted spawn vector before ownership;
  BallMover validates initial replacement before cleanup and moved targets
  before `Vector3.MoveTowards`.
- Repository-root and external-directory `make check` both passed the source,
  lifecycle, scene, project, workflow, and completed-plan contracts on June 16,
  2026; both truthfully reported that Unity 5.6.1p1 and the Unity/iOS build are
  unavailable.
- Eight isolated mutations cover both predicates and ownership guards, the
  adjusted-spawn and moved-target guards, maintained guidance, and reopened
  plan status.
