#include "SimpleSemaphore.au3"
#include <SQLite.au3>
#include <Array.au3>
#include "Multiprocessing.au3"

Local $hSem = BoundedSemaphore("DBSemaphore", 3)
;Local $hSem = Semaphore("DBSemaphore", 3)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : semNo. = ' & SemaphoreGetCount($hSem) & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hSem = ' & $hSem & @CRLF) ;### Debug Console

;_SQLite_Startup("D:\MyProgram\Autoit\Tools\SQLite\SQLite3_300800403.dll")
_SQLite_Startup()
ConsoleWrite("----" & _SQLite_LibVersion() & "----" & @CRLF)
_SQLite_Open("justTesting.db")
_SQLite_Exec(-1, "CREATE TABLE TEST (a);")
For $x  = 0 To 10
  _SQLite_Exec(-1, "INSERT INTO TEST(a) VALUES('" & $x & "');")
Next
;####################
; child process in here
;####################
Local $aProcessList = []
For $y = 1 to 6
  Local $args[] = [$y]
  _ArrayAdd($aProcessList, SubProcess(ProcessConnect, $args))
Next

For $z In $aProcessList
  SubProcess_Run($z)
Next

For $z in $aProcessList
  SubProcess_Join($z)
Next
_SQLite_Close()
_SQLite_Shutdown()
FileDelete("justTesting.db")

Func ProcessConnect($i)
  Local $hQuery
  Local $hSem1 = BoundedSemaphore("DBSemaphore", 3)
  ;Local $hSem1 = Semaphore("DBSemaphore", 3)
  ;MsgBox(4096, "", "count: " & SemaphoreGetCount($hSem1))
  If @error Then MsgBox(4096, "error", "open error!!!")
  if SemaphoreAcquire($hSem1) Then
    MsgBox(4096, @AutoItPID, @AutoItPID & " has gotten a semaphore.")
    ;_SQLite_Startup("D:\MyProgram\Autoit\Tools\SQLite\SQLite3_300800403.dll")
    _SQLite_Startup()
    _SQLite_Open("justTesting.db")
    _SQLite_Query(-1, "select * from test where a = '" & $i & "';", $hQuery)
    ;If @error Then MsgBox(4096, "", "sqlite error.")
    _SQLite_Close()
    _SQLite_Shutdown()
    SemaphoreRelease($hSem1)
    ;MsgBox(4096, @AutoItPID, @AutoItPID & "has released a semaphore.")
  Else
    MsgBox(4096, @AutoItPID, "can't get semaphore" & @CRLF  & _WinAPI_GetLastError())
  EndIf
EndFunc
