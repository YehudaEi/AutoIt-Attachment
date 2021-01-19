#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.9.13 (beta)
 Author:         Triblade

 Created 14-12-2007 (dd-mm-yyyy)
 Updated 21-12-2007 (dd-mm-yyyy)

 Updated 21-12-2007:
	- Added global $max variable to expand maximum number of ping entries when wanted. (don't recommand to do this cause of lag issues)
	- Changed: Some harcoded variables (10's and 9's) to use the $max var instead
	- Added Slow ping option in the Global options traymenu to be able to use the AutoIt native ping function instead of the command prompt, which is OS dependant
	- Added fastpong function. The original ping is still there and accessable through the traymenu in the Global options as Slow ping. Fastpong uses the command prompt of the OS for faster results.
		Thanks for this idea and sample to: GaryFrost (In post: http://www.autoitscript.com/forum/index.php?showtopic=59502&view=findpost&p=448259 )
	- Added Case Else in the $error Switch. This because the fastping gives too long error messages to display. So it display's a simple 'Unknown ping loss' message. (Also I'm to lazy to check every posibility)

 Script Function:
	Ping up to $max (standard set to 10) hosts from one window.
	Interresting abilities:
		- Expandable window to create more ping-entries ($max = standard set to 10)
		- On-top function via the Tray
		- Hide / Show GUI option in the Tray
		- GUI controls in array for dynamic expansion
		- Ping error-text
		- Colored input field when pinged
		- External ping option (standard set). Faster but uses the external cmd prompt to get fast results
		- Internal ping option. Slower but isn't using the external cmd prompt
		- Tooltips with controls (the least interresting if you'd ask me)
		
		Okay, some of this so-called interresting stuff may not be as interresting for some, but it was for me and maybe for others.
		
	(The maximum of 10 entries is because of the ping-timeout, else the lag would be even larger than it allready can be. However this $max var can be set to a larger number.)

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Declaration of includes
#include <GUIConstants.au3>
#include <Constants.au3>
#include <Array.au3>

; Set resize mode so that controls won't be auto-shaped
; Set traymenumode so that I can create my own traymenu
Opt("GUIResizeMode", 802)
Opt("TrayMenuMode", 1)

; Set $max variable. This var contains the maximum number of ping entries
Global $max = 10

; Declare a lot of variables. (I hope I didn't leave one out :) )
Global $actief[$max]
Dim $pongfrm, $pinggroup[$max], $pinglbl[$max], $pingbtn[$max], $rembtn[$max], $addbtn, $traymenu, $noms, $hsgui, $otgui, $exitgui, $fpingoption
Dim $time, $pingip, $roundtrip, $currentnumber, $ontop, $frmstate, $error, $nomsstate, $fastping
Dim $msg, $traymsg, $i, $j

; Set all array variables to 0 or 9999
; Those set to 99999 aren't set to 0 cause this can cause problems when using these vars and controlID's. My code needs this :)
For $i = 0 To $max - 1 Step 1
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
$nomsstate = 0
$fastping = 1

; Create the GUI and set the background color of it
$pongfrm = GUICreate("Pong", 160, 40, -1, -1)
GUISetBkColor(0x20A0FF)

$addbtn = GUICtrlCreateButton("+", 143, 20, 15, 15) ; Create the add button before the rest for tabbing purposes.
GUICtrlSetTip($addbtn, "Add ping entry") ; Set the tooltip for the add button. I use the full variable instead of -1 cause  I think this is more precise.
extra() ; Go into the routine that generates the ping entries

TraySetClick(16) ; Set the tray to react only to the secondary mouse button (Right button for most mouses)
$traymenu = TrayCreateMenu("Global options") ; Create a menu in the trayicon

; Create few items in the trayicon
$noms = TrayCreateItem("Show destination instead of ms", $traymenu)
$fpingoption = TrayCreateItem("Slow ping (uses native ping)", $traymenu)
$hsgui = TrayCreateItem("Hide / Show screen")
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
	If TimerDiff($time) > 1000 Then ; At least 1 second has to pass before it pings all again. This because else the program will ping to much and to fast
		For $i = 0 To $currentnumber - 1 Step 1
			If $actief[$i] <> "0" Then ; See if the entry is active. If the number is not 0 then it is active
				If $fastping = 1 Then ; If $fastping option is 1 (set) then go to the fastpong function
					fastpong($i)
				Else ; Else goto the pong function
					pong($i)
				EndIf
				$time = TimerInit() ; Reset the timer to now
			EndIf
		Next
	EndIf
WEnd

Exit ; I all ways exit with this even if there's an infinite loop above it. Just to be certain

Func extra() ; The variable $currentnumber holds the number of ping entries made in the GUI
	$pinggroup[$currentnumber] = GUICtrlCreateGroup("", 5, $currentnumber * 30, 135, 35) ; Create a group. This is visualised as a line/border
		$pinglbl[$currentnumber] = GUICtrlCreateInput("127.0.0.1", 10, $currentnumber * 30 + 12, 95, 17, BitOr($ES_AUTOHSCROLL, $SS_CENTER)) ; Create a input box with near unlimited space and centered text.
		GUICtrlSetTip($pinglbl[$currentnumber], "Ping destination")
		$pingbtn[$currentnumber] = GUICtrlCreateButton(">", 106, $currentnumber * 30 + 12, 15, 15)
		GUICtrlSetTip($pingbtn[$currentnumber], "Start/Stop this ping")
		GUICtrlSetState($pingbtn[$currentnumber], $GUI_FOCUS) ; Set the focus to the start/stop button after the entry is made
		If $currentnumber > 0 Then ; If it is not the first entry then display a remove button
			$rembtn[$currentnumber] = GUICtrlCreateButton("-", 121, $currentnumber * 30 + 12, 15, 15)
			GUICtrlSetTip($rembtn[$currentnumber], "Remove entry")
		EndIf
	GUICtrlCreateGroup("",-99,-99,1,1) ; End group creation
	GUICtrlSetPos($addbtn, 143, $currentnumber * 30 + 20) ; Shift the add button one down
	$currentnumber = $currentnumber + 1 ; Add one to the number of entries noted in this var
	If $currentnumber = $max Then GUICtrlSetState($addbtn, $GUI_DISABLE) ; If there are $max (standard set to 10) entries then disable the add button to deny the possibility to add more
EndFunc

Func remove($i)
	GUICtrlDelete($pinggroup[$i]) ; Delete the entry (all controls of the ping group
	GUICtrlDelete($pinglbl[$i])
	GUICtrlDelete($pingbtn[$i])
	GUICtrlDelete($rembtn[$i])
	For $j = $i To $currentnumber - 1 Step 1 ; Shift the position of all remaining (visually below the deleted group) controls one position up
		GUICtrlSetPos($pinggroup[$j], 5, (($j - 1) * 30))
		GUICtrlSetPos($pinglbl[$j], 10, (($j - 1) * 30) + 12)
		GUICtrlSetPos($pingbtn[$j], 106, (($j - 1) * 30) + 12)
		GUICtrlSetPos($rembtn[$j], 121, (($j - 1) * 30) + 12)
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

Func pong($j)
	$roundtrip = Ping($actief[$j], 1000) ; Ping the entry with a timeout of 1 second and save the roundtrip time
	pingresult($roundtrip, $j, @error)
EndFunc

Func fastpong($j)
	Local $selectedoutput = "", $line = "", $console, $pingresult, $lineresult ; Local some variables
	Local $console = Run(@ComSpec & " /c ping -n 1 -w 10 " & $actief[$j], @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD) ; Run a command screen with a ping command
	While 1
		$line = StdoutRead($console) ; Read a line of the output of the command screen output
		If @error Then ExitLoop
		$selectedoutput &= $line ; Put all the read lines together in one variable
	WEnd
	If StringInStr($selectedoutput, "Received = 1") Then ; Check if there is a successfull recieved ping
		$line = StringMid($selectedoutput, StringInStr($selectedoutput, "time") + 5) ; Select the piece of output where the roundtrip time is shown
		$lineresult = StringInStr($line, "TTL=") - 4 ; Check where the roundtrip time ends
		$pingresult = StringMid($line, 1, $lineresult) ; Trim the above line so that only the roundstrip time in ms is selected
	EndIf
	pingresult($pingresult, $i, $selectedoutput)
EndFunc

Func pingresult($roundtrip, $i, $error)
	If $roundtrip = 0 Then ; If the roundtrip is not 0 then check error results
		Switch $error ; Switch @error from the ping() command accourding to the helpfile v3.2.8.1
			Case 1
				GUICtrlSetData($pinglbl[$i], "Host is offline")
			Case 2
				GUICtrlSetData($pinglbl[$i], "Host is unreachable")
			Case 3
				GUICtrlSetData($pinglbl[$i], "Bad destination")
			Case 4
				GUICtrlSetData($pinglbl[$i], "Unknown error")
			Case Else ; If the input is not from the internal ping command, then if it failes it automatically comes here
				GUICtrlSetData($pinglbl[$i], "Unknown ping loss")
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
				TrayItemSetState($noms, $TRAY_CHECKED)
			Else
				$nomsstate = 0
				TrayItemSetState($noms, $TRAY_UNCHECKED)
			EndIf
		Case $fpingoption
			If $fastping = 1 Then
				$fastping = 0
				TrayItemSetState($fpingoption, $TRAY_CHECKED)
			Else
				$fastping = 1
				TrayItemSetState($fpingoption, $TRAY_UNCHECKED)
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