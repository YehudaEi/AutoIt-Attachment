#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include<Guiedit.au3>
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <Array.au3>
#include <ListviewConstants.au3>

#NoTrayIcon
;~ Opt("TrayIconDebug",1)
Global $draw = 9999, $rectangle_box = 9999, $circle_box = 9999, $ellipse_box = 9999, $line_box = 9999, $move_box = 9999, $text_box = 9999, $horizontal_box = 9999, $arc_box = 9999, $polygon_box = 9999, $layer_box = 9999
Global $i = 25, $layer_index = 0
Global $x1, $y1, $x2, $y2, $width, $x_c, $y_c, $start_angle, $sweep_angle, $i_current, $radius, $text
Local $graphic[100], $what_to_move[100], $type[100], $connector[100], $layer[100][3]
$degtorad = ATan(1) / 45
$action = "none"
$pen_size = 1
$Color = 0x000000
$text_settings_modified = False

;start
For $i = 26 To 99
	$graphic[$i] = "Free"
Next
;end

$main = GUICreate(" 2D Drawing Tool", 1000, 700)
;~ GUISetBkColor(0xFFFFFF)
$file_menu = GUICtrlCreateMenu("File")
$save_as = GUICtrlCreateMenuItem("Save As", $file_menu)
GUICtrlSetState($save_as, @SW_DISABLE)
GUICtrlSetState($save_as, $GUI_UNCHECKED)
$exit_sub = GUICtrlCreateMenuItem("Exit", $file_menu)

$draw_menu = GUICtrlCreateMenu("Draw")
$line = GUICtrlCreateMenuItem("Line", $draw_menu)
$circle = GUICtrlCreateMenuItem("Circle", $draw_menu)
$rectangle = GUICtrlCreateMenuItem("Rectangle", $draw_menu)
$ellipse = GUICtrlCreateMenuItem("Ellipse", $draw_menu)
$text = GUICtrlCreateMenuItem("Text", $draw_menu)
$arc = GUICtrlCreateMenuItem("Arc", $draw_menu)
$polygon = GUICtrlCreateMenuItem("Polygon", $draw_menu)
GUICtrlCreateMenuItem("", $draw_menu)
$dimension_lines = GUICtrlCreateMenu("Dimension lines", $draw_menu)
$horizontal = GUICtrlCreateMenuItem("Horizontal dimension", $dimension_lines)


$modify = GUICtrlCreateMenu("Modify")
$delete_sub = GUICtrlCreateMenuItem("Delete", $modify)
$move = GUICtrlCreateMenuItem("Move", $modify)
GUICtrlCreateMenuItem("", $modify)
$layer1 = GUICtrlCreateMenuItem("Layer manager", $modify)


$text_properties = GUICtrlCreateMenuItem("Text settings", $modify)
$view = GUICtrlCreateMenuItem("View", $modify)

GUISetState(@SW_SHOW, $main)

