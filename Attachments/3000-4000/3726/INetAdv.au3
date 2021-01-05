$INetAdvNumber = 0
$INetAdvFile = 0
$INetAdvUrl = 0
$INetAdvInfo = 0
Func _INetAdvGo()
	$INetAdvNumber = $INetAdvNumber + 1
	If @InetGetActive Then
		$INetAdvInfo[0] = 1
		$INetAdvInfo[6] = Int((100 / $INetAdvInfo[7]) * @InetGetBytesRead)
		If $INetAdvNumber = 4 Then
			$INetAdvInfo[4] = @InetGetBytesRead - $INetAdvInfo[3]
			$INetAdvInfo[5] = Int(($INetAdvInfo[7] - @InetGetBytesRead) / $INetAdvInfo[4])
			$INetAdvNumber = 0
		EndIf
		$INetAdvInfo[3] = @InetGetBytesRead
	Else
		_INetAdvAbort()
	EndIf
EndFunc   ;==>_INetAdvGo
;===============================================================================
;
; Function Name:    _INetAdvGet()
; Description:      Starts the downloading of a file in INetAdv mode.
; Parameter(s):     $INetAdvUrl               - URL of the file to download
;                   $INetAdvFile              - Local filename to download to
;                   $INetAdvCache [optional]  - 0 = (default) Get the file from local cache if available
;                                             - 1 = Forces a reload from the remote site
; Requirement(s):   AutoIt v3.1.1
; Return Value(s):  On Success - Returns 1
;                   Creates (and keeps updating) an array with the following values:
;                   $INetAdvInfo[0]=1 when dowloading, 0 when not
;                   $INetAdvInfo[1]=Url you are downloading from
;                   $INetAdvInfo[2]=Local filename where downloading to
;                   $INetAdvInfo[3]=Bytes read
;                   $INetAdvInfo[4]=Bytes per second
;                   $INetAdvInfo[5]=Seconds until finished
;                   $INetAdvInfo[6]=Percent
;                   $INetAdvInfo[7]=Total size
;                   On Failure - Returns 0 and sets @error to 1
; Author(s):        Svennie
;
;===============================================================================
Func _INetAdvGet($INetAdvUrl, $INetAdvFile, $INetAdvCache = 0)
	InetGet($INetAdvUrl, $INetAdvFile, $INetAdvCache, 1)
	If Not @error Then
		Dim $INetAdvInfo[8]
		$INetAdvNumber = 0
		$INetAdvInfo[3] = 0
		$INetAdvInfo[7] = InetGetSize($INetAdvUrl)
		$INetAdvInfo[1] = $INetAdvUrl
		$INetAdvInfo[2] = $INetAdvFile
		_INetAdvGo()
		AdlibEnable("_INetAdvGo")
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_INetAdvGet
;===============================================================================
;
; Function Name:    _INetAdvAbort()
; Description:      Aborts a downloading file in INetAdv mode.
; Parameter(s):     None
; Requirement(s):   AutoIt v3.1.1
; Return Value(s):  None
; Author(s):        Svennie
;
;===============================================================================
Func _INetAdvAbort()
	InetGet("abort")
	AdlibDisable()
	$INetAdvInfo[0] = 0
EndFunc   ;==>_INetAdvAbort