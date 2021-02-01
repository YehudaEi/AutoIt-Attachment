#include <Date.au3>


While 1
		$sShortDayName = _DateDayOfWeek( @WDAY, 1 )
		$sJulDate = _DateToDayValue (@YEAR, @MON, @MDAY)
		$title=WinGetTitle("")
		$pos=MouseGetPos()
		$mem=MemGetStats()
		sleep(10)
		If $title <> "" Then
			ToolTip($pos[0] & "," & $pos[1] & @CRLF & "Free Memory : " & $mem[2]*100/$mem[1] & " %"& @CRLF & $sShortDayName & " (" & _DateTimeFormat( _NowCalc(),0) & ")" & @CRLF & "You are looking at : " & $title,$pos[0]+10,$pos[1]+10)
		Else
			ToolTip($pos[0] & "," & $pos[1] & @CRLF & "Free Memory : " & $mem[2]*100/$mem[1] & " %"& @CRLF & $sShortDayName & " (" & _DateTimeFormat( _NowCalc(),0) & ")",$pos[0]+10,$pos[1]+10)
		EndIf
WEnd
