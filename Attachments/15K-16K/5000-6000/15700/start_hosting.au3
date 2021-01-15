#include-once
;AutoHost for Delta Force 2 Demo V1.03.04
;by T!G3R
;December 2005


Func AutoHost()
	WriteIni()
	EditDF2cfg()

;First check to see if DF2Demo or BabStats are already open.
	If WinExists("Delta Force 2, Demo V1.03.04") Then		
		IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Already Running] ",  _Now() & " Delta Force 2, Demo V1.03.04 already running. AutoHost session start up terminated.")
		MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is already running on this computer." & @CRLF & "Please shut down Delta Force 2 Demo before starting a hosting session in AutoHost.")
		Return
	EndIf
	If WinExists("BAB.stats v1.2 - DF2DEMO v1.03.04") Then		
		IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [DemoStats Already Running] ",  _Now() & " DemoStats (BAB.stats v1.2) already running. AutoHost session start up terminated.")
		MsgBox(0,"DemoStats Error - AutoHost " & $gVersion, "DemoStats (BAB.stats v1.2) is already running on this computer." & @CRLF & "Please shut down DemoStats before starting a hosting session in AutoHost.")
		Return
	EndIf	
	If GUICtrlRead($BSSwitch) = 1 Then
		If NOT FileExists(GUICtrlRead($BSpath)) Then
		    IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [DemopStats Start Up] ",  _Now() & " Incorrect application path set in AutoHost configuration.")
			MsgBox(0,"DemoStats Load Error - AutoHost " & $gVersion, "DemoStats has been set to ON, but does not exist in directory set in configuration." & @CRLF & "Please return to Configure Tab and either turn off DemoStats option or enter correct directory path.")
			Return
		Else
			Send("#r")
			Sleep(1000)
			;check for BABstats DF2demo config file
			If FileExists(StringReplace(GUICtrlRead($BSpath), "babstats.exe", "df2demo10304.cfg")) Then
				Send('"' & GUICtrlRead($BSpath) & '" df2demo10304.cfg')
			Else
				Send(GUICtrlRead($BSpath))
			EndIf
			Send("{ENTER}")
			WinWaitActive("BAB.stats v1.2 - DF2DEMO v1.03.04")
			Sleep(2000)
		EndIf
	EndIf
	If StringInStr(GUICtrlRead($DFpath),"Df2dem.exe") = 0 Then
		IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Start Up] ",  _Now() & " Incorrect application path set in AutoHost configuration.")
		MsgBox(0,"Delta Force 2 Demo Load Error - AutoHost " & $gVersion, "Delta Force 2 Demo V1.03.04 (Df2dem.exe) does not exist in directory set in configuration." & @CRLF & "Please return to Configure Tab and enter correct directory path.")
		Return
	Else
		If FileExists(GUICtrlRead($DFpath)) Then
			Send("#r")
			Sleep(1000)
			Send(GUICtrlRead($DFpath))
			Send("{ENTER}")
			WinWaitActive("Delta Force 2, Demo V1.03.04")
			;Wait 10 seconds (10000) for the DF2 Demo interface to load (using loop to detect if DF2 Demo has been shut down).
			$pause = GUICtrlRead($StartPause)
			$pause = StringLeft(($pause), 2) * 1000
			$i = 1
			While 1
		    	If NOT WinExists("Delta Force 2, Demo V1.03.04") Then
					IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")
					MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is no longer running.")
					Return
				EndIf	
				If $i = $pause Then ExitLoop
				$i = $i + 1
			WEnd
			Send("a")
			Sleep(1000)
			Send("m")
			Sleep(1000)
			Send("h")
			Sleep(1000)
			Send("o")
			Sleep(1000)
			Send("h")
			IniWrite(@ScriptDir & "\settings.ini","config","AHRB","0")
		Else
			IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Start Up] ",  _Now() & " Incorrect application path set in AutoHost configuration.")
			MsgBox(0,"Delta Force 2 Demo Load Error - AutoHost " & $gVersion, "Delta Force 2 Demo V1.03.04 (Df2dem.exe) does not exist in directory set in configuration." & @CRLF & "Please return to Configure Tab and enter correct directory path.")
			Return
		EndIf
	EndIf

	;Wait for Server to start and map to load (takes about 3 seconds - using loop to detect if DF2 Demo has been shut down).
	$i = 1
	While 1
	   	If NOT WinExists("Delta Force 2, Demo V1.03.04") Then		
			IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")
			MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is no longer running.")
			Return
		EndIf	
		If $i = 3000 Then ExitLoop
		$i = $i + 1
	WEnd
	
	
	;Do First map load error check else move on
	$x = 0
	If WinExists("Program Error") Then
	   	WinActivate("Program Error")
		While WinActive("Program Error")
			$x = $x + 1
			$ErrorText = StringTrimRight(StringTrimLeft(WinGetText("Program Error", ""), 3), 1)
			IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Program Error] "& $x,  _Now() & " " & $ErrorText)
		    Send('{ENTER}')
			Sleep(5000)
		WEnd
		;close send error dialog box
		If WinExists("Df2dem.exe") Then
			Send('{ENTER}')
		EndIf
		Sleep(1000)
		MsgBox(0, "DF2 Demo Pogram Errors - AutoHost " & $gVersion, $x & " Program Errors encounted when starting DF2 Demo." & @CRLF & "Please check the AutoHost error.log file for details.")
		Return
	EndIf
	
	WinWait("Delta Force 2, Demo V1.03.04")

	If NOT WinExists("Delta Force 2, Demo V1.03.04") Then		
		IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")
		MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is no longer running.")
		Return
	EndIf
	WinActivate("Delta Force 2, Demo V1.03.04")
	
	
	
