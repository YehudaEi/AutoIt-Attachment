#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
Global Const $iW = 300, $iH = 280
Global $aAnim[10], $i
For $i = 1 To 9
	$aAnim[$i] = Call("_PixelCoordinates" & $i) ;create an array with arrays as values
Next
Global $hGUI = GUICreate("Test", $iW, $iH)
GUISetBkColor(0x003388)
Global $iBtnX = GUICtrlCreateButton("", 0, 0, 300, 280)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor (-1, 0)
GUICtrlSetTip(-1, "Click exit")
GUISetState()
GUIRegisterMsg($WM_TIMER, "PlayAnim") ;$WM_TIMER = 0x0113
DllCall("User32.dll", "int", "SetTimer", "hwnd", $hGUI, "int", 0, "int", 100, "int", 0)
Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $iBtnX
			GUIRegisterMsg($WM_TIMER, "")
			GUIDelete()
			Exit
	EndSwitch
Until False
Func PlayAnim()
$a3Array =_PixelCoordinates1()
$aSize = StringSplit($a3Array[0], ",", 2)
	Local Static $f = 1
  Local Static $fi = -50
	_WinAPI_DeleteObject(_WinAPI_GuiImageHole($hGUI, $aAnim[$f], $fi, $fi,$aSize[0], $aSize[1]))
	$f += 1
$fi += 1
	If $f > 9 Then $f = 1
  If $fi > 280 Then $fi = -50
EndFunc
Func _WinAPI_GuiImageHole($hWnd, $aPixelArray, $iX, $iY, $iWidth, $iHeight, $fScale = 1, $bCorrection = True)
Local $size = WinGetPos(HWnd($hWnd))
Local $iHwndWidth = $size[2]
Local $iHwndHeight = $size[3]
If $bCorrection Then
  $iX += _WinAPI_GetSystemMetrics($SM_CXDLGFRAME)
  $iY += _WinAPI_GetSystemMetrics(8) + _WinAPI_GetSystemMetrics($SM_CYSIZE) + 1
EndIf
Local $aM_Mask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', 0, 'long', 0), $aMask
$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', $iX, 'long', $iHwndHeight)
DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', $iHwndWidth, 'long', $iY)
DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', $iX + $iWidth, 'long', 0, 'long', $iHwndWidth, 'long', $iHwndHeight)
DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', $iY + $iHeight, 'long', $iHwndWidth, 'long', $iHwndHeight)
DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
Local $i, $aBlock, $aRet, $hDLL = DllOpen('gdi32.dll')
For $i = 1 To UBound($aPixelArray) - 1
  $aBlock = StringSplit($aPixelArray[$i], ',', 2)
  $aRet = DllCall($hDLL, 'long', 'CreateRectRgn', 'long', $iX + $aBlock[0] * $fScale, 'long', $iY + $aBlock[1] * $fScale, 'long', $iX + $aBlock[2] * $fScale, 'long', $iY + $aBlock[3] * $fScale)
  DllCall($hDLL, 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aRet[0], 'long', $aM_Mask[0], 'int', 2)
  _WinAPI_DeleteObject($aRet[0])
Next
DllClose($hDLL)
DllCall('user32.dll', 'long', 'SetWindowRgn', 'hwnd', $hWnd, 'long', $aM_Mask[0], 'int', 1)
Return $aM_Mask[0]
EndFunc   ;==>_WinAPI_GuiImageHole
Func _PixelCoordinates0()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,6;0,32,31,60;0,6,36,29;36,6,44,8;44,6,48,7;60,30,100,100;71,6,100,30;66,6,71,10;62,6,66,7;49,7,63,12;65,7,66,8;36,8,40,10;40,10,43,16;41,8,42,10;40,8,41,9;44,8,49,13;63,9,65,15;63,8,64,9;43,9,44,13;42,9,43,10;36,10,39,13;65,11,67,15;65,10,66,11;68,10,71,13;67,10,68,11;50,12,53,19;48,13,50,14;49,12,50,13;53,12,55,13;61,12,63,16;60,12,61,13;67,12,68,15;36,13,38,14;38,14,40,16;39,13,40,14;53,16,59,18;54,14,56,15;55,13,56,14;70,13,71,15;69,13,70,14;36,14,37,15;43,14,44,17;37,15,38,16;45,15,48,17;44,15,45,16;53,15,54,16;55,15,58,16;59,15,61,16;68,15,69,17;38,17,40,21;38,16,39,17;48,18,50,20;49,16,50,18;62,16,67,17;69,17,71,19;69,16,70,17;40,17,43,18;45,17,47,18;59,17,63,18;65,19,69,22;67,17,68,19;66,17,67,18;40,18,41,19;43,18,46,20;42,18,43,19;53,18,54,19;55,18,59,20;59,18,61,19;63,18,65,19;36,21,38,28;36,19,37,21;50,19,51,21;62,19,64,20;69,19,70,21;45,22,48,23;46,20,48,22;44,20,46,21;51,20,55,21;59,20,63,21;39,25,41,33;39,21,40,25;48,21,49,22;56,21,60,22;63,23,66,26;64,21,65,23;68,24,71,30;69,22,71,24;70,21,71,22;43,22,44,23;49,22,51,24;52,22,55,24;55,22,56,23;61,22,63,23;66,22,68,24;65,22,66,23;45,23,47,24;58,23,61,25;57,24,58,26;61,25,63,28;62,24,63,25;66,24,67,25;54,25,55,32;53,25,54,28;55,25,56,27;58,25,59,26;66,26,68,30;67,25,68,26;44,26,45,27;47,26,48,28;46,26,47,27;49,26,52,28;56,26,57,27;59,26,61,29;63,26,65,27;41,28,44,34;41,27,42,28;57,27,59,30;63,27,64,28;64,28,66,30;65,27,66,28;36,28,37,29;55,28,57,31;61,28,62,29;0,29,28,32;28,29,29,30;49,29,50,39;44,29,49,34;50,29,54,33;59,29,60,30;62,29,64,30;57,30,58,31;28,31,29,32;33,31,38,32;55,31,56,32;58,31,60,45;31,36,45,51;37,33,39,36;36,32,38,33;56,32,58,37;31,33,33,36;40,33,41,34;55,33,56,34;33,34,34,36;39,34,40,36;50,36,53,43;50,34,52,36;34,35,35,36;40,35,49,36;45,36,49,37;45,37,47,38;48,37,49,38;57,37,58,40;45,38,46,39;45,44,50,57;45,41,47,44;45,40,46,41;49,40,50,42;52,43,54,45;53,41,54,43;55,41,56,44;47,42,48,44;48,43,49,44;51,43,52,44;55,45,57,47;56,44,57,45;50,46,52,56;50,45,51,46;"
  $sPixelRect &= "59,45,60,50;52,47,53,52;57,47,58,49;56,47,57,48;54,52,60,72;54,51,58,52;55,50,56,51;38,51,45,54;35,51,38,53;33,51,35,52;59,51,60,52;0,62,50,100;34,55,37,62;33,54,35,55;42,54,45,56;40,54,42,55;33,55,34,57;31,56,32,59;37,57,42,62;37,56,39,57;49,57,51,59;50,56,51,57;52,60,54,62;53,56,54,60;47,57,49,58;42,59,46,62;42,58,44,59;0,60,30,62;46,60,47,62;47,61,49,62;50,66,52,80;50,62,51,66;53,62,54,66;52,71,53,74;56,72,60,87;54,76,56,86;55,72,56,76;50,80,51,84;53,82,54,86;50,89,60,100;57,87,60,89;50,88,52,89"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates1()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,7;0,35,32,61;0,7,34,31;34,7,43,9;43,7,46,8;61,30,100,100;71,7,100,30;66,7,71,11;64,7,66,9;63,7,64,8;47,8,63,13;34,9,39,12;39,9,41,10;43,9,47,14;63,10,65,16;63,9,64,10;65,9,66,10;40,11,43,16;41,10,43,11;65,12,67,16;65,11,66,12;68,11,71,14;67,11,68,13;34,12,38,14;38,14,40,17;39,12,40,14;49,16,53,20;48,13,53,15;47,13,48,14;53,13,54,14;59,15,62,17;61,13,63,15;60,13,61,14;34,20,37,30;34,14,36,20;36,14,37,15;54,14,56,15;70,14,71,16;69,14,70,15;41,16,48,17;43,15,44,16;50,15,52,16;62,15,63,16;67,15,68,17;37,16,38,19;54,16,57,19;53,16,54,18;65,16,66,19;68,17,70,21;68,16,69,17;38,18,40,33;38,17,39,18;40,17,41,19;44,17,46,19;46,17,47,18;47,19,49,20;48,17,49,19;57,17,59,20;61,17,64,18;65,20,67,25;66,17,67,20;42,18,44,21;41,18,42,19;59,18,62,19;44,19,45,22;55,19,57,21;59,19,60,20;62,19,64,21;45,20,46,22;48,20,51,21;50,21,54,22;53,20,54,21;57,20,58,23;61,20,62,22;43,21,44,22;46,21,48,22;58,21,60,22;63,23,65,27;64,21,65,23;67,21,69,22;68,24,71,30;69,22,71,24;70,21,71,22;41,22,42,23;45,23,47,25;46,22,47,23;56,22,57,23;58,22,59,23;62,22,63,23;67,22,68,24;43,23,44,24;48,23,50,24;51,23,55,24;61,23,62,24;52,24,53,25;57,24,60,26;61,25,63,29;62,24,63,25;54,25,56,28;65,25,66,26;66,26,68,30;67,25,68,26;52,26,54,28;57,26,59,27;59,27,61,30;60,26,61,27;42,27,43,28;44,27,45,28;46,27,51,28;63,27,64,28;64,28,66,30;65,27,66,28;40,28,42,35;47,28,48,29;49,28,51,29;43,30,55,33;52,28,53,30;56,28,59,31;42,29,46,30;53,29,56,30;63,29,64,30;55,30,56,32;0,31,29,35;29,31,31,32;34,32,37,33;36,31,37,32;42,31,43,35;56,31,57,32;58,32,61,41;59,31,61,32;56,33,58,37;57,32,58,33;29,33,30,35;39,33,40,34;43,33,53,34;55,33,56,35;30,34,31,35;32,36,46,54;38,34,39,36;43,34,48,35;32,35,33,36;39,35,40,36;48,35,50,39;52,36,54,43;52,35,53,36;46,36,48,38;57,37,58,39;46,38,47,39;49,39,51,41;50,38,51,39;54,39,56,44;54,38,55,39;46,43,50,58;46,41,47,43;56,41,57,45;60,41,61,46;59,41,60,43;47,42,49,43;57,43,58,45;52,48,61,65;52,45,53,48;53,46,55,48;55,47,57,48;42,54,46,56;38,54,42,55;0,66,50,100;34,57,41,66;"
  $sPixelRect &= "34,56,37,57;45,56,46,58;44,56,45,57;41,60,45,66;41,58,43,60;48,58,50,60;47,58,48,59;43,59,44,60;51,59,52,63;49,60,50,61;0,61,31,66;45,62,48,66;45,61,46,62;48,63,49,66;31,64,32,66;49,64,50,66;32,65,33,66;55,80,61,88;55,65,61,74;54,65,55,71;53,65,54,68;50,71,53,80;50,66,51,71;51,69,52,71;53,73,54,79;56,74,61,80;50,80,52,82;53,82,55,87;54,81,55,82;50,82,51,83;52,84,53,87;54,87,55,88;50,90,61,100;57,88,61,90;50,89,54,90;56,89,57,90"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates2()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,10;0,43,35,77;0,10,33,39;33,10,41,12;41,10,47,11;63,29,100,100;68,10,100,29;63,10,68,14;61,10,63,12;60,10,61,11;50,11,60,16;33,12,37,14;37,12,39,13;46,12,49,23;39,13,46,18;42,12,46,13;49,12,50,18;60,13,62,18;60,12,61,13;62,12,63,13;33,14,35,18;35,14,36,15;36,15,39,20;37,14,39,15;62,14,63,18;65,14,68,17;64,14,65,16;50,16,51,17;58,16,60,19;57,16,58,17;63,16,64,18;51,17,53,18;67,17,68,19;66,17,67,18;33,18,34,19;34,19,36,24;35,18,36,19;39,18,40,21;49,20,56,22;51,18,52,20;50,18,51,19;56,18,58,20;55,18,56,19;64,18,65,19;41,19,44,22;40,19,41,21;49,19,50,20;52,19,54,20;60,19,63,20;65,19,67,23;36,20,37,21;45,20,46,24;44,20,45,21;58,20,60,21;62,23,65,26;63,20,64,23;62,20,63,21;37,21,39,23;56,21,59,22;36,22,37,37;40,22,42,25;39,22,40,24;42,22,43,23;49,22,50,23;54,22,55,26;52,22,54,24;55,22,57,23;59,22,61,23;62,22,63,23;44,23,45,24;46,23,48,26;48,24,52,25;50,23,51,24;58,23,60,24;65,23,66,24;66,25,68,29;67,23,68,25;33,27,35,39;33,24,34,27;35,24,36,27;43,24,44,28;41,25,43,26;42,24,43,25;55,24,57,25;60,26,63,29;61,24,62,26;44,25,46,26;53,25,54,26;55,25,56,26;59,25,60,26;38,26,39,27;40,26,41,28;49,26,51,28;51,26,52,27;58,26,59,27;63,26,64,28;65,26,66,29;42,27,43,28;45,27,48,28;55,27,57,29;57,27,58,28;58,28,60,32;59,27,60,28;50,29,53,31;52,28,53,29;54,28,55,30;64,28,65,29;55,29,56,30;56,30,58,33;57,29,58,30;60,29,62,30;37,32,40,38;37,30,38,32;46,30,49,32;53,30,54,31;60,30,61,31;58,34,63,44;60,32,63,34;62,30,63,32;40,31,41,32;42,31,43,32;44,31,45,32;41,33,55,35;51,31,52,33;50,31,51,32;54,31,56,33;52,32,54,33;40,33,41,34;55,33,57,34;59,33,60,34;55,35,58,40;57,34,58,35;40,35,48,38;48,35,51,37;51,35,53,36;53,36,55,38;38,38,44,39;50,40,53,60;50,38,51,40;54,38,55,39;0,39,31,43;31,39,32,40;35,45,48,65;42,39,48,45;51,39,52,40;39,40,42,42;36,40,38,42;38,40,39,41;57,40,58,42;56,40,57,41;31,41,32,43;35,41,36,42;53,42,55,48;53,41,54,42;32,42,33,43;40,42,42,45;35,44,36,45;55,45,57,48;55,44,56,45;60,44,63,46;59,44,60,45;57,46,58,48;62,46,63,49;61,46,62,47;58,47,59,48;"
  $sPixelRect &= "56,48,57,49;58,50,63,77;53,51,58,69;51,60,53,66;48,61,49,64;35,65,42,69;42,65,45,67;45,65,46,66;42,72,52,85;47,68,51,72;48,67,50,68;49,66,50,67;52,66,53,68;42,67,44,68;35,69,40,71;40,69,41,70;44,70,47,72;46,69,47,70;51,69,52,72;55,69,58,72;54,69,55,71;35,71,38,73;38,71,39,72;43,71,44,72;52,74,55,83;52,71,53,74;56,72,58,74;35,73,37,74;38,76,42,81;40,74,42,76;41,73,42,74;53,73,54,74;35,74,36,75;57,74,58,75;39,75,40,76;55,78,57,82;55,76,56,78;0,77,34,100;37,77,38,80;56,84,63,100;60,77,63,84;59,77,60,79;57,79,58,81;34,83,38,100;34,80,35,83;35,81,36,83;40,81,42,83;39,81,40,82;36,82,37,83;57,83,60,84;59,82,60,83;41,83,42,84;52,83,54,84;38,84,39,89;44,90,54,100;44,85,51,89;43,85,44,87;42,85,43,86;54,86,56,89;55,85,56,86;39,86,40,89;53,86,54,87;40,87,41,89;51,87,52,90;41,88,42,89;45,89,51,90;52,89,53,90;55,89,56,91;38,91,44,100;38,90,39,91;54,92,56,100;54,91,55,92"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates3()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,15;0,43,33,100;0,15,29,43;29,15,39,17;39,15,44,16;69,15,100,65;60,15,69,20;58,15,60,17;56,15,58,16;45,16,56,21;29,17,34,19;34,17,36,18;39,17,45,23;56,18,58,23;56,17,57,18;59,17,60,19;34,19,39,23;36,18,39,19;29,19,32,21;32,19,33,20;58,20,60,23;58,19,59,20;32,21,34,26;33,20,34,21;59,35,69,47;64,20,69,35;62,20,64,22;61,20,62,21;29,21,31,24;45,21,47,22;54,21,56,24;53,21,54,22;45,22,46,23;47,22,49,23;60,22,61,23;63,22,64,23;35,25,41,27;34,23,36,25;42,25,47,28;43,23,45,25;42,23,43,24;47,24,51,27;46,23,48,24;51,23,54,24;58,23,59,25;61,23,63,28;29,24,30,25;31,24,32,31;45,24,46,25;55,24,57,25;59,24,60,26;34,25,35,26;51,25,54,27;54,25,56,26;60,25,61,26;63,25,64,26;30,26,31,27;56,26,58,27;32,27,36,28;37,27,39,31;39,27,40,28;41,28,44,30;41,27,42,28;50,27,51,31;48,27,50,29;51,27,53,28;55,27,57,28;58,27,61,32;30,28,31,29;32,28,34,30;36,28,37,30;35,28,36,29;55,28,56,29;61,28,62,30;62,30,64,35;63,28,64,30;29,34,32,43;29,29,30,34;39,29,40,31;44,29,48,30;51,29,53,30;32,32,34,36;32,30,33,32;40,30,42,31;43,30,45,31;51,30,52,31;55,30,56,31;56,31,58,35;57,30,58,31;30,31,31,34;45,31,48,33;48,31,49,32;51,32,54,34;53,31,54,32;35,32,38,33;39,32,41,33;42,32,44,33;58,32,60,33;60,33,62,35;61,32,62,33;39,33,40,34;46,34,50,36;49,33,50,34;54,34,56,37;55,33,56,34;58,33,59,35;51,34,52,35;43,35,46,37;52,35,54,38;56,35,57,36;33,38,45,43;33,36,35,38;38,36,39,37;41,36,42,38;40,36,41,37;46,36,48,37;48,37,52,40;50,36,52,37;56,37,59,43;58,36,59,37;54,37,55,38;45,38,48,42;52,38,53,39;54,39,56,41;55,38,56,39;48,40,50,41;48,44,55,58;50,41,52,44;55,41,56,42;47,43,50,44;49,42,50,43;52,42,53,44;34,43,42,44;53,43,54,44;58,43,59,45;57,43,58,44;33,44,34,46;33,54,45,68;38,45,45,50;42,44,45,45;47,44,48,53;36,46,38,48;37,45,38,46;55,46,57,51;55,45,56,46;57,47,58,51;60,51,69,63;61,47,69,51;60,47,61,48;33,49,35,54;33,48,34,49;37,48,38,49;58,49,59,50;35,51,37,54;35,50,36,51;39,50,40,51;43,50,45,54;37,52,38,54;55,54,60,63;58,53,60,54;59,52,60,53;38,53,39,54;42,53,43,54;45,55,46,67;50,58,55,63;"
  $sPixelRect &= "49,58,50,62;46,61,47,66;66,63,69,64;47,64,48,65;42,78,63,100;51,65,62,74;62,65,66,70;66,66,68,69;66,65,67,66;71,68,100,100;73,65,100,68;46,69,51,78;49,66,51,69;68,66,69,68;47,68,49,69;48,67,49,68;72,67,73,68;33,68,40,73;40,68,43,70;43,68,44,69;64,73,71,100;68,70,71,73;70,69,71,70;40,70,42,71;43,72,46,78;44,71,46,72;45,70,46,71;62,70,64,72;64,70,65,71;40,71,41,72;66,72,68,73;67,71,68,72;62,72,63,73;33,73,38,76;38,73,39,75;41,74,43,78;42,73,43,74;51,74,61,78;38,78,42,84;39,76,41,78;40,75,41,76;63,75,64,76;33,76,36,78;36,76,37,77;61,76,62,78;38,77,39,78;33,78,35,79;33,79,34,81;36,80,38,82;37,79,38,80;63,80,64,100;33,85,37,100;33,82,34,85;37,82,38,83;34,83,35,85;35,84,36,85;40,84,42,86;39,84,40,85;37,86,38,90;41,86,42,88;38,88,39,89;37,92,42,100;39,91,42,92;41,90,42,91"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates4()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,11;0,43,34,74;0,11,23,43;23,11,37,13;37,11,42,12;42,12,50,17;47,11,48,12;67,11,100,100;58,11,67,26;53,11,58,15;51,11,53,13;50,11,51,12;23,13,30,15;30,13,33,14;38,13,42,18;50,14,52,18;50,13,51,14;52,13,53,14;31,15,38,20;33,14,38,15;23,15,27,17;27,15,29,16;52,15,53,18;56,15,58,17;54,15,56,16;27,17,31,21;29,16,31,17;53,16,54,18;23,17,25,22;25,17,26,18;48,17,50,19;47,17,48,18;54,17,55,19;57,17,58,18;38,18,40,19;55,18,56,21;25,22,27,27;26,19,27,22;36,22,40,25;37,20,39,22;38,19,39,20;40,19,42,20;45,19,49,20;52,19,54,21;51,19,52,20;56,20,58,22;56,19,57,20;36,20,37,21;42,21,47,24;42,20,44,21;49,20,51,21;54,20,55,21;27,21,30,24;40,21,42,23;39,21,40,22;47,21,50,22;50,22,52,23;51,21,52,22;23,22,24,24;27,25,34,26;30,22,35,24;47,22,48,23;53,22,56,26;56,22,57,24;49,23,51,24;51,26,54,30;52,23,53,26;24,24,25,25;32,24,34,25;40,24,41,25;43,24,45,25;45,25,48,26;47,24,48,25;49,24,50,25;57,24,58,26;36,25,39,27;35,25,36,26;41,25,43,26;50,25,51,26;23,30,26,43;23,26,24,30;26,27,28,30;27,26,28,27;31,26,33,28;30,26,31,27;39,26,41,27;44,26,47,27;49,26,50,27;54,26,55,28;61,26,67,27;34,27,35,31;33,27,34,29;35,27,36,28;37,27,39,28;41,27,43,29;46,28,49,29;48,27,49,28;51,33,67,55;64,29,67,33;65,27,67,29;24,28,25,30;40,28,41,29;49,29,51,33;50,28,51,29;55,28,60,30;60,28,61,29;31,29,32,30;35,29,36,30;37,29,39,30;46,29,47,31;45,29,46,30;47,29,48,30;27,30,28,33;33,30,34,31;42,30,45,32;47,31,49,34;48,30,49,31;51,30,53,31;54,30,57,33;57,30,58,31;62,31,64,33;63,30,64,31;28,34,30,40;28,31,29,34;38,32,44,33;41,31,42,32;51,31,52,32;52,32,54,33;53,31,54,32;26,32,27,43;44,33,47,36;46,32,47,33;57,32,58,33;60,32,62,33;33,33,34,34;35,33,37,34;38,33,41,34;49,33,50,34;32,34,33,35;36,35,44,38;41,34,44,35;47,34,48,35;44,41,51,57;48,36,51,41;49,35,51,36;50,34,51,35;30,36,33,41;30,35,32,36;33,38,38,41;34,36,36,38;33,36,34,37;44,36,46,37;27,38,28,43;38,38,43,39;38,39,40,40;43,39,44,40;46,40,48,41;47,39,48,40;29,40,30,41;28,41,29,43;33,41,34,43;31,41,33,42;34,41,35,42;38,41,39,42;29,42,31,43;"
  $sPixelRect &= "36,42,38,43;42,43,44,49;43,42,44,43;34,49,41,65;34,46,40,49;34,45,35,46;37,45,40,46;43,49,44,54;41,58,43,63;41,54,42,58;51,55,58,57;58,55,62,56;45,57,54,58;56,58,63,61;61,57,64,58;45,58,49,59;63,58,64,59;41,71,67,100;64,61,67,69;65,59,67,61;66,58,67,59;46,61,60,71;53,59,56,61;43,60,44,62;49,60,53,61;60,61,62,63;43,64,46,71;44,63,46,64;45,62,46,63;41,63,42,64;60,63,61,64;62,65,64,67;63,63,64,65;34,65,38,69;38,65,40,66;38,66,39,67;41,67,43,71;42,66,43,67;63,67,64,68;37,72,41,79;39,69,41,72;40,68,41,69;60,68,61,71;34,69,36,71;36,69,37,70;61,69,62,71;66,69,67,71;38,70,39,72;62,70,63,71;34,71,35,72;35,74,37,77;36,73,37,74;0,74,32,100;32,74,33,75;34,76,35,77;32,79,34,100;32,77,33,79;36,77,37,78;39,79,41,81;38,79,39,80;34,81,36,86;34,80,35,81;40,81,41,82;36,82,37,85;37,83,38,84;34,88,41,100;39,85,41,88;36,87,39,88;38,86,39,87"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates5()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;48,0,100,7;0,0,30,9;30,0,48,5;30,5,35,7;35,5,39,6;46,5,48,6;39,6,46,11;30,7,32,8;33,8,39,12;36,7,39,8;46,8,49,11;46,7,47,8;67,7,100,100;55,7,67,24;51,7,55,10;49,7,51,9;0,38,34,76;0,9,20,38;20,9,26,11;26,9,27,10;28,10,33,16;30,9,33,10;49,9,50,10;54,10,55,13;53,10,54,11;20,11,23,13;23,11,24,12;24,13,28,16;27,11,28,13;26,11,27,12;44,11,46,13;43,11,44,12;46,11,48,12;51,11,53,13;50,11,51,12;25,12,26,13;33,16,37,19;33,12,36,16;36,12,37,13;48,12,50,14;52,13,54,16;53,12,54,13;20,13,22,15;37,13,39,14;42,13,45,14;45,14,47,15;46,13,47,14;49,16,52,22;50,13,51,16;22,16,26,20;22,15,24,16;23,14,24,15;37,14,38,15;39,15,42,19;39,14,41,15;20,15,21,19;37,16,39,18;38,15,39,16;42,15,45,17;45,15,46,16;46,16,48,17;47,15,48,16;26,16,27,17;52,16,53,19;53,19,55,25;54,16,55,19;21,17,22,18;29,17,31,21;42,17,43,18;46,17,47,18;26,18,28,20;28,18,29,19;31,18,32,19;42,19,45,20;44,18,45,19;32,19,36,21;39,19,41,20;47,19,48,20;22,20,24,23;21,20,22,21;24,21,30,22;25,20,26,21;28,20,29,21;37,20,39,21;41,20,43,21;46,20,47,21;47,22,50,25;48,20,49,22;33,21,34,22;35,21,37,22;44,21,46,23;51,23,53,26;52,21,53,23;20,27,24,38;20,22,21,27;23,23,25,25;24,22,25,23;29,22,33,24;27,22,29,23;34,22,35,23;37,22,40,24;40,22,41,23;43,22,44,25;50,22,51,24;34,24,36,25;35,23,36,24;44,23,45,24;45,25,48,27;46,23,47,25;21,24,22,27;31,24,33,26;40,24,42,27;55,24,58,25;47,31,67,55;63,26,67,31;64,24,67,26;22,25,23,27;25,25,26,30;24,25,25,27;27,25,28,26;29,25,30,26;39,25,40,28;42,25,43,26;48,25,49,26;49,26,51,27;50,25,51,26;53,25,54,26;34,30,41,33;36,27,38,29;37,26,38,27;42,27,46,29;43,26,45,27;55,27,60,28;59,26,60,27;35,27,36,28;46,27,47,28;61,28,63,31;62,27,63,28;26,28,27,33;33,28,35,29;41,29,43,32;40,28,42,29;52,28,58,31;37,29,41,30;43,29,45,30;48,29,52,31;24,33,26,38;24,30,25,33;27,31,34,36;27,30,28,31;43,30,44,31;44,31,47,34;45,30,48,31;43,32,44,35;34,33,37,35;37,33,39,34;42,34,43,39;46,34,47,35;34,35,36,36;36,36,39,37;38,35,39,36;26,36,27,38;28,36,34,37;27,37,28,38;34,50,40,67;34,37,36,50;33,37,34,38;36,37,38,39;"
  $sPixelRect &= "42,42,47,53;45,38,47,42;46,37,47,38;41,38,42,40;36,39,37,42;43,41,45,42;44,40,45,41;38,41,39,43;41,43,42,50;36,46,39,50;38,45,39,46;44,53,47,58;43,53,44,56;40,57,42,64;40,54,41,57;47,55,58,57;58,55,63,56;47,57,54,58;60,58,64,60;63,57,64,58;45,58,50,59;65,61,67,69;66,58,67,61;42,59,43,61;42,71,66,100;51,60,61,67;56,59,60,60;61,60,63,62;44,62,51,71;45,61,51,62;61,62,62,64;42,66,44,71;43,63,44,66;63,65,65,68;64,63,65,65;40,64,41,65;34,67,38,69;38,67,39,68;37,72,42,81;40,69,42,72;41,67,42,69;51,67,60,71;60,68,61,71;34,69,36,72;36,69,37,70;61,69,63,71;38,71,40,72;39,70,40,71;63,70,64,71;34,72,35,74;66,72,67,100;35,76,37,79;36,74,37,76;0,76,33,100;33,88,42,100;33,81,35,87;33,79,34,81;36,79,37,80;39,81,42,83;38,81,39,82;35,83,37,86;35,82,36,83;41,83,42,85;40,83,41,84;37,84,38,86;39,87,42,88;41,86,42,87;33,87,34,88"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates6()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;48,0,100,7;0,0,28,9;28,0,48,5;28,5,34,7;34,5,38,6;38,6,46,11;43,5,44,6;47,5,48,6;28,7,30,8;31,8,38,12;35,7,38,8;46,8,49,12;46,7,48,8;66,7,100,71;55,7,66,22;51,7,55,10;50,7,51,9;49,7,50,8;0,37,35,76;0,9,20,37;20,9,24,11;24,9,26,10;26,10,31,15;28,9,31,10;49,9,50,12;52,10,55,11;20,11,22,16;22,11,23,12;23,12,26,18;24,11,26,12;38,11,39,12;44,11,46,14;51,11,52,13;50,11,51,12;54,11,55,13;33,15,37,19;31,12,36,15;36,12,37,13;46,12,47,13;52,13,54,17;52,12,53,13;37,13,39,14;42,13,44,14;49,13,51,15;47,13,49,14;39,15,43,18;39,14,41,15;46,14,47,15;26,17,28,19;26,15,27,17;37,15,39,17;43,15,45,17;45,15,46,16;46,16,48,18;47,15,48,16;20,16,21,18;21,18,23,20;22,16,23,18;29,16,31,19;49,16,52,22;28,17,29,18;31,17,32,18;52,17,53,19;53,19,55,25;54,17,55,19;23,18,24,19;32,18,33,21;37,18,38,19;39,18,42,19;44,18,45,19;24,19,27,20;27,20,30,22;28,19,30,20;33,19,35,21;38,19,40,20;42,19,44,20;47,22,50,25;48,19,49,22;47,19,48,20;23,20,25,24;22,20,23,22;26,20,27,21;35,20,38,21;41,20,43,21;46,20,47,21;20,24,23,37;20,21,21,24;31,22,33,24;30,21,32,22;34,21,36,22;38,21,40,23;44,21,46,23;51,23,53,26;52,21,53,23;29,22,31,23;37,22,38,24;42,23,45,24;43,22,44,23;50,22,51,23;55,22,60,23;46,31,66,58;61,22,66,31;21,23,22,24;28,23,29,25;34,23,36,24;45,24,47,27;46,23,47,24;55,23,57,24;24,24,25,28;30,24,32,25;39,24,42,26;43,24,44,25;35,26,41,27;38,25,39,26;43,26,45,29;44,25,45,26;47,25,49,26;49,26,52,27;50,25,51,26;57,25,59,26;25,28,27,33;25,26,26,28;47,26,48,27;55,26,58,28;60,26,61,31;23,27,24,37;33,27,34,29;32,27,33,28;35,27,38,28;38,28,43,31;41,27,43,28;45,27,46,28;48,27,50,28;51,28,56,31;53,27,55,28;29,28,30,29;31,28,32,29;47,28,48,29;56,28,57,29;27,30,29,36;27,29,28,30;30,30,38,33;35,29,38,30;43,29,44,30;49,29,51,31;59,29,60,31;29,30,30,31;47,30,49,31;38,31,40,33;40,31,41,32;43,32,46,35;45,31,46,32;24,32,25,37;29,33,33,36;29,32,30,33;26,33,27,35;33,33,37,34;33,34,35,35;38,34,40,35;25,35,26,37;35,36,38,41;36,35,39,36;43,35,44,36;26,36,27,37;32,36,35,37;38,36,39,38;39,40,41,43;40,38,41,40;"
  $sPixelRect &= "44,41,46,54;45,39,46,41;35,49,42,68;35,43,38,49;35,41,37,43;39,43,40,44;38,46,41,49;45,54,46,60;46,58,58,60;58,58,62,59;65,58,66,59;42,62,44,65;42,60,43,62;46,60,51,62;51,60,55,61;41,74,100,100;56,61,63,74;61,60,64,61;63,61,64,66;46,62,47,63;49,63,56,74;53,62,56,63;45,66,49,74;47,64,49,66;65,64,66,71;42,65,43,66;46,65,47,66;42,69,45,74;43,68,45,69;44,67,45,68;35,68,40,70;40,68,41,69;35,70,38,73;38,70,39,71;40,72,42,74;41,70,42,72;69,71,100,74;67,71,69,72;63,72,65,74;35,73,37,74;37,75,41,82;38,74,41,75;39,73,40,74;65,73,67,74;68,73,69,74;35,74,36,75;0,76,33,100;33,76,34,78;35,78,37,79;36,76,37,78;36,79,37,81;33,80,34,100;34,83,36,89;34,81,35,83;38,82,41,84;36,84,37,89;40,84,41,87;39,84,40,85;37,86,38,88;34,89,35,90;36,90,41,100;40,89,41,90;34,91,36,100"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates7()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,10;0,42,39,74;0,10,25,42;25,10,39,12;39,10,45,11;60,38,100,69;65,10,100,38;56,10,65,16;52,10,56,12;51,10,52,11;44,11,50,16;25,12,32,14;32,12,35,13;40,12,44,17;50,13,53,18;50,12,52,13;54,12,56,14;53,12,54,13;36,17,41,20;36,13,40,17;25,14,29,16;29,14,30,15;31,15,36,19;33,14,36,15;53,15,55,18;53,14,54,15;55,14,56,15;25,16,27,18;27,16,28,17;28,17,31,23;29,16,31,17;48,18,50,20;49,16,50,18;48,16,49,17;60,16,65,28;59,16,60,19;58,16,59,17;41,17,42,18;56,17,57,19;55,17,56,18;25,18,26,22;26,22,28,26;27,18,28,22;42,18,44,19;50,18,51,19;53,18,54,20;57,19,59,22;57,18,58,19;31,19,33,20;43,20,47,23;44,19,46,20;47,19,48,20;51,19,52,20;54,22,57,26;54,19,56,21;38,20,42,24;42,20,43,22;49,20,51,21;28,24,35,25;31,21,36,23;37,21,38,26;47,21,49,23;49,21,50,22;51,22,53,23;52,21,53,22;55,21,56,22;57,22,58,23;58,24,60,29;59,22,60,24;33,23,36,24;44,23,47,24;50,23,52,24;36,24,37,25;38,24,40,26;40,25,43,26;42,24,43,25;44,24,45,25;47,24,49,26;52,26,55,30;53,24,54,26;28,25,30,26;32,25,34,27;31,25,32,26;45,25,47,26;51,25,52,26;28,26,29,31;27,26,28,28;35,26,37,30;33,27,35,28;34,26,35,27;39,26,41,27;55,26,56,28;56,28,58,30;57,26,58,28;25,31,28,42;25,28,27,31;25,27,26,28;41,27,45,28;48,27,50,29;32,28,33,29;38,28,40,29;42,28,43,29;47,28,48,30;50,29,52,32;51,28,52,29;60,28,61,29;29,29,30,38;34,29,35,30;44,29,46,32;48,29,49,30;63,32,65,38;64,29,65,32;39,34,46,37;43,30,44,34;42,30,43,31;48,31,50,34;49,30,50,31;52,30,54,31;55,30,56,31;39,31,42,33;52,31,53,32;57,32,61,33;60,31,61,32;37,32,38,34;36,32,37,33;46,32,48,35;50,32,51,33;30,34,32,40;30,33,31,34;33,33,34,34;35,33,36,34;44,33,46,34;48,39,60,63;52,34,58,39;55,33,60,34;48,34,49,35;58,34,59,35;62,34,63,38;32,37,39,40;35,35,39,37;32,35,35,36;46,35,47,36;48,36,52,39;50,35,52,36;32,36,33,37;28,37,29,42;39,37,42,39;42,37,44,38;61,37,62,38;58,38,59,39;42,39,44,40;45,40,47,41;46,39,47,40;29,40,30,42;32,40,36,41;40,40,43,42;30,41,32,42;35,41,40,42;39,42,41,45;41,42,42,43;39,45,40,47;39,50,46,65;43,46,46,50;44,45,46,46;41,48,43,50;"
  $sPixelRect &= "42,47,43,48;40,49,41,50;46,60,47,64;54,63,60,66;52,63,54,65;50,63,52,64;39,65,44,67;44,65,45,66;40,74,58,100;46,67,55,74;48,65,51,67;47,66,48,67;51,66,53,67;58,66,60,68;56,66,58,67;39,67,42,69;42,67,43,68;43,70,46,74;44,69,46,70;45,68,46,69;55,69,59,74;55,68,57,69;39,69,41,71;64,69,100,100;63,69,64,71;62,69,63,70;58,74,61,76;59,71,62,74;59,70,60,71;39,71,40,72;42,71,43,74;41,73,42,74;0,74,34,100;34,74,37,77;37,74,38,75;38,76,40,82;39,75,40,76;62,77,64,82;63,75,64,77;58,76,60,79;34,81,37,91;34,77,36,81;58,79,59,81;61,79,62,82;39,82,40,86;63,82,64,83;58,85,64,100;58,83,60,85;60,84,62,85;37,86,38,90;34,91,35,92;34,93,40,100;37,92,40,93;39,91,40,92"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates8()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,17;0,45,35,100;0,17,30,45;30,17,38,19;38,17,41,18;67,17,100,100;61,17,67,22;59,17,61,19;58,17,59,18;48,18,58,23;44,18,47,30;38,19,44,24;42,18,44,19;47,18,48,21;30,19,34,21;34,19,36,20;58,20,60,25;58,19,59,20;60,19,61,20;34,21,38,24;36,20,38,21;30,21,33,24;60,21,61,25;47,22,48,24;63,22,67,24;62,22,63,23;56,23,58,26;55,23,56,24;61,23,62,24;30,24,32,25;33,24,37,27;43,24,44,25;48,24,50,25;65,24,67,28;64,24,65,25;30,25,31,26;32,27,34,31;32,25,33,27;37,25,38,27;49,27,56,29;54,25,56,27;53,25,54,26;62,25,63,27;61,25,62,26;39,26,42,28;38,26,39,27;43,26,44,31;47,26,52,27;58,26,61,27;63,27,65,30;63,26,64,27;47,27,49,28;56,27,58,28;60,29,62,34;61,27,62,29;60,27,61,28;30,31,32,45;30,28,31,31;36,28,40,30;34,28,36,29;40,28,41,29;56,29,59,30;58,28,59,29;62,34,67,43;65,30,67,34;66,28,67,30;34,29,35,31;42,29,43,31;47,29,48,32;50,29,54,30;38,30,40,32;37,30,38,31;44,30,45,32;49,30,52,31;56,30,58,31;58,32,60,37;59,30,60,32;62,30,64,31;33,35,35,43;33,31,34,35;40,31,42,34;45,31,47,32;51,31,55,32;62,31,63,33;64,31,65,34;46,33,50,34;48,32,49,33;51,32,53,33;56,32,57,33;37,33,38,34;39,33,40,34;43,33,45,34;63,33,64,34;40,34,41,35;47,34,48,35;52,34,54,36;54,34,55,35;56,35,58,38;57,34,58,35;60,34,61,36;47,36,51,38;49,35,50,36;51,35,52,36;59,38,62,41;61,35,62,38;52,36,53,37;53,37,56,40;55,36,56,37;37,37,38,38;39,37,40,38;41,37,42,39;44,37,46,39;43,37,44,38;58,37,59,38;60,37,61,38;35,39,41,45;35,38,36,39;51,38,53,41;56,38,57,39;46,39,50,43;50,39,51,42;58,39,59,41;57,39,58,40;41,40,46,44;53,40,54,41;51,41,52,42;52,51,67,67;52,42,58,48;54,41,56,42;61,41,62,43;60,41,61,42;34,43,35,44;46,43,48,44;58,44,61,47;58,43,60,44;64,43,67,45;63,43,64,44;32,44,33,45;41,44,43,45;47,45,50,57;48,44,50,45;43,46,47,49;44,45,47,46;61,45,63,47;66,45,67,46;35,53,47,66;35,46,39,53;39,46,41,47;63,46,64,47;39,47,40,48;41,48,43,49;42,47,43,48;50,48,51,50;52,48,56,51;61,49,67,51;66,48,67,49;44,49,47,50;39,50,40,53;60,50,61,51;40,51,42,53;42,52,43,53;46,52,47,53;47,57,49,62;51,58,52,65;47,62,48,65;"
  $sPixelRect &= "50,62,51,65;35,66,42,70;42,66,44,68;44,66,45,67;41,73,53,100;47,68,51,73;48,67,50,68;55,78,67,88;56,67,67,78;54,67,56,70;53,67,54,68;42,68,43,69;45,70,47,73;46,69,47,70;51,69,52,73;35,70,40,72;40,70,41,71;55,70,56,72;42,72,45,73;44,71,45,72;52,71,53,73;35,72,38,75;38,72,39,73;53,72,54,78;38,76,41,83;39,75,41,76;40,74,41,75;35,75,37,76;35,76,36,77;37,77,38,81;35,83,37,91;35,81,36,83;40,83,41,87;39,83,40,85;37,85,38,90;38,87,39,90;53,91,67,100;53,88,54,91;60,88,67,91;57,88,60,90;56,88,57,89;37,93,41,100;39,91,41,93;40,90,41,91;54,90,55,91;35,94,37,100;35,91,36,94;38,92,39,93"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()
