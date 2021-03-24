#Region Header

#cs
    Title:          SQLite Extending Library for AutoIt3
    Filename:       SQLiteEx.au3
    Description:    Set of useful SQLite functions
    Author:         57ar7up
    Version:        0.5.1
	Last Update: 	21/01/14
    Requirements:   AutoIt v3.3 +, Developed/Tested on Windows 7
	Notes:			With this UDF you can work only with one database simultaneously, for simplicity

    Available functions:

    _SQLiteEx_Open
	_SQLiteEx_Get
	_SQLiteEx_Set
	_SQLiteEx_Insert
	_SQLiteEx_Delete
	_SQLiteEx_QuerySingleRow
	_SQLiteEx_FirstTableEntry
	_SQLiteEx_LastTableEntry
    _SQLiteEx_SetTable
	_SQLiteEx_TableExists
	_SQLiteEx_ShowTable
	_SQLiteEx_DropTable
	_SQLiteEx_DatabaseExists
	_SQLiteEx_DropDatabase
	_SQLiteEx_Close

    Examples: see SQLiteEx_Examples.au3
#ce

#Include-once
#Include 'SQLite.au3'
#Include 'SQLite.dll.au3'

#EndRegion Header

#Region Global Variables and Constants

Global $_sDBExtension	= '.sqlite3'		;Database extension
Global $_sDBsPath		= @ScriptDir & '/'	;Path to databases
Global $_hDB			= FALSE				;Current database handle
Global $_sDBName		= FALSE				;Current database name
Global $_sTable			= FALSE				;Current table name

Dim $aSQLiteErrors[24][2] = [ _
	[0, 'OK'], _
	[1, 'SQL error or missing database'], _
	[2, 'An internal logic error in SQLite'], _
	[3, 'Access permission denied'], _
	[4, 'Callback routine requested an abort'], _
	[5, 'The database file is locked'], _
	[6, 'A table in the database is locked'], _
	[7, 'A malloc() failed'], _
	[8, 'Attempt to write a readonly database'], _
	[9, 'Operation terminated by sqlite_interrupt()'], _
	[10, 'Some kind of disk I/O error occurred'], _
	[11, 'The database disk image is malformed'], _
	[12, '(Internal Only) Table or record not found'], _
	[13, 'Insertion failed because database is full'], _
	[14, 'Unable to open the database file'], _
	[15, 'Database lock protocol error'], _
	[16, '(Internal Only) Database table is empty'], _
	[17, 'The database schema changed'], _
	[18, 'Too much data for one row of a table'], _
	[19, 'Abort due to constraint violation'], _
	[20, 'Data type mismatch'], _
	[21, 'Library used incorrectly'], _
	[22, 'Uses OS features not supported on host'], _
	[23, 'Authorization denied'] _
]

#EndRegion Global Variables and Constants

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_Open
; Description....: Opens SQLite database
; Syntax.........: _SQLite_Open ($sDBWay [, $sSQL])
;                  $sDBWay	- Way to name new DB or find DB file, can be file name in database folder with extension or without (must be $_sDBExtension)
;				   $sSQL	- SQL code to execute, if provided
; Return values..: Success	- TRUE
;                  Failure	- FALSE
; Author.........: 57ar7up
; Remarks........: If not exists, new DB created
; ======

