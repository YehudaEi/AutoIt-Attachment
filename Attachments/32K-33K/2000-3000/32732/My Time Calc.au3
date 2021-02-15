#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\Users\User\Desktop\Form1.kxf
Global $Form1 = GUICreate("TIME CALCULATOR", 375, 112, -1, -1)
GUISetIcon("C:\Program Files (x86)\AutoIt3\Icons\120px-Crystal_Clear_app_clock.ico", -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUIStartGroup()
Global $Label1 = GUICtrlCreateLabel("Start Time", 16, 8, 99, 28)
GUICtrlSetFont(-1, 16, 800, 4, "Times New Roman")
GUICtrlSetColor(-1, 0x008000)
Global $Label2 = GUICtrlCreateLabel("Stop Time", 124, 8, 95, 28)
GUICtrlSetFont(-1, 16, 800, 4, "Times New Roman")
GUICtrlSetColor(-1, 0xFF0000)
Global $Label3 = GUICtrlCreateLabel("Elapsed Time", 232, 8, 124, 28)
GUICtrlSetFont(-1, 16, 800, 4, "Times New Roman")
GUICtrlSetColor(-1, 0x0000FF)
Global $Input1 = GUICtrlCreateInput("00:00", 13, 32, 73, 29)
GUICtrlSetFont(-1, 14, 400, 0, "Times New Roman")
GUICtrlSetOnEvent(-1, "Input1Change")
GUICtrlSetTip(-1, "ENTER YOUR TIME AS FOLLOWS '00:00'")
Global $Input2 = GUICtrlCreateInput("00:00", 119, 32, 89, 29)
GUICtrlSetFont(-1, 14, 400, 0, "Times New Roman")
GUICtrlSetOnEvent(-1, "Input2Change")
GUICtrlSetTip(-1, "ENTER YOUR TIME AS FOLLOWS '00:00'")
Global $Input3 = GUICtrlCreateInput("0.00", 230, 32, 81, 29)
GUICtrlSetFont(-1, 14, 400, 0, "Times New Roman")
GUICtrlSetOnEvent(-1, "Input3Change")
GUICtrlSetState(-1, $GUI_DISABLE)
Global $Button1 = GUICtrlCreateButton("CALC", 16, 72, 81, 25)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Button1Click")
Global $Button2 = GUICtrlCreateButton("EXIT", 267, 72, 89, 25)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Button2Click")
GUIStartGroup()
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetLimit($Input1, 5)
GUICtrlSetLimit($Input2, 5)
GUICtrlSetLimit($Input3, 5)
GUICtrlSetTip($Input1, "ENTER YOUR TIME AS FOLLOWS '00:00'")
GUICtrlSetTip($Input2, "ENTER YOUR TIME AS FOLLOWS '00:00'")
GUICtrlSetTip($Input3, "DO NOT ENTER ANY INFORMATION HERE.")



$totalminutes = 0
While 1
	Sleep(100)
WEnd

Func Button1Click()
	$start_time = GUICtrlRead($Input1)
	$stop_time = GUICtrlRead($Input2)
	$stop_minutes = computeminutes($stop_time)
	$start_minutes = computeminutes($start_time)

	If $stop_minutes < $start_minutes Then
		$totalminutes = computeminutes($stop_time) + (12 * 60) - computeminutes($start_time)
	Else
		$totalminutes = computeminutes($stop_time) - computeminutes($start_time)
	EndIf

	GUICtrlSetData($Input3, Round($totalminutes / 60, 2))
EndFunc   ;==>Button1Click
Func Button2Click()
	Exit
EndFunc   ;==>Button2Click
Func Form1Close()
	Exit
EndFunc   ;==>Form1Close
Func Input1Change()

EndFunc   ;==>Input1Change
Func Input2Change()

EndFunc   ;==>Input2Change
Func Input3Change()

EndFunc   ;==>Input3Change


MsgBox(0, "TOAL MINUTES ELAPSED", "TOTALMINUTES: " & $totalminutes)
MsgBox(0, "TOTAL MINUTES ELAPSED", "TOTAL MINUTES ELAPSED: " & $totalminutes & @CRLF & "tenths = " & $totalminutes / 60)



Exit

Func computeminutes($y)
	$m = StringLen($y)
	$colonsearch = StringInStr($y, ":")

	If StringLen($y) > 5 Or StringLen($y) < 4 Then
		ConsoleWrite("ERROR REENTER TIME INFORMATION" & StringLen($y))
		MsgBox(0, "TIME ENTRY ERROR", "TIME STRING INVALID!  Your entry was: " & $y & @CRLF)
	Else
		Select
			Case $colonsearch = 2
				ConsoleWrite("$colonsearch = " & $colonsearch & @CRLF)
			Case $colonsearch = 3
				ConsoleWrite("$colonsearch = " & $colonsearch & @CRLF)
			Case $colonsearch - 1 >= 3 Or $m - $colonsearch >= 3
				ConsoleWrite("CASE error reenter string" & StringLen($y) & @CRLF)
				MsgBox(0, "TIME ENTRY ERROR", "CASE error reenter string")
			Case Else
				ConsoleWrite("CASE error reenter string" & StringLen($y) & @CRLF)
				MsgBox(0, "TIME ENTRY ERROR", "CASE error reenter string")
		EndSelect
	EndIf
	$hour = StringLeft($y, $colonsearch - 1)
	$hourstominutes = $hour * 60
	ConsoleWrite("$hourstominutes = " & $hourstominutes & @CRLF)

	$straightminutes = StringRight($y, 2) * 1
	ConsoleWrite("$straightminutes = " & $straightminutes & @CRLF)
	Return $hourstominutes + $straightminutes
EndFunc   ;==>computeminutes
Exit