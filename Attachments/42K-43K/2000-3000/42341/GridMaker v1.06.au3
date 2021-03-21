#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=script.ico
#AutoIt3Wrapper_Outfile=GlyphDesigner v1.06.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Fileversion=1.0.0.6
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/StripOnly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <Ext.au3>
; Config/Variables
Global $GuiVersion                  = 1.06
Global $GuiTitle                    = "GlyphDesigner v"&$GuiVersion&"  By BiatuAutMiahn"    ; Gui Title
Global $GuiScale                    = 400                                                  ; 64, 112, 208, 400
Global $GuiStyle                    = -1                                                    ; Gui Sytle Flags, Use BitOR() for combined styles.
Global $GuiStyleExtended            = -1                                                    ; Extended Gui Sytle Flags, Use BitOR() for combined styles.
Global $GuiEventListenerDelay       = 1                                                     ; Milliseconds
Global $ConsoleDebugEventListener   = 1                                                     ; Enable Debug Messages from the Event Listener
Global $CursorClickDelay            = 500                                                   ; Prevent click for X Milliseconds
Global $KeyPressDelay               = 125                                                   ; Prevent KeyPress for X Milliseconds
Global $GdiSmoothingFilter          = 2                                                     ; GDI Plus Surface Smoothing Filter Mode
Global $GuiWidth                    = $GuiScale                                             ; Gui Width
Global $GuiHeight                   = $GuiScale+43                                          ; Gui Height
Global $GdiSurfaceWidth             = $GuiScale                                             ; GDI Plus Surface Width
Global $GdiSurfaceHeight            = $GuiScale                                             ; GDI Plus Surface Height

; Init/Variables
Global $CursorX, $CursorY, $GuiEvents, $CursorStateTimer, $GlyphData
Global $CursorLastStateTime, $GdiOverlayGridX, $GdiOverlayGridY, $GdiCursorGridPen
Global $GdiOverlayGridPen, $GdiOverlayGridScale, $GdiCursorGridScale, $GuiConfigQualityMenu

Global $GdiOverlay = 1, $CursorState = 0, $GdiCursorGridX = 4, $GdiCursorGridY = 4
Global $EditMode = 1, $GuiSaveCursor = 0, $GridStartY = 0, $ExportTransparency = 1
Global $LineStartY = 0, $LineEndX = 0, $LineEndY = 0, $VGA[1][10]
Global $Drawing = 0, $LineStartX = 0, $GridX = 0, $GridY = 0, $GridStartX = 0
GLobal $GuiDrawMode = 0, $GuiFileNotSaved = 0, $GuiShowShade = 1, $GuiShowGrid = True
Global $GuiFileMenu=Random(0,65535,1), $GuiConfigMenu=Random(0,65535,1), $GuiMenu=Random(0,65535,1), $GuiMenuNewFile=Random(0,65535,1)
Global $GuiMenuFileOpen=Random(0,65535,1), $GuiMenuSaveFile=Random(0,65535,1), $GuiMenuSaveFileAs=Random(0,65535,1), $GuiMenuExit=Random(0,65535,1)
Global $GuiMenuLineMode=Random(0,65535,1), $GuiMenuCircleMode=Random(0,65535,1), $GuiMenuAbout=Random(0,65535,1),$GuiMenuGridOption=Random(0,65535,1)
Global $GuiMenuCurveMode=Random(0,65535,1), $GuiMenuPolygonMode=Random(0,65535,1), $GuiMenuGridOption=Random(0,65535,1), $GuiMenuShadeOption=Random(0,65535,1)
Global $GuiQuality0=Random(0,65535,1) ,$GuiQuality1=Random(0,65535,1), $GuiQuality2=Random(0,65535,1), $GuiMenuExportFile=Random(0,65535,1)
Global $GuiMenuExportTransparencyOption=Random(0,65535,1)
$VGA[0][0] = 0

; Init
_GDIPlus_Startup()

; Main
$GuiHandle = GUICreate($GuiTitle,$GuiWidth,$GuiHeight,Default,Default,$GuiStyle,$GuiStyleExtended)
GUISetBkColor(0x000000)
$GuiFileMenu = _GUICtrlMenu_CreateMenu()
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,0,"&New",$GuiMenuNewFile)
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,1,"&Open",$GuiMenuFileOpen)
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,2,"&Save",$GuiMenuSaveFile)
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,3,"",0)
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,4,"&Export",$GuiMenuExportFile)
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,5,"",0)
_GUICtrlMenu_InsertMenuItem($GuiFileMenu,6,"E&xit",$GuiMenuExit)
_GUICtrlMenu_SetItemDisabled($GuiFileMenu, 3,True)

