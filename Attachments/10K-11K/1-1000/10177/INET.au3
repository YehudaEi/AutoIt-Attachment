
$Header = "Content-Type: application/x-www-form-urlencoded"
$Host = "brihar7.freehostia.com"
$File = "/register.php"
$URL = "http://" & $Host & $File
$PostData = "UserID=Username&Password=Password"


Func QuickOutput($Filename, $Output, $Mode)
	Local $File = FileOpen($Filename, $Mode)
	FileWriteLine($File, $Output)
	FileClose($File)
EndFunc


;~ ;http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wininet/wininet/http_sessions.asp
$Internet = _InternetOpen("AutoIT3")
$InternetConnection = _InternetConnect($Internet, $Host)
$Request = _HttpOpenRequest($InternetConnection, "POST", $File)
_HttpSendRequest($Request, $Header, StringLen($Header), $PostData, StringLen($PostData))
$Response = _InternetRead($Request)
QuickOutput("Response.html", $Response, 2)
_InternetCloseHandle($Internet)




Func _InternetOpen($s_Agent, $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags = 0)

	Local $ai_InternetOpen = DllCall('wininet.dll', 'long', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, 'str', $s_ProxyName, 'str', $s_ProxyBypass, 'long', $l_Flags)
	If @error Or $ai_InternetOpen[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_InternetOpen[0]

EndFunc

Func _InternetConnect($l_InternetSession, $s_ServerName)

	Local $ai_InternetConnect = DllCall('wininet.dll', 'long', 'InternetConnect', 'long', $l_InternetSession, 'str', $s_ServerName, 'int', 80, 'int', 0, 'int', 0, 'long', 3, 'long', 0, 'long', 0)
	If @error Or $ai_InternetConnect[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_InternetConnect[0]

EndFunc

Func _HttpOpenRequest($l_InternetConnection, $s_Verb, $s_File)
	Local $ai_HttpOpenRequest = DllCall('wininet.dll', 'long', 'HttpOpenRequest', 'long', $l_InternetConnection, 'str', $s_Verb, 'str', $s_File, 'int', 0, 'int', 0, 'int', 0, 'int', 0, 'int', 0)
	If @error Or $ai_HttpOpenRequest[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_HttpOpenRequest[0]

EndFunc

Func _HttpSendRequest($l_Request, $s_Headers, $l_HeadersLength, $s_Data, $l_DataLength)
	Local $ai_HttpSendRequest = DllCall('wininet.dll', 'long', 'HttpSendRequest', 'long', $l_Request, 'str', $s_Headers, 'long', $l_HeadersLength, 'str', $s_Data, 'long', $l_DataLength)
	If @error Or $ai_HttpSendRequest[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_HttpSendRequest[0]

EndFunc

Func _InternetRead($l_Request)
	Local $ai_IRF, $s_Buf = ''
	Local $v_Struct = DllStructCreate('udword')
	DllStructSetData($v_Struct, 1, 1)
	
	While DllStructGetData($v_Struct, 1) <> 0
		$ai_IRF = DllCall('wininet.dll', 'int', 'InternetReadFile', 'long', $l_Request, 'str', '', 'int', 256, 'ptr', DllStructGetPtr($v_Struct))        
		$s_Buf &= StringLeft($ai_IRF[2], DllStructGetData($v_Struct, 1))
	WEnd
	Return $s_Buf
EndFunc
Func _InternetCloseHandle($l_InternetSession)

	Local $ai_InternetCloseHandle = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'long', $l_InternetSession)
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_InternetCloseHandle[0]

EndFunc











