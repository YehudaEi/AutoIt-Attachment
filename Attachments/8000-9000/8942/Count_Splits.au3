
$String="five|ten|three|five|six|ten|five"

$Split=StringSplit($String,"|",0)

$line=""
For $z = 1 to $Split[0]
	$array = StringSplit($String, $Split[$z], 1)
	if Stringinstr($line,$Split[$z]) = 0 then $line=$line & $Split[$z] & " = " & $array[0]-1 & ", "
next

MsgBox(0,"",$line)
