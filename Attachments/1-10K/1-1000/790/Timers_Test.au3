Opt ("TrayIconDebug", 1)
Opt ("MustDeclareVars", 1)
Opt ("GuiOnEventMode", 1)
Opt ("WinTitleMatchMode", 4)

#include <GUIConstants.au3>
#include "Timers.inc.au3"

Main()

Func Main()
   
   HotKeySet("{Esc}", "Terminate")
   HotKeySet("^1", "Toggle_TenSeconds")
   HotKeySet("^2", "Toggle_TwoSeconds")
   HotKeySet("^3", "Toggle_FiveSeconds")
   
   TrayTip("Timers", "Starting", 0)
   
   _TimersInitialize ()
   
   _TimerSet ("TenSeconds", 10000, "TenSeconds_Tick")
   _TimerSet ("FiveSeconds", 5000, "FiveSeconds_Tick")
   _TimerSet ("TwoSeconds", 2000, "TwoSeconds_Tick")
   _TimerStart ("TenSeconds")
   _TimerStart ("TwoSeconds")
   _TimerStart ("FiveSeconds")
   
   While 1
      Sleep(10)
   WEnd
   
EndFunc   ;==>Main

Func Terminate()
   Exit
EndFunc   ;==>Terminate

Func TenSeconds_Tick()
   TrayTip("TenSeconds", "Tick " & @SEC, 1, 1)
   ConsoleWrite("TenSeconds: " & @SEC & @LF)
EndFunc   ;==>TenSeconds_Tick

Func TwoSeconds_Tick()
   TrayTip("TwoSeconds", "Tick " & @SEC, 1, 1)
   ConsoleWrite("TwoSeconds: " & @SEC & @LF)
EndFunc   ;==>TwoSeconds_Tick

Func FiveSeconds_Tick()
   TrayTip("FiveSeconds", "Tick " & @SEC, 1, 1)
   ConsoleWrite("FiveSeconds: " & @SEC & @LF)
EndFunc   ;==>FiveSeconds_Tick
 
Func Toggle_TenSeconds()
   Toggle("TenSeconds")
EndFunc   ;==>Toggle_TenSeconds

Func Toggle_TwoSeconds()
   Toggle("TwoSeconds")
EndFunc   ;==>Toggle_TwoSeconds

Func Toggle_FiveSeconds()
   Toggle("FiveSeconds")
EndFunc   ;==>Toggle_FiveSeconds

Func Toggle($timerID)
   
   If _isTimerStarted ($timerID) = $__TRUE Then
      _TimerStop ($timerID)
      ConsoleWrite($timerID & " stopped" & @LF)
   Else
      _TimerStart ($timerID)
      ConsoleWrite($timerID & " started" & @LF)
   EndIf
   
EndFunc   ;==>Toggle



