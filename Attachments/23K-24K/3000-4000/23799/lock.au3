#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=lock.lck
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <string.au3>
#include "securun.au3"
$securunkey = _StringEncrypt(1, @YDAY + @MDAY + @HOUR + @MIN + @MON, "securun")
If @Compiled = 1 Then
	If $cmdline[1] <> $securunkey Then
		If $cmdline[0] <> 2 Then
			MsgBox(32,"","ERROR 0x00001CA: YOU ARE NOT AUTHORIZED TO USE THIS APPLICATION")
		Else
			_secure_run(@ScriptFullPath & ' ' & $securunkey & " " & $cmdline[2])
			Exit
		EndIf
	EndIf
Else
	MsgBox(0,@ScriptFullPath,@Compiled & " " & $cmdlineraw)
EndIf
Global $mp
$pass = $cmdline[2]
;~ $pass = "lol"
$mp = MouseGetPos()
SplashTextOn("Autoit Lock", "locked. press p to bring up the password screen", @DesktopWidth, @DesktopHeight, Default, Default, 3, "Times New Roman", 72, 700)
$locked = 1
HotKeySet("p", "_Passwd")
$splash = 1
HotKeySet("p", "_Passwd")
While 1
	MouseMove($mp[0], $mp[1], 0)
	WinActivate("Autoit Lock")
WEnd
Func _Passwd()
	SplashOff()
	HotKeySet("p")
	$pwin = GUICreate("password", @DesktopWidth, @DesktopHeight)
	GUICtrlCreateLabel("Password", @DesktopWidth / 2, (@DesktopHeight / 2) - 12)
	$p = GUICtrlCreateInput("", @DesktopWidth / 2, (@DesktopHeight / 2))
	$s = GUICtrlCreateButton("Submit", @DesktopWidth / 2 - 20, (@DesktopHeight / 2) + 20)
	$c = GUICtrlCreateButton("Cancel", @DesktopWidth / 2 + 20, (@DesktopHeight / 2) + 20)
	GUISetState()
	While 1
		If $locked = 1 Then
			WinActive("password")
			ProcessClose("taskmgr.exe")
		EndIf
		$msg = GUIGetMsg()
		Switch $msg
			Case $c
				_lock()
				GUIDelete($pwin)
				Return
			Case $s
				$pp = GUICtrlRead($p)
				If $pp = $pass Then
					Exit
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>_Passwd
Func _lock()
	$mp = MouseGetPos()
	SplashTextOn("PixelSoft Lock", "locked. press p to bring up the password screen", @DesktopWidth, @DesktopHeight, Default, Default, 3, "Times New Roman", 72, 700)
	HotKeySet("p", "_Passwd")
EndFunc   ;==>_lock