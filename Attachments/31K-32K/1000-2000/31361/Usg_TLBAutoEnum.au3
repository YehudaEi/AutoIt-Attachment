; ------------------------------------------------------------------------------
;
; Version:        1.0.0
; AutoIt Version: 3.3.4.0
; Language:       English
; Author:         doudou
; Description:    Example application for TLBAutoEnum.
; $Revision: $
; $Date:  $
;
; ------------------------------------------------------------------------------
#include "TLBAutoEnum.au3"

Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
_AutoItObject_Startup()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Method 1
; load enums from TypeLib files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; import all MSXML enums
Dim $szFile = "C:\WINDOWS\system32\msxml.dll"
_TLBAutoEnum_ImportFile($szFile, "*")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & $szFile & "]")

; import all Scripting enums
$szFile = "C:\WINDOWS\system32\scrrun.dll"
_TLBAutoEnum_ImportFile($szFile, "*")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & $szFile & "]")

; import single enum from Shell32
$szFile = "C:\WINDOWS\system32\shell32.dll"
_TLBAutoEnum_ImportFile($szFile, "ShellSpecialFolderConstants")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & $szFile & "]")

For $i = 0 To UBound($_TLBAutoEnum_imported) - 1
    ConsoleWrite("Imported From Files: " & $_TLBAutoEnum_imported[$i] & @lf)
Next
DisplayImports("Values Imported From TLB Files")
_TLBAutoEnum_CleanupImports()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Method 2
; load enums from registry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; import all MSXML enums
Dim $guid = "{D63E0CE2-A0A2-11D0-9C02-00C04FC99C8E}"
_TLBAutoEnum_ImportReg($guid, "*", 2)
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & $guid & "]")

; import all Scripting enums
$guid = "{420B2830-E718-11CF-893D-00A0C9054228}"
_TLBAutoEnum_ImportReg($guid, "*")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & $guid & "]")

; import single enum from Shell32
$guid = "{50A7E9B0-70EF-11D1-B75A-00A0C90564FE}"
_TLBAutoEnum_ImportReg($guid, "ShellSpecialFolderConstants")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & $guid & "]")

For $i = 0 To UBound($_TLBAutoEnum_imported) - 1
    ConsoleWrite("Imported From Reg: " & $_TLBAutoEnum_imported[$i] & @lf)
Next
DisplayImports("Values Imported From Registry")
_TLBAutoEnum_CleanupImports()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Method 3
; load enums from TypeLib related to an object
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; import all MSXML enums
Dim $obj = ObjCreate("Microsoft.XMLDOM")
_TLBAutoEnum_ImportRelated($obj, "*")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & ObjName($obj) & "]")

; import all Scripting enums
$obj = ObjCreate("Scripting.Dictionary")
_TLBAutoEnum_ImportRelated($obj, "*")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & ObjName($obj) & "]")

; import single enum from Shell32
$obj = ObjCreate("Shell.Application")
_TLBAutoEnum_ImportRelated($obj, "ShellSpecialFolderConstants")
If @error Then MsgBox(0, "TLBAutoEnum", "Error importing [" & ObjName($obj) & "]")

For $i = 0 To UBound($_TLBAutoEnum_imported) - 1
    ConsoleWrite("Imported From Related: " & $_TLBAutoEnum_imported[$i] & @lf)
Next
DisplayImports("Related Values Imported")
_TLBAutoEnum_CleanupImports()

Func DisplayImports($title)
    Local $info = ""
    ; read some MSXML constants
    $info &= $DOMNodeType._EnumName & ".NODE_ELEMENT=" & $DOMNodeType.NODE_ELEMENT & @crlf
    $info &= $DOMNodeType._EnumName & ".NODE_ATTRIBUTE=" & $DOMNodeType.NODE_ATTRIBUTE & @crlf
    $info &= $DOMNodeType._EnumName & ".NODE_TEXT=" & $DOMNodeType.NODE_TEXT & @crlf
    $info &= @crlf
    ; read some Scripting constants
    $info &= $FileAttribute._EnumName & ".Normal=" & $FileAttribute.Normal & @crlf
    $info &= $FileAttribute._EnumName & ".ReadOnly=" & $FileAttribute.ReadOnly & @crlf
    $info &= $FileAttribute._EnumName & ".Hidden=" & $FileAttribute.Hidden & @crlf
    $info &= $DriveTypeConst._EnumName & ".Removable=" & $DriveTypeConst.Removable & @crlf
    $info &= $DriveTypeConst._EnumName & ".Fixed=" & $DriveTypeConst.Fixed & @crlf
    $info &= $DriveTypeConst._EnumName & ".Remote=" & $DriveTypeConst.Remote & @crlf
    $info &= @crlf
    ; read some Shell32 constants
    $info &= $ShellSpecialFolderConstants._EnumName & ".ssfDESKTOP=" & $ShellSpecialFolderConstants.ssfDESKTOP & @crlf
    $info &= $ShellSpecialFolderConstants._EnumName & ".ssfPROGRAMS=" & $ShellSpecialFolderConstants.ssfPROGRAMS & @crlf
    $info &= $ShellSpecialFolderConstants._EnumName & ".ssfCONTROLS=" & $ShellSpecialFolderConstants.ssfCONTROLS & @crlf
    
    MsgBox(0, $title, $info)
EndFunc

Func _ErrFunc()
    ConsoleWrite("! COM Error !  Number: 0x" & Hex($oError.number, 8) & "   ScriptLine: " & $oError.scriptline & " - " & $oError.windescription & @CRLF)
    Return
EndFunc   ;==>_ErrFunc
