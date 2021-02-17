#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=security_badge.ico
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;.......script written by trancexx (trancexx at yahoo dot com)

#include <File.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <GUIEdit.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <ScreenCapture.au3>
#include <SQLite.au3>
#Include <Clipboard.au3>
#include <GDIPlus.au3>
#include <WINAPI.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <Constants.au3>
#include <Excel.au3>
#include <Array.au3>
#include <GUIFade.au3>
#include <DateTimeConstants.au3>
#Include <GuiButton.au3>
#Include <GuiMonthCal.au3>
#include <IE.au3>
#include <GUIComboBox.au3>
#Include <Misc.au3>
#include <GuiComboBoxEx.au3>
#include <GuiImageList.au3>
#include <GuiTreeView.au3>
#include <Memory.au3>
#include <GuiConstants.au3>



;#include "OpenGLconstants.au3" ; constants are extracred for this example
Global $stop = HotKeySet("{ESC}", "_Quit")

Global $DigitCount, $FirstDigitEntered, $Number[10], $FirstDigitTried, $SecondDigitTried, $ThirdDigitTried, $FourthDigitTried, $FourthDigitCorrect, $FirstDigitCorrect, $SecondDigitCorrect, $ThirdDigitCorrect, $DisplayGrantedEntry

Global $Hold = False
Global $Back

Opt('GUICloseOnESC', 0)
Opt("GUIOnEventMode", 1)

; Check for right interpreter
If @AutoItX64 Then
	ConsoleWriteError("! 32-bit only" & @CRLF)
	MsgBox(262192, "32-bit", "This is 32-bit script.")
	Exit
EndIf

; Used Dlls
Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hGDI32 = DllOpen("gdi32.dll")
Global Const $hOPENGL32 = DllOpen("opengl32.dll")

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

FileInstall("E:\Decoder_X - STR_Creator\Autoit.JPG", @UserProfileDir & "\Autoit.JPG")
FileInstall("E:\Decoder_X - STR_Creator\Data\s2u-b-b.bmp", @UserProfileDir & "\s2u-b-b.bmp")
FileInstall("E:\Decoder_X - STR_Creator\Data\s2u-u-b.bmp", @UserProfileDir & "\s2u-u-b.bmp")
FileInstall("E:\Decoder_X - STR_Creator\Data\s2u-b-l.bmp", @UserProfileDir & "\s2u-b-l.bmp")
FileInstall("E:\Decoder_X - STR_Creator\Data\s2u-b-m.bmp", @UserProfileDir & "\s2u-b-m.bmp")
FileInstall("E:\Decoder_X - STR_Creator\Data\s2u-b-r.bmp", @UserProfileDir & "\s2u-b-r.bmp")
FileInstall("E:\Decoder_X - STR_Creator\Data\s2u-b-u.bmp", @UserProfileDir & "\s2u-b-u.bmp")

FileInstall("E:\Decoder_X - STR_Creator\Data\Valid.bmp", @UserProfileDir & "\Valid.bmp")
FileInstall("E:\Decoder_X - STR_Creator\Data\Invalid.bmp", @UserProfileDir & "\Invalid.bmp")

FileChangeDir(@UserProfileDir & "\")
_readpass()

Global $SW = @DesktopWidth
Global $SH = @DesktopHeight
; Make a GUI
Global $iWidthGUI = $SW
Global $iHeightGUI = $SH -298
Global $TOPSCREEN, $MPOS, $POS, $CONTROLPOS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global Const $hGUI = GUICreate("Space Windows Lock", $SW, $SH -198, 0,50, $WS_POPUP) ; WS_OVERLAPPEDWINDOW

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
DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", $hDC, "ptr", $hRC)
_glClear(BitOR($GL_COLOR_BUFFER_BIT, $GL_DEPTH_BUFFER_BIT)) ; initially cleaning buffers in case something is left there


Global $tRandom = DllStructCreate("dword") ; this will hold generated random walues by RtlRandomEx function
Global $pRandom = DllStructGetPtr($tRandom)

Global $tFogColor = DllStructCreate("float[4]") ; fog color structure. Needed for _glFogfv function
DllStructSetData($tFogColor, 1, 1, 5) ; other two values are 0
Global $pFogColor = DllStructGetPtr($tFogColor)

Global $tStars = DllStructCreate("float[" & 3 * $iNumStars & "]; float[" & 3 * $iNumStars & "]") ; first element of this structure holds coordinates for every star. Second one is color.
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

Global $tZoffset = DllStructCreate("float") ; this is determining the tail of passing stars
DllStructSetData($tZoffset, 1, 0.9)
Global $pZoffset = DllStructGetPtr($tZoffset)

Global $tZincrement = DllStructCreate("float") ; I call this 'repetitive density value' ...or speed if you like, speed speed speed

DllStructSetData($tZincrement, 1, 0.38)
Global $pZincrement = DllStructGetPtr($tZincrement)



Global $tThreshold = DllStructCreate("float") ; this structure will hold a threshold value
DllStructSetData($tThreshold, 1, 6) ; value is 6 (star will be out of scope when 6 is reached)
Global $pThreshold = DllStructGetPtr($tThreshold)

Global $tDiv = DllStructCreate("float") ; this is additional divisor for generated random floats. To make them 'more' random
DllStructSetData($tDiv, 1, 100.23)
Global $pDiv = DllStructGetPtr($tDiv)


; RtlRandomEx for generating random integers
Global $aRtlRandomEx = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("ntdll.dll"), "str", "RtlRandomEx")
Global $pRtlRandomEx = $aRtlRandomEx[0]
; See that it works for Windows 2000
If Not $pRtlRandomEx Then
	$aRtlRandomEx = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("ntdll.dll"), "str", "RtlRandom")
	$pRtlRandomEx = $aRtlRandomEx[0]
