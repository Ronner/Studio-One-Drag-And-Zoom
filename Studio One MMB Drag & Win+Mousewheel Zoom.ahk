Persistent
#SingleInstance Force

SetTitleMatchMode("RegEx")
CoordMode("Mouse", "Screen")

kShift := 0x4
kNone := 0x0
regPath := "HKEY_CURRENT_USER\Software\Studio One MMBDragAndWinZoom"
runRegPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"

sensX := RegRead(regPath, "sensX", 4)
sensY := RegRead(regPath, "sensY", 4)
runOnStartup := RegRead(regPath, "runOnStartup", true)
mmbPanning := RegRead(regPath, "mmbPanning", true)
winMwZoom := RegRead(regPath, "winMwZoom", true)

Tray := A_TrayMenu
Tray.Delete()
Tray.Add("Settings", SettingsGUI)
Tray.Add("Run on startup", ToggleRunOnStartup)
Tray.Add()
Tray.Add("Exit", (*) => ExitApp())
Tray.Default := "Settings"
A_IconTip := "Studio One Middle-Mouse-Button Drag and WIN+MouseWheel Zoom"
TraySetIcon(A_WorkingDir . "\s1+mouse.ico")

If (runOnStartup) {
	Tray.Check("Run on startup")
	RegWrite(A_ScriptFullPath, "REG_SZ", runRegPath, "Studio One MMBDragAndWinZoom")
} else {
	Tray.Uncheck("Run on startup")
	Try RegDelete(runRegPath, "Studio One MMBDragAndWinZoom")
}

SettingsGUI(Item, *) {
	global sensX, sensY, mmbPanning, winMwZoom
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
	ogcCheckboxGuiwinMwZoom := myGui.Add("Checkbox", "vGuiwinMwZoom", "Enable Win+MouseWheel Zoom")
	ogcCheckboxGuiwinMwZoom.Value := winMwZoom
	ogcButtonOK := myGui.Add("Button", "Default", "OK")
	ogcButtonOK.OnEvent("Click", (*) => ButtonOK(myGui, ogcUpDownGuiSensX, ogcUpDownGuiSensY, ogcCheckboxGuiMmbPanning, ogcCheckboxGuiwinMwZoom))
}

ButtonOK(myGui, sensXCtrl, sensYCtrl, mmbPanningCtrl, winMwZoomCtrl, *) {
	global sensX, sensY, mmbPanning, winMwZoom, regPath
	sensX := sensXCtrl.Value
	sensY := sensYCtrl.Value
	mmbPanning := mmbPanningCtrl.Value
	winMwZoom := winMwZoomCtrl.Value

	myGui.Hide()

	RegWrite(sensX, "REG_DWORD", regPath, "sensX")
	RegWrite(sensY, "REG_DWORD", regPath, "sensY")
	RegWrite(mmbPanning, "REG_DWORD", regPath, "mmbPanning")
	RegWrite(winMwZoom, "REG_DWORD", regPath, "winMwZoom")
	return
}

ToggleRunOnStartup(Item, *) {
	global runOnStartup, runRegPath
	runOnStartup := !runOnStartup
	If (runOnStartup) {
		Tray.Check("Run on startup")
		RegWrite(A_ScriptFullPath, "REG_SZ", runRegPath, "Studio One MMBDragAndWinZoom")
	} Else {
		Tray.Uncheck("Run on startup")
		RegDelete(runRegPath, "Studio One MMBDragAndWinZoom")
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

A_MenuMaskKey := "vkE8"

#HotIf CheckWin() and winMwZoom
#WheelDown:: {
	CoordMode("Mouse", "Screen")
	MouseGetPos(&mX, &mY, &tWnd)
	PostMessage(0x20A, -40 << 16 | 0x8 , mY << 16 | mX, , "ahk_id " tWnd)
	PostMessage(0x20A, -40 << 16 | 0xc , mY << 16 | mX, , "ahk_id " tWnd)
}

#WheelUp:: {
	CoordMode("Mouse", "Screen")
	MouseGetPos(&mX, &mY, &tWnd)
	PostMessage(0x20A, 40 << 16 | 0x8, mY << 16 | mX, , "ahk_id " tWnd)
	PostMessage(0x20A, 40 << 16 | 0xc, mY << 16 | mX, , "ahk_id " tWnd)
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