$GuiConfigDrawMenu = _GUICtrlMenu_CreateMenu()
_GUICtrlMenu_InsertMenuItem($GuiConfigDrawMenu,0,"Dot/Line",$GuiMenuLineMode)
_GUICtrlMenu_InsertMenuItem($GuiConfigDrawMenu,1,"&Circle",$GuiMenuCircleMode)
_GUICtrlMenu_InsertMenuItem($GuiConfigDrawMenu,2,"&Polygon",$GuiMenuPolygonMode)
_GUICtrlMenu_InsertMenuItem($GuiConfigDrawMenu,3,"C&urve",$GuiMenuCurveMode)
_GUICtrlMenu_SetItemType($GuiConfigDrawMenu,0,$MFT_RADIOCHECK)
_GUICtrlMenu_SetItemType($GuiConfigDrawMenu,1,$MFT_RADIOCHECK)
_GUICtrlMenu_SetItemType($GuiConfigDrawMenu,2,$MFT_RADIOCHECK)
_GUICtrlMenu_SetItemType($GuiConfigDrawMenu,3,$MFT_RADIOCHECK)
_GUICtrlMenu_SetItemDisabled($GuiConfigDrawMenu,2,True)
_GUICtrlMenu_SetItemDisabled($GuiConfigDrawMenu,3,True)
_GUICtrlMenu_CheckRadioItem($GuiConfigDrawMenu, 0, 3, $GuiDrawMode)
_GUICtrlMenu_CheckRadioItem($GuiConfigMenu,$GuiMenuLineMode,$GuiMenuCircleMode,$GuiMenuLineMode)
_GUICtrlMenu_SetItemChecked($GuiConfigDrawMenu,$GuiMenuLineMode,True)

$GuiConfigQualityMenu = _GUICtrlMenu_CreateMenu()
_GUICtrlMenu_InsertMenuItem($GuiConfigQualityMenu,0,"0",$GuiQuality0)
_GUICtrlMenu_InsertMenuItem($GuiConfigQualityMenu,1,"1",$GuiQuality1)
_GUICtrlMenu_InsertMenuItem($GuiConfigQualityMenu,2,"2",$GuiQuality2)
_GUICtrlMenu_CheckRadioItem($GuiConfigQualityMenu,0,2,$GdiSmoothingFilter)

$GuiConfigGFXMenu = _GUICtrlMenu_CreateMenu()
_GUICtrlMenu_InsertMenuItem($GuiConfigGFXMenu,0,"Show &Grid",$GuiMenuGridOption)
_GUICtrlMenu_InsertMenuItem($GuiConfigGFXMenu,1,"Show S&hade",$GuiMenuShadeOption)
_GUICtrlMenu_InsertMenuItem($GuiConfigGFXMenu,2,"Export with Transparency",$GuiMenuExportTransparencyOption)
_GUICtrlMenu_InsertMenuItem($GuiConfigGFXMenu,3,"GFX &Quality",0,$GuiConfigQualityMenu)
_GUICtrlMenu_SetItemChecked($GuiConfigGFXMenu,0,$GuiShowGrid)
_GUICtrlMenu_SetItemChecked($GuiConfigGFXMenu,1,$GuiShowShade)
_GUICtrlMenu_SetItemChecked($GuiConfigGFXMenu,2,$ExportTransparency)

$GuiConfigMenu = _GUICtrlMenu_CreateMenu()
_GUICtrlMenu_InsertMenuItem($GuiConfigMenu,0,"&Draw Mode",0,$GuiConfigDrawMenu)
_GUICtrlMenu_InsertMenuItem($GuiConfigMenu,1,"G&FX Options",0,$GuiConfigGFXMenu)
_GUICtrlMenu_InsertMenuItem($GuiConfigMenu,2,"",0)
_GUICtrlMenu_InsertMenuItem($GuiConfigMenu,3,"A&bout",$GuiMenuAbout)
_GUICtrlMenu_SetItemDisabled($GuiConfigMenu,3,True)

$GuiMenu = _GUICtrlMenu_CreateMenu()
_GUICtrlMenu_InsertMenuItem($GuiMenu,0, "&File", 0, $GuiFileMenu)
_GUICtrlMenu_InsertMenuItem($GuiMenu,1, "&Config", 0, $GuiConfigMenu)
_GUICtrlMenu_SetMenu($GuiHandle, $GuiMenu)

$GuiGdiSurface = _GDIPlus_GraphicsCreateFromHWND($GuiHandle)
$GuiGdiSurfaceBitmap = _GDIPlus_BitmapCreateFromGraphics($GdiSurfaceWidth,$GdiSurfaceHeight,$GuiGdiSurface)
$GuiGdiSurfaceBuffer = _GDIPlus_ImageGetGraphicsContext($GuiGdiSurfaceBitmap)
$GuiGridSurfaceBuffer = _GDIPlus_ImageGetGraphicsContext($GuiGdiSurfaceBitmap)
_GDIPlus_GraphicsSetSmoothingMode($GuiGdiSurfaceBuffer,$GdiSmoothingFilter)
_GDIPlus_GraphicsClear($GuiGdiSurfaceBuffer,0x00000000)

$GuiGridSurfaceBitmap = _GDIPlus_BitmapCreateFromGraphics($GdiSurfaceWidth,$GdiSurfaceHeight,$GuiGdiSurface)
$GuiGridSurfaceBuffer = _GDIPlus_ImageGetGraphicsContext($GuiGridSurfaceBitmap)

$GuiCursorSurfaceBitmap = _GDIPlus_BitmapCreateFromGraphics($GdiSurfaceWidth,$GdiSurfaceHeight,$GuiGdiSurface)
$GuiCursorSurfaceBuffer = _GDIPlus_ImageGetGraphicsContext($GuiCursorSurfaceBitmap)

$GuiStatus = _GUICtrlStatusBar_Create($GuiHandle)
_GUICtrlStatusBar_SetParts($GuiStatus,2,64)
GUISetState(@SW_SHOW,$GuiHandle)
$CursorStateTimer = TimerInit()
$KeyStateTimer = TimerInit()
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GuiGridGen()
UpdateGUI()
While Sleep($GuiEventListenerDelay)
  Local $Timer = TimerInit()
  $GuiEvents = GUIGetMsg(1)
  $CursorLastStateTime = TimerDiff($CursorStateTimer)
  $KeyPressLastStateTime = TimerDiff($KeyStateTimer)
  If _IsPressed("A2") And _IsPressed("5A") Then; Ctrl+Z
      If $KeyPressLastStateTime >= $KeyPressDelay Then
        $KeyStateTimer = TimerInit()
        If $VGA[0][0] > 0 Then
          _ArrayDelete($VGA,$VGA[0][0])
          $VGA[0][0] -=1
        EndIf
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,KeyPress,CtrlZ"&@CRLF)
      Else
        $KeyStateTimer = TimerInit()
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Warning@Event,KeyPress,Blocked"&@CRLF)
      EndIf
    EndIf

  If (_IsPressed("A2") And _IsPressed("4E"))  Then; Ctrl+N
      If $KeyPressLastStateTime >= $KeyPressDelay Then
        $KeyStateTimer = TimerInit()
        If $VGA[0][0] > 0 Then
          For $Line = 1 To $VGA[0][0]
            _ArrayDelete($VGA,$Line)
          Next
          $VGA[0][0] = 0
        EndIf
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,KeyPress,CtrlN"&@CRLF)
      Else
        $KeyStateTimer = TimerInit()
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Warning@Event,KeyPress,Blocked"&@CRLF)
      EndIf
  EndIf
  If $CursorLastStateTime >= $CursorClickDelay And ($CursorState = 1 Or $CursorState = -1) Then
    $CursorState = 0
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,State,"&$CursorState&@CRLF)
  EndIf
  Switch $GuiEvents[0]
    Case $GUI_EVENT_CLOSE
      If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,Kill"&@CRLF)
      Kill()
      Exit
    Case $GUI_EVENT_MOUSEMOVE
      If ($GuiEvents[3] >= 0 AND $GuiEvents[3] <= $GuiWidth) And ($GuiEvents[4] >= 0 AND $GuiEvents[4] <= $GuiHeight) Then
        $CursorX = $GuiEvents[3]
        $CursorY = $GuiEvents[4]
      ElseIf $GuiEvents[3] > $GuiWidth Then
        $CursorX = $GuiWidth
      ElseIf $GuiEvents[3] < 0 Then
        $CursorX = 0
      ElseIf $GuiEvents[4] > $GuiHeight Then
        $CursorY = $GuiHeight
      ElseIf $GuiEvents[4] > 0 Then
        $CursorY = 0
      EndIf
    Case $GUI_EVENT_PRIMARYDOWN
      If $CursorLastStateTime >= $CursorClickDelay Then
        $CursorState = 2
        $CursorStateTimer = TimerInit()
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,State,"&$CursorState&@CRLF)
      Else
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,Blocked,LeftClick"&@CRLF)
        $CursorStateTimer = TimerInit()
      EndIf
    Case $GUI_EVENT_PRIMARYUP
      $CursorState = 1
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,State,"&$CursorState&@CRLF)
    Case $GUI_EVENT_SECONDARYDOWN
      If $CursorLastStateTime >= $CursorClickDelay Then
        $CursorState = -2
        $CursorStateTimer = TimerInit()
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,State,"&$CursorState&@CRLF)
      Else
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,Blocked,RightClick"&@CRLF)
        $CursorStateTimer = TimerInit()
      EndIf
    Case $GUI_EVENT_SECONDARYUP
        $CursorState = -1
        If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Info@Event,MouseClick,State,"&$CursorState&@CRLF)
    Case Else
      If $ConsoleDebugEventListener = 1 And $GuiEvents[0] <> 0 Then ConsoleWrite("Warning@Event,Unknown,"&$GuiEvents[0]&@CRLF)
    EndSwitch
    UpdateGUI()
    _GUICtrlStatusBar_SetText($GuiStatus,Round(TimerDiff($Timer),3)&" MilliSec/Frame",1)
