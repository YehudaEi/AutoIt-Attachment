#cs ----------------------------------------------------------------------------
 Functions for use with 7-zip32.dll
 Version 0.4.1b
 Copyright (C) 2006 JAK-Software.org. Released under GNU LGPL.

 Please Note:	To use the functions, the 7-zip32.dll file must be in the path. If you saved it into a subfolder use SetEnv and GetEnv

 Changes:
 0.4.1b: - Modified by Jazkal to include install of the 7-zip32.dll to the path if not there already
	     - Edited _SevenZipAdd Comment section to explain actual Function parameters
 0.4.1:	- Replaced last parameter: "str", 0 ==> "int", 0

 0.4:	- Added Hwnd Argument
	- Modified Variable Names
	- Added SetError(1) and Return 0 for Errors

 0.3:	- Removed @ScriptDir in DllOpen
#ce ----------------------------------------------------------------------------

;===============================================================================
;
; Description:      Adds Files to an Archive/Creates an Archiv
; Parameter(s):     $sArchive   - The Archive Name to Create
;                   $sFiles     - The Files/Folder to add to the Archive
;                   $iLevel     - set compression Method (1-9) ???
;					$sType		- What type of Archive ???
;                   $sCMDLine   - Optional Options
;                   $hWnd       - The Window
; Requirement(s):   None
; Return Value(s):  On Success - Return 1
;                   On Failure - Return 0
; Author(s):        JAK-Software.org (modified by Jazkal)
; Note(s):          Need 7-zip32.dll in the path (added line to install DLL file into Path if not there already - Jazkal)
;
;===============================================================================
Func _SevenZipAdd($sArchive, $sFiles, $iLevel = 6, $sType = "7z", $sCMDLine = "", $hWnd = 0)
	FileInstall("C:\Program Files\AutoIt3\Include\7-zip32.dll", @WindowsDir&"\System32\7-zip32.dll",0)
	$dll = DllOpen("7-zip32.dll")
	$result = DllCall($dll, "int", "SevenZip", "hwnd", $hWnd, "str", 'a ' & $sCMDLine & '  -mx' & $iLevel & ' -t' & $sType & ' ' & $sArchive & ' ' & $sFiles, "int", 0)
	$error = @error
	DllClose($dll)
	If $error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_SevenZipAdd
;===============================================================================
;
; Description:      Executes 7-zip Commands (Syntax Like in 7z.exe/7za.exe)
; Parameter(s):     $sCMDLine   - The Commandline
;                   $hWnd       - The Window
; Requirement(s):   None
; Return Value(s):  On Success - Return 1
;                   On Failure - Return 0
; Author(s):        JAK-Software.org
; Note(s):          Need 7-zip32.dll in the path (added line to install DLL file into Path if not there already - Jazkal)
;
;===============================================================================
Func _SevenZipCMD($sCMDLine, $hWnd = 0)
	FileInstall("C:\Program Files\AutoIt3\Include\7-zip32.dll", @WindowsDir&"\System32\7-zip32.dll",0)
	$dll = DllOpen("7-zip32.dll")
	DllCall($dll, "int", "SevenZip", "hwnd", $hWnd, "str", $sCMDLine, "int", 0)
	$error = @error
	DllClose($dll)
	If $error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_SevenZipCMD
;===============================================================================
;
; Description:      Extracts files from an archive
; Parameter(s):     $sArchive    - The Archive to use
;                   $sOutDir    - Where to extract the files
;                   $sFilter    - Files to extract from the Archive (e.g. *.exe)
;                   $sCMDLine   - Optional Options
;                   $hWnd       - The Window
; Requirement(s):   None
; Return Value(s):  On Success - Return 1
;                   On Failure - Return 0
; Author(s):        JAK-Software.org
; Note(s):          Need 7-zip32.dll in the path (added line to install DLL file into Path if not there already - Jazkal)
;
;===============================================================================
Func _SevenZipExtract($sArchive, $sOutDir = ".", $sFilter = '*', $sCMDLine = '', $hWnd = 0)
	FileInstall("C:\Program Files\AutoIt3\Include\7-zip32.dll", @WindowsDir&"\System32\7-zip32.dll",0)
	$dll = DllOpen("7-zip32.dll")
	DllCall($dll, "int", "SevenZip", "hwnd", $hWnd, "str", 'x ' & $sCMDLine & ' -o' & $sOutDir & ' ' & $sArchive & ' ' & $sFilter, "int", 0)
	$error = @error
	DllClose($dll)
	If $error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_SevenZipExtract
