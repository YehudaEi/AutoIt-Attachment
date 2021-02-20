#include-once

; #INDEX# ========================================================================
; Title .........: AdoSQL.au3
; AutoIt Version : 3.2
; Language ......: English
; Description ...: Some SQL stuff to use with a database using standard ADO interface
; Author ........: Chris Lambert
; Modified ......: jchd
; ================================================================================

; #VARIABLES# ====================================================================
Global $_AdoSQL_LastConnection ;  enables the use of -1 to access the last opened connection
Global $AdoSQLErr              ;  Plain text error message holder
Global $AdoSQLObjErr           ;  For COM error handler
Global $AdoSQLTimeout
Global Const $AdoSQL_OK   = 0  ;  Successful result
Global Const $AdoSQL_FAIL = 1  ;  SQL error
Global Const $AdoSQL_BUSY = 2  ;  SQL database is busy
Global Const $AdoSQL_EOF  = 3  ;  no more row in Recordset
; ==============================================================================

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_RegisterErrorHandler
; Description ...: Register COM error handler
; Syntax.........: _AdoSQL_RegisterErrorHandler($Func = "_AdoSQL_ErrFunc")
; Parameters ....: $Func      - String variable with the name of a user-defined COM error handler.
;                  Defaults to the _AdoSQL_ErrFunc()
; Return values .: On Success - Returns $AdoSQL_OK
;                  On Failure - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......: AutoIt3 V3.2 or higher
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_RegisterErrorHandler($Func = "_AdoSQL_ErrFunc")

    If ObjEvent("AutoIt.Error") = "" Then
		$AdoSQLObjErr = ObjEvent("AutoIt.Error", $Func)
		$AdoSQLErr = ""
        Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)
    Else
        $AdoSQLErr = "An Error Handler is already registered"
        Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
    EndIf

EndFunc   ;==>_AdoSQL_RegisterErrorHandler

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_UnRegisterErrorHandler()
; Description ...: Disable a registered error handler
; Syntax.........: _AdoSQL_UnRegisterErrorHandler()
; Parameters ....: None
; Return values .: On Success - Returns $AdoSQL_OK
;                  On Failure - None
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......: AutoIt3 V3.2 or higher
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_UnRegisterErrorHandler()

    $AdoSQLErr = ""
    $AdoSQLObjErr = ""
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_UnRegisterErrorHandler

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_SetTimeout()
; Description ...: Set maximum time to keep trying an SQL operation before it returns a busy status
; Syntax.........: _AdoSQL_SetTimeout($iTimeout = 10000)
; Parameters ....: $iTimeout - delay in ms. Defaults to 10000ms
; Return values .: None
; Author ........: jchd
; Modified ......:
; Remarks .......: AutoIt3 V3.2 or higher
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_SetTimeout($iTimeout = 10000)

    $AdoSQLTimeout = $iTimeout
    Return

EndFunc   ;==>_AdoSQL_SetTimeout

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_Connect
; Description ...: Starts then open a Generic ADO Database Connection
; Syntax.........: _AdoSQL_Connect($connectionString)
; Parameters ....: $connectionString  - The string used to establish connection.
; Return values .: On Success   - Returns ADODB.Connection handle. @error = $AdoSQL_OK
;                  On Failure   - @error = $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: jchd
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_Connect($connectionString)

    $AdoSQLErr = ""
    Local $oAdoCon = ObjCreate("ADODB.Connection")
    If IsObj($oAdoCon) Then
        $_AdoSQL_LastConnection = $oAdoCon
		$oAdoCon.Open($connectionString) ;<==Connect with required credentials
		If Not @error Then
			Return SetError($AdoSQL_OK, 0, $oAdoCon)
		Else
			$AdoSQLErr = "Connection error"
		EndIf
    Else
        $AdoSQLErr = "Failed to create ADODB.Connection object"
    EndIf
	Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)

