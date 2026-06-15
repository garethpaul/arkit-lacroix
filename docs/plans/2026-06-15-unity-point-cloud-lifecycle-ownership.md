# Own Unity Point-Cloud Listener and Object Lifecycles

Status: Completed

## Context

`PointCloudParticleExample` and `UnityPointCloudExample` subscribe to the static
`UnityARSessionNativeInterface.ARFrameUpdatedEvent` in `Start()` without a
matching unsubscribe. Destroyed or disabled components can therefore remain
retained and continue receiving AR frame callbacks. Both examples also
instantiate point-cloud scene objects without explicit component-level cleanup.

## Requirements

- Register each point-cloud component for AR frame updates at most once while
  it is enabled.
- Remove the matching callback when the component is disabled or destroyed.
- Destroy only the particle system or point objects instantiated by the owning
  component, and clear retained collection or frame-data references.
- Preserve point count limits, particle appearance, prefab placement, public
  fields, scene assets, and the Unity 5.6.1p1 API surface.
- Add portable, mutation-sensitive lifecycle contracts and maintenance
  documentation without claiming Unity editor, Xcode, simulator, or device
  execution.

## Implementation Units

### U1: Matched AR frame ownership

- Update `Assets/Plugins/iOS/UnityARKit/PointCloudParticleExample.cs` and
  `Assets/Plugins/iOS/UnityARKit/UnityPointCloudExample.cs` with guarded
  subscribe and unsubscribe helpers used by enable, disable, and destruction
  lifecycle methods.

### U2: Instantiated object cleanup

- Release the owned particle-system instance and point-cloud prefab instances
  during destruction.
- Clear retained point-cloud data and collection references after cleanup.

### U3: Repository contracts and evidence

- Extend `scripts/check-baseline.sh` with exact matched-listener, lifecycle,
  ownership-cleanup, documentation, and completed-plan contracts.
- Update `AGENTS.md`, `README.md`, `SECURITY.md`, `VISION.md`, and `CHANGES.md`
  with the point-cloud ownership boundary.

## Verification

- Run repository and external-directory `make check`.
- Reject hostile mutations that remove guarded subscription, either matched
  unsubscribe, disable or destruction cleanup, owned-object destruction,
  retained-reference clearing, documentation, or completed-plan evidence.
- Audit the exact diff, POSIX shell syntax, generated Unity artifacts,
  credential patterns, conflict markers, and whitespace before commit.

## Risks

- Unity's destroyed-object null semantics require cleanup to remain explicit
  and limited to instances created by these components.
- Unity 5.6.1p1 editor, Xcode export, iOS simulator, and physical ARKit device
  behavior remain unexecuted and must not be inferred from portable checks.
- Existing stacked pull requests remain open and require explicit owner
  authorization before merge or closure.

## Verification Results

Completed on 2026-06-15:

- Both point-cloud examples now guard their static AR frame subscriptions,
  unsubscribe on disable and destruction, and release only scene objects they
  instantiated.
- The particle example now iterates only the bounded particle count instead of
  indexing a smaller buffer with the full source cloud.
- Repository and external-directory `make check` passed the portable scene,
  source, lifecycle, documentation, and plan contracts while truthfully
  reporting the unavailable Unity editor and iOS build boundary.
- Twelve isolated hostile mutations were rejected across subscription guards,
  matched removal, disable and destroy routing, owned-object destruction,
  retained-reference clearing, particle bounds, documentation, and plan status.
- Exact diff, generated-artifact, credential-pattern, conflict-marker, POSIX
  syntax, and whitespace audits passed before commit.
- No Unity 5.6.1p1 editor, Xcode export, iOS simulator, or physical ARKit device
  execution was performed or claimed.
