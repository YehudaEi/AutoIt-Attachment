#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.9.13 (beta)
 Author:         Triblade

 Script Function:
	Ping up to 10 hosts from one window.
	Interresting abilities:
		- Expandable window to create more ping-entries (10 max)
		- On-top function via the Tray
		- Hide / Show GUI option in the Tray
		- GUI controls in array for dynamic expansion
		- Ping error-text
		- Colored input field when pinged
		- Tooltips with controls (the least interresting if you'd ask me)
		
		Okay, some of this so-called interresting stuff may not be as interresting for some, but it was for me and maybe for others.
		
	(The maximum of 10 entries is because of the ping-timeout, else the lag would be even larger than it allready can be)

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Declaration of includes
#include <GUIConstants.au3>
#Include <Constants.au3>
#include <Array.au3>

; Set resize mode so that controls won't be auto-shaped
; Set traymenumode so that I can create my own traymenu
Opt("GUIResizeMode", 802)
Opt("TrayMenuMode", 1)

; Declare a lot of variables.
Global $actief[10]
Dim $pongfrm, $pinggroup[10], $pinglbl[10], $pingbtn[10], $rembtn[10], $addbtn, $traymenu, $noms, $hsgui, $otgui, $exitgui
Dim $time, $pingip, $roundtrip, $currentnumber, $ontop, $frmstate, $error, $nomsstate
Dim $msg, $traymsg, $i, $j

; Set all array variables to 0 or 99999
; Those set to 99999 aren't set to 0 cause this can cause problems when using these vars and controlID's. My code needs this :)
For $i = 0 To 9 Step 1
	$pinggroup[$i] = 0
	$pinglbl[$i] = 0
	$pingbtn[$i] = 99999
	$rembtn[$i] = 99999
	$actief[$i] = 0
Next

; More variables
$time = 2000
$currentnumber = 0
$ontop = 0
$frmstate = 1

; Create the GUI and set the background color of it
$pongfrm = GUICreate("Pong", 160, 40, -1, -1)
GUISetBkColor(0x20A0FF)

$addbtn = GUICtrlCreateButton("+", 143, 20, 15, 15) ; Create the add button before the rest for tabbing purposes.
GUICtrlSetTip($addbtn, "Add ping entry") ; Set the tooltip for the add button. I use the full variable instead of -1 cause  I think this is more precise.
extra() ; Go into the routine that generates the ping entries

TraySetClick(16) ; Set the tray to react only to the secondary mouse button (Right button for most mouses)
$traymenu = TrayCreateMenu("Global options") ; Create a menu in the trayicon

; Create few items in the trayicon
$noms = TrayCreateItem("Show hostname instead of ms", $traymenu)
$hsgui = TrayCreateItem("Hide / Show GUI")
$otgui = TrayCreateItem("Toggle on-top mode")
$exitgui = TrayCreateItem("Exit")
TrayItemSetState($hsgui, $TRAY_CHECKED) ; Set the $hsgui trayitem to be checked.
TraySetState() ; Creates/Shows the traymenu

GUISetState() ; Creates/Shows the GUI

$time = TimerInit() ; Set the var to hold the current time

While 1 ; Main loop
	$msg = GUIGetMsg() ; Get GUI events
	Switch $msg ; Switch .. Case for events
		Case $GUI_EVENT_CLOSE
			Exit
		Case $addbtn
			$guiposition = WinGetPos($pongfrm) ; Get the GUI coördinates
			WinMove($pongfrm, "", $guiposition[0], $guiposition[1], $guiposition[2], $guiposition[3] + 30) ; Expandes the window with 30 pixels downward
			extra()
	EndSwitch
	tray()
	For $i = 1 To $currentnumber - 1 Step 1 ; Check all the remove buttons if there is an event
		If $msg = $rembtn[$i] Then
			remove($i)
		EndIf
	Next
	For $i = 0 To $currentnumber - 1 Step 1 ; Check all ping buttons to see if there is a ping activated or deactivated and act accourdingly
		If $msg = $pingbtn[$i] Then
			If GUICtrlRead($pingbtn[$i]) = ">" Then
				$actief[$i] = GUICtrlRead($pinglbl[$i])
				GUICtrlSetStyle($pinglbl[$i], BitOr($SS_CENTER, $ES_READONLY))
				GUICtrlSetData($pingbtn[$i], "||")
			Else
				GUICtrlSetData($pinglbl[$i], $actief[$i])
				GUICtrlSetBkColor($pinglbl[$i], $GUI_BKCOLOR_TRANSPARENT)
				$actief[$i] = 0
				GUICtrlSetStyle($pinglbl[$i], $SS_CENTER)
				GUICtrlSetData($pingbtn[$i], ">")
			EndIf
		EndIf
	Next
	pong()
