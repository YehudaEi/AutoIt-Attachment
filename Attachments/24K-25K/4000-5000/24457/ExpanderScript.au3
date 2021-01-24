#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Generate a single scriptfile version by adding all included files.
#AutoIt3Wrapper_Res_Description=Generate a single scriptfile version by adding all included files.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2009 Jos van der Zande
#AutoIt3Wrapper_Res_Field=Made By|Jos van der Zande
#AutoIt3Wrapper_Res_Field=Email|jdeb at autoitscript dot com
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <file.au3>
Global $SourceFileName, $TargetFileName
If $CmdLine[0] > 0 And FileExists($CmdLine[1]) Then
	$SourceFileName = $CmdLine[1]
	If $CmdLine[0] > 1 Then
		$TargetFileName = $CmdLine[2]
	Else
		$TargetFileName = StringReplace($SourceFileName, ".au3", "_FullSource.au3")
	EndIf
Else
	$SourceFileName = FileOpenDialog("Specify the file to be expanded", @ScriptDir, "AutoIt3 Script (*.au3)", 3)
	If @error Then Exit
EndIf

FileChangeDir($SourceFileName)
;
; Get Include Paths
;
Global $User_IncludeDirs = StringSplit(RegRead("HKCU\Software\AutoIt v3\Autoit", "Include"), ";")
Global $IncludeDirs[2 + UBound($User_IncludeDirs) - 1]
Global $IncludeFiles[500], $IncludeFilesCnt = 1
$IncludeFiles[$IncludeFilesCnt] = $SourceFileName
; First store the AutoIt3 directory to the search table
$IncludeDirs[0] = @ScriptDir & "\include"
Global $I_Cnt = 1
; Add User Include Directories to the table
For $x = 1 To $User_IncludeDirs[0]
	If StringStripWS($User_IncludeDirs[$x], 3) <> "" And FileExists($User_IncludeDirs[$x]) Then
		$IncludeDirs[$I_Cnt] = StringReplace($User_IncludeDirs[$x], '"', '')
		$I_Cnt += 1
	EndIf
Next
; Add the scriptpath as last entry to the table
Global $szDrive, $szDir, $szFName, $szExt
_PathSplit($SourceFileName, $szDrive, $szDir, $szFName, $szExt)
$IncludeDirs[$I_Cnt] = _PathFull($szDrive & $szDir)
;
; Add \ at the end of the Include dirs in the search table
For $x = 0 To $I_Cnt
	If StringRight($IncludeDirs[$x], 1) <> "\" Then
		$IncludeDirs[$x] &= "\"
	EndIf
Next
;
;  Process scriptfile
;
Global $TempRec, $t_TempRec, $Include_Once, $InIncludeCnt
Global $H_Inp = FileOpen($SourceFileName, 0)
If @error Then
	MsgBox(0, "error", " Unable to open Sourcefile:" & $SourceFileName)
	Exit
EndIf
Global $H_Out = FileOpen($TargetFileName, 2)
If @error Then
	MsgBox(0, "error", " Unable to open Ouputfile:" & $TargetFileName)
	Exit
EndIf
;
While 1
	$TempRec = FileReadLine($H_Inp)
	If @error Then ExitLoop
	$t_TempRec = StringStripWS(StringLeft($TempRec, 50), 3)
	If @error Then ExitLoop
	If StringLeft($TempRec, 8) <> "#include" Then
		FileWriteLine($H_Out, $TempRec)
	Else
		If StringLeft($t_TempRec, 13) = "#include-once" Then
			$Include_Once = 1
		Else
			Add_Include($TempRec)
		EndIf
	EndIf
WEnd
FileClose($H_Inp)
FileClose($H_Out)
ConsoleWrite("+" & $TargetFileName & " outputfile created." & @CRLF)
; strip comment blocks
$fullSource = Fileread($TargetFileName)



