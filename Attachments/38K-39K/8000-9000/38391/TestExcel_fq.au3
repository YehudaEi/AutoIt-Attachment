#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <IE.au3>
#include <Array.au3>
#include <Excel.au3>
#include <File.au3>
#include <Date.au3>

#cs
SHORT SCRIPT TO TRY TO READ THE Fx LINE OF AN EXCEL SHEET
Used the "notepad example" from AutoIt Help as a start
Succeded in writing text to the Fx control line
Have had no success in reading back the text that was written
#ce

#cs
EXAMPLE FROM HELP:
Run("notepad.exe")
WinWait("[CLASS:Notepad]")
ControlSetText("[CLASS:Notepad]", "", "Edit1", "New Text Here")
Local $sText = ControlGetText("[CLASS:Notepad]", "", "Edit1")
MsgBox(0, "ControlGetText Example", "The control text is: " & $sText)
#ce

;C:\Program Files (x86)\Microsoft Office\Office14	-LOCATION OF EXCEL ON MY COMPUTER

Run("C:\Program Files (x86)\Microsoft Office\Office14\excel.exe")
WinWaitActive("[CLASS:XLMAIN]", "")

ControlSend("[CLASS:XLMAIN]", "", "[CLASS:EXCEL<;INSTANCE:1]", "New Text Here")	;NOTE:  This works, text appears in Fx line
sleep(500)
$sText = ControlGetText("[CLASS:XLMAIN]", "", "[CLASS:EXCEL<;INSTANCE:1]")	;NOTE: Same exact window title and control access used here as in the above "ControlSend", which works

MsgBox(0, "ControlGetText Example", "The error code is: " & @error )	;Returns an error code 1
MsgBox(0, "ControlGetText Example", "The control text is: " & $sText )	;Returns a null string

Exit
