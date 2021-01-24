#NoTrayIcon
Opt("TrayMenuMode", 1)
Global Const $sName = "µTorrent script"

DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $sName)
$lastError = DllCall("kernel32.dll", "int", "GetLastError")
If $lastError[0] == 183 Then
	$wList = WinList("[TITLE:"& $sName &"]")
	If $wList[0][0] > 0 Then
		For $i = 1 To $wList[0][0]
			If WinGetProcess($wList[$i][1]) <> @AutoItPID Then WinActivate($wList[$i][1])
		Next
	EndIf
	Exit
EndIf

$tExit = TrayCreateItem("Exit")
TraySetClick(8)
TraySetToolTip($sName)
TraySetIcon("shell32.dll", 3)
TraySetState(1)

$hWin = WinGetHandle("[TITLE:µTorrent 1.8.1]")
If $hWin == "" Then
	MsgBox(16, $sName, "Couldn't find µTorrent window.", 5)
	Exit
EndIf
$hControl = ControlGetHandle($hWin, "", "[CLASS:SysListView32; INSTANCE:2]")
ControlClick($hWin, "", $hControl, "left", 1, 5, 5)  ; all
$hControl = ControlGetHandle($hWin, "", "[CLASS:SysListView32; INSTANCE:3]")

Do
	$tMsg = TrayGetMsg()
	If $tMsg == $tExit Then Exit
	
	$shutDown = 1
	$tTip = ""
	$count = ControlListView($hWin, "", $hControl, "GetItemCount")
	If $count == 0 Then
		MsgBox(48, $sName, "List is empty.", 5)
		Exit
	EndIf
	For $i = 0 To $count-1
		$name = ControlListView($hWin, "", $hControl, "GetText", $i, 0)
		$procent = Number(ControlListView($hWin, "", $hControl, "GetText", $i, 3))
		$ratio = Number(ControlListView($hWin, "", $hControl, "GetText", $i, 11))
		
		If $procent < 100 Then $shutDown = 0
		If $ratio < 1.5 Then $shutDown = 0
		$tTip &= $name &", "& $procent &"%, "& $ratio
		If $i <> $count-1 Then $tTip &= @CRLF
	Next
	TraySetToolTip($tTip)
Until $shutDown
If Not @Compiled Then
	MsgBox(0, $sName, "Cya!", 5)
	Exit
EndIf

$PID = WinGetProcess($hWin)
Do 
	ProcessClose($PID)
	Sleep(250)
Until Not ProcessExists($PID)
If MsgBox(64, $sName, "Press OK to stop shutdown.", 15) == 1 Then Exit
Shutdown(1)
