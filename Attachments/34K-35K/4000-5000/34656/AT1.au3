########################################################################
# AT1.au3
########################################################################
Local $GUI = GUICreate("", 500, 200, 1, 200)
Local $GUI_Line1 = GUICtrlCreateLabel("---", 20,  0, 500, 32)
Local $GUI_Line2 = GUICtrlCreateLabel("---", 20, 16, 500, 32)
Local $GUI_Line3 = GUICtrlCreateLabel("---", 20, 32, 500, 32)
HotKeySet("{ESC}", "terminate")
########################################################################
GUISetState() 

Local $c1=0, $t=0

runAdlib() 

Main()

########################################################################
Func Main()
Local $c
  while(true)
       $c += 1
       GUICtrlSetData($GUI_Line3, StringFormat("main=%d", $c))
       sleep(100)
  wend
EndFunc
########################################################################
Func runAdlib() 
Local $d, $p, $b, $f=25000000
  $d = TimerDiff($t)
  $p = TimerInit()
  AdlibUnRegister("runAdlib")
  $d /= 1000
  FileWriteLine("AT1.log", "")
  $b = StringFormat("runAdlib-in after=%.6f", $d)
  printLog($b)
  GUICtrlSetData($GUI_Line1, $b)
  $c1 += 1
  GUICtrlSetData($GUI_Line2, StringFormat("Adlib=%d", $c1))
  for $i = 1 to $f
  next
  AdlibRegister("runAdlib", 2000)
  $t = TimerInit()
  printLog(StringFormat("runAdlib-out elapsed=%.3f", TimerDiff($p)/1000))
  return
EndFunc
########################################################################
Func printLog($msg)
  FileWriteLine("AT1.log", @HOUR&":"&@MIN&":"&@SEC&"."&@MSEC &" " &$msg)
  return
EndFunc
########################################################################
Func terminate()
  exit
EndFunc
########################################################################
