# Unity Ambient Light Dependency Refresh

Status: Completed
Date: 2026-06-09

## Goal

Keep `UnityARAmbient` able to recover when the scene `Light` component or ARKit
session is unavailable at startup but becomes available before a later device
update.

## Changes

- Replaced one-time ambient dependency assignment with a reusable refresh helper.
- Retried missing `Light` component and AR session lookup before each device
  update.
- Kept ARKit ambient intensity conversion unchanged.
- Extended the SDK-free baseline and documentation to enforce the refresh
  contract.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
