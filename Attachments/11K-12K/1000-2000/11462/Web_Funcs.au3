#include-once
#include<File.au3>
;===============================================================================
;
; Description:      Loads a full HTML page to screen.
; Syntax:           _LoadPage ( $Location )
; Parameter(s):     $Location = full path to the html to load.
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1 and HTML page.
;                   On Failure - Returns 0
; Author(s):        Chipped
; Note(s):			None
;
;===============================================================================
Func _LoadPage ( $Location )
	Local $html, $ret
	$ret = _FileReadToArray ( $Location, $html )
If $ret = 1 Then
	For $i = 1 To UBound ( $html ) -1 Step 1
	ConsoleWrite ( $html[$i] & @CRLF )
	Next
	Return 1
Else
	Return 0
EndIf
EndFunc ;==>_LoadPage

;===============================================================================
;
; Description:      Returns ethier a POST or GET into an array
; Syntax:           _ParseReturns ( $type )
; Parameter(s):     $clean = Enter your POST or GET to parse
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array with POST or GET
;                   On Failure - Returns 0
; Author(s):        Chipped
; Note(s):          None
;
;===============================================================================
Func _ParseReturns ( $clean )
Local $info, $i
MsgBox ( 1, "Clean", $clean )
	$info = StringSplit ( $clean, "&" )
	_ArrayDisplay ( $info, "lol" )
Local $return[$info[0]+ 1][2]
	For $i = 1 To $info[0] Step 1
$return[$i][0] = StringTrimRight ( $info[$i], StringLen ( $info[$i] ) - StringInStr ( $info[$i], "=" )+1 )
$return[$i][1] = StringTrimLeft ( $info[$i], StringLen ( $return[$i][0] ) + 1)
	Next
If IsArray ( $return ) = 0 Then
	Return 0
Else
	Return $return
EndIf
EndFunc ;==>_ParseReturns

;===============================================================================
;
; Description:      Creates an SQLite table
; Syntax:           _CreateTable ( $name, $array )
; Parameter(s):     $name = Name of the table
;					$array = An array of the columns you want added
; Requirement(s):   SQLite database loaded, SQLite.dll
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns SQLite ErrMsg and Sets Error to 1
; Author(s):        Chipped
; Note(s):          Must have a _SQLite_Open run before running this.
;
;===============================================================================
Func _CreateTable ( $name, $array )
Local $values, $ret, $i
For $i = 0 To UBound ( $array ) - 1 Step 1
	$values = $values & $array[$i] & "', '" 
Next
	$values = StringTrimRight ( $values, 3) & ");" 
	$ret = _SQLite_Exec ( -1, "CREATE TABLE " & $name & " ( '" & $values )
If $ret = $SQLite_OK Then
	Return 1
Else
	SetError (1)
	Return _SQLite_ErrMsg ()
EndIf
EndFunc ;==>_CreateTable

;===============================================================================
;
; Description:      Inserts information into a Table
; Syntax:           _InsertTable ( $name, $array )
; Parameter(s):     $name = Name of the table to put information
;					$array = An array of the information to put in
; Requirement(s):   SQLite database loaded, SQLite.dll
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns SQLite ErrMsg and Sets Error to 1
; Author(s):        Chipped
; Note(s):          Must have a _SQLite_Open run before running this.
;
;===============================================================================
Func _InsertTable ( $name, $array )
Local $values, $ret, $i
For $i = 0 To UBound ( $array )-1 Step 1
	$values = $values & $array[$i] & "', '" 
Next
	$values = StringTrimRight ( $values, 3) & ");" 
	$ret = _SQLite_Exec ( -1, "INSERT INTO " & $name & " VALUES ( '" & $values )
If $ret = $SQLite_OK Then
	Return 1
Else
	SetError (1)
	Return _SQLite_ErrMsg ()
EndIf
EndFunc ;==>_InsertTable

;===============================================================================
;
; Description:      Updates information in a Table
; Syntax:           _UpdateTable ( $name, $column, $data, $RowID = 1 )
; Parameter(s):     $name = Name of the table to update information
;					$column = Name of the column your updating
;					$data = Data you want to enter
;					$RowID = Spot where the information is. Default is 1.
; Requirement(s):   SQLite database loaded, SQLite.dll
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns SQLite ErrMsg and Sets Error to 1
; Author(s):        Chipped
; Note(s):          Must have a _SQLite_Open run before running this.
;
;===============================================================================
Func _UpdateTable ( $name, $column, $data, $RowID = 1 )
Local $ret
	$ret = _SQLite_Exec ( -1, "UPDATE " & $name & " SET '" & $column & "' = '" & $data & "' WHERE 'RowID' = '" & $RowID & "'" )
