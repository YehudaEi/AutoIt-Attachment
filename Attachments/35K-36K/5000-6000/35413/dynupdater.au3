#cs
Copyright (C) 2011 http://lior.weissbrod.com

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses>.

Additional restrictions under GNU GPL version 3 section 7:

In accordance with item 7b), it is required to preserve the reasonable legal notices/author attributions in the material and in the Appropriate Legal Notices displayed by works containing it (including in the footer).
In accordance with item 7c), misrepresentation of the origin of the material must be marked in reasonable ways as different from the original version.
#ce

; Originally by:
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <Inet.au3>
#include <IE.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>

$programname="Dynamic IP Updater"
$version=3.2
$thedate="2011"

$Test = ObjCreate("Shell.Explorer.2")

$SinkObject=ObjEvent($Test,"IEEvent_","DWebBrowserEvents")
if @error then
   Msgbox(0,"COM Test","Error! ObjEvent: Can't use the 'DWebBrowserEvents' interface.")
   exit
endif

$main_GUI = GUICreate($programname, 340, 480)
$helpmenu = GUICtrlCreateMenu("&Help")
$helpitem_about = GUICtrlCreateMenuItem("&About", $helpmenu)
$GUIActiveX = GUICtrlCreateObj ( $Test, 10, 29, 320, 82)
$Group1 = GUICtrlCreateGroup("Menu", 1, 112, 338, 210, -1, $WS_EX_TRANSPARENT)
$Tab1 = GUICtrlCreateTab(10, 130, 321, 190)
$TabSheet1 = GUICtrlCreateTabItem("DynUpdater")
;$GUIPICTURE = GuiCtrlCreatePic(@ScriptDir & "\d.jpg", 130, 175, 80, 80)
$GUI_Button_DynUpdate = GUICtrlCreateButton("DyndnsUpdate", 15, 175, 100, 30)
$GUI_Button_DynLocal = GUICtrlCreateButton("Dyndns127.0.0.1", 225, 175, 100, 30)
$GUI_Button_NoipUpdate= GUICtrlCreateButton("No-IpUpdate", 15, 225, 100, 30)
$GUI_Button_NoipLocal = GUICtrlCreateButton("No-Ip127.0.0.1", 225, 225, 100, 30)
$GUI_Button_Close = GUICtrlCreateButton("Escape && set all to 127.0.0.1", 90, 270, 160, 30)
$TabSheet2 = GUICtrlCreateTabItem("Accounts")
GuiCtrlCreateLabel("Dyndns", 20, 171, 90, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
GuiCtrlCreateLabel("User", 124, 171, 90, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
GuiCtrlCreateLabel("Password", 228, 171, 90, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
GuiCtrlCreateLabel("No-IP", 20, 228, 90, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
GuiCtrlCreateLabel("User", 124, 228, 90, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
GuiCtrlCreateLabel("Password", 228, 228, 90, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
$Save = GuiCtrlCreateButton("Save", 118, 285, 100, 30)
$dya = IniRead("dynupdater.ini", "www.dyndns.org", "Dyndns Account", "")
$da = GuiCtrlCreateInput("" & $dya, 20, 196, 90, 20)
$dyb = IniRead("dynupdater.ini", "www.dyndns.org", "User Name", "")
$db = GuiCtrlCreateInput("" & $dyb, 124, 196, 90, 20)
$dyc = IniRead("dynupdater.ini", "www.dyndns.org", "Password", "")
$dc = GuiCtrlCreateInput("" & $dyc, 228, 196, 90, 20, $ES_PASSWORD)
$nia = IniRead("dynupdater.ini", "www.no-ip.org", "No-IP Account", "")
$na = GuiCtrlCreateInput("" & $nia, 20, 253, 90, 20)
$nib = IniRead("dynupdater.ini", "www.no-ip.org", "User Name", "")
$nb = GuiCtrlCreateInput("" & $nib, 124, 253, 90, 20)
$nic = IniRead("dynupdater.ini", "www.no-ip.org", "Password", "")
$nc = GuiCtrlCreateInput("" & $nic, 228, 253, 90, 20, $ES_PASSWORD)
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW, $main_GUI)
$GUI_Label_Status   = GUICtrlCreateLabel   ("Status:",     10, 352 , 320, 30 )
$GUI_Progress = GUICtrlCreateProgress (10, 330 , 320 , 20 )
$GUI_Edit_Log = GUICtrlCreateEdit        ("Progress:" & @CRLF, 10, 385 , 320 , 90)
;GUISetState(@SW_SHOW)
$PublicIP = _GetIP()
GuiCtrlCreateLabel("The WAN IP is:  " & $PublicIP, 10, 10, 320, 20,$SS_CENTER,$SS_CENTERIMAGE)
GuiCtrlSetBkColor(-1, 0x86A8D6)
GUICtrlSetFont (-1,9, 400, 1, "Courier New Bold")
GUISetState()
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            ExitLoop
		Case $helpitem_about
			about()
        Case $GUI_Button_DynUpdate
	If StringLen(GUICtrlRead($da)) = 0 Then
	MsgBox(64, "Dynupdater", "Type Account", 3)
	Else
	$Test.navigate("http://"&GUICtrlRead($db)&":"&GUICtrlRead($dc)&"@members.dyndns.org/nic/update?system=dyndns&wildcard=NOCHG&hostname="&GUICtrlRead($da))
	_IELoadWait($Test)
	EndIf
	Case $GUI_Button_NoipUpdate
	If StringLen(GUICtrlRead($na)) = 0 Then
	MsgBox(64, "Dynupdater", "Type Account", 3)
	Else
	$Test.navigate("http://dynupdate.no-ip.com/dns?username="&GUICtrlRead($nb)&"&password="&GUICtrlRead($nc)&"&hostname="&GUICtrlRead($na))
	_IELoadWait($Test)
	EndIf
        Case $GUI_Button_DynLocal
	If StringLen(GUICtrlRead($da)) = 0 Then
	MsgBox(64, "Dynupdater", "Type Account", 3)
	Else
	$Test.navigate("http://"&GUICtrlRead($db)&":"&GUICtrlRead($dc)&"@members.dyndns.org/nic/update?system=dyndns&wildcard=NOCHG&hostname="&GUICtrlRead($da)&"&myip=127.0.0.1")
	_IELoadWait($Test)
	EndIf
	Case $GUI_Button_NoipLocal
	If StringLen(GUICtrlRead($na)) = 0 Then
	MsgBox(64, "Dynupdater", "Type Account", 3)
	Else
	$Test.navigate("http://dynupdate.no-ip.com/dns?username="&GUICtrlRead($nb)&"&password="&GUICtrlRead($nc)&"&hostname="&GUICtrlRead($na)&"&ip=127.0.0.1")
	_IELoadWait($Test)
	EndIf
	Case $GUI_Button_Close
	If StringLen(GUICtrlRead($da)) = 0 Then
	Sleep(50)
	Else
	$Test.navigate("http://"&GUICtrlRead($db)&":"&GUICtrlRead($dc)&"@members.dyndns.org/nic/update?system=dyndns&wildcard=NOCHG&hostname="&GUICtrlRead($da)&"&myip=127.0.0.1")
	_IELoadWait($Test)
	EndIf
	If StringLen(GUICtrlRead($na)) = 0 Then
	Sleep(50)
	Else
	$Test.navigate("http://dynupdate.no-ip.com/dns?username="&GUICtrlRead($nb)&"&password="&GUICtrlRead($nc)&"&hostname="&GUICtrlRead($na)&"&ip=127.0.0.1")
	_IELoadWait($Test)
	Sleep(2000)
	EndIf
	  ExitLoop
	Case $Save
	IniWrite("dynupdater.ini", "www.dyndns.org", "Dyndns Account", GUICtrlRead($da))
	IniWrite("dynupdater.ini", "www.dyndns.org", "User Name", GUICtrlRead($db))
	IniWrite("dynupdater.ini", "www.dyndns.org", "Password", GUICtrlRead($dc))
	IniWrite("dynupdater.ini", "www.no-ip.org", "No-IP Account", GUICtrlRead($na))
	IniWrite("dynupdater.ini", "www.no-ip.org", "User Name", GUICtrlRead($nb))
	IniWrite("dynupdater.ini", "www.no-ip.org", "Password", GUICtrlRead($nc))
	If StringLen(GUICtrlRead($da)) > 0 Then
    	MsgBox(64, "Dynupdater", "Account saved", 3)
	ElseIf StringLen(GUICtrlRead($na)) > 0 Then
    	MsgBox(64, "Dynupdater", "Account saved", 3)
	Else
	MsgBox(64, "Dynupdater", "There are no accounts!", 3)
	EndIf
    EndSwitch
    Sleep(50)
WEnd
GUIDelete ()

  $SinkObject=""; Stop receiving events
  $Test=""      ; Stop IE
Exit

Func IEEvent_ProgressChange($Progress,$ProgressMax)

    GUICtrlSetData( $GUI_Progress , ($Progress * 100) / $ProgressMax )

EndFunc

Func IEEvent_StatusTextChange($Text)

    GUICtrlSetData( $GUI_Label_Status, $Text)

    If $Text <> "" then GUICtrlSetData( $GUI_Edit_Log, "IE Status text changed to: " & $Text & @CRLF  , "append" )

EndFunc

Func IEEvent_NavigateComplete2($oWebBrowser,$URL)

;   IDispatch *pDisp,
;   VARIANT *URL

    GUICtrlSetData ( $GUI_Edit_Log, "IE has finished loading URL: " & $URL & @CRLF  , "append" )

EndFunc

Func about()
  GUICreate("About " & $programname, -1, -1, -1, -1, -1, $WS_EX_MDICHILD, $main_GUI)
  $localleft=10
  $localtop=10
  $message=$programname & " - Version " & $version & @crlf & _
  "©" & $thedate & " LWC" & _
  @crlf & @crlf & _
  $programname & " is a portable program that lets you control menus" & _
  @crlf & "via ini files." & _
  @crlf & @crlf & _
  "It also serves as a portable enforcer/simulator for semi-portable programs" & _
  @crlf & "that don't need installation but do otherwise leave leftovers forever." & _
  @crlf & @crlf & _
  "Look out for newer versions in:"
  GUICtrlCreateLabel($message, $localleft, $localtop)
  $aLabel = GUICtrlCreateLabel("http://lior.weissbrod.com", $localleft, $localtop+135)
  GUICtrlSetFont(-1,-1,-1,4)
  GUICtrlSetColor(-1,0x0000cc)
  GUICtrlSetCursor(-1,0)
  GUICtrlCreateLabel("This program comes with ABSOLUTELY NO WARRANTY;" & _
  @crlf & _
  "This is free software, and you are welcome to redistribute it" & _
  @crlf & _
  "under certain conditions;", $localleft, $localtop+155)
  $okay=GUICtrlCreateButton("OK", $localleft+270, $localtop+350, 100)

  GUISetState(@SW_SHOW)
  While 1
	$msg=guigetmsg()
	switch $msg
		case $GUI_EVENT_CLOSE, $okay
			guidelete()
			ExitLoop
		case $aLabel
			ShellExecute(GUICtrlRead($msg))
	endswitch
  WEnd
EndFunc