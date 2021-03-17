#include <Misc.au3>

Local $msg = 4

MsgBox(4096, "Message", "The original way...")
While $msg = 4
    Local $txt, $num = Random(1, 6, 1)

    Switch $num
        Case 1
            $txt = "Number 1 was chosen!"
        Case 2
            $txt = "This is what shows for #2"
        Case 3
            $txt = "3 is a magic number."
        Case 4
            $txt = "Twas a 4"
        Case Else
            $txt = "Uh oh! I don't know about " & $num & ", sorry."
    EndSwitch

    $msg = MsgBox(5+32, "Traditional Case Method", $txt)
WEnd

$msg = 4
MsgBox(4096, "Message", "Using nested _Iifs")
While $msg = 4
    $num = Random(1, 6, 1)
    $msg = MsgBox(5+32, "Using _Iif", _Iif($num=1, "Number 1 was chosen!", _Iif($num=2, "This is what shows for #2", _Iif($num=3, "3 is a magic number.", _Iif($num=4, "Twas a 4", "Uh oh! I don't know about " & $num & ", sorry.")))))
WEnd

$msg = 4
MsgBox(4096, "Message", "The better way...")
While $msg = 4
    $msg = MsgBox(5+32, "Using _ICase", _ICase(Random(1, 6, 1), "1|2|3|4", "Number 1 was chosen!|This is what shows for #2|3 is a magic number.|Twas a 4", "Uh oh! I don't know about %s, sorry."))
WEnd

; #FUNCTION# ====================================================================================================================
; Name ..........: _ICase
; Description ...: Returns values based on other values (case-like) from delimited strings.
; Syntax ........: _ICase($sValue, $sValues, $sReturns, $sElse[, $sDelimiter = "|"])
; Parameters ....: $sValue              - The value to match.
;                  $sValues             - A string of values delimited by $sDelimiter.
;                  $sReturns            - A string of returns delimited by $sDelimiter.
;                  $sElse               - A string value to return if there are no matches.
;                  $sDelimiter          - [optional] The delimiter to use in the strings. Default is "|".
; Return values .: Success: The string associated with a match to $sValue. May set @error:
;                           1 - Returns had to be expanded to avoid subscript errors;
;                               some results may return blank
;                  Failure: $sElse, formatted with $sValue (see StringFormat)
; Author ........: cyberbit
; Modified ......: 08.09.13
; Remarks .......:
; Related .......: _Iif
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ICase($sValue, $sValues, $sReturns, $sElse, $sDelimiter = "|")
    $aValues = StringSplit($sValues, $sDelimiter)
    $aReturns = StringSplit($sReturns, $sDelimiter)

    If $aValues[0] > $aReturns[0] Then
        ReDim $aReturns[$aValues[0]+1]
        SetError(1)
    EndIf

    For $i = 1 To $aValues[0]
        If $sValue = $aValues[$i] Then Return $aReturns[$i]
    Next

    Return SetError(2, 0, StringFormat($sElse, $sValue))
EndFunc