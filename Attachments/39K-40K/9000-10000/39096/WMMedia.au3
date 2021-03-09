#include-once
Local $pObj = 0


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:     English
; Description:  Functions that assist with Media Manipulation.
;
; Notes:		Keep Player Open For as Long as Your Script will be playing songs.
;				Don't Close and Restart the Player for every song Change.
;				Run WMStartPLayer() First, All other Functions Depend on it Running first.
; ------------------------------------------------------------------------------

; ====================================================================================================
; Description ..: 	Opens The Player Object
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been More than Once
; ====================================================================================================
Func WMStartPlayer()
	If $pObj = 0 Then 
		$pObj = ObjCreate("WMPlayer.ocx")
	Else
		SetError(1)
	EndIf
EndFunc

; ====================================================================================================
; Description ..: 	Closes The Player Object
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	
; ====================================================================================================
Func WMClosePlayer()
	If WMGetState() <> "Stopped" Then WMStop()
	$pObj = 0
EndFunc

; ====================================================================================================
; Description ..: 	Opens The Media file in The Player Object
; Parameters ...:	$sFilename	- Filename of the Media to Open
; Return values : 	Song Object to be used in other functions
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMOpenFile($sFilename)
	If $pObj <> 0 Then Return $pObj.newMedia($sFilename)
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Sets the Volume of the Player.  
; Parameters ...:	$iVol		- New Volume ( 0 - 100 )
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Does Not Affect System/Wave Volumes!!
;					Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMSetVolume($iVol)
    If $pObj <> 0 Then $pObj.settings.volume = $iVol
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Returns the Current Volume of The Player
; Parameters ...:	
; Return values : 	Current Volume ( 0 - 100 )
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMGetVolume()
    If $pObj <> 0 Then Return $pObj.settings.volume
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Fast Forwards the Current Playing Media
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMFastForward()
    If $pObj <> 0 Then $pObj.controls.fastForward()
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Rewinds the Current Playing Media
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMReverse()
    If $pObj <> 0 Then $pObj.controls.fastReverse()
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Plays a Media for the first time
; Parameters ...:	$sFilename	- Filename of the Media to Play
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMPlay($sFilename)
	If $pObj <> 0 Then 
		$pObj.url = $sFilename
		While Not WMGetState() = "Playing"
			Sleep(100)
		WEnd
	EndIf
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Pauses the Current Playing Media
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMPause()
    If $pObj <> 0 Then $pObj.controls.pause()
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Resumes a Stopped or Paused Media
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMResume()
    If $pObj <> 0 Then $pObj.controls.play()
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Stops the Current Playing Media
; Parameters ...:	
; Return values : 	
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMStop()
    If $pObj <> 0 Then $pObj.controls.stop()
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Sets the Position of the Media
; Parameters ...:	$iPos		- Position in Seconds
; Return values : 	
; Author .......: 	CFire
; Notes ........:	No need to call a WMPlay(). This will continue play at the new Position
;					Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMSetPosition($iPos)
    If $pObj <> 0 Then $pObj.controls.currentPosition = $iPos
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Returns the Current Position in the Media
; Parameters ...:	
; Return values : 	Position in Seconds
; Author .......: 	CFire
; Notes ........:	Sets @error = 1 When This Function has Been called Before WMStartPlayer()
; ====================================================================================================
Func WMGetPosition()
    If $pObj <> 0 Then Return $pObj.controls.currentPosition
	If $pObj = 0 Then SetError(1)
EndFunc

; ====================================================================================================
; Description ..: 	Returns the Duration / Length of the Media
; Parameters ...:	$sObj		- The Song Object returned from WMOpenFile()
; Return values : 	Duration in Seconds
; Author .......: 	CFire
; Notes ........:	
; ====================================================================================================
Func WMGetDuration($sObj)
	Return $sObj.GetItemInfo("Duration")
EndFunc

; ====================================================================================================
; Description ..: 	Functions that Get a Property of the Media
; Parameters ...:	$sObj		- The Song Object returned from WMOpenFile()
; Return values : 	Specific Property
; Author .......: 	CFire
; Notes ........:	
; ====================================================================================================
Func WMGetArtist($sObj)
	Return $sObj.GetItemInfo("Artist")
EndFunc

Func WMGetTitle($sObj)
	Return $sObj.GetItemInfo("Title")
EndFunc

Func WMGetAlbum($sObj)
	Return $sObj.GetItemInfo("Album")
EndFunc

Func WMGetBitrate($sObj)
	Return $sObj.GetItemInfo("Bitrate")
EndFunc

Func WMGetMediaType($sObj)
	Return $sObj.GetItemInfo("MediaType")
EndFunc

Func WMGetFileSize($sObj)
	Return $sObj.GetItemInfo("FileSize")
EndFunc

Func WMGetFileType($sObj)
	Return $sObj.GetItemInfo("FileType")
EndFunc

Func WMGetCategory($sObj)
	Return $sObj.GetItemInfo("WM/Category")
EndFunc

Func WMGetGenre($sObj)
	Return $sObj.GetItemInfo("WM/Genre")
EndFunc

Func WMGetYear($sObj)
	Return $sObj.GetItemInfo("WM/Year")
EndFunc

Func WMGetState()
	If $pObj <> 0 Then 
		$sStates = "Undefined,Stopped,Paused,Playing,ScanForward,ScanReverse,Buffering,"
		$sStates &= "Waiting,MediaEnded,Transitioning,Ready,Reconnecting"
		$aStates = StringSplit($sStates,",")
		$iState = $pObj.playState() + 1
		return $aStates[$iState]
	EndIf
	If $pObj = 0 Then SetError(1)
EndFunc