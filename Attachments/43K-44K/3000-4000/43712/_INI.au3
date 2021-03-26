#Region: Initialize
	#Include-once
	#Include <D:\My Documents\My Programs\UDF\_MyFunctions.au3>
	#Include <Constants.au3>
	#Include <File.au3>
	#Include <String.au3>
	#Include <Array.au3>
	
	Global $Error_section
	
	Dim $Ask
	Dim $Depth
	Dim $Section
	Dim $INIFile_array
	Dim $Key
	Dim $vKey
	Dim $Key_flag
	Dim $Key_line
	Dim $Key_line_split
	Dim $Key_start
	Dim $Key_test
	Dim $Key_val
	Dim $Line
	Dim $Line_num
	Dim $IsSubfolder
	Dim $Parent_name
	Dim $Rows_max
	Dim $Section_end
	Dim $Section_start
	Dim $Tabs
	Dim $TopSub
	Dim $Dir
	Dim $Drive
	Dim $Ext
	Dim $Fname
	Dim $Style = "M/d/yyyy"
	Dim $TodayDate = @MON & "/" & @MDAY & "/" & @YEAR
	Dim $wProcOld
	Dim $Y
	Dim $Root_name
	Dim $Val
	Dim $Val_test
	Dim $Val_split
	Dim $Show
	Dim $Headers_file
	Dim $Section_temp
	Dim $Field_count
	Dim $SortDir
	
	Dim $INI_File
	Dim $Line1
	Dim $Line2
	Dim $Key1
	Dim $Key2
	Dim $Val1
	Dim $Val2
	
#Endregion

#Region: _INISections_Fix($INI_File, $Source="")
	Func _INISections_Fix($INI_File, $Source="")
		#cs 
			This fixes all sections to ensure they all have a CRLF between sections.
			
			9/23/2012
			Discovered that a tab above a section was not seen as empty, so it was adding a CR. 
			
			I then had to correct another problem: I was using $ToFix_array like it was 0-based, but it was
			really 1-based. So it was looking at the count value and thinking that was the index to use.
		#ce
		
		;ConsoleWrite(@CR & "_INISections_Fix(): " & @CR & _
		;"    Called by: " & $Source & @CR & _
		;"    INI File: " & $INI_File & @CR)
		
		Dim $File_array[1]
		Local $ToFix_array[1]
		
		;MsgBox(0, "_INIFile_FixSections", "Ready to process " & $INI_File)
		_FileReadToArray($INI_File, $File_array)
		;_ArrayDisplay($File_array)
		
		;MsgBox(0, "_INISections_Fix", "1: Lines to process: " & $File_array[0])
		
		;Find sections that need a CRLF above it.
		For $i = 2 To $File_array[0]
			If StringInStr($File_array[$i], "[") Then
				;Strip tabs and CRLF from line above.
				$Line = StringReplace($File_array[$i-1], @TAB, @CRLF, "")
				;MsgBox(0, "_INISections_Fix", "Section detected at line " & $i & @CR & _
				;"Line " & $i - 1 & ": " & $Line)
				;If line above NOT empty, it needs a CR above it, so add its index to array.
				If $Line <> "" Then
					;MsgBox(0, "Line " & $i-1, "Section needs CR above it.")
					;ConsoleWrite(@CR & "_INISections_Fix(): Line " & $i & " needs CR above it." & @CR)
					;_ArrayDisplay($File_array, "Line " & $i)
					_BumpArray($ToFix_array)
					$ToFix_array[$ToFix_array[0]] = $i
				EndIf
			EndIf
		Next
		
		;If nothing needs fixing, return.
		If $ToFix_array[0] = 0 Then Return
		
		;Loop through array and insert CR above each index.
		MsgBox(0, "_INISections_Fix", "There are " & $ToFix_array[0] & " indexes to process.")
		_ArrayDisplay($ToFix_array, "_INISections_Fix(): ToFix_array")
		For $i = 1 To $ToFix_array[0]
			;If first index, use line num as is.
			If $i = 1 Then
				;_ArrayDisplay($ToFix_array, "_INISections_Fix(): ToFix_array")
				_FileWriteToLine($INI_File, $ToFix_array[$i], "", 0)
				ConsoleWrite("_INISections_Fix (A): ToFix_array. Added CR at index " & $ToFix_array[$i] & @CR)
			;Otherwise, each time a CRLF is added, the line num in the array should be bumped by 1.
			Else
				_FileWriteToLine($INI_File, $ToFix_array[$i] + 1, "", 0)
				ConsoleWrite("_INISections_Fix (B): ToFix_array. Added CR at index " & $ToFix_array[$i] + 1 & @CR)
			EndIf
		Next
			
		Return
	EndFunc
#EndRegion
#Region: _INIFile_GetSections($INI_File, $Source="")
	Func _INIFile_GetSections($INI_File, $Source="")
		#cs 
			Creates an array containing names of all sections and its depth (in case depth is used
			for nested sections, such as used in Project Manager).
			
			But something is odd: It reads my Pill Tracker.ini file and adds a row under the Active
			section as though it were a section name. Not sure why yet.
		#ce
		
		;MsgBox(0, "_INIFile_GetSections", "$INI_File: " & $INI_File & @CR & _
		;"Source: " & $Source)
		
		Local $File_array[1]
		Local $Section_name = ""
		Local $Depth = ""
		Local $i = ""
		Local $Line = ""
		Dim $Sections_array[1][2]
		
		;MsgBox(0, "_INIFile_GetSections", "Ready to process " & $INI_File)
		If FileExists($INI_File) Then
			_FileReadToArray($INI_File, $File_array)
		Else
			;MsgBox(0, "_INIFile_GetSections", "Whoops! Problem with " & $INI_File)
			ConsoleWrite("_INIFile_GetSections (A): Whoops! " & $INI_File & " does not exist." & @CR & _
			"  Called by: " & $Source & @CR)
			Return
		EndIf
		
		If $File_array[0] = "" Then
			;MsgBox(0, "_INIFile_GetSections", "Whoops! Problem with " & $INI_File)
			ConsoleWrite("_INIFile_GetSections (B): Whoops! " & $INI_File & " is empty." & @CR & _
			"  Called by: " & $Source & @CR)
			Return
		EndIf
		;_ArrayDisplay($File_array)
		
		;Find section names.
		For $i = 1 To $File_array[0]
			;If string contains "=" sign, it is likely a line that contains brackets in a note.
			;If StringInStr($File_array[$i], "=") Then ContinueLoop
			
			;If string contains "[" AND "]", it is a section name.
			$Line = $File_array[$i]
			If $Line = "" Then ContinueLoop
			
			;Get sections.
			If StringInStr($Line, "[") And StringInStr($Line, "]") Then
				;ConsoleWrite("_INIFile_GetSections: Line: " & $Line & @CR)
				$Section_name = StringReplace($Line, "[", "")
				$Section_name = StringReplace($Section_name, "]", "")
				
				;Get depth within section (number of tabs). Delete tab for section name.
				$Section_name = StringReplace($Section_name, @TAB, "")
				$Depth = @extended
				
				;Add section name and depth to array.
				_BumpArray($Sections_array, 2)
				$Sections_array[$Sections_array[0][0]][0] = $Section_name; section name
				$Sections_array[$Sections_array[0][0]][1] = $Depth; depth
			Else
				ContinueLoop
			EndIf
		Next
		
		Return $Sections_array
	EndFunc
