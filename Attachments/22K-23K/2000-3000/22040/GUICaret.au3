#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.3 (beta)
 Author:         Kip

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#cs

Functions:

Func _Caret_Create($hWnd, $hBitmap=0, $iWidth=1, $iHeight=16)
Func _Caret_Show($hWnd)
Func _Caret_SetPos($iX, $iY)
Func _Caret_SetBlinkTime($iTime) ; WARNING! Do not use this function! This is the same as setting the blink time in the Control Panel. Other applications will also use this time.
Func _Caret_GetBlinkTime()
Func _Caret_Hide($hWnd)
Func _Caret_Destroy()
Func _Caret_GetPos()

#CE

Func _Caret_Create($hWnd, $hBitmap=0, $iWidth=1, $iHeight=16)
	Local $iRet = DllCall("User32.dll","hwnd","CreateCaret","hwnd",$hWnd,"hwnd",$hBitmap,"int",$iWidth,"int",$iHeight)
	Return $iRet[0]
EndFunc

Func _Caret_Show($hWnd)
	Local $iRet = DllCall("User32.dll","int","ShowCaret","hwnd",$hWnd)
	Return $iRet[0]
EndFunc

Func _Caret_SetPos($iX, $iY)
	Local $iRet = DllCall("User32.dll","int","SetCaretPos","int",$iX,"int",$iY)
	Return $iRet[0]
EndFunc

Func _Caret_SetBlinkTime($iTime) ; WARNING! Do not use this function! This is the same as setting the blink time in the Control Panel. Other applications will also use this time.
	Local $iRet = DllCall("User32.dll","int","SetCaretBlinkTime","uint",$iTime)
	Return $iRet[0]
EndFunc

Func _Caret_GetBlinkTime()
	Local $iRet = DllCall("User32.dll","uint","GetCaretBlinkTime")
	Return $iRet[0]
EndFunc

Func _Caret_Hide($hWnd)
	Local $iRet = DllCall("User32.dll","int","HideCaret","hwnd",$hWnd)
	Return $iRet[0]
EndFunc

Func _Caret_Destroy()
	Local $iRet = DllCall("User32.dll","int","DestroyCaret")
	Return $iRet[0]
EndFunc

Func _Caret_GetPos()
	Local $POINT = DllStructCreate("long;long")
	Local $Return[2]
	
	DllCall("User32.dll","int","GetCaretPos","ptr",DllStructGetPtr($POINT))

	$Return[0] = DllStructGetData($POINT,1)
	$Return[1] = DllStructGetData($POINT,2)
	
	Return $Return
	
EndFunc