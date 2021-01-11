#Include<ArraySearchPlus.au3>
Dim $Array[6]
$Array[0] = "String0"
$Array[1] = "String1"
$Array[2] = "String2"
$Array[3] = "String3"
$Array[4] = "String4"
$Array[5] = "String5"

$Input = InputBox("ArraySearch Demo", "String To Find?")
$flag = Int(InputBox ("ArraySearch Demo", "Flag?"))
If @error Then Exit

$Pos = _ArraySearchPlus ($Array, $Input, 0, 0, 0, $flag)
Select
    Case $Pos = -1
        MsgBox(0, "Not Found", '"' & $Input & '" was not found in the array.')
    Case Else
        MsgBox(0, "Found", '"' & $Input & '" was found in the array at pos ' & $Pos & ".")
EndSelect