#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Documents and Settings\sbuck\Desktop\Form1.kxf
$Form1 = GUICreate("Form1", 374, 126, 192, 114)
GUICtrlCreateInput("", 8, 32, 129, 21)
$Radio2 = GUICtrlCreateRadio("Radio2", 8, 8, 17, 17)
$Label2 = GUICtrlCreateLabel("User", 32, 8, 26, 17)
$Button1 = GUICtrlCreateButton("Check", 144, 32, 49, 25)
$Input1 = GUICtrlCreateInput("", 248, 56, 113, 21)
$Input2 = GUICtrlCreateInput("", 248, 96, 113, 21)
$Label4 = GUICtrlCreateLabel("Currently Logged On", 248, 40, 101, 17)
$Label5 = GUICtrlCreateLabel("Password Status", 248, 80, 83, 17)
$Input3 = GUICtrlCreateInput("", 248, 16, 113, 21)
$Label1 = GUICtrlCreateLabel("Location", 248, 0, 45, 17)
$Radio1 = GUICtrlCreateRadio("Radio1", 8, 72, 17, 17)
$Label3 = GUICtrlCreateLabel("Machine", 24, 72, 45, 17)
$IPAddress1 = _GUICtrlIpAddress_Create($Form1, 104, 96, 97, 17)
_GUICtrlIpAddress_Set($IPAddress1, "0.0.0.0")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
