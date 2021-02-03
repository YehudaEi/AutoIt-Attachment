#Region Header

; #INDEX# =======================================================================================================================
; Title .........: ExpListView
; AutoIt Version : 3.3.5.0
; Language ......: English
; Description ...: Functions for working with Explorer ListViews.
; Author(s) .....: Beege
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ExpListView_Create
; _ExpListView_Back
; _ExpListView_DirGetCurrent
; _ExpListView_DirSetCurrent
; _ExpListView_SetColumns
; _ExpListView_SetFunction
; _ExpListView_ShowHiddenFiles
; _ExpListView_Refresh
; _ExpListView_ColumnViewsSave
; _ExpListView_ColumnViewsRestore
; ===============================================================================================================================

#include-once
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <array.au3>

GUIRegisterMsg($WM_NOTIFY, "EXPLORER_WM_NOTIFY")
OnAutoItExitRegister('__EXIT')

#EndRegion Header

#Region Global Variables and Constants

Global $Shell32 = DllOpen('shell32.dll')
Global Const $FOLDER_ICON_INDEX = _GUIImageList_GetFileIconIndex(@SystemDir, 0, 1)
Global $aListViews[1][7] = [[0, 'Current Dir', 'Dir History', 'Columns', 'Function', 'ColumnWidths', 'ShowHidden']]

#cs

	$aListViews[0][0] 		= List Count
	[0][1-6] 	= Nothing

	$aListViews[$i][0] 	= hwnd
	[$i][1] 	= Current Directory
	[$i][2] 	= Directory History
	[$i][3] 	= Columns-Value  :filesize = 1, modified = 2,Attributes = 4, Creation = 8, Accessed = 16
	[$i][4] 	= Function to Call
	[$i][5] 	= Column Widths
	[$i][6] 	= Show Hidden Files Flag

#ce

#EndRegion Global Variables and Constants
#Region Public Functions
; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_Create
; Description ...: Create a ExpListView control
; Syntax.........: _GUICtrlListView_Create($hWnd, $sStartDir, $iColumns, $bShowHidden = False, $iX = 1, $iY = 1, [, $iWidth = 150[, $iHeight = 150[, $iStyle = 0x0000000D[, $iExStyle = 0x00000000[, $fCoInit = False]]]]])
; Parameters ....: $hWnd        - Handle to parent or owner window
;                  $sStartDir 	- Directory to start ListView in
;                  $iColumns    - This Flag value indicates which columns will be displayed. See Remarks
;                  $bShowHidden - This Flag value indicates weather hidden files will be displayed or not.
;                  $iX          - Horizontal position of the control
;                  $iY          - Vertical position of the control
;                  $iWidth      - Control width
;                  $iHeight     - Control height
;                  $iStyle      - Control styles: See _GUICtrlListView_Create() for Styles
;				   $iExStyle    - Extended control styles. See _GUICtrlListView_Create() for Extended Styles
;                  $fCoInit     - Initializes the COM library for use by the calling thread.
; Return values .: Success      - Handle to the ListView control
;                  Failure      - 0
; Author ........: Beege
; Remarks .......: The iColumns flag parameter can be a combination of the following values added together:
;					1 - File Size
;					2 - Last Modified
;					4 - Attributes
;					8 - Creation
;					16 - Last Accessed
;					Ex: If you wanted to show columns File size, Attributes and Creation, Flag Value would be 1+4+8 = 13
; Related .......: _GUICtrlListView_Create
; ===============================================================================================================================
Func _ExpListView_Create($hWnd, $sStartDir, $iColumns, $bShowHidden = False, $iX = 1, $iY = 1, $iWidth = 150, $iHeight = 150, $iStyle = 0x0000000D, $iExStyle = 0x00000000, $fCoInit = False)
	Local $hListView = _GUICtrlListView_Create($hWnd, 'Name', $iX, $iY, $iWidth, $iHeight, $iStyle, $iExStyle, $fCoInit)
	If $hListView = 0 Then Return SetError(1, @extended, 0)
	_GUICtrlListView_SetImageList($hListView, _GUIImageList_GetSystemImageList(), 1)
	ReDim $aListViews[UBound($aListViews) + 1][UBound($aListViews, 2)]
	$aListViews[0][0] += 1
	$aListViews[$aListViews[0][0]][0] = $hListView
	$aListViews[$aListViews[0][0]][1] = $sStartDir
	$aListViews[$aListViews[0][0]][5] = '50;50;50;50;50'
	$aListViews[$aListViews[0][0]][6] = $bShowHidden
	_ExpListView_SetColumns($hListView, $iColumns, False)
	_ChangeDir($aListViews[0][0], $sStartDir, False)
	Return $hListView
