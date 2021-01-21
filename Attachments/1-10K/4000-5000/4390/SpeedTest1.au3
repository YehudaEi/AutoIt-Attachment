
DirCreate(@ScriptDir & "\test files")
Dim $str = ""
Dim $time = ""
Dim $counter = 0
$transactiontime = 0
$secs = TimerInit()
$total = TimerInit()
For $i = 1 To 100
	For $j = 1 To 200
		$write = TimerInit()
		$str = $str & ($transactiontime & ",") ; ; this bit just records the $str &= transaction time from  the previous loop
		$transactiontime = TimerDiff($write)
	Next
	$str &= @CRLF
	$counter = $counter + 1
	If $counter = 10 Then ; lets get the time for each group of 10 loops
		$time = $time & StringFormat("%.0f", TimerDiff($secs)) & " , "
		$counter = 0
		$secs = TimerInit()
	EndIf
Next
$x = FileOpen(@ScriptDir & "\test files\log.txt", 1)
FileWriteLine($x, $str & @CRLF)
FileClose($x)
$totaltime = StringFormat("%.0f", TimerDiff($total))
$test0 = $time & @CRLF & "Total time using RAM and $str = $str & $blah to store information  :  " & $totaltime
MsgBox(0, "Time in milliseconds for each group of 10 loops", $test0)
Dim $str = ""
Dim $time = ""
Dim $counter = 0
$transactiontime = 0
$secs = TimerInit()
$total = TimerInit()
For $i = 1 To 100
	For $j = 1 To 200
		$write = TimerInit()
		$str &= ($transactiontime & ",") ; ; this bit just records the $str &= transaction time from  the previous loop
		$transactiontime = TimerDiff($write)
	Next
	$str &= @CRLF
	$counter = $counter + 1
	If $counter = 10 Then ; lets get the time for each group of 10 loops
		$time = $time & StringFormat("%.0f", TimerDiff($secs)) & " , "
		$counter = 0
		$secs = TimerInit()
	EndIf
Next
$x = FileOpen(@ScriptDir & "\test files\log.txt", 1)
FileWriteLine($x, $str & @CRLF)
FileClose($x)
$totaltime = StringFormat("%.0f", TimerDiff($total))
$test1 = $time & @CRLF & "Total time using RAM and $str &= $blah to store information  :  " & $totaltime
MsgBox(0, "Time in milliseconds for each group of 10 loops", $test1)

$x = FileOpen(@ScriptDir & "\test files\log.txt", 1)
Dim $str = ""
Dim $time = ""
Dim $counter = 0
$transactiontime = 0
$secs = TimerInit()
$total = TimerInit()
For $i = 1 To 100
	For $j = 1 To 200
		$write = TimerInit()
		FileWrite($x,$transactiontime & ",") ; this bit just records the FileWrite transaction time from  the previous loop
		$transactiontime = TimerDiff($write)
	Next
	FileWrite($x,@CRLF)
	$counter = $counter + 1
	If $counter = 10 Then ; lets get the time for each group of 10 loops
		$time = $time & StringFormat("%.0f", TimerDiff($secs)) & " , "
		$counter = 0
		$secs = TimerInit()
	EndIf
Next
FileClose($x)
$totaltime = StringFormat("%.0f", TimerDiff($total))
$test2 = $time & @CRLF & "Total time using hard drive to store information  :  " & $totaltime
MsgBox(0, "Time in milliseconds for each group of 10 loops", $test2)
MsgBox(0,"tests",$test0  & @CRLF & @CRLF & $test1  & @CRLF & @CRLF & $test2)
