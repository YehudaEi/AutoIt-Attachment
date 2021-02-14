#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; LIVE STREAM PLAYER
;.......script written by trancexx (trancexx at yahoo dot com)

#include "AutoitObject.au3"

Opt("MustDeclareVars", 1)

HotKeySet("{ESC}", "_Quit") ; Esc to exit any time

Global $sMediaFile = "                           " ; any other. Pay attention to format

; Error monitoring
Global $oCOMError = ObjEvent("AutoIt.Error", "_ErrFunc")

; Let the magic begin...
_AutoItObject_StartUp()

; DLLs to use
Global $oUSER32DLL = _AutoItObject_DllOpen("user32.dll")

; GUI
Global $hGUI = GUICreate("Live Streaming", 278, 80)

Global $hVolSlider = GUICtrlCreateSlider(10, 14, 28, 64, 10 + 16)
GUICtrlSetTip(-1, "100 %VOL")
GUICtrlCreateLabel("VOL", 40, 21, 68, 20)
GUICtrlSetFont(-1, 9, -1, 2, "Curier New")

Global $hButtonPlay = GUICtrlCreateButton("&Pause", 80, 20, 115, 25)
Global $hLabelInfo = GUICtrlCreateLabel("  ...Connecting...", 90, 60, 130, 25)
GUICtrlSetFont(-1, 9, -1, 2, "Arial")
Global $hLevMet

; Objects
Global $oGraphBuilder, $oMediaControl, $oBasicAudio, $oAudioMeterInformation

; Level-meter
_AudioVolObject($oAudioMeterInformation)
If Not @error Then ; if this objects are available on the system then add control for it
	$hLevMet = GUICtrlCreateProgress(230, 15, 40, 60, 4)
	AdlibRegister("_LevelMeter", 45)
EndIf

; Misc variables
Global $iPlaying = 1, $iVol

; Show GUI
GUISetState()


; Main loop
While 1
	Switch GUIGetMsg()
		Case -3
			ExitLoop
		Case $hButtonPlay
			If $iPlaying Then
				$oMediaControl.Pause()
				GUICtrlSetData($hButtonPlay, "&Play")
				$iPlaying = 0
			Else
				$oMediaControl.Run()
				GUICtrlSetData($hButtonPlay, "&Pause")
				$iPlaying = 1
			EndIf
	EndSwitch
	If $iVol <> GUICtrlRead($hVolSlider) Then
		$iVol = GUICtrlRead($hVolSlider)
		If IsObj($oBasicAudio) Then $oBasicAudio.put_Volume(-Exp(($iVol) / 10.86))
		GUICtrlSetTip($hVolSlider, 100 - $iVol & " %VOL")
	EndIf
	If $sMediaFile Then _RenderFile($sMediaFile)
WEnd

; Free before the end
_Quit()

;THE END





Func _Quit()
	; Release objests
	_ReleaseBuilder($oGraphBuilder, $oMediaControl, $oBasicAudio)
	$oAudioMeterInformation = 0
	; Bye bye
	Exit
EndFunc   ;==>_Quit

Func _LevelMeter()
	Local $aCall = $oAudioMeterInformation.GetPeakValue(0)
	If IsArray($aCall) Then
		Local $iCurrentRead = 100 * $aCall[1]
		GUICtrlSetData($hLevMet, $iCurrentRead + 1)
		GUICtrlSetData($hLevMet, $iCurrentRead)
	EndIf
EndFunc   ;==>_LevelMeter


Func _AudioVolObject(ByRef $oAudioMeterInformation)
	Local Const $sCLSID_MMDeviceEnumerator = "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
	Local Const $sIID_IMMDeviceEnumerator = "{A95664D2-9614-4F35-A746-DE8DB63617E6}"
	Global $dtagIMMDeviceEnumerator = $dtagIUnknown & _
			"EnumAudioEndpoints hresult(dword;dword;ptr*);" & _
			"GetDefaultAudioEndpoint hresult(dword;dword;ptr*);" & _
			"GetDevice hresult(wstr;ptr*);" & _
			"RegisterEndpointNotificationCallback hresult(ptr);" & _
			"UnregisterEndpointNotificationCallback hresult(ptr);"

	Local $dtagIMMDevice = $dtagIUnknown & _
			"Activate hresult(ptr;dword;variant*;ptr*);" & _
			"OpenPropertyStore hresult(dword;ptr*);" & _
			"GetId hresult(wstr*);" & _
			"GetState hresult(dword*);"

	Local Const $sIID_IAudioMeterInformation = "{C02216F6-8C67-4B5B-9D00-D008E73E0064}"
	Local $dtagIAudioMeterInformation = $dtagIUnknown & _
			"GetPeakValue hresult(float*);" & _
			"GetMeteringChannelCount hresult(dword*);" & _
			"GetChannelsPeakValues hresult(dword;float*);" & _
			"QueryHardwareSupport hresult(dword*);"

	; MMDeviceEnumerator
	Local $oMMDeviceEnumerator = _AutoItObject_ObjCreate($sCLSID_MMDeviceEnumerator, $sIID_IMMDeviceEnumerator, $dtagIMMDeviceEnumerator)
	If @error Then Return SetError(1, 0, 0)

	; DefaultAudioEndpoint
	Local $aCall = $oMMDeviceEnumerator.GetDefaultAudioEndpoint(0, 0, 0) ; eRender, eConsole
	If Not IsArray($aCall) Then Return SetError(2, 0, 0)
	Local $oDefaultDevice = _AutoItObject_WrapperCreate($aCall[3], $dtagIMMDevice)

	; AudioMeterInformation
	Local $pIID_IAudioMeterInformation = _AutoItObject_CLSIDFromString($sIID_IAudioMeterInformation)
	$aCall = $oDefaultDevice.Activate(Number(DllStructGetPtr($pIID_IAudioMeterInformation)), 1, 0, 0)
	If Not IsArray($aCall) Then Return SetError(3, 0, 0)
	$oAudioMeterInformation = _AutoItObject_WrapperCreate($aCall[4], $dtagIAudioMeterInformation)

	; That's it
	Return True
