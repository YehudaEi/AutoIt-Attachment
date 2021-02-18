#include <Array.au3>
#include <File.au3>
#include "Toast.au3"
#include <String.au3>
SoundSetWaveVolume(100)


$loop = 1
Do

Global $sMsg, $hProgress, $aRet[2] ; needed for toast script
;read string two
Local $temp = InetRead("                                           ",1) ; 1 forces reload
Local $nBytesRead = @extended ; duno where this is for exactly
Local $bin2string = BinaryToString($temp) ; make string
Local $Trim_WhiteSpace = StringStripWS($bin2string,3) ; strip all spaces
local $string_two = _StringStripComma($Trim_WhiteSpace)

$string_two = StringReplace($string_two,"Ã©","é")
$string_two = StringReplace($string_two,"(guest) ","Gast_")
ConsoleWrite("String_two = " & $string_two & @CRLF) ; output internet read to console


; read string one
$file = FileOpen("chatters.txt", 0) ; 0 = read
Local $string_one = FileReadLine($file)							
FileClose($file)
$string_one = StringReplace($string_one,"(guest) ","Gast_")
ConsoleWrite("String_one = " & _StringProper($string_one) & @CRLF & @CRLF) ; output file read to console

; our two test strings are ready now
; lets compare them

; ----------- Malkey's part starts here ------------
Local $sPattern1 = StringReplace($string_one, ",", ",?|") & ",?"
Local $sDiffAdd = StringRegExpReplace($string_two, $sPattern1, "")
;ConsoleWrite("$sPattern1 =  " & $sPattern1 & "   $sDiffAdd =  " & $sDiffAdd & @CRLF)

Local $sPattern2 = StringReplace($string_two, ",", ",?|") & ",?"
Local $sDiffGo = StringRegExpReplace($string_one, $sPattern2, "")
;ConsoleWrite("$sPattern2 =  " & $sPattern2 & "   $sDiffGo =  " & $sDiffGo & @CRLF)

If $sDiffAdd <> "" Or $sDiffGo <> "" Then
    If $sDiffAdd <> "" Then 
		;MsgBox(0, "Result", 'Person/s added = "' & _StringStripComma($sDiffAdd) & '"') ; Remove comma.
		; popup a toast message
		$sMsg  = _StringStripComma($sDiffAdd & @CRLF & "online")  ;
        Soundplay(@WindowsDir & "\Media\Windows Exclamation.wav", 0)
        _Toast_Set(5, 0xFF0011, 0xFFFF00, 0x0000FF, 0xFFFFFF, 10, "Arial")
        $aRet = _Toast_Show(0, "PartyPlayers Chat", $sMsg, 10)
        _Toast_Hide()

		
		EndIf
    If $sDiffGo <> "" Then 
		;MsgBox(0, "Result", 'Person/s gone = "' & _StringStripComma($sDiffGo) & '"') ; Remove comma.
		; popup a toast message
		$sMsg  = _StringStripComma($sDiffGo & @CRLF & "online")  ;
        Soundplay(@WindowsDir & "\Media\Windows Exclamation.wav", 0)
        _Toast_Set(5, 0xFF0011, 0xFFFF00, 0x0000FF, 0xFFFFFF, 10, "Arial")
        $aRet = _Toast_Show(0, "PartyPlayers Chat", $sMsg, 10)
        _Toast_Hide()
		
		EndIf
Else
    ;MsgBox(0, "Result", 'Both strings the same')
EndIf
;------------end Milkey's part here -----------------


$file = FileOpen("chatters.txt", 2)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
FileWriteLine($file, $string_two); record to disk from internet
FileClose($file)
ConsoleWrite("String_three = " & $string_two & @CRLF) ; output file read to console

sleep(5000)
$loop = $loop +1
Until $loop = 0


; Removes leading and trailing commas.
Func _StringStripComma($string)
    While StringLeft($string, 1) == ","
        $string = StringTrimLeft($string, 1)
    WEnd
    While StringRight($string, 1) == ","
        $string = StringTrimRight($string, 1)
    WEnd
    Return $string
EndFunc   ;==>_StringStripComma
