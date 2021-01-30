;  Title:   SuspendSPS Cyber Security Utility - Suspend Screen and Power Saver v0.8 Beta   Oct 2009
;
;  Purpose:	This AutoIt compilable script provide users a simple way to temporarily suspend automatic screen 
;           saver password locking and power saving timeouts due to inactivity with options that include 1, 2, 
;           and 4 hours.  Utility is intended to promote broad implementation of require default screen 
;           saving time out after a period of inactivity (e.g. 15 minutes).   Instead of requesting full
;           exceptions to a manditory screen saver password lock as a standard requirement, many situations 
;           can be addressed with the use of this utility when business needs necessitate users having the 
;           means to temporarily suspend screen saver password locking.  SuspendSPS is also designed to 
;           properly function in enviroments where users have a significant reduction in local PC privileges. 
;
;           Once active, this utility imperceptibly moves screen mouse pointer placement every thirty seconds 
;           to ensure the PC is considered in active use (quickly shifting mouse pointer one step and returning 
;           to prior position).
;
;	Notes: 	This software is provided 'as-is,' without any expressed or implied warranty. In no event shall 
; 			the authors or distributors of this software be held liable for any damages arising from use.
;
;	    	Inspired by example:   	                                          
;           More about AutoIt v3:	http://www.autoitscript.com/autoit3/	      
;	       
;	       
;  Author(s)/Versions History :    
;          Orlando Stevenson   v0.8 Beta Oct 2009
;		
#Include <Date.au3>			; Include standard date related User Functions

;  Global Variables
	$IconInactiveDLLFile ="shell32.dll"  ; Reference common Windows icon library for inactive status
	$IconInactiveIndex = 251			 ; Reference common Windows icon library idex for inactive status
	$MsgDelay = 7;                       ; Automatic timeout for displayed messages - in seconds.
	$Expiration = "2009/11/01"			 ; Assert an expiration- useful for limited duration beta/testing cycles

;  Expiration Check
$CurrentDate = _NowCalcDate()
;	Msgbox(64,"About: SuspendSPS - _NowDate", $CurrentDate,$MsgDelay)
If $CurrentDate >= $Expiration Then
	Msgbox(0,"SuspendSPS: Beta Expired " & $Expiration,"Expired v0.8 Beta build, exiting program",$MsgDelay)
	Exit_Program()
EndIf


AutoItSetOption("TrayOnEventMode",1) ; Enable OnEvent functions notifications for the tray. 0 = (default) disable 1 = enable
AutoItSetOption("TrayAutoPause",0)  ; Script pauses when click on tray icon. 0 = no pause
AutoItSetOption("TrayMenuMode",1)   ; Extend the behaviour of the script tray icon/menu.  1 = Default tray menu items (Script Paused/Exit) will not be shown.
;   For more on AutoItSetOption, see http://www.autoitscript.com/autoit3/docs/functions/AutoItSetOption.htm

HotKeySet("^!q", "Exit_Program")

$SuspendScreenSaver = TrayCreateMenu("Suspend Inactivity Screen and Power Savers")
TrayCreateItem("")
TrayCreateItem("About")
TrayItemSetOnEvent(-1, "SuspendSPS_About")
TrayCreateItem("")
TrayCreateItem("Exit (To exit pres CTRL-ALT-q)")
TrayItemSetOnEvent(-1, "Exit_Program")

