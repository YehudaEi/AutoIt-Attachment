#include-once

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>

Global Const $EN_CHANGE = -2; since I couldn't find something like this in the include files (this variable was used in the autoit wiki, where is it?)
							; so I created a manual system- the event occurs when the value of a control changes. the value is stored at $avCallbacks[$i][5]

Global $avCallbacks[1][6]
Global $boolPassEvent = False; Enable this option if you want autoit to process the window message after these functions are done with it.
								   ; If you are not using GUIGetMsg then this should probably stay as false. Default is false.

GUIRegisterMsg($WM_COMMAND, "__MY_WM_COMMAND")

Func _GUICtrlSetOnEvent($hControl, $sCallback, $boolPassParam = False, $Param = 0, $iEvent = -1)
	Local $iIndex = UBound($avCallbacks)
	ReDim $avCallbacks[$iIndex + 1][6]

	$avCallbacks[$iIndex][0] = $hControl; save the control id
	$avCallbacks[$iIndex][1] = $sCallback; save the callback function

	If $iEvent = 0 Then
		$avCallbacks[$iIndex][2] = $iEvent; save a particular event that the callback function should be called on.
									  ; if left at 0 then the function will be called on all events.

	ElseIf $iEvent = $EN_CHANGE Then
		$avCallbacks[$iIndex][2] = $EN_CHANGE
		$avCallbacks[$iIndex][5] = GUICtrlRead($hControl)
	ElseIf IsString($iEvent) Then; incase a control type was supplied to automatically find a 'default' event
		Switch $iEvent
			Case "button", "checkbox", "graphic", "icon", "label", "listview", "obj", "pic", "progress", "radio", "slider"
				$avCallbacks[$iIndex][2] = $NM_CLICK

			Case "listviewitem"
				$avCallbacks[$iIndex][2] = $NM_DBLCLK

			Case "input", "edit", "combo", "tab"
				$avCallbacks[$iIndex][2] = $EN_CHANGE
				$avCallbacks[$iIndex][5] = GUICtrlRead($hControl)

		EndSwitch
	EndIf



	$avCallbacks[$iIndex][3] = $boolPassParam; save whether or not to pass a parameter to the callback function
	$avCallbacks[$iIndex][4] = $Param; save the parameter to pass
EndFunc

Func _setBoolPassEvent($boolNewValue); so that users can change this without having to edit this file every time they use it.
	$boolPassEvent = $boolNewValue; set the new value
EndFunc

Func __MY_WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	Local $iControlId = BitAND($wParam, 0xFFFF); the control id that triggered the event
	Local $iCode = BitShift($wParam, 16); the code (or type) of event that was triggered

	Local $iEventIndex = __isRegisteredControl($iControlId, $iCode); this is the index of the event in $avCallbacks

	If $iEventIndex Then; if the control is registered
		If $avCallbacks[$iEventIndex][3] Then; if it is specified to pass a parameter
			Call($avCallbacks[$iEventIndex][1], $avCallbacks[$iEventIndex][4])
		Else; it is specified to NOT pass a parameter
			Call($avCallbacks[$iEventIndex][1])
		EndIf
	EndIf

	If $boolPassEvent Then; if it is specified to allow autoit to process the event
		Return $GUI_RUNDEFMSG; allow autoit to process the event
	Else
		Return; otherwise don't allow autoit to process the event
	EndIf
EndFunc

Func __isRegisteredControl($iControlId, $iCode); tests to see if the control is registered, and with the supplied event code (if appliacable)
	For $i = 0 To UBound($avCallbacks) - 1
		If $avCallbacks[$i][0] = $iControlId Then
			If $avCallbacks[$i][2] <> 0 Then; if there is a particular event that was registered
				If $avCallbacks[$i][2] = $EN_CHANGE Then; specified event is a change in value
					If GUICtrlRead($iControlId) <> $avCallbacks[$i][5] Then
						$avCallbacks[$i][5] = GUICtrlRead($iControlId)
						Return $i
					Else
						ContinueLoop; the event did not occur so keep looping to see if it was registered more than once with another event
					EndIf
				ElseIf $avCallbacks[$i][2] = $iCode Then; test and see if the event is the registered one
					Return $i; the event is the registered code
				Else
					ContinueLoop; the event is not the registered code so keep looping to see if it was registered more than once with another event
				EndIf
			Else; no particular event was registered so any event works
				Return $i
			EndIf
		EndIf
	Next
	Return 0; the control id of the event was not registered
EndFunc
