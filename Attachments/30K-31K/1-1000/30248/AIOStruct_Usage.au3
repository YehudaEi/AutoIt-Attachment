; ------------------------------------------------------------------------------
;
; Version:        1.1.0
; AutoIt Version: 3.3.4.0
; Language:       English
; Author:         doudou
; Description:    Usage examples for AIOStruct.
; $Revision: 1.2 $
; $Date: 2010/04/08 16:11:24 $
;
; ------------------------------------------------------------------------------
#include <AIOStruct.au3>

_AutoItObject_Startup()
Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")

Global Const $tagTIME_ZONE_INFORMATION = "long Bias;wchar StdName[32];word StdDate[8];long StdBias;wchar DayName[32];word DayDate[8];long DayBias"
Global Const $tagMARGINS = "int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight"

; create empty struct
Dim $objStruct = AIOStruct_New($tagMARGINS)
; set data
$objStruct.cxLeftWidth = 1
$objStruct.cxRightWidth = 2
; non-existent, throws error
ConsoleWrite("VVVVV Expected Error Follows VVVVV" & @LF)
$objStruct.Nonsense = 3

; retrieve some elements
ConsoleWrite("cxLeftWidth=" & $objStruct.cxLeftWidth & ", cxRightWidth=" & $objStruct.cxRightWidth & @lf)

; retrieve all elements
For $i = 0 To $objStruct.ElementCount - 1
    If 0 < $i Then ConsoleWrite(", ")
    ConsoleWrite($objStruct.GetElementName($i) & "=" & $objStruct.GetData($i))
Next
ConsoleWrite(@LF)

;create struct with initial data
Dim $struct = DllStructCreate($tagTIME_ZONE_INFORMATION)
DllStructSetData($struct, "DayName", "Monday")
DllStructSetData($struct, "DayDate", 1, 1)
DllStructSetData($struct, "DayDate", 2, 2)
$objStruct = AIOStruct_New($tagTIME_ZONE_INFORMATION, DllStructGetPtr($struct))
; set data
$objStruct.Bias = 1
$objStruct.StdName = "Name"
; preferred way to set array data
Dim $dwArr[8] = [1, 2]
$objStruct.StdDate = $dwArr
; alternate way to set array data
$objStruct.SetData("StdDate", 3, 2)

; non-existent, throws error
ConsoleWrite("VVVVV Expected Error Follows VVVVV" & @LF)
$objStruct.Nonsense = 3

; retrieve some elements
ConsoleWrite("Bias=" & $objStruct.Bias & ", StdName=" & $objStruct.StdName & @lf)

; retrieve all elements
For $i = 0 To $objStruct.ElementCount - 1
    If 0 < $i Then ConsoleWrite(", ")
    ConsoleWrite($objStruct.GetElementName($i) & "=" & $objStruct.GetData($i))
Next
ConsoleWrite(@LF)

; convert back to DllStruct
$struct = _AIOStruct_ToDllStruct($objStruct)
ConsoleWrite("tagTIME_ZONE_INFORMATION.StdName=" & DllStructGetData($struct, "StdName") & _
    ", tagTIME_ZONE_INFORMATION.StdDate[2]=" & DllStructGetData($struct, "StdDate", 3) & _
    ", tagTIME_ZONE_INFORMATION.DayDate[1]=" & DllStructGetData($struct, "DayDate", 2) & @LF)

; change struct directly (like an API call would do)
DllStructSetData($struct, "DayName", "Tuesday")
; push it back to object
If $objStruct.ElementCount > $objStruct.ReadStruct(Number(DllStructGetPtr($struct))) Then
    ConsoleWrite("Error reading struct" & @LF)
Else
    ; retrieve changed elements
    ConsoleWrite("DayName=" & $objStruct.DayName & @lf)
EndIf

$objStruct = 0

Func _ErrFunc()
    ConsoleWrite("! COM Error !  Number: 0x" & Hex($oError.number, 8) & "   ScriptLine: " & $oError.scriptline & " - " & $oError.windescription & @CRLF)
    Return
EndFunc   ;==>_ErrFunc