WEnd

Func UpdateGUI()
    _GDIPlus_GraphicsClear($GuiGdiSurfaceBuffer, 0x0F000000)
    _GDIPlus_GraphicsClear($GuiCursorSurfaceBuffer, 0x0B000000)
    If $GuiShowGrid Then
      _GDIPlus_GraphicsDrawImageRect($GuiGdiSurfaceBuffer, $GuiGridSurfaceBitmap, 0, 0, $GdiSurfaceWidth, $GdiSurfaceHeight)
    EndIf
    DrawCursor()
    StartDraw()
    _GDIPlus_GraphicsDrawImageRect($GuiGdiSurfaceBuffer, $GuiCursorSurfaceBitmap, 0, 0, $GdiSurfaceWidth, $GdiSurfaceHeight)
    If $GuiShowShade Then
      _GDIPlus_CircularGradient2Image($GuiGdiSurface, $GuiGdiSurfaceBitmap, -200, -200, $GdiSurfaceWidth, $GdiSurfaceHeight)
    Else
      _GDIPlus_GraphicsDrawImageRect($GuiGdiSurface, $GuiGdiSurfaceBitmap, 0, 0, $GdiSurfaceWidth, $GdiSurfaceHeight)
   EndIf
EndFunc

Func GuiGridGen()
  DrawGrid(1,0x33FF0000,1)
  DrawGrid(2,0xFFFF7F00,2)
  DrawGrid(4,0x99D9D919,3)
  DrawGrid(8,0xCC00FF7F,4)
  DrawGrid(16,0xFF4D4DFF,4)
EndFunc

Func Kill()
  _GDIPlus_GraphicsDispose($GuiGdiSurfaceBuffer)
  _GDIPlus_BitmapDispose ($GuiGdiSurfaceBitmap)
  _GDIPlus_GraphicsDispose($GuiGdiSurface)
  _GDIPlus_Shutdown()
  GUIDelete($GuiHandle)
  Exit
EndFunc


Func DrawGrid($GdiOverlayGridScale=2,$GdiOverlayGridColor=0xAA00FF00,$GdiOverlayGridDensity=4)
    $GdiOverlayGridPen = _GDIPlus_PenCreate($GdiOverlayGridColor,$GdiOverlayGridDensity,2)
    For $GdiOverlayGridX = 7 To $GdiSurfaceWidth-9 Step 12*$GdiOverlayGridScale
      _GDIPlus_GraphicsDrawLine($GuiGridSurfaceBuffer,$GdiOverlayGridX,7,$GdiOverlayGridX,$GdiSurfaceHeight-9,$GdiOverlayGridPen)
    Next
    For $GdiOverlayGridY = 7 To $GdiSurfaceWidth-9 Step 12*$GdiOverlayGridScale
      _GDIPlus_GraphicsDrawLine($GuiGridSurfaceBuffer,7,$GdiOverlayGridY,$GdiSurfaceWidth-9,$GdiOverlayGridY,$GdiOverlayGridPen)
    Next
    _GDIPlus_PenDispose($GdiOverlayGridPen)
EndFunc

Func DrawCursor()
		$GdiCursorGridScale = 63
    $GdiCursorGridPen = _GDIPlus_PenCreate(0xAAFFFFFF,2)
    For $GdiCursorGridX = 4 To $GdiSurfaceWidth-12 Step 12
      For $GdiCursorGridY = 4 To $GdiSurfaceHeight-12 Step 12
        If ($CursorX >= $GdiCursorGridX-6) And ($CursorX <= $GdiCursorGridX+6) And ($CursorY >= $GdiCursorGridY-6) And ($CursorY <= $GdiCursorGridY+6) Then
          _GDIPlus_GraphicsDrawRect($GuiCursorSurfaceBuffer,$GdiCursorGridX,$GdiCursorGridY,6,6,$GdiCursorGridPen)
          $CursorX = $GdiCursorGridX
          $CursorY = $GdiCursorGridY
          $GridX = Round($CursorX/(388/33))
          $GridY = Round($CursorY/(388/33))
          _GUICtrlStatusBar_SetText($GuiStatus,StringFormat("%02d",Round($CursorX/(388/33)))&","&StringFormat("%02d",Round($CursorY/(388/33))),0)
          ;If $ConsoleDebugEventListener = 1 Then ConsoleWrite("Event,MouseMoved,"&Round($CursorX/(388/33))&"|"&Round($CursorY/(388/33))&@CRLF)
        EndIf
      Next
    Next
EndFunc

