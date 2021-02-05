;.......script written by trancexx (trancexx at yahoo dot com)
;.......based on "DirectSound Beep Implementation" (http://www.codeproject.com/KB/winsdk/DirectSound_beep.aspx) by CyLith

#include "AutoItObject.au3"
#include <WinAPI.au3>

Opt("MustDeclareVars", 1)

; Start AutoItObject
_AutoItObject_StartUp()

; Error monitoring
Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
Func _ErrFunc()
	ConsoleWrite("! COM Error !  Number: 0x" & Hex($oError.number, 8) & "   ScriptLine: " & $oError.scriptline & " - " & $oError.windescription & @CRLF)
	Return
EndFunc   ;==>_ErrFunc


; Play something
_Beep(1047, 562) ; C
_Beep(1319, 375) ; E
_Beep(1480, 375) ; F#
_Beep(1760, 188) ; A
_Beep(1568, 562) ; G
_Beep(1319, 375) ; E
_Beep(1047, 375) ; C
; Lower now
_Beep(880, 188) ; A
_Beep(740, 188) ; F#
_Beep(740, 188) ; F#
_Beep(740, 188) ; F#
_Beep(784, 750) ; G

; That's it!



; BEEP FUNCTION

Func _Beep($iFrequency, $iDuration)
	; WAVEFORMATEX structure (http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.waveformatex(VS.85).aspx)
	Local $tWAVEFORMATEX = DllStructCreate("align 2;word FormatTag;" & _
			"word Channels;" & _
			"dword SamplesPerSec;" & _
			"dword AvgBytesPerSec;" & _
			"word BlockAlign;" & _
			"word BitsPerSample;" & _
			"word Size")
	; DSBUFFERDESC structure (http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.dsbufferdesc(VS.85).aspx)
	Local $tDSBUFFERDESC = DllStructCreate("dword Size;" & _
			"dword Flags;" & _
			"dword BufferBytes;" & _
			"dword Reserved;" & _
			"ptr Format")
	; Some constants
	Local Const $DSBCAPS_CTRLPOSITIONNOTIFY = 256
	Local Const $DSBCAPS_CTRLFREQUENCY = 32
	Local Const $DSBCAPS_GLOBALFOCUS = 32768
	Local Const $DSSCL_NORMAL = 1
	Local Const $WAVE_FORMAT_PCM = 1
	Local Const $DSBLOCK_ENTIREBUFFER = 2
	Local Const $DSBPLAY_LOOPING = 1
	Local Const $BITS_PER_SAMPLE = 16
	Local Const $NUM_CHANNELS = 2 ; stereo (no particular reason why)
	Local Const $SAMPLING_RATE = 44100
	; Derived
	Local Const $SCALE = BitShift(1, -($BITS_PER_SAMPLE - 1)) - 1
	; Let's go. DirectSound8 over DirectSound only because of the convinient links (http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.directsoundcreate8(VS.85).aspx)
	Local $aCall = DllCall("dsound.dll", "long", "DirectSoundCreate8", _
			"ptr", 0, _
			"ptr*", 0, _
			"ptr", 0)
	If @error Or $aCall[0] Then
		Return SetError(1, 0, 0) ; DirectSoundCreate8 or call to it failed
	EndIf
	; Collect
	Local $pDSound = $aCall[2]
	; Define IDirectSound8 vTable methods
	Local $tagIDirectSound = "QueryInterface;" & _
			"AddRef;" & _
			"Release;" & _ ; IUnknown
			"CreateSoundBuffer;" & _
			"GetCaps;" & _
			"DuplicateSoundBuffer;" & _
			"SetCooperativeLevel;" & _
			"Compact;" & _
			"GetSpeakerConfig;" & _
			"SetSpeakerConfig;" & _
			"Initialize;" & _ ; IDirectSound
			"VerifyCertification;" ; IDirectSound8
	; Wrapp IDirectSound8 interface
	Local $oIDirectSound8 = _AutoItObject_WrapperCreate($pDSound, $tagIDirectSound)
	; Byrocracy... (http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.idirectsound8.idirectsound8.setcooperativelevel(VS.85).aspx)
	Local $aCall = $oIDirectSound8.SetCooperativeLevel("long", "hwnd", Number(_WinAPI_GetDesktopWindow()), "dword", $DSSCL_NORMAL)
	If Not IsArray($aCall) Or $aCall[0] Then
		$oIDirectSound8 = 0
		Return SetError(2, 0, 0) ; SetCooperativeLevel failed
	EndIf
	; Fill the structures
	DllStructSetData($tWAVEFORMATEX, "FormatTag", $WAVE_FORMAT_PCM)
	DllStructSetData($tWAVEFORMATEX, "Channels", $NUM_CHANNELS)
	DllStructSetData($tWAVEFORMATEX, "BitsPerSample", $BITS_PER_SAMPLE)
	DllStructSetData($tWAVEFORMATEX, "SamplesPerSec", $SAMPLING_RATE)
	DllStructSetData($tWAVEFORMATEX, "BlockAlign", $NUM_CHANNELS * $BITS_PER_SAMPLE / 8)
	DllStructSetData($tWAVEFORMATEX, "AvgBytesPerSec", $SAMPLING_RATE * $NUM_CHANNELS * $BITS_PER_SAMPLE / 8)
	DllStructSetData($tWAVEFORMATEX, "Size", 0)
	; With DSBUFFERDESC too
	DllStructSetData($tDSBUFFERDESC, "Size", DllStructGetSize($tDSBUFFERDESC))
	DllStructSetData($tDSBUFFERDESC, "Flags", BitOR($DSBCAPS_CTRLPOSITIONNOTIFY, $DSBCAPS_CTRLFREQUENCY, $DSBCAPS_GLOBALFOCUS))
	DllStructSetData($tDSBUFFERDESC, "Format", DllStructGetPtr($tWAVEFORMATEX))
	; Zero
	Local $iHalfPeriod = Int($SAMPLING_RATE * $NUM_CHANNELS / (2 * $iFrequency))
	; Limit
	If $iHalfPeriod < 1 Then $iHalfPeriod = 1
	; Calculate buffer size
	Local $iBufferSize = Int(2 * $iHalfPeriod * $BITS_PER_SAMPLE / 8)
	; Set buffer size
	DllStructSetData($tDSBUFFERDESC, "BufferBytes", $iBufferSize)
	; Make SoundBuffer (http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.idirectsound8.idirectsound8.createsoundbuffer(VS.85).aspx)
	$aCall = $oIDirectSound8.CreateSoundBuffer("long", "ptr", Number(DllStructGetPtr($tDSBUFFERDESC)), "ptr*", 0, "ptr", 0)
	If Not IsArray($aCall) Or $aCall[0] Then
		$oIDirectSound8 = 0
		Return SetError(3, 0, 0) ; CreateSoundBuffer failed
	EndIf
	; Collect data
	Local $pDirectSoundBuffer = $aCall[3]
	; Define IDirectSoundBuffer vTable methods
	Local $tagIDirectSoundBuffer = "QueryInterface;" & _
			"AddRef;" & _
			"Release;" & _ ; IUnknown
			"GetCaps;" & _
			"GetCurrentPosition;" & _
			"GetFormat;" & _
			"GetVolume;" & _
			"GetPan;" & _
			"GetFrequency;" & _
			"GetStatus;" & _
			"Initialize;" & _
			"Lock;" & _
			"Play;" & _
			"SetCurrentPosition;" & _
			"SetFormat;" & _
			"SetVolume;" & _
			"SetPan;" & _
			"SetFrequency;" & _
			"Stop;" & _
			"Unlock;" & _
			"Restore;" ; DirectSoundBuffer
	; Wrapp IDirectSoundBuffer interface
	Local $oIDirectSoundBuffer = _AutoItObject_WrapperCreate($pDirectSoundBuffer, $tagIDirectSoundBuffer)
	; Get frequency
	$aCall = $oIDirectSoundBuffer.GetFrequency("long", "dword*", 0)
	If Not IsArray($aCall) Then
		$oIDirectSoundBuffer = 0
	    $oIDirectSound8 = 0
		Return SetError(4, 0, 0) ; GetFrequency failed
	EndIf
	; Collect data
	Local $iPlayFreq = $aCall[2]
	; Correct input frequency (integer rounding)
	$iPlayFreq = $iPlayFreq * 2 * $iFrequency * $iHalfPeriod / ($SAMPLING_RATE * $NUM_CHANNELS)
	; Set corrected frequency
	$aCall = $oIDirectSoundBuffer.SetFrequency("long", "dword", $iPlayFreq)
	; Get pointer to buffer where audio is stored
	$aCall = $oIDirectSoundBuffer.Lock("long", "dword", 0, "dword", $iBufferSize, "ptr*", 0, "dword*", 0, "ptr", 0, "ptr", 0, "dword", $DSBLOCK_ENTIREBUFFER)
	If Not IsArray($aCall) Or $aCall[0] Then
		$oIDirectSoundBuffer = 0
	    $oIDirectSound8 = 0
		Return SetError(5, 0, 0) ; Lock
	EndIf
	; Collect interesting data out of that call
	Local $pWrite = $aCall[4]
	Local $iLen = $aCall[5]
	; Make writable buffer at thet address
	Local $tSoundBuffer = DllStructCreate("short[" & $iLen / 2 & "]", $pWrite)
	; Write square wave
	For $i = 1 To $iHalfPeriod ; First half is below 0
		DllStructSetData($tSoundBuffer, 1, -$SCALE, $i)
	Next
	For $i = $iHalfPeriod + 1 To $iLen / 2 ; Second is above
		DllStructSetData($tSoundBuffer, 1, $SCALE, $i)
	Next
	; Unlock memory (will not check for errors from now on since it's just call, call, call... situation)
	$oIDirectSoundBuffer.Unlock("long", "ptr", $pWrite, "dword", $iLen, "ptr", 0, "dword", 0)
	; Set current position to 0 (start)
	$oIDirectSoundBuffer.SetCurrentPosition("long", "dword", 0)
	; Play the beep
	$oIDirectSoundBuffer.Play("long", "dword", 0, "dword", 0, "dword", $DSBPLAY_LOOPING)
	; Sleep for duration
	Sleep($iDuration)
	; Stop the beep
	$oIDirectSoundBuffer.Stop("long")
	;Release objects
	$oIDirectSoundBuffer = 0
	$oIDirectSound8 = 0
	; Return ok
	Return 1
EndFunc   ;==>_Beep