EndIf

; SwapBuffers to fully use double-buffering
Global $aSwapBuffers = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("gdi32.dll"), "str", "SwapBuffers")
Global $pSwapBuffers = $aSwapBuffers[0]

; Get handle of $hOPENGL32 for 'economy' reasons
Global $hOpenGL = _WinAPI_GetModuleHandle("opengl32.dll") ; opengl32.dll handle (not to have to call it more than once)

; glClear to clean buffers
Global $aglClear = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hOpenGL, "str", "glClear")
Global $pglClear = $aglClear[0]

; glBegin to initialize drawing procedure
Global $aglBegin = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hOpenGL, "str", "glBegin")
Global $pglBegin = $aglBegin[0]

; glEnd to end drawing procedure
Global $aglEnd = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hOpenGL, "str", "glEnd")
Global $pglEnd = $aglEnd[0]

; $pwglMakeCurrent for rendering context
Global $awglMakeCurrent = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hOpenGL, "str", "wglMakeCurrent")
Global $pwglMakeCurrent = $awglMakeCurrent[0]

; glVertex3fv for drawing
Global $aglVertex3fv = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hOpenGL, "str", "glVertex3fv")
Global $pglVertex3fv = $aglVertex3fv[0]

; glColor3fv for color of lines
Global $aglColor3fv = DllCall($hKERNEL32, "ptr", "GetProcAddress", "ptr", $hOpenGL, "str", "glColor3fv")
Global $pglColor3fv = $aglColor3fv[0]


; Allocating enough memory (512 bytes) with $PAGE_EXECUTE_READWRITE
Global $pRemoteCode = _MemVirtualAlloc(0, 512, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)

; Standard allocation in reserved address (512 bytes again)
Global $tCodeBuffer = DllStructCreate("byte[512]", $pRemoteCode)


; Writing to it (this is setting initial values - coordinates for aech and every star plus green and blue color factors)
DllStructSetData($tCodeBuffer, 1, _
		"0x" & _
		"8B1D" & SwapEndian($pInt) & _                             ; mov ebx, $pInt
		"" & _ ; x COORDINATE
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(429497) & _                              ; mov ecx, 429497d
		"F7F1" & _                                                 ; div ecx
		"81E8" & SwapEndian(2500) & _                              ; sub eax, 2500d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D835" & SwapEndian($pDiv) & _                             ; fdiv 32real[$pDiv]
		"D95B" & Hex(0, 2) & _                                     ; fstp 32real[ebx+0d]
		"" & _ ; y COORDINATE
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(429497) & _                              ; mov ecx, 429497d
		"F7F1" & _                                                 ; div ecx
		"81E8" & SwapEndian(2500) & _                              ; sub eax, 2500d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D835" & SwapEndian($pDiv) & _  ;                          ; fdiv 32real[$pDiv]
		"D95B" & Hex(4, 2) & _                                     ; fstp 32real[ebx+4d]
		"" & _ ; z COORDINATE
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(14316558) & _                            ; mov ecx, 14316558d
		"F7F1" & _                                                 ; div ecx
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D9E0" & _                                                 ; fchs  ;<- change sign of st(0)
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d]
		"" & _ ; g COLOR
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(107374182) & _                           ; mov ecx, 429497d
		"F7F1" & _                                                 ; div ecx
		"05" & SwapEndian(80) & _                                  ; add eax, 80d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D835" & SwapEndian($pDiv) & _                             ; fdiv 32real[$pDiv]
		"D99B" & SwapEndian(4 + 3 * $iNumStars * 4) & _            ; fstp 32real[ebx+4+3*$iNumStars*4]
		"" & _ ; b COLOR
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx
		"FFD0" & _                                                 ; call eax
		"99" & _                                                   ; cdq
		"B9" & SwapEndian(107374182) & _                           ; mov ecx, 429497d
		"F7F1" & _                                                 ; div ecx
		"05" & SwapEndian(80) & _                                  ; add eax, 80d
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1
		"D835" & SwapEndian($pDiv) & _                             ; fdiv 32real[$pDiv]
		"D99B" & SwapEndian(8 + 3 * $iNumStars * 4) & _            ; fstp 32real[ebx+8+3*$iNumStars*4]
		"" & _ ; SEE IF IT'S ALL
		"81C3" & SwapEndian(12) & _                                ; add ebx, 12
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"75" & Hex(1, 2) & _                                       ; jne 1 byte ;<- go forward 1 byte if not equal
		"C3" & _                                                   ; ret
		"E9" & SwapEndian(-244) _                                  ; jump -244d ;<- jump 244 bytes back
		)