Func _SQLiteEx_Open($sDBWay = FALSE, $sSQL = FALSE) ;Returns handle to DB
	_SQLite_Startup()
	If @error > 0 Then
		Exit - 1
	EndIf
	If Not $sDBWay = FALSE Then
		$sDBPath = $_sDBsPath & $sDBWay
		If Not FileExists($sDBPath) Then
			Local $sDrive, $sDir, $sFileName, $sExtension
			Local $aPathSplit = _PathSplit($sDBPath, $sDrive, $sDir, $sFileName, $sExtension)
			If $sExtension = $_sDBExtension Then
				_FileCreate($sDBPath)
			Else
				$sDBPath &= $_sDBExtension
				If NOT FileExists($sDBPath) Then _FileCreate($sDBPath)
			EndIf
		EndIf
	Else
		$sTempFile = _TempFile(@ScriptFullPath, '', $_sDBExtension)
		Local $sDrive, $sDir, $sFileName, $sExtension
		Local $aPathSplit = _PathSplit($sTempFile, $sDrive, $sDir, $sFileName, $sExtension)
		$sDBPath = $sFileName & $sExtension
	EndIf
	$_hDB = _SQLite_Open($sDBPath)
	If $_hDB <> FALSE Then
		$_sDBName = __FileBasename($sDBPath)
		
		If $sSQL <> FALSE Then
			$iSQLite_Status = _SQLite_Exec($_hDB, $sSQL)
			If Not $iSQLite_Status = $SQLite_OK Then
				Return SetError(1, FALSE, _SQLite_ErrMsg());$aSQLiteErrors[$iSQLite_Status][1])
			Else
				Return TRUE
			EndIf
		Else
			Return TRUE
		EndIf
	Else
		Say('Failed to open DB')
		Sleep(2000)
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_Get
; Description....: Gets value from specified column
; Syntax.........: _SQLiteEx_Get ($sColumn [, $sWhere])
;                  $sColumn	- Name of the existing column in current working table
;				   $sWhere	- Optional SQL code inserted after 'WHERE '
; Return values..: Success	- Value
;                  Failure  - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_Get($sColumn, $sWhere = FALSE)
	If $_sTable = FALSE Then Return FALSE
	If $sWhere Then
		$sSQL = "SELECT " & $sColumn & " FROM " & $_sTable & " WHERE " & $sWhere
	Else
		$sSQL = "SELECT " & $sColumn & " FROM " & $_sTable
	EndIf
	$aRow = _SQLiteEx_QuerySingleRow($sSQL)
	If Not IsArray($aRow) Then
		Return FALSE
	Else
		Return $aRow[0]
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_Set
; Description....: Sets value for specified column
; Syntax.........: _SQLiteEx_Set ($Field, $Value [, $sWhere])
;                  $sField  - Name of the existing column in current working table
;				   $sValue	- Data to set
;				   $sWhere	- Optional SQL code inserted after 'WHERE'
; Return values..: Success  - TRUE
;                  Failure  - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_Set($Field, $Value, $sWhere = Default)
	If $_sTable = FALSE Then Return FALSE
	If $sWhere <> Default Then
		$sWhereIs = ' WHERE ' & $sWhere
	Else
		$sWhereIs = ''
	EndIf
	$sSQL = 'SELECT * FROM ' & $_sTable & $sWhereIs
	$aRow = _SQLiteEx_QuerySingleRow($sSQL)
	If IsArray($aRow) Then
		If Not __SQLiteEx_Update($Field, $Value, $sWhere) = FALSE Then
			Return TRUE
		Else
			Return FALSE
		EndIf
	Else
		If Not _SQLiteEx_Insert($Field, $Value) = FALSE Then
			Return TRUE
		Else
			Return FALSE
		EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_Insert
; Description....: Inserts row with value at specified column
; Syntax.........: _SQLiteEx_Insert ($Field, $Value)
;                  $sField  - Name of the existing column in current working table
;				   $sValue	- Data to insert
; Return values..: Success  - Id of inserted row
;                  Failure  - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_Insert($Field, $Value) ;Returns inserted id if success
	If IsArray($Field) Then
		Local $sField, $sValue = ''
		For $i = 0 To UBound($Field) - 1
			$sField &= $Field[$i]
			$sValue &= $Value[$i]
			If $i <> UBound($Field) - 1 Then
				$sField &= "', '"
				$sValue &= "', '"
			EndIf
		Next
	Else
		$sField = $Field
		$sValue = $Value
	EndIf
	If $_sTable = FALSE Then Return FALSE
	$sSQL = "INSERT INTO " & $_sTable & " ('" & $sField & "') VALUES ('" & $sValue & "');"
	If _SQLite_Exec(-1, $sSQL) = $SQLite_OK Then
		Return _SQLite_LastInsertRowID()
	Else
		Return SetError(_SQLite_ErrMsg(), '', FALSE)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_Delete
