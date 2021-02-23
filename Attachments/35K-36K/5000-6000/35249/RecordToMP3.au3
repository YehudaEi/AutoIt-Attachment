#AutoIt3Wrapper_UseX64=n

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <UpdownConstants.au3>
#include <WinAPI.au3>

Opt("MustDeclareVars", 1)

; Current WaveIn and LameEnc functions used in this example.
; # _WaveIn Functions # =========================================================================================================
;_waveInAddBuffer
;_waveInClose
;_waveInGetErrorText
;_waveInOpen
;_waveInPrepareHeader
;_waveInProc ; this is a place holder function, that the user should impliment to suit their own needs.
;_waveInReset
;_waveInStart
;_waveInStop
;_waveInUnprepareHeader
; ===============================================================================================================================
; #_LameEnc Functions# ==========================================================================================================
;_LameEnc_Close
;_LameEnc_CloseStream
;_LameEnc_DeinitStream
;_LameEnc_EncodeChunk
;_LameEnc_InitStream
;_LameEnc_Open
; ===============================================================================================================================

; #_WaveIn CONSTANTS# ========================================================================================================
Global Const $MAXERRORLENGTH = 256 ; max error text length used for _waveInGetErrorText
Global Const $CALLBACK_WINDOW = 0x00010000 ;/* dwCallback is a HWND */
Global Const $WAVE_MAPPER = -1 ; Used in as DeviceID in _waveInOpen
Global Const $WAVE_FORMAT_PCM = 1 ; Used in WAVEFORMATEX structure "wFormatTag"
Global Const $WAVE_FORMAT_QUERY = 0x0001 ; Used in _waveInOpen as $iOpenFlag parameter to query the wave device.

; Messages that will be passed to the callback function.
Global Const $WIM_OPEN = 0x3BE
Global Const $WIM_CLOSE = 0x3BF
Global Const $WIM_DATA = 0x3C0

; tag structures used for WaveIn
Global Const $tag_WAVEFORMATEX = _
		"WORD wFormatTag;" & _             ; /* format type */
		"WORD nChannels;" & _              ; /* number of channels (i.e. mono, stereo...) */
		"DWORD nSamplesPerSec;" & _        ; /* sample rate */
		"DWORD nAvgBytesPerSec;" & _       ; /* for buffer estimation */
		"WORD nBlockAlign;" & _            ; /* block size of data */
		"WORD wBitsPerSample;" & _         ; /* number of bits per sample of mono data */
		"WORD cbSize;" ; /* the count in bytes of the size of */
Global Const $tag_WAVEHDR = _
		"ptr lpData;" & _                  ; /* pointer to locked data buffer */
		"DWORD dwBufferLength;" & _        ; /* length of data buffer */
		"DWORD dwBytesRecorded;" & _       ; /* used for input only */
		"DWORD_PTR dwUser;" & _            ; /* for client's use */
		"DWORD dwFlags;" & _               ; /* assorted flags (see defines) */
		"DWORD dwLoops;" & _               ; /* loop control counter */
		"PTR lpNext;" & _                  ; /* reserved for driver */"struct wavehdr_tag FAR *lpNext;"
		"DWORD_PTR reserved;" ; /* reserved for driver */

; ===============================================================================================================================

