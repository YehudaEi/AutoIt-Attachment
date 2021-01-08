; Title: Simple Obfuscator.au3
; Author: taurus905
; Purpose: This program accepts an inputed AutoIt script and outputs four files.
;          1) List of alphabetical Variables to be randomized --> OriginalName - Vars.txt
;          2) List of alphabetical Functions to be randomized --> OriginalName - Funcs.txt
;          3) List of Random Names used in place of Vars and Funcs --> OriginalName - RandomNames.txt
;          4) The new obfuscated script (minus comments) --> OriginalName - Simple Obfuscated.au3
; Limitations: Variables should be atleast two characters in length. (Ex: $i could be $ii)
; Options: Variables that are all UPPERCASE will NOT be obfuscated.
;          Function names that begin with an underscore "_" WILL be obfuscated.
;          Add functions that begin with an underscroe "_" to line in _Func_Read_One that you
;             do NOT want to be obfuscated. (Ex:  If $func[$func_ct] = "_FileReadToArray" Or . . .)
;          Change $On_Whitespace = "" to $On_Whitespace = "Y" to add whitespace to outputted script.
#include <GUIConstants.au3>
#include <Array.au3>

Dim $file_orig, $file_vars, $file_funcs, $line_ct, $var_ct, $func_ct, $random_ct, $var_unique_ct, $func_unique_ct, $char, $white_space, $random[9]
_File_Choose() ; Choose file to obfuscate

_File_Ct_Lines() ; Count lines in file
Dim $line[$line_ct + 1], $line_new[$line_ct + 1]
_File_Read_Lines() ; Read lines to array

_Lines_Ct_Vars() ; Count variables in lines
Dim $var[$var_ct + 1]
_Lines_Read_Vars() ; Read variables in lines

_Array_Vars_Sort() ; Sort variables in array

_Array_Ct_Unique_Vars() ; Count unique variables in array and write to file
Dim $var_unique[$var_unique_ct + 1]
_File_Read_Unique_Vars() ; Read unique variables from file to array

_Lines_Ct_Funcs() ; Count functions in lines
Dim $func[$func_ct + 1]
_Lines_Read_Funcs() ; Read functions in lines

_Array_Funcs_Sort() ; Sort functions in array

_Array_Ct_Unique_Funcs() ; Count unique functions in array and write to file
Dim $func_unique[$func_unique_ct + 1]
_File_Read_Unique_Funcs() ; Read unique functions from file to array

_Find_Random_Names_Ct() ; Find random names count
Dim $random_name[$random_ct + 1]
_Array_Create_Random_Names() ; Create random names and write to file

_Var_Replace() ; Replace variables
_Func_Replace() ; Replace functions

Dim $On_Whitespace = "" ; Don't add whitespace
;Dim $On_Whitespace = "Y" ; Add whitespace

_Lines_Find_Splits() ; Find where to insert white space
_File_Write_New() ; Write new file
Exit
; ###################################################################################################
; ===================================================================================================
Func _File_Choose() ; Choose file to obfuscate
	$file_orig = FileOpenDialog("Choose a file to obfuscate:", @ScriptDir, "Scripts (*.au3)", 1 + 2)
	If @error Then Exit
EndFunc ; ==> _File_Choose
; ===================================================================================================
Func _File_Ct_Lines() ; Count lines in file
	FileOpen($file_orig, 0)
	$line_ct = 0
	For $ii = 1 To 100000
		$line_trash = FileReadLine($file_orig, $ii)
		If @error = -1 Then ExitLoop
		$line_ct = $line_ct + 1
	Next
EndFunc ; ==> _File_Ct_Lines
; ===================================================================================================
Func _File_Read_Lines() ; Read lines to array
	For $ii = 1 To $line_ct
		$line[$ii] = FileReadLine($file_orig, $ii)
	Next
	FileClose($file_orig)
EndFunc ; ==> _File_Read_Lines
; ===================================================================================================
Func _Lines_Ct_Vars() ; Count variables in lines
	For $ii = 1 To $line_ct
		$quote_on = "No"
		$line[0] = $line[$ii]
		$line_length = StringLen($line[0])
		For $jj = 1 To $line_length
			$char = StringLeft($line[0], 1)
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "$" And $quote_on = "No" Then $var_ct = $var_ct +1
			$line[0] = StringTrimLeft($line[0], 1)
		Next
	Next
