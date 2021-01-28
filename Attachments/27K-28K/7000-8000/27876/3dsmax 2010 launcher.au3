#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <buttonrestore.au3>

$Form1 = GUICreate("",200,100)
$button1 = GUICtrlCreateButton ("Backup",0,0,60,20)
$button2 = GUICtrlCreateButton ("Start 3DsMax",100,0,60,20)
$button3 = GUICtrlCreateButton ("Restore",160,0,60,20)
GUISetState(@SW_SHOW)

While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
	   case $button1
	buttonrestore()
	Case $GUI_EVENT_CLOSE
           Exit
EndSwitch
WEnd