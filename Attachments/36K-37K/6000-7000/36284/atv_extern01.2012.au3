#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <INet.au3>
#include <ComboConstants.au3>
#include <Constants.au3>
Global $ii = 1, $message = "", $vlcinfo = 0
while stringlen(IniRead ( @AppDataDir & "\andygoreceiver.ini", "receiver", $ii, "" )) > 6
    if stringlen(IniRead ( @AppDataDir & "\andygoreceiver.ini", "receiver", $ii, "" )) > 6 then $message &= IniRead ( @AppDataDir & "\andygoreceiver.ini", "receiver", $ii, "" )&"|"
	$ii += 1
wend
$pregui = GUICreate("LAN.TV.Setup", 256, 115)
$label = GUICtrlCreateLabel("Receiver.IP"&@CRLF&"Dreambox(gemini e1 / e2), D-Box(neutrino yWeb)", 4, 4, 246, 30)
$devices = GUICtrlCreateCombo("Receiver", 4, 38, 248, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
if $message <> "" then
    GUICtrlSetData($devices, $message, "Receiver")
Else
	GUICtrlSetState ($devices, $GUI_DISABLE)
endif
$new = GUICtrlCreateinput("192.168.", 4, 64, 248, 20)
$vdo = GUICtrlCreateCheckbox("VLC Debug", 5, 92, 70, 18)
$go = GUICtrlCreateButton("OK", 91, 87, 74, 22)
GUISetState()
Opt("GuiOnEventMode", 0)
while 1
	sleep(20)
	$msg = GUIGetMsg()
	Select
		case $msg = $vdo
			if $vlcinfo = 0 Then
				$vlcinfo = 1
				msgbox(64, "VLC", "Die Debugkonsole kann u.U. das Zappen verlangsamen.")
			endif
		Case $msg = $GUI_EVENT_CLOSE
			if msgbox(68,"Frage", "LAN.TV beenden?") = 6 then Exit
		case $msg = $go
			exitloop
		case $msg = $devices
			if GUICtrlRead($devices) <> "Receiver" then GUICtrlSetData($new, GUICtrlRead($devices))
	EndSelect
wend
$ip = GUICtrlRead($new)
FileInstall("atv_intern12.exe", @AppDataDir & "\atv_intern12.exe", 1)
$pid = Run(@AppDataDir&"\atv_intern12.exe "&@AutoItPID&" "&$ip&" "&GUICtrlRead($vdo), @AppDataDir, @SW_SHOW, $STDERR_CHILD)
GUIDelete($pregui)
While ProcessExists($pid)
	$ct = StderrRead($pid)
	$ct = StringTrimLeft($ct, StringInStr($ct, "[", 0, -1)-1)
	$ct = StringLeft($ct, StringInStr($ct, @LF)-1)&"+ "&StringInStr($ct, @CR)
	if StringInStr($ct, "[") > 0 then
		if IniRead ( @AppDataDir & "\vlc"&@AutoItPID&".ini", "receiver", "console", "" ) <> $ct then iniwrite(@AppDataDir & "\vlc"&@AutoItPID&".ini", "receiver", "console",  $ct)
	endif
	sleep(125)
Wend
Exit
