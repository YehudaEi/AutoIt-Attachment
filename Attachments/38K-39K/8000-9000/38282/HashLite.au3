#include-once
#include <Sqlite.au3>
#include <Crypt.au3>

#cs
	The ability to use hash fields to store data.
	Can add, delete, sort, unique, and retrieve data based on hash table
	This UDF was designed using the SQLite.au3
	  Which means:
		1.  You must have a sqlite3 dynamic library ( or include sqlitedll.au3 )
		2.  You must initiate the library, either by calling _hashlite_Initiate or _SQLite_Start()
#ce

Global Const $__gi_hashlite_MasterHashMaxArgs = 100
Global $__ga_hashlite_MasterHashMaxColumns = 100
Global $__gi_hashlite_ErrorCode = 0
Global $__gs_hashlite_ErrorFunction = ""
Global $__gs_hashlite_SQLiteErrMsg = ""
Global Enum _
	$__gi_hashlite_EnumDB = 0, _
	$__gi_hashlite_EnumDataType, _
	$__gi_hashlite_EnumColumns, _
	$__gi_hashlite_EnumCaseSensitive, _
	$__gi_hashlite_EnumNextIndex, _
	$__gi_hashlite_EnumStorageArray, _
	$__gi_hashlite_EnumLastIndex
Global $__gf_hashlite_SQLiteInitiated = False

; #Function Names#===================================================================================
;    _hashlite_AddValue()
;    _hashlite_Create()
;    _hashlite_Delete()
;    _hashlite_GetLastErrorMsg()
;    _hashlite_GetValue()
;    _hashlite_Initiate()
;    _hashlite_Sort()
;    _hashlite_TableToArray()
;    _hashlite_Unique()
; ===================================================================================================

