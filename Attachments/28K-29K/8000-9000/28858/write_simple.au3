
Openmmap()
$data=""
While StringUpper($data)<>"END"
	$data=InputBox("Data to send","'END' for finish","")
	simplemmapwrite($data)
WEnd
fin()
Exit




Func fin()
	DllCall($dll, "none", "Close")
	If @error Then
		MsgBox(0, "DLL error", "Close FALSE")
	EndIf
	DllClose($dll)
	If @error Then
		MsgBox(0, "Testing", "Error closing autoitmmap.dll")
	EndIf
	Exit
EndFunc   ;==>fin


Func Openmmap($NomMapObj="ammap")
	Global $dll,$read_string
	$dll = DllOpen("ammap.dll")
	If @error Then
		MsgBox(0, "Testing", "Error opening ammap.dll", 6)
		Exit
	EndIf
	DllCall($dll, "int", "Open", "str", $NomMapObj)
EndFunc   ;==>Openmmap


Func simplemmapwrite($data)
	DllCall($dll, "none", "SetSharedMem", "str", $data)
	If @error Then
		MsgBox(0, "DLL error", "Error calling SetSharedMem")
	EndIf
EndFunc   ;==>simplemmapwrite


Func simplemmapread()
	Local $ret,$vret,$long
	$read_string=" "
	$ret = DllCall($dll, "none", "GetSharedMem", "str", $read_string, "int", 32767)
	If @error Then
		MsgBox(0, "DLL error", "Error calling GetSharedMem")
	EndIf
	Return ($ret[1])
EndFunc   ;==>simplemmapread

