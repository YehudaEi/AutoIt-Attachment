#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>

$main = GUICreate("Drawing", 400, 400)

$file_menu = GUICtrlCreateMenu("File")
$exit_sub = GUICtrlCreateMenuItem("Exit", $file_menu)

$draw_menu = GUICtrlCreateMenu("Draw")
$line = GUICtrlCreateMenuItem("Line", $draw_menu)

$arc = GUICtrlCreateMenuItem("Arc", $draw_menu)
$circle = GUICtrlCreateMenuItem("Circle", $draw_menu)
$spline = GUICtrlCreateMenuItem("Spline", $draw_menu)
$rectangle = GUICtrlCreateMenuItem("Rectangle", $draw_menu)

GUISetState()

_GDIPlus_Startup()
$graphic = _GDIPlus_GraphicsCreateFromHWND($main)
$bitmap = _GDIPlus_BitmapCreateFromGraphics(401, 401, $graphic)
$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE Or $msg = $exit_sub
            ExitLoop
        Case $msg = $line
            GUISetState(@SW_DISABLE)
            GUICreate("Coordinates", 200, 150)
            GUISetState()
            GUICtrlCreateGroup("Start Point", 10, 10, 80, 80)
            $x1 = GUICtrlCreateInput("x", 15, 30, 30, 20)
            $y1 = GUICtrlCreateInput("y", 50, 30, 30, 20)
            GUICtrlCreateGroup("End Point", 100, 10, 80, 80)
            $x2 = GUICtrlCreateInput("x", 105, 30, 30, 20)
            $y2 = GUICtrlCreateInput("y", 140, 30, 30, 20)
            $ok_button = GUICtrlCreateButton("OK", 60, 120, 40, 20)
            $cancel_button = GUICtrlCreateButton("Cancel", 110, 120, 40, 20)
            While 1
                $msg = GUIGetMsg()
                Select
                    Case $msg = $GUI_EVENT_CLOSE
                        ExitLoop
                    Case $msg = $ok_button
                        $p1 = GUICtrlRead($x1)
                        $p2 = GUICtrlRead($x2)
                        $t1 = GUICtrlRead($y1)
                        $t2 = GUICtrlRead($y2)
                        GUIDelete()
                        GUISetState(@SW_ENABLE, $main)
                        WinActivate($main)

                        _GDIPlus_GraphicsDrawLine($backbuffer, $p1, $t1, $p2, $t2)
                        _GDIPlus_GraphicsDrawImageRect($graphic, $bitmap, 0, 0, 401, 401)
                        ExitLoop
					Case $msg=$cancel_button
						GUIDelete()
					   GUISetState(@SW_ENABLE,$main)
					   WinActivate($main)
                EndSelect
            WEnd
		Case $msg=$arc
			GUISetState(@SW_DISABLE)
			$sub=GUICreate("Ellipse",200,150)
			GUISetState()
			GUICtrlCreateGroup("First corner point", 10, 10, 80, 80)
            $x1 = GUICtrlCreateInput("x", 15, 30, 30, 20)
            $y1 = GUICtrlCreateInput("y", 50, 30, 30, 20)
            GUICtrlCreateGroup("Other corner point", 100, 10, 80, 80)
            $x2 = GUICtrlCreateInput("x", 105, 30, 30, 20)
            $y2 = GUICtrlCreateInput("y", 140, 30, 30, 20)
            $ok_button = GUICtrlCreateButton("OK", 60, 120, 40, 20)
            $cancel_button = GUICtrlCreateButton("Cancel", 110, 120, 40, 20)
			While 1
				$msg = GUIGetMsg()
			    Select
                Case $msg = $GUI_EVENT_CLOSE
                    ExitLoop
                Case $msg = $ok_button
                    $p1 = GUICtrlRead($x1)
                    $p2 = GUICtrlRead($x2)
                    $t1 = GUICtrlRead($y1)
                    $t2 = GUICtrlRead($y2)
                    GUIDelete()
                    GUISetState(@SW_ENABLE, $main)
                    WinActivate($main)
					_GDIPlus_GraphicsDrawEllipse($backbuffer, $p1, $t1, $p2-$p1, $t2-$t1)
					_GDIPlus_GraphicsDrawImageRect($graphic, $bitmap, 0, 0, 401, 401)
					ExitLoop
				Case $msg=$cancel_button
					GUIDelete()
					GUISetState(@SW_ENABLE,$main)
					WinActivate($main)
				EndSelect
    EndSelect
WEnd

_GDIPlus_GraphicsDispose($backbuffer)
_GDIPlus_BitmapDispose($bitmap)
_GDIPlus_GraphicsDispose($graphic)
_GDIPlus_Shutdown()
