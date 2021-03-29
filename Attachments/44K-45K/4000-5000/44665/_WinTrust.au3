; Author 1: progandy (http://www.autoit.de/index.php?page=Thread&postID=68477#post68477)
; Author 2: Kasty added support for catalogs, UTF-8 paths, WinVerifyTrust return values, Certificate serial number, owner and issuer. (http://www.autoitscript.com/forum/topic/140737-wintrustau3/)
; Author 3: Factfinder and dragan added function to get catalogcontext  (http://www.autoitscript.com/forum/topic/161553-help-with-converting-c-to-autoit-a-dllcall-failes/)
; Author 4: Step887 with examples by Danyfirex wrote to get the catalog path and then verify function
;
; tested on Autoit v3.3.10.2


;Example using verify
;~ $filepath = FileOpenDialog("pick a file",@ScriptDir, "All Files (*.*)")
;~ If Not FileExists($filepath) Then
;~ 	MsgBox(16, '', $filepath & ' does not exist.')
;~ 	Exit
;~ EndIf
;~ $retval = _Verify($filepath)
;~ If $retval[0] Then
;~ 	MsgBox(64,'Verified', $filepath & ' is verified.' & @crlf & $retval[0] & @CRLF & $retval[1] & @CRLF & $retval[2])
;~ 	ConsoleWrite($filepath & ' is verified.' & @CRLF & $retval[0] & @CRLF & $retval[1] & @CRLF & $retval[2] & @CRLF)
;~ Else
;~ 	MsgBox(032,'Unverified',$filepath & ' is not verified.')
;~ 	ConsoleWrite($filepath & ' is not verified.' & @CRLF)
;~ EndIf

;Previous Examples by Kasty
; Example 1 (file with embedded signature, without catalogs):
;	$filePath = ".\unsigned.exe"
;	$signed = False
;	If _WinVerifyTrust($filePath) = $ERROR_SUCCESS Then $signed = True
;	ConsoleWrite($filepath & " is correctly signed = " & $signed & @LF)

; Example 2 (file without embedded signature, using a catalog instead):
;	$filePath = ".\unsigned.zip"
;	$fileTag = "File1"
;	$catalogPath = ".\catalog.cat"
;	$signed = False
;	If _WinVerifyTrust($filePath, $catalogPath, $fileTag) = $ERROR_SUCCESS Then $signed = True
;	ConsoleWrite($filepath & " is correctly signed = " & $signed & @LF)

; Example 3 (obtaining the serial number, owner and issuer of the certificate used to sign a file):
;	$certInfo = _GetSignatureInfo(".\signed.exe")
;	ConsoleWrite("Serial Number: " & $certInfo[0] & @LF)
;	ConsoleWrite("Owner: " & $certInfo[1] & @LF)
;	ConsoleWrite("Issuer: " & $certInfo[2] & @LF)

;=================================================================================================

#include <WinAPI.au3>

Global Const $tagCATALOG_INFO = _
		"DWORD cbStruct;" & _
		"WCHAR wszCatalogFile[" & 260 + 1 & "];"


Global Const $tagWINTRUST_FILE_INFO = _
		"DWORD cbStruct;" & _
		"ptr pcwszFilePath;" & _ ; LPCWSTR
		"HWND hFile;" & _
		"ptr  pgKnownSubject;" ; GUID *

Global Const $tagWINTRUST_DATA = _
		"DWORD cbStruct;" & _
		"ptr   pPolicyCallbackData;" & _
		"ptr   pSIPClientData;" & _
		"DWORD dwUIChoice;" & _
		"DWORD fdwRevocationChecks;" & _
		"DWORD dwUnionChoice;" & _
		"ptr   pInfoStruct;" & _
		"DWORD dwStateAction;" & _
		"HWND  hWVTStateData;" & _
		"ptr   pwszURLReference;" & _ ;WCHAR *
		"DWORD dwProvFlags;" & _
		"DWORD dwUIContext;"

Global Const $tagWINTRUST_CATALOG_INFO = _
		"DWORD cbStruct;" & _
		"DWORD   dwCatalogVersion;" & _
		"ptr   pcwszCatalogFilePath;" & _
		"ptr pcwszMemberTag;" & _
		"ptr pcwszMemberFilePath;" & _
		"HANDLE hMemberFile;" & _
		"ptr   pbCalculatedFileHash;" & _
		"DWORD cbCalculatedFileHash;" & _
		"ptr  pcCatalogContext;"

Global Const $tagCMSG_SIGNER_INFO = _
		"DWORD dwVersion;" & _
		"DWORD   Issuer_cbData;" & _
		"ptr   Issuer_pbData;" & _
		"DWORD SerialNumber_cbData;" & _
		"ptr SerialNumber_pbData;" & _
		"ptr HashAlgorithm_pszObjId;" & _
		"DWORD HashAlgorithm_Parameters_cbData;" & _
		"ptr HashAlgorithm_Parameters_pbData;" & _
		"ptr HashEncryptionAlgorithm_pszObjId;" & _
		"DWORD HashEncryptionAlgorithm_Parameters_cbData;" & _
		"ptr HashEncryptionAlgorithm_Parameters_pbData;" & _
		"DWORD EncryptedHash_cbData;" & _
		"ptr EncryptedHash_pbData;" & _
		"DWORD AuthAttrs_cAttr;" & _
		"ptr AuthAttrs_rgAttr;" & _
		"DWORD UnauthAttrs_cAttr;" & _
		"ptr UnauthAttrs_rgAttr;" & _
		"DWORD dwUIContext;"

Global Const $tagCERT_INFO = _
		"DWORD dwVersion;" & _
		"DWORD SerialNumber_cbData;" & _
		"ptr SerialNumber_pbData;" & _
		"ptr SignatureAlgorithm_pszObjId;" & _
		"DWORD SignatureAlgorithm_Parameters_cbData;" & _
		"ptr SignatureAlgorithm_Parameters_pbData;" & _
		"DWORD Issuer_cbData;" & _
		"ptr Issuer_pbData;" & _
		"DWORD NotBefore_dwLowDateTime;" & _
		"DWORD NotBefore_dwHighDateTime;" & _
		"DWORD NotAfter_dwLowDateTime;" & _
		"DWORD NotAfter_dwHighDateTime;" & _
		"DWORD Subject_cbData;" & _
		"ptr Subject_pbData;" & _
		"ptr SubjectPublicKeyInfo_Algorithm_pszObjId;" & _
		"DWORD SubjectPublicKeyInfo_Algorithm_Parameters_cbData;" & _
		"ptr SubjectPublicKeyInfo_Algorithm_Parameters_pbData;" & _
		"DWORD SubjectPublicKeyInfo_PublicKey_cbData;" & _
		"ptr SubjectPublicKeyInfo_PublicKey_pbData;" & _
		"DWORD IssuerUniqueId_cbData;" & _
		"ptr IssuerUniqueId_pbData;" & _
		"DWORD SubjectUniqueId_cbData;" & _
		"ptr SubjectUniqueId_pbData;" & _
		"DWORD cExtension;" & _
		"ptr rgExtension;"


Global Const $WTD_UI_ALL = 1
Global Const $WTD_UI_NONE = 2
Global Const $WTD_UI_NOBAD = 3
Global Const $WTD_UI_NOGOOD = 4
;~ /* fdwRevocationChecks */
Global Const $WTD_REVOKE_NONE = 0
Global Const $WTD_REVOKE_WHOLECHAIN = 1
;~ /* dwUnionChoice */
Global Const $WTD_CHOICE_FILE = 1
Global Const $WTD_CHOICE_CATALOG = 2
Global Const $WTD_CHOICE_BLOB = 3
Global Const $WTD_CHOICE_SIGNER = 4
Global Const $WTD_CHOICE_CERT = 5

Global Const $WTD_STATEACTION_IGNORE = 0
Global Const $WTD_STATEACTION_VERIFY = 1
Global Const $WTD_STATEACTION_CLOSE = 2
Global Const $WTD_STATEACTION_AUTO_CACHE = 3
Global Const $WTD_STATEACTION_AUTO_CACHE_FLUSH = 4

Global Const $WTD_PROV_FLAGS_MASK = 0x0000ffff
Global Const $WTD_USE_IE4_TRUST_FLAG = 0x00000001
Global Const $WTD_NO_IE4_CHAIN_FLAG = 0x00000002
Global Const $WTD_NO_POLICY_USAGE_FLAG = 0x00000004
Global Const $WTD_REVOCATION_CHECK_NONE = 0x00000010
Global Const $WTD_REVOCATION_CHECK_END_CERT = 0x00000020
Global Const $WTD_REVOCATION_CHECK_CHAIN = 0x00000040
Global Const $WTD_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = 0x00000080
Global Const $WTD_SAFER_FLAG = 0x00000100
Global Const $WTD_HASH_ONLY_FLAG = 0x00000200
Global Const $WTD_USE_DEFAULT_OSVER_CHECK = 0x00000400
Global Const $WTD_LIFETIME_SIGNING_FLAG = 0x00000800

Global Const $WTD_UICONTEXT_EXECUTE = 0
Global Const $WTD_UICONTEXT_INSTALL = 1

Global Const $ERROR_SUCCESS = 0
Global Const $TRUST_E_SYSTEM_ERROR = (0x80096001)
Global Const $TRUST_E_NO_SIGNER_CERT = (0x80096002)
Global Const $TRUST_E_COUNTER_SIGNER = (0x80096003)
Global Const $TRUST_E_CERT_SIGNATURE = (0x80096004)
Global Const $TRUST_E_TIME_STAMP = (0x80096005)
Global Const $TRUST_E_BAD_DIGEST = (0x80096010)
Global Const $TRUST_E_BASIC_CONSTRAINTS = (0x80096019)
Global Const $TRUST_E_FINANCIAL_CRITERIA = (0x8009601E)
Global Const $TRUST_E_PROVIDER_UNKNOWN = (0x800B0001)
Global Const $TRUST_E_ACTION_UNKNOWN = (0x800B0002)
Global Const $TRUST_E_SUBJECT_FORM_UNKNOWN = (0x800B0003)
Global Const $TRUST_E_SUBJECT_NOT_TRUSTED = (0x800B0004)
Global Const $TRUST_E_NOSIGNATURE = (0x800B0100)
Global Const $TRUST_E_FAIL = (0x800B010B)
Global Const $TRUST_E_EXPLICIT_DISTRUST = (0x800B0111)
;~ Global Const $TRUST_E_PROVIDER_UNKNOWN	 = (0x800B0001)

Global Const $CRYPT_E_SECURITY_SETTINGS = 0x80092026

Global $WINTRUST_ACTION_GENERIC_VERIFY_V2 = _WinAPI_GUIDFromString("{00AAC56B-CD44-11D0-8CC2-00C04FC295EE}")

Global Const $CERT_QUERY_OBJECT_FILE = 0x1
Global Const $CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED = 10
Global Const $CERT_QUERY_CONTENT_FLAG_ALL = 16382
Global Const $CERT_QUERY_CONTENT_FLAG_CERT = 2
Global Const $CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED = 2 ^ $CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED
Global Const $CERT_QUERY_FORMAT_BINARY = 0x1
Global Const $CERT_QUERY_FORMAT_FLAG_BINARY = 2 ^ $CERT_QUERY_FORMAT_BINARY
Global Const $CMSG_SIGNER_INFO_PARAM = 0x6
Global Const $X509_ASN_ENCODING = 0x00000001
Global Const $PKCS_7_ASN_ENCODING = 0x00010000
Global Const $CERT_FIND_SUBJECT_CERT = 720896
Global Const $CERT_NAME_SIMPLE_DISPLAY_TYPE = 4
Global Const $CERT_NAME_ISSUER_FLAG = 1
Global $context

Func _Verify($zfile)
	Dim $ret[3] = ["", "", ""]
	If Not FileExists($zfile) Then Return SetError(-1, 0, $ret)
	$catalogPath = _GetCatalog($zfile);able to get catalog
	If Not @error Then
		;able to get catalog
		If _WinVerifyTrust($zfile, $catalogPath, "File1") = $ERROR_SUCCESS Then
			$ret[0] = True
			$ret[1] = FileGetVersion($zfile, "CompanyName")
			$ret[2] = 'Authenticode Signed'
			Return $ret
		EndIf
	EndIf
	;If verify by catalog fails, then try to use internal Digital signature.
	$certInfo = _GetSignatureInfo($zfile)
	Return $certInfo
EndFunc   ;==>_Verify

;=================================================================================================
; $catPath = path to the catalog being used, or empty string if no catalog should be used (i.e. the signature is embedded in the file)
; $catMemberTag = if a catalog is used, this is the tag of the file inside the catalog (see MakeCat at MSDN for options)
; $iCodePage sets the encoding of the file path, see _WinAPI_MultiByteToWideChar for options, default is ANSI
; $dwProvFlags sets the way the signature is checked, see WINTRUST_DATE struct


Func _WinVerifyTrust($filePath, $catPath = "", $catMemberTag = "", $dwProvFlags = $WTD_REVOCATION_CHECK_NONE, $iCodePage = 0)
	If Not FileExists($filePath) Then Return -1
	If StringLen($filePath) > 1000 Then Return -1

	Local $wszSourceFile = _WinAPI_MultiByteToWideChar($filePath, $iCodePage, $MB_PRECOMPOSED)
	If @error Then Return -1

	If StringLen($catPath) = 0 Then
		$WINTRUST_FILE_INFO = DllStructCreate($tagWINTRUST_FILE_INFO)
		DllStructSetData($WINTRUST_FILE_INFO, "cbStruct", DllStructGetSize($WINTRUST_FILE_INFO))
		DllStructSetData($WINTRUST_FILE_INFO, "pcwszFilePath", DllStructGetPtr($wszSourceFile))
		DllStructSetData($WINTRUST_FILE_INFO, "hFile", 0)
		DllStructSetData($WINTRUST_FILE_INFO, "pgKnownSubject", 0)
		$pInfoStruct = DllStructGetPtr($WINTRUST_FILE_INFO)
		$dwUnionChoice = $WTD_CHOICE_FILE
	Else
		$wszCatalogFile = _WinAPI_MultiByteToWideChar($catPath, $iCodePage, $MB_PRECOMPOSED)
		If @error Then Return -1

		$wszFileTag = _WinAPI_MultiByteToWideChar($catMemberTag, $iCodePage, $MB_PRECOMPOSED)
		If @error Then Return -1

		$WINTRUST_CATALOG_INFO = DllStructCreate($tagWINTRUST_CATALOG_INFO)
		DllStructSetData($WINTRUST_CATALOG_INFO, "cbStruct", DllStructGetSize($WINTRUST_CATALOG_INFO))
		DllStructSetData($WINTRUST_CATALOG_INFO, "dwCatalogVersion", 0)
		DllStructSetData($WINTRUST_CATALOG_INFO, "pcwszCatalogFilePath", DllStructGetPtr($wszCatalogFile))
		DllStructSetData($WINTRUST_CATALOG_INFO, "pcwszMemberTag", DllStructGetPtr($wszFileTag))
		DllStructSetData($WINTRUST_CATALOG_INFO, "pcwszMemberFilePath", DllStructGetPtr($wszSourceFile))
		DllStructSetData($WINTRUST_CATALOG_INFO, "hMemberFile", 0)
		DllStructSetData($WINTRUST_CATALOG_INFO, "pbCalculatedFileHash", 0)
		DllStructSetData($WINTRUST_CATALOG_INFO, "cbCalculatedFileHash", 0)
		DllStructSetData($WINTRUST_CATALOG_INFO, "pcCatalogContext", 0)
		$pInfoStruct = DllStructGetPtr($WINTRUST_CATALOG_INFO)
		$dwUnionChoice = $WTD_CHOICE_CATALOG
	EndIf

	$WINTRUST_DATA = DllStructCreate($tagWINTRUST_DATA)
	DllStructSetData($WINTRUST_DATA, "cbStruct", DllStructGetSize($WINTRUST_DATA))
	DllStructSetData($WINTRUST_DATA, "pPolicyCallbackData", 0)
	DllStructSetData($WINTRUST_DATA, "pSIPClientData", 0)
	DllStructSetData($WINTRUST_DATA, "dwUIChoice", $WTD_UI_NONE)
	DllStructSetData($WINTRUST_DATA, "fdwRevocationChecks", $WTD_REVOKE_NONE)
	DllStructSetData($WINTRUST_DATA, "dwUnionChoice", $dwUnionChoice)
	DllStructSetData($WINTRUST_DATA, "pInfoStruct", $pInfoStruct)
	DllStructSetData($WINTRUST_DATA, "dwStateAction", $WTD_STATEACTION_AUTO_CACHE_FLUSH);changed from 0  http://www.autoitscript.com/forum/topic/134572-c-to-autoit-conversion/
	DllStructSetData($WINTRUST_DATA, "hWVTStateData", 0)
	DllStructSetData($WINTRUST_DATA, "pwszURLReference", 0)
	DllStructSetData($WINTRUST_DATA, "dwProvFlags", $dwProvFlags)
	DllStructSetData($WINTRUST_DATA, "dwUIContext", 0)

	$pGUID = DllStructGetPtr($WINTRUST_ACTION_GENERIC_VERIFY_V2)
	$pWINTRUST_DATA = DllStructGetPtr($WINTRUST_DATA)

	$status = DllCall("wintrust.dll", "long", "WinVerifyTrust", "HWND", 0, "ptr", $pGUID, "ptr", $pWINTRUST_DATA)
	If @error Then Return -1
	;Free context.
	If $context Then DllCall("wintrust.dll", "bool", "CryptCATAdminReleaseContext", "handle", $context, "dword", 0)
	;If we successfully verified, we need to free.
	If $status[0] Then
		DllStructSetData($WINTRUST_DATA, "dwStateAction", $WTD_STATEACTION_CLOSE)
		$ret = DllCall("wintrust.dll", "long", "WinVerifyTrust", "HWND", 0, "ptr", $pGUID, "ptr", $pWINTRUST_DATA)
	EndIf
	Return $status[0]
EndFunc   ;==>_WinVerifyTrust

;==================================================================================================================
; $filePath = path of a signed file (may be a catalog)
; $iCodePage = code page, default is ANSI
; Returns: array of 3 elements [certificate serial number, cert. signer, cert. issuer]

Func _GetSignatureInfo($filePath, $iCodePage = 0)

	Dim $empty_answer[3] = ["", "", ""]
	Dim $certInfo[3] = ["", "", ""]

	If Not FileExists($filePath) Then Return $empty_answer

	Local $wszSourceFile = _WinAPI_MultiByteToWideChar($filePath, $iCodePage, $MB_PRECOMPOSED, True)
	If @error Then Return $empty_answer

	Local $aCall = DllCall("Crypt32.dll", "bool", "CryptQueryObject", _
			"dword", $CERT_QUERY_OBJECT_FILE, _
			"wstr", $wszSourceFile, _
			"dword", $CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED, _
			"dword", $CERT_QUERY_FORMAT_FLAG_BINARY, _
			"dword", 0, _
			"dword*", 0, _
			"dword*", 0, _
			"dword*", 0, _
			"handle*", 0, _
			"handle*", 0, _
			"ptr", 0)
	If $aCall[0] = 0 Then Return $empty_answer

	Local $iMsgAndCertEncodingType = $aCall[6]
	Local $iContentType = $aCall[7]
	Local $iFormatType = $aCall[8]
	Local $hStore = $aCall[9]
	Local $hMsg = $aCall[10]
	Local $ppvContext = $aCall[11]

	; Simple check
	If Not $hMsg Then Return $empty_answer

	$aCall = DllCall("Crypt32.dll", "bool", "CryptMsgGetParam", _
			"handle", $hMsg, _
			"dword", $CMSG_SIGNER_INFO_PARAM, _
			"dword", 0, _
			"ptr", 0, _
			"dword*", 0)

	Local $iSize = $aCall[5]

	Local $pSignerInfo = DllStructCreate("byte[" & $iSize & "]")

	$aCall = DllCall("Crypt32.dll", "bool", "CryptMsgGetParam", _
			"handle", $hMsg, _
			"dword", $CMSG_SIGNER_INFO_PARAM, _
			"dword", 0, _
			"ptr", DllStructGetPtr($pSignerInfo), _
			"dword*", DllStructGetSize($pSignerInfo))

	; CMSG_SIGNER_INFO structure
	Local $CMSG_SIGNER_INFO = DllStructCreate($tagCMSG_SIGNER_INFO, DllStructGetPtr($pSignerInfo))

	Local $CERT_INFO = DllStructCreate($tagCERT_INFO)
	DllStructSetData($CERT_INFO, "Issuer_cbData", DllStructGetData($CMSG_SIGNER_INFO, "Issuer_cbData"))
	DllStructSetData($CERT_INFO, "Issuer_pbData", DllStructGetData($CMSG_SIGNER_INFO, "Issuer_pbData"))
	DllStructSetData($CERT_INFO, "SerialNumber_cbData", DllStructGetData($CMSG_SIGNER_INFO, "SerialNumber_cbData"))
	DllStructSetData($CERT_INFO, "SerialNumber_pbData", DllStructGetData($CMSG_SIGNER_INFO, "SerialNumber_pbData"))

	$aCall = DllCall("Crypt32.dll", "ptr", "CertFindCertificateInStore", _
			"HANDLE", $hStore, _
			"DWORD", $X509_ASN_ENCODING + $PKCS_7_ASN_ENCODING, _
			"DWORD", 0, _
			"DWORD", $CERT_FIND_SUBJECT_CERT, _
			"ptr", DllStructGetPtr($CERT_INFO), _
			"ptr", 0)

	If $aCall[0] = 0 Then Return $empty_answer
	Local $pCertContext = $aCall[0]

	; get serial Number
	Local $serialNumberSize = DllStructGetData($CERT_INFO, "SerialNumber_cbData")
	Local $_serialNumber = DllStructCreate("BYTE[" & $serialNumberSize & "]", DllStructGetData($CERT_INFO, "SerialNumber_pbData"))
	Local $invertedSerialNumber = Hex(DllStructGetData($_serialNumber, 1))
	Local $serialNumber = ""
	For $x = 1 To $serialNumberSize * 2 Step 2
		$serialNumber = $serialNumber & StringMid($invertedSerialNumber, ($serialNumberSize * 2) - $x, 2)
	Next
	$certInfo[0] = $serialNumber

	; get signer
	$aCall = DllCall("Crypt32.dll", "DWORD", "CertGetNameStringW", "ptr", $pCertContext, "DWORD", $CERT_NAME_SIMPLE_DISPLAY_TYPE, "DWORD", 0, "ptr", 0, "ptr", 0, "DWORD", 0)
	If $aCall[0] = 0 Then Return $empty_answer
	Local $dwSize = $aCall[0]
	Local $szSignerName = DllStructCreate("wchar[" & $dwSize & "]")
	$aCall = DllCall("Crypt32.dll", "DWORD", "CertGetNameStringW", "ptr", $pCertContext, "DWORD", $CERT_NAME_SIMPLE_DISPLAY_TYPE, "DWORD", 0, "ptr", 0, "ptr", DllStructGetPtr($szSignerName), "DWORD", $dwSize)
	If $aCall[0] = 0 Then Return $empty_answer
	$certInfo[1] = DllStructGetData($szSignerName, 1)

	; get issuer
	$aCall = DllCall("Crypt32.dll", "DWORD", "CertGetNameStringW", "ptr", $pCertContext, "DWORD", $CERT_NAME_SIMPLE_DISPLAY_TYPE, "DWORD", $CERT_NAME_ISSUER_FLAG, "ptr", 0, "ptr", 0, "DWORD", 0)
	If $aCall[0] = 0 Then Return $empty_answer
	$dwSize = $aCall[0]
	Local $szIssuerName = DllStructCreate("wchar[" & $dwSize & "]")
	$aCall = DllCall("Crypt32.dll", "DWORD", "CertGetNameStringW", "ptr", $pCertContext, "DWORD", $CERT_NAME_SIMPLE_DISPLAY_TYPE, "DWORD", $CERT_NAME_ISSUER_FLAG, "ptr", 0, "ptr", DllStructGetPtr($szIssuerName), "DWORD", $dwSize)
	If $aCall[0] = 0 Then Return $empty_answer
	$certInfo[2] = DllStructGetData($szIssuerName, 1)

	Return $certInfo

EndFunc   ;==>_GetSignatureInfo

Func _GetCatalog($sFile)
	Local $pContext
	$context = DllCall('Wintrust.dll', 'BOOL', 'CryptCATAdminAcquireContext', 'ptr*', $pContext, 'ptr', 0, 'DWORD', 0)
	If @error Or Not $context[0] Then Return SetError(1, 0, "CryptCATAdminAcquireContext failed to return pContext")
	$context = $context[1]
	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
			"wstr", $sFile, _
			"dword", 0x80000000, _ ; GENERIC_READ
			"dword", 1, _ ; FILE_SHARE_READ
			"ptr", 0, _
			"dword", 3, _ ; OPEN_EXISTING
			"dword", 0, _ ; SECURITY_ANONYMOUS
			"ptr", 0)
	If @error Or $a_hCall[0] = -1 Then Return SetError(2, 0, "CreateFileW function failed")
	Local $hFile = $a_hCall[0]

	Local $cbHash = 0
	$cbHash = DllCall('Wintrust.dll', 'BOOL', 'CryptCATAdminCalcHashFromFileHandle', 'handle', $hFile, 'DWORD*', $cbHash, 'ptr', 0, 'dword', 0)
	If @error Or Not $cbHash[0] Then
		_WinAPI_CloseHandleEx($hFile)
		Return SetError(3, 0, "CryptCATAdminCalcHashFromFileHandle failed to return cbHash")
	EndIf
	$cbHash = $cbHash[2]

	Local $Buffer = DllStructCreate('BYTE[' & $cbHash & ']')
	$pbHash = DllStructGetPtr($Buffer, 1)

	$cbHash = DllCall('Wintrust.dll', 'BOOL', 'CryptCATAdminCalcHashFromFileHandle', 'handle', $hFile, 'DWORD*', $cbHash, 'ptr', $pbHash, 'DWORD', 0)
	If @error Or Not $cbHash[0] Then
		_WinAPI_CloseHandleEx($hFile)
		Return SetError(4, 0, "CryptCATAdminCalcHashFromFileHandle failed to return cbHash, #2")
	EndIf
	$cbHash = $cbHash[2]
	_WinAPI_CloseHandleEx($hFile)

	Local $CatalogContext = DllCall('Wintrust.dll', 'handle', 'CryptCATAdminEnumCatalogFromHash', 'handle', $context, 'ptr', $pbHash, 'DWORD', $cbHash, 'DWORD', 0, "handle", 0)
	If @error Or Not $CatalogContext[0] Then Return SetError(5, 0, "CryptCATAdminEnumCatalogFromHash failed to return HCATINFO")
	$CatalogContext = $CatalogContext[0]
	If $CatalogContext Then
		$sInfoStruct = DllStructCreate($tagCATALOG_INFO)
		DllStructSetData($sInfoStruct, "cbStruct", DllStructGetSize($sInfoStruct))
		$InfoStruct = DllStructGetPtr($sInfoStruct)
		$return = DllCall('Wintrust.dll', 'BOOL', 'CryptCATCatalogInfoFromContext', 'handle', $CatalogContext, 'ptr', $InfoStruct, 'dword', 0)
		If @error Then Return SetError(5, 0, "CryptCATCatalogInfoFromContext failed")
		$catalogPath = DllStructGetData($sInfoStruct, "wszCatalogFile")
		Return $catalogPath
	EndIf

EndFunc   ;==>_GetCatalog

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CloseHandleEx($hObject)
	Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CloseHandleEx
