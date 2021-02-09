#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=ic.ico
#AutoIt3Wrapper_outfile=DropIt.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=DropIt - To sort your files with a drop
#AutoIt3Wrapper_Res_Fileversion=0.9.5.0
#AutoIt3Wrapper_Res_ProductVersion=0.9.5.0
#AutoIt3Wrapper_Res_LegalCopyright=Lupo PenSuite Team
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Info: http://www.autoitscript.com/autoit3/scite/docs/AutoIt3Wrapper.htm
; Icons added to the resources can be used with TraySetIcon(@ScriptFullPath, -5) etc. and are stored with numbers -5, -6...

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#Include <GUIListBox.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <File.au3>

Opt("MustDeclareVars", 1)
Opt("TrayIconHide", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

Global $sName = "DropIt", $sVer = " (v0.9.5)", $ii = $sName & " - To sort your files with a drop"
Global $sIni = @ScriptDir & "\settings.ini", $sIniPr, $PrDir = @ScriptDir & "\profiles", $ImDir = @ScriptDir & "\img", $sWork = $ImDir & "\zz.gif", $ImDef = "Default.gif", $sIm = $ImDir & "\" & $ImDef
Global $hGUI, $hGUI2, $sIcon, $sIcon2, $sData, $Dummy, $hListView, $temp, $i, $top, $Show, $Separ, $Exit, $menu, $func1, $func3, $func2, $func4, $func5, $func6, $custom, $specialClick
Global Const $WM_DROPFILES = 0x233, $WM_ENTERSIZEMOVE = 0x231, $WM_EXITSIZEMOVE = 0x232
Global $gaDropFiles[1], $RelPos[2], $EP = "Exclusion-Pattern"
Global $tips = '- As destination folders are supported both absolute ("C:\Lupo\My Images") and relative ("..\My Images") paths.' & @LF & @LF & '- If you want to use different pattern groups, for example on different computers, you can click "Profiles" -> "Customize" to create and manage them.' & @LF & @LF & '- If you want to exclude files that match with a specified pattern, you can add "$" at the end of the pattern itself (for example:  *.exe$ ).' & @LF & @LF & '- If you need more info about supported pattern rules, you can click the "Rules" button and see a list of possible patterns.'
Global $prs = 'Examples of supported pattern rules for files:' & @LF & '*.zip   = all files with "zip" extension' & @LF & 'penguin.*   = all files named "penguin"' & @LF & 'penguin*.*   = all files that begin with "penguin"' & @LF & '*penguin*   = all files that contain "penguin"' & @LF & @LF & 'Examples of supported pattern rules for folders:' & @LF & 'robot**   = all folders that begin with "robot"' & @LF & '**robot   = all folders that end with "robot"' & @LF & '**robot**   = all folders that contain "robot"' & @LF & @LF & 'Add "$" at the end of a pattern to skip loaded' & @LF & 'files that match with it (eg:  sky*.jpg$ ).' & @LF & @LF & 'Separate several strings in a pattern with ";" to' & @LF & 'create multi-string patterns (eg:  *.jpg;*.png ).'
Global $er1 = "You have to select a destination folder to associate it.", $er2 = "You have to insert a correct pattern to add the association.", $er3 = "This pattern rule already exists.", $er4 = "You are running " & $sName & " with an invalid profile.", $me1 = "Insert the desired destination folder and write a pattern, to place there files that match with it:", $me2 = "Change this pattern, the destination folder for files that match with it or delete this association:"


_Main()


Func Manage()
	Local $DFA, $sel, $close, $help, $tem, $var, $ff, $decision
	Local $hListBox, $Dir1, $Dir2, $fo1, $fo2, $se1, $se2, $bot1, $bot2, $bot3, $bot4
	$DFA = GUICreate("Destination Folders Association [" & IniRead($sIni, "General", "Profile", "Default") & "]", 420, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI)
	
	GUICtrlCreateGroup("Add Association", 10, 6, 280, 115)
	GUICtrlCreateLabel($me1, 21, 6+17, 260, 40)
	$Dir1 = GUICtrlCreateInput("", 18, 6+50, 207, 20)
	$se1 = GUICtrlCreateButton("Folder", 286-60, 6+49, 56, 22)
	GUICtrlSetTip($se1, "Select a destination folder")
	$bot1 = GUICtrlCreateButton("Rules", 150-54-64, 6+79, 64, 24)
	GUICtrlSetTip($bot1, "Info about supported pattern rules")
	$fo1 = GUICtrlCreateInput("", 150-39, 6+81, 78, 20)
	GUICtrlSetTip($fo1, "Write here the desired pattern")
	$bot2 = GUICtrlCreateButton("Apply", 150+54, 6+79, 64, 24)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateGroup("Edit Associations", 10, 125, 280, 115)
	GUICtrlCreateLabel($me2, 21, 125+17, 260, 40)
	$Dir2 = GUICtrlCreateInput("", 18, 125+50, 207, 20)
	$se2 = GUICtrlCreateButton("Folder", 286-60, 125+49, 56, 22)
	GUICtrlSetTip($se2, "Change the destination folder")
	$bot3 = GUICtrlCreateButton("Delete", 150-54-64, 125+79, 64, 24)
	GUICtrlSetTip($bot3, "Delete this association")
	$fo2 = GUICtrlCreateInput("", 150-39, 125+81, 78, 20)
	$bot4 = GUICtrlCreateButton("Apply",150+54, 125+79, 64, 24)
	GUICtrlSetState($Dir2, $GUI_DISABLE)
	GUICtrlSetState($se2, $GUI_DISABLE)
	GUICtrlSetState($bot3, $GUI_DISABLE)
	GUICtrlSetState($bot4, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateGroup("Pattern List", 300, 6, 110, 234)
	$hListBox = GUICtrlCreateList("", 308, 6+18, 94, 211, BitOr($LBS_DISABLENOSCROLL, $LBS_STANDARD, $LBS_SORT))
	$var = IniReadSection($sIniPr, "Patterns")
	If Not @error Then
		For $i = 1 To $var[0][0]
			_GUICtrlListBox_AddString($hListBox, $var[$i][0])
		Next
	EndIf
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$help = GUICtrlCreateButton("Help", 205-30-100, 247, 100, 24)
	$close = GUICtrlCreateButton("Close", 205+30, 247, 100, 24)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $se1
				If $top = "True" Then WinSetOnTop($DFA, "", 0)
				$tem = FileSelectFolder("Select a destination folder:", "", 3)
				If $tem <> "" Then GUICtrlSetData($Dir1, $tem)
				If $top = "True" Then WinSetOnTop($DFA, "", 1)
				
			Case $se2
				If $top = "True" Then WinSetOnTop($DFA, "", 0)
				$tem = FileSelectFolder("Select a destination folder:", "", 3)
				If $tem <> "" Then GUICtrlSetData($Dir2, $tem)
				If $top = "True" Then WinSetOnTop($DFA, "", 1)
				
			Case $bot1
				MsgBox(0x40000, "Supported pattern rules", $prs)
				
			Case $bot2
				$tem = GUICtrlRead($Dir1)
				$ff = StringLower(GUICtrlRead($fo1))
				If $ff = "" Or Not(StringInStr($ff, "*")) Then
					MsgBox(0x40000, "Message", $er2)
				Else
					If IniRead($sIniPr, "Patterns", $ff, "0") = "0" Then
						If StringRight($ff, 1) = "$" Then $tem = $EP
						If $tem = "" Then
							MsgBox(0x40000, "Message", $er1)
						Else
							IniWrite($sIniPr, "Patterns", $ff, $tem)
							_GUICtrlListBox_AddString($hListBox, $ff)
							GUICtrlSetData($Dir1, "")
							GUICtrlSetData($fo1, "")
						EndIf
					Else
						MsgBox(0x40000, "Message", $er3)
					EndIf
				EndIf
				
			Case $bot3
				$decision = MsgBox(0x40004, "Delete association", 'Are you sure to delete this association?')
				If $decision = 6 Then
					IniDelete($sIniPr, "Patterns", $ff)
					_GUICtrlListBox_DeleteString($hListBox, _GUICtrlListBox_FindString($hListBox, $ff))
					GUICtrlSetData($Dir2, "")
					GUICtrlSetData($fo2, "")
				EndIf
				
			Case $bot4
				$tem = GUICtrlRead($Dir2)
				If $tem = "" Then
					MsgBox(0x40000, "Message", $er1)
				Else
					If $ff = StringLower(GUICtrlRead($fo2)) Then
						IniWrite($sIniPr, "Patterns", $ff, $tem)
					ElseIf _GUICtrlListBox_FindString($hListBox, GUICtrlRead($fo2), True) <> -1 Then
						MsgBox(0x40000, "Message", $er3)
					Else
						IniDelete($sIniPr, "Patterns", $ff)
						_GUICtrlListBox_DeleteString($hListBox, _GUICtrlListBox_FindString($hListBox, $ff))
						$ff = StringLower(GUICtrlRead($fo2))
						IniWrite($sIniPr, "Patterns", $ff, $tem)
						_GUICtrlListBox_AddString($hListBox, $ff)
					EndIf
				EndIf
				
			Case $hListBox
				$ff = GUICtrlRead($hListBox)
				$tem = IniRead($sIniPr, "Patterns", $ff, "")
				If $tem <> "" Then
					GUICtrlSetState($bot3, $GUI_ENABLE)
					GUICtrlSetState($bot4, $GUI_ENABLE)
					If StringRight($ff, 1) = "$" Then
						GUICtrlSetState($Dir2, $GUI_DISABLE)
						GUICtrlSetState($se2, $GUI_DISABLE)
					Else
						GUICtrlSetState($Dir2, $GUI_ENABLE)
						GUICtrlSetState($se2, $GUI_ENABLE)
					EndIf
					GUICtrlSetData($Dir2, $tem)
					GUICtrlSetData($fo2, $ff)
				EndIf
				
			Case $help
					MsgBox(0x40000, "Tips and tricks", $tips)
				
			Case $close, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($DFA)
	If $top = "True" Then WinSetOnTop($hGUI, "", 1)
EndFunc


Func Options()
	Local $opz, $sel, $check1, $check2, $check3, $check4, $check5, $mod1, $mod2, $modA, $do1, $do2, $do3, $ok, $canc, $tp
	$opz = GUICreate("Options", 256, 256, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI)
	
	; group of general options
	GUICtrlCreateGroup("General",10, 6, 236, 124)
	$check1 = GUICtrlCreateCheckbox("Show target image always on top", 24, 6+16)
	$check2 = GUICtrlCreateCheckbox("Lock target image position", 24, 6+16+20)
	$check3 = GUICtrlCreateCheckbox("Enable association also for folders", 24, 6+16+40)
	$check4 = GUICtrlCreateCheckbox("Enable multiple instances", 24, 6+16+60)
	$check5 = GUICtrlCreateCheckbox("Set automatic choice for duplicates", 24, 6+16+80)
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	; group of update procedure options
	GUICtrlCreateGroup("Positioning mode", 10, 134, 110, 84)
	$mod1 = GUICtrlCreateRadio("Move files", 24, 134+16, 90, 20)
	$mod2 = GUICtrlCreateRadio("Copy files", 24, 134+16+20, 90, 20)
	$modA = GUICtrlCreateCheckbox("Ask each drop", 24, 134+16+40)
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	; group of update procedure options
	GUICtrlCreateGroup("Manage duplicates", 130, 134, 116, 84)
	$do1 = GUICtrlCreateRadio("Overwrite files", 144, 134+16, 90, 20)
	$do2 = GUICtrlCreateRadio("Skip files", 144, 134+16+20, 90, 20)
	$do3 = GUICtrlCreateRadio("Rename files", 144, 134+16+40, 90, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	If IniRead($sIni, "General", "Mode", "Move") = "Move" Then
		GUICtrlSetState($mod1, 1)
		GUICtrlSetState($mod2, 4)
	Else
		GUICtrlSetState($mod1, 4)
		GUICtrlSetState($mod2, 1)
	EndIf
	If IniRead($sIni, "General", "AskMode", "False") = "True" Then
		GUICtrlSetState($modA, $GUI_CHECKED)
		GUICtrlSetState($mod1, $GUI_DISABLE)
		GUICtrlSetState($mod2, $GUI_DISABLE)
	EndIf
	If IniRead($sIni, "General", "Duplicates", "Overwrite") = "Overwrite" Then
		GUICtrlSetState($do1, 1)
		GUICtrlSetState($do2, 4)
		GUICtrlSetState($do3, 4)
	ElseIf IniRead($sIni, "General", "Duplicates", "Overwrite") = "Skip" Then
		GUICtrlSetState($do1, 4)
		GUICtrlSetState($do2, 1)
		GUICtrlSetState($do3, 4)
	Else
		GUICtrlSetState($do1, 4)
		GUICtrlSetState($do2, 4)
		GUICtrlSetState($do3, 1)
	EndIf
	If IniRead($sIni, "General", "OnTop", "True") = "True" Then GUICtrlSetState($check1, $GUI_CHECKED)
	If IniRead($sIni, "General", "LockPos", "True") = "True" Then GUICtrlSetState($check2, $GUI_CHECKED)
	If IniRead($sIni, "General", "DirForFolders", "False") = "True" Then GUICtrlSetState($check3, $GUI_CHECKED)
	If IniRead($sIni, "General", "MultipleInst", "False") = "True" Then GUICtrlSetState($check4, $GUI_CHECKED)
	If IniRead($sIni, "General", "AutoForDup", "False") = "True" Then
		GUICtrlSetState($check5, $GUI_CHECKED)
	Else
		GUICtrlSetState($do1, $GUI_DISABLE)
		GUICtrlSetState($do2, $GUI_DISABLE)
		GUICtrlSetState($do3, $GUI_DISABLE)
	EndIf
	
	$ok = GUICtrlCreateButton("OK", 128-20-66, 226, 66, 24)
	$canc = GUICtrlCreateButton("Cancel", 128+20, 226, 66, 24)
	GUICtrlSetState($ok, $GUI_FOCUS)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $check5
				If GUICtrlRead($check5) = 1 Then
					GUICtrlSetState($do1, $GUI_ENABLE)
					GUICtrlSetState($do2, $GUI_ENABLE)
					GUICtrlSetState($do3, $GUI_ENABLE)
				Else
					GUICtrlSetState($do1, $GUI_DISABLE)
					GUICtrlSetState($do2, $GUI_DISABLE)
					GUICtrlSetState($do3, $GUI_DISABLE)
				EndIf
				
			Case $modA
				If GUICtrlRead($modA) = 1 Then
					GUICtrlSetState($mod1, $GUI_DISABLE)
					GUICtrlSetState($mod2, $GUI_DISABLE)
				Else
					GUICtrlSetState($mod1, $GUI_ENABLE)
					GUICtrlSetState($mod2, $GUI_ENABLE)
				EndIf
				
			Case $ok
				$top = "False"
				If GUICtrlRead($check1) = 1 Then
					$top = "True"
					WinSetOnTop($hGUI, "", 1)
				Else
					WinSetOnTop($hGUI, "", 0)
				EndIf
				IniWrite($sIni, "General", "OnTop", $top)
				
				$tp = "False"
				If GUICtrlRead($check2) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "LockPos", $tp)
				
				$tp = "False"
				If GUICtrlRead($check3) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "DirForFolders", $tp)
				
				$tp = "False"
				If GUICtrlRead($check4) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "MultipleInst", $tp)
				
				$tp = "False"
				If GUICtrlRead($check5) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "AutoForDup", $tp)
				
				If GUICtrlRead($do1) = 1 Then
					$tp = "Overwrite"
				ElseIf GUICtrlRead($do2) = 1 Then
					$tp = "Skip"
				Else
					$tp = "Rename"
				EndIf
				IniWrite($sIni, "General", "Duplicates", $tp)
				
				$tp = "Copy"
				If GUICtrlRead($mod1) = 1 Then $tp = "Move"
				IniWrite($sIni, "General", "Mode", $tp)
				
				$tp = "False"
				If GUICtrlRead($modA) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "AskMode", $tp)
				ExitLoop
				
			Case $canc, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($opz)
	If $top = "True" Then WinSetOnTop($hGUI, "", 1)
