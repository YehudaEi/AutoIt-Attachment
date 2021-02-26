
;.......script written by trancexx (trancexx at yahoo dot com)

#include <WinAPI.au3>

Opt("MustDeclareVars", 1)

; Interfaces
;===============================================================================
#interface "IDirectSound8"
Global Const $sCLSID_DirectSound8 = "{3901cc3f-84b5-4fa4-ba35-aa8172b8a09b}"
Global Const $sIID_IDirectSound8 = "{C50A7E93-F395-4834-9EF6-7FA99DE50966}"
; Definition
Global Const $tagIDirectSound8 = "CreateSoundBuffer hresult(struct*;ptr*;ptr);" & _
		"GetCaps hresult(struct*);" & _
		"DuplicateSoundBuffer hresult(ptr;ptr*);" & _
		"SetCooperativeLevel hresult(hwnd;dword);" & _
		"Compact hresult();" & _
		"GetSpeakerConfig hresult(dword*);" & _
		"SetSpeakerConfig hresult(dword);" & _
		"Initialize hresult(struct*);" & _
		"VerifyCertification hresult(dword*);"
;===============================================================================
;===============================================================================
#interface "IDirectSoundBuffer"
Global Const $sIID_IDirectSoundBuffer = "{279AFA85-4981-11CE-A521-0020AF0BE560}"
; Definition
Global Const $tagIDirectSoundBuffer = "GetCaps hresult(struct*);" & _
		"GetCurrentPosition hresult(dword*;dword*);" & _
		"GetFormat hresult(struct*;dword;dword*);" & _
		"GetVolume hresult(long*);" & _
		"GetPan hresult(long*);" & _
		"GetFrequency hresult(dword*);" & _
		"GetStatus hresult(dword*);" & _
		"Initialize hresult(ptr;struct*);" & _
		"Lock hresult(dword;dword;ptr*;dword*;ptr;ptr;dword);" & _
		"Play hresult(dword;dword;dword);" & _
		"SetCurrentPosition hresult(dword);" & _
		"SetFormat hresult(struct*);" & _
		"SetVolume hresult(long);" & _
		"SetPan hresult(long);" & _
		"SetFrequency hresult(dword);" & _
		"Stop hresult();" & _
		"Unlock hresult(ptr;dword;ptr;dword);" & _
		"Restore hresult();"
;===============================================================================



Global $__DS_oIDirectSound8, $__DS_tDSBUFFERDESC, $__DS_tWAVEFORMATEX

