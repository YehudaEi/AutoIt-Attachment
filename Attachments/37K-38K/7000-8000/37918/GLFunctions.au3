#include-once

Func GLBegin($iMode)
	DllCall($hOPENGL32, "none", "glBegin", "dword", $iMode)
EndFunc   ;==>GLBegin

Func GLBlendFunc($iSfactor, $iDfactor)
	DllCall($hOPENGL32, "none", "glBlendFunc", "dword", $iSfactor, "dword", $iDfactor)
EndFunc   ;==>GLBlendFunc

Func GLCallList($iList)
	DllCall($hOPENGL32, "none", "glCallList", "dword", $iList)
EndFunc   ;==>GLCallList

Func GLCallListsChar($iSize, $iType, $pList)
	DllCall($hOPENGL32, "none", "glCallLists", "dword", $iSize, "dword", $iType, "str", $pList)
EndFunc   ;==>GLCallListsChar

Func GLClear($iMask)
	DllCall($hOPENGL32, "none", "glClear", "dword", $iMask)
EndFunc   ;==>GLClear

Func GLClearColor($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall($hOPENGL32, "none", "glClearColor", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>GLClearColor

Func GLColor3f($nRed, $nGreen, $nBlue)
	DllCall($hOPENGL32, "none", "glColor3f", "float", $nRed, "float", $nGreen, "float", $nBlue)
EndFunc   ;==>GLColor3f

Func GLColor4f($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall($hOPENGL32, "none", "glColor4f", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>GLColor4f

Func GLDepthFunc($iFunc)
	DllCall($hOPENGL32, "none", "glDepthFunc", "dword", $iFunc)
EndFunc   ;==>GLDepthFunc

Func GLDepthMask($iFlag)
	DllCall($hOPENGL32, "none", "glDepthMask", "ubyte", $iFlag)
EndFunc   ;==>GLDepthMask

Func GLDisable($iCap)
	DllCall($hOPENGL32, "none", "glDisable", "dword", $iCap)
EndFunc   ;==>GLDisable

Func GLEnable($iCap)
	DllCall($hOPENGL32, "none", "glEnable", "dword", $iCap)
EndFunc   ;==>GLEnable

Func GLEnd()
	DllCall($hOPENGL32, "none", "glEnd")
EndFunc   ;==>GLEnd

Func GLEndList()
	DllCall($hOPENGL32, "none", "glEndList")
EndFunc   ;==>GLEndList

Func GLFlush()
	DllCall($hOPENGL32, "none", "glFlush")
EndFunc   ;==>GLFlush

Func GLGenLists($iRange)
	Local $aCall = DllCall($hOPENGL32, "dword", "glGenLists", "dword", $iRange)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $aCall[0]
EndFunc   ;==>GLGenLists

Func GLLightfv($iLight, $iName, $pParams)
	DllCall($hOPENGL32, "none", "glLightfv", "dword", $iLight, "dword", $iName, "ptr", $pParams)
EndFunc   ;==>GLLightfv

Func GLListBase($iBase)
	DllCall($hOPENGL32, "none", "glListBase", "dword", $iBase)
EndFunc   ;==>GLListBase

Func GLLoadIdentity()
	DllCall($hOPENGL32, "none", "glLoadIdentity")
EndFunc   ;==>GLLoadIdentity

Func GLMaterialfv($iFace, $iName, $pParams)
	DllCall($hOPENGL32, "none", "glMaterialfv", "dword", $iFace, "dword", $iName, "ptr", $pParams)
EndFunc   ;==>GLMaterialfv

Func GLMatrixMode($iMode)
	DllCall($hOPENGL32, "none", "glMatrixMode", "dword", $iMode)
EndFunc   ;==>GLMatrixMode

Func GLNewList($iList, $iMode)
	DllCall($hOPENGL32, "none", "glNewList", "dword", $iList, "dword", $iMode)
EndFunc   ;==>GLNewList

Func GLNormal3f($nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glNormal3f", "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>GLNormal3f

Func GLPointSize($fSize=1.0)
	DllCall($hOPENGL32, "none", "glPointSize", "float", $fSize)
EndFunc

Func GLPolygonMode($iFace, $iMode);$GL_POINT for vertex, $GL_LINE for wireframe, $GL_FILL for normal
	DllCall($hOPENGL32, "none", "glPolygonMode", "dword", $iFace, "dword", $iMode);$GL_POINT for vertex, $GL_LINE for wireframe, $GL_FILL for normal
EndFunc   ;==>GLPolygonMode

Func GLPopAttrib()
	DllCall($hOPENGL32, "none", "glPopAttrib")
EndFunc   ;==>GLPopAttrib

Func GLPopMatrix()
	DllCall($hOPENGL32, "none", "glPopMatrix")
EndFunc   ;==>GLPopMatrix

Func GLPushAttrib($iMask)
	DllCall($hOPENGL32, "none", "glPushAttrib", "dword", $iMask)
EndFunc   ;==>GLPushAttrib

Func GLPushMatrix()
	DllCall($hOPENGL32, "none", "glPushMatrix")
EndFunc   ;==>GLPushMatrix

Func GLRotatef($nAngle, $nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glRotatef", "float", $nAngle, "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>GLRotatef

Func GLRasterPos2f($nX, $nY)
	DllCall($hOPENGL32, "none", "glRasterPos2f", "float", $nX, "float", $nY)
EndFunc   ;==>GLRasterPos2f

Func GLShadeModel($iMode)
	DllCall($hOPENGL32, "none", "glShadeModel", "dword", $iMode)
EndFunc   ;==>GLShadeModel

Func GLTranslatef($nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glTranslatef", "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>GLTranslatef

Func GLVertex3f($nX, $nY, $nZ)
	DllCall($hOPENGL32, "none", "glVertex3f", "float", $nX, "float", $nY, "float", $nZ)
EndFunc   ;==>GLVertex3f

Func GLViewport($iX, $iY, $iWidth, $iHeight)
	DllCall($hOPENGL32, "none", "glViewport", "int", $iX, "int", $iY, "dword", $iWidth, "dword", $iHeight)
EndFunc   ;==>GLViewport





Func GluNewQuadric()
	Local $aCall = DllCall($hGLU32, "ptr", "gluNewQuadric")
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $aCall[0]
EndFunc   ;==>GluNewQuadric

Func GluSphere($pObj, $nRadius, $iSlices, $iStacks)
	DllCall($hGLU32, "none", "gluSphere", "ptr", $pObj, "double", $nRadius, "int", $iSlices, "int", $iStacks)
EndFunc   ;==>GluSphere

Func GluCylinder($pObj, $nBaseRadius, $nTopRadius, $nHeight, $iSlices, $iStacks)
	DllCall($hGLU32, "ptr", "gluCylinder", "ptr", $pObj, "double", $nBaseRadius, "double", $nTopRadius, "double", $nHeight, "dword", $iSlices, "dword", $iStacks)
EndFunc   ;==>GluCylinder

Func  GluLookAt($fEyeX, $fEyeY, $fEyeZ, $fCenterX, $fCenterY, $fCenterZ, $fUpX, $fUpY, $fUpZ)
	DllCall($hGLU32, "none", "gluLookAt", "double", $fEyeX, "double", $fEyeY, "double", $fEyeZ, "double", $fCenterX, "double", $fCenterY, "double", $fCenterZ, "double", $fUpX, "double", $fUpY, "double", $fUpZ)
EndFunc   ;==>GluLookAt

Func GluPerspective($fovy=90, $aspect=1, $zNear=0, $zFar=1)
	DllCall($hGLU32, "none", "gluPerspective", "double", $fovy, "double", $aspect, "double", $zNear, "double", $zFar)
EndFunc


Func SwapBuffers($hDC)
	DllCall($hGDI32, "int", "SwapBuffers", "ptr", $hDC)
EndFunc   ;==>_SwapBuffers
; This is needed for initialization
Func EnableOpenGL($hWnd, ByRef $hDeviceContext, ByRef $hOPENGL32RenderingContext)
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
	
	Local $aCall = DllCall($hUSER32, "ptr", "GetDC", "hwnd", $hWnd)
	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0) ; could not retrieve a handle to a device context
	EndIf
	$hDeviceContext = $aCall[0]
	$aCall = DllCall($hGDI32, "int", "ChoosePixelFormat", "ptr", $hDeviceContext, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, 0) ; could not match an appropriate pixel format
	EndIf
	Local $iFormat = $aCall[0]
	$aCall = DllCall($hGDI32, "int", "SetPixelFormat", "ptr", $hDeviceContext, "int", $iFormat, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $aCall[0] Then
		Return SetError(3, 0, 0) ; could not set the pixel format of the specified device context to the specified format
	EndIf
	$aCall = DllCall($hOPENGL32, "ptr", "wglCreateContext", "ptr", $hDeviceContext)
	If @error Or Not $aCall[0] Then
		Return SetError(4, 0, 0) ; could not create a rendering context
	EndIf
	$hOPENGL32RenderingContext = $aCall[0]
	$aCall = DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", $hDeviceContext, "ptr", $hOPENGL32RenderingContext)
	If @error Or Not $aCall[0] Then
		Return SetError(5, 0, 0) ; failed to make the specified rendering context the calling thread's current rendering context
	EndIf

	Return 1 ; all OK!
EndFunc   ;==>_EnableOpenGL
; This is cleaning function
Func DisableOpenGL($hWnd, $hDeviceContext, $hOPENGL32RenderingContext)
	; No point in doing error checking if this is done on exit. Will just call the cleaning functions.
	DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", 0, "ptr", 0)
	DllCall($hOPENGL32, "int", "wglDeleteContext", "ptr", $hOPENGL32RenderingContext)
	DllCall($hUSER32, "int", "ReleaseDC", "hwnd", $hWnd, "ptr", $hDeviceContext)
EndFunc   ;==>_DisableOpenGL
