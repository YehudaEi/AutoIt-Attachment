#include-once

; #FUNCTION# ;===============================================================================
;
; Name...........: _GoogleAuth
; Description ...: Authenticates with Google Apps and returns Authentication token
; Syntax.........: _GoogleAuth($sUser, $sPassword, $sService)
; Parameters ....: $sUser      - Full google username. This is either "username@gmail.com" for gmail users or "username@domain.com" for apps users.
;                  $sPassword  - Case sensitive password of the google account.
;				   $sService   - Google Service Code, one of the following:
;				   | Calendar Data API				= "cl"
;				   | Google Base Data API			= "gbase"
;				   | Blogger Data API				= "blogger"
;				   | Contacts Data API				= "cp"
;				   | Documents List Data API		= "writely"
;				   | Picasa Web Albums Data API		= "lh2"
;				   | Google Apps Provisioning API	= "apps"
;				   | Spreadsheets Data API			= "wise"
;				   | YouTube Data API				= "youtube" 
; Return values .: Success - Authentication token
;                  Failure - Returns 0 and Sets @Error:
;                  |1 - Bad Authentication 	(User or Password incorrect)
;                  |2 - Not Verified		(Google account has to be verified online)
;                  |3 - Terms Not Agreed	(User has not yet agreed to the terms)
;                  |4 - Captcha Required	(Captcha is required) 
;                  |5 - Account Deleted		(The specified user existed, but not anymore)
;                  |6 - Account Disabled	(Account is disabled)
;                  |7 - Service Disabled	(Service is disabled for this user)
;                  |8 - Service Unavailable	(Service is temporary unavailable)
;                  |9 - Other Error			(Unspecified)
; Author ........: O.K. de Wit
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........; http://code.google.com/intl/nl-NL/apis/accounts/docs/AuthForInstalledApps.html
; Example .......; Yes
;
; ;==========================================================================================

Func _GoogleAuth($sUser,$sPassword,$sService)
	$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
	$sUrl = "https://www.google.com/accounts/ClientLogin"
	$PostData = "accountType=HOSTED_OR_GOOGLE&Email="&$sUser&"&Passwd="&$sPassword&"&service="&$sService&"&source=AutoIT-App-1.0"
	$oHttpRequest = ObjCreate("WinHttp.WinHttpRequest.5.1")
	$oHttpRequest.Option(4) = 13056
	$oHttpRequest.Open ("POST", $sUrl, False)
	$oHttpRequest.setRequestHeader  ("Content-Type", "application/x-www-form-urlencoded")
	$oHttpRequest.Send ($PostData)
	$Response = $oHttpRequest.ResponseText
	$oHttpRequest = ""
	Switch $Response 
	Case "Error=BadAuthentication"&@LF
		SetError(1)
		Return
	Case "Error=NotVerified"&@LF 
		SetError(2)
		Return
	Case "Error=TermsNotAgreed"&@LF 
		SetError(3)
		Return
	Case "Error=CaptchaRequired"&@LF 
		SetError(4)
		Return
	Case "Error=AccountDeleted"&@LF 
		SetError(5)
		Return
	Case "Error=AccountDisabled"&@LF 
		SetError(6)
		Return
	Case "Error=ServiceDisabled"&@LF 
		SetError(7)
		Return
	Case "Error=ServiceUnavailable"&@LF 
		SetError(8)
		Return	
	EndSwitch
	If StringLeft($Response,4) = "SID=" Then
		Return StringTrimLeft($Response,StringInStr($Response,"Auth=")+4)
	Else
		SetError(9)
		Return
	EndIf	
EndFunc

Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    ConsoleWrite("COM Error: " & $HexNumber & " ScriptLine: " & $oMyError.scriptline & " Description: " & $oMyError.description & @LF)
    SetError(9)
    Return
EndFunc