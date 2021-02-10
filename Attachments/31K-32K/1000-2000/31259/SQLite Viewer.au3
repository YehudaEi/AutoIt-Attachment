#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.4.0
	Author:         LurchMan (7/22/2010)
	Version: 1.0
	Script Function: Basic SQLite Database Viewer

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <sqlite.au3>
#include <SQLite.dll.au3>
#include <GuiListView.au3>
#include <GuiTab.au3>
Global $sPath, $hDB, $Tab, $ListView, $aTabs[1], $aListView[1]
Global $TableName
Opt("GUIOnEventMode", 1)
Opt("GUIDataSeparatorChar", "|")
;~ #Region ### START Koda GUI section ### Form=
;~ $front = GUICreate("Open SQLite DB", 722, 572, 192, 114)
;~ GUISetOnEvent($GUI_EVENT_CLOSE, "frontClose")
;~ $path = GUICtrlCreateInput("", 88, 24, 417, 21)
;~ GUICtrlCreateLabel("Path to DB", 16, 28, 56, 17)
;~ $browse = GUICtrlCreateButton("Browse", 528, 22, 75, 25, $WS_GROUP)
;~ GUICtrlSetOnEvent(-1, "browseClick")
;~ $Open = GUICtrlCreateButton("Open", 184, 64, 75, 25, BitOR($WS_GROUP, $BS_DEFPUSHBUTTON))
;~ GUICtrlSetOnEvent(-1, "OpenClick")
;~ $Exit = GUICtrlCreateButton("Exit", 304, 64, 75, 25, $WS_GROUP)
;~ GUICtrlSetOnEvent(-1, "frontclose")
;~ GUISetState(@SW_SHOW)
;~ #EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=
$front = GUICreate("SQLite Viewer | Open SQLite DB", 723, 573, 192, 114)
GUISetOnEvent($GUI_EVENT_CLOSE, "frontClose")
$path = GUICtrlCreateInput("", 136, 240, 417, 21)
GUICtrlCreateLabel("Path to DB", 64, 244, 56, 17)
$browse = GUICtrlCreateButton("Browse", 576, 238, 75, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "browseClick")
$Open = GUICtrlCreateButton("Open", 232, 280, 75, 25, BitOR($BS_DEFPUSHBUTTON, $WS_GROUP))
GUICtrlSetOnEvent(-1, "OpenClick")
$Exit = GUICtrlCreateButton("Exit", 352, 280, 75, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "frontclose")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	Sleep(100)
WEnd

Func browseClick()
	Local $sPath = FileOpenDialog("Open SQLite DB", @MyDocumentsDir, "All (*.*)")
	GUICtrlSetData($path, $sPath)
EndFunc   ;==>browseClick

Func frontClose()
	_SQLite_Shutdown()
	Exit
EndFunc   ;==>frontClose

Func OpenClick()
	$sPath = GUICtrlRead($path)
	If Not FileExists(GUICtrlRead($path)) Then
		MsgBox(16, "File Not Found", "The file " & $sPath & " was not found.")
		Return
	EndIf
	_OpenDB($sPath)
EndFunc   ;==>OpenClick

Func _OpenDB($sPath)
	Local $aResult, $iRows, $iColumns, $hQuery, $sTableName
	Local $sTables = "", $aRow, $sMsg, $aNames, $sNames
	$hDll = _SQLite_Startup()

	$hDB = _SQLite_Open($sPath)
	If @extended <> $SQLITE_OK Then
		MsgBox(16, "Error", "Error while attempting to open the Database.")
		Return
	EndIf
;~ 	Get Table Names
	$rtn = _SQLite_GetTable($hDB, "SELECT * FROM sqlite_master", $aResult, $iRows, $iColumns)

	If $rtn <> $SQLITE_OK Then
		MsgBox(16, "Error", "Error while retrieving table names.")
		Return
	EndIf

	If $aResult[0] > 10 Then
		For $n = 7 To UBound($aResult) - 1 Step 5
			$sTableName &= $aResult[$n] & "|"
		Next
		$sTableName = StringTrimRight($sTableName, 1)
	Else
		$sTableName = $aResult[7]
	EndIf

	If StringInStr($sTableName, "|") Then $sTableName = StringSplit($sTableName, "|")

	_Viewer($sTableName)
EndFunc   ;==>_OpenDB

