#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>

Opt("MustDeclareVars", 1)

Global Const $AC_SRC_ALPHA = 1
Global $hGUI_Graphics
Global $hGUI_Border
;Global $hImageG1, $hImageScreen, $hImagePin, $hImageBorder
Global $hImageG1, $hImageScreen, $hImageNeedle, $hImageBorder
Global $hGUI, $TCPAccept = 10, $TCPListen, $TCPPrevious = 255, $TCPRecv

TCPStartup()
$TCPListen = TCPListen(@IPAddress1, 5000)

;Global $hPen, $radius = 80, $x = 160, $y = @DesktopHeight-15

Do
    $TCPAccept = TCPAccept($TCPListen)
Until $TCPAccept <> -1

$hGUI_Graphics = GUICreate("Graphics", @DesktopWidth, @DesktopHeight, -1, -1, -1, BitOR(BitOR($WS_EX_LAYERED,$WS_EX_TOPMOST),$WS_EX_TRANSPARENT))
GUISetState(@SW_SHOW)

$hGUI_Border = GUICreate("Border", @DesktopWidth, @DesktopHeight, -1, -1, -1, BitOR(BitOR($WS_EX_LAYERED,$WS_EX_TOPMOST),$WS_EX_TRANSPARENT))
GUISetState(@SW_SHOW)

_GDIPlus_Startup()
;$hPen = _GDIPlus_PenCreate(0xFFFF0000, 5)
$hImageG1 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\gauge1.png")
$hImageScreen = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\screen.png")
$hImageBorder = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\border.png")
$hImageNeedle = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\needle.png")

While 1
    $TCPRecv = TCPRecv($TCPAccept, 1000000)
	If $TCPRecv <> "" And $TCPRecv <> $TCPPrevious Then
        $TCPPrevious = $TCPRecv
        ConsoleWrite("What is recieved >> " & $TCPPrevious & @CRLF)
		If $TCPPrevious > $TCPPrevious +1 Then
			Do
				$TCPPrevious = $TCPPrevious + 1
			Until $TCPPrevious = $TCPRecv
		EndIf
		If $TCPPrevious < $TCPPrevious -1 Then
			Do
				$TCPPrevious = $TCPPrevious - 1
			Until $TCPPrevious = $TCPRecv
		EndIf
		Local $pkt1 = StringRight($TCPRecv, StringInStr($TCPRecv, "<Start>")+StringInStr($TCPRecv, ",",0,1)-1)
		Local $pkt2 = StringRight($TCPRecv, StringInStr($TCPRecv, "<Start>")+StringInStr($TCPRecv, ",",0,2)-1)
		Global $c12aa = Round(Number($pkt1*2.55))
		Global $c12ab = Round(Number($pkt2*2.55))
		Global $c12aap = $c12aa
		Global $c12abp = $c12ab
		Local $i = 0
		_Update()
    EndIf
    Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
            Exit
	EndSwitch
WEnd

_GDIPlus_ImageDispose($hImageG1)
_GDIPlus_ImageDispose($hImageScreen)
_GDIPlus_ImageDispose($hImageBorder)
_GDIPlus_ImageDispose($hImageNeedle)
;_GDIPlus_PenDispose($hPen)
_GDIPlus_Shutdown()

Func _Update()
    Local $iSliderValue = $c12abp
	Local $iSliderValuer = $c12aap
    Local $iSliderPerc = $c12aap/2.55
	Local $hBitmap = $hImageScreen
	Local $hBitmap2 = $hImageBorder

	Local $hGraphic2 = _GDIPlus_ImageGetGraphicsContext($hBitmap2)
    Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsDrawImage ($hGraphic, $hImageG1, 0, @DesktopHeight-225)
	_GDIPlus_GraphicsDrawImage ($hGraphic2, $hImageBorder, @DesktopWidth, @DesktopHeight)

	Local $hMatrix = _GDIPlus_MatrixCreate()
	_GDIPlus_MatrixTranslate($hMatrix,160,@DesktopHeight-15,True)
	_GDIPlus_MatrixRotate($hMatrix,($iSliderValue*.715)+130)
	_GDIPlus_GraphicsSetTransform($hGraphic, $hMatrix)
	_GDIPlus_MatrixDispose($hMatrix)
	_GDIPlus_GraphicsDrawImage ($hGraphic, $hImageNeedle, 0, 0)

	;Local $radian = (($iSliderValuer/255)+1) * 3.14159265358979
    ;_GDIPlus_GraphicsDrawLine($hGraphic, $x, $y, $x + Cos($radian) * $radius,$y +  Sin($radian) * $radius, $hPen)

    _GDIPlus_GraphicsDispose($hGraphic2)
    _GDIPlus_GraphicsDispose($hGraphic)

    Local $iTrans = Round(($iSliderValue))
    If $iTrans < 0 Then $iTrans = 0
	If $iTrans > 255 Then $iTrans = 255
	SetBitMap($hGUI_Border, $hBitmap2, 255)
    SetBitMap($hGUI_Graphics, $hBitmap, $iTrans)

    _WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteObject($hBitmap2)
EndFunc

Func SetBitmap($hGUI, $hImage, $iOpacity)
  Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
  $hScrDC  = _WinAPI_GetDC(0)
  $hMemDC  = _WinAPI_CreateCompatibleDC($hScrDC)
  $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
  $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
  $tSize   = DllStructCreate($tagSIZE)
  $pSize   = DllStructGetPtr($tSize  )
  DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
  DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
  $tSource = DllStructCreate($tagPOINT)
  $pSource = DllStructGetPtr($tSource)
  $tBlend  = DllStructCreate($tagBLENDFUNCTION)
  $pBlend  = DllStructGetPtr($tBlend)
  DllStructSetData($tBlend, "Alpha" , $iOpacity )
  DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
  _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
  _WinAPI_ReleaseDC   (0, $hScrDC)
  _WinAPI_SelectObject($hMemDC, $hOld)
  _WinAPI_DeleteObject($hBitmap)
  _WinAPI_DeleteDC  ($hMemDC)
EndFunc