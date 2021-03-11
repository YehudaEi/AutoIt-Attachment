#include <GUIConstantsEx.au3>
#include <GuiConstants.au3>
#include <Array.au3>
#include <String.au3>
#include "ModernSplash2.au3"
#include <misc.au3>
#include <EditConstants.au3>
#include <GuiListBox.au3>
#include <ie.au3>

If _Singleton("WebSite login",1) = 0 then
 MsgBox(0, "Warning", "An occurence of WebSite login is already running")
Exit
EndIf
Opt("GUICoordMode", 1)
Global $Cm2_Saved, $In2_ServerIP, $In2_Name, $In2_Userfile, $In2_PWDFile, $BS_DEFPUSHBUTTON, $In_Name, $count, $Items_Length, $countsaved, $d

$ip = ""
$appName = "WebSite login"
$iniFile = (@ScriptDir & "\webinfo.ini")
$AddName = " Add / Edit / Remove"


$Mgui1=GuiCreate($appName, 340, 400)
GuiCtrlCreateLabel("Saved Connections", 10, 10)
GuiCtrlCreateLabel("Name:", 10, 60)
GuiCtrlCreateLabel("Device Ip Info:", 10, 110)
GuiCtrlCreateLabel("Username", 10, 160)
GuiCtrlCreateLabel("Password", 10, 210)
$Cm_Saved = GuiCtrlCreateCombo("", 10, 30, 300, 21)
$In_Name = GuiCtrlCreateInput("", 10, 80, 300, 20)
$In_ServerIP = GuiCtrlCreateInput("", 10, 130, 300, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
	$WebIcon = GUICtrlCreateIcon("shell32.dll", -14, 315, 135 - 17, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Go to Website")
$WebIcon2 = GUICtrlCreateIcon("shell32.dll", -180, 315, 160 - 18, 16, 16) ; 135
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Copy URL to Clipboard")
$In_Userfile = GuiCtrlCreateInput("", 10, 180, 300, 20)
	GUICtrlSetState(-1, $GUI_DISABLE)
 $UserIcon = GUICtrlCreateIcon("shell32.dll", -174, 315, 200 - 18, 16, 16) ; 135
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Copy Username to Clipboard")
$In_PWDFile = GuiCtrlCreateInput("", 10, 230, 300, 20, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
$PassIcon = GUICtrlCreateIcon("shell32.dll", -48, 315, 250 - 18, 18, 18) ; 135
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Copy Password to Clipboard")
$Bt_Conect = GuiCtrlCreateButton("Auto Connect", 7, 280, 80)
$Bt_OpenFF = GuiCtrlCreateButton("Open Fire Fox", 120, 280, 80)
$Bt_OpenFFip = GuiCtrlCreateButton("Fire Fox @ip", 245, 280, 80)
$Bt_add = GUICtrlCreateButton("Add/Edit/Remove", 7, 315, 120, 30, BitOR($BS_DEFPUSHBUTTON, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$Bt_OpenIE = GuiCtrlCreateButton("Open IE", 135, 315, 80)
$Bt_OpenIEip = GuiCtrlCreateButton(" IE @ ip", 245, 315, 80)

GuiCtrlCreateLabel("Portable Browser C:\PortableFirefox\FirefoxPortable.exe", 10, 355)
readSaved()

HotKeySet("{ESC}", "Terminate")
GuiSetState()

While 1
    $msg = GuiGetMsg()
	Switch $msg
  Case $GUI_EVENT_CLOSE
			ExitLoop

Case $Bt_add
AddEditGUI()

  Case $Bt_OpenIE
			 InternetExplorer()

  Case $Bt_OpenIEip
	  			$ip = GUICtrlRead($In_ServerIP)
			$go = 1

			if $ip = "" Then
				MsgBox(48, "Error", "No IP or URL to connect to")
				$go = 0
			EndIf
			if $go = 1 Then
			 InternetExplorerIP()
EndIf

  Case $Bt_OpenFF
 			 OpenFireFox()

  Case $Bt_OpenFFip
			$ip = GUICtrlRead($In_ServerIP)
			$go = 1

			if $ip = "" Then
				MsgBox(48, "Error", "No IP or URL to connect to")
				$go = 0
			EndIf
			if $go = 1 Then
		  OpenFireFoxip()
			EndIf

  Case $Bt_Conect
			$ip = GUICtrlRead($In_ServerIP)
			$pwdF = GUICtrlRead($In_PWDFile)
			$go = 1

			if $ip = "" Then
				MsgBox(48, "Error", "No IP or URL to connect to")
				$go = 0
			EndIf

			if $go = 1 Then
				Connect()
			EndIf

	Case $WebIcon
	$ip = GUICtrlRead($In_ServerIP)
			$go = 1

			if $ip = "" Then
				MsgBox(48, "Error", "No IP or URL to connect to")
				$go = 0
			EndIf
			if $go = 1 Then
		  OpenFireFoxip()
			EndIf

    Case $WebIcon2
    ClipPut(GUICtrlRead($In_ServerIP))

      Case $UserIcon
				ClipPut(GUICtrlRead($In_Userfile))
                WinSetState("WebSite login", "", @SW_MINIMIZE)

	Case $PassIcon
				ClipPut(GUICtrlRead($In_PWDFile))
                WinSetState("WebSite login", "", @SW_MINIMIZE)

	Case $Cm_Saved
            UpdateScr()
    Case Else
;;;
	EndSwitch
WEnd
exit

Func AddEditGUI()   ;==>AddEditGUI
GuiCreate($AddName, 320, 320)
GuiCtrlCreateLabel("Saved Connections", 10, 10)
GuiCtrlCreateLabel("Name:", 10, 60)
GuiCtrlCreateLabel("Device Ip Info:     https://ip address:port#", 10, 110)
GuiCtrlCreateLabel("Username", 10, 160)
GuiCtrlCreateLabel("Password", 10, 210)
$Cm2_Saved = GuiCtrlCreateCombo("", 10, 30, 300, 21)
$In2_Name = GuiCtrlCreateInput("", 10, 80, 300, 20)
$In2_ServerIP = GuiCtrlCreateInput("", 10, 130, 300, 20)
$In2_Userfile = GuiCtrlCreateInput("", 10, 180, 300, 20)
$In2_PWDFile = GuiCtrlCreateInput("", 10, 230, 300, 20)
$Bt_Save = GuiCtrlCreateButton("Save", 100, 280, 60)
$Bt_Remove = GuiCtrlCreateButton("Remove", 180, 280, 60)
readSaved2()

GuiSetState()
While 1

$msg2 = GuiGetMsg()
	Switch $msg2

   Case $GUI_EVENT_CLOSE
readSaved()
GUIDelete($AddName)
        ExitLoop

   Case $Bt_Save
			Select
				Case GUICtrlRead($In2_Name) = ""
					MsgBox(48, "Error", "Please enter a name to save too")

				Case GUICtrlRead($In2_ServerIP) = ""
					MsgBox(48, "Error", "Please enter a server URL/short name/IP address to save")

				case Else
			if MsgBox(4, "Verify Save", "Are you sure you want to save" & GUICtrlRead($Cm2_Saved) & "?") = 6 Then
;				Save()
IniWrite($iniFile, "clt-" & GUICtrlRead($In2_Name), "IP", GUICtrlRead($In2_ServerIP))
IniWrite($iniFile, "clt-" & GUICtrlRead($In2_Name), "pwdfile", GUICtrlRead($In2_PWDFile))
IniWrite($iniFile, "clt-" & GUICtrlRead($In2_Name), "userfile", GUICtrlRead($In2_Userfile))
	readSaved2()
EndIf
	      EndSelect

	Case $Bt_Remove
			if MsgBox(4, "Verify Remove", "Are you sure you want to remove " & GUICtrlRead($Cm2_Saved) & "?") = 6 Then
IniDelete($iniFile, "clt-" & GUICtrlRead($Cm2_Saved))
GUICtrlSetdata($In_Name, "")
GUICtrlSetdata($In_ServerIP, "")
GUICtrlSetdata($In_PWDFile, "")
GUICtrlSetdata($In_Userfile, "")
 readSaved2()
EndIf

	Case $Cm2_Saved
			;if the user changes a selection in the drop down box, update the screen
			UpdateScr2()
EndSwitch
WEnd
EndFunc   ;==>AddEditGUI

Func Terminate()
	if WinActive($appName) Then
		Exit 0
	EndIf
EndFunc

Func OpenFireFox()
ShellExecute ("C:\PortableFireFox\FirefoxPortable.exe")
EndFunc

Func OpenFireFoxip()
ShellExecute ("C:\PortableFireFox\FirefoxPortable.exe", $ip)
EndFunc

Func InternetExplorer()
_IECreate("www.google.com", 0, 1, 0, 1)
EndFunc

Func InternetExplorerip()
_IECreate($ip, 0, 1, 0, 1)
EndFunc

Func Connect()
$usersend = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "userfile" , "")
$passsend = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
ShellExecute ("C:\PortableFireFox\FirefoxPortable.exe", $ip)
Sleep(9000)
send($usersend)
Sleep(4000)
Send("{TAB}")
Send($passsend)
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{enter}")
EndFunc

;reads ini file and populates drop down box
Func readSaved()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$saved = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($saved)
		$c = ""
		For $i = 1 To $saved[0]
			if StringLeft($saved[$i], 4) = "clt-" Then
				$name = StringRight($saved[$i], StringLen($saved[$i]) - 4)
				if $c = "" Then
					$c = $name
				Else
					$c = $c & "|" & $name
               EndIf
			EndIf
		Next
			GUICtrlSetData($Cm_Saved, $c)
UpdateScr()
	EndIf
EndFunc

;reads ini file and populates drop down box for edit

Func readSaved2()
	GUICtrlSetData($Cm2_Saved, "") ;blank saved pull down
	$saved2 = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($saved2)
		$c2 = ""
		For $i2 = 1 To $saved2[0]
			if StringLeft($saved2[$i2], 4) = "clt-" Then
				$name2 = StringRight($saved2[$i2], StringLen($saved2[$i2]) - 4)
				if $c2 = "" Then
					$c2 = $name2
				Else
					$c2 = $c2 & "|" & $name2
				EndIf
			EndIf
		Next
		GUICtrlSetData($Cm2_Saved, $c2)
		EndIf
		UpdateScr2()
EndFunc

;updates screen info to reflect saved setting in ini file
Func UpdateScr()
	$name = GUICtrlRead($Cm_Saved)
    $ip = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$pwdF = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
    $user = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "userfile" , "")

	GUICtrlSetData($In_ServerIP, $ip)
	GUICtrlSetdata($In_Name, $name)
    GUICtrlSetdata($In_Userfile, $user)
	GUICtrlSetdata($In_PWDFile, $pwdF)

EndFunc

Func UpdateScr2()
	$name2 = GUICtrlRead($Cm2_Saved)
    $ip2 = IniRead($iniFile, "clt-" & GUICtrlRead($Cm2_Saved), "IP" , "")
    $pwdF2 = IniRead($iniFile, "clt-" & GUICtrlRead($Cm2_Saved), "pwdfile" , "")
    $user2 = IniRead($iniFile, "clt-" & GUICtrlRead($Cm2_Saved), "userfile" , "")

	GUICtrlSetData($In2_ServerIP, $ip2)
	GUICtrlSetdata($In2_Name, $name2)
    GUICtrlSetdata($In2_Userfile, $user2)
	GUICtrlSetdata($In2_PWDFile, $pwdF2)
readSaved()
EndFunc