;~ drawing output window
$drawing_window = GUICreate("", 900, 620, 50, 10, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
GUISetBkColor(0xFFFFFF)

GUISetState()

GUISwitch($main)

HotKeySet("{Esc}", "_DeleteWindows")

While 1
	$msg = GUIGetMsg(1)
	Switch $msg[1]
		Case $main
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE, $exit_sub
					ExitLoop
				Case $view
					_ArrayDisplay($graphic)
				Case $save_as
					$destination = FileSaveDialog("Save as...", @MyDocumentsDir, "(.jpg)")
					_ScreenCapture_CaptureWnd($destination & ".jpg", $drawing_window, 0, 0, -1, -1, False)
				Case $delete_sub
					_DeleteWindows()
					$action = "delete"
				Case $move
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Move_1")
					$action = "move"
					$move_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify new start point", 0, 0, 200, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $line
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Line_1")
					$action = "none"
					$line_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify start point", 0, 0, 150, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $rectangle
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Rectangle_1")
					$action = "none"
					$rectangle_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify first corner point", 0, 0, 150, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $circle
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Circle_1")
					$action = "none"
					$circle_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify center point", 0, 0, 150, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $ellipse
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Ellipse_1")
					$action = "none"
					$ellipse_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify start point", 0, 0, 150, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $text
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Text_1")
					$text_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify start point", 0, 0, 150, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					$ok = GUICtrlCreateButton("OK", 400, 0)
					GUICtrlSetState($ok, $GUI_HIDE)
					$edit = GUICtrlCreateEdit("", 200, 0, 150, 40)
					GUICtrlSetState($edit, $GUI_HIDE)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $text_properties
					$text_settings = _ChooseFont()
					$text_settings_modified = True
					If @error Then $text_settings_modified = False
				Case $layer1
					GUISetState(@SW_DISABLE, $main)
					$layer_box = GUICreate("Test", 400, 400, Default, Default)
					$add_layer = GUICtrlCreateButton("Add layer", 10, 10)
					$list_view = GUICtrlCreateListView("Name|Color|Line weight", 10, 50, 200, 200, $LVS_EDITLABELS)
					$activate = GUICtrlCreateButton("Activate", 100, 10)
					If $layer_index <> 0 Then
						For $smth = 1 To $layer_index
							GUICtrlCreateListViewItem("Layer " & $layer[$smth][0] & "|" & $layer[$smth][1] & "|" & $layer[$smth][2], $list_view)
							GUICtrlSetBkColor(-1, $layer[$smth][1])
						Next
					EndIf
					GUISetState()
				Case $horizontal
					_DeleteWindows()
					HotKeySet("{ENTER}", "_HorizontalDimension_1")
					$horizontal_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify  start point", 0, 0, 200, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $arc
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Arc_1")
					$arc_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify center point", 0, 0, 200, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
				Case $polygon
					_DeleteWindows()
					HotKeySet("{ENTER}", "_Polygon_1")
					$polygon_box = GUICreate("", 500, 30, 10, 640, $WS_CHILD, $WS_EX_CLIENTEDGE, $main)
					$label = GUICtrlCreateLabel("Specify center point", 0, 0, 200, 20)
					$input = GUICtrlCreateInput("", 200, 0)
					GUISetBkColor(0xFFFFFF)
					GUISetState(@SW_SHOW)
			EndSwitch
		Case $circle_box

		Case $ellipse_box

		Case $line_box

		Case $drawing_window
			If $action = "delete" Then
				Select
					Case $msg[0] <> 0
						If $type[$msg[0]] = "Horizontal_Dimension_1" Then
							$graphic[$msg[0]] = "Free"
							GUICtrlDelete($msg[0])
							GUICtrlDelete(($msg[0] + $connector[$msg[0]]))
							$graphic[($msg[0] + $connector[$msg[0]])] = "Free"
							$action = "none"
						ElseIf $type = "Horizontal_Dimension_2" Then
							$graphic[$msg[0]] = "Free"
							GUICtrlDelete($msg[0])
							GUICtrlDelete(($msg[0] - $connector[$msg[0]]))
							$graphic[($msg[0] - $connector[$msg[0]])] = "Free"
							$action = "none"
						Else
							GUICtrlDelete($msg[0])
							$graphic[$msg[0]] = "Free"
							$action = "none"
						EndIf
				EndSelect
			ElseIf $action = "move" Then
				Select
					Case $msg[0] <> 0
						GUICtrlSetPos($msg[0], $x1, $y1)
						$action = "none"
						GUIDelete($move_box)
				EndSelect
			Else

			EndIf
		Case $move_box

		Case $text_box
			Switch $msg[0]
				Case $ok
					$text = GUICtrlRead($edit)
					GUISwitch($drawing_window)
					$free = _ArraySearch($graphic, "Free", 1)
					$i_current = $i
					$i = $free
					_Sort()
					$graphic[$i] = GUICtrlCreateLabel($text, $x1, $y1, $x2 - $x1, $y2 - $y1)
					If $text_settings_modified = True Then
						GUICtrlSetFont(-1, $text_settings[3], $text_settings[4], $text_settings[1], $text_settings[2])
						GUICtrlSetColor(-1, $text_settings[7])
					EndIf
					$type[$i] = "Text"
					GUIDelete($text_box)
			EndSwitch
		Case $horizontal_box

		Case $layer_box
			Switch $msg[0]
				Case -3
					GUIDelete($layer_box)
					GUISetState(@SW_ENABLE, $main)
				Case $add_layer
					$layer_index = $layer_index + 1
					$Color = _ChooseColor(2, 0, 0)
					$pen_size = InputBox("Pen Size", "Type the size you want", 1, " M")
					GUICtrlCreateListViewItem("Layer " & $layer_index & "|" & $Color & "|" & $pen_size, $list_view)
					$layer[$layer_index][0] = $layer_index
					$layer[$layer_index][1] = $Color
					$layer[$layer_index][2] = $pen_size
					GUICtrlSetBkColor(-1, $layer[$layer_index][1]); cameronsdad solved;Montfrooij
				Case $activate
					$read = GUICtrlRead(GUICtrlRead($list_view))
					$split = StringSplit($read, "|")
					$Color = $split[2]
					$pen_size = $split[3]
			EndSwitch
	EndSwitch
WEnd

Func _DeleteWindows()
	GUIDelete($text_box)
	GUIDelete($move_box)
	GUIDelete($line_box)
	GUIDelete($ellipse_box)
	GUIDelete($circle_box)
	GUIDelete($rectangle_box)
	GUIDelete($horizontal_box)
	GUIDelete($arc_box)
	GUIDelete($polygon)
EndFunc   ;==>_DeleteWindows

Func _DrawingProperties()
	GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, $pen_size)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $Color)
