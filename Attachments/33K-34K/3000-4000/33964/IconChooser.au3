#Region Header

#cs

    Title:          Icon Chooser Dialog UDF Library for AutoIt3
    Filename:       IconChooser.au3
    Description:    Creates a "Change Icon" dialog box to select a custom icon from the specified file
    Author:         Yashied
    Version:        1.1
    Requirements:   AutoIt v3.3.4.x, Developed/Tested on WindowsXP Pro Service Pack 2
    Uses:           Array.au3, Crypt.au3, ButtonConstants.au3, EditConstants.au3, GUIConstantsEx.au3, GUIImageList.au3, GUIListView.au3, GUIMenu.au3, WindowsConstants.au3, WinAPI.au3
    Notes:          The library registers the following window message:

                    WM_COMMAND
                    WM_CONTEXTMENU
                    WM_GETMINMAXINFO
                    WM_NOTIFY
                    WM_SYSCOMMAND

    Available functions:

    _IconChooserDialog

    Example:

    #Include <IconChooser.au3>

    Global $Ico[2] = [@SystemDir & '\shell32.dll', 23]

    $hForm = GUICreate('MyGUI', 160, 160)
    $Button = GUICtrlCreateButton('Change Icon...', 25, 130, 110, 23)
    $Icon = GUICtrlCreateIcon($Ico[0], -(1 + $Ico[1]), 64, 50, 32, 32)
    GUISetState()

    While 1
        Switch GUIGetMsg()
            Case -3
                ExitLoop
            Case $Button
                $Data = _IconChooserDialog($Ico[0], $Ico[1], 32, -1, $hForm)
                If IsArray($Data) Then
                    GUICtrlSetImage($Icon, $Data[0], -(1 + $Data[1]))
                    $Ico = $Data
                EndIf
        EndSwitch
    WEnd

#ce

#Include-once

#Include <Array.au3>
#Include <Crypt.au3>
#Include <ButtonConstants.au3>
#Include <EditConstants.au3>
#Include <GUIConstantsEx.au3>
#Include <GUIImageList.au3>
#Include <GUIListView.au3>
#Include <GUIMenu.au3>
#Include <WindowsConstants.au3>
#Include <WinAPI.au3>

#EndRegion Header

#Region Global Variables and Constants

Global Const $IC_FLAG_BROWSEFIlE = 0x0001
Global Const $IC_FLAG_ICONSIZE = 0x0002
;~Global Const $IC_FLAG_ICONLABEL = 0x0004
Global Const $IC_FLAG_RESIZABLEWINDOW = 0x0008
Global Const $IC_FLAG_USEREGISTRY = 0x0040
Global Const $IC_FLAG_USECACHE = 0x0080
Global Const $IC_FLAG_EXPLORERSTYLE = 0x1000
Global Const $IC_FLAG_DEFAULT = BitOR($IC_FLAG_BROWSEFIlE, $IC_FLAG_ICONSIZE, $IC_FLAG_RESIZABLEWINDOW, $IC_FLAG_EXPLORERSTYLE)

#EndRegion Global Variables and Constants

#Region Local Variables and Constants

Global Const $IC_REG_COMMONDATA = 'HKCU\SOFTWARE\Y''s\Common Data\Icon Chooser\1.0'
Global Const $IC_REG_DEFAULT = _IC_DWordToInt(0x80000000)
Global Const $IC_WINVER = _IC_WinVer()

;~Global Const $tagHEADER = 'dword Sig;ushort Reserved;ushort BitCount;uint64 Time;dword Size;dword Icons;dword X;dword Y'

#cs

"IC-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX.cache"
-------------------------(Header)-------------------------
DWORD   Signature (0xnnnn4349 - "ICxx")
USHORT  Reserved
USHORT  Number of bits-per-pixel
UINT64  Date and time of last modification (FILETIME)
DWORD   Size of data in bytes
DWORD   Number of icons
DWORD   Width (width and height must be equal)
DWORD   Height
--------------------(BITMAPINFOHEADER)--------------------
BITMAPINFOHEADER + RGBQUAD[2] (48 bytes)
--------------------------(Mask)--------------------------
BYTE    Data[n]
--------------------(BITMAPINFOHEADER)--------------------
BITMAPINFOHEADER + RGBQUAD[2] (48 bytes)
-------------------------(Colors)-------------------------
BYTE    Data[n]
...

#ce

Global $icData[28] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, Default, Default, '16,24,32,48,64,96,128,256', 0, 0, 0, 0x01014349, 0, '16,24,32,48,64,96', 250, 0]

#cs

WARNING: DO NOT CHANGE THIS ARRAY, FOR INTERNAL USE ONLY!

$icData[0 ]    - Handle to the dialog box window (must be zero if the window does not exist)
       [1 ]    - ID of the Input control
       [2 ]    - ID of the Dummy control (ListView)
       [3 ]    - ID of the Dummy control (Menu)
       [4 ]    - ID of the "Browse..." button control
       [5 ]    - ID of the "OK" button control
       [6 ]    - ID of the "Cancel" button control
       [7 ]    - ID of the "Size" button control
       [8 ]    - Handle to the ListView control
       [9 ]    - Handle to the "Size" button control
       [10]    - Minimum width of the window
       [11]    - Minimum height of the window
       [12]    - Path to the file that is currently browsing
       [13]    - Index of the currently selected icon
       [14]    - Icon enumerating (updating) control flag
       [15]    - Abort updating control flag
       [16]    - WM disabling control flag
       [17]    - X-offset relative to the parent window (Optional)
       [18]    - Y-offset relative to the parent window (Optional)
       [19]    - List of the icon size (Optional)
       [20-21] - Used in callback function
       [22]    - Error control flag
       [23]    - Signature of "*.cache" files
       [24]    - User's flags
       [25]    - Valid icon sizes to cache (Optional)
       [26]    - Max. size cache, MB (Optional)
       [27]    - Reserved

#ce

#EndRegion Local Variables and Constants

#Region Initialization

; IMPORTANT: If you register the following window messages in your code, you should call handlers from this library until
; you return from your handlers, otherwise, the TreeView Explorer will not work properly! For example:
;
; Func MY_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
;     Local $Result = IC_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
;     If $Result <> $GUI_RUNDEFMSG Then
;         Return $Result
;     EndIf
;     ...
; EndFunc

GUIRegisterMsg(0x0111, 'IC_WM_COMMAND')
GUIRegisterMsg(0x007B, 'IC_WM_CONTEXTMENU')
GUIRegisterMsg(0x0024, 'IC_WM_GETMINMAXINFO')
GUIRegisterMsg(0x004E, 'IC_WM_NOTIFY')
GUIRegisterMsg(0x0112, 'IC_WM_SYSCOMMAND')

#EndRegion Initialization

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _IconChooserDialog
; Description....: Creates a "Change Icon" dialog box that enables the user to select an icon.
; Syntax.........: _IconChooserDialog ( [$sFile [, $iIndex [, $iSize [, $iFlags [, $hParent [, $sTitle]]]]]] )
; Parameters.....: $sFile   - The path of the file that contains the initial icon.
;                  $iIndex  - The zero-based index of the initial icon. If this value is a negative number, will be initialized the
;                             icon whose resource identifier is equal to the absolute value of this value.
;                  $iSize   - The size of the initial displaying icons. This parameter can be in the range from 8 to 256.
;                  $iFlags  - The flags that defines a style of the dialog box. This parameter can be zero, (-1),
;                             or combination of the following values.
;
;                             $IC_FLAG_BROWSEFIlE
;                             $IC_FLAG_ICONSIZE
;                             $IC_FLAG_ICONLABEL (Not currently used)
;                             $IC_FLAG_RESIZABLEWINDOW
;                             $IC_FLAG_USEREGISTRY
;                             $IC_FLAG_USECACHE
;                             $IC_FLAG_EXPLORERSTYLE
;                             $IC_FLAG_DEFAULT
;
;                  $hParent - Handle to the window that owns the dialog box.
;                  $sTitle  - Title of the dialog box.
; Return values..: Success  - The array containing the following parameters:
;
;                             [0] - The path of the file that contains the selected icon.
;                             [1] - The index of the selected icon.
;
;                  Failure  - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: If $IC_FLAG_USEREGISTRY flag is set, the dialog's settings (window size and position, file path, etc.) will be
;                  taken from the registry and saved in the registry after closing the window to the following hive:
;
;                  HKEY_CURRENT_USER\Software\Y's\Common Data\Icon Chooser\1.x
;
;                  If $IC_FLAG_USECACHE flag is set, the icons will be cached to improve display performance at the following
;                  shows. All cached icons are located in a temporary directory in the following format:
;
;                  %TEMP%\IC-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX.cache
;
;                  The maximum cache size is 250 MB.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _IconChooserDialog($sFile = '', $iIndex = 0, $iSize = -1, $iFlags = -1, $hParent = 0, $sTitle = 'Change Icon')

	Local $Size = StringSplit(StringStripWS($icData[19], 8), ',')
	Local $W, $H, $DH = 35, $hIL, $Data, $Item, $Menu = 0, $Msg, $Pos, $Style = 0, $Index = -1
	Local $Dlg[5] = ['Browser', 'X', 'Y', 'Width', 'Height']
	Local $Opt1 = Opt('GUIOnEventMode', 0)
	Local $Opt2 = Opt('GUICloseOnESC', 1)
	Local $Param[2] = [0, 0]

	If $iFlags = -1 Then
		$iFlags = $IC_FLAG_DEFAULT
	EndIf
	If BitAND($iFlags, $IC_FLAG_RESIZABLEWINDOW) Then
		$Style = $WS_SIZEBOX
	EndIf
	If BitAND($iFlags, $IC_FLAG_BROWSEFIlE) Then
		$DH = 0
	EndIf
	$sFile = _IC_SearchPath($sFile)
	If Not $sFile Then
		$Param[0] = 1
		If BitAND($iFlags, $IC_FLAG_USEREGISTRY) Then
			$sFile = _IC_SearchPath(_IC_RegRead('IconPath'), 1)
		EndIf
		If Not $sFile Then
			$sFile = _IC_SearchPath('shell32.dll', 1)
		EndIf
		$iIndex = 0
	EndIf
	$iIndex = Number($iIndex)
	If $iIndex < 0 Then
		$iIndex = _IC_GetIconIndex($sFile, Abs($iIndex))
	EndIf
	If $iSize = -1 Then
		$Param[1] = 1
		If BitAND($iFlags, $IC_FLAG_USEREGISTRY) Then
			$iSize = _IC_RegRead('IconSize', 32)
		Else
			$iSize = 32
		EndIf
	EndIf
	$iSize = Number($iSize)
	If ($iSize < 8) Or ($iSize > 256) Then
		$iSize = 32
	EndIf
	Switch $iSize
		Case 16
			$W = 373
			$H = 426 - $DH
		Case 24
			$W = 401
			$H = 454 - $DH
		Case 32
			$W = 361
			$H = 414 - $DH
		Case 48
			$W = 389
			$H = 442 - $DH
		Case 64
			$W = 385
			$H = 438 - $DH
		Case 72
			$W = 417
			$H = 470 - $DH
		Case 80
			$W = 449
			$H = 502 - $DH
		Case 96
			$W = 397
			$H = 450 - $DH
		Case 128
			$W = 493
			$H = 546 - $DH
		Case 256
			$W = 601
			$H = 654 - $DH
		Case Else
			$W = 361
			$H = 414 - $DH
	EndSwitch
	For $i = 1 To $Size[0]
		$Size[$i] = Number($Size[$i])
	Next
	For $i = 1 To $Size[0]
		If $Size[$i] = $iSize Then
			$Item = $i
			ExitLoop
		EndIf
		If $Size[$i] > $iSize Then
			$Size[0] += 1
			ReDim $Size[$Size[0] + 1]
			For $j = $Size[0] - 1 To $i Step -1
				$Size[$j + 1] = $Size[$j]
			Next
			$Size[$i] = $iSize
			$Item = $i
			ExitLoop
		EndIf
	Next

	$icData[1 ] = 0
	$icData[3 ] = 0
	$icData[4 ] = 0
	$icData[7 ] = 0
	$icData[9 ] = 0
	$icData[10] = 377
	$icData[11] = 450 - $DH
	$icData[12] = $sFile
	$icData[13] = $iIndex
	$icData[14] = 1
	$icData[15] = 0
	$icData[16] = 0
	$icData[22] = 0
	$icData[24] = $iFlags
;~	$icData[25] = 0

	GUISetState(@SW_DISABLE, $hParent)

	$icData[0] = GUICreate($sTitle, $W, $H, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $Style), $WS_EX_DLGMODALFRAME, $hParent)
	If Not _IC_MoveWindow($icData[0], $hParent, $icData[17], $icData[18]) Then

	EndIf
	If BitAND($iFlags, $IC_FLAG_BROWSEFIlE) Then
		$icData[1] = GUICtrlCreateInput($sFile, 14, 14, $W - 105, 21, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
		GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKRIGHT, $GUI_DOCKHEIGHT))
		$icData[4] = GUICtrlCreateButton('Browse...', $W - 85, 13, 72, 23)
		GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKSIZE))
	EndIf
	$icData[8] = GUICtrlCreateListView('', 14, 49 - $DH, $W - 28, $H + $DH - 98, -1, $WS_EX_CLIENTEDGE)
	$icData[8] = GUICtrlGetHandle(-1)
	GUICtrlSetStyle(-1, BitOR($LVS_AUTOARRANGE, $LVS_ICON, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL))
	GUICtrlSetFont(-1, 8.5, 400, 0, 'Tahoma')
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	GUICtrlSetState(-1, $GUI_FOCUS)
	_GUICtrlListView_SetExtendedListViewStyle($icData[8], $LVS_EX_DOUBLEBUFFER)
	$hIL = _GUIImageList_Create($iSize, $iSize, 5, 1)
	_GUICtrlListView_SetImageList($icData[8], $hIL)
	$icData[2] = GUICtrlCreateDummy()
	If BitAND($iFlags, $IC_FLAG_EXPLORERSTYLE) Then
		_IC_SetExplorerStyle($icData[8])
	EndIf
	If BitAND($iFlags, $IC_FLAG_ICONSIZE) Then
		If $IC_WINVER >= 0x0600 Then
			$icData[7] = GUICtrlCreateButton($Size[$Item] & 'x' & $Size[$Item], 13, $H - 36, 72, 23, $BS_SPLITBUTTON)
		Else
			$icData[7] = GUICtrlCreateButton($Size[$Item] & 'x' & $Size[$Item], 13, $H - 36, 72, 23)
		EndIf
		$icData[9] = GUICtrlGetHandle(-1)
		GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKSIZE))
		If $IC_WINVER >= 0x0600 Then
			GUICtrlSetFont(-1, 9.1, 400, 0, 'Segoe UI')
		EndIf
		$icData[3] = GUICtrlCreateDummy()
		Dim $Menu[UBound($Size)]
		If $IC_WINVER >= 0x0600 Then
			$Menu[0] = GUICtrlCreateContextMenu($icData[3])
		Else
			$Menu[0] = GUICtrlCreateContextMenu($icData[7])
		EndIf
		For $i = 1 To $Size[0]
			$Menu[$i] = GUICtrlCreateMenuItem($Size[$i] & 'x' & $Size[$i], $Menu[0], Default, 1)
		Next
		GUICtrlSetState($Menu[$Item], $GUI_CHECKED)
		$Menu[0] = GUICtrlGetHandle($Menu[0])
	EndIf
	$icData[5] = GUICtrlCreateButton('OK', $W - 162, $H - 36, 72, 23)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	$icData[6] = GUICtrlCreateButton('Cancel', $W - 85, $H - 36, 72, 23)
	For $i = 5 To 6
		GUICtrlSetResizing($icData[$i], BitOR($GUI_DOCKRIGHT, $GUI_DOCKBOTTOM, $GUI_DOCKSIZE))
	Next
	$Pos = WinGetPos($icData[0])
	If IsArray($Pos) Then
		$icData[10] = $Pos[2] - $W + 361
		$icData[11] = $Pos[3] - $H + 414 - $DH
	EndIf
	If BitAND($iFlags, $IC_FLAG_USEREGISTRY) Then
		Do
			For $i = 0 To 4
				$Dlg[$i] = _IC_DWordToInt(_IC_RegRead($Dlg[$i], $IC_REG_DEFAULT))
				If $Dlg[$i] = $IC_REG_DEFAULT Then
					ExitLoop 2
				EndIf
			Next
			If Not $DH Then
				If Not $Dlg[0] Then
					$Dlg[4] += 35
				EndIf
			Else
				If $Dlg[0] Then
					$Dlg[4] -= 35
				EndIf
			EndIf
			If ($Dlg[3] >= $icData[10]) And ($Dlg[4] >= $icData[11]) And (BitAND($iFlags, $IC_FLAG_RESIZABLEWINDOW)) Then
				_IC_MoveWindow($icData[0], 0, $Dlg[1], $Dlg[2], $Dlg[3], $Dlg[4], 1, 1)
			Else
				_IC_MoveWindow($icData[0], 0, $Dlg[1], $Dlg[2])
			EndIf
		Until 1
	EndIf

	GUISetState(@SW_SHOW, $icData[0])

	While 1
		If $icData[14] Then
			If Not _IC_Update($icData[12], $Size[$Item], $icData[13]) Then
				Switch @error
					Case 1
						ExitLoop
					Case 2
						MsgBox(48, $sTitle, '"' & StringRegExpReplace($icData[12], '^.*\\', '') & '" contains no icons.', 0, $icData[0])
					Case 3
						MsgBox(48, $sTitle, '"' & StringRegExpReplace($icData[12], '^.*\\', '') & '" not found.', 0, $icData[0])
				EndSwitch
				GUICtrlSetState($icData[1], $GUI_FOCUS)
				$icData[22] = 1
			EndIf
			$icData[14] = 0
;~			If True Then
				_IC_Wait()
;~			EndIf
		EndIf
		$Msg = GUIGetMsg()
		Switch $Msg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $icData[2]
				$Index = GUICtrlRead($icData[2])
				ExitLoop
			Case $icData[3]
				_GUICtrlMenu_TrackPopupMenu($Menu[0], $icData[0])
			Case $icData[4]
				If _IC_SearchPath($icData[12], 1) Then
					$Data = $icData[12]
				Else
					$Data = ''
				EndIf
				$Data = FileOpenDialog('Browse Icon File', StringRegExpReplace($Data, '\\[^\\]*\Z', ''), 'Icon Files (*.ico;*.icl;*.exe;*.dll)|Programs (*.exe)|Libraries (*.dll)|Icons (*.ico)|All Files (*.*)', 1 + 2, '', $icData[0])
				If $Data Then
					GUICtrlSetData($icData[1], $Data)
					$icData[12] = $Data
					$icData[13] = 0
					$icData[14] = 1
					$icData[22] = 0
				EndIf
			Case $icData[5]
				If _GUICtrlListView_GetItemCount($icData[8]) Then
					$Index = $icData[13]
				Else
					$Index = -1
				EndIf
				ExitLoop
			Case $icData[6]
				ExitLoop
			Case $icData[7]
				GUICtrlSetState($Menu[$Item], $GUI_UNCHECKED)
				$Item += 1
				If $Item > $Size[0] Then
					$Item = 1
				EndIf
				GUICtrlSetData($icData[7], $Size[$Item] & 'x' & $Size[$Item])
				GUICtrlSetState($Menu[$Item], $GUI_CHECKED)
				If Not $icData[22] Then
