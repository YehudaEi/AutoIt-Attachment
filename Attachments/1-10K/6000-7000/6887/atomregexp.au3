$line1 = 'Atom "©nam" contains: Title'
$line2 = 'Atom "tvsh" contains: TV Show'
$line3 = 'Atom "stik" contains: Movie'
$line4 = 'Atom "©alb" contains: Album'
;The easiest way I can see to do this, is if these lines are returned in a file, just FileReadLine, and parse line by line

$pattern = '(?:Atom ")(.+)(?:" contains: )(.+)'
$display = ""

$display &= StripVars($line1,$pattern)
$display &= StripVars($line2,$pattern)
$display &= StripVars($line3,$pattern)
$display &= StripVars($line4,$pattern)

MsgBox(0,"Results", $display)

Func StripVars($line, $pattern)
	$result = StringRegExp($line, $pattern, 1) ;Flag 1 returns any matching groups in an array
	If IsArray($result) Then
		Return "Var="&$result[0]&" Data="&$result[1]&@CRLF
	EndIf
EndFunc