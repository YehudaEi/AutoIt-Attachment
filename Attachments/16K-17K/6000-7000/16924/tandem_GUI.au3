;
;	_trids_GL3.au3
;		Controlling the window from a GUI console
;		adding zoom
;

#include <GUIConstants.au3>

	Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=d:\_#www\autoit - goodies\koda forms - 1.7.0.0\koda_1.7.0.0\forms\gl_console.kxf
	$frmGLconsole = GUICreate("GL Console", 323, 279, 588, 437)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_frmGLconsole_Close")
	$chkAnimate = GUICtrlCreateCheckbox("Animate", 8, 8, 97, 17)
		GUICtrlSetState(-1, $GUI_CHECKED)
	$sldAnimate = GUICtrlCreateSlider(112, 5, 206, 21)
		GUICtrlSetLimit(-1, 100, 1)
		GUICtrlSetData(-1, 75)
		GUICtrlSetOnEvent(-1, "_sldAnimate_Change")
	$btnQuit = GUICtrlCreateButton("Quit", 232, 240, 75, 25)
		GUICtrlSetOnEvent(-1, "_btnQuit_Click")
	$AGroup1 = GUICtrlCreateGroup("Perspective", 8, 40, 305, 81)
		$sldZoom = GUICtrlCreateSlider(10, 63, 126, 21)
			GUICtrlSetLimit(-1, 100, -100)
			GUICtrlSetOnEvent(-1, "_sldZoom_Change")
			GUICtrlSetTip(-1, "Zoom (L=OUT, R=IN)")
		$optEyeL = GUICtrlCreateRadio("Left Eye", 149, 63, 65, 17)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "_optEyeL_Click")
		$optEyeR = GUICtrlCreateRadio("Right Eye", 221, 63, 73, 17)
			GUICtrlSetOnEvent(-1, "_optEyeR_Click")
		$txtX = GUICtrlCreateInput("", 32, 90, 49, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL))
		$Label1 = GUICtrlCreateLabel("X=", 16, 94, 17, 17)
		$Label2 = GUICtrlCreateLabel("Y=", 86, 94, 17, 17)
		$txtY = GUICtrlCreateInput("", 102, 90, 49, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL))
		$Label3 = GUICtrlCreateLabel("Z=", 156, 94, 17, 17)
		$txtZ = GUICtrlCreateInput("", 172, 90, 49, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL))
		$Button1 = GUICtrlCreateButton("Apply Coords", 232, 88, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$AGroup2 = GUICtrlCreateGroup("Future Features", 8, 128, 305, 97)
		$ALabel4 = GUICtrlCreateLabel("Binocular vision (3D, using two concurrent persepctives", 17, 174, 266, 17)
		$ALabel3 = GUICtrlCreateLabel("PAN controls", 17, 153, 66, 17)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



#include "GlPluginUtils.au3"
#Include <Misc.au3>

Global $nPi = 3.14159265358979
Global $nToRad = $nPi / 180

;prep
	$Title = "My World"
	
;define window
	DefineGlWindow( 400, 300, $Title )
	
;set back color
	SetClearColor( 0.72, 0.82, 0.95 )

;create light 0
	CreateLight( 0, 900, 900, 900 )
	SetLightAmbient( 0, 0.2, 0.2, 0.2 )
	SetLightDiffuse( 0, 0.7, 0.7, 0.7 )
	SetLightSpecular( 0, 0.9, 0.9, 0.9 )

;make some objects...
;make some objects...
;make some objects...

;Horizontal plane	
	$oHoriz = ObjectCreate()
		$shpPlane = AddCube( $oHoriz,		220,220,2, 	.7, .5, 0, 		1 )
		TextureSetBuffer( 2 )
		TextureAdd( "Au3", @ScriptDir & "\data\au3.bmp" )
		TextureSetMode( )
		TextureBind( $oHoriz, $shpPlane, "Au3" )
	SetPrint( $oHoriz )
	
;Create platform
	$oPlatform = ObjectCreate()
		AddCube( $oPlatform,		50, 50, 10, 	0, .5, .1, 	1 )			
		ObjectTranslate( $oPlatform, 0, 0, 20 )
	SetPrint( $oPlatform )

;Create floating widgets
	$oWidget = ObjectCreate()
		$shpSphere1	= AddSphere( $oWidget,		0, 0, 0,	10, 12, 12, 	1, 0, 0, 	1)	; orb component
		$shpSphere2	= AddSphere( $oWidget,		0, 0, 0,	10, 12, 12, 	0, 0, 1, 	1)	; orb component
		$shpCube 	= AddCube( $oWidget,		20, 20, 20,		1, 1, 0, 	1)	; orb component
		ShapeTranslate( $oWidget, $shpSphere1, 0, 0, -25 )
		ShapeTranslate( $oWidget, $shpSphere2, 0, 0, 25 )
		ObjectTranslate( $oWidget, 0, 0, 70 )
	SetPrint( $oWidget )

;... make some objects
;... make some objects
;... make some objects



;Set point of view
	SetCameraUp( 0, 0, 1 )
	SetCameraView( 1, 3000 )	; Near, far limits
	
	WinWait( $Title )







;Animate
	_sldAnimate_Change()
	$nJ			= 0
	$nK			= 0
	$nDeg_cam	= 0
	;$nRad_cam	= 100
	$nUpDn		= 1
	While 1
		SceneDraw( )
		sleep( _nSleep() )
		If _ynAnimate() Then
			$nJ += 1
			$nK += $nUpDn	
			;Toggle $nUpDn for vertical movement
			If $nK = 300 Or $nK = -50 Then $nUpDn *= -1

			$nDeg_Cam += 1
			$nDeg_cam = Mod( $nDeg_cam, 360 ) ;Then $nDeg_cam = 0

			$nRad_cam = 200 + $nK
			$nX_cam = $nRad_cam * Sin( _Rads( 90-$nDeg_Cam ) ) 
			$nY_cam = $nRad_cam * Sin( _Rads( $nDeg_Cam ) )
			$nZ_cam = $nK

			ObjectRotate( $oWidget, 	0 , $nJ, $nJ*4)

		Endif
		_RefreshXYZ($nX_cam, $nY_cam, $nZ_cam)
		;Check Exit
		if not WinExists($Title) then Exit
	Wend

Func _Rads($pDeg)
	Return $pDeg * $nToRad
EndFunc


While 1
	Sleep(100)
WEnd
		
Func _btnQuit_Click()
	Exit
EndFunc

		
Func _nSleep()
	Return Int( 50 * ( 1 - GuiCtrlRead($sldAnimate) / 100 ) )
EndFunc

		
Func _ynAnimate()
	If GuiCtrlRead($chkAnimate)	= $GUI_CHECKED Then
		Return True
	Else
		Return False
	Endif	
EndFunc

		
Func _sldAnimate_Change()
	;Update the pct display
	GUICtrlSetData( $chkAnimate, "Animate (" & GuiCtrlRead($sldAnimate) & "%)")
EndFunc

		
Func _sldZoom_Change()
;This just resets the zoom to 0 when the user lets go of the control.
;.. Until he lets go, the value is used in 
	GUICtrlSetData( $sldZoom, 0)
EndFunc

		
Func _frmGLconsole_Close()
	_btnQuit_Click()
EndFunc

		
Func _optEyeL_Click()

EndFunc

		
Func _optEyeR_Click()

EndFunc

Func _RefreshXYZ($pnX, $pnY, $pnZ)
;refreshes the GUI feedback of the X;Y;Z coords
Local $nZoom
	
	GUICtrlSetData( $txtX, $pnX)
	GUICtrlSetData( $txtY, $pnY)
	GUICtrlSetData( $txtZ, $pnZ)
	;apply the zoom factor
	$nZoom = 1 + GuiCtrlRead($sldZoom) / 100	
	SetCamera( $nX_cam * $nZoom, $nY_cam * $nZoom, $nZ_cam * $nZoom, 	0, 0, 50 )
EndFunc


