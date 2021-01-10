#include <String.au3>


$Char="START"
$Char2="END"

$message = "Open File To String."
$file = @ScriptDir & "\Main.bin"
$file = FileOpen($file, 16)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
$String = FileRead($file)
If @error = -1 Then Exit
$Hex = _StringToHex($Char)
$Hex2 = _StringToHex($Char2)

$result = StringInStr($String, $Hex)
$result2 = StringInStr($String, $Hex2)
If ($result = 0 or $result2 = 0)  Then
	MsgBox(0,"NO MATCH","NO MATCH")
	Exit
EndIf
 
$FROM = $result
$TO = $Hex2 + stringlen($Hex2)

; Now I need to copy string from $String (starting from $FROM, ending at $TO) then to save to somefile.




FileClose($file)