;----------------SET TIMERS AND LOOK FOR CONFLICTS-----------------------
;1 minute = 60000 milliseconds
;5 minutes = 300000 milliseconds
;10 minutes = 600000 milliseconds
;15 minutes = 900000 milliseconds
;20 minutes = 1200000 milliseconds
;25 minutes = 1500000 milliseconds
;30 minutes = 1800000 milliseconds
;35 minutes = 2100000 milliseconds
;40 minutes = 2400000 milliseconds
;45 minutes = 2700000 milliseconds
;50 minutes = 3000000 milliseconds
;55 minutes = 3300000 milliseconds
;60 minutes = 3600000 milliseconds

$PromoteTimeTrigger = StringLeft((GUICtrlRead($PromoteTime)), 2) * 60000
$DSTimeTrigger = StringLeft((GUICtrlRead($StatsTime)), 2) * 60000
$KFNTimeTrigger = StringLeft((GUICtrlRead($KFNTime)), 2) * 60000
$PuntCRCTimeTrigger = StringLeft((GUICtrlRead($PuntCRCTime)), 2) * 60000
$NetDelayTimeTrigger = StringLeft((GUICtrlRead($NetDelayTime)), 2) * 60000
$SDMTimeTrigger = StringLeft((GUICtrlRead($SDMTime)), 2) * 60000
$SHSTimeTrigger = StringLeft((GUICtrlRead($SHSTime)), 2) * 3600000
If GUICtrlRead($RBTime) = "24 hours" Then
	$RBTimeTrigger = 86400000
EndIf
If GUICtrlRead($RBTime) = "Once a week" Then
	$RBTimeTrigger = 604800000
EndIf
If GUICtrlRead($RBTime) = "Once a month" Then
	$RBTimeTrigger = 2419200000
EndIf
;REBOOT TEST TIMER
;$RBTimeTrigger = 60000


;when initiate timer add 3 seconds to cover start up delays...?

Local $NetDelayTimer = TimerInit()
Local $PuntCRCTimer = TimerInit()
Local $PromoteTimer = TimerInit()
Local $DSTimer = TimerInit()
Local $KFNTimer = TimerInit()
Local $ErrorCheckTimer = TimerInit()
Local $IPMTimer = TimerInit()
Local $SHSTimer = TimerInit()
Local $LMTimer = TimerInit()
Local $RBTimer = TimerInit()

While 1

; make sure DF2 Demo exsist and is active
	If WinExists("Delta Force 2, Demo V1.03.04") Then
		If WinActive("Delta Force 2, Demo V1.03.04") Then

;-------------------------------- NetDelay -----------------------------
			If GUICtrlRead($NetDelaySwitch) = 1 Then
			    If TimerDiff($NetDelayTimer) > $NetDelayTimeTrigger Then
			        $NetDelayTimer = TimerInit()
					Send($gComKey)
					Sleep(500)
					Send("netdelay 0")
					Sleep(500)
					Send("{ENTER}")
					Sleep(500)
			    EndIf
			EndIf
