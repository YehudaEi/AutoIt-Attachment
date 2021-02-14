#include 'GetNetSpeed.au3'

; Example
Local $dtw = Round(@DesktopWidth / 3)
Local $ui = GUICreate('', 300, 0, $dtw, 0, Default, BitOR(0x00000008, 0x00000080, 0x00000100))
GUISetState(@SW_SHOW, $ui)

AdlibRegister("_gns", 2000)
_gns(); Init first run

Do;something with loop
Until GUIGetMsg() = -3
AdlibUnRegister("_gns")
GUIDelete($ui)

Func _gns()
    Local $gns = GetNetSpeed()
    If @error Then
        WinSetTitle($ui, '', "GetNetSpeed Error: " & @error)
        AdlibUnRegister("_gns"); If error then it turn off
    Else
        WinSetTitle($ui, '', "DN: " & $gns[1] & "   -   UP: " & $gns[2])
    EndIf
EndFunc
