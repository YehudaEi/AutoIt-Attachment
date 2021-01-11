
#cs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~                               ;~~           ;~                     ;~
;~ AutoIt Version: 3.2.0.1        ;~~         ;~                     ;~
;~ Author:clearguy               ;~~           ;~~~~~~~~~~~~~~~~~~~~;
;~~                                ;~~~~~~~~~~~~~~~~~~~~~~~~~~;    ;~
;~~ Script Function:                                        ;~~     ;~
;~~	Insert string in a string between all characters         ;~~   ;~
;~~          or in a range of characters.                   ;~~     ;~
#ce~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~     ///// _StringMultiInsert \\\\\\
;~Script Start 
;~~ Example
$String = 'Allseparedwith a slash "/"'
MsgBox(0,"_StringMultiInsert", _StringMultiInsert($String, "/", 1, 14))
;~~
$String = ':::::::::'
MsgBox(0,"_StringMultiInsert", "Bad smileys => "& _StringMultiInsert($String, "/" ))
;~~
$String = 0
_StringMultiInsert($String,"!" )
MsgBox(0,"_StringMultiInsert", "Error 1 : "& @error)
 ;~~Function
Func _StringMultiInsert($s_String, $s_InsertString, $s_StartRange = 0, $s_RangeStop = 0)
	Local $s_NewString, $i_Length, $s_SplitString
	
		If $s_String = "" Or (Not IsString($s_String)) Then
		SetError(1) ;~~ Source string empty / not a string
		Return $s_String
	ElseIf $s_InsertString = "" Or (Not IsString($s_String)) Then
		SetError(2) ;~~ Insert string empty / not a string
		Return $s_String
	Else
		$i_Length = StringLen($s_String) ; Take a note of the length of the source string
		If (Abs($s_StartRange) > $i_Length) Or (Not IsInt($s_StartRange)) Or (Not IsInt($s_RangeStop)) Or ($s_RangeStop > $i_Length) Or ($s_RangeStop < $s_StartRange) Then
			SetError(3) ;~~ Invalid position
			Return $s_String
		EndIf
	EndIf
	
	$i_Length = StringLen($s_String)  ;~~ take string length
	$s_SplitString = StringSplit($s_String, "") ;~~split all chars in string
	
	If $s_StartRange = 0 And $s_RangeStop = 0 Then
		For $i = 1 To $i_Length
			$s_NewString = $s_NewString & $s_SplitString[$i] & $s_InsertString ;~~ simply add InsertString everywhere
		Next
		Return $s_NewString
	ElseIf  $s_StartRange <> 0  Then
		If $s_StartRange > 1 And $s_RangeStop > $s_StartRange Then
			$s_NewString = StringLeft($s_String,$s_StartRange - 1)  ;~~ add clear string before starting the multi-insert
			For $i = $s_StartRange To $s_RangeStop
				$s_NewString = $s_NewString & $s_SplitString[$i] & $s_InsertString ;~~ add InsertString in a range of string
			Next
			$s_NewString = $s_NewString & StringRight($s_String, ($i_Length - $s_RangeStop) ) ;~~ add clear string after multi-insert range
			Return $s_NewString
		ElseIf $s_StartRange = 1 And $s_RangeStop > $s_StartRange Then
			For $i = 1 To $s_RangeStop
				$s_NewString = $s_NewString & $s_SplitString[$i] & $s_InsertString   ;~~ multi-insert since the start
			Next
			$s_NewString = $s_NewString & StringRight($s_String, ($i_Length - $s_RangeStop) ) ;~~ until the range stop
			Return $s_NewString
		EndIf
	EndIf
EndFunc