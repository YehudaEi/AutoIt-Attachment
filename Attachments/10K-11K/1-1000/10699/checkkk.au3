;GUISortCheckIdx.au3 0_2
;~ #include "_GuiCtrlListViewIMG.au3"
;~ #include "_GuiCtrlListView.au3"
#include "_ArrayView2D1D.au3"
Local $ar_SetCheckboxes[1], $ar_isChecked [1]
Global $line
$line = "1"
$searchdir = "c:\"
$s_NewDir = $searchdir & "backup"
$searchfile = "*.txt"
$timerstampS = TimerInit()
$gui = GUICreate("TEST APP!", 392, 322, -1, -1, $WS_CAPTION + $WS_POPUP + $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX);+$WS_MAXIMIZE)
$Btn_Get = GUICtrlCreateButton("Get From Index 2", 150, 200, 90, 40)
;===================================================================
_GUISetCheckBoxesPresent(2);******************************
$listview = _GUICtrlCreateListViewIndexed("Column 1        ",40, 30, 310, 149,$LVS_EX_CHECKBOXES+$LVS_EX_GRIDLINES)
;===================================================================
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
RunWait(@ComSpec & ' /c DIR "' & $searchdir & '" /A-D /B  ' & $searchfile & ' > %TEMP%\checkfiles.tmp', $searchdir, @SW_HIDE)
ConsoleWrite("DOS :" & Round(TimerDiff($timerstampS)) & " mseconds " & @LF)
$timerstampS = TimerInit()
local $aArray
_FileReadToArray(@TempDir & "\checkfiles.tmp",$aArray)
for $i= 1 to UBound($aArray)-1
	_GUICtrlCreateListViewItem($aArray[$i],$listview,$searchdir,1,1)
next
If $i_GUISetCheckBoxes=2 Then 	_GUICtrlListViewSetCheckState($listview, -1, 1)
_GUICtrlListViewHideColumn ($listview, _GUICtrlListViewGetSubItemsCount($listview)-1)
GUISetState(@SW_SHOW, $gui)
ConsoleWrite("LV :" & Round(TimerDiff($timerstampS)) & " mseconds " & @LF)
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Btn_Get ; set up a button
			$timerstampSt = TimerInit()
			$a = 0
			ReDim $ar_isChecked [_GUICtrlListViewGetItemCount($listview) ]
			For $i = 0 To _GUICtrlListViewGetItemCount($listview) - 1
				If _GUICtrlListViewGetCheckedState($listview, $i) Then
					$ar_isChecked [$a] = __GUICtrlListViewGetItemText($listview, $i, 0)
					$a += 1
				EndIf
			Next
			ConsoleWrite("GET :" & Round(TimerDiff($timerstampSt)) & " mseconds " & @LF)
			if not $a then ReDim $ar_isChecked [1]
			if $a then 
				ReDim $ar_isChecked [$a]
				_FileWriteFromArray(@ScriptDir & "\ar_isChecked.txt", $ar_isChecked)
				RunWait("notepad " & @ScriptDir & "\ar_isChecked.txt")
;~ 				_GUISetCheckBoxesPresent(0);******************************
;~ 				_ArrayView2D1D ($ar_isChecked, "$ar_isChecked", 1)
;~ 				_ArrayDisplay($ar_isChecked, "$ar_isChecked")
				For $a = 0 To UBound($ar_isChecked) - 1
;~ 					If FileExists($ar_isChecked[$a]) Then FileCopy($ar_isChecked[$a], $s_NewDir)
				Next
;~ 				exit
			EndIf
		Case $msg = $listview
			__GUICtrlListViewSort ($listview, -1, GUICtrlGetState($listview))
	EndSelect
WEnd