;=========================================================
; Add all #Include files to the outputfile - recursively
;=========================================================
Func Add_Include($Include_Rec, $source = "Main")
	Local $TempRec, $ChkInclude, $Include_Once = 0, $NeedsIncluded, $IncludeFile, $IncludeFileFound = 0
	Local $H_Incl
	; Find the proper path
	If StringInStr($Include_Rec,";") then $Include_Rec = StringLeft($Include_Rec, StringInStr($Include_Rec,";")-1)
	$IncludeFile = StringMid(StringStripWS($Include_Rec, 3), 9)
	$IncludeFile = StringStripWS($IncludeFile, 3)
	; Determine the Path sequence to scan for include files
	If StringLeft($IncludeFile, 1) = "<" Then
		$IncludeFile = StringReplace($IncludeFile, ">", "")
		$IncludeFile = StringReplace($IncludeFile, "<", "")
		$IncludeFile = StringStripWS($IncludeFile, 3)
		For $x = 0 To $I_Cnt
			If $IncludeDirs[$x] <> "" And FileExists($IncludeDirs[$x] & $IncludeFile) Then
				$IncludeFile = $IncludeDirs[$x] & $IncludeFile
				$IncludeFileFound = 1
				ExitLoop
			EndIf
		Next
	Else
		$IncludeFile = StringReplace($IncludeFile, "'", "")
		$IncludeFile = StringReplace($IncludeFile, '"', "")
		$IncludeFile = StringStripWS($IncludeFile, 3)
		For $x = $I_Cnt To 0 Step -1
			If $IncludeDirs[$x] <> "" And FileExists($IncludeDirs[$x] & $IncludeFile) Then
				$IncludeFile = $IncludeDirs[$x] & $IncludeFile
				$IncludeFileFound = 1
				ExitLoop
			EndIf
		Next
	EndIf
	; If File is found then determine if it still needs to be included
	If $IncludeFileFound Then
		; Check for #Include_once
		$TempRec = FileRead($IncludeFile)
		If StringInStr($TempRec, "#include-once") Then $Include_Once = 1
		; check If include is already included
		$NeedsIncluded = 1
		If $Include_Once = 1 Then
			For $ChkInclude = 1 To $IncludeFilesCnt
				If $IncludeFiles[$ChkInclude] = $IncludeFile Then
					$NeedsIncluded = 0
					ExitLoop
				EndIf
			Next
		Else
			;TraceLog("==> *** Needs to be included since no #include-once is found.")
		EndIf
		;
		If $NeedsIncluded = 1 Then
			TraceLog("+ ==> IncludeOnce=" & $Include_Once & " Including:" & $IncludeFile & "   Include by:" & $source)
			FileWriteLine($H_Out, ";*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
			FileWriteLine($H_Out, ";* Start Include:" & $IncludeFile & "   Include by:" & $source)
			FileWriteLine($H_Out, ";*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
			$InIncludeCnt = 0
			$IncludeFilesCnt += 1
			$IncludeFiles[$IncludeFilesCnt] = $IncludeFile
			$H_Incl = FileOpen($IncludeFile, 0)
			While 1
				$TempRec = FileReadLine($H_Incl)
				If @error Then ExitLoop
				$t_TempRec = StringStripWS(StringLeft($TempRec, 50), 3)
				If StringLeft($TempRec, 8) <> "#include" Then
					FileWriteLine($H_Out, $TempRec)
				Else
					If StringLeft($t_TempRec, 13) <> "#include-once" Then
						Add_Include($TempRec, $IncludeFile)
					EndIf
				EndIf
			WEnd
			FileWriteLine($H_Out, ";*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
			FileWriteLine($H_Out, ";* End Include:" & $IncludeFile & "   Include by:" & $source)
			FileWriteLine($H_Out, ";*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
			FileClose($H_Incl)
		Else
			TraceLog("  ==> Skipped, Already included:" & $IncludeFile)
			$IncludeFile = ""
		EndIf
	Else
		TraceLog("!==> *** ERROR: include file not found :" & $Include_Rec)
	EndIf
EndFunc   ;==>Add_Include
;
Func TraceLog($text)
	ConsoleWrite($text & @CRLF)
EndFunc   ;==>TraceLog