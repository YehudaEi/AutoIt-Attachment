;==================================================================================================
; GUI zum Funktionstest
;==================================================================================================
#include <GuiConstants.au3>

GuiCreate("Test Function _GetCdDriveInfo()", 573, 353,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Group_1 = GuiCtrlCreateGroup("Parameter Drive-Position", 30, 40, 240, 170)
$Radio_3 = GuiCtrlCreateRadio("First Drive only", 50, 60, 200, 20)
GUICtrlSetState($Radio_3,$gui_checked)
$Radio_4 = GuiCtrlCreateRadio("Second Drive only", 50, 120, 200, 20)
$Radio_5 = GuiCtrlCreateRadio("Both Drives", 50, 180, 200, 20)
$Group_2 = GuiCtrlCreateGroup("Parameter Info-Type", 300, 40, 240, 170)
$Radio_6 = GuiCtrlCreateRadio("Drive Letter only", 320, 60, 210, 20)
GUICtrlSetState($Radio_6,$gui_checked)
$Radio_7 = GuiCtrlCreateRadio("Device Name only", 320, 90, 210, 20)
$Radio_8 = GuiCtrlCreateRadio("Firmware only", 320, 120, 210, 20)
$Radio_9 = GuiCtrlCreateRadio("Drive Letter + Device Name", 320, 150, 210, 20)
$Radio_10 = GuiCtrlCreateRadio("Drive Letter + Device Name + Firmware", 320, 180, 210, 20)
$Button_11 = GuiCtrlCreateButton("Get Info", 240, 230, 80, 20)
$Label_12 = GuiCtrlCreateLabel("", 30, 270, 510, 20)
$Button_13 = GuiCtrlCreateButton("End", 240, 310, 80, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	$r1_1 = GUICtrlRead($Radio_3)
	If $r1_1 = 1 Then
		$param1 = 1
	EndIf
	$r1_2 = GUICtrlRead($Radio_4)
	If $r1_2 = 1 Then
		$param1 = 2
	EndIf
	$r1_3 = GUICtrlRead($Radio_5)
	If $r1_3 = 1 Then
		$param1 = 3
	EndIf
	$r2_1 = GUICtrlRead($Radio_6)
	If $r2_1 = 1 Then
		$param2 = 1
	EndIf
	$r2_2 = GUICtrlRead($Radio_7)
	If $r2_2 = 1 Then
		$param2 = 2
	EndIf
	$r2_3 = GUICtrlRead($Radio_8)
	If $r2_3 = 1 Then
		$param2 = 3
	EndIf
	$r2_1 = GUICtrlRead($Radio_9)
	If $r2_1 = 1 Then
		$param2 = 4
	EndIf
	$r2_2 = GUICtrlRead($Radio_10)
	If $r2_2 = 1 Then
		$param2 = 5
	EndIf	
	Select
	Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_13
		ExitLoop
	Case $msg = $Button_11
		GUICtrlSetData($Label_12,_GetCdDriveInfo($param1, $param2))
	EndSelect
WEnd
Exit








;==================================================================================================
; Function:		_GetCdDriveInfo($cd_pos, $cd_info_type)
;
; Description:	Get Info of physical CD/DVD-drives (Drive-Letter, Device-Name, Firmware)
;
; Parameter(s):	$cd_pos
;					1= First Drive;
;					2= Second Drive;
;					3= Info of Both Drives with Seperator " | "
;				$cd_info_type
;					1= Drive-Letter only
;					2= Device-Name only
;					3= Firmware-Version only
;					4= Drive-Letter & " " & Device-Name
;					5= Drive-Letter & " " & Device-Name & " " & Firmware-Version
;
; Return Value:	i.e. D:[ HL-DT-ST DVDRAM GSA-4081B][ v.A100] | [E:][ TOSHIBA DVD-ROM SD-M1612][ v.1004]
;				Sets @ERROR to:	1 - no CD/DVD-Device found
;								2 - Second CD/DVD-Device not found
;				no @ERROR sets 	if $cd_pos= 3 and Second CD/DVD-Device was'nt found
;								Return only First Drive Info
;
; Author:		BugFix (bug_fix@web.de)
;==================================================================================================
#include <String.au3>

Func _GetCdDriveInfo($cd_pos = 1, $cd_info_type = 1)
	$cd1 = ""
	$cd1_name = "no_drive"
	$cd1_fw = ""
	$cd2 = ""
	$cd2_name = "no_drive"
	$cd2_fw = ""
	$p2 = 0
	
	For $a = 68 To 90
		$drv = Chr($a)
		$reg = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices", "\DosDevices\" & $drv & ":")
		$val = ""
		$name = ""
		For $i = 1 To StringLen($reg) - 2 Step 2
			$tmp = _HexToString(StringMid($reg, $i, 2))
			If $tmp <> "" Then
				$val = $val & $tmp
			EndIf
		Next
		$p1 = StringInStr($val, "#") + 1
		$type = StringMid($val, $p1, 5)
		If $type = "CdRom" Then
			$p2 = StringInStr($val, "__")
			If $p2 > 6 Then
				$name = StringMid($val, $p1 + 5, $p2- ($p1 + 5))
				$name = StringReplace($name, "_", " ")
				If $cd1 = "" Then
					$cd1 = $drv & ":"
					$cd1_name = $name
				Else
					$cd2 = $drv & ":"
					$cd2_name = $name
				EndIf
				$p3 = StringInStr($val, "#", 0, 2)
				For $i = $p3 - 1 To $p2 Step - 1
					If StringMid($val, $i, 1) <> "_" Then
						$pos_fw_end = $i
						ExitLoop
					EndIf
				Next
				For $i = $pos_fw_end To $p2 Step - 1
					If StringMid($val, $i, 1) = "_" Then
						$pos_fw_begin = $i+1
						$fw_len = $pos_fw_end - $pos_fw_begin +1
						ExitLoop
					EndIf
				Next
				$cd_fw = "v." & StringMid($val, $pos_fw_begin, $fw_len)
				If $cd1_fw = "" Then
					$cd1_fw = $cd_fw
				Else
					$cd2_fw = $cd_fw
				EndIf
			EndIf
		EndIf
		$p2 = 0
	Next
	If $cd1_name = "no_drive" And $cd2_name = "no_drive" Then
		SetError(1)
		Return False
	EndIf
	If $cd2_name = "no_drive" And $cd_pos = 2 Then
		SetError(2)
		Return False
	EndIf
	Select
		Case ($cd_pos = 1 Or ($cd_pos = 3 And $cd2_name = "no_drive")) And $cd_info_type = 1
			Return $cd1
		Case ($cd_pos = 1 Or ($cd_pos = 3 And $cd2_name = "no_drive")) And $cd_info_type = 2
			Return $cd1_name
		Case ($cd_pos = 1 Or ($cd_pos = 3 And $cd2_name = "no_drive")) And $cd_info_type = 3
			Return $cd1_fw
		Case ($cd_pos = 1 Or ($cd_pos = 3 And $cd2_name = "no_drive")) And $cd_info_type = 4
			Return $cd1 & " " & $cd1_name
		Case ($cd_pos = 1 Or ($cd_pos = 3 And $cd2_name = "no_drive")) And $cd_info_type = 5
			Return $cd1 & " " & $cd1_name & " " & $cd1_fw
		Case $cd_pos = 2 And $cd_info_type = 1
			Return $cd2
		Case $cd_pos = 2 And $cd_info_type = 2
			Return $cd2_name
		Case $cd_pos = 2 And $cd_info_type = 3
			Return $cd2_fw
		Case $cd_pos = 2 And $cd_info_type = 4
			Return $cd2 & " " & $cd2_name
		Case $cd_pos = 2 And $cd_info_type = 5
			Return $cd2 & " " & $cd2_name & " " & $cd2_fw
		Case $cd_pos = 3 And $cd_info_type = 1
			Return $cd1 & " | " & $cd2
		Case $cd_pos = 3 And $cd_info_type = 2
			Return $cd1_name & " | " & $cd2_name
		Case $cd_pos = 3 And $cd_info_type = 3
			Return $cd1_fw & " | " & $cd2_fw
		Case $cd_pos = 3 And $cd_info_type = 4
			Return $cd1 & " " & $cd1_name & " | " & $cd2 & " " & $cd2_name
		Case $cd_pos = 3 And $cd_info_type = 5
			Return $cd1 & " " & $cd1_name & " " & $cd1_fw & " | " & $cd2 & " " & $cd2_name & " " & $cd2_fw
	EndSelect
EndFunc   ;==>_GetCdDriveInfo