TrayCreateItem("1 Min (Beta only)", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_1m")
TrayCreateItem("6 Min (Beta only)", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_6m")

TrayCreateItem("30 Min", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_30m")
TrayCreateItem("1 Hour", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_60m")
TrayCreateItem("2 Hours", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_120m")
TrayCreateItem("4 Hours", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_240m")

TrayCreateItem("8 Hours (Beta only)", $SuspendScreenSaver )
TrayItemSetOnEvent(-1, "SuspendSS_480m")

TraySetState()
TraySetIcon($IconInactiveDLLFile,$IconInactiveIndex )
TraySetToolTip("SuspendSPS:  Inactive")

While True
	Sleep(1000)  ; Infinite loop with one second sleep cycles.
WEnd


Func SuspendSPS_About()
	$MsgBody = "Suspend Screen and Power Saver v0.8 (Beta)" & Chr(10)
	$MsgBody &= "Expiration: " & $Expiration &  Chr(10)& "Authored by Orlando Stevenson (10/04/2009)" & Chr(10) & Chr(10)
	$MsgBody &= "This software is provided 'as-is,' without any expressed or implied warranty.  "  
	$MsgBody &= "In no event shall the authors or distributors of this software be held liable for any damages arising from use."
	Msgbox(64,"About: SuspendSPS - Cyber Security Utility",	$MsgBody, $MsgDelay)
EndFunc



Func Exit_Program()
	Exit 0
EndFunc


Func JogMouse()
	$x = MouseGetPos(0)
	$y = MouseGetPos(1)
	MouseMove($x,$y+1,0)
	MouseMove($x,$y,0)
Endfunc


Func SuspendSS_1m()
	SuspendSS(1);
EndFunc

Func SuspendSS_6m()
	SuspendSS(6);
EndFunc


Func SuspendSS_30m()
	SuspendSS(30);
EndFunc

Func SuspendSS_60m()
	SuspendSS(60);
EndFunc

Func SuspendSS_120m()
	SuspendSS(120);
EndFunc

Func SuspendSS_240m()
	SuspendSS(240);
EndFunc

Func SuspendSS_480m()
	SuspendSS(480);
EndFunc

Func SuspendSS($minutes)  ; minutes must be int > 0 - minimal error checking required given menue driven
	$IconActiveDLLFile = "wpdshext.dll"   ; Reference common Windows icon library for Active indication XP, Vista, Win7
	$IconActiveNormalIndex = 714 ; Normal display of icon with status of greater than five minutes left
	$IconActiveRedIndex = 710;   ; Red display of icon with status of less than five minutes left
	$IconActiveRedThreshold = 5  ; Time in minutes where icon will turn red idicating less that five minutes left.

	$FiveMinutesOrLess = False    ; Function has not determined to be five minutes or less left yet to switch to a red toned icon.
	TraySetIcon($IconActiveDLLFile,$IconActiveNormalIndex)

	MsgBox(64,"SuspendSPS - Initiating Suspension for " & $minutes & " Minutes","Suspending inactivty triggered screen locking and power savings settings.",$MsgDelay)
	$i = $minutes
;	MsgBox(0,"Minutes- $i", $i)

	While $i > 0
		JogMouse()  ;  Move mouse pointer slightly and then return
		TraySetToolTip("SuspendSPS:  " & $i & " minute(s) remaining.")
		If (NOT $FiveMinutesOrLess) AND ($i <= $IconActiveRedThreshold) Then
			TraySetIcon($IconActiveDLLFile,$IconActiveRedIndex)
			$FiveMinutesOrLess = True
		EndIf
;		MsgBox(0,"Before Sleep 60", $i)
		sleep(30000)  ;  Sleep for thirty seconds - milliseconds, jog ~every 30 seconds to address even most restrictive automatic lockout (1m).
		JogMouse()    ;  Move mouse pointer slightly up and then back to current position to generate activity
		sleep(30000)  ;  Sleep for thirty more seconds - milliseconds, jog ~every 30 seconds to address even most restrictive automatic lockout (1m).
;		MsgBox(0,"After Sleep 60", $i)
		$i=$i-1
	WEnd
	MsgBox(64,"SuspendSPS - Suspension Completed for " & $minutes & " Minutes","Resuming normal inactivity triggered screen locking and power savings settings.",$MsgDelay)
	TraySetIcon($IconInactiveDLLFile,$IconInactiveIndex)
	TraySetToolTip("SuspendSPS:  Inactive")
EndFunc


