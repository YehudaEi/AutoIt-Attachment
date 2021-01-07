;this programm uses the registry as autostart_option
;only works as admin
;made by Marten Zimmermann

#include <guiconstants.au3>

GUICreate ("Main", 600, 100, -1, -1, -1, $WS_EX_ACCEPTFILES)
;the regvalue
GUICtrlCreateLabel ("Registryvalue", 10, 10, 100)
$regval = GUICtrlCreateEdit ("", 120, 10, 170)
;the programm
guictrlcreatelabel ("Programm", 10, 40, 100)
$prog = GUICtrlCreateEdit ("", 120, 40, 420, -1, $ES_READONLY, $WS_EX_STATICEDGE + $WS_EX_ACCEPTFILES)
$progbut = GUICtrlCreateButton ("...", 550, 40, 40)
;do as you wish button
$write = GUICtrlCreateButton ("AutoStartIt", 10, 70, 280)
;set the focus on first control
GUICtrlSetState ($regval, $GUI_FOCUS)
GUISetState()


while 1
	$msg = GUIGetMsg()
	Select
	;exit on X
	case $msg = $GUI_EVENT_CLOSE
		Exit
	;what happens at "..."
	case $msg = $progbut
		;open a filedialog to input the file
		$file = FileOpenDialog("Choose file...",@WorkingDir,"Exe (*.exe)", 1)
		;if there is a file selected update the edit_control
		if @error <> 1 Then
			GUICtrlSetData ($prog, $file)
		EndIf
	;what happens at "AutoStartIt"
	case $msg = $write
		;call this function
		writeit()
	EndSelect
WEnd


func writeit()
;check if there is a programm chosen
if guictrlread ($prog) <> "" Then
	;check if registry-value already exists
	$a = RegRead ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", guictrlread($regval))
	;if it doesn't write it
	if @error = -1 Then
		$regvalue = StringReplace(guictrlread($regval), " ", "_")
		$b = RegWrite ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $regvalue, "REG_SZ", guictrlread ($prog))
		;check if writing was successful
		if $b = 1 Then
			msgbox (0, "Success", "Programm automated successfully", 2)
		Else
			msgbox (0, "Error", "An Error occured while writing", 2)
		EndIf
	Else
		msgbox (0, "Error", "Key already exists", 5)
	EndIf
Else
	msgbox (0, "Error", "No programm", 5)
EndIf
EndFunc		