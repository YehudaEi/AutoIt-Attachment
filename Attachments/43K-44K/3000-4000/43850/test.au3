#include <array.au3>
#include <XMLDomWrapper.au3>

Global Const $sConfigFile = @ScriptDir & "\test.xml"
If Not FileExists($sConfigFile) Then
	$sErrorMsg = "Configuration File FolderMenu.xml Does Not Exist." & @LF & "Default Configuration File Is Used." & @LF
	MsgBox(4096, "", $sErrorMsg)
EndIf
If _XMLFileOpen($sConfigFile) = -1 Then
	$sErrorMsg &= "Error opening " & $sConfigFile & "."
	MsgBox(4096, "", $sErrorMsg)
EndIf

Global $a_Names[1]
Global $a_Values[1]

$a_Return = _XMLGetAllAttrib("SysSettings/SystemSpecific/MODEL/NICPowerSettings", $a_Names, $a_Values, "Setting")

If @error = -1 Then
	MsgBox(4096, "Error", $a_Return)
Else
	_ArrayDisplay($a_Names, "Names")
	_ArrayDisplay($a_Values, "Values")
EndIf