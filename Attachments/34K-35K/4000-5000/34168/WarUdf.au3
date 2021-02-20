#include-once

; #INDEX# =======================================================================================================================
; Title .........:	Write and send UDF
; AutoIt Version :	How should i know?
; Language ......:	English
; Description ...:	A function that will find out if the program has been ran before.
; Author(s) .....:	Maffe811
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;	WarUdf
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........:	WarUdf
; Description ...:	A function that will find out if the program has been ran before.
; Syntax.........:	Func WarUdf($filedir, $filename, $var, $section, $read = 0, $newstart, $oldstart )
; Parameters ....:
;					$filedir	Directory for where to look for file.
;					$filename	The file name.
;					$var 		Variable in the file .
;					$section	Section the variable in the file will be.
;					$read 		The value that represents if the file has been opened before.
; Return values .:	0			The program HAS NOT been ran before.
;					1			The program HAS been ran before.
; Author ........:	Maffe811
; Related .......:	IniRead, IniWrite
; Example .......:	No, just follow the instructions!
; ===============================================================================================================================
Func WarUdf($filedir, $filename, $section, $var)
	If FileExists($filedir) Then ;Check if the file directory exist.
		FileChangeDir($filedir) ;If it exists, go to the file directory.
		$read = IniRead($filename, $section, $var, 0) ;Read the ini file, if nothing found $read = 0.
	Else
		DirCreate ($filedir) ;If file directory doesnt exist, create it.
	EndIf

	While 1
		IniWrite ($filename, $section, $var, 1);Writes the ini file, so it knows the program has been ran before!
		Return $read;Returns the $read variable
	WEnd
EndFunc;==> WarUdf()

