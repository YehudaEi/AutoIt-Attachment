;
; converts reg files to au3 scripts
; reads simple unicode-files (like reg files from regedit windows 2000/xp)
;
; known problem: not all regtypes are supported by autoit
; 
;                                                     by albach_s@yahoo.de

global $file_in, $file_in_handle, $file_in_size, $file_out, $file_out_handle
global $reg_delete, $reg_key, $reg_valuename, $reg_type, $reg_value
global $eof, $lines_written, $lines_read, $file_read_size, $regedit

;set default params
if 1 Then
	$shortkeys = 0
	$regedit = 0
	$step = 0
	
	$reg_delete = 0
	$reg_key = ""
	$reg_valuename = ""
	$reg_type = ""
	$reg_value = ""
	
	$eof = 0
	$lines_written = 0
	$lines_read = 0
	$file_read_size = 0
EndIf

;start and fileselect-dialogs
if 1 then 
; 	MsgBox(0, "reg2au3", "Welcome to reg2au3 !" & @cr & @CR _ 
; 	& "With this handy little tool you're able to convert a standard .reg-file" & @CR _
; 	& "(previously exported from registry) to an AutoIt ready .au3-file." & @cr & @cr _
; 	& "Please select source-file and destination-file at the next dialogs" & @cr _
; 	& "and let this script do the rest.")
	
	$file_in = FileOpenDialog("reg2au3 - select source-file", "", ".reg-files (*.reg)", 1 )
	If @error Then _Error("source-file is needed")
	$file_in_size = FileGetSize($file_in)
	If $file_in_size = 0 Then _Error("source-file is empty")
		
	$file_out = FileSaveDialog( "reg2au3 - select destination-file", "", "AU3-Scripts (*.au3)", 24, _File_Name($file_in) & "_reghack.au3")
	If @error Then _Error("destination-file is needed")

; 	$a = MsgBox(36, "reg2au3", "Do you like short Registry keys ?" & @cr & @cr _
; 	& "like ""HKLM"" instead of ""HKEY_LOCAL_MACHINE"".")
; 	if $a = 6 then $shortkeys = 1
EndIf

_Files_Open()
ProgressOn("reg3au3 - progress", "working ...")

