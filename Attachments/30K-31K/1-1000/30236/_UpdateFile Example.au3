#include "_UpdateFile.au3"

$iReturn = _FileUpdate(@DesktopDir & "\Google.gif", "http://www.google.com/intl/en_ALL/images/logo.gif")
If $iReturn = 1 Then $iReturn = "Successful!"
Switch @error
	Case 0
		$sERROR = "No errors!"
	Case 1
		$sERROR = "Invalid first parameter."
	Case 2
		$sERROR = "Invalid second parameter."
	Case 3
		$sERROR = "Could not create Batch file."
	Case 4
		$sERROR = "Could not write to Batch file."
	Case 5
		$sERROR = "Could not run Batch file."
EndSwitch

MsgBox(0, "Return", $iReturn & @CRLF & $sERROR)