#EndRegion
#Region: _INISection_GetInfo($INI_File, $vSection, $Source="")
	Func _INISection_GetInfo($INI_File, $vSection, $Source="")
		#cs
			9/24/2012
			I had added an Include statement for _MyFunctions.au3, but this prevented this script
			from being run at all.
		#ce
		
		;Consider renaming vars to match those used by _INISection_GetInfo().
		
		;MsgBox(0, "_INISection_GetInfo", "Started")
		
		;Initialize
		Local $i
		Local $j
		Local $Val
		Local $Val_split
		Local $INI_File_temp
		
		Global $INIFile_array[1]
		Global $Section_array[1]
		
		$Section_start = ""
		$Section_end = ""
		$Depth = 0
		
		$Test = 0
		If $Test = 1 Then
			ConsoleWrite(@CR & "_INISection_GetInfo(): " & @CR & _
			"    Called by: " & $Source & @CR & _
			"    INI File: " & $INI_File & @CR & _
			"    Section: " & $vSection & @CR)
		EndIf
		
		;Read file to array.
		 _FileReadToArray($INI_File, $INIFile_array)
		
		;Find Section_start.
		;ConsoleWrite(@CR & $i & ": _INISection_GetInfo: Looking for [" & $Section & "]" & @CR)
		 For $i = 1 To $INIFile_array[0]
			;ConsoleWrite($i & ": _INISection_GetInfo: Line = " & StringReplace($INIFile_array[$i], @TAB, "") & @CR)
			$Line_NoTabs = StringReplace($INIFile_array[$i], @TAB, "")
			If StringInStr($Line_NoTabs, "[" & $vSection & "]") Then
				$Section_start = $i
				;Save depth.
				StringReplace($INIFile_array[$i], @TAB, @TAB)
				$Depth = @extended
				ExitLoop
			EndIf
		Next
		
		If $Section_start = "" Then Return
		;ConsoleWrite("  Section_start: " & $Section_start & @CR)
		
		;Find Section_end.
		 For $i = $Section_start + 1 To $INIFile_array[0]
			;Split line into key=val.
			$Line = $INIFile_array[$i]
			$Pos = StringInStr($Line, "=");find first = sign. This separates key from val.
			$Val = StringMid($Line, $Pos + 1);get val part.
			
			;Replace "=" with "~eq~" if exists in value.
			;If StringInStr($Val, "=") Then
				;ConsoleWrite($Val & " contains an '=' sign?" & @CR)
				;$Val = StringReplace($Val, "=", "~eq~")
				;Put line back together: key & val.
				;$Line = StringMid($Line, 1, $Pos) & "=" & $Val
				;Update INI with replacements.
				;_FileWriteToLine($INI_File, $i, $Line, 1)
			;EndIf
			
			;If line is empty, it is end of section (I have to use an empty line to indicate end of a section).
			If $INIFile_array[$i] = "" Then
				$Section_end = $i - 1
				ExitLoop
			;Otherwise, if at last index, it is end of file, so is also end of section.
			ElseIf $i = $INIFile_array[0] Then
				$Section_end = $i
				ExitLoop
			EndIf
		Next
		
		$Test = 0
		If $Test = 1 Then
			ConsoleWrite($INI_File & " section " & $vSection & ":  Section_end: " & $Section_end & @CR)
		EndIf
		 
		 ;======================
		 ;FILL ARRAY
		 ;======================
		 ;If section has only 1 line, no need to loop section.
		 If $Section_end = $Section_start + 1 Then
			_BumpArray($Section_array)
			$Section_array[$Section_array[0]] = $INIFile_array[$Section_end] 
		;Otherwise, section has more than 1 line, so loop section.
		Else
			For $i = $Section_start + 1 To $Section_end
				_BumpArray($Section_array)
				
				$String = $INIFile_array[$i]
				;_FixText($String, "Write")
				$Section_array[$Section_array[0]] = $String 
			Next
		EndIf
		
		;MsgBox(0, "_INISection_GetInfo", $Source & " done.")
		
		;_ArrayDisplay($Section_array, $Section)
		
		Return $Section_start & $Section_end & $Depth & $Section_array & $INIFile_array
	EndFunc
#Endregion
#Region: _INISection_InsertNew($INI_File, $Section, $Section_new, $AboveBelow)
	Func _INISection_InsertNew($INI_File, $Section, $Section_new, $AboveBelow=0)
		#cs
			Description: Inserts $Section_new above or below $Section.
			
			Receives: $INI_File, $Section, $Section_new, $AboveBelow
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
				o $Section_new: Name to use for new section header (w/o brackets).
				o $AboveBelow: 
					0 = insert below specified section.
					1 = insert above specified section
			
			Returns: Nothing
			
			$AboveBelow [0 = default]
				0 = Insert BELOW $Section
				1 = Insert ABOVE $Section
			
			==================
			METHOD
			==================
			o A CRLF is used to separate sections [built-in INI commands do not add CRLF below section].
			o Tabs are used to maintain any sub-level depth.
			
			10/15/2012
			Renamed: Was _INISection_InsertNew().
			
			2/21/2013
			Had to use _FileReadToArray() to avoid the weird problem of this displaying _FileCountLines().
			even though I was not explicitly displaying that.
			
		#ce
	
		;Initialize.
		Local $Tabs
		$Line_num = -1
		;$Rows_max = _FileCountLines($INI_File)

		;Find start of section.
		;$INIFile_array = FileOpen($INI_File, 0)
		 _FileReadToArray($INI_File, $INIFile_array)
			For $i = 1 to $INIFile_array[0]
				$Line = FileReadLine($INIFile_array, $i)
				If StringInStr($Line, "[" & $Section & "]") Then
					$Section_start = $i
					StringReplace($Line, @TAB, @TAB)
					$Depth = @extended
					ExitLoop
				EndIf
			Next
		
			;Set tabs based on depth.
			$Tabs = ""
			For $j = 1 To $Depth
				$Tabs &= @TAB
			Next

			;Find end of section.
			For $i = $Section_start + 1 to $Rows_max
				$Line = FileReadLine($INIFile_array, $i)
				If StringInStr($Line, "[") Then
					$Section_end = $i - 2
					ExitLoop
				Else
					;It must be at end of file.
					$Section_end = $Rows_max
				EndIf
			Next
		;FileClose($INIFile_array)
		;MsgBox(0, "_INISection_Insert", "3: OK to here")

		Switch $AboveBelow
			;Add below specified section.
			Case 0
				;MsgBox(0, "_INISection_Insert", "Inserting 1 line below end of " & $Section & @CR & _
				;"Section_end: " & $Section_end)
				_FileWriteToLine ($INI_File, $Section_end + 1, @CRLF & $Tabs & "[" & $Section_new & "]")
			;Add above specified section.
			Case 1
				;MsgBox(0, "_INISection_Insert", "Inserting 1 line above start of " & $Section & @CR & _
				;"Section_start: " & $Section_start)
				_FileWriteToLine ($INI_File, $Section_start - 1, @CRLF & $Tabs & "[" & $Section_new & "]")
		EndSwitch
		;MsgBox(0, "_INISection_Insert", "Ended")
		
		Return
	EndFunc
#EndRegion
#Region: _INISection_Delete($INI_File, $Section, $Source="")
	Func _INISection_Delete($INI_File, $Section, $Source="")
		#cs
			Description: Deletes entire section (from header to last key).
			
			Receives: $INI_File, $Section
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
			
			Returns: Nothing.
			
		#ce
		
		;Initialize.
		$Rows_max = _FileCountLines($INI_File)

		;Find start of target section.
		$INIFile_array = FileOpen($INI_File, 0)
			For $i = 1 to $Rows_max
				$Line = FileReadLine($INIFile_array, $i)
				If StringInStr($Line, "[" & $Section & "]") Then
					$Section_start = $i
					ExitLoop
				EndIf
			Next

			;Find end of target section.
			For $i = $Section_start + 1 to $Rows_max
				$Line = FileReadLine($INIFile_array, $i)
				If StringInStr($Line, "[") Then
					$Section_end = $i - 1
					ExitLoop
				;If "[" not found, must be at end of file.
				ElseIf $i = $Rows_max Then
					$Section_end = $Rows_max
				EndIf
			Next
		FileClose($INIFile_array)

		;Delete each line in section, starting with $Section_start.
		$n = ($Section_end - $Section_start) + 1
		For $i = 1 To $n
			_FileWriteToLine($INI_File, $Section_start, "", 1)
		Next
		
		Return
	EndFunc
