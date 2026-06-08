# Unity SodaSpawn Disable Cleanup

## Goal

Ensure `SodaSpawn` cleans up tracked spawned cans when the spawner component is
disabled or the scene exits, not only when the max-count cap is reached.

## Red

- Extended `scripts/check-baseline.sh` to require an `OnDisable` lifecycle hook
  and reuse of `ClearSodas`.
- Confirmed the baseline failed with `SodaSpawn must clean up spawned cans when
  disabled.`

## Green

- Added `OnDisable` to call `ClearSodas`.
- Documented the lifecycle cleanup in the README and changelog.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`

Unity is not installed in this environment, so editor, iOS export, and device
verification remain deferred to a matching Unity 5.6.1p1 setup.
