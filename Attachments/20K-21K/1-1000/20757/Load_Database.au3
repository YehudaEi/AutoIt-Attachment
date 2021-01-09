#include <file.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#NoTrayIcon


Dim $Array, $aRow, $aRec
FileDelete(@ScriptDir & "\DAILY.xdb")
#Region SQL Startup
_SQLite_Startup()
If @error > 0 Then
	MsgBox(16, "SQLite Error", "SQLite.dll Can't be Loaded!")
	Exit - 1
EndIf

; Open database
$DataBase = _SQLite_Open (@ScriptDir & "\DAILY.xdb") 							
If @error > 0 Then
	; create database
	MsgBox(16, "SQLite Error", "Can't Load Database!")
	Exit
EndIf	
ToolTip("Writing Database... Please Wait...", 1, 1)
; create the tables
; Daily table records each transaction
_SQLite_Exec(-1 , "CREATE TABLE Daily (TxNo NUMERIC, Date TEXT, Time TEXT, ItemCode NUMERIC, Description TEXT, Qty NUMERIC, Price NUMERIC, Dept TEXT, Disc NUMERIC, DiscRef TEXT);")

; Products table stores all products / services sold
_SQLite_Exec(-1 , "CREATE TABLE Products (ItemCode NUMERIC, Description TEXT, Price NUMERIC, Dept TEXT, SDisc NUMERIC, SQty NUMERIC, CDisc NUMERIC, CQty NUMERIC, FDisc NUMERIC, FQty NUMERIC, PDisc NUMERIC, PQty NUMERIC);")

;Dept table stores dept names/codes for the Products - not necessary, but convenient
_SQLite_Exec(-1 , "CREATE TABLE Dept (Dept TEXT, Code TEXT);")

; fill Dept table with some values
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Typing', '01');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Print', '02');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Tel', '03');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('INet', '04');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('PC Use', '05');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Repairs', '06');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Virus', '07');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Stationery', '08');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('House', '09');")
_SQLite_Exec(-1 , "INSERT INTO Dept (Dept, Code) VALUES ('Discount', '90');")
#endregion

; read product items from text file into array
If Not _FileReadToArray("PosConfig.txt",$aRec) Then
	_SQLite_Close($DataBase)
   _SQLite_Shutdown()
   FileDelete(@ScriptDir&"\DAILY.xdb")
   MsgBox(4096,"Error", " Error reading log to Array  error:" & @error)
   MsgBox(4096, "Error", "You probably have a corrupted PoSConfig.txt file, or it does not exist!")
   Exit
 EndIf
 
; add items to SQL database
For $x = 1 to $aRec[0]
	ConsoleWrite("Rec# " & $x & ": " & $aRec[$x] & @LF)
	$aRow = StringSplit($aRec[$x], "|")
	_SQLite_Exec(-1 , "INSERT INTO Products (ItemCode, Description, Price, Dept) " & _
										"VALUES ('" & $aRow[1] & "', '"& $aRow[2] & "', '" & $aRow[3] & "', '" & $aRow[4] & "' );")
Next
ToolTip("Database Writing Finished...Clearing Cache...", 1, 1)
Sleep(2000)
ToolTip("Ready...", 1, 1)
MsgBox(0, "Ready", "You Can Now Use The CashUp Program")