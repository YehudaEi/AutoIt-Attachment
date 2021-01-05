; AutoIt Version: 3.1.0
; Language:       English
; Platform:       Win9x(untested on XP, Linux, Unix, ect...)
; Author:         CLeeRVu1kan
;
; Script Function:
;   Launch all programs required
;	to connect to the Internet
;	and connect using one of a
;	variety of connectoids
;If you want to use this script, it will require a bit of modding...all places that need to be adjusted are marked with '|-o-|'
;=============================
Opt ('TrayIconHide', 1)
#include <GuiConstants.au3>
GUICreate("Internet Automation", 392, 323, (@DesktopWidth - 392) / 2, (@DesktopHeight - 323) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUICtrlCreateLabel("The keyboard and mouse will not function while the Autolauncher does it's thing.", 20, 20, 200, 30)
GUICtrlCreateLabel("04-08-05/CLeeRVu1kan", 260, 10, 120, 20)
$Button_go = GUICtrlCreateButton("Go!", 240, 280, 60, 30)
$Button_nogo = GUICtrlCreateButton("No Go", 320, 280, 60, 30)
GUICtrlSetState(-1, $GUI_Focus)
;Firewall
$Checkbox_firewall = GUICtrlCreateCheckbox("Armor2Net", 30, 80, 80, 20) ;|-o-| You may want to change these so it'll look nice
GUICtrlSetState(-1, $GUI_Checked)
;Popupblocker
$Checkbox_killad = GUICtrlCreateCheckbox("KillAd", 30, 100, 80, 20);|-o-|
GUICtrlSetState(-1, $GUI_Checked)
;Browser
$Checkbox_fx = GUICtrlCreateCheckbox("MozillaFx", 30, 120, 70, 20);|-o-|
GUICtrlSetState(-1, $GUI_Checked)
;alternate browser
$Checkbox_ie = GUICtrlCreateCheckbox("Internet Explorer", 100, 120, 100, 20);|-o-|
;Messenger
$Checkbox_ymess = GUICtrlCreateCheckbox("Y!Mess", 30, 140, 70, 20);|-o-|
GUICtrlSetState(-1, $GUI_Checked)
;Alternate Messenger
$Checkbox_tril = GUICtrlCreateCheckbox("Trillian", 100, 140, 80, 20);|-o-|
GUICtrlCreateLabel("It wil launch the following programs:", 10, 60, 170, 20)
;Dialup networking connectoids
$Radio_alltel = GUICtrlCreateRadio("Alltel", 100, 210, 70, 20);|-o-|
GUICtrlSetState(-1, $GUI_Checked);|-o-|
$Radio_earthlink = GUICtrlCreateRadio("Earthlink", 100, 230, 70, 20);|-o-|
;Free connectoids
$Radio_juno = GUICtrlCreateRadio("Juno", 50, 250, 50, 20);|-o-|
$Radio_netzero = GUICtrlCreateRadio("NetZero", 100, 250, 70, 20);|-o-|
GUICtrlCreateGroup("Connectoid", 30, 200, 150, 80)
;And this was throwen in for the heck of it
GUICtrlCreateDate("Date16", 20, 290, 190, 20)
GUICtrlCreateLabel('Place a Checkmark in the boxes next to the programs you want to use, and click on ''Go!''', 220, 80, 100, 70)
GUICtrlCreateGroup("Instuctions", 210, 60, 110, 100)
;This line only works if you have Y!Mess
GUICtrlCreatePic('C:\Program Files\Yahoo!\Messenger\Media\Smileys\16.gif', 255, 180, 40, 40)
GUICtrlCreateLabel('It took almost 6 hours of programming to make this!', 200, 230, 150, 40)
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button_nogo
			ExitLoop
		Case $msg = $Button_go
			GUISetState(@SW_HIDE)
			BlockInput(1)
			SplashTextOn('Internet Automation---Working', 'The keyboard and the mouse will be disabled _
					while the computer is automaticly prepared to surf.', 300, 65)
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
				Case GUICtrlRead($Checkbox_firewall) = $GUI_Checked
					Run('c:\Program Files\Armor2net\Armor2net Personal Firewall\armor2net.exe');|-o-| Insert your firewall info here
					Sleep(5000)
				Case GUICtrlRead($Checkbox_firewall) = $GUI_UNCHECKED
					SplashOff()
					BlockInput(0)
					$nf = MsgBox(16, 'NO!', 'You cannot surf without a firewall, Try Again!')
					IF $nf = 1 Then Exit
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_killad) = $GUI_Checked
					Run('c:\Program Files\killad\killad.exe');|-o-| Insert your popup blocker here
					Sleep(2000)
				Case GUICtrlRead($Checkbox_killad) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_fx) = $GUI_Checked
					Run('c:\Program Files\Mozilla Firefox\firefox.exe');|-o-| I would hope you wouldn't have to change this one...
					WinWait('Mozilla Firefox') ;|-o-|
				Case GUICtrlRead($Checkbox_fx) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_ie) = $GUI_Checked
					Run('C:\Program Files\Internet Explorer\IEXPLORE.EXE');|-o-| and this one was just included for ppl still using it
					WinWait('about:blank - Microsoft Internet Explorer') ;|-o-|
				Case GUICtrlRead($Checkbox_ie) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_ymess) = $GUI_Checked
					Run('C:\Program Files\Yahoo!\Messenger\YPager.exe');|-o-| if you use msn plug it in here
					WinWait('Yahoo! Messenger') ;|-o-|
				Case GUICtrlRead($Checkbox_ymess) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			Select
				Case GUICtrlRead($Checkbox_tril) = $GUI_Checked
					Run('c:\Program Files\Trillian\trillian.exe');|-o-| and trillian is avaliable(and free) just google it
					Sleep(5000)
				Case GUICtrlRead($Checkbox_tril) = $GUI_UNCHECKED
					Sleep(500)
			EndSelect
			;---connectoids
			Select
				Case GUICtrlRead($Radio_alltel) = $GUI_Checked
					Run('rundll rnaui.dll,RnaDial Alltel');|-o-| if you use WinDUN(dial up networking), plug the name of yours in here
					WinWaitActive('Connect To', 'Alltel');|-o-| and here
					BlockInput(0)
					Send('{ENTER}')
				Case GUICtrlRead($Radio_earthlink) = $GUI_Checked
					Run('rundll rnaui.dll,RnaDial Earthlink');|-o-| I have several accounts,
					WinWaitActive('Connect To', 'Earthlink');|-o-| If you don't, delete these other 3
					BlockInput(0)
					Send('{ENTER}')
				Case GUICtrlRead($Radio_juno) = $GUI_Checked
					Run('C:\Program Files\Juno\exec.exe');|-o-|
					WinWaitActive('Login to Juno');|-o-|
					BlockInput(0)
					Send('{ENTER}')
				Case GUICtrlRead($Radio_netzero) = $GUI_Checked
					Run('C:\Program Files\NetZero\exec.exe');|-o-|
					WinWaitActive('Login to NetZero');|-o-|
					BlockInput(0)
					Send('{ENTER}')
			EndSelect
			SplashOff()
			SplashTextOn('Internet Automation---Finished', 'Finished, Connecting...', 200, 25, -1, -1, 4)
			Sleep(5000)
			SplashOff()
			ExitLoop
	EndSelect
WEnd
Exit
;And that's it.  all in all you'd have to change 27 items to make this autolauncher work for you.  Peace :)>-