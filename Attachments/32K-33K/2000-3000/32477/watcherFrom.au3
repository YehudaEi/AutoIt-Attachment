#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1) ;For multi GUI functions

Global $watcherFrm

$started = True

_mainGui()

Func _mainGui()
	$watcherFrm = GUICreate("Watcher From", 296, 34, 549, 224)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onBtn")
	$Label1 = GUICtrlCreateLabel("Label1", 8, 8, 280, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetOnEvent(-1, "_onBtn")
	GUISetState()

	While 1
		If $started = True Then
			If WinExists('Main Form', '') Then
;~ 		 		WinSetState("Progress Meter", "", @SW_HIDE)
				GUICtrlSetData($Label1,ControlGetText("Main Form","","[CLASS:Static; INSTANCE:1]"))
			Else
				GUICtrlSetData($Label1,'Main Form does not exist!')
			EndIf
			Sleep(500)
		Else
			Sleep(200)
		EndIf
	WEnd
EndFunc

Func _onBtn()
	Switch @GUI_CTRLID
		Case $GUI_EVENT_CLOSE
			$started = False
			Exit
	EndSwitch
EndFunc
