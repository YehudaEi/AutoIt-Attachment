#include <WindowsConstants.au3>

Opt( "MustDeclareVars", 1 )

; Dynamic Link Libraries
Global Const $dllGLU32    = DllOpen( "glu32.dll" )
Global Const $dllGDI32    = DllOpen( "gdi32.dll" )
Global Const $dllOpenGL32 = DllOpen( "opengl32.dll" )
Global Const $dllUser32   = DllOpen( "user32.dll" )

; Version
Global Const $GL_VERSION_1_1 = 1

; PixelFormatDescriptor
Global Const $PFD_TYPE_RGBA = 0
Global Const $PFD_MAIN_PLANE = 0
Global Const $PFD_DOUBLEBUFFER = 1
Global Const $PFD_DRAW_TO_WINDOW = 4
Global Const $PFD_SUPPORT_OPENGL = 32

; GetTarget
Global Const $GL_MODELVIEW_MATRIX = 0x0BA6
Global Const $GL_PROJECTION_MATRIX = 0x0BA7

; MatrixMode
Global Const $GL_MODELVIEW = 0x1700
Global Const $GL_PROJECTION = 0x1701

Global Const $NULL_MATRIX[16] = [ _
	0, 0, 0, 0, _
	0, 0, 0, 0, _
	0, 0, 0, 0, _
	0, 0, 0, 0 ]

Global $hGui, $hDC, $hRC

MainScript()

Func MainScript()

	$hGui = GUICreate( "OpenGL 1.1", 600, 600, 400, 200, $WS_OVERLAPPEDWINDOW )

	EnableOpenGL( $hGui, $hDC, $hRC )

	ResizeOpenGLWin( 600, 600 ) ; <<< See below <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	DisableOpenGL( $hGui, $hDC, $hRC )
	DllClose( $dllGLU32 )
	DllClose( $dllGDI32 )
	DllClose( $dllOpenGL32 )
	DllClose( $dllUser32 )

EndFunc


Func ResizeOpenGLWin( $w, $h )
	Local Const $SphereDiameter = 3 * 3.5

	Local Const $zNear = 1.0
	Local Const $zFar  = $zNear + $SphereDiameter

	Local $dLeft   = 0.0 - $SphereDiameter / 2
	Local $dRight  = 0.0 + $SphereDiameter / 2
	Local $dBottom = 0.0 - $SphereDiameter / 2
	Local $dTop    = 0.0 + $SphereDiameter / 2

	Local $dAspect = $w / $h

	If $dAspect < 1.0 Then
		$dBottom /= $dAspect
		$dTop /= $dAspect
	Else
		$dLeft *= $dAspect
		$dRight *= $dAspect
	EndIf

	; A normal set of five statements to resize an OpenGL window
	glViewport( 0, 0, $w, $h )
	glMatrixMode( $GL_PROJECTION )
	glLoadIdentity()
	;glOrtho( $dLeft, $dRight, $dBottom, $dTop, $zNear, $zFar ) ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	;glMatrixMode( $GL_MODELVIEW )

	; Before glOrtho
	Local $m = $NULL_MATRIX
	glGetFloatv( $GL_PROJECTION_MATRIX, $m )
	ConsoleWrite( "GL_PROJECTION_MATRIX Before" & @CRLF )
	ConsoleWrite( "(  [0],  [1],  [2],  [3] ) = " & sf1(  $m[0] ) & sf1(  $m[1] ) & sf1(  $m[2] ) & sf2(  $m[3] ) )
	ConsoleWrite( "(  [4],  [5],  [6],  [7] ) = " & sf1(  $m[4] ) & sf1(  $m[5] ) & sf1(  $m[6] ) & sf2(  $m[7] ) )
	ConsoleWrite( "(  [8],  [9], [10], [11] ) = " & sf1(  $m[8] ) & sf1(  $m[9] ) & sf1( $m[10] ) & sf2( $m[11] ) )
	ConsoleWrite( "( [12], [13], [14], [15] ) = " & sf1( $m[12] ) & sf1( $m[13] ) & sf1( $m[14] ) & sf2( $m[15] ) )

	glOrtho( $dLeft, $dRight, $dBottom, $dTop, $zNear, $zFar ) ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	; After glOrtho
	glGetFloatv( $GL_PROJECTION_MATRIX, $m )
	ConsoleWrite( "GL_PROJECTION_MATRIX After" & @CRLF )
	ConsoleWrite( "(  [0],  [1],  [2],  [3] ) = " & sf1(  $m[0] ) & sf1(  $m[1] ) & sf1(  $m[2] ) & sf2(  $m[3] ) )
	ConsoleWrite( "(  [4],  [5],  [6],  [7] ) = " & sf1(  $m[4] ) & sf1(  $m[5] ) & sf1(  $m[6] ) & sf2(  $m[7] ) )
	ConsoleWrite( "(  [8],  [9], [10], [11] ) = " & sf1(  $m[8] ) & sf1(  $m[9] ) & sf1( $m[10] ) & sf2( $m[11] ) )
	ConsoleWrite( "( [12], [13], [14], [15] ) = " & sf1( $m[12] ) & sf1( $m[13] ) & sf1( $m[14] ) & sf2( $m[15] ) )

	glMatrixMode( $GL_MODELVIEW )
EndFunc

