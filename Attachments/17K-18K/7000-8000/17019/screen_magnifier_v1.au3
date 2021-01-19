;#####################################################
#cs
Screen Magnifier, Pixel pos and Window info tool
all-in-one, by Siao
Usage:
	Main window resizeable
	Left click drags window
	Right click brings up options
	etc.
#ce
;#####################################################

#include <GUIConstants.au3>

#NoTrayIcon
Opt("WinWaitDelay", 0)
Opt("GUICloseOnESC", 0)
Opt("GUIOnEventMode", 1)

Global Const $WM_MOVING = 0x0216
;~ Global Const $WM_SIZING = 0x0214
;cursors
Global Const $IDC_SIZEALL = 32646
Global Const $IDC_ARROW = 32512
;~ Global Const $WM_SETCURSOR  = 0x0020
;Drag constants
Global Const $HTCAPTION = 2
Global Const $WM_NCLBUTTONDOWN = 0xA1
;raster opcodes
;normal:
Global Const $SRCCOPY = 0xCC0020
Global Const $MERGECOPY = 0xC000CA
;inverted:
Global Const $NOTSRCCOPY = 0x330008
;text constants:
Global Const $DT_RIGHT = 0x2

Global $nZoomFactor = 2, $aMPosOld[2], $nTrans = 200
Global $iSleepTime = 90, $nTimer = 0, $bShowMini = 1, $bShowText = 1, $bAlwaysCenter = 0, $bInvert = 0, $bMouseUpdate = 1, $bSave = 0

;Main view GUI
$hGuiMain = GUICreate("Magnifier by Siao", 400, 300, -1, -1, _
					BitOR($WS_POPUP,$WS_BORDER,$WS_SIZEBOX+$WS_CLIPCHILDREN), _
					$WS_EX_TOPMOST _
					);+$WS_EX_LAYERED+$WS_EX_TRANSPARENT

;Mini view GUI
$hGuiMini = GUICreate("Aimpoint 5x5", 128,128,400-130,0,$WS_CHILD+$WS_BORDER, -1, $hGuiMain)


;Options GUI
#Region ### START Koda GUI section ### Form=d:\miniprojects\autoit3\magnifier\guioptions.kxf
$hGuiOpt = GUICreate("Magnifier Options", 305, 230, -1, -1, BitOR($WS_SYSMENU,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS), -1, $hGuiMain)
$btnMin = GUICtrlCreateButton("Minimize", 5, 5, 145, 25, 0)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$btnQuit = GUICtrlCreateButton("Quit Program", 155, 5, 145, 25, 0)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$SliderTrans = GUICtrlCreateSlider(6, 54, 19, 165, BitOR($TBS_VERT,$TBS_AUTOTICKS))
GUICtrlSetCursor (-1, 11)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$grp1 = GUICtrlCreateGroup("View options", 60, 40, 235, 147)
$SliderZoom = GUICtrlCreateSlider(126, 60, 161, 19);, $TBS_AUTOTICKS)
GUICtrlSetLimit(-1, 100, 1)
GUICtrlSetData(-1, 2)
GUICtrlSetCursor (-1, 13)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$cbInvert = GUICtrlCreateCheckbox("Invert colors", 76, 90, 93, 21)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$cbCenter = GUICtrlCreateCheckbox("Always center", 76, 108, 93, 21)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$Label1 = GUICtrlCreateLabel("Zoom:", 74, 60, 50, 17)
$cbInfoPix = GUICtrlCreateCheckbox("Show pixel info", 182, 108, 93, 21)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$cbInfoWin = GUICtrlCreateCheckbox("Show win info", 182, 90, 93, 21)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$inTimer = GUICtrlCreateInput("", 192, 136, 37, 21, $ES_NUMBER)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$Label3 = GUICtrlCreateLabel("Update time (ms):", 106, 138, 86, 17)
$cbMouseUpdate = GUICtrlCreateCheckbox("Update only on mouse move", 104, 159, 161, 21)
GUICtrlSetOnEvent(-1, "OptionsEvents")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label2 = GUICtrlCreateLabel("Trans:", 6, 40, 34, 17)
$Label4 = GUICtrlCreateLabel("(c) Siao, 2007", 300, 226, 1, 1, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetCursor (-1, 0)
$Label5 = GUICtrlCreateLabel("0", 30, 204, 10, 17)
$Label6 = GUICtrlCreateLabel("255", 30, 57, 22, 17)
$cbSave = GUICtrlCreateCheckbox("Remember options", 70, 194, 113, 30)
GUICtrlSetOnEvent(-1, "OptionsEvents")
$btnOK = GUICtrlCreateButton("OK", 198, 194, 87, 29, 0)
GUICtrlSetOnEvent(-1, "OptionsEvents")
GUISetState(@SW_DISABLE)
GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###

_LoadOptions()
GUISwitch($hGuiMain)

GUISetOnEvent($GUI_EVENT_CLOSE, "SystemEvents")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "SystemEvents")
GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "SystemEvents")

