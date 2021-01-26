#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Memory.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;#include "OpenGLconstants.au3" ; constants are extracred for this examle
Opt("GUIOnEventMode", 1)

Global $speed = 0.5 ; speed of projectile, 0.28 defult
Global $relitave = 0

If $relitave = 1 Then
	Global $tail = $speed * 3.2145
Else
	Global $tail = 14.0
EndIf

; Used constants from OpenGLconstants.au3
Global Const $GL_VERSION_1_1 = 1
Global Const $GL_DEPTH_BUFFER_BIT = 0x00000100
Global Const $GL_COLOR_BUFFER_BIT = 0x00004000
Global Const $GL_SRC_COLOR = 0x0300
Global Const $GL_DST_COLOR = 0x0306
Global Const $GL_FOG = 0x0B60
Global Const $GL_FOG_DENSITY = 0x0B62
Global Const $GL_FOG_START = 0x0B63
Global Const $GL_FOG_END = 0x0B64
Global Const $GL_FOG_MODE = 0x0B65
Global Const $GL_FOG_COLOR = 0x0B66
Global Const $GL_BLEND = 0x0BE2
Global Const $GL_FOG_HINT = 0x0C54
Global Const $GL_DONT_CARE = 0x1100
Global Const $GL_MODELVIEW = 0x1700
Global Const $GL_PROJECTION = 0x1701
Global Const $GL_LINEAR = 0x2601

; Some other constants
Global Const $PFD_TYPE_RGBA = 0
Global Const $PFD_MAIN_PLANE = 0
Global Const $PFD_DOUBLEBUFFER = 1
Global Const $PFD_DRAW_TO_WINDOW = 4
Global Const $PFD_SUPPORT_OPENGL = 32

; Number of stars
Global $iNumStars = 9999 ; for example

; Make a GUI
Global $iWidthGUI = 600
Global $iHeightGUI = 400
Global $hGUI = GUICreate("OpenGL Space", $iWidthGUI, $iHeightGUI, -1, -1, $WS_OVERLAPPEDWINDOW)

; Black? Yes black.
GUISetBkColor(0)

; Device context and rendering context
Global $hDC, $hRC ; this two goes in _EnableOpenGL() ByRef

; Enabling OpenGL
If Not _EnableOpenGL($hGUI, $hDC, $hRC) Then
	MsgBox(48, "Error", "Error initializing usage of OpenGL functions" & @CRLF & "Error code: " & @error) ; this is bad
	Exit
EndIf

; Initially cleaning buffers - this is almost redundant. wglMakeCurrent is to associate rendering context with the current thread
DllCall("opengl32.dll", "int", "wglMakeCurrent", "hwnd", $hDC, "hwnd", $hRC)
_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; initially cleaning buffers in case something is left there


Global $tRandom = DllStructCreate("dword") ; this will hold generated random walues by RtlRandomEx function
Global $pRandom = DllStructGetPtr($tRandom)

Global $tFogColor = DllStructCreate("float[4]") ; fog color structure. Needed for _glFogfv function
DllStructSetData($tFogColor, 1, 1, 4) ; other two values are 0
Global $pFogColor = DllStructGetPtr($tFogColor)

Global $tStars = DllStructCreate("float[" & 3 * $iNumStars & "]") ; this structure holds coordinates for every star
Global $pStars = DllStructGetPtr($tStars)

Global $tInt = DllStructCreate("dword") ; this will dynamically hold the address of $tStars
DllStructSetData($tInt, 1, $pStars)
Global $pInt = DllStructGetPtr($tInt)

Global $tInt1 = DllStructCreate("int") ; this is placeholder for the integer used in assembly code in different places
Global $pInt1 = DllStructGetPtr($tInt1)

Global $tInt2 = DllStructCreate("int") ; this is placeholder for the float value of the same value. It's the main 'frequency'
DllStructSetData($tInt2, 1, 150)
Global $pInt2 = DllStructGetPtr($tInt2)

Global $tEndColor = DllStructCreate("float[3]") ; this structure holds ending color of each star (same value for all of them)
DllStructSetData($tEndColor, 1, 0.2, 3) ; other two values are 0
Global $pEndColor = DllStructGetPtr($tEndColor)

Global $tStartColor = DllStructCreate("float[3]") ; this structure holds start color for each star
DllStructSetData($tStartColor, 1, 0.5, 1) ; color crap=============================================================
DllStructSetData($tStartColor, 1, 0.9, 2) ; color crap=============================================================
DllStructSetData($tStartColor, 1, 0.9, 3) ; color crap=============================================================
Global $pStartColor = DllStructGetPtr($tStartColor)