Func _PixelCoordinates9()
#region pixel coordinates
Local $sPixelRect
  $sPixelRect &= "100,100;0,0,100,16;0,16,33,100;33,16,42,18;42,16,46,17;66,34,100,100;70,16,100,34;53,16,70,17;48,18,51,29;48,17,50,18;65,17,70,21;63,17,65,19;62,17,63,18;33,18,38,21;38,18,39,19;42,18,48,23;51,18,62,22;38,20,42,25;39,19,42,20;60,22,65,25;62,19,63,22;64,19,65,20;63,20,64,22;33,21,37,23;64,21,65,22;67,21,70,25;66,21,67,24;51,22,54,23;56,22,60,23;33,42,36,65;33,30,36,37;33,23,35,30;37,23,38,43;47,23,48,24;51,23,52,24;59,23,60,24;65,23,66,26;36,24,37,30;40,25,46,26;42,24,43,25;52,24,54,25;53,26,56,30;54,25,56,26;57,25,64,26;69,25,70,27;68,25,69,26;38,26,40,27;43,26,45,28;45,26,46,27;46,28,48,30;47,26,48,28;51,26,53,28;58,26,60,27;67,27,69,30;66,26,68,27;38,27,39,29;40,27,43,29;56,27,59,29;60,27,62,28;64,27,65,29;63,27,64,28;66,27,67,28;42,29,44,31;43,28,44,29;59,28,60,29;65,28,66,30;41,29,42,30;48,29,49,31;56,29,58,30;60,29,62,31;62,29,63,30;69,29,70,34;44,30,46,33;49,30,55,31;61,39,66,45;62,32,65,37;63,30,65,32;66,30,68,32;41,31,42,33;46,31,47,32;54,31,58,32;65,31,66,34;43,32,44,33;47,32,48,34;50,32,53,34;54,32,56,33;60,32,61,33;67,33,69,34;68,32,69,33;44,33,45,34;48,33,49,34;59,33,60,34;60,34,62,38;61,33,62,34;55,34,58,36;58,34,59,35;52,35,53,42;50,36,52,38;51,35,52,36;53,35,54,37;58,36,60,39;59,35,60,36;64,37,66,39;65,35,66,37;36,36,37,42;38,37,40,43;38,36,39,37;42,36,43,37;45,36,46,38;44,36,45,37;47,36,49,38;49,36,50,37;55,36,56,37;33,37,35,42;56,37,58,40;40,40,46,44;41,38,44,40;40,38,41,39;53,38,56,41;60,38,61,39;63,38,64,39;46,39,52,43;44,39,46,40;58,39,59,40;56,40,57,41;59,40,61,43;53,41,54,42;58,41,59,42;55,44,58,51;55,42,56,44;36,49,40,64;36,44,38,49;36,43,37,44;39,43,40,44;56,43,57,44;60,43,61,44;38,44,39,46;47,44,52,58;44,45,47,51;46,44,47,45;52,44,53,51;41,45,44,48;58,46,60,52;58,45,59,46;63,45,66,48;62,45,63,47;40,46,41,47;38,48,39,49;43,48,44,50;42,48,43,49;60,49,62,52;60,48,61,49;64,48,66,50;40,53,44,63;40,50,41,53;62,50,63,52;65,50,66,51;41,51,42,53;46,51,47,52;55,51,56,52;42,52,43,53;53,59,66,67;54,54,66,59;54,53,56,54;44,55,47,63;44,54,46,55;"
  $sPixelRect &= "47,58,51,61;47,61,50,63;52,61,53,65;38,68,52,100;41,65,50,68;48,64,50,65;33,65,35,66;33,66,34,67;37,66,41,68;50,66,51,68;36,68,38,73;35,67,37,68;55,78,66,88;56,67,66,78;55,67,56,72;54,67,55,69;35,68,36,70;33,73,35,79;33,69,34,73;52,72,54,78;52,70,53,72;37,73,38,76;35,77,36,79;52,78,53,84;33,79,34,80;33,82,38,100;37,81,38,82;54,84,55,87;52,90,56,100;52,87,53,90;53,88,54,90;56,91,66,100;59,88,66,91;58,88,59,90;57,88,58,89;54,89,55,90"
#endregion
Local $aPixelRect = StringSplit($sPixelRect, ";", 2)
Return $aPixelRect
EndFunc   ;==>_PixelCoordinates()