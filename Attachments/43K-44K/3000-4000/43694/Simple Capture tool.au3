#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.10.2
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#pragma compile(FileVersion, 1.0.0.4)
#pragma compile(FileDescription, 'Capture tool')
#pragma compile(LegalCopyright, © demon Corporation)
#pragma compile(UPX, false)
#pragma compile(Compression, 9)
#pragma compile(ExecLevel, asInvoker)

; By FireFox, 2014
; Version : 1.4

#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <ClipBoard.au3>
#include <ColorConstants.au3>
#include <Constants.au3>

; Settings
Global $_fShowMousePos = True, $_fShowRectSize = True, $_fHideDesktop = False, $_fHideTaskBar = False

If HotKeySet("{PRINTSCREEN}", "Example") = 0 Then
	MsgBox($MB_SYSTEMMODAL, "", "Could not set the hotkey !")
	Exit 1
EndIf

HotKeySet("^+{3}", "Example") ;for Windows under a MacBook lacking of a PrintScreen key (yes... me)

While 1
    Sleep(10000) ;10 sec
WEnd

Func Example()
    Local $iX1 = 0, $iY1 = 0, $iX2 = 0, $iY2 = 0
    Local $hGUICapture = 0

    Mark_Rect($hGUICapture, $iX1, $iY1, $iX2, $iY2)

    Local $hBitmap = _ScreenCapture_CaptureWnd("", $hGUICapture, $iX1, $iY1, $iX2, $iY2, False)
    GUIDelete($hGUICapture)

    Local $fOpenCb = _ClipBoard_Open(0)
	If Not $fOpenCb Then
		MsgBox($MB_SYSTEMMODAL, "", "Could not open the clipboard !")
		Return False
	EndIf

    _ClipBoard_Empty()

    Local $hBitmap3 = _WinAPI_CopyImage($hBitmap, 0, 0, 0, BitOR($LR_COPYDELETEORG, $LR_COPYRETURNORG))
    _WinAPI_DeleteObject($hBitmap)

    _ClipBoard_SetDataEx($hBitmap3, $CF_BITMAP)
    _ClipBoard_Close()

    _WinAPI_DeleteObject($hBitmap3)
EndFunc   ;==>Example

