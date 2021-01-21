#Include <date.au3>
Dim $text
Dim $result
Dim $file
Dim $app
;path to log file
$file = "<path>\form1.log"
;path to sample application
$app = "<path>\WindowsApplication1.exe"

$filelog = FileOpen($file, 2)

Run($app)
WinWaitActive("Form1")
TestRadioButton()
TestCheckbox()

Func TestRadioButton()
	ControlFocus("Form1", "", "WindowsForms10.BUTTON.app35")
	$result = ControlCommand("Form1", "", "WindowsForms10.BUTTON.app35", "IsChecked", "")
	WriteToLog("Error 1: " & @error)
	If $result = 1 Then	
		WriteToLog("RadioButton2 is checked")
		ControlCommand("Form1", "", "WindowsForms10.BUTTON.app35", "UnCheck", "")
		WriteToLog("Error 2: " & @error)
	Else
		WriteToLog("RadioButton2 is unchecked")
		ControlFocus("Form1", "", "WindowsForms10.BUTTON.app35")
		ControlCommand("Form1", "", "WindowsForms10.BUTTON.app35", "Check", "")
		WinWait("Form1", "", 5)
		WriteToLog("Error 3: " & @error)
	EndIf
	ControlFocus("Form1", "", "WindowsForms10.BUTTON.app35")
	$result = ControlCommand("Form1", "", "WindowsForms10.BUTTON.app35", "IsChecked", "")
	WriteToLog("Error 4: " & @error)
	If $result = 1 Then	
		WriteToLog("RadioButton2 is checked")
	Else
		WriteToLog("RadioButton2 is unchecked")
	EndIf
EndFunc

Func TestCheckbox()
	ControlFocus("Form1", "", "WindowsForms10.BUTTON.app33")
	$result = ControlCommand("Form1", "", "WindowsForms10.BUTTON.app33", "IsChecked", "")
	WriteToLog("Error 1: " & @error)
	If $result = 1 Then	
		WriteToLog("CheckBox1 is checked")
		ControlCommand("Form1", "", "WindowsForms10.BUTTON.app33", "UnCheck", "")
		WriteToLog("Error 2: " & @error)
	Else
		WriteToLog("CheckBox1 is unchecked")
		ControlFocus("Form1", "", "WindowsForms10.BUTTON.app33")
		ControlCommand("Form1", "", "WindowsForms10.BUTTON.app33", "Check", "")
		WinWait("Form1", "", 5)
		WriteToLog("Error 3: " & @error)
	EndIf
	ControlFocus("Form1", "", "WindowsForms10.BUTTON.app33")
	$result = ControlCommand("Form1", "", "WindowsForms10.BUTTON.app33", "IsChecked", "")
	WriteToLog("Error 4: " & @error)
	If $result = 1 Then	
		WriteToLog("CheckBox1 is checked")
	Else
		WriteToLog("CheckBox1 is unchecked")
	EndIf
EndFunc
	
Func WriteToLog($text)
	FileWriteLine($filelog, _Now() & " " & $text)
EndFunc
