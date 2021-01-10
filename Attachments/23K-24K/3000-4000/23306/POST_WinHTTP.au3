#include-once
#include <WinHTTP.au3>
#include <Array.au3>

$USE_MIMETYPEFILE = 0

Global $MIMETypes[8][2] = [ _
["bmp",	"image/bmp"], _
["gif",	"image/gif"], _
["jpe",	"image/jpeg"], _
["jpeg",	"image/jpeg"], _
["jpg",	"image/jpeg"], _
["png",	"image/png"], _
["tif",	"image/tiff"], _
["tiff",	"image/tiff"]]
_SortMIMETypes()

;~ Local $form_fields[2][2] = [["password", "PW123"],["filename", "test.bmp"]]
Local $form_fields = 0
Local $form_files[1][2] = [["fileupload", "D:\test.bmp"]]

$x = post_multipart("                                  ", "", $form_fields, $form_files)
ConsoleWrite(">Body: " & @CRLF & $x[1] & @CRLF)
#include <Array.au3>

$aDirect_Link = StringRegExp($x[1], '(?i)(?s).*value="(.*)"/>.*', 3)
$aThumbnail_Link = StringRegExp($x[1], '(?i)(?s).*value="(\[URL=.*\]\[IMG\].*\[/IMG\]\[/URL\])" /> Thumbnail', 3)
$aThumbnail_Link2 = StringRegExp($x[1], '(?i)(?s).*value="(\[URL=.*\]\[IMG=.*\]\[/URL\])" /> Thumbnail', 3)
$aFriend_Link = StringRegExp($x[1], '(?i)(?s).*<a href="(.*)"><b>Show</b></a> image to friends<br', 3)
$aWebInput = ""
ConsoleWrite($aThumbnail_Link[0] & @CRLF)
If IsArray($aThumbnail_Link) Then $aThumbnail_Link = $aThumbnail_Link[0]
If IsArray($aThumbnail_Link2) Then $aThumbnail_Link2 = $aThumbnail_Link2[0]
If IsArray($aDirect_Link) Then $aDirect_Link = $aDirect_Link[0]
If IsArray($aFriend_Link) Then $aFriend_Link = $aFriend_Link[0]
If StringLen($aFriend_Link) Then $aWebInput = '<a href="                    "><img src="'&$aFriend_Link&'" border="0" alt="Image Hosted by ImageShack.us"></a><br />'
	
ConsoleWrite($aThumbnail_Link & @CRLF)
ConsoleWrite($aThumbnail_Link2 & @CRLF)
ConsoleWrite($aDirect_Link & @CRLF)
ConsoleWrite($aFriend_Link & @CRLF)
ConsoleWrite($aWebInput & @CRLF)

;~ ConsoleWrite(">Header: " & @CRLF & $x[0] & @CRLF & @CRLF)
;~ ConsoleWrite(">Body: " & @CRLF & $x[1] & @CRLF)
If Not IsDeclared("MIMETypes") Then Global $MIMETypes
If Not IsDeclared("USE_MIMETYPEFILE") Then $USE_MIMETYPEFILE = 1
; Prog@ndy
Func _LoadMimeTypes()
	Global $MIMETypes[200][2]
	Local $line
	If Not FileExists(@ScriptDir & "\MIMETypes.txt") Then
		If MsgBox(36, 'PostData', "MIMETYpes.txt fehlt. Downloaden?") = 6 Then
			InetGet("                                             ", @ScriptDir & "\MIMETypes.txt")
		EndIf
	EndIf
	$mime = FileOpen(@ScriptDir & "\MIMETypes.txt", 0)
	For $i = 0 To 199
		$line = FileReadLine($mime)
		If @error = -1 Then ExitLoop
		$line = StringSplit($line, @TAB)
		$MIMETypes[$i][0] = $line[1]
		$MIMETypes[$i][1] = $line[2]
	Next
	FileClose($mime)

	If $i < 1 Then $i = 1
	ReDim $MIMETypes[$i][2]
	_SortMIMETypes()
