#Region Header

#cs

	Title:			Management of Context Help UDF Library for AutoIt3
	Filename:		ContextHelp.au3
	Description:	Creating context help text for GUI controls
	Author:			Yashied
	Version:		1.0
	Requirements:	AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
	Uses:			WinAPI.au3
	Notes:			Original library by R.Gilman (a.k.a. rasim)
					(http://www.autoitscript.com/forum/index.php?showtopic=72152)

	Available functions:

	_ContextHelp_Create
	_ContextHelp_Delete

	Example:

		#Include <ContextHelp.au3>
		#Include <WindowsConstants.au3>

		Global $Edit, $ButtonOk, $ButtonCancel

		GUICreate('Test', 400, 250, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU), $WS_EX_CONTEXTHELP)
		$Edit = GUICtrlCreateEdit('', 10, 10, 380, 202)
		_ContextHelp_Create($Edit, 'Simple text')
		$ButtonOk = GUICtrlCreateButton('OK', 127, 220, 70, 23)
		_ContextHelp_Create($ButtonOk, 'Press "OK" button')
		$ButtonCancel = GUICtrlCreateButton('Cancel', 203, 220, 70, 23)
		_ContextHelp_Create($ButtonCancel, 'Press "Cancel" button')
		GUISetState()

		Do
		Until GUIGetMsg() = -3

#ce

#Include-once

#Include <WinAPI.au3>

#EndRegion Header

#Region Local Variables and Constants

Dim $cxId[1][12] = [[0, -1]]

#cs
	
DO NOT USE THIS ARRAY IN THE SCRIPT, INTERNAL USE ONLY!

