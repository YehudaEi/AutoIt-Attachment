#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;--INCLUDES--
#include 'GlPluginUtils.au3'
#include <Misc.au3>
;<-----------

;--VARIABLES--
$PlayerPosX = 0
$PlayerPosZ = 0
$PlayerAngle = 0
$PlayerSpeed = 0.6
$UpDownSpeed = 0.025
$UpDownTrigger = "UP"
;<------------
;--DLL--
$userdll = DLLOpen("user32.dll")
;<------

;--OPTIONS--
AutoItSetOption( "TrayIconHide", 1 )
Opt( "WinTitleMatchMode", 3 )
$WinTitle = "BlockBuster"
;<----------


;--------OPENGL--------
;######################
;OpenGL Window
DefineGlWindow( $WinTitle, 800, 600 )
;Background Color
SetClearColor( 1.0, 1.0, 1.0 )
;Lights
CreateLight( 0, 300, 300, 300 )
SetLightAmbient( 0, 0.2, 0.2, 0.2 )
SetLightDiffuse( 0, 0.7, 0.7, 0.7 )
SetLightSpecular( 0, 1.0, 1.0, 1.0 )
;Camera
$xCam = 0 ;X Position of Camera
$yCam = -60 ;Y Position of Camera
$zCam = 80 ;Z Position of Camera
SetCamera( $xCam, $yCam, $zCam, 0, 40, 0 )
;Objects
$Player = ObjectCreate( )
$Ambient = ObjectCreate( )
;PLAYER
	$PlayerRed = 0.5
	$PlayerGreen = 0.5
	$PlayerBlue = 0.5
	$PlayerAlpha = 1.0
	$Body = AddCylinder( $Player, 0, -7, 0, 3, 2.5, 10, 10, 10, $PlayerRed, $PlayerGreen, $PlayerBlue, $PlayerAlpha )
	$EngineRight = AddCylinder( $Player, 2.9, -9, 0, 1.3, 1, 6, 10, 10, $PlayerRed, $PlayerGreen, $PlayerBlue, $PlayerAlpha )
	$EngineLeft = AddCylinder( $Player, -2.9, -9, 0, 1.3, 1, 6, 10, 10, $PlayerRed, $PlayerGreen, $PlayerBlue, $PlayerAlpha )
	$BackMain = AddPartialDisk( $Player, 0, -7, 0, 1, 3, 10, 3, 0, 360, $PlayerRed, $PlayerGreen, $PlayerBlue, $PlayerAlpha )
	$BackMainInner = AddPartialDisk( $Player, 0, -6, 0, 0, 2.8, 10, 3, 0, 360, 0.9, 0.1, 0.1, 1 )
	$BackRight = AddPartialDisk( $Player, 2.9, -9, 0, 0, 1, 10, 3, 0, 360, 0.9, 0.1, 0.1, 0.9 )
	$BackLeft = AddPartialDisk( $Player, -2.9, -9, 0, 0, 1, 10, 3, 0, 360, 0.9, 0.1, 0.1, 0.9 )
;--->END OF PLAYER
;AMBIENT
	$Street = AddCube( $Ambient, 70, 500, 0.01, 0.2, 0.2, 0.2, 1.0 )
;--->END OF AMBIENT
;--What to print on screen--
SetPrint( $Player )
SetPrint( $Ambient )
;<--------------------------
;--Set Position of Objects and Shapes at start--
	ObjectTranslate( $Player, -1, -1, -1)
	ShapeTranslate( $Ambient, $Street, -1, -1, -6)
;<----------------------------------------------
;###############################################
;<---------END OF OPENGL-------------------------


;--Hotkey Functions--
HotKeySet( "{ESC}", "ExitScript" )
;--------------------


WinWait( $WinTitle )
$CheckWindowTimer = TimerInit( )



;~ 	For $i = 1 To 10
;~ 		$Point = AddSphere( $Points[$i], Random(-25, 25), $PointsY[$i], 0, 3, 10, 10, 0.2, 0.95, 0.2, 1.0 )
;~ 	Next

;__________________________
;#######_GAMEPLAY_########
While 1

	If _IsPressed("41", $userdll) AND _IsPressed("44", $userdll) Then
		If $PlayerAngle < 0 Then
			$PlayerAngle = $Playerangle + 2
			ObjectRotate( $Player, -1, $PlayerAngle, -1 )
		ElseIf $PlayerAngle > 0 Then
			$PlayerAngle = $PlayerAngle - 2
			ObjectRotate( $Player, -1, $PlayerAngle, -1 )
		EndIf
	Else
		If _IsPressed("41", $userdll) Then
			If $PlayerAngle > 0 Then $PlayerAngle = $Playerangle - 4
			If $PlayerAngle > -35 Then
				$PlayerAngle = $PlayerAngle - 2
				ObjectRotate( $Player, -1, $PlayerAngle, -1 )
			EndIf
			If $PlayerPosX > -27.5 Then
				$PlayerPosX = $PlayerPosX - $PlayerSpeed
				ObjectTranslate( $Player, $PlayerposX, -1, $PlayerPosZ )
;~ 				ToolTip($PlayerPosX)
			EndIf
		ElseIf _IsPressed("44", $userdll) Then
			If $PlayerAngle < 0 Then $PlayerAngle = $Playerangle + 4
			If $PlayerAngle < 35 Then
				$PlayerAngle = $PlayerAngle + 2
				ObjectRotate( $Player, -1, $PlayerAngle, -1 )
			EndIf
			If $PlayerPosX < 25 Then
				$PlayerPosX = $PlayerPosX + $PlayerSpeed
				ObjectTranslate( $Player, $PlayerposX, -1, $PlayerPosZ )
;~ 				ToolTip($PlayerPosX)
			EndIf
		Else
			If $PlayerAngle < 0 Then
				$PlayerAngle = $Playerangle + 2
				ObjectRotate( $Player, -1, $PlayerAngle, -1 )
			ElseIf $PlayerAngle > 0 Then
				$PlayerAngle = $PlayerAngle - 2
				ObjectRotate( $Player, -1, $PlayerAngle, -1 )
			EndIf
		EndIf
	EndIf

	If _IsPressed( "46", $userdll ) Then
		If $zCam > 61 Then
			$zCam = $zCam - 0.35
			$yCam = $yCam + 0.25
		EndIf
		$UpDownSpeed = 0.08
;~ 		ToolTip($zCam&" "&$yCam)
		SetCameraPos( $xCam, $yCam, $zCam )
	Else
		If $zCam < 82 Then
			$zCam = $zCam + 0.35
			$yCam = $yCam - 0.25
		EndIf
		$UpDownSpeed = 0.025
;~ 		ToolTip($zCam&" "&$yCam)
		SetCameraPos( $xCam, $yCam, $zCam )
	EndIf

If $PlayerPosZ < 2.3 AND $UpDownTrigger = "UP" Then
	$PlayerPosZ = $PlayerposZ + $UpDownSpeed
	ObjectTranslate( $Player, $PlayerPosX, -1, $PlayerPosZ )
	If $PlayerPosZ > 2.2 Then $UpDownTrigger = "DOWN"
ElseIf $PlayerPosZ > 0 AND $UpDownTrigger = "DOWN" Then
	$PlayerPosZ = $PlayerposZ - $UpDownSpeed
	ObjectTranslate( $Player, $PlayerPosX, -1, $PlayerPosZ )
	If $PlayerPosZ < 0.15 Then $UpDownTrigger = "UP"
EndIf



;--Drawing of the Scene--
	SceneDraw( )
	Sleep( 3 )
;<-----------------------

;--End the program if window is removed--
	If TimerDiff( $CheckWindowTimer ) > 500 Then
		If WinExists( $WinTitle ) = 0 Then ExitScript()
		If WinActive( $WinTitle ) == 0 Then WinWaitActive( $WinTitle )
		$CheckWindowTimer = TimerInit( )
	EndIf
;<----------------------------------------
WEnd
;#######_GAMEPLAY END_########
;<----------------------------


;---FUNCTIONS---
;같같같같같같같�

Func ExitScript()
	DllClose($userdll)
	Exit
EndFunc

;같같같같같같같�
;<--------------