EndFunc   ;==>_AudioVolObject

Func _InitBuilder(ByRef $oGraphBuilder, ByRef $oMediaControl, ByRef $oBasicAudio)
	; Needed identifiera
	Local $sCLSID_FilterGraph = "{E436EBB3-524F-11CE-9F53-0020AF0BA770}"
	Local $sIID_IGraphBuilder = "{56A868A9-0AD4-11CE-B03A-0020AF0BA770}"
	; More...
	Local $tIID_IMediaControl = _AutoItObject_CLSIDFromString("{56A868B1-0AD4-11CE-B03A-0020AF0BA770}")
	Local $tIID_IBasicAudio = _AutoItObject_CLSIDFromString("{56A868B3-0AD4-11CE-B03A-0020AF0BA770}")

	; Define IGraphBuilder methods
	Local $dtagIGraphBuilder = $dtagIUnknown & _
			"AddFilter hresult(ptr;wstr);" & _
			"RemoveFilter hresult(ptr);" & _
			"EnumFilters hresult(ptr*);" & _
			"FindFilterByName hresult(wstr;ptr*);" & _
			"ConnectDirect hresult(ptr;ptr;ptr);" & _
			"Reconnect hresult(ptr);" & _
			"Disconnect hresult(ptr);" & _
			"SetDefaultSyncSource hresult();" & _ ; IFilterGraph
			"Connect hresult(ptr;ptr);" & _
			"Render hresult(ptr);" & _
			"RenderFile hresult(wstr;ptr);" & _
			"AddSourceFilter hresult(wstr;wstr;ptr*);" & _
			"SetLogFile hresult(dword_ptr);" & _
			"Abort hresult();" & _
			"ShouldOperationContinue hresult();" ; IGraphBuilder

	; Wrapp IGraphBuilder interface
	$oGraphBuilder = _AutoItObject_ObjCreate($sCLSID_FilterGraph, $sIID_IGraphBuilder, $dtagIGraphBuilder)
	If @error Then Return SetError(1, 0, False)

	; IMediaControl IDispatch
	Local $aCall = $oGraphBuilder.QueryInterface(Number(DllStructGetPtr($tIID_IMediaControl)), 0)
	If IsArray($aCall) And $aCall[2] Then
		$oMediaControl = _AutoItObject_PtrToIDispatch($aCall[2])
	Else
		Return SetError(2, 0, False)
	EndIf

	Local $pBasicAudio
	; Get pointer to IBasicAudio interface
	$aCall = $oGraphBuilder.QueryInterface(Number(DllStructGetPtr($tIID_IBasicAudio)), 0)
	If IsArray($aCall) And $aCall[2] Then
		$pBasicAudio = $aCall[2]
	Else
		Return SetError(3, 0, False)
	EndIf

	; IBasicAudio is dual interface. Defining vTable methods:
	Local $dtagIBasicAudio = $dtagIDispatch & _
			"put_Volume hresult(long);" & _
			"get_Volume hresult(long*);" & _
			"put_Balance hresult(long);" & _
			"get_Balance hresult(long*);" ; IBasicAudio

	; Wrapp it:
	$oBasicAudio = _AutoItObject_WrapperCreate($pBasicAudio, $dtagIBasicAudio)
	If @error Then Return SetError(4, 0, False)

	Return True ; There
EndFunc   ;==>_InitBuilder

Func _ReleaseBuilder(ByRef $oGraphBuilder, ByRef $oMediaControl, ByRef $oBasicAudio)
	$oMediaControl.Stop()
	$oBasicAudio = 0
	$oMediaControl = 0
	$oGraphBuilder.Release() ;<-!
	$oGraphBuilder = 0
EndFunc   ;==>_ReleaseBuilder

