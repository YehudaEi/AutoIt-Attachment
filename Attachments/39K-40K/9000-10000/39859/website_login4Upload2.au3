#include <GUIConstantsEx.au3>
#include <GuiConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <misc.au3>
#include <EditConstants.au3>
#include <GuiListBox.au3>
#include <ie.au3>

If _Singleton("Web Device login",1) = 0 then
 MsgBox(0, "Warning", "An occurence of Web Device login is already running")
Exit
EndIf
Opt("GUICoordMode", 1)
;Global $In_Name, $count, $Items_Length, $countsaved
Global $Cm2_Saved, $In2_ServerIP, $In2_Name, $In2_Userfile, $In2_PWDFile
Global $dataset3, $DataSet2, $ch_Ver51, $ch_Ver61, $ch_Ver71, $ch_Ver81, $ch_Ver91
$ip = ""
$appName = "Web Device login"
$iniFile = (@ScriptDir & "\webinfo.ini")
$AddName = "Add / Remove"

; Check to see if Firefox portable and Chrome Portable are on the C drive
If FileExists("C:\PortableFirefox\FirefoxPortable.exe") Then
Else
    MsgBox(4096, "Portable FireFox Missing", "Please Download and install Portable FireFox to C:\PortableFireFox")
EndIf

If FileExists("C:\PortableChrome\GoogleChromePortable.exe") Then

Else
    MsgBox(4096, "Portable Chrome Missing", "Please Download and install Portable Chrome to C:\PortableChrome")
EndIf

$Mgui1=GuiCreate($appName, 350, 400)
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
;$Bt_Conect = GuiCtrlCreateButton("Auto Connect", 7, 285, 80)
$Bt_OpenFF = GuiCtrlCreateButton("Open Fire Fox", 120, 255, 80)
$Bt_OpenFFip = GuiCtrlCreateButton("Fire Fox @ ip", 245, 255, 80)
$Bt_OpenChrome = GuiCtrlCreateButton("Open Chrome", 120, 285, 80)
$Bt_OpenChromeip = GuiCtrlCreateButton("Chrome @ ip", 245, 285, 80)
$Bt_add = GUICtrlCreateButton("Add/Remove", 7, 315, 80)
$Bt_OpenIE = GuiCtrlCreateButton("Open IE", 120, 315, 80)
$Bt_OpenIEip = GuiCtrlCreateButton(" IE @ ip", 245, 315, 80)

$ch_Ver5 = GUICtrlCreateRadio("FireWall", 2, 360, 70, 20)
$ch_Ver6 = GUICtrlCreateRadio("Power", 73, 360, 70, 20)
$ch_Ver7 = GUICtrlCreateRadio("BDR", 145, 360, 70, 20)
$ch_Ver8 = GUICtrlCreateRadio("Other", 215, 360, 70, 20)
$ch_Ver9 = GUICtrlCreateRadio("Mod", 290, 360, 70, 20)
GUICtrlSetState($ch_Ver5, $GUI_CHECKED)
;GuiCtrlCreateLabel("Portable Browser C:\PortableFirefox\FirefoxPortable.exe", 10, 365)
;GuiCtrlCreateLabel("Portable Browser C:\PortableChrome\GoogleChromePortable.exe", 10, 380)
;readSaved()
read_fws()
HotKeySet("{ESC}", "Terminate")
GuiSetState()

While 1
   $msg = GuiGetMsg()
	Switch $msg

 Case $GUI_EVENT_CLOSE
			ExitLoop

Case $ch_Ver5
read_fws()

case $ch_Ver6
read_pwr()

Case $ch_Ver7
read_bdr()

Case $ch_Ver8
read_oth()

Case $ch_Ver9
read_mod()

  Case $Bt_add
        AddEditGUI()
          If BitAND(GUICtrlRead($ch_Ver5), $GUI_CHECKED) = $GUI_CHECKED Then read_fws()
	      If BitAND(GUICtrlRead($ch_Ver6), $GUI_CHECKED) = $GUI_CHECKED Then read_pwr()
	      If BitAND(GUICtrlRead($ch_Ver7), $GUI_CHECKED) = $GUI_CHECKED Then read_bdr()
	      If BitAND(GUICtrlRead($ch_Ver8), $GUI_CHECKED) = $GUI_CHECKED Then read_oth()
          If BitAND(GUICtrlRead($ch_Ver9), $GUI_CHECKED) = $GUI_CHECKED Then read_mod()

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