;main script
While 1
	$line = _File_Read_Line()
	Select
	case $eof and $line = ""
		if $step = 1 then _File_Write()
		ExitLoop
	case $line = ""
	case $regedit = 0
		if $line = "REGEDIT4" then $regedit = 4
		if $line = "Windows Registry Editor Version 5.00" Then $regedit = 5
	case StringLeft($line, 1) = "[" And StringRight($line, 1) = "]"			;New REG-Key
		$reg_valuename = ""
		$reg_type = ""
		$reg_value = ""
		if $shortkeys Then
			$line = StringReplace($line, "[HKEY_LOCAL_MACHINE", "[HKLM")
			$line = StringReplace($line, "[HKEY_CLASSES_ROOT", "[HKCR")
			$line = StringReplace($line, "[HKEY_CURRENT_USER", "[HKCU")
			$line = StringReplace($line, "[HKEY_USERS", "[HKU")
			$line = StringReplace($line, "[HKEY_CURRENT_CONFIG", "[HKCC")
		EndIf
		$line = StringTrimRight(StringTrimLeft($line, 1), 1)
		if $step = 1 Then
			if StringInStr($line, $reg_key) = 0 Then _File_Write()
		EndIf
		$reg_key = $line
		if StringLeft($reg_key, 1) = "-" Then
			$reg_delete = 1
			$reg_key = StringTrimLeft($reg_key, 1)
			_File_Write()
			$step = 0
		Else
			$step = 1
		EndIf
	case $step < 1
	Case Else
		$step = 2
		$err = 0
		if StringLeft($line, 2) = "@=" Then
			$reg_valuename = "@"
			$line = StringTrimLeft($line, 2)
			if $line = "-" then $err = 1
		ElseIf StringLeft($line, 1) = '"' Then
			$pos = 0
			$esc = 0
			$reg_valuename = ""
			for $i = 1 to stringlen($line)
				$a = stringmid($line, $i, 1)
				Select
				case $esc
					$esc = 0
					$reg_valuename = $reg_valuename & $a
				case $a = '\'
					$esc = 1
				case $a = '"'
					if $i > 1 Then 
						$pos = $i + 1
						ExitLoop
					EndIf
				case Else
					$reg_valuename = $reg_valuename & $a
				EndSelect
			Next
			if StringMid($line, $pos, 1) = "=" then
				$line = StringTrimLeft($line, $pos)
			Else
				$err = 2
			EndIf
		Else
			$err = 3
		EndIf

		if $err Then
			msgbox(4144, "reg2au3", "Warning:" & @cr & "bad syntax at value-name - " & $err & @cr & "in line: " & $lines_read )
			ContinueLoop
		EndIf

		if StringLeft($line, 1) = '"' And StringRight($line, 1) = '"' Then
			$reg_type = "REG_SZ"
			$pos = 0
			$esc = 0
			$reg_value = ""
			for $i = 1 to stringlen($line)
				$a = stringmid($line, $i, 1)
				Select
				case $esc
					$esc = 0
					$reg_value = $reg_value & $a
				case $a = '\'
					$esc = 1
				case $a = '"'
					if $i > 1 Then
						$pos = $i +1
						ExitLoop
					EndIf
				case Else
					$reg_value = $reg_value & $a
				EndSelect
			Next
		ElseIf StringLeft($line, 1) = "-" Then
			$reg_delete = 1
		Else
			$type = StringLeft($line, StringInStr($line, ":"))
			$line = StringTrimLeft($line, StringLen($type))
			Select
			case $type = "dword:"
				$reg_type = "REG_DWORD"
				$reg_value = Dec($line)
			case $type = "hex(7):"
				$reg_type = "REG_MULTI_SZ"
				$reg_value = _Hex_Convert($line)
			case $type = "hex(2):"
				$reg_type = "REG_EXPAND_SZ"
				$reg_value = _Hex_Convert($line)
			case $type = "hex:"
				$reg_type = "REG_BINARY"
				$reg_value = StringReplace($line, ",", "")
			case StringLeft($type, 3) = "hex"
				msgbox(4144, "reg2au3", "Warning:" & @cr & "unsupported key-type - " & $type & @cr & "in line: " & $lines_read , 3)
				ContinueLoop
			case Else
				msgbox(4144, "reg2au3", "Warning:" & @cr & "bad syntax at key-type" & @cr & "in line: " & $lines_read )
				ContinueLoop
			EndSelect
		EndIf
		_File_Write()
	EndSelect
WEnd

;some Types of Registry Values
;hex: REG_BINARY
;hex(0): REG_NONE							- Null value
;hex(1): REG_SZ								- Null terminated Unicode fixed string value
;hex(2): EXPAND_SZ							- Null terminated unexpanded Unicode/ANSI environment string value
;hex(3): REG_BINARY							- Binary value of any form/length
;hex(4): REG_DWORD							- 32-bit numerical value
;hex(4): REG_DWORD_LITTLE_ENDIAN  			- little-endian 32-bit numerical value (same as REG_DWORD)
;hex(5): REG_DWORD_BIG_ENDIAN				- 32-bit reversed numerical value
;hex(6): REG_LINK							- Symbolic Unicode link string value
;hex(7): REG_MULTI_SZ						- Array of multiple Unicode strings separated/ended by null characters
;hex(8): REG_RESOURCE_LIST					- Device driver list of hardware resources in Resource Map tree
;hex(9): REG_FULL_RESOURCE_DESCRIPTOR		- List of hardware resources in Description tree
;hex(a): REG_RESOURCE_REQUIREMENTS_LIST		- Device driver list of hardware resource requirements in Resource Map tree
;hex(?): REG_QWORD							- 64-bit numerical value
;hex(?): REG_QWORD_LITTLE_ENDIAN  			- little-endian 64-bit numerical value (same as REG_QWORD)

_Files_Close()

;end-dialog
if 1 then 
	ProgressSet(100 , "Done", "Complete")
	sleep(1000)
	ProgressOff()
EndIf

