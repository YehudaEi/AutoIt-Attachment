#Region Version History Comments
; Chaos Bot - a bot program for Mu Online
; written by TrueMu
;
; Designed for Windowmode or Minimizer
;
;Vers.	1.7	Added Inventory clearance during AFK, Autoparty
;Vers.	1.8 Added DL Raven, AutoCombo
;Vers.	1.8.x	Modifications to adapt to new GG. Client-Server etc....
;Vers.	1.9.x	New Client-Server with STD-IO, more color based routines
;Vers.	2.0		Adapted to compile with 3.2.4.9, Color check made optional

;------------------------------------------------------------------------
; Change History
;------------------------------------------------------------------------
;		Modified: SS are now taken based on Win Client Area
;		Added: Clear Button to delete all *.jpg from Sceeenshot or Mu folder older 24h
;		Added: DL Multi Distance Attack
;		Added: _ManyPixelSearch, also now used for detecting DC
;		Fixed $DW_Protect was not restored properly
;		Fixed Bug in _SetRequestOff that always enabled AutoPick
;		Allowing User to select Modifier Key, also other Hotkeys
;		Modified _BotHalt to avoid RemoteSend interuption, Bugfix for _SanityCheck
;		Now saving DropPosition
;		Store-Read many params from registry to make ini easier to maintain
;		Now doing _SanityCheck during runtime if full afk
;		Removed some obsolete Functions _UnFocus, _PickIt...
;		Fixed Endless-Loop that occured after Disconnect in _OpenInvetory
;		Added Timeout Function that disables Raven Attack after some time
;		Using PixelSearch on InventoryClear
;		#### REMOVED: Using BlockInput to prevent multiple _RemoteSend invokes, especially when using hotkeys
;		Added Int & Number function to GUIctrlreads to make sure values are used properly
;		Started to change timings, make adjustment easier
;		Added Screenshot functionality
;	1.9	Now Server working as Consoleapp with STD-IO
;------------------------------------------------------------------------
;	Planned Features
;------------------------------------------------------------------------
;		Search for exc items -> Pixelsearch in 4 areas UL,UR,LL,LR by checkbox
;			-search color, click at returned coords, pick, click to return to previous spot
;			-ADDED this feature, but not working due to failure in pixelsearch T_T
;		Bitmap analysis, need proper struct for bitmap
;		Ignore Mana in Inventory
;		Auto Logon with GUI Interaction


#EndRegion Version History Comments

Dim $MajorVer = "2."
Dim $MinorVer = "0.0"
Dim $Bot_Name = " Chaos Bot"
#Region AutoIt3Wrapper directives section
;===============================================================================================================
;** AUTOIT3 settings
#AutoIt3Wrapper_Run_Debug_Mode=N                 ;(Y/N)Run Script with console debugging. Default=N
;===============================================================================================================
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=IC2a.ico           		;Filename of the Ico file to use
#AutoIt3Wrapper_Outfile=Tablet.exe      		;Target exe/a3x filename.
#AutoIt3Wrapper_Outfile_Type=exe         		;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=4             		;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=Y                 		;(Y/N) Compress output program. Default=Y
;===============================================================================================================
;** Target program Resource info
#AutoIt3Wrapper_Res_Comment=Use at your own risk - ALWAYS BETA				;Comment field
#AutoIt3Wrapper_Res_Description=Chaos Bot - a muonline autobot program		;Description field
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=N  ;(Y/N/P) AutoIncrement FileVersion After Aut2EXE is finished. default=N
;                                                P=Prompt, Will ask at Compilation time if you want to increase the version number.
;#AutoIt3Wrapper_Res_Language=                   ;Resource Language code . default 2057=English (United Kingdom)
#AutoIt3Wrapper_Res_LegalCopyright=All rights reserved by the author             ;Copyright field
;#AutoIt3Wrapper_res_requestedExecutionLevel=    ;None, asInvoker, highestAvailable or requireAdministrator (default=None)
;
;===============================================================================================================
; Obfuscator
;#AutoIt3Wrapper_Run_Obfuscator=Y                 ;(Y/N) Run Obfuscator before compilation. default=N
;#Obfuscator_Parameters=/SF /SV /CV /CF /CS /CN
;===============================================================================================================
#EndRegion AutoIt3Wrapper directives section

;--------------------------------------
; General Settings & Includes, Options will be set from ini file
;--------------------------------------
#include <Constants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiTab.au3>
#include <Date.au3>
#include <String.au3>
#include <Misc.au3>
#include <GuiCombo.au3>
#include <A3LScreenCap.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

#NoTrayIcon
;AutoItSetOption("TrayIconDebug",1)	;Zeigt im Icon die aktuelle Scriptzeile an

AutoItSetOption("MustDeclareVars", 1) ;Alle Variablen müssen vor der Verwendung deklariert werden
AutoItSetOption("GUICloseOnESC", 0) ;GUI wird nicht beendet, wenn ESC gedrückt wird
AutoItSetOption("SendCapslockMode", 0)	;0: Dont store, 1: Store Capsstate before send (DEFAULT)
AutoItSetOption("WinWaitDelay", 50) ;Zeit nach einer Windowsaktion (default is 250ms)
AutoItSetOption("PixelCoordMode", 2) ;1:Absolute Coordiante 2:Relative Position zur aktuellen Clientarea 0:relative to window
AutoItSetOption("MouseCoordMode", 2) ;1:Absolute Coordiante 2:Relative Position zur aktuellen Clientarea
AutoItSetOption("WinTitleMatchMode", 3) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

#Region Global and Constants
;--------------------------------------
; Constants and Globals
;--------------------------------------

;Variablen für die Deklaration weiterer Optionen
Dim $Opt_KeyDelay = 100, $Opt_KeyDownDelay = 100, $Opt_MouseClickDelay = 100, $Opt_MouseClickDownDelay = 100

; GUI Definitions
Dim $msg[5], $ctrl_StartStop, $ctrl_MuStart, $ctrl_Ampel, $lbl_Pick, $Ampel_Color
Dim $tab, $tabEE, $tabAE, $tabDW, $tabDK, $tabAFK, $tabOpt
Dim $ctrl_Buff_Delay, $ctrl_PM[5], $ctrl_Pick ;Each Array has 5 Elemente, index ranges from 0..4
Dim $ctrl_PM_Def[5], $ctrl_PM_Dam[5], $ctrl_PM_Heal[5], $ctrl_PM_Heal_Delay[5]
Dim $ctrl_AE_WStart, $ctrl_AE_WStop, $ctrl_AE_WDiff, $ctrl_AE_Dist, $ctrl_AE_Dist1
Dim $ctrl_AE_Hybrid, $ctrl_AE_EE, $ctrl_AE_Skill, $ctrl_AE_Delay, $ctrl_AE_Power
Dim $ctrl_DW_Skill, $ctrl_DW_Skill2, $ctrl_DW_Delay
Dim $ctrl_DW_Delay2, $ctrl_DW_Protect, $ctrl_DW_Power, $ctrl_DW_Party
Dim $hMain, $sMain, $MuExe
Dim $Hotkeys_D = "Tastenbelegung:" & @CR
Dim $Hotkeys_E = "Hotkeys:" & @CR ;String to hold Tooltip for Hotkeys

;General Definitions
Dim $WHandle = "MU" ;Handle for Mu Window Aktivation, Default is Text MU
Dim $WSize[2] ;Windowsize in Pixeln [0] = X, [1] = Y
Dim $WBase[2] ;Windowposition on Desktop [0] = X, [1] = Y
Dim $DSize[2] ;Desktopsize in Pixeln [0] = X, [1] = Y
Dim $cnt
Dim $Config_File = @ScriptDir & "\" & StringStripWS($Bot_Name, 3) & ".ini" ;Ini file to store some values
Dim $Log_File ;Debug Log file
Dim $Do_Log = False ;flag to enable debug
Dim $Buff_Timer, $Buff_Last ;For all Bufftimings (not just EE)
Dim $Key_Delay = 100 ;Pause after key press
Dim $Skill_Last = 99 ;Stores last used Skill, to avoid multiple sends
Dim $RMouse_Down = False ;used with Powermode - Status of right mousebutton
Dim $Mouse_Speed = 2 ;Mouse Move Speed
Dim $pi = 3.1415926535897
Dim $err = -1 ;Error codes
Dim $PauseTime = 10 ;Pause time when F7 is pressed
Dim $vDLL, $RegRoot
Dim $Mu_User, $Mu_Pass, $Mu_WinMode, $Mu_Sound, $UserArray
Dim $ctrl_WinMode, $ctrl_Sound, $ctrl_UserArray
Dim $ModifierKey, $Do_Color

;Networking Definitions
Dim $netAppName = @ScriptName
Dim $netData, $netServer, $ServerDelay
Dim $netLock, $aKeys[5], $pKeyStart, $pKeyEnd

; Bot Definitions
Dim $Bot_Mode = 2 ; EE = 1, AE = 2, DW = 3, DK = 4, 0 for testing code
Dim $Do_Pick = False
Dim $Do_Run = False 
Dim $Do_Stop = False
Dim $Do_Chat = False ;Pauses Bot for chat
Dim $Chat_Init = False ;Flag to manage Chat Hotkey
Dim $Do_LClick = False ;Leftclick for Shoppping, Statpunkte
Dim $Do_X, $Do_Y ;common X,Y storage (zB AFK Tab)
Dim $Bot_Pos[4] 

; EE Definitions
Dim $EE_Heal = "2"
Dim $EE_Defense = "3"
Dim $EE_Damage = "4"
Dim $EE_Summon = "5"
Dim $Party_Size = "3" ;1 - 5 möglich
Dim $Do_Defense = False
Dim $Do_Damage = False
Dim $Do_Heal = False
Dim $EE_Buff_Delay = 54000 ;Pause in Millisekunden
Dim $ctrl_Key_Def, $ctrl_Key_Dam, $ctrl_Key_Heal
Dim $EE_PM_Def[5], $EE_PM_Dam[5], $EE_PM_Heal_Delay[5] ;if Heal_delay = 0, don't heal PM
Dim $EE_PM_Timer[5], $EE_PM_Last[5] ;Keep track of Heal Timing
Dim $PM_X[5], $PM_Y[5] ;keeps all locations for PMs
Dim $PM_Factor ;Distance Multiplier from PM x to PM x+1
Dim $PM_XFactor; Horizontal multiplier for Partymemberpos.
Dim $PM_Base ;Startoffset for PM 1

; AE Definitions
Dim $AE_Skill = 1 ;Taste für Skill
Dim $AE_Skill_Delay ;Delay MouseUp for continuous shooting
Dim $AE_Skill_Duration ;Mousedown for single shot
Dim $AE_Power = False ;enables power mode
Dim $AE_Winkel_Start = 0 ;Startangle (runs clockwise)
Dim $AE_Winkel_Stop2 ;Stopangle, if == Startangle -> 360° Mode
Dim $AE_Winkel_Stop = 0 ;Stopangle for display in GUI
Dim $AE_Winkel_Diff = 30
Dim $AE_Winkel = 0	;current Angle
Dim $AE_Dist[2] 	;Distance from Center position
Dim $AE_Dist_Flag = 0	;Selects the proper Distance from Array
Dim $AE_Hybrid = False ;enable Selfbuff with settings for PM 1
Dim $AE_EE_Mode = False ;enable partybuff with settings from EE tab
Dim $AE_X, $AE_dX, $AE_Y, $AE_dY ;position for shot
Dim $ctrl_AE_NoSkill, $AE_NoSkill ;do normal attack (DK Mode)
Dim $AE_DoInfinity, $ctrl_AE_Infinity, $AE_Inf_Skill, $ctrl_AE_InfSkill
Dim $AE_Inf_Delay, $AE_Inf_Timer, $AE_Inf_Last
Dim $AE_Raven, $ctrl_AE_Raven, $AE_Raven_Delay, $AE_Raven_Timer, $AE_Raven_Last
Dim $AE_Raven_Alive, $ctrl_AE_RavenTime, $AE_Raven_Time, $AE_Raven_Off_Init, $AE_Raven_Off_Timer

; DW Definitions
Dim $DW_Skill = "1" ;Default Skill
Dim $DW_Delay = 800
Dim $DW_Protect = False ;Use second skill (SM Soul barrier, or Fortitude for BK)
Dim $DW_Skill2 = "0" ;Soul Barrier, oder Fortitude für DK
Dim $DW_Delay2 = 65000 ;Soul Barrier Delay, oder Fortitide für DK
Dim $DW_Power = False ;Powermode on / off
Dim $DW_Party = False ;Should EE Def skill be used? (Soul Barrier for Party)
Dim $DK_Combo, $DK_Combo_1, $DK_Combo_2, $DK_Combo_3, $DK_Combo_Delay, $DK_Combo_Hotkey
Dim $ctrl_Combo, $ctrl_Combo1, $ctrl_Combo2, $ctrl_Combo3, $ctrl_Combo_Delay
Dim $ctrl_ComboD1, $ctrl_ComboD2, $ctrl_ComboD3, $DK_Combo_D1, $DK_Combo_D2, $DK_Combo_D3

; AFK Definitions
Dim $ctrl_Accept, $AFK_Accept ;AutoAccept incoming requests
Dim $ctrl_Req, $AFK_Request ;Request on/off
Dim $ctrl_Off, $ctrl_Off_h, $ctrl_Off_min ;Autoshutdown Controls
Dim $ctrl_Shop, $Do_Shop ;left clicker
Dim $Do_Shutdown = False
Dim $AFK_Off_h, $AFK_Off_min, $Shutdown_Mode
Dim $Do_Repair, $ctrl_Repair, $ctrl_RepDelay ; Repaair flag, GUI Controls
Dim $AFK_RepTimer, $AFK_RepLast, $AFK_RepDelay	;Timers, Last Timestamp, Delay
Dim $Do_AFK, $ctrl_AFK
Dim $AFK_Pos[2] ;Saves mouse position for full afk mode
Dim $Do_Macro, $ctrl_Macro, $MacroList[10] ;Chat macros for shopping messages
Dim $Do_MLoad, $ctrl_MLoad, $MacroFile ;Loading macros from file
Dim $Macro_Timer, $Macro_Last, $Macro_Delay
Dim $Macro_Cnt, $Macro_Current
Dim $ctrl_UsePots, $ctrl_Pots, $ctrl_PotsDelay
Dim $Pots = "QE", $Do_UsePots, $PotsDelay = 120000 ;Delay in ms, wird als Minuten angezeigt -> Umrechnen
Dim $Pots_Timer, $Pots_Last
Dim $ctrl_AutoParty, $AutoParty_XY[2], $AutoParty_Pos, $AP_Dist
Dim $Do_AutoParty, $AP_Timer, $AP_Delay, $AP_Last, $AP_Sleep
Dim $ctrl_MuPath, $Do_Test
Dim $Drop_XY[2], $Drop_Row, $Drop_Col, $Drop_Row_Counter, $Drop_Col_Counter, $Drop_Row_Tracker
Dim $Drop_Timer, $Drop_Last, $Drop_Delay, $Drop_Dura_Last, $Drop_Dura_Timer, $Drop_Dura_Delay
Dim $Do_Drop, $ctrl_DropDelay, $ctrl_DropInv, $ctrl_DropPos, $Drop_Pos_Set = False
Dim $ctrl_DropX, $ctrl_DropY
Dim $ctrl_SS_Enable, $ctrl_SS_Delay, $ctrl_SS_Delete
Dim $Do_ScreenShot, $SS_Delay, $SS_Timer, $SS_Last, $SS_Path, $SS_MU_Type, $SS_Hours
Dim $C_InvOpen, $C_InvOpenY, $C_InvOpenR, $C_IsParty, $C_RavenAlive, $C_Tol	;Color values for different uses, C_Tol is the tolerance used in PixelSearch
Dim $C_InvEmpty, $C_Ignore1, $C_Ignore2, $C_Friend, $C_Open, $C_Disco, $C_Excellent
Dim $Do_ExcUL, $Do_ExcUR, $Do_ExcLL, $Do_ExcLR, $ctrl_ExcUL, $ctrl_ExcUR, $ctrl_ExcLL, $ctrl_ExcLR
Dim $ExcTile[8][4]
Dim $aXY_DC[13], $Do_Disco
#EndRegion Global and Constants


#Region Main_Start
;----------------------------------------------------
; Programmbeginn
;----------------------------------------------------
$sMain = $Bot_Name & "  " & $MajorVer & $MinorVer
If _Singleton($Bot_Name, 1) = 0 Then
	Exit 1
EndIf

If $CmdLine[0] >= 1 Then
	$Config_File = @ScriptDir & "\" & $CmdLine[1]
EndIf

_RegistrySetup()

If FileExists($Config_File) Then
	_ReadConfig()
	If $Do_Log == True Then
		_LogStart()
	EndIf
	_LogWrite("Configfile was read: " & $Config_File)
Else
	MsgBox(0x41010, "Fatal Error", $Config_File & " could not be read!" & @CRLF & _
			"Must be in same directory as Bot.")
	Exit 1
EndIf

AutoItSetOption("SendKeyDelay", $Opt_KeyDelay) ;Delay between keystrokes
AutoItSetOption("SendKeyDownDelay", $Opt_KeyDownDelay)
AutoItSetOption("MouseClickDelay", $Opt_MouseClickDelay) ;Delay between mouseclicks
AutoItSetOption("MouseClickDownDelay", $Opt_MouseClickDownDelay) ;mouse key downtime

FileInstall("KeyServer.exe", @TempDir & "\" & $netAppName, 1)	;Save the KeyServer to the temp folder

If FileExists(@TempDir & "\" & $netAppName) Then	;Run the keyserver as child process, attach to STDIN/OUT pipes
	$netServer = Run(@TempDir & "\" & $netAppName, @TempDir, @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)
EndIf
ProcessWait($netAppName, 500)	;Make sure it is running

$vDLL = DllOpen("user32.dll")

_CreateBotGUI()

;Setup the KeyServer:
_RemoteSend("$$PATH=" & @ScriptDir)
If $Do_Log == True Then _RemoteSend("DEBUG ON")

_RemoteSend("$$KDLY=" & $Opt_KeyDelay)
_RemoteSend("$$KDWN=" & $Opt_KeyDownDelay)
_RemoteSend("$$MDLY=" & $ServerDelay)
_RemoteSend("$$BWND=" & $sMain)
_RemoteSend("$$WDLY=" & 10000)

HotKeySet("{F5}", "_StartMuButton")
HotKeySet("{F6}", "_TogglePick")
HotKeySet("{F7}", "_PauseIt")
HotKeySet("{F8}", "_ToggleClick") ;Will be disabled in _BotStart
HotKeySet("{F9}", "_BotStart")
HotKeySet($ModifierKey & "{UP}", "_IncreaseDelay")
HotKeySet($ModifierKey & "{DOWN}", "_DecreaseDelay")
HotKeySet($ModifierKey & "{LEFT}", "_OptionDec")
HotKeySet($ModifierKey & "{RIGHT}", "_OptionInc")
HotKeySet($ModifierKey & "{F5}", "_DropSetup")
HotKeySet($ModifierKey & "{F6}", "_ToggleAFK")
HotKeySet($ModifierKey & "{F7}", "_TogglePower")
HotKeySet($ModifierKey & "{F8}", "_SaveConfig")
HotKeySet($ModifierKey & "{F9}", "_SetHandle")
HotKeySet($ModifierKey & "{NUMPADADD}", "_PlusParty")
HotKeySet($ModifierKey & "{NUMPADSUB}", "_MinusParty")
HotKeySet($ModifierKey & "{PGUP}", "_Option2Inc")
HotKeySet($ModifierKey & "{PGDN}", "_Option2Dec")
	;Just for test purposes
;~ 	HotKeySet("!1", "CaptureTest1")
;~ 	HotKeySet("!2", "CaptureTest2")
;~ 	HotKeySet("!3", "CaptureTest3")

$Hotkeys_D = $Hotkeys_D & "F6:  AutoPick an/aus" & @CR & "F7:  10 sec. Pause" & @CR & _
		"F8:  Links Clicker" & @CR & "F9:  Start/Stop Bot" & @CR & "<ALT><DOWN>:  Verzögerung verringern" & @CR & _
		"<ALT><UP>:  Verzögerung erhöhen" & @CR & "<ALT><LEFT>:  Kleinerer Winkel/2.Delay" & @CR & _
		"<ALT><RIGHT>:  größerer Winkel/2.Delay" & @CR & "<ALT><SeiteHoch>: Heal Delay / Entfernung erhöhen" & @CR & _
		"<ALT><SeiteRunter>: Heal Delay / Entfernung verringern" & @CR & "<ALT>Ziffernblock<+>: größere Party" & @CR & _
		"<ALT>Ziffernblock<->: kleinere Party" & @CR & "<ALT><F5>:  Position zum Item Drop setzen" & @CR & _
		"<ALT><F6>:  AFK Mode an/aus - Mauspos. setzen" & @CR & "<ALT><F7>:  Power Mode an/aus" & @CR & _
		"<ALT><F8>:  Konfiguration Sichern" & @CR & "<ALT><F9>:  aktuelles Fenster wählen" & @CR & _
		"<RETURN>:  Bot anhalten für Chat"
$Hotkeys_E = $Hotkeys_E & "F6:  AutoPick on/off" & @CR & "F7:  10 sec. Break" & @CR & _
		"F8:  Left Clicker" & @CR & "F9:  Start/Stop Bot" & @CR & "<ALT><DOWN>:  reduce Delay" & @CR & _
		"<ALT><UP>:  increase Delay" & @CR & "<ALT><LEFT>:  smaller Angle/2.Delay" & @CR & _
		"<ALT><RIGHT>:  bigger Angle/2.Delay" & @CR & "<ALT><PageUp>:  increase Heal Delay / Distance" & @CR & _
		"<ALT><PageDown>:  reduce Heal Delay / Distance" & @CR & "<ALT>Numpad<->:  smaller Party" & @CR & _
		"<ALT>Numpad<+>:  bigger Party" & @CR & "<ALT><F5>:  Set Item Drop Position" & @CR & _
		"<ALT><F6>:  AFK Mode on/off - Set Mouse Pos." & @CR & "<ALT><F7>:  Toggle Power Mode for AE/DW" & @CR & _
		"<ALT><F8>:  Save Configuration" & @CR & "<ALT><F9>:  Select current window" & @CR & _
		"<RETURN>:  Activate Chat Mode"

HotKeySet($ModifierKey & "{F10}", "_LogStart")
;~ HotKeySet("!{F10}", "_LogStart")
HotKeySet("{F10}", "_StopLog")
$Hotkeys_D = $Hotkeys_D & @CR & "<F10>:  Log anhalten" & @CR & "<ALT><F10>:  Log aktivieren"
$Hotkeys_E = $Hotkeys_E & @CR & "<F10>:  Disable Logging" & @CR & "<ALT><F10>:  Enable Logging"

GUICtrlSetTip($ctrl_MuStart, $Hotkeys_D)
GUICtrlSetTip($ctrl_StartStop, $Hotkeys_E)
#EndRegion Main_Start

While 1
	
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			_SaveConfig()
			_StopServer()
			ExitLoop
		Case $ctrl_MuStart
			If Not $Do_Run Then
				_StartMuButton()
			EndIf
		Case $ctrl_StartStop
			If $Do_Run Then
				_BotHalt()
			Else
				_BotStart()
			EndIf
		Case $ctrl_Pick
			_TogglePick()
		Case $ctrl_PM_Heal_Delay[0]
			$EE_PM_Heal_Delay[0] = Int(GUICtrlRead($ctrl_PM_Heal_Delay[0])) * 1000
		Case $ctrl_PM_Heal_Delay[1]
			$EE_PM_Heal_Delay[1] = Int(GUICtrlRead($ctrl_PM_Heal_Delay[1])) * 1000
		Case $ctrl_PM_Heal_Delay[2]
			$EE_PM_Heal_Delay[2] = Int(GUICtrlRead($ctrl_PM_Heal_Delay[2])) * 1000
		Case $ctrl_PM_Heal_Delay[3]
			$EE_PM_Heal_Delay[3] = Int(GUICtrlRead($ctrl_PM_Heal_Delay[3])) * 1000
		Case $ctrl_PM_Heal_Delay[4]
			$EE_PM_Heal_Delay[4] = Int(GUICtrlRead($ctrl_PM_Heal_Delay[4])) * 1000
		Case $ctrl_AFK
			_ToggleAFK()
		Case $ctrl_DW_Power
			_TogglePower()
		Case $ctrl_AE_Hybrid
			_ToggleHybrid()
		Case $ctrl_AE_EE
			_ToggleEE()
		Case $ctrl_MLoad
			_LoadMacro($Macro_Cnt, $Macro_Current)
		Case $ctrl_MuPath
			;_Mu_GetPixel($WHandle, 100, 100)
			;$cnt = _DetectPartySize()
			;MsgBox(0, "Party Size", $cnt, 3)
			;_Mu_GetPixelColor($WHandle, 150, 150)
			;_SaveScreenShot()
			_SelectMuPath()
		Case $ctrl_SS_Delete
			_DeleteScreenshots()
		Case $ctrl_UserArray
			_SetUserData()
	EndSwitch

;~ 	$cnt = 0
;~ 	While _IsPressed("10", $vDLL) Or _IsPressed("11", $vDLL) Or _IsPressed("12", $vDLL)
;~ 		$cnt += 1
;~ 		If $cnt > 65 Then
;~ 			ExitLoop
;~ 			_LogWrite("TIMEOUT in Option Key Check.")
;~ 		EndIf
;~ 		Sleep(100)
;~ 	WEnd
;~ 	$cnt = 0
	
	If $Do_Stop Then ;BOT WURDE GERADE ANGEHALTEN
		$Do_Stop = False
		If $RMouse_Down Then
			MouseUp("Right")
			$RMouse_Down = False
		EndIf
		If $Do_Pick Then _RemoteSend("PICK OFF")
		If $AFK_Request Then ;Falls Requests abgelehnt werden...
			$AFK_Request = False
			_SetRequestOff(False) ;Damit werden Requests wieder erlaubt
		EndIf
		;Sleep($Key_Delay)
		If $Mu_Pass <> "" Then
			ClipPut($Mu_Pass)
		EndIf
		_LogWrite("Bot wurde jetzt angehalten")

	EndIf

	If $Do_Shutdown And $Do_Run Then
		_Shutdown()
	EndIf

	If $Do_LClick And Not $Do_Run Then
		_LeftClick($Opt_MouseClickDownDelay/2)
	EndIf
	
	If $Do_Run And WinActivate($WHandle) == 0 Then
		_BotHalt()
	EndIf
	
	If $Do_Run And WinActivate($WHandle) == 1 Then
		
		If $Do_Macro Then
			_SendMacro()
		EndIf
		
		If $Bot_Mode < 5 Then
			If $Do_Repair And $Do_Run Then
				_RepairAll()
			EndIf
			
			If $Do_Drop And $Do_Run And $Drop_Pos_Set Then
				_DropItems($Drop_Col, $Drop_Row, $Drop_XY[0], $Drop_XY[1])
			EndIf
			
			If $Do_UsePots Then
				_UsePots()
			EndIf
			
			If $Do_AutoParty And $Do_Run Then
				_AutoParty()
			EndIf
			
			If $Do_Run And $Do_ScreenShot Then
				_SaveScreenShot()
			EndIf

			If $Do_AFK And $Do_Color == True Then
				_SanityCheck()
			EndIf
			
;~ 			_SearchExcellent()
			
		EndIf

		While $Do_Chat And $Do_Run
			;Loop forever until Chat mode is false
			If $Chat_Init Then
				If $Do_Pick Then _RemoteSend("PICK OFF")
				$Chat_Init = False
				HotKeySet("{ENTER}")
				Sleep($Key_Delay)
				_RemoteSend("{ENTER}") ;Open Chat Dialog
				HotKeySet("{ENTER}", "_ToggleChat")
				Sleep($Key_Delay)
			EndIf
			Sleep(500)
			
			$msg = GUIGetMsg() ; Make sure that this loop can be exited
			Switch $msg
				Case $GUI_EVENT_CLOSE
					_SaveConfig()
					_StopServer()
					ExitLoop
			EndSwitch
		WEnd

		If $Do_Chat And $Do_Stop Then
			$Do_Chat = False
			If $Chat_Init Then
				$Chat_Init = False
			Else
				_RemoteSend("{ENTER}")
			EndIf
		EndIf

		Switch $Bot_Mode
			Case 1 ; EE Mode für Party Buff
				$Buff_Timer = TimerDiff($Buff_Last)
				If $Buff_Timer > $EE_Buff_Delay Then
					$Buff_Last = TimerInit()
					_LogWrite("EE MODE: Current Party Size detected: " & _DetectPartySize())
					If $Party_Size == 1 Then ;Buff at current Cursorposition
						If $Do_AFK Then
							MouseMove($AFK_Pos[0], $AFK_Pos[1], $Mouse_Speed)
						EndIf
						If $EE_PM_Heal_Delay[0] > 0 Then
							$EE_PM_Last[0] = TimerInit()
							_DoSkill(0, 0, $EE_Heal)
						EndIf
						_DoSkill(0, 0, $EE_Defense)
						_DoSkill(0, 0, $EE_Damage)
					Else ;Buff alle Partymember
						For $cnt = 0 To $Party_Size - 1
							If $Do_Stop Then
								ContinueLoop
							EndIf
							If $EE_PM_Heal_Delay[$cnt] > 0 Then
								$EE_PM_Last[$cnt] = TimerInit()
								_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Heal)
							EndIf
							If $Do_Stop Then
								ContinueLoop
							EndIf
							If $EE_PM_Def[$cnt] Then
								_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Defense)
							EndIf
							If $Do_Stop Then
								ContinueLoop
							EndIf
							If $EE_PM_Dam[$cnt] Then
								_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Damage)
							EndIf
						Next
					EndIf
				EndIf
				If $Party_Size == 1 Then
					If $EE_PM_Heal_Delay[0] > 0 Then
						$EE_PM_Timer[0] = TimerDiff($EE_PM_Last[0])
						If $EE_PM_Timer[0] > $EE_PM_Heal_Delay[0] Then
							$EE_PM_Last[0] = TimerInit()
							_DoSkill(0, 0, $EE_Heal)
						EndIf
					EndIf
				Else
					For $cnt = 0 To $Party_Size - 1 ;Extra Heal Buff if timer is up
						If $Do_Stop Then
							ContinueLoop
						EndIf
						If $EE_PM_Heal_Delay[$cnt] > 0 Then
							$EE_PM_Timer[$cnt] = TimerDiff($EE_PM_Last[$cnt])
							If $EE_PM_Timer[$cnt] > $EE_PM_Heal_Delay[$cnt] Then
								$EE_PM_Last[$cnt] = TimerInit()
								_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Heal)
							EndIf
						EndIf
					Next
				EndIf
			Case 2 ; AE Mode incl. Hybrid
				If $AE_Raven Then	;Refresh the raven attack command OR disable raven attack
					$AE_Raven_Off_Timer = TimerDiff($AE_Raven_Off_Init)
					If $AE_Raven_Off_Timer < $AE_Raven_Time*60000 Then
						$AE_Raven_Timer = TimerDiff($AE_Raven_Last)
						If $AE_Raven_Timer > $AE_Raven_Delay Then
							_Raven_Attack(True)
							$AE_Raven_Last = TimerInit()
						EndIf
					Else
						$AE_Raven = False
						_Raven_Attack(False)
					EndIf
				EndIf
				If $AE_EE_Mode Then	;Buff all PM
					$Buff_Timer = TimerDiff($Buff_Last)
					If $Buff_Timer > $EE_Buff_Delay Then
						$Buff_Last = TimerInit()
						If $AE_Power And $RMouse_Down Then
							MouseUp("Right")
						EndIf
						If $Party_Size > 1 Then
							For $cnt = 0 To $Party_Size - 1
								If $Do_Stop Then
									ContinueLoop
								EndIf
								If $EE_PM_Heal_Delay[$cnt] > 0 Then
									$EE_PM_Last[$cnt] = TimerInit()
									_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Heal)
								EndIf
								If $Do_Stop Then
									ContinueLoop
								EndIf
								If $EE_PM_Def[$cnt] Then
									_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Defense)
								EndIf
								If $Do_Stop Then
									ContinueLoop
								EndIf
								If $EE_PM_Dam[$cnt] Then
									_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Damage)
								EndIf
							Next
						Else
							If $Do_AFK Then
								MouseMove($AFK_Pos[0], $AFK_Pos[1], $Mouse_Speed)
							EndIf
							If $EE_PM_Heal_Delay[0] > 0 Then
								$EE_PM_Last[0] = TimerInit()
								_DoSkill(0, 0, $EE_Heal)
							EndIf
							_DoSkill(0, 0, $EE_Defense)
							_DoSkill(0, 0, $EE_Damage)
						EndIf
						If $AE_Power And $RMouse_Down Then
							MouseDown("Right")
						EndIf
					EndIf
				EndIf
				If $AE_Hybrid Then ;Do Self - Buff
					$Buff_Timer = TimerDiff($Buff_Last)
					If $Buff_Timer > $EE_Buff_Delay Then
						$Buff_Last = TimerInit()
						If $EE_PM_Def[0] And $Do_Run Then
							_DoSkill($AE_X, $AE_Y, $EE_Defense)
						EndIf
						If $Do_Stop Then
							ContinueLoop
						EndIf
						If $EE_PM_Dam[0] And $Do_Run Then
							_DoSkill($AE_X, $AE_Y, $EE_Damage)
						EndIf
						If $Do_Stop Then
							ContinueLoop
						EndIf
						If $EE_PM_Heal_Delay[0] > 0 And $Do_Run Then
							$EE_PM_Last[0] = TimerInit()
							_DoSkill($AFK_Pos[0], $AFK_Pos[1], $EE_Heal)
						EndIf
					EndIf
					If $Do_Stop Then
						ContinueLoop
					EndIf
					If $EE_PM_Heal_Delay[0] > 0 & $Do_Run Then
						$EE_PM_Timer[0] = TimerDiff($EE_PM_Last[0])
						If $EE_PM_Timer[0] > $EE_PM_Heal_Delay[0] Then
							$EE_PM_Last[0] = TimerInit()
							_DoSkill($AFK_Pos[0], $AFK_Pos[1], $EE_Heal)
						EndIf
					EndIf
				EndIf
				If $AE_DoInfinity Then
					$AE_Inf_Timer = TimerDiff($AE_Inf_Last)
					If $AE_Inf_Timer > $AE_Inf_Delay Then
						If $AE_Power And $RMouse_Down Then
							MouseUp("Right")
						EndIf
						_StopInfinity()
						_DoSkill($AE_X, $AE_Y, $AE_Inf_Skill)
						If $AE_Power And $RMouse_Down Then
							MouseDown("Right")
						EndIf
						$AE_Inf_Last = TimerInit()
					EndIf
				EndIf
				
				$AE_Dist_Flag = Mod($AE_Dist_Flag+1, 2)
				$AE_dX = Round(Cos($AE_Winkel * $pi / 180) * $WSize[1] / 800 * $AE_Dist[$AE_Dist_Flag])
				$AE_dY = Round(Sin($AE_Winkel * $pi / 180) * $WSize[1] / 800 * $AE_Dist[$AE_Dist_Flag])
				_DoShoot($AE_X + $AE_dX, $AE_Y + $AE_dY, $AE_Skill, $AE_Skill_Delay)
				$AE_Winkel += $AE_Winkel_Diff
				If $AE_Winkel > $AE_Winkel_Stop2 - 1 Then ;reset to start -1, so it wont shoot 0 position twice
					$AE_Winkel = $AE_Winkel_Start
				EndIf

			Case 3 ; Mode for DW / DK / MG
				If Not $DK_Combo Then	;Ignore other settings if Combo is active
					If $DW_Party Then	; Perform Defense Buff for partymembers
						$Buff_Timer = TimerDiff($Buff_Last)
						If $Buff_Timer > $EE_Buff_Delay Then
							$Buff_Last = TimerInit()
							For $cnt = 0 To $Party_Size - 1
								If $EE_PM_Def[$cnt] Then
									_DoSkill($PM_X[$cnt], $PM_Y[$cnt], $EE_Defense)
								EndIf
								If $Do_Stop Then
									ContinueLoop
								EndIf
							Next
						EndIf
					EndIf

					If $Do_AFK Then	;Move mouse before skilling
						MouseMove($AFK_Pos[0], $AFK_Pos[1], $Mouse_Speed)
					EndIf
					_DoSkill(0, 0, $DW_Skill, $DW_Delay)
				Else ;DK Combo Action
					If _IsPressed($DK_Combo_Hotkey, $vDLL) Then
						_DoSkill(0, 0, $DK_Combo_1, $DK_Combo_D1)
						_DoSkill(0, 0, $DK_Combo_2, $DK_Combo_D2)
						_DoSkill(0, 0, $DK_Combo_3, $DK_Combo_D3 / 2)
						_DoSkill(0, 0, $DK_Combo_3, $DK_Combo_D3 / 2)	;Do it twice, to make sure that it works at least once ;)
						_RemoteSend($DK_Combo_1)	;Select standard skill again
					EndIf
				EndIf
				If $DW_Protect Then		;Use second skill, Soul barrier, or Fortitude
					$Buff_Timer = TimerDiff($Buff_Last)
					If $Buff_Timer > $DW_Delay2 Then
						$Buff_Last = TimerInit()
						If $DW_Power And $RMouse_Down Then	;When using Nova on Mainskill, this will stop the charging
							MouseUp("Right")
						EndIf
						_DoSkill(0, 0, $DW_Skill2)
						If $DW_Power And $RMouse_Down Then
							_RemoteSend($DW_Skill)	;Select primary Skill again
							MouseDown("Right")
						EndIf
					EndIf
				EndIf

			Case 5 ; Opt Tab
				If $AFK_Accept Then		;On Opt tab only execute Accept
					$Do_X = Round($WSize[0] * 0.415)
					$Do_Y = Round($WSize[1] * 0.22)
					MouseMove($Do_X, $Do_Y, $Mouse_Speed)
					_RemoteSend("{SHIFTDOWN}")	;Avoid character move, not reliable, as MU does not always keep from moving
					_LeftClick()
					_RemoteSend("{SHIFTUP}")
					Sleep(2500) ;Click every 2.5 seconds so Request does not time out
				EndIf
		EndSwitch
	EndIf
WEnd

DllClose($vDLL)
;_StopServer()

;###############################################################################
; END OF MAIN LOOP
;###############################################################################

