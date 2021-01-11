#Include <Constants.au3>
#include <Misc.au3>
#include <Array.au3>

$numbers = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Call Ignore","Ignore Numbers")
If $numbers = "" Then
$numbers = "2105860050||8003264593||"
EndIf

Dim $ignoreon = True, $ignoreall = False
TrayTip("","Starting Call Ignore Monitor…",10,16)

Opt("TrayMenuMode",3)
Opt("TrayOnEventMode",1)
TraySetClick(18)
$checkitem = TrayCreateItem("Ignore Toggle",-1,-1)
TrayItemSetState($checkitem, $TRAY_CHECKED)
TrayItemSetOnEvent($checkitem,"CheckToggle")
$autoitem = TrayCreateItem("Auto Ignore All Calls",-1,-1)
TrayItemSetOnEvent($autoitem,"AutoToggle")
TrayCreateItem("",-1)
$additem = TrayCreateItem("Add Number to Ignore List…",-1,-1)
TrayItemSetOnEvent($additem,"AddNumber")
$delitem = TrayCreateItem("Delete Number from Ignore List…",-1,-1)
TrayItemSetOnEvent($delitem,"DeleteNumber")
$listitem = TrayCreateItem("List Numbers in Ignore List…",-1,-1)
TrayItemSetOnEvent($listitem,"ListNumbers")
TrayCreateItem("",-1)
$exit = TrayCreateItem("Exit",-1)
TrayItemSetOnEvent($exit,"_exiter")

While 1
	If $ignoreon Then
 		;If WinExists("Dialog -  142") Then
		If WinExists("V.92 Modem On Hold") Then
			If $ignoreall Then
				$handle = WinGetHandle("V.92 Modem On Hold");WinGetHandle("Dialog -  142")
				$person = ControlGetText($handle,"",1019)
				$name = StringRegExp($person,"Name:\s(.*)$",3)
				$number = StringRegExp($person,"Number:\s(\d{10})",3)
				ControlClick($handle,"",1035,"left",1)
				If IsArray($name) And IsArray($number) Then
				TrayTip("Auto Ignoring Call… (All Call Ignore ON)","Name: " & $name[0] & @CRLF & "Number: ("&StringLeft($number[0],3)&")"&StringMid($number[0],4,3)&"-"&StringRight($number[0],4),10,17)
				Else
				TrayTip("Auto Ignoring Call… (All Call Ignore ON)","Call Auto Ignored",10,16)
				EndIf
				Sleep(500)
				WinSetState($handle,"",@SW_HIDE)
				WinWaitClose($handle)
				TrayTip("","Internet Connection Resumed…",10,16)
			Else
		$handle = WinGetHandle("V.92 Modem On Hold");WinGetHandle("Dialog -  142")
		$person = ControlGetText($handle,"",1019)
		$name = StringRegExp($person,"Name:\s(.*)$",3)
			$numarray = StringRegExp($numbers,"(\d{10})\||",3)
			For $i = 0 to (UBound($numarray) - 1)
				If StringInStr($person,"Number: " & $numarray[$i]) Then
					If IsArray($name) Then
					TrayTip("Ignoring Call From Ignore List……","Name: " & $name[0] & @CRLF & "Number: ("&StringLeft($numarray[$i],3)&")"&StringMid($numarray[$i],4,3)&"-"&StringRight($numarray[$i],4),10,17)
					Else
					TrayTip("Ignoring Call from Ignore List…","Number: "&$numarray[$i],10,16)
					EndIf
					ControlClick($handle,"",1035,"left",1)
					Sleep(500)
					WinSetState($handle,"",@SW_HIDE)
					WinWaitClose($handle)
					TrayTip("","Internet Connection Resumed…",10,16)
				EndIf
			Next
			EndIf
		EndIf
	EndIf
	Sleep(50)
WEnd