EndFunc   ;==>_ExpListView_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_Back
; Description ...: Navigates ListView Back to previous Directorys
; Syntax.........: _ExpListView_Back($hWnd)
; Parameters ....: $hWnd			- HWnd returned from _ExpListView_Create()
; Return values .: Success      - 1
;                  Failure      - 0  and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: Function returns a 2 and does not set error if the History Stack is Empty
; ===============================================================================================================================
Func _ExpListView_Back($hWnd)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	Local $sPop = _HistoryPoP($iArrayIndex)
	If $sPop = -1 Then Return 2;History Stack is empty
	_ChangeDir($iArrayIndex, $sPop, False)
	Return 1
EndFunc   ;==>_ExpListView_Back

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_DirGetCurrent
; Description ...: Gets ListView Current Directory
; Syntax.........: _ExpListView_DirGetCurrent($hWnd)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
; Return values .: Success      - Directory Name
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: -
; ===============================================================================================================================
Func _ExpListView_DirGetCurrent($hWnd)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	Return $aListViews[$iArrayIndex][1]
EndFunc   ;==>_ExpListView_DirGetCurrent

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_DirSetCurrent
; Description ...: Sets ListView Current Directory
; Syntax.........: _ExpListView_DirSetCurrent($hWnd, $sDirectory)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
; Return values .: Success      - 1
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: -
; ===============================================================================================================================
Func _ExpListView_DirSetCurrent($hWnd, $sDirectory)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	If Not FileExists($sDirectory) Then Return SetError(2, @extended, 0) ;invalad Directory
	_ChangeDir($iArrayIndex, $sDirectory)
	Return 1
EndFunc   ;==>_ExpListView_DirSetCurrent

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_SetColumns
; Description ...: Sets ListView Column Flag value indicating which columns to show.
; Syntax.........: _ExpListView_SetColumns($hWnd, $iColunms, $bRefresh = True)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
;				   $iColumns	- Column Flag Value. See Remarks
;				   $bRefresh	- Flag indicating weather to refresh listview after setting columns
; Return values .: Success      - 1
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: The iColumns flag parameter can be a combination of the following values:
;					1  - File Size
;					2  - Last Modified
;					4  - Attributes
;					8  - Creation
;					16 - Last Accessed
;					Ex: If you wanted to show columns File size, Attributes and Creation, Flag Value would be 1+4+8 = 13
; ===============================================================================================================================
Func _ExpListView_SetColumns($hWnd, $iColunms, $bRefresh = True)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd

	_SaveColunmWidths($iArrayIndex, $hWnd)
	$aListViews[$iArrayIndex][3] = $iColunms

	_SetColumnsWidths($iArrayIndex, $hWnd)

	If $bRefresh Then _ChangeDir($iArrayIndex, $aListViews[$iArrayIndex][1], False)
	Return 1
EndFunc   ;==>_ExpListView_SetColumns

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_SetFunction
; Description ...: Sets a function to call after a Double-Click(Navigation) Event has happened.
; Syntax.........: _ExpListView_SetFunction($hWnd, $sFunction)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
;				   $sFunction	- Function to Call
; Return values .: Success      - 1
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: User function needs to have one parameter. That parameter is the Hwnd of the ListView that recived the Event.
;					Ex: 	Func MyUserFunction($hWndListView)
;							...
;							EndFunc
; ===============================================================================================================================
Func _ExpListView_SetFunction($hWnd, $sFunction)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	$aListViews[$iArrayIndex][4] = $sFunction
	Return 1
EndFunc   ;==>_ExpListView_SetFunction

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_ShowHiddenFiles
; Description ...: Sets Current ListView Directory
; Syntax.........: _ExpListView_ShowHiddenFiles($hWnd, $bShowHidden)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
;                  $bShowHidden - This Flag value indicates weather hidden files will be displayed or not. True or False
; Return values .: Success      - 1
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
;								- 2 Invalid Flag
; Author ........: Beege
; Remarks .......: ExpListViews are created with default showhidden flag being False
; ===============================================================================================================================
Func _ExpListView_ShowHiddenFiles($hWnd, $bShowHidden)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	If $bShowHidden Or Not $bShowHidden Then
		$aListViews[$iArrayIndex][6] = $bShowHidden
		Return 1
	EndIf
	Return SetError(2, @extended, 0);invalad Flag
