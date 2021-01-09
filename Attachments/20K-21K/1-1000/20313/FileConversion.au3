;======================================================================================
; int _FileLineAdd($file, $add, [$flag])
; Add a character or string to each line of a file
;
;Parameters:
;	string or handle	$file:	 	The file or filehandle, can be a relative or fix path
;	string				$add:		The character or string to add
;	int					$flag:		0(Default)=Add at the end of the line, 1=Add at the beginning of the line
;
;Return Value:
;	Success:
;	Returns an integer >= 0 indicating the number of edited lines
;	
;	Failure:
;	Returns -1 and sets @ERROR to:
;	1 = Unable to open source file
;	2 = Unable to open tmp-file
;	3 = Unable to replace source-file with tmp-file
;
;Author:	Marco Tanner
;======================================================================================

Func _FileLineAdd($file, $add, $flag=0)
	Local $read, $write, $line, $cnt = 0
	
	$read = FileOpen($file, 0)
	If $read = -1 Then 
		SetError(1)
		Return -1
	EndIf
	$write= FileOpen(@TempDir & "\~tmp", 2)
	If $write = -1 Then
		SetError(2)
		Return -1	
	EndIf
	
	While 1
		$line = FileReadLine($read)
		If @error Then ExitLoop
		
		If $flag = 0 Then
			FileWriteLine($write, $line & $add)
		Else
			FileWriteLine($write, $add & $line)
		EndIf
		$cnt += 1
	WEnd
	
	FileClose($read)
	FileClose($write)
	
	If Not FileMove(@TempDir & "\~tmp", $file, 1) Then
		SetError(3)
		Return -1
	EndIf
	
	Return $cnt
EndFunc

;======================================================================================
; int _FileLineSub($file, $sub, [$flag])
; Cut a number of characters from all lines in a file
;
;Parameters:
;	string or handle	$file:	 	The file or filehandle, can be a relative or fix path
;	string				$sub:		The number of characters to cut
;	int					$flag:		Option to cut at the left or right side from the line: 0(default)=cut right, 1=cut left
;
;Return Value:
;	Success:
;	Returns an integer >= 0 indicating the number of edited lines
;	
;	Failure:
;	Returns -1 and sets @ERROR to:
;	1 = Unable to open source file
;	2 = Unable to open tmp-file
;	3 = Unable to replace source-file with tmp-file
;
;Author:	Marco Tanner
;======================================================================================

Func _FileLineSub($file, $sub, $flag = 0)
	Local $read, $write, $line, $cnt = 0
	
	$read = FileOpen($file, 0)
	If $read = -1 Then 
		SetError(1)
		Return -1
	EndIf
	$write= FileOpen(@TempDir & "\~tmp", 2)
	If $write = -1 Then
		SetError(2)
		Return -1	
	EndIf
	
	While 1
		$line = FileReadLine($read)
		If @error Then ExitLoop
		
		If $flag = 0 Then
			FileWriteLine($write, StringTrimRight($line, $sub))
		Else
			FileWriteLine($write, StringTrimLeft($line, $sub))
		EndIf
		$cnt += 1
	WEnd
	
	FileClose($read)
	FileClose($write)
	
	If Not FileMove(@TempDir & "\~tmp", $file, 1) Then
		SetError(3)
		Return -1
	EndIf
	
	Return $cnt
EndFunc

;======================================================================================
; int _FileCharacterReplace($file, $search, $replace)
; Replace a certain character in a file
;
;Parameters:
;	string or handle	$file:	 	The file or filehandle to replace the character, can be a relative or fix path
;	char				$search: 	The character to replace
;	char				$replace:	The character to replace matches with
;
;Remarks:	
;	Can only replace single characters, if a string is given as $search or $replace, the
;	first character of the string will be used

;Return Value:
;	Success:
;	Returns an integer >= 0 which indicates the number of replacements which were made
;	
;	Failure:
;	Returns -1 and sets @ERROR to:
;	1 = Unable to open file
;	2 = Unable to open temp-file
;	3 =	$search is an invalid character
;	4 = $replace is an invalid character
;	5 = Unable to replace source-file with tmp-file
;
;Author:	Marco Tanner
;======================================================================================

Func _FileCharacterReplace($file, $search, $replace)
	Local $cnt = 0
	Local $read
	Local $write
	Local $char
	
	$read = FileOpen($file, 0)
	If $read = -1 Then
		SetError(1)
		Return -1
	EndIf
	
	$write = FileOpen("~tmp", 2)
	If $write = -1 Then
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
		$char = FileRead($read, 1)
		If @error = -1 Then ExitLoop
		
		If $char = $search Then 
			$char = $replace
			$cnt += 1
		EndIf
		
		FileWrite($write, $char)
	WEnd
	
	FileClose($read)
	FileClose($write)
	
	If Not FileMove("~tmp", $file, 1) Then
		SetError(5)
		Return -1
	EndIf

	Return $cnt
EndFunc

