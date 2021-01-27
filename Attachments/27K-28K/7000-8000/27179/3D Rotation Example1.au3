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
Global Const $GL_QUADS = 0x0007
Global Const $GL_BLEND = 0x0BE2
Global Const $GL_ONE = 1
Global Const $GL_DEPTH_BUFFER_BIT = 0x00000100
Global Const $GL_ALL_ATTRIB_BITS = 0x000FFFFF
Global Const $GL_TRANSFORM_BIT = 0x00001000
Global Const $GL_VIEWPORT_BIT = 0x00000800
Global Const $GL_LIST_BIT = 0x00020000
Global Const $GL_UNSIGNED_BYTE = 0x1401

; Create GUI
Global $iWidth = 450
Global $iHeight = 450
Global $hGUI = GUICreate("OpenGL 3D rotation and font demo", $iWidth, $iHeight)

GUISetBkColor(0) ; black


; Enable OpenGL
Global $hDC, $hRC ; device context and rendering context

If Not _EnableOpenGL($hGUI, $hDC, $hRC) Then
	MsgBox(48, "Error", "Error initializing usage of OpenGL functions" & @CRLF & "Error code: " & @error)
	Exit
EndIf

; Font
Global $hFontList = _CreateOpenGLFont(20, 400, 256, "Segoe UI")

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


Global $nM ; this to be used for rotation


; Loop and draw till exit
While 1

	_GLDraw()
	Sleep(25)

WEnd



; Main drawing function
Func _GLDraw()

	_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; cleaning buffers

	$nM -= 0.5 ; decreasing. To rotate otherwise do increasing

	_glPopMatrix()
	_glPushMatrix()

	;Draw text
	_glColor3f(0.2, 0.3, 0.9) ; color of text
	_glDrawText(-0.8, -0.3, "3D rotation/translation of two", $hFontList)
	_glColor3f(0.8, 0.8, 0.2) ; new color
	_glDrawText(-0.45, -0.5, "parallel planes", $hFontList)

	; Rotate
	_glRotatef($nM, 1, 1, 1)

	; Start drawing
	_glBegin($GL_QUADS)

	; Will make plane
	_glColor3f(0.7, 0, 0) ; red nuance
	_glVertex3f(0.5, 0.5, 0) ; front top

	_glColor3f(0.7, 0.7, 0) ; yellow nuance
	_glVertex3f(0.5, -0.5, 0) ; front right

	_glColor3f(0, 0.7, 0) ; green nuance
	_glVertex3f(-0.5, -0.5, 0) ; front left

	_glColor3f(0, 0, 0.7) ; blue nuance
	_glVertex3f(-0.5, 0.5, 0) ; front top
	; That's it

	; End drawing
	_glEnd()

	; Dislocate it
	_glTranslatef(0.1, 0.1, 0.3)

	; Start drawing again
	_glBegin($GL_QUADS)

	; Will make new plane
	_glColor3f(0.7, 0, 0) ; red nuance
	_glVertex3f(0.5, 0.5, 0) ; front top

	_glColor3f(0.7, 0.7, 0) ; yellow nuance
	_glVertex3f(0.5, -0.5, 0) ; front right

	_glColor3f(0, 0.7, 0) ; green nuance
	_glVertex3f(-0.5, -0.5, 0) ; front left

	_glColor3f(0, 0, 0.7) ; blue nuance
	_glVertex3f(-0.5, 0.5, 0) ; front top
	; That's it

	; End drawing
	_glEnd()

	; Replace old with the new one
	_SwapBuffers($hDC)

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



; Used GL functions (and few not used too)
Func _glBegin($iMode)
	DllCall($hOPENGL32, "none", "glBegin", "dword", $iMode)
EndFunc   ;==>_glBegin

Func _glBlendFunc($iSfactor, $iDfactor)
	DllCall($hOPENGL32, "none", "glBlendFunc", "dword", $iSfactor, "dword", $iDfactor)
