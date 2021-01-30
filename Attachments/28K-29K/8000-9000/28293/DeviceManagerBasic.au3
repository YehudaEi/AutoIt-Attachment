;
; The script opens the Device manager, 
; locates a sub-device under a given device
; and opens it's properties dialog
;



#include "GuiTreeView.au3"
#include "GuiTab.au3"
#include "GuiComboBox.au3" 
#include "GuiListView.au3"
#include "GuiButton.au3"

$stdout = False

$title = 'Device Manager'
$sub_window_title = ''
$tree = ''
$branch = ''
$sub_device = ''
$separator = "%%%"
$sub_device_index=1
;OpenProperties($component,$sub_window,"Details")  
	
	
Func CheckNumberOfParameters($parameters, $expectedNum, $usage_message)
	if $parameters[0] < $expectedNum Then
		MsgBox(0, "Error","Usage: <script>  " & $usage_message & ',  Using default values')
		Return -1
	EndIf
	$stdout = True
	Return 1
EndFunc



Func OpenDeviceManager()
	Run(@ComSpec & ' /c ' & 'devmgmt.msc', '', @SW_HIDE)
	WinActivate($title)
	WinWait($title)
EndFunc



Func FindComponent($device_name, $expand)
	$tree = ControlGetHandle($title,'','[Class:SysTreeView32;Instance:1]')
	$branch = _GUICtrlTreeView_FindItem($tree,$device_name)


	If $branch <> 0 Then
		If $expand = True Then
			_GUICtrlTreeView_Expand($tree,$branch)
		EndIf
	EndIf
EndFunc


Func OpenProperties($device_name, $sub_device_name, $tab_name)
	OpenProperties2($device_name, $sub_device_name, 1,$tab_name)
EndFunc


Func OpenProperties2($device_name, $sub_device_name, $sub_device_index, $tab_name)
	OpenDeviceManager()
	FindComponent($device_name, True)
	
	If $branch <> 0 Then
		
		GetTreeHandleByIndex($branch, $sub_device_name, $sub_device_index)
		if $sub_device = 0 Then
			print("ERROR - couldn't find sub device: " & $sub_device_name)
			CloseAll()
			Exit
			EndIf
		
		_GUICtrlTreeView_ClickItem($tree,$sub_device,'left', False, 2);
		$sub_window_title = $sub_device_name & ' Properties'
		WinWait($sub_window_title)
			
		$tab_main = ControlGetHandle($sub_window_title,'','[CLASS:SysTabControl32; INSTANCE:1]')
		$requested_tab = _GUICtrlTab_FindTab($tab_main,$tab_name)
		_GUICtrlTab_ClickTab($tab_main,$requested_tab)
	EndIf
	
EndFunc

; Get a branch in the device manager (for example: Digitizers), a name of a child to find and an index.
; index = 1 is first child
Func GetTreeHandleByIndex($branch, $name, $index)
	$counter = 0
	$child_count = _GUICtrlTreeView_GetChildCount($tree,$branch)
	$sub_device = _GUICtrlTreeView_GetFirstChild($tree,$branch)
	For $count = 1 To $child_count
		$child_name= _GUICtrlTreeView_GetText($tree,$sub_device)
		If $child_name = $name Then
			$counter = $counter + 1
		EndIf
		If $counter = $index Then
			ExitLoop
		EndIf
		
		$sub_device = _GUICtrlTreeView_GetNextChild($tree, $sub_device)
	Next
EndFunc


Func CloseAll()
	WinClose($sub_window_title)
	If ($sub_window_title <> '' And  WinExists($sub_window_title) = 1) Then
		WinWaitClose($sub_window_title)
	EndIf
	WinClose($title)
EndFunc



Func Print($var)
	If $stdout = False Then
		MsgBox(0, "Information", $var)
	Else
		ConsoleWrite($var)
	EndIf
EndFunc
  