EndFunc   ;==>_AdoSQL_Connect

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_Close
; Description ...: Closes an open ADODB.Connection
; Syntax.........: _AdoSQL_Close ($oAdoCon = -1)
; Parameters ....: $oAdoCon - Optional Database Handle
; Return values .: On Success   - Returns $AdoSQL_OK   @error = $AdoSQL_OK
;                  On Failure   - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_Close($oAdoCon = -1)

    $AdoSQLErr = ""
    If $oAdoCon = -1 Then $oAdoCon = $_AdoSQL_LastConnection
    If Not IsObj($oAdoCon) Then
        $AdoSQLErr = "Invalid ADODB.Connection object, use _AdoSQL_Open()"
        Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
    EndIf
    $oAdoCon.Close
    If $oAdoCon = $_AdoSQL_LastConnection Then $_AdoSQL_LastConnection = ""
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_Close

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_GetTable2d()
; Description ...: Passes Out a 2Dimensional Array Containing Tablenames and Data of Executed Query
; Syntax.........: _AdoSQL_GetTable2D($oAdoCon, $sQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)
; Parameters ....: $oAdoCon - An Open Database, Use -1 To use Last Opened Database
;                  $sQuery     - SQL Statement to be executed
;                  $aResult    - Passes out the Result
;                  $iRows      - Passes out the number of 'data' Rows
;                  $iColumns   - Passes out the number of Columns
; Return values .: On Success  - Returns $AdoSQL_OK. @error = $AdoSQL_OK
;                  On Failure  - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro) jchd (almost completely rewritten)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_GetTable2D($oAdoCon, $sQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)

	$aResult = ''
	$iRows = 0
	$iColumns = 0
    $AdoSQLErr = ""
    If $oAdoCon = -1 Then $oAdoCon = $_AdoSQL_LastConnection
    Local $AdoRs = ObjCreate("ADODB.Recordset")
	If @error Then
        $AdoSQLErr = "Failed to create ADODB.Recordset object."
		Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
	EndIf
    With $AdoRs
		.CursorType = 2
		.LockType = 3
		.Open($sQuery, $oAdoCon)
		If @error Then
			$AdoSQLErr = "Failed to open ADODB.Recordset object. Probable SQL error."
			Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
		EndIf
		If Not .EOF Then
			$aResult = .GetRows()
			$iRows = UBound($aResult, 1)
			$iColumns = UBound($aResult, 2)
			ReDim $aResult[$iRows + 1][$iColumns]
			For $i = $iRows - 1 To 0 Step -1
				For $j = 0 To $iColumns - 1
					$aResult[$i + 1][$j] = $aResult[$i][$j]
				Next
			Next
			For $i = 0 To $iColumns - 1
				$aResult[0][$i] = .Fields($i).Name
			Next
		EndIf
		.Close
    EndWith
	$AdoRs = 0
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_GetTable2D

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_GetData2d()
; Description ...: Passes Out a 2Dimensional Array Containing Data of Executed Query
; Syntax.........: _AdoSQL_GetData2D($oAdoCon, $sQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)
; Parameters ....: $oAdoCon - An Open Database, Use -1 To use Last Opened Database
;                  $sQuery     - SQL Statement to be executed
;                  $aResult    - Passes out the Result
;                  $iRows      - Passes out the number of 'data' Rows
;                  $iColumns   - Passes out the number of Columns
; Return values .: On Success  - Returns $AdoSQL_OK. @error = $AdoSQL_OK
;                  On Failure  - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: jchd (new)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_GetData2D($oAdoCon, $sQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)

	$aResult = ''
	$iRows = 0
	$iColumns = 0
    $AdoSQLErr = ""
    If $oAdoCon = -1 Then $oAdoCon = $_AdoSQL_LastConnection
    Local $AdoRs = ObjCreate("ADODB.Recordset")
	If @error Then
        $AdoSQLErr = "Failed to create ADODB.Recordset object."
		Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
	EndIf
    With $AdoRs
		.CursorType = 2
		.LockType = 3
		.Open($sQuery, $oAdoCon)
		If @error Then
			$AdoSQLErr = "Failed to open ADODB.Recordset object. Probable SQL error."
			Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
		EndIf
		If Not .EOF Then
			$aResult = .GetRows()
			$iRows = UBound($aResult, 1)
			$iColumns = UBound($aResult, 2)
		EndIf
		.Close
    EndWith
	$AdoRs = 0
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_GetData2D

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_GetTable()
; Description ...: Passes Out a 1Dimensional Array Containing Tablenames and Data of Executed Query
; Syntax.........: _AdoSQL_GetTable($oAdoCon, $sQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)
; Parameters ....: $oAdoCon    - An Open Database, Use -1 To use Last Opened Database
;                  $sQuery     - SQL Statement to be executed
;                  $aResult    - Passes out the Result
;                  $iRows      - Passes out the amount of 'data' Rows
;                  $iColumns   - Passes out the amount of Columns
; Return values .: On Success  - Returns $AdoSQL_OK. @error = $AdoSQL_OK
;                  On Failure  - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro) jchd (almost completely rewritten)
; Remarks .......: reallocates result array by 1 row at a time so it will be _slow_ on large tables
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_GetTable($oAdoCon, $sQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)

	Local Const $FieldDelim = Chr(0x1E)
	Dim $aResult[1] = [0]
	$iRows = 0
	$iColumns = 0
    $AdoSQLErr = ""
    If $oAdoCon = -1 Then $oAdoCon = $_AdoSQL_LastConnection
    Local $AdoRs = ObjCreate("ADODB.Recordset")
	If @error Then
        $AdoSQLErr = "Failed to create ADODB.Recordset object."
		Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
	EndIf
    With $AdoRs
		.CursorType = 2
		.LockType = 3
		.Open($sQuery, $oAdoCon)
		If @error Then
			$AdoSQLErr = "Failed to open ADODB.Recordset object. Probable SQL error."
			Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
		EndIf
        If Not .EOF Then
			Local $res
			$iColumns = .Fields.Count
			; Get information about Fields collection
			For $i = 0 To $iColumns - 1
				$res &= .Fields($i).Name & $FieldDelim
			Next
			$iRows = .RecordCount
			$res &= .GetString(2, $iRows, $FieldDelim, $FieldDelim, 0)
			$aResult = StringSplit(StringTrimRight($res, 1), $FieldDelim)
		EndIf
		.Close
    EndWith
	$AdoRs = 0
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_GetTable

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_QuerySingleRow()
; Description ...: Read out the first Row of the Result from the Specified query
; Syntax.........: _AdoSQL_QuerySingleRow($oAdoCon, $sSQL, ByRef $aRow)
; Parameters ....: $oAdoCon - An Open Database, Use -1 To use Last Opened Database.
;                  $sSQL       - SQL Statement to be executed.
;                  $aRow       - Array to hold return results.
; Return values .: On Success  - Returns $AdoSQL_OK. @error = $AdoSQL_OK or $AdoSQL_EOF
;                  On Failure  - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: jchd (almost completely rewritten)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_QuerySingleRow($oAdoCon, $sQuery, ByRef $aRow)

	$aRow = 0
    Local $n, $AdoRs
    $AdoSQLErr = ""
    If $oAdoCon = -1 Then $oAdoCon = $_AdoSQL_LastConnection
    $AdoRs = ObjCreate("ADODB.Recordset")
	If @error Then
        $AdoSQLErr = "Failed to create ADODB.Recordset object."
		$AdoRs = 0
		Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
	EndIf
	$AdoRs.CursorType = 2
	$AdoRs.LockType = 3
	$AdoRs.Open($sQuery, $oAdoCon)
	If @error Then
		$AdoSQLErr = "Failed to open ADODB.Recordset object. Probable SQL error."
		$AdoRs = 0
		Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
	EndIf
	$n = $AdoRs.Fields.Count
	If Not $AdoRs.EOF Then