;~					$icData[13] =-1
					$icData[14] = 1
				EndIf
			Case Else
				For $i = 1 To UBound($Menu) - 1
					If $Msg = $Menu[$i] Then
						If $i <> $Item Then
							GUICtrlSetData($icData[7], $Size[$i] & 'x' & $Size[$i])
							GUICtrlSetState($Menu[$Item], $GUI_UNCHECKED)
							GUICtrlSetState($Menu[$i], $GUI_CHECKED)
							If Not $icData[22] Then
;~								$icData[13] =-1
								$icData[14] = 1
							EndIf
							$Item = $i
						EndIf
						ExitLoop
					EndIf
				Next
		EndSwitch
	WEnd

	$Pos = WinGetPos($icData[0])

	GUISetState(@SW_ENABLE, $hParent)
	GUIDelete($icData[0])

	$icData[0] = 0

	Opt('GUIOnEventMode', $Opt1)
	Opt('GUICloseOnESC', $Opt2)

	If BitAND($iFlags, $IC_FLAG_USEREGISTRY) Then
		If IsArray($Pos) Then
			RegWrite($IC_REG_COMMONDATA, 'Browser', 'REG_DWORD', BitAND($iFlags, $IC_FLAG_BROWSEFIlE) = $IC_FLAG_BROWSEFIlE)
			RegWrite($IC_REG_COMMONDATA, 'X', 'REG_DWORD', $Pos[0])
			RegWrite($IC_REG_COMMONDATA, 'Y', 'REG_DWORD', $Pos[1])
			If BitAND($iFlags, $IC_FLAG_RESIZABLEWINDOW) Then
				RegWrite($IC_REG_COMMONDATA, 'Width' , 'REG_DWORD', $Pos[2])
				RegWrite($IC_REG_COMMONDATA, 'Height', 'REG_DWORD', $Pos[3])
			EndIf
		EndIf
		If $Param[1] Then
			RegWrite($IC_REG_COMMONDATA, 'IconSize', 'REG_DWORD', $Size[$Item])
		EndIf
		If ($Param[0]) And (_IC_SearchPath($icData[12], 1)) Then
			RegWrite($IC_REG_COMMONDATA, 'IconPath', 'REG_SZ', $icData[12])
		EndIf
	EndIf
	If $Index = -1 Then
		Return 0
	EndIf
	Dim $Data[2]
	$Data[0] = $icData[12]
	$Data[1] = $Index
	Return $Data
EndFunc   ;==>_IconChooserDialog

#EndRegion Public Functions

#Region Internal Functions

#cs

_IC_DWordToInt
_IC_ExtractIcon
_IC_GetCachePath
_IC_GetIconIndex
_IC_HWnd
_IC_MoveWindow
_IC_PurgeCache
_IC_RegRead
_IC_SCAW
_IC_SearchPath
_IC_SetExplorerStyle
_IC_Update
_IC_Wait
_IC_WinVer

#ce

Func _IC_DWordToInt($iValue)

	Local $tDWord = DllStructCreate('dword')
	Local $tInt = DllStructCreate('int', DllStructGetPtr($tDWord))

	DllStructSetData($tDWord, 1, $iValue)
	If Not @error Then
		Return DllStructGetData($tInt, 1)
	Else
		Return 0
	EndIf
EndFunc   ;==>_IC_DWordToInt

Func _IC_ExtractIcon($sFile, $iIndex, $iSize)

	Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $sFile, 'int', $iIndex, 'int', $iSize, 'int', $iSize, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)

	If (Not @error) And ($Ret[0]) And ($Ret[5]) Then
		Return $Ret[5]
	Else
		Return 0
	EndIf
EndFunc   ;==>_IC_ExtractIcon

Func _IC_GetCachePath($sFile, $iParam1 = '', $iParam2 = '')

	Local $ID

	$sFile = StringUpper(FileGetLongName($sFile))
	If $iParam1 Then
		$sFile &= '@' & $iParam1
	EndIf
	If $iParam2 Then
		$sFile &= '@' & $iParam2
	EndIf
	$ID = _Crypt_HashData($sFile, $CALG_MD5)
	If Not @error Then
		Return @TempDir & '\IC-' & StringMid($ID, 3, 8) & '-' & StringMid($ID, 11, 4) & '-' & StringMid($ID, 15, 4) & '-' & StringMid($ID, 19, 4) & '-' & StringMid($ID, 23, 12) & '.cache'
	Else
		Return ''
	EndIf
EndFunc   ;==>_IC_GetCachePath

Func _IC_GetIconIndex($sFile, $sName)

	Local $hModule, $hProc

	$hModule = _WinAPI_LoadLibrary($sFile)
	If Not $hModule Then
		Return 0
	EndIf
	$icData[20] =-1
	$icData[21] = 0
	$hProc = DllCallbackRegister('_IC_EnumProc','int','ptr;ptr;ptr;long_ptr')
	DllCall('kernel32.dll', 'int', 'EnumResourceNamesW', 'ptr', $hModule, 'int', 14, 'ptr', DllCallbackGetPtr($hProc), 'long_ptr', $sName)
	DllCallbackFree($hProc)
	_WinAPI_FreeLibrary($hModule)
	If $icData[20] <> -1 Then
		Return $icData[20]
	Else
		Return 0
	EndIf
EndFunc   ;==>_IC_GetIconIndex

Func _IC_HWnd($hWnd)
	If Not IsHWnd($hWnd) Then
		Return GUICtrlGetHandle($hWnd)
	Else
		Return $hWnd
	EndIf
EndFunc   ;==>_IC_HWnd

Func _IC_MoveWindow($hWnd, $hParent = 0, $iX = Default, $iY = Default, $iW = -1, $iH = -1, $fClient = 1, $fResize = 0)

	Local $Area[4], $Wx[2], $Cx[2], $tRect, $pRect, $Pos, $Ret

	$Ret = DllCall('user32.dll', 'long', 'GetWindowLongW', 'hwnd', $hWnd, 'int', -16)
	If (@error) Or (BitAND($Ret[0], 0x21000000)) Then
		Return 0
	EndIf
	$Pos = WinGetPos($hWnd)
	If @error Then
		Return 0
	EndIf
	If $iW = -1 Then
		$iW = $Pos[2]
	EndIf
	If $iH = -1 Then
		$iH = $Pos[3]
	EndIf
	$tRect = DllStructCreate('int;int;int;int')
	$pRect = DllStructGetPtr($tRect)
	$Ret = DllCall('dwmapi.dll', 'uint', 'DwmGetWindowAttribute', 'hwnd', $hWnd, 'dword', 9, 'ptr', $pRect, 'dword', 16)
	If (Not @error) And (Not $Ret[0]) Then
		For $i = 0 To 1
			$Wx[$i] = DllStructGetData($tRect, $i + 3) - DllStructGetData($tRect, $i + 1) - $Pos[$i + 2]
		Next
	Else
		For $i = 0 To 1
			$Wx[$i] = 0
		Next
	EndIf
	$iW += $Wx[0]
	$iH += $Wx[1]
	$Ret = DllCall('user32.dll', 'int', 'SystemParametersInfoW', 'uint', 0x0030, 'uint', 0, 'ptr', $pRect, 'uint', 0)
	If (@error) Or (Not $Ret[0]) Then
		$Area[0] = 0
		$Area[1] = 0
		$Area[2] = @DesktopWidth
		$Area[3] = @DesktopHeight
	Else
		For $i = 0 To 3
			$Area[$i] = DllStructGetData($tRect, $i + 1)
		Next
	EndIf
	Do
		If $hParent Then
			$Ret = DllCall('user32.dll', 'long', 'GetWindowLongW', 'hwnd', $hParent, 'int', -16)
			If @error Then
				Return 0
			EndIf
			If Not BitAND($Ret[0], 0x20000000) Then
				If $fClient Then
					$Ret = DllCall('user32.dll', 'int', 'GetClientRect', 'hwnd', $hParent, 'ptr', $pRect)
					If (@error) Or (Not $Ret[0]) Then
						Return 0
					EndIf
					$Ret = DllCall('user32.dll', 'int', 'ClientToScreen', 'hwnd', $hParent, 'ptr', $pRect)
					If (@error) Or (Not $Ret[0]) Then
						Return 0
					EndIf
					If $iX = Default Then
						$iX = Int((DllStructGetData($tRect, 3) - $iW) / 2)
					EndIf
					If $iY = Default Then
						$iY = Int((DllStructGetData($tRect, 4) - $iH) / 2)
					EndIf
					$iX += DllStructGetData($tRect, 1)
					$iY += DllStructGetData($tRect, 2)
				Else
					$Pos = WinGetPos($hParent)
					If @error Then
						Return 0
					EndIf
					$Ret = DllCall('dwmapi.dll', 'uint', 'DwmGetWindowAttribute', 'hwnd', $hParent, 'dword', 9, 'ptr', $pRect, 'dword', 16)
					If (Not @error) And (Not $Ret[0]) Then
						For $i = 0 To 1
							$Cx[$i] = DllStructGetData($tRect, $i + 3) - DllStructGetData($tRect, $i + 1) - $Pos[$i + 2]
						Next
					Else
						For $i = 0 To 1
							$Cx[$i] = 0
						Next
					EndIf
					If $iX = Default Then
						$iX = Int(($Pos[2] + $Cx[0] - $iW) / 2)
					EndIf
					If $iY = Default Then
						$iY = Int(($Pos[3] + $Cx[1] - $iH) / 2)
					EndIf
					$iX += $Pos[0] - $Cx[0] / 2
					$iY += $Pos[1] - $Cx[1] / 2
				EndIf
				ExitLoop
			EndIf
		EndIf
		If $iX = Default Then
			$iX = Int(($Area[2] - $iW) / 2)
		EndIf
		If $iY = Default Then
			$iY = Int(($Area[3] - $iH) / 2)
		EndIf
		$iX += $Area[0]
		$iY += $Area[1]
	Until 1
	$iX += $Wx[0] / 2
	$iY += $Wx[1] / 2
	If ($fResize) And ($iW > $Area[2] - $Area[0]) Then
		$iW = $Area[2] - $Area[0] - $Wx[0]
	EndIf
	If ($fResize) And ($iH > $Area[3] - $Area[1]) Then
		$iH = $Area[3] - $Area[1] - $Wx[1]
	EndIf
	If $iX > $Area[2] - $iW Then
		$iX = $Area[2] - $iW + $Wx[0] / 2
	EndIf
	If $iX < $Area[0] Then
		$iX = $Area[0] + $Wx[0] / 2
	EndIf
	If $iY > $Area[3] - $iH Then
		$iY = $Area[3] - $iH + $Wx[1] / 2
	EndIf
	If $iY < $Area[1] Then
		$iY = $Area[1] + $Wx[1] / 2
	EndIf
	If WinMove($hWnd, '', $iX, $iY, $iW - $Wx[0], $iH - $Wx[1]) Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_IC_MoveWindow

Func _IC_PurgeCache($iMax = 0)

	Local $hSearch, $File
	Local $List[101][3] = [[0, 0]]

	If Not $iMax Then
		Return FileDelete(@TempDir & '\IC-????????-????-????-????-????????????.cache')
	EndIf
	$hSearch = FileFindFirstFile(@TempDir & '\IC-????????-????-????-????-????????????.cache')
	Switch @error
		Case 0

		Case 1
			Return 1
		Case Else
			Return 0
	EndSwitch
	While 1
		$File = FileFindNextFile($hSearch)
		If @error Then
			ExitLoop
		EndIf
		If Not @extended Then
			$List[0][0] += 1
			If $List[0][0] > UBound($List) - 1 Then
				ReDim $List[$List[0][0] + 100][3]
			EndIf
			$List[$List[0][0]][0] = $File
			$List[$List[0][0]][1] = FileGetSize(@TempDir & '\' & $File)
			$List[$List[0][0]][2] = FileGetTime(@TempDir & '\' & $File, 0, 1)
			$List[$List[0][0]][2] = Number($List[$List[0][0]][2])
			$List[0][1] += $List[$List[0][0]][1]
		EndIf
	WEnd
	FileClose($hSearch)
	If ($List[0][0] > 1) And ($List[0][1] > $iMax) Then
		_ArraySort($List, 0, 1, $List[0][0], 2)
		$iMax = Int($iMax / 2)
		For $i = 1 To $List[0][0] - 1
			If Not FileDelete(@TempDir & '\' & $List[$i][0]) Then
				Return 0
			EndIf
			$List[0][1] -= $List[$i][1]
			If $List[0][1] <= $iMax Then
				ExitLoop
			EndIf
		Next
	EndIf
	Return 1
EndFunc   ;==>_IC_PurgeCache

Func _IC_RegRead($sValue, $sDefault = '')

	Local $Val = RegRead($IC_REG_COMMONDATA, $sValue)

	If @error Then
		Return $sDefault
	Else
		Return $Val
	EndIf
EndFunc   ;==>_IC_RegRead

Func _IC_SCAW()

	Local $tKey, $Ret

	$tKey = DllStructCreate('byte[256]')
	$Ret = DllCall('user32.dll', 'int', 'GetKeyboardState', 'ptr', DllStructGetPtr($tKey))
	If (@error) Or (Not $Ret[0]) Then
		Return 0
	EndIf
	For $i = 0x5B To 0x5C
		If BitAND(DllStructGetData($tKey, 1, $i + 1), 0xF0) Then
			Return 1
		EndIf
	Next
	For $i = 0xA0 To 0xA5
		If BitAND(DllStructGetData($tKey, 1, $i + 1), 0xF0) Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_IC_SCAW

Func _IC_SearchPath($sPath, $fExists = 0)

	Local $tPath, $Path, $Ret

	$sPath = StringStripWS($sPath, 3)
	$tPath = DllStructCreate('wchar[1024]')
	$Ret = DllCall('shlwapi.dll', 'int', 'PathSearchAndQualifyW', 'wstr', $sPath, 'ptr', DllStructGetPtr($tPath), 'int', 1024)
	If (Not @error) And ($Ret[0]) Then
		$Path = DllStructGetData($tPath, 1)
		If (FileExists($Path)) And (Not StringInStr(FileGetAttrib($Path), 'D')) Then
			Return FileGetLongName($Path)
		Else
			If Not $fExists Then
				Return $sPath
			Else
				Return ''
			EndIf
		EndIf
	Else
		Return ''
	EndIf
EndFunc   ;==>_IC_SearchPath

Func _IC_SetExplorerStyle($hWnd)

	Local $Ret

	$hWnd = _IC_HWnd($hWnd)
	If ($hWnd) And ($IC_WINVER >= 0x0600) Then
		$Ret = DllCall('uxtheme.dll', 'uint', 'SetWindowTheme', 'hwnd', $hWnd, 'wstr', 'Explorer', 'ptr', 0)
		If (Not @error) And (Not $Ret[0]) Then
			Return 1
		EndIf
	EndIf
	Return 0
EndFunc   ;==>_IC_SetExplorerStyle

Func _IC_Update($sFile, $iSize, $iItem = -1)

	Local $hDC, $hIL, $hFile, $hBitmap, $hIcon, $tInfo, $pInfo, $tDM, $tBI, $pBI, $tHdr, $tData, $pData, $iBits, $iByte, $iIcon, $nSize, $iTime, $sPath = ''
	Local $Ret, $Error, $Icons, $Text, $Cache = 1, $Count = 0
	Local $aInfo[2] = [0, 0]

	If $iItem = -1 Then
		$iItem = Number(_GUICtrlListView_GetSelectedIndices($icData[8]))
	EndIf
	$hIL = _GUICtrlListView_GetImageList($icData[8], 0)
	_GUICtrlListView_DeleteAllItems($icData[8])
	_GUICtrlListView_SetIconSpacing($icData[8], $iSize + 20, $iSize + 20)
	_GUIImageList_Remove($hIL)
	_GUIImageList_SetIconSize($hIL, $iSize, $iSize)
	_GUICtrlListView_SetImageList($icData[8], $hIL)
	$Icons = _WinAPI_ExtractIconEx($sFile, -1, 0, 0, 0)
	$hFile = _WinAPI_CreateFile($sFile, 2, 2)
	If Not $hFile Then
		If $sFile Then
			Return SetError(3, 0, 0)
		Else
			Return 1
		EndIf
	EndIf
	If (BitAND($icData[24], $IC_FLAG_USECACHE)) And (StringInStr($icData[25], $iSize)) And ($Icons > 16) Then
		$tDM = DllStructCreate('wchar[32];ushort;ushort;ushort;ushort;dword;dword[2];dword;dword;short;short;short;short;short;wchar[32];ushort;dword;dword;dword;dword;dword')
		DllStructSetData($tDM, 4, DllStructGetSize($tDM))
		DllStructSetData($tDM, 5, 0)
		$Ret = DllCall('user32.dll', 'int', 'EnumDisplaySettingsW', 'ptr', 0, 'dword', -1, 'ptr', DllStructGetPtr($tDM))
		If (Not @error) And ($Ret[0]) Then
			$iBits = DllStructGetData($tDM, 17)
		EndIf
		$Ret = DllCall('kernel32.dll', 'int', 'GetFileTime', 'ptr', $hFile, 'ptr', 0, 'ptr', 0, 'uint64*', 0)
		If (Not @error) And ($Ret[0]) Then
			$iTime = $Ret[4]
		EndIf
		If ($iBits) And ($iTime) Then
			$sPath = _IC_GetCachePath($sFile, $iSize)
		EndIf
	EndIf
	$icData[13] = 0
	$icData[15] = 0
	$icData[16] = 1
	If $icData[1] Then
		$Text = GUICtrlRead($icData[1])
	EndIf
	GUISetCursor(15, 1, $icData[0])
	Opt('GUIOnEventMode', 1)
	_GUICtrlListView_BeginUpdate($icData[8])
	If $hFile Then
		_WinAPI_CloseHandle($hFile)
	EndIf
	If $sPath Then
		$hFile = _WinAPI_CreateFile($sPath, 2, 2)
		$tHdr = DllStructCreate('dword Sig;ushort Reserved;ushort BitCount;uint64 Time;dword Size;dword Icons;dword X;dword Y')
		If (_WinAPI_ReadFile($hFile, DllStructGetPtr($tHdr), 32, $iByte)) And (DllStructGetData($tHdr, 'Sig') = $icData[23]) And (DllStructGetData($tHdr, 'BitCount') = $iBits) And (DllStructGetData($tHdr, 'Time') = $iTime) And (DllStructGetData($tHdr, 'X') = $iSize) And (DllStructGetData($tHdr, 'Y') = $iSize) Then
			$nSize = DllStructGetData($tHdr, 'Size')
			$tData = DllStructCreate('byte[' & $nSize & ']')
			$pData = DllStructGetPtr($tData)
			If _WinAPI_ReadFile($hFile, $pData, $nSize, $iByte) Then
				$iIcon = DllStructGetData($tHdr, 'Icons')
				$nSize = 0
				For $i = 0 To $iIcon - 1
					For $j = 0 To 1
						$Error = 1
						$tBI = DllStructCreate('dword Size;byte[12];dword Compression;dword SizeImage;byte[24]', $pData + $nSize)
						$pBI = DllStructGetPtr($tBI)
						$Ret = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', $pBI, 'uint', 0, 'ptr*', 0, 'ptr', 0, 'dword', 0)
						If (Not @error) And ($Ret[0]) Then
							$aInfo[$j] = $Ret[0]
						Else
							$aInfo[$j] = 0
							ExitLoop
						EndIf
						$iByte = DllStructGetData($tBI, 'SizeImage')
						DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'ptr', $Ret[4], 'ptr', $pBI + 48, 'ulong_ptr', $iByte)
						If @error Then
							ExitLoop
						EndIf
						$nSize += 48 + $iByte
						$Error = 0
					Next
					If $Error Then

					Else
						_GUICtrlListView_AddItem($icData[8], $i, _GUIImageList_Add($hIL, $aInfo[1], $aInfo[0]))
					EndIf
					For $j = 0 To 1
						If $aInfo[$j] Then
							_WinAPI_DeleteObject($aInfo[$j])
						EndIf
					Next
					If ($Error) Or ($icData[15]) Then
						_GUICtrlListView_DeleteAllItems($icData[8])
						_GUIImageList_Remove($hIL)
						ExitLoop
					EndIf
				Next
				If $Error Then

				Else
					$Count = $iIcon
					$Cache = 0
				EndIf
			EndIf
		EndIf
		If $hFile Then
			_WinAPI_CloseHandle($hFile)
		EndIf
		If $Cache Then
			FileDelete($sPath)
		EndIf
	EndIf
	If ($Cache) And ($Icons) Then
		If $sPath Then
			FileDelete($sPath)
			$hDC = _WinAPI_CreateCompatibleDC(0)
			$tData = DllStructCreate('byte[' & (32 + (48 + 5 * ($iSize ^ 2)) * $Icons) & ']')
			$pData = DllStructGetPtr($tData)
			$tInfo = DllStructCreate('int Icon;dword X;dword Y;ptr hMask;ptr hColor')
			$pInfo = DllStructGetPtr($tInfo)
			$nSize = 32
		EndIf
		$Error = 0
		For $i = 0 To $Icons - 1
			$hIcon = _IC_ExtractIcon($sFile, $i, $iSize)
			If $hIcon Then
				_GUICtrlListView_AddItem($icData[8], $i, _GUIImageList_ReplaceIcon($hIL, -1, $hIcon))
				If ($sPath) And (Not $Error) Then
					$Ret = DllCall('user32.dll', 'int', 'GetIconInfo', 'ptr', $hIcon, 'ptr', $pInfo)
					If @error Then
						$Error = 1
					Else
						For $j = 4 To 5
							If $Error Then

							Else
								$hBitmap = DllStructGetData($tInfo, $j)
								$tBI = DllStructCreate('dword Size;byte[12];dword Compression;dword SizeImage;byte[24]', $pData + $nSize)
								$pBI = DllStructGetPtr($tBI)
								DllStructSetData($tBI, 'Size', 48)
								_WinAPI_SelectObject($hDC, $hBitmap)
								If _WinAPI_GetDIBits($hDC, $hBitmap, 0, 0, 0, $pBI, 0) Then
									DllStructSetData($tBI, 'Compression', 0)
									If _WinAPI_GetDIBits($hDC, $hBitmap, 0, $iSize, $pData + $nSize + 48, $pBI, 0) Then
										$nSize += 48 + DllStructGetData($tBI, 'SizeImage')
									Else
										$Error = 1
									EndIf
								Else
									$Error = 1
								EndIf
							EndIf
							_WinAPI_DeleteObject($hBitmap)
						Next
					EndIf
				EndIf
				_WinAPI_DestroyIcon($hIcon)
				$Count += 1
			EndIf
			If $icData[15] Then
				_GUICtrlListView_DeleteAllItems($icData[8])
				_GUIImageList_Remove($hIL)
				ExitLoop
			EndIf
		Next
		If $hDC Then
			_WinAPI_DeleteDC($hDC)
		EndIf
		If ($sPath) And ($Count) And (Not $Error) And (Not $icData[15]) Then
			$hFile = _WinAPI_CreateFile($sPath, 1, 4)
			$tHdr = DllStructCreate('dword Sig;ushort Reserved;ushort BitCount;uint64 Time;dword Size;dword Icons;dword X;dword Y', $pData)
			DllStructSetData($tHdr, 'Sig', $icData[23])
			DllStructSetData($tHdr, 'Reserved', 0)
			DllStructSetData($tHdr, 'BitCount', $iBits)
			DllStructSetData($tHdr, 'Time', $iTime)
			DllStructSetData($tHdr, 'Size', $nSize - 32)
			DllStructSetData($tHdr, 'Icons', $Count)
			DllStructSetData($tHdr, 'X', $iSize)
			DllStructSetData($tHdr, 'Y', $iSize)
			If Not _WinAPI_WriteFile($hFile, $pData, $nSize, $iByte) Then
				$Error = 1
			EndIf
			If $hFile Then
				_WinAPI_CloseHandle($hFile)
			EndIf
			If $Error Then
				FileDelete($sPath)
			EndIf
		EndIf
	EndIf
	_GUICtrlListView_EndUpdate($icData[8])
	GUISetCursor(2, 0, $icData[0])
	If $icData[1] Then
		GUICtrlSetData($icData[1], $Text)
	EndIf
	Opt('GUIOnEventMode', 0)
	$icData[16] = 0
	If Not $icData[15] Then
		If $Count Then
			If ($iItem < 0) Or ($iItem > $Count - 1) Then
				$iItem = 0
			EndIf
			_GUICtrlListView_SetItemSelected($icData[8], $iItem, 1, 1)
			_GUICtrlListView_EnsureVisible($icData[8], $iItem)
			$icData[13] = $iItem
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf
	_WinAPI_SetFocus($icData[8])
;~	_IC_Wait()
	If Not $Count Then
		Return SetError(2, 0, 0)
	Else
		If $sPath Then
			_IC_PurgeCache($icData[26] * 1024 * 1024)
		EndIf
		Return 1
	EndIf
EndFunc   ;==>_IC_Update

Func _IC_Wait($ID = 0)
	Do
	Until GUIGetMsg() = $ID
EndFunc   ;==>_IC_Wait

Func _IC_WinVer()

	Local $tOS, $Ret

	$tOS = DllStructCreate('dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128]')
	DllStructSetData($tOS, 'OSVersionInfoSize', DllStructGetSize($tOS))
	$Ret = DllCall('kernel32.dll', 'int', 'GetVersionExW', 'ptr', DllStructGetPtr($tOS))
	If (Not @error) And ($Ret[0]) Then
		Return BitOR(BitShift(DllStructGetData($tOS, 'MajorVersion'), -8), DllStructGetData($tOS, 'MinorVersion'))
	Else
		Return 0
	EndIf
EndFunc   ;==>_IC_WinVer

#EndRegion Internal Functions

#Region DLL Functions

#cs

_IC_EnumProc

#ce

Func _IC_EnumProc($hModule, $iType, $iName, $lParam)

	#forceref $hModule, $iType

	$icData[21] += 1

	Local $Ret = DllCall('kernel32.dll', 'int', 'lstrlenW', 'ptr', $iName)

	If @error Then
		Return 0
	EndIf
	If (Not $Ret[0]) And (Number($iName) = $lParam) Then
		$icData[20] = $icData[21] - 1
		Return 0
	Else
		Return 1
	EndIf
EndFunc ;==> _IC_EnumProc

#Region DLL Functions

#Region Window Message Functions

#cs

IC_WM_COMMAND
IC_WM_CONTEXTMENU
IC_WM_GETMINMAXINFO
IC_WM_NOTIFY
IC_WM_SYSCOMMAND

#ce

Func IC_WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	Switch $hWnd
		Case 0

		Case $icData[0]

			Local $Data

			Switch _WinAPI_LoWord($wParam)
				Case 0

				Case $icData[1]
					If $icData[16] Then
						Return $GUI_RUNDEFMSG
					EndIf
					Switch _WinAPI_HiWord($wParam)
						Case $EN_KILLFOCUS
							$Data = _IC_SearchPath(GUICtrlRead($icData[1]))
							GUICtrlSetData($icData[1], $Data)
							If $Data <> $icData[12] Then
								$icData[12] = $Data
								$icData[13] = 0
								$icData[14] = 1
								$icData[22] = 0
							EndIf
					EndSwitch
				Case $icData[6]
					Switch _WinAPI_HiWord($wParam)
						Case $BN_CLICKED
							$icData[15] = 1
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>IC_WM_COMMAND

Func IC_WM_CONTEXTMENU($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	Switch $hWnd
		Case 0

		Case $icData[0]
			If $icData[16] Then
				Return 0
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>IC_WM_CONTEXTMENU

Func IC_WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	Switch $hWnd
		Case 0

		Case $icData[0]

			Local $tMMI = DllStructCreate('long[2];long[2];long[2];long[2];long[2]', $lParam)

			DllStructSetData($tMMI, 4, $icData[10], 1)
			DllStructSetData($tMMI, 4, $icData[11], 2)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>IC_WM_GETMINMAXINFO

Func IC_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	If $icData[16] Then
		Return $GUI_RUNDEFMSG
	EndIf

	Switch $hWnd
		Case 0

		Case $icData[0]

;~			Local $tNMIA = DllStructCreate($tagNMITEMACTIVATE, $lParam)
			If @AutoItX64 Then
				Local $tNMIA = DllStructCreate($tagNMHDR & ';uint Aligment;int Item;int SubItem;uint NewState;uint OldState;uint Changed;int X;int Y;lparam lParam;uint KeyFlags', $lParam)
			Else
				Local $tNMIA = DllStructCreate($tagNMHDR & ';int Item;int SubItem;uint NewState;uint OldState;uint Changed;int X;int Y;lparam lParam;uint KeyFlags', $lParam)
			EndIf
			Local $hLV = DllStructGetData($tNMIA, 'hWndFrom')
			Local $ID = DllStructGetData($tNMIA, 'Code')
			Local $Item = DllStructGetData($tNMIA, 'Item')

			Switch $hLV
				Case 0

				Case $icData[8]
					Switch $ID
						Case $LVN_BEGINDRAG
							Return 0
						Case $LVN_ITEMACTIVATE
							GUICtrlSendToDummy($icData[2], $Item)
						Case $LVN_ITEMCHANGED
							If BitAND(DllStructGetData($tNMIA, 'NewState'), $LVIS_SELECTED) Then
								$icData[13] = $Item
							EndIf
						Case $LVN_KEYDOWN
							If Not _IC_SCAW() Then
								Switch BitAND($Item, 0xFF)
									Case 0x74 ; F5
;~										$icData[13] =-1
										$icData[14] = 1
								EndSwitch
							EndIf
						Case $NM_CLICK, $NM_DBLCLK, $NM_RCLICK, $NM_RDBLCLK
							If $Item = -1 Then
								_GUICtrlListView_SetItemSelected($hLV, $icData[13], 1, 1)
							EndIf
					EndSwitch
				Case $icData[9]
					Switch $ID
						Case $BCN_DROPDOWN
							GUICtrlSendToDummy($icData[3])
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>IC_WM_NOTIFY

Func IC_WM_SYSCOMMAND($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	Switch $hWnd
		Case 0

		Case $icData[0]
			Switch $wParam
				Case 0xF060 ; SC_CLOSE
					$icData[15] = 1
				Case 0xF100 ; SC_KEYMENU
					Return 0
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>IC_WM_SYSCOMMAND

#EndRegion Window Message Functions
