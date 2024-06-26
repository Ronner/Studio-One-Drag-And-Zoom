# Studio One Drag &amp; Zoom
This AutoHotKey V2 script enables you to use the WIN+MouseButton(s) to drag the view of your arrangement, piano-roll etc, and allows you to use the WIN+MouseWheel to zoom horizontally and vertically at the same time (like "pinch to zoom"). Functionality can be enabled/disabled and adjusted using the tray icon by right clicking on the tray icon. It also comes with a "Run at startup" toggle so that you can start it up when your system boots and not have to think about it anymore.

![StudioOneDragAndZoom](https://github.com/Ronner/Studio-One-Drag-And-Zoom/assets/2070774/6f7d3ac3-95e8-4a05-b7fc-cb96f56b8a22)

Credits for the dragging part go to the contributers of this Github Repo: https://github.com/lokanchung/StudioPlusOne

# Horizontal dragging only
When using WIN+RightMouseButton you will drag horizontally only. This should be used on the mixer/console because otherwise it has side effects. See the caution below why that is. If you prefer to have the "horizontal-only dragging" on the left mouse button and "both directions dragging" on the right mouse button, you can change that in the settings from the tray menu by selecting "Horizontal only on left mouse button"

# Caution when dragging on the console!
When using the drag functionality on the mixer/console, make sure to use WIN + RightMouseButton, otherwise it has all kinds of side effects. This is due to the fact that to achieve the dragging functionality the script sends mousewheel commands to Studio One. However, when using the mousewheel on the mixer/console without shift, it can result in moving faders and other setttings.

# Windows Only
Unfortunately this is a Windows only solution. Mac users will have to wait and see if PreSonus decides to put this type of functionality within Studio One itself. I sure hope they do so we do not have to resort to scripted workarounds like this.

# Installation
You can install this utility in one of two ways:

## 1. Easiest
Simply download the latest compiled .exe file from the [releases](https://github.com/Ronner/Studio-One-Drag-And-Zoom/releases) page and run that (**NB**: It's a 64bit .exe).

## 2. Using AutoHotKey V2 
* Install AutoHotKey V2, which can be downloaded from the official [AutoHotKey.com](https://www.autohotkey.com/) website.
* Check out or download this repository.
* Double click the .ahk file to start the script.

# Accessing the settings

Running either the .exe or the .ahk file will not popup a program window. The only thing that is added is this tray icon (2nd icon from the left):

![image](https://github.com/Ronner/Studio-One-Drag-And-Zoom/assets/2070774/6f8a1a85-489c-446c-a553-ff459d73b834)

If you do not see this icon, click on the "arrow up" icon on the left to show all tray icons available.

Simply rightclick on this icon to show the settings menu.

![image](https://github.com/Ronner/Studio-One-Drag-And-Zoom/assets/2070774/b226d1fc-1e03-4d1f-aa42-a002ac19bfde)
