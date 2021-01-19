#include <Process.au3>
ProcessClose("doscan.exe")
TrayTip("Intruder Detector","Program By: Ibrahim Ghorabah",2)
Do
$rc = _RunDos("arp -a >c:\ArpList.bin")
$Size=FileGetSize("c:\ArpList.bin")
$intruder=FileRead("c:\ArpList.bin")
if $Size>142 then 
	TrayTip("Network Watcher","Life Connection From"&$intruder,4,2)
	FileWrite("c:\intruderList.txt",@HOUR&":"&@MIN&"--<Connection From:-"&$intruder)
_RunDos("arp -d")
EndIf
	Sleep(5000)
Until $rc=1



