#include <Constants.au3>
#include <Process.au3>
FileInstall("on.ico",@WindowsDir,1)
FileInstall("off.ico",@WindowsDir,1)
Opt("TrayIconHide", 1)
while @error <> 4
	Opt("TrayIconHide", 0)
	$foo = Run("arp -a", @SystemDir, @SW_HIDE, $STDOUT_CHILD)

Global $line = ""

While 1
    $line = $line & StdoutRead($foo)
    If @error Then ExitLoop
Wend

$result = StringRegExp($line, "(?i)((?:\d{1,3}\.){3}\d{1,3})\s+?((?:[0-9A-F]{2}-){5}[0-9A-F]{2})", 3)
	$var = Ping("www.AutoItScript.com",250)
For $i = 0 to UBound($result) - 1 step 2
    ;MsgBox(0, UBound($result) / 2, "IP:     " & $result[$i] & @CRLF & "MAC: " & $result[$i+1])
	
	;if $result[$i+1]<>"00-0e-50-bd-c8-72" then TrayTip("Network Watcher","Life Connection From"&$result[$i]&"With the mac address of"& $result[$i+1],4,2)
	if $result[$i]="192.168.1.1" and $result[$i+1]<>"00-14-78-7c-f1-6f" then 
				TrayTip("Ibrahim Ghorabah Network Guard","You are Being Banned From You Router <"&$result[$i+1]&">",1,2)
		TraySetIcon(@WindowsDir&"\Off.ico")
	SoundPlay(@WindowsDir&"\media\Notify.wav",0)
	EndIf
Next
_RunDos("arp -d")
TraySetIcon(@WindowsDir&"\On.ico")
sleep(2000)
Wend