Case $Bt_OpenChrome
			 OpenChrome()

  Case $Bt_OpenChromeip
			$ip = GUICtrlRead($In_ServerIP)
			$go = 1

			if $ip = "" Then
				MsgBox(48, "Error", "No IP or URL to connect to")
				$go = 0
			EndIf
			if $go = 1 Then
		  OpenChromeip()
			EndIf

;  Case $Bt_Conect
;			$ip = GUICtrlRead($In_ServerIP)
;			$pwdF = GUICtrlRead($In_PWDFile)
;			$go = 1
;
;			if $ip = "" Then
;				MsgBox(48, "Error", "No IP or URL to connect to")
;				$go = 0
;			EndIf
;
;			if $go = 1 Then
;				Connect()
;			EndIf

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
                WinSetState("Web Device login", "", @SW_MINIMIZE)

	Case $PassIcon
				ClipPut(GUICtrlRead($In_PWDFile))
                WinSetState("Web Device login", "", @SW_MINIMIZE)

	Case $Cm_Saved
          If BitAND(GUICtrlRead($ch_Ver5), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_fws()
	      If BitAND(GUICtrlRead($ch_Ver6), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_pwr()
	      If BitAND(GUICtrlRead($ch_Ver7), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_bdr()
	      If BitAND(GUICtrlRead($ch_Ver8), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_oth()
          If BitAND(GUICtrlRead($ch_Ver9), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_mod()
  Case Else
;;;
	EndSwitch
WEnd
exit

Func AddEditGUI()   ;==>AddEditGUI
GuiCreate($AddName, 350, 350)
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
$Bt_Save = GuiCtrlCreateButton("Save", 100, 300, 60)
$Bt_Remove = GuiCtrlCreateButton("Remove", 180, 300, 60)

$ch_Ver51 = GUICtrlCreateRadio("FireWall", 5, 270, 70, 20)
$ch_Ver61 = GUICtrlCreateRadio("Power", 75, 270, 70, 20)
$ch_Ver71 = GUICtrlCreateRadio("BDR", 145, 270, 70, 20)
$ch_Ver81 = GUICtrlCreateRadio("Other", 215, 270, 70, 20)
$ch_Ver91 = GUICtrlCreateRadio("Mod", 285, 270, 70, 20)
GUICtrlSetState($ch_Ver51, $GUI_CHECKED)
read_edit_fws()
GuiSetState()
While 1
$msg2 = GuiGetMsg()
	Switch $msg2

   Case $GUI_EVENT_CLOSE

GUIDelete($AddName)
        ExitLoop

Case $ch_Ver51
read_edit_fws()

case $ch_Ver61
read_edit_pwr()

Case $ch_Ver71
read_edit_bdr()

Case $ch_Ver81
read_edit_oth()

Case $ch_Ver91
read_edit_mod()


Case $Bt_Save
			Select
				Case GUICtrlRead($In2_Name) = ""
					MsgBox(48, "Error", "Please enter a name to save too")

				Case GUICtrlRead($In2_ServerIP) = ""
					MsgBox(48, "Error", "Please enter a server URL/short name/IP address to save")

				case Else
			if MsgBox(4, "Verify Save", "Are you sure you want to save" & GUICtrlRead($Cm2_Saved) & "?") = 6 Then
;				Save()
	If BitAND(GUICtrlRead($ch_Ver51), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet2 = "fws-"
	If BitAND(GUICtrlRead($ch_Ver61), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet2 = "pwr-"
	If BitAND(GUICtrlRead($ch_Ver71), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet2 = "bdr-"
	If BitAND(GUICtrlRead($ch_Ver81), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet2 = "oth-"
	If BitAND(GUICtrlRead($ch_Ver91), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet2 = "mod-"

; GUICtrlSetData($GUI_CHECKED, $dataset2)
IniWrite($iniFile, $dataset2 & GUICtrlRead($In2_Name), "IP", GUICtrlRead($In2_ServerIP))
IniWrite($iniFile, $dataset2 & GUICtrlRead($In2_Name), "pwdfile", GUICtrlRead($In2_PWDFile))
IniWrite($iniFile, $dataset2 & GUICtrlRead($In2_Name), "userfile", GUICtrlRead($In2_Userfile))

          If BitAND(GUICtrlRead($ch_Ver51), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_fws()
	      If BitAND(GUICtrlRead($ch_Ver61), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_pwr()
	      If BitAND(GUICtrlRead($ch_Ver71), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_bdr()
	      If BitAND(GUICtrlRead($ch_Ver81), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_oth()
          If BitAND(GUICtrlRead($ch_Ver91), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_mod()
EndIf
	      EndSelect

	Case $Bt_Remove
			if MsgBox(4, "Verify Remove", "Are you sure you want to remove " & GUICtrlRead($Cm2_Saved) & "?") = 6 Then
	If BitAND(GUICtrlRead($ch_Ver51), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet3 = "fws-"
	If BitAND(GUICtrlRead($ch_Ver61), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet3 = "pwr-"
	If BitAND(GUICtrlRead($ch_Ver71), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet3 = "bdr-"
	If BitAND(GUICtrlRead($ch_Ver81), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet3 = "oth-"
	If BitAND(GUICtrlRead($ch_Ver91), $GUI_CHECKED) = $GUI_CHECKED Then $DataSet3 = "mod-"

;IniDelete($iniFile, "clt-" & GUICtrlRead($Cm2_Saved))
IniDelete($iniFile, $dataset3 & GUICtrlRead($Cm2_Saved))
GUICtrlSetdata($In_Name, "")
GUICtrlSetdata($In_ServerIP, "")
GUICtrlSetdata($In_PWDFile, "")
GUICtrlSetdata($In_Userfile, "")
          If BitAND(GUICtrlRead($ch_Ver51), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_fws()
	      If BitAND(GUICtrlRead($ch_Ver61), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_pwr()
	      If BitAND(GUICtrlRead($ch_Ver71), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_bdr()
	      If BitAND(GUICtrlRead($ch_Ver81), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_oth()
          If BitAND(GUICtrlRead($ch_Ver91), $GUI_CHECKED) = $GUI_CHECKED Then read_edit_mod()
EndIf

	Case $Cm2_Saved
			;if the user changes a selection in the drop down box, update the screen
          If BitAND(GUICtrlRead($ch_Ver51), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_edit_fws()
	      If BitAND(GUICtrlRead($ch_Ver61), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_edit_pwr()
	      If BitAND(GUICtrlRead($ch_Ver71), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_edit_bdr()
	      If BitAND(GUICtrlRead($ch_Ver81), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_edit_oth()
          If BitAND(GUICtrlRead($ch_Ver91), $GUI_CHECKED) = $GUI_CHECKED Then UpdateScr_edit_mod()
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

Func OpenChrome()
ShellExecute ("C:\PortableChrome\GoogleChromePortable.exe")
EndFunc

Func OpenChromeip()
ShellExecute ("C:\PortableChrome\GoogleChromePortable.exe", $ip)
EndFunc

Func InternetExplorer()
_IECreate("www.google.com", 0, 1, 0, 1)
EndFunc

Func InternetExplorerip()
_IECreate($ip, 0, 1, 0, 1)
EndFunc

;Func Connect()
;$usersend = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "userfile" , "")
;$passsend = IniRead($iniFile, "clt-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
;ShellExecute ("C:\PortableFireFox\FirefoxPortable.exe", $ip)
;Sleep(9000)
;send($usersend)
;Sleep(4000)
;Send("{TAB}")
;Send($passsend)
;Send("{TAB}")
;Send("{TAB}")
;Send("{TAB}")
;Send("{enter}")
;EndFunc

;reads ini file Firewalls and populates drop down box
Func read_fws()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$saved = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($saved)
		$c = ""
		For $i = 1 To $saved[0]
			if StringLeft($saved[$i], 4) = "fws-" Then
				$name = StringRight($saved[$i], StringLen($saved[$i]) - 4)
				if $c = "" Then
					$c = $name
				Else
					$c = $c & "|" & $name
               EndIf
			EndIf
		Next
			GUICtrlSetData($Cm_Saved, $c)
UpdateScr_fws()
	EndIf
EndFunc

;updates screen info to reflect saved setting in ini file
Func UpdateScr_fws()
    $name = GUICtrlRead($Cm_Saved)
    $ip = IniRead($iniFile, "fws-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$pwdF = IniRead($iniFile, "fws-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
    $user = IniRead($iniFile, "fws-" & GUICtrlRead($Cm_Saved), "userfile" , "")

	GUICtrlSetData($In_ServerIP, $ip)
	GUICtrlSetdata($In_Name, $name)
    GUICtrlSetdata($In_Userfile, $user)
	GUICtrlSetdata($In_PWDFile, $pwdF)

EndFunc

;reads ini file and populates drop down box
Func read_pwr()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$savedpwr = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($savedpwr)
		$cpwr = ""
		For $ipwr = 1 To $savedpwr[0]
			if StringLeft($savedpwr[$ipwr], 4) = "pwr-" Then
				$namepwr = StringRight($savedpwr[$ipwr], StringLen($savedpwr[$ipwr]) - 4)
				if $cpwr = "" Then
					$cpwr = $namepwr
				Else
					$cpwr = $cpwr & "|" & $namepwr
               EndIf
			EndIf
		Next
			GUICtrlSetData($Cm_Saved, $cpwr)
UpdateScr_pwr()
	EndIf
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_pwr()
    $name_pwr = GUICtrlRead($Cm_Saved)
    $ip_pwr = IniRead($iniFile, "pwr-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$pwdF_pwr= IniRead($iniFile, "pwr-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
    $user_pwr = IniRead($iniFile, "pwr-" & GUICtrlRead($Cm_Saved), "userfile" , "")
	GUICtrlSetData($In_ServerIP, $ip_pwr)
	GUICtrlSetdata($In_Name, $name_pwr)
    GUICtrlSetdata($In_Userfile, $user_pwr)
	GUICtrlSetdata($In_PWDFile, $pwdF_pwr)
EndFunc

;reads ini file for BDR and populates drop down box
Func read_bdr()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$savedbdr = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($savedbdr)
		$cbdr = ""
		For $ibdr = 1 To $savedbdr[0]
			if StringLeft($savedbdr[$ibdr], 4) = "bdr-" Then
				$namebdr = StringRight($savedbdr[$ibdr], StringLen($savedbdr[$ibdr]) - 4)
				if $cbdr = "" Then
					$cbdr = $namebdr
				Else
					$cbdr = $cbdr & "|" & $namebdr
               EndIf
			EndIf
		Next
			GUICtrlSetData($Cm_Saved, $cbdr)
UpdateScr_bdr()
	EndIf
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_bdr()
    $name_bdr = GUICtrlRead($Cm_Saved)
    $ip_bdr = IniRead($iniFile, "bdr-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$pwdF_bdr = IniRead($iniFile, "bdr-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
    $user_bdr = IniRead($iniFile, "bdr-" & GUICtrlRead($Cm_Saved), "userfile" , "")
	GUICtrlSetData($In_ServerIP, $ip_bdr)
	GUICtrlSetdata($In_Name, $name_bdr)
    GUICtrlSetdata($In_Userfile, $user_bdr)
	GUICtrlSetdata($In_PWDFile, $pwdF_bdr)
EndFunc
;reads ini file for Other other and populates drop down box
Func read_oth()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$savedoth = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($savedoth)
		$coth = ""
		For $ioth = 1 To $savedoth[0]
			if StringLeft($savedoth[$ioth], 4) = "oth-" Then
				$nameoth = StringRight($savedoth[$ioth], StringLen($savedoth[$ioth]) - 4)
				if $coth = "" Then
					$coth = $nameoth
				Else
					$coth = $coth & "|" & $nameoth
               EndIf
			EndIf
		Next
			GUICtrlSetData($Cm_Saved, $coth)
UpdateScr_oth()
	EndIf
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_oth()
    $name_oth = GUICtrlRead($Cm_Saved)
    $ip_oth = IniRead($iniFile, "oth-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$pwdF_oth = IniRead($iniFile, "oth-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
    $user_oth = IniRead($iniFile, "oth-" & GUICtrlRead($Cm_Saved), "userfile" , "")
	GUICtrlSetData($In_ServerIP, $ip_oth)
	GUICtrlSetdata($In_Name, $name_oth)
    GUICtrlSetdata($In_Userfile, $user_oth)
	GUICtrlSetdata($In_PWDFile, $pwdF_oth)
EndFunc
;reads ini file for mod and populates drop down box
Func read_mod()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$savedmod = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($savedmod)
		$cmod = ""
		For $imod = 1 To $savedmod[0]
			if StringLeft($savedmod[$imod], 4) = "mod-" Then
				$namemod = StringRight($savedmod[$imod], StringLen($savedmod[$imod]) - 4)
				if $cmod = "" Then
					$cmod = $namemod
				Else
					$cmod = $cmod & "|" & $namemod
               EndIf
			EndIf
		Next
			GUICtrlSetData($Cm_Saved, $cmod)
UpdateScr_mod()
	EndIf
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_mod()
    $name_mod = GUICtrlRead($Cm_Saved)
    $ip_mod = IniRead($iniFile, "mod-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$pwdF_mod = IniRead($iniFile, "mod-" & GUICtrlRead($Cm_Saved), "pwdfile" , "")
    $user_mod = IniRead($iniFile, "mod-" & GUICtrlRead($Cm_Saved), "userfile" , "")

	GUICtrlSetData($In_ServerIP, $ip_mod)
	GUICtrlSetdata($In_Name, $name_mod)
    GUICtrlSetdata($In_Userfile, $user_mod)
	GUICtrlSetdata($In_PWDFile, $pwdF_mod)
EndFunc

; reads ini file for firewall edit gui and populates drop down box for edit
Func read_edit_fws()
 ; 	MsgBox(0, "", "1")
	If BitAND(GUICtrlRead($ch_Ver51), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetData($Cm2_Saved, "") ;blank saved pull down
$saved5 = IniReadSectionNames($iniFile)
if not @error Then
		_ArraySort($saved5)
		$c5 = ""
		For $i5 = 1 To $saved5[0]
;			if StringLeft($saved2[$i2], 4) = "clt-" Then
if StringLeft($saved5[$i5], 4) = "fws-" Then
                $name5 = StringRight($saved5[$i5], StringLen($saved5[$i5]) - 4)
				if $c5 = "" Then
					$c5 = $name5
				Else
					$c5 = $c5 & "|" & $name5
				EndIf
			EndIf
		Next
		GUICtrlSetData($Cm2_Saved, $c5)
		EndIf
UpdateScr_edit_fws()
EndIf
EndFunc
;updates screen info to reflect saved setting in ini file
func UpdateScr_edit_fws()
    $name2 = GUICtrlRead($Cm2_Saved)
    $ip2 = IniRead($iniFile, "fws-" & GUICtrlRead($Cm2_Saved), "IP" , "")
    $pwdF2 = IniRead($iniFile, "fws-" & GUICtrlRead($Cm2_Saved), "pwdfile" , "")
    $user2 = IniRead($iniFile, "fws-" & GUICtrlRead($Cm2_Saved), "userfile" , "")
	GUICtrlSetData($In2_ServerIP, $ip2)
	GUICtrlSetdata($In2_Name, $name2)
    GUICtrlSetdata($In2_Userfile, $user2)
	GUICtrlSetdata($In2_PWDFile, $pwdF2)
EndFunc

Func read_edit_pwr()
	GUICtrlSetData($Cm2_Saved, "") ;blank saved pull down
$saved5 = IniReadSectionNames($iniFile)
if not @error Then
		_ArraySort($saved5)
		$c5 = ""
		For $i5 = 1 To $saved5[0]
;			if StringLeft($saved2[$i2], 4) = "clt-" Then
if StringLeft($saved5[$i5], 4) = "pwr-" Then
                $name5 = StringRight($saved5[$i5], StringLen($saved5[$i5]) - 4)
				if $c5 = "" Then
					$c5 = $name5
				Else
					$c5 = $c5 & "|" & $name5
				EndIf
			EndIf
		Next
		GUICtrlSetData($Cm2_Saved, $c5)
		EndIf
	UpdateScr_edit_pwr()
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_edit_pwr()
    $name2 = GUICtrlRead($Cm2_Saved)
    $ip2 = IniRead($iniFile, "pwr-" & GUICtrlRead($Cm2_Saved), "IP" , "")
    $pwdF2 = IniRead($iniFile, "pwr-" & GUICtrlRead($Cm2_Saved), "pwdfile" , "")
    $user2 = IniRead($iniFile, "pwr-" & GUICtrlRead($Cm2_Saved), "userfile" , "")
	GUICtrlSetData($In2_ServerIP, $ip2)
	GUICtrlSetdata($In2_Name, $name2)
    GUICtrlSetdata($In2_Userfile, $user2)
	GUICtrlSetdata($In2_PWDFile, $pwdF2)
EndFunc

Func read_edit_bdr()
	GUICtrlSetData($Cm2_Saved, "") ;blank saved pull down
$saved5 = IniReadSectionNames($iniFile)
if not @error Then
		_ArraySort($saved5)
		$c5 = ""
		For $i5 = 1 To $saved5[0]
;			if StringLeft($saved2[$i2], 4) = "clt-" Then
if StringLeft($saved5[$i5], 4) = "bdr-" Then
                $name5 = StringRight($saved5[$i5], StringLen($saved5[$i5]) - 4)
				if $c5 = "" Then
					$c5 = $name5
				Else
					$c5 = $c5 & "|" & $name5
				EndIf
			EndIf
		Next
		GUICtrlSetData($Cm2_Saved, $c5)
		EndIf
	UpdateScr_edit_bdr()
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_edit_bdr()
    $name2 = GUICtrlRead($Cm2_Saved)
    $ip2 = IniRead($iniFile, "bdr-" & GUICtrlRead($Cm2_Saved), "IP" , "")
    $pwdF2 = IniRead($iniFile, "bdr-" & GUICtrlRead($Cm2_Saved), "pwdfile" , "")
    $user2 = IniRead($iniFile, "bdr-" & GUICtrlRead($Cm2_Saved), "userfile" , "")

	GUICtrlSetData($In2_ServerIP, $ip2)
	GUICtrlSetdata($In2_Name, $name2)
    GUICtrlSetdata($In2_Userfile, $user2)
	GUICtrlSetdata($In2_PWDFile, $pwdF2)
EndFunc

Func read_edit_oth()
GUICtrlSetData($Cm2_Saved, "") ;blank saved pull down
$saved5 = IniReadSectionNames($iniFile)
if not @error Then
		_ArraySort($saved5)
		$c5 = ""
		For $i5 = 1 To $saved5[0]
;			if StringLeft($saved2[$i2], 4) = "clt-" Then
if StringLeft($saved5[$i5], 4) = "oth-" Then
                $name5 = StringRight($saved5[$i5], StringLen($saved5[$i5]) - 4)
				if $c5 = "" Then
					$c5 = $name5
				Else
					$c5 = $c5 & "|" & $name5
				EndIf
			EndIf
		Next
		GUICtrlSetData($Cm2_Saved, $c5)
		EndIf
		UpdateScr_edit_oth()
EndFunc
;updates screen info to reflect saved setting in ini file
func UpdateScr_edit_oth()
    $name2 = GUICtrlRead($Cm2_Saved)
    $ip2 = IniRead($iniFile, "oth-" & GUICtrlRead($Cm2_Saved), "IP" , "")
    $pwdF2 = IniRead($iniFile, "oth-" & GUICtrlRead($Cm2_Saved), "pwdfile" , "")
    $user2 = IniRead($iniFile, "oth-" & GUICtrlRead($Cm2_Saved), "userfile" , "")
	GUICtrlSetData($In2_ServerIP, $ip2)
	GUICtrlSetdata($In2_Name, $name2)
    GUICtrlSetdata($In2_Userfile, $user2)
	GUICtrlSetdata($In2_PWDFile, $pwdF2)
EndFunc

Func read_edit_mod()
GUICtrlSetData($Cm2_Saved, "") ;blank saved pull down
$saved5 = IniReadSectionNames($iniFile)
if not @error Then
		_ArraySort($saved5)
		$c5 = ""
		For $i5 = 1 To $saved5[0]
;			if StringLeft($saved2[$i2], 4) = "clt-" Then
if StringLeft($saved5[$i5], 4) = "mod-" Then
                $name5 = StringRight($saved5[$i5], StringLen($saved5[$i5]) - 4)
				if $c5 = "" Then
					$c5 = $name5
				Else
					$c5 = $c5 & "|" & $name5
				EndIf
			EndIf
		Next
		GUICtrlSetData($Cm2_Saved, $c5)
UpdateScr_edit_mod()
	EndIf
EndFunc
;updates screen info to reflect saved setting in ini file
Func UpdateScr_edit_mod()
$name2 = GUICtrlRead($Cm2_Saved)
    $ip2 = IniRead($iniFile, "mod-" & GUICtrlRead($Cm2_Saved), "IP" , "")
    $pwdF2 = IniRead($iniFile, "mod-" & GUICtrlRead($Cm2_Saved), "pwdfile" , "")
    $user2 = IniRead($iniFile, "mod-" & GUICtrlRead($Cm2_Saved), "userfile" , "")
	GUICtrlSetData($In2_ServerIP, $ip2)
	GUICtrlSetdata($In2_Name, $name2)
    GUICtrlSetdata($In2_Userfile, $user2)
	GUICtrlSetdata($In2_PWDFile, $pwdF2)
EndFunc