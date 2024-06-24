# Studio One MMB Drag &amp; Win+Mousewheel Zoom or Alt+Mousewheel Zoom

This AutoHotKey V2 script enables you to use the MMB (Middle Mouse Button) to drag the view of your arrangement, and allows you to use the WIN+MouseWheel or ALT+MouseWheel to zoom both horizontally and vertically (like "pinch to zoom"). It comes with a settings screens that allows you to enable/disable certain functionality and to adjust the dragging sensitivity to your liking. It also comes with a "Run at startup" toggle so that you can start it up when your system boots and not have to think about it anymore.

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
  * You can also download only the .ahk file of the WIN or ALT version. In that case you also need to download the s1+mouse.ico file and put it in the same directory as the .ahk file.
* Double click the WIN or ALT .ahk file to start the script. The WIN+Mousewheel version works much better, so I would advise to use that one.

# Caution

The Alt+Mousewheel version can get really slow and clunky to use. This is probably due to the SendInput commands waiting for acknowledgement from Studio One, or some other reason that Studio One slows things down when the ALT key is pressed down. The WIN+Mousewheel version does not have this problem and performs way better.
