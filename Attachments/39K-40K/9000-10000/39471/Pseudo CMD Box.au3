;Build 2013-01-28
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--best --lzma


#include <GuiButton.au3>
#include <GuiImageList.au3>
;~ #include <Array.au3>;~~~
#include <Constants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GUIEdit.au3>
#include <Misc.au3>
#include <ScrollBarConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("CaretCoordMode", 0)
Global $aPalette[21] = [0xFFFFFF, 0x000000, 0xC0C0C0, 0x808080, _
										 0xFF0000, 0x800000, 0xFFFF00, 0x808000, _
										 0x00FF00, 0x008000, 0x00FFFF, 0x008080, _
										 0x0000FF, 0x000080, 0xFF00FF, 0x800080, _
										 0xC0DCC0, 0xA6CAF0, 0xFFFBF0, 0xA0A0A4, 0xABCDEF]

Global Const $hFullScreen = WinGetHandle("[TITLE:Program Manager;CLASS:Progman]")
Global Const $aFullScreen = WinGetPos($hFullScreen)

_GDIPlus_Startup()
Global Const $iW = 736, $iH = 369, $sFont = "Lucida Console"
Global $iFGColor = 0xC0C0C0, $iBGColor = 0x000000, $__Enum
Global Const $hGUI = GUICreate("CMD Box Emulator 2012 Alpha Version by UEZ", 736, 450, -1, -1, -1, $WS_EX_CONTEXTHELP + $WS_EX_ACCEPTFILES)
Global Const $idEdit = GUICtrlCreateEdit($hGUI, 0, 0, $iW, $iH, BitOR($ES_AUTOVSCROLL, $WS_HSCROLL, $WS_VSCROLL, $ES_MULTILINE, $ES_WANTRETURN))
Global Const $hEdit = GUICtrlGetHandle($idEdit)
Global $sCMDLine = @HomeDrive & @HomePath
Global $sPrefix = StringStripWS(StringStripCR(ExecuteCMD("ver")), 3)
Global $iPrefixLen = StringLen($sCMDLine & ">")
Global Const $iColorTxt = $iFGColor
GUICtrlSetData($idEdit, $sPrefix & @CRLF & _
		"Copyright (c) 2009 Microsoft Corporation.  All rights reserved." & @CRLF & @CRLF)
GUICtrlSetFont($idEdit, 10, 600, 0, $sFont, 5)
GUICtrlSetColor($idEdit, $iColorTxt)
GUICtrlSetBkColor($idEdit, $iBGColor)
_GUICtrlEdit_SetLimitText($hEdit, -1)

Global Const $iStartx = 30, $iBtnWidth = 80, $iStarty = 390
Global Const $idButton_Dir = GUICtrlCreateButton("Dir", $iStartx, $iStarty, $iBtnWidth, 40)
Global Const $hButton_Dir = GUICtrlGetHandle($idButton_Dir)
Global Const $sButton_DirNN = _WinAPI_GetClassName($hButton_Dir) & _GetNN($hButton_Dir)

Global Const $idButton_IPC = GUICtrlCreateButton("IPConfig", 2 * $iStartx + 1 * $iBtnWidth, $iStarty, $iBtnWidth, 40)
Global Const $hButton_IPC = GUICtrlGetHandle($idButton_IPC)
Global Const $sButton_IPCNN = _WinAPI_GetClassName($hButton_IPC) & _GetNN($hButton_IPC)

Global Const $idButton_Ping = GUICtrlCreateButton("Ping", 3 * $iStartx + 2 * $iBtnWidth, $iStarty, $iBtnWidth, 40)
Global Const $hButton_Ping = GUICtrlGetHandle($idButton_Ping)
Global Const $sButton_PingNN = _WinAPI_GetClassName($hButton_Ping) & _GetNN($hButton_Ping)

Global Const $idButton_RunBatch = GUICtrlCreateButton("Run Batch", 4 * $iStartx + 3 * $iBtnWidth, $iStarty, $iBtnWidth, 40, $BS_DEFPUSHBUTTON)
GUICtrlSetBkColor(-1, 0xE0FFE0)
Global Const $hButton_RunBatch = GUICtrlGetHandle($idButton_RunBatch)
Global Const $sButton_RunBatchNN = _WinAPI_GetClassName($hButton_RunBatch) & _GetNN($hButton_RunBatch)