#region standard functions hashlite
;===================================================================================================
;
; Function Name....:    _hashlite_AddValue()
; Description......:    Adds a value to the hash table
; Parameter(s).....:
;                       $a_ptr:  storage container for hash data
;                       $s_value: the value to insert based on the hash strings passed in v_hashstr's
;                       $v_hashstr(001-100) are optional for the hash lookup strings used to index the value
; Return Value(s)..:
;                       Success...:  1
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    1 - Invalid hash ptr/array
;                                    2 - Invalid number of hash parameters sent
;                                    3 - Hash fields passed in function call cannot be empty
;                                    4 - Error executing sqlite statement, see
;                                          _hashlite_GetLastErrorMsg() for more details
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_AddValue(ByRef $a_ptr, $s_value, _
	$v_hashstr001 = "", $v_hashstr002 = "", $v_hashstr003 = "", $v_hashstr004 = "", $v_hashstr005 = "", _
	$v_hashstr006 = "", $v_hashstr007 = "", $v_hashstr008 = "", $v_hashstr009 = "", $v_hashstr010 = "", _
	$v_hashstr011 = "", $v_hashstr012 = "", $v_hashstr013 = "", $v_hashstr014 = "", $v_hashstr015 = "", _
	$v_hashstr016 = "", $v_hashstr017 = "", $v_hashstr018 = "", $v_hashstr019 = "", $v_hashstr020 = "", _
	$v_hashstr021 = "", $v_hashstr022 = "", $v_hashstr023 = "", $v_hashstr024 = "", $v_hashstr025 = "", _
	$v_hashstr026 = "", $v_hashstr027 = "", $v_hashstr028 = "", $v_hashstr029 = "", $v_hashstr030 = "", _
	$v_hashstr031 = "", $v_hashstr032 = "", $v_hashstr033 = "", $v_hashstr034 = "", $v_hashstr035 = "", _
	$v_hashstr036 = "", $v_hashstr037 = "", $v_hashstr038 = "", $v_hashstr039 = "", $v_hashstr040 = "", _
	$v_hashstr041 = "", $v_hashstr042 = "", $v_hashstr043 = "", $v_hashstr044 = "", $v_hashstr045 = "", _
	$v_hashstr046 = "", $v_hashstr047 = "", $v_hashstr048 = "", $v_hashstr049 = "", $v_hashstr050 = "", _
	$v_hashstr051 = "", $v_hashstr052 = "", $v_hashstr053 = "", $v_hashstr054 = "", $v_hashstr055 = "", _
	$v_hashstr056 = "", $v_hashstr057 = "", $v_hashstr058 = "", $v_hashstr059 = "", $v_hashstr060 = "", _
	$v_hashstr061 = "", $v_hashstr062 = "", $v_hashstr063 = "", $v_hashstr064 = "", $v_hashstr065 = "", _
	$v_hashstr066 = "", $v_hashstr067 = "", $v_hashstr068 = "", $v_hashstr069 = "", $v_hashstr070 = "", _
	$v_hashstr071 = "", $v_hashstr072 = "", $v_hashstr073 = "", $v_hashstr074 = "", $v_hashstr075 = "", _
	$v_hashstr076 = "", $v_hashstr077 = "", $v_hashstr078 = "", $v_hashstr079 = "", $v_hashstr080 = "", _
	$v_hashstr081 = "", $v_hashstr082 = "", $v_hashstr083 = "", $v_hashstr084 = "", $v_hashstr085 = "", _
	$v_hashstr086 = "", $v_hashstr087 = "", $v_hashstr088 = "", $v_hashstr089 = "", $v_hashstr090 = "", _
	$v_hashstr091 = "", $v_hashstr092 = "", $v_hashstr093 = "", $v_hashstr094 = "", $v_hashstr095 = "", _
	$v_hashstr096 = "", $v_hashstr097 = "", $v_hashstr098 = "", $v_hashstr099 = "", $v_hashstr100 = "")

	#forceref $v_hashstr001, $v_hashstr002, $v_hashstr003, $v_hashstr004, $v_hashstr005
	#forceref $v_hashstr006, $v_hashstr007, $v_hashstr008, $v_hashstr009, $v_hashstr010
	#forceref $v_hashstr011, $v_hashstr012, $v_hashstr013, $v_hashstr014, $v_hashstr015
	#forceref $v_hashstr016, $v_hashstr017, $v_hashstr018, $v_hashstr019, $v_hashstr020
	#forceref $v_hashstr021, $v_hashstr022, $v_hashstr023, $v_hashstr024, $v_hashstr025
	#forceref $v_hashstr026, $v_hashstr027, $v_hashstr028, $v_hashstr029, $v_hashstr030
	#forceref $v_hashstr031, $v_hashstr032, $v_hashstr033, $v_hashstr034, $v_hashstr035
	#forceref $v_hashstr036, $v_hashstr037, $v_hashstr038, $v_hashstr039, $v_hashstr040
	#forceref $v_hashstr041, $v_hashstr042, $v_hashstr043, $v_hashstr044, $v_hashstr045
	#forceref $v_hashstr046, $v_hashstr047, $v_hashstr048, $v_hashstr049, $v_hashstr050
	#forceref $v_hashstr051, $v_hashstr052, $v_hashstr053, $v_hashstr054, $v_hashstr055
	#forceref $v_hashstr056, $v_hashstr057, $v_hashstr058, $v_hashstr059, $v_hashstr060
	#forceref $v_hashstr061, $v_hashstr062, $v_hashstr063, $v_hashstr064, $v_hashstr065
	#forceref $v_hashstr066, $v_hashstr067, $v_hashstr068, $v_hashstr069, $v_hashstr070
	#forceref $v_hashstr071, $v_hashstr072, $v_hashstr073, $v_hashstr074, $v_hashstr075
	#forceref $v_hashstr076, $v_hashstr077, $v_hashstr078, $v_hashstr079, $v_hashstr080
	#forceref $v_hashstr081, $v_hashstr082, $v_hashstr083, $v_hashstr084, $v_hashstr085
	#forceref $v_hashstr086, $v_hashstr087, $v_hashstr088, $v_hashstr089, $v_hashstr090
	#forceref $v_hashstr091, $v_hashstr092, $v_hashstr093, $v_hashstr094, $v_hashstr095
	#forceref $v_hashstr096, $v_hashstr097, $v_hashstr098, $v_hashstr099, $v_hashstr100

	__hashlite_SetErrorCode()

	Local $i_ptrub = UBound($a_ptr)
	If $i_ptrub < $__gi_hashlite_EnumLastIndex Then
		__hashlite_SetErrorCode(-2, "_hashlite_AddValue", "Invalid Hash Ptr.")
		Return SetError(1, 0, 0)
	EndIf

	Local $h_db = $a_ptr[$__gi_hashlite_EnumDB]
	Local $i_params = @NumParams
	Local $i_columns = $a_ptr[$__gi_hashlite_EnumColumns]
	Local $i_nxt = $a_ptr[$__gi_hashlite_EnumNextIndex]

	If $i_params - 2 <>  $i_columns Then
		__hashlite_SetErrorCode(-2, "_hashlite_AddValue", _
			"Invalid number of parameters: Sent -> " & $i_params & ", Requires " & $i_columns + 2)
		Return SetError(2, 0, 0)
	EndIf
	$i_params -= 2

	Local $s_add2hash = Chr(1) & "__hashlite__" & Chr(1)
	Local $f_casesensitive = $a_ptr[$__gi_hashlite_EnumCaseSensitive]
	Local $s_hashdata = "", $s_pval
	For $i = 0 To $i_params - 1
		$s_pval = Eval("v_hashstr" & StringFormat("%03d", $i + 1))
		If StringLen($s_pval) > 0 Then
			If Not $f_casesensitive Then $s_pval = StringLower($s_pval)
			$s_hashdata &= $s_add2hash & $s_pval & $s_add2hash
		Else
			__hashlite_SetErrorCode(-2, "_hashlite_AddValue", "Column values cannot be blank.")
			Return SetError(3, 0, 0)
		EndIf
	Next
	$s_hashdata = _Crypt_HashData($s_hashdata, $CALG_MD5)

	; see if this already exist
	Local $h_query, $a_r
	_SQLite_Query($h_db, "SELECT argindex FROM array WHERE hash = '" & $s_hashdata & "';", $h_query)
	Local $f_founddata = _SQLite_FetchData($h_query, $a_r) = $SQLITE_OK
	_SQLite_QueryFinalize($h_query)
	Local $i_deletefromarg = -1
	If $f_founddata Then $i_deletefromarg = $a_r[0]

	Local $a_storage = $a_ptr[$__gi_hashlite_EnumStorageArray]
	#forceref $a_storage

	Local $s_query = "", $f_toarray = False
	Local $s_vartype = VarGetType($s_value)
	Switch $s_vartype
		Case "Int32", "Int64"
			If $f_founddata Then
				$s_query = "UPDATE array SET argindex = " & $i_deletefromarg & _
					", datatype = '" & $s_vartype & "', datvalue = " & $s_value & " " & _
					"WHERE hash = '" & $s_hashdata & "';"
				; no longer using array to store data
				If Int($i_deletefromarg) > -1 Then
					$a_storage[$i_deletefromarg] = $s_add2hash & "deleted" & $s_add2hash
				EndIf
			Else
				$s_query = "UPDATE array SET argindex = -1" & _
					", datatype = '" & $s_vartype & "', datvalue = " & $s_value & " " & _
					"WHERE hash = '" & $s_hashdata & "';"
				$s_query &= "INSERT OR IGNORE INTO array VALUES(-1,'" & $s_vartype & "','" & _
					$s_hashdata & "'," & $s_value & ");"
			EndIf
		Case "Double", "String"
			If $f_founddata Then
				$s_query = "UPDATE array SET argindex = " & $i_deletefromarg & _
					", datatype = '" & $s_vartype & "', datvalue = '" & _
					StringReplace($s_value, "'", "''", 0, 1) & "' " & _
					"WHERE hash = '" & $s_hashdata & "';"
				; no longer using array to store data
				If Int($i_deletefromarg) > -1 Then
					$a_storage[$i_deletefromarg] = $s_add2hash & "deleted" & $s_add2hash
				EndIf
			Else
				$s_query = "UPDATE array SET argindex = -1" & _
					", datatype = '" & $s_vartype & "', datvalue = '" & _
					StringReplace($s_value, "'", "''", 0, 1) & "' " & _
					"WHERE hash = '" & $s_hashdata & "';"
				$s_query &= "INSERT OR IGNORE INTO array VALUES(-1,'" & $s_vartype & "','" & _
					$s_hashdata & "','" & StringReplace($s_value, "'", "''", 0, 1) & "');"
			EndIf
		Case Else
			If $f_founddata Then
				$s_query = "UPDATE array SET argindex = " & $i_nxt & _
					", datatype = '" & $s_vartype & "', datvalue = NULL " & _
					"WHERE hash = '" & $s_hashdata & "';"
			Else
				$s_query = "UPDATE array SET argindex = " & $i_nxt & _
					", datatype = '" & $s_vartype & "', datvalue = NULL " & _
					"WHERE hash = '" & $s_hashdata & "';"
				$s_query &= "INSERT OR IGNORE INTO array VALUES(" & $i_nxt & ",'" & $s_vartype & "','" & _
				$s_hashdata & "',NULL);"
			EndIf
			$f_toarray = True
	EndSwitch

	If _SQLite_Exec($h_db, "BEGIN;" & $s_query & "COMMIT;") <> $SQLITE_OK Then
		__hashlite_SetErrorCode(-1, "_hashlite_AddValue", _SQLite_ErrMsg($h_db))
		Return SetError(4, 0, 0)
	EndIf

	If $f_toarray Then __hashlite_AddValue($a_ptr, $s_value)

	Return 1
