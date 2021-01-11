$Email = InputBox("Email:", "Email:", "", "", 100, 10)
If $Email = "" Then
	MsgBox(0, "Error:", "Input An Email Address")
	Exit
EndIf
$oMessenger = ObjCreate("Messenger.UIAutomation.1")
$Status = $oMessenger.GetContact($Email, $oMessenger.MyServiceId).Status
Switch $Status
	Case 1
		MsgBox(0, "", $Email & " Is Offline")
	Case 2
		MsgBox(0, "", $Email & " Is Online")
	Case 6
		MsgBox(0, "", $Email & " Is Offline")
	Case 10
		MsgBox(0, "", $Email & " Is Busy")
	Case 14
		MsgBox(0, "", $Email & " Will Be Right Back")
	Case 18
		MsgBox(0, "", $Email & " Is Idle")
	Case 34
		MsgBox(0, "", $Email & " Is Away")
	Case 50
		MsgBox(0, "", $Email & " Is On The Phone")
	Case 66
		MsgBox(0, "", $Email & " Is Eating Lunch")
	Case Else
		MsgBox(0, "", $Email & " Is Unknown")
EndSwitch
$oMessenger = ""