Global Const $idButton_Exit = GUICtrlCreateButton("Exit", $iW - $iBtnWidth - $iStartx, $iStarty, $iBtnWidth, 40)
Global Const $hButton_Exit= GUICtrlGetHandle($idButton_Exit)
Global Const $sButton_ExitNN = _WinAPI_GetClassName($hButton_Exit) & _GetNN($hButton_Exit)

Global Const $idLable_ChgBGColor = GUICtrlCreateLabel("Change BG Color",  5 * $iStartx + 4 * $iBtnWidth, $iStarty - 10)
Global Const $idLable_ChgFGColor = GUICtrlCreateLabel("Change FG Color",  5 * $iStartx + 4 * $iBtnWidth, $iStarty + 14)
Global Const $idLable_ChgFont = GUICtrlCreateLabel("Change Font",  5 * $iStartx + 4 * $iBtnWidth, $iStarty + 36)
Global $iStyle = $BS_SPLITBUTTON + $BCSS_NOSPLIT
If @OSBuild < 6000 Then $iStyle = Default
Global Const $idButton_ChgBGColor = GUICtrlCreateButton("", 5 * $iStartx + 4 * $iBtnWidth + 92, $iStarty - 12, 40, 18, $iStyle)
Global Const $hButton_ChgBGColor = GUICtrlGetHandle($idButton_ChgBGColor)
Global Const $sButton_ChgBGColorNN = _WinAPI_GetClassName($hButton_ChgBGColor) & _GetNN($hButton_ChgBGColor)
_GUICtrlButton_SetSplitInfo($hButton_ChgBGColor, -1, $BCSS_NOSPLIT)

Global Const $idButton_ChgFGColor  = GUICtrlCreateButton("", 5 * $iStartx + 4 * $iBtnWidth + 92, $iStarty + 12, 40, 18, $iStyle)
Global Const $hButton_ChgFGColor = GUICtrlGetHandle($idButton_ChgFGColor)
Global Const $sButton_ChgFGColorNN = _WinAPI_GetClassName($hButton_ChgFGColor) & _GetNN($hButton_ChgFGColor)
_GUICtrlButton_SetSplitInfo($hButton_ChgFGColor, -1, $BCSS_NOSPLIT)

Global Const $idButton_ChgFont = GUICtrlCreateButton("...", 5 * $iStartx + 4 * $iBtnWidth + 92, $iStarty + 34, 40, 18, $BS_TOP)
Global Const $hButton_ChgFont = GUICtrlGetHandle($idButton_ChgFont)
Global Const $sButton_ChgFontNN = _WinAPI_GetClassName($hButton_ChgFont) & _GetNN($hButton_ChgFont)

Global $hImage_BG = _GUIImageList_Create(14, 10, 5, 3)
Global $hBmp_BG = _WinAPI_CreateSolidBitmap($hButton_ChgBGColor, $iBGColor, 14, 10)
_GUIImageList_Add($hImage_BG, $hBmp_BG)
_GUICtrlButton_SetImageList($hButton_ChgBGColor, $hImage_BG, 1)

Global $hImage_FG = _GUIImageList_Create(14, 10, 5, 3)
_GUIImageList_Add($hImage_FG, _WinAPI_CreateSolidBitmap($hButton_ChgFGColor, $iFGColor, 14, 10))
_GUICtrlButton_SetImageList($hButton_ChgFGColor, $hImage_FG, 1)

Global $hBitmap = CreateCaretBitmap()
Global $aBlinkTime = DllCall('user32.dll', 'int', 'GetCaretBlinkTime')
Global $iBlinkTime_save = $aBlinkTime[0]
Global $iBlinkTime = Int($aBlinkTime[0] * 0.9)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

GUISetState()

_GUICtrlEdit_AppendText($hEdit, $sCMDLine & ">")
GUISetIcon(@SystemDir & "\cmd.exe", 0, $hGUI)

;~ ControlClick("", "", $idEdit)

Global $aCaretPos[2], $sFile, $aFont
Global $hEditWndProc = DllCallbackRegister("EditWndProc", "lresult", "hwnd;uint;wparam;lparam")
Global $hOldEditProc = _WinAPI_SetWindowLong($hEdit, $GWL_WNDPROC, DllCallbackGetPtr($hEditWndProc))

$aCaretPos = GetCaretPos()
;~ DllCall('user32.dll', 'int', 'SetCaretPos', 'int', $aCaretPos[0] + 100, 'int', $aCaretPos[1])
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES")

Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $idButton_Exit
			GUIRegisterMsg($WM_DROPFILES, "")
			GUIRegisterMsg($WM_COMMAND, "")
			_WinAPI_DeleteObject($hBmp_BG)
			_GUIImageList_Destroy($hImage_BG)
			_GUIImageList_Destroy($hImage_FG)
			_WinAPI_DeleteObject($hBitmap)
			_WinAPI_SetWindowLong($hEdit, $GWL_WNDPROC, $hOldEditProc)
			DllCallbackFree($hEditWndProc)
			DllCall('user32.dll', 'int', 'SetCaretBlinkTime', 'uint', $iBlinkTime_save)
			_GDIPlus_Shutdown()
			GUIDelete()
			Exit
		Case $idButton_Dir
			If ControlGetFocus($hGUI) <> $sButton_DirNN Then ContinueCase
			SendCommand2CMD("dir")
		Case $idButton_IPC
			If ControlGetFocus($hGUI) <> $sButton_IPCNN Then ContinueCase
			SendCommand2CMD("ipconfig")
		Case $idButton_Ping
			If ControlGetFocus($hGUI) <> $sButton_PingNN Then ContinueCase
			SendCommand2CMD("ping autoitscript.com -n 10")
		Case $idButton_RunBatch
			If ControlGetFocus($hGUI) <> $sButton_RunBatchNN Then ContinueCase
			$sFile = FileOpenDialog("Select a batch file to execute", "", "Batch File (*.cmd; *.bat)", 3, "", $hGUI)
			If @error Then
				MsgBox(64, "Information", "Aborted", 5, $hGUI)
				ContinueCase
			EndIf
			SendCommand2CMD($sFile)
		Case $idButton_ChgBGColor
			If ControlGetFocus($hGUI) <> $sButton_ChgBGColorNN Then ContinueCase
			ChooseColorBG($hGUI, $hButton_ChgBGColor, $aPalette, $hImage_BG, "BG")
		Case $idButton_ChgFGColor
			If ControlGetFocus($hGUI) <> $sButton_ChgFGColorNN Then ContinueCase
			ChooseColorBG($hGUI, $hButton_ChgFGColor, $aPalette, $hImage_FG, "FG")
		Case $idButton_ChgFont
			If ControlGetFocus($hGUI) <> $sButton_ChgFontNN Then ContinueCase
			$aFont = _ChooseFont($sFont, 10, 0, 600, False, False, False, $hGUI)
			If @error Then ContinueLoop
			GUICtrlSetFont($idEdit, $aFont[3], $aFont[4], $aFont[1], $aFont[2], 5)
			ControlFocus($hGUI, "", $idEdit)
	EndSwitch
Until False

