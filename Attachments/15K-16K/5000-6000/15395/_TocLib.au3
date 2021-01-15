#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.1.12 (beta)
	Script Version: 2.1.1.0
	Author:         Daniel "Falcone88" Leong
	
	Script Function:
	My own UDF for the TOC (Talk To Oscar) Protocol
	
	Documentation for the protocol itself may be found in the following:
	http://terraim.cvs.sourceforge.net/*checkout*/terraim/terraim/src/toc/TOC1.txt
	http://terraim.cvs.sourceforge.net/*checkout*/terraim/terraim/src/toc/TOC2.txt
	
	The following, though a bit dated, was still very helpful:
	                                                                           
	
	If something isn't in the TOC2 docs, it is the same asin TOC1. Note, of course,
	that the most recent things (IE: as shown in TOC2) must be used.	
	
	List of functions:
		_TocLogin
		_TocFinalizeLogin
		_TocSendIM
		_TocSetAway
		_TocParseIm
		_TocParseConfig <- doesn't do anything yet
		_TocCleanup
		
		_TocRegisterFunc
		_TocIsRegistered
		_TocInitLoop
		_TocStopLoop
		_TocDoLoop
		
		_TocRoastPass
		_TocNormalizeName
		_TocNormalizeString
		_TocMakeSigninCode
		_TocMakeFlapPacket
		_TocDecodeFlap
		_TocSendFlap
		_TocSendRaw	
		_TocWaitFlap	
		_TocGetFlap
		
		_BinaryNumber
		_BinaryNumberDecode
	
#ce ----------------------------------------------------------------------------

#include <Array.au3>

; @error codes
Global Const $TOC_TCP_FAIL = 1 			; could not init TCP
Global Const $TOC_CONNECT_FAIL = 2 		; could not connect to toc server
Global Const $TOC_SEND_FAIL = 3 		; could not send over TCP for some reason
Global Const $TOC_ERROR = 4 			; TOC server sent an error code
Global Const $TOC_NO_HANDLERS = 5 		; no functions to handle inputs defined
Global Const $TOC_CMD_TOOLONG = 6 		; attempted to send a string to TOC longer than max

; TOC errors
#cs
	* General Errors *
	901   - $1 not currently available
	902   - Warning of $1 not currently available
	903   - A message has been dropped, you are exceeding
	the server speed limit
	
	;* Admin Errors  *
	911   - Error validating input
	912   - Invalid account
	913   - Error encountered while processing request
	914   - Service unavailable
	
	* Chat Errors  *
	950   - Chat in $1 is unavailable.
	
	* IM & Info Errors *
	960   - You are sending message too fast to $1
	961   - You missed an im from $1 because it was too big.
	962   - You missed an im from $1 because it was sent too fast.
	
	* Dir Errors *
	970   - Failure
	971   - Too many matches
	972   - Need more qualifiers
	973   - Dir service temporarily unavailable
	974   - Email lookup restricted
	975   - Keyword Ignored
	976   - No Keywords
	977   - Language not supported
	-Update: 977 can also mean no directory information available
	978   - Country not supported
	979   - Failure unknown $1
	
	* Auth errors *
	980   - Incorrect nickname or password.
	981   - The service is temporarily unavailable.
	982   - Your warning level is currently too high to sign on.
	983   - You have been connecting and
	disconnecting too frequently.  Wait 10 minutes and try again.
	If you continue to try, you will need to wait even longer.
	989   - An unknown signon error has occurred $1
#ce

; TOC Server -> Client commands
Global Const $TOC_CMD_SIGNON = "SIGN_ON"
Global Const $TOC_CMD_IMRECV = "IM_IN_ENC2"
Global Const $TOC_CMD_CONFIG = "CONFIG2"
Global Const $TOC_CMD_BUDDY_ACCEPTED = "NEW_BUDDY_REPLY2"
Global Const $TOC_CMD_CHATRECV = "CHAT_IN_ENC"
Global Const $TOC_CMD_BUDDY_UPDATE = "UPDATE_BUDDY2"
Global Const $TOC_CMD_CHAT_UPDATE = "CHAT_UPDATE_BUDDY"
Global Const $TOC_CMD_CHATINVITE = "CHAT_INVITE"
Global Const $TOC_CMD_ERROR = "ERROR"
Global Const $TOC_CMD_ANY = "~ANY~" ; catches anything not registered otherwise

