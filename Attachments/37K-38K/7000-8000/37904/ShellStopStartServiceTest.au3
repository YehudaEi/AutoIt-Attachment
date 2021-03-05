#RequireAdmin
WinWaitActive("Run As")
Send({Down})
Send({Down})
Send({Tab})
$oShell = ObjCreate("shell.application")
If @error Then
	MsgBox(1, "Error", "Error in creating oblect" & " " & @error)
EndIf

$oShell.ServiceStop("EspRun", False)


MsgBox(0, "Service Stopped", "Service stopped")
$oShell.ServiceStart("EspRun", False)

MsgBox(0, "Service Started", "Service has started again")

;EndIf