Func StartDraw()
  $GdiLinePen = _GDIPlus_PenCreate(0xBBFFFFFF,8,2)
  $GdiBallPen = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
  If $CursorState = 2 And $Drawing = 0 Then
    $LineStartX = $CursorX
    $LineStartY = $CursorY
    $GridStartX = $GridX
    $GridStartY = $GridY
    $Drawing = 1
  EndIf
  Switch $GuiDrawmode
    Case 0 ; Dot/Line
      If $CursorState = 2 And $Drawing = 1 And ($CursorY <> $LineStartY OR $LineStartX <> $CursorX) Then
          _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$LineStartX-1,$LineStartY-1,8,8,$GdiBallPen)
          _GDIPlus_GraphicsDrawLine($GuiGdiSurfaceBuffer,$LineStartX+3,$LineStartY+3,$CursorX+3,$CursorY+3,$GdiLinePen)
          _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$CursorX-1,$CursorY-1,8,8,$GdiBallPen)
      EndIf
      If $CursorState = 1 And $Drawing = 1 And ($CursorY <> $LineStartY OR $LineStartX <> $CursorX) Then
        $LineEndX = $CursorX
        $LineEndY = $CursorY
        AddVGA(1)
        $Drawing = 0
      EndIf
    Case 1; Dot/Circle
      If $CursorState = 2 And $Drawing = 1 And ($CursorY <> $LineStartY OR $LineStartX <> $CursorX) Then
        _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$LineStartX-1,$LineStartY-1,8,8,$GdiBallPen)
        _GDIPlus_GraphicsDrawEllipse($GuiGdiSurfaceBuffer,$LineStartX+3,$LineStartY+3,($CursorX-$LineStartX),($CursorY-$LineStartY),$GdiLinePen)
        _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$CursorX-1,$CursorY-1,8,8,$GdiBallPen)
      EndIf
      If $CursorState = 1 And $Drawing = 1 And ($CursorY <> $LineStartY OR $LineStartX <> $CursorX) Then
        $LineEndX = $CursorX
        $LineEndY = $CursorY
        AddVGA(2)
        $Drawing = 0
      EndIf
  EndSwitch

  If $CursorState = 2 And $Drawing = 1 And ($CursorX <= $CursorX+8 And $CursorX >= $CursorX-8) And ($CursorY <= $CursorY+8 And $CursorY >= $CursorY-8) Then
    _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$CursorX-1,$CursorY-1,8,8,$GdiBallPen)
  EndIf
  If $CursorState = 1 And $Drawing = 1 And ($CursorX <= $CursorX+6 And $CursorX >= $CursorX-6) And ($CursorY <= $CursorY+6 And $CursorY >= $CursorY-6) Then
    AddVGA(0)
    $Drawing = 0
  EndIf

  If $VGA[0][0] > 0 Then
    For $Lines = 1 To $VGA[0][0]
      Switch $VGA[$Lines][0]
        Case 0
          _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$VGA[$Lines][1],$VGA[$Lines][2],8,8,$GdiBallPen)
        Case 1
          _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$VGA[$Lines][1],$VGA[$Lines][2],8,8,$GdiBallPen)
          _GDIPlus_GraphicsDrawLine($GuiGdiSurfaceBuffer,$VGA[$Lines][1]+4,$VGA[$Lines][2]+4,$VGA[$Lines][3]+4,$VGA[$Lines][4]+4,$GdiLinePen)
          _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$VGA[$Lines][3],$VGA[$Lines][4],8,8,$GdiBallPen)
        Case 2
          ;If $EditMode Then _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$VGA[$Lines][1],$VGA[$Lines][2],8,8,$GdiBallPen)
          _GDIPlus_GraphicsDrawEllipse($GuiGdiSurfaceBuffer,$VGA[$Lines][3],$VGA[$Lines][4],$VGA[$Lines][5],$VGA[$Lines][6],$GdiLinePen)
          ;If $EditMode Then _GDIPlus_GraphicsFillEllipse($GuiGdiSurfaceBuffer,$VGA[$Lines][7],$VGA[$Lines][8],8,8,$GdiBallPen)
      EndSwitch
    Next
  EndIf
EndFunc

Func ModVGA($Vector)
EndFunc

