global $notify

If FileExists("Preferences01.ini") = 0 Then
	setup()
Else
	test()
EndIf

Func setup()
	#include <GUIConstants.au3>
	GUICreate("Connection Guardian v1.0 Setup",300,200)
	$checkfor = GUICtrlCreateInput("Ip address or website",5,5,150)
	$time = GUICtrlCreateCombo("Interval Time",5,30,150)
	GUICtrlSetData($time,"1 Minute|5 Minutes|10 Minutes|15 Minutes|30 Minutes|1 Hour|2 Hours")
	$set = GUICtrlCreateButton("Set And Start",215,165,80)
	$notify = GUICtrlCreateCombo("Type of notification",5,60,150)
	GUICtrlSetData($notify,"Balloon Tip|Msg Box|Tool Tip (by mouse pointer)|Tray Icon")
	GUISetState()
	
	While 1
		$msg = GUIGetMsg()
		If $msg = $gui_event_close Then
			Exit
		EndIf
		
		If $msg = $gui_event_minimize Then
			;winsetstate()
		EndIf
		
		If $msg = $set Then
			$address = GUICtrlRead($checkfor)
			$time = GUICtrlRead($time)
			$notify = GUICtrlRead($notify)
			
			If $address = "Ip address or website" Then
				MsgBox(0,"Error!","Please insert an IP address that is not your own or a website like www.google.com")
				GUIDelete()
				setup()
			ElseIf $time = "Interval Time" Then
				MsgBox(0,"Error!","Please Select an interval period")
				GUIDelete()
				setup()
			ElseIf $notify = "Type of notification" Then
				MsgBox(0,"Error!","Select a type of notification!")
				GUIDelete()
				setup()
			Else
				IniWrite("Preferences01.ini","Settings","Address",$address)
				IniWrite("Preferences01.ini","Settings","Interval",$time)
				IniWrite("Preferences01.ini","Settings","Notfiy",$notify)
				test()
			EndIf
		EndIf
	WEnd
EndFunc

Func test()
	$address = IniRead("Preferences01.ini","Settings","Address","www.google.com")
	$time = IniRead("Preferences01.ini","Settings","Interval","15 Minutes")
	$notify = IniRead("Preferences01.ini","Settings","Notify","Ballon Tip")
	If $time = "1 Minute" Then
		$time = 60000
	ElseIf $time = "5 Minutes" Then
		$time = 60000 * 5
	ElseIf $time = "10 Minutes" Then
		$time = 600000
	ElseIf $time = "15 Minutes" Then
		$time = 15000 * 60
	ElseIf $time = "30 Minutes" Then
		$time = 30000 * 60
	ElseIf $time = "1 Hour" Then
		$time = 3600000
	ElseIf $time = "2 Hours" Then
		$time = 120 * 60000
	EndIf
	
	While 1
		Ping($address)
		If @error > 0 Then
			If $notify = "Balloon Tip" Then
				TrayTip("Network Error Detected!","Your internet connection may have been lost. This may also be due to server issues. To check this, google and yahoo will both be tested.",30,3)
				test2()
			ElseIf $notify = "Msg Box" Then
				MsgBox(0,"Network Error Detected!","Your internet connection may have been lost. This may also be due to server issues. To check this, google will be tested. A confirmation box will appear showing the results.")
				test2()
			ElseIf $notify = "Tool Tip (by mouse pointer)" Then
				ToolTip("Network Error Detected! Checking Validity...you will see a confirmation box that will show the results.")
				test2()
			ElseIf $notify = "Tray Icon" Then
				;work on this
			EndIf
		EndIf
		Sleep($time)
	WEnd
EndFunc			
		
Func test2()
	Ping("www.google.com")
	If @error > 0 Then
		If $notify = "Balloon Tip" Then
			TrayTip("Validity Check Concluded...","Your network connection has been lost...",30,3)
			test()
		ElseIf $notify = "Msg Box" Then
			MsgBox(0,"Validity Check Concluded...","Your network connection has been lost...")
			test()
		ElseIf $notify = "Tool Tip (by mouse pointer)" Then
			ToolTip("Validity Check Concluded...","Your network connection has been lost...")
			test()
		ElseIf $notify = "Tray Icon" Then
			;work on this
		EndIf
	Else
		If $notify = "Balloon Tip" Then
			TrayTip("Validity Check Concluded...","Your network connection has NOT been lost. The error must have been due to server issues.",30,3)
			test()
		ElseIf $notify = "Msg Box" Then
			MsgBox(0,"Validity Check Concluded...","Your network connection has NOT been lost. The error must have been due to server issues.")
			test()
		ElseIf $notify = "Tool Tip (by mouse pointer)" Then
			ToolTip("Validity Check Concluded...","Your network connection has NOT been lost. The error must have been due to server issues.")
			test()
		ElseIf $notify = "Tray Icon" Then
			;work on this
		EndIf
	EndIf
EndFunc		