# Unity SodaSpawn Runtime Cap Repair

## Status: Completed

## Goal

Keep `SodaSpawn.maxSodas` self-repairing when invalid inspector values are
loaded, edited, or changed during play so the raining-can cleanup cap remains
predictable.

## Scope

- Reuse one cap-repair helper instead of keeping the check inline in `Start`.
- Repair invalid caps from Unity editor validation.
- Repair invalid caps before each spawn update.
- Extend the SDK-free baseline and docs for the runtime cap repair contract.

## Out Of Scope

- Changing the default 1000-can cap.
- Changing the spawn cadence, physics, prefab, or scene references.
- Running Unity editor, iOS export, or ARKit device verification on this host.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`
