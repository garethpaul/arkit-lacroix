# Unity Ambient Intensity Upper Bound

Status: Completed

## Context

`UnityARAmbient` converted ARKit ambient intensity by dividing by `1000.0f`.
The script comments document Unity's useful over-bright range as `0-8`, but the
value guard only rejected non-finite and negative values. An implausibly high
ARKit value could still push the scene light beyond that documented range.

## Plan

- Keep the upper renderable AR ambient intensity explicit in source.
- Reject AR ambient intensity values that would convert above Unity's
  over-bright light range.
- Preserve the existing non-finite, negative, dependency, and null guards.
- Extend the SDK-free baseline and maintenance docs for the upper-bound
  contract.

## Verification

- `scripts/check-baseline.sh`
- `git diff --check`
- `make check`
