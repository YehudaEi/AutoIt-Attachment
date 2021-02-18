#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<array.au3>
#include<file.au3>
#include<string.au3>
#include"Autoit_def.au3"

$VERSION = "v0.0.1"
ConsoleWrite("Autoit Generic PArSeR " & $VERSION & " - - (c) 2011" & @CRLF & @CRLF)

;+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_
;PROGRAM STRUCTURE:
;	1. Takes Input
;	2. Reads Definitions telling it how to process the data. (Default for autoitv3 script parsing: Autoit_def.au3)
;	3. Following the definition, performs an ordered set of functions interpreting the script into a generic, non-Object Oriented format.
;	4. At this point this format can be interpreted into another language, with a custom script.


;Internal Variables.
global $original_filearray
global $working_filearray
global $outputhandle
global $outputfilename
global $buildpath = "/build"
global $build_datastructure_path = "/build/data structures"

global $current_address = Random(120, 600, 1)
global $Code_Start_Pointer
;Script Parsing Variables.
global $coded_languages

global $required_modules[1]
global $script_functions[1][2]; 0 = name, 1 = filepath to code.


if not FileExists(@ScriptDir & $buildpath) then DirCreate( @ScriptDir & $buildpath)
if not FileExists(@ScriptDir & $build_datastructure_path) then DirCreate( @ScriptDir & $build_datastructure_path)


