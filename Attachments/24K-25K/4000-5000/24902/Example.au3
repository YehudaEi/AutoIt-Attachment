#include "FAF Archiver.au3"

$faf = _FAF_OpenArchive("test.faf")

$index = _FAF_ReadArchiveIndex($faf)

$string = "The archive contains the following files: " & @CRLF

For $i = 0 To UBound($index) - 1
	$string &= $index[$i][0] & " (ID=" & $index[$i][3] & ")" & @CRLF
Next
$string &= "Press ok to extract them in script dir now."
$answer = MsgBox(1, "Archive content", $string)
If $answer = 1 Then
	For $i = 0 To UBound($index) - 1
		_FAF_ExtractFile($faf, $index[$i][3], $index[$i][0])
	Next

EndIf


_FAF_CloseArchive($faf)
