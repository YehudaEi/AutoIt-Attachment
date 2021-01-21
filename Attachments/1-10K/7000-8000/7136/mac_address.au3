;===============================================================================
; _GetIPConfigData()
; Description:		: Gets all the IP related information about your computer
; Parameter(s):		: -
; Return Value(s):	: An array containing the folowing:
; $ret[0][0] = Host Name of Computer
; $ret[1 to *][0] = Type Of Adapter
; $ret[1 to *][1] = Name Of Adapter
; $ret[1 to *][2] = Adapter Description
; $ret[1 to *][3] = Physical Address of Adapter
; $ret[1 to *][4] = IP Address of Adapter
; $ret[1 to *][5] = Subnet Mask of IP Address of Adapter
; $ret[1 to *][6] = Default Gateway of Adapter
; $ret[1 to *][7] = Array of DNS servers this adapter uses
; Author(s):		: nfwu
; Note(s):			: Only works on a Windows machine
;
;===============================================================================
Func _GetIPConfigData()
	Local $ipconfig = Run(@ComSpec & " /c " & 'ipconfig /all', "", @SW_HIDE, 2)
	Local $data = "Start Of Data:"&@CRLF
	While 1
		$data &= StdoutRead($ipconfig)
		If @error = -1 Then ExitLoop
	WEnd
	$data = StringSplit($data, @CRLF)
	Local Const $adapter_no = 8
	Local $retval[1][$adapter_no]
	Local $curr_adapter = 0
	Local $tmp
	For $i = 1 to $data[0]
		If __GPA_EL($data[$i], "        Host Name . . . . . . . . . . . . : ") Then 
			$retval[0][0] = __GPA_GL($data[$i], "        Host Name . . . . . . . . . . . . : ")
		ElseIf StringInStr($data[$i]," adapter ") Then 
			$tmp = StringSplit($data[$i]," adapter ",1)
			$curr_adapter += 1
			ReDim $retval[$curr_adapter+1][$adapter_no]
			$retval[$curr_adapter][0] = $tmp[0]
			$retval[$curr_adapter][1] = $tmp[1]
		ElseIf __GPA_EL($data[$i], "        Description . . . . . . . . . . . : ") Then 
			$retval[$curr_adapter][2] = __GPA_GL($data[$i], "        Description . . . . . . . . . . . : ")
		ElseIf __GPA_EL($data[$i], "        Physical Address. . . . . . . . . : ") Then 
			$retval[$curr_adapter][3] = __GPA_GL($data[$i], "        Physical Address. . . . . . . . . : ")
		ElseIf __GPA_EL($data[$i], "        IP Address. . . . . . . . . . . . : ") Then 
			$retval[$curr_adapter][4] = __GPA_GL($data[$i], "        IP Address. . . . . . . . . . . . : ")
		ElseIf __GPA_EL($data[$i], "        Subnet Mask . . . . . . . . . . . : ") Then 
			$retval[$curr_adapter][5] = __GPA_GL($data[$i], "        Subnet Mask . . . . . . . . . . . : ")
		ElseIf __GPA_EL($data[$i], "        Default Gateway . . . . . . . . . : ") Then 
			$retval[$curr_adapter][6] = __GPA_GL($data[$i], "        Default Gateway . . . . . . . . . : ")
		ElseIf __GPA_EL($data[$i], "        DNS Servers . . . . . . . . . . . : ") Then 
			__GPA_StackPush($retval[$curr_adapter][7], __GPA_GL($data[$i], "        DNS Servers . . . . . . . . . . . : "))
		ElseIf __GPA_EL($data[$i], "                                            ") Then 
			__GPA_StackPush($retval[$curr_adapter][7], __GPA_GL($data[$i], "                                            "))
		EndIf
	Next
		
Func __GPA_EL($data,$eqstr)
	Return StringLeft( $data, StringLen($eqstr)) == $eqstr
EndFunc
Func __GPA_GL($data,$eqstr)
	Return StringRight($data, Stringlen($data)-Stringlen($eqstr) )
EndFunc
Func __GPA_StackPush(ByRef $avArray, $sValue)
	IF IsArray( $avArray ) Then
		ReDim $avArray[Ubound($avArray)+1]
	Else
		Dim $avArray[1]
	EndIf
	$avArray[UBound($avArray)] = $sValue
	SetError(0)
	Return 1
EndFunc