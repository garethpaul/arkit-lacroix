# Reconcile Point-Cloud Marker Visibility

Status: Planned

## Summary

Prevent preallocated point-cloud markers from remaining visible at stale
positions when a later AR frame contains fewer points or frame state is reset.

## Problem

`UnityPointCloudExample.Update()` moves only the prefix represented by the
current frame. Markers above that count remain active at positions from an
older frame, and clearing retained frame data does not hide them.

## Requirements

- Activate and position only markers represented by the current frame and
  configured point limit.
- Hide every unused preallocated marker after each frame reconciliation.
- Hide all owned markers whenever retained frame state is cleared.
- Preserve prefab creation, point limits, event ownership, disable/re-enable
  behavior, and destruction cleanup.
- Add ordered mutation-sensitive portable contracts and maintained guidance.

## Implementation Units

### U1. Reconcile marker active state

**Files:** `Assets/Plugins/iOS/UnityARKit/UnityPointCloudExample.cs`

**Approach:** Compute the displayed point count once, iterate the complete
owned marker list, activate and position the current prefix, and deactivate
the remaining suffix. Reuse a helper to hide all markers during frame reset.

**Verification:** Portable contracts require full-list iteration, active-state
selection from the displayed count, guarded frame indexing, and reset-time
hiding.

### U2. Preserve the rendering contract

**Files:** `scripts/check-baseline.sh`, `README.md`, `SECURITY.md`, `AGENTS.md`,
`CHANGES.md`, `docs/plans/2026-06-15-unity-point-cloud-marker-visibility.md`

**Approach:** Register source, ordering, documentation, and completed-plan
contracts in the existing dependency-free baseline.

**Verification:** Isolated mutations removing count bounding, full-list
iteration, activation, suffix hiding, reset hiding, documentation, or plan
completion are rejected.

## Scope Boundaries

- Do not change the point budget, prefab ownership, AR session callbacks,
  particle-system example, scenes, dependencies, or Unity project settings.
- Do not claim Unity editor, Xcode export, simulator, physical-device, or live
  AR frame execution from Linux.
- Keep this work stacked on the point-cloud disable-frame-reset pull request.

## Verification Plan

- Run POSIX shell syntax and the focused portable baseline.
- Run repository-root and external-directory `make check` with bounded
  commands.
- Run isolated hostile mutations for the rendering and evidence contracts.
- Audit the exact intended diff, artifacts, whitespace, conflict markers,
  large files, and likely secrets before commit.
