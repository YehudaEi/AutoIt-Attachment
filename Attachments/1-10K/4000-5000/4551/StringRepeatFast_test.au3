#Include<String.au3>
#Include <StringRepeatFast.au3>
$Timer=TimerInit()
$X1=_StringRepeatFast("AAAA",4000)
$CT1=TimerDiff($Timer)
$Timer=TimerInit()
$X1=_StringRepeat("AAAA",4000)
$CT2=TimerDiff($Timer)
MsgBox(0,"Done","_StringDup()=" & $CT1 & @LF & "_StringRepeat()=" & $CT2)

