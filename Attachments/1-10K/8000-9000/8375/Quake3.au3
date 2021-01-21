#include-once


;===============================================================================
;
; Function Name:	_Q3ServerQuery()
; Description:      Sends a query to the server.
; Parameter(s):     $sSrvIP		- server to connect to.
;					$sQuery		- query to send.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : Returns the respond from the server (if any).
;					On Failure : @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;
; Note(s):			This function is fundamental and is used by all of the
;					communication UDFs in this collection in some way.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3ServerQuery($sSrvIP, $sQuery, $iSrvPort = 27960)
	
	Local $sRespond, $sRecv, $aSocket = UDPOpen ($sSrvIP, $iSrvPort)
	
	If @error Then
		UDPCloseSocket ($aSocket)
		SetError(1)
		Return
	EndIf
	
	If UDPSend ($aSocket, "ÿÿÿÿ" & $sQuery) = 0 Then
		UDPCloseSocket ($aSocket)
		SetError(2)
		Return
	EndIf
	
	Do
		$sRecv = UDPRecv ($aSocket, 65507)
		$sRespond &= $sRecv
	Until $sRecv = ""
	
	UDPCloseSocket ($aSocket)
	Return $sRespond
EndFunc   ;==>_Q3ServerQuery


;===============================================================================
;
; Function Name:	_Q3ServerInfo()
; Description:      Connects and returns basic information from a server.
; Parameter(s):     $sSrvIP		- server to connect to.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : A two dimensional array :
;					$array[0][0] - number of keys and values.
;					$array[x][0] - key-name
;					$array[x][1] - key-value
;
;					On Failure : $array[0][0] equals 0 and @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - No response from server.
;						4 - Invalid data received from server.
;
; Note(s):			This function returns basic information about the server,
;					such as "mapname", "hostname", "protocol" and more.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3ServerInfo($sSrvIP, $iSrvPort = 27960)
	
	Local $sRespond, $aReturn[1][1], $aInfo, $iCount = 0
	
	$sRespond = _Q3ServerQuery($sSrvIP, "getinfo", $iSrvPort)
	If @error Then
		SetError(@error)
		Return $aReturn
	EndIf
	
	If $sRespond = "" Then
		SetError(3)
		Return $aReturn
	EndIf
	
	If Not StringLeft($sRespond, 16) = "ÿÿÿÿinfoResponse" Or Not StringInStr($sRespond, "\") Then
		SetError(4)
		Return $aReturn
	EndIf
	
	$aInfo = StringSplit(StringTrimLeft($sRespond, StringInStr($sRespond, @LF) + 1), "\")
	If Mod($aInfo[0], 2) Then
		SetError(4)
		Return $aReturn
	EndIf
	
	$aReturn[0][0] = ($aInfo[0] / 2)
	ReDim $aReturn[$aReturn[0][0] + 1][2]
	For $i = 1 To $aReturn[0][0]
		$iCount += 2
		$aReturn[$i][0] = $aInfo[$iCount - 1]
		$aReturn[$i][1] = $aInfo[$iCount]
	Next
	
	Return $aReturn
EndFunc   ;==>_Q3ServerInfo


;===============================================================================
;
; Function Name:	_Q3ServerStatus()
; Description:       Connects and returns a statusreport from a server.
; Parameter(s):     $sSrvIP		- server to connect to.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : A two dimensional array :
;					$array[0][0] - number of keys and values.
;					$array[x][0] - key-name
;					$array[x][1] - key-value
;
;					On Failure : $array[0][0] equals 0 and @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - No response from server.
;						4 - Invalid data received from server.
;
; Note(s):			This function returns a much more detailed report about
;					the server, the current game and it's rules and settings.
;					Examples are : "dmflags", "timelimit", "g_needpass".
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3ServerStatus($sSrvIP, $iSrvPort = 27960)
	
	Local $sRespond, $aReturn[1][1] = [[0]], $aStatus, $iCount = 0
	
	$sRespond = _Q3ServerQuery($sSrvIP, "getstatus", $iSrvPort)
	If @error Then
		SetError(@error)
		Return $aReturn
	EndIf
	
	If $sRespond = "" Then
		SetError(3)
		Return $aReturn
	EndIf
	
	If Not StringLeft($sRespond, 18) = "ÿÿÿÿstatusResponse" Or Not StringInStr($sRespond, "\") Then
		SetError(4)
		Return $aReturn
	EndIf
	
	$sRespond = StringLeft($sRespond, StringInStr($sRespond, @LF, 0, 2) - 1)
	$aStatus = StringSplit(StringTrimLeft($sRespond, StringInStr($sRespond, @LF) + 1), "\")
	If Mod($aStatus[0], 2) Then
		SetError(4)
		Return $aReturn
	EndIf
	
	$aReturn[0][0] = $aStatus[0] / 2
	ReDim $aReturn[$aReturn[0][0] + 1][2]
	For $i = 1 To $aReturn[0][0]
		$iCount += 2
		$aReturn[$i][0] = $aStatus[$iCount - 1]
		$aReturn[$i][1] = $aStatus[$iCount]
	Next
	
	Return $aReturn
EndFunc   ;==>_Q3ServerStatus


;===============================================================================
;
; Function Name:	_Q3ServerClients()
; Description:      Connects and returns the client-list from a server.
; Parameter(s):     $sSrvIP		- server to connect to.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : A two dimensional array :
;						$array[0][0] - number of connected clients.
;						$array[x][0] - client-name.
;						$array[x][1] - client-score.
;						$array[x][2] - client-ping.
;
;					On Failure : $array[0][0] equals 0 and @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - No clients connected.
;						4 - Invalid data received from server.
;
; Note(s):			This function actually uses the same query-string as
;					Status, where the only difference is how the
;					functions process the data returned from the server.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3ServerClients($sSrvIP, $iSrvPort = 27960)
	
	Local $sRespond, $aReturn[1][1] = [[0]], $sPlayers, $aPlayers, $iCount = 0
	
	$sRespond = _Q3ServerQuery($sSrvIP, "getstatus", $iSrvPort)
	If @error Then
		SetError(@error)
		Return $aReturn
	EndIf
	
	If $sRespond = "" Then
		SetError(4)
		Return $aReturn
	EndIf
	
	If Not StringLeft($sRespond, 18) = "ÿÿÿÿstatusResponse" Or Not StringInStr($sRespond, "\") Then
		SetError(4)
		Return $aReturn
	EndIf
	
	$sPlayers = StringTrimLeft($sRespond, StringInStr($sRespond, @LF, 0, 2))
	If Not StringInStr($sPlayers, @LF) Then
		SetError(3)
		Return $aReturn
	EndIf
	
	$aPlayers = StringSplit($sPlayers, @LF)
	$aPlayers[0] -= 1
	ReDim $aReturn[$aPlayers[0] + 1][3]
	
	$iCount = 0
	$aReturn[0][0] = $aPlayers[0]
	For $i = 1 To $aPlayers[0]
		$iCount += 1
		$aReturn[$i][0] = StringTrimRight(StringTrimLeft($aPlayers[$iCount], StringInStr($aPlayers[$iCount], '"')), 1)
		$aReturn[$i][1] = StringLeft($aPlayers[$iCount], StringInStr($aPlayers[$iCount], " ", 0) - 1)
		$aReturn[$i][2] = StringMid($aPlayers[$iCount], StringInStr($aPlayers[$iCount], " ") + 1, _
				StringInStr($aPlayers[$iCount], " ", 0, 2) - (StringInStr($aPlayers[$iCount], " ") + 1))
	Next
	
	Return $aReturn
EndFunc   ;==>_Q3ServerClients


;===============================================================================
;
; Function Name:	_Q3AdminRcon()
; Description:      Sends a remote command to a server, used for controlling the server.
; Parameter(s):     $sSrvIP		- server to connect to.
;					$sPass		- rcon-password.
;					$sCommand	- command to send.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : Returns the respond from the server (if any).
;
;					On Failure : Sets @error :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - Invalid password.
;
; Note(s):			It isn't necessarily a bad thing that this function doesn't
;					return anything, as the server doesn't always repond your
;					queries, which is why @error isn't set in those cases.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3AdminRcon($sSrvIP, $sPass, $sCommand, $iSrvPort = 27960)
	
	Local $sRespond = _Q3ServerQuery($sSrvIP, 'rcon "' & $sPass & '" ' & $sCommand, $iSrvPort)
	If @error Then
		SetError(@error)
		Return ""
	EndIf
	
	If $sRespond = "ÿÿÿÿprint" & @LF & "Bad rconpassword." & @LF Then
		SetError(3)
		Return
	EndIf
	
	Return $sRespond
EndFunc   ;==>_Q3AdminRcon


;===============================================================================
;
; Function Name:	_Q3AdminClients()
; Description:      Connects and returns the client-list from a server.
; Parameter(s):     $sSrvIP		- server to connect to.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : A two dimensional array :
;						$array[0][0] - number of connected clients.
;						$array[x][0] - client number.
;						$array[x][1] - client score
;						$array[x][2] - client ping.
;						$array[x][3] - client name.
;						$array[x][4] - client lastmsg*.
;						$array[x][5] - client address.
;						$array[x][6] - client qport*.
;						$array[x][7] - client rate*.
;
;					On Failure : $array[0][0] equals 0 and @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - Invalid password.
;						4 - Invalid data received from server.
;						5 - No clients connected.
;
; Note(s):			This function returns more information than _Q3ServerClients(), where
;					the most useful differences is probably the client number and address.
;					These can be used for kicking and banning a client, combined with the
;					help from the functions _Q3AdminKick and _Q3AdminBan.
;
;					"lastmsg" is the time (in milliseconds) since the server last heard from
;					the client (probably :p). "qport" is the port the client is connected thru
;					and "rate" is the highest amount of bytes the client can receive every second.
;
; Author(s):        Helge, LazyCat
;
;===============================================================================
Func _Q3AdminClients($sSrvIP, $sPass, $iSrvPort = 27960)
	
	Local $sRespond, $aRespond, $aReturn[1][1] = [[0]], $sPlayers, $aPlayers, $aInfo
	
	$sRespond = _Q3AdminRcon($sSrvIP, $sPass, "status", $iSrvPort)
	If @error Then
		SetError(@error)
		Return $aReturn
	EndIf
	
	$aRespond = StringSplit($sRespond, @LF)
	If Not StringLeft($sRespond, 15) = "ÿÿÿÿprint" & @LF & "map: " Or $aRespond[0] < 4 Then
		SetError(4)
		Return $aReturn
	EndIf
	
	If $aRespond[3] <> "num score ping name            lastmsg address               qport rate" Or _
			$aRespond[4] <> "--- ----- ---- --------------- ------- --------------------- ----- -----" Then
		SetError(4)
		Return $aReturn
	EndIf
	
	If UBound($aRespond) < 5 Then
		SetError(5)
		Return $aReturn
	EndIf
	
	For $i = 5 To $aRespond[0] - 2
		$aInfo = StringRegExp($aRespond[$i], _
				"\s+?(\d+?)\s+?(\d+?)\s+?(\d+?)\s+?(.+?)\s+?(\d+?)\s?(bot|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{2,5})\s+?(\d+?)\s+?(\d+)", 3)
		If UBound($aInfo) = 8 Then
			$aReturn[0][0] += 1
			ReDim $aReturn[UBound($aReturn) + 1][8]
			
			For $i2 = 0 To 7
				$aReturn[$i - 4][$i2] = $aInfo[$i2]
			Next
		Else
			SetError(4)
		EndIf
	Next
	
	Return $aReturn
EndFunc   ;==>_Q3AdminClients


;===============================================================================
;
; Function Name:	_Q3AdminKick()
; Description:      Kicks a client off the server.
; Parameter(s):     $sSrvIP		- server to connect to.
;					$sPass		- rcon-password.
;					$vClient	- the ID or name of the client to kick (see Notes).
;					$fIsName	- Optional : if True then $vClient is a name. Default is False (meaning ID).
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : Returns 1 and @error is 0.
;
;					On Failure : Returns 0 and @error is :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - Invalid password.
;						4 - Invalid data received from server.
;						5 - $vClient was invalid.
;
; Note(s):			The third parameter, $vClient, can be either a client's name or number,
;					where the default setting is number. This can be changed by changing the
;					fourth parameter's value from False to True.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3AdminKick($sSrvIP, $sPass, $vClient, $fIsName = False, $iSrvPort = 27960)
	
	Local $sRespond, $aRespond, $sKickCMD = "clientkick "
	
	If $fIsName = True Then $sKickCMD = "kick "
	$sRespond = _Q3AdminRcon($sSrvIP, $sPass, $sKickCMD & $vClient, $iSrvPort)
	If @error Then
		SetError(@error)
		Return 0
	EndIf
	
	$aRespond = StringSplit($sRespond, @LF)
	If @error Then
		SetError(4)
		Return 0
	EndIf
	
	If $aRespond[0] >= 3 And StringLeft($aRespond[3], 17) = "ClientDisconnect:" Then Return 1
	If $aRespond[0] >= 2 Then
		If $aRespond[2] = "Bad client slot: " & $vClient Or $aRespond[2] = "Bad slot number: " & $vClient Or _
				$aRespond[2] = "Player " & $vClient & " is not on the server" Or $aRespond[2] = "Client " & $vClient & " is not active" Then
			SetError(5)
			Return 0
		EndIf
	EndIf
	
	SetError(4)
	Return 0
EndFunc   ;==>_Q3AdminKick


;===============================================================================
;
; Function Name:	_Q3AdminBanList()
; Description:      Returns a list of banned IPs from the server.
; Parameter(s):     $sSrvIP		- server to connect to.
;					$sPass		- rcon-password.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : Returns an array containing the banned IPs.
;
;					On Failure : $array[0] equals 0 and sets @error :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - Invalid password.
;						4 - Invalid data received from server.
;
; Note(s):			This function returns every banned IP from the server.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3AdminBanList($sSrvIP, $sPass, $iSrvPort = 27960)
	
	Local $aReturn[1] = [0], $sRespond
	
	$sRespond = _Q3AdminRcon($sSrvIP, $sPass, "g_banips", $iSrvPort)
	If @error Then
		SetError(@error)
		Return $aReturn
	EndIf
	
	If Not StringLeft($sRespond, 25) = "ÿÿÿÿprint" & @LF & '"g_banIPs" is:"' Then
		SetError(4)
		Return $aReturn
	EndIf
	
	$sRespond = StringTrimLeft($sRespond, 25)
	$sRespond = StringLeft($sRespond, StringInStr($sRespond, '"') - 1)
	If $sRespond <> "" Then
		If StringRight($sRespond, 3) = " ^7" Then $sRespond = StringTrimRight($sRespond, 3)
		If StringLen($sRespond) > 3 Then $aReturn = StringSplit($sRespond, " ")
	EndIf
	
	Return $aReturn
EndFunc   ;==>_Q3AdminBanList


;===============================================================================
;
; Function Name:	_Q3AdminBan()
; Description:      Adds a IP (or IP-mask) to the ban-filter.
; Parameter(s):     $sSrvIP		- server to connect to.
;					$sPass		- rcon-password.
;					$sIP		- the IP (or IP-mask) to ban.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : @error is 0.
;
;					On Failure : @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - Invalid password.
;						4 - Invalid data received from server.
;						5 - $sIP was invalid.
;
; Note(s):			For this function to work "g_filterban" must be set to 1, which is also
;					the default setting for Quake 3. However if that's not the case, then it
;					can be changed remotelly by using _Q3AdminRcon. Since Quake 3 version 1.32
;					you have to	use * for IP pattern matching, while previous versions used 0.
;					Example : 192.246.12.*
;					
;					The client isn't automatically removed from the server when banning him,
;					so that has to be done with _Q3AdminKick together with the client's number.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3AdminBan($sSrvIP, $sPass, $sIP, $iSrvPort = 27960)
	
	If StringInStr($sIP, ":") Then $sIP = StringLeft($sIP, StringInStr($sIP, ":") - 1)
	
	Local $sRespond = _Q3AdminRcon($sSrvIP, $sPass, "addip " & $sIP, $iSrvPort)
	If @error Then
		SetError(@error)
		Return 0
	EndIf
	
	If StringLeft($sRespond, 30) = "ÿÿÿÿprint" & @LF & "Bad filter address: " Then
		SetError(5)
		Return 0
	EndIf
	
	If $sRespond = "ÿÿÿÿprint" & @LF Then Return 1
	
	SetError(4)
	Return 0
EndFunc   ;==>_Q3AdminBan


;===============================================================================
;
; Function Name:	_Q3AdminUnBan()
; Description:      Removes a IP (or IP-mask) from the ban-filter.
; Parameter(s):     $sSrvIP		- server to connect to.
;					$sPass		- rcon-password.
;					$sIP		- the IP (or IP-mask) to remove.
;                   $iSrvPort	- Optional : server-port. Default is 27960.
;
; Return Value(s):  On Success : @error equals 0.
;
;					On Failure : @error is set :
;						1 - Failed to connect to server.
;						2 - Failed to send request.
;						3 - Invalid password.
;						4 - Invalid data received from server.
;						5 - Bad IP.
;
; Note(s):			Since Quake 3 version 1.32 you have to use '*' for IP pattern
;					matching, while previous versions used '0'.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3AdminUnban($sSrvIP, $sPass, $sIP, $iSrvPort = 27960)
	
	If StringInStr($sIP, ":") Then $sIP = StringLeft($sIP, StringInStr($sIP, ":") - 1)
	
	Local $sRespond = _Q3AdminRcon($sSrvIP, $sPass, "removeip " & $sIP, $iSrvPort)
	If @error Then
		SetError(@error)
		Return 0
	EndIf
	
	If StringLeft($sRespond, 30) = "ÿÿÿÿprint" & @LF & "Bad filter address: " Or StringLeft($sRespond, 22) = "ÿÿÿÿprint" & @LF & "Didn't find " Then
		SetError(5)
		Return 0
	EndIf
	
	If $sRespond = "ÿÿÿÿprint" & @LF & "Removed." & @LF Then Return 1
	
	SetError(4)
	Return 0
EndFunc   ;==>_Q3AdminUnban


;===============================================================================
;
; Function Name:	_Q3SearchKey()
; Description:      Searches thru an array for the specified key and returns it's value.
; Parameter(s):     $sKey		- key to search for.
;                   $aArray		- array to search thru.
;					$iStrip		- if 1 or 2 then key-names will be stripped for colors (see Notes). Default is 0.
;					$iElement	- Optional : the element in the second dimension to return. Default is 1.
;
; Return Value(s):  On Success : Returns the value for $sKey.
;
;					On Failure : Returns "" and sets @error :
;						1 - $aArray was invalid.
;						2 - $iElement was invalid.
;						3 - Failed to find $sKey.
;
; Note(s):			This function searches thru entire arrays in the second
;					dimension, in the first element, and if $sKey matches one
;					of these values, the value in the second element is returned.
;					The element to return can be changed by setting $iElement.
;
;					The default for $iStrip is 0, which means that the array's
;					key-names will not stripped for colors when mathing it with $sKey.
;					If you set it to 1 or 2 it would make it easier to search for,
;					and find, a player which uses color-codes in his name. 1 means that
;					$fOSPHex in StripColors is set to False and with 2 it's set to True.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3SearchKey($sKey, $aArray, $iStrip = 0, $iElement = 1)
	
	Local $fOSPHex = False
	If $iStrip = 2 Then $fOSPHex = True
	
	If UBound($aArray) < 1 Or UBound($aArray, 0) <> 2 Then
		SetError(1)
		Return ""
	EndIf
	
	If UBound($aArray, 2) < $iElement Then
		SetError(2)
		Return ""
	EndIf
	
	For $i = 1 To $aArray[0][0]
		If $iStrip > 0 Then
			If _Q3StripColors($aArray[$i][0], $fOSPHex) = $sKey Then Return $aArray[$i][$iElement]
		Else
			If $aArray[$i][0] = $sKey Then Return $aArray[$i][$iElement]
		EndIf
	Next
	
	SetError(2)
	Return ""
EndFunc   ;==>_Q3SearchKey


;===============================================================================
;
; Function Name:	_Q3StripColors()
; Description:      Strips Quake3-colorcodes from a string.
; Parameter(s):     $sString	- string to strip colors from.
;                   $fOSPHex	- Optional : Toggle removal of OSP hex-codes (see Notes). Default is True.
;
; Return Value(s):  Returns the new string without color-codes.
;
; Note(s):			The OSP-mod features a more advanced coloring, where you can specify
;					hex-colors. If the second parameter is True then these can also be removed.
;					These kind of codes consists of a caret and a "x", followed by a hex-code
;					(6 characters). Example : "^xC400C4" would become some kind of pink.
;
;					It's recommended to keep the default value for $fOSPHex, unless you
;					know for a fact that the string isn't from any OSP-server or anything
;					concerning OSP. This is because "^x" isn't a valid colorcode for Quake3.
;
; Author(s):        Helge
;
;===============================================================================
Func _Q3StripColors($sString, $fOSPHex = True)
	
	$sString = StringRegExpReplace($sString, "\^[^xX\^]", "")
	
	If $fOSPHex Then
		$sString = StringRegExpReplace($sString, "(?i)\^x.{6}", "")
	Else
		$sString = StringReplace($sString, "^x", "", 0, 0)
	EndIf
	
	Return StringReplace($sString, "^^", "^")
EndFunc   ;==>_Q3StripColors

