# Unity Point Cloud Count Bound Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Prevent malformed Unity serialization or runtime assignments from causing `UnityPointCloudExample` to allocate an unbounded number of marker objects.

**Architecture:** Preserve the public serialized `uint numPointsToShow` field and all checked-in scene values. Add a small repair helper that restores zero or values above 1,000 to the original default of 100 before marker allocation, and invoke the same helper during inspector validation.

**Tech Stack:** Unity 5.6 C#, POSIX shell source contracts, GNU Make.

---

## Status: Completed

### Task 1: Add the failing source contract

**Files:**
- Modify: `scripts/check-baseline.sh`

1. Require explicit default and maximum point-count constants.
2. Require `OnValidate` and startup to call a shared repair helper.
3. Require the helper to reject zero and values above the maximum.
4. Run `scripts/check-baseline.sh` and confirm it fails because the repair is absent.

### Task 2: Implement the bounded repair

**Files:**
- Modify: `Assets/Plugins/iOS/UnityARKit/UnityPointCloudExample.cs`

1. Add default 100 and maximum 1,000 constants.
2. Add `RepairPointCount()` without changing the serialized field type.
3. Call the helper from `OnValidate()` and before marker allocation in `Start()`.
4. Run `scripts/check-baseline.sh` and confirm it passes.

### Task 3: Record ownership and verification

**Files:**
- Modify: `AGENTS.md`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `CHANGES.md`
- Modify: `docs/plans/2026-06-26-unity-point-cloud-count-bound.md`
- Modify: `scripts/check-baseline.sh`

1. Document the bounded marker-allocation contract.
2. Mark this plan completed with exact verification evidence.
3. Run `make check` from the repository and an external directory.
4. Run shell syntax checks, hostile source mutations, and `git diff --check`.
5. Record that Unity editor, Xcode export, ARKit, and device execution remain unverified locally.

## Verification

- The test-first baseline failed on the missing `DefaultPointsToShow` constant.
- `scripts/check-baseline.sh`
- `make check`
- External-directory `make check`
- `/bin/sh -n scripts/*.sh`
- `git diff --check`
- Official .NET SDK 8 container compiled and ran eleven production native-interface contracts with zero warnings or errors.
- Missing-upper-bound, missing-startup-repair, and raised-ceiling mutations failed for the intended reasons.
- Unity 5.6.1p1 editor, iOS/Xcode export, ARKit session, camera, and physical-device execution remain unverified locally.