EndFunc   ;==>_hashlite_AddValue

;===================================================================================================
;
; Function Name....:    _hashlite_Create()
; Description......:    Creates the database hash table
; Parameter(s).....:
;                       $i_columns:  default is 1 field, how many fields you'll use for the
;                                      hash table ( not counting the data values )
;                       $i_datatype:  default is anything other than 1 or 2, it is TEXT for
;                                      the sqlite table, 1 is integer, 2 is number/float/double
;                       $f_casesensitive:  Default is not sensitive, determines if lookup
;                                            hash strings are to be case sensitive or not
; Return Value(s)..:
;                       Success...:  The ptr/array housing hash table data needed for funcs
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    -1- SQLite dll is not initiated
;                                    1 - Error opening SQLite memory database
;                                    2 - Exceeded max number of hash fields allowed
;                                    3 - Error executing sqlite exec statement for creating db,
;                                          see _hashlite_GetLastErrorMsg() for string message
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_Create($i_columns = 1, $i_datatype = -1, $f_casesensitive = False)

	__hashlite_SetErrorCode()

	__hashlite_SQLiteIsInitiated()
	If @error Then
		__hashlite_SetErrorCode(1, "_hashlite_Create")
		Return SetError(-1, 0, 0)
	EndIf

	Local $h_db = _SQLite_Open(":memory:")
	If $h_db < 1 Then Return SetError(1, 0, 0)

	If Int($i_columns) < 1 Then $i_columns = 1
	If $i_columns > $__ga_hashlite_MasterHashMaxColumns Then
		__hashlite_SetErrorCode(-2, "_hashlite_Create", "Max number of columns is " & $__ga_hashlite_MasterHashMaxColumns)
		Return SetError(2, 0, 0)
	EndIf

	Local $s_datatype = "TEXT"
	Switch Int($i_datatype)
		Case 1
			$s_datatype = "INTEGER"
		Case 2
			$s_datatype = "REAL"
	EndSwitch

	If $f_casesensitive = Default Or (IsInt($f_casesensitive) And Int($f_casesensitive = -1)) Then
		$f_casesensitive = False
	EndIf

	Local $s_casesensitvie = ""
	If $f_casesensitive Then $s_casesensitvie = " NO COLLATE"

	Local $s_create = "CREATE TABLE array ("
	$s_create &= "argindex INTEGER NOT NULL DEFAULT -1, datatype TEXT, hash TEXT UNIQUE, "
	$s_create &= "datvalue " & $s_datatype & " " & $s_casesensitvie & ");"
	If _SQLite_Exec($h_db, "BEGIN;" & $s_create & "COMMIT;") <> $SQLITE_OK Then
		__hashlite_SetErrorCode(-1, "_hashlite_Create", _SQLite_ErrMsg($h_db))
		_SQLite_Close($h_db)
		Return SetError(3, 0, 0)
	EndIf

	Local $a_ptrstorage[$__gi_hashlite_MasterHashMaxArgs]
	Local $a_data[$__gi_hashlite_EnumLastIndex]
		$a_data[$__gi_hashlite_EnumDB] = $h_db
		$a_data[$__gi_hashlite_EnumDataType] = $s_datatype
		$a_data[$__gi_hashlite_EnumColumns] = $i_columns
		$a_data[$__gi_hashlite_EnumCaseSensitive] = $f_casesensitive
		$a_data[$__gi_hashlite_EnumNextIndex] = 0
		$a_data[$__gi_hashlite_EnumStorageArray] = $a_ptrstorage

	Return $a_data
EndFunc   ;==>_hashlite_Create

