#include-once
#include <WinHTTP_COM.au3>
; #INDEX# =======================================================================================================================
; Title .........: YMSG Library for AutoIt
; Version .......: 3.4
; Author ........: Crash Daemonicus (crashdemons) <crashenator@gmail.com>
; Language ......: English
; Description ...: A library containing much of the capability related to the [unofficially documented] Yahoo Chat protocol.
; Updated .......: 3.4 - _YMSG_Captcha* function fixes and redesign
;                  3.3 - _YMSG_Client_PM added fields, internal MD5 function now accepts the Crypt.au3 library,
;                        _YMSG_Client_ChatLogin changed, _YMSG_Client_Disconnect added,
;                        $_YMSG_Stealth has been removed because it's values were inconsistent with testing,
;                        _YMSG_Client_StealthPerm and _YMSG_Client_StealthSess have been added.
;                        _YMSG_Client_IgnoreUser has been changed.
;                        _YMSG_Client_SpamReport has been added.
;                        _YMSG_Client_Acknowledge has been added.
;                        _YMSG_ListCreate added.
;                        _YMSG_ItemCreate added.
;                        Default protocol version changed to 17.
; Dependencies ..: Array.au3 for base conversions*, MD5 function*, Base64 functions*, WinHTTP COM functions (included)
;                  * = If you don't use these functions you may be able to disinclude them, assuming you don't use Au3Check.
; ===============================================================================================================================

; #LICENSE# =======================================================================================================================
;           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;                   Version 2, December 2004
;
; License Copyright (C) 2004 Sam Hocevar
;  14 rue de Plaisance, 75014 Paris, France
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;  0. You just DO WHAT THE FUCK YOU WANT TO.
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_YMSG_LibRequire
;_YMSG_LibError
;_YMSG_StripFormatting
;_YMSG_StripTags
;_YMSG_ValidateMobile
;_YMSG_ValidateID
;_YMSG_ValidateFields
;_YMSG_ConfigLogin
;_YMSG_CheckOnline
;_YMSG_ListGetName
;_YMSG_FieldGetName
;_YMSG_PacketGetName
;_YMSG_StatusGetName
;_YMSG_Lang
;_YMSG_Country
;_YMSG_Industry
;_YMSG_JobTitle
;_YMSG_ErrorGetReason
;_YMSG_Auth16
;_YMSG_PwToken_Get
;_YMSG_PwToken_Login
;_YMSG_YContent_Load
;_YMSG_Rooms_CatLoad
;_YMSG_Rooms_CatIDArray
;_YMSG_Rooms_CatGetAttrib
;_YMSG_Rooms_RoomGetAttrib
;_YMSG_Rooms_LobbyGetAttrib
;_YMSG_Rooms_RoomIDArray
;_YMSG_Rooms_LobbyNumArray
;_YMSG_CaptchaLoad
;_YMSG_CaptchaSend
;_YMSG_CaptchaSubmit
;_YMSG_CaptchaClose
;_YMSG_Y64
;_YMSG_CookieEncode
;_YMSG_Base32ToInt
;_YMSG_IntToBase32
;_YMSG_Client_Disconnect
;_YMSG_Client_Ping
;_YMSG_Client_PagerPing
;_YMSG_Client_ChatPing
;_YMSG_Client_HostProbe
;_YMSG_Client_AuthResponseWM
;_YMSG_Client_AuthRequest
;_YMSG_Client_AuthResponse
;_YMSG_Client_VerifyContact
;_YMSG_Client_BuddyAdded
;_YMSG_Client_BuddyDeleted
;_YMSG_Client_IgnoreUser
;_YMSG_Client_AccountInfo
;_YMSG_Client_BudStatus
;_YMSG_Client_Visible
;_YMSG_Client_Away
;_YMSG_Client_PictureRequest
;_YMSG_Client_SMS
;_YMSG_Client_PM
;_YMSG_Client_ChatLogout
;_YMSG_Client_ChatLogin
;_YMSG_Client_ChatJoin
;_YMSG_Client_ChatLeave
;_YMSG_Client_ChatText
;_YMSG_Client_StealthPerm
;_YMSG_Client_StealthSess
;_YMSG_Client_SpamReport
;_YMSG_Client_Acknowledge
;_YMSG_FieldArrayCount
;_YMSG_FieldArrayGetValue
;_YMSG_FieldsToArray
;_YMSG_ListCreate
;_YMSG_ItemCreate
;_YMSG_FieldCreate
;_YMSG_HeaderCreate
;_YMSG_PacketGetLen
;_YMSG_PacketToArray
;_YMSG_PacketFromArray
; ===============================================================================================================================

; #INTERNAL# =====================================================================================================================
;__YMSG_MD5bin
;__YMSG_B64EncodeStr
;__YMSG_B64DecodeBin
;__atoa
;__itoa
;__atoi
;_URIEncode
; ===============================================================================================================================


Global Const $_YMSG_LibVer=3.4
Global Const $_YMSG_FieldDelim=Chr(0xc0)&Chr(0x80)
Global Const $_YMSG_tPacket='byte sig[4]; byte ver[2]; byte vid[2]; byte len[2]; byte typ[2]; byte sta[4]; byte sid[4]'
Global Const $_YMSG_Charset_Y64='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._'
Global Const $_YMSG_Charset_Padding_Y64='-'
Global Const $_YMSG_Charset_Base32='0123456789abcdefghjiklmnopqrstuv'; Triacontakaidecimal / base32hex
Global Const $_YMSG_Charset_CookieEncode_Plain='abcdefghijklmnopqrstuvwxyz0123456789._@-+'
Global Const $_YMSG_Charset_CookieEncode_Encoded='0123456789abcdefghijklmnopqrstuvwxyz._@-+'

Global $_YMSG_LibINI=@ScriptDir&'\YMSGLib.ini'; not a const so that a programmer can change this if absolutely necessary.
Global $_YMSG_ProtocolVersion=17
Global $_YMSG_SessionID='00000000'
Global $_YMSG_VendorID=0
Global $_YMSG_YMVersion='10.0.0.1270'

Global $_YMSG_URL_PwTokenGet='https://login.yahoo.com/config/pwtoken_get?'
Global $_YMSG_URL_PwTokenLogin='https://login.yahoo.com/config/pwtoken_login?'
Global $_YMSG_URL_YContent='                                       '
Global $_YMSG_URL_EditRegJSON='https://edit.yahoo.com/reg_json?'
Global $_YMSG_URL_ConfigLogin='http://login.yahoo.com/config/login?'
Global $_YMSG_URL_OpiOnline='                            '
Global $_YMSG_URL_CaptchaImg='                              '
Global $_YMSG_URL_CaptchaSubmit='http://captcha.chat.yahoo.com/captcha1'
Global $_YMSG_URL_MobileNumber='                                      '

;  [index] [option]
;          [0     ] = str  Return   - Return data of the last CAPTCHA submittal
;          [1     ] = str  URL      - The URL of the last CAPTCHA
;          [2     ] = str  Answer   - The submitted text of the last CAPTCHA
;          [3     ] = int  Timer    - Timer initialized when the last CAPTCHA was loaded
Global $_YMSG_Captcha_Last[4]=[0,'','',0]


;  [index] [option]
;          [0     ] = int  SvcNum (value for field 241)
;          [1     ] = str  SvcName
;          [2 ... ] = str  ShortNames
;          [4 ... ] = str  SomeDomains
;-Pager Service Destinations
Global Const $_YMSG_PgrServices[4][6]=                                      [  _
[ 0,"Yahoo!"             ,"yahoo"  ,"ym"   ,"ymail.com"    ,"rocketmail.com"], _
[ 1,"Live Communications","lcs"    ,"lc"   ,"microsoft.com","microsoft.com" ], _
[ 2,"Windows MSN Live"   ,"windows","msn"  ,"msn.com"      ,"hotmail.com"   ], _
[ 9,"IBM Lotus Sametime" ,"ibm"    ,"lotus","ibm.com"      ,"lotus.com"     ]  ]


;  [index] [option]
;          [0     ] = int  AwayState
;          [1     ] = int  StatusIcon
;          [2     ] = bool HasCustomText
;          [3     ] = str  Name of Status
;  Away States - NOTE: In YMSG16 you must send a different packet to assign Invisible mode.
Global Const $_YMSG_AwayStatus[16][4]= [  _
      [ 12,-1,False,'Invisible'        ], _
      [ 99, 0,True ,'Custom Available' ], _
      [ 99, 1,True ,'Custom Busy'      ], _
      [ 99, 2,True ,'Custom Idle'      ], _
      [  0,-1,False,'Available'        ], _
      [  1,-1,False,'Be Right Back'    ], _
      [  2,-1,False,'Busy'             ], _
      [  3,-1,False,'Not At Home'      ], _
      [  4,-1,False,'Not At Desk'      ], _
      [  5,-1,False,'Not At Office'    ], _
      [  6,-1,False,'On The Phone'     ], _
      [  7,-1,False,'On Vacation'      ], _
      [  8,-1,False,'At Lunch'         ], _
      [  9,-1,False,'Stepped Out'      ], _
      [ 11,-1,False,'Auto Away'        ], _
      [999,-1,False,'Idle'             ]  ]



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_LibRequire
; Description ...: Requires a specific YMSGLib version
; Syntax ........: _YMSG_LibRequire($sLibVer[, $fExact = False[, $sWinHTTPVer = 0[, $fExact2 = False]]])
; Parameters ....: $sLibVer - version of the YMSGLib library
;                  $fExact - If False, higher YMSGLib versions than the one input are applicable.
;                  $sWinHTTPVer - Version of the included WinHTTP library to require
;                  $fExact2 - If True, the exact WinHTTP library version is required.
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_LibRequire($sLibVer,$fExact=False,$sWinHTTPVer=0,$fExact2=False)
	Local $fError=False
	Local $sRequireExt=''
	If $fExact Then
		If Not ($sLibVer=$_YMSG_LibVer) Then $fError=True
	Else
		If Number($_YMSG_LibVer)<Number($sLibVer) Then $fError=True
		$sRequireExt=' or higher'
	EndIf
	If $fError Then Return _YMSG_LibError(16,True,'A YMSGLib version mismatch has occured in the requested program.'&@CRLF& _
	'This program requires YMSGLib v'&$sLibVer&$sRequireExt&' to run.'&@CRLF& _
	'The available YMSGLib is currently v'&$_YMSG_LibVer&'.')

	If $sWinHTTPVer==0 Then Return

	$fError=False
	$sRequireExt=''
	If $fExact2 Then
		If Not ($sWinHTTPVer=$_WinHTTP_LibVer) Then $fError=True
	Else
		If Number($_WinHTTP_LibVer)<Number($sWinHTTPVer) Then $fError=True
		$sRequireExt=' or higher'
	EndIf
	If $fError Then Return _YMSG_LibError(16,True,'A WinHTTP version mismatch has occured in the requested program.'&@CRLF& _
	'This program requires WinHTTP v'&$sWinHTTPVer&$sRequireExt&' to run.'&@CRLF& _
	'The available WinHTTP is currently v'&$_WinHTTP_LibVer&'.')

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_LibError
; Description ...: Displays a YMSGLib error message
; Syntax ........: _YMSG_LibError($iFlags, $fCritical, $sMessage)
; Parameters ....: $iFlags - MessageBox Flags; Please see MsgBox()
;                  $fCritical - If True, the program will exit after the error message.
;                  $sMessage - The body of the error message
; Return values .: Returns the MsgBox return value
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_LibError($iFlags,$fCritical,$sMessage); hopefully we don't have to use this much
	Local $sType='Warning'
	If BitAnd($iFlags,16)=16 Then $sType='Error'
	If BitAnd($iFlags,32)=32 Then $sType='Confirmation'
	If BitAnd($iFlags,64)=64 Then $sType='Information'
	if $fCritical Then $sType='Critical '&$sType
	Local $ret=MsgBox($iFlags,'YMSGLib v'&$_YMSG_LibVer&' '&$sType,$sMessage)
	If $fCritical Then Exit
	Return $ret
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: __YMSG_MD5bin
; Description ...: Creates an MD5 hash using one of several libraries
; Syntax ........: __YMSG_MD5bin($str)
; Parameters ....: $str
; Return values .: Binary representation of an MD5 hash
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __YMSG_MD5bin($str)
	; allows the use of either major MD5 functions: Hex output or binary
	Local $sHash
	$sHash=Call('_MD5',$str)
	If @error=0xDEAD And @extended=0xBEEF Then
		$sHash=Call('_Hash',"MD5",$str)
		if @error=0xDEAD And @extended=0xBEEF Then
			$sHash=Call('MD5',$str)
			if @error=0xDEAD And @extended=0xBEEF Then
				$sHash=Call('_Crypt_HashData',$str,0x00008003,True)
				If @error=0xDEAD And @extended=0xBEEF Then _YMSG_LibError(16,True,'Error: YMSGLib could not find any suitable MD5 libraries.'&@CRLF& _
				'Suitable candidates are:'&@CRLF& _
				'     Crypt.au3'&@CRLF& _
				'          Author: Andreas Karlsson (monoceres)'&@CRLF& _
				'          Function: _Crypt_HashData($vData, $iALG_ID, $fFinal)'&@CRLF& _
				'          Return: Binary'&@CRLF& _
				'     MD5.au3'&@CRLF& _
				'          Author: Ward'&@CRLF& _
				'          Function: _MD5($Data)'&@CRLF& _
				'          Return: Binary'&@CRLF& _
				'     Hash[#].au3, Hash[#]DLL.au3'&@CRLF& _
				'          Author: Ward'&@CRLF& _
				'          Function: _Hash($Type, $Data)'&@CRLF& _
				'          Return: Hex String'&@CRLF& _
				'     MD5.au3'&@CRLF& _
				'          Author: SvenP / Phil Fresle / Frez Systems Ltd.'&@CRLF& _
				'          Function: MD5($sMessage)'&@CRLF& _
				'          Return: Hex String'&@CRLF)
			EndIf
		EndIf
	EndIf

	If Not (StringLeft($sHash,2)=='0x') Then Return Binary('0x'&$sHash)
	Return $sHash
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: __YMSG_B64EncodeStr
; Description ...: Base64 encodes input data using one of several libraries
; Syntax ........: __YMSG_B64EncodeStr($str)
; Parameters ....: $str
; Return values .: Returns a Base64 encoded string
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __YMSG_B64EncodeStr($str)
	Local $sEncode
	Local $sFunc='_Base64Encode'
	$sEncode=Call($sFunc,$str); only here if I find other Base64 libraries to support that have different Encode functions
	If @error=0xDEAD And @extended=0xBEEF Then _YMSG_LibError(16,True,'Error: YMSGLib could not find any suitable Base64 libraries.'&@CRLF& _
		'Suitable candidates are:'&@CRLF& _
		'     Base64.au3 (preferred)'&@CRLF& _
		'          Author: Ward'&@CRLF& _
		'          Function: _Base64Encode($Data, $LineBreak = 76)'&@CRLF& _
		'          Return: String'&@CRLF& _
		'     _Base64.au3'&@CRLF& _
		'          Author: blindwig / Mikeytown2'&@CRLF& _
		"          Function: _Base64Encode($s_Input, $b_WordWrap = '', $s_ProgressTitle = '')"&@CRLF& _
		'          Return: String'&@CRLF)
	;EndIf
	;If StringLeft($sEncode,2)=='0x' Then Return BinaryToString($sEncode); not necessary - YET
	Return $sEncode
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: __YMSG_B64DecodeBin
; Description ...: Base64 decodes input data using one of several libraries
; Syntax ........: __YMSG_B64DecodeBin($str)
; Parameters ....: $str
; Return values .: Returns the binary representation of a Base64 decoded string
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __YMSG_B64DecodeBin($str)
	Local $sDecode
	Local $sFunc='_Base64Decode'
	$sDecode=Call($sFunc,$str)
	If @error=0xDEAD And @extended=0xBEEF Then _YMSG_LibError(16,True,'Error: YMSGLib could not find any suitable Base64 libraries.'&@CRLF& _
		'Suitable candidates are:'&@CRLF& _
		'     Base64.au3 (preferred)'&@CRLF& _
		'          Author: Ward'&@CRLF& _
		'          Function: _Base64Decode($Data)'&@CRLF& _
		'          Return: Binary'&@CRLF& _
		'     _Base64.au3'&@CRLF& _
		'          Author: blindwig / Mikeytown2'&@CRLF& _
		"          Function: _Base64Decode($s_CypherText, $s_ProgressTitle = '')"&@CRLF& _
		'          Return: String'&@CRLF)
	;EndIf
	If Not (StringLeft($sDecode,2)=='0x') Then Return StringToBinary($sDecode)
	Return $sDecode
