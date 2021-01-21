Const $WH_KEYBOARD = 2
Const $WH_CBT = 5
Const $WH_MOUSE = 7

Const $WM_AUTOITLBUTTONDOWN = 0x1400 + 0x0A30
Const $WM_AUTOITRBUTTONDOWN = 0x1400 + 0x0A31
Const $WM_AUTOITMBUTTONDOWN = 0x1400 + 0x0A32
Const $WM_AUTOITXBUTTONDOWN1 = 0x1400 + 0x0A33
Const $WM_AUTOITXBUTTONDOWN2 = 0x1400 + 0x0A34
Const $WM_AUTOITLBUTTONUP = 0x1400 + 0x0B30
Const $WM_AUTOITRBUTTONUP = 0x1400 + 0x0B31
Const $WM_AUTOITMBUTTONUP = 0x1400 + 0x0B32
Const $WM_AUTOITXBUTTONUP1 = 0x1400 + 0x0B33
Const $WM_AUTOITXBUTTONUP2 = 0x1400 + 0x0B34
Const $WM_AUTOITLDBLCLK = 0x1400 + 0x0C30
Const $WM_AUTOITRDBLCLK = 0x1400 + 0x0C31
Const $WM_AUTOITMDBLCLK = 0x1400 + 0x0C32
Const $WM_AUTOITXDBLCLK1 = 0x1400 + 0x0C33
Const $WM_AUTOITXDBLCLK2 = 0x1400 + 0x0C34
Const $WM_AUTOITMOUSEWHEELUP = 0x1400 + 0x0D30
Const $WM_AUTOITMOUSEWHEELDOWN = 0x1400 + 0x0D31
Const $WM_AUTOITMOUSEMOVE = 0x1400 + 0x0F30

Const $HCBT_SETFOCUS = 0x1400 + 0x1A30
Const $HCBT_ACTIVATE = 0x1400 + 0x1A31
Const $HCBT_CREATEWND = 0x1400 + 0x1A32
Const $HCBT_DESTROYWND = 0x1400 + 0x1A33
Const $HCBT_MINMAX = 0x1400 + 0x1A34

Const $WM_KEYDOWN = 0x0400 + 0x0A30
Const $WM_KEYUP = 0x0400 + 0x0A31

Global $n,$msg,$buffer = ""

HotKeySet("{ESC}","GoAway")

$gui = GUICreate("test")

Global $DLLinst = DLLCall("kernel32.dll","hwnd","LoadLibrary","str",".\hook.dll")
Global $mouseHOOKproc = DLLCall("kernel32.dll","hwnd","GetProcAddress","hwnd",$DLLInst[0],"str","MouseProc")
Global $keyHOOKproc = DLLCall("kernel32.dll","hwnd","GetProcAddress","hwnd",$DLLInst[0],"str","KeyProc")
Global $cbtHOOKproc = DLLCall("kernel32.dll","hwnd","GetProcAddress","hwnd",$DLLInst[0],"str","CBTProc")

Global $hhMouse = DLLCall("user32.dll","hwnd","SetWindowsHookEx","int",$WH_MOUSE, _
        "hwnd",$mouseHOOKproc[0],"hwnd",$DLLinst[0],"int",0)
Global $hhKey = DLLCall("user32.dll","hwnd","SetWindowsHookEx","int",$WH_KEYBOARD, _
        "hwnd",$keyHOOKproc[0],"hwnd",$DLLinst[0],"int",0)
Global $hhCBT = DLLCall("user32.dll","hwnd","SetWindowsHookEx","int",$WH_CBT, _
        "hwnd",$cbtHOOKproc[0],"hwnd",$DLLinst[0],"int",0)

DLLCall(".\hook.dll","int","SetValuesMouse","hwnd",$gui,"hwnd",$hhMouse[0])
DLLCall(".\hook.dll","int","SetValuesKey","hwnd",$gui,"hwnd",$hhKey[0])
DLLCall(".\hook.dll","int","SetValuesCBT","hwnd",$gui,"hwnd",$hhCBT[0])

GUIRegisterMsg($WM_AUTOITLDBLCLK,"myfunc")
GUIRegisterMsg($WM_AUTOITRDBLCLK,"myfunc")
GUIRegisterMsg($WM_AUTOITMDBLCLK,"myfunc")
GUIRegisterMsg($WM_AUTOITLBUTTONDOWN,"myfunc")
GUIRegisterMsg($WM_AUTOITRBUTTONDOWN,"myfunc")
GUIRegisterMsg($WM_AUTOITLBUTTONUP,"myfunc")
GUIRegisterMsg($WM_AUTOITRBUTTONUP,"myfunc")
GUIRegisterMsg($WM_AUTOITMBUTTONDOWN,"myfunc")
GUIRegisterMsg($WM_AUTOITMBUTTONUP,"myfunc")
GUIRegisterMsg($WM_AUTOITMOUSEWHEELUP,"myfunc")
GUIRegisterMsg($WM_AUTOITMOUSEWHEELDOWN,"myfunc")
;GUIRegisterMsg($WM_AUTOITMOUSEMOVE,"myfunc")

GUIRegisterMsg($HCBT_ACTIVATE,"myCBTfunc")

GUIRegisterMsg($WM_KEYDOWN,"myKeyfunc")
GUIRegisterMsg($WM_KEYUP,"myKeyfunc")


While 1
    $msg = GUIGetMsg()
    If $msg = -3 Then ExitLoop
WEnd

Func MyFunc($hWndGUI, $MsgID, $WParam, $LParam)
	$n += 1
    If $n > 25 Then
        $n = 25
        $buffer = StringTrimLeft($buffer,StringInStr($buffer,@LF))
    EndIf
    $buffer &= "Mouse: " & $MsgID & "," &  $WParam & "," &  $LParam & @LF
	ToolTip($buffer)
EndFunc

Func MyCBTFunc($hWndGUI, $MsgID, $WParam, $LParam)
	$n += 1
    If $n > 25 Then
        $n = 25
        $buffer = StringTrimLeft($buffer,StringInStr($buffer,@LF))
    EndIf
    $buffer &= "CBT: " & $MsgID & "," &  $WParam & "," &  $LParam & @LF
	ToolTip($buffer)
EndFunc

Func MyKeyFunc($hWndGUI, $MsgID, $WParam, $LParam)
	$n += 1
    If $n > 25 Then
        $n = 25
        $buffer = StringTrimLeft($buffer,StringInStr($buffer,@LF))
    EndIf
    $buffer &= "Keyboard: " & $MsgID & "," &  $WParam & "," &  $LParam & @LF
	ToolTip($buffer)
EndFunc

Func GoAway()
    Exit
EndFunc

Func OnAutoItExit()
    DLLCall("user32.dll","int","UnhookWindowsHookEx","hwnd",$hhMouse[0])
    DLLCall("user32.dll","int","UnhookWindowsHookEx","hwnd",$hhKey[0])
    DLLCall("user32.dll","int","UnhookWindowsHookEx","hwnd",$hhCBT[0])
    DLLCall("kernel32.dll","int","FreeLibrary","hwnd",$DLLinst[0])
EndFunc