; #_LameEnc CONSTANTS & VARIABLES# ==============================================================================================
; tag Config structure used with LameEnc.
Global Const $tag_BE_CONFIG = _ ;   {
		"DWORD  dwConfig;" & _ ;            // BE_CONFIG_LAME
		"DWORD  dwStructVersion;" & _ ;    // LAME header version 1
		"DWORD  dwStructSize;" & _ ;       // Size of this structure (332 in autoit, should be 331)
		"DWORD  dwSampleRate;" & _ ;        // SAMPLERATE OF INPUT FILE
		"DWORD  dwReSampleRate;" & _ ;  // DOWNSAMPLERATE, 0=ENCODER DECIDES
		"LONG   nMode;" & _ ;               // BE_MP3_MODE_STEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO
		"DWORD  dwBitrate;" & _ ;           // CBR bitrate, VBR min bitrate
		"DWORD  dwMaxBitrate;" & _ ;        // CBR ignored, VBR Max bitrate
		"LONG   nPreset;" & _ ;         // Quality preset, use one of the settings of the LAME_QUALITY_PRESET enum
		"DWORD  dwMpegVersion;" & _ ;       // FUTURE USE, MPEG-1 OR MPEG-2
		"DWORD  dwPsyModel;" & _ ;          // FUTURE USE, SET TO 0
		"DWORD  dwEmphasis;" & _ ;          // FUTURE USE, SET TO 0
		"BOOL   bPrivate;" & _ ;            // Set Private Bit (TRUE/FALSE)
		"BOOL   bCRC;" & _ ;                // Insert CRC (TRUE/FALSE)
		"BOOL   bCopyright;" & _ ;          // Set Copyright Bit (TRUE/FALSE)
		"BOOL   bOriginal;" & _ ;           // Set Original Bit (TRUE/FALSE)
		"BOOL   bWriteVBRHeader;" & _ ; // WRITE XING VBR HEADER (TRUE/FALSE)
		"BOOL   bEnableVBR;" & _ ;          // USE VBR ENCODING (TRUE/FALSE)
		"INT    nVBRQuality;" & _ ;     // VBR QUALITY 0..9
		"DWORD  dwVbrAbr_bps;" & _ ;        // Use ABR in stead of nVBRQuality
		"UINT   nVbrMethod;" & _ ;
		"BOOL   bNoRes; " & _ ;         // Disable Bit resorvoir (TRUE/FALSE)
		"BOOL   bStrictIso;" & _ ;          // Use strict ISO encoding rules (TRUE/FALSE)
		"WORD   nQuality;" & _ ;            // Quality Setting, HIGH BYTE should be NOT LOW byte, otherwhise quality=5
		"BYTE   btReserved[" & 255 - 4 * 4 - 2 & "]"
Global $h_LameEncDLL = -1
; ===============================================================================================================================

; General global variables used for the example
Global $sOutMP3 = @ScriptDir & "\RTM.mp3" ; A number will auto be added to this. (eg: 000_RTM.mp3)
Global $sIni = @ScriptDir & "\RTM.ini"
Global $sLameEncDll = "lame_enc.dll"
Global $hGui, $iPresetWaweIn, $iPresetMP3, $iDevice, $iMP3Path, $iSaveAs, $iBrowse
Global $iPlay, $iLastFile, $iRecord, $iElapsed, $iMP3Size, $iDriveSpace, $iStatus
Global $iSizeLimit, $iSizeUD, $iSizeStop, $iTimeStop, $iTimeLimit, $iSpaceLimit, $iSpaceUD
Global $iTimeStart, $iStartTime, $aDay[8] = ["Every Day", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], $iStartFlag
Global $iFDS, $sFDS, $sLastFDS
Global $hWaveIn, $hWaveInProc, $tWaveFormatEx, $atWaveHdr[2], $atWavBuf[2]
Global $iError, $iStopFlag = 1, $iBytesReceived, $iBytesWritten, $iTime, $sTmpTime
Global $tMP3Cfg, $tMP3Buf, $iSamples, $iMP3Buffer, $hStream, $iOutput, $iWritten
Global $hWriteOut, $sCurFile = _NumberFile($sOutMP3), $sLastFile, $sTmpMP3, $sTmpMP3Last

$hGui = GUICreate("Record To MP3", 355, 380, @DesktopWidth - 380, -1, -1, $WS_EX_TOPMOST)
GUICtrlCreateGroup("Wave in recording quality", 5, 5, 235, 55)
$iPresetWaweIn = GUICtrlCreateCombo("", 15, 25, 215, 20, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
GUICtrlSetData(-1, _CreateComboPreset(), "44.100 kHz, 16 bit, Stereo, 172 kb/sec")
GUICtrlCreateGroup("MP3 out bitrate", 245, 5, 105, 55)
$iPresetMP3 = GUICtrlCreateCombo("", 255, 25, 85, 20, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
GUICtrlSetData(-1, "32 Kbps|40 Kbps|48 Kbps|56 Kbps|64 Kbps|80 Kbps|96 Kbps|112 Kbps|128 Kbps|160 Kbps|192 Kbps|224 Kbps|256 Kbps|320 Kbps", "128 Kbps")
GUICtrlCreateGroup("Save recording as...", 5, 65, 345, 55)
$iMP3Path = GUICtrlCreateInput(_NumberFile($sOutMP3), 15, 85, 290, 20, BitOR($ES_READONLY, $ES_AUTOHSCROLL))
GUICtrlSetBkColor(-1, 0xFFFFFF)
$iSaveAs = GUICtrlCreateButton("<", 310, 80, 30, 30)
GUICtrlSetFont(-1, 14, 400, 0, "wingdings")
GUICtrlSetTip(-1, "Save recording as...")
GUICtrlCreateGroup("Stop at size, timer, free space", 5, 205, 170, 110)
$iSizeStop = GUICtrlCreateCheckbox("Size limit MB", 15, 225, 80, 20)
GUICtrlSetFont(-1, 8.5, 400, 0, "Arial")
$iSizeLimit = GUICtrlCreateInput("1", 95, 225, 70, 20, BitOR($ES_NUMBER, $ES_RIGHT))
GUICtrlSetTip(-1, "If a recording reaches this size stop recording.")
GUICtrlSetState(-1, $GUI_DISABLE)
$iSizeUD = GUICtrlCreateUpdown(-1, $UDS_NOTHOUSANDS)
GUICtrlSetState(-1, $GUI_DISABLE)
$iTimeStop = GUICtrlCreateCheckbox("Timer H:M:S", 15, 253, 80, 20)
GUICtrlSetFont(-1, 8.5, 400, 0, "Arial")
$iTimeLimit = GUICtrlCreateDate("00:00:00", 95, 253, 70, 20, 9); $DTS_TIMEFORMAT = 9
GUICtrlSetTip(-1, "If a recording reaches this time limit stop recording." & @LF & "00:00:00 = 24 hours")
GUICtrlSendMsg($iTimeLimit, 0x1032, 0, "HH:mm:ss"); $DTM_SETFORMATW =  0x1032
GUICtrlSetState(-1, $GUI_DISABLE)
$iSpaceLimit = GUICtrlCreateInput("2", 95, 280, 70, 20, BitOR($ES_NUMBER, $ES_RIGHT))
GUICtrlSetTip(-1, "Stop recording if free drive space reaches this amount.")
$iSpaceUD = GUICtrlCreateUpdown(-1, $UDS_NOTHOUSANDS)
$iPlay = GUICtrlCreateButton("4", 105, 335, 30, 30, $BS_ICON)
GUICtrlSetFont(-1, 14, 400, 0, "webdings")
GUICtrlSetTip(-1, "Play last recording with windows default player.")
GUICtrlSetState(-1, $GUI_DISABLE)
$iLastFile = GUICtrlCreateLabel("", 140, 340, 145, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10)
GUICtrlCreateLabel("Free Space MB", 15, 283, 80, 16)
GUICtrlSetFont(-1, 8.5, 400, 0, "Arial")
GUICtrlCreateGroup("Start recording at time and selected days", 5, 125, 345, 75)
$iTimeStart = GUICtrlCreateCheckbox("Start recording at selected time:", 15, 145, 170, 20)
GUICtrlSetFont(-1, 8.5, 400, 0, "Arial")
$iStartTime = GUICtrlCreateDate("00:00", 189, 145, 75, 20, 9); $DTS_TIMEFORMAT = 9
GUICtrlSetTip(-1, "Start recording at this time on selected days.")
GUICtrlSendMsg($iStartTime, 0x1032, 0, "hh:mm tt"); $DTM_SETFORMATW =  0x1032
$aDay[0] = GUICtrlCreateCheckbox("Every Day", 270, 145, 70, 20);, BitOR($BS_RIGHT, $BS_RIGHTBUTTON))
GUICtrlSetState(-1, $GUI_CHECKED)
For $i = 0 To 6
	$aDay[$i + 1] = GUICtrlCreateCheckbox($aDay[$i + 1], 15 + ($i * 48), 170, 46, 20)
	GUICtrlSetTip(-1, "Select days to start recording")
	GUICtrlSetState(-1, BitOR($GUI_CHECKED, $GUI_DISABLE))
Next
GUICtrlCreateGroup("Recording Information", 180, 205, 170, 110)
$iStatus = GUICtrlCreateLabel("Status: STOPPED", 185, 225, 160, 20, $SS_CENTER);
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$iMP3Size = GUICtrlCreateLabel("MP3 Size: 0.00 MB", 185, 245, 160, 20, $SS_CENTER);, 185, 165, 160, 20
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$iElapsed = GUICtrlCreateLabel("Time Elapsed: 00:00:00", 185, 265, 160, 20, $SS_CENTER)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$iDriveSpace = GUICtrlCreateLabel("", 185, 285, 160, 20, $SS_CENTER)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlCreateGroup("Other options", 5, 320, 85, 55)
$iDevice = GUICtrlCreateButton("@", 15, 335, 30, 30, $BS_ICON)
GUICtrlSetFont(-1, 14, 400, 0, "webdings")
GUICtrlSetTip(-1, "Configure the device to record from.")
$iBrowse = GUICtrlCreateButton("1", 50, 335, 30, 30)
GUICtrlSetFont(-1, 14, 400, 0, "wingdings")
GUICtrlSetTip(-1, "Browse recording directory.")
GUICtrlCreateGroup("Play last recorded file.", 95, 320, 200, 55)
$iRecord = GUICtrlCreateButton("l", 300, 325, 50, 50)
GUICtrlSetFont(-1, 24, 400, 0, "wingdings")
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetTip(-1, "Start recording.")
_LoadIni()
_DiveSpace()
GUISetState(@SW_SHOW, $hGui)

; Register to make Size And Free Space Input conrols can only be set to a minimum value.
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

; updates the gui with free drive space, recording time elapsed, enable disable play last recorded file.
AdlibRegister("_DiveSpace", 1000)

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			_Quit()
		Case $iSaveAs
			_SaveAs()
		Case $iTimeStart
			_SetTimeDayCtrls(1)
		Case $aDay[0]
			_SetTimeDayCtrls(2)
		Case $aDay[1] To $aDay[7]
			_SetTimeDayCtrls(3)
		Case $iSizeStop, $iTimeStop
			_SizeTimeCtrlState()
		Case $iDevice
			If StringInStr("WIN_XP|WIN_2000", @OSVersion) Then
				ShellExecute("sndvol32", "/r")
			Else
				ShellExecute("control.exe", "mmsys.cpl,,1") ;haven't tested this yet.
			EndIf
		Case $iBrowse
			ShellExecute(StringLeft($sOutMP3, StringInStr($sOutMP3, "\", 0, -1)))
		Case $iPlay
			If FileExists($sLastFile) Then
				ShellExecute($sLastFile)
			Else
				$sLastFile = ""
			EndIf
		Case $iRecord
			If GUICtrlRead($iRecord) = "l" Then
				_StartRecording()
			Else
				_StopRecording()
			EndIf
	EndSwitch
WEnd

; Start recording by setting up WaveIn device, MP3 encoder, out mp3 file,  wav and mp3 buffers...etc
Func _StartRecording()
	If Not FileExists($sLameEncDll) Then Return MsgBox(48, $sLameEncDll, "You require " & $sLameEncDll & " in the script directory.")
	GUICtrlSetData($iRecord, "n")
	GUICtrlSetColor($iRecord, 0x000000)
	GUICtrlSetTip($iRecord, "Stop recording.")
	GUICtrlSetState($iRecord, $GUI_DISABLE)
	GUICtrlSetState($iSaveAs, $GUI_DISABLE)
	For $i = $iPresetWaweIn To $iLastFile
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
	_SetTimeDayCtrls(-1)

	ConsoleWrite("|======= Start Record Session Log =======|" & @LF)

	; Create a WaveFormatEx structure with wave settings that the WaveIn device will use.
	$tWaveFormatEx = DllStructCreate($tag_WAVEFORMATEX)
	ConsoleWrite("| DllStructCreate($tag_WAVEFORMATEX): " & (IsDllStruct($tWaveFormatEx) = 1) & @LF)
	If Not IsDllStruct($tWaveFormatEx) Then Return _StopRecording()
	DllStructSetData($tWaveFormatEx, "wFormatTag", $WAVE_FORMAT_PCM)
	_WaveFormatExFromCombo(GUICtrlRead($iPresetWaweIn), $tWaveFormatEx)
	DllStructSetData($tWaveFormatEx, "cbSize ", 0)

	; Query if the format is supported by the WaveIn device.
	_waveInOpen($hWaveIn, $WAVE_MAPPER, DllStructGetPtr($tWaveFormatEx), 0, 0, $WAVE_FORMAT_QUERY)
	$iError = @error
	ConsoleWrite("| _waveInOpen query supported format: " & _waveInGetErrorText($iError) & @LF)
	If $iError Then Return _StopRecording()

	; This flag tells WriteMP3 function to keep adding the returned buffer back to the WaveIn device once it's been encoded.
	$iStopFlag = 0

	; Using the Gui handle to catch WaveIn device events so register the messages to catch events.
	GUIRegisterMsg($WIM_OPEN, "_waveInProc")
	GUIRegisterMsg($WIM_CLOSE, "_waveInProc")
	GUIRegisterMsg($WIM_DATA, "_waveInProc")

	; Open the WaveIn device, passing it the $tWaveFormatEx and Gui handle.
	_waveInOpen($hWaveIn, $WAVE_MAPPER, DllStructGetPtr($tWaveFormatEx), $hGui, 0, $CALLBACK_WINDOW)
	$iError = @error
	ConsoleWrite("| _waveInOpen open wave in device: " & _waveInGetErrorText($iError) & @LF)
	If $iError Or Not $hWaveIn Then Return _StopRecording()

	; Open lame_enc.dll
	_LameEnc_Open($sLameEncDll)
	$iError = @error
	ConsoleWrite("| _LameEnc_Open: " & ($iError = 0) & @LF)
	If $iError Then Return _StopRecording()

	; Create a struct with some basic lame encoder settings
	$tMP3Cfg = DllStructCreate($tag_BE_CONFIG)
	ConsoleWrite("| DllStructCreate($tag_BE_CONFIG): " & (IsDllStruct($tMP3Cfg) = 1) & @LF)
	If Not IsDllStruct($tMP3Cfg) Then Return _StopRecording()
	DllStructSetData($tMP3Cfg, "dwConfig", 256) ;// BE_CONFIG_LAME
	DllStructSetData($tMP3Cfg, "dwStructVersion", 1) ;// Struct version (LVH1)
	DllStructSetData($tMP3Cfg, "dwStructSize", DllStructGetSize($tMP3Cfg)); // Struct Size
	DllStructSetData($tMP3Cfg, "dwSampleRate", DllStructGetData($tWaveFormatEx, "nSamplesPerSec")) ; // INPUT FREQUENCY
	If DllStructGetData($tWaveFormatEx, "nChannels") = 2 Then
		DllStructSetData($tMP3Cfg, "nMode", 1) ;BE_MP3_MODE_JSTEREO;   // OUTPUT IN JOINT STEREO
	Else
		DllStructSetData($tMP3Cfg, "nMode", 3) ;BE_MP3_MODE_MONO;   // OUTPUT IN MONO
	EndIf
	DllStructSetData($tMP3Cfg, "dwBitrate", StringRegExpReplace(GUICtrlRead($iPresetMP3), "\D", "")); // MINIMUM BIT RATE
	DllStructSetData($tMP3Cfg, "nPreset", 12) ;LQP_CBR;        // QUALITY PRESET SETTING
	If DllStructGetData($tWaveFormatEx, "nSamplesPerSec") >= 32000 Then DllStructSetData($tMP3Cfg, "dwMpegVersion", 1);MPEG1;    // MPEG VERSION (I or II)
	DllStructSetData($tMP3Cfg, "bOriginal", 1);                    // SET ORIGINAL FLAG

	; Initiate a stream for lame encoder, this tells us the size of the wav and mp3 buffers we'll need and also gives a pointer to the mp3 stream.
	_LameEnc_InitStream(DllStructGetPtr($tMP3Cfg), $iSamples, $iMP3Buffer, $hStream)
	$iError = @error
	ConsoleWrite("| _LameEnc_InitStream: " & ($iError = 0) & @LF)
	If $iError Then Return _StopRecording()

	; Create MP3 buffer to receive the encoded mp3 data
	$tMP3Buf = DllStructCreate("BYTE[" & $iMP3Buffer & "]")
	ConsoleWrite('| DllStructCreate("BYTE[" & $iMP3Buffer & "]"): ' & (IsDllStruct($tMP3Buf) = 1) & @LF)
	If Not IsDllStruct($tMP3Buf) Then _StopRecording()
	ConsoleWrite("| $tMP3Buf size: " & $iMP3Buffer & @LF)

	; Create a mp3 file to write data to.
	$hWriteOut = _WinAPI_CreateFile($sCurFile, 1, 4)
	ConsoleWrite("| _WinAPI_CreateFile to write mp3: " & ($hWriteOut <> 0) & @LF)
	If Not $hWriteOut Then _StopRecording(1)

	; Create 2 WaveHdr and 2 Wav buffer structs to record wav data into (double buffer), prepare each WaveHdr and add each buffer.
	For $i = 0 To 1
		$atWavBuf[$i] = DllStructCreate("BYTE[" & $iSamples * 2 & "]")
		ConsoleWrite('| DllStructCreate("BYTE[" & $iSamples * 2 & "]") ' & $i & ': ' & (IsDllStruct($atWavBuf[$i]) = 1) & @LF)
		If Not IsDllStruct($atWavBuf[$i]) Then _StopRecording(1)
		ConsoleWrite("| $atWavBuf[" & $i & "] Size: " & DllStructGetSize($atWavBuf[$i]) & @LF)

		$atWaveHdr[$i] = DllStructCreate($tag_WAVEHDR)
		DllStructSetData($atWaveHdr[$i], "lpData", DllStructGetPtr($atWavBuf[$i]))
		DllStructSetData($atWaveHdr[$i], "dwBufferLength", DllStructGetSize($atWavBuf[$i]))
		DllStructSetData($atWaveHdr[$i], "dwFlags", 0)
		ConsoleWrite("| DllStructCreate($tag_WAVEHDR) " & $i & ": " & (IsDllStruct($atWaveHdr[$i]) = 1) & @LF)
		If Not IsDllStruct($atWaveHdr[$i]) Then _StopRecording(1)

		_waveInPrepareHeader($hWaveIn, DllStructGetPtr($atWaveHdr[$i]), DllStructGetSize($atWaveHdr[$i]))
		$iError = @error
		ConsoleWrite("| _waveInPrepareHeader WaveHdr " & $i & ": " & _waveInGetErrorText($iError) & @LF)
		If $iError Then Return _StopRecording(1)

		_waveInAddBuffer($hWaveIn, DllStructGetPtr($atWaveHdr[$i]), DllStructGetSize($atWaveHdr[$i]))
		$iError = @error
		ConsoleWrite("| _waveInAddBuffer WavBuf " & $i & ": " & _waveInGetErrorText($iError) & @LF)
		If $iError Then Return _StopRecording(1)
	Next

	; Start recording from the WaveIn device.
	_waveInStart($hWaveIn)
	$iError = @error
	ConsoleWrite("| _waveInStart: " & _waveInGetErrorText($iError) & @LF)
	If $iError Then Return _StopRecording(1)

	; Timer to display in the Gui for the time elapsed since we started recording and used by Timed stop
	$iTime = TimerInit()

	GUICtrlSetState($iRecord, $GUI_ENABLE)
	GUICtrlSetData($iStatus, "Status: RECORDING")
	GUICtrlSetColor($iStatus, 0xFF0000)
EndFunc   ;==>_StartRecording

; Stops recording or if things don't pan out it tidies up the resources.
Func _StopRecording($iCode = 0)
	GUICtrlSetData($iStatus, "Status: STOPPING")
	GUICtrlSetData($iElapsed, _TimeElapsed(TimerDiff($iTime)))
	GUICtrlSetState($iRecord, $GUI_DISABLE)

	$iStopFlag = 1
	If $hWaveIn Then
		;Stop and reset the WaveIn device
		_waveInStop($hWaveIn)
		_waveInReset($hWaveIn)
	EndIf
	$tWaveFormatEx = 0
	For $i = 0 To 1
		If IsDllStruct($atWaveHdr[$i]) Then
			; Unprepare the wavehdr, won't hurt even if the wavehdr wasn't prepared to start with.
			_waveInUnprepareHeader($hWaveIn, DllStructGetPtr($atWaveHdr[$i]), DllStructGetSize($atWaveHdr[$i]))
			$atWaveHdr[$i] = 0
		EndIf
		If IsDllStruct($atWavBuf[$i]) Then $atWavBuf[$i] = 0
	Next

	; close the WaveIn device.
	If $hWaveIn Then _waveInClose($hWaveIn)
	$hWaveIn = 0
	$iBytesWritten = 0
	$iTime = 0
	If $hStream Then
		If $hWriteOut Then
			; Flush any bytes left in the ecoder.
			_LameEnc_DeinitStream($hStream, DllStructGetPtr($tMP3Buf), $iOutput)

			; Write any data that was flushed from the encoder to the mp3 file.
			_WinAPI_WriteFile($hWriteOut, DllStructGetPtr($tMP3Buf), $iOutput, $iWritten)
		EndIf

		; Close the stream.
		_LameEnc_CloseStream($hStream)
	EndIf
	If $hWriteOut Then _WinAPI_CloseHandle($hWriteOut)
	If $h_LameEncDLL <> -1 Then _LameEnc_Close()
	If $iCode = 1 Then
		FileDelete($sCurFile)
	Else
		If FileExists($sCurFile) Then
			$sLastFile = $sCurFile
			GUICtrlSetData($iLastFile, StringTrimLeft($sLastFile, StringInStr($sLastFile, "\", 0, -1)))
			$sCurFile = _NumberFile($sOutMP3)
			GUICtrlSetData($iMP3Path, $sCurFile)
		EndIf
	EndIf
	$hWriteOut = 0
	$tMP3Cfg = 0
	$tMP3Buf = 0
	$iSamples = 0
	$iMP3Buffer = 0
	$hStream = 0
	$iOutput = 0
	$iWritten = 0
	GUIRegisterMsg($WIM_OPEN, "")
	GUIRegisterMsg($WIM_CLOSE, "")
	GUIRegisterMsg($WIM_DATA, "")

	; Update gui controls
	GUICtrlSetData($iRecord, "l")
	GUICtrlSetColor($iRecord, 0xFF0000)
	GUICtrlSetTip($iRecord, "Start recording.")
	GUICtrlSetState($iRecord, $GUI_ENABLE)
	For $i = $iPresetWaweIn To $iSaveAs
		GUICtrlSetState($i, $GUI_ENABLE)
	Next
	_SetTimeDayCtrls(0)
	GUICtrlSetState($iSizeStop, $GUI_ENABLE)
	GUICtrlSetState($iTimeStop, $GUI_ENABLE)
	GUICtrlSetState($iSpaceLimit, $GUI_ENABLE)
	GUICtrlSetState($iSpaceUD, $GUI_ENABLE)
	_SizeTimeCtrlState()
	GUICtrlSetData($iStatus, "Status: STOPPED")
	GUICtrlSetColor($iStatus, 0x000000)
	GUICtrlSetData($iElapsed, _TimeElapsed(0))
	GUICtrlSetData($iMP3Size, "MP3 Size: 0.00 MB")
	_DiveSpace()
EndFunc   ;==>_StopRecording

; Gets called by the Gui when WaveIn device sends an event msg
Func _waveInProc($hWnd, $iMsg, $wParam, $lParam)
	Switch $iMsg
		Case $WIM_OPEN
			ConsoleWrite("| _waveInProc Msg: Open" & @LF)
		Case $WIM_CLOSE
			ConsoleWrite("| _waveInProc Msg: Close" & @LF & "|======= End Record Session Log =======|" & @LF)
		Case $WIM_DATA
			If $lParam = DllStructGetPtr($atWaveHdr[0]) Then
				_WriteMP3(0)
			Else
				_WriteMP3(1)
			EndIf
	EndSwitch
EndFunc   ;==>_waveInProc

; Encodes the returned WaveIn buffer to mp3 and then writes the mp3 data to file and if not stopping adds the buffer back to the WaveIn device.
Func _WriteMP3($iData)

	If $iStopFlag Then Return 0

	; Encode the Wave buffer to mp3 buffer
	If Not _LameEnc_EncodeChunk($hStream, DllStructGetData($atWaveHdr[$iData], "dwBytesRecorded") / 2, DllStructGetPtr($atWavBuf[$iData]), DllStructGetPtr($tMP3Buf), $iOutput) Then
		ConsoleWrite("| _LameEnc_EncodeChunk error: " & @error & @LF)
		Return _StopRecording(1)
	EndIf

	; Write the bytes from the $MP3buf to the mp3 file.
	If Not _WinAPI_WriteFile($hWriteOut, DllStructGetPtr($tMP3Buf), $iOutput, $iWritten) Or ($iOutput <> $iWritten) Then
		ConsoleWrite("| _WinAPI_WriteFile in _WriteMP3 function failed to write a buffer to mp3 file." & @LF)
		If Not $iStopFlag Then Return _StopRecording(1)
	EndIf

	; Keep a running total of how many bytes are written to the mp3 file and display it in the gui.
	$iBytesWritten += $iWritten
	$sTmpMP3 = StringFormat("MP3 Size: %0.02f MB", $iBytesWritten / 1024 / 1024)
	If $sTmpMP3Last <> $sTmpMP3 Then
		GUICtrlSetData($iMP3Size, $sTmpMP3)
		$sTmpMP3Last = $sTmpMP3
	EndIf

	; Check to see if the drive still has space to record to.
	If $iFDS <= Number(GUICtrlRead($iSpaceLimit)) Then Return _StopRecording()

	; Check to see if stop recording at size is set.
	If BitAND(GUICtrlRead($iSizeStop), $GUI_CHECKED) And $iBytesWritten >= (GUICtrlRead($iSizeLimit) * 1024 * 1024) Then Return _StopRecording()

	; Check to see if stop recording time limit is set.
	If BitAND(GUICtrlRead($iTimeStop), $GUI_CHECKED) And TimerDiff($iTime) >= _TimeToMS(GUICtrlRead($iTimeLimit)) Then Return _StopRecording()

	; Add the buffer back to the WaveIn device to be filled again if the user hasn't asked to stop recording.
	If Not _waveInAddBuffer($hWaveIn, DllStructGetPtr($atWaveHdr[$iData]), DllStructGetSize($atWaveHdr[$iData])) Then
		ConsoleWrite("| _waveInAddBuffer in _WriteMP3 function error: " & _waveInGetErrorText(@error) & @LF)
		Return _StopRecording()
	EndIf
EndFunc   ;==>_WriteMP3

; File save dialog
Func _SaveAs()
	Local $FSD, $sPath, $sFile
	$sPath = StringLeft($sOutMP3, StringInStr($sOutMP3, "\", 0, -1))
	$sFile = StringTrimLeft($sOutMP3, StringInStr($sOutMP3, "\", 0, -1))
	$FSD = FileSaveDialog("Save As....", $sPath, "MP3 (*.mp3)", 2, $sFile, WinGetHandle(""))
	If Not @error Then
		If Not (StringRight($FSD, 4) = ".mp3") Then $FSD &= ".mp3"
		$sOutMP3 = $FSD
		$sCurFile = _NumberFile($sOutMP3)
		GUICtrlSetData($iMP3Path, $sCurFile)
	EndIf
EndFunc   ;==>_SaveAs

; Sets states of Start time and day controls
Func _SetTimeDayCtrls($iCode)
	Local $iDayFlag
	Switch $iCode
		Case -1 ;Disable All, for recording
			_SetTimeDayCtrls(3)
			For $i = $iTimeStart To $aDay[7]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		Case 0, 1 ;
			If Not $iCode Then GUICtrlSetState($iTimeStart, $GUI_ENABLE)
			If BitAND(GUICtrlRead($iTimeStart), $GUI_CHECKED) Then
				For $i = $iStartTime To $aDay[7]
					GUICtrlSetState($i, $GUI_DISABLE)
				Next
				_SetTimeDayCtrls(3)
			Else
				For $i = $iStartTime To $aDay[7]
					If $i <= $aDay[0] Or BitAND(GUICtrlRead($aDay[0]), $GUI_UNCHECKED) Then GUICtrlSetState($i, $GUI_ENABLE)
				Next
			EndIf
		Case 2
			If BitAND(GUICtrlRead($aDay[0]), $GUI_CHECKED) Then
				For $i = $aDay[1] To $aDay[7]
					GUICtrlSetState($i, $GUI_CHECKED)
					GUICtrlSetState($i, $GUI_DISABLE)
				Next
			Else
				For $i = 1 To 7
					GUICtrlSetState($aDay[$i], $GUI_ENABLE)
				Next
			EndIf
		Case 3
			For $i = 0 To 7
				If BitAND(GUICtrlRead($aDay[$i]), $GUI_CHECKED) Then $iDayFlag += 1
			Next
			If Not $iDayFlag Then
				For $i = 0 To 7
					GUICtrlSetState($aDay[$i], $GUI_CHECKED)
					If $i Then GUICtrlSetState($aDay[$i], $GUI_DISABLE)
				Next
			ElseIf $iDayFlag = 7 Then
				GUICtrlSetState($aDay[0], $GUI_CHECKED)
				_SetTimeDayCtrls(2)
			EndIf
	EndSwitch
EndFunc   ;==>_SetTimeDayCtrls

; Sets the state of Size and Time controls based on what's checked or unchecked.
Func _SizeTimeCtrlState()
	If BitAND(GUICtrlRead($iSizeStop), $GUI_CHECKED) Then
		GUICtrlSetState($iSizeLimit, $GUI_ENABLE)
		GUICtrlSetState($iSizeUD, $GUI_ENABLE)
	Else
		GUICtrlSetState($iSizeLimit, $GUI_DISABLE)
		GUICtrlSetState($iSizeUD, $GUI_DISABLE)
	EndIf
	If BitAND(GUICtrlRead($iTimeStop), $GUI_CHECKED) Then
		GUICtrlSetState($iTimeLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($iTimeLimit, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_SizeTimeCtrlState

; Appends a number to the start of the file name, so a user doesn't overwrite an existing recording.
Func _NumberFile($sFilePath)
	Local $sPath, $sFile, $sTmp, $i = 0
	$sPath = StringLeft($sFilePath, StringInStr($sFilePath, "\", 0, -1))
	$sFile = StringTrimLeft($sFilePath, StringInStr($sFilePath, "\", 0, -1))
	Do
		$sTmp = StringFormat('%03d_%s', $i, $sFile)
		$i += 1
	Until Not FileExists($sPath & $sTmp)
	Return $sPath & $sTmp
EndFunc   ;==>_NumberFile

;Fills the WaveIn quality settings combobox in the gui.
Func _CreateComboPreset()
	Local $aPreset, $sReturn
	$aPreset = StringSplit("8.000|11.025|12.000|16.000|22.050|24.000|32.000|44.100|48.000", "|")
	For $i = 1 To $aPreset[0]
		$sReturn &= StringFormat("%.03f kHz, 8 Bit, Mono, %d kb/sec|", $aPreset[$i], Floor(Int(StringReplace($aPreset[$i], ".", "")) / 1024))
		$sReturn &= StringFormat("%.03f kHz, 8 Bit, Stereo, %d kb/sec|", $aPreset[$i], Floor((Int(StringReplace($aPreset[$i], ".", "")) * 2) / 1024))
		$sReturn &= StringFormat("%.03f kHz, 16 Bit, Mono, %d kb/sec|", $aPreset[$i], Floor((Int(StringReplace($aPreset[$i], ".", "")) * 2) / 1024))
		$sReturn &= StringFormat("%.03f kHz, 16 Bit, Stereo, %d kb/sec|", $aPreset[$i], Floor((Int(StringReplace($aPreset[$i], ".", "")) * 4) / 1024))
	Next
	Return StringTrimRight($sReturn, 1)
EndFunc   ;==>_CreateComboPreset

; Fills the $tWaveFormatEx structure depending what's selected in the combobox in the gui.
Func _WaveFormatExFromCombo($sString, $tWaveFormatEx)
	Local $aS
	$aS = StringSplit(StringRegExpReplace($sString, "(\.|kHz|Bit|, \d+ kb/sec| )", ""), ",")
	If $aS[3] = "Mono" Then $aS[3] = 1
	If $aS[3] = "Stereo" Then $aS[3] = 2
	DllStructSetData($tWaveFormatEx, "nChannels", $aS[3])
	DllStructSetData($tWaveFormatEx, "nSamplesPerSec", $aS[1])
	DllStructSetData($tWaveFormatEx, "wBitsPerSample", $aS[2])
	DllStructSetData($tWaveFormatEx, "nAvgBytesPerSec", (($aS[3] * $aS[2]) / 8) * $aS[1])
	DllStructSetData($tWaveFormatEx, "nBlockAlign", ($aS[3] * $aS[2]) / 8)
EndFunc   ;==>_WaveFormatExFromCombo

; Returns milliseconds formatted to a string of "Time Elapsed: HH:MM:SS"
Func _TimeElapsed($iMS)
	Local $iHours = 0, $iMins = 0, $iSecs = 0
	If $iMS Then
		$iMS = Int($iMS / 1000)
		$iHours = Int($iMS / 3600)
		$iMS = Mod($iMS, 3600)
		$iMins = Int($iMS / 60)
		$iSecs = Mod($iMS, 60)
	EndIf
	Return StringFormat("Time Elapsed: %02d:%02d:%02d", $iHours, $iMins, $iSecs)
EndFunc   ;==>_TimeElapsed

; Returns milliseconds from a hh:mm:ss time sting eg: "00:00:00" -> milliseconds
Func _TimeToMS($sTime)
	Local $aT = StringSplit($sTime, ":")
	If Not $aT[0] = 3 Then Return 0
	If $aT[1] = "00" Then $aT[1] = 24
	Return 1000 * ((3600 * $aT[1]) + (60 * $aT[2]) + $aT[3])
EndFunc   ;==>_TimeToMS

; Adlib calls this every second, update some stuff in the gui, check for Start time recording.
Func _DiveSpace()
	If Not $iStopFlag Then GUICtrlSetData($iElapsed, _TimeElapsed(TimerDiff($iTime)))
	If $iStopFlag Then _CheckStartTime()
	If $iStopFlag And GUICtrlRead($iStatus) = "Status: STOPPED" Then
		If BitAND(GUICtrlGetState($iPlay), $GUI_ENABLE) And Not FileExists($sLastFile) Then
			GUICtrlSetState($iPlay, $GUI_DISABLE)
			GUICtrlSetState($iLastFile, $GUI_DISABLE)
			$sLastFile = ""
			GUICtrlSetData($iLastFile, $sLastFile)
		ElseIf BitAND(GUICtrlGetState($iPlay), $GUI_DISABLE) And FileExists($sLastFile) Then
			GUICtrlSetState($iPlay, $GUI_ENABLE)
			GUICtrlSetState($iLastFile, $GUI_ENABLE)
			GUICtrlSetData($iLastFile, StringTrimLeft($sLastFile, StringInStr($sLastFile, "\", 0, -1)))
		EndIf
	EndIf
	$iFDS = DriveSpaceFree(StringLeft($sOutMP3, 2))
	$sFDS = StringFormat("Free Space: %d MB", $iFDS)
	If $sLastFDS <> $sFDS Then
		GUICtrlSetData($iDriveSpace, $sFDS)
		$sLastFDS = $sFDS
	EndIf
EndFunc   ;==>_DiveSpace

; Checks for Start time recording.
Func _CheckStartTime()
	If BitAND(GUICtrlRead($iTimeStart), $GUI_UNCHECKED) Or Not $iStopFlag Then Return 0
	Local $sCT, $sST, $iH = @HOUR, $iM = @MIN, $sAP = "AM"
	If $iH = 00 Then
		$iH = 12
	ElseIf $iH > 12 Then
		$iH -= 12
		$sAP = "PM"
	ElseIf $iH = 12 Then
		$sAP = "PM"
	EndIf
	$sCT = StringFormat("%02d:%02d %s", $iH, $iM, $sAP)
	$sST = GUICtrlRead($iStartTime)
	If $sCT <> $sST Then $iStartFlag = 0
	If BitAND(GUICtrlRead($aDay[0]), $GUI_CHECKED) And ($sCT = $sST) And $iStopFlag And Not $iStartFlag Then
		$iStartFlag = 1
		Return _StartRecording()
	Else
		For $i = 1 To 7
			If BitAND(GUICtrlRead($aDay[$i]), $GUI_CHECKED) And ($sCT = $sST) And ($i = @WDAY) And $iStopFlag And Not $iStartFlag Then
				$iStartFlag = 1
				Return _StartRecording()
			EndIf
		Next
	EndIf
EndFunc   ;==>_CheckStartTime

; Save some gui settings
Func _SaveIni()
	IniWrite($sIni, "SETTINGS", "PresetWaweIn", GUICtrlRead($iPresetWaweIn))
	IniWrite($sIni, "SETTINGS", "PresetMP3", GUICtrlRead($iPresetMP3))
	IniWrite($sIni, "SETTINGS", "OutMP3", $sOutMP3)
	IniWrite($sIni, "SETTINGS", "LastFile", $sLastFile)
	IniWrite($sIni, "SETTINGS", "TimeStart", GUICtrlRead($iTimeStart))
	_SetTimeDayCtrls(3)
	Local $aT = StringSplit(GUICtrlRead($iStartTime), ":")
	Switch StringRight($aT[2], 2)
		Case "AM"
			If $aT[1] = 12 Then $aT[1] = "00"
		Case "PM"
			If $aT[1] < 12 Then $aT[1] += 12
	EndSwitch
	IniWrite($sIni, "SETTINGS", "StartTime", $aT[1] & ":" & StringTrimRight($aT[2], 3))
	For $i = 0 To 7
		IniWrite($sIni, "SETTINGS", "Day" & $i, GUICtrlRead($aDay[$i]))
	Next
	IniWrite($sIni, "SETTINGS", "SizeStop", GUICtrlRead($iSizeStop))
	IniWrite($sIni, "SETTINGS", "SizeLimit", GUICtrlRead($iSizeLimit))
	IniWrite($sIni, "SETTINGS", "TimeStop", GUICtrlRead($iTimeStop))
	IniWrite($sIni, "SETTINGS", "TimeLimit", GUICtrlRead($iTimeLimit))
	IniWrite($sIni, "SETTINGS", "SpaceLimit", GUICtrlRead($iSpaceLimit))
EndFunc   ;==>_SaveIni

; Load gui settings that were saved from previous use.
Func _LoadIni()
	Local $aT, $tTime
	GUICtrlSetData($iPresetWaweIn, IniRead($sIni, "SETTINGS", "PresetWaweIn", GUICtrlRead($iPresetWaweIn)))
	GUICtrlSetData($iPresetMP3, IniRead($sIni, "SETTINGS", "PresetMP3", GUICtrlRead($iPresetMP3)))
	$sOutMP3 = IniRead($sIni, "SETTINGS", "OutMP3", $sOutMP3)
	$sCurFile = _NumberFile($sOutMP3)
	GUICtrlSetData($iMP3Path, $sCurFile)
	$sLastFile = IniRead($sIni, "SETTINGS", "LastFile", $sLastFile)
	GUICtrlSetState($iTimeStart, IniRead($sIni, "SETTINGS", "TimeStart", 4))
	$aT = StringSplit(IniRead($sIni, "SETTINGS", "StartTime", "00:00"), ":")
	$tTime = DllStructCreate("short;short;short;short;short;short;short;short")
	If $aT[0] = 2 Then
		DllStructSetData($tTime, 1, @YEAR)
		DllStructSetData($tTime, 2, @MON)
		DllStructSetData($tTime, 4, @MDAY)
		DllStructSetData($tTime, 5, $aT[1])
		DllStructSetData($tTime, 6, $aT[2])
		GUICtrlSendMsg($iStartTime, 0x1002, 0, DllStructGetPtr($tTime)) ; $DTM_SETSYSTEMTIME = 0x1002
	EndIf
	For $i = 0 To 7
		GUICtrlSetState($aDay[$i], IniRead($sIni, "SETTINGS", "Day" & $i, 1))
	Next
	_SetTimeDayCtrls(1)
	GUICtrlSetState($iSizeStop, IniRead($sIni, "SETTINGS", "SizeStop", 4))
	GUICtrlSetData($iSizeLimit, IniRead($sIni, "SETTINGS", "SizeLimit", 1))
	GUICtrlSetState($iTimeStop, IniRead($sIni, "SETTINGS", "TimeStop", 4))
	_SizeTimeCtrlState()
	$aT = StringSplit(IniRead($sIni, "SETTINGS", "TimeLimit", "00:00:00"), ":")
	If $aT[0] = 3 Then
		DllStructSetData($tTime, 5, $aT[1])
		DllStructSetData($tTime, 6, $aT[2])
		DllStructSetData($tTime, 7, $aT[3])
		GUICtrlSendMsg($iTimeLimit, 0x1002, 0, DllStructGetPtr($tTime)) ; $DTM_SETSYSTEMTIME = 0x1002
	EndIf
	$tTime = 0
	GUICtrlSetData($iSpaceLimit, IniRead($sIni, "SETTINGS", "SpaceLimit", 2))
EndFunc   ;==>_LoadIni

;Exit the example.
Func _Quit()
	AdlibUnRegister("_DiveSpace")
	_StopRecording()
	_SaveIni()
	Exit
EndFunc   ;==>_Quit

; Makes sure that Size and Free Space input controls don't go lower then a certain minimum.
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $iCode, $hSizeLimit, $hSpaceLimit
	$hSizeLimit = GUICtrlGetHandle($iSizeLimit)
	$hSpaceLimit = GUICtrlGetHandle($iSpaceLimit)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $ilParam
		Case $hSizeLimit
			If $iCode = $EN_CHANGE Then
				If GUICtrlRead($iSizeLimit) < 1 Then GUICtrlSetData($iSizeLimit, 1)
			EndIf
		Case $hSpaceLimit
			If $iCode = $EN_CHANGE Then
				If GUICtrlRead($iSpaceLimit) < 2 Then GUICtrlSetData($iSpaceLimit, 2)
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

; #_WaveIn Functions# ===========================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInAddBuffer
; Description ...: Send an input buffer to the given waveform-audio input device.
; Syntax.........: _waveInAddBuffer($hWaveIn, $pWaveHdr,  $iSizeWaveHdr)
; Parameters ....: $hWaveIn - Handle to the waveform-audio input device.
;                  $pWaveHdr - Pointer to a WAVEHDR structure that identifies the buffer.
;                  $iSizeWaveHdr - Size, in bytes, of the WAVEHDR structure.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: When the buffer is filled, the WHDR_DONE bit is set in the dwFlags member of the WAVEHDR structure.
;                  The buffer must be prepared with the _waveInPrepareHeader function before it is passed to this function.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInAddBuffer function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743838%28v=vs.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInAddBuffer($hWaveIn, $pWaveHdr, $iSizeWaveHdr)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInAddBuffer", "handle", $hWaveIn, "ptr", $pWaveHdr, "uint", $iSizeWaveHdr)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInAddBuffer

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInClose
; Description ...: Close the given waveform-audio input device.
; Syntax.........: _waveInClose($hWaveIn)
; Parameters ....: $hWaveIn - Handle to the waveform-audio input device.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: If there are input buffers that have been sent with the _waveInAddBuffer function and
;                  that haven't been returned to the application, the close operation will fail.
;                  Call the _waveInReset function to mark all pending buffers as done.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInClose function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743840%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInClose($hWaveIn)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInClose", "handle", $hWaveIn)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInClose

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInGetErrorText
; Description ...: Retrieve a text description of the error identified by the given error number.
; Syntax.........: _waveInGetErrorText($iError)
; Parameters ....: $iError - Error number returned from a _waveInXxxxx function.
; Return values .: Success - String of text describing the error.
;                  Failure - Empty String "" or "AutoIt DllCall failed @error: X" (X being 1 to 4 ) and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743842%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInGetErrorText($iError)
	Local $tReturn, $aReturn
	$tReturn = DllStructCreate("CHAR[" & $MAXERRORLENGTH & "]")
	$aReturn = DllCall("winmm.dll", "uint", "waveInGetErrorText", "uint", $iError, "ptr", DllStructGetPtr($tReturn), "uint", DllStructGetSize($tReturn))
	If @error Then Return SetError(1, 0, "AutoIt DllCall failed @error: " & @error)
	Return SetError(DllStructGetData($tReturn, 1) = "", 0, DllStructGetData($tReturn, 1))
EndFunc   ;==>_waveInGetErrorText

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInGetNumDevs
; Description ...: Get the number of waveform-audio input devices present in the system.
; Syntax.........: _waveInGetNumDevs()
; Parameters ....: None.
; Return values .: Success - Number of devices.
;                  Failure - zero means that no devices are present or that an error occurred.
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743844%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInGetNumDevs()
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInGetNumDevs")
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($aReturn[0] = 0, 0, $aReturn[0])
EndFunc   ;==>_waveInGetNumDevs

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInOpen
; Description ...: Opens the given waveform-audio input device for recording.
; Syntax.........: _waveInOpen(ByRef $hWaveIn, $iDeviceID, $pWaveFormatEx, $pCallback, $pInstance, $iOpenFlag)
; Parameters ....: $hWaveIn - Returned handle to identify the device when calling other waveform-audio input functions.
;                             This parameter can be NULL if $WAVE_FORMAT_QUERY is specified for $iOpenFlag.
;                  $iDeviceID - Identifier of the waveform-audio input device to open.
;                               It can be either a device identifier or a handle of an open waveform-audio input device.
;                               You can use the flag $WAVE_MAPPER instead of a device identifier.
;                  $pWaveFormatEx - Pointer to a WAVEFORMATEX structure that identifies the desired format for recording waveform-audio data.
;                                   You can free this structure immediately after waveInOpen returns.
;                  $pCallback - Pointer to a fixed callback function, an event handle, a handle to a window,
;                               or the identifier of a thread to be called during waveform-audio recording to
;                               process messages related to the progress of recording.
;                               If no callback function is required, this value can be zero.
;                               For more information on the callback function, see _waveInProc.
;                  $pInstance - User-instance data passed to the callback mechanism.
;                               This parameter is not used with the window callback mechanism.
;                  $iOpenFlag - Flags for opening the device. The following values are defined:
;                               $CALLBACK_EVENT - The $pCallback parameter is an event handle.
;                               $CALLBACK_FUNCTION - The $pCallback parameter is a callback procedure address.
;                               $CALLBACK_NULL - No callback mechanism.
;                               $CALLBACK_THREAD - The $pCallback parameter is a thread identifier.
;                               $CALLBACK_WINDOW - The $pCallback parameter is a window handle.
;                               $WAVE_MAPPED_DEFAULT_COMMUNICATION_DEVICE - If this flag is specified and the uDeviceID parameter is WAVE_MAPPER,
;                                                                           the function opens the default communication device.
;                                                                           This flag applies only when $iDeviceID equals WAVE_MAPPER.
;                                                                           Note: Requires Windows 7
;                               $WAVE_FORMAT_DIRECT - If this flag is specified, the ACM driver does not perform conversions on the audio data.
;                               $WAVE_FORMAT_QUERY - The function queries the device to determine whether it supports the given format, but it does not open the device.
;                               $WAVE_MAPPED - The $iDeviceID parameter specifies a waveform-audio device to be mapped to by the wave mapper.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: Use the waveInGetNumDevs function to determine the number of waveform-audio input devices present on the system.
;                  The device identifier specified by $iDeviceID varies from zero to one less than the number of devices present.
;                  The $WAVE_MAPPER constant can also be used as a device identifier.
;                  If you choose to have a window or thread receive callback information,
;                  the following messages are sent to the window procedure or
;                  thread to indicate the progress of waveform-audio input: $MM_WIM_OPEN, $MM_WIM_CLOSE, and $MM_WIM_DATA.
;                  If you choose to have a function receive callback information,
;                  the following messages are sent to the function to indicate the progress of waveform-audio input: WIM_OPEN, WIM_CLOSE, and WIM_DATA.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInOpen function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743847%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInOpen(ByRef $hWaveIn, $iDeviceID, $pWaveFormatEx, $pCallback, $pInstance, $iOpenFlag)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInOpen", "handle*", 0, "uint", $iDeviceID, "ptr", $pWaveFormatEx, "ptr", $pCallback, "ptr", $pInstance, "dword", $iOpenFlag)
	If @error Then Return SetError(1, @error, @error = 0)
	$hWaveIn = $aReturn[1]
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInOpen

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInPrepareHeader
; Description ...: Prepare a buffer for waveform-audio input.
; Syntax.........: _waveInPrepareHeader($hWaveIn, $pWaveHdr, $iSizeWaveHdr)
; Parameters ....: $hWaveIn - Handle to the waveform-audio input device.
;                  $pWaveHdr - Pointer to a WAVEHDR structure that identifies the buffer.
;                  $iSizeWaveHdr - Size, in bytes, of the WAVEHDR structure.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: The lpData, dwBufferLength, and dwFlags members of the WAVEHDR structure must be set before calling this function (dwFlags must be zero).
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInOpen function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743848%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInPrepareHeader($hWaveIn, $pWaveHdr, $iSizeWaveHdr)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInPrepareHeader", "handle", $hWaveIn, "ptr", $pWaveHdr, "uint", $iSizeWaveHdr)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInPrepareHeader

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInProc
; Description ...: Callback function used with the waveform-audio input device.
; Syntax.........: _waveInProc($hWaveIn, $iMsg, $pInstance, $pParam1, $pParam2)
; Parameters ....: $hWaveIn - Handle to the waveform-audio device associated with the callback function.
;                  $iMsg - Waveform-audio input message. It can be one of the following messages:
;                          $WIM_CLOSE - Sent when the device is closed using the _waveInClose function.
;                          $WIM_DATA - Sent when the device driver is finished with a data block sent using the _waveInAddBuffer function.
;                          $WIM_OPEN - Sent when the device is opened using the _waveInOpen function.
;                  $pInstance - User instance data specified with waveInOpen.
;                  $pParam1 - Message parameter.
;                  $pParam2 - Message parameter.
; Return values .: None,
; Author ........: smashly
; Modified.......:
; Remarks .......: This function is a placeholder for the application-defined function name, given for example.
;                  The address of this function can be specified in the $pCallback-address parameter of the _waveInOpen function.
;                  Applications should not call any system-defined functions from inside a callback function,
;                  except for EnterCriticalSection, LeaveCriticalSection, midiOutLongMsg, midiOutShortMsg, OutputDebugString,
;                  PostMessage, PostThreadMessage, SetEvent, timeGetSystemTime, timeGetTime, timeKillEvent, and timeSetEvent.
;                  Calling other wave functions will cause deadlock.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743849%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
;~ Func _waveInProc($hWaveIn, $iMsg, $pInstance, $pParam1, $pParam2)
; "handle", $hWaveIn, "uint", $iMsg, "ptr", $pInstance, "ptr", $pParam1, "ptr", $pParam2
;~  Switch $iMsg
;~      Case $WIM_OPEN
;~          ConsoleWrite("_waveInProc CallBack Msg: Open" & @LF)
;~      Case $WIM_CLOSE
;~          ConsoleWrite("_waveInProc CallBack Msg: Close" & @LF)
;~      Case $WIM_DATA
;~          ConsoleWrite("_waveInProc CallBack Msg: Data" & @LF)
;~          ;; $pParam1 pointer to the returned buffer
;~     EndSwitch
;~ EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInReset
; Description ...: Stops input on the given waveform-audio input device and resets the current position to zero.
; Syntax.........: _waveInReset($hWaveIn)
; Parameters ....: $hWaveIn - Handle to the waveform-audio device.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: All pending buffers are marked as done and returned to the application.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInOpen function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743850%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInReset($hWaveIn)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInReset", "handle", $hWaveIn)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInReset

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInStart
; Description ...: Start input on the given waveform-audio input device.
; Syntax.........: _waveInStart($hWaveIn)
; Parameters ....: $hWaveIn - Handle to the waveform-audio device.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: Buffers are returned to the application when full or when the _waveInReset function is called
;                  (the dwBytesRecorded member in the header will contain the length of data).
;                  If there are no buffers in the queue, the data is thrown away without notifying the application, and input continues.
;                  Calling this function when input is already started has no effect, and the function returns zero.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInOpen function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743851%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInStart($hWaveIn)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInStart", "handle", $hWaveIn)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInStart

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInStop
; Description ...: Stops waveform-audio input.
; Syntax.........: _waveInStop($hWaveIn)
; Parameters ....: $hWaveIn - Handle to the waveform-audio device.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: If there are any buffers in the queue, the current buffer will be marked as done
;                  (the dwBytesRecorded member in the header will contain the length of data), but any empty buffers in the queue will remain there.
;                  Calling this function when input is not started has no effect, and the function returns zero.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInOpen function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743852%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInStop($hWaveIn)
	Local $aReturn
	$aReturn = DllCall("winmm.dll", "uint", "waveInStop", "handle", $hWaveIn)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInStop

; #FUNCTION# ====================================================================================================================
; Name...........: _waveInUnprepareHeader
; Description ...: Clean up the preparation performed by the _waveInPrepareHeader function.
; Syntax.........: _waveInUnprepareHeader($hWaveIn, $pWaveHdr, $iSizeWaveHdr)
; Parameters ....: $hWaveIn - Handle to the waveform-audio device.
;                  $pWaveHdr - Pointer to a WAVEHDR structure that identifies the buffer.
;                  $iSizeWaveHdr - Size, in bytes, of the WAVEHDR structure.
; Return values .: Success - True and @error 0.
;                  Failure - False and @error <> 0 (see remarks for more info)
; Author ........: smashly
; Modified.......:
; Remarks .......: This function complements the waveInPrepareHeader function.
;                  You must call this function before freeing the buffer.
;                  After passing a buffer to the device driver with the waveInAddBuffer function,
;                  you must wait until the driver is finished with the buffer before calling waveInUnprepareHeader.
;                  Unpreparing a buffer that has not been prepared has no effect, and the function returns zero.
;                  Notes on error return: Use the @error return with _waveInGetErrorText to get a text description of the error.
;                  If @error = 1 and @extended <> 0 it's a failed AutoIt DllCall (@extended could be 1 to 4).
;                  If @error <> 0 and @extended = 0 then it's an error related to _waveInOpen function call.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/dd743853%28v=VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _waveInUnprepareHeader($hWaveIn, $pWaveHdr, $iSizeWaveHdr)
	Local $aReturn = DllCall("winmm.dll", "uint", "waveInUnprepareHeader", "handle", $hWaveIn, "ptr", $pWaveHdr, "unit", $iSizeWaveHdr)
	If @error Then Return SetError(1, @error, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_waveInUnprepareHeader

; #_LameEnc Functions# =========================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _LameEnc_Close
; Description ...: Close lame_enc.dll.
; Syntax.........: _LameEnc_Close()
; Parameters ....: None.
; Return values .: None.
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _LameEnc_Close()
	DllClose($h_LameEncDLL)
	$h_LameEncDLL = -1
EndFunc   ;==>_LameEnc_Close

; #FUNCTION# ====================================================================================================================
; Name...........: _LameEnc_CloseStream
; Description ...: Close a stream when finished encoding.
; Syntax.........: _LameEnc_CloseStream($hStream)
; Parameters ....: $hStream - Ponter to the Stream to close.
; Return values .: Success - True.
;                  Failure - False.
; Author ........: smashly
; Modified.......:
; Remarks .......: If you call this function before calling _LameEnc_DeinitStream then any data left in the stream will be lost.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _LameEnc_CloseStream($hStream)
	Local $aReturn
	$aReturn = DllCall($h_LameEncDLL, "ulong:cdecl", "beCloseStream", "ptr", $hStream)
	If @error Then Return SetError(-1, 0, @error = 0)
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_LameEnc_CloseStream

; #FUNCTION# ====================================================================================================================
; Name...........: _LameEnc_DeinitStream
; Description ...: Deinitiate stream to flush any data that may be left in the stream to the mp3 out buffer.
; Syntax.........: _LameEnc_DeinitStream($hStream, $pMP3Buffer, ByRef $iOutput)
; Parameters ....: $hStream - Ponter to a Stream as returned by _LameEnc_InitStream.
;                  $pMP3Buffer - Pointer to Mp3 out buffer.
;                  $iOutput - How many bytes were written from the stream to the Mp3 out buffer.
; Return values .: Success - True.
;                  Failure - False.
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _LameEnc_DeinitStream($hStream, $pMP3Buffer, ByRef $iOutput)
	Local $aReturn
	$aReturn = DllCall($h_LameEncDLL, "ulong:cdecl", "beDeinitStream", "ptr", $hStream, "ptr", $pMP3Buffer, "dword*", 0)
	If @error Then Return SetError(-1, 0, @error = 0)
	$iOutput = $aReturn[3]
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_LameEnc_DeinitStream

; #FUNCTION# ====================================================================================================================
; Name...........: _LameEnc_EncodeChunk
; Description ...: Encode a chunk of pcm wave data to mp3 data.
; Syntax.........: _LameEnc_EncodeChunk($hStream, $iSamples, $pWAVBuffer, $pMP3Buffer, ByRef $iOutput)
; Parameters ....: $hStream - Ponter to the Stream
;                  $iSamples - Number of samples in the Wav buffer to encode.
;                  $pMP3Buffer - Pointer to Mp3 out buffer.
;                  $iOutput - How many bytes were written to the Mp3 out buffer.
; Return values .: Success - True.
;                  Failure - False.
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _LameEnc_EncodeChunk($hStream, $iSamples, $pWAVBuffer, $pMP3Buffer, ByRef $iOutput)
	Local $aReturn
	$aReturn = DllCall($h_LameEncDLL, "ulong:cdecl", "beEncodeChunk", "ptr", $hStream, "dword", $iSamples, "ptr", $pWAVBuffer, "ptr", $pMP3Buffer, "int*", 0)
	If @error Then Return SetError(-1, @error, @error = 0)
	$iOutput = $aReturn[5]
	Return SetError($aReturn[0], 0, $aReturn[0] = 0)
EndFunc   ;==>_LameEnc_EncodeChunk

; #FUNCTION# ====================================================================================================================
; Name...........: _LameEnc_InitStream
; Description ...: Initiate a stream to pass data to lame encoder.
; Syntax.........: _LameEnc_InitStream($pConfig, ByRef $iSamples, ByRef $iBufferSize, ByRef $hStream)
; Parameters ....: $pConfig - Pointer to beConfig structure that contains settings for lame encoder to use.
;                  $iSamples - Returns recommended number of samples the input Wav buffer should be able hold. 1 sample is 2 bytes (SHORT data type)
;                  $iBufferSize - Returns recommended size for the output MP3 buffer in bytes.
;                  $hStream - Returns a ponter to the created stream which can be be used with other _LameEnc functions.
; Return values .: Success - True.
;                  Failure - False.
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _LameEnc_InitStream($pConfig, ByRef $iSamples, ByRef $iBufferSize, ByRef $hStream)
	Local $aReturn, $aResult[3]
	$aReturn = DllCall($h_LameEncDLL, "ulong:cdecl", "beInitStream", "ptr", $pConfig, "dword*", 0, "dword*", 0, "ptr*", 0)
	If @error Then Return SetError(-1, @error, @error = 0)
	$iSamples = $aReturn[2]
	$iBufferSize = $aReturn[3]
	$hStream = $aReturn[4]
	Return SetError($aReturn[0], 0, $aResult[0] = 0)
EndFunc   ;==>_LameEnc_InitStream

; #FUNCTION# ====================================================================================================================
; Name...........: _LameEnc_Open
; Description ...: Open lame_enc.dll ready to use with other _LameEnc functions.
; Syntax.........:_LameEnc_Open([$sLameEncDll = "lame_enc.dll"])
; Parameters ....: $sLameEncDll - [Optional] Path to lame_enc.dll.
; Return values .: Success - True.
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _LameEnc_Open($sLameEncDll = "lame_enc.dll")
	$h_LameEncDLL = DllOpen($sLameEncDll)
	Return SetError($h_LameEncDLL = -1, 0, $h_LameEncDLL <> -1)
EndFunc   ;==>_LameEnc_Open