EndFunc




; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_StripFormatting
; Description ...: Removes formatting substrings from a string
; Syntax ........: _YMSG_StripFormatting($text)
; Parameters ....: $text - The text to strip formatting from
; Return values .: Returns the original string with formatting removed
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_StripFormatting($text)
	$text=StringRegExpReplace($text, "(?s)(?U)\[x?[0-9]m", "")
	$text=StringRegExpReplace($text, "(?s)(?U)\[3[0-9]m", "")
	$text=StringRegExpReplace($text, "(?s)(?U)\[\#[0-9abcdefABCDEF]{6}m", "")
	$text=StringRegExpReplace($text, "(?s)(?U)\[x?lm", "")
	$text=StringReplace($text,"[*m","")
	$text=StringReplace($text,"[%m","")
	Return $text
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_StripTags
; Description ...: Removes valid tags from a string
; Syntax ........: _YMSG_StripTags($text)
; Parameters ....: $text - The text to strip
; Return values .: Returns the original string with tags removed
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_StripTags($text); only the VALID tags!
	$text=StringRegExpReplace($text, "(?i)(?s)(?U)</?(font|fade|alt|u|i|b|sup|red|green|blue) *[^>]*>","")
	$text=StringRegExpReplace($text, "(?i)(?s)(?U)</?(black|white|red|green|blue|purple|gray|grey|pink|purple|orange|yellow) *[^>]*>","")
	$text=StringRegExpReplace($text, "(?s)(?U)<#[^>]*>","")
	Return $text
EndFunc




; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ValidateMobile
; Description ...: Retrieves an HTTP Response containing XML indicating the validity and carrier data of a mobile number.
; Syntax ........: _YMSG_ValidateMobile($sMobileNumber, $sYCookie, $sTCookie[,$intl='us'])
; Parameters ....: sMobileNumber - A string containing a mobile number.
;                  $sYCookie - A string containing a your 'Y' Yahoo Login cookie.
;                  $sTCookie - A string containing a your 'T' Yahoo Login cookie.
;                  $intl -  The international language/country abbreviation for the request.
; Return values .: Success - Returns a the content of the HTTP Response (preferably XML data)
;                  Failure - Returns a blank string ""
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: Thanks to 'LoSt_PrOtOcOL' and 'WickedCoder' for this information
; Related .......:
; Link ..........:                                                            
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ValidateMobile($sMobileNumber,$sYCookie,$sTCookie,$intl='us')
	If StringLeft($sYCookie,2)<>'Y=' Then $sYCookie='Y='&$sYCookie
	If StringLeft($sTCookie,2)<>'T=' Then $sTCookie='T='&$sTCookie
	If StringRight($sYCookie,1)<>';' Then $sYCookie&=';'
	If StringRight($sTCookie,1)<>';' Then $sTCookie&=';'

	Local $return=0
	Local $text=""
	Local $extraHeaders='Cookie: '&$sYCookie&$sTCookie& @CRLF & _
	'Content-Type: application/x-www-form-urlencoded'&@CRLF

	Local $aReq=__YMSG_HTTPReq('POST',$_YMSG_URL_MobileNumber&'?intl='&_URIEncode($intl)&'&version='&_URIEncode($_YMSG_YMVersion), _
	'<validate intl="us" version="'&$_YMSG_YMVersion&'" qos="0">'& _
	'<mobile_no msisdn="'&$sMobileNumber&'"></mobile_no>'&@CRLF& _
	'</validate>',$extraHeaders)
	__YMSG_HTTPTransfer($aReq,$text)
	ConsoleWrite($text&@CRLF)
	Local $pos=StringInStr($text,@CRLF&@CRLF)
	If $pos>0 Then $text=StringMid($text,$pos+4)
	Return $text
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ValidateID
; Description ...: Checks if a username is a valid Yahoo alias.
; Syntax ........: _YMSG_ValidateID($Username[, $fAllowIllegals = True])
; Parameters ....: $Username - The username to validate
;                  $fAllowIllegals - If True, usernames which can't be registered but can be logged in are validated
; Return values .: Success - Returns 0, the Yahoo error code 'OK'
;                  Failure - Returns Yahoo error code 202 and sets @error to:
;                  |@error = 1 : Username length validation was not passed
;                  |@error = 2 : Initial username-format check not passed
;                  |@error = 3 : Username does not start with a letter
;                  |@error = 4 : Username contains two symbols in a row or ends with a symbol
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ValidateID($Username,$fAllowIllegals=True)
	Local $iMin=1
	Local $iMax=256
	Local $valid=False
	Local $iLen=StringLen($Username)
	If $fAllowIllegals=False Then
		$iMin=2
		$iMax=32
	EndIf

	If $iLen>=$iMin And $iLen<=$iMax Then
		If $fAllowIllegals Then
			If StringRegExp($Username,'(?i)^[a-z0-9\-\+\_\.]+(@[a-z]+\.[a-z]+){0,1}$') Then
				$valid=True
			Else
				SetError(2)
			EndIf
		Else
			If StringRegExp($Username,'(?i)^[a-z0-9\_\.]+(@[a-z]+\.[a-z]+){0,1}$') Then
				If StringRegExp($Username,'(?i)^[a-z]') Then; starts with a letter
					If Not StringRegExp($Username,'[\_\.]([\_\.\@]|$)') Then; no double symbols, cannot end with a symbol.
						$valid=True
					Else
						SetError(4)
					EndIf
				Else
					SetError(3)
				EndIf
			Else
				SetError(2)
			EndIf
		EndIf
	Else
		SetError(1)
	EndIf
	If Not $valid Then Return 202
	Return 0
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ValidateFields
; Description ...: Returns the response of the ValidateFields Yahoo Membership API function; Verifies an alias can be registered.
; Syntax ........: _YMSG_ValidateFields($sAccountID)
; Parameters ....: $sAccountID - The username or alias to validate
; Return values .: Success - Returns a response structure containing PERMANENT_FAILURE and suggestions if a username exists; SUCCESS if not.
;                  Failure - Returns a blank string.
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ValidateFields($sAccountID)
	Local $URL=$_YMSG_URL_EditRegJSON&'PartnerName=yahoo_default&AccountID='&_URIEncode(StringLower($sAccountID))&'&ApiName=ValidateFields'
	_WinHTTP_Startup()
	Local $text=_WinHTTP_Request('GET',$URL)
	_WinHTTP_Shutdown()
	Return $text
EndFunc





; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ConfigLogin
; Description ...: Requests a Yahoo Config-Login
; Syntax ........: _YMSG_ConfigLogin($sLogin, $sPasswd,Byref $sYCookie, ByRef $sTCookie)
; Parameters ....: $sLogin - The username to login with
;                  $sPasswd - The password to login with
;                  $sYCookie - The Variable to hold the Y Yahoo cookie
;                  $sTCookie - The Variable to hold the T Yahoo cookie
; Return values .: Returns:
;                  | True - Cookies were present in the HTTP login response and were set
;                  | False - Cookies were not found in the HTTP login response
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ConfigLogin($sLogin, $sPasswd,Byref $sYCookie, ByRef $sTCookie)
	Local $aReq=__YMSG_HTTPReq('GET',$_YMSG_URL_ConfigLogin&'login='&_URIEncode($sLogin)&'&passwd='&_URIEncode($sPasswd))
	Local $sock=TCPConnect(TCPNameToIP($aReq[0]),80)
	TCPSend($sock,$aReq[2])
	Local $recv=""
	While $sock<>-1
		$recv&=TCPRecv($sock,10000)
		If @error<>0 Or (StringInStr($recv,'T=',1)<StringInStr($recv,';',1,-1)) Then
			TCPCloseSocket($sock)
			ExitLoop
		EndIf
		Sleep(50)
	WEnd
	$pos=StringInStr($recv,'Y=v=',1)
	If $pos<1 Then Return False
	$sYCookie=StringMid($recv,$pos+2); cut off the Y=
	$sYCookie=StringLeft($sYCookie,StringInStr($sYCookie,';')-1)

	$sTCookie=StringMid($recv,StringInStr($recv,'T=z=',1)+2)
	$sTCookie=StringLeft($sTCookie,StringInStr($sTCookie,';')-1)

	Return True
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_CheckOnline
; Description ...: Queries Yahoo as to whether a user is publically online
; Syntax ........: _YMSG_CheckOnline($sUser[, $sFormat = 't'[, $iType = 1]])
; Parameters ....: $sUser - The user to check the online status of
;                  $sFormat - The format of the response data; 't' for text, 'g' for graphic
;                  $iType - The type of response for the chosen format
; Return values .: Success - Returns the response data of the request, depending on $sFormat
;                  Failure - Returns an empty string
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: If the format is text and the type is 1, the response will either be 00 or 01 (offline/online)
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_CheckOnline($sUser,$sFormat='t',$iType=1); $sFormat is 't' for Text or 'g' for Graphic
	Local $aReq=__YMSG_HTTPReq('GET',$_YMSG_URL_OpiOnline&'u='&_URIEncode($sUser)&'&m='&_URIEncode($sFormat)&'&t='&_URIEncode($iType))
	Local $recv
	__YMSG_HTTPTransfer($aReq,$recv)
	Local $pos=StringInStr($recv,@CRLF&@CRLF)
	If $pos<1 Then Return ""
	Return StringMid($recv,$pos+4)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ListGetName
