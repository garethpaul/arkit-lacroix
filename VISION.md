## ARKit LaCroix Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

ARKit LaCroix is a Unity and ARKit demo where LaCroix cans rain into an
augmented-reality scene.

The repository is useful as a playful AR experiment with Unity scenes, ARKit
plugins, assets, prefabs, and a recorded demo. Project context lives in
[`README.md`](README.md).

The goal is to preserve the demo and keep future Unity/ARKit work reviewable
instead of turning the project into an untracked asset dump.

The current focus is:

Priority:

- Preserve the existing Unity scenes, models, materials, and ARKit behavior
- Keep demo media and screenshots tied to the checked-in experience
- Keep `SodaSpawn` caps and cleanup behavior explicit in source
- Keep spawn caps bounded to the original 1000-can cleanup limit
- Keep spawned-can tracking aligned with live scene objects
- Keep the spawn cap populated through bounded oldest-first eviction
- Keep can creation on an explicit bounded cadence instead of device frame rate
- Keep AR ambient light updates tolerant of missing scene components
- Keep AR ambient light dependency lookup tolerant of late availability
- Keep AR ambient intensity writes guarded against invalid values
- Keep AR ambient intensity bounded to Unity's over-bright range
- Keep particle painting callbacks scoped to active, initialized components
- Keep particle painting samples inside a repaired minimum/maximum movement window
- Keep each particle-painting stroke bounded and reuse its active particle buffer
- ParticlePainter caps active and completed paint systems and releases owned systems on destruction.
- The UnityARBallz BallMaker caps retained balls, prunes missing objects, evicts
  oldest ownership first, and releases retained balls when disabled.
- UnityARBallz BallMover releases its tracked object before replacement and when disabled.
- UnityARVideo reuses its external texture pair and releases it on teardown.
- Keep root lint, test, and build gates wired to the SDK-free Unity baseline
- Keep the SDK-free `make check` baseline running in GitHub Actions
- Keep CodeQL default-setup coverage for Actions and Unity C#, and close the native plugin analysis gap separately
- Avoid asset or plugin changes without explaining Unity version assumptions
- Keep generated Unity metadata consistent with asset changes
- Keep exact-commit ARKit Lacroix device verification matrix evidence separate
  from portable checks, with unexecuted Unity, Xcode, camera, and device rows
  explicit

Next priorities:

- Document the Unity and Xcode versions needed to open and build the demo
- Add manual verification steps for launching the AR scene
- Clarify which assets are original, third-party, or replaceable
- Modernize ARKit/plugin dependencies only in a dedicated pass
- Execute the device verification matrix with privacy-safe camera, tracking,
  resource-ownership, interruption, and long-session evidence

Contribution rules:

- One PR = one focused scene, asset, script, or documentation change.
- Include Unity version notes when modifying project settings or plugins.
- Keep `.meta` files with their matching assets.
- Use screenshots or a short demo clip for visible AR behavior changes.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

AR demos use device cameras and real-world surroundings. Future features should
avoid collecting, uploading, or logging camera-derived data unless the data flow
is explicit and user-controlled.

## What We Will Not Merge (For Now)

- Large asset imports without provenance and purpose
- Unity version migrations bundled with unrelated gameplay changes
- Camera data collection or upload behavior
- Broken asset metadata or missing prefabs needed by the demo scene

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
