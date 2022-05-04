# Immersive Stream for XR Template Project

## [1.7.1] - 2022-03-31

### Fixes

* Setting the starting 3D Pawn in XR_Init instead of checking for pawns in the scene.
* Using the in level rotation and location values for the default pawn.

### Modified files

* XR_Init
* LevelActions
* Main_Persistent
* 3D_DefaultPawn
* TouchExample_BP

## [1.7.0] - 2022-03-29

### Fixes

* Modified folder and asset naming.

### Renamed files and folders

* /ImEdgeActions > /XR_Actions
* ImEdge_Template > XR_Template
* ImEdge_Init > XR_Init
* ImEdge_DefaultPawn > 3D_DefaultPawn
* ImEdge_UI > XR_UI
* ImEdge_GM > Default_GM
* ImEdge_CameraManager > Default_CameraManager
* ImEdge_Controller > Default_Controller

* Note: Other files were also modified due to dependencies.
* Please download the complete new template version.

## [1.6.6] - 2022-03-22

### Fixes

* Modified/optimized structure of UI folder.
* Prepared functionality to load Demos directory independently.

### Modified files

* Content/UI
* LevelActions
* ImEdge_Init
* (Added) Demo_List

## [1.6.5] - 2022-03-18

### Fixes

* Exposed camera variables in the 3D pawn.
* Added trigger in 3D only functionality in LevelActions.

### Modified files

* ImEdge_DefaultPawn
* LevelActions

## [1.6.4] - 2022-02-25

### Fixes

* Fixed AR shadow artifacts.
* Added functionality for persistent and streaming level switch with the ARAssetID.

### Modified files

* ToBuild/ARLights
* ToBuild/SideChannel
* LevelActions

## [1.6.3] - 2022-02-18

### Fixes

* Set frame delay flags to reduce latency and fix AR mode in UE4.27.

### Modified files

* ImEdge_Init

## [1.6.2] - 2022-02-10

### Fixes

* Fixed shadow direction when rotating the object in AR mode.

### Modified files

* ToBuild/ARLights

## [1.6.1] - 2022-02-03

### Fixes

* Fixed shadow and lighting brightness in AR mode.

### Modified files

* Shadow_Plane
* Shadow_PostProcessing
* ShadowParameters
* AR_BG
* ARLights
* ToBuild/ARLights

## [1.6.0] - 2022-01-26

### Fixes

* Included controlled AR lighting setup.
* Preload AR_BG level in ImEdge_Init.
* Spawn ARLights in the AR_BG Level Blueprint.

### Modified files

* ImEdge_Init
* AR_BG
* AR_BG_BuiltData
* (Added) ARLights
* (Added) ToBuild/ARLights

## [1.5.1] - 2022-01-26

### Fixes

* Added events and examples in Server_Only_UI to open a URL on client, trigger switch to AR mode and share from server to client.
* Added exposed variable UI in ImEdge_Init that sets the UI used for the experience (default = "Server_Client_UI")
* Server_Client_UI: Includes in editor preview UI for the elements that will then come from the client side.
* Server_Only_UI: Works with the new events that are set up in Unreal and all the UI will show up in the experience.

Note: Server to client events do not work e2e yet.

### Modified files

* LevelActions
* ToBuild/SideChannel
* SideChannel
* ImEdge_Init
* ImEdge_UI
* System_UI_Reference
* Default_InterfaceHUD
* (Added) Server_Client_UI
* (Added) Server_Only_UI
* (Added) UI/imgs/Share
* (Added) UI_List
* (Added) AR_Editor_Preview_UI

## [1.5.0] - 2022-01-20

### Fixes

* Modified and added scripts in ImEdgeActions that use the Stream API.

### Modified files

* SyncContent
* (Added) DescribeInstances
* (Added) BuildContent
* (Added) DescribeContent
* (Added) DescribeInstance
* (Added) DescribeContents

## [1.4.0] - 2021-11-15

### Fixes

* Adjusts how AR mode position is tracked
* Adds functionality to be able to teleport in AR mode

### Modified files

* LevelActions
* Main_Persistent
* AR_Pawn
* (Added) ARAnchor
* (Added) ARMovement

## [1.3.0] - 2021-10-13

### Fixes

* Replaced UIEvent with SideChannel that allows events from and to the server

### Modified files

* (Deleted) UIEvent
* (Deleted) ToBuild/UIEvent
* (Added) SideChannel
* (Added) ToBuild/SideChannel
* ImEdge_Init

## [1.2.7] - 2021-09-21

### Fixes

* Adding UI component that shows Asset ID

### Modified files

* LevelActions
* ImEdge_UI

## [1.2.6] - 2021-09-13

### Fixes

* Added visual reference of space reserved for system UI only

### Modified files

* System_UI_Reference
* (New) systemUI

## [1.2.5] - 2021-08-23

### Fixes

* Fixed FOV and cam rotation limits
* Addd "Triger in AR" and "Trigger in 3D" dispatchers

### Modified files

* ImEdge_DefaultPawn
* ImEdge_GM
* LevelActions
* (New) ImEdge_Controller
* (New) ImEdge_CameraManager

## [1.2.4] - 2021-08-12

### Fixes

* Adds Cloud AR asset ID custom events

### Modified files

* ToBuild/UIEvent
* LevelActions

## [1.2.3] - 2021-08-04

### Fixes

* Improved AR/3D transition loading time

### Modified files

* LevelActions
* Main_Persistent
* System_UI_Reference

## [1.2.2] - 2021-07-29

### Fixes

* Improved AR lighting

### Modified files

* AR_BG
* Shadow_Plane

## [1.2.1] - 2021-07-28

### Fixes

* Improvements to the SyncContent script
* Calls to AR and 3D mode specific events
* Reduced error threshold for tap

### Modified files

* LevelActions
* SyncContent
* ImEdge_DefaultPawn
* TouchExample_BP

## [1.2.0] - 2021-07-23

### Features added

* Support for adding pawn in the scene or dynamically

### Modified files

* LevelActions
* ImEdge_Init

## [1.1.0] - 2021-07-21

### Features added

* Custom events for map loading and navigation change
* Exposed start map, background and AR background values 

### Modified files

* ToBuild/UIEvent
* LevelActions
* ImEdge_Init
* System_UI_Reference
* ImEdge_UI

## [1.0.0] - 2021-07-16

### Features added

* Touch enabled
* Server camera control
* HUD UI in 3D
* Folder for extra files: ToCustomize