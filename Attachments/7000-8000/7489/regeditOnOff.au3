#include <GUIConstants.au3>
Opt("GUICoordMode",2)
Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)



; create the form
GUICreate("Enable/Disable regedit",250,30)  ; will create a dialog box that when displayed is centered

; create the checkbox
$checkCN = GUICtrlCreateCheckbox ("Registry Editting Enabled", 10, 10, 150, 20)

; set the state of the checkbox
if (_GetRegEditAllowed()==1) Then
	GUICtrlSetState($checkCN,$GUI_CHECKED);
Else
	GUICtrlSetState($checkCN,$GUI_UNCHECKED);
EndIf

; start processing gui events
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
GUICtrlSetOnEvent(-1, "ToggleCheckbox")
GUISetState ()       ; will display an  dialog box with 1 checkbox

; Run the GUI until the dialog is closed
While 1
	Sleep(10)
Wend

Func SpecialEvents()

    Select
        Case @GUI_CTRLID = $GUI_EVENT_CLOSE
            Exit
            
;        Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
 ;           MsgBox(0, "Window Minimized", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
  ;          
   ;     Case @GUI_CTRLID = $GUI_EVENT_RESTORE
    ;        MsgBox(0, "Window Restored", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
            
    EndSelect
    
EndFunc

Func ToggleCheckbox()	
	if (_GetRegEditAllowed()==1) Then
		_SetRegEditAllowed(0)
		GUICtrlSetState($checkCN,$GUI_UNCHECKED);
	Else
		_SetRegEditAllowed(1)
		GUICtrlSetState($checkCN,$GUI_CHECKED);
	EndIf
EndFunc

Func _GetRegEditAllowed()
	Local $var = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools");
	if ($var="" or $var="0") Then
		; registry editting is allowed ie not disabled
		return 1
	Else
		; registry editting is disabled
		Return 0
	EndIf
EndFunc

Func _SetRegEditAllowed($allowed)
	local $v;
	if ($allowed==1) Then
		$v=0
	ElseIf ($allowed==0) Then
		$v=1
	Else
		Return "Param ERR";
	EndIf
	Local $var = RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools","REG_DWORD",$v);
	Return $var
EndFunc

 