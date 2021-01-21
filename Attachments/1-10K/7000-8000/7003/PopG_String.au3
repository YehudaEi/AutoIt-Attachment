; PopG_String.au3 - Andy Swarbrick (c) 2005-6 - Extends String functionality
#Region		Doc:
#Region		Doc: Notes
; Extends String functionality
; You may ask, "Why write _StringBegins when there is StringLeft?"  The answer is that _StringBegins makes straighforward and frequent comparison easy and accessible.
; You are allowed to freely use this code without restriction.
#EndRegion	Doc: Notes
#Region		Doc: Requirements
; Requires Au3 build 3.1.1.109 or better
; Uses the array and string include libraries.
#EndRegion	Doc: Requirements
#Region		Doc: Function list
; _StringBegins							Returns true if a string begins with the substring
; _StringInsert2						Extends StringInsert to be able to repeat the inserts at every n'th position.
; _StringInStrCount						Returns the number of occurences of a subscrting
; _StringReplaceRepeat					Extends StringReplace to repeatedly replace while more occurences are found.
; _StringShowCtrlChars					Returns string with control characters replaced with a visual representation.
; _StringSplit2							Splits a string in two parts, separated by the specified delimeter.
#EndRegion	Doc: Function list
#Region		Doc: History
; 19-Feb-06 Als Added	_StringBegins
; 18-Feb-06 Als Updated	_StringShowCtrlChars and added optional args $Format, $Before and $After.
; 06-Feb-06 Als Added	_StringInStrCount
; 16-Jan-06 Als Updated	_StringSplit2: 	$OkLast functionality to added
#EndRegion	Doc: History
#EndRegion	Doc:
#Region		Init:
#Region		Init: Includes
	#include-once
	#include <array.au3>
	#include <string.au3>
#EndRegion	Init: Includes
#Region		Init: Autoit Options
	#NoTrayIcon
	Opt ('MustDeclareVars', True)
#EndRegion	Init: Autoit Options
#EndRegion	Init:
#Region		Run:
#Region		Run: Test Harness
#Region		Run: Test _StringSplit2
;~ 	Local $l,$r,$s,$o
;~ 	$s='A'
;~ 	$d='|'
;~ 	$o=1
;~ 	_StringSplit2($s,$d,$l,$r,$o)
;~ 	MsgBox(0,'_StringSplit2 test','Left='&$l&@LF&'Right='&$r)
;~ 	Exit
#EndRegion	Run: Test _StringSplit2
#EndRegion	Run: Test Harness
#Region		Run: Functions
; _StringInsert2						Extends StringInsert to be able to repeat the inserts at every n'th position.
;
; Notes:
; Familiarise yourself with StringInsert before using this function.
;
; Parameters:
; $Str				The string in which the insert is to take place
; $Ins				The string to be inserted.
; $Pos				The position at which the insert is to happen.
; $Occur			The number of occurences to be replaced.
;
; @error=1			If $Str is blank.
; @error=2			If $Ins is blank.
; @error=3			If $Pos is negative.
; @error=4			If $Occur is negative.
Func _StringInsert2($Str,$Ins,$Pos,$Occur=1)
	Local $res=$Str
	Local $idx
	Local $len=StringLen($res)
	Local $arr[1]
	;
	If $Str='' Then 
		SetError(1)
		Return $res
	EndIf
	If $Ins='' Then 
		SetError(2)
		Return $res
	EndIf
	If $Pos<=0 Then ; $Pos>$len is not an error since $len is probably variable.
		SetError(3)
		Return $res
	EndIf
	If $Occur<=0 Then 
		SetError(4)
		Return $res
	EndIf
	;
	;Build an array of insert positions, counting forwards
	For $idx=$Pos to $len Step $Pos
		If $idx>$len Or $idx>$Occur Then ExitLoop
		ReDim $arr[UBound($arr)+1]
		$arr[UBound($arr)]=$idx
	Next
	$arr[0]=UBound($arr)-1
	;
	; and now work backwards.
	For $idx=$arr[0] to 1 Step -1
		$res=_StringInsert($res,$Ins,$arr[$idx])
	Next
	Return $res
