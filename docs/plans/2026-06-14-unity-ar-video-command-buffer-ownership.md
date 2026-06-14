# Unity AR Video Command Buffer Ownership

Status: Completed

## Problem

`UnityARVideo` creates a native-backed `CommandBuffer` and attaches it to the
camera, but teardown only removes the buffer from the camera. The buffer itself
is never released, and disabling the component leaves the command buffer
attached and rendering until object destruction.

## Requirements

1. Remove the owned command buffer from its camera when the component is
   disabled or destroyed.
2. Release the command buffer exactly once and clear its reference.
3. Reset initialization state so re-enabling can create a fresh buffer through
   the existing `OnPreRender` path.
4. Tolerate missing camera components and repeated disable/destroy callbacks.
5. Preserve video material behavior, external texture reuse and release,
   camera events, scene metadata, dependencies, and editor/device boundaries.
6. Add mutation-sensitive portable contracts, maintenance guidance, and
   truthful verification evidence.

## Implementation Units

### 1. Centralize command-buffer release

Files:

- `Assets/Plugins/iOS/UnityARKit/UnityARVideo.cs`

Add an idempotent release helper that removes the buffer from an available
camera, releases native buffer resources, clears ownership, and resets the
initialized flag.

### 2. Cover disable and destroy lifecycle

Files:

- `Assets/Plugins/iOS/UnityARKit/UnityARVideo.cs`
- `scripts/check-baseline.sh`

Invoke the helper from both lifecycle callbacks and protect ordering, null
guards, reference clearing, and exactly-once release behavior.

### 3. Document ownership

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `docs/plans/2026-06-14-unity-ar-video-command-buffer-ownership.md`

Record that video command buffers are detached and released on disable and
destroy, independently of external texture ownership.

## Verification

- `sh -n scripts/check-baseline.sh` and the portable scene, source, workflow,
  documentation, and plan contracts passed.
- Repository-root and external-directory `make check` passed. Both truthfully
  reported Unity `5.6.1p1`, Xcode export, and ARKit device execution as
  unavailable rather than claiming runtime coverage.
- Nine isolated mutations were rejected for disable cleanup, destroy cleanup,
  camera/material initialization guarding, cleanup camera guarding,
  command-buffer release, reference clearing, initialization-state reset,
  documentation, and completed plan evidence.

## Scope Boundaries

- Do not alter shader/material setup, camera event selection, texture handles,
  scene metadata, or checked-in Unity project settings.
- Do not claim Unity editor, Xcode export, simulator, ARKit, or device execution.
- Do not merge or close any pull request without explicit authorization.
