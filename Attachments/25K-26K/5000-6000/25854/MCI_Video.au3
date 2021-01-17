#include-once

; #CURRENT# ===============================================================================================
; _Video_Close
; _Video_Dimension
; _Video_FrameRate
; _Video_Length
; _Video_Mute
; _Video_Open
; _Video_Pause
; _Video_Play
; _Video_Resume
; _Video_Seek
; _Video_Status
; _Video_Step
; _Video_Stop
; _Video_TimePos
; _Video_Volume
; _Video_WindowPut
; _RandomStr
; _MSToHMS
; _mciDeviceExists
; _mciListDevices
; _mciSendString
;==========================================================================================================

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Close
; Description....: Close a video.
; Syntax.........: _Video_Close($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and sets Alias name to "".
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to close video
; Author ........: smashly
; =========================================================================================================
Func _Video_Close(ByRef $sAlias)
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If _mciSendString("close " & $sAlias) = 0 Then
		$sAlias = ""
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Close

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Dimension
; Description....: Retrieves the Width and Height of the source video.
; Syntax.........: _Video_Dimension($sFile)
; Parameters ....: $sFile     - The full path to video file.
; Return values .: Success    - Returns an array. array[0] = Width, array[1] = Height
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = File doesn't exist.
;                               @error 2 = MCI failed to open the video file.
;                               @error 3 = MCI failed to get the source video dimensions.
; Author ........: smashly
; =========================================================================================================
Func _Video_Dimension($sFile)
	Local $iRet, $sVID, $aTmp
	If Not FileExists($sFile) Then Return SetError(1, 0, 0)
	$sVID = _RandomStr()
	$iRet = _mciSendString("open " & FileGetShortName($sFile) & " alias " & $sVID)
	If $iRet <> 0 Then Return SetError(2, 0, 0)
	$iRet = _mciSendString("where " & $sVID & " source", 255)
	If $iRet = "" Then
		_mciSendString("close " & $sVID)
		Return SetError(3, 0, 0)
	EndIf
	_mciSendString("close " & $sVID)
	$aTmp = StringSplit($iRet, Chr(32))
	$aTmp[1] = $aTmp[$aTmp[0]]
	$aTmp[0] = $aTmp[$aTmp[0] - 1]
	ReDim $aTmp[2]
	Return $aTmp
EndFunc   ;==>_Video_Dimension

; #FUNCTION# ==============================================================================================
; Name...........: _Video_FrameRate
; Description....: Close a video.
; Syntax.........: _Video_FrameRate($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Returns the Frames Per Second of the video.
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
; Author ........: smashly
; =========================================================================================================
Func _Video_FrameRate($sAlias)
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	Return _mciSendString("status " & $sAlias & " nominal frame rate", 255) / 1000
EndFunc   ;==>_Video_FrameRate

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Length
; Description....: Get the time length of a video in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
; Syntax.........: _Video_Length($sAlias[, $iTime = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open
;				   $iTime     - 0 Return time lenth in Hours, Minutes, Seconds (HH:MM:SS)
;						      - 1 Return time lenth in Milliseconds.
; Return values .: Success    - Return time length in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
; Author ........: smashly
; =========================================================================================================
Func _Video_Length($sAlias, $iTime = 0)
	Local $iMS
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	_mciSendString("set " & $sAlias & " time format ms")
	$iMS = _mciSendString("status " & $sAlias & " length", 255)
	If Not $iTime Then Return _MSToHMS($iMS)
	If $iTime Then Return $iMS
EndFunc   ;==>_Video_Length

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Mute
; Description....: Turn off/on the audio in a video.
; Syntax.........: _Video_Mute($sAlias[, $iMute = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iAudio    - 0 = Audio On, 1 = Audio Off
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to turn the video audio off/on
; Author ........: smashly
; =========================================================================================================
Func _Video_Mute($sAlias, $iMute = 0)
	Local $iRet, $iAM = "on"
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If $iMute Then $iAM = "off"
	$iRet = _mciSendString("set " & $sAlias & " audio all " & $iAM)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Mute

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Open
; Description ...: Opens a Video file ready for use with other _Video_xxxx functions.
; Syntax.........: _Video_Open($sFile, $hWnd, $iX, $iY, $iW, $iH[, $sDevice = ""])
; Parameters ....: $sFile     - The full path to video file.
;                  $hWnd      - Handle to a window or control that the video will be displayed on
;                  $iX        - Left position of the video.
;                  $iY        - Top position of the video.
;                  $iW        - Width of the video.
;                  $iH        - Height of the video.
;                  $sDevice   - MCI Device type to play video with. (See Remarks for more info)
; Return values .: Success    - Return an Alias name for use with other _Video_xxxx functions.
;                  Failure    - Return an empty String "" and @error 1~5
;                               @error 1 = File doesn't exist
;                               @error 2 = Window or Control handle not valid.
;                               @error 3 = Invalid MCI Device type specified.
;                               @error 4 = MCI failed to open video file
;                               @error 5 = MCI failed window for video.
;                               @error 5 = MCI failed to put video at the deignated location.
; Author ........: smashly
; Remarks .......: If your having trouble with avi playback (eg; playing fast, slow, choppy or no audio)
;                  or a video won't play but it plays fine in any other player ...
;                  Then set the $sDevice parameter to "MPEGVideo"
;                  If the $sDevice parameter is left blank then windows will decide which MCI Device type
;                  to use.
;                  Most current day avi/wmv/mp4 formats dont play properly or at all when windows selects
;                  the mci device type to use.
;                  Windows would default use "AVIVideo" MCI Device type to play avi with mci.
;                  When you specify "MPEGVideo" for an avi and mci fails it then uses the windows native
;                  chain of codecs that would be used by any other player not using mci ;)
;                  Because of this behaviour you can usually play almost any type of video that normally
;                  fails when using mci just by specifying "MPEGVideo" mci device type.
;                  For playing video on an autoit gui then be sure to add the $WS_CLIPCHILDREN style
;                  to your Gui. This will keep the Video dislpayed on your Gui all the time.
; =========================================================================================================
Func _Video_Open($sFile, $hWnd, $iX, $iY, $iH, $iW, $sDevice = "")
	Local $sAlias, $sHwnd, $iRet, $sDT = ""
	If Not FileExists($sFile) Then Return SetError(1, 0, "")
	$sAlias = _RandomStr()
	If Not IsHWnd($hWnd) Then Return SetError(2, 0, "")
	$sHwnd = Dec(Hex($hWnd))
	If $sDevice <> "" Then
		If Not _mciDeviceExists($sDevice) Then Return SetError(3, 0, "")
		$sDT = " type " & $sDevice
	EndIf
	$iRet = _mciSendString("open " & FileGetShortName($sFile) & " alias " & $sAlias & $sDT)
	If $iRet <> 0 Then Return SetError(4, 0, "")
	$iRet = _mciSendString("window " & $sAlias & " handle " & $sHwnd)
	If $iRet <> 0 Then
		_mciSendString("close " & $sAlias)
		Return SetError(5, 0, "")
	EndIf
	$iRet = _mciSendString("put " & $sAlias & " destination at " & $iX & " " & $iY & " " & $iH & " " & $iW)
	If $iRet <> 0 Then
		_mciSendString("close " & $sAlias)
		Return SetError(6, 0, "")
	EndIf
	Return SetError(0, 0, $sAlias)
EndFunc   ;==>_Video_Open

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Pause
; Description....: Pause a Video at the current playing position.
; Syntax.........: _Video_Pause($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = Failed to pause video.
; Author ........: smashly
; =========================================================================================================
Func _Video_Pause($sAlias)
	Local $iRet
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	$iRet = _mciSendString("pause " & $sAlias)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Pause

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Play
; Description....: Play a video that was opened using the _Video_Open() function.
; Syntax.........: _Video_Play($sAlias[, $iFlag = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iFlag     - 0 = play
;                               1 = fullscreen
;                               2 = repeat (loop)
;                               3 = fullsreen and repeat
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid Flag
;                               @error 3 = MCI failed to play video.
; Author ........: smashly
; ======================================================================================================================
Func _Video_Play($sAlias, $iFlag = 0)
	Local $iRet, $sFlg
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If _Video_TimePos($sAlias, 1) = _Video_Length($sAlias, 1) Then _Video_Seek($sAlias, "start")
	Switch $iFlag
		Case 0
			$sFlg = ""
		Case 1
			$sFlg = " fullscreen"
		Case 2
			$sFlg = " repeat"
		Case 3
			$sFlg = " fullscreen repeat"
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch
	$iRet = _mciSendString("play " & $sAlias & $sFlg)
	If $iRet <> 0 Then Return SetError(3, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>_Video_Play

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Resume
; Description....: Resume playing a video after pausing.
; Syntax.........: _Video_Resume($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to resume video.
; Author ........: smashly
; =========================================================================================================
Func _Video_Resume($sAlias)
	Local $iRet
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	$iRet = _mciSendString("resume " & $sAlias)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Resume

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Seek
; Description....: Seek a video to the specified time position.
; Syntax.........: _Video_Seek($sAlias, $iTime)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;				   $iTime     - Time to Seek. Can be Millisecons or HH:MM:SS or "start" or "end"
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid time format.
;                               @error 3 = MCI Seek error
; Author ........: smashly
; =========================================================================================================
Func _Video_Seek($sAlias, $iTime)
	Local $iMS, $aTime, $iRet
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If StringInStr($iTime, ":") Then
		$aTime = StringSplit($iTime, ":")
		If $aTime[0] <> 3 Then Return SetError(2, 0, 0)
		$iMS = 1000 * ((3600 * $aTime[1]) + (60 * $aTime[2]) + $aTime[3])
	ElseIf StringIsInt($iTime) Or $iTime = "start" Or $iTime = "end" Then
		$iMS = $iTime
	Else
		Return SetError(2, 0, 0)
	EndIf
	_mciSendString("set " & $sAlias & " time format ms")
	$iRet = _mciSendString("seek " & $sAlias & " to " & $iMS)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc   ;==>_Video_Seek

; #FUNCTION# =================================================================================================
; Name...........: _Video_Status
; Description....: Get a status status message from a video device.
; Syntax.........: _Video_Status($sAlias[, $sQuery = "mode"])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open
;                  $sQuery    - What to get the status of:
;                               "audio"   - returns the "on" or "off"
;                               "mode"    - returns "paused", "playing", "stopped" or "0" if no video loaded.
;                               "window handle" - returns the parent window handle.
; Return values .: Success    - Returns a Status message from the video device.
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid query (To be implemented)
; Author ........: smashly
; ============================================================================================================
Func _Video_Status($sAlias, $sQuery = "mode")
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If Not StringRegExp($sQuery, "\A(audio|mode|window handle)\z", 0) Then Return SetError(2, 0, 0)
	Switch $sQuery
		Case "audio", "mode"
			Return _mciSendString("status " & $sAlias & " " & $sQuery, 255)
		Case "window handle"
			Return HWnd(_mciSendString("status " & $sAlias & " " & $sQuery, 255))
	EndSwitch
EndFunc   ;==>_Video_Status

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Step
; Description....: Step a video forwards or backwards by a number of frames.
; Syntax.........: _Video_Step($sAlias, $iFrames)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open
;                  $iFrames   - The number of frames to step, use negative numbers to step backwards.
; Return values .: Success    - Returns 1 and @error 0
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid frames
;                               @error 3 = MCI Step error
; Author ........: smashly
; =========================================================================================================
Func _Video_Step($sAlias, $iFrames)
	Local $iRet
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If StringRegExp(StringReplace($iFrames, "-", ""), '\D', 0) Then Return SetError(2, 0, 0)
	$iRet = _mciSendString("step " & $sAlias & " by " & $iFrames)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc   ;==>_Video_Step

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Stop
; Description....: Stop a Video playing. (seeks video to start)
; Syntax.........: _Video_Stop($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = Failed to stop or seek
; Author ........: smashly
;==========================================================================================================
Func _Video_Stop($sAlias)
	Local $iRet, $iRet2
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	$iRet = _Video_Seek($sAlias, "start")
	$iRet2 = _mciSendString("stop " & $sAlias)
	If $iRet = 0 And $iRet2 = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Stop

; #FUNCTION# ==============================================================================================
; Name...........: _Video_TimePos
; Description....: Get the time poition of a video in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
; Syntax.........: _Video_TimePos($sAlias[, $iTime = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;				   $iTime     - 0 Return time lenth in Hours, Minutes, Seconds (HH:MM:SS)
;						      - 1 Return time lenth in Milliseconds.
; Return values .: Success    - Return time position in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
; Author ........: smashly
; =========================================================================================================
Func _Video_TimePos($sAlias, $iTime = 0)
	Local $iMS
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	_mciSendString("set " & $sAlias & " time format ms")
	$iMS = _mciSendString("status " & $sAlias & " position", 255)
	If Not $iTime Then Return _MSToHMS($iMS)
	If $iTime Then Return $iMS
EndFunc   ;==>_Video_TimePos

; #FUNCTION# ==============================================================================================
; Name...........: _Video_Volume
; Description....: Turn the video audio volume up or down.
; Syntax.........: _Video_AudioVolume($sAlias[, $iVolume = 100])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iVolume   - 0 = Min, 100 = Max
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid Volume
;                               @error 3 = MCI failed to set volume
; Author ........: smashly
; =========================================================================================================
Func _Video_Volume($sAlias, $iVolume = 100)
	Local $iRet, $iVol
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If StringRegExp($iVolume, '\D', 0) Then Return SetError(2, 0, 0)
	If $iVolume >= 100 Then
		$iVol = 1000
	ElseIf $iVolume <= 0 Then
		$iVol = 0
	ElseIf $iVolume > 0 And $iVolume < 100 Then
		$iVol = $iVolume * 10
	EndIf
	$iRet = _mciSendString("setaudio " & $sAlias & " volume to " & $iVol)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc   ;==>_Video_Volume

; #FUNCTION# ==============================================================================================
; Name...........: _Video_WindowPut
; Description....: Put a video on a window and optionaly set the desired position and size of the video.
; Syntax.........: _Video_WindowPut($sAlias, $hWnd[, $iX = -1[, $iY = -1[, $iW = -1[, $iH = -1]]]])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $hWnd      - Handle to a window to put the video on.
;                  $iX        - Left postion to put the video.
;                  $iY        - Top postion to put the video.
;                  $iW        - Width to put the video.
;                  $iH        - Height to put the video.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~4
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid window handle specified
;                               @error 3 = MCI failed window
;                               @error 4 = MCI failed put
; Author ........: smashly
; Remarks .......: If none of the x/y/w/h parameters are set then the video will display the full size
;                  of the specifed window.
;                  Whether or not the video is streched depends if the mci device type used supports
;                  stretching.
; =========================================================================================================
Func _Video_WindowPut($sAlias, $hWnd, $iX = -1, $iY = -1, $iW = -1, $iH = -1)
	Local $iRet, $sDes = " destination"
	If Not StringRegExp($sAlias, "\A[[:lower:]]+\z", 0) Then Return SetError(1, 0, 0)
	If Not IsHWnd($hWnd) Then Return SetError(2, 0, 0)
	$sHwnd = Dec(Hex($hWnd))
	$iRet = _mciSendString("window " & $sAlias & " handle " & $sHwnd)
	If $iRet <> 0 Then Return SetError(3, 0, 0)
	If Not ($iX = -1 And $iY = -1 And $iW = -1 And $iH = -1) Then
		$sDes &= ' at' & ' ' & $iX & ' ' & $iY & ' ' & $iW & ' ' & $iH
		$sDes = StringReplace($sDes, "-1", "0")
	EndIf
	$iRet = _mciSendString("put " & $sAlias & $sDes)
	If $iRet <> 0 Then Return SetError(4, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>_Video_WindowPut

;==========================================================================================================
; Internal use functions beyond this point
;==========================================================================================================

; #FUNCTION# ==============================================================================================
; Name...........: _MSToHMS
; Description....: Converts Milliseconds to Hours, Minutes, Seconds
; Syntax.........: _MSToHMS($iMS)
; Parameters ....: $iMS       - Milliseconds to convert
; Return values .: Success    - Returns Hours, Minutes, Seconds (HH:MM:SS)
; Author ........: smashly
; =========================================================================================================
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
EndFunc   ;==>_MSToHMS

; #FUNCTION# ==============================================================================================
; Name...........: _RandomStr
; Description....: Creates a random string
; Syntax.........: _RandomStr([$iLen = 10])
; Parameters ....: $iLen      - Length of string to return
; Return values .: Success    - Returns a string of random letters (a~z)
; Author ........: RazerM
; =========================================================================================================
Func _RandomStr($iLen = 10)
	Local $sTmp = ''
	For $i = 1 To $iLen
		$sTmp &= Chr(Random(97, 122, 1))
	Next
	Return $sTmp
EndFunc   ;==>_RandomStr

; #FUNCTION# ==============================================================================================
; Name...........: _mciDeviceExists
; Description....: Check if a MCI Device type exists
; Syntax.........: _mciDeviceExists($sDevice)
; Parameters ....: $sDevice   - Name of MCI Device type to check for
; Return values .: Success    - Return 1 if MCI Device type exists and @error 0
;                  Failure    - Return 0 if MCI Device type does not exist and @error 1~2
;                               @error 1 = No matching MCI Device type found.
;                               @error 2 = Failed to list any MCI Device types
; Author ........: smashly
; =========================================================================================================
Func _mciDeviceExists($sDevice)
	Local $aDT = _mciListDevices()
	If @error Then Return SetError(2, 0, 0)
	For $idx = 1 To $aDT[0]
		If $sDevice = $aDT[$idx] Then Return SetError(0, 0, 1)
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>_mciDeviceExists

; #FUNCTION# ==============================================================================================
; Name...........: _mciListDevices
; Description....: List all found MCI Device types in an array
; Syntax.........: _mciListDevices()
; Parameters ....: None
; Return values .: Success    - Return 1D array of found MCI Device types and @error 0
;                               array[0] Number of MCI Device types found
;                               array[n] MCI Device type name
;                  Failure    - Return empty 1D array and @error 1
; Author ........: smashly
; =========================================================================================================
Func _mciListDevices()
	Local $iMD, $sTmp
	$iMD = _mciSendString("sysinfo all quantity", 255)
	If StringIsInt($iMD) Then
		For $idx = 1 To $iMD
			$sTmp &= _mciSendString("sysinfo all name " & $idx, 255) & Chr(0)
		Next
		Return SetError(0, 0, StringSplit(StringTrimRight($sTmp, 1), Chr(0)))
	EndIf
	Return SetError(1, 0, StringSplit($sTmp, Chr(0)))
EndFunc   ;==>_mciListDevices

; #FUNCTION# ==============================================================================================
; Name...........: _mciSendString
; Description....:
; Syntax.........: _mciSendString($string[, $iLen = 0])
; Parameters ....: $string
;                  $iLen
; Return values .:
; Author ........: RazerM
; =========================================================================================================
Func _mciSendString($string, $iLen = 0)
	Local $iRet
	$iRet = DllCall("winmm.dll", "int", "mciSendStringA", "str", $string, "str", "", "long", $iLen, "long", 0)
	If Not @error Then Return $iRet[2]
EndFunc   ;==>_mciSendString