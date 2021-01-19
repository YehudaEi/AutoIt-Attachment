#include <GuiConstants.au3>
#include <Misc.au3>

#NoTrayIcon
Opt("GUICloseOnESC", 0)
Opt("GUIOnEventMode", 1)
Opt("WinWaitDelay", 0)

Global Const $WM_SYSCOMMAND = 0x0112
Global Const $SC_MOVE = 0xF010
Global Const $SC_SIZE = 0xF000
Global Const $SC_CLOSE = 0xF060

;ShellHook notification codes:
Global Const $HSHELL_WINDOWCREATED = 1;
Global Const $HSHELL_WINDOWDESTROYED = 2;
Global Const $HSHELL_ACTIVATESHELLWINDOW = 3;
Global Const $HSHELL_WINDOWACTIVATED = 4;
Global Const $HSHELL_GETMINRECT = 5;
Global Const $HSHELL_REDRAW = 6;
Global Const $HSHELL_TASKMAN = 7;
Global Const $HSHELL_LANGUAGE = 8;
Global Const $HSHELL_SYSMENU = 9;
Global Const $HSHELL_ENDTASK = 10;
Global Const $HSHELL_ACCESSIBILITYSTATE = 11;
Global Const $HSHELL_APPCOMMAND = 12;
Global Const $HSHELL_WINDOWREPLACED = 13;
Global Const $HSHELL_WINDOWREPLACING = 14;
Global Const $HSHELL_RUDEAPPACTIVATED = 32772;
Global Const $HSHELL_FLASH = 32774;

Global $bHook = 1
;GUI stuff:

Global $iGuiW = 400, $iGuiH = 50, $sTitle = "Shell Hooker", $aBtnText[2] = ["START", "STOP"]
$hGui = GUICreate($sTitle, $iGuiW, $iGuiH, -1, 0, $WS_POPUP+$WS_BORDER, $WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE, "SysEvents")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "SysEvents")
GUIRegisterMsg($WM_SYSCOMMAND, "On_WM_SYSCOMMAND")
$cBtnMini = GUICtrlCreateButton("v", $iGuiW-$iGuiH, 0, $iGuiH/2, $iGuiH/2)
GUICtrlSetOnEvent(-1, "CtrlEvents")
GUICtrlSetTip(-1, "Minimize")
$cBtnClose = GUICtrlCreateButton("X", $iGuiW-$iGuiH/2, 0, $iGuiH/2, $iGuiH/2)
GUICtrlSetOnEvent(-1, "CtrlEvents")
GUICtrlSetTip(-1, "Exit")
$cBtnHook = GUICtrlCreateButton("", $iGuiW-$iGuiH, $iGuiH/2, $iGuiH, $iGuiH/2)
GUICtrlSetData(-1, $aBtnText[$bHook])
GUICtrlSetTip(-1, "Hook/Unhook Shell")
GUICtrlSetOnEvent(-1, "CtrlEvents")
$cList = GUICtrlCreateList("", 0, 0, $iGuiW-$iGuiH-1, $iGuiH, $LBS_NOINTEGRALHEIGHT+$WS_VSCROLL)
GUICtrlSetOnEvent(-1, "CtrlEvents")

;Hook stuff:
GUIRegisterMsg(RegisterWindowMessage("SHELLHOOK"), "HShellWndProc")
ShellHookWindow($hGui, $bHook)


GUISetState()

While 1
	Sleep(1000)
WEnd

Func SysEvents()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_EVENT_PRIMARYDOWN
			;CTRL + Left click to drag GUI
			If _IsPressed("11") Then
				DllCall("user32.dll", "int", "ReleaseCapture")
				DllCall("user32.dll", "int", "SendMessage", "hWnd", $hGui, "int", 0xA1, "int", 2, "int", 0)
			EndIf
	EndSwitch
EndFunc
Func CtrlEvents()
	Switch @GUI_CtrlId
		Case $cBtnMini
			GUISetState(@SW_MINIMIZE)
		Case $cBtnClose
			_SendMessage($hGui, $WM_SYSCOMMAND, $SC_CLOSE, 0)
		Case $cBtnHook
			$bHook = BitXOR($bHook, 1)
			ShellHookWindow($hGui, $bHook)
			GUICtrlSetData($cBtnHook, $aBtnText[$bHook])
	EndSwitch	
EndFunc
Func HShellWndProc($hWnd, $Msg, $wParam, $lParam)
	Switch $wParam
		Case $HSHELL_WINDOWCREATED
			MsgPrint("Window created: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case $HSHELL_WINDOWDESTROYED
			MsgPrint("Window destroyed: " & $lParam)
		Case $HSHELL_ACTIVATESHELLWINDOW
			MsgPrint("HSHELL_ACTIVATESHELLWINDOW: Not used.");
		Case $HSHELL_WINDOWACTIVATED
			MsgPrint("Window activated: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case $HSHELL_GETMINRECT
			Local $tSHELLHOOKINFO = DllStructCreate("hwnd hwnd;int left;long top;long right;long bottom", $lParam)
			MsgPrint("HSHELL_GETMINRECT: " & HWnd(DllStructGetData($tSHELLHOOKINFO, "hwnd")) & ' (' & _
											DllStructGetData($tSHELLHOOKINFO, "left") & ',' & _
											DllStructGetData($tSHELLHOOKINFO, "top") & ',' & _	
											DllStructGetData($tSHELLHOOKINFO, "right") & ',' & _	
											DllStructGetData($tSHELLHOOKINFO, "bottom") & ')')
		Case $HSHELL_REDRAW
			MsgPrint("Window redraw: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case $HSHELL_TASKMAN
			MsgPrint("HSHELL_TASKMAN: Can be ignored.");
		Case $HSHELL_LANGUAGE
			MsgPrint("HSHELL_LANGUAGE: " & $lParam);
		Case $HSHELL_SYSMENU
			MsgPrint("HSHELL_SYSMENU: " & $lParam);
		Case $HSHELL_ENDTASK
			MsgPrint("Window needs to be closed: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case $HSHELL_ACCESSIBILITYSTATE
			MsgPrint("HSHELL_ACCESSIBILITYSTATE: " & $lParam);
		Case $HSHELL_APPCOMMAND
			MsgPrint("HSHELL_APPCOMMAND: " & $lParam);
		Case $HSHELL_WINDOWREPLACED
			MsgPrint("Window replaced: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case $HSHELL_WINDOWREPLACING
			MsgPrint("Window replacing: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case $HSHELL_RUDEAPPACTIVATED
			MsgPrint("HSHELL_RUDEAPPACTIVATED: " & $lParam);
		Case $HSHELL_FLASH
			MsgPrint("Window flash: " & $lParam & " (" & WinGetTitle($lParam) & ")")
		Case Else
			MsgPrint("Unknown ShellHook message: " & $wParam & " , " & $lParam)
	EndSwitch
EndFunc
;register/unregister ShellHook
Func ShellHookWindow($hWnd, $bFlag)
	Local $sFunc = 'DeregisterShellHookWindow'
	If $bFlag Then $sFunc = 'RegisterShellHookWindow'
	Local $aRet = DllCall('user32.dll', 'int', $sFunc, 'hwnd', $hWnd)
	MsgPrint($sFunc & ' = ' & $aRet[0])
	Return $aRet[0]
EndFunc
Func MsgPrint($sText)
	ConsoleWrite($sText & @CRLF)
	GUICtrlSendMsg($cList, $LB_SETCURSEL, GUICtrlSendMsg($cList, $LB_ADDSTRING, 0, $sText), 0)
EndFunc
;register window message
Func RegisterWindowMessage($sText)
	Local $aRet = DllCall('user32.dll', 'int', 'RegisterWindowMessage', 'str', $sText)
	Return $aRet[0]
EndFunc
Func On_WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
    Switch BitAND($wParam, 0xFFF0)
        Case $SC_MOVE, $SC_SIZE
		Case $SC_CLOSE
			ShellHookWindow($hGui, 0)
			Return $GUI_RUNDEFMSG
			;Exit
	EndSwitch
EndFunc