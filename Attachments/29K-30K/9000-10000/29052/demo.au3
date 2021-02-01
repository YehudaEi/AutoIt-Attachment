#include <SQLite.au3>
#include <SQLite.dll.au3>

Local $hQuery, $aRow, $aNames
_SQLite_Startup ()
_SQLite_Open () ; open :memory: Database
_SQLite_Exec (-1, "CREATE TABLE aTest (a,b,c);")
_SQLite_Exec (-1, "INSERT INTO aTest(a,b,c) VALUES ('c','2','World');")
_SQLite_Exec (-1, "INSERT INTO aTest(a,b,c) VALUES ('b','3',' ');")
_SQLite_Exec (-1, "INSERT INTO aTest(a,b,c) VALUES ('a','1','Hello');")
_SQlite_Query (-1, "SELECT ROWID,* FROM aTest ORDER BY a;", $hQuery)
_SQLite_FetchNames ($hQuery, $aNames)
MsgBox(0, "code -> 'msg'", StringFormat("%-10s  %-10s  %-10s  %-10s", $aNames[0], $aNames[1], $aNames[2], $aNames[3]))
While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK ; Read Out the next Row
    MsgBox(0, StringFormat("%s -> '%s'", _SQLite_ErrCode(), _SQLite_ErrMsg()), StringFormat(" %-10s  %-10s  %-10s  %-10s ", $aRow[0], $aRow[1], $aRow[2], $aRow[3]))
WEnd
_SQLite_Exec (-1, "DROP TABLE aTest;")
_SQLite_Close ()
_SQLite_Shutdown ()