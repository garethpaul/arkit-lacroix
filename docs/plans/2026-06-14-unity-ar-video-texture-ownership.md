# Unity AR Video Texture Ownership

Status: Completed

## Problem

`UnityARVideo.OnPreRender` creates new Y and CbCr external `Texture2D` wrappers
on every rendered frame without releasing the prior pair. A sustained AR
session therefore accumulates Unity texture objects even though only the latest
native handles are used.

## Requirements

1. Create one external texture pair for the current screen resolution.
2. Reuse that pair by updating native handles while resolution is unchanged.
3. Release both textures before resolution-driven replacement and on teardown.
4. Clear both tracked references immediately after scheduling destruction.
5. Preserve formats, filtering, wrapping, material bindings, orientation, and
   command-buffer behavior.
6. Add mutation-sensitive source, documentation, and completed-plan contracts.

## Scope Boundaries

- Do not change Unity, ARKit, scene, material, shader, or native plugin files.
- Do not claim Unity editor, iOS export, simulator, physical-device, camera, or
  ARKit runtime verification.
- Do not merge or close stacked pull requests without explicit authorization.

## Verification

- Root and external-directory `make check` passed the complete source, scene,
  workflow, documentation, and plan contract gate.
- Six hostile mutations were rejected for restored per-frame creation, missing
  handle updates, missing resolution replacement cleanup, missing teardown,
  retained destroyed references, and reopened plan status.
- Exact diff, shell syntax, metadata, generated-artifact, whitespace, and
  credential-shaped addition audits passed.
- Unity 5.6.1p1, iOS export, simulator, physical-device, camera, and ARKit
  runtime execution were unavailable and are not claimed.
