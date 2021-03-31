#include "Bass.au3"
#include "BassFX.au3"
#include <GuiSlider.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <SliderConstants.au3>


Opt("GUIOnEventMode", 1)

Global $hSLDR_[10], $hCB_[6], $SliderOnTheMove = 0, $hStream, $Len

HotKeySet("{ESC}", "_Exit")

$hGui = GUICreate("Effects Test", 420, 240)
_CreateSliders()
$hProgress = GUICtrlCreateProgress(40, 140, 280, 10, 0x01)
_CreateCheckBoxes()
$Button_0 = GUICtrlCreateButton("Open", 360, 10, 40, 20)
GUICtrlSetOnEvent(-1, "_OpenFile")
$Button_1 = GUICtrlCreateButton("Default", 350, 160, 50, 20)
GUICtrlSetOnEvent(-1, "_Defaults")
$Button_2 = GUICtrlCreateButton("Exit", 360, 210, 40, 20)
GUICtrlSetOnEvent(-1, "_Exit")
$Button_3 = GUICtrlCreateButton("Rock", 350, 60, 50, 20)
GUICtrlSetOnEvent(-1, "_RockPreset")
$Button_4 = GUICtrlCreateButton("Pop", 350, 85, 50, 20)
GUICtrlSetOnEvent(-1, "_PopPreset")
$Button_5 = GUICtrlCreateButton("Dance", 350, 110, 50, 20)
GUICtrlSetOnEvent(-1, "_DancePreset")
$Button_6 = GUICtrlCreateButton("Billy", 350, 135, 50, 20)
GUICtrlSetOnEvent(-1, "_BillyPreset")
_CreateLabels()

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_PrimaryDown")
GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_PrimaryUp")

GUISetState()

_BASS_Startup()
_BASS_FX_Startup()

_BASS_Init(0, -1, 44100, 0, "")

If FileExists("bassflac.dll") Then
	$Flac = _BASS_PluginLoad("bassflac.dll") ; Required to play .flac files
EndIf

_BASS_SetConfig($BASS_CONFIG_GVOL_STREAM, 10000); Adjust as you want

While 1
	If $SliderOnTheMove Then
		_Sliders()
	EndIf
	$Byte = _BASS_ChannelGetPosition($hStream, $BASS_POS_BYTE)
	GUICtrlSetData($hProgress, $Byte / $Len * 100)
	Sleep(20)
WEnd

Func _OpenFile()
	$sFile = FileOpenDialog("Open...", "..\audiofiles", "playable formats (*.MP3;*.MP2;*.MP1;*.OGG;*.WAV;*.AIFF;*.AIF;*.FLAC;*.WMA;*.M4A)")
	If $sFile > "" Then
		_BASS_ChannelStop($hStream)
		GUICtrlSetData($hProgress, 0)
		_Defaults()
		$hStream = _BASS_StreamCreateFile(False, $sFile, 0, 0, $BASS_SAMPLE_FLOAT)
		_BASS_ChannelPlay($hStream, True)
		$Len = _BASS_ChannelGetLength($hStream, $BASS_POS_BYTE)
	EndIf
EndFunc   ;==>_OpenFile

Func _Chorus()
	Local Static $hFX_Chorus
	If GUICtrlRead($hCB_[0]) = $GUI_CHECKED Then
		$hFX_Chorus = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_CHORUS, 1)
		_BASS_FXSetParameters($hFX_Chorus, "0.5|0.4|0.5|1|10|5|" & $BASS_BFX_CHANALL) ;Play with the parameters to set them to your preference
	Else
		_BASS_ChannelRemoveFX($hStream, $hFX_Chorus)
	EndIf
EndFunc   ;==>_Chorus

Func _Echo()
	Local Static $hFX_Echo
	If GUICtrlRead($hCB_[1]) = $GUI_CHECKED Then
		$hFX_Echo = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_ECHO2, 1)
		_BASS_FXSetParameters($hFX_Echo, "1|0.3|0.3|0.4|" & $BASS_BFX_CHANALL);Play with the parameters to set them to your preference
	Else
		_BASS_ChannelRemoveFX($hStream, $hFX_Echo)
	EndIf
EndFunc   ;==>_Echo

Func _Reverb()
	Local Static $hFX_Reverb
	If GUICtrlRead($hCB_[2]) = $GUI_CHECKED Then
		$hFX_Reverb = _BASS_ChannelSetFX($hStream, $BASS_FX_DX8_REVERB, 1)
		_BASS_FXSetParameters($hFX_Reverb, "0|-6|2000|0.001");Play with the parameters to set them to your preference
	Else
		_BASS_ChannelRemoveFX($hStream, $hFX_Reverb)
	EndIf
EndFunc   ;==>_Reverb