GUIRegisterMsg($WM_MOVING, "WindowEvents")
GUIRegisterMsg($WM_SIZING, "WindowEvents")

GUISetState()

;=== Main loop =========================================
While 1
	Sleep($iSleepTime)
	If BitAnd(WinGetState($hGuiMain), 16) Then ContinueLoop
	If BitAnd(WinGetState($hGuiOpt), 2) Then ContinueLoop
	_Zoom($nZoomFactor, _ZoomGetOptions())
WEnd
;========================================================

Func OptionsEvents()
	Switch @GUI_CtrlId
		Case $btnOK
			WinToggle(@GUI_WinHandle)
		Case $btnMin
			WinToggle(@GUI_WinHandle)
			GUISetState(@SW_MINIMIZE, $hGuiMain)
		Case $btnQuit
			_CloseProgram()
		Case $cbInvert
			$bInvert = BitXOR($bInvert, 1)
		Case $cbInfoPix
			$bShowMini =BitXOR($bShowMini, 1)
			WinToggle($hGuiMini)
		Case $cbInfoWin
			$bShowText = BitXOR($bShowText, 1)
		Case $cbCenter
			$bAlwaysCenter = BitXOR($bAlwaysCenter, 1)
		Case $SliderZoom
			$nZoomFactor = GUICtrlRead($SliderZoom)
			GUICtrlSetData($Label1, "Zoom: x" & $nZoomFactor)
		Case $SliderTrans
			$nTrans = 0-GUICtrlRead($SliderTrans)
			WinSetTrans($hGuiMain, "", $nTrans)
;~ 			GUICtrlSetTip($SliderTrans, $nTrans)
		Case $inTimer
			$iSleepTime = Int(GUICtrlRead($inTimer))
		Case $cbMouseUpdate
			$bMouseUpdate = BitXOR($bMouseUpdate, 1)
		Case $cbSave
			$bSave = BitXOR($bSave, 1)
			;_SaveOptions()
	EndSwitch
EndFunc

Func WindowEvents($hWnd, $Msg, $wParam, $lParam)
	Switch $Msg
		Case $WM_MOVING
			;zoom while moving
			If TimerDiff($nTimer) > $iSleepTime Then 
				_Zoom($nZoomFactor, _ZoomGetOptions())
				$nTimer = TimerInit()
			EndIf
		Case $WM_SIZING
			Local $tRECT = DllStructCreate("long; long; long; long", $lParam)
			$aTmp = WinGetPos($hGuiMini)
			DllCall("user32.dll", "int", "MoveWindow", "hwnd", $hGuiMini, _
									"int", DllStructGetData($tRECT, 3)-DllStructGetData($tRECT, 1)-$aTmp[2]-8, _
									"int", 0, _
									"int", $aTmp[2], "int", $aTmp[3], "int", False)
	EndSwitch
EndFunc

Func SystemEvents()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			_CloseProgram()
		Case $GUI_EVENT_PRIMARYDOWN
			_ChangeCursor($IDC_SIZEALL)
			Drag($hGuiMain)
		Case $GUI_EVENT_PRIMARYUP
			;
		Case $GUI_EVENT_SECONDARYDOWN
			If Not BitAnd(WinGetState($hGuiOpt), 2) Then
				If Not IsDeclared("aMPosOld") Then Global $aMPosOld[2] = [0,0]
				;Options gui size - 305,230
				WinMove($hGuiOpt, "", Min(Max($aMPosOld[0]-50, 0), @DesktopWidth-305), _
										Min(Max($aMPosOld[1]-50, 0), @DesktopHeight-230))
				WinToggle($hGuiOpt)
			EndIf
	EndSwitch
EndFunc

Func _CloseProgram()
	If BitAND(GUICtrlRead($cbSave), $GUI_CHECKED) Then 
		_SaveOptions()
	Else
		_ClearOptions()
	EndIf
	Exit
EndFunc

;by Zedna
Func Drag($h)
;~ 	dllcall("user32.dll","int","ReleaseCapture")
    DllCall("user32.dll","int","SendMessage","hWnd", $h,"int",$WM_NCLBUTTONDOWN,"int", $HTCAPTION,"int", 0)
EndFunc

Func WinToggle($hWin)
	If BitAND(WinGetState($hWin), 6) Then
		GUISetState(@SW_DISABLE, $hWin)
		GUISetState(@SW_HIDE, $hWin)
	Else
		GUISetState(@SW_ENABLE, $hWin)
		GUISetState(@SW_SHOW, $hWin)
	EndIf
EndFunc

Func _SaveOptions()
	$aPos = WinGetPos($hGuiMain)
	RegWrite("HKCU\SOFTWARE\SiaoSoft\Magnifier v1", "WindowPos", "REG_SZ", $aPos[0] & ";" & $aPos[1] & ";" & $aPos[2] & ";" & $aPos[3])
	$sOptions = $nTrans & ";" & $nZoomFactor & ";" & $bInvert & ";" & $bAlwaysCenter & ";" &  _
				$bShowText & ";" & $bShowMini & ";" & $iSleepTime & ";" & $bMouseUpdate & ";" & $bSave
	RegWrite("HKCU\SOFTWARE\SiaoSoft\Magnifier v1", "Options", "REG_SZ", $sOptions)
EndFunc
Func _LoadOptions()
	$aWinPos = StringSplit(RegRead("HKCU\SOFTWARE\SiaoSoft\Magnifier v1", "WindowPos"), ";")
	If $aWinPos[0] = 4 Then
		WinMove($hGuiMain, "", Int($aWinPos[1]), Int($aWinPos[2]), Int($aWinPos[3]), Int($aWinPos[4]))
		$aTmp = WinGetPos($hGuiMini)
		WinMove($hGuiMini, "", Int($aWinPos[3])-$aTmp[2]-8, 0)
	EndIf
	$aOpts = StringSplit(RegRead("HKCU\SOFTWARE\SiaoSoft\Magnifier v1", "Options"), ";")	
	If $aOpts[0] = 9 Then
		$nTrans = Int($aOpts[1])
		$nZoomFactor = Int($aOpts[2])
		$bInvert = Int($aOpts[3])
		$bAlwaysCenter = Int($aOpts[4])
		$bShowText = Int($aOpts[5])
		$bShowMini = Int($aOpts[6])
		$iSleepTime = Int($aOpts[7])
		$bMouseUpdate = Int($aOpts[8])
		$bSave = Int($aOpts[9])
	EndIf
	If $bShowMini Then GUICtrlSetState($cbInfoPix, $GUI_CHECKED)
	If $bShowText Then GUICtrlSetState($cbInfoWin, $GUI_CHECKED)
	If $bMouseUpdate Then GUICtrlSetState($cbMouseUpdate, $GUI_CHECKED)
	If $bInvert Then GUICtrlSetState($cbInvert, $GUI_CHECKED)
	If $bAlwaysCenter Then GUICtrlSetState($cbCenter, $GUI_CHECKED)
	If $bSave Then GUICtrlSetState($cbSave, $GUI_CHECKED)
	GUICtrlSetLimit($SliderZoom, 10, 1)
	GUICtrlSetLimit($SliderTrans, 0, -255)
	DllCall("user32.dll","int","SendMessage","hWnd", ControlGetHandle($hGuiOpt, "", $SliderZoom),"int",$TBM_SETTICFREQ,"int", 1,"int", 0)
	DllCall("user32.dll","int","SendMessage","hWnd", ControlGetHandle($hGuiOpt, "", $SliderTrans),"int",$TBM_SETTICFREQ,"int", 16,"int", 0)
	GUICtrlSetData($SliderZoom, $nZoomFactor)
	GUICtrlSetData($Label1, "Zoom: x" & $nZoomFactor)
	GUICtrlSetData($SliderTrans, 0-$nTrans)
	GUICtrlSetData($inTimer, $iSleepTime)
	WinSetTrans($hGuiMain, "", $nTrans)
	GUICtrlSetState($btnOK, $GUI_FOCUS)
	If $bShowMini Then GUISetState(@SW_SHOW, $hGuiMini)
EndFunc
Func _ClearOptions()
	$sRegRoot = "HKCU\SOFTWARE\SiaoSoft"
	RegDelete($sRegRoot & "\Magnifier v1")
	RegEnumKey($sRegRoot, 1)
	$err = @error
	RegEnumVal($sRegRoot, 1)
	If @error <> 0 And $err <> 0 Then RegDelete($sRegRoot)
EndFunc

Func _ChangeCursor($lpCursorName = 0)
	If $lpCursorName <> 0 Then
		$aRet = DllCall("user32.dll","long","LoadCursor","long",0,"long",$lpCursorName)
		$hCurs = $aRet[0]
	Else
		$hCurs = 0
	EndIf
	$aRet = DllCall("user32.dll","long","SetCursor","hwnd",$hCurs)
	Return $aRet[0]
EndFunc

Func _ZoomGetOptions()
	$nOptions = 0
	If $bShowMini Then $nOptions += 1
	If $bShowText Then $nOptions += 2
	If $bMouseUpdate Then $nOptions += 4
	If $bAlwaysCenter Then $nOptions += 8
	If $bInvert Then $nOptions += 16
	Return $nOptions
EndFunc

Func _Zoom($zf, $dwOptions)
;===============================================================================
; Parameter(s):     $zf - zoom factor
;					$dwOptions - Can be a combination of the following:
;						1 = Show mini window
;						2 = Show window info
;						4 = Update on mouse move only
;						8 = Always center view (on screen edges)
;						16 = Invert colors
;===============================================================================
	Local $aMPos, $aMainSize, $aMiniSize, $aMyMainDC, $aMyMiniDC, $aScreenDC, $aPen, $aPenOld, $aMiniFont, $aMiniFontOld
	Local $tRECT, $srcW, $srcH, $srcX, $srcY, $sPixel, $sWinInfo
	
    $aMPos = MouseGetPos()
	If Not IsDeclared("aMPosOld") Then Global $aMPosOld[2] = [0,0]
	If BitAND($dwOptions, 4) And $aMPos[0] = $aMPosOld[0] And $aMPos[1] = $aMPosOld[1] Then Return
	$aMPosOld = $aMPos
	$aMainSize = WinGetClientSize($hGuiMain)
	$aMiniSize = WinGetClientSize($hGuiMini)
    $aMyMainDC = DLLCall("user32.dll","int","GetDC","hwnd",$hGuiMain)
	$aMyMiniDC = DLLCall("user32.dll","int","GetDC","hwnd",$hGuiMini)
	$aScreenDC = DLLCall("user32.dll","int","GetDC","hwnd",0)
	$tRECT = DllStructCreate("long; long; long; long")

	$srcW = $aMainSize[0] / $zf
	$srcH = $aMainSize[1] / $zf
	If BitAND($dwOptions, 8) Then
		$srcX = $aMPos[0] - $aMainSize[0] / (2 * $zf)
		$srcY = $aMPos[1] - $aMainSize[1] / (2 * $zf)
		$dwRop = $MERGECOPY
	Else
		$srcX = Min(Max($aMPos[0] - $aMainSize[0] / (2 * $zf), 0), @DesktopWidth-$srcW)
		$srcY = Min(Max($aMPos[1] - $aMainSize[1] / (2 * $zf), 0), @DesktopHeight-$srcH)
		$dwRop = $SRCCOPY
	EndIf

	If BitAND($dwOptions, 16) Then $dwRop = $NOTSRCCOPY

	DLLCall("gdi32.dll","int","StretchBlt", _
		"int",$aMyMainDC[0],"int", 0,"int",0,"int",$aMainSize[0],"int",$aMainSize[1], _
		"int",$aScreenDC[0],"int", $srcX,"int",$srcY,"int",$srcW,"int",$srcH, _
		"long", $dwRop)
				
	If BitAND($dwOptions, 1) Then
		; strech 5x5 area around cursor into Mini gui
		DLLCall("gdi32.dll","int","StretchBlt", _
			"int",$aMyMiniDC[0],"int", 0,"int",0,"int",$aMiniSize[0],"int",$aMiniSize[1], _
			"int",$aScreenDC[0],"int", $aMPos[0]-2,"int",$aMPos[1]-2,"int",5,"int",5, _
			"long", $dwRop)
		;draw crosshair on top of it
		DLLCall("gdi32.dll","int","Arc", "hwnd", $aMyMiniDC[0], _
							"int", 0, "int", 0, "int", $aMiniSize[0], "int", $aMiniSize[1], _
							"int", 0, "int", $aMiniSize[1]/2, "int", 0, "int", $aMiniSize[1]/2)
		$aPen = DLLCall("gdi32.dll","hwnd","CreatePen", "int", 3, "int", 0, "int", 0x00000000)
		$aPenOld = DLLCall("gdi32.dll","hwnd","SelectObject", "hwnd", $aMyMiniDC[0], "hwnd", $aPen[0])
		DLLCall("gdi32.dll","int","MoveToEx", "hwnd", $aMyMiniDC[0], "int", 0, "int", $aMiniSize[1]/2, "ptr", 0)
		DLLCall("gdi32.dll","int","LineTo", "hwnd", $aMyMiniDC[0], "int", $aMiniSize[0], "int", $aMiniSize[1]/2)
		DLLCall("gdi32.dll","int","MoveToEx", "hwnd", $aMyMiniDC[0], "int", $aMiniSize[0]/2, "int", 0, "ptr", 0)
		DLLCall("gdi32.dll","int","LineTo", "hwnd", $aMyMiniDC[0], "int", $aMiniSize[0]/2, "int", $aMiniSize[1])
		;draw pixel color/pos text
		DllStructSetData($tRECT, 1, 0)
		DllStructSetData($tRECT, 2, 0)
		DllStructSetData($tRECT, 3, $aMiniSize[0])
		DllStructSetData($tRECT, 4, 14)		
		$aMiniFont = DLLCall("gdi32.dll","int","CreateFont", "int", 14, "int", 0, "int", 0, "int", 0, "int", 700, _
								"dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, _
								"dword", 0, "str", "")
		$aMiniFontOld = DLLCall("gdi32.dll","hwnd","SelectObject", "hwnd", $aMyMiniDC[0], "hwnd", $aMiniFont[0])
		$sPixel = " 0x" & Hex(PixelGetColor($aMPos[0],$aMPos[1]),6) & " at " & $aMPos[0] & "," & $aMPos[1] & "               "
		DLLCall("user32.dll","int","DrawText", "hwnd", $aMyMiniDC[0], _
							"str", $sPixel, "int", StringLen($sPixel), "ptr", DllStructGetPtr($tRECT), "uint", 0)
		DLLCall("gdi32.dll","hwnd","SelectObject", "hwnd", $aMyMiniDC[0], "hwnd", $aMiniFontOld[0])
		DLLCall("gdi32.dll","int","DeleteObject", "hwnd", $aMiniFont[0])
		DLLCall("gdi32.dll","hwnd","SelectObject", "hwnd", $aMyMiniDC[0], "hwnd", $aPenOld[0])
		DLLCall("gdi32.dll","int","DeleteObject", "hwnd", $aPen[0])
	EndIf
	
	If BitAND($dwOptions, 2) Then
		;get and show window/control info
		$sWinInfo = _WinInfoFromPoint($aMPos[0], $aMPos[1])	
		DllStructSetData($tRECT, 1, 0)
		DllStructSetData($tRECT, 2, $aMainSize[1]-48)
		DllStructSetData($tRECT, 3, $aMainSize[0])
		DllStructSetData($tRECT, 4, $aMainSize[1])
		DLLCall("user32.dll","int","DrawText", "hwnd", $aMyMainDC[0], _
							"str", $sWinInfo, "int", StringLen($sWinInfo), "ptr", DllStructGetPtr($tRECT), "uint", $DT_RIGHT)
	EndIf

	DLLCall("user32.dll","int","ReleaseDC","hwnd",0,"hwnd",$aScreenDC[0])
    DLLCall("user32.dll","int","ReleaseDC","hwnd",$hGuiMain,"hwnd",$aMyMainDC[0])
	DLLCall("user32.dll","int","ReleaseDC","hwnd",$hGuiMini,"hwnd",$aMyMiniDC[0])

