#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
$Form2 = GUICreate("MyNetwork", 429, 212, 494, 236)
$Button1 = GUICtrlCreateButton("Make a new Network", 8, 16, 145, 33, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Start", 8, 56, 145, 33, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Stop", 8, 96, 145, 33, $WS_GROUP)
$Button4 = GUICtrlCreateButton("Refresh", 8, 136, 147, 33, $WS_GROUP)
$Button5 = GUICtrlCreateButton("Status", 8, 176, 145, 33, $WS_GROUP)
$Input1 = GUICtrlCreateInput("", 160, 24, 241, 21, $ES_NOHIDESEL)
$Input2 = GUICtrlCreateInput("password", 160, 64, 241, 21)
$Checkbox1 = GUICtrlCreateCheckbox("Hide characters", 160, 88, 113, 17)
$Label1 = GUICtrlCreateLabel("Name of Network", 160, 8, 200, 17)
$Label2 = GUICtrlCreateLabel("Password (min. of 8 characters)", 160, 48, 200, 17)
$str1 = GUICtrlRead($Input1)
$str2 = GUICtrlRead($Input2)
GUISetState(@SW_SHOW)



While 1
		$msg = GUIGetMsg()


		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop

			Case $msg =$Button5
				run("cmd")
				WinActivate ( "cmd" )
				sleep ( 500 )
				send("netsh wlan show hostednetwork")
				send( "{enter}")

			Case $msg =$Button1
				run("notepad")
				WinActivate ( "notepad" )
				sleep ( 500 )
				send("netsh wlan set hostednetwork mode=allow ssid=" & $str1 )

			Case $msg =$Button3
				run("cmd")
				WinActivate ( "cmd" )
				sleep ( 500 )
				send("netsh wlan stop hostednetwork")
				send( "{enter}")

			Case $msg =$Button4
				run("cmd")
				WinActivate ( "cmd" )
				sleep ( 500 )
				send("netsh wlan refresh hostednetwork")
				send( "{enter}")
		EndSelect
	WEnd

	GUIDelete()

	Exit

