; Title: Simple_Obfuscator_v1.2.au3
; Version: v1.2
; Requirements: AutoIt Version 3.1.1.0 (Beta is NOT required)
; Date: July 26, 2006
; Author: taurus905
; Purpose: This script obfuscates an AutoIt script by identifying, counting and replacing all
;          variables and functions within that script, according to the following notes.
; Notes: Variables that are all UPPERCASE, such as, $GUI_EVENT_CLOSE, will not be obfuscated.
;        Functions to be obfuscated must start with an underscore "_".
;        Functions that are all UPPERCASE, such as, _DO_NOT_OBFUSCATE_THIS, will not be obfuscated.
;        Add arguments in the "Functions_NOT_to_obfuscate_section:" to bypass these functions.
;        Uncomment: (in the script)
;             Global $Show_Messages = "Yes"
;                  to show Message Boxes and Array Displays during execution.
; Input:            An AutoIt Script --> OriginalScriptName.au3
; Output: Variables to be Obfuscated --> OriginalScriptName - Vars to Obfuscate.txt
;         Functions to be Obfuscated --> OriginalScriptName - Funcs to Obfuscate.txt
;                       Random Names --> OriginalScriptName - Random Names.txt
;           Simple Obfuscated Script --> OriginalScriptName - Simple Obfuscated.au3
; ===================================================================================================

#include <GUIConstants.au3>
#include <Array.au3>
Opt("MustDeclareVars", 1) ; Variables must be declared

Global $Show_Messages = "No"
; Uncomment the following line to see progress messages and arrays during execution.
;Global $Show_Messages = "Yes"
; ===================================================================================================

Global $file_Script_to_Obfuscate
_Choose_Script_to_Obfuscate() ; Choose Script to Obfuscate

; ===================================================================================================
; Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines

Global $Num_of_Lines
_Count_Lines() ; Count Lines of Script to Obfuscate
If $Show_Messages = "Yes" Then MsgBox(0, "$Num_of_Lines", $Num_of_Lines)

Global $Array_of_Lines[$Num_of_Lines + 1]
_Read_Lines_to_Array() ; Read Lines to Array
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Lines, "$Array_of_Lines")

; Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines
; ===================================================================================================
; Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars

Global $Num_of_Vars
_Count_Vars() ; Count Variables in Script to Obfuscate
If $Show_Messages = "Yes" Then MsgBox(0, "$Num_of_Vars", $Num_of_Vars)

Global $Array_of_Vars[$Num_of_Vars + 1]
_Read_Vars_to_Array() ; Read Variables to Array
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Vars, "$Array_of_Vars")

_Sort_Array_of_Vars() ; Sort Array of Variables
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Vars, "$Array_of_Vars")

Global $Num_of_Unique_Vars
_Count_Unique_Vars() ; Count Unique Variables
If $Show_Messages = "Yes" Then MsgBox(0, "$Num_of_Unique_Vars", $Num_of_Unique_Vars)

Global $Array_of_Unique_Vars[$Num_of_Unique_Vars + 1]
_Read_Unique_Vars_to_Array() ; Read Unique Variables to Array
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Unique_Vars, "$Array_of_Unique_Vars")

_Write_Unique_Vars_to_File() ; Write Unique Variables to File

; Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars
; ===================================================================================================
; Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs

Global $Num_of_Funcs
_Count_Funcs() ; Count Functions in Script to Obfuscate
If $Show_Messages = "Yes" Then MsgBox(0, "$Num_of_Funcs", $Num_of_Funcs)

Global $Array_of_Funcs[$Num_of_Funcs + 1]
_Read_Funcs_to_Array() ; Read Functions to Array
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Funcs, "$Array_of_Funcs")

_Sort_Array_of_Funcs() ; Sort Array of Functions
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Funcs, "$Array_of_Funcs")

Global $Num_of_Unique_Funcs
_Count_Unique_Funcs() ; Count Unique Functions
If $Show_Messages = "Yes" Then MsgBox(0, "$Num_of_Unique_Funcs", $Num_of_Unique_Funcs)

Global $Array_of_Unique_Funcs[$Num_of_Unique_Funcs + 1]
_Read_Unique_Funcs_to_Array() ; Read Unique Functions to Array
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Unique_Funcs, "$Array_of_Unique_Funcs")

_Write_Unique_Funcs_to_File() ; Write Unique Functions to File

; Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs
; ===================================================================================================
; Random - Random - Random - Random - Random - Random - Random - Random - Random - Random - Random

Global $Num_of_Random_Names
_Find_Random_Name_Count() ; Find Random Name Count

Global $Random_Name[$Num_of_Random_Names + 1]
_Read_Random_Names_to_Array() ; Read Random Names to Array
If $Show_Messages = "Yes" Then _ArrayDisplay($Random_Name, "$Random_Name")

_Write_Random_Names_to_File() ; Write Random Names to File

; Random - Random - Random - Random - Random - Random - Random - Random - Random - Random - Random
; ===================================================================================================
; Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace

_Replace_Vars() ; Replace Variables
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Lines, "$Array_of_Lines")

_Replace_Funcs() ; Replace Functions
If $Show_Messages = "Yes" Then _ArrayDisplay($Array_of_Lines, "$Array_of_Lines")

Global $New_Array_of_Lines[$Num_of_Lines + 1]
_Remove_Comments() ; Remove Comments
If $Show_Messages = "Yes" Then _ArrayDisplay($New_Array_of_Lines, "$New_Array_of_Lines")

; Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace
; ===================================================================================================

_Write_Simple_Obfuscated_File() ; Write Simple Obfuscated Script

Exit
; ###################################################################################################
; ===================================================================================================
Func _Choose_Script_to_Obfuscate() ; Choose Script to Obfuscate
	$file_Script_to_Obfuscate = FileOpenDialog("Choose an AutoIt Script to Obfuscate:", @ScriptDir, "Scripts (*.au3)", 1 + 2)
	If @error Then Exit
EndFunc ; ==> _Choose_Script_to_Obfuscate
; ===================================================================================================
; Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines

Func _Count_Lines() ; Count Lines of Script to Obfuscate
	FileOpen($file_Script_to_Obfuscate, 0) ; Open File to Obfuscate
	$Num_of_Lines = 0
	While 1
		$Num_of_Lines = $Num_of_Lines + 1
		FileReadLine($file_Script_to_Obfuscate, $Num_of_Lines) ; Read All Lines for Count
		If @error = -1 Then ExitLoop
	WEnd
EndFunc ; ==> _Count_Lines
; ===================================================================================================
Func _Read_Lines_to_Array() ; Read Lines to Array
	For $iii = 1 To $Num_of_Lines
		$Array_of_Lines[$iii] = FileReadLine($file_Script_to_Obfuscate, $iii) ; Read All Lines
	Next
	FileClose($file_Script_to_Obfuscate) ; Close File to Obfuscate
EndFunc ; ==> _Read_Lines_to_Array

; Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines - Lines
; ===================================================================================================
; Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars

Func _Count_Vars() ; Count Variables in Script to Obfuscate
	$Num_of_Vars = 0
	For $iii = 1 To $Num_of_Lines
		Local $quote_on = "No"
		$Array_of_Lines[0] = $Array_of_Lines[$iii]
		Local $line_length = StringLen($Array_of_Lines[0])
		For $jjj = 1 To $line_length
			Local $char = StringLeft($Array_of_Lines[0], 1)
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "$" And $quote_on = "No" Then $Num_of_Vars = $Num_of_Vars + 1
			$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
		Next
	Next
EndFunc ; ==> _Count_Vars
; ===================================================================================================
Func _Read_Vars_to_Array() ; Read Variables to Array
	Local $var_ct = 0
	For $iii = 1 To $Num_of_Lines
		Local $quote_on = "No"
		$Array_of_Lines[0] = $Array_of_Lines[$iii]
		Local $line_length = StringLen($Array_of_Lines[0])
		For $jjj = 1 To $line_length
			Local $char = StringLeft($Array_of_Lines[0], 1)
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "$" And $quote_on = "No" Then ; Read One Variable
				$var_ct = $var_ct + 1
				$Array_of_Vars[$var_ct] = ""
				For $kkk = 1 To 256
					$char = StringLeft($Array_of_Lines[0], 1)
					If $char = " " Or _
							$char = "	" Or _
							$char = "=" Or _
							$char = "[" Or _
							$char = "]" Or _
							$char = "," Or _
							$char = ")" Or _
							$char = ";" Or _
							$char = "+" Or _
							$char = "-" Or _
							$char = "*" Or _
							$char = "/" Or _
							$char = Chr(34) Then ExitLoop
					$Array_of_Vars[$var_ct] = $Array_of_Vars[$var_ct] & $char
					$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
				Next
			EndIf
			$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
		Next
	Next
