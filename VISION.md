## ARKit LaCroix Vision

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
- Avoid asset or plugin changes without explaining Unity version assumptions
- Keep generated Unity metadata consistent with asset changes

Next priorities:

- Document the Unity and Xcode versions needed to open and build the demo
- Add manual verification steps for launching the AR scene
- Clarify which assets are original, third-party, or replaceable
- Modernize ARKit/plugin dependencies only in a dedicated pass

Contribution rules:

- One PR = one focused scene, asset, script, or documentation change.
- Include Unity version notes when modifying project settings or plugins.
- Keep `.meta` files with their matching assets.
- Use screenshots or a short demo clip for visible AR behavior changes.

## Security And Privacy

AR demos use device cameras and real-world surroundings. Future features should
avoid collecting, uploading, or logging camera-derived data unless the data flow
is explicit and user-controlled.

## What We Will Not Merge (For Now)

- Large asset imports without provenance and purpose
- Unity version migrations bundled with unrelated gameplay changes
- Camera data collection or upload behavior
- Broken asset metadata or missing prefabs needed by the demo scene
