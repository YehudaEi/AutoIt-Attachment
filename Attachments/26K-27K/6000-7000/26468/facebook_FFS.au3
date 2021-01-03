; FACEBOOK FRIENDS FOR SALE
#include <IE.au3>
#include <Date.au3>
#include <Array.au3>
#include <String.au3>
_IELoadWaitTimeout(10000)


; GET FRIEND DATA

$me = "Marian Jancuska"
$done = 0
$file = FileOpen("FFS.csv", 0) ; ====================== SOURCE FILENAME HERE

; Check if file opened for reading OK
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

; Count lines in file
$linecount = 0
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	$linecount = $linecount + 1
WEnd
;MsgBox(0, "Line count:", $linecount)
$items = $linecount
; Count columns in file (based on split of 1st row - delimiter: ",")
$line = FileReadLine($file, 1)
$ara = StringSplit($line, ",")
$colcount = $ara[0]
;MsgBox(0, "Cols read:", $colcount)

; Define target array based on source CSV file dimensions
Dim $myArray[$linecount][$colcount] ;element 0,0 to 999,1

; Read data from file and write them to array
$ro = 0
While 1
	
	$line = FileReadLine($file, $ro + 1)
	If @error = -1 Then ExitLoop
	;MsgBox(0, "Line read:", $line)
	$ara = StringSplit($line, ",") ; text to columns to array... , delimiter:  ","
	;_ArrayDisplay( $ara, "Entries in the array" )
	$co = 0
	While $colcount > $co
		$myArray[$ro][$co] = $ara[$co + 1] ; fill myArray
		$co = $co + 1
	WEnd
	;_ArrayAdd( $myArray,5)
	;_ArrayDisplay($myArray, "Entries in the array")
	If $ro = $linecount - 1 Then
		ExitLoop
	EndIf
	$ro = $ro + 1
	
WEnd



Do
	ConsoleWrite("Initializing... (" & _Now() & ")" & @CRLF)
	$oIE = _IECreate("about:blank", 0, 1)
	$oIE = _IEAttach("about:blank", "url")
	_IELoadWait($oIE)
	Sleep(1500)
	For $i = 0 To $items - 1 Step 1
		ConsoleWrite(_Now() & ": Checking item #" & $i + 1 & "(" & $myArray[$i][0] & ")")
		_IENavigate($oIE, "http://apps.facebook.com/friendsforsale/users/show/" & $myArray[$i][0])
		_IELoadWait($oIE)

		Sleep(3000)
		$sText = _IEBodyReadText($oIE)
		;MsgBox(0, "Body Text", $sText)
		
		$pos = StringInStr($sText, "can only be purchased by friends while he or she is uninstalled")
		If $pos > 0 Then
			$pos = StringInStr($sText, "|  Help") ; [, casesense [, occurrence [, start [, count]]]] )
			;MsgBox(0, "tmp", $pos)
			$sText = StringTrimLeft($sText, $pos - 1)
			;MsgBox(0, "Body Text", $sText)
			$pos1 = StringInStr($sText, "can only be purchased by friends while he or she is uninstalled") ; [, casesense [, occurrence [, start [, count]]]] )
			;MsgBox(0, "tmp", $pos1)
			$name = StringMid($sText, 14, $pos1 - 14 - 1)
			;MsgBox(0, "Body Text", ">" & $name & "<")
		Else
			$pos = StringInStr($sText, "|  Help") ; [, casesense [, occurrence [, start [, count]]]] )
			;MsgBox(0, "tmp", $pos)
			$sText = StringTrimLeft($sText, $pos - 1)
			;MsgBox(0, "Body Text", $sText)
			$pos1 = StringInStr($sText, "“") ; [, casesense [, occurrence [, start [, count]]]] )
			;MsgBox(0, "tmp", $pos1)
			$name = StringMid($sText, 14, $pos1 - 14 - 3)
			;MsgBox(0, "Body Text", ">" & $name & "<")
		EndIf
		

		$pos = StringInStr($sText, "“") ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos)
		$sText = StringTrimLeft($sText, $pos)
		;MsgBox(0, "Body Text", $sText)
		$pos1 = StringInStr($sText, "”") ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos1)
		$desc = StringMid($sText, 1, $pos1 - 1)
		;MsgBox(0, "Body Text", ">" & $desc & "<")
		
		$pos = StringInStr($sText, "Value: $") ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos)
		$sText = StringTrimLeft($sText, $pos - 1)
		;MsgBox(0, "Body Text", $sText)
		$pos1 = StringInStr($sText, "Cash:") ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos1)
		$value = StringMid($sText, 9, $pos1 - 9 - 3)
		;MsgBox(0, "Body Text", ">" & $value & "<")
		$value = StringReplace($value, ",", "")

		$pos = StringInStr($sText, "s Owner") ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos)
		$sText = StringTrimLeft($sText, $pos - 1)
		;MsgBox(0, "Body Text", $sText)
		$pos1 = StringInStr($sText, "”") ; [, casesense [, occurrence [, start [, count]]]] )
		;MsgBox(0, "tmp", $pos1)
		$owner = StringMid($sText, 11, $pos1 - 11 - 2)
		;MsgBox(0, "Body Text", ">" & $owner& "<")
		
		IniWrite("FFS.ini", $myArray[$i][0], "name", $name)
		IniWrite("FFS.ini", $myArray[$i][0], "desc", $desc)
		IniWrite("FFS.ini", $myArray[$i][0], "value", $value)
		IniWrite("FFS.ini", $myArray[$i][0], "owner", $owner)

		If $owner = $me Then
			ConsoleWrite(" ... This one is already mine B-)" & @CRLF)
		Else
			ConsoleWrite(" ... buying")
			;_IELinkClickByText($oIE, "Buy for ")
			$sMyString = "Buy for"
			$oLinks = _IELinkGetCollection($oIE)
			For $oLink In $oLinks
				$sLinkText = _IEPropertyGet($oLink, "innerText")
				If StringInStr($sLinkText, $sMyString) Then
					_IEAction($oLink, "click")
					ExitLoop
				EndIf
			Next
			Sleep(3000)
			;_IELinkClickByText($oIE, "Purchase for ")
			Send("+{TAB}")
			Sleep(300)
			Send("{ENTER}")
			ConsoleWrite(" ... done" & @CRLF)
			Sleep(2000)
			_IELoadWait($oIE)
		EndIf
		
	Next
	_IEQuit($oIE)
	Sleep(10000)
Until $done = 1
_IEQuit($oIE)
ConsoleWrite("DONE..." & @CRLF)
Sleep(2500)
Exit