Func AddVGA($Mode=0) ;Vector Graphics Array
  For $Vector = 1 To $VGA[0][0]
    If $VGA[$Vector][0] = $Mode Then
      Switch $Mode
        Case 0
          If ($VGA[$Vector][1] = $LineStartX-1 And $VGA[$Vector][2] = $LineStartY-1) Then
            ConsoleWrite("Warning@VGA,SpaceReserved@"&$Vector&"|"&$VGA[$Vector][0]&"|"&$VGA[$Vector][1]&"|"&$VGA[$Vector][2]&@CRLF)
            Return
          EndIf
        Case 1
          If ($VGA[$Vector][1] = $LineStartX-1 And $VGA[$Vector][2] = $LineStartY-1 And $VGA[$Vector][3] = $LineEndX-1 And $VGA[$Vector][4] = $LineEndY-1) Then
            ConsoleWrite("Warning@VGA,SpaceReserved,"&$Vector&"|"&$VGA[$Vector][0]&"|"&$VGA[$Vector][1]&"|"&$VGA[$Vector][2]&"|"&$VGA[$Vector][3]&"|"&$VGA[$Vector][4]&@CRLF)
            Return
          EndIf
          If ($VGA[$Vector][3] = $LineStartX-1 And $VGA[$Vector][4] = $LineStartY-1 And $VGA[$Vector][1] = $LineEndX-1 And $VGA[$Vector][2] = $LineEndY-1) Then
            ConsoleWrite("Warning@VGA,SpaceReserved,"&$Vector&"|"&$VGA[$Vector][0]&"|"&$VGA[$Vector][3]&"|"&$VGA[$Vector][4]&"|"&$VGA[$Vector][1]&"|"&$VGA[$Vector][2]&@CRLF)
            Return
          EndIf
        Case 2
          If ($VGA[$Vector][1] = $LineStartX-1 And $VGA[$Vector][2] = $LineStartY-1 And $VGA[$Vector][7] = $LineEndX-1 And $VGA[$Vector][8] = $LineEndY-1) Then
            ConsoleWrite("Warning@VGA,SpaceReserved,"&$Vector&"|"&$VGA[$Vector][0]&"|"&$VGA[$Vector][1]&"|"&$VGA[$Vector][2]&"|"&$VGA[$Vector][3]&"|"&$VGA[$Vector][4]&"|"&$VGA[$Vector][5]&"|"&$VGA[$Vector][6]&"|"&$VGA[$Vector][7]&"|"&$VGA[$Vector][7]&@CRLF)
            Return
          EndIf
          If ($VGA[$Vector][7] = $LineStartX-1 And $VGA[$Vector][8] = $LineStartY-1 And $VGA[$Vector][1] = $LineEndX-1 And $VGA[$Vector][2] = $LineEndY-1) Then
            ConsoleWrite("Warning@VGA,SpaceReserved,"&$Vector&"|"&$VGA[$Vector][0]&"|"&$VGA[$Vector][7]&"|"&$VGA[$Vector][8]&"|"&$VGA[$Vector][3]&"|"&$VGA[$Vector][4]&"|"&$VGA[$Vector][5]&"|"&$VGA[$Vector][6]&"|"&$VGA[$Vector][1]&"|"&$VGA[$Vector][2]&@CRLF)
            Return
          EndIf
      EndSwitch
    EndIf
  Next
  Local $iUBound = UBound($VGA)
	ReDim $VGA[$iUBound + 1][10]
	$VGA[0][0] = $iUBound
  Switch $Mode
    Case 0; Point
      $VGA[$iUBound][0] = 0
      $VGA[$iUBound][1] = $LineStartX-1
      $VGA[$iUBound][2] = $LineStartY-1
    Case 1; Line
      $VGA[$iUBound][0] = 1
      $VGA[$iUBound][1] = $LineStartX-1
      $VGA[$iUBound][2] = $LineStartY-1
      $VGA[$iUBound][3] = $LineEndX-1
      $VGA[$iUBound][4] = $LineEndY-1
    Case 2; Circle
      $VGA[$iUBound][0] = 2
      $VGA[$iUBound][1] = $LineStartX-1
      $VGA[$iUBound][2] = $LineStartY-1
      $VGA[$iUBound][3] = $LineStartX+3
      $VGA[$iUBound][4] = $LineStartY+3
      $VGA[$iUBound][5] = ($LineEndX-$LineStartX)
      $VGA[$iUBound][6] = ($LineEndY-$LineStartY)
      $VGA[$iUBound][7] = $LineEndX-1
      $VGA[$iUBound][8] = $LineEndY-1
    EndSwitch
