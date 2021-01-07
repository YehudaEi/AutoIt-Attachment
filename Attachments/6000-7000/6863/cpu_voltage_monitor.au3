Global $Title = "CPU Voltage Monitor v0.3"
If WinExists("CPU Voltage Monitor v0.3") Then
	$sdnow=10
	Bye()
EndIf
AutoItWinSetTitle($Title)

#Include <Constants.au3>
#NoTrayIcon

Opt("TrayIconHide",1)

HotKeySet("+{ESC}", "Bye")
HotKeySet("+!s", "EShutDown")
HotKeySet("+!v", "Voltage")

Global $Output, $sdnow=0
Global $current_voltage = GetVoltage()
Global $min = $current_voltage - 0.1
Global $max = $current_voltage + 0.1

Alert(0)

$Title = "Auto Settings"
$Output=""
$Output = $Output & "Based on the detected voltage the settings"&b()
$Output = $Output & "below will be used for Tolerance Range:"&b()&b()
$Output = $Output & "               Detected: "&$current_voltage&" V"&b()&b()
$Output = $Output & "         Mininmum Tolerance: "&$min&"00 V"&b()
$Output = $Output & "         Maximum Tolerance : "&$max&"00 V"&b()
MsgBox(64,$Title,$Output,10)

$Title = "Controls"
$Output=""
$Output = $Output & "Here is a list of controls for use with CVM:"&b()&b()
$Output = $Output & "Exit Program"&t()&"SHIFT+ESC"&b()&b()
$Output = $Output & "Emergency"&t()&"SHIFT+ALT+S"&b()
$Output = $Output & "Shutdown"&b()&b()
$Output = $Output & "Current Voltage"&t()&"SHIFT+ALT+V"&b()&b()
MsgBox(64,$Title,$Output,10)

While 1
	$current_voltage = GetVoltage()
	Select
	Case $current_voltage<$min 
		Alert(1)
	Case $current_voltage>$max
		Alert(2)
	Case Else
		Sleep(1000)
	EndSelect
Wend

Func Bye()
	Exit
EndFunc

Func OnAutoItExit()
	Select
		Case $sdnow=1
			Shutdown(13)
		Case $sdnow=0
			$Title = "CPU Voltage Monitor v0.3 - Exit"
			$Output = ""
			$Output = $Output & "      Hope you enjoyed this version."&b()&b()
			$Output = $Output & "Please POST/PM/IM/EMAIL Any and All"&b()
			$Output = $Output & "         Feedback and Criticism :)"&b()
			MsgBox(64,$Title,$Output,10)
		Case $sdnow=10
			$Title = "CPU Voltage Monitor v0.3"
			$Output = ""
			$Output = $Output & " An instance of CPU Voltage Monitor"&b()
			$Output = $Output & "        is already running."
			MsgBox(64,$Title,$Output,10)
	EndSelect
EndFunc

Func Voltage()
		$Title = "CPU Voltage Monitor v0.3"
		$Output = ""
		$Output = $Output & "Current Voltage Detected : "&GetVoltage()&" V"
		MsgBox(64,$Title,$Output,30)
EndFunc

Func EShutDown()
	$Title = "Emergency Shutdown"
	$Output=""
	$Output = $Output & "      Do you want to ShutDown your computer"&b()&b()
	$Output = $Output & "                         IMMEDIATELY?"&b()&b()
	$Output = $Output & "If you click Yes All Programs will be forced to Close"&b()
	$Output = $Output & "   and this computer will ShutDown Immediately."&b()
	$Output = $Output & "        Continue with Emergency ShutDown?"&b()
	If ShowMe($Title,$Output,120)=6 Then
		$Title = "Emergency Shutdown"
		$Output=""
		$Output = $Output & "Are you Sure?"&b()&b()
		If ShowMe($Title,$Output,30)=6 Then
			$sdnow=1
			Bye()
		Else
			Return
		EndIf
	EndIf
EndFunc

Func b()
	Return @CRLF
EndFunc

Func t()
	Return @TAB
EndFunc

Func ShowMe($T,$O,$to=10)
	SoundPlay(@WindowsDir & "\media\chord.wav",0)
	Return Msgbox(4096+4,$T,$O,$to)
EndFunc

Func Alert($lvl)
	Select
	Case $lvl = 0 ;welcome message
			$Title = "CPU Voltage Monitor v0.3"
			$Output = $Output & "CPU Voltage Monitor will alert you if your" & b()
			$Output = $Output & "CPU Voltage rises above or drops below" & b()
			$Output = $Output & "1/10th of your Current Voltage Detected." & b()&b()
			$Output = $Output & "                 Want to Continue?"& b()& b()
			$Output = $Output & "Click Yes to Continue or Click No to Abort." & b()
			If ShowMe($Title,$Output,100)=7 Then
				Bye()
			Else
				Return
			EndIf
		Case $lvl = 1 ;below tolerance
			$Title = "CPU Voltage Alert"
			$Output=""
			$Output = $Output & "Your CPU Voltage is below tolerance."&b()&b()
			$Output = $Output & "         Minimum Voltage  : "&$min&" V"&b()
			$Output = $Output & "         Detected Voltage : "&$current_voltage&" V"&b()&b()
			$Output = $Output & "    Do Emergency Shutdown?"&b()
			If ShowMe($Title,$Output)=6 Then
				$sdnow=1
				Bye()
			Else
				Return
			EndIf
		Case $lvl = 2 ;above tolerance
			$Title = "CPU Voltage Alert"
			$Output=""
			$Output = $Output & "Your CPU Voltage is above tolerance."&b()&b()
			$Output = $Output & "         Maximum Voltage : "&$max&" V"&b()
			$Output = $Output & "         Detected Voltage : "&$current_voltage&" V"&b()&b()
			$Output = $Output & "    Do Emergency Shutdown?"&b()
			If ShowMe($Title,$Output)=6 Then
				$sdnow=1
				Bye()
			Else
				Return
			EndIf
		Case Else
			Return
	EndSelect
EndFunc

Func GetVoltage()
	Local $objWMIService, $strComputer = ".", $objItem, $colItems
	Local $voltage
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
	$colItems = $objWMIService.ExecQuery("Select * from Win32_Processor")
	If IsObj($colItems) then
		For $objItem In $colItems
			$voltage=$objItem.CurrentVoltage
		Next
	EndIf
	$voltage = StringLeft($voltage,1)&"."&StringRight($voltage,Stringlen($voltage)-1)&"00"
	Return $voltage
EndFunc