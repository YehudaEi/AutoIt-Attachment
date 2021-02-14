#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=CernerCitrixNet.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Users\rogedf\My Documents\CernerCitrixNet.au3>
; ----------------------------------------------------------------------------

Opt("TrayAutoPause",1)
Opt("TrayIconDebug", 1)


$g_szVersion = "Cerner Citrix Net Automation Script"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)

BlockInput(1)

Select
Case @ComputerName = "nwbmm28p" or @ComputerName = "nwbmm2dr" or @ComputerName = "nlbmd212" or @ComputerName = "nlbmd222"
;		 MsgBox(64,"INTEGRIS Health Cerner PathNet TAT Application Launcher", "The PathNet TAT Application will resume in 60 seconds." & @CR & "Please Wait...",60)
		 $USERNAME = "labbtat"
		 $PASS = "pvview"
		 Call("PathNet")
Case Else
		BlockInput(0)
		MsgBox (4096, "INTEGRIS Health Cerner Net Application Launcher", "The Cerner Net Application Launcher has not been modified " & @CR & _
	    "for use with " & @ComputerName & "." & @CR & @CR & "For assistance please call Angela Lilienthal with the INTEGRIS " & @CR & _
		"Information Technology department at 405.552.0827. " & @CR & @CR & "ComputerName:  " & @ComputerName & "     IP Address: " & @IPAddress1)
		Exit(1)
EndSelect

BlockInput(0)

Exit(0)

Func PathNet()

  ShellExecute("                                                     ")

  WinWaitActive("HNAM Logon - \\Remote")	;, "P227")
  ConsoleWrite("Window active!" & @CRLF)
  ControlFocus("HNAM Logon", "P227", 1001)
  ControlSetText("HNAM Logon", "P227", 1001, $USERNAME)
  ControlFocus("HNAM Logon", "P227", 1003)
  ControlSetText("HNAM Logon", "P227", 1003, $PASS)
  ControlClick("HNAM Logon", "P227", 1)

 ; WinWaitActive("Select Service Resource")
  #comments-start
  WinSetState("Select Service Resource", , @SW_MAXIMIZE)
 #comments-end


  ;Do
  ;  Sleep(3000)
;	Send("IBMC")
;	Send("{SPACE}")
;	Send("lab")
;	Send("{ENTER}")
;	Sleep(3000)
;	Send("{ENTER}")
 ; WinActivate("PathNet Lab Management: TAT Monitor", "")
 ; Until WinActive("PathNet Lab Management: TAT Monitor", "")


EndFunc

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Documents and Settings\martr2\Desktop\Mics\Cerner\CernerNet\CernerNet.au3>
; ----------------------------------------------------------------------------

Exit(1)