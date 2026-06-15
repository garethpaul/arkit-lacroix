# AGENTS.md

## Repository purpose

`garethpaul/arkit-lacroix` is a public sample, documentation, or utility project. A raining lacroix app built using Unity and ARKit

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Assets` - repository source or sample assets
- `ProjectSettings` - repository source or sample assets
- `Screenshots` - repository source or sample assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- Combined verification: `make verify`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: C# (55), Objective-C++ (1), shell (1).

## Testing guidance

- Test-related files detected: `Assets/HSVPicker/Other/ColorPickerTester.cs`, `Assets/HSVPicker/Other/ColorPickerTester.cs.meta`, `Assets/HSVPicker/PickerTest.unity`, `Assets/HSVPicker/PickerTest.unity.meta`, `Assets/Plugins/iOS/UnityARKit/NativeInterface/ARHitTestResult.cs`, `Assets/Plugins/iOS/UnityARKit/NativeInterface/ARHitTestResult.cs.meta`, `Assets/Plugins/iOS/UnityARKit/NativeInterface/ARHitTestResultType.cs`, `Assets/Plugins/iOS/UnityARKit/NativeInterface/ARHitTestResultType.cs.meta`, `Assets/Plugins/iOS/UnityARKit/NativeInterface/ARLightEstimate.cs`, `Assets/Plugins/iOS/UnityARKit/NativeInterface/ARLightEstimate.cs.meta`
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.
- `SodaSpawn.maxSodas` is bounded to the original 1000-can cleanup cap through the Unity inspector range and runtime repair helper.
- `SodaSpawn` prunes missing spawned-can references before enforcing the cap so the tracked list reflects live spawned objects.
- `UnityARAmbient` skips ARKit intensity writes when its scene `Light` or AR session is unavailable.
- `UnityARAmbient` refreshes missing AR ambient light dependencies before each device update.
- `UnityARAmbient` rejects non-finite or negative AR ambient intensity values before writing to the scene `Light`.
- ParticlePainter caps active and completed paint systems and releases owned systems on destruction.
- Point-cloud examples release AR frame listeners and owned scene objects during lifecycle teardown.
- The UnityARBallz BallMaker caps retained balls, prunes missing objects, evicts
  oldest ownership first, and releases retained balls when disabled.
- UnityARBallz BallMover releases its tracked object before replacement and when disabled.
- UnityARVideo reuses its external texture pair and releases it on teardown.
- HexColorField removes its end-edit listener from the matching event during
  teardown so destroyed controls do not retain callbacks.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
