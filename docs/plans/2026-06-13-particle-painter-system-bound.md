# Particle Painter System Bound

Status: Completed

## Context

`ParticlePainter` bounds samples and reusable buffer memory within each stroke,
but every paint-mode restart retains the previous `ParticleSystem` without a
global stroke limit. Repeated mode cycling can therefore grow scene objects and
particle capacity for the lifetime of the painter.

## Scope

- Add a repaired inspector limit for total owned paint systems, including the
  active stroke.
- Before creating a new active stroke, evict and destroy oldest completed paint
  systems until the active-plus-completed total remains within the limit.
- Apply a lowered runtime limit during `Update` and editor validation/startup.
- Destroy the active and completed systems when the painter is destroyed.
- Protect exact ownership, ordering, documentation, and completed evidence with
  SDK-free mutation-sensitive contracts.

## Out Of Scope

- Object pooling, particle visual redesign, Unity version upgrades, or changes
  to the existing per-stroke sample limit.
- Unity editor, Xcode export, simulator, or ARKit device execution, because the
  historical Unity 5.6.1p1 toolchain is unavailable.

## Implementation

### U1: Bound Owned Paint Systems

**File:** `Assets/ParticlePainter.cs`

Repair `maxPaintSystems`, trim completed systems while reserving one active
slot, and destroy oldest completed systems before each restart.

### U2: Release Painter-Owned Systems

**File:** `Assets/ParticlePainter.cs`

Destroy the active system and every retained completed system from
`OnDestroy`, then clear ownership references.

### U3: Protect And Document

**Files:** `scripts/check-baseline.sh`, `AGENTS.md`, `README.md`, `VISION.md`,
`CHANGES.md`, this plan

Pin repair, trim, restart, and destruction ordering. Run repository and
external-working-directory gates, hostile mutations, and exact artifact/secret
inspection without claiming Unity runtime coverage.

## Verification

- Repository and external-working-directory `make check` passed the SDK-free
  scene/source baseline and root lint, test, build, verify, and check wrappers.
- Ten focused hostile mutations were rejected across limit/repair removal,
  off-by-one ownership, eviction order/destruction, restart order, runtime
  lowering, teardown, guidance, and plan-status regressions.
- Shell syntax and `git diff --check` passed. Final exact diff, generated
  artifact, conflict-marker, and credential-pattern inspection is performed
  before commit.
- No Unity 5.6.1p1 editor or compatible standalone C# compiler is available;
  no claim is made for editor, Xcode export, or ARKit device execution.