; Description ...: Retrieves the preset name of a numerical List type
; Syntax ........: _YMSG_ListGetName($iField)
; Parameters ....: $iField - The numerical data of the list field
; Return values .: Success - The name of the List value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: If the List Field value is NOT known or in the 10000's , it is probably a field # that the list contains.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ListGetName($iField)
	Return IniRead($_YMSG_LibINI,'Lists',Int($iField),'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_FieldGetName
; Description ...: Retrieves the preset name for a field number
; Syntax ........: _YMSG_FieldGetName($iField)
; Parameters ....: $iField - The number of the field
; Return values .: Success - The name of the Field value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_FieldGetName($iField)
	Return IniRead($_YMSG_LibINI,'Fields',Int($iField),'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_PacketGetName
; Description ...: Retrieves the preset name of a Packet Type
; Syntax ........: _YMSG_PacketGetName($hPacket)
; Parameters ....: $hPacket - The Packet Type value in hex
; Return values .: Success - The name of the Packet value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_PacketGetName($hPacket)
	$hPacket=StringRegExpReplace($hPacket,'^0*([[:xdigit:]]*)','\1')
	Return IniRead($_YMSG_LibINI,'Packets',$hPacket,'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_StatusGetName
; Description ...: Retrieves the preset name of a Packet Status
; Syntax ........: _YMSG_StatusGetName($iStatus)
; Parameters ....: $iStatus - The numerical Status of a Packet
; Return values .: Success - The name of the Status value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_StatusGetName($iStatus)
	Return IniRead($_YMSG_LibINI,'Status',Int($iStatus),'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Lang
; Description ...: Retrieves the preset name of a language abbreviation
; Syntax ........: _YMSG_Lang($lg_1)
; Parameters ....: $lg_1 - A language abbreviation (eg: "en")
; Return values .: Success - The name of the Language value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Lang($lg_1)
	Return IniRead($_YMSG_LibINI,'Languages',$lg_1,'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Country
; Description ...: Retrieves the preset name of a country abbreviation
; Syntax ........: _YMSG_Country($Country)
; Parameters ....: $Country - The abbreviation of a country name
; Return values .: Success - The name of the Country value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Country($Country)
	Return IniRead($_YMSG_LibINI,'Countries',$Country,'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Industry
; Description ...: Retrieves the preset name of a Yahoo Industry value
; Syntax ........: _YMSG_Industry($i)
; Parameters ....: $i - The numerical Yahoo value for an Industry selection
; Return values .: Success - The name of the Industry value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Industry($i)
	Return IniRead($_YMSG_LibINI,'Industries',Int($i),'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_JobTitle
; Description ...: Retrieves the name of a Yahoo Job Title value
; Syntax ........: _YMSG_JobTitle($i)
; Parameters ....: $i - The numerical value of a Yahoo Job Title selection
; Return values .: Success - The name of the Title value is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_JobTitle($i)
	Return IniRead($_YMSG_LibINI,'Titles',Int($i),'')
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ErrorGetReason
; Description ...: Retrieves the preset reason text for an error code.
; Syntax ........: _YMSG_ErrorGetReason($vErrorCode)
; Parameters ....: $vErrorCode - A Yahoo error value; numerical with certain exceptions where strings are allowed
; Return values .: Success - The name/reason text of the Yahoo error code is returned
;                  Failure - "" is returned
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ErrorGetReason($vErrorCode)
	; These error codes were taken directly from a Yahoo! registration server and apply to many services,
	; -such as the HTTP Login and some Yahoo Chat errors.
	;$vErrorCode can be a string or an int
	Return IniRead($_YMSG_LibINI,'Errors',$vErrorCode,'')
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Auth16
; Description ...: Performs a Yahoo PwToken retrieval and login
; Syntax ........: _YMSG_Auth16($sUser, $sPass, $sChallenge, ByRef $sYCookie, ByRef $sTCookie, ByRef $sAuthHash64)
; Parameters ....: $sUser - The username to login with
;                  $sPass - The Password to login with
;                  $sChallenge - The YMSG16 challenge to login with
;                  $sYCookie - The variable to hold the output 'Y' Cookie value
;                  $sTCookie - The variable to hold the output 'T' Cookie value
;                  $sAuthHash64 - The variable to hold the output YMSG16 authentication hash
; Return values .: Success - Returns 0
;                  Failure - Returns a non-zero Yahoo error code
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Auth16($sUser,$sPass,$sChallenge,   ByRef $sYCookie, ByRef $sTCookie, ByRef $sAuthHash64); Return 0=Success, Return <> 0=Failure
	_WinHTTP_Startup()
	Local $iError,$sToken,$sPartner,  $sCrumb,$sExpire
	_YMSG_PwToken_Get($iError, $sToken, $sPartner, $sUser,$sPass,$sChallenge)
	If $iError<>0 Then Return $iError
	_YMSG_PwToken_Login($iError,$sCrumb,$sYCookie, $sTCookie, $sExpire,$sToken)
	If $iError<>0 Then Return $iError
	$sYCookie=StringTrimLeft($sYCookie,2); trim off Y=
	$sTCookie=StringTrimLeft($sTCookie,2); trim off T=
	$sAuthHash64=_YMSG_Y64(BinaryToString(__YMSG_MD5bin($sCrumb&$sChallenge)))
	_WinHTTP_Shutdown()
	Return 0
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_PwToken_Get
; Description ...: Performs and outputs data for the Yahoo PwToken retrieval
; Syntax ........: _YMSG_PwToken_Get(ByRef $iError, ByRef $sPwToken, ByRef $sPartnerID, $sUser, $sPass[, $sChallenge = ''])
; Parameters ....: $iError - The variable to hold the output Yahoo error value for the request
;                  $sPwToken - The variable to hold the output PwToken
;                  $sPartnerID - The variable to hold the output Partner ID
;                  $sUser - The username to authenticate with
;                  $sPass - The password to authenticate with
;                  $sChallenge - The optional YMSG16 challenge value for the PwToken retrieval
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_PwToken_Get(ByRef $iError, ByRef $sPwToken, ByRef $sPartnerID, $sUser,$sPass,$sChallenge='')
	Local $sURL=$_YMSG_URL_PwTokenGet&'src=ymsgr&ts=&login='&_URIEncode($sUser)&'&passwd='&_URIEncode($sPass)
	If StringLen($sChallenge)>0 Then $sURL&='&chal='&_URIEncode($sChallenge)
	Local $sData=_WinHTTP_Request('GET',$sURL)
	Local $aData=StringSplit(StringStripCR($sData)&@LF&@LF&@LF,@LF)
	$iError=Int($aData[1])
	If StringLen($sData)<1 Then $iError=20000
	$sData=0
	$sPwToken=StringReplace($aData[2],'ymsgr=','',1)
	$sPartnerID=StringReplace($aData[3],'partnerid=','',1)
	$aData=0
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_PwToken_Login
; Description ...: Performs and outputs data for the Yahoo PwToken login
; Syntax ........: _YMSG_PwToken_Login(ByRef $iError, ByRef $sCrumb, ByRef $sYCookie, ByRef $sTCookie, Byref $sExpire, $sPwToken)
; Parameters ....: $iError - The variable to hold the output Yahoo error value
;                  $sCrumb - The variable to hold the output Yahoo Crumb value
;                  $sYCookie - The variable to hold the output 'Y' cookie value
;                  $sTCookie - The variable to hold the output 'T' cookie value
;                  $sExpire - The variable to hold the output expiration time for the output cookies
;                  $sPwToken - The PwToken value to complete login authentication with
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_PwToken_Login(ByRef $iError,ByRef $sCrumb,ByRef $sYCookie, ByRef $sTCookie, Byref $sExpire, $sPwToken)
	Local $sURL=$_YMSG_URL_PwTokenLogin&'src=ymsgr&ts=&token='&_URIEncode($sPwToken)
	Local $sData=_WinHTTP_Request('GET',$sURL)
	$aData=StringSplit(StringStripCR($sData)&@LF&@LF&@LF&@LF,@LF)
	$iError=Int($aData[1])
	If StringLen($sData)<1 Then $iError=20000
	$sData=0
	$sCrumb=StringReplace($aData[2],'crumb=','',1)
	$sYCookie=StringMid($aData[3],1,StringInStr($aData[3],';')-1)
	$sTCookie=StringMid($aData[4],1,StringInStr($aData[4],';')-1)
	$sExpire=StringReplace($aData[5],'cookievalidfor=','',1)
	$aData=0
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_YContent_Load
; Description ...: Returns a specified Yahoo YContent XML value
; Syntax ........: _YMSG_YContent_Load(ByRef $sXML, $sType[, $sData = 1[, $sIntl = 'us']])
; Parameters ....: $sXML - The variable to hold the output XML data
;                  $sType - The name of the YContent data to request
;                  $sData - The data to assign to the YContent request type argument (usually not required)
;                  $sIntl - The international language/country abbreviation for the request
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_YContent_Load(ByRef $sXML, $sType, $sData=1, $sIntl='us')
	$sXML=""
	Local $aReq=__YMSG_HTTPReq('GET',$_YMSG_URL_YContent&$sType&'='&_URIEncode($sData)&'&intl='&_URIEncode($sIntl))
	Local $recv
	__YMSG_HTTPTransfer($aReq,$recv)
	Local $pos=StringInStr($recv,@CRLF&@CRLF)
	If $pos<1 Then Return
	$sXML=StringMid($recv,$pos+4)
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_CatLoad
; Description ...: Outputs the XML Data pertaining to the Yahoo Chat room categories
; Syntax ........: _YMSG_Rooms_CatLoad(ByRef $sXML[, $iCatID = 0[, $sIntl = 'us']])
; Parameters ....: $sXML
;                  $iCatID - The room category number to request, use 0 for a category listing.
;                  $sIntl - The international language/country abbreviation for the request
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_CatLoad(ByRef $sXML, $iCatID=0, $sIntl='us')
	Local $sType='chatcat'
	if $iCatID<>0 Then $sType='chatroom_'&$iCatID
	_YMSG_YContent_Load($sXML, $sType, 1, $sIntl)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_CatIDArray
; Description ...: Creates an array of Yahoo room category ID's from XML data
; Syntax ........: _YMSG_Rooms_CatIDArray($sXML, ByRef $aIDs)
; Parameters ....: $sXML - XML data containing the Yahoo room category list
;                  $aIDs - The variable to hold the output array of category ID's
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_CatIDArray($sXML, ByRef $aIDs); really bad
	$aIDs=''
	Local $pos=0
	Local $mfnd='<category id="'
	Local $mlen=StringLen($mfnd)
	Do
		If $pos>$mlen Then
			$sXML=StringMid($sXML,$pos)
			$aIDs&=StringMid($sXML,1,StringInStr($sXML,'"')-1)&'|'
		EndIf
		$pos=StringInStr($sXML,$mfnd)+$mlen
	Until $pos<=$mlen
	If StringRight($aIDs,1)='|' then $aIDs=StringTrimRight($aIDs,1)
	$aIDs=StringSplit($aIDs,'|')
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_CatGetAttrib
; Description ...: Finds the value of an XML tag attribute for a Yahoo room category
; Syntax ........: _YMSG_Rooms_CatGetAttrib(ByRef $sXML, $iCatID[, $sAttrib = 'name'])
; Parameters ....: $sXML - The variable containing the XML data for the Yahoo room category list
;                  $iCatID - A Yahoo room category ID
;                  $sAttrib - The name of the attribute to retrieve the value of
; Return values .: Returns a string containing the value of the tag attribute
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_CatGetAttrib(ByRef $sXML, $iCatID, $sAttrib='name')
	Local $sTagData=StringMid($sXML,StringInStr($sXML,'<category id="'&$iCatID&'"'))
	$sTagData=StringMid($sTagData,1,StringInStr($sTagData,'>'))
	$sAttrib&='="'
	$sTagData=StringMid($sTagData,StringInStr($sTagData,$sAttrib)+StringLen($sAttrib))
	Return StringMid($sTagData,1,StringInStr($sTagData,'"')-1)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_RoomGetAttrib
; Description ...: Returns the value of an XML tag attribute for a Yahoo room
; Syntax ........: _YMSG_Rooms_RoomGetAttrib(ByRef $sXML, $iRoomID[, $sAttrib = 'name'[, $sRoomType = 'yahoo']])
; Parameters ....: $sXML - The variable containing the Yahoo room list XML data
;                  $iRoomID - The ID of a specific Yahoo room
;                  $sAttrib - The name of the attribute to retrieval the value of
;                  $sRoomType - The type of room (should always be "yahoo", anymore)
; Return values .: Returns a string containing the value of the tag attribute
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_RoomGetAttrib(ByRef $sXML, $iRoomID, $sAttrib='name', $sRoomType='yahoo')
	Local $sTagData=StringMid($sXML,StringInStr($sXML,'<room type="'&$sRoomType&'" id="'&$iRoomID&'"'))
	$sTagData=StringMid($sTagData,1,StringInStr($sTagData,'>'))
	$sAttrib&='="'
	$sTagData=StringMid($sTagData,StringInStr($sTagData,$sAttrib)+StringLen($sAttrib))
	Return StringMid($sTagData,1,StringInStr($sTagData,'"')-1)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_LobbyGetAttrib
; Description ...: Returns the value of an XML tag attribute for a Yahoo lobby (Room #)
; Syntax ........: _YMSG_Rooms_LobbyGetAttrib(ByRef $sXML, $iRoomID[, $iLobbyCount = 1[, $sAttrib = 'users'[, $sRoomType = 'yahoo']]])
; Parameters ....: $sXML - The variable containing the Yahoo room list XML data
;                  $iRoomID - The ID of a specific Yahoo room
;                  $iLobbyCount - The number of the Yahoo room (eg: 1 for Computers Lobby:1)
;                  $sAttrib - The name of the attribute to retrieve the value of
;                  $sRoomType - The type of room
; Return values .: Returns a string containing the value of the tag attribute
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_LobbyGetAttrib(ByRef $sXML, $iRoomID, $iLobbyCount=1, $sAttrib='users', $sRoomType='yahoo')
	Local $sTagData=StringMid($sXML,StringInStr($sXML,'<room type="'&$sRoomType&'" id="'&$iRoomID&'"'))
	$sTagData=StringMid($sTagData,StringInStr($sTagData,'<lobby count="'&$iLobbyCount&'"'))
	$sTagData=StringMid($sTagData,1,StringInStr($sTagData,'>'))
	$sAttrib&='="'
	$sTagData=StringMid($sTagData,StringInStr($sTagData,$sAttrib)+StringLen($sAttrib))
	Return StringMid($sTagData,1,StringInStr($sTagData,'"')-1)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_RoomIDArray
; Description ...: Outputs an array of room ID's from XML data containing a Yahoo room list
; Syntax ........: _YMSG_Rooms_RoomIDArray($sXML, ByRef $aIDs)
; Parameters ....: $sXML - The XML data of a Yahoo room list
;                  $aIDs - The variable to hold the ouput array of room ID's
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_RoomIDArray($sXML, ByRef $aIDs); really bad
	$aIDs=''
	Local $pos=0
	Local $mfnd='<room type="yahoo" id="'
	Local $mlen=StringLen($mfnd)
	Do
		If $pos>$mlen Then
			$sXML=StringMid($sXML,$pos)
			$aIDs&=StringMid($sXML,1,StringInStr($sXML,'"')-1)&'|'
		EndIf
		$pos=StringInStr($sXML,$mfnd)+$mlen
	Until $pos<=$mlen
	If StringRight($aIDs,1)='|' then $aIDs=StringTrimRight($aIDs,1)
	$aIDs=StringSplit($aIDs,'|')
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Rooms_LobbyNumArray
; Description ...: Outputs an array of Lobby numbers (Room #'s) from XML data containing a Yahoo room list
; Syntax ........: _YMSG_Rooms_LobbyNumArray($sXML, $iRoomID, ByRef $aIDs)
; Parameters ....: $sXML - XML data containing a yahoo room list
;                  $iRoomID - the ID of the room requested
;                  $aIDs - The variable to hold the output array of lobby numbers
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Rooms_LobbyNumArray($sXML, $iRoomID, ByRef $aIDs); really bad - should be in numerical order, but NOT ALWAYS
	$sXML=StringMid($sXML,StringInStr($sXML,'<room type="yahoo" id="'&$iRoomID&'"'))
	$sXML=StringMid($sXML,1,StringInStr($sXML,'</room'))
	$aIDs=''
	Local $pos=0
	Local $mfnd='<lobby count="'
	Local $mlen=StringLen($mfnd)
	Do
		If $pos>$mlen Then
			$sXML=StringMid($sXML,$pos)
			$aIDs&=StringMid($sXML,1,StringInStr($sXML,'"')-1)&'|'
		EndIf
		$pos=StringInStr($sXML,$mfnd)+$mlen
	Until $pos<=$mlen
	If StringRight($aIDs,1)='|' then $aIDs=StringTrimRight($aIDs,1)
	$aIDs=StringSplit($aIDs,'|')
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_CaptchaLoad
; Description ...: Loads, displays and processes events for a Yahoo chat CAPTCHA form
; Syntax ........: _YMSG_CaptchaLoad($_YMSG_URL_Captcha = ''[, $ResendOldValid = True[, $OGUI_Array = False]])
; Parameters ....: $_YMSG_URL_Captcha - The URL of the Yahoo Chat CAPTCHA
;                  $ResendOldValid - If True, the last successful submission is resent if within 5 minutes of it
;                  $OGUI_Array - An array containing GUI  ID's for an external CAPTCHA form
; Return values .: Success - Returns 1 if the CAPTCHA answer was correct
;                  Failure - Returns one of the following values:
;                  |Returns -2 if the CAPTCHA has expired or was denied for other reasons
;                  |Returns -1 if the CAPTCHA answer was incorrect
;                  |Returns 0 if the CAPTCHA submission encountered an error or the response was not recognized
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_CaptchaLoad($_YMSG_URL_Captcha='',$ResendOldValid=True, $OGUI_Array=False)
	Global $_YMSG_Captcha_Submitted,$_YMSG_Captcha_Last
	Local $iTimer=TimerInit()
	Local $iMin, $iSec


	$Args=__YMSG_URL_GetArgs($_YMSG_URL_Captcha)
	$ArgsArr=__YMSG_URL_ArgsToArray($Args)

	$iimg=__YMSG_URL_ArgArray_GetArg($ArgsArr,'img')
	$img=$ArgsArr[$iimg][1]



	Local $sImgFile=@ScriptDir&'\_YMSG_Captcha.jpg'
	$_YMSG_Captcha_Submitted=0
	Local $return=0
	If $ResendOldValid Then
		If $_YMSG_Captcha_Last[0]=1 Then
			If TimerDiff($_YMSG_Captcha_Last[3])<(299000) Then;captcha is less than 5 minutes old (1 sec off for recv time)
				;_YMSGLib_Console('CAPTCHA_ResendOldValid: '&$_YMSG_Captcha_Last[2]&@CRLF)
				$return=_YMSG_CaptchaSend($_YMSG_Captcha_Last)
			EndIf
		EndIf
	EndIf
	If $return=0 Then
		;_YMSGLib_Console('CAPTCHA: '&$img&@CRLF)
		If StringLen($img)<1 Then $img=$_YMSG_URL_CaptchaImg&'/invalid.jpg'

		Local $aReq=__YMSG_HTTPReq('GET',$img)
		Local $recv
		__YMSG_HTTPTransfer($aReq,$recv)
		__YMSG_toBinary($recv)
		Local $pos=StringInStr(BinaryToString($recv),@CRLF&@CRLF)
		If $pos>0 Then $recv=BinaryMid($recv,$pos+4)
		If FileExists($sImgFile) Then FileDelete($sImgFile)
		Local $fh=FileOpen($sImgFile, 2+16)
		If $fh<>-1 Then
			FileWrite($fh, $recv)
			;ConsoleWrite('Written '&IsBinary($recv)&' '&$recv&@CRLF)
			FileClose($fh)
		Else
			; can't write!
		EndIf

		Local $_YMSG_Captcha_Form, $Input1,$Label4,$Pic1,$Icon1, $answer,$Button1, $Button2
		If Not IsArray($OGUI_Array) Then
			#Region ### START Koda GUI section ### Form=
			$_YMSG_Captcha_Form = GUICreate("Humans Only", 316, 265, 560, 228)
			GUICtrlCreateLabel("Enter the text displayed in the graphic below. ", 1, 10, 311, 18, 1)
			$Input1 = GUICtrlCreateInput("", 43, 29, 225, 41, BitOR(1,128))
			GUICtrlSetFont(-1, 23, 400, 0, "Courier New Bold")
			GUICtrlCreateLabel("( It's OK to enter it in all lowercase ) ", 8, 73, 298, 17, 1)
			GUICtrlSetState(-1, 128)
			$Pic1 = GUICtrlCreatePic("", 14, 93, 285, 114, BitOR(256,131072,67108864),131072)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlSetState(-1, 128)
			$Label4=GUICtrlCreateLabel("", 21, 96, 273, 17, 1)
			GUICtrlSetColor(-1, 0x808080)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			$Button1=GUICtrlCreateButton("OK", 214, 230, 89, 25,1)
			$Button2=GUICtrlCreateButton("Cancel", 12, 230, 89, 25, 0)
			$Icon1 = GUICtrlCreateIcon("", 0, 146, 225, 32, 32, BitOR(256,131072))
			Dim $Accels[1][2]=[['{Enter}',$Button1]]
			GUISetAccelerators($Accels,$_YMSG_Captcha_Form)
			#EndRegion ### END Koda GUI section ###
		Else
			$_YMSG_Captcha_Form=$OGUI_Array[0]
			$Input1=$OGUI_Array[1]
			$Pic1=$OGUI_Array[2]
			$Label4=$OGUI_Array[3]
			$Button1=$OGUI_Array[4]
			$Button2=$OGUI_Array[5]
			$Icon1=$OGUI_Array[6]
		EndIf
			GUISetOnEvent(-3,'_YMSG_CaptchaClose',$_YMSG_Captcha_Form)
			GUICtrlSetOnEvent($Button2,'_YMSG_CaptchaClose')
			GUICtrlSetOnEvent($Button1,'_YMSG_CaptchaSubmit')
			GUICtrlSetImage($Icon1,@ScriptFullPath)
			GUICtrlSetImage($Pic1,$sImgFile)
			$_YMSG_Captcha_Submitted=0
			GUISetState(@SW_SHOW,$_YMSG_Captcha_Form)
			WinSetOnTop($_YMSG_Captcha_Form,'',1)
			WinActivate($_YMSG_Captcha_Form)
			GUICtrlSetState($Input1,256)

		Local $lasttime,$newtime
		While Not $_YMSG_Captcha_Submitted=-1
			$iSec=299-Round(TimerDiff($iTimer)/1000,0)
			If $iSec<=0 Then $_YMSG_Captcha_Submitted=-1
			$iMin=Int($iSec/60)
			$iSec-=$iMin*60
			$iMin='0'&$iMin; always lower than 5 minutes, so it always needs a 0
			If $iSec<10 Then $iSec='0'&$iSec
			$newtime=$iMin&':'&$iSec
			If $newtime<>$lasttime Then
				GUICtrlSetData($Label4,"This window will self-destruct in "&$newtime)
				GUICtrlSetState($Button1, 512)
				$lasttime=$newtime
			EndIf
			Sleep(300)
		WEnd
		$answer=GUICtrlRead($Input1)
		GUIDelete($_YMSG_Captcha_Form)
	EndIf
	If $_YMSG_Captcha_Submitted=1 Then
		Local $CaptchaInfoArray[4]=[0,$_YMSG_URL_Captcha,$answer,$iTimer]
		$return=_YMSG_CaptchaSend($CaptchaInfoArray)
		$CaptchaInfoArray[0]=$return
		If $return=1 Then
			$_YMSG_Captcha_Last=$CaptchaInfoArray
			;_YMSGLib_Console('CAPTCHA_ValidSaved: '&$answer&@CRLF)
		EndIf
	EndIf
	FileDelete(@ScriptDir&'\_YMSG_Captcha.jpg')
	Return $return
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_CaptchaSend
; Description ...: Submits an answer to a Yahoo Chat CAPTCHA
; Syntax ........: _YMSG_CaptchaSend($img, $answer[, $intl = 'us'])
; Parameters ....: CaptchaInfoArray - Captcha information array containing [Last Return Value, Full Captcha URL, Captcha Answer, Last Timer]
; Return values .: Success - Returns 1 if the CAPTCHA answer was correct
;                  Failure - Returns one of the following values:
;                  |Returns -2 if the CAPTCHA has expired or was denied for other reasons
;                  |Returns -1 if the CAPTCHA answer was incorrect
;                  |Returns 0 if the CAPTCHA submission encountered an error or the response was not recognized
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_CaptchaSend($CaptchaInfoArray)
	Local $return=0
	Local $text=""
	Local $URL=$CaptchaInfoArray[1]
	Local $extraHeaders="Referer: "&$URL&@CRLF& _
	"Content-Type: application/x-www-form-urlencoded"&@CRLF

	Local $answer=$CaptchaInfoArray[2]
	Local $args=__YMSG_URL_GetArgs($URL)
	Local $arr=__YMSG_URL_ArgsToArray($args)
	__YMSG_URL_ArgArray_SetArg($arr, 'img','question')
	Local $args2=__YMSG_URL_ArrayToArgs($arr)


	Local $aReq=__YMSG_HTTPReq('POST',$_YMSG_URL_CaptchaSubmit, _
	$args2& _
	'&answer='&_URIEncode($answer) _
	,$extraHeaders)


	__YMSG_HTTPTransfer($aReq,$text)
	ConsoleWrite($text&@CRLF)
	Local $pos=StringInStr($text,@CRLF&@CRLF)
	If $pos>0 Then $text=StringMid($text,$pos+4)

	#cs
	_WinHTTP_Startup()
	$text=_WinHTTP_Request('POST','http://captcha.chat.yahoo.com/captcha1','question='&$img&'&.intl='&$intl&'&answer='&$answer)
	_WinHTTP_Shutdown()
	#ce
	If StringLen($text)>0 Then
		If StringInStr($text,'captchat/')>0 Then
			$return=1
			If StringInStr($text,'?tryagain') Then $return=-1
			If StringInStr($text,'?exceeded') Then $return=-2
		EndIf
	EndIf
	Return $return
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_CaptchaSubmit
; Description ...: Form event for 'CaptchaLoad' if the CAPTCHA response is to be sent
; Syntax ........: _YMSG_CaptchaSubmit()
; Parameters ....:
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_CaptchaSubmit()
	Global $_YMSG_Captcha_Submitted
	$_YMSG_Captcha_Submitted=1
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_CaptchaClose
; Description ...: Form event for 'CaptchaLoad' if the CAPTCHA response is NOT to be sent
; Syntax ........: _YMSG_CaptchaClose()
; Parameters ....:
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_CaptchaClose()
	Global $_YMSG_Captcha_Submitted
	$_YMSG_Captcha_Submitted=-1
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Y64
; Description ...: Returns the results of Yahoo's modified Base64 algorithm
; Syntax ........: _YMSG_Y64($Data[, $fEncode = True])
; Parameters ....: $Data - The data to either be encoded or decoded with Y64
;                  $fEncode - if True, the data will be encoded; if false - decoded
; Return values .: Returns Binary representation of the Y64 decoded data or the String value of the Y64 encoded data
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Y64($Data,$fEncode=True)
	If $fEncode Then
		Return StringReplace(StringReplace(StringReplace(__YMSG_B64EncodeStr($Data),'+','.'),'/','_'),'=','-')
	Else
		Return __YMSG_B64DecodeBin(StringReplace(StringReplace(StringReplace($Data,'.','+'),'_','/'),'-','='))
	EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_CookieEncode
; Description ...: Returns the result of Yahoo's cookie obfuscation algorithm
; Syntax ........: _YMSG_CookieEncode($str, $fEncode)
; Parameters ....: $str - A string to either be encoded or decoded
;                  $fEncode - If True, the data will be encoded; if False - decoded.
; Return values .: Returns the encoded or decoded string value.
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_CookieEncode($str,$fEncode); this is the simple replacement encoding being done on some Yahoo cookies values
	;yeah this could be more efficient
	Local $strln=StringLen($str)
	Local $pos
	Local $out=""
	For $i=1 To $strln
		Switch $fEncode
			Case True
				$out&= StringMid($_YMSG_Charset_CookieEncode_Encoded,StringInStr($_YMSG_Charset_CookieEncode_Plain,StringMid($str,$i,1)),1)
			Case False
				$out&= StringMid($_YMSG_Charset_CookieEncode_Plain,StringInStr($_YMSG_Charset_CookieEncode_Encoded,StringMid($str,$i,1)),1)
		EndSwitch
	Next
	Return $out
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Base32ToInt
; Description ...: Returns the integer representation of a Base32 string
; Syntax ........: _YMSG_Base32ToInt($sBase32String)
; Parameters ....: $sBase32String - The Base32 string to decode
; Return values .: Success - Returns an integer value.
;                  Failure - Returns 0 and sets @error to:
;                  |@error = 1 : Charset too short (2 characters minimum required)
;                  |@error = 2 : Character not found in Charset (invalid input string)
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Base32ToInt($sBase32String)
	Local $i=__atoi($sBase32String,$_YMSG_Charset_Base32)
	Return SetError(@error,0,$i)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_IntToBase32
; Description ...: Returns the Base32 string representation of an integer value
; Syntax ........: _YMSG_IntToBase32($iInteger)
; Parameters ....: $iInteger - The integer value to encode
; Return values .: Success - Returns a Base32 string.
;                  Failure - Returns "" and sets @error to:
;                  |@error = 1 : Charset too short (2 characters minimum required)
;                  |@error = 2 : Character position out-of-range (should be impossible)
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: Returns only the first character in the Base32 charset if the converted value is 0
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_IntToBase32($iInteger)
	Local $s=__itoa($iInteger,$_YMSG_Charset_Base32)
	Return SetError(@error,0,$s)
EndFunc




; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_Disconnect
; Description ...: Creates the Disconnect packet
; Syntax ........: _YMSG_Client_Disconnect([$iVersion=-1[,$iVendor=-1[,$hSessionID=-1]]])
; Parameters ....: $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_Disconnect($iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,0,'0002',0,$hSessionID)
	Return $sHeader
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_Ping
; Description ...: Creates the Generic Ping packet
; Syntax ........: _YMSG_Client_Ping([$iVersion=-1[,$iVendor=-1[,$hSessionID=-1]]])
; Parameters ....: $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _YMSG_Client_Ping($iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,0,'0012',1,$hSessionID)
	Return $sHeader
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_PagerPing
; Description ...: Creates the Pager Ping packet
; Syntax ........: _YMSG_Client_PagerPing($sAccountName[,$iVersion=-1[,$iVendor=-1[,$hSessionID=-1]]])
; Parameters ....: $sAccountName - The account name to use in the ping
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_PagerPing($sAccountName,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(0,$sAccountName)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'008A',0,$hSessionID)
	Return $sHeader&$sData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_ChatPing
; Description ...: Creates the Chat Ping packet
; Syntax ........: _YMSG_Client_ChatPing($sAlias[,$fSendUsername=true[,$iVersion=-1[,$iVendor=-1[,$hSessionID=-1]]]])
; Parameters ....: $sAlias - The Yahoo Chat alias to use in the ping
;                  $fSendUsername - If True, a username field is added which *may* boost chat session time
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_ChatPing($sAlias,$fSendUsername=true,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(109,$sAlias)
	If $fSendUsername Then $sData&=_YMSG_FieldCreate(1,$sAlias)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00A1',1,$hSessionID)
	Return $sHeader&$sData
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_HostProbe
; Description ...: Creates the client packet for a hostprobe - AKA handshake or server ping
; Syntax ........: _YMSG_Client_HostProbe($iVersion = -1[, $iVendor=-1[, $hSessionID = -1]])
; Parameters ....: $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_HostProbe($iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,0,'004C',1,$hSessionID)
	Return $sHeader
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_AuthRequest
; Description ...: Returns the client packet for a pager authentication request (YMSG16, preferably)
; Syntax ........: _YMSG_Client_AuthRequest($sAlias[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The alias to use during authentication
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_AuthRequest($sAlias,$iVersion=-1,$iVendor=-1,$hSessionID=-1)

	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0057',0,$hSessionID)
	Return $sHeader&$sData
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_AuthResponseWM
; Description ...: Creates the client packet for an pager authentication response (for Web Messenger?)
; Syntax ........: _YMSG_Client_AuthResponseWM($sAlias, $sYCookie, $sTCookie[, $sCountry = 'us'[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - Account alias to use during authentication
;                  $sYCookie - The value of the 'Y' Cookie
;                  $sTCookie - The value of the 'T' cookie
;                  $sCountry - The country abbreviation to use in authentication
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: This is the main function for the new "Cookie" Auth Login on YMSG
;                  |for use in conjunction with either ConfigLogin or PwToken functions which will get the required cookies.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_AuthResponseWM($sAlias,$sYCookie,$sTCookie,$sCountry='us',$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	If StringLeft($sYCookie,2)<>'Y=' Then $sYCookie='Y='&$sYCookie
	If StringLeft($sTCookie,2)<>'T=' Then $sTCookie='T='&$sTCookie
	If StringRight($sYCookie,1)<>';' Then $sYCookie&=';'
	If StringRight($sTCookie,1)<>';' Then $sTCookie&=';'
	Local $sData=_YMSG_FieldCreate(0,$sAlias)
	$sData&=_YMSG_FieldCreate(2,$sAlias)
	$sData&=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(244,16777215)
	$sData&=_YMSG_FieldCreate(6,$sYCookie&' '&$sTCookie)
	$sData&=_YMSG_FieldCreate(98,$sCountry)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0226',12,$hSessionID)
	Return $sHeader&$sData
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_AuthResponse
; Description ...: Returns the client packet for a pager authentication reponse
; Syntax ........: _YMSG_Client_AuthResponse($sAlias, $sYCookie, $sTCookie, $sAuthHash64[, $Country = 'us'[, $sYMVersion = -1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]]])
; Parameters ....: $sAlias - The alias to use during authentication
;                  $sYCookie - The value of the 'Y' cookie
;                  $sTCookie - The value of the 'T' cookie
;                  $sAuthHash64 - The Base64-encoded authentication hash of the crumb and challenge values.
;                  $Country - Country abbreviation
;                  $sYMVersion - The Yahoo Messenger version to use during authentication
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: See _YMSG_Auth16 for the inputs to this function
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_AuthResponse($sAlias,$sYCookie,$sTCookie,$sAuthHash64,$Country='us',$sYMVersion=-1,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	If $sYMVersion=-1 Then $sYMVersion=$_YMSG_YMVersion

	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(0,$sAlias)
	$sData&=_YMSG_FieldCreate(277,$sYCookie)
	$sData&=_YMSG_FieldCreate(278,$sTCookie)
	$sData&=_YMSG_FieldCreate(307,$sAuthHash64)
	$sData&=_YMSG_FieldCreate(244,16777215)
	$sData&=_YMSG_FieldCreate(2,$sAlias)
	$sData&=_YMSG_FieldCreate(2,1); I have no idea why this exists
	$sData&=_YMSG_FieldCreate(98,$Country)
	$sData&=_YMSG_FieldCreate(135,$sYMVersion)
	;$sData&=_YMSG_FieldCreate(148,300)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0054',12,$hSessionID)
	Return $sHeader&$sData
EndFunc



Func _YMSG_Client_SMS($sAlias,$sMobileNumber,$sCarrier,$sText,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(69,$sAlias)
	$sData&=_YMSG_FieldCreate(5,$sMobileNumber)
	$sData&=_YMSG_FieldCreate(68,$sCarrier)
	$sData&=_YMSG_FieldCreate(14,$sText)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'02EA',0,$hSessionID)
	Return $sHeader&$sData
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_VerifyContact
; Description ...: Returns the client packet for a buddy verification message (allow/deny buddy requests)
; Syntax ........: _YMSG_Client_VerifyContact($sAlias, $sBuddyAlias[, $iState = 1[, $sMessage = 'I have added you to my buddy list.'[, $iUsesUTF8 = 1[, $iUnk334 = 0[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sBuddyAlias - The alias of a potentional buddy
;                  $iState - If 1, the buddyrequest is accepted; if 2, a buddyrequests from the user is denied.
;                  $sMessage - The message to send to the potential buddy
;                  $iUsesUTF8 - If 1, the message is UTF-8 compatible; if 0 or 2, it is not.
;                  $iUnk334 - Unknown Flag or Switch
;                  $iService - The flag for the network which the destination user is logged into (see $_YMSG_PgrServices)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_VerifyContact($sAlias,$sBuddyAlias,$iState=1,$sMessage='I have added you to my buddy list.',$iUsesUTF8=1,$iUnk334=0,$iService=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(5,$sBuddyAlias)
	$sData&=_YMSG_FieldCreate(13,$iState)
	$sData&=_YMSG_FieldCreate(97,$iUsesUTF8)
	$sData&=_YMSG_FieldCreate(334,$iUnk334)
	$sData&=_YMSG_FieldCreate(14,$sMessage)
	If $iService<>0 Then $sData&=_YMSG_FieldCreate(241,$iService)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00D6',0,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_BuddyAdded
; Description ...: Returns the client packet for a Buddy Add (to be used in addition to VerifyContact)
; Syntax ........: _YMSG_Client_BuddyAdded($sAlias, $sBuddyAlias[, $sGroup = 'Yahoo'[, $sMessage = 'I have added you to my buddy list.'[, $iUsesUTF8 = 1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sBuddyAlias - The alias of the requested user or other party
;                  $sGroup - The existing buddylist group to add the user to
;                  $sMessage - The message to send to the user with the request
;                  $iUsesUTF8 - If 1, the message is UTF-8 compatible; if 0 or 2, it is not.
;                  $iService - The flag for the network which the destination user is logged into (see $_YMSG_PgrServices)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_BuddyAdded($sAlias,$sBuddyAlias,$sGroup='Yahoo',$sMessage='I have added you to my buddy list.',$iUsesUTF8=1,$iService=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(14,$sMessage);I have added you to my buddy list.|
	$sData&=_YMSG_FieldCreate(65,$sGroup)
	$sData&=_YMSG_FieldCreate(97,$iUsesUTF8)
	$sData&=_YMSG_FieldCreate(1,$sAlias)

	Local $sItemData=_YMSG_FieldCreate(7,$sBuddyAlias)
	If $iService<>0 Then $sItemData&=_YMSG_FieldCreate(241,$iService)
	$sData&=_YMSG_ListCreate(319,_YMSG_ItemCreate(319,$sItemData))

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0083',1,$hSessionID)
	Return $sHeader&$sData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_BuddyDeleted
; Description ...: Returns the client packet for buddy deletion
; Syntax ........: _YMSG_Client_BuddyDeleted($sAlias, $sBuddyAlias[, $sGroup = 'Yahoo'[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sBuddyAlias - The alias of the requested user or other party
;                  $sGroup - The name of an existing buddylist group
;                  $iService - The flag for the network which the destination user is logged into (see $_YMSG_PgrServices)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_BuddyDeleted($sAlias,$sBuddyAlias,$sGroup='Yahoo',$iService=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias);I have added you to my buddy list.|
	$sData&=_YMSG_FieldCreate(7,$sBuddyAlias)
	$sData&=_YMSG_FieldCreate(65,$sGroup)
	If $iService<>0 Then $sData&=_YMSG_FieldCreate(241,$iService)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0084',1,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_IgnoreUser
; Description ...: Returns the client packet to ignore a specific alias (max ~100)
; Syntax ........: _YMSG_Client_IgnoreUser($sAlias, $sToAlias[, $iState = 1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sToAlias - The alias of the requested user or other party
;                  $iState - If 1, the user is ignored, if 2, the user is unignored; 3 who knows (seen when following a spam report)
;                  $iService - The flag for the network which the destination user is logged into (see $_YMSG_PgrServices)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_IgnoreUser($sAlias,$sToAlias,$iState=1,$iService=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1); 1 ignore, 2 unignore
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(13,$iState)

	Local $sItemData=_YMSG_FieldCreate(7,$sToAlias)
	If $iService<>0 Then $sItemData&=_YMSG_FieldCreate(241,$iService)
	$sData&=_YMSG_ListCreate(319,_YMSG_ItemCreate(319,$sItemData))

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0085',1,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_AccountInfo
; Description ...: Returns the client packet for to request information pertaining to yahoo pager (eg: Buddies online, etc.)
; Syntax ........: _YMSG_Client_AccountInfo($sAlias[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_AccountInfo($sAlias,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0055',1,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_BudStatus
; Description ...: Returns the client packet to request the status of online buddies
; Syntax ........: _YMSG_Client_BudStatus($sAlias[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_BudStatus($sAlias,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(0,$sAlias)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'000A',1,$hSessionID)
	Return $sHeader&$sData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_Visible
; Description ...: Returns the client packet to set the visibility of the account on Yahoo pager
; Syntax ........: _YMSG_Client_Visible($iState = 1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $iState - Visibility flag; 1 is visible, 2 is invisible
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_Visible($iState=1,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(13,$iState); 2=invisible, 1=visible
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00C5',1,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_Away
; Description ...: Returns the client packet to set the away state of the current account
; Syntax ........: _YMSG_Client_Away($iAwayState = 0[, $sAwayText = ''[, $iAwayIcon = -1[, $iWebcam = -1[, $iUsesUTF8 = 1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]]]]])
; Parameters ....: $iAwayState - The numerical away-state (see $_YMSG_AwayStatus)
;                  $sAwayText - The away text to set, if the away-state permits text
;                  $iAwayIcon - The extended away-state, if the away-state requires it (eg: Custom Away)
;                  $iWebcam - Flag pertaining to webcam availability
;                  $iUsesUTF8 - If 1, the message is UTF-8 compatible; if 0 or 2, it is not.
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_Away($iAwayState=0,$sAwayText='',$iAwayIcon=-1,$iWebcam=-1,$iUsesUTF8=1,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(10,$iAwayState)
	If StringLen($sAwayText)>0 Then $sData&=_YMSG_FieldCreate(19,$sAwayText)
	If $iAwayIcon>-1 Then $sData&=_YMSG_FieldCreate(47,$iAwayIcon)
	If $iWebcam>-1 Then $sData&=_YMSG_FieldCreate(187,$iWebcam)
	$sData&=_YMSG_FieldCreate(97,$iUsesUTF8)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00C6',1,$hSessionID)
	Return $sHeader&$sData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_PictureRequest
; Description ...: Returns the client packet for buddy-image request
; Syntax ........: _YMSG_Client_PictureRequest($sAlias, $sToAlias[, $iState = 1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sToAlias - The alias of the requested user or destination
;                  $iState - Image request flag; One of the following values:
;                  |1 - for a request
;                  |2 - for a response
;                  |3 - unknown flag, seen from the receiver of a bad ImageURL
;                  $sImageURL - Image URL used in responses
;                  $iChecksum - Unknown integer value
;                  $iService - The flag for the network which the destination user is logged into (see $_YMSG_PgrServices)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_PictureRequest($sAlias,$sToAlias,$iState=1,$sImageURL='',$iChecksum=16777215,$iService=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(5,$sToAlias)
	$sData&=_YMSG_FieldCreate(13,$iState)
	If $iState=2 Then
		$sData&=_YMSG_FieldCreate(20,$sImageURL)
		$sData&=_YMSG_FieldCreate(192,$iChecksum)
	EndIf
	If $iService<>0 Then $sData&=_YMSG_FieldCreate(241,$iService)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00BE',1,$hSessionID)
	Return $sHeader&$sData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_PM
; Description ...: Returns the client packet for a private message to a user
; Syntax ........: _YMSG_Client_PM($sAlias, $sToAlias, $sPMText[, $iUsesUTF8 = 1[, $sIMVironment = ';0'[, $iPMExtra = 0[, $iService = 0[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sToAlias - The alias of the requested user or destination
;                  $sPMText - The message to send to the other user
;                  $iUsesUTF8 - If 1, the message is UTF-8 compatible; if 0 or 2, it is not.
;                  $sIMVironment - String identifying a Yahoo IMVironment for the message window.
;                  $iPMExtra - Unknown Flag or Extended data
;                  $iService - The flag for the network which the destination user is logged into (see $_YMSG_PgrServices)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_PM($sAlias,$sToAlias,$sPMText,$iUsesUTF8=1,$sIMVironment=';0',$iPMExtra=0,$iService=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(5,$sToAlias)
	$sData&=_YMSG_FieldCreate(97,$iUsesUTF8)
	$sData&=_YMSG_FieldCreate(63,$sIMVironment)
	$sData&=_YMSG_FieldCreate(64,$iPMExtra)
	$sData&=_YMSG_FieldCreate(206,1);???
	$sData&=_YMSG_FieldCreate(14,$sPMText)
	;$sData&=_YMSG_FieldCreate(429,'000000003D0A1531');???
	$sData&=_YMSG_FieldCreate(450,0);This is NOT a resent PM
	If $iService<>0 Then $sData&=_YMSG_FieldCreate(241,$iService)


	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0006',33,$hSessionID)
	Return $sHeader&$sData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_ChatLogout
; Description ...: Returns the client packet to end chat (but not pager)
; Syntax ........: _YMSG_Client_ChatLogout($sAlias[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_ChatLogout($sAlias,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	;$sData&=_YMSG_FieldCreate(1005,74349928); room time, we can't provide this yet.
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00A0',0,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_ChatLogin
; Description ...: Returns the client packet to start chat (required before joining)
; Syntax ........: _YMSG_Client_ChatLogin($sAlias[, $sAuth = 'abcde'[, $sCountry = 'us'[, $sYMVersion = -1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sAuth - Unknown string; almost always "abcde"
;                  $sCountry - Country abbreviation
;                  $sLanguage - Language code
;                  $sYMVersion - The Yahoo Messenger version to use; -1 is equivalent to $_YMSG_YMVersion
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_ChatLogin($sAlias,$sAuth='abcde',$sCountry='us',$sLanguage='en-US',$sYMVersion=-1,$iVersion=-1,$iVendor=-1,$hSessionID=-1); aka Preproom, for you YahELite users!
	If $sYMVersion=-1 Then $sYMVersion=$_YMSG_YMVersion

	Local	$sData =_YMSG_FieldCreate(109,$sAlias)
			$sData&=_YMSG_FieldCreate(1,$sAlias)
			$sData&=_YMSG_FieldCreate(6,$sAuth); not required - don't ask me why this is abcde
			$sData&=_YMSG_FieldCreate(98,$sCountry)
			$sData&=_YMSG_FieldCreate(445,$sLanguage)
			$sData&=_YMSG_FieldCreate(135,'ym'&$sYMVersion)

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0096',0,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_ChatJoin
; Description ...: Returns the client packet to request to join a specific room
; Syntax ........: _YMSG_Client_ChatJoin($sAlias, $sRoomName, $iRoomID[, $iMode = 0[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sRoomName - The name of the room to join
;                  $iRoomID - The ID number of the room to join (synonymous with the Name)
;                  $iMode - Unknown join flag,
;                  | 0 = normal?
;                  | 1 = indicates availability of a webcam
;                  | 2 = default for YM10 (seems to be the same as 0)
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_ChatJoin($sAlias,$sRoomName,$iRoomID,$iMode=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1); aka Preproom, for you YahELite users!
	;     Room:Number::RoomID       - for this function, RoomName=Room:Number

	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(104,$sRoomName);  Room:Number
	$sData&=_YMSG_FieldCreate(129,$iRoomID);    ####...
	$sData&=_YMSG_FieldCreate(62,$iMode)
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'0098',0,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_ChatLeave
; Description ...: Returns the client packet to leave a chat room
; Syntax ........: _YMSG_Client_ChatLeave($sAlias, $sRoomName, $iRoomID[, $iMode = 0[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sRoomName - The name of a room to leave ("Room:#")
;                  $iRoomID - The ID of the room to leave
;                  $iMode - Unknown room flag
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_ChatLeave($sAlias,$sRoomName,$iRoomID,$iMode=0,$iVersion=-1,$iVendor=-1,$hSessionID=-1); aka Preproom, for you YahELite users!

	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(109,$sAlias)
	$sData&=_YMSG_FieldCreate(62,$iMode); Join mode; 0 is a regular join, 1 joins the room as "webcam enabled"
	;     Room:Number::RoomID       - for this function, RoomName=Room:Number
	$sData&=_YMSG_FieldCreate(104,$sRoomName);  Room:Number
	$sData&=_YMSG_FieldCreate(129,$iRoomID);    ####...
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'009B',0,$hSessionID)
	Return $sHeader&$sData
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_ChatText
; Description ...: Returns the client packet to send text to the chatroom
; Syntax ........: _YMSG_Client_ChatText($sAlias, $sRoomName, $sChatText[, $iTextMode = 1[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sRoomName - The name of the room to send chat text to (Room:#)
;                  $sChatText - The message/text to send
;                  $iTextMode - A flag indicating what type of text this is: 1=Normal, 2=Emote, 3=Thought, ...=Reserved
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_Client_ChatText($sAlias,$sRoomName,$sChatText,$iTextMode=1,$iVersion=-1,$iVendor=-1,$hSessionID=-1); aka Preproom, for you YahELite users!
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(104,$sRoomName);  Room:Number
	$sData&=_YMSG_FieldCreate(117,$sChatText)
	$sData&=_YMSG_FieldCreate(124,$iTextMode);  1 is regular text, 2 is an emote, 3 is a thought [use ". o O ( %s )"]
	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00A8',0,$hSessionID)
	Return $sHeader&$sData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_StealthPerm
; Description ...: Returns a permanent stealth settings packet
; Syntax ........: _YMSG_Client_StealthPerm($sAlias, $i31Value, $i13Value, $vBuddies[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $i31Value - Unknown stealth flag
;                  $i13Value - Unknown stealth flag
;                  $vBuddies - Buddies to set stealth settings for. This variable can be an Array or String
;                  | Array - A 1-dimensional 0-based array of usernames is assumed, settings are applied to all usernames.
;                  | String - One username, settings are applied to just this user.
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _YMSG_Client_StealthPerm($sAlias,$i31Value,$i13Value,$vBuddies,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(31,$i31Value)
	$sData&=_YMSG_FieldCreate(13,$i13Value)

	Local $sListData=''
	If IsArray($vBuddies) Then
		For $i=0 To UBound($vBuddies)-1
			$sListData&=_YMSG_ItemCreate(319,_YMSG_FieldCreate(7,$vBuddies[$i]))
		Next
	Else
		$sListData=_YMSG_ItemCreate(319,_YMSG_FieldCreate(7,$vBuddies))
	EndIf
	$sData&=_YMSG_ListCreate(319,$sListData)

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00B9',0,$hSessionID)
	Return $sHeader&$sData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_StealthSess
; Description ...: Returns a session stealth settings packet
; Syntax ........: _YMSG_Client_StealthSess($sAlias, $i31Value, $i13Value, $vBuddies[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $i31Value - Unknown stealth flag
;                  $i13Value - Unknown stealth flag
;                  $vBuddies - Buddies to set stealth settings for. This variable can be an Array or String
;                  | Array - A 1-dimensional 0-based array of usernames is assumed, settings are applied to all usernames.
;                  | String - One username, settings are applied to just this user.
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _YMSG_Client_StealthSess($sAlias,$i31Value,$i13Value,$vBuddies,$iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(31,$i31Value)
	$sData&=_YMSG_FieldCreate(13,$i13Value)

	Local $sListData=''
	If IsArray($vBuddies) Then
		For $i=0 To UBound($vBuddies)-1
			$sListData&=_YMSG_ItemCreate(319,_YMSG_FieldCreate(7,$vBuddies[$i]))
		Next
	Else
		$sListData=_YMSG_ItemCreate(319,_YMSG_FieldCreate(7,$vBuddies))
	EndIf
	$sData&=_YMSG_ListCreate(319,$sListData)

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00BA',0,$hSessionID)
	Return $sHeader&$sData
EndFunc




; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_SpamReport
; Description ...: Returns a PM Spam Report packet
; Syntax ........: _YMSG_Client_SpamReport($sAlias, $sSpammer, $iTimestamp, $sSpamPMText, $sSpamPM252Value[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sSpammer - Username of the Spam message's sender.
;                  $iTimestamp - Unknown Timestamp. Probably eithe the time the spam was received.
;                  | NOTE: This is NOT the PM's timestamp field value! (in testing always about 10-20 after the PM timestamp)
;                  $sSpamPMText - Exact value of field 14 from the original spam PM.
;                  $sSpamPM252Value - Exact value of field 252 from the original spam PM.
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: Fields 270 and 13 in testing always had the specified values, so their purpose is not known
;                  In Testing, this packet was always followed with an ignore with state 3 (unknown); you can use the following:
;                  | _YMSG_Client_IgnoreUser($sAlias,$sSpammer,3, ...)
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _YMSG_Client_SpamReport($sAlias, $sSpammer, $iTimestamp, $sSpamPMText, $sSpamPM252Value, $iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(269,$sSpammer)
	$sData&=_YMSG_FieldCreate(15,$iTimestamp)
	$sData&=_YMSG_FieldCreate(270,1);Unknown, perhaps count of spammers or of spam?

	Local $sItemData=_YMSG_FieldCreate(14,$sSpamPMText)
	$sItemData&=_YMSG_FieldCreate(252,$sSpamPM252Value)
	$sItemData&=_YMSG_FieldCreate(13,2)
	$sData&=_YMSG_ListCreate(274,_YMSG_ItemCreate(274,$sItemData))

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00E0',0,$hSessionID)
	Return $sHeader&$sData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_Client_Acknowledge
; Description ...: Returns a PM Acknowledgement packet (prevents a duplicate from being received)
; Syntax ........: _YMSG_Client_Acknowledge($sAlias, $sAliasTo, $s430Value[, $i450Value=0[, $iVersion = -1[, $iVendor=-1[, $hSessionID = -1]]]])
; Parameters ....: $sAlias - The current logged-in account alias used in the session
;                  $sAliasTo - The username that sent the original PM
;                  $s430Value - The exact value from field 430 of the original PM.
;                  $i450Value - The exact value from field 450 of the original PM.
;                  | Note: Hopefully this is 0, since 1 indicates a resent PM
;                  $iVersion - YMSG Protocol version to use, -1 is equivalent to the value of $_YMSG_ProtocolVersion
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $hSessionID - YMSG Session ID, -1 is equivalent to the value of $_YMSG_SessionID
; Return values .: Returns a data string containing a YMSG Packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _YMSG_Client_Acknowledge($sAlias,$sAliasTo,$s430Value,$i450Value=0, $iVersion=-1,$iVendor=-1,$hSessionID=-1)
	Local $sData=_YMSG_FieldCreate(1,$sAlias)
	$sData&=_YMSG_FieldCreate(5,$sAliasTo)
	$sData&=_YMSG_FieldCreate(302,430)
		$sData&=_YMSG_FieldCreate(430,$s430Value)
	$sData&=_YMSG_FieldCreate(303,430)
	$sData&=_YMSG_FieldCreate(450,$i450Value)

	Local $sHeader
	_YMSG_HeaderCreate($sHeader,$iVersion,$iVendor,StringLen($sData),'00FB',0,$hSessionID)
	Return $sHeader&$sData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_FieldArrayCount
; Description ...: Counts matching fields in field/data array
; Syntax ........: _YMSG_FieldArrayCount(Byref $a, $field)
; Parameters ....: $a - An input field/data array
;                  $field - The field number to match
; Return values .: Success - Returns the number of occurrences for a field
;                  Failure - Returns 0
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_FieldArrayCount(Byref $a,$field)
	; counts the number of valid data fields with the corresponding field number
	Local $u=Ubound($a)-1
	Local $occur_x=0
	For $i=1 To $u Step 2
		If ($a[$i]==$field) And (($i+1)<=$u) Then $occur_x+=1
	Next
	Return $occur_x
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_FieldArrayGetValue
; Description ...: Retrieves the value of a matching field
; Syntax ........: _YMSG_FieldArrayGetValue(ByRef $aFields, $iField[, $iOccur = 1])
; Parameters ....: $aFields - An input field/data array
;                  $iField - The field number to match
;                  $iOccur - The occurrence of the field in the array to search for
; Return values .: Success - Returns the string value of a specific field
;                  Failure - Returns '' and sets @error=1; the field was not found.
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_FieldArrayGetValue(ByRef $aFields, $iField, $iOccur=1)
	Local $u=Ubound($aFields)-1
	Local $occur_x=1
	For $i=1 To $u Step 2
		If ($aFields[$i]==$iField) And (($i+1)<=$u) Then
			If $iOccur<=$occur_x Then
				SetError(0)
				Return $aFields[$i+1]
			EndIf
			$occur_x+=1
		EndIf
	Next
	SetError(1)
	Return ''
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_FieldsToArray
; Description ...: Outputs an array of fields/data from a the data section of a YMSG packet
; Syntax ........: _YMSG_FieldsToArray(ByRef $aFields, ByRef $dFields)
; Parameters ....: $aFields - The variable to hold the field/data array
;                  $dFields - The input data containing fields
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_FieldsToArray(ByRef $aFields,ByRef $dFields)
	$aFields=StringSplit($dFields,$_YMSG_FieldDelim,1)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ListCreate
; Description ...: Returns field data in the structure of a List
; Syntax ........: _YMSG_ListCreate($iList,$sItems)
; Parameters ....: $iList - the List identifier
;                  $sItems - field data composed soley of Items*
; Return values .: Returns a data string containing data fields
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: Lists are containers for several Items of the same type that are related.
;                  | (eg: BuddyStats List contains several BuddyInfo Items)
;                  Lists should only contain Items, uncontained fields are not allowed*
;
;                  * Lists can sometimes act as a container for Fields of the same type instead of Items;
;                  | but Lists of Fields and Lists of Items cannot be mixed
;                  YMSG Lists may bear resemblances to typed-Arrays.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ListCreate($iList,$sItems)
	Return 302&$_YMSG_FieldDelim&$iList&$_YMSG_FieldDelim & _
	$sItems & _
	303&$_YMSG_FieldDelim&$iList&$_YMSG_FieldDelim
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_ItemCreate
; Description ...: Returns field data in the structure of a Item
; Syntax ........: _YMSG_ItemCreate($iItem,$sFields)
; Parameters ....: $iItem - the ListItem identifier
;                  $sFields - field data to include in the Item.
; Return values .: Returns a data string containing data fields
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: Items are containers for fields that are related (eg: buddy information fields)
;                  | Items can contain any structure of fields, including other Items or even Lists
;                  YMSG Items may bear resemblances to Class Objects.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_ItemCreate($iItem,$sFields)
	Return 300&$_YMSG_FieldDelim&$iItem&$_YMSG_FieldDelim & _
	$sFields & _
	301&$_YMSG_FieldDelim&$iItem&$_YMSG_FieldDelim
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_FieldCreate
; Description ...: Returns the data representing one data field (for a packet's data section)
; Syntax ........: _YMSG_FieldCreate($iFieldNum, $sFieldData)
; Parameters ....: $iFieldNum - The field identifier to set data for
;                  $sFieldData - The value to set the chosen field to
; Return values .: Returns a data string containing a field with the set value
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_FieldCreate($iFieldNum,$sFieldData)
	Return $iFieldNum&$_YMSG_FieldDelim&$sFieldData&$_YMSG_FieldDelim
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_HeaderCreate
; Description ...: Outputs the data representing the header of a YMSG packet
; Syntax ........: _YMSG_HeaderCreate(Byref $sHeader[, $iVersion = 16[, iVendorID=0[, $iLength = 0[, $hType = 0[, $iStatus = 1[, $hSessionID = 0[, $fAllowGlobals = True]]]]]]])
; Parameters ....: $sHeader - The variable to hold the output data string containing a YMSG header
;                  $iVersion - YMSG Protocol version to use
;                  $iVendor - YMSG Protocol "Vendor ID" to use, -1 is equivalent to the Global value
;                  | generally unused except for protocol versions above 100
;                  $iLength - Length of the packet's data section in bytes
;                  $hType - Hex value representing the Packet Type
;                  $iStatus - The status value of the packet; 1 is "Normal"
;                  $hSessionID - Current session ID (set by the server during authentication)
;                  $fAllowGlobals - If True, the input-1 for the Version, VendorID and SessionID is replaced with corresponding
;                  | global variable values.
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: In usual circumstances (YMSG16 and lower), the VendorID is generally always 0.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_HeaderCreate(Byref $sHeader,$iVersion=16,$iVendorID=0,$iLength=0,$hType=0,$iStatus=0,$hSessionID=0,$fAllowGlobals=True)
	If $fAllowGlobals Then
		Global $_YMSG_ProtocolVersion, $_YMSG_VendorID, $_YMSG_SessionID
		If $iVersion=-1 Then $iVersion=$_YMSG_ProtocolVersion
		If $iVendorID=-1 Then $iVendorID=$_YMSG_VendorID
		If $hSessionID=-1 Then $hSessionID=$_YMSG_SessionID
	EndIf

	Local $stcPacket=DllStructCreate($_YMSG_tPacket)
	DllStructSetData($stcPacket,'sig','YMSG')
	DllStructSetData($stcPacket,'ver',Binary('0x'&Hex($iVersion,4))); I'd use Binary() alone, but I needed the prefixed 00's I guess - or the endianness is wrong
	DllStructSetData($stcPacket,'vid',Binary('0x'&Hex($iVendorID,4)))
	DllStructSetData($stcPacket,'len',Binary('0x'&Hex($iLength ,4)))
	DllStructSetData($stcPacket,'typ',Binary('0x'&Hex(Dec($hType),4)))
	DllStructSetData($stcPacket,'sta',Binary('0x'&Hex($iStatus,8)))
	DllStructSetData($stcPacket,'sid',Binary('0x'&Hex(Dec($hSessionID),8)))
	Local $stcHeader=DllStructCreate('byte[20]',DllStructGetPtr($stcPacket))
	$sHeader=BinaryToString(DllStructGetData($stcHeader,1))
	$stcHeader=0
	$stcPacket=0
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_PacketGetLen
; Description ...: Retrieve just the length of a packet's data section
; Syntax ........: _YMSG_PacketGetLen(ByRef $dPacket)
; Parameters ....: $dPacket - Variable containing the input YMSG packet or header
; Return values .: Returns the length, in bytes, for the data section of the YMSG packet
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: This function assumes that data represents a YMSG packet stats at the first byte of $dPacket
;                  | and ends before or at the last byte of $dPacket.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_PacketGetLen(ByRef $dPacket)
	Return Dec(StringTrimLeft(StringToBinary(StringMid($dPacket, 9, 2)), 2))
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_PacketToArray
; Description ...: Outputs an array representation of a YMSG packet
; Syntax ........: _YMSG_PacketToArray(ByRef $dPacket, ByRef $aPacket)
; Parameters ....: $dPacket - Variable containing the input packet data
;                  $aPacket - Variable to hold the output packet array
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: The valid packet is trimmed from $dPacket when you use this function.
;                  | ($dPacket will resultingly contain any remaining data)
;                  | This may allow you to retrieve the next packet more easily.
;                  This function assumes that the data which represents a YMSG packet starts at the first byte of $dPacket
;                  | and ends before or at the last byte of $dPacket.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_PacketToArray(ByRef $dPacket, ByRef $aPacket)
	; we're passing an array since I can't return a struct
	; because $stcPacket is at the same pointer as $stcHeader, closing either closes both
	; when the function ends $stcHeader gets closed thus closing $stcPacket :|
	; - even if we passed stcPacket ByRef or by Return - it still is closed when the function ends

	; $dPacket becomes any remaining data that is not a part of the packet's data length.
	Global $_YMSG_tPacketStruct
	Dim $aPacket[8]
	Local $stcHeader=DllStructCreate('byte[20]')
	;ConsoleWrite(_StringToHex(StringLeft($dPacket,20))&@CRLF)
	DllStructSetData($stcHeader,1,StringLeft($dPacket,20))
	$dPacket=StringTrimLeft($dPacket,20)
	Local $stcPacket=DllStructCreate($_YMSG_tPacket,DllStructGetPtr($stcHeader))
	$aPacket[0]=BinaryToString(DllStructGetData($stcPacket,'sig'))
	$aPacket[1]=Dec(StringTrimLeft(DllStructGetData($stcPacket,'ver'),2))
	$aPacket[2]=Dec(StringTrimLeft(DllStructGetData($stcPacket,'vid'),2))
	$aPacket[3]=Dec(StringTrimLeft(DllStructGetData($stcPacket,'len'),2))
	$aPacket[4]=StringTrimLeft(DllStructGetData($stcPacket,'typ'),2)
	$aPacket[5]=Dec(StringTrimLeft(DllStructGetData($stcPacket,'sta'),2))
	$aPacket[6]=StringTrimLeft(DllStructGetData($stcPacket,'sid'),2)
	$aPacket[7]=StringToBinary(StringLeft($dPacket,$aPacket[3]))
	$dPacket=StringTrimLeft($dPacket,$aPacket[3])
	$stcPacket=0
	$stcHeader=0
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _YMSG_PacketFromArray
; Description ...: Create a YMSG packet from its array representation
; Syntax ........: _YMSG_PacketFromArray(ByRef $aPacket, ByRef $sPacket)
; Parameters ....: $aPacket - Variable that holds the input YMSG packet array
;                  $sPacket - Variable to hold the output YMSG packet data
; Return values .: None
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _YMSG_PacketFromArray(ByRef $aPacket, ByRef $sPacket)
	$sPacket='0x'
	$sPacket&=StringTrimLeft(StringToBinary($aPacket[0]),2);4
	$sPacket&=Hex($aPacket[1],4);2
	$sPacket&=Hex($aPacket[2],4);2
	$sPacket&=Hex($aPacket[3],4);2
	$sPacket&=$aPacket[4];2
	$sPacket&=Hex($aPacket[5],8);2
	$sPacket&=$aPacket[6]
	$sPacket=BinaryToString(Binary($sPacket))&BinaryToString($aPacket[7])
EndFunc










;-------------some required functions
Func __YMSG_URL_GetArgs($URL)
	Local $p=StringInStr($URL,'?')
	If $p=0 Then Return ''
	Return StringMid($URL,$p+1)
EndFunc
Func __YMSG_URL_ArgsToArray($Args)
	Local $aArgStr=StringSplit($Args,'&')
	Local $numArgs=$aArgStr[0]
	Local $aArguments[$numArgs+1][2]
	$aArguments[0][0]=$numArgs
	For $i=1 To $numArgs
		Local $arr=StringSplit($aArgStr[$i]&'=','='); var=val= JIC
		If $arr[0]>=1 Then $aArguments[$i][0]=$arr[1]
		If $arr[0]>=2 Then $aArguments[$i][1]=$arr[2]
	Next
	Return $aArguments
EndFunc
Func __YMSG_URL_ArrayToArgs(ByRef $aArguments)
	Local $Args=''
	Local $numArgs=$aArguments[0][0]
	For $i=1 To $numArgs
		If StringLen($Args)>0 Then $Args&='&'
		If StringLen($aArguments[$i][0])>0 Then
			$Args&=$aArguments[$i][0]&'='&$aArguments[$i][1]
		EndIf
	Next
	Return $Args
EndFunc

Func __YMSG_URL_ArgArray_GetArg(ByRef $aArguments, $sName)
	Local $numArgs=$aArguments[0][0]
	For $i=1 To $numArgs
		If $aArguments[$i][0]==$sName Then Return $i
	Next
	Return -1
EndFunc
Func __YMSG_URL_ArgArray_SetArg(ByRef $aArguments, $sName, $vNewName=False, $vNewData=False)
	Local $numArgs=$aArguments[0][0]
	Local $iMod=-1
	For $i=1 To $numArgs
		If $aArguments[$i][0]==$sName Then $iMod=$i
	Next
	If $iMod>-1 Then
		If IsBool($vNewName)=0 Then $aArguments[$iMod][0]=$vNewName
		If IsBool($vNewData)=0 Then $aArguments[$iMod][1]=$vNewData
	EndIf
	Return $iMod
EndFunc




Func __YMSG_HTTPReq($Method='GET',$URL='http://example.com/',$Content='',$extraHeaders='')
	Local $aRet[4]
	$URL=StringTrimLeft($URL,StringInStr($URL,'://')+2)
	Local $pos=StringInStr($URL,'/')
	Local $HOST=StringLeft($URL,$pos-1)

	Local $PORT=80
	Local $pColon=StringInStr($HOST,':')
	If $pColon>0 Then
		$PORT=StringMid($HOST,$pColon+1)
		$HOST=StringLeft($HOST,$pColon-1)
	EndIf

	$URL=StringMid($URL,$pos)
	Local $HTTPRequest=$Method&' '&$URL&' HTTP/1.0'&@CRLF& _
	'Accept-Language: en'&@CRLF& _
	'Accept: */*'&@CRLF& _
	'Host: '&$HOST&@CRLF& _
	'Cache-Control: no-cache'&@CRLF& _
	'User-Agent: Mozilla/1.0'&@CRLF& _
	'Connection: close'&@CRLF& _
	'Accept-Encoding: '&@CRLF& _
	'Accept-Language: en'&@CRLF
	If StringLen($extraHeaders)>0 Then $HTTPRequest&=$extraHeaders
	If StringLen($Content)>0 Then
		$HTTPRequest&='Content-Length: '&StringLen($Content)&@CRLF
		$HTTPRequest&=@CRLF&$Content;&@CRLF
	Else
		$HTTPRequest&=@CRLF
	EndIf
	$aRet[0]=$HOST
	$aRet[1]=$URL; now a URI
	$aRet[2]=$HTTPRequest
	$aRet[3]=$PORT
	Return $aRet
EndFunc
Func __YMSG_HTTPTransfer(ByRef $aReq, Byref $sRecv_Out)
	ConsoleWrite($aReq[2]&@CRLF)
	Local $sock=TCPConnect(TCPNameToIP($aReq[0]),$aReq[3])
	ConsoleWrite('HTTPSock: '&$aReq[0]&'//'&$aReq[3]&'//'&$sock&'//'&@error&@CRLF)
	TCPSend($sock,$aReq[2])
	$sRecv_Out=""
	While $sock<>-1
		Local $recv=TCPRecv($sock,10000,1)
		Local $error=@error
		If IsBinary($recv) Then $recv=BinaryToString($recv)
		$sRecv_Out&=$recv
		If $error<>0 Then
			TCPCloseSocket($sock)
			$sock=-1
			ExitLoop
		EndIf
		;Sleep(50)
	WEnd
	ConsoleWrite('HTTPSockError: '&$error&@CRLF)
EndFunc



; Thanks Progandy
Func _URIEncode($sData)
    ; Prog@ndy
    Local $aData = StringSplit(BinaryToString(StringToBinary($sData,4),1),"")
    Local $nChar
    $sData=""
    For $i = 1 To $aData[0]
        $nChar = Asc($aData[$i])
        Switch $nChar
            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $sData &= $aData[$i]
            Case 32
                $sData &= "+"
            Case Else
                $sData &= "%" & Hex($nChar,2)
        EndSwitch
    Next
    Return $sData
EndFunc







Func __YMSG_toBinary(Byref $var)
	If Not IsBinary($var) Then
		If StringLeft(String($var),2)='0x' Then
			;ConsoleWrite(' - - Processed Binary String'&@CRLF)
			$var=Binary($var)
		Else
			;ConsoleWrite(' - - Converted string to Binary.'&@CRLF)
			$var=StringToBinary($var)
		EndIf
	Else
		If StringLeft(String($var),7)='0x30783' Then
			;ConsoleWrite(' - - Binary of a binary string, to binary.'&@CRLF)
			$var=Binary(BinaryToString($var))
		EndIf
	EndIf
EndFunc


Func __atoa($sIntegerA,$sCharsetA,$sCharsetB,$iCaseSense=0); changes an integer in one set to a different set
	Local $i=__atoi($sIntegerA,$sCharsetA,$iCaseSense)
	If @error<>0 Then Return SetError(@error,1,'')
	Local $s=__itoa($i,$sCharsetB)
	Return SetError(@error,0,$s)
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: __itoa
; Description ...: Converts an integer to a string representation of the absolute value in a different number system
; Syntax ........: __itoa($iInteger[,$vCharset='0123456789'[,$fOutputString=True]])
; Parameters ....: $iInteger - Integer value to convert
;                  $vCharset - String or 0-based Array containing the digits in the number system to convert to
;                  $fOutputString - Determines whether the output is a string or 0-based Digit array.
; Return values .: Success -
;                  | Returns a string of digits from the chosen number system, if fOutputString is True
;                  | Returns a 0-based Array of digits from the chosen number system, if fOutputString is False
;                  Failure - Returns "" and sets @error to:
;                  |@error = 1 : Charset too short (2 characters minimum required)
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: This function assumes the Most-significant digit on the output is always on the left.
;                  This function assumes that the character-set given goes from least to greatest in value,
;                  | with the first character at value 0.
;                  If the value of the input is zero, the first digit of the given character set is output.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func __itoa($iInteger,$vCharset='0123456789',$fOutputString=True); NOTE: this function assumes the Most-significant char is on the left!
	Local $iCharsetStart=0
	If IsArray($vCharset)=0 Then
		$vCharset=StringSplit($vCharset,'')
		$iCharsetStart=1
	EndIf
	Local $iCharsetLen=UBound($vCharset)
	Local $iCharsetRadix=$iCharSetLen-$iCharsetStart
	If $iCharsetRadix<2 Then Return SetError(1,0,'')
	If $iInteger<0 Then $iInteger=-$iInteger;make iInteger positive, not sure if this is faster than just ABS'ing it.

	Local $sInteger=''
	Local $aInteger[1]=[0]
	Local $iArrayDim=1
	Do
		Local $remainder=Mod($iInteger,$iCharsetRadix)
		$iInteger=Int($iInteger/$iCharsetRadix)

		;If ($remainder+$iCharsetStart)<0 Or ($remainder+$iCharsetStart)>($iCharsetLen-1) Then
		;	MsgBox(0,$remainder&'/'&$iCharsetLen,'F('&$iInteger&','&$vCharset&','&$fOutputString&')')
		;EndIf

		Local $sDigit=$vCharset[$remainder+$iCharsetStart]

		If $fOutputString Then
			;prepend digits
			$sInteger=$sDigit&$sInteger
		Else
			;there's no great way to prepend an array, so lets append and reverse later
			If $iArrayDim>1 Then ReDim $aInteger[$iArrayDim]
			$aInteger[$iArrayDim-1]=$sDigit
			$iArrayDim+=1
		EndIf
	Until $iInteger=0

	If $fOutputString Then
		If StringLen($sInteger)<1 Then $sInteger=$iCharsetStart[$iCharsetStart]
		Return $sInteger
	Else
		_ArrayReverse($aInteger)
		Return $aInteger
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: __atoi
; Description ...: Converts an absolute value in a different number system to an integer
; Syntax ........: __atoi($vInteger,$vCharset[,$iCaseSense=0])
; Parameters ....: $vInteger - The integer made of digits represented by the given character set (String or 0-based Digit Array)
;                  $vCharset - The character set of the number system for the given value (String or 0-based Digit Array)
; Return values .: Success - Returns an integer value converted from the given string
;                  Failure - Returns 0 and sets @error to:
;                  |@error = 1 : Charset too short (2 characters minimum required)
;                  |@error = 2 : Character not found in Charset (invalid input string); @extended is set to the ASCII value.
; Author ........: Crash Daemonicus (crashdemons)
; Modified ......:
; Remarks .......: This function assumes the Most-significant digit on the output is always on the left.
;                  This function assumes that the character-set given goes from least to greatest in value,
;                  | with the first character at value 0.
;                  If you want to convert a multi-character-digit system to a number, you MUST input vInteger as an array,
;                  | otherwise it is assumed to be single-character-digit number.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __atoi($vInteger,$vCharset,$iCaseSense=0); NOTE: this function assumes the Most-significant char is on the left!
	Local $iInteger=0,$iIntegerStart=0,$iCharsetStart=0
	If IsArray($vInteger)=0 Then
		$vInteger=StringSplit($vInteger,'')
		$iIntegerStart=1
	EndIf
	If IsArray($vCharset)=0 Then
		$vCharset=StringSplit($vCharset,'')
		$iCharsetStart=1
	EndIf
	Local $iIntegerLen=UBound($vInteger)
	Local $iCharsetLen=UBound($vCharset)
	Local $iIntegerMax=$iIntegerLen-1
	Local $iCharsetRadix=$iCharSetLen-$iCharsetStart
	If $iCharsetRadix<2 Then Return SetError(1,0,0); array does not have 2 entries from start position

	For $i=$iIntegerStart To $iIntegerMax
		Local $iPower=$iIntegerMax-$i
		Local $cIntChar=$vInteger[$i]
		Local $iCharVal=_ArraySearch($vCharset,$cIntChar,$iCharsetStart,0,$iCaseSense)-$iCharsetStart
		If $iCharVal<0 Then Return SetError(2,Asc($cIntChar),0); would only happen if part of sInt isn't in the Charset
		Local $iValue=$iCharVal*($iCharsetRadix^$iPower)
		$iInteger+=$iValue
	Next
	Return $iInteger
EndFunc
