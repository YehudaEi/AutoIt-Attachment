#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<file.au3>
#include<array.au3>
#include<string.au3>
#include<Misc.au3>
#include<build_overrides.au3>
;Written by Hyperzap.
;Credit to whoever wrote the last function. Could be any/all - Rob Saunders/JPM/strik3r0475/erebus


;This script builds the interpreter script to handle dynamic (buitin function) calling.
;It should be re-run everytime the Autoit interpreter is updated/version changes.
;You will need a decompiled version of the helpfile. Decompile to this folder.
global $filearr
global $errors[1][3]
global $writehnd = FileOpen( @ScriptDir & "/../Auto_interpreter_funcs.au3", 2)




ConsoleWrite("Autoit Dynamic Function Generator - (c) 2011" & @CRLF)
ConsoleWrite("Coded by: Hyperzap" & @CRLF&@CRLF)


DirRemove( @ScriptDir & "/build")
sleep(2000)

DirCreate( @ScriptDir & "/build")
$output = FileGetShortName( @ScriptDir & "/build")
Global $s_Au3Path = RegRead64('HKLM\Software\AutoIt v3\AutoIt', 'InstallDir')
$input = FileGetShortName( $s_Au3Path & "/AutoIt3.chm")
ConsoleWrite("Preparing to Decompile Parameter Information from: " & $s_Au3Path & @CRLF)
ConsoleWrite("Output: /../Auto_interpreter_funcs.au3"& @CRLF&@CRLF)


if not FileExists($s_Au3Path & "/AutoIt3.chm") Then
	ConsoleWrite(@CRLF & "ERROR: Cannot find Autoit Helpfile to build from." & @CRLF)
	sleep(7000)
	Exit
EndIf

if FileExists(@HomeDrive & "/Windows/hh.exe") Then
	RunWait( @HomeDrive & "/Windows/hh.exe -decompile " & $output & " " & $input)
Elseif FileExists(@HomeDrive & "/WIN/hh.exe") Then
	RunWait( @HomeDrive & "/WIN/hh.exe -decompile " & $output & " " & $input)
Elseif FileExists(@HomeDrive & "/hh.exe") Then
	RunWait( @HomeDrive & "/hh.exe -decompile " & $output & " " & $input)
Else
	ConsoleWrite(@CRLF & "ERROR: Cannot find Builtin CHM decompiler." & @CRLF)
		sleep(7000)
	Exit
EndIf





$filearr = _FileListToArray( @ScriptDir & "\build\html\functions", "*.htm")

