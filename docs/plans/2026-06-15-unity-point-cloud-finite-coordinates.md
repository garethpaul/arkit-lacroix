# Unity Point Cloud Finite Coordinate Boundary

Status: Completed

## Problem

Both ARKit point-cloud examples copy native coordinates directly into Unity
particle or transform positions. A `NaN` or infinite coordinate can therefore
enter the renderer, producing undefined placement, unstable bounds, or a
persistently corrupted visual object.

## Priorities

1. Reject non-finite point-cloud coordinates before writing Unity positions.
2. Preserve all finite samples, point ordering, marker visibility, particle
   sizing, frame ownership, and lifecycle cleanup.
3. Add mutation-sensitive static contracts and portable documentation evidence
   without claiming Unity editor or device execution.

## Requirements

- Add dependency-free finite-coordinate predicates for the particle and marker
  renderers.
- Compact valid particle samples so rejected values do not create rendered
  gaps or consume the emitted particle count.
- Hide marker objects whose corresponding point is non-finite.
- Preserve null/empty frame handling, maximum display bounds, subscriptions,
  disable resets, and teardown.
- Add maintained guidance and completed verification evidence.

## Implementation Units

### 1. Filter particle coordinates

**File:** `Assets/Plugins/iOS/UnityARKit/PointCloudParticleExample.cs`

Validate all three coordinates and emit only finite samples to the particle
system.

### 2. Hide invalid marker coordinates

**File:** `Assets/Plugins/iOS/UnityARKit/UnityPointCloudExample.cs`

Bind marker visibility to both array ownership and finite XYZ coordinates.

### 3. Protect and document the boundary

**Files:** `scripts/check-baseline.sh`, `AGENTS.md`, `README.md`, `SECURITY.md`,
`VISION.md`, `CHANGES.md`, and this plan.

## Verification

- Run repository-root and external-directory `make check`.
- Reject isolated particle predicate, marker predicate, compact-count,
  visibility, guidance, and incomplete-plan mutations.
- Audit exact paths, generated artifacts, conflict markers, binary and scene
  drift, whitespace, and credential-shaped additions.

## Risks

- No Unity editor, Xcode export, ARKit session, physical device, or rendered
  point-cloud scene is available on this Linux host.
- Invalid samples are omitted rather than repaired because no trustworthy
  replacement coordinate exists.
- This PR is stacked on PR #14 and must retain base-first merge ordering.

## Out Of Scope

- AR relocalization, coordinate-system conversion, point confidence, smoothing,
  sorting, sampling strategy, material changes, and render performance tuning.
- Unity, Xcode, ARKit, dependency, project-setting, scene, or asset upgrades.

## Completion Evidence

- Repository-root and external-directory `make check` passed all source,
  lifecycle, scene, project, workflow, and completed-plan contracts.
- Six isolated hostile mutations were rejected for the particle finite
  predicate, marker finite predicate, compact particle count, marker visibility,
  maintained guidance, and incomplete-plan evidence.
- Exact-path diff, generated-artifact, binary/scene/project/workflow drift,
  conflict-marker, whitespace, and credential-shaped-addition audits passed.
- No Unity editor, Xcode export, ARKit session, physical device, or rendered
  point-cloud scene was executed.
