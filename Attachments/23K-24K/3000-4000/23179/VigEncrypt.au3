#include <Array.au3>
$Alphabet = stringsplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ","")
_ArrayDelete($Alphabet, 0)
Global $VigCypher[26][26]
For $i = 0 to 25
	Global $icopy = $i
	VigFill($i)
Next
Func VigFill($offset)
	Dim $res[26]
	For $a = 0 to 25
		$VigCypher[$icopy][$a] = $Alphabet[Mod($a+$offset,26)]
	Next
EndFunc

$KeyWord = StringUpper(InputBox("keyword","keyword please"))
$File = FileOpenDialog("select file to encrypt...","C;\","txt (*.txt)")
$Text = FileRead($file)
MsgBox(0,"text",$Text)
$Text = StringRegExpReplace(StringUpper(StringStripCR($Text)),"[^:ABCDEFGHIJKLMNOPQRSTUVWXYZ:]","")
$a = 1
MsgBox(0,"text",$Text)
$EncryptText=""
While $a<StringLen($Text)
	For $i = 1 to StringLen($KeyWord)
		$KeyPlace = _ArraySearch($Alphabet,StringMid($KeyWord,$i,1))
		$TextPlace = _ArraySearch($Alphabet,StringMid($Text,$a,1))
		$EncryptText = $EncryptText&$VigCypher[$Keyplace][$TextPlace]
		$a+=1
	Next
WEnd
MsgBox(0,"",$EncryptText)
ClipPut($EncryptText)
MsgBox(0,"","Encrypted Text added to clipboard")
