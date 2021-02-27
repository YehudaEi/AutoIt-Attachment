#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <WindowsConstants.au3>
; *** End added by AutoIt3Wrapper ***
#include <array.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>
#include <string.au3>
#include <_xVideoUDF.au3>

HotKeySet("{ESC}", "_ExitFullScreen")


Global $VideoRendererVMR7wr, $VideoRendererVMR9wr, $VideoRendererVMR7wlr, $VideoRendererVMR9wlr, $VideoRendererEVR, $VideoRendererNULL, $VRset = 0
Global $timer, $Secs, $Mins, $Hour, $Time
Global $fullscreen = 0

$hVideoStream = 0
$PosSec = 0
$sPosSec = 0
$file = 0

$gui = GUICreate("xVideo Player Demo", 720, 550)
;GUISetBkColor(0x000000)

$filemenu = GUICtrlCreateMenu("&File")
$fileitemOpen = GUICtrlCreateMenuItem("Open", $filemenu)
$fileitemProp = GUICtrlCreateMenuItem("Properties", $filemenu)
GUICtrlSetState($fileitemProp, $GUI_DISABLE)
$fileitemExit = GUICtrlCreateMenuItem("Exit", $filemenu)

$BtnPlay = GUICtrlCreateButton("Play", 20, 460, 50, 25)
$BtnPause = GUICtrlCreateButton("Pause", 90, 460, 50, 25)
$BtnStop = GUICtrlCreateButton("Stop", 160, 460, 50, 25)
$BtnFull = GUICtrlCreateButton("Full", 240, 460, 50, 25)

$LblPos = GUICtrlCreateLabel("00:00:00", 545, 465, 65, 20)
GUICtrlSetFont(-1, 12)
GUICtrlSetColor(-1, 0x000000)

GUICtrlCreateLabel("\", 610, 465, 5, 20)
GUICtrlSetFont(-1, 12)
GUICtrlSetColor(-1, 0x000000)
$LblLenght = GUICtrlCreateLabel("00:00:00", 615, 465, 70, 20)
GUICtrlSetFont(-1, 12)
GUICtrlSetColor(-1, 0x000000)

$slider = GUICtrlCreateSlider(20, 500, 680, 25)

$sliderVol = GUICtrlCreateSlider(350, 465, 100, 25)


$SettingsMenu = GUICtrlCreateMenu("&")
$SettingsMenu = GUICtrlCreateMenu("&Settings")
$VideoRendererMenu = GUICtrlCreateMenu("Video Renderer", $SettingsMenu, 1)
$VideoRendererVMR7wr = GUICtrlCreateMenuItem("(1) VMR7 Windowed render", $VideoRendererMenu)
$VideoRendererVMR9wr = GUICtrlCreateMenuItem("(2) VMR9 Windowed render", $VideoRendererMenu)
$VideoRendererVMR7wlr = GUICtrlCreateMenuItem("(3) VMR7 window less render", $VideoRendererMenu)
$VideoRendererVMR9wlr = GUICtrlCreateMenuItem("(4) VMR9 window less render", $VideoRendererMenu)
$VideoRendererEVR = GUICtrlCreateMenuItem("(5) Enhanced Video Renderer", $VideoRendererMenu)
$VideoRendererNULL = GUICtrlCreateMenuItem("(6) NULL Video Renderer", $VideoRendererMenu)

$AudioRendererMenu = GUICtrlCreateMenu("Audio Renderer", $SettingsMenu, 1)
$AudioRendererNull = GUICtrlCreateMenuItem("(1) NULL Audio Renderer", $AudioRendererMenu)
$AudioRendererDefault = GUICtrlCreateMenuItem("(2) Default Audio Device", $AudioRendererMenu)



$GuiVideo = GUICreate("VideoW", 720, 440, 0, 0, $WS_POPUP)
GUISetBkColor(0x000000, $GuiVideo)

$handle = WinGetHandle($GuiVideo)
DllCall("user32.dll", "int", "SetParent", "hwnd", WinGetHandle($handle), "hwnd", WinGetHandle($gui))
GUISetState(@SW_SHOW, $GuiVideo)
GUISetState(@SW_SHOW, $gui)

_xVideo_UDF_Open()
_xVideo_Init(WinGetHandle($GuiVideo))
_xVideo_SetConfig($xVideo_CONFIG_VideoRenderer, $xVideo_VMR9);"xVideo_EVR")
ConsoleWrite("ver. " & _xVideo_GetVersion() & @CRLF)
ConsoleWrite("VideoRenderer = " & _xVideo_GetConfig($xVideo_CONFIG_VideoRenderer) & @CRLF)