EndFunc   ;==>_LoadMimeTypes
If $USE_MIMETYPEFILE Then _LoadMimeTypes()
Func _SortMIMETypes()
	_ArraySort($MIMETypes, 0, 0, 0, 2)
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpWriteDataBin
; Description ...: Writes request data to an HTTP server.
; Syntax.........: _WinHttpWriteData($hRequest, $string)
; Parameters ....: $hRequest - Valid handle returned by _WinHttpSendRequest().
;                  $binary - Binary data to write.
; Return values .: Success - Returns 1
;                          - Sets @error to 0
;                          - sets @extended to written bytes
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......: ProgAndy
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384120(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpWriteDataBin($hRequest, $binary)
	Local $lpBinary
	Local $iNumberOfBytesToWrite
	If IsDllStruct($binary) Then
		$lpBinary = DllStructGetPtr($binary)
		$iNumberOfBytesToWrite = DllStructGetSize($binary)
	Else
		$iNumberOfBytesToWrite = BinaryLen($binary)
		Local $sBinary = DllStructCreate("byte[" & $iNumberOfBytesToWrite & "]")
		DllStructSetData($sBinary, 1, $binary)
		$lpBinary = DllStructGetPtr($sBinary)
	EndIf
	
	Local $a_iCall = DllCall("Winhttp.dll", "int", "WinHttpWriteData", _
			"hwnd", $hRequest, _
			"ptr", $lpBinary, _
			"dword", $iNumberOfBytesToWrite, _
			"dword*", 0)
	
	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, $a_iCall[4], 1)
	
	
EndFunc   ;==>_WinHttpWriteDataBin

#cs
post_multipart and encode_multipart_formdata translated from the cookbook 
    see ActiveState's ASPN 
    http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/146306
#ce

Func post_multipart($host, $selector, ByRef $fields, ByRef $files)
;~     """
;~     Post fields and files to an http host as multipart/form-data.
;~     fields is a sequence of (name, value) elements for regular form fields.
;~     files is a sequence of (name, filename, value) elements for data to be uploaded as files
;~     Return the server's response page.
;~     """
	Local $Return = encode_multipart_formdata($fields, $files)
	Local $content_type = 'Content-Type: ' & $Return[0] & @CRLF
;~ 	$body = $Return[1]
	Local $URL = _WinHttpCrackUrl($host)
	Local $hSession = _WinHttpOpen()
	Local $hConnection = _WinHTTPConnect($hSession,$URL[2],$URL[3])
	ConsoleWrite( $content_type&@CRLF)
;~ ConsoleWrite( StringReplace($Return[1],Chr(0),".")&@CRLF)
;~ $s = StringToBinary($Return[1])
;~ ConsoleWrite( BinaryLen($s) & "--" & StringLen($Return[1]))
;~ Return
	Local $hRequest = _WinHttpOpenRequest($hConnection,"POST",$URL[6]&$URL[7],"HTTP/1.1","http://"&$URL[2])
	_WinHttpSendRequest($hRequest,$content_type,$WINHTTP_NO_REQUEST_DATA,StringLen($Return[1]));,StringLen($Return[1]))
	_WinHTTPWriteDataBin($hRequest,StringToBinary($Return[1]))
	MsgBox(0, '', @error)
	_WinHttpReceiveResponse($hRequest)
	Local $Return[2]
	If _WinHttpQueryDataAvailable($hRequest) Then
		Local $temp
		While 1
			$temp = _WinHttpReadData($hRequest)
			If $temp = "" Then ExitLoop
			$Return[1] &=$temp
		WEnd
		$temp =""
		; Does not work since @error is 0, when no more data is available
