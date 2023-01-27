# Immersive Stream for XR

This repository contains a template that can be used to start
development with Immersive Stream for XR.

#### Table of Contents
1. [Unreal Template Project](#unreal-template-project)
2. [Content Guidelines for 3D and AR creators](#content-guidelines-for-3d-and-ar-creators)
2. [Demo Features and Templates](#demo-features-and-templates)

For information about Immersive Stream for XR, quickstart guide and additional documentation visit
[cloud.google.com/immersive-stream/xr](https://cloud.google.com/immersive-stream/xr)

_Google does not charge for access to Unreal Engine®, which is
subject to the Unreal Engine® End User License Agreement._

_________________________________________________________________________________________

## Unreal Template Project

### Getting started
To get started with Immersive Stream for XR, you can download this template project that
includes all the required settings for you to start your project.
The project uses [Unreal Engine®](about-unreal) 5.0.3.


### Features
This template project supports the following features:

* Switch between 3D and AR modes.
* Fully customizable UI and events triggered within Unreal Engine®.
* Pre-made events [Trigger in AR,  Trigger in 3D, Switch Background, Switch Map].
* Pre-made client trigger events
  [Switch to AR Mode, Set Share URL, Redirect to URL].
* Fully customizable pre-set gesture controlled camera for 3D mode.
* Touch in world space for 3D and AR.
* Debug mode with toggle stats option.
* Preview support in the editor.
* Asset ID definition to define starting map using the entrypoint URL.
* Upload by running a script [SyncContent.ps1].
* Adaptive lighting in AR mode [Experimental].


### Setup and content overview

The project uses a persistent map, `Main_Persistent`, that includes the assets
and streaming levels required for the experience.

* `XR_Init` blueprint
* `Default_GM` game mode
* `3D_ Default` pawn
* Streaming levels: `Content_Start`, `3D_BG` and `AR_BG` (Find in: `Content/Maps/`)

_Warning: If any of these files are missing in your main persistent map, the
experience won't work correctly. For example, if you don't include the `AR_BG`
streaming level, the AR mode will fail to load._

#### Levels

The project differentiates between content and background streaming levels.
This allows you to separate the content you want to show in AR mode from
the user's camera feed as a background from any 3D background assets that
will not be present in AR.

`Main_Persistent` is set as the starter map and includes asset and background maps as streaming
levels:

<img src="/docs/static/template-starter-map.png" alt="Starter map" width="450">

The asset map, `Content_Start`, includes mesh assets and static lighting.
The background map, `3D_BG`, includes an HDRI dome and a dynamic light source.

With this default setup, in 3D mode the user will see the content of
`3D_BG` + `Content_Start` levels.
In AR mode, we load the `AR_BG` + `Content_Start` levels.

You can add or change backgrounds and content levels as needed to the persistent
level and combine the visibility of these in any way you want as long as the
content and background are in distinct levels, and `AR_BG` is kept as a
streaming level. [Learn more about level switching](#interactions).

_Note: For faster transitions between modes, set all streaming levels to be
initially loaded._

To add streaming maps, include the maps in the list of maps packaged in the
project settings:

<img src="/docs/static/template-map-settings.png" alt="Template settings" width="600">

#### Modes

Immersive Stream for XR supports both 3D and AR modes. There are some differences between their features:

3D mode                | AR mode
-----------------------|------------------------|
Screen space UI        | World space UI         |
Custom camera controls | Pre-set camera controls|
Background switching   | `AR_BG` + camera feed  |

_Note: Creators can choose to load a virtual background in AR mode by adding it to the asset scene._

To add any assets that are only loaded in AR mode, include the assets in the `AR_BG`
level or add triggers in the level blueprint. To trigger an event in 3D mode only,
use the event dispatcher **Trigger in 3D** which is called when the mode is switched:

<img src="/docs/static/template-trigger-3d.png" alt="Trigger in 3D" width="750">

For example, if you want to switch the visibility of the AR world space UI to ON
for AR mode, you can add this event in the `AR_BG` level blueprint.

_Warning: Don't remove the existing assets in the `AR_BG` map or add any dynamic
lights in it._

#### AR Mode

The contents displayed in AR mode only are part of the `AR_BG` level.

Lighting in AR mode is static by default and set to be fixed with the user's environment, even if they rotate the objects.
In the Unreal® Editor, the static lighting blueprint has a skylight and directional light `ARLighting_Static`.

[Android Only] You can use an experimental option (in **XR_Init**, set the **AR_DynamicLighting** value to **true**) to set dynamic lighting that depends on the environment of the camera feed of each user.
When you select this experimental option, the lighting of the AR_BG level in the editor is available for preview purposes only and won't affect the final look in AR if modified.

If you want to enable the controlled dynamic AR lighting, you can set the `AR_DynamicLighting` value to true in `XR_Init`:

<img src="/docs/static/template-turn-on-arlights.png" alt="Turn on controlled AR lighting" width="350">

##### Blueprints

The template project includes the following blueprints that shouldn't be removed or modified:

* `XR_Init`
* `LevelActions`
* `SideChannel`

You can modify the exposed values as needed in the `XR_Init` blueprint:

<img src="/docs/static/template-xrinit.png" alt="Exposed values in XR_Init Blueprint" width="350">

* `Start Level`: Initial content level loaded.
* `Start 3D Background`: Initially loaded background level for 3D mode.
* `Start AR Background`: Default background level for AR mode.
* `Start 3D Pawn`: Initially active pawn in 3D mode.
* `Switch Landscape UI`: Enables UI widget switch when the user's phone orientation changes to landscape.
* `Debug Mode`: Display or hide the toggle stats button in the build.
* `Debug Stats Commands`: List of commands to run when tapping the stats button in debug mode.

#### Debug mode enabled

The scale of the stats screen when debug mode is enabled is determined by the
camera's FOV. The larger the FOV, the smaller the stats. For example, this
capture uses the default value of `40deg`:

<img src="/docs/static/template-debug-mode.png" alt="Experience with debug mode enabled" width="500">

Important: Make sure that the project runs both in 3D and AR modes at ~30fps in
the deployed version. This helps the experience run smoothly and avoid crashes.

#### Game mode

The project uses `Default_GM` as the default game mode, which is required for
the camera and pawn to work correctly in AR and 3D modes.

<img src="/docs/static/template-game-mode.png" alt="Game mode settings" width="350">

Don't change the following values:

* `Default Pawn Class`
* `HUD Class`
* `Player Controller Class`
* `Spectator Class`


### Interactions

#### Touch Events

We support touch events in Unreal Engine®. You can set this up in the
`DefaultInput.ini` config file. The template includes a few examples of touch
events:

*  `TouchExample_BP` has a simple example of how you can set up an event trigger
   by tapping on an object.
*  `3D_DefaultPawn` shows how you can use pinch, tap,
   and slide gestures to control the camera.

#### Server to Client Events

From the Unreal® project on the server side, you can trigger the following events
on the client side:

* `Switch to AR Mode``: Triggers the switch from 3D to AR mode.
* `Set Share URL`: Sets the URL that is shared when triggering the OS share panel.
* `Redirect to URL`: Opens the specified website on the client side.

**Switch to AR Mode** triggers a simplified preview in the Unreal® Editor
and both the **Set Share URL** and **Redirect to URL** events  print out the
specified URL to screen.

You can find examples of how these events are set up in the `3D_UI`
widget blueprint.

<img src="/docs/static/template-touch-events.png" alt="Touch events in 3D_UI blueprint" width="500">

#### Camera controls

We use two different types of camera controls for 3D and AR modes:

* 3D mode uses a custom pawn called `3D_DefaultPawn` that controls the camera
  by default.
* AR mode uses a camera controlled on the client side so you can't modify these
  controls, but you can configure the starting location and orientation. See
  [AR camera customization](ar_camera_customization) for details.

The `3D_DefaultPawn` is set up to orbit around an object and contains a camera
and spring arm.

<img src="/docs/static/template-camera-settings.png" alt="Camera 3d_DefaultPawn customizable settings" width="350">

Some values are exposed for easier customization:

* `Swipe Speed`
* `Pinch Scale`
* `Cam Arm Length`
* `Min Arm Length`
* `Max Arm Length`

To modify the 3D mode camera controls, replace the `3D_DefaultPawn` with the
pawn you want to use in the `Main_Persistent` map and assign it as the
`Start 3D Pawn` in the `XR_Init` Blueprint.

#### AR Camera customization

In AR mode, you can customize:

* `Start location`
* `Start orientation`
* `Teleporting functionality`

To modify the AR start location and orientation, edit the `ARStartAnchor` asset
in the `Main_Persistent` map. You can modify the yaw orientation and XY location
values; however, Z (height) and pitch/roll are restricted.

<img src="/docs/static/template-ar-camera.png" alt="Editing the ARStartAnchor asset" width="350">

In use cases where the world surrounds the user and there is no need
for a pivot point, you can configure teleporting by using the `ARTeleport` function
to move the camera to a given position/orientation by adding a camera in the
scene and inheriting the position/orientation from it. Note that when moving or rotating the object in AR,
the teleport function causes the pivot point of the scene to not coincide with the origin. For example:

<img src="/docs/static/template-ar-camera-blueprint.png" alt="AR Camera blueprint" width="450">

_Note: The preview is for design purposes and will not display the exact camera
pose._

#### Asset and background switch

You can use a pre-made event to switch between maps and backgrounds. Call
`Switch Background` and `Switch Map` events using `LevelActions` as the target
and assign the desired level names:

<img src="/docs/static/template-level-actions.png" alt="Level actions blueprint" width="600">

#### Startup customization

<img src="/docs/static/template-asset-id.png" alt="View in your space option" width="300">

On startup, we pass a customizable parameter from the client-side to
Unreal Engine® that can be used to do the following operations. For example:

* Load different levels per different entry points using a customized intent
  URL.
* Load a configuration from a previous session.
* Show customized messages.

The `SwitchCloudARAssetID` event in the `LevelActions` blueprint is called on
startup with an `AssetID` string parameter equal to the value of the
`cloudARAssetID` intent parameter that you used to launch the experience.

You can preview the value for `cloudArAssetId` above the **View in your space**
button:

In this example, the intent would contain the following:

    intent://arvr.google.com/scene-viewer/...cloudArAssetId=asset-1...;end

In Unreal® Editor, by default the value of the `CloudARAssetID` variable is:
`test-asset`.

This value is set up in the `SwitchCloudARAssetID` event in the `LevelActions`
blueprint:

<img src="/docs/static/template-switchcloudarassetid.png" alt="SwitchCloudARAssetID in the LevelActions Blueprint" width="600">

We added a default behavior that switches the persistent and streaming levels.

* To assign both, use the pattern `cloudArAssetId=PersistentLevel:StreamingLevel`.
* To only change the streaming level, set the value to the streaming level name.

_Warning: In the **Project Settings**, you must add the levels in the maps to
include in packaged build for this to work._

From here, customize the  actions in Unreal Engine® based on the asset
ID received from the intent. You can remove the UI element displaying the
asset ID can be when customizing the content UI.

_Warning: This parameter in the intent is customizable to any value you like, but
it cannot be empty._


### UI Customization

#### Main UI

<img src="/docs/static/template-main-ui.png" alt="Main UI" width="300">

Immersive Stream for XR allows for screen space UI in 3D mode only.
In AR mode, you can add any UI as world space UI, similar to the standard approach to UI in VR games.

The UI works with the [server to client events](#server_to_client_events)
that are set up in Unreal Engine® and all of the UI elements will show up in the
experience.

Everything in the `3D_UI` and `3D_UI_Landscape` widgets will be present in the built experience.

The UI is part of the `Main_UI` widget. This asset has a `UI_Switcher` with the following widgets:
* [0] AR_Editor_Preview_UI
* [1] 3D_UI
* [2] 3D_UI_Landscape

These are toggled depending on the active mode. The logic is present in the `Default_InterfaceHUD`.

#### AR UI in editor preview

<img src="/docs/static/template-in-editor.png" alt="In Editor preview screenshot" width="300">

You can preview the AR UI in the Unreal® Editor viewport by simulating or playing from the `Main_Persistent.umap`
and clicking on the **View in your space** button. Currently the screen space UI in AR mode cannot be modified.

_Note: We start the project with a 500x1000 viewport. Leave this setting
unchanged so you view the experience as close as possible to how a mobile user
would see it in portrait mode. You can add a second viewport that shows the
experience in landscape mode to test how your experience appears in this aspect
ratio._

#### Landscape mode

Immersive Stream for XR is optimized to display experiences in portrait mode on
mobile and desktop devices but can be viewed in landscape aspect ratios as well.

Immersive Stream for XR doesn't support fully responsive UI yet, but you can turn on a
different UI for Landscape aspect ratio.

By default the Landscape UI switch is activated using the `XR_Init` variable
`SwitchLandscapeUI`. When you set this to **true** and the aspect ratio of the screen
exceeds the value of 1, the UI widget switches from `3D_UI` to `3D_UI_Landscape`.
You can do this in the `Default_InterfaceHUD` by using the console variable
`r.C9.FullViewAspectRatio` to react to changes in the aspect ratio.

<img src="/docs/static/template-landscape.png" alt="Landscape mode" width="600">


_______________________________________________________________________________________


## Content guidelines for 3D and AR creators

Immersive Stream for XR currently supports **Unreal Engine**. The recommended
specifications are based on asset integration and development with *Unreal®
version 5.0.3*.

### Recommended specifications

The specifications are selected to guarantee that the assets will render at 30
FPS *and* load in 2 seconds or less when deployed in the cloud.

#### File size

To check the size of your map in Unreal® Editor, use the right-click menu of the
car level umap asset and then select
[Size Map](https://docs.unrealengine.com/en-US/Engine/Basics/AssetsAndPackages/AssetManagement/CookingAndChunking/index.html#sizemap).
Including large assets tends to increase loading times. Enable
streaming for meshes and textures.

Keep asset names to a maximum of 30 characters.

#### Textures

We recommend optimizing the
textures for optimal loading times and rendering performance.

You can use the **Required Texture Resolution** view to analyze the texture size
needs for each asset.

<img src="/docs/static/content-textures.png" alt="Analyzing texture size" width="700">

Bake any textures that you use from
[Substance](https://www.substance3d.com/) or any other dynamic plugins.

#### Materials

##### Translucent materials

Use Surface *ForwardShading* as the lighting mode for translucent materials.

##### Ray tracing

Currently, Immersive Stream for XR does not support ray tracing.

#### Meshes

##### Shadow casting

Leave shadow casting enabled for most meshes, but we recommend that you disable
dynamic shadow casting for smaller meshes when possible.

##### Instancing

Meshes should use instancing as much as possible.

##### Triangle and mesh count

Keep the total triangle count of all meshes and the number of distinct meshes
within a reasonable range. For example, for Automotive projects, we used
17,000,000 triangles or less for LOD 0 and 700,000 or less for LOD 1, with a
mesh count of less than 300. This speeds up model loading times and avoids a
large number of draw calls.

##### Connectivity

Keep repeated vertices to a minimum. In general, the number of vertices per
mesh should be less than 1.75 times the number of triangles. You can check
whether the vertex and triangle count of your original mesh roughly match the
one in Unreal® Editor after importing.

##### LODs

When the total triangle count for all meshes is above the 700,000 limit, high
triangle count meshes can provide both a high (LOD 0) and low detail LOD (LOD
1). LOD1 will be shown initially while LOD0 is streamed in.

* Set the **Screen Size** to 0.0 for LOD 1.
* Set **LOD for collision** to 1.

You can provide a custom, externally generated mesh for LOD 1 or use
[Unreal Engine®'s built-in mesh simplification](https://docs.unrealengine.com/en-US/Engine/Content/Types/StaticMeshes/HowTo/AutomaticLODGeneration/index.html).

#### Adding Videos

The experience is run using Linux and Vulkan, so the supported type of video
formats are:

* Image sequence
* WebM

_Note: Remember to include the movie files during packaging. You can configure
this in the **Project Settings** > **Packaging** section._

<img src="/docs/static/content-movie-files.png" alt="Project Settings for movie files" width="700">

#### Lighting setups

##### 3D mode background levels

Ideally, 3D mode background levels should use one movable `DirectionalLight` and
dynamic shadow casting. The scenes can include an `HDRI_Backdrop`
with a stationary `SkyLight`. In some cases, you can use additional static light
sources that use prebuilt lighting.

##### AR mode background level

Our AR mode background level uses the `ARLighting_Static` blueprint that contains a `Directional Light` and a `Skylight`.
Any modifications made to this blueprint will affect the final look in AR

##### Asset levels

You can add light sources to the asset levels, but these light sources need
to have static mobility and **Cast Shadows** turned off.

#### Orientation

##### Rotation

For the assets to face the camera at the start of the experience when using
the default camera setup,  rotate the assets to face the -X axis. The 3D
default pawn starts with a 45 deg rotation in Z.

#### Optimization

_Note: The optimal values mentioned below do not account for Nanite and Lumen usage._

##### Textures

Make sure the following values are within the bounds listed in the
the following tables:

    Fully Loaded Memory ≤ 1,500,000 KB | Limit total size of all loaded textures.

Make sure that for each texture the following value is within bounds.

    Max dimensions ≤ 4,096x4,096 | Limit the maximum dimensions of each texture.

Make sure that the number of rows (distinct textures) is ≤ 150.

You can view these values for your application by following these steps:

1. In the **Statistics** window, select **Texture Stats** from the drop down menu.
2. Select **All Streaming Levels** in the upper right dropdown.

##### Geometry

Select **Primitive Stats** from the upper left drop down menu in the
**Statistics** window and select **All Objects** in the upper right dropdown.
Make sure the following values are within the bounds listed below in the first
row of the following table:

| <span style="font-weight:400">Count ≤ 300</span>| <span style="font-weight:400">limit the number of unique meshes</span>|
|:-----------------------|:----------------------------------------------|
| Inst Section ≤ 1000    | limit the number of sections within each mesh |
| Sum Tris ≤ 17,000,000  | limit the total triangle count                |
| Avg R ≤ 75             | limit the average mesh bounding sphere radius |

_Note that optimizing one of the requirements above might negatively impact others. It is
important to find a balance such that all values stay within the bounds._

##### Rendering

You can analyze the statistics of a rendered frame in Unreal® Editor. To do so,
position the camera to show the full model. Run the `r.AllowOcclusionQueries
0` console command to avoid GPU object culling. Then run the following console
commands:

    stat RHI

Make sure the counters for *Triangles drawn* are ≤ 35,000,000 and *DrawPrimitive calls* ≤ 1,500.

    stat GPU

Make sure the average timing for the *Basepass* is less than or equal to one third of the entry for *[Total]*.

You can find more information on stat commands in the [Unreal Engine® documentation](https://docs.unrealengine.com/en-US/Engine/Performance/StatCommands/index.html)

#### Asset analysis

To make sure the models are up to the required specifications, you can analyze most of the specifications listed above within Unreal® Editor using the
**Window ￫ Statistics** window or using the **Asset Analysis** tool.

This tool should be loaded by default when opening the template project.
If you don't see the window, you can activate it with the following steps:

    Click Window > Editor Utility Widgets > AssetAnalysis


### Links and resources

#### Automatic LOD generation

To generate the low detail LOD (LOD 1) using the automatic LOD generation
that Unreal Engine® provides, start with a simplification percentage that
generates meshes totalling 500,000 triangles or less. From there, add additional
triangles for meshes with obvious mesh defects. You can check the total
triangle count of a view using the `stat` commands described in the
[Rendering](#rendering) section. To force rendering of LOD 1, you
can set **Forced Lod Model** to 2 on all meshes (don't forget to reset **Forced
Lod Model** to 0 before sharing). For the automatic LOD generation to work
optimally, make sure to merge all duplicate vertices to get a better
representation of the mesh connectivity.


### Limitations

#### Plugins

Immersive Stream for XR currently only supports custom plugins at the Unreal Engine®
project level located in the `Plugins` subfolder.
We support most standard UE5 engine plugins except for the Bridge plugin.
Project plugins either need to be prebuilt for Linux or will be built
as part of building the Content resource you create. The latter requires the upload of the source files of the plugin.

_______________________________________________________________________________________

## Demo Features and Templates

### Overview
The Immersive Stream for XR template project includes some Demos which show how to use some features and offer content specific pre-made experiences examples such as Automotive display.

<img src="/docs/static/demos-start.png" alt="Demos start screen" width="250">

There are two types of demos, `Feature demos` and `Template demos`. All Demo assets can be found in the `Content/Demos` folder.

<img src="/docs/static/demos-folder-structure.png" alt="Demos folder structure" width="350">

To view all demos you can load the `Demos_Persistent` level that contains the necessary UI to switch between demos.
Each feature has its own streaming level within `Demos_Persistent` and each template has its own persistent map ex: `Autos_Template`.

<img src="/docs/static/demos-persistent-structure.png" alt="Persistent level structure" width="350">

The list of features can be found in `Content/Demos/Features/Feature_List`, or looking at the folders in `Content/Demos/Features`.
Templates are all under `Content/Demos/Templates`.

<img src="/docs/static/demos-features-list.png" alt="Features list" width="600">

The main UI for demos is `Demos_UI` and is set in the `XR_Init` BP that is in the `Demos_Persistent` level.
Demos have their own HUD `Demos_InterfaceHUD` and Game Mode `Demos_GM`.

<img src="/docs/static/demos-xrinit.png" alt="Demos XR_Init settings" width="350">

#### Features demos
Features demos include simple demos of specific features. For example, the `Custom 3D Camera` demo shows how to change camera controls.
Each feature has its own streaming level, all loaded in the `Demos_Persistent` level.

<img src="/docs/static/demos-3d-cam.png" alt="Custom 3D camera eature demo" width="250">

#### Templates demos
Each template demo has have its own persistent level that includes streaming levels.
Within the template folder we have a subfolder for each template, for example: `Content/Demos/Templates/Autos`.
The aforementioned folder includes the Assets, Blueprints, Maps and UI folders corresponding to each template.

<img src="/docs/static/demos-template-structure.png" alt="Demos templates folder structure" width="300">

### Autos template

<table>
  <tr>
    <td><img src="/docs/static/demos-autos-start.png" alt="Autos template start screen" width="250"></td>
     <td><img src="/docs/static/demos-autos-start-menu.png" alt="Autos template start screen with the menu expanded" width="250"></td>
  </tr>
</table>

The **Autos template** is designed as a starting point for experiences that display vehicles and provides basic examples on common interactions like the following:
* Exterior color change with simple menu and name display.
* Background toggle between 2 options.
* Hotspots to access interior with fade to black transition.
* Hotspots to open doors or trigger animations.
* Camera transition to interior.
* Camera transition to different angles (interior and exterior).

The **Autos template** includes the following assets:
* Simplified car model.
* Basic materials for car paint switch.
* Two background environments (Studio and Exterior).
* Open door animations.
* Customizable UI.
* Pre-made reusable elements like interactive hotspots.

#### Overview
The content for the Autos template can be found in the `Content/Demos/Templates/Autos` folder.
The main persistent map is `Autos_Template` which includes the following streaming levels:

<img src="/docs/static/demos-autos-levels.png" alt="Autos template streaming levels" width="350">

All of these levels are loaded and only `Dummy_Car` and `3D_BG_Studio` are visible at start.
The `Autos_Template` map has an instance of the `XR_Init` blueprint with the initial settings to load the correct maps and UI.

<img src="/docs/static/demos-autos-xrinit.png" alt="Autos template XR_Init settings" width="350">

#### UI
The Autos template uses the `Autos_UI` widget which includes the initially hidden `Autos_Menu_UI` that is displayed when the `+` button is clicked.
In `Autos_UI` we set any UI changes like `Hotspot mode` and `Interior/Exterior mode`. The difference between modes mainly replaces the `+` button with a `back button`. The _fade in_ and _fade out_ animations between modes are alse set in this widget.

<img src="/docs/static/demos-autos-ui.png" alt="Autos UI" width="600">

#### Pre-made reusable elements

##### Camera Hotspot
Camera hotspots are used to move the camera view to specific areas in the scene. To achieve this we use the `BP_Hotspot_Cam` blueprint.
For example, camera hotspots are used on the car wheels to get a closer view.

`BP_Hotspot_Cam` includes the following components:

<img src="/docs/static/demos-autos-cam-hotspot.png" alt="Camera hotspot blueprint" width="350">

This blueprint uses a mimic of the orbit pawn.
You can modify the following values to better adjust to your content:
* `position`
* `rotation`
* `spring arm length`
* `FOV`
* `camera limits`

<img src="/docs/static/demos-autos-cam-orbit.png" alt="Camera hotspot orbit pawn settings" width="350">

Some of these values are exposed in the blueprint details and others can be modified directly in the components.
To transition to the interior view of the car we use an instance of `BP_Hotspot_Cam` with the hotspot icon disabled
and trigger the switch when the user taps in a screen space UI icon instead.
You can disable the hotspot icon using the exposed variable in the blueprint details:

<img src="/docs/static/demos-autos-interior.png" alt="Transition to car interior hotspot" width="600">

##### Animation Hotspot
Animation hotspots are used to trigger a Skeletal Mesh animation. For this we use the `BP_Hotspot_Anim` blueprint.
For example, animation hotspots are used on the car doors to open them when the hotspot is tapped.

`BP_Hotspot_Anim` includes the following components:

<img src="/docs/static/demos-autos-anim-hotspot.png" alt="Animation hotspot blueprint" width="350">

You can add the `BP_Hotspot_Anim` to the scene and parent it to a socket within your model.
This Hotspot triggers an animation assigned to the linked actor in the blueprint details.

<img src="/docs/static/demos-autos-anim-hotspot-link.png" alt="Linking an actor to the animation hotspot" width="350">

_Note: For this to work the actor to which the blueprint is parented needs to be a Skeletal Mesh._

##### Exterior color change
You can change the car's exterior color by tapping on the car mesh or using the menu.
The color values are defined by the color value of each button in `Autos_Menu_UI`.

<img src="/docs/static/demos-autos-paint-color.png" alt="Car paint color value assignment" width="600">

The color names are defined by the name of each color button in `Autos_Menu_UI`.

<img src="/docs/static/demos-autos-paint-name.png" alt="Car paint color name assignment" width="600">

##### Background change
Background changes are handled by `Autos_Menu_UI` using the `Switch_Background` event from `LevelActions`.

<img src="/docs/static/demos-autos-bg.png" alt="Autos background change" width="450">

##### AR and 3D only triggers
Because we only want the hostposts that change the camera to be only available in 3D mode we added logic in the `AR_BG_Autos` level blueprint that disables and enables them depending on the mode the user is on. Otherwise, everything on the `Dummy_Car` level would be visible and active in AR mode too.

<img src="/docs/static/demos-autos-modes.png" alt="Mode specific triggers" width="600">

_Note: To build and test the Demos the maps need to be included in the project settings.
You can test this by creating the experience link with the `Demos_Persistent:Content_Start` asset ID_

<img src="/docs/static/demos-asset-id.png" alt="Using the Demos asset ID" width="400">
