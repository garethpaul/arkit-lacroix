# Unity SodaSpawn Missing Reference Prune

Status: Completed
Date: 2026-06-09

## Goal

Keep `SodaSpawn` cap enforcement tied to live tracked cans when spawned objects
are destroyed by Unity lifecycle behavior or other scene code outside the
spawner cleanup path.

## Changes

- Added a reusable missing-reference pruning helper for the spawned-can list.
- Pruned the tracked list before prefab checks and cap enforcement during
  `Update`.
- Extended the SDK-free baseline to require the pruning helper and plan.
- Documented the live-object tracking contract in the README, changelog, and
  vision.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Unity editor, iOS export, and ARKit device verification still require a machine
with Unity 5.6.1p1 and the matching legacy iOS toolchain.