; FLAP constant crap
$TOC_FLAP_ON = "FLAPON"&@CRLF&@CRLF
$TOC_ROAST_STRING = "Tic/Toc"
$TOC_LANGUAGE = "english"
$TOC_VERSION = "TIC:TOCLib for Autoit by Dan Leong"
$TOC_COUNTRY = "US"
$TOC_MAX_CHAR_LENGTH = 2048
$TOC_MAX_CHAR_RECV = 8192
$TOC_SIGNON_TYPE = 1
$TOC_DATA_TYPE = 2

; global vars
Global $currSequence = 0
Global $tocTcpSocket
Global $tocVersion = ""
Global $handleRecvCmd[1]
Global $handleRecvFunc[1] ; func called on recieved new message
Global $recvCmdBuffer[1] ; in case we recieve messages too fast, we'll throw extra ones into a buffer


;===============================================================================
;
; Description:      Login to the TOC Server
; Parameter(s):     $sUser	- Username for AIM 
;					$sPass	- Password for AIM 
;					$fFinalize	- Whether or not to finalize connection (see notes)
;					$sTocServer - TOC Servername. The default should be fine, but
;							localhost may be used for testing...
;					$iTocPort	- TOC port to connect to. Again, default should be fine
;					$sAuthServer	- Authentication server. (Allows you to login to AIM)
;					$iAuthPort	- Port of the Auth Server
; Requirement(s):   None
; Return Value(s):  On Success - true
;                   On Failure - false  and Set
;                                   @ERROR to:  $TOC_CONNECT_FAIL - Could not connect to TOC server
;                                               $TOC_SEND_FAIL - Could not send data to the server
;                                               $TOC_ERROR - Recieved an ERROR message from the TOC server
;													The error number will be set in @extended
; Author(s):        Dan "Falcone88" Leong
; Note(s):			If you want to send configurations to the TOC server (say, you're making an AIM client),
;					you will want to set this to false, send your config, then use _TocFinalizeLogin(). Note
;					that this must be sent within 30 seconds of _TocLogin()'s return, or the server will drop
;					the connection.
;
;					The comments on the format of the packets were taken from one of the websites at the top
;					of this file. 
;
;===============================================================================
Func _TocLogin( $sUser, $sPass, $fFinalize=true, $sTocServer="aimexpress.oscar.aol.com", $iTocPort=5190, $sAuthServer="login.oscar.aol.com", $iAuthPort=5190)
	If not TCPStartUp() Then
		SetError($TOC_TCP_FAIL)
		return false
	EndIf
	
	$tocTcpSocket = TCPConnect( TCPNameToIP($sTocServer), $iTocPort )

	if $tocTcpSocket == -1 Then
		SetError($TOC_CONNECT_FAIL)
		return false
	EndIf
	
	; initialize FLAP
	$bytes = _TocSendRaw($TOC_FLAP_ON)
	if $bytes == 0 Then
		SetError($TOC_SEND_FAIL)
		return false
	EndIf
	_DebugPrint( "Sent FLAPON" )
	
	; wait for TOC version
	$tocVersion = _TocWaitFlap()
	_DebugPrint( "Recieved TOC Version" )
	
	; send "signon" packet
	#cs
		First, the version numbers, then a word of 0x0001. This indicates that a user name will follow.
		The next word represents the length of the screen name. Following the length is the normalized
		representation of the screen name - all spaces are removed and the entire name is converted to lowercase.
	#ce
	$bytes = _TocSendFlap($tocVersion & BinaryString( "0x0001" ) & ( _BinaryNumber(StringLen($sUser)) ) & _TocNormalizeName($sUser), $TOC_SIGNON_TYPE )
	if $bytes == 0 Then
		SetError($TOC_SEND_FAIL)
		return false
	EndIf
	_DebugPrint( "Sent SIGNON" )
	
	; login
	#cs
		toc2_login <address> <port> <screenname> <roasted pw> <language> <version*> 160 US "" "" 3 0 30303 -kentucky -utf8 76144224***
		
		* The version string MUST start with "TIC:" otherwise, no dice.  For example, "TIC:AIMM" is ok, but "AIMM2" would be rejected.
		** I have no idea what the parameters after the version are. Put them in verbatim and logging in works.
		*** See _TocMakeSigninCode()
	#ce
	$loginStr =  'toc2_login '&$sAuthServer&' '&$iAuthPort&' "'&$sUser&'" '&_TocRoastPass($sPass)&' "'
	$loginStr &= $TOC_LANGUAGE&'" "'&$TOC_VERSION&'" 160 '&$TOC_COUNTRY&' "" "" 3 0 30303 -kentucky -utf8 '
	$loginStr &= _TocMakeSigninCode($sUser, ($sPass))
	
	$bytes = _TocSendFlap($loginStr)
	if $bytes == 0 Then
		SetError($TOC_SEND_FAIL)
		return false
	EndIf
	_DebugPrint( "Sent LOGIN" )
	
	$response = _TocWaitFlap(2)
	_DebugPrint( _ArrayToString($response, " ") )
	if $response[1] = $TOC_CMD_ERROR Then		
		SetError($TOC_ERROR, StringLeft($response[2], 3), false)
		
	ElseIf $response[1] = $TOC_CMD_SIGNON Then
		_DebugPrint("Logged on successfully")
		
		If $fFinalize Then _TocFinalizeLogin()
		
		return true
	Else		
		_DebugPrint("Weird.. I see ("&$response[1]&")")
		SetError($TOC_ERROR)
		return false
	EndIf
	
	return false ; just in case
EndFunc	;==>_TocLogin

;===============================================================================
;
; Description:      Finalize login to AIM server
; Parameter(s):     None
; Requirement(s):   A successful call to _TocLogin()
; Return Value(s):  Number of bytes sent via TCP
;
; Author(s):        Dan "Falcone88" Leong
; Note(s):			See _TocLogin()
;
;===============================================================================
Func _TocFinalizeLogin()
	return _TocSendFlap("toc_init_done")
EndFunc	;==>_TocFinalizeLogin()


;===============================================================================
;
; Description:      Send an IM to specified user via AIM
; Parameter(s):     $sUser	- Target user's AIM screenname
;                   $sMsg	- The message to send
;                   $fAuto	- Whether or not to specify the message as an auto response
; Requirement(s):   A successful call to _TocLogin()
; Return Value(s):  Number of bytes sent via TCP
;
; Author(s):        Dan "Falcone88" Leong
; Note(s):			None.
;
;===============================================================================
Func _TocSendIM($sUser, $sMsg, $fAuto=false)
	Local $packet = 'toc2_send_im '&_TocNormalizeName($sUser)&' "'
	
	$packet &= _TocNormalizeString($sMsg)&'"'
	
	if $fAuto Then $packet &= ' auto'
	return _TocSendFlap($packet)
EndFunc	;==>_TocSendIM


;===============================================================================
;
; Description:      Set your away message
; Parameter(s):     $sMsg	- The away message to set
;
; Requirement(s):   A successful call to _TocLogin()
; Return Value(s):  Number of bytes sent via TCP
;
; Author(s):        Dan "Falcone88" Leong
; Note(s):			If you call without any arguments, it will set status to
;					available.
;
;===============================================================================
Func _TocSetAway($sMsg = "")	
	return _TocSendFlap('toc_set_away "' & _TocNormalizeString($sMsg) & '"')
EndFunc	;==>_TocSetAway


;===============================================================================
;
; Description:      Parse in IM_IN packet from TOC2 into something useful
; Parameter(s):     $sPacket	- The packet data from IM_IN (Just the data part, not FLAP)
; Requirement(s):   Array.au3
; Return Value(s):  On Success - An array as follows:
;  									$ret[0] = username from
;  									$ret[1] = auto or not (String "T"/"F")
;									$ret[2] = buddy status
;									$ret[3] = message
;                   On Failure - "" and Set @ERROR to 1
; Author(s):        Dan "Falcone88" Leong
; Note(s):			$sPacket SHOULD look like this: (I think)
;					<user>:<auto>:<???>:<???>:<buddy status>:<???>:<???>:en:<message>
;					Note the omission of IM_IN_ENC2... That's because it's omitted in
;					the way _TocDoLoop() calls registered functions ;)
;					Alternatively, it can be an array as returned by _TocGetFlap(2)
;
;===============================================================================
Func _TocParseIm( $sPacket )
	Local $ret[4], $iMod = 0
	if not IsArray($sPacket) Then
		$sPacket = StringSplit($sPacket, ":")
	Else
		$iMod = 1
	EndIf
	
	If not IsArray($sPacket) or UBound($sPacket) <  9+$iMod Then
		SetError(1)
		return ""
	EndIf
	
	$ret[0] = $sPacket[1 + $iMod]
	$ret[1] = $sPacket[2 + $iMod]
	$ret[2] = $sPacket[5 + $iMod]
	$ret[3] = _ArrayToString ( $sPacket, ":", 9 + $iMod )
	
	return $ret