$cxId[0][0 ]   - Count item of array
     [0][1 ]   - DLL "handle" (HHCtrl.ocx)
     [0][2-10] - Don`t used

$cxId[i][0 ]   - Handle of the given control ID
     [i][1 ]   - Text which be showed to context help
     [i][2 ]   - The name of the font
     [i][3 ]   - Font size
     [i][4 ]   - Font attribute
     [i][5 ]   - Color of text in BGR value
     [i][6 ]   - Color of backgrond in BGR value
     [i][7 ]   - Left margin
     [i][8 ]   - Top margin
     [i][9 ]   - Right margin
     [i][10]   - Bottom margin
     [i][11]   - Flag
	
#ce

Global Const $HH_DISPLAY_TEXT_POPUP = 0x000E
Global Const $HH_CLOSE_ALL = 0x0012

Global Const $CX_WM_HELP = 0x0053

Global $OnContextHelpExit = Opt('OnExitFunc', 'OnContextHelpExit')

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _ContextHelp_Create
; Description ...: Creates a context help item for the GUI.
; Syntax.........: _ContextHelp_Create ( $hWnd, $sText [, $iTextColor [, $iBGColor [, $sFontName [, $sFontSize [, $sFontAttribute [, $iMarginLeft [, $iMarginTop [, $iMarginRight [, $iMarginBottom [, $iFlag]]]]]]]]]] )
; Parameters ....: $hWnd           - Handle or identifier (controlID) to the control
;                  $sText          - Text which be showed to context help. The following characters are contained in the string will be replaced to:
;                  |"&" to " " (#255)
;                  |"|" to @CR
;                  |"~" to @TAB
;                  $iTextColor     - Color of text in HEX (RGB) value
;                  $iBGColor       - Color of backgrond in HEX (RGB) value
;                  $sFontName      - The name of the font (Default is "MS Sans Serif")
;                  $sFontSize      - Font size (Default is 8.5)
;                  $sFontAttribute - Font attributes, valid values:
;                  |PLAIN (Default)
;                  |BOLD
;                  |ITALIC
;                  |UNDERLINE
;                  $iMarginLeft    - Left margins
;                  $iMarginTop     - Top margins
;                  $iMarginRight   - Right margins
;                  $iMarginBottom  - Bottom margins
;                  $Flags          - Context help show flag, valid values:
;                  |0 - Always show (Default)
;                  |1 - Don`t show context help if controls is disabled
; Return values .: Success         - 1
;                  Failure         - 0 and sets the @error flag to non-zero.
; Author ........: Yashied
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _ContextHelp_Create($hWnd, $sText, $iTextColor = -1, $iBGColor = -1, $sFontName = '', $sFontSize = -1, $sFontAttribute = '', $iMarginLeft = -1, $iMarginTop = -1, $iMarginRight = -1, $iMarginBottom = -1, $iFlag = 0)
	
	Local $n = 0

	$sFontName = StringStripWS($sFontName, 3)
	$sFontAttribute = StringStripWS($sFontAttribute, 3)
	
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	
	If $iTextColor > 0 Then
		$iTextColor = BitAND($iTextColor, 0x00FF00) + BitShift(BitAND($iTextColor, 0x0000FF), -16) + BitShift(BitAND($iTextColor, 0xFF0000), 16)
	EndIf
	If $iBGColor > 0 Then
		$iBGColor = BitAND($iBGColor, 0x00FF00) + BitShift(BitAND($iBGColor, 0x0000FF), -16) + BitShift(BitAND($iBGColor, 0xFF0000), 16)
	EndIf
	If $sFontName = '' Then
		$sFontName = 'MS Sans Serif'
	EndIf
	If $sFontSize < 0 Then
		$sFontSize = '8.5'
	EndIf
	If $sFontAttribute = '' Then
		$sFontAttribute = 'PLAIN'
	EndIf
	
	If $cxId[0][0] = 0 Then
		$cxId[0][1] = DllOpen('HHCtrl.ocx')
		If $cxId[0][1] = -1 Then
			Return SetError(1, 0, 0)
		EndIf
		If Not GUIRegisterMsg($CX_WM_HELP, 'CX_WM_HELP') Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	
	For $i = 1 to $cxId[0][0]
		If $hWnd = $cxId[$i][0] Then
			$n = $i
			ExitLoop
		EndIf
	Next
	If $n = 0 Then
		$n = $cxId[0][0] + 1
		ReDim $cxId[$n + 1][UBound($cxId, 2)]
		$cxId[0][0] = $n
	EndIf
	
	$cxId[$n][0 ] = $hWnd
	$cxId[$n][1 ] = StringReplace(StringReplace(StringReplace($sText, '&', ' '), '|', @CR), '~', @TAB)
	$cxId[$n][2 ] = $sFontName
	$cxId[$n][3 ] = String($sFontSize)
	$cxId[$n][4 ] = $sFontAttribute
	$cxId[$n][5 ] = $iTextColor
	$cxId[$n][6 ] = $iBGColor
	$cxId[$n][7 ] = $iMarginLeft
	$cxId[$n][8 ] = $iMarginTop
	$cxId[$n][9 ] = $iMarginRight
	$cxId[$n][10] = $iMarginBottom
	$cxId[$n][11] = $iFlag
	
	Return SetError(0, 0, 1)
EndFunc   ;==>_ContextHelp_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _ContextHelp_Delete
; Description ...: Deletes a context help item.
; Syntax.........: _ContextHelp_Delete ( $hWnd )
; Parameters ....: $hWnd   - Handle or identifier (controlID) to the control
; Return values .: Success - 1
;                  Failure - 0 and sets the @error flag to non-zero.
; Author ........: Yashied
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _ContextHelp_Delete($hWnd)
	
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	
	For $i = 1 to $cxId[0][0]
		If $hWnd = $cxId[$i][0] Then
			For $j = $i To $cxId[0][0] - 1
				For $k = 0 To UBound($cxId, 2) - 1
					$cxId[$j][$k] = $cxId[$j + 1][$k]
				Next
			Next
			$cxId[0][0] -= 1
			ReDim $cxId[$cxId[0][0] + 1][UBound($cxId, 2)]
			If $cxId[0][0] = 0 Then
				GUIRegisterMsg($CX_WM_HELP, '')
			EndIf
			Return SetError(0, 0, 1)
		EndIf
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>_ContextHelp_Delete

#EndRegion Public Functions

#Region Windows Message Functions

