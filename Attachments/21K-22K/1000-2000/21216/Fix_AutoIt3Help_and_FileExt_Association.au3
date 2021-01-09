; Scriptname: FixHelpFileExamples.au3
; Script to fix Registry setting for SciTE/AutoIt3/Helpfile Open Button
;
If Not FileExists(@ScriptDir & '\Autoit3.exe') then
	MsgBox(16,"Autoit3.exe error",'File Autoit3.exe not found. Place this script in the AutoIt3 program directory and run it again.')
	Exit
EndIf
If Not FileExists(@ScriptDir & '\SciTE\SciTE.exe') then
	MsgBox(16,"SciTE.exe error",'File ..\SciTE\SciTE.exe not found. Something is not installer the standard way. Exiting.')
	Exit
EndIf
$Open_SciTe = '"' & @ScriptDir & '\SciTE\SciTE.exe" "%1"'
$Edit_SciTe = '"' & @ScriptDir & '\SciTE\SciTE.exe" "%1"'
$Run_SciTe = '"' & @ScriptDir & '\AutoIt3.exe" "%1" %*'
$Open = RegRead("HKCR\AutoIt3Script\Shell\Open\Command", "")
$Edit = RegRead("HKCR\AutoIt3Script\Shell\Edit\Command", "")
$Run = RegRead("HKCR\AutoIt3Script\Shell\Run\Command", "")
$Default = RegRead("HKCR\AutoIt3Script\Shell", "")
$FixedOpen = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.au3", "Application")
ConsoleWrite("+****************************************************************************************" &@CRLF)
ConsoleWrite("+* Current setting: " &@CRLF)
ConsoleWrite("+*        Default action:" & $Default & @CRLF)
ConsoleWrite("+*                   Run:" & $Run & @CRLF)
ConsoleWrite("+*                  Open:" & $Open & @CRLF)
ConsoleWrite("+*                  Edit:" & $Edit & @CRLF)
ConsoleWrite("+*      Always open with:" & $FixedOpen & @CRLF)
ConsoleWrite("+****************************************************************************************" &@CRLF)
; Check for "Always open with settings 
If $FixedOpen <> "" Then
	If MsgBox(4, "Override setting for Open on .AU3", 'You have specified to "Always Open" with:' & @CRLF & $FixedOpen & _
			@CRLF & " But this should be removed and the standard setting should be used!" & _
			@CRLF & @CRLF & "Click Yes to Remove this Keys") = 6 Then
		$rc = RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.au3", "Application")
		ConsoleWrite('-RegDelete ("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.au3", "Application") $rc = ' & $rc & "  @Error=" & @error & @CRLF)
	Else
		ConsoleWrite('! Override setting for Open on .AU3 not removed' & @CRLF)
	EndIf
Else
	ConsoleWrite('+No Open override on .au3.' & @CRLF)
EndIf
; Check Edit Settings
If $Edit <> $Edit_SciTe Then
	If MsgBox(4, "Edit Settings for AU3", 'Your "Edit" settings are currently:' & @CRLF & $Edit & @CRLF & " But should be:" & @CRLF & $Edit_SciTe & @CRLF & @CRLF & " Update?") = 6 Then
		$rc = RegWrite("HKCR\AutoIt3Script\Shell\Edit\Command", "", "REG_SZ", $Edit_SciTe)
		ConsoleWrite('-RegWrite Edit $rc = ' & $rc & "  @Error=" & @error & @CRLF)
	EndIf
Else
	ConsoleWrite('+Edit already set to default = ' & $Edit & @CRLF)
EndIf
; Check Open Settings
If $Open <> $Open_SciTe Then
	If MsgBox(4, "Open Settings for AU3", 'Your "Open" settings are currently:' & @CRLF & $Open & @CRLF & " But should be:" & @CRLF & $Open_SciTe & @CRLF & @CRLF & " Update?") = 6 Then
		RegWrite("HKCR\AutoIt3Script\Shell\Open\Command", "", "REG_SZ", $Open_SciTe)
		ConsoleWrite('-RegWrite Open $rc = ' & $rc & "  @Error=" & @error & @CRLF)
	EndIf
Else
	ConsoleWrite('+Open already set to default = ' & $Open & @CRLF)
EndIf
; Check Run Settings
If $Run <> $Run_SciTe Then
	If MsgBox(4, "Run Setting for AU3", 'Your "Run" settings are currently:' & @CRLF & $Run & @CRLF & " But should be:" & @CRLF & $Run_SciTe & @CRLF & @CRLF & " Update?") = 6 Then
		RegWrite("HKCR\AutoIt3Script\Shell\Run\Command", "", "REG_SZ", $Run_SciTe)
		ConsoleWrite('-RegWrite Run $rc = ' & $rc & "  @Error=" & @error & @CRLF)
	EndIf
Else
	ConsoleWrite('+Run already set to default = ' & $Run & @CRLF)
EndIf
;Fix default action if needed.
If MsgBox(4, "Default action for AU3", 'Your current "Default" action for au3 is:' & '"' & $Default & '"' &  @CRLF &  @CRLF & "Do you want to change that? ") = 6 Then
	If MsgBox(4, "Default action for AU3", 'Click Yes for "Edit" ' & @CRLF & '    or No for "Run"') = 6 Then
		RegWrite("HKCR\AutoIt3Script\Shell", "", "REG_SZ", "Edit")
		ConsoleWrite('+Changed Default action to "Edit" ' & @CRLF)
	Else
		RegWrite("HKCR\AutoIt3Script\Shell", "", "REG_SZ", "Run")
		ConsoleWrite('+Changed Default action to "Run" ' & @CRLF)
	EndIf	
EndIf	
;
;Ensure hhctrl is properly registered
$rc = RunWait(@ComSpec & " /c /s regsvr32 hhctrl.ocx", "", @SW_HIDE)
ConsoleWrite('+regsvr32 hhctrl.ocx $rc = ' & $rc & @CRLF)