#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=C:\Documents and Settings\J\My Documents\My Pictures\autoicon.ico
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs==============================================================================|
///////////////////////// AutoITV3 BETA-/////////////////////////////////////////|
//  Author: Krypton88@MMOWNED and Owner of KryptonWorkz.info/////////////////////|
//  Program: World Of WarCraft Auto-Caster (Fully Customizable)//////////////////|
//  Version: 1.0 ////////////////////////////////////////////////////////////////|
//  Type: OPEN SOURCE!///////////////////////////////////////////////////////////|
//  Notes: Thanks for downloading! This is a Small Project that I made on my/////|
// Free time! I originally made it for a small simple private program cuz ///////|
// I was sick of spamming spells, So I made a Fully Customizable program/////////|
// that casts spells Down to the Milli-Second of the global Cool-down! //////////|
// Meaning this program spams spells and buff's 3 times as fast as your hands!///|
// Making this very usful for grinding PLUS MORE EXP! and good for duels!////////|
// The faster you can cast spells the faster you can win right? /////////////////|
// Have Fun with it and Edit the Script if you want, Just respect me as//////////|
// the author and Credit me if you use this source on one of your projects :)////|
// Enjoy -Krypton88//////////////////////////////////////////////////////////////|
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#ce
; *** Start added by AutoIt3Wrapper ***
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
; *** End added by AutoIt3Wrapper ***
#include <GUIConstants.au3>
#include <Misc.au3>
#include <EzSkin.au3>
;===================================================================================|
; ---GUI CREATION-------------------------------------------------------------------|
;===================================================================================|
;$Form1 = GUICreate("WoW Auto-Caster V1.0", 250, 215, 193, 125)
$EzGUI = EzSkinGUICreate("MyEzSkinDemo",250,215)
$EzIcon = EzSkinIcon($EzGUI)
$Label1 = GUICtrlCreateLabel("Krypton's WoW Auto-Caster V1.0", 45, 8, 168, 17)
$Status = GUICtrlCreateLabel("Finding WoW.exe.....                    ", 40, 50, 170, 20, $SS_CENTER, $WS_EX_CLIENTEDGE)
$myexit = GUICtrlCreateButton("Exit Auto-Cast", 64, 160, 113, 25, 0, $WS_EX_CLIENTEDGE)
$ksave = GUICtrlCreateButton("Save Settings", 64, 185, 112, 25, 0, $WS_EX_CLIENTEDGE)
$Label2 = GUICtrlCreateLabel("HOTKEYS", 85, 104, 63, 17, $SS_CENTER)
$Label3 = GUICtrlCreateLabel("::Combat Spam::..   NUM Key-1", 47, 120)
$Label4 = GUICtrlCreateLabel("::Non-Combat::....    NUM Key-2", 47, 136)
$Combatlabel = GUICtrlCreateLabel("Combat Spells------------->>", 83, 68)
$Combatlabel = GUICtrlCreateLabel("<<-------------Non-Combat Buff's", 45, 84)
;===========================================================================================================|
; Program Reads the Settings in the Combat.ini and Noncombat.ini file, Default settings are 1,2,3,4,5,6,7,8-|
;===========================================================================================================|
$key1 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell1", ""), 220, 10, 25, 20)
$key2 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell2", ""), 220, 35, 25, 20)
$key3 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell3", ""), 220, 60, 25, 20)
$key4 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell4", ""), 220, 85, 25, 20)
$key5 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell5", ""), 220, 110, 25, 20)
$key6 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell6", ""), 220, 135, 25, 20)
$key7 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell7", ""), 220, 160, 25, 20)
$key8 = GUICtrlCreateInput(IniRead("combat.ini", "spells", "spell8", ""), 220, 185, 25, 20)
$nkey1 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff1", ""), 4, 10, 25, 20)
$nkey2 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff2", ""), 4, 35, 25, 20)
$nkey3 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff3", ""), 4, 60, 25, 20)
$nkey4 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff4", ""), 4, 85, 25, 20)
$nkey5 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff5", ""), 4, 110, 25, 20)
$nkey6 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff6", ""), 4, 135, 25, 20)
$nkey7 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff7", ""), 4, 160, 25, 20)
$nkey8 = GUICtrlCreateInput(IniRead("noncombat.ini", "buffs", "buff8", ""), 4, 185, 25, 20)
GUISetState(@SW_SHOW)
;===================================================================================|
;Hot Key's you can set this to whatever you like! I personally like {NUMPAD} keys..-|
;===================================================================================|
HotKeySet("{NUMPAD1}", "combatspell")
HotKeySet("{NUMPAD2}", "noncombat")
;====================================================================================|
;If WoW Window Exists Show that Auto-Cast is ready!----------------------------------|
;====================================================================================|
If WinExists("World of Warcraft") Then
	Sleep(3000)
	GUICtrlSetData($Status, "Found WoW! Auto-Cast is Ready!")