Func _CreateBotGUI()
	Local $index
	
	;Restore Bot position, unless it is off screen
	If $Bot_Pos[0] > (@DesktopWidth - 50) Then $Bot_Pos[0] = @DesktopWidth - 50
	If $Bot_Pos[1] > (@DesktopHeight - 50) Then $Bot_Pos[1] = @DesktopHeight - 50
	If $Bot_Pos[0] < 0 Then $Bot_Pos[0] = 0
	If $Bot_Pos[1] < 0 Then $Bot_Pos[1] = 0

	$hMain = GUICreate($sMain, 213, 305, $Bot_Pos[0], $Bot_Pos[1])
	GUISetIcon("IC2b.ico")

	$tab = GUICtrlCreateTab(1, 5, 213, 265)

	;################ EE TAB CREATION #######################
	$tabEE = GUICtrlCreateTabItem(" EE") ;Erzeugt EE Tab, alle weiteren Controls beziehen sich nur auf EE Tab
	GUICtrlCreateLabel("Buff Delay (s):", 5, 35)
	$ctrl_Buff_Delay = GUICtrlCreateInput("", 80, 33, 30, 20)
	GUICtrlSetData($ctrl_Buff_Delay, $EE_Buff_Delay / 1000) ;Standardwert setzen
	GUICtrlSetTip($ctrl_Buff_Delay, "<ALT><UP> / <ALT><DOWN>")
	;Radiobuttons für die Auswahl der Partygröße
	GUICtrlCreateLabel("Party Size:", 5, 64)
	$ctrl_PM[0] = GUICtrlCreateRadio("1", 60, 60, 25)
	GUICtrlSetTip($ctrl_PM[0], "<ALT><Numpad +> / <ALT><Numpad ->")
	$ctrl_PM[1] = GUICtrlCreateRadio("2", 85, 60, 25)
	GUICtrlSetTip($ctrl_PM[1], "<ALT><Numpad +> / <ALT><Numpad ->")
	$ctrl_PM[2] = GUICtrlCreateRadio("3", 112, 60, 25)
	GUICtrlSetTip($ctrl_PM[2], "<ALT><Numpad +> / <ALT><Numpad ->")
	$ctrl_PM[3] = GUICtrlCreateRadio("4", 137, 60, 25)
	GUICtrlSetTip($ctrl_PM[3], "<ALT><Numpad +> / <ALT><Numpad ->")
	$ctrl_PM[4] = GUICtrlCreateRadio("5", 162, 60, 25)
	GUICtrlSetTip($ctrl_PM[4], "<ALT><Numpad +> / <ALT><Numpad ->")
	GUICtrlSetState($ctrl_PM[$Party_Size - 1], $GUI_CHECKED) ;Standardwert setzen, Einzel
	;Auswahl der einzelnen Buffs für die Partymembers
	GUICtrlCreateLabel("Party          Def  Dmg  HP    HPTime", 5, 90)
	For $cnt = 0 To 4 ;Erzeugen der einzelnen Checkboxen für die Partymemberbuffs
		GUICtrlCreateLabel("PM " & $cnt + 1, 5, 115 + $cnt * 25, 45, 20) ;PM Label
		$ctrl_PM_Def[$cnt] = GUICtrlCreateCheckbox("", 60, 110 + $cnt * 25, 20, 20) ;Checkbox Defense
		If $EE_PM_Def[$cnt] == 1 Then
			GUICtrlSetState($ctrl_PM_Def[$cnt], $GUI_CHECKED)
		Else
			GUICtrlSetState($ctrl_PM_Def[$cnt], $GUI_UNCHECKED)
		EndIf
		$ctrl_PM_Dam[$cnt] = GUICtrlCreateCheckbox("", 85, 110 + $cnt * 25, 20, 20) ;Checkbox Damage
		If $EE_PM_Dam[$cnt] == 1 Then
			GUICtrlSetState($ctrl_PM_Dam[$cnt], $GUI_CHECKED)
		Else
			GUICtrlSetState($ctrl_PM_Dam[$cnt], $GUI_UNCHECKED)
		EndIf
		$ctrl_PM_Heal[$cnt] = GUICtrlCreateCheckbox("", 110, 110 + $cnt * 25, 20, 20) ;Checkbox Heal
		$ctrl_PM_Heal_Delay[$cnt] = GUICtrlCreateInput("", 140, 110 + $cnt * 25, 30, 20) ;Inputfeld für Healdelay
		If $EE_PM_Heal_Delay[$cnt] == 0 Then
			GUICtrlSetState($ctrl_PM_Heal[$cnt], $GUI_UNCHECKED)
			GUICtrlSetData($ctrl_PM_Heal_Delay[$cnt], $EE_Buff_Delay / 1000) ;Standardwert für Healdelay setzen
		Else
			GUICtrlSetState($ctrl_PM_Heal[$cnt], $GUI_CHECKED)
			GUICtrlSetData($ctrl_PM_Heal_Delay[$cnt], $EE_PM_Heal_Delay[$cnt] / 1000) ;Standardwert für Healdelay setzen
		EndIf
		GUICtrlSetTip($ctrl_PM_Heal_Delay[$cnt], "Heal delay will not be " & @CR & "larger then Buff Delay" _
				 & @CR & "Change with <ALT><PGUP>/<PGDN>")
	Next
	GUICtrlCreateLabel("Keys:   Def", 5, 240)
	$ctrl_Key_Def = GUICtrlCreateInput("", 60, 238, 18, 18)
	GUICtrlSetData($ctrl_Key_Def, $EE_Defense)
	GUICtrlCreateLabel("Dam", 90, 240)
	$ctrl_Key_Dam = GUICtrlCreateInput("", 115, 238, 18, 18)
	GUICtrlSetData($ctrl_Key_Dam, $EE_Damage)
	GUICtrlCreateLabel("Heal", 140, 240)
	$ctrl_Key_Heal = GUICtrlCreateInput("", 165, 238, 18, 18)
	GUICtrlSetData($ctrl_Key_Heal, $EE_Heal)


	;################ AE TAB CREATION #######################
	$tabAE = GUICtrlCreateTabItem(" AE") ;Erzeugt AE Tab, beendet EE Tab, alle Befehle wirken auf AE Tab
	GUICtrlCreateLabel("Hybrid Mode", 5, 35)
	$ctrl_AE_Hybrid = GUICtrlCreateCheckbox("", 75, 33, 20, 20)
	GUICtrlSetTip($ctrl_AE_Hybrid, "This will use the EE settings" & @CR & "for PM1 to do self buff")
	If $AE_Hybrid == 1 Then
		GUICtrlSetState($ctrl_AE_Hybrid, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AE_Hybrid, $GUI_UNCHECKED)
		$AE_Hybrid = 0
	EndIf
	GUICtrlCreateLabel("Party Mode", 5, 60)
	$ctrl_AE_EE = GUICtrlCreateCheckbox("", 75, 58, 20, 20)
	GUICtrlSetTip($ctrl_AE_EE, "This will use the full EE Tab settings" & @CR & "Use <ALT><Numpad +/-> to change party size")
	If $AE_EE_Mode == 1 And $AE_Hybrid == 0 Then
		GUICtrlSetState($ctrl_AE_EE, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AE_EE, $GUI_UNCHECKED)
		$AE_EE_Mode = 0
	EndIf
	GUICtrlCreateLabel("Power Mode", 108, 60)
	$ctrl_AE_Power = GUICtrlCreateCheckbox("", 173, 58, 20, 20)
	GUICtrlSetTip($ctrl_AE_Power, "Shoots continuously" & @CR & "Use <ALT><F7> to toggle")
	If $AE_Power == 1 Then
		GUICtrlSetState($ctrl_AE_Power, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AE_Power, $GUI_UNCHECKED)
		$AE_Power = 0
	EndIf
	GUICtrlCreateLabel("No Skill Mode", 5, 85)
	$ctrl_AE_NoSkill = GUICtrlCreateCheckbox("", 75, 83, 20, 20)
	GUICtrlSetTip($ctrl_AE_NoSkill, "Will Right Click to attack" & @CR & "Ignores Skill Selection")
	If $AE_NoSkill == 1 Then
		GUICtrlSetState($ctrl_AE_NoSkill, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AE_NoSkill, $GUI_UNCHECKED)
		$AE_NoSkill = 0
	EndIf
	GUICtrlCreateLabel("AE Skill:", 5, 110)
	$ctrl_AE_Skill = GUICtrlCreateInput("", 75, 108, 18, 18)
	GUICtrlSetData($ctrl_AE_Skill, $AE_Skill)
	GUICtrlCreateLabel("Delay:", 110, 110)
	$ctrl_AE_Delay = GUICtrlCreateInput("", 145, 108, 36, 18)
	GUICtrlSetData($ctrl_AE_Delay, $AE_Skill_Delay)
	GUICtrlSetTip($ctrl_AE_Delay, "Use <ALT><UP>/<DOWN> to change")
	GUICtrlCreateLabel("Start/Stop Angle:", 5, 135)
	$ctrl_AE_WStart = GUICtrlCreateInput("", 105, 133, 28, 18)
	GUICtrlSetData($ctrl_AE_WStart, $AE_Winkel_Start)
	$ctrl_AE_WStop = GUICtrlCreateInput("", 145, 133, 28, 18)
	GUICtrlSetData($ctrl_AE_WStop, $AE_Winkel_Stop)
	GUICtrlCreateLabel("Angle Inc:", 5, 160)
	$ctrl_AE_WDiff = GUICtrlCreateInput("", 75, 158, 25, 18)
	GUICtrlSetData($ctrl_AE_WDiff, $AE_Winkel_Diff)
	GUICtrlCreateLabel("Distance:", 5, 185)
	$ctrl_AE_Dist = GUICtrlCreateInput("", 75, 183, 30, 18)
	GUICtrlSetData($ctrl_AE_Dist, $AE_Dist[0])
	GUICtrlSetTip($ctrl_AE_Dist, "Change with <ALT><PGUP>/<PGDN>")
	GUICtrlCreateLabel("Dist2:", 110, 185)
	$ctrl_AE_Dist1 = GUICtrlCreateInput("", 145, 183, 30, 18)
	GUICtrlSetData($ctrl_AE_Dist1, $AE_Dist[1])
	GUICtrlSetTip($ctrl_AE_Dist1, "This will be used every second skill")
	GUICtrlCreateLabel("Use Infinity", 5, 210)
	$ctrl_AE_Infinity = GUICtrlCreateCheckbox("", 75, 208, 20, 20)
	GUICtrlSetTip($ctrl_AE_Infinity, "Will enable Infinity Arrow for Muse Elf")
	If $AE_DoInfinity == 1 Then
		GUICtrlSetState($ctrl_AE_Infinity, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AE_Infinity, $GUI_UNCHECKED)
		$AE_DoInfinity = 0
	EndIf
	GUICtrlCreateLabel("Skill:", 110, 210)
	$ctrl_AE_InfSkill = GUICtrlCreateInput("", 145, 208, 25, 18)
	GUICtrlSetData($ctrl_AE_InfSkill, $AE_Inf_Skill)
	
	GUICtrlCreateLabel("Use Raven", 5, 235)
	$ctrl_AE_Raven = GUICtrlCreateCheckbox("", 75, 233, 20, 20)
	GUICtrlSetTip($ctrl_AE_Raven, "Enables Raven Random Attack every few min")
	If $AE_Raven == 1 Then
		GUICtrlSetState($ctrl_AE_Raven, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AE_Raven, $GUI_UNCHECKED)
		$AE_Raven = 0
	EndIf
	GUICtrlCreateLabel("Time:", 110, 235)
	$ctrl_AE_RavenTime = GUICtrlCreateInput("", 145, 233, 30, 18)
	GUICtrlSetData($ctrl_AE_RavenTime, $AE_Raven_Time)
	GUICtrlSetTip($ctrl_AE_Raven, "Maximum Time for Raven Attack in min")
	

	
	;################ DW TAB CREATION #######################
	$tabDW = GUICtrlCreateTabItem(" DW") ;Erzeugt DW Tab, beendet AE Tab, alle Befehle wirken auf DW Tab
	GUICtrlCreateLabel("Use 2. Skill", 5, 35)
	$ctrl_DW_Protect = GUICtrlCreateCheckbox("", 75, 33, 20, 20)
	If $DW_Protect == 1 Then
		GUICtrlSetState($ctrl_DW_Protect, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_DW_Protect, $GUI_UNCHECKED)
		$DW_Protect = 0
	EndIf
	GUICtrlCreateLabel("DW Skill:", 5, 65)
	$ctrl_DW_Skill = GUICtrlCreateInput("", 72, 63, 18, 18)
	GUICtrlSetData($ctrl_DW_Skill, $DW_Skill)
	GUICtrlCreateLabel("Delay:", 100, 65)
	$ctrl_DW_Delay = GUICtrlCreateInput("", 145, 63, 36, 18)
	GUICtrlSetData($ctrl_DW_Delay, $DW_Delay)
	GUICtrlCreateLabel("DW Skill2:", 5, 90)
	$ctrl_DW_Skill2 = GUICtrlCreateInput("", 72, 88, 18, 18)
	GUICtrlSetData($ctrl_DW_Skill2, $DW_Skill2)
	GUICtrlCreateLabel("2. Delay:", 100, 90)
	$ctrl_DW_Delay2 = GUICtrlCreateInput("", 145, 88, 25, 18)
	GUICtrlSetData($ctrl_DW_Delay2, $DW_Delay2 / 1000)
	GUICtrlCreateLabel("Power Mode", 5, 115)
	$ctrl_DW_Power = GUICtrlCreateCheckbox("", 75, 113, 20, 20)
	GUICtrlSetTip($ctrl_DW_Power, "Will use Skill permanently" & @CR & "Use <ALT><F7> to toggle")
	If $DW_Power == 1 Then
		GUICtrlSetState($ctrl_DW_Power, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_DW_Power, $GUI_UNCHECKED)
		$DW_Power = 0
	EndIf
	GUICtrlCreateLabel("Party Mode", 5, 140)
	$ctrl_DW_Party = GUICtrlCreateCheckbox("", 75, 138, 20, 20)
	GUICtrlSetTip($ctrl_DW_Party, "Will use EE Def Skill on Party" & @CR & "Useful with Manashield")
	If $DW_Party == 1 Then
		GUICtrlSetState($ctrl_DW_Party, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_DW_Party, $GUI_UNCHECKED)
		$DW_Party = 0
	EndIf
	GUICtrlCreateLabel("Combo:", 5, 165)
	$ctrl_Combo = GUICtrlCreateCheckbox("", 75, 163, 20, 20)
	;	GUICtrlSetTip ($ctrl_Combo, "Will enable Comboattack with SHIFT-LeftClick")
	GUICtrlSetTip($ctrl_Combo, "Disables Primary Skill Intervall" & @CR & "Combo on Mouse Center Button")
	If $DK_Combo == 1 Then
		GUICtrlSetState($ctrl_Combo, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_Combo, $GUI_UNCHECKED)
		$DK_Combo = 0
	EndIf
	$ctrl_Combo1 = GUICtrlCreateInput("", 110, 163, 20, 20)
	GUICtrlSetTip($ctrl_Combo1, "Weapon Skill for Combo")
	GUICtrlSetData($ctrl_Combo1, $DK_Combo_1)
	$ctrl_ComboD1 = GUICtrlCreateInput("", 140, 163, 30, 20)
	GUICtrlSetTip($ctrl_ComboD1, "Delay after Weapon Skill")
	GUICtrlSetData($ctrl_ComboD1, $DK_Combo_D1)
	$ctrl_Combo2 = GUICtrlCreateInput("", 110, 188, 20, 20)
	GUICtrlSetTip($ctrl_Combo2, "First Orb Skill for Combo")
	GUICtrlSetData($ctrl_Combo2, $DK_Combo_2)
	$ctrl_ComboD2 = GUICtrlCreateInput("", 140, 188, 30, 20)
	GUICtrlSetTip($ctrl_ComboD2, "Delay after 1. Orb Skill")
	GUICtrlSetData($ctrl_ComboD2, $DK_Combo_D2)
	$ctrl_Combo3 = GUICtrlCreateInput("", 110, 213, 20, 20)
	GUICtrlSetTip($ctrl_Combo3, "Second Orb Skill for Combo")
	GUICtrlSetData($ctrl_Combo3, $DK_Combo_3)
	$ctrl_ComboD3 = GUICtrlCreateInput("", 140, 213, 30, 20)
	GUICtrlSetTip($ctrl_ComboD3, "Delay after 2. Orb Skill")
	GUICtrlSetData($ctrl_ComboD3, $DK_Combo_D3)
	
	;################ AFK TAB CREATION #######################
	$tabAFK = GUICtrlCreateTabItem("AFK") ;Tab für Sonderfunktionen
	
	GUICtrlCreateLabel("Request Off", 15, 35)
	$ctrl_Req = GUICtrlCreateCheckbox("", 90, 33, 20, 20)
	If $AFK_Request == 1 Then
		GUICtrlSetState($ctrl_Req, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_Req, $GUI_UNCHECKED)
	EndIf
	
	GUICtrlCreateLabel("Autoparty", 15, 60)
	$ctrl_AutoParty = GUICtrlCreateCombo("Off", 90, 58, 60, 20, $CBS_DROPDOWNLIST)
	GUICtrlSetTip($ctrl_AutoParty, "Will invite player at position to join party")
	GUICtrlSetData($ctrl_AutoParty, "Top|Left|Bottom|Right")
	
	GUICtrlCreateLabel("Full AFK Mode", 15, 85)
	$ctrl_AFK = GUICtrlCreateCheckbox("", 90, 83, 20, 20)
	GUICtrlSetTip($ctrl_AFK, "Will actively control Mouse pointer")
	If $Do_AFK == 1 Then
		GUICtrlSetState($ctrl_AFK, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_AFK, $GUI_UNCHECKED)
		$Do_AFK = 0
	EndIf
	
	GUICtrlCreateLabel("Autorepair", 15, 110)
	$ctrl_Repair = GUICtrlCreateCheckbox("", 90, 108, 20, 20)
	If $Do_Repair == 1 Then
		GUICtrlSetState($ctrl_Repair, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_Repair, $GUI_UNCHECKED)
	EndIf
	GUICtrlCreateLabel("Delay(min)", 110, 110)
	$ctrl_RepDelay = GUICtrlCreateInput("", 163, 108, 23, 18)
	GUICtrlSetData($ctrl_RepDelay, $AFK_RepDelay / 60000)
	
	GUICtrlCreateLabel("Use Pots (min)", 15, 135)
	$ctrl_UsePots = GUICtrlCreateCheckbox("", 90, 133, 20, 20)
	GUICtrlSetTip($ctrl_UsePots, "Will use Pots to clear inventory")
	If $Do_UsePots == 1 Then
		GUICtrlSetState($ctrl_UsePots, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_UsePots, $GUI_UNCHECKED)
		$Do_UsePots = 0
	EndIf
	$ctrl_PotsDelay = GUICtrlCreateInput("", 115, 133, 23, 18)
	GUICtrlSetTip($ctrl_PotsDelay, "Delay in minutes for pot usage")
	GUICtrlSetData($ctrl_PotsDelay, $PotsDelay / 60000)
	$ctrl_Pots = GUICtrlCreateInput("", 150, 133, 33, 18)
	GUICtrlSetTip($ctrl_Pots, "Valid keys are Q, W, E or any combination.")
	GUICtrlSetData($ctrl_Pots, $Pots)
	
	GUICtrlCreateLabel("Clear Inventory", 15, 160)
	$ctrl_DropInv = GUICtrlCreateCheckbox("", 90, 157, 20, 20)
	GUICtrlSetTip($ctrl_DropInv, "Drops items from Inventory")
	If $Do_Drop == 1 Then
		GUICtrlSetState($ctrl_DropInv, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_DropInv, $GUI_UNCHECKED)
		$Do_Drop = 0
	EndIf
	$ctrl_DropDelay = GUICtrlCreateInput("", 115, 157, 23, 18)
	GUICtrlSetTip($ctrl_DropDelay, "Delay in minutes for Item Dropping")
	GUICtrlSetData($ctrl_DropDelay, $Drop_Delay / 60000)
	$ctrl_DropPos = GUICtrlCreateInput("", 150, 157, 53, 18)
	GUICtrlSetTip($ctrl_DropPos, "Shows Drop Position")
	If $Drop_Pos_Set = True Then
		GUICtrlSetData($ctrl_DropPos, $Drop_XY[0] & "-" & $Drop_XY[1])
	Else
		GUICtrlSetData($ctrl_DropPos, "not set")
	EndIf
	GUICtrlCreateLabel("First Drop Col/Row.", 15, 185)
	$ctrl_DropX = GUICtrlCreateInput("", 115, 182, 18, 18)
	$ctrl_DropY = GUICtrlCreateInput("", 140, 182, 18, 18)
	GUICtrlSetData($ctrl_DropX, $Drop_Col)
	GUICtrlSetData($ctrl_DropY, $Drop_Row)
	GUICtrlSetTip($ctrl_DropX, "May be 1 - 8, 1 clears all COLUMNS")
	GUICtrlSetTip($ctrl_DropY, "May be 1 - 8, 8 clears only last ROW")
	GUICtrlCreateLabel("Save Screenshots", 15, 210)
	$ctrl_SS_Enable = GUICtrlCreateCheckbox("", 115, 207, 20, 20)
	GUICtrlSetTip($ctrl_SS_Enable, "Saves Screenshots to verify AFK Actions")
	$ctrl_SS_Delay = GUICtrlCreateInput("", 140, 207, 23, 18)
	GUICtrlSetTip($ctrl_SS_Delay, "Delay in minutes")
	If $Do_ScreenShot = 1 Then
		GUICtrlSetState($ctrl_SS_Enable, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_SS_Enable, $GUI_UNCHECKED)
		$Do_ScreenShot = 0
	EndIf
	GUICtrlSetData($ctrl_SS_Delay, $SS_Delay / 60000)
	$ctrl_SS_Delete = GUICtrlCreateButton ("Clear",170,205,35,22)
	GUICtrlCreateLabel("Search Exc", 15, 235)
	GUICtrlSetState(-1,$GUI_HIDE)
	$ctrl_ExcUL = GUICtrlCreateCheckbox("", 90, 232, 20, 20)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlSetTip($ctrl_ExcUL, "Search Upper Left")
	If $Do_ExcUL = 1 Then
		GUICtrlSetState($ctrl_ExcUL, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_ExcUL, $GUI_UNCHECKED)
		$Do_ExcUL = 0
	EndIf
	$ctrl_ExcUR = GUICtrlCreateCheckbox("", 115, 232, 20, 20)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlSetTip($ctrl_ExcUR, "Search Upper Right")
	If $Do_ExcUR = 1 Then
		GUICtrlSetState($ctrl_ExcUR, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_ExcUR, $GUI_UNCHECKED)
		$Do_ExcUR = 0
	EndIf
	$ctrl_ExcLL = GUICtrlCreateCheckbox("", 140, 232, 20, 20)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlSetTip($ctrl_ExcLL, "Search Lower Left")
	If $Do_ExcUL = 1 Then
		GUICtrlSetState($ctrl_ExcLL, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_ExcLL, $GUI_UNCHECKED)
		$Do_ExcLL = 0
	EndIf
	$ctrl_ExcLR = GUICtrlCreateCheckbox("", 165, 232, 20, 20)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlSetTip($ctrl_ExcLR, "Search Lower Right")
	If $Do_ExcLR = 1 Then
		GUICtrlSetState($ctrl_ExcLR, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_ExcLR, $GUI_UNCHECKED)
		$Do_ExcLR = 0
	EndIf
	
	;################ OPT TAB CREATION #######################
	$tabOpt = GUICtrlCreateTabItem("Opt") ;Tab für Sonderfunktionen
	
	GUICtrlCreateLabel("AutoAccept", 15, 35)
	$ctrl_Accept = GUICtrlCreateCheckbox("", 90, 33, 20, 20)
	GUICtrlSetTip($ctrl_Accept, "Click to Accept Trade/Party Requests")
	GUICtrlCreateLabel("Run Macros", 15, 60)
	$ctrl_Macro = GUICtrlCreateCheckbox("", 90, 58, 20, 20)
	GUICtrlSetTip($ctrl_Macro, "Repeats ALT-x Macros")
	If $Do_Macro == 1 Then
		GUICtrlSetState($ctrl_Macro, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_Macro, $GUI_UNCHECKED)
		$Do_Macro = 0
	EndIf
	$ctrl_MLoad = GUICtrlCreateButton("Load", 125, 58, 62, 20)
	GUICtrlSetTip($ctrl_MLoad, "Loads ALT-x Macros")

	GUICtrlCreateLabel("Shutdown", 15, 85)
	$ctrl_Off = GUICtrlCreateCheckbox("", 90, 83, 20, 20)
	GUICtrlCreateLabel("h:mm", 110, 85)
	$ctrl_Off_h = GUICtrlCreateInput("", 138, 83, 23, 18)
	GUICtrlSetTip($ctrl_Off_h, "0..23")
	$ctrl_Off_min = GUICtrlCreateInput("", 163, 83, 23, 18)
	GUICtrlSetData($ctrl_Off_h, $AFK_Off_h)
	GUICtrlSetData($ctrl_Off_min, $AFK_Off_min)
	
	GUICtrlCreateLabel("MU Launcher Settings:", 15, 110)
	GUICtrlCreateLabel("Windowmode", 15, 130)
	$ctrl_WinMode = GUICtrlCreateCheckbox("", 90, 128, 20, 20)
	GUICtrlSetTip($ctrl_WinMode, "Sets Registrysetting for Windowmode" & @CR & "THIS IS NOT A MINIMIZER !")
	If $Mu_WinMode == 1 Then
		GUICtrlSetState($ctrl_WinMode, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_WinMode, $GUI_UNCHECKED)
		$Mu_WinMode = 0
	EndIf
	GUICtrlCreateLabel("Sound:", 125, 130)
	$ctrl_Sound = GUICtrlCreateCheckbox("", 170, 128, 20, 20)
	GUICtrlSetTip($ctrl_Sound, "Sets Registrysetting for Sound")
	If $Mu_Sound == 1 Then
		GUICtrlSetState($ctrl_Sound, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_Sound, $GUI_UNCHECKED)
		$Mu_Sound = 0
	EndIf
	
	GUICtrlCreateLabel("MU Account", 15, 155)
	$ctrl_UserArray = GUICtrlCreateCombo("", 90, 153, 100, 20)
	GUICtrlSetTip($ctrl_UserArray, "Select User from List")
	_GUICtrlComboAddString($ctrl_UserArray, "")
	If IsArray($UserArray) Then
		For $i = 1 To $UserArray[0][0]
			_GUICtrlComboAddString($ctrl_UserArray, $UserArray[$i][0])
		Next
	ElseIf $Mu_User <> "" Then
		_GUICtrlComboAddString($ctrl_UserArray, $Mu_User)
		Dim $UserArray[2][2]
		$UserArray[0][0] = 1
		$UserArray[1][0] = $Mu_User
		$UserArray[1][1] = $Mu_Pass
	EndIf
	$index = _GUICtrlComboSelectString($ctrl_UserArray, -1, $Mu_User)
	_GUICtrlComboSetCurSel($ctrl_UserArray, $index)
		
	GUICtrlCreateLabel("Select mu.exe:", 15, 180)
	$ctrl_MuPath = GUICtrlCreateButton("Browse", 100, 178, 60, 20) ;Browsing for MU Folder
	
	GUICtrlCreateTabItem("") ;Empty Tab closes tab creation
	;################ END OF TAB CREATION #######################

	;Globales Pickflag, shown on all tabs
	$lbl_Pick = GUICtrlCreateLabel("AutoPick", 125, 35)
	$ctrl_Pick = GUICtrlCreateCheckbox("", 173, 33, 20, 20)
	If $Do_Pick == 1 Then
		GUICtrlSetState($ctrl_Pick, $GUI_CHECKED)
	Else
		GUICtrlSetState($ctrl_Pick, $GUI_UNCHECKED)
		$Do_Pick = 0
	EndIf

	$ctrl_Ampel = GUICtrlCreateInput("", 0, 268, 213, 37)
	GUICtrlSetState(-1, $GUI_DISABLE)	;Create disabled input field that can be painted
	$ctrl_MuStart = GUICtrlCreateButton("Run MU (F5)", 10, 275, 85, 25) ;Launch MU Button
	$ctrl_StartStop = GUICtrlCreateButton("START (F9)", 119, 275, 85, 25) ;Start-Stop Knopf

	;GUI anzeigen
	GUISetState(@SW_SHOW) ;Show to measure color of UI elements
	$Ampel_Color = PixelGetColor(3, 30)

	GUICtrlSetBkColor($lbl_Pick, PixelGetColor(10, 50))
	GUICtrlSetBkColor($ctrl_Pick, PixelGetColor(10, 50))
	GUICtrlSetBkColor($ctrl_Ampel, $Ampel_Color)
	GUISetState(@SW_HIDE) ;hide and show to fore repaint
	GUISetState(@SW_SHOW) 

	;Set Startup Tab
	_GUICtrlTabSetCurFocus($tab, $Bot_Mode - 1)

