#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	Local $oIE, $GUIActiveX1
	Local $msg

	$oIE = ObjCreate("Shell.Explorer")

	GUICreate("Personalized Short-Cuts Control Panel", 571, 490, 579, 140, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))

	$TabSet = GUICtrlCreateTab(10, 10, 550, 444, 0)

	$TabSheet1 = GUICtrlCreateTabItem("Personalized Short-Cuts")

	$GUIActiveX1 = GUICtrlCreateObj($oIE, 16, 40, 510, 400)

	GUISetState()
	$oIE.navigate("c:\Shortcuts")


	While 1

		$msg = GUIGetMsg()

		Select

			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop


		EndSelect

	WEnd

	GUIDelete()

EndFunc   ;==>Example