;------------------------------- PuntCRC --------------------------------
			If GUICtrlRead($PuntCRCSwitch) = 1 Then
			    If TimerDiff($PuntCRCTimer) > $PuntCRCTimeTrigger Then
			        $PuntCRCTimer = TimerInit()
			        Send($gComKey)
			        Sleep(500)
			        Send("puntcrc")
			        Sleep(500)
					Send("{ENTER}")
					Sleep(500)
			    EndIf
			EndIf
;------------------------------- Promote -------------------------------
			If GUICtrlRead($PromoteSwitch) = 1 Then
				$SendPromoteText = GUICtrlRead($PromoteText)		
				$SendPromoteText = StringReplace($SendPromoteText, "{", "{{}")
				$SendPromoteText = StringReplace($SendPromoteText, "}", "{}}")
				$SendPromoteText = StringReplace($SendPromoteText, "!", "{!}")
				$SendPromoteText = StringReplace($SendPromoteText, "^", "{^}")
				$SendPromoteText = StringReplace($SendPromoteText, "+", "{+}")
				$SendPromoteText = StringReplace($SendPromoteText, "#", "{#}")
			    If TimerDiff($PromoteTimer) > $PromoteTimeTrigger Then
			        $PromoteTimer = TimerInit()
			        Send($gComKey)
			        Sleep(500)
			        Send("talk")
			        Sleep(500)
			        Send("{ENTER}")
			        Sleep(500)
					Send($SendPromoteText & "{ENTER}")
					Sleep(500)
			    EndIf
			EndIf
			If GUICtrlRead($StatsSwitch) = 1 Then
			    If TimerDiff($DSTimer) > $DSTimeTrigger Then
			        $DSTimer = TimerInit()
			        Send($gComKey)
			        Sleep(500)
			        Send("talk")
			        Sleep(500)
			        Send("{ENTER}")
			        Sleep(500)
					Send($gDStext & "{ENTER}")
					Sleep(500)
			    EndIf
			EndIf
			If GUICtrlRead($KFNSwitch) = 1 Then
			    If TimerDiff($KFNTimer) > $KFNTimeTrigger Then
			        $KFNTimer = TimerInit()
			        Send($gComKey)
			        Sleep(500)
			        Send("talk")
			        Sleep(500)
			        Send("{ENTER}")
			        Sleep(500)
					Send($gKFNtext & "{ENTER}")
					Sleep(500)
			    EndIf
			EndIf
;------------------------------- IP Monitor -------------------------------
			If GUICtrlRead($IPMSwitch) = 1 Then
				If TimerDiff($IPMTimer) > 86400000 Then		 ; once every 24 hours
					$IPMTimer = TimerInit()
					$CurrentIP = _CheckIP()
					$OldIP = IniRead("settings.ini","host","WAN_IP","")
					If $OldIP = "(no internet connection)" AND $CurrentIP <> "(no internet connection)" Then
						IniWrite(@ScriptDir & "\settings.ini","host","WAN_IP",$CurrentIP)
						$OldIP = $CurrentIP
					EndIf
					$same = StringInStr($CurrentIP, $OldIP)
					If $same = 0 Then
						IniWrite(@ScriptDir & "\settings.ini","host","WAN_IP",$CurrentIP)
						If $CurrentIP = "(no internet connection)" Then
							$ping = Ping ("novaworld.net") ;ping DF2 lobby, if that is out then shutdown df2
															;just in case it's only checkip.dyndns.org that's down
							If $ping = 0 Then
								Send($gComKey)
						        Sleep(500)
						        Send('quit')
						        Sleep(500)
						        Send('{ENTER}')
								Sleep(500)
								IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Lost Internet connection] ",  _Now() & " Internet connection lost. Ping to NovaWorld Lobby failed. Hosting session terminated. DF2 Demo shutdown.")
								MsgBox(64, "Connection Error - AutoHost " & $gVersion, "Internet connection has been lost." & @CRLF & "DF2 Demo has been shutdown." & @CRLF & "Please check the AutoHost error.log file for details.")
								Return
							EndIf
						Else
							IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [WAN IP dynamic update] ",  _Now() & " IP address changed from " & $OldIP & " to " & $CurrentIP & " - DF2 Demo restarted.")
							Sleep(500)
							Send($gComKey)
			        		Sleep(500)
			        		Send('talk')
			        		Sleep(500)
			        		Send('{ENTER}')
			        		Sleep(500)
						    Send("WAN IP has been updated{!} Restarting DF2 Demo hosting session.....{ENTER}")
							Sleep(5000)
							Send($gComKey)
						    Sleep(500)
						    Send('quit')
						    Sleep(500)
						    Send('{ENTER}')
							Sleep(1000)
							RestartHosting()
						EndIf
					EndIf
				EndIf
			EndIf