EndFunc   ;==>_ExpListView_ShowHiddenFiles

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_Refresh
; Description ...: Refreshes ExpListView
; Syntax.........: _ExpListView_Refresh($hWnd)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
; Return values .: Success      - 1
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: -
; ===============================================================================================================================
Func _ExpListView_Refresh($hWnd)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	_ChangeDir($iArrayIndex, $aListViews[$iArrayIndex][1], False)
EndFunc   ;==>_ExpListView_Refresh

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_ColumnViewsSave
; Description ...: Gets string representing info about column widths and values
; Syntax.........: _ExpListView_ColumnViewsSave($hWnd)
; Parameters ....: $hWnd		- HWnd returned from _ExpListView_Create()
; Return values .: Success      - String
;                  Failure      - 0 and sets @ERROR:
;								- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: String is to be used with _ExpListView_ColumnViewsRestore() function.
; ===============================================================================================================================
Func _ExpListView_ColumnViewsSave($hWnd)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	_SaveColunmWidths($iArrayIndex, $hWnd)
	Return ($aListViews[$iArrayIndex][3] & '|' & _GUICtrlListView_GetColumnWidth($hWnd, 0) & '|' & $aListViews[$iArrayIndex][5])
EndFunc   ;==>_ExpListView_ColumnViewsSave

; #FUNCTION# ====================================================================================================================
; Name...........: _ExpListView_ColumnViewsRestore
; Description ...: Restores ExpListViews Columns and Column Sizes
; Syntax.........: _ExpListView_ColumnViewsRestore($hWnd, $sColumnViews)
; Parameters ....: $hWnd			- HWnd returned from _ExpListView_Create()
;                  $sColumnViews 	- String Returned from _ExpListView_ColumnViewsSave()
; Return values .: Success      	- String
;                  Failure      	- 0 and sets @ERROR:
;									- 1 Invalid hWnd
; Author ........: Beege
; Remarks .......: -
; ===============================================================================================================================
Func _ExpListView_ColumnViewsRestore($hWnd, $sColumnViews)
	Local $iArrayIndex = _GetIndex($hWnd)
	If $iArrayIndex = -1 Then Return SetError(1, @extended, 0);invald hWnd
	Local $aSplit = StringSplit($sColumnViews, '|')
	_GUICtrlListView_SetColumnWidth($hWnd, 0, $aSplit[2])
	$aListViews[$iArrayIndex][5] = $aSplit[3]
	_SetColumnsWidths($iArrayIndex, $hWnd)
	_ExpListView_SetColumns($hWnd, $aSplit[1])
EndFunc   ;==>_ExpListView_ColumnViewsRestore
#EndRegion Public Functions

#Region Internal Functions
Func EXPLORER_WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	Local $iCode = DllStructGetData($tNMHDR, "Code")
	If $iCode = $NM_DBLCLK Then ; Sent by a list-view control when the user double-clicks an item with the left mouse button
		Local $hWndFrom, $tInfo, $iArrayIndex
		$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
		$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
		$iArrayIndex = _GetIndex($hWndFrom)
		_GetChangeDir($iArrayIndex, DllStructGetData($tInfo, "Index"))
		If $aListViews[$iArrayIndex][4] <> '' Then Call($aListViews[$iArrayIndex][4], $hWndFrom)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>EXPLORER_WM_NOTIFY
Func _SetColumnsWidths($iArrayIndex, $hWnd)
	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hWnd)
	For $i = 1 To $iColumnCount
		_GUICtrlListView_DeleteColumn($hWnd, 1)
	Next

	Local $aColumnWidths = StringSplit($aListViews[$iArrayIndex][5], ';')
	If BitAND($aListViews[$iArrayIndex][3], 1) Then _GUICtrlListView_AddColumn($hWnd, 'Size', Int($aColumnWidths[1]))
	If BitAND($aListViews[$iArrayIndex][3], 2) Then _GUICtrlListView_AddColumn($hWnd, 'Modified', Int($aColumnWidths[2]))
	If BitAND($aListViews[$iArrayIndex][3], 4) Then _GUICtrlListView_AddColumn($hWnd, 'Attributes', Int($aColumnWidths[3]))
	If BitAND($aListViews[$iArrayIndex][3], 8) Then _GUICtrlListView_AddColumn($hWnd, 'Creation', Int($aColumnWidths[4]))
	If BitAND($aListViews[$iArrayIndex][3], 16) Then _GUICtrlListView_AddColumn($hWnd, 'Accessed', Int($aColumnWidths[5]))
