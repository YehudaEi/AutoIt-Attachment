#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>

;Application writtien by Bruce Evans and Tim Addy of Synergetics DCS for Southern Research
;to manipulate the TimeClock and Wincati Interviewer applications in the attempt
;to sync the employees time in and time out entries. It also forces them not to 
;forget to log out or goto break

__steam_window('SOUTHERN RESEARCH GROUP', 600, 300) ; WIDTH NOT SMALLER THEN 400 | HEIGHT NOT SMALLER THEN 200 === TRUST ME

Func __steam_window($sWINDOW_TITLE, $iWINDOW_WIDTH, $iWINDOW_HEIGHT)
	Local $oWINDOW = GUICreate($sWINDOW_TITLE, $iWINDOW_WIDTH, $iWINDOW_HEIGHT, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU, $WS_MINIMIZEBOX), $WS_EX_LAYERED) ; BitOR($WS_EX_TOOLWINDOW, $WS_EX_LAYERED))
	GUISetFont(12, 400, 0, 'Tahoma')
	GUISetBkColor(0x494E49)
	GUICtrlCreatePic('hdr.bmp', 0, 0, $iWINDOW_WIDTH - 16, 20, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 16, 0, 11, 5, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 16, 16, 11, 4, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 5, 0, 5, 20, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreateGraphic(0, 20, 1, $iWINDOW_HEIGHT)
	GUICtrlSetColor(-1, 0x686A65)
	GUICtrlCreateGraphic($iWINDOW_WIDTH - 1, 20, 1, $iWINDOW_HEIGHT)
	GUICtrlSetColor(-1, 0x686A65)
	GUICtrlCreateGraphic(0, $iWINDOW_HEIGHT - 1, $iWINDOW_WIDTH, 1)
	GUICtrlSetColor(-1, 0x686A65)
	Local $oCLOSE = GUICtrlCreatePic('cls.bmp', $iWINDOW_WIDTH - 16, 5, 11, 11, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	Local $oLABELHEADER = GUICtrlCreateLabel($sWINDOW_TITLE, 6, 0, $iWINDOW_WIDTH - 22, 20, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0xD8DED3)
	GUICtrlSetBkColor(-1, 0x5A6A50)
	
	#cs ==============================
	EXAMPLE SECTION ==================
	#ce ==============================
	
	;Login Button
	Local $oBUTTON_1 = GUICtrlCreateButton('LOG IN', 10, 30, 140, 20)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		GUICtrlSetState ( $oBUTTON_1, $GUI_DEFBUTTON )
	;Cancel Button
	Local $oBUTTON_2 = GUICtrlCreateButton('CANCEL', 10, 60, 140, 20)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
	
	
	
	GUICtrlCreateGraphic(1, 20, 160, $iWINDOW_HEIGHT - 21)
		GUICtrlSetColor(-1, 0x464646)
		GUICtrlSetBkColor(-1, 0x464646)
	
	GUICtrlCreateGraphic(158, 20, 1, $iWINDOW_HEIGHT - 21)
		GUICtrlSetColor(-1, 0x3D423D)
	
	GUICtrlCreateGraphic(159, 20, 1, $iWINDOW_HEIGHT - 21)
		GUICtrlSetColor(-1, 0x424742)
	
	GUICtrlCreateGraphic(160, 20, 1, $iWINDOW_HEIGHT - 21)
		GUICtrlSetColor(-1, 0x454A45)
	
	;Code to create label above entry text boxes
	$oLABELTOP = GUICtrlCreateLabel('WINCATI AND TIMECLOCK DUAL LOGIN', 180, 31, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		GUICtrlSetColor(-1, 0xC4B550)
	
	GUICtrlCreateGraphic(170, 51, $iWINDOW_WIDTH - 180, 1)
		GUICtrlSetColor(-1, 0x636763)
	
	;Code for Enter ID Number control Label
	GUICtrlCreateLabel('Enter ID number:', 250, 70, 150, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		GUICtrlSetColor(-1, 0xE6ECE0)

	;Code for Enter ID Number control Input Box
	global $oInput_1 = GUICtrlCreateInput('', 420, 70, 90, 20,0x2000)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		local $oLimit_1 = GUICtrlSetLimit(-1, 7)
		GUICtrlSetState($oInput_1,$GUI_FOCUS)
	
		;Code for Select Job Code control Label
		GUICtrlCreateLabel('Select Job Code:', 250, 100, 150, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
			GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
			GUICtrlSetColor(-1, 0xE6ECE0)
		;Code for Select Job Code control Input Box
		global $oInput_2 = GUICtrlCreateInput('', 420, 100, 50, 20,0x2000)
			GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
			local $oLimit_2 = GUICtrlSetLimit(-1, 3)
	
	;Code for Costing Code control Label
	GUICtrlCreateLabel('Costing Code:', 250, 130, 150, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xE6ECE0)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
	;Code for Costing Code control Input Box
	local $oInput_3 = GUICtrlCreateInput('', 420, 130, 50, 20,0x2000)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		local $oLimit_3 = GUICtrlSetLimit(-1, 2)
		
		;Code for Interviewer ID control Label
		GUICtrlCreateLabel('Interviewer ID:', 250, 160, 150, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
			GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
			GUICtrlSetColor(-1, 0xE6ECE0)
		;Code for Interviewer ID control Input Box
		local $oInput_4 = GUICtrlCreateInput('', 420, 160, 50, 20,0x2000)
			GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
			local $oLimit_4 = GUICtrlSetLimit(-1, 3)
	
	;Code for Station Number control Label
	GUICtrlCreateLabel('Station Number:', 250, 190, 150, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		GUICtrlSetColor(-1, 0xE6ECE0)
	;Code for Station Number control Input Box
	local $oInput_5 = GUICtrlCreateInput('', 420, 190, 50, 20,0x2000)
		GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
		local $oLimit_5 = GUICtrlSetLimit(-1, 3)
	
		;Code for Study List control Label
		GUICtrlCreateLabel('Study List:', 250, 220, 150, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
			GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
			GUICtrlSetColor(-1, 0xE6ECE0)
		;Code for Study List control Input Box
		local $oInput_6 = GUICtrlCreateInput('', 420, 220, 50, 20,0x2000)
			GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
			local $oLimit_6 = GUICtrlSetLimit(-1, 3)
	
	; THIS CONTROL NEEDS TO BE LAST DUE TO OVERLAY ISSUES
	GUICtrlCreateGraphic(170, 30, $iWINDOW_WIDTH - 180, $iWINDOW_HEIGHT - 40)
	GUICtrlSetColor(-1, 0x686A65)
	
	#cs ==============================
	EXAMPLE SECTION ==================
	#ce ==============================
	
	GUICtrlCreatePic('cnr.bmp', 0, 0, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('cnr.bmp', $iWINDOW_WIDTH - 1, 0, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('cnr.bmp', 0, $iWINDOW_HEIGHT - 1, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('cnr.bmp', $iWINDOW_WIDTH - 1, $iWINDOW_HEIGHT - 1, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	
	;This is the start of the app that open the main window
	GUISetState(@SW_SHOW)
	
	
	While 1
		Local $eMSG = GUIGetMsg()
		Switch $eMSG
			Case $GUI_EVENT_CLOSE
				;Local $iWINDOW_TRANS
				;For $iWINDOW_TRANS = 255 To 0 Step -10
					;If $iWINDOW_TRANS > 0 Then WinSetTrans($oWINDOW,'',$iWINDOW_TRANS)
 					;Sleep(10)
 				;Next
				Exit
			Case $oCLOSE
 				;Local $iWINDOW_TRANS
 				;For $iWINDOW_TRANS = 255 To 0 Step -10
 					;If $iWINDOW_TRANS > 0 Then WinSetTrans($oWINDOW,'',$iWINDOW_TRANS)
 					;Sleep(10)
 				;Next
				Exit
			Case $oBUTTON_2
				;Local $iWINDOW_TRANS
				;For $iWINDOW_TRANS = 255 To 0 Step -10
					;If $iWINDOW_TRANS > 0 Then WinSetTrans($oWINDOW,'',$iWINDOW_TRANS)
 					;Sleep(10)
 				;Next
				Exit				
				
			;This is the login code. It executes the Time Clock via the ICON on the desktop it
			;must be there and named exactly as the entry under the SHELLEXECUTE() statment
			Case $oButton_1
			
			;Need to add edit checks here, make sure there is data in the text boxes
			
			if GuiCtrlRead($oInput_1) = "" then
				MsgBox(4096,"Enter ID Number Error","There must be a ID Number, the program will exit now!") 
				Exit
			endif
			if GuiCtrlRead($oInput_2) = "" then
				MsgBox(4096,"Select Job Code Error","There must be a Job Code, the program will exit now!")
				Exit
			endif
			if GuiCtrlRead($oInput_3) = "" then
				MsgBox(4096,"Costing Code Error","There must be a Costing Code, the program will exit now!")
				Exit
			endif
			if GuiCtrlRead($oInput_4) = "" then
				MsgBox(4096,"Interviewer ID Error","There must be a Interviewer ID, the program will exit now!")
				Exit
			endif
			if GuiCtrlRead($oInput_5) = "" then
				MsgBox(4096,"Station Number Error","There must be a Station Number, the program will exit now!")
				Exit
			endif
			if GuiCtrlRead($oInput_6) = "" then
				MsgBox(4096,"Study List Error","There must be a Study List, the program will exit now!")
				Exit
			endif
			
			GUISetState(@SW_HIDE)
			
			
;**** Start of warning box to user about not touching mouse or keyboard during automation process			
;************************************************************************************************************************			
				$WarnVar = GuiCreate("DUAL LOGIN *** Usage WARNING  ***", 440, 160,-1, -1 , $DS_MODALFRAME)
					GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')

				GUICtrlCreateLabel('DO NOT TOUCH KEYBOARD OR MOUSE', 30, 10, 338, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
					GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
					GUICtrlSetColor(-1, 0xff0000)
				
				GUICtrlCreateLabel('UNTIL YOU SEE THE WINCATI', 30, 35, 300, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
					GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
					GUICtrlSetColor(-1, 0xff0000)
				
				GUICtrlCreateLabel('INTERVIEWER SCREEN', 30, 60, 275, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
					GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
					GUICtrlSetColor(-1, 0xff0000)
				
				Local $oOK_1 = GUICtrlCreateButton('OK', 170, 85,80,40)
					GUICtrlSetFont(-1, 12, 800, 0, 'Tahoma')
					GUICtrlSetState ( $oOK_1, $GUI_DEFBUTTON )
				

				GuiSetState()
				$MyOK = 0
				While $MyOK = 0
				$msg = GuiGetMsg() 
					Select
						Case $msg = $oOK_1
						GUISetState(@SW_HIDE)
						ExitLoop
						
					EndSelect
				
				WEnd
;************************************************************************************************************************
;**** End of warning box to user about not touching mouse or keyboard during automation process

;**** Start of dual login process
;************************************************************************************************************************
				;*** Launch the time clock software, NOTE this link must be a the location shouwn in the shellexecute
				ShellExecute ( "F:\CALL CENTER - OPERATIONS\SRG  Folder\On-Screen TimeClock.lnk","", "" )
				;*** Now Wait 5 seconds for the Time Clock to load, my vary on different machines, may have to increase for slowest system
				Sleep(5000)
				;*** This ENTER is to launch the "Clock IN" process
				Send("{ENTER}")
				;*** Now wait 1 second for the input box to open
				Sleep(1000)
				;*** Now input the varible from input 1
				Send(GuiCtrlRead($oInput_1))
				;*** ENTER again to accespt the input
				Send("{ENTER}")
				
				Sleep(1000)
				Send("{ENTER}")
				Sleep(1000)
				Send(GuiCtrlRead($oInput_2))
				Sleep(1000)
				Send("{ENTER}")
				Sleep(1000)
				Send(GuiCtrlRead($oInput_3))
				Sleep(4000)
				
				;This is the login to the Interviewer code. It executes the WinCati via the ICON on the desktop it
				;must be there and named exactly as the entry under the SHELLEXECUTE() statment
				ShellExecute ( "F:\CALL CENTER - OPERATIONS\SRG  Folder\Interviewer.lnk","", "" )
				;**** Now Wait 5 seconds for the Interviewer to load, my vary on different machines, may have to increase for slowest system
				Sleep(5000)
				
				Send(GuiCtrlRead($oInput_4))
				Sleep(1000)
				Send("{TAB}")
				Send(GuiCtrlRead($oInput_5))
				Sleep(1000)
				Send("{TAB}")

				Sleep(1000)
				Send(GuiCtrlRead($oInput_6))
				Sleep(1000)	
				Send("{TAB}")
				Send("{ENTER}")
				Sleep(2000)
				WinActivate("Costing Code Selection")
				Send("{ENTER}")
				
				;***************************************************************************************************
				;**** We want to minimize both the duallogon and time clock windows so the Interviewer is on top ***
				;***************************************************************************************************
				
				WinSetState ( "TimeClock Plus","", @SW_MINIMIZE )
				WinSetState ( "SOUTHERN RESEARCH GROUP","", @SW_MINIMIZE )
				

				;**** Now call the Check WinCati function to loop until the WinCati Interviewer window close.
				;*********************************************************************************************
				CheckWincati()
				
			;EndFunc
			
		EndSwitch ;??????????
	WEnd ;????????????????????
EndFunc

;**** This is the loop that watches for the interviewer windows to close
;*********************************************************************************
func CheckWincati()
	
	
	
	While WinExists("WinCati 4.1 Interviewer") = 1 
		
		;**** Checking every 2 seconds to see if it has closed
		;*****************************************************
		sleep("2000")
		ContinueLoop
		
	Wend	
	
	;Set global vars for next bit of code before moving on.
Opt("GUIOnEventMode", 0)
	;**** If the WinCati Interviewer closes then run the "Log out of interviewer" function
	;***************************************************************************************
	;Logoutofintview()
	CreateLogoutWindow()
EndFunc				
Func CreateLogoutWindow()
	
	;**** Change window processing to On Event Mode!!!!!
	Opt("GUIOnEventMode", 1)
	
					global $Radio_1
					global $Radio_2
					global $Radio_3
					global $Radio_4
					global $MyLoopCounter
					global $Logoutmsg
					global $MyExitDialog
	
	if WinExists("Log Out Type Selection")  = 1 then
		;WinClose("Log Out Type Selection")
		WinSetState ( "Log Out Type Selection","", @SW_RESTORE )
		GUICtrlDelete($Radio_1)
		GUICtrlDelete($Radio_2)
		GUICtrlDelete($Radio_3)
		GUICtrlDelete($Radio_4)
		;$Radio_1 = GuiCtrlCreateRadio("Log Out Completely", 30, 20, 190, 15)
		;GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		;GUICtrlSetOnEvent(-1, "Option1checked")
		;$Radio_2 = GuiCtrlCreateRadio("Log Out for Paid Break", 30, 40, 190, 15)
		;GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		;GUICtrlSetOnEvent(-1, "Option2checked")
		;$Radio_3 = GuiCtrlCreateRadio("Log Out for UN-Paid Break",30, 60, 190, 15)
		;GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		;GUICtrlSetOnEvent(-1, "Option3checked")
		;$Radio_4 = GuiCtrlCreateRadio("Go Back Into Interviwer",30, 80, 190, 15)
		;GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		;GUICtrlSetOnEvent(-1, "Option4checked")
		
	Else
	
		
	$MyExitDialog = GuiCreate("Log Out Type Selection", 260, 120,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	
	endif
	$Radio_1 = GuiCtrlCreateRadio("Log Out Completely", 30, 20, 190, 15)
		GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		GUICtrlSetOnEvent($Radio_1, "Option1checked")
		
	$Radio_2 = GuiCtrlCreateRadio("Log Out for Paid Break", 30, 40, 190, 15)
		GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		GUICtrlSetOnEvent($Radio_2, "Option2checked")
	$Radio_3 = GuiCtrlCreateRadio("Log Out for UN-Paid Break",30, 60, 190, 15)
		GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		GUICtrlSetOnEvent($Radio_3, "Option3checked")
	$Radio_4 = GuiCtrlCreateRadio("Go Back Into Interviwer",30, 80, 190, 15)
		GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
		GUICtrlSetOnEvent($Radio_4, "Option4checked")
		
	GuiSetState(@SW_SHOW,$MyExitDialog)
	
	
	$MyLoopCounter = 60
	
	While 1
        if $MyLoopCounter <= 0 Then
			Option1checked()
		EndIf
		sleep(1000)
		$MyLoopCounter = $MyLoopCounter - 1
    WEnd
EndFunc

	Func Option1checked()
		WinActivate("TimeClock Plus")
		Send("{TAB}")
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		Send(GuiCtrlRead($oInput_1))
		Sleep(2000)
		Send("{ENTER}")
		Sleep(5000)
		Send("{ENTER}")
		Sleep(5000)
		$Logoutmsg = "You have Logged out of the System"
		GUICtrlSetState($Radio_1,$GUI_UNCHECKED)
		MyExit()
	EndFunc			
	
	Func Option2checked()
		WinActivate("TimeClock Plus")
		Send("{TAB}")
		Sleep(2000)
		Send("{TAB}")
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		Send("P")
		Sleep(2000)
		Send(GuiCtrlRead($oInput_1))
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		$Logoutmsg = "You have Logged out on PAID Break"
		GUICtrlSetState($Radio_2,$GUI_UNCHECKED)
		MyExit()
	EndFunc
	
	Func Option3checked()
		WinActivate("TimeClock Plus")
		Send("{TAB}")
		Sleep(2000)
		Send("{TAB}")
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		Send("N")
		Sleep(2000)
		Send(GuiCtrlRead($oInput_1))
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		Send("{ENTER}")
		Sleep(2000)
		$Logoutmsg = "You have Logged out on NON-PAID Break"
		GUICtrlSetState($Radio_3,$GUI_UNCHECKED)
		MyExit()
	EndFunc
	
	Func Option4checked()
		
		GUICtrlSetState($Radio_4,$GUI_UNCHECKED)
		ShellExecute ( "F:\CALL CENTER - OPERATIONS\SRG  Folder\Interviewer.lnk","", "" )
		WinSetState ( "Log Out Type Selection","", @SW_MINIMIZE )
		WinClose("Log Out Type Selection")
		sleep(1500)
		
		
		CheckWincati()
	EndFunc
	Func MyExit()
		
	if ProcessExists("wintck32.exe") Then
		ProcessClose("wintck32.exe")
	EndIf
	;MsgBox(4096,"Time Clock Automation","You are now logged out!")
	MsgBox(4096,"Time Clock Automation",$Logoutmsg)
	Exit
		
	EndFunc

;**** This section runs for the user to choose if they want to logout, 3 different ways or go back into Interviewer"
func Logoutofintview()	
		
	msgbox(4096,"Here","1")
	
	;Global $MyExitDialog
	global $MyLoopCounter
	
	;msgbox(4096,"Window Exist",WinExists("Log Out Type Selection"))
	
	;if WinExists("Log Out Type Selection")  = 1 then
		;GUICtrlDelete($MyExitDialog)
		;GUICtrlDelete($Radio_1)
		;GUICtrlDelete($Radio_2)
		;GUICtrlDelete($Radio_3)
		;GUICtrlDelete($Radio_4)
		;GuiSetState(@SW_SHOW + @SW_ENABLE,$MyExitDialog)
		
		;GUICtrlSetState($Radio_1,$GUI_UNCHECKED)
		;GUICtrlSetState($Radio_2,$GUI_UNCHECKED)
		;GUICtrlSetState($Radio_2,$GUI_UNCHECKED)
		;GUICtrlSetState($Radio_2,$GUI_UNCHECKED)
		;GUISetState(@SW_SHOW,$MyExitDialog)
	;else
		CreateLogoutWindow()
	;EndIf
	
	$MyExit = 0
	$MyLoopCounter = 60
	$Logoutmsg = "Error in Logout, see Administrator"
	;GuiSetState(@SW_SHOW)
	
	While $MyExit = 0
		$msg = GuiGetMsg()
		
		;if $MyLoopCounter = 0 Then ;Timer to force log out after 60 seconds
			;same as $radio_1 below
			;WinActivate("TimeClock Plus")
			;Send("{TAB}")
			;Sleep(2000)
			;Send("{ENTER}")
			;Sleep(2000)
			;Send(GuiCtrlRead($oInput_1))
			;Sleep(2000)
			;Send("{ENTER}")
			;Sleep(5000)
			;Send("{ENTER}")
			;Sleep(5000)
			;$Logoutmsg = "You have Logged out of the System Automatilly"
			;$MyExit = 1
		;Else
			 
			Select
				;Case $msg = $GUI_EVENT_CLOSE
					;ExitLoop
		
				Case $msg = $Radio_1 ;Log out completely
					;GUISetState(@SW_HIDE + @SW_DISABLE)	
					;Time Clock - logout
					WinActivate("TimeClock Plus")
					Send("{TAB}")
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					Send(GuiCtrlRead($oInput_1))
					Sleep(2000)
					Send("{ENTER}")
					Sleep(5000)
					Send("{ENTER}")
					Sleep(5000)
					$Logoutmsg = "You have Logged out of the System"
					$MyExit = 1

	
				Case $msg = $Radio_2
					;GUISetState(@SW_HIDE + @SW_DISABLE)
					;Time Clock - Paid Break
					WinActivate("TimeClock Plus")
					Send("{TAB}")
					Sleep(2000)
					Send("{TAB}")
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					Send("P")
					Sleep(2000)
					Send(GuiCtrlRead($oInput_1))
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					$Logoutmsg = "You have Logged out on PAID Break"
					$MyExit = 1

				Case $msg = $Radio_3
					;GUISetState(@SW_HIDE + @SW_DISABLE)
					;Time Clock - Non-Paid Break
					WinActivate("TimeClock Plus")
					Send("{TAB}")
					Sleep(2000)
					Send("{TAB}")
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					Send("N")
					Sleep(2000)
					Send(GuiCtrlRead($oInput_1))
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					Send("{ENTER}")
					Sleep(2000)
					$Logoutmsg = "You have Logged out on NON-PAID Break"
					$MyExit = 1

				Case $msg = $Radio_4()
					GUISetState(@SW_HIDE + @SW_DISABLE,$MyExitDialog)
					GUICtrlSetState($Radio_4,$GUI_UNCHECKED)
					ShellExecute ( "F:\CALL CENTER - OPERATIONS\SRG  Folder\Interviewer.lnk","", "" )
					sleep(1500)
					$MyExit = 1
					CheckWincati()
				Case Else
				;;;
			EndSelect
	
		;EndIf

		;sleep("1000")
		;$MyLoopCounter = $MyLoopCounter - 1

	WEnd


	if ProcessExists("wintck32.exe") Then
		ProcessClose("wintck32.exe")
	EndIf
	
	
	;MsgBox(4096,"Time Clock Automation","You are now logged out!")
	
	MsgBox(4096,"Time Clock Automation",$Logoutmsg)
	Exit
EndFunc