;------------------------------- Lobby Monitor -------------------------------
			If GUICtrlRead($LMSwitch) = 1 Then
				If TimerDiff($LMTimer) > 86400000 Then		 ; once every 24 hours
					$LMTimer = TimerInit()
					$ping = Ping ("novaworld.net")
					If $ping = 0 Then
						Send($gComKey)
				        Sleep(500)
				        Send('quit')
				        Sleep(500)
				        Send('{ENTER}')
						Sleep(500)
						IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [NovaWorld Lobby Offline] ", _Now() & " Ping to NovaWorld Lobby failed. Hosting session terminated. DF2 Demo shutdown.")
						MsgBox(64, "NovaWorld Lobby Offline - AutoHost " & $gVersion, "NovaWorld Lobby Offline." & @CRLF & "DF2 Demo has been shutdown." & @CRLF & "Please check the AutoHost error.log file for details.")
						Return
					EndIf
				EndIf
			EndIf
;------------------------------- Shutdown session -------------------------------
			If GUICtrlRead($SHSSwitch) = 1 Then
				If TimerDiff($SHSTimer) > $SHSTimeTrigger Then
					Send($gComKey)
			        Sleep(500)
			        Send("talk")
			        Sleep(500)
			        Send("{ENTER}")
			        Sleep(500)
					Send("This game server is shutting down in 10 seconds.{ENTER}")
					Sleep(10000)
					Send($gComKey)
					Sleep(500)
					Send('quit')
					Sleep(500)
					Send('{ENTER}')
					If GUICtrlRead($SHSSwitch2) = 1 Then
						Shutdown(1)
					EndIf
					Return
				EndIf
			EndIf
;------------------------------- Restart Server -------------------------------
			If GUICtrlRead($RBSwitch) = 1 Then
				If TimerDiff($RBTimer) > $RBTimeTrigger Then
					If WinExists("Delta Force 2, Demo V1.03.04") Then
						Send($gComKey)
				        Sleep(500)
				        Send("talk")
				        Sleep(500)
				        Send("{ENTER}")
				        Sleep(500)
						Send("This game server is rebooting in 10 seconds.{ENTER}")
						Sleep(10000)
						Send($gComKey)
					   	Sleep(500)
					   	Send('quit')
					   	Sleep(500)
					   	Send('{ENTER}')
						Sleep(500)
					EndIf
					If WinExists("BAB.stats v1.2 - DF2DEMO v1.03.04") Then
						If FileExists(StringReplace(GUICtrlRead($BSpath), "babstats.exe", "df2demo10304.cfg")) Then
						;BABstats
							ControlClick ( "BAB.stats v1.2 - DF2DEMO v1.03.04", "", "Button11")
						Else
						;DemoStats
							ControlClick ( "BAB.stats v1.2 - DF2DEMO v1.03.04", "", "Button9")
						EndIf
						Sleep(500)
					EndIf
					$ShutDown = MsgBox(17, "AutoHost " & $gVersion, "AutoHost will reboot game server in 30 seconds.", 30)
					If $ShutDown = 1 OR $ShutDown = -1 Then
						IniWrite(@ScriptDir & "\error.log","Program Event","EVENT: [Server Reboot] ", _Now() & " Server restarted as per config setting.")
						IniWrite(@ScriptDir & "\settings.ini","config","AHRB","1")
						Sleep(500)
						Shutdown(6)  ;Force a reboot
						Exit 0
					Else
						Return
					EndIf
				EndIf
			EndIf

		Else ; If DF2 exsist but not active
		
