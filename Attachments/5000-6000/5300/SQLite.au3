#include-once
#comments-start
	
	User Calltips:
	
	_SQLite_Startup([$sDll_Filename]) Loads SQLite3.dll
	_SQLite_Shutdown() Unloads SQLite3.dll
	_SQLite_Open($sDatabase_Filename) ; Opens Database, Sets Standard Handle, Returns Handle
	_SQLite_Close($hDB) Closes Database
	_SQLite_GetTable($hDB | -1, $sSQL, ByRef $aResult, ByRef $iRows, ByRef $iColumns, ByRef $sErrorMsg, [$iCharSize = 64]) Executes $sSQL Query to $aResult, Returns Error Code
	_SQLite_Exec($hDB | -1, $sSQL, ByRef $sErrorMsg, $iCharSize = 64) Executes $sSQL (No Result), Returns Error Code
	_SQLite_LibVersion() Returns Dll's Version No.
	_SQLite_LastInsertRowID($hDB) Returns Last INSERT ROWID
	_SQLite_Changes([$hDB]) Returns Number of Changes (Excluding Triggers)
	_SQLite_TotalChanges([$hDB]) Returns Number of All Changes (Including Triggers)
	_SQLite_ErrCode([$hDB]) Returns Last Error Code (Numeric)
	_SQLite_ErrMsg([$hDB]) Returns Las Error Message
	
#comments-end
Global Const $SQLITE_OK = 0   ; /* Successful result */
Global Const $SQLITE_ERROR = 1   ; /* SQL error or missing database */
Global Const $SQLITE_INTERNAL = 2   ; /* An internal logic error in SQLite */
Global Const $SQLITE_PERM = 3   ; /* Access permission denied */
Global Const $SQLITE_ABORT = 4   ; /* Callback routine requested an abort */
Global Const $SQLITE_BUSY = 5   ; /* The database file is locked */
Global Const $SQLITE_LOCKED = 6   ; /* A table in the database is locked */
Global Const $SQLITE_NOMEM = 7   ; /* A malloc() failed */
Global Const $SQLITE_READONLY = 8   ; /* Attempt to write a readonly database */
Global Const $SQLITE_INTERRUPT = 9   ; /* Operation terminated by sqlite_interrupt() */
Global Const $SQLITE_IOERR = 10   ; /* Some kind of disk I/O error occurred */
Global Const $SQLITE_CORRUPT = 11   ; /* The database disk image is malformed */
Global Const $SQLITE_NOTFOUND = 12   ; /* (Internal Only) Table or record not found */
Global Const $SQLITE_FULL = 13   ; /* Insertion failed because database is full */
Global Const $SQLITE_CANTOPEN = 14   ; /* Unable to open the database file */
Global Const $SQLITE_PROTOCOL = 15   ; /* Database lock protocol error */
Global Const $SQLITE_EMPTY = 16   ; /* (Internal Only) Database table is empty */
Global Const $SQLITE_SCHEMA = 17   ; /* The database schema changed */
Global Const $SQLITE_TOOBIG = 18   ; /* Too much data for one row of a table */
Global Const $SQLITE_CONSTRAINT = 19   ; /* Abort due to constraint violation */
Global Const $SQLITE_MISMATCH = 20   ; /* Data type mismatch */
Global Const $SQLITE_MISUSE = 21   ; /* Library used incorrectly */
Global Const $SQLITE_NOLFS = 22   ; /* Uses OS features not supported on host */
Global Const $SQLITE_AUTH = 23   ; /* Authorization denied */
Global Const $SQLITE_ROW = 100   ; /* sqlite_step() has another row ready */
Global Const $SQLITE_DONE = 101   ; /* sqlite_step() has finished executing */

Global $SQLiteWrapperGlobalVar_hDll = 0
Global $SQLiteWrapperGlobalVar_hDB = 0

Func _SQLite_Startup($sDll_Filename = "sqlite3.dll") ; Loads SQLite Dll
	Global $SQLiteWrapperGlobalVar_hDll
	Local $hDll
	$hDll = DllOpen($sDll_Filename)
	If $hDll = -1 Then
		SetError(1)
	Else
		$SQLiteWrapperGlobalVar_hDll = $hDll
	EndIf
EndFunc   ;==>_SQLite_Startup

Func _SQLite_Shutdown() ; Unloads SQLite Dll
	Global $SQLiteWrapperGlobalVar_hDll
	DllClose($SQLiteWrapperGlobalVar_hDll)
EndFunc   ;==>_SQLite_Shutdown

Func _SQLite_Open($sDatabase_Filename) ; Opens Database, Returns Handle
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "int", "sqlite3_open", "str", $sDatabase_Filename, "long_ptr", 0) ; OUT: SQLite db handle
	If @error > 0 Then
		SetError(1)
	Else
		$SQLiteWrapperGlobalVar_hDB = $r[2]
		Return $r[2]
	EndIf
EndFunc   ;==>_SQLite_Open

Func _SQLite_Close($hDB) ; Closes Database
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "int", "sqlite3_close", "ptr", $hDB) ; An open database
	If @error > 0 Then
		SetError(1) ; Dll Calling Error
	ElseIf $r[0] = 0 Then
		$SQLiteWrapperGlobalVar_hDB = 0
		Return
	Else
		SetError(2) ; Sqlite Error
	EndIf
