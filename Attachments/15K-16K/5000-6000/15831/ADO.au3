;===============================================================================
; Function List:
;					_adoCreateDB()
;					_adoCreateTable()
;					_adoDeleteTable()
;					_adoListTables()
;					_adoCountTables()
;					_adoAddRecord()
;					_adoUpdateRecord()
;					_adoClearTable()
;					_adoCountRecords()
;					_adoCountFields()
;					_adoListFields()
;					_adoQueryLike()
; To Do List:
;					_adoAppendField()
;					_adoDeleteRecord()
;					_adoDeleteMulti()
;					_adoStringSearch()
;					_adoNumSearch()

;===============================================================================
#include-once
Global Const $Provider = 'Microsoft.Jet.OLEDB.4.0; '
Global Const $adOpenDynamic = 2
Global Const $adOpenStatic = 3
Global Const $adLockReadOnly =1
Global Const $adLockPessimistic = 2
Global Const $adLockOptimistic = 3
Global Const $adLockBatchOptimistic = 4
Global Const $adUseClient = 3
Global Const $adSchemaTables = 20
;===============================================================================
;
; Function Name:    _adoCreateDB()
; Description:      Create a MS Access database (*.mdb) file
; Syntax:	_adoCreateDB ($adSource)
; Parameter(s):     $adSource  - The full path/filename of the database to be created
; Requirement(s):   None.
; Return Value(s):
; Author(s):        GEOSoft
; Note(s):          None.
;
;===============================================================================
;
Func _adoCreateDB ($adSource)
	If StringRight($adSource, 4) <> '.mdb' Then $adSource &= '.mdb'
	If FileExists($adSource) Then
		Local $Fe = MsgBox ( 262196, 'File Exists', 'The file ' & $adSource & ' already exists.' & @CRLF & '' & @CRLF & 'Do you want to replace the existing file?')
		If $Fe = 6 Then
			FileDelete($adSource)
		Else
			Return
		EndIf
	EndIf
	$dbObj = ObjCreate('ADOX.Catalog')
	If IsObj($dbObj) Then
		$dbObj.Create ('Provider = ' & $Provider & 'Data Source = ' & $adSource)
	Else
		MsgBox ( 262160, 'Error', 'Unable to create the requested object')
	EndIf
EndFunc    ;<===> _adoCreateDB ()

;===============================================================================
;
; Function Name:    _adoCreateTable()
; Description:      Create a table in an existing MS Access database
; Syntax:				_adoCreateTable($adSource, $adTable, $adCol)
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - The name of the table to create
;										$adCol - An array (or a '|' separated list) of column header names and field types (see notes)
; Requirement(s):   None.
; Return Value(s):  Success - Creates the table and sets @error = 0
;										Failure - Sets @error 1 -Table already exists
;										Failure Sets @Error
;											1 = unable to create connection
;											3 = table already exists
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          The field type is not case sensitive. I use upper for clarity.
;									Current types that work are; TEXT, MEMO, COUNTER, INTEGER, YESNO, DATETIME, CURRENCY and OLEOBJECT
;									The header name can NOT include spaces but must be separated from the field type with a space
;									To set a maximum number of characters in a TEXT field use (<number>) as shown in the second example
;									TEXT (0) will set the field to the maximum allowable (255 characters). In the second example Category1 is 50 characters
;										and Category4 is 255 characters.
; Example(s):		_adoCreateTable($adSource, $adTable, $aArray)
;									_adoCreateTable($adSource, $adTable, 'Category1 TEXT(50)|Category2 TEXT(100)|Category3 MEMO|Category4 TEXT')
;
;===============================================================================
;
Func _adoCreateTable($adTable, $adCol = '')
	Local $F_Out = ''
	If $adCol <> '' Then
		If NOT IsArray($adCol) Then
			$adCol = StringSplit($adCol,'|')
		EndIf
		
		For $I = 1 To $adCol[0]
			If $I <> $adCol[0] Then $adCol[$I] = $adCol[$I] & ' ,'
			$F_Out &= $adCol[$I]
		Next
	EndIf

	If IsObj($oADO) = 0 Then $oADO = _adoOpen($db)
	If IsObj($oADO) = 0 Then Return SetError(1)
	If $F_Out <> '' Then
		$oADO.Execute ("CREATE TABLE " & $adTable & '(' & $F_Out & ')');;<<=== Create the table and the columns specified by $adCol
	Else
		$oADO.Execute ("CREATE TABLE " & $adTable);;  <<==== No columns were specified so just create an empty table
	EndIf