Func _Autowah()
	Local Static $hFX_Autowah
	If GUICtrlRead($hCB_[3]) = $GUI_CHECKED Then
		$hFX_Autowah = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_AUTOWAH, 1)
		_BASS_FXSetParameters($hFX_Autowah, "2|2|0.5|9|2|500|" & $BASS_BFX_CHANALL);Play with the parameters to set them to your preference
		;ConsoleWrite("Autowah " & @error & @LF)
	Else
		_BASS_ChannelRemoveFX($hStream, $hFX_Autowah)
	EndIf
EndFunc   ;==>_Autowah

Func _Rotate()
	Local Static $hFX_Rotate
	If GUICtrlRead($hCB_[4]) = $GUI_CHECKED Then
		$hFX_Rotate = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_ROTATE, 1)
		_BASS_FXSetParameters($hFX_Rotate, "500|" & $BASS_BFX_CHANALL);Play with the parameter to set to your preference
		;ConsoleWrite("Rotate " & @error & @LF)
	Else
		_BASS_ChannelRemoveFX($hStream, $hFX_Rotate)
	EndIf
EndFunc   ;==>_Rotate

Func _Flanger()
	Local Static $hFX_Flanger
	If GUICtrlRead($hCB_[5]) = $GUI_CHECKED Then
		$hFX_Flanger = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_FLANGER, 1)
		_BASS_FXSetParameters($hFX_Flanger, "0.5|0.09|" & $BASS_BFX_CHANALL);Play with the parameters to set them to your preference
		;ConsoleWrite("Flanger " & @error & @LF)
	Else
		_BASS_ChannelRemoveFX($hStream, $hFX_Flanger)
	EndIf
EndFunc   ;==>_Flanger

Func _Sliders()
	Local $Gain
	Switch $SliderOnTheMove
		Case $hSLDR_[0]
			$Gain = 30 - GUICtrlRead($hSLDR_[0])
			_SetEqualiser($Gain / 2, 0)

		Case $hSLDR_[1]
			$Gain = 30 - GUICtrlRead($hSLDR_[1])
			_SetEqualiser($Gain / 2, 1)

		Case $hSLDR_[2]
			$Gain = -30 + GUICtrlRead($hSLDR_[2])
			_SetEqualiser($Gain / 2, 2)

		Case $hSLDR_[3]
			$Gain = 30 - GUICtrlRead($hSLDR_[3])
			_SetEqualiser($Gain / 2, 3)

		Case $hSLDR_[4]
			$Gain = 30 - GUICtrlRead($hSLDR_[4])
			_SetEqualiser($Gain / 2, 4)

		Case $hSLDR_[5]
			$Gain = 30 - GUICtrlRead($hSLDR_[5])
			_SetEqualiser($Gain / 2, 5)

		Case $hSLDR_[6]
			$Gain = 30 - GUICtrlRead($hSLDR_[6])
			_SetEqualiser($Gain / 2, 6)

		Case $hSLDR_[7]
			$Gain = 30 - GUICtrlRead($hSLDR_[7])
			_SetEqualiser($Gain / 2, 7)

		Case $hSLDR_[8]
			$Gain = 30 - GUICtrlRead($hSLDR_[8])
			_SetEqualiser($Gain / 2, 8)

		Case $hSLDR_[9]
			$Gain = 30 - GUICtrlRead($hSLDR_[9])
			_SetEqualiser($Gain / 2, 9)

	EndSwitch
EndFunc   ;==>_Sliders

Func _PrimaryDown()
	$aInfo = GUIGetCursorInfo()
	If @error Then Return
	Switch $aInfo[4] ; See what control was clicked
		Case $hSLDR_[0] To $hSLDR_[9] ; if it's a slider
			$SliderOnTheMove = $aInfo[4] ; then set the $SliderOnTheMove variable with the control ID
	EndSwitch
EndFunc   ;==>_SliderMove

Func _PrimaryUp()
	If $SliderOnTheMove Then
		$SliderOnTheMove = 0
	EndIf
EndFunc   ;==>_PrimaryUp

Func _RockPreset()
	Local $aRock[10] = [5.5, 5, 3.5, 2, -3, -3, 0, 3, 4, 5] ;Sets the gain on the frequencies
	_SetEqualiser($aRock)
EndFunc   ;==>_RockPreset

Func _PopPreset()
	Local $aPop[10] = [-2, -2, 0, 2, 5, 5, 3, 0, -2, -2] ; Adjust to suit your preference
	_SetEqualiser($aPop)
EndFunc   ;==>_PopPreset

Func _DancePreset()
	Local $aDance[10] = [5, 7, 6, 1, 3, 5, 6, 5, 4, 1]
	_SetEqualiser($aDance)
EndFunc   ;==>_DancePreset

Func _BillyPreset()
	Local $aBilly[10] = [15, 15, 15, 15, 15, 15, 15, 15, 15, 15]
	_SetEqualiser($aBilly)
EndFunc   ;==>_BillyPreset

