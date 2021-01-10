#include <WinHTTP.au3>

$WINHTTP_STATUS_CALLBACK = DllCallbackRegister("WINHTTP_STATUS_CALLBACK","int","hwnd;ulong_ptr;dword;ptr;dword")

; CALLBACK function
Func WINHTTP_STATUS_CALLBACK($hInternet, $dwContext, $dwInternetStatus, $lpvStatusInformation, $dwStatusInformationLength)
	MsgBox(0, '', "StatusCallback called")
EndFunc

	;// Use WinHttpOpen to obtain an HINTERNET handle.
$hSession = _WinHTTPOpen("A WinHTTP Example Program/1.0", _
					$WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, _
					$WINHTTP_NO_PROXY_NAME, _
					$WINHTTP_NO_PROXY_BYPASS, 0);
if ($hSession) Then
	;// Install the status callback function.
	$isCallback =  _WinHttpSetStatusCallback( $hSession, _
						DllCallbackGetPtr($WINHTTP_STATUS_CALLBACK), _
						$WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS);

	;// Place additional code here.
    
	;// When finished, release the HINTERNET handle.
	_WinHttpCloseHandle($hSession);
else
	MsgBox(0, '', "error on HttpOpen")
EndIf
	
Func _WinHttpSetStatusCallback($hInternet,$lpfnInternetCallback,$dwNotificationFlags)
	Local $setStatusCallback = DllCall("Winhttp.dll","ptr","WinHttpSetStatusCallback","hwnd",$hInternet,"ptr",$lpfnInternetCallback,"dword",$dwNotificationFlags,"ptr",0)
	If @error Then Return SetError(1,0,$WINHTTP_INVALID_STATUS_CALLBACK)
	Return $setStatusCallback[0]
EndFunc