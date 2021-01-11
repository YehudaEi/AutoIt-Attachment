;Script Stripper, a Script that cleans scripts v0.3.0.5
;Author: The Kandie Man
#include <array.au3>
#include <file.au3>
#include <GUIConstants.au3>
Opt("TrayIconDebug", 1)
Opt("RunErrorsFatal",0)
Global $text = ''
Global $Input1
Global $filename
Global $av_stringtxt, $file, $Checkbox3, $tempname
Global $decompiledfn
Global $readinput2
; == GUI generated with Koda ==
$Form1 = GUICreate("Script Stripper v0.3.0.5 - By The Kandie Man", 484, 150, (@DesktopWidth - 484)/2,(@DesktopHeight - 300)/2) ;197, 137)
$Input1 = GUICtrlCreateInput("", 16, 24, 345, 21, -1, $WS_EX_CLIENTEDGE)
$Button1 = GUICtrlCreateButton("Browse", 392, 24, 73, 25)
GUICtrlCreateLabel("Select Script to Strip:", 16, 8, 103, 17)
$Group1 = GUICtrlCreateGroup("Options", 16, 56, 457, 89)
$Checkbox1 = GUICtrlCreateCheckbox("Remove Comments", 32, 72, 129, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox2 = GUICtrlCreateCheckbox("Remove Unused Functions", 32, 96, 161, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox4 = GUICtrlCreateCheckbox("Remove Unused Global Variables", 32, 120, 180, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox3 = GUICtrlCreateCheckbox("Use Beta Includes", 192, 72, 153, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("Number of Passes:", 192, 96, 93, 17)
$input2 = GUICtrlCreateInput("5", 285, 93, 38, 20, 8192)
$updown = GUICtrlCreateUpdown($input2)
GUICtrlSetLimit($input2, 999, 1)
$Button2 = GUICtrlCreateButton("Strip Script", 384, 96, 73, 25)
GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button1
			$v_filename = FileOpenDialog("Open", @ScriptDir, "AutoIt v3 (*.au3)", 3)
			If Not @error And FileExists($v_filename) Then
				GUICtrlSetData($Input1, $v_filename)
			EndIf
		Case $msg = $Button2
			StripScript()
			
	EndSelect
WEnd
Func StripScript()
	$origfilename = GUICtrlRead($Input1)
	If Not FileExists($origfilename) Then
		MsgBox(48,"Error!","Could not open script.  Please verify that the path is correct.")
		Return 0		
	Endif
	Local $szDrive, $szDir, $szFName, $szExt
	_PathSplit($origfilename, $szDrive, $szDir, $szFName, $szExt)
	If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
		$Au2Exe = _DirAutoIt("Beta")
	Else
		$Au2Exe = _DirAutoIt("Prod")
	EndIf
	$tempname = "temp.au3"
	$filename = $Au2Exe & "\Aut2Exe\" & $tempname
	If Not FileExists($Au2Exe) Then
		$Au2Exe = FileOpenDialog('Select Autoit2Exe Executable', @HomeDrive, 'Executables (*.exe)', 'Aut2exe.exe')
	EndIf
	FileCopy($origfilename, $filename, 1)
	$readinput2 = GUICtrlRead($input2)
	$timestamp = TimerInit()
	If Not $readinput2 >= 1 And Not $readinput2 <= 99 Then
		$readinput2 = 5
	EndIf
	If Not AddIncludes() Then Return 0
	For $x= 1 To $readinput2
		$av_stringtxt = 0
		$text = ""
		If StripEngine($x) = 0 Then Return 0
	Next
;~ 	Run("SCITE.exe " & $decompiledfn)
	ClipPut(_ArrayToString($av_stringtxt, @LF, 1))
	$i_secondstocomplete = Int(TimerDiff($timestamp) / 1000)
	MsgBox(64, "Done!", "The script took " & $i_secondstocomplete & " seconds to strip and it has been placed on your clipboard.  To get the script use a text editor such as SCITE and paste the script into it." & @CRLF & @CRLF & "Notepad WILL NOT CORRECTLY DISPLAY THE NEW CODE.  You will have to use a more advanced text editor, such as SCITE.")
EndFunc   ;==>StripScript
Func StripEngine($passnumber)

	$file = FileOpen($decompiledfn, 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Return 0
	EndIf
	Local $i_lines = _FileCountLines($decompiledfn)
	$totalsteps = 5
	ProgressOn("Pass " & $passnumber & " of " & $readinput2 , "Step 1 of " & $totalsteps, "Stripping Lines", -1, -1, 16)
	; Read in lines of text until the EOF is reached
	Local $i_linecounter = 1
	$cs = 0
	While 1
		ProgressSet(($i_linecounter / $i_lines) * 100)
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		$line = StringStripWS($line, 3)
		If StringLeft($line,7) = "#Region" Or StringLeft($line,10) = "#EndRegion" Then Continueloop
		If StringLeft($line, 15) = '#comments-end' Or StringLeft($line, 3) = '#ce' Then
			$cs = 0
			ContinueLoop  ;prevent #ce from appearing in the output
		EndIf
		If $cs = 0 And $line <> '' And StringLeft($line, 1) <> ';' Then
			If StringLeft($line, 15) = '#comments-start' Or StringLeft($line, 3) = '#cs' Then
				$cs = 1
			Else
				; Check for line contiutations; if found, remove them
				If StringRight($line, 1) = '_' Then ;get rest of line continued line
					$full = "" ;build up the entire line without line continues
					While 1
						$full = StringStripWS($full & StringStripWS($line, 3), 3)
						If StringRight($full, 1) = '_' Then $full = StringTrimRight($full, 1)
						$line = FileReadLine($file)
						If @error Or StringRight(StringStripWS($line, 3), 1) <> '_' Then
							$text = $text & $full & StringStripWS($line, 3)
							$line = '' ;prevents $text = $text & $line & @LF from duplicating text
							ExitLoop
						EndIf
					WEnd
				EndIf
				$text = $text & $line & @LF
			EndIf
		EndIf
		$i_linecounter += 1
	WEnd
	ProgressSet(100)
;~ ProgressOff()
	$av_stringtxt = StringSplit($text, @LF)
	ProgressSet(0, "Stripping Code Line Comments", "Step 2 of " & $totalsteps)
	For $i_commentcount = 1 To UBound($av_stringtxt) - 1
		$semipos = StringInStr($av_stringtxt[$i_commentcount], ";", -1)
;~ 	ProgressSet ( Int($i_commentcount/$av_stringtxt*100), "Stripping Code Line Comments","Step 2 of 3")
		If $semipos > 0 Then
			If StringInStr($av_stringtxt[$i_commentcount], "'", 0, -1) < $semipos And StringInStr($av_stringtxt[$i_commentcount], '"', 0, -1) < $semipos Then
				$av_stringtxt[$i_commentcount] = StringLeft($av_stringtxt[$i_commentcount], $semipos - 1)
			EndIf
		EndIf
	Next
	ProgressSet(100, "Stripping Code Line Comments", "Step 2 of " & $totalsteps)
	Sleep(50)
	ProgressSet(0, "Stripping Functions", "Step 3 of " & $totalsteps)
	$ubound = UBound($av_stringtxt)
	$strippedtext = StringStripWS($text, 8)
	For $i_counter = 1 To $ubound - 1
		ProgressSet(Int($i_counter / $ubound * 100))
;~ 	ConsoleWrite($i_counter &"|"& $ubound&@LF)
		If $i_counter = $ubound Then ExitLoop
		If StringLeft($av_stringtxt[$i_counter], 5) = "Func " Then
			$i_LPpos = StringInStr($av_stringtxt[$i_counter], "(")
			If $i_LPpos = 0 Then ContinueLoop
			$i_funcnamelen = $i_LPpos - (5)
			$s_Funcname = StringMid($av_stringtxt[$i_counter], 5, $i_funcnamelen)
			$s_Funcname = StringStripWS($s_Funcname, 8)
			$firstpos = StringInStr($strippedtext, $s_Funcname)
			$secondpos = StringInStr($strippedtext, $s_Funcname, 0, -1)
;~ 		FileWriteLine("functions.log",$s_Funcname & "|" & $firstpos & "|" & $secondpos)
;~ 		ConsoleWrite($s_Funcname & "|" & $firstpos & "|" & $secondpos &@LF)
			If $firstpos = $secondpos Then
				$i_counter2 = $i_counter
				_ArrayDelete($av_stringtxt, $i_counter2)
;~ 			Msgbox(0,"OMG","Only one instance of this function!" & @CRLF & $s_Funcname)
;~ 			FileWriteLine("debuglog.txt",$s_Funcname)
				While 1
;~ 				$i_counter2 += 1
;~ 				Msgbox(0,$i_counter2, UBound($av_stringtxt))
;~ 				_ArrayDisplay($av_stringtxt,"array")
					If $i_counter2 = UBound($av_stringtxt) Then ExitLoop
					If StringInStr($av_stringtxt[$i_counter2], "EndFunc") Then
						_ArrayDelete($av_stringtxt, $i_counter2)
						ExitLoop
					EndIf
					_ArrayDelete($av_stringtxt, $i_counter2)
				WEnd
				$ubound = UBound($av_stringtxt)
			EndIf
;~ 		Msgbox(0,"Number",$i_LPpos & "|" &$i_Funcpos & "|" & $i_funcnamelen)
;~ 		Msgbox(0,"Func Name:",'"' & StringStripWS($s_Funcname,8) & '"')
		EndIf
	Next
	For $2passcounter = 4 To 5
		$newtext = _ArrayToString($av_stringtxt, @LF)
		$varcounter = 1
		While 1
			$varcounter += 1
			If $varcounter = UBound($av_stringtxt) Then ExitLoop
			ProgressSet(Int($varcounter / UBound($av_stringtxt) * 100), "Stripping Unused Variables", "Step " & $2passcounter & " of " & $totalsteps)
			$trimedline = StringStripWS($av_stringtxt[$varcounter], 8)
;~ 	Msgbox(0,"Info",$trimedline)
			If StringLeft($trimedline, 11) = "GlobalConst" Then
;~ 		ConsoleWrite($trimedline &@LF)
				$equalpos = StringInStr($trimedline, "=")
				$varname = StringMid($trimedline, 12, $equalpos - 12)
				$firstpos = StringInStr($newtext, $varname)
				$secondpos = StringInStr($newtext, $varname, 0, -1)
;~ 		ConsoleWrite($varname & "|"& $firstpos & "|"& $secondpos & @LF)
				If $firstpos = $secondpos Then
					_ArrayDelete($av_stringtxt, $varcounter)
					$varcounter -= 1
				EndIf
			EndIf
		WEnd
	Next	
;~ _ArrayDisplay($av_stringtxt,"array")
	ProgressOff()
	FileClose($file)
	$file2 = FileOpen($decompiledfn, 2)
	FileWrite($file2, _ArrayToString($av_stringtxt, @LF, 1))
	FileClose($file2)
	Return 1
EndFunc   ;==>StripEngine

Func _DirAutoIt($version = 'Prod')
	Switch $version
		Case 'Prod'
			Switch True
				Case FileExists(@ProgramFilesDir & '\AutoIt3')
					Return @ProgramFilesDir & '\AutoIt3'
				Case RegRead('HKLM\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir')
					Return RegRead('HKLM\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir')
			EndSwitch
		Case 'Beta'
			Switch True
				Case FileExists(@ProgramFilesDir & '\AutoIt3\Beta')
					Return @ProgramFilesDir & '\AutoIt3\Beta'
				Case RegRead('HKLM\SOFTWARE\AutoIt v3\AutoIt', 'betaInstallDir')
					Return RegRead('HKLM\SOFTWARE\AutoIt v3\AutoIt', 'betaInstallDir')
			EndSwitch
	EndSwitch
	If $version = 'Prod' Then $version = 'Public Release'
	Return FileSelectFolder('Locate AutoIt Directory  (' & $version & ' version)', @HomeDrive)
EndFunc   ;==>_DirAutoIt
Func AddIncludes()
	If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
		$Au2Exe = _DirAutoIt("Beta")
	Else
		$Au2Exe = _DirAutoIt("Prod")
	EndIf
	If Not FileExists($Au2Exe) Then
		$Au2Exe = FileOpenDialog('Select Autoit2Exe Executable', @HomeDrive, 'Executables (*.exe)', 'Aut2exe.exe')
	EndIf
	$Exe2Aut = _DirAutoIt("Prod")
;~ 		ConsoleWRite($filename  & "|" & $Au2Exe & "\Aut2Exe\Aut2Exe.exe"&"|"& $Exe2Aut & "\Extras\Exe2Aut\Exe2Aut.exe"&"|"& 'bbbb')
	_CompileDecompile($filename, $Au2Exe & "\Aut2Exe\Aut2Exe.exe", $Exe2Aut & "\Extras\Exe2Aut\Exe2Aut.exe", 'bbbb')
	If FileExists($decompiledfn) Then
;~ 			Msgbox(0,"Success","It converted the .exe back to a script")
		Return 1
	Else
		MsgBox(0, "Failure", "It did not convert the .exe to a script")
		Return 0
	EndIf
EndFunc   ;==>AddIncludes
Func _CompileDecompile($filename, $Au2Exe, $Exe2Aut, $pass = 'asdf')
	Local $szDrive, $szDir, $szFName, $szExt
	_PathSplit($filename, $szDrive, $szDir, $szFName, $szExt)
	ConsoleWrite($filename)
	RunWait($Au2Exe & ' /in "' & $filename & '" /out "' & $szDrive & $szDir & 'temporary.exe" /pass "' & $pass & '"')
	RunWait($Exe2Aut & ' /in "' & $szDrive & $szDir & 'temporary.exe" /out "' & $szDrive & $szDir & 'decompiled.au3" /pass "' & $pass & '"')
;~ 	$tempfilename = @TempDir & "\temp.au3"
	FileDelete($szDrive & $szDir & '\temporary.exe"')
	FileDelete($filename)
	$decompiledfn = $szDrive & $szDir & 'decompiled.au3'
;~ 	ConsoleWrite("Decompiled: " & $decompiledfn)
	Return 1
EndFunc   ;==>_CompileDecompile

Func OnAutoItExit ( )
	FileDelete($decompiledfn)
EndFunc
