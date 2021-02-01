#include "MailSlot.au3"
writebat()
run("C:\MStest.bat")
Sleep(2000)


Global $sMailSlotName = "\\.\MailSlot\waitfor.exe\SIGNAL"
_SendMail($sMailSlotName,"1")
Sleep(2000)
_SendMail($sMailSlotName,"2")
Sleep(4000)
_SendMail($sMailSlotName,"3")

Exit



Func _SendMail($sMailSlotName,$sDataToSend)
	_MailSlotWrite($sMailSlotName, $sDataToSend, 1)
	Switch @error
		Case 1
			MsgBox(48, "MailSlot error", "Account that you try to send to likely doesn't exist!")
		Case 2
			MsgBox(48, "MailSlot error", "Message is blocked!")
		Case 3
			MsgBox(48, "MailSlot error", "Message is send but there is an open handle left." & @CRLF & "That could lead to possible errors in future")
		Case 4
			MsgBox(48, "MailSlot error", "All is fucked up!" & @CRLF & "Try debugging MailSlot.au3 functions. Thanks.")
		Case Else
			;MsgBox(64, "MailSlot", "Sucessfully sent!")
	EndSwitch
EndFunc   ;==>_SendMail



Func writebat()
	$b=""
	$b &= "@echo off "          & @CRLF
	$b &= "echo Etape_1"        & @CRLF
	$b &= "waitfor /T 60 SIGNAL"& @CRLF
	$b &= "echo Etape_2"        & @CRLF
	$b &= "waitfor /T 60 SIGNAL"& @CRLF
	$b &= "echo Etape_3"        & @CRLF
	$b &= "waitfor /T 60 SIGNAL"& @CRLF
	$b &= "echo Etape_4"        & @CRLF
	$b &= "pause Ended"         & @CRLF

	$f=FileOpen("C:\MStest.bat",2)
	FileWrite($f,$b)
	FileClose($f)
EndFunc
