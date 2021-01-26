#include <Constants.au3>
#include <File.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <WinAPI.au3>
#include <GuiListView.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global Const $NULL = Chr(0)
Global Const $INVALID_HANDLE_VALUE = Ptr(0xFFFFFFFF); invalid ptr value
Global Const $STORAGE_DEVICE_NUMBER = "ulong DeviceType;ulong DeviceNumber;ulong PartitionNumber"
Global Const $IOCTL_STORAGE_GET_DEVICE_NUMBER = 0x2D1080
Global Const $CR_SUCCESS = 0x0
Global Const $DN_REMOVABLE = 0x4000
Global Const $CM_REMOVE_NO_RESTART = 0x2
Global Const $CR_ACCESS_DENIED = 0x33
Global Const $PNP_VetoTypeUnknown = 0 ; Name is unspecified
Global Const $DRIVE_REMOVABLE = 2
Global Const $DRIVE_FIXED = 3
Global Const $DRIVE_CDROM = 5
Global Const $DIGCF_PRESENT = 0x2
Global Const $DIGCF_DEVICEINTERFACE = 0x10
Global Const $SP_DEV_BUF = "byte[1024]"
Global Const $SP_DEVICE_INTERFACE_DETAIL_DATA = "dword cbSize;char DevicePath[1020]"
Global Const $SP_DEVICE_INTERFACE_DATA = "dword cbSize;byte InterfaceClassGuid[16];dword Flags;ptr Reserved"
Global Const $SP_DEVINFO_DATA = "dword cbSize;byte ClassGuid[16];dword DevInst;ptr Reserved"
Global $Clicked_Item

$guidDisk = DllStructCreate($tagGUID)
DllStructSetData($guidDisk, "Data1", 0x53f56307)
DllStructSetData($guidDisk, "Data2", 0xb6bf)
DllStructSetData($guidDisk, "Data3", 0x11d0)
DllStructSetData($guidDisk, "Data4", Binary("0x94f200a0c91efb8b"))
$guidCDROM = DllStructCreate($tagGUID)
DllStructSetData($guidCDROM, "Data1", 0x53f56308)
DllStructSetData($guidCDROM, "Data2", 0xb6bf)
DllStructSetData($guidCDROM, "Data3", 0x11d0)
DllStructSetData($guidCDROM, "Data4", Binary("0x94f200a0c91efb8b"))
$guidFloppy = DllStructCreate($tagGUID)
DllStructSetData($guidFloppy, "Data1", 0x53f56311)
DllStructSetData($guidFloppy, "Data2", 0xb6bf)
DllStructSetData($guidFloppy, "Data3", 0x11d0)
DllStructSetData($guidFloppy, "Data4", Binary("0x94f200a0c91efb8b"))