Func ChooseColorBG($hGUI, $hControl, ByRef $aPalette, $hImageList, $xG)
	GUISetState(@SW_DISABLE, $hGUI)
	Local $aCtrlPos = MouseGetPos()
	Local Const $iUB = UBound($aPalette) - 1, $iWX = 4, $iWY = 5
	Local Const $dx = 4, $dy = 4, $iSizeW = 24, $iSizeH = 24
	Local $iW = $iWX * ($iSizeW + $dx) - $dx, $iH = $iWY * ($iSizeH + $dy) - $dy + 45
	Local $iX = $aCtrlPos[0] - $dx, $iY = $aCtrlPos[1] - $dy
	If ($iX + $iW) > $aFullScreen[2] Then $iX -= $iW - $dx * 2
	If ($iY + $iH) > $aFullScreen[3] Then $iY -= $iH - $dY * 2
	Local Const $hGUI_Color = GUICreate("", $iW, $iH, $iX, $iY, $WS_POPUP, $WS_EX_DLGMODALFRAME, $hGUI)
	Local Const $idButton_CC = GUICtrlCreateButton("More", $iW / 2 - 30, $iWY * ($iSizeH + $dy) + 5, 60, 30)
	Local $x, $y, $z
	Local $aCLabels[$iUB]
	While $z < $iUB
			$aCLabels[$z] = GUICtrlCreateLabel("", $x * ($iSizeW + $dx), $y * ($iSizeH + $dy), $iSizeW, $iSizeH, $SS_SUNKEN)
			GUICtrlSetBkColor($aCLabels[$z], $aPalette[$z])
			$x = Mod($x + 1, $iWX)
			If Not $x Then $y += 1
			$z += 1
	WEnd
	Local Const $min = $aCLabels[0], $max = $aCLabels[0] + UBound($aCLabels) - 1
	GUISetState(@SW_SHOW, $hGUI_Color)
	Local $aInfo, $c
	Do
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idButton_CC
				$c = _ChooseColor(2, 0, 2, $hGUI_Color)
				If @error Then ContinueLoop
				$aPalette[$iUB] = "0x" & Hex($c, 6)
				ChangeColor($max + 1, $min, $hControl, $hImageList, $xG)
				ExitLoop
		EndSwitch
		$aInfo = GUIGetCursorInfo($hGUI_Color)
		Switch $aInfo[2]
			Case 1
				If $aInfo[4] >= $min And $aInfo[4] <= $max Then
					ChangeColor($aInfo[4], $min, $hControl, $hImageList, $xG)
					ExitLoop
				EndIf
		EndSwitch
	Until False
	GUISetState(@SW_ENABLE, $hGUI)
	GUIDelete($hGUI_Color)
	ControlFocus($hGUI, "", $idEdit)
EndFunc

Func ChangeColor($iID, $min, $hControl, $hImageList, $xG)
	_GUIImageList_Remove($hImageList)
	_WinAPI_DeleteObject($hBmp_BG)
	Local Const $iColor = $aPalette[$iID - $min]
	$hBmp_BG = _WinAPI_CreateSolidBitmap($hControl, $iColor, 14, 10)
	_GUIImageList_Add($hImageList, $hBmp_BG)
	_GUICtrlButton_SetImageList($hControl, $hImageList, 1)
	If $xG = "BG" Then
		GUICtrlSetBkColor($idEdit, $iColor)
	Else
		GUICtrlSetColor($idEdit, $iColor)
		_WinAPI_DeleteObject($hBitmap)
		$hBitmap = CreateCaretBitmap(9, 14, "0xFF" & Hex($iColor, 6))
	EndIf
EndFunc

Func SendCommand2CMD($sCommand)
	ControlFocus($hGUI, "", $idEdit)
	ControlSend($hGUI, "", $idEdit, $sCommand & @LF)
EndFunc   ;==>SendCommand2CMD

