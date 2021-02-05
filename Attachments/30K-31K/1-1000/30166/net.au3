#include "NetworkValues.au3"


HotKeySet("{ESC}","_Exit")


; These constants are fore readability
Global Const $qDATA = 0
Global Const $qTIME = 1
Global Const $qSIZE = 50

; This affects how our script works
Global Const $pollingFrequency = .5 * 1000; Poll every 1/2 second
Global Const $timeDiff = 2 * 1000
; The threashold for warning about spikes
Global Const $dataDiff = 30

; I hate global data structures, but it avoids tedious passing of
; values between functions
Global $qFront = 0 ;Holds the index of the most current time
Global $qBack = 0 ;Holds the index of the oldest time
Global $qSmall = 0 ;Holds the index of the smallest time between $qFront and $qBack
Global $Queue [$qSIZE][2] ;The array that will hold our queue
Global $logHandle = FileOpen ("SomeLogFilePath.txt", 1) ;Open the log file

; Start the timer
Local $timer = TimerInit()

; Zero out the first entry
$Queue [0][$qDATA] = 0
$Queue [0][$qTIME] = 0

While 1
    Sleep($pollingFrequency)
    ; Record the current usage and time
    Local $nowDATA = _GetNetworkUsage()
    Local $nowTIME = TimerDiff ($timer)
    
    ; Add it to the queue
    _AddToQueue ($nowDATA, $nowTIME)
    
    ; Check if it is smaller than the oldest low point
    If $nowDATA < $Queue[$qSmall][$qDATA] Then 
        $qSmall = $qFront
	ElseIf Abs($nowDATA - $Queue[$qSmall][$qDATA]) >= $dataDiff Then
        _AlertMe ()
        $qSmall = $qFront
    EndIf
WEnd

Func _AlertMe ()
	MsgBox(0, "Alert", "The Variable has shown a spike: "&$InfuserHP)
EndFunc

Func _AddToQueue ($data, $time)
    If $time - $Queue[$qBack][$qTIME] > $timeDiff Then ;If the last item in the queue has timed out
        ;Increment $qBack
        $qBack = Mod ($qBack + 1, $qSIZE)
        
        If $qBack - 1 = $qSmall Then ;Find the next smallest
            $qSmall = $qBack
            ;Custom loop to deal with the Queue, which is treated as a circle, with end and beginning connected
            Local $temp = $qBack
            While $temp <> $qFront
                If $Queue[$temp][$qDATA] < $Queue[$qSmall][$qDATA] Then $qSmall = $temp
                ;Increment $temp, which will wrap around at the end of the array
                $temp = Mod($temp + 1, $qSIZE)
            WEnd
        EndIf
    EndIf
    
    ;Move $qFront forward
    $qFront = Mod($qFront + 1, $qSIZE) ;Wraps around if we pass $qSIZE
    
    ;Increment $qBack if we are out of space in the queue
    If $qFront > $qBack AND $qFront - $qBack > $qSIZE Then 
        $qBack = Mod ($qBack + 1, $qSIZE)
        FileWriteLine ($logHandle, @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " Size of Queue exeeded, please resize $qSIZE")
    ElseIf $qFront < $qBack AND ($qFront + 50) - $qBack > $qSIZE Then 
        $qBack = Mod ($qBack + 1, $qSIZE)
        FileWriteLine ($logHandle, @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " Size of Queue exeeded, please resize $qSIZE")
    EndIf
    
    ;Insert our data in the new first slot
    $Queue[$qFront][$qDATA] = $data
    $Queue[$qFront][$qTIME] = $time
EndFunc

Func _GetNetworkUsage()
	
	Return $networkvalue ; A number between 1 and 100
	
EndFunc

Func _Exit()
    Exit
EndFunc