EndFunc	;==>_TocParseIm

;===============================================================================
;
; Description:      Parse a CONFIG2 packet from TOC2 into something useful
; Parameter(s):     $sPacket	- The packet data from CONFIG2 (Just the data part, not FLAP)
; Requirement(s):   Array.au3
; Return Value(s):  On Success - 
;                   On Failure - 
; Author(s):        Dan "Falcone88" Leong
; Note(s):			Obviously, this does nothing at the moment. Looking at samples,
;					It so far seems pointless to include this, as there's no really
;					good way that I can see implementing this as a helpful function
;					without using some strange 3d array
;
;===============================================================================
Func _TocParseConfig( $sPacket )

EndFunc	;==>_TocParseConfig

;===============================================================================
;
; Description:      Cleanup the TCP connections and such
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  None
;
; Author(s):        Dan "Falcone88" Leong
; Note(s):			None
;
;===============================================================================
Func _TocCleanup()
	_TocStopLoop()
	TCPCloseSocket( $tocTcpSocket )
	TCPShutdown()
EndFunc	;==> _TocCleanup

;
; _TocDoLoop() related functions
;

;===============================================================================
;
; Description:      Register a function to be called upon receiving a given command
; Parameter(s):     $sCmd	- The TOC command to trigger the function
;					$sFuncName	- Name of the user's function to be called upon recieve
; Requirement(s):   Array.au3
; Return Value(s):  Always returns true...
; Author(s):        Dan "Falcone88" Leong
; Note(s):			The function to be called should expect a single argument, 
;					which will be the exact string arguments provided in the FLAP packet. 
;
;===============================================================================
Func _TocRegisterFunc($sCmd, $sFuncName)
	$key = _ArraySearch($handleRecvCmd, $sCmd)
	
	if $key == -1 Then
		_ArrayAdd($handleRecvCmd, $sCmd)
		_ArrayAdd($handleRecvFunc, $sFuncName)
		$handleRecvCmd[0] += 1
		$handleRecvFunc[0] += 1
	Else
		$handleRecvFunc[ $key ] = $sFuncName
	EndIf
	
	return true