EndFunc   ;==>_CreateBotGUI

;--------------------------------------
; Common Functions
;--------------------------------------
;Read the current GUI controls and set the bot variables accordingly
Func _DoReadGUI()

	;##################### READ EE TAB ########################
	$EE_Buff_Delay = Number(GUICtrlRead($ctrl_Buff_Delay)) * 1000 ;Auslesen des Buff Delays in ms wegen Timerzeit
	If GUICtrlRead($ctrl_Pick) == $GUI_CHECKED Then ;Falls Pick selektiert ist, Pick aktivieren
		$Do_Pick = 1
	Else
		$Do_Pick = 0
	EndIf
	For $cnt = 0 To 4 ;Schleife für alle möglichen Partymember
		If GUICtrlRead($ctrl_PM[$cnt]) == $GUI_CHECKED Then ;Abfrage der Radiobuttons, wenn Button aktiv, setzen der Partygröße
			$Party_Size = $cnt + 1
		EndIf
		If GUICtrlRead($ctrl_PM_Dam[$cnt]) == $GUI_CHECKED Then ;Damage Buff ein- oder ausschalten
			$EE_PM_Dam[$cnt] = 1
		Else
			$EE_PM_Dam[$cnt] = 0
		EndIf
		If GUICtrlRead($ctrl_PM_Def[$cnt]) == $GUI_CHECKED Then ;Defense Buff ein- oder ausschalten
			$EE_PM_Def[$cnt] = 1
		Else
			$EE_PM_Def[$cnt] = 0
		EndIf
	Next
	For $cnt = 0 To 4
		If GUICtrlRead($ctrl_PM_Heal[$cnt]) == $GUI_CHECKED Then ;Falls Heal aktiv ist, den Intervall auslesen
			$EE_PM_Heal_Delay[$cnt] = Number(GUICtrlRead($ctrl_PM_Heal_Delay[$cnt])) * 1000 ;in ms wegen Timerzeiteinheit
		Else
			$EE_PM_Heal_Delay[$cnt] = 0 ;Intervall auf 0 bedeutet, kein Buff
		EndIf
	Next
	$EE_Damage = GUICtrlRead($ctrl_Key_Dam)
	$EE_Defense = GUICtrlRead($ctrl_Key_Def)
	$EE_Heal = GUICtrlRead($ctrl_Key_Heal)

	;##################### READ AE TAB ########################
	If GUICtrlRead($ctrl_AE_EE) == $GUI_CHECKED Then
		$AE_EE_Mode = 1
		GUICtrlSetState($ctrl_AE_Hybrid, $GUI_UNCHECKED)
	Else
		$AE_EE_Mode = 0
	EndIf
	If GUICtrlRead($ctrl_AE_Hybrid) == $GUI_CHECKED Then
		$AE_Hybrid = 1
	Else
		$AE_Hybrid = 0
	EndIf
	If GUICtrlRead($ctrl_AE_NoSkill) == $GUI_CHECKED Then
		$AE_NoSkill = 1
	Else
		$AE_NoSkill = 0
	EndIf
	If GUICtrlRead($ctrl_AE_Power) == $GUI_CHECKED Then
		$AE_Power = 1
	Else
		$AE_Power = 0
	EndIf
	$AE_Skill = GUICtrlRead($ctrl_AE_Skill)
	$AE_Skill_Delay = Number(GUICtrlRead($ctrl_AE_Delay))
	$AE_Winkel_Start = Int(GUICtrlRead($ctrl_AE_WStart))
	$AE_Winkel_Stop = Int(GUICtrlRead($ctrl_AE_WStop))
	$AE_Winkel_Diff = Int(GUICtrlRead($ctrl_AE_WDiff))
	$AE_Dist[0] = Int(GUICtrlRead($ctrl_AE_Dist))
	$AE_Dist[1] = Int(GUICtrlRead($ctrl_AE_Dist1))
	If GUICtrlRead($ctrl_AE_Infinity) == $GUI_CHECKED Then
		$AE_DoInfinity = 1
	Else
		$AE_DoInfinity = 0
	EndIf
	$AE_Inf_Skill = GUICtrlRead($ctrl_AE_InfSkill)
	If GUICtrlRead($ctrl_AE_Raven) == $GUI_CHECKED Then
		$AE_Raven = 1
	Else
		$AE_Raven = 0
	EndIf
	$AE_Raven_Time = Number(GUICtrlRead($ctrl_AE_RavenTime))
	
	;##################### READ DW/DK TAB ########################
	If GUICtrlRead($ctrl_DW_Protect) == $GUI_CHECKED Then
		$DW_Protect = 1
	Else
		$DW_Protect = 0
	EndIf
	If GUICtrlRead($ctrl_DW_Power) == $GUI_CHECKED Then
		$DW_Power = 1
	Else
		$DW_Power = 0
	EndIf
	$DW_Skill = GUICtrlRead($ctrl_DW_Skill)
	$DW_Delay = Number(GUICtrlRead($ctrl_DW_Delay))
	$DW_Skill2 = GUICtrlRead($ctrl_DW_Skill2)
	$DW_Delay2 = Number(GUICtrlRead($ctrl_DW_Delay2)) * 1000
	If GUICtrlRead($ctrl_DW_Party) == $GUI_CHECKED Then
		$DW_Party = 1
	Else
		$DW_Party = 0
	EndIf
	If GUICtrlRead($ctrl_Combo) == $GUI_CHECKED Then
		$DK_Combo = 1
	Else
		$DK_Combo = 0
	EndIf
	$DK_Combo_1 = GUICtrlRead($ctrl_Combo1)
	$DK_Combo_2 = GUICtrlRead($ctrl_Combo2)
	$DK_Combo_3 = GUICtrlRead($ctrl_Combo3)
	$DK_Combo_D1 = Int(GUICtrlRead($ctrl_ComboD1))
	$DK_Combo_D2 = Int(GUICtrlRead($ctrl_ComboD2))
	$DK_Combo_D3 = Int(GUICtrlRead($ctrl_ComboD3))
	
	;##################### READ AFK TAB ########################
	If GUICtrlRead($ctrl_Accept) == $GUI_CHECKED Then ;Auto Accept Mode ein- oder ausschalten
		$AFK_Accept = 1
	Else
		$AFK_Accept = 0
	EndIf
	If GUICtrlRead($ctrl_Req) == $GUI_CHECKED Then ;Request on oder off
		$AFK_Request = 1
	Else
		$AFK_Request = 0
	EndIf
	If GUICtrlRead($ctrl_Off) == $GUI_CHECKED Then
		$Do_Shutdown = 1
	Else
		$Do_Shutdown = 0
	EndIf
	$AFK_Off_h = Number(GUICtrlRead($ctrl_Off_h))
	$AFK_Off_min = Number(GUICtrlRead($ctrl_Off_min))

	If GUICtrlRead($ctrl_Repair) == $GUI_CHECKED Then ;Repair on oder off
		$AFK_RepDelay = Number(GUICtrlRead($ctrl_RepDelay)) * 60000
		$Do_Repair = 1
	Else
		$Do_Repair = 0
	EndIf

	If GUICtrlRead($ctrl_AFK) == $GUI_CHECKED Then ;Full AFK on oder off
		$Do_AFK = 1
	Else
		$Do_AFK = 0
	EndIf
	
	$AutoParty_Pos = GUICtrlRead($ctrl_AutoParty)

	If GUICtrlRead($ctrl_UsePots) == $GUI_CHECKED Then ;Use Pots on oder off
		$PotsDelay = Number(GUICtrlRead($ctrl_PotsDelay)) * 60000
		$Pots = GUICtrlRead($ctrl_Pots)
		$Do_UsePots = 1
	Else
		$Do_UsePots = 0
	EndIf

	If GUICtrlRead($ctrl_DropInv) == $GUI_CHECKED Then ;Empty Inventory on oder off
		$Drop_Delay = Number(GUICtrlRead($ctrl_DropDelay)) * 60000
		$Do_Drop = 1
	Else
		$Do_Drop = 0
	EndIf
	$Drop_Col = Int(GUICtrlRead($ctrl_DropX))
	$Drop_Row = Int(GUICtrlRead($ctrl_DropY))
	
	If GUICtrlRead($ctrl_SS_Enable) == $GUI_CHECKED Then ;Enable Screenshots on oder off
		$SS_Delay = Number(GUICtrlRead($ctrl_SS_Delay)) * 60000
		$Do_ScreenShot = 1
	Else
		$Do_ScreenShot = 0
	EndIf
	
	;##################### READ OPT TAB ########################
	If GUICtrlRead($ctrl_Macro) == $GUI_CHECKED Then ;Macro aufrufen on oder off
		$Do_Macro = 1
	Else
		$Do_Macro = 0
	EndIf

	If GUICtrlRead($ctrl_WinMode) == $GUI_CHECKED Then ;WindowMode on oder off
		$Mu_WinMode = 1
	Else
		$Mu_WinMode = 0
	EndIf
	If GUICtrlRead($ctrl_Sound) == $GUI_CHECKED Then ;MU Sound on oder off
		$Mu_Sound = 1
	Else
		$Mu_Sound = 0
	EndIf
	
	$Bot_Mode = _GUICtrlTabGetCurSel($tab) + 1

EndFunc   ;==>_DoReadGUI

Func _BotHalt()
	HotKeySet("{F9}")
	GUICtrlSetBkColor($ctrl_Ampel, $Ampel_Color)
	GUICtrlSetState($ctrl_MuStart, $GUI_SHOW)
	GUICtrlSetData($ctrl_StartStop, "START (F9)")
	GUICtrlSetState($ctrl_StartStop, $GUI_SHOW)
	WinActivate($WHandle)
	$Do_Run = False
	$Do_Stop = True
	HotKeySet($ModifierKey & "{F5}", "_DropSetup") ; Droppos setzen
	HotKeySet("{F8}", "_ToggleClick")
	HotKeySet("{F9}", "_BotStart") ;Botstart aktivieren
	_LogWrite("_BotHalt wurde ausgeführt")
	;BlockInput(0)
EndFunc   ;==>_BotHalt