EndFunc   ;==>_DrawingProperties

Func _Rectangle_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x1 = $split[1]
		$y1 = $split[2]
		GUICtrlSetData($label, "Specify second corner point")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Rectangle_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Rectangle_1

Func _Rectangle_2()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x2 = $split[1]
		$y2 = $split[2]
;~ 		$i = $i + 1
		GUISwitch($drawing_window)
		$free = _ArraySearch($graphic, "Free", 1)
		$i_current = $i
		$i = $free
		_Sort()
		$graphic[$i] = GUICtrlCreateGraphic($x1, $y1, $x2 - $x1, $y2 - $y1)
		_DrawingProperties()
		GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
		GUICtrlSetGraphic($graphic[$i], $GUI_GR_RECT, 0, 0, $x2 - $x1, $y2 - $y1)
		GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
		$type[$i] = "Rectangle"
		$i = $i_current
		GUISwitch($main)
		GUIDelete($rectangle_box)
		HotKeySet("{ENTER}")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Rectangle_2

Func _Circle_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x1 = $split[1]
		$y1 = $split[2]
		GUICtrlSetData($label, "Specify radius of  circle")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Circle_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Circle_1

Func _Circle_2()
	$radius = GUICtrlRead($input)
;~ 	$i = $i + 1
	$free = _ArraySearch($graphic, "Free", 1)
	$i_current = $i
	$i = $free
	GUISwitch($drawing_window)
	$graphic[$i] = GUICtrlCreateGraphic($x1 - $radius, $y1 - $radius, 2 * $radius, 2 * $radius)
	_DrawingProperties()
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_ELLIPSE, 0, 0, 2 * $radius, 2 * $radius)
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
	$type[$i] = "Circle"
	GUISwitch($main)
	GUIDelete($circle_box)
	HotKeySet("{ENTER}")
EndFunc   ;==>_Circle_2

Func _Ellipse_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x1 = $split[1]
		$y1 = $split[2]
		GUICtrlSetData($label, "Specify width")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Ellipse_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Ellipse_1