; Executing code
DllCall($hUSER32, "int", "CallWindowProcW", _
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
		"" & _ ; 50. DETERMINING INITIAL COLOR (15 bytes code):
		"8BC3" & _                                                 ; mov eax, ebx
		"05" & SwapEndian(3 * $iNumStars * 4) & _                  ; add eax, 3*$iNumStars*4
		"50" & _                                                   ; push eax
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
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<- load float (z coordinate)
		"D825" & SwapEndian($pZoffset) & _                         ; fsub [$pZoffset] ; <- substract value stored in $tZoffset
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<- save changes and pop
		"53" & _                                                   ; push ebx ;<- this is float[3] with ending coordinates (x, y, z)
		"B8" & SwapEndian($pglVertex3fv) & _                       ; mov eax, $pglVertex3fv ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling glVertex3fv function
		"" & _ ; 90. RESTORE z COORDINATE (12 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<- load float (z coordinate)
		"D805" & SwapEndian($pZoffset) & _                         ; fadd [$pZoffset] ;<- add value of $tZoffset
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<- save changes and pop
		"" & _ ; 100. ADD SIZE OF float[3] TO ebx (3 bytes code):
		"83C3" & Hex(12, 2) & _                                    ; add ebx, 12 ;<- add 12 to ebx. That is the size of float[3]
		"" & _ ; 110. COMPARE IT (6 bytes code):
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"" & _ ; 120. MAKE A CONDITION (2 bytes code):
		"73" & Hex(2, 2) & _                                       ; jnb 2d ;<- jump forward 2 bytes on not below; to <135>
		"" & _ ; 130. GO BACK (2 bytes code):
		"EB" & Hex(-80, 2) & _                                     ; jump -80d ;<- jump 80 bytes back otherwise; to <50>
		"" & _ ; >>>>>>>>>>>>>>>>>>>> GENERAL JOB <<<<<<<<<<<<<<<<<<<<<<<
		"" & _ ; 135. CALL glEnd FUNCTION (7 bytes code):
		"B8" & SwapEndian($pglEnd) & _                             ; mov eax, glEnd
		"FFD0" & _                                                 ; call eax ;<- calling glEnd
		"" & _ ; >>>>>>>>>>>>>>>>>>>> SECOND LOOP <<<<<<<<<<<<<<<<<<<<<<<
		"" & _ ; 140. INITIALIZING NEW LOOP (6 bytes code):
		"8B1D" & SwapEndian($pInt) & _                             ; mov ebx, [$pInt] ;<- assigning ebx to address of $pStars (stored in $tInt)
		"" & _ ; 150. CHECK  THRESHOLD (12 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<- load float (z coordinate)
		"D81D" & SwapEndian($pThreshold) & _                       ; fcomp [$pThreshold] ;<- compare st(0) to float at $tThreshold and pop
		"DFE0" & _                                                 ; fnstsw ax ;<- update ax register (this is essential for conditional jumps with floats)
		"9E" & _                                                   ; sahf ;<- copy ah register (same remark as above)
		"" & _ ; 160. MAKE A CONDITION (2 bytes code):
		"73" & Hex(25, 2) & _                                      ; jnb 25d ;<- jump 25 bytes forward on not below; to <220>
		"" & _ ; 170. 'MOVE' IT (12 bytes code):
		"D943" & Hex(8, 2) & _                                     ; fld 32real[ebx+8d] ;<- load float (z coordinate)
		"D805" & SwapEndian($pZincrement) & _                      ; fadd [$pZincrement] ;<- add (increment by) value of $tZincrement
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<- save changes
		"" & _ ; 180. ADD SIZE OF float[3] TO ebx (3 bytes code):
		"83C3" & Hex(12, 2) & _                                    ; add ebx, 12 ;<- add 12 to ebx. That is the size of float[3]
		"" & _ ; 190. COMPARE IT (6 bytes code):
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"" & _ ; 200. MAKE A CONDITION (2 bytes code):
		"73" & Hex(121, 2) & _                                     ; jnb  121d ;<- jump forward 121 bytes on not below; to <290>
		"" & _ ; 210. GO BACK (2 bytes code):
		"EB" & Hex(-39, 2) & _                                     ; jump -39d ;<- jump 39 bytes back otherwise; to <150>
		"" & _ ; 220. GENERATE RANDOM INTEGER IN RANGE OF -25, 25 AND SAVE IT TO x COORDINATE FLOAT (37 bytes code):
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling RtlRandomEx function
		"99" & _                                                   ; cdq ;<- this is needed o avoid illegalness (dividing below)
		"B9" & SwapEndian(429497) & _                              ; mov ecx, 429497d ;<- ecx = 429497
		"F7F1" & _                                                 ; div ecx ;<- divide eax by ecx
		"81E8" & SwapEndian(2500) & _                              ; sub eax, 2500d ;<- substract 2500
		"A3" & SwapEndian($pInt1) & _                              ; mov [$pInt1], eax ;<- save the result to $tInt1
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1 ;<- load generated integer to st(0)
		"D835" & SwapEndian($pDiv) & _                             ; fdiv 32real[$pDiv] ;<- divide it with float at $tDiv
		"D95B" & Hex(0, 2) & _                                     ; fstp 32real[ebx+0d] ;<- save it to a proper location and pop
		"" & _ ; 230. GENERATE RANDOM INTEGER IN RANGE OF -25, 25 AND SAVE IT TO y COORDINATE FLOAT (37 bytes code):
		"68" & SwapEndian($pRandom) & _                            ; push $pRandom ;<-
		"B8" & SwapEndian($pRtlRandomEx) & _                       ; mov eax, RtlRandomEx ;<- 'preparing' to call
		"FFD0" & _                                                 ; call eax ;<- calling RtlRandomEx
		"99" & _                                                   ; cdq ;<- dividing below
		"B9" & SwapEndian(429497) & _                              ; mov ecx, 429497d ;<- ecx = 429497
		"F7F1" & _                                                 ; div ecx ;<- divide eax by ecx
		"81E8" & SwapEndian(2500) & _                              ; sub eax, 2500d ;<- substract 2500
		"A3" & SwapEndian($pInt1) & _                              ; mov $pInt1, eax ;<- save the result to $tInt1
		"DB05" & SwapEndian($pInt1) & _                            ; fild $pInt1 ;<- load generated integer to st(0)
		"D835" & SwapEndian($pDiv) & _                             ; fdiv 32real[$pDiv] ;<- divide it with float at $tDiv
		"D95B" & Hex(4, 2) & _                                     ; fstp 32real[ebx+4d] ;<- save it to a proper location and pop
		"" & _ ; 240. SET z COORDINATE to -150 FLOAT VALUE (11 bytes code):
		"DB05" & SwapEndian($pInt2) & _                            ; fild $pInt2 ; load integer at $tInt2 to st(0)
		"D9E0" & _                                                 ; fchs  ;<- change sign of st(0) (this is redundant since the integer could be negative, but never mind)
		"D95B" & Hex(8, 2) & _                                     ; fstp 32real[ebx+8d] ;<- save it to proper location and pop
		"" & _ ; 250. ADD SIZE OF float[3] TO ebx (3 bytes code):
		"83C3" & Hex(12, 2) & _                                    ; add ebx, 12 ;<- add 12 to ebx. That is the size of float[3]
		"" & _ ; 260. COMPARE IT (6 bytes code):
		"81FB" & SwapEndian($pStars + $iNumStars * 12) & _         ; cmp ebx, $pStars+$iNumStars*12 ; <- compare ebx with $pStars+$iNumStars*size of float[3]
		"" & _ ; 270. MAKE A CONDITION (2 bytes code):
		"73" & Hex(5, 2) & _                                       ; jnb  5d ;<- jump forward 5 bytes on not below; to <290>
		"" & _ ; 280. GO BACK (5 bytes code):
		"E9" & SwapEndian(-158) & _                                ; jump -158d ;<- jump 158 bytes back otherwise; to <150>
		"" & _ ; 290. CALL SwapBuffers function (12 bytes code):
		"68" & SwapEndian($hDC) & _                                ; push $hDC
		"B8" & SwapEndian($pSwapBuffers) & _                       ; mov eax, SwapBuffers
		"FFD0" & _                                                 ; call eax ;<- calling SwapBuffers
		"" & _ ; 300. RETURN (1 byte code):
		"C3" _                                                    ; ret
		)

; Associate contexts with the current thread
DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", $hDC, "ptr", $hRC)

; Initializing GL environment
_glClearColor(0, 0, 0, 1) ; black
_glFogi($GL_FOG_MODE, $GL_LINEAR) ; use linear equation to compute the fog blend factor
_glFogfv($GL_FOG_COLOR, $pFogColor) ; set fog color
_glFogf($GL_FOG_DENSITY, 0.1) ; fog density
_glHint($GL_FOG_HINT, $GL_DONT_CARE) ; no preference
_glFogf($GL_FOG_START, 70) ; set the near distance for linear fog equation
_glFogf($GL_FOG_END, 150) ; set the far distance for linear fog equation
_glEnable($GL_FOG) ; enable fog
_glBlendFunc($GL_SRC_COLOR, $GL_DST_COLOR)
_glEnable($GL_BLEND) ; enable blending


; Initially put things in place (literally)
_glLoadIdentity()
_glViewport(0, 0, $iWidthGUI, $iHeightGUI) ; default position
_glMatrixMode($GL_PROJECTION) ; current matrix
_glLoadIdentity()
Global $nRatio = $iWidthGUI / $iHeightGUI
_glFrustum(-$nRatio * 0.75, $nRatio * 0.75, -0.75, 0.75, 6, 150) ; multiplying the current matrix by a perspective matrix
_glMatrixMode($GL_MODELVIEW) ; current matrix


; Installing function to do the refreshment
GUIRegisterMsg(133, "_Preserve") ; WM_NCPAINT

; Installing function to handle resizing
GUIRegisterMsg(5, "_ResizeGL") ; WM_SIZE

; Installing function to change speed with mouse wheel
GUIRegisterMsg(522, "_ChangeSpeed") ; WM_MOUSEWHEEL


WinSetTrans($hGUI, "", 0)

; Handling things on Exit
GUISetOnEvent(-3, "_Quit") ; $GUI_EVENT_CLOSE
; Show GUI
GUISetState(@SW_SHOW,$hGUI)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Global const $MGUI = GUICreate("Space Windows Lock", $SW, $SH, 0, 0, $WS_POPUP)
GUISetBkColor(0x000000, $MGUI)

Global $font = "Verdana"
Global $font1 = "Arial"

;$BACK = GUICtrlCreatePic(@UserProfileDir & "\Autoit.JPG", 0, 0, $SW, $SH)
Global $TOPBACK = GUICtrlCreatePic(@UserProfileDir & "\s2u-b-b.bmp", 0, 0, $SW, 50)
Global $BOTTOMBACK = GUICtrlCreatePic(@UserProfileDir & "\s2u-u-b.bmp", 0, $SH - 250, $SW, 250)
Global $BARLEFT = GUICtrlCreatePic(@UserProfileDir & "\s2u-b-l.bmp", 400, $SH - 151, 21, 52)
Global $BARMIDDLE = GUICtrlCreatePic(@UserProfileDir & "\s2u-b-m.bmp", 421, $SH - 151, $SW - 821, 52)
Global $BARRIGHT = GUICtrlCreatePic(@UserProfileDir & "\s2u-b-r.bmp", $SW - 421, $SH - 151, 21, 52)

Global $BARLABEL = GUICtrlCreateLabel("Slide to Unlock", 20, $SH - 151, $SW - 42, 52, $SS_NOTIFY & $SS_CENTER)
Global $SLIDER = GUICtrlCreatePic(@UserProfileDir & "\s2u-b-u.bmp", 422.5, $SH - 147, 60, 45)

Global $enterpassbox = GUICtrlCreateInput("", $SW /2 -95, $SH /2 +450, 190, 25, $ES_CENTER, $WS_EX_TRANSPARENT)
GUICtrlSetFont($enterpassbox, 14, 400, 1, $font)
GUICtrlSetColor($enterpassbox, 0x969696)
GUICtrlSetBkColor($enterpassbox, 0x333333)


WinSetTrans($MGUI, "", 0)

_GuiHole($MGUI, 0, 50, 300)

;@DesktopWidth -400, 40, 200, $SH - 240

; Handling things on Exit
GUISetOnEvent(-3, "_Quit") ; $GUI_EVENT_CLOSE
; Show GUI
GUISetState()
WinSetState($MGUI,"", @SW_MAXIMIZE)



Func _GuiHole($h_win, $i_x, $i_y, $i_size)
   Local $ghpos, $outer_rgn, $inner_rgn, $combined_rgn, $ret
   $ghpos = WinGetPos($h_win)

   $outer_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", $ghpos[2], "long", $ghpos[3])
    If IsArray($outer_rgn) Then
        $inner_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", $i_x, "long", $i_y, "long", @DesktopWidth, "long", 502 + $i_size)
        If IsArray($inner_rgn) Then
            $combined_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)
            If IsArray($combined_rgn) Then
                DllCall("gdi32.dll", "long", "CombineRgn", "long", $combined_rgn[0], "long", $outer_rgn[0], "long", $inner_rgn[0], "int", 4)
                $ret = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $combined_rgn[0], "int", 1)
                If $ret[0] Then
                    Return 1
                Else
                    Return 0
                EndIf
            Else
                Return 0
            EndIf
        Else
            Return 0
        EndIf
    Else
        Return 0
    EndIf