;~ 		$aRow = $AdoRs.GetRows(1)		; semble poser problème dans le cas de retour d'une seule colonne avec (certains pilotes ?) ADO ...
		Dim $aRow[$n]
		For $i = 0 To $n - 1
            $aRow[$i] = $AdoRs.Fields($i).Value
		Next
	Else
		$AdoRs.Close
		$AdoRs = 0
		Return SetError($AdoSQL_EOF, 0, $AdoSQL_OK)
	EndIf
	$AdoRs.Close
	$AdoRs = 0
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_QuerySingleRow

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_Exec()
; Description ...: Executes an SQL Query
; Syntax.........: _AdoSQL_Exec([ $oAdoCon = -1[,$sQuery = "" ]])
; Parameters ....: $oAdoCon    - A valid Database.Connection object. Use -1 To use Last Opened Database
;                  $sQuery     - SQL Statement to be executed
; Return values .: On Success  - Returns a Recordset handle. @error = $AdoSQL_OK
;                  On Failure  - @error = $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: jchd (almost completely rewritten)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_Exec($oAdoCon = -1, $sQuery = "")

    $AdoSQLErr = ""
    If $oAdoCon = -1 Then $oAdoCon = $_AdoSQL_LastConnection
    Local $AdoRs = ObjCreate("ADODB.Recordset")
	If @error Then
        $AdoSQLErr = "Failed to create ADODB.Recordset object."
		Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
	EndIf
    With $AdoRs
		.CursorType = 2
		.LockType = 3
		.Open($sQuery, $oAdoCon)
	EndWith
    If @error Then
		$AdoSQLErr = "Failed to open ADODB.Recordset object. Probable SQL error."
        Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
    Else
        Return SetError($AdoSQL_OK, 0, $AdoRs)
    EndIf

