#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Yashied

 Script Function:
    Run Dialog.

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper
#AutoIt3Wrapper_Outfile=Output\Run.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=Opens a program, folder, document, or Web site
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Au3check=n
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, DIALOG, 1000,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, MENU, 166,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, ICON, 161,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, ICON, 162,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, ICON, 164,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, ICON, 169,
#EndRegion AutoIt3Wrapper

#Region Initialization

#NoTrayIcon

#Include <ComboConstants.au3>
#Include <GUIComboBoxEx.au3>
#Include <GUIConstantsEx.au3>
#Include <GUIEdit.au3>
#Include <Misc.au3>
#Include <WindowsConstants.au3>

#include <UDFs\MRU.au3>

Opt('MustDeclareVars', 1)
Opt('MouseCoordMode', 2)
Opt('WinTitleMatchMode', 3)

Global Const $GUI_NAME = 'Run'
Global Const $REG_KEY_NAME = 'HKCU\SOFTWARE\' & $GUI_NAME

Global Const $GCL_HICON = -14
Global Const $GCL_HICONSM = -34

Global Const $WIN_LEFT_TOP = 0
Global Const $WIN_RIGHT_TOP = 1
Global Const $WIN_LEFT_BOTTOM = 2
Global Const $WIN_RIGHT_BOTTOM = 3

Global Const $WM_DROPFILES = 0x0233

If _Singleton('RunDlg', 1) = 0 Then
	WinActivate('Run')
	Exit
EndIf

Global $Form, $GUIMsg, $Combo, $Dummy, $Input, $ButtonOk, $ButtonCancel, $ButtonBrowse
Global $Cmd, $pCmd = '', $Parameters = StringStripWS(_RegRead($REG_KEY_NAME, 'Parameters', 'REG_SZ', ''), 3)
Global $Mru = _MRU_Create($REG_KEY_NAME & '\MRU'), $Fn, $Path = @MyDocumentsDir
Global $Width, $Height

#EndRegion Initialization

#Region Main State

If $CmdLine[0] > 0 Then
	Select
		Case StringLower($CmdLine[1]) = '/reset'
			_MRU_Reset($Mru)
			_MRU_RegWrite($Mru)
			_MRU_Release($Mru)
			RegWrite($REG_KEY_NAME, 'Parameters', 'REG_SZ', '')
			Exit
		Case Else
			$pCmd = $CmdLine[1]
			$Parameters = ''
	EndSelect
EndIf

CreateForm()

While 1
	$GUIMsg = GUIGetMsg()
	Select
		Case ($GUIMsg = $ButtonCancel) Or ($GUIMsg = $GUI_EVENT_CLOSE)
			_MRU_Release($Mru)
			Exit
		Case ($GUIMsg = $ButtonOk)
			$Fn = StringStripWS(GUICtrlRead($Combo), 3)
			$Parameters = StringStripWS(GUICtrlRead($Input), 3)
			If $Fn > '' Then
				ShellExecute($Fn, $Parameters)
				If Not @error Then
					_MRU_AddItem($Mru, $Fn)
					_MRU_RegWrite($Mru)
					_MRU_Release($Mru)
					RegWrite($REG_KEY_NAME, 'Parameters', 'REG_SZ', $Parameters)
					Exit
				EndIf
			EndIf
		Case ($GUIMsg = $ButtonBrowse)
			$Fn = FileOpenDialog('Select File', $Path, 'All files (*.*)', 1 + 2, '', $Form)
			If $Fn > '' Then
				$Path = StringRegExpReplace($Fn, '\\[^\\]*$', '')
				GUICtrlSetState($Combo, $GUI_FOCUS)
				_GUICtrlComboBox_SetEditText($Combo, $Fn)
				_GUICtrlComboBox_SetEditSel($Combo, 0, -1)
			EndIf
		Case ($GUIMsg = $Dummy)
			$Cmd = GUICtrlRead($Combo)
			If $Cmd <> $pCmd Then
				GUICtrlSetData($Input, '')
				$pCmd = $Cmd
			EndIf
	EndSelect
WEnd

#EndRegion Main State

#Region Additional Functions

