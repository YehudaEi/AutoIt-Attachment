#cs
	Author: Robbie Casstevens - thetwistedpanda@gmail.com
	Title: Panda's Dragon Court Client, version 2.0
	Information:
	Start Date: 6/01/07
	Release Date:
	---
	This client is simply a Graphical User Interface (GUI) with an embedded internet explorer
		window linked to Dragon Court @ www.FFiends.com. This client does not break/bend/modify/etc
		any of the game's defined rules set by FFiends.com and is perfectly safe for use. The only
		fault of this client is the fact it basically removes all Advertisements the site uses,
		which was one of the main reasons for creating the client (they're annoying). The client
		saves and encrypts your login information for any number of characters for both the regular
		Dragon Court server, as well as the Dragon Court Test server. It features automatic login,
		numerous settings for the Client, your Heroes, and the client's Security. A few worth
		mentioning are a working Countdown timer which informs the user when the next Quest Refresh
		occurs, several Links around the Dragon Court Homepage and various other sites to help players
		in their adventures, and numerous "Extra" program add-ons such as the AutoClicker - A program
		which automatically clicks your mouse repeatedly until you press the stop key (It is very useful
		inside the Queen's Royal Court).
  
	On the event the Client looses focus or another object is brought infront of the client, the
		applet for Dragon Court will disappear to protect it from an AutoIt error (the language this
		client was written in). If for any reason your screen (Dragon Court applet) go complete white
		or have white blotches on the screen which inhibit game play, drag the client off screen and
		bring it back slowly to fix the problem. Another possible solution is to 'defocus' the client,
		i.e. clicking another object in the background or minimizing the client.

	Myself, nor this client, has any affiliation with Fred's Fiends, Inc nor FFiends.com (©1997-2007).
#ce

#cs 
	Dragon Court Client v2.0 To Do List
	:Script
	;- Remove Duplicate Code for GameType = 0 & 1
	;- Optimize Various Segments of Code
	
	;Loading
	;- Load Passwords into variables for Encryption Level
	;   to function properly
	
	;Drag_GUI
	;- Loading Messages
	;- Pause Messages
	
	;Drag_Mod
	;- Changing Server Type malfunctions
	
	;Drag_Security
	;- Client Password Menu
	;-  Save as Ini (Opt)
	;-  Save as Reg (Opt)
	;-  Reset Password
	
	;Drag_Hero
	;- Drag & Drop on ListViews results in a Hard Crash
	
	;Client Add-ons
	;- Auto Clicker
	;- Note Taker
	;- Password Encrypter
#ce

;======================================================
;=GUI Includes=========================================
;======================================================
#include <GUIConstants.au3>
#include <IE.au3>
#include <Array.au3>
#include <String.au3>
#include <Date.au3>
#include <GuiListView.au3>
;#include <_MouseHover.au3>

;======================================================
;=GUI Options==========================================
;======================================================
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
Opt("SendKeyDelay", 1)
Opt("TrayMenuMode", 1)
Opt("WinTitleMatchMode", 2)
HotKeySet("{TAB}", "_TabPatch")

_IEErrorHandlerRegister()
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
$DPI = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "AppliedDPI")
If $DPI <= 108 Then
	$FontSize = 10
ElseIf $DPI >= 109 Then
	$FontSize = 8
EndIf

;======================================================
;=GUI Variables========================================
;======================================================
If Not FileExists(@ProgramFilesDir & "\Dragon Court Client") Then
	DirCreate(@ProgramFilesDir & "\Dragon Court Client\")
	DirCreate(@ProgramFilesDir & "\Dragon Court Client\Images\")
	DirCreate(@ProgramFilesDir & "\Dragon Court Client\Extras\")
EndIf

FileInstall("Images\Spacer.jpg", @ProgramFilesDir & "\Dragon Court Client\Images\Spacer.jpg", 1)
FileInstall("Images\DC_ICO_01.ico", @ProgramFilesDir & "\Dragon Court Client\Images\DC_ICO_01.ico", 1)
FileInstall("Images\DC_ICO_02.ico", @ProgramFilesDir & "\Dragon Court Client\Images\DC_ICO_02.ico", 1)
FileInstall("Images\DC_ICO_03.ico", @ProgramFilesDir & "\Dragon Court Client\Images\DC_ICO_03.ico", 1)
FileInstall("Images\DC_BMP_01.bmp", @ProgramFilesDir & "\Dragon Court Client\Images\DC_BMP_01.bmp", 1)
FileInstall("Images\DC_BMP_02.bmp", @ProgramFilesDir & "\Dragon Court Client\Images\DC_BMP_02.bmp", 1)
FileInstall("Images\DC_BMP_03.bmp", @ProgramFilesDir & "\Dragon Court Client\Images\DC_BMP_03.bmp", 1)

If FileExists(@ScriptDir & "\DragClient.ini") Then
	If Not FileExists(@ProgramFilesDir & "\Dragon Court Client\DragClient.ini") Then
		FileCopy(@ScriptDir & "\DragClient.ini", @ProgramFilesDir & "\Dragon Court Client\DragClient.ini", 1)
	EndIf
EndIf

Const $EM_SETPASSWORDCHAR = 0xCC
Global Const $WM_MENUSELECT = 0x011F
GUIRegisterMsg($WM_MENUSELECT, "_MouseOverMenu")

Local $IniFile = ""
Local $IniFile = IniRead($IniFile, "Dragon Court Client", "Config Dir", @ProgramFilesDir & "\Dragon Court Client\") & "DragClient.ini"
Local $Drag_URL = "                                      "
Local $Drag_TestURL = "                                        "
Local $Cur_Date = @YEAR & "/" & @MON & "/" & @MDAY
Local $StartTime, $Secs, $Mins, $Hour, $Time, $Cur_Sel, $FontSize, $Java_Ctrl
Local $aCtrlArray[1], $aCtrlMsgArray[1], $ControlID

Dim $NameToLink
Dim $LinkToName

$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", 0)
Dim $HeroArray[$CurrentNumber + 1][2]
Local $HeroArray[$CurrentNumber + 1][2]
$HeroArray[0][0] = "Select Hero:"

$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", 0)
Dim $TestArray[$CurrentNumber + 1][2]
Local $TestArray[$CurrentNumber + 1][2]
$TestArray[0][0] = "Select Hero:"

;======================================================
;=Ini Defaults=========================================
;======================================================
If Not FileExists($IniFile) Then
	;Client;===========================================
	IniWrite($IniFile, "Dragon Court Client", "Config Name", $IniFile)
	IniWrite($IniFile, "Dragon Court Client", "Config Dir", @ProgramFilesDir & "\Dragon Court Client\")
	IniWrite($IniFile, "Dragon Court Client", "Component Dir", @ProgramFilesDir & "\Dragon Court Client\Extras\")
	IniWrite($IniFile, "Dragon Court Client", "Image Dir", @ProgramFilesDir & "\Dragon Court Client\Images\")
	IniWrite($IniFile, "Dragon Court Client", "Client Version", "2.0")
	IniWrite($IniFile, "Dragon Court Client", "Loaded Defaults", 1)
	IniWrite($IniFile, "Dragon Court Client", "Has Loaded", 0)
	;Settings: Client;=================================
	IniWrite($IniFile, "Settings: Client", "Game Type", 0)
	IniWrite($IniFile, "Settings: Client", "Window Type", 0)
	IniWrite($IniFile, "Settings: Client", "Refresh Bar", 0)
	IniWrite($IniFile, "Settings: Client", "Status Bar", 0)
	IniWrite($IniFile, "Settings: Client", "Open Links", 1)
	IniWrite($IniFile, "Settings: Client", "Client Loading", 1)
	;Settings: Heroes;=================================
	IniWrite($IniFile, "Settings: Hero", "Text Speed", 10)
	IniWrite($IniFile, "Settings: Hero", "Mouse Speed", 10)
	IniWrite($IniFile, "Settings: Hero", "Save Level", 0)
	IniWrite($IniFile, "Settings: Hero", "Save Clan", 0)
	IniWrite($IniFile, "Settings: Hero", "Save Other", 0)
	;Settings: Security;===============================
	IniWrite($IniFile, "Settings: Security", "Client Password", 1)
	IniWrite($IniFile, "Settings: Security", "Show Password", 0)
	IniWrite($IniFile, "Settings: Security", "Require Password", 1)
	IniWrite($IniFile, "Settings: Security", "Client Encryption", 1)
	IniWrite($IniFile, "Settings: Security", "Hero Encryption", 1)
	IniWrite($IniFile, "Settings: Security", "Security Password", "")
EndIf

If IniRead($IniFile, "Settings: Client", "Refresh Bar", "") == 1 Then
	$Drag_LabelMsg = "Panda's D.C. Client, version 2.0"
Else
	$Drag_LabelMsg = "Time Until Quest Refresh: 00h 00m 00s"
EndIf
If IniRead($IniFile, "Settings: Client", "Status Bar", "") == 1 Then
	$Drag_StatMod = 25
Else
	$Drag_StatMod = 0
EndIf

;======================================================
;=Tray Information========================================
;======================================================
TraySetIcon(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_02.ico")
TrayTip("Panda's Dragon Court Client", "Loading...", 60)

$Tray_Exit = TrayCreateItem("Exit Client")

;======================================================
;=Parent GUI===========================================
;======================================================
If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
	$Drag_GUI = GUICreate("Dragon Court Client", 475, 460 - $Drag_StatMod, -1, -1, BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX), $WS_EX_STATICEDGE)
	GUISetState(@SW_HIDE, $Drag_GUI)

	$Drag_IE = _IECreateEmbedded()
	$Drag_ActiveX = GUICtrlCreateObj($Drag_IE, 15, 70, 444, 334)
	GUICtrlSetState($Drag_ActiveX, $GUI_HIDE)
	$Drag_Group1 = GUICtrlCreateGroup("", 5, 0, 465, 45)
	$Drag_Pic = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 0, 0, 475, 1)
	$Drag_Label = GUICtrlCreateLabel($Drag_LabelMsg, 15, 13, 240, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont($Drag_Label, $FontSize, 400, 0, "Comic Sans MS")
	$Drag_Combo = GUICtrlCreateCombo("Select Hero:", 280, 14, 180, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
	GUICtrlSetFont($Drag_Combo, $FontSize - 2, 400, 0, "Comic Sans MS")
	$Drag_Pic = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 266, 10, 1, 31)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Drag_Group2 = GUICtrlCreateGroup("Dragon Court Applet", 5, 50, 465, 380, $BS_CENTER)
	GUICtrlSetFont($Drag_Group2, $FontSize, 600, 0, "Comic Sans MS")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Drag_Status = GUICtrlCreateLabel("Status Bar", 5, 435, 465, 20, BitOR($SS_CENTERIMAGE, $SS_SUNKEN))
	GUICtrlSetFont($Drag_Status, $FontSize - 1, 400, 0, "Comic Sans MS")
	
	If IniRead($IniFile, "Settings: Client", "Status Bar", "") == 1 Then
		GUICtrlSetState($Drag_Status, $GUI_DISABLE)
	EndIf
Else
	$Drag_GUI = GUICreate("Dragon Court Client", 515, 490 - $Drag_StatMod, -1, -1, BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX), $WS_EX_STATICEDGE)
	GUISetState(@SW_HIDE, $Drag_GUI)
	$Drag_IE = _IECreateEmbedded()
	
	$Drag_ActiveX = GUICtrlCreateObj($Drag_IE, 15, 70, 484, 361)
	GUICtrlSetState($Drag_ActiveX, $GUI_HIDE)
	$Drag_Group1 = GUICtrlCreateGroup("", 5, 0, 505, 45)
	$Drag_Pic = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 0, 0, 475, 1)
	$Drag_Label = GUICtrlCreateLabel($Drag_LabelMsg, 15, 13, 270, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont($Drag_Label, $FontSize, 400, 0, "Comic Sans MS")
	$Drag_Combo = GUICtrlCreateCombo("Select Hero:", 310, 14, 180, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
	GUICtrlSetFont($Drag_Combo, $FontSize - 2, 400, 0, "Comic Sans MS")
	$Drag_Pic = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 290, 10, 1, 31)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Drag_Group2 = GUICtrlCreateGroup("Dragon Court *TEST* Applet", 5, 50, 505, 410, $BS_CENTER)
	GUICtrlSetFont($Drag_Group2, $FontSize, 600, 0, "Comic Sans MS")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Drag_Status = GUICtrlCreateLabel("Status Bar", 5, 465, 505, 17, BitOR($SS_CENTERIMAGE, $SS_SUNKEN))
	GUICtrlSetFont($Drag_Status, $FontSize - 1, 400, 0, "Comic Sans MS")
		
	If IniRead($IniFile, "Settings: Client", "Status Bar", "") == 1 Then
		GUICtrlSetState($Drag_Status, $GUI_DISABLE)
	EndIf
EndIf

;======================================================
;=Parent Menu==========================================
;======================================================
$Drag_FMenu = GUICtrlCreateMenu("&File")
_AddCtrl($Drag_FMenu, "File Menu")
$Drag_FItem1 = GUICtrlCreateMenuItem("Open Config", $Drag_FMenu)
_AddCtrl($Drag_FItem1, "Opens the client's configuration file.")
GUICtrlCreateMenuItem("", $Drag_FMenu, 1)
$Drag_Fitem2 = GUICtrlCreateMenuItem("Exit Client", $Drag_FMenu)
_AddCtrl($Drag_Fitem2, "Saves current data and exits the client.")
$Drag_SMenu = GUICtrlCreateMenu("Settings")
_AddCtrl($Drag_SMenu, "Settings Menu")
$Drag_SItem1 = GUICtrlCreateMenuItem("Client Config", $Drag_SMenu)
_AddCtrl($Drag_SItem1, "Creates a new window with various options for the client.")
$Drag_SItem2 = GUICtrlCreateMenuItem("Hero Config", $Drag_SMenu)
_AddCtrl($Drag_SItem2, "Creates a new window with options for your heroes.")
$Drag_SItem3 = GUICtrlCreateMenuItem("Security Config", $Drag_SMenu)
_AddCtrl($Drag_SItem3, "Creates a new window with options for the client's security.")
$Drag_EMenu = GUICtrlCreateMenu("Extras")
_AddCtrl($Drag_EMenu, "Extra Menu")
$Drag_EItem1 = GUICtrlCreateMenuItem("Auto Click", $Drag_EMenu)
_AddCtrl($Drag_EItem1, "Auto Click Program")
$Drag_Spacer = GUICtrlCreateMenuItem("", $Drag_EMenu, 1)
$Drag_IMenu = GUICtrlCreateMenu("Information")
_AddCtrl($Drag_IMenu, "Information Menu")
$Drag_IItem1 = GUICtrlCreateMenuItem("About the Client", $Drag_IMenu)
_AddCtrl($Drag_IItem1, "General information about the client.")
$Drag_IItem2 = GUICtrlCreateMenuItem("Further Information", $Drag_IMenu)
_AddCtrl($Drag_IItem2, "How to contact the author of the client...")

;======================================================
;=Drag_Client==========================================
;======================================================
$Drag_Client = GUICreate("Dragon Court Client: Client Settings", 405, 310, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE, $Drag_GUI)
GUISwitch($Drag_Client)
GUISetState(@SW_HIDE, $Drag_Client)

$Client_Group1 = GUICtrlCreateGroup("Game Type:", 5, 0, 195, 70, $BS_CENTER)
GUICtrlSetFont($Client_Group1, $FontSize + 1, 600, 0, "Comic Sans MS")
$Client_Radio1 = GUICtrlCreateRadio("Dragon Court", 15, 20, 175, 20)
GUICtrlSetFont($Client_Radio1, $FontSize, 400, 0, "Comic Sans MS")
$Client_Radio2 = GUICtrlCreateRadio("Dragon Court *TEST*", 15, 40, 175, 20)
GUICtrlSetFont($Client_Radio2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Group2 = GUICtrlCreateGroup("Window Type: *", 205, 0, 195, 70, $BS_CENTER)
GUICtrlSetFont($Client_Group2, $FontSize + 1, 600, 0, "Comic Sans MS")
$Client_Radio3 = GUICtrlCreateRadio("Highest Priority", 215, 20, 175, 20)
GUICtrlSetFont($Client_Radio3, $FontSize, 400, 0, "Comic Sans MS")
$Client_Radio4 = GUICtrlCreateRadio("Regular", 215, 40, 175, 20)
GUICtrlSetFont($Client_Radio4, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Group3 = GUICtrlCreateGroup("Quest Timer: *", 5, 75, 195, 70, $BS_CENTER)
GUICtrlSetFont($Client_Group3, $FontSize + 1, 600, 0, "Comic Sans MS")
$Client_Radio5 = GUICtrlCreateRadio("Enable", 15, 95, 115, 20)
GUICtrlSetFont($Client_Radio5, $FontSize, 400, 0, "Comic Sans MS")
$Client_Radio6 = GUICtrlCreateRadio("Disable", 15, 115, 125, 20)
GUICtrlSetFont($Client_Radio6, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Group4 = GUICtrlCreateGroup("Status Bar: *", 205, 75, 195, 70, $BS_CENTER)
GUICtrlSetFont($Client_Group4, $FontSize + 1, 600, 0, "Comic Sans MS")
$Client_Radio7 = GUICtrlCreateRadio("Enable", 215, 95, 115, 20)
GUICtrlSetFont($Client_Radio7, $FontSize, 400, 0, "Comic Sans MS")
$Client_Radio8 = GUICtrlCreateRadio("Disable", 215, 115, 125, 20)
GUICtrlSetFont($Client_Radio8, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Group5 = GUICtrlCreateGroup("Links:", 5, 150, 195, 70, $BS_CENTER)
GUICtrlSetFont($Client_Group5, $FontSize + 1, 600, 0, "Comic Sans MS")
$Client_Radio9 = GUICtrlCreateRadio("Open in New Window", 15, 170, 175, 20)
GUICtrlSetFont($Client_Radio9, $FontSize, 400, 0, "Comic Sans MS")
$Client_Radio10 = GUICtrlCreateRadio("Open in Existing Window", 15, 190, 175, 20)
GUICtrlSetFont($Client_Radio10, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Group6 = GUICtrlCreateGroup("Loading Order: *", 205, 150, 195, 70, $BS_CENTER)
GUICtrlSetFont($Client_Group6, $FontSize + 1, 600, 0, "Comic Sans MS")
$Client_Radio11 = GUICtrlCreateRadio("Client before Game", 215, 170, 175, 20)
GUICtrlSetFont($Client_Radio11, $FontSize, 400, 0, "Comic Sans MS")
$Client_Radio12 = GUICtrlCreateRadio("Game before Client", 215, 190, 175, 20)
GUICtrlSetFont($Client_Radio12, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Label1 = GUICtrlCreateLabel("Configuration File Directory:", 65, 230, 180, 20, $SS_CENTERIMAGE)
GUICtrlSetFont($Client_Label1, $FontSize, 400, 0, "Comic Sans MS")
$Client_Input1 = GUICtrlCreateInput(IniRead($IniFile, "Dragon Court Client", "Config Dir", ""), 5, 260, 395, 25, BitOR($ES_OEMCONVERT, $ES_READONLY, $ES_NOHIDESEL, $ES_AUTOHSCROLL))
GUICtrlSetFont($Client_Input1, $FontSize, 400, 0, "Comic Sans MS")
$Client_Button1 = GUICtrlCreateButton("Browse", 255, 230, 85, 20, 0)
GUICtrlSetFont($Client_Button1, $FontSize, 400, 0, "Comic Sans MS")
$Client_Label2 = GUICtrlCreateLabel("*: Denotes that these settings will not take effect until client has been restarted", 5, 290, 395, 20, BitOR($SS_CENTERIMAGE, $SS_CENTER))
GUICtrlSetFont($Client_Label2, $FontSize - 2, 400, 0, "Comic Sans MS")

;======================================================
;=Drag_Client Ini Settings=============================
;======================================================
If IniRead($IniFile, "Settings: Client", "Game Type", "") == 1 Then
	GUICtrlSetState($Client_Radio2, $GUI_CHECKED)
Else
	GUICtrlSetState($Client_Radio1, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Client", "Window Type", "") == 1 Then
	GUICtrlSetState($Client_Radio4, $GUI_CHECKED)
Else
	GUICtrlSetState($Client_Radio3, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Client", "Refresh Bar", "") == 1 Then
	GUICtrlSetState($Client_Radio6, $GUI_CHECKED)
Else
	GUICtrlSetState($Client_Radio5, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Client", "Status Bar", "") == 1 Then
	GUICtrlSetState($Client_Radio8, $GUI_CHECKED)
Else
	GUICtrlSetState($Client_Radio7, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Client", "Client Loading", "") == 1 Then
	GUICtrlSetState($Client_Radio12, $GUI_CHECKED)
Else
	GUICtrlSetState($Client_Radio11, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Client", "Open Links", "") == 1 Then
	GUICtrlSetState($Client_Radio10, $GUI_CHECKED)

	$Drag_EItem2 = GUICtrlCreateMenu("Links", $Drag_EMenu)
	$Drag_Link1 = GUICtrlCreateMenuItem("Create New Hero", $Drag_EItem2)
	$Drag_Link2 = GUICtrlCreateMenuItem("Change Hero's Password", $Drag_EItem2)
	$Drag_Link3 = GUICtrlCreateMenuItem("Recover Lost Password", $Drag_EItem2)
	$Drag_Link4 = GUICtrlCreateMenuItem("Change Hero's Email", $Drag_EItem2)
	$Drag_Link5 = GUICtrlCreateMenuItem("FFiends.com", $Drag_EItem2)
	$Drag_Link6 = GUICtrlCreateMenuItem("randomorange's Help Site", $Drag_EItem2)
Else
	GUICtrlSetState($Client_Radio9, $GUI_CHECKED)
	
	$Drag_EItem2 = GUICtrlCreateMenuItem("Links", $Drag_EMenu)
	$HiddenButton = GUICtrlCreateButton("", 0, 0, 0, 0)
	GUICtrlSetState($HiddenButton, @SW_HIDE)
	$Drag_Link1 = $HiddenButton
	$Drag_Link2 = $HiddenButton
	$Drag_Link3 = $HiddenButton
	$Drag_Link4 = $HiddenButton
	$Drag_Link5 = $HiddenButton
	$Drag_Link6 = $HiddenButton
EndIf

;======================================================
;=Drag_Hero============================================
;======================================================
$Drag_Hero = GUICreate("Dragon Court Client: Hero Settings", 405, 305, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE, $Drag_GUI)
GUISwitch($Drag_Hero)
GUISetState(@SW_HIDE, $Drag_Hero)

$Hero_Group1 = GUICtrlCreateGroup("Hero Information", 205, 0, 195, 85, $BS_CENTER)
GUICtrlSetFont($Hero_Group1, $FontSize + 1, 600, 0, "Comic Sans MS")
$Hero_Box1 = GUICtrlCreateCheckbox("Save Level", 215, 25, 85, 20)
GUICtrlSetFont($Hero_Box1, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Box2 = GUICtrlCreateCheckbox("Save Clan", 310, 25, 80, 20)
GUICtrlSetFont($Hero_Box2, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Box3 = GUICtrlCreateCheckbox("Save Extra Info", 215, 50, 175, 20)
GUICtrlSetFont($Hero_Box3, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Label1 = GUICtrlCreateLabel("*Saved in Config File*", 240, 68, 131, 15, $SS_CENTERIMAGE)
GUICtrlSetFont($Hero_Label1, $FontSize - 2, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Hero_Group2 = GUICtrlCreateGroup("Loading Speed (ms)", 5, 0, 195, 85, $BS_CENTER)
GUICtrlSetFont($Hero_Group2, $FontSize + 1, 600, 0, "Comic Sans MS")
$Hero_Label2 = GUICtrlCreateLabel("Text Input:", 10, 23, 75, 22, $SS_CENTERIMAGE)
GUICtrlSetFont($Hero_Label2, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Label3 = GUICtrlCreateLabel("Mouse Movement:", 10, 51, 110, 22, $SS_CENTERIMAGE)
GUICtrlSetFont($Hero_Label3, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Input1 = GUICtrlCreateInput(IniRead($IniFile, "Settings: Hero", "Text Speed", "10"), 130, 20, 60, 25, $ES_READONLY)
GUICtrlSetFont($Hero_Input1, $FontSize - 1, 400, 0, "Comic Sans MS")
$Hero_UpDown1 = GUICtrlCreateUpdown(-1, BitOr($UDS_NOTHOUSANDS, $UDS_ARROWKEYS))
GUICtrlSetLimit($Hero_UpDown1, 3000, 1)
$Hero_Input2 = GUICtrlCreateInput(IniRead($IniFile, "Settings: Hero", "Mouse Speed", "10"), 130, 50, 60, 25, $ES_READONLY)
GUICtrlSetFont($Hero_Input2, $FontSize - 1, 400, 0, "Comic Sans MS")
$Hero_UpDown2 = GUICtrlCreateUpdown(-1, BitOr($UDS_NOTHOUSANDS, $UDS_ARROWKEYS))
GUICtrlSetLimit($Hero_UpDown2, 3000, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Hero_Group3 = GUICtrlCreateGroup("Your Heroes", 5, 90, 395, 210, $BS_CENTER)
GUICtrlSetFont($Hero_Group3, $FontSize + 1, 600, 0, "Comic Sans MS")
$Hero_List1 = GUICtrlCreateListView("D.C. Server:", 15, 110, 185, 140, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_NOSORTHEADER), BitOr($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
GUICtrlSetFont($Hero_List1, $FontSize, 400, 0, "Comic Sans MS")
$Hero_List2 = GUICtrlCreateListView("Test Server:", 205, 110, 185, 140, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_NOSORTHEADER), BitOr($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
GUICtrlSetFont($Hero_List2, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Hidden1 = GUICtrlCreateEdit("", 15, 110, 185, 140, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_READONLY))
GUICtrlSetFont($Hero_Hidden1, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Hero_Hidden1, $GUI_HIDE)
$Hero_Hidden2 = GUICtrlCreateEdit("", 205, 110, 185, 140, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_READONLY))
GUICtrlSetFont($Hero_Hidden2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Hero_Hidden2, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Hero_Button1 = GUICtrlCreateButton("Add Hero", 35, 260, 105, 25, 0)
GUICtrlSetFont($Hero_Button1, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Button2 = GUICtrlCreateButton("Modify Hero", 150, 260, 105, 25, 0)
GUICtrlSetFont($Hero_Button2, $FontSize, 400, 0, "Comic Sans MS")
$Hero_Button3 = GUICtrlCreateButton("Remove Hero", 265, 260, 105, 25, 0)
GUICtrlSetFont($Hero_Button3, $FontSize, 400, 0, "Comic Sans MS")

;======================================================
;=Drag_Hero Ini Settings===============================
;======================================================
If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
	GUICtrlSetState($Hero_Box1, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
	GUICtrlSetState($Hero_Box2, $GUI_CHECKED)
EndIf
If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
	GUICtrlSetState($Hero_Box3, $GUI_CHECKED)
EndIf

;======================================================
;=Drag_Security========================================
;======================================================
$Drag_Security = GUICreate("Dragon Court Client: Security Settings", 405, 245, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE, $Drag_GUI)
GUISwitch($Drag_Security)
GUISetState(@SW_HIDE, $Drag_Security)

$Security_Group1 = GUICtrlCreateGroup("Client Password", 5, 0, 195, 70, $BS_CENTER)
GUICtrlSetFont($Security_Group1, $FontSize + 1, 600, 0, "Comic Sans MS")
$Security_Radio1 = GUICtrlCreateRadio("Enable", 15, 20, 175, 20)
GUICtrlSetFont($Security_Radio1, $FontSize, 400, 0, "Comic Sans MS")
$Security_Radio2 = GUICtrlCreateRadio("Disable", 15, 40, 175, 20)
GUICtrlSetFont($Security_Radio2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Security_Group2 = GUICtrlCreateGroup("Security Password", 205, 0, 195, 70, $BS_CENTER)
GUICtrlSetFont($Security_Group2, $FontSize + 1, 600, 0, "Comic Sans MS")
$Security_Input1 = GUICtrlCreateInput("", 215, 30, 120, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Security_Input1, $FontSize, 400, 0, "Comic Sans MS")
$Security_Button1 = GUICtrlCreateButton("", 345, 30, 45, 25)
GUICtrlSetFont($Security_Button1, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Security_Group3 = GUICtrlCreateGroup("Passwords", 5, 75, 195, 70, $BS_CENTER)
GUICtrlSetFont($Security_Group3, $FontSize + 1, 600, 0, "Comic Sans MS")
$Security_Radio3 = GUICtrlCreateRadio("Hide", 15, 95, 175, 20)
GUICtrlSetFont($Security_Radio3, $FontSize, 400, 0, "Comic Sans MS")
$Security_Radio4 = GUICtrlCreateRadio("Show", 15, 115, 175, 20)
GUICtrlSetFont($Security_Radio4, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Security_Group4 = GUICtrlCreateGroup("Hero Modification", 205, 75, 195, 70, $BS_CENTER)
GUICtrlSetFont($Security_Group4, $FontSize + 1, 600, 0, "Comic Sans MS")
$Security_Radio5 = GUICtrlCreateRadio("Require Password", 215, 95, 175, 20)
GUICtrlSetFont($Security_Radio5, $FontSize, 400, 0, "Comic Sans MS")
$Security_Radio6 = GUICtrlCreateRadio("Do Not Require", 215, 115, 175, 20)
GUICtrlSetFont($Security_Radio6, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Security_Group5 = GUICtrlCreateGroup("Encryption", 5, 150, 280, 90, $BS_CENTER)
GUICtrlSetFont($Security_Group5, $FontSize + 1, 600, 0, "Comic Sans MS")
$Security_Label1 = GUICtrlCreateLabel(" Client Password Hero Encryption:", 15, 175, 215, 25, BitOR($SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Security_Label1, $FontSize, 400, 0, "Comic Sans MS")
$Security_Input2 = GUICtrlCreateInput(IniRead($IniFile, "Settings: Security", "Client Encryption", 1), 235, 175, 40, 25)
GUICtrlSetFont($Security_Input2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateUpdown($Security_Input2)
GUICtrlSetLimit($Security_Input2, 5, 1)
$Security_Label2 = GUICtrlCreateLabel(" Hero Password Hero Encryption:", 15, 205, 215, 25, BitOR($SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Security_Label2, $FontSize, 400, 0, "Comic Sans MS")
$Security_Input3 = GUICtrlCreateInput(IniRead($IniFile, "Settings: Security", "Hero Encryption", 1), 235, 205, 40, 25)
GUICtrlSetFont($Security_Input3, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateUpdown($Security_Input3)
GUICtrlSetLimit($Security_Input3, 5, 1)
$Security_Button2 = GUICtrlCreateButton("Security", 305, 158, 80, 80, $BS_BITMAP)
GUICtrlSetFont($Security_Button2, $FontSize - 1, 400, 0, "Comic Sans MS")
GUICtrlSetImage($Security_Button2, IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_01.bmp", -1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;======================================================
;=Drag_Security Ini Settings===========================
;======================================================
If IniRead($IniFile, "Settings: Security", "Security Password", "") <> "" Then
	GUICtrlSetData($Security_Button1, "Enter")
Else
	GUICtrlSetData($Security_Button1, "Save")
EndIf

;======================================================
;=Drag_View============================================
;======================================================
$Drag_View = GUICreate("Dragon Court Client: View Config", 405, 450, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE, $Drag_GUI)
GUISwitch($Drag_View)
GUISetState(@SW_HIDE, $Drag_View)

$View_Group = GUICtrlCreateGroup("DragClient.ini", 5, 0, 395, 445, $BS_CENTER)
GUICtrlSetFont($View_Group, $FontSize + 0.5, 600, 0, "Comic Sans MS")
$View_Edit = GUICtrlCreateEdit("", 15, 20, 375, 415, BitOr($ES_READONLY, $ES_OEMCONVERT))
GUICtrlSetFont($View_Edit, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$IniOpen = FileOpen($IniFile, 0)

GUICtrlSetData($View_Edit, FileRead($IniOpen))

;======================================================
;=Drag_Information=====================================
;======================================================
$Drag_Info = GUICreate("Dragon Court Client: Information", 405, 250, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE, $Drag_GUI)
GUISwitch($Drag_Info)
GUISetState(@SW_HIDE, $Drag_Info)

$Info_Group = GUICtrlCreateGroup("Information", 5, 0, 395, 245, $BS_CENTER)
GUICtrlSetFont($Info_Group, $FontSize + 0.5, 600, 0, "Comic Sans MS")
$Info_Edit = GUICtrlCreateEdit("", 15, 20, 375, 215, BitOr($ES_READONLY, $ES_OEMCONVERT))
GUICtrlSetFont($Info_Edit, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)

;======================================================
;=Drag_Link============================================
;======================================================
$Drag_Link = GUICreate("Dragon Court Client: Links", 600, 375, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE, $Drag_GUI)
GUISwitch($Drag_Link)
GUISetState(@SW_HIDE, $Drag_Link)

$NameToLink = _ArrayCreate("", "1) Create a New Hero", "2) Change a Hero's Password", "3) Recover a Hero's Lost Password", _
		"4) Change a Hero's Email", "5) Navigate to FFiends.com", "6) randomorange's Help Site")

$LinkToName = _ArrayCreate("", "                                          ", "                                              ", _
		"                                              ", "                                               ", _
		"                       ", "                                              ")

$Link_Group = GUICtrlCreateGroup("Information", 5, 0, 590, 365, $BS_CENTER)
GUICtrlSetFont($Link_Group, $FontSize + 0.5, 600, 0, "Comic Sans MS")
$Link_Combo = GUICtrlCreateCombo("Select Link:", 15, 20, 570, 25)
GUICtrlSetFont($Link_Combo, $FontSize, 400, 0, "Comic Sans MS")
$Link_IE = _IECreateEmbedded()
$Link_ActiveX = GUICtrlCreateObj($Link_IE, 15, 55, 570, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

For $iCounter = 1 To UBound($NameToLink) - 1
	GUICtrlSetData($Link_Combo, $NameToLink[$iCounter], $NameToLink[0])
Next

;======================================================
;=Drag_Add=============================================
;======================================================
$Drag_Add = GUICreate("Dragon Court Client: Add Hero", 340, 315, -1, -1, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), BitOR($WS_EX_STATICEDGE, $WS_EX_TOOLWINDOW), $Drag_GUI)
GUISwitch($Drag_Add)
GUISetState(@SW_HIDE, $Drag_Add)

$Add_Group1 = GUICtrlCreateGroup("Add Hero", 5, 0, 330, 310, BitOR($BS_CENTER, $WS_CLIPSIBLINGS))
GUICtrlSetFont($Add_Group1, $FontSize + 1, 600, 0, "Comic Sans MS")
$Add_Box1 = GUICtrlCreateCheckbox("Name:", 15, 20, 85, 25)
GUICtrlSetFont($Add_Box1, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Box1, $GUI_CHECKED)
GUICtrlSetState($Add_Box1, $GUI_DISABLE)
$Add_Input1 = GUICtrlCreateInput("", 110, 20, 210, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Add_Input1, $FontSize, 400, 0, "Comic Sans MS")
$Add_Box2 = GUICtrlCreateCheckbox("Pass:", 15, 55, 85, 25)
GUICtrlSetFont($Add_Box2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Box2, $GUI_CHECKED)
GUICtrlSetState($Add_Box2, $GUI_DISABLE)
$Add_Input2 = GUICtrlCreateInput("", 110, 55, 210, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Add_Input2, $FontSize, 400, 0, "Comic Sans MS")
$Add_Box3 = GUICtrlCreateCheckbox("Level:", 15, 90, 85, 25)
GUICtrlSetFont($Add_Box3, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Box3, $GUI_DISABLE)
$Add_Input3 = GUICtrlCreateInput("1", 275, 90, 50, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetFont($Add_Input3, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Input3, $GUI_DISABLE)
$Add_UpDown1 = GUICtrlCreateUpdown($Add_Input3)
GUICtrlSetLimit($Add_UpDown1, 53, 1)
$Add_Box4 = GUICtrlCreateCheckbox("Clan:", 15, 125, 85, 25)
GUICtrlSetFont($Add_Box4, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Box4, $GUI_DISABLE)
$Add_Input4 = GUICtrlCreateInput("", 110, 125, 210, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Add_Input4, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Input4, $GUI_DISABLE)
$Add_Box5 = GUICtrlCreateCheckbox("Other:", 15, 160, 85, 25)
GUICtrlSetFont($Add_Box5, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Box5, $GUI_DISABLE)
$Add_Input5 = GUICtrlCreateInput("", 110, 160, 210, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Add_Input5, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Add_Input5, $GUI_DISABLE)
$Add_Group2 = GUICtrlCreateGroup("Server:", 15, 205, 310, 55, $BS_CENTER)
GUICtrlSetFont($Add_Group2, 9, 400, 0, "Comic Sans MS")
$Add_Radio1 = GUICtrlCreateRadio("Regular", 70, 225, 80, 25)
GUICtrlSetFont($Add_Radio1, 9, 400, 0, "Comic Sans MS")
$Add_Radio2 = GUICtrlCreateRadio("Test", 205, 225, 55, 25)
GUICtrlSetFont($Add_Radio2, 9, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Add_Button1 = GUICtrlCreateButton("Create Hero", 35, 270, 125, 25, BitOR($BS_CENTER, $BS_VCENTER))
GUICtrlSetFont($Add_Button1, $FontSize, 400, 0, "Comic Sans MS")
$Add_Button2 = GUICtrlCreateButton("Cancel", 175, 270, 125, 25, BitOR($BS_CENTER, $BS_VCENTER))
GUICtrlSetFont($Add_Button1, $FontSize, 400, 0, "Comic Sans MS")
$Add_Pic = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 5, 200, 326, 1)

;======================================================
;=Drag_Add Ini Settings================================
;======================================================
If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
	GUICtrlSetState($Add_Box3, $GUI_UNCHECKED)
	GUICtrlSetState($Add_Box3, $GUI_ENABLE)
	GUICtrlSetState($Add_Input3, $GUI_DISABLE)
Else
	GUICtrlSetState($Add_Box3, $GUI_UNCHECKED)
	GUICtrlSetState($Add_Box3, $GUI_DISABLE)
	GUICtrlSetState($Add_Input3, $GUI_DISABLE)
EndIf
If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
	GUICtrlSetState($Add_Box4, $GUI_UNCHECKED)
	GUICtrlSetState($Add_Box4, $GUI_ENABLE)
	GUICtrlSetState($Add_Input4, $GUI_DISABLE)
Else
	GUICtrlSetState($Add_Box4, $GUI_UNCHECKED)
	GUICtrlSetState($Add_Box4, $GUI_DISABLE)
	GUICtrlSetState($Add_Input5, $GUI_DISABLE)
EndIf
If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
	GUICtrlSetState($Add_Box5, $GUI_UNCHECKED)
	GUICtrlSetState($Add_Box5, $GUI_ENABLE)
	GUICtrlSetState($Add_Input5, $GUI_DISABLE)
Else
	GUICtrlSetState($Add_Box5, $GUI_UNCHECKED)
	GUICtrlSetState($Add_Box5, $GUI_DISABLE)
	GUICtrlSetState($Add_Input5, $GUI_DISABLE)
EndIf
If IniRead($IniFile, "Settings: Client", "Game Type", "") == 1 Then
	GUICtrlSetState($Add_Radio2, $GUI_CHECKED)
Else
	GUICtrlSetState($Add_Radio1, $GUI_CHECKED)
EndIf

;======================================================
;=Drag_Mod=============================================
;======================================================
$Drag_Mod = GUICreate("Dragon Court Client: Modify", 340, 435, Default, Default, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), BitOR($WS_EX_STATICEDGE, $WS_EX_TOOLWINDOW), $Drag_GUI)
GUISwitch($Drag_Mod)
GUISetState(@SW_HIDE, $Drag_Mod)

$Mod_Group1 = GUICtrlCreateGroup("Modify Hero", 5, 0, 330, 430, BitOR($BS_CENTER, $WS_CLIPSIBLINGS))
GUICtrlSetFont($Mod_Group1, $FontSize + 1, 600, 0, "Comic Sans MS")
$Mod_Label1 = GUICtrlCreateLabel("Username: ", 15, 20, 90, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Mod_Label1, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Combo = GUICtrlCreateCombo("", 110, 20, 215, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetFont($Mod_Combo, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Label2 = GUICtrlCreateLabel("Password: ", 15, 55, 90, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Mod_Label2, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Input1 = GUICtrlCreateInput("", 110, 55, 215, 25, BitOR($ES_CENTER, $ES_READONLY, $ES_AUTOHSCROLL))
GUICtrlSetFont($Mod_Input1, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Pic1 = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 5, 90, 329, 1)
$Mod_Label3 = GUICtrlCreateLabel(" Security: ", 15, 100, 85, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Mod_Label3, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Input2 = GUICtrlCreateInput("", 110, 100, 215, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Mod_Input2, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Pic2 = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 5, 135, 329, 1)
$Mod_Box1 = GUICtrlCreateCheckbox("Name:", 15, 145, 85, 25, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_VCENTER, $WS_TABSTOP))
GUICtrlSetFont($Mod_Box1, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Box1, $GUI_UNCHECKED)
$Mod_Input3 = GUICtrlCreateInput("", 110, 145, 215, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Mod_Input3, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Input3, $GUI_DISABLE)
$Mod_Box2 = GUICtrlCreateCheckbox("Pass:", 15, 175, 85, 25, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_VCENTER, $WS_TABSTOP))
GUICtrlSetFont($Mod_Box2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Box2, $GUI_UNCHECKED)
$Mod_Input4 = GUICtrlCreateInput("", 110, 175, 215, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Mod_Input4, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Input4, $GUI_DISABLE)
$Mod_Box3 = GUICtrlCreateCheckbox("Level:", 15, 205, 85, 25, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_VCENTER, $WS_TABSTOP))
GUICtrlSetFont($Mod_Box3, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
GUICtrlSetState($Mod_Box3, $GUI_DISABLE)
$Mod_Input5 = GUICtrlCreateInput("1", 275, 205, 50, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_NUMBER, $ES_READONLY))
GUICtrlSetFont($Mod_Input5, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
$Mod_UpDown1 = GUICtrlCreateUpdown($Mod_Input5)
GUICtrlSetLimit($Mod_UpDown1, 1, 53)
$Mod_Box4 = GUICtrlCreateCheckbox("Clan:", 15, 235, 85, 25, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_VCENTER, $WS_TABSTOP))
GUICtrlSetFont($Mod_Box4, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
GUICtrlSetState($Mod_Box4, $GUI_DISABLE)
$Mod_Input6 = GUICtrlCreateInput("", 110, 235, 215, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Mod_Input6, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Input6, $GUI_DISABLE)
$Mod_Box5 = GUICtrlCreateCheckbox("Other:", 15, 270, 85, 25, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_VCENTER, $WS_TABSTOP))
GUICtrlSetFont($Mod_Box5, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
GUICtrlSetState($Mod_Box5, $GUI_DISABLE)
$Mod_Input7 = GUICtrlCreateInput("", 110, 270, 215, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Mod_Input7, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
$Mod_Pic3 = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 5, 305, 329, 1)
$Mod_Group2 = GUICtrlCreateGroup("Server:", 15, 310, 310, 55, $BS_CENTER)
GUICtrlSetFont($Mod_Group2, 9, 400, 0, "Comic Sans MS")
$Mod_Radio1 = GUICtrlCreateRadio("Regular", 70, 330, 80, 25)
GUICtrlSetFont($Mod_Radio1, 9, 400, 0, "Comic Sans MS")
$Mod_Radio2 = GUICtrlCreateRadio("Test", 205, 330, 55, 25)
GUICtrlSetFont($Mod_Radio2, 9, 400, 0, "Comic Sans MS")
$Mod_Pic4 = GUICtrlCreatePic(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", 5, 375, 329, 1, BitOR($SS_NOTIFY, $WS_GROUP))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Mod_Button1 = GUICtrlCreateButton("Save Hero", 35, 390, 125, 25, BitOR($BS_CENTER, $BS_VCENTER))
GUICtrlSetFont($Mod_Button1, $FontSize, 400, 0, "Comic Sans MS")
$Mod_Button2 = GUICtrlCreateButton("Cancel", 175, 390, 125, 25, BitOR($BS_CENTER, $BS_VCENTER))
GUICtrlSetFont($Mod_Button2, $FontSize, 400, 0, "Comic Sans MS")

;======================================================
;=Drag_Mod Ini Settings================================
;======================================================
If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
	GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
	GUICtrlSetState($Mod_Box3, $GUI_ENABLE)
	GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
Else
	GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
	GUICtrlSetState($Mod_Box3, $GUI_DISABLE)
	GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
EndIf
If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
	GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
	GUICtrlSetState($Mod_Box4, $GUI_ENABLE)
	GUICtrlSetState($Mod_Input6, $GUI_DISABLE)
Else
	GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
	GUICtrlSetState($Mod_Box4, $GUI_DISABLE)
	GUICtrlSetState($Mod_Input6, $GUI_DISABLE)
EndIf
If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
	GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
	GUICtrlSetState($Mod_Box5, $GUI_ENABLE)
	GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
Else
	GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
	GUICtrlSetState($Mod_Box5, $GUI_DISABLE)
	GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
EndIf
If IniRead($IniFile, "Settings: Client", "Game Type", "") == 1 Then
	GUICtrlSetState($Mod_Radio2, $GUI_CHECKED)
Else
	GUICtrlSetState($Mod_Radio1, $GUI_CHECKED)
EndIf

;======================================================
;=Drag_Rem=============================================
;======================================================
$Drag_Rem = GUICreate("Dragon Court Client: Remove", 340, 275, Default, Default, BitOR($WS_POPUP, $WS_CHILD, $WS_CAPTION, $WS_SYSMENU, $WS_CLIPSIBLINGS), BitOR($WS_EX_STATICEDGE, $WS_EX_TOOLWINDOW), $Drag_GUI)
GUISwitch($Drag_Rem)
GUISetState(@SW_HIDE, $Drag_Rem)

$Rem_Group1 = GUICtrlCreateGroup("Remove Hero", 5, 0, 330, 270, BitOR($BS_CENTER, $WS_CLIPSIBLINGS))
GUICtrlSetFont($Rem_Group1, $FontSize + 1, 600, 0, "Comic Sans MS")
$Rem_Label1 = GUICtrlCreateLabel("Username: ", 15, 20, 90, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Rem_Label1, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Combo = GUICtrlCreateCombo("", 110, 20, 215, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetFont($Rem_Combo, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Label2 = GUICtrlCreateLabel(" Security: ", 15, 55, 90, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Rem_Label2, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Input1 = GUICtrlCreateInput("", 110, 55, 215, 25, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
GUICtrlSetFont($Rem_Input1, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Label3 = GUICtrlCreateLabel("Hero's Information: ", 15, 90, 310, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN))
GUICtrlSetFont($Rem_Label3, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Edit = GUICtrlCreateEdit("", 15, 125, 310, 100, BitOR($ES_MULTILINE, $ES_READONLY))
GUICtrlSetFont($Rem_Edit, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Button1 = GUICtrlCreateButton("Remove Hero", 35, 235, 125, 25, BitOR($BS_CENTER, $BS_VCENTER))
GUICtrlSetFont($Rem_Button1, $FontSize, 400, 0, "Comic Sans MS")
$Rem_Button2 = GUICtrlCreateButton("Cancel", 175, 235, 125, 25, BitOR($BS_CENTER, $BS_VCENTER))
GUICtrlSetFont($Rem_Button2, $FontSize, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)

;======================================================
;=Ini Operations=======================================
;======================================================
If IniRead($IniFile, "Settings: Client", "Window Type", 0) == 0 Then
	_ShowAndHideWin(1)
Else
	_ShowAndHideWin(0)
EndIf

If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
	$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")
	For $iCounter = 1 To $CurrentNumber
		If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
			GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), "Select Hero:")
		EndIf
	Next
Else
	$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")
	For $iCounter = 1 To $CurrentNumber
		If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
			GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), "Select Hero:")
		EndIf
	Next
EndIf

If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 7 Then
	_GUICtrlListViewSetColumnWidth($Hero_List1, 0, 164)
Else
	_GUICtrlListViewSetColumnWidth($Hero_List1, 0, $LVSCW_AUTOSIZE_USEHEADER)
EndIf

If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 7 Then
	_GUICtrlListViewSetColumnWidth($Hero_List2, 0, 164)
Else
	_GUICtrlListViewSetColumnWidth($Hero_List2, 0, $LVSCW_AUTOSIZE_USEHEADER)
EndIf

If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
	_GUICtrlListViewSetColumnHeaderText($Hero_List1, 0, "D.C. Server: *")
	GUICtrlSetState($Hero_List2, $GUI_DISABLE)

	If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 1 Then
		$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")

		For $iCounter = 1 To $CurrentNumber
			If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
				$HeroArray[$iCounter][0] = IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")
				$HeroArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

				GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
			EndIf
		Next
		If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 1 Then
			$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

			For $iCounter = 1 To $CurrentNumber
				If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
					$TestArray[$iCounter][0] = IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")
					$TestArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

					GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
				EndIf
			Next
		EndIf
	Else
		If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 1 Then
			$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

			For $iCounter = 1 To $CurrentNumber
				If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
					$TestArray[$iCounter][0] = IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")
					$TestArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

					GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
				EndIf
			Next
		EndIf
	EndIf
Else
	_GUICtrlListViewSetColumnHeaderText($Hero_List2, 0, "Test Server: *")
	GUICtrlSetState($Hero_List1, $GUI_DISABLE)
	
	If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 1 Then
		$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

		For $iCounter = 1 To $CurrentNumber
			If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
				$TestArray[$iCounter][0] = IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")
				$TestArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

				GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
			EndIf
		Next
		If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 1 Then
			$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")
			
			For $iCounter = 1 To $CurrentNumber
				If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
					$HeroArray[$iCounter][0] = IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")
					$HeroArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

					GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
				EndIf
			Next
		EndIf
	Else
		If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 1 Then
			$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")

			For $iCounter = 1 To $CurrentNumber
				If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
					$HeroArray[$iCounter][0] = IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")
					$HeroArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

					GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
				EndIf
			Next
		EndIf
	EndIf
EndIf

;===================================================
;Client Password is on, disable everything but input
;===================================================
If IniRead($IniFile, "Settings: Security", "Client Password", 1) == 0 Then
	If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
		IniWrite($IniFile, "Settings: Security", "Client Password", 1)
	EndIf

	If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
		;Password is enabled, but not set, so use defaults
		GUICtrlSetState($Security_Radio1, $GUI_CHECKED)

		If IniRead($IniFile, "Settings: Security", "Show Password", 0) == 0 Then
			GUICtrlSetState($Security_Radio3, $GUI_CHECKED)
		Else
			GUICtrlSetState($Security_Radio4, $GUI_CHECKED)
		EndIf

		If IniRead($IniFile, "Settings: Security", "Require Password", 0) == 0 Then
			GUICtrlSetState($Security_Radio5, $GUI_CHECKED)
		Else
			GUICtrlSetState($Security_Radio6, $GUI_CHECKED)
		EndIf

		GUICtrlSetState($Security_Input1, $GUI_ENABLE)
		GUICtrlSetState($Security_Group3, $GUI_ENABLE)
		GUICtrlSetState($Security_Radio3, $GUI_ENABLE)
		GUICtrlSetState($Security_Radio4, $GUI_ENABLE)
		GUICtrlSetState($Security_Group4, $GUI_ENABLE)
		GUICtrlSetState($Security_Radio5, $GUI_ENABLE)
		GUICtrlSetState($Security_Radio6, $GUI_ENABLE)
		GUICtrlSetState($Security_Group5, $GUI_ENABLE)
		GUICtrlSetState($Security_Input2, $GUI_ENABLE)
		GUICtrlSetState($Security_Input3, $GUI_ENABLE)
		GUICtrlSetState($Security_Button1, $GUI_ENABLE)
		GUICtrlSetState($Security_Button2, $GUI_ENABLE)
	Else
		;Password is set, disable everything
		GUICtrlSetState($Security_Radio1, $GUI_CHECKED)
		If IniRead($IniFile, "Settings: Security", "Show Password", 0) == 0 Then
			GUICtrlSetState($Security_Radio3, $GUI_CHECKED)
		Else
			GUICtrlSetState($Security_Radio4, $GUI_CHECKED)
		EndIf

		If IniRead($IniFile, "Settings: Security", "Require Password", 0) == 0 Then
			GUICtrlSetState($Security_Radio5, $GUI_CHECKED)
		Else
			GUICtrlSetState($Security_Radio6, $GUI_CHECKED)
		EndIf
		GUICtrlSetState($Security_Input1, $GUI_ENABLE)
		GUICtrlSetState($Security_Button1, $GUI_DISABLE)
		GUICtrlSetState($Security_Group1, $GUI_DISABLE)
		GUICtrlSetState($Security_Radio1, $GUI_DISABLE)
		GUICtrlSetState($Security_Radio2, $GUI_DISABLE)
		GUICtrlSetState($Security_Group3, $GUI_DISABLE)
		GUICtrlSetState($Security_Radio3, $GUI_DISABLE)
		GUICtrlSetState($Security_Radio4, $GUI_DISABLE)
		GUICtrlSetState($Security_Group4, $GUI_DISABLE)
		GUICtrlSetState($Security_Radio5, $GUI_DISABLE)
		GUICtrlSetState($Security_Radio6, $GUI_DISABLE)
		GUICtrlSetState($Security_Group5, $GUI_DISABLE)
		GUICtrlSetState($Security_Input2, $GUI_DISABLE)
		GUICtrlSetState($Security_Input3, $GUI_DISABLE)
		GUICtrlSetState($Security_Button2, $GUI_DISABLE)
	EndIf
	;=============================================
	;Client password is off, use disabled defaults
	;=============================================
Else
	GUICtrlSetState($Security_Radio2, $GUI_CHECKED)
	If IniRead($IniFile, "Settings: Security", "Show Password", 0) == 0 Then
		GUICtrlSetState($Security_Radio3, $GUI_CHECKED)
	Else
		GUICtrlSetState($Security_Radio4, $GUI_CHECKED)
	EndIf

	If IniRead($IniFile, "Settings: Security", "Require Password", 0) == 0 Then
		GUICtrlSetState($Security_Radio5, $GUI_CHECKED)
	Else
		GUICtrlSetState($Security_Radio6, $GUI_CHECKED)
	EndIf
	GUICtrlSetState($Security_Input1, $GUI_DISABLE)
	GUICtrlSetState($Security_Group1, $GUI_ENABLE)
	GUICtrlSetState($Security_Radio1, $GUI_ENABLE)
	GUICtrlSetState($Security_Radio2, $GUI_ENABLE)
	GUICtrlSetState($Security_Group3, $GUI_DISABLE)
	GUICtrlSetState($Security_Radio3, $GUI_DISABLE)
	GUICtrlSetState($Security_Radio4, $GUI_DISABLE)
	GUICtrlSetState($Security_Group4, $GUI_DISABLE)
	GUICtrlSetState($Security_Radio5, $GUI_DISABLE)
	GUICtrlSetState($Security_Radio6, $GUI_DISABLE)
	GUICtrlSetState($Security_Group5, $GUI_DISABLE)
	GUICtrlSetState($Security_Input2, $GUI_DISABLE)
	GUICtrlSetState($Security_Input3, $GUI_DISABLE)
	GUICtrlSetState($Security_Button1, $GUI_DISABLE)
	GUICtrlSetState($Security_Button2, $GUI_DISABLE)
EndIf

;======================================================
;=Client Operations====================================
;======================================================

If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
	_IENavigate($Drag_IE, $Drag_URL, 1)
Else
	_IENavigate($Drag_IE, $Drag_TestURL, 1)
EndIf
Sleep(10)
If IniRead($IniFile, "Settings: Client", "Client Loading", 0) == 0 Then
	$oApplet = _IETagNameGetCollection($Drag_IE, "applet", 0)
	$oApplet.scrollIntoView ()
	$Drag_IE.document.body.scroll = "no"
Else
	$oApplet = _IETagNameGetCollection($Drag_IE, "applet", 0)
	$oApplet.scrollIntoView ()
	$Drag_IE.document.body.scroll = "no"
EndIf

TrayTip("", "", 0)
GUISetState(@SW_SHOW, $Drag_GUI)
GUICtrlSetState($Drag_ActiveX, $GUI_SHOW)
WinActivate($Drag_GUI, "")

If IniRead($IniFile, "Settings: Client", "Refresh Bar", 0) == 0 Then
	$Temp_Html = _StringBetween(_IEPropertyGet($Drag_IE, "innerhtml"), "Quest Refresh:<BR>", "</b>")
	$QuestRefresh = String($Temp_Html[0])

	$UntilRefresh = StringSplit($QuestRefresh, " ", 0)
	For $iCounter = 1 To UBound($UntilRefresh) - 2
		$UntilRefresh[$iCounter] = StringTrimRight($UntilRefresh[$iCounter], 1)
		If $UntilRefresh[$iCounter] < 10 Then
			$UntilRefresh[$iCounter] = 0 & $UntilRefresh[$iCounter]
		EndIf
	Next

	$StartTime = ((($UntilRefresh[1] * 3600) + ($UntilRefresh[2] * 60)) + $UntilRefresh[3]) * 1000

	$_Countdown = TimerInit()
	AdlibEnable("_Countdown", 50)
EndIf
;======================================================
;=Client Code==========================================
;======================================================
While 1
	If StringInStr(ControlGetFocus($Drag_GUI, ""), "SunAwtCanvas") Then
		If Not @Error And $Java_Ctrl = "" Then
			$Java_Ctrl = ControlGetHandle($Drag_GUI, "", ControlGetFocus($Drag_GUI, ""))
			ControlFocus($Drag_GUI, "", $Java_Ctrl)
		EndIf
	EndIf
	
	If WinGetState($Drag_GUI) = 7 Or WinGetState($Drag_GUI) = 23 Then
		If BitAND(GUICtrlGetState($Drag_ActiveX), $GUI_SHOW) Then
			GUICtrlSetState($Drag_ActiveX, $GUI_HIDE)
			
			If $Java_Ctrl <> "" Then
				ControlDisable($Drag_GUI, "", $Java_Ctrl)
			EndIf
		EndIf
	ElseIf WinGetState($Drag_GUI) = 15 Then
		If BitAND(GUICtrlGetState($Drag_ActiveX), $GUI_HIDE) Then
			GUICtrlSetState($Drag_ActiveX, $GUI_SHOW)
			
			If $Java_Ctrl <> "" Then
				ControlEnable($Drag_GUI, "", $Java_Ctrl)
				ControlFocus($Drag_GUI, "", $Java_Ctrl)
			EndIf
		EndIf
	EndIf

	If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
		$Drag_X_Position = 480
	Else
		$Drag_X_Position = 520
	EndIf

	If WinActive("Dragon Court", "") Then
		HotKeySet("{TAB}", "_TabPatch")
	Else
		HotKeySet("{TAB}")
	EndIf

	If WinGetState($Drag_Security) == 15 Then
		If ControlGetHandle($Drag_Security, "", ControlGetFocus($Drag_Security, "")) == GUICtrlGetHandle($Security_Input1) Then
			If IniRead($IniFile, "Settings: Security", "Client Password", "") == 0 Then
				If StringLen(GUICtrlRead($Security_Input1)) >= 4 Then
					If BitAND(GUICtrlGetState($Security_Button1), $GUI_DISABLE) Then
						If BitAND(GUICtrlGetState($Security_Input1), $GUI_ENABLE) Then
							GUICtrlSetState($Security_Button1, $GUI_ENABLE)
						EndIf
					EndIf
				Else
					If BitAND(GUICtrlGetState($Security_Button1), $GUI_ENABLE) Then
						GUICtrlSetState($Security_Button1, $GUI_DISABLE)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	$nMsg = GUIGetMsg(1)
	Select
		;=============================================================
		Case $nMsg[1] = $Tray_Exit 	;=============================
			;=============================================================
			ExitLoop

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_GUI	;=
			;=============================================================
			ExitLoop

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Client;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Hero	;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Security
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_View	;=
			;=============================================================
			FileClose($IniOpen)
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Info	;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Link	;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Add	;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Mod	;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

		Case $nMsg[0] = $GUI_EVENT_CLOSE And $nMsg[1] = $Drag_Rem	;=
			;=============================================================
			GUISetState(@SW_HIDE, $nMsg[1])

			;=============================================================
		Case $nMsg[0] = $Drag_Fitem2	;=============================
			;=============================================================
			ExitLoop

			;=============================================================
		Case $nMsg[0] = $Drag_FItem1	;=============================
			;=============================================================
			$Drag_Pos = WinGetPos($Drag_GUI)
			WinMove($Drag_View, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
			GUISetState(@SW_SHOW, $Drag_View)
			;=============================================================
		Case $nMsg[0] = $Drag_SItem1	;=============================
			;=============================================================
			$Drag_Pos = WinGetPos($Drag_GUI)
			WinMove($Drag_Client, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
			GUISetState(@SW_SHOW, $Drag_Client)

			;=============================================================
		Case $nMsg[0] = $Drag_SItem2	;=============================
			;=============================================================
			$Drag_Pos = WinGetPos($Drag_GUI)
			WinMove($Drag_Hero, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
			GUISetState(@SW_SHOW, $Drag_Hero)
			;=============================================================
		Case $nMsg[0] = $Drag_SItem3	;=============================
			;=============================================================
			$Drag_Pos = WinGetPos($Drag_GUI)
			WinMove($Drag_Security, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
			GUICtrlSetData($Security_Input1, "")
			GUISetState(@SW_SHOW, $Drag_Security)

			;=============================================================
		Case $nMsg[0] = $Drag_IItem1	;=============================
			;=============================================================
			$Drag_Pos = WinGetPos($Drag_GUI)
			WinMove($Drag_Info, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
			GUICtrlSetData($Info_Edit, "Client Information")
			GUISetState(@SW_SHOW, $Drag_Info)

			;=============================================================
		Case $nMsg[0] = $Drag_IItem2	;=============================
			;=============================================================
			$Drag_Pos = WinGetPos($Drag_GUI)
			WinMove($Drag_Info, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
			GUICtrlSetData($Info_Edit, "Author Information")
			GUISetState(@SW_SHOW, $Drag_Info)

			;=============================================================
		Case $nMsg[0] = $Drag_EItem2	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", 1) == 1 Then
				$Drag_Pos = WinGetPos($Drag_GUI)
				WinMove($Drag_Link, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
				GUISetState(@SW_SHOW, $Drag_Link)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Combo 	;=============================
			;=============================================================
			If GUICtrlRead($Drag_Combo) <> "Select Hero:" Then
				If IniRead($IniFile, "Dragon Court Client", "Has Loaded", 0) == 1 Then
					If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
						_IENavigate($Drag_IE, $Drag_URL, 1)
					Else
						_IENavigate($Drag_IE, $Drag_TestURL, 1)
					EndIf
					IniWrite($IniFile, "Dragon Court Client", "Has Loaded", 0)
				EndIf

				Sleep(10)
				$oApplet = _IETagNameGetCollection($Drag_IE, "applet", 0)
				$oApplet.scrollIntoView ()
				$Drag_IE.document.body.scroll = "no"

				$MouseSpeed = IniRead($IniFile, "Settings: Hero", "Mouse Speed", "10")

				If IniRead($IniFile, "Settings: Client", "Game Type", 0) == 0 Then
					For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
						If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Drag_Combo) Then
							$Selection = $iCounter
							ExitLoop
						EndIf
					Next

					MouseClick("Primary", 175, 305, 1, $MouseSpeed)
					MouseClick("Primary", 175, 330, 1, $MouseSpeed)
					Opt("SendKeyDelay", 10)
					ControlSend("Dragon Court Client", "", $Drag_IE, "{BACKSPACE 15}")
					Sleep(10)
					Opt("SendKeyDelay", IniRead($IniFile, "Settings: Hero", "Text Speed", "10"))
					ControlSend("Dragon Court Client", "", $Drag_IE, IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""))

					MouseClick("Primary", 175, 360, 1, $MouseSpeed)
					Opt("SendKeyDelay", 10)
					ControlSend("Dragon Court Client", "", $Drag_IE, "{BACKSPACE 15}")
					Sleep(10)
					Opt("SendKeyDelay", IniRead($IniFile, "Settings: Hero", "Text Speed", "10"))
					ControlSend("Dragon Court Client", "", $Drag_IE, _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", "")))
					MouseClick("Primary", 315, 335, 1, $MouseSpeed)
					IniWrite($IniFile, "Dragon Court Client", "Has Loaded", 1)

					IniWrite($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Last Login", $Cur_Date)
				Else
					For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
						If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Drag_Combo) Then
							$Selection = $iCounter
							ExitLoop
						EndIf
					Next

					MouseClick("Primary", 175, 325, 1, $MouseSpeed)
					MouseClick("Primary", 175, 350, 1, $MouseSpeed)
					ControlSend("Dragon Court Client", "", $Drag_IE, "{BACKSPACE 15}")
					Sleep(10)
					ControlSend("Dragon Court Client", "", $Drag_IE, IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""))

					MouseClick("Primary", 175, 380, 1, $MouseSpeed)
					ControlSend("Dragon Court Client", "", $Drag_IE, "{BACKSPACE 15}")
					Sleep(10)
					ControlSend("Dragon Court Client", "", $Drag_IE, _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", "")))
					MouseClick("Primary", 335, 355, 1, $MouseSpeed)
					IniWrite($IniFile, "Dragon Court Client", "Has Loaded", 1)

					IniWrite($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Last Login", $Cur_Date)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio1 	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio1) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Game Type", "") <> 0 Then
					IniWrite($IniFile, "Settings: Client", "Game Type", 0)
					GUICtrlSetState($Drag_ActiveX, $GUI_SHOW)
					$Drag_Pos = WinGetPos($Drag_GUI)
					If IniRead($IniFile, "Settings: Client", "Status Bar", 0) == 1 Then
						$Drag_StatMod = 15
					EndIf
					WinMove($Drag_GUI, "", $Drag_Pos[0], $Drag_Pos[1], 480, 495 - $Drag_StatMod)
					GUICtrlSetPos($Drag_Group1, 5, 0, 465, 45)
					GUICtrlSetPos($Drag_Label, 15, 13, 240, 25)
					GUICtrlSetPos($Drag_Combo, 280, 15, 180, 25)
					GUICtrlSetPos($Drag_Pic, 266, 7, 1, 37)
					GUICtrlSetPos($Drag_Group2, 5, 50, 465, 365)
					GUICtrlSetPos($Drag_ActiveX, 15, 70, 444, 334)
					GUICtrlSetPos($Drag_Status, 5, 420, 465, 17)

					$Drag_X_Position = 480
					$Drag_Pos = WinGetPos($Drag_GUI)
					WinMove($Drag_View, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Client, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Hero, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Security, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Info, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Add, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Rem, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Mod, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])

					GUICtrlSetData($Drag_Group2, "Dragon Court Applet")
					GUICtrlSetState($Drag_ActiveX, $GUI_HIDE)
					GUICtrlSetState($Hero_List1, $GUI_ENABLE)
					GUICtrlSetState($Hero_List2, $GUI_DISABLE)

					_GUICtrlListViewDeleteAllItems($Hero_List1)
					_GUICtrlListViewDeleteAllItems($Hero_List2)
					_GUICtrlListViewSetColumnHeaderText($Hero_List1, 0, "D.C. Server: *")
					_GUICtrlListViewSetColumnHeaderText($Hero_List2, 0, "Test Server:")

					#cs 
					If IniRead($IniFile, "Settings: Hero", "Test Count", 0) <= 0 Then
						GUICtrlSetState($Hero_List2, $GUI_HIDE)
						GUICtrlSetState($Hero_Hidden1, $GUI_HIDE)
						GUICtrlSetState($Hero_Hidden2, $GUI_SHOW)
						GUICtrlSetState($Hero_List1, $GUI_SHOW)
					ElseIf IniRead($IniFile, "Settings: Hero", "Hero Count", 0) <= 0 Then
						GUICtrlSetState($Hero_List2, $GUI_SHOW)
						GUICtrlSetState($Hero_Hidden1, $GUI_SHOW)
						GUICtrlSetState($Hero_Hidden2, $GUI_HIDE)
						GUICtrlSetState($Hero_List1, $GUI_HIDE)						
					EndIf
					#ce
					
					If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 1 Then
						$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")

						Dim $HeroArray[$CurrentNumber + 1][2]

						$HeroArray[0][0] = "Select Hero:"
						$HeroArray[0][1] = ""
						
						GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")

						For $iCounter = 1 To $CurrentNumber
							If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
								$HeroArray[$iCounter][0] = IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")
								$HeroArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

								GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $HeroArray[0][0])
								GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
							EndIf
						Next
						If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 1 Then
							$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

							Dim $TestArray[$CurrentNumber + 1][2]

							$TestArray[0][0] = "Select Hero:"
							$TestArray[0][1] = ""

							For $iCounter = 1 To $CurrentNumber
								If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
									$TestArray[$iCounter][0] = IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")
									$TestArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

									GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
								EndIf
							Next
						EndIf
					Else
						GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")
						If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 1 Then
							$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

							Dim $TestArray[$CurrentNumber + 1][2]

							$TestArray[0][0] = "Select Hero:"
							$TestArray[0][1] = ""

							For $iCounter = 1 To $CurrentNumber
								If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
									$TestArray[$iCounter][0] = IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")
									$TestArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

									GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
								EndIf
							Next
						EndIf						
					EndIf

					If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 7 Then
						_GUICtrlListViewSetColumnWidth($Hero_List1, 0, 164)
					Else
						_GUICtrlListViewSetColumnWidth($Hero_List1, 0, $LVSCW_AUTOSIZE_USEHEADER)
					EndIf
					
					If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 7 Then
						_GUICtrlListViewSetColumnWidth($Hero_List2, 0, 164)
					Else
						_GUICtrlListViewSetColumnWidth($Hero_List2, 0, $LVSCW_AUTOSIZE_USEHEADER)
					EndIf

					_IENavigate($Drag_IE, $Drag_URL)
					$Drag_IE.document.body.scroll = "no"
					$oApplet = _IETagNameGetCollection($Drag_IE, "applet", 0)
					$oApplet.scrollIntoView ()
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio2 	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio2) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Game Type", "") <> 1 Then
					IniWrite($IniFile, "Settings: Client", "Game Type", 1)
					GUICtrlSetState($Drag_ActiveX, $GUI_SHOW)
					$Drag_Pos = WinGetPos($Drag_GUI)
					If IniRead($IniFile, "Settings: Client", "Status Bar", 0) == 1 Then
						$Drag_StatMod = 15
					EndIf					
					WinMove($Drag_GUI, "", $Drag_Pos[0], $Drag_Pos[1], 520, 525 - $Drag_StatMod)
					GUICtrlSetPos($Drag_Group1, 5, 0, 505, 45)
					GUICtrlSetPos($Drag_Label, 15, 13, 270, 25)
					GUICtrlSetPos($Drag_Combo, 310, 15, 180, 25)
					GUICtrlSetPos($Drag_Pic, 290, 7, 1, 37)
					GUICtrlSetPos($Drag_Group2, 5, 50, 505, 395)
					GUICtrlSetPos($Drag_ActiveX, 15, 70, 484, 361)
					GUICtrlSetPos($Drag_Status, 5, 450, 505, 17)

					$Drag_X_Position = 520
					$Drag_Pos = WinGetPos($Drag_GUI)
					WinMove($Drag_View, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Client, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Hero, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Security, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Info, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Add, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Rem, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])
					WinMove($Drag_Mod, "", $Drag_Pos[0] + $Drag_X_Position, $Drag_Pos[1])

					GUICtrlSetData($Drag_Group2, "Dragon Court *TEST* Applet")
					GUICtrlSetState($Drag_ActiveX, $GUI_HIDE)
					GUICtrlSetState($Hero_List2, $GUI_ENABLE)
					GUICtrlSetState($Hero_List1, $GUI_DISABLE)

					_GUICtrlListViewDeleteAllItems($Hero_List1)
					_GUICtrlListViewDeleteAllItems($Hero_List2)

					_GUICtrlListViewSetColumnHeaderText($Hero_List1, 0, "D.C. Server:")
					_GUICtrlListViewSetColumnHeaderText($Hero_List2, 0, "Test Server: *")
	
					#cs
					If IniRead($IniFile, "Settings: Hero", "Test Count", 0) <= 0 Then
						GUICtrlSetState($Hero_List1, $GUI_HIDE)
						GUICtrlSetState($Hero_List2, $GUI_SHOW)
					EndIf
					#ce
					
					If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 1 Then
						$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

						Dim $TestArray[$CurrentNumber + 1][2]

						$TestArray[0][0] = "Select Hero:"
						$TestArray[0][1] = ""
						
						GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")

						For $iCounter = 1 To $CurrentNumber
							If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
								$TestArray[$iCounter][0] = IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")
								$TestArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

								GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $TestArray[0][0])
								GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
							EndIf
						Next
						If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 1 Then
							$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")

							Dim $HeroArray[$CurrentNumber + 1][2]

							$HeroArray[0][0] = "Select Hero:"
							$HeroArray[0][1] = ""

							For $iCounter = 1 To $CurrentNumber
								If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
									$HeroArray[$iCounter][0] = IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")
									$HeroArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

									GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
								EndIf
							Next
						EndIf
					Else
						GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")
						If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 1 Then
							$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")

							Dim $HeroArray[$CurrentNumber + 1][2]

							$HeroArray[0][0] = "Select Hero:"
							$HeroArray[0][1] = ""

							For $iCounter = 1 To $CurrentNumber
								If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
									$HeroArray[$iCounter][0] = IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")
									$HeroArray[$iCounter][1] = _StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $iCounter & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))

									GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
								EndIf
							Next
						EndIf						
					EndIf

					If IniRead($IniFile, "Settings: Hero", "Hero Count", 0) >= 7 Then
						_GUICtrlListViewSetColumnWidth($Hero_List1, 0, 164)
					Else
						_GUICtrlListViewSetColumnWidth($Hero_List1, 0, $LVSCW_AUTOSIZE_USEHEADER)
					EndIf
					
					If IniRead($IniFile, "Settings: Hero", "Test Count", 0) >= 7 Then
						_GUICtrlListViewSetColumnWidth($Hero_List2, 0, 164)
					Else
						_GUICtrlListViewSetColumnWidth($Hero_List2, 0, $LVSCW_AUTOSIZE_USEHEADER)
					EndIf


					_IENavigate($Drag_IE, $Drag_TestURL)
					$Drag_IE.document.body.scroll = "no"
					$oApplet = _IETagNameGetCollection($Drag_IE, "applet", 0)
					$oApplet.scrollIntoView ()
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio3	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio3) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Window Type", "") <> 0 Then
					IniWrite($IniFile, "Settings: Client", "Window Type", 0)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio4 	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio4) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Window Type", "") <> 1 Then
					IniWrite($IniFile, "Settings: Client", "Window Type", 1)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio5	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio5) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Refresh Bar", "") <> 0 Then
					IniWrite($IniFile, "Settings: Client", "Refresh Bar", 0)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio6	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio6) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Refresh Bar", "") <> 1 Then
					IniWrite($IniFile, "Settings: Client", "Refresh Bar", 1)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio7	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio7) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Status Bar", "") <> 0 Then
					IniWrite($IniFile, "Settings: Client", "Status Bar", 0)
				EndIf
			EndIf
			;=============================================================
		Case $nMsg[0] = $Client_Radio8	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio8) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Status Bar", "") <> 1 Then
					IniWrite($IniFile, "Settings: Client", "Status Bar", 1)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio9	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio9) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Open Links", "") <> 0 Then
					IniWrite($IniFile, "Settings: Client", "Open Links", 0)
					GUICtrlDelete($Drag_EItem2)
					$Drag_EItem2 = GUICtrlCreateMenu("Links", $Drag_EMenu)
					$Drag_Link1 = GUICtrlCreateMenuItem("Create New Hero", $Drag_EItem2)
					$Drag_Link2 = GUICtrlCreateMenuItem("Change Hero's Password", $Drag_EItem2)
					$Drag_Link3 = GUICtrlCreateMenuItem("Recover Lost Password", $Drag_EItem2)
					$Drag_Link4 = GUICtrlCreateMenuItem("Change Hero's Email", $Drag_EItem2)
					$Drag_Link5 = GUICtrlCreateMenuItem("FFiends.com", $Drag_EItem2)
					$Drag_Link6 = GUICtrlCreateMenuItem("randomorange's Help Site", $Drag_EItem2)
					GUISetState(@SW_HIDE, $Drag_Link)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio10	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio10) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Open Links", "") <> 1 Then
					IniWrite($IniFile, "Settings: Client", "Open Links", 1)
					GUICtrlDelete($Drag_EItem2)
					$Drag_EItem2 = GUICtrlCreateMenuItem("Links", $Drag_EMenu)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio11	;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio11) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Client Loading", "") <> 0 Then
					IniWrite($IniFile, "Settings: Client", "Client Loading", 0)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Radio12 ;=============================
			;=============================================================
			If GUICtrlRead($Client_Radio12) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Client", "Client Loading", "") <> 1 Then
					IniWrite($IniFile, "Settings: Client", "Client Loading", 1)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Client_Button1	;=============================
			;=============================================================
			_ShowAndHideWin(0)
			$Path = FileSelectFolder("Select the folder containing " & $IniFile, "", 5, GUICtrlRead($Client_Input1))
			If Not @error Then
				If FileExists($Path) Then
					GUICtrlSetData($Client_Input1, $Path)
					
					DirCreate($Path & "\Dragon Court Client\")
					DirCreate($Path & "\Dragon Court Client\Images\")
					DirCreate($Path & "\Dragon Court Client\Extras\")
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Config Dir", "") & "\DragClient.ini", $Path & "\Dragon Court Client\DragClient.ini", 1)
					
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg", $Path & "\Dragon Court Client\Images\Spacer.jpg", 1)
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_01.ico", $Path & "\Dragon Court Client\Images\DC_ICO_01.ico", 1)
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_02.ico", $Path & "\Dragon Court Client\Images\DC_ICO_02.ico", 1)
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_03.ico", $Path & "\Dragon Court Client\Images\DC_ICO_03.ico", 1)
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_01.bmp", $Path & "\Dragon Court Client\Images\DC_BMP_01.bmp", 1)
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_02.bmp", $Path & "\Dragon Court Client\Images\DC_BMP_02.bmp", 1)
					FileCopy(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_03.bmp", $Path & "\Dragon Court Client\Images\DC_BMP_03.bmp", 1)
					
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "Spacer.jpg")
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_01.ico")
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_02.ico")
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_ICO_03.ico")
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_01.bmp")
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_02.bmp")
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Image Dir", "") & "DC_BMP_03.bmp")
					
					FileDelete(IniRead($IniFile, "Dragon Court Client", "Config Dir", "") & "\DragClient.ini")
					DirRemove(IniRead($IniFile, "Dragon Court Client", "Config Dir", ""))
					DirRemove(IniRead($IniFile, "Dragon Court Client", "Component Dir", ""))
					DirRemove(IniRead($IniFile, "Dragon Court Client", "Image Dir", ""))
					
					$IniFile = $Path & "\Dragon Court Client\DragClient.ini"

					IniWrite($IniFile, "Dragon Court Client", "Config Name", $IniFile)
					IniWrite($IniFile, "Dragon Court Client", "Config Dir", $Path & "\Dragon Court Client\")
					IniWrite($IniFile, "Dragon Court Client", "Component Dir", $Path & "\Dragon Court Client\Extras\")
					IniWrite($IniFile, "Dragon Court Client", "Image Dir", $Path & "\Dragon Court Client\Images\")
				EndIf
			Else
				MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "The directory you have chosen is invalid.")
			EndIf
			_ShowAndHideWin(1)

			;=============================================================
		Case $nMsg[0] = $Hero_UpDown1;====================================
			;=============================================================
			IniWrite($IniFile, "Settings: Hero", "Text Speed", GUICtrlRead($Hero_Input1))

			;=============================================================
		Case $nMsg[0] = $Hero_UpDown2;====================================
			;=============================================================	
			IniWrite($IniFile, "Settings: Hero", "Mouse Speed", GUICtrlRead($Hero_Input2))			

			;=============================================================
		Case $nMsg[0] = $Hero_Box1 	;=============================
			;=============================================================
			If GUICtrlRead($Hero_Box1) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Hero", "Save Level", "") <> 1 Then
					IniWrite($IniFile, "Settings: Hero", "Save Level", 1)
					GUICtrlSetState($Add_Box3, $GUI_UNCHECKED)
					GUICtrlSetState($Add_Box3, $GUI_ENABLE)
					GUICtrlSetState($Add_Input3, $GUI_DISABLE)

					GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
					GUICtrlSetState($Mod_Box3, $GUI_ENABLE)
					GUICtrlSetState($Mod_Input5, $GUI_DISABLE)					
				EndIf
			Else
				If IniRead($IniFile, "Settings: Hero", "Save Level", "") <> 0 Then
					IniWrite($IniFile, "Settings: Hero", "Save Level", 0)					
					GUICtrlSetState($Add_Box3, $GUI_UNCHECKED)
					GUICtrlSetState($Add_Box3, $GUI_DISABLE)
					GUICtrlSetState($Add_Input3, $GUI_DISABLE)

					GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
					GUICtrlSetState($Mod_Box3, $GUI_DISABLE)
					GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Hero_Box2 	;=============================
			;=============================================================
			If GUICtrlRead($Hero_Box2) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Hero", "Save Clan", "") <> 1 Then
					IniWrite($IniFile, "Settings: Hero", "Save Clan", 1)
					GUICtrlSetState($Add_Box4, $GUI_UNCHECKED)
					GUICtrlSetState($Add_Box4, $GUI_ENABLE)
					GUICtrlSetState($Add_Input4, $GUI_DISABLE)

					GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
					GUICtrlSetState($Mod_Box4, $GUI_ENABLE)
					GUICtrlSetState($Mod_Input6, $GUI_DISABLE)				
				EndIf
			Else
				If IniRead($IniFile, "Settings: Hero", "Save Clan", "") <> 0 Then
					IniWrite($IniFile, "Settings: Hero", "Save Clan", 0)
					GUICtrlSetState($Add_Box4, $GUI_UNCHECKED)
					GUICtrlSetState($Add_Box4, $GUI_DISABLE)
					GUICtrlSetState($Add_Input4, $GUI_DISABLE)		

					GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
					GUICtrlSetState($Mod_Box4, $GUI_DISABLE)
					GUICtrlSetState($Mod_Input6, $GUI_DISABLE)	
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Hero_Box3 	;=============================
			;=============================================================
			If GUICtrlRead($Hero_Box3) = $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Hero", "Save Other", "") <> 1 Then
					IniWrite($IniFile, "Settings: Hero", "Save Other", 1)
					GUICtrlSetState($Add_Box5, $GUI_UNCHECKED)
					GUICtrlSetState($Add_Box5, $GUI_ENABLE)
					GUICtrlSetState($Add_Input5, $GUI_DISABLE)
					
					GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
					GUICtrlSetState($Mod_Box5, $GUI_ENABLE)
					GUICtrlSetState($Mod_Input7, $GUI_DISABLE)					
				EndIf
			Else
				If IniRead($IniFile, "Settings: Hero", "Save Other", "") <> 0 Then
					IniWrite($IniFile, "Settings: Hero", "Save Other", 0)
					GUICtrlSetState($Add_Box5, $GUI_UNCHECKED)
					GUICtrlSetState($Add_Box5, $GUI_DISABLE)
					GUICtrlSetState($Add_Input5, $GUI_DISABLE)

					GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
					GUICtrlSetState($Mod_Box5, $GUI_DISABLE)
					GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Hero_Button1	;=============================
			;=============================================================
			GUICtrlSetData($Add_Input1, "")
			GUICtrlSetData($Add_Input2, "")
			GUICtrlSetData($Add_Input3, "1")
			GUICtrlSetData($Add_Input4, "")
			GUICtrlSetData($Add_Input5, "")

			If IniRead($IniFile, "Settings: Client", "Game Type", "") == 1 Then
				GUICtrlSetState($Add_Radio2, $GUI_CHECKED)
			Else
				GUICtrlSetState($Add_Radio1, $GUI_CHECKED)
			EndIf

			If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
				GUICtrlSetState($Add_Box3, $GUI_UNCHECKED)
				GUICtrlSetState($Add_Box3, $GUI_ENABLE)
				GUICtrlSetState($Add_Input3, $GUI_DISABLE)
			Else
				GUICtrlSetState($Add_Box3, $GUI_UNCHECKED)
				GUICtrlSetState($Add_Box3, $GUI_DISABLE)
				GUICtrlSetState($Add_Input3, $GUI_DISABLE)
			EndIf
			If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
				GUICtrlSetState($Add_Box4, $GUI_UNCHECKED)
				GUICtrlSetState($Add_Box4, $GUI_ENABLE)
				GUICtrlSetState($Add_Input4, $GUI_DISABLE)
			Else
				GUICtrlSetState($Add_Box4, $GUI_UNCHECKED)
				GUICtrlSetState($Add_Box4, $GUI_DISABLE)
				GUICtrlSetState($Add_Input4, $GUI_DISABLE)
			EndIf
			If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
				GUICtrlSetState($Add_Box5, $GUI_UNCHECKED)
				GUICtrlSetState($Add_Box5, $GUI_ENABLE)
				GUICtrlSetState($Add_Input5, $GUI_DISABLE)
			Else
				GUICtrlSetState($Add_Box5, $GUI_UNCHECKED)
				GUICtrlSetState($Add_Box5, $GUI_DISABLE)
				GUICtrlSetState($Add_Input5, $GUI_DISABLE)
			EndIf
			GUISetState(@SW_SHOW, $Drag_Add)

			;=============================================================
		Case $nMsg[0] = $Add_Button1	;=============================
			;=============================================================
			If GUICtrlRead($Add_Input1) == "" Or GUICtrlRead($Add_Input2) == "" Then
				MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "You did not enter your hero's username and/or passsword.")
			Else
				$Flag = True
				If GUICtrlRead($Add_Radio1) == $GUI_CHECKED Then
					For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
						If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") = GUICtrlRead($Add_Input1) Then
							MsgBox(BitOR(0, 48, 0, 8192, 262144), "Error", "The hero, " & GUICtrlRead($Add_Input1) & ", already exists in the hero database.")
							$Flag = False
						EndIf
					Next
				EndIf
				If GUICtrlRead($Add_Radio2) == $GUI_CHECKED Then
					For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
						If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") = GUICtrlRead($Add_Input1) Then
							MsgBox(BitOR(0, 48, 0, 8192, 262144), "Error", "The hero, " & GUICtrlRead($Add_Input1) & ", already exists in the test database.")
							$Flag = False
						EndIf
					Next
				EndIf

				$fMsg = "Create Hero?" & @CRLF & "Name: " & GUICtrlRead($Add_Input1) & @CRLF & "Password: " & GUICtrlRead($Add_Input2)
				If GUICtrlRead($Add_Box3) == $GUI_CHECKED Then
					If GUICtrlRead($Add_Input3) <> "" Then
						$fMsg = $fMsg & @CRLF & "Level: " & GUICtrlRead($Add_Input3)
					EndIf
				EndIf

				If GUICtrlRead($Add_Box4) == $GUI_CHECKED Then
					If GUICtrlRead($Add_Input4) <> "" Then
						$fMsg = $fMsg & @CRLF & "Clan: " & GUICtrlRead($Add_Input4)
					EndIf
				EndIf

				If GUICtrlRead($Add_Box5) == $GUI_CHECKED Then
					If GUICtrlRead($Add_Input5) <> "" Then
						$fMsg = $fMsg & @CRLF & "Other: " & GUICtrlRead($Add_Input5)
					EndIf
				EndIf

				If $Flag == True Then
					$MsgBox = MsgBox(BitOR(4, 32, 0, 4096, 262144), "Verify Information", $fMsg)

					If $MsgBox == 6 Then
						;==================================================
						;Contains Invalid Character & Length Error Checking
						;==================================================
						$eMsg = "The following characters are invalid"
						$fMsg = ""

						$uMsg = ""
						$User = ""
						If GUICtrlRead($Add_Box1) == $GUI_CHECKED Then
							$User = String(GUICtrlRead($Add_Input1))
							For $iCounter = 1 To StringLen($User)
								$Char = StringMid($User, $iCounter, 1)
								If (Asc($Char) >= 48 And Asc($Char) <= 57) Or (Asc($Char) >= 65 And Asc($Char) <= 90) Or (Asc($Char) == 95) Or (Asc($Char) >= 97 And Asc($Char <= 122)) Then
									ContinueLoop
								Else
									$uMsg = $uMsg & Chr(39) & $Char & Chr(39) & ", "
								EndIf
							Next
						EndIf

						$pMsg = ""
						$Pass = ""
						If GUICtrlRead($Add_Box2) == $GUI_CHECKED Then
							$Pass = String(GUICtrlRead($Add_Input2))
							For $iCounter = 1 To StringLen($Pass)
								$Char = StringMid($Pass, $iCounter, 1)
								If (Asc($Char) >= 48 And Asc($Char) <= 57) Or (Asc($Char) >= 65 And Asc($Char) <= 90) Or (Asc($Char) == 95) Or (Asc($Char) >= 97 And Asc($Char <= 122)) Then
									ContinueLoop
								Else
									$pMsg = $pMsg & Chr(39) & $Char & Chr(39) & ", "
								EndIf
							Next
						EndIf

						$lMsg = ""
						$Level = ""
						If GUICtrlRead($Add_Box3) == $GUI_CHECKED Then
							$Level = GUICtrlRead($Add_Input3)
						EndIf

						$cMsg = ""
						$Clan = ""
						If GUICtrlRead($Add_Box4) == $GUI_CHECKED Then
							$Clan = String(GUICtrlRead($Add_Input4))
							For $iCounter = 1 To StringLen($Clan)
								$Char = StringMid($Clan, $iCounter, 1)
								If Asc($Char) == 35 Or Asc($Char) == 39 Then
									$cMsg = $cMsg & Chr(39) & $Char & Chr(39) & ", "
								Else
									ContinueLoop
								EndIf
							Next
						EndIf

						$oMsg = ""
						$Other = ""
						If GUICtrlRead($Add_Box5) == $GUI_CHECKED Then
							$Other = String(GUICtrlRead($Add_Input5))
							For $iCounter = 1 To StringLen($Other)
								$Char = StringMid($Other, $iCounter, 1)
								If Asc($Char) == 35 Or Asc($Char) == 39 Then
									$oMsg = $oMsg & Chr(39) & $oMsg & Chr(39) & ", "
								Else
									ContinueLoop
								EndIf
							Next
						EndIf

						If $uMsg <> "" Then
							$fMsg = $fMsg & "Username: " & $eMsg & @CRLF & $uMsg & @CRLF
						EndIf
						If $pMsg <> "" Then
							$fMsg = $fMsg & "Password: " & $eMsg & @CRLF & $pMsg & @CRLF
						EndIf
						If $cMsg <> "" Then
							$fMsg = $fMsg & "Clan: " & $eMsg & @CRLF & $cMsg & @CRLF
						EndIf
						If $oMsg <> "" Then
							$fMsg = $fMsg & "Other: " & $eMsg & @CRLF & $oMsg & @CRLF
						EndIf

						If $fMsg <> "" Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", $fMsg)
						ElseIf StringLen(GUICtrlRead($Add_Input1)) < 4 Or StringLen(GUICtrlRead($Add_Input2)) < 4 Then
							MsgBox(BitOR(4, 16, 0, 8192, 262144), "Error", "Hero's username and/or password is less than four characters long.")
						Else
							If GUICtrlRead($Add_Radio1) == $GUI_CHECKED Then
								_CreateHero(GUICtrlRead($Add_Input1), GUICtrlRead($Add_Input2), 0, $Level, $Clan, $Other)
							Else
								_CreateHero(GUICtrlRead($Add_Input1), GUICtrlRead($Add_Input2), 1, $Level, $Clan, $Other)
							EndIf
							GUISetState(@SW_HIDE, $Drag_Add)
						EndIf
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Add_Button2	;=============================
			;=============================================================
			GUISetState(@SW_HIDE, $Drag_Add)

			;=============================================================
		Case $nMsg[0] = $Add_Box3 	;=============================
			;=============================================================
			If GUICtrlRead($Add_Box3) == $GUI_CHECKED Then
				GUICtrlSetState($Add_Input3, $GUI_ENABLE)
			Else
				GUICtrlSetState($Add_Input3, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Add_Box4 	;=============================
			;=============================================================
			If GUICtrlRead($Add_Box4) == $GUI_CHECKED Then
				GUICtrlSetState($Add_Input4, $GUI_ENABLE)
			Else
				GUICtrlSetState($Add_Input4, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Add_Box5 	;=============================
			;=============================================================
			If GUICtrlRead($Add_Box5) == $GUI_CHECKED Then
				GUICtrlSetState($Add_Input5, $GUI_ENABLE)
			Else
				GUICtrlSetState($Add_Input5, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Hero_Button2	;=============================
			;=============================================================
			GUICtrlSetData($Mod_Input1, "")
			GUICtrlSetData($Mod_Input2, "")
			GUICtrlSetData($Mod_Input3, "")
			GUICtrlSetData($Mod_Input4, "")
			GUICtrlSetData($Mod_Input5, "1")
			GUICtrlSetData($Mod_Input6, "")
			GUICtrlSetData($Mod_Input7, "")
			
			If IniRead($IniFile, "Settings: Security", "Require Password", "") == 0 Then
				GUICtrlSetState($Mod_Input2, $GUI_ENABLE)
			Else
				GUICtrlSetState($Mod_Input2, $GUI_DISABLE)
			EndIf

			If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
				If _GUICtrlListViewGetCurSel($Hero_List1) <> -1 Then
					$Cur_Sel = _GUICtrlListViewGetItemText($Hero_List1, _GUICtrlListViewGetCurSel($Hero_List1))
					$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
					$Selection = 0
					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == $Cur_Sel Then
							$Selection = $iCounter
							ExitLoop
						EndIf
					Next

					GUICtrlSetData($Mod_Input1, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
					GUICtrlSetData($Mod_Input3, IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""))
					GUICtrlSetData($Mod_Input4, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
	
					GUICtrlSetData($Mod_Combo, "|")

					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
							GUICtrlSetData($Mod_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Cur_Sel)
						EndIf
					Next
					
					GUICtrlSetState($Mod_Radio1, $GUI_CHECKED)
					GUISetState(@SW_SHOW, $Drag_Mod)
					$Game_Var = "Hero"
				EndIf
			Else
				If _GUICtrlListViewGetCurSel($Hero_List2) <> -1 Then
					$Cur_Sel = _GUICtrlListViewGetItemText($Hero_List2, _GUICtrlListViewGetCurSel($Hero_List2))
					$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", 1)
					$Selection = 0
					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == $Cur_Sel Then
							$Selection = $iCounter
							ExitLoop
						EndIf
					Next

					GUICtrlSetData($Mod_Input1, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
					GUICtrlSetData($Mod_Input3, IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""))
					GUICtrlSetData($Mod_Input4, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))

					GUICtrlSetData($Mod_Combo, "|")

					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
							GUICtrlSetData($Mod_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Cur_Sel)
						EndIf
					Next
					
					GUICtrlSetState($Mod_Radio2, $GUI_CHECKED)
					GUISetState(@SW_SHOW, $Drag_Mod)
					$Game_Var = "Test"
				EndIf
			EndIf

			If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
				GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box3, $GUI_ENABLE)
				GUICtrlSetState($Mod_Input5, $GUI_DISABLE)	
				GUICtrlSetData($Mod_Input5, IniRead($IniFile, $Game_Var & ": " & $Cur_Sel, "Level", ""))
			Else
				GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box3, $GUI_DISABLE)
				GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
			EndIf
			If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
				GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box4, $GUI_ENABLE)
				GUICtrlSetState($Mod_Input6, $GUI_DISABLE)	
				GUICtrlSetData($Mod_Input6, IniRead($IniFile, $Game_Var & ": " & $Cur_Sel, "Clan", ""))						
			Else
				GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box4, $GUI_DISABLE)
				GUICtrlSetState($Mod_Input6, $GUI_DISABLE)
			EndIf
			If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
				GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box5, $GUI_ENABLE)
				GUICtrlSetState($Mod_Input7, $GUI_DISABLE)	
				GUICtrlSetData($Mod_Input7, IniRead($IniFile, $Game_Var & ": " & $Cur_Sel, "Other", ""))						
			Else
				GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box5, $GUI_DISABLE)
				GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Mod_Combo 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
				$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
				$Selection = 0
				For $iCounter = 1 To $CurrentNumber
					If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Mod_Combo) Then
						$Selection = $iCounter
						ExitLoop
					EndIf
				Next

				GUICtrlSetData($Mod_Input1, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
				GUICtrlSetData($Mod_Input3, IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""))
				GUICtrlSetData($Mod_Input4, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
				
				$Cur_Sel = IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")
				$Game_Var = "Hero"
			Else
				$Selection = 0
				$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", 1)
				For $iCounter = 1 To $CurrentNumber
					If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Mod_Combo) Then
						$Selection = $iCounter
						ExitLoop
					EndIf
				Next

				GUICtrlSetData($Mod_Input1, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
				GUICtrlSetData($Mod_Input3, IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""))
				GUICtrlSetData($Mod_Input4, _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))))
				
				$Cur_Sel = IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")
				$Game_Var = "Test"
			EndIf

			GUICtrlSetState($Mod_Radio1, $GUI_CHECKED)

			If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
				GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box3, $GUI_ENABLE)
				GUICtrlSetState($Mod_Input5, $GUI_DISABLE)	
				GUICtrlSetData($Mod_Input5, IniRead($IniFile, $Game_Var & ": " & $Cur_Sel, "Level", "1"))					
			Else
				GUICtrlSetState($Mod_Box3, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box3, $GUI_DISABLE)
				GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
			EndIf
			If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
				GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box4, $GUI_ENABLE)
				GUICtrlSetState($Mod_Input6, $GUI_DISABLE)	
				GUICtrlSetData($Mod_Input6, IniRead($IniFile, $Game_Var & ": " & $Cur_Sel, "Clan", ""))					
			Else
				GUICtrlSetState($Mod_Box4, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box4, $GUI_DISABLE)
				GUICtrlSetState($Mod_Input6, $GUI_DISABLE)
			EndIf
			If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
				GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box5, $GUI_ENABLE)
				GUICtrlSetState($Mod_Input7, $GUI_DISABLE)				
				GUICtrlSetData($Mod_Input7, IniRead($IniFile, $Game_Var & ": " & $Cur_Sel, "Other", ""))					
			Else
				GUICtrlSetState($Mod_Box5, $GUI_UNCHECKED)
				GUICtrlSetState($Mod_Box5, $GUI_DISABLE)
				GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Mod_Button1	;=============================
			;=============================================================
			$Flag = False
			If IniRead($IniFile, "Settings: Security", "Client Password", "") == 0 Then
				If IniRead($IniFile, "Settings: Security", "Require Password", "") == 0 Then
					$secPass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
					$curPass = GUICtrlRead($Mod_Input2)
					If $curPass == "" Then
						MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "The client's security feature is currently on " & @CRLF & @CRLF & "In order to modify a hero, you must enter the client's security password in the correct field.")
					ElseIf $secPass <> $curPass Then
						MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "You did not enter the correct security password for the client." & @CRLF & @CRLF & "No changes to your hero will be made.")
					Else
						$Flag = True
					EndIf
				Else
					$Flag = True
				EndIf
			Else
				$Flag = True
			EndIf

			$fMsg = "Modify Hero?" & @CRLF & "Hero: " & GUICtrlRead($Mod_Combo) & @CRLF

			If GUICtrlRead($Mod_Box1) == $GUI_CHECKED Then
				If GUICtrlRead($Mod_Input1) <> "" Then
					$fMsg = $fMsg & @CRLF & "Name: " & GUICtrlRead($Mod_Input1)
				EndIf
			EndIf

			If GUICtrlRead($Mod_Box2) == $GUI_CHECKED Then
				If GUICtrlRead($Mod_Input2) <> "" Then
					$fMsg = $fMsg & @CRLF & "Pass: " & GUICtrlRead($Mod_Input2)
				EndIf
			EndIf

			If GUICtrlRead($Mod_Box3) == $GUI_CHECKED Then
				If GUICtrlRead($Mod_Input3) <> "" Then
					$fMsg = $fMsg & @CRLF & "Level: " & GUICtrlRead($Mod_Input3)
				EndIf
			EndIf

			If GUICtrlRead($Mod_Box4) == $GUI_CHECKED Then
				If GUICtrlRead($Mod_Input4) <> "" Then
					$fMsg = $fMsg & @CRLF & "Clan: " & GUICtrlRead($Mod_Input4)
				EndIf
			EndIf

			If GUICtrlRead($Mod_Box5) == $GUI_CHECKED Then
				If GUICtrlRead($Mod_Input5) <> "" Then
					$fMsg = $fMsg & @CRLF & "Other: " & GUICtrlRead($Mod_Input5)
				EndIf
			EndIf

			If $Flag == True Then
				If GUICtrlRead($Mod_Combo) <> "Select Hero:" Then
					$MsgBox = MsgBox(BitOR(4, 32, 0, 4096, 262144), "Verify Information", $fMsg)

					If $MsgBox == 6 Then
						;==================================================
						;Contains Invalid Character & Length Error Checking
						;==================================================
						$eMsg = "The following characters are invalid"
						$fMsg = ""


						$uMsg = ""
						If GUICtrlRead($Mod_Box1) == $GUI_CHECKED Then
							$User = String(GUICtrlRead($Mod_Input3))
							For $iCounter = 1 To StringLen($User)
								$Char = StringMid($User, $iCounter, 1)
								If (Asc($Char) >= 48 And Asc($Char) <= 57) Or (Asc($Char) >= 65 And Asc($Char) <= 90) Or (Asc($Char) == 95) Or (Asc($Char) >= 97 And Asc($Char <= 122)) Then
									ContinueLoop
								Else
									$uMsg = $uMsg & Chr(39) & $Char & Chr(39) & ", "
								EndIf
							Next
						EndIf

						$pMsg = ""
						If GUICtrlRead($Mod_Box2) == $GUI_CHECKED Then
							$Pass = String(GUICtrlRead($Mod_Input4))
							For $iCounter = 1 To StringLen($Pass)
								$Char = StringMid($Pass, $iCounter, 1)
								If (Asc($Char) >= 48 And Asc($Char) <= 57) Or (Asc($Char) >= 65 And Asc($Char) <= 90) Or (Asc($Char) == 95) Or (Asc($Char) >= 97 And Asc($Char <= 122)) Then
									ContinueLoop
								Else
									$pMsg = $pMsg & Chr(39) & $Char & Chr(39) & ", "
								EndIf
							Next
						EndIf

						$lMsg = ""
						$Level = ""
						If GUICtrlRead($Mod_Box3) == $GUI_CHECKED Then
							$Level = String(GUICtrlRead($Mod_Input5))
							If $Level < 0 Then
								$Level = 1
							ElseIf $Level > 53 Then
								$Level = 1
							EndIf
						EndIf

						$cMsg = ""
						$Clan = ""
						If GUICtrlRead($Mod_Box4) == $GUI_CHECKED Then
							$Clan = String(GUICtrlRead($Mod_Input6))
							For $iCounter = 1 To StringLen($Clan)
								$Char = StringMid($Clan, $iCounter, 1)
								If Asc($Char) == 35 Or Asc($Char) == 39 Then
									$cMsg = $cMsg & Chr(39) & $Char & Chr(39) & ", "
								Else
									ContinueLoop
								EndIf
							Next
						EndIf

						$oMsg = ""
						$Other = ""
						If GUICtrlRead($Mod_Box5) == $GUI_CHECKED Then
							$Other = String(GUICtrlRead($Mod_Input7))
							For $iCounter = 1 To StringLen($Other)
								$Char = StringMid($Other, $iCounter, 1)
								If Asc($Char) == 35 Or Asc($Char) == 39 Then
									$oMsg = $oMsg & Chr(39) & $oMsg & Chr(39) & ", "
								Else
									ContinueLoop
								EndIf
							Next
						EndIf

						If $uMsg <> "" Then
							$fMsg = $fMsg & "Username: " & $eMsg & @CRLF & $uMsg & @CRLF
						EndIf
						If $pMsg <> "" Then
							$fMsg = $fMsg & "Password: " & $eMsg & @CRLF & $pMsg & @CRLF
						EndIf
						If $cMsg <> "" Then
							$fMsg = $fMsg & "Clan: " & $eMsg & @CRLF & $cMsg & @CRLF
						EndIf
						If $oMsg <> "" Then
							$fMsg = $fMsg & "Other: " & $eMsg & @CRLF & $oMsg & @CRLF
						EndIf

						If $fMsg <> "" Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", $fMsg)
						ElseIf (StringLen(GUICtrlRead($Mod_Input3)) < 4 And GUICtrlRead($Mod_Box1) == $GUI_CHECKED) Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "New username is less than four characters long.")
						ElseIf (StringLen(GUICtrlRead($Mod_Input4)) < 4 And GUICtrlRead($Mod_Box2) == $GUI_CHECKED) Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "New password is less than four characters long.")
						Else
							$Selection = 0
							$DeleteFlag = False

							For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", "")
								If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Mod_Combo) Then
									$Selection = $iCounter
									$Type = 0
									
									$uVal = IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")
									ExitLoop
								EndIf
							Next
							If $Selection = 0 Then
								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", "")
									If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Mod_Combo) Then
										$Selection = $iCounter
										$Type = 1
										
										$uVal = IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")
										ExitLoop
									EndIf
								Next
							EndIf
							
							;Modify the hero counts since there is movement
							If $Type == 0 And GUICtrlRead($Mod_Radio2) = $GUI_CHECKED Then ;Hero is Reg, Test is Checked

								IniWrite($IniFile, "Test Login", "Username: " & IniRead($IniFile, "Settings: Hero", "Test Count", "") + 1 & " ", GUICtrlRead($Mod_Input3))
								IniDelete($IniFile, "Hero Login", "Username: " & $Selection & " ")

								IniWrite($IniFile, "Test Login", "Password: " & IniRead($IniFile, "Settings: Hero", "Test Count", "") + 1 & " ", _StringEncrypt(1, GUICtrlRead($Mod_Input4), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Security", "Hero Encryption", 1)))
								IniDelete($IniFile, "Hero Login", "Password: " & $Selection & " ")

								If IniRead($IniFile, "Hero: " & $uVal, "Level", "") <> "" Then
									IniWrite($IniFile, "Test: " & $uVal, "Level", $Level)
									$DeleteFlag = True
								EndIf

								If IniRead($IniFile, "Hero: " & $uVal, "Clan", "") <> "" Then
									IniWrite($IniFile, "Test: " & $uVal, "Clan", $Clan)
									$DeleteFlag = True
								EndIf

								If IniRead($IniFile, "Hero: " & $uVal, "Other", "") <> "" Then
									IniWrite($IniFile, "Test: " & $uVal, "Other", $Other)
									$DeleteFlag = True
								EndIf
								
								If $DeleteFlag == True Then
									IniDelete($IniFile, "Hero: " & $uVal)
								EndIf								
								
								IniWrite($IniFile, "Settings: Hero", "Hero Count", IniRead($IniFile, "Settings: Hero", "Hero Count", "") - 1)
								IniWrite($IniFile, "Settings: Hero", "Test Count", IniRead($IniFile, "Settings: Hero", "Test Count", "") + 1)
							ElseIf $Type == 1 And GUICtrlRead($Mod_Radio1) = $GUI_CHECKED Then ;Hero is Test, Reg is Checked								
								IniWrite($IniFile, "Hero Login", "Username: " & IniRead($IniFile, "Settings: Hero", "Hero Count", "") + 1 & " ", GUICtrlRead($Mod_Input3))
								IniDelete($IniFile, "Test Login", "Username: " & $Selection & " ")
								
								IniWrite($IniFile, "Hero Login", "Password: " & IniRead($IniFile, "Settings: Hero", "Hero Count", "") + 1 & " ", _StringEncrypt(1, GUICtrlRead($Mod_Input4), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Security", "Hero Encryption", 1)))
								IniDelete($IniFile, "Test Login", "Password: " & $Selection & " ")

								If IniRead($IniFile, "Test: " & $uVal, "Level", "") <> "" Then
									IniWrite($IniFile, "Hero: " & $uVal, "Level", $Level)
									$DeleteFlag = True
								EndIf

								If IniRead($IniFile, "Test: " & $uVal, "Clan", "") <> "" Then
									IniWrite($IniFile, "Hero: " & $uVal, "Clan", $Clan)
									$DeleteFlag = True
								EndIf

								If IniRead($IniFile, "Test: " & $uVal, "Other", "") <> "" Then
									IniWrite($IniFile, "Hero: " & $uVal, "Other", $Other)
									$DeleteFlag = True
								EndIf
								
								If $DeleteFlag == True Then
									IniDelete($IniFile, "Test: " & $uVal)
								EndIf								
								
								IniWrite($IniFile, "Settings: Hero", "Test Count", IniRead($IniFile, "Settings: Hero", "Test Count", "") - 1)
								IniWrite($IniFile, "Settings: Hero", "Hero Count", IniRead($IniFile, "Settings: Hero", "Hero Count", "") + 1)
							Else ;Hero is either reg and reg is checked, or hero is test and test is checked
								If GUICtrlRead($Mod_Box1) == $GUI_CHECKED Then
									If GUICtrlRead($Mod_Radio1) = $GUI_CHECKED Then
										IniWrite($IniFile, "Hero Login", "Username: " & $Selection & " ", GUICtrlRead($Mod_Input3))
									Else
										IniWrite($IniFile, "Test Login", "Username: " & $Selection & " ", GUICtrlRead($Mod_Input3))
									EndIf
								EndIf
								If GUICtrlRead($Mod_Box2) == $GUI_CHECKED Then
									If GUICtrlRead($Mod_Radio1) = $GUI_CHECKED Then
										IniWrite($IniFile, "Hero Login", "Password: " & $Selection & " ", _StringEncrypt(1, GUICtrlRead($Mod_Input4), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Security", "Hero Encryption", 1)))
									Else
										IniWrite($IniFile, "Test Login", "Password: " & $Selection & " ", _StringEncrypt(1, GUICtrlRead($Mod_Input4), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Security", "Hero Encryption", 1)))
									EndIf
								EndIf
								If GUICtrlRead($Mod_Box3) == $GUI_CHECKED Then
									If GUICtrlRead($Mod_Radio1) = $GUI_CHECKED Then
										IniWrite($IniFile, "Hero: " & $uVal, "Level", $Level)
									Else
										IniWrite($IniFile, "Test: " & $uVal, "Level", $Level)
									EndIf
								EndIf
								If GUICtrlRead($Mod_Box4) == $GUI_CHECKED Then
									If GUICtrlRead($Mod_Radio1) = $GUI_CHECKED Then
										IniWrite($IniFile, "Hero: " & $uVal, "Clan", $Clan)
									Else
										IniWrite($IniFile, "Test: " & $uVal, "Clan", $Clan)
									EndIf
								EndIf
								If GUICtrlRead($Mod_Box5) == $GUI_CHECKED Then
									If GUICtrlRead($Mod_Radio1) = $GUI_CHECKED Then
										IniWrite($IniFile, "Hero: " & $uVal, "Other", $Other)
									Else
										IniWrite($IniFile, "Test: " & $uVal, "Other", $Other)
									EndIf
								EndIf								
							EndIf

							GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")

							If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
								_GUICtrlListViewDeleteAllItems($Hero_List1)

								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
									If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
										GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $HeroArray[0][0])
										GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
									EndIf
								Next
								GUISetState(@SW_HIDE, $Drag_Mod)
							Else
								_GUICtrlListViewDeleteAllItems($Hero_List2)
								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
									If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
										GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $TestArray[0][0])
										GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
									EndIf
								Next
								GUISetState(@SW_HIDE, $Drag_Mod)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Mod_Button2
			;=============================================================
			GUISetState(@SW_HIDE, $Drag_Mod)

			;=============================================================
		Case $nMsg[0] = $Mod_Box1 	;=============================
			;=============================================================
			If GUICtrlRead($Mod_Box1) == $GUI_CHECKED Then
				GUICtrlSetState($Mod_Input3, $GUI_ENABLE)
			Else
				GUICtrlSetState($Mod_Input3, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Mod_Box2 	;=============================
			;=============================================================
			If GUICtrlRead($Mod_Box2) == $GUI_CHECKED Then
				GUICtrlSetState($Mod_Input4, $GUI_ENABLE)
			Else
				GUICtrlSetState($Mod_Input4, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Mod_Box3 	;=============================
			;=============================================================
			If GUICtrlRead($Mod_Box3) == $GUI_CHECKED Then
				GUICtrlSetState($Mod_Input5, $GUI_ENABLE)
			Else
				GUICtrlSetState($Mod_Input5, $GUI_DISABLE)
			EndIf
			;=============================================================
		Case $nMsg[0] = $Mod_Box4 	;=============================
			;=============================================================
			If GUICtrlRead($Mod_Box4) == $GUI_CHECKED Then
				GUICtrlSetState($Mod_Input6, $GUI_ENABLE)
			Else
				GUICtrlSetState($Mod_Input6, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Mod_Box5 	;=============================
			;=============================================================
			If GUICtrlRead($Mod_Box5) == $GUI_CHECKED Then
				GUICtrlSetState($Mod_Input7, $GUI_ENABLE)
			Else
				GUICtrlSetState($Mod_Input7, $GUI_DISABLE)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Hero_Button3	;=============================
			;=============================================================
			GUICtrlSetData($Rem_Edit, "")

			If IniRead($IniFile, "Settings: Security", "Require Password", "") == 0 Then
				GUICtrlSetState($Rem_Input1, $GUI_ENABLE)
			Else
				GUICtrlSetState($Rem_Input1, $GUI_DISABLE)
			EndIf

			If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
				If _GUICtrlListViewGetCurSel($Hero_List1) <> -1 Then
					$Cur_Sel = _GUICtrlListViewGetItemText($Hero_List1, _GUICtrlListViewGetCurSel($Hero_List1))
					$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Hero Count", "")

					$Selection = 0
					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == $Cur_Sel Then
							$Selection = $iCounter
							ExitLoop
						EndIf
					Next

					GUICtrlSetData($Rem_Combo, "|")

					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
							GUICtrlSetData($Rem_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Cur_Sel)
						EndIf
					Next

					$fMsg = "Name: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "") & @CRLF
					$fMsg = $fMsg & "Password: " & _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))) & @CRLF

					If IniRead($IniFile, "Hero: " & $Cur_Sel, "Last Login", "") <> "" Then
						$fMsg = $fMsg & "Last Login: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Last Login", "") & @CRLF
					EndIf
					If IniRead($IniFile, "Hero: " & $Cur_Sel, "Level", "") <> "" Then
						$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Level", "") & @CRLF
					EndIf
					If IniRead($IniFile, "Hero: " & $Cur_Sel, "Clan", "") <> "" Then
						$fMsg = $fMsg & "Clan: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Clan", "") & @CRLF
					EndIf
					If IniRead($IniFile, "Hero: " & $Cur_Sel, "Other", "") <> "" Then
						$fMsg = $fMsg & "Other: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Other", "")
					EndIf

					GUICtrlSetData($Rem_Edit, $fMsg)
					GUISetState(@SW_SHOW, $Drag_Rem)
				EndIf
			Else
				If _GUICtrlListViewGetCurSel($Hero_List2) <> -1 Then
					$Cur_Sel = _GUICtrlListViewGetItemText($Hero_List2, _GUICtrlListViewGetCurSel($Hero_List2))
					$CurrentNumber = IniRead($IniFile, "Settings: Hero", "Test Count", "")

					$Selection = 0
					For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
						If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == $Cur_Sel Then
							$Selection = $iCounter
							ExitLoop
						EndIf
					Next

					GUICtrlSetData($Rem_Combo, "|")

					For $iCounter = 1 To $CurrentNumber
						If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
							GUICtrlSetData($Rem_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Cur_Sel)
						EndIf
					Next

					$fMsg = "Name: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "") & @CRLF
					$fMsg = $fMsg & "Password: " & _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))) & @CRLF

					If IniRead($IniFile, "Test: " & $Cur_Sel, "Last Login", "") <> "" Then
						$fMsg = $fMsg & "Last Login: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Last Login", "") & @CRLF
					EndIf
					If IniRead($IniFile, "Test: " & $Cur_Sel, "Level", "") <> "" Then
						$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Level", "") & @CRLF
					EndIf
					If IniRead($IniFile, "Test: " & $Cur_Sel, "Clan", "") <> "" Then
						$fMsg = $fMsg & "Clan: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Clan", "") & @CRLF
					EndIf
					If IniRead($IniFile, "Test: " & $Cur_Sel, "Other", "") <> "" Then
						$fMsg = $fMsg & "Other: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Other", "")
					EndIf

					GUICtrlSetData($Rem_Edit, $fMsg)
					GUISetState(@SW_SHOW, $Drag_Rem)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Rem_Combo 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
				$Selection = 0
				For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
					If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Rem_Combo) Then
						$Selection = $iCounter
						ExitLoop
					EndIf
				Next
				$Cur_Sel = IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")

				$fMsg = "Name: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "") & @CRLF
				$fMsg = $fMsg & "Password: " & _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Hero Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))) & @CRLF

				If IniRead($IniFile, "Hero: " & $Cur_Sel, "Last Login", "") <> "" Then
					$fMsg = $fMsg & "Last Login: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Last Login", "") & @CRLF
				EndIf
				If IniRead($IniFile, "Hero: " & $Cur_Sel, "Level", "") <> "" Then
					$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Level", "") & @CRLF
				EndIf
				If IniRead($IniFile, "Hero: " & $Cur_Sel, "Clan", "") <> "" Then
					$fMsg = $fMsg & "Clan: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Clan", "") & @CRLF
				EndIf
				If IniRead($IniFile, "Hero: " & $Cur_Sel, "Other", "") <> "" Then
					$fMsg = $fMsg & "Other: " & IniRead($IniFile, "Hero: " & $Cur_Sel, "Other", "")
				EndIf

				GUICtrlSetData($Rem_Edit, $fMsg)
			Else
				$Selection = 0
				For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
					If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Rem_Combo) Then
						$Selection = $iCounter
						ExitLoop
					EndIf
				Next
				$Cur_Sel = IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")

				$fMsg = "Name: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "") & @CRLF
				$fMsg = $fMsg & "Password: " & _ShowAndHidePasswords(_StringEncrypt(0, IniRead($IniFile, "Test Login", "Password: " & $Selection & " ", ""), _StringToHex(IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", ""))) & @CRLF

				If IniRead($IniFile, "Test: " & $Cur_Sel, "Last Login", "") <> "" Then
					$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Last Login: " & $Cur_Sel, "Last Login", "") & @CRLF
				EndIf
				If IniRead($IniFile, "Test: " & $Cur_Sel, "Level", "") <> "" Then
					$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Level", "") & @CRLF
				EndIf
				If IniRead($IniFile, "Test: " & $Cur_Sel, "Clan", "") <> "" Then
					$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Clan", "") & @CRLF
				EndIf
				If IniRead($IniFile, "Test: " & $Cur_Sel, "Other", "") <> "" Then
					$fMsg = $fMsg & "Level: " & IniRead($IniFile, "Test: " & $Cur_Sel, "Other", "")
				EndIf

				GUICtrlSetData($Rem_Edit, $fMsg)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Rem_Button1	;=============================
			;=============================================================

			If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
				$Selection = 0
				For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
					If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Rem_Combo) Then
						$Selection = $iCounter
						ExitLoop
					EndIf
				Next
				$Cur_Sel = IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")

				$Flag = True
				If IniRead($IniFile, "Settings: Security", "Client Password", "") == 0 Then
					If IniRead($IniFile, "Settings: Security", "Require Password", "") == 0 Then
						$secPass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
						$curPass = GUICtrlRead($Rem_Input1)
						If $curPass == "" Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "The client's security feature is currently on " & @CRLF & @CRLF & "In order to remove a hero, you must enter the client's security password in the correct field.")
							$Flag = False
						ElseIf $secPass <> $curPass Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "You did not enter the correct security password for the client." & @CRLF & @CRLF & "No changes to your hero will be made.")
							$Flag = False
						EndIf
					EndIf
				EndIf

				$fMsg = "Remove Hero?" & @CRLF & @CRLF & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", "")

				If $Flag == True Then
					If GUICtrlRead($Rem_Combo) <> "Select Hero:" Then
						$MsgBox = MsgBox(BitOR(4, 32, 0, 4096, 262144), "Verify Information", $fMsg)
						If $MsgBox == 6 Then
							If IniRead($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Last Login", "") <> "" Then
								IniDelete($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Last Login")
							EndIf
							If IniRead($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Level", "") <> "" Then
								IniDelete($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Level")
							EndIf
							If IniRead($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Clan", "") <> "" Then
								IniDelete($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Clan")
							EndIf
							If IniRead($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Other", "") <> "" Then
								IniDelete($IniFile, "Hero: " & IniRead($IniFile, "Hero Login", "Username: " & $Selection & " ", ""), "Other")
							EndIf								
							
							For $iCounter = $Selection To IniRead($IniFile, "Settings: Hero", "Hero Count", "1")
								If $iCounter == IniRead($IniFile, "Settings: Hero", "Hero Count", "1") Then									
									IniDelete($IniFile, "Hero Login", "Username: " & $iCounter & " ")
									IniDelete($IniFile, "Hero Login", "Password: " & $iCounter & " ")								
								Else
									IniWrite($IniFile, "Hero Login", "Username: " & $iCounter & " ", IniRead($IniFile, "Hero Login", "Username: " & $iCounter + 1 & " ", ""))
									IniWrite($IniFile, "Hero Login", "Password: " & $iCounter & " ", IniRead($IniFile, "Hero Login", "Password: " & $iCounter + 1 & " ", ""))
									IniDelete($IniFile, "Hero Login", "Username: " & $iCounter+1 & " ")
									IniDelete($IniFile, "Hero Login", "Password: " & $iCounter+1 & " ")
								EndIf
							Next

							IniWrite($IniFile, "Settings: Hero", "Hero Count", $iCounter - 2)

							GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")

							If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
								_GUICtrlListViewDeleteAllItems($Hero_List1)

								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
									If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
										GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $HeroArray[0][0])
										GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
									EndIf
								Next
								GUISetState(@SW_HIDE, $Drag_Rem)
							Else
								_GUICtrlListViewDeleteAllItems($Hero_List2)
								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
									If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
										GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $TestArray[0][0])
										GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
									EndIf
								Next
								GUISetState(@SW_HIDE, $Drag_Rem)
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				$Selection = 0
				For $iCounter = 1 To IniRead($IniFile, "Settings: Test", "Test Count", 1)
					If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") == GUICtrlRead($Rem_Combo) Then
						$Selection = $iCounter
						ExitLoop
					EndIf
				Next
				$Cur_Sel = IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")

				$Flag = True
				If IniRead($IniFile, "Settings: Security", "Client Password", "") == 0 Then
					If IniRead($IniFile, "Settings: Security", "Require Password", "") == 0 Then
						$secPass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
						$curPass = GUICtrlRead($Rem_Input1)
						If $curPass == "" Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "The client's security feature is currently on " & @CRLF & @CRLF & "In order to remove a hero, you must enter the client's security password in the correct field.")
							$Flag = False
						ElseIf $secPass <> $curPass Then
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "You did not enter the correct security password for the client." & @CRLF & @CRLF & "No changes to your hero will be made.")
							$Flag = False
						EndIf
					EndIf
				EndIf

				$fMsg = "Remove Hero?" & @CRLF & @CRLF & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", "")

				If $Flag == True Then
					If GUICtrlRead($Rem_Combo) <> "Select Hero:" Then
						$MsgBox = MsgBox(BitOR(4, 32, 0, 4096, 262144), "Verify Information", $fMsg)

						If $MsgBox == 6 Then
							If IniRead($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Last Login", "") <> "" Then
								IniDelete($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Last Login")
							EndIf
							If IniRead($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Level", "") <> "" Then
								IniDelete($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Level")
							EndIf
							If IniRead($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Clan", "") <> "" Then
								IniDelete($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Clan")
							EndIf
							If IniRead($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Other", "") <> "" Then
								IniDelete($IniFile, "Test: " & IniRead($IniFile, "Test Login", "Username: " & $Selection & " ", ""), "Other")
							EndIf	
							
							For $iCounter = $Selection To IniRead($IniFile, "Settings: Hero", "Test Count", "1")
								If $iCounter == IniRead($IniFile, "Settings: Hero", "Test Count", "1") Then
									IniDelete($IniFile, "Test Login", "Username: " & $iCounter & " ")
									IniDelete($IniFile, "Test Login", "Password: " & $iCounter & " ")
								Else	
									IniWrite($IniFile, "Test Login", "Username: " & $iCounter & " ", IniRead($IniFile, "Test Login", "Username: " & $iCounter + 1 & " ", ""))
									IniWrite($IniFile, "Test Login", "Password: " & $iCounter & " ", IniRead($IniFile, "Test Login", "Password: " & $iCounter + 1 & " ", ""))
									IniDelete($IniFile, "Test Login", "Username: " & $iCounter+1 & " ")
									IniDelete($IniFile, "Test Login", "Password: " & $iCounter+1 & " ")
								EndIf
							Next

							IniWrite($IniFile, "Settings: Hero", "Test Count", $iCounter - 2)

							GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")

							If IniRead($IniFile, "Settings: Client", "Game Type", "") == 0 Then
								_GUICtrlListViewDeleteAllItems($Hero_List1)

								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
									If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
										GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $HeroArray[0][0])
										GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
									EndIf
								Next
								GUISetState(@SW_HIDE, $Drag_Rem)
							Else
								_GUICtrlListViewDeleteAllItems($Hero_List2)
								For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
									If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
										GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $TestArray[0][0])
										GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
									EndIf
								Next
								GUISetState(@SW_HIDE, $Drag_Rem)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Rem_Button2
			;=============================================================
			GUISetState(@SW_HIDE, $Drag_Rem)

			;=============================================================
		Case $nMsg[0] = $Security_Radio1;=============================
			;=============================================================
			If GUICtrlRead($Security_Radio1) == $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Security", "Client Password", "") <> 0 Then
					IniWrite($IniFile, "Settings: Security", "Client Password", 0)

					GUICtrlSetState($Security_Input1, $GUI_ENABLE)

					If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
						MsgBox(BitOR(0, 64, 0, 4096, 262144), "Security Password", "You have enabled the client's security feature," & "which will help protect the client and your passwords from sneaky bastards." & @CRLF & @CRLF & "Please enter a password " & "to protect the client with. (Caution: entering a password will save it for future use - so remember it)")
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Security_Radio2;=============================
			;=============================================================
			If GUICtrlRead($Security_Radio2) == $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Security", "Client Password", "") <> 1 Then
					If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
						IniWrite($IniFile, "Settings: Security", "Client Password", 1)
						GUICtrlSetState($Security_Input1, $GUI_DISABLE)
						GUICtrlSetState($Security_Button1, $GUI_DISABLE)

						GUICtrlSetState($Security_Group3, $GUI_DISABLE)
						GUICtrlSetState($Security_Radio3, $GUI_DISABLE)
						GUICtrlSetState($Security_Radio4, $GUI_DISABLE)
						GUICtrlSetState($Security_Group4, $GUI_DISABLE)
						GUICtrlSetState($Security_Radio5, $GUI_DISABLE)
						GUICtrlSetState($Security_Radio6, $GUI_DISABLE)
						GUICtrlSetState($Security_Group5, $GUI_DISABLE)
						GUICtrlSetState($Security_Input2, $GUI_DISABLE)
						GUICtrlSetState($Security_Input3, $GUI_DISABLE)
						GUICtrlSetState($Security_Button2, $GUI_DISABLE)
					Else
						If GUICtrlRead($Security_Input1) == "" Then
							$MsgBox = MsgBox(BitOR(0, 16, 0, 4096, 262144), "Security Password", "The client's security feature is currently on. In order to turn off the security system, please enter the correct security password.")
							GUICtrlSetState($Security_Radio1, $GUI_CHECKED)
							ControlFocus($Drag_Security, "", $Security_Input1)
						Else
							$curPass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
							$newPass = GUICtrlRead($Security_Input1)

							If $curPass = $newPass Or $curPass = "" Then
								IniWrite($IniFile, "Settings: Security", "Security Password", _StringEncrypt(1, GUICtrlRead($Security_Input1), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1)))
								TrayTip("Success!", "You entered the correct security password", 3)

								IniWrite($IniFile, "Settings: Security", "Client Password", 1)
								GUICtrlSetState($Security_Input1, $GUI_DISABLE)
								GUICtrlSetState($Security_Button1, $GUI_DISABLE)

								GUICtrlSetState($Security_Group3, $GUI_DISABLE)
								GUICtrlSetState($Security_Radio3, $GUI_DISABLE)
								GUICtrlSetState($Security_Radio4, $GUI_DISABLE)
								GUICtrlSetState($Security_Group4, $GUI_DISABLE)
								GUICtrlSetState($Security_Radio5, $GUI_DISABLE)
								GUICtrlSetState($Security_Radio6, $GUI_DISABLE)
								GUICtrlSetState($Security_Group5, $GUI_DISABLE)
								GUICtrlSetState($Security_Input2, $GUI_DISABLE)
								GUICtrlSetState($Security_Input3, $GUI_DISABLE)
								GUICtrlSetState($Security_Button2, $GUI_DISABLE)
							Else
								$MsgBox = MsgBox(BitOR(4, 16, 0, 8192, 262144), "Error", "You did not enter the correct security password." & @CRLF & @CRLF & "Try Again?")

								If $MsgBox = 6 Then
									ControlFocus($Drag_Security, "", $Security_Input1)
								Else
									TrayTip("Failure!", "You did not enter the correct security password", 3)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Security_Button1;============================
			;=============================================================
			If IniRead($IniFile, "Settings: Security", "Client Password", "") == 0 Then
				If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
					If StringLen(GUICtrlRead($Security_Input1)) < 4 Then
						MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "Client's security password is less than four characters long.")
					Else
						$oMsg = ""
						$Client = String(GUICtrlRead($Security_Input1))
						For $iCounter = 1 To StringLen($Client)
							$Char = StringMid($Client, $iCounter, 1)
							If Asc($Char) == 35 Or Asc($Char) == 39 Then
								$oMsg = $oMsg & Chr(39) & $oMsg & Chr(39) & ", "
							Else
								ContinueLoop
							EndIf
						Next
						If $oMsg <> "" Then
							$cMsg = "Other: " & "The following characters are invalid" & @CRLF & $oMsg & @CRLF
							MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", $cMsg)
						Else
							MsgBox(BitOR(0, 48, 0, 4096, 262144), "Security Password", "The client's security password has been saved as " & GUICtrlRead($Security_Input1) & "." & @CRLF & @CRLF & "Please remember the password, as you will not be able to recover it should the password be lost.")
							IniWrite($IniFile, "Settings: Security", "Security Password", _StringEncrypt(1, GUICtrlRead($Security_Input1), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1)))

							GUICtrlSetData($Security_Button1, "Enter")
							GUICtrlSetState($Security_Group3, $GUI_ENABLE)
							GUICtrlSetState($Security_Group1, $GUI_ENABLE)
							GUICtrlSetState($Security_Radio1, $GUI_ENABLE)
							GUICtrlSetState($Security_Radio2, $GUI_ENABLE)
							GUICtrlSetState($Security_Radio3, $GUI_ENABLE)
							GUICtrlSetState($Security_Radio4, $GUI_ENABLE)
							GUICtrlSetState($Security_Group4, $GUI_ENABLE)
							GUICtrlSetState($Security_Radio5, $GUI_ENABLE)
							GUICtrlSetState($Security_Radio6, $GUI_ENABLE)
							GUICtrlSetState($Security_Group5, $GUI_ENABLE)
							GUICtrlSetState($Security_Input2, $GUI_ENABLE)
							GUICtrlSetState($Security_Input3, $GUI_ENABLE)
							GUICtrlSetState($Security_Button1, $GUI_ENABLE)
							GUICtrlSetState($Security_Button2, $GUI_ENABLE)

							GUICtrlSendMsg($Security_Input1, $EM_SETPASSWORDCHAR, 42, 0)
							ControlFocus($Drag_Security, "", $Security_Input1)
						EndIf
					EndIf
				Else
					$Pass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
					$User = GUICtrlRead($Security_Input1)

					If $Pass <> $User Then
						MsgBox(BitOR(0, 16, 0, 8192, 262144), "Error", "You entered the wrong security password!")
					Else
						GUICtrlSetState($Security_Group3, $GUI_ENABLE)
						GUICtrlSetState($Security_Group1, $GUI_ENABLE)
						GUICtrlSetState($Security_Radio1, $GUI_ENABLE)
						GUICtrlSetState($Security_Radio2, $GUI_ENABLE)
						GUICtrlSetState($Security_Radio3, $GUI_ENABLE)
						GUICtrlSetState($Security_Radio4, $GUI_ENABLE)
						GUICtrlSetState($Security_Group4, $GUI_ENABLE)
						GUICtrlSetState($Security_Radio5, $GUI_ENABLE)
						GUICtrlSetState($Security_Radio6, $GUI_ENABLE)
						GUICtrlSetState($Security_Group5, $GUI_ENABLE)
						GUICtrlSetState($Security_Input2, $GUI_ENABLE)
						GUICtrlSetState($Security_Input3, $GUI_ENABLE)
						GUICtrlSetState($Security_Button1, $GUI_ENABLE)
						GUICtrlSetState($Security_Button2, $GUI_ENABLE)

						GUICtrlSendMsg($Security_Input1, $EM_SETPASSWORDCHAR, 42, 0)
						ControlFocus($Drag_Security, "", $Security_Input1)
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Security_Radio3;=============================
			;=============================================================
			If GUICtrlRead($Security_Radio3) == $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Security", "Show Password", "") <> 0 Then
					IniWrite($IniFile, "Settings: Security", "Show Password", 0)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Security_Radio4;=============================
			;=============================================================
			If GUICtrlRead($Security_Radio4) == $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Security", "Show Password", "") <> 1 Then
					If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
						IniWrite($IniFile, "Settings: Security", "Show Password", 1)
						GUICtrlSetStyle($Mod_Input1, "", "")
						GUICtrlSetStyle($Mod_Input2, "", "")
					Else
						If GUICtrlRead($Security_Input1) == "" Then
							$MsgBox = MsgBox(BitOR(0, 64, 0, 4096, 262144), "Security Password", "The client's security feature is currently on. In order to turn off the security system, please enter the correct security password.")
							GUICtrlSetState($Security_Radio3, $GUI_CHECKED)
							ControlFocus($Drag_Security, "", $Security_Input1)
						Else
							$curPass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
							$newPass = GUICtrlRead($Security_Input1)

							If $curPass = $newPass Or $curPass = "" Then
								IniWrite($IniFile, "Settings: Security", "Show Password", 1)
								;_ShowAndHidePasswords(1)
								GUICtrlSetStyle($Mod_Input1, "", "")
								GUICtrlSetStyle($Mod_Input2, "", "")
							Else
								$MsgBox = MsgBox(BitOR(4, 16, 0, 8192, 262144), "Error", "You did not enter the correct security password." & @CRLF & @CRLF & "Try Again?")
								
								GUICtrlSetState($Security_Radio3, $GUI_CHECKED)
								If $MsgBox = 6 Then
									ControlFocus($Drag_Security, "", $Security_Input1)
								Else
									TrayTip("Failure!", "You did not enter the correct security password", 3)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Security_Radio5;=============================
			;=============================================================
			If GUICtrlRead($Security_Radio5) == $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Security", "Require Password", "") <> 0 Then
					IniWrite($IniFile, "Settings: Security", "Require Password", 0)
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Security_Radio6;=============================
			;=============================================================
			If GUICtrlRead($Security_Radio6) == $GUI_CHECKED Then
				If IniRead($IniFile, "Settings: Security", "Require Password", "") <> 1 Then
					If IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
						IniWrite($IniFile, "Settings: Security", "Require Password", 1)
					Else
						If GUICtrlRead($Security_Input1) == "" Then
							$MsgBox = MsgBox(BitOR(0, 64, 0, 4096, 262144), "Security Password", "The client's security feature is currently on. In order to turn off the security system, please enter the correct security password.")
							GUICtrlSetState($Security_Radio5, $GUI_CHECKED)
							ControlFocus($Drag_Security, "", $Security_Input1)
						Else
							$curPass = _StringEncrypt(0, IniRead($IniFile, "Settings: Security", "Security Password", ""), $IniFile, IniRead($IniFile, "Settings: Security", "Client Encryption", 1))
							$newPass = GUICtrlRead($Security_Input1)

							If $curPass = $newPass Or $curPass = "" Then
								IniWrite($IniFile, "Settings: Security", "Require Password", 1)
								;_RequirePassword(1)
							Else
								$MsgBox = MsgBox(BitOR(4, 16, 0, 8192, 262144), "Error", "You did not enter the correct security password." & @CRLF & @CRLF & "Try Again?")

								GUICtrlSetState($Security_Radio5, $GUI_CHECKED)
								If $MsgBox = 6 Then
									ControlFocus($Drag_Security, "", $Security_Input1)
								Else
									TrayTip("Failure!", "You did not enter the correct security password", 3)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Link1 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", "") == 0 Then
				$Link_oIE = _IECreate("                                          ", 1, 1, 0)
				WinMove($Link_oIE, "", 0, 0, @DesktopWidth / 3, @DesktopHeight / 2)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Link2 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", "") == 0 Then
				$Link_oIE = _IECreate("                                              ", 1, 1, 0)
				WinMove($Link_oIE, "", 0, 0, @DesktopWidth / 3, @DesktopHeight / 2)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Link3 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", "") == 0 Then
				$Link_oIE = _IECreate("                                              ", 1, 1, 0)
				WinMove($Link_oIE, "", 0, 0, @DesktopWidth / 3, @DesktopHeight / 2)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Link4 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", "") == 0 Then
				$Link_oIE = _IECreate("                                               ", 1, 1, 0)
				WinMove($Link_oIE, "", 0, 0, @DesktopWidth / 3, @DesktopHeight / 2)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Link5 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", "") == 0 Then
				$Link_oIE = _IECreate("                       ", 1, 1, 0)
				WinMove($Link_oIE, "", 0, 0, @DesktopWidth / 3, @DesktopHeight / 2)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Drag_Link6 	;=============================
			;=============================================================
			If IniRead($IniFile, "Settings: Client", "Open Links", "") == 0 Then
				$Link_oIE = _IECreate("                                              ", 1, 1, 0)
				WinMove($Link_oIE, "", 0, 0, @DesktopWidth / 3, @DesktopHeight / 2)
			EndIf

			;=============================================================
		Case $nMsg[0] = $Link_Combo 	;=============================
			;=============================================================
			$Selection = 0
			For $iCounter = 1 To UBound($NameToLink) - 1
				If GUICtrlRead($Link_Combo) == $NameToLink[$iCounter] Then
					$Selection = $iCounter
					ExitLoop
				EndIf
			Next
			_IENavigate($Link_IE, $LinkToName[$Selection], 0)
			;=============================================================
		Case $nMsg[0] = $Hero_List1;=============================
			;=============================================================

	EndSelect

	;Disabled due to the fact it does not support multiple GUIs
	;_ProcessHover()
WEnd

If IniRead($IniFile, "Settings: Security", "Client Password", "") == 0 And IniRead($IniFile, "Settings: Security", "Security Password", "") == "" Then
	IniWrite($IniFile, "Settings: Security", "Client Password", 1)
EndIf

IniDelete($IniFile, "Dragon Court Client", "Has Loaded")
GUIDelete($Drag_GUI)
GUIDelete($Drag_Client)
GUIDelete($Drag_Hero)
GUIDelete($Drag_Security)
GUIDelete($Drag_View)
GUIDelete($Drag_Info)
GUIDelete($Drag_Link)
GUIDelete($Drag_Add)
GUIDelete($Drag_Mod)
GUIDelete($Drag_Rem)
Exit

;======================================================
;=Client Functions=====================================
;======================================================
Func _CreateHero($uVal, $pVal, $gVal, $lVal, $cVal, $oVal)
	$CurrentNumber = 1

	If $gVal == 0 Then
		$Game_Var = "Hero"
	Else
		$Game_Var = "Test"
	EndIf

	For $iCounter = 1 To 1000
		If IniRead($IniFile, $Game_Var & " Login", "Username: " & $iCounter & " ", "Stop") == "Stop" Then
			$CurrentNumber = $iCounter
			ExitLoop
		EndIf
	Next

	If $gVal == 0 Then
		Dim $HeroArray[$CurrentNumber][2]
	Else
		Dim $TestArray[$CurrentNumber][2]
	EndIf
	
	$iCounter = $CurrentNumber - 1
	IniWrite($IniFile, "Settings: Hero", $Game_Var & " Count", $CurrentNumber)
	IniWrite($IniFile, $Game_Var & " Login", "Username: " & $CurrentNumber & " ", $uVal)
	IniWrite($IniFile, $Game_Var & " Login", "Password: " & $CurrentNumber & " ", _StringEncrypt(1, $pVal, _StringToHex(IniRead($IniFile, $Game_Var & " Login", "Username: " & $CurrentNumber & " ", "")), IniRead($IniFile, "Settings: Security", "Hero Encryption", "")))

	If IniRead($IniFile, "Settings: Hero", "Save Level", "") == 1 Then
		If $lval <> "" Then
			IniWrite($IniFile, $Game_Var & ": " & $uVal, "Level", $lVal)
		EndIf
	EndIf
	If IniRead($IniFile, "Settings: Hero", "Save Clan", "") == 1 Then
		If $cVal <> "" Then
			IniWrite($IniFile, $Game_Var & ": " & $uVal, "Clan", $cVal)
		EndIf
	EndIf
	If IniRead($IniFile, "Settings: Hero", "Save Other", "") == 1 Then
		If $oVal <> "" Then
			IniWrite($IniFile, $Game_Var & ": " & $uVal, "Other", $oVal)
		EndIf
	EndIf

	GUICtrlSetData($Drag_Combo, "|" & "Select Hero:", "Select Hero:")
	If $gVal == 0 Then
		_GUICtrlListViewDeleteAllItems($Hero_List1)
		For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Hero Count", 1)
			If IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", "") <> "" Then
				GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $HeroArray[0][0])
				GUICtrlCreateListViewItem(IniRead($IniFile, "Hero Login", "Username: " & $iCounter & " ", ""), $Hero_List1)
			EndIf
		Next
	Else
		_GUICtrlListViewDeleteAllItems($Hero_List2)
		For $iCounter = 1 To IniRead($IniFile, "Settings: Hero", "Test Count", 1)
			If IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", "") <> "" Then
				GUICtrlSetData($Drag_Combo, IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $TestArray[0][0])
				GUICtrlCreateListViewItem(IniRead($IniFile, "Test Login", "Username: " & $iCounter & " ", ""), $Hero_List2)
			EndIf
		Next
	EndIf
	Return 1
EndFunc   ;==>_CreateHero

Func _ShowAndHideWin($Var)
	If $Var == 0 Or $Var == 1 Then
		WinSetOnTop($Drag_Client, "", $Var)
		WinSetOnTop($Drag_Hero, "", $Var)
		WinSetOnTop($Drag_Security, "", $Var)
		WinSetOnTop($Drag_View, "", $Var)
		WinSetOnTop($Drag_Info, "", $Var)
		WinSetOnTop($Drag_Link, "", $Var)
		WinSetOnTop($Drag_Add, "", $Var)
		WinSetOnTop($Drag_Mod, "", $Var)
		WinSetOnTop($Drag_Rem, "", $Var)
		WinSetOnTop($Drag_GUI, "", $Var)
	Else
		MsgBox(0, "_ShowAndHideWin()", "Invalid $Var: " & $Var)
	EndIf
EndFunc   ;==>_ShowAndHideWin

Func _ShowAndHidePasswords($Str)
	If IniRead($IniFile, "Settings: Security", "Show Password", "") == 0 Then
		$Len = StringLen($Str)
		$Spoof = ""
		For $iCounter = 0 To $Len - 1
			$Spoof = $Spoof & "*"
		Next

		Return $Spoof
	Else
		Return $Str
	EndIf
EndFunc   ;==>_ShowAndHidePasswords

Func _TabPatch()
	If WinActive("Dragon Court", "") Then
	EndIf
EndFunc   ;==>_TabPatch

Func _Countdown()
	$TimeLeft = $StartTime - TimerDiff($_Countdown)
	If $TimeLeft > 0 Then
		_TicksToTime(Int($TimeLeft), $Hour, $Mins, $Secs)
		Local $sTime = $Time
		$Time = StringFormat("%2ih %02im %02is", $Hour, $Mins, $Secs)
		If $sTime <> $Time Then
			GUICtrlSetData($Drag_Label, "Time Until Quest Refresh: " & $Time)
		EndIf
	EndIf
EndFunc   ;==>_Countdown

Func _MouseOverMenu($hWndGUI, $MsgID, $WParam, $LParam)
	Local $id = BitAND($WParam, 0xFFFF)

	For $x = 0 To UBound($aCtrlArray) - 1
		If $id = ($aCtrlArray[$x]) Then
			GUICtrlSetData($Drag_Status, $aCtrlMsgArray[$x])
			ExitLoop
		EndIf
	Next
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_MouseOverMenu

Func _AddCtrl($ControlID, $ControlMsg)
	_ArrayAdd($aCtrlArray, $ControlID)
	_ArrayAdd($aCtrlMsgArray, $ControlMsg)
EndFunc   ;==>_AddCtrl

#cs
	Func _ProcessHover()
	$ctrlid = _HoverCheck()
	If IsArray($ctrlid) Then
	If $ctrlid[0] = "AcquiredHover" Then
	_HoverFound($ctrlid[1])
	Else
	_HoverLost($ctrlid[1])
	EndIf
	EndIf
	EndFunc

	Func _HoverFound($ControlID)
	Switch $ControlID
	Case $Drag_Label
	GUICtrlSetData($Drag_Status, "This is how long you have until the next quest refresh.")
	EndSwitch
	EndFunc

	Func _HoverLost($ControlID)
	Switch $ControlID
	Case $Drag_Label
	GUICtrlSetData($Drag_Status, "")
	EndSwitch
	EndFunc
#ce