EndFunc

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
  ;ConsoleWrite(_WinAPI_LoWord($iwParam)&@CRLF)
	Switch _WinAPI_LoWord($iwParam)
    Case $GuiMenuExit
      Kill()
      Exit
    Case  $GuiMenuGridOption
      If $GuiShowGrid = True Then
        $GuiShowGrid = False
      ElseIf $GuiShowGrid = False Then
        $GuiShowGrid = True
      EndIf
      _GUICtrlMenu_SetItemChecked($GuiConfigGFXMenu,0,$GuiShowGrid)
    Case $GuiMenuExportTransparencyOption
      If $ExportTransparency = True Then
        $ExportTransparency = False
      ElseIf $ExportTransparency = False Then
        $ExportTransparency = True
      EndIf
      _GUICtrlMenu_SetItemChecked($GuiConfigGFXMenu,2,$ExportTransparency)
    Case  $GuiMenuShadeOption
      If $GuiShowShade = True Then
        $GuiShowShade = False
      ElseIf $GuiShowShade = False Then
        $GuiShowShade = True
      EndIf
      _GUICtrlMenu_SetItemChecked($GuiConfigGFXMenu,1,$GuiShowShade)
    Case $GuiQuality0
      $GdiSmoothingFilter = 0
      _GUICtrlMenu_CheckRadioItem($GuiConfigQualityMenu,0,2,$GdiSmoothingFilter)
      _GDIPlus_GraphicsSetSmoothingMode($GuiGdiSurfaceBuffer,$GdiSmoothingFilter)
    Case $GuiQuality1
      $GdiSmoothingFilter = 1
      _GUICtrlMenu_CheckRadioItem($GuiConfigQualityMenu,0,2,$GdiSmoothingFilter)
      _GDIPlus_GraphicsSetSmoothingMode($GuiGdiSurfaceBuffer,$GdiSmoothingFilter)
    Case $GuiQuality2
      $GdiSmoothingFilter = 2
      _GUICtrlMenu_CheckRadioItem($GuiConfigQualityMenu,0,2,$GdiSmoothingFilter)
      _GDIPlus_GraphicsSetSmoothingMode($GuiGdiSurfaceBuffer,$GdiSmoothingFilter)
    Case $GuiMenuLineMode
      $GuiDrawMode = 0
      _GUICtrlMenu_CheckRadioItem($GuiConfigDrawMenu, 0, 3, $GuiDrawMode)
    Case $GuiMenuCircleMode
      $GuiDrawMode = 1
      _GUICtrlMenu_CheckRadioItem($GuiConfigDrawMenu, 0, 3, $GuiDrawMode)
    Case $GuiMenuPolygonMode
      $GuiDrawMode = 2
      _GUICtrlMenu_CheckRadioItem($GuiConfigDrawMenu, 0, 3, $GuiDrawMode)
    Case $GuiMenuCurveMode
      $GuiDrawMode = 3
      _GUICtrlMenu_CheckRadioItem($GuiConfigDrawMenu, 0, 3, $GuiDrawMode)
    Case $GuiMenuNewFile
      If $VGA[0][0] > 0 Then
        For $Line = 1 To $VGA[0][0]
          _ArrayDelete($VGA,$Line)
        Next
        $VGA[0][0] = 0
      EndIf
      UpdateGUI()
    Case $GuiMenuFileOpen
      AdlibRegister("OpenFile",100)
    Case $GuiMenuExportFile
      AdlibRegister("ExportFile",100)
    Case $GuiMenuSaveFile
      AdlibRegister("SaveFile",100)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func OpenFile()
  AdlibUnRegister("OpenFile")
  $GlyphFile = FileOpenDialog($GuiTitle,"","GlyphData Files(*.gly)",3)
  If @error Then Return $GUI_RUNDEFMSG
  If $GlyphFile = "" Then Return $GUI_RUNDEFMSG
  $GlyphData = Encry(FileRead($GlyphFile),1)
  If Not $GlyphData = "" Then
    $GlyphData = StringSplit($GlyphData,",",1)
    If IsArray($GlyphData) Then
      If $GlyphData[0] > 1 Then
        If $VGA[0][0] > 0 Then
          For $Line = 1 To $VGA[0][0]
            _ArrayDelete($VGA,$Line)
          Next
          $VGA[0][0] = 0
        EndIf
        If StringLeft($GlyphData[1],12) == "~!@GlyphFile" And StringTrimLeft($GlyphData[1],13) = $GuiVersion Then
          For $Line = 2 To $GlyphData[0]
            $Lines = StringSplit($GlyphData[$Line],"|",1)
            If IsArray($Lines) Then
              Local $iUBound = UBound($VGA)
              ReDim $VGA[$iUBound + 1][10]
              $VGA[0][0] = $iUBound
              Switch $Lines[1]
                Case 0; Point
                  $VGA[$iUBound][0] = 0
                  $VGA[$iUBound][1] = $Lines[2]
                  $VGA[$iUBound][2] = $Lines[3]
                Case 1; Line
                  $VGA[$iUBound][0] = 1
                  $VGA[$iUBound][1] = $Lines[2]
                  $VGA[$iUBound][2] = $Lines[3]
                  $VGA[$iUBound][3] = $Lines[4]
                  $VGA[$iUBound][4] = $Lines[5]
                Case 2; Circle
                  $VGA[$iUBound][0] = 2
                  $VGA[$iUBound][1] = $Lines[2]
                  $VGA[$iUBound][2] = $Lines[3]
                  $VGA[$iUBound][3] = $Lines[4]
                  $VGA[$iUBound][4] = $Lines[5]
                  $VGA[$iUBound][5] = $Lines[6]
                  $VGA[$iUBound][6] = $Lines[7]
                  $VGA[$iUBound][7] = $Lines[8]
                  $VGA[$iUBound][8] = $Lines[9]
              EndSwitch
            EndIf
          Next
        UpdateGUI()
        Else
        ConsoleWrite("Error@FileOpen,GlyphDataVersionConflict"&@CRLF)
        DwmBox(16,$GuiTitle,"Error@FileOpen,GlyphDataVersionConflict")
        EndIf
      EndIf
    EndIf
  EndIf
