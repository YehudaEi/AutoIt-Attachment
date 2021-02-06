#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Opt('MustDeclareVars', 1)

_Main_GDIPlus_approach()

;try GDI
_Main_GDI_approach()


Func _Main_GDIPlus_approach()
	Local $hGUI, $hGraphic, $hPen

	; Create GUI
	$hGUI = GUICreate("GDI+", 400, 300)
	GUISetState()

	; Draw line
	_GDIPlus_Startup ()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI)
	$hPen = _GDIPlus_PenCreate (0xFF000000)	;AARRGGBB format	AA=0x00 is fully transparent, AA=0xFF is fully opaque
	_GDIPlus_GraphicsDrawLine ($hGraphic, 90, 200, 100, 200, $hPen)
	_GDIPlus_GraphicsDrawLine ($hGraphic, 102, 200, 112, 200, $hPen)	;leave pixel 101,200 open

	$hPen = _GDIPlus_PenCreate (0xFFFF0000)	;AARRGGBB format
	_GDIPlus_GraphicsDrawLine ($hGraphic, 101, 201, 102, 201, $hPen)	;<---- problem here: 101 to 102 draws 2 pixels, 101 to 101 draws NONE
																		; how to draw a single pixel??

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; Clean up resources
	_GDIPlus_PenDispose ($hPen)
	_GDIPlus_GraphicsDispose ($hGraphic)
	_GDIPlus_Shutdown ()

EndFunc   ;_Main_GDIPlus_approach


Func _Main_GDI_approach()
	Local $hGUI, $hDC, $hPen, $obj_orig

	; Create GUI
	$hGUI = GUICreate("GDI", 400, 300)
	GUISetState()

    $hDC = _WinAPI_GetWindowDC($hGUI) ; DC of window
    $hPen = _WinAPI_CreatePen($PS_SOLID, 1, 0xff0000)	;caution $color format is BBGGRR
    $obj_orig = _WinAPI_SelectObject($hDC, $hPen)

	;Caution _WinAPI_DrawLine DOES NOT DRAW LAST PIXEL.  It draws up to but *not* end point
	;_WinAPI_DrawLine($hDC, 98, 200, 100, 200) ;x,y start  x,y end	should be 3 pixels, 98 99 100  IT's 2 pixels !! ONLY 98, 99

	;leave 101, 200 pixel location open
	_WinAPI_DrawLine($hDC, 90, 200, 101, 200) ;x,y start  x,y end	draws 90 to 100 NOT 101
	_WinAPI_DrawLine($hDC, 102, 200, 112, 200) ;x,y start  x,y end	draws 101 to 111

	$hPen = _WinAPI_CreatePen($PS_SOLID, 1, 0x0000FF)	;caution $color format is BBGGRR
	$obj_orig = _WinAPI_SelectObject($hDC, $hPen)
	_WinAPI_DrawLine($hDC, 101, 201, 102, 201) ;x,y start  x,y end	draws 1 pixel only at 101,201


; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; clear resources
    _WinAPI_SelectObject($hDC, $obj_orig)
    _WinAPI_DeleteObject($hPen)
    _WinAPI_ReleaseDC(0, $hDC)

EndFunc   ;_Main_GDI_approach