;~ 		Do
;~ 			$Return[1] &= _WinHttpReadData($hRequest)
;~ 		Until  @error <> 0
	EndIf
	$Return[0] = _WinHttpQueryHeaders($hRequest)
	_WinHttpCloseHandle($hRequest)
	_WinHttpCloseHandle($hConnection)
	_WinHttpCloseHandle($hSession)
	Return $Return
EndFunc   ;==>post_multipart

; Prog@ndy
Func encode_multipart_formdata($fields, $files)
;~     """
;~     fields is a sequence of (name, value) elements for regular form fields.
;~     files is a sequence of (name, filename, value) elements for data to be uploaded as files
;~     Return (content_type, body) ready for httplib.HTTP instance
;~     """
	Local Const $BOUNDARY = 'ThIs_Is_tHe_bouNdaRY_$'
;~     CRLF = '\r\n'
	$L = ""
	For $i = 0 To UBound($fields) - 1
		$L &= ('--' & $BOUNDARY) & @CRLF
		$L &= ('Content-Disposition: form-data; name="' & $fields[$i][0] & '"') & @CRLF
		$L &= @CRLF
		$L &= $fields[$i][1] & @CRLF
	Next
	For $i = 0 To UBound($files) - 1
		$L &= ('--' & $BOUNDARY) & @CRLF
		$L &= ('Content-Disposition: form-data; name="' & $files[$i][0] & '"; filename="' & $files[$i][1] & '"') & @CRLF
		$content_type = get_content_type($files[$i][1])
		$L &= ('Content-Type: ' & $content_type) & @CRLF
		$L &= @CRLF
;~ 		If StringLeft($content_type, 5) <> "text/" Then
;~ 			$f = FileOpen($files[$i][1], 16)
;~ 			$L &= BinaryToString(FileRead($f)) & @CRLF
;~ 			FileClose($f)
;~ 		Else
		$L &= FileRead($files[$i][1]) & @CRLF
;~ 		EndIf
	Next
	$L &= ('--' & $BOUNDARY & '--') & @CRLF
	$L &= @CRLF
	
	$content_type = 'multipart/form-data; boundary="' & $BOUNDARY & '"'
	Local $Return[2] = [$content_type, $L]
;~     return content_type, body
	Return $Return
EndFunc   ;==>encode_multipart_formdata

; Prog@ndy
Func get_content_type($path)
;~ 	Return "application/octet-stream"
	Local $szExt = StringLower(StringRegExpReplace(,".*(?:\.([^.\\/]*))?\Z","$1"))
;~ 	ConsoleWrite(StringTrimLeft($szExt, 1) & @CRLF)
	If $szExt = "" Then Return 'application/octet-stream'
	Local $mimeid = _ArrayBinarySearch2D($MIMETypes, $szExt)
;~ 	ConsoleWrite($mimeid & @error & @CRLF)
	If $mimeid = -1 Then Return SetError(1, 0, 'application/octet-stream')
	Return $MIMETypes[$mimeid][1]
EndFunc   ;==>get_content_type
;===============================================================================
;
; Function Name:  _ArrayBinarySearch()
; Description:    Uses the binary search algorithm to search through a
;                 1-dimensional array.
; Author(s):      Jos van der Zande <jdeb at autoitscript dot com>
; Modified:       Prog@ndy
;
;===============================================================================
Func _ArrayBinarySearch2D(Const ByRef $avArray, $vValue, $iStart = 0, $Column = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Local $iMid = Int(($iEnd + $iStart) / 2)

	If $avArray[$iStart][$Column] > $vValue Or $avArray[$iEnd][$Column] < $vValue Then Return SetError(2, 0, -1)

	; Search
	While $iStart <= $iMid And $vValue <> $avArray[$iMid][$Column]
		If $vValue < $avArray[$iMid][$Column] Then
			$iEnd = $iMid - 1
		Else
			$iStart = $iMid + 1
		EndIf
		$iMid = Int(($iEnd + $iStart) / 2)
	WEnd

	If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found

	Return $iMid
EndFunc   ;==>_ArrayBinarySearch2D