
#include <Process.au3>
#include <GUIConstants.au3>
#include <Array.au3>

Dim $guiwidth = 200, $guiheight = 100
Dim $PIDrecords

$myGUI = GUICreate("Test Priority", $guiwidth, $guiheight, -1, -1, $WS_overlappedwindow)

$PriorityInput = GUICtrlCreateInput("", 80, 10, 35, 20)
GUICtrlSetData(-1, 2)
$PriorityUpDown = GUICtrlCreateUpdown($PriorityInput)
GUICtrlSetLimit(-1, 5, 0)
GUICtrlSetTip(-1, "Click the Set button to reset the execution priority to selected value")
GUICtrlSetResizing($PriorityInput, $GUI_DOCKLEFT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)

$priorityLabel = GUICtrlCreateLabel("Priority:  "  , 130, 12, 70, 15)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
GUICtrlSetTip($priorityLabel, "Process priority - Actual")

$prioritySetButton = GUICtrlCreateButton("Set", 40, 10, 30, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
GUICtrlSetTip($prioritySetButton, "Click to set execution priority to selected value.")

$priorityOptionButton = GUICtrlCreateButton("? ", 26, 10, 12, 17)
GUICtrlSetTip($priorityOptionButton, "Click for execution priority options")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)

$PIDDisplayLabel = GUICtrlCreateLabel("PID", 26, 40, 40, 17)
$PIDDisplay = GUICtrlCreateLabel("", 56, 40, 40, 17)


GUISetState() ; show form

$PIDList = ProcessList("_Priority.exe")
;_ArrayDisplay($PIDList)
;MsgBox(0, "PID", $PIDList[$PIDList[0][0]][1])
$PID = $PIDList[$PIDList[0][0]][1]
GUICtrlSetData($PIDDisplay, $PID)
GUICtrlSetData($priorityLabel,"Priority: " & _ProcessGetPriority($PID))


While 1
	
	$msg = GUIGetMsg()
	

	Switch $msg

		Case $GUI_EVENT_CLOSE
			Exit
		

		Case $PriorityInput
			GUICtrlSetData($priorityLabel, "Priority:  " & _ProcessGetPriority($PID))
			
		Case $prioritySetButton
			$DesiredPriority = GUICtrlRead($PriorityInput)
			If $DesiredPriority = 5 Then $response = MsgBox(1, "Are you sure?", "Setting run priority to 5 (realtime) may make " & @CR & _
				"the system unstable. Are you sure?")
			If $DesiredPriority < 5 Or $response = 1 Then ProcessSetPriority($PID, $DesiredPriority)
			GUICtrlSetData($priorityLabel, "Priority:  " & _ProcessGetPriority($PID))
					
		Case $priorityOptionButton
			MsgBox(0, "Priority Options", "0 - Idle/Low" & @CR & _
				"1 - Below Normal (Not supported on Windows 95/98/ME)" & @CR & _
				"2 - Normal" & @CR & _
				"3 - Above Normal (Not supported on Windows 95/98/ME)" & @CR & _
				"4 - High" & @CR & _
				"5 - Realtime (Use with caution, may make the system unstable)")

	EndSwitch

WEnd