EndFunc ; ==> _Read_Vars_to_Array
; ===================================================================================================
Func _Sort_Array_of_Vars() ; Sort Array of Variables
	_ArraySort($Array_of_Vars)
EndFunc ; ==> _Sort_Array_of_Vars
; ===================================================================================================
Func _Count_Unique_Vars() ; Count Unique Variables
	$Num_of_Unique_Vars = 0
	For $iii = 1 To $Num_of_Vars
		If $Array_of_Vars[$iii] <> $Array_of_Vars[$iii - 1] Then
			If StringIsUpper(StringTrimLeft(StringReplace($Array_of_Vars[$iii], "_", ""), 1)) Then ContinueLoop ; Don't write any system variables that are all UPPERCASE, such as, $GUI_EVENT_CLOSE
			$Num_of_Unique_Vars = $Num_of_Unique_Vars + 1
		EndIf
	Next
EndFunc ; ==> _Count_Unique_Vars
; ===================================================================================================
Func _Read_Unique_Vars_to_Array() ; Read Unique Variables to Array
	Local $var_unique_ct = 0
	For $iii = 1 To $Num_of_Vars
		If $Array_of_Vars[$iii] <> $Array_of_Vars[$iii - 1] Then
			If StringIsUpper(StringTrimLeft(StringReplace($Array_of_Vars[$iii], "_", ""), 1)) Then ContinueLoop ; Don't read any System Variables that are all UPPERCASE, such as, $GUI_EVENT_CLOSE
			$var_unique_ct = $var_unique_ct + 1
			$Array_of_Unique_Vars[$var_unique_ct] = $Array_of_Vars[$iii]
		EndIf
	Next
EndFunc ; ==> _Read_Unique_Vars_to_Array
; ===================================================================================================
Func _Write_Unique_Vars_to_File() ; Write Unique Variables to File
	Local $file_Unique_Vars = StringTrimRight($file_Script_to_Obfuscate, 4) & " - Vars to Obfuscate.txt" ; Create Unique Variables Filename
	FileOpen($file_Unique_Vars, 2) ; Open File to Write Unique Variables
	For $iii = 1 To $Num_of_Unique_Vars
		FileWrite($file_Unique_Vars, $Array_of_Unique_Vars[$iii] & @CRLF)
	Next
	FileClose($file_Unique_Vars) ; Close Unique Variables File
EndFunc ; ==> _Write_Unique_Vars_to_File

; Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars - Vars
; ===================================================================================================
; Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs

Func _Count_Funcs() ; Count Functions in Script to Obfuscate
	$Num_of_Funcs = 0
	For $iii = 1 To $Num_of_Lines
		Local $quote_on = "No"
		Local $var_on = "No"
		Local $func_on = "No"
		$Array_of_Lines[0] = $Array_of_Lines[$iii]
		Local $line_length = StringLen($Array_of_Lines[0])
		For $jjj = 1 To $line_length
			Local $char = StringLeft($Array_of_Lines[0], 1)
			If $char = "(" Or $char = " " Then $func_on = "No"
			If $char = "$" And $quote_on = "No" Then $var_on = "Yes"
			If $char = "@" And $quote_on = "No" Then $var_on = "Yes"
			If $char = "<" And $quote_on = "No" Then $var_on = "Yes"
			If $char = " " And $quote_on = "No" Then $var_on = "No"
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "_" And $quote_on = "No" And $func_on = "No" And $var_on = "No" Then
				$func_on = "Yes"
				$Num_of_Funcs = $Num_of_Funcs + 1
			EndIf
			$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
		Next
	Next
