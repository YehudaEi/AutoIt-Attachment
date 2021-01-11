Func _RC4Crypt($plaintxt, $psw)
    Local $sbox[256]
    Local $key[256]
    Local $temp, $a, $k, $cipherby, $cipher, $tempSwap, $aa, $bb, $intLength
    Local $i = 0
    Local $j = 0
    $intLength = StringLen($psw)
    For $aa = 0 To 255
        $key[$aa] = Asc(StringMid($psw, Mod($aa,$intLength)+1, 1))
        $sbox[$aa] = $aa
    Next
    $bb = 0
    For $aa = 0 To 255
        $bb = Mod(($bb + $sbox[$aa] + $key[$aa]),  256)
        $tempSwap = $sbox[$aa]
        $sbox[$aa] = $sbox[$bb]
        $sbox[$bb] = $tempSwap
    Next
    For $a = 1 To StringLen($plaintxt)
        $i = Mod(($i + 1), 256)
        $j = Mod(($j + $sbox[$i]), 256)
        $temp = $sbox[$i]
        $sbox[$i] = $sbox[$j]
        $sbox[$j] = $temp
        $k = $sbox[Mod(($sbox[$i] + $sbox[$j]), 256)]
        $cipherby = BitXOR(Asc(StringMid($plaintxt, $a, 1)), $k)
        $cipher &= Chr($cipherby)
    Next
    Return $cipher
EndFunc; _RC4Crypt


#Region Public Members

#Region _RC4Encrypt()
; ===================================================================
; _RC4Encrypt($sData, $sKey)
;
; Encrypts a string using the RC4 algorithm.
; Parameters:
;    $sData - IN - The data to encrypt.
;    $sKey - IN - The key to use for encryption.
; Returns:
;    The encrypted string.
; ===================================================================
Func _RC4Encrypt($sData, $sKey)
    Local $sResult = __RC4Impl($sData, $sKey)
    SetError(@error, @extended)    ; Propagate up
    Return $sResult
EndFunc    ; _RC4Encrypt()
#EndRegion _RC4Encrypt()

#Region _RC4Decrypt()
; ===================================================================
; _RC4Decrypt($sData, $sKey)
;
; Decrypts an RC4 encrypted string.
; Parameters:
;    $sData - IN - The data to decrypt.
;    $sKey - IN - The key to used during encryption.
; Returns:
;    The decrypted string.
; ===================================================================
Func _RC4Decrypt($sData, $sKey)
    Local $sResult = __RC4Impl($sData, $sKey)
    SetError(@error, @extended)    ; Propagate up
    Return $sResult
EndFunc    ; _RC4Decrypt()
#EndRegion _RC4Decrypt()

#EndRegion Public Members

#Region Private Members

#Region __RC4Impl()
; ===================================================================
; __RC4Impl($sData, $sKey)
;
; Implementation of the RC4 encryption algorithm.
; Parameters:
;    $sData - IN - Either plain text or an encrypted string.
;    $sKey - IN - The key to encrypt with or used during a previous encryption.
; Returns:
;    The string after being processed by the RC4 algorithm.
; ===================================================================
Func __RC4Impl($sData, $sKey)
    Local $aState[256]
    Local $nKeyLength = StringLen($sKey), $nDataLength = StringLen($sData)
    Local $c, $index, $x = 0, $y = 0, $sResult = ""

    For $counter = 0 To 255
        $aState[$counter] = $counter
    Next

    For $counter = 0 To 255
        $c = StringMid($sKey, Mod($counter, $nKeyLength)+1, 1)
        $index = Mod(Asc($c) + $aState[$counter] + $index, 256)
        __RC4Swap($aState[$counter], $aState[$index])
    Next

    For $counter = 1 To $nDataLength
        $x = Mod($x+1, 256)
        $y = Mod($aState[$x]+$y, 256)
        __RC4Swap($aState[$x], $aState[$y])
        $index = Mod($aState[$x]+$aState[$y], 256)
        $c = BitXOR(Asc(StringMid($sData, $counter, 1)), $aState[$index])
        $sResult &= Chr($c)
    Next
    Return $sResult
EndFunc    ; __RC4Impl()
#EndRegion __RC4Impl()

