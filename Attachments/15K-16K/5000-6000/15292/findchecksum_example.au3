#include <findchecksum_UDF.au3>

Global $checksum, $coord, $pcolor

; Specify checksum width
Global $width = 30
; Specify checksum height
Global $height = 30

HotKeySet("{ENTER}","checksum_record")

Global $instructions1 = "Move the mouse to the top left of the search" & @LF & "area and then press Enter to record the area."
Global $instructions2 = "Press the F key to find the recorded area."

While $checksum = ""
    $coord = MouseGetPos()
    $pcolor = PixelGetColor($coord[0], $coord[1])
    ToolTip($instructions1 & @LF & @LF & "x = " & $coord[0] & @LF & "y = " & $coord[1] & @LF & @LF & "Decimal Pixel Color = " & $pcolor, $coord[0] - 250, $coord[1] - 100)
    Sleep(100)
WEnd

HotKeySet("f","checksum_find")

While 1
	ToolTip($instructions2)
	Sleep(100)
WEnd

Func checksum_record()
    $checksum = PixelChecksum($coord[0], $coord[1], $coord[0] + $width, $coord[1] + $height)
	HotKeySet("{ENTER}")
EndFunc

Func checksum_find()
	ToolTip("")
	$found = _findchecksum($checksum, $width, $height, $pcolor)
	If $found = 0 Then
		MsgBox(4096,"Error","Checksum not found.")
		Exit
	Else
		MouseMove($found[0] + ($width / 2), $found[1] + ($height / 2), 1000)
		ToolTip("Found it!")
		Sleep(5000)
		ToolTip("")
		MsgBox(0,"Checksum Found","Checksum found with center at x=" & $found[0] + ($width / 2) & " y=" & $found[1] + ($height / 2) & ".")
		Exit
	EndIf
EndFunc