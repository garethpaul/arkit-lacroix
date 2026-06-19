# ARKit Lacroix Device Verification Checklist

Status: Completed

## Problem

Portable contracts cover spawn cadence, particle buffers and system ownership,
ball ownership, ambient-light guards, and AR video texture reuse, but no
checklist defines repeatable Unity editor, Xcode export, or physical ARKit
device evidence for the exact implementation commit.

## Requirements

1. Add an exact-commit matrix for scene launch, permission, AR tracking, video
   textures, ambient light, soda spawning, painting, ownership bounds,
   interruption, memory behavior, and relaunch.
2. Require sanitized Unity, Xcode, iOS, device, result, and evidence fields.
3. Keep repository checks separate from unexecuted Unity, Xcode, camera,
   ARKit, and physical-device scenarios.
4. Add mutation-sensitive contracts for the checklist and completion evidence.

## Scope Boundaries

- Do not change Unity scenes, prefabs, scripts, plugins, project settings,
  dependencies, asset metadata, or runtime behavior.
- Do not add device identifiers, camera captures, room imagery, location data,
  screenshots, logs, Xcode archives, exported projects, or signing material.
- Do not claim Unity editor, Xcode, simulator, camera, or ARKit device execution
  from portable checks.
- Do not merge or close stacked pull requests without explicit authorization.

## Verification

- `sh -n scripts/check-baseline.sh` and the focused baseline checker passed.
- `make check` passed from the repository and from an external working
  directory for all portable contracts available in this Linux environment.
- Twelve hostile mutations were rejected by the checklist's static contracts.
- No Unity editor, Xcode export, iOS simulator, physical ARKit device, camera, or live AR scene scenario was executed;
  every runtime matrix row remains `not run`.