EndFunc    ;<===> _adoCreateTable1()

;===============================================================================
;
; Function Name:    _adoListTables()
; Description:      List the tables in an MSAccess (*.mdb) file
; Syntax:	adoListTables ($adSource)
; Parameter(s):     $adSource  - The full path/filename of the database to be listed
; Requirement(s):   None.
; Return Value(s):  Success - Returns a "|" delimited string of table names
;										Failure Sets @Error
;											1 = unable to create connection
;											3 = no matching tables located (returns a blankString)
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          None.
;
;===============================================================================
;
Func _adoListTables()
	Local $oList = ''
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = $oADO.OpenSchema($adSchemaTables)
	
	While NOT $oRec.EOF
		If StringLen( $oRec("TABLE_TYPE").value) > 5 Then;; Skip the hidden internal tables
			$oRec.movenext
			ContinueLoop
		EndIf
		$oList = $oList & $oRec("TABLE_NAME").value & '|'
		$oRec.movenext
	Wend
	
	If $oList <> '' Then
		Return '|' & StringTrimRight($oList,1)
	Else
		SetError(3, 0, 0)
		Return $oList
	EndIf
EndFunc    ;<===> _adoListTables()

;===============================================================================
;
; Function Name:    _adoClearTable()
; Description:      Clear all records in an MS Access database table
; Syntax:				_adoClearTable($adSource, $adTable)
; Parameter(s):     $adSource  - The full path/filename of the database to be accessed
;										$adTable - the name of the table to clear
; Requirement(s):   None.
; Return Value(s):  Sucess - all records are removed from table
;										Failure - Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          This will only clear the records, not remove the table (see _adoDeleteTable())
;
;===============================================================================
;
Func _adoClearTable($adTable)
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	$oRec.CursorLocation = $adUseClient
	$oRec.Open ("Delete * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
EndFunc    ;<===> _adoClearTable()

;===============================================================================
;
; Function Name:    _adoDeleteTable()
; Description:      Delete a table from an MSAccess (*.mdb) file
; Syntax:	_adoDeleteTable($adSource, $adTable)
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table to be deleted
; Requirement(s):   None.
; Return Value(s):  Success - Deletes the table and returns 0
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
;
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          None.
;

;===============================================================================
;
Func _adoDeleteTable($adTable)
	$oADO.execute ("DROP TABLE " & $adTable)
EndFunc    ;<===> _adoDeleteTable()

;===============================================================================
;
; Function Name:    _adoTableCount()
; Description:      Count the tables in an MSAccess (*.mdb) file
; Syntax:	_adoTableCount($adSource)
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
; Requirement(s):   None.
; Return Value(s):  Success - returns the number of tables
;
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          None.
;
;===============================================================================
;
Func _adoTableCount()
	$T_Count = StringSplit(_adoListTables(), '|')
	Return $T_Count[0]
EndFunc    ;<===> _adoTableCount()

;===============================================================================
;
; Function Name:    _adoAddRecord()
; Description:      Add a new record (single or multiple fields) in an existing MS Access database table
; Syntax:				_adoAddRecord($adSource, $adTable)
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table to add the record to
;										$rData - Data to be added to field (to add data to multiple fields this must be an array) see notes
;										$adCol - the name or 0 based index of the field to add the data to when $rData is not an array (default is first field)
; Requirement(s):   None.
; Return Value(s):  Success - @Error = 0 and record is added to table
;										Failure - Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          None.
;
;===============================================================================
;
Func _adoAddRecord($adTable, $rData, $adCol)
	If NOT IsArray($rData) Then
		$rData = StringSplit($rData,'|')
	EndIf

	If IsObj($oADO) = 0 Then Return SetError(1)
	If Not IsObj($oADO) Then Return SetError(2, 0, 0)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	With $oRec
		.Open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
		.AddNew
		If IsArray($rData) Then
			For $I = 1 To Ubound($rData) -1;$rData[0]
				$rData[$I] = StringStripWs($rData[$I],1)
				.Fields.Item($I -1) = $rData[$I]
			Next
			
		Else
			.Fields.Item($adCol) = $rData
		EndIf
		.Update
		.Close
	EndWith
EndFunc    ;<===> _adoAddRecord()

;===============================================================================
;
; Function Name:    _adoUpdateRecord()
; Description:      Searches for a record in an MS Access database table and updates that record with new data
; Syntax:				_adoUpdateRecord($adSource,$adTable,$adCol,$adQuery,$adcCol,$adData)
; Parameter(s):     $adSource  - The full path/filename of the database to be accessed
;										$adTable - the name of the table to update
;										$adCol - The field (column) to search
;										$adQuery - the string to find
;										$adcCol - The field to update
;										$adData - the new string to be placed in $adcCol
; Requirement(s):   None.
; Return Value(s):  Success - Updates the field
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
;											3 = unable to open the record for updating
; Author(s):        GEOSoft, 2tim3_16
; Note(s):
;
;===============================================================================
;
Func _adoUpdateRecord($adTable,$adCol,$adQuery,$adcCol,$adData)
	$adQuery = Chr(39) & $adQuery & Chr(39)

	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	$oRec.CursorLocation = $adUseClient
	$oRec.Open ("UPDATE " & $adTable & " SET " & $adTable & ".[" & $adcCol & "] = '" & $adData & "' WHERE (((" & $adTable & ".[" & $adCol & "])=" & $adQuery & "))", $oADO,  $adOpenStatic, $adLockOptimistic)
	
	If @Error = 0 Then
	Else
		Return SetError(3,0,0)
	EndIf
EndFunc    ;<===> _adoUpdateRecord()

;===============================================================================
;
; Function Name:    _adoDeleteRecord()
; Description:      Searches a database for all records where the specified field contains a specified string
; Syntax:				adoDeleteRecord($adSource,$adTable, $adCol,$Find,[$adOcc])
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table to search
;										$adCol - The name of the field to search (DO NOT use the index number)
;										$Find - The string to locate
;										$adOcc - If = 1 Delete the first matching record (Default)
;										                If <> 1 Delete all matching records
; Requirement(s):   _adoCountFields()
; Return Value(s):  Success - Record(s) deleted from table
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
;; Author(s):        GEOSoft, 2tim3_16
; Note(s):          Chr(28) is a non-printable character and is used to avoid a clash with characters that may be found in the string
;
;===============================================================================
;
Func _adoDeleteRecord($adTable, $adCol,$Find,$adOcc = 1)
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	$Search = $adCol & " = '" & $Find & Chr(39)
	With $oRec
		.CursorLocation = $adUseClient
		If $adOcc = 1 Then
			.Open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
			.find($Search)
			.Delete()
			.close
		Else
			.Open("DELETE * FROM " & $adTable & " WHERE " & $adCol & " = '" & $Find & Chr(39), $oADO, $adOpenStatic, $adLockOptimistic)
		EndIf
	EndWith
EndFunc    ;<===> adoDeleteRecord()

;===============================================================================
;
; Function Name:    _adoCountRecords()
; Description:      Count the records in an MS Access database table
; Syntax:				_adoCountRecords($adSource, $adTable)
; Parameter(s):     $adSource  - The full path/filename of the database to be accessed
;										$adTable - the name of the table to count
; Requirement(s):   None.
; Return Value(s):  The number of records in the table
;										Failure - Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          Typical usage would be :
;									(MsgBox(0,'Records', 'There are ' & _adoCountRecords($adSource, $adTable) & ' in the table')
;
;===============================================================================
;
Func _adoCountRecords($adTable)
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	$oRec.open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
	If $oRec.recordcount <> 0 Then $oRec.MoveFirst
	$Rc = $oRec.recordcount
	$oRec.Close
	Return $Rc
EndFunc    ;<===> _adoCountRecords()

;===============================================================================
;
; Function Name:    _adoCountFields()
; Description:      Count the fields in an MS Access database table
; Syntax:				_adoCountFields($adSource, $adTable)
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table to count
; Requirement(s):   None.
; Return Value(s):  The number of fields in the table
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          Typical usage would be:
;									MsgBox(0,'Number of fields', 'There are ' & _adoCountFields($adSource, $adTable) & ' fields in this table')
;
;===============================================================================
;
Func _adoCountFields($adTable)
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	$oRec.open ($adTable , $oADO, $adOpenStatic, $adLockOptimistic)
	$Fc = $oRec.fields.count
	$oRec.Close
	Return $Fc
EndFunc    ;<===> _adoCountFields()

;===============================================================================
;
; Function Name:    _adoListFields()
; Description:      List the names of fields in an MS Access database table
; Syntax:				adoColNames($adSource, $adTable)
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table to check
; Requirement(s):   None.
; Return Value(s):  Success - A "|" delimited list of the field names.
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          None
;
;===============================================================================
;
Func _adoListFields($adTable)
	Local $Rtn
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	With $oRec
		.Open ($adTable , $oADO, $adOpenStatic, $adLockOptimistic)
		$Fc = .fields.count
		If $Fc > 0 Then
			
			For $I = 0 to $Fc-1
				$Rtn = $Rtn & .fields($I).name & '|'
			Next
			
		EndIf
		.Close
	EndWith

	If $Rtn Then
		Return StringTrimRight($Rtn, 1)
	EndIf
EndFunc    ;<===> _adoListFields()

;===============================================================================
;
; Function Name:    _adoQueryLike()
; Description:      Searches a database for all records where the specified field contains a specified string
; Syntax:				_adoQueryLike($adSource,$adTable, $adCol,$Find, [$adFull])
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table to search
;										$adCol - The name of the field to search (DO NOT use the index number)
;										$Find - The string to locate
;										$adFull - If = 1 Returns an array containing a Chr(28) delimited list of the records field values. (Default)
;										               If <> 1 Returns an array of the specified field values for each record.
; Requirement(s):   _adoCountFields()
; Return Value(s):  Success - An Array containing a Chr(28) delimited list of the records field values.(Default --- see $adFull above)
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          Chr(28) is a non-printable character and is used to avoid a clash with characters that may be found in the string
;
;===============================================================================
;
Func _adoQueryLike($adTable, $adCol,$Find, $adFull = 1)
	Local $I, $Rtn
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	$oRec.Open ("SELECT * FROM "& $adTable & " WHERE " & $adCol & " Like '%" & $Find & "%'", $oADO, $adOpenStatic, $adLockOptimistic)
	If $oRec.RecordCount < 1 Then
		Return SetError(1)
	Else
		SetError(0)
		$oRec.MoveFirst()
		Do
			If $adFull = 1 Then
				
				For $I = 0 To _adoCountFields($adTable)-1
					$Rtn = $Rtn & $oRec.Fields($I).Value & Chr(28);;<<====== Separate the fields with a non-printable character
				Next
				
			EndIf
			$Rtn = $Rtn & Chr(29);;<<====== Separate the records with a non-printable character
			$oRec.MoveNext()
		Until $oRec.EOF
		
		$oRec.Close()
		If $adFull = 1 Then Return StringSplit(StringTrimRight($Rtn, 2),Chr(29))
		Return StringSplit(StringTrimRight($Rtn, 1),Chr(29))
	EndIf
EndFunc    ;<===> _adoQueryLike()

;===============================================================================
;
; Function Name:    _adoSQLSelect()
; Description:      Runs a SQL Select query
; Syntax:				_adoSQLSelect($adSource, $adTable, $adCol, $adCriteria, [$adFull])
; Parameter(s):     $adSource  - The full path/filename of the database to be opened
;										$adTable - the name of the table(s) to include
;										$adCol - The name of the field(s) to include (DO NOT use the index number)
;										$adCriteria - Criteria for WHERE clause; and empty string specifies no WHERE clause.
;										$adFull - If = 1 Returns an array containing a Chr(28) delimited list of the records field values. (Default)
;										               If <> 1 Returns an array of the specified field values for each record.
; Requirement(s):   _adoCountFields()
; Return Value(s):  Success - An Array containing a Chr(28) delimited list of the records field values.(Default --- see $adFull above)
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
; Author(s):        GEOSoft, 2tim3_16
; Note(s):          Chr(28) is a non-printable character and is used to avoid a clash with characters that may be found in the string
;
;===============================================================================
;
Func _adoSQLSelect($adTable, $adCol, $adCriteria, $adFull = 1)
	Local $I, $Rtn
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	If $adCriteria = "" Then
		$adSQL = "SELECT " & $adCol & " FROM " & $adTable
	Else
		$adSQL = "SELECT " & $adCol & " FROM " & $adTable & " WHERE " & $adCriteria
	EndIf
	
	$oRec.Open ($adSQL, $oADO, $adOpenStatic, $adLockOptimistic)
	If $oRec.RecordCount < 1 Then
		Return SetError(1)
	Else
		SetError(0)
		$oRec.MoveFirst()
		Do
			If $adFull = 1 Then
				
				For $I = 0 To _adoCountFields($adTable)-1
					$Rtn = $Rtn & $oRec.Fields($I).Value & Chr(28);;<<====== Separate the fields with a non-printable character
				Next
				
			EndIf
			$Rtn = $Rtn & Chr(29);;<<====== Separate the records with a non-printable character
			$oRec.MoveNext()
		Until $oRec.EOF
		
		$oRec.Close()
		If $adFull = 1 Then Return StringSplit(StringTrimRight($Rtn, 2),Chr(29))
		Return StringSplit(StringTrimRight($Rtn, 1),Chr(29))
	EndIf
EndFunc    ;<===> _adoSQLSelect()

;===============================================================================
;
; Function Name:    _adoExecuteSQL()
; Description:      Executes a SQL Action query (Make Table, Append, Update, or Delete)
; Syntax:				_adoUpdateRecord($adSource,$adSQL)
; Parameter(s):     $adSource  - The full path/filename of the database to be accessed
;										$adSQL - the SQL string to execute
; Requirement(s):   None.
; Return Value(s):  Success - Updates the field
;										Failure Sets @Error
;											1 = unable to create connection
;											2 = unable to create recordset
;											3 = unable to open the record
; Author(s):        GEOSoft, 2tim3_16
; Note(s):
;
;===============================================================================
;
Func _adoExecuteSQL($adSQL)
	If IsObj($oADO) = 0 Then Return SetError(1)
	$oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
	If IsObj($oRec) = 0 Then Return SetError(2)
	
	$oRec.CursorLocation = $adUseClient
	$oRec.Open ($adSQL, $oADO,  $adOpenStatic, $adLockOptimistic)
	
	If @Error = 0 Then
	Else
		Return SetError(3,0,0)
	EndIf
EndFunc    ;<===> _adoExecuteSQL()

;===============================================================================
;Private Functions
;===============================================================================

Func _adoOpen($adSource)
	$oADO = ObjCreate("ADODB.Connection")
	$oADO.Provider = $Provider
	$oADO.Open ($adSource)
	Return $oADO
EndFunc    ;<===> _adoOpen()

Func _adoOpenRecordset()
	$oRec = ObjCreate("ADODB.Recordset")
	Return $oRec
EndFunc   ;<==> _adoOpenRecordset()

Func _adoClose($oADO)
	$oADO.Close()
EndFunc   ;<==> _adoClose()

;;============= End of Script ============