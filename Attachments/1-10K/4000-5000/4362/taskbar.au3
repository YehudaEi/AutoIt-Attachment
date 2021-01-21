; ---------------------------------------------------------------------------
; AutoIt Version: 3.0
; Language: English
; Platform: Windows XP
; Function: This script aquires the handles of windows that have taskbar
;           buttons
; Author: Robert Rimes Perry (robertrimesperry@yahoo.com)
; ---------------------------------------------------------------------------

; Constants used with API
Dim Const $GW_OWNER = 4
Dim Const $GWL_EXSTYLE = (-20)
Dim Const $WS_EX_TOOLWINDOW = 0x80
Dim Const $WS_EX_APPWINDOW = 0x40000

; Find windows that:
; - are visible
; - have a title
; - do not have a parent
; - do not have an owner and are not Tool windows OR
;   have an owner and are App windows
Dim $hWnd, $sTitle
Dim $a = WinList()
For $i = 1 to $a[0][0]
    $hWnd = $a[$i][1]
    $sTitle = $a[$i][0]
    $bHasParent = HasParent($hWnd)
    If(IsVisible($hWnd) AND ($sTitle <> "") AND NOT $bHasParent) Then
        $bHasOwner = HasOwner($hWnd)
        $iExStyle = GetExStyle($hWnd)
        If((NOT $bHasOwner AND NOT BitAnd($iExStyle, $WS_EX_TOOLWINDOW)) OR _
        ($bHasOwner AND BitAnd($iExStyle, $WS_EX_APPWINDOW))) Then
            MsgBox(0, "", "sTitle=" & $sTitle & @LF & _
            "hWnd=" & $hWnd & @LF & _
            "bHasParent=" & $bHasParent & @LF & _
            "bHasOwner=" & $bHasOwner & @LF & _
            "iExStyle=" & $iExStyle)
        EndIf
    EndIf
Next

Func GetExStyle($hWnd)
    Local $a = DllCall("user32.dll", "hwnd", "GetWindowLong", _
    "hwnd", $hWnd, _
    "int", $GWL_EXSTYLE)
    Return Dec($a[0])
EndFunc

Func HasOwner($hWnd)
    Local $a = DllCall("user32.dll", "hwnd", "GetWindow", _
    "hwnd", $hWnd, _
    "int", $GW_OWNER)
    If($a[0]) Then
            Return 1
    Else
            Return 0
    EndIf
EndFunc

Func HasParent($hWnd)
    Local $a = DllCall("user32.dll", "hwnd", "GetParent", _
    "hwnd", $hWnd)
    If $a[0] Then
            Return 1
    Else
            Return 0
    EndIf
EndFunc

Func IsMinimized($hWnd)
    If BitAnd(WinGetState($hWnd), 16) Then
        Return 1
    Else
        Return 0
    EndIf
EndFunc


Func IsVisible($hWnd)
    If BitAnd(WinGetState($hWnd), 2) Then
        Return 1
    Else
        Return 0
    EndIf
EndFunc
