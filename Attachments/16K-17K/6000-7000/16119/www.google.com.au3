#include <GuiConstants.au3>
#include <file.au3>
#include <IE.au3>

Dim $aRecords, $bRecords, $cRecords
If Not _FileReadToArray(@ScriptDir & "\A.txt", $aRecords) Then
MsgBox(4096, "Error", " Error reading A.txt log to Array error:" & @error)
Exit
EndIf

If Not _FileReadToArray(@ScriptDir & "\B.txt", $bRecords) Then
MsgBox(4096, "Error", " Error reading B.txt log to Array error:" & @error)
Exit
EndIf

If Not _FileReadToArray(@ScriptDir & "\C.txt", $cRecords) Then
MsgBox(4096, "Error", " Error reading C.txt log to Array error:" & @error)
Exit
EndIf


$sText = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\", "Window Title")
$oIE = _IEAttach($sText, "WindowTitle")


$MyMessage = $aRecords[Random(1, UBound($aRecords) - 1, 1) ] & $bRecords[Random(1, UBound($bRecords) - 1, 1) ] & $cRecords[Random(1, UBound($cRecords) - 1, 1) ]
$sPage = "<HTML><HEAD></HEAD><BODY>" & "                                                                                                         " & $MyMessage & "</BODY></HTML>"
_IEDocWriteHTML($oIE, $sPage)
sleep (1000)
_IENavigate($oIE, "http:\\www.google.com")




