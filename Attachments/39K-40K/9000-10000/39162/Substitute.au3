#include <String.au3>
#include <Array.au3>

Local $text

$text = FileRead("Super.au3")

FileDelete("c:\sera.txt")
_Go()

Func _Go()
$aArray1 =  _StringBetween($text, '"', '"')
$total = UBound($aArray1, 1) -1
$count = 0
$text2 = $text


For $count = 0 To $total
$varText = $aArray1[$count]


$toEncrypt = _StringEncrypt(1, $varText, "thi", 1)

$toDecryptText = "_StringEncrypt(0, " & "'" & $toEncrypt &  "'" & ", 'thi', 1)"

$text2 = StringReplace($text2, $varText, $toDecryptText)
;~ MsgBox(0,"", $varText)

$Count = $Count + 1

FileDelete("c:\sera.txt")
FileWrite("c:\sera.txt", $text2)

Sleep(100)
Next



EndFunc