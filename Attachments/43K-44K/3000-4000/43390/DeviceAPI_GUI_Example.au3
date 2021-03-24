#include <GuiConstantsEx.au3>
#include <GuiTreeView.au3>
#include <TreeViewConstants.au3>
#Include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <GuiImageList.au3>
#include "DeviceAPI.au3"

Global $aAssoc[1][2]

$GUI = GUICreate("Device Management API - GUI Example", 800, 500)

Dim $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS)
$hTreeView = _GUICtrlTreeView_Create($GUI, 5, 5, 300, 450, $iStyle, $WS_EX_STATICEDGE )
$hListView = GUICtrlCreateListView ("Key|Value", 310, 5, 485,450)
GUISetState()

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

;Assign image list to treeview
_GUICtrlTreeView_SetNormalImageList($hTreeView, _DeviceAPI_GetClassImageList())

Dim $total_devices = 0

_DeviceAPI_GetClasses()
While _DeviceAPI_EnumClasses()

	;Get icon index from image list for given class
	$Icon_Index = _DeviceAPI_GetClassImageIndex($p_currentGUID)

	;Build list of devices within current class, if class doesn't contain any devices it will be skipped
	_DeviceAPI_GetClassDevices($p_currentGUID)

	;Skip classes without devices
	If _DeviceAPI_GetDeviceCount() > 0 Then

		;Add parent class to treeview
		$parent = _GUICtrlTreeView_Add($hTreeView, 0, _DeviceAPI_GetClassDescription($p_currentGUID), $Icon_Index, $Icon_Index)

		;Loop through all devices by index
		While _DeviceAPI_EnumDevices()

			$description = _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DEVICEDESC)
			$friendly_name = _DeviceAPI_GetDeviceRegistryProperty($SPDRP_FRIENDLYNAME)

			;If a friendly name is available, use it instead of description
			If $friendly_name <> "" Then $description = $friendly_name

			;Add device to treeview below parent
			$handle = _GUICtrlTreeView_AddChild($hTreeView, $parent, $description, $Icon_Index, $Icon_Index)

			If $total_devices > 0 Then
				ReDim $aAssoc[$total_devices+1][2]
			EndIf

			;Add treeview item handle to array along with device Unique Instance Id (For lookup)
			$aAssoc[$total_devices][0] = $handle
			$aAssoc[$total_devices][1] = _DeviceAPI_GetDeviceId()

			;Update running total count of devices
			$total_devices += 1
		WEnd
	EndIf
WEnd

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop
	EndSwitch
WEnd

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndTreeview

	$hWndTreeview = $hTreeView
	If Not IsHWnd($hTreeView) Then $hWndTreeview = GUICtrlGetHandle($hTreeView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndTreeview
			Switch $iCode
				Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
					RefreshDeviceProperties()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

;Triggered when a device is selected in the treeview
Func RefreshDeviceProperties()
	Local $hSelected = _GUICtrlTreeView_GetSelection($hTreeView)

	;Don't do anything if a class name (root item) was clicked
	If _GUICtrlTreeView_Level($hTreeView, $hSelected) = 0 Then Return

	;Lookup treeview item handle in global array
	For $X = 0 to Ubound($aAssoc)-1

		If $hSelected = $aAssoc[$X][0] Then
			;MsgBox(0,"", "Handle: " & $aAssoc[$X][0] & @CRLF & "Unique Instance Id: " & $aAssoc[$X][1])

			;Build list of ALL device classes
			_DeviceAPI_GetClassDevices()

			;Loop through all devices by index
			While _DeviceAPI_EnumDevices()
				If $aAssoc[$X][1] = _DeviceAPI_GetDeviceId() Then

					;Empty listview
					_GUICtrlListView_DeleteAllItems($hListView)

					GUICtrlCreateListViewItem ("Hardware ID: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_HARDWAREID), $hListView )
					GUICtrlCreateListViewItem ("Unique Instance ID: |" & _DeviceAPI_GetDeviceId(), $hListView )
					GUICtrlCreateListViewItem ("Manufacturer: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_MFG), $hListView )
					GUICtrlCreateListViewItem ("Driver: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DRIVER), $hListView )
					GUICtrlCreateListViewItem ("Friendly Name: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_FRIENDLYNAME), $hListView )
					GUICtrlCreateListViewItem ("Physical Device Object Name: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_PHYSICAL_DEVICE_OBJECT_NAME), $hListView )
					GUICtrlCreateListViewItem ("Upper Filters: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_UPPERFILTERS), $hListView )
					GUICtrlCreateListViewItem ("Lower Filters: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_LOWERFILTERS), $hListView )
					GUICtrlCreateListViewItem ("Enumerator: |" & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_ENUMERATOR_NAME), $hListView )

					;Resize columns to fit text
					_GUICtrlListView_SetColumnWidth($hListView, 0,$LVSCW_AUTOSIZE)
					_GUICtrlListView_SetColumnWidth($hListView, 1,$LVSCW_AUTOSIZE)
				EndIf
			WEnd
		EndIf
	Next
EndFunc

;Cleanup image list
_DeviceAPI_DestroyClassImageList()

_DeviceAPI_DestroyDeviceInfoList() ;Cleanup for good measure