#Region __RC4Swap()
; ===================================================================
; __RC4Swap(ByRef $a, ByRef $cool.gif
;
; Swap function provided only for convience.
; Parameters:
;    $a - IN/OUT - First argument to swap.
;    $b - IN/OUT - Second argument to swap.
; Returns:
;    None.
; ===================================================================
Func __RC4Swap(ByRef $a, ByRef $b)
    Local $t = $a
    $a = $b
    $b = $t
EndFunc    ; __RC4Swap()
#EndRegion __RC4Swap()

#EndRegion Private Members

;===============================================================================
;
; Function Name:   _StringEncryptRC4
; Description::    Encrypts text using RC4 Encryption
; Parameter(s):    $text, $encryptkey
; Requirement(s):  AutoIt
; Return Value(s): Encrypted String
; Author(s):       RazerM
;
;===============================================================================
;
Func _StringEncryptRC4($text, $encryptkey)
    Local $sbox[256]
    Local $key[256]
    Local $temp
    Local $a
    Local $i
    Local $j
    Local $k
    Local $cipherby
    Local $cipher
   
    $i = 0
    $j = 0
   
    __RC4Initialize($encryptkey, $key, $sbox)
   
    For $a = 1 To StringLen($text)
        $i = Mod(($i + 1),256)
        $j = Mod(($j + $sbox[$i]),256)
        $temp = $sbox[$i]
        $sbox[$i] = $sbox[$j]
        $sbox[$j] = $temp
       
        $k = $sbox[Mod(($sbox[$i] + $sbox[$j]),256)]
       
        $cipherby = BitXOR(Asc(StringMid($text, $a, 1)),$k)
        $cipher = $cipher & Chr($cipherby)
    Next
   
    Return _StringToHexEx($cipher)
EndFunc   ;==>_StringEncryptRC4

;===============================================================================
;
; Function Name:   _StringDecryptRC4
; Description::    Decrypts text using RC4 Encryption
; Parameter(s):    $text, $encryptkey
; Requirement(s):  AutoIt
; Return Value(s): Decrypted String
; Author(s):       RazerM
; Note(s):         RC4 uses the same algorithm to encrypt and decrypt
;
;===============================================================================
;

Func _StringDecryptRC4($text, $encryptkey)
    Local $sbox[256]
    Local $key[256]
    Local $temp
    Local $a
    Local $i
    Local $j
    Local $k
    Local $cipherby
    Local $cipher
    $text = _HexToStringEx($text)
   
    $i = 0
    $j = 0
   
    __RC4Initialize($encryptkey, $key, $sbox)
   
    For $a = 1 To StringLen($text)
        $i = Mod(($i + 1),256)
        $j = Mod(($j + $sbox[$i]),256)
        $temp = $sbox[$i]
        $sbox[$i] = $sbox[$j]
        $sbox[$j] = $temp
       
        $k = $sbox[Mod(($sbox[$i] + $sbox[$j]),256)]
       
        $cipherby = BitXOR(Asc(StringMid($text, $a, 1)),$k)
        $cipher = $cipher & Chr($cipherby)
    Next
    Return $cipher
EndFunc   ;==>_StringDecryptRC4


; Helper function
Func __RC4Initialize($strPwd, ByRef $key, ByRef $sbox)
    Dim $tempSwap
    Dim $a
    Dim $b
   
    $intLength = StringLen($strPwd)
    For $a = 0 To 255
        $key[$a] = Asc(StringMid($strPwd, (Mod($a,$intLength))+1, 1))
        $sbox[$a] = $a
    Next
   
    $b = 0
    For $a = 0 To 255
        $b = Mod($b + $sbox[$a] + $key[$a],256)
        $tempSwap = $sbox[$a]
        $sbox[$a] = $sbox[$b]
        $sbox[$b] = $tempSwap
    Next
EndFunc   ;==>__RC4Initialize

Func _HexToStringEx($strHex)
    Return BinaryString("0x" & $strHex)
EndFunc   ;==>_HexToStringEx

Func _StringToHexEx($strChar)
    Return Hex(BinaryString($strChar))
EndFunc   ;==>_StringToHexEx

#include <string.au3>
Dim $mypass, $mytext, $myenctext, $mydectext, $mboxtext
Dim $valikenctext, $valikdectext
Dim $razermenctext, $razermdectext, $razermshenctext, $razermshdectext
$mypass="123456"
$mytext="This is some text to encrypt here."

$myenctext = _StringToHex(_RC4Crypt($mytext,$mypass))
$mydectext = _RC4Crypt(_HexToString($myenctext),$mypass)
$valikenctext = _StringToHex(_RC4Encrypt($mytext,$mypass))
$valikdectext = _RC4Decrypt(_HexToString($myenctext),$mypass)
$razermenctext = _StringEncryptRC4($mytext,$mypass)
$razermdectext = _StringDecryptRC4($myenctext,$mypass)

$mboxtext =""
$mboxtext&="Password:"&@CRLF&$mypass&@CRLF&@CRLF
$mboxtext&="Text String:"&@CRLF&$mytext&@CRLF&@CRLF

$mboxtext&="_RC4Crypt:"&@CRLF&$myenctext&@CRLF&@CRLF
$mboxtext&="_RC4Encrypt:"&@CRLF&$valikenctext&@CRLF&@CRLF
$mboxtext&="_StringEncryptRC4:"&@CRLF&$razermenctext&@CRLF&@CRLF

$mboxtext&="_RC4Crypt:"&@CRLF&$mydectext&@CRLF&@CRLF
$mboxtext&="_RC4Decrypt:"&@CRLF&$valikdectext&@CRLF&@CRLF
$mboxtext&="_StringDecryptRC4:"&@CRLF&$razermdectext&@CRLF&@CRLF

MsgBox(0,"",$mboxtext,60)