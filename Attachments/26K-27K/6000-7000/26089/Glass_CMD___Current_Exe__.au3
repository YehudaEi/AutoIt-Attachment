#include <Misc.au3>
#include <Process.au3>
#Include <WinAPI.au3>
Opt("TrayMenuMode",1) 

Global Const $HSHELL_WINDOWCREATED = 1
Global Const $HSHELL_WINDOWACTIVATED = 4;
Global Const $HWND_MESSAGE  = -3
Global $bHook = 1

$hGui = GUICreate("", 10, 10, -1, 0,-1,-1,$HWND_MESSAGE)
GUIRegisterMsg(_WinAPI_RegisterWindowMessage("SHELLHOOK"), "HookProc")
ShellHookWindow($hGui, $bHook)
ClearMemory()
$About = TrayCreateItem("About")
TrayCreateItem("")
$Exit = TrayCreateItem("Exit")

While 1
	Switch TrayGetMsg()
		Case $About
			MsgBox("","","Glass CMD for Windows Vista/Seven By Komalo - komalo.deviantart.com")
		Case $Exit
			Exit
	EndSwitch
WEnd

Func HookProc($hWnd, $Msg, $wParam, $lParam)
	Switch $wParam 
		Case $HSHELL_WINDOWCREATED
		If _ProcessGetName(WinGetProcess($lParam)) = "cmd.exe" Then 
			EnableBlurBehind($lParam)
			If @error Then MsgBox(16, "Glass CMD", "You are not running Vista!")
			ClearMemory()
		EndIf
	Case $HSHELL_WINDOWACTIVATED
		ClearMemory()
	EndSwitch
EndFunc

Func ShellHookWindow($hWnd, $bFlag)
    Local $sFunc = 'DeregisterShellHookWindow'
    If $bFlag Then $sFunc = 'RegisterShellHookWindow'
    Local $aRet = DllCall('user32.dll', 'int', $sFunc, 'hwnd', $hWnd)
    Return $aRet[0]
EndFunc

Func EnableBlurBehind($hWnd)
	Const $DWM_BB_ENABLE = 0x00000001
	$Struct = DllStructCreate("dword;int;ptr;int")
	DllStructSetData($Struct,1,$DWM_BB_ENABLE)
	DllStructSetData($Struct,2,"1")
	DllStructSetData($Struct,4,"1")
	DllCall("dwmapi.dll","int","DwmEnableBlurBehindWindow","hwnd",$hWnd,"ptr",DllStructGetPtr($Struct))
EndFunc

Func ClearMemory()
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory