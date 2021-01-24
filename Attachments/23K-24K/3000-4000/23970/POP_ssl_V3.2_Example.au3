#include <Array.au3>
#include "POP_ssl_V3.2.au3"


Opt("OnExitFunc", "endscript")
Opt("SendKeyDelay", 0)
Opt("TrayIconDebug", 1)

;kill previous run
While ProcessExists("openssl.exe")
	ProcessClose("cmd.exe")
	ProcessClose("openssl.exe")
WEnd

;###FILL IN THIS INFO###
$User = InputBox("Gmail", "Enter Username", "")
$Pass = InputBox("Gmail", "Enter Password", "", "*")

;set server info
$SSL_Exe_loc = "C:\OpenSSL\bin\openssl.exe"
$POP_Server = "pop.gmail.com"
$POP_Port = "995"
$error = ""

$msg = _POP_Connect($POP_Server, $POP_Port, $SSL_Exe_loc, True)
;MsgBox(0, $msg & " - " & @error, $_POP_Log)
$error &= $msg & " - " & @error & @CRLF

If $msg == False Then EndReport($error)
$msg = _POP_Login($User, $Pass)
;MsgBox(0, $msg & " - " & @error, $_POP_Log)
$error &= $msg & " - " & @error & @CRLF

If $msg == False Then EndReport($error)
$msg = _POP_GetStats()
MsgBox(0, "", $msg)
$error &= $msg & " - " & @error & @CRLF

If $msg == False Then EndReport($error)
$msg = _POP_GetList()
_ArrayDisplay($msg)
$error &= $msg & " - " & @error & @CRLF

$msg = _POP_GetMessage(1)
_ArrayDisplay($msg)
$error &= $msg & " - " & @error & @CRLF

$msg = _POP_Disconnect()
$error &= $msg & " - " & @error & @CRLF


EndReport($error)
Func EndReport($error)
	MsgBox(0, "", $error)
	Exit
EndFunc   ;==>EndReport