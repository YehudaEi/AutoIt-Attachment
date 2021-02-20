#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Sleep(2000)
Opt("WinTitleMatchMode", 2)

$var = WinGetTitle("Windows Internet Explorer", "Google")

MsgBox(0, "Test", $var)

Select
	Case $var = "Google Maps - Windows Internet Explorer" ;testing purpose, will use different (constant) URL in my script
		Sleep(10000)
		$var = WinGetTitle("Windows Internet Explorer", "Google")
	Case $var = 0 ;want to be able to identify if it could not find a title, not to just continue
		MsgBox(0, "ERROR!", "No Title Found" & @CRLF & @CRLF & "Error Line 51" & @CRLF & @CRLF & "Retrying in 5 seconds", 10)
		Sleep(10000)
		$var = WinGetTitle("Windows Internet Explorer", "Google")	
	Case Else
		MsgBox(0, "Success!", "Correct page found " & $var)
EndSelect

MsgBox(0, "Final", $var)
