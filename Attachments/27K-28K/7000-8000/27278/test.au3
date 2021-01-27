#Include "Constants.au3"
#Include "memstats.au3"
#Include "String.au3"
#Include "config.au3"
#include "ButtonConstants.au3"
#include "EditConstants.au3"
#include "GUIConstantsEx.au3"
#include "WindowsConstants.au3"
#include "CompInfo.au3"
#include "Array.au3"
#include <GUIListBox.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

;----------------------------Computer Info----------------------------------------------
;Drive Info
$computerDrives = TrayCreateMenu("Hard Drives")
	TrayCreateItem("", $computerDrives)
	Dim $Drives
	_ComputerGetDrives($Drives) ;Defaults to "FIXED"
	Dim $totalDrives
	For $totalDrives = 1 To $Drives[0][0] Step 1
		$totalDrives = $totalDrives + 1
	Next
	TrayCreateItem("", $computerDrives)
	TrayCreateItem("Total Drives Found: " & ($totalDrives - 1), $computerDrives)
	TrayCreateItem("", $computerDrives)
	For $i = 1 To $Drives[0][0] Step 1
		TrayCreateItem("-------------DRIVE #" & $i & "----------------", $computerDrives)
		TrayCreateItem("Label: " & $Drives[$i][2], $computerDrives)
		TrayCreateItem("Drive: " & $Drives[$i][0], $computerDrives)
		TrayCreateItem("FileSystem: " & $Drives[$i][1], $computerDrives)
		TrayCreateItem("SerialNumber: " & $Drives[$i][3], $computerDrives)
		TrayCreateItem("Free Space: " & Round($Drives[$i][4] / 1024, 2) & "GB", $computerDrives)
		TrayCreateItem("Total Space: " & Round($Drives[$i][5] / 1024, 2) & "GB", $computerDrives)
		TrayCreateItem("", $computerDrives)
	Next

;Testing ListBox for Drive
#Region ### START Koda GUI section ### Form=
$ListBoxFormName = GUICreate("Drive List", 633, 443, 1222, 890)
$ListBoxName = GUICtrlCreateList("", 16, 8, 609, 422)
_GUICtrlListView_SetView($ListBoxName, 5)
GUICtrlCreateListView("Menu Header", 16, 50, 50,10)
GUICtrlSetData(-1, "PS1|PS2|PS3|PS4|PS5|PF1|PF2|PF3|PF4|SS|DA")
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
_GUICtrlListBox_AddString($ListBoxName, "Test2")
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		Exit
	EndSwitch
WEnd