#EndRegion
#Region: _INISection_Rename($INI_File, $Section, $Section_new)
	Func _INISection_Rename($INI_File, $Section, $Section_new)
		#cs
			Description: Renames specified section header.
			
			Receives: $INI_File, $Section, $Section_new
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
				o $Section_new: New section name.
				
			Returns: Nothing.
			
		#ce
	
		;Initialize.
		$Rows_max = _FileCountLines($INI_File)

		;Find start of target section.
		$INIFile_array = FileOpen($INI_File, 0)
			For $i = 1 to $Rows_max
				$Line = FileReadLine($INIFile_array, $i)
				If StringInStr($Line, "[" & $Section & "]") Then
					$Section_start = $i
					StringReplace($Line, @TAB, @TAB)
					$Depth = @extended
					ExitLoop
				EndIf
			Next
		FileClose($INIFile_array)
		
		;Set tabs based on depth.
		$Tabs = ""
		For $j = 1 To $Depth
			$Tabs &= @TAB
		Next

		;Write line.
		_FileWriteToLine($INI_File, $Section_start, $Tabs & "[" & $Section_new & "]", 1)
		
		Return
	EndFunc
#EndRegion
#Region: _INISection_UpdateKeys($INI_File, $vSection, $Source="")
	Func _INISection_UpdateKeys($INI_File, $vSection, $Source="")
		#cs: DESCRIPTION
				Updates key numbers in specified section with sequential keys.
				Note: I must first make sure the key is a number.
			
			Receives
				o $INI_File: Path to INI file.
				o $vSection: Section name (w/o brackets).
			
			Returns
				Nothing.
				
			Action
				Updates keys to be sequential from 1 to end.

			Notes
				o Maintains depth using tabs at same level as specified section.
				o Can handle any number of sublevels (see $c_max).
				
				I use $ErrantKeys_array to hold a list of keys that do NOT match what they
				should be to be sequential. If the array is NOT empty, I loop through the
				array to fix the errant keys.
		
			6/4/2012
			Having trouble when a section is empty. It is reporting Section_end incorrectly.
			
			3/19/2013
			Found a problem when trying to run Ganja Tracker: It was saying that the string had
			only 1 field, yet it was OK. I found that I had been using the wrong vars: I was using
			_FixText($Line, "Write") instead of _FixText($Val, "Write"). So it was changing the
			"=" sign in $Line instead of $Val. So it wasn't able to split the line at "=".
			
			Sheesh! I don't know how I've able to get by with all the other scripts. I noticed it when
			running it from the script and noticing the status window.
			
			4/11/2013
			This is weird. I got an error from Pill Tracker. I traced it to a missing $Val_split. But
			how did this work before for other scripts that use this?
			
			I added $Val_split.
			
			8/5/2013
			Had to comment out code that checked if $Val_split[0] = 1 because it wasn't updating sections
			in Project Manager (because they aren't piped values -- so $Val_split[0] is always 1].
			
			10/27/2013
			Too often, I forget when adding data and I use brackets. So I added code to replace them with
			parenthesis.
		#ce
		
		;ConsoleWrite(@CR & "_INISection_UpdateKeys:" & @CR & _
		;"  Called by: " & $Source & @CR & _
		;"  File: " & $INI_File & @CR & _
		;"  Section: " & $vSection & @CR)
		
		;If vSection is empty, return.
		If $vSection = "" Then Return
			
		;ConsoleWrite(@CR & "_INISection_UpdateKeys:" & @CR)
		
		;Get section start and end.
		_INISection_GetInfo($INI_File, $vSection, "_INISection_UpdateKeys")
		If $Section_end = $Section_start Then Return
		
		;ConsoleWrite(@CR & "_INISection_UpdateKeys:"  & @CR & _
		;"  Called by: " & $Source & @CR & _
		;"    File: " & $INI_File & @CR & _
		;"    Section: " & $vSection & @CR & _
		;"      Section_start: " & $Section_start & @CR & _
		;"      Section_end: " & $Section_end & @CR)

		;Initialize.
		Local $i = 0
		Local $k=1
		Local $Key = ""
		Local $Val = ""
		Local $Line = ""
		Local $Line_split = ""
		Dim $ErrantKeys_array[1][3];Line num|Key|Value
			
		;_ArrayDisplay($ErrantKeys_array, "A: ErrantKeys_array")
		
		$Tab_pad = ""
		For $i = 1 To $Depth
			$Tab_pad &= @TAB
		Next
		
		;ConsoleWrite("_INISection_UpdateKeys: " & $vSection & " has at least 1 record." & @CR)
		;_ArrayDisplay($INIFile_array, "INIFile_array")
		For $i = $Section_start + 1 to $Section_end
			$Line = $INIFile_array[$i]
			
			If $Line = "" Then
				ConsoleWrite("_INISection_UpdateKeys (A): Whoops! Record is empty." & @CR & _
				"  File: " & $INI_File & @CR & _
				"  Section: " & $vSection & @CR & _
				"  Line #: " & $i & @CR)
				ExitLoop
			EndIf
			
			$Line = StringReplace($Line, @TAB, "");Remove any tabs (used only Project Manager for now).
				
			$Line_split = StringSplit($Line, "=")
			If @error Then
				ConsoleWrite("_INISection_UpdateKeys (B): Whoops! Line NOT key=value pair." & @CR & _
				"  Called by: " & $Source & @CR & _
				"  Line: " & $Line & @CR)
				_ArrayDisplay($INIFile_array, "INIFile_array")
				MsgBox(0, "_INISection_UpdateKeys (B)", "Whoops! Line NOT key=value pair:" & @CR & _
				"  Line: " & $Line & @CR & _
				"  Key: " & $i & @CR & _
				"  Line: " & $Section_start + $i)
				Return
			EndIf
			
			$Key = $Line_split[1]
			$Val = $Line_split[2]
			
			;ConsoleWrite("  Key: " & $Key & @CR & _
			;"  Val: " & $Val)
			
			;Replace brackets with parenthesis.
			If StringInStr($Val, "[") Then
				;MsgBox(0, "_INISection_UpdateKeys", "Found brackets in line " & $Section_start + $i & @CR & _
				;"Val: " & $Val)
				$Val = StringReplace($Val, "[", "(")
				$Val = StringReplace($Val, "]", ")")
				
				_BumpArray($ErrantKeys_array, 3)
				$ErrantKeys_array[$ErrantKeys_array[0][0]][0] = $i; line number
				$ErrantKeys_array[$ErrantKeys_array[0][0]][1] = $k; correct key
				$ErrantKeys_array[$ErrantKeys_array[0][0]][2] = $Val; line value.
			EndIf
			
			;_ArrayDisplay($ErrantKeys_array, "B: ErrantKeys_array")
			
			;$Val_split = StringSplit($Val, "|")
			
			;MsgBox(0, "_INISection_UpdateKeys (B)", "Key: " & $Key & @CR & _
			;"Val: " & $Val)
			
			#cs
				Had to comment this out because it wasn't updating the sections in Project Manager
				(because they aren't piped values). So $Val_split[0] is always 1.
			#ce
			;If $Val_split[0] = 1 Then
				;ConsoleWrite("_INISection_UpdateKeys (C) problem: " & @CR & _
				;"  Problem: Only 1 field in record, or error." & @CR & _
				;"  File: " & $INI_File & @CR & _
				;"  Section: " & $vSection & @CR & _
				;"  Line #: " & $i & @CR & _
				;"  Line: " & $Line & @CR)
				;ExitLoop
			;EndIf
			
			;If key is text, stop.
			If StringIsAlpha($Key) Then
				;ConsoleWrite("_INISection_UpdateKeys: " & $Key & " must be a number." & @CR)
				MsgBox(0, "_INISection_UpdateKeys", "Whoops! Key in " & $INI_File & " section " & $Section & " is not a number.")
				Return
			EndIf
			
			;If $Key <> $k, write to array.
			If $Key <> $k Then
				;ConsoleWrite("_INISection_UpdateKeys: Adding key " & $Key & " as " & $k & " at line " & $i & " to array." & @CR & @CR)
				_BumpArray($ErrantKeys_array, 3)
				$ErrantKeys_array[$ErrantKeys_array[0][0]][0] = $i; line number
				$ErrantKeys_array[$ErrantKeys_array[0][0]][1] = $k; correct key
				$ErrantKeys_array[$ErrantKeys_array[0][0]][2] = $Val; line value.
			EndIf
			
			;Bump key counter.
			$k += 1
		Next
		
		;If array not empty, keys must be updated.
		If $ErrantKeys_array[0][0] <> "" Then
			;_ArrayDisplay($ErrantKeys_array, "ErrantKeys")
			;Loop through Section_array.
			;ConsoleWrite("  Writing to section " & $vSection & " in file " & $INI_File & @CR)
			For $i = 1 To $ErrantKeys_array[0][0]
				;Get line number from col 0.
				$LineNum = $ErrantKeys_array[$i][0]
				
				;Get correct key from col 1.
				$LineKey = $ErrantKeys_array[$i][1]
				
				;Get val from col 2.
				$Val = $ErrantKeys_array[$i][2]
				
				;Create NewVal.
				$NewVal = $LineKey & "=" & $Val
				
				;Write new line to INI.
				;ConsoleWrite("  Writing " & $NewVal & " to line " & $LineNum & @CR)
				;MsgBox(0, "_INISection_UpdateKeys", "Writing " & $NewVal & " to line " & $LineNum)
				_FileWriteToLine($INI_File, $LineNum, $Tab_pad & $NewVal, 1)
			Next
		EndIf
		
		Return
	EndFunc
#EndRegion
#Region: _INISection_InsertFieldInHeader($INI_File, $Section, $Header_array, $Field_name, $Field_ref, $Field_before="", $Source="")
	Func _INISection_InsertFieldInHeader($INI_File, $Section, ByRef $Header_array, $Field_name, $Field_ref, $Field_before="", $Source="")
		#cs
			Ganja Tracker uses many INI files with sections that use the same header key. So to avoid
			having to include the same Headers section in each file, I add a Header key to the General
			section of each INI that specifies which INI file contains the Headers section, like this:
			
			Headers_file=D:\My Documents\My Programs\Ganja Tracker\Ganja Tracker.ini
			
			Therefore, I need a way to determine the Headers file in case this occurs.
			
			So I first look for the "Headers_file" key in the General section of the specified INI file to determine
			which file contains Headers. If it does NOT contain that key, then the Headers section is located
			in the specified INI file (which I set as $Headers_file). Otherwise, I set $Headers_file to the specified
			value for the Headers_file key.
			
			However, another problem occurs in Ganja Tracker because I use the same Header key (like "Grow")
			with a number appended to it in order to be able to use separate Grow sections. So I also have to find
			the real header key from something like "Grow15") by eliminating the numbers to get just "Grow". But
			I don't want to lose the original section name either. So I use $Section_temp to hold the parsed section
			to use as the header key, then read that header key from the correct INI file's Headers section.
			
			Whew! Complicated!
			
			I then need to create $Header_array from scratch. If the header contains more fields than the
			section, I need insert the extra fields only to the section. But in doing so, the header must match
			the section to determine the correct position to insert it. But how do I send it those fields?
			
			I also have to make sure that the new field has not already been added to the header when I add
			the new field to other sections in the same file.
			
			If $Field_before = "", it means that I must determine the position of the new field from $Field_ref
			and assume that it should always be inserted.
			
			If the header has more fields than the section, I need to pass it a $Header_array that does NOT
			contain the new fields. I must set pass $Header_array that reflects the current state, meaning
			that the first time, $Header_array should not include any new fields (so I have to remove those
			from $Header_array before passing it). But the next field to be added should include the current
			state of the fields, which means it should now include the last field added.
		#ce
		;Initialize
		Dim $Header
		Dim $Header_split
		Local $New_header
		Local $New_val
		Local $Header_flag= 0
		Local $Field_pos
		
		$Test = 0
		If $Test = 1 Then
			MsgBox(0, "_INISection_InsertFieldInHeader", "INI_file: " & $INI_File & @CR & _
			"INI_Section: " & $Section & @CR & _
			"Field_name: " & $Field_name & @CR & _
			"Field_ref: " & $Field_ref & @CR & _
			"Field_before: " & $Field_before)
		EndIf
		
		;=============================
		;INSERT NEW FIELD IN HEADER
		;=============================
		;Get header from INI.
		_GetHeadersFile($INI_File, $Section, "_INISection_InsertField")
		_GetHeader($Headers_file, $Section_temp)
		
		;If $Field_name already exists in header, set flag to prevent updating header again.
		For $i = 1 To $Header_array[0][0]
			If $Header_array[$i][0] = $Field_name Then
				;MsgBox(0, "_INISection_InsertField", $Field_name & " found at index " & $i)
				$Header_flag = 1;1 = field already exists in header.
			EndIf
		Next
		
		;Find $Field_pos.
		For $i = 1 To $Header_array[0][0]
			;Get $Field_pos (for use when inserting into section)
			If $Header_array[$i][0] = $Field_ref Then
				;MsgBox(0, "_INISection_InsertField", $Field_ref & " found at index " & $i)
				If $Field_before = 1 Then
					$Field_pos = $i - 1
				Else
					$Field_pos = $i
				EndIf
				ExitLoop
			EndIf
		Next
		;MsgBox(0, "_INISection_InsertField", "Field_pos: " & $Field_pos)
		
		;If new field NOT in header, find field position in header.
		If $Header_flag = 0 Then
			;Find index position of $Field_ref.
			For $i = 1 To $Header_array[0][0]
				If $Header_array[$i][0] = $Field_ref Then
					If $Field_before = 1 Then
						$Field_pos = $i - 1
						ExitLoop
					Else
						$Field_pos = $i
						ExitLoop
					EndIf
				EndIf
			Next
			
			#cs
				$Field_pos is the index to find when inserting a new field. 
				
				But if $Field_ref = 1 AND $Field_before = 1, then $Field_pos = 0, which is outside $Header_split[0].
				In that case, I must add a new row BEFORE the first row.
				
				I must also insert the few field (row) in $Header_array. But $Header_array is 2D, so can't use
				_ArrayInsert(). So I first I declare $Header_array_temp[1][4]. Then I loop through $Header_array
				and insert the new field (row) at the appropriate place. 
				
				When done, I then set  $Header_array = $Header_array_temp and delete $Header_array_temp.
			#ce
			Global $Header_array_temp[1][4]
			
			;If $Field_pos = 0, insert new field BEFORE next field.
			If $Field_pos = 0 Then
				_BumpArray($Header_array_temp, 4)
				$Header_array_temp[$Header_array_temp[0][0]][0] = $Field_name
			;Otherwise, insert new field AFTER next field.
			Else
				For $i = 1 To $Header_array[0][0]
					;If index matches $Field_pos:
					If $i = $Field_pos Then
						;Add existing field.
						_BumpArray($Header_array_temp, 4)
						$Header_array_temp[$Header_array_temp[0][0]][0] = $Header_array[$i][0]
						
						;Add new field.
						_BumpArray($Header_array_temp, 4)
						$Header_array_temp[$Header_array_temp[0][0]][0] = $Field_name
					;Otherwise, add current field to current position.
					Else
						;Add existing field.
						_BumpArray($Header_array_temp, 4)
						$Header_array_temp[$Header_array_temp[0][0]][0] = $Header_array[$i][0]
					EndIf
				Next
			EndIf
			
			$Header_array = $Header_array_temp
			
			;Create $Header from new $Header_array
			$Header = ""
			For $i = 1 To $Header_array_temp[0][0]
				$Header &= $Header_array_temp[$i][0] & "|"
			Next
			$Header = StringTrimRight($Header, 1)
		EndIf
		
		;_ArrayDisplay($Header_array, "Header_array")
		
		Return $Header_array & $Header
	EndFunc
#EndRegion
#Region: _INISection_InsertFieldInSection($INI_File, $Section, $Header_array, $SelIndexes, $Field_name, $Field_ref, $Field_before="", $Source="")
	Func _INISection_InsertFieldInSection($INI_File, $Section, $Header_array, $SelIndexes, $Field_name, $Field_ref, $Field_before="", $Source="")
		#cs
			Ganja Tracker uses many INI files with sections that use the same header key. So to avoid
			having to include the same Headers section in each file, I add a Header key to the General
			section of each INI that specifies which INI file contains the Headers section, like this:
			
			Headers_file=D:\My Documents\My Programs\Ganja Tracker\Ganja Tracker.ini
			
			Therefore, I need a way to determine the Headers file in case this occurs.
			
			So I first look for the "Headers_file" key in the General section of the specified INI file to determine
			which file contains Headers. If it does NOT contain that key, then the Headers section is located
			in the specified INI file (which I set as $Headers_file). Otherwise, I set $Headers_file to the specified
			value for the Headers_file key.
			
			However, another problem occurs in Ganja Tracker because I use the same Header key (like "Grow")
			with a number appended to it in order to be able to use separate Grow sections. So I also have to find
			the real header key from something like "Grow15") by eliminating the numbers to get just "Grow". But
			I don't want to lose the original section name either. So I use $Section_temp to hold the parsed section
			to use as the header key, then read that header key from the correct INI file's Headers section.
			
			Whew! Complicated!
			
			I then need to create $Header_array from scratch. If the header contains more fields than the
			section, I need insert the extra fields only to the section. But in doing so, the header must match
			the section to determine the correct position to insert it. But how do I send it those fields?
			
			I also have to make sure that the new field has not already been added to the header when I add
			the new field to other sections in the same file.
			
			If $Field_before = "", it means that I must determine the position of the new field from $Field_ref
			and assume that it should always be inserted.
			
			If the header has more fields than the section, I need to pass it a $Header_array that does NOT
			contain the new fields. I must set pass $Header_array that reflects the current state, meaning
			that the first time, $Header_array should not include any new fields (so I have to remove those
			from $Header_array before passing it). But the next field to be added should include the current
			state of the fields, which means it should now include the last field added.
			
			4/9/2012
			I had to split _INISection_InsertField() into two functions into order to handle this better in the
			calling script:
				o _INISection_InsertFieldInHeader()
				o _INISection_InsertFieldInSection()
				
			I will update the comments later.
			
		#ce
		;Initialize
		Dim $Header = ""
		Dim $Header_split = ""
		Local $New_header = ""
		Local $New_val = ""
		Local $Field_pos = ""
		
		$Test = 0
		If $Test = 1 Then
			MsgBox(0, "_INISection_InsertField", "INI_file: " & $INI_File & @CR & _
			"INI_Section: " & $Section & @CR & _
			"Field_name: " & $Field_name & @CR & _
			"Field_ref: " & $Field_ref & @CR & _
			"Sel Indexes: " & $SelIndexes[0] & @CR & _
			"Field_before: " & $Field_before)
		EndIf
		
		;=============================
		;FIND FIELD POS
		;=============================
		;Find $Field_pos.
		For $i = 1 To $Header_array[0][0]
			;Get $Field_pos (for use when inserting into section)
			If $Header_array[$i][0] = $Field_ref Then
				;MsgBox(0, "_INISection_InsertField", $Field_ref & " found at index " & $i)
				If $Field_before = 1 Then
					$Field_pos = $i - 1
				Else
					$Field_pos = $i
				EndIf
				ExitLoop
			EndIf
		Next
		;MsgBox(0, "_INISection_InsertField", "Field_pos: " & $Field_pos)
		
		;=============================
		;INSERT FIELD IN SECTION
		;=============================
		_INISection_GetInfo($INI_File, $Section, "_INISection_InsertField")
		;_ArrayDisplay($Header_array, "Header_array")
		
		;Loop through section.
		For $i = 1 To $Section_array[0]
			#cs
				DO NOT use _GetFields(): It returns $Header and $Header_array, which would overwrite
				$Header and $Header_array that already includes the new fields. I MUST populate
				$Header_array the long way.
			#ce
			
			$String_split = StringSplit($Section_array[$i], "=")
			$Key = $String_split[1]
			$Val = $String_split[2]
			$Val_split = StringSplit($Val, "|")
			
			$New_val = ""
			;If $Field_pos = 0, add new blank field BEFORE current field.
			If $Field_pos = 0 Then
				$New_val &= "|"
			;Otherwise, add new blank field AFTER current field.
			Else
				For $j = 1 To $Val_split[0]
					If $j = $Field_pos Then
						$New_val &= $Val_split[$j] & "|"
						$New_val &= "|"
					;Otherwise, insert current field.
					Else
						$New_val &= $Val_split[$j] & "|"
					EndIf
				Next
			EndIf
			$New_val = StringTrimRight($New_val, 1)
		
			;Write to INI.
			;MsgBox(0, "_INISection_InsertField", "Ready to write " & $Key & "=" & $New_val & " to line " & $Section_start + $i)
			_FileWriteToLine($INI_File, $Section_start + $i, $Key & "=" & $New_val, 1)
		Next
		
		Return
	EndFunc