EndFunc  ;==>_GuiHole



For $TRANS = 0 To 255 Step 25
    WinSetTrans($hGUI, "", $TRANS)
    If $TRANS >= 255 Then
        ExitLoop
    EndIf
Next


WinSetTrans($MGUI, "", 255)

_SETSTATEANDFONT()


Global Const $VK_ENTER = '0D'

Global Const  $dll = DllOpen("user32.dll")





; Loop till the end
While 1

	Global $MINFO = GUIGetCursorInfo($MGUI)
    Switch GUIGetMsg($MGUI)
        Case $GUI_EVENT_CLOSE
            Exit
	EndSwitch

Select


Case _IsPressed("0D", $dll)
	Global $lockfile = FileOpen(@UserProfileDir & "\winpass.ini", 0)
	Global $v_enterpassbox = GUICtrlRead($enterpassbox)
	Global $thepass = FileReadLine($lockfile)
	If $v_enterpassbox = $thepass  Then
            SoundPlay(@ScriptDir & "\Data\log in authorized.mp3")
            SplashImageOn("",@ScriptDir & "\Data\Valid.bmp", $SW, $SH-300,0,50,1)
            Sleep(1500)
            SplashOff()

            ;SplashTextOn("", "( You may now slide the bar )", 600, 90, -1, -1, 0, "Arial", 30)
             ;Sleep(3000)
             ;SplashOff()

		    $DisplayGrantedEntry = 1

	    ElseIf $v_enterpassbox = "exit1234" Then
            SoundPlay(@ScriptDir & "\Data\mission override.mp3")
            SplashImageOn("",@ScriptDir & "\Data\Valid.bmp", $SW, $SH-300,0,50,1)
            Sleep(1500)
            SplashOff()


		    $DisplayGrantedEntry = 1

		Else

        SoundPlay(@ScriptDir & "\Data\accessed denied.mp3")
        SplashImageOn("",@ScriptDir & "\Data\Invalid.bmp", $SW, $SH-300,0,50,1)
        Sleep(100)
        SplashOff()
        SplashImageOn("",@ScriptDir & "\Data\Invalid.bmp", $SW, $SH-300,0,50,1)
        Sleep(100)
        SplashOff()
        SplashImageOn("",@ScriptDir & "\Data\Invalid.bmp", $SW, $SH-300,0,50,1)
        Sleep(100)
        SplashOff()
        SplashImageOn("",@ScriptDir & "\Data\Invalid.bmp", $SW, $SH-300,0,50,1)
        Sleep(100)
        SplashOff()
        SplashImageOn("",@ScriptDir & "\Data\Invalid.bmp", $SW, $SH-300,0,50,1)
        Sleep(100)
        SplashOff()
        SplashImageOn("",@ScriptDir & "\Data\Invalid.bmp", $SW, $SH-300,0,50,1)
        Sleep(100)
        SplashOff()
		GUICtrlSetData($enterpassbox, "")
		$DisplayGrantedEntry = 0
	EndIf
