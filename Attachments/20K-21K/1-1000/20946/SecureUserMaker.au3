$Username2 = InputBox ("Username", "Enter the username to hash : ")
$Password2 = InputBox ("Password", "Enter the password to hash : ")
$Attrib = InputBox ("Attribute", "Enter user attribute (OK/BAN) : ")

If $attrib <> "OK" AND $attrib <> "BAN" Then
	MsgBox (16, "Attribute", "Attribute can only be OK or BAN (case sensitive)!")
	Exit
EndIf

$Username = _Crypt_HashData ($Username2)
$Password = _Crypt_HashData ($Password2)

FileWrite (@ScriptDir & "\" & $Username & ".txt",$Password & @CRLF & $Attrib)

;===============================================================================
; Function Name:    _Crypt_HashData()
; Description:      Calculate hash from data
; Syntax:
; Parameter(s):  $vData - data to hash, can be binary or a string
;               $iAlgID - hash algorithm identifier, can be one of the following:
;                  0x8001 = MD2
;                  0x8002 = MD4
;                  0x8003 = MD5 (default)
;                  0x8004 = SHA1
;                  also see http://msdn.microsoft.com/en-us/library/aa375549(VS.85).aspx
; Requirement(s):
; Return Value(s):  Success = Returns hash string
;               Failure = Returns empty string and sets error:
;                  @error -1 = error opening advapi32.dll
;                  @error 1 = failed CryptAcquireContext
;                  @error 2 = failed CryptCreateHash
;                  @error 3 = failed CryptHashData
; Author(s):   Siao
; Modification(s):
;===============================================================================
Func _Crypt_HashData($vData, $iAlgID = 0x8003)
    Local $hDll = DllOpen('advapi32.dll'), $iLen = BinaryLen($vData), $hContext, $hHash, $aRet, $sRet = "", $iErr = 0, $tDat = DllStructCreate("byte[" & $iLen+1 & "]"), $tBuf
    DllStructSetData($tDat, 1, $vData)
    If $hDll = -1 Then Return SetError($hDll,0,$sRet)
    $aRet = DllCall($hDll,'int','CryptAcquireContext', 'ptr*',0, 'ptr',0, 'ptr',0, 'dword',1, 'dword',0xF0000000) ;PROV_RSA_FULL = 1; CRYPT_VERIFYCONTEXT = 0xF0000000
    If Not @error And $aRet[0] Then
        $hContext = $aRet[1]
        $aRet = DllCall($hDll,'int','CryptCreateHash', 'ptr',$hContext, 'dword',$iAlgID, 'ptr',0, 'dword',0, 'ptr*',0)
        If $aRet[0] Then
            $hHash = $aRet[5]
            $aRet = DllCall($hDll,'int','CryptHashData', 'ptr',$hHash, 'ptr',DllStructGetPtr($tDat), 'dword',$iLen, 'dword',0)
            If $aRet[0] Then
                $aRet = DllCall($hDll,'int','CryptGetHashParam', 'ptr',$hHash, 'dword',2, 'ptr',0, 'int*',0, 'dword',0) ;HP_HASHVAL = 2
                $tBuf = DllStructCreate("byte[" & $aRet[4] & "]")
                DllCall($hDll,'int','CryptGetHashParam', 'ptr',$hHash, 'dword',2, 'ptr',DllStructGetPtr($tBuf), 'int*',$aRet[4], 'dword',0)
                $sRet = Hex(DllStructGetData($tBuf, 1))
            Else
                $iErr = 3
            EndIf
            DllCall($hDll,'int','CryptDestroyHash', 'ptr',$hHash)
        Else
            $iErr = 2
        EndIf
        DllCall($hDll,'int','CryptReleaseContext', 'ptr',$hContext, 'dword',0)
    Else
        $iErr = 1
    EndIf
    DllClose($hDll)
    Return SetError($iErr,0,$sRet)
EndFunc