EndFunc	;==>_TocRegisterFunc


;===============================================================================
;
; Description:      Check if a particular cmd has a function registered with it
; Parameter(s):     $sCmd	- The TOC command to trigger the function
;					$fReturnIndex	- whether to return the index of the cmd (if found)
;								instead of a boolean
; Requirement(s):   Array.au3
; Return Value(s):  On Success -  if $fReturnIndex=false, returns TRUE
;								 if $fReturnIndex=true, returns the index of the func
;					On Failure -  FALSE
;
; Author(s):        Dan "Falcone88" Leong
; Note(s):			$fReturnIndex=true is probably not necessary for the casual
;					user. I use it as a utility for other functions, though
;
;===============================================================================
Func _TocIsRegistered($sCmd, $fReturnIndex=false)
	$key = _ArraySearch($handleRecvCmd, $sCmd)
	
	if $key == -1 Then
		return false
	Else
		if $fReturnIndex Then
			return $key
		Else
			return True
		EndIf
	EndIf	
EndFunc	;==>_TocIsRegistered


;===============================================================================
;
; Description:      Initialize the AdLib loop that checks for server input and calls
;  						the appropriate registered functions. 
; Parameter(s):     $iDelay	- Time in ms between function calls (See definition of AdlibEnable)
; Requirement(s):   At least one call to _TocRegisterFunc
; Return Value(s):  On Success - true
;                   On Failure - false and Set @ERROR to $TOC_NO_HANDLERS (No functions registered)
; Author(s):        Dan "Falcone88" Leong
; Note(s):			none
;
;===============================================================================
Func _TocInitLoop($iDelay=250)
	if $handleRecvCmd[0] < 1 Then
		SetError( $TOC_NO_HANDLERS )
		return false
	EndIf
	
	AdlibEnable("_TocDoLoop", $iDelay)
	return true
EndFunc	;==>_TocInitLoop

;===============================================================================
;
; Description:      Stop the AdLib loop. That's about it ;)
; Parameter(s):     none
; Requirement(s):   A previous call to _TocInitLoop()... if you want it to do something
; Return Value(s):  none
; Author(s):        Dan "Falcone88" Leong
; Note(s):			none
;
;===============================================================================
Func _TocStopLoop()
	AdLibDisable()
