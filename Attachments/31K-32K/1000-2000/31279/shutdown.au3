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
	$hour = 1000 * 60 * 60
	$min = 1000 *60
	$sec = 1000

	;Dim $Total = GUICtrlRead($input1) * $hour + GUICtrlRead($input2) * $min + GUICtrlRead($input3) * $sec   ;I thought it had to be like this, but because it already sleep($sec) each time, then you don't have to * 1000 on both Hours, Minutes and Seconds.
	Dim $Total = GUICtrlRead($input1) * 60 * 60 + GUICtrlRead($input2) * 60 + GUICtrlRead($input3)

	For $s = $Total To 0 Step -1 		; Seconds left
		Sleep($sec)
		$TT = ToolTip("System will shutdown in " & $s & " seconds!", 50, 50, "Countdown until shutdown", 1)
	Next

	Sleep($Total)
	Dim $TT = ToolTip("")

	MsgBox(0, "Shutdown", "Your system is shutting down.", 5 * $sec)

	Exit

	;For $h = GUICtrlRead($input1) To 0 Step -1       ; Timer for hours
	;	Sleep(1000)
		;Sleep($hour)							;
	;	GUICtrlSetData($input1, $h)
	;Next		;here ends the timer

	;For $m = GUICtrlRead($input2) To 0 Step -1		; Timer for minutes
	;	Sleep($min)
	;	GUICtrlSetData($input2, $m)
	;Next
	;
EndFunc

Func shutdownat()
	For $s = GUICtrlRead($input3) To 0 Step -1
		Sleep(1000)
		Tooltip($s, 50, 50, "Countdown", 1)
	Next

If @HOUR = GUICtrlRead($input1) And @MIN = GUICtrlRead($input2) Then
			MsgBox(1, "Shutdown", "Shutdown would happen now!")
		EndIf
EndFunc

Func end()
	Exit
EndFunc