#include <GUIConstantsEx.au3>
#include <SendMessage.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>

HotKeySet("{ESC}", "_EXIT")

If Not FileExists(@DesktopDir & "\WeatherTray") Then
	DirCreate(@DesktopDir & "\WeatherTray")
	For $x = 0 To 48
		InetGet("http://image.weather.com/web/common/wxicons/52/" & $x & ".gif?12122006", @DesktopDir & "\WeatherTray\Pic" & $x & ".gif")
	Next
EndIf

_GDIPlus_Startup()
$Image = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Test.png")
$Image_Height = _GDIPlus_ImageGetHeight($Image) ;220
$Image_Width = _GDIPlus_ImageGetWidth($Image) ;140

$GUI = GUICreate("Test", $Image_Width, $Image_Height, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
GUISetState()
SetBitmap($GUI, $Image, 145)

$GUI2 = GUICreate("Test2", $Image_Width, $Image_Height, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $GUI)
GUICtrlCreatePic(@DesktopDir & "\WeatherTray\Pic3.gif", 16, 48, 52, 52)
GUISetControlsVisible($GUI2)
GUISetState()

While 1
	$Msg = GUIGetMsg(1)
	If $Msg[0] = $GUI_EVENT_PRIMARYDOWN Then
		If $Msg[1] = $GUI Then _SendMessage($GUI, $WM_SYSCOMMAND, 0xF012, 0) ;SC_DRAGMOVE
	EndIf
WEnd

Func _exit()
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit

Func GUISetControlsVisible($hWnd)
	Local $aM_Mask, $aCtrlPos, $aMask

	$aM_Mask = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)
	$aLastID = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))

	For $i = 3 To $aLastID[0]
		$aCtrlPos = ControlGetPos($hWnd, '', $i)
		If Not IsArray($aCtrlPos) Then ContinueLoop

		$aMask = DllCall("gdi32.dll", "long", "CreateRectRgn", _
				"long", $aCtrlPos[0], _
				"long", $aCtrlPos[1], _
				"long", $aCtrlPos[0] + $aCtrlPos[2], _
				"long", $aCtrlPos[1] + $aCtrlPos[3])
		DllCall("gdi32.dll", "long", "CombineRgn", "long", $aM_Mask[0], "long", $aMask[0], "long", $aM_Mask[0], "int", 2)
	Next
	DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $hWnd, "long", $aM_Mask[0], "int", 1)
EndFunc   ;==>GUISetControlsVisible

Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $AC_SRC_ALPHA = 1
	Local $ULW_ALPHA = 2
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap