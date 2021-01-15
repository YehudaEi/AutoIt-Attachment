#include <GuiConstants.au3>
#include <misc.au3>

Global $SELECT_HWND
Global Const $SELECT_RUBBERBAND_TITLE = "RubberBandSelect"

;Initialize the rubberband selector, must call this at top of your script.
_InitRubberBand_Selector()

;========================= START OF MAIN ========================

While 1
	
	_RubberBand_Color(0xFF00FF,80) ;change selection box to purple
	
	$coords = _RubberBand_Select() ;Use left mouse to to select region
	If @error <> -2 Then
		MsgBox(0,"Your selected region coords","Top-Left: " & $coords[0] & "," & $coords[1] & @CRLF & "Bottom-Right: " _
		& $coords[2] & "," & $coords[3])
	EndIf
	
	_RubberBand_Color(0x00FFFF,80) ;change selection box to teal
	
	$coords = _RubberBand_Select() ;Use left mouse to to select region
	If @error <> -2 Then
		MsgBox(0,"Your selected region coords","Top-Left: " & $coords[0] & "," & $coords[1] & @CRLF & "Bottom-Right: " _
		& $coords[2] & "," & $coords[3])
	EndIf
	
	_RubberBand_Color(0xFFFF00,80) ;change selection box to yellow
	
	$coords = _RubberBand_Select() ;Use left mouse to to select region
	If @error <> -2 Then
		MsgBox(0,"Your selected region coords","Top-Left: " & $coords[0] & "," & $coords[1] & @CRLF & "Bottom-Right: " _
		& $coords[2] & "," & $coords[3])
	EndIf
	
WEnd

;========================= END OD MAIN ==========================

;================================================================
;  Creates a the selection box gui
;  Must call this before using Rubberband_Select()
;  Call this at top of script with other gui related inits
;  Params:
;        $color = Color of the selection box
;        $transparency = 0 - 100, Transparency level of box
;================================================================
Func _InitRubberBand_Selector($color = 0x00FFFF, $transparency = 60)
	$SELECT_HWND =  GUICreate( $SELECT_RUBBERBAND_TITLE, 0 , 0 , 0, 0,  $WS_POPUP + $WS_BORDER, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW)
	GUISetBkColor($color,$SELECT_HWND)
	WinSetTrans($SELECT_RUBBERBAND_TITLE,"",$transparency)
EndFunc
;================================================================
;  Changes the color os the rubberband selection box
;  Must initialize the selection box before calling this.
; 
;  Params:
;        $color = Color of the selection box
;        $transparency = 0 - 100, Transparency level of box
;  Returns:
;        Success - Color and transparency changed
;        Failure - @error = -2
;================================================================
Func _RubberBand_Color($color, $transparency = "")
	GUISetBkColor($color,$SELECT_HWND)
	If $transparency <> "" Then
		WinSetTrans($SELECT_RUBBERBAND_TITLE,"",$transparency)
	EndIf
EndFunc
;================================================================
;  Wait here until a mouse button is pressed down and and released
;  Params:
;        $mouse = "left" (default)
;                 "middle"
;                 "right"
;  Returns: 
;           Array[4] = [x-top-left, y-top-left, x-bottom-right, y-bottom-right]
;           0 = Invalide input, @error = 0
;          -2 = Mouse just clicked, @error = -2
;================================================================
Func _RubberBand_Select($mouse = "left")
	Local $dec, $x, $y
	WinMove($SELECT_RUBBERBAND_TITLE,"",1,1,2,2)
	GUISetState(@SW_RESTORE,$SELECT_HWND)
	GUISetState(@SW_SHOW,$SELECT_HWND)
	Local $firstCoord, $secondCoord, $currCoord
	If $mouse = "right" Then
		$dec = 2
	ElseIf $mouse = "middle" Then
		$dec = 4
	Elseif $mouse = "left" Then
		$dec = 1
	Else
		SetError(0)
		Return 0
	EndIf
	If _IsPressed(Hex($dec,2)) Then
		While _IsPressed(Hex($dec,2))
			Sleep(10)
		WEnd
	EndIf
	While Not _IsPressed(Hex($dec,2))
		$currCoord = MouseGetPos()
		Sleep(10)
		If _IsPressed(Hex($dec,2)) Then
			$firstCoord = MouseGetPos()
			WinMove($SELECT_RUBBERBAND_TITLE,"",$firstCoord[0],$firstCoord[1],1,1)
			While _IsPressed(Hex($dec,2))
				Sleep(10)
				$currCoord = MouseGetPos()
				$x = _RubberBand_Select_Order($firstCoord[0],$currCoord[0])
				$y = _RubberBand_Select_Order($firstCoord[1],$currCoord[1])
				WinMove($SELECT_RUBBERBAND_TITLE,"",$x[0],$y[0],$x[1],$y[1])
			WEnd
			$secondCoord = MouseGetPos()
			ExitLoop 1
		EndIf
	WEnd
	If $secondCoord[0] = $firstCoord[0] And $secondCoord[1] = $firstCoord[1] Then
		SetError(-2)
		Return -2
	EndIf
	Local $returnCoords[4] = [$x[0], $y[0], $x[1]+$x[0], $y[1]+$y[0]]
	GUISetState(@SW_HIDE,$SELECT_HWND)
	Return $returnCoords
EndFunc
;================================================================
;  Allow the selection box to be moved in all 4 quadrants
;  Params:
;         $a - First Coord mouse clicked (x or y)
;         $b - Current mouse position coord (x or y)
;  Returns: Array[2] = [x1,x2] in correct order
;================================================================
Func _RubberBand_Select_Order($a,$b)
    Dim $res[2]
    If $a < $b Then
        $res[0] = $a
        $res[1] = $b - $a
    Else
        $res[0] = $b
        $res[1] = $a - $b
    EndIf
    Return $res
EndFunc