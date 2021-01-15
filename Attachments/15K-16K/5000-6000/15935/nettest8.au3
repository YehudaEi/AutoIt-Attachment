#include <GUIConstants.au3>
#include"constants.au3"
#Region ### START Koda GUI section ### Form=c:\documents and settings\bret\my documents\fun\nettest7.kxf
$Form2 = GUICreate("Dialog", 591, 374, 251, 199)
GUISetIcon("D:\003.ico")
$GroupBox1 = GUICtrlCreateGroup("", 0, -7, 585, 377)
$IP = InputBox("IP ADDRESS/HOST NAME","Input the IP Address or Host Name here:", "192.168.0.1" ,"",16, 32, 153, 21)
$PING = GUICtrlCreateButton("PING", 16, 88, 75, 25, 0)
$TRACERT = GUICtrlCreateButton("TRACERT", 16, 144, 75, 25, 0)
$IPCONFIG = GUICtrlCreateButton("IPCONFIG", 96, 88, 75, 25, 0)
$NETSTAT = GUICtrlCreateButton("NETSTAT", 96, 144, 75, 25, 0)
$NSLOOKUP = GUICtrlCreateButton("NSLOOKUP", 16, 200, 75, 25, 0)
$NBTSTAT = GUICtrlCreateButton("NBTSTAT", 96, 200, 75, 25, 0)
$GUIEdit = GUICtrlCreateEdit("", 189, 29, 385, 321)
GUICtrlSetColor(-1, 0x716F64)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&EXIT", 96, 257, 75, 25, 0)
$CANCEL = GUICtrlCreateButton("CANCEL", 16, 257, 75, 25, 0)
$IPADDRESS = GUICtrlCreateLabel("IP ADDRESS:" & @CRLF & $IP, 24, 32, 146, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $Button1
			Exit
		case $PING
			$get = GUICtrlGetHandle($IP)
			$ping2 = Run(@ComSpec & " /c ping.exe " & $IP, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			If @Error = -1 Then ExitLoop
			$lineping = StdoutRead($ping2)
			GUICtrlSetData($GUIEdit, $lineping & @CRLF, 1)
		case $TRACERT
			$get = GUICtrlRead($IP)
			$trace = Run(@ComSpec & " /c tracert" & " " & $IP, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			If @Error = -1 Then ExitLoop
			$linetrace = StdoutRead($trace)
			GUICtrlSetData($GUIEdit, $linetrace & @CRLF, 1)
		case $NSLOOKUP
			$get = GUICtrlRead($IP)
			$look = Run(@ComSpec & " /c nslookup" & " " & $IP, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			If @Error = -1 Then ExitLoop
			$linelook = StdoutRead($look)
			GUICtrlSetData($GUIEdit, $linelook & @CRLF, 1)
		case $NETSTAT
			$stat = Run(@ComSpec & " /c netstat", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			If @Error = -1 Then ExitLoop
			$linestat = StdoutRead($stat)
			GUICtrlSetData($GUIEdit, $linestat & @CRLF, 1)
		case $IPCONFIG
			$config = Run(@ComSpec & " /c ipconfig /all", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			If @Error = -1 Then ExitLoop
			$lineconfig = StdoutRead($config)
			GUICtrlSetData($GUIEdit, $lineconfig & @CRLF, 1)
	EndSwitch
WEnd
