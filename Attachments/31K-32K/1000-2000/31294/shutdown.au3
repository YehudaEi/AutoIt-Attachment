#comments-start
Shutdown Tool written by Reinn
Version: 1.0
Released: 27-07-2010
#comments-end

#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("{ESC}", "end")
HotKeySet("{F10}", "Start")

#Region ### START Koda GUI section ### Form=C:\Users\Jan\Documents\koda_1.7.2.2_b204_2010-02-04\Forms\Shutdown tool.kxf
$Form1_1 = GUICreate("Shutdown tool", 218, 105, 192, 124)
$Input1 = GUICtrlCreateInput("00", 40, 64, 25, 21)
$Input2 = GUICtrlCreateInput("10", 96, 64, 25, 21)
$Input3 = GUICtrlCreateInput("30", 152, 64, 25, 21)
$Label1 = GUICtrlCreateLabel("Hour(s)", 40, 48, 38, 17)
$Label2 = GUICtrlCreateLabel("Minute(s)", 88, 48, 47, 17)
$Label3 = GUICtrlCreateLabel("Second(s)", 144, 48, 52, 17)
$Combo1 = GUICtrlCreateCombo("Shutdown in", 40, 16, 145, 25)
GUICtrlSetData(-1, "Shutdown at")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func Start()
If GUICtrlRead($Combo1) = "Shutdown in" Then
	countdown()
Else
	shutdownat()
EndIf
EndFunc

Func countdown()
	Dim $Total = GUICtrlRead($input1) * 60 * 60 + GUICtrlRead($input2) * 60 + GUICtrlRead($input3)


	For $s = $Total To 0 Step -1
		Sleep(1000)

		$Tseconds=$s
		$hours = int($Tseconds/3600)
		$Remsecs = $Tseconds - ($hours * 3600)
		$minutes = int($Remsecs / 60)
		$Seconds = $Remsecs - ($minutes * 60)

		$TT = ToolTip("System will shutdown in " & $hours & " hour(s), " & $minutes & " minute(s) and " & $Seconds & " second(s)." & @CRLF & "To cancel shutdown and exit the script press the ESCAPE key.", 50, 50, "Countdown until shutdown" & @CRLF & "This script has been written by Reinn. Educational purposes only, all rights reserved - 2010.", 1)
	Next

	Sleep($Total)
	Dim $TT = ToolTip("")

	MsgBox(0, "Shutdown", "Your system is shutting down.", 5000)
	Shutdown(9)

	Exit
EndFunc

Func shutdownat()
	Dim $shutat = GUICtrlRead($input1) * 60 * 60 + GUICtrlRead($input2) * 60 + GUICtrlRead($input3)
	Dim $timenow = @Hour * 60 * 60 + @MIN * 60 + @SEC
	Dim $shutin = $shutat - $timenow

	For $s = $shutin To 0 Step -1 		; Tooltip Countdown
		Sleep(1000)

		$Tseconds=$s
		$hours = int($Tseconds/3600)
		$Remsecs = $Tseconds - ($hours * 3600)
		$minutes = int($Remsecs / 60)
		$Seconds = $Remsecs - ($minutes * 60)

		$TT = ToolTip("System will shutdown in " & $hours & " hour(s), " & $minutes & " minute(s) and " & $Seconds & " second(s)." & @CRLF & "To cancel shutdown and exit the script press the ESCAPE key.", 50, 50, "Countdown until shutdown" & @CRLF & "This script has been written by Reinn. Educational purposes only, all rights reserved - 2010.", 1)
	Next

	Sleep($shutin)
	Dim $TT = ToolTip("")

	MsgBox(0, "Shutdown", "Your system is shutting down.", 5000)
	Shutdown(9)

EndFunc

Func end()
	Exit
EndFunc