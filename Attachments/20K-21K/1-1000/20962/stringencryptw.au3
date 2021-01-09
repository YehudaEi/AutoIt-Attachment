#include <String.au3>
$String = "The quick brown fox jumps over the lazy dog.阿飞说到国外恶搞"
$Key = "Password"
ConsoleWrite('@@ _StringEncrypt(1, $string, $key ) = ' & _StringEncrypt(1, $String, $Key) & @CRLF & '>Error code: ' & @error & @CRLF);### Debug Console
ConsoleWrite('@@ _StringEncrypt(0, _StringEncrypt(1, $string, $key ), $key ) = ' & _StringEncrypt(0, _StringEncrypt(1, $String, $Key), $Key) & @CRLF & '>Error code: ' & @error & @CRLF);### Debug Console
ConsoleWrite('@@ _StringEncryptW(1, $string, $key ) = ' & _StringEncryptW(1, $String, $Key) & @CRLF & '>Error code: ' & @error & @CRLF);### Debug Console
ConsoleWrite('@@ _StringEncryptW(0, _StringEncryptW(1, $string, $key ), $key ) = ' & _StringEncryptW(0, _StringEncryptW(1, $String, $Key), $Key) & @CRLF & '>Error code: ' & @error & @CRLF);### Debug Console

MsgBox(0,"test",_StringEncryptW(0, _StringEncryptW(1, $String, $Key), $Key))

Func _StringEncryptW($i_Encrypt, $s_EncryptText, $s_EncryptPassword, $i_EncryptLevel = 1)
    If $i_Encrypt <> 0 And $i_Encrypt <> 1 Then
        SetError(1)
        Return ''
    ElseIf $s_EncryptText = '' Or $s_EncryptPassword = '' Then
        SetError(1)
        Return ''
    Else
        If Number($i_EncryptLevel) <= 0 Or Int($i_EncryptLevel) <> $i_EncryptLevel Then $i_EncryptLevel = 1
        Local $v_EncryptModified
        Local $i_EncryptCountH
        Local $i_EncryptCountG
        Local $v_EncryptSwap
        Local $av_EncryptBox[256][2]
        Local $i_EncryptCountA
        Local $i_EncryptCountB
        Local $i_EncryptCountC
        Local $i_EncryptCountD
        Local $i_EncryptCountE
        Local $v_EncryptCipher
        Local $v_EncryptCipherBy
        If $i_Encrypt = 1 Then
            For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
                $i_EncryptCountG = ''
                $i_EncryptCountH = ''
                $v_EncryptModified = ''
                For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
                    If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
                        $i_EncryptCountH = 1
                    Else
                        $i_EncryptCountH += 1
                    EndIf
                    $v_EncryptModified = $v_EncryptModified & ChrW(BitXOR(AscW(StringMid($s_EncryptText, $i_EncryptCountG, 1)), AscW(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
                Next
                $s_EncryptText = $v_EncryptModified
                $i_EncryptCountA = ''
                $i_EncryptCountB = 0
                $i_EncryptCountC = ''
                $i_EncryptCountD = ''
                $i_EncryptCountE = ''
                $v_EncryptCipherBy = ''
                $v_EncryptCipher = ''
                $v_EncryptSwap = ''
                $av_EncryptBox = ''
                Local $av_EncryptBox[256][2]
                For $i_EncryptCountA = 0 To 255
                    $av_EncryptBox[$i_EncryptCountA][1] = AscW(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
                    $av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
                Next
                For $i_EncryptCountA = 0 To 255
                    $i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
                    $v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
                    $av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
                    $av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
                Next
                For $i_EncryptCountA = 1 To StringLen($s_EncryptText)
                    $i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
                    $i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
                    $i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256)][0]
                    $v_EncryptCipherBy = BitXOR(AscW(StringMid($s_EncryptText, $i_EncryptCountA, 1)), $i_EncryptCountE)
                    $v_EncryptCipher &= Hex($v_EncryptCipherBy, 2)
                Next
                $s_EncryptText = $v_EncryptCipher
            Next
        Else
            For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
                $i_EncryptCountB = 0
                $i_EncryptCountC = ''
                $i_EncryptCountD = ''
                $i_EncryptCountE = ''
                $v_EncryptCipherBy = ''
                $v_EncryptCipher = ''
                $v_EncryptSwap = ''
                $av_EncryptBox = ''
                Local $av_EncryptBox[256][2]
                For $i_EncryptCountA = 0 To 255
                    $av_EncryptBox[$i_EncryptCountA][1] = AscW(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
                    $av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
                Next
                For $i_EncryptCountA = 0 To 255
                    $i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
                    $v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
                    $av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
                    $av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
                Next
                For $i_EncryptCountA = 1 To StringLen($s_EncryptText) Step 2
                    $i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
                    $i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
                    $i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256)][0]
                    $v_EncryptCipherBy = BitXOR(Dec(StringMid($s_EncryptText, $i_EncryptCountA, 2)), $i_EncryptCountE)
                    $v_EncryptCipher = $v_EncryptCipher & ChrW($v_EncryptCipherBy)
                Next
                $s_EncryptText = $v_EncryptCipher
                $i_EncryptCountG = ''
                $i_EncryptCountH = ''
                $v_EncryptModified = ''
                For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
                    If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
                        $i_EncryptCountH = 1
                    Else
                        $i_EncryptCountH += 1
                    EndIf
                    $v_EncryptModified &= ChrW(BitXOR(AscW(StringMid($s_EncryptText, $i_EncryptCountG, 1)), AscW(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
                Next
                $s_EncryptText = $v_EncryptModified
            Next
        EndIf
        Return $s_EncryptText
    EndIf
EndFunc ;==>_StringEncryptW