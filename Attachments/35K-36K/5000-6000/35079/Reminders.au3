#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <Array1.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
Opt("TrayMenuMode", 1)
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Reminders", 400, 318, 303, 123)
GUISetCursor(3)
GUISetBkColor(0x0A246A)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$List1 = GUICtrlCreateList("", 160, 8, 233, 305, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $WS_HSCROLL))
GUICtrlSetBkColor(-1, 0x0A246A)
GUICtrlSetColor(-1, 0xFFFFFF)
$Date = GUICtrlCreateDate("", 8, 8, 146, 21, $WS_TABSTOP)
$Time = GUICtrlCreateDate("", 8, 32, 146, 21, BitOR($DTS_UPDOWN, $DTS_TIMEFORMAT, $WS_TABSTOP))
$Edit1 = GUICtrlCreateEdit("", 8, 64, 145, 129, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "")
$Add = GUICtrlCreateButton("Add", 40, 216, 75, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Button1Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Global $File = @ScriptDir & "\Reminders.ini"
Global $n = 0

_OpeningFunction()

While 1
	Sleep(100)
WEnd

Func _OpeningFunction()
	If FileExists($File) Then
		Global $dateList = IniReadSectionNames($File)
		Local $dateList2D[$dateList[0]][3]
		For $k = 1 To $dateList[0]
			$selDate = StringSplit($dateList[$k], "/")
			$selDateYear = $selDate[3]
			$selDateMonth = $selDate[1]
			$selDateDay = $selDate[2]
			$dateList2D[$k - 1][0] = $selDateMonth
			$dateList2D[$k - 1][1] = $selDateDay
			$dateList2D[$k - 1][2] = $selDateYear
		Next
		$CurrentYear = @YEAR
		$CurrentMonth = Number(@MON)
		$CurrentDay = Number(@MDAY)
		_ArraySort($dateList2D, 0, 0, 0, 0)
		For $i = 1 To $dateList[0]
			If $dateList2D[$i - 1][2] = $CurrentYear Then
				If $dateList2D[$i - 1][0] = $CurrentMonth Then
					If $dateList2D[$i - 1][1] < $CurrentDay Then
						IniDelete($File, $dateList[$i])
					EndIf
					If $dateList2D[$i - 1][1] = $CurrentDay And $n = 0 Then
						$selMonth = IniReadSection($File, $dateList[$i])
						_GUICtrlListBox_BeginUpdate($List1)
						_GUICtrlListBox_InsertString($List1, "Today's Schedule")
						For $j = 1 To $selMonth[0][0]
							_GUICtrlListBox_InsertString($List1, $selMonth[$j][0] & "  " & $selMonth[$j][1])
						Next
						_GUICtrlListBox_UpdateHScroll($List1)
						_GUICtrlListBox_EndUpdate($List1)
					ElseIf $i >= $dateList[0] And $n = 0 Then
						_GUICtrlListBox_BeginUpdate($List1)
						_GUICtrlListBox_InsertString($List1, "No Scheduled Appointments Today")
						_GUICtrlListBox_UpdateHScroll($List1)
						_GUICtrlListBox_EndUpdate($List1)
					EndIf
					If $dateList2D[$i - 1][1] > $CurrentDay And $n = 1 Then
						$selMonth = IniReadSection($File, $dateList[$i])
						_GUICtrlListBox_BeginUpdate($List1)
						_GUICtrlListBox_InsertString($List1, "__________________________________")
						_GUICtrlListBox_InsertString($List1, $dateList[$i])
						_GUICtrlListBox_InsertString($List1, " ")
						For $j = 1 To $selMonth[0][0]
							_GUICtrlListBox_InsertString($List1, $selMonth[$j][0] & "  " & $selMonth[$j][1])
						Next
						_GUICtrlListBox_UpdateHScroll($List1)
						_GUICtrlListBox_EndUpdate($List1)
					EndIf
				ElseIf $dateList2D[$i - 1][0] > $CurrentMonth And $n = 2 Then
					$selMonth = IniReadSection($File, $dateList[$i])
					_GUICtrlListBox_BeginUpdate($List1)
					_GUICtrlListBox_InsertString($List1, "__________________________________")
					_GUICtrlListBox_InsertString($List1, $dateList[$i])
					_GUICtrlListBox_InsertString($List1, " ")
					For $j = 1 To $selMonth[0][0]
						_GUICtrlListBox_InsertString($List1, $selMonth[$j][0] & "  " & $selMonth[$j][1])
					Next
					_GUICtrlListBox_UpdateHScroll($List1)
					_GUICtrlListBox_EndUpdate($List1)
				EndIf
			EndIf
			If $i >= $dateList[0] Then
				$n = $n + 1
			EndIf
		Next
		If $n <= 3 Then
			_OpeningFunction()
		EndIf
	EndIf
EndFunc   ;==>_OpeningFunction

Func Button1Click() ; Add
	$setDate = GUICtrlRead($Date)
	$setTime = GUICtrlRead($Time)
	$setTimeSplit = StringSplit($setTime, ":")
	$AmPm = StringRight($setTime, 2)
	$setTimeHM = String($setTimeSplit[1] & ":" & $setTimeSplit[2] & " " & $AmPm)
	IniWrite($File, $setDate, $setTimeHM, GUICtrlRead($Edit1))
EndFunc   ;==>Button1Click
Func Form1Close()
	Exit
EndFunc   ;==>Form1Close
Func Form1Minimize()
	GUISetState(@SW_MINIMIZE)
EndFunc   ;==>Form1Minimize
Func Form1Restore()
	GUISetState(@SW_RESTORE)
EndFunc   ;==>Form1Restore