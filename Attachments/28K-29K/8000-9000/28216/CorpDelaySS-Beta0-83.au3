;  Title:     CorpDelaySS Cyber Security Utility - Corporate Delay Screen Saver v0.83    Oct 2009
;
;  Purpose:	This AutoIt compilable script provide users a simple way to temporarily delay automatic screen 
;           saver password locking due to inactivity with options that include 1, 2, and 4 hours before resuming
;           normal screen saver functions.  Utility is intended to help support broad implementation of required
;           default screen saving time out after a period of inactivity (e.g. 15 minutes).   Instead of requesting 
;           full exceptions to a manditory screen saver password lock as a standard requirement, many situations 
;           can be addressed with the use of this utility when business needs necessitate users having the 
;           means to temporarily Delay screen saver password locking.  CorpDelaySS is also designed to 
;           properly function in enviroments where users have a significant reduction in local PC privileges. 
;
;           
;			Windows XP
; 			Once active for Windows XP, this utility will disable the screen saver and then reenable
;           with available registry setting "HKEY_CURRENT_USER\Control Panel\Desktop"  "ScreenSaveActive"  (a 
;           prior approach of just moving the mouse pointer proved ineffective.  Additionally this utility 
;           will ensure screen saver is active upon entry and exit.
;	
;			Other Windows (Vista, Win7)
;			Use the JogMouse function to impreceptively move the mouse every 30 seconds and generate activity.
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
;
;          v0.83 Beta Oct 2009 -  Orlando Stevenson  - Expire 2009/11/08
;                 - use single registry key approach, WinXP 
;                 - oterwise, use mouse movement for Vista, Win7
;          v0.81 Beta Oct 2009 -  Orlando Stevenson  - Expire 2009/11/08
;                 - use registry key approach, XP Only
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

	$Expiration = "2009/12/01"			 ; Assert an expiration- useful for limited duration beta/testing cycles

;  Expiration Check
$CurrentDate = _NowCalcDate()
;	Msgbox(64,"About: CorpDelaySS - _NowDate", $CurrentDate,$MsgDelay)
If $CurrentDate >= $Expiration Then
	Msgbox(0,"CorpDelaySS: Beta Expired " & $Expiration,"Expired v0.8 Beta build, exiting program",$MsgDelay)
	Exit_Program()
EndIf

If @OSVersion <> "WIN_XP" Then
	$XPOS = False
Else
	$XPOS = True	
Endif


If $XPOS Then
	EnableSS();  ;  Ensure screen saver is active
EndIf	
	
;  Assert UI Behaviors
AutoItSetOption("TrayOnEventMode",1) ; Enable OnEvent functions notifications for the tray. 0 = (default) disable, 1 = enable
AutoItSetOption("TrayAutoPause",0)  ; Script pauses when click on tray icon. 0 = no pause
AutoItSetOption("TrayMenuMode",1)   ; Extend the behaviour of the script tray icon/menu.  1 = Default tray menu items (Script Paused/Exit) will not be shown.
;   For more on AutoItSetOption, see http://www.autoitscript.com/autoit3/docs/functions/AutoItSetOption.htm
HotKeySet("^!q", "Exit_Program")

;  Build UI Menu 
$CorpDelaySSMenu = TrayCreateMenu("Set Screen Saver Delay")
TrayCreateItem("")
TrayCreateItem("About")
TrayItemSetOnEvent(-1, "CorpDelaySS_About")
TrayCreateItem("")
TrayCreateItem("Exit - Use CTRL-ALT-Q when Active")
TrayItemSetOnEvent(-1, "Exit_Program")

TrayCreateItem("1 Min (Beta only)", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_1m")
TrayCreateItem("6 Min (Beta only)", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_6m")

TrayCreateItem("30 Min", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_30m")
TrayCreateItem("1 Hour", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_60m")
TrayCreateItem("2 Hours", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_120m")
TrayCreateItem("4 Hours", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_240m")

TrayCreateItem("8 Hours (Beta only)", $CorpDelaySSMenu )
TrayItemSetOnEvent(-1, "CorpDelaySS_480m")

TraySetState()
TraySetIcon($IconInactiveDLLFile,$IconInactiveIndex )
TraySetToolTip("CorpDelaySS v0.83 Beta" & chr(10) & "Inactive")

While True
	Sleep(1000)  ; Infinite loop with one second sleep cycles.
WEnd


Func CorpDelaySS_About()
	$MsgBody = "Corporate Delay Screen Saver v0.83 (Beta) 10/13/2009" & Chr(10)
	$MsgBody &= "Expiration: " & $Expiration &  Chr(10)& "Author(s): Orlando Stevenson" & Chr(10) & Chr(10)
	$MsgBody &= "This software is provided 'as-is,' without any expressed or implied warranty.  "  
	$MsgBody &= "In no event shall the authors or distributors of this software be held liable for any damages arising from use."
	Msgbox(64,"About: CorpDelaySS - Cyber Security Utility",	$MsgBody, $MsgDelay)
EndFunc


Func Exit_Program()
	If $XPOS Then 
		EnableSS();  ;  Ensure screen saver is active
	EndIf
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


Func JogMouse()
	$CurPos = MouseGetPos ( )
	MouseMove ( $CurPos[0] + 1, $CurPos[1] )
	MouseMove ( $CurPos[0] - 1, $CurPos[1] )
Endfunc


Func CorpDelaySS_1m()
	CorpDelaySS(1);
EndFunc

Func CorpDelaySS_6m()
	CorpDelaySS(6);
EndFunc

Func CorpDelaySS_30m()
	CorpDelaySS(30);
EndFunc

Func CorpDelaySS_60m()
	CorpDelaySS(60);
EndFunc

Func CorpDelaySS_120m()
	CorpDelaySS(120);
EndFunc

Func CorpDelaySS_240m()
	CorpDelaySS(240);
EndFunc

Func CorpDelaySS_480m()
	CorpDelaySS(480);
EndFunc

Func CorpDelaySS($minutes)  ; minutes must be int > 0 - minimal error checking required given menu driven
	If $XPOS THEN 
		DisableSS() ; Disable Screensaver using registry approach for XP
	EndIF
	$IconActiveDLLFile = "wpdshext.dll"   ; Reference common Windows icon library for Active indication XP, Vista, Win7
	$IconActiveNormalIndex = 714 ; Normal display of icon with status of greater than five minutes left
	$IconActiveRedIndex = 710;   ; Red display of icon with status of less than five minutes left
	$IconActiveRedThreshold = 5  ; Time in minutes where icon will turn red idicating less that five minutes left.
	$FiveMinutesOrLess = False    ; Function has not determined to be five minutes or less left yet to switch to a red toned icon.
	TraySetIcon($IconActiveDLLFile,$IconActiveNormalIndex)

	$i = $minutes
	While $i > 0   ; Loop for all but last minute
		TraySetToolTip("CorpDelaySS v0.83 Beta" &chr(10) & "Active ("& $i & " min left)")
		If (NOT $FiveMinutesOrLess) AND ($i <= $IconActiveRedThreshold) Then
			TraySetIcon($IconActiveDLLFile,$IconActiveRedIndex)
			$FiveMinutesOrLess = True
		EndIf
		IF $XPOS Then
			Sleep(60000)  
		Else
			JogMouse()
			Sleep(30000)
			JogMouse()
			Sleep(30000)		
		EndIf
		$i=$i-1
	WEnd
	; Last minute handling
	TraySetIcon($IconInactiveDLLFile,$IconInactiveIndex)
	TraySetToolTip("CorpDelaySS v0.83 Beta" & chr(10) & "Inactive")
	IF $XPOS Then
		EnableSS(); ; Enable Screensaver
	EndIf 
EndFunc


