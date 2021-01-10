#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
$one = 1
$code = '-'&$one
$to = 1

$return = _GetCommonFactors(-8, 15)
if IsArray($return) then
	msgbox(0, 'Result:', $return[1]&' and '&$return[2]&@CRLF&'because:'&@CRLF&$return[1]&'+'&$return[2]&'='&$return[1]+$return[2]&@CRLF&$return[1]&'*'&$return[2]&'='&$return[1]*$return[2])
EndIf
Func _GetCommonFactors($nNumber1, $nNumber2)
	local $ret[3]
	$ret[0] = 2
	$number = _R($nNumber2)
	$negative = Number('-'&$number)
	$positive = Number($number)
	For $1 = $negative to $positive
		For $2 = $negative to $positive
			if _M($1) and _M($2) then
				$op1 = $1 - _R($2)
				$op2 = $1 * $2
			Else
				$op1 = $1 + $2
				$op2 = $1 * $2
			EndIf
			if $op1 = $nNumber1 and $op2 = $nNumber2 then
				$ret[1] = $1
				$ret[2] = $2
				return $ret
			EndIf
		Next
	Next
EndFunc

Func _R($number)
	return StringReplace($number, '-', '')
EndFunc

Func _M($number)
	return StringInStr($number, '-')
EndFunc