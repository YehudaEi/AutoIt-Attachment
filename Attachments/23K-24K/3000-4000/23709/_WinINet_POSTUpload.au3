#Include <WinINet.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinINet_POSTUpload
; Description ...: Upload files via POST
; Syntax ........: _WinINet_POSTUpload($sFile, $sFieldName, $sHost, $sPath[, $iPort = 0[, $sUser = Default[, $sPass = Default]]])
; Parameters ....: $sFile      - The file to upload
;                  $sFieldName - The form field the server expects
;                  $sHost      - The host to upload to
;                  $sPath      - The path on the host
;                  $iPort      - [optional] The port the host is on
;                  $sUser      - [optional] The login username (basic HTTP auth only)
;                  $sPass      - [optional] The login password (basic HTTP auth only)
; Return values .: Success - The server response
;                  Failure - "", sets @error to:
;                  |1 - File not found
;                  |2 - Could not start WinINet
;                  |3 - Could not open a connection
;                  |4 - Could not connect to the server
;                  |5 - Could not initiate a request
;                  |6 - Could not send request
;                  |7 - Server did not accept the file
;                  |8 - Could not read server response
; Author ........: Ultima
; Modified.......:
; Remarks .......: This is a crude example of how to upload via POST.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinINet_POSTUpload($asFormData, $asFiles, $sHost, $sPath, $iPort = 0, $sUser = Default, $sPass = Default)
	; Generate boundary
	Local $sBoundary
	For $i = 0 To 20
		$sBoundary &= Chr(Random(32, 126, 1))
	Next

	; Build form data
	Local $sFormDataTemplate = "--" & $sBoundary & @CRLF & 'Content-Disposition: form-data; name="%s"'
	Local $sFormData

	For $i = 0 To UBound($asFormData) - 1
		$sFormData &= StringFormat($sFormDataTemplate, $asFormData[$i][0]) & @CRLF & @CRLF & $asFormData[$i][1] & @CRLF
	Next
	
	; Build file data
	Local $sFileTemplate = $sFormDataTemplate & '; filename="%s"' & @CRLF & 'Content-Type: application/octet-stream'
	Local $sFile, $bFiles = Binary('')
	Local $hFile, $bFileData
	For $i = 0 To UBound($asFiles) - 1
		If Not FileExists($asFiles[$i][1]) Then ContinueLoop

		; Read the file
		$hFile = FileOpen($asFiles[$i][1], 16)
		$bFileData = FileRead($hFile)
		FileClose($hFile)

		; Add to the file data blob
		$sFile = StringFormat($sFileTemplate, $asFiles[$i][0], $asFiles[$i][1]) & @CRLF & @CRLF
		$bFiles &= StringToBinary($sFile) & $bFileData & StringToBinary(@CRLF)
	Next
	$bFiles &= StringToBinary('--' & $sBoundary & @CRLF)

	; Build form data
	Local $vData = StringToBinary($sFormData) & $bFiles

	; Setup headers
	Local $sHeaders = _
		'Content-Type: multipart/form-data; boundary=' & $sBoundary & @CRLF & _
		'Content-Length: ' & BinaryLen($vData)

	; Connect to the server
	If Not _WinINet_Startup() Then Return SetError(2, 0, "")

	Local $hInternetOpen = _WinINet_InternetOpen("AutoIt/" & @AutoItVersion)
	If @error Then Return SetError(3, 0, "")

	Local $hInternetConnect = _WinINet_InternetConnect($hInternetOpen, $INTERNET_SERVICE_HTTP, $sHost, $iPort, $INTERNET_FLAG_RELOAD + $INTERNET_FLAG_KEEP_CONNECTION, $sUser, $sPass)
	If @error Then Return SetError(4, 0, "")

	; Send the request
	Local $hOpenRequest = _WinINet_HttpOpenRequest($hInternetConnect, "POST", $sPath)
	If @error Then Return SetError(5, 0, "")

	_WinINet_HttpSendRequest($hOpenRequest, $sHeaders, $vData)
	If @error Then Return SetError(6, 0, "")

	; Make sure the request returns HTTP 200 OK
	Local $vStatusCode = _WinINet_HttpQueryInfo($hOpenRequest, $HTTP_QUERY_STATUS_CODE, 0)
	$vStatusCode = Int(BinaryToString(DllStructGetData($vStatusCode[0], 1), $AU3_UNICODE+1))

	If $vStatusCode <> $HTTP_STATUS_OK Then Return SetError(7, $vStatusCode, "")

	; Read the returned data
	Local $vReceived = Binary("")
	Do
		$vReceived &= _WinINet_InternetReadFile($hOpenRequest, 1024000)
	Until @error Or Not @extended

	If @error Then Return SetError(8, 0, "")
	Return $vReceived
EndFunc   ;==>_WinINet_POSTUpload
