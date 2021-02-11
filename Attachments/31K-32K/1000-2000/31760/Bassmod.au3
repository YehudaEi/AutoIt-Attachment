#include-once

; Error codes returned by BASSMOD_GetErrorCode()
Global Const $BASS_OK             = 0  ; all is OK
Global Const $BASS_ERROR_MEM      = 1  ; memory error
Global Const $BASS_ERROR_FILEOPEN = 2  ; can;t open the file
Global Const $BASS_ERROR_DRIVER   = 3  ; can;t find a free/valid driver
Global Const $BASS_ERROR_HANDLE   = 5  ; invalid handle
Global Const $BASS_ERROR_FORMAT   = 6  ; unsupported format
Global Const $BASS_ERROR_POSITION = 7  ; invalid playback position
Global Const $BASS_ERROR_INIT     = 8  ; BASS_Init has not been successfully called
Global Const $BASS_ERROR_ALREADY  = 14 ; already initialized/loaded
Global Const $BASS_ERROR_NOPAUSE  = 16 ; not paused
Global Const $BASS_ERROR_ILLTYPE  = 19 ; an illegal type was specified
Global Const $BASS_ERROR_ILLPARAM = 20 ; an illegal parameter was specified
Global Const $BASS_ERROR_DEVICE   = 23 ; illegal device number
Global Const $BASS_ERROR_NOPLAY   = 24 ; not playing
Global Const $BASS_ERROR_NOMUSIC  = 28 ; no MOD music has been loaded
Global Const $BASS_ERROR_NOSYNC   = 30 ; synchronizers have been disabled
Global Const $BASS_ERROR_NOTAVAIL = 37 ; requested data is not available
Global Const $BASS_ERROR_DECODE   = 38 ; the channel is a "decoding channel"
Global Const $BASS_ERROR_FILEFORM = 41 ; unsupported file format
Global Const $BASS_ERROR_UNKNOWN = -1  ; some other mystery error

; Device setup flags
Global Const $BASS_DEVICE_8BITS  = 1  ; use 8 bit resolution, else 16 bit
Global Const $BASS_DEVICE_MONO   = 2  ; use mono, else stereo
Global Const $BASS_DEVICE_NOSYNC = 16 ; disable synchronizers

; Music flags
Global Const $BASS_MUSIC_RAMP = 1 ; normal ramping
Global Const $BASS_MUSIC_RAMPS = 2 ; sensitive ramping
Global Const $BASS_MUSIC_LOOP = 4 ; loop music
Global Const $BASS_MUSIC_FT2MOD = 16 ; play .MOD as FastTracker 2 does
Global Const $BASS_MUSIC_PT1MOD = 32 ; play .MOD as ProTracker 1 does
Global Const $BASS_MUSIC_POSRESET = 256 ; stop all notes when moving position
Global Const $BASS_MUSIC_SURROUND = 512 ;surround sound
Global Const $BASS_MUSIC_SURROUND2 = 1024 ;surround sound (mode 2)
Global Const $BASS_MUSIC_STOPBACK = 2048 ;stop the music on a backwards jump effect
Global Const $BASS_MUSIC_CALCLEN = 8192 ;calculate playback length
Global Const $BASS_MUSIC_NONINTER = 16384 ; non-interpolated mixing
Global Const $BASS_MUSIC_NOSAMPLE = 0x400000 ; don't load the samples
Global Const $BASS_UNICODE = 0x80000000

; BASSMOD_MusicIsActive return values
Global Const $BASS_ACTIVE_STOPPED = 0
Global Const $BASS_ACTIVE_PLAYING = 1
Global Const $BASS_ACTIVE_PAUSED = 3