Func _Ellipse_2()
	GUICtrlSetData($label, "Specify height")
	$width = GUICtrlRead($input)
	GUICtrlSetData($input, "")
	HotKeySet("{ENTER}", "_Ellipse_3")
EndFunc   ;==>_Ellipse_2

Func _Ellipse_3()
	$height = GUICtrlRead($input)
;~ 	$i = $i + 1
	$free = _ArraySearch($graphic, "Free", 1)
	$i_current = $i
	$i = $free
	GUISwitch($drawing_window)
	$graphic[$i] = GUICtrlCreateGraphic($x1 - $width / 2, $y1 - $height / 2, $width, $height)
	_DrawingProperties()
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_ELLIPSE, 0, 0, $width, $height)
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
	$type[$i] = "Ellipse"
	GUISwitch($main)
	GUIDelete($ellipse_box)
	HotKeySet("{ENTER}")
EndFunc   ;==>_Ellipse_3

Func _Line_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x1 = $split[1]
		$y1 = $split[2]
		GUICtrlSetData($label, "Specify end point")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Line_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Line_1

Func _Line_2()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x2 = $split[1]
		$y2 = $split[2]
;~ 		$i = $i + 1
		$free = _ArraySearch($graphic, "Free", 1)
		$i_current = $i
		$i = $free
		$x1_backup = $x1
		$y1_backup = $y1
		$x2_backup = $x2
		$y2_backup = $y2
		GUISwitch($drawing_window)
		If ($x2 > $x1 And $y2 > $y1) Then
			$graphic[$i] = GUICtrlCreateGraphic($x1, $y1, $x2 - $x1, $y2 - $y1)
			_DrawingProperties()
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, 0)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2 - $x1, $y2 - $y1)
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			$type[$i] = "Line"
			GUISwitch($main)
			GUIDelete($line_box)
			HotKeySet("{ENTER}")
		ElseIf ($x2 > $x1 And $y2 < $y1) Then
			$graphic[$i] = GUICtrlCreateGraphic($x2 - $x1, $y2, $x2 - $x1, $y1 - $y2)
			_DrawingProperties()
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $y1 - $y2)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2 - $x1, 0)
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			$type[$i] = "Line"
			GUISwitch($main)
			GUIDelete($line_box)
			HotKeySet("{ENTER}")
		ElseIf ($x2 < $x1 And $y2 < $y1) Then
			$graphic[$i] = GUICtrlCreateGraphic($x2, $y2, $x1 - $x2, $y1 - $y2)
			_DrawingProperties()
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, 0)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x1 - $x2, $y1 - $y2)
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			$type[$i] = "Line"
			GUISwitch($main)
			GUIDelete($line_box)
			HotKeySet("{ENTER}")
		ElseIf ($x2 < $x1 And $y2 > $y1) Then
			$graphic[$i] = GUICtrlCreateGraphic($x1-$x2, $y1, $x1 - $x2, $y2 - $y1)
			_DrawingProperties()
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $y2-$y1)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x1-$x2, 0)
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			$type[$i] = "Line"
			GUISwitch($main)
			GUIDelete($line_box)
			HotKeySet("{ENTER}")
		Else
		EndIf
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Line_2

Func _Text_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		GUICtrlSetData($label, "Specify second corner point")
		$x1 = $split[1]
		$y1 = $split[2]
		GUICtrlSetData($label, "Specify end point")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Text_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Text_1

Func _Text_2()
	GUICtrlSetData($label, "Type the text")
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x2 = $split[1]
		$y2 = $split[2]
		GUICtrlDelete($input)
		GUICtrlSetState($edit, $GUI_SHOW)
		GUICtrlSetState($ok, $GUI_SHOW)
		HotKeySet("{ENTER}")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Text_2

Func _Move_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x1 = $split[1]
		$y1 = $split[2]
		GUICtrlDelete($input)
		GUICtrlSetData($label, "Select object to move")
		$action = "move"
		HotKeySet("{ENTER}")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Move_1

