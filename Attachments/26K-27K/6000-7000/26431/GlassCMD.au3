#include <Misc.au3>
#include <Process.au3>
#include <WinAPI.au3>

If @OSVersion <> "WIN_VISTA" Then
	MsgBox(16, "Glass CMD", "You must be running Windows Vista/Seven to use this!")
	Exit
Else
	; Are they running Aero
	If Not _Vista_IsAero() Then
		MsgBox(16, "Glass CMD", "You must have Aero turned on before running Glass CMD!")
	EndIf
EndIf

; We only want one script running
If _Singleton("Glass CMD", 1) = 0 Then
	Exit ; Just Exit
EndIf

Opt("TrayMenuMode", 1)

Global Const $HSHELL_WINDOWCREATED = 1
Global Const $HSHELL_WINDOWACTIVATED = 4;
Global Const $HWND_MESSAGE = -3
Global $bHook = 1

$hGui = GUICreate("", 10, 10, -1, 0, -1, -1, $HWND_MESSAGE)
GUIRegisterMsg(_WinAPI_RegisterWindowMessage("SHELLHOOK"), "HookProc")
ShellHookWindow($hGui, $bHook)
ClearMemory()
$About = TrayCreateItem("About")
TrayCreateItem("")
$Exit = TrayCreateItem("Exit")

While 1
	Switch TrayGetMsg()
		Case $About
			MsgBox("", "", "Glass CMD for Windows Vista/Seven By Komalo - komalo.deviantart.com")
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
EndFunc   ;==>HookProc

Func ShellHookWindow($hWnd, $bFlag)
	Local $sFunc = 'DeregisterShellHookWindow'
	If $bFlag Then $sFunc = 'RegisterShellHookWindow'
	Local $aRet = DllCall('user32.dll', 'int', $sFunc, 'hwnd', $hWnd)
	Return $aRet[0]
EndFunc   ;==>ShellHookWindow

Func EnableBlurBehind($hWnd)
	Const $DWM_BB_ENABLE = 0x00000001
	$Struct = DllStructCreate("dword;int;ptr;int")
	DllStructSetData($Struct, 1, $DWM_BB_ENABLE)
	DllStructSetData($Struct, 2, "1")
	DllStructSetData($Struct, 4, "1")
	DllCall("dwmapi.dll", "int", "DwmEnableBlurBehindWindow", "hwnd", $hWnd, "ptr", DllStructGetPtr($Struct))
EndFunc   ;==>EnableBlurBehind

Func ClearMemory()
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	Return $ai_Return[0]
EndFunc   ;==>ClearMemory

Func _Vista_IsAero()
	$ICEStruct = DllStructCreate("int;")
	$Ret = DllCall("dwmapi.dll", "int", "DwmIsCompositionEnabled", "ptr", DllStructGetPtr($ICEStruct))
	If @error Then
		Return 0
	Else
		Return DllStructGetData($ICEStruct, 1)
	EndIf
EndFunc   ;==>_Vista_ICE