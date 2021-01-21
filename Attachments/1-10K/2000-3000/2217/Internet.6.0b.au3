; AutoIt Version: 3.1.0
; Script Version: 6.0.0
; Language:       English
; Platform:       Win9x
;	(untested on XP, Linux, Unix, ect...)
; Author:         CLeeRVu1kan
;
; Script Function:
;   Launch all programs required
;	to connect to the Internet
;	and connect using one of a
;	variety of connectoids
;===============================
Opt ('TrayIconHide', 1)
#include <GuiConstants.au3>
GUICreate("Internet Automation", 392, 323, (@DesktopWidth - 392) / 2, (@DesktopHeight - 323) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUICtrlCreateLabel("The keyboard and mouse will not function while the Autolauncher does it's thing.", 20, 20, 200, 30)
GUICtrlCreateLabel("04-08-05/CLeeRVu1kan", 260, 10, 120, 20)
$Button_go = GUICtrlCreateButton("Go!", 240, 280, 60, 30)
GUICtrlSetState(-1, $GUI_Focus)
$Button_nogo = GUICtrlCreateButton("No Go", 320, 280, 60, 30)
$Button_abut = GUICtrlCreateButton("About", 320, 30, 60, 20)
GUICtrlCreateLabel("It wil launch the following programs:", 10, 60, 170, 20)
$Checkbox_firewall = GUICtrlCreateCheckbox("Firewall", 30, 80, 80, 20)
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_killad = GUICtrlCreateCheckbox("PopUp Blocker", 30, 100, 90, 20)
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_fx = GUICtrlCreateCheckbox("MozillaFx", 30, 120, 70, 20)
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_ie = GUICtrlCreateCheckbox("Internet Explorer", 100, 120, 100, 20)
$Checkbox_ymess = GUICtrlCreateCheckbox("Y!Mess", 30, 140, 70, 20)
GUICtrlSetState(-1, $GUI_Checked)
$Radio_alltel = GUICtrlCreateRadio("Alltel", 100, 210, 70, 20)
GUICtrlSetState(-1, $GUI_Checked)
$Radio_earthlink = GUICtrlCreateRadio("Earthlink", 100, 230, 70, 20)
GUICtrlCreateGroup("Connectoid", 30, 200, 150, 80)
GUICtrlCreateDate("Date16", 20, 290, 190, 20)
GUICtrlCreateGroup("Instuctions", 210, 60, 110, 100)
GUICtrlCreateLabel('Place a checkmark in the boxes next to the programs you want to use, and click on ''Go!''', 220, 80, 95, 70)
GUICtrlCreatePic('C:\Program Files\Yahoo!\Messenger\Media\Smileys\16.gif', 255, 180, 40, 40)
GUICtrlCreateLabel('It took almost 12 hours of programming to make this!', 200, 230, 150, 40)
$Time = TimerInit()
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button_nogo
			ExitLoop
		Case $msg = $Button_abut
			MsgBox(262208, 'About Autolauncher 5.0.1', 'This Autolauncher is intended for people using Dialup Internet connections, It _
			will launch your firewall, popup blocker, browser, instant messenger, and connect using WinDUN.  All you have to do is_
			modify the program paths, compile it, select the checkboxes next to the programs, and click ''GO!''.  It will only _
			automaticaly dial your Windows Dialup Networking connection if you have the username and password saved.  Created over _
			several weeks by CLeeRVu1kan.  Visit my site:                            .')
		Case $msg = $Button_go or TimerDiff($Time) >= 30000
			BlockInput(1)
			GUISetState(@SW_HIDE)
			If TimerDiff($Time) >= 30000 Then SplashTexton('Too Slow', 'You''re too slow, choices have been made for you', 200, 40)
			If TimerDiff($Time) >= 30000 Then Sleep(3000)
			If TimerDiff($Time) >= 30000 Then Splashoff()
			SplashTextOn('Internet Automation---Working', 'The keyboard and the mouse will be disabled while the computer is _
			automaticly prepared to surf.', 300, 65)
			$Chbxfw = GUICtrlRead($Checkbox_firewall)
			$Chbxpb = GUICtrlRead($Checkbox_killad)
			$Chbxfx = GUICtrlRead($Checkbox_fx)
			$Chbxie = GUICtrlRead($Checkbox_ie)
			$Chbxymess = GUICtrlRead($Checkbox_ymess)
			$Rduone = GUICtrlRead($Radio_alltel)
			$Rdutwo = GUICtrlRead($Radio_earthlink)
			$inivirus = IniRead("Internet.ini", "apps", "virus", 0)
			$inivexe = IniRead("Internet.ini", "apps", "vexe", 0 )
			$inifw = IniRead("Internet.ini", "apps", "fw", 0)
			$inifwexe = IniRead("Internet.ini", "apps", "fwexe", 0)
			$inipop = IniRead("Internet.ini", "apps", "popup", 0)
			$inifx = IniRead("Internet.ini", "apps", "fx", 0)
			$iniie = IniRead("Internet.ini", "apps", "ie", 0)
			$iniymess = IniRead("Internet.ini", "apps", "ymess", 0)
			$inidu = IniRead("Internet.ini", "connectoid", "first", 0)
			$inidu2 = IniRead("Internet.ini", "connectoid", "second", 0)
			Select
				Case $Chbxfx = $GUI_Checked And $Chbxie = $GUI_Checked
				SplashOff()
				BlockInput(0)
				$fxie = MsgBox(262148, 'Oops!', 'You have both Firefox and Internet Explorer set to run.  Are you sure you need two _
				browsers?')
				IF $fxie = 7 Then ExitLoop
			EndSelect
			Select
				Case ProcessExists($inivexe)
					Sleep(500)
				Case Not ProcessExists($inivexe)
					SplashOff()
					BlockInput(0)
					$nv = MsgBox(262160, 'NO!', 'You cannot surf without a Virus Guard, Try Again!')
					IF $nv = 1 Then Run($inivirus)
					IF $nv = 1 Then ExitLoop
			EndSelect
			Select
				Case $Chbxfw = $GUI_Checked
					Select
						Case ProcessExists($inifwexe)
							sleep(500)
						Case Not ProcessExists($inifwexe)
							Run($inifw)
					EndSelect
					ProcessWait($inifwexe)
					Sleep(5000)
				Case $Chbxfw = $GUI_UNCHECKED
					SplashOff()
					BlockInput(0)
					$nf = MsgBox(262160, 'NO!', 'You cannot surf without a firewall, Try Again!')
					IF $nf = 1 Then ExitLoop
				EndSelect
				Select
				Case $Chbxpb = $GUI_Checked
					Run($inipop)
					Sleep(2000)
				Case $Chbxpb = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case $Chbxfx = $GUI_Checked
					Run($inifx)
					WinWait('Mozilla Firefox')
					Sleep(2000)
				Case $Chbxfx = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case $Chbxie = $GUI_Checked
					Run($iniie)
					WinWait('about:blank - Microsoft Internet Explorer')
					Sleep(2000)
				Case $Chbxie = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case $Chbxymess = $GUI_Checked
					Run($iniymess)
					WinWait('Yahoo! Messenger')
					Sleep(5000)
				Case $Chbxymess = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
;			---connectoids
			Select
				Case $Rduone = $GUI_Checked
					Run($inidu)
					WinWaitActive('Connect To', 'User')
					Sleep(2000)
					BlockInput(0)
					Send('{ENTER}')
				Case $Rdutwo = $GUI_Checked
					Run($inidu2)
					WinWaitActive('Connect To', 'User')
					Sleep(2000)
					BlockInput(0)
					Send('{ENTER}')
			EndSelect
		SplashOff()
		SplashTextOn('Automation Finished', 'Finished, Connecting...', 200, 25, -1, -1, 4)
		Sleep(3000)
		SplashOff()
	ExitLoop
EndSelect
WEnd
Exit