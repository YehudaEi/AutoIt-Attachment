;======================================================================================
; integer _FileCharacterReplace($file, $search, $replace)
; Replace a certain character in a file
;
;Parameters:
;	string	$file:	 	The file to replace the character, can be a relative or fix path
;	char	$search: 	The character to replace
;	char	$replace:	The character to replace matches with
;
;Remarks:	
;	Can only replace single characters, if a string is given as $search or $replace, the
;	first character of the string will be used

;Return Value:
;	Success:
;	Returns an integer which indicates the number of replacements which were made
;	
;	Failure:
;	Returns -1 and sets @ERROR to:
;		1 = Unable to open file
;		2 = Unable to open temp-file
;		3 = $search is an invalid cahracter
;		4 = $replace is an invalid character
;
;Author:	Marco Tanner
;======================================================================================

Func _FileCharacterReplace($file, $search, $replace)
	Local $cnt = 0
	Local $h_file
	Local $h_tmpfile
	Local $char
	
	$h_file = FileOpen($file, 0)
	If $h_file = -1 Then
		SetError(1)
		Return -1
	EndIf
	
	$h_tmpfile = FileOpen("~tmp", 2)
	If $h_tmpfile = -1 Then
		SetError(2)
		Return -1
	EndIf

	If Asc($search) < 1 Or Asc($search) > 254 Then
		SetError(3)
		Return -1
	EndIf

	If Asc($replace) < 1 Or Asc($replace) > 254 Then
		SetError(4)
		Return -1
	EndIf

	While 1
		$char = FileRead($h_file, 1)
		If @error = -1 Then ExitLoop
		
		If $char = $search Then 
			$char = $replace
			$cnt += 1
		EndIf
		
		FileWrite($h_tmpfile, $char)
	WEnd
	
	FileClose($h_file)
	FileClose($h_tmpfile)
	
	FileMove("~tmp", $file, 1)

	SetError(0)
	Return $cnt
EndFunc