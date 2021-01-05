; A simple custom messagebox that uses the OnEvent mode

#include <GUIConstants.au3>

Opt("GUIOnEventMode",1)

GUICreate("Custom Msgbox", 210, 80)

$Label = GUICtrlCreateLabel("Please click a button!", 10, 10)
$YesID  = GUICtrlCreateButton("Set Proxy", 10, 50, 50, 20)
GUICtrlSetOnEvent($YesID,"OnYes")
$NoID   = GUICtrlCreateButton("Unset Proxy", 80, 50, 50, 20)
GUICtrlSetOnEvent($NoID,"OnNo")
$ExitID = GUICtrlCreateButton("Exit", 150, 50, 50, 20)
GUICtrlSetOnEvent($ExitID,"OnExit")

GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")

GUISetState()  ; display the GUI

While 1
   Sleep (1000)
WEnd

;--------------- Functions ---------------
Func OnYes()
	MsgBox(0,"You clicked on", "Set Proxy")
	ControlSend ( "Local Area Network (LAN) Settings", "text", 1570,"{NUMPADADD}")
	ControlClick ( "Local Area Network (LAN) Settings", "OK", 1 )
EndFunc

Func OnNo()
	MsgBox(0,"You clicked on", "Unset Proxy")
	ControlSend ( "Local Area Network (LAN) Settings", "text", 1570,"{NUMPADSUB}")
	ControlClick ( "Local Area Network (LAN) Settings", "OK", 1 )
EndFunc

Func OnExit()
	if @GUI_CtrlId = $ExitId Then
		MsgBox(0,"You clicked on", "Exit")
	Else
		MsgBox(0,"You clicked on", "Close")
	EndIf

	Exit
EndFunc
