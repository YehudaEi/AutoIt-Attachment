#include-once

; #INDEX# =======================================================================================================================
; Title .........:	IsRun
; AutoIt Version :	How should i know?
; Language ......:	English
; Description ...:	A function that will find out if the program has been ran before.
; Author(s) .....:	Maffe811
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;	_IsRun
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........:	_IsRun
; Description ...:	A function that will find out if the program has been ran before.
; Syntax.........:	Func _IsRun($filedir, $filename, $var, $section, $read = 0, $newstart, $oldstart )
; Parameters ....:	$sFiledir	Directory for where to look for file.
;					$sFilename	The file name.
;					$sVar 		Variable in the file .
;					$sSection	Section the variable in the file will be.
;					$sRead 		The value that represents if the file has been opened before.
; Return values .:	0			The program HAS NOT been ran before.
;					1			The program HAS been ran before.
; Author ........:	Maffe811
; Related .......:	IniRead, IniWrite
; ===============================================================================================================================
Func _IsRun($sFiledir, $sFilename, $sSection, $sVar)
	If FileExists($sFiledir) Then ;Check if the file directory exist.
		FileChangeDir($sFiledir) ;If it exists, go to the file directory.
	Local $sRead = IniRead($sFilename, $sSection, $sVar, 0) ;Read the ini file, if nothing found $read = 0.
	Else
		DirCreate ($sFiledir) ;If file directory doesnt exist, create it.
	EndIf
	While 1
		IniWrite ($sFilename, $sSection, $sVar, 1);Writes the ini file, so it knows the program has been ran before!
		Return $sRead;Returns the $read variable
	WEnd
EndFunc;==> _IsRun()

