#include <Array.au3>
#include <File.au3>
#include "Toast.au3"
#include <String.au3>
SoundSetWaveVolume(100)

;$aDiffGone = _StringDiff($string_one, $string_two)
;$aDiffAdded = _StringDiff($string_two, $string_one)
;MsgBox(0, "Result First Example", 'Person/s added = "' & $aDiffAdded  & '"' & @CRLF & 'Person/s gone = "' & $aDiffGone & '"')

$loop = 1
Do

Global $sMsg, $hProgress, $aRet[2] ; needed for toast script
;read string two
Local $temp = InetRead("                                           ",1) ; 1 forces reload
Local $nBytesRead = @extended ; duno where this is for exactly
Local $bin2string = BinaryToString($temp) ; make string
Local $Trim_WhiteSpace = StringStripWS($bin2string,3) ; strip all spaces
local $string_two = _StringStripComma($Trim_WhiteSpace)

; do some converting
$string_two = StringReplace($string_two,"(guest) ","") ; is this easier to do ????
$string_two = StringReplace($string_two,"Ã©","é")
$string_two = StringReplace($string_two,"#","")
$string_two = StringReplace($string_two,"@","")
$string_two = StringReplace($string_two," ","_")
$string_two = StringReplace($string_two,"&","_en_")
ConsoleWrite("String_two = " & _StringProper($string_two) & @CRLF & @CRLF) ; output internet read to console


; read string one
$file = FileOpen("chatters.txt", 0) ; 0 = read
Local $string_one = FileReadLine($file)							
FileClose($file)
$string_one = StringReplace($string_one,"(guest) ","") ; is this easier to do ????
$string_one = StringReplace($string_one,"Ã©","é")
$string_one = StringReplace($string_one,"#","")
$string_one = StringReplace($string_one,"@","")
$string_one = StringReplace($string_one," ","_")
$string_one = StringReplace($string_one,"&","_en_")
ConsoleWrite("String_one = " & _StringProper($string_one) & @CRLF & @CRLF) ; output file read to console

; our two test strings are ready now
; lets compare them
local $aDiffGone = _StringDiff($string_one, $string_two)
local $aDiffAdded = _StringDiff($string_two, $string_one)


; for test only ; $aDiffAdded = "PINO,JAN,KLAAS,PIETJE"


If $aDiffAdded <> "" Or $aDiffGone <> "" Then
    If $aDiffAdded <> "" Then 
		;MsgBox(0, "Result", 'Person/s added = "' & _StringStripComma($sDiffAdd) & '"') ; Remove comma.
		; popup a toast message
		$sMsg  = _StringStripComma($aDiffAdded & @CRLF & @CRLF & "Online")  ; ovebodig in nieuwe script ?
        ;Soundplay(@WindowsDir & "\Media\Windows Exclamation.wav", 0)
		_Toast_Set(5, 0xFF0011, 0xFFFF00, 0x0000FF, 0xFFFFFF, 10, "Arial")
		
		Local $Each = stringsplit($aDiffAdded,",")
		For $r = 1 to UBound($Each)-1
			       Soundplay(@WindowsDir & "\Media\Windows Exclamation.wav", 0)
			ConsoleWrite($Each[$r] & @CRLF)	
						
		$aRet = _Toast_Show(0, "Party Players Chat", $Each[$r]& @CRLF & @CRLF & "is On line", 3)
        	Next	
		_Toast_Hide()
	EndIf

If $aDiffGone <> "" Then 
		;MsgBox(0, "Result", 'Person/s gone = "' & _StringStripComma($sDiffGo) & '"') ; Remove comma. ; use instead of Toast
		; popup a toast message
		$sMsg  = _StringStripComma($aDiffGone & @CRLF & @CRLF & "Offline")  ;
        ;Soundplay(@WindowsDir & "\Media\Windows Exclamation.wav", 0)
        _Toast_Set(5, 0xFF0011, 0xFFFF00, 0x0000FF, 0xFFFFFF, 10, "Arial")
        
	Local $Each = stringsplit($aDiffGone,",")
		For $r = 1 to UBound($Each)-1
			       Soundplay(@WindowsDir & "\Media\Windows Exclamation.wav", 0)
			ConsoleWrite($Each[$r] & @CRLF)	
						
		$aRet = _Toast_Show(0, "Party Players Chat", $Each[$r]& @CRLF & "is Off line", 3)
        	Next	
        
		_Toast_Hide()
	EndIf

Else
    ;MsgBox(0, "Result", 'Both strings the same')
	; no message needed
EndIf

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




; -------------------------------------------------
; Function:  _StringDiff
; Purpose:  Returns a string from $sString1 that do not occur in $sString2.
;                               i.e.  _StringDiff = $sString2 - $sString1
; Syntax:   _StringDiff(ByRef $avString1, ByRef $avString2 [, $f_CaseSense = 0 ,[$sDelimiter = ","}})
;   Where:  $sString1 = Source string
;           $sString2 = String to search for in $sString1 string
;           $f_CaseSense (optional) = Case sensitivity as passed to StringInStr()
;               0 = not case sensitive, using the user's locale (default)
;               1 = case sensitive
;               2 = not case sensitive, using a basic/faster comparison
;                       $sDelimiter = One or more characters to use as delimiters (case sensitive).
; Returns:  On success returns a string from $sString1 that do not occur in $sString2
;               If all elements in $sString1 occur in $sString2 then "" is returned
; Author:   Malkey
; Notes:    Based on PsaltyDS's _ArrayDiff function on www.autoitscript.com/forum
; --------------------------------------------------
Func _StringDiff($sString1, $sString2, $f_CaseSense = 0, $sDelimiter = ",")
    Local  $sRET = ""
    $sString2 = $sDelimiter & $sString2 & $sDelimiter
    Local $aArray1 = StringSplit($sString1, $sDelimiter, 2)
    For $n = 0 To UBound($aArray1) - 1
        If Not StringInStr($sString2, $sDelimiter & $aArray1[$n] & $sDelimiter, $f_CaseSense) Then $sRET &= $aArray1[$n] & $sDelimiter
    Next
    If StringLen($sRET) Then
        $sRET = StringTrimRight($sRET, 1)
    EndIf
    Return $sRET
EndFunc   ;==>_StringDiff

