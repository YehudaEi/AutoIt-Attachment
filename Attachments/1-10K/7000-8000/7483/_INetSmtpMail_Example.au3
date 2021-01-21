#include "_INetSmtpMail.Au3"
#include <Constants.au3>
#include "_Base64.Au3"
Opt("TrayIconDebug", 1)
;EXAMPLE CODE


;FILL THIS IN START
$s_FromName = "AutoItDemo"
$s_FromAddress = "test@test.com"
$s_ToAddress = "test@test.com"
$s_Subject = "My Test UDF"
Dim $as_Body[2]
$as_Body[0] = "Testing the new email udf"
$as_Body[1] = "Second Line"
;FILL THIS IN END


$b_trace = True ;false no trace window, true trace window displayed
$s_helo = @ComputerName ;sometimes WAN IP, localhost or 127.0.0.1
$s_first = "" ;@CRLF ;this is pointless with my UDF, since it will automaticly do it, if need be

$s_UserName = "" ;just declearing it, no need to fill in
$s_Password = "" ;just declearing it, no need to fill in
$temp = StringSplit($s_FromAddress, "@")

If MsgBox(4, "SMTP", "Would you like to send the email from a smtp server?" & @CRLF & "Click no to send from your computer directly to the mx server (may not work!)") = 6 Then
	$s_Server = InputBox("SMTP Server", "Enter SMTP Server Address", "smtp." & $temp[$temp[0]])
	$s_UserName = _Base64Encode (InputBox("Login", "Enter Login Name For SMTP Server" & @CRLF & "Leave blank if you dont need one", $temp[1]))
	If $s_UserName Then
		$s_Password = _Base64Encode (InputBox("Password", "Enter Your Password For The SMTP Server", "", "*"))
	EndIf
Else
	$s_Server = ""
	
	;domain lookup
	$IP = _INetGetSource ("http://dynupdate.no-ip.com/ip.php")
	If @error Or $IP = "" Then
		$IP = "127.0.0.1"
	EndIf
	$RunPID = Run(@ComSpec & " /c nslookup " & $IP, "", @SW_HIDE, $STDOUT_CHILD)
	$name = StringSplit(StdoutRead($RunPID), "Name:", 1)
	If $name[0] > 1 Then
		$name = StringSplit($name[2], "Address:", 1)
		$name = StringStripWS($name[1], 8)
	Else
		$name = "No Internet Connection"
	EndIf
	
	$domain = StringSplit($name, ".")
	If $domain[0] > 1 Then
		$domain = $domain[$domain[0] - 1] & "." & $domain[$domain[0]]
	Else
		$domain = $domain[$domain[0]]
	EndIf
	
	If $domain <> $temp[$temp[0]] Then
		If MsgBox(4, "MX Servers", "Some MX servers will not accept emails if they don't come from your domain" & @CRLF _
		& "Would you like to change this " & @CRLF & $s_FromAddress & " to this " & @CRLF & $temp[1] & "@" & $domain) = 6 Then
			$s_FromAddress = $temp[1] & "@" & $domain
		EndIf
	EndIf
EndIf

;call udf
If _INetSmtpMail ($s_FromName, $s_FromAddress, $s_ToAddress, $s_Server, $s_Subject, $as_Body, $s_helo, $s_UserName, $s_Password, $b_trace) <> 1 Then
	MsgBox(0, "Error!", "Mail failed with error code " & @error)
Else
	MsgBox(0, "Success!", "Mail sent")
EndIf


;===============================================================================
;
; Function Name:    _INetGetSource()
; Description:      Gets the source from an URL without writing a temp file.
; Parameter(s):     $s_URL = The URL of the site.
; Requirement(s):   DllCall/Struct & WinInet.dll
; Return Value(s):  On Success - Returns the source code.
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Wouter van Kesteren.
;
;===============================================================================
Func _INetGetSource($s_URL, $s_Header = '')
	
	If StringLeft($s_URL, 7) <> 'http://' And StringLeft($s_URL, 8) <> 'https://' Then $s_URL = 'http://' & $s_URL
	
	Local $h_DLL = DllOpen("wininet.dll")
	
	Local $ai_IRF, $s_Buf = ''
	
	Local $ai_IO = DllCall($h_DLL, 'int', 'InternetOpen', 'str', "AutoIt v3", 'int', 0, 'int', 0, 'int', 0, 'int', 0)
	If @error Or $ai_IO[0] = 0 Then
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf
	
	Local $ai_IOU = DllCall($h_DLL, 'int', 'InternetOpenUrl', 'int', $ai_IO[0], 'str', $s_URL, 'str', $s_Header, 'int', StringLen($s_Header), 'int', 0x80000000, 'int', 0)
	If @error Or $ai_IOU[0] = 0 Then
		DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf
	
	Local $v_Struct = DllStructCreate('udword')
	DllStructSetData($v_Struct, 1, 1)
	
	While DllStructGetData($v_Struct, 1) <> 0
		$ai_IRF = DllCall($h_DLL, 'int', 'InternetReadFile', 'int', $ai_IOU[0], 'str', '', 'int', 256, 'ptr', DllStructGetPtr($v_Struct))        
		$s_Buf &= StringLeft($ai_IRF[2], DllStructGetData($v_Struct, 1))
	WEnd
	
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IOU[0])
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
	DllClose($h_DLL)
	Return $s_Buf
EndFunc   ;==>_INetGetSource