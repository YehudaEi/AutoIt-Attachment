; TransIt
; Just a little scrap.. I find it useful though.
; MoreTrans() and LessTrans() are compatible with XP only. Vista has not yet been tested.

HotKeySet("{NUMPADADD}", "MoreTrans")
HotKeySet("{NUMPADSUB}", "LessTrans")
HotKeySet("{NUMPADMULT}", "SetTrans")

While 1
	Sleep(10)
WEnd

Func SetTrans()
	$active = WinGetTitle("")
	$input = InputBox("TransIt", "Please enter a transparency level (being between 0 and 255.")
	If $input < 0 Or $input > 255 Then
		MsgBox(0, "TransIt", "That was an invalid number!")
	Else
		WinSetTrans($active, "", Int($input))
	EndIf
EndFunc

Func MoreTrans()
	Local $active = WinGetTitle("")
	If WinGetTrans($active) = 225 Then
		; do nothing
	Else
		WinSetTrans($active, "", WinGetTrans($active) + 10)
	EndIf
EndFunc

Func LessTrans()
	Local $active = WinGetTitle("")
	If WinGetTrans($active) = 0 Then
		; do nothing
	Else
		WinSetTrans($active, "", WinGetTrans($active) - 10)
	EndIf
EndFunc

; I did not write the below function. It is by Valik; I acquired it through MsCreator.
Func WinGetTrans($sTitle, $sText = "")
	Local $hWnd = WinGetHandle($sTitle, $sText)
	If Not $hWnd Then Return -1
	Local $aRet = DllCall("user32.dll", "int", "GetLayeredWindowAttributes", "hwnd", $hWnd, "ptr", 0, "int_ptr", 0, "ptr", 0)
	If @error Or Not $aRet[0] Then Return -1
	Return $aRet[3]
EndFunc