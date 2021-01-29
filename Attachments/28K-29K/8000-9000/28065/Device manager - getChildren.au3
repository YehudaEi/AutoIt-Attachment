;
; The script opens the Device manager, 
; locates a sub-device under a given device
; and opens it's properties dialog, Details tab
; Then it selects a combo box and gets all info for it
;

#include "DeviceManagerBasic.au3"

$device_name = "Digitizers"
$separator = ';'

if CheckNumberOfParameters($CmdLine,2, "DeviceName Separator") = 1 Then
	 $device_name = $CmdLine[1]
	 $separator = $CmdLine[2]
EndIf
	 
OpenDeviceManager()
FindComponent($device_name, True)
PrintAllChildren()
;WinClose($title)
CloseAll()


Func PrintAllChildren()
		$child_count = _GUICtrlTreeView_GetChildCount($tree,$branch)
		$current_child = _GUICtrlTreeView_GetFirstChild($tree,$branch)
		For $count = 1 To $child_count
			$name = _GUICtrlTreeView_GetText($tree,$current_child)
			print($name  & $separator)
			$current_child = _GUICtrlTreeView_GetNextChild($tree, $current_child)
		Next
EndFunc

Exit  