EndFunc

;Gets window/control info from cursor pos, returns formatted string
Func _WinInfoFromPoint($nX, $nY)
	Local $tStrBuff, $pStrBuff, $aRet, $hWnd, $hOwnerWnd, $sClassName, $sOwnerClass, $sWinText
	$tStrBuff = DllStructCreate("char[100]")
	$pStrBuff = DllStructGetPtr($tStrBuff)
	$aRet = DllCall("user32.dll", "hwnd", "WindowFromPoint", "uint", $nX, "uint", $nY)
	$hWnd = $aRet[0]
	$aRet = DllCall("user32.dll", "int", "GetClassName", "hwnd", $hWnd, "ptr", $pStrBuff, "int", 100)
	$sClassName = DllStructGetData($tStrBuff, 1)
	DllStructSetData($tStrBuff, 1, "")
	DllCall("user32.dll", "int", "GetWindowText", "hwnd", $hWnd, "ptr", $pStrBuff, "int", 100)
;~ 	DllCall("user32.dll", "int", "SendMessage", "hwnd", $hWnd, "uint", $WM_GETTEXT, "uint", 100, "ptr", $pStrBuff)
	$sWinText = DllStructGetData($tStrBuff, 1)
	DllStructSetData($tStrBuff, 1, "")	
	$aRet = DllCall("user32.dll", "hwnd", "GetAncestor", "hwnd", $hWnd, "uint", 2) ;$GA_ROOT = 2
	$hOwnerWnd = $aRet[0]
	$aRet = DllCall("user32.dll", "int", "GetClassName", "hwnd", $hOwnerWnd, "ptr", $pStrBuff, "int", 100)
	$sOwnerClass = DllStructGetData($tStrBuff, 1)
	DllStructSetData($tStrBuff, 1, "")

	Return $sWinText & @CRLF & "[ Class: " & $sClassName & "; hWnd: " & $hWnd & " ]" & @CRLF & _
						"( Owner: " & $sOwnerClass & "; " & $hOwnerWnd & " )"
EndFunc

Func Min($n1, $n2)
	If $n1 < $n2 Then Return $n1
	Return $n2
EndFunc
Func Max($n1, $n2)
	If $n1 > $n2 Then Return $n1
	Return $n2
EndFunc

;================ 
