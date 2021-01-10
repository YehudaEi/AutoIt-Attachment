$time1=0
$time2=0
$time3=0

For $x = 1 to 10
	$time1 += Method1()
	$time2 += Method2()
	$time3 += Method3()
	Sleep(Random(200,700))
Next

$time1/=10
$time2/=10
$time3/=10

ConsoleWrite("PsaltyDS' Method Average Time: " & $time1 & " milliseconds" & @CRLF)
ConsoleWrite("Zedna's Method Average Time: " & $time2 & " milliseconds" & @CRLF)
ConsoleWrite("BrettF's Method Average Time: " & $time3 & " milliseconds" & @CRLF)

Func Method1() ;PsaltyDS' Method
	$timer = TimerInit()
	$avArray = StringRegExp("abcdefghijklmnopqrstuvwxyz", ".", 3)
	$timer = TimerDiff($timer)
	Return $timer
EndFunc

Func Method2() ;Zedna's Method
	$timer = TimerInit()
	$avArray = StringSplit("abcdefghijklmnopqrstuvwxyz", "")
	$timer = TimerDiff($timer)
	Return $timer
EndFunc

Func Method3() ;BrettF's Method
	$timer = TimerInit()
	Dim $array[26]
	For $i = 0 to 25
		$array[$i] = Chr (65+$i)
	Next
	$timer = TimerDiff($timer)
	Return $timer
EndFunc