Global $tZoffset = DllStructCreate("float") ; this is determining the tail of passing stars
DllStructSetData($tZoffset, 1, $tail) ; length of tail=============================================================
Global $pZoffset = DllStructGetPtr($tZoffset)

Global $tZincrement = DllStructCreate("float") ; I call this 'repetitive density value' ...or spead if you like
DllStructSetData($tZincrement, 1, $speed) ; 0.28
Global $pZincrement = DllStructGetPtr($tZincrement)

Global $tThreshold = DllStructCreate("float") ; this structure will hold a threshold value
DllStructSetData($tThreshold, 1, 5) ; value is 5 (star will be out of scope when 5 is reached)
Global $pThreshold = DllStructGetPtr($tThreshold)


; SwapBuffers to fully use double-buffering
Global $aSwapBuffers = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("gdi32.dll"), "str", "SwapBuffers")
Global $pSwapBuffers = $aSwapBuffers[0]

; glClear to clean buffers
Global $aglClear = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("opengl32.dll"), "str", "glClear")
Global $pglClear = $aglClear[0]

; glBegin to initialize drawing procedure
Global $aglBegin = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("opengl32.dll"), "str", "glBegin")
Global $pglBegin = $aglBegin[0]

; glEnd to end drawing procedure
Global $aglEnd = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("opengl32.dll"), "str", "glEnd")
Global $pglEnd = $aglEnd[0]

; $pwglMakeCurrent for rendering context
Global $awglMakeCurrent = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("opengl32.dll"), "str", "wglMakeCurrent")
Global $pwglMakeCurrent = $awglMakeCurrent[0]

; RtlRandomEx for generating random integers
Global $aRtlRandomEx = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("ntdll.dll"), "str", "RtlRandomEx")
Global $pRtlRandomEx = $aRtlRandomEx[0]

; glVertex3fv for drawing
Global $aglVertex3fv = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("opengl32.dll"), "str", "glVertex3fv")
Global $pglVertex3fv = $aglVertex3fv[0]

; glColor3fv for color of lines
Global $aglColor3fv = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("opengl32.dll"), "str", "glColor3fv")
Global $pglColor3fv = $aglColor3fv[0]


; Allocating enough memory (512 bytes) with $PAGE_EXECUTE_READWRITE
Global $pRemoteCode = _MemVirtualAlloc(0, 512, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)

; Standard allocation in reserved address (512 bytes again)
Global $tCodeBuffer = DllStructCreate("byte[512]", $pRemoteCode)


; Writing to it (this is setting initial values - coordinates for aech and every star)
DllStructSetData($tCodeBuffer, 1, _
		"0x" & _
		"8B1D" & SwapEndian($pInt) & _                             ; mov ebx, $pInt
		"" & _
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(42949673) & _                            ; mov ecx, 42949673d
		"F7F1" & _                                                 ; div ecx
		"83E8" & Hex(25, 2) & _                                    ; sub eax, 25d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D95B" & Hex(0, 2) & _                                     ; fstp 32real[ebx+0d]
		"" & _
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(42949673) & _                            ; mov ecx, 42949673d
		"F7F1" & _                                                 ; div ecx
		"83E8" & Hex(25, 2) & _                                    ; sub eax, 25d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D95B" & Hex(4, 2) & _                                     ; fstp 32real[ebx+4d]
		"" & _
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(14316558) & _                            ; mov ecx, 14316558d
		"F7F1" & _                                                 ; div ecx
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D9E0" & _                                                 ; fchs  ;<-  change sign of st(0)
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d]
		"" & _
		"81C3" & SwapEndian(12) & _                                ; add ebx, 12
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"75" & Hex(-124, 2) & _                                    ; jne -124 bytes ;<- go back 124 bytes if not equal
		"C3" _                                                     ; ret
		)

; Executing code
DllCall("user32.dll", "int", "CallWindowProcW", _
		"ptr", $pRemoteCode, _
		"int", 0, _
		"int", 0, _
		"int", 0, _
		"int", 0)


; Writing new code (will use the same buffer since the code from it is already executed)
DllStructSetData($tCodeBuffer, 1, _
		"0x" & _
		"" & _ ; >>>>>>>>>>>>>>>>>>>> GENERAL JOB <<<<<<<<<<<<<<<<<<<<<<<
		"" & _ ; 10. $hRC TO THIS THREAD (17 bytes code):
		"68" & SwapEndian($hRC) & _                                ; push $hRC
		"68" & SwapEndian($hDC) & _                                ; push $hDC
		"B8" & SwapEndian($pwglMakeCurrent) & _                    ; mov eax, wglMakeCurrent
		"FFD0" & _                                                 ; call eax ;<- calling function
		"" & _ ; 20. CLEAR BUFFERS (12 bytes code):
		"68" & SwapEndian(16640) & _                               ; push $GL_COLOR_BUFFER_BIT|$GL_DEPTH_BUFFER_BIT
		"B8" & SwapEndian($pglClear) & _                           ; mov eax, glClear
		"FFD0" & _                                                 ; call eax ;<- calling function
		"" & _ ; 30. WILL DRAW LINES - INITIALIZE LINES (12 bytes code):
		"68" & SwapEndian(1) & _                                   ; push $GL_LINES
		"B8" & SwapEndian($pglBegin) & _                           ; mov eax, glBegin
		"FFD0" & _                                                 ; call eax ;<- calling function
		"" & _ ; >>>>>>>>>>>>>>>>>>>> FIRST LOOP <<<<<<<<<<<<<<<<<<<<<<<
		"" & _ ; 40. INITIALIZE LOOP BY ASSIGNING INITIAL VALUE TO ebx (6 bytes code):
		"8B1D" & SwapEndian($pInt) & _                             ; mov ebx, [$pInt] ;<- assigning ebx to address of $pStars (stored in $tInt)
		"" & _ ; 50. DETERMINING INITIAL COLOR (12 bytes code):
		"68" & SwapEndian($pStartColor) & _                        ; push $pStartColor ;<- this is float[3] with start color (r, g, b)
		"B8" & SwapEndian($pglColor3fv) & _                        ; mov eax, $pglColor3fv ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling glColor3fv function
		"" & _ ; 60. DETERMINING INITIAL POINT (8 bytes code):
		"53" & _                                                   ; push ebx ;<- this is float[3] with start coordinates (x, y, z)
		"B8" & SwapEndian($pglVertex3fv) & _                       ; mov eax, $pglVertex3fv ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling glVertex3fv function
		"" & _ ; 70. DETERMINING END COLOR (12 bytes code):
		"68" & SwapEndian($pEndColor) & _                          ; push $pEndColor ;<- this is float[3] with ending color (r, g, b)
		"B8" & SwapEndian($pglColor3fv) & _                        ; mov eax, $pglColor3fv
		"FFD0" & _                                                 ; call eax ;<- calling glColor3fv function
		"" & _ ; 80. DETERMINING END POINT (dislocate z coordinate by value of $tZoffset) (20 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<-  load float (z coordinate)
		"D825" & SwapEndian($pZoffset) & _                         ; fsub [$pZoffset] ; <- substract value stored in $tZoffset
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<- save changes and pop
		"53" & _                                                   ; push ebx ;<- this is float[3] with ending coordinates (x, y, z)
		"B8" & SwapEndian($pglVertex3fv) & _                       ; mov eax, $pglVertex3fv ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling glVertex3fv function
		"" & _ ; 90. RESTORE z COORDINATE (12 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<-  load float (z coordinate)
		"D805" & SwapEndian($pZoffset) & _                         ; fadd [$pZoffset] ;<- add value of $tZoffset
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<- save changes and pop
		"" & _ ; 100. ADD SIZE OF float[3] TO ebx (3 bytes code):
		"83C3" & Hex(12, 2) & _                                    ; add ebx, 12 ;<- add 12 to ebx. That is the size of float[3]
		"" & _ ; 110. COMPARE IT (6 bytes code):
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"" & _ ; 120. MAKE A CONDITION (2 bytes code):
		"73" & Hex(2, 2) & _                                       ; jnb 2d ;<- jump forward 2 bytes on not below; to <135>
		"" & _ ; 130. GO BACK (2 bytes code):
		"EB" & Hex(-77, 2) & _                                     ; jump -77d ;<- jump 77 bytes back otherwise; to <50>
		"" & _ ; >>>>>>>>>>>>>>>>>>>> GENERAL JOB <<<<<<<<<<<<<<<<<<<<<<<
		"" & _ ; 135. CALL glEnd FUNCTION (7 bytes code):
		"B8" & SwapEndian($pglEnd) & _                             ; mov eax, glEnd
		"FFD0" & _                                                 ; call eax ;<- calling glEnd
		"" & _ ; >>>>>>>>>>>>>>>>>>>> SECOND LOOP <<<<<<<<<<<<<<<<<<<<<<<
		"" & _ ; 140. INITIALIZING NEW LOOP (6 bytes code):
		"8B1D" & SwapEndian($pInt) & _                             ; mov ebx, [$pInt] ;<- assigning ebx to address of $pStars (stored in $tInt)
        "" & _ ; 150. CHECK  THRESHOLD (12 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<-  load float (z coordinate)
        "D81D" & SwapEndian($pThreshold) & _                       ; fcomp [$pThreshold] ;<- compare st(0) to float at $tThreshold and pop
        "DFE0" & _                                                 ; fnstsw ax ; update ax register (this is essential for conditional jumps with floats)
		"9E" & _                                                   ; sahf ; copy ah register (same remark as above)
		"" & _ ; 160. MAKE A CONDITION (2 bytes code):
		"73" & Hex(25, 2) & _                                      ; jnb 25d ;<- jump 25 bytes forward on not below; to <220>
		"" & _ ; 170. 'MOVE' IT (12 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<-  load float (z coordinate)
		"D805" & SwapEndian($pZincrement) & _                      ; fadd [$pZincrement] ;<-  add (increment by) value of $tZincrement
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<-  save changes
		"" & _ ; 180. ADD SIZE OF float[3] TO ebx (3 bytes code):
		"83C3" & Hex(12, 2) & _                                    ; add ebx, 12 ;<- add 12 to ebx. That is the size of float[3]
		"" & _ ; 190. COMPARE IT (6 bytes code):
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"" & _ ; 200. MAKE A CONDITION (2 bytes code):
		"73" & Hex(103, 2) & _                                     ; jnb  103d ;<- jump forward 103 bytes on not below; to <290>
		"" & _ ; 210. GO BACK (2 bytes code):
		"EB" & Hex(-39, 2) & _                                     ; jump -39d ;<- jump 39 bytes back otherwise; to <150>
		"" & _ ; 220. GENERATE RANDOM INTEGER IN RANGE OF -25, 25 AND SAVE IT TO x COORDINATE FLOAT (37 bytes code):
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling RtlRandomEx function
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(42949673) & _                            ; mov ecx, 42949673d
		"F7F1" & _                                                 ; div ecx
		"83E8" & Hex(25, 2) & _                                    ; sub eax, 25d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D95B" & Hex(0, 2) & _                                     ; fstp 32real[ebx+0d]
		"" & _ ; 230. GENERATE RANDOM INTEGER IN RANGE OF -25, 25 AND SAVE IT TO y COORDINATE FLOAT (37 bytes code):
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom ;<-
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling RtlRandomEx
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(42949673) & _                            ; mov ecx, 4294967d
		"F7F1" & _                                                 ; div ecx
		"83E8" & Hex(25, 2) & _                                    ; sub eax, 250d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D95B" & Hex(4, 2) & _                                     ; fstp 32real[ebx+4d]
		"" & _ ; 240. SET z COORDINATE to -150 FLOAT VALUE (11 bytes code):
		"DB05" & SwapEndian($pInt2) & _                            ; fild $pInt2
		"D9E0" & _                                                 ; fchs  ;<-  change sign of st(0)
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<-  save it to proper location
		"" & _ ; 250. ADD SIZE OF float[3] TO ebx (3 bytes code):
		"83C3" & Hex(12, 2) & _                                    ; add ebx, 12 ;<- add 12 to ebx. That is the size of float[3]
		"" & _ ; 260. COMPARE IT (6 bytes code):
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"" & _ ; 270. MAKE A CONDITION (2 bytes code):
		"73" & Hex(5, 2) & _                                       ; jnb  5d ;<- jump forward 5 bytes on not below; to <290>
		"" & _ ; 280. GO BACK (5 bytes code):
		"E9" & SwapEndian(-140) & _                                ; jump -140d ;<- jump 140 bytes back otherwise; to <150>
		"" & _ ; 290. CALL SwapBuffers function (12 bytes code):
		"68" & SwapEndian($hDC) & _                                ; push $hDC
		"B8" & SwapEndian($pSwapBuffers) & _                       ; mov eax, SwapBuffers
		"FFD0" & _                                                 ; call eax ;<- calling SwapBuffers
		"" & _ ; 300. RETURN (1 byte code):
		"C3" _                                                    ; ret
		)


; associate contexts with the current thread
DllCall("opengl32.dll", "int", "wglMakeCurrent", "hwnd", $hDC, "hwnd", $hRC)

;Initializing gl environment
_glClearColor(0, 0, 0, 1) ; we said black
_glFogi($GL_FOG_MODE, $GL_LINEAR)
_glFogfv($GL_FOG_COLOR, $pFogColor)
_glFogf($GL_FOG_DENSITY, 0.1)
_glHint($GL_FOG_HINT, $GL_DONT_CARE)
_glFogf($GL_FOG_START, 70)
_glFogf($GL_FOG_END, 150)
_glEnable($GL_FOG)
_glBlendFunc($GL_SRC_COLOR, $GL_DST_COLOR)
_glEnable($GL_BLEND)

; Initially put things in place (literally)
_glLoadIdentity()
_glViewport(0, 0, $iWidthGUI, $iHeightGUI)
_glMatrixMode($GL_PROJECTION)
_glLoadIdentity()
Global $nRatio = $iWidthGUI / $iHeightGUI
_glFrustum(-$nRatio * 0.75, $nRatio * 0.75, -0.75, 0.75, 6, 150)
_glMatrixMode($GL_MODELVIEW)


; Installing function to do the refreshment
GUIRegisterMsg(133, "_Preserve") ; WM_NCPAINT

; Installing function to do handle resizing
GUIRegisterMsg(5, "_ResizeGL") ; WM_SIZE

; Handling things on Exit
GUISetOnEvent(-3, "_Quit") ; $GUI_EVENT_CLOSE

; Show GUI
GUISetState(@SW_SHOW, $hGUI)


; Loop till the end
While 1

	_GLDraw()
    Sleep(20)

WEnd







; USED FUNCTIONS:

Func _GLDraw()

	DllCall("user32.dll", "int", "CallWindowProcW", _
			"ptr", $pRemoteCode, _
			"int", 0, _
			"int", 0, _
			"int", 0, _
			"int", 0)

EndFunc   ;==>_GLDraw


Func SwapEndian($iValue)
	Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian


Func _EnableOpenGL($hWnd, ByRef $hDeviceContext, ByRef $hOpenGLRenderingContext)

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

	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", "opengl32.dll")
	If @error Then
		Return SetError(1, 0, 0) ; what???
	EndIf

	If Not $a_hCall[0] Then
		If DllOpen("opengl32.dll") = -1 Then
			Return SetError(2, 0, 0) ; could not open opengl32.dll
		EndIf
	EndIf

	$a_hCall = DllCall("user32.dll", "hwnd", "GetDC", "hwnd", $hWnd)

	If @error Or Not $a_hCall[0] Then
		Return SetError(3, 0, 0) ; could not retrieve a handle to a device context
	EndIf

	$hDeviceContext = $a_hCall[0]

	Local $a_iCall = DllCall("gdi32.dll", "int", "ChoosePixelFormat", "hwnd", $hDeviceContext, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $a_iCall[0] Then
		Return SetError(4, 0, 0) ; could not match an appropriate pixel format
	EndIf
	Local $iFormat = $a_iCall[0]

	$a_iCall = DllCall("gdi32.dll", "int", "SetPixelFormat", "hwnd", $hDeviceContext, "int", $iFormat, "ptr", DllStructGetPtr($tPIXELFORMATDESCRIPTOR))
	If @error Or Not $a_iCall[0] Then
		Return SetError(5, 0, 0) ; could not set the pixel format of the specified device context to the specified format
	EndIf

	$a_hCall = DllCall("opengl32.dll", "hwnd", "wglCreateContext", "hwnd", $hDeviceContext)
	If @error Or Not $a_hCall[0] Then
		Return SetError(6, 0, 0) ; could not create a rendering context
	EndIf

	$hOpenGLRenderingContext = $a_hCall[0]

	Return SetError(0, 0, 1) ; all OK!

EndFunc   ;==>_EnableOpenGL


Func _DisableOpenGL($hWnd, $hDeviceContext, $hOpenGLRenderingContext)

	; No point in doing error checking if this is done on exit. Will just call the cleaning functions.

	DllCall("opengl32.dll", "int", "wglMakeCurrent", "hwnd", 0, "hwnd", 0)
	DllCall("opengl32.dll", "int", "wglDeleteContext", "hwnd", $hOpenGLRenderingContext)
	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "hwnd", $hDeviceContext)

EndFunc   ;==>_DisableOpenGL


Func _ResizeGL($hWnd, $iMsg, $wParam, $lParam)

    ; dealing with AU3Check.exe
	#forceref $hWnd, $iMsg, $wParam

	; associate contexts with the current thread
	DllCall("opengl32.dll", "int", "wglMakeCurrent", "hwnd", $hDC, "hwnd", $hRC)

	; determine the size of our window
	Local $aClientSize[2] = [BitAND($lParam, 65535), BitShift($lParam, 16)] ; window dimension

	; process changes... adopt to them
	_glLoadIdentity()
	_glViewport(0, 0, $aClientSize[0], $aClientSize[1])
	_glMatrixMode($GL_PROJECTION)
	_glLoadIdentity()
	Local $nRatio = $aClientSize[0] / $aClientSize[1]
	_glFrustum(-$nRatio * .75, $nRatio * .75, -.75, .75, 6.0, 150.0)
	_glMatrixMode($GL_MODELVIEW)

EndFunc   ;==>_ResizeGL


Func _glBegin($iMode)
	DllCall("opengl32.dll", "none", "glBegin", "dword", $iMode)
EndFunc   ;==>_glBegin


Func _glBlendFunc($iSfactor, $iDfactor)
	DllCall("opengl32.dll", "none", "glBlendFunc", "dword", $iSfactor, "dword", $iDfactor)
EndFunc   ;==>_glBlendFunc


Func _glColor3fv($pColorFloat)
	DllCall("opengl32.dll", "none", "glColor3fv", "ptr", $pColorFloat)
EndFunc   ;==>_glColor3fv


Func _glClear($iMask)
	DllCall("opengl32.dll", "none", "glClear", "dword", $iMask)
EndFunc   ;==>_glClear


Func _glClearColor($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall("opengl32.dll", "none", "glClearColor", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>_glClearColor


Func _glEnable($iCap)
	DllCall("opengl32.dll", "none", "glEnable", "dword", $iCap)
EndFunc   ;==>_glEnable


Func _glEnd()
	DllCall("opengl32.dll", "none", "glEnd")
EndFunc   ;==>_glEnd


Func _glFrustum($nLeft, $nRight, $nBottom, $nTop, $nZNear, $nZFar)
	DllCall("opengl32.dll", "none", "glFrustum", "double", $nLeft, "double", $nRight, "double", $nBottom, "double", $nTop, "double", $nZNear, "double", $nZFar)
EndFunc   ;==>_glFrustum


Func _glFogf($iName, $nParam)
	DllCall("opengl32.dll", "none", "glFogf", "dword", $iName, "float", $nParam)
EndFunc   ;==>_glFogf


Func _glFogi($iName, $iParam)
	DllCall("opengl32.dll", "none", "glFogi", "dword", $iName, "dword", $iParam)
EndFunc   ;==>_glFogi


Func _glFogfv($iName, $pParams)
	DllCall("opengl32.dll", "none", "glFogfv", "dword", $iName, "ptr", $pParams)
EndFunc   ;==>_glFogfv


Func _glHint($iTarget, $iMode)
	DllCall("opengl32.dll", "none", "glHint", "dword", $iTarget, "dword", $iMode)
EndFunc   ;==>_glHint


Func _glLoadIdentity()
	DllCall("opengl32.dll", "none", "glLoadIdentity")
EndFunc   ;==>_glLoadIdentity


Func _glMatrixMode($iMode)
	DllCall("opengl32.dll", "none", "glMatrixMode", "dword", $iMode)
EndFunc   ;==>_glMatrixMode


Func _glViewport($iX, $iY, $iWidth, $iHeight)
	DllCall("opengl32.dll", "none", "glViewport", "int", $iX, "int", $iY, "dword", $iWidth, "dword", $iHeight)
EndFunc   ;==>_glViewport


Func _glVertex3fv($pPointer)
	DllCall("opengl32.dll", "none", "glVertex3fv", "ptr", $pPointer)
EndFunc   ;==>_glVertex3fv


Func _SwapBuffers($hDC)
	DllCall("gdi32.dll", "int", "SwapBuffers", "hwnd", $hDC)
EndFunc   ;==>_SwapBuffers



Func _Preserve()
	_SwapBuffers($hDC)
EndFunc   ;==>_Preserve


Func _Quit()
	_DisableOpenGL($hGUI, $hDC, $hRC)
	Exit
EndFunc   ;==>_Quit
