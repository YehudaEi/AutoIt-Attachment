;Renamer / Domainer
;
;A script i made to (hopefully) make some common tasks 
;i do a lot a little easier.
;For XP Pro only.
;
;Alan Brevick 
;mrmincho@gmail.com
;
#include<GUIConstants.au3>

Opt("GUIOnEventMode", 1)

$question = GUICreate("Question", 300, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSE")
GUICtrlCreateLabel("Naming or Domining? Note: these will restart the computer when finished.", 30, 10)

$Naming = GUICtrlCreateButton("Naming", 70, 50, 60)
$Domaining = GUICtrlCreateButton("Domaining", 180, 50, 60)

;
;Make sure for buttons its Gui ctrl SET on event
;
GUICtrlSetOnEvent($Naming, "CMDNaming")
GUICtrlSetOnEvent($Domaining, "CMDDomaining")

GUISetState(@SW_SHOW)

While 1
	Sleep(1000)
Wend

;Funcs

Func CMDNaming()
	
	$CompName = InputBox("Input Name", "Type name wished for computer. Limit to 15 Characters!")
	Run("control sysdm.cpl,, 1")
	WinWaitActive("System Properties")
	Send("{TAB}{TAB}{ENTER}")
	Send($CompName)
	Send("{ENTER}{ENTER}{TAB}{ENTER}{ENTER}")
Exit
EndFunc

Func CMDDomaining()
	Run("control sysdm.cpl,, 1")
	WinWaitActive("System Properties")
	Send("{TAB}{TAB}{ENTER}")
	Send("{TAB}{TAB}{UP}{TAB}")
;Domain Here
	Send("{ENTER}")
;Username here
	Send("{TAB}")
;pword here
	Send("{ENTER}{ENTER}{ENTER}{TAB}{ENTER}")

Exit
	
EndFunc


Func CLOSE()
	Exit
EndFunc
