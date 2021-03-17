#include <APIConstants.au3>
#include <WinAPIEx.au3>

$sTestPath = "C:Test.txt"

ConsoleWrite("_GetFileType (Test path): " & _GetFileType($sTestPath) & @CRLF)
ConsoleWrite("_GetFileType (Script path): " & _GetFileType(@ScriptFullPath) & @CRLF)
ConsoleWrite("_GetFileType (Script directory): " & _GetFileType(@ScriptDir) & @CRLF)
ConsoleWrite("_GetFileTypeByDll (Test path): " & _GetFileTypeByDll($sTestPath) & @CRLF)
ConsoleWrite("_GetFileTypeByDll (Script path): " & _GetFileTypeByDll(@ScriptFullPath) & @CRLF)
ConsoleWrite("_GetFileTypeByDll (Script directory): " & _GetFileTypeByDll(@ScriptDir) & @CRLF)

;#FUNCTION# ======================================================================================
; Name...........: _GetFileType
; Description ...: Returns a String representing the type of the file at $sFilePath.
; Syntax.........: _GetFileType($sFilePath)
; Parameters ....: $sFilePath - The filename to parse for a filetype (must exist if directory)
; Return values .: Success - return String filetype
;                  Failure - set @error:
;                    [1]  Directory Tree
;                    [2]  <Unknown>
; Authors .......: cyberbit, guinness
; Modified.......: 10/16/2012
; Remarks .......: Returns system global type association.
; Related .......: _GetFileTypeByDll
; Link ..........:
; Example .......:
; =================================================================================================
Func _GetFileType($sFilePath)
   If StringInStr(FileGetAttrib($sFilePath), 'D') <> 0 Then Return SetError(1, 0, 'Directory Tree')
   Local $sRegRead = RegRead('HKEY_CLASSES_ROOT' & RegRead('HKEY_CLASSES_ROOT.' & StringRegExpReplace($sFilePath, '.*.', ''), ''), '')
   If $sRegRead Then Return $sRegRead
   Return SetError(2, 0, '<Unknown>')
EndFunc   ;==>_GetFileType

;#FUNCTION# ======================================================================================
; Name...........: _GetFileTypeByDll
; Description ...: Returns a String representing the type of the file at $sFilePath. Respects user
;                  associations for file types.
; Syntax.........: _GetFileTypeByDll($sFilePath)
; Parameters ....: $sFilePath - The filename to parse for a filetype (must exist if directory)
; Return values .: Success - return String filetype
;                  Failure - set @error:
;                    [1]  Directory Tree
;                    [2]  <Unknown>
; Authors .......: cyberbit, guinness
; Modified.......: 10/16/2012
; Remarks .......: Returns local user type association.
; Related .......: _GetFileType
; Link ..........:
; Example .......:
; =================================================================================================
Func _GetFileTypeByDll($sFilePath)
   If StringInStr(FileGetAttrib($sFilePath), 'D') <> 0 Then Return SetError(1, 0, 'Directory Tree')
   Local $sAssocQuery = _WinAPI_AssocQueryString(_WinAPI_PathFindExtension($sFilePath), $ASSOCSTR_FRIENDLYDOCNAME)
   If $sAssocQuery Then Return $sAssocQuery
   Return SetError(2, 0, '<Unknown>')
EndFunc   ;==>_GetFileTypeByDll
