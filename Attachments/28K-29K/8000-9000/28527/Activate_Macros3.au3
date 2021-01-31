#include <Excel.au3>

$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

$oExcel = _ExcelBookOpen("E:\NEW.xlsm", 1)
If @error Then
    ConsoleWrite("Error opening Excel Workbook" & @CR)
    Exit
EndIf

Global Const $XL_msoAutomationSecurityLow = 0x1 ; Allow all macros
Global Const $XL_msoAutomationSecurityByUI = 0x2 ;  As set in the Trust Center UI
Global Const $XL_msoAutomationSecurityForceDisable = 0x3 ; Disable macros (default)

$AutomationSecurity_Save = $oExcel.AutomationSecurity

	msgbox(64,"Info 1", "before")
	_ExcelMacroRun($oExcel, "Tabelle1.delete_values")
	$oExcel.AutomationSecurity = $XL_msoAutomationSecurityLow
	msgbox(64,"Info 2", "after")

$oExcel.Workbooks.close
$oExcel.Quit

;===============================================================================
;
; Function Name:    _ExcelMacroRun()
; Description:      Runs a Visual Basic macro
; Parameter(s):     $o_object           - Object variable of a Excel.Application object
;                   $s_MacroName        - The name of the macro. Can be any combination of template,
;                                           module, and macro name. (See Remarks)
;                   $v_Arg1             - Optional: The first parameter to pass to the macro
;                   ...                 ...
;                   $v_Arg30            - Optional: The thirtieth parameter to pass to the macro
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success  - Returns 1
;                   On Failure  - Returns 0 and sets @ERROR
;                   @ERROR      - 0 No Error
;                               - 2 Com Error
;                               - 3 Invalid Data Type
;                   @Extended   - Contains invalid parameter number
; Remark(s):
; Author(s):        Bob Anthony (big_daddy)
;
;===============================================================================
;
Func _ExcelMacroRun(ByRef $o_object, $s_MacroName, $v_Arg1 = Default, $v_Arg2 = Default, $v_Arg3 = Default, $v_Arg4 = Default, $v_Arg5 = Default, $v_Arg6 = Default, $v_Arg7 = Default, $v_Arg8 = Default, $v_Arg9 = Default, $v_Arg10 = Default, $v_Arg11 = Default, $v_Arg12 = Default, $v_Arg13 = Default, $v_Arg14 = Default, $v_Arg15 = Default, $v_Arg16 = Default, $v_Arg17 = Default, $v_Arg18 = Default, $v_Arg19 = Default, $v_Arg20 = Default, $v_Arg21 = Default, $v_Arg22 = Default, $v_Arg23 = Default, $v_Arg24 = Default, $v_Arg25 = Default, $v_Arg26 = Default, $v_Arg27 = Default, $v_Arg28 = Default, $v_Arg29 = Default, $v_Arg30 = Default)

    If Not IsObj($o_object) Then
        SetError(3, 1)
        Return 0
    EndIf
    ;
    $o_object.Run($s_MacroName, $v_Arg1, $v_Arg2, $v_Arg3, $v_Arg4, $v_Arg5, _
            $v_Arg6, $v_Arg7, $v_Arg8, $v_Arg9, $v_Arg10, _
            $v_Arg11, $v_Arg12, $v_Arg13, $v_Arg14, $v_Arg15, _
            $v_Arg16, $v_Arg17, $v_Arg18, $v_Arg19, $v_Arg20, _
            $v_Arg21, $v_Arg22, $v_Arg23, $v_Arg24, $v_Arg25, _
            $v_Arg26, $v_Arg27, $v_Arg28, $v_Arg29, $v_Arg30)

    If @error Then
        SetError(2)
        Return 0
    EndIf

    SetError(0)
    Return 1
EndFunc   ;==>_ExcelMacroRun

Func MyErrFunc()

    ConsoleWrite("We intercepted a COM Error !" & @CRLF & @CRLF & _
            "err.description is: " & @TAB & $oMyError.description & @CRLF & _
            "err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
            "err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
            "err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
            "err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
            "err.source is: " & @TAB & $oMyError.source & @CRLF & _
            "err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
            "err.helpcontext is: " & @TAB & $oMyError.helpcontext & @CRLF)

    Local $err = $oMyError.number
    If $err = 0 Then $err = -1

    $g_eventerror = $err ; to check for after this function returns
EndFunc   ;==>MyErrFunc

