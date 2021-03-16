#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.9.4 (beta)
 Author:         FireFox

 Script Function:
	Displays a MsgBox when the microphone is muted while in a call

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#AutoIt3Wrapper_UseX64=n

#include <Constants.au3>
#include "..\Skype.au3"

Global $oCall = _Skype_CallCreate("echo123")

HotKeySet("{ESC}", "_Exit")

_Skype_OnEventMute("_OnMute")

While 1
    Sleep(1000)
WEnd

Func _OnMute($blMute)
	MsgBox($MB_SYSTEMMODAL, Default, "Muted: " & $blMute)
EndFunc

Func _Exit()
	If _Skype_CallGetStatus($oCall) < $cClsFinished Then _Skype_CallFinish($oCall)
	Exit
EndFunc