#include <ServiceControl.au3>
#include <Service.au3>

Global $file_to_monitor = "C:\inetpub\ftproot\Music\Songs\playlist"
Global $on_start_value = CheckForFileUpdate($file_to_monitor)

While 1 
    Sleep(1000)
    $return_date = CheckForFileUpdate($file_to_monitor)
    ;ConsoleWrite(@CRLF & $return_date & " - " & $on_start_value)
    If $return_date <> $on_start_value Then
        _RestartServices() ; restarts service 'Music', could have some error checking here
        $on_start_value = $return_date ; resets the on_start_value to newest date / time value
    EndIf
WEnd


Func CheckForFileUpdate($file_to_check)
    $file_time = FileGetTime($file_to_check, 0)
    If Not @error Then
        $yyyymd = $file_time[0] & "/" & $file_time[1] & "/" & $file_time[2]
        $hhmmss = $file_time[3] & ":" & $file_time[4] & ":" & $file_time[5]
        Return $yyyymd & " " & $hhmmss
    EndIf
    Return 0
EndFunc   ;==>CheckForFileUpdate
Func _RestartServices()
    Local $time1, $time2
    If _ServiceExists ("", "Music") = 1 Then
        If _ServGetState("Music") = "Running"  Then
            _StopService ("", "Music")
        EndIf
        $time1 = TimerInit()
        Do
            Sleep(1000)
            If _ServGetState("Music") = "Stopped"  Then ExitLoop
        Until TimerDiff($time1) > 20000
        _StartService("", "Music")
        $time2 = TimerInit()
        Do
            Sleep(1000)
            If _ServGetState("Music") = "Running"  Then Return "1" 
        Until TimerDiff($time2) > 20000; check timeout
    EndIf
    Return "0" 
EndFunc   ;==>_RestartServices