; Globals used to store information (don't do anything to them in your script!!)
Global $__BASSMOD_SoundScaler = 1
Global $__BASSMOD_SoundFrequency = 44100
Global $__BASSMOD_SoundChannels = 2
Global $__BASSMOD_SoundBits = 2

Global $hBassModDLL = DllOpen(@ScriptDir & "\bassmod.dll")
If $hBassModDLL = -1 Then
	MsgBox(16, "Error", 'The "BASSMOD.DLL" not found.' & @LF & _
		   'Please place a "BASSMOD.DLL" in the current directory')
	Exit
EndIf

; #FUNCTION# ==================================================================================================
; Name............: _Bassmod_Init
; Description.....: Initializes BASSMOD
; Syntax..........: _Bassmod_Init([$sDevice = -1[, $sFreq = 44100[, $sFlag = 0]]])
; Parameter(s)....: $sDevice - [optional] The device to use... 0 = first, -1 = default, -2 = no sound, -3 = decode only
;					$sFreq   - [optional] Output sample rate (default is 44100)
;					$sFlag   - [optional] Any combination of these flags: $BASS_DEVICE_8BITS = Use 8 bit resolution, else 16 bit,
;					+ BASS_DEVICE_MONO = Use mono, else stereo, $BASS_DEVICE_NOSYNC = Disable synchronizers (default is 16 bit,
;					+ stereo, enable synchronizers)
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; Modified........: Alexander Samuelsson (aka AdmiralAlkex)
; ==============================================================================================================
Func _Bassmod_Init($sDevice = -1, $sFreq = 44100, $sFlag = 0)
	If BitAND($sFlag, $BASS_DEVICE_MONO) = $BASS_DEVICE_MONO Then $_BASSMOD__SoundChannels = 1
	If BitAND($sFlag, $BASS_DEVICE_8BITS) = $BASS_DEVICE_8BITS Then $_BASSMOD__SoundBits = 1
	If $__BASSMOD_SoundFrequency <> 44100 Then $__BASSMOD_SoundFrequency = $sFreq
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_Init", "int", $sDevice, "dword", $sFreq, "dword", $sFlag)
	Return $aRet[0]
EndFunc   ;==>_Bassmod_Init

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_GetDeviceDescription
; Description.....: Retrieves the text description of a device
; Syntax..........: _BASSMOD_GetDeviceDescription([$sDevice = -1])
; Parameter(s)....: $sDevice - [optional] The device to use... 0 = first, -1 = default
; Return value(s).: Success - Returns the text description of a device
;					Failure - Returns the empty string (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_GetDeviceDescription($sDevice = -1)
	Local $aRet = DllCall($hBassModDLL, "ptr", "BASSMOD_GetDeviceDescription", "int", $sDevice)
	Local $DevDescript = DllStructCreate("char[256]", $aRet[0])
	Return DllStructGetData($DevDescript, 1)
EndFunc   ;==>BASSMOD_GetDeviceDescription

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_GetVersion
; Description.....: Retrieves the version number of the BASSMOD.DLL that is loaded
; Syntax..........: _BASSMOD_GetVersion()
; Parameter(s)....: None
; Return value(s).: The BASSMOD version
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_GetVersion()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_GetVersion")
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_GetVersion

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_ErrorGetCode
; Description.....: Retrieves the BASSMOD error code for the most recent BASSMOD function call
; Syntax..........: _BASSMOD_ErrorGetCode()
; Parameter(s)....: None
; Return value(s).: If no error occured during the last BASSMOD function call then BASS_OK is returned
;					If error occured one of the BASS_ERROR values is returned
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_ErrorGetCode()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_ErrorGetCode")
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_ErrorGetCode

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_GetCPU
; Description.....: Retrieves the current CPU usage of BASSMOD
; Syntax..........: _BASSMOD_GetCPU()
; Parameter(s)....: None
; Return value(s).: The BASSMOD CPU usage as a percentage of total CPU time
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_GetCPU()
	Local $aRet = DllCall($hBassModDLL, "float", "BASSMOD_GetCPU")
	Return Round($aRet[0], 2)
EndFunc   ;==>_BASSMOD_GetCPU

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_SetVolume
; Description.....: Sets the digital output master volume
; Syntax..........: _BASSMOD_SetVolume([$sVolLevel = 100])
; Parameter(s)....: $sVolLevel - [optional] The volume level... 0 (min) - 100 (max), default is 100
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_SetVolume($sVolLevel = 100)
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_SetVolume", "int", $sVolLevel)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_SetVolume

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_GetVolume
; Description.....: Retrieves the current volume level
; Syntax..........: _BASSMOD_GetVolume()
; Parameter(s)....: None
; Return value(s).: Success - Returns the volume level
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_GetVolume()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_GetVolume")
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_GetVolume

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_Free
; Description.....: Frees all resources used by the digital output, including the MOD music
; Syntax..........: _BASSMOD_Free()
; Parameter(s)....: None
; Return value(s).: None
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_Free()
	DllCall($hBassModDLL, "none", "BASSMOD_Free")
EndFunc   ;==>_BASSMOD_Free

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicLoad
; Description.....: Loads a MOD music
; Syntax..........: _BASSMOD_MusicLoad($sFile[, $sFlag = $BASS_MUSIC_LOOP])
; Parameter(s)....: $sFile - Filename
;					$sFlag - [optional] A combination of flags, default is $BASS_MUSIC_LOOP
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicLoad($sFile, $sFlag = $BASS_MUSIC_LOOP)
	Local $FileBuffer = DllStructCreate("char[256]")
	DllStructSetData($FileBuffer, 1, $sFile)
	
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicLoad", "int", False, "ptr", DllStructGetPtr($FileBuffer), "int", 0, _
						  "int", 0, "int", $sFlag)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicLoad

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicPlay
; Description.....: Plays the MOD music
; Syntax..........: _BASSMOD_MusicPlay()
; Parameter(s)....: None
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicPlay()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicPlay")
	Return $aRet[0]
EndFunc   ;==>BASSMOD_MusicPlay

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicPlayEx
; Description.....: Plays the MOD music, using the specified start position and flags
; Syntax..........: _BASSMOD_MusicPlayEx([$sPos = 0[, $sFlag = $BASS_MUSIC_LOOP[, $sReset = False]]])
; Parameter(s)....: $sPos   - [optional] Position to start playback from (in second), default is 0
;					$sFlag  - [optional] A combination of flags, default is $BASS_MUSIC_LOOP
;					$sReset - [optional] Stop all playing notes and reset BPM, default is False
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicPlayEx($sPos = 0, $sFlag = $BASS_MUSIC_LOOP, $sReset = False)
	If $sPos Then $sPos = BitOR(BitAND($sPos, 0xFFFF), BitShift(0xFFFF, -16))
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicPlayEx", "int", $sPos, "int", $sFlag, "int", $sReset)
	Return $aRet[0]
EndFunc   ;==>BASSMOD_MusicPlayEx

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicPause
; Description.....: Pauses the MOD music
; Syntax..........: _BASSMOD_MusicPause()
; Parameter(s)....: None
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicPause()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicPause")
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicPause

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicStop
; Description.....: Stops the MOD music
; Syntax..........: _BASSMOD_MusicStop()
; Parameter(s)....: None
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicStop()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicStop")
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicStop

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicGetPosition
; Description.....: Retrieves the playback position of the MOD music
; Syntax..........: _BASSMOD_MusicGetPosition()
; Parameter(s)....: None
; Return value(s).: Success - Array with the following format:
;                   |$aPos[0] - Current order
;                   |$aPos[1] - Current row
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; Modified........: Alexander Samuelsson (aka AdmiralAlkex)
; ==============================================================================================================
Func _BASSMOD_MusicGetPosition()
	Local $aRet = DllCall($hBassModDLL, "dword", "BASSMOD_MusicGetPosition"), $aPos[2]
	$aPos[0] = BitAND($aRet[0], 0xFFFF)
	$aPos[1] = BitShift($aRet[0] / $__BASSMOD_SoundScaler, 16)
	Return $aPos
EndFunc   ;==>_BASSMOD_MusicGetPosition

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicGetLength
; Description.....: Retrieves the length of the MOD music
; Syntax..........: _BASSMOD_MusicGetLength([$sFlag = False])
; Parameter(s)....: $sFlag - [optional] Sort of length to get... False = the order length, True = millisecond
; Return value(s).: Success - Returns the music's length
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2, for more info see the help file
; Author(s).......: R.Gilman (a.k.a. rasim)
; Modified........: Alexander Samuelsson (aka AdmiralAlkex)
; ==============================================================================================================
Func _BASSMOD_MusicGetLength($sFlag = False)
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicGetLength", "int", $sFlag)
	If $sFlag = True Then
		Return $aRet[0] / ($__BASSMOD_SoundFrequency * $__BASSMOD_SoundBits * $__BASSMOD_SoundChannels)
	ElseIf $sFlag = False Then
		Return $aRet[0]
	EndIf
EndFunc   ;==>_BASSMOD_MusicGetLength

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicGetName
; Description.....: Retrieves the MOD music's name
; Syntax..........: _BASSMOD_MusicGetName()
; Parameter(s)....: None
; Return value(s).: Success - Returns the music's name
;					Failure - Returns empty string (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicGetName()
	Local $aRet = DllCall($hBassModDLL, "ptr", "BASSMOD_MusicGetName")
	If Not $aRet[0] Then Return 0
	
	Local $MusicName = DllStructCreate("char[256]", $aRet[0])
	Return DllStructGetData($MusicName, 1)
EndFunc   ;==>_BASSMOD_MusicGetName

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicGetVolume
; Description.....: Retrieves the volume level of a channel or instrument in a MOD music
; Syntax..........: _BASSMOD_MusicGetVolume([$sChan = 0[, $sInst = 0]])
; Parameter(s)....: $sChan - [optional] If the $sInst is 0, then the $sChan is a channel number (0 = 1st channel)
;					$sInst - [optional] If the $sInst is 1, then the $sChan is an instrument number (0 = 1st instument)
; Return value(s).: Success - Returns the requested volume level
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicGetVolume($sChan = 0, $sInst = 0)
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicGetVolume", "int", BitOR(BitAND($sChan, 0xFFFF), BitShift($sInst, -16)))
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicGetVolume

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicSetVolume
; Description.....: Sets the volume level of a channel or instrument in a MOD music
; Syntax..........: _BASSMOD_MusicSetVolume([$sChan = 0[, $sInst = 0[, $sVolLevel = 100]]])
; Parameter(s)....: $sChan - [optional] If the $sInst is 0, then the $sChan is a channel number (0 = 1st channel)
;					$sInst - [optional] If the $sInst is 1, then the $sChan is an instrument number (0 = 1st instument)
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicSetVolume($sChan = 0, $sInst = 0, $sVolLevel = 100)
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicSetVolume", "int", BitOR(BitAND($sChan, 0xFFFF), BitShift($sInst, -16)), "int", $sVolLevel)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicSetVolume

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicSetAmplify
; Description.....: Sets the MOD music's amplification level
; Syntax..........: _BASSMOD_MusicSetAmplify([$sVolLevel = 100])
; Parameter(s)....: $sVolLevel - [optional] Amplification level 0 (min) - 100 (max) the default when a MOD music is loaded is 50
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicSetAmplify($sVolLevel = 100)
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicSetAmplify", "int", $sVolLevel)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicSetAmplify

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicSetPosition
; Description.....: Sets the playback position of the MOD music
; Syntax..........: _BASSMOD_MusicSetPosition([$sPos = 0])
; Parameter(s)....: $sPos - [optional]
;                    |If array: Position in order [0] and row [1]
;                    |If not array: Position in seconds
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; Modified........: Alexander Samuelsson (aka AdmiralAlkex)
; ==============================================================================================================
Func _BASSMOD_MusicSetPosition($sPos = 0)
	If IsArray($sPos) Then
		Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicSetPosition", "int", BitOR(BitAND($sPos[0], 0xFFFF), BitShift($sPos[1], -16)))
	Else
		Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicSetPosition", "int", BitOR(BitAND($sPos, 0xFFFF), BitShift(0xFFFF, -16)))
	EndIf
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicSetPosition

; #FUNCTION# ==================================================================================================
; Name............: _BASSMOD_MusicSetPanSep
; Description.....: Sets the MOD music's pan seperation level
; Syntax..........: _BASSMOD_MusicSetPanSep([$sSep = 100])
; Parameter(s)....: $sSep - [optional] Pan seperation 0 (min) - 100 (max), 50 = linear (default when a MOD music is loaded)
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicSetPanSep($sSep = 100)
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicSetPanSep", "int", $sSep)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicSetPanSep

; #FUNCTION# ===================================================================================================
; Name............: _BASSMOD_MusicSetPositionScaler
; Description.....: Sets the MOD music's _BASSMOD_MusicGetPosition() scaler
; Syntax..........: _BASSMOD_MusicSetPositionScaler([$sScale = 1])
; Parameter(s)....: $sScale - [optional] The scaler... 1 (min) - 256 (max)... the default when a MOD music is loaded is 1
; Return value(s).: Success - Returns True
;					Failure - Returns False (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2, for more info see a help file
; Author(s).......: R.Gilman (a.k.a. rasim)
; Modified........: Alexander Samuelsson (aka AdmiralAlkex)
; ==============================================================================================================
Func _BASSMOD_MusicSetPositionScaler($sScale = 1)
	$__BASSMOD_SoundScaler = $sScale
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicSetPositionScaler", "int", $sScale)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicSetPositionScaler

; #FUNCTION# ===================================================================================================
; Name............: _BASSMOD_MusicEnumChannel
; Description.....: Count the number of channels in a MOD music
; Syntax..........: _BASSMOD_MusicEnumChannel()
; Parameter(s)....: None
; Return value(s).: Success - Returns the number of channels
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicEnumChannel()
	Local $aRet, $iCount = 0
	
	Do
		$aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicGetVolume", "int", BitOR(BitAND($iCount, 0xFFFF), BitShift(0, -16)))
		$iCount += 1
	Until $aRet[0] = -1
	
	Return $iCount - 1
EndFunc   ;==>_BASSMOD_MusicEnumChannel

; #FUNCTION# ===================================================================================================
; Name............: _BASSMOD_MusicEnumInstrument
; Description.....: Count the number of instruments in a MOD music
; Syntax..........: _BASSMOD_MusicEnumInstrument()
; Parameter(s)....: None
; Return value(s).: Success - Returns the number of channels
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicEnumInstrument()
	Local $aRet, $iCount = 0
	
	Do
		$aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicGetVolume", "int", BitOR(BitAND($iCount, 0xFFFF), BitShift(1, -16)))
		$iCount += 1
	Until $aRet[0] = -1
	
	Return $iCount - 1
EndFunc   ;==>_BASSMOD_MusicEnumInstrument

; #FUNCTION# ===================================================================================================
; Name............: _BASSMOD_MusicIsActive
; Description.....: Checks if the MOD music is active (playing)
; Syntax..........: _BASSMOD_MusicIsActive()
; Parameter(s)....: None
; Return value(s).: $BASS_ACTIVE_STOPPED - The MOD music is not active
;					$BASS_ACTIVE_PLAYING - The MOD music is playing
;					$BASS_ACTIVE_PAUSED  - The MOD music is paused 
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2, for more info see a help file
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicIsActive()
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicIsActive")
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicIsActive

; #FUNCTION# ===================================================================================================
; Name............: _BASSMOD_MusicDecode
; Description.....: Gets decoded sample data from the MOD music
; Syntax..........: _BASSMOD_MusicDecode()
; Parameter(s)....: None
; Return value(s).: Success - Returns the number of bytes actually decoded
;					Failure - Returns -1 (Use _BASSMOD_ErrorGetCode to get the error code)
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2, for more info see a help file
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicDecode()
	Local $tBUFFER = DllStructCreate("ubyte[1000]")
	Local $aRet = DllCall($hBassModDLL, "int", "BASSMOD_MusicDecode", "ptr", DllStructGetPtr($tBUFFER), "int", 1000)
	Return $aRet[0]
EndFunc   ;==>_BASSMOD_MusicDecode

; #FUNCTION# ===================================================================================================
; Name............: _BASSMOD_MusicFree
; Description.....: Frees the MOD music's resources
; Syntax..........: _BASSMOD_MusicFree()
; Parameter(s)....: None
; Return value(s).: None
; Note(s).........: Tested on AutoIt 3.2.12.1 and Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ==============================================================================================================
Func _BASSMOD_MusicFree()
	DllCall($hBassModDLL, "none", "BASSMOD_MusicFree")
EndFunc   ;==>BASSMOD_MusicFree

Func OnAutoItExit()
	If $hBassModDLL <> -1 Then DllClose($hBassModDLL)
EndFunc   ;==>OnAutoItExit