EndFunc ; ==> _Count_Funcs
; ===================================================================================================
Func _Read_Funcs_to_Array() ; Read Functions to Array
	Local $func_ct = 0
	For $iii = 1 To $Num_of_Lines
		Local $quote_on = "No"
		Local $var_on = "No"
		Local $func_on = "No"
		$Array_of_Lines[0] = $Array_of_Lines[$iii]
		Local $line_length = StringLen($Array_of_Lines[0])
		For $jjj = 1 To $line_length
			Local $char = StringLeft($Array_of_Lines[0], 1)
			If $char = "(" Or $char = " " Then $func_on = "No"
			If $char = "$" And $quote_on = "No" Then $var_on = "Yes"
			If $char = "@" And $quote_on = "No" Then $var_on = "Yes"
			If $char = "<" And $quote_on = "No" Then $var_on = "Yes"
			If $char = " " And $quote_on = "No" Then $var_on = "No"
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			If $char = "_" And $quote_on = "No" And $func_on = "No" And $var_on = "No" Then ; Read One Function
				$func_ct = $func_ct + 1
				$Array_of_Funcs[$func_ct] = ""
				For $kkk = 1 To 256
					$char = StringLeft($Array_of_Lines[0], 1)
					If $char = " " Or $char = "(" Then ExitLoop
					$Array_of_Funcs[$func_ct] = $Array_of_Funcs[$func_ct] & $char
					$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
				Next
				; Functions_NOT_to_obfuscate_section:
				; Add functions to the following lines that start with an underscore "_" that you
				;    do NOT want to be obfuscated. Example:
				; If $Array_of_Funcs[$func_ct] = "_ArraySort" Or _
				If $Array_of_Funcs[$func_ct] = "_ArraySort" Or _
						$Array_of_Funcs[$func_ct] = "_ArrayDisplay" Or _
						$Array_of_Funcs[$func_ct] = "_ChooseColor" Or _
						$Array_of_Funcs[$func_ct] = "_ChooseFont" Or _
						$Array_of_Funcs[$func_ct] = "_ImageGetSize" Or _
						$Array_of_Funcs[$func_ct] = "_IsPressed" Or _
						$Array_of_Funcs[$func_ct] = "_StringEncrypt" Or _
						$Array_of_Funcs[$func_ct] = "_" Then ; Do NOT Count Built-In Functions
					$func_ct = $func_ct - 1
				EndIf
			EndIf
			$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
		Next
	Next
EndFunc ; ==> _Read_Funcs_to_Array
; ===================================================================================================
Func _Sort_Array_of_Funcs() ; Sort Array of Functions
	_ArraySort($Array_of_Funcs)
EndFunc ; ==> _Sort_Array_of_Funcs
; ===================================================================================================
Func _Count_Unique_Funcs() ; Count Unique Functions
	$Num_of_Unique_Funcs = 0
	For $iii = 1 To $Num_of_Funcs
		If $Array_of_Funcs[$iii] <> $Array_of_Funcs[$iii - 1] Then
			If StringIsUpper(StringTrimLeft(StringReplace($Array_of_Funcs[$iii], "_", ""), 1)) Then ContinueLoop ; Don't write any functions that are all UPPERCASE, such as, _DO_NOT_OBFUSCATE_THIS
			$Num_of_Unique_Funcs = $Num_of_Unique_Funcs + 1
		EndIf
	Next
EndFunc ; ==> _Count_Unique_Funcs
; ===================================================================================================
Func _Read_Unique_Funcs_to_Array() ; Read Unique Functions to Array
	Local $func_unique_ct = 0
	For $iii = 1 To $Num_of_Funcs
		If $Array_of_Funcs[$iii] <> $Array_of_Funcs[$iii - 1] Then
			If StringIsUpper(StringTrimLeft(StringReplace($Array_of_Funcs[$iii], "_", ""), 1)) Then ContinueLoop ; Don't write any functions that are all UPPERCASE, such as, _DONOTOBFUSCATETHIS
			$func_unique_ct = $func_unique_ct + 1
			$Array_of_Unique_Funcs[$func_unique_ct] = $Array_of_Funcs[$iii]
		EndIf
	Next
EndFunc ; ==> _Read_Unique_Funcs_to_Array
; ===================================================================================================
Func _Write_Unique_Funcs_to_File() ; Write Unique Functions to File
	Local $file_Unique_Funcs = StringTrimRight($file_Script_to_Obfuscate, 4) & " - Funcs to Obfuscate.txt" ; Create Unique Functions Filename
	FileOpen($file_Unique_Funcs, 2) ; Open File to Write Unique Functions
	For $iii = 1 To $Num_of_Unique_Funcs
		FileWrite($file_Unique_Funcs, $Array_of_Unique_Funcs[$iii] & @CRLF)
	Next
	FileClose($file_Unique_Funcs) ; Close Unique Functions File
EndFunc ; ==> _Write_Unique_Funcs_to_File

; Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs - Funcs
; ===================================================================================================
; Random - Random - Random - Random - Random - Random - Random - Random - Random - Random - Random