Sleep(3000)
for $x = 1 to $filearr[0] step 1
	global $filecontents
	$filecontents = FileRead( @ScriptDir & "\build\html\functions\" & $filearr[$x], 8000)
	;ConsoleWrite($filecontents)
	$inside = StringInStr($filecontents, '<p class="codeheader">')

	if $inside > 0 then
		$outside = StringMid( $filecontents, $inside, StringInStr(StringTrimLeft( $filecontents, $inside), '</p>'))
		if StringRight($outside, 4) = "<br>" then $outside = StringTrimRight($outside, 4)
		if StringRight($outside, 2) = @CRLF then $outside = StringTrimRight($outside, 2)
		if StringRight($outside, 4) = "<br>" then $outside = StringTrimRight($outside, 4)
		if StringLeft($outside, 22) = '<p class="codeheader">' then $outside = StringTrimLeft($outside, 22)
		if StringLeft($outside, 2) = @CRLF then $outside = StringTrimLeft($outside, 2)
		$outside = StringReplace( $outside, '"', "")
		$outside = StringReplace( $outside, "'", "")
		ConsoleWrite( "=> Building Dynamic Function for: " & StringTrimRight($filearr[$x], 4) & @CRLF)
		$paramstring = StringSplit($outside, "(")

		$param_table_locate = StringInStr($filecontents, '<table border="1" width="100%" cellspacing="0" cellpadding="3" bordercolor="#C0C0C0">')
		$param_table_end = StringInStr(StringTrimLeft( $filecontents, $param_table_locate), '</table>')
		$table = StringMid( $filecontents, $param_table_locate, $param_table_end)
		$params = StringSplit( $table, "<tr>", 1)

		;ConsoleWrite("PARSE: " & $params[0] & " - " & $table & " - " & $param_table_locate & " - " & $param_table_end)


		dim $params2[1][2]
		FOr $d = 2 to $params[0] step 1 ;Finder + parser for the parameters table.
			$parameter = _StringBetween( $params[$d], '<td width="15%">', '</td>', True)
			$description = _StringBetween( $params[$d], '<td width="85%">', '</td>', True)
			if IsArray($description) and IsArray($parameter) then ;If its a valid description of the parameter.
				ReDim $params2[UBound( $params2)+1][2]
				$params2[0][0] = UBound( $params2)-1
				$params2[UBound( $params2)-1][0] = $description[0]
				$params2[UBound( $params2)-1][1] = $parameter[0]
			Else
				$parameter = _StringBetween( $params[$d], '<td>', '</td>', True)
				if IsArray($parameter) Then
					$description = _StringBetween( StringTrimLeft($params[$d], StringLen($parameter[0])+8), '<td>', '</td>', True)
					if IsArray($description) then ;If its a valid description of the parameter.
						ReDim $params2[UBound( $params2)+1][2]
						$params2[0][0] = UBound( $params2)-1
						$params2[UBound( $params2)-1][0] = $description[0]
						$params2[UBound( $params2)-1][1] = $parameter[0]
					endif
				EndIf
			EndIf
		next
		Generate_Autoit_Function( StringTrimRight($filearr[$x], 4), $params2)
	EndIf
Next

sleep(1000) ;Gotta wait for some reason.
DirRemove( @ScriptDir & "/build")

Build_Message()

ConsoleWrite( @CRLF & @CRLF & "-------- ERRORS: -----------------------" & @CRLF)
	for $f = 1 to UBound($errors)-1 step 1
		ConsoleWrite( "= " & $errors[$f][0] & "> " & $errors[$f][1] &  @CRLF & " ---->" & $errors[$f][2] & @CRLF)
	Next
ConsoleWrite( @CRLF & "Build Completed Successfully. Press <Enter> to exit.")

While not _IsPressed("0D")
	sleep(70)
WEnd





Func Generate_Autoit_Function( $name, $paramarray)
	local $used_param_names[1]
	$used_param_names[0] = "fgbslbksj;klbj,mneobiu lj;lkjerg;ljk";something that wont be a function.
	local $paramstr = "("

	for $a = 0 to UBound( $function_Overrides)-1 step 1
		if StringUpper($name) = StringUpper($function_Overrides[$a]) then
			FileWrite( $writehnd, Call( "Return_" & StringUpper($function_Overrides[$a])) & @CRLF & @CRLF)
			Return
		EndIf
	Next

	for $r = 1 to $paramarray[0][0] step 1
		;Make sure we dont have two parameters to the same name/variable.
		for $e = 0 to UBound( $used_param_names)-1 step 1
			if $paramarray[$r][1] = $used_param_names[$e] Then
				ConsoleWrite(@CRLF & "!> Variable Overlap - Performing Reassignment." & @CRLF)
				while Check_Is_in_list( $used_param_names, $paramarray[$r][1])
					$paramarray[$r][1] = $paramarray[$r][1] & "_"
				WEnd
				ExitLoop
			EndIf
		Next

		if $paramarray[$r][1] = "" or $paramarray[$r][1] = " " Then
			_ArrayDelete($paramarray, $r)
			$paramarray[0][0] -= 1
			if $r =	$paramarray[0][0] then ;The bounds are changing so for loop doesnt work. Must check manually.
				if $r = UBound($paramarray)-1 then ExitLoop
			EndIf
			ContinueLoop
		EndIf

		ReDim $used_param_names[Ubound($used_param_names)+1]
		$used_param_names[Ubound($used_param_names)-1] = $paramarray[$r][1]

		if StringLeft( StringUpper($paramarray[$r][1]), StringUpper("BYREF")) = "BYREF" Then
			Register_Error(3, $name&" : "&$paramarray[$r][1], "Unable to Process Expression. BYREF is not yet supported.")
			Return
		EndIf

		If StringInStr( $paramarray[$r][1], "...") > 0 Then
			Register_Error(4, $name&" : "&$paramarray[$r][1], "Unable to Process Expression. Operation not supported.")
			Return
		EndIf
		$paramarray[$r][1] = StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(Expression_remove_whitespace( $paramarray[$r][1]),"$",""),":",""),'"',""),"'",""),"/",""),"-",""),"+",""),",",""),";",""),"&","")
		$paramstr &= " $" & $paramarray[$r][1]
		if StringInStr( $paramarray[$r][0], "<b>[optional]</b>") > 0 Then $paramstr &= "=Default"
		$paramstr &= ","
		if $r >= $paramarray[0][0] then ;The bounds are changing so for loop doesnt work. Must check manually.
			ExitLoop
		EndIf
	Next
	if $paramarray[0][0] > 0 then $paramstr = StringTrimRight( $paramstr, 1)
	$paramstr &= ")"
	FileWrite( $writehnd, "Func _DynEXEC_" & StringUpper($name) & $paramstr &  @CRLF)
	FileWrite( $writehnd, @TAB & "local $ret = " & StringUpper($name) & "(")
	for $t = 1 to $paramarray[0][0] step 1
		FileWrite( $writehnd, "$" & $paramarray[$t][1])
		if $t <> $paramarray[0][0] then FileWrite( $writehnd, ",")
	Next
	FileWrite( $writehnd, ")"& @CRLF)
	FileWrite( $writehnd, @TAB&"SetError(@error,@extended)"&@CRLF)
	FileWrite( $writehnd, @TAB&"Return $ret" & @CRLF)
	FileWrite( $writehnd, "Endfunc"&@CRLF&@CRLF)
	;ConsoleWrite( "Func _DynEXEC_" & StringUpper($name) & $paramstr&@CRLF)