Func CX_WM_HELP($hWnd, $iMsg, $wParam, $lParam)

	Local $tHELPINFO = DllStructCreate('uint cbSize;int iContextType;int iCtrlId;hwnd hItemHandle;int dwContextId;int MousePos[2]', $lParam)
	Local $hControl = DllStructGetData($tHELPINFO, 'hItemHandle')
	
	For $i = 1 To $cxId[0][0]
		If $hControl = $cxId[$i][0] Then
			
			If  (BitAND($cxId[$i][11], 0x01) = 0x01) And (Not ControlCommand($hControl, '', '', 'IsEnabled')) Then
				ExitLoop
			EndIf
			
			Local $sFont = $cxId[$i][2] & ',' & $cxId[$i][3] & ',,' & $cxId[$i][4]
			
			Local $tRECT = _WinAPI_GetWindowRect($hControl)
			Local $tHH_POPUP = DllStructCreate('int cbStruct;hwnd hInst;uint idString;ptr pszText;int pt[2];dword clrForeground;dword clrBackground;long rcMargins[4];ptr pszFont')
			Local $tText = DllStructCreate('char[' & (StringLen($cxId[$i][1]) + 1) & ']')
			Local $tFont = DllStructCreate('char[' & (StringLen($sFont) + 1) & ']')
			
			Local $XPos = DllStructGetData($tHELPINFO, 'MousePos', 1)
			Local $YPos = DllStructGetData($tHELPINFO, 'MousePos', 2)
			Local $iLeft = DllStructGetData($tRECT, 1)
			Local $iTop = DllStructGetData($tRECT, 2)
			Local $iRight = DllStructGetData($tRECT, 3)
			Local $iBottom = DllStructGetData($tRECT, 4)

			If ($XPos < $iLeft) Or ($XPos > $iRight) Or ($YPos < $iTop) Or ($YPos > $iBottom) Then
				$XPos = $iLeft
				$YPos = $iTop + 15
			EndIf

			DllStructSetData($tText, 1, $cxId[$i][1])
			DllStructSetData($tFont, 1, $sFont)

			DllStructSetData($tHH_POPUP, 'cbStruct', DllStructGetSize($tHH_POPUP))
			DllStructSetData($tHH_POPUP, 'idString', 0)
			DllStructSetData($tHH_POPUP, 'rcMargins', $cxId[$i][7 ], 1)
			DllStructSetData($tHH_POPUP, 'rcMargins', $cxId[$i][8 ], 2)
			DllStructSetData($tHH_POPUP, 'rcMargins', $cxId[$i][9 ], 3)
			DllStructSetData($tHH_POPUP, 'rcMargins', $cxId[$i][10], 4)
			DllStructSetData($tHH_POPUP, 'pszText', DllStructGetPtr($tText))
			DllStructSetData($tHH_POPUP, 'pszFont', DllStructGetPtr($tFont))
			DllStructSetData($tHH_POPUP, 'clrForeground', $cxId[$i][5])
			DllStructSetData($tHH_POPUP, 'clrBackground', $cxId[$i][6])
			DllStructSetData($tHH_POPUP, 'pt', $XPos, 1)
			DllStructSetData($tHH_POPUP, 'pt', $YPos, 2)
			
			DllCall($cxId[0][1], 'hwnd', 'HtmlHelp', 'hwnd', 0, 'ptr', 0, 'int', $HH_DISPLAY_TEXT_POPUP, 'dword', DllStructGetPtr($tHH_POPUP))

			$tRECT = 0
			$tHH_POPUP = 0
			$tText = 0
			$tFont = 0
			
			ExitLoop
		EndIf
	Next
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>CX_WM_HELP

#EndRegion Windows Message Functions

#Region OnAutoItExit

Func OnContextHelpExit()
	GUIRegisterMsg($CX_WM_HELP, '')
	If $cxId[0][1] > -1 Then
		DllCall($cxId[0][1], 'hwnd', 'HtmlHelp', 'hwnd', 0, 'ptr', 0, 'int', $HH_CLOSE_ALL, 'dword', 0)
		DllClose($cxId[0][1])
	EndIf
	Call($OnContextHelpExit)
EndFunc   ;==>OnContextHelpExit

#EndRegion OnAutoItExit