Func CreateForm()

	Local $Parent

	$Form = _GUICreateDlgFrame($GUI_NAME, 380, 160, -1, -1, $WS_SIZEBOX, $WS_EX_ACCEPTFILES, GUICreate('', 0, 0, 0, 0, 0, $WS_EX_TOOLWINDOW))
	GUISetIcon(@SystemDir & '\shell32.dll', 25)

	GUISetFont(8.5, 400, 0, 'Tahoma', $Form)

	GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
	GUIRegisterMsg($WM_DROPFILES, 'WM_DROPFILES')
	GUIRegisterMsg($WM_GETMINMAXINFO, 'WM_GETMINMAXINFO')

	GUICtrlCreateIcon(@SystemDir & '\shell32.dll', 25, 12, 16, 32, 32)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetResizing(-1, 802)
	GUICtrlCreateLabel('Type the name of a program, folder, document, or Internet resource, and Windows will open it for you.', 56, 16, 310, 41)
	GUICtrlSetResizing(-1, 550)
	GUICtrlCreateLabel('Open:', 12, 61, 42, 14)
	GUICtrlSetResizing(-1, 802)
	$Combo = GUICtrlCreateCombo('', 56, 58, 310, 21, BitOR($CBS_AUTOHSCROLL, $CBS_DROPDOWN))
	GUICtrlSetData(-1, _MRU_GetAsString($Mru, '|'))
	GUICtrlSetResizing(-1, 550)
	$Dummy = GUICtrlCreateDummy()
	GUICtrlCreateLabel('With:', 12, 89, 42, 14)
	GUICtrlSetResizing(-1, 802)
	$Input = GUICtrlCreateInput($Parameters, 56, 86, 310, 21)
	GUICtrlSetResizing(-1, 550)
	GUICtrlSetResizing(-1, 550)
	If $pCmd = '' Then
		$pCmd = _Mru_GetItem($Mru, 1)
	EndIf
	_GUICtrlComboBox_SetEditText($Combo, $pCmd)
	If $CmdLine[0] > 0 Then
		GUICtrlSetState($Input, $GUI_FOCUS)
		_GUICtrlEdit_SetSel($Input, -1, -1)
	Else
		GUICtrlSetState($Combo, $GUI_FOCUS)
		_GUICtrlComboBox_SetEditSel($Combo, 0, -1)
	EndIf
	$ButtonOk = GUICtrlCreateButton('OK', 130, 129, 75, 23)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	GUICtrlSetResizing(-1, 804)
	$ButtonCancel = GUICtrlCreateButton('Cancel', 211, 129, 75, 23)
	GUICtrlSetResizing(-1, 804)
	$ButtonBrowse = GUICtrlCreateButton('Browse...', 292, 129, 75, 23)
	GUICtrlSetResizing(-1, 804)

	$Width = _GetWindowWidth($Form)
	$Height = _GetWindowHeight($Form)

	_SetWindowPos($Form, 3, 3, $Width, $Height, $WIN_LEFT_BOTTOM)

	GUISetState()

EndFunc   ;==>CreateForm

