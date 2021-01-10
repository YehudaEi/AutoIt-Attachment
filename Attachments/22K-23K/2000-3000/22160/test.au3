#include <GuiConstants.au3>
#Include <Constants.au3>

Opt("TrayMenuMode",1)
Global $ProcessID = WinGetProcess("Kungfu Client")

Global $Address = 0x005FE608

Global $CurrentHealthOffset[2]
$CurrentHealthOffset[0] = 'NULL'
$CurrentHealthOffset[1] = 192

Global $CurrentManaOffset[2]
$CurrentManaOffset[1] = 200

Global $CurrentHealth[2], $CurrentMana[2]

Global $Handle = _MemoryOpen($ProcessID)

Global $CurrentHealth = _MemoryPointerRead($Address, $Handle, $CurrentHealthOffset)
Global $CurrentMana = _MemoryPointerRead($Address, $Handle, $CurrentManaOffset)

_MemoryClose($Handle)

	$keys = "{F1}" & "|" & "{F2}" & "|" & "{F3}" & "|"  & "{F4}" & "|" & "{F5}" & "|"  & "{F6}" & "|" & "{F7}" & "|" & "{F8}" & "|" & "{F9}" & "|" & "{F10}" & "|" & "{F11}" & "|" & "{F12}" & "|" & "1" & "|" & "2" & "|"  & "3" & "|" & "4" & "|"  & "5" & "|" & "6" & "|" & "7" & "|" & "8" & "|" & "9" & "|" & "0"
	$config = GUICreate("Configuration (HOME = HIDE)", 200, 250, 0 + 100, 1 + 100, 1, 1)
	GUICtrlCreateTab(0, 0, 250, 280)
    GUICtrlCreateTabItem("General")
	$CurrentHP = GUICtrlCreateLabel("HP : " & $CurrentHealth[1] , 10, 35, 50, 25)
	$CurrentMP = GUICtrlCreateLabel("MP : " & $CurrentMana[1] , 10, 55, 50, 25)
	GUICtrlCreateLabel("  IF HP     < ", 5, 90, 70, 21)
	$CHP = GUICtrlCreateInput("", 80, 87, 45)
	$CHPKEY = GUICtrlCreateCombo("", 140, 87, 45)
	GUICtrlSetData(-1, $keys)
	GUICtrlCreateLabel("  IF MP     < ", 5, 120, 70, 21)
	$CMP = GUICtrlCreateInput("", 80, 119, 45)
	$CMPKEY = GUICtrlCreateCombo("", 140, 119, 45)
	GUICtrlSetData(-1, $keys)
    $exit= GUICtrlCreateButton("Exit", 80, 190, 45 , 25)	
	GUISetState(@SW_HIDE)

_Main()

Func _Main()
	HotKeySet("{HOME}", "_Config")
	While 1
$Handle = _MemoryOpen($ProcessID)
$CurrentHealth = _MemoryPointerRead($Address, $Handle, $CurrentHealthOffset)
$CurrentMana = _MemoryPointerRead($Address, $Handle, $CurrentManaOffset)
GUICtrlSetData ($CurrentHP, "HP : " & $CurrentHealth[1])
GUICtrlSetData ($CurrentMP, "MP : " & $CurrentMana[1])
	$msg = guiGetMsg()
		If $msg = $exit Then
			GUIDelete()
			Exit
		EndIf
	

	WEnd
EndFunc

Func _config()
$check = WinActive ("Configuration")
If $check = 1 Then
GUISetState(@SW_HIDE)
_Fight()
EndIf
If $check = 0 Then
GUISetState(@SW_SHOW)
_StopFight()
EndIf
EndFunc

Func _Fight()
	Do
$CMPcheck = GUICtrlRead($CMP)
$CMPKEYcheck = GUICtrlRead($CMPKEY)
$CHPcheck = GUICtrlRead($CHP)
$CHPKEYcheck = GUICtrlRead($CHPKEY)
$StopFight = WinActive("Configuration")
$Handle = _MemoryOpen($ProcessID)
$CurrentHealth = _MemoryPointerRead($Address, $Handle, $CurrentHealthOffset)
$CurrentMana = _MemoryPointerRead($Address, $Handle, $CurrentManaOffset)
		If $CurrentHealth[1] < $CHPcheck Then
			Send($CHPKEYcheck)
			Sleep(1000)
		EndIf
		If $CurrentMana[1] < $CMPcheck Then
			Send($CMPKEYcheck)
			Sleep(1000)
		EndIf
	Until $StopFight = 1
EndFunc

Func _StopFight()
	Sleep(100)
EndFunc

Func _getdata4()
	
EndFunc

Func _MemoryPointerRead ($iv_Address, $ah_Handle, $av_Offset, $sv_Type = 'dword')
	
	If IsArray($av_Offset) Then
		If IsArray($ah_Handle) Then
			Local $iv_PointerCount = UBound($av_Offset) - 1
		Else
			SetError(2)
			Return 0
		EndIf
	Else
		SetError(1)
		Return 0
	EndIf
	
	Local $iv_Data[2], $i
	Local $v_Buffer = DllStructCreate('dword')
	
	For $i = 0 to $iv_PointerCount
		
		If $i = $iv_PointerCount Then
			$v_Buffer = DllStructCreate($sv_Type)
			If @Error Then
				SetError(@Error + 2)
				Return 0
			EndIf
			
			$iv_Address = '0x' & hex($iv_Data[1] + $av_Offset[$i])
			DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
			If @Error Then
				SetError(7)
				Return 0
			EndIf
			
			$iv_Data[1] = DllStructGetData($v_Buffer, 1)
			
		ElseIf $i = 0 Then
			DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
			If @Error Then
				SetError(7)
				Return 0
			EndIf
			
			$iv_Data[1] = DllStructGetData($v_Buffer, 1)
			
		Else
			$iv_Address = '0x' & hex($iv_Data[1] + $av_Offset[$i])
			DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
			If @Error Then
				SetError(7)
				Return 0
			EndIf
			
			$iv_Data[1] = DllStructGetData($v_Buffer, 1)
			
		EndIf
		
	Next
	
	$iv_Data[0] = $iv_Address
	
	Return $iv_Data

EndFunc

Func _MemoryClose($ah_Handle)
	
	If Not IsArray($ah_Handle) Then
		SetError(1)
        Return 0
	EndIf
	
	DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
	If Not @Error Then
		DllClose($ah_Handle[0])
		Return 1
	Else
		DllClose($ah_Handle[0])
		SetError(2)
        Return 0
	EndIf
	
EndFunc

Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $if_InheritHandle = 1)
	
	If Not ProcessExists($iv_Pid) Then
		SetError(1)
        Return 0
	EndIf
	
	Local $ah_Handle[2] = [DllOpen('kernel32.dll')]
	
	If @Error Then
        SetError(2)
        Return 0
    EndIf
	
	Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $if_InheritHandle, 'int', $iv_Pid)
	
	If @Error Then
        DllClose($ah_Handle[0])
        SetError(3)
        Return 0
    EndIf
	
	$ah_Handle[1] = $av_OpenProcess[0]
	
	Return $ah_Handle
	
EndFunc