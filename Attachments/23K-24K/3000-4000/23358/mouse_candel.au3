#include <GuiConstants.au3>
HotKeySet("{esc}","foo")
Func foo()
	Exit
EndFunc

$pos = MouseGetPos()
dim $WS_EX_TOPMOST, $WS_MAXIMIZE

$my_gui = GUICreate("MyGUI", @DesktopWidth + 10, @DesktopHeight-1, -10, -30,"" ,0x00000008)
GUISetBkColor(0x000000)

;_GuiHole($my_gui, $pos[0], $pos[1], 200)
GUISetState()
While 1
	$pos = MouseGetPos()
	_GuiHole($my_gui, $pos[0]-90, $pos[1]-70, 200)
	GUISetState()
$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd
Exit

Func _GuiHole($h_win, $i_x, $i_y, $i_size)
   Dim $pos, $outer_rgn, $inner_rgn, $wh, $combined_rgn, $ret
   $pos = WinGetPos($h_win)
   
   $outer_rgn = DllCall("gdi32.dll", "hwnd", "CreateRectRgn", "long", 0, "long", 0, "long", $pos[2], "long", $pos[3])
    If IsArray($outer_rgn) Then
        $inner_rgn = DllCall("gdi32.dll", "hwnd", "CreateEllipticRgn", "long", $i_x, "long", $i_y, "long", $i_x + $i_size, "long", $i_y + $i_size)
        If IsArray($inner_rgn) Then

                DllCall("gdi32.dll", "long", "CombineRgn", "hwnd", $outer_rgn[0], "hwnd", $outer_rgn[0], "hwnd", $inner_rgn[0], "int", 4)
                $ret = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "hwnd", $outer_rgn[0], "int", 1)
;~                 DllCall("gdi32.dll", "long", "DeleteObject", "hwnd", $inner_rgn[0])
                If $ret[0] Then
                    Return 1
                Else
                    Return 0
                EndIf

        Else
            Return 0
        EndIf
    Else
        Return 0
    EndIf
   
EndFunc ;==>_GuiHole