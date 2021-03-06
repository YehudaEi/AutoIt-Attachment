;This is a whole bunch of function calls for the tsremote.dll.
;Most of it is adapted from a document by Niels Werensteijn
;  I found it at                                                              
;The rest is adapted from a visual basic wrapper by Ren� Sch�dlich
;Anything that I invented myself is purely accidental :)
;
;There are examples of using each of the functions below.
;
;Every function should return a string.
;
;Each _tsrDisplay... function is a conversion of an array to near English.  The output
;  should be pretty self-explanitory
;
;Every other function will return "OK" on success.
;  "CALL FAILED" if there was an error setting up the DllCall or executing it.
;  "ERROR ...whatever..." if the DllCall executed but generated an error.  These are actual
;    error messages generated by the TSRemote.dll
;
;There are three main structures:
;  The Channel Array - 6 elements
;    Channel[0] = Number (Channel ID)
;    Channel[1] = Number (Parent Channel ID)
;    Channel[2] = Number (Count of Players in Channel)
;    Channel[3] = Binary (Channel Flags)
;      Bit[0] = Registered
;      Bit[1] = Unregistered
;      Bit[2] = Moderated
;      Bit[3] = Password Required
;      Bit[4] = Hierarchical
;      Bit[5] = Default
;    Channel[4] = Binary (Codec)
;    Channel[5] = String (Channel Name)
;
;  The Player Array - 6 elements
;    Player[0] = Number (Player ID)
;    Player[1] = Number (Channel ID)
;    Player[2] = String (Nick Name)
;    Player[3] = Binary (Channel Privileges)
;      Bit[0] = Admin
;      Bit[1] = Operator
;      Bit[2] = Auto-Operator
;      Bit[3] = Voiced
;      Bit[4] = Auto-Voiced
;    Player[4] = Binary (Server Privileges)
;      Bit[0] = Super Server Admin
;      Bit[1] = Server Admin
;      Bit[2] = Can Register
;      Bit[3] = Registered
;      Bit[4] = Unregistered
;    Player[5] = Binary (Player Flags)
;      Bit[0] = Channel Commander
;      Bit[1] = Want Voice
;      Bit[2] = No Whisper
;      Bit[3] = Away
;      Bit[4] = Input Mute
;      Bit[5] = Output Mute
;
;  The Server Array - 14 elements
;    Server[0] = String (Server Name)
;    Server[1] = String (Welcome Message)
;    Server[2 - 5] = Number (Server Major, Minor, Release, Build Version)
;    Server[6] = String (Server Platform)
;    Server[7] = String (IP Address of Server)
;    Server[8] = String (Hostname of Server)
;    String[9] = Binary (Server Type)
;      Bit[0] = Clan Server
;      Bit[1] = Public Server
;      Bit[2] = Freeware Server
;      Bit[3] = Commercial Server
;    String[10] = Number (Max Users Allowed)
;    String[11] = Binary (Supported Codecs)
;    String[12] = Number (Current Channel Count)
;    String[13] = Number (Current User Count)
;
;  URL
;  The teamspeak URL used in the connect string is sort of a normal URL.
;  It starts with: teamspeak://server:port which is normal enough
;  then it can accept up to 5 arguments:
;    ?loginname=
;    ?password=
;    ?nickname=
;    ?channel=
;    ?channelpassword=
;  Each argument has the ? seperator.  Don't switch to & after the first one.
;  Spaces are allowed in the URL  don't convert them to %20's.  
;  I'm guessing other special characters are as well.
;  
;  You can use ?channel= more than once, for example if you have two sub channels
;  named "Subchannel 1", one in "Channel 1" and another in "Channel 2":
;    ?channel=Channel 1?channel=Subchannel 1 will specify the one you think.
;
;  There's not a whole lot of documentation out there that I can locate for
;  TSRemote other than the two programs I mentioned above.  It's possible that
;  a lot more can be done - but I have no way of knowing.  Sorry.
;
;  That's it.  Good luck!
;                              Jason - mother9987@lizandjason.com