; Description....: Deletes row with value at specified column
; Syntax.........: _SQLiteEx_Delete ( $sField [, $sValue])
;                  $sField  - Name of the existing column in current working table
;				   $sValue	- When this value at column, row removed
; Return values..: Success  - TRUE
;                  Failure  - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_Delete($sField, $sValue)
	If $_sTable = FALSE Then Return FALSE
	$sSQL = "SELECT * FROM " & $_sTable & " WHERE " & $sField & "='" & $sValue & "'"
	If _SQLiteEx_QuerySingleRow($sSQL) = FALSE Then Return FALSE
	$sSQL = "DELETE FROM " & $_sTable & " WHERE " & $sField & "='" & $sValue & "'"
	If _SQLite_Exec(-1, $sSQL) = $SQLite_OK Then
		Return TRUE
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_QuerySingleRow
; Description....: Read out the first row of the result from the specified query.
; Syntax.........: _SQLiteEx_QuerySingleRow ($sSQL)
;                  $sSQL	- SQL code
; Return values..: Success  - Array with row data
;                  Failure  - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_QuerySingleRow($sSQL)
	Local $aRet
	_SQLite_QuerySingleRow(-1, $sSQL, $aRet)
	If IsArray($aRet) Then
		Return $aRet
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_FirstTableEntry
; Description....: Gets entry with minimum RowID
; Syntax.........: _SQLiteEx_FirstTableEntry ()
; Return values..: Success - Array with row data
;                  Failure - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_FirstTableEntry()
	If $_sTable = FALSE Then Return FALSE
	$sSQL = 'SELECT * FROM ' & $_sTable & ' WHERE ROWID=(SELECT MIN(ROWID) FROM ' & $_sTable & ')';
	$aRet = _SQLiteEx_QuerySingleRow($sSQL)
	If IsArray($aRet) Then
		Return $aRet
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_LastTableEntry
; Description....: Get entry with maximum RowID
; Syntax.........: _SQLiteEx_LastTableEntry ()
; Return values..: Success - Array with row data
;                  Failure - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_LastTableEntry()
	Local $aRet
	If $_sTable = FALSE Then Return FALSE
	$sSQL = 'SELECT * FROM ' & $_sTable & ' WHERE ROWID=(SELECT MAX(ROWID) FROM ' & $_sTable & ')';
	$aRet = _SQLiteEx_QuerySingleRow($sSQL)
	If IsArray($aRet) Then
		Return $aRet
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_SetTable
; Description....: Sets current table to work with
; Syntax.........: _SQLiteEx_SetTable ($sTBL)
;                  $sTBL - Name of the table
; Return values..: none
; Author.........: 57ar7up
; ======

Func _SQLiteEx_SetTable($sTBL)
	$_sTable = $sTBL
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_TableExists
; Description....: Checks whether table with specified name exists, if not defined checks current table
; Syntax.........: _SQLiteEx_TableExists ([$sTBL])
;                  $sTBL - Name of the table
; Return values..: Success - TRUE
;                  Failure - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_TableExists($sTBL = Default)
	If $sTBL = Default Then
		If $_sTable = FALSE Then
			Return FALSE
		Else
			$sTable = $_sTable
		EndIf
	Else
		$sTable = $sTBL
	EndIf
	$sSQL = "SELECT name FROM SQLite_master WHERE type='table' AND name='" & $_sTable & "';"
	$aRet = _SQLiteEx_QuerySingleRow($sSQL)
	If $aRet[0] <> '' Then
		Return TRUE
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_ShowTable
; Description....: Checks whether table with specified name exists, if not defined checks current table
; Syntax.........: _SQLiteEx_ShowTable ([$sTBL] [, $sColumn [, $sSortType]])
;                  $sTBL		- Name of the table, if not specified, will take current
;				   $sColumn		- Name of column to sort
;				   $sSortType	- Type of sorting, ASC or DESC
; Return values..: Success		- Shows modal window with table data
;                  Failure		- FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_ShowTable($sTBL = Default, $sColumn = 'RowID', $sSortType = 'ASC') ;Displays current table
	If $sTBL = Default Then
		If $_sTable = FALSE Then
			Return FALSE
		Else
			$sTable = $_sTable
		EndIf
	Else
		$sTable = $sTBL
	EndIf
	If $_sTable = FALSE Then Return FALSE
	Local $aResult, $iRows, $iColumns, $iRval
	$sSQL = 'SELECT * FROM ' & $_sTable & ' ORDER BY ' & $sColumn & ' ' & $sSortType
	$iRval = _SQLite_GetTable2d(-1, $sSQL, $aResult, $iRows, $iColumns)
	If $iRval = $SQLite_OK Then
		_ArrayDisplay($aResult, $_sTable)
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_DropTable
; Description....: Deletes table
; Syntax.........: _SQLiteEx_DropTable ($sTBL)
;                  $sTBL	- Name of the table to delete, if not specified, current table will be deleted
; Return values..: Success	- TRUE
;                  Failure	- FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_DropTable($sTBL = Default)
	If $sTBL = Default Then
		If $_sTable = FALSE Then
			Return FALSE
		Else
			$sTable = $_sTable
		EndIf
	Else
		$sTable = $sTBL
	EndIf
	$sSQL = ('DROP TABLE ' & $_sTable)
	If _SQLite_Exec($_hDB, $sSQL) = $SQLite_OK Then
		Return TRUE
	Else
		Return FALSE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_DatabaseExists
