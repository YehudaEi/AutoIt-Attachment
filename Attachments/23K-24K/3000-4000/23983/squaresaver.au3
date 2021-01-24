#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.13 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
; Defult esc exit function
hotkeyset("{ESC}","foo")
Func foo()
GUIDelete( $hGUI )
SCR_Options_Proc2()
EndFunc
; Script Start - Add your code below here
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiConstants.au3>
#include <GDIPlus.au3>
Opt('MustDeclareVars', 1)
Global Const $Pi = 3.1415926535897932384626
Global Const $width = @DesktopWidth + 10
Global Const $height = @DesktopHeight + 30
Global $hGUI, $hWnd, $hGraphic, $ParticleBitmap, $ParticleBuffer, $hBrush0, $hBrush1, $hBrush2, $Pen
Global $starting_point, $i, $j, $k, $xcoord1, $ycoord1, $xcoord2, $ycoord2, $size, $red, $green, $blue, $start

If $CmdLineRaw = "/S" Then
    ScreenSaver_Proc()
ElseIf $CmdLine[0] = 0 Or StringLeft($CmdLineRaw, 3) = "/c:" Then
    SCR_Options_Proc(StringLeft($CmdLineRaw, 3) = "/c:")
EndIf

Func SCR_Options_Proc($DisableParent=0)
    Local $iMsg, $ParentHwnd = 0
    
    ;If "/c:" passed as commandline, that's mean that the "Options" button was pressed from the screensaver installation dialog
    ;therefore we can disable the parent dialog and open our Options dialog as child
    If $DisableParent = 1 Then
        $ParentHwnd = WinGetHandle("")
        WinSetState($ParentHwnd, "", @SW_DISABLE)
    EndIf
    
    Global $GUI = GUICreate("options", 181, 122, 192, 124)
    Global $Label1 = GUICtrlCreateLabel("Space between squares.", 56, 8, 122, 17)
    Global $Input1 = GUICtrlCreateInput("30", 8, 8, 41, 21)
    Global $Input2 = GUICtrlCreateInput("150", 8, 32, 41, 21)
    Global $Input3 = GUICtrlCreateInput("30", 8, 56, 41, 21)
    Global $Label2 = GUICtrlCreateLabel("Square travel distance.", 56, 32, 101, 17)
    Global $Label3 = GUICtrlCreateLabel("Clear/refresh dely.", 56, 56, 89, 17)
    Global $Preview_Button = GUICtrlCreateButton("Preview", 8, 80, 145, 33, 0)
    
    GUISetState()
    
    While 1
        $iMsg = GUIGetMsg($GUI)
        Switch $iMsg
            Case $GUI_EVENT_CLOSE
                ;Enable back the parent dialog
                If $DisableParent = 1 Then WinSetState($ParentHwnd, "", @SW_ENABLE)
                Exit
            Case $Preview_Button
				Global $Dis = GUICtrlRead($Input2)
				Global $dly = GUICtrlRead($Input1)
				Global $ref = GUICtrlRead($Input3)
				ScreenSaver_Proc()
        EndSwitch
    WEnd
EndFunc

Func ScreenSaver_Proc()
					$hGUI = GUICreate("GDI+: Flying Squares by UEZ 2009", $width, $height)
					$hWnd = WinGetHandle($hGUI)
					GUISetState()

					; Draw an ellipse
					_GDIPlus_Startup ()
					$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hWnd) ;create graphic
					$ParticleBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic) ;create bitmap
					$ParticleBuffer = _GDIPlus_ImageGetGraphicsContext($ParticleBitmap) ;create buffer
					$hBrush1 = _GDIPlus_BrushCreateSolid(0x7F777777)
					AntiAlias($ParticleBuffer, 4)
					_GDIPlus_GraphicsClear($ParticleBuffer) ;clear buffer
					

					$start = -25
					$i = $start
					$starting_point = 0
					; Loop until user exits
				Do
					$red = ((Sin(2^0 * $i / 2^5) + 1) / 2) * 256
					$green = ((Sin(2^0 * $i / 2^7) + 1) / 2) * 256
					$blue = ((Sin(2^0 * $i / 2^9) + 1) / 2) * 256
					$hBrush1 = _GDIPlus_BrushCreateSolid("0x0F" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2))
					$Pen = _GDIPlus_PenCreate("0xEF" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2), 1)
					_GDIPlus_GraphicsClear($ParticleBuffer) ;clear buffer
					$k = $ref * 10
					$starting_point -= 0.05
					For $j = 1 To $k Step $dly
					$size = $i - $j
					$xcoord1 = $width / 2 - (($i - $j) / 2) + Sin($starting_point) * -Sin(($i - $j) * $Pi / 90) * 64 * $Dis / 10
					$ycoord1 = $height / 2 - (($i - $j) / 2) + -Cos($starting_point) * Cos(($i - $j) * $Pi / 90) * 32 * $Dis / 10
        			$xcoord2 = $width / 2 - (-($i - $j) / 2) + Sin($starting_point) * -Sin(($i - $j) * $Pi / 90) * 64 * $Dis / 10
    			    $ycoord2 = $height / 2 - (($i - $j) / 2) + -Cos($starting_point) * Cos(($i - $j) * $Pi / 90) * 32 * $Dis / 10
    			    _GDIPlus_GraphicsDrawRect($ParticleBuffer, $xcoord1, $ycoord1, $size, $size, $Pen)
;~    			     _GDIPlus_GraphicsFillRect($ParticleBuffer, $xcoord1, $ycoord1, $size, $size, $hBrush1)
				Next
					_GDIPlus_GraphicsDrawImageRect($hGraphic, $ParticleBitmap, 0, 0, $width, $height) ;copy to bitmap
					$i += 2
					If $i > $k + $ref * 10 Then $i = $start
					Sleep(20)
				Until GUIGetMsg() = $GUI_EVENT_CLOSE

			; Clean up resources
			_GDIPlus_GraphicsDispose ($hGraphic)
			_GDIPlus_BitmapDispose($ParticleBitmap)
			_GDIPlus_GraphicsDispose($ParticleBuffer)
			_GDIPlus_BrushDispose($hBrush1)
			_GDIPlus_Shutdown ()
			
			
EndFunc

Func AntiAlias($hGraphics, $iMode)
    Local $aResult
    $aResult = DllCall($ghGDIPDll, "int", "GdipSetSmoothingMode", "hwnd", $hGraphics, "int", $iMode)
    If @error Then Return SetError(@error, @extended, False)
    Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_AntiAlias

Func SCR_Options_Proc2($DisableParent=0)
    Local $iMsg, $ParentHwnd = 0
    While 1
        $iMsg = GUIGetMsg($GUI)
        Switch $iMsg
            Case $GUI_EVENT_CLOSE
                ;Enable back the parent dialog
                If $DisableParent = 1 Then WinSetState($ParentHwnd, "", @SW_ENABLE)
                Exit
            Case $Preview_Button
				Global $Dis = GUICtrlRead($Input2)
				Global $dly = GUICtrlRead($Input1)
				Global $ref = GUICtrlRead($Input3)
				ScreenSaver_Proc()
        EndSwitch
    WEnd
EndFunc