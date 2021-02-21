#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $TCPPrevious

TCPStartup()
$TCPListen = TCPListen(@IPAddress1, 1000)

Opt("WinTitleMatchMode", 2)
$opacity = 255

$Form1 = GUICreate("No", @DesktopWidth, @DesktopHeight,0,0,$WS_POPUP)
$Graphic1 = GUICtrlCreateGraphic(0, 0, @DesktopWidth, @DesktopHeight)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0x000000)
GUISetState()

Do
    $TCPAccept = TCPAccept($TCPListen)
Until $TCPAccept <> -1

While 1
    $TCPRecv = TCPRecv($TCPAccept, 255)
    If $TCPRecv <> "" And $TCPRecv <> $TCPPrevious Then
        $TCPPrevious = $TCPRecv
        WinSetTrans("No", "", $opacity)
		GUICtrlSetData($opacity, $TCPRecv)
    EndIf

    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd