#include <ServiceControl.au3>
#include <Service.au3>

Global $file_to_monitor = "C:\a.txt"
Global $on_start_value = CheckForFileUpdate($file_to_monitor)

While 1 
    Sleep(1000)
    $return_date = CheckForFileUpdate($file_to_monitor)
    ;ConsoleWrite(@CRLF & $return_date & " - " & $on_start_value)
    If $return_date <> $on_start_value Then
        _ProcessClose() ; 
        $on_start_value = $return_date ; resets the on_start_value to newest date / time value


Func CheckForFileUpdate($file_to_check)
    $file_time = FileGetTime($file_to_check, 0)
    If Not @error Then
        $yyyymd = $file_time[0] & "/" & $file_time[1] & "/" & $file_time[2]
        $hhmmss = $file_time[3] & ":" & $file_time[4] & ":" & $file_time[5]
        Return $yyyymd & " " & $hhmmss
    EndIf
    Return 0
EndFunc   ;==>CheckForFileUpdate
Func _ProcessClose()
    Local $time1, $time2
    If _ProcessExists("iexplore.exe") Then
	_ProcessClose("iexplore.exe")

        EndIf
        $time1 = TimerInit()
        Do
            Sleep(1000)
    EndIf
    Return "0" 
EndFunc   ;==>_ProcessClose