;======================================================================================
; integer _FileDeleteLine($file, $search, [$opt], [$case], [$flag])
; Delete all lines containing a certain substring in a file
;
;Parameters:
;	string	$file:	 	The file to edit, can be a relative or fix path
;	string	$search: 	The char or string to search for
;	int		$opt:		0 (Default)=Match anywhere in the line, 1=Match only the beginning of the line, 2=Match only the end of the line
;	int		$case:		Search is: 0 (Default)=Case insensitive, 1=Case sensitive
;	int		$flag		0 (Default)=Leave empty lines, 1=Delete empty lines
;
;Remarks:	
;	If an empty search string is given, no lines are matched.
;
;Return Value:
;	Success:
;	Returns an integer >=0 which indicates the number of deleted lines
;	
;	Failure:
;	Returns -1 and sets @ERROR to:
;	1 = Unable to open file
;	2 = Unable to open temp-file
;	3 = Unable to replace source-file with tmp-file
;
;Author:	Marco Tanner
;======================================================================================

Func _FileDeleteLine($file, $search, $opt=0, $case=0, $flag=0)
	Local $read, $write, $line, $cnt = 0, $match
	
	$read = FileOpen($file, 0)
	If $read = -1 Then 
		SetError(1)
		Return -1
	EndIf
	$write= FileOpen(@TempDir & "\~tmp", 2)
	If $write = -1 Then
		SetError(2)
		Return -1	
	EndIf
	
	While 1
		$line = FileReadLine($read)
		If @error Then ExitLoop
		
		$match = 0
		
		Select
			Case $opt = 0
				If $case = 0 Then
					If StringInStr($line, $search, 2) Then $match = 1
				Else
					If StringInStr($line, $search, 1) Then $match = 1
				EndIf
			Case $opt = 1
				If $case = 0 Then
					If StringCompare(StringLeft($line, StringLen($search)), $search, 2) = 0 Then $match = 1
				Else
					If StringCompare(StringLeft($line, StringLen($search)), $search, 1) = 0 Then $match = 1
				EndIf
			Case $opt = 2
				If $case = 0 Then
					If StringCompare(StringRight($line, StringLen($search)), $search, 2) = 0 Then $match = 1
				Else
					If StringCompare(StringRight($line, StringLen($search)), $search, 1) = 0 Then $match = 1
				EndIf
		EndSelect
		
		If $match = 0 Then
			If $flag = 1 And $line = "" Then
				$cnt += 1
			Else
				FileWriteLine($write, $line)
			EndIf
		Else
			$cnt += 1
		EndIf		
	WEnd
	
	FileClose($read)
	FileClose($write)
	
	If Not FileMove(@TempDir & "\~tmp", $file, 1) Then
		SetError(3)
		Return -1
	EndIf
	
	Return $cnt
EndFunc

;======================================================================================
; integer _FileExtractLine($file, $search, $target, [$opt], [$case])
; Extract all lines containing a certain substring in a file
;
;Parameters:
;	string	$file:	 	The file to edit, can be a relative or fix path
;	string	$search: 	The char or string to search for
;	int		$opt:		0 (Default)=Match anywhere in the line, 1=Match only the beginning of the line, 2=Match only the end of the line
;	int		$case:		Search is: 0 (Default)=Case insensitive, 1=Case sensitive
;
;Remarks:	
; 	Works a bit like the unix command 'grep'
;	The source file remains untouched
;	If an empty search string is given, no lines are matched.
;
;Return Value:
;	Success:
;	Returns an integer which indicates the number of extracted lines
;	
;	Failure:
;	Returns -1 and sets @ERROR to:
;	1 = Unable to open file
;	2 = Unable to open temp-file
;	3 = Unable to write target-file
;
;Author:	Marco Tanner
;======================================================================================

Func _FileExtractLine($file, $search, $target, $opt=0, $case=0)
	Local $read, $write, $line, $cnt = 0, $match
	
	$read = FileOpen($file, 0)
	If $read = -1 Then 
		SetError(1)
		Return -1
	EndIf
	$write= FileOpen(@TempDir & "\~tmp", 2)
	If $write = -1 Then
		SetError(2)
		Return -1	
	EndIf
	
	While 1
		$line = FileReadLine($read)
		If @error Then ExitLoop
		
		$match = 0
		
		Select
			Case $opt = 0
				If $case = 0 Then
					If StringInStr($line, $search, 2) Then $match = 1
				Else
					If StringInStr($line, $search, 1) Then $match = 1
				EndIf
			Case $opt = 1
				If $case = 0 Then
					If StringCompare(StringLeft($line, StringLen($search)), $search, 2) = 0 Then $match = 1
				Else
					If StringCompare(StringLeft($line, StringLen($search)), $search, 1) = 0 Then $match = 1
				EndIf
			Case $opt = 2
				If $case = 0 Then
					If StringCompare(StringRight($line, StringLen($search)), $search, 2) = 0 Then $match = 1
				Else
					If StringCompare(StringRight($line, StringLen($search)), $search, 1) = 0 Then $match = 1
				EndIf
		EndSelect
		
		If $match = 1 Then
			FileWriteLine($write, $line)
			$cnt += 1
		EndIf		
	WEnd
	
	FileClose($read)
	FileClose($write)
	
	If Not FileMove(@TempDir & "\~tmp", $target, 1) Then
		SetError(3)
		Return -1
	EndIf
	
	Return $cnt
EndFunc