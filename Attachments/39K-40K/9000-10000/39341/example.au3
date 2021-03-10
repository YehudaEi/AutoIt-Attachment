#include <FF.au3>

Func _RunScript()
	$cdown = TimerInit()
	$cdowntime = 600000;10min, adjust here
	do
		$cdif = TimerDiff($cdown)
		$trload= $cdowntime-$cdif
		$dummy = $trload/1000
		$dummy2= mod ($dummy, 3600)
		$hours = ($dummy-$dummy2) / 3600
		$dummy = $dummy2
		$dummy2= mod ($dummy, 60)
		$minutes = ($dummy-$dummy2) / 60
		$dummy = $dummy2
		$seconds= round($dummy)	
		TrayTip("","relaunch in: "&$minutes&" minutes, "&$seconds&" seconds ",999)
		sleep(500)
	until TimerDiff($cdown) > $cdowntime
	TrayTip("","relaunching now",999)
	_FFQuit()
	sleep(3000)
	If @compiled then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc
	
Global $last = TimerInit()
Func relaunch()
	$gdif = TimerDiff($last)
	$gdiftime = 600000;10min, relaunch after this amount of time
	$tcountdown = 300000;5min time till relaunch countdown
	If $gdif > $gdiftime Then
		TrayTip("","relaunching now",999)
		If @compiled then
			Run(FileGetShortName(@ScriptFullPath))
		Else
			Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
		EndIf
		Exit
	ElseIf $gdif > $tcountdown Then;3mins
		$trload= $gdiftime-$gdif
		$dummy = $trload/1000
		$dummy2= mod ($dummy, 3600)
		$hours = ($dummy-$dummy2) / 3600
		$dummy = $dummy2
		$dummy2= mod ($dummy, 60)
		$minutes = ($dummy-$dummy2) / 60
		$dummy = $dummy2
		$seconds= round($dummy)	
		TrayTip("","relaunch in: "&$minutes&" minutes",999)
		sleep(500)
	EndIf
	sleep(50)
EndFunc

$sURL = "http://www.sitename.com/somepage.php"
If _FFStart($sURL, Default, 2) <> 1 Then
	_RunScript();if canot connect then relaunch
EndIf

while 1;main loop
	If _FFIsConnected() Then;make sure mozrepl is running and connectable
		If _FFLoadWait() <> 1 Then;make sure that the page loads
			_RunScript();if canot connect then relaunch
		EndIf
	EndIf
	$last = TimerInit()
	while 1;process loop
		relaunch();if no activity relaunch
		$sText = _FFReadHTML("body",10)
		If StringInStr($sText, "stuff im lookin for", 1) > 1 Then
			;do some stuff with the text i found
			;do some stuff with the text i found
			;do some stuff with the text i found
			;do some stuff with the text i found
			Exitloop;yay I found it, im done with this page.
		EndIf
		sleep(100)
	wend
	;click link that takes me to next page
	sleep(1000)
wend