WEnd

Exit ; I all ways exit with this even if there's an infinite loop above it. Just to be certain

Func extra() ; The variable $currentnumber holds the number of ping entries made in the GUI
	$pinggroup[$currentnumber] = GUICtrlCreateGroup("", 5, $currentnumber * 30, 135, 35) ; Create a group. This is visualised as a line/border
		$pinglbl[$currentnumber] = GUICtrlCreateInput("127.0.0.1", 13, $currentnumber * 30 + 12, 90, 17, BitOr($ES_AUTOHSCROLL, $SS_CENTER)) ; Create a input box with near unlimited space and centered text.
		GUICtrlSetTip($pinglbl[$currentnumber], "Ping destination")
		$pingbtn[$currentnumber] = GUICtrlCreateButton(">", 105, $currentnumber * 30 + 12, 15, 15)
		GUICtrlSetTip($pingbtn[$currentnumber], "Start/Stop this ping")
		GUICtrlSetState($pingbtn[$currentnumber], $GUI_FOCUS) ; Set the focus to the start/stop button after the entry is made
		If $currentnumber > 0 Then ; If it is not the first entry then display a remove button
			$rembtn[$currentnumber] = GUICtrlCreateButton("-", 120, $currentnumber * 30 + 12, 15, 15)
			GUICtrlSetTip($rembtn[$currentnumber], "Remove entry")
		EndIf
	GUICtrlCreateGroup("",-99,-99,1,1) ; End group creation
	GUICtrlSetPos($addbtn, 143, $currentnumber * 30 + 20) ; Shift the add button one down
	$currentnumber = $currentnumber + 1 ; Add one to the number of entries noted in this var
	If $currentnumber = 10 Then GUICtrlSetState($addbtn, $GUI_DISABLE) ; If there are 10 entries then disable the add button to deny the possibility to add more
EndFunc