Func EditWndProc($hWnd, $iMsg, $wParam, $lParam)
	Switch $iMsg
		Case $WM_KEYDOWN
			Switch $wParam
				Case 0x25 ;left
					$aCaretPos = GetCaretPos()
					If ($aCaretPos[0] / 9) <= $iPrefixLen Then
						DllCall('user32.dll', 'int', 'SetCaretPos', 'int', $aCaretPos[0] + 1, 'int', $aCaretPos[1])
						$aCaretPos = GetCaretPos()
						Return 1
					EndIf
				Case 0x0D ;enter
					Local $sCMD = StringMid(_GUICtrlEdit_GetLine($hEdit, _GUICtrlEdit_LineFromChar($hEdit)), $iPrefixLen + 1)
					If $sCMD <> "" Then
						ExecuteCMDRT($sCMD)
						$sCMDLine = StringReplace(ExecuteCMD("cd"), @CRLF, "")
						ExecuteCMD("cd /d " & $sCMDLine)
					EndIf
					$iPrefixLen = StringLen($sCMDLine & ">")
					_GUICtrlEdit_AppendText($hEdit, $sCMDLine & ">")
					_GUICtrlEdit_SetSel($hEdit, -1, -1)
					_GUICtrlEdit_Scroll($hEdit, $SB_SCROLLCARET)
					$aCaretPos = GetCaretPos()
					Sleep(30)
					Return 1
				Case 0x08, 0x24, 0x26, 0x28 ;backspace, home, arraow up, arrow down
					If _GUICtrlEdit_LineLength($hEdit) < $iPrefixLen Then
						_GUICtrlEdit_AppendText($hEdit, ">")
						$aCaretPos = GetCaretPos()
					EndIf
					Return 1
			EndSwitch
		Case $WM_LBUTTONDOWN
			DllCall('user32.dll', 'int', 'SetCaretPos', 'int', $aCaretPos[0], 'int', $aCaretPos[1])
			Return 1
	EndSwitch
	Return _WinAPI_CallWindowProc($hOldEditProc, $hWnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>EditWndProc

Func GetCaretPos() ;http://msdn.microsoft.com/en-us/library/ms648402(v=vs.85).aspx
	Local Const $Point = "LONG x;LONG y;"
	Local $sPoint = DllStructCreate($Point)
	DllCall("User32.dll", "int", "GetCaretPos", "ptr", DllStructGetPtr($sPoint))
	Local $aPos[2] = [DllStructGetData($sPoint, "x") - 1, DllStructGetData($sPoint, "y")]
	Return $aPos
EndFunc   ;==>GetCaretPos

Func ExecuteCMDRT($sCommand)
	Local $iPID, $line
	If StringMid($sCommand, 2, 1) = ":" Then
		$iPID = Run(@ComSpec & ' /c "' & $sCommand & '"', StringRegExpReplace($sCommand, "(.+\\)(.*)", "$1"), @SW_HIDE, $STDERR_MERGED) ;set working dir to path of file
	Else
		$iPID = Run(@ComSpec & ' /c "' & $sCommand & '"', $sCMDLine, @SW_HIDE, $STDERR_MERGED)
	EndIf
	While 1
		$line = StdoutRead($iPID)
		If @error Then ExitLoop
		_GUICtrlEdit_AppendText($hEdit, Oem2Ansi($line))
	WEnd
	_GUICtrlEdit_AppendText($hEdit, @CRLF)
EndFunc   ;==>ExecuteCMDRT

Func ExecuteCMD($sCommand)
	Local $iPID = Run(@ComSpec & ' /c "' & $sCommand & '"', $sCMDLine, @SW_HIDE, $STDERR_MERGED)
	Local $line
	While 1
		$line &= StdoutRead($iPID)
		If @error Then ExitLoop
	WEnd
	Return Oem2Ansi($line)
EndFunc   ;==>ExecuteCMD

Func Oem2Ansi($text)
	Local $aText = DllCall("user32.dll", "Int", "OemToChar", "str", $text, "str", "")
	Return $aText[2]
EndFunc   ;==>Oem2Ansi

Func CreateCaretBitmap($iW = 9, $iH = 14, $iColor = 0xFFC0C0C0)
	Local Const $aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
	Local Const $hBitmap = $aResult[6]
	Local Const $hCtx = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	Local Const $hBrush = _GDIPlus_BrushCreateSolid($iColor)
	_GDIPlus_GraphicsFillRect($hCtx, 0, $iH - 3, $iW, $iH, $hBrush)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hCtx)
	Local $hHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)
	Return $hHBitmap
EndFunc   ;==>CreateCaretBitmap

Func WM_DROPFILES($hWnd, $msg, $wParam, $lParam)
	Local $aRet = DllCall("shell32.dll", "int", "DragQueryFile", "int", $wParam, "int", -1, "ptr", 0, "int", 0)
	If @error Then Return SetError(1, 0, 0)
	Local $tBuffer = DllStructCreate("char[256]")
	DllCall("shell32.dll", "int", "DragQueryFile", "int", $wParam, "int", 0, "ptr", DllStructGetPtr($tBuffer), "int", DllStructGetSize($tBuffer))
	Local Const $sDroppedFiles = DllStructGetData($tBuffer, 1)
