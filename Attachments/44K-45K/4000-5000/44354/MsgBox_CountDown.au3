#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>

Local $iResult = MsgBox_CountDown("Failure", "Restarting process within", 10)
If $iResult = $IDOK Then
	ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : OK Pressed" & @CRLF)
ElseIf $iResult = $IDTIMEOUT Then
	ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : Timeout" & @CRLF)
Else
	ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : Cancel Pressed" & @CRLF)
EndIf

; #FUNCTION# ================================================================================
; Name...........: MsgBox_CountDown
; Description ...: MsgBox with visual CountDown
; Syntax.........: MsgBox_CountDown($sTitle, $sMessage, $iTimeOut = 30, $hWnd = 0)
; Parameters ....: $sTitle - The title of the message box
;				   $sMessage - The text of the message box
;				   $iTimeOut - Optional - Timeout in seconds
;				   $hWnd - Optional - The window handle to use as the parent for this dialog.
; Return values .: Success - Following return codes:
;						OK : $IDOK (1)
;				   		Timeout : $IDTIMEOUT (-1)
;                  		Cancel : $IDCANCEL (2)
;                  Failure - Returns @Error:
;				   |1 - Erroneous Timout value, should be higher than 0
; Author ........: GreenCan
; Modified.......:
; Remarks .......: Not meant as a replacement of MsgBox
; Related .......:
; Link ..........:
; Example .......: No
; ===========================================================================================
Func MsgBox_CountDown($sTitle, $sMessage, $iTimeOut = 30, $hWnd = 0)
	If $iTimeOut < 0 Then Return SetError(1, 0, 0)

	Local $hMsgBoxCtDwn, $hButtonOK, $hButtonCancel, $Sec = @SEC, $sMsg, $iMsg
	Local $iWidth = 200, $iHeight = 100
    $hMsgBoxCtDwn = GUICreate($sTitle, $iWidth, 100, -1, -1, $WS_DLGFRAME, -1, $hWnd)
    $sMsg = GUICtrlCreateLabel($sMessage & " " & $iTimeOut & " sec", 0, 20, $iWidth, 28, $SS_CENTER)
	$hButtonOK = GUICtrlCreateButton("OK", ($iWidth/2) - 85, $iHeight - 50,  80, 20, BitOR($BS_CENTER, $BS_DEFPUSHBUTTON))
    $hButtonCancel = GUICtrlCreateButton("Cancel", ($iWidth/2) + 5, $iHeight - 50, 80, 20, $BS_CENTER)
    GUISetState(@SW_SHOW)

	While 1
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $hButtonOK
				GUIDelete($hMsgBoxCtDwn)
				Return $IDOK

			Case $iMsg = $hButtonCancel Or $iMsg = $GUI_EVENT_CLOSE
				GUIDelete($hMsgBoxCtDwn)
				Return $IDCANCEL

			Case $iTimeOut = 0
				GUIDelete($hMsgBoxCtDwn)
				Return $IDTIMEOUT
		EndSelect

		If @SEC <> $Sec Then
			$Sec = @SEC
			$iTimeOut -= 1
			GUICtrlSetData($sMsg, $sMessage & " " & $iTimeOut & " sec")

        EndIf
	WEnd

EndFunc	;==>MsgBox_CountDown
