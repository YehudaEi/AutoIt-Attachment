#include "AVIWriter Extented.au3"
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <WindowsConstants.au3>

_GDIPlus_Startup()

Global Const $sFile = @ScriptDir & "\test.avi"
FileDelete($sFile)

Global $rec_duration = 5 ;5 seconds
Global $fps = 5

Global Const $dll = DllOpen("user32.dll")
Global $hGUI_Grab2AVI = GUICreate("", 0, 0, 0, 0, $WS_POPUP, $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW, WinGetHandle(AutoItWinGetTitle()))
GUISetBkColor(0xFF0000, $hGUI_Grab2AVI)
GUISetState(@SW_SHOW, $hGUI_Grab2AVI)
Global $aMPos, $hWin, $hWinAncestor, $hWnd, $aRet_prev, $aPos
Global Const $frame_size = 3
Global $tPoint = DllStructCreate($tagPOINT)
Global $esc = True
Global $mxo, $myo

While Not _IsPressed("1B", $dll) * Sleep(30)
	$aMPos = MouseGetPos()
	DllStructSetData($tPoint, 1, $aMPos[0])
	DllStructSetData($tPoint, 2, $aMPos[1])
	$hWin = _WinAPI_WindowFromPoint($tPoint)
	$hWinAncestor = _WinAPI_GetAncestor($hWin, 2)
	$hWnd = HWnd($hWinAncestor)
	$aRet_prev = -1
	$aPos  = WinGetPos($hWnd)
	If $hWnd <> $hGUI_Grab2AVI And $hWnd <> $aRet_prev Then
		$aRet_prev = $hWnd
		If $aMPos[0] <> $mxo Or $aMPos[1] <> $myo Then
			WinMove($hGUI_Grab2AVI, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], 1)
			_GuiHole($hGUI_Grab2AVI, $frame_size, $frame_size, $aPos[2] - 2 * $frame_size, $aPos[3] - 2 * $frame_size, $aPos[2], $aPos[3])
			WinSetOnTop($hGUI_Grab2AVI, 0, 1)
			ToolTip("Press CTRL to start capturing of" & @LF & "marked window to a AVI file!" & @LF & @LF & _
						 "Duration: " & $rec_duration & " seconds @ " & $fps & " fps" & @LF & _
						  "Windows Size: " & $aPos[2] & " x " & $aPos[3], $aMPos[0] + 20, $aMPos[1] + 20)
			$mxo = $aMPos[0]
			$myo = $aMPos[1]
		EndIf
	EndIf
	If _IsPressed("11", $dll) Then
		$esc = False
		ExitLoop
	EndIf
WEnd
ToolTip("")
GUIDelete($hGUI_Grab2AVI)
If $esc Then Exit MsgBox(0, "Information", "Aborted", 10)

_StartAviLibrary()
Global $aAVI = _CreateAvi($sFile, $fps, $aPos[2], $aPos[3])
If @error Then close()

Global $hBmp

Global $fSleep = 1000 / $fps, $t, $td
Global $total_FPS = $rec_duration * $fps, $fps_c = 1
$k32_dll = DllOpen("kernel32.dll")

Do
	$fTimer = TimerInit()

    $hBmp = _ScreenCapture_CaptureWnd("", $hWnd)
    _AddHBitmapToAvi($aAVI, $hBmp)
    _WinAPI_DeleteObject($hBmp)

	$fps_c += 1
	$td = $fSleep - TimerDiff($fTimer)
	If $td > 0 Then
		DllCall($k32_dll, "none", "Sleep", "dword", $td)
	EndIf

	If $fps_c > $total_FPS Then
		Close()
	EndIf

Until False

Func Close()
	DllClose($dll)
    _GDIPlus_Shutdown()
    _CloseAvi($aAVI)
    _StopAviLibrary()
    ConsoleWrite("AVI filesize: " & Round(FileGetSize($sFile) / 1024 ^ 2, 2) & " MB" & @CRLF)
    Exit MsgBox(0, "Information", "Done!", 15)
EndFunc   ;==>close

Func _GuiHole($hWnd, $i_x, $i_y, $i_sizew, $i_sizeh, $width, $height)
	Local $outer_rgn, $inner_rgn, $combined_rgn
	$outer_rgn = _WinAPI_CreateRectRgn(0, 0, $width, $height)
	$inner_rgn = _WinAPI_CreateRectRgn($i_x, $i_y, $i_x + $i_sizew, $i_y + $i_sizeh)
	$combined_rgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)
	_WinAPI_CombineRgn($combined_rgn, $outer_rgn, $inner_rgn, $RGN_DIFF)
	_WinAPI_DeleteObject($outer_rgn)
	_WinAPI_DeleteObject($inner_rgn)
	_WinAPI_SetWindowRgn($hWnd, $combined_rgn)
EndFunc   ;==>_GuiHole