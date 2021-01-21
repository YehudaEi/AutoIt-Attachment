;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Nomad
;
; Script Function:
;   Automatically heals the player in a game of Diablo II, and adds the ability to exit a game quickly
;   This script is incomplete, but functional
;

#include <Constants.au3>
#Include <Misc.au3>

Global $V, $Window, $HPT, $HPTDIF, $RP2, $HP2, $pc1, $pc2, $pc3, $pc4, $x1, $x2, $x3, $x4, $y1

$HPTS = 0
$HKS = 0
$Return = 0
$SettingsFile = @SCRIPTDIR & '\Settings.ini'
$RP = IniRead($SettingsFile, "Settings", "RejuvenationPotion%", "50") ; default uses a rejuv at 50% life
$HP = IniRead($SettingsFile, "Settings", "HealthPotion%", "70") ; default uses a health pot at 70% life

AutoItSetOption ( "PixelCoordMode", 2) ; allows pixelcheck to be done in window or full screen
AutoItSetOption ( "MouseCoordMode", 2) ; allows mouse to move to correct position in window or full screen
AutoItSetOption ( "SendKeyDownDelay", 15) ; helps ensure that a critical keypress is not missed

$dll = DllOpen("user32.dll")

$V = 1

While (1)
	Main ()
WEnd

;==========Functions============

Func Main () ; this will contain more when the GUI and other functions are scripted
While (1)
	Select
		Case $V = 1
			TitleGet ()
		Case $V = 2
			ChickenPixelCheck ()
	EndSelect
WEnd
EndFunc


Func TitleGet () ; $V = 1

$pc = PixelGetColor(341, 560) ; checks to see if in game
If $pc = 4161439 or $pc = 13382604 Then ; in game
$Window = WinGetTitle("")
$V = 2
Else
	$V = 1
EndIf

EndFunc


Func ChickenPixelCheck () ; $V = 2

$x1 = 438
$x2 = 469
$x3 = 500
$x4 = 531
$y1 = 581

While (not _IsPressed("1B", $dll)) ; i tried using this alone instead of all the calls, but the delay to exit was too long

If $HPTS = 1 Then ; health pot used, starting delay timer (keeps script from potting all the health pots away)
	$HPTS = 2
	$HPT = TimerInit()
EndIf

If $HPTS = 2 Then ; sets delay at 5 seconds
	$HPTDIF = TimerDiff($HPT)
	If $HPTDIF > 5000 Then
		$HPTS = 0
	EndIf
EndIf

If Not WinActive($Window) Then ExitLoop
$pc = PixelGetColor(341, 560) ; checks to see if in game
If _IsPressed("0D", $dll) Then ; checks to see if Enter was pressed
	If $Return = 0 Then
		$Return = 1
	ElseIf $Return = 1 Then
		$Return = 0
	EndIf
EndIf
If _IsPressed("1B", $dll) Then ; checks to see if Escape was pressed
	ExitGame ()
	ExitLoop