$GUI1 = GUICreate("Shutdown Sequence", 361, 246, 192, 124)
$Button_Shutdown = GUICtrlCreateButton("Shutdown", 15, 15, 100, 50)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Button_Logoff = GUICtrlCreateButton("Log Off", 130, 15, 100, 50)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Button_Restart = GUICtrlCreateButton("Restart", 245, 15, 100, 50)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Checkbox_Eject = GUICtrlCreateCheckbox("Eject Drives", 39, 88, 125, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlCreateLabel("Run on Shutdown", 0, 120, 360, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Checkbox_Page = GUICtrlCreateCheckbox("Clear Page File", 199, 88, 125, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$ListView_Run = GUICtrlCreateListView("Program|Parameters", 15, 145, 330, 85, BitOR($LVS_REPORT, $LVS_SINGLESEL, _
		$LVS_SHOWSELALWAYS, $WS_HSCROLL, $WS_VSCROLL), BitOR($LVS_EX_FULLROWSELECT, $WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 230)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 96)
GUISetState()
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

$ContextMenu = GUICtrlCreateContextMenu($ListView_Run)
$Context_Add = GUICtrlCreateMenuItem("Add Item", $ContextMenu)
$Context_Delete = GUICtrlCreateMenuItem("Delete Item", $ContextMenu)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button_Logoff, $Button_Restart, $Button_Shutdown
			If IsChecked($Checkbox_Eject) Then Eject_All_Drives()
			If IsChecked($Checkbox_Page) Then RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management", "ClearPageFileAtShutdown", "REG_DWORD", 1)
			AutoRun()
			ContinueCase
		Case $Button_Logoff
			Shutdown(0 + 16)
			Exit
		Case $Button_Restart
			Shutdown(2 + 16)
			Exit
		Case $Button_Shutdown
			Shutdown(1 + 16)
			Exit
		Case $Context_Add
			GUISetState(@SW_DISABLE, $GUI1)
			Local $File = ""
			$GUI2 = GUICreate("Add Item...", 276, 87, 192, 124, BitOR($WS_POPUPWINDOW, $WS_CAPTION))
			$Button_File = GUICtrlCreateButton("Select File", 52, 46, 75, 25)
			$Input_Param = GUICtrlCreateInput("", 15, 16, 245, 21)
			GUICtrlSetData($Input_Param, "Parameters")
			GUICtrlSetColor($Input_Param, 0x808080)
			$Button_OK = GUICtrlCreateButton("OK", 144, 46, 75, 25, $BS_DEFPUSHBUTTON)
			GUISetState()
			GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						ExitLoop
					Case $Button_File
						$File = FileOpenDialog("Select File", @DesktopDir, "All Files (*.*)", 7, "", $GUI2)
						If Not @error Then $Item = $File
					Case $Button_OK
						If $File <> "" Then
							If GUICtrlRead($Input_Param) = "Parameters" Then GUICtrlSetData($Input_Param, "")
							$Index = _GUICtrlListView_AddItem($ListView_Run, $Item)
							_GUICtrlListView_AddSubItem($ListView_Run, $Index, GUICtrlRead($Input_Param), 1)
							ExitLoop
						Else
							MsgBox(262192, "ERROR", "You have not selected a file to run yet!", 0, $GUI2)
						EndIf
				EndSwitch
			WEnd
			GUIRegisterMsg($WM_COMMAND, "")
			GUIDelete($GUI2)
			GUISetState(@SW_ENABLE, $GUI1)
			WinActivate($GUI1)
		Case $Context_Delete
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			_GUICtrlListView_SetItemText($ListView_Run, $Clicked_Item, "Test")
			_GUICtrlListView_DeleteItem($ListView_Run, $Clicked_Item)
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
			;Delete Item????????????????????????????????????????????????????????????????????????????????????????????????????????????
	EndSwitch
WEnd

Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
	Local $hWnd_ListView, $tNMHDR, $hWndFrom, $iCode

	$hWnd_ListView = $ListView_Run
	If Not IsHWnd($hWnd_ListView) Then $hWnd_ListView = GUICtrlGetHandle($ListView_Run)

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")

	Switch $hWndFrom
		Case $hWnd_ListView
			Switch $iCode
				Case $NM_RCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					Local $iItem = DllStructGetData($tInfo, "Item")

					If $iItem = -1 Then ;right click off item
						GUICtrlSetState($Context_Delete, $GUI_DISABLE)
					Else
						GUICtrlSetState($Context_Delete, $GUI_ENABLE)
						Global $Clicked_Item = $iItem
					EndIf
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func IsChecked($control)
	Return BitAND(GUICtrlRead($control), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>IsChecked

Func AutoRun()
	Local $line1 = "", $line2 = ""
	$Count = _GUICtrlListView_GetItemCount($ListView_Run)
	For $x = 0 To $Count - 1
		Run('"' & _GUICtrlListView_GetItemText($ListView_Run, $x, 0) & '" ' & _GUICtrlListView_GetItemText($ListView_Run, $x, 1))
		If @error Then
			_FileWriteLog(@ScriptDir & "\Shutdown Log.txt", "The command " & '"' & _GUICtrlListView_GetItemText($ListView_Run, $x, 0) & '"' & " " & _GUICtrlListView_GetItemText($ListView_Run, $x, 1) & "has failed.")
		Else
			ProcessWaitClose(StringTrimLeft(_GUICtrlListView_GetItemText($ListView_Run, $x, 0), StringInStr(_GUICtrlListView_GetItemText($ListView_Run, $x, 0), "\")), 15)
		EndIf
	Next
EndFunc   ;==>AutoRun

Func _EjectDrive($drive)
	$szRootPath = $drive & ":\"
	$szDevicePath = $drive & ":"
	$szVolumeAccessPath = "\\.\" & $drive & ":"
	$DeviceNumber = -1
	$hVolume = DllCall("kernel32.dll", "ptr", "CreateFile", "str", $szVolumeAccessPath, "dword", 0, _
			"dword", BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), "ptr", $NULL, "dword", $OPEN_EXISTING, _
			"dword", 0, "ptr", $NULL)
	$hVolume = $hVolume[0]
	If $hVolume == $INVALID_HANDLE_VALUE Then Return 1
	$sdn = DllStructCreate($STORAGE_DEVICE_NUMBER)
	$res = DllCall("kernel32.dll", "int", "DeviceIoControl", "ptr", $hVolume, "dword", $IOCTL_STORAGE_GET_DEVICE_NUMBER, _
			"ptr", $NULL, "dword", 0, "ptr", DllStructGetPtr($sdn), "dword", DllStructGetSize($sdn), _
			"dword*", "", "ptr", $NULL)
	If $res[0] Then $DeviceNumber = DllStructGetData($sdn, "DeviceNumber")
	$res = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hVolume)
	If Not $res[0] Then Return 1
	If $DeviceNumber == -1 Then Return 1
	$DriveType = DllCall("kernel32.dll", "uint", "GetDriveType", "str", $szRootPath)
	$DriveType = $DriveType[0]
	$res = DllCall("kernel32.dll", "dword", "QueryDosDevice", "str", $szDevicePath, "str", "", "dword", 260)
	If Not $res[0] Then Return 1
	$szDosDeviceName = $res[2]
	$DevInst = _GetDrivesDevInstByDeviceNumber($DeviceNumber, $DriveType, $szDosDeviceName)
	If $DevInst == 0 Then Return 1

	Return _DevInstEject($DevInst)
EndFunc   ;==>_EjectDrive

Func _GetDrivesDevInstByDeviceNumber($DeviceNumber, $DriveType, $szDosDeviceName)
	$IsFloppy = (StringInStr($szDosDeviceName, "\floppy") <> 0)
	Local $GUID
	Switch $DriveType
		Case $DRIVE_REMOVABLE
			If $IsFloppy Then
				$GUID = DllStructGetPtr($guidFloppy)
			Else
				$GUID = DllStructGetPtr($guidDisk)
			EndIf
		Case $DRIVE_FIXED
			$GUID = DllStructGetPtr($guidDisk)
		Case $DRIVE_CDROM
			$GUID = DllStructGetPtr($guidCDROM)
		Case Default
			Return 0
	EndSwitch
	$hDevInfo = DllCall("setupapi.dll", "ptr", "SetupDiGetClassDevs", "ptr", $GUID, "ptr", $NULL, "hwnd", $NULL, _
			"dword", BitOR($DIGCF_PRESENT, $DIGCF_DEVICEINTERFACE))
	$hDevInfo = $hDevInfo[0]
	If $hDevInfo == $INVALID_HANDLE_VALUE Then Return 0
	$dwIndex = 0
	$bRet = False
	$buf = DllStructCreate($SP_DEV_BUF)
	$pspdidd = DllStructCreate($SP_DEVICE_INTERFACE_DETAIL_DATA, DllStructGetPtr($buf))
	$spdid = DllStructCreate($SP_DEVICE_INTERFACE_DATA)
	$spdd = DllStructCreate($SP_DEVINFO_DATA)
	DllStructSetData($spdid, "cbSize", DllStructGetSize($spdid))
	While True
		$bRet = DllCall("setupapi.dll", "int", "SetupDiEnumDeviceInterfaces", "ptr", $hDevInfo, "ptr", $NULL, _
				"ptr", $GUID, "dword", $dwIndex, "ptr", DllStructGetPtr($spdid))
		If Not $bRet[0] Then ExitLoop
		$res = DllCall("setupapi.dll", "int", "SetupDiGetDeviceInterfaceDetail", "ptr", $hDevInfo, "ptr", DllStructGetPtr($spdid), _
				"ptr", $NULL, "dword", 0, "dword*", "", "ptr", $NULL)
		$dwSize = $res[5]
		If $dwSize <> 0 And $dwSize <= DllStructGetSize($buf) Then
			DllStructSetData($pspdidd, "cbSize", 5)
			_ZeroMemory(DllStructGetPtr($spdd), DllStructGetSize($spdd))
			DllStructSetData($spdd, "cbSize", DllStructGetSize($spdd))
			$res = DllCall("setupapi.dll", "int", "SetupDiGetDeviceInterfaceDetail", "ptr", $hDevInfo, "ptr", DllStructGetPtr($spdid), _
					"ptr", DllStructGetPtr($pspdidd), "dword", $dwSize, "dword*", "", "ptr", DllStructGetPtr($spdd))
			If $res[0] Then
				$hDrive = DllCall("kernel32.dll", "ptr", "CreateFile", "str", DllStructGetData($pspdidd, "DevicePath"), "dword", 0, _
						"dword", BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), "ptr", $NULL, "dword", $OPEN_EXISTING, _
						"dword", 0, "ptr", $NULL)
				$hDrive = $hDrive[0]
				If $hDrive <> $INVALID_HANDLE_VALUE Then
					$sdn2 = DllStructCreate($STORAGE_DEVICE_NUMBER)
					$res = DllCall("kernel32.dll", "int", "DeviceIoControl", "ptr", $hDrive, "dword", $IOCTL_STORAGE_GET_DEVICE_NUMBER, _
							"ptr", $NULL, "dword", 0, "ptr", DllStructGetPtr($sdn2), "dword", DllStructGetSize($sdn2), _
							"dword*", "", "ptr", $NULL)
					If $res[0] Then
						If $DeviceNumber == DllStructGetData($sdn2, "DeviceNumber") Then
							$res = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hDrive)
							$res = DllCall("setupapi.dll", "int", "SetupDiDestroyDeviceInfoList", "ptr", $hDevInfo)
							Return DllStructGetData($spdd, "DevInst")
						EndIf
					EndIf
					$res = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hDrive)
				EndIf
			EndIf
		EndIf
		$dwIndex += 1
	WEnd
	$res = DllCall("setupapi.dll", "int", "SetupDiDestroyDeviceInfoList", "ptr", $hDevInfo)

	Return 0
EndFunc   ;==>_GetDrivesDevInstByDeviceNumber

Func _DevInstEject($DevInst)
	$bSuccess = False
	$res = DllCall("setupapi.dll", "dword", "CM_Get_Parent", "dword*", "", "dword", $DevInst, "ulong", 0)
	If Not $res[0] == $CR_SUCCESS Then Return 1
	$DevInstParent = $res[1]
	$res = DllCall("setupapi.dll", "dword", "CM_Get_Device_IDW", "ptr", $DevInstParent, "wstr", "", "ulong", 1024, "ulong", 0)
	$res = DllCall("setupapi.dll", "dword", "CM_Get_DevNode_Status", "ulong*", "", "ulong*", "", "ptr", $DevInstParent, "ulong", 0)
	$IsRemovable = (BitAND($res[1], $DN_REMOVABLE) <> 0)
	For $tries = 1 To 3
		$res = DllCall("setupapi.dll", "dword", "CM_Query_And_Remove_SubTreeW", "dword", $DevInstParent, _
				"dword*", "", "wstr", "", "ulong", 260, "ulong", $CM_REMOVE_NO_RESTART)
		If $res[0] == $CR_ACCESS_DENIED Then
			$res = DllCall("setupapi.dll", "dword", "CM_Request_Device_EjectW", "dword", $DevInstParent, _
					"dword*", "", "wstr", "", "ulong", 260, "ulong", 0)
		EndIf
		$bSuccess = (($res[0] == $CR_SUCCESS) And ($res[2] == $PNP_VetoTypeUnknown))
		If $bSuccess Then ExitLoop
		Sleep(500)
	Next

	Return $bSuccess
EndFunc   ;==>_DevInstEject

Func _ZeroMemory($ptr, $size)
	$struct = DllStructCreate("byte[" & $size & "]", $ptr)
	$szdata = "0x"
	For $i = 1 To $size
		$szdata &= "00"
	Next
	DllStructSetData($struct, 1, Binary($szdata))
EndFunc   ;==>_ZeroMemory

Func Eject_All_Drives()
	Local $Fixed_Drives, $CD_Drives, $Removable_Drives, $iMsgBoxAnswer, $x

	;External Drives
	$Fixed_Drives = DriveGetDrive("Fixed")
	_ArrayDelete($Fixed_Drives, 0)
	_ArrayDelete($Fixed_Drives, _ArraySearch($Fixed_Drives, @HomeDrive))
	If _ArraySearch($Fixed_Drives, "D:") <> -1 Then _ArrayDelete($Fixed_Drives, _ArraySearch($Fixed_Drives, "D:"))
	If UBound($Fixed_Drives) > 0 Then
		For $element In $Fixed_Drives
			_EjectDrive(StringTrimRight($element, 1))
		Next
	EndIf

	;CD Drives
	$CD_Drives = DriveGetDrive("CDROM")
	$x = $CD_Drives[0]
	While 1
		If DriveStatus($CD_Drives[$x]) <> "NOTREADY" Then
			ConsoleWrite($CD_Drives[$x] & @CRLF)
			CDTray($CD_Drives[$x], "Open")
			$iMsgBoxAnswer = MsgBox(262209, "Warning", "Please remove the disk in drive " & $CD_Drives[$x] & " and click OK." & _
					@CRLF & "Click cancel to leave the disk in drive " & $CD_Drives[$x] & ".")
			Switch $iMsgBoxAnswer
				Case 1 ;OK
					CDTray($CD_Drives[$x], "Close")
				Case 2 ;Cancel
					CDTray($CD_Drives[$x], "Close")
					$x -= 1
			EndSwitch
		Else
			$x -= 1
		EndIf
		If $x = 0 Then ExitLoop
	WEnd

	;USB Drives
	$Removable_Drives = DriveGetDrive("Removable")
	If $Removable_Drives[0] > 0 Then
		_ArrayDelete($Removable_Drives, 0)
		For $element In $Removable_Drives
			If DriveStatus($element) <> "NOTREADY" Then _EjectDrive(StringTrimRight($element, 1))
		Next
	EndIf
EndFunc   ;==>Eject_All_Drives

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndEdit1 = GUICtrlGetHandle($Input_Param)
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hWndEdit1
			Switch $iCode
				Case $EN_KILLFOCUS
					If _GUICtrlEdit_GetTextLen($Input_Param) = 0 Then
						GUICtrlSetData($Input_Param, "Parameters")
						GUICtrlSetColor($Input_Param, 0x808080)
					EndIf
				Case $EN_SETFOCUS
					If GUICtrlRead($Input_Param) = "Parameters" Then
						GUICtrlSetData($Input_Param, "")
						GUICtrlSetColor($Input_Param, 0x000000)
					EndIf
				Case $EN_CHANGE
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND