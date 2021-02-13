#include <sqlite.au3>
#include <sqlite.dll.au3>


#include "sqlitebackup.au3"

#include "..\include\helpers.au3"

;;========================
;;
;; SQLite backup examples
;;
;;
;; The SQLite backup API is intended to perform a backgroud backup of a database while it
;; is being used by other processes.  This live backup is a essentially a _slow_ process.
;; If you're in a hurry, then close your database and copy the database file as a whole,
;; or specify -1 as the page block size.  It will copy the whole base in one run but be
;; warned that then SQLite will hold an exclusive lock on the source database, which may
;; be difficult to obtain or may go against availability constraints for other processes.
;;
;; To use successfully (without locking errors), you have to take usual precautions, just
;; like with other shared resource.  Use _SQLite_SetTimeout with ample delay and wrap any
;; read/modify/write operations in an IMMEDIATE transaction. Groups (tight loops) of inserts
;; should always use a transaction anyway, for mere efficiency.  Of course, if there are
;; no other processes using the database, it's much faster to copy the database file like
;; any other file.
;;
;; This example shows that a backup can go on with reads and writes occuring concurrently
;; but you'll notice that the backup restarts every time it 'sees' that the database has
;; been written to.  If you expect that the rate of writes won't give the backup enough
;; time to complete, then the backup process will never finish, defeating its purpose.
;;
;; You can use this function to backup disk or memory databases to/from disk or memory.
;; There is provision to specify the name of source/destination database(s) to make the
;; backup act on 'main', temp' or any attached database which has been given an alias.
;;
;; To fully understand the process, please refer to the current SQLite documentation.
;;
;; Default parameters seem to give decent performance and reflect most usual cases.  Be
;; wise if you modify them: a sleeptime of 10ms is certainly not enough, 1 000 000 000ms
;; is probably too much...
;;
;;========================


#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
;~ #include <SendMessage.au3>


	Global $rowsInserted = 0
	Global $rowsSelected = 0
	Global $rowsUpdated = 0

	Local $srcfile = ":memory:"
	Local $dstfile = "testbackup.db3"
	Local $Form1 = GUICreate("SQLite Backup demo", 400, 170)
	Local $lbDoing = GUICtrlCreateLabel("", 50, 25, 300, 15, $SS_CENTER)
	Local $pbPercent = GUICtrlCreateProgress(50, 50, 300, 20, $PBS_SMOOTH)
