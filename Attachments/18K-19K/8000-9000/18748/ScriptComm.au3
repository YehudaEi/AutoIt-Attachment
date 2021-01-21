Global $ss__Global[1][3]
#include <SendMessage.au3>

;===============================================================================
;
; Function Name:    _ScriptComCreateRecv($ii_Nme, $ii_Callback)
; Description:      Creates a GUI and sets a callback for recv
; Parameter(s):     $ii_Nme			- A name for the GUI which you will recv/send messages
;					$ii_Callback	- Function to call when a message is received
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1 and creates a hidden GUI
;
; Author(s):        Chipped
;
;===============================================================================
Func _ScriptComCreateRecv($ii_Nme, $ii_Callback)
	Local Const $WM_COPYDATA = 0x4A
	Local $ss_Hwnd = GUICreate($ii_Nme)
	Local $ss_Dim = UBound($ss__Global)
	ReDim $ss__Global[$ss_Dim  + 1][3]
	$ss__Global[$ss_Dim][0] = $ss_Hwnd
	$ss__Global[$ss_Dim][1] = $ii_Nme
	$ss__Global[$ss_Dim][2] = $ii_Callback
	GUIRegisterMsg($WM_COPYDATA, "_ScriptComRcvInt")
	Return 1
EndFunc

;===============================================================================
;
; Function Name:     _ScriptComAttachRecv($ii_Hwnd, $ii_Callback)
; Description:      Attachs to a GUI and sets a callback for recv
; Parameter(s):     $ii_Hwnd		- The GUI's handle inwhich you are to attach to
;					$ii_Callback	- Function to call when a message is received
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;
; Author(s):        Chipped
;
;===============================================================================
Func _ScriptComAttachRecv($ii_Hwnd, $ii_Callback)
	Local Const $WM_COPYDATA = 0x4A
	Local $ss_Dim = UBound($ss__Global)
	ReDim $ss__Global[$ss_Dim  + 1][3]
	$ss__Global[$ss_Dim][0] = $ii_Hwnd
	$ss__Global[$ss_Dim][1] = WinGetTitle($ii_Hwnd)
	$ss__Global[$ss_Dim][2] = $ii_Callback
	GUIRegisterMsg($WM_COPYDATA, "_ScriptComRcvInt")
	Return 1
EndFunc

;===============================================================================
;
; Function Name:    _ScriptComSend($iHwnd, $sMsg, $iSender)
; Description:      Attachs to a GUI and sets a callback for recv
; Parameter(s):     $iHwnd		- The GUI's handle inwhich you are to send a message
;					$sMsg		- Message to send
;					$iSender	- The handle to send recv
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;					On Fail	   - Returns -1
;
; Author(s):        Chipped
;
;===============================================================================
Func _ScriptComSend($iHwnd, $sMsg, $iSender=0)
	If IsHWnd($iHwnd) = 0 Then
		$iHwnd = WinGetHandle($iHwnd)
		If IsHWnd($iHwnd) = 0 Then Return -1
	EndIf
	Local Const $WM_COPYDATA = 0x4A
	$ii_Size = StringLen($sMsg)
	$ii_Struct = DllStructCreate("char[1024]")
	DllStructSetData($ii_Struct, 1, $sMsg)
	
    $ii_WM = DllStructCreate ("uint;uint;ptr")
    DllStructSetData ($ii_WM, 1, 1)
    DllStructSetData ($ii_WM, 2, ($ii_Size * 2))
    DllStructSetData ($ii_WM, 3, DllStructGetPtr ($ii_Struct))

	_SendMessage($iHwnd, $WM_COPYDATA, $iSender, DllStructGetPtr($ii_WM))
	Return 1
EndFunc

;======================================================
;Internal Function
;======================================================
Func _ScriptComRcvInt ($hWnd, $iMsgID, $WParam, $LParam)
    Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr',$LParam)
    $ss_LEN = DllStructGetData($COPYDATA, 2)
    Local $__Struct = DllStructCreate('Char['&$ss_LEN+1&']',DllStructGetData($COPYDATA, 3))
    $msg = Stringleft(DllStructGetData($__Struct, 1),$ss_LEN)
	For $ss__ = 0 To UBound($ss__Global) - 1 Step 1
		If $ss__Global[$ss__][0] = $hWnd Then
			 Return Call($ss__Global[$ss__][2], $WParam, $msg)
		EndIf
	Next
EndFunc