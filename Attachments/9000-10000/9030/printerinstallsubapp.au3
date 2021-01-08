;this tiny script simply clicks on the unsigned driver approvals if they pop up.
;The main script can't do this function as it is waiting for the the rundll RunWait() function to terminate

;this script never terminates.  It is terminated by the main script when it is no longer required

while 1
;click OK on unsigned driver if required
$UnsignedDriverAprove = WinWait("Hardware Installation", "has not passed Windows Logo testing") ; Waits forever
If $UnsignedDriverAprove = 1 Then
	Sleep(500)
	WinActivate("Hardware Installation", "has not passed Windows Logo testing")
	Sleep(500)
	ControlClick("Hardware Installation", "has not passed Windows Logo testing", 5303)
	Sleep(500)
EndIf

WEnd ; loopback

Exit