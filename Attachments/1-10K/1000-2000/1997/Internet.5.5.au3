; AutoIt Version: 3.1.0
; SciTE Version: 1.62
;	Code(?I dunno if this is the right term) Version: 1.0.3
; Script Version: 5.5.1
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
;
;
#cs You'll need to modify the program 
 	paths for this script to work for 
	you; all places requiring your 
#ce	input have been marked with ;|-o-|
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
$Checkbox_firewall = GUICtrlCreateCheckbox("Firewall", 30, 80, 80, 20);|-o-| you may want to change the names of the programs
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_killad = GUICtrlCreateCheckbox("PopUp Blocker", 30, 100, 90, 20);|-o-| just to make it look prettier
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_fx = GUICtrlCreateCheckbox("MozillaFx", 30, 120, 70, 20);|-o-|
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_ie = GUICtrlCreateCheckbox("Internet Explorer", 100, 120, 100, 20);|-o-|
$Checkbox_ymess = GUICtrlCreateCheckbox("Y!Mess", 30, 140, 70, 20)
GUICtrlSetState(-1, $GUI_Checked)
$Checkbox_tril = GUICtrlCreateCheckbox("Trillian", 100, 140, 80, 20);|-o-|
$Radio_alltel = GUICtrlCreateRadio("Alltel", 100, 210, 70, 20);|-o-|
GUICtrlSetState(-1, $GUI_Checked)
$Radio_earthlink = GUICtrlCreateRadio("Earthlink", 100, 230, 70, 20);|-o-|
$Radio_juno = GUICtrlCreateRadio("Juno", 50, 250, 50, 20);|-o-|
$Radio_netzero = GUICtrlCreateRadio("NetZero", 100, 250, 70, 20);|-o-|
GUICtrlCreateGroup("Connectoid", 30, 200, 150, 80)
GUICtrlCreateDate("Date16", 20, 290, 190, 20)
GUICtrlCreateGroup("Instuctions", 210, 60, 110, 100)
GUICtrlCreateLabel('Place a checkmark in the boxes next to the programs you want to use, and click on ''Go!''', 220, 80, 95, 70)
GUICtrlCreatePic('C:\Program Files\Yahoo!\Messenger\Media\Smileys\16.gif', 255, 180, 40, 40);|-o-| this image will only display if you have Yahoo!Messenger
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
			GUICtrlRead($Checkbox_firewall)
			GUICtrlRead($Checkbox_killad)
			GUICtrlRead($Checkbox_fx)
			GUICtrlRead($Checkbox_ie)
			GUICtrlRead($Checkbox_ymess)
			GUICtrlRead($Checkbox_tril)
			GUICtrlRead($Radio_alltel)
			GUICtrlRead($Radio_earthlink)
			GUICtrlRead($Radio_juno)
			GUICtrlRead($Radio_netzero)
			Select
				Case GUICtrlRead($Checkbox_fx) = $GUI_Checked And GUICtrlRead($Checkbox_ie) = $GUI_Checked
				SplashOff()
				BlockInput(0)
				$fxie = MsgBox(262148, 'Oops!', 'You have both Firefox and Internet Explorer set to run.  Are you sure you need two browsers?')
				IF $fxie = 7 Then ExitLoop
			EndSelect
			Select
				Case ProcessExists('AVGCTRL.exe');|-o-|Input your virus guard(I would hope you have one)
					Sleep(500)
				Case Not ProcessExists('AVGCTRL.exe');|-o-|see above
					SplashOff()
					BlockInput(0)
					$nv = MsgBox(262160, 'NO!', 'You cannot surf without a Virus Guard, Try Again!')
					Run('C:\Program Files\AVPersonal\AVGCTRL.EXE');|-o-| see above
					IF $nv = 1 Then Run('C:\Program Files\AVPersonal\AVGCTRL.EXE');|-o-| see above
					IF $nv = 1 Then ExitLoop
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_firewall) = $GUI_Checked
					Run('C:\Program Files\Sygate\SPF\Smc.exe');|-o-|input your firewall
					ProcessWait('smc.exe');|-o-| see above
					Sleep(3000)
				Case GUICtrlRead($Checkbox_firewall) = $GUI_UNCHECKED
					SplashOff()
					BlockInput(0)
					$nf = MsgBox(262160, 'NO!', 'You cannot surf without a firewall, Try Again!')
					IF $nf = 1 Then ExitLoop
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_killad) = $GUI_Checked
					Run('c:\Program Files\killad\killad.exe');|-o-|Input your popup blocker/killer(or google this one...it rocks)
					Sleep(2000)
				Case GUICtrlRead($Checkbox_killad) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_fx) = $GUI_Checked
					Run('c:\Program Files\Mozilla Firefox\firefox.exe');|-o-|if you use Fx you shouldn't need to change this one
					WinWait('Mozilla Firefox')
					Sleep(2000)
				Case GUICtrlRead($Checkbox_fx) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_ie) = $GUI_Checked
					Run('C:\Program Files\Internet Explorer\IEXPLORE.EXE');|-o-|if you use MSIE you shouldn't need to change this one
					WinWait('about:blank - Microsoft Internet Explorer')
					Sleep(2000)
				Case GUICtrlRead($Checkbox_ie) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_ymess) = $GUI_Checked
					Run('C:\Program Files\Yahoo!\Messenger\YPager.exe');|-o-|if you use Y!Mess this one should be okay,
					WinWait('Yahoo! Messenger');|-o-|you only need to change it if your IM client is ICQ, AolIM, or MSNMess
					Sleep(5000)
				Case GUICtrlRead($Checkbox_ymess) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_tril) = $GUI_Checked
					Run('c:\Program Files\Trillian\trillian.exe');|-o-|A multi messenger program, it supports the Yahoo! nework, ICQ, AolIM, MSNMess and a couple others
					Sleep(5000)
				Case GUICtrlRead($Checkbox_tril) = $GUI_UNCHECKED
					Sleep(500)
				EndSelect