ElseIf $pc = 4161439 or $pc = 13382604 Then ; in game
	If Not WinActive($Window) Then ExitLoop
	Sleep (15) ; these sleep commands are to slow the script down and keep the game from lagging
	$pc1 = PixelGetColor($x1, $y1) ; checks to see what pots are in the belt
	$pc2 = PixelGetColor($x4, $y1)
	$pc3 = PixelGetColor($x3, $y1)
	$pc4 = PixelGetColor($x4, $y1)
	$pc = PixelGetColor(70, 580) ; checks for 10% life
	If _IsPressed("0D", $dll) Then
		If $Return = 0 Then
			$Return = 1
		ElseIf $Return = 1 Then
			$Return = 0
		EndIf
	EndIf
	If _IsPressed("1B", $dll) Then
		ExitGame ()
		ExitLoop
	ElseIf $pc = 12558143 or $pc = 10460991 or $pc = 3355392 Then ; check passed
		If Not WinActive($Window) Then ExitLoop
		Sleep (15)
		$pc = PixelGetColor(70, 573) ; checks for 20% life
		If _IsPressed("0D", $dll) Then
			If $Return = 0 Then
				$Return = 1
			ElseIf $Return = 1 Then
				$Return = 0
			EndIf
		EndIf
		If _IsPressed("1B", $dll) Then
			ExitGame ()
			ExitLoop
		ElseIf $pc = 4185919 or $pc = 8347519 or $pc = 16737792 Then ; check passed
			If Not WinActive($Window) Then ExitLoop
			Sleep (15)
			$pc = PixelGetColor(70, 564) ; checks for 30% life
			If _IsPressed("0D", $dll) Then
				If $Return = 0 Then
					$Return = 1
				ElseIf $Return = 1 Then
					$Return = 0
				EndIf
			EndIf
			If _IsPressed("1B", $dll) Then
				ExitGame ()
				ExitLoop
			ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
				If Not WinActive($Window) Then ExitLoop
				Sleep (15)
				$pc = PixelGetColor(70, 556) ; checks for 40% life
				If _IsPressed("0D", $dll) Then
					If $Return = 0 Then
						$Return = 1
					ElseIf $Return = 1 Then
						$Return = 0
					EndIf
				EndIf
				If _IsPressed("1B", $dll) Then
					ExitGame ()
					ExitLoop
				ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
					If Not WinActive($Window) Then ExitLoop
					Sleep (15)
					$pc = PixelGetColor(70, 547) ; checks for 50% life
					If _IsPressed("0D", $dll) Then
						If $Return = 0 Then
							$Return = 1
						ElseIf $Return = 1 Then
							$Return = 0
						EndIf
					EndIf
					If _IsPressed("1B", $dll) Then
						ExitGame ()
						ExitLoop
					ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
						If Not WinActive($Window) Then ExitLoop
						Sleep (15)
						$pc = PixelGetColor(70, 540) ; checks for 60% life
						If _IsPressed("0D", $dll) Then
							If $Return = 0 Then
								$Return = 1
							ElseIf $Return = 1 Then
								$Return = 0
							EndIf
						EndIf
						If _IsPressed("1B", $dll) Then
							ExitGame ()
							ExitLoop
						ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
							If Not WinActive($Window) Then ExitLoop
							Sleep (15)
							$pc = PixelGetColor(70, 532) ; checks for 70% life
							If _IsPressed("0D", $dll) Then
								If $Return = 0 Then
									$Return = 1
								ElseIf $Return = 1 Then
									$Return = 0
								EndIf
							EndIf
							If _IsPressed("1B", $dll) Then
								ExitGame ()
								ExitLoop
							ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
								If Not WinActive($Window) Then ExitLoop
								Sleep (15)
								$pc = PixelGetColor(70, 524) ; checks for 80% life
								If _IsPressed("0D", $dll) Then
									If $Return = 0 Then
										$Return = 1
									ElseIf $Return = 1 Then
										$Return = 0
									EndIf
								EndIf
								If _IsPressed("1B", $dll) Then
									ExitGame ()
									ExitLoop
								ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
									If Not WinActive($Window) Then ExitLoop
									Sleep (15)
									$pc = PixelGetColor(70, 516) ; checks for 90% life
									If _IsPressed("0D", $dll) Then
										If $Return = 0 Then
											$Return = 1
										ElseIf $Return = 1 Then
											$Return = 0
										EndIf
									EndIf
									If _IsPressed("1B", $dll) Then
										ExitGame ()
										ExitLoop
									ElseIf $pc = 8388736 or $pc = 8347519 Then ; check passed
										If Not WinActive($Window) Then ExitLoop
										ContinueLoop
									Else ; at ~90% life
										If Not WinActive($Window) Then ExitLoop
										If $RP2 >= 90 Then
											UseRPotion ()
										ElseIf $HP2 >= 90 Then
											UseHPotion ()
										EndIf
										ContinueLoop
									EndIf
								Else ; at ~80% life
									If Not WinActive($Window) Then ExitLoop
									If $RP2 >= 80 Then
										UseRPotion ()
									ElseIf $HP2 >= 80 Then
										UseHPotion ()
									EndIf
									ContinueLoop
								EndIf
							Else ; at ~70% life
								If Not WinActive($Window) Then ExitLoop
								If $RP2 >= 70 Then
									UseRPotion ()
								ElseIf $HP2 >= 70 Then
									UseHPotion ()
								EndIf
								ContinueLoop
							EndIf
						Else ; at ~60% life
							If Not WinActive($Window) Then ExitLoop
							If $RP2 >= 60 Then
								UseRPotion ()
							ElseIf $HP2 >= 60 Then
								UseHPotion ()
							EndIf
							ContinueLoop
						EndIf
					Else ; at ~50% life
						If Not WinActive($Window) Then ExitLoop
						If $RP2 >= 50 Then
							UseRPotion ()
						ElseIf $HP2 >= 50 Then
							UseHPotion ()
						EndIf
						ContinueLoop
					EndIf
				Else ; at ~40% life
					If Not WinActive($Window) Then ExitLoop
					If $RP2 >= 40 Then
						UseRPotion ()
					ElseIf $HP2 >= 40 Then
						UseHPotion ()
					EndIf
					ContinueLoop
				EndIf
			Else ; at ~30% life
				If Not WinActive($Window) Then ExitLoop
				If $RP2 >= 30 Then
					UseRPotion ()
				ElseIf $HP2 >= 30 Then
					UseHPotion ()
				EndIf
				ContinueLoop
			EndIf
		Else ; at ~20% life
			If Not WinActive($Window) Then ExitLoop
			If $RP2 >= 20 Then
				UseRPotion ()
			ElseIf $HP2 >= 20 Then
				UseHPotion ()
			EndIf
			ContinueLoop
		EndIf
	Else ; at ~10% life
		If Not WinActive($Window) Then ExitLoop
		If $RP2 >= 10 Then
			UseRPotion ()
		ElseIf $HP2 >= 10 Then
			UseHPotion ()
		EndIf
		ContinueLoop
	EndIf