EndFunc   ;==>_SetColumnsWidths
Func _SaveColunmWidths($iArrayIndex, $hWnd)
	Local $i, $aColumnWidths, $iColunmValue = 1, $iColunmIndex = 1
	$aColumnWidths = StringSplit($aListViews[$iArrayIndex][5], ';')

	For $i = 1 To 5
		If BitAND($aListViews[$iArrayIndex][3], $iColunmValue) Then
			$aColumnWidths[$i] = _GUICtrlListView_GetColumnWidth($hWnd, $iColunmIndex)
			$iColunmIndex += 1
		EndIf
		$iColunmValue += $iColunmValue
	Next

	$aListViews[$iArrayIndex][5] = _ArrayToString($aColumnWidths, ';', 1)
EndFunc   ;==>_SaveColunmWidths
Func _GetIndex($hWnd)
	Local $i
	For $i = 1 To $aListViews[0][0]
		If $aListViews[$i][0] = $hWnd Then Return $i
	Next
	Return -1
EndFunc   ;==>_GetIndex
Func _ParentDirectory($iArrayIndex)
	Local $aDirSplit, $sChangeDir
	$aDirSplit = StringSplit($aListViews[$iArrayIndex][1], '\')
	If $aDirSplit[0] = 2 Then
		If $aDirSplit[2] = '' Then
			$sChangeDir = 'My Computer'
		Else
			$sChangeDir = $aDirSplit[1] & '\'
		EndIf
	Else
		For $i = 1 To $aDirSplit[0] - 1
			$sChangeDir &= $aDirSplit[$i] & '\'
		Next
		$sChangeDir = StringTrimRight($sChangeDir, 1)
	EndIf
	_ChangeDir($iArrayIndex, $sChangeDir)
EndFunc   ;==>_ParentDirectory
Func _GetChangeDir($iArrayIndex, $iListIndex)
	Local $sChangeDir, $sItemText = _GUICtrlListView_GetItemText($aListViews[$iArrayIndex][0], $iListIndex)
	Select
		Case $sItemText = '[..]'
			_ParentDirectory($iArrayIndex)
			Return
		Case $aListViews[$iArrayIndex][1] = 'My Computer'
			$sChangeDir = StringMid($sItemText, StringInStr($sItemText, '(') + 1, 2) & '\'
		Case Else
			If StringRight($aListViews[$iArrayIndex][1], 1) = '\' Then
				$sChangeDir = $aListViews[$iArrayIndex][1] & $sItemText
			Else
				$sChangeDir = $aListViews[$iArrayIndex][1] & '\' & $sItemText
			EndIf
			If StringInStr(FileGetAttrib($sChangeDir), 'D') = 0 Then Return
	EndSelect
	_ChangeDir($iArrayIndex, $sChangeDir)
EndFunc   ;==>_GetChangeDir
Func _ChangeDir($iArrayIndex, $sDirectory, $bPushHistory = True)
	If $sDirectory = 'My Computer' Then
		If $bPushHistory Then _HistoryPush($iArrayIndex, $aListViews[$iArrayIndex][1])
		_MyComputer($iArrayIndex)
		Return
	EndIf

	Local $aList, $sFile, $sAttributes, $iIcon, $iItem, $iSize, $aTime, $iColumnIndex = 1
	_GUICtrlListView_DeleteAllItems($aListViews[$iArrayIndex][0])
	$aList = _FileListToArray_mod($sDirectory)
	_GUICtrlListView_BeginUpdate($aListViews[$iArrayIndex][0])
	_GUICtrlListView_AddItem($aListViews[$iArrayIndex][0], "[..]", $FOLDER_ICON_INDEX)

	If IsArray($aList) Then
		For $i = 1 To $aList[0]
			$sFile = $sDirectory & '\' & $aList[$i]
			$sAttributes = FileGetAttrib($sFile)
			If Not $aListViews[$iArrayIndex][6] Then;ShowHidden
				If StringInStr($sAttributes, 'H') > 0 Then ContinueLoop
			EndIf
			If StringInStr($sAttributes, 'D') > 0 Then
				$iIcon = $FOLDER_ICON_INDEX
			Else
				$iIcon = _GUIImageList_GetFileIconIndex($aList[$i])
			EndIf
			$iItem = _GUICtrlListView_AddItem($aListViews[$iArrayIndex][0], $aList[$i], $iIcon)
			;
			If BitAND($aListViews[$iArrayIndex][3], 1) Then ;size
				If $iIcon = $FOLDER_ICON_INDEX Then
					_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $iItem, 'DIR', $iColumnIndex)
				Else
					$iSize = FileGetSize($sFile)
					_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $iItem, _bytes($iSize), $iColumnIndex)
				EndIf
				$iColumnIndex += 1
			EndIf
			If BitAND($aListViews[$iArrayIndex][3], 2) Then ;Modified
				$aTime = FileGetTime($sFile, 0)
				_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $iItem, $aTime[0] & '/' & $aTime[1] & '/' & $aTime[2] & ' ' & $aTime[3] & ':' & $aTime[4] & ':' & $aTime[5], $iColumnIndex)
				$iColumnIndex += 1
			EndIf
			If BitAND($aListViews[$iArrayIndex][3], 4) Then ;Attributes
				_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $iItem, $sAttributes, $iColumnIndex)
				$iColumnIndex += 1
			EndIf

			If BitAND($aListViews[$iArrayIndex][3], 8) Then;Creation
				$aTime = FileGetTime($sFile, 1)
				_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $iItem, $aTime[0] & '/' & $aTime[1] & '/' & $aTime[2] & ' ' & $aTime[3] & ':' & $aTime[4] & ':' & $aTime[5], $iColumnIndex)
				$iColumnIndex += 1
			EndIf
			If BitAND($aListViews[$iArrayIndex][3], 16) Then;Accessed
				$aTime = FileGetTime($sFile, 2)
				_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $iItem, $aTime[0] & '/' & $aTime[1] & '/' & $aTime[2] & ' ' & $aTime[3] & ':' & $aTime[4] & ':' & $aTime[5], $iColumnIndex)
				$iColumnIndex += 1
			EndIf
			$iColumnIndex = 1
		Next
	EndIf
	_GUICtrlListView_EndUpdate($aListViews[$iArrayIndex][0])
	If $bPushHistory Then _HistoryPush($iArrayIndex, $aListViews[$iArrayIndex][1])
	$aListViews[$iArrayIndex][1] = $sDirectory
