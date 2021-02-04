#Include <Misc.au3>

Global $Paused

$hDll = DllOpen("user32.dll")
HotKeySet("m", "_Monies")

While 1
	Sleep(10)
	If _IsPressed(0x05, $hDll) Then
		Send("{q down}")
		While _IsPressed(0x05, $hDll)
			Sleep(10)
		WEnd
		Send("{q up}")
	EndIf
	If _IsPressed(0x06, $hDll) Then
		Send("{e down}")
		While _IsPressed(0x06, $hDll)
			Sleep(10)
		WEnd
		Send("{e up}")
	EndIf
WEnd

Func _Monies()
	$Paused = NOT $Paused
	While $Paused
		If _IsPressed(0x10, $hDll) = 0 Then Send("f")
	WEnd
EndFunc