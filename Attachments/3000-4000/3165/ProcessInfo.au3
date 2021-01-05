#cs
	
	1 = Caption
	2 = CreatingProcessID
	3 = Description
	4 = ElapsedTime
	5 = Frequency_Object
	6 = Frequency_PerfTime
	7 = Frequency_Sys100NS
	8 = HandleCount
	9 = IDProcess
	10 = IODataBytesPersec
	11 = IODataOperationsPersec
	12 = IOOtherBytesPersec
	13 = IOOtherOperationsPersec
	14 = IOReadBytesPersec
	15 = IOReadOperationsPersec
	16 = IOWriteBytesPersec
	17 = IOWriteOperationsPersec
	18 = Name
	19 = PageFaultsPersec
	20 = PageFileBytes
	21 = PageFileBytesPeak
	22 = PercentPrivilegedTime
	23 = PercentProcessorTime
	24 = PercentUserTime
	25 = PoolNonpagedBytes
	26 = PoolPagedBytes
	27 = PriorityBase
	28 = PrivateBytes
	29 = ThreadCount
	30 = Timestamp_Object
	31 = Timestamp_PerfTime
	32 = Timestamp_Sys100NS
	33 = VirtualBytes
	34 = VirtualBytesPeak
	35 = WorkingSet
	36 = WorkingSetPeak
	
#ce

Func _ProcessInfo($v_PID, $i_thing = 0)
	
	Local $o_WMIService = ObjGet ("winmgmts:\\localhost\root\CIMV2")
	Local $o_ColItems = $o_WMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfProc_Process", "WQL", 0x10 + 0x20)
	Local $v_Output = ""
	
	; 0 = pid
	; 1 = processname
	; 2 = title/hwnd
	
	If $i_thing = 1 Then
		$v_PID = ProcessExists($v_PID)
		If $v_PID = -1 Then $o_ColItems = ''
	EndIf
	
	If $i_thing = 2 Then
		$v_PID = WinGetProcess($v_PID)
		If $v_PID = -1 Then $o_ColItems = ''		
	EndIf
	
	If IsObj ($o_ColItems) Then
		For $o_Item In $o_ColItems
			If $o_Item.IDProcess == $v_PID Then
				$v_Output &= $o_Item.Caption & @CRLF
				$v_Output &= $o_Item.CreatingProcessID & @CRLF
				$v_Output &= $o_Item.Description & @CRLF
				$v_Output &= $o_Item.ElapsedTime & @CRLF
				$v_Output &= $o_Item.Frequency_Object & @CRLF
				$v_Output &= $o_Item.Frequency_PerfTime & @CRLF
				$v_Output &= $o_Item.Frequency_Sys100NS & @CRLF
				$v_Output &= $o_Item.HandleCount & @CRLF
				$v_Output &= $o_Item.IDProcess & @CRLF
				$v_Output &= $o_Item.IODataBytesPersec & @CRLF
				$v_Output &= $o_Item.IODataOperationsPersec & @CRLF
				$v_Output &= $o_Item.IOOtherBytesPersec & @CRLF
				$v_Output &= $o_Item.IOOtherOperationsPersec & @CRLF
				$v_Output &= $o_Item.IOReadBytesPersec & @CRLF
				$v_Output &= $o_Item.IOReadOperationsPersec & @CRLF
				$v_Output &= $o_Item.IOWriteBytesPersec & @CRLF
				$v_Output &= $o_Item.IOWriteOperationsPersec & @CRLF
				$v_Output &= $o_Item.Name & @CRLF
				$v_Output &= $o_Item.PageFaultsPersec & @CRLF
				$v_Output &= $o_Item.PageFileBytes & @CRLF
				$v_Output &= $o_Item.PageFileBytesPeak & @CRLF
				$v_Output &= $o_Item.PercentPrivilegedTime & @CRLF
				$v_Output &= $o_Item.PercentProcessorTime & @CRLF
				$v_Output &= $o_Item.PercentUserTime & @CRLF
				$v_Output &= $o_Item.PoolNonpagedBytes & @CRLF
				$v_Output &= $o_Item.PoolPagedBytes & @CRLF
				$v_Output &= $o_Item.PriorityBase & @CRLF
				$v_Output &= $o_Item.PrivateBytes & @CRLF
				$v_Output &= $o_Item.ThreadCount & @CRLF
				$v_Output &= $o_Item.Timestamp_Object & @CRLF
				$v_Output &= $o_Item.Timestamp_PerfTime & @CRLF
				$v_Output &= $o_Item.Timestamp_Sys100NS & @CRLF
				$v_Output &= $o_Item.VirtualBytes & @CRLF
				$v_Output &= $o_Item.VirtualBytesPeak & @CRLF
				$v_Output &= $o_Item.WorkingSet & @CRLF
				$v_Output &= $o_Item.WorkingSetPeak & @CRLF
			EndIf
		Next
	EndIf
	
	If $v_Output = '' Then
		Local $as_dummy[1]
		$as_dummy[0] = 0
		SetError(1)
		Return $as_dummy
	EndIf
	
	Return StringSplit(StringTrimRight(StringReplace($v_Output, @LF, ''), 1), @CRLF)
	
EndFunc ;==> _ProcessInfo()


$var = _ProcessInfo(1416)

For $i = 1 To $var[0]
	ConsoleWrite($i & ' = ' & $var[$i] & @LF)
Next