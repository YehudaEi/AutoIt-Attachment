#include <A3LGDIPlus.au3>

Opt("MustDeclareVars", 0)
Global Const $AC_SRC_ALPHA      = 1
Global Const $ULW_ALPHA         = 2

; Load PNG file as GDI bitmap
_GDIP_Startup()
$pngSrc = @scriptdir&"\au3_logo_alpha.png"
$hImage = _GDIP_ImageLoadFromFile($pngSrc)

; Extract image width and height from PNG
$width =  _GDIP_ImageGetWidth ($hImage)
$height = _GDIP_ImageGetHeight($hImage)

; Create layered window
$GUI = GUICreate("au3 logo test (Press ESC to close)", $width, $height, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
SetBitMap($GUI, $hImage, 0)
; Register notification messages
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
GUISetState()
WinSetOnTop($gui,"",1)
SetBitMap($GUI, $hImage, 255)

$controlGui = GUICreate("ControlGUI", $width, $height, 0,0,$WS_POPUP,BitOR($WS_EX_LAYERED,$WS_EX_MDICHILD),$gui)
GUICtrlCreatePic(-1,0,0,$width,$height)
GuiCtrlSetState(-1,$GUI_DISABLE)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd
GUIDelete($controlGui)
_API_DeleteObject($hImage)
_GDIP_Shutdown()

; ===============================================================================================================================
; Handle the WM_NCHITTEST for the layered window so it can be dragged by clicking anywhere on the image.
; ===============================================================================================================================
Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
  if ($hWnd = $GUI) and ($iMsg = $WM_NCHITTEST) then Return $HTCAPTION
EndFunc

; ===============================================================================================================================
; SetBitMap
; ===============================================================================================================================
Func SetBitmap($hGUI, $hImage, $iOpacity)
  Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

  $hScrDC  = _API_GetDC(0)
  $hMemDC  = _API_CreateCompatibleDC($hScrDC)
  $hBitmap = _GDIP_BitmapCreateHBITMAPFromBitmap($hImage)
  $hOld    = _API_SelectObject($hMemDC, $hBitmap)
  $tSize   = DllStructCreate($tagSIZE)
  $pSize   = DllStructGetPtr($tSize  )
  DllStructSetData($tSize, "X", _GDIP_ImageGetWidth ($hImage))
  DllStructSetData($tSize, "Y", _GDIP_ImageGetHeight($hImage))
  $tSource = DllStructCreate($tagPOINT)
  $pSource = DllStructGetPtr($tSource)
  $tBlend  = DllStructCreate($tagBLENDFUNCTION)
  $pBlend  = DllStructGetPtr($tBlend)
  DllStructSetData($tBlend, "Alpha" , $iOpacity    )
  DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
  _API_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
  _API_ReleaseDC   (0, $hScrDC)
  _API_SelectObject($hMemDC, $hOld)
  _API_DeleteObject($hBitmap)
  _API_DeleteDC    ($hMemDC)
EndFunc