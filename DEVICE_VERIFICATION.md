# ARKit Lacroix Device Verification Matrix

Use this matrix only for an exact implementation commit. Record the commit SHA and pull request
before testing so Unity, Xcode, ARKit, camera, and ownership evidence cannot be
transferred to a different scene or script implementation.

## Evidence Rules

- Record Unity 5.6.1p1, the Xcode version, iOS version, device model class,
  ARKit support, build/export method, result, and evidence identifier.
- Use a controlled space with no people, addresses, documents, screens, or
  other sensitive surroundings visible to the camera.
- Do not include device identifiers, camera captures, room imagery, location
  data, signing details, unrelated notifications, or raw diagnostic output.
- Store durable evidence outside git. Link only a sanitized run, screenshot, or
  short log excerpt by stable identifier.
- Record each result as `pass`, `fail`, `blocked`, or `not run`, with an owner
  and follow-up for every result other than `pass`.
- Do not convert `not run` into passing evidence.

## Run Identity

| Field | Value |
| --- | --- |
| Commit SHA | `not run` |
| Pull request | `not run` |
| Unity / Xcode | `not run` |
| iOS / device class | `not run` |
| ARKit support | `not run` |
| Export / signing method | `not run` |
| Evidence location | `not run` |

## Verification Matrix

| Scenario | Expected evidence | Result | Evidence |
| --- | --- | --- | --- |
| Unity project open | Unity 5.6.1p1 opens the project and active build scene without missing scripts or broken asset references. | `not run` | `not run` |
| Xcode export and build | The documented export produces a buildable iOS project without modifying checked-in assets or metadata. | `not run` | `not run` |
| Camera permission | First launch requests camera access and denied access fails safely without collecting imagery. | `not run` | `not run` |
| AR session tracking | Supported hardware starts tracking and the scene remains stable through normal movement. | `not run` | `not run` |
| UnityARVideo texture pair | One Y/CbCr external texture pair is reused while camera resolution remains stable. | `not run` | `not run` |
| Resolution change | Camera resolution change releases both wrappers before creating the replacement pair. | `not run` | `not run` |
| Ambient light updates | Valid estimates update the scene light while unavailable, negative, non-finite, and excessive values are ignored or bounded. | `not run` | `not run` |
| Soda spawn cadence | Can creation follows the configured cadence without frame-rate-dependent bursts. | `not run` | `not run` |
| Soda ownership cap | Live spawned cans remain bounded with missing references pruned and oldest ownership evicted first. | `not run` | `not run` |
| Particle painting | Movement-window sampling remains bounded and active/completed particle systems stay within ownership limits. | `not run` | `not run` |
| BallMaker ownership | Retained balls remain capped, oldest ownership is evicted, and disable cleanup releases retained objects. | `not run` | `not run` |
| BallMover replacement | Replacement releases the previously tracked object and disable cleanup clears ownership. | `not run` | `not run` |
| Background and foreground | AR interruption and resume do not leak textures, balls, cans, or particle systems. | `not run` | `not run` |
| Long session | A bounded smoke interval shows stable memory and object counts without runaway spawn or texture growth. | `not run` | `not run` |
| Process relaunch | Relaunch creates fresh session, texture, and scene ownership without stale native or Unity objects. | `not run` | `not run` |

## Current Status

No Unity editor, Xcode export, iOS simulator, physical ARKit device, camera, or
live AR scene scenario was executed for this checklist. Treat every Unity, Xcode, ARKit, camera, and device row as unexecuted
until evidence is attached to the exact commit.