;===================================================================================================
;
; Function Name....:    _hashlite_Delete()
; Description......:    Deletes a value based on hash params sent from hash table
; Parameter(s).....:
;                       $a_ptr:  storage container for hash data
;                       $v_hashstr(001-100) are optional for the hash lookup strings used to index the value
;                       	If no values are passed, the entire hash table is destroyed
; Return Value(s)..:
;                       Success...:  1
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    1 - Invalid hash ptr/array
;                                    2 - Invalid number of hash parameters sent
;                                    3 - Error executing sqlite exec statement, see _hashlite_GetLastErrorMsg() for string message
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_Delete(ByRef $a_ptr, _
	$v_hashstr001 = "", $v_hashstr002 = "", $v_hashstr003 = "", $v_hashstr004 = "", $v_hashstr005 = "", _
	$v_hashstr006 = "", $v_hashstr007 = "", $v_hashstr008 = "", $v_hashstr009 = "", $v_hashstr010 = "", _
	$v_hashstr011 = "", $v_hashstr012 = "", $v_hashstr013 = "", $v_hashstr014 = "", $v_hashstr015 = "", _
	$v_hashstr016 = "", $v_hashstr017 = "", $v_hashstr018 = "", $v_hashstr019 = "", $v_hashstr020 = "", _
	$v_hashstr021 = "", $v_hashstr022 = "", $v_hashstr023 = "", $v_hashstr024 = "", $v_hashstr025 = "", _
	$v_hashstr026 = "", $v_hashstr027 = "", $v_hashstr028 = "", $v_hashstr029 = "", $v_hashstr030 = "", _
	$v_hashstr031 = "", $v_hashstr032 = "", $v_hashstr033 = "", $v_hashstr034 = "", $v_hashstr035 = "", _
	$v_hashstr036 = "", $v_hashstr037 = "", $v_hashstr038 = "", $v_hashstr039 = "", $v_hashstr040 = "", _
	$v_hashstr041 = "", $v_hashstr042 = "", $v_hashstr043 = "", $v_hashstr044 = "", $v_hashstr045 = "", _
	$v_hashstr046 = "", $v_hashstr047 = "", $v_hashstr048 = "", $v_hashstr049 = "", $v_hashstr050 = "", _
	$v_hashstr051 = "", $v_hashstr052 = "", $v_hashstr053 = "", $v_hashstr054 = "", $v_hashstr055 = "", _
	$v_hashstr056 = "", $v_hashstr057 = "", $v_hashstr058 = "", $v_hashstr059 = "", $v_hashstr060 = "", _
	$v_hashstr061 = "", $v_hashstr062 = "", $v_hashstr063 = "", $v_hashstr064 = "", $v_hashstr065 = "", _
	$v_hashstr066 = "", $v_hashstr067 = "", $v_hashstr068 = "", $v_hashstr069 = "", $v_hashstr070 = "", _
	$v_hashstr071 = "", $v_hashstr072 = "", $v_hashstr073 = "", $v_hashstr074 = "", $v_hashstr075 = "", _
	$v_hashstr076 = "", $v_hashstr077 = "", $v_hashstr078 = "", $v_hashstr079 = "", $v_hashstr080 = "", _
	$v_hashstr081 = "", $v_hashstr082 = "", $v_hashstr083 = "", $v_hashstr084 = "", $v_hashstr085 = "", _
	$v_hashstr086 = "", $v_hashstr087 = "", $v_hashstr088 = "", $v_hashstr089 = "", $v_hashstr090 = "", _
	$v_hashstr091 = "", $v_hashstr092 = "", $v_hashstr093 = "", $v_hashstr094 = "", $v_hashstr095 = "", _
	$v_hashstr096 = "", $v_hashstr097 = "", $v_hashstr098 = "", $v_hashstr099 = "", $v_hashstr100 = "")

	#forceref $v_hashstr001, $v_hashstr002, $v_hashstr003, $v_hashstr004, $v_hashstr005
	#forceref $v_hashstr006, $v_hashstr007, $v_hashstr008, $v_hashstr009, $v_hashstr010
	#forceref $v_hashstr011, $v_hashstr012, $v_hashstr013, $v_hashstr014, $v_hashstr015
	#forceref $v_hashstr016, $v_hashstr017, $v_hashstr018, $v_hashstr019, $v_hashstr020
	#forceref $v_hashstr021, $v_hashstr022, $v_hashstr023, $v_hashstr024, $v_hashstr025
	#forceref $v_hashstr026, $v_hashstr027, $v_hashstr028, $v_hashstr029, $v_hashstr030
	#forceref $v_hashstr031, $v_hashstr032, $v_hashstr033, $v_hashstr034, $v_hashstr035
	#forceref $v_hashstr036, $v_hashstr037, $v_hashstr038, $v_hashstr039, $v_hashstr040
	#forceref $v_hashstr041, $v_hashstr042, $v_hashstr043, $v_hashstr044, $v_hashstr045
	#forceref $v_hashstr046, $v_hashstr047, $v_hashstr048, $v_hashstr049, $v_hashstr050
	#forceref $v_hashstr051, $v_hashstr052, $v_hashstr053, $v_hashstr054, $v_hashstr055
	#forceref $v_hashstr056, $v_hashstr057, $v_hashstr058, $v_hashstr059, $v_hashstr060
	#forceref $v_hashstr061, $v_hashstr062, $v_hashstr063, $v_hashstr064, $v_hashstr065
	#forceref $v_hashstr066, $v_hashstr067, $v_hashstr068, $v_hashstr069, $v_hashstr070
	#forceref $v_hashstr071, $v_hashstr072, $v_hashstr073, $v_hashstr074, $v_hashstr075
	#forceref $v_hashstr076, $v_hashstr077, $v_hashstr078, $v_hashstr079, $v_hashstr080
	#forceref $v_hashstr081, $v_hashstr082, $v_hashstr083, $v_hashstr084, $v_hashstr085
	#forceref $v_hashstr086, $v_hashstr087, $v_hashstr088, $v_hashstr089, $v_hashstr090
	#forceref $v_hashstr091, $v_hashstr092, $v_hashstr093, $v_hashstr094, $v_hashstr095
	#forceref $v_hashstr096, $v_hashstr097, $v_hashstr098, $v_hashstr099, $v_hashstr100

	__hashlite_SetErrorCode()

	Local $i_ptrub = UBound($a_ptr)
	If $i_ptrub < $__gi_hashlite_EnumLastIndex Then
		__hashlite_SetErrorCode(-2, "_hashlite_Delete", "Invalid Hash Ptr.")
		Return SetError(1, 0, 0)
	EndIf

	Local $h_db = $a_ptr[$__gi_hashlite_EnumDB]
	Local $i_params = @NumParams
	Local $i_columns = $a_ptr[$__gi_hashlite_EnumColumns]
	Local $f_casesensitive = $a_ptr[$__gi_hashlite_EnumCaseSensitive]

	If $i_params = 1 Then
		; delete entire hash table and arrays
		_SQLite_Close($h_db)
		$a_ptr = 0
		Return 1
	EndIf

	If $i_params - 1 <>  $i_columns Then
		__hashlite_SetErrorCode(-2, "_hashlite_Delete", _
			"Invalid number of parameters: Sent -> " & $i_params & ", Requires " & $i_columns + 1)
		Return SetError(2, 0, 0)
	EndIf
	$i_params -= 1

	Local $s_add2hash = Chr(1) & "__hashlite__" & Chr(1)
	Local $s_hashlookup = "", $s_pval = ""
	For $i = 0 To $i_params - 1
		$s_pval = Eval("v_hashstr" & StringFormat("%03d", $i + 1))
		If Not $f_casesensitive Then $s_pval = StringLower($s_pval)
		$s_hashlookup &= $s_add2hash & $s_pval & $s_add2hash
	Next
	$s_hashlookup = _Crypt_HashData($s_hashlookup, $CALG_MD5)

	Local $s_find = "SELECT argindex FROM array "
	$s_find &= "WHERE argindex > -1 AND hash = '" & $s_hashlookup & "' LIMIT 1;"

	Local $h_query, $a_ret
	_SQLite_Query($h_db, $s_find, $h_query)
	Local $f_fetch = _SQLite_FetchData($h_query, $a_ret) = $SQLITE_OK
	_SQLite_QueryFinalize($h_query)

	; null the data out of the sqlite db
	Local $s_delete = "BEGIN;DELETE FROM array WHERE hash = '" & $s_hashlookup & "';COMMIT;"
	If _SQLite_Exec($h_db, $s_delete) <> $SQLITE_OK Then
		; could not find value to delete
		__hashlite_SetErrorCode(-2, "_hashlite_Delete", _SQLite_ErrMsg())
		Return SetError(3, 0, 0)
	EndIf

	If Not $f_fetch Then Return 1

	Local $a_storage = $a_ptr[$__gi_hashlite_EnumStorageArray]
	$a_storage[$a_ret[0]] = ""

	$a_ptr[$__gi_hashlite_EnumStorageArray] = $a_storage

	Return 1
