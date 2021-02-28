#include <IE.au3>

$oIE = _IECreate("http://www.google.nl", 0, 1, 0, 1)
_IELoadWait($oIE, 250)
$sHTML = _IEBodyReadHTML($oIE)
If $sHTML = 0 Then
	MsgBox(16, "Error", "Could not read HTML output for google")
	Exit
EndIf
ConsoleWrite($oIE)