EndFunc ; ==> _Lines_Ct_Vars
; ===================================================================================================
Func _Lines_Read_Vars() ; Read variables in lines
	$var_ct = 0
	For $ii = 1 To $line_ct
		$quote_on = "No"
		$line[0] = $line[$ii]
		$line_length = StringLen($line[0])
		For $jj = 1 To $line_length
			$char = StringLeft($line[0], 1)
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "$" And $quote_on = "No" Then _Var_Read_One() ; Read one variable
			$line[0] = StringTrimLeft($line[0], 1)
		Next
	Next
EndFunc ; ==> _Lines_Read_Vars
; ===================================================================================================
Func _Var_Read_One() ; Read one variable
	$var_ct = $var_ct + 1
	$var[$var_ct] = ""
	For $kk = 1 To 256
		$char = StringLeft($line[0], 1)
		If $char = " " Or $char = "=" or $char = "[" or $char = "]" or $char = "," or $char = ")" or $char = ";" or $char = "+" or $char = "-" or $char = "*" or $char = "/" or $char = Chr(34) Then ExitLoop
		$var[$var_ct] = $var[$var_ct] & $char
		$line[0] = StringTrimLeft($line[0], 1)
	Next
EndFunc ; ==> _Var_Read_One
; ===================================================================================================
Func _Array_Vars_Sort() ; Sort variables in array
	$var[0]=""
	_ArraySort($var)
EndFunc ; ==> _Array_Vars_Sort
; ===================================================================================================
Func _Array_Ct_Unique_Vars() ; Count unique variables in array and write to file
	$file_vars = StringTrimRight($file_orig, 4) & " - Vars.txt" ; Create unique variables file name
	FileOpen($file_vars, 2) ; Open file to write unique variables
	$var_unique_ct = 0
	For $ii = 1 To $var_ct
		If $var[$ii] <> $var[$ii - 1] Then
			If StringIsUpper(StringTrimLeft(StringReplace($var[$ii], "_", ""), 1)) Then ContinueLoop ; Don't write any system variables that are all uppercase, such as, $GUI_EVENT_CLOSE
			$var_unique_ct = $var_unique_ct +1
			FileWrite($file_vars, $var[$ii] & @CRLF )
		EndIf
	Next
	FileClose($file_vars)
EndFunc ; ==> _Array_Ct_Unique_Vars
; ===================================================================================================
Func _File_Read_Unique_Vars() ; Read unique variables from file to array
	FileOpen($file_vars, 0) ; Open file to read unique variables to array
	For $ii = 1 To $var_unique_ct
		$var_unique[$ii] = FileReadLine($file_vars, $ii)
	Next
	FileClose($file_vars)
EndFunc ; ==> _File_Read_Unique_Vars
; ===================================================================================================
Func _Lines_Ct_Funcs() ; Count functions in lines
	For $ii = 1 To $line_ct
		$quote_on = "No"
		$var_on = "No"
		$func_on = "No"
		$line[0] = $line[$ii]
		$line_length = StringLen($line[0])
		For $jj = 1 To $line_length
			$char = StringLeft($line[0], 1)
			If $char = "$" And $quote_on = "No" Then $var_on = "Yes"
			If $char = "@" And $quote_on = "No" Then $var_on = "Yes"
			If $char = " " And $quote_on = "No" Then $var_on = "No"
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "_" And $quote_on = "No" And $func_on = "No" And $var_on = "No" Then
				$func_on = "Yes"
				$func_ct = $func_ct +1
			EndIf
			$line[0] = StringTrimLeft($line[0], 1)
		Next
	Next
EndFunc ; ==> _Lines_Ct_Funcs
; ===================================================================================================
Func _Lines_Read_Funcs() ; Read functions in lines
	$func_ct = 0
	For $ii = 1 To $line_ct
		$quote_on = "No"
		$var_on = "No"
		$func_on = "No"
		$line[0] = $line[$ii]
		$line_length = StringLen($line[0])
		For $jj = 1 To $line_length
			$char = StringLeft($line[0], 1)
			If $char = "$" And $quote_on = "No" Then $var_on = "Yes"
			If $char = "@" And $quote_on = "No" Then $var_on = "Yes"
			If $char = " " And $quote_on = "No" Then $var_on = "No"
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "_" And $quote_on = "No" And $func_on = "No" And $var_on = "No" Then _Func_Read_One() ; Read one function
			$line[0] = StringTrimLeft($line[0], 1)
		Next
	Next
