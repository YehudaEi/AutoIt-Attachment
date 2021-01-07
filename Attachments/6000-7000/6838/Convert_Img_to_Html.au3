#include "_Base64.au3"

$file = FileOpenDialog("Base64 Image Encoder", "", "Images (*.png;*.gif;*.jpg;*.jpeg;*.bmp;*tif;*.tiff)", 1)
If @error Then Exit

$type = StringSplit($file, ".")
$name = StringSplit($type[$type[0] - 1], "\")
$name = $name[$name[0]]
$type = $type[$type[0]]

$fsize = FileGetSize($file)
$filehand = FileOpen($file, 0)
$tmp = _Base64Encode((FileRead($filehand,$fsize)))

$out = '<img src="data:image/' & $type & ';base64,' & $tmp & '"/>'

$loc = StringReplace($file, $name & "." & $type, "") & $name & "[" & $type & "].htm"
FileWrite($loc, $out)
Do
	FileDelete($tmp)
Until not FileExists($tmp)
MsgBox(0, "Done!", "File has been converted and saved as:" & @CRLF & @CRLF & $loc)