Func _GetDesktopArea()

	Const $SPI_GETWORKAREA = 48

	Local $tRect = DllStructCreate('long Left;long Top;long Right;long Bottom')
	Local $aRect[4], $aRet

	$aRet = DllCall('user32.dll', 'int', 'SystemParametersInfo', 'uint', $SPI_GETWORKAREA, 'uint', 0, 'ptr', DllStructGetPtr($tRect), 'uint', 0)
	If (@error) Or ($aRet[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf

	$aRect[0] = DllStructGetData($tRect, 'Left')
	$aRect[1] = DllStructGetData($tRect, 'Top')
	$aRect[2] = DllStructGetData($tRect, 'Right')
	$aRect[3] = DllStructGetData($tRect, 'Bottom')

	Return SetError(0, 0, $aRect)
EndFunc   ;==>_GetDesktopArea

Func _GetTaskbarHeight()

	Local $Desktop = _GetDesktopArea()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, @DesktopHeight - $Desktop[3])
EndFunc   ;==>_GetTaskbarHeight

Func _GetWindowHeight($hWnd)

	Local $tRet, $iHeight

	$tRet = _WinAPI_GetWindowPlacement($hWnd)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	$iHeight = DllStructGetData($tRet, 'rcNormalPosition', 4) - DllStructGetData($tRet, 'rcNormalPosition', 2)
	$tRet = 0

	Return SetError(0, 0, $iHeight)
EndFunc   ;==>_GetWindowHeight

Func _GetWindowWidth($hWnd)

	Local $tRet, $iWidth

	$tRet = _WinAPI_GetWindowPlacement($hWnd)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	$iWidth = DllStructGetData($tRet, 'rcNormalPosition', 3) - DllStructGetData($tRet, 'rcNormalPosition', 1)
	$tRet = 0

	Return SetError(0, 0, $iWidth)
EndFunc   ;==>_GetWindowWidth

Func _GUICreateDlgFrame($sTitle, $iWidth = -1, $iHeight = -1, $iLeft = -1, $iTop = -1, $iStyle = 0, $iExStyle = 0, $hParent = 0)

	Local $hWnd = GUICreate($sTitle, $iWidth, $iHeight, $iLeft, $iTop, BitOR($WS_CAPTION, $WS_SYSMENU, $iStyle), BitOR($WS_EX_DLGMODALFRAME, $iExStyle), $hParent)

	If (@error) Or ($hWnd = 0) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hIcon = _WinAPI_GetClassLong($hWnd, $GCL_HICON)

	If IsPtr($hIcon) Then
		_WinAPI_DestroyIcon($hIcon)
	EndIf

	_WinAPI_SetClassLong($hWnd, $GCL_HICON, 0)
	_WinAPI_SetClassLong($hWnd, $GCL_HICONSM, 0)

	Return SetError(0, 0, $hWnd)
EndFunc   ;==>_GUICreateDlgFrame

Func _MouseIn($X1, $Y1, $X2, $Y2)

	Local $pos

	$pos = MouseGetPos()
	If ($pos[0] >= $X1) And ($pos[0] <= $X2) And ($pos[1] >= $Y1) And ($pos[1] <= $Y2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_MouseIn

Func _RegRead($Key, $Value, $Type, $Default)

	Local $Val = RegRead($Key, $Value)

	If @error Then
		RegWrite($Key, $Value, $Type, $Default)
		Return $Default
	EndIf

	Switch StringUpper($Type)
		Case 'REG_SZ', 'REG_MULTI_SZ', 'REG_EXPAND_SZ'
			If Not IsString($Val) Then
				Return SetError(1, 0, $Default)
			EndIf
		Case 'REG_BINARY'
			If Not IsBinary($Val) Then
				Return SetError(1, 0, $Default)
			EndIf
		Case 'REG_DWORD'
			If Not IsInt($Val) Then
				Return SetError(1, 0, $Default)
			EndIf
		Case Else
			Return SetError(1, 0, $Default)
	EndSwitch
	Return $Val
EndFunc   ;==>_RegRead

Func _SetWindowPos($hWnd, $iX, $iY, $iWidth = -1, $iHeight = -1, $iFlag = $WIN_LEFT_TOP)

	Local $tRet

	$tRet = _WinAPI_GetWindowPlacement($hWnd)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	If $iWidth < 0 Then
		$iWidth = DllStructGetData($tRet, 'rcNormalPosition', 3) - DllStructGetData($tRet, 'rcNormalPosition', 1)
	EndIf
	If $iHeight < 0 Then
		$iHeight = DllStructGetData($tRet, 'rcNormalPosition', 4) - DllStructGetData($tRet, 'rcNormalPosition', 2)
	EndIf
	Switch $iFlag
		Case $WIN_LEFT_TOP
			DllStructSetData($tRet, 'rcNormalPosition', $iX, 1)
			DllStructSetData($tRet, 'rcNormalPosition', $iY, 2)
			DllStructSetData($tRet, 'rcNormalPosition', $iX + $iWidth, 3)
			DllStructSetData($tRet, 'rcNormalPosition', $iY + $iHeight, 4)
		Case $WIN_RIGHT_TOP
			DllStructSetData($tRet, 'rcNormalPosition', @DesktopWidth - $iWidth - $iX, 1)
			DllStructSetData($tRet, 'rcNormalPosition', $iY, 2)
			DllStructSetData($tRet, 'rcNormalPosition', DllStructGetData($tRet, 'rcNormalPosition', 1) + $iWidth, 3)
			DllStructSetData($tRet, 'rcNormalPosition', $iY + $iHeight, 4)
		Case $WIN_LEFT_BOTTOM
			DllStructSetData($tRet, 'rcNormalPosition', $iX, 1)
			DllStructSetData($tRet, 'rcNormalPosition', @DesktopHeight - $iHeight - _GetTaskbarHeight() - $iY, 2)
			DllStructSetData($tRet, 'rcNormalPosition', $iX + $iWidth, 3)
			DllStructSetData($tRet, 'rcNormalPosition', DllStructGetData($tRet, 'rcNormalPosition', 2) + $iHeight, 4)
		Case $WIN_RIGHT_BOTTOM
			DllStructSetData($tRet, 'rcNormalPosition', @DesktopWidth - $iWidth - $iX, 1)
			DllStructSetData($tRet, 'rcNormalPosition', @DesktopHeight - $iHeight - _GetTaskbarHeight() - $iY, 2)
			DllStructSetData($tRet, 'rcNormalPosition', DllStructGetData($tRet, 'rcNormalPosition', 1) + $iWidth, 3)
			DllStructSetData($tRet, 'rcNormalPosition', DllStructGetData($tRet, 'rcNormalPosition', 2) + $iHeight, 4)
		Case Else

	EndSwitch
	_WinAPI_SetWindowPlacement($hWnd, DllStructGetPtr($tRet))
	$tRet = 0

	Return SetError(0, 0, 1)
EndFunc   ;==>_SetWindowPos

Func _WinAPI_GetClassLong($hWnd, $nIndex)

	Local $Ret = DllCall('user32.dll', 'int', 'GetClassLong', 'hwnd', $hWnd, 'int', $nIndex)

	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $Ret[0]
EndFunc   ;==>_WinAPI_GetClassLong

Func _WinAPI_SetClassLong($hWnd, $nIndex, $dwNewLong)

	Local $Ret = DllCall('user32.dll', 'int', 'SetClassLong', 'hwnd', $hWnd, 'int', $nIndex, 'long', $dwNewLong)

	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $Ret[0]
EndFunc   ;==>_WinAPI_SetClassLong

#EndRegion Additional Functions

#Region Windows Message Functions

Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	Switch BitAND($wParam, 0xFFFF)
		Case $Combo
			Switch BitShift($wParam, 16)
				Case $CBN_EDITCHANGE
					_GUICtrlComboBox_AutoComplete($Combo)
					ContinueCase
				Case $CBN_SELCHANGE
					GUICtrlSendToDummy($Dummy)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_DROPFILES($hWnd, $iMsg, $wParam, $lParam)

	Local $Data, $Drag, $Size, $Name, $File
	Local $Amt = DllCall('shell32.dll', 'int', 'DragQueryFile', 'hwnd', $wParam, 'int', -1, 'ptr', 0, 'int', 255)

	If $Amt[0] = 0 Then
		Return 0
	EndIf

	$Drag = DllCall('shell32.dll', 'int', 'DragQueryFile', 'hwnd', $wParam, 'int', 0, 'ptr', 0, 'int', 0)
	$Size = $Drag[0] + 1
	$Name = DllStructCreate('char[' & $Size & ']')
	DllCall('shell32.dll', 'int', 'DragQueryFile', 'hwnd', $wParam, 'int', 0, 'ptr', DllStructGetPtr($Name), 'int', $Size)
	$File = DllStructGetData($Name, 1)
	$Name = 0
	GUISetState(@SW_RESTORE)
	If _MouseIn(56, 86, 366 + (_GetWindowWidth($Form) - $Width), 107) Then
		If StringInStr($File, ' ') Then
			$File = '"' & $File & '"'
		EndIf
		GUICtrlSetState($Input, $GUI_FOCUS)
		GUICtrlSetData($Input, GUICtrlRead($Input) & $File)
		_GUICtrlEdit_SetSel($Input, -1, -1)
	Else
		GUICtrlSetState($Combo, $GUI_FOCUS)
		_GUICtrlComboBox_SetEditText($Combo, $File)
		_GUICtrlComboBox_SetEditSel($Combo, 0, -1)
	EndIf
	Return 0
EndFunc   ;==>WM_DROPFILES

Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)

	Local $tMINMAXINFO = DllStructCreate('int ptReserved[2];int ptMaxSize[2];int ptMaxPosition[2];int ptMinTrackSize[2];int ptMaxTrackSize[2]', $lParam)

	DllStructSetData($tMINMAXINFO, 'ptMinTrackSize', $Width, 1)
	DllStructSetData($tMINMAXINFO, 'ptMinTrackSize', $Height, 2)
	DllStructSetData($tMINMAXINFO, 'ptMaxTrackSize', @DesktopWidth, 1)
	DllStructSetData($tMINMAXINFO, 'ptMaxTrackSize', $Height, 2)

	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

#EndRegion Windows Message Functions
