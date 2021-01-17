Opt("GUICoordMode", " 2")
$ret = _GUICreateLogin("Enter Credentials", "Enter the subjectnumber and session", -1, -1, -1, -1, -1, 10000)
If @error Then
	MsgBox(0, "Error", "Error Returned: " & $ret & @CRLF & "Error Code: " & @error & @CRLF & "Extended: " & @extended)
Else
	MsgBox(0, "Credentails Returned", "subjectnumber: " & $ret[0] & @CRLF & "session:  " & $ret[1])
EndIf

;===============================================================================
; Function Name:   _GUICreateLogin()
; Description:     Create a basic login box with Username, Password, and a prompt.
; Syntax:
; Parameter(s):    $hTitle - The title of the Form
;                  $hPrompt - The text prompt for the user [Optional] (maximum of 2 lines)
;                  $bBlank - The subjectnumber or session  can be blank. [optional]
;                            Default = False (Blanks are not allowed)
;                  $hWidth - Width of the form [optional] - default = 250
;                  $hHeight - Height of the form [optional] - default = 130
;                  $hLeft - X position [optional] - default = centered
;                  $hTop - Y position [optional] - default = centered
;                  $Timeout - The timeout of the form [optional - default = 0 (no timeout)
;                  $ShowError - Prompts are displayed to the user with timeout [optional]
; Requirement(s):  None
; Return Value(s): Success - Returns an array of 2 elements where
;                                        [0] = subjectnumber	
;                                        [1] = session
;                  Failure - Sets @Error to 1 and
;                                 @Extended - 1 = Cancel/Exit Button Pressed
;                                           - 2 = Timed out
; Author(s):   Brett Francis (exodus.is.me@hotmail.com)
; Modification(s): GeoSoft
; Note(s): If $hPrompt is blank then the GUI height will be reduced by 30
; Example(s):
;===============================================================================

Func _GUICreateLogin($hTitle, $hPrompt = "", $bBlank = False, $hWidth = -1, $hHeight = -1, $hLeft = -1, $hTop = -1, $timeout = 0, $ShowError = 0)
	If Not $hTitle Then $hTitle = "Login" 
	$iGCM = Opt("GUICoordMode", 2);; Get the current value of GUICoordMode and set it to 2
	If StringRegExp($bBlank, "(?i)\s|default|-1") Then $bBlank = False
	If StringRegExp($hWidth, "(?i)\s|default|-1") Then $hWidth = 250
	If StringRegExp($hHeight, "(?i)\s|default|-1") Then $hHeight = 130
	If StringRegExp($hLeft, "(?i)\s|default|-1") Then $hLeft = (@DesktopWidth / 2) - ($hWidth / 2)
	If StringRegExp($hTop, "(?i)\s|default|-1") Then $hTop = (@DesktopHeight / 2) - ($hHeight / 2)
	If Not $hPrompt Then $hHeight -= 30;If $hPrompt is blank then resize the GUI.
	Local $retarr[2] = ["", ""], $Time = 0

	Local $gui = GUICreate($hTitle, $hWidth, $hHeight, $hLeft, $hTop)
	GUISetCoord(4, 0)
	If $hPrompt Then Local $Lbl_Prompt = GUICtrlCreateLabel($hPrompt, -1, 4, 201, 30)
	Local $Lbl_User = GUICtrlCreateLabel("subjectnumber:", -1, 4, 64, 17);44, 64, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	Local $subjectnumber = GUICtrlCreateInput('', 8, -1, $hWidth - 81, 21)
	GUICtrlCreateLabel("session:", -($hWidth - 8), 4, 65, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	Local $session = GUICtrlCreateInput('', 8, -1, $hWidth - 81, 21, 32);, $ES_session)
	GUISetCoord(($hWidth / 2) - 85, $hHeight - 34)
	Local $Btn_OK = GUICtrlCreateButton("&OK", -1, -1, 75, 25)
	Local $Btn_Cancel = GUICtrlCreateButton("&Cancel", 20, -1, 75, 25)
	GUICtrlSetState($Btn_OK, 512)
	GUISetState()
	If $timeout Then $Time = TimerInit()
	While 1
		$Msg = GUIGetMsg()
		Local $sUser = GUICtrlRead($subjectnumber)
		Local $ssess = GUICtrlRead($session)
		If ($Time And TimerDiff($Time) >= $timeout) And ($sUser = "" And $ssess = "") Then
			$Status = 2
			ExitLoop
		EndIf
		Select
			Case $Msg = -3
				$Status = 0
				ExitLoop
			Case $Msg = $Btn_OK
				If $bBlank And ($sUser = "" Or $ssess = "") Then
					$Status = 1
					ExitLoop
				Else
					If $sUser <> "" And $ssess <> "" Then
						$Status = 1
						ExitLoop
					Else
						Select
							Case $sUser = "" And $ssess = ""
								If $ShowError = 1 Then MsgBox(16, "Error!", "subjectnumber and session cannot be blank!")
							Case $ssess = ""
								If $ShowError = 1 Then MsgBox(16, "Error!", "session cannot be blank!")
								GUICtrlSetState($session, 256)
							Case $sUser = ""
								If $ShowError = 1 Then MsgBox(16, "Error!", "subjectnumber cannot be blank!")
								GUICtrlSetState($username, 256)
						EndSelect
					EndIf
				EndIf
			Case $Msg = $Btn_Cancel
				$Status = 0
				ExitLoop
			Case $timeout And TimerDiff($Time) >= $timeout; And $timeout
				If $bBlank And ($sUser = "" Or $ssess = "") Then
					$Status = 2
					ExitLoop
				Else
					;$time = TimerInit()
					Select
						Case $sUser = "" And $ssess = ""
							If $timeout Then $Time = TimerInit()
							If $ShowError = 1 Then MsgBox(16, "Error!", "subjectnumber and session cannot be blank!")
						Case $ssess = ""
							If $timeout Then $Time = TimerInit()
							If $ShowError = 1 Then
								MsgBox(16, "Error!", "session cannot be blank!")
								GUICtrlSetState($session, 256)
							EndIf
						Case $sUser = ""
							$Time = TimerInit()
							If $ShowError = 1 Then
								MsgBox(16, "Error!", "subjectnumber cannot be blank!")
								GUICtrlSetState($subjectnumber, 256)
							EndIf
							;Case ($Timeout AND TimerDiff($time) >= $timeout) AND ($sUser = "" OR $ssess = "")
							;$status = 2
							;ExitLoop
						Case Else
							If $sUser <> "" And $ssess <> "" Then
								$Status = 3
								;If $Timeout AND TimerDiff($time) >= $timeout Then $Status = 2
								ExitLoop
							EndIf
					EndSelect
				EndIf
		EndSelect
	WEnd
	Local $eMsg = ""
	Switch $Status
		Case 0, 2
			$err = 1;0
			$ext = 1;Cancel/Exit Button Pressed
			$eMsg = "Cancel/Exit Button Pressed" 
			If $Status = 2 Then $ext = 2;Timed Out
			If $ext = 2 Then $eMsg = "Timed Out" 
		Case Else;1, 3
			$retarr[0] = $sUser
			$retarr[1] = $ssess
			$err = 0;1
			$ext = 0
			If $Status = 3 Then $ext = 1;subjectnumberFields Not Blank, Timeout reached
	EndSwitch
	GUIDelete($gui)
	Opt("GUICoordMode", $iGCM);Reset the GUICoordMode to what it started as.
	If $eMsg Then Return SetError($err, $ext, $eMsg)
	Return $retarr
EndFunc   ;==>_GUICreateLogin