Func glOrtho( $left, $right, $bottom, $top, $zNear, $zFar ) ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	DllCall( $dllOpenGL32, "none", "glOrtho", "double", $left, "double", $right, "double", $bottom, "double", $top, "double", $zNear, "double", $zFar )
	If @error Then ConsoleWrite( "glOrtho error" & @CRLF )
EndFunc

Func EnableOpenGL( $hWnd, ByRef $hDeviceContext, ByRef $hOPENGL32RenderingContext )

	Local $tPIXELFORMATDESCRIPTOR = DllStructCreate( _
		"word  Size;" & _
		"word  Version;" & _
		"dword Flags;" & _
		"byte  PixelType;" & _
		"byte  ColorBits;" & _
		"byte  RedBits;" & _
		"byte  RedShift;" & _
		"byte  GreenBits;" & _
		"byte  GreenShift;" & _
		"byte  BlueBits;" & _
		"byte  BlueShift;" & _
		"byte  AlphaBits;" & _
		"byte  AlphaShift;" & _
		"byte  AccumBits;" & _
		"byte  AccumRedBits;" & _
		"byte  AccumGreenBits;" & _
		"byte  AccumBlueBits;" & _
		"byte  AccumAlphaBits;" & _
		"byte  DepthBits;" & _
		"byte  StencilBits;" & _
		"byte  AuxBuffers;" & _
		"byte  LayerType;" & _
		"byte  Reserved;" & _
		"dword LayerMask;" & _
		"dword VisibleMask;" & _
		"dword DamageMask" )

	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "Size", DllStructGetSize( $tPIXELFORMATDESCRIPTOR ) )
	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "Version", $GL_VERSION_1_1 )
	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "Flags", BitOR( $PFD_DRAW_TO_WINDOW, $PFD_SUPPORT_OPENGL, $PFD_DOUBLEBUFFER ) )
	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "PixelType", $PFD_TYPE_RGBA )
	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "ColorBits", 24 )
	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "DepthBits", 32 )
	DllStructSetData( $tPIXELFORMATDESCRIPTOR, "LayerType", $PFD_MAIN_PLANE )

	Local $aRet = DllCall( $dllUser32, "hwnd", "GetDC", "hwnd", $hWnd )
	If @error Or Not $aRet[0] Then Return SetError(1,0,0)

	$hDeviceContext = $aRet[0]

	$aRet = DllCall( $dllGDI32, "int", "ChoosePixelFormat", "hwnd", $hDeviceContext, "ptr", DllStructGetPtr( $tPIXELFORMATDESCRIPTOR ) )
	If @error Or Not $aRet[0] Then Return SetError(2,0,0)
	Local $iFormat = $aRet[0]

	$aRet = DllCall( $dllGDI32, "int", "SetPixelFormat", "hwnd", $hDeviceContext, "int", $iFormat, "ptr", DllStructGetPtr( $tPIXELFORMATDESCRIPTOR ) )
	If @error Or Not $aRet[0] Then Return SetError(3,0,0)

	$aRet = DllCall( $dllOpenGL32, "hwnd", "wglCreateContext", "hwnd", $hDeviceContext )
	If @error Or Not $aRet[0] Then Return SetError(4,0,0)

	$hOPENGL32RenderingContext = $aRet[0]

	$aRet = DllCall( $dllOpenGL32, "int", "wglMakeCurrent", "hwnd", $hDeviceContext, "hwnd", $hOPENGL32RenderingContext )
	If @error Or Not $aRet[0] Then Return SetError(5,0,0)

	Return SetError(0,0,1)

EndFunc

Func DisableOpenGL( $hWnd, $hDeviceContext, $hOPENGL32RenderingContext )
	DllCall( $dllOpenGL32, "int", "wglMakeCurrent", "hwnd", 0, "hwnd", 0 )
	DllCall( $dllOpenGL32, "int", "wglDeleteContext", "hwnd", $hOPENGL32RenderingContext )
	DllCall( $dllUser32, "int", "ReleaseDC", "hwnd", $hWnd, "hwnd", $hDeviceContext )
EndFunc

Func glViewport( $x, $y, $width, $height )
	DllCall( $dllOpenGL32, "none", "glViewport", "int", $x, "int", $y, "int", $width, "int", $height )
EndFunc

Func glMatrixMode( $mode )
	DllCall( $dllOpenGL32, "none", "glMatrixMode", "uint", $mode )
EndFunc

Func glLoadIdentity()
	DllCall( $dllOpenGL32, "none", "glLoadIdentity" )
EndFunc

Func glGetFloatv( $pname, ByRef $params )
	Local $a = 0, $n = 1
	If IsArray( $params ) Then
		$a = 1
		$n = UBound( $params )
	EndIf
	Local $tFloat = DllStructCreate( "float[" & $n & "]" )
	Local $aRet = DllCall( $dllOpenGL32, "none", "glGetFloatv", "uint", $pname, "ptr", DllStructGetPtr( $tFloat ) )
	If @error Then Return SetError( 1, 0, 0 )
	If $a Then
		For $i = 0 To $n - 1
			$params[$i] = DllStructGetData( $tFloat, 1, $i+1 )
		Next
	Else
		$params = DllStructGetData( $tFloat, 1, 1 )
	EndIf
EndFunc

Func sf1( $v )
	Return StringFormat( "%.2f", $v ) & ", "
EndFunc

Func sf2( $v )
	Return StringFormat( "%.2f", $v ) & @CRLF
EndFunc