EndFunc ; ==> _Lines_Read_Funcs
; ===================================================================================================
Func _Func_Read_One() ; Read one function
	$func_ct = $func_ct + 1
	$func[$func_ct] = ""
	For $kk = 1 To 256
			$char = StringLeft($line[0], 1)
			If $char = " " Or $char = "(" Then ExitLoop
		$func[$func_ct] = $func[$func_ct] & $char
		$line[0] = StringTrimLeft($line[0], 1)
	Next
	; Add functions to the following line that start with an underscore "_" that you
	;    do NOT want to be obfuscated. (Ex:  If $func[$func_ct] = "_FileReadToArray" Or . . .)
	If $func[$func_ct] = "_ArraySort" Or $func[$func_ct] = "_get_size.au3>" Or $func[$func_ct] = "_FileReadToArray" Or $func[$func_ct] = "_ImageGetSize" Or $func[$func_ct] = "_ArrayDisplay" Or $func[$func_ct] = "_StringProper" Or $func[$func_ct] = "_ArrayDisplay" Or $func[$func_ct] = "_DATEADD" Or $func[$func_ct] = "_NOWCALC" Then ; Don't count built-in functions
		$func_ct = $func_ct - 1
	EndIf
EndFunc ; ==> _Func_Read_One
; ===================================================================================================
Func _Array_Funcs_Sort() ; Sort functions in array
	$func[0]=""
	_ArraySort($func)
EndFunc ; ==> _Array_Funcs_Sort
; ===================================================================================================
Func _Array_Ct_Unique_Funcs() ; Count unique functions in array and write to file
	$file_funcs = StringTrimRight($file_orig, 4) & " - Funcs.txt" ; Create unique functions file name
	FileOpen($file_funcs, 2) ; Open file to write unique functions
	$func_unique_ct = 0
	For $ii = 1 To $func_ct
		If $func[$ii] <> $func[$ii - 1] Then
			$func_unique_ct = $func_unique_ct +1
			FileWrite($file_funcs, $func[$ii] & @CRLF )
		EndIf
	Next
	FileClose($file_funcs)
EndFunc ; ==> _Array_Ct_Unique_Funcs
; ===================================================================================================
Func _File_Read_Unique_Funcs() ; Read unique functions from file to array
	FileOpen($file_funcs, 0) ; Open file to read unique functions
	For $ii = 1 To $func_unique_ct
		$func_unique[$ii] = FileReadLine($file_funcs, $ii)
	Next
	FileClose($file_funcs)
EndFunc ; ==> _Funcs_Read_Unique
; ===================================================================================================
Func _Find_Random_Names_Ct() ; Find random names count
	If $var_unique_ct > $func_unique_ct Then
		$random_ct = $var_unique_ct
	Else
		$random_ct = $func_unique_ct
	EndIf
EndFunc ; ==> Find random names count
; ===================================================================================================
Func _Array_Create_Random_Names() ; Create random names and write to file
	For $ii = 1 To $random_ct
		$random_name[$ii] = ""
		For $jj = 1 To 8
			$random[$jj] = Random( 48, 122, 1)
			If $random[$jj] > 64 And $random[$jj] < 91 Or $random[$jj] > 96 And $random[$jj] < 123 Then
				$random_name[$ii] = $random_name[$ii] & Chr($random[$jj])
			Else
				$jj = $jj - 1
				ContinueLoop
			EndIf
		Next
	Next
	$file_random = StringTrimRight($file_orig, 4) & " - RandomNames.txt" ; Create random names file name
	FileOpen($file_random, 2) ; Open file to write random names
	For $ii = 1 To $random_ct
		FileWrite($file_random, $random_name[$ii] & @CRLF )
	Next
	FileClose($file_random)
EndFunc ; ==> _Array_Create_Random_Names
; ===================================================================================================
Func _Var_Replace() ; Replace variables
	For $ii = 1 To $line_ct
		For $jj = $var_unique_ct To 1 Step -1
			$line[$ii] = StringReplace($line[$ii], $var_unique[$jj], "$" & $random_name[$jj])
		Next
	Next