EndFunc	;==>_TocStopLoop

;===============================================================================
;
; Description:      The function called in each loop to parse packets.
; Parameter(s):     $iDelay	- Time in ms between function calls (See definition of AdlibEnable)
; Requirement(s):   Array.au3
; Return Value(s):  none
; Author(s):        Dan "Falcone88" Leong
; Note(s):			When it finds a handled command, it sends the whole
;  					argument string to that function. The command itself is,
;  					of course, omitted, as you should know what command it's handling.
;
;===============================================================================
Func _TocDoLoop()
	Local $packet, $cmdIndex

	$packet = _TocGetFlap(2)
	if $packet == -1 Then Return ; nothing
	
;~ 	_DebugPrint( "Recieved: " & _ArrayToString($packet, ":") &@LF& "Looking for: "& $packet[1] )
	$cmdIndex = _ArraySearch($handleRecvCmd, $packet[1])
	if $cmdIndex == -1 Then 
		$cmdIndex = _TocIsRegistered($TOC_CMD_ANY, true)
		
		if $cmdIndex == -1 Then return ; unhandled cmd, ignore
	EndIf
	
	Call( $handleRecvFunc[$cmdIndex], _ArrayToString($packet,":",2) )
EndFunc


;
; Util Funcs
;

;===============================================================================
;
; Description:      "Roast" a password. Basically it's a really simple encryption
;					that TOC requires
; Parameter(s):     $sOldPass	- The unencrypted password
; Requirement(s):   none
; Return Value(s):  The "roasted" password
; Author(s):        Dan "Falcone88" Leong
; Note(s):			none
;
;===============================================================================
Func _TocRoastPass($sOldPass)
	Local $roasted = "0x", $xor_i = 1
	
	for $i=1 to StringLen($sOldPass)
		$roasted &= hex( BitXOR( Asc(StringMid($TOC_ROAST_STRING, $xor_i, 1)), Asc(StringMid($sOldPass, $i, 1)) ), 2 )
		
		$xor_i += 1
		if ( $xor_i > StringLen($TOC_ROAST_STRING) ) Then $xor_i=1
	Next
	
	return $roasted
EndFunc	;==>_TocRoastPass

;===============================================================================
;
; Description:      "Normalize" a name 
; Parameter(s):     $sString	- The string to "normalize"
; Requirement(s):   none
; Return Value(s):  The "normalized" name
; Author(s):        Dan "Falcone88" Leong
; Note(s):			As you can see, this just removes spaces and puts it in lower
;					case. This is mostly used for usernames when communicating 
;					with TOC
;
;===============================================================================
Func _TocNormalizeName($sString)
	return StringReplace(StringLower($sString), " ", "")
EndFunc	;==>_TocNormalizeName


;===============================================================================
;
; Description:      "Normalize" a string. 
; Parameter(s):     $sString	- The string to "normalize"
; Requirement(s):   none
; Return Value(s):  The "normalized" string
; Author(s):        Dan "Falcone88" Leong
; Note(s):			This changes some characters to something more acceptable to
;					TOC. This is another function that received help from
;					BlueTOC
;
;===============================================================================
Func _TocNormalizeString($sString)
	$sString = StringReplace( $sString, "\", "\\" )
	$sString = StringReplace( $sString, "$", "\$" )
	$sString = StringReplace( $sString, '"', '\"' )
	$sString = StringReplace( $sString, "(", "\(" )
	$sString = StringReplace( $sString, ")", "\)" )
	$sString = StringReplace( $sString, "[", "\[" )
	$sString = StringReplace( $sString, "]", "\]" )
	$sString = StringReplace( $sString, "{", "\{" )
	$sString = StringReplace( $sString, "}", "\}" )
			
	return $sString
EndFunc ;==>_TocNormalizeString

;===============================================================================
;
; Description:      Create the wierd authentication code needed to login with TOC2
; Parameter(s):     $sUser	- the username being used to log in
;					$sPass	- the password
; Requirement(s):   none
; Return Value(s):  The code
; Author(s):        Dan "Falcone88" Leong (Conversion to AutoIt)
; Note(s):			Borrowed from BlueTOC, the PHP library for TOC2. Original
;					comments are left intact :)
;
;===============================================================================
Func _TocMakeSigninCode($sUser, $sPass)
	Local $un, $pn, $a, $b, $c
	
	; We get the ascii value of the first character of
	; the username and password and then we subtract
	; 96 from each value
	$un = asc( StringLeft($sUser, 1) ) - 96
	$pn = asc( StringLeft($sPass, 1) ) - 96
	
	; Then we do some math
	$a = $un * 7696 + 738816;
	$b = $un * 746512;
	$c = $pn * $a;
	
	; And then we have some weird signon code we need
	return $c - $a + $b + 71665152;
