#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>

;AutoItSetOption ("MouseCoordMode",2)
GUICreate("Trial",250,250)
$checkCN = GUICtrlCreateCheckbox("Sample", 10, 10, 120, 20)
GUISetState(@SW_SHOW)
Sleep(1000)
While 1
        $msg = GUIGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		$handle = WinGetHandle("Sample","")
		;WinActivate
		$color =PixelGetColor(530,406,$handle)
		$color = Hex($color,6)
		If  $color <> "21A121" Then
			MsgBox(0,"Status","Unchecked",2)
			Sleep(1000)
			MouseClick("left",530,406)
		Else
			MsgBox(0,"Status","Checked",2)
			Sleep(1000)
			MouseClick("left",530,406)
		EndIf
		Sleep(1000)
WEnd
