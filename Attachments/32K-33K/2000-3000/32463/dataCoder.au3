;REQUIRE: _ZIP.au3

#include <_zip.au3>
#Include <Crypt.au3>

_ZIP_Create("dataTemp.zip");
_ZIP_AddFile(@ScriptDir&"\dataTemp.zip", @ScriptDir&"\bg.jpg", 0);
_ZIP_AddFile(@ScriptDir&"\dataTemp.zip", @ScriptDir&"\transparent.gif", 0);
MsgBox(0,"","DONE");