EndFunc ; ==> _Var_Replace
; ===================================================================================================
Func _Func_Replace() ; Replace functions
	For $ii = 1 To $line_ct
		For $jj = $func_unique_ct To 1 Step -1
			$line[$ii] = StringReplace($line[$ii], $func_unique[$jj], $random_name[$jj])
		Next
	Next
EndFunc ; ==> _Func_Replace
; ===================================================================================================
Func _Lines_Find_Splits() ; Find where to insert white space
	For $ii = 1 To $line_ct
		$quote_on = "No"
		$line[0] = $line[$ii]
		$line_length = StringLen($line[0])
		$line_new[$ii] = ""
		For $jj = 1 To $line_length
			$char = StringLeft($line[0], 1)
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $On_Whitespace = "Y" Then
				If $char = "$" And $quote_on = "No" Then _Add_WhiteSpace_Char()
				If $char = "<" And $quote_on = "No" Then _Add_WhiteSpace_Char()
				If $char = Chr(34) And $quote_on = "Yes" Then _Add_WhiteSpace_Char()
				If $char = Chr(34) And $quote_on = "No" Then _Add_Char_WhiteSpace()
				If $char = "=" And $quote_on = "No" Then _Add_Char_WhiteSpace()
				If $char = ">" And $quote_on = "No" Then _Add_Char_WhiteSpace()
				If $char = "[" And $quote_on = "No" Then _Add_WhiteSpace_Char_WhiteSpace()
				If $char = "]" And $quote_on = "No" Then _Add_WhiteSpace_Char_WhiteSpace()
				If $char = "(" And $quote_on = "No" Then _Add_WhiteSpace_Char_WhiteSpace()
				If $char = ")" And $quote_on = "No" Then _Add_WhiteSpace_Char_WhiteSpace()
				If $char = "," And $quote_on = "No" Then _Add_WhiteSpace_Char_WhiteSpace()
				If $char = " " And $quote_on = "No" Then _Add_WhiteSpace_Char_WhiteSpace()
			EndIf
			$line_new[$ii] = $line_new[$ii] & $char
			$line[0] = StringTrimLeft($line[0], 1)
		Next
	Next
EndFunc ; ==> _Lines_Find_Splits
; ===================================================================================================
Func _Add_WhiteSpace_Char() ; Add white space to front of character
	_Random_White_Space() ; Calculate random white space
	$char = $white_space & $char
EndFunc ; ==> _Add_WhiteSpace_Char
; ===================================================================================================
Func _Add_Char_WhiteSpace() ; Add white space to front of character
	_Random_White_Space() ; Calculate random white space
	$char = $char & $white_space
EndFunc ; ==> _Add_Char_WhiteSpace
; ===================================================================================================
Func _Add_WhiteSpace_Char_WhiteSpace() ; Add white space to front and back of character
	_Random_White_Space() ; Calculate random white space
	$char = $white_space & $char & $white_space
EndFunc ; _Add_WhiteSpace_Char_WhiteSpace
; ===================================================================================================
Func _Random_White_Space() ; Calculate random white space
	$space_ct = Random( 3, 7, 1) ; Number of random spaces
	$random_spaces = ""
	For $ss = 1 To $space_ct
		$random_spaces = $random_spaces & Chr(32) ; Sum spaces
	Next
	$tab_ct = Random( 3, 7, 1) ; Number of random tabs
	$random_tabs = ""
	For $tt = 1 To $tab_ct
		$random_tabs = $random_tabs & Chr(9) ; Sum tabs
	Next
	$white_space = ""
	$white_space = $random_spaces & $random_tabs & $random_spaces
EndFunc ; ==> _Random_White_Space
; ===================================================================================================
Func _File_Write_New() ; Write new file
	$file_new = StringTrimRight($file_orig, 4) & " - Simple Obfuscated.au3" ; Create new file name
	FileOpen($file_new, 2) ; Open new file to write
	For $ii = 1 To $line_ct
		If $line_new[$ii] <> "" Then FileWrite($file_new, $line_new[$ii] & @CRLF )
	Next
	FileClose($file_new)
EndFunc ; ==> _File_Write_New
; ===================================================================================================