$VideoRenderer = _StringBetween(_xVideo_GetConfig($xVideo_CONFIG_VideoRenderer), "(", ")")
_SetVideoRenderer($VideoRenderer[0], 0)

$AudioRenderer = _StringBetween(_xVideo_GetConfig($xVideo_CONFIG_AudioRenderer), "(", ")")
_SetAudioRenderer($AudioRenderer[0], 0)

GUICtrlSetData($sliderVol, 100)

While 1
	Sleep(20)
	$msg = GUIGetMsg()
	If $msg = $VideoRendererVMR7wr Then
		_SetVideoRenderer(1, 1)
	EndIf
	If $msg = $VideoRendererVMR9wr Then
		_SetVideoRenderer(2, 1)
	EndIf
	If $msg = $VideoRendererVMR7wlr Then
		_SetVideoRenderer(3, 1)
	EndIf
	If $msg = $VideoRendererVMR9wlr Then
		_SetVideoRenderer(4, 1)
	EndIf
	If $msg = $VideoRendererEVR Then
		_SetVideoRenderer(5, 1)
	EndIf
	If $msg = $VideoRendererNULL Then
		_SetVideoRenderer(6, 1)
	EndIf

	If $msg = $AudioRendererDefault Then
		_SetAudioRenderer(0x1433, 1)
	EndIf

	If $msg = $AudioRendererNull Then
		_SetAudioRenderer(0x1432, 1)
	EndIf

	If $msg = $GUI_EVENT_CLOSE Then ExitLoop

	If $msg = $fileitemExit Then ExitLoop

	If $msg = $fileitemOpen Then
		$file = FileOpenDialog("", "", "VIDEO (*.avi;*.mpg;*.mkv;*.m2ts)")
		If $file <> "" Then
			ConsoleWrite("GetState =  " & _xVideo_ChannelGetState($hVideoStream) & @CRLF)
			If _xVideo_ChannelGetState($hVideoStream) > 0 Then
				_xVideo_ChannelStop($hVideoStream)
				_xVideo_StreamFree($hVideoStream)
			EndIf
			$hVideoStream = _xVideo_StreamCreateFile($file, 0, 0)
			_xVideo_ChannelSetWindow($hVideoStream, $GuiVideo)
			_xVideo_PlayStream($hVideoStream)

			$GetInfo = _xVideo_ChannelGetInfo($hVideoStream)
			$Width = $GetInfo[2]
			$Height = $GetInfo[1]
			$Width = 720

			If $Height > 440 Then
				$shrink = 100 / $Width * ($Width - 720)
				$Height = 440
			EndIf

			$y = (440 - $Height) / 2
			_xVideo_ChannelResizeWindow($hVideoStream, 0, $y, $Width, $Height)
			If _xVideo_ChannelGetState($hVideoStream) > 0 Then
				$Vlenght = _xVideo_ChannelGetLength($hVideoStream, "xVideo_POS_SEC")
				GUICtrlSetData($LblLenght, _time($Vlenght))
			EndIf
			GUICtrlSetData($sliderVol, _xVideo_ChannelGetAttribute($hVideoStream, $xVideo_ATTRIB_VOL))
			GUICtrlSetState($fileitemProp, $GUI_ENABLE)
			;_xVideo_ChannelGetStream($hVideoStream)
			;MsgBox(0,"", _xVideo_ChannelStreamsCount($hVideoStream))
		EndIf
	EndIf

	If _xVideo_ChannelGetState($hVideoStream) > 0 Then
		$a = GUIGetCursorInfo($gui)
		If IsArray($a) And $a[4] = $slider And $a[2] = 1 Then
			_xVideo_ChannelSetPosition($hVideoStream, Round(($Vlenght / 100) * GUICtrlRead($slider)), 0)
			ConsoleWrite(Round(($Vlenght / 100) * GUICtrlRead($slider)) & @CRLF)
		EndIf

		$PosSec = _xVideo_ChannelGetPosition($hVideoStream, 0)
		If $sPosSec <> $PosSec Then
			GUICtrlSetData($LblPos, _time($PosSec))
			GUICtrlSetData($slider, (100 / $Vlenght) * $PosSec)
			$sPosSec = $PosSec
		EndIf

		If IsArray($a) And $a[4] = $sliderVol And $a[2] = 1 Then
			_xVideo_ChannelSetAttribute($hVideoStream, $xVideo_ATTRIB_VOL, GUICtrlRead($sliderVol))
			ConsoleWrite(_xVideo_ChannelGetAttribute($hVideoStream, $xVideo_ATTRIB_VOL) & @CRLF)
		EndIf
	EndIf

	If $msg = $BtnStop Then
		_xVideo_ChannelStop($hVideoStream)
		_xVideo_StreamFree($hVideoStream)
	EndIf

	If $msg = $BtnPause Then
		;_xVideo_ChannelGetStream($hVideoStream)
		_xVideo_ChannelGetInfo($hVideoStream)
		_xVideo_ChannelPause($hVideoStream)
	EndIf

	If $msg = $BtnPlay Then
		_xVideo_ChannelPlay($hVideoStream)
	EndIf

	If $msg = $BtnFull Then
		_FullScreen($hVideoStream, True)
	EndIf

	If $msg = $fileitemProp Then
		$GetInfo = _xVideo_ChannelGetInfo($hVideoStream)
		;_ArrayDisplay($GetInfo)
		$GuiInfo = GUICreate("Properties", 240, 150, -1, -1, $GUI_SS_DEFAULT_GUI - $WS_MINIMIZEBOX, -1, $gui)
		GUICtrlCreateLabel("Duration", 10, 10, 110, 15)
		GUICtrlCreateLabel(" :  " & _time(_xVideo_ChannelGetLength($hVideoStream, "xVideo_POS_SEC")), 120, 10, 110, 15)
		GUICtrlCreateLabel("Frame rate", 10, 25, 110, 15)
		GUICtrlCreateLabel(" :  " & $GetInfo[0], 120, 25, 110, 15)
		GUICtrlCreateLabel("Width", 10, 40, 110, 15)
		GUICtrlCreateLabel(" :  " & $GetInfo[2], 120, 40, 110, 15)
		GUICtrlCreateLabel("Height", 10, 55, 110, 15)
		GUICtrlCreateLabel(" :  " & $GetInfo[1], 120, 55, 110, 15)
		GUICtrlCreateLabel("Chanels", 10, 70, 110, 15)
		GUICtrlCreateLabel(" :  " & $GetInfo[3], 120, 70, 110, 15)
		GUICtrlCreateLabel("Sampling rate", 10, 85, 110, 15)
		GUICtrlCreateLabel(" :  " & $GetInfo[4], 120, 85, 110, 15)
		GUICtrlCreateLabel("Audio Resolution", 10, 100, 110, 15)
		GUICtrlCreateLabel(" :  " & $GetInfo[5], 120, 100, 110, 15)
		GUISetState(@SW_SHOW, $GuiInfo)
		While 1
			Sleep(20)
			$msg1 = GUIGetMsg()
			If $msg1 = $GUI_EVENT_CLOSE Then ExitLoop
		WEnd
		GUIDelete($GuiInfo)
	EndIf
WEnd

_xVideo_UDF_Close()
GUIDelete($gui)

Func _time($sec)
	_TicksToTime(Int($sec * 1000), $Hour, $Mins, $Secs)
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	Return $Time
EndFunc   ;==>_time

Func _FullScreen($chan, $full)
	_xVideo_ChannelSetFullscreen($chan, $full)
EndFunc   ;==>_FullScreen

Func _ExitFullScreen()
	_xVideo_ChannelSetFullscreen($hVideoStream, False)
EndFunc


Func _SetVideoRenderer($vRenderer, $SetVr)
	GUICtrlSetState($VideoRendererVMR7wr, $GUI_UNCHECKED)
	GUICtrlSetState($VideoRendererVMR9wr, $GUI_UNCHECKED)
	GUICtrlSetState($VideoRendererVMR7wlr, $GUI_UNCHECKED)
	GUICtrlSetState($VideoRendererVMR9wlr, $GUI_UNCHECKED)
	GUICtrlSetState($VideoRendererEVR, $GUI_UNCHECKED)
	GUICtrlSetState($VideoRendererNULL, $GUI_UNCHECKED)

	If $vRenderer = 1 Then GUICtrlSetState($VideoRendererVMR7wr, $GUI_CHECKED)
	If $vRenderer = 2 Then GUICtrlSetState($VideoRendererVMR9wr, $GUI_CHECKED)
	If $vRenderer = 3 Then GUICtrlSetState($VideoRendererVMR7wlr, $GUI_CHECKED)
	If $vRenderer = 4 Then GUICtrlSetState($VideoRendererVMR9wlr, $GUI_CHECKED)
	If $vRenderer = 5 Then GUICtrlSetState($VideoRendererEVR, $GUI_CHECKED)
	If $vRenderer = 6 Then GUICtrlSetState($VideoRendererNULL, $GUI_CHECKED)

	If $SetVr = 1 Then
		If _xVideo_ChannelGetState($hVideoStream) > 0 Then
			$PosSecSave = _xVideo_ChannelGetPosition($hVideoStream, "xVideo_POS_SEC")
			_xVideo_ChannelStop($hVideoStream)
			_xVideo_StreamFree($hVideoStream)

			_xVideo_SetConfig($xVideo_CONFIG_VideoRenderer, $vRenderer)
			ConsoleWrite(_xVideo_GetConfig($xVideo_CONFIG_VideoRenderer) & @CRLF)
			$hVideoStream = _xVideo_StreamCreateFile($file, 0, 0)
			_xVideo_PlayStream($hVideoStream)
			_xVideo_ChannelSetPosition($hVideoStream, $PosSecSave, "xVideo_POS_SEC")
			$GetInfo = _xVideo_ChannelGetInfo($hVideoStream)
			$Width = $GetInfo[2]
			$Height = $GetInfo[1]
			$Width = 720

			If $Height > 440 Then
				$shrink = 100 / $Width * ($Width - 720)
				$Height = 440
			EndIf

			$y = (440 - $Height) / 2
			_xVideo_ChannelResizeWindow($hVideoStream, 0, $y, $Width, $Height)
			If _xVideo_ChannelGetState($hVideoStream) > 0 Then
				$Vlenght = _xVideo_ChannelGetLength($hVideoStream, "xVideo_POS_SEC")
				GUICtrlSetData($LblLenght, _time($Vlenght))
			EndIf
		EndIf

		WinActivate($gui)
		GUICtrlSetState($slider, $GUI_ENABLE)
	EndIf

	$VRset = $vRenderer
EndFunc   ;==>_SetVideoRenderer

Func _SetAudioRenderer($aRenderer, $SetAr)
	GUICtrlSetState($AudioRendererNull, $GUI_UNCHECKED)
	GUICtrlSetState($AudioRendererDefault, $GUI_UNCHECKED)

	If $aRenderer = 0x1432 Then GUICtrlSetState($AudioRendererNull, $GUI_CHECKED)
	If $aRenderer = 0x1433 Then GUICtrlSetState($AudioRendererDefault, $GUI_CHECKED)

	If $SetAr = 1 Then

		If _xVideo_ChannelGetState($hVideoStream) > 0 Then
			$PosSecSave = _xVideo_ChannelGetPosition($hVideoStream, "xVideo_POS_SEC")
			_xVideo_ChannelStop($hVideoStream)
			_xVideo_StreamFree($hVideoStream)

			_xVideo_SetConfig($xVideo_CONFIG_AudioRenderer, $aRenderer)
			ConsoleWrite(_xVideo_GetConfig($xVideo_CONFIG_AudioRenderer) & @CRLF)
			$hVideoStream = _xVideo_StreamCreateFile($file, 0, 0)
			_xVideo_PlayStream($hVideoStream)
			_xVideo_ChannelSetPosition($hVideoStream, $PosSecSave, "xVideo_POS_SEC")
			$GetInfo = _xVideo_ChannelGetInfo($hVideoStream)
			$Width = $GetInfo[2]
			$Height = $GetInfo[1]
			$Width = 720

			If $Height > 440 Then
				$shrink = 100 / $Width * ($Width - 720)
				$Height = 440
			EndIf

			$y = (440 - $Height) / 2
			_xVideo_ChannelResizeWindow($hVideoStream, 0, $y, $Width, $Height)
			If _xVideo_ChannelGetState($hVideoStream) > 0 Then
				$Vlenght = _xVideo_ChannelGetLength($hVideoStream, "xVideo_POS_SEC")
				GUICtrlSetData($LblLenght, _time($Vlenght))
			EndIf
		EndIf

		WinActivate($gui)
		GUICtrlSetState($slider, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_SetAudioRenderer