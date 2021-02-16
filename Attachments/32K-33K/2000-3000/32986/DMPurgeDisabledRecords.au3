#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         Grant Jefferies
 Date:			 22 Sept 2006
 Modify:		31 July 2008 - REM out EMAIL and EMAILR (lines 97&98) as they were causing problems
 
 Script Function:
	Purge Disabled records in all Databases.
	CmdLine[1]=Drive Letter, defaults to P if none supplied

#ce ----------------------------------------------------------------------------

AutoItSetOption("WinTitleMatchMode", 4)
AutoItSetOption("MustDeclareVars",1)

Dim $Company, $User, $Pwd, $Drive, $WorkingDir, $AppName, $Result

$Company = "ZZZ"
$User    = "AUTI"
$Pwd     = "a"
$Drive   = "P"
$WorkingDir = "\\aklaq811.corp.ad.airnz.co.nz\sdmq\FltCtrl"

AutoItSetOption("WinTitleMatchMode", 4)

; Check Parameters and set Drive Letter to Use
If ($CmdLine[0] = 1) Then
	If StringLen($CmdLine[1]) = 1 Then
		$Drive = $CmdLine[1]
	EndIf
Endif

$Result = MsgBox(1,"Purge Disabled Records","Run on " & $Drive & " Drive and stop " & _
					@LF & "current instances of DM",10)
WinActivate("Purge Disabled Records")					
If $Result = -1 OR $Result = 2 Then
	Exit
EndIf

; Stop currently running instances of DM
While WinActivate("Dispatch Manager - ") = 1
	Send("!F")
	;Exit
	Send("x")
WEnd

;$AppName = $Drive &":\FltCtrl\Bin\DISPMGR.exe N " & $User & "PPPCAANZPOXz FLTCTRL EAGLEOX P"
;If MsgBox(1,"Purge Disabled Records","Running on " & $Drive & " Drive",10) = 2 Then
;	Exit
;EndIf	
$AppName = $Drive &":\FltCtrl\Bin\DISPMGR.exe N " & $User & $Drive & $Drive & $Drive & "CAANZ" _
           & $Drive & "OYz FLTCTRL EAGLEOX " & $Drive

; Start Dispatch Manager
;MsgBox(0,"Airway Cross Ref",$Company & " " & $AppName & " " & $WorkingDir)
;MsgBox(0,"Airway Cross Ref",$AppName)

Run($AppName,$WorkingDir)

;Sign In
WinWaitActive("Dispatch Manager Sign In")
Send($Pwd & "{Tab 4}" & $Company & "{Enter}")
;Clear Email (Not Required for AUTI User)
;WinWaitActive("DPMAIL.NEW","",2)
;	Send("!e")
;If WinWaitActive("Dispmgr","",2) Then
;	ControlFocus("Dispmgr","","TButton1")
;	ControlClick("Dispmgr","","TButton1")
;Endif
Send("{Enter}")
WinWaitActive("Dispatch Manager - ")

