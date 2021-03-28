#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include <MsgBoxConstants.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <GuiComboBox.au3>
#include <Date.au3>
#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>

;#Region Metro Style GUI
$boolck1=False


Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Opt('PixelCoordMode', 1) ;Uses pixel coords relative to the absolute screen coordinates

GUIRegisterMsg(0xF, "WM_PAINT")

;~ GUICreate("ciao", 100, 100)
;~ GUISetState()

;~ MsgBox(16,"ciao","")

;$pid = Run("C:\pcekg\exe\wincrx32.exe", "", @SW_MAXIMIZE)

;ProcessWait($pid)

$GUIThemeColor = "0x009933"
$FontThemeColor = "0xFFFFFF"
$GUIControlThemeColorBG = StringReplace($GUIThemeColor, "0x", "0xFF")
$GUIControlThemeColor = StringReplace("0xFFFFFF", "0x", "0xFF");"0xff0099CC"
$borderCol = "0xFFFFFF";"0x0099CC"
$ButtonColorb_d = "0xff80CC99" ;"0x00a6d2", "0x", "0xFF")
$ButtonColorb_w = "0xffffffff";"0xff0077AA"
$ButtonColorb = "0xff009933";"0xff0099CC"
$FontButton_w = "0xffffffff"
$FontButton = "0xff009933"
$FontButton_h = "0xffffffff"

Global $msg
Sleep(4000)

nuovo()

Func nuovo()

$STM_SETIMAGE = 0x0172
_GDIPlus_Startup()

$Form1 = GUICreate("ECG GUI - INSERIMENTO DATI PAZIENTE", 940, 560, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP))
GUISetBkColor($GUIThemeColor)

