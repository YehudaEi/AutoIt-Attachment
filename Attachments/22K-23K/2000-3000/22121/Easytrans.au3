#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Easytrans.exe
#AutoIt3Wrapper_Res_Comment=Easy to use transparency tool!
#AutoIt3Wrapper_Res_Description=Transparency made easy!
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=None
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field="Creator"|"TheMadman"
#AutoIt3Wrapper_Res_Field="Programming Language"|"AutoItv3"
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<Misc.au3>
#include<SliderConstants.au3>
#include<GUIConstants.au3>
#include<WindowsConstants.au3>
#include<Array.au3>
#include<Constants.au3>
AdlibEnable("_hotmouse", 10)
Dim $arr1[10000], $arr2[10000]
Global $count = 0, $color = 0x000000, $gui = 0, $asd = 0
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 11)
Opt("TrayOnEventMode", 1)
$op = TrayCreateMenu("Options")
$as = TrayCreateItem("Start with windows", $op)
TrayItemSetOnEvent(-1, "autostart")
TrayCreateItem("Background color", $op)
TrayItemSetOnEvent(-1, "bgck")
TrayCreateItem("")
TrayCreateItem("H&elp")
TrayItemSetOnEvent(-1, "help")
TrayCreateItem("A&bout")
TrayItemSetOnEvent(-1, "about")
TrayCreateItem("")
$q = TrayCreateItem("E&xit")
TrayItemSetOnEvent($q, "quit")
checkstart()
While 1
	Sleep(1)
WEnd
Func _hotmouse()
	If _IsPressed(01) Then
		$zpos = MouseGetPos()
		GUIDelete($gui)
		$asd = WinGetHandle("")
		While _IsPressed(01)
			Sleep(1)
		WEnd
		$xpos = MouseGetPos()
		If $zpos[0] <> $xpos[0] Or $zpos[1] <> $xpos[1] Then Return
		$title = WinGetTitle($asd)
		;If $title=0 Then Return
		$pos = WinGetPos($title)
		$mpos = MouseGetPos()
		If Not IsArray($pos) Then Return
		If $mpos[1] - $pos[1] > 20 Then Return
		If WinGetHandle("[CLASS:Shell_TrayWnd]") = $asd Or $title = "Program Manager" Then Return
		$gui = GUICreate("", 120, 20, $pos[0] + $pos[2] / 2 - 60, $pos[1] + 2, $WS_POPUP)
		GUISetBkColor($color)
		GUISetState()
		WinSetOnTop($gui, "", 1)
		_scroll($asd)
	EndIf
EndFunc   ;==>_hotmouse
Func _scroll($handle)
	$title = WinGetTitle($handle)
	$asd = GUICtrlCreateSlider(0, 0, 120, 20, $TBS_NOTICKS)
	GUICtrlSetBkColor(-1, $color)
	$x = _ArraySearch($arr1, $handle, 0, $count + 1)
	GUICtrlSetLimit(-1, 253, 30)
	If $x <> -1 Then
		GUICtrlSetData(-1, $arr2[$x])
	Else
		GUICtrlSetData(-1, 253)
	EndIf
	$old = 0
	While 1
		$gci = GUIGetCursorInfo($gui)
		If _IsPressed(01) Then
			If $gci[4] = $asd Then
				While _IsPressed(01)
					$new = GUICtrlRead($asd)
					If $new <> $old Then
						WinSetTrans($title, "", $new)
						$old = $new
					EndIf
					Sleep(1)
				WEnd
				If $x = -1 Then
					$arr1[$count] = $handle
					$arr2[$count] = $new
					$count += 1
				Else
					$arr2[$x] = $new
				EndIf
			Else
				While _IsPressed(01)
					Sleep(1)
				WEnd
			EndIf
			GUIDelete($gui)
			Return
		EndIf
	WEnd
EndFunc   ;==>_scroll

Func quit()
	$msg = MsgBox(36, "Easytrans exit", "Are you sure you want to quit easytrans?")
	If $msg = 6 Then Exit
EndFunc   ;==>quit

Func help()
	MsgBox(0, "A helping hand", "Just click on the title of a window and move the slider to change it's transparency")
EndFunc   ;==>help
Func about()
	MsgBox(0, "", "Easytrans by Alexmadman AKA TheMadman" & Chr(153) & " @ AutoItv3")
EndFunc   ;==>about
Func autostart()
	$z = TrayItemGetState($as)
	If BitAND($z, $TRAY_CHECKED) = 1 Then
		;;debifat (nu porneste)
		TrayItemSetState($as, $TRAY_UNCHECKED)
		RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Easytrans")
	ElseIf BitAND($z, $TRAY_UNCHECKED) Then
		;;bifat(porneste)
		TrayItemSetState($as, $TRAY_CHECKED)
		$asd = RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Easytrans", "REG_SZ", @ScriptFullPath)
		If $asd = 0 Then
			MsgBox(16, "Error", "Unalble to write to the system registry!" & @CRLF & "Check firewall settings and/or system permissions and try again")
			TrayItemSetState($as, $TRAY_UNCHECKED)
		EndIf
	EndIf
EndFunc   ;==>autostart
Func bgck()
	$new = _ChooseColor(2, $color)
	If $new <> -1 Then
		$color = $new
		IniWrite(@MyDocumentsDir & "\easytrans", "settings", "bgcolor", $color)
	EndIf
EndFunc   ;==>bgck
Func checkstart()
	$color = IniRead(@MyDocumentsDir & "\easytrans", "settings", "bgcolor", 0x000000)
	$data = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Easytrans")
	If $data <> "" Then
		TrayItemSetState($as, $TRAY_CHECKED)
		If $data <> @ScriptFullPath Then
			$asd = RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Easytrans", "REG_SZ", @ScriptFullPath)
			If $asd = 0 Then
				MsgBox(16, "Error", "Unalble to write to the system registry!" & @CRLF & "Check firewall settings and/or system permissions and try again" & @CRLF & "(the executable was moved so it tried to refresh the registry with the new path)")
				TrayItemSetState($as, $TRAY_UNCHECKED)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>checkstart