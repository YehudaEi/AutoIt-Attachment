#include <Constants.au3>
Run("clickme.exe", @ScriptDir, @SW_HIDE)
msgbox(0,"","Start sending click")
For $a  = 1 To 20
	ControlClick ( "click me", "", 3 , "left", 1  )
	If $a = 1 Then WinSetState ( "click me", "", @SW_MINIMIZE  ) ;your target is sent to bkground
	Sleep(500) ;this delay is for demo only, can be taken away or adjust duration
Next
MsgBox(0, "Done!", "clickme.exe should be closed" )