Func Mark_Rect(ByRef $hGUICapture, ByRef $iX1, ByRef $iY1, ByRef $iX2, ByRef $iY2)
    Local $iX_Pos = 0, $iY_Pos = 0, $iTemp = 0, $iWidth = 0, $iHeight = 0
    Local $hMask_1 = 0

    Local $hWnd = WinGetHandle("[TITLE:Program Manager;CLASS:Progman]")
    Local $aWgp = WinGetPos($hWnd)

	If $_fHideDesktop Then
		ControlHide($hWnd, "", "[CLASS:SysListView32; INSTANCE:1]")
	EndIf

	If $_fHideTaskBar Then
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
		WinSetState("[CLASS:Button]", "", @SW_HIDE)
	EndIf

    Local $hBitmap = _ScreenCapture_Capture("", $aWgp[0], $aWgp[1], $aWgp[2], $aWgp[3])

	Local $aSize[2] = [$aWgp[2], $aWgp[3]]
	$aWgp = 0

    $hGUICapture = GUICreate("", $aSize[0], $aSize[1], 0, 0, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_APPWINDOW, $WS_EX_TOPMOST))
    GUISetCursor($IDC_CROSS, 1, $hGUICapture)

    If $giGDIPRef = 0 Then
        _GDIPlus_Startup()
    EndIf

    Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUICapture)

    Local $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
    _WinAPI_DeleteObject($hBitmap)

    WinSetTrans($hGUICapture, "", 0)

    GUISetState(@SW_SHOWNOACTIVATE, $hGUICapture)

    _GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)

    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_ImageDispose($hImage)

    If $giGDIPRef > 1 Then
        _GDIPlus_Shutdown()
    EndIf

    WinSetTrans($hGUICapture, "", 255)

	If $_fHideTaskBar Then
		WinSetState("[CLASS:Button]", "", @SW_SHOWNOACTIVATE)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOWNOACTIVATE)
	EndIf

	If $_fHideDesktop Then
		ControlShow($hWnd, "", "[CLASS:SysListView32; INSTANCE:1]")
	EndIf

    Local $hGUIRect = GUICreate("", $aSize[0], $aSize[1], 0, 0, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
    GUISetBkColor($COLOR_BLACK)
    GUISetCursor($IDC_CROSS, 1, $hGUIRect)

    _GUICreateInvRect($hGUIRect, $aSize, $hMask_1, 0, 0, 1, 1)

    WinSetTrans($hGUIRect, "", 75)
    GUISetState(@SW_SHOWNOACTIVATE, $hGUIRect)

    Local $hUserDLL = DllOpen("user32.dll")
    Local $aMgp = 0
    Local $fExitLoop = False

    ; Wait until mouse button pressed
    While Not _IsPressed("01", $hUserDLL) And Not $fExitLoop
        If $_fShowMousePos Then
            $aMgp = MouseGetPos()
            ToolTip("x: " & $aMgp[0] & ", y: " & $aMgp[1], _
                    $aMgp[0] + ($aMgp[0] > 100 ? -95 : 10), _
                    $aMgp[1] + ($aMgp[1] > 50 ? -35 : 10))
        EndIf

        Sleep(10)
        If _IsPressed("1B", $hUserDLL) Then $fExitLoop = True
    WEnd

    If $_fShowMousePos Then
        ToolTip("")
    EndIf

    ; Get first mouse position
    $aMgp = MouseGetPos()
    $iX1 = $aMgp[0]
    $iY1 = $aMgp[1]

    ; Draw rectangle while mouse button pressed
    While _IsPressed("01", $hUserDLL) And Not $fExitLoop
        $aMgp = MouseGetPos()

        ; Set in correct order if required
        If $aMgp[0] < $iX1 Then
            $iX_Pos = $aMgp[0]
            $iWidth = $iX1 - $aMgp[0]
        Else
            $iX_Pos = $iX1
            $iWidth = $aMgp[0] - $iX1
        EndIf
        If $aMgp[1] < $iY1 Then
            $iY_Pos = $aMgp[1]
            $iHeight = $iY1 - $aMgp[1]
        Else
            $iY_Pos = $iY1
            $iHeight = $aMgp[1] - $iY1
        EndIf

        _GUICreateInvRect($hGUIRect, $aSize, $hMask_1, $iX_Pos, $iY_Pos, $iWidth, $iHeight)

        If $_fShowRectSize Then
            ToolTip("w: " & Abs($aMgp[0] - $iX1) & ", h: " & Abs($aMgp[1] - $iY1), _
                    $aMgp[0] + ((($aMgp[0] > $aSize[0] - 100 Or ($aMgp[0] - $iX1 < 0 And $aMgp[1] - $iY1 < 0)) And $aMgp[0] > 100) ? -95 : 10), _
                    $aMgp[1] + ((($aMgp[1] > $aSize[1] - 40 Or ($aMgp[0] - $iX1 < 0 And $aMgp[1] - $iY1 < 0)) And $aMgp[1] > 40) ? -35 : 10))
        EndIf

        Sleep(10)
        If _IsPressed("1B", $hUserDLL) Then $fExitLoop = True
    WEnd

    If $_fShowRectSize Then
        ToolTip("")
    EndIf

    _WinAPI_DeleteObject($hMask_1)

    ; Get second mouse position
    $iX2 = $aMgp[0]
    $iY2 = $aMgp[1]

    ; Set in correct order if required
    If $iX2 < $iX1 Then
        $iTemp = $iX1
        $iX1 = $iX2
        $iX2 = $iTemp
    EndIf
    If $iY2 < $iY1 Then
        $iTemp = $iY1
        $iY1 = $iY2
        $iY2 = $iTemp
    EndIf

    GUIDelete($hGUIRect)
    DllClose($hUserDLL)
EndFunc   ;==>Mark_Rect

Func _GUICreateInvRect($hWnd, $aSize, ByRef $hMask_1, $iX, $iY, $iW, $iH)
    Local $hMask_2 = 0, $hMask_3 = 0, $hMask_4 = 0

    $hMask_1 = _WinAPI_CreateRectRgn(0, 0, $aSize[0], $iY)
    $hMask_2 = _WinAPI_CreateRectRgn(0, 0, $iX, $aSize[1])
    $hMask_3 = _WinAPI_CreateRectRgn($iX + $iW, 0, $aSize[0], $aSize[1])
    $hMask_4 = _WinAPI_CreateRectRgn(0, $iY + $iH, $aSize[0], $aSize[1])

    _WinAPI_CombineRgn($hMask_1, $hMask_1, $hMask_2, 2)
    _WinAPI_CombineRgn($hMask_1, $hMask_1, $hMask_3, 2)
    _WinAPI_CombineRgn($hMask_1, $hMask_1, $hMask_4, 2)

    _WinAPI_DeleteObject($hMask_2)
    _WinAPI_DeleteObject($hMask_3)
    _WinAPI_DeleteObject($hMask_4)

    _WinAPI_SetWindowRgn($hWnd, $hMask_1, 1)
EndFunc   ;==>_GUICreateInvRect