EndFunc


Func MoreMatches($matches, $item, $j)
	Local $asso, $sel, $ok, $canc, $rad[$j+1], $ma = "-1"
	Local $mess = 'You have to select the pattern to use or click "Cancel".'
	$asso = GUICreate("Pattern ambiguity", 280, 115+21*$j, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI2)
	
	GUICtrlCreateGroup("Item with pattern ambiguity:", 8, 6, 264, 40)
	GUICtrlCreateLabel($item, 30, 4+20, 230, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateGroup("Select what pattern use for it:", 8, 40+6*2, 264, 22+21*$j)
	For $i = 1 To $j
		$rad[$i] = GUICtrlCreateRadio(" " & $matches[$i][0], 30, 46+($i*21), 220, 20)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$ok = GUICtrlCreateButton("OK", 140-20-66, 82+21*$j, 66, 24)
	$canc = GUICtrlCreateButton("Cancel", 140+20, 82+21*$j, 66, 24)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $ok
				For $i = 1 To $j
					If GUICtrlRead($rad[$i]) = 1 Then $ma = $matches[$i][1]
				Next
				If $ma <> "-1" Then ExitLoop
				MsgBox(0x40000, "Message", $mess)
				
			Case $canc, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($asso)
	If $top = "True" Then WinSetOnTop($hGUI, "", 1)
	If $ma = $EP Then $ma = "-1"
	Return $ma
EndFunc


Func Checking($item, $ff)
	Local $str, $match, $pattern, $j = 0, $k, $matches[8][2], $var = IniReadSection($sIniPr, "Patterns")
	If Not(@error) Then
		For $i = 1 To $var[0][0]
			$match = 0
			$str = $var[$i][0]
			If StringRight($var[$i][0], 1) = "$" Then $str = StringTrimRight($var[$i][0], 1)
			Local $strings = StringSplit($str, ";")
			For $k = 1 To $strings[0]
				If StringInStr($strings[$k], "**") Then
					$pattern = StringReplace($strings[$k], "**", "(.*?)")
					If $ff = "0" Then $match = StringRegExp(StringLower($item), "^" & $pattern & "$")
				Else
					$pattern = StringReplace($strings[$k], "*", "(.*?)")
					If $ff <> "0" Then $match = StringRegExp(StringLower($item), "^" & $pattern & "$")
				EndIf
				If $match = 1 Then ExitLoop
			Next
			If $match = 1 And $j < 7 Then
				$j = $j + 1
				$matches[$j][0] = $var[$i][0]
				$matches[$j][1] = $var[$i][1]
			EndIf
		Next
		If $j = 1 Then
			If StringRight($matches[$j][0], 1) = "$" Then
				Return "-1"
			Else
				Return $matches[$j][1]
			EndIf
		ElseIf $j > 1 Then
			$match = MoreMatches($matches, $item, $j)
			Return $match
		EndIf
	EndIf
	Return "0"
EndFunc


Func Associate($item, $ff)
	Local $asso, $sel, $Dir1, $se1, $bot1, $fo1, $bot2, $canc, $tem, $tx = ""
	$asso = GUICreate("Add Association", 296, 160, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI2)
	If $ff = "0" Then
		$tx = $item & "**"
	Else
		$tx = "*." & $ff
	EndIf
	GUICtrlCreateGroup("", 8, 4, 280, 115)
	GUICtrlCreateLabel($me1, 19, 4+17, 260, 40)
	$Dir1 = GUICtrlCreateInput("", 16, 4+50, 207, 20)
	$se1 = GUICtrlCreateButton("Folder", 284-60, 4+49, 56, 22)
	GUICtrlSetTip($se1, "Select a destination folder")
	$bot1 = GUICtrlCreateButton("Rules", 150-54-64, 4+79, 64, 24)
	GUICtrlSetTip($bot1, "Info about supported pattern rules")
	$fo1 = GUICtrlCreateInput($tx, 150-39, 4+81, 78, 20)
	GUICtrlSetTip($fo1, "Write here the desired pattern")
	$bot2 = GUICtrlCreateButton("Apply", 150+54, 4+79, 64, 24)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateLabel('Item: "' & $item & '"', 18, 133, 170, 20)
	$canc = GUICtrlCreateButton("Cancel", 190, 127, 86, 24)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $se1
				If $top = "True" Then WinSetOnTop($asso, "", 0)
				$tem = FileSelectFolder("Select a destination folder:", "", 3)
				If $tem <> "" Then GUICtrlSetData($Dir1, $tem)
				If $top = "True" Then WinSetOnTop($asso, "", 1)
				
			Case $bot1
				MsgBox(0x40000, "Supported pattern rules", $prs)
				
			Case $bot2
				$tem = GUICtrlRead($Dir1)
				$ff = StringLower(GUICtrlRead($fo1))
				If $ff = "" Or Not(StringInStr($ff, "*")) Then
					MsgBox(0x40000, "Message", $er2)
				Else
					If IniRead($sIniPr, "Patterns", $ff, "0") = "0" Then
						If StringRight($ff, 1) = "$" Then $tem = $EP
						If $tem = "" Then
							MsgBox(0x40000, "Message", $er1)
						Else
							IniWrite($sIniPr, "Patterns", $ff, $tem)
							ExitLoop
						EndIf
					Else
						MsgBox(0x40000, "Message", $er3)
					EndIf
				EndIf
				
			Case $canc, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($asso)
	If $top = "True" Then WinSetOnTop($hGUI, "", 1)
EndFunc


Func PosFile($temp)
	Local $Place, $item, $name, $tut, $decision, $cont, $tx, $j = 1, $f = 0, $DD = 0, $nodir = 1, $ff = "0"
	If StringInStr(FileGetAttrib($temp), "D") Then $DD = 1
	; Rules extrapolation
	While 1
		$j = $j + 1
		$item = StringRight($temp, $j)
		If StringLeft($item, 1) = '.' And $f = 0 Then
			If $DD = 0 Then $ff = StringLower(StringRight($temp, $j - 1))
			$f = 1
		EndIf
		If StringLeft($item, 1) = '\' Then
			$item = StringRight($temp, $j - 1)
			ExitLoop
		EndIf
	WEnd
	; Check if match with a pattern
	$Place = Checking($item, $ff)	; destination if ok, 0 to associate, -1 to skip
	If $Place = "0" Then
		If $DD = 0 Then
			$tx = "file:"
		Else
			$tx = 'folder:'
		EndIf
		$decision = MsgBox(0x40004, "Association needed", 'No association found for the following ' & $tx & @LF & $temp & @LF & @LF & 'Do you want to associate a destination folder for it?')
		If $decision = 6 Then
			Associate($item, $ff)
			$Place = Checking($item, $ff)
		EndIf
	EndIf
	; File positioning
	If $Place <> "0" And $Place <> "-1" Then
		Opt("ExpandEnvStrings", 1)
		$decision = 6
		If Not FileExists($Place) Then
			$nodir = DirCreate($Place)
			If $nodir = 0 Then MsgBox(0, "Destination problem", "Sort operation has been partially skipped. The following destination folder does not exist and cannot be created:" & @LF & $Place)
		EndIf
		If FileExists($Place & "\" & $item) Then
			If IniRead($sIni, "General", "AutoForDup", "False") = "False" Then
				If $DD = 1 Then
					$tx = "Folder"
				Else
					$tx = "File"
				EndIf
				$decision = MsgBox(0x40004, $tx & " already exists", '"' & $item & '" already exists in destination folder.' & @LF & 'Do you want to overwrite it? (otherwise it will be skipped)')
			Else
				If IniRead($sIni, "General", "Duplicates", "Overwrite") = "Skip" Then $decision = 1
				If IniRead($sIni, "General", "Duplicates", "Overwrite") = "Rename" Then
					$j = 0
					While 1
						$j = $j + 1
						If $j < 10 Then
							$cont = "0" & $j
						Else
							$cont = $j
						EndIf
						If $DD = 1 Then
							$name = $item & "_" & $cont
						Else
							$name = StringTrimRight($item, StringLen($ff) + 1) & "_" & $cont & "." & $ff
						EndIf
						If Not FileExists($Place & "\" & $name) Then
							$item = $name
							ExitLoop
						EndIf
					WEnd
				EndIf
			EndIf
		EndIf
		If $decision = 6 And $nodir = 1 Then
			If IniRead($sIni, "General", "Mode", "Move") = "Move" Then
				If $DD = 1 Then
					DirMove($temp, $Place & "\" & $item, 1)
				Else
					FileMove($temp, $Place & "\" & $item, 1)
				EndIf
			Else
				If $DD = 1 Then
					DirCopy($temp, $Place & "\" & $item, 1)
				Else
					FileCopy($temp, $Place & "\" & $item, 1)
				EndIf
			EndIf
		EndIf
		Opt("ExpandEnvStrings", 0)
	EndIf
EndFunc


Func Position($temp)
	Local $search, $file, $attrib
	If StringInStr(FileGetAttrib($temp), "D") Then
		If IniRead($sIni, "General", "DirForFolders", "False") = "True" Then
			PosFile($temp)
		Else
			; Load files
			$search = FileFindFirstFile($temp & "\*.*")
			While 1
				$file = FileFindNextFile($search)
				If @error Then ExitLoop
				$attrib = FileGetAttrib($temp & "\" & $file)
				If Not StringInStr($attrib, "D") Then PosFile($temp & "\" & $file)
			WEnd
			FileClose($search)
			; Load folders
			$search = FileFindFirstFile($temp & "\*.*")
			While 1
				$file = FileFindNextFile($search)
				If @error Then ExitLoop
				$attrib = FileGetAttrib($temp & "\" & $file)
				If StringInStr($attrib, "D") Then Position($temp & "\" & $file)
			WEnd
			FileClose($search)
		EndIf
	Else
		PosFile($temp)
	EndIf
EndFunc


Func DropEvent()
	Local $decision, $size, $fullsize = 0
	If IniRead($sIni, "General", "AskMode", "False") = "True" Then
		$decision = MsgBox(0x40004, "Choose positioning mode", "Do you want to 'move' these files in destination folders?" & @LF & "(otherwise they will be 'copied' in destination folders)")
		If $decision = 6 Then
			IniWrite($sIni, "General", "Mode", "Move")
		Else
			IniWrite($sIni, "General", "Mode", "Copy")
		EndIf
	EndIf
	For $i = 0 To UBound($gaDropFiles) - 1
		$temp = $gaDropFiles[$i]
		If FileExists($temp) Then
			If StringInStr(FileGetAttrib($temp), "D") Then
				$size = DirGetSize($temp)
			Else
				$size = FileGetSize($temp)
			EndIf
			$fullsize = $fullsize + $size
		EndIf
	Next
	If $fullsize > 2000000000 Then
		$decision = MsgBox(0x40004, "Estimated long processing time", "You are trying to process a large size of files (" & StringFormat("%.2f", $fullsize/1073741824) & " GB)." & @LF & "It may take long time, do you wish to continue?")
	Else
		$decision = 6
	EndIf
	If $decision = 6 Then
		For $i = 0 To UBound($gaDropFiles) - 1
			$temp = $gaDropFiles[$i]
			If FileExists($temp) Then Position($temp)
		Next
	EndIf
EndFunc


Func WM_DROPFILES_UNICODE_FUNC($hWnd, $msgID, $wParam, $lParam)
    Local $nSize, $pFileName
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("wchar[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "int", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i + 1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
EndFunc


Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
	If IniRead($sIni, "General", "LockPos", "True") = "True" Then
		If BitAND($wParam, 0x0000FFF0) = $SC_MOVE Then Return False
	EndIf
    Return 'GUI_RUNDEFMSG'
EndFunc


Func ShowEvent()
	TrayItemDelete($Show)
	TrayItemDelete($Separ)
	TrayItemDelete($Exit)
	GUISetState(@SW_SHOW, $hGUI)
	Opt("TrayIconHide", 1)
EndFunc


Func ExitEvent()
	_Pos()
    Exit
EndFunc


Func MyTrayMenu()
	GUISetState(@SW_HIDE, $hGUI)
	Opt("TrayIconHide", 0)
	TraySetToolTip($ii)
	$Show = TrayCreateItem("Show")
	$Separ = TrayCreateItem("")
	$Exit = TrayCreateItem("Exit")
	TrayItemSetOnEvent($Show, 'ShowEvent')
	TrayItemSetOnEvent($Exit, 'ExitEvent')
	TraySetOnEvent(-13, 'ShowEvent')
	TraySetState()
	TraySetClick(16)
EndFunc


Func _Pos()
	Local $pos = WinGetPos($hGUI)
	IniWrite($sIni, "General", "PosX", $pos[0])
	IniWrite($sIni, "General", "PosY", $pos[1])
EndFunc


Func FollowMe($hW, $iM, $wp, $lp)
    If $hW <> $hGUI Then Return
    Local $xypos = WinGetPos($hGUI)
    WinMove($hGUI2, "", $xypos[0] - $RelPos[0], $xypos[1] - $RelPos[1])
EndFunc


Func SetRelPos($hW, $iM, $wp, $lp)
    If $hW <> $hGUI Then Return
    Local $hGUIp = WinGetPos($hGUI)
    Local $hGUI2p = WinGetPos($hGUI2)
    $RelPos[0] = $hGUIp[0] - $hGUI2p[0]
    $RelPos[1] = $hGUIp[1] - $hGUI2p[1]
EndFunc


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
    Local $tNMITEMACTIVATE = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
    Local $hWndFrom = HWnd(DllStructGetData($tNMITEMACTIVATE, 'hWndFrom'))
    Local $Index = DllStructGetData($tNMITEMACTIVATE, 'Index')
    Local $Code = DllStructGetData($tNMITEMACTIVATE, 'Code')
    Switch $hWndFrom
        Case $hListView
            Switch $Code
				Case $LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW
                    Local $tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
                    Return False
					
                Case $LVN_ENDLABELEDITA, $LVN_ENDLABELEDITW
					Local $tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
                    Local $tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
                    If StringLen(DllStructGetData($tBuffer, "Text")) Then
						$specialClick = 1
						Return True
					EndIf
					
                Case $NM_RCLICK
                    GUICtrlSendToDummy($Dummy, $Index)
					Return 0
					
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc


Func ListProfiles()
    Local $search, $file, $profiles[16]
	$profiles[0] = 0
	$search = FileFindFirstFile($PrDir & "\*.ini")
	If $search = -1 Then Return $profiles
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If $profiles[0] = 15 Then ExitLoop
		$profiles[0] = $profiles[0] + 1
		$profiles[$profiles[0]] = StringTrimRight($file, 4)
	WEnd
	FileClose($search)
	Return $profiles
EndFunc


Func ImProf($cust, $nProf)
    Local $tp, $none = "0"
	WinSetOnTop($cust, "", 0)
	$tp = FileOpenDialog('Select target image for "' & $nProf & '" profile', $ImDir & "\", "Image (*.gif)", 1)
	If Not @error Then
		If StringInStr($tp, $ImDir) Then
			$tp = StringTrimLeft($tp, StringLen($ImDir) + 1)
			IniWrite($PrDir & "\" & $nProf & ".ini", "Target", "Image", $tp)
			$none = $tp
		Else
			MsgBox(0x40000, "Image not correct", "The target image must be placed in this directory:" & @LF & $ImDir)
		EndIf
	EndIf
	If $top = "True" Then WinSetOnTop($cust, "", 1)
	Return $none
EndFunc


Func ImSizeProf($cust, $nProf, $tp)
    Local $create, $sel, $ok, $cancel, $sX, $sY, $temX, $temY, $size = "0"
	WinSetOnTop($cust, "", 0)
	$create = GUICreate("Target Size", 200, 69, -1, -1, -1, $WS_EX_TOOLWINDOW, $cust)
	$tp = StringSplit($tp, "x")
	GUICtrlCreateLabel("Width:", 10, 12, 34, 20)
	$sX = GUICtrlCreateInput($tp[1], 48, 10, 40, 20)
	GUICtrlCreateLabel("Height:", 106, 12, 34, 20)
	$sY = GUICtrlCreateInput($tp[2], 146, 10, 40, 20)
	$ok = GUICtrlCreateButton("OK", 100-60-12, 39, 60, 22)
	$cancel = GUICtrlCreateButton("Cancel", 100+12, 39, 60, 22)
	GUISetState()
	If $top = "True" Then WinSetOnTop($create, "", 1)
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $ok
				$temX = GUICtrlRead($sX)
				$temY = GUICtrlRead($sY)
				If StringIsDigit($temX) And StringIsDigit($temY) And $temX > 10 And $temY > 10 Then
					$tp = $PrDir & "\" & $nProf & ".ini"
					IniWrite($tp, "Target", "SizeX", $temX)
					IniWrite($tp, "Target", "SizeY", $temY)
					$size = $temX & "x" & $temY
					ExitLoop
				Else
					MsgBox(0x40000, "Size not correct", "You have to insert correct sizes for target image." & @LF & "(both width and height must be more than 10 pixels)")
				EndIf
	
			Case $cancel, $GUI_EVENT_CLOSE
				ExitLoop
			
		EndSwitch
	WEnd
	GUIDelete($create)
	If $top = "True" Then WinSetOnTop($cust, "", 1)
	Return $size
EndFunc


Func ImTarget()
	$sIm = IniRead($sIniPr, "Target", "Image", "")
	If $sIm = "" Or Not FileExists($ImDir & "\" & $sIm) Then
		$sIm = $ImDef
		IniWrite($sIniPr, "Target", "Image", $sIm)
		MsgBox(0, "Image not found", 'Target image not found. The default image will be assigned to this profile.')
	EndIf
	$sIm = $ImDir & "\" & $sIm
EndFunc


Func Customize($profiles)
	Local $cust, $sel, $bt1, $bt2, $bt3, $bt4, $bt5, $close, $ListView, $item, $cMenu, $hMenu, $tp, $profSel, $nProf, $decision
	$cust = GUICreate("Customize Profiles", 296, 222, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI)
	
	$Dummy = GUICtrlCreateDummy()
	$cMenu = GUICtrlCreateContextMenu($Dummy)
	$bt2 = GUICtrlCreateMenuItem("Rename", $cMenu)
	$bt3 = GUICtrlCreateMenuItem("Set image", $cMenu)
	$bt4 = GUICtrlCreateMenuItem("Set size", $cMenu)
	GUICtrlCreateMenuItem("", $cMenu)
	$bt5 = GUICtrlCreateMenuItem("Remove", $cMenu)
	
	$ListView = GUICtrlCreateListView("Profile|Image|Size", 8, 8, 280, 155, BitOr($LVS_NOSORTHEADER, $LVS_EDITLABELS, $LVS_REPORT, $LVS_SINGLESEL))
    $hListView = GUICtrlGetHandle($ListView)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOr($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($hListView, 0, 100)
	_GUICtrlListView_SetColumnWidth($hListView, 1, 110)
	_GUICtrlListView_SetColumnWidth($hListView, 2, 60)
	
	GUICtrlCreateLabel("Click New to add a profile or Right-click a profile to edit it.", 12, 167, 280, 20)
	$bt1 = GUICtrlCreateButton("New", 148-70-25, 190, 70, 24)
	$close = GUICtrlCreateButton("Close", 148+25, 190, 70, 24)
	
	For $i = 1 To $profiles[0]
		$item = _GUICtrlListView_AddItem($hListView, $profiles[$i])
		$tp = IniRead($PrDir & "\" & $profiles[$i] & ".ini", "Target", "Image", "")
		If $tp = "" Then $tp = $ImDef
		_GUICtrlListView_AddSubItem($hListView, $item, $tp, 1)
		$tp = IniRead($PrDir & "\" & $profiles[$i] & ".ini", "Target", "SizeX", "")
		If $tp = "" Then $tp = "64"
		$temp = $tp
		$tp = IniRead($PrDir & "\" & $profiles[$i] & ".ini", "Target", "SizeY", "")
		If $tp = "" Then $tp = "64"
		_GUICtrlListView_AddSubItem($hListView, $item, $temp & "x" & $tp, 2)
	Next
	
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUISetState()
	If $top = "True" Then WinSetOnTop($cust, "", 1)
	$hMenu = GUICtrlGetHandle($cMenu)
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $Dummy
				$profSel = GUICtrlRead($Dummy)
				If $profSel >= 0 Then
					GUICtrlSetState($bt2, $GUI_ENABLE)
					GUICtrlSetState($bt3, $GUI_ENABLE)
					GUICtrlSetState($bt4, $GUI_ENABLE)
					GUICtrlSetState($bt5, $GUI_ENABLE)
					$temp = _GUICtrlListView_GetItemText($hListView, $profSel, 0)
				Else
					GUICtrlSetState($bt2, $GUI_DISABLE)
					GUICtrlSetState($bt3, $GUI_DISABLE)
					GUICtrlSetState($bt4, $GUI_DISABLE)
					GUICtrlSetState($bt5, $GUI_DISABLE)
				EndIf
				_GUICtrlMenu_TrackPopupMenu($hMenu, $cust)
				
			Case $bt1
				$profSel = _GUICtrlListView_AddItem($hListView, "")
				_GUICtrlListView_EditLabel($hListView, $profSel)
				
			Case $bt2
				_GUICtrlListView_EditLabel($hListView, $profSel)
				
			Case $bt3
				$tp = ImProf($cust, $temp)
				If $tp <> "0" Then _GUICtrlListView_SetItemText($hListView, $profSel, $tp, 1)
				
			Case $bt4
				$tp = ImSizeProf($cust, $temp, _GUICtrlListView_GetItemText($hListView, $profSel, 2))
				If $tp <> "0" Then _GUICtrlListView_SetItemText($hListView, $profSel, $tp, 2)
				
			Case $bt5
				$decision = MsgBox(0x40004, "Remove selected profile", 'Are you sure to remove selected profile?')
				If $decision = 6 Then
					FileDelete($PrDir & "\" & $temp & ".ini")
					_GUICtrlListView_DeleteItem($hListView, $profSel)
					$tp = $profiles[$profSel + 1]
					$profiles[0] = $profiles[0] - 1
					For $i = 1 To $profiles[0]
						If $i > $profSel Then $profiles[$i] = $profiles[$i + 1]
					Next
					If $tp = IniRead($sIni, "General", "Profile", "Default") Then
						$tp = _GUICtrlListView_GetItemText($hListView, 0, 0)
						If $tp = "" Then $tp = "Default"
						IniWrite($sIni, "General", "Profile", $tp)
						$sIniPr = $PrDir & "\" & $tp & ".ini"
					EndIf
				EndIf
				
			Case $close, $GUI_EVENT_CLOSE
				ExitLoop
			
			EndSwitch
			If $specialClick = 1 Then
				$specialClick = 0
				$nProf = _GUICtrlListView_GetItemText($hListView, $profSel, 0)
				For $i = 1 To $profiles[0]
					; check if the profile name already exists
					$tp = _GUICtrlListView_GetItemText($hListView, $i - 1, 0)
					If $nProf = $tp And $profSel <> $i - 1 Then
						MsgBox(0x40000, "Name not available", "This profile name already exists.")
						_GUICtrlListView_SetItemText($hListView, $profSel, $temp, 0)
						$nProf = ""
					EndIf
				Next
				If $profSel = $profiles[0] Then
					; new profile creation
					If $nProf = "" Then
						_GUICtrlListView_DeleteItem($hListView, $profSel)
					Else
						$profiles[0] = $profSel + 1
						$profiles[$profSel + 1] = $nProf
						$tp = $PrDir & "\" & $nProf & ".ini"
						IniWriteSection($tp, "Target", "Image=" & $ImDef & @LF & "SizeX=64" & @LF & "SizeY=64")
						IniWriteSection($tp, "Patterns", "")
						$tp = ImProf($cust, $nProf)
						If $tp = "0" Then
							_GUICtrlListView_AddSubItem($hListView, $profSel, $ImDef, 1)
							$tp = "64x64"
						Else
							_GUICtrlListView_AddSubItem($hListView, $profSel, $tp, 1)
							$tp = ImSizeProf($cust, $nProf, "64x64")
							If $tp = "0" Then $tp = "64x64"
						EndIf
						_GUICtrlListView_AddSubItem($hListView, $profSel, $tp, 2)
					EndIf
				ElseIf $nProf <> "" Then
					; profile renomination
					$profiles[$profSel + 1] = $nProf
					FileMove($PrDir & "\" & $temp & ".ini", $PrDir & "\" & $nProf & ".ini")
					If $temp = IniRead($sIni, "General", "Profile", "Default") Then
						IniWrite($sIni, "General", "Profile", $nProf)
						$sIniPr = $PrDir & "\" & $nProf & ".ini"
					EndIf
				EndIf
			EndIf
	WEnd
	If _GUICtrlListView_GetItemCount($hListView) = 0 Then
		; create default profile if no other profiles exist
		IniWrite($sIni, "General", "Profile", "Default")
		$sIniPr = $PrDir & "\Default.ini"
		If Not FileExists($PrDir) Then DirCreate($PrDir)
		If Not FileExists($sIniPr) Then
			IniWriteSection($sIniPr, "Target", "Image=" & $ImDef & @LF & "SizeX=64" & @LF & "SizeY=64")
			IniWriteSection($sIniPr, "Patterns", "")
		EndIf
	EndIf
	GUIDelete($cust)
	If $top = "True" Then WinSetOnTop($hGUI, "", 1)
	Return ListProfiles()
EndFunc


Func Refresh($sIniPr, $profiles)
	Local $prof[16], $xD = IniRead($sIniPr, "Target", "SizeX", "64"), $yD = IniRead($sIniPr, "Target", "SizeY", "64")
	
	GUIDelete($hGUI2)
	GUIDelete($hGUI)
	$hGUI = GUICreate($sName, $xD, $yD, IniRead($sIni, "General", "PosX", "-1"), IniRead($sIni, "General", "PosY", "-1"), $WS_POPUP, BitOR($WS_EX_ACCEPTFILES, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	$sIcon = GUICtrlCreatePic($sIm, 0, 0, $xD, $yD, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetState($sIcon, $GUI_DROPACCEPTED)
	GUICtrlSetTip($sIcon, $ii)
	
	; Context menu
	$menu = GUICtrlCreateContextMenu($sIcon)
	$func1 = GUICtrlCreateMenuItem("Manage", $menu, 0)
	GUICtrlCreateMenuItem("", $menu, 1)
	$func2 = GUICtrlCreateMenu("Profiles", $menu, 2)
	$func3 = GUICtrlCreateMenuItem("Options", $menu, 3)
	$func4 = GUICtrlCreateMenuItem("Hide", $menu, 4)
	$func5 = GUICtrlCreateMenuItem("About...", $menu, 5)
	GUICtrlCreateMenuItem("", $menu, 6)
	$func6 = GUICtrlCreateMenuItem("Exit", $menu, 7)
	$custom = GUICtrlCreateMenuItem("Customize", $func2)
	GUICtrlCreateMenuItem("", $func2)
	For $i = 1 To $profiles[0]
		$prof[$i] = GUICtrlCreateMenuItem($profiles[$i], $func2, $i+1, 1)
		If $profiles[$i] = IniRead($sIni, "General", "Profile", "Default") Then GUICtrlSetState($prof[$i], $GUI_CHECKED)
    Next
	GUISetState(@SW_SHOW, $hGUI)
	
	Local $pos = WinGetPos($hGUI)
	$hGUI2 = GUICreate("Positioning", 16, 16, $pos[0]+($xD/9), $pos[1]+($yD/9), $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST), $hGUI)
	$sIcon2 = GUICtrlCreatePic($sWork, 0, 0, 16, 16, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUIRegisterMsg($WM_ENTERSIZEMOVE, "SetRelPos")
	GUIRegisterMsg($WM_MOVE, "FollowMe")
	GUISetState(@SW_HIDE, $hGUI2)
	
	$top = IniRead($sIni, "General", "OnTop", "True")
	If $top = "True" Then
		WinSetOnTop($hGUI, "", 1)
	Else
		WinSetOnTop($hGUI, "", 0)
	EndIf
	Return $prof
EndFunc


Func _Main()
	Local $nMsg, $j, $list, $tp, $noprof = 0, $prof[16], $profiles[16]
	If FileExists(@ScriptDir & "\unins000.exe") Then
		If FileExists($sIni) Then FileMove($sIni, @AppDataDir & "\" & $sName & "\settings.ini", 9)
		If FileExists($PrDir) Then DirMove($PrDir, @AppDataDir & "\" & $sName & "\profiles", 1)
		If FileExists($ImDir) Then DirMove($ImDir, @AppDataDir & "\" & $sName & "\img", 1)
		$sIni = @AppDataDir & "\" & $sName & "\settings.ini"
		$PrDir = @AppDataDir & "\" & $sName & "\profiles"
		$ImDir = @AppDataDir & "\" & $sName & "\img"
	EndIf
	If Not FileExists($PrDir) Then DirCreate($PrDir)
	If Not FileExists($ImDir) Then DirCreate($ImDir)
	If Not FileExists($sIm) Then FileInstall("img\Default.gif", $sIm)
	If Not FileExists($sWork) Then FileInstall("img\zz.gif", $sWork)
	
	; Creation of the main ini
	If Not FileExists($sIni) Then
		$sData = "Profile=Default" & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & "OnTop=True" & @LF & "LockPos=False" & @LF & "DirForFolders=False" & @LF & "MultipleInst=False" & @LF & "AutoForDup=False" & @LF & "Duplicates=Overwrite" & @LF & "Mode=Move" & @LF & "AskMode=False"
		IniWriteSection($sIni, "General", $sData)
	EndIf
	
	; Checking of multiple instances
	If IniRead($sIni, "General", "MultipleInst", "False") = "False" Then
		$list = ProcessList(@ScriptName)
		If $list[0][0] > 1 Then Exit
	EndIf
	
	; Loading of the profile ini
	$sData = IniRead($sIni, "General", "Profile", "")
	If Not FileExists($PrDir & "\" & $sData & ".ini") And $sData <> "Default" Then
		$noprof = 1
		$sData = "Default"
		IniWrite($sIni, "General", "Profile", $sData)
		If $CmdLine[0] = 0 Then MsgBox(0, "Profile not found", $er4 & @LF & 'It will be started with "Default" profile.')
	EndIf
	$sIniPr = $PrDir & "\" & $sData & ".ini"
	If Not FileExists($sIniPr) Then
		IniWriteSection($sIniPr, "Target", "Image=" & $ImDef & @LF & "SizeX=64" & @LF & "SizeY=64")
		IniWriteSection($sIniPr, "Patterns", "")
	EndIf
	
	; Creation of the profile list
	$profiles = ListProfiles()
	
	; Background mode
	$temp = $CmdLine[0]
	If $temp > 0 Then
		If StringLeft($CmdLine[1], 1) = "-" Then
			$temp = $temp - 1
			$sData = StringTrimLeft($CmdLine[1], 1)
			If FileExists($PrDir & "\" & $sData & ".ini") Then
				IniWrite($sIni, "General", "Profile", $sData)
				$sIniPr = $PrDir & "\" & $sData & ".ini"
				$noprof = 0
			Else
				MsgBox(0, "Profile not found", $er4 & @LF & "It will start with the last-known profile and files sent with command line will be skipped.")
				$temp = 0
			EndIf
		EndIf
		If $temp > 0 Then
			If $noprof = 1 Then
				MsgBox(0, "Profile not found", $er4 & @LF & "It cannot be started and files will not be sorted.")
			Else
				ReDim $gaDropFiles[$temp]
				For $j = 1 To $temp
					$tp = $CmdLine[$CmdLine[0] - $temp + $j]
					If StringInStr($tp, ":") Then
						$gaDropFiles[$j - 1] = $tp
					Else
						$gaDropFiles[$j - 1] = _PathFull(@ScriptDir & "..\" & $tp)	; it needs this additional "..\" to work fine
					EndIf
				Next
				DropEvent()
			EndIf
			Exit
		EndIf
	EndIf
	
	; Target image loading
	ImTarget()
	
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_UNICODE_FUNC")
	GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
	$prof = Refresh($sIniPr, $profiles)
	
	While 1
		$nMsg = GUIGetMsg()
		Select
			Case $nMsg = $GUI_EVENT_DROPPED
				GUISetState(@SW_SHOW, $hGUI2)
				DropEvent()
				GUISetState(@SW_HIDE, $hGUI2)
				
			Case $nMsg = $func1
				GUICtrlSetState($sIcon, $GUI_DISABLE)
				Manage()
				GUICtrlSetState($sIcon, $GUI_ENABLE)
			
			Case $nMsg = $custom
				GUICtrlSetState($sIcon, $GUI_DISABLE)
				$profiles = Customize($profiles)
				$sIniPr = $PrDir & "\" & IniRead($sIni, "General", "Profile", "Default") & ".ini"
				_Pos()
				ImTarget()
				$prof = Refresh($sIniPr, $profiles)
				
			Case $nMsg >= $prof[1] And $nMsg <= $prof[$profiles[0]]
				For $i = 1 To $profiles[0]
					If $nMsg = $prof[$i] Then
						IniWrite($sIni, "General", "Profile", $profiles[$i])
						$sIniPr = $PrDir & "\" & $profiles[$i] & ".ini"
					EndIf
				Next
				_Pos()
				ImTarget()
				$prof = Refresh($sIniPr, $profiles)
				
			Case $nMsg = $func3
				GUICtrlSetState($sIcon, $GUI_DISABLE)
				Options()
				GUICtrlSetState($sIcon, $GUI_ENABLE)
				
			Case $nMsg = $func4
				MyTrayMenu()
				
			Case $nMsg = $func5
				MsgBox(0x40040, "About", "      " & $sName & $sVer & @LF & @LF & "Software developed by Lupo PenSuite Team." & @LF & "Released under Open Source GPL.")
				
			Case $nMsg = $func6
				ExitLoop
				
			Case $nMsg = $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSelect
	WEnd
	ExitEvent()
EndFunc