#EndRegion
#Region: _INISection_SwapFields($INI_File, $Section, $Header_key, $Field_pos1, $Field_pos2, $Source="")
	Func _INISection_SwapFields($INI_File, $Section, $Header_key, $Field_pos1, $Field_pos2, $Source="")
		#cs: DESCRIPTION
			Swaps values and field names between two fields: $INI_Field1 and $INI_Field2.
			
			Parameters
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
				o $Header_key: Name of key for piped header.
				o $Field_pos1: Position of field 1.
				o $Field_pos2: Position of field 2.
			
			Returns: Nothing.
			
			Method
			Loop through section and rewrite line using value from $INI_Field_pos_2 to replace value from
			$INI_Field_pos_1, and vice versa.
			
			Use Header to loop through fields, then write $NewVal to include swapped data.
		#ce
	
		;Initialize
		Local $String
		Local $String_split
		Local $Header
		Local $Header_split
		Local $Field_name1
		Local $Field_name2
		Local $Field1
		Local $Field2
		Local $New_header
		Local $New_val
		
		$Test = 0
		If $Test = 1 Then
			MsgBox(0, "_INISection_SwapFields", "INI_file: " & $INI_File & @CR & _
			"INI_Section: " & $Section & @CR & _
			"Header_key: " & $Header_key & @CR & _
			"Field_pos1: " & $Field_pos1 & @CR & _
			"Field_pos2: " & $Field_pos2)
		EndIf
		
		;=============================
		;SWAP FIELD NAMES IN HEADER
		;=============================
		;Get header.
		_GetHeadersFile($INI_File, $Section);returns $Headers_file and $Section_temp.
		$Header = IniRead($Headers_file, "Headers", $Section_temp, "")
		$Header_split = StringSplit($Header, "|")
		
		;Swap field names in header.
		$Field_name1 = $Header_split[$Field_pos1]
		$Field_name2 = $Header_split[$Field_pos2]
		
		$New_header = ""
		For $i = 1 To $Header_split[0]
			If $i = $Field_pos1 Then
				$New_header &= $Field_name2 & "|"
			ElseIf $i = $Field_pos2 Then
				$New_header &= $Field_name1 & "|"
			Else
				$New_header &= $Header_split[$i] & "|"
			EndIf
		Next
		$New_header = StringTrimRight($New_header, 1)
		
		;Write to INI.
		_INIKey_GetInfo($Headers_file, "Headers", $Header_key, "")
		If $Section_end = $Section_start Then Return
		
		;MsgBox(0, "_INISection_SwapFields", "Ready to update header key " & $Header_key & " as " & $New_header & " to line " & $Section_start + 1)
		ConsoleWrite("_INISection_SwapFields: Ready to update header key " & $Header_key & " as " & $New_header & " to line " & $Section_start + 1)
		_FileWriteToLine($INI_File, $Section_start + 1, $Header_key & "=" & $New_header, 1)
		
		;=============================
		;SWAP FIELDS IN SECTION
		;=============================
		_INISection_GetInfo($INI_File, $Section, "_INISection_SwapFields")
		
		;Loop through section.
		$INI_Read = IniReadSection($INI_File, $Section)
		For $i = 1 To $INI_Read[0][0]
			$String = $INI_Read[$i][1]
			$String_split = StringSplit($String, "|")
			
			;Get field data from each field.
			$Field1 = $String_split[$Field_pos1]
			$Field2 = $String_split[$Field_pos2]
			
			$New_val = ""
			For $j = 1 To $String_split[0]
				If $j = $Field_pos1 Then
					$New_val &= $Field2 & "|"
				ElseIf $j = $Field_pos2 Then
					$New_val &= $Field1 & "|"
				Else
					$New_val &= $String_split[$j] & "|"
				EndIf
			Next
			$New_val = StringTrimRight($New_val, 1)
			;MsgBox(0, "SwapFields", "Key " & $i & ": Old_val was: " & $String & @CR & _
			;"New_val is: " & $New_val & @CR & _
			;"Line num = " & $Section_start + $i)
			ConsoleWrite("_INISection_SwapFields: Key " & $i & ": Old_val: " & $String & @CR & _
			"  New_val: " & $New_val & @CR & _
			"  Line num: " & $Section_start + $i & @CR)
		
			;Write to INI.
			_FileWriteToLine($INI_File, $Section_start + $i, $INI_Read[$i][0] & "=" & $New_val, 1)
		Next
		
		Return
	EndFunc
