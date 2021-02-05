; ------------------------------------------------------------------------------
;
; Version:        1.1.1
; AutoIt Version: 3.3.4.0
; Language:       English
; Author:         doudou
; Description:    Usage examples for AIOStructMgd.
; $Revision: 1.2 $
; $Date: 2010/04/08 18:09:42 $
;
; ------------------------------------------------------------------------------
#include <AIOStructMgd.au3>

Global Const $tagOSVERSIONINFOEX = "DWORD dwOSVersionInfoSize; DWORD dwMajorVersion; DWORD dwMinorVersion; DWORD dwBuildNumber; DWORD dwPlatformId; CHAR szCSDVersion[128]; WORD  wServicePackMajor; WORD  wServicePackMinor; WORD  wSuiteMask; BYTE  wProductType; BYTE  wReserved"

_AutoItObject_Startup()
Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")

; create managed struct
Dim $objStruct = AIOStructMgd_New($tagOSVERSIONINFOEX)
; set some elements
$objStruct.dwOSVersionInfoSize = $objStruct.StructSize
; call an API function with the struct pointer 
Dim $res = DllCall("kernel32.dll", "bool", "GetVersionEx", "ptr", $objStruct.GetPtr())
If $res[0] Then
    ; sync changed struct data
    If $objStruct.ElementCount > $objStruct.UpdateStruct() Then ConsoleWrite("Failed to sync struct" & @LF)
    ConsoleWrite("tagOSVERSIONINFOEX {" & @LF)
    ; retrieve all elements
    For $i = 0 To $objStruct.ElementCount - 1
        ConsoleWrite("    " & $objStruct.GetElementName($i) & "=" & $objStruct.GetData($i) & @LF)
    Next
    ConsoleWrite("}" & @LF)
Else
    ConsoleWrite("Error calling GetVersionEx" & @LF)
EndIf

; call an API function with element pointer
$res = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $objStruct.GetPtr("szCSDVersion"))
ConsoleWrite("Length of szCSDVersion: " & $res[0] & @LF)

; release the struct
$objStruct = 0
If @error Then ConsoleWrite("Error clearing memory" & @LF)

Func _ErrFunc()
    ConsoleWrite("! COM Error !  Number: 0x" & Hex($oError.number, 8) & "   ScriptLine: " & $oError.scriptline & " - " & $oError.windescription & @CRLF)
    Return
EndFunc   ;==>_ErrFunc
