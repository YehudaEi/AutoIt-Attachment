#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Sound.au3>

HotKeySet('!{ENTER}', 'FullScreen') ; Alt + Enter toggles fullscreen

Opt("GuiOnEventMode",1)

Global $vID, $Fullscreen


;~ $hGUI = GUICreate("Video Control", 400, 335 , -1, -1, BitOr($WS_OVERLAPPEDWINDOW,$WS_CLIPCHILDREN))
;~ GUISetOnEvent($GUI_EVENT_CLOSE , "Event")

;~ $Play = GUICtrlCreateButton("Play", 5, 305, 40, 25)
;~ GUICtrlSetOnEvent(-1 , "Event")
;~ GuiCtrlSetState(-1, $GUI_DISABLE)

;~ $Stop = GUICtrlCreateButton("Stop", 50, 305, 40, 25)
;~ GUICtrlSetOnEvent(-1 , "Event")
;~ GuiCtrlSetState(-1, $GUI_DISABLE)

;~ $Open = GUICtrlCreateButton("Load", 95, 305, 40, 25)
;~ GUICtrlSetOnEvent(-1 , "Event")

;~ GuiSetState(@SW_SHOW, $hGUI)

While 1
	Sleep(100)
	
WEnd

;~ Func Event()
;~ 	Switch @GUI_CtrlId
;~ 		Case $GUI_EVENT_CLOSE
;~ 	        _SoundClose($vID)
;~ 	        Exit			
;~ 		Case $Play
;~ 			If _SoundStatus($vID) = "playing" Then 
;~ 				_SoundPause($vID)
;~ 		       GUICtrlSetData($Play, 'Play')
;~             ElseIf _SoundStatus($vID) = "paused" Then 
;~ 				_SoundResume($vID)
;~ 		        GUICtrlSetData($Play, 'Pause')
;~ 	        ElseIf _SoundStatus($vID) = "stopped" Then 
;~ 				_VidPlay($vID, 0)
;~ 		        GUICtrlSetData($Play, 'Pause')
;~ 			EndIf
;~ 		Case $Stop
;~ 			If _SoundStatus($vID) = "playing" Then
;~ 				_SoundStop($vID)
;~ 				GUICtrlSetData($Play, 'Play')
;~ 			EndIf
;~ 		Case $Open
;~ 	        $file = FileOpenDialog("OPEN","","Video (*.avi;*.mpg)")
;~             If @error <> 1 Then
;~ 				If _SoundStatus($vID) <> "" Then 
;~ 					_SoundClose($vID)
;~ 					GUICtrlSetData($Play, 'Play')
;~ 				EndIf	
;~ 				$vID = _VidOpen($file, "", $hGUI, 0, 0, 400, 300)
;~ 				
;~ 				If $vID <> "" Then
;~ 					_VidPlay($vID, 0)
;~ 					GUICtrlSetData($Play, 'Pause')
;~ 					GuiCtrlSetState($Play, $GUI_ENABLE)
;~ 					GuiCtrlSetState($Stop, $GUI_ENABLE)
;~                     WinSetTitle($hGUI, "", _VidLength($vID, 1))
;~ 				EndIf	
;~ 	        EndIf
;~ 	EndSwitch		
;~ EndFunc	

Func Quit()
	        _SoundClose($vID)
	        Exit
EndFunc			

Func FullScreen()
	If $Fullscreen = 0 Then
		_VidPlay($vid, 1)
		$Fullscreen = 1
	ElseIf $Fullscreen = 1 Then
		_VidPlay($vid, 0)
	    $Fullscreen = 0
	EndIf
EndFunc

;========================================================================================================
; Description ...: Opens a Video file ready for use with other _Video_xxxx functions.
; Syntax.........: _Video_Open($sFile, $hWnd, $iX, $iY, $iW, $iH)
; Parameters ....: $sFile     - The full path to video file. 
;                  $hWnd      - Handle to a window or control that the video will be displayed on
;                  $iX        - Left position of the video.
;                  $iY        - Top position of the video.
;                  $iW        - Width of the video. 
;                  $iH        - Height of the video.
; Return values .: Success    - Return a string (Alias name for use with other _Video_xxxx functions)
;                  Failure    - Return an empty String "" and @error 1~5
;                               @error 1 = File doesn't exist
;                               @error 2 = Window or Control handle not valid.
;                               @error 3 = Failed to render video.
;                               @error 4 = Failed to place video at the deignated location.
; Author ........: smashly
;========================================================================================================
Func _Video_Open($sFile, $hWnd, $iX, $iY, $iH, $iH)
	Local $sVID, $gId, $vRet, $vWin, $vLoc
	If Not FileExists($sFile) Then Return SetError(1, 0, "")
	If Not IsHWnd($hWnd) Then Return SetError(2, 0, "")
	$gId = Dec(StringTrimLeft($hWnd,2))
	$sVID = _RandomStr()
	$vRet = _mciSendString("open " & FileGetShortName($sFile) & " alias " & $sVID)
	$vWin = _mciSendString("window " & $sVID & " handle " & $gId)
	If $vWin <> 0 Then 
		_mciSendString("close " & $sVID)
		Return SetError(3, 0, "")
	EndIf	
	$vLoc = _mciSendString("put " & $sVID & " destination at " & $iX & " " & $iY & " " & $iH & " " & $iH)
	If $vLoc <> 0 Then 
		_mciSendString("close " & $sVID)
		Return SetError(4, 0, "")
	EndIf	
	Return SetError(0, 0, $sVID)