;			---connectoids
			Select
				Case GUICtrlRead($Radio_alltel) = $GUI_Checked
					Run('rundll rnaui.dll,RnaDial Alltel');|-o-|Input the name of your WinDUN connectoid in place of 'Alltel'
					WinWaitActive('Connect To', 'Alltel');|-o-|(unless you're unlucky enough to have to use them as well)
					Sleep(2000)
					BlockInput(0)
					Send('{ENTER}')
				Case GUICtrlRead($Radio_earthlink) = $GUI_Checked
					Run('rundll rnaui.dll,RnaDial Earthlink');|-o-|Input your secondary connectoid here, unless you don't have
					WinWaitActive('Connect To', 'Earthlink');|-o-| two or more, in that case, delete this
					Sleep(2000)
					BlockInput(0)
					Send('{ENTER}')
				Case GUICtrlRead($Radio_juno) = $GUI_Checked
					Run('C:\Program Files\Juno\exec.exe');|-o-|A free ISP(ya only get 10 hrs/month), if you're interested, google 'em
					WinWaitActive('Login to Juno')
					Sleep(2000)
					BlockInput(0)
					Send('{ENTER}')
				Case GUICtrlRead($Radio_netzero) = $GUI_Checked
					Run('C:\Program Files\NetZero\exec.exe');|-o-|see above
					WinWaitActive('Login to NetZero')
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
#cs	And that's it!  All in all, to use this autolauncher you'd only have to modify 28 commands!
	A couple of notes:
	1. I initially made this script for my own convineance, hence the funky layout.
	2. If you don't know what WinDUN means, check the 'about' box in the script's GUI.
	3. The only major change in 5.5.1: i added lines to check for a virus guard.
	4. After the intial convineance factor had been satisfied, I had a bunch of end-users trying to use the compiled script to surf 
		with, which is why I added the dialouges about the Firewall, Virus Scanner and using MSIE and FX at the same time.  As well as 
		the'BlockInput's.
	5. Finally, I suggest you use SciTE to do your editing.
#ce	That about covers it...If you can't use the script, at least it's a nice exercise in GUI.  :)>- Peace.