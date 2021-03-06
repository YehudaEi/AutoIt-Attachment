#Region - TimeStamp
; 2012-07-23 17:52:55
#EndRegion - TimeStamp
#Include <GDIPlus.au3>
#Include <GUIConstantsEx.au3>
#Include "MouseTrapCircle.au3"

_Main()

Func _Main()

	Local $hGui, $hPen, $hBrush1, $hBrush2, $hGraphic
	Local $iTop, $iSide, $sTitle = 'MouseTrapCircle'
	Local $fStart = False
	_SystemGetWindowBorder($iTop, $iSide)


	$hGui = GUICreate($sTitle & '  [OFF]', 300, 300, 400, 100)
	GUICtrlCreateLabel('Click inside circle to start/stop', 80, 50)
	GUISetState(@SW_SHOW, $hGui)

	_GDIPlus_Startup()
	$hPen     = _GDIPlus_PenCreate(0xFF0000FF)
	$hBrush1  = _GDIPlus_BrushCreateSolid(0xFFFFFACD)
	$hBrush2  = _GDIPlus_BrushCreateSolid(0xFFDD2233)
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
	_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)

	_GDIPlus_GraphicsFillCircleByCentre($hGraphic, 150, 150, 90, $hBrush1)
	_GDIPlus_GraphicsDrawCircleByCentre($hGraphic, 150, 150, 90, $hPen)

	While True
		Switch GUIGetMsg()
			Case -3
				_GDIPlus_PenDispose($hPen)
				_GDIPlus_BrushDispose($hBrush1)
				_GDIPlus_BrushDispose($hBrush2)
				_GDIPlus_GraphicsDispose($hGraphic)
				_GDIPlus_Shutdown()
				Exit
			Case $GUI_EVENT_PRIMARYUP
				Local $aMouse = MouseGetPos()
				Local $aWin   = WinGetPos($hGui)
				If _PointInCircle($aMouse[0], $aMouse[1], $aWin[0]+$iSide+150, $aWin[1]+$iTop+150, 45) Then
					$fStart = Not $fStart
					If $fStart Then
						WinSetTitle($hGui, '', $sTitle & '  [ON]')
						_GDIPlus_GraphicsFillCircleByCentre($hGraphic, 150, 150, 90, $hBrush2)
						_GDIPlus_GraphicsDrawCircleByCentre($hGraphic, 150, 150, 90, $hPen)
						_MouseTrapCircle(150, 150, 45, -1, $hGui)
					Else
						WinSetTitle($hGui, '', $sTitle & '  [OFF]')
						_MouseTrapCircle()
						_GDIPlus_GraphicsFillCircleByCentre($hGraphic, 150, 150, 90, $hBrush1)
						_GDIPlus_GraphicsDrawCircleByCentre($hGraphic, 150, 150, 90, $hPen)
					EndIf
				EndIf
		EndSwitch
	WEnd

EndFunc


Func _GDIPlus_GraphicsDrawCircleByCentre($_hGraphic, $_iX, $_iY, $_iDiameter, $_hPen=0)
    $_iX -= $_iDiameter/2
    $_iY -= $_iDiameter/2
    _GDIPlus_GraphicsDrawEllipse($_hGraphic, $_iX, $_iY, $_iDiameter, $_iDiameter, $_hPen)
EndFunc

Func _GDIPlus_GraphicsFillCircleByCentre($_hGraphic, $_iX, $_iY, $_iDiameter, $_hBrush=0)
    $_iX -= $_iDiameter/2
    $_iY -= $_iDiameter/2
	_GDIPlus_GraphicsFillEllipse($_hGraphic, $_iX, $_iY, $_iDiameter, $_iDiameter, $_hBrush)
EndFunc