EndFunc	;==>_TocMakeSigninCode

;===============================================================================
;
; Description:      Take a TOC command and prepend a FLAP header to it :)
; Parameter(s):     $iType - The type of packet. Can be:
;						$TOC_SIGNON_TYPE - used for the signon packet... rarely used
;						$TOC_DATA_TYPE - used for nearly everything. Default :)
;					$sData	- the command string
; Requirement(s):   none
; Return Value(s):  The created packet
; Author(s):        Dan "Falcone88" Leong 
; Note(s):			This took me FOREVER to figure out. The most annoying 
;					part of this whole library, easily
;
;===============================================================================
Func _TocMakeFlapPacket($iType, $sData)
	$currSequence += 1
	if $iType == $TOC_DATA_TYPE Then $sData &= chr(0)

	$btype = _BinaryNumber( $iType, 1 )
	$bseq = _BinaryNumber( ($currSequence) )
	$blen = _BinaryNumber( StringLen($sData) )
	
	$header = "*" & $btype & $bseq & $blen
	
	return $header & $sData
EndFunc	;==>_TocMakeFlapPacket

;===============================================================================
;
; Description:      Decode a raw FLAP packet
; Parameter(s):     $bPacket	- The packet
;
; Requirement(s):   none
; Return Value(s):  Success - An array formated as follows:
;						$ret[0] = "*"
;						$ret[1] = type
;						$ret[2] = sequence number
;						$ret[3] = length of the packet
;						$ret[4] = the packet itself
;						$ret[5] = any excess stuff after reading $ret[3] characters
;					Failure - The original packet, and sets @ERROR = 1
; Author(s):        Dan "Falcone88" Leong 
; Note(s):			This removes any Chr(0) found in the strings. The fifth index
;					is included because sometimes packets are sent quickly and
;					become mixed up. This helps to ensure that all packets
;					are recieved properly.
;
;===============================================================================
Func _TocDecodeFlap( $bPacket )
	If BinaryLen($bPacket) < 1 or Binary( BinaryMid( $bPacket, 1, 1 ) ) <> Binary("*") Then		
		SetError(1) ; not a proper flap packet, returns full packet
		return $bPacket
	EndIf
	
	Local $ret[6]
	
	$ret[0] = "*"
	$ret[1] = _BinaryNumberDecode( BinaryMid($bPacket, 2, 1) ) 
	$ret[2] = _BinaryNumberDecode( BinaryMid($bPacket, 3, 2) )
	$ret[3] = _BinaryNumberDecode( BinaryMid($bPacket, 5, 2) ) 
	$ret[4] = StringMid( BinaryToString($bPacket), 7, $ret[3] )	
	$ret[5] = StringMid( BinaryToString($bPacket), 6 + $ret[3] )	

;~ 	FileWriteLine(@ScriptDir&"\parsed.txt", "--------")
;~ 	FileWriteLine(@ScriptDir&"\parsed.txt", " PacketRaw: " & $bPacket)
;~ 	FileWriteLine(@ScriptDir&"\parsed.txt", "PacketRead: " & $ret[4])
;~ 	FileWriteLine(@ScriptDir&"\parsed.txt", "Proposed Length: " & $ret[3])	
	
	return $ret
EndFunc	;==>_TocDecodeFlap

;===============================================================================
;
; Description:      Send a packet to TOC with a FLAP header. 
; Parameter(s):     $sData	- The data string to send
;					$iType	- type of packet (See _TocMakeFlapPacket)
;					$fTruncate	- See _TocSendRaw()
;
; Requirement(s):   none
; Return Value(s):  Number of bytes sent via TCP
; Author(s):        Dan "Falcone88" Leong 
; Note(s):			$iType is second so it can be optional and default to $TOC_DATA_TYPE, 
;					as that is the most common type
;
;===============================================================================
Func _TocSendFlap( $sData, $iType = 2, $fTruncate=false )
	_DebugPrint("SENT: " & $sData)
	return _TocSendRaw( _TocMakeFlapPacket($iType, $sData) )
