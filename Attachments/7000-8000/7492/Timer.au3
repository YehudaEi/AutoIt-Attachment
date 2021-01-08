#include <GUIConstants.au3>
#include <Date.au3>

Global $Secs, $Mins, $Hour, $Time, $InitialT, $TargetT
GUICreate("Timer", 200, 100)
$MinIn = GUICtrlCreateInput("00", 70, 10, 30, 20, $ES_NUMBER)
$label = GUICtrlCreateLabel(":", 101, 12)
$SecIn = GUICtrlCreateInput("00", 105, 10, 30, 20, $ES_NUMBER)
$start = GUICtrlCreateButton("Start", 75, 50, 50, 30)
$timeLabel = GUICtrlCreateLabel("00:00:00", 80, 20)
GUICtrlSetState($timeLabel, $GUI_HIDE)
GUISetState(@SW_SHOW)
$started = 0

While 1
  ;After every loop check if the user clicked something in the GUI window
   $msg = GUIGetMsg()

   Select
   
     ;Check if user clicked on the close button
      Case $msg = $GUI_EVENT_CLOSE
        ;Destroy the GUI including the controls
         GUIDelete()
         ExitLoop

      Case $msg = $start
        If GUICtrlRead($start) == "Start" Then
            StartTimer()
        Else
            StopTimer()
        EndIf

   EndSelect

WEnd
Exit

Func StartTimer()
    GUICtrlSetData($start, "Stop")
    GUICtrlSetState($MinIn, $GUI_HIDE)
    GUICtrlSetState($label, $GUI_HIDE)
    GUICtrlSetState($SecIn, $GUI_HIDE)
    GUICtrlSetState($timeLabel, $GUI_SHOW)
    $InitialT = TimerInit()
    $TargetT = (GUICtrlRead($MinIn) * 60 + GUICtrlRead($SecIn)) *1000
    AdlibEnable("Timer")
EndFunc  ;==>StartTimer

Func StopTimer()
    GUICtrlSetData($start, "Start")
    GUICtrlSetState($MinIn, $GUI_SHOW)
    GUICtrlSetState($label, $GUI_SHOW)
    GUICtrlSetState($SecIn, $GUI_SHOW)
    GUICtrlSetState($timeLabel, $GUI_HIDE)
    AdlibDisable()
EndFunc  ;==>StartTimer

Func Timer()
    $TimeLeft = $TargetT - TimerDiff($InitialT)
    If $TimeLeft > 0 Then
        _TicksToTime(Int($TimeLeft), $Hour, $Mins, $Secs)
        ; save current time to be able to test and avoid flicker..
        Local $sTime = $Time
        $Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime <> $Time Then GUICtrlSetData($timeLabel, $Time)
    Else
        ; Do something here

        StopTimer()
    EndIf
EndFunc  ;==>Timer
