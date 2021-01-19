#NoTrayIcon
#include <GUIConstants.au3>
#include <sqlite.au3>
#include <sqlite.dll.au3>
#Include <GuiListBox.au3>
#Include <GuiListView.au3>
#include <Misc.au3>
_Singleton ("a89s76da9sd768")

#compiler_useupx=n

Global $gui_Form, $gui_Log, $gui_InputQuery, $gui_SendQuery, $gui_Result, $gui_Tables, $gui_filemenu, $gui_fileopen, $gui_TblContexDelDat, $gui_TblContexSelectCnt,$gui_TblContexHtml
Global $gui_optGetTable, $gui_optmenu, $gui_optQuery, $gui_funcChanges, $gui_funcLastInsertId, $gui_funcMenu, $gui_funcRepQuery, $gui_optPragmaInChk, $gui_optPragmaSyn
Global $gui_TblContexDrop, $gui_TblContexMenu, $gui_TblContexSelect, $gui_ResultContexCopy = -1, $gui_ResultContexMenu, $gui_TblContexRndIns
$gui_Form = GUICreate("SQLite Browser", 622, 460, 199, 135, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
$gui_Log = GUICtrlCreateEdit("", 8, 368, 609, 70, BitOR($WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY), $WS_EX_CLIENTEDGE)
GUICtrlSetFont(-1, 7)
GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
$gui_InputQuery = GUICtrlCreateCombo("SELECT * FROM sqlite_master;", 8, 336, 561, 21, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWN), $WS_EX_CLIENTEDGE)
GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
$gui_SendQuery = GUICtrlCreateButton("&Query", 576, 336, 41, 21, $BS_DEFPUSHBUTTON)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
$gui_Result = GUICtrlCreateListView("", 131, 8, 485, 305, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
$gui_Tables = GUICtrlCreateList("", 8, 8, 121, 318, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
$gui_TblContexMenu = GUICtrlCreateContextMenu($gui_Tables)
$gui_TblContexSelect = GUICtrlCreateMenuItem("Select Table", $gui_TblContexMenu)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$gui_TblContexHtml = GUICtrlCreateMenuItem("Show Table in Browser", $gui_TblContexMenu)
$gui_TblContexSelectCnt = GUICtrlCreateMenuItem("Count Rows", $gui_TblContexMenu)
$gui_TblContexDrop = GUICtrlCreateMenuItem("Drop Table", $gui_TblContexMenu)
$gui_TblContexInsert = GUICtrlCreateMenuItem("Build Insert", $gui_TblContexMenu)
$gui_TblContexRndIns = GUICtrlCreateMenuItem("Insert 'random(*)' Data", $gui_TblContexMenu)
$gui_TblContexDelDat = GUICtrlCreateMenuItem("Delete Data", $gui_TblContexMenu)
$gui_filemenu = GUICtrlCreateMenu("&File")
$gui_fileopen = GUICtrlCreateMenuItem("Open", $gui_filemenu)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$gui_fileClose = GUICtrlCreateMenuItem("Close", $gui_filemenu)
GUICtrlSetState(-1, $GUI_DISABLE)
$gui_optmenu = GUICtrlCreateMenu("&Options")
$gui_optGetTable = GUICtrlCreateMenuItem("Use GetTable", $gui_optmenu)
GUICtrlSetState(-1, $GUI_CHECKED)
$gui_optQuery = GUICtrlCreateMenuItem("Use Prepare,Step", $gui_optmenu)
GUICtrlCreateMenuItem("", $gui_optmenu)
$gui_optPragmaSyn = GUICtrlCreateMenuItem("PRAGMA synchronous;", $gui_optmenu)
$gui_optPragmaInChk = GUICtrlCreateMenuItem("PRAGMA integrity_check;", $gui_optmenu)
$gui_funcMenu = GUICtrlCreateMenu("F&unctions")
$gui_funcLastInsertId = GUICtrlCreateMenuItem("Last Insert RowID", $gui_funcMenu)
$gui_funcChanges = GUICtrlCreateMenuItem("Changes", $gui_funcMenu)
$gui_funcRepQuery = GUICtrlCreateMenuItem("Repeat Query", $gui_funcMenu)
GUISetState(@SW_SHOW)

_SQLite_Startup ()
If @error > 0 Then
	MsgBox(0, @error, "Error loading SQLite.dll")
	Exit
EndIf
_log("SQLite Version: " & _SQLite_LibVersion (), 0)

Local $sDBFileName, $tmp
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $gui_fileopen
			$sDBFileName = FileOpenDialog("Select Database, Nonexistend will be Created", @ScriptDir, "db Files (*.db)|All (*.*)", 0, "test.db")
			If @error > 0 Then $sDBFileName = ""
			_SQLite_Open ($sDBFileName)
			If @error > 0 Then
				_log("Error opening " & $sDBFileName)
				ContinueLoop
			EndIf
			GUICtrlSetState($gui_fileopen, $GUI_DISABLE)
			GUICtrlSetState($gui_fileClose, $GUI_ENABLE)
			_updatetables()
			GUICtrlSetState($gui_SendQuery, $GUI_ENABLE)
		Case $msg = $gui_Tables Or $msg = $gui_TblContexSelect
			Local $sSelectedTable = GUICtrlRead($gui_Tables)
			GUICtrlSetData($gui_InputQuery, "SELECT ROWID AS RowID,* FROM " & $sSelectedTable & ";", "SELECT ROWID AS RowID,* FROM " & $sSelectedTable & ";")
		Case $msg = $gui_TblContexDelDat
			Local $sSelectedTable = GUICtrlRead($gui_Tables)
			GUICtrlSetData($gui_InputQuery, "DELETE FROM " & $sSelectedTable & ";", "DELETE FROM " & $sSelectedTable & ";")
		Case $msg = $gui_optPragmaInChk
			GUICtrlSetData($gui_InputQuery, "PRAGMA integrity_check;", "PRAGMA integrity_check;")
		Case $msg = $gui_optPragmaSyn
			GUICtrlSetData($gui_InputQuery, "PRAGMA synchronous;", "PRAGMA synchronous;")
		Case $msg = $gui_TblContexSelectCnt
			Local $sSelectedTable = GUICtrlRead($gui_Tables) 
			GUICtrlSetData($gui_InputQuery, "SELECT count() as RowCount FROM " & $sSelectedTable & ";", "SELECT count() as RowCount FROM " & $sSelectedTable & ";")
		Case $msg = $gui_TblContexHtml
			_BrowseTable(GUICtrlRead($gui_Tables))
		Case $msg = $gui_SendQuery
			Local $nTimerQuery
			GUICtrlSetState($gui_SendQuery, $GUI_DISABLE)
			GUICtrlSetData($gui_InputQuery, GUICtrlRead($gui_InputQuery))
			$nTimerQuery = TimerInit()
			If BitAND(GUICtrlRead($gui_optGetTable), $GUI_CHECKED) Then
				_sqlGetTable(GUICtrlRead($gui_InputQuery))
			Else
				_sqlQuery(GUICtrlRead($gui_InputQuery))
			EndIf
			_log("Total Query Time: " & Round(TimerDiff($nTimerQuery), 2) & " mSec.")
			_updatetables()
			GUICtrlSetState($gui_SendQuery, $GUI_ENABLE)
		Case $msg = $gui_funcRepQuery
			Local $nTimerQuery, $nRepeats = InputBox('Repeat Query', "how often?", "10")
			If @error > 0 Then ContinueLoop
			GUICtrlSetState($gui_SendQuery, $GUI_DISABLE)
			GUICtrlSetData($gui_InputQuery, GUICtrlRead($gui_InputQuery))
			$nTimerQuery = TimerInit()
			If BitAND(GUICtrlRead($gui_optGetTable), $GUI_CHECKED) Then
				_sqlGetTable(GUICtrlRead($gui_InputQuery), $nRepeats)
			Else
				_sqlQuery(GUICtrlRead($gui_InputQuery), $nRepeats)
			EndIf
			_log("Total Query Time: " & Round(TimerDiff($nTimerQuery), 2) & " mSec.")
			_updatetables()
			GUICtrlSetState($gui_SendQuery, $GUI_ENABLE)
		Case $msg = $gui_fileClose
			Local $iTmp
			$iTmp = _SQLite_Close ()
			If Not $iTmp = $SQLITE_OK Then
				_log("Cannot close Database.")
				_log("SQLite ErrCode: " & $iTmp)
				_log("SQLite ErrMsg: " & _SQLite_ErrMsg ())
			EndIf
			_GUICtrlListClear ($gui_Tables)
			_ResetResults()
			GUICtrlSetState($gui_fileClose, $GUI_DISABLE)
			GUICtrlSetState($gui_fileopen, $GUI_ENABLE)
			GUICtrlSetState($gui_SendQuery, $GUI_DISABLE)
		Case $msg = $gui_optGetTable
			GUICtrlSetState($gui_optGetTable, $GUI_CHECKED)
			GUICtrlSetState($gui_optQuery, $GUI_UNCHECKED)
			GUICtrlSetState($gui_funcRepQuery, $GUI_ENABLE)
		Case $msg = $gui_optQuery
			GUICtrlSetState($gui_optQuery, $GUI_CHECKED)
			GUICtrlSetState($gui_optGetTable, $GUI_UNCHECKED)
			GUICtrlSetState($gui_funcRepQuery, $GUI_DISABLE)
		Case $msg = $gui_funcChanges
			_log("Changes: " & _SQLite_Changes ())
			_log("Total Changes: " & _SQLite_TotalChanges ())
		Case $msg = $gui_funcLastInsertId
			_log("Last INSERT RowID: " & _SQLite_LastInsertRowID ())
		Case $msg = $gui_TblContexDrop
			Local $sSelectedTable = GUICtrlRead($gui_Tables)
			GUICtrlSetData($gui_InputQuery, "DROP TABLE " & $sSelectedTable & ";", "DROP TABLE " & $sSelectedTable & ";")
		Case $msg = $gui_TblContexInsert
			Local $aTbl, $aRow, $iTmp, $i, $sQuery, $hQuery
			$aTbl = _GUICtrlListGetSelItemsText ($gui_Tables)
			If IsArray($aTbl) Then
				$iTmp = _SQLite_Query (-1, "SELECT * FROM " & $aTbl[1] & " LIMIT 1;", $hQuery)
				If $iTmp = $SQLITE_OK Then
					_SQLite_FetchNames ($hQuery, $aRow)
					_SQLite_QueryFinalize ($hQuery)
					$sQuery = "INSERT INTO " & $aTbl[1] & " VALUES ("
					For $i = 0 To UBound($aRow) - 1
						$sQuery &= "'',"
					Next
					$sQuery = StringTrimRight($sQuery, 1)
					$sQuery &= ");"
					GUICtrlSetData($gui_InputQuery, $sQuery, $sQuery)
				EndIf
			EndIf
		Case $msg = $gui_TblContexRndIns
			Local $aTbl, $aRow, $iTmp, $i, $sQuery, $hQuery
			$aTbl = _GUICtrlListGetSelItemsText ($gui_Tables)
			If IsArray($aTbl) Then
				$iTmp = _SQLite_Query (-1, "SELECT * FROM " & $aTbl[1] & " LIMIT 1;", $hQuery)
				If $iTmp = $SQLITE_OK Then
					_SQLite_FetchNames ($hQuery, $aRow)
					_SQLite_QueryFinalize ($hQuery)
					$sQuery = "INSERT INTO " & $aTbl[1] & " VALUES ("
					For $i = 0 To UBound($aRow) - 1
						$sQuery &= "random(*),"
					Next
					$sQuery = StringTrimRight($sQuery, 1)
					$sQuery &= ");"
					GUICtrlSetData($gui_InputQuery, $sQuery, $sQuery)
				EndIf
			EndIf
		Case $msg = $gui_ResultContexCopy
			ClipPut(_GUICtrlListViewGetItemText ($gui_Result))
		Case Else
			;;;;;;;
	EndSelect
WEnd
_SQLite_Shutdown ()
Exit

Func _log($str, $fprepandcr = True)
	If $fprepandcr Then $str = @CRLF & $str
	GUICtrlSetData($gui_Log, $str, 1)
EndFunc   ;==>_log

Func _updatetables()
	_GUICtrlListClear ($gui_Tables)
	Local $hQuery, $iTmp, $aRow
	$iTmp = _SQlite_Query (-1, "SELECT name FROM sqlite_master WHERE type = 'table' OR type = 'view'", $hQuery)
	If Not $iTmp = $SQLITE_OK Then
		_log("Cant Read out Tables")
		Return
	EndIf
	While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
		_GUICtrlListAddItem ($gui_Tables, $aRow[0])
	WEnd
	_SQLite_QueryFinalize ($hQuery)
	$iTmp = _SQlite_Query (-1, "SELECT name FROM sqlite_temp_master WHERE type = 'table' OR type = 'view'", $hQuery)
	If Not $iTmp = $SQLITE_OK Then
		_log("Cant Read out Temp Tables")
		Return
	EndIf
	While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
		_GUICtrlListAddItem ($gui_Tables, $aRow[0])
	WEnd
	_SQLite_QueryFinalize ($hQuery)
	_GUICtrlListAddItem ($gui_Tables, 'sqlite_master')
	_GUICtrlListAddItem ($gui_Tables, 'sqlite_temp_master')
EndFunc   ;==>_updatetables

Func _sqlQuery($sql, $nRepeats = -1)
	Local $iTmp, $hQuery, $aRow, $aNames
	_log("SQLite Query: " & $sql)
	$iTmp = _SQlite_Query (-1, $sql, $hQuery)
	If Not $iTmp = $SQLITE_OK Then
		_log("SQLite ErrCode: " & $iTmp)
		_log("SQLite ErrMsg: " & _SQLite_ErrMsg ())
		Return
	EndIf
	_SQLite_FetchNames ($hQuery, $aNames)
	If UBound($aNames) = 1 Then $aNames[0] &= "|"
	_ResetResults(_ArrayToString($aNames, "|"))
	While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
		GUICtrlCreateListViewItem(_ArrayToString($aRow, "|"), $gui_Result)
	WEnd
EndFunc   ;==>_sqlQuery

Func _sqlGetTable($sql, $nRepeats = -1)
	Local $aResult, $iRows, $iColumns, $iRval, $iCol, $iRow, $ResHead, $ResData, $nSQLiteApiTimer, $sqlrep
	_log("SQLite GetTable: " & $sql)
	If $nRepeats > 0 Then
		For $i = 1 To $nRepeats
			$sqlrep = $sqlrep & $sql
		Next
		$sql = $sqlrep
	EndIf
	$nSQLiteApiTimer = TimerInit()
	$iRval = _SQLite_GetTable2d (-1, $sql, $aResult, $iRows, $iColumns)
	If Not $iRval = $SQLITE_OK Then
		_log("SQLite ErrCode: " & $iRval)
		_log("SQLite ErrMsg: " & _SQLite_ErrMsg())
		Return
	EndIf
	_log("SQLite Api Time: " & Round(TimerDiff($nSQLiteApiTimer), 2) & " mSec.")
	If UBound($aResult, 2) = 0 Then _ResetResults()
	For $iCol = 0 To UBound($aResult, 1) - 1
		$ResData = ''
		For $iRow = 0 To UBound($aResult, 2) - 1
			If $iCol = 0 Then
				$ResHead &= $aResult[$iCol][$iRow] & "|"
			Else
				$ResData &= $aResult[$iCol][$iRow] & "|"
			EndIf
		Next
		If $iCol = 0 Then
			StringTrimRight($ResHead, 1)
			_ResetResults($ResHead)
		Else
			StringTrimRight($ResData, 1)
			GUICtrlCreateListViewItem($ResData, $gui_Result)
		EndIf
	Next
EndFunc   ;==>_sqlGetTable

Func _ResetResults($str = "")
	Local $a
	$a = ControlGetPos($gui_Form, "", $gui_Result)
	GUICtrlDelete($gui_Result)
	;$gui_Result = GUICtrlCreateListView($str, 131, 8, 485, 305, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
	$gui_Result = GUICtrlCreateListView($str, $a[0], $a[1], $a[2], $a[3], BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP, $LVS_EX_TRACKSELECT, $LVS_EX_FULLROWSELECT))
	;GUICtrlSendMsg($gui_Result, 0x101E, 0, -1) ;$listview, LVM_SETCOLUMNWIDTH, 0,  resize to widest value
	GUICtrlSetResizing($gui_Result, $GUI_DOCKBORDERS)
	$gui_ResultContexMenu = GUICtrlCreateContextMenu($gui_Result)
	$gui_ResultContexCopy = GUICtrlCreateMenuItem("Copy", $gui_ResultContexMenu)
EndFunc   ;==>_ResetResults

Func _BrowseTable($sTable)
	If $sTable = "" Then Return ; No Table Selected
	; Write Table to disk
	Local $sTempDbFile = FileGetShortName(_TempFile(@TempDir,"",".db")), $aRow, $nTimer = TimerInit()
	$i = _SQLite_Exec(-1,"ATTACH DATABASE '" & $sTempDbFile & "' AS HtmlExport;")
	_SQLite_QuerySingleRow(-1,"SELECT sql FROM sqlite_master WHERE type = 'table' and name = '" & $sTable & "';",$aRow)
	if stringlen($aRow[0]) < 6 Then
		_SQLite_QuerySingleRow(-1,"SELECT sql FROM sqlite_temp_master WHERE type = 'table' and name = '" & $sTable & "';",$aRow)
		if stringlen($aRow[0]) < 6 Then Return ; Table not found
	EndIf
	Local $sTableCreate = StringReplace($aRow[0],"CREATE TABLE " & $sTable, "CREATE TABLE HtmlExport." & $sTable)
	_SQLite_Exec(-1,$sTableCreate)
	_SQLite_Exec(-1,"INSERT INTO HtmlExport." & $sTable & " SELECT * FROM " & $sTable & ";")
	_SQLite_Exec(-1,"DETACH DATABASE HtmlExport;")

	; Create html
	Local $sTempPrefix = FileGetShortName(_TempFile(@TempDir,"",".htm"))
	Local $sTempSuffix = FileGetShortName(_TempFile(@TempDir,"",".htm"))
	Local $sTempMiddle = FileGetShortName(_TempFile(@TempDir,"",".htm"))
	Local $sTempOutputHtml = FileGetShortName(_TempFile(@TempDir,"",".htm"))
	FileWrite($sTempPrefix,"<html><body><table cellpadding='2' cellspacing ='1'rules='all' border='1' >")
	FileWrite($sTempSuffix,"</table></body></html><!-- ")
	Local $sInput, $sOutput
	$sInput  = ".header ON" & @CRLF
	$sInput &= ".mode html" & @CRLF
	$sInput &= ".output '" & $sTempMiddle & "'" & @CRLF
	$sInput &= "SELECT ROWID as RowID,* FROM " & $sTable & ";" & @CRLF
	_SQLite_SQLiteExe($sTempDbFile,$sInput,$sOutput)
	RunWait (@ComSpec & " /c copy /y " & $sTempPrefix & "+" & $sTempMiddle & "+" & $sTempSuffix & " " & $sTempOutputHtml,@WorkingDir,@SW_HIDE)
	_log('Export Time:' & Round(TimerDiff($nTimer), 2) & " mSec.")
	RunWait (@ComSpec & " /c START " & $sTempOutputHtml,@WorkingDir,@SW_HIDE)
	
EndFunc