#Endregion
#Region: _INISection_SwapRecords($INI_File, $Section, $Index1, $Index2, $Source="")
	Func _INISection_SwapRecords($INI_File, $Section, $Index1, $Index2, $Source="")
		#cs: DESCRIPTION
			Swaps records (rows) in specified INI and section.
			
			Parameters
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
				o $Index1: Row index 1.
				o $Index2: Row index 2.
			
			Returns: Nothing.
			
			Method
			Loop through section and rewrite line using value from $INI_Index2 to replace value from
			$INI_Index1, and vice versa.
			
			Use Header to loop through fields, then write $NewVal to include swapped data.
		#ce
		$Test = 0
		If $Test = 1 Then
			MsgBox(0, "_INISection_SwapRecords", "INI_file: " & $INI_File & @CR & _
			"INI_Section: " & $Section & @CR & _
			"Index1: " & $Index1 & @CR & _
			"Index2: " & $Index2)
		EndIf
		
		;=============================
		;SWAP RECORDS IN SECTION
		;=============================
		_INISection_GetInfo($INI_File, $Section, "_INISection_SwaprRecords")
		If $Section_start = $Section_end Then Return
		
		;Read section to array.
		;$INI_Read = IniReadSection($INI_File, $Section)
		
		;Get key=value for Index1.
		For $i = 1 To $Section_array[0]
			If $i = $Index1 Then
				$Line1 = $Section_start + $i
				$String = $Section_array[$i]
				$String_split = StringSplit($String, "=")
				$Key1= $String_split[1]
				$Val1 = $String_split[2]
				ExitLoop
			EndIf
		Next
		
		;Get key=value for Index2.
		For $i = 1 To $Section_array[0]
			If $i = $Index2 Then
				$Line2 = $Section_start + $i
				$String = $Section_array[$i]
				$String_split = StringSplit($String, "=")
				$Key2= $String_split[1]
				$Val2 = $String_split[2]
				ExitLoop
			EndIf
		Next
		
		;Write Key1=Val2 to Index1.
		;MsgBox(0, "SwapRecords", "Ready to write " & $Key2 & "=" & $Val1 & " from line " & $Line1 & " to line " &  $Line2)
		_FileWriteToLine($INI_File, $Line2, $Key2 & "=" & $Val1, 1)
		
		;Write Key2=Val1 to Index2.
		;MsgBox(0, "SwapRecords", "Ready to write " & $Key1 & "=" & $Val2 & " from line " & $Line2 & " to line " &  $Line1)
		_FileWriteToLine($INI_File, $Line1, $Key1 & "=" & $Val2, 1)
		
		Return
	EndFunc