Func _BotStart()
	_DoReadGUI()
	ControlFocus($hMain, "", $ctrl_Pick)
	If $WHandle <> "MU" And Not WinActivate($WHandle) Then	;After Bot has been set to handle recognition, and MU quit and restarted, the handle becomes invalid. This fixes this issue
		$WHandle = "MU"
	EndIf
	If Not WinActivate($WHandle) Then
		$Do_Run = False
		MsgBox(0x41010, "Fatal Error", "MU window was not found" & @CR & "Bot Halted", 10)
		_LogWrite("_BotStart wurde mit Fehler beendet: Mu nicht gefunden")
		;_StopLog()
	Else
		_SetHandle()	;Change Windowrecognition to handlebased recognition
		HotKeySet("{F9}")
		GUICtrlSetBkColor($ctrl_Ampel, 0x20C020) ;Grüner Hintergrund - Bot läuft
		GUICtrlSetState($ctrl_MuStart, $GUI_SHOW) ;Versteckte Buttons wieder zeigen
		GUICtrlSetData($ctrl_StartStop, "STOP (F9)")
		GUICtrlSetState($ctrl_StartStop, $GUI_SHOW)
		$WSize = WinGetClientSize($WHandle)
		$WBase = WinGetPos($WHandle)
		$DSize = WinGetClientSize("Program Manager")
		$AE_Winkel = $AE_Winkel_Start
		$AE_Winkel_Stop2 = $AE_Winkel_Stop
		If Int($AE_Winkel_Start) >= Int($AE_Winkel_Stop) Then ;Nötig um einen NULLÜBERGANG zu ermöglichen
			$AE_Winkel_Stop2 = $AE_Winkel_Stop + 360
		EndIf
		;Initialize Timer & Positions
		For $cnt = 0 To 4
			$EE_PM_Last[$cnt] = TimerInit() - $EE_PM_Heal_Delay[$cnt] * 4000000
			$EE_PM_Timer[$cnt] = TimerDiff($EE_PM_Last[$cnt])
			$PM_X[$cnt] = Round($WSize[0] * $PM_XFactor);Unused with Coordmode=2: + $WBase[0]
			$PM_Y[$cnt] = Round($WSize[1] * $PM_Factor * ($cnt + 1)) + $PM_Base;Unused with Coordmode=2: + $WBase[1]
		Next
		;The following structure contains 3 sets of coordinates for use with _manypixelsearch. $aXY_DC[0] is number of sets
		Dim $aXY_DC[13]=[3,Round($WSize[0]*0.35), Round($WSize[1]*0.16), 4+Round($WSize[0]*0.35), 4+Round($WSize[1]*0.16), _	;363,124 0x131313 bei 1024x768
						Round($WSize[0]*0.42), Round($WSize[1]*0.215), 4+Round($WSize[0]*0.42), 4+Round($WSize[1]*0.215), _		;436,167
						Round($WSize[0]*0.6), Round($WSize[1]*0.185), 4+Round($WSize[0]*0.6), 4+Round($WSize[1]*0.185)]		;620,145
		$Buff_Last = TimerInit() - ($EE_Buff_Delay+$DW_Delay2) * 4000000 ;Immediately expire the timer
		$Buff_Timer = TimerDiff($Buff_Last)
		$AFK_RepLast = TimerInit()
		$Macro_Last = TimerInit() - $Macro_Delay * 4000000 ;Immediately expire the timer
		$Pots_Last = TimerInit()
		$Drop_Dura_Last = TimerInit()
		$AP_Last = TimerInit()
		$AE_Raven_Last = TimerInit() - $AE_Raven_Delay * 4000000 ;Damit Raven sofort aktiviert wird
		$AE_Raven_Off_Init = TimerInit()
		$AE_Inf_Last = TimerInit() - $AE_Inf_Delay * 4000000 ;Damit Infinity sofort aktiviert wird
		$SS_Last = TimerInit() ;Screenshot Timer
		If $AFK_Request And Not $AFK_Accept Then
			_SetRequestOff(True)
		EndIf
		If $Do_Pick Then
			_RemoteSend("PICK ON")
		EndIf
		$AE_X = Round(($WSize[0] / 2))
		$AE_Y = Round(($WSize[1] / 2.5))	;Coords for selfbuff
		$AFK_Pos[0] = $AE_X
		$AFK_Pos[1] = Round($AE_Y + $WSize[1] / 20) ;Below your feet, for party, and more
		Switch $AutoParty_Pos ;Init positions for Autoparty
			Case "Off"
				$Do_AutoParty = False
				;Do nothing
			Case "Top"
				Dim $AutoParty_XY[2]
				$AutoParty_XY[0] = $AE_X
				$AutoParty_XY[1] = $AE_Y - Round(($WSize[1] * $AP_Dist))
				$Do_AutoParty = True
			Case "Right"
				Dim $AutoParty_XY[2]
				$AutoParty_XY[0] = $AE_X + Round(($WSize[0] * $AP_Dist))
				$AutoParty_XY[1] = $AE_Y
				$Do_AutoParty = True
			Case "Bottom"
				Dim $AutoParty_XY[2]
				$AutoParty_XY[0] = $AE_X
				$AutoParty_XY[1] = $AE_Y + Round(($WSize[1] * $AP_Dist))
				$Do_AutoParty = True
			Case "Left"
				Dim $AutoParty_XY[2]
				$AutoParty_XY[0] = $AE_X - Round(($WSize[0] * $AP_Dist))
				$AutoParty_XY[1] = $AE_Y
				$Do_AutoParty = True
		EndSwitch
		HotKeySet($ModifierKey & "{F5}") ; Droppos setzen ausschalten
		HotKeySet("{F8}") ;_ToggleClick ausschalten
		$Do_Chat = False
		$Chat_Init = False
		HotKeySet("{ENTER}", "_ToggleChat") ;Hotkey um Chat Funktion einzuschalten
		HotKeySet("{F9}", "_BotHalt")
		$Skill_Last = 99
		$Do_LClick = False ;Leftclicker abschalten
		$Do_Run = True
		_LogWrite("_BotStart wurde ausgeführt")
	EndIf
EndFunc   ;==>_BotStart

Func _PauseIt()
	Local $i
	
	For $i = 0 To $PauseTime * 2
		If $Do_Stop Then ExitLoop
		Sleep(500)
		$msg = GUIGetMsg() ; Make sure that this loop can be exited
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	Next
EndFunc   ;==>_PauseIt

Func _DoSkill($X, $Y, $Key, $Skill_Delay = 350)
	_LogWrite("Aufruf _DoSkill: X # Y # $Key: " & $X & " # " & $Y & " # " & $Key)
	If $X > 0 Then
		MouseMove($X, $Y, $Mouse_Speed)
	EndIf
	If $Skill_Last <> $Key Then
		$Skill_Last = $Key
		_RemoteSend($Key)
		Sleep($Key_Delay)
	EndIf
	_RightClick(100)
	Sleep($Skill_Delay)
EndFunc   ;==>_DoSkill

Func _DoShoot($X, $Y, $Key, $Skill_Delay)
	Local $DetectMob
	_LogWrite("Aufruf _DoShoot: X # Y # $Key # Delay: " & $X & " # " & $Y & " # " & $Key & " # " & $Skill_Delay)
	MouseMove($X, $Y, $Mouse_Speed)
	If $AE_NoSkill Then
		_RemoteSend("{SHIFTDOWN}")
		_LeftClick()
		_RemoteSend("{SHIFTUP}")
	Else
		If $Skill_Last <> $Key Then
			$Skill_Last = $Key
			_RemoteSend($Key)
			Sleep($Key_Delay)
		EndIf
		_RightClick($AE_Skill_Duration)
	EndIf
	Sleep($Skill_Delay)
EndFunc   ;==>_DoShoot

Func _RightClick($RDelay)
	MouseDown("Right")
	If ($DW_Power And $Bot_Mode == 3) Or ($AE_Power And $Bot_Mode == 2) Then
		$RMouse_Down = True
	Else
		Sleep($RDelay)
		MouseUp("Right")
	EndIf
EndFunc   ;==>_RightClick

;Func _LeftClick($i = $Opt_MouseClickDownDelay)
Func _LeftClick($i = 50)
	MouseDown("left")
	Sleep($i)
	MouseUp("left")
EndFunc   ;==>_LeftClick

Func _Raven_Attack($Attack)
	Local $XY[2]
	
	$XY = MouseGetPos()
	If $RMouse_Down == True Then
		MouseUp("Right")
	EndIf
	Sleep(100)
	If $Do_Pick Then _RemoteSend("PICK OFF")
	_RemoteSend("{shiftdown}")
	If $Attack Then
		_RemoteSend("2")
	Else
		_RemoteSend("1")
		GUICtrlSetState($ctrl_AE_Raven, $GUI_UNCHECKED)
	EndIf	
	_RemoteSend("{shiftup}")
	If $Do_Pick Then _RemoteSend("PICK ON")
	MouseMove($AFK_Pos[0], $AFK_Pos[1], $Mouse_Speed)
	_RightClick(100)
	If $Skill_Last < 10 Then _RemoteSend($Skill_Last)
	If $RMouse_Down == True Then
		MouseDown("Right")
	EndIf
	MouseMove($XY[0], $XY[1], $Mouse_Speed)
	
EndFunc   ;==>_Raven_Attack

Func _TogglePick() ;Aufsammeln An/Aus
	If $Do_Pick Then
		$Do_Pick = False
		GUICtrlSetState($ctrl_Pick, $GUI_UNCHECKED) ;GUI aktualisieren
		If $Do_Run Then _RemoteSend("PICK OFF")
	Else
		$Do_Pick = True
		GUICtrlSetState($ctrl_Pick, $GUI_CHECKED) ;GUI aktualisieren
		If $Do_Run Then _RemoteSend("PICK ON")
	EndIf
	_LogWrite("_TogglePick ausgeführt, Status = " & $Do_Pick)
EndFunc   ;==>_TogglePick

Func _ToggleClick() ;_LeftClick ein- und ausschalten
	If $Do_LClick Then
		$Do_LClick = False
	Else
		$Do_LClick = True
	EndIf
EndFunc   ;==>_ToggleClick

Func _ToggleTest() ;Testmodus ein- bzw. ausschalten
	If $Do_Test Then
		$Do_Test = False
	Else
		$Do_Test = True
	EndIf
EndFunc   ;==>_ToggleTest

Func _ToggleChat() ;Chat ein- und ausschalten
	HotKeySet("{ENTER}")
	If $Do_Chat = True Then
		$Do_Chat = False
		If Not $Chat_Init Then
			_RemoteSend("{ENTER}") ;Chat Dialog schließen
			If $Do_Pick Then _RemoteSend("PICK ON")
		Else
			$Chat_Init = False
		EndIf
	Else
		$Do_Chat = True
		$Chat_Init = True
	EndIf
	If $Do_Run Then
		HotKeySet("{ENTER}", "_ToggleChat")
	EndIf
EndFunc   ;==>_ToggleChat


Func _ToggleAFK() ;AFK Mode An/Aus
	If $Do_AFK Then
		$Do_AFK = False
		GUICtrlSetState($ctrl_AFK, $GUI_UNCHECKED) ;GUI aktualisieren
	Else
		$Do_AFK = True
		If $Do_Run == True Then
			$AFK_Pos = MouseGetPos()
		EndIf
		GUICtrlSetState($ctrl_AFK, $GUI_CHECKED) ;GUI aktualisieren
	EndIf
	_LogWrite("Toggle AFK ausgeführt - Status " & $Do_AFK)
EndFunc   ;==>_ToggleAFK

Func _TogglePower() ;Power Mode An/Aus
	Switch $Bot_Mode
		Case 2
			If $AE_Power Then
				$AE_Power = False
				GUICtrlSetState($ctrl_AE_Power, $GUI_UNCHECKED) ;GUI aktualisieren
			Else
				$AE_Power = True
				GUICtrlSetState($ctrl_AE_Power, $GUI_CHECKED) ;GUI aktualisieren
			EndIf
			_LogWrite("Toggle Power für AE ausgeführt - Status " & $AE_Power)
		Case 3
			If $DW_Power Then
				$DW_Power = False
				GUICtrlSetState($ctrl_DW_Power, $GUI_UNCHECKED) ;GUI aktualisieren
			Else
				$DW_Power = True
				GUICtrlSetState($ctrl_DW_Power, $GUI_CHECKED) ;GUI aktualisieren
			EndIf
			_LogWrite("Toggle Power für DW ausgeführt - Status " & $DW_Power)
	EndSwitch
EndFunc   ;==>_TogglePower

Func _ToggleHybrid() ;AE Hybrid Mode An/Aus
	If $AE_Hybrid == True Then
		$AE_Hybrid = False
		GUICtrlSetState($ctrl_AE_Hybrid, $GUI_UNCHECKED) ;GUI aktualisieren
	Else
		$AE_Hybrid = True
		$AE_EE_Mode = False
		GUICtrlSetState($ctrl_AE_Hybrid, $GUI_CHECKED) ;GUI aktualisieren
		GUICtrlSetState($ctrl_AE_EE, $GUI_UNCHECKED) ;EE Mode geht NICHT mit Hybrid
	EndIf
	_LogWrite("Toggle AE_Hybrid ausgeführt - Status " & $AE_Hybrid)
EndFunc   ;==>_ToggleHybrid

Func _ToggleEE() ;AE Party Mode An/Aus
	If $AE_EE_Mode == True Then
		$AE_EE_Mode = False
		GUICtrlSetState($ctrl_AE_EE, $GUI_UNCHECKED) ;GUI aktualisieren
	Else
		$AE_EE_Mode = True
		$AE_Hybrid = False
		GUICtrlSetState($ctrl_AE_EE, $GUI_CHECKED) ;GUI aktualisieren
		GUICtrlSetState($ctrl_AE_Hybrid, $GUI_UNCHECKED) ;Hybrid geht NICHT mit EE
	EndIf
	_LogWrite("Toggle AE_Hybrid ausgeführt - Status " & $AE_Hybrid)
EndFunc   ;==>_ToggleEE

Func _SetRequestOff($State)
	Local $SendDelay1, $SendDelay2
	
	If $Bot_Mode < 5 Then
		HotKeySet("{ENTER}")
		If $Do_Chat Then
			_RemoteSend("{ENTER}")
;~ 			Sleep($Key_Delay)
			$Do_Chat = False
		EndIf
		If $State == True Then
			If WinActivate($WHandle) == 1 Then
				If $Do_Pick Then _RemoteSend("PICK OFF")
				ClipPut("/request off")
				_RemoteSend("{ENTER}")
				_RemoteSend("^V")
				_RemoteSend("{ENTER}")
				If $Do_Pick And $Do_Run Then _RemoteSend("PICK ON")	;$Do_Run added to avoid ALWAYS ON
			EndIf
		Else
			If WinActivate($WHandle) == 1 Then
				If $Do_Pick Then _RemoteSend("PICK OFF")
				_RemoteSend("{ENTER}")
				If WinActivate($WHandle) == 1 Then ;When Disconnected, MU will be closed by pressing enter
					ClipPut("/request on")
					_RemoteSend("^V")
					_RemoteSend("{ENTER}")
					If $Do_Pick And $Do_Run Then _RemoteSend("PICK ON") ;$Do_Run added to avoid ALWAYS ON
				EndIf
			EndIf
		EndIf
		If $Do_Run Then	HotKeySet("{ENTER}", "_ToggleChat")
	EndIf

EndFunc   ;==>_SetRequestOff

Func _LogStart()
	Local $sFile
	
	ConsoleWrite ("STarting Log:  ")
	$sFile = "\" & StringStripWS($Bot_Name, 3) & ".log"
	If FileGetSize(@ScriptDir & $sFile) > (256 * 1024) Then
		FileDelete(@ScriptDir & $sFile)
	EndIf
	$Log_File = FileOpen(@ScriptDir & $sFile, 1)
	If $Log_File = -1 Then MsgBox (16, "File Open Error","Logfile failed to open")
	ConsoleWrite ("Opened File " & @ScriptDir & $sFile & @CRLF)
	_LogWrite(StringStripWS($Bot_Name, 3) & " Debug Log " & $MajorVer & $MinorVer, False)
	_LogWrite("###   Start of Log Session   ###", False)
	If $Do_Log = False Then
		_RemoteSend("DEBUG ON")
		$Do_Log = True
	EndIf
	
EndFunc   ;==>_LogStart

Func _StopLog()
	_LogWrite("###   End of Log Session   ###", False)
	$Do_Log = False
	FileClose($Log_File)
	_RemoteSend("DEBUG OFF")
EndFunc   ;==>_StopLog

Func _LogWrite($LogMsg, $Time = True, $NoCR = False)
	Dim $CRLF ;local variable für Zeilenende
	Dim $TimeStr ; local variable für Zeitstempel
	If $Do_Log Then
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

Func _OptionInc()
	Switch $Bot_Mode
		Case 1 ;EE Definition
		Case 2 ;AE Definition - Change Angles
			$AE_Winkel_Start += 5
			$AE_Winkel_Stop += 5
			$AE_Winkel_Stop2 += 5
			If $AE_Winkel_Start >= 360 Then
				$AE_Winkel_Start -= 360
				$AE_Winkel_Stop2 -= 360
			EndIf
			If $AE_Winkel_Stop >= 360 Then
				$AE_Winkel_Stop -= 360
			EndIf
			GUICtrlSetData($ctrl_AE_WStart, $AE_Winkel_Start)
			GUICtrlSetData($ctrl_AE_WStop, $AE_Winkel_Stop)
			If $AE_Winkel < $AE_Winkel_Start Or $AE_Winkel > $AE_Winkel_Stop2 Then
				$AE_Winkel = $AE_Winkel_Start
			EndIf
		Case 3 ;DW/DK Definition - Change 2. Skill Delay
			$DW_Delay2 += 1000
			GUICtrlSetData($ctrl_DW_Delay2, $DW_Delay2 / 1000)
		Case 4 ;AFK Definition
	EndSwitch
EndFunc   ;==>_OptionInc

Func _OptionDec()
	Switch $Bot_Mode
		Case 1 ;EE Definition
		Case 2 ;AE Definition - Change Angles
			$AE_Winkel_Start -= 5
			$AE_Winkel_Stop -= 5
			$AE_Winkel_Stop2 -= 5
			If $AE_Winkel_Start < 0 Then
				$AE_Winkel_Start += 360
				$AE_Winkel_Stop2 += 360
			EndIf
			If $AE_Winkel_Stop < 0 Then
				$AE_Winkel_Stop += 360
			EndIf
			GUICtrlSetData($ctrl_AE_WStart, $AE_Winkel_Start)
			GUICtrlSetData($ctrl_AE_WStop, $AE_Winkel_Stop)
			;Make sure that Change is applied immediately
			If $AE_Winkel < $AE_Winkel_Start Or $AE_Winkel > $AE_Winkel_Stop Then
				$AE_Winkel = $AE_Winkel_Start
			EndIf
		Case 3 ;DW/DK Definition - Change 2. Skill Delay
			If $DW_Delay2 >= 2000 Then
				$DW_Delay2 -= 1000
				GUICtrlSetData($ctrl_DW_Delay2, $DW_Delay2 / 1000)
			EndIf
		Case 4 ;AFK Definition
	EndSwitch
EndFunc   ;==>_OptionDec

Func _Option2Inc()
	Local $i
	Switch $Bot_Mode
		Case 1 ;EE Definition - Change all Heals
			For $i = 0 To 4
				$EE_PM_Heal_Delay[$i] += 1000
				GUICtrlSetData($ctrl_PM_Heal_Delay[$i], $EE_PM_Heal_Delay[$i] / 1000)
			Next
		Case 2 ;AE Definition - Change Distance
			$AE_Dist[0] += 10
			$AE_Dist[1] += 10
			GUICtrlSetData($ctrl_AE_Dist, $AE_Dist[0])
			GUICtrlSetData($ctrl_AE_Dist1, $AE_Dist[1])
	EndSwitch
EndFunc   ;==>_Option2Inc

Func _Option2Dec()
	Local $i
	Switch $Bot_Mode
		Case 1 ;EE Definition - Change all Heals
			For $i = 0 To 4
				If $EE_PM_Heal_Delay[$i] > 2000 Then
					$EE_PM_Heal_Delay[$i] -= 1000
					GUICtrlSetData($ctrl_PM_Heal_Delay[$i], $EE_PM_Heal_Delay[$i] / 1000)
				EndIf
			Next
		Case 2 ;AE Definition - Change Distance
			If $AE_Dist[0] > 30 And $AE_Dist[1] > 30 Then
				$AE_Dist[0] -= 10
				GUICtrlSetData($ctrl_AE_Dist, $AE_Dist[0])
				$AE_Dist[1] -= 10
				GUICtrlSetData($ctrl_AE_Dist1, $AE_Dist[1])
			EndIf
	EndSwitch
EndFunc   ;==>_Option2Dec

Func _IncreaseDelay()
	Switch $Bot_Mode
		Case 1 ;EE Definition
			If $EE_Buff_Delay < 600000 Then
				$EE_Buff_Delay += 1000 ;1s
				GUICtrlSetData($ctrl_Buff_Delay, $EE_Buff_Delay / 1000)
			EndIf
		Case 2 ;AE Definition - Increase Mouse Down Time
			$AE_Skill_Delay += 100 ;100ms Verlängerung
			GUICtrlSetData($ctrl_AE_Delay, $AE_Skill_Delay)
		Case 3 ;DW/DK Definition - Change 2. Skill Delay
			$DW_Delay += 100 ;100ms
			GUICtrlSetData($ctrl_DW_Delay, $DW_Delay)
		Case 4 ;AFK Definition
	EndSwitch
EndFunc   ;==>_IncreaseDelay

Func _DecreaseDelay()
	Switch $Bot_Mode
		Case 1 ;EE Definition
			If $EE_Buff_Delay >= 2000 Then
				$EE_Buff_Delay -= 1000 ;1s
				GUICtrlSetData($ctrl_Buff_Delay, $EE_Buff_Delay / 1000)
			EndIf
		Case 2 ;AE Definition - Change Skill Mouse Down Time
			If $AE_Skill_Delay >= 100 Then
				$AE_Skill_Delay -= 100 ;100ms Verlängerung
				GUICtrlSetData($ctrl_AE_Delay, $AE_Skill_Delay)
			EndIf
		Case 3 ;DW/DK Definition - Change Main Skill Delay
			If $DW_Delay >= 200 Then
				$DW_Delay -= 100 ;100ms
				GUICtrlSetData($ctrl_DW_Delay, $DW_Delay)
			EndIf
		Case 4 ;AFK Definition
	EndSwitch
EndFunc   ;==>_DecreaseDelay

Func _PlusParty()
	Switch $Bot_Mode
		Case 1 To 3 ;EE/AE/DW Definition
			If $Party_Size < 5 Then
				GUICtrlSetState($ctrl_PM[$Party_Size], $GUI_CHECKED)
				GUICtrlSetState($ctrl_PM[$Party_Size - 1], $GUI_SHOW)
				$Party_Size += 1
			EndIf
	EndSwitch