EndFunc
; _StringSplit2							Splits a string in two parts, separated by the specified delimiter.
;
; Notes:
; Optionally you can select an occurance of the delimiter, use negative numbers to specify the occurance working from right to left.  So -1 splits at the last occurance.
;
; Parameters:
; $String				The string to be split
;
; History:
; 16-Jan-06 Als Updated	_StringSplit2: 	$OkLast functionality to added
Func _StringSplit2($String,$Dlm,ByRef $Left,ByRef $Right,$Occur=1)
	Local $idx,$Split,$DlmL,$DlmR
	If $Occur=0 Then $Occur=1	; default
	$Split=StringSplit($String,$dlm)
	If $Occur<0 Then $Occur=$Split[0]+$Occur
	If $Occur>$Split[0] Then $Occur=$Split[0]-1
	$Left=''
	$Right=''
	$DlmL=''
	$DlmR=''
	For $idx=1 To $Split[0]
		If $idx<=$Occur Then
			$Left=$Left&$DlmL&$Split[$idx]
			$DlmL=$dlm
		Else
			$Right=$Right&$DlmR&$Split[$idx]
			$DlmR=$dlm
		EndIf
	Next
EndFunc ; _StringSplit2
; _StringInStrCount						Returns the number of occurences of a subscrting
;
; Notes:
; Similar syntax to StringInStr.  We recommend you familiarlise yourself with StringInStr before using this function.
;
; Parameters:
; $String				The string that is to be searched.
; $Substring			The string to be found.
; $CaseSense			Whether a case-sensitive search is to be used.
Func _StringInStrCount($String,$Substring,$CaseSense=0)
	$Occur=1
	While True
		If StringInStr($String,$Substring,$CaseSense,$Occur)=0 Then Return $Occur-1
		$Occur=$Occur+1
	WEnd
EndFunc ; _StringInStrCount
; _StringBegins							Returns true if a string begins with the substring
;
; Parameters:
; $String
; $SubString
; $CaseSense
;
; History:
; 19-Feb-06 Als Added	_StringBegins
Func _StringBegins($String,$Substring,$CaseSense=False)
	Local $StrLen=StringLen($Substring)
	If $CaseSense Then
		Return StringLeft($String,$StrLen)==$Substring		; double == implies case-sensitive test
	Else
		Return StringLeft($String,$StrLen)=$Substring		; single = implies case-insensitive test
	EndIf
EndFunc ; _StringBegins
; _StringReplaceRepeat				Extends StringReplace to repeatedly replace while more occurences are found.
;
; Notes:
; We recommend you familiarise yourself with function StringReplace first.
;
; Examples:
; _StringReplaceRepeat('fred000jim','0','') returns 'fredjim', effectively stripping 0's from the string.
;
; Parameters:
; $String				The string in which the replacement is to occur.
; $OldStr				The old string that is to be searched for.
; $NewStr				The new string that is to be inserted instead.
; $CaseSense			Whether the search is to be case-sensitive. 1/True=sensitive, 0/False=insensitive (default).
;
; Results:
; Returns the replaced string.  If no replacements are possible the original string is returned.
;
; History:
; 18-Feb-03 Als Added	_StringReplaceRepeat
Func _StringReplaceRepeat($String,$OldStr,$NewStr,$CaseSense=False)
	Do
		$String=StringReplace($String,$OldStr,$NewStr,0,$CaseSense)
	Until @extended=0
	Return $String
EndFunc
; _StringShowCtrlChars					Returns string with control characters replaced with a visual representation.
;
; Notes:
; This function can be useful for discovering hidden characters such as line-feeds & tabs.
;
; Parameters:
; $String					The string in which you wish to discover characters.
; $Format					How the discovered strings are to be shown.  1=Ascii number (Default).
; $Before					a prefix that should appear before any discovered characters.  Defaults to '{asc'.
; $After					a suffix that should appear after any discovered characters.  Defaults to '}'.
;
; History:
; 18-Feb-06 Als Updated	_StringShowCtrlChars and added optional args $Format, $Before and $After.
Func _StringShowCtrlChars($String, $Format=1,$Before='{asc',$After='}')
	Local $sccIdx,$sccInChr,$sccOutChr,$sccOutStr,$AscChr
	$sccOutStr= ''
	For $sccIdx=1 to StringLen($String)
		$sccInChr=StringMid($String, $sccIdx, 1)
		$sccOutChr=$sccInChr
		$AscChr=Asc($sccInChr)
		If $AscChr<32 Or $AscChr>126 Then $sccOutChr=$AscChr
		If $sccOutChr<>$sccInChr then
			If $Format=1 Then
				$sccOutStr= $sccOutStr & $Before&$sccOutChr&$After
			EndIf
		Else
			$sccOutStr= $sccOutStr & $sccInChr
		EndIF
	Next
	Return $sccOutStr
EndFunc ; _StringShowCtrlChars
#EndRegion	Run: Functions
#EndRegion	Run:
