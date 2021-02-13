#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.4.0
	Author:         FireFox

	Script Function:
	Answer call automatically and join calls if you're already in a call

#ce ----------------------------------------------------------------------------
#include "..\Skype.au3"

Local $oMainCall = ""

Local $aCall = _Skype_CallGetActive()
If IsArray($aCall) Then $oMainCall = $aCall[0] ;if a call is running then set it as main call

_Skype_SetSilentMode(True) ;Disable all skype windows

_Skype_OnEventCallStatus("_CallIncomming", $cClsRinging) ;if someone is calling you
_Skype_OnEventCallStatus("_CallFinished", $cClsFinished) ;if a call has finished

While 1
	Sleep(60000)
WEnd

Func _CallIncomming($oCall)
	Local $TCallType = _Skype_CallGetType($oCall)

	If ($TCallType = $cCltIncomingP2P) Or ($TCallType = $cCltIncomingPSTN) Then ;if it's a valid incomming call
		If IsObj($oMainCall) Then ;if a call is running then join the incomming call to the main call
			_Skype_CallJoin($oMainCall, $oCall)
		Else ;else answer
			_Skype_CallAnswer($oCall)
		EndIf
		$oMainCall = $oCall ;set the current call as the main call
	EndIf
EndFunc

Func _CallFinished($oCall)
	Local $aCall = _Skype_CallGetActive()

	If IsArray($aCall) Then ;if a call is running then set it as main call
		$oMainCall = $aCall[0]
	Else ;else no call running
		$oMainCall = ""
	EndIf
EndFunc