EndFunc   ;==>_PlusParty

Func _MinusParty()
	Switch $Bot_Mode
		Case 1 To 3 ;EE/AE/DW Definition
			If $Party_Size > 1 Then
				GUICtrlSetState($ctrl_PM[$Party_Size - 2], $GUI_CHECKED)
				GUICtrlSetState($ctrl_PM[$Party_Size - 1], $GUI_SHOW)
				$Party_Size -= 1
			EndIf
	EndSwitch
EndFunc   ;==>_MinusParty

Func _LoadMacro(ByRef $Macro_Cnt, ByRef $Macro_Current)

	If FileExists("messages.txt") == 1 Then
		If WinActivate($WHandle) Then
			WinActivate($WHandle)
			$MacroFile = FileOpen("messages.txt", 0)
			For $Macro_Cnt = 0 To 9
				$MacroList[$Macro_Cnt] = FileReadLine($MacroFile)
				If @error == -1 Then ExitLoop
				ClipPut("/" & Mod($Macro_Cnt + 1, 10) & " " & $MacroList[$Macro_Cnt])
				;_RemoteSend(@CR & "/" & Mod($Macro_Cnt+1, 10) & " " & $MacroList[$Macro_Cnt] & @CR)
				_RemoteSend("{ENTER}")
				_RemoteSend("^V")	;Using the Clipboard is so much faster for longer texts !! Idea seen used by PJ Autoplay
				_RemoteSend("{ENTER}")
			Next
			FileClose($MacroFile)
			$Macro_Current = 1
		Else
			MsgBox(0x41010, "Window Not Found", "MU Window could not be found", 5)
		EndIf
	Else
		MsgBox(0x41010, "Load Error", "File messages.txt was not found in current directory", 5)
	EndIf
	If $Mu_Pass <> "" Then
		ClipPut($Mu_Pass)
	EndIf
EndFunc   ;==>_LoadMacro


Func _SaveConfig()
	_DoReadGUI()
	$Bot_Pos = WinGetPos($Bot_Name & "  " & $MajorVer & $MinorVer)
	IniWrite($Config_File, "GLOBAL", "OptKeyDelay", $Opt_KeyDelay)
	IniWrite($Config_File, "GLOBAL", "OptKeyDownDelay", $Opt_KeyDownDelay)
	If $netAppName = @ScriptName Then
		IniWrite($Config_File, "GLOBAL", "ServerName", "")
	Else
		IniWrite($Config_File, "GLOBAL", "ServerName", $netAppName)
	EndIf
	If $MuExe = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Webzen\Mu", "Exe") Then
		IniWrite($Config_File, "GLOBAL", "MU_Path", "")
	Else
		IniWrite($Config_File, "GLOBAL", "MU_Path", $MuExe)
	EndIf
	IniWrite($Config_File, "GLOBAL", "ServerDelay", $ServerDelay)
	IniWrite($Config_File, "GLOBAL", "KeyDelay", $Key_Delay)
	IniWrite($Config_File, "GLOBAL", "ClickDelay", $Opt_MouseClickDelay)
	IniWrite($Config_File, "GLOBAL", "ClickDownDelay", $Opt_MouseClickDownDelay)
	IniWrite($Config_File, "GLOBAL", "DebugFlag", False)
	IniWrite($Config_File, "GLOBAL", "PYFactor", $PM_Factor)
	IniWrite($Config_File, "GLOBAL", "PYBase", $PM_Base)
	IniWrite($Config_File, "GLOBAL", "PXFactor", $PM_XFactor)
	IniWrite($Config_File, "GLOBAL", "PauseLength", $PauseTime)
	IniWrite($Config_File, "GLOBAL", "MouseSpeed", $Mouse_Speed)
	IniWrite($Config_File, "GLOBAL", "ModifierKey", $ModifierKey)
	IniWrite($Config_File, "GLOBAL", "Use ColorDetect", $Do_Color)
	IniWrite($Config_File, "GLOBAL", "Detect DC", $Do_Disco)
	If $Bot_Pos[0] >= -10 Then
		RegWrite($RegRoot,"XPos","REG_DWORD", $Bot_Pos[0])
	EndIf
	If $Bot_Pos[1] >= -10 Then
		RegWrite($RegRoot,"YPos","REG_DWORD",$Bot_Pos[1])
	EndIf
	RegWrite($RegRoot,"StartMode","REG_DWORD",$Bot_Mode)

	RegWrite($RegRoot&"\EE", "Delay","REG_DWORD",$EE_Buff_Delay)
	RegWrite($RegRoot&"\EE", "Defense Key","REG_SZ", $EE_Defense)
	RegWrite($RegRoot&"\EE", "Damage Key","REG_SZ", $EE_Damage)
	RegWrite($RegRoot&"\EE", "Heal Key","REG_SZ", $EE_Heal)
	RegWrite($RegRoot&"\EE", "Party Size","REG_DWORD", $Party_Size)
	For $cnt = 0 To 4
		RegWrite($RegRoot&"\EE", "PM_Dam" & $cnt,"REG_DWORD", $EE_PM_Dam[$cnt])
		RegWrite($RegRoot&"\EE", "PM_Def" & $cnt,"REG_DWORD", $EE_PM_Def[$cnt])
		RegWrite($RegRoot&"\EE", "PM_Heal" & $cnt,"REG_DWORD", $EE_PM_Heal_Delay[$cnt])
	Next

	RegWrite($RegRoot&"\AE", "Skill Key", "REG_SZ", $AE_Skill)
	RegWrite($RegRoot&"\AE", "Skill Delay","REG_DWORD", $AE_Skill_Delay)
	RegWrite($RegRoot&"\AE", "AEPower","REG_DWORD", $AE_Power)
	RegWrite($RegRoot&"\AE", "AEnoSkill","REG_DWORD", $AE_NoSkill)
	RegWrite($RegRoot&"\AE", "Start Angle","REG_DWORD", $AE_Winkel_Start)
	RegWrite($RegRoot&"\AE", "Stop Angle", "REG_DWORD", $AE_Winkel_Stop)
	RegWrite($RegRoot&"\AE", "Intervall", "REG_DWORD", $AE_Winkel_Diff)
	RegWrite($RegRoot&"\AE", "Distance", "REG_DWORD", $AE_Dist[0])
	RegWrite($RegRoot&"\AE", "Dist2", "REG_DWORD", $AE_Dist[1])
	RegWrite($RegRoot&"\AE", "Selfbuff", "REG_DWORD", $AE_Hybrid)
	RegWrite($RegRoot&"\AE", "Partybuff", "REG_DWORD", $AE_EE_Mode)
	RegWrite($RegRoot&"\AE", "Infinity", "REG_DWORD", $AE_DoInfinity)
	RegWrite($RegRoot&"\AE", "Infinity Skill","REG_SZ", $AE_Inf_Skill)
	RegWrite($RegRoot&"\AE", "Use Raven", "REG_DWORD", $AE_Raven)
	RegWrite($RegRoot&"\AE", "Raven TimeOut", "REG_DWORD", $AE_Raven_Time)
	IniWrite($Config_File, "AGILTY", "Skill Time", $AE_Skill_Duration)
	IniWrite($Config_File, "AGILTY", "Infinity Delay", $AE_Inf_Delay)
	IniWrite($Config_File, "AGILTY", "Raven Delay", $AE_Raven_Delay)
	
	RegWrite($RegRoot&"\DW", "Main Skill", "REG_SZ", $DW_Skill)
	RegWrite($RegRoot&"\DW", "Supp. Skill", "REG_SZ", $DW_Skill2)
	RegWrite($RegRoot&"\DW", "Skill Delay", "REG_DWORD", $DW_Delay)
	RegWrite($RegRoot&"\DW", "Supp. Skill Delay", "REG_DWORD", $DW_Delay2)
	RegWrite($RegRoot&"\DW", "Use Supp. Skill", "REG_DWORD", $DW_Protect)
	RegWrite($RegRoot&"\DW", "PowerSkilling", "REG_DWORD", $DW_Power)
	RegWrite($RegRoot&"\DW", "Party Mode", "REG_DWORD", $DW_Party)
	RegWrite($RegRoot&"\DW", "Combo Mode", "REG_DWORD", $DK_Combo)
	RegWrite($RegRoot&"\DW", "Combo Skill1", "REG_SZ", $DK_Combo_1)
	RegWrite($RegRoot&"\DW", "Skill1 Delay", "REG_DWORD", $DK_Combo_D1)
	RegWrite($RegRoot&"\DW", "Combo Skill2", "REG_SZ", $DK_Combo_2)
	RegWrite($RegRoot&"\DW", "Skill2 Delay", "REG_DWORD", $DK_Combo_D2)
	RegWrite($RegRoot&"\DW", "Combo Skill3", "REG_SZ", $DK_Combo_3)
	RegWrite($RegRoot&"\DW", "Skill3 Delay", "REG_DWORD", $DK_Combo_D3)
	IniWrite($Config_File, "DW-DK", "Combo Hotkey", $DK_Combo_Hotkey)
	
	RegWrite($RegRoot&"\AFK", "Auto Pick", "REG_DWORD", $Do_Pick)
	RegWrite($RegRoot&"\AFK", "Auto Repair", "REG_DWORD", $Do_Repair)
	RegWrite($RegRoot&"\AFK", "Repair Timer", "REG_DWORD", $AFK_RepDelay)
	RegWrite($RegRoot&"\AFK", "Request Mode", "REG_DWORD", $AFK_Request)
	RegWrite($RegRoot&"\AFK", "AFK Mode", "REG_DWORD", $Do_AFK)
	RegWrite($RegRoot&"\AFK", "Pots Usage", "REG_DWORD", $Do_UsePots)
	RegWrite($RegRoot&"\AFK", "Pots Keys", "REG_SZ", $Pots)
	RegWrite($RegRoot&"\AFK", "Pots Delay", "REG_DWORD", $PotsDelay)
	RegWrite($RegRoot&"\AFK", "Drop Items",  "REG_DWORD", $Do_Drop)
	RegWrite($RegRoot&"\AFK", "Drop StartRow", "REG_DWORD", $Drop_Row)
	RegWrite($RegRoot&"\AFK", "Drop StartCol", "REG_DWORD", $Drop_Col)
	RegWrite($RegRoot&"\AFK", "Drop Delay", "REG_DWORD", $Drop_Delay)
	RegWrite($RegRoot&"\AFK", "Do Screenshots", "REG_DWORD", $Do_ScreenShot)
	RegWrite($RegRoot&"\AFK", "Screenshot Delay", "REG_DWORD", $SS_Delay)
	RegWrite($RegRoot&"\AFK", "Exc Upper Left", "REG_DWORD", $Do_ExcUL)
	RegWrite($RegRoot&"\AFK", "Exc Upper Right", "REG_DWORD", $Do_ExcUR)
	RegWrite($RegRoot&"\AFK", "Exc Lower Left", "REG_DWORD", $Do_ExcLL)
	RegWrite($RegRoot&"\AFK", "Exc Lower Right", "REG_DWORD", $Do_ExcLR)
	IniWrite($Config_File, "AFK", "Drop X", $Drop_XY[0])
	IniWrite($Config_File, "AFK", "Drop Y", $Drop_XY[1])
	IniWrite($Config_File, "AFK", "Party Intervall", $AP_Delay)
	IniWrite($Config_File, "AFK", "Party Delay", $AP_Sleep)
	IniWrite($Config_File, "AFK", "Party Distance", $AP_Dist)
	IniWrite($Config_File, "AFK", "MU Screenshot", $SS_MU_Type)
	
	IniWrite($Config_File, "OPT", "Macro Delay", $Macro_Delay)
	IniWrite($Config_File, "OPT", "ShutdownMode", $Shutdown_Mode)
	IniWrite($Config_File, "OPT", "LoginID", $Mu_User)
	IniWrite($Config_File, "OPT", "LoginPass", $Mu_Pass)
	RegWrite($RegRoot&"\OPT", "Shutdown", "REG_DWORD", $Do_Shutdown)
	RegWrite($RegRoot&"\OPT", "SH Hour", "REG_DWORD", $AFK_Off_h)
	RegWrite($RegRoot&"\OPT", "SH Min", "REG_DWORD", $AFK_Off_min)
	RegWrite($RegRoot&"\OPT", "WindowMode", "REG_DWORD", $Mu_WinMode)
	RegWrite($RegRoot&"\OPT", "SoundMode", "REG_DWORD", $Mu_Sound)

EndFunc   ;==>_SaveConfig


Func _ReadConfig()
Local $tmp

	$Opt_KeyDelay = IniRead($Config_File, "GLOBAL", "OptKeyDelay", 150)
	$Opt_KeyDownDelay = IniRead($Config_File, "GLOBAL", "OptKeyDownDelay", 150)
	$tmp = IniRead($Config_File, "GLOBAL", "ServerName", "")
	If $tmp <> "" Then
		$netAppName = $tmp
	EndIf
	$ServerDelay = IniRead($Config_File, "GLOBAL", "ServerDelay", 100)
	$Key_Delay = IniRead($Config_File, "GLOBAL", "KeyDelay", 100)
	$Opt_MouseClickDelay = IniRead($Config_File, "GLOBAL", "ClickDelay", 120)
	$Opt_MouseClickDownDelay = IniRead($Config_File, "GLOBAL", "ClickDownDelay", 120)
	$Do_Log = IniRead($Config_File, "GLOBAL", "DebugFlag", False)
	$Bot_Mode = RegRead($RegRoot, "StartMode")
	$MuExe = IniRead($Config_File, "GLOBAL", "MU_Path", RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Webzen\Mu", "Exe"))
	If $MuExe = "" Then
		$MuExe = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Webzen\Mu", "Exe")
	EndIf
	$PM_Factor = IniRead($Config_File, "GLOBAL", "PYFactor", 0.040) ; 0.039 - 0.042
	$PM_Base = IniRead($Config_File, "GLOBAL", "PYBase", -11) ; Default Offset for Life Bar, ~ -10 for center
	$PM_XFactor = IniRead($Config_File, "GLOBAL", "PXFactor", 0.933); For beginning of Life Bar 0.923
	$PauseTime = IniRead($Config_File, "GLOBAL", "PauseLength", 10)
	$Mouse_Speed = IniRead($Config_File, "GLOBAL", "MouseSpeed", 2)
	$ModifierKey = IniRead($Config_File, "GLOBAL", "ModifierKey", "!")	; AutoIt Keydefinitions, ! = ALT, + = SHIFT
	$Do_Color = IniRead($Config_File, "GLOBAL", "Use ColorDetect", True)
	$Do_Disco = IniRead($Config_File, "GLOBAL", "Detect DC", False)
	$Bot_Pos[0] = RegRead($RegRoot, "XPos")
	$Bot_Pos[1] = RegRead($RegRoot, "YPos")
	
	$EE_Buff_Delay = RegRead($RegRoot&"\EE", "Delay")
	$EE_Defense = RegRead($RegRoot&"\EE", "Defense Key")
	$EE_Damage = RegRead($RegRoot&"\EE", "Damage Key")
	$EE_Heal = RegRead($RegRoot&"\EE", "Heal Key")
	$Party_Size = RegRead($RegRoot&"\EE", "Party Size")
	For $cnt = 0 To 4
		$EE_PM_Dam[$cnt] = RegRead($RegRoot&"\EE", "PM_Dam" & $cnt)
		$EE_PM_Def[$cnt] = RegRead($RegRoot&"\EE", "PM_Def" & $cnt)
		$EE_PM_Heal_Delay[$cnt] = RegRead($RegRoot&"\EE", "PM_Heal" & $cnt)
	Next
	
	$AE_Skill = RegRead($RegRoot&"\AE", "Skill Key")
	$AE_Skill_Delay = RegRead($RegRoot&"\AE", "Skill Delay")
	$AE_Skill_Duration = IniRead($Config_File, "AGILTY", "Skill Time", 500)
	$AE_Power = RegRead($RegRoot&"\AE", "AEPower")
	$AE_NoSkill = RegRead($RegRoot&"\AE", "AEnoSkill")
	$AE_Winkel_Start = RegRead($RegRoot&"\AE", "Start Angle")
	$AE_Winkel_Stop = RegRead($RegRoot&"\AE", "Stop Angle")
	$AE_Winkel_Diff = RegRead($RegRoot&"\AE", "Intervall")
	$AE_Dist[0] = RegRead($RegRoot&"\AE", "Distance")
	$AE_Dist[1] = RegRead($RegRoot&"\AE", "Dist2")
	$AE_Hybrid = RegRead($RegRoot&"\AE", "Selfbuff")
	$AE_EE_Mode = RegRead($RegRoot&"\AE", "Partybuff")
	$AE_DoInfinity = RegRead($RegRoot&"\AE", "Infinity")
	$AE_Inf_Skill = RegRead($RegRoot&"\AE", "Infinity Skill")
	$AE_Inf_Delay = IniRead($Config_File, "AGILTY", "Infinity Delay", 120000) ;Entspricht 2min
	$AE_Raven = RegRead($RegRoot&"\AE", "Use Raven")
	$AE_Raven_Delay = IniRead($Config_File, "AGILTY", "Raven Delay", 300000) ;Entspricht 5min
	$AE_Raven_Time = RegRead($RegRoot&"\AE", "Raven TimeOut")
	
	$DW_Skill = RegRead($RegRoot&"\DW", "Main Skill")
	$DW_Skill2 = RegRead($RegRoot&"\DW", "Supp. Skill")
	$DW_Delay = RegRead($RegRoot&"\DW", "Skill Delay")
	$DW_Delay2 = RegRead($RegRoot&"\DW", "Supp. Skill Delay")
	$DW_Protect = RegRead($RegRoot&"\DW", "Use Supp. Skill")
	$DW_Power = RegRead($RegRoot&"\DW", "PowerSkilling")
	$DW_Party = RegRead($RegRoot&"\DW", "Party Mode")
	$DK_Combo = RegRead($RegRoot&"\DW", "Combo Mode")
	$DK_Combo_1 = RegRead($RegRoot&"\DW", "Combo Skill1")
	$DK_Combo_D1 = RegRead($RegRoot&"\DW", "Skill1 Delay")
	$DK_Combo_2 = RegRead($RegRoot&"\DW", "Combo Skill2")
	$DK_Combo_D2 = RegRead($RegRoot&"\DW", "Skill2 Delay")
	$DK_Combo_3 = RegRead($RegRoot&"\DW", "Combo Skill3")
	$DK_Combo_D3 = RegRead($RegRoot&"\DW", "Skill3 Delay")
	$DK_Combo_Hotkey = IniRead($Config_File, "DW-DK", "Combo Hotkey", 04) ; See User Guide or AutoIt Help for Details

	$Do_Pick = RegRead($RegRoot&"\AFK", "Auto Pick")
	$Do_Repair = RegRead($RegRoot&"\AFK", "Auto Repair")
	$AFK_RepDelay = RegRead($RegRoot&"\AFK", "Repair Timer")
	$AFK_Request = RegRead($RegRoot&"\AFK", "Request Mode")
	$Do_AFK = RegRead($RegRoot&"\AFK", "AFK Mode")
	$Do_UsePots = RegRead($RegRoot&"\AFK", "Pots Usage")
	$Pots = RegRead($RegRoot&"\AFK", "Pots Keys")
	$PotsDelay = RegRead($RegRoot&"\AFK", "Pots Delay")
	$Do_Drop = RegRead($RegRoot&"\AFK", "Drop Items")
	$Drop_Row = RegRead($RegRoot&"\AFK", "Drop StartRow")
	$Drop_Col = RegRead($RegRoot&"\AFK", "Drop StartCol")
	$Drop_Delay = RegRead($RegRoot&"\AFK", "Drop Delay")
	$Drop_XY[0] = IniRead($Config_File, "AFK", "Drop X", 0)
	$Drop_XY[1] = IniRead($Config_File, "AFK", "Drop Y", 0)
	If $Drop_XY[0] <> 0 And $Drop_XY[1] <> 0 Then
		$Drop_Pos_Set = True
	EndIf
	$AP_Delay = IniRead($Config_File, "AFK", "Party Intervall", 15000)
	$AP_Sleep = IniRead($Config_File, "AFK", "Party Delay", 1000)
	$AP_Dist = IniRead($Config_File, "AFK", "Party Distance", 0.1)
	$Do_ScreenShot = RegRead($RegRoot&"\AFK", "Do Screenshots")
	$SS_Delay = RegRead($RegRoot&"\AFK", "Screenshot Delay")
	$SS_MU_Type = IniRead($Config_File, "AFK", "MU Screenshot", False)
	$SS_Path = IniRead($Config_File, "AFK", "Screenshot Path", @ScriptDir & "\Screenshots")
	$SS_Hours = IniRead($Config_File, "AFK", "Hours2Keep", 24)
	$Do_ExcLL = RegRead($RegRoot&"\AFK", "Exc Lower Left")
	$Do_ExcLR = RegRead($RegRoot&"\AFK", "Exc Lower Right")
	$Do_ExcUL = RegRead($RegRoot&"\AFK", "Exc Upper Left")
	$Do_ExcUR = RegRead($RegRoot&"\AFK", "Exc Upper Right")

	$Do_Shutdown = RegRead($RegRoot&"\OPT", "Shutdown")
	$Shutdown_Mode = IniRead($Config_File, "OPT", "ShutdownMode", 13)
	$AFK_Off_h = RegRead($RegRoot&"\OPT", "SH Hour")
	$AFK_Off_min = RegRead($RegRoot&"\OPT", "SH Min")
	$Macro_Delay = IniRead($Config_File, "OPT", "Macro Delay", 11000)
	$Mu_WinMode = RegRead($RegRoot&"\OPT", "WindowMode")
	$Mu_Sound = RegRead($RegRoot&"\OPT", "SoundMode")
	$Mu_User = IniRead($Config_File, "OPT", "LoginID", "")
	$Mu_Pass = IniRead($Config_File, "OPT", "LoginPass", "")
	$UserArray = IniReadSection($Config_File, "LOGIN")
	
	$C_InvOpen = IniRead($Config_File, "COLOR", "InvOpen", 0xF8BC20)
	$C_InvOpenY = IniRead($Config_File, "COLOR", "InvOpenY", 0xC48205)
	$C_InvOpenR = IniRead($Config_File, "COLOR", "InvOpenR", 0xC33810)
	$C_InvEmpty = IniRead($Config_File, "COLOR", "InvEmpty", 0x3C3C3F)
	$C_Ignore1 = IniRead($Config_File, "COLOR", "Ignore1", 0x0B01DB)	;Large Mana pots
	$C_Ignore2 = IniRead($Config_File, "COLOR", "Ignore2", 0x000000)
	$C_RavenAlive = IniRead($Config_File, "COLOR", "RavenAlive", 0x1FEE9E)
	$C_IsParty = IniRead($Config_File, "COLOR", "IsParty", 0xF1FAED)
	$C_Friend = IniRead($Config_File, "COLOR", "IsFriend", 0x4E4D52)
	$C_Open = IniRead($Config_File, "COLOR", "IsOpen", 0x3F3F41)	;822-74 : 403F45 /444148 ## 0.8027 - 0.0964
	$C_Disco = IniRead($Config_File, "COLOR", "Disconnect", 0x131313)
	$C_Excellent = IniRead($Config_File, "COLOR", "Excellent", 0x003000)	;0x22-0x33	Tol 5 max!! Für Zen: 0xE6CA67
	$C_Tol = IniRead($Config_File, "COLOR", "Tolerance", 4)
	
EndFunc   ;==>_ReadConfig


Func _StopServer()
	_RemoteSend("STOP")
	Sleep(500)
	FileDelete(@TempDir & "\" & $netAppName)
EndFunc   ;==>_StopServer


Func _RepairAll()
	Local $XY[2] ;Aktuelle Mausposition
	Local $Pixel, $IsOpen

	$AFK_RepTimer = TimerDiff($AFK_RepLast)
	If $AFK_RepTimer > $AFK_RepDelay Then
		$AFK_RepLast = TimerInit()

		$XY = MouseGetPos()
		If $RMouse_Down == True Then
			MouseUp("Right")
		EndIf
		
		_OpenInventory(True)
		
		_RemoteSend("r")
		Sleep($Key_Delay)
		;Do Repair
		MouseClick("Left", Round($WSize[0] * 0.85), Round($WSize[1] * 0.16), 1, 2) ;Helm
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.94375), Round($WSize[1] * 0.16), 1, 2) ;Wings
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.759), Round($WSize[1] * 0.2117), 1, 2) ;Weapon
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.80625), Round($WSize[1] * 0.2117), 1, 2) ;Pendant
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.85), Round($WSize[1] * 0.2117), 1, 2) ;Armor
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.94375), Round($WSize[1] * 0.2117), 1, 2) ;Shield
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.759), Round($WSize[1] * 0.3417), 1, 2) ;Gloves
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.80625), Round($WSize[1] * 0.3417), 1, 2) ;Left Ring
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.85), Round($WSize[1] * 0.3417), 1, 2) ;Pants
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.8975), Round($WSize[1] * 0.3417), 1, 2) ;Right Ring
		EndIf
		If $Do_Run Then
			Sleep(100)
			MouseClick("Left", Round($WSize[0] * 0.94375), Round($WSize[1] * 0.3417), 1, 2) ;Boots
			Sleep(100)
		EndIf
		
		_OpenInventory(False)
		
		MouseMove($XY[0], $XY[1], $Mouse_Speed)
		If $RMouse_Down == True Then
			MouseDown("Right")
		EndIf
	EndIf
