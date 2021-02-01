#include <Misc.au3>
#include <Process.au3>
#Include <WinAPI.au3>
Opt('TrayMenuMode',1)

$HideTrayIcon = IniRead('Settings.ini', 'Settings', 'HideTrayIcon', 'DoesNotExist')

If $HideTrayIcon == 1 Then
    Opt('TrayIconHide', 1)
EndIf

Global Const $HSHELL_WINDOWCREATED = 1
Global Const $HSHELL_WINDOWACTIVATED = 4
Global Const $HWND_MESSAGE  = -3
Global $bHook = 1

$hGui = GUICreate('', 10, 10, -1, 0,-1,-1,$HWND_MESSAGE)
GUIRegisterMsg(_WinAPI_RegisterWindowMessage('SHELLHOOK'), 'HookProc')
ShellHookWindow($hGui, $bHook)
ClearMemory()
$About = TrayCreateItem('About')
TrayCreateItem('')
$Exit = TrayCreateItem('Exit')

While 1
	Switch TrayGetMsg()
		Case $About
			MsgBox('','About','Glass PowerShell for Windows Vista/Seven By Vadersapien.')
		Case $Exit
			Exit
	EndSwitch
WEnd

Func HookProc($hWnd, $Msg, $wParam, $lParam)
	Switch $wParam
		Case $HSHELL_WINDOWCREATED
		$pname = _ProcessGetName(WinGetProcess($lParam))
		If $pname = 'powershell.exe' Then
			If DwmIsCompositionEnabled() Then
			    DwmExtendFrameIntoClientArea($lParam)
			    ClearMemory()
			EndIf
		EndIf
		If $pname = 'notepad2.exe' Then
			If DwmIsCompositionEnabled() Then
			    DwmExtendFrameIntoClientArea($lParam)
			    ClearMemory()
			EndIf
		EndIf
		If $pname = 'cmd.exe' Then
			If DwmIsCompositionEnabled() Then
			    DwmExtendFrameIntoClientArea($lParam)
			    ClearMemory()
			EndIf
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

Func DwmExtendFrameIntoClientArea($hWnd)
	$struct=DllStructCreate('int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;')
    DllStructSetData($struct,'cxLeftWidth',-1)
    DllStructSetData($struct,'cxRightWidth',-1)
    DllStructSetData($struct,'cyTopHeight',-1)
    DllStructSetData($struct,'cyBottomHeight',-1)
    Return DllCall('dwmapi.dll', 'int', 'DwmExtendFrameIntoClientArea', 'hwnd', $hWnd, 'ptr', DllStructGetPtr($struct))
EndFunc

Func DwmIsCompositionEnabled()
    Local $aResult = DllCall("dwmapi.dll", "int", "DwmIsCompositionEnabled", "int*", 0)

    If @error Then Return SetError(@error, @extended, -1)
    Return SetError($aResult[0], 0, $aResult[1])
EndFunc

Func ClearMemory()
	Local $ai_Return = DllCall('psapi.dll', 'int', 'EmptyWorkingSet', 'long', -1)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func OnAutoItExit()
    If $hGui Then
        ShellHookWindow($hGui, 0)
    EndIf
EndFunc  ;==>OnAutoItExit

