;REQUIRE: _ZIP.au3

#include <_zip.au3>
#Include <Crypt.au3>


$zipPath=@ScriptDir&"\dataTemp.zip";
$desPath=@ScriptDir&"\data";
;MsgBox(0,"", "Extract "&$zipPath&" to folder "&$desPath);
$ss=_Zip_Unzip($zipPath, "bg.jpg", $desPath, 1);
MsgBox(0,"",$ss);
MsgBox(0,"",@error);