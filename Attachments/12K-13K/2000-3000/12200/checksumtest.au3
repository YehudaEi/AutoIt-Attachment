$x = 0
$barf = 0

local $test_checksum = PixelChecksum(1, 1, 20, 20)

while $barf < 1
	$sum = PixelChecksum(1, 1, 20, 20)
	If $sum <> $test_checksum Then
		$barf = $barf + 1
	Else
		$barf = 0
	EndIf
	
	consolewrite("Test number: " & $x & @LF)
	consolewrite("Checksum: " & $sum & @LF)
	
	$x = $x + 1
WEnd

MsgBox(8192, "Barf!", "Test number: " & $x)
