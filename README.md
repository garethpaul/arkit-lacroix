# arkit-lacroix

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/arkit-lacroix` is a public sample, documentation, or utility project. A raining lacroix app built using Unity and ARKit

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: C# (55), Objective-C++ (1), shell (1).

## Repository Contents

- `README.md` - project overview and local usage notes
- `Assets` - source or example code
- `docs` - source or example code
- `ProjectSettings` - source or example code
- `scripts` - source or example code
- `SECURITY.md` - security reporting and disclosure guidance
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: Assets, ProjectSettings, docs, scripts
- Dependency and build manifests: none detected
- Entry points or build surfaces: none detected
- Test-looking files: Assets/HSVPicker/Other/ColorPickerTester.cs, Assets/Plugins/iOS/UnityARKit/NativeInterface/ARHitTestResult.cs, Assets/Plugins/iOS/UnityARKit/NativeInterface/ARHitTestResultType.cs, Assets/Plugins/iOS/UnityARKit/NativeInterface/ARLightEstimate.cs, Assets/Plugins/iOS/UnityARKit/UnityARHitTestExample.cs

## Getting Started

### Prerequisites

- Git

### Setup

```bash
git clone https://github.com/garethpaul/arkit-lacroix.git
cd arkit-lacroix
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- No single runtime entry point was identified. Start by reading the source files and manifests listed above.

## Testing and Verification

Run the SDK-free source baseline check first:

```sh
scripts/check-baseline.sh
```

Unity editor version: 5.6.1p1. This host does not have Unity installed, so full editor, iOS export, and ARKit device verification must happen on a machine with the matching legacy Unity/iOS toolchain.

The source baseline checks the active `Assets/GameScene.unity` build scene, stable scene/prefab GUIDs, generated Unity directory ignore policy, and keeps the original 1000-can cleanup cap explicit.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.

## Security and Privacy Notes

- Review changes touching authentication or token handling; examples from the scan include Assets/Plugins/iOS/UnityARKit/NativeInterface/ARErrorCode.cs, Assets/Plugins/iOS/UnityARKit/NativeInterface/ARSessionNative.mm, Assets/Plugins/iOS/UnityARKit/NativeInterface/UnityARSessionNativeInterface.cs, Assets/Plugins/iOS/UnityARKit/UnityARKitControl.cs, and 1 more.
- Review changes touching network requests, sockets, or service endpoints; examples from the scan include Assets/Plugins/iOS/UnityARKit/Utility/UnityARMatrixOps.cs, Assets/TUTORIAL.txt.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include Assets/HSVPicker/UI/ColorImage.cs, Assets/HSVPicker/UI/ColorPresets.cs, Assets/HSVPicker/UI/ColorSliderImage.cs, Assets/HSVPicker/UI/HexColorField.cs, and 3 more.
- Review changes touching database, model, or persistence code; examples from the scan include docs/plans/2026-06-08-unity-arkit-scene-baseline.md, docs/plans/2026-06-08-unity-sodaspawn-safety-baseline.md.

## Maintenance Notes

- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `CHANGES.md` for the maintenance history.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