EndSelect



If $DisplayGrantedEntry = 1 Then


    If $MINFO[4] = $SLIDER Then
        $POS = 1
        $MINFO = GUIGetCursorInfo($MGUI)
        While $MINFO[4] = $SLIDER
            $MINFO = GUIGetCursorInfo($MGUI)
            If $MINFO[2] = 1 Then
                $MINFO = GUIGetCursorInfo($MGUI)
                $MPOS = MouseGetPos()
                $CONTROLPOS = $MPOS[0] - 422.5
                While $MINFO[2] = 1
                    $MINFO = GUIGetCursorInfo($MGUI)
                    $POS = MouseGetPos()
                    $POS = $POS[0] - $CONTROLPOS
                    If $POS <= 20 Then
                        ControlMove("Space Windows Lock", "", $SLIDER, 422.5, $SH - 147)
                    ElseIf $POS >= $SW - 476.5 Then
                        ControlMove("Space Windows Lock", "", $SLIDER, $SW - 822.5, $SH - 147)
                        _SLIDEFULL()
                    Else
                        ControlMove("Space Windows Lock", "", $SLIDER, $POS, $SH - 147)
                    EndIf
                    Sleep(5)
                WEnd

                Do
                    ControlMove("Space Windows Lock", "", $SLIDER, $POS, $SH - 147)
                    $POS = $POS - 25
                    Sleep(5)
                Until $POS <= 422.5
                ControlMove("Space Windows Lock", "", $SLIDER, 422.5, $SH - 147)

            EndIf
            Sleep(10)
        WEnd
    EndIf
