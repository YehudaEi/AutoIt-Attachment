#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1) ;For multi GUI functions

Global $watchProgress, $watchLbl, $startBtn, $started

_mainGui()

Func _mainGui()
	#Region ### START Koda GUI section ### Form=
	$hiddenFrm = GUICreate("Main Form", 306, 122, 192, 124)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onBtn")
	$watchProgress = GUICtrlCreateProgress(8, 8, 286, 33)
	$watchLbl = GUICtrlCreateLabel("Not started.", 8, 48, 287, 17)
	$startBtn = GUICtrlCreateButton("Start", 8, 72, 291, 41, $WS_GROUP)
	GUICtrlSetOnEvent(-1, "_onBtn")
	GUISetState()
	#EndRegion ### END Koda GUI section ###

	While 1
		If $started = True Then
			For $i = 0 to 100 step 1
				sleep(100)
				GUICtrlSetData($watchProgress, $i & " percent.")
				GUICtrlSetData($watchLbl, $i & " percent.")
			Next
			sleep(500)
			For $i = 100 to 0 step -1
				sleep(100)
				GUICtrlSetData($watchProgress, $i & " percent.")
				GUICtrlSetData($watchLbl, $i & " percent.")
			Next
			sleep(500)
		Else
			Sleep(200)
		EndIf
	WEnd
EndFunc

Func _onBtn()
	Switch @GUI_CTRLID
		Case $startBtn
			$started = True
			GUICtrlSetState($startBtn,$GUI_DISABLE)
		Case $GUI_EVENT_CLOSE
			$started = False
			Exit
	EndSwitch
EndFunc