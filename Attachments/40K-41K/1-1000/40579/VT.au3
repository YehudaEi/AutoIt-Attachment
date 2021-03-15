 #include-once
 #include "WinHttp.au3"

; #INDEX# =================================================================================================
; Title .........: VT.au3
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: VirusTotal public API version 2.0 implementation in Autoit
;thanks to: trancexx|ProgAndy "WinHttp.au3"  ||| guinness "Suggestions+Snippets ||| www.virustotal.com
;Reference https://www.virustotal.com/es/documentation/public-api
;Written by Danyfirex
;Date 12/05/2013 | Update 03/06/2013
; #FUNCTION# =============================================================================================




;===================CONSTANTS/CONSTANTES=======================
Global Const $__sVirusTotal_Page = 'www.virustotal.com'
Global Enum $eAPI_HttpOpen, $eAPI_HttpConnect
Global Enum $fReport,$fScan,$fRescan,$uReport,$uScan,$Comment
Global Const $tURL[6]=['/vtapi/v2/file/report','/vtapi/v2/file/scan','/vtapi/v2/file/rescan', _
                       '/vtapi/v2/url/report','/vtapi/v2/url/scan','/vtapi/v2/comments/put']
;==============================================================


; #FUNCTIONS/FUNCIONES# =======================================
;VT() ;Use respective flag($Type)
;VT(ByRef $aAPI, $Type, $sResource, $sAPIkey,$Comments="")
;flags($Type)
;$fReport = retrieve a scan report on a given file
;$fScan   = submit a file for Scanning
;$fRescan = Rescan files in VirusTotal's file store
;$uReport = retrieve a scan report on a given URL
;$uScan   = submit a URL for Scanning
;$Comment = Make a commnet on files and URLs
; ==============================================================



; #FUNCTION# =============================================================================================
; Name...........: VT_Open
; Description ...: Initialize and get session handle & connection handle
; Syntax.........: VT_Open()
; guinness
; #FUNCTION# =============================================================================================
Func VT_Open()
    Local $aAPI[2] = [0, 0]
    $aAPI[$eAPI_HttpOpen] = _WinHttpOpen()
    If @error Then $aAPI[$eAPI_HttpOpen] = -1
    $aAPI[$eAPI_HttpConnect] = _WinHttpConnect($aAPI[$eAPI_HttpOpen], $__sVirusTotal_Page)
    If @error Then $aAPI[$eAPI_HttpConnect] = -1
    Return $aAPI
EndFunc   ;==>VT_Open


; #FUNCTION# =============================================================================================
; Name...........: VT_Close
; Description ...: Close handles
; Syntax.........: VT_Close($handle)
;guinness
; #FUNCTION# =============================================================================================
Func VT_Close(ByRef Const $aAPI)
    _WinHttpCloseHandle($aAPI[$eAPI_HttpOpen])
    _WinHttpCloseHandle($aAPI[$eAPI_HttpConnect])
    Return True
EndFunc   ;==>VT_Close



; #FUNCTION# =============================================================================================
; Name...........: VT
; Syntax.........: VT(ByRef $aAPI, $Type, $sResource, $sAPIkey,$Comments="")
;VT($hVirusTotal, $fReport, '20c83c1c5d1289f177bc222d248dab261a62529b19352d7c0f965039168c0654',$APIkey)
;VT($hVirusTotal, $fScan, "C:\file.exe",$APIkey)
;VT($hVirusTotal, $fRescan, hex($bHash),$APIkey)
;VT($hVirusTotal, $uReport, "http://www.virustotal.com",$APIkey)
;VT($hVirusTotal, $uScan, "http://www.google.com",$APIkey)
;VT($hVirusTotal, $Comment, hex($bHash) ,$APIkey,"Hello Word | Hola Mundo")
; Parameters....: $Resource - md5/sha1/sha256/scan_id | filename | Url | respectively for flag($Type)
;                 $APIkey -  your API key.
;                 $Comments - your Comments
;Return.........; response format is a JSON object
; #FUNCTION# =============================================================================================
Func VT(ByRef $aAPI, $Type, $sResource, $sAPIkey,$Comments="")

    If $aAPI[$eAPI_HttpConnect] = -1 Then $aAPI = VT_Open()

	Select ;$fReport,$fScan,$fRescan,$uReport,$uScan,$Comment
    Case $Type = $fReport
         Return _WinHttpSimpleRequest($aAPI[$eAPI_HttpConnect], 'POST', $tURL[$Type], Default, 'resource=' & $sResource & '&key=' & $sAPIkey)

	 Case $Type = $fScan
		  Local $sBoundary="--------Boundary"
		  Local $sHeaders = "Content-Type: multipart/form-data; boundary=" & $sBoundary & @CRLF
		  Local $sData = ''
			    $sData &= "--" & $sBoundary & @CRLF
				$sData &= 'Content-Disposition: form-data; name="apikey"' & @CRLF & @CRLF & $sAPIkey & @CRLF
				$sData &= "--" & $sBoundary & @CRLF
				$sData &= __WinHttpFileContent("", "file", $sResource,$sBoundary)
				$sData &= "--" & $sBoundary & "--" & @CRLF
		 Return _WinHttpSimpleRequest($aAPI[$eAPI_HttpConnect], "POST", $tURL[$Type], Default, StringToBinary($sData,0), $sHeaders)

	Case $Type = $fRescan
         Return _WinHttpSimpleRequest($aAPI[$eAPI_HttpConnect], "POST", "/vtapi/v2/file/rescan", Default, "resource=" & $sResource &"&key=" & $sAPIkey)

	Case $Type = $uReport
         Return _WinHttpSimpleRequest($aAPI[$eAPI_HttpConnect], 'POST', $tURL[$Type], Default, 'resource=' & $sResource & '&key=' & $sAPIkey)

	Case $Type = $uScan
         Return _WinHttpSimpleRequest($aAPI[$eAPI_HttpConnect], 'POST', $tURL[$Type], Default, 'url=' & $sResource & '&key=' & $sAPIkey)

	Case $Type = $Comment
         return _WinHttpSimpleRequest($aAPI[$eAPI_HttpConnect], "POST", "/vtapi/v2/comments/put", Default, "resource=" & $sResource & _
		 "&comment=" & $Comments & "&key=" & $sAPIkey)

    Case Else
        SetError(3)
EndSelect

EndFunc   ;==>VT