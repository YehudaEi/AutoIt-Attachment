#include <sqlite.au3>
#include <sqlite.dll.au3>
Local $aResult,$iRows,$iColumns
_SQLite_Startup()
_SQLite_Open() ; Memory Database
_SQLite_Exec(-1,"Create Table tblTest (a,b,c);") ; Create Table
_SQLite_Exec(-1,"insert into tblTest(a,b,c) values('a1','b1','c1');") ; Row 1
_SQLite_GetTable2d(-1,"Select * From tblTest",$aResult,$iRows,$iColumns)
MsgBox(0,"Initial State of table:",_SQLite_Display2DResult($aResult,0,True))
_SQLite_Exec(-1,"Begin;")
_SQLite_Exec(-1,"insert into tblTest(a,b,c) values('a2','b2','c2');") ; Row 2
_SQLite_Exec(-1,"insert into tblTest(a,b,c) values('a3','b3','c3');") ; Row 3
_SQLite_GetTable2d(-1,"Select * From tblTest",$aResult,$iRows,$iColumns)
MsgBox(0,"Added line 2 and 3:",_SQLite_Display2DResult($aResult,0,True))
_SQLite_Exec(-1,"Commit;")
_SQLite_Exec(-1,"Rollback;")
_SQLite_GetTable2d(-1,"Select * From tblTest",$aResult,$iRows,$iColumns)
MsgBox(0,"After Rollback:",_SQLite_Display2DResult($aResult,0,True))
_SQLite_Shutdown()