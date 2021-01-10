#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>


local $a, $b, $msg, $comp, $sel, $val
GUICreate ("PING C264")
$a = GUICtrlCreateCombo (" ", 10,20,70,30)
$comp = GUICtrlSetData($a, "C2641|C2642|C2643|C2644|C264S1" , " ")
$b = GUICtrlCreateButton ("PING", 10,50,70,30)
$sel = GUICtrlSetState(-1, $GUI_FOCUS)
$c = GUICtrlCreateLabel ("C264-LIST", 100,25)
$d = GUICtrlCreateButton ("OK", 200,20)
GUISetState()
While 1
  $msg = GUIGetMsg()

  Select
    Case $msg = $d And $a = "C2641"
      MsgBox(0, "GUI Event", "You have selected C2641")
	  
	  Run ("notepad.exe", "", @SW_MAXIMIZE)
	 
	 Case $msg = $b
     RunWait(@ComSpec & " /c " & 'ping 192.168.0.10', "", @SW_MAXIMIZE) 

    Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
  EndSelect
WEnd 
