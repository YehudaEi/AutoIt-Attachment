#include <WinAPI.au3>

Global Const $tagWINTRUST_FILE_INFO = _
  "DWORD cbStruct;" & _
  "ptr pcwszFilePath;" & _ ; LPCWSTR
  "HWND hFile;" & _
  "ptr  pgKnownSubject;" ; GUID *

$tagWINTRUST_DATA = _
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


#cs pInfoStruct is a pointer to one of the following:
union {
    struct WINTRUST_FILE_INFO_ *pFile;
    struct WINTRUST_CATALOG_INFO_ *pCatalog;
    struct WINTRUST_BLOB_INFO_ *pBlob;
    struct WINTRUST_SGNR_INFO_ *pSgnr;
    struct WINTRUST_CERT_INFO_ *pCert;
  } ;
#ce

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

Global $WINTRUST_ACTION_GENERIC_VERIFY_V2 = _GUIDStruct("{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}")

; Prog@ndy
Func _GUIDStruct($IID)
	$IID = StringRegExpReplace($IID,"([}{])","")
	$IID = StringSplit($IID,"-")
	Local $_GUID =  "DWORD Data1;  ushort Data2;  ushort Data3;  BYTE Data4[8];"
	Local $GUID = DllStructCreate($_GUID)
	If $IID[0] = 5 Then $IID[4] &= $IID[5]
	If $IID[0] > 5 Or $IID[0] < 4 Then Return SetError(1,0,0)
	DllStructSetData($GUID,1,Dec($IID[1]))
	DllStructSetData($GUID,2,Dec($IID[2]))
	DllStructSetData($GUID,3,Dec($IID[3]))
	DllStructSetData($GUID,4,Binary("0x"&$IID[4]))
	Return $GUID
EndFunc
$hWnd=0

$SourceFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt","InstallDir")
If $SourceFile = "" Then $SourceFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt","betaInstallDir")
If $SourceFile = "" Then 
	$SourceFile = @AutoItExe
Else
	$SourceFile &= "\AutoIt3.exe"
EndIf


$pGUID=DllStructGetPtr($WINTRUST_ACTION_GENERIC_VERIFY_V2)

$WINTRUST_FILE_INFO = DllStructCreate($tagWINTRUST_FILE_INFO)

DllStructSetData($WINTRUST_FILE_INFO,1,DllStructGetSize($WINTRUST_FILE_INFO))

$wszSourceFile = DllStructCreate("wchar[" & StringLen($SourceFile)+1 & "]")

DllStructSetData($wszSourceFile,1,$SourceFile)
DllStructSetData($WINTRUST_FILE_INFO,"pcwszFilePath",DllStructGetPtr($wszSourceFile))


$WINTRUST_DATA = DllStructCreate($tagWINTRUST_DATA)
$pWINTRUST_DATA = DllStructGetPtr($WINTRUST_DATA)

DllStructSetData($WINTRUST_DATA,1,DllStructGetSize($WINTRUST_DATA))

DllStructSetData($WINTRUST_DATA,"pPolicyCallbackData",0)
DllStructSetData($WINTRUST_DATA,"pSIPClientData",0)
DllStructSetData($WINTRUST_DATA,"dwUIChoice",$WTD_UI_NONE)
DllStructSetData($WINTRUST_DATA,"fdwRevocationChecks",$WTD_REVOKE_NONE)
DllStructSetData($WINTRUST_DATA,"dwUnionChoice",$WTD_CHOICE_FILE)
DllStructSetData($WINTRUST_DATA,"dwStateAction",0)
DllStructSetData($WINTRUST_DATA,"hWVTStateData",0)
DllStructSetData($WINTRUST_DATA,"pwszURLReference",0)
DllStructSetData($WINTRUST_DATA,"dwProvFlags",$WTD_SAFER_FLAG)
DllStructSetData($WINTRUST_DATA,"dwUIContext",0)
DllStructSetData($WINTRUST_DATA,"pInfoStruct",DllStructGetPtr($WINTRUST_FILE_INFO))

$Wintrustdll = DllOpen("Wintrust.dll")
$LStatus = DllCall($Wintrustdll,"long","WinVerifyTrust","hWnd",$hWnd,"ptr",$pGUID,"ptr",$pWINTRUST_DATA)
If Not @error Then 
	$LStatus = $LStatus[0]
Else
	$LStatus = -1
EndIf

Switch $LStatus
	Case 0 ; ERROR_SUCCESS
		MsgBox(0, '', StringFormat('The file "%s" is signed and the signature was verified.\n',$SourceFile))
	Case $TRUST_E_NOSIGNATURE
;~ 		            // Get the reason for no signature.
            Local $dwLastError = _WinAPI_GetLastError();
            if ($TRUST_E_NOSIGNATURE == $dwLastError Or _
                    $TRUST_E_SUBJECT_FORM_UNKNOWN == $dwLastError Or _
                    $TRUST_E_PROVIDER_UNKNOWN == $dwLastError) Then
                ;// The file was not signed.
                MsgBox(0, '', StringFormat('The file "%s" is not signed or does not exist',$SourceFile));
            else 
                ;// The signature was not valid or there was an error 
                ;// opening the file.
                MsgBox(0, '', StringFormat('An unknown error occurred trying to verify the signature of the "%s" file.\n',$SourceFile));
            EndIf
	case $TRUST_E_EXPLICIT_DISTRUST
            ;// The hash that represents the subject or the publisher 
            ;// is not allowed by the admin or user.
            MsgBox(0, '', "The signature is present, but specifically disallowed.");

	case $TRUST_E_SUBJECT_NOT_TRUSTED
            ;// The user clicked "No" when asked to install and run.
            MsgBox(0, '', "The signature is present, but not trusted.");

	case $CRYPT_E_SECURITY_SETTINGS
            ;/*
            ;The hash that represents the subject or the publisher 
            ;was not explicitly trusted by the admin and the 
            ;admin policy has disabled user trust. No signature, 
            ;publisher or time stamp errors.
            ;*/
            MsgBox(0, '', "CRYPT_E_SECURITY_SETTINGS - The hash " & _
                "representing the subject or the publisher wasn't "& _
                "explicitly trusted by the admin and admin policy "& _
                "has disabled user trust. No signature, publisher "& _
                "or timestamp errors.");
	Case -1
		MsgBox(0, '', "DLL Call failed")

	Case Else
            ;// The UI was disabled in dwUIChoice or the admin policy 
            ;// has disabled user trust. lStatus contains the 
            ;// publisher or time stamp chain error.
            MsgBox(0, '', StringFormat('Error is: 0x%x.\n',$lStatus));
EndSwitch