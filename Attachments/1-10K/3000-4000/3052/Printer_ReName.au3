; ----------------------------------------------------------------------------
;  6/30/05
;  Lexmark Printer WH Name and Address update
; ----------------------------------------------------------------------------
#include <Process.au3>
Dim $IP ; lookup from col "A" on SS
Dim $ContactName ; lookup from col "B" on SS
Dim $LocationName ; lookup from col "C" on SS
Dim $OpenWeb ; Launches the web-interface
$A = "A" ; Starting Cell Reference
$1 = 1   ; Starting Cell Reference

Do ;All the code needed for one full loop; 
$combo = $A & $1
$IP=getcell($combo)
Send("{right}")
ControlSend("Microsoft Excel","","XLDESK1","^c"); copies contents
$ContactName=clipget(); move clipboard to $ContactName
ControlSend("Microsoft Excel","","XLDESK1","{esc}"); return excel to normal state
Send("{right}")
ControlSend("Microsoft Excel","","XLDESK1","^c"); copies contents
$LocationName=clipget(); move clipboard to $LocationName
ControlSend("Microsoft Excel","","XLDESK1","{esc}"); return excel to normal state
MsgBox(0,"output", $IP & $ContactName & $LocationName) ; Just validates my output is what I want
$OpenWeb=_RunDos("start http://" & $IP & "/port_0/config/general") ;To be called as from the START menu
;Wait for print server window to be activly loaded, then send the following;
WinWaitActive("Print Server Settings - Microsoft Internet Explorer","")
Sleep(3000)
Send("{Tab}")
Send("{Tab}")
Send($ContactName)
Send("{Tab}")
Send("{CTRLDOWN}a{CTRLUP}{BACKSPACE}")
Send($LocationName)
Sleep(500)
Send("{Enter}")
WinWaitActive("Configuration Change Submitted - Microsoft Internet Explorer","")
$1 = $1 + 1   ;Start over on next IP, move down one cell
Until $1 = 11  ;Number of printers to update xtimes to repeat
SoundPlay(@WindowsDir & "\media\tada.wav",1)


Func getcell($combo) ;Function to get cell reference "$combo" off the clipboard into variable $x
winactivate("Microsoft Excel")
ControlSend("Microsoft Excel","","XLDESK1","{f5}")
While NOT ControlCommand ("Go To","","EDTBX1","IsVisible", "") ; wait for window
sleep(100)
Wend
ControlSend("Go To","","EDTBX1",$combo &"{enter}")
ControlSend("Microsoft Excel","","XLDESK1","^c"); copies contents
$IP=clipget(); move clipboard to $x
ControlSend("Microsoft Excel","","XLDESK1","{esc}"); return excel to normal state
Return $IP
EndFunc
