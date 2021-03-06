#include-once
#include <WindowsConstants.au3>

; #INDEX# =======================================================================================================================
; Title .........: WebcamDS
; AutoIt Version : from  3.3.9.1 beta
; Language ......: English
; Description ...: handle webcams with Direct Show
; Author(s) .....: frank10
;
; ------------------------ CREDITS: -------------------------
;
; thanks to trancexx and ProgAndy for the beginning tasks with DirectShow objects
; ===============================================================================================================================

; 1.2  added VMR9 mixing mode

; #VARIABLES# ===================================================================================================================
Global $aWebcamList[9]
Global $aCompressorList[50]
;~ Global $aAuCompressorList[50]
Global $aMicList[9]
Global $iWebcam = 1, $iWebAudio = 0, $iWebRescale = 1, $iWebX, $iWebY, $iWebBpp, $aZoomPos[4]
$aZoomPos[0] = 1
$aZoomPos[1] = 0
$aZoomPos[2] = 1
$aZoomPos[3] = 0

Global $oBasicAudio, $oBasicVideo, $oBuild, $oCapture[9], $oCaptureAudio, $oGraph, $oIBaseFilter, $oMediaControl, $oDevEnum, $oEnum, $oICreateDevEnum, $oIEnumMoniker
Global $oVideoWindow, $oVmr9, $oCompressor, $oStreamConfig
Global $Vmr9 = 1, $iWebXinside=0,$iWebYinside=0
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
#include "DirectShow_Interfaces_1.2.au3"
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_WebcamDS_ReleaseObjects
;_WebcamDS_RenderWebcam
;_WebcamDS_SaveFile
;_WebcamDS_WebcamInit
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
;_WebcamDS_EnumerateDevices
;_WebcamDS_Reset
;_WebcamDS_SelectRect
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
;
; Name...........: _WebcamDS_ReleaseObjects
; Description ...: release Objects created during script and at the end of it
; Syntax.........: _WebcamDS_ReleaseObjects($iArg = 0)
; Parameters ....: $iArg   - use 0 if you want to delete only the current capture obj, otherwise (ie: at the end) put it to 1
; Return values .: Success - it deletes the objects created
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: Frank10
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ===============================================================================================================================
Func _WebcamDS_ReleaseObjects($iArg = 0)
	$oMediaControl.Stop()
	$oMediaControl = 0
	$oVmr9 = 0
	$oCapture[$iWebcam] = 0
	If $iArg Then $oCapture = 0
	$oCaptureAudio = 0
	$oBasicAudio = 0
	$oBasicVideo = 0
	$oVideoWindow = 0
	$oGraph = 0
	$oBuild = 0
	$oCompressor = 0
EndFunc   ;==>_ReleaseObjects