EndFunc   ;==>_hashlite_Delete

;===================================================================================================
;
; Function Name....:    _hashlite_GetLastErrorMsg()
; Description......:    Last error message when error happens
; Parameter(s).....:    none
; Return Value(s)..:    none
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_GetLastErrorMsg()

	Switch $__gi_hashlite_ErrorCode
		Case -1
			Return "Function: " & $__gs_hashlite_ErrorFunction & _
				": " & $__gs_hashlite_SQLiteErrMsg
		Case 0
			Return "No Error."
		Case 1
			Return "Function: " & $__gs_hashlite_ErrorFunction & _
				": No instance of the sqlite dynamic library was found running."
		Case Else
			If $__gs_hashlite_SQLiteErrMsg <> "" Then
				Return "Function: " & $__gs_hashlite_ErrorFunction & _
					": " & $__gs_hashlite_SQLiteErrMsg
			EndIf
			Return "Function: " & $__gs_hashlite_ErrorFunction & _
				": Unknown Error."
	EndSwitch
EndFunc   ;==>_hashlite_GetLastErrorMsg

;===================================================================================================
;
; Function Name....:    _hashlite_GetValue()
; Description......:   Retrieves a value based on hash params passed in function call
; Parameter(s).....:
;                       $a_ptr:  storage container for hash data
;                       $v_hashstr(001-100) are optional for the hash lookup strings used to
;                         index the value
; Return Value(s)..:
;                       Success...:  The value retrieved from hash params sent
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    1 - Invalid hash ptr/array
;                                    2 - Invalid number of hash parameters sent
;                                    3 - Empty hash parameters sent
;                                    4 - Hash parameters sent were not found
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_GetValue(ByRef $a_ptr, _
	$v_hashstr001 = "", $v_hashstr002 = "", $v_hashstr003 = "", $v_hashstr004 = "", $v_hashstr005 = "", _
	$v_hashstr006 = "", $v_hashstr007 = "", $v_hashstr008 = "", $v_hashstr009 = "", $v_hashstr010 = "", _
	$v_hashstr011 = "", $v_hashstr012 = "", $v_hashstr013 = "", $v_hashstr014 = "", $v_hashstr015 = "", _
	$v_hashstr016 = "", $v_hashstr017 = "", $v_hashstr018 = "", $v_hashstr019 = "", $v_hashstr020 = "", _
	$v_hashstr021 = "", $v_hashstr022 = "", $v_hashstr023 = "", $v_hashstr024 = "", $v_hashstr025 = "", _
	$v_hashstr026 = "", $v_hashstr027 = "", $v_hashstr028 = "", $v_hashstr029 = "", $v_hashstr030 = "", _
	$v_hashstr031 = "", $v_hashstr032 = "", $v_hashstr033 = "", $v_hashstr034 = "", $v_hashstr035 = "", _
	$v_hashstr036 = "", $v_hashstr037 = "", $v_hashstr038 = "", $v_hashstr039 = "", $v_hashstr040 = "", _
	$v_hashstr041 = "", $v_hashstr042 = "", $v_hashstr043 = "", $v_hashstr044 = "", $v_hashstr045 = "", _
	$v_hashstr046 = "", $v_hashstr047 = "", $v_hashstr048 = "", $v_hashstr049 = "", $v_hashstr050 = "", _
	$v_hashstr051 = "", $v_hashstr052 = "", $v_hashstr053 = "", $v_hashstr054 = "", $v_hashstr055 = "", _
	$v_hashstr056 = "", $v_hashstr057 = "", $v_hashstr058 = "", $v_hashstr059 = "", $v_hashstr060 = "", _
	$v_hashstr061 = "", $v_hashstr062 = "", $v_hashstr063 = "", $v_hashstr064 = "", $v_hashstr065 = "", _
	$v_hashstr066 = "", $v_hashstr067 = "", $v_hashstr068 = "", $v_hashstr069 = "", $v_hashstr070 = "", _
	$v_hashstr071 = "", $v_hashstr072 = "", $v_hashstr073 = "", $v_hashstr074 = "", $v_hashstr075 = "", _
	$v_hashstr076 = "", $v_hashstr077 = "", $v_hashstr078 = "", $v_hashstr079 = "", $v_hashstr080 = "", _
	$v_hashstr081 = "", $v_hashstr082 = "", $v_hashstr083 = "", $v_hashstr084 = "", $v_hashstr085 = "", _
	$v_hashstr086 = "", $v_hashstr087 = "", $v_hashstr088 = "", $v_hashstr089 = "", $v_hashstr090 = "", _
	$v_hashstr091 = "", $v_hashstr092 = "", $v_hashstr093 = "", $v_hashstr094 = "", $v_hashstr095 = "", _
	$v_hashstr096 = "", $v_hashstr097 = "", $v_hashstr098 = "", $v_hashstr099 = "", $v_hashstr100 = "")

	#forceref $v_hashstr001, $v_hashstr002, $v_hashstr003, $v_hashstr004, $v_hashstr005
	#forceref $v_hashstr006, $v_hashstr007, $v_hashstr008, $v_hashstr009, $v_hashstr010
	#forceref $v_hashstr011, $v_hashstr012, $v_hashstr013, $v_hashstr014, $v_hashstr015
	#forceref $v_hashstr016, $v_hashstr017, $v_hashstr018, $v_hashstr019, $v_hashstr020
	#forceref $v_hashstr021, $v_hashstr022, $v_hashstr023, $v_hashstr024, $v_hashstr025
	#forceref $v_hashstr026, $v_hashstr027, $v_hashstr028, $v_hashstr029, $v_hashstr030
	#forceref $v_hashstr031, $v_hashstr032, $v_hashstr033, $v_hashstr034, $v_hashstr035
	#forceref $v_hashstr036, $v_hashstr037, $v_hashstr038, $v_hashstr039, $v_hashstr040
	#forceref $v_hashstr041, $v_hashstr042, $v_hashstr043, $v_hashstr044, $v_hashstr045
	#forceref $v_hashstr046, $v_hashstr047, $v_hashstr048, $v_hashstr049, $v_hashstr050
	#forceref $v_hashstr051, $v_hashstr052, $v_hashstr053, $v_hashstr054, $v_hashstr055
	#forceref $v_hashstr056, $v_hashstr057, $v_hashstr058, $v_hashstr059, $v_hashstr060
	#forceref $v_hashstr061, $v_hashstr062, $v_hashstr063, $v_hashstr064, $v_hashstr065
	#forceref $v_hashstr066, $v_hashstr067, $v_hashstr068, $v_hashstr069, $v_hashstr070
	#forceref $v_hashstr071, $v_hashstr072, $v_hashstr073, $v_hashstr074, $v_hashstr075
	#forceref $v_hashstr076, $v_hashstr077, $v_hashstr078, $v_hashstr079, $v_hashstr080
	#forceref $v_hashstr081, $v_hashstr082, $v_hashstr083, $v_hashstr084, $v_hashstr085
	#forceref $v_hashstr086, $v_hashstr087, $v_hashstr088, $v_hashstr089, $v_hashstr090
	#forceref $v_hashstr091, $v_hashstr092, $v_hashstr093, $v_hashstr094, $v_hashstr095
	#forceref $v_hashstr096, $v_hashstr097, $v_hashstr098, $v_hashstr099, $v_hashstr100

	__hashlite_SetErrorCode()

	Local $i_ptrub = UBound($a_ptr)
	If $i_ptrub < $__gi_hashlite_EnumLastIndex Then
		__hashlite_SetErrorCode(-2, "_hashlite_GetValue", "Invalid Hash Ptr.")
		Return SetError(1, 0, 0)
	EndIf

	Local $h_db = $a_ptr[$__gi_hashlite_EnumDB]
	Local $i_params = @NumParams
	Local $i_columns = $a_ptr[$__gi_hashlite_EnumColumns]

	If $i_params - 1 <>  $i_columns Then
		__hashlite_SetErrorCode(-2, "_hashlite_GetValue", _
			"Invalid number of parameters: Sent -> " & $i_params & ", Requires " & $i_columns + 1)
		Return SetError(2, 0, 0)
	EndIf
	$i_params -= 1

	Local $f_casesensitive = $a_ptr[$__gi_hashlite_EnumCaseSensitive]
	Local $s_hashlookup = "", $s_pval
	Local $s_add2hash = Chr(1) & "__hashlite__" & Chr(1)
	For $i = 0 To $i_params - 1
		$s_pval = Eval("v_hashstr" & StringFormat("%03d", $i + 1))
		If Not $f_casesensitive Then $s_pval = StringLower($s_pval)
		If StringLen($s_pval) > 0 Then
			$s_hashlookup &= $s_add2hash & $s_pval & $s_add2hash
		Else
			__hashlite_SetErrorCode(-2, "_hashlite_GetValue", "Column values cannot be blank.")
			Return SetError(3, 0, 0)
		EndIf
	Next
	$s_hashlookup = _Crypt_HashData($s_hashlookup, $CALG_MD5)

	Local $s_query = "SELECT argindex,datatype,datvalue FROM array "
	$s_query &= "WHERE hash = '" & $s_hashlookup & "' LIMIT 1;"

	Local $h_query, $a_ret
	_SQLite_Query($h_db, $s_query, $h_query)
	Local $f_fetch = _SQLite_FetchData($h_query, $a_ret) = $SQLITE_OK
	_SQLite_QueryFinalize($h_query)

	If Not $f_fetch Then
		; no value for hash strings passed was in the db
		; sort of like an array bounds issue
		__hashlite_SetErrorCode(-2, "_hashlite_GetValue", _
			"One or more of the column(s) passed did match those in the hash table.")
		Return SetError(4, 0, 0)
	EndIf

	Local $a_storage
	If $a_ret[0] <> "-1" Then
		$a_storage = $a_ptr[$__gi_hashlite_EnumStorageArray]
		Return $a_storage[$a_ret[0]]
	EndIf

	Switch $a_ret[1]
		Case "Int32", "Int64"
			Return Int($a_ret[2])
		Case "Double"
			Return Number($a_ret[2])
	EndSwitch

	Return $a_ret[2]
