; Open HP 1320n PRINT SERVER AND CONFIGURE
; Written by Dana L. Houseman

;InputBox features: Title=Yes, Prompt=Yes, Default Text=No, Mandatory
$InputBoxAnswer = InputBox("Password (y/n)!","Do you Need to use a password?","","*M","-1","-1","-1","-1")
If $InputBoxAnswer = "Y" Then
$passwd1 = InputBox("Open Password", "Enter password to Open the Jet Direct with.", "", "*", _ 
500, 150, 220, 220)
	$user= "admin"
	Else
	EndIf

$answer1 = InputBox("1320N CURRENT IP", "What is the Current IP Address of the Jet Direct?", "10.", "", _
    500, 150, 200, 200) ; "10." is the default answer for quick editing in our environment. 

$answer2 = InputBox("1320n IP SETUP", "What is the NEW IP Address?", "10.", "", _
500, 150, 210, 210) 

$answer3 = InputBox("1320n IP SETUP GATEWAY", "What is the NEW GATEWAY?", "10.", "", _
500, 150, 220, 220) 

$answer4 = InputBox("1320n IP SETUP Host Name", "What is the Common Name you would like for this DEVICE?", "MS-112", "", _
500, 150, 240, 240)

$passwd2 = InputBox("Security Check", "Enter password to set. Note once executed the password will be displayed as it's passed to the Jetdirect", "", "*", _ 
500, 150, 250, 250) 

;InputBox2 Provides an opportunity to abort!
$InputBoxAnswer2 = InputBox("CONTINUE???? (y/n)!","Continue programing 1320n Printer?????","","","-1","-1","-1","-1")
If $InputBoxAnswer2 = "Y" Then
MsgBox(4096, "CONFIRMED", "One moment please!", 3)
	Else
		MsgBox(4096, "ABORT", "You did not choose Y to continue. Now ending the program. This message will self distruct.", 5)
		Exit
	EndIf

RUN ("cmd.exe")
Sleep(1000)
SEND ('telnet{ENTER}')

Sleep(1000)
Send("Open " & $answer1 & "{ENTER}")
sleep(2800)

If $InputBoxAnswer = "Y" Then
	Send(""& $user)
Sleep(1000)
Send("{ENTER}")
	Send(""& $passwd1)
Sleep(1000)
Send("{ENTER}")
	Else
	EndIf
	
Sleep(500)
Send("ip-config:manual")
Sleep(500)
Send("{ENTER}")

Sleep(500)
Send("IP:"& $answer2)
Sleep(500)
Send("{ENTER}")

Sleep(500)
Send("Subnet-Mask:255.255.0.0")
Sleep(500)
Send("{ENTER}")

Sleep(500)
Send("default-gw:" & $answer3)
Sleep(500)
Send("{ENTER}")

Sleep(500)
Send("host-name:" & $answer4)
Sleep(500)
Send("{ENTER}")

Sleep(500)
Send("passwd")
Send("{ENTER}")
Sleep(250)
Send("passwd:" & $passwd2 &" " & $passwd2) 
Sleep(50)
Send("{ENTER}")
Sleep(1000)
Send("quit")
Send("{ENTER}")
Sleep(500)
Send("{ENTER}")
Sleep(500)
Send("{ENTER}")
Sleep(1500)
Send("quit")
Send("{ENTER}")
Sleep(1500)
Send("quit")
Send("{ENTER}")
Sleep(1500)
Send("exit") 
Send("{ENTER}")
Exit



