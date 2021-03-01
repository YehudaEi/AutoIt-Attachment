#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPI.au3>
#include "WinHttp.au3"

Global $localfritzbox_ip_or_name = "fritz.box"
Global $password = "test";as set in your fritzbox
Global $local_config_port = 80

Global $enable_remote_config = true
Global $remotefritzbox_ip_or_name = "fritz.box"
Global $remote_config_user = "tester";must be set to on in the fritzbox webinterface and username and password mus be set
Global $remote_config_password = "test"
Global $remote_config_port = 443

Global $port = $INTERNET_DEFAULT_HTTP_PORT
Global $fritzbox_ip_or_name = ""

If $enable_remote_config = True Then
    $port = $remote_config_port
    $fritzbox_ip_or_name = $remotefritzbox_ip_or_name
Else
    $port = $local_config_port
    $fritzbox_ip_or_name = $localfritzbox_ip_or_name
EndIf

Global $hOpen = _WinHttpOpen()
If $enable_remote_config = True Then
    ;handle invalid ssl cerificate used by fritzbox
    _WinHttpSetOption($hOpen, $WINHTTP_OPTION_SECURITY_FLAGS, BitOR($SECURITY_FLAG_IGNORE_CERT_CN_INVALID, $SECURITY_FLAG_IGNORE_UNKNOWN_CA))
EndIf

Global $hConnect = _WinHttpConnect($hOpen, $fritzbox_ip_or_name, $port)

If @error Or $hConnect = 0 Then
    MsgBox(0, "Error", "can not connect")
    Exit
EndIf

If $enable_remote_config = True Then;when ssl is used add flag
    $hRequest = _WinHttpOpenRequest($hConnect, Default, '/cgi-bin/webcm?getpage=../html/login_sid.xml', Default, Default, Default, BitOR($WINHTTP_FLAG_SECURE, $WINHTTP_FLAG_ESCAPE_DISABLE))
Else
    $hRequest = _WinHttpOpenRequest($hConnect, Default, '/cgi-bin/webcm?getpage=../html/login_sid.xml')
EndIf
If @error Or $hRequest = 0 Then
    MsgBox(0, "Error", "_WinHttpOpenRequest failed")
    Exit
EndIf

$scResult = _WinHttpSetCredentials($hRequest, $WINHTTP_AUTH_TARGET_SERVER, $WINHTTP_AUTH_SCHEME_BASIC, $remote_config_user, $remote_config_password)
If @error Or $scResult = 0 Then
    MsgBox(0, "Error", "_WinHttpQueryHeaders failed")
    Exit
EndIf

$srResult = _WinHttpSendRequest($hRequest)
If @error Or $srResult = 0 Then
    MsgBox(0, "Error", "_WinHttpSendRequest failed")
    Exit
EndIf

$RecResResult=_WinHttpReceiveResponse($hRequest)
If @error Or $RecResResult = 0 Then
    MsgBox(0, "Error", "_WinHttpReceiveResponse failed")
    Exit
EndIf

$result = _WinHttpReadData($hRequest)

_WinHttpCloseHandle($hRequest)
If StringInStr($result, "<SessionInfo>") <> 0 Then;seems ok
    MsgBox(0, "OK", "<SessionInfo> found")
Else;info is missing
    MsgBox(0, "Error", "<SessionInfo> not found")
EndIf
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)
Exit 0