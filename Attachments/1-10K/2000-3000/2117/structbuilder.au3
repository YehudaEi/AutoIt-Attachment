#cs
	UDFs to help ease the creation of the strings for use w/ DllStructCreate
#ce

_DllStructTutorial("int;char[128];ptr")

Func _DllStructTutorial($struct_str)
	Local $p,$s="",$i,$split,$split2,$s2=""
	
	;create the struct
	$p = DllStructCreate($struct_str)
	if @error Then
		MsgBox(0,"Bad Start","Not a good start, error in DllStructCreate()")
		Return
	EndIf

	$s	= "Create the struct with:" & @CRLF
	$s	&= "$p" & @tab & '= DllStructCreate("' & $struct_str & '")' & @CRLF & @CRLF

	$s	&= "Use the struct in DllCall with:" & @CRLF & "$return" & @tab & '= DllCall("SomeDll.dll","int","FuncName","ptr",DllStructPtr($p))' & @CRLF & @CRLF
	
	;Display some info about the struct
	$s	&= "Your struct in C looks like:" & @CRLF & "{" & @CRLF

	$split	= StringSplit($struct_str,";")

	For $i = 1 To $split[0]
		$split2	= StringSplit($split[$i],"[")
		if $split2[0] > 1 Then ;array
			$s	&= @tab & $split2[1] & @tab & "Variable" & $i & "[" & $split2[2] & ";" & @CRLF
		Else
			$s	&= @tab & $split[$i] & @tab & "Variable" & $i & ";" & @CRLF
		EndIf

		if $split[$i] = "ptr" Then
			$s	&= "//or" & @tab & "DATA" & @tab & "*Variable" & $i & ";" & @CRLF
			$s	&= "//or" & @tab & "LPXXX" & @tab & "Variable" & $i & ";" & @CRLF
		EndIf
	Next
	$s	&= "}" & @CRLF & @CRLF

	$s &= "Get the elements of the struct with:" & @CRLF
	For $i = 1 To $split[0]
		$split2	= StringSplit($split[$i],"[")
		if $split2[0] > 1 Then ;array
			$s	&= "$Variable" & $i & "_1" & @tab & "= DllStructGet($p," & $i & ",1)" & @CRLF
			$s	&= "$Variable" & $i & "_" & StringLeft($split2[2],StringLen($split2[2])-1) & @tab & "= DllStructGet($p," & $i & "," & StringLeft($split2[2],StringLen($split2[2])-1) & ")" & @CRLF
		Else
			$s	&= "$Variable" & $i & @tab & "= DllStructGet($p," & $i & ")" & @CRLF
		EndIf

		If $split2[0] > 1 And $split2[1] = "char" Then
			$s	&= "$Variable" & $i & @tab & "= DllStructGet($p," & $i & ");String" & @CRLF
		EndIf
	Next
	$s	&= @CRLF

	$s	&= "Set the elements of the struct with:" & @CRLF
	For $i = 1 To $split[0]
		$split2	= StringSplit($split[$i],"[")
		if $split2[0] > 1 Then ;array
			$s	&= "DllStructSet($p," & $i & ",$data,1)" & @CRLF
			$s	&= "DllStructSet($p," & $i & ",$data," & StringLeft($split2[2],StringLen($split2[2])-1) & ")" & @CRLF
		Else
			$s	&= "DllStructSet($p," & $i & ",$data)" & @CRLF
		EndIf

		If $split2[0] > 1 And $split2[1] = "char" Then
			$s	&= "DllStructSet($p," & $i & ",$data);String" & @CRLF
		EndIf

		If $split2[1] = "ptr" Then
			$s	&= "DllStructSet($p," & $i & ",DllStructPtr($anotherstruct))" & @CRLF
		EndIf

	Next


	MsgBox(0,"The struct",$s)

	DllStructFree($p)
EndFunc