;--------------------------- ErrorCheck ---------------------------------- 
			If GUICtrlRead($SDMSwitch) = 1 Then
				If TimerDiff($ErrorCheckTimer) > $SDMTimeTrigger Then
					$ErrorCheckTimer = TimerInit()
					$x = 0
					If WinExists("Program Error") Then
				    	WinActivate("Program Error")
						While WinActive("Program Error")
							$x = $x + 1
							$ErrorText = StringTrimRight(StringTrimLeft(WinGetText("Program Error", ""), 3), 1)
							IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Program Error] "& $x,  _Now() & " " & $ErrorText)
				    		Send('{ENTER}')
							Sleep(5000)
						WEnd
						;close send error dialog box
						If WinExists("Df2dem.exe") Then
							Send('{ENTER}')
						EndIf
						Sleep(1000)
	; IF ERROR INCOUNTED THEN DO THE FOLLOWING BASED ON CONFIG
					;Restart DF2 Demo, restart hosting session.
						If GUICtrlRead($SDMopt1) = 1 Then
							$rs = $rs + 1
							If $rs <> GUICtrlRead($SDMrestarts) Then
								IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Restart] ",  _Now() & " DF2 Demo restarted " & $rs & " times.")
				    			RestartHosting()
							Else
								IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Restart] ",  _Now() & " DF2 Demo restarted " & $rs & " times.")
								MsgBox(64, "DF2 Demo Pogram Errors - AutoHost " & $gVersion, $x & " Program Errors encounted." & @CRLF & "DF2 Demo hase been restarted " & $rs & " times." & @CRLF & "Hosting session terminated." & @CRLF & "Please check the AutoHost error.log file for details.")
								Return
								$Bob = 1
							EndIf
						EndIf
					;Shutdown DF2 Demo.
						If GUICtrlRead($SDMopt2) = 1 Then
							MsgBox(0, "DF2 Demo Pogram Errors - AutoHost " & $gVersion, $x & " Program Errors encounted." & @CRLF & "Please check the AutoHost error.log file for details.")
							;shutdown BABstats
							;WinActivate("BAB.stats v1.2 - DF2DEMO v1.03.04")
							Return
						EndIf
					;Shutdown Computer.
						If GUICtrlRead($SDMopt3) = 1 Then
							$Bob = 1
							$ShutDown = MsgBox(17, "DF2 Demo Pogram Errors - AutoHost " & $gVersion, $x & " Program Errors encounted." & @CRLF & "Computer will shut down in 30 seconds.", 30)
							If $ShutDown = 1 OR $ShutDown = -1 Then
								Shutdown(1)
							Else
								$Bob = 1
								Return
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			;error check end
			
			;----- option to force DF2 to stay active
			If GUICtrlRead($AHopt1) = 1 Then
				WinActivate("Delta Force 2, Demo V1.03.04")
			EndIf
			
		EndIf ; DF2 active EndIf
	Else
	; If DF2 is closed exit loop and function
		If $Bob = 0 Then
			IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")
			MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is no longer running.")
			Return
		Else
			IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")	
			Return
		EndIf
	EndIf ; DF2 exsist EndIf
	; Briefly pause to avoid excessive CPU usage
    Sleep(1000)
WEnd
EndFunc

Func RestartHosting()
	Send("#r")
	Sleep(1000)
	Send(GUICtrlRead($DFpath))
	Send("{ENTER}")
	WinWaitActive("Delta Force 2, Demo V1.03.04")
	;Wait 10 seconds for the DF2 Demo interface to load (using loop to detect if DF2 Demo has been shut down).
	$pause = GUICtrlRead($StartPause)
	$pause = StringLeft(($pause), 2) * 1000
	$i = 1
	While 1
	   	If NOT WinExists("Delta Force 2, Demo V1.03.04") Then
			IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")
			MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is no longer running.")
			Return
		EndIf	
		If $i = $pause Then ExitLoop
		$i = $i + 1
	WEnd
	Send("a")
	Sleep(1000)
	Send("m")
	Sleep(1000)
	Send("h")
	Sleep(1000)
	Send("o")
	Sleep(1000)
	Send("h")
	WinWait("Delta Force 2, Demo V1.03.04")
	If NOT WinExists("Delta Force 2, Demo V1.03.04") Then		
		IniWrite(@ScriptDir & "\error.log","Program Error","ERROR: [Delta Force Unexpectedly Quit] ",  _Now() & " Delta Force 2, Demo V1.03.04 terminated. Reason unknown.")
		MsgBox(0,"DF2 Demo Error - AutoHost " & $gVersion, "Delta Force 2, Demo V1.03.04 is no longer running.")
		Return
	EndIf
	WinActivate("Delta Force 2, Demo V1.03.04")
	Return
EndFunc