; Description....: Checks whether database exists, name can be file name with extension or not
; Syntax.........: _SQLiteEx_DatabaseExists ( $sDBName )
;                  $sDB	- Name of database to delete
; Return values..: Success - TRUE
;                  Failure - FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_DatabaseExists($sDBName)
	If Not FileExists($sDBName) Then
		$sDBName &= $_sDBExtension
		If Not FileExists($sDBName) Then Return FALSE
	EndIf
	Return TRUE
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_DropDatabase
; Description....: Deletes database
; Syntax.........: _SQLiteEx_DropDatabase ( $sDB)
;                  $sDBN	- Name of database to delete, if not specified, current DB will be deleted
; Return values..: Success	- TRUE
;                  Failure	- FALSE
; Author.........: 57ar7up
; ======

Func _SQLiteEx_DropDatabase($sDBN = Default)
	If $sDBN = Default Then
		If $_sDBName = FALSE Then
			Return FALSE
		Else
			$sDBName = $_sDBName
		EndIf
	Else
		$sDBName = $sDBN
	EndIf
	If $_sDBName <> FALSE And $sDBName = $_sDBName Then
		_SQLite_Close($_hDB)
		_SQLite_Shutdown()
	EndIf
	$sDBPath = $_sDBsPath & $sDBName & $_sDBExtension
	If FileExists($sDBPath) Then
		$iDelete = FileDelete($sDBPath)
		If $iDelete = 1 Then Return TRUE
		Return FALSE
	Else
		Return TRUE
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLiteEx_Close
; Description....: Closes current database
; Syntax.........: _SQLiteEx_Close ()
; Return values..: none
; Author.........: 57ar7up
; ======

Func _SQLiteEx_Close()
	If $_hDB = FALSE Then $_hDB = -1
	_SQLite_Close($_hDB)
EndFunc

#EndRegion Public Functions

Func __SQLiteEx_Query($sSQL)
	Local $hQuery
	_SQLite_Query(-1, $sSQL, $hQuery)
	Return $hQuery
EndFunc

Func __SQLiteEx_Update($Field, $Value, $sWhere = Default)
	If IsArray($Field) Then
		Local $sSet
		For $i = 0 To UBound($Field) - 1
			$sSet &= $Field[$i] & " = '" & $Value[$i] & "'"
			If $i <> UBound($Field) - 1 Then $sSet &= ", "
		Next
	Else
		$sSet = $Field & " = '" & $Value & "'"
	EndIf
	If $sWhere <> Default Then
		$sWhereIs = ' WHERE ' & $sWhere
	Else
		$sWhereIs = ''
	EndIf
	If $_sTable = FALSE Then Return FALSE
	$sSQL = "UPDATE " & $_sTable & " SET " & $sSet & $sWhereIs
	If _SQLite_Exec(-1, $sSQL) = $SQLite_OK Then
		Return TRUE
	Else
		Return SetError(_SQLite_ErrMsg(), '', FALSE)
	EndIf
EndFunc

Func __FileBasename($sFile)
	Return StringRegExpReplace($sFile, "(.*?[\\/])*(.*?)((?:\.\w+\z|\z))", "$2")
EndFunc

OnAutoitExitRegister('_SQLite_Shutdown')