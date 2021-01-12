#include <GUIConstants.au3>
#include <Misc.au3>
#include <Color.au3>

$RGWin = "Shoka Game Engine (Prototype 1, Window ID "&Random(1000,9999,1)&")"
$Win = "Shoka Game Engine"

$Colour1 = 0xFFFFFF
$Colour2 = 0x33337F

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Moi\My Documents\AutoIt\Projects\ShokaGameEngine\Prototype\SettingsWindow.kxf
$ShokaWIN = GUICreate("Shoka Game Engine", 634, 380, 193, 115)
GUICtrlCreateLabel("Shoka", 0, 0, 227, 94)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetFont(-1, 48, 800, 0, "Arial Black")
GUICtrlCreateLabel("Game Engine", 140, 63, 190, 47)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetFont(-1, 28, 400, 2, "Arial Narrow")
$Version = GUICtrlCreateLabel("Prototype 1 (Globe)", 240, 10, 81, 47, $SS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "Arial Narrow")
GUICtrlCreateLabel("Written by Paul Callender"&@Crlf&@Crlf&"Uses OpenGL Utility Toolkit"&@Crlf&"Plugin by A. Percy", 340, 0, 293, 57)
GUICtrlCreateLabel("Warning!", 350, 70, 55, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlCreateLabel("This is a prototype script, and may cause instability on some computers", 350, 90, 273, 37)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlCreateGroup("", 340, 60, 291, 71)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateLabel("Number of Stars", 10, 143, 80, 17, $SS_CENTERIMAGE)
$Stars = GUICtrlCreateSlider(100, 140, 420, 25, $TBS_NOTICKS)
GUICtrlSetLimit(-1, 1000, 0)
GUICtrlSetData(-1, 150)
$StarsValue = GUICtrlCreateLabel("150", 530, 143, 80, 17, $SS_CENTERIMAGE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("Star Color", 10, 185, 50, 17)
;$RedLabel1 = GUICtrlCreateLabel("Red", 100, 170, 140, 17, $SS_CENTER)
;GUICtrlSetColor(-1, 0xFF0000)
;$GreenLabel1 = GUICtrlCreateLabel("Green", 240, 170, 140, 17, $SS_CENTER)
;GUICtrlSetColor(-1, 0x00FF00)
;$BlueLabel1 = GUICtrlCreateLabel("Blue", 380, 170, 140, 17, $SS_CENTER)
;GUICtrlSetColor(-1, 0x0000FF)
$ColourLabel1 = GUICtrlCreateLabel("", 530, 170, 94, 50, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_CLIENTEDGE)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$ColourBtn1 = GUICtrlCreateButton("Choose Colour...",100,170,420,50)
;$RedSlider1 = GUICtrlCreateSlider(100, 190, 140, 25)
;GUICtrlSetLimit(-1, 255, 0)
;GUICtrlSetData(-1, 255)
;$GreenSlider1 = GUICtrlCreateSlider(240, 190, 140, 25)
;GUICtrlSetLimit(-1, 255, 0)
;GUICtrlSetData(-1, 255)
;$BlueSlider1 = GUICtrlCreateSlider(380, 190, 140, 25)
;GUICtrlSetLimit(-1, 255, 0)
;GUICtrlSetData(-1, 255)
GUICtrlCreateLabel("Planet Color", 10, 245, 61, 17)
;$RedLabel2 = GUICtrlCreateLabel("Red", 100, 230, 140, 17, $SS_CENTER)
;GUICtrlSetColor(-1, 0xFF0000)
;$GreenLabel2 = GUICtrlCreateLabel("Green", 240, 230, 140, 17, $SS_CENTER)
;GUICtrlSetColor(-1, 0x00FF00)
;$BlueLabel2 = GUICtrlCreateLabel("Blue", 380, 230, 140, 17, $SS_CENTER)
;GUICtrlSetColor(-1, 0x0000FF)
$ColourLabel2 = GUICtrlCreateLabel("", 530, 230, 94, 50, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_CLIENTEDGE)
GUICtrlSetBkColor(-1, 0x33337F)
$ColourBtn2 = GUICtrlCreateButton("Choose Colour...",100,230,420,50)
;$RedSlider2 = GUICtrlCreateSlider(100, 250, 140, 25)
;GUICtrlSetLimit(-1, 255, 0)
;GUICtrlSetData(-1, 255)
;$GreenSlider2 = GUICtrlCreateSlider(240, 250, 140, 25)
;GUICtrlSetLimit(-1, 255, 0)
;GUICtrlSetData(-1, 255)
;$BlueSlider2 = GUICtrlCreateSlider(380, 250, 140, 25)
;GUICtrlSetLimit(-1, 255, 0)
;GUICtrlSetData(-1, 255)
GUICtrlCreateLabel("Note:", 10, 300, 35, 27, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlCreateLabel("It is recommended to only set a high number of stars on fast computers. If your computer is particularly slow, set this slider to 75 or less.", 50, 300, 440, 27)
$CheckAdv = GUICtrlCreateCheckbox("Advanced Controls",500,300,123,27)
$QuitBtn = GUICtrlCreateButton("Quit", 10, 340, 301, 31, 0)
$LaunchBtn = GUICtrlCreateButton("Launch Engine", 320, 340, 301, 31, $BS_DEFPUSHBUTTON)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $QuitBtn
			Exit
		Case $LaunchBtn
			ExitLoop
		Case $ColourBtn1
			Global $Colour1 = _ChooseColor(2,0xFFFFFF,2)
			GUICtrlSetBkColor($ColourLabel1,$Colour1)
		Case $ColourBtn2
			Global $Colour2 = _ChooseColor(2,0x33337F,2)
			GUICtrlSetBkColor($ColourLabel2,$Colour2)
	EndSwitch
	If GUICtrlRead($Stars) <> GUICtrlRead($StarsValue) Then GUICtrlSetData($StarsValue,GUICtrlRead($Stars))
WEnd

If GUICtrlRead($CheckAdv) == $GUI_CHECKED Then
	Global $Advanced = True
Else
	Global $Advanced = False
EndIf
Global $Stars = GUICtrlRead($StarsValue)
GUIDelete()
	
ProgressOn($Win,"Preparing...","Loading A. Percy's GLUT Plugin...")
#include "GlPluginUtils.au3"
ProgressSet(10,"Creating Window...")
DefineGlWindow( @DesktopWidth, @DesktopHeight, $RGWin )
ProgressSet(20,"Adding Background...")
SetClearColor( 0, 0, 0 )

ProgressSet(30,"Creating Main Light...")
CreateLight( 0, 300, 300, 300 )
ProgressSet(40,"Setting Light Properties")
SetLightAmbient( 0, 0.2, 0.2, 0.2 )
SetLightDiffuse( 0, 0.7, 0.7, 0.7 )
SetLightSpecular( 0, 1.0, 1.0, 1.0 )

ProgressSet(50,"Creating Stars...")
SplashTextOn("Shoka GE Effects - Stars","",@DesktopWidth/4,@DesktopHeight/4,(@DesktopWidth/8)*3,(@DesktopHeight/8)*5,4)
For $i = 1 to $Stars
	Sleep(50)
	$a = Random(@DesktopWidth/-2,@DesktopWidth/2)
	$b = Random(@DesktopHeight/-2,@DesktopHeight/2)
	$c = Random(-500,0)
	ControlSetText("Shoka GE Effects - Stars","","Static1","Number: "&@Tab&$i&@Crlf&@Crlf&"X: "&@Tab&@Tab&$a&@Crlf&"Y: "&@Tab&@Tab&$b&@Crlf&"Z: "&@Tab&@Tab&$c&@Crlf&@Crlf&"Star:"&@Tab&@Tab&"Creating...")
	;_CreateCube("Star"&$i,$a,$b,$c,$a+3,$b+3,$c+3,_ColorGetRed($Colour1)/255,_ColorGetGreen($Colour1)/255,_ColorGetBlue($Colour1)/255,0.5)
	AddObject("Star"&$i)
	Dim $v1[3] = [$a+3,$b,$c]
	Dim $v2[3] = [$a,$b+6,$c]
	Dim $v3[3] = [$a+6,$b+6,$c]
	Dim $Normal[3] = [0,0,0]
	_AddTriangleEx("Star"&$i,$v1,$v2,$v3,$normal,_ColorGetRed($Colour1)/255,_ColorGetGreen($Colour1)/255,_ColorGetBlue($Colour1)/255,1)
	Dim $v1[3] = [$a,$b,$c]
	Dim $v2[3] = [$a+6,$b,$c]
	Dim $v3[3] = [$a+1.5,$b+6,$c]
	Dim $Normal[3] = [0,0,0]
	_AddTriangleEx("Star"&$i,$v1,$v2,$v3,$normal,_ColorGetRed($Colour1)/255,_ColorGetGreen($Colour1)/255,_ColorGetBlue($Colour1)/255,1)
	CreateLight($i,$a+1.5,$b+1.5,$c+6)
Next
SplashOff()

;_CreateCube( "Cube1", -30, 30, -30, 30, -30, 30 , 0.4, 0.4, 1.0, 1.0 )
;_CreateWireCube( "Cube1", -40, 40, -40, 40, -40, 40 , 1.0, 1.0, 0.4 )
;TranslateObject( "Cube1", -120, 0, 0 )

;_CreateCube( "Cube2", -40, 40, -40, 40, -40, 40 , 0.4, 1.0, 0.4, 1.0 )
;TranslateObject( "Cube2", 120, 0, 120 )

ProgressSet(60,"Creating Globe...")
AddObject( "Globe" )
;AddGlSphere( Name, X, Y, Z, Radius, Slices, Stacks, Red, Green, Blue, Alpha )
ProgressSet(70,"Setting Properties...")
AddGlSphere( "Globe", 0, 0, 0, @DesktopHeight/3, 60, 60, _ColorGetRed($Colour2)/255, _ColorGetGreen($Colour2)/255, _ColorGetBlue($Colour2)/255, 1.0 )
TranslateObject( "Globe", 0, 0, -120 )

ProgressSet(80,"Moving Camera...")
SetCamera( 0, 0, 0, 0, 0, 0 )

ProgressSet(90,"Initialising...")
GlMainLoop( )

Sleep(100)

ProgressSet(100,"Loading Defaults...")
$AY_Axis  = 0
$AX_Axis  = 0
$AZ_Axis  = 700
$AY2_Axis = 0
$AX2_Axis = 0
$AZ2_Axis = 0
$Y_Axis = $AY_Axis
$X_Axis = $AX_Axis
$Z_Axis = $AZ_Axis
$X2_Axis = $AX2_Axis
$Y2_Axis = $AY2_Axis
$Z2_Axis = $AZ2_Axis
RotateObject( "Globe", $X_Axis, $Y_Axis, 0 )
SetCamera(0,0,$Z_Axis,0,0,$Z2_Axis)
ProgressOff()
SplashTextOn("Shoka Game Engine Globe Axis",$Y_Axis&" "&$X_Axis&" "&$Z_Axis&" "&$Y2_Axis&" "&$X2_Axis&" "&$Z2_Axis,@DesktopWidth,40,0,@DesktopHeight-40,1)
While WinExists($RGWin)
	sleep( 10 )
	If _IsPressed("25") Then $X_Axis -= 10
	If _IsPressed("26") Then $Y_Axis += 10
	If _IsPressed("27") Then $X_Axis += 10
	If _IsPressed("28") Then $Y_Axis -= 10
	If _IsPressed("21") Then $Z_Axis -= 10
	If _IsPressed("22") Then $Z_Axis += 10
	If _IsPressed("41") Then $X2_Axis -= 10
	If _IsPressed("57") Then $Y2_Axis += 10
	If _IsPressed("44") Then $X2_Axis += 10
	If _IsPressed("53") Then $Y2_Axis -= 10 
	If _IsPressed("01") Then $Z2_Axis += 10
	If _IsPressed("02") Then $Z2_Axis -= 10
	If _IsPressed("25") and _IsPressed("27") Then $X_Axis = $AX_Axis
	If _IsPressed("26") and _IsPressed("28") Then $Y_Axis = $AY_Axis
	If _IsPressed("21") and _IsPressed("22") Then $Z_Axis = $AZ_Axis
	If _IsPressed("41") and _IsPressed("44") Then $X2_Axis = $AX2_Axis
	If _IsPressed("57") and _IsPressed("53") Then $Y2_Axis = $AY2_Axis
	If _IsPressed("01") and _IsPressed("02") Then $Z2_Axis = $AZ2_Axis
	If $Z_Axis < 150 Then $Z_Axis = 150
	If $Advanced == False Then
		RotateObject( "Globe", $X_Axis, $Y_Axis, 0 )
		SetCamera(0,0,$Z_Axis,0,0,0)
	ElseIf $Advanced == True Then
		SetCamera($X_Axis,$Y_Axis,$Z_Axis,$X2_Axis,$Y2_Axis,$Z2_Axis)
	EndIf
	$text = "X: "&$X_Axis&", Y: "&$Y_Axis&", Z: "&$Z_Axis&",  X2: "&$X2_Axis&", Y2: "&$Y2_Axis&", Z2:"&$Z2_Axis&@CRLF&"Arrow L/R = X, Arrow U/D = Y, PgUp/PgDn = Z, A/D = X2, W/S = Y2, Mouse L/R = Z2"
	If ControlGetText("Shoka Game Engine Globe Axis","","Static1") <> $text Then ControlSetText("Shoka Game Engine Globe Axis","","Static1",$text)
Wend
ControlSetText(SplashTextOn($Win,""),"","Static1","Shoka Game Engine is being developed by Paul Callender as a reproduction of the Populous: The Beginning engine. This prototype illustrates the possibility of the 'World View'."&@Crlf&@Crlf&"                                                        "&@Crlf&"                                    "&@Crlf&"                                 "&@Crlf&"                                                          ")
Sleep(5000)
PluginClose($GLPluginHandle)
SplashOff()