EndFunc   ;==>_AdoSQL_Exec

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_FetchNames()
; Description ...: Read out the Tablenames of a _AdoSQL_Exec() based query
; Syntax.........: _AdoSQL_FetchNames($AdoRs, ByRef $aNames)
; Parameters ....: $AdoRs     - Recordset handle generated by _AdoSQL_Exec()
;                  $aNames    - variable to store the Table Names
; Return values .: On Success - Returns $AdoSQL_OK. @error = $AdoSQL_OK
;                  On Failure - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: jchd (almost completely rewritten)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_FetchNames($AdoRs, ByRef $aNames)

	$aNames = 0
    $AdoSQLErr = ""
    If Not IsObj($AdoRs) Then
        $AdoSQLErr = "Invalid Recordset handle"
        Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
    EndIf
	With $AdoRs
		Local $n = .Fields.Count
		Dim $aNames[$n]
		For $i = 0 To $n - 1
			$aNames[$i] = .Fields($i).Name
		Next
    EndWith
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_FetchNames

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_FetchData()
; Description ...: Fetches 1 Row of Data from an _AdoSQL_Exec() based query
; Syntax.........: _AdoSQL_FetchData($AdoRs, ByRef $aRow)
; Parameters ....: $AdoRs     - Recordset handle passed out by _AdoSQL_Exec()
;                  $aRow      - A 1 dimensional array containing a row of data
; Return values .: On Success - Returns $AdoSQL_OK. @error = $AdoSQL_OK
;                  On Failure - Returns $AdoSQL_FAIL and $AdoSQLErr is set.
;                  .Use _AdoSQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: jchd (almost completely rewritten)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_FetchData($AdoRs, ByRef $aRow)

	$aRow = 0
    $AdoSQLErr = ""
    If Not IsObj($AdoRs) Then
        $AdoSQLErr = "Invalid Recordset handle"
        Return SetError($AdoSQL_FAIL, 0, $AdoSQL_FAIL)
    EndIf
	If $AdoRs.EOF Then
		$AdoSQLErr = "End of Data Stream"
		Return SetError($AdoSQL_OK, 0, $AdoSQL_EOF)
	EndIf
	With $AdoRs
		Local $n = .Fields.Count
		Dim $aRow[$n]
		For $i = 0 To $n - 1
			$aRow[$i] = .Fields($i).Value
		Next
		.MoveNext
    EndWith
    Return SetError($AdoSQL_OK, 0, $AdoSQL_OK)

EndFunc   ;==>_AdoSQL_FetchData

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_GetErrMsg
; Description ...: Get SQL error as text
; Syntax.........: _AdoSQL_GetErrMsg()
; Parameters ....:                None
; Return values .: On Success - Returns the text string from $AdoSQLErr. @error = $AdoSQL_OK
;                  On Failure - None
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _AdoSQL_GetErrMsg()

    Local $AdoSQLErr_TMP = $AdoSQLErr
    $AdoSQLErr = ""
    Return SetError($AdoSQL_OK, 0, $AdoSQLErr_TMP)

EndFunc   ;==>_AdoSQL_GetErrMsg

; #FUNCTION# ===================================================================
; Name ..........: _AdoSQL_ErrFunc
; Description ...: Autoit Error handler function
; Syntax ........: _AdoSQL_ErrFunc()
; Parameters ....: None.
; Return values .: none: program exits
; Author ........:
; Modified.......: jchd remove useless fields
; Remarks .......: COM error handler function.
; Related .......:
; Link ..........:
; Example .......: no
; ================================================================================
Func _AdoSQL_ErrFunc()

	$AdoSQLErr = "err.description: " & $AdoSQLObjErr.description & @LF & _
				 "err.source:      " & $AdoSQLObjErr.source & @LF & _
				 "err.scriptline:  " & $AdoSQLObjErr.scriptline & @LF & _
				 "err.windescription: " & @TAB & $AdoSQLObjErr.windescription & @LF & _
				 "err.number:         " & @TAB & Hex($AdoSQLObjErr.number, 8) & @LF & _
				 "err.lastdllerror:   " & @TAB & $AdoSQLObjErr.lastdllerror
    _ByeBox($AdoSQLErr)
	; stop things there before more damage can be done

EndFunc   ;==>_AdoSQL_ErrFunc
