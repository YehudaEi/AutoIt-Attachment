#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Date.au3>
_NowTime([$sType = 4])
$ID =(_NowTime)
If $ID =="18:00" Then
	run("C:\Program Files\Google\Picasa3\Picasa3.exe")
	Else Sleep(60000)
EndIf
Run("Start-picasa-kl1800.exe")