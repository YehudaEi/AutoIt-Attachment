#NoTrayIcon

Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)


; Used Dlls
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hGDI32 = DllOpen("gdi32.dll")
Global Const $hOPENGL32 = DllOpen("opengl32.dll")

; General constants
Global Const $PFD_TYPE_RGBA = 0
Global Const $PFD_MAIN_PLANE = 0
Global Const $PFD_DOUBLEBUFFER = 1
Global Const $PFD_DRAW_TO_WINDOW = 4
Global Const $PFD_SUPPORT_OPENGL = 32

; Used GL constants. See OpenGLConstants.au3
Global Const $GL_VERSION_1_1 = 1
Global Const $GL_COLOR_BUFFER_BIT = 0x00004000
Global Const $GL_TRIANGLES = 0x0004
Global Const $GL_BLEND = 0x0BE2
Global Const $GL_ONE = 1
Global Const $GL_DEPTH_BUFFER_BIT = 0x00000100

; Create GUI
Global $iWidth = 450
Global $iHeight = 450
Global $hGUI = GUICreate("OpenGL 3D Rotation", $iWidth, $iHeight)

GUISetBkColor(0) ; black


; Enable OpenGL
Global $hDC, $hRC ; device context and rendering context

If Not _EnableOpenGL($hGUI, $hDC, $hRC) Then
	MsgBox(48, "Error", "Error initializing usage of OpenGL functions" & @CRLF & "Error code: " & @error)
	Exit
EndIf

; Prepare things
_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; initially cleaning buffers in case something is left there

; About blending (not needed but to show it)
_glEnable($GL_BLEND) ; enable GL_BLEND
_glBlendFunc($GL_ONE, $GL_ONE) ; blending fashion

_glViewport(0, 0, $iWidth, $iHeight) ; position the view


; To keep it 'full' all the time
GUIRegisterMsg(133, "_Preserve") ; WM_NCPAINT

; Handle exit
GUISetOnEvent(-3, "_Quit") ; on exit


; Show GUI
GUISetState(@SW_SHOW, $hGUI)


Global $nM ; this to use for rotation


; Loop and draw till exit
While 1

	_GLDraw()
	Sleep(20)

WEnd



; Main drawing function
Func _GLDraw()

	_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; cleaning buffers

	$nM -= 0.5 ; decreasing. To rotate otherwise do increasing

	_glPopMatrix()
	_glPushMatrix()

	_glRotatef($nM, 1, 1, 1) ; this is actual rotation

	_glBegin($GL_TRIANGLES) ; draw triangle

	; Will make square pyramid
	_glColor3f(0.5, 0, 0) ; red nuance
	_glVertex3f(0, 0.5, 0) ; front top
	_glColor3f(0, 0.5, 0) ; green nuance
	_glVertex3f(-0.5, -0.5, 0.5) ; front left
	_glColor3f(0, 0, 0.5) ; blue nuance
	_glVertex3f(0.5, -0.5, 0.5) ; front right

	_glColor3f(0.5, 0, 0) ; red nuance
	_glVertex3f(0, 0.5, 0) ; top right
	_glColor3f(0, 0, 0.5) ; blue nuance
	_glVertex3f(0.5, -0.5, 0.5) ; left right
	_glColor3f(0, 0.5, 0); green nuance
	_glVertex3f(0.5, -0.5, -0.5) ; right right

	_glColor3f(0.5, 0, 0) ; red nuance
	_glVertex3f(0, 0.5, 0) ; top back
	_glColor3f(0, 0.5, 0) ; green nuance
	_glVertex3f(0.5, -0.5, -0.5) ; left back
	_glColor3f(0, 0, 0.5) ; blue nuance
	_glVertex3f(-0.5, -0.5, -0.5) ; right back

	_glColor3f(0.5, 0, 0) ; red nuance
	_glVertex3f(0, 0.5, 0) ; top left
	_glColor3f(0, 0, 0.5) ; blue nuance
	_glVertex3f(-0.5, -0.5, -0.5) ; left left
	_glColor3f(0, 0.5, 0) ; green nuance
	_glVertex3f(-0.5, -0.5, 0.5) ; right left
	; That's it

	_glEnd() ; end drawing

	_SwapBuffers($hDC) ; "refresh"

EndFunc   ;==>_GLDraw



; USED FUNCTIONS

