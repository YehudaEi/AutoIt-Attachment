#include <GUIConstants.au3>

$gui = GUICreate("AutoIt Memory Editor", 360, 280)

Global $combo = GUICtrlCreateCombo("", 10, 10, 230, 20)
_RefreshList()

$open = GUICtrlCreateButton("Open", 250, 10, 45, 20)
$refresh = GUICtrlCreateButton("Refresh", 305, 10, 45, 20)

GUICtrlCreateGroup("Read", 5, 40, 350, 118)
	GUICtrlCreateLabel("Data Type", 10, 58, 60, 15)
	$rtype = GUICtrlCreateCombo("byte", 70, 55, 100, 20)
	GUICtrlSetData(-1, "ubyte|char|short|ushort|int|uint|dword|udword|ptr|float|double|int64|uint64")
	GUICtrlCreateLabel("Address", 10, 88, 60, 15)
	$raddress = GUICtrlCreateInput("0x00000000", 70, 85, 100, 20)
	$read = GUICtrlCreateButton("Read", 15, 120, 70, 20)
	$rclose = GUICtrlCreateButton("Close", 95, 120, 70, 20)
	$rdata = GUICtrlCreateEdit("", 180, 55, 170, 95)

GUICtrlCreateGroup("Write", 5, 158, 350, 117)
	GUICtrlCreateLabel("Data Type", 10, 176, 60, 15)
	$wtype = GUICtrlCreateCombo("byte", 70, 173, 100, 20)
	GUICtrlSetData(-1, "ubyte|char|short|ushort|int|uint|dword|udword|ptr|float|double|int64|uint64")
	GUICtrlCreateLabel("Address", 10, 206, 60, 15)
	$waddress = GUICtrlCreateInput("0x00000000", 70, 203, 100, 20)
	$write = GUICtrlCreateButton("Write", 15, 238, 70, 20)
	$wclose = GUICtrlCreateButton("Close", 95, 238, 70, 20)
	$wdata = GUICtrlCreateEdit("", 180, 173, 170, 95)

GUICtrlSetState($combo, $GUI_FOCUS)
_Disable()
GUISetState()

$proc = 0
$mem = 0

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $combo
			$proc = ProcessExists(GUICtrlRead($combo))
		Case $refresh
			_RefreshList()
		Case $open
			$mem = _MemOpen($proc)
			If @error Then
				mError("Can't open process memory!")
			Else
				_Enable()
			EndIf
		Case $read
			_SizeOf(GUICtrlRead($rtype))
			If @error Then
				mError("Wrong data type!")
			Else
				GUICtrlSetData($rdata, _MemRead($mem, GUICtrlRead($raddress), GUICtrlRead($rtype)))
			EndIf
		Case $rclose, $wclose
			_MemClose($mem)
			_Disable()
		Case $write
			_SizeOf(GUICtrlRead($wtype))
			If @error Then
				mError("Wrong data type!")
			Else
				_MemWrite($mem, GUICtrlRead($waddress), _MemCreate(GUICtrlRead($wdata), _SizeOf(GUICtrlRead($wtype))))
			EndIf
	EndSwitch
	Sleep(0)
WEnd


Func mError($sText, $iFatal = 0, $sTitle = "Error", $iOpt = 0)
	Local $ret = MsgBox(48 + 4096 + 262144 + $iOpt, $sTitle, $sText)
	If $iFatal Then Exit
	Return $ret
EndFunc

Func _RefreshList()
	Local $ps = ProcessList(), $list = ""
	For $i = 1 to $ps[0][0]
		$list &= "|" & $ps[$i][0]
	Next
	GUICtrlSetData($combo, $list)
	GUISetState()
EndFunc

Func _Disable()
	GUICtrlSetState($rtype, $GUI_DISABLE)
	GUICtrlSetState($raddress, $GUI_DISABLE)
	GUICtrlSetState($read, $GUI_DISABLE)
	GUICtrlSetState($rclose, $GUI_DISABLE)
	GUICtrlSetState($rdata, $GUI_DISABLE)
	GUICtrlSetState($wtype, $GUI_DISABLE)
	GUICtrlSetState($waddress, $GUI_DISABLE)
	GUICtrlSetState($write, $GUI_DISABLE)
	GUICtrlSetState($wclose, $GUI_DISABLE)
	GUICtrlSetState($wdata, $GUI_DISABLE)
	GUISetState()
EndFunc

Func _Enable()
	GUICtrlSetState($rtype, $GUI_ENABLE)
	GUICtrlSetState($raddress, $GUI_ENABLE)
	GUICtrlSetState($read, $GUI_ENABLE)
	GUICtrlSetState($rclose, $GUI_ENABLE)
	GUICtrlSetState($rdata, $GUI_ENABLE)
	GUICtrlSetState($wtype, $GUI_ENABLE)
	GUICtrlSetState($waddress, $GUI_ENABLE)
	GUICtrlSetState($write, $GUI_ENABLE)
	GUICtrlSetState($wclose, $GUI_ENABLE)
	GUICtrlSetState($wdata, $GUI_ENABLE)
	GUISetState()
EndFunc


Func _MemOpen( $i_Pid, $i_Access = 0x1F0FFF, $i_Inherit = 0 )
	Local $av_Return[2] = [DllOpen('kernel32.dll')]
	Local $ai_Handle = DllCall($av_Return[0], 'int', 'OpenProcess', 'int', $i_Access, 'int', $i_Inherit, 'int', $i_Pid)
	If @error Then
		DllClose($av_Return[0])
		SetError(1)
		Return 0
	EndIf
	$av_Return[1] = $ai_Handle[0]
	Return $av_Return
EndFunc  ;==>_MemOpen

Func _MemClose( $ah_Mem )
	Local $av_Ret = DllCall($ah_Mem[0], 'int', 'CloseHandle', 'int', $ah_Mem[1])
	DllClose($ah_Mem[0])
	Return $av_Ret[0]
EndFunc  ;==>_MemClose

Func _MemAlloc( $ah_Mem, $i_Size, $i_Address = 0, $i_AT = 4096, $i_Protect = 0x40 )
	Switch @OSVersion
		Case "WIN_ME", "WIN_98", "WIN_95"
			$av_Alloc = DllCall($ah_Mem[0], 'int', 'VirtualAlloc', 'int', $i_Address, 'int', $i_Size, 'int', BitOR($i_AT, 0x8000000), 'int', $i_Protect)
		Case Else
			$av_Alloc = DllCall($ah_Mem[0], 'int', 'VirtualAllocEx', 'int', $ah_Mem[1], 'int', $i_Address, 'int', $i_Size, 'int', $i_AT, 'int', $i_Protect)
	EndSwitch
	Return $av_Alloc[0]
EndFunc  ;==>_MemAlloc

Func _MemFree( $ah_Mem, $i_Address )
	Switch @OSVersion
		Case "WIN_ME", "WIN_98", "WIN_95"
			$av_Free = DllCall($ah_Mem[0], 'int', 'VirtualFree', 'int', $i_Address, 'int', 0, 'int', 0x8000)
		Case Else
			$av_Free = DllCall($ah_Mem[0], 'int', 'VirtualFreeEx', 'int', $ah_Mem[1], 'int', $i_Address, 'int', 0, 'int', 0x8000)
	EndSwitch
	Return $av_Free[0]
EndFunc  ;==>_MemFree

Func _MemRead( $ah_Mem, $i_Address, $s_Type = '' )
	If $s_Type = '' Then
		Local $v_Return = ''
		Local $v_Struct = DllStructCreate('byte[1]')
		Local $v_Ret
		While 1
			DllCall($ah_Mem[0], 'int', 'ReadProcessMemory', 'int', $ah_Mem[1], 'int', $i_Address, 'ptr', DllStructGetPtr($v_Struct), 'int', 1, 'int', '')
			$v_Ret = DllStructGetData($v_Struct, 1)
			If $v_Ret = 0 Then ExitLoop
			$v_Return &= Chr($v_Ret)
			$i_Address += 1
		WEnd
	Else
		Local $v_Struct = DllStructCreate($s_Type)
		DllCall($ah_Mem[0], 'int', 'ReadProcessMemory', 'int', $ah_Mem[1], 'int', $i_Address, 'ptr', DllStructGetPtr($v_Struct), 'int', _SizeOf($s_Type), 'int', '')
		Local $v_Return = DllStructGetData($v_Struct, 1, 1)
	EndIf
	Return $v_Return
EndFunc  ;==>_MemRead

Func _MemCreate( $v_Data, $s_Type = '' )
	If $s_Type = '' Then
		$v_Data = StringSplit($v_Data, '')
		Local $v_Struct = DllStructCreate('byte[' & $v_Data[0] + 1 & ']')
		For $i = 1 To $v_Data[0]
			DllStructSetData($v_Struct, 1, Asc($v_Data[$i]), $i)
		Next
	Else
		Local $v_Struct = DllStructCreate($s_Type)
		DllStructSetData($v_Struct, 1, $v_Data, 1)
	EndIf
	Return $v_Struct
EndFunc  ;==>_MemCreate

Func _MemWrite( $ah_Mem, $i_Address, $v_Inject )
	Local $av_Call = DllCall($ah_Mem[0], 'int', 'WriteProcessMemory', 'int', $ah_Mem[1], 'int', $i_Address, 'ptr', DllStructGetPtr($v_Inject), 'int', DllStructGetSize($v_Inject), 'int', '')
	Return $av_Call[0]
EndFunc  ;==>_MemWrite

Func _MemText( $ah_Mem, $s_Text )
	Local $i_Size = StringLen($s_Text) + 1
	Local $i_Addr = _MemAlloc($ah_Mem, $i_Size)
	_MemWrite($ah_Mem, $i_Addr, _MemCreate($s_Text))
	Return $i_Addr
EndFunc  ;==>_MemText

Func _SizeOf( $s_Type )
	Local $v_Struct = DllStructCreate($s_Type), $i_Size = DllStructGetSize($v_Struct)
	If @error Then
		SetError(1)
		Return 0
	EndIf
	$v_Struct = 0
	Return $i_Size
EndFunc  ;==>_SizeOf