; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       WinXP
; Author:         rtk217
;
; Script Function: Macro for Knight Online: classes: mage,warrior, rogue, priest (not buffer).
;
;
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 1)
AutoItSetOption("SendKeyDelay", 5)
AutoItSetOption("SendKeyDownDelay", 50)
;AutoItSetOption("SendKeyDelay", 10)
opt("WinTitleMatchMode", 2)
opt("MouseClickDownDelay", 200)
opt("SendAttachMode", 1)
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------
#include <Array.au3>
#include <file.au3>

Global $redx, $redy, $bluex, $bluey, $mana, $life, $black, $blackx
global $blacky, $block, $melee, $meleec, $counter = 0, $dead, $i
global $skills, $fucked, $aoe, $ccc, $k[6]


HotKeySet("{insert}", "TogglePause")

Sleep(100)



Func TogglePause()
	If $dead = 0 Then ToolTip("Program Paused", 0, 0)
	Sleep(500)
	While 1
		If _IsPressed('2D') = 1 Then
			if _IsPressed('2E') then exit
			Sleep(200)
			ToolTip("")
			$dead = 0
			main()
		EndIf
	WEnd
EndFunc   ;==>TogglePause


Func _IsPressed($hexKey)


	Local $aR, $bO

	$hexKey = '0x' & $hexKey
	$aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
	If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
		$bO = 1
	Else
		$bO = 0
	EndIf

	Return $bO
EndFunc   ;==>_IsPressed

Func setup()
	$file = FileOpen("macro.ini", 0)
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	$k[0] = FileReadLine($file, 1)
	$k[1] = FileReadLine($file, 2)
	$k[2] = FileReadLine($file, 3)
	$k[3] = FileReadLine($file, 4)
	$k[4] = FileReadLine($file, 5)
	$k[5] = FileReadLine($file, 6)
	$life = FileReadLine($file, 7)
	$mana = FileReadLine($file, 8)
	$block = FileReadLine($file, 9)
	$melee = FileReadLine($file, 10)
	$skills = FileReadLine($file, 11)
	$aoe = FileReadLine($file, 12)
	FileClose($file)
	WinActivate("Knight OnLine Client", "")
	$redx = 202
	$redy = 11
	$bluex = 183
	$bluey = 29
	$black = 16777215
	$blackx = 424
	$blacky = 341
	If WinActive("Knight OnLine Client") = 0 Then exit
	If $block = 1 Then block()
	main()

EndFunc   ;==>setup

Func block()
	Sleep(100)
	Send("{enter}")
	Sleep(100)
	Send("/block_party")
	Sleep(100)
	Send("{enter}")
	Sleep(1000)
	Sleep(100)
	Send("/block_trade_request")
	Sleep(100)
	Send("{enter}")
	Sleep(200)
	Send("{enter}")
	Sleep(1000)
	main()
EndFunc   ;==>block

Func pressok()
	Sleep(100)
	MouseMove(512, 437)
	Sleep(300)
	MouseDown("left")
	Sleep(300)
	MouseUp("left")
	ToolTip("U died", 0, 0)
	$dead = 1
	TogglePause()
EndFunc   ;==>pressok


Func sit()
	If PixelGetColor(535, 745) <> 0 Then Send("c")
	Sleep(100)
	If PixelGetColor(535, 745) <> 0 Then Send("c")
	Sleep(500)
	While 1
		If PixelGetColor(270, 10) <> 0 And PixelGetColor(270, 29) <> 0 Then
			Sleep(200)
			$fucked = 0
			main()
		EndIf
		If PixelGetColor(270, 29) = 0 Or PixelGetColor(270, 11) = 0 Then
			$fucked = 1
			Sleep(500)
			If PixelGetColor(535, 745) = 15667200 Then main()
			If _IsPressed('2E') = 1 Then exit
			If _IsPressed('2D') = 1 Then TogglePause()
		EndIf

	WEnd
	Sleep(200)
	$fucked = 0
	main()
EndFunc   ;==>sit



Func attack()
	$ccc= $ccc + 1
	$counter = 0
	While PixelGetColor(445, 48) = 6492176
		$counter = $counter + 1
		If PixelGetColor($redx, $redy) = 0 Then Send($life)
		If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
		Sleep(100)
		If _IsPressed('2E') = 1 Then exit
		If _IsPressed('2D') = 1 Then TogglePause()
		If $melee = 1 And $meleec = 0 Then
			Send("r")
			$meleec = 1
		EndIf
		If $skills <> 0 and $aoe <> 1 Then

				For $i = 0 To $skills - 1
					If _IsPressed('2E') = 1 Then exit
					If _IsPressed('2D') = 1 Then TogglePause()
					If PixelGetColor($redx, $redy) = 0 Then Send($life)
					If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
					If $k[$i] <> "" Then
						Send($k[$i])
						Sleep(200)
					EndIf
				Next
		EndIf
		If $aoe = 1 Then
			If _IsPressed('2E') = 1 Then exit
			If _IsPressed('2D') = 1 Then TogglePause()
			If PixelGetColor($redx, $redy) = 0 Then Send($life)
			If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
			If $k[1] <> "" Then
				Send($k[1])
				Sleep(100)
				MouseMove(512, 384)
				Sleep(100)
				MouseDown("left")
				Sleep(100)
				MouseUp("left")
			EndIf
		EndIf
		Sleep(100)
		If $counter > 6 And PixelGetColor(589, 48) = 6492176 Then main()
	WEnd
	main()
EndFunc   ;==>attack

Func runagain()
	Run("mse.exe")
	Exit
EndFunc   ;==>runagain

Func main()
	sleep(100)
	While 1
		
		If $ccc > 500 then runagain()
		If PixelGetColor($blackx, $blacky) = $black Then pressok()
		If _IsPressed('2E') = 1 Then exit
		If _IsPressed('2D') = 1 Then TogglePause()
		if PixelGetColor(215, $redy) = 0 and PixelGetColor(445, 48) <> 6492176 And $fucked = 0 Then sit()
		if PixelGetColor(210, $bluey) = 0 and PixelGetColor(445, 48) <> 6492176 And $fucked = 0 Then sit()
		Send("z")
		Sleep(700)
		If _IsPressed('2E') = 1 Then exit
		If _IsPressed('2D') = 1 Then TogglePause()
		If $fucked = 1 Then
			Send("z")
			Sleep(700)
			If PixelGetColor($redx, $redy) = 0 Then Send($life)
			If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
			$fucked = 0
			attack()
		EndIf
		If PixelGetColor(445, 48) = 6492176 And PixelGetColor($redx, $redy) <> 0 And PixelGetColor($bluex, $bluey) <> 0 Then attack()
		Send("x")
		Sleep(150)
		Send("w")
		Sleep(200)
		Send("ss")
		$counter = 0
		$meleec = 0
		If PixelGetColor($redx, $redy) = 0 Then Send($life)
		If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
	WEnd
EndFunc   ;==>main
setup()
