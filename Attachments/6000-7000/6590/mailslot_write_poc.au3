$kernel32 = DllOpen("kernel32.dll")
$ourCall = DllCall($kernel32, "ptr", "CreateFile", _
	"str", "\\.\mailslot\AutoIt3", _
	"int", 0x40000000, _; GENERIC_WRITE
	"int", 1, _; FILE_SHARE_READ
	"ptr", 0, _
	"int", 3, _; OPEN_EXISTING
	"int", 0x80, _; FILE_ATTRIBUTE_NORMAL
	"ptr", 0 );

If Not IsArray($ourCall) Then
   MsgBox(0, "Error", "CreateFile failed...");
EndIf

$ourMailslot = $ourCall[0]

$ourMsg = "Testing, testing..."

$ourCall = DllCall($kernel32, "int", "WriteFile", "ptr", $ourMailslot, "str", $ourMsg, "int", StringLen($ourMsg), "int_ptr", 0, "ptr", 0)

If Not IsArray($ourCall) Then
   MsgBox(0, "Error", "WriteFile failed...")
Else
   MsgBox(0, "Debug", "Slot written to successfully.")
EndIf

DllClose($kernel32)