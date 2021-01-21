#include <Misc.au3>
#include <String.au3>
#include <Date.au3>
#include <GUIConstants.au3>
#Include <GuiCombo.au3>
Opt("GUIOnEventMode", 1)
Dim $a,$a1,$a3,$b,$b1,$b2,$recv
$a3 = ping("www.yahoo.com",1000)
If @OSVersion = 'Win_98' Then 
	$a = StringSplit ( 'Afghanistan Standard Time,Alaskan Standard Time,Arab Standard Time,Arabian Standard Time,Atlantic Standard Time,AUS Central Standard Time,AUS Eastern Standard Time,Azores Standard Time,Canada Central Standard Time,Caucasus Standard Time,Cen. Australia Standard Time,Central Standard Time,Central Asia Standard Time,Central Europe Standard Time,Central European Standard Time,Central Pacific Standard Time,China Standard Time,Dateline Standard Time,E. Africa Standard Time,E. Australia Standard Time,E. Europe Standard Time,E. South America Standard Time,Eastern Standard Time,Egypt Standard Time,Ekaterinburg Standard Time,Fiji Standard Time,FLE Standard Time,GMT Standard Time,Greenwich Standard Time,GTB Standard Time,Hawaiian Standard Time,India Standard Time,Iran Standard Time,Jerusalem Standard Time,Korea Standard Time,Mexico Standard Time,Mid-Atlantic Standard Time,Mountain Standard Time,New Zealand Standard Time,Newfoundland Standard Time,Pacific Standard Time,Pacific SA Standard Time,Romance Standard Time,Russian Standard Time,SA Eastern Standard Time,SA Pacific Standard Time,SA Western Standard Time,Samoa Standard Time,SE Asia Standard Time,Singapore Standard Time,South Africa Standard Time,Sri Lanka Standard Time,Taipei Standard Time,Tasmania Standard Time,Tokyo Standard Time,US Eastern Standard Time,US Mountain Standard Time,Vladivostok Standard Time,W. Australia Standard Time,W. Europe Standard Time,West Asia Standard Time,West Pacific Standard Time,Yakutsk Standard Time',',')
	$a1 = StringSplit ('16200,-32400,10800,14400,-14400,34200,36000,-3600,-21600,14400,34200,-21600,21600,3600,3600,39600,28800,-43200,10800,36000,7200,-10800,-18000,7200,18000,43200,7200,0,0,7200,-36000,19800,12600,7200,32400,-21600,-7200,-25200,43200,-12600,-28800,-14400,3600,10800,-10800,-18000,-14400,-39600,25200,28800,7200,21600,28800,36000,32400,-18000,-25200,36000,28800,3600,18000,36000,32400',',')
	For $b = 1 To UBound($a)
		If $a[$b] = RegRead ("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation",'StandardName') Then ExitLoop
	Next
	$a = 0	
	$a1 = $a1[$b]	
Else
	$a1 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\" _
		& RegRead ('HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\TimeZoneInformation','StandardName'),'Display')
	$a1=(StringMid($a1,6,2)*3600+StringMid($a1,9,2)*60)*_Iif(StringMid($a1,5,1)='+',1,-1)	
EndIf
$Form1 = GUICreate("IPClock Sync", 260, 71, (@DesktopWidth-260)/2,(@DesktopHeight/2)+100 )
GUISetBkColor(0x3C8B7B)
$l01=GUICtrlCreateLabel("Time Server", 4, 7, 61, 17)
GUICtrlSetColor($l01,0xB0FFEF)
$cb01 = GUICtrlCreateCombo("", 68, 4, 186, 75,-1)
GUICtrlSetData(-1, "time-a.nist.gov|time-b.nist.gov|time-a.timefreq.bldrdoc.gov|time-b.timefreq.bldrdoc.gov|" _ 
			& "time-c.timefreq.bldrdoc.gov|utcnist.colorado.edu|time.nist.gov|time-nw.nist.gov|nist1.symmetricom.com|" _ 
			& "nist1-dc.glassey.com|nist1-ny.glassey.com|nist1-sj.glassey.com|nist1.aol-ca.truetime.com|" _ 
			& "nist1.aol-va.truetime.com|nist1.columbiacountyga.gov",'time-a.nist.gov')
$b01 = GUICtrlCreateButton("Sync Time", 185, 27, 65, 20)
$ckb01 = GUICtrlCreateCheckbox("", 98, 28, 15, 20)
$l02=GUICtrlCreateLabel("Set PC Time", 113, 31, 70, 20)
GUICtrlSetColor($l02,0xB0FFEF)
$e01 = GUICtrlCreateInput("", 4, 49, 252, 20, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetColor($e01,0x388777)
GUICtrlSetBkColor($e01,0x7ECDBD)
If $a3 = 0 Then 
	GUICtrlSetState($b01,$GUI_DISABLE)
	GUICtrlSetData($e01,"Internet Access is Required to Sync Time")
EndIf	
GUICtrlSetOnEvent ($b01, "tcpsync")
GUICtrlSetOnEvent ($l02, "setckb")
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
$a = StringSplit('129.6.15.28,129.6.15.29,132.163.4.101,132.163.4.102,132.163.4.103,' _ 
			& '128.138.140.44,192.43.244.18,131.107.1.10,69.25.96.13,216.200.93.8,' _ 
			& '208.184.49.9,207.126.98.204,207.200.81.113,64.236.96.53,68.216.79.113',',')

$g_IP = $a[_GUICtrlComboGetCurSel($cb01)+1]
While 1
	If GUICtrlGetState($b01) = 144 Then
		If WinGetState ( "IPClock Sync")=31 Or WinGetState ( "IPClock Sync")=23 Or WinGetState ( "IPClock Sync")=7 Then
			If ping("www.yahoo.com",3000)> 0 Then
				GUISetState(@SW_SHOW,$Form1)
				GUISetState ( @SW_HIDE,$Form1 )
				GUISetState ( @SW_SHOW,$Form1 )
				GUICtrlSetState($b01,$GUI_ENABLE)
				GUICtrlSetData($e01,"Internet Access Established")
			EndIf
		EndIf
	EndIf	
	Sleep(400)
WEnd
Func setckb()
	If GUICtrlRead($ckb01)=1 Then 
		GUICtrlSetState($ckb01,$GUI_UNCHECKED)
	Else
		GUICtrlSetState($ckb01,$GUI_CHECKED)
	EndIf
EndFunc	
Func setpctime()
	$b1=StringSplit(StringLeft(_DateAdd ( 's', $a, "1900/01/01 00:00:00"),10),'/')
	$b2=StringSplit(StringRight(_DateAdd ( 's', $a, "1900/01/01 00:00:00"),8),':')
	_SetTime($b2[1],$b2[2],$b2[3])
	_SetDate($b1[3],$b1[2],$b1[1])
EndFunc
Func tcpsync()
GUICtrlSetData($e01,"Connecting Internet Time Server...")
TCPStartUp()
$socket = TCPConnect( $g_IP, 37 )
If $socket = -1 Then 
	GUICtrlSetData($e01,"RFC868 via TCP Failed")
	Sleep(1000)
	GUICtrlSetData($e01,"Now Trying RFC868 via UDP")
	udpsync()
	If GUICtrlRead($e01)="Please Choose Another Server and Try Again!" Then Return
EndIf	
While 1
	If $socket > 0 Then 
		$recv = TCPRecv( $socket, 512 )
	EndIf
	If $recv <> "" Then 
		$a = Asc(StringMid($recv,1,1))*256^3+Asc(StringMid($recv,2,1))*256^2+Asc(StringMid($recv,3,1))*256+Asc(StringMid($recv,4,1))+$a1
		If GUICtrlRead($ckb01) = 1 Then setpctime()
		GUICtrlSetData($e01," Cesium Clock Time Now is: "& _DateAdd ( 's', $a, "1900/01/01 00:00:00"))
		ExitLoop
	EndIf	
WEnd
TCPCloseSocket ( $socket )
TCPShutdown ( )
EndFunc

Func udpsync()
$a=UDPStartup()
$socket = UDPOpen($g_IP, 37)
If @error <> 0 Then Return
$begin = TimerInit()
While 1
	If $socket[1] > 0 Then 
		UDPSend($socket, "")	
		$recv = UDPRecv( $socket, 512 )
	EndIf
	If $recv <> "" Then 
		$a = Asc(StringMid($recv,1,1))*256^3+Asc(StringMid($recv,2,1))*256^2+Asc(StringMid($recv,3,1))*256+Asc(StringMid($recv,4,1))+$a1
		If GUICtrlRead($ckb01) = 1 Then setpctime()
		GUICtrlSetData($e01,"Cesium Clock Time Now is: "& _DateAdd ( 's', $a, "1900/01/01 00:00:00"))
		$socket[1] = 0 
		ExitLoop
	EndIf
If TimerDiff($begin)>5000 Then 
	GUICtrlSetData($e01,"RFC868 via UDP Failed")
	Sleep(1000)
	GUICtrlSetData($e01,"Please Choose Another Server and Try Again!")
	Return
EndIf	
WEnd
    UDPCloseSocket($socket)
    UDPShutdown()
EndFunc
Func CLOSEClicked()
  Exit
EndFunc