;$TSRemote = DllOpen( "c:\download\tsremote.dll" )
;$TSRemote = "c:\download\tsremote.dll" ;This seems to work, but seriously - don't use it.

;Dim $Channels[1024][6], $Channel[6], $User[6], $ParentChannel[6], $Players[1024][6], $Server[14]

;Run( "C:\Program Files\Teamspeak2_RC2\TeamSpeak.exe","C:\Program Files\Teamspeak2_RC2\", @SW_HIDE)
;Sleep (1500)

;MsgBox( 0, "Connect", _tsrConnect( $TSRemote, "teamspeak://127.0.0.1:8767?loginname=user?password=password?nickname=nick?channel=channel?channelpassword=secret" ) )
;MsgBox( 0, "Client Version", _tsrGetClientVersion( $TSRemote ) )
;MsgBox( 0, "Server Info", _tsrGetServerInfo( $TSRemote, $Server ) )
;MsgBox( 0, "Server Details", _tsrDisplayServerInfo( $Server ) )
;MsgBox( 0, "Get Channel List", _tsrGetChannelList( $TSRemote, $Channels, $NumChannels)
;For $i = 0 to 5
;	$Channel[$i] = $Channels[$NumChannels - 1][$i]
;Next
;MsgBox(0, "Last Channel", _tsrDisplayChannelInfo( $Channel ) )
;MsgBox(0, "Switch Channel", _tsrSwitchChannelByID( $TSremote, 9 ) )
;MsgBox(0, "User Info", _tsrGetUserInfo( $TSRemote, $User, $Channel, $ParentChannel) )
;MsgBox(0, "Channel Info", _tsrGetChannelInfoByID( $TSRemote, $Channels[$NumChannels - 1][0], $Channel, $Players, $NumPlayers ) )
;MsgBox(0, "Channel Info Channel", _tsrDisplayChannelInfo( $Channel ) )
;For $i = 0 to 5
;	$User[$i] = $Players[0][$i]
;Next
;MsgBox(0, "Channel Info Player", _tsrDisplayDetailedPlayerInfo( $User ) )
;MsgBox(0, "Get Player Info by ID", _tsrGetPlayerInfoByID( $TSRemote, $Players[0][0], $User ) )
;MsgBox(0, "Player Info", _tsrDisplayDetailedPlayerInfo( $User ) )
;MsgBox(0, "Set Away", _tsrSetAway( $TSRemote, 3 ) )
;MsgBox(0, "Set Mute", _tsrSetMute( $TSRemote, 0 ) )
;MsgBox(0, "Set Operator", _tsrSetOperator( $TSRemote, $User[0], 0) )
;MsgBox(0, "Set Voice", _tsrSetVoice( $TSRemote, $User[0], 5) )
;MsgBox(0, "Get Player List, _tsrGetPlayerList( $TSRemote, $Players, $NumPlayers)
;For $i = 0 to 5
;	$User[$i] = $Players[$NumPlayers - 1][$i]
;Next
;MsgBox(0, "Last User", _tsrDisplayDetailedPlayerInfo( $User ) )
;MsgBox(0, "Kick Player", _tsrKickPlayerFromChannel( $TSRemote, $User[0], "You smell." ) )
;MsgBox(0, "Kick Player Server", _tsrKickPlayerFromServer( $TSRemote, $User[0], "You smell awful." ) )
;MsgBox(0, "Send Text Message", _tsrSendTextMessageByID( $TSRemote, 9, "Hello Everyone!" ) )
;MsgBox(0, "Disconnect", _tsrDisconnect( $TSRemote ) )
;MsgBox(0, "Quit", _tsrExitClient( $TSRemote ) )

 Func _tsrDisplayChannelInfo( $avChannelInfo )
	 Local $Channel
	 
	 $Channel = "ID: " & $avChannelInfo[0] & @CRLF
	 $Channel &= "Parent: " & $avChannelInfo[1] & @CRLF
	 $Channel &= "Name: " & $avChannelInfo[5] & @CRLF
	 $Channel &= "Players: " & $avChannelInfo[2] & @CRLF
	 $Channel &= "Flags: " & Hex( $avChannelInfo[3], 8) & @CRLF
	 $Channel &= "Codec: " & Hex( $avChannelInfo[4], 8)
			 
	 Return $Channel
 EndFunc

 Func _tsrDisplayPlayerInfo( $avPlayerInfo )
	Local $Player
	
	$Player = "ID: " & $avPlayerInfo[0] & @CRLF
	$Player &= "Channel: " & $avPlayerInfo[1] & @CRLF
	$Player &= "Nick: " & $avPlayerInfo[2] & @CRLF
	$Player &= "ChannelPrivs: " & Hex( $avPlayerInfo[3], 8 ) & @CRLF
	$Player &= "Privs: " & Hex( $avPlayerInfo[4], 8 ) & @CRLF
	$Player &= "Flags: " & Hex( $avPlayerInfo[5], 8 )
	
	Return $Player
 EndFunc

 Func _tsrDisplayDetailedPlayerInfo( $avPlayerInfo )
	Local Const $pcpAdmin = 2 ^ 0
	Local Const $pcpOperator = 2 ^ 1
	Local Const $pcpAutoOperator = 2 ^ 2
	Local Const $pcpVoiced = 2 ^ 3
	Local Const $pcpAutoVoice = 2 ^ 4	
	
	Local Const $ppSuperServerAdmin = 2 ^ 0
	Local Const $ppServerAdmin = 2 ^ 1
	Local Const $ppCanRegister = 2 ^ 2
	Local Const $ppRegistered = 2 ^ 3
	Local Const $ppUnregistered = 2 ^ 4
	
	Local Const $pfChannelCommander = 2 ^ 0
	Local Const $pfWantVoice = 2 ^ 1
	Local Const $pfNoWhisper = 2 ^ 2
	Local Const $pfAway = 2 ^ 3
	Local Const $pfInputMuted = 2 ^ 4
	Local Const $pfOutputMuted = 2 ^ 5

	Local $Player, $CPrivs
	
	$Player = "ID: " & $avPlayerInfo[0] & @CRLF
	$Player &= "Channel: " & $avPlayerInfo[1] & @CRLF
	$Player &= "Nick: " & $avPlayerInfo[2] & @CRLF

	$CPrivs = ""
	If BitAND( $avPlayerInfo[3], $pcpAdmin) Then $CPrivs = "Admin,"
	If BitAND( $avPlayerInfo[3], $pcpOperator) Then $CPrivs &= "Operator,"
	If BitAND( $avPlayerInfo[3], $pcpAutoOperator) Then $CPrivs = "Auto-Operator,"
	If BitAND( $avPlayerInfo[3], $pcpVoiced) Then $CPrivs &= "Voiced,"
	If BitAND( $avPlayerInfo[3], $pcpAutoVoice) Then $CPrivs &= "Auto-Voice,"
	If $CPrivs<>"" Then
		$CPrivs = StringLeft( $CPrivs, StringLen( $CPrivs ) -1)
	Else
		$CPrivs = "None"
	EndIf
	$Player &= "Channel Privs: " & Hex( $avPlayerInfo[3], 2) & "(" & $CPrivs & ")" & @CRLF
	
	$CPrivs = ""
	If BitAND( $avPlayerInfo[4], $ppSuperServerAdmin) Then $CPrivs = "SuperServerAdmin,"
	If BitAND( $avPlayerInfo[4], $ppServerAdmin) Then $CPrivs &= "ServerAdmin,"
	If BitAND( $avPlayerInfo[4], $ppCanRegister) Then $CPrivs = "CanRegister,"
	If BitAND( $avPlayerInfo[4], $ppRegistered) Then 
		$CPrivs &= "Registered"
	Else
		$CPrivs &= "Unregistered"
	EndIf
	$Player &= "Privs: " & Hex( $avPlayerInfo[4], 2) & "(" & $CPrivs & ")" & @CRLF
	
	$CPrivs = ""
	If BitAND( $avPlayerInfo[5], $pfChannelCommander) Then $CPrivs = "ChannelCommander,"
	If BitAND( $avPlayerInfo[5], $pfWantVoice) Then $CPrivs &= "WantVoice,"
	If BitAND( $avPlayerInfo[5], $pfNoWhisper) Then $CPrivs = "NoWhisper,"
	If BitAND( $avPlayerInfo[5], $pfAway) Then $CPrivs &= "Away,"
	If BitAND( $avPlayerInfo[5], $pfInputMuted) Then $CPrivs &= "InputMuted,"
	If BitAND( $avPlayerInfo[5], $pfOutputMuted) Then $CPrivs &= "OutputMuted,"
	If $CPrivs<>"" Then
		$CPrivs = StringLeft( $CPrivs, StringLen( $CPrivs ) -1)
	Else
		$CPrivs = "None"
	EndIf
	$Player &= "Flags: " & Hex( $avPlayerInfo[5], 2) & "(" & $CPrivs & ")"
	
	Return $Player
 EndFunc	
 
 Func _tsrDisplayServerInfo( $avServerInfo )
	Local Const $tsrcCodecCelp51 = 0
	Local Const $tsrcCodecCelp63 = 1
	Local Const $tsrcCodecGSM148 = 2
	Local Const $tsrcCodecGSM164 = 3
	Local Const $tsrcCodecWindowsCelp52 = 4

	Local Const $tsrcmCelp51 = 2 ^ $tsrcCodecCelp51
	Local Const $tsrcmCelp63 = 2 ^ $tsrcCodecCelp63
	Local Const $tsrcmGSM148 = 2 ^ $tsrcCodecGSM148
	Local Const $tsrcmGSM164 = 2 ^ $tsrcCodecGSM164
	Local Const $tsrcmWindowsCELP52 = 2 ^ $tsrcCodecWindowsCELP52

	Local Const $tsrstClan = 2 ^ 0
	Local Const $tsrstPublic = 2 ^ 1
	Local Const $tsrstFreeware = 2 ^ 2
	Local Const $tsrstCommercial = 2 ^ 3

	Local $Server, $ST, $SC
	
	 $Server = "Servername: " & $avServerInfo[0] & @CRLF
	 $Server &= "Welcome message: " & $avServerInfo[1] & @CRLF
	 $Server &= "Version: " & $avServerInfo[2] & "." & $avServerInfo[3]
	 $Server &= "." & $avServerInfo[4] & "." & $avServerInfo[5] & @CRLF
	 $Server &= "Platform: " & $avServerInfo[6] & @CRLF
	 $Server &= "IP: " & $avServerInfo[7] & @CRLF
	 $Server &= "Host: " & $avServerInfo[8] & @CRLF
	 $Server &= "Max Users: " & $avServerInfo[10] & @CRLF
	 $Server &= "Current User Count: " & $avServerInfo[13] & @CRLF
	 $Server &= "Current Channel Count: " & $avServerInfo[12] & @CRLF
		 
	 $ST = ""
	 If BitAND( $avServerInfo[9], $tsrstFreeware) then $ST = "Freeware "
	 If BitAND( $avServerInfo[9], $tsrstCommercial) then $ST = "Commercial "
	 If BitAND( $avServerInfo[9], $tsrstClan) then $ST &= "Clan Server"
	 If BitAND( $avServerInfo[9], $tsrstPublic) then $ST &= "Public Server"
	 $Server &= "Server Type: " & $ST & @CRLF
	 
	 $SC = ""
	 If BitAND( $avServerInfo[11], $tsrcmCelp51) then $SC = "Celp 5.1, "
	 If BitAND( $avServerInfo[11], $tsrcmCelp63) then $SC &= "Celp 6.3, "
	 If BitAND( $avServerInfo[11], $tsrcmGSM148) then $SC &= "GSM 14.8, "
	 If BitAND( $avServerInfo[11], $tsrcmGSM164) then $SC &= "GSM 16.4, "
	 If BitAND( $avServerInfo[11], $tsrcmWindowsCELP52) then $SC &= "WCELP 5.2, "
	 If StringLen( $SC ) > 0 then $SC = StringLeft( $SC, StringLen( $SC ) - 2)
	 $Server &= "Supported Codecs: " & $SC

	 Return $Server
 EndFunc

 Func _tsrConnect( $vDllPath, $sURL )
	 Local $Result, $Connect
	 
	 $Result = DllCall( $vDllPath, "INT", "tsrConnect", "STR", $sURL )
	 If @Error then Return "CALL FAILED"
		 
     $Connect = _tsrGetLastMessage( $vDllPath, $Result[0] )
	 
	 Return $Connect
 EndFunc
 
 Func _tsrDisconnect( $vDllPath )
	 Local $Result, $Connect
     
	 $Result = DllCall( $vDllPath, "INT", "tsrDisconnect" )
	 if @error then Return "CALL FAILED"
		 
	 $Connect = _tsrGetLastMessage( $vDllPath, $Result[0] )
	 
	 Return $Connect
 EndFunc
	
 Func _tsrExitClient( $vDllPath )
	 Local $Result, $Connect
     
	 $Result = DllCall( $vDllPath, "INT", "tsrQuit" )
	 If @error then Return "CALL FAILED"
		 
	 $Connect = _tsrGetLastMessage( $vDllPath, $Result[0] )
	 
	 Return $Connect
 EndFunc
 
 Func _tsrGetChannelInfoByID( $vDllPath, $iChannelID, ByRef $avChannel, ByRef $avPlayers, ByRef $iNumPlayers)
	Local Const $type_tsrPlayerInfo = "int;int;char[30];int;int;int"
	Local Const $type_tsrChannelInfo = "int;int;int;int;int;char[30]"
	
	Local $p, $ChannelInfo, $PlayersInfo, $Records, $Result, $i, $j
	
	$ChannelInfo = DllStructCreate( $type_tsrChannelInfo )
	$PlayersInfo    = DllStructCreate( "byte[51200]" )
	if @error then return "CALL FAILED"
	
	$Records = DllStructCreate( "int" )
	DllStructSetData( $Records, 1, Ubound( $avPlayers) )

	$Result = DllCall( $vDllPath, "INT", "tsrGetChannelInfoByID", "INT", $iChannelID, "PTR", DllStructGetPtr( $ChannelInfo ), "PTR", DllStructGetPtr( $PlayersInfo ), "PTR", DllStructGetPtr( $Records) )
	
	if @error <> 1 Then
		 if $Result[0] <> 0 then return _tsrGetLastMessage( $vDllPath, $Result[0] )

		 $iNumPlayers = DllStructGetData( $Records, 1) 
		 
		 If $iNumPlayers > 0 Then
			 
			For $j = 0 to $iNumPlayers -1
				$p = DllStructCreate( $type_tsrPlayerInfo, DllStructGetPtr($PlayersInfo) + (50 * $j))
				For $i = 1 to 6
					$avPlayers[$j][ $i-1 ] = DllStructGetData( $p, $i)
				Next			 
			Next
		EndIf
		For $i = 1 to 6
			$avChannel[ $i - 1 ] = DllStructGetData( $ChannelInfo, $i )
		Next
	Else
		return "CALL FAILED"
	EndIf
	 
	DllStructDelete( $ChannelInfo )
	DllStructDelete( $PlayersInfo )
	DllStructDelete( $Records )
	Return "OK" 	
 EndFunc

 Func _tsrGetChannelList( $vDllPath, ByRef $avChannels, ByRef $iNumChannels );
	Local Const $type_tsrChannelInfo = "int;int;int;int;int;char[30]"

	Local $p, $ChannelsInfo, $Records, $Result, $j, $i
	
	$ChannelsInfo    = DllStructCreate( "byte[51200]" )
	if @error then return "CALL FAILED"
	
	$Records = DllStructCreate( "int" )
	DllStructSetData( $Records, 1, Ubound( $avChannels) )
	
	$Result = DllCall( $vDllPath, "INT", "tsrGetChannels", "PTR", DllStructGetPtr( $ChannelsInfo ), "PTR", DllStructGetPtr( $Records) )
	
	if @error <> 1 Then
		 if $Result[0] <> 0 then return _tsrGetLastMessage( $vDllPath, $Result[0] )
		 $iNumChannels = DllStructGetData( $Records, 1) 
		 
		 If $iNumChannels > 0 Then
			 
			For $j = 0 to $iNumChannels -1
				$p = DllStructCreate( $type_tsrChannelInfo, DllStructGetPtr($ChannelsInfo) + (50 * $j))
				For $i = 1 to 6
					$avChannels[$j][ $i-1 ] = DllStructGetData( $p, $i)
				Next			 
			Next
		 EndIf
	Else
		 return "CALL FAILED"
	EndIf
	 
	DllStructDelete( $ChannelsInfo )
	DllStructDelete( $Records )
	Return "OK"
 EndFunc

 Func _tsrGetClientVersion( $vDllPath )
	 Local Const $type_tsrVersion = "int;int;int;int"
	 
	 Local $Version, $VersionInfo, $Result
	 
	 $VersionInfo = DllStructCreate( $type_tsrVersion )
	 
	 $Result = DllCall( $vDllPath, "INT", "tsrGetVersion", "PTR", DllStructGetPtr($VersionInfo) )
	 if @error <> 1 Then
		 If $Result[0] <>0 Then
			 $Version = _tsrGetLastMessage( $vDllPath, $Result[0] )
		 Else
			 
		 $Version = DllStructGetData( $VersionInfo, 1) & "." & DllStructGetData( $VersionInfo, 2) & "."
		 $Version = $Version & DllStructGetData( $VersionInfo, 3) & "." & DllStructGetData( $VersionInfo, 4)
		 DllStructDelete($VersionInfo)
		 
		 $Version = "Version " & $Version 
		 EndIf
	 EndIf
	 
	 Return $Version
 EndFunc

 Func _tsrGetLastMessage( $vDllPath, $iResult )
	Local $ErrorMessage, $Result
	
	Local $ErrorMessage
	$ErrorMessage = "                                                                "
	$ErrorMessage = $ErrorMessage & $ErrorMessage & $ErrorMessage & $Errormessage
	$ErrorMessage = $ErrorMessage & $ErrorMessage & $ErrorMessage & $Errormessage

	If $iResult = 0 Then
		$ErrorMessage = "OK"
	Else
		$Result = DllCall( $vDllPath, "INT", "tsrGetLastError", "STR", $ErrorMessage, "INT", StringLen( $ErrorMessage ) )
		If @error <> 1 Then
			$ErrorMessage = $Result[1] 
		Else
			$ErrorMessage = "CALL FAILED"
		EndIf
	EndIf
 
	Return $ErrorMessage
 EndFunc
 
 Func _tsrGetPlayerInfoByID( $vDllPath, $iPlayerID, ByRef $avPlayer )
	Local Const $type_tsrPlayerInfo = "int;int;char[30];int;int;int"

	Local $Result, $PlayerInfo, $i

	$PlayerInfo = DllStructCreate( $type_tsrPlayerInfo )
	if @error then Return "CALL FAILED"
				
	$Result = DllCall( $vDllPath, "INT", "tsrGetPlayerInfoByID", "INT", $iPlayerID, "PTR", DllStructGetPtr( $PlayerInfo ) )

	if @error then 
		return "CALL FAILED"
	EndIf
	if $Result[0] <> 0 then 
		return _tsrGetLastMessage( $vDllPath, $Result[0] )
	EndIf
	
	for $i=0 to 5
		$avPlayer[ $i ] = DllStructGetData( $PlayerInfo, $i + 1)
	Next
	
	DllStructDelete( $PlayerInfo )
	
	Return "OK"
 EndFunc

 Func _tsrGetPlayerList( $vDllPath, ByRef $avPlayers, ByRef $iNumPlayers );
	Local Const $type_tsrPlayerInfo = "int;int;char[30];int;int;int"

	Local $p, $PlayerInfo, $Records, $Result, $i, $j
	
	$PlayersInfo    = DllStructCreate( "byte[51200]" )
	if @error then return "CALL FAILED"
	
	$Records = DllStructCreate( "int" )
	DllStructSetData( $Records, 1, Ubound( $avPlayers) )
	
	$Result = DllCall( $vDllPath, "INT", "tsrGetPlayers", "PTR", DllStructGetPtr( $PlayersInfo ), "PTR", DllStructGetPtr( $Records) )
	
	if @error <> 1 Then
		 if $Result[0] <> 0 then return _tsrGetLastMessage( $vDllPath, $Result[0] )
		 $iNumPlayers = DllStructGetData( $Records, 1) 
		 
		 If $iNumPlayers > 0 Then
			 
			For $j = 0 to $iNumPlayers -1
				$p = DllStructCreate( $type_tsrPlayerInfo, DllStructGetPtr($PlayersInfo) + (50 * $j))
				For $i = 1 to 6
					$avPlayers[$j][ $i-1 ] = DllStructGetData( $p, $i)
				Next			 
			Next
		 EndIf
	Else
		return "CALL FAILED"
	EndIf
	 
	DllStructDelete( $PlayersInfo )
	DllStructDelete( $Records )
	Return "OK"
 EndFunc
 
 Func _tsrGetServerInfo( $vDllPath, ByRef $avServerInfo )
	Local Const $type_tsrServerInfo = "char[30];char[256];int;int;int;int;char[30];char[30];char[100];int;int;int;int;int"
	
	Local $ServerInfo, $Result, $i
	
	$ServerInfo = DllStructCreate( $type_tsrServerInfo )
	
	$Result = DllCall( $vDllPath, "INT", "tsrGetServerInfo", "PTR", DllStructGetPtr( $ServerInfo ) )
	
	If @error then Return "CALL FAILED"
	For $i = 1 to 14
		$avServerInfo[ $i - 1 ] = DllStructGetData( $ServerInfo, $i )
	Next

	DllStructDelete( $ServerInfo )

	Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc

 Func _tsrKickPlayerFromChannel( $vDllPath, $iPlayerID, $sReason )
		Local $Result
		
		$Result = DllCall( $vDllPath, "INT", "tsrKickPlayerFromChannel", "INT", $iPlayerID, "STR", $sReason )
		If @error then Return "CALL FAILED"
			
		Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc
 
 Func _tsrKickPlayerFromServer( $vDllPath, $iPlayerID, $sReason )
		Local $Result
		
		$Result = DllCall( $vDllPath, "INT", "tsrKickPlayerFromServer", "INT", $iPlayerID, "STR", $sReason )
		If @error then Return "CALL FAILED"
			
		Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc
 
 Func _tsrSetAway( $vDllPath, $fAway )
	  Local Const $pfAway = 2 ^ 3
	  Local $Result, $User[6], $Channel[6], $ParentChannel[6]
	 
	  If _tsrGetUserInfo( $vDllPath, $User, $Channel, $ParentChannel)<>"OK" Then
		  Return "CALL FAILED"
	  EndIf
	  
	  If $fAway then 
		  $User[5] = BitOR( $User[5], $pfAway )
	  Else
		  $User[5] = BitAND( $User[5], BitNOT( $pfAway ) )
	  EndIf
	  
	  $Result = DllCall( $vDllPath, "INT", "tsrSetPlayerFlags", "INT", $User[5] )
	  If @error then return "CALL FAILED"
		  
	  Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc

 Func _tsrSetMute( $vDllPath, $fMute )
	  Local Const $pfInputMuted = 2 ^ 4
	  Local Const $pfOutputMuted = 2 ^ 5
	  Local $Result, $User[6], $Channel[6], $ParentChannel[6]
	 
	  If _tsrGetUserInfo( $vDllPath, $User, $Channel, $ParentChannel)<>"OK" Then
		  Return "CALL FAILED"
	  EndIf
	  
	  If $fMute then 
		  $User[5] = BitOR( $User[5], $pfInputMuted + $pfOutputMuted )
	  Else
		  $User[5] = BitAND( $User[5], BitNOT( $pfInputMuted + $pfOutputMuted ) )
	  EndIf
	  
	  $Result = DllCall( $vDllPath, "INT", "tsrSetPlayerFlags", "INT", $User[5] )
	  If @error then return "CALL FAILED"
		  
	  Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc
 
 Func _tsrSetOperator( $vDllPath, $iPlayerID, $fOperator )
	  Local $Result
	  
	  $fOperator = ($fOperator <> 0)
	 
	  $Result = DllCall( $vDllPath, "INT", "tsrSetOperator", "INT", $iPlayerID, "INT", $fOperator )
	  If @error then return "CALL FAILED"
		  
	  Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc
  
 Func _tsrSetVoice( $vDllPath, $iPlayerID, $fVoice )
	  Local $Result
	  
	  $fVoice = ($fVoice <> 0)
	 
	  $Result = DllCall( $vDllPath, "INT", "tsrSetVoice", "INT", $iPlayerID, "INT", $fVoice )
	  If @error then return "CALL FAILED"
		  
	  Return _tsrGetLastMessage( $vDllPath, $Result[0] )
 EndFunc
  
 Func _tsrGetUserInfo( $vDllPath, ByRef $avUser, ByRef $avChannel, ByRef $avParentChannel )
	Local Const $type_tsrPlayerInfo = "int;int;char[30];int;int;int"
	Local Const $type_tsrChannelInfo = "int;int;int;int;int;char[30]"
	Local Const $type_tsrUserInfo = $type_tsrPlayerInfo & ";" & $type_tsrChannelInfo & ";" & $type_tsrChannelInfo

	Local $Result, $UserInfo, $i
	
	$UserInfo = DllStructCreate( $type_tsrUserInfo )
	if @error then Return -1
				
	$Result = DllCall( $vDllPath, "INT", "tsrGetUserInfo", "PTR", DllStructGetPtr( $UserInfo ) )
	
	if @error then 
		return "CALL FAILED"
	EndIf
	if $Result[0] <> 0 then 
		return _tsrGetLastMessage( $vDllPath, $Result[0] )
	EndIf
	
	for $i=0 to 5
		$avUser[ $i ] = DllStructGetData( $UserInfo, $i + 1)
		$avChannel[ $i ] = DllStructGetData( $UserInfo, $i + 7)
		$avParentChannel[ $i ] = DllStructGetData( $UserInfo, $i + 13)
	Next
	
	DllStructDelete( $UserInfo )
	
	Return "OK"
 EndFunc

 Func _tsrSendTextMessage( $vDllPath, $sMessage )
	 Local $Result, $Send
	 
	 $Result = DllCall( $vDllPath, "INT", "tsrSendTextMessage", "STR", $sMessage )
	 if @error then Return "CALL FAILED"
		 
	 $Send = _tsrGetLastMessage( $vDllPath, $Result[0] )
	 
	 Return $Send
 EndFunc

 Func _tsrSendTextMessageByID( $vDllPath, $iChannelID, $sMessage )
	 Local $Result, $Send
	 
	 $Result = DllCall( $vDllPath, "INT", "tsrSendTextMessageToChannel", "INT", $iChannelID, "STR", $sMessage )
	 if @error then Return "CALL FAILED"
		 
	 $Send = _tsrGetLastMessage( $vDllPath, $Result[0] )
	 
	 Return $Send
 EndFunc
 
 Func _tsrSwitchChannelByID( $vDllPath, $iChannelID, $sPassword="")
	 Local $Result, $Connect
	 
	 $Result = DllCall( $vDllPath, "INT", "tsrSwitchChannelID", "INT", $iChannelID, "STR", $sPassword )
	 $Connect = _tsrGetLastMessage( $vDllPath, $Result[0] )
	 if @error then Return "CALL FAILED"
		 
	 Return $Connect
 EndFunc
 