EndFunc   ;==>_hashlite_GetValue

;===================================================================================================
;
; Function Name....:    _hashlite_Initiate()
; Description......:    Initiate the SQLite dll, same as SQLiteStart()
; Parameter(s).....:
;                       $s_dll:
; Return Value(s)..:    none
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_Initiate($s_dll = "")
	If $__gf_hashlite_SQLiteInitiated Then Return
	If Not $s_dll And $g_hDll_SQLite Then Return
	_SQLite_Startup($s_dll)
	$__gf_hashlite_SQLiteInitiated = True
EndFunc   ;==>_hashlite_Initiate

;===================================================================================================
;
; Function Name....:    _hashlite_Sort()
; Description......:   Sorts text, integers, numbers ( Not binary, objects, hwnds, etc )
; Parameter(s).....:
;                       $a_ptr:  storage container for hash data
;                       $f_desc: Default ascending sort
;                       $i_typesort:
;                                      0 = sort all numbers, text, integers (Default, -1, text sort)
;                                      1 = sort text/string only
;                                      2 = sort integers only
;                                      3 = sort numbers and integers only
; Return Value(s)..:
;                       Success...:  1D Array of sorted data
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    1 - Invalid hash ptr/array
;                                    2 - Nothing found during sort to sort
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_Sort(ByRef $a_ptr, $f_desc = False, $i_typesort = -1)

	__hashlite_SetErrorCode()

	Local $i_ptrub = UBound($a_ptr)
	If $i_ptrub < $__gi_hashlite_EnumLastIndex Then
		__hashlite_SetErrorCode(-2, "_hashlite_Sort", "Invalid Hash Ptr.")
		Return SetError(1, 0, 0)
	EndIf

	Local $h_db = $a_ptr[$__gi_hashlite_EnumDB]

	If $f_desc = Default Or Int($f_desc) = -1 Then $f_desc = False
	Local $s_asc = " ASC"
	If $f_desc Then $s_asc = " DESC"

	Local $s_query = "SELECT datvalue FROM array "
	$s_query &= "WHERE datatype = 'String' OR datatype LIKE 'INT%' OR datatype = 'Double' "
	$s_query &= "ORDER BY datvalue " & $s_asc & ";"
	Switch $i_typesort
		Case 1 ; STRING
			$s_query = "SELECT datvalue FROM array "
			$s_query &= "WHERE datatype = 'String' "
			$s_query &= "ORDER BY datvalue" & $s_asc & ";"
		Case 2 ; INTEGER
			$s_query = "SELECT datvalue FROM array "
			$s_query &= "WHERE datatype LIKE 'INT%' "
			$s_query &= "ORDER BY CAST(datvalue AS INTEGER)" & $s_asc & ";"
		Case 3 ; NUMBER, Will sort integer and numbers
			$s_query = "SELECT datvalue FROM array "
			$s_query &= "WHERE datatype LIKE 'INT%' OR datatype = 'Double' "
			$s_query &= "ORDER BY CAST(datvalue AS REAL)" & $s_asc & ";"
	EndSwitch

	Local $h_query, $a_ret
	_SQLite_Query($h_db, $s_query, $h_query)

	Local $i_num = 0, $a_r[100], $i_lastcount = 100
	While _SQLite_FetchData($h_query, $a_ret) = $SQLITE_OK
		If $i_num = $i_lastcount Then
			ReDim $a_r[$i_lastcount + 100]
			$i_lastcount += 100
		EndIf
		$a_r[$i_num] = $a_ret[0]
		$i_num += 1
	WEnd
	_SQLite_QueryFinalize($h_query)

	If $i_num = 0 Then
		; nothing found
		__hashlite_SetErrorCode(-2, "_hashlite_Sort", "Nothing found during sort")
		Return SetError(2, 0, 0)
	EndIf

	ReDim $a_r[$i_num]
	Return $a_r
