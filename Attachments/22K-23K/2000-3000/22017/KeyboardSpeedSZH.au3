#include <EditConstants.au3>

_ArrayAdd($SPORTS, "KeyboardSpeedSzh" )
$SPORTS[0]+= 1

Func _KeyboardSpeedSzh_INFO()
	Local $a[4]
	$a[0] = "Keyboard Speed"
	$a[1] = "Keyboard Typing"
	$a[2] = "Easy"
	$a[3] = "Szhlopp"
	Return $a
EndFunc

Global $LetterInput, $LetterLabel, $CurLet, $InitTimer, $TotalTime, $KeyGameStarted = False, $LettersCompleted = 0
Func _KeyboardSpeedSzh_RUN($hWnd, $Name)
	
	
$KeyboardGUI = GUICreate("Keyboard Test", 317, 267, 420, 246)
$LetterLabel = GUICtrlCreateLabel("", 135, 20, 65, 37)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$LetterInput = GUICtrlCreateInput("", 50, 84, 195, 21)
$ResetButton = GUICtrlCreateButton("Reset", 212, 224, 88, 36, 0)
$StartButton = GUICtrlCreateButton("Start", 10, 225, 88, 36, 0)
$DisplayInput = GUICtrlCreateLabel("", 40, 140, 250, 61)
GUIRegisterMsg($WM_COMMAND, "SZHKeySpeedWM_COMMAND")
GUISetState(@SW_SHOW)



While 1
	
	If $KeyGameStarted = True And $LettersCompleted = 5 Then
		GUICtrlSetData($DisplayInput, "Finished! You copied 5 keys in: " & Round($TotalTime / 1000, 3) & " seconds!" & @CRLF & "Highscores are saved in 'SZHNerdScores.txt'")
		If IniRead(@ScriptDir & '\SZHNerdScores.txt', "Keyboard", "Speed", "NA") > Round($TotalTime / 1000, 3) Or IniRead(@ScriptDir & '\SZHNerdScores.txt', "Keyboard", "Speed", "NA") = "NA" Then 
			IniWrite(@ScriptDir & '\SZHNerdScores.txt', "Keyboard", "Speed", Round($TotalTime / 1000, 3))
		EndIf
		$KeyGameStarted = False
		$LettersCompleted = 0
		GUICtrlSetState($LetterInput, $GUI_DISABLE)
		GUICtrlSetData($LetterLabel, "")
	EndIf
	
		
	
	Sleep(20)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIRegisterMsg($WM_COMMAND, "")
			GUIDelete($KeyboardGUI)
			ExitLoop
		Case $StartButton
			GUICtrlSetData($LetterInput, "")
			GUICtrlSetState($LetterInput, $GUI_ENABLE)
			GUICtrlSetState($LetterInput, $GUI_FOCUS)
			GUICtrlSetData($DisplayInput, "Game starting in 3 seconds... Press the keys as fast as you can!")
			Sleep(3000)
			GUICtrlSetData($DisplayInput, "")
			GUICtrlSetState($LetterInput, $GUI_ENABLE)
			GUICtrlSetState($LetterInput, $GUI_FOCUS)
			$TotalTime = 0
			$KeyGameStarted = True
			$InitTimer = TimerInit()
			$CurLet = Chr(Random(97, 122, 1))
			GUICtrlSetData($LetterLabel, " " & $CurLet)
		Case $ResetButton
			$KeyGameStarted = False
			$LettersCompleted = 0
			$TotalTime = 0
			GUICtrlSetState($LetterInput, $GUI_DISABLE)
			GUICtrlSetData($LetterLabel, "")
			GUICtrlSetData($DisplayInput, "")

	EndSwitch
	
WEnd

	
EndFunc

Func SZHKeySpeedWM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    ;ConsoleWrite("Debug: $wParam = " & $wParam & @LF)
	If $KeyGameStarted <> False Then
		Local $wParamLow = BitAND($wParam, 0xFFFF)
	   ; ConsoleWrite("Debug: $wParamLow = " & $wParamLow & @LF)
		Local $wParamHigh = BitShift($wParam, 16)
	   ; ConsoleWrite("Debug: $wParamHigh = " & $wParamHigh & @LF & @LF)
	   
		Switch $wParamLow ; Control ID switch $lparam also works
			Case $LetterInput   ; The control
				Switch $wParamHigh  ; What msg was sent 
					Case $EN_CHANGE ; Killfocus, the message
						
						If GUICtrlRead($LetterInput) = $CurLet Then
							$timerdiff = TimerDiff($InitTimer)
							$TotalTime += $timerdiff
							$InitTimer = TimerInit()
							$CurLet = Chr(Random(97, 122, 1))
							GUICtrlSetData($LetterLabel, " " & $CurLet)
							$LettersCompleted += 1
						EndIf
						GUICtrlSetData($LetterInput, "")
						GUICtrlSetState($LetterInput, $GUI_FOCUS)
						
				EndSwitch
		EndSwitch
	EndIf
		
EndFunc