#Endregion
#Region: _INISection_SwapSections(TBD: $INI_File, $Section, $Dir, $Source="")
	#cs
		Swap sections. Dir indicates direction: 0 = swap with section above, 1 = swap with section below.
	#ce
#Endregion
#Region: _INISection_DeleteField($INI_File, $Section, $INI_Header, $Field_name, $Source="")
	Func _INISection_DeleteField($INI_File, $Section, $INI_Header, $Field_name, $Source="")
		#cs: DESCRIPTION
			Deletes field values and field name in specified file and section.
			
			Parameters
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
				o $INI_Header: Name of key for piped header.
				o $Field_name: Name of field to delete.
			
			Returns: Nothing.
			
			Method
				Loop through section, construct New_val without specified field, then rewrite lines.
				Loop Header and skip specified field position to rewrite header.
		#ce
		
		;Initialize
		Local $String
		Local $String_split
		Local $Header
		Local $Header_split
		Local $New_header
		Local $Field_pos
		
		$Test = 1
		If $Test = 1 Then
			MsgBox(0, "_INISection_DeleteField", "INI_file: " & $INI_File & @CR & _
			"  INI_Section: " & $Section & @CR & _
			"  INI_Header: " & $INI_Header & @CR & _
			"  Field name: " & $Field_name)
		EndIf
		
		;=============================
		;SWAP FIELD NAMES IN HEADER
		;=============================
		;Get header.
		$Header = IniRead($INI_File, "Headers", $INI_Header, "")
		$Header_split = StringSplit($Header, "|")
		
		For $i = 1 To $Header_split[0]
			If $Header_split[$i] = $Field_name Then
				$Field_pos = $i
				ExitLoop
			EndIf
		Next
		
		;===============================
		;DELETE FIELD NAME FROM HEADER
		;===============================
		$New_header = ""
		For $i = 1 To $Header_split[0]
			If $Header_split[$i] <> $Field_name Then
				$New_header &= $Header_split[$i] & "|"
			EndIf
		Next
		$New_header = StringTrimRight($New_header, 1)
		
		;MsgBox(0, "_INISection_DeleteField", "Ready to delete " & $Field_name & " at index " & $Field_pos & " from header." & @CR & _
		;"  Original header: " & $Header & @CR & _
		;"  New header: " & $New_header)
		
		;Write to INI.
		;MsgBox(0, "_INISection_DeleteField", "Ready to write " & $New_header & " to " & $Section & " key.")
		IniWrite($INI_File, "Headers", $Section, $New_header)
		
		;=============================
		;DELETE FIELD FROM EACH LINE
		;=============================
		_INISection_GetInfo($INI_File, $Section, "_INISection_DeleteField")
		If $Section_start = "" Then Return
		
		;Loop through section.
		For $i = 1 To $Section_array[0]
			_GetFields($Section_array[$i], "_INISection_DeleteField")
			
			$New_val = ""
			For $j = 1 To $Val_split[0]
				If $j <> $Field_pos Then
					$New_val &= $Val_split[$j] & "|"
				EndIf
			Next
			$New_val = StringTrimRight($New_val, 1)
			
			;MsgBox(0, "_INISection_DeleteField", "Line " & $Section_start + $i & @CR & _
			;"  Key " & $Key & ": Old_val was: " & $Val & @CR & _
			;"  New_val is: " & $New_val)
		
			;Write to INI.
			_FileWriteToLine($INI_File, $Section_start + $i, $Key & "=" & $New_val, 1)
		Next
		
		MsgBox(0, "_INISection_DeleteField", "Done.")
		
		Return
	EndFunc
