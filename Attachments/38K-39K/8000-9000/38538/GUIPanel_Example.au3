#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.0
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include "GUIPanel_UDF.au3"

Opt("GUIOnEventMode", 1)

Global $sLogo4imgPath = @ProgramFilesDir & "\AutoIt3\Examples\GUI\logo4.gif"
Global $iPanel1step = 0, $iPanel3step = 0

#region GUI
$GUI = GUICreate("GUIPanel UDF - Example", 400, 350)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUICtrlCreateLabel("Label on the GUI", 300, 320)

#region Panel1
$hPanel1 = _GUICtrlPanel_Create($GUI, "Coords", 10, 40, 200, 50)
_GUICtrlPanel_SetBackground($hPanel1, 0xFF0000)

GUICtrlCreateLabel("Label on the Panel1", 5, 5, 95, 13)

$btnPanel1 = GUICtrlCreateButton("Swap with Panel4", 10, 20, 100, 22)
GUICtrlSetOnEvent($btnPanel1, "_Panel1_BtnEvent")
#endregion Panel1

#region Panel2
$hPanel2 = _GUICtrlPanel_Create($GUI, "BottomLeft", 0, 0, 200, 100, $WS_BORDER, @SW_SHOWNA, 0x00FF00)

GUICtrlCreateLabel("Label on the Panel2", 5, 5, 95, 13)

#region Panel2Sub
$hPanel2Sub = _GUICtrlPanel_Create($hPanel2, "CenterRight", 0, 0, 120, 30, $WS_BORDER, @SW_SHOWNA)

Global $aGUIPanelExample_Panel2SubPos = _GUICtrlPanel_GetPos($hPanel2Sub)
GUICtrlCreateLabel("Pos (X, Y) : " & $aGUIPanelExample_Panel2SubPos[0] & ", " & $aGUIPanelExample_Panel2SubPos[1], 5, 8, 100, 13)
#endregion
#endregion Panel2

#region Panel3
$hPanel3 = _GUICtrlPanel_Create($GUI, "Centered", 0, 0, 169, 68, $WS_BORDER, @SW_SHOWNA, $sLogo4imgPath)

$btnPanel3 = GUICtrlCreateButton("Move me", 10, 10, 70, 22)
GUICtrlSetOnEvent($btnPanel3, "_Panel3_BtnEvent")

GUICtrlCreateCheckbox("no event", 70, 55, 68, 13)
GUICtrlSetBkColor(-1, 0xFFFFFF)
#endregion Panel3

#region Panel4
$hPanel4 = _GUICtrlPanel_Create($GUI, "TopRight", 0, 0, 100, 50, $WS_BORDER)

GUICtrlCreateCombo("Panel4", 10, 10, 80)
#endregion Panel4

GUISetState(@SW_SHOW, $GUI)
#endregion GUI

While 1
	Sleep(1000)
WEnd

Func _Panel3_BtnEvent()
	Switch $iPanel3step
		Case 0
			_GUICtrlPanel_SetPos($hPanel3, "CenterRight")
			GUICtrlSetData($btnPanel3, "Hide me")
		Case 1
			_GUICtrlPanel_SetState($hPanel3, @SW_HIDE)
	EndSwitch

	$iPanel3step += 1
EndFunc   ;==>_Panel3_BtnEvent

Func _Panel1_BtnEvent()
	Switch $iPanel1step
		Case 0
			_GUICtrlPanel_SetPos($hPanel1, "TopRight")
			_GUICtrlPanel_SetPos($hPanel4, "Coords", 10, 40)

			GUICtrlSetData($btnPanel1, "Disable me")
		Case 1
			_GUICtrlPanel_SetState($hPanel1, @SW_DISABLE)
			GUICtrlSetData($btnPanel1, "Disabled")
	EndSwitch

	$iPanel1step += 1
EndFunc   ;==>_Panel1_BtnEvent

Func _Exit()
	Exit
EndFunc   ;==>_Exit