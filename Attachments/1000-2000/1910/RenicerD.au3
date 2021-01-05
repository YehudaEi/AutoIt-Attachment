; ===================================================================
; ==  RenicerD                                                     ==
; ==  Version 1.0 by WarmFuzzy - April 19th, 2005                  ==
; ==                                                               ==
; ==  Purpose: Every 30 seconds modifies "nice" value (Process     ==
; ==           Priority) for programs we want to ensure have a     ==
; ==           high or low value (e.g. VOIP soft phones, etc.)     ==
; ===================================================================
 

; #NoTrayIcon
Opt("TrayIconHide", 0)          ; 0=show, 1=hide tray icon

Break(1)						; 0=Disable break  1=Enable Break
Opt("MustDeclareVars", 1)		; this makes us better people

global $nicelist[10][2]			; Our list to renice to
MakeArray()						; Add list elements for renice

while 1							; infinite loop waiting for something to happen
	CheckNiceness()				; check/set Process Priority
	Sleep (30000)				; every 30 seconds shouldn't be too onerous
Wend
Exit

Func CheckNiceness()
	; AutoIt3 is missing a ProcessGetPriority so we'll just blindly keep modifying process priority
	local $i,$nicename,$nicelevel
	for $i = 0 to UBound($nicelist)-1
		$nicename=$nicelist[$i][0]
		$nicelevel=$nicelist[$i][1]
		if $nicename<>"0" Then
			;msgbox(0,$nicename,$nicelevel,5000)
			ProcessSetPriority($nicename,$nicelevel)	; @error=1 is failure, e.g. process not running
			if @error>1 Then MsgBox(48,"ProcessSetPriority Error","@error was " & @error & " - possible unsupported priority class",5000)
		EndIf
	Next
EndFunc

Func MakeArray()
	;	0 - Idle/Low
	;	1 - Below Normal (Not supported on Windows 95/98/ME)
	;	2 - Normal
	;	3 - Above Normal (Not supported on Windows 95/98/ME)
	;	4 - High
	;	5 - Realtime (Use with caution, may make the system unstable)
	$nicelist[0][0]="eyebeam.exe"		; VOIP - www.xten.com
	$nicelist[0][1]=4
EndFunc