EndFunc   ;==>_hashlite_Sort

;===================================================================================================
;
; Function Name....:    _hashlite_TableToArray()
; Description......:    Return a 1 dimensional array of your data in the hash table
; Parameter(s).....:
;                       $a_ptr:  The ptr returned from _hashlite_Create() function
; Return Value(s)..:
;                       Success...:  a 1D array
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    1 - Invalid hash ptr/array
;                                    2 - Empty hash table
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_TableToArray(ByRef $a_ptr)

	__hashlite_SetErrorCode()

	Local $i_ptrub = UBound($a_ptr)
	If $i_ptrub < $__gi_hashlite_EnumLastIndex Then
		__hashlite_SetErrorCode(-2, "_hashlite_TableToArray", "Invalid Hash Ptr.")
		Return SetError(1, 0, 0)
	EndIf

	Local $h_db = $a_ptr[$__gi_hashlite_EnumDB]

	Local $s_query = "SELECT max(rowid) FROM array;"
	Local $h_query, $a_ret
	_SQLite_Query($h_db, $s_query, $h_query)
	Local $f_fetch = _SQLite_FetchData($h_query, $a_ret) = $SQLITE_OK
	_SQLite_QueryFinalize($h_query)

	If Not $f_fetch Then
		__hashlite_SetErrorCode(-2, "_hashlite_TableToArray", "There are no values for this request.")
		Return SetError(2, 0, 0)
	EndIf

	Local $a_rdata[$a_ret[0]]
	Local $a_storage = $a_ptr[$__gi_hashlite_EnumStorageArray]

	$s_query = "SELECT argindex,datvalue FROM array;"
	_SQLite_Query($h_db, $s_query, $h_query)
	Local $i_count = 0
	For $i = 0 To Int($a_ret[0]) - 1
		If _SQLite_FetchData($h_query, $a_ret) <> $SQLITE_OK Then ExitLoop
		If $a_ret[0] = "-1" Then
			$a_rdata[$i] = $a_ret[1]
		Else
			$a_rdata[$i] = $a_storage[$a_ret[0]]
		EndIf
		$i_count += 1
	Next
	_SQLite_QueryFinalize($h_query)

	ReDim $a_rdata[$i_count]

	Return $a_rdata
