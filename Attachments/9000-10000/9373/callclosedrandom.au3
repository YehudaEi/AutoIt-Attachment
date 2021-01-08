Opt("WinTitleMatchMode", 2)

Dim $name[4]
Dim $phone[4]
Dim $ext[4]
Dim $location[4]
Dim $issue[4][50]
$line = 1
$exit = 0
$x = 0

HotKeySet("{ESC}", "Close")

;Retrieves date and modifys it to yesterdays date
$day = @MDAY
$month = @MON
$year = @YEAR
If $day = 1 then
	If $month = 01 then
		$day = 31
		$month = 12
		$year = $year - 1
	ElseIf $month = 02 then
		$day = 31
		$month = 01
	ElseIf $month = 03 then
		$day = 31
		$month = 02
	ElseIf $month = 04 then
		$day = 31
		$month = 03
	ElseIf $month = 05 then
		$day = 30
		$month = 04
	ElseIf $month = 06 then
		$day = 31
		$month = 05
	ElseIf $month = 07 then
		$day = 30
		$month = 06
	ElseIf $month = 08 then
		$day = 31
		$month = 07
	ElseIf $month = 09 then
		$day = 31
		$month = 08
	ElseIf $month = 10 then
		$day = 30
		$month = 09
	ElseIf $month = 11 then
		$day = 31
		$month = 10
	ElseIf $month = 12 then
		$day = 30
		$month = 11
	EndIf
Else
	$day = $day - 1
EndIf

$date = $year & "-" & $month & "-" & $day

WinActivate("Call Logging")
Sleep("700")

MouseClick("left", 1015, 35)
Sleep("1500")
MouseClick("left", 1015, 35)

;For $x = 250 to 151 Step -7
;	MouseClickDrag("left", $x, 625, 150, 625, 0)
;Next

;Searches for yesterdays tickets
Send("^o")
Sleep("300")
Send("{ENTER}")
Sleep("300")
If WinExists("Save Call") then Send("a")
Sleep("300")
MouseClick("left", 710, 470)
Sleep("300")
MouseClick("right", 710, 470)
Sleep("300")
MouseClick("left", 740, 600)
Sleep("300")
Send("+{END}")
Send("{DEL}")
Send($date)
Send("{TAB}")
Send("{TAB}")
Send("{SPACE}")
Sleep("200")
Send("{ENTER}")

Sleep("1000")
;Retrieves the number of tickets found
$title = WinGetTitle("Call Logging")
$of = StringInStr($title, "of", 0, -1)
$title = StringTrimLeft(StringTrimRight($title, 1), $of + 2)

For $num = 0 to 3
	;Generates a random ticket to scroll to
	$clicks = Random(0, $title - 1, 1)

	;Scrolls to the ticket
	MouseClick("left", 370, 60, $clicks)
	Sleep("700")

	;Retrieve name and phone number
	MouseClick("left", 255, 120)
	Send("{END}")
	Send("+{HOME}")
	Send("^c")
	$name[$num] = ClipGet()
	
	While $name[$num] = "External"
		MouseClick("left", 415, 55)
		$clicks = Random(0, $title, 1)
		MouseClick("left", 370, 60, $clicks)
		Sleep("700")
		MouseClick("left", 255, 120)
		Send("{END}")
		Send("+{HOME}")
		Send("^c")
		$name[$num] = ClipGet()
	WEnd
	
	While $name[$num] = "grafx_grafx"
		MouseClick("left", 415, 55)
		$clicks = Random(0, $title, 1)
		MouseClick("left", 370, 60, $clicks)
		Sleep("700")
		MouseClick("left", 255, 120)
		Send("{END}")
		Send("+{HOME}")
		Send("^c")
		$name[$num] = ClipGet()
	WEnd

	MouseClick("left", 380, 155)
	Send("{END}")
	Send("+{HOME}")
	Send("^c")
	$phone[$num] = ClipGet()
	MouseClick("left", 425, 150)
	Send("{END}")
	Send("+{HOME}")
	Send("^c")
	$ext[$num] = ClipGet()
	If $ext[$num] = $phone[$num] then $ext[$num] = ""
	MouseClick("left", 720, 150)
	Send("{END}")
	Send("+{HOME}")
	Send("^c")
	$location[$num] = ClipGet()
	MouseClick("left", 220, 260)
	For $line = 0 to 49
		Send("{END}")
		Send("+{HOME}")
		Send("^c")
		$lastline = $line - 1
		If $line <> 0 then
			If ClipGet() = $issue[$num][$lastline] then
				$line = $line - 1
				If $exit = 12 then ExitLoop
				$exit = $exit + 1
			Else
				$exit = 0
				$issue[$num][$line] = ClipGet()
			EndIf
		Else
			$issue[$num][$line] = ClipGet()
		EndIf
		Send("{DOWN}")
	Next

	;Reset ticket
	MouseClick("left", 415, 55)
Next

$file = FileOpen(@ScriptDir & "\closed.txt", 1)

For $num = 0 to 3
	FileWriteLine($file, "Name: " & $name[$num])
	If $ext[$num] <> "" then
		If $phone[$num] <> "" then FileWriteLine($file, "Phone Number: " & $phone[$num] & "    x" & $ext[$num])
	Else
		If $phone[$num] = "" then
			FileWriteLine($file, "Ext: " & $ext[$num])
		Else
			FileWriteLine($file, "Phone Number: " & $phone[$num])
		EndIf
	EndIf
	FileWriteLine($file, "Location: " & $location[$num])
	FileWriteLine($file, "Issue:")
	For $line = 0 to (UBound($issue, 2) - 1)
		$lastline = $line -1
		If $line <> 0 then
			If $issue[$num][$line] <> "" then
				FileWriteLine($file, "        " & $issue[$num][$line])
			EndIf
		Else
			FileWriteLine($file, "        " & $issue[$num][$line])
		EndIf
	Next
	FileWriteLine($file, " ")
Next

FileWriteLine($file, " ")
FileWriteLine($file, "-----------------------------------")
FileWriteLine($file, " ")
FileClose($file)

Func Close()
	Exit
EndFunc;==>Close