#Endregion
#Region: _INISection_MoveField($INI_File, $Section, $INI_Header, $INI_Field_pos_1, $INI_Field_pos_2, $Source="")
	;TBD
#EndRegion
#Region: _INISection_Sort($INI_File, $Section, $Sort_col, $Sort_order="", $Source="")
	Func _INISection_Sort($INI_File, $Section, $Sort_col, $Sort_order="", $Source="")
		#cs
			Sorts records (rows) in specified INI and section by designated field and sort order.
			
			Parameters
				o $INI_File: Path to INI file.
				o $Section: Section name (w/o brackets).
				o $Sort_col: The field index that should be sorted.
					Note: It is 1-based, so I need to make it 0-based in _ArraySort().
			
			Returns: Nothing. It updates $INI_File directly. So I should make a backup copy of it first.
			
			The default sort order is ascending (if $Sort_order = ""). If $Sort_order = 1, it sorts in descending
			order.
			
			I could also specify the start and end records, so could sort only a portion of the section.
			I don't know where I need that yet, but it would be easy to add this ability.
			
			Method
				Get section into array.
				Convert to 2D array with number of columns equal to number of fields + 1 (for Key).
				Split entries into fields.
				Write entries to 2D array.
				Sort array by $Sort_col and $Sort_order, then rewrite INI section from array.
				
				12/16/2012
				Finally got it to sort and write to the INI.
				
				Good job, Dick!
		#ce
		;Initialize
		
		If $Sort_order = 1 Then
			$SortDir = "Descending"
		Else
			$Sort_order = 0
			$SortDir = "Ascending"
		EndIf
		
		$Test = 0
		If $Test = 1 Then
			MsgBox(0, "_INISection_Sort", "INI_file: " & $INI_File & @CR & _
			"INI_Section: " & $Section & @CR & _
			"Sort column: " & $Sort_col & @CR & _
			"SortDir: " & $SortDir)
		EndIf
		
		;Make backup copy of INI file.
		$Path = _PathSplit($INI_File, $Drive, $Dir, $Fname, $Ext)
		FileCopy($INI_File, $Drive & $Dir & $Fname & "-copy" & $Ext) 
		
		_INISection_GetInfo($INI_File, $Section, "_INISection_Sort")
		If $Section_start = $Section_end Then Return
		
		;Get number of fields.
		$String_split = StringSplit($Section_array[1], "|")
		$Field_count = $String_split[0]
		
		;Save to 2D array. Add 1 column for Key.
		Dim $2D_array[$Section_end - $Section_start][$Field_count + 1]
		
		;Fill 2D array.
		For $i = 1 To $Section_array[0]
			;Split string into key=value pair.
			$String = $Section_array[$i]
			$String_split = StringSplit($String, "=")
			$Key = $String_split[1]
			$Val = $String_split[2]
			$Val_split = StringSplit($Val, "|")
			
			;Write key to col 0.
			$2D_array[$i-1][0] = $Key
			
			;Write remaining cols with field values.
			For $j = 1 To $Field_count
				$2D_array[$i-1][$j] = $Val_split[$j]
			Next
		Next
		
		;Sort array by specified field index and sort order, from record 1 to end.
		;_ArrayDisplay($2D_array, "Before sort")
		;MsgBox(0, "_INISection_Sort", "Ready to sort column " & $Sort_col)
		_ArraySort($2D_array, $Sort_order, 0, 0, $Sort_col)
		;_ArrayDisplay($2D_array, "After sort")
		
		;Rewrite section from array.
		;NOTE: Remember that this array is 0-based (has no row counter). So add 1 for 1-based INI.
		
		For $i = 0 To UBound($2D_array) - 1
			;Write fields as value.
			$String = ""
			For $j = 1 To $Field_count
				$String &= $2D_array[$i][$j] & "|"
			Next
			$String = $2D_array[$i][0] & "=" & StringTrimRight($String, 1)
			
			;MsgBox(0, "_INISection_Sort", "Ready to write " & $String & " to line " & $Section_start + $i)
			;ConsoleWrite("_INISection_Sort: Ready to write " & $String & " to line " & $Section_start + $i + 1 & @CR)
			_FileWriteToLine($INI_File, $Section_start + $i + 1, $String, 1)
		Next
		
		Return $2D_array
	EndFunc
