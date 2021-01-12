;#include <SQLite.dll.au3>
#include <SQLite.au3>
Local $hQuery, $iCount, $aRow
_SQLite_Startup ()
_SQLite_Open () ; open :memory: Database
_SQLite_Exec (-1, "CREATE TABLE aTest (a,b,c);")
_SQLite_Exec (-1, "INSERT INTO aTest(a,b,c) VALUES ('c','2','World');")
_SQLite_Exec (-1, "INSERT INTO aTest(a,b,c) VALUES ('b','3','TEST');")
_SQLite_Exec (-1, "INSERT INTO aTest(a,b,c) VALUES ('a','1','Hello');")
_SQlite_Query (-1, "SELECT RowID,* FROM aTest ORDER BY a;", $hQuery) ; Including RowID


_SQLite_ColumnCount ($hQuery, $iCount) ; Read out the ColumnCount
MsgBox(0,"SQLite","Get # Columns using ColumnCount : " & $iCount & @CR)

;While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK	
;	MsgBox(0,"SQLite","Get Data using FetchData : " &  StringFormat(" %-10s  %-10s  %-10s  %-10s ", $aRow[0], $aRow[1], $aRow[2], $aRow[3]) & @CR)
;WEnd

While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
	MsgBox(0,"SQLite","Get Data using FetchData : " &  StringFormat(" %-10s  %-10s  %-10s  %-10s ", $aRow[0], $aRow[1], $aRow[2], $aRow[3]) & @CR)
	
	_SQLite_ColumnType($hQuery)
	
	_SQLite_ColumnText($hQuery)
		
	;_SQLite_Step()
WEnd


_SQLite_Exec (-1, "DROP TABLE aTest;")
_SQLite_Close ()
_SQLite_Shutdown ()

Func _SQLite_Step()
	local $Step 
	$Step = DllCall($g_hDll_SQLite, "int:cdecl", "sqlite3_step", "ptr", $hQuery)
					MsgBox(0,"Step # ",$Step[0]-100)
EndFunc


Func _SQLite_ColumnText($hQuery)
	local $val,$i
For $i = 1 To $iCount -1
	$val = DllCall($g_hDll_SQLite, "str:cdecl", "sqlite3_column_text", "ptr", $hQuery, "int", $i)
	$i += 1
	MsgBox(0,"Culumn Text",$val[0])
	Next
EndFunc
 
Func _SQLite_ColumnType($hQuery)
	local $coltype, $val,$i,$Step
	For $i = 1 To $iCount -1
	$coltype = DllCall($g_hDll_SQLite, "int:cdecl", "sqlite3_column_type", "ptr", $hQuery, "int", $i)
			; INTEGER  1
			; FLOAT    2
			; TEXT     3
			; BLOB     4
			; NULL     5
		$i += 1
	MsgBox(0,"Culumn Type",$coltype[0])
	Next
EndFunc				

Func _SQLite_ColumnCount($hQuery, ByRef $iCount)
	If Not __SQLite_hChk($hQuery, $SQLITE_QUERYHANDLE) = $SQLITE_OK Then Return SetError(3, 0, $SQLITE_MISUSE)
	$iColumnCnt = DllCall($g_hDll_SQLite, "int:cdecl", "sqlite3_column_count", "ptr", $hQuery)
	If @error > 0 Then
		Return SetError(1, 0, $SQLITE_MISUSE) ; DllCall Error (sqlite3_column_count)
	ElseIf $iColumnCnt[0] > 0 Then
		$iCount =  $iColumnCnt[0]
		Return $SQLITE_OK
	Else
		Return SetError(-1, 0, $SQLITE_EMPTY)
	EndIf
EndFunc   ;==>_SQLite_ColumnCount