EndFunc   ;==>_RepairAll


Func _SetHandle()
	
	$WHandle = WinGetHandle("[ACTIVE]")	;Sets WHandle to active Window
	_RemoteSend("$$MWND=[ACTIVE]")		;Command to Server to also "Grab" the handle. Passing $WHandle does noit make it a handle for the server
	
EndFunc   ;==>_SetHandle


Func _AutoParty() ;Automatically party players near player position
	Local $XY[2] ;Current Mouseposition
	
	$AP_Timer = TimerDiff($AP_Last)
	If $AP_Timer > $AP_Delay Then
		$AP_Last = TimerInit()
		$XY = MouseGetPos()
		HotKeySet("{ENTER}")	;Disable chat interrupt
		MouseMove($AutoParty_XY[0], $AutoParty_XY[1], $Mouse_Speed)
		If $Do_Pick Then _RemoteSend("PICK OFF")	;Disable sending Spacebar from server component
		_RemoteSend("{ENTER}")
		_RemoteSend("/party")
		_RemoteSend("{ENTER}")
		Sleep($AP_Sleep)
		If $Do_Pick Then _RemoteSend("PICK ON")
		HotKeySet("{ENTER}", "_ToggleChat")
		MouseMove($XY[0], $XY[1], $Mouse_Speed)
	EndIf
	
EndFunc   ;==>_AutoParty


Func _UsePots()
	$Pots_Timer = TimerDiff($Pots_Last)
	If $Pots_Timer > $PotsDelay Then
		_RemoteSend($Pots)
		$Pots_Last = TimerInit()
	EndIf
EndFunc   ;==>_UsePots


Func _SendMacro()

	$Macro_Timer = TimerDiff($Macro_Last)
	If $Macro_Timer > $Macro_Delay Then
		_RemoteSend("!" & $Macro_Current)
		_RemoteSend("{ALTDOWN}{ALTUP}")
		$Macro_Current = Mod($Macro_Current, $Macro_Cnt) + 1	;Use Modulus operator to increment by 1 until last Macro is sent and reset to 0
		If $Macro_Current == 10 Then	;If $Macro_Cnt is 10, the above Modulus will not work, as range is 0 - 9
			$Macro_Current = 0
		EndIf
		$Macro_Last = TimerInit()
	EndIf
	
EndFunc   ;==>_SendMacro


Func _DropSetup() ;Set Current Mouseposition as Droplocation for Inv. clearing
	Local $XY[2]

	$XY = MouseGetPos()
	$WSize = WinGetClientSize($WHandle)
	If $WSize = 0 And $WHandle <> "MU" Then
		$WHandle = "MU"
		If WinActivate($WHandle) Then
			_SetHandle()
		EndIf
		$WSize = WinGetClientSize($WHandle)
	EndIf
	If IsArray ($WSize) Then
		$Drop_XY[0] = $XY[0]
		$Drop_XY[1] = $XY[1]
		;$Drop_XY[1] = Round($WSize[1] * 0.92)
		GUICtrlSetData($ctrl_DropPos, $Drop_XY[0] & "-" & $Drop_XY[1])
		$Drop_Pos_Set = True
	Else
		MsgBox(16,"Invalid Window Handle","MU Window could not be identified. Please use "&@CR&"<ALT><F9> to assign current Window as MU Window.",5)
	EndIf
	
EndFunc   ;==>_DropSetup


Func _DropItems($lCol, $lRow, $lPosX, $lPosY) ;Remove droppable Items from Inventory
	Local $XY[2], $Pos[2] ;Aktuelle Mausposition
	Local $XD, $YD ;Itemposition im Inventory
	Local $c, $r ;Row, Column Counter
	
	If $lRow <= 0 Then
		$lRow = 1
	EndIf
	If $lCol <= 0 Then
		$lCol = 1
	EndIf

	$Drop_Dura_Timer = TimerDiff($Drop_Dura_Last)
	If $Drop_Dura_Timer > $Drop_Delay Then

		$XY = MouseGetPos() ;Aktuell Pos sichern
		If $RMouse_Down == True Then
			MouseUp("Right")
		EndIf
		
		_OpenInventory(True)
		
		$r = $lRow + $Drop_Row_Tracker - 1
		
		For $c = $lCol - 1 To 7	;Clear 1 row at a time, and close inventory in between
			$XD = Round($WSize[0] / 1.34 + $WSize[0] / 32 * $c)
			$YD = Round($WSize[1] / 2.21 + $WSize[1] / 25.3 * $r)
			If _DetectItem($XD, $YD) Then
				If $Do_Log And $Do_Color Then
					AutoItSetOption ("MouseCoordMode", 1)	;Absolute Screen Position
					$Pos = MouseGetPos()
					AutoItSetOption ("MouseCoordMode", 2)	;Relative to Window Client Area
					$Pos[0] = $Pos[0] - $XY[0] + $XD
					$Pos[1] = $Pos[1] - $XY[1] + $YD
					_ScreenCap_Capture($SS_Path & "\" & "ItemDetected_" & $XD & "-" & $YD & "_" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".jpg", _
										$Pos[0]-2, $Pos[1]-2, $Pos[0]+2, $Pos[1]+2, True)
				EndIf
				MouseClick("Left", $XD, $YD, 1, $Mouse_Speed) ;Get Item
				MouseClick("Left", $lPosX, $lPosY, 1, $Mouse_Speed) ;Drop Item
				Sleep(500)
				_LogWrite("_DropItems von Col-Row: " & $c & "-" & $r)
			EndIf
			If $Do_Stop Then
				ExitLoop
			EndIf
		Next
		MouseMove($AFK_Pos[0], $AFK_Pos[1], $Mouse_Speed)
		
		_OpenInventory(False)

		MouseMove($XY[0], $XY[1], $Mouse_Speed)
		If $RMouse_Down == True Then
			MouseDown("Right")
		EndIf
		
		If $lRow + $Drop_Row_Tracker == 8 Then	;Increment Rowtracker OR reset timer
			$Drop_Dura_Last = TimerInit()
			$Drop_Row_Tracker = 0
		Else
			$Drop_Row_Tracker += 1
		EndIf
	EndIf
EndFunc   ;==>_DropItems

Func _DetectItem($x, $y)	;Detect if there is an item at inventory position X, Y
	Local $ItemDetected, $ItemPos, $d = 2
	
	If $Do_Color == False Then
		$ItemDetected = True
	Else
		$ItemPos = PixelSearch ( $x-$d, $y-$d, $x+$d, $y+$d, $C_InvEmpty, $C_Tol)	;$C_InvEmpty is the empty color value
		If IsArray($ItemPos) Then
			$ItemDetected = False		;Then there is no item
		Else 
			$ItemPos = PixelSearch ( $x-$d, $y-$d, $x+$d, $y+$d, $C_Ignore1, $C_Tol)	;$C_Ingnore1 allows to ignore Manapotions
			If IsArray($ItemPos) Then
				$ItemDetected = False		;Found first ignore Color
			Else 
				$ItemPos = PixelSearch ( $x-$d, $y-$d, $x+$d, $y+$d, $C_Ignore2, $C_Tol)	;$C_Ignore2 can be set to ignore other items, like high-level DW scrolls
				If IsArray($ItemPos) Then
					$ItemDetected = False		;Found second ignore Color
				Else 
					$ItemDetected = True		;Else theres an item - > droppable item detected
				EndIf
			EndIf
		EndIf
	_LogWrite ("_DetectItem Result at "&$x&"-"&$y&": " & $ItemDetected)
	EndIf
				
	Return $ItemDetected
EndFunc

Func _OpenInventory($Open = True) ;Open / Close Invetory
	Local $Pixel, $IsOpen
	Local $X0, $X1, $Y0, $Y1
	Local $cnt, $Pos[2], $XY[2]

	$X0 = $WSize[0] * 0.745		;these locations specify the postion of the yellow X
	$Y0 = $WSize[1] * 0.835
	$X1 = $WSize[0] * 0.76
	$Y1 = $WSize[1] * 0.86
	$cnt = 0

	If $Open == True Then	;true will open, false will close the inventory
		Do
			_RemoteSend("i") ;Inventory will open
			Sleep($Key_Delay) ;Make sure that keystroke will be accepted
			$IsOpen = True
			$Pixel = PixelSearch($X0, $Y0, $X1, $Y1, $C_InvOpen, $C_Tol)
			If Not IsArray($Pixel) Then
				$Pixel = PixelSearch($X0, $Y0, $X1, $Y1, $C_InvOpenY, $C_Tol)
				If Not IsArray($Pixel) Then
					$Pixel = PixelSearch($X0, $Y0, $X1, $Y1, $C_InvOpenR, $C_Tol)
					If Not IsArray($Pixel) Then
						_LogWrite("_DropItems: Inventory not open, trying again." & " :" & $cnt)
						$XY = MouseGetPos()
						AutoItSetOption ("MouseCoordMode", 1)	;Absolute Screen Position
						$Pos = MouseGetPos()
						AutoItSetOption ("MouseCoordMode", 2)	;Relative to Window Client Area
						$Pos[0] = $Pos[0] - $XY[0]
						$Pos[1] = $Pos[1] - $XY[1]						
						_ScreenCap_Capture($SS_Path & "\" & "OpenInvFail" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".jpg", _
									$X0+$Pos[0], $Y0+$Pos[1], $X1+$Pos[0], $Y1+$Pos[1], True)
						$IsOpen = False
					EndIf
				EndIf
			EndIf
			$cnt+=1
		Until $IsOpen Or $Do_Stop Or $cnt>4 Or $Do_Color == False
	Else
		Do
			_RemoteSend("i") ;Inventory Close
			Sleep($Key_Delay) ;Make sure that keystroke will be accepted
			$IsOpen = False
			$Pixel = PixelSearch($X0, $Y0, $X1, $Y1, $C_InvOpen, $C_Tol)
			If IsArray($Pixel) Then
				_LogWrite("_DropItems: Inventory still open, trying again. " & $Pixel[0] & "-" & $Pixel[1] & " :" & $cnt)
				$IsOpen = True
			Else
				$Pixel = PixelSearch($X0, $Y0, $X1, $Y1, $C_InvOpenY, $C_Tol)
				If IsArray($Pixel) Then
					_LogWrite("_DropItems: Inventory still open, trying again. " & $Pixel[0] & "-" & $Pixel[1] & " :" & $cnt)
					$IsOpen = True
				Else
					$Pixel = PixelSearch($X0, $Y0, $X1, $Y1, $C_InvOpenR, $C_Tol)
					If IsArray($Pixel) Then
						_LogWrite("_DropItems: Inventory still open, trying again. " & $Pixel[0] & "-" & $Pixel[1] & " :" & $cnt)
						$XY = MouseGetPos()
						AutoItSetOption ("MouseCoordMode", 1)	;Absolute Screen Position
						$Pos = MouseGetPos()
						AutoItSetOption ("MouseCoordMode", 2)	;Relative to Window Client Area
						$Pos[0] = $Pos[0] - $XY[0]
						$Pos[1] = $Pos[1] - $XY[1]						
						_ScreenCap_Capture($SS_Path & "\" & "CloseInvFail" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".jpg", _
									$X0+$Pos[0], $Y0+$Pos[1], $X1+$Pos[0], $Y1+$Pos[1], True)
						$IsOpen = True
					EndIf
				EndIf
			EndIf
			$cnt+=1
		Until Not $IsOpen Or $Do_Stop Or $cnt>4 Or $Do_Color == False
	EndIf
	If $cnt >4 Then
		_LogWrite("TimeOut in OpenInventory, failed attempt to OPEN: " & $Open & " :" & $cnt)
		_LogWrite("#####     Turning off Inventory Clear and AutoRepair     #####")
		$Do_Drop = False	;Flag for Inv. Clear
		$Do_Repair = False	;Flag for auto repair
	EndIf

EndFunc   ;==>_OpenInventory

Func _StopInfinity()
	;Click deactivate position
	_RemoteSend("{Shiftdown}")
	MouseClick("Left", Round($WSize[0] * 0.85), Round($WSize[1] * 0.015), 1, $Mouse_Speed)
	Sleep($Key_Delay)
	;Confirm deactivate
	MouseClick("Left", Round($WSize[0] * 0.42), Round($WSize[1] * 0.42), 1, $Mouse_Speed)
	_RemoteSend("{Shiftup}")
EndFunc   ;==>_StopInfinity