Func _StartDSBeep()
	; WAVEFORMATEX structure ( http://msdn.microsoft.com/en-us/library/windows/desktop/dd390970(v=vs.85).aspx )
	$__DS_tWAVEFORMATEX = DllStructCreate("align 2;word FormatTag;" & _
			"word Channels;" & _
			"dword SamplesPerSec;" & _
			"dword AvgBytesPerSec;" & _
			"word BlockAlign;" & _
			"word BitsPerSample;" & _
			"word Size")
	; DSBUFFERDESC structure ( http://msdn.microsoft.com/en-us/library/windows/desktop/microsoft.directx_sdk.reference.dsbufferdesc(v=vs.85).aspx )
	$__DS_tDSBUFFERDESC = DllStructCreate("dword Size;" & _
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
	Local Const $BITS_PER_SAMPLE = 16
	Local Const $NUM_CHANNELS = 2 ; stereo (no particular reason why)
	Local Const $SAMPLING_RATE = 44100
	; Derived
	Local Const $SCALE = BitShift(1, -($BITS_PER_SAMPLE - 1)) - 1

	; DirectSound8 interface object
	$__DS_oIDirectSound8 = ObjCreateInterface($sCLSID_DirectSound8, $sIID_IDirectSound8, $tagIDirectSound8)
	If @error Then Return 0

	; Initialization call
	$__DS_oIDirectSound8.Initialize(0)

	; Fill the structures
	DllStructSetData($__DS_tWAVEFORMATEX, "FormatTag", $WAVE_FORMAT_PCM)
	DllStructSetData($__DS_tWAVEFORMATEX, "Channels", $NUM_CHANNELS)
	DllStructSetData($__DS_tWAVEFORMATEX, "BitsPerSample", $BITS_PER_SAMPLE)
	DllStructSetData($__DS_tWAVEFORMATEX, "SamplesPerSec", $SAMPLING_RATE)
	DllStructSetData($__DS_tWAVEFORMATEX, "BlockAlign", $NUM_CHANNELS * $BITS_PER_SAMPLE / 8)
	DllStructSetData($__DS_tWAVEFORMATEX, "AvgBytesPerSec", $SAMPLING_RATE * $NUM_CHANNELS * $BITS_PER_SAMPLE / 8)
	DllStructSetData($__DS_tWAVEFORMATEX, "Size", 0)
	; DSBUFFERDESC too
	DllStructSetData($__DS_tDSBUFFERDESC, "Size", DllStructGetSize($__DS_tDSBUFFERDESC))
	DllStructSetData($__DS_tDSBUFFERDESC, "Flags", BitOR($DSBCAPS_CTRLPOSITIONNOTIFY, $DSBCAPS_CTRLFREQUENCY, $DSBCAPS_GLOBALFOCUS))
	DllStructSetData($__DS_tDSBUFFERDESC, "Format", DllStructGetPtr($__DS_tWAVEFORMATEX))
	$__DS_oIDirectSound8.SetCooperativeLevel(_WinAPI_GetDesktopWindow(), $DSSCL_NORMAL)
	Return 1
EndFunc   ;==>_StartDSBeep

Func _StopDSBeep()
	$__DS_oIDirectSound8 = 0
	$__DS_tDSBUFFERDESC = 0
	$__DS_tWAVEFORMATEX = 0
EndFunc   ;==>_StopDSBeep

Func _Beep($iNote = 0, $iOctave = 4, $iDuration = 200, $iPause = 0, $nTempo = 1, $iTone = 0)
	; Sanity check
	If Not IsObj($__DS_oIDirectSound8) Then Return SetError(1, 0, 0)

	; Input parameters
	Local Static $nTempoLocal = $nTempo
	If @NumParams > 4 Then $nTempoLocal = $nTempo
	Local Static $iToneLocal = $iTone
	If @NumParams > 5 Then $iToneLocal = $iTone
	Local $iFrequency = 440 * 2 ^ (($iNote + $iToneLocal) / 12 + $iOctave + 1 / 6 - 4)
	$iDuration = $iDuration / $nTempoLocal
	Local $iSleep = $iPause / $nTempoLocal
	Local Const $DSBLOCK_ENTIREBUFFER = 2
	Local Const $DSBPLAY_LOOPING = 1
	Local Const $BITS_PER_SAMPLE = 16
	Local Const $NUM_CHANNELS = 2 ; stereo (no particular reason why)
	Local Const $SAMPLING_RATE = 44100
	; Derived
	Local Const $SCALE = BitShift(1, -($BITS_PER_SAMPLE - 1)) - 1 ; Byrocracy
	; Zero
	Local $iHalfPeriod = Int($SAMPLING_RATE * $NUM_CHANNELS / (2 * $iFrequency))
	; Limit
	If $iHalfPeriod < 1 Then $iHalfPeriod = 1
	; Calculate buffer size
	Local $iBufferSize = Int(2 * $iHalfPeriod * $BITS_PER_SAMPLE / 8)
	; Set buffer size
	DllStructSetData($__DS_tDSBUFFERDESC, "BufferBytes", $iBufferSize)

	; Make SoundBuffer ( http://msdn.microsoft.com/en-us/library/windows/desktop/microsoft.directx_sdk.idirectsound8.idirectsound8.createsoundbuffer(v=vs.85).aspx )
	Local $pDirectSoundBuffer
	$__DS_oIDirectSound8.CreateSoundBuffer($__DS_tDSBUFFERDESC, $pDirectSoundBuffer, 0)

	; Wrapp IDirectSoundBuffer interface
	Local $oIDirectSoundBuffer = ObjCreateInterface($pDirectSoundBuffer, $sIID_IDirectSoundBuffer, $tagIDirectSoundBuffer)

	; Get frequency
	Local $iPlayFreq
	$oIDirectSoundBuffer.GetFrequency($iPlayFreq)

	; Correct input frequency (integer rounding)
	$iPlayFreq = $iPlayFreq * 2 * $iFrequency * $iHalfPeriod / ($SAMPLING_RATE * $NUM_CHANNELS)
	; Set corrected frequency
	$oIDirectSoundBuffer.SetFrequency($iPlayFreq)

	; Get pointer to buffer where audio is stored
	Local $pWrite, $iLen
	$oIDirectSoundBuffer.Lock(0, $iBufferSize, $pWrite, $iLen, 0, 0, $DSBLOCK_ENTIREBUFFER)

	; Make writable buffer at thet address
	Local $tSoundBuffer = DllStructCreate("short[" & $iLen / 2 & "]", $pWrite)
	; Write square wave (to get sound similar to onboard buzzer's)
	For $i = 1 To $iHalfPeriod ; First half is below 0
		DllStructSetData($tSoundBuffer, 1, -$SCALE, $i)
	Next
	For $i = $iHalfPeriod + 1 To $iLen / 2 ; Second is above
		DllStructSetData($tSoundBuffer, 1, $SCALE, $i)
	Next
	; Unlock memory
	$oIDirectSoundBuffer.Unlock($pWrite, $iLen, 0, 0)
	; Set current position to 0 (start)
	$oIDirectSoundBuffer.SetCurrentPosition(0)

	; Play the beep
	$oIDirectSoundBuffer.Play(0, 0, $DSBPLAY_LOOPING)
	; Sleep for duration
	Sleep($iDuration)
	; Stop the beep
	$oIDirectSoundBuffer.Stop()
    ; Sleep for pause
	Sleep($iSleep)

	; Return ok
	Return 1
EndFunc   ;==>_Beep
