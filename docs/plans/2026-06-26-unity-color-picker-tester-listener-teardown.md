# Unity ColorPickerTester Listener Teardown

Status: Completed

## Problem

`ColorPickerTester.Start` registered an anonymous callback with the picker's
runtime `onValueChanged` event. The callback had no stable identity for
`RemoveListener`, so a picker that outlived the tester could retain a callback
targeting the destroyed component and its renderer reference.

## Decision

Replace the anonymous callback with a private `ColorChanged` method and add a
picker-first-safe `OnDestroy` that calls `RemoveListener(ColorChanged)`. Keep
the initial color assignment and active-lifetime renderer updates unchanged.

## Verification

- The source contract failed first on the missing removable named listener.
- `scripts/check-baseline.sh`
- `make check`
- External-directory `make check`
- Official .NET SDK 8 container compiled and ran eleven production native-interface contracts with zero warnings or errors.
- Three isolated anonymous-listener, missing-removal, and null-guard mutations failed for the intended reason.
- Unity editor and device execution remain unverified locally.
