#include <file.au3>
$Nr_linii_t = _FileCountLines("C:\NICE\wav\Administrator_audfiles.txt")
MsgBox(0, "Nr lines in text files is:", $Nr_linii_t)

$Nr_linii=Int($Nr_linii_t/5 )
MsgBox(0, "Nr lines 5 by 5:", $Nr_linii)

$a=1
While $a <= $Nr_linii
	$b=$a*5

MsgBox(0, "Step nr:", $a)
MsgBox(0, "Line nr:", $b)

$file = FileOpen("C:\NICE\wav\Administrator_audfiles.txt", 0)
Sleep(1000)
$line = FileReadLine($file,$b)

$result = StringLeft($line, 35)
$result1=StringStripWS($result, 8)
MsgBox(0, "File to rename:", $result1)

$text = StringReplace($line,":", "-")  ;replace in line 5 chars ':' and '/' with '-' 
$text1 = StringReplace($text,"/", "-")
$text2 = StringStripWS($text1, 8)
MsgBox(0, "The new string is:", $text2)

$x=31
$an=@YEAR
$var = StringMid($text2, $x, 4)
MsgBox(0, "4 chars extracted beginning with the 31st position are:", $var)

while $an<>$var
	$x=$x+1
    $var = StringMid($text2, $x, 4)
WEnd
MsgBox(0, "This year:", $var)


;this year
$y=$x-6
$var_y = StringMid($text2, $y, 10)
MsgBox(0, "Current date:", $var_y)

$data=StringReplace($var_y,"+", " ")
MsgBox(0, "Current date without plus sign:", $data)

;current hour
$w=$x+4
$var_w=StringMid($text2, $w, 8)
$ora1=StringReplace($var_w,"A", " ")
$ora2=StringReplace($ora1,"P", " ")
$ora=StringStripWS($ora2, 8)
MsgBox(0, "Current hour:", $ora)


;Current channel
$char_dr = StringRight($text2, 10)
MsgBox(0, "The last 10 chars are:", $char_dr)
$logger=StringMid($char_dr, 1, 7)

;MsgBox(0, "Final logger is:", $logger)

If $logger=4719604 Then
	$can=StringRight($char_dr, 3)
ElseIf $logger<>4719604 Then
	$can=StringRight($char_dr, 2)
EndIf	

$canal=StringTrimRight($can, 1)

If $canal=1 Then
	$tel=200
ElseIf $canal=2 Then
	$tel=201
ElseIf $canal=3 Then
	$tel=202
ElseIf $canal=4 Then
	$tel=203
ElseIf $canal=5 Then
	$tel=204
ElseIf $canal=6 Then
	$tel=205
ElseIf $canal=7 Then
	$tel=206
ElseIf $canal=8 Then
	$tel=207
ElseIf $canal=9 Then
	$tel=208
ElseIf $canal=10 Then
	$tel=209
ElseIf $canal=11 Then
	$tel=210
ElseIf $canal=12 Then
	$tel=211
ElseIf $canal=13 Then
	$tel=212
ElseIf $canal=14 Then
	$tel=213
ElseIf $canal=15 Then
	$tel=214
ElseIf $canal=16 Then
	$tel=215
EndIf
MsgBox(0, "The phone is:", $tel)

MsgBox(0, "The file have to be renamed:", $data & $ora & $tel)

FileMove($result1 & ".wav", "C:\NICE\wav\" & $data & "_" & $ora &"_" & $tel & "_" & $canal & "_DJ.wav")
Sleep(1000)
FileClose($file)

$a=$a+1
WEnd
MsgBox(0, "The phone is:", "OK")
Exit