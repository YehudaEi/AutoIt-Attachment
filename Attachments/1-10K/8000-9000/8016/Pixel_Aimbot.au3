; +--------------------------------------------------------------------------------------------------------------+
; | Aimbot: Proof of Concept                                                                                     |
; | "A pixel searching aimbot that utilizes several lockon/autoshoot/search methods. It requires the AutoIt BETA |
; | and the Shockwave browser plugin."                                                                           |
; | By: Simucal                                                                                                  |
; +--------------------------------------------------------------------------------------------------------------+


#include <GUIConstants.au3>
Global $Aimbot = 0, $found = "no"

Opt("MouseCoordMode", 0)
Opt("PixelCoordMode", 0)
Opt("MouseClickDelay", 0)
Opt("MouseClickDownDelay", 0)


While 1
	$SelectionForm = GUICreate("Aimbot - Proof of Concept", 298, 83, 350, 400)
	GUICtrlCreateLabel("Choose a game:", 32, 8, 81, 17)
	$flybutton = GUICtrlCreateButton("Shoot the Fly", 32, 40, 105, 25)
	$csbutton = GUICtrlCreateButton("Camper Strike", 168, 40, 105, 25)
	
	GUISetState()
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $flybutton
				$gamename = "Shoot the Fly"
				GUIDelete($SelectionForm)
				ExitLoop
			Case $msg = $csbutton
				$gamename = "Camper Strike"
				GUIDelete($SelectionForm)
				ExitLoop
			Case $msg = $GUI_EVENT_CLOSE
				Exit
		EndSelect
	WEnd
	
	HotKeySet("{Space}", "ToggleAimbot")
	HotKeySet("{End}", "TurnoffAimbot")
	
	$oGame = ObjCreate ("ShockwaveFlash.ShockwaveFlash.1")
	$GameForm = GUICreate($gamename & ": Aimbot Proof of Concept", 820, 660, -1, -1)
	$GUIActiveX = GUICtrlCreateObj ($oGame, 10, 10, 800, 580)
	$exitbutton = GUICtrlCreateButton("Exit", 704, 624, 89, 25)
	$changebutton = GUICtrlCreateButton("Change Game", 610, 624, 89, 25)
	GUICtrlCreateLabel("Hit [Space] to toggle the aimbot, [End] to turn it off.", 16, 608, 300, 17)
	$status = GUICtrlCreateLabel("Aimbot Status: Off", 16, 624, 500, 33)
	GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
	
	If $gamename = "Shoot the Fly" Then
		With $oGame
			.bgcolor = "#000000"
			.Movie = '                                                      '
			.ScaleMode = 2
			.Loop = True
			.wmode = "Opaque"
		EndWith
		$searchcolor = 0x23AC00
	Else
		With $oGame
			.bgcolor = "#000000"
			.Movie = '                                                      '
			.ScaleMode = 2
			.Loop = True
			.wmode = "Opaque"
		EndWith
		$headshot = 0xFF9986
		$bodyshot = 0xFF7070
		$searchcolor = 0xFF9986
		$headradio = GUICtrlCreateRadio("ARadio1", 425, 608, 17, 17)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$bodyradio = GUICtrlCreateRadio("ARadio2", 505, 608, 17, 17)
		GUICtrlCreateLabel("Headshot", 443, 608, 50, 17)
		GUICtrlCreateLabel("Bodyshot", 523, 608, 48, 17)
		GUICtrlCreateLabel("Aimbot Options:", 340, 608, 78, 17)
	EndIf
	
	GUISetState()
	
	While 1
		If $Aimbot = 1 Then; Normal Auto-Aim
			$coord = PixelSearch(10, 10, 800, 580, $searchcolor)
			If IsArray($coord) = 1 Then
				MouseMove($coord[0], $coord[1], 0)
			EndIf
		EndIf
		If $Aimbot = 2 Then; Auto-Aim + Autoshoot
			$coord = PixelSearch(10, 10, 800, 580, $searchcolor)
			If IsArray($coord) = 1 Then
				MouseClick('left', $coord[0], $coord[1], 1, 0)
				If $gamename = "Camper Strike" Then Send("r")
			EndIf
		EndIf
		If $Aimbot = 3 Then; Snap-to
			If $found = "no" Then
				$pos = MouseGetPos()
				$coord = PixelSearch(($pos[0] - 50) , ($pos[1] - 50) , ($pos[0] + 50) , ($pos[1] + 50), $searchcolor) ; initial search area 50sq'pixels
				If IsArray($coord) = 1 Then
					MouseMove($coord[0], $coord[1], 0)
					$found = "yes"
				EndIf
			EndIf
			If $found = "yes" Then
				$pos = MouseGetPos()
				$coord = PixelSearch(($pos[0] - 10) , ($pos[1] - 10) , ($pos[0] + 10) , ($pos[1] + 10), $searchcolor) ; locked on search area 10sq'pixels
				If IsArray($coord) = 1 Then
					MouseMove($coord[0], $coord[1], 0)
				Else
					$found = "no"
				EndIf
			EndIf
		EndIf
		If $Aimbot = 4 Then; Snap-to + Autoshoot
			$pos = MouseGetPos()
			$coord = PixelSearch(($pos[0] - 50) , ($pos[1] - 50) , ($pos[0] + 50) , ($pos[1] + 50), $searchcolor)
			If IsArray($coord) = 1 Then
				MouseClick('left', $coord[0], $coord[1], 1, 0)
				If $gamename = "Camper Strike" Then Send("r")
			EndIf
		EndIf
		If $Aimbot = 5 Then; Auto Lock-On the first available target on screen
			If $found = "no" Then
				$coord = PixelSearch(10, 10, 800, 580, $searchcolor)
				If IsArray($coord) = 1 Then
					MouseMove($coord[0], $coord[1], 0)
					$found = "yes"
				EndIf
			Else
				$pos = MouseGetPos()
				$coord = PixelSearch(($pos[0] - 10) , ($pos[1] - 10) , ($pos[0] + 10) , ($pos[1] + 10), $searchcolor) ; refined locked on search area of 10sq'pixels
				If IsArray($coord) = 1 Then
					MouseMove($coord[0], $coord[1], 0)
				Else
					$found = "no"
				EndIf
			EndIf
		EndIf
		If $Aimbot = 6 Then; Auto Lock-On the first available target + Autoshoot
			If $found = "no" Then
				$coord = PixelSearch(10, 10, 800, 580, $searchcolor)
				If IsArray($coord) = 1 Then
					MouseMove($coord[0], $coord[1], 0)
					$found = "yes"
				EndIf
			Else
				$pos = MouseGetPos()
				$coord = PixelSearch(($pos[0] - 10) , ($pos[1] - 10) , ($pos[0] + 10) , ($pos[1] + 10), $searchcolor)
				If IsArray($coord) = 1 Then
					MouseClick('left', $coord[0], $coord[1], 1, 0)
					If $gamename = "Camper Strike" Then
						Send("r")
					EndIf
				Else
					$found = "no"
				EndIf
			EndIf
		EndIf
		$msg = GUIGetMsg()
		If $gamename = "Shoot the fly" Then
			Select
				Case $msg = $exitbutton
					ExitLoop 2
				Case $msg = $changebutton
					GUIDelete($GameForm)
					ExitLoop 1
				Case $msg = $GUI_EVENT_CLOSE
					ExitLoop 2
			EndSelect
		EndIf
		If $gamename = "Camper Strike" Then
			Select
				Case $msg = $exitbutton
					ExitLoop 2
				Case $msg = $changebutton
					$oGame.Stop
					GUIDelete($GameForm)
					ExitLoop 1
				Case $msg = $bodyradio
					$searchcolor = $bodyshot
				Case $msg = $headradio
					$searchcolor = $headshot
				Case $msg = $GUI_EVENT_CLOSE
					ExitLoop 2
			EndSelect
		EndIf
		
	WEnd
	$oGame = 0
	GUIDelete()
WEnd
Exit

Func ToggleAimbot()
	If $Aimbot < 6 Then
		$Aimbot = $Aimbot + 1
	Else
		$Aimbot = 0
	EndIf
	Select
		Case $Aimbot = 0
			GUICtrlSetData($status, "Aimbot Status: Off")
		Case $Aimbot = 1
			GUICtrlSetData($status, "Aimbot Status: AutoFind")
		Case $Aimbot = 2
			GUICtrlSetData($status, "Aimbot Status: AutoFind + AutoShoot")
		Case $Aimbot = 3
			GUICtrlSetData($status, "Aimbot Status: Snap-To")
		Case $Aimbot = 4
			GUICtrlSetData($status, "Aimbot Status: Snap-To + AutoShoot")
		Case $Aimbot = 5
			GUICtrlSetData($status, "Aimbot Status: AutoFind/Lock-On")
		Case $Aimbot = 6
			GUICtrlSetData($status, "Aimbot Status: AutoFind/Lock-On + AutoShoot")
	EndSelect
EndFunc   ;==>ToggleAimbot

Func TurnoffAimbot()
	$Aimbot = 0
	GUICtrlSetData($status, "Aimbot Status: Off")
EndFunc   ;==>TurnoffAimbot