EndFunc	;==>_TocSendFlap

;===============================================================================
;
; Description:      Send a raw packet to TOC server
; Parameter(s):     $bData	- The data string to send
;					$fTruncate	- Silently clip $bData if it's too long or not
;
; Requirement(s):   Previous successful call to _TocLogin()
; Return Value(s):  Success - Number of bytes sent via TCP
;					Failure - 0, and set @ERROR = $TOC_CMD_TOOLONG
; Author(s):        Dan "Falcone88" Leong 
; Note(s):			Failure condition only ever occurs if $fTruncate = false. If
;					$fTruncate = true, this will not issue any errors even if
;					the string is longer than allowed ($TOC_MAX_CHAR_LENGTH). It
;					will simply truncate the string to the allowed length
;
;===============================================================================
Func _TocSendRaw( $bData, $fTruncate=false )
	if not $fTruncate and StringLen($bData) > $TOC_MAX_CHAR_LENGTH Then
		SetError($TOC_CMD_TOOLONG)
		return 0
	EndIf		
	
	return TCPSend($tocTcpSocket, StringLeft($bData, $TOC_MAX_CHAR_LENGTH))
EndFunc	;==>_TocSendRaw

;===============================================================================
;
; Description:      Wait until a packet is recieved from the TOC server
; Parameter(s):     $iRetType - Return format; See _TocGetFlap
;
; Requirement(s):   Previous successful call to _TocLogin()
; Return Value(s):  See _TocGetFlap
; Author(s):        Dan "Falcone88" Leong 
; Note(s):			none
;
;===============================================================================
Func _TocWaitFlap($iRetType=1)
	Local $packet = ""
	Do
		$packet = _TocGetFlap($iRetType)

	Until $packet <> -1
	
	return $packet
EndFunc	;==>_TocWaitFlap