; #FUNCTION# ====================================================================================================================
;
; Name...........: _WebcamDS_RenderWebcam
; Description ...: call it to set which webcam to display, audio preview, resolution, scale to GUI, zoom
; Syntax.........: _WebcamDS_RenderWebcam($iNumberWebcam=1,$iAudioMic=0,$hGuiWin[,$iScale=1[,$xVideo=640[,$yVideo=480[,$ibpp=16[,$iZoomX=0[,$iZoomY=0[,$iZoomW=0[,$iZoomH=0]]]]]]]])
; Parameters ....: $iNumberWebcam - The webcam to display (from 1)
;                  $iAudioMic   - If you want to preview the audio from the mic of the webcam set it to the corresponding
;									position of the mic
;								- see the position in the Mic list in the array $aMicList filled by _WebcamInit (the position of
;									the Mic isn't always equal to the webcam position!)
;								- it's possible to view one webcam and listen to the mic of another one!
;								- if you don't want audio preview, set it to 0
;                  $hGuiWin  	- The GUI you create to display the webcam
;                  $iScale		- if you want to scale the webcam resolution to the res of the GUI, set it to 1, otherwise to 0
;                  $xVideo		- The webcam Width
;                  $yVideo  	- The webcam Height
;                  $ibpp		- bitplane (if you put strange values it doesn't seem to change it..) normal: 12-16-24
;                  $iZoomX		- rectangle Zoom offsetX (0 = noZoom)
;								- if you use it manually, be careful to put values that are inside the original width-height of
;									webcam otherwise it doesn't work
;								- it's better to use the Setrect func drawing the rectangle with mouse directly on the GUI
;                  $iZoomY		- rectangle Zoom offsetY (0 = noZoom)
;                  $iZoomW  	- rectangle Zoom Width (0 = noZoom)
;                  $iZoomH		- rectangle Zoom Heigth (0 = noZoom)
; Return values .: Success - it displays the webcam selected
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: Frank10
; Modified.......:
; Remarks .......: use global var $iWebXinside and $iWebYinside to adapt X-Y webcam's position inside your GUI
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ===============================================================================================================================
;~ Func _RenderWebcam(ByRef $iWebcam,$hGuiWin=$hGUI,ByRef $iScale,$xVideo='640',$yVideo='480',$ibpp='16',$iZoomX=0,$iZoomY=0,$iZoomW=0,$iZoomH=0)
;~ Func _RenderWebcam($iWebcam,$hGuiWin=$hGUI,$iScale,$xVideo='640',$yVideo='480',$ibpp='16',$iZoomX=0,$iZoomY=0,$iZoomW=0,$iZoomH=0)
Func _WebcamDS_RenderWebcam($iNumberWebcam, $iAudioMic, $hGuiWin , $iScale = 1, $xVideo = 640, $yVideo = 480, $ibpp = 16, $iZoomX = 0, $iZoomY = 0, $iZoomW = 0, $iZoomH = 0)
	local $hr
	$iWebcam = $iNumberWebcam
	$iWebAudio = $iAudioMic
	$iWebRescale = $iScale
	$iWebX = $xVideo
	$iWebY = $yVideo

	_WebcamDS_enumerateDevices($sCLSID_VideoInputDeviceCategory, $iNumberWebcam)
	;----------------------------------------------------------------------------------------------------
	;-----------------------------------  change resolution original video: --------------
	Local $_GUID = "DWORD Data1;" & _
			"WORD  Data2;" & _
			"WORD  Data3;" & _
			"BYTE  Data4[8];"
;~ 	Local $tGuid = DllStructCreate($_GUID)

	Local $_SIZE = "LONG cx;" & _
			"LONG cy;"
;~ 	Local $tSize = DllStructCreate($_SIZE)

	Local $_VIDEO_STREAM_CONFIG_CAPS = $_GUID & _
			"ULONG    VideoStandard;" & _
			$_SIZE & _
			$_SIZE & _
			$_SIZE & _
			"int      CropGranularityX;" & _
			"int      CropGranularityY;" & _
			"int      CropAlignX;" & _
			"int      CropAlignY;" & _
			$_SIZE & _
			$_SIZE & _
			"int      OutputGranularityX;" & _
			"int      OutputGranularityY;" & _
			"int      StretchTapsX;" & _
			"int      StretchTapsY;" & _
			"int      ShrinkTapsX;" & _
			"int      ShrinkTapsY;" & _
			"int64 	MinFrameInterval;" & _
			"int64	 MaxFrameInterval;" & _
			"LONG     MinBitsPerSecond;" & _
			"LONG     MaxBitsPerSecond;"
	Local $tVideoStream = DllStructCreate($_VIDEO_STREAM_CONFIG_CAPS)

	Local $_AM_MEDIA = $_GUID & _
			$_GUID & _
			'BOOL  bFixedSizeSamples;' & _
			'BOOL  bTemporalCompression;' & _
			'ULONG    lSampleSize;' & _
			$_GUID & _
			'ptr pUnk;' & _
			'ULONG    cbFormat;' & _
			'ptr  pbFormat;'
	Local $t_AM_MEDIA = DllStructCreate($_AM_MEDIA)

	Local $_RECT = 'LONG left;' & _
			'LONG top;' & _
			'LONG right;' & _
			'LONG bottom;'
	Local $_tagBITMAPINFOHEADER = 'DWORD biSize;' & _
			'LONG  biWidth;' & _
			'LONG  biHeight;' & _
			'WORD  biPlanes;' & _
			'WORD  biBitCount;' & _
			'DWORD biCompression;' & _
			'DWORD biSizeImage;' & _
			'LONG  biXPelsPerMeter;' & _
			'LONG  biYPelsPerMeter;' & _
			'DWORD biClrUsed;' & _
			'DWORD biClrImportant;'
	Local $_tagVIDEOINFOHEADER = $_RECT & _
			$_RECT & _
			'DWORD            dwBitRate;' & _
			'DWORD            dwBitErrorRate;' & _
			'int64   AvgTimePerFrame;' & _
			$_tagBITMAPINFOHEADER

;~ 	Local $MAX_PIN_NAME = 128
	Local $_PinInfo = 'ptr   pFilter;' & _
			'int64    dir;' & _
			'wchar    achName[128];'
;~ 		'wchar    achName['&$MAX_PIN_NAME&'];'


	Local $pConfig
	$hr = $oBuild.FindInterface($PIN_CATEGORY_CAPTURE, $MEDIATYPE_Video, $oCapture[$iNumberWebcam], $sIID_IAMStreamConfig, $pConfig)
	$oStreamConfig = ObjCreateInterface($pConfig, $sIID_IAMStreamConfig, $tagIAMStreamConfig)
	FileWrite($log, "13,0" & @CRLF)
	If Not IsObj($oStreamConfig) Then		Return SetError(13, 0, 0)

	Local $iCount = 0, $iSize = 0
	$hr = $oStreamConfig.GetNumberOfCapabilities($iCount, $iSize)
	FileWrite($log, "1,7" & @CRLF)
	If $hr < 0 Then		Return SetError(1, 7, 0)

	; Check the size to make sure we pass in the correct structure.
	If DllStructGetSize($tVideoStream) == $iSize Then
		For $iFormat = 0 To $iCount - 1 Step 1
			Local $scc = DllStructGetPtr($tVideoStream)
			Local $pmtConfig = DllStructGetPtr($t_AM_MEDIA)

			$hr = $oStreamConfig.GetStreamCaps($iFormat, $pmtConfig, $scc);
			Local $t_AM_MEDIA_TYPE = DllStructCreate($_AM_MEDIA, $pmtConfig)

			Local $pbFormat = DllStructGetData($t_AM_MEDIA_TYPE, "pbFormat")
			Local $t_VIDEOINFOHEADER = DllStructCreate($_tagVIDEOINFOHEADER, $pbFormat)

			Local $videoWidth = DllStructGetData($t_VIDEOINFOHEADER, 'biWidth')
			Local $videoHeight = DllStructGetData($t_VIDEOINFOHEADER, 'biHeight')
			Local $bitCount = DllStructGetData($t_VIDEOINFOHEADER, 'biBitCount')
			Local $dwBitRate = DllStructGetData($t_VIDEOINFOHEADER, 'dwBitRate')
			Local $biCompression = DllStructGetData($t_VIDEOINFOHEADER, 'biCompression')
			Local $biPlanes = DllStructGetData($t_VIDEOINFOHEADER, 'biPlanes')
			Local $biSize = DllStructGetData($t_VIDEOINFOHEADER, 'biSizeImage')
			Local $AvgframeRate = Round(10000000 / DllStructGetData($t_VIDEOINFOHEADER, 'AvgTimePerFrame'))

			; identify FOURCC compression:
			Local $sText = ''
			For $i = 7 To 0 Step -2
				If $biCompression <> 0 Then $sText = $sText & Chr(Dec(StringMid(Hex($biCompression, 8), $i, 2)))
			Next
;~ 			if $videoWidth <> 0 Then ConsoleWrite('----- iFormat:'&$iFormat& '  VIDEOINFOHEADER:'&$videoWidth&'x'&$videoHeight&','&$bitCount & ', FrameRate:' &$AvgframeRate&', bitRate(MBs):' & Round($dwBitRate/8/1024/1024,1) & ', Compression:' & Hex($biCompression,8)& '-' _
;~ 				& $sText & ', biSize(bytes):'  & $biSize  & @CRLF)

			Local $FrameRate = GUICtrlRead($FrameInput)
			DllStructSetData($t_VIDEOINFOHEADER, 'AvgTimePerFrame', 10000000 / $FrameRate)
			If $videoWidth = $xVideo And $videoHeight = $yVideo And $bitCount = $ibpp Then
				$hr = $oStreamConfig.SetFormat(DllStructGetPtr($t_AM_MEDIA_TYPE));
				FileWrite($log, "1,8" & @CRLF)
				If $hr < 0 Then		Return SetError(1, 8, 0)
				ExitLoop
			EndIf

			; if there is no match with the desired res, I create one personalized:
			If $iFormat = $iCount - 1 Then
				DllStructSetData($t_VIDEOINFOHEADER, 'biWidth', $xVideo)
				DllStructSetData($t_VIDEOINFOHEADER, 'biHeight', $yVideo)
				DllStructSetData($t_VIDEOINFOHEADER, 'biBitCount', $ibpp)
				$hr = $oStreamConfig.SetFormat(DllStructGetPtr($t_AM_MEDIA_TYPE));
				FileWrite($log, "1,9" & @CRLF)
				If $hr < 0 Then		Return SetError(1, 9, 0)
			EndIf
		Next
		WinSetTitle($hGuiWin, '', WinGetTitle($hGuiWin) & ' - ' & $xVideo & 'x' & $yVideo & 'x' & $ibpp)
		$oStreamConfig = 0
	EndIf ; end change resolution

	;----------------------------------------------------------------------------------------------------
	;------------------------------------------------------AUDIO preview: -------------------------------

	If $iAudioMic <> 0 Then
		_WebcamDS_enumerateDevices($sCLSID_AudioInputDeviceCategory, $iAudioMic)
		$pConfig = ''
		$hr = $oBuild.FindInterface($PIN_CATEGORY_CAPTURE, $MEDIATYPE_Audio, $oCaptureAudio, $sIID_IAMStreamConfig, $pConfig)
		Global $oAStreamConfig = ObjCreateInterface($pConfig, $sIID_IAMStreamConfig, $tagIAMStreamConfig)
	EndIf

;~ 	if IsObj($oCaptureAudio) Then
;~ 			local $pEnum
;~ 			$hr = $oCaptureAudio.EnumPins($pEnum)
;~ 			$oEnum =ObjCreateInterface($pEnum, $sIID_IEnumPins, $tagIEnumPins)

;~ 			Local $pPin,$pCompress,$pInfo,$oPin
;~ 			While $oEnum.Next(1, $pPin, 0) = $S_OK
;~ 				$oPin = ObjCreateInterface($pPin, $sIID_IPin, $tagIPin)

;~ 				local $pPinInfo
;~ 				$hr = $oPin.QueryPinInfo($pPinInfo)
;~ 				Local $t_PinInfo = DLLStructCreate($_PinInfo, $pPinInfo)
;~ 				ConsoleWrite('--PinName:--'& @error &' struct:'&DLLStructGetData($t_PinInfo, 3)  &@CRLF)

;~ 				Local $pAudioMixer, $oAudioMixer
;~ 				$oPin = 0
;~ 				$i +=1
;~ 				ConsoleWrite('---i:'&$i&' hr:'&$hr&@CRLF)
;~ 			WEnd
;~ 			$oEnum = 0
;~ 			$oPin = 0
;~ 	EndIf


	;---------------------------------------------------------------------------------------
	;-----------------------------------  VMR7 or VMR9 renderer   --------------------------
	If $Vmr9 = 0 Then
		;  Build the preview part of the graph.
		$hr = $oBuild.RenderStream($PIN_CATEGORY_PREVIEW, $MEDIATYPE_Video, $oCapture[$iNumberWebcam], 0, 0)
		FileWrite($log, "1,10" & @CRLF)
		If $hr < 0 Then		Return SetError(1, 10, 0)
		If IsObj($oCaptureAudio) Then $hr = $oBuild.RenderStream($PIN_CATEGORY_PREVIEW, $MEDIATYPE_Audio, $oCaptureAudio, 0, 0)
	Else
		$oVmr9 = ObjCreateInterface($sCLSID_VideoMixingRenderer9, $sIID_IBaseFilter, $tagIBaseFilter)
		FileWrite($log, "14,0" & @CRLF)
		If Not IsObj($oVmr9) Then		Return SetError(14, 0, 0)

		; Call IFilterGraph::AddFilter on the Filter Graph Manager to add the VMR-9 to the filter graph:
		$hr = $oGraph.AddFilter($oVmr9, "VMR9")
		FileWrite($log, "1,11" & @CRLF)
		If $hr < 0 Then		Return SetError(1, 11, 0)

		; set mixing-mode for more than 1 stream:
		local $pConfig9, $oConfig9
		$hr = $oVmr9.QueryInterface($sIID_IVMRFilterConfig9, $pConfig9);
		$oConfig9 = ObjCreateInterface($pConfig9, $sIID_IVMRFilterConfig9, $tagIVMRFilterConfig9)
		FileWrite($log, "15,0" & @CRLF)
		If Not IsObj($oConfig9) Then		Return SetError(15, 0, 0)

		ConsoleWrite('Filterconf hr:'&$hr&'  '&IsObj($oConfig9) &@CRLF)

		local $str=''
		$hr = $oConfig9.SetNumberOfStreams(4);
		FileWrite($log, "1,12" & @CRLF)
		If $hr < 0 Then		Return SetError(1, 12, 0)

;~ 		$hr = $oConfig9.GetNumberOfStreams($str);
		ConsoleWrite('NumberStream hr:'&$hr&'  Get:'&$str&@CRLF)

		local $pMixControl9,$oMixControl9
		$hr = $oVmr9.QueryInterface($sIID_IVMRMixerControl9, $pMixControl9);
		ConsoleWrite('Mixercontrol9 hr:'&$hr&@CRLF)
		$oMixControl9 = ObjCreateInterface($pMixControl9, $sIID_IVMRMixerControl9, $tagIVMRMixerControl9)
		FileWrite($log, "16,0" & @CRLF)
		If Not IsObj($oMixControl9) Then		Return SetError(16, 0, 0)

		Local $t_VMR9rect = DllStructCreate($_RECT) ; ltrb

		Local $l = 0, $t = 0, $r = $l + $xVideo, $b = $t + $yVideo
		DllStructSetData($t_VMR9rect, 'left', $l)
		DllStructSetData($t_VMR9rect, 'top', $t)
		DllStructSetData($t_VMR9rect, 'right', $r)
		DllStructSetData($t_VMR9rect, 'bottom', $b)
		local $streamID = 0
		$hr = $oMixControl9.SetOutputRect($streamID, DllStructGetPtr($t_VMR9rect));
		ConsoleWrite('Output rect0 hr:'&$hr&@CRLF)
		FileWrite($log, "1,13" & @CRLF)
		If $hr < 0 Then			Return SetError(1, 13, 0)

;~ 		Local $l = 150, $t = 200, $r = $l + $xVideo, $b = $t + $yVideo
;~ 		DllStructSetData($t_VMR9rect, 'left', $l)
;~ 		DllStructSetData($t_VMR9rect, 'top', $t)
;~ 		DllStructSetData($t_VMR9rect, 'right', $r)
;~ 		DllStructSetData($t_VMR9rect, 'bottom', $b)
;~ 		local $streamID = 1
;~ 		$hr = $oMixControl9.SetOutputRect($streamID, DllStructGetPtr($t_VMR9rect));
;~ 		ConsoleWrite('Output rect1 hr:'&$hr&@CRLF)
;~ 		If $hr < 0 Then
;~ 			Return SetError(1, 14, 0)
;~
;~ 		EndIf


        $oConfig9 = 0
		$oMixControl9 = 0



;~         pConfig->SetRenderingMode(VMR9Mode_Windowless);
;~         pConfig->SetRenderingPrefs(RenderPrefs_AllowOverlays);
;~         hr = pConfig->SetRenderingPrefs(RenderPrefs_ForceOverlays|RenderPrefs_AllowOverlays);
;~         pConfig->Release();

;      WINDOWLESS 9
;~         hRes = pBF->QueryInterface(IID_IVMRWindowlessControl9, (LPVOID *)&m_Wc);
;~         HRESULT hr = m_Wc->SetVideoClippingWindow(m_hwndApp);
;~         hr = m_Wc->SetAspectRatioMode(VMR_ARMODE_LETTER_BOX);

;~         bRet = (m_Wc->GetNativeVideoSize(pcx, pcy, NULL, NULL) == S_OK);

;~         RECT src={0}, dest={0};
;~         HRESULT hr = m_Wc->GetVideoPosition(&src, &dest);
;~         *px = dest.left;
;~         *py = dest.right;
;~         *pcx = dest.right - dest.left;
;~         *pcy = dest.bottom - dest.top;

;~     RECT rc;
;~     SetRect(&rc, x, y, x + cx, y + cy);
;~     if(m_Wc)
;~     {
;~         bRet = (m_Wc->SetVideoPosition(NULL, &rc) == S_OK);


;~     HRESULT hres = m_Wc->QueryInterface(IID_IVMRMixerBitmap9, (LPVOID *)&pBmp);
;~     hres = pBmp->SetAlphaBitmap(lpBmpInfo);
;~     hres = pBmp->UpdateAlphaBitmapParameters(lpBmpInfo);






		; Call the ICaptureGraphBuilder2::RenderStream method to render the video stream to the VMR and eventually the audio:
		$hr = $oBuild.RenderStream($PIN_CATEGORY_PREVIEW, $MEDIATYPE_Video, $oCapture[$iNumberWebcam], 0, $oVmr9)
		FileWrite($log, "1,14" & @CRLF)
		If $hr < 0 Then		Return SetError(1, 14, 0)
		If IsObj($oCaptureAudio) Then $hr = $oBuild.RenderStream($PIN_CATEGORY_PREVIEW, $MEDIATYPE_Audio, $oCaptureAudio, 0, 0)
		; 		ConsoleWrite(">>RenderstreamPrev VMR9 hr = " & Hex($hr) & @CRLF) 	;>>RenderstreamPrev VMR9 hr = 0004027E  OK: Preview was rendered throught the Smart Tee filter,
		$oVmr9 = 0
	EndIf

	; set position e dimensions of webcam inside GUI, eventually rescale it
	Local $iX = $iWebXinside, $iY = $iWebYinside

	Local $aClientSize = WinGetClientSize($hGuiWin)
	If $iScale = 1 Then
		$xVideo = $aClientSize[0]
		$yVideo = $aClientSize[1]
	EndIf

	If $iZoomW <> 0 Then
		$hr = $oBasicVideo.SetSourcePosition($iZoomX, $iZoomY, $iZoomW, $iZoomH)
		FileWrite($log, "1,15" & @CRLF)
		If $hr < 0 Then		Return SetError(1, 15, 0)
	EndIf


	$hr = $oVideoWindow.SetWindowPosition($iX, $iY, $xVideo, $yVideo)
	FileWrite($log, "1,16" & @CRLF)
	If $hr < 0 Then		Return SetError(1, 16, 0)

	; connect video to GUI
	$hr = $oVideoWindow.put_Owner($hGuiWin)
	FileWrite($log, "1,17" & @CRLF)
	If $hr < 0 Then		Return SetError(1, 17, 0)

	; borderless
	$oVideoWindow.put_WindowStyle(BitOR($WS_CHILD, $WS_CLIPCHILDREN))
	FileWrite($log, "1,18" & @CRLF)
	If $hr < 0 Then		Return SetError(1, 18, 0)

	; start graph
	$hr = $oMediaControl.Run()
	FileWrite($log, "1,19" & @CRLF)
	If $hr < 0 Then		Return SetError(1, 19, 0)
EndFunc   ;==>_RenderWebcam


; #FUNCTION# ====================================================================================================================
;
; Name...........: _WebcamDS_SaveFile
; Description ...: save an avi with the wecam selected with or without audio
; Syntax.........: _WebcamDS_SaveFile($sFileName[,$sCompress[,$iAudioMic=0]])
; Parameters ....: $sFileName	- The filename to save with
;                  $sCompress   - the name of the compressor to use as you can find in the $aCompressorList, use 'Uncompressed'
;									if you don't want to compress
;								- generally to change the parameters of compressor use the dialog box of the specific compressor
;									prior to call this func
;                  $iAudioMic   - If you want to save the audio too, set it to the mic number you want, otherwise to 0
;								- (you can save the video from one webcam and the audio from another one, but the audio is the
;									same of the preview)
; Return values .: Success - it saves an avi
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: Frank10
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ===============================================================================================================================
Func _WebcamDS_SaveFile($sFileName, $sCompress='Uncompressed', $iAudioMic = 0)
	Local $hr
	$hr = $oMediaControl.Stop()

	_WebcamDS_enumerateDevices($sCLSID_VideoCompressorCategory, $sCompress)

	If $sCompress <> 'Uncompressed' Then
		Local $i = 0, $pEnum, $oCompress, $oPin
		$hr = $oCompressor.EnumPins($pEnum)
		If $hr < 0 Then		Return SetError(1, 20, 0)

		$oEnum = ObjCreateInterface($pEnum, $sIID_IEnumPins, $tagIEnumPins)
		Local $pPin, $pCompress
		While $oEnum.Next(1, $pPin, 0) = $S_OK
			$oPin = ObjCreateInterface($pPin, $sIID_IPin, $tagIPin)
			If Not IsObj($oPin) Then		Return SetError(17, 0, 0)

			$hr = $oPin.QueryInterface($sIID_IAMVideoCompression, $pCompress)
			$oCompress = ObjCreateInterface($pCompress, $sIID_IAMVideoCompression, $tagIAMVideoCompression)
			If Not IsObj($oCompress) Then		Return SetError(18, 0, 0)

			$oPin = 0
			$i += 1
			If $hr >= 0 Then
				ExitLoop
			EndIf
			$oCompress = 0
		WEnd
		$oEnum = 0
		$oPin = 0

		If $hr >= 0 Then
			Local $Cap, $KeyFrameDef, $PFrameDef, $QualityDef, $KeyFrame, $PFrame, $m_Quality
			$hr = $oCompress.GetInfo(0, 0, 0, 0, $KeyFrameDef, $PFrameDef, $QualityDef, $Cap)
			If $hr < 0 Then		Return SetError(1, 21, 0)

;~ 			ConsoleWrite($hr & ' --- KeyDef= ' & $KeyFrameDef & ' PFrame:' &$PFrameDef & ' QualDef:'&$QualityDef&' cap:'&$Cap&@CRLF)
			; 			it's possible to change quality (MJPEG):
;~ 			$hr = $oCompress.put_Quality(1.0)

			If $hr >= 0 Then
				If BitAND($Cap, $CompressionCaps_CanKeyframe) Then
					$hr = $oCompress.get_KeyFrameRate($KeyFrame)
					If $hr < 0 Or $KeyFrame < 0 Then $KeyFrame = $KeyFrameDef
				EndIf
			EndIf
		EndIf
	Else
		$oCompressor = 0
	EndIf

	; save to disk
	Local $pMux, $oMux

	$hr = $oBuild.SetOutputFileName($MEDIASUBTYPE_Avi, $sFileName, $pMux, 0)
	If $hr < 0 Then		Return SetError(1, 22, 0)

	$oMux = ObjCreateInterface($pMux, $sIID_IBaseFilter, $tagIBaseFilter)
	If Not IsObj($oMux) Then		Return SetError(19, 0, 0)

	$hr = $oBuild.RenderStream($PIN_CATEGORY_CAPTURE, $MEDIATYPE_Video, $oCapture[$iWebcam], $oCompressor, $oMux)
	If $hr < 0 Then		Return SetError(1, 23, 0)

	If $iAudioMic <> 0 Then
		_WebcamDS_EnumerateDevices($sCLSID_AudioInputDeviceCategory, $iAudioMic)
		$hr = $oBuild.RenderStream($PIN_CATEGORY_CAPTURE, $MEDIATYPE_Audio, $oCaptureAudio, 0, $oMux)
		If $hr < 0 Then		Return SetError(1, 24, 0)
	EndIf

	$oMux = 0
	$oMediaControl.Run()
EndFunc   ;==>_WebcamDS_SaveFile

; #FUNCTION# ====================================================================================================================
;
; Name...........: _WebcamDS_Init
; Description ...: Create Direct Show objects and enumerate webcams, compressors, micAudio
; Syntax.........: _WebcamDS_Init()
; Parameters ....: none
; Return values .: Success - it fills 3 array  $aWebcamList, $aCompressorList, $aMicList
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: Frank10
; Modified.......:
; Remarks .......: call it at the beginning of the script
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ===============================================================================================================================
Func _WebcamDS_Init()
	Local $hr, $aCall
;~  / / Create the FGM.
	$oGraph = ObjCreateInterface($sCLSID_FilterGraph, $sIID_IGraphBuilder, $tagIGraphBuilder)
	FileWrite($log, "1,0" & @CRLF)
	If Not IsObj($oGraph) Then	Return SetError(1, 0, 0)

;~  / / Create the capture graph builder helper object
	$oBuild = ObjCreateInterface($sCLSID_CaptureGraphBuilder2, $sIID_ICaptureGraphBuilder2, $tagICaptureGraphBuilder2)
	FileWrite($log, "2,0" & @CRLF)
	If Not IsObj($oBuild) Then	Return SetError(2, 0, 0)

;~  / / Tell the capture graph builder about the FGM.
	$hr = $oBuild.SetFiltergraph($oGraph)
	FileWrite($log, "0,1" & @CRLF)
	If $hr < 0 Then		Return SetError(0, 1, 0)

	Local $pMediaControl
	$oGraph.QueryInterface($sIID_IMediaControl, $pMediaControl)
	$oMediaControl = ObjCreateInterface($pMediaControl, $sIID_IMediaControl)
	FileWrite($log, "3,0" & @CRLF)
	If Not IsObj($oMediaControl) Then	Return SetError(3, 0, 0)

	Local $pVideoWindow
	$oGraph.QueryInterface($sIID_IVideoWindow, $pVideoWindow)
	$oVideoWindow = ObjCreateInterface($pVideoWindow, $sIID_IVideoWindow, $tagIVideoWindow)
	FileWrite($log, "4,0" & @CRLF)
	 If Not IsObj($oVideoWindow) Then	Return SetError(4, 0, 0)

	Local $pBasicVideo
	$oGraph.QueryInterface($sIID_IBasicVideo, $pBasicVideo)
	$oBasicVideo = ObjCreateInterface($pBasicVideo, $sIID_IBasicVideo, $tagIBasicVideo)
	FileWrite($log, "5,0" & @CRLF)
	 If Not IsObj($oBasicVideo) Then		Return SetError(5, 0, 0)

	If $aWebcamList[1] = '' Then
		_WebcamDS_EnumerateDevices($sCLSID_VideoInputDeviceCategory)

		_WebcamDS_EnumerateDevices($sCLSID_VideoCompressorCategory)

		_WebcamDS_EnumerateDevices($sCLSID_AudioInputDeviceCategory)
	EndIf
EndFunc   ;==>_WebcamInit



; =====================================================================================================================
;
; #INTERNAL_NO_DOC# ===================================================================================================
;
; =====================================================================================================================
Func _WebcamDS_EnumerateDevices($CLSID_category, $argument = 99)
	; Create a helper object To find the capture device.
	$oDevEnum = ObjCreateInterface($sCLSID_SystemDeviceEnum, $sIID_ICreateDevEnum, $tagICreateDevEnum)
	FileWrite($log, "6,0"  & @CRLF)
	If Not IsObj($oDevEnum) Then Return SetError(6, 0, 0)

	Local $pEnum = 0
	$oDevEnum.CreateClassEnumerator($CLSID_category, $pEnum, 0)
	$oEnum = ObjCreateInterface($pEnum, $sIID_IEnumMoniker, $tagIEnumMoniker)
	FileWrite($log, "7,0" & @CRLF)
	If Not IsObj($oEnum) Then	Return SetError(7, 0, 0)

	Local $iPosition = '', $arg = ''
	If StringInStr($CLSID_category, "860bb310") Or StringInStr($CLSID_category, "33d9a762") Then ; VideoInputDevice or Audio
		$iPosition = $argument
		$arg = ''
	Else ; data for compressor
		$iPosition = ''
		$arg = $argument
	EndIf

	Local $pMoniker, $oMoniker, $hr
	Local $i = 1, $pBindObj[99]
	While $oEnum.Next(1, $pMoniker, 0) = $S_OK
		Local $pPropBag, $oPropBag
		$oMoniker = ObjCreateInterface($pMoniker, $sIID_IMoniker, $tagIMoniker)
		FileWrite($log, "8,0" & @CRLF)
		If Not IsObj($oMoniker) Then	Return SetError(8, 0, 0)

		$hr = $oMoniker.BindToObject(0, 0, $sIID_IBaseFilter, $pBindObj[$i])
		If $hr < 0 Then ExitLoop

		$hr = $oMoniker.BindToStorage(0, 0, $sIID_IPropertyBag, $pPropBag)
		FileWrite($log, "1,2" & @CRLF)
		If $hr < 0 Then	Return SetError(1, 2, 0)

		$oPropBag = ObjCreateInterface($pPropBag, $sIID_IPropertyBag, $tagIPropertyBag)
		FileWrite($log, "9,0" & @CRLF)
		If Not IsObj($oPropBag) Then	Return SetError(9, 0, 0)

		Local $var = ''
		$hr = $oPropBag.Read("FriendlyName", $var, 0)
		FileWrite($log, "1,3" & @CRLF)
		If $hr < 0 Then		Return SetError(1, 3, 0)
		 	;	ConsoleWrite('>> FriendlyMoniker' & $i & ': ' &$var& @CRLF)

		If $iPosition = 99 Then
			If StringInStr($CLSID_category, "33d9a762") Then; list mics
				If $var <> '' Then
					$aMicList[$i] = $var
				EndIf
			Else ; list webcams
				If $var <> '' Then
					$aWebcamList[$i] = $var
				EndIf
			EndIf
			Local $oCaptureTemp = ObjCreateInterface($pBindObj[$i], $sIID_IBaseFilter, $tagIBaseFilter)
			$oCaptureTemp = 0
			; create oCaptureTemp otherwise with some webcams (Philips) gives error at the end of script ????
			; ---------------------------
			; ASSERT Failed
			; ---------------------------
			; Executable: autoit3.exe  Pid 17dc  Tid 768. Module CamExt40V32.ax, 2 objects left active!
			; At line 320 of f:\dev64\dsdll\dllentry.cpp
			; Continue? (Cancel to debug)
			; ---------------------------
		EndIf
		If $iPosition = '' And $arg = 99 Then
			; list of compressor
			If $var <> '' Then
				$aCompressorList[$i] = $var
			EndIf
		EndIf

		If ($iPosition <> '' And $iPosition = $i) Or ($arg <> '' And $var = $arg) Then
			; 			ConsoleWrite('------found'&@CRLF)
			If ($iPosition = '' And $arg = $var) Then ;
				If Not IsObj($oCompressor) Then
					$oCompressor = ObjCreateInterface($pBindObj[$i], $sIID_IBaseFilter, $tagIBaseFilter)
					FileWrite($log, "10,0" & @CRLF)
					If Not IsObj($oCompressor) Then		Return SetError(10, 0, 0)
				EndIf
				; Add the compressor filter To the filter graph
				$hr = $oGraph.AddFilter($oCompressor, "Compressor" & $iWebcam)
				FileWrite($log, "1,4" & @CRLF)
				If $hr < 0 Then			Return SetError(1, 4, 0)
				ExitLoop
			EndIf

			If ($iPosition <> '' And $iPosition = $i) Then
				If StringInStr($CLSID_category, "33d9a762") Then ; � l'audio
					If Not IsObj($oCaptureAudio) Then
						$oCaptureAudio = ObjCreateInterface($pBindObj[$i], $sIID_IBaseFilter, $tagIBaseFilter)
						FileWrite($log, "11,0" & @CRLF)
						If Not IsObj($oCaptureAudio) Then 	Return SetError(11, 0, 0)
						ConsoleWrite($iWebAudio & 'capAu:' & $i & @CRLF)
					EndIf
					;  Add the captureAudio filter To the filter graph
					$hr = $oGraph.AddFilter($oCaptureAudio, $var)
					FileWrite($log, "1,5" & @CRLF)
					If $hr < 0 Then		Return SetError(1, 5, 0)
				Else
					If Not IsObj($oCapture[$iPosition]) Then
						$oCapture[$iPosition] = ObjCreateInterface($pBindObj[$i], $sIID_IBaseFilter, $tagIBaseFilter)
						FileWrite($log, "12,0" & @CRLF)
						If Not IsObj($oCapture[$iPosition]) Then		Return SetError(12, 0, 0)
					EndIf

					;  Add the captureVideo filter To the filter graph
					$hr = $oGraph.AddFilter($oCapture[$iPosition], "CaptureFilter" & $iWebcam)
					FileWrite($log, "1,6" & @CRLF)
					If $hr < 0 Then	Return SetError(1, 6, 0)
					WinSetTitle($hGUI, '', $var)
				EndIf
				ExitLoop
			EndIf
		EndIf
		$oPropBag = 0
		$i += 1
	WEnd
;~ 	_ArrayDisplay($aCompressorList)
	If $iPosition = 99 And StringInStr($CLSID_category, "33d9a762") Then $aMicList[0] = $i - 1
	If $iPosition = 99 And StringInStr($CLSID_category, "860bb310") Then $aWebcamList[0] = $i - 1
	If $iPosition = '' And $arg = 99 Then
		$aCompressorList[$i] = 'Uncompressed'
		$aCompressorList[0] = $i - 1
	EndIf
	$oMoniker = 0
	$oEnum = 0
	$oDevEnum = 0
EndFunc   ;==>_WebcamDS_enumerateDevices

Func _WebcamDS_Reset()
	_WebcamDS_ReleaseObjects()
	_WebcamDS_Init()
EndFunc   ;==>_WebcamDS_Reset

Func _WebcamDS_SelectRect($hGuiWin)
	Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp

	; Get first mouse position
	$aMouse_Pos = MouseGetPos()
	Local $iX1 = $aMouse_Pos[0]
	Local $iY1 = $aMouse_Pos[1]

	; get final pos rectangle while mouse button pressed
	While _IsPressed("01", $UserDLL)
		$aMouse_Pos = MouseGetPos()
		Sleep(10)
	WEnd

	; Get final mouse position
	Local $iX2 = $aMouse_Pos[0]
	Local $iY2 = $aMouse_Pos[1]

	; Set in correct order if required
	If $iX2 < $iX1 Then
		$iTemp = $iX1
		$iX1 = $iX2
		$iX2 = $iTemp
	EndIf
	If $iY2 < $iY1 Then
		$iTemp = $iY1
		$iY1 = $iY2
		$iY2 = $iTemp
	EndIf

	Local $aGUIPos = WinGetPos($hGuiWin)
	Local $aGUISize = WinGetClientSize($hGuiWin)

	;do the math for correct offsetX-Y, width & height , also with consecutive zoom selections !! (take care of titlebar and line of buttons, too...)
	Local $sZoom
	If $iX1 <> $iX2 Then
		If $iWebRescale = 1 And $aZoomPos[0] = 1 Then
			$aZoomPos[0] = $aGUISize[0] / $iWebX
			$aZoomPos[2] = $aGUISize[1] / $iWebY
		EndIf
		$sZoom = ($iX1 - $aGUIPos[0]) / $aZoomPos[0] + $aZoomPos[1] & "," & ($iY1 - ($aGUIPos[1] + 50)) / $aZoomPos[2] + $aZoomPos[3] & "," & _
				($iX2 - $iX1) / $aZoomPos[0] & "," & ($iY2 - $iY1) / $aZoomPos[2]

		Local $aZoomPosTemp[4], $iSizeX, $iSizeY
		If $iWebRescale = 1 Then
			$iSizeX = $aGUISize[0]
			$iSizeY = $aGUISize[1]
		Else
			$iSizeX = $iWebX
			$iSizeY = $iWebY
		EndIf
		$aZoomPosTemp[0] = $iSizeX / (($iX2 - $iX1) / $aZoomPos[0]) ; new factor moltiplicativo X   (ris.Webcam / (widthRect/precedenteFattoremoltipl))
		$aZoomPosTemp[2] = $iSizeY / (($iY2 - $iY1) / $aZoomPos[2]) ; new factor moltiplicativo Y

		$aZoomPosTemp[1] = ($iX1 - $aGUIPos[0]) / $aZoomPos[0] + $aZoomPos[1] ; old X: offsetX   (posXRect-posXGUI)/fattMoltipl  + preced.offsetX)
		$aZoomPosTemp[3] = ($iY1 - ($aGUIPos[1] + 50)) / $aZoomPos[2] + $aZoomPos[3] ; old Y: offsetY
		$aZoomPos[0] = $aZoomPosTemp[0]
		$aZoomPos[1] = $aZoomPosTemp[1]
		$aZoomPos[2] = $aZoomPosTemp[2]
		$aZoomPos[3] = $aZoomPosTemp[3]
		Return $sZoom
	EndIf
EndFunc   ;==>_WebcamDS_SelectRect