EndFunc


Func Check_Is_in_list( $list, $item)
	for $e = 0 to UBound( $list)-1 step 1
		if $item = $list[$e] Then
			return True
			ExitLoop
		EndIf
	Next
	return False
EndFunc

Func Register_Error($code, $function, $description)
	redim $errors[UBound($errors)+1][3]
	$errors[UBound($errors)-1][0] = $code
	$errors[UBound($errors)-1][1] = $function
	$errors[UBound($errors)-1][2] = $description
	ConsoleWrite(@CRLF & "!> Generation Error!" &@CRLF&"=>Code: " & $code &@CRLF& "=> In: " & $function & @CRLF&"=>" & $description & @CRLF& @CRLF)
EndFunc

Func Build_Message()
	FileClose($writehnd)
	local $aTemp
	_FileReadToArray( @ScriptDir & "/../Auto_interpreter_funcs.au3", $aTemp)
	local $writeStr = ";========================================================================================================" & @CRLF & _
	";AUTOIT DYNAMIC SCRIPT GENERATION            		       -    				  BUILT: " & @HOUR & ":" & @MIN & @CRLF & _
	";Build Status: Successful! (No fatal errors were encountered during the build process.)" & @CRLF & ";" & @CRLF & _
	";" & $filearr[0] & " Total Corpora Processed." & @CRLF & _
	";" & UBound($errors)-1 & " Total Errors." & @CRLF & ";" & @CRLF& _
	";---------- GENERATION ERRORS: --------------------------------------------------------------------------" & @CRLF
	for $f = 1 to UBound($errors)-1 step 1
		$writeStr &= ";= " & $errors[$f][0] & "> " & $errors[$f][1] & " - " & $errors[$f][2] & @CRLF
	Next
	$writeStr &= ";========================================================================================================" & @CRLF & @CRLF

	local $filehnd = FileOpen( @ScriptDir & "/../Auto_interpreter_funcs.au3", 2)

	FileWrite( $filehnd, $writeStr)

	for $s = 1 to $aTemp[0] step 1
		FileWrite( $filehnd, $aTemp[$s] & @CRLF)
	Next

	FileClose($filehnd)
EndFunc










;Stole it from Autoit Updater.
Func RegRead64($sKeyname, $sValue)
		Local $res = RegRead($sKeyname, $sValue)
		If @error And @AutoItX64 Then
			$sKeyname = StringReplace($sKeyname, "HKEY_LOCAL_MACHINE", "HKLM")
			$sKeyname = StringReplace($sKeyname, "HKLM\SOFTWARE\", "HKLM\SOFTWARE\Wow6432Node\")
			$res = RegRead($sKeyname, $sValue)
			If @error Then
				SetError(1)
				Return ""
			EndIf
		EndIf

	SetError(0)
	Return $res
EndFunc

Func Expression_remove_whitespace( $input)
	local $Is_In_String = False
	local $return = ""
	local $split = StringSplit( $input, "")

	For $letter = 1 to $split[0] step 1

		if not $Is_In_String Then
			if Asc($split[$letter]) = 44 Then
				$return &= $split[$letter]
				$return &= "p"
			elseif Asc($split[$letter]) <> 32 Then
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



#comments-start
Func Generate_Autoit_Function( $name, $paramstring)
	local $param_out = StringTrimRight( Expression_remove_whitespace( StringReplace(StringReplace($paramstring, "[", ""), "]", "")), 1)
	$param_out = StringReplace(StringReplace(StringReplace($param_out, "<i>N</i>", ""), ":", ""), "-", "")
	local $spl = StringSplit( $param_out, ",")
	for $r = 1 to $spl[0] step 1
		if $spl[$r] <> "" Then
			local $sTemp = "$pr"&$spl[$r]
			$spl[$r] = $sTemp
		EndIf
	Next
	$param_out = ""
	for $r = 1 to $spl[0] step 1
		$param_out &= $spl[$r] & ","
	Next
	$param_out = StringTrimRight( $param_out, 1)
	FileWrite( $writehnd, "Func _INTEXEC_" & $name & "(" & $param_out & ")" &  @CRLF)
	FileWrite( $writehnd, "Return " & $name & "(" & $param_out & ")" &  @CRLF)
	FileWrite( $writehnd, "Endfunc" & @CRLF &  @CRLF)
EndFunc
#comments-end