#include <Array.au3>
#include "_Base64.au3"
#include "SMTP-ssl_V3.0.au3"
$default = "Username"


Opt("OnExitFunc", "endscript")
Opt("SendKeyDelay", 0)
Opt("TrayIconDebug", 1)

;kill previous run
While ProcessExists("openssl.exe")
	ProcessClose("cmd.exe")
	ProcessClose("openssl.exe")
WEnd

;###FILL IN THIS INFO###
;set user/pass
$user = _Base64Encode(InputBox("Username", "Username", $default))
$pass = _Base64Encode(InputBox("Password", "Password", "", "*"))

;set message info
$s_ToAddress = InputBox("To", "To Address", $default & "@gmail.com")
$s_FromName = InputBox("From Name", "From Name", $default)
$s_FromAddress = InputBox("From", "From Address", $default & "@gmail.com")
$s_Subject = "UDF Test"
Dim $as_Body[2]
$as_Body[0] = "Testing the new email udf"
$as_Body[1] = "Second Line"

;build body of email
$BodyString = ""
For $i = 0 To UBound($as_Body) - 1 Step +1
	$BodyString = $BodyString & $as_Body[$i] & @CRLF
Next

;set server info
$SSL_Exe_loc = "C:\OpenSSL\bin\openssl.exe"
$SMTP_Server = "smtp.gmail.com"
$SMTP_Port = "465"
$error = ""

$msg = _SMTP_Connect($SMTP_Server, $SMTP_Port, $SSL_Exe_loc, True)
;MsgBox(0, $msg & " - " & @error, $_SMTP_Log)
$error &= $msg & " - " & @error & @CRLF

$msg = _SMTP_Login($user, $pass)
;MsgBox(0, $msg & " - " & @error, $_SMTP_Log)
$error &= $msg & " - " & @error & @CRLF

$msg = _SMTP_SendEmail($s_ToAddress, $s_FromAddress, $s_FromName, $s_Subject, $BodyString)
;MsgBox(0, $msg & " - " & @error, $_SMTP_Log)
$error &= $msg & " - " & @error & @CRLF

$msg = _SMTP_Disconnect()
;MsgBox(0, $msg & " - " & @error, $_SMTP_Log)
$error &= $msg & " - " & @error & @CRLF
MsgBox(0, "", $error)