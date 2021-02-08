#cs
    
    GetExplorerModules
    
    (Thanks to monoceres & ProgAndy for UDF)
    
    I needed a different method to locate dll virus hooks in Explorer.
    This is the result of the effort which gives clues for determining that.
    
#ce

#include <WinAPI.au3>
#include <Array.au3>

Local $pglm = _ProcessGetLoadedModules(ProcessExists('explorer.exe'))
_ArrayDisplay($pglm, 'Loaded Explorer Modules')

; modified by ripdad to give file info - June 12, 2010
; ----------------------------------------------------------------------------------------
; Name...........: _ProcessGetLoadedModules
; Syntax.........: _ProcessGetLoadedModules($iPID)
; Return values .: Success - An array with all the paths
;                : Failure - -1 and @error=1 if the specified process couldn't be opened.
; Author ........: Andreas Karlsson (monoceres) & ProgAndy
; ----------------------------------------------------------------------------------------
Func _ProcessGetLoadedModules($iPID)
    Local Const $PROCESS_QUERY_INFORMATION = 0x0400
    Local Const $PROCESS_VM_READ = 0x0010
    Local $aCall, $hPsapi = DllOpen("Psapi.dll")
    Local $hProcess, $tModulesStruct
    $tModulesStruct = DllStructCreate("hwnd [200]")
    Local $SIZEOFHWND = DllStructGetSize($tModulesStruct) / 200
    $hProcess = _WinAPI_OpenProcess(BitOR($PROCESS_QUERY_INFORMATION, $PROCESS_VM_READ), False, $iPID)
    If Not $hProcess Then Return SetError(1, 0, -1)
    $aCall = DllCall($hPsapi, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($tModulesStruct), "dword", DllStructGetSize($tModulesStruct), "dword*", "")
    If $aCall[4] > DllStructGetSize($tModulesStruct) Then
        $tModulesStruct = DllStructCreate("hwnd [" & $aCall[4] / $SIZEOFHWND & "]")
        $aCall = DllCall($hPsapi, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($tModulesStruct), "dword", $aCall[4], "dword*", "")
    EndIf
    Local $aReturn[$aCall[4] / $SIZEOFHWND][6] = [['Enumerated', 'Date Created', 'Date Modified', 'File Version', 'File Description', 'Company Name']]
    For $i = 1 To UBound($aReturn) - 1
        $aCall = DllCall($hPsapi, "dword", "GetModuleFileNameExW", "ptr", $hProcess, "ptr", DllStructGetData($tModulesStruct, 1, $i + 1), "wstr", "", "dword", 65536)
        $aReturn[$i][0] = $aCall[3]
        If FileExists($aReturn[$i][0]) Then
            $fgd = FileGetTime($aReturn[$i][0], 1)
            $aReturn[$i][1] = ($fgd[1] & "/" & $fgd[2] & "/" & $fgd[0])
            $fgd = FileGetTime($aReturn[$i][0], 0)
            $aReturn[$i][2] = ($fgd[1] & "/" & $fgd[2] & "/" & $fgd[0])
            $aReturn[$i][3] = FileGetVersion($aReturn[$i][0])
            $aReturn[$i][4] = FileGetVersion($aReturn[$i][0], 'FileDescription')
            $aReturn[$i][5] = FileGetVersion($aReturn[$i][0], 'CompanyName')
        EndIf
    Next
    $aReturn[0][0] = $i - 1
    _WinAPI_CloseHandle($hProcess)
    DllClose($hPsapi)
    _ArraySort($aReturn, 0, 1)
    Return $aReturn
EndFunc