;Select inputfile.
$inputfile = FileOpenDialog("Select a script file...", @ScriptDir & "\", "Autoit Scripts (*.au3)", 1 + 2 )

;Build the working resources.
$outputfilename = GetName_frompath( $inputfile)
_FileReadToArray( $inputfile, $original_filearray)
$working_filearray = $original_filearray
ConsoleWrite("File Selected: " & UBound( $original_filearray) & " lines." & @CRLF)
Defs_parse_INTERPRET() ;This uses the definition variables to parse the input and build an output.

Sleep(2000)
ConsoleWrite(@CRLF & @CRLF &  "Autoit -> Generic Completed Successfullly." & @CRLF)

;==================Convienience Functions=========
Func GetName_frompath( $path)
	local $spl = StringSplit( $path, "/\")
	return $spl[$spl[0]]
EndFunc

Func Build_from_file( $path)
	ConsoleWrite( "Rebuilding Parse Data from: " & $path & @CRLF)
	_FileReadToArray( @ScriptDir & $path, $working_filearray)
EndFunc

;==================Definition Resolution Functions============

;Parse from a definitions file (must be an #include in the script) - Very powerful.
Func Defs_parse_INTERPRET()
	IniWrite(@ScriptDir & $buildpath & "/global." & @YDAY & "." & $outputfilename & ".ini", "global","lang",$Def_Language)
	If not $interpret_ready then
		ConsoleWrite(@CRLF & "Unable to interpret: Definitions incapable." & @CRLF)
		Return
	EndIf

	for $opcode = 0 to UBound( $interpret_actions)-1 step 1
		local $operations = StringSplit( $interpret_actions[$opcode], "-")
		if $operations[2] = "File" Then $output = $buildpath & "/" & $operations[1] & "." & @YDAY & "." & $outputfilename
		if $operations[2] = "Internal" Then $output = "MEMORY"
		Simple_parse( $operations[1], $working_filearray, $output)

		if $operations[3] = "Rebuild" then Build_from_file( $output)
		if $operations[3] = "Hold" then ContinueLoop
		sleep(400);wait a bit in case the file buffers haven't been flushed.
	Next
	sleep(2000)
	Transolate_Build_Autoit($Code_Start_Pointer);Build the Generic Format from Autoit.
EndFunc



;Parsing Caller:
Func Simple_parse( $func, $input, $output, $rebuild = False)
	if not Call( $func, $input, $output) Then
		ConsoleWrite(@CRLF&"->Critical Error in " & $func & " - Terminating. The build is incomplete.:" & @CRLF)
		Exit
	EndIf
	ConsoleWrite(@CRLF & $func & " Completed." & @CRLF)
	if $rebuild Then
		Build_from_file( $output)
	EndIf
EndFunc

;==================BREAKOUT FUNCTIONS===============
;These functions normalize the input and build data structures that can be parsed.
;===================================================

Func Un_Tidy($input, $output = False)
	ConsoleWrite(@CRLF& "+--->Untidy - v1.0. Output: " & $output & @CRLF)
	local $goodpass = False
	local $passcount = 0

	While $goodpass = False
		ConsoleWrite("=> UnTidy_: Pass: " & $passcount+1 & @CRLF)
		$passcount += 1
		$goodpass = True
		for $x = 1 to $input[0] step 1
			if $input[$x] = " " or Asc($input[$x]) = 9 Then
				local $atemp = StringTrimLeft( $input[$x], 1)
				$input[$x] = $atemp
				$goodpass = FAlse
			EndIf
		Next
		Sleep(50)
	WEnd

	if $output = "MEMORY" Then
		ConsoleWrite("=> UnTidy_: Output Committed to the working set." & @CRLF)
		$working_filearray = $input
	Else
		ConsoleWrite("=> UnTidy_: Building output: " & $output & @CRLF)
		_FileWriteFromArray( @ScriptDir & $output, $input, 1)
	EndIf
	return true
EndFunc

Func Dependency_Discovery($input, $output = False)
	;TODO - Support for multiple boundries.
	ConsoleWrite(@CRLF& "+--->Dependency Discovery - v1.0. Output: " & $output & @CRLF)
	ConsoleWrite("=> Dependency_Discovery_: Recursive Definitions set to " & $Dependency_Discovery_Is_Recursive & "." & @CRLF)
	if not $Dependency_Discovery_Is_Recursive Then

		for $x = 1 to $input[0] step 1
			if StringUpper(StringLeft($input[$x], StringLen($Dependency_Discovery_Def[0]))) = StringUpper($Dependency_Discovery_Def[0]) Then
				local $spl = StringSplit($Dependency_Discovery_Def[1], "")
				local $module = StringTrimRight( StringTrimLeft($input[$x], StringLen($Dependency_Discovery_Def[0])+StringLen($spl[1])), StringLen($spl[2]))
				if StringLeft( $module, 1) = "<" or StringLeft( $module, 1) = '"' or StringLeft( $module, 1) = "'" then $module = StringTrimLeft($module,1)
				ConsoleWrite("=> Dependency_Discovery_: Module Discovered with reference - " & $module & @CRLF)
				sleep(50)
				redim $required_modules[UBound($required_modules)+1]
				$required_modules[UBound($required_modules)-1] = $module
			EndIf
		Next

		if $output <> "MEMORY" then
			for $s = 0 to UBound($required_modules)-1 step 1
				if $s = 0 then ContinueLoop
				IniWrite( @ScriptDir & $buildpath & "/global." & @YDAY & "." & $outputfilename & ".ini", "modules", $s, $required_modules[$s])
			Next
		EndIf
	else
		ConsoleWrite("=> Dependency_Discovery_: ERROR - Recursive Dependency Discovery is not yet supported." & @CRLF)
		return false
	EndIf
	return true
EndFunc

Func Function_Alloc($input, $output = False)
	ConsoleWrite(@CRLF& "+--->Function_Alloc - v1.0. Output: " & $output & @CRLF)
	ConsoleWrite("=> Function_Alloc_: Recursive Definitions set to " & $Function_Alloc_Is_Recursive & "." & @CRLF)
	if not $Function_Alloc_Is_Recursive Then
		for $x = 1 to $input[0] step 1
			if StringUpper(StringLeft($input[$x], StringLen($Function_Alloc_Def[0]))) = StringUpper($Function_Alloc_Def[0]) Then
				local $funcname = StringTrimLeft($input[$x], StringLen($Function_Alloc_Def[0]))
				redim $script_functions[UBound($script_functions)+1][2]
				$script_functions[UBound($script_functions)-1][0] = $funcname
				$script_functions[UBound($script_functions)-1][1] = $buildpath & "/Function_Alloc." & $funcname & "." & @YDAY & "." & $outputfilename

				if $output <> "MEMORY" Then
					local $foundpos = False
					local $completestr = ""
					While $x < $input[0]
						$x += 1
						if StringUpper($input[$x]) = StringUpper($Function_Alloc_Endblock) Then
							$foundpos += 1
							ExitLoop
						EndIf
						$completestr = $completestr & @CRLF & $input[$x]
					WEnd
					if $foundpos = False Then
						ConsoleWrite( @CRLF& "=> Function_Alloc_: CRITICAL ERROR: Unbalanced Function Expression." & @CRLF)
						return false
					Else
						ConsoleWrite("=> Function_Alloc_: Function: " & $funcname & " was discovered." & @CRLF)
						sleep(50)
					EndIf
					local $filehnd = FileOpen( @ScriptDir & $buildpath & "/Function_Alloc." & $funcname & "." & @YDAY & "." & $outputfilename, 8 + 2)
					FileWrite( $filehnd, $completestr)
					FileClose( $filehnd)
				EndIf
			EndIf
		Next
	else
		ConsoleWrite("=> Function_Alloc_: ERROR - Recursive Function Discovery is not yet supported." & @CRLF)
		return false
	EndIf
	return True
EndFunc


;==============Parsing Functions================================
;These interpret the breakouts and scripts into the generic format.
;===============================================================

Func Parser_Launch( $input, $output)
	ConsoleWrite(@CRLF &  "+====+>Code Block Parser v1.0 (c) 2011 " & @CRLF)
	ConsoleWrite("=>Output: " & $output & @CRLF & @CRLF)
	sleep(700)
	local $pointer = $current_address+Random(0,99999,1)
	$Code_Start_Pointer = $pointer
	ConsoleWrite( "Start Code Pointer: " & _StringToHex($pointer) & @CRLF)
	IniWrite( @ScriptDir & $buildpath & "/global." & @YDAY & "." & $outputfilename & ".ini", "global", "codepointer", _StringToHex($pointer))
	return Generic_Parse( $input, $output, 1, "", 1, $pointer)
EndFunc



;Hard function to explain.
;Basically, it detects all the control statements - While, If, For, etc, and gives each nested block its own file.
;Every block gets its own file to prevent reuse of ambiguous/multi-case code.

;The detection is acomplished by heavy recursion, that unwinds at the end of each block.
;It also begins to classify lines ready for the generic interpreter.
Func Generic_Parse( $input, $output, $startline, $terminate_block_signal, $level, $address)

	local $filehnd = FileOpen(@ScriptDir & $build_datastructure_path & "/" & _StringToHex(String($address)) & "." & @YDAY & "." & $outputfilename, 2)


	for $lineposition = $startline to $input[0] step 1
		;ConsoleWrite( $lineposition & "-" & _StringRepeat( "=", $level*3) & "> " & $input[$lineposition] & @CRLF)

		;If we have reached the end of our domain, so unwind recursion.
		if $terminate_block_signal <> "" and StringUpper(StringLeft( $input[$lineposition], StringLen($terminate_block_signal))) = StringUpper($terminate_block_signal) Then
			return $lineposition
		EndIf

		;IF CONTROL STATEMENT
		if StringUpper(StringLeft($input[$lineposition], StringLen($IF_statement))) = StringUpper($IF_statement) Then
			if StringUpper(StringRight( $input[$lineposition], StringLen($IF_Suffix)+StringLen($Control_Block_Suffix))) = StringUpper($IF_Suffix&$Control_Block_Suffix) then
				ConsoleWrite( "=> Recursive Parse Advance (IF Control Statement) - Depth: " & $level & " Line: " & $lineposition & @CRLF)
				FileWriteLine( $filehnd, $input[$lineposition])
				local $pointer = $current_address+Random(0,99999,1)
				FileWriteLine( $filehnd, "CONDITIONAL IF POINT " & String($pointer))
				$lineposition = Generic_Parse( $input, $output, $lineposition+1, $IF_Close, $level+1, $pointer)
				Sleep(50);Giva 'ittle time for the garbage collector
			Else
				local $spl = StringSplit( $input[$lineposition], $IF_Suffix&$Control_Block_Suffix, 1)
				if $spl[0] > 1 Then
					FileWriteLine( $filehnd, $input[$lineposition])
					FileWriteLine( $filehnd, "CONDITIONAL IF EXPRESSION")
				EndIf
			EndIf
		;FOR CONTROL STATEMENT
		ElseIf StringUpper(StringLeft($input[$lineposition], StringLen($FOR_statement))) = StringUpper($FOR_statement) Then
				ConsoleWrite( "=> Recursive Parse Advance (FOR Control Statement) - Depth: " & $level & " Line: " & $lineposition & @CRLF)
				FileWriteLine( $filehnd, $input[$lineposition])
				local $pointer = $current_address+Random(0,99999,1)
				FileWriteLine( $filehnd, "CONDITIONAL FOR POINT " & String($pointer))
				$lineposition = Generic_Parse( $input, $output, $lineposition+1, $FOR_Close, $level+1, $pointer)
				Sleep(50);Giva 'ittle time for the garbage collector
		;WHILE CONTROL STATEMENT
		ElseIf StringUpper(StringLeft($input[$lineposition], StringLen($WHILE_statement))) = StringUpper($WHILE_statement) Then
				ConsoleWrite( "=> Recursive Parse Advance (WHILE Control Statement) - Depth: " & $level & " Line: " & $lineposition & @CRLF)
				FileWriteLine( $filehnd, $input[$lineposition])
				local $pointer = $current_address+Random(0,99999,1)
				FileWriteLine( $filehnd, "CONDITIONAL WHILE POINT " & String($pointer))
				$lineposition = Generic_Parse( $input, $output, $lineposition+1, $WHILE_Close, $level+1, $pointer)
				Sleep(50);Giva 'ittle time for the garbage collector
		;USER DEFINED CONTROL BLOCKS
		ElseIf StringUpper(StringLeft($input[$lineposition], StringLen($Function_Alloc_Def[0]))) = StringUpper($Function_Alloc_Def[0]) Then
				ConsoleWrite( "=> Recursive Parse Advance (USER DEFINED Control Statement) - Depth: " & $level & " Line: " & $lineposition & @CRLF)
				FileWriteLine( $filehnd, $input[$lineposition])
				local $pointer = $current_address+Random(0,99999,1)
				FileWriteLine( $filehnd, "COMPILER FUNCTION POINT " & String($pointer))
				$lineposition = Generic_Parse( $input, $output, $lineposition+1, $Function_Alloc_Endblock, $level+1, $pointer)
				Sleep(50);Giva 'ittle time for the garbage collector
		Else
			FileWriteLine( $filehnd, $input[$lineposition])
			FileWriteLine( $filehnd, "UNPROCESSEDCOMMAND")
		EndIf
	Next
	FileClose($filehnd)
	return $address
EndFunc


;===============Transolator Functions=============
;Now that the ambigiuities are gone we can rebuild the code's functionality into the generic format.
;=================================================

;Given a (generic language) pointer, It will convert the Autoit code into generic (language) code.
Func Transolate_Build_Autoit($start_pointer)
	ConsoleWrite(@CRLF &  "+====+>    Autoit   ->   Generic Interpreter v1.0 (c) 2011 " & @CRLF)
	ConsoleWrite(@CRLF &  "=>Beginning Translation - Pointer:  " & _StringToHex($start_pointer) & @CRLF)
	Transolate_File_Autoit($start_pointer, "", "")
EndFunc


;Recursive function to walk through every line in order, and translate it to generic (language).
Func Transolate_File_Autoit($pointer, $line, $Classify_line)
	ConsoleWrite(@CRLF &  "====>Transolate From Pointer: " & $pointer)
	sleep(50)
	;Circumvents a bug in _FileReadToArray()
	local $filearr = Robust_File_Read_To_Array( @ScriptDir & $build_datastructure_path & "/" & _StringToHex($pointer) & "." & @YDAY & "." & $outputfilename)

	For $first_line_count = 1 to $filearr[0] step 2 ;jump in each block; which consists of two lines - Code and discriptor.
		$line = $filearr[$first_line_count]
		$Classify_line = $filearr[$first_line_count+1]
		if $filearr[0] <  $first_line_count+1 then
			ConsoleWrite(@CRLF &  "=>Translation Error: Inbalanced Input File!")
			Exit
		EndIf
		local $ret = Transolate_Line_Autoit( $line, $Classify_line)
		$filearr[$first_line_count] = $ret[0]
		$filearr[$first_line_count+1] = $ret[1]
	Next
	_FileWriteFromArray( @ScriptDir & $build_datastructure_path & "/" & _StringToHex($pointer) & "." & @YDAY & "." & $outputfilename, $filearr, 1)
EndFunc

;Worker function for the above. Interprets Builtins, scope, User Funcs, expressions, and pointers and translates to GENERIC.
Func Transolate_Line_Autoit( $input, $Classify_line)
	local $splorg = StringSplit( $input, " ")
	local $ret[2]
	$ret[0] = $input
	$ret[1] = $Classify_line
	For $q = 1 to UBound($Prefix_Modifiers)-1 step 1
		if StringUpper($splorg[1]) = $Prefix_Modifiers[$q] Then
			$input = StringTrimLeft( $input, StringLen($Prefix_Modifiers[$q])+1)
			ExitLoop
		EndIf
	Next

	;ConsoleWrite(@CRLF &  "=>Transolate Line: "& $input & "- - - - " & $Classify_line)
	FileWrite( @ScriptDir & $build_datastructure_path & "/PreTranslateDUMP" , $input & @CRLF & $Classify_line & @CRLF & @CRLF)
	local $class_split = StringSplit( $Classify_line, " ")
	local $spl = StringSplit( $input, " ")

	if $class_split[0] > 3 and $class_split[3] = "POINT" Then
		$ret[0] = Conditional_Expression_format( $input, $Classify_line)
		Transolate_File_Autoit(String($class_split[4]), $input, $Classify_line)
	ElseIf $Var_has_symbol and StringLeft($input, 1) = "$" and $class_split[1] = "UNPROCESSEDCOMMAND" Then
		if StringInStr( $spl[1], "[") > 0 Then
			$ret[1] = "ASSIGNMENT ARRAY"
		Else
			$ret[1] = "ASSIGNMENT VARIANT"
		EndIf
		$ret[0] = Expression_Capitalise( $input)
	ElseIf StringInStr( $spl[1], "(") > 0 Then ;Function
		local $spl2 = StringSplit( $spl[1], "(")
		for $r = 0 to Ubound($Builtin_Funcs)-1 step 1
			if $spl2[1] = $Builtin_Funcs[$r] Then
				$ret[1] = "BUILTIN " & $Def_Language
				$ret[0] = Expression_Capitalise( $input)
				return $ret
			EndIf
		Next

		for $r = 0 to Ubound($script_functions)-1 step 1
			local $tempspl = StringSplit( $script_functions[$r][0], "(")
			if  $tempspl[1] = $spl2[1] then
				$ret[1] = "FUNCTION (" & $tempspl[1] & ")"
				$ret[0] = Expression_Capitalise( $input)
				return $ret
			EndIf
		Next
	ElseIf StringLeft($input, 1) = ";" Then
		$ret[1] = "COMMENT"
	ElseIf StringLeft(StringUpper($input), 8) = "#INCLUDE" Then ;They were found in module discovery, right?
		$ret[1] = "REGISTERED MODULE INCLUSION"
	ElseIf StringLeft(StringUpper($input), 1) = "#" Then ;No one gives a damn bout these fuckers.
		$ret[1] = "COMPILER DIRECTIVE"
	ElseIf StringUpper($input) = "" Then
		$ret[1] = "WHITESPACE"
	Else
		for $y = 0 to UBound($Expressional_functions)-1 step 1
			if StringUpper($spl[1]) = $Expressional_functions[$y] Then
				$ret[1] = "EXPRESSIONAL BUILTIN " & $Def_Language
				$ret[0] = $Expressional_functions[$y] & " (" & StringTrimLeft( $input, StringLen($Expressional_functions[$y])+1) & ")"
				return $ret
			EndIf
		Next

		$ret[1] = "UNKNOWN OPERATION"
		$ret[0] = Expression_Capitalise( $input)
	EndIf

	For $q = 1 to UBound($Prefix_Modifiers)-1 step 1
		if StringUpper($splorg[1]) = $Prefix_Modifiers[$q] Then
			$ret[1] &= " (" & $Prefix_Modifiers[$q] & ")"
			ExitLoop
		EndIf
	Next

	return $ret
EndFunc

;Given a Conditional expression, it will format it.
Func Conditional_Expression_format( $input, $Classify_line)
	$input = Expression_Capitalise( $input)
	local $spl = StringSplit( $input, " ")
	local $cspl = StringSplit( $Classify_line, " ")
	if not $cspl[1] = "CONDITIONAL" Then return $input

	if $cspl[2] = "IF" Then ;IF (expression) THEN or If Not (expression) THEN or If (expression) or (expression) THEN
		local $expression = StringTrimLeft( StringTrimRight($input, StringLen($IF_Suffix)+1), StringLen($IF_statement)+1)
		$expression = $IF_statement & " (" & Expression_remove_whitespace( $expression) & ") " & $IF_Suffix
		return $expression

	Elseif $cspl[2] = "WHILE" Then ;WHILE (expression)
		local $expression = StringTrimLeft( $input, StringLen($WHILE_statement)+1)
		return $WHILE_statement & " (" & Expression_remove_whitespace( $expression) & ")"
	Elseif $cspl[2] = "FOR" Then
		local $full = StringTrimLeft( $input, StringLen($FOR_statement)+1)
		local $exp1 = StringSplit( $full, $FOR_intermediate, 1)
		local $exp2 = StringSplit( $exp1[2], $FOR_intermediate2, 1)
		if $exp2[0] < 2 then ;FOr the case where Step is omitted
			ReDim $exp2[3]
			$exp2[2] = " 1"
		EndIf
		local $exp3 = $exp2[2]
		return $FOR_statement & " (" & Expression_remove_whitespace( $exp1[1]) & ") " & $FOR_intermediate & " (" & Expression_remove_whitespace( $exp2[1]) & ") " & $FOR_intermediate2 & " (" & $exp3 & ")"
	EndIf

	return $input
EndFunc

;Worker for conditional expression - Capitalize all but strings.
Func Expression_Capitalise( $input)
	local $Is_In_String = False
	local $string_Boundary
	local $return = ""
	local $split = StringSplit( $input, "")

	For $letter = 1 to $split[0] step 1
		if not $Is_In_String Then
			for $f = 0 to UBound( $String_Identifiers)-1 step 1
				if $split[$letter] = $String_Identifiers[$f] Then
					$Is_In_String = True
					$string_Boundary = $String_Identifiers[$f]
				EndIf
			Next
		Else
			if $split[$letter] = $string_Boundary Then
				$Is_In_String = False
			EndIf
		EndIf
		if not $Is_In_String Then
			$return &= StringUpper($split[$letter])
		Else
			$return &= $split[$letter]
		EndIf
		;ConsoleWrite( "-"&$Is_In_String)
	Next
	return $return
EndFunc

;worker for conditional expression function - remove whitespace for all but strings.
Func Expression_remove_whitespace( $input)
	local $Is_In_String = False
	local $string_Boundary
	local $return = ""
	local $split = StringSplit( $input, "")

	For $letter = 1 to $split[0] step 1
		if not $Is_In_String Then
			for $f = 0 to UBound( $String_Identifiers)-1 step 1
				if $split[$letter] = $String_Identifiers[$f] Then
					$Is_In_String = True
					$string_Boundary = $String_Identifiers[$f]
				EndIf
			Next
		Else
			if $split[$letter] = $string_Boundary Then
				$Is_In_String = False
			EndIf
		EndIf
		if not $Is_In_String Then
			if Asc($split[$letter]) <> 32 Then
				$return &= $split[$letter]
			EndIf
		Else
			$return &= $split[$letter]
		EndIf
		;ConsoleWrite( "-"&$Is_In_String)
	Next
	if Asc(StringLeft( $return, 1)) = 32 then $return = StringTrimLeft( $return, 1)
	return $return
EndFunc


;==================For some reason _FileReadToArray fails in a recursive function.
;==========================So I wrote my own.

Func Robust_File_Read_To_Array( $filepath)
	local $array[1]
	$array[0] = 0
	local $filehnd = FileOpen( $filepath)
	While True
		$line = FileReadLine($filehnd)
		if @error <> -1 Then
			ReDim $array[UBound( $array)+1]
			$array[0] += 1
			$array[UBound( $array)-1] = $line
		Else
			FileClose( $filehnd)
			return $array
		EndIf
	WEnd
	FileClose( $filehnd)
	return $array
EndFunc

