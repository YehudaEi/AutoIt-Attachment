#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <guiconstants.au3>
#include <inet.au3>

Opt("GUIOnEventMode", 1)

Global $guiWidth = 200
Global $guiHeight = 150

Global $goldenLeft = (@DesktopWidth - $guiWidth)/2
Global $goldenTop = (( 3*@DesktopHeight - Sqrt(5*(@DesktopHeight^2)) ) - $guiHeight)/2

Global $ipsGUI = GUICreate("Copy IPs", $guiWidth, $guiHeight, $goldenLeft, $goldenTop)

$newTop = 0

$newTop = $newTop + 10
Global $wanLabel = GUICtrlCreateLabel ("Your WAN IP is:", 10, $newTop)

$newTop = $newTop + 20
$wanIP = _GetIP()
Global $wanIPbutton = GUICtrlCreateButton($wanIP, 20, $newTop, 100)
GUICtrlSetOnEvent($wanIPbutton,"CopyWanIp2Clipboard")	;orizoume ti sinarthsh pou tha antistoixei sto koumpi

$newTop = $newTop + 40
Global $wanLabel = GUICtrlCreateLabel ("Your Local IP is:", 10, $newTop)

$newTop = $newTop + 20
$localIP = @IPAddress1
Global $wanIPbutton = GUICtrlCreateButton($localIP, 20, $newTop, 100)
GUICtrlSetOnEvent($wanIPbutton,"CopyLocalIp2Clipboard")	;orizoume ti sinarthsh pou tha antistoixei sto koumpi

GUISetState(@SW_SHOW,$ipsGUI)

GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

While 1
	Sleep(100)	;aplws kolla edw kai perimene energeies tou xrhsth
WEnd

Func Close()
	GUIDelete($ipsGUI)	;skotose to gui
	Exit	;time to exit baby
EndFunc

Func CopyWanIp2Clipboard()
	ClipPut($wanIP)
EndFunc

Func CopyLocalIp2Clipboard()
	ClipPut($localIP)
EndFunc
