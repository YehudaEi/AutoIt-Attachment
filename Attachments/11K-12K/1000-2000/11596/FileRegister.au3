;==============================================================================================
;
; Description:		FileRegister($ext, $cmd, $verb[, $def[, $icon = ""[, $desc = ""]]])
;					Registers a file type in Explorer
; Parameter(s):		$ext - 	File Extension without period eg. "zip"
;					$cmd - 	Program path with arguments eg. '"C:\test\testprog.exe" "%1"'
;							(%1 is 1st argument, %2 is 2nd, etc.)
;					$verb - Name of action to perform on file
;							eg. "Open with ProgramName" or "Extract Files"
;					$def - 	Action is the default action for this filetype
;							(1 for true 0 for false)
;							If the file is not already associated, this will be the default.
;					$icon - Default icon for filetype including resource # if needed
;							eg. "C:\test\testprog.exe,0" or "C:\test\filetype.ico"
;					$desc - File Description eg. "Zip File" or "ProgramName Document"
;
;===============================================================================================
Func FileRegister($ext, $cmd, $verb, $def = 0, $icon = "", $desc = "")
	$loc = RegRead("HKCR\." & $ext, "")
	If @error Then
		RegWrite("HKCR\." & $ext, "", "REG_SZ", $ext & "file")
		$loc = $ext & "file"
	EndIf
	$curdesc = RegRead("HKCR\" & $loc, "")
	If @error Then
		If $desc <> "" Then
			RegWrite("HKCR\" & $loc, "", "REG_SZ", $desc)
		EndIf
	Else
		If $desc <> "" And $curdesc <> $desc Then
			RegWrite("HKCR\" & $loc, "", "REG_SZ", $desc)
			RegWrite("HKCR\" & $loc, "olddesc", "REG_SZ", $curdesc)
		EndIf
		If $curdesc = "" And $desc <> "" Then
			RegWrite("HKCR\" & $loc, "", "REG_SZ", $desc)
		EndIf
	EndIf
	$curverb = RegRead("HKCR\" & $loc & "\shell", "")
	If @error Then
		If $def = 1 Then
			RegWrite("HKCR\" & $loc & "\shell", "", "REG_SZ", $verb)
		EndIf
	Else
		If $def = 1 Then
			RegWrite("HKCR\" & $loc & "\shell", "", "REG_SZ", $verb)
			RegWrite("HKCR\" & $loc & "\shell", "oldverb", "REG_SZ", $curverb)
		EndIf
	EndIf
	$curcmd = RegRead("HKCR\" & $loc & "\shell\" & $verb & "\command", "")
	If Not @error Then
		RegRead("HKCR\" & $loc & "\shell\" & $verb & "\command", "oldcmd")
		If @error Then
			RegWrite("HKCR\" & $loc & "\shell\" & $verb & "\command", "oldcmd", "REG_SZ", $curcmd)
		EndIf
	EndIf
	RegWrite("HKCR\" & $loc & "\shell\" & $verb & "\command", "", "REG_SZ", $cmd)
	If $icon <> "" Then
		$curicon = RegRead("HKCR\" & $loc & "\DefaultIcon", "")
		If @error Then
			RegWrite("HKCR\" & $loc & "\DefaultIcon", "", "REG_SZ", $icon)
		Else
			RegWrite("HKCR\" & $loc & "\DefaultIcon", "", "REG_SZ", $icon)
			RegWrite("HKCR\" & $loc & "\DefaultIcon", "oldicon", "REG_SZ", $curicon)
		EndIf
	EndIf
EndFunc

;===============================================================================
;
; Description:		FileUnRegister($ext, $verb)
;					UnRegisters a verb for a file type in Explorer
; Parameter(s):		$ext - File Extension without period eg. "zip"
;					$verb - Name of file action to remove
;							eg. "Open with ProgramName" or "Extract Files"
;
;===============================================================================
Func FileUnRegister($ext, $verb)
	$loc = RegRead("HKCR\." & $ext, "")
	If Not @error Then
		$oldicon = RegRead("HKCR\" & $loc & "\shell", "oldicon")
		If Not @error Then
			RegWrite("HKCR\" & $loc & "\DefaultIcon", "", "REG_SZ", $oldicon)
		Else
			RegDelete("HKCR\" & $loc & "\DefaultIcon", "")
		EndIf
		$oldverb = RegRead("HKCR\" & $loc & "\shell", "oldverb")
		If Not @error Then
			RegWrite("HKCR\" & $loc & "\shell", "", "REG_SZ", $oldverb)
		Else
			RegDelete("HKCR\" & $loc & "\shell", "")
		EndIf
		$olddesc = RegRead("HKCR\" & $loc, "olddesc")
		If Not @error Then
			RegWrite("HKCR\" & $loc, "", "REG_SZ", $olddesc)
		Else
			RegDelete("HKCR\" & $loc, "")
		EndIf
		$oldcmd = RegRead("HKCR\" & $loc & "\shell\" & $verb & "\command", "oldcmd")
		If Not @error Then
			RegWrite("HKCR\" & $loc & "\shell\" & $verb & "\command", "", "REG_SZ", $oldcmd)
			RegDelete("HKCR\" & $loc & "\shell\" & $verb & "\command", "oldcmd")
		Else
			RegDelete("HKCR\" & $loc & "\shell\" & $verb)
		EndIf
	EndIf
EndFunc