Func _Find_Random_Name_Count() ; Find Random Name Count
	If $Num_of_Unique_Vars > $Num_of_Unique_Funcs Then
		$Num_of_Random_Names = $Num_of_Unique_Vars
	Else
		$Num_of_Random_Names = $Num_of_Unique_Funcs
	EndIf
EndFunc ; ==> _Find_Random_Name_Count
; ===================================================================================================
Func _Read_Random_Names_to_Array() ; Read Random Names to Array
	Local $random[9]
	For $iii = 1 To $Num_of_Random_Names
		$Random_Name[$iii] = ""
		For $jjj = 1 To 8 ; The number of random characters to use in each random name
			$random[$jjj] = Random(48, 122, 1)
			If $random[$jjj] > 64 And $random[$jjj] < 91 Or $random[$jjj] > 96 And $random[$jjj] < 123 Then
				$Random_Name[$iii] = $Random_Name[$iii] & Chr($random[$jjj])
			Else
				$jjj = $jjj - 1
				ContinueLoop
			EndIf
		Next
	Next
EndFunc ; ==> _Read_Random_Names_to_Array
; ===================================================================================================
Func _Write_Random_Names_to_File() ; Write Random Names to File
	Local $file_Random_Names = StringTrimRight($file_Script_to_Obfuscate, 4) & " - Random Names.txt" ; Create Random Names Filename
	FileOpen($file_Random_Names, 2) ; Open File to Write Random Names
	For $iii = 1 To $Num_of_Random_Names
		FileWrite($file_Random_Names, $Random_Name[$iii] & @CRLF)
	Next
	FileClose($file_Random_Names) ; Close Random Names File
EndFunc ; ==> _Write_Random_Names_to_File

; Random - Random - Random - Random - Random - Random - Random - Random - Random - Random - Random
; ===================================================================================================
; Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace

Func _Replace_Vars() ; Replace Variables
	For $iii = 1 To $Num_of_Lines
		For $jjj = $Num_of_Unique_Vars To 1 Step - 1
			$Array_of_Lines[$iii] = StringReplace($Array_of_Lines[$iii], $Array_of_Unique_Vars[$jjj], "$" & $Random_Name[$jjj])
		Next
	Next
EndFunc ; ==> _Replace_Vars
; ===================================================================================================
Func _Replace_Funcs() ; Replace Functions
	For $iii = 1 To $Num_of_Lines
		For $jjj = $Num_of_Unique_Funcs To 1 Step - 1
			$Array_of_Lines[$iii] = StringReplace($Array_of_Lines[$iii], $Array_of_Unique_Funcs[$jjj], $Random_Name[$jjj])
		Next
	Next
EndFunc ; ==> _Replace_Funcs
; ===================================================================================================
Func _Remove_Comments() ; Remove Comments
	For $iii = 1 To $Num_of_Lines
		Local $quote_on = "No"
		$Array_of_Lines[0] = $Array_of_Lines[$iii]
		Local $line_length = StringLen($Array_of_Lines[0])
		$New_Array_of_Lines[$iii] = ""
		For $jjj = 1 To $line_length
			Local $char = StringLeft($Array_of_Lines[0], 1)
			If $char = Chr(34) And $quote_on = "No" Then
				$quote_on = "Yes"
			ElseIf $char = Chr(34) And $quote_on = "Yes" Then
				$quote_on = "No"
			EndIf
			If $char = ";" And $quote_on = "No" Then ExitLoop
			$New_Array_of_Lines[$iii] = $New_Array_of_Lines[$iii] & $char
			$Array_of_Lines[0] = StringTrimLeft($Array_of_Lines[0], 1)
		Next
	Next
EndFunc ; ==> _Remove_Comments

; Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace - Replace
; ===================================================================================================

Func _Write_Simple_Obfuscated_File() ; Write Simple Obfuscated File
	Local $file_Simple_Obfuscated = StringTrimRight($file_Script_to_Obfuscate, 4) & " - Simple Obfuscated.au3" ; Create Simple Obfuscated Filename
	FileOpen($file_Simple_Obfuscated, 2) ; Open File to Write Simple Obfuscated Script
	For $iii = 1 To $Num_of_Lines
		If $New_Array_of_Lines[$iii] <> "" Then FileWrite($file_Simple_Obfuscated, $New_Array_of_Lines[$iii] & @CRLF)
	Next
	FileClose($file_Simple_Obfuscated) ; Close Simple Obfuscated File
EndFunc ; ==> _Write_Simple_Obfuscated_File
; ===================================================================================================