EndFunc   ;==>_ChangeDir
Func _MyComputer($iArrayIndex)
	Local $drives, $attributes, $item, $Time, $iColunmIndex = 1
	$aListViews[$iArrayIndex][1] = 'My Computer'
	_GUICtrlListView_DeleteAllItems($aListViews[$iArrayIndex][0])
	$drives = DriveGetDrive("ALL")
	For $i = 1 To $drives[0]
		$item = _GUICtrlListView_AddItem($aListViews[$iArrayIndex][0], DriveGetLabel($drives[$i] & '\') & ' (' & StringUpper($drives[$i]) & ')', _GUIImageList_GetFileIconIndex($drives[$i] & '\'))
		If BitAND($aListViews[$iArrayIndex][3], 1) Then ;size
			_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $item, 'DIR', $iColunmIndex)
			$iColunmIndex += 1
		EndIf
		If BitAND($aListViews[$iArrayIndex][3], 2) Then $iColunmIndex += 1;Modified
		If BitAND($aListViews[$iArrayIndex][3], 4) Then;Attributes
			$attributes = FileGetAttrib($drives[$i] & '\')
			_GUICtrlListView_AddSubItem($aListViews[$iArrayIndex][0], $item, $attributes, $iColunmIndex)
		EndIf
		$iColunmIndex = 1
	Next
EndFunc   ;==>_MyComputer
Func _HistoryPush($iArrayIndex, $sDir)
	$aListViews[$iArrayIndex][2] = $sDir & '|' & $aListViews[$iArrayIndex][2]
EndFunc   ;==>_HistoryPush
Func _HistoryPoP($iArrayIndex)
	Local $aSplit = StringSplit($aListViews[$iArrayIndex][2], '|', 2)
	If $aSplit[0] = '' Then Return -1
	Local $sReturn = $aSplit[0]
	_ArrayDelete($aSplit, 0)
	$aListViews[$iArrayIndex][2] = _ArrayToString($aSplit, '|')
	Return $sReturn
EndFunc   ;==>_HistoryPoP
Func _FileListToArray_mod($sPath, $sFilter = "*", $iFlag = 0)
	Local $hSearch, $sFile, $sFileList, $sFolderList, $sDelim = "|"
	$sPath = StringRegExpReplace($sPath, "[\\/]+\z", "") & "\" ; ensure single trailing backslash
	If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If StringRegExp($sFilter, "[\\/:><\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
	$hSearch = FileFindFirstFile($sPath & $sFilter)
	If @error Then Return SetError(4, 4, "")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If @extended Then
			$sFolderList &= $sDelim & $sFile
		Else
			$sFileList &= $sDelim & $sFile
		EndIf
	WEnd
	FileClose($hSearch)
	$sFileList = $sFolderList & $sFileList
	If Not $sFileList Then Return SetError(4, 4, "")
	Return StringSplit(StringTrimLeft($sFileList, 1), "|")
EndFunc   ;==>_FileListToArray_mod
Func _bytes($iBytes)
	Switch $iBytes
		Case 0 To 1023
			Return $iBytes & " Bytes"
		Case 1024 To 1048575
			Return Round($iBytes / 1024, 2) & " KB"
		Case 1048576 To 1073741823
			Return Round($iBytes / 1048576, 2) & " MB"
		Case Else
			Return Round($iBytes / 1073741824, 2) & " GB"
	EndSwitch
EndFunc   ;==>_bytes
Func __EXIT()
	DllClose($Shell32)
EndFunc   ;==>__EXIT
;Originally written by Prog@ndy
Func _GUIImageList_GetSystemImageList($bLargeIcons = False)
	Local $SHGFI_USEFILEATTRIBUTES = 0x10, $SHGFI_SYSICONINDEX = 0x4000, $SHGFI_SMALLICON = 0x1;, $SHGFI_LARGEICON = 0x0;,$FILE_ATTRIBUTE_NORMAL = 0x80
	Local $FileInfo = DllStructCreate("dword hIcon; int iIcon; DWORD dwAttributes; CHAR szDisplayName[255]; CHAR szTypeName[80];")
	Local $dwFlags = BitOR($SHGFI_USEFILEATTRIBUTES, $SHGFI_SYSICONINDEX)
	If Not ($bLargeIcons) Then $dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
	Local $hIml = _WinAPI_SHGetFileInfo(".txt", $FILE_ATTRIBUTE_NORMAL, DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), $dwFlags)
	Return $hIml
EndFunc   ;==>_GUIImageList_GetSystemImageList
Func _GUIImageList_GetFileIconIndex($sFileSpec, $bLargeIcons = False, $bForceLoadFromDisk = False);modified
	Static $FileInfo = DllStructCreate("dword hIcon; int iIcon; DWORD dwAttributes; CHAR szDisplayName[255]; CHAR szTypeName[80];")
	Local $dwFlags = BitOR(0x4000, 0x1)
	If Not $bForceLoadFromDisk Then $dwFlags = BitOR($dwFlags, 0x10)
	DllCall($Shell32, "DWORD*", "SHGetFileInfo", "str", $sFileSpec, "DWORD", $FILE_ATTRIBUTE_NORMAL, "ptr", DllStructGetPtr($FileInfo), "UINT", DllStructGetSize($FileInfo), "UINT", $dwFlags)
	If @error Then Return SetError(1, 0, -1)
	Return DllStructGetData($FileInfo, "iIcon")
EndFunc   ;==>_GUIImageList_GetFileIconIndex
Func _WinAPI_SHGetFileInfo($pszPath, $dwFileAttributes, $psfi, $cbFileInfo, $uFlags)
	Local $return = DllCall($Shell32, "DWORD*", "SHGetFileInfo", "str", $pszPath, "DWORD", $dwFileAttributes, "ptr", $psfi, "UINT", $cbFileInfo, "UINT", $uFlags)
	If @error Then Return SetError(@error, 0, 0)
	Return $return[0]
EndFunc   ;==>_WinAPI_SHGetFileInfo
#EndRegion Internal Functions
