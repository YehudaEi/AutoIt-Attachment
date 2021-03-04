; Original Author: progandy (http://www.autoit.de/index.php?page=Thread&postID=68477#post68477)
; Modified by Kasty: added support for catalogs, UTF-8 paths, and external handling of WinVerifyTrust return values
;
; Usage 1 (file with embedded signature, without catalogs):
;	$filePath = ".\unsigned.exe"
;	$signed = False
;	If _WinVerifyTrust($filePath) = $ERROR_SUCCESS Then $signed = True
;	ConsoleWrite($filepath & " is correctly signed = " & $signed & @LF)

; Usage 2 (file without embedded signature, using a catalog instead):
;	$filePath = ".\unsigned.zip"
;	$fileTag = "File1"
;	$catalogPath = ".\catalog.cat"
;	$signed = False
;	If _WinVerifyTrust($filePath, $catalogPath, $fileTag) = $ERROR_SUCCESS Then $signed = True
;	ConsoleWrite($filepath & " is correctly signed = " & $signed & @LF)
;=================================================================================================
#Include <WinAPI.au3>

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

Global Const $WTD_UI_ALL                = 1
Global Const $WTD_UI_NONE               = 2
Global Const $WTD_UI_NOBAD              = 3
Global Const $WTD_UI_NOGOOD             = 4
;~ /* fdwRevocationChecks */
Global Const $WTD_REVOKE_NONE           = 0
Global Const $WTD_REVOKE_WHOLECHAIN     = 1
;~ /* dwUnionChoice */
Global Const $WTD_CHOICE_FILE           = 1
Global Const $WTD_CHOICE_CATALOG        = 2
Global Const $WTD_CHOICE_BLOB           = 3
Global Const $WTD_CHOICE_SIGNER         = 4
Global Const $WTD_CHOICE_CERT           = 5

Global Const $WTD_STATEACTION_IGNORE           = 0
Global Const $WTD_STATEACTION_VERIFY           = 1
Global Const $WTD_STATEACTION_CLOSE            = 2
Global Const $WTD_STATEACTION_AUTO_CACHE       = 3
Global Const $WTD_STATEACTION_AUTO_CACHE_FLUSH = 4

Global Const $WTD_PROV_FLAGS_MASK                     = 0x0000ffff
Global Const $WTD_USE_IE4_TRUST_FLAG                  = 0x00000001
Global Const $WTD_NO_IE4_CHAIN_FLAG                   = 0x00000002
Global Const $WTD_NO_POLICY_USAGE_FLAG                = 0x00000004
Global Const $WTD_REVOCATION_CHECK_NONE               = 0x00000010
Global Const $WTD_REVOCATION_CHECK_END_CERT           = 0x00000020
Global Const $WTD_REVOCATION_CHECK_CHAIN              = 0x00000040
Global Const $WTD_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = 0x00000080
Global Const $WTD_SAFER_FLAG                          = 0x00000100
Global Const $WTD_HASH_ONLY_FLAG                      = 0x00000200
Global Const $WTD_USE_DEFAULT_OSVER_CHECK             = 0x00000400
Global Const $WTD_LIFETIME_SIGNING_FLAG               = 0x00000800

Global Const $WTD_UICONTEXT_EXECUTE = 0
Global Const $WTD_UICONTEXT_INSTALL = 1

Global Const $ERROR_SUCCESS = 0
Global Const $TRUST_E_SYSTEM_ERROR  = (0x80096001)
Global Const $TRUST_E_NO_SIGNER_CERT  = (0x80096002)
Global Const $TRUST_E_COUNTER_SIGNER  = (0x80096003)
Global Const $TRUST_E_CERT_SIGNATURE  = (0x80096004)
Global Const $TRUST_E_TIME_STAMP  = (0x80096005)
Global Const $TRUST_E_BAD_DIGEST  = (0x80096010)
Global Const $TRUST_E_BASIC_CONSTRAINTS  = (0x80096019)
Global Const $TRUST_E_FINANCIAL_CRITERIA  = (0x8009601E)
Global Const $TRUST_E_PROVIDER_UNKNOWN  = (0x800B0001)
Global Const $TRUST_E_ACTION_UNKNOWN  = (0x800B0002)
Global Const $TRUST_E_SUBJECT_FORM_UNKNOWN  = (0x800B0003)
Global Const $TRUST_E_SUBJECT_NOT_TRUSTED  = (0x800B0004)
Global Const $TRUST_E_NOSIGNATURE  = (0x800B0100)
Global Const $TRUST_E_FAIL  = (0x800B010B)
Global Const $TRUST_E_EXPLICIT_DISTRUST  = (0x800B0111)
;~ Global Const $TRUST_E_PROVIDER_UNKNOWN	 = (0x800B0001)

Global Const $CRYPT_E_SECURITY_SETTINGS = 0x80092026

Global $WINTRUST_ACTION_GENERIC_VERIFY_V2 = _WinAPI_GUIDFromString("{00AAC56B-CD44-11D0-8CC2-00C04FC295EE}")

;=================================================================================================
; $catPath = path to the catalog being used, or empty string if no catalog should be used (i.e. the signature is embedded in the file)
; $catMemberTag = if a catalog is used, this is the tag of the file inside the catalog (see MakeCat at MSDN for options)
; $iCodePage sets the encoding of the file path, see _WinAPI_MultiByteToWideChar for options, default is ANSI
; $dwProvFlags sets the way the signature is checked, see WINTRUST_DATE struct

Func _WinVerifyTrust($filePath, $catPath = "", $catMemberTag = "", $dwProvFlags = $WTD_REVOCATION_CHECK_NONE, $iCodePage = 0)
	If Not FileExists($filePath) Then return -1
	If StringLen($filePath) > 1000 Then return -1
			
	$wszSourceFile = _WinAPI_MultiByteToWideChar($filePath , $iCodePage , $MB_PRECOMPOSED)
	If @error Then return -1

	If StringLen($catPath) = 0 Then
		$WINTRUST_FILE_INFO = DllStructCreate($tagWINTRUST_FILE_INFO)
		DllStructSetData($WINTRUST_FILE_INFO, "cbStruct", DllStructGetSize($WINTRUST_FILE_INFO))
		DllStructSetData($WINTRUST_FILE_INFO, "pcwszFilePath", DllStructGetPtr($wszSourceFile))
		DllStructSetData($WINTRUST_FILE_INFO, "hFile", 0)
		DllStructSetData($WINTRUST_FILE_INFO, "pgKnownSubject", 0)
		$pInfoStruct = DllStructGetPtr($WINTRUST_FILE_INFO)
		$dwUnionChoice = $WTD_CHOICE_FILE
	Else
		$wszCatalogFile = _WinAPI_MultiByteToWideChar($catPath , $iCodePage , $MB_PRECOMPOSED)
		If @error Then return -1

		$wszFileTag = _WinAPI_MultiByteToWideChar($catMemberTag , $iCodePage , $MB_PRECOMPOSED)
		If @error Then return -1

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
	DllStructSetData($WINTRUST_DATA, "dwStateAction", 0)
	DllStructSetData($WINTRUST_DATA, "hWVTStateData", 0)
	DllStructSetData($WINTRUST_DATA, "pwszURLReference", 0)
	DllStructSetData($WINTRUST_DATA, "dwProvFlags", $dwProvFlags)
	DllStructSetData($WINTRUST_DATA, "dwUIContext", 0)
		
	$pGUID=DllStructGetPtr($WINTRUST_ACTION_GENERIC_VERIFY_V2)
	$pWINTRUST_DATA = DllStructGetPtr($WINTRUST_DATA)

	$status = DllCall("wintrust.dll","long","WinVerifyTrust","HWND", 0, "ptr", $pGUID, "ptr", $pWINTRUST_DATA)
	If @error Then return -1

	return $status[0]
EndFunc