Else ; not in game
	ExitLoop
EndIf
WEnd

$V = 1

EndFunc


Func UseRPotion () ; use rejuvenation pot or exit game if none left

If $Return = 0 Then ; chat window is closed
	Select
		Case $pc1 = 10053171
			Send ('{1}')
		Case $pc2 = 10053171
			Send ('{2}')
		Case $pc3 = 10053171
			Send ('{3}')
		Case $pc4 = 10053171
			Send ('{4}')
		Case Else
			ExitGame ()
	EndSelect
Else ; chat window is open, can't use keys to send data
	Select
		Case $pc1 = 10053171
			$XY = MouseGetPos()
			If _IsPressed("01", $dll) Then ; checks if left mouse button is pressed
				$Left = 1
			Else
				$Left = 0
			EndIf
			MouseClick ("left", $x1, $y1, 1, 0)
			If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
			If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
		Case $pc2 = 10053171
			$XY = MouseGetPos()
			If _IsPressed("01", $dll) Then
				$Left = 1
			Else
				$Left = 0
			EndIf
			MouseClick ("left", $x2, $y1, 1, 0)
			If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
			If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
		Case $pc3 = 10053171
			$XY = MouseGetPos()
			If _IsPressed("01", $dll) Then
				$Left = 1
			Else
				$Left = 0
			EndIf
			MouseClick ("left", $x3, $y1, 1, 0)
			If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
			If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
		Case $pc4 = 10053171
			$XY = MouseGetPos()
			If _IsPressed("01", $dll) Then
				$Left = 1
			Else
				$Left = 0
			EndIf
			MouseClick ("left", $x4, $y1, 1, 0)
			If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
			If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
		Case Else
			ExitGame ()
	EndSelect
EndIf

EndFunc


Func UseHPotion () ; use health pot
	
If $Return = 0 Then ; chat window is closed
	If $HPTS = 0 Then
		$HPTS = 1
		Select
			Case $pc1 = 6723891
				Send ('{1}')
			Case $pc2 = 6723891
				Send ('{2}')
			Case $pc3 = 6723891
				Send ('{3}')
			Case $pc4 = 6723891
				Send ('{4}')
		EndSelect
	EndIf
Else ; chat window is open, can't use keys to send data
	If $HPTS = 0 Then
		$HPTS = 1
		Select
			Case $pc1 = 6723891
				$XY = MouseGetPos()
				If _IsPressed("01", $dll) Then ; checks if left mouse button is pressed
					$Left = 1
				Else
					$Left = 0
				EndIf
				MouseClick ("left", $x1, $y1, 1, 0)
				If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
				If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
			Case $pc2 = 6723891
				$XY = MouseGetPos()
				If _IsPressed("01", $dll) Then
					$Left = 1
				Else
					$Left = 0
				EndIf
				MouseClick ("left", $x2, $y1, 1, 0)
				If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
				If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
			Case $pc3 = 6723891
				$XY = MouseGetPos()
				If _IsPressed("01", $dll) Then
					$Left = 1
				Else
					$Left = 0
				EndIf
				MouseClick ("left", $x3, $y1, 1, 0)
				If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
				If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
			Case $pc4 = 6723891
				$XY = MouseGetPos()
				If _IsPressed("01", $dll) Then
					$Left = 1
				Else
					$Left = 0
				EndIf
				MouseClick ("left", $x4, $y1, 1, 0)
				If $Left = 0 Then MouseMove ($XY[0], $XY[1], 0)
				If $Left = 1 Then MouseClick ("left", $XY[0], $XY[1], 1, 0)
		EndSelect
	EndIf
EndIf

EndFunc


Func ExitGame ()

If $Return = 1 Then ; chat window was open, closed when user pressed escape, but now need escape again to exit
	ControlSend ($Window, '', '', '{ESC}')
EndIf
MouseMove (400, 500, 0)
ControlSend ($Window, '', '', '{UP}{ENTER}')
$Return = 0

EndFunc