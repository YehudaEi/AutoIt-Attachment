#include <GUIConstants.au3>

HotKeySet("{ESC}", "_Terminate")
HotKeySet("#{SPACE}", "MonitoInfo")

Global Const $WM_SETTINGCHANGE = 0x001A ; for detecting workspace size change

Global Const $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 0x00000001
Global Const $DISPLAY_DEVICE_MULTI_DRIVER        = 0x00000002
Global Const $DISPLAY_DEVICE_PRIMARY_DEVICE      = 0x00000004
Global Const $DISPLAY_DEVICE_MIRRORING_DRIVER 	 = 0x00000008

Global Const $DISPLAY_DEVICE_ACTIVE 			 = 0x00000001
Global Const $DISPLAY_DEVICE_ATTACHED 			 = 0x00000002

Global Const $ENUM_CURRENT_SETTINGS = -1
Global Const $ENUM_REGISTRY_SETTINGS = -2
Global Const $MONITOR_DEFAULTTONULL = 0
Global Const $MONITOR_DEFAULTTOPRIMARY = 1
Global Const $MONITOR_DEFAULTTONEAREST = 2

Global Const $MONITORINFO = "int;int[4];int[4];int"
Global Const $WINDOWPLACEMENT = "uint;uint;uint;int[2];int[2];int[4]"
Global Const $DISPLAY_DEVICE = "int;char[32];char[128];int;char[128];char[128]"
Global Const $DEVMODE = "byte[32];short;short;short;short;int;int[2];int;int" & _
		";short;short;short;short;short;byte[32]" & _
		";short;ushort;int;int;int;int"

$dll = DllOpen("user32.dll")
GUIRegisterMsg($WM_SETTINGCHANGE,"_DetectWorkspaceChange")

While 1
;~ 	Sleep(100)
WEnd


Func _Terminate()
	GUIRegisterMsg($WM_SETTINGCHANGE,"")
	DllClose($dll)
	Exit
EndFunc

Func _DetectWorkspaceChange($hWnd, $nMsgID, $wParam, $lParam)
	; ensure change was something relevant
	If Dec(Hex($wParam)) = 47 Or $wParam = 0 Then
		MonitoInfo()
		Return $GUI_RUNDEFMSG
	EndIf
EndFunc ; ==> _DetectWorkspaceChange


Func MonitoInfo()
	Local $MonitorPos[1][5]
	Local $dev = 0
	Local $id = 0
	$msg = ""
	Local $dd = DllStructCreate($DISPLAY_DEVICE)
	DllStructSetData($dd, 1, DllStructGetSize($dd))
	
	Local $EnumDisplays = DllCall($dll, "int", "EnumDisplayDevices", "ptr", 0, "int", $dev, "ptr", DllStructGetPtr($dd), "int", 0)
	Local $StateFlag = Number(StringMid(Hex(DllStructGetData($dd, 4)), 3))
	While $EnumDisplays[0] <> 0
		If ($StateFlag <> $DISPLAY_DEVICE_MIRRORING_DRIVER) Then ;ignore virtual mirror displays ;And ($StateFlag <> 0)
			
			;get information about the display's position and the current display mode
			Local $dm = DllStructCreate($DEVMODE)
			DllStructSetData($dm, 4, DllStructGetSize($dm))
			Local $EnumDisplaysEx = DllCall($dll, "int", "EnumDisplaySettingsEx", "str", DllStructGetData($dd, 2), "int", $ENUM_CURRENT_SETTINGS, "ptr", DllStructGetPtr($dm), "int", 0)
			If $EnumDisplaysEx[0] = 0 Then
				DllCall($dll, "int", "EnumDisplaySettingsEx", "str", DllStructGetData($dd, 2), "int", $ENUM_REGISTRY_SETTINGS, "ptr", DllStructGetPtr($dm), "int", 0)
			EndIf
			;get the monitor handle and workspace
			Local $hm
			Local $mi = DllStructCreate($MONITORINFO)
			DllStructSetData($mi, 1, DllStructGetSize($mi))
			If Mod($StateFlag, 2) <> 0 Then ; $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP
				;display is enabled. only enabled displays have a monitor handle
				$hm = DllCall($dll, "hwnd", "MonitorFromPoint", "int", DllStructGetData($dm, 7, 1), "int", DllStructGetData($dm, 7, 2), "int", 0)
				If $hm[0] <> 0 Then
					DllCall($dll, "int", "GetMonitorInfo", "hwnd", $hm[0], "ptr", DllStructGetPtr($mi))
				EndIf
			EndIf
			;format information about this monitor
			If $hm[0] <> 0 And DllStructGetData($mi, 3, 3) - DllStructGetData($mi, 3, 1) <> 0 Then
				$id += 1
				ReDim $MonitorPos[$id+1][5]
				$MonitorPos[$id][0] = $id
				$MonitorPos[$id][1] = DllStructGetData($mi, 3, 1)
				$MonitorPos[$id][2] = DllStructGetData($mi, 3, 2)
				$MonitorPos[$id][3] = DllStructGetData($mi, 3, 3) - $MonitorPos[$id][1]
				$MonitorPos[$id][4] = DllStructGetData($mi, 3, 4) - $MonitorPos[$id][2]
				
				$msg &= "workspace:" & $hm[0] & ": " & _
						DllStructGetData($mi, 3, 1) & "," & _
						DllStructGetData($mi, 3, 2) & " to " & _
						DllStructGetData($mi, 3, 3) & "," & _
						DllStructGetData($mi, 3, 4) & Chr(13)
				
			EndIf
		EndIf
		
		$dev += 1
		$EnumDisplays = 0
		$EnumDisplays = DllCall($dll, "int", "EnumDisplayDevices", "ptr", 0, "int", $dev, "ptr", DllStructGetPtr($dd), "int", 0)  ; PROBLEM IS RIGHT HERE ; PROBLEM IS RIGHT HERE ;; PROBLEM IS RIGHT HERE ;; PROBLEM IS RIGHT HERE ;
		ConsoleWrite(@ScriptLineNumber & ":error:" & @error & @CRLF) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ConsoleWrite(@ScriptLineNumber & ":$EnumDisplays[0]:" & $EnumDisplays[0] & @CRLF) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		$StateFlag = Number(StringMid(Hex(DllStructGetData($dd, 4)), 3))
	WEnd
	$MonitorPos[0][0] = $id
	
	; free memory
	$dd = 0
	$dm = 0
	$mi = 0
	ConsoleWrite($msg)
	Return $MonitorPos
EndFunc