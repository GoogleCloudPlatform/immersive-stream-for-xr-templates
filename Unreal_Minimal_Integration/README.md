# Immersive Stream for XR + Unreal Minimal Integration

These are instructions on the minimal amount of files/assets that need to be ported into an
existing Unreal Engine project for it to work on Immersive Stream for XR.

#### Table of Contents
1. [Step by Step](#step-by-step)
1. [Features](#features)
1. [Notes](#notes)

For information about Immersive Stream for XR, quickstart guide and additional documentation visit
[cloud.google.com/immersive-stream/xr](https://cloud.google.com/immersive-stream/xr)

_Google does not charge for access to Unreal Engine®, which is
subject to the Unreal Engine® End User License Agreement._

_________________________________________________________________________________________

## Step by Step

The bare minimun files you need for your project to work with Immersive Stream for XR are the following:

    Unreal_Minimal_Integration/
    ├── Content/
    │   ├── Blueprints/
    │   │   ├── XR_Init.uasset
    ├── CHANGELOG.md

1. Add the **Content** folder and the `CHANGELOG.md` file into the root directory of your project.
2. Include the `XR_Init` blueprint in your main level.
(Make sure this blueprint gets executed at EventBeginPlay in the main level at startup).

#### Optional

##### Screen Space UI

    ├── Content/
    │   ├── Global/
    │   │   ├── ISXR_HUD.uasset

If your project has screen space UI, use `ISXR_HUD` in your **GameMode**
and modify the blueprint to create the widget of the desired class.
`ISXR_HUD` has the logic that scales the UI to the correct aspect ratio
and includes the `SetUIOrientation` event to swicth to portrait and landscape modes.

##### 3D Camera Pawn

    ├── Config/
    │   ├── DefaultInput.ini
    ├── Content/
    │   ├── Global/
    │   │   ├── ISXR_3D_Pawn.uasset

`ISXR_3D_Pawn` uses pinch to zoom and swipe to rotate camera gestures to navigate the scene.
Include `ISXR_3D_Pawn` in the main level and add `DefaultInput.ini` to the **Config** folder.

##### Side Channel Events

    ├── ToBuild/
    │   ├── Content/
    │   │   ├── Blueprints/
    │   │   │   ├── SideChannel.uasset

To set a starting map using the entrypoint URL or redirect to an external URL from your game,
include the `ToBuild` folder in your root directory.

##### Uploading Project

    ├── XRActions/
    │   ├── SyncContent.ps1

__(Windows only)__ Once you have your Cloud project setup, including the storage bucket,
upload the project files using `SyncContent.ps1` in PowerShell.

## Features

This approach supports the following features:

* Stream 3D mode only.
* Fully customizable UI and events triggered within Unreal Engine®.
* Pre-made client trigger event [`Redirect to URL`](/Unreal_Template_Project/README.md#server-to-client-events).
* Fully customizable pre-set gesture controlled camera for 3D mode.
* Touch in world space for 3D.
* [Debug mode](/README.md#debug-mode) with toggle stats option.
* [Asset ID definition](/Unreal_Template_Project/README.md#startup-customization) to set starting map using the entrypoint URL.
* Upload by running a script `SyncContent.ps1`.

## Notes

* The files work on Unreal Engine 5.0.
* This workflow is intended for 3D only experiences.
* Please do not modify the location or name of the assets.