EndIf
    Sleep(1)
	_GLDraw()

	Sleep(20)

WEnd





Func _readpass()
	Local $dll = DllOpen("user32.dll")

	FileDelete(@UserProfileDir & "\winpass.ini")
	$lockfile = FileOpen(@UserProfileDir & "\winpass.ini", 2)
	SoundPlay(@ScriptDir & "\Data\please enter your password.mp3")
	$thepass = InputBox("Create Password", "        Enter Desired Password:", "", "*" & "M", 130, 120)

	Select

		Case _IsPressed("0D", $dll)
			If $thepass = "" Then
				Call("_Quit")
			EndIf
			If $thepass > "" Then
			    FileWriteLine($lockfile, $thepass)
	            FileClose($lockfile)
	            FileSetAttrib(@UserProfileDir & "\winpass.ini", "H")
			EndIf

	EndSelect
EndFunc

FileClose(@UserProfileDir & "\winpass.ini")



;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Func _SETSTATEANDFONT()
    GUICtrlSetColor($BARLABEL, 0x373737)
    GUICtrlSetBkColor($BARLABEL, $GUI_BKCOLOR_TRANSPARENT)
    GUICtrlSetFont($BARLABEL, 21, 400, "", "Lucida Sans")

    For $X = $BACK To $BARRIGHT
        GUICtrlSetState($X, $GUI_DISABLE)
    Next