;===============================================================================
;
; Description:      Instantaneous (non-blocking) check for a flap packet
; Parameter(s):     $iRetType - Format for the return value
;
; Requirement(s):   Previous successful call to _TocLogin()
; Return Value(s):  Success - Returns the packet, depending on $iRetType:
;						0 - Full packet, raw (including FLAP header)
;						1 - The data part (everything BUT header), raw
;						2 - The data part (everything BUT header), split into
;							an array using ":" as the delimeter
;					Failure - (No new packet) returns -1
; Author(s):        Dan "Falcone88" Leong 
; Note(s):			This function looks about 25 lines longer than it needs to be,
;					but that's because it takes into account packets sent in
;	really close proximity that consequently might be interpretted as a single packet. 
;	Extra packets are added to $recvCmdBuffer and are inserted before the next recieved 
;	packet in order recieved. (Obviously, there could be a backup if a packet wasn't split up, 
;	which this method accounts for. However, this is not a problem, as the new packet will
;	be found and added to the end of the buffer. 
;
;===============================================================================
Func _TocGetFlap($iRetType=0, $fCalledFromLoop=false)
	Local $packet = "", $decoded, $extraString, $newPacket
	
	$packet = TCPRecv($tocTcpSocket, $TOC_MAX_CHAR_RECV)
	
	if $recvCmdBuffer[0] > 0 Then
;~ 		_ArrayAdd( $recvCmdBuffer,  )
		$packet = $recvCmdBuffer[1] & $packet
		_ArrayDelete( $recvCmdBuffer, 1 )
		$recvCmdBuffer[0] -= 1
	EndIf
	
	$decoded = _TocDecodeFlap($packet)			
	
	
	; first, see if we got the whole packet
	If IsArray($decoded) Then		
		If $decoded[3] <> StringLen($decoded[4]) Then
			; if not, enqueue it
			_ArrayAdd( $recvCmdBuffer, $packet )
			$recvCmdBuffer[0] += 1
			
;~ 			_DebugPrint( "Doin' a loop to get the whole packet :)" )
			; call ourself again to get the rest of the packet
			return _TocGetFlap($iRetType)
		EndIf
	Else
		; not a flap packet, ignore for now
		return -1
	EndIf

	; now process
	if StringLen($packet) > 0 Then
		; check for extra commands
		if $decoded[5] <> "" Then
			$extraString = $decoded[5]
			Do ; loop through, enqueing all COMPLETE packets as separate entries
				$newPacket = _TocDecodeFlap( $extraString )
				if IsArray($newPacket) Then
					if $newPacket[0] == "*" Then ; make sure it's actually flap						
						_ArrayAdd( $recvCmdBuffer, StringLeft( $extraString, 6 + $newPacket[3] ) )
						$recvCmdBuffer[0] += 1
						
						$extraString = $newPacket[5]
					EndIf
				Else
					$extraString = ""
				EndIf
			Until $extraString == ""
		EndIf
		
;~ 		FileWriteLine(@ScriptDir&".\buffer.txt", "-------")
;~ 		FileWriteLine(@ScriptDir&".\buffer.txt", "Current packet: "&$packet)
;~ 		FileWriteLine(@ScriptDir&".\buffer.txt", "Excess: " & $decoded[5])
;~ 		FileWriteLine(@ScriptDir&".\buffer.txt", "Buffer: ") 
;~ 		
;~ 		for $i=1 to $recvCmdBuffer[0]			
;~ 			FileWriteLine(@ScriptDir&".\buffer.txt", $recvCmdBuffer[$i] & @CRLF&"<>"&@CRLF )
;~ 		Next
;~ 		
;~ 		FileWriteLine(@ScriptDir&".\buffer.txt", "-------")
		
		_DebugPrint("Received: " & $decoded[4])
		Switch $iRetType
			case 0
				return $packet
			case 1
				return $decoded[4]
			case 2
				return StringSplit($decoded[4], ":")			
		EndSwitch
	Else
		return -1
	EndIf
EndFunc	;==>_TocGetFlap

;===============================================================================
;
; Description:      Convert a number to the necessary binary format, padding the
;					beginning with Chr(0) until it's the appropriate $iLength
; Parameter(s):     $iNum	- The number to be converted
;					$iLength	- The desired length
; Requirement(s):   none
; Return Value(s):  The converted number
; Author(s):        Dan "Falcone88" Leong
; Note(s):			It took me forever to figure out how I was supposed to do this!
;					For $iLength:
;						byte = 1
;						word = 2
;						dword = 4
;						qword = 8
;
;===============================================================================
Func _BinaryNumber($iNum, $iLength=2)		
	Local $b, $numStarted=false, $out="", $prepend=""
		
	$b = Binary($iNum)			
	for $i=BinaryLen($b) to 1 Step -1
		if Chr( BinaryMid($b, $i, 1) ) <> Chr(0) or $numStarted Then
			if not $numStarted then $numStarted = true
			$out &= Chr( BinaryMid($b, $i, 1) )
		EndIf
	Next	

	if BinaryLen($out) < $iLength Then
		for $i=1 to $iLength-BinaryLen($out)
			$prepend &= Chr(0)
		Next
	EndIf
	
	return $prepend&$out

EndFunc	;==>_BinaryNumber


Func BinaryString ($sData)	
	Local $b = Binary($sData)
	Local $out = ""
	
	for $i=1 to BinaryLen($b)
		$out &= Chr( BinaryMid($b, $i, 1) )
	Next

	return $out
EndFunc


;===============================================================================
;
; Description:      Convert a number from the necessary binary format to a
;					usable number
; Parameter(s):     $iNum	- The number to be converted

;
; Requirement(s):   none
; Return Value(s):  The converted number
; Author(s):        Dan "Falcone88" Leong
; Note(s):			It took me forever to figure out how I was supposed to do this.
;					I finally made this magical. Hopefully it still works
;					properly....
;
;===============================================================================
Func _BinaryNumberDecode($iNum)
	
	; A shortcut! 
	if StringInStr(String($iNum), "0x") Then 				
		$iNum = StringMid(String($iNum),3)
		return dec($iNum)
	EndIf
	
	$iOffset = 1
	While StringMid(String($iNum),$iOffset,2) == "00"
		$iOffset+=2
	WEnd
	$sTrim = StringMid($iNum, $iOffset)
	$iLength = StringLen( $sTrim )
	$iVal = 0
	
	for $i=1 to $iLength
		$iVal += Number( String( Asc( StringMid($sTrim,$i,1) ) ) ) * (16^ (2*($iLength-$i)))
	Next
	
	return $iVal
EndFunc	;==>_BinaryNumberDecode

;
; This is not my method, but was very helpful, and I don't want to delete all of the calls
;  to it... just in case. So there :P
;
Func _DebugPrint($s_text)	
	$s_text = StringReplace($s_text,@LF,@LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint		