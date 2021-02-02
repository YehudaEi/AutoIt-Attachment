#include-once


; #LICENSE# =======================================================================================================================
;           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;                   Version 2, December 2004
;
; Copyright (C) 2004 Sam Hocevar
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




;Modified 6:47 PM 7/18/2009 made MsgBox for WinHTTP errors conditional
;Modified 4:58 AM 6/5/2009 to make variable names less conflicting - _WinHTTP_Startup has a parameter to NOT set the error-handler.
;Modified 3:56 PM 5/22/2009 to supress Au3Check warnings
;Modified 10:49 AM 5/15/2009 to have a manual setting to ignore WinHTTP Shutdown calls.
;Modified 1:40 AM 5/8/2009 to not try to re-initialize in _Startup() if objects already exist.
Global Const $_WinHTTP_LibVer='1.6'
Global $_WinHTTP_StayEnabled=False
Global $_WinHTTP_UseDefaultErrorHandler=True
Global $_WinHTTP_ShowErrorMessage=True
Global $_WinHTTP_oErrorHandler,$_WinHTTP_oRequest,$_WinHTTP_oAdodb,$_WinHTTP_Error

;used just for error messages/etc.
Global $_WinHTTP_Stage
Global $_WinHTTP_Request


Func _WinHTTP_Startup()
	Global $_WinHTTP_oErrorHandler,$_WinHTTP_oRequest,$_WinHTTP_oAdodb,$_WinHTTP_Error
	If Not IsObj($_WinHTTP_oRequest) Then
		$_WinHTTP_oRequest = ObjCreate("winhttp.winhttprequest.5.1")
		If @error Then
			MsgBox(0,'WinHTTP Error', 'There was an error initializing the WinHTTPRequest object. ')
			Return _WinHTTP_Shutdown()
		EndIf
	EndIf
	If Not IsObj($_WinHTTP_oAdodb) Then
		$_WinHTTP_oAdodb = ObjCreate("ADODB.Stream")
		If @error Then
			MsgBox(0,'WinHTTP Error', 'There was an error initializing the ADODB.Stream object. ')
			Return _WinHTTP_Shutdown()
		EndIf
	EndIf
	If $_WinHTTP_UseDefaultErrorHandler Then
		If Not IsObj($_WinHTTP_oErrorHandler) Then
			$_WinHTTP_oErrorHandler = ObjEvent("AutoIt.Error","_WinHTTP_Error")
			If @error Then
				MsgBox(0,'WinHTTP Error', 'There was an error initializing the Error handler. ')
				Return _WinHTTP_Shutdown()
			EndIf
		EndIf
	EndIf
	$_WinHTTP_Error=0
EndFunc
Func _WinHTTP_Shutdown()
	Global $_WinHTTP_oErrorHandler,$_WinHTTP_oRequest,$_WinHTTP_oAdodb,$_WinHTTP_Error,$_WinHTTP_StayEnabled
	If $_WinHTTP_StayEnabled Then Return
	$_WinHTTP_oErrorHandler=0
	$_WinHTTP_oRequest=0
	$_WinHTTP_oAdodb=0
	$_WinHTTP_Error=0
EndFunc
Func _WinHTTP_Request($method='GET',$URL='http://www.example.com/',$Content='',$File='',$aHeaders=0)
	Global $_WinHTTP_Error
	$_WinHTTP_Error=0

	Local $bDelete=False
	$method=StringUpper($method)
	If $method='GET' Then $Content=''; GET requests won't have content data.
	If StringLen($File)<1 Then
		$File=@ScriptDir&'\WinHTTP.TMP'
		$bDelete=True
	EndIf
	If Not (IsObj($_WinHTTP_oRequest) And IsObj($_WinHTTP_oAdodb)) Then Return ''
	$_WinHTTP_Request=@CRLF&'Request: '&$method&' '&$URL&@CRLF&$Content&@CRLF&'Temp: '&$File
	$_WinHTTP_Stage='WinHTTPRequest.Open('&$method&', '&$URL&', False)'
	$_WinHTTP_oRequest.Open($method, $URL, False)
	If _WinHTTP_GetError() Then Return ''

	If IsArray($aHeaders) Then
		For $i=0 To UBound($aHeaders)-1
			$_WinHTTP_Request&=@CRLF&'Header: '&$aHeaders[$i][0]&'='&$aHeaders[$i][1]
			$_WinHTTP_Stage='WinHTTPRequest.SetRequestHeader('&$aHeaders[$i][0]&','&$aHeaders[$i][1]&')'
			$_WinHTTP_oRequest.SetRequestHeader($aHeaders[$i][0],$aHeaders[$i][1])
			If _WinHTTP_GetError() Then Return ''
		Next
	EndIf

	$_WinHTTP_Stage='WinHTTPRequest.Send('&$Content&')'
	$_WinHTTP_oRequest.Send($Content)
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Type=1'
	$_WinHTTP_oAdodb.Type=1
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Open'
	$_WinHTTP_oAdodb.Open
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Write($_WinHTTP_oRequest.ResponseBody)'
	$_WinHTTP_oAdodb.Write($_WinHTTP_oRequest.ResponseBody)
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.SaveToFile('&$File&', 2)'
	$_WinHTTP_oAdodb.SaveToFile($File, 2)
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Close'
	$_WinHTTP_oAdodb.Close
	If _WinHTTP_GetError() Then Return ''
	Local $data=FileReadFull($File)
	If $bDelete Then
		;ConsoleWrite('WinHTTP DeleteTemp'&@CRLF)
		FileDelete($File)
	EndIf
	$_WinHTTP_Request=''
	Return $data