;~ GUICtrlSetStyle($pbPercent,0x040A)		; démarrage
;~ _SendMessage(GUICtrlGetHandle($pbPercent), 0x040A, True, 30)		; vitesse in 1-99

	Local $lbSelects = GUICtrlCreateLabel("", 50, 80, 300, 15, $SS_CENTER)
	Local $lbInserts = GUICtrlCreateLabel("", 50, 105, 300, 15, $SS_CENTER)
	Local $lbUpdates = GUICtrlCreateLabel("", 50, 130, 300, 15, $SS_CENTER)
	GUISetState()

	GUICtrlSetData($lbDoing, 'Starting SQLite')
	_SQLite_Startup()
	If @error Then
		MsgBox(8192 + 16, "SQLite Backup demo - fatal error", "SQLite3.dll can't be loaded.")
		Exit
	EndIf

	; open memory database
	GUICtrlSetData($lbDoing, 'Opening database')
	Local $hDB = _SQLite_Open($srcfile)

	ConsoleWrite('Running SQLite version ' & _SQLite_LibVersion() & @LF)

	; create a table
	GUICtrlSetData($lbDoing, 'Creating a table')
	_SQLite_Exec($hDB, "create table if not exists test (Id integer, Inserted integer, Updated integer, Data text);")

	; populate the table with our "high-value" data ;-)
	GUICtrlSetData($lbDoing, 'Populating the table with random data')
	_SQLite_Exec($hDB, "begin;")
	For $i = 1 To 32768
		_SQLite_Exec($hDB, "insert into test values(abs(round(random()/1048576)), 0, 0, lower(hex(randomblob(4))));")
		GUICtrlSetData($pbPercent, 100 * $i / 32768)
	Next
	_SQLite_Exec($hDB, "commit;")

	; We show that we can continue using (read and write) the database while it is
	; backed up, being careful not to modify the base faster than it's being saved!
	;
	; Each time a record is inserted or updated, the backup process needs to start
	; again from scratch, except if the modification is made using the same SQLite
	; connection AND the source database is disk-based.
	;
	; By default, _SQLite_Backup write 16 database pages then sleeps for 250ms
	; to give a chance to concurrent accesses to take place, eventually.  Think of
	; the defaults as a backgroupnd slow function.  You can force a backup in a single
	; operation by supplying -1 as the backup page count, but it will block any
	; concurrent read by other processes until it's done.
	;
	; Here we limit (by counting) the number of added records, to be sure the backup
	; process will finish. We also launch random updates. these writes cause the backup
	; to restart completely if the source is a memory database or if the source is disk
	; -based and the modifications are made by using another connection.
	;
	; We use 3 different adlib delays so that it more or less mimics normal random activity
	AdlibRegister("InsertData", 470);
	AdlibRegister("UpdateData", 3190);

	; we may read the base as well (not using index means a full scan)
	AdlibRegister("SelectData", 1100);

	; make a disk backup
	GUICtrlSetData($lbDoing, 'Backing up the memory DB to disk (watch it restart at DB writes).')
	Local $hDbCopy = _SQLite_Backup($hDB, $dstfile, Default, Default, Default, Default, $pbPercent)
	ConsoleWrite("Backup status: " & @error & ' ' & @extended & @LF)

	; $hDbCopy is the handle to the backup database, left open by the backup function (new interface)
	; we may perform operations on it, like check integrity, vacuum and/or reindex
	Local $rows, $nrows, $ncols
	_SQLite_GetTable($hDbCopy, "pragma integrity_check;", $rows, $nrows, $ncols)
	ConsoleWrite("Check status: " & @error & ' ' & @extended & @LF)
	_ArrayDelete($rows, 0)
	_ArrayDisplay($rows, "Integrity check result")
	_SQLite_Exec($hDbCopy, "vacuum;")
	ConsoleWrite("Vacuum status: " & @error & ' ' & @extended & @LF)

	; stop using, then close the disk backup DB
	_SQLite_Close($hDbCopy)

	; stop using, then close the memory DB
	AdlibUnRegister("SelectData");
	AdlibUnRegister("UpdateData");
	AdlibUnRegister("InsertData");
	_SQLite_Close($hDB)

	; reopen the disk base we just duplicated
	Local $hDB2 = _SQLite_Open($dstfile)

	; back it up into a new memory DB
	GUICtrlSetData($lbDoing, 'Backup the disk file to a new memory DB')
	; copy blocks of 256 pages at once, report progress to console
	Local $hmemDb = _SQLite_Backup($hDB2, ':memory:', Default, Default, 256, Default, -1)
	ConsoleWrite("Backup status: " & @error & ' ' & @extended & @LF)

	; close the (now source) disk DB
	_SQLite_Close($hDB2)

	; trim the memory table just loaded
	; remove the large number of rows we didn't modify
	GUICtrlSetData($lbDoing, 'Modify the base')
	_SQLite_Exec($hmemDb, "delete from test where inserted = 0 and updated = 0;")

	; look at this memory DB
	_SQLite_GetTable2d($hmemDb, "select * from test order by id;", $rows, $nrows, $ncols)
	_ArrayDisplay($rows, "Reading from the memory copy")

	; close the clone memory DB
	_SQLite_Close($hmemDb)

	_SQLite_ShutDown()
	FileDelete($dstfile)
;~ GUICtrlSetStyle($pbPercent, 0)			; arrêt
;~ _SendMessage(GUICtrlGetHandle($pbPercent), 0x040A, False, 0)

	Exit

;;========================

Func InsertData()
	If $rowsInserted >= 10 Then Return
	If Random(0, 3, 1) = 1 Then
		_SQLite_Exec($hDB, "insert into test (id, inserted, updated, data) values(abs(round(random()/1048576)), 1, 0, lower(hex(randomblob(4))));")
		$rowsInserted += 1
		GUICtrlSetData($lbInserts, $rowsInserted & " rows inserted during backup")
	EndIf
EndFunc


Func UpdateData()
	If $rowsUpdated >= 5 Then Return
	Local $row, $cond
	_SQLite_Exec($hDB, "begin immediate;")
	_SQLite_QuerySingleRow($hDB, "select lower(hex(randomblob(2)));", $row)
	$cond = " where updated = 0 and data like '" & $row[0] & "%';"
	_SQLite_QuerySingleRow($hDB, "select count(*) from test" & $cond, $row)
	_SQLite_Exec($hDB, "update test set Updated = 1" & $cond)
	_SQLite_Exec($hDB, "commit;")
	If $row <> '' Then
		$rowsUpdated += Number($row[0])
		GUICtrlSetData($lbUpdates, $rowsUpdated & " rows updated during backup")
	EndIf
EndFunc


Func SelectData()
	Local $row
	_SQLite_QuerySingleRow($hDB, "select count(*) from test where inserted or updated;", $row)
	If $row <> '' Then
		$rowsSelected = $row[0]
		GUICtrlSetData($lbSelects, 'SELECT found ' & $row[0] & " rows modified during backup")
	EndIf
EndFunc