;returns converted hex-string suitable to regwrite
Func _Hex_Convert( $hex)
	local $i, $a, $string
	$string = ""
	for $i = 1 to StringLen($hex)
		$a = chr(dec(StringMid($hex, $i, 2)))
		if $a = chr(0) then $a = @lf
		$string = $string & $a
		if $regedit = 5 then 
			$i = $i + 5
		Else
			$i = $i + 2
		EndIf
	Next
	While StringRight($string,1) = @LF
		$string = StringTrimRight($string, 1)
	WEnd
	return $string
EndFunc

;extract the filename without extension
Func _File_Name( $file )
	$fn = StringRight( $file , stringlen( $file ) - StringInStr($file, "\", 0, -1) )
	if StringInStr($fn, ".") then $fn = StringLeft($fn, StringInStr($fn, ".")-1)
	Return $fn
EndFunc

;returns a string containing the commandline
Func _Create_Commandline()
	Local $cmdline
	if $reg_delete Then
		$cmdline = "RegDelete(" & chr(34) & _Clean_String($reg_key) & chr(34)
		if $reg_valuename <> "" Then
			$cmdline = $cmdline & ", " & chr(34) & _Clean_String($reg_valuename) & chr(34)
		Else
			$reg_key = ""
		EndIf
		$cmdline = $cmdline & ")"
		$reg_delete = 0
	Else
		$cmdline = "RegWrite(" & chr(34) & _Clean_String($reg_key) & chr(34)
		if $reg_valuename <> "" Then
			if $reg_valuename = "@" then $reg_valuename = ""
			$cmdline = $cmdline & ", " & chr(34) & _Clean_String($reg_valuename) & chr(34)
			$cmdline = $cmdline & ", " & chr(34) & $reg_type & chr(34)
			$cmdline = $cmdline & ", " & chr(34) & _Clean_String($reg_value) & chr(34)
		EndIf
		$cmdline = $cmdline & ")"
	EndIf
	$reg_valuename = ""
	$reg_type = ""
	$reg_value = ""
	Return $cmdline
EndFunc

;cleans given String from @LF
Func _Clean_String( $val )
	$val = StringReplace($val, '"', '""')
	$val = StringReplace($val, @lf, '" & @lf & "')
	Return $val
EndFunc

;open the input and output files
Func _Files_Open()
	$file_in_handle = FileOpen($file_in, 0)
	If $file_in_handle = -1 Then _Error( "Unable to open source-file.")
	$file_out_handle = FileOpen($file_out, 2)
	If $file_out_handle = -1 Then _Error( "Unable to open destinaion-file.")
EndFunc

;reads a line from a file
Func _File_Read_Line()
	local $line, $a, $b, $c, $r
	$line = ""
	$c = 1
	While $c
		$c = 0
		$r = ""
		while 1
			$a = FileRead($file_in_handle, 1)
			If @error = -1 Then 
				$eof = 1
				ExitLoop
			EndIf
			$file_read_size = $file_read_size + 1
			$b = asc($a)
			if $b > 0 and $b < 254 Then $r = $r & $a
			if $b = 10 then ExitLoop
		WEnd
		$lines_read = $lines_read + 1
		_Show_Progress()
		$r = StringStripWS($r, 3)
		if StringRight($r, 1) = "\" Then			;regedit uses the backslash to split long lines
			$r = StringTrimRight($r, 1)
			$c = 1
		EndIf
		$line = $line & $r
	WEnd
	return $line
EndFunc

;Write Commandline to Outputfile
Func _File_Write()
	local $a
	$a = FileWriteLine( $file_out_handle, _Create_Commandline() )
	if $a = 0 Then _Error( "Unable to write to " & $file_in )
	$lines_written = $lines_written + 1
EndFunc

;close the input and output files
Func _Files_Close()
	if $file_in_handle then FileClose($file_in_handle)
	if $file_out_handle then FileClose($file_out_handle)
EndFunc

;cleanup output files
Func _Files_Cleanup()
	FileDelete($file_out)
EndFunc

;shows the progress bar
Func _Show_Progress()
	local $p
	$p = int($file_read_size * 100 / $file_in_size)
	ProgressSet( $p, "current line: " & $lines_read)
EndFunc

;errorhandling
Func _Error( $message )
	_Files_Close()
	_Files_Cleanup()
	ProgressOff()
	msgbox(16, "reg2au3", "ERROR:" & @cr & $message)
	Exit
EndFunc

 


