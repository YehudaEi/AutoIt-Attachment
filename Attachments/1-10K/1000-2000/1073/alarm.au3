
$a = InputBox("hour", "hour", "1", "",)
$b = InputBox("minute", "minute", "1", "",)
$c = InputBox("what song", "1 = beatles            2 = starwars - soundtrack            3 = behtoven             4 = Jarassic Park - soundtrack             5 = Titanic - soundtrack", "", "",)
$d = 1
$e = 1
$f = 2000

$q = @ScriptDir & "\alarm.ini"

if $a = 1 Then
	$a = @HOUR
EndIf
if $b = 1 Then
	$b = @min
EndIf

if $c = 1 Then
	$c = IniRead($q, "music", "1","not found")
ElseIf $c = 2 Then
	$c = IniRead($q, "music", "2","not found")
ElseIf $c = 3 Then
	$c = IniRead($q, "music", "3","not found")
ElseIf $c = 4 Then
	$c = IniRead($q, "music", "4","not found")
ElseIf $c = 5 Then
	$c = IniRead($q, "music", "5","not found")
EndIf

if $a = @hour and $b = @min Then
	send("#r")
	sleep(100)
	Send($c)  
	 send("{enter}")
	 sleep(100)
	 send("^a")
     send("{enter}")
EndIf
	
if $c = "E:\My Shared Folder\share\Full Albums\John Williams-Star Wars"Then
$f = 10
EndIf

Do 
	Sleep($f)
	Send("{volume_up}")
	$d = $d +1
	sleep($f)
until $d = 30
sleep(6000) 
 if $c = "E:\My Shared Folder\share\Full Albums\John Williams-Star Wars" Then
	do 
		send("{volume_down}")
		$e = $e + 1
	Until $e  = 30
EndIf

$f = 2000
Do 
	Sleep($f)
	Send("{volume_up}")
	$d = $d +1
	sleep($f)
until $d = 25

IniWrite($q,"music","checkdir","1")

