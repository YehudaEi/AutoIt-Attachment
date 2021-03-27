#NoTrayIcon
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
Opt("GUICloseOnEsc", 0)

Global Const $VK_NUMLOCK = 0x90
Global Const $VK_SCROLL = 0x91
Global Const $VK_CAPITAL = 0x14
Global $hMain, $hState, $hMainContext, $mExit, $mTrans, $mTopMost
Global $Global_Trans, $TopMost


main()

Func main()
	Local $nMsg, $PosX = Number(IniRead("config.dat", "set", "x", "-1")), $PosY = Number(IniRead("config.dat", "set", "y", "-1"))
	If $PosX > @DesktopWidth Then $PosX = -1
	If $PosY > @DesktopHeight Then $PosY = -1

	$Global_Trans = Number(IniRead("config.dat", "set", "trans", "255"))
	$TopMost = Number(IniRead("config.dat", "set", "top", "1"))
	$hMain = GUICreate("KeyState Indicator", 144, 48, $PosX, $PosY, $WS_POPUP, $WS_EX_TOOLWINDOW)
;~ 	$hMain = GUICreate("KeyState Indicator", 144, 48, $PosX, $PosY, $WS_POPUP)
	$hState = GUICtrlCreatePic(@ScriptDir & "\0-1.jpg", 0, 0, 144, 48, -1, $GUI_WS_EX_PARENTDRAG)
	$hMainContext = GUICtrlCreateContextMenu($hState)
	$mTopMost = GUICtrlCreateMenuItem("Always On TopMost", $hMainContext, -1)
	$mTrans = GUICtrlCreateMenuItem("Set transparency", $hMainContext)
	GUICtrlCreateMenuItem("", $hMainContext)
	$mExit = GUICtrlCreateMenuItem("Exit", $hMainContext)
	AdlibRegister(toggleKeys, 100)
	OnAutoItExitRegister(_RegisterPostion)
	GUISetState(@SW_SHOW, $hMain)
	WinSetTrans($hMain, "", $Global_Trans)
	If $TopMost > 0 Then
		WinSetOnTop($hMain, "", $TopMost)
		GUICtrlSetState($mTopMost, $GUI_CHECKED)
	EndIf


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $mExit, $GUI_EVENT_CLOSE
				Exit
			Case $mTopMost
				If BitAND(GUICtrlRead($mTopMost), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($mTopMost, $GUI_UNCHECKED)
					$TopMost = 0
				Else
					GUICtrlSetState($mTopMost, $GUI_CHECKED)
					$TopMost = 1
				EndIf
				WinSetOnTop($hMain, "", $TopMost)
				IniWrite("config.dat", "set", "top", $TopMost)
			Case $mTrans
				$Global_Trans = _SetTrans($Global_Trans)
				IniWrite("config.dat", "set", "trans", $Global_Trans)
				WinSetTrans($hMain, "", $Global_Trans)
		EndSwitch
	WEnd
EndFunc   ;==>main

Func _RegisterPostion()
	Local $pos = WinGetPos($hMain)
	ConsoleWrite("x:" & $pos[0])
	IniWrite("config.dat", "set", "x", $pos[0])
	IniWrite("config.dat", "set", "y", $pos[1])
EndFunc   ;==>_RegisterPostion
Func _SetTrans($val)
	GUISetState(@SW_DISABLE, $hMain)
	Local $hTrans = GUICreate("Set Transparency", 408, 69, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hMain)
	Local $Slider = GUICtrlCreateSlider(0, 0, 406, 45)
	GUICtrlSetLimit(-1, 255, 100)
	GUICtrlSetData(-1, $val)
	Local $level = GUICtrlCreateLabel("Transparency Level: " & $val, 2, 48, 200, 17)
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_ENABLE, $hMain)
				GUIDelete($hTrans)
				Return $val
			Case $Slider
				$val = Number(GUICtrlRead($Slider))
				GUICtrlSetData($level, "Transparency Level: " & $val)
		EndSwitch
	WEnd
EndFunc   ;==>_SetTrans

Func toggleKeys()
	$keystate = 0
	If GetNumLock() <> 0 Then
		$keystate = $keystate + 1
	EndIf

	If GetScrollLock() <> 0 Then
		$keystate = $keystate + 2
	EndIf

	If GetCapsLock() <> 0 Then
		$keystate = $keystate + 4
	EndIf

	Select
		Case $keystate = 1
			GUICtrlSetImage($hState, @ScriptDir & "\1-1.jpg")
		Case $keystate = 2
			GUICtrlSetImage($hState, @ScriptDir & "\2-1.jpg")
		Case $keystate = 3
			GUICtrlSetImage($hState, @ScriptDir & "\3-1.jpg")
		Case $keystate = 4
			GUICtrlSetImage($hState, @ScriptDir & "\4-1.jpg")
		Case $keystate = 5
			GUICtrlSetImage($hState, @ScriptDir & "\5-1.jpg")
		Case $keystate = 6
			GUICtrlSetImage($hState, @ScriptDir & "\6-1.jpg")
		Case $keystate = 7
			GUICtrlSetImage($hState, @ScriptDir & "\7-1.jpg")
		Case Else
			GUICtrlSetImage($hState, @ScriptDir & "\0-1.jpg")
	EndSelect

EndFunc   ;==>toggleKeys

;Code from gafrost ==> http://www.autoitscript.com/forum/index.php?showtopic=12056
Func GetNumLock()
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_NUMLOCK)
	Return $ret[0]
EndFunc   ;==>GetNumLock

Func GetScrollLock()
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_SCROLL)
	Return $ret[0]
EndFunc   ;==>GetScrollLock

Func GetCapsLock()
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_CAPITAL)
	Return $ret[0]
EndFunc   ;==>GetCapsLock

