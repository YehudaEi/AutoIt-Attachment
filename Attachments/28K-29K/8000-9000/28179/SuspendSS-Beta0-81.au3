;  Title:     SuspendSS Cyber Security Utility - Suspend Screen Saver v0.81    Oct 2009
;
;  Purpose:	This AutoIt compilable script provide users a simple way to temporarily suspend automatic screen 
;           saver password locking due to inactivity with options that include 1, 2, and 4 hours before resuming
;           normal screen saver functions.  Utility is intended to help support broad implementation of required
;           default screen saving time out after a period of inactivity (e.g. 15 minutes).   Instead of requesting 
;           full exceptions to a manditory screen saver password lock as a standard requirement, many situations 
;           can be addressed with the use of this utility when business needs necessitate users having the 
;           means to temporarily suspend screen saver password locking.  SuspendSS is also designed to 
;           properly function in enviroments where users have a significant reduction in local PC privileges. 
;
;           Once active, this utility will imperceptibly periodically disable the screen saver and then reenable
;           with available registry setting "HKEY_CURRENT_USER\Control Panel\Desktop"  "ScreenSaveActive"  (a 
;           prior approach of just moving the mouse pointer proved ineffective.  Additionally this utility 
;           will ensure screen saver is active upon entry and exit.
;
;	Notes: 	This software is provided 'as-is,' without any expressed or implied warranty. In no event shall 
; 			the authors or distributors of this software be held liable for any damages arising from use.
;
;			AutoIt v3:	http://www.autoitscript.com/autoit3/	     
; 
;	    	More information:
;              #1:                                            
;              #2:  http://www.autoitscript.com/forum/index.php?showtopic=8867 
;              #3:  www.rarst.net/script/toggle-screensaver/
;              #4:                                                                         
;              
;               
;	       
;  Author(s)/Versions History :    
;          v0.81 Beta Oct 2009 -  Orlando Stevenson  - Expire 2009/11/08
;                 - use registry key approach
;          v0.8  Beta Oct 2009 -  Orlando Stevenson  - Expire 2009/11/01
;                 - use mouse pointer movement approach;								
;
#Include <Date.au3>			; Include standard date related User Functions

;  Global Variables
	$IconInactiveDLLFile ="shell32.dll"  ; Reference common Windows icon library for inactive status
	$IconInactiveIndex = 251			 ; Reference common Windows icon library idex for inactive status
	$MsgDelay = 7;                       ; Automatic timeout for displayed messages - in seconds.
	$REGkey="HKEY_CURRENT_USER\Control Panel\Desktop"
	$REGvalue="ScreenSaveActive"

	$Expiration = "2009/11/08"			 ; Assert an expiration- useful for limited duration beta/testing cycles

;  Expiration Check
$CurrentDate = _NowCalcDate()
;	Msgbox(64,"About: SuspendSS - _NowDate", $CurrentDate,$MsgDelay)
If $CurrentDate >= $Expiration Then
	Msgbox(0,"SuspendSS: Beta Expired " & $Expiration,"Expired v0.8 Beta build, exiting program",$MsgDelay)
	Exit_Program()
EndIf

If @OSVersion <> "WIN_XP" Then
	Msgbox(0,"SuspendSS: Error" ,"Currently only supports Windows XP, program exiting.",$MsgDelay)
	Exit_Program()
Endif



EnableSS();  ;  Ensure screen saver is active
		
;  Assert UI Behaviors
AutoItSetOption("TrayOnEventMode",1) ; Enable OnEvent functions notifications for the tray. 0 = (default) disable, 1 = enable
AutoItSetOption("TrayAutoPause",0)  ; Script pauses when click on tray icon. 0 = no pause
AutoItSetOption("TrayMenuMode",1)   ; Extend the behaviour of the script tray icon/menu.  1 = Default tray menu items (Script Paused/Exit) will not be shown.
;   For more on AutoItSetOption, see http://www.autoitscript.com/autoit3/docs/functions/AutoItSetOption.htm
HotKeySet("^!q", "Exit_Program")

;  Build UI Menu 
$SuspendScreenSaver = TrayCreateMenu("Suspend Inactivity Screen and Power Savers")
TrayCreateItem("")
TrayCreateItem("About")
TrayItemSetOnEvent(-1, "SuspendSS_About")
TrayCreateItem("")
TrayCreateItem("Exit - When Active, use CTRL-ALT-Q")
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
TraySetToolTip("SuspendSS v0.9 Beta" & chr(10) & "Inactive")

While True
	Sleep(1000)  ; Infinite loop with one second sleep cycles.
WEnd


Func SuspendSS_About()
	$MsgBody = "Suspend Screen and Power Saver v0.9 (Beta)" & Chr(10)
	$MsgBody &= "Expiration: " & $Expiration &  Chr(10)& "Authored by Orlando Stevenson (10/04/2009)" & Chr(10) & Chr(10)
	$MsgBody &= "This software is provided 'as-is,' without any expressed or implied warranty.  "  
	$MsgBody &= "In no event shall the authors or distributors of this software be held liable for any damages arising from use."
	Msgbox(64,"About: SuspendSS - Cyber Security Utility",	$MsgBody, $MsgDelay)
EndFunc


Func Exit_Program()
	EnableSS();  ;  Ensure screen saver is active
	Exit 0
EndFunc

Func EnableSS() ; Ensure screen saver is enabled
	If NOT(Number(RegRead($REGkey, $REGvalue))) Then
		RegWrite($REGkey, $REGvalue, "REG_SZ", 1 )
	EndIf
EndFunc

Func DisableSS()  ; Esure screen saver is disabled
	If Number(RegRead($REGkey, $REGvalue)) Then
		RegWrite($REGkey, $REGvalue, "REG_SZ", 0)
	EndIf
EndFunc


;Func JogMouse($j)
;	$x = MouseGetPos(0)
;	$y = MouseGetPos(1)
;	MouseMove($x,$y+$j,1)
; Endfunc


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

Func SuspendSS($minutes)  ; minutes must be int > 0 - minimal error checking required given menu driven
	DisableSS() ; Disable Screensaver 
	$IconActiveDLLFile = "wpdshext.dll"   ; Reference common Windows icon library for Active indication XP, Vista, Win7
	$IconActiveNormalIndex = 714 ; Normal display of icon with status of greater than five minutes left
	$IconActiveRedIndex = 710;   ; Red display of icon with status of less than five minutes left
	$IconActiveRedThreshold = 5  ; Time in minutes where icon will turn red idicating less that five minutes left.
	$FiveMinutesOrLess = False    ; Function has not determined to be five minutes or less left yet to switch to a red toned icon.
	TraySetIcon($IconActiveDLLFile,$IconActiveNormalIndex)

	$i = $minutes
	While $i > 0   ; Loop for all but last minute
		TraySetToolTip("SuspendSS v0.81 Beta" &chr(10) & "Active ("& $i & " min left)")
		If (NOT $FiveMinutesOrLess) AND ($i <= $IconActiveRedThreshold) Then
			TraySetIcon($IconActiveDLLFile,$IconActiveRedIndex)
			$FiveMinutesOrLess = True
		EndIf
		Sleep(60000)  
		$i=$i-1
	WEnd
	; Last minute handling
	TraySetIcon($IconInactiveDLLFile,$IconInactiveIndex)
	TraySetToolTip("SuspendSS v0.81 Beta" & chr(10) & "Inactive")
	EnableSS(); ; Enable Screensaver
EndFunc