EndFunc   ;==>_hashlite_TableToArray

;===================================================================================================
;
; Function Name....:    _hashlite_Unique()
; Description......:   Unique text, integers, numbers ( Not binary, objects, hwnds, etc )
; Parameter(s).....:
;                       $a_ptr:  storage container for hash data
;                       $i_typeunique:
;                                      0 = unique all numbers, text, integers (Default, -1, text sort)
;                                      1 = unique text/string only
;                                      2 = unique integers only
;                                      3 = unique numbers and integers only
; Return Value(s)..:
;                       Success...:  1D Array of sorted data
;                       Failure...:  0 <zero>
;                       Error.....:
;                                    1 - Invalid hash ptr/array
;                                    2 - Nothing found during sort to unique
;                                    Call _hashlite_GetLastErrorMsg() for string message
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _hashlite_Unique(ByRef $a_ptr, $i_typeunique = -1)

	__hashlite_SetErrorCode()

	Local $i_ptrub = UBound($a_ptr)
	If $i_ptrub < $__gi_hashlite_EnumLastIndex Then
		__hashlite_SetErrorCode(-2, "_hashlite_Unique", "Invalid Hash Ptr.")
		Return SetError(1, 0, 0)
	EndIf

	Local $h_db = $a_ptr[$__gi_hashlite_EnumDB]

	Local $s_query = "SELECT DISTINCT datvalue FROM array "
	$s_query &= "WHERE datatype = 'String' OR datatype LIKE 'INT%' OR datatype = 'Double';"
	Switch $i_typeunique
		Case 1 ; STRING
			$s_query = "SELECT DISTINCT datvalue FROM array "
			$s_query &= "WHERE datatype = 'String';"
		Case 2 ; INTEGER
			$s_query = "SELECT DISTINCT datvalue FROM array "
			$s_query &= "WHERE datatype LIKE 'INT%';"
		Case 3 ; NUMBER, Will sort integer and numbers
			$s_query = "SELECT DISTINCT datvalue FROM array "
			$s_query &= "WHERE datatype LIKE 'INT%' OR datatype = 'Double';"
	EndSwitch

	Local $h_query, $a_ret
	_SQLite_Query($h_db, $s_query, $h_query)

	Local $i_num = 0, $a_r[100], $i_lastcount = 100
	While _SQLite_FetchData($h_query, $a_ret) = $SQLITE_OK
		If $i_num = $i_lastcount Then
			ReDim $a_r[$i_lastcount + 100]
			$i_lastcount += 100
		EndIf
		$a_r[$i_num] = $a_ret[0]
		$i_num += 1
	WEnd
	_SQLite_QueryFinalize($h_query)

	If $i_num = 0 Then
		; nothing found
		__hashlite_SetErrorCode(-2, "_hashlite_Unique", "Nothing found during sort")
		Return SetError(2, 0, 0)
	EndIf

	ReDim $a_r[$i_num]
	Return $a_r
EndFunc   ;==>_hashlite_Unique
#endregion standard functions hashlite


#region internal use only hashlite functions

;===================================================================================================
;
; Function Name....:    __hashlite_AddValue()
; Description......:    Internal function only
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func __hashlite_AddValue(ByRef $a_ptr, $s_value)

	Local $a_storage = $a_ptr[$__gi_hashlite_EnumStorageArray]
	Local $i_storageub = UBound($a_storage)

	Local $i_nextindex = $a_ptr[$__gi_hashlite_EnumNextIndex]

	If Int($i_nextindex) >= $i_storageub Then
		ReDim $a_storage[$i_nextindex + $__gi_hashlite_MasterHashMaxArgs]
	EndIf

	$a_storage[$i_nextindex] = $s_value
	$a_ptr[$__gi_hashlite_EnumNextIndex] += 1 ; next index
	$a_ptr[$__gi_hashlite_EnumStorageArray] = $a_storage

	Return 1
EndFunc   ;==>__hashlite_AddValue

;===================================================================================================
;
; Function Name....:    __hashlite_SetErrorCode()
; Description......:    Internal function only
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func __hashlite_SetErrorCode($i_code = 0, $s_function = "", $s_msg = "")
	$__gs_hashlite_ErrorFunction = $s_function
	$__gi_hashlite_ErrorCode = $i_code
	$__gs_hashlite_SQLiteErrMsg = $s_msg
EndFunc   ;==>__hashlite_SetErrorCode

;===================================================================================================
;
; Function Name....:    __hashlite_SQLiteIsInitiated()
; Description......:    Internal function only
; Requirement(s)...:
; Author(s)........:    SmOke_N
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func __hashlite_SQLiteIsInitiated()
	If Not $g_hDll_SQLite Then
		$__gf_hashlite_SQLiteInitiated = False
		SetError(1)
	EndIf
EndFunc   ;==>__hashlite_SQLiteIsInitiated
#endregion internal use only hashlite functions