;-------------------------------------------------------------------------------------------------
;
;	Chaos Bot Keyboard Server 2.0
;
;	This Component MUST be compiled with AutoIt 3.2.4.9
;
;	Credits:	Concept and Programming by TrueMu
;-------------------------------------------------------------------------------------------------
;	This server component is called by the actual bot to perform the Mouse actions.
;	All setup commands start with "$$", to make sure they can be identified. Other commands are used
;	to start / stop the server and so on.
;	Take care to perform the neccessary setup BEFORE you call the commands that depend on the setup!
;-------------------------------------------------------------------------------------------------
#AutoIt3Wrapper_Icon=IC2a.ico           		;Filename of the Ico file to use
#AutoIt3Wrapper_Outfile=KeyServer.exe      		;Target exe/a3x filename.
#AutoIt3Wrapper_Outfile_Type=exe         		;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=4             		;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=Y                 		;(Y/N) Compress output program. Default=Y
#AutoIt3Wrapper_Res_Comment=Use at your own risk - ALWAYS BETA			;Comment field
#AutoIt3Wrapper_Res_Description=Chaos Bot Key Server					;Description field
#AutoIt3Wrapper_Res_Fileversion=2.0
#AutoIt3Wrapper_Res_LegalCopyright=All rights reserved by the author	;Copyright field



AutoItSetOption("MustDeclareVars", 1)
AutoItSetOption("TrayAutoPause", 0)

#Include <Date.au3>

Dim $DebugMode = False
Dim $Do_Pick = False
Dim $Log_File, $SourcePath
Dim $MainDelay = 50
Dim $cnt = 0
Dim $recv
Dim $KeyDelay, $KeyDownDelay
Dim $hBotWnd = "", $hMuWnd = ""
Dim $ctrl_MU = ""
Dim $WinTimer, $WinLast, $WinDelay = 30000
Dim $PickTimer, $PickLast

$PickLast = TimerInit ()
$WinLast = TimerInit ()

While 1

	$recv = ConsoleRead(0,True)	;Read from Standard Input Stream

    If $recv <> 0 Then		;If anything was received
		$recv = ConsoleRead()
		If $DebugMode Then		
			_LogWrite($recv)	;Log to file if $DebugMode is true
		EndIf
		If StringLeft($recv,2) <> "$$" Then	;--- no Setup Command received
			Switch $recv
				Case "STOP"		;Terminate Keyboard Server
					$Do_Pick = False
					If $DebugMode = True Then
						$DebugMode = False
						_StopLog()
					EndIf
					ConsoleWrite($recv)
					ExitLoop
				Case "DEBUG ON"		;Enable Logging
					$DebugMode = True
					_StartLog()
				Case "DEBUG OFF"	;Disable Logging
					_StopLog()
					$DebugMode = False
				Case "PICK ON"		;Enable Autopick
					$Do_Pick = True
				Case "PICK OFF"		;Disable Autopick
					$Do_Pick = False
				Case ""
					;do nothing, but this should never occur
				Case Else
					Send ($recv)	;Send the received string to active Window
			EndSwitch
			If $recv <> "" Then		;Return Handshake to Client
				ConsoleWrite($recv)
			EndIf
		Else	;--- The Setup Commands (with parameter)
			Switch StringLeft($recv, 7)
				Case "$$KDLY="		;SendKeyDelay Option Setting from Client
					$KeyDelay = StringMid($recv, 8)
					AutoItSetOption("SendKeyDelay", $KeyDelay)
					ConsoleWrite($recv)
				Case "$$KDWN="		;SendKeyDownDelay Option Setting from Client
					$KeyDownDelay = StringMid($recv, 8)
					AutoItSetOption("SendKeyDownDelay", $KeyDownDelay)
					ConsoleWrite($recv)
				Case "$$PATH="		;Path of invoking script -> Logfile Destination
					$SourcePath = StringMid($recv, 8)
					ConsoleWrite($recv)
				Case "$$MDLY="		;Minimum Delay between Picks
					$MainDelay = StringMid($recv, 8)
					ConsoleWrite($recv)
				Case "$$BWND="		;BOT Windowrecognition String
					$hBotWnd = StringMid($recv, 8)
					ConsoleWrite($recv)
				Case "$$MWND="		;MU Windowrecognition String
					$hMuWnd = WinGetHandle(StringMid($recv, 8))
					ConsoleWrite($recv)
				Case "$$MCID="		;MU Control ID, needed for ControlSend
					$ctrl_MU = StringMid($recv, 8)
					ConsoleWrite($recv)
				Case "$$WDLY="		;Interval for checking Client and MU Window
					$WinDelay = StringMid($recv, 8)
					ConsoleWrite($recv)
				Case Else
					MsgBox (16, "Unknown Command Packet", "Server received unknown Command:" & @CR & $recv, 5)
					_LogWrite ("Server received unknown Command: " & $recv)
					ConsoleWrite("ERR")
			EndSwitch			
		EndIf
	EndIf
	
	$WinTimer = TimerDiff ($WinLast)
	If $WinTimer > $WinDelay Then
		If $hBotWnd <> "" Then
			If Not WinExists ($hBotWnd) Then	;Shutdown if the main bot window does not exit anymore
				_LogWrite ("Could not find Bot Window: Handle invalid")
				_StopLog()
				ExitLoop
			EndIf
		EndIf
		If $hMuWnd <> "" Then
			If Not WinExists ($hMuWnd) Then	;stop all actions (picking) if MU can not be found
				_LogWrite ("Could not find MU Window: Handle invalid - Stopping Pick")
				$Do_Pick = False
			EndIf
		EndIf
		$WinLast = TimerInit ()
	EndIf

	$PickTimer = TimerDiff ($PickLast)	;Timer based pick interval, can be used to pick less frequently
	If $Do_Pick And $PickTimer > $MainDelay Then
		$PickLast = TimerInit()
		Send (" ")
	EndIf
;~ 	If $Do_Pick Then	;optional pick routine without timer control, uncomment if desired
;~ 		Send (" ")		;but comment the above timer based routine if you do so
;~ 	EndIf
	
	Sleep (25)	;Idle the CPU so other tasks can be performed. Reducing this number may result in lag and worse
WEnd

Func _StartLog()
	$Log_File = FileOpen($SourcePath & "\" & "KeyServer" & ".log", 1)
	_LogWrite(@ScriptName & " Debug Log ", False)
	_LogWrite("#####     Start of Log Session     #####", False)
EndFunc   ;==>_StartLog

Func _StopLog()
	_LogWrite("#####     End of Log Session     #####", False)
	_LogWrite("======================================", False)
	FileClose($Log_File)
EndFunc   ;==>_StopLog

Func _LogWrite($LogMsg, $Time = True, $NoCR = False)
	Local $CRLF ;local variable for CR flag
	Local $TimeStr ; local variable for time stamp
	If $DebugMode Then
		If $NoCR Then
			$CRLF = ""
		Else
			$CRLF = @CRLF
		EndIf
		If $Time Then
			$TimeStr = @YEAR & "-" & @MON & "-" & @MDAY & " " & _NowTime(5) & "  "
		Else
			$TimeStr = ""
		EndIf
		FileWrite($Log_File, $TimeStr & $LogMsg & $CRLF)
	EndIf
EndFunc   ;==>_LogWrite
