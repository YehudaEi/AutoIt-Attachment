;========================================
; Author: Toady
;
; Mousehook DLL: Larry
; GDI Library: PaulIA
;
; Example desktop zoom using mouse scroll
; and GDI+
;========================================
#include <A3LScreenCap.au3>
#include <misc.au3>
#include <GuiConstants.au3>
#include <A3LGDIPlus.au3>

_Singleton("zoom")

Opt("RunErrorsFatal",0)

Global Const $DESTW = 200 ;width of zoom box
Global Const $DESTH = 200 ;height of zoom box
Global Const $BASE_BOX_SIZE = 20 ;max zoom box is 40x40 pixels
Global $title = "Mouse zoom"
Global $refresh = Floor(1000/@DesktopRefresh) ;no flicker
Global $zoom_level = 5 ;Initial zoom

$GUI = GUICreate($title,200,230,-1,-1)
$label_zoom = GUICtrlCreateLabel("Zoom: 1x",70,205,100)
GUICtrlSetFont (-1,12, 400, Default, "Comic Sans MS")
GUISetState(@SW_SHOW,$GUI)
WinSetOnTop ($title,"",1)
_HookMouse($GUI) ;hook mouse scroll for zooming

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			_UnHookMouse()
			_GDIP_ShutDown()
			Exit
	EndSelect
WEnd

Func _GetIMG($hWndGUI, $MsgID, $WParam, $LParam)
	Local $x = BitAND($LParam,0x0000FFFF) ;Get mouses x coord
	Local $y = BitShift($LParam,16) ;Get mouses y coord
	Local $currentZoom = $BASE_BOX_SIZE*$zoom_level ;The "+-" for the screen capture
	_GDIP_StartUp() ;Start GDI
	$BITMAP_H = _ScreenCap_Capture("",$x-$currentZoom,$y-$currentZoom,$x+$currentZoom,$y+$currentZoom)
	$hImage  = _GDIP_BitmapCreateFromHBITMAP($BITMAP_H)
	$hGraphic = _GDIP_GraphicsCreateFromHWND($gui)
	_GDIP_GraphicsSetSmoothingMode($hGraphic, 0)
	$iWidth  = _GDIP_ImageGetWidth ($hImage)
	$iHeight = _GDIP_ImageGetHeight($hImage)
	_GDIP_GraphicsDrawImageRectRect($hGraphic, $hImage, 0, 0,$iWidth,$iHeight,0,0,$DESTW ,$DESTH)
	_GDIP_GraphicsDispose($hGraphic)
	_GDIP_ImageDispose($hImage)
	_API_DeleteObject($BITMAP_H)
	_UnHookMouse()
	Sleep($refresh)
	_HookMouse($hWndGUI)
EndFunc

Func _HookMouse($gui)
	Global $DLLinst = DLLCall("kernel32.dll","hwnd","LoadLibrary","str",".\hook.dll")
	Global $mouseHOOKproc = DLLCall("kernel32.dll","hwnd","GetProcAddress","hwnd",$DLLInst[0],"str","MouseProc")
	Global $hhMouse = DLLCall("user32.dll","hwnd","SetWindowsHookEx","int",7, _
				"hwnd",$mouseHOOKproc[0],"hwnd",$DLLinst[0],"int",0)
	DLLCall(".\hook.dll","int","SetValuesMouse","hwnd",$gui,"hwnd",$hhMouse[0])
	GUIRegisterMsg(0x1400 + 0x0D30, "_Zoom") ;mouse wheel up
	GUIRegisterMsg(0x1400 + 0x0D31, "_Zoom") ;mouse wheel down
	GUIRegisterMsg(0x1400 + 0x0F30,"_GetIMG") ;mouse move
EndFunc

Func _Zoom($hWndGUI, $MsgID, $WParam, $LParam)
		If $MsgID = 8496 And $zoom_level > 1 Then ;scroll up
			$zoom_level -= 1
		ElseIf $MsgID = 8497 And $zoom_level < 5 Then;scroll down
			$zoom_level += 1
		EndIf
		GUICtrlSetData($label_zoom,"Zoom: " & 6-$zoom_level & "x")
		_GetIMG($hWndGUI, $MsgID, $WParam, $LParam) ;zoom while mouse being still
EndFunc

Func _UnHookMouse()
	DLLCall("user32.dll","int","UnhookWindowsHookEx","hwnd",$hhMouse[0])	
    DLLCall("kernel32.dll","int","FreeLibrary","hwnd",$DLLinst[0])
EndFunc