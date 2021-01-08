; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function:
;	RegisteredOwner for Windows XP --> change
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>

;GUI
$GUI = GUICreate("Change RegisteredOwner", 170, 200, 200, 200)

;Label
$RegisteredOwner_L = GUICtrlCreateLabel("RegisteredOwner", 10, 10, 150, 17)
$NewRegisteredOwner_L = GUICtrlCreateLabel("Type: New RegisteredOwner", 10, 70, 150, 17)
$status_L = GUICtrlCreateLabel("Status", 10, 170, 150, 17, $SS_SUNKEN)

;Input
$RegisteredOwner_I = GUICtrlCreateInput("RegisteredOwner", 10, 30, 150, 17)
$NewRegisteredOwner_I = GUICtrlCreateInput("New RegisteredOwner", 10, 90, 150, 17)

;Button
$ok = GUICtrlCreateButton("Change RegisteredOwner", 10, 120, 150, 23)

;Variable
Dim $count = 0
Dim $key4RegisteredOwner = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
GUICtrlSetData($RegisteredOwner_I, RegRead($key4RegisteredOwner, "RegisteredOwner"))

;TrayIconToolTip
TraySetToolTip("Change RegisteredOwner")

GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	If $count < 1 Then
		Sleep(2000)
		GUICtrlSetData($status_L, "ready...")
		$count += 1
	EndIf
	Select
		Case $msg = $GUI_EVENT_CLOSE
			GUICtrlSetData($status_L, "So long, Mega")
			Sleep(1000)
			ExitLoop
		Case $msg = $ok
			$status = RegWrite($key4RegisteredOwner, "RegisteredOwner", "REG_SZ", ControlGetText("", "", $NewRegisteredOwner_I))
			If $status = 1 Then
				GUICtrlSetData($status_L, "changed successfully...")
				Sleep(1000)
				GUICtrlSetData($status_L, "ready...")
			Else
				GUICtrlSetData($status_L, "Error...")
			EndIf
	EndSelect
WEnd
Exit