#include <GuiConstants.au3>
#NoTrayIcon
Opt ("MustDeclareVars", 1)
Opt ("TrayIconDebug", 1)
opt ("MouseCoordMode", 0)    ; rel to window
Opt("WinWaitDelay", 1000)
Opt("WinTitleMatchMode", 1)	; from left end
Opt("GUIOnEventMode", 0)  
Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
Opt("TrayOnEventMode",1)

; 01 Feb 08 Added ChooseContinueOrExit
; 06 Feb 07	Added $cnmDriveLtr; added avoid multiple instances
; 26 Jan 07 Added TraySetIcon
; 18 Dec 06	Changed to 5 beeps at 1 sec interval
; 08 Dec 06	Changed from maximizing Pegasus to ControlClick

; When a new message arrives and Pegasus is minimized, beeps
Global $macroname = "Check for new email"
Global $cnmDriveLtr,$playUntilMaxed = False,$CCEans

InitTray()

If WinExists($macroname&"_") Then Exit	; avoid multiple instances
AutoItWinSetTitle($macroname&"_")

$cnmDriveLtr = FindPegasusDrive()	; includes colon
if $cnmDriveLtr="" then
	MsgBox(0,$macroname,"Search for Pegasus' Inbox failed")
	Exit
EndIf

WaitForPegasusToRun()

main()

Func main()
Local $qMsgs,$state,$playing,$wasMaxd,$firstTime=True,$t,$mailWaiting,$n,$newMail,$i
	$wasMaxd = (BitAND($state,32)<>0)
	$qMsgs = 0
	While 1
		$state = WinGetState("Pegasus Mail")
;		Winstate()
		If $state=0 Then	; if Pegasus window not found
			If ChooseContinueOrExit()="e" Then Exit
		ElseIf BitAND($state,32)<>0 Then		; if maximized
			if $playing Then 
				$playing = False
			EndIf
			$wasMaxd = 1
			Sleep(10*1000)
		ElseIf BitAND($state,16)<>0 Then	; if minimized
			if $wasMaxd or $firstTime Then
				$qMsgs = CountCNMs()
			Else	
				$t = WinGetText("Pegasus Mail")
				$mailWaiting = StringInStr($t,"waiting on pop.gmail.com")
				if $mailWaiting Then	; If Gmail advised rather than downloading
					ControlClick("Pegasus Mail","",827,"left",1)	; Click on donwload email icon
				EndIf
				$n = CountCNMs()
				$newMail = $n>$qmsgs ; or $mailWaiting
				if $n>$qMsgs Then $qMsgs = $n
				if $newMail Then
					if Not $playing Then
						MsgBox(4096,$macroname,"There is new mail",10)
						$playing = True
					EndIf
				EndIf
				$i = 1
				While $i <= 10
					if BitAND(WinGetState("Pegasus Mail"),32)<>0 Then ExitLoop	; if maximized
					If $playing Then
						If $i <5 Or $playUntilMaxed Then
							beep(500,500)
							beep(500*1.414,500)
						Else
							$playing = False
						EndIf
					EndIf
					Sleep(1*1000)
					$i = $i + 1
				WEnd
			EndIf
		Else
			Sleep(10*1000)
		EndIf
		$wasMaxd = BitAND($state,32)
		$firstTime = False
	WEnd
EndFunc ; main

Func InitTray()
;	TraySetIcon(@ScriptDir&"\\MAPIF1L.ICO")
	TrayCreateItem("Beep until Pegasus is maximized")
	TrayItemSetOnEvent(-1,"TogglePlayUntilMaxedCB")
	TrayCreateItem("")
	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1,"ExitScriptCB")
	TraySetState()
EndFunc

Func TogglePlayUntilMaxedCB()
;	$playUntilMaxed = Not $playUntilMaxed
	If BitAND(TrayItemGetState(@TRAY_ID),$TRAY_UNCHECKED)<>0 Then 
		TrayItemSetState(@TRAY_ID,$TRAY_CHECKED)
	Else
		TrayItemSetState(@TRAY_ID,$TRAY_UNCHECKED)
	EndIf
	$playUntilMaxed = (BitAND(TrayItemGetState(@TRAY_ID),$TRAY_CHECKED)<>0)
EndFunc

Func ExitScriptCB()
	Exit
EndFunc

Func ChooseContinueOrExit()
Local $BtnCont,$BtnExit,$msg
	GuiCreate($macroname, 241, 119,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

	GuiCtrlCreateLabel("Click on Continue when Pegasus is running", 10, 20, 210, 20)
	GuiCtrlCreateLabel("or on Exit to exit Check for new mail", 10, 40, 200, 20)
	$BtnCont = GuiCtrlCreateButton(" Continue ", 10, 70)
	$BtnExit = GuiCtrlCreateButton(" Exit ", 170, 70)

	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg=$BtnCont
			Return "c"
		Case $msg=$BtnExit
			Return "e"
		EndSelect
	WEnd
EndFunc
#cs
Func ChooseContinueOrExit()
	GuiCreate($macroname, 241, 119,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	GUISetOnEvent($GUI_EVENT_CLOSE,"CCEexit")
	GuiCtrlCreateLabel("Click on Continue when Pegasus is running", 10, 20, 210, 20)
	GuiCtrlCreateLabel("or on Exit to exit Check for new mail", 10, 40, 200, 20)
	GuiCtrlCreateButton("Continue", 10, 70)
	GUICtrlSetOnEvent(-1,"CCEcontinue")
	GuiCtrlCreateButton("Exit", 170, 70)
	GUICtrlSetOnEvent(-1,"CCEexit")
	GuiSetState()
	$CCEans = ""
	While $CCEans=""
		Sleep(50)
	WEnd
	GUIDelete()
	Return $CCEans
EndFunc

Func CCEcontinue()
	$CCEans = "c"
EndFunc

Func CCEexit()
	$CCEans = "e"
EndFunc
#ce
Func CountCNMs()	; count messages in Inbox
Local $search,$qfiles
	$search = FileFindFirstFile($cnmDriveLtr&"\PMAIL\MAIL\*.cnm")  
	If $search = -1 Then
		Return 0
	Else
		$qfiles = 0
		While 1
			FileFindNextFile($search)
			If @error Then ExitLoop	; if no more files
			$qfiles = $qfiles + 1
		WEnd
		FileClose($search)
		Return $qfiles
	EndIf
EndFunc
 
Func FindPegasusDrive()	; returns, e.g. h:
Local $i,$drv,$drvs,$search,$err
	$drvs = DriveGetDrive("Fixed")
	For $i = 1 to $drvs[0]
		$drv = $drvs[$i]
		$search = FileFindFirstFile($drv&"\PMAIL\MAIL\*.cnm")  
		if $search<>-1 Then
			FileClose($search)
			Return $drv
		EndIf
	Next
	Return ""
EndFunc

func WaitForPegasusToRun()
Local $found
	$found = False
	For $i = 1 to 60
		If WinExists("Pegasus Mail") Then
			$found = True
			ExitLoop
		EndIf
		Sleep(1*1000)
	Next
	If Not $found Then
		MsgBox(4096,$macroname,"Pegasus is not running, so I quit")
		Exit
	EndIf
EndFunc	