# arkit-lacroix
A raining LaCroix app built using Unity and ARKit.

You can see a video of this demo via https://youtu.be/m9xaGxl466A

![alt text](https://github.com/garethpaul/arkit-lacroix/blob/master/Screenshots/demo01.png?raw=true)

## Toolchain

This repository is a legacy Unity ARKit project:

- Unity editor version: 5.6.1p1
- Active build scene: `Assets/GameScene.unity`
- ARKit bridge code: `Assets/Plugins/iOS/UnityARKit/`
- Demo spawn script: `Assets/SodaSpawn.cs`
- LaCroix prefab/model assets: `Assets/Models/LaCroix.prefab` and `Assets/Models/can4.obj`

Unity is not installed in this environment, so this pass verifies project
metadata and source provenance without exporting an Xcode project.

## Verify

Run the SDK-free baseline check:

```sh
scripts/check-baseline.sh
```

Full build verification requires Unity 5.6.1p1 and an iOS/ARKit-capable Unity
export path. Do not commit generated `Library/`, `Temp/`, `Obj/`, `Build/`, or
`Builds/` directories.

## Modernization Notes

The current baseline keeps the original Unity/ARKit sample intact and corrects
the active build scene to the checked-in `Assets/GameScene.unity`. `SodaSpawn`
keeps the original 1000-can cleanup cap explicit and skips spawning when the
prefab reference is missing. A future pass should document the exact Unity
batchmode export command, generated Xcode project settings, signing
requirements, and device smoke-test evidence.
