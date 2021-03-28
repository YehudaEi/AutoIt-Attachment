
; #FUNCTION# ====================================================================================================================
; Name...........: _SQLite_Backup
; Version........: 0.2	2010-03-08 (new return value)
; Description ...: Backups an entire open SQLite Database, even while it's being used
; Syntax.........: _SQLite_Backup($hSrcDbCon, $sDstDbFile, Byref $hDstDbCon, $sSrcDbName = 'main', $sDstDbName = 'main', $iBlockSize = Default, $iSleepTime = Default, $hProgressBar = Default)
; Parameters ....: $hSrcDbCon - An Open Database connection, Use -1 To use Last Opened Database
;                  $sDstDbFile - The destination database filename
;                  $hDstDbCon - pass back the handle of a DB when restoring to memory
;                  $sSrcDbName - Optional: The name of the source database, defaults to 'main'
;                  $sDstDbName - Optional: The name of the destination database, defaults to 'main'
;                  $iBlockSize - Optional: The number of pages in every backup block, default to 16 pages.  Use -1 to copy the database in one shot.
;                  $iSleepTime - Optional: The sleep delay between block of pages writes, default to 250ms
;                  $hProgressBar - Optional: ID of a ProgressBar (returned by GUICtrlCreateProgress) to update, or -1 to list progress on console. Default is 0 for none.
; Return values .: Returns the handle of a memory DB when restoring from disk to memory
;                  @error Value(s):       -1 - SQLite Reported an Error (Check @extended Value)
;                  1 - Error returned by _SQLite_LibVersion
;                  2 - The active sqlite3.dll doesn't support the backup API. Minimum version is 3.6.11
;                  3 - Invalid source DB connection handle ($hSrcDbCon)
;                  4 - Error while converting $sSrcDbFile to UTF-8
;                  5 - Error while converting $sDstDbFile to UTF-8
;                  6 - Error reported by _SQLite_open
;                  7 - Error reported by _SQLite_SetTimeout on source DB
;                  8 - Error reported by _SQLite_SetTimeout on destination DB
;                  9 - Error querying source Db page_size
;                  10 - Error querying destination Db page_size
;                  11 - Error changing destination Db page_size
;                  12 - Error Calling SQLite API 'sqlite3_backup_init'
;                  13 - Error Calling SQLite API 'sqlite3_backup_step'
;                  14 - Error Calling SQLite API 'sqlite3_backup_remaining'
;                  15 - Error Calling SQLite API 'sqlite3_backup_pagecount'
;                  16 - Error Calling SQLite API 'sqlite3_backup_finish'
;                  17 - Error closing destination Db
;                  @extended Value(s): Can be compared against $SQLITE_* Constants
; Author ........: jchd
; ===============================================================================================================================
Func _SQLite_Backup($hSrcDbCon, $sDstDbFile, $sSrcDbName = Default, $sDstDbName = Default, $iBlockSize = Default, $iSleepTime = Default, $hProgressBar = Default)
    If __SQLite_hChk($hSrcDbCon, 3) Then Return SetError(@error, 0, $SQLITE_MISUSE)
	If IsKeyword($sSrcDbName) Then $sSrcDbName = 'main'
	If IsKeyword($sDstDbName) Then $sDstDbName = 'main'
	If IsKeyword($iBlockSize) Then $iBlockSize = 16
	If IsKeyword($iSleepTime) Then $iSleepTime = 250
	If IsKeyword($hProgressBar) Then $hProgressBar = 0
	Local $RetVal = _SQLite_LibVersion()
    If @error Then Return SetError(1, @error, 0)
	; no backup API existed before SQLite v3.6.11
    If $RetVal < '3.6.11' Then Return SetError(2, 0, $SQLITE_MISUSE)
	; change dest DB pagesize if needed
    Local $tSrcDb8 = __SQLite_StringToUtf8Struct($sSrcDbName)
    If @error Then Return SetError(4, @error, 0)
    Local $tDstDb8 = __SQLite_StringToUtf8Struct($sDstDbName)
    If @error Then Return SetError(5, @error, 0)
	Local $hDstDbCon = _SQLite_Open($sDstDbFile)
    If @error Then Return SetError(6, @error, 0)
	_SQLite_SetTimeout($hSrcDbCon, 60000)
    If @error Then Return SetError(7, @error, 0)
	; is this really necessary?
	_SQLite_SetTimeout($hDstDbCon, 60000)
    If @error Then Return SetError(8, @error, 0)
	Local $row
	$RetVal = _SQLite_QuerySingleRow($hSrcDbCon, "pragma page_size;", $row)
	Local $err = @error
    If $err Then
		_SQLite_Close($hDstDbCon)
		Return SetError(9, @error, 0)
	EndIf
	Local $SrcPagesize = $row[0]
	$RetVal = _SQLite_QuerySingleRow($hDstDbCon, "pragma page_size;", $row)
	$err = @error
    If $err Then
		_SQLite_Close($hDstDbCon)
		Return SetError(10, @error, 0)
	EndIf
	Local $DstPagesize = $row[0]
	; we need to (try to) match the pagesize when the destination is :memory:
	; if not possible, the backup will fail
	If $SrcPagesize <> $DstPagesize And ($sDstDbFile = '' Or $sDstDbFile = ':memory:') Then
		$RetVal = _SQLite_QuerySingleRow($hDstDbCon, "pragma page_size = " & $SrcPagesize & ";", $row)
		$err = @error
		If $err Then
			_SQLite_Close($hDstDbCon)
			Return SetError(11, @error, 0)
		EndIf
	EndIf
	; init backup
	$RetVal = DllCall($__g_hDll_SQLite, "ptr:cdecl", "sqlite3_backup_init", _
            "ptr", $hDstDbCon, _ 				; Destination database connection
            "ptr", DllStructGetPtr($tDstDb8), _ ; UTF-8 name of destination base
            "ptr", $hSrcDbCon, _ 				; Source database connection
            "ptr", DllStructGetPtr($tSrcDb8))	; UTF-8 name of source base
	$err = @error
    If $err Then
		_SQLite_Close($hDstDbCon)
		Return SetError(12, $err, $SQLITE_MISUSE)
	EndIf
	Local $hBackup = $RetVal[0]
    If Not $hBackup Then
		$err = _SQLite_ErrCode($hDstDbCon)
		_SQLite_Close($hDstDbCon)
		Return SetError(-1, $err, 10)
	EndIf
	Local $rc
	Do
		; copy a block of pages
		$RetVal = DllCall($__g_hDll_SQLite, "int:cdecl", "sqlite3_backup_step", "ptr", $hBackup, "int", $iBlockSize)
		$err = @error
		If $err Then
			_SQLite_Close($hDstDbCon)
			Return SetError(13, $err, 0)
		EndIf
		$rc = $RetVal[0]
		$RetVal = DllCall($__g_hDll_SQLite, "int:cdecl", "sqlite3_backup_remaining", "ptr", $hBackup)
		$err = @error
		If $err Then
			_SQLite_Close($hDstDbCon)
			Return SetError(14, $err, 0)
		EndIf
		Local $iRemain = $RetVal[0]
		$RetVal = DllCall($__g_hDll_SQLite, "int:cdecl", "sqlite3_backup_pagecount", "ptr", $hBackup)
		$err = @error
		If $err Then
			_SQLite_Close($hDstDbCon)
			Return SetError(15, $err, 0)
		EndIf
		Local $iPages = $RetVal[0]
		; inform caller of progress
		If $iPages > 0 Then
			If $hProgressBar = -1 Then
				ConsoleWrite('Done ' & $iPages - $iRemain & '/' & $iPages & ' (' & Round(100 * ($iPages - $iRemain) / $iPages, 2) & '%)' & @LF)
			Else
				GUICtrlSetData($hProgressBar, 100 * ($iPages - $iRemain) / $iPages)
			EndIf
		EndIf
		If ($rc = $SQLITE_OK Or $rc = $SQLITE_BUSY Or $rc = $SQLITE_LOCKED) Then Sleep($iSleepTime)
	Until ($rc <> $SQLITE_OK And $rc <> $SQLITE_BUSY And $rc <> $SQLITE_LOCKED)
	$RetVal = DllCall($__g_hDll_SQLite, "none:cdecl", "sqlite3_backup_finish", "ptr", $hBackup)
	$err = @error
    If $err Then
		_SQLite_Close($hDstDbCon)
		Return SetError(16, $err, 0)
	EndIf
	Return $hDstDbCon
EndFunc   ;==>_SQLite_Backup