Else
	GUICtrlSetData($status, "WoW.exe Not Found...")
EndIf
;Loop for Saving Settings to the Config file(.INI) I Do not recommend editing this if you dont know what you doing...
While 1
	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE;Exit Script...Duh
			Exit
		
EndSwitch
Select
	Case $nMsg = $myexit;Exit script if user press's "exit Auto-caster" button...Duh :)
		Exit
	Case $nmsg = $ksave;Saves all user settings in direct file, Does NOT take up much CPU :) 
		IniWrite("combat.ini", "spells", "spell1", GUICtrlRead($Key1))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell2", GUICtrlRead($Key2))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell3", GUICtrlRead($Key3))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell4", GUICtrlRead($Key4))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell5", GUICtrlRead($Key5))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell6", GUICtrlRead($Key6))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell7", GUICtrlRead($Key7))
		Sleep(5)
		IniWrite("combat.ini", "spells", "spell8", GUICtrlRead($Key8))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff1", GUICtrlRead($nkey1))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff2", GUICtrlRead($nkey2))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff3", GUICtrlRead($nkey3))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff4", GUICtrlRead($nkey4))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff5", GUICtrlRead($nkey5))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff6", GUICtrlRead($nkey6))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff7", GUICtrlRead($nkey7))
		Sleep(5)
		IniWrite("noncombat.ini", "buffs", "buff8", GUICtrlRead($nkey8))
	
EndSelect


WEnd
;======================================================================================================|
;--COMBAT SPELLS FUNCTION! Set to send each spell down to the milli-Second!(you can edit if you like.. |
;======================================================================================================|
Func combatspell()
	$file = FileOpen("combat.ini", 0)
	While 1
		If GUICtrlRead($key1) = "" Then
		MsgBox(1, "Error", "Minimum of 3 spells are Required for Auto-Cast to work!")
		ExitLoop
	EndIf
	If GUICtrlRead($key2) = "" Then
		MsgBox(1, "Error", "Minimum of 3 spells are Required for Auto-Cast to work!")
		ExitLoop
	EndIf
	If GUICtrlRead($key3) = "" Then
		MsgBox(1, "Error", "Minimum of 3 spells are Required for Auto-Cast to work!")
		ExitLoop
	EndIf
	Send(GUICtrlRead($key1))
	Sleep(1600)
	Send(GUICtrlRead($key2))
	Sleep(1600)
	Send(GUICtrlRead($key3))
	Sleep(1600)
	Send(GUICtrlRead($key4))
	Sleep(1600)
	Send(GUICtrlRead($key5))
	Sleep(1600)
	Send(GUICtrlRead($key6))
	Sleep(1600)
	Send(GUICtrlRead($key7))
	If GUICtrlRead($key4) = "" Then
		Send("")
	EndIf
	If GUICtrlRead($key5) = "" Then
		Send("")
	EndIf
	If GUICtrlRead($key6) = "" Then
		Send("")
	EndIf
	If GUICtrlRead($key7) = "" Then
		Send("")
	EndIf
	ExitLoop
WEnd
EndFunc
;======================================================================================|
;--NON-COMBAT BUFFS/SPELLS Function----------------------------------------------------|
;======================================================================================|
Func noncombat()
	while 1
		If GUICtrlRead($nkey1) = "" Then
		MsgBox(1, "Error", "Minimum of 3 Buff's are Required for Auto-Cast to work!")
		ExitLoop
	EndIf
	If GUICtrlRead($nkey2) = "" Then
		MsgBox(1, "Error", "Minimum of 3 Buff's are Required for Auto-Cast to work!")
		ExitLoop
	EndIf
	If GUICtrlRead($nkey3) = "" Then
		MsgBox(1, "Error", "Minimum of 3 Buff's are Required for Auto-Cast to work!")
		ExitLoop
	EndIf
		Send(GUICtrlRead($nkey1))
		Sleep(1700)
		Send(GUICtrlRead($nkey2))
		Sleep(1700)
		Send(GUICtrlRead($nkey3))
		Sleep(1700)
		Send(GUICtrlRead($nkey4))
		Sleep(1700)
		Send(GUICtrlRead($nkey5))
		Sleep(1700)
		Send(GUICtrlRead($nkey6))
		Sleep(1700)
		Send(GUICtrlRead($nkey7))
		If GUICtrlRead($nkey4) = "" Then
			Send("")
		EndIf
		If GUICtrlRead($nkey5) = "" Then
			Send("")
		EndIf
		If GUICtrlRead($nkey6) = "" Then
			Send("")
		EndIf
		If GUICtrlRead($nkey7) = "" Then
			Send("")
		EndIf
		ExitLoop
	WEnd
EndFunc