#Endregion
#Region: _INIKey_GetInfo($INI_File, $Section, $vKey="", $Item="", $Source="")
	Func _INIKey_GetInfo($INI_File, $Section, $vKey="", $Item="", $Source="")
		#cs
			$INI_File: The "database" file that contains Fields and Tags sections.
			$Section: The section in get.
			$vKey: The key to find (if passed).
			$Item: The text in a field to find (if passed).
			$Source: The calling function.
			
			This gets info about the specified key OR text from any field. 
			
			NOTE: This requires calling _INISection_GetInfo() in calling script before calling this function.
			
			Logic:
				If $Key NOT empty AND $Item NOT empty: Look for key, then match item in pos 2 to $Item.
				If $Key NOT empty AND $Item EMPTY: Look for key.
				If $Key EMPTY AND $Item NOT empty: Look for $Item in field position 2.
				If $Key EMPTY AND $Item EMPTY: <This should not happen>.
			
			Returns: $Key, $Key_start (line number), $Section_array, $Val (piped fields from INI).
			
			NOTE: After MUCH trial and error, I discovered that (for some reason) I MUST use a different
			varname for $Key. So I changed it to $vKey. When found, I set $Key = $vKey and return $Key.
			
			I also deleted the part that set $RN because that was specifically for Info Manager.
			
			I also deleted the call to _INISection_GetInfo(). I now call this explicitly in my scripts to get
			the section info before I call this (_INIKey_GetInfo). That lets me update the section info only
			when I need to. If I am still working in the same section, I now only need to call it once, then I
			can call _INIKey_GetInfo() any number of times to get specific key info. This should speed things
			up and eliminate other conflicts.

			Working good so far!
			
		#ce
		
		If $Section_start = "" Then
			MsgBox(0, "_INIKey_GetInfo", "Whoops! Section " & $Section & " is empty." & @CR & _
			"    Called by: " & $Source & @CR & _
			"    INI File: " & $INI_File & @CR & _
			"    Section: " & $Section & @CR & _
			"    Key: " & $vKey & @CR & _
			"    Item: " & $Item)
			Return
		EndIf
		;ConsoleWrite("_INIKey_GetInfo(1): OK to here." & @CR)
		
		Dim $Key_start
		Dim $Val
		Local $i
		Local $j
		
		;_ArrayDisplay($Section_array)
		
		;If $Key NOT empty AND $Item NOT empty, find key, then find item:
		If $vKey <> "" And $Item <> "" Then
			 ;Look for key, then match item in pos 2 to $Item.
			For $i = 1 To $Section_array[0]
				$String_split = StringSplit($Section_array[$i], "=")
				;If Key found:
				If $String_split[1] = $vKey Then
					$Val = $String_split[2]
					$Val_split = StringSplit($Val, "|")
					;If item found, look for item in fields.
					For $j = 1 To $Val_split[0]
						If $Val_split[$j] = $Item Then
							$Key_start = $i + $Section_start
							$Key = $vKey
							ExitLoop 2
						EndIf
					Next
				EndIf
			Next
		EndIf
		
		;If $Key NOT empty BUT $Item is EMPTY, just look for key:
		If $vKey <> "" And $Item = "" Then
			 ;Look for key, then find item in fields.
			For $i = 1 To $Section_array[0]
				$String_split = StringSplit($Section_array[$i], "=")
				;If key found, return.
				If $String_split[1] = $vKey Then
					$Key_start = $i + $Section_start
					$Key = $vKey
					$Val = $String_split[2]
					ExitLoop
				EndIf
			Next
		EndIf
		
		;If $Key EMPTY AND $Item NOT empty, just look for item, then return key.
		If $vKey = "" And $Item <> "" Then
			 ;Look for $Item in field position 2.
			For $i = 1 To $Section_array[0]
				;Split string with = sign, then split fields with pipe.
				$String_split = StringSplit($Section_array[$i], "=")
				;Search fields for item.
				$Val = $String_split[2]
				$Val_split = StringSplit($Val, "|")
				For $j = 1 To $Val_split[0]
					;If item found:
					If $Val_split[$j] = $Item Then
						$Key = $String_split[1]
						$Key_start = $i + $Section_start
						ExitLoop 2
					EndIf
				Next
			Next
		EndIf
		
		;ConsoleWrite("_INIKey_GetInfo: Source = " & $Source & ". " & $Item & " found at key " & $Key & " line " & $Key_start & @CR)
		
		Return $Key & $Key_start & $Val

	EndFunc
#Endregion
#Region: _INIKey_Delete($INI_File, $Section, $vKey="", $Item="", $Source="")
	;TBD
#Endregion

#Region: _GetVars_LVSel($DataINI, $DataSection, $SelIndex, $SelText, $HeaderINI, $HeaderKey, $CalledBy="")
	Func _GetVars_LVSel($DataINI, $DataSection, $SelIndex, $SelText, $HeaderINI, $HeaderKey, $CalledBy="")
		#cs
			Creates dynamic vars with values from selected listview item.
			
			Parameters:
				o $DataINI: INI file that contains field data.
				o $DataSection: Section in $DataINI that contains data.
				o $SelIndex: Listview index for selected item.
				o $SelText: Listview text (typically col 0) of selected item.
				o $HeaderINI: INI file that contains header for section in $DataINI.
				o $HeaderKey: Header key that matches section in $DataINI.
				o $CalledBy: Text that identifies source of call.
				
			Returns: $Val & $Val_split & $Section_start & $Section_end &  $Key_start

		#ce
		
		Local $j
		
		;Get header.
		Global $Header_array[1][4]
		_GetHeader($HeaderINI, $HeaderKey, $CalledBy)
		
		;Get item from INI.
		$Test = 0
		If $Test = 1 Then
			MsgBox(0, "_GetVars_LVSel", "Ready to get key info for " & $SelText & @CR & _
			"  INI file: " & $DataINI & @CR & _
			"  INI section: " & $DataSection & @CR & _
			"  Header file: " & $HeaderINI & @CR & _
			"  Header key: " & $HeaderKey & @CR & _
			"  Source: " & $CalledBy)
		EndIf
		
		#cs: NOTE
			_INISection_GetInfo() OR _INISection_UpdateKeys() MUST be called from source before
			_INIKey_GetInfo() is called in order to get $Section_array. I could do it here, but I usually
			don't need to call it every time I read a section. So I handle that in the source script.
		#ce
		
		If $Section_array[0] = "" Then
			MsgBox(0, "", "Whoops! Must call _INISection_GetInfo() or _INISection_UpdateKeys() first.")
			Return
		EndIf
		
		_INIKey_GetInfo($DataINI, $DataSection, $SelIndex + 1, $SelText, $CalledBy)
		If $Key_start = "" Then Return
		
		;Get fields.
		_GetFields($Val, $CalledBy)
		;_ShowFields($Header_array)
		
		;Return if elements in INI do not match elements in Header.
		If $Val_split = "" Then Return 
		If $Val_split[0] = 1 Then Return 
		If $Header_array = "" Then Return
		If $Header_array[0][0] = "" Then Return
		
		;Create dynamic vars.
		For $j = 1 To $Header_array[0][0]
			$Assign_val = Assign( $Header_array[$j][0], $Val_split[$j])
			ConsoleWrite("_GetVars_LVSel: Assigned " & $Header_array[$j][0] & @CR)
			If Eval($Assign_val) = 0 Then
				ConsoleWrite("_GetVars_LVSel: Problem with " & $Header_array[$j][0] & ". Called by " & $CalledBy & @CR)
				Return
			EndIf
		Next
		
		Return $Val & $Val_split & $Section_start & $Section_end &  $Key_start & $Header_array
	EndFunc
#Endregion
#Region: _GetVars_INI($DataINI, $DataSection, $HeaderINI, $HeaderKey, $CalledBy="")
	Func _GetVars_INI($DataINI, $DataSection, $HeaderINI, $HeaderKey, $CalledBy="")
		#cs
			Creates dynamic vars with values from selected listview item.
			
			Parameters:
				o $DataINI: INI file that contains field data.
				o $DataSection: Section in $DataINI that contains data.
				o $HeaderINI: INI file that contains header for section in $DataINI.
				o $HeaderKey: Header key that matches section in $DataINI.
				o $CalledBy: Text that identifies source of call.
		#ce
		
		;Get header.
		_GetHeadersFile($DataINI, $DataSection, "_GetVars_INI")
		_GetHeader($Headers_file, $Section_temp, $CalledBy)
		
		;Get section from INI.
		_INISection_GetInfo($DataINI, $DataSection, $CalledBy)
		If $Section_end = $Section_start Then Return
		ConsoleWrite("_GetVars_INI: Section_start = " & $Section_start & ". Key_start = " & $Key_start & @CR)
		
		;Get fields.
		_GetFields($Val, $CalledBy)
		
		;Return if elements in INI do not match elements in Header.
		If $Val_split = "" Then Return 
		If $Val_split[0] = 1 Then Return 
		If $Header_array = "" Then Return
		If $Header_array[0][0] = "" Then Return
		
		;Create dynamic vars.
		For $j = 1 To $Header_array[0][0]
			$Assign_val = Assign($Header_array[$j][0], $Val_split[$j])
			If Eval($Assign_val) = 0 Then
				ConsoleWrite("_GetVars_INI: Problem with " & $CalledBy & @CR)
				Return
			EndIf
		Next
		
		Return $Section_array & $Section_start & $Section_end &  $Key_start
	EndFunc
#Endregion
#Endregion