Func _Defaults()
	Local $aDefaults[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	_SetEqualiser($aDefaults)
	If GUICtrlRead($hCB_[0]) = $GUI_CHECKED Then
		GUICtrlSetState($hCB_[0], $GUI_UNCHECKED)
		_Chorus()
	EndIf
	If GUICtrlRead($hCB_[1]) = $GUI_CHECKED Then
		GUICtrlSetState($hCB_[1], $GUI_UNCHECKED)
		_Echo()
	EndIf
	If GUICtrlRead($hCB_[2]) = $GUI_CHECKED Then
		GUICtrlSetState($hCB_[2], $GUI_UNCHECKED)
		_Reverb()
	EndIf
	If GUICtrlRead($hCB_[3]) = $GUI_CHECKED Then
		GUICtrlSetState($hCB_[3], $GUI_UNCHECKED)
		_Autowah()
	EndIf
	If GUICtrlRead($hCB_[4]) = $GUI_CHECKED Then
		GUICtrlSetState($hCB_[4], $GUI_UNCHECKED)
		_Rotate()
	EndIf
	If GUICtrlRead($hCB_[5]) = $GUI_CHECKED Then
		GUICtrlSetState($hCB_[5], $GUI_UNCHECKED)
		_Flanger()
	EndIf
EndFunc   ;==>_Defaults

Func _SetEqualiser($Gain, $Band = -1)
	Local Static $iFreq_[10] = [32, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000] ; Frequencies that are being set
	Local Static $hLFX_[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Array to hold handles to the effects
	Local Static $CG[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Array to support checking
	If IsArray($Gain) Then
		For $i = 0 To 9
			If $Gain[$i] <> $CG[$i] Then ; Make sure we are not sending an unnessary call
				_BASS_ChannelRemoveFX($hStream, $hLFX_[$i]) ; Remove the effect - there probably is a way to just update it that I don't know
				$hLFX_[$i] = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_BQF, 1) ; Prepare the stream for the new effect
				_BASS_FXSetParameters($hLFX_[$i], $BASS_BFX_BQF_PEAKINGEQ & "|" & $iFreq_[$i] & "|" & $Gain[$i] & "|1|0|0|" & $BASS_BFX_CHANALL); and set the new effect
				;For setting BASS_FX_BFX_BQF parameters - see                                                                               
				GUICtrlSetData($hSLDR_[$i], 30 - $Gain[$i] * 2) ; Adjust the slider to the match the new gain
			EndIf
		Next
		$CG = $Gain
	Else ; If just one slider is being moved adjust the gain for the appropriate frequency
		If $Band > -1 Then
			$i = $Band
			_BASS_ChannelRemoveFX($hStream, $hLFX_[$i])
			$hLFX_[$i] = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_BQF, 1)
			_BASS_FXSetParameters($hLFX_[$i], $BASS_BFX_BQF_PEAKINGEQ & "|" & $iFreq_[$i] & "|" & $Gain & "|1|0|0|" & $BASS_BFX_CHANALL)
			$CG[$i] = $Gain
		EndIf
	EndIf
EndFunc   ;==>_SetEqualiser

Func _CreateSliders()
	Local $aPos[10] = [40, 70, 100, 130, 160, 190, 220, 250, 280, 310]
	For $i = 0 To 9
		$hSLDR_[$i] = GUICtrlCreateSlider($aPos[$i], 20, 20, 100, BitOR($TBS_AUTOTICKS, $TBS_VERT))
		GUICtrlSetLimit(-1, 60, 0)
		GUICtrlSetData(-1, 30)
	Next
EndFunc   ;==>_CreateSliders

Func _CreateCheckBoxes()
	Local $aCB[6][3] = [["Chorus", 50, 170],["Echo", 150, 170],["Reverb", 250, 170],["Autowah", 50, 200],["Rotate", 150, 200],["Flanger", 250, 200]]
	For $i = 0 To 5
		$hCB_[$i] = GUICtrlCreateCheckbox($aCB[$i][0], $aCB[$i][1], $aCB[$i][2])
		GUICtrlSetOnEvent(-1, "_" & $aCB[$i][0])
	Next
EndFunc   ;==>_CreateCheckBoxes

Func _CreateLabels()
	Local $Freq[10] = [32, 63, 125, 250, 500, 1, 2, 4, 8, 16]
	Local $Pos[10] = [38, 68, 95, 125, 155, 185, 215, 245, 275, 303]
	Local $hz = "hz"
	For $i = 0 To 9
		GUICtrlCreateLabel($Freq[$i] & $hz, $Pos[$i], 8, Default, 12);, $SS_CENTER)
		GUICtrlSetFont(-1, 7)
		If $i = 4 Then $hz = "Khz"
	Next
	Local $DB[3] = ["+15", "0db", "-15"]
	Local $Pos1[3] = [25, 65, 105]
	For $i = 0 To 2
		GUICtrlCreateLabel($DB[$i], 10, $Pos1[$i], -1, -1, $SS_RIGHT)
		GUICtrlSetFont(-1, 7)
	Next
EndFunc   ;==>CreateLabels

Func _Exit()
	_BASS_ChannelStop($hStream)
	_BASS_PluginFree($Flac)
	_BASS_Free()
	Exit
EndFunc   ;==>_Exit
