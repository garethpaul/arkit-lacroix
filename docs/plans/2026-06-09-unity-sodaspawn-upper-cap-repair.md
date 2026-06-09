# Unity SodaSpawn Upper Cap Repair

## Status: Completed

## Goal

Keep `SodaSpawn.maxSodas` bounded to the original 1000-can cleanup cap even when
Unity inspector data or runtime scripts assign a larger value.

## Scope

- Preserve the default 1000-can cap and existing spawn cadence.
- Add an inspector range that communicates the intended cap.
- Reuse the existing `RepairMaxSodas` helper for startup, inspector validation,
  and per-frame runtime repair.
- Extend the SDK-free baseline and docs for the upper-bound contract.

## Out Of Scope

- Changing the LaCroix prefab, scene references, physics, or cleanup strategy.
- Adding Unity editor tests or changing project settings.
- Running Unity editor, iOS export, or ARKit device verification on this host.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`