EndFunc

Func SaveFile()
  AdlibUnRegister("SaveFile")
  $GlyphData = "~!@GlyphFile|"&$GuiVersion&","
  If $VGA[0][0] > 0 Then
    For $Line = 1 To $VGA[0][0]
      Switch $VGA[$Line][0]
        Case 0; Point
          $GlyphData &= "0|"
          $GlyphData &= $VGA[$Line][1]&"|"
          $GlyphData &= $VGA[$Line][2]&","
        Case 1; Line
          $GlyphData &= "1|"
          $GlyphData &= $VGA[$Line][1]&"|"
          $GlyphData &= $VGA[$Line][2]&"|"
          $GlyphData &= $VGA[$Line][3]&"|"
          $GlyphData &= $VGA[$Line][4]&","
        Case 2; Circle
          $GlyphData &= "2|"
          $GlyphData &= $VGA[$Line][1]&"|"
          $GlyphData &= $VGA[$Line][2]&"|"
          $GlyphData &= $VGA[$Line][3]&"|"
          $GlyphData &= $VGA[$Line][4]&"|"
          $GlyphData &= $VGA[$Line][5]&"|"
          $GlyphData &= $VGA[$Line][6]&"|"
          $GlyphData &= $VGA[$Line][8]&"|"
          $GlyphData &= $VGA[$Line][7]&","
      EndSwitch
    Next
    $GlyphFile = _WinAPI_SaveFileDlg($GuiTitle,Default,"GlyphData Files (*.Gly;*.GlyDat;*.GlyphData)",1,@UserName&"- "&Hex(Random(0,65535,1),4)&".Gly","Gly",BitOR($OFN_DONTADDTORECENT,$OFN_OVERWRITEPROMPT,$OFN_FORCESHOWHIDDEN))
    If @error Then Return $GUI_RUNDEFMSG
    If $GlyphFile = "" Then Return $GUI_RUNDEFMSG
    If FileWrite($GlyphFile,Encry(StringTrimRight($GlyphData,1))) Then
      DwmBox(64,$GuiTitle,"Sucessfully Saved Data")
    Else
      DwmBox(16,$GuiTitle,"Failed Saving Data")
    EndIf
  Else
    DwmBox(48, $GuiTitle, "Nothing to Save!")
  EndIf
EndFunc

Func ExportFile()
  AdlibUnRegister("ExportFile")
  Local $ImageFile = _WinAPI_SaveFileDlg($GuiTitle,Default,"Image Files (*.Png;*.Jpg;*.Bmp)",1,@UserName&"- "&Hex(Random(0,65535,1),4)&".Png","Png",BitOR($OFN_DONTADDTORECENT,$OFN_OVERWRITEPROMPT,$OFN_FORCESHOWHIDDEN))
  If @error Then Return $GUI_RUNDEFMSG
  If $ImageFile = "" Then Return $GUI_RUNDEFMSG
  Local $BitmapFile = _GDIPlus_BitmapCreateFromGraphics($GdiSurfaceWidth,$GdiSurfaceHeight,$GuiGdiSurface)
  Local $BitmapBuffer = _GDIPlus_ImageGetGraphicsContext($BitmapFile)
  _GDIPlus_GraphicsClear($GuiGdiSurfaceBuffer, 0x0B000000)
  _GDIPlus_GraphicsClear($GuiCursorSurfaceBuffer, 0x0B000000)
  If $ExportTransparency = 0 Then _GDIPlus_GraphicsClear($BitmapBuffer, 0xFF000000)
  If $GuiShowGrid Then
    _GDIPlus_GraphicsDrawImageRect($BitmapBuffer, $GuiGridSurfaceBitmap, 0, 0, $GdiSurfaceWidth, $GdiSurfaceHeight)
  EndIf
  If $GuiSaveCursor Then
    DrawCursor()
    _GDIPlus_GraphicsDrawImageRect($BitmapBuffer, $GuiCursorSurfaceBitmap, 0, 0, $GdiSurfaceWidth, $GdiSurfaceHeight)
  EndIf
  StartDraw()
  If $GuiShowShade Then
    _GDIPlus_CircularGradient2Image($BitmapBuffer, $GuiGdiSurfaceBitmap, -200, -200, $GdiSurfaceWidth, $GdiSurfaceHeight)
  Else
    _GDIPlus_GraphicsDrawImageRect($BitmapBuffer, $GuiGdiSurfaceBitmap, 0, 0, $GdiSurfaceWidth, $GdiSurfaceHeight)
  EndIf
  If _GDIPlus_ImageSaveToFile($BitmapFile,$ImageFile) Then
    DwmBox(64,$GuiTitle,"Sucessfully Exported Image")
  Else
    DwmBox(16,$GuiTitle,"Failed Exported Data")
  EndIf
EndFunc
