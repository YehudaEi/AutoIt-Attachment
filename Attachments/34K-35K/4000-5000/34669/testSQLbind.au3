; ===============================================================================================================================
; Test _SQLite_Bind_* functions
; ===============================================================================================================================

#include <SQLite.au3>
#include "SQLiteBind.au3"


Local $hQuery, $rc
_SQLite_Startup()
If @error Then ConsoleWrite("++ rc = " & $rc & "  @error = " & @error & @LF)
Local $hDB = _SQLite_Open(@ScriptDir & "\testbind.db3")
If @error Then ConsoleWrite("-- rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Exec($hDB, "CREATE TABLE IF NOT EXISTS [test] (" & _
						"[id] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, " & _
						"[C_int] INTEGER, " & _
						"[C_int64] INTEGER, " & _
						"[C_real] REAL, " & _
						"[C_text] TEXT, " & _
						"[C_blob] BLOB, " & _
						"[C_zblob] BLOB, " & _
						"[C_null]  " & _
					"CONSTRAINT [chkTypes] CHECK(" & _
						"typeof(C_int) = 'integer' and " & _
						"typeof(C_int64) = 'integer' and " & _
						"typeof(C_text) = 'text' and " & _
						"typeof(C_real) = 'real' and " & _
						"typeof(C_blob) = 'blob' and " & _
						"typeof(C_zblob) = 'blob' and " & _
						"typeof(C_null) = 'null')" & _
					");")
If @error Then ConsoleWrite("00 rc = " & $rc & "  @error = " & @error & @LF)

; let's prove this works as intended: the check constraint will take care of verifying we're inserting the expected types.

; parameter numbers and/or names: you can use  a single ? to specify a numbered parameter (numbering starts at 1)
; you can as well use ?1, ?2, ?3 ...
; it's also possible to give names to parameters. Such names are introduced by any of the following characters : or $ or @
; like this :first_param, $second_param, @third_param
; you are free to mix all of the above in the same statement, like in the example below

$rc = _SQLite_Query($hDB, "insert into test (C_int, C_int64, C_real, C_text, C_blob, C_zblob, C_null) values (" & _
								"?1, ?, :third, $string, @blobcolumn, ?, ?7);", $hQuery)
If @error Then ConsoleWrite("01 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Numeric($hQuery, 1, 123456)
If @error Then ConsoleWrite("02 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Numeric($hQuery, 2, 123456789012345)
If @error Then ConsoleWrite("03 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Numeric($hQuery, 3, 123456.789012)
If @error Then ConsoleWrite("04 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_String($hQuery, 4, 'abcdef')
If @error Then ConsoleWrite("05 rc = " & $rc & "  @error = " & @error & @LF)
; note that you can use parameter index (number) _or_ its name when it has one
$rc = _SQLite_Bind_Blob($hQuery, '@blobcolumn', Binary(0123456789))
If @error Then ConsoleWrite("06 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_ZeroBlob($hQuery, 6, 1024)
If @error Then ConsoleWrite("07 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Null($hQuery, 7)
If @error Then ConsoleWrite("08 rc = " & $rc & "  @error = " & @error & @LF)
; cause actual INSERT to be effective.  Might give error as well (busy, locked, ...).
$rc = _SQLite_Step($hQuery)
If @error Then ConsoleWrite("09 rc = " & $rc & "  @error = " & @error & @LF)

$rc = _SQLite_QueryReset($hQuery)
If @error Then ConsoleWrite("101 rc = " & $rc & "  @error = " & @error & @LF)

; sometimes you may have the need to clear the bindings already done.  NOTE that _SQLite_QueryReset does _not_ clear bindings!
;~ $rc = _SQLite_ClearBindings($hQuery)
;~ If @error Then ConsoleWrite("102 rc = " & $rc & "  @error = " & @error & @LF)

$rc = _SQLite_Bind_Numeric($hQuery, 1, 654321)
If @error Then ConsoleWrite("10 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Numeric($hQuery, 2, 543210987654321)
If @error Then ConsoleWrite("11 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Numeric($hQuery, ':third', 789012.123456)			; use the parameter name
If @error Then ConsoleWrite("12 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_String($hQuery, "$string", 'fedcba')					; use the parameter name
If @error Then ConsoleWrite("13 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Blob($hQuery, 5, Binary(8887776665), 3)
If @error Then ConsoleWrite("14 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_ZeroBlob($hQuery, 6, 33)
If @error Then ConsoleWrite("15 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Bind_Null($hQuery, 7)
If @error Then ConsoleWrite("16 rc = " & $rc & "  @error = " & @error & @LF)
$rc = _SQLite_Step($hQuery)
If @error Then ConsoleWrite("17 rc = " & $rc & "  @error = " & @error & @LF)

$rc = _SQLite_QueryFinalize($hQuery)
If @error Then ConsoleWrite("103 rc = " & $rc & "  @error = " & @error & @LF)

_SQLite_Close($hDB)
_SQLite_Shutdown()
