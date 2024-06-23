# Studio One MMB Drag &amp; Alt+Mousewheel Zoom or Win+Mousewheel Zoom

This AutoHotKey V2 script enables you to use the MMB (Middle Mouse Button) to drag the view of your arrangement, and allows you to use the ALT+MouseWheel or Win+MouseWheel to zoom in and out both horizontally and vertically (sort of like "pinch to zoom"). It comes with a settings screens that allows you to enable/disable certain functionality and to adjust the dragging sensitivity to your liking. It also comes with a "Run at startup" toggle so that you can start it up when your system boots and not have to think about it anymore.

Credits for the dragging part go to the contributers of this Github Repo (https://github.com/lokanchung/StudioPlusOne), which gave me the inspiration to convert it to a V2 AutoHotKey script that also includes a "pinch to zoom" type of zooming using ALT+Mousewheel.

I hope this script is useful to some people. I know that I enjoy using it a lot and hopefully this type of functionality will eventually be added to Studio One natively.

# Windows Only
Unfortunately this is a Windows only solution. Mac users will have to wait until Presonus decides to finally put this functionality within Studio One itself.

# Installation
* Install AutoHotKey V2
* Check out or download this repository
* Double click the .ahk file to start the script. (Choose the version you want. Either Alt+Mousewheel or Win+MouseWheel. The latter is much more responsive)

An alternative is to simply download the executable from the releases (or the exe from the repo itself) and use that compiled .exe file (64 bit windows) so you do not have to install AutoHotKey.

# Caution

After using it a while, the Alt+Mousewheel version can get really slow and clunky to use. This is probably due to the SendInput commands which are waiting for acknowledgement, or some other reason that Studio One slows things down when the ALT key is pressed down. That's why I added a Win+MouseWheel Zoom version as well, which performs pretty good.
