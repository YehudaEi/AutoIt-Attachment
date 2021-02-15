#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Furnaceactive.ico
#AutoIt3Wrapper_outfile=MMCL.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=0.1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>

If Not FileExists("set.ini") Then
	IniWrite("set.ini", "playtime", "playtime", 0)
	IniWrite("set.ini", "settings", "mobile", $GUI_UNCHECKED)
EndIf

$gui = GUICreate("MMCL", 200, 85)

GUICtrlCreateLabel("Minikori's Minecraft Launcher v0.1", 5, 5)
$mobile = GUICtrlCreateCheckbox("Mobile", 5, 25)
$ptlab = GUICtrlCreateLabel("Playtime: " & Round(Number(IniRead("set.ini", "playtime", "playtime", 0))/3600000, 2) & " hours", 75, 28)
$launch = GUICtrlCreateButton("Launch MC", 5, 50, 190, 30)

GUISetIcon("Furnaceactive.ico")
GUICtrlSetState($mobile, IniRead("set.ini", "settings", "mobile", $GUI_UNCHECKED))
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			IniWrite("set.ini", "settings", "mobile", GUICtrlRead($mobile))
			ExitLoop
		Case $msg = $launch
			If GUICtrlRead($mobile) = $GUI_CHECKED Then DirCopy(@ScriptDir & "\.minecraft", @AppDataDir & "\.minecraft", 1)
			GUISetState(@SW_HIDE, $gui)
			RunWait("minecraft.exe")
			Do
				Sleep(1)
			Until WinExists("Minecraft")
			$timer = TimerInit()
			Do
				Sleep(1)
			Until Not WinExists("Minecraft")
			$dif = TimerDiff($timer)
			If GUICtrlRead($mobile) = $GUI_CHECKED Then DirCopy(@AppDataDir & "\.minecraft", @ScriptDir & "\.minecraft", 1)
			$playtime = IniRead("set.ini", "playtime", "playtime", 0)
			IniWrite("set.ini", "playtime", "playtime", Number($playtime)+$dif)
			GUICtrlSetData($ptlab, "Playtime: " & Round(Number(IniRead("set.ini", "playtime", "playtime", 0))/3600000, 2) & " hours")
			GUISetState(@SW_SHOW, $gui)
	EndSelect
WEnd
Exit