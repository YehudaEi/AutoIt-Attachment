
Func _RegisterWindowMessage($sMsg)
    Local $aRet = DllCall("user32.dll", "int", "RegisterWindowMessage", "str", $sMsg)
    If @error Then Return SetError(@error, @extended, 0)
    Return $aRet[0]
EndFunc

Func _SendMessageTimeout($hWnd, $msg, $wParam, $lParam, $nFlags, $nTimeout, ByRef $vOut, $r = 0, $t1 = "int", $t2 = "int")
    Local $aRet = DllCall("user32.dll", "long", "SendMessageTimeout", "hwnd", $hWnd, "int", $msg, $t1, $wParam, $t2, $lParam, "int", $nFlags, "int", $nTimeout, "int_ptr", "")
    If @error Then
        $vOut = 0
        Return SetError(@error, @extended, 0)
    EndIf
    $vOut = $aRet[7]
    If $r >= 0 And $r <= 4 Then Return $aRet[$r]
    Return $aRet
EndFunc

Func _ObjGetFromHWND(ByRef $hWin)
    DLLCall("ole32.dll","int","CoInitialize","ptr",0)
    If @error Then Return SetError(@error,@extended,0)

    Local Const $WM_HTML_GETOBJECT = _RegisterWindowMessage("WM_HTML_GETOBJECT")
    If @error Then Return SetError(@error,@extended,0)
    
    Local Const $SMTO_ABORTIFHUNG = 0x0002
    Local $lResult, $typUUID, $aRet, $oIE

    _SendMessageTimeout($hWin, $WM_HTML_GETOBJECT, 0, 0, $SMTO_ABORTIFHUNG, 1000, $lResult)
    If @error Then Return SetError(@error,@extended,0)

    $typUUID = DLLStructCreate("int;short;short;byte[8]")
    DLLStructSetData($typUUID,1,0x626FC520)
    DLLStructSetData($typUUID,2,0xA41E)
    DLLStructSetData($typUUID,3,0x11CF)
    DLLStructSetData($typUUID,4,0xA7,1)
    DLLStructSetData($typUUID,4,0x31,2)
    DLLStructSetData($typUUID,4,0x0,3)
    DLLStructSetData($typUUID,4,0xA0,4)
    DLLStructSetData($typUUID,4,0xC9,5)
    DLLStructSetData($typUUID,4,0x8,6)
    DLLStructSetData($typUUID,4,0x26,7)
    DLLStructSetData($typUUID,4,0x37,8)

    $aRet = DllCall("oleacc.dll", "int", "ObjectFromLresult", "int", $lResult, _
            "ptr", DLLStructGetPtr($typUUID), "int", 0, "idispatch_ptr", "")
    If @error Then Return SetError(@error,@extended,0)

    If Not IsObj($aRet[4]) Then Return SetError(1,@extended,0)

    $oIE = $aRet[4].Script()
; $oIE is now a valid IDispatch object
;Return $oIE.Document.parentwindow
    Return $oIE
EndFunc