Func remove($i)
	GUICtrlDelete($pinggroup[$i]) ; Delete the entry (all controls of the ping group
	GUICtrlDelete($pinglbl[$i])
	GUICtrlDelete($pingbtn[$i])
	GUICtrlDelete($rembtn[$i])
	For $j = $i To $currentnumber - 1 Step 1 ; Shift the position of all remaining (visually below the deleted group) controls one position up
		GUICtrlSetPos($pinggroup[$j], 5, (($j - 1) * 30))
		GUICtrlSetPos($pinglbl[$j], 13, (($j - 1) * 30) + 12)
		GUICtrlSetPos($pingbtn[$j], 105, (($j - 1) * 30) + 12)
		GUICtrlSetPos($rembtn[$j], 120, (($j - 1) * 30) + 12)
	Next
	For $j = $i To $currentnumber - 1 Step 1 ; Shift the control ID's to the right array position o stay coherent to the entry number
		If $j < $currentnumber - 1 Then
			_ArraySwap($actief[$j], $actief[$j + 1])
			_ArraySwap($pinggroup[$j], $pinggroup[$j + 1])
			_ArraySwap($pinglbl[$j], $pinglbl[$j + 1])
			_ArraySwap($pingbtn[$j], $pingbtn[$j + 1])
			_ArraySwap($rembtn[$j], $rembtn[$j + 1])
		Else ; The last one can be set to 0, not really needed, but to be neat
			$actief[$j] = 0
			$pinggroup[$j] = 0
			$pinglbl[$j] = 0
			$pingbtn[$j] = 0
			$rembtn[$j] = 0
		EndIf
	Next
	GUICtrlSetPos($addbtn, 143, $currentnumber * 30 - 40) ; Shift the add button one up
	$guiposition = WinGetPos($pongfrm) ; Get the size of the GUI
	WinMove($pongfrm, "", $guiposition[0], $guiposition[1], $guiposition[2], $guiposition[3] - 30) ; Contract the current GUI size 30 pixels. Contrary to the 30 pixel exand
	$currentnumber = $currentnumber - 1 ; Subtract one from the number of made entries
	If GUICtrlGetState($addbtn) = 144 Then GUICtrlSetState($addbtn, $GUI_ENABLE) ; If the add button is disables then enable it. This is because there is room for at least one more entry after a delete
EndFunc

Func pong()
	If TimerDiff($time) > 1000 Then ; At least 1 second has to pass before it pings all again. This because else the program will ping to much and to fast
		For $i = 0 To $currentnumber - 1 Step 1
			If $actief[$i] <> "0" Then ; See if the entry is active. If the number is not 0 then it is active
				$roundtrip = Ping($actief[$i], 1000) ; Ping the entry with a timeout of 1 second and save the roundtrip time
				pingresult($roundtrip, $i, @error)
			EndIf
		Next
		$time = TimerInit() ; Reset the timer to nowe
	EndIf
EndFunc

Func pingresult($roundtrip, $i, $error)
	If $roundtrip = 0 Then ; If the roundtrip is not 0 then check error results
		Switch $error
			Case 1
				GUICtrlSetData($pinglbl[$i], "Host is offline")
			Case 2
				GUICtrlSetData($pinglbl[$i], "Host is unreachable")
			Case 3
				GUICtrlSetData($pinglbl[$i], "Bad destination")
			Case 4
				GUICtrlSetData($pinglbl[$i], "Unknown error")
		EndSwitch
		GUICtrlSetBkColor($pinglbl[$i], 0xff0000) ; Set backgroundcolor to red
	Else
		If $nomsstate = 0 Then ; If the no millisecond variable is 0 then display the roundtrip time
			GUICtrlSetData($pinglbl[$i], $roundtrip & " ms")
		Else
			GUICtrlSetData($pinglbl[$i], $actief[$i]) ; Else display just the destination
		EndIf
		GUICtrlSetBkColor($pinglbl[$i], 0x00ff00) ; Set the background color green
	EndIf
EndFunc

Func tray()
	$traymsg = TrayGetMsg() ; Get the tray events
	Switch $traymsg
		Case $TRAY_EVENT_PRIMARYDOUBLE ; If there is doubleclick then..
			trayswitch()
		Case $noms
			If $nomsstate = 0 Then
				$nomsstate = 1
			Else
				$nomsstate = 0
			EndIf
		Case $hsgui
			trayswitch()
		Case $otgui
			ontop()
		Case $exitgui
			Exit
	EndSwitch
EndFunc

Func trayswitch()
	If $frmstate = 1 Then
		GUISetState(@SW_HIDE, $pongfrm) ; Hides the GUI
		TrayItemSetState($hsgui, $TRAY_UNCHECKED) ; Uncheck the hsgui trayitem
		$frmstate = 0
	Else
		GUISetState(@SW_SHOW, $pongfrm) ; Shows the GUI
		GUISetState(@SW_RESTORE, $pongfrm) ; Restores the GUI (that it is set on front)
		TrayItemSetState($hsgui, $TRAY_CHECKED) ; Check the hsgui trayitem
		$frmstate = 1
	EndIf
EndFunc

Func ontop()
	If $ontop = 0 then
		WinSetOnTop($pongfrm, "", 1) ; Set the GUI on top
		TrayItemSetState($otgui, $TRAY_CHECKED) ; Check the otgui trayitem
		$ontop = 1
	Else
		WinSetOnTop($pongfrm, "", 0) ; Unset the GUI on top
		TrayItemSetState($otgui, $TRAY_UNCHECKED) ; Uncheck th otgui trayitem
		$ontop = 0
	EndIf
EndFunc