Func _HorizontalDimension_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		GUICtrlSetData($label, "Specify end point")
		GUICtrlSetData($input, "")
		$x1 = $split[1]
		$y1 = $split[2]
		HotKeySet("{ENTER}", "_HorizontalDimension_2")
	EndIf
EndFunc   ;==>_HorizontalDimension_1

Func _HorizontalDimension_2()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		GUICtrlSetData($label, "Specify dimesion text")
		$x2 = $split[1]
		$y2 = $split[2]
		$d = Abs($x2 - $x1)
		GUICtrlSetData($input, $d)
		HotKeySet("{ENTER}", "_HorizontalDimension_3")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_HorizontalDimension_2

Func _HorizontalDimension_3()
	$text = GUICtrlRead($input)

	GUICtrlSetData($label, "Specify offset from main line")
	GUICtrlSetData($input, "")
	HotKeySet("{ENTER}", "_HorizontalDimension_4")
EndFunc   ;==>_HorizontalDimension_3

Func _HorizontalDimension_4()
	$offset = GUICtrlRead($input)
	GUISwitch($drawing_window)
;~  	$i = $i + 1
	$free = _ArraySearch($graphic, "Free", 1)
	$i_current = $i
	$i = $free
	_Sort()
	$graphic[$i] = GUICtrlCreateGraphic($x1, $y1, $x2 - $x1, $y2 - $y1 + $offset)
	_DrawingProperties()
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, 0)
	GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 0, $y2 - $y1 + $offset)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2 - $y1, $y2 - $y1 + $offset)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2 - $x1, $y2 - $y1)
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $x2 - $y1, $y2 - $y1 + $offset)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2 - $y1 - $pen_size * 4, $y2 - $y1 + $offset + $pen_size)
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $x2 - $y1, $y2 - $y1 + $offset)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2 - $y1 - $pen_size * 4, $y2 - $y1 + $offset - $pen_size)
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $y2 - $y1 + $offset)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 4 * $pen_size, $y2 - $y1 + $offset + $pen_size)
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $y2 - $y1 + $offset)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 4 * $pen_size, $y2 - $y1 + $offset - $pen_size)
	GUICtrlSetGraphic($graphic[$i], $GUI_GR_REFRESH)
	$type[$i] = "Horizontal_Dimension_1"
	$connector_ID = $i
	$previous = $graphic[$i]
;~ 	$d = Abs($x2 - $x1)
	$len = StringLen($text)
	$free = _ArraySearch($graphic, "Free", 1)
	$i_current = $i
	$i = $free
	$graphic[$i] = GUICtrlCreateLabel($text, (($x1 + $x2) / 2) - ($len / 2), $y2 + $offset - 15, 7.5 * $len, 15)
	GUICtrlSetColor(-1, $Color)
	$type[$i] = "Horizontal_Dimension_2"
	$connector[$connector_ID] = $graphic[$i] - $previous ;debbug
	GUIDelete($horizontal_box)
	HotKeySet("{ENTER}")
EndFunc   ;==>_HorizontalDimension_4

Func _Arc_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x_c = $split[1]
		$y_c = $split[2]
		GUICtrlSetData($label, "Specify start angle")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Arc_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Arc_1

Func _Arc_2()
	$start_angle = GUICtrlRead($input)
	HotKeySet("{ENTER}", "_Arc_3")
	GUICtrlSetData($label, "Specify sweep angle")
EndFunc   ;==>_Arc_2

Func _Arc_3()
	$sweep_angle = GUICtrlRead($input)
	HotKeySet("{ENTER}", "_Arc_4")
	GUICtrlSetData($label, "Specify arc radius")
	GUICtrlSetData($input, "")
	GUICtrlSetData($input, "")
EndFunc   ;==>_Arc_3

Func _Arc_4()
	$radius = GUICtrlRead($input)
	GUISwitch($drawing_window)