EndFunc   ;==>_SQLite_Close

Func _SQLite_GetTable($hDB, $sSQL, ByRef $aResult, ByRef $iRows, ByRef $iColumns, ByRef $sErrorMsg,$iCharSize = 64)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	Local $r, $iResultSize, $i, $struct1, $pResult
	
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	
	$r = DllCall($SQLiteWrapperGlobalVar_hDll, "int", "sqlite3_get_table", "ptr", $hDB, "str", $sSQL, "long_ptr", 0, "long_ptr", 0, "long_ptr", 0, "long_ptr", 0)  ; Error msg written here
	
	If @error > 0 Then
		SetError(1) ; Dll Calling Error
		Return
	EndIf
	
	$pResult = $r[3]
	$iRows = $r[4]+1
	$iColumns = $r[5]
	$iResultSize = ($iRows) * ($iColumns)
	
	For $i = 1 To $iResultSize - 1
		$struct1 &= "ptr;"
	Next
	
	$struct1 &= "ptr"
	$struct2 = DllStructCreate($struct1, $pResult)
	
	if $irows > 0 and $icolumns > 0 then	
		Dim $aResult [$icolumns][$irows]
		
		$iCurRow = 0
		$iCurCol = 0
		
		For $i = 1 To $iResultSize
			if $iCurCol+1 > $icolumns Then
				$iCurRow = $iCurRow+1
				$iCurCol = 0
			EndIf
			
			$aResult[$iCurCol][$iCurRow] = DllStructGetData(DllStructCreate("char[" & $iCharSize & "]", DllStructGetData($struct2, $i)), 1)
			
			$iCurCol = $iCurCol+1
		Next
		
	EndIf
	If $r[0] = $SQLITE_OK Then
		$sErrorMsg = "Successful result"
	Else
		$sErrorMsg = DllStructGetData(DllStructCreate("char[" & $iCharSize & "]", $r[6]), 1)
		SetError(2) ; Sql Error
	EndIf
	DllCall($SQLiteWrapperGlobalVar_hDll, "none", "sqlite3_free_table", "ptr", $pResult) ; pointer to 'resultp' from sqlite3_get_table
	Return $r[0]
EndFunc   ;==>_SQLite_GetTable

Func _SQLite_Exec($hDB, $sSQL, ByRef $sErrorMsg, $iCharSize = 256)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "int", "sqlite3_exec", "ptr", $hDB, "str", $sSQL, "ptr", "", "ptr", "", "long_ptr", 0); Error msg written here
	If @error > 0 Then
		SetError(1) ; DllCall Error
	EndIf
	If $r[0] = $SQLITE_OK Then
		$sErrorMsg = "Successful result"
	Else
		SetError(2) ; SQL Error
		$sErrorMsg = DllStructGetData(DllStructCreate("char[" & $iCharSize & "]", $r[5]), 1)
	EndIf
	Return $r[0]
EndFunc   ;==>_SQLite_Exec

Func _SQLite_LibVersion()
	Global $SQLiteWrapperGlobalVar_hDll
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "str", "sqlite3_libversion")
	If @error > 0 Then
		SetError(1); DLLCall Error
	Else
		Return $r[0]
	EndIf
EndFunc   ;==>_SQLite_LibVersion

Func _SQLite_LastInsertRowID($hDB = -1)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "long", "sqlite3_last_insert_rowid", "ptr", $hDB)
	If @error > 0 Then
		SetError(1) ;DllCall Error
	Else
		Return $r[0]
	EndIf
EndFunc   ;==>_SQLite_LastInsertRowID

Func _SQLite_Changes($hDB = -1)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "long", "sqlite3_changes", "ptr", $hDB)
	If @error > 0 Then
		SetError(1) ;DllCall Error
	Else
		Return $r[0]
	EndIf
EndFunc   ;==>_SQLite_Changes

Func _SQLite_TotalChanges($hDB = -1)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "long", "sqlite3_total_changes", "ptr", $hDB)
	If @error > 0 Then
		SetError(1) ;DllCall Error
	Else
		Return $r[0]
	EndIf
EndFunc   ;==>_SQLite_TotalChanges

Func _SQLite_ErrCode($hDB = -1)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "long", "sqlite3_errcode", "ptr", $hDB)
	If @error > 0 Then
		SetError(1) ;DllCall Error
	Else
		Return $r[0]
	EndIf
EndFunc   ;==>_SQLite_ErrCode

Func _SQLite_ErrMsg($hDB = -1)
	Global $SQLiteWrapperGlobalVar_hDll
	Global $SQLiteWrapperGlobalVar_hDB
	If $hDB = -1 Or $hDB = "" Then
		$hDB = $SQLiteWrapperGlobalVar_hDB
	EndIf
	Local $r = DllCall($SQLiteWrapperGlobalVar_hDll, "str", "sqlite3_errmsg", "ptr", $hDB)
	If @error > 0 Then
		SetError(1) ;DllCall Error
	Else
		Return $r[0]
	EndIf
EndFunc   ;==>_SQLite_ErrMsg