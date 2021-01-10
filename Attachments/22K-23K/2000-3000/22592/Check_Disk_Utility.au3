#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Check Disk Utility.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>

Opt("GUIOnEventMode", 1)
$first = GUICreate("Disk Check Utility")
GUICtrlCreateLabel("This utility will AUTOMATE the task of checking your system disk for errors", 10, 20)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Close")
$okButton = GUICtrlCreateButton("OK", 50, 50, 60)
GUISetOnEvent($okButton, "_OkButton")
GUISetState(@SW_SHOW)

While 1
	Sleep(1000) ;wait
WEnd


;GUICreate("Confirmation")
;$yes = GUICtrlCreateButton("Yes", 50, 70)
;$no = GUICtrlCreateButton("No", 75, 70)
;$bool = False


Func _OkButton()
	;user chooses to run application
	MsgBox(0, "GUI Event", "You pressed OK!")

	Exit
	Run("cmd.exe")
	WinWaitActive("C:\WINDOWS\system32\cmd.exe")
	Send("chkdsk /x /r{enter}")
	Sleep(2000)
	Send("n {enter}")
	Sleep(1000)
	WinActivate("C:\WINDOWS\system32\cmd.exe")
	WinClose("C:\WINDOWS\system32\cmd.exe")
	Sleep(1000)
EndFunc   ;==>_OkButton


Func _Close()
	;user chose to close befor running
	Exit
EndFunc   ;==>_Close