;~ 	Switch StringRight($sDroppedFiles, 4)
;~ 		Case ".cmd", ".bat"
	_GUICtrlEdit_AppendText($hEdit, $sDroppedFiles)
	$aCaretPos = GetCaretPos()
;~ 	EndSwitch
	DllCall("shell32.dll", "none", "DragFinish", "int", $wParam)
	$tBuffer = 0
	WinActivate($hWnd)
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_DROPFILES

Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	Switch BitShift($wParam, 16)
		Case $EN_SETFOCUS
			DllCall('user32.dll', 'int', 'CreateCaret', 'hwnd', $lParam, 'ptr', $hBitmap, 'int', 0, 'int', 0)
			DllCall('user32.dll', 'int', 'ShowCaret', 'hwnd', $lParam)
			DllCall('user32.dll', 'int', 'SetCaretBlinkTime', 'uint', $iBlinkTime)
			$aBlinkTime = DllCall('user32.dll', 'int', 'GetCaretBlinkTime')
			$iBlinkTime = $aBlinkTime[0]
		Case $EN_KILLFOCUS
			DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', $lParam)
			DllCall('user32.dll', 'int', 'DestroyCaret')
			DllCall('user32.dll', 'int', 'SetCaretBlinkTime', 'uint', $aBlinkTime[0])
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_COMMAND

Func _GetNN($hWnd)
	Local $List, $Text, $ID = 0
	$Text = _WinAPI_GetClassName($hWnd)
	If Not $Text Then
		Return -1
	EndIf
	$List = _WinAPI_EnumChildWindows(_WinAPI_GetAncestor($hWnd, $GA_ROOT), 0)
	If @error Then
		Return -1
	EndIf
	For $i = 1 To $List[0][0]
		If $List[$i][1] = $Text Then
			$ID += 1
		EndIf
		If $List[$i][0] = $hWnd Then
			ExitLoop
		EndIf
	Next
	If Not $ID Then
		Return -1
	EndIf
	Return $ID
EndFunc   ;==>_GetNN

Func _WinAPI_EnumChildWindows($hWnd, $fVisible = 1)
	If Not _WinAPI_GetWindow($hWnd, 5) Then
		Return SetError(1, 0, 0)
	EndIf
	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'int', 'hwnd;lparam')
	Dim $__Enum[101][2] = [[0]]
	DllCall('user32.dll', 'int', 'EnumChildWindows', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $fVisible)
	If (@error) Or (Not $__Enum[0][0]) Then
		$__Enum = 0
	EndIf
	DllCallbackFree($hEnumProc)
	If Not IsArray($__Enum) Then
		Return SetError(1, 0, 0)
	EndIf
	__Inc($__Enum, -1)
	Return $__Enum
EndFunc   ;==>_WinAPI_EnumChildWindows

Func __EnumWindowsProc($hWnd, $fVisible)
	If ($fVisible) And (Not _WinAPI_IsWindowVisible($hWnd)) Then
		Return 1
	EndIf
	__Inc($__Enum)
	$__Enum[$__Enum[0][0]][0] = $hWnd
	$__Enum[$__Enum[0][0]][1] = _WinAPI_GetClassName($hWnd)
	Return 1
EndFunc   ;==>__EnumWindowsProc

Func __Inc(ByRef $aData, $iIncrement = 100)
	Select
		Case UBound($aData, 2)
			If $iIncrement < 0 Then
				ReDim $aData[$aData[0][0] + 1][UBound($aData, 2)]
			Else
				$aData[0][0] += 1
				If $aData[0][0] > UBound($aData) - 1 Then
					ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, 2)]
				EndIf
			EndIf
		Case UBound($aData, 1)
			If $iIncrement < 0 Then
				ReDim $aData[$aData[0] + 1]
			Else
				$aData[0] += 1
				If $aData[0] > UBound($aData) - 1 Then
					ReDim $aData[$aData[0] + $iIncrement]
				EndIf
			EndIf
		Case Else
			Return 0
	EndSelect
	Return 1
EndFunc   ;==>__Inc