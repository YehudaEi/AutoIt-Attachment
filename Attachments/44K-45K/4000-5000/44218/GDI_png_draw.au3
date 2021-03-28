#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#Include <Misc.au3>

Opt("MustDeclareVars", 1)

; ===============================================================================================================================
; Description ...: Shows how to display a PNG image
; Author ........: Andreas Klein
; Notes .........:
; ===============================================================================================================================

; ===============================================================================================================================
; Global variables
; ===============================================================================================================================
Global $hGUI, $hImage1, $hImage2, $hGraphic, $label_cursorinfo, $cursorinfo, $mousepos, $WM_PAINT

; Create GUI
$hGUI = GUICreate("Show PNG", 350, 350)

$label_cursorinfo = GUICtrlCreateLabel(" ",10,10,290,290)
GUICtrlSetState($label_cursorinfo,@SW_HIDE)

;069380767265
;2178post
;michael102
GUISetState()

; Load PNG image
_GDIPlus_StartUp()
$hImage1   = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\win7.png")
$hImage2  = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Rainbow_trout_transparent.png")

; Draw PNG image
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

;Local $hMatrix = _GDIPlus_MatrixCreate()
; Scale the matrix by 2 (everything will get 2x larger)
;_GDIPlus_MatrixScale($hMatrix, 0.1, 0.1)
;_GDIPlus_GraphicsSetTransform($hGraphic,$hMatrix)

;_GDIPlus_GraphicsDrawImage($hGraphic, $hImage2, 0, 0)
;_GDIPlus_GraphicsDrawImage($hGraphic, $hImage1,5, 5)

_GDIPlus_GraphicsDrawImageRect($hGraphic,$hImage2,0,0,300,300)
_GDIPlus_GraphicsDrawImageRect($hGraphic,$hImage1,10,10,200,200)
; Loop until user exits

GUIRegisterMsg($WM_PAINT, "WM_PAINT")
While 1

	GUICtrlSetState($label_cursorinfo,@SW_HIDE)
	$cursorinfo = GUIGetCursorInfo($hGUI)
	$mousepos = MouseGetPos()
	;GUICtrlSetData($label_cursorinfo,$cursorinfo[0] & @CRLF & $cursorinfo[1] & @CRLF & $cursorinfo[2] & @CRLF & $cursorinfo[3] & @CRLF & $cursorinfo[4])

	If $cursorinfo[4] = $hImage1 Then
		ToolTip("Button Start erreicht!" & @CRLF & "ID: " & $hImage1,$mousepos[0],$mousepos[1])
	Else
		ToolTip("X: " & $cursorinfo[0] & @CRLF & "Y: " & $cursorinfo[1] & @CRLF & "Gesucht: " & $hImage1,$mousepos[0],$mousepos[1])
	EndIf
	Sleep(50)

	Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
	EndSwitch
WEnd


Func WM_PAINT($hWnd, $Msg, $wParam, $lParam)
    _GDIPlus_GraphicsDrawImageRect($hGraphic,$hImage1,10,10,200,200)
EndFunc   ;==>WM_PAINT

; Clean up resources
_GDIPlus_GraphicsDispose($hGraphic)
_GDIPlus_ImageDispose($hImage1)
_GDIPlus_ImageDispose($hImage2)
_GDIPlus_ShutDown()