EndFunc
Func _WinHTTP_RequestAll($method='GET',$URL='http://www.example.com/',$Content='',$File='',$aHeaders=0)
	Global $_WinHTTP_Error
	$_WinHTTP_Error=0
	Local $bDelete=False
	$method=StringUpper($method)
	If $method='GET' Then $Content=''; GET requests can't have content data.
	If StringLen($File)<1 Then
		$File=@ScriptDir&'\WinHTTP.TMP'
		$bDelete=True
	EndIf
	If Not (IsObj($_WinHTTP_oRequest) And IsObj($_WinHTTP_oAdodb)) Then Return ''
	$_WinHTTP_Request=@CRLF&'Request: '&$method&' '&$URL&@CRLF&$Content&@CRLF&'Temp: '&$File
	$_WinHTTP_Stage='WinHTTPRequest.Open('&$method&', '&$URL&', False)'
	$_WinHTTP_oRequest.Open($method, $URL, False)
	If _WinHTTP_GetError() Then Return ''

	If IsArray($aHeaders) Then
		For $i=0 To UBound($aHeaders)-1
			$_WinHTTP_Request&=@CRLF&'Header: '&$aHeaders[$i][0]&'='&$aHeaders[$i][1];$req
			$_WinHTTP_Stage='WinHTTPRequest.SetRequestHeader('&$aHeaders[$i][0]&','&$aHeaders[$i][1]&')'
			$_WinHTTP_oRequest.SetRequestHeader($aHeaders[$i][0],$aHeaders[$i][1])
			If _WinHTTP_GetError() Then Return ''
		Next
	EndIf
	$_WinHTTP_Stage='WinHTTPRequest.Send('&$Content&')'
	$_WinHTTP_oRequest.Send($Content)
	If _WinHTTP_GetError() Then Return ''
	Local $aRet[2]=['','']
	$_WinHTTP_Stage='WinHTTPRequest.GetAllResponseHeaders()'
	$aRet[0]=$_WinHTTP_oRequest.GetAllResponseHeaders()
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Type=1'
	$_WinHTTP_oAdodb.Type=1
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Open'
	$_WinHTTP_oAdodb.Open
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Write($_WinHTTP_oRequest.ResponseBody)'
	$_WinHTTP_oAdodb.Write($_WinHTTP_oRequest.ResponseBody)
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.SaveToFile('&$File&', 2)'
	$_WinHTTP_oAdodb.SaveToFile($File, 2)
	If _WinHTTP_GetError() Then Return ''
	$_WinHTTP_Stage='ADODB.Close'
	$_WinHTTP_oAdodb.Close
	If _WinHTTP_GetError() Then Return ''
	$aRet[1]=FileReadFull($File)
	If $bDelete Then
		;ConsoleWrite('WinHTTP DeleteTemp'&@CRLF)
		FileDelete($File)
	EndIf
	$_WinHTTP_Stage=''
	Return $aRet
EndFunc
Func _WinHTTP_GetError()
	Global $_WinHTTP_Error, $_WinHTTP_ErrorDesc
	Local $req='Stage: '&$_WinHTTP_Stage&$_WinHTTP_Request
	Local $tmp=$_WinHTTP_Error
	If $tmp<>0 Then
		If $_WinHTTP_ShowErrorMessage Then MsgBox(0,'WinHTTP Error: '&$tmp,$_WinHTTP_ErrorDesc&@CRLF&'_______________________________________'&@CRLF&$req)
		$_WinHTTP_ErrorDesc=''
		$_WinHTTP_Error=0; clear the error
	EndIf
	Return $tmp
EndFunc
Func _WinHTTP_Error()
	Global $_WinHTTP_oErrorHandler,$_WinHTTP_oRequest,$_WinHTTP_oAdodb
	Global $_WinHTTP_Error,$_WinHTTP_ErrorDesc
	If Not IsObj($_WinHTTP_oErrorHandler) Then Return MsgBox(0,'Error Handler','Funnily enough, the error handler has encountered an error!'&@CRLF&'The error handler expects $_WinHTTP_oErrorHandler to be an object, which it is not.')
	Local $errtxt="!> We intercepted a COM Error !"      & @CRLF  & @CRLF & _
			 "!>    err.description is: "    & @TAB & $_WinHTTP_oErrorHandler.description    & @CRLF & _
			 "!>    err.windescription:"     & @TAB & $_WinHTTP_oErrorHandler.windescription & @CRLF & _
			 "!>    err.number is: "         & @TAB & hex($_WinHTTP_oErrorHandler.number,8)  & @CRLF & _
			 "!>    err.lastdllerror is: "   & @TAB & $_WinHTTP_oErrorHandler.lastdllerror   & @CRLF & _
			 "!>    err.scriptline is: "     & @TAB & $_WinHTTP_oErrorHandler.scriptline     & @CRLF & _
			 "!>    err.source is: "         & @TAB & $_WinHTTP_oErrorHandler.source         & @CRLF & _
			 "!>    err.helpfile is: "       & @TAB & $_WinHTTP_oErrorHandler.helpfile       & @CRLF & _
			 "!>    err.helpcontext is: "    & @TAB & $_WinHTTP_oErrorHandler.helpcontext  & @CRLF
	;ConsoleWrite($errtxt)
	$_WinHTTP_ErrorDesc=$_WinHTTP_oErrorHandler.description&@CRLF&$_WinHTTP_oErrorHandler.windescription
	$_WinHTTP_Error=1
EndFunc





Func FileReadFull($file)
	$fh = FileOpen($file, 16)
	;If $fh=-1 Then Return $fh
	$d = BinaryToString(FileRead($fh))
	FileClose($fh)
	Return $d
EndFunc   ;==>FileReadFull