Func _RenderFile(ByRef $sMediaFile)
	_ReleaseBuilder($oGraphBuilder, $oMediaControl, $oBasicAudio)
	_InitBuilder($oGraphBuilder, $oMediaControl, $oBasicAudio)
	If Not _WMAsfReaderLoad($sMediaFile) Then
		$oUSER32DLL.MessageBeep("int", "dword", 48)
		$sMediaFile = ""
		Return SetError(1, 0, False)
	EndIf
	$oCOMError.number = 0 ; set no-error condition
	$oMediaControl.Run()
	; Check for error
	If $oCOMError.number Then
		GUICtrlSetFont($hLabelInfo, 9, -1, 1, "Arial")
		GUICtrlSetData($hLabelInfo, "Streaming failed")
		GUICtrlSetColor($hLabelInfo, 0xFF0000)
		MsgBox(48, "Error", "Failed to stream", 0, $hGUI)
	Else
		GUICtrlSetFont($hLabelInfo, 9, -1, 1, "Arial")
		GUICtrlSetData($hLabelInfo, "    Connected!")
	EndIf
	$sMediaFile = ""
	Return True
EndFunc   ;==>_RenderFile

Func _WMAsfReaderLoad($sFile)
	Local Const $sCLSID_WMAsfReader = "{187463A0-5BB7-11d3-ACBE-0080C75E246E}"
	; IBaseFilter definition
	Local Const $sIID_IBaseFilter = "{56a86895-0ad4-11ce-b03a-0020af0ba770}"
	Local $dtagIBaseFilter = $dtagIUnknown & _
			"GetClassID hresult(ptr*);" & _; IPersist
			"Stop hresult();" & _
			"Pause hresult();" & _
			"Run hresult(int64);" & _
			"GetState hresult(dword;dword*);" & _
			"SetSyncSource hresult(ptr);" & _
			"GetSyncSource hresult(ptr*);" & _ ; IMediaFilter
			"EnumPins hresult(ptr*);" & _
			"FindPin hresult(wstr;ptr*);" & _
			"QueryFilterInfo hresult(ptr*);" & _
			"JoinFilterGraph hresult(ptr;wstr);" & _
			"QueryVendorInfo hresult(wstr*);" ; IBaseFilter
	; Create object
	Local $oBaseFilter = _AutoItObject_ObjCreate($sCLSID_WMAsfReader, $sIID_IBaseFilter, $dtagIBaseFilter)
	If @error Then Return SetError(1, 0, False)
	; AddFilter is "must" to be able to use it
	$oGraphBuilder.AddFilter($oBaseFilter.__ptr__, "anything")

	; File will be loaded using FileSourceFilter object
	; IFileSourceFilter definition
	Local Const $sIID_IFileSourceFilter = "{56a868a6-0ad4-11ce-b03a-0020af0ba770}"
	Local $dtagIFileSourceFilter = $dtagIUnknown & _
			"Load hresult(wstr;ptr);" & _
			"GetCurFile hresult(ptr*;ptr);"

	Local $tIID_IFileSourceFilter = _AutoItObject_CLSIDFromString($sIID_IFileSourceFilter)
	; Ask for FileSourceFilter object from BaseFilter
	Local $aCall = $oBaseFilter.QueryInterface(Number(DllStructGetPtr($tIID_IFileSourceFilter)), 0)
	If Not IsArray($aCall) Then Return SetError(2, 0, False)
	; Wrapp it
	Local $oFileSourceFilter = _AutoItObject_WrapperCreate($aCall[2], $dtagIFileSourceFilter)

	; Load the file now
	$oFileSourceFilter.Load($sFile, 0)

	$aCall = $oFileSourceFilter.GetCurFile(0, 0)
	Local $pFile = $aCall[1]
	Local $sLoaded = DllStructGetData(DllStructCreate("wchar[" & __Au3Obj_PtrStringLen($pFile) + 1 & "]", $pFile), 1)
	__Au3Obj_CoTaskMemFree($pFile)
	ConsoleWrite($sLoaded & @CRLF)

	; Get pointer to EnumPins object
	$aCall = $oBaseFilter.EnumPins(0)
	If Not IsArray($aCall) Or Not $aCall[1] Then Return SetError(3, 0, False)
	Local $pEnum = $aCall[1]

	; Define IEnumPins methods
	Local $dtagIEnumPins = $dtagIUnknown & _
			"Next hresult(dword;ptr*;dword*);" & _
			"Skip hresult(dword);" & _
			"Reset hresult();" & _
			"Clone hresult(ptr*);"
	; Wrapp it
	Local $oEnum = _AutoItObject_WrapperCreate($pEnum, $dtagIEnumPins)

	; Will enumerate all PINs and render them
	Local $pPin
	While 1
		$aCall = $oEnum.Next(1, 0, 0)
		If Not IsArray($aCall) Then Return SetError(4, 0, False)
		$pPin = $aCall[2]
		If $pPin Then
			$oGraphBuilder.Render($pPin)
			_AutoItObject_IUnknownRelease($pPin); releasing non-wrapped object when no longer needed
		EndIf
		If $aCall[0] Then ExitLoop
	WEnd

	; All's ok
	Return True
EndFunc   ;==>_WMAsfReaderLoad


Func _ErrFunc()
;~ 	ConsoleWrite("! COM Error !  Number: 0x" & Hex($oCOMError.number, 8) & "   ScriptLine: " & $oCOMError.scriptline & " - " & $oCOMError.windescription & @CRLF)
EndFunc   ;==>_ErrFunc