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
Global $blacky, $block, $melee, $meleec, $counter = 0, $dead, $i
Global $skills, $aoe, $fucked, $ccc, $k[6]

$dll = DllOpen("user32.dll")


HotKeySet("{insert}", "TogglePause")

Sleep(100)

setup()

Func TogglePause()
	If $dead = 0 Then ToolTip("Program Paused", 0, 0)
	Sleep(500)
	While 1
		If _IsPressed('2D', $dll) = 1 Then
			If _IsPressed('2E', $dll) Then _Exit()
			Sleep(200)
			ToolTip("")
			$dead = 0
			main()
		EndIf
	WEnd
EndFunc   ;==>TogglePause


Func _IsPressed($s_hexKey, $v_dll = 'user32.dll')
	; $hexKey must be the value of one of the keys.
	; _Is_Key_Pressed will return 0 if the key is not pressed, 1 if it is.
	Local $a_R = DllCall($v_dll, "int", "GetAsyncKeyState", "int", '0x' & $s_hexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc   ;==>_IsPressed

Func setup()
	$file = FileOpen("macro.ini", 0)
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		_Exit()
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
	If WinActive("Knight OnLine Client") = 0 Then _Exit()
	If $block = 1 Then
		block()
	Else
		main()
	EndIf
	
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
			Sleep(500)
			If PixelGetColor(535, 745) = 15667200 Then $fucked = 1
			If _IsPressed('2E', $dll) = 1 Then _Exit()
			If _IsPressed('2D', $dll) = 1 Then TogglePause()
			fucked()
		EndIf
		
	WEnd
EndFunc   ;==>sit

Func fucked()
	Send("z")
	Sleep(500)
	$counter = 0
	If PixelGetColor($redx, $redy) = 0 Then Send($life)
	If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
	While PixelGetColor(445, 48) = 6492176
		$counter = $counter + 1
		If PixelGetColor($redx, $redy) = 0 Then Send($life)
		If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
		Sleep(100)
		If _IsPressed('2E', $dll) = 1 Then _Exit()
		If _IsPressed('2D', $dll) = 1 Then TogglePause()
		If $melee = 1 And $meleec = 0 Then
			Send("r")
			$meleec = 1
		EndIf
		If $skills <> 0 And $aoe <> 1 Then
			
			For $i = 0 To $skills - 1
				If _IsPressed('2E', $dll) = 1 Then _Exit()
				If _IsPressed('2D', $dll) = 1 Then TogglePause()
				If PixelGetColor($redx, $redy) = 0 Then Send($life)
				If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
				If $k[$i] <> "" Then
					Send($k[$i])
					Sleep(200)
				EndIf
			Next
		EndIf
		If $aoe = 1 Then
			If _IsPressed('2E', $dll) = 1 Then _Exit()
			If _IsPressed('2D', $dll) = 1 Then TogglePause()
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
		If $counter > 6 And PixelGetColor(589, 48) = 6492176 Then ExitLoop
	WEnd
	main()
EndFunc   ;==>fucked


Func runagain()
	Run("mse.exe")
	_Exit()
EndFunc   ;==>runagain

Func main()
	;$ccc= $ccc + 1
	;If $ccc > 200 then runagain()
	Sleep(100)
	While 1
		If PixelGetColor($blackx, $blacky) = $black Then pressok()
		If _IsPressed('2E', $dll) = 1 Then _Exit()
		If _IsPressed('2D', $dll) = 1 Then TogglePause()
		If PixelGetColor(215, $redy) = 0 And PixelGetColor(445, 48) <> 6492176 Then sit()
		If PixelGetColor(210, $bluey) = 0 And PixelGetColor(445, 48) <> 6492176 Then sit()
		Send("z")
		Sleep(500)
		If _IsPressed('2E', $dll) = 1 Then _Exit()
		If _IsPressed('2D', $dll) = 1 Then TogglePause()
		If PixelGetColor(445, 48) = 6492176 And PixelGetColor($redx, $redy) <> 0 And PixelGetColor($bluex, $bluey) <> 0 Then
			$counter = 0
			While PixelGetColor(445, 48) = 6492176
				$counter = $counter + 1
				If PixelGetColor($redx, $redy) = 0 Then Send($life)
				If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
				Sleep(100)
				If _IsPressed('2E', $dll) = 1 Then _Exit()
				If _IsPressed('2D', $dll) = 1 Then TogglePause()
				If $melee = 1 And $meleec = 0 Then
					Send("r")
					$meleec = 1
				EndIf
				If $skills <> 0 And $aoe <> 1 Then
					
					For $i = 0 To $skills - 1
						If _IsPressed('2E', $dll) = 1 Then _Exit()
						If _IsPressed('2D', $dll) = 1 Then TogglePause()
						If PixelGetColor($redx, $redy) = 0 Then Send($life)
						If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
						If $k[$i] <> "" Then
							Send($k[$i])
							Sleep(200)
						EndIf
					Next
				EndIf
				If $aoe = 1 Then
					If _IsPressed('2E', $dll) = 1 Then _Exit()
					If _IsPressed('2D', $dll) = 1 Then TogglePause()
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
				If $counter > 6 And PixelGetColor(589, 48) = 6492176 Then ExitLoop
			WEnd
		EndIf
		Send("x")
		Sleep(150)
		Send("w")
		Sleep(200)
		Send("ss")
		$counter = 0
		$meleec = 0
		If PixelGetColor(215, $redy) = 0 And PixelGetColor(445, 48) <> 6492176 Then sit()
		If PixelGetColor(210, $bluey) = 0 And PixelGetColor(445, 48) <> 6492176 Then sit()
		If PixelGetColor($redx, $redy) = 0 Then Send($life)
		If PixelGetColor($bluex, $bluey) = 0 Then Send($mana)
	WEnd
EndFunc   ;==>main

Func _Exit()
	DllClose($dll)
	Exit
EndFunc   ;==>_Exit