EndFunc   ;==>_VidOpen

;===============================================================================
;
; Function Name:   _VidPlay($vID, $fScreen)
; Description::    Plays a Video from the current position (beginning is the default)
; Parameter(s):    $vID - Video ID returned by _VidOpen
;				   $fScreen [Optional] - If set to 1 the will be played in FullScreen (no Gui or Controls displayed)
;						               - If set to 0 the video will play in the GUI as specified in _VidOpen
;                                      - If omitted then 0 will be used (play in the GUI as specified in _VidOpen)
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 - Failure
;                  @error = 1 - play failed
; Author(s):       smashly (modified from RazorM sound udf for video play)
;
;===============================================================================
;
Func _VidPlay($vID, $fScreen = 0)
	;Declare variables
	Local $vRet
	;if sound has finished, seek to start
	If _VidPos($vID, 2) = _VidLength($vID, 2) Then mciSendString("seek " & $vID & " to start")
	If $fScreen = 1 Then
		$vRet = _mciSendString("play " & $vID & " fullscreen")
	Else
		$vRet = _mciSendString("play " & $vID)
	EndIf
	;return
	If $vRet = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_VidPlay

;===============================================================================
;
; Function Name:   _VidLength
; Description::    Returns the length of the sound in the format hh:mm:ss
; Parameter(s):    $vID     - Sound ID returned by _SoundOpen or sound file,
;				   $iMode = 1 - hh:mm:ss, $iMode = 2 - milliseconds
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): Length of the sound - Success, 0 and @error = 1 - $iMode is invalid
; Author(s):       RazerM
; Mofified:        jpm
;
;===============================================================================
;
Func _VidLength($vID, $iMode = 1)
	Local $iMS
	If $vID = "" Or StringRegExp($vID, "\W|_", 0) Then Return SetError(1, 0, 0)
	If $iMode <> 1 And $iMode <> 2 Then Return SetError(2, 0, 0)
	mciSendString("set " & FileGetShortName($vID) & " time format ms")
	$iMS = mciSendString("status " & FileGetShortName($vID) & " length", 255)
	If $iMode = 1 Then Return _MSToHMS($iMs)
	If $iMode = 2 Then Return $iMS
EndFunc   ;==>_VidLength

Func _VidPos($vID, $iMode = 1)
	Local $iMS
	If $vID = "" Or StringRegExp($vID, "\W|_", 0) Then Return SetError(1, 0, 0)
	If $iMode <> 1 And $iMode <> 2 Then Return SetError(2, 0, 0)
	_mciSendString("set " & $vID & " time format ms")
	$iMs = _mciSendString("status " & $vID & " position", 255)
	If $iMode = 1 Then Return _MSToHMS($iMs)
	If $iMode = 2 Then Return $iMs
EndFunc   ;==>_VidPos




Func _MSToHMS($iMS)
	Local $iHours = 0, $iMins = 0, $iSecs = 0
	If Number($iMS) > 0 Then
		$iMS = Round($iMS / 1000)
		$iHours = Int($iMS / 3600)
		$iTicks = Mod($iMS, 3600)
		$iMins = Int($iTicks / 60)
		$iSecs = Round(Mod($iMS, 60))
		Return StringFormat("%02i:%02i:%02i", $iHours, $iMins, $iSecs)
	EndIf
	Return StringFormat("%02i:%02i:%02i", $iHours, $iMins, $iSecs)
EndFunc

Func _mciSendString($string, $iLen = 0)
	Local $iRet
	$iRet = DllCall("winmm.dll", "int", "mciSendStringA", "str", $string, "str", "", "long", $iLen, "long", 0)
	If Not @error Then Return $iRet[2]
EndFunc   ;==>mciSendString

Func _RandomStr($len = 10)
	Local $string
	For $iCurrentPos = 1 To $len
		$string &= Chr(Random(97, 122, 1))
	Next
	Return $string
EndFunc   ;==>RandomStr