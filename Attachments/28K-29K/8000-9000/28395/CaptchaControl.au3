;.......script written by trancexx (trancexx at yahoo dot com)

#NoTrayIcon

Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

; Used Dlls
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hGDI32 = DllOpen("gdi32.dll")
Global Const $hOPENGL32 = DllOpen("opengl32.dll")
Global Const $hADVAPI32 = DllOpen("advapi32.dll")

; General constants
Global Const $PFD_TYPE_RGBA = 0
Global Const $PFD_MAIN_PLANE = 0
Global Const $PFD_DOUBLEBUFFER = 1
Global Const $PFD_DRAW_TO_WINDOW = 4
Global Const $PFD_SUPPORT_OPENGL = 32

; Used GL constants. See OpenGLConstants.au3
Global Const $GL_VERSION_1_1 = 1
Global Const $GL_COLOR_BUFFER_BIT = 0x00004000
Global Const $GL_DEPTH_BUFFER_BIT = 0x00000100
Global Const $GL_ALL_ATTRIB_BITS = 0x000FFFFF
Global Const $GL_LINES = 0x0001
Global Const $GL_UNSIGNED_BYTE = 0x1401
Global Const $GL_COMPILE = 0x1300

; Hash will be in memory
Global $sCaptchaMD5

; Create GUI
Global $hGUI = GUICreate("Captcha check", 300, 200)

; And controls
Global $hPic = GUICtrlCreatePic("", 70, 50, 100, 55)

Global $hButtonNew = GUICtrlCreateButton("New", 210, 65, 50, 25)
GUICtrlSetOnEvent(-1, "_NewText")

Global $hButton = GUICtrlCreateButton("Check", 210, 137, 50, 25)
GUICtrlSetOnEvent(-1, "_CheckInput")

Global $hInput = GUICtrlCreateInput("", 70, 140, 100, 20)
GUICtrlSetState(-1, 256) ; $GUI_FOCUS


; Enable OpenGL
Global $hDC, $hRC ; device context and rendering context

If Not _EnableOpenGL(GUICtrlGetHandle($hPic), $hDC, $hRC) Then
	MsgBox(48, "Error", "Error initializing usage of OpenGL functions" & @CRLF & "Error code: " & @error)
	Exit
EndIf

; OpenGL preparing and positioning
_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; initially cleaning buffers in case something is left there
_glViewport(0, 0, 100, 55) ; position the view

; Font-matic
Global $iFontUbound = _GetNumberOfFonts()
Global $sFont = RegEnumVal("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", Random(1, $iFontUbound, 1))
Global $hFontList = _CaptchaCreateOpenGLFont(16, 400, 256 + 2 ^ Random(0, 3, 1), $sFont)


; Proper thing to do
GUIRegisterMsg(133, "_Preserve") ; WM_NCPAINT

GUISetOnEvent(-3, "_Quit") ; on exit

; Show GUI
GUISetState(@SW_SHOW, $hGUI)

; Initial generation
_NewText()


_glNewList(2, $GL_COMPILE)
; will make a net
_glBegin($GL_LINES)
; color
_glColor3f(0.7, 0.7, 0.7)
; three horizontal lines
; first:
_glVertex3f(-1, 0.7, 0)
_glVertex3f(1, 0.7, 0)
; second:
_glVertex3f(-1, 0.1, 0)
_glVertex3f(1, 0.1, 0)
; third
_glVertex3f(-1, -0.5, 0)
_glVertex3f(1, -0.5, 0)
; and vertical
; first:
_glVertex3f(-0.7, 1, 0)
_glVertex3f(-0.7, -1, 0)
; second
_glVertex3f(-0.1, 1, 0)
_glVertex3f(-0.1, -1, 0)
; third
_glVertex3f(0.5, 1, 0)
_glVertex3f(0.5, -1, 0)
; over
_glEnd()
; ...and out
_glEndList()



; Loop and draw till exit
While 1

	_GLDraw()
	Sleep(200)

WEnd




; USED FUNCTIONS

Func _GLDraw()

	;_glClearColor(Random(0,1), Random(0,1), Random(0, 1), 0)
	_glClearColor(0, 0, 1, 0)
	_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; cleaning buffers
	_glCallList(1)
	_glCallList(2)
	_SwapBuffers($hDC)