;~ 	$i=$i+1
	$free = _ArraySearch($graphic, "Free", 1)
	$i_current = $i
	$i = $free
	$graphic[$i] = GUICtrlCreateGraphic($x_c - $radius, $y_c - $radius, 2 * $radius, 2 * $radius)
	_DrawingProperties()
	GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
	GUICtrlSetGraphic(-1, $GUI_GR_PIE, $radius, $radius, $radius, $start_angle, $sweep_angle)
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $radius, $radius)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xFFFFFF)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $radius+$radius*_Cos($start_angle), $radius-$radius*_Sin($start_angle))
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $radius, $radius)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xFFFFFF)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $radius+$radius * _Cos($sweep_angle+$start_angle),$radius- $radius*_Sin($sweep_angle+$start_angle))
	GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
	$type[$i] = "Arc"
	HotKeySet("{ENTER}")
	GUIDelete($arc_box)
EndFunc   ;==>_Arc_4

Func _Polygon_1()
	$read = GUICtrlRead($input)
	$split = StringSplit($read, ",")
	If $split[0] = 2 Then
		$x_c = $split[1]
		$y_c = $split[2]
		GUICtrlSetData($label, "Specify radius of  circle")
		GUICtrlSetData($input, "")
		HotKeySet("{ENTER}", "_Polygon_2")
	Else
		GUICtrlSetData($label, "Wrong input, try again")
	EndIf
EndFunc   ;==>_Polygon_1

Func _Polygon_2()
	$radius = GUICtrlRead($input)
	GUICtrlSetData($label, "Specify number of sides")
	GUICtrlSetData($input, "")
	HotKeySet("{ENTER}", "_Polygon_3")
EndFunc   ;==>_Polygon_2

Func _Polygon_3()
	$n = GUICtrlRead($input)
	GUIDelete($polygon_box)
	HotKeySet("{ENTER}")
	$free = _ArraySearch($graphic, "Free", 1)
	$i_current = $i
	$i = $free
	GUISwitch($drawing_window)
	$polygon_angle = 360 / $n
	$start_angle = 90 - $polygon_angle / 2
	$graphic[$i] = GUICtrlCreateGraphic($x_c - $radius, $y_c - $radius, 2 * $radius, 2 * $radius)
	_DrawingProperties()
	For $j = 1 To $n
		$x1 = $radius + $radius * Cos(($start_angle + $j * $polygon_angle) * $degtorad)
		$y1 = $radius + $radius * Sin(($start_angle + $j * $polygon_angle) * $degtorad)
		GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $x1, $y1)
		$x2 = $radius + $radius * Cos(($start_angle + ($j + 1) * $polygon_angle) * $degtorad)
		$y2 = $radius + $radius * Sin(($start_angle + ($j + 1) * $polygon_angle) * $degtorad)
		GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x2, $y2)
		GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
	Next
	GUISetState(@SW_SHOW, $drawing_window)
	$type[$i] = "Polygon"
EndFunc   ;==>_Polygon_3

Func _Sort()
	$x1_backup = $x1
	$y1_backup = $y1
	$x2_backup = $x2
	$y2_backup = $y2
	If $x1 > $x2 Then
		$x1 = $x2
		$x2 = $x1_backup
	EndIf
	If $y1 > $y2 Then
		$y1 = $y2
		$y2 = $y1_backup
	EndIf
EndFunc   ;==>_Sort

Func _Cos($angle)
	Local $cos = Cos(4 * ATan(1) * $angle / 180) ; [pi = 4 * ATan(1)]
	If ($angle = 90 Or $angle = 270) Then $cos = 0
	Return $cos
EndFunc   ;==>_Cos

Func _Sin($angle)
	Local $sin = Sin(4 * ATan(1) * $angle / 180)
	If ($angle = 180 Or $angle = 360) Then $sin = 0
	Return $sin
EndFunc   ;==>_Sin