EndFunc   ;==>_SETSTATEANDFONT


Func _SLIDEFULL()
    Local $BARPOS = $SH - 151
    Local $SLIDERPOS = $SH - 147.5
    Local $BOTTOMPOS = $SH - 250
    Local $TOPPOS = 0
	$TOPSCREEN = _ScreenCapture_Capture(@UserProfileDir & "\Data\s2u-topscreen.bmp", 0, 0, $SW, 50, False)
    Local $TOPCTRLSCREEN = GUICtrlCreatePic(@UserProfileDir & "\Data\s2u-topscreen.bmp", 0, 0, $SW, 50)
    ;GUICtrlSetState($TOPBACK, $GUI_HIDE)
    Do

        ControlMove($MGUI, "", $TOPCTRLSCREEN, 0, $TOPPOS)
        ControlMove($MGUI, "", $BOTTOMBACK, 0, $BOTTOMPOS)
        ControlMove($MGUI, "", $BARLEFT, 20, $BARPOS)
        ControlMove($MGUI, "", $BARMIDDLE, 41, $BARPOS)
        ControlMove($MGUI, "", $BARRIGHT, $SW - 41, $BARPOS)
        ControlMove($MGUI, "", $BARLABEL, 20, $BARPOS)
        ControlMove($MGUI, "", $SLIDER, 422.5, $SLIDERPOS)
        $TOPPOS = $TOPPOS - 2
        $BOTTOMPOS = $BOTTOMPOS + 10
        $BARPOS = $BARPOS + 10
        $SLIDERPOS = $SLIDERPOS + 10
    Until BitAND($TOPPOS <= -50, $BOTTOMPOS >= $SH)
    ;FileDelete("Data\s2u-back.bmp")
    Exit
EndFunc   ;==>_Exit

DllClose($dll)








; USED FUNCTIONS:
Func _GLDraw()

	DllCall($hUSER32, "int", "CallWindowProcW", _
			"ptr", $pRemoteCode, _
			"int", 0, _
			"int", 0, _
			"int", 0, _
			"int", 0)

EndFunc   ;==>_GLDraw

Func stop_GLDraw()

Return

EndFunc   ;==>_GLDraw


Func SwapEndian($iValue)
	Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian


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

	Return SetError(0, 0, 1) ; all OK!

EndFunc   ;==>_EnableOpenGL



Func _DisableOpenGL($hWnd, $hDeviceContext, $hOpenGLRenderingContext)

	; No point in doing error checking if this is done on exit. Will just call the cleaning functions.

	DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", 0, "ptr", 0)
	DllCall($hOPENGL32, "int", "wglDeleteContext", "ptr", $hOpenGLRenderingContext)
	DllCall($hUSER32, "int", "ReleaseDC", "hwnd", $hWnd, "ptr", $hDeviceContext)

EndFunc   ;==>_DisableOpenGL


Func _ResizeGL($hWnd, $iMsg, $wParam, $lParam)

	; dealing with AU3Check.exe
	#forceref $hWnd, $iMsg, $wParam

	; associate contexts with the current thread
	DllCall($hOPENGL32, "int", "wglMakeCurrent", "ptr", $hDC, "ptr", $hRC)

	; determine the size of our window
	Local $aClientSize[2] = [BitAND($lParam, 65535), BitShift($lParam, 16)] ; window dimension

	; process changes... adopt to them
	_glLoadIdentity()
	_glViewport(0, 0, $aClientSize[0], $aClientSize[1])
	_glMatrixMode($GL_PROJECTION)
	_glLoadIdentity()
	Local $nRatio = $aClientSize[0] / $aClientSize[1]
	_glFrustum(-$nRatio * .75, $nRatio * .75, - 2.4, .75, 5, 120.0)
	_glMatrixMode($GL_MODELVIEW)

EndFunc   ;==>_ResizeGL


Func _ChangeSpeed($hWnd, $iMsg, $wParam, $lParam)

	; dealing with AU3Check.exe
	#forceref $hWnd, $iMsg, $lParam

	Local $nSpeedFactor = DllStructGetData($tZincrement, 1) ; this is where speed information is kept

	If BitShift($wParam, 16) > 0 Then ; determine in what way the wheel is turning
		$nSpeedFactor *= 1.2 ; speed it up by 10% (not linear on purpose)
	Else
		$nSpeedFactor /= 1.3 ; slow it down by 10%
	EndIf

	; set some limits
	If $nSpeedFactor > 5 Then $nSpeedFactor = 5
	If $nSpeedFactor < 0.08 Then $nSpeedFactor = 0.08

	; save the changes
	DllStructSetData($tZincrement, 1, $nSpeedFactor)

	Local $nTail = $nSpeedFactor * 3.2
	If $nTail < 0.6 Then $nTail = 0.6
	DllStructSetData($tZoffset, 1, $nTail)

	; update window title
	WinSetTitle($hGUI, 0, "OpenGL Space, Warp " & 1 + Round($nSpeedFactor, 2))

EndFunc   ;==>_ChangeSpeed


; Used OpenGL function plus some unused
Func _glBegin($iMode)
	DllCall($hOPENGL32, "none", "glBegin", "dword", $iMode)
EndFunc   ;==>_glBegin


Func _glBlendFunc($iSfactor, $iDfactor)
	DllCall($hOPENGL32, "none", "glBlendFunc", "dword", $iSfactor, "dword", $iDfactor)
EndFunc   ;==>_glBlendFunc


Func _glColor3fv($pColorFloat)
	DllCall($hOPENGL32, "none", "glColor3fv", "ptr", $pColorFloat)
EndFunc   ;==>_glColor3fv


Func _glClear($iMask)
	DllCall($hOPENGL32, "none", "glClear", "dword", $iMask)
EndFunc   ;==>_glClear


Func _glClearColor($nRed, $nGreen, $nBlue, $nAlpha)
	DllCall($hOPENGL32, "none", "glClearColor", "float", $nRed, "float", $nGreen, "float", $nBlue, "float", $nAlpha)
EndFunc   ;==>_glClearColor


Func _glEnable($iCap)
	DllCall($hOPENGL32, "none", "glEnable", "dword", $iCap)
EndFunc   ;==>_glEnable


Func _glEnd()
	DllCall($hOPENGL32, "none", "glEnd")
EndFunc   ;==>_glEnd


Func _glFrustum($nLeft, $nRight, $nBottom, $nTop, $nZNear, $nZFar)
	DllCall($hOPENGL32, "none", "glFrustum", "double", $nLeft, "double", $nRight, "double", $nBottom, "double", $nTop, "double", $nZNear, "double", $nZFar)
EndFunc   ;==>_glFrustum


Func _glFogf($iName, $nParam)
	DllCall($hOPENGL32, "none", "glFogf", "dword", $iName, "float", $nParam)
EndFunc   ;==>_glFogf


Func _glFogi($iName, $iParam)
	DllCall($hOPENGL32, "none", "glFogi", "dword", $iName, "dword", $iParam)
EndFunc   ;==>_glFogi


Func _glFogfv($iName, $pParams)
	DllCall($hOPENGL32, "none", "glFogfv", "dword", $iName, "ptr", $pParams)
EndFunc   ;==>_glFogfv


Func _glHint($iTarget, $iMode)
	DllCall($hOPENGL32, "none", "glHint", "dword", $iTarget, "dword", $iMode)
EndFunc   ;==>_glHint


Func _glLoadIdentity()
	DllCall($hOPENGL32, "none", "glLoadIdentity")
EndFunc   ;==>_glLoadIdentity


Func _glMatrixMode($iMode)
	DllCall($hOPENGL32, "none", "glMatrixMode", "dword", $iMode)
EndFunc   ;==>_glMatrixMode


Func _glViewport($iX, $iY, $iWidth, $iHeight)
	DllCall($hOPENGL32, "none", "glViewport", "int", $iX, "int", $iY, "dword", $iWidth, "dword", $iHeight)
EndFunc   ;==>_glViewport


Func _glVertex3fv($pPointer)
	DllCall($hOPENGL32, "none", "glVertex3fv", "ptr", $pPointer)
EndFunc   ;==>_glVertex3fv


Func _SwapBuffers($hDC)
	DllCall($hGDI32, "int", "SwapBuffers", "ptr", $hDC)
EndFunc   ;==>_SwapBuffers



Func _Preserve()
	_SwapBuffers($hDC)
EndFunc   ;==>_Preserve







Func _Quit()
	Local $MGUI, $hGUI, $hDC, $hRC
	_DisableOpenGL($hGUI, $hDC, $hRC)
	GUIDelete($hGUI)
	GUIDelete($MGUI)
	Exit
EndFunc   ;==>_Quit
