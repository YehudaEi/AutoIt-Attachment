
;demo usage
;msgbox(0,"",PortCheck("172.21.25.1"))
;
;actual function
;emperor_kkyahoo.com / 04/08/2011
;
Func PortCheck($py = "127.0.0.1",$px="all")
	Local $maxport = 14
	Dim $PortList[$maxport][2]

$PortList[0][0] = 80 ;HTTP
$PortList[0][1] = "HTTP"
$PortList[1][0] = 81 ;HTTP alt
$PortList[1][1] = "HTTP alt"
$PortList[2][0] = 8080 ;HTTP alt
$PortList[2][1] = "HTTP alt"
$PortList[3][0] = 3389 ;RDP
$PortList[3][1] = "Terminal Services - RDP"
$PortList[4][0] = 5900 ;VNC
$PortList[4][1] = "VNC Server Port"
$PortList[5][0] = 1433 ;MS SQL Listener
$PortList[5][1] = "MSSQL Server Database Engine"
$PortList[6][0] = 20 ; FTP data
$PortList[6][1] = "FTP Data"
$PortList[7][0] = 21 ; FTP Control
$PortList[7][1] = "FTP Control/Data"
$PortList[8][0] = 22 ; SSH
$PortList[8][1] = "SSH"
$PortList[9][0] = 2483 ;Oracle Listener Server
$PortList[9][1] = "Oracle Listener Server"
$PortList[10][0] = 3306 ; Mysql Database System
$PortList[10][1] = "Mysql Database System"
$PortList[11][0] = 5500 ;VNC Incoming Listener
$PortList[11][1] = "VNC Incoming Listener"
$PortList[12][0] = 3872 ;Oracle management tool
$PortList[12][1] = "Oracle management tool"
$PortList[13][0] = 23 ;Telnet
$PortList[13][1] = "Telnet"

	Opt('TCPTimeout', 100)
	TCPStartup() ;Start TCP services
		Local $testport, $pi =0,$port_result = "Ports"

	If $px = "all" Then

		while $pi<$maxport
		$testport = TCPConnect($py,$PortList[$pi][0])
		TCPCloseSocket($PortList[$pi][0])
		If $testport>0 Then $port_result = $port_result & ", " & $PortList[$pi][0] & " (" & $PortList[$pi][1] & ")"
		$pi = $pi + 1 ;go to next port
		WEnd
	Else ;if specific port
		$testport = TCPConnect($py,$px)
		TCPCloseSocket($px)
		If $testport>0 Then $port_result = $port_result & ", " & $px
	EndIf



	$PortList = 0 ;erase list
	$port_result = StringReplace($port_result,"Ports,", "Ports:") ;make result string look nice
	TCPShutdown ( ) ; Close TCP Services
	Return $port_result
EndFunc

