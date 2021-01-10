#include <IE.au3>
#include <array.au3>
#include <file.au3>

Dim $username, $password, $villageid

$username = ""
$password = ""
$villageid = ""

While 1
	$buildqueueex = FileExists(@TempDir & "\buildingstodo.txt")
	If $buildqueueex = 1 Then
	Else
		$builds = InputBox("", "Builds")
		$sepbuild = StringReplace($builds, " ", @CRLF)
		_FileCreate(@TempDir & "\buildingstodo.txt")
		$fobuild = FileOpen(@TempDir & "\buildingstodo.txt", 2)
		FileWrite($fobuild, $sepbuild)
		FileClose($fobuild)
	EndIf
	$buildsnum = _FileCountLines(@TempDir & "\buildingstodo.txt")
	$timesexist = FileExists(@TempDir & "\times.txt")
	If $timesexist <> 1 Then
		_FileCreate(@TempDir & "\times.txt")
		$fotimes = FileOpen(@TempDir & "\times.txt", 2)
		FileWrite($fotimes, "1")
		$currentnum = 1
	Else
		$foforcurr = FileOpen(@TempDir & "\times.txt", 0)
		$currentnum = FileRead($foforcurr)
		FileClose($foforcurr)
	EndIf
	$fobuild1 = FileOpen(@TempDir & "\buildingstodo.txt", 0)
	$buildid = FileReadLine($fobuild1, $currentnum)
	FileClose($fobuild1)
	$oIE = _IECreate("gr2.ds.ignames.net")
	_IELoadWait($oIE)
	$user = _IEGetObjById($oIE, "user")
	$pass = _IEGetObjById($oIE, "password")
	$server = _IEGetObjByName($oIE, 'server')
	$signin = _IEGetObjByName($oIE, "login-btn-input")
	_IEFormElementOptionSelect($server, "gr2")
	_IEFormElementSetValue($user, $username)
	_IEFormElementSetValue($pass, $password)
	_IEAction($signin, "click")
	_IELoadWait($oIE)
	$aIE = _IECreate("                                              " & $villageid & "&screen=main")
	_IELoadWait($aIE)
	_IEQuit($oIE)
	WinSetState("Φυλετικές Μάχες - Windows Internet Explorer", "", @SW_MAXIMIZE)
	$frame = _IEFrameGetObjByName($aIE, "main")
	For $ist = 1 To 18 Step 1
		$tablesss = _IETableGetCollection($frame, $ist)
		$arr = _IETableWriteToArray($tablesss)
		$ubou = UBound($arr, 2)
		If $ubou > 7 Then
			ExitLoop
		Else
		EndIf
	Next
	For $atz = 0 To $ubou - 1 Step 1
		$string = $arr[0][$atz]
		If StringInStr($string, _wordconverter($buildid)) Then
			$whenwillread = $arr[6][$atz]
			If StringInStr($whenwillread, "η ώρα") Then
				If FileExists(@TempDir & "\sleeptime.txt") Then
				Else
					_FileCreate(@TempDir & "\sleeptime.txt")
				EndIf
				$foshi = FileOpen(@TempDir & "\sleeptime.txt", 1)
				FileWrite($foshi, "The reources will be available at " & StringRight($whenwillread, 5) & " obvious" & @CRLF)
				FileClose($foshi)
				Sleep(_timeuntildl(StringRight($whenwillread, 5)))
			Else
			EndIf
			$timeget = $arr[5][$atz]
			ExitLoop
		Else
		EndIf
	Next
	$links = _IELinkGetCollection($frame)
	For $link In $links
		$checkstring = StringInStr($link.href, $buildid & "&h=")
		If $checkstring = 0 Then
		Else
			ExitLoop
		EndIf
	Next
	If $checkstring = 0 Then
		Sleep(7000000)
	Else
		Sleep(666)
		_IENavigate($aIE, $link.href)
		_IELoadWait($aIE)
		_IEQuit($aIE)
		If FileExists(@TempDir & "\sleeptime.txt") Then
		Else
			_FileCreate(@TempDir & "\sleeptime.txt")
		EndIf
		$fo3 = FileOpen(@TempDir & "\sleeptime.txt", 1)
		FileWrite($fo3, $timeget & " Now Time is: " & @HOUR & @MIN & @SEC & " diladi stis " & _Sleeptime($timeget, 1) & @CRLF)
		FileClose($fo3)
		$fotimes1 = FileOpen(@TempDir & "\times.txt", 0)
		$currentnum = FileRead($fotimes1)
		FileClose($fotimes1)
		$currentnum = $currentnum + 1
		If $currentnum = $buildsnum Then
			FileDelete(@TempDir & "\times.txt")
			FileDelete(@TempDir & "\buildingstodo.txt")
			Exit
		Else
			$fo2 = FileOpen(@TempDir & "\times.txt", 2)
			FileWrite($fo2, $currentnum)
			FileClose($fo2)
		EndIf
		_Sleeptime($timeget)
	EndIf
WEnd
Func _Sleeptime($iendtime, $ichoice = 0)
	
	Local $icheckpositionfhorhour, $iendhour, $icheckpositionsec, $istringlen, $iendsec, $iendmin, $iamallin
	
	$icheckpositionfhorhour = StringInStr($iendtime, ":")
	$iendhour = StringMid($iendtime, 1, $icheckpositionfhorhour - 1)
	$icheckpositionsec = StringInStr($iendtime, ":", 0, -1)
	$istringlen = StringLen($iendtime)
	$iendsec = StringMid($iendtime, $icheckpositionsec + 1, $istringlen - $icheckpositionsec)
	$iendmin = StringMid($iendtime, $icheckpositionfhorhour + 1, $icheckpositionsec - $icheckpositionfhorhour - 1)
	$iamallin = ($iendhour * 60 * 60 * 1000) + ($iendmin * 60 * 1000) + ($iendsec * 1000)
	If $ichoice = 1 Then
		$newsec = $iendsec + @SEC
		$newmin = $iendmin + @MIN
		$newhour = $iendhour + @HOUR
		Select
			Case $newsec >= 60
				$newsec = $newsec - 60
				$newmin = $newmin + 1
				If $newmin >= 60 Then
					$newmin = $newmin - 60
					$newhour = $newhour + 1
				Else
				EndIf
			Case $newsec < 60
				If $newmin >= 60 Then
					$newmin = $newmin - 60
					$newhour = $newhour + 1
				Else
				EndIf
		EndSelect
		If $newhour >= 24 Then $newhour = $newhour - 24
		If $newhour < 10 Then $newhour = "0" & $newhour
		If $newmin < 10 Then $newmin = "0" & $newmin
		If $newsec < 10 Then $newsec = "0" & $newsec
		Return $newhour & ":" & $newmin & ":" & $newsec
	Else
		Sleep($iamallin)
	EndIf
EndFunc   ;==>_Sleeptime
Func _wordconverter($iword)
	Switch $iword
		Case "Smith"
			Return "Οπλουργείο"
		Case "main"
			Return "Επιτελείο"
		Case "wall"
			Return "Τείχος"
		Case "snob"
			Return "Ακαδημία"
		Case "Stable"
			Return "Σταύλος"
		Case "Wood"
			Return "Ξυλουργείο"
		Case "Stone"
			Return "Λατομείο"
		Case "Iron"
			Return "Σιδηρωρυχείο"
		Case "Storage"
			Return "Αποθήκη"
		Case "Farm"
			Return "Αγρόκτημα"
		Case "Barracks"
			Return "Στρατώνας"
		Case "Market"
			Return "Αγορά"
		case "Hide"
			Return "Κρυψώνα"
		case Else
			Return MsgBox(0, "", "i lexi den bre8ike")
	EndSwitch
EndFunc   ;==>_wordconverter
Func _timeuntildl($imwendtime)
	Local $icheckpositionfhorhour, $iendhour, $iendhour, $fh, $fm, $iallsec
	
	$icheckpositionfhorhour = StringInStr($imwendtime, ":")
	$iendhour = StringMid($imwendtime, 1, $icheckpositionfhorhour - 1)
	$iendmin = StringMid($imwendtime, StringLen($imwendtime) - 1, 2)
	Select
		Case $iendhour < @HOUR
			$iendhour = $iendhour + 24
			If $iendmin < @MIN Then
				$iendmin = $iendmin + 60
				$iendhour = $iendhour - 1
			Else
			EndIf
		Case $iendhour > @HOUR
			If $iendmin < @MIN Then
				$iendmin = $iendmin + 60
				$iendhour = $iendhour - 1
			Else
			EndIf
		Case $iendhour = @HOUR
			If $iendmin < @MIN Then
				$iendhour = $iendhour + 23
				$iendmin = $iendmin + 60
			Else
			EndIf
	EndSelect
	$fh = $iendhour - @HOUR
	$fm = $iendmin - @MIN
	$iallsec = $fh * 60 * 60 * 1000 + $fm * 60 * 1000
	Return $iallsec
EndFunc   ;==>_timeuntildl