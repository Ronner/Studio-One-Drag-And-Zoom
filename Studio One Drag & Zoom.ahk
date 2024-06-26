Persistent
#SingleInstance Force
SetTitleMatchMode("RegEx")
kShift := 0x4
kCtrl := 0x8
kCtrlShift := 0xc
kNone := 0x0
A_IconTip := "Studio One Drag and Zoom"
A_AllowMainWindow := 0
regName := "Studio One Drag and Zoom"
regPath := "HKEY_CURRENT_USER\Software\" . regName
runRegPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
dragSensX := RegRead(regPath, "dragSensX", 4)
dragSensY := RegRead(regPath, "dragSensY", 4)
runOnStartup := RegRead(regPath, "runOnStartup", true)
dragEnabled := RegRead(regPath, "dragEnabled", true)
switchMouseButtons := RegRead(regPath, "switchMouseButtons", false)
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
dragEnabledText := "Dragging enabled"
mwZoomEnabledText := "Mousewheel zoom enabled"
switchMouseButtonsText := "Horizontal only on left mouse button"

A_TrayMenu.Delete()
A_TrayMenu.Add(runOnStartupText, ToggleSetting)
A_TrayMenu.Add()
A_TrayMenu.Add(dragEnabledText, ToggleSetting)
A_TrayMenu.Add("Drag sensitivity X", DragSensXSubmenu)
A_TrayMenu.Add("Drag sensitivity Y", DragSensYSubmenu)
A_TrayMenu.Add(switchMouseButtonsText, ToggleSetting)
A_TrayMenu.Add()
A_TrayMenu.Add(mwZoomEnabledText, ToggleSetting)
A_TrayMenu.Add("Zoom sensitivity", ZoomSensSubmenu)
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())

if FileExist(A_WorkingDir . "\s1+mouse.ico")
	TraySetIcon(A_WorkingDir . "\s1+mouse.ico")

SaveSettings()

ToggleSetting(menuItem, *) {
	global runOnStartup, dragEnabled, mwZoomEnabled

	If (menuItem = runOnStartupText)
		runOnStartup := !runOnStartup

	If (menuItem = dragEnabledText)
		dragEnabled := !dragEnabled

	If (menuItem = mwZoomEnabledText)
		mwZoomEnabled := !mwZoomEnabled

	If (menuItem = switchMouseButtonsText)
		switchMouseButtons := !switchMouseButtons

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
	RegWrite(dragEnabled, "REG_DWORD", regPath, "dragEnabled")
	RegWrite(switchMouseButtons, "REG_DWORD", regPath, "switchMouseButtons")
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

	If (dragEnabled) {
		A_TrayMenu.Check(dragEnabledText)
		A_TrayMenu.Enable("Drag sensitivity X")
		A_TrayMenu.Enable("Drag sensitivity Y")
	}
	Else {
		A_TrayMenu.Uncheck(dragEnabledText)
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

HandleDragButton(ignoreY) {
	global lastX, lastY, startX, startY, s1Window, ignoreYEnabled
	ignoreYEnabled := ignoreY
	MouseGetPos(&startX, &startY, &s1Window)
	lastX := startX
	lastY := startY
	SetTimer(Timer, 10)
}

ReleaseDragButton() {
	SetTimer(Timer, 0)
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

	If (dY != 0 && !ignoreYEnabled) {
	 	PostMW(scrollY, kNone, startX, startY)
	}

	lastX := curX
	lastY := curY
}

#HotIf CheckWin() and dragEnabled
#LButton::HandleDragButton(switchMouseButtons)
#RButton::HandleDragButton(!switchMouseButtons)
#LButton Up::ReleaseDragButton()
#RButton Up::ReleaseDragButton()
#HotIf

#HotIf CheckWin() and mwZoomEnabled
#WheelDown::HandleMouseWheel(-mwZoomSens)
#WheelUp::HandleMouseWheel(mwZoomSens)
#HotIf
