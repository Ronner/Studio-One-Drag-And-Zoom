# Studio One Middle Mouse Button Drag &amp; Win+Mousewheel Pinch to Zoom

This AutoHotKey V2 script enables you to use the MMB (Middle Mouse Button) to drag the view of your arrangement, piano-roll etc, and allows you to use the WIN+MouseWheel to zoom horizontally and vertically at the same time (like "pinch to zoom"). Functionality can be enabled/disabled and adjusted using the tray icon. It also comes with a "Run at startup" toggle so that you can start it up when your system boots and not have to think about it anymore.

Credits for the dragging part go to the contributers of this Github Repo: https://github.com/lokanchung/StudioPlusOne

I hope this script is useful to some people. I know that I enjoy using it a lot and hopefully PreSonus will add this type of functionality to Studio One natively.

# Windows Only
Unfortunately this is a Windows only solution. Mac users will have to wait if and until PreSonus decides to put this functionality within Studio One itself.

# Installation

You can install this utility in one of two ways:

## 1. Easiest
Simply download the compiled .exe file from the [releases](https://github.com/Ronner/Studio-One-MMB-Drag-Alt-Mousewheel-Zoom/releases) page and run that (**NB**: It's a 64bit .exe).

## 2. Using AutoHotKey V2 
* Install AutoHotKey V2, which can be downloaded from the official [AutoHotKey.com](https://www.autohotkey.com/) website.
* Check out or download this repository.
* Double click the .ahk file to start the script.

# Caution when dragging on the console!

When using the MMB dragging on the console it has all kinds of side effects. This is due to the fact that to achieve the dragging functionality the script sends mousewheel commands. However, when using mousewheel on the console without shift results in moving faders and other setttings. To still allow MMB dragging on the console, you must keep the WIN key pressed so that the dragging only sends "Shift+Mousewheel" commands to Studio one.
