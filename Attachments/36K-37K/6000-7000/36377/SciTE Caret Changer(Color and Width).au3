; #INDEX# =======================================================================================================================
; Title .........: SciTE Caret Changer(Color and Width)
; Language ......: English
; Description ...: SimpleCode to Change Caret of SciTE Editor.(AutoIt Editor)
; Author(s) .....: eManF
; Dll ...........: user32.dll
; ===============================================================================================================================


;--- InClude <scintilla.h.au3> converted to au3 format by lokster --;
;(Simple);
;{
Global $user32 = DllOpen("user32.dll")
Global Const $SCI_SETCARETFORE=2069
Global Const $SCI_GETCARETFORE=2138
Global Const $SCI_SETCARETWIDTH=2188
Global Const $SCI_GETCARETWIDTH=2189
;}

;### You can change these ###
;{
Global $iColor = 0x000000	;---> CaretColor. 0x000000 = Black.
Global $iWidth = 1			;---> CaretWidth. Can be 0-3(0 = hide).
;}

$iSci = ControlGetHandle("[CLASS:SciTEWindow]","","Scintilla1") ;---> Get SciT Handle

HotKeySet("^+r","iCaretSet") ;---> Set HotKey(Ctrl+Shift+r) For Run
HotKeySet("^+q","iExit")	 ;---> Set HotKey(Ctrl+Shift+q) For Exit

While 1
	Sleep(50)
WEnd

Func iCaretSet()
	AdlibUnRegister("__CaretSet")
	AdlibRegister("__CaretSet", 1000)
EndFunc

Func __CaretSet()
	If Sci_CaretGetColor($iSci) <> $iColor Or Sci_CaretGetWidth($iSci) <> $iWidth Then
		Sci_CaretSetWidth($iSci, $iWidth)
		Sci_CaretSetColor($iSci, $iColor)
	EndIf
EndFunc

Func iExit()
	DllClose($user32)
	Exit
EndFunc

;--- InClude <_SciLexer.au3> By Kip --;
;(Simple);
;{
Func Sci_CaretSetColor($Sci, $iColor)
	Return SendMessage($Sci, $SCI_SETCARETFORE, $iColor, 0)
EndFunc

Func Sci_CaretGetColor($Sci)
	Return SendMessage($Sci, $SCI_GETCARETFORE, 0, 0)
EndFunc

Func Sci_CaretSetWidth($Sci, $iWidth)
	Return SendMessage($Sci, $SCI_SETCARETWIDTH, $iWidth, 0)
EndFunc

Func Sci_CaretGetWidth($Sci)
	Return SendMessage($Sci, $SCI_GETCARETWIDTH, 0, 0)
EndFunc

Func SendMessage($hwnd, $msg, $wp, $lp)
	Local $ret
	$ret = DllCall($user32, "long", "SendMessageA", "long", $hwnd, "int", $msg, "int", $wp, "int", $lp)
	If @error Then
		SetError(1)
		Return 0
	Else
		SetError(0)
		Return $ret[0]
	EndIf

EndFunc   ;==>SendMessage
;}