Func _Viewer($TableName)
	GUISetState(@SW_HIDE, $front)
	$viewer = GUICreate("SQLite Viewer | " & $sPath, 722, 572, 192, 114)
	GUISetOnEvent($GUI_EVENT_CLOSE, "frontClose")
	$Tab = GUICtrlCreateTab(24, 8, 681, 561)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlSetState(-1, $GUI_SHOW)
	GUICtrlSetOnEvent(-1, "TabChange")

	If Not IsArray($TableName) Then
		$temp = _GetTableInfo($TableName)
		$sColNames = _ArrayToString($temp)
		$aData = _GetData($TableName)
		_ArrayDelete($aData, 0)
		$aCols = StringSplit($sColNames, "|")
		GUICtrlCreateTabItem($TableName)
		$ListView = GUICtrlCreateListView($sColNames, 24, 32, 680, 535)
		_AddData($aData, $aCols, $ListView)

	Else
		For $n = 1 To UBound($TableName) - 1
			If $n > UBound($aTabs) - 1 Then ReDim $aTabs[$n + 1]
			If $n > UBound($aListView) - 1 Then ReDim $aListView[$n + 1]
			$temp = _GetTableInfo($TableName[$n])
			$sColNames = _ArrayToString($temp)
			$aData = _GetData($TableName[$n])
			_ArrayDelete($aData, 0)
			$aCols = StringSplit($sColNames, "|")
			$aTabs[$n] = GUICtrlCreateTabItem($TableName[$n])
			$aListView[$n] = GUICtrlCreateListView($sColNames, 24, 32, 680, 535)
			_AddData($aData, $aCols, $aListView[$n])
			GUICtrlSetState($aListView[$n], @SW_HIDE)
		Next
	EndIf
	GUICtrlCreateTabItem("")
	GUISetState(@SW_SHOW)
EndFunc   ;==>_Viewer

Func TabChange()
	Local $SelTab, $iCount
	$SelTab = GUICtrlRead($Tab)
	$iCount = _GUICtrlTab_GetItemCount($Tab)
	If IsArray($TableName) Then
		For $n = 0 To $iCount
			If $n <> $SelTab Then GUICtrlSetState($aListView[$n], @SW_HIDE)
		Next
		GUICtrlSetState($aListView[$SelTab], @SW_SHOW)
	EndIf
EndFunc   ;==>TabChange

Func _GetData($sTableName)
	Local $hQuery, $aRow, $sMsg = "", $iColumns, $iRows, $aResult
	Local $iCnt = 0
	$iRval = _SQLite_GetTable(-1, "SELECT * FROM " & $sTableName & ";", $aResult, $iRows, $iColumns)
	If $iRval <> $SQLITE_OK Then
		MsgBox(16, "Error", "Error while retrieving data from the table(s).")
		Return
	EndIf
	$rtn = _SQLite_Query($hDB, "SELECT * FROM " & $sTableName, $hQuery)
	If $rtn <> $SQLITE_OK Then
		MsgBox(16, "Error", "Error while aretrieving data from the table(s).")
		Return
	EndIf
	While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
		For $n = 0 To UBound($aRow) - 1
			$sMsg &= $aRow[$n] & "|"
		Next
	WEnd
	$sMsg = StringTrimRight($sMsg, 1)
	$aRtn = StringSplit($sMsg, "|")
	Return $aRtn
EndFunc   ;==>_GetData

Func _GetTableInfo($sTableName, $iCols = 0)
	Local $aResult, $iRows, $iColumns, $hQuery, $aNames
	_ArrayDisplay($sTableName)
	If $iCols = 1 Then
		$iRval = _SQLite_GetTable(-1, "SELECT * FROM " & $sTableName & ";", $aResult, $iRows, $iColumns)
		Return $iColumns
	Else
		_SQLite_SafeMode(False)
		$rtn = _SQLite_Query($hDB, "SELECT * FROM " & $sTableName & ";", $hQuery)
		If $rtn <> $SQLITE_OK Then
			MsgBox(16, "Error", "Error while attempting to retrieve database information.")
			Return
		EndIf
		_SQLite_FetchNames($hQuery, $aNames) ; Read out Column Names
		_SQLite_SafeMode(True)
		Return $aNames
	EndIf
EndFunc   ;==>_GetTableInfo

Func _AddData($aData, $aCols, $hListView)
	Local $iCnt = 0
	For $n = 0 To UBound($aData) - 1 Step $aCols[0]
		_GUICtrlListView_AddItem($hListView, $aData[$n], $iCnt)
		For $i = 0 To $aCols[0] - 1
			_GUICtrlListView_AddSubItem($hListView, $iCnt, $aData[$n + $i], $i)
		Next
		$iCnt += 1
	Next
EndFunc   ;==>_AddData