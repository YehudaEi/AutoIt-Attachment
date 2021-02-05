; Author: Giulio Muscarello - Giulio M - Arcadiagiulio
; Time control
; Find string "???" and change into prohibited time interval. E.g. Case ??? To ??? ---> Case 10 to 18
; After, search string "redclarinet" and change password.
; If someone tries to enter the forbidden time zones, hear a beep, the message will read "Access Prohibited (...)" and shut down the system.
; And, the access wil be registered into the file "connectiontime.log" in the directory where this script is installed.

#NoTrayIcon ;Nobody will see that script is active
Dim Const $psswd = "redclarinet"
$declaredpsswd = InputBox("Password", "Insert your password: if you want to access as Limited-time user insert 'child'.")
Select
Case $declaredpsswd = $psswd
	$usertype = "ADULT"
Case $declaredpsswd = "child"
	$usertype = "CHILD"
Case Else
	$usertype = "HACKR"
Select
	Case $usertype = "CHILD"
		Switch @HOUR
			Case ??? To ??? ; Prohibited hours; 24 hours format
				Beep()
				SplashTextOn ("Prohibited access", "Prohibited access. It's " & @HOUR & ": you cannot access now. System will shut down.")
				Sleep(2000)
				SplashOff
				Shutdown(1)
			Case ??? To ??? ; 1st time zone
				;Choose the content
			Case ??? To ??? ; 2nd time zone
				;Choose the content
			Case ??? To ??? ; 3rd time zone
				;Choose the content...
			EndSwitch
eNDsELECT
EndSelect
		EndSwitch
	Case $usertype = "ADULT"
		SplashTextOn("Adult Access", "Access as Adult.")
		Sleep(2000)
		SplashOff
	Case $usertype = "HACKR"
		SplashTextOn( "Wrong password", "Wrong password. This can be an attempt to hack time limitation script: for safety, the system will reboot.")
		Sleep(2000)
		SplashOff
		Shutdown(6, "Hacking attempt")
	#include <File.au3>
	; In the ??? field, insert the text file where to register Date and Hour of connection
	_FileWriteLog(@ScriptDir & "Connectiontime.log","A Child/Guest user starts Windows at " & @HOUR & ":" & @MIN & ".", 0)
EndSelect