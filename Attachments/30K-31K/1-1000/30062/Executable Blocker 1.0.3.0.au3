#region Script Options ======================================================================================================
#AutoIt3Wrapper_icon=
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=.\Protected.ico		;Filename of the Ico file to use
#AutoIt3Wrapper_OutFile=Executable Blocker.exe           ;Target exe/a3x filename.
#AutoIt3Wrapper_OutFile_Type=exe                ;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=2                   ;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=Y                        ;(Y/N) Compress output program.  Default=Y
;~ #AutoIt3Wrapper_Change2CUI=Y                    ;(Y/N) Change output program to CUI in stead of GUI. Default=N
;** Target program Resource info
#AutoIt3Wrapper_res_comment=Executable Blocker Block all exes from running
#AutoIt3Wrapper_res_description=Executable Blocker
#AutoIt3Wrapper_Res_Fileversion=1.0.3.6
#AutoIt3Wrapper_res_fileversion_autoincrement=Y
#AutoIt3Wrapper_res_legalcopyright=Copyright © 2010 Shafayat
#AutoIt3Wrapper_res_field=Made By|Shafayat
#AutoIt3Wrapper_res_field=Email|Shafayat at yahoo dot com
#AutoIt3Wrapper_res_field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_res_field=Compile Date|%date% %time%
#AutoIt3Wrapper_Run_Debug_Mode=N
#AutoIt3Wrapper_run_cvswrapper=v
#AutoIt3Wrapper_run_obfuscator=y
; Obfuscator
#Obfuscator_parameters=/cs=0 /cn=0 /cf=0 /cv=0 /sf=1
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Change2CUI=n
; Script: Executable Blocker.au3
; Version: 1.02
; Author: Shafayat
; File: 2 of 2
;
; No Includes Needed
#NoTrayIcon
;
#Include <String.au3>
If ($CmdLine[0] = 0) Then
	Exit
Else
	Global $cmd = $CmdLine[1]
EndIf
;
;~ MsgBox(0,"",$Cmd)
Global Const $GUI_EVENT_CLOSE = -3
Global Const $WS_DLGFRAME = 0x00400000
Global Const $WS_POPUPWINDOW = 0x80880000
Global Const $GUI_DISABLE = 128
;
Global $szDrive, $szDir, $szFName, $szExt, $Child, $Delete = 1234, $Recycle = 1243, $Quarantine = 1423, $Cancel = 1429
Global $CmdPath = _PathSplit($cmd, $szDrive, $szDir, $szFName, $szExt)
Global $clicked = 0
;
Global $SCRIPT_VERSION = "Please Compile !"
If @Compiled Then $SCRIPT_VERSION = FileGetVersion(@ScriptName)
Global $EXE_NAME = ("Executable Blocker"); program name
Global $INI_NAME = @ScriptDir&"\"&$EXE_NAME & ".INI"
Global $LOG_NAME = $EXE_NAME & ".LOG"

If IniRead($INI_NAME,"Allowed",$Cmd,"") = _StringEncrypt (1 , $Cmd, @ScriptFullPath) Then
	Run($CmdLineRaw)
	Exit