EndFunc   ;==>_GLDraw


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

	Local $a_hCall = DllCall($hUSER32, "ptr", "GetDC", "hwnd", $hWnd)

	If @error Or Not $a_hCall[0] Then
		Return SetError(1, 0, 0) ; could not retrieve a handle to a device context
	EndIf

	$hDeviceContext = $a_hCall[0]

	Local $a_iCall = DllCall($hGDI32, "int", "ChoosePixelFormat", "ptr", $hDeviceContext, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, 0) ; could not match an appropriate pixel format
	EndIf
	Local $iFormat = $a_iCall[0]

	$a_iCall = DllCall($hGDI32, "int", "SetPixelFormat", "ptr", $hDeviceContext, "int", $iFormat, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $a_iCall[0] Then
		Return SetError(3, 0, 0) ; could not set the pixel format of the specified device context to the specified format
	EndIf

	$a_hCall = DllCall($hOPENGL32, "ptr", "wglCreateContext", "ptr", $hDeviceContext)
	If @error Or Not $a_hCall[0] Then
		Return SetError(4, 0, 0) ; could not create a rendering context
	EndIf

	$hOPENGL32RenderingContext = $a_hCall[0]

	$a_iCall = DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", $hDeviceContext, "ptr", $hOPENGL32RenderingContext)
	If @error Or Not $a_iCall[0] Then
		Return SetError(5, 0, 0) ; failed to make the specified rendering context the calling thread's current rendering context
	EndIf

	Return SetError(0, 0, 1) ; all OK!

EndFunc   ;==>_EnableOpenGL



; This is cleaning function
Func _DisableOpenGL($hWnd, $hDeviceContext, $hOPENGL32RenderingContext)

	; No point in doing error checking if this is done on exit. Will just call the cleaning functions.

	DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", 0, "ptr", 0)
	DllCall($hOPENGL32, "int", "wglDeleteContext", "ptr", $hOPENGL32RenderingContext)
	DllCall($hUSER32, "int", "ReleaseDC", "hwnd", $hWnd, "ptr", $hDeviceContext)

EndFunc   ;==>_DisableOpenGL



; Used GL functions

Func _glBegin($iMode)
	DllCall($hOPENGL32, "none", "glBegin", "dword", $iMode)
EndFunc   ;==>_glBegin

Func _glCallList($iList)
	DllCall($hOPENGL32, "none", "glCallList", "dword", $iList)
EndFunc   ;==>_glCallList

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

Func _glEnd()
	DllCall($hOPENGL32, "none", "glEnd")
EndFunc   ;==>_glEnd

Func _glEndList()
	DllCall($hOPENGL32, "none", "glEndList")
EndFunc   ;==>_glEndList

Func _glListBase($iBase)
	DllCall($hOPENGL32, "none", "glListBase", "dword", $iBase)
EndFunc   ;==>_glListBase

Func _glNewList($iList, $iMode)
	DllCall($hOPENGL32, "none", "glNewList", "dword", $iList, "dword", $iMode)
EndFunc   ;==>_glNewList

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

Func _glRasterPos2f($nX, $nY)
	DllCall($hOPENGL32, "none", "glRasterPos2f", "float", $nX, "float", $nY)
EndFunc   ;==>_glRasterPos2f

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

Func _glDrawText($iXcoordinate, $iYcoordinate, $sString, $hFontList)

	_glPushMatrix()
	_glRasterPos2f($iXcoordinate, $iYcoordinate)
	_glPushAttrib($GL_ALL_ATTRIB_BITS)
	_glListBase($hFontList)
	_glCallListsChar(StringLen($sString), $GL_UNSIGNED_BYTE, $sString) ; this function is in such form that it receives strings only (deliberately)
	_glPopAttrib()
	_glPopMatrix()

EndFunc   ;==>_glDrawText


Func _Preserve()
	_SwapBuffers($hDC)
EndFunc   ;==>_Preserve


Func _Quit()
	_DisableOpenGL($hGUI, $hDC, $hRC)
	Exit
EndFunc   ;==>_Quit


; Font function (slightly modified for this)
Func _CaptchaCreateOpenGLFont($iSize = 8.5, $iWeight = 400, $iAttribute = 256, $sFontName = "", $hFontList = 0, $iNumberOf = 1)

	; Get current DC (DC is global variable so this in not strictly necessary. But still... to have more freedom)
	Local $aCall = DllCall($hOPENGL32, "hwnd", "wglGetCurrentDC")

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hDC = $aCall[0]

	; This is needed to propery determine the size of the new font
	$aCall = DllCall($hGDI32, "int", "GetDeviceCaps", _
			"ptr", $hDC, _
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
			"int", 400, _
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
	$aCall = DllCall($hGDI32, "ptr", "SelectObject", "ptr", $hDC, "ptr", $hFont)

	If @error Or Not $aCall[0] Then
		DllCall($hGDI32, "int", "DeleteObject", "ptr", $hFont)
		Return SetError(4, 0, 0)
	EndIf

	; This was before
	Local $hOldFont = $aCall[0]

	; If old FontList is passed delete it to free memory.
	If $hFontList Then DllCall($hOPENGL32, "dword", "glDeleteLists", "dword", $hFontList, "dword", $iNumberOf)

	; Generate empty display list
	$aCall = DllCall($hOPENGL32, "dword", "glGenLists", "dword", 1)

	If @error Or Not $aCall[0] Then
		DllCall($hGDI32, "int", "DeleteObject", "ptr", $hFont)
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
		DllCall($hGDI32, "int", "DeleteObject", "ptr", $hFont)
		Return SetError(6, 0, 0)
	EndIf

	; There can be only one. Delete old font.
	DllCall($hGDI32, "int", "DeleteObject", "ptr", $hOldFont)

	; All OK. Return FontList
	Return SetError(0, 0, $hFontList)

EndFunc   ;==>_CaptchaCreateOpenGLFont


; Number of fonts on your system
Func _GetNumberOfFonts()

	Local $i

	While 1
		$i += 1
		RegEnumVal("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", $i)
		If @error Then
			Return $i - 1
		EndIf
	WEnd

EndFunc   ;==>_GetNumberOfFonts



Func _NewText()

	; change font
	$sFont = RegEnumVal("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", Random(1, $iFontUbound, 1))
	$sFont = StringRegExpReplace($sFont, " (.*)", "")
	; make OpenGL font out of it
	$hFontList = _CaptchaCreateOpenGLFont(16, 400, 256 + 2 ^ Random(0, 3, 1), $sFont, $hFontList)

	_glNewList(1, $GL_COMPILE)
	_glColor3f(Random(0, 1), 1, Random(0, 1)) ; random text color
	Local $sCaptcha = Hex(Random(123, 16777215, 1), 6) ; some random string
	_glDrawText(-1, -0.5, $sCaptcha, $hFontList)
	_glEndList()

	$sCaptchaMD5 = _MD5($sCaptcha)

	GUICtrlSetData($hInput, "")
	GUICtrlSetState($hInput, 256) ; $GUI_FOCUS

EndFunc   ;==>_NewText


Func _CheckInput()

	If _MD5(GUICtrlRead($hInput)) = $sCaptchaMD5 Then
		MsgBox(0, "OK", "You got it!", 0, $hGUI)
	Else ; if wrong
		Beep(50, 100)
	EndIf

	; new text
	_NewText()

EndFunc   ;==>_CheckInput


Func _MD5($sData)

	Local $bData = Binary($sData)
	Local $iBufferSize = BinaryLen($bData)

	Local $tData = DllStructCreate("byte[" & $iBufferSize & "]")
	DllStructSetData($tData, 1, $bData)

	Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
			"dword buf[4];" & _
			"ubyte in[64];" & _
			"ubyte digest[16]")

	DllCall($hADVAPI32, "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))

	If @error Then
		Return SetError(1, 0, "")
	EndIf

	DllCall($hADVAPI32, "none", "MD5Update", _
			"ptr", DllStructGetPtr($tMD5_CTX), _
			"ptr", DllStructGetPtr($tData), _
			"dword", $iBufferSize)

	If @error Then
		Return SetError(2, 0, "")
	EndIf

	DllCall($hADVAPI32, "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))

	If @error Then
		Return SetError(3, 0, "")
	EndIf

	Return Hex(DllStructGetData($tMD5_CTX, "digest"))

EndFunc   ;==>_MD5