$iCheckbox1 = GUICtrlCreatePic("", 480, 222, 385, 50)
$aiCheckbox1 = _GDIPlus_CreateTextButton("bbbbbbbbbb", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
$MinimizeButton = GUICtrlCreatePic("", 857, 15, 49, 41)
GUICtrlSetCursor(-1, 0)
$aMinimizeButton = _GDIPlus_CreateTextButton("_", 28, 28, $GUIControlThemeColorBG, 20, "Arial", "", $GUIControlThemeColor, $GUIControlThemeColor)

_WinAPI_DeleteObject(GUICtrlSendMsg($MinimizeButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aMinimizeButton[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[1]))
$bHide = False

GUISetState(@SW_SHOW)
_ClearMemory();To reduce the memory usage

$bool=False

While $bool=False
    Local $aMouseInfo, $bShow = False, $bHide = False
    Do

        If WinActive($Form1) Then
            $aMouseInfo = GUIGetCursorInfo($Form1)
            Switch $aMouseInfo[4]

			Case $iCheckbox1
					if $boolck1=False Then
						$aiCheckbox1 = _GDIPlus_CreateTextButton("bbbbbbbbbb", 155, 49, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_over($iCheckbox1,$aiCheckbox1)
					 EndIf
					 _ClearMemory()

			Case Else
					 if $boolck1=False Then
						$aiCheckbox1 = _GDIPlus_CreateTextButton("bbbbbbbbbb", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[1]))
					 EndIf

					 $bShow = True
					 $bHide = False

					_ClearMemory();To reduce the memory usage
			EndSwitch
        EndIf
	    $nMsg = GUIGetMsg()
        Switch $nMsg
			 Case $iCheckbox1
				  $boolck1=_onClick($boolck1,"bbbbbbbbbb",$iCheckbox1,$aiCheckbox1)
			 Case $MinimizeButton
                _WinAPI_DeleteObject($aMinimizeButton[1])

                _GDIPlus_Shutdown()
				$bool=True
				GUIDelete("ECG GUI - INSERIMENTO DATI PAZIENTE")
			 EndSwitch
	    Until $bool=True
WEnd

EndFunc   ;==>esci

Func _onClick($boolc,$sString,$iCheckbox,$aiCheckbox)
   if($boolc=False) Then
						$boolc=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox = _GDIPlus_CreateTextButton($sString, 155, 49, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
					    _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox, 370, 0, $aiCheckbox[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolc=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox3 = _GDIPlus_CreateTextButton($sString, 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						 _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox, 370, 0, $aiCheckbox[0]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()
					 return $boolc
 EndFunc

Func _over($But,$aBut)
   _WinAPI_DeleteObject(GUICtrlSendMsg($But, 370, 0, $aBut[1]))
                    $bShow = True
                    $bHide = False
					$temp=False
					_ClearMemory()
EndFunc

Func _onClickS($boolc,$sString1,$sString2,$iSex1,$iSex2,$aiSex1,$aiSex2)

					if($boolc=True) Then
						$boolc=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiSex2 = _GDIPlus_CreateTextButton($sString2, 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, 370, 0, $aiSex2[1]))
						$aiSex1 = _GDIPlus_CreateTextButton($sString1, 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, 370, 0, $aiSex1[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolc=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiSex1 = _GDIPlus_CreateTextButton($sString1, 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, 370, 0, $aiSex1[1]))
						$aiSex2 = _GDIPlus_CreateTextButton($sString2, 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, 370, 0, $aiSex2[1]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()
					 return $boolc

EndFunc


;~ ### error handling ###
Func MyErrFunc()
	$ErrorCode = 0
	If IsObj($oMyError) Then
		$ErrorCode = Hex($oMyError.number)
		TrayTip("Errore", "Errore", 5, 1)
		MsgBox(16 + 262144, "Errore", "Errore")

		Exit
		$oMyError.clear

	EndIf
EndFunc   ;==>MyErrFunc



;===============================================================================
;
; Function Name:    _ProcessGetHWnd
; Description:    Returns the HWND(s) owned by the specified process (PID only !).
;
; Parameter(s):  $iPid      - the owner-PID.
;                   $iOption    - Optional : return/search methods :
;                       0 - returns the HWND for the first non-titleless window.
;                       1 - returns the HWND for the first found window (default).
;                       2 - returns all HWNDs for all matches.
;
;                  $sTitle      - Optional : the title to match (see notes).
;                   $iTimeout   - Optional : timeout in msec (see notes)
;
; Return Value(s):  On Success - returns the HWND (see below for method 2).
;                       $array[0][0] - number of HWNDs
;                       $array[x][0] - title
;                       $array[x][1] - HWND
;
;                  On Failure   - returns 0 and sets @error to 1.
;
; Note(s):          When a title is specified it will then only return the HWND to the titles
;                   matching that specific string. If no title is specified it will return as
;                   described by the option used.
;
;                   When using a timeout it's possible to use WinWaitDelay (Opt) to specify how
;                   often it should wait before attempting another time to get the HWND.
;
;
; Author(s):        Helge
;
;===============================================================================
Func _ProcessGetHWnd($iPid, $iOption = 1, $sTitle = "", $iTimeout = 2000)
	Local $aReturn[1][1] = [[0]], $aWin, $hTimer = TimerInit()

	While 1

		; Get list of windows
		$aWin = WinList($sTitle)

		; Searches thru all windows
		For $i = 1 To $aWin[0][0]

			; Found a window owned by the given PID
			If $iPid = WinGetProcess($aWin[$i][1]) Then

				; Option 0 or 1 used
				If $iOption = 1 Or ($iOption = 0 And $aWin[$i][0] <> "") Then
					Return $aWin[$i][1]

					; Option 2 is used
				ElseIf $iOption = 2 Then
					ReDim $aReturn[UBound($aReturn) + 1][2]
					$aReturn[0][0] += 1
					$aReturn[$aReturn[0][0]][0] = $aWin[$i][0]
					$aReturn[$aReturn[0][0]][1] = $aWin[$i][1]
				EndIf
			EndIf
		Next

		; If option 2 is used and there was matches then the list is returned
		If $iOption = 2 And $aReturn[0][0] > 0 Then Return $aReturn

		; If timed out then give up
		If TimerDiff($hTimer) > $iTimeout Then ExitLoop

		; Waits before new attempt
		Sleep(Opt("WinWaitDelay"))
	WEnd


	; No matches
	SetError(1)
	Return 0
EndFunc   ;==>_ProcessGetHWnd

;#Region Metro-Style Requiered Functions
Func _GDIPlus_CreateTextButton($sString, $iWidth, $iHeight, $iBgColor = 0xFF1BA0E1, $iFontSize = 22, $sFont = "Arial", $iHoverColor = 0x3E3E3E, $iFontFrameColor = 0x0099CC, $iFontColor = 0x0099CC, $iFrameThickness = 4);MetroStyle Button Funktion
    If $sString = "" Then Return SetError(1, 0, 0)
    If Int($iWidth) < 4 Then Return SetError(2, 0, 0)
    If Int($iHeight) < 4 Then Return SetError(3, 0, 0)
    Local Const $hFormat = _GDIPlus_StringFormatCreate()
    Local Const $hFamily = _GDIPlus_FontFamilyCreate($sFont)
    Local $tLayout = _GDIPlus_RectFCreate(0, 0, $iWidth, 0)
    _GDIPlus_StringFormatSetAlign($hFormat, 1)
    Local Const $aBitmaps[2] = [_GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight), _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)]
    Local Const $aGfxCtxt[2] = [_GDIPlus_ImageGetGraphicsContext($aBitmaps[0]), _GDIPlus_ImageGetGraphicsContext($aBitmaps[1])]
    _GDIPlus_GraphicsSetSmoothingMode($aGfxCtxt[0], $GDIP_SMOOTHINGMODE_HIGHQUALITY)
    _GDIPlus_GraphicsSetTextRenderingHint($aGfxCtxt[0], $GDIP_TEXTRENDERINGHINT_ANTIALIASGRIDFIT)
    Local Const $hBrushFontColor = _GDIPlus_BrushCreateSolid($iFontColor)
    $hPenFontFrameColor = _GDIPlus_PenCreate($iFontFrameColor, $iFrameThickness)
    $hPenHoverColor = _GDIPlus_PenCreate($iHoverColor, 3)
    Local Const $hPath = _GDIPlus_PathCreate()
    Local Const $hPath_Dummy = _GDIPlus_PathClone($hPath)
    _GDIPlus_PathAddString($hPath_Dummy, $sString, $tLayout, $hFamily, 0, $iFontSize, $hFormat)
	Local $aInfo[10]
	$aInfo[3] = 10.0
    $aInfo = _GDIPlus_PathGetWorldBounds($hPath_Dummy)
    $tLayout.Y = ($iHeight - $aInfo[3]) / 2 - Ceiling($aInfo[1])
    _GDIPlus_PathAddString($hPath, $sString, $tLayout, $hFamily, 0, $iFontSize, $hFormat)
    _GDIPlus_GraphicsClear($aGfxCtxt[0], $iBgColor)
    _GDIPlus_GraphicsFillPath($aGfxCtxt[0], $hPath, $hBrushFontColor)
    _GDIPlus_GraphicsDrawPath($aGfxCtxt[0], $hPath, $hPenFontFrameColor)
    _GDIPlus_GraphicsDrawImageRect($aGfxCtxt[1], $aBitmaps[0], 0, 0, $iWidth, $iHeight)
    _GDIPlus_GraphicsDrawRect($aGfxCtxt[1], 0, 0, $iWidth - 1, $iHeight - 1, $hPenHoverColor)
    $hPenFontFrameColor = _GDIPlus_PenCreate($iFontFrameColor, ($iFrameThickness - 1))
    _GDIPlus_GraphicsSetSmoothingMode($sFont, 2)
    _GDIPlus_GraphicsClear($aGfxCtxt[0], $iBgColor)
    _GDIPlus_GraphicsFillPath($aGfxCtxt[0], $hPath, $hBrushFontColor)
    _GDIPlus_GraphicsDrawPath($aGfxCtxt[0], $hPath, $hPenFontFrameColor)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_PathDispose($hPath)
    _GDIPlus_PathDispose($hPath_Dummy)
    _GDIPlus_GraphicsDispose($aGfxCtxt[0])
    _GDIPlus_GraphicsDispose($aGfxCtxt[1])
    _GDIPlus_BrushDispose($hBrushFontColor)
    _GDIPlus_PenDispose($hPenFontFrameColor)
    _GDIPlus_PenDispose($hPenHoverColor)
    Local $aHBitmaps[2] = [_GDIPlus_BitmapCreateHBITMAPFromBitmap($aBitmaps[0]), _GDIPlus_BitmapCreateHBITMAPFromBitmap($aBitmaps[1])]
    _GDIPlus_BitmapDispose($aBitmaps[0])
    _GDIPlus_BitmapDispose($aBitmaps[1])
    Return $aHBitmaps
EndFunc   ;==>_GDIPlus_CreateTextButton
Func _CreateBorder($guiW, $guiH, $bordercolor = 0xFFFFFF, $style = 1, $borderThickness = 1)
    If $style = 0 Then
        ;#TOP#
        GUICtrlCreateLabel("", 0, 0, $guiW - 1, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Bottom
        GUICtrlCreateLabel("", 0, $guiH - $borderThickness, $guiW - 1, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Left
        GUICtrlCreateLabel("", 0, 1, $borderThickness, $guiH - 1)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Right
        GUICtrlCreateLabel("", $guiW - $borderThickness, 1, $borderThickness, $guiH - 1)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
    Else
        ;#TOP#
        GUICtrlCreateLabel("", 1, 1, $guiW - 2, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Bottom
        GUICtrlCreateLabel("", 1, $guiH - $borderThickness - 1, $guiW - 2, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Left
        GUICtrlCreateLabel("", 1, 1, $borderThickness, $guiH - 2)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Right
        GUICtrlCreateLabel("", $guiW - $borderThickness - 1, 1, $borderThickness, $guiH - 2)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
    EndIf
EndFunc   ;==>_CreateBorder
Func _ClearMemory($i_PID = -1)
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    Return $ai_Return[0]
EndFunc   ;==>_ClearMemory
;#EndRegion Metro-Style Requiered Functions