EndIf
;
$GUI = GUICreate("Execution Blocked ! - "&$SCRIPT_VERSION, 400, 285, -1, -1)
GUISetIcon(@ScriptDir&"\Protected.ico")
GUICtrlCreateGroup($szFName, 20, 15, 360, 100)
GUICtrlCreateIcon($cmd, 0, 30, 40)
GUICtrlCreateLabel("File Name: " & $szFName & $szExt, 75, 40, 300)
GUICtrlCreateLabel(FileGetVersion($cmd, "ProductName"), 75, 60, 300)
GUICtrlCreateLabel(FileGetVersion($cmd, "FileDescription"), 75, 80, 300)
$Allow = GUICtrlCreateButton("Allow", 20, 125, 80, 30)
$Block = GUICtrlCreateButton("Block", 110, 125, 80, 30)
$Trust = GUICtrlCreateButton("Trust", 210, 125, 80, 30)
If IsAdmin() = 0 Then GUICtrlSetState(-1, $GUI_DISABLE)
$More = GUICtrlCreateButton("More", 300, 125, 80, 30)
GUICtrlCreateLabel("Executable Blocker" & " has detected and blocked effort to execute a File: ", 20, 170, 360, 15)
$filenametext = GUICtrlCreateInput($CmdPath[3]&"."&$CmdPath[4], 20, 190, 360, 20)
GUICtrlSetColor($filenametext, 0x0000FF)
GUICtrlCreateLabel("Full Command Line: ", 20, 220, 360, 15)
$commmandlinefulltext = GUICtrlCreateInput($CmdLineRaw, 20, 240, 360, 20)
GUICtrlSetColor($commmandlinefulltext, 0x0000FF)
GUISetState(@SW_SHOW, $GUI)
;
While 1
	$msg = GUIGetMsg(1)
	Select
		Case $msg[0] = $GUI_EVENT_CLOSE
			If ($msg[1] = $GUI) Then
				If $clicked = 1 Then GUIDelete($CHILD)
				GUIDelete($GUI)
				Exit
			EndIf
			If ($msg[1] = $CHILD) Then
				GUIDelete($CHILD)
				$clicked = 0
			EndIf
		Case $msg[0] = $Allow
			LogThis("Allowed "&$CmdLineRaw)
			Run($CmdLineRaw)
			If $clicked = 1 Then GUIDelete($CHILD)
			GUIDelete($GUI)
			Exit
		Case $msg[0] = $Block
			LogThis("Blocked "&$CmdLineRaw)
			If $clicked = 1 Then GUIDelete($CHILD)
			GUIDelete($GUI)
			Exit
		Case $msg[0] = $Trust
			LogThis("Trusted "&$CmdLineRaw)
			IniWrite($INI_NAME,"Allowed",$Cmd,_StringEncrypt (1 , $Cmd, @ScriptFullPath))
			Run($CmdLineRaw)
			If $clicked = 1 Then GUIDelete($CHILD)
			GUIDelete($GUI)
			Exit
		Case $msg[0] = $More
			If ($clicked = 0) Then
				$clicked = 1
				$CHILD = GUICreate("More....", 400, 290, -1, -1, $WS_DLGFRAME + $WS_POPUPWINDOW, -1, $GUI)
				GUISetIcon(@ScriptDir & '\Protected.ico')
				GUICtrlCreateGroup(_GetFileDets($cmd), 10, 40, 380, 195)
				$ver = @CRLF & _GetFileProps($cmd) & @CRLF & @CRLF & "File Attributes: " & _GetFileAttr($cmd)
				GUICtrlCreateInput($cmd, 20, 10, 360, 20)
				GUICtrlCreateLabel($ver, 20, 60, 360, 165)
				$Quarantine = GUICtrlCreateButton("Quarantine", 10, 245, 75, 30)
				$Recycle = GUICtrlCreateButton("Send to Recycle Bin", 97, 245, 115, 30)
				$Delete = GUICtrlCreateButton("Delete", 225, 245, 75, 30)
				$Cancel = GUICtrlCreateButton("Cancel", 315, 245, 75, 30)
				GUISetState(@SW_SHOW, $CHILD)
			EndIf
		Case $msg[0] = $Cancel
			GUIDelete($CHILD)
			$clicked = 0
		Case $msg[0] = $Delete
			$answer = MsgBox(4, "Confirm Delete", "DELETE this file?")
			If $answer = 7 Then
			Else
				$Del = FileDelete($cmd)
				If ($Del = True) Then
					LogThis("Deleted "&$CmdLineRaw)
					MsgBox(0, "Operation Successful", "File Deleted")
					GUIDelete($CHILD)
					GUIDelete($GUI)
					Exit
				Else
					MsgBox(0, "Operation Failed", "Could NOT Delete")
				EndIf
			EndIf
		Case $msg[0] = $Recycle
			$answer = MsgBox(4, "Confirm Recycle", "RECYCLE this file?")
			If $answer = 7 Then
			Else
				$Del = FileRecycle($cmd)
				If ($Del = True) Then
					LogThis("Recycled "&$CmdLineRaw)
					MsgBox(0, "Operation Successful", "File Recycled")
					GUIDelete($CHILD)
					GUIDelete($GUI)
					Exit
				Else
					MsgBox(0, "Operation Failed", "Could NOT send to Recycle-Bin   ")
				EndIf
			EndIf
		Case $msg[0] = $Quarantine
			$answer = MsgBox(4, "Confirm Quarantine", "QUARANTINE this file?")
			If $answer = 7 Then
			Else
				$Del = FileMove($cmd, "D:\Quarantined\" & $szFName & $szExt & ".QUARANTINED", 9)
				If ($Del = True) Then
					LogThis("Quarantined "&$CmdLineRaw)
					MsgBox(0, "Operation Successful", "Quarantined File to D:\Quarantined\   ")
					GUIDelete($CHILD)
					GUIDelete($GUI)
					Exit
				Else
					MsgBox(0, "Operation Failed", "Could NOT Quarantine")
				EndIf
			EndIf
	EndSelect
WEnd
;------------------------------------------------------------------------------------------------------------
Func _GetFileProps($Parameter)
	Local $testvar
	$testvar = "Internal Name: " & FileGetVersion($Parameter, "InternalName")
	$testvar = $testvar & @CRLF & "Original File Name: " & FileGetVersion($Parameter, "OriginalFilename")
	$testvar = $testvar & @CRLF & "Special Build: " & FileGetVersion($Parameter, "SpecialBuild")
	$testvar = $testvar & @CRLF & "Product Name: " & FileGetVersion($Parameter, "ProductName")
	$testvar = $testvar & @CRLF & "Company Name: " & FileGetVersion($Parameter, "CompanyName")
	$testvar = $testvar & @CRLF & "File Description: " & FileGetVersion($Parameter, "FileDescription")
	$testvar = $testvar & @CRLF & "File Version: " & FileGetVersion($Parameter, "FileVersion")
	$testvar = $testvar & @CRLF & "Product Version: " & FileGetVersion($Parameter, "ProductVersion")
	$testvar = $testvar & @CRLF & "Comments: " & FileGetVersion($Parameter, "Comments")
	Return $testvar
EndFunc
;
Func _GetFileAttr($Parameter)
	Local $att, $testvar, $testvar1, $testvar2, $testvar3, $testvar4
	$testvar = ''
	$att = FileGetAttrib($Parameter)
	$testvar1 = StringInStr($att, 'R', 0, 1)
	$testvar2 = StringInStr($att, 'A', 0, 1)
	$testvar3 = StringInStr($att, 'S', 0, 1)
	$testvar4 = StringInStr($att, 'H', 0, 1)
	If Not ($testvar1 = 0) Then $testvar = ' [ READ-ONLY ] '
	If Not ($testvar2 = 0) Then $testvar = $testvar & ' [ ARCHIVE ] '
	If Not ($testvar3 = 0) Then $testvar = $testvar & ' [ SYSTEM ] '
	If Not ($testvar4 = 0) Then $testvar = $testvar & ' [ HIDDEN ] '
	Return $testvar
EndFunc
;
Func _GetFileDets($Parameter)
	Local $testvar = 0
	$testvar = ("File Size:  " & FileGetSize($Parameter) / 1024 & " Kbs ")
	Return $testvar
EndFunc
;
Func LogThis($Text)
	DirCreate(@AppDataCommonDir&"\"&$EXE_NAME)
	Local $fh = FileOpen(@AppDataCommonDir&"\"&$EXE_NAME&"\"&$LOG_NAME,9)
	FileWriteLine($fh, @YEAR&@MON&@MDAY&"-"&@HOUR&@MIN&@SEC&" "&@UserName&" "&$Text)
	FileClose($fh)
EndFunc
;
; #FUNCTION# ====================================================================================================================
; Name...........: _PathSplit
; Description ...: Splits a path into the drive, directory, file name and file extension parts. An empty string is set if a part is missing.
; Syntax.........: _PathSplit($szPath, ByRef $szDrive, ByRef $szDir, ByRef $szFName, ByRef $szExt)
; Parameters ....: $szPath  - The path to be split (Can contain a UNC server or drive letter)
;                  $szDrive - String to hold the drive
;                  $szDir   - String to hold the directory
;                  $szFName - String to hold the file name
;                  $szExt   - String to hold the file extension
; Return values .: Success - Returns an array with 5 elements where 0 = original path, 1 = drive, 2 = directory, 3 = filename, 4 = extension
; Author ........: Valik
; Modified.......:
; Remarks .......: This function does not take a command line string. It works on paths, not paths with arguments.
; Related .......: _PathFull, _PathMake
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _PathSplit($szPath, ByRef $szDrive, ByRef $szDir, ByRef $szFName, ByRef $szExt)
	; Set local strings to null (We use local strings in case one of the arguments is the same variable)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $pos
	; Create an array which will be filled and returned later
	Local $array[5]
	$array[0] = $szPath; $szPath can get destroyed, so it needs set now
	; Get drive letter if present (Can be a UNC server)
	If StringMid($szPath, 2, 1) = ":" Then
		$drive = StringLeft($szPath, 2)
		$szPath = StringTrimLeft($szPath, 2)
	ElseIf StringLeft($szPath, 2) = "\\" Then
		$szPath = StringTrimLeft($szPath, 2) ; Trim the \\
		$pos = StringInStr($szPath, "\")
		If $pos = 0 Then $pos = StringInStr($szPath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szPath; Prepend the \\ we stripped earlier
			$szPath = ""; Set to null because the whole path was just the UNC server name
		Else
			$drive = "\\" & StringLeft($szPath, $pos - 1) ; Prepend the \\ we stripped earlier
			$szPath = StringTrimLeft($szPath, $pos - 1)
		EndIf
	EndIf
	; Set the directory and file name if present
	Local $nPosForward = StringInStr($szPath, "/", 0, -1)
	Local $nPosBackward = StringInStr($szPath, "\", 0, -1)
	If $nPosForward >= $nPosBackward Then
		$pos = $nPosForward
	Else
		$pos = $nPosBackward
	EndIf
	$dir = StringLeft($szPath, $pos)
	$fname = StringRight($szPath, StringLen($szPath) - $pos)
	; If $szDir wasn't set, then the whole path must just be a file, so set the filename
	If StringLen($dir) = 0 Then $fname = $szPath
	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf
	; Set the strings and array to what we found
	$szDrive = $drive
	$szDir = $dir
	$szFName = $fname
	$szExt = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc ;==>_PathSplit
;