If $ret = $SQLite_OK Then
	Return 1
Else
	SetError (1)
	Return _SQLite_ErrMsg ()
EndIf
EndFunc ;==>_UpdateTable

;===============================================================================
;
; Description:      Deletes a row of information from a table.
; Syntax:          _DeleteTable ( $name, $RowID = 1 )
; Parameter(s):     $name = Name of the table that has the information you wish to delete
;					$RowID = Spot where the information is. Default is 1.
; Requirement(s):   SQLite database loaded, SQLite.dll
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns SQLite ErrMsg and Sets Error to 1
; Author(s):        Chipped
; Note(s):          Must have a _SQLite_Open run before running this.
;
;===============================================================================
Func _DeleteTable ( $name, $RowID = 1 )
Local $ret
	$ret = _SQLite_Exec ( -1, "DELETE FROM " & $name & " WHERE RowID = '" & $RowID & "';" )
If $ret = $SQLite_OK Then
	Return 1
Else
	SetError (1)
	Return _SQLite_ErrMsg ()
EndIf
EndFunc	;==>_DeleteTable

;===============================================================================
;
; Description:      Grabs information from a table.
; Syntax:           _GrabTable ( $name, $column, $RowID )
; Parameter(s):     $name = Name of the table that has the information you wish to delete
;					$column = Column in the table you want the information from. * is a wildcard.
;					$RowID = Spot where the information is. Default is 1.
; Requirement(s):   SQLite database loaded, SQLite.dll
; Return Value(s):  On Success - Returns information
;                   On Failure - Returns SQLite ErrMsg and Sets Error to 1
; Author(s):        Chipped
; Note(s):          Must have a _SQLite_Open run before running this.
;
;===============================================================================
Func _GrabTable ( $name, $column, $RowID = "" )
Local $end = "", $ret, $final, $return
If $RowID <> "" Then
	$end = " WHERE 'RowID' = '" & $RowID & "'"
EndIf
	$ret = _SQLite_Query ( -1, "SELECT " & $column & " FROM " & $name & $end, $final )
	If $ret = $SQLite_OK Then
	_SQLite_FetchData ( $final, $return )
	_SQLite_QueryFinalize ( $final )
	_SQLite_QueryReset ( $final )
	Return $return
Else
	SetError (1)
	_SQLite_QueryFinalize ( $final )
	_SQLite_QueryReset ( $final )
	Return _SQLite_ErrMsg ()
EndIf	
EndFunc ;==>_GrabTable

;===============================================================================
;
; Description:      Deletes a table from the database.
; Syntax:          _DeleteTable ( $name )
; Parameter(s):     $name = Name of the table that has the information you wish to delete
; Requirement(s):   SQLite database loaded, SQLite.dll
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns SQLite ErrMsg and Sets Error to 1
; Author(s):        Chipped
; Note(s):          Must have a _SQLite_Open run before running this.
;
;===============================================================================
Func _DropTable ( $name )
Local $ret
	$ret = _SQLite_Exec ( -1, "DROP TABLE " & $name )
If $ret = $SQLite_OK Then
	Return 1
Else
	SetError (1)
	Return _SQLite_ErrMsg ()
EndIf
EndFunc	;==>_DropTable

;===============================================================================
;
; Description:      Copys & Registers SQLite3.dll
; Syntax:           _InstallSQL ()
; Parameter(s):     None
; Requirement(s):   SQLite.dll in the Script Directory.
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
; Author(s):        Chipped
; Note(s):          None
;
;===============================================================================
Func _InstallSQL ()
If FileExists ( @WindowsDir & "/system32/SQLite3.dll" ) = 0 Then
$ret = FileMove ( @ScriptDir & "/SQLite3.dll", @WindowsDir & "/system32/SQLite3.dll" , 1) 
If $ret = 1 Then
Run ( @ComSpec & "regsvr32 sqlite3.dll" )
Return 1
Else
Return 0
EndIf
Else
Return 1
EndIf
EndFunc

;===============================================================================
;
; Description:      Opens a SQLite Database
; Syntax:           _OpenSQL ( $database )
; Parameter(s):     $config = Name of database to load
; Requirement(s):   SQLite.dll installed
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
; Author(s):        Chipped
; Note(s):          None
;
;===============================================================================
	
Func _OpenSQL ( $database )
	_SQLite_Startup ()
	_SQLite_Open ( $database )
	If @Error = 1 Then
	Return 0
Else
	Return 1
EndIf
EndFunc
