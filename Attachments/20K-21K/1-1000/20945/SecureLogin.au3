#include <IE.au3>

;===============================================================================
; Function Name:    _Login()
; Description:      Adds login-security to your application (using MD5 hash).
; Syntax:
; Parameter(s):  $webDirectory - The directory on your website which contains .txt files.
;								 The .txt file must contain MD5 hash of the user's password 
;								 and OK/BAN attribute ($MD5PW & @CRLF & $ATTRIBUTE).
;								 Name of the .txt file must be the MD5 hash of username.
;								 Don't add " / " at the end of the web adress.
;
;                $OKMessage - The message that will show up if the username and password are correct
;				 $BANMessage - The message that will show up if the user is banned
;				 $WRONGMessage - The message that will show up if the user specified wrong username/password
; Requirement(s):
; Return Value(s):  Success = Returns ID and Password in format like this (without quotes) : "username,password"
; Author(s):   mafioso
; Modification(s):
;===============================================================================

Func _SecureLogin($webDirectory, $OKMessage = "User file found. You may use this program !", $BANMessage = "User banned. You can't use this program !", $WRONGMessage = "Username and/or password wrong. Please try again.")
$ID = InputBox ("Username", "Please enter your username : ", "")
$PW = InputBox ("Password", "Please enter your password : ", "*")
$IECheck = _IECreate ($webDirectory & "/" & _Crypt_HashData($ID) & ".txt", 0, 0) ;Find the file on web server
$Source = _IEBodyReadText ($IECheck) ; Read the userfile	
;===PROCEED===;
If $Source = _Crypt_HashData($PW) & @CRLF & "OK" Then ;If the userfile is found and PW is OK, and the user is not banned
	MsgBox (64, "Login check", $OKMessage)
EndIf ;=> PROCEED
;===BANNED===;
If $Source = _Crypt_HashData($PW) & @CRLF & "BAN" Then ;If the userfile is found and PW is OK, but the user IS BANNED
	MsgBox (16, "Login check", $BANMessage)
	Exit
EndIf ;=> BANNED
;===WRONG USERNAME/PW===;
If $Source <> _Crypt_HashData($PW) & @CRLF & "OK" AND $Source <> _Crypt_HashData($PW) & @CRLF & "BAN" Then ;If the file is not found (wrong username)
	MsgBox (16, "Login check", $WRONGMessage)
	MsgBox (64, "Login check", "Please note that this could also mean that the userfile on the server is not OK. Please contact application maker if you think that your username and password are correct.")
	Exit
EndIf ;=> WRONG USERNAME/PW
Return _Crypt_HashData($ID) & "," & _Crypt_HashData($PW) & "," & $webDirectory
EndFunc

;===============================================================================
; Function Name:    _SecurityCheck()
; Description:      Checks if the login is OK. This function is great if you think that someone may
;					reverse your application. Add this function more times at random lines in your code.
; Syntax:
; Parameter(s):  $Login - Previous call to _Login function
;				 $Message - The message that will show if someone tried to reverse your application
;				 $BANMessage - The message that will show up if the user is banned
; Requirement(s):
; Return Value(s): 
; Author(s):   mafioso
; Modification(s):
;===============================================================================

Func _SecureCheck($Login, $Message = "You tried to reverse/crack this application. The application will now exit.", $BANMessage = "User you specified is banned. You can't use this program !")
$UserData = StringSplit ($Login, ",")
$IECheck = _IECreate ($UserData[3] & "/" & $UserData[1] & ".txt", 0, 0) ;Find the file on web server
$Source = _IEBodyReadText ($IECheck) ; Read the userfile	
;===PROCEED===;
If $Source = $UserData[2] & @CRLF & "OK" Then ;If the userfile is found and PW is OK, and the user is not banned
	;You can do something here if you want
EndIf ;=> PROCEED
;===BANNED===;
If $Source = $UserData[2] & @CRLF & "BAN" Then ;If the userfile is found and PW is OK, but the user IS BANNED
	MsgBox (16, "Login check", $BANMessage)
	Exit
EndIf ;=> BANNED
;===WRONG USERNAME/PW===;
If $Source <> $UserData[2] & @CRLF & "OK" AND $Source <> $UserData[2] & @CRLF & "BAN" Then ;If the file is not found (wrong username)
	MsgBox (16, "Login check", $Message)
	Exit
EndIf ;=> WRONG USERNAME/PW
EndFunc


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