; This is needed for initialization
Func _EnableOpenGL($hWnd, ByRef $hDeviceContext, ByRef $hOPENGL32RenderingContext)

	Local $tPIXELFORMATDESCRIPTOR = DllStructCreate("ushort Size;" & _
			"ushort Version;" & _
			"dword Flags;" & _
			"ubyte PixelType;" & _
			"ubyte ColorBits;" & _
			"ubyte RedBits;" & _
			"ubyte RedShift;" & _
			"ubyte GreenBits;" & _
			"ubyte GreenShift;" & _
			"ubyte BlueBits;" & _
			"ubyte BlueShift;" & _
			"ubyte AlphaBits;" & _
			"ubyte AlphaShift;" & _
			"ubyte AccumBits;" & _
			"ubyte AccumRedBits;" & _
			"ubyte AccumGreenBits;" & _
			"ubyte AccumBlueBits;" & _
			"ubyte AccumAlphaBits;" & _
			"ubyte DepthBits;" & _
			"ubyte StencilBits;" & _
			"ubyte AuxBuffers;" & _
			"ubyte LayerType;" & _
			"ubyte Reserved;" & _
			"dword LayerMask;" & _
			"dword VisibleMask;" & _
			"dword DamageMask")

	DllStructSetData($tPIXELFORMATDESCRIPTOR, "Size", DllStructGetSize($tPIXELFORMATDESCRIPTOR))
	DllStructSetData($tPIXELFORMATDESCRIPTOR, "Version", $GL_VERSION_1_1)
	DllStructSetData($tPIXELFORMATDESCRIPTOR, "Flags", BitOR($PFD_DRAW_TO_WINDOW, $PFD_SUPPORT_OPENGL, $PFD_DOUBLEBUFFER))
	DllStructSetData($tPIXELFORMATDESCRIPTOR, "PixelType", $PFD_TYPE_RGBA)
	DllStructSetData($tPIXELFORMATDESCRIPTOR, "ColorBits", 24)
	DllStructSetData($tPIXELFORMATDESCRIPTOR, "DepthBits", 32)
	DllStructSetData($tPIXELFORMATDESCRIPTOR, "LayerType", $PFD_MAIN_PLANE)


	Local $a_hCall = DllCall($hUSER32, "hwnd", "GetDC", "hwnd", $hWnd)

	If @error Or Not $a_hCall[0] Then
		Return SetError(1, 0, 0) ; could not retrieve a handle to a device context
	EndIf

	$hDeviceContext = $a_hCall[0]

	Local $a_iCall = DllCall($hGDI32, "int", "ChoosePixelFormat", "hwnd", $hDeviceContext, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, 0) ; could not match an appropriate pixel format
	EndIf
	Local $iFormat = $a_iCall[0]

	$a_iCall = DllCall($hGDI32, "int", "SetPixelFormat", "hwnd", $hDeviceContext, "int", $iFormat, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $a_iCall[0] Then
		Return SetError(3, 0, 0) ; could not set the pixel format of the specified device context to the specified format
	EndIf

	$a_hCall = DllCall($hOPENGL32, "hwnd", "wglCreateContext", "hwnd", $hDeviceContext)
	If @error Or Not $a_hCall[0] Then
		Return SetError(4, 0, 0) ; could not create a rendering context
	EndIf

	$hOPENGL32RenderingContext = $a_hCall[0]

	$a_iCall = DllCall($hOPENGL32, "int", "wglMakeCurrent", "hwnd", $hDeviceContext, "hwnd", $hOPENGL32RenderingContext)
	If @error Or Not $a_iCall[0] Then
		Return SetError(5, 0, 0) ; failed to make the specified rendering context the calling thread's current rendering context
	EndIf

	Return SetError(0, 0, 1) ; all OK!

EndFunc   ;==>_EnableOpenGL



; This is cleaning function
Func _DisableOpenGL($hWnd, $hDeviceContext, $hOPENGL32RenderingContext)

	; No point in doing error checking if this is done on exit. Will just call the cleaning functions.

	DllCall($hOPENGL32, "int", "wglMakeCurrent", "hwnd", 0, "hwnd", 0)
	DllCall($hOPENGL32, "int", "wglDeleteContext", "hwnd", $hOPENGL32RenderingContext)
	DllCall($hUSER32, "int", "ReleaseDC", "hwnd", $hWnd, "hwnd", $hDeviceContext)

EndFunc   ;==>_DisableOpenGL



; Used GL functions
Func _glBegin($iMode)
	DllCall($hOPENGL32, "none", "glBegin", "dword", $iMode)
EndFunc   ;==>_glBegin

Func _glBlendFunc($iSfactor, $iDfactor)
	DllCall($hOPENGL32, "none", "glBlendFunc", "dword", $iSfactor, "dword", $iDfactor)
EndFunc   ;==>_glBlendFunc

Func _glClear($iMask)
	DllCall($hOPENGL32, "none", "glClear", "dword", $iMask)
EndFunc   ;==>_glClear

Func _glColor3f($red, $green, $blue)
	DllCall($hOPENGL32, "none", "glColor3f", "float", $red, "float", $green, "float", $blue)
EndFunc   ;==>_glColor3f

Func _glEnable($iCap)
	DllCall($hOPENGL32, "none", "glEnable", "dword", $iCap)
EndFunc   ;==>_glEnable

Func _glEnd()
	DllCall($hOPENGL32, "none", "glEnd")
EndFunc   ;==>_glEnd

Func _glLoadIdentity()
	DllCall($hOPENGL32, "none", "glLoadIdentity")
EndFunc   ;==>_glLoadIdentity

Func _glPopMatrix()
	DllCall($hOPENGL32, "none", "glPopMatrix")
EndFunc   ;==>_glPopMatrix

Func _glPushMatrix()
	DllCall($hOPENGL32, "none", "glPushMatrix")
EndFunc   ;==>_glPushMatrix

Func _glRotatef($nAngle, $nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glRotatef", "float", $nAngle, "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>_glRotatef

Func _glVertex3f($x, $y, $z)
	DllCall($hOPENGL32, "none", "glVertex3f", "float", $x, "float", $y, "float", $z)
EndFunc   ;==>_glVertex3f

Func _glViewport($iX, $iY, $iWidth, $iHeight)
	DllCall($hOPENGL32, "none", "glViewport", "int", $iX, "int", $iY, "dword", $iWidth, "dword", $iHeight)
EndFunc   ;==>_glViewport

Func _glClearColor($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall($hOPENGL32, "none", "glClearColor", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>_glClearColor


; Other functions
Func _SwapBuffers($hDC)
	DllCall($hGDI32, "int", "SwapBuffers", "hwnd", $hDC)
EndFunc   ;==>_SwapBuffers


; Two more used functions (wrappers)

Func _Preserve()
	_SwapBuffers($hDC)
EndFunc   ;==>_Preserve

Func _Quit()
	_DisableOpenGL($hGUI, $hDC, $hRC)
	Exit
EndFunc   ;==>_Quit
