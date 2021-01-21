HotKeySet ("^+z", "Hide")
HotKeySet ("^+x", "Show")
Opt("TrayIconHide", 1)
$hidden = "no"

While 1
	If $hidden = "yes" Then
		Sleep (10)
	Else
		Global $title = WinGetTitle("")
		Sleep (10)
	EndIf
WEnd

Func Hide()
	$hidden = "yes"
	If WinExists("" & $title) Then
	WinSetState ("" & $title, "", @SW_HIDE)
	EndIf
EndFunc

Func Show()
	$hidden = "no"
	If WinExists("" & $title) Then
	WinSetState ("" & $title, "", @SW_SHOW)
	EndIf
EndFunc