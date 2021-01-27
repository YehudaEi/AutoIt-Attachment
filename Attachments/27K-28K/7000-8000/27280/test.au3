#Include "Constants.au3"
#Include "memstats.au3"
#Include "String.au3"
#Include "config.au3"
#include "ButtonConstants.au3"
#include "EditConstants.au3"
#include "GUIConstantsEx.au3"
#include "WindowsConstants.au3"
#include "CompInfo.au3"
;#include "Array.au3"
#include "GUIListBox.au3"
#include "GUIListView.au3"
#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

;----------------------------Computer Info----------------------------------------------
;Drive Info
;Testing ListBox for Drive
#Region ### START Koda GUI section ### Form=
GUICreate("Drive List", 740, 443, 1222, 890)
$ListBoxName = GUICtrlCreateListView("", 16, 8, 710, 422)
_GUICtrlListView_AddColumn($ListBoxName,"Number",100)
_GUICtrlListView_AddColumn($ListBoxName,"Label",100)
_GUICtrlListView_AddColumn($ListBoxName,"Drive",100)
_GUICtrlListView_AddColumn($ListBoxName,"FileSystem",100)
_GUICtrlListView_AddColumn($ListBoxName,"SerialNumber",100)
_GUICtrlListView_AddColumn($ListBoxName,"Free Space",100)
_GUICtrlListView_AddColumn($ListBoxName,"Total Space",100)

	Dim $Drives
	_ComputerGetDrives($Drives) ;Defaults to "FIXED"
	For $i = 1 To $Drives[0][0] Step 1
		_GUICtrlListView_AddItem($ListBoxName, "Drive #" & $i, $i)
		_GUICtrlListView_AddSubItem($ListBoxName, $i, $Drives[$i][2], 1, 1)
		_GUICtrlListView_AddSubItem($ListBoxName, $i, $Drives[$i][0], 2, 2)
		_GUICtrlListView_AddSubItem($ListBoxName, $i, $Drives[$i][1], 3, 3)
		_GUICtrlListView_AddSubItem($ListBoxName, $i, $Drives[$i][3], 4, 4)
		_GUICtrlListView_AddSubItem($ListBoxName, $i, Round($Drives[$i][4]/1024,2) & "GB", 5, 5)
		_GUICtrlListView_AddSubItem($ListBoxName, $i, Round($Drives[$i][5]/1024,2) & "GB", 6, 6)
	Next
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		Exit
	EndSwitch
WEnd