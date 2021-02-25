#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>
#include <_xVideoUDF.au3>

Global $timer, $Secs, $Mins, $Hour, $Time

$hVideoStream = 0
$PosSec = 0
$sPosSec = 0

$gui = GUICreate("xVideo Player Demo", 720, 520)
GUISetBkColor(0x000000)

$filemenu = GUICtrlCreateMenu("&File")
$fileitemOpen = GUICtrlCreateMenuItem("Open", $filemenu)
$fileitemExit = GUICtrlCreateMenuItem("Exit", $filemenu)

$BtnPlay = GUICtrlCreateButton("Play", 20, 440, 50, 25)
$BtnPause = GUICtrlCreateButton("Pause", 90, 440, 50, 25)
$BtnStop = GUICtrlCreateButton("Stop", 160, 440, 50, 25)
$BtnFull = GUICtrlCreateButton("Full", 240, 440, 50, 25)

$LblPos = GUICtrlCreateLabel("00:00:00", 400, 445, 70, 20)
GUICtrlSetFont(-1, 12)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetBkColor(-1, 0xff0000)

$LblLenght = GUICtrlCreateLabel("00:00:00", 470, 445, 70, 20)
GUICtrlSetFont(-1, 12)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetBkColor(-1, 0xff0000)

$slider = GUICtrlCreateSlider(20, 470, 680, 25)

_xVideo_UDF_Open()
_xVideo_Init(WinGetHandle($gui))
_xVideo_SetConfig("xVideo_CONFIG_VideoRenderer", "xVideo_VMR9");"xVideo_EVR")

ConsoleWrite("ver. " & _xVideo_GetVersion() & @CRLF)

GUISetState()

While 1
	Sleep(20)
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop

	If $msg = $fileitemExit Then ExitLoop

	If $msg = $fileitemOpen Then
		$file = FileOpenDialog("", "", "VIDEO (*.avi;*.mpg;*.mkv;*.m2ts)")
		ConsoleWrite("GetState =  "&_xVideo_ChannelGetState($hVideoStream) & @CRLF)
		$hVideoStream = _xVideo_StreamCreateFile($file, 0, 0)
		_xVideo_ChannelSetWindow($hVideoStream, $gui)
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
	EndIf

	If _xVideo_ChannelGetState($hVideoStream) > 0 Then
		$a = GUIGetCursorInfo()
		If IsArray($a) And $a[4] = $slider And $a[2] = 1 Then
			_xVideo_ChannelSetPosition($hVideoStream, Round(($Vlenght / 100) * GUICtrlRead($slider)), "xVideo_POS_SEC")
		EndIf

		$PosSec = _xVideo_ChannelGetPosition($hVideoStream, "xVideo_POS_SEC")
		If $sPosSec <> $PosSec Then
			GUICtrlSetData($LblPos, _time($PosSec))
			GUICtrlSetData($slider, (100 / $Vlenght) * $PosSec)
			$sPosSec = $PosSec
		EndIf
	EndIf

	If $msg = $BtnStop Then
		_xVideo_ChannelStop($hVideoStream)
		_xVideo_StreamFree($hVideoStream)
	EndIf

	If $msg = $BtnPause Then
		_xVideo_ChannelGetInfo($hVideoStream)
		_xVideo_ChannelPause($hVideoStream)
	EndIf

	If $msg = $BtnPlay Then
		_xVideo_ChannelPlay($hVideoStream)
	EndIf

	If $msg = $BtnFull Then
		_FullScreen($hVideoStream, True)
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