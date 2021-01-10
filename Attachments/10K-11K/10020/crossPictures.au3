

; Enter your own $filedir where pictures will be saved!!!
;$bytes is the minimum size of pics u want to download
$filedir = "C:\AA TASKBAR SHORTCUTS\Desk\Hold Basket\crossPictures.txt"
$bytes = 25000
$start = 0
$ended = 0
$linenumb = 0
$file = ""
$pic = 1
$size = ""

$page = InputBox("Cross Pictures", "Enter Page Number (1-425)")

$rssfeed = "                                                  " & $page & "/key_/tm.htm"

$file = FileOpen($filedir, 0)
InetGet($rssfeed, $filedir, 1, 0)

While 1
	$line = FileReadLine($file, $linenumb)
	If @error = -1 Then ExitLoop
	$ended = StringInStr($line, ".jpg")
	If $ended > 0 Then Cut()
	$linenumb = $linenumb + 1
WEnd

MsgBox(0, "", "All Pictures From Page " & $page & " Have Been Downloaded!")
Exit

Func Cut()
	$picsave = $filedir & $page & $pic & ".jpg"
	$start = StringInStr($line, "http", 0, -1)
	$cutright = StringTrimRight($line, StringLen($line) - $ended - 3)
	$cutleft = StringTrimLeft($cutright, $start - 1)
	$size = InetGetSize($cutleft)
	
	If $size > $bytes Then
		SplashTextOn("Downloading", "Pict = " & $pic & @CRLF & "Size = " & $size & "bytes" & @CRLF, "150", "70", "-1", "-1", 2, "", "", "")
		InetGet($cutleft, $picsave, 1, 0)
		SplashOff()
		$pic = $pic + 1
	EndIf
EndFunc  