EndFunc   ;==>_glBlendFunc

Func _glCallListsChar($iSize, $iType, $pList)
	DllCall($hOPENGL32, "none", "glCallLists", "dword", $iSize, "dword", $iType, "str", $pList)
EndFunc   ;==>_glCallListsChar

Func _glClear($iMask)
	DllCall($hOPENGL32, "none", "glClear", "dword", $iMask)
EndFunc   ;==>_glClear

Func _glClearColor($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall($hOPENGL32, "none", "glClearColor", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>_glClearColor

Func _glColor3f($nRed, $nGreen, $nBlue)
	DllCall($hOPENGL32, "none", "glColor3f", "float", $nRed, "float", $nGreen, "float", $nBlue)
EndFunc   ;==>_glColor3f

Func _glColor4f($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall($hOPENGL32, "none", "glColor4f", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>_glColor4f

Func _glEnable($iCap)
	DllCall($hOPENGL32, "none", "glEnable", "dword", $iCap)
EndFunc   ;==>_glEnable

Func _glEnd()
	DllCall($hOPENGL32, "none", "glEnd")
EndFunc   ;==>_glEnd

Func _glListBase($iBase)
	DllCall($hOPENGL32, "none", "glListBase", "dword", $iBase)
EndFunc   ;==>_glListBase

Func _glLoadIdentity()
	DllCall($hOPENGL32, "none", "glLoadIdentity")
EndFunc   ;==>_glLoadIdentity

Func _glPopAttrib()
	DllCall($hOPENGL32, "none", "glPopAttrib")
EndFunc   ;==>_glPopAttrib

Func _glPopMatrix()
	DllCall($hOPENGL32, "none", "glPopMatrix")
EndFunc   ;==>_glPopMatrix

Func _glPushAttrib($iMask)
	DllCall($hOPENGL32, "none", "glPushAttrib", "dword", $iMask)
EndFunc   ;==>_glPushAttrib

Func _glPushMatrix()
	DllCall($hOPENGL32, "none", "glPushMatrix")
EndFunc   ;==>_glPushMatrix

Func _glRotatef($nAngle, $nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glRotatef", "float", $nAngle, "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>_glRotatef

Func _glRasterPos2f($nX, $nY)
	DllCall($hOPENGL32, "none", "glRasterPos2f", "float", $nX, "float", $nY)
EndFunc   ;==>_glRasterPos2f

Func _glTranslatef($nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glTranslatef", "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>_glTranslatef

Func _glVertex3f($nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glVertex3f", "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>_glVertex3f

Func _glViewport($iX, $iY, $iWidth, $iHeight)
	DllCall($hOPENGL32, "none", "glViewport", "int", $iX, "int", $iY, "dword", $iWidth, "dword", $iHeight)
EndFunc   ;==>_glViewport




; Other functions
Func _SwapBuffers($hDC)
	DllCall($hGDI32, "int", "SwapBuffers", "hwnd", $hDC)
EndFunc   ;==>_SwapBuffers


; Few more used functions (wrappers)

Func _Preserve()
	_SwapBuffers($hDC)
EndFunc   ;==>_Preserve


Func _Quit()
	_DisableOpenGL($hGUI, $hDC, $hRC)
	Exit
EndFunc   ;==>_Quit


Func _glDrawText($iXcoordinate, $iYcoordinate, $sString, $hFontList)

	_glPushMatrix()
	_glRasterPos2f($iXcoordinate, $iYcoordinate)
	_glPushAttrib($GL_ALL_ATTRIB_BITS)
	_glListBase($hFontList)
	_glCallListsChar(StringLen($sString), $GL_UNSIGNED_BYTE, $sString) ; this function is in such form that it receives strings only (deliberately)
	_glPopAttrib()
	_glPopMatrix()

EndFunc   ;==>_glDrawText

; Font function
Func _CreateOpenGLFont($iSize = 8.5, $iWeight = 400, $iAttribute = 256, $sFontName = "", $hFontList = 0, $iNumberOf = 1)

	; Get current DC (DC is global variable so this in not strictly necessary. But still... to have more freedom)
	Local $aCall = DllCall($hOPENGL32, "hwnd", "wglGetCurrentDC")

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hDC = $aCall[0]

	; This is needed to propery determine the size of the new font
	$aCall = DllCall($hGDI32, "int", "GetDeviceCaps", _
			"hwnd", $hDC, _
			"int", 90) ; LOGPIXELSY

	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Local $iDCaps = $aCall[0]

	; $iAttribute is complex. Contains more than one passed data.
	Local $iItalic = BitAND($iAttribute, 2)
	Local $iUnderline = BitAND($iAttribute, 4)
	Local $iStrikeout = BitAND($iAttribute, 8)

	Local $iQuality
	If BitAND($iAttribute, 16) Then
		$iQuality = 1 ; DRAFT_QUALITY
	ElseIf BitAND($iAttribute, 32) Then
		$iQuality = 2 ; PROOF_QUALITY
	ElseIf BitAND($iAttribute, 64) Then
		$iQuality = 3 ; NONANTIALIASED_QUALITY
	ElseIf BitAND($iAttribute, 128) Then
		$iQuality = 4 ; ANTIALIASED_QUALITY
	ElseIf BitAND($iAttribute, 256) Then
		$iQuality = 5 ; CLEARTYPE_QUALITY
	ElseIf BitAND($iAttribute, 512) Then
		$iQuality = 6 ; CLEARTYPE_COMPAT_QUALITY
	EndIf

	; Create new font
	$aCall = DllCall($hGDI32, "ptr", "CreateFontW", _
			"int", -$iSize * $iDCaps / 72, _
			"int", 0, _
			"int", 0, _
			"int", 0, _
			"int", $iWeight, _
			"dword", $iItalic, _
			"dword", $iUnderline, _
			"dword", $iStrikeout, _
			"dword", 0, _
			"dword", 0, _
			"dword", 0, _
			"dword", $iQuality, _
			"dword", 0, _
			"wstr", $sFontName)

	If @error Or Not $aCall[0] Then
		Return SetError(3, 0, 0)
	EndIf

	Local $hFont = $aCall[0]

	; New font to DC
	$aCall = DllCall($hGDI32, "hwnd", "SelectObject", "hwnd", $hDC, "hwnd", $hFont)

	If @error Or Not $aCall[0] Then
		DllCall($hGDI32, "int", "DeleteObject", "hwnd", $hFont)
		Return SetError(4, 0, 0)
	EndIf

	; This was before
	Local $hOldFont = $aCall[0]

	; If old FontList is passed delete it to free memory.
	If $hFontList Then DllCall($hOPENGL32, "dword", "glDeleteLists", "dword", $hFontList, "dword", $iNumberOf)

	; Generate empty display list
	$aCall = DllCall($hOPENGL32, "dword", "glGenLists", "dword", 1)

	If @error Or Not $aCall[0] Then
		DllCall($hGDI32, "int", "DeleteObject", "hwnd", $hFont)
		Return SetError(5, 0, 0)
	EndIf

	$hFontList = $aCall[0]

	; Make glyph bitmaps
	$aCall = DllCall($hOPENGL32, "int", "wglUseFontBitmapsW", _
			"ptr", $hDC, _
			"dword", 0, _
			"dword", 256, _
			"ptr", $hFontList)

	If @error Or Not $aCall[0] Then
		DllCall($hGDI32, "int", "DeleteObject", "hwnd", $hFont)
		Return SetError(6, 0, 0)
	EndIf

	; There can be only one. Delete old font.
	DllCall($hGDI32, "int", "DeleteObject", "hwnd", $hOldFont)

	; All OK. Return FontList
	Return SetError(0, 0, $hFontList)

EndFunc   ;==>_CreateOpenGLFont
