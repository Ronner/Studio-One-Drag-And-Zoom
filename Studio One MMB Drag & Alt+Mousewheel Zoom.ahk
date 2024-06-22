Persistent
#SingleInstance Force

SetTitleMatchMode("RegEx")
CoordMode("Mouse", "Screen")

kShift := 0x4
kControl := 0x8
kNone := 0x0
regPath := "HKEY_CURRENT_USER\Software\Studio One MMBDragAndAltZoom"
runRegPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"

sensX := RegRead(regPath, "sensX", 4)
sensY := RegRead(regPath, "sensY", 4)
runOnStartup := RegRead(regPath, "runOnStartup", true)
mmbPanning := RegRead(regPath, "mmbPanning", true)
altMwZoom := RegRead(regPath, "altMwZoom", true)

Tray := A_TrayMenu
Tray.Delete()
Tray.Add("Settings", SettingsGUI)
Tray.Add("Run on startup", ToggleRunOnStartup)
Tray.Add()
Tray.Add("Exit", (*) => ExitApp())
Tray.Default := "Settings"
A_IconTip := "Studio One Middle-Mouse-Button Drag and ALT+MouseWheel Zoom"
TraySetIcon(A_WorkingDir . "\s1+mouse.ico")

If (runOnStartup) {
	Tray.Check("Run on startup")
	RegWrite(A_ScriptFullPath, "REG_SZ", runRegPath, "Studio One MMBDragAndAltZoom")
} else {
	Tray.Uncheck("Run on startup")
	Try RegDelete(runRegPath, "Studio One MMBDragAndAltZoom")
}
return

SettingsGUI(Item, *) {
	global sensX, sensY, mmbPanning, altMwZoom
	myGui := Gui()
	myGui.Show("W240 H180")
	myGui.Add("Text", , "Sensitivity X:")
	ogcGuiSensXEdit := myGui.Add("Edit", "vGuiSensXEdit")
	ogcUpDownGuiSensX := myGui.Add("UpDown", "vGuiSensX Range1-50", sensX)
	myGui.Add("Text", , "Sensitivity Y:")
	ogcGuiSensYEdit := myGui.Add("Edit", "vGuiSensYEdit")
	ogcUpDownGuiSensY := myGui.Add("UpDown", "vGuiSensY Range1-50", sensY)
	ogcCheckboxGuiMmbPanning := myGui.Add("Checkbox", "vGuiMmbPanning", "Enable Middle Mouse Button Panning")
	ogcCheckboxGuiMmbPanning.Value := mmbPanning
	ogcCheckboxGuiAltMwZoom := myGui.Add("Checkbox", "vGuiAltMwZoom", "Enable Alt+MouseWheel Zoom")
	ogcCheckboxGuiAltMwZoom.Value := altMwZoom
	ogcButtonOK := myGui.Add("Button", "Default", "OK")
	ogcButtonOK.OnEvent("Click", (*) => ButtonOK(myGui, ogcUpDownGuiSensX, ogcUpDownGuiSensY, ogcCheckboxGuiMmbPanning, ogcCheckboxGuiAltMwZoom))
}

ButtonOK(myGui, sensXCtrl, sensYCtrl, mmbPanningCtrl, altMwZoomCtrl, *) {
	global sensX, sensY, mmbPanning, altMwZoom, regPath
	sensX := sensXCtrl.Value
	sensY := sensYCtrl.Value
	mmbPanning := mmbPanningCtrl.Value
	altMwZoom := altMwZoomCtrl.Value

	myGui.Hide()

	RegWrite(sensX, "REG_DWORD", regPath, "sensX")
	RegWrite(sensY, "REG_DWORD", regPath, "sensY")
	RegWrite(mmbPanning, "REG_DWORD", regPath, "mmbPanning")
	RegWrite(altMwZoom, "REG_DWORD", regPath, "altMwZoom")
	return
}

ToggleRunOnStartup(Item, *) {
	global runOnStartup, runRegPath
	runOnStartup := !runOnStartup
	If (runOnStartup) {
		Tray.Check("Run on startup")
		RegWrite(A_ScriptFullPath, "REG_SZ", runRegPath, "Studio One MMBDragAndAltZoom")
	} Else {
		Tray.Uncheck("Run on startup")
		RegDelete(runRegPath, "Studio One MMBDragAndAltZoom")
	}
	RegWrite(runOnStartup, "REG_DWORD", regPath, "runOnStartup")
}

CheckWin() {
	MouseGetPos(, , &wnd)
	exe := WinGetProcessName("ahk_id " wnd)
	exe := StrLower(exe)

	Return (exe = "studio one.exe")
}

#HotIf CheckWin() and mmbPanning
MButton:: {
	global lastX, lastY, startX, startY, dragWnd, sensX, sensY, kShift, kNone
	MouseGetPos(&lastX, &lastY)
	MouseGetPos(&startX, &startY, &dragWnd)
	SetTimer(Timer, 10)
	return
}

MButton Up:: {
	SetTimer(Timer, 0)
	If (not mmbPanning) {
		Send("{MButton Up}")
	}
	return
}
#HotIf

#HotIf CheckWin() and altMwZoom
!WheelDown:: {
	SendInput("^{WheelDown}")
	Sleep(20)
	SendInput("^+{WheelDown}")
	return
}

!WheelUp:: {
	SendInput("^{WheelUp}")
	Sleep(20)
	SendInput("^+{WheelUp}")
	return
}
#HotIf

PostMW(hWnd, delta, modifiers, x, y) {
	CoordMode("Mouse", "Screen")
	lowOrderX := x & 0xFFFF
	highOrderY := y & 0xFFFF
	PostMessage(0x20A, delta << 16 | modifiers, highOrderY << 16 | lowOrderX, , "ahk_id " hWnd)
}

Timer() {
	global lastX, lastY, startX, startY, dragWnd, sensX, sensY, kShift, kNone
	MouseGetPos(&curX, &curY)
	dX := (curX - lastX)
	dY := (curY - lastY)
	scrollX := dX * sensX
	scrollY := dY * sensY

	If (dX != 0) {
		PostMW(dragWnd, scrollX, kShift, startX, startY)
	}

	If (dY != 0) {
		PostMW(dragWnd, scrollY, kNone, startX, startY)
	}

	lastX := curX
	lastY := curY
	return
}