Func CheckToggle()
	$ignoreon = NOT $ignoreon
	If $ignoreon Then
	TrayItemSetState($checkitem, $TRAY_CHECKED)
	TrayItemSetState($autoitem,$TRAY_ENABLE)
	Else
	TrayItemSetState($checkitem, $TRAY_UNCHECKED)
	TrayItemSetState($autoitem, $TRAY_UNCHECKED)
	TrayItemSetState($autoitem,$TRAY_DISABLE)
	$ignoreall = False
	EndIf
	TrayTip("","Call Ignore Monitoring " & _Iif($ignoreon,"Enabled…","Disabled…"),10,16)
EndFunc

Func AutoToggle()
	$ignoreall = NOT $ignoreall
	If $ignoreall Then
	TrayItemSetState($autoitem, $TRAY_CHECKED)
	Else
	TrayItemSetState($autoitem, $TRAY_UNCHECKED)
	EndIf
	TrayTip("","Ignore ALL Calls " & _Iif($ignoreall,"Enabled…","Disabled…"),10,16)
EndFunc

Func AddNumber()
$inumber = InputBox("Number to Add To Ignore List","Please Enter the 10 digit number to add to the Ignore List…" & @CRLF & "Eg.: 5555555555",""," 10","-1","-1","-1","-1")
Select
   Case @Error = 0 ;OK - The string returned is valid
	If StringInStr($numbers,$inumber&"||") Then
		MsgBox(4096,"Number Already In List!","Number Already In List!")
	Else
		$numbers = $numbers & $inumber & "||"
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Call Ignore","Ignore Numbers","REG_SZ",$numbers)
		MsgBox(4096,"Number Added!","Number Added!",10)
	EndIf
   Case @Error = 1 ;The Cancel button was pushed
   Case @Error = 3 ;The InputBox failed to open
EndSelect
EndFunc

Func DeleteNumber()
$inumber = InputBox("Number to Detete From Ignore List","Please Enter the 10 digit number to delete from the Ignore List…" & @CRLF & "Eg.: 5555555555",""," 10","-1","-1","-1","-1")
Select
   Case @Error = 0 ;OK - The string returned is valid
	If $inumber = "2105860050" or $inumber =  "8003264593" Then
		MsgBox(4096,"Cannot Remove Number!","Number Entered is Either Chase or Capital One, and Will NOT Be Removed")
	Else
	If NOT StringInStr($numbers,$inumber&"||") Then
		MsgBox(4096,"Number Not In List!","Number Not In List!")
	Else
		$numarray = StringRegExp($numbers,"(\d{10})\||",3)
		For $i = 0 to UBound($numarray) - 1
		If $numarray[$i] = $inumber Then
			_ArrayDelete($numarray,$i)
			MsgBox(4096,"Number Deleted!","Number Deleted!",10)
			ExitLoop
		EndIf
		Next

		For $i = 0 To UBound($numarray) - 1
			If $i > 0 Then
				$numbers = $numbers & $numarray[$i] & "||"
			Else
				$numbers = $numarray[$i] & "||"
			EndIf
		Next
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Call Ignore","Ignore Numbers","REG_SZ",$numbers)
	EndIf
	EndIf
   Case @Error = 1 ;The Cancel button was pushed
   Case @Error = 3 ;The InputBox failed to open
EndSelect
	
EndFunc

Func ListNumbers()
$lister = ""
	$numarray = StringRegExp($numbers,"(\d{10})\||",3)
	For $i = 0 to UBound($numarray) - 1
	If $i > 0 Then
		$lister = $lister & @CRLF & "(" & StringLeft($numarray[$i],3) & ")" & StringMid($numarray[$i],4,3) & "-" & StringMid($numarray[$i],7,4)
	Else
		$lister = "(" & StringLeft($numarray[$i],3) & ")" & StringMid($numarray[$i],4,3) & "-" & StringMid($numarray[$i],7,4)
	EndIf
	Next
MsgBox(4096,"Number List:","The Following Numbers are on the Ignore List:" & @CRLF & $lister)
EndFunc

Func _exiter()
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Call Ignore","Ignore Numbers","REG_SZ",$numbers)
	Exit
EndFunc