Func _SaveScreenShot()
	Local $XY[2], $Pos[2]
	
	$SS_Timer = TimerDiff($SS_Last)
	If $SS_Timer > $SS_Delay Then
		If $SS_MU_Type == True Then
			_RemoteSend("{PRINTSCREEN}")
			Sleep($Key_Delay)
		Else 
			If FileExists($SS_Path) == 0 Then
				DirCreate($SS_Path)
			EndIf
			AutoItSetOption ("MouseCoordMode", 1)	;Absolute Screen Position
			$XY = MouseGetPos()
			AutoItSetOption ("MouseCoordMode", 2)	;Relative to Window Client Area
			$Pos = MouseGetPos()
			$XY[0] = $XY[0] - $Pos[0]
			$XY[1] = $XY[1] - $Pos[1]
			;ConsoleWrite ($SS_Path & "\" & "Screen" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".jpg" & @CR)
			_ScreenCap_Capture($SS_Path & "\" & "Screen" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".jpg", _
									$XY[0], $XY[1], $XY[0] + $WSize[0], $XY[1] + $WSize[1], True)
			;_ScreenCapture_CaptureWnd($SS_Path & "\" & "Screen" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".jpg", $WHandle, 0, 0, -1, -1, True)
		EndIf
		$SS_Last = TimerInit()
	EndIf

EndFunc   ;==>_SaveScreenShot

Func _DeleteScreenshots()
	Local $fhandle, $file, $ftime, $delTime
	
	$delTime = _DateAdd("h", -$SS_Hours, _NowCalc())
	$delTime = StringRegExpReplace($delTime,"[/: ]","")
	;ConsoleWrite ($delTime & @CR)
	$fhandle = FileFindFirstFile ($SS_Path & "\*.jpg")
	If $fhandle <> -1 Then
		While 1
			$file = FileFindNextFile($fhandle)
			If @error = 1 Then ExitLoop
			$ftime = FileGetTime($SS_Path & "\" & $file, 0, 1)
			;ConsoleWrite($ftime & @CR)
			If $ftime < $delTime Then FileDelete($SS_Path & "\" & $file)
		WEnd
	EndIf
	FileClose($fhandle)
	
EndFunc

Func _SetUserData()	;Process combobox selection for selecting user account
	Local $index
	
	$index = _GUICtrlComboGetCurSel($ctrl_UserArray)
	If $index > 0 Then
		If IsArray($UserArray) Then
			$Mu_User = $UserArray[$index][0]
			$Mu_Pass = $UserArray[$index][1]
		EndIf
		RegWrite("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "ID", "REG_SZ", $Mu_User)
		If $Mu_Pass <> "" Then ClipPut($Mu_Pass)
		;ConsoleWrite ("Eintrag vorhanden, index" & $index & @CR)
	ElseIf $index = 0 Then
		;ConsoleWrite ("Kein Eintrag, index 0" & @CR)
		$Mu_User = ""
		$Mu_Pass = ""
		ClipPut($Mu_Pass)
	Else
		MsgBox(16, "Error in ComboSelection", "Invalid Selection, check Data Structure")
	EndIf
EndFunc   ;==>_SetUserData

Func _StartMuButton()	;Will be called by hotkey or GUI event, sets registry settings for MU launch
	Local $lWinMode, $lSound
	
	_DoReadGUI()
	
	$lSound = RegRead("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "SoundOnOff")
	If $lSound <> $Mu_Sound Then
		RegWrite("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "SoundOnOff", "REG_DWORD", $Mu_Sound)
	EndIf

	$lWinMode = RegRead("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "WindowMode")
	If $lWinMode <> $Mu_WinMode Then
		RegWrite("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "WindowMode", "REG_DWORD", $Mu_WinMode)
	EndIf

	If $Mu_User == "" Then
		$Mu_User = RegRead("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "ID")
	ElseIf $Mu_Pass <> "" Then
		ClipPut($Mu_Pass)
	EndIf

	_StartMu($Mu_User, $Mu_Pass)	;Will launch and run MU
	
EndFunc   ;==>_StartMuButton

Func _StartMu($User, $Pass)	;Will launch and run MU
	Local $MuID, $MuPath, $MuMini
	Local $MuTest, $lcnt
	
	If WinExists($WHandle) Then
		MsgBox(0x10, "MU Launcher", "MU is already running." & @CR & "Launch aborted!", 4)
		Return
	EndIf
	;read registry for mu data
	$MuID = RegRead("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "ID")
	If @error <> 0 Then
		MsgBox(0x10, "MU Launcher", "MU may not be installed or incompatible version." & @CR & "Registry Keys not found. Launch aborted!")
		Return
	EndIf
	If $MuID <> $User Then
		RegWrite("HKEY_CURRENT_USER\Software\Webzen\MU\Config", "ID", "REG_SZ", $User)
	EndIf
	If $MuExe = "" Then
		$MuExe = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Webzen\Mu", "Exe")
		If @error <> 0 Then
			MsgBox(0x10, "MU Launcher", "MU may not be installed or incompatible version." & @CR & "MU.EXE not found. Launch aborted!")
			Return
		EndIf
	EndIf
	
	If Not FileExists($MuExe) Then
		$lcnt = -2
		Do
			$MuTest = StringLeft($MuExe, StringInStr($MuExe, "\", 0, $lcnt)) & "Mu\"	;Here I try to compensate for Installer Error from MU
			ConsoleWrite("MuTest = " & $MuTest & @CR)									;The Exe key does not point to correct location always
			If FileExists($MuTest & "mu.exe") Then										;For my installations this workaround DID work
				$MuExe = $MuTest & "mu.exe"												;Best is to change the key in the registry to the correct path
;				If $SS_MU_Type Then	$SS_Path = StringTrimRight($MuTest,1)	;To make sure that $SS_Path is not \ terminated
				$MuPath = StringTrimRight($MuTest, 1)
				ExitLoop
			EndIf
			$lcnt -= 1
		Until $MuTest = ""
	EndIf

	If Not WinExists("MU Auto Update") Then
		If Not WinExists($WHandle) Then
			Run($MuExe, StringLeft ($MuExe, StringInStr($MuExe,"\",1,-1)-1))
		Else
			MsgBox(0x40, "MU Launcher", "MU Process main.exe detected." & @CR & "Stopping Launcher.", 3)
			Return
		EndIf
	Else
		MsgBox(0x40, "MU Launcher", "MU Launcher Process mu.exe detected." & @CR & "Using Existing Launcher Window.", 3)
		WinActivate("MU Auto Update")
	EndIf

	WinWaitActive("MU Auto Update", "Click connection button", 15)
	Sleep(1000)
	ControlClick("MU Auto Update", "Connect", 1999)
;THIS IS FUTURE DEVELOPMENT FOR AUTORECONNECT --- GO FOR IT ;)
	;Connect to server
	;login and wait character screen
	;select character
	
EndFunc   ;==>_StartMu

;This function was intended to automatically detect party size, but fails to return proper value. So it is not used :(
Func _DetectPartySize()
	Local $i, $Pixel, $lParty = 1
	
	For $i = 4 To 1 Step -1
		$Pixel = PixelSearch($PM_X[$i] - 4, $PM_Y[$i] - 4, $PM_X[$i] + 4, $PM_Y[$i] + 4, $C_IsParty, $C_Tol)
		_LogWrite("_DetectPartySize: $i: x-y: $C_IsParty: $lParty: " & $i & " : " & $PM_X[$i] & "-" & $PM_Y[$i] & " : " & $C_IsParty & " : " & $lParty)
		If IsArray($Pixel) Then
			$lParty = $i + 1
			ExitLoop
		EndIf
	Next
	Return $lParty
	
EndFunc   ;==>_DetectPartySize

Func _RemoteSend($sData, $line = @ScriptLineNumber)	;Replaces standard send, will send to key server
	Local $recv
	Local $lcnt
	
	_LogWrite("_RemoteSend: Writing to StdIn: " & $sData & "  Line: " & $line)
	StdinWrite($netServer, $sData)
	$lcnt = 0
	While StdoutRead($netServer, 1, True) == ""
		Sleep(25)
		$lcnt += 1
		If $lcnt > 100 Then
			_LogWrite("Timeout in _RemoteSend: " & $sData)
			MsgBox(16, "Communication Error", "Server Timeout occured in" & @LF & "Function _RemoteSend", 2)
			ExitLoop
		EndIf
	WEnd
	$recv = StdoutRead($netServer)	;Hand Shake with server to make sure data was processed
	If $recv <> $sData Then
		If $recv == "ERR" Then
			_LogWrite("Server reported invalid Command: " & $sData)
			MsgBox(16, "Server Error", "Chaos Bot Server received invalid Command: " & $sData, 3)
		Else
			_LogWrite("Server returned invalid Data: " & $sData & " - " & $recv)
			MsgBox(16, "Server Error", "Chaos Bot Server returned wrong Data: " & $recv & @CR & "Expected Data was: " & $sData, 3)
		EndIf
	EndIf

EndFunc   ;==>_RemoteSend

Func _Shutdown()	;This will end MU and Bot and shutdown the PC if desired
	
	If Int(@HOUR) == $AFK_Off_h Then
		If Int(@MIN) >= $AFK_Off_min Then
			_LogWrite("System reached shutdown time --- shutting down NOW")
			_RemoteSend("{SHIFTUP}{ALTUP}{CTRLUP}")
			_BotHalt()
			_SaveConfig()
			If $Do_ScreenShot Then
				_SaveScreenShot()
			EndIf
			;Shutdown Mu
			If WinActivate($WHandle) Then
				ConsoleWrite("Found Handle" & @LF)
				_RemoteSend("{ESC}") ;Main Menu
				Sleep(1000)
				MouseClick("Left", Round($WSize[0] / 2), Round($WSize[1] * 0.2), 1, 2)
				Sleep(15000) ;Wait 15sec for disconnect
				MouseClick("Left", Round($WSize[0] / 2), Round($WSize[1] * 0.277), 1, 2)
			EndIf
			If $Shutdown_Mode >= 0 Then
				Shutdown($Shutdown_Mode) ;Force Shutdown and Poweroff
			EndIf
			_StopLog()
			_StopServer()
			Exit ;Terminate Bot
		EndIf
	EndIf
	
EndFunc

Func _RegistrySetup()	;Define initial values for GUI controls
	Local $cnt
	
	$RegRoot = "HKCU\Software\Webzen\Chaos Bot"
	
	If RegRead($RegRoot,"Init") <> "valid" Then
		RegWrite($RegRoot,"Init","REG_SZ","valid")
		RegWrite($RegRoot,"StartMode","REG_DWORD",5)
		RegWrite($RegRoot,"XPos","REG_DWORD",10)
		RegWrite($RegRoot,"YPos","REG_DWORD",10)

		RegWrite($RegRoot&"\EE", "Delay","REG_DWORD",55000)
		RegWrite($RegRoot&"\EE", "Defense Key","REG_SZ", "3")
		RegWrite($RegRoot&"\EE", "Damage Key","REG_SZ", "4")
		RegWrite($RegRoot&"\EE", "Heal Key","REG_SZ", "2")
		RegWrite($RegRoot&"\EE", "Party Size","REG_DWORD", 5)
		For $cnt = 0 To 4
			RegWrite($RegRoot&"\EE", "PM_Dam" & $cnt,"REG_DWORD", 1)
			RegWrite($RegRoot&"\EE", "PM_Def" & $cnt,"REG_DWORD", 1)
			RegWrite($RegRoot&"\EE", "PM_Heal" & $cnt,"REG_DWORD", 55000)
		Next

		RegWrite($RegRoot&"\AE", "Skill Key", "REG_SZ", "1")
		RegWrite($RegRoot&"\AE", "Skill Delay","REG_DWORD", 500)
		RegWrite($RegRoot&"\AE", "AEPower","REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "AEnoSkill","REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Start Angle","REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Stop Angle", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Intervall", "REG_DWORD", 30)
		RegWrite($RegRoot&"\AE", "Distance", "REG_DWORD", 100)
		RegWrite($RegRoot&"\AE", "Dist2", "REG_DWORD", 100)
		RegWrite($RegRoot&"\AE", "Selfbuff", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Partybuff", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Infinity", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Infinity Skill","REG_SZ", "0")
		RegWrite($RegRoot&"\AE", "Use Raven", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AE", "Raven TimeOut", "REG_DWORD", 210)
		
		RegWrite($RegRoot&"\DW", "Main Skill", "REG_SZ", "1")
		RegWrite($RegRoot&"\DW", "Supp. Skill", "REG_SZ", "5")
		RegWrite($RegRoot&"\DW", "Skill Delay", "REG_DWORD", 800)
		RegWrite($RegRoot&"\DW", "Supp. Skill Delay", "REG_DWORD", 65000)
		RegWrite($RegRoot&"\DW", "Use Supp. Skill", "REG_DWORD", 0)
		RegWrite($RegRoot&"\DW", "PowerSkilling", "REG_DWORD", 0)
		RegWrite($RegRoot&"\DW", "Party Mode", "REG_DWORD", 0)
		RegWrite($RegRoot&"\DW", "Combo Mode", "REG_DWORD", 0)
		RegWrite($RegRoot&"\DW", "Combo Skill1", "REG_SZ", "1")
		RegWrite($RegRoot&"\DW", "Skill1 Delay", "REG_DWORD", 500)
		RegWrite($RegRoot&"\DW", "Combo Skill2", "REG_SZ", "2")
		RegWrite($RegRoot&"\DW", "Skill2 Delay", "REG_DWORD", 500)
		RegWrite($RegRoot&"\DW", "Combo Skill3", "REG_SZ", "3")
		RegWrite($RegRoot&"\DW", "Skill3 Delay", "REG_DWORD", 500)
		
		RegWrite($RegRoot&"\AFK", "Auto Pick", "REG_DWORD", 1)
		RegWrite($RegRoot&"\AFK", "Auto Repair", "REG_DWORD", 1)
		RegWrite($RegRoot&"\AFK", "Repair Timer", "REG_DWORD", 2400000)
		RegWrite($RegRoot&"\AFK", "Request Mode", "REG_DWORD", 1)
		RegWrite($RegRoot&"\AFK", "AFK Mode", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AFK", "Pots Usage", "REG_DWORD", 1)
		RegWrite($RegRoot&"\AFK", "Pots Keys", "REG_SZ", "QE")
		RegWrite($RegRoot&"\AFK", "Pots Delay", "REG_DWORD", 120000)
		RegWrite($RegRoot&"\AFK", "Drop Items",  "REG_DWORD", 1)
		RegWrite($RegRoot&"\AFK", "Drop StartRow", "REG_DWORD", 5)
		RegWrite($RegRoot&"\AFK", "Drop StartCol", "REG_DWORD", 5)
		RegWrite($RegRoot&"\AFK", "Drop Delay", "REG_DWORD", 180000)
		RegWrite($RegRoot&"\AFK", "Do Screenshots", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AFK", "Screenshot Delay", "REG_DWORD", 120000)
		RegWrite($RegRoot&"\AFK", "Exc Upper Left", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AFK", "Exc Upper Right", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AFK", "Exc Lower Left", "REG_DWORD", 0)
		RegWrite($RegRoot&"\AFK", "Exc Lower Right", "REG_DWORD", 0)
		
		RegWrite($RegRoot&"\OPT", "Shutdown", "REG_DWORD", 0)
		RegWrite($RegRoot&"\OPT", "SH Hour", "REG_DWORD", 20)
		RegWrite($RegRoot&"\OPT", "SH Min", "REG_DWORD", 0)
		RegWrite($RegRoot&"\OPT", "WindowMode", "REG_DWORD", 1)
		RegWrite($RegRoot&"\OPT", "SoundMode", "REG_DWORD", 0)
	EndIf

EndFunc

Func _SanityCheck()		;Function to verify the current operations
	;intended to check for DCs, Pending requests, open windows (friend, party, stats....)
	;WORK IN PROGRESS
	Local $Pixel, $XY[2]
	Local $FriendX, $FriendY
	Local $OpenX, $OpenY
	
	_LogWrite ("_SanityCheck is Running, AFK is " & $Do_AFK & " and Color is " & $Do_Color)
	
	$FriendX = Round($WSize[0] * 0.0488)
	$FriendY = Round($WSize[1] * 0.842)
	$OpenX = Round($WSize[0] * 0.8027)
	$OpenY = Round($WSize[1] * 0.0964)
	
	$XY = MouseGetPos()
	;Check for Friend Request - THIS MIGHT CAUSE TROUBLE IN Chaos Castle and Blood Castle
	$Pixel = PixelSearch($FriendX-2, $FriendY-2, $FriendX+2, $FriendY+2, $C_Friend, $C_Tol)
	If IsArray ($Pixel) Then
		MouseMove($FriendX, $FriendY, $Mouse_Speed)
		_RemoteSend("{SHIFTDOWN}")
		_LeftClick()
		_RemoteSend("{SHIFTUP}")
		MouseMove($XY[0], $XY[1], $Mouse_Speed)
	EndIf
;~ 	;Check for Open Tab		;822-74 : 403F45 /444148 ## 0.8027 - 0.0964
;~ 	$Pixel = PixelSearch($OpenX-4, $OpenY-4, $OpenX+4, $OpenY+4, $C_Open, $C_Tol)
;~ 	If IsArray ($Pixel) Then
;~ 		_RemoteSend("{ESC}")
;~ 	EndIf
	;Check for DC
	;If DC And $Do_Shutdown then _Shutdown()
	If $Do_Disco Then
		If _ManyPixelSearch($aXY_DC, $C_Disco, $C_Tol) Then
			_LogWrite ("_SanityCheck: Detected Disconnect, Stopping Bot/MU/PC")
			If $Do_Shutdown Then
				_Shutdown()
			Else
				_BotHalt()
			EndIf
		EndIf
	EndIf
EndFunc

;~ Func _SearchExcellent()	; This one attempts to search for excellent items in different regions of the map
;~ 	;DOES NOT WORK AS EXPECTED, as bloody MU does not allow to find the item text colors when ALT is active
;~ 	;Looking for other ways to make it work -> Analysing saved screenshots or such
;~ 	;WORK IN PROGRESS
;~ 	Local $XY, $rX, $rY

;~ 	If $Do_ExcUL Then
;~ 		;Search and pick left upper corner tile
;~ 		$XY = PixelSearch ($ExcTile[0][0],$ExcTile[0][1],$ExcTile[0][2],$ExcTile[0][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: UL Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcUL Or $Do_ExcUR Then
;~ 		;Search and pick upper center tile
;~ 		$XY = PixelSearch ($ExcTile[1][0],$ExcTile[1][1],$ExcTile[1][2],$ExcTile[1][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: UC Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcUR Then
;~ 		;Search and pick upper right corner tile
;~ 		$XY = PixelSearch ($ExcTile[2][0],$ExcTile[2][1],$ExcTile[2][2],$ExcTile[2][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: UR Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcLR Or $Do_ExcUR Then
;~ 		;Search and pick right center tile
;~ 		$XY = PixelSearch ($ExcTile[3][0],$ExcTile[3][1],$ExcTile[3][2],$ExcTile[3][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: RC Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcLR Then
;~ 		;Search and pick right lower corner tile
;~ 		$XY = PixelSearch ($ExcTile[4][0],$ExcTile[4][1],$ExcTile[4][2],$ExcTile[4][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: LR Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcLR Or $Do_ExcLL Then
;~ 		;Search and pick lower center tile
;~ 		$XY = PixelSearch ($ExcTile[5][0],$ExcTile[5][1],$ExcTile[5][2],$ExcTile[5][3], $C_Excellent, $C_Tol)
;~ 			_LogWrite("_SearchExc: LC Pixelsearch returned: " & @error)
;~ 			If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcLL Then
;~ 		;Search and pick left lower corner tile
;~ 		$XY = PixelSearch ($ExcTile[6][0],$ExcTile[6][1],$ExcTile[6][2],$ExcTile[6][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: LL Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf
;~ 	If $Do_ExcUL Or $Do_ExcLL Then
;~ 		;Search and pick left center tile
;~ 		$XY = PixelSearch ($ExcTile[7][0],$ExcTile[7][1],$ExcTile[7][2],$ExcTile[7][3], $C_Excellent, $C_Tol)
;~ 		_LogWrite("_SearchExc: LC Pixelsearch returned: " & @error)
;~ 		If IsArray ($XY) Then
;~ 			If $RMouse_Down Then MouseUp ("Right")
;~ 			MouseClick ("Left", $XY[0], $XY[1], 1, $Mouse_Speed)
;~ 			Sleep (3000)	;Delay to allow character to move and autopick
;~ 			$rX = $WSize[0] - $XY[0]
;~ 			$rY = $WSize[1] * 0.9 - $XY[1]
;~ 			MouseClick ("Left", $rX, $rY, 1, $Mouse_Speed)
;~ 			Sleep(2000)		;Let char move back to origin			
;~ 			If $RMouse_Down Then MouseDown ("Right")
;~ 		EndIf
;~ 	EndIf

;~ EndFunc

Func _ManyPixelSearch($aCoords, $Color, $cTol=3, $And=True)
	;Searches for a specific Color in several locations and returns true if Color was found
	;$aCoords is 0-based array, [0] is number of coord-sets, 1-4 is first set, and so on
	;if $And is false, the sets are evaluated OR based (1 coord must match), default AND based (all coords must match)
	
	Local $result = False, $XY, $i
	
	If Not IsArray ($aCoords) Then
		SetError (-1)
		Return $result
	EndIf
	
	If UBound($aCoords) = ($aCoords[0]*4)+1 Then
		For $i = 0 To $aCoords[0]-1
			$XY = PixelSearch ($aCoords[$i*4+1],$aCoords[$i*4+2],$aCoords[$i*4+3],$aCoords[$i*4+4],$Color,$cTol)
			If IsArray($XY) Then
				_LogWrite ("_ManyPixelSeach found Pixel "&$i&" at "&$XY[0]&"-"&$XY[1])
				If Not $And Or $i = $aCoords[0]-1 Then
					$result = True
					ExitLoop
				EndIf
			Else
				If $And Then ExitLoop
			EndIf
		Next
	EndIf
	
	Return $result
EndFunc

Func _SelectMuPath()
;Dummy function to be used with the TEST button in the UI. No current code associated with this.

If $MuExe = "" Then
	$MuExe = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Webzen\Mu", "Exe")
EndIf

$MuExe = FileOpenDialog ("Select mu.exe", $MuExe, "Exe (*.exe)")

ConsoleWrite ($MuExe & @crlf)
ConsoleWrite (StringLeft ($MuExe, StringInStr($MuExe,"\",1,-1)-1) & @crlf)

EndFunc