#include <GUIConstants.au3>
#include<user32.au3>

HotKeySet("{ESC}","quit")
Opt("GUIOnEventMode", 1)


Global $size[3] , $mid[3] , $fake_mouse[3], $last[3], $dll = DllOpen( "user32.dll"), $temp
$size[1] = @DesktopWidth
$size[2] = @DesktopHeight
$mid[1] = Int($size[1] / 2)
$mid[2] = Int($size[2] / 2)
$last[0] = ""

$win = GUICreate( "", $size[1], $size[2], 0, 0, $WS_POPUPWINDOW ,$WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)
$fake_mouse[0] = GUICtrlCreateIcon( @windowsdir & "\cursors\horse.ani",0,0,32,32)
$label = GUICtrlCreateLabel( "", 0, 0, 300, 300)

GuiCtrlSetOnEvent($fake_mouse[0],"quit")
GUISetState(@SW_SHOW)
MouseMove($mid[1],$mid[2],0)

While 1
    Sleep(10)
    $pos = MouseGetPos()
    $fake_mouse[1] = $fake_mouse[1] - ($mid[1] - $pos[0])
    $fake_mouse[2] = $fake_mouse[2] - ($mid[2] - $pos[1])
    _SetCursorPos( $mid[1], $mid[2], $dll)
    If $fake_mouse[1] > $size[1] Then
        $fake_mouse[1] = $size[1]
    ElseIf $fake_mouse[1] < 0 Then
        $fake_mouse[1] = 0
    EndIf
    
    If $fake_mouse[2] > $size[2] Then
        $fake_mouse[2] = $size[2]
    ElseIf $fake_mouse[2] < 0 Then
        $fake_mouse[2] = 0
    EndIf
	If ($last[1] <> $fake_mouse[1]) Or ($last[2] <> $fake_mouse[2]) Then
    GUICtrlSetPos($fake_mouse[0],$fake_mouse[1],$fake_mouse[2])
	$last[1] = $fake_mouse[1]
	$last[2] = $fake_mouse[2]
EndIf

$temp = "Real mouse: " & $pos[0] & "," & $pos[1] & @LF & _
"Fake mouse: " & $fake_mouse[1] & "," & $fake_mouse[2]
If ($last[0] <> $temp) Then
	GUICtrlSetData( $label, $temp)
	$last[0] = $temp
EndIf
WEnd


func quit()
	DllClose( $dll)
    Exit
EndFunc