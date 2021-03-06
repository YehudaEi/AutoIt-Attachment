#include "GLConstants.au3"
#include "GLFunctions.au3"
#include <Misc.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hGDI32 = DllOpen("gdi32.dll")
Global Const $hOPENGL32 = DllOpen("opengl32.dll")
Global Const $hGLU32 = DllOpen("glu32.dll")

Global Const $Pi = 3.14159265358979
Global $RotPos[2], $CPR[2] = [@DesktopWidth, @DesktopHeight]; cycles per revolution
Global $MouseDownRight[3] = [False,0,0]
Global $Camera[6] = [0,-5, 0, 0, -4, 0]
Global $FoVAngle = 40, $DrawDistance = 1000
Global $Speed = 50
InitColourStructs()

; Create GUI
Global $iWidth = @DesktopWidth - 100
Global $iHeight = @DesktopHeight - 100
Global $hGUI = GUICreate("GL GUI", $iWidth, $iHeight)

; Enable OpenGL
Global $hDC, $hRC ; device context and rendering context
If Not EnableOpenGL($hGUI, $hDC, $hRC) Then
	MsgBox(48, "Error", "Error initializing usage of OpenGL functions" & @CRLF & "Error code: " & @error)
	Exit
EndIf
GLViewport(0, 0, $iWidth, $iHeight) ; position the view
GLMatrixMode($GL_PROJECTION); initialize 3d projection
GLLoadIdentity()
GluPerspective($FoVAngle, $iWidth/$iHeight, 0.001, $DrawDistance)
GLMatrixMode($GL_MODELVIEW);set to modelview for rest of program
GLEnable($GL_LIGHTING);enable Lighting
GLDepthFunc($GL_LEQUAL);set the Depth Function
GLEnable($GL_DEPTH_TEST);enable Depth Testing
GLShadeModel($GL_SMOOTH);use Smooth shading
GLPointSize(5);set point size

GUISetOnEvent(-3, "Terminate", $hGUI) ; on exit
GUISetState(@SW_SHOW, $hGUI)

Global $pQuadratic = GluNewQuadric()
GLNewList(1, $GL_COMPILE)
	For $i = 0 To 999;make 1000 randomly located sphere's
		GLTranslatef(Random(-10,10), Random(-10,10), Random(-10,10))
		GluSphere($pQuadratic, 1, 16, 16)
	Next
GLEndList()
GLNewList(2, $GL_COMPILE)
	For $i = 0 To 999;make 1000 randomly located and sized triangles
		GLTranslatef(Random(-10,10), Random(-10,10), Random(-10,10))
		GLBegin($GL_TRIANGLES);
			GLVertex3f(Random(-10,10), Random(-10,10), Random(-10,10));
			GLVertex3f(Random(-10,10), Random(-10,10), Random(-10,10));
			GLVertex3f(Random(-10,10), Random(-10,10), Random(-10,10));
		GLEnd( );
	Next
GLEndList()

Global $SyncTimer = TimerInit()
$RotPos[0] = 0
$RotPos[1] = $CPR[1]/2
While 1
	UpdateCamera()
	GLDraw()
;~ 	ToolTip("X: "&$Camera[0]&@CR&"Y: "&$Camera[1]&@CR&"Z: "&$Camera[2], 0, 0)
WEnd
Func UpdateCamera()
	Local $Sync = TimerDiff($SyncTimer) / 1000
	If _IsPressed(02) Then;if right mouse is pressed;
		;If on screen needed to add in						##########################################
		If $MouseDownRight[0] Then
			$RotPos[0] += (@DesktopWidth/2) - MouseGetPos(0)
			$RotPos[1] += (@DesktopHeight/2) - MouseGetPos(1)
			If $RotPos[1] < 1 Then 
				$RotPos[1] = 1
			ElseIf $RotPos[1] > $CPR[1] - 1 Then 
				$RotPos[1] = $CPR[1] - 1
			EndIf
			If $RotPos[0] < 0 Then 
				$RotPos[0] += $CPR[0]
			ElseIf $RotPos[0] > $CPR[0] - 1 Then 
				$RotPos[0] -= $CPR[0]
			EndIf
			MouseMove(@DesktopWidth/2, @DesktopHeight/2, 0)
		Else
			$MouseDownRight[0] = True
			$MouseDownRight[1] = MouseGetPos(0)
			$MouseDownRight[2] = MouseGetPos(1)
			GUISetCursor(16);hide mouse
			MouseMove(@DesktopWidth/2, @DesktopHeight/2, 0)
		EndIf
	Else
		If $MouseDownRight[0] Then 
			$MouseDownRight[0] = False
			MouseMove($MouseDownRight[1], $MouseDownRight[2], 0)
			GUISetCursor(2);show mouse
		EndIf
	EndIf
 	If _IsPressed(57) Then;if w is pressed move cam forward
		$Camera[0] += (Cos(($RotPos[0]/$CPR[0])*2*$Pi) * Cos((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2)) * $Speed * $Sync
		$Camera[1] += (Sin(($RotPos[0]/$CPR[0])*2*$Pi) * Cos((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2)) * $Speed * $Sync
		$Camera[2] += ((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2) * $Speed * $Sync
	EndIf
	If _IsPressed(53) Then;if s is pressed move cam backward
		$Camera[0] -= (Cos(($RotPos[0]/$CPR[0])*2*$Pi) * Cos((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2)) * $Speed * $Sync
		$Camera[1] -= (Sin(($RotPos[0]/$CPR[0])*2*$Pi) * Cos((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2)) * $Speed * $Sync
		$Camera[2] -= ((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2) * $Speed * $Sync
	EndIf
	If _IsPressed(41) Then;if a is pressed rotate cam left
		$RotPos[0] += 10
;~ 		$Camera[0] += (Cos((($RotPos[0]+$CPR[0]/4)/$CPR[0])*2*$Pi)) * $Speed * $Sync;Works but adds up with forward/backward motion. need to restrict
;~ 		$Camera[1] += (Sin((($RotPos[0]+$CPR[0]/4)/$CPR[0])*2*$Pi)) * $Speed * $Sync;combine forward/backward and set vector to ($RotPos[0]+$CPR[0]/8) maybe?
	EndIf
	If _IsPressed(44) Then;if d is pressed rotate cam right
		$RotPos[0] -= 10
;~ 		$Camera[0] += (Cos((($RotPos[0]-$CPR[0]/4)/$CPR[0])*2*$Pi)) * $Speed * $Sync;Works but adds up with forward/backward motion. need to restrict
;~ 		$Camera[1] += (Sin((($RotPos[0]-$CPR[0]/4)/$CPR[0])*2*$Pi)) * $Speed * $Sync;combine forward/backward and set vector to ($RotPos[0]-$CPR[0]/8) maybe?
	EndIf
	
	$Camera[3] = $Camera[0] + (Cos(($RotPos[0]/$CPR[0])*2*$Pi) * Cos((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2))
	$Camera[4] = $Camera[1] + (Sin(($RotPos[0]/$CPR[0])*2*$Pi) * Cos((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2))
	$Camera[5] = $Camera[2] + ((((($RotPos[1]+1)/($CPR[1]+2))*2)-1)*$Pi/2)
;~ 	ToolTip($RotPos[0]&@CR&$RotPos[1], 10, 10)
;~ 	ToolTip(Round(1/$Sync)&" FPS", 10, 10)
	$SyncTimer = TimerInit()
EndFunc
Func GLDraw()
	GLClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT));clean buffers
	GLClearColor(0.75, 0.75, .75, 1);grey Background
	
	
	GLLoadIdentity()
	GluLookAt(	$Camera[0], $Camera[1], $Camera[2], _
				$Camera[3], $Camera[4], $Camera[5], _
				0, 0, 1)
	GLPolygonMode($GL_FRONT_AND_BACK, $GL_LINE)
	GLMaterialfv($GL_FRONT_AND_BACK, $GL_EMISSION, $pBlue)
	GLCallList(1)
	
	GLLoadIdentity()
	GluLookAt(	$Camera[0], $Camera[1], $Camera[2], _
				$Camera[3], $Camera[4], $Camera[5], _
				0, 0, 1)
	GLPolygonMode($GL_FRONT_AND_BACK, $GL_POINT)
	GLMaterialfv($GL_FRONT_AND_BACK, $GL_EMISSION, $pRED)
	GLCallList(1)

	
	GLLoadIdentity()
	GluLookAt(	$Camera[0], $Camera[1], $Camera[2], _
				$Camera[3], $Camera[4], $Camera[5], _
				0, 0, 1)
	GLPolygonMode($GL_FRONT_AND_BACK, $GL_LINE)
	GLMaterialfv($GL_FRONT_AND_BACK, $GL_EMISSION, $pRED)
	GLCallList(2)
	
	GLLoadIdentity()
	GluLookAt(	$Camera[0], $Camera[1], $Camera[2], _
				$Camera[3], $Camera[4], $Camera[5], _
				0, 0, 1)
	GLPolygonMode($GL_FRONT_AND_BACK, $GL_POINT)
	GLMaterialfv($GL_FRONT_AND_BACK, $GL_EMISSION, $pBLUE)
	GLCallList(2)
	
	
	SwapBuffers($hDC)
EndFunc   ;==>GLDraw

Func Terminate()
	DisableOpenGL($hGUI, $hDC, $hRC)
	Exit
EndFunc   ;==>Terminate






Func InitColourStructs()
	Global $tBLUE = DllStructCreate("float[4]")
	DllStructSetData($tBLUE, 1, 0, 1)
	DllStructSetData($tBLUE, 1, 0, 2)
	DllStructSetData($tBLUE, 1, 1, 3)
	DllStructSetData($tBLUE, 1, 1, 4)
	Global $pBLUE = DllStructGetPtr($tBLUE)

	Global $tRED = DllStructCreate("float[4]")
	DllStructSetData($tRED, 1, 1, 1)
	DllStructSetData($tRED, 1, 0, 2)
	DllStructSetData($tRED, 1, 0, 3)
	DllStructSetData($tRED, 1, 1, 4)
	Global $pRED = DllStructGetPtr($tRED)
	
	Global $tGREEN = DllStructCreate("float[4]")
	DllStructSetData($tGREEN, 1, 0, 1)
	DllStructSetData($tGREEN, 1, 1, 2)
	DllStructSetData($tGREEN, 1, 0, 3)
	DllStructSetData($tGREEN, 1, 1, 4)
	Global $pGREEN = DllStructGetPtr($tGREEN)
EndFunc