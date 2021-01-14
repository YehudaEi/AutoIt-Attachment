while 1
	$data = ""
	Do
		$data = consoleread()
	until $data <> ""
	$data1 = stringsplit($data," ")
	call($data1[1])
WEnd
func mbox()
	if $data1[0] <> 4 Then
		return -1
	EndIf
	msgbox($data1[2],$data1[3],$data1[4])
	consolewrite("lol")
EndFunc
func exit2()
	Exit
EndFunc