#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$Form1_1 = GUICreate("Apply Proxy Settings", 276, 84, 320, 196)
GUISetBkColor(0x0000FF)
$Combo1 = GUICtrlCreateCombo("Select Proxy", 56, 32, 185, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData (-1, "Load Proxy 1|Load Proxy 2")
$Load = GUICtrlCreateLabel("Select Proxy Server", 56, 16, 116, 17)
GUICtrlSetFont(-1, 9, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Button1 = GUICtrlCreateButton("Apply", 184, 56, 59, 25)
GUISetState(@SW_SHOW)

Local $WSDIR = "c:\program files\websense\websense endpoint"
Local $stop = "-stop -password 1websense1 wspxy"

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Load
		Case $Button1
			StopWS ()

EndSwitch

WEnd

#region --- Proxy ---

;=============================================================================================================================
Func StopWS()
		if $Combo1 = "Proxy 1" Then
		ShellExecuteWait("wepsvc", $stop, $WSDIR, "", @SW_HIDE)
		RegWrite("HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel", "HomePage", "Reg_DWORD", 1)
		RegWrite("HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel", "Proxy", "Reg_DWORD", 1)
		RegWrite("HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel", "Autoconfig", "Reg_DWORD", 1)
		Sleep(7000)
		MsgBox(0, "Restart Browser", "You must close and restart all browsers including Internet Explore Chrome or FireFox"&$Combo1, 20)
EndFunc





