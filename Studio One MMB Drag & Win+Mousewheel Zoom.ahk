Persistent
#SingleInstance Force
SetTitleMatchMode("RegEx")
kShift := 0x4
kCtrl := 0x8
kCtrlShift := 0xc
kNone := 0x0
A_IconTip := "Studio One Middle-Mouse-Button Drag and MouseWheel Zoom"
regName := "Studio One MMBDragAndWheelZoom"
regPath := "HKEY_CURRENT_USER\Software\" . regName
runRegPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
dragSensX := RegRead(regPath, "dragSensX", 4)
dragSensY := RegRead(regPath, "dragSensY", 4)
runOnStartup := RegRead(regPath, "runOnStartup", true)
mmbDragEnabled := RegRead(regPath, "mmbDragEnabled", true)
mwZoomEnabled := RegRead(regPath, "mwZoomEnabled", true)
mwZoomSens := RegRead(regPath, "mwZoomSens", 100)

sensOptions := ["Lowest", "Lower", "Low", "Default", "Fast", "Faster", "Fastest"]
mwZoomSensValues := [10, 20, 35, 50, 80, 100, 150]

DragSensXSubmenu := Menu()
DragSensYSubmenu := Menu()
ZoomSensSubmenu := Menu()

Loop sensOptions.Length {
	DragSensXSubmenu.Add(sensOptions[A_Index], SensitivityMenuItemHandler)
	DragSensYSubmenu.Add(sensOptions[A_Index], SensitivityMenuItemHandler)
	ZoomSensSubmenu.Add(sensOptions[A_Index], SensitivityMenuItemHandler)
}

runOnStartupText := "Run on startup"
mmbDragEnabledText := "Middle Mouse Button Drag enabled"
mwZoomEnabledText := "Mousewheel zoom enabled"

A_TrayMenu.Delete()
A_TrayMenu.Add(runOnStartupText, ToggleSetting)
A_TrayMenu.Add()
A_TrayMenu.Add(mmbDragEnabledText, ToggleSetting)
A_TrayMenu.Add("Drag sensitivity X", DragSensXSubmenu)
A_TrayMenu.Add("Drag sensitivity Y", DragSensYSubmenu)
A_TrayMenu.Add()
A_TrayMenu.Add(mwZoomEnabledText, ToggleSetting)
A_TrayMenu.Add("Zoom sensitivity", ZoomSensSubmenu)
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())

if FileExist(A_WorkingDir . "\s1+mouse.ico")
	TraySetIcon(A_WorkingDir . "\s1+mouse.ico")

SaveSettings()

ToggleSetting(menuItem, *) {
	global runOnStartup, mmbDragEnabled, mwZoomEnabled

	If (menuItem = runOnStartupText)
		runOnStartup := !runOnStartup

	If (menuItem = mmbDragEnabledText)
		mmbDragEnabled := !mmbDragEnabled

	If (menuItem = mwZoomEnabledText)
		mwZoomEnabled := !mwZoomEnabled

	SaveSettings()
}

SensitivityMenuItemHandler(Item, ItemPos, TheMenu) {
	global dragSensX, dragSensY, mwZoomSens
	dragSensX := (TheMenu = DragSensXSubmenu) ? ItemPos : dragSensX
	dragSensY := (TheMenu = DragSensYSubmenu) ? ItemPos : dragSensY
	mwZoomSens := (TheMenu = ZoomSensSubmenu) ? mwZoomSensValues[ItemPos] : mwZoomSens
	SaveSettings()
}

SaveSettings() {
	RegWrite(runOnStartup, "REG_DWORD", regPath, "runOnStartup")
	RegWrite(dragSensX, "REG_DWORD", regPath, "dragSensX")
	RegWrite(dragSensY, "REG_DWORD", regPath, "dragSensY")
	RegWrite(mmbDragEnabled, "REG_DWORD", regPath, "mmbDragEnabled")
	RegWrite(mwZoomEnabled, "REG_DWORD", regPath, "mwZoomEnabled")
	RegWrite(mwZoomSens, "REG_DWORD", regPath, "mwZoomSens")

	If (runOnStartup)
		RegWrite(A_ScriptFullPath, "REG_SZ", runRegPath, regName)
	Else
		Try RegDelete(runRegPath, regName)

	UpdateMenuState()
}

UpdateMenuState() {
	If (runOnStartup)
		A_TrayMenu.Check(runOnStartupText)
	Else
		A_TrayMenu.Uncheck(runOnStartupText)

	If (mmbDragEnabled) {
		A_TrayMenu.Check(mmbDragEnabledText)
		A_TrayMenu.Enable("Drag sensitivity X")
		A_TrayMenu.Enable("Drag sensitivity Y")
	}
	Else {
		A_TrayMenu.Uncheck(mmbDragEnabledText)
		A_TrayMenu.Disable("Drag sensitivity X")
		A_TrayMenu.Disable("Drag sensitivity Y")
	}

	If (mwZoomEnabled) {
		A_TrayMenu.Check(mwZoomEnabledText)
		A_TrayMenu.Enable("Zoom sensitivity")
	}
	Else {
		A_TrayMenu.Uncheck(mwZoomEnabledText)
		A_TrayMenu.Disable("Zoom sensitivity")
	}

	Loop sensOptions.Length {
		DragSensXSubmenu.Uncheck(sensOptions[A_Index])
		DragSensYSubmenu.Uncheck(sensOptions[A_Index])
		ZoomSensSubmenu.Uncheck(sensOptions[A_Index])
	}

	DragSensXSubmenu.Check(sensOptions[dragSensX])
	DragSensYSubmenu.Check(sensOptions[dragSensY])

	For i, v in mwZoomSensValues {
		if (v = mwZoomSens)
			ZoomSensSubmenu.Check(sensOptions[i])
	}
}

CheckWin() {
	MouseGetPos(, , &wnd)
	exe := WinGetProcessName("ahk_id " wnd)
	Return (StrLower(exe) = "studio one.exe")
}

HandleMiddleButton() {
	global lastX, lastY, startX, startY, s1Window, winKeyPressed
	winKeyPressed := GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
	MouseGetPos(&startX, &startY, &s1Window)
	lastX := startX
	lastY := startY
	SetTimer(Timer, 10)
}

ReleaseMiddleButton() {
	SetTimer(Timer, 0)
	If (not mmbDragEnabled) {
		Send("{MButton Up}")
	}
}

HandleMouseWheel(delta) {
	global s1Window
	MouseGetPos(&mX, &mY, &s1Window)
	PostMW(delta, kCtrl, mX, mY)
	PostMW(delta, kCtrlShift, mX, mY)
}

PostMW(delta, modifiers, x, y) {
	; global s1Window
	CoordMode("Mouse", "Screen")
	lowOrderX := x & 0xFFFF
	highOrderY := y & 0xFFFF
	PostMessage(0x20A, delta << 16 | modifiers, highOrderY << 16 | lowOrderX, , "ahk_id " s1Window)
}

Timer() {
	global lastX, lastY
	MouseGetPos(&curX, &curY)
	dX := (curX - lastX)
	dY := (curY - lastY)
	scrollX := dX * dragSensX
	scrollY := dY * dragSensY

	If (dX != 0) {
		PostMW(scrollX, kShift, startX, startY)
	}

	If (dY != 0 && !winKeyPressed) {
		PostMW(scrollY, kNone, startX, startY)
	}

	lastX := curX
	lastY := curY
}

#HotIf CheckWin() and mmbDragEnabled
MButton::HandleMiddleButton()
#MButton::HandleMiddleButton()
MButton Up::ReleaseMiddleButton()
#MButton Up::ReleaseMiddleButton()
#HotIf

#HotIf CheckWin() and mwZoomEnabled
#WheelDown::HandleMouseWheel(-mwZoomSens)
#WheelUp::HandleMouseWheel(mwZoomSens)
#HotIf