PurgeDisabled("!PAA")			;Purge ACATC
PurgeDisabled("!AA") 			;Purge ACLog
PurgeDisabled("!PAW") 			;Purge ACWgts
PurgeDisabled("!IC") 			;Purge Codes
PurgeDisabled("!IT") 			;Purge DBKeys
PurgeDisabled("!ID") 			;Purge DED
PurgeDisabled("!OIN") 			;Purge DPCONT
PurgeDisabled("!OI")	 		;Purge DCPER
PurgeDisabled("!OD") 			;Purge DPCTRL
PurgeDisabled("!OSC") 			;Purge DPCZP
PurgeDisabled("!OE") 			;Purge DPETPA
PurgeDisabled("!OT") 			;Purge DPETPP
PurgeDisabled("!OSF") 			;Purge DPFLP
PurgeDisabled("!NF") 			;Purge DPFLX
PurgeDisabled("!OF") 			;Purge DPFOD
PurgeDisabled("!DO") 			;Purge DPMSGS
PurgeDisabled("!OC") 			;Purge DPOD
PurgeDisabled("!OP") 			;Purge DPPERF
PurgeDisabled("!OL") 			;Purge DPPLOT
PurgeDisabled("!OR") 			;Purge DPREF
PurgeDisabled("!OV") 			;Purge DPREVN
PurgeDisabled("!OU") 			;Purge DPRTE
PurgeDisabled("!OSX") 			;Purge DPTAXI
PurgeDisabled("!EM") 			;Purge EMAIL
PurgeDisabled("!ER") 			;Purge EMAILR Freezes up
PurgeDisabled("!DT") 			;Purge FDAPT
PurgeDisabled("!CI") 			;Purge FDAPTL
PurgeDisabled("!WI") 			;Purge FDAPTM
PurgeDisabled("!DSWD") 		;Purge FDDESK Freezes up
;PurgeDisabled("!R{RIGHT}FS") 	;Purge FDFIRFEE Freezes up
PurgeDisabled("!DE")			;Purge FDMSG
PurgeDisabled("!DA")			;Purge FDNOTES
PurgeDisabled("!DR") 			;Purge FDREL
PurgeDisabled("!DD") 			;Purge FDRMKS
PurgeDisabled("!PW") 			;Purge FDWXALT
;PurgeDisabled("!WD") 			;Purge FFDELAY File not found
PurgeDisabled("!WA") 			;Purge FFLOAD Freezes up
PurgeDisabled("!WF") 			;Purge FFPOS Freezes up
;PurgeDisabled("!WO") 			;Purge FFPROB File not found
PurgeDisabled("!NVF") 			;Purge FIR
PurgeDisabled("!R{RIGHT}FF")	;Purge FIRFEES Freezes up
PurgeDisabled("!NVU") 			;Purge FLTAB
PurgeDisabled("!PF") 			;Purge FPCFP Freezes up
PurgeDisabled("!IFF") 			;Purge FPFORM Freezes up
PurgeDisabled("!IFL") 			;Purge FPMASK
PurgeDisabled("!PN") 			;Purge FPRR
PurgeDisabled("!SD") 			;Purge FSDAILY
PurgeDisabled("!SM") 			;Purge FSMASTER Freezes up
PurgeDisabled("!SS") 			;Purge FSMONTHS
PurgeDisabled("!WL") 			;Purge FWAPS
PurgeDisabled("!DL") 			;Purge LOG
PurgeDisabled("!AM") 			;Purge MELS
PurgeDisabled("!IM") 			;Purge MENUS
PurgeDisabled("!MA") 			;Purge MSADDR
PurgeDisabled("!XS") 			;Purge MSGCODE
PurgeDisabled("!XA") 			;Purge NOTAM Freezes up
PurgeDisabled("!XN") 			;Purge NTMCODE Freezes up
PurgeDisabled("!NVG") 			;Purge NVMAP
PurgeDisabled("!NP") 			;Purge NVPREF
PurgeDisabled("!DO") 			;Purge ODNOTES
PurgeDisabled("!IO") 			;Purge OPERATOR
PurgeDisabled("!DP") 			;Purge PHONES
PurgeDisabled("!CC") 			;Purge SMICODE
PurgeDisabled("!XR") 			;Purge WXAREA Freezes up
PurgeDisabled("!XB") 			;Purge WXBRF
PurgeDisabled("!XY") 			;Purge WXEYE

MsgBox(0,"Purge Disabled Records","Purge Disabled Records Complete")
;Exit DM
ExitDM()

Func PurgeDisabled($KeyStrokes)
	AutoItSetOption("SendKeyDelay",20)
	;Bring Menu into Focus
	WinActivate("Dispatch Manager - ")
	;MsgBox(0,"Purge Disabled Records","")
	Send($KeyStrokes)
	;For $Count = 1 to StringLen($KeyStrokes)
	;	Send(StringMid($KeyStrokes,$Count,1))
	;Next
	;MsgBox(0,"Purge Disabled Records","")
	WinWaitActive("classname=TsEnterString","")
	Send("ZZZ")
	Send("!O")
	WinWaitActive("classname=TsDBFile")
	Send("!G")
	Send("P")
	;MsgBox(0,"Purge Disabled Records","")
	;Send("{Enter 2}")
	Send("!O")
	Send("!O")
	;MsgBox(0,"Purge Disabled Records","")
	If WinWaitActive("classname=TsDBGlobal","",2) = 1 Then
	;MsgBox(0,"Purge Disabled Records","TsDBGlobal")
		Send("{Enter}")
	If WinWaitActive("classname=TsDBFile","",2) = 1 Then
		EndIf
	EndIf
	WinWaitActive("classname=TMessageForm") 
	;MsgBox(0,"Purge Disabled Records","TMessageForm")
	Send("{Enter}")
	Send("!x")
	AutoItSetOption("SendKeyDelay",Default)
	WinActivate("Dispatch Manager - ")
EndFunc

Func ExitDM()
	;Exit Dispatch Manager
	;Bring Menu into Focus
	WinActivate("Dispatch Manager - ")
	Send("!F")
	;Exit
	Send("x")
EndFunc




