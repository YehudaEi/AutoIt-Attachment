#include-once

; #INDEX# ======================================================================
; Title .........: 7Zip.au3
; Version  ......: 1.0
; Language ......: English
; Author(s) .....: R. Gilman (rasim), James Ciasullo (Deltaforce229), dany
; Link ..........:
; Description ...: AutoIt UDF for 7-zip32.dll by Minoru Akita.
; Remarks .......: Doesn't support scripts running in 64-bit as there is no 64-bit
;                  version of this dll currently available.
;                  Main site: http://akky.xrea.jp/download/7-zip32.html
;                  Mirror: http://www.madobe.net/archiver/lib/7-zip32.html
;                  Mirror: http://www.csdinc.co.jp/archiver/lib/7-zip32.html
; ==============================================================================

; #CURRENT# ====================================================================
;_7Zip_Startup
;_7Zip_Shutdown
;_7Zip_FreeOwnerWindowCallback
;_7Zip_Add
;_7Zip_CreateSFX
;_7Zip_CreateSFXEx
;_7Zip_Delete
;_7Zip_Download7Zip32Dll
;_7Zip_Extract
;_7Zip_ExtractEx
;_7Zip_Update
;_7Zip
;_7Zip_CheckArchive
;_7Zip_ClearOwnerWindow
;_7Zip_CloseArchive
;_7Zip_ConfigDialog
;_7Zip_FindFirst
;_7Zip_FindNext
;_7Zip_GetAccessTime
;_7Zip_GetAccessTimeEx
;_7Zip_GetArcAccessTimeEx
;_7Zip_GetArcCompressedSize
;_7Zip_GetArcCompressedSizeEx
;_7Zip_GetArcCreateTimeEx
;_7Zip_GetArcDate
;_7Zip_GetArcFileName
;_7Zip_GetArcFileSize
;_7Zip_GetArcFileSizeEx
;_7Zip_GetArchiveType
;_7Zip_GetArcOriginalSize
;_7Zip_GetArcOriginalSizeEx
;_7Zip_GetArcOSType
;_7Zip_GetArcRatio
;_7Zip_GetArcTime
;_7Zip_GetArcWriteTimeEx
;_7Zip_GetAttribute
;_7Zip_GetBackGroundMode
;_7Zip_GetCompressedSize
;_7Zip_GetCompressedSizeEx
;_7Zip_GetCRC
;_7Zip_GetCreateTime
;_7Zip_GetCreateTimeEx
;_7Zip_GetCursorInterval
;_7Zip_GetCursorMode
;_7Zip_GetDate
;_7Zip_GetDefaultPassword
;_7Zip_GetFileCount
;_7Zip_GetFileName
;_7Zip_GetMethod
;_7Zip_GetOriginalSize
;_7Zip_GetOriginalSizeEx
;_7Zip_GetOSType
;_7Zip_GetRatio
;_7Zip_GetRunning
;_7Zip_GetSubVersion
;_7Zip_GetTime
;_7Zip_GetVersion
;_7Zip_GetWriteTime
;_7Zip_GetWriteTimeEx
;_7Zip_IsSFXFile
;_7Zip_KillOwnerWindowEx
;_7Zip_KillOwnerWindowEx64
;_7Zip_OpenArchive
;_7Zip_PasswordDialog
;_7Zip_QueryFunctionList
;_7Zip_SetBackGroundMode
;_7Zip_SetCursorInterval
;_7Zip_SetCursorMode
;_7Zip_SetDefaultPassword
;_7Zip_SetOwnerWindow
;_7Zip_SetOwnerWindowEx
;_7Zip_SetOwnerWindowEx64
;_7Zip_SetPriority
;_7Zip_SetUnicodeMode
; ==============================================================================

; #INTERNAL_USE_ONLY# ==========================================================
;__7Zip_SetDllPath
;__7Zip_COMErrorFunc
;__7Zip_GetCommand
;__7Zip_Quote
;__7Zip_RecursionSet
;__7Zip_OverwriteSet
;__7Zip_IncludeFileSet
;__7Zip_ExcludeFileSet
;__7Zip_IncludeArcSet
;__7Zip_ExcludeArcSet
;__7Zip_GetSFXCommand
; ==============================================================================

#Region Public constants and variables.
; Int: @error return codes.
Global Enum $E_7ZIP_DLL_FILE_UNUSABLE = 1, $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE, _
        $E_7ZIP_DLL_FUNCTION_NOT_FOUND, _
        $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS, $E_7ZIP_DLL_BAD_PARAMETER, _
        $E_7ZIP_BAD_FUNCTION_ARGUMENT, _
        $E_7ZIP_64BIT_UNSUPPORTED, _
        $E_7ZIP_DLL_NOT_FOUND, $E_7ZIP_SFX_NOT_FOUND, _
        $E_7ZIP_DLL_NOT_LOADED, _
        $E_7ZIP_NO_UNZIP_SUPPORT, $E_7ZIP_DOWNLOAD_FAILED, $E_7ZIP_DOWNLOAD_UNZIP_FAILED

; Int: Maximum filename length.
Global Const $7ZIP_FNAME_MAX32 = 512

; String: FILETIME Structure from StructureConstants.au3.
Global Const $7ZIP_TAG_FILETIME = 'struct;dword Lo;dword Hi;endstruct'

; src\7-zip32.h
; String: INDIVIDUALINFO Structure.
Global Const $7ZIP_TAG_INDIVIDUALINFO = 'dword dwOriginalSize;' & _
        'dword dwCompressedSize;' & _
        'dword dwCRC;' & _
        'uint uFlag;' & _
        'uint uOSType;' & _
        'word wRatio;' & _
        'word wDate;' & _
        'word wTime;' & _
        'char szFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy1[3];' & _
        'char szAttribute[8];' & _
        'char szMode[8]'
#EndRegion Public constants and variables.

#Region Private constants and variables.
; #INTERNAL_USE_ONLY# ==========================================================
Global Const $__7ZIP_DLL = '7-zip32.dll'
Global Const $__7ZIP_DLL_DOWNLOAD_LINK = 'http://akky.xrea.jp/cgi-bin/download.cgi?7-zip32' & _
        '|http://www.csdinc.co.jp/archiver/lib/7z920002.zip' & _
        '|http://www.madobe.net/archiver/lib/7z920002.zip'

Global $__7Zip_sDllDir = @ScriptDir & '\Res'
Global $__7Zip_sDllPath = $__7Zip_sDllDir & '\' & $__7ZIP_DLL
Global $__7Zip_hDll = -1
Global $__7Zip_hArchiveProc
; ==============================================================================
#EndRegion Private constants and variables.

#Region Startup and shutdown fuctions.
; #FUNCTION# ===================================================================
; Name...........: _7Zip_Startup
; Description ...: Loads 7-zip32.dll.
; Syntax.........: _7Zip_Startup([$sDllPath [, $fForce]])
; Parameters ....: $sDllPath - String: Path to 7-zip32.dll. Default path is @ScriptDir & '\7-zip32.dll'.
;                  $fForce - Boolean: Force reload of 7-zip32.dll.
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |7 $E_7ZIP_64BIT_UNSUPPORTED
;                  |8 $E_7ZIP_DLL_NOT_FOUND
; Author ........: James Ciasullo (Deltaforce229)
; Modified ......: dany
; Remarks .......: Registers _7Zip_Shutdown as callback when AutoIt exits.
; Related .......: _7Zip_Shutdown
; ==============================================================================
Func _7Zip_Startup($sDllPath = Default, $fForce = False)
    If Not $fForce And -1 <> $__7Zip_hDll Then Return 1
    If @AutoItX64 Then Return SetError($E_7ZIP_64BIT_UNSUPPORTED, 0, 0)
    If Not IsString($sDllPath) Or '' = $sDllPath Then $sDllPath = $__7Zip_sDllPath
    If Not FileExists($sDllPath) Then
        $sDllPath = $__7Zip_sDllPath
        If Not FileExists($sDllPath) Then
            $sDllPath = @SystemDir & '\' & $__7ZIP_DLL ; Look in @SystemDir.
            If Not FileExists($sDllPath) Then Return SetError($E_7ZIP_DLL_NOT_FOUND, 0, 0)
        EndIf
    EndIf
    If $fForce Then _7Zip_Shutdown()
    $__7Zip_hDll = DllOpen($sDllPath)
    If @error Then Return SetError(@error, 0, 0)
    __7Zip_SetDllPath($sDllPath)
    OnAutoItExitRegister('_7Zip_Shutdown')
    Return 1
EndFunc   ;==>_7Zip_Startup

; #FUNCTION# ===================================================================
; Name...........: _7Zip_Shutdown
; Description ...: Unloads 7-zip32.dll and frees the callback, if used.
; Syntax.........: _7Zip_Shutdown()
; Parameters ....: None.
; Return values .: None.
; Author ........: James Ciasullo (Deltaforce229)
; Modified ......: dany
; Remarks .......: Registered on AutoIt exit by _7Zip_Startup. Unregisters itself
;                  when called.
; Related .......: _7Zip_Startup
; ==============================================================================
Func _7Zip_Shutdown()
    $__7Zip_hDll = DllClose($__7Zip_hDll)
    _7Zip_FreeOwnerWindowCallback()
    OnAutoItExitUnRegister('_7Zip_Shutdown')
EndFunc   ;==>_7Zip_Shutdown

; #FUNCTION# ===================================================================
; Name...........: _7Zip_FreeOwnerWindowCallback
; Description ...:
; Syntax.........: _7Zip_FreeOwnerWindowCallback()
; Parameters ....: None.
; Return values .: Int: Returns 1, always.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_FreeOwnerWindowCallback()
    $__7Zip_hArchiveProc = DllCallbackFree($__7Zip_hArchiveProc)
    Return 1
EndFunc   ;==>_7Zip_FreeOwnerWindowCallback
#EndRegion Startup and shutdown fuctions.

#Region Extra 7-zip functions.
; #FUNCTION# ===================================================================
; Name...........: _7Zip_Add
; Description ...:
; Syntax.........: _7Zip_Add($hWnd, $sArcName, $sFileNames [, $iHide [, $iCompress [, $iRecurse [, $sIncludeFiles [, $sExcludeFiles [, $sPassword [, $iSFX [, $iVolume [, $sWorkDir]]]]]]]]])
; Parameters ....: $hWnd   - HWnd:
;                  $sArcName - String:
;                  $sFileNames - String:
;                  $iHide  - Int:
;                  $iCompress - Int:
;                  $iRecurse - Int:
;                  $sIncludeFiles - String:
;                  $sExcludeFiles - String:
;                  $sPassword - String:
;                  $iSFX   - Int:
;                  $iVolume - Int:
;                  $sWorkDir - String:
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_Add($hWnd, $sArcName, $sFileNames, $iHide = 0, $iCompress = 5, $iRecurse = 1, $sIncludeFiles = 0, $sExcludeFiles = 0, $sPassword = 0, $iSFX = 0, $iVolume = 0, $sWorkDir = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $sCopyCMD = __7Zip_GetCommand($iHide, $iCompress, $iRecurse, 0, 0, 0, $sIncludeFiles, $sExcludeFiles, $sPassword, $iVolume, $sWorkDir, 0)
    $sCopyCMD = 'a ' & __7Zip_Quote($sArcName) &  ' ' & __7Zip_Quote($sFileNames) & ' ' & $sCopyCMD
    Local $sRes = _7Zip($hWnd, $sCopyCMD)
    Return SetError(@error, 0, $sRes)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_CreateSFX
; Description ...:
; Syntax.........: _7Zip_CreateSFX($sArcFile, $iSFXType [, $sOutFile [, $sConfigFile]])
; Parameters ....: $sArcFile - String:
;                  $iSFXType - Int:
;                  $sOutFile - String:
;                  $sConfigFile - String:
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |9 $E_7ZIP_SFX_NOT_FOUND
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_CreateSFX($sArcFile, $iSFXType, $sOutFile = '', $sConfigFile = '')
    If Not IsString($sArcFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsInt($iSFXType) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not ($iSFXType >= 1 And $iSFXType <= 4) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sOutFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sConfigFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If '' = $sOutFile Then $sOutFile = StringLeft($sArcFile, StringInStr($sArcFile, '.', 2, -1) - 1) & '.exe'
    Local $sCopyCMD = __7Zip_GetSFXCommand($sArcFile, $iSFXType, $sOutFile, $sConfigFile)
    If Not $sCopyCMD Then Return SetError($E_7ZIP_SFX_NOT_FOUND, 0, 0)
    Return Not RunWait($sCopyCMD, @WorkingDir, @SW_HIDE) ; (Not 0) = 1.
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_CreateSFXEx
; Description ...:
; Syntax.........: _7Zip_CreateSFXEx($sArcFile, $iSFXType [, $sOutFile [, $sConfigFile]])
; Parameters ....: $sArcFile - String:
;                  $iSFXType - Int:
;                  $sOutFile - String:
;                  $sConfigFile - String:
; Return values .: Success - Int: Returns PID of running COPY command.
;                  Failure - Int: Returns 0 and sets @error:
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |9 $E_7ZIP_SFX_NOT_FOUND
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_CreateSFXEx($sArcFile, $iSFXType, $sOutFile = '', $sConfigFile = '')
    If Not IsString($sArcFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsInt($iSFXType) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not ($iSFXType >= 1 And $iSFXType <= 4) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sOutFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sConfigFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If '' = $sOutFile Then $sOutFile = StringLeft($sArcFile, StringInStr($sArcFile, '.', 2, -1) - 1) & '.exe'
    Local $sCopyCMD = __7Zip_GetSFXCommand($sArcFile, $iSFXType, $sOutFile, $sConfigFile)
    If Not $sCopyCMD Then Return SetError($E_7ZIP_SFX_NOT_FOUND, 0, 0)
    Return Run($sCopyCMD, @WorkingDir, @SW_HIDE, 0x8) ; $STDERR_MERGED.
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_Delete
; Description ...:
; Syntax.........: _7Zip_Delete($hWnd, $sArcName, $sFileNames [, $iHide [, $iCompress [, $iRecurse [, $sIncludeFiles [, $sExcludeFiles [, $sPassword [, $sWorkDir]]]]]]])
; Parameters ....: $hWnd   - HWnd:
;                  $sArcName - String:
;                  $sFileNames - String:
;                  $iHide  - Int:
;                  $iCompress - Int:
;                  $iRecurse - Int:
;                  $sIncludeFiles - String:
;                  $sExcludeFiles - String:
;                  $sPassword - String:
;                  $sWorkDir - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_Delete($hWnd, $sArcName, $sFileNames, $iHide = 0, $iCompress = 5, $iRecurse = 1, $sIncludeFiles = 0, $sExcludeFiles = 0, $sPassword = 0, $sWorkDir = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $sCopyCMD = __7Zip_GetCommand($iHide, $iCompress, $iRecurse, 0, 0, 0, $sIncludeFiles, $sExcludeFiles, $sPassword, 0, $sWorkDir, 0)
    $sCopyCMD = 'd ' & __7Zip_Quote($sArcName) &  ' ' & __7Zip_Quote($sFileNames) & ' ' & $sCopyCMD
    Local $sRes = _7Zip($hWnd, $sCopyCMD)
    Return SetError(@error, 0, $sRes)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_Download7Zip32Dll
; Description ...: Download 7-zip32.dll from the developer's site and install.
; Syntax.........: _7Zip_Download7Zip32Dll([$sInstallDir [, $fForce [, $iTimeout]]])
; Parameters ....: $sInstallDir - String:
;                  $fForce - Boolean:
;                  $iTimeout - Int:
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |11 $E_7ZIP_NO_UNZIP_SUPPORT
;                  |12 $E_7ZIP_DOWNLOAD_FAILED
;                  |13 $E_7ZIP_DOWNLOAD_UNZIP_FAILED
; Author ........: dany
; Modified ......:
; Remarks .......: Temporarily registers COM error handler stub if not already set.
;                  Adds AutoIt version and CPU arch to user-agent string.
; Related .......:
; ==============================================================================
Func _7Zip_Download7Zip32Dll($sInstallDir = Default, $fForce = False, $iTimeout = 5)
    If Not FileExists(@SystemDir & '\zipfldr.dll') Then Return SetError($E_7ZIP_NO_UNZIP_SUPPORT, 0, 0)
    If Not RegRead('HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}', '') Then Return SetError($E_7ZIP_NO_UNZIP_SUPPORT, 0, 0)
    If Not IsString($sInstallDir) Or '' = $sInstallDir Then $sInstallDir = $__7Zip_sDllDir
    $sInstallDir = StringReplace($sInstallDir, '/', '\')
    If '\' = StringRight($sInstallDir, 1) Then $sInstallDir = StringTrimRight($sInstallDir, 1)
    If Not $fForce And FileExists($sInstallDir & '\' & $__7ZIP_DLL) Then Return 1
    If Not IsInt($iTimeout) Then $iTimeout = 5
    Local $sZip = @TempDir & '\7-zip32.zip', $sInstallPath = $sInstallDir & '\' & $__7ZIP_DLL
    Local $aUrl = StringSplit($__7ZIP_DLL_DOWNLOAD_LINK, '|')
    Local $iTimer = 0, $hDownload, $oApp, $o7Zip32Dll, $oCOMError
    $iTimeout *= 10
    ; Let Minoru Akita know about AutoIt.
    HttpSetUserAgent('AutoIt ' & @AutoItVersion & ' ' & @CPUArch)
    For $i = 1 To $aUrl[0]
        InetClose($hDownload)
        $iTimer = 0
        $hDownload = InetGet($aUrl[$i], $sZip, 9, 1) ; 1 + 8 = Force reload + Binary mode
        While 1
            If InetGetInfo($hDownload, 2) Or $iTimeout = $iTimer Then ExitLoop
            Sleep(100)
            $iTimer += 1
        WEnd
        If InetGetInfo($hDownload, 3) Then ExitLoop
    Next
    HttpSetUserAgent('') ; Set default user-agent.
    If Not InetGetInfo($hDownload, 3) Then
        InetClose($hDownload)
        FileDelete($sZip)
        Return SetError($E_7ZIP_DOWNLOAD_FAILED, 0, 0)
    EndIf
    InetClose($hDownload)
    If Not ObjEvent('AutoIt.Error') Then $oCOMError = ObjEvent('AutoIt.Error', '__7Zip_COMErrorFunc')
    $oApp = ObjCreate('Shell.Application')
    If @error Then
        $oCOMError = 0
        FileDelete($sZip)
        Return SetError($E_7ZIP_DOWNLOAD_UNZIP_FAILED, 0, 0)
    EndIf
    $o7Zip32Dll = $oApp.NameSpace($sZip).ParseName($__7ZIP_DLL)
    If Not IsObj($o7Zip32Dll) Then
        $oApp = 0
        $o7Zip32Dll = 0
        $oCOMError = 0
        FileDelete($sZip)
        Return SetError($E_7ZIP_DOWNLOAD_UNZIP_FAILED, 0, 0)
    EndIf
    If $fForce Then
        _7Zip_Shutdown()
        If FileExists($sInstallPath) Then FileMove($sInstallPath, $sInstallPath & '.bak', 1)
    EndIf
    If Not FileExists($sInstallDir) Then DirCreate($sInstallDir)
    $oApp.NameSpace($sInstallDir).CopyHere($o7Zip32Dll, 0x14) ; H(4 + 16) = No progress + Yes to all.
    $iTimer = 0
    While 1
        ;If BitAND(WinGetState('[CLASS:#32770]'), @SW_HIDE) <> @SW_HIDE Then WinSetState(WinGetHandle('[CLASS:#32770]'), '', @SW_HIDE)
        If FileExists($sInstallPath) Or $iTimeout = $iTimer Then ExitLoop ; Default 5 seconds.
        Sleep(100)
        $iTimer += 1
    WEnd
    $oApp = 0
    $o7Zip32Dll = 0
    $oCOMError = 0
    FileDelete($sZip)
    If FileExists($sInstallPath) Then
        __7Zip_SetDllPath($sInstallPath)
        FileDelete($sInstallPath & '.bak')
        Return 1
    EndIf
    FileMove($sInstallPath & '.bak', $sInstallPath, 1)
    Return SetError($E_7ZIP_DOWNLOAD_UNZIP_FAILED, 0, 0)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_Extract
; Description ...:
; Syntax.........: _7Zip_Extract($hWnd, $sArcName [, $sOutDir [, $iHide [, $iOverWrite [, $iRecurse [, $sIncludeArcs [, $sExcludeArcs [, $sIncludeFiles [, $sExcludeFiles [, $sPassword [, $iYes]]]]]]]]])
; Parameters ....: $hWnd   - HWnd:
;                  $sArcName - String:
;                  $sOutDir - String:
;                  $iHide  - Int:
;                  $iOverWrite - Int:
;                  $iRecurse - Int:
;                  $sIncludeArcs - String:
;                  $sExcludeArcs - String:
;                  $sIncludeFiles - String:
;                  $sExcludeFiles - String:
;                  $sPassword - String:
;                  $iYes   - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_Extract($hWnd, $sArcName, $sOutDir = 0, $iHide = 0, $iOverWrite = 0, $iRecurse = 1, $sIncludeArcs = 0, $sExcludeArcs = 0, $sIncludeFiles = 0, $sExcludeFiles = 0, $sPassword = 0, $iYes = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $sCopyCMD = __7Zip_GetCommand($iHide, 0, $iRecurse, $iOverWrite, $sIncludeArcs, $sExcludeArcs, $sIncludeFiles, $sExcludeFiles, $sPassword, 0, 0, $iYes)
    If $sOutDir Then $sCopyCMD = ' -o' & __7Zip_Quote($sOutDir) & ' ' & $sCopyCMD
    $sCopyCMD = 'e ' & __7Zip_Quote($sArcName) &  ' ' & $sCopyCMD
    Local $sRes = _7Zip($hWnd, $sCopyCMD)
    Return SetError(@error, 0, $sRes)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_ExtractEx
; Description ...:
; Syntax.........: _7Zip_ExtractEx($hWnd, $sArcName [, $sOutDir [, $iHide [, $iOverWrite [, $iRecurse [, $sIncludeArcs [, $sExcludeArcs [, $sIncludeFiles [, $sExcludeFiles [, $sPassword [, $iYes]]]]]]]]])
; Parameters ....: $hWnd   - HWnd:
;                  $sArcName - String:
;                  $sOutDir - String:
;                  $iHide  - Int:
;                  $iOverWrite - Int:
;                  $iRecurse - Int:
;                  $sIncludeArcs - String:
;                  $sExcludeArcs - String:
;                  $sIncludeFiles - String:
;                  $sExcludeFiles - String:
;                  $sPassword - String:
;                  $iYes   - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_ExtractEx($hWnd, $sArcName, $sOutDir = 0, $iHide = 0, $iOverWrite = 0, $iRecurse = 1, $sIncludeArcs = 0, $sExcludeArcs = 0, $sIncludeFiles = 0, $sExcludeFiles = 0, $sPassword = 0, $iYes = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $sCopyCMD = __7Zip_GetCommand($iHide, 0, $iRecurse, $iOverWrite, $sIncludeArcs, $sExcludeArcs, $sIncludeFiles, $sExcludeFiles, $sPassword, 0, 0, $iYes)
    If $sOutDir Then $sCopyCMD = ' -o' & __7Zip_Quote($sOutDir) & ' ' & $sCopyCMD
    $sCopyCMD = 'x ' & __7Zip_Quote($sArcName) &  ' ' & $sCopyCMD
    Local $sRes = _7Zip($hWnd, $sCopyCMD)
    Return SetError(@error, 0, $sRes)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_Update
; Description ...:
; Syntax.........: _7Zip_Update($hWnd, $sArcName, $sFileNames [, $iHide [, $iCompress [, $iRecurse [, $sIncludeFiles [, $sExcludeFiles [, $sPassword [, $iSFX [, $iVolume [, $sWorkDir]]]]]]]]])
; Parameters ....: $hWnd   - HWnd:
;                  $sArcName - String:
;                  $sFileNames - String:
;                  $iHide  - Int:
;                  $iCompress - Int:
;                  $iRecurse - Int:
;                  $sIncludeFiles - String:
;                  $sExcludeFiles - String:
;                  $sPassword - String:
;                  $iSFX   - Int:
;                  $iVolume - Int:
;                  $sWorkDir - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_Update($hWnd, $sArcName, $sFileNames, $iHide = 0, $iCompress = 5, $iRecurse = 1, $sIncludeFiles = 0, $sExcludeFiles = 0, $sPassword = 0, $iSFX = 0, $iVolume = 0, $sWorkDir = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $sCopyCMD = __7Zip_GetCommand($iHide, $iCompress, $iRecurse, 0, 0, 0, $sIncludeFiles, $sExcludeFiles, $sPassword, $iVolume, $sWorkDir, 0)
    $sCopyCMD = 'u ' & __7Zip_Quote($sArcName) &  ' ' & __7Zip_Quote($sFileNames) & ' ' & $sCopyCMD
    Local $sRes = _7Zip($hWnd, $sCopyCMD)
    Return SetError(@error, 0, $sRes)
EndFunc
#EndRegion Extra 7-zip functions.

#Region 7-zip Dll API.
; #FUNCTION# ===================================================================
; Name...........: _7Zip
; Description ...:
; Syntax.........: _7Zip($hWnd, $sCmdLine)
; Parameters ....: $hWnd   - HWnd:
;                  $sCmdLine - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip($hWnd, $sCmdLine)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sCmdLine) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[32768]')
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZip', 'hwnd' $hWnd, 'str', $sCmdLine, 'ptr', DllStructGetPtr($tBuffer), 'dword', DllStructGetSize($tBuffer))
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_CheckArchive
; Description ...:
; Syntax.........: _7Zip_CheckArchive($sArcName [, $iMode])
; Parameters ....: $sArcName - String:
;                  $iMode  - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 $E_7ZIP_DLL_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_CheckArchive($sArcName, $iMode = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsString($sArcName) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsInt($iMode) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipCheckArchive', 'str', $sArcName, 'int', $iMode)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_ClearOwnerWindow
; Description ...:
; Syntax.........: _7Zip_ClearOwnerWindow()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_ClearOwnerWindow()
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipClearOwnerWindow')
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_CloseArchive
; Description ...:
; Syntax.........: _7Zip_CloseArchive($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_CloseArchive($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipCloseArchive', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_ConfigDialog
; Description ...:
; Syntax.........: _7Zip_ConfigDialog($hWnd [, $iMode])
; Parameters ....: $hWnd   - HWnd:
;                  $iMode  - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_ConfigDialog($hWnd, $iMode = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsInt($iMode) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[32768]')
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipConfigDialog', 'hwnd', $hWnd, 'str', DllStructGetPtr($tBuffer), 'int', $iMode)
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_FindFirst
; Description ...:
; Syntax.........: _7Zip_FindFirst($hArchive, $sWildName)
; Parameters ....: $hArchive - Ptr:
;                  $sWildName - String:
; Return values .: Success - Struct:
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_FindFirst($hArchive, $sWildName)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sWildName) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tSubInfo = DllStructCreate($7ZIP_TAG_INDIVIDUALINFO)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipFindFirst', 'hwnd', $hArchive, 'str', $sWildName, 'ptr*', DllStructGetPtr($tSubInfo))
    If @error Then Return SetError(@error, 0, 0)
    Return $tSubInfo
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_FindNext
; Description ...:
; Syntax.........: _7Zip_FindNext($hArchive, $tSubInfo)
; Parameters ....: $hArchive - Ptr:
;                  $tSubInfo - Struct:
; Return values .: Success - Struct:
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_FindNext($hArchive, $tSubInfo)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipFindNext', 'hwnd', $hArchive, 'ptr*', DllStructGetPtr($tSubInfo))
    If @error Then Return SetError(@error, 0, 0)
    Return $tSubInfo
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetAccessTime
; Description ...:
; Syntax.........: _7Zip_GetAccessTime($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetAccessTime($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetAccessTime', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetAccessTimeEx
; Description ...:
; Syntax.........: _7Zip_GetAccessTimeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetAccessTimeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tFileTime = DllStructCreate($7ZIP_TAG_FILETIME)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetAccessTimeEx','hwnd', $hArchive, 'ptr*', DllStructGetPtr($tFileTime))
    If @error Then Return SetError(@error, 0, 0)
    Return $tFileTime
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcAccessTimeEx
; Description ...:
; Syntax.........: _7Zip_GetArcAccessTimeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcAccessTimeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tFileTime = DllStructCreate($7ZIP_TAG_FILETIME)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetArcAccessTimeEx', 'hwnd', $hArchive, 'ptr*', DllStructGetPtr($tFileTime))
    If @error Then Return SetError(@error, 0, 0)
    Return $tFileTime
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcCompressedSize
; Description ...:
; Syntax.........: _7Zip_GetArcCompressedSize($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcCompressedSize($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetArcCompressedSize', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcCompressedSizeEx
; Description ...:
; Syntax.........: _7Zip_GetArcCompressedSizeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcCompressedSizeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetArcCompressedSizeEx', 'hwnd', $hArchive, 'int64*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[2]
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcCreateTimeEx
; Description ...:
; Syntax.........: _7Zip_GetArcCreateTimeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcCreateTimeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tFileTime = DllStructCreate($7ZIP_TAG_FILETIME)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetArcCreateTimeEx', 'hwnd', $hArchive, 'ptr*', DllStructGetPtr($tFileTime))
    If @error Then Return SetError(@error, 0, 0)
    Return $tFileTime
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcDate
; Description ...:
; Syntax.........: _7Zip_GetArcDate($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcDate($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetArcDate', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcFileName
; Description ...:
; Syntax.........: _7Zip_GetArcFileName($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcFileName($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[' & ($7ZIP_FNAME_MAX32 + 1) & ']')
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipGetArcFileName', 'hwnd', $hArchive, 'ptr', DllStructGetPtr($tBuffer), 'int', DllStructGetSize($tBuffer))
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcFileSize
; Description ...:
; Syntax.........: _7Zip_GetArcFileSize($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcFileSize($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetArcFileSize', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcFileSizeEx
; Description ...:
; Syntax.........: _7Zip_GetArcFileSizeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcFileSizeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetArcFileSizeEx', 'hwnd', $hArchive, 'int64*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[2]
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArchiveType
; Description ...:
; Syntax.........: _7Zip_GetArchiveType($sArcName)
; Parameters ....: $sArcName - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArchiveType($sArcName)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsString($sArcName) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipGetArchiveType', 'str', $sArcName)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcOriginalSize
; Description ...:
; Syntax.........: _7Zip_GetArcOriginalSize($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcOriginalSize($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetArcOriginalSize', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcOriginalSizeEx
; Description ...:
; Syntax.........: _7Zip_GetArcOriginalSizeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcOriginalSizeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetArcOriginalSizeEx', 'hwnd', $hArchive, 'int64*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[2]
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcOSType
; Description ...:
; Syntax.........: _7Zip_GetArcOSType($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcOSType($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'uint', 'SevenZipGetArcOSType', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcRatio
; Description ...:
; Syntax.........: _7Zip_GetArcRatio($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcRatio($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetArcRatio', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcTime
; Description ...:
; Syntax.........: _7Zip_GetArcTime($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcTime($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetArcTime', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetArcWriteTimeEx
; Description ...:
; Syntax.........: _7Zip_GetArcWriteTimeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetArcWriteTimeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tFileTime = DllStructCreate($7ZIP_TAG_FILETIME)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetArcWriteTimeEx', 'hwnd', $hArchive, 'ptr*', DllStructGetPtr($tFileTime))
    If @error Then Return SetError(@error, 0, 0)
    Return $tFileTime
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetAttribute
; Description ...:
; Syntax.........: _7Zip_GetAttribute($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetAttribute($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipGetAttribute', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetBackGroundMode
; Description ...:
; Syntax.........: _7Zip_GetBackGroundMode()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetBackGroundMode()
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetBackGroundMode')
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCompressedSize
; Description ...:
; Syntax.........: _7Zip_GetCompressedSize($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCompressedSize($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetCompressedSize', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCompressedSizeEx
; Description ...:
; Syntax.........: _7Zip_GetCompressedSizeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCompressedSizeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetCompressedSizeEx', 'hwnd', $hArchive, 'int64*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[2]
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCRC
; Description ...:
; Syntax.........: _7Zip_GetCRC($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCRC($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetCRC', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCreateTime
; Description ...:
; Syntax.........: _7Zip_GetCreateTime($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCreateTime($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetCreateTime', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCreateTimeEx
; Description ...:
; Syntax.........: _7Zip_GetCreateTimeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCreateTimeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tFileTime = DllStructCreate($7ZIP_TAG_FILETIME)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetCreateTimeEx', 'hwnd', $hArchive, 'ptr*', DllStructGetPtr($tFileTime))
    If @error Then Return SetError(@error, 0, 0)
    Return $tFileTime
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCursorInterval
; Description ...:
; Syntax.........: _7Zip_GetCursorInterval()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCursorInterval()
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetCursorInterval')
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetCursorMode
; Description ...:
; Syntax.........: _7Zip_GetCursorMode()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetCursorMode()
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetCursorMode')
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetDate
; Description ...:
; Syntax.........: _7Zip_GetDate($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetDate($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetDate', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetDefaultPassword
; Description ...:
; Syntax.........: _7Zip_GetDefaultPassword($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetDefaultPassword($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[32768]')
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetDefaultPassword', 'hwnd', $hArchive, 'ptr', DllStructGetPtr($tBuffer), 'int', DllStructGetSize($tBuffer))
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetFileCount
; Description ...:
; Syntax.........: _7Zip_GetFileCount($sArcFile)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetFileCount($sArcFile)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsString($sArcFile) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipGetFileCount', 'str', $sArcFile)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetFileName
; Description ...:
; Syntax.........: _7Zip_GetFileName($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetFileName($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[' & ($7ZIP_FNAME_MAX32 + 1) & ']')
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipGetFileName', 'hwnd', $hArchive, 'ptr', DllStructGetPtr($tBuffer), 'int', DllStructGetSize($tBuffer))
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetMethod
; Description ...:
; Syntax.........: _7Zip_GetMethod($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetMethod($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[32]')
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipGetMethod', 'hwnd', $hArchive, 'ptr', DllStructGetPtr($tBuffer), 'int', DllStructGetSize($tBuffer))
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetOriginalSize
; Description ...:
; Syntax.........: _7Zip_GetOriginalSize($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetOriginalSize($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetOriginalSize', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetOriginalSizeEx
; Description ...:
; Syntax.........: _7Zip_GetOriginalSizeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetOriginalSizeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetOriginalSizeEx', 'hwnd', $hArchive, 'int64*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[2]
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetOSType
; Description ...:
; Syntax.........: _7Zip_GetOSType($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetOSType($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'uint', 'SevenZipGetOSType', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetRatio
; Description ...:
; Syntax.........: _7Zip_GetRatio($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetRatio($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetRatio', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetRunning
; Description ...:
; Syntax.........: _7Zip_GetRunning()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetRunning()
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetRunning')
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetSubVersion
; Description ...:
; Syntax.........: _7Zip_GetSubVersion()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetSubVersion()
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetSubVersion')
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetTime
; Description ...:
; Syntax.........: _7Zip_GetTime($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetTime($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetTime', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetVersion
; Description ...:
; Syntax.........: _7Zip_GetVersion()
; Parameters ....: None.
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetVersion()
    ;If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'word', 'SevenZipGetVersion')
    If @error Then Return SetError(@error, 0, 0)
    Return StringLeft($aRes[0], 1) & '.' & StringTrimLeft($aRes[0], 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetWriteTime
; Description ...:
; Syntax.........: _7Zip_GetWriteTime($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetWriteTime($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'dword', 'SevenZipGetWriteTime', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_GetWriteTimeEx
; Description ...:
; Syntax.........: _7Zip_GetWriteTimeEx($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_GetWriteTimeEx($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tFileTime = DllStructCreate($7ZIP_TAG_FILETIME)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipGetWriteTimeEx', 'hwnd', $hArchive, 'ptr*', DllStructGetPtr($tFileTime))
    If @error Then Return SetError(@error, 0, 0)
    Return $tFileTime
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_IsSFXFile
; Description ...:
; Syntax.........: _7Zip_IsSFXFile($hArchive)
; Parameters ....: $hArchive - Ptr:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_IsSFXFile($hArchive)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsPtr($hArchive) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipIsSFXFile', 'hwnd', $hArchive)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_KillOwnerWindowEx
; Description ...:
; Syntax.........: _7Zip_KillOwnerWindowEx($hWnd)
; Parameters ....: $hWnd   - HWnd:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_KillOwnerWindowEx($hWnd)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    _7Zip_FreeOwnerWindowCallback()
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipKillOwnerWindowEx', 'hwnd', $hWnd)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_KillOwnerWindowEx64
; Description ...:
; Syntax.........: _7Zip_KillOwnerWindowEx64($hWnd)
; Parameters ....: $hWnd   - HWnd:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_KillOwnerWindowEx64($hWnd)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    _7Zip_FreeOwnerWindowCallback()
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipKillOwnerWindowEx64', 'hwnd', $hWnd)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_OpenArchive
; Description ...:
; Syntax.........: _7Zip_OpenArchive($hWnd, $sArcName [, $iMode])
; Parameters ....: $hWnd   - HWnd:
;                  $sArcName - String:
;                  $iMode  - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_OpenArchive($hWnd, $sArcName, $iMode = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sArcName) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsInt($iMode) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'hwnd', 'SevenZipOpenArchive', 'hwnd', $hWnd, 'str', $sArcName, 'dword', $iMode)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_PasswordDialog
; Description ...:
; Syntax.........: _7Zip_PasswordDialog($hWnd)
; Parameters ....: $hWnd   - HWnd:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_PasswordDialog($hWnd)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $tBuffer = DllStructCreate('char[32768]')
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipPasswordDialog', 'hwnd', $hWnd, 'ptr', DllStructGetPtr($tBuffer), 'int', DllStructGetSize($tBuffer))
    If @error Then Return SetError(@error, 0, 0)
    Return DllStructGetData($tBuffer, 1)
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_QueryFunctionList
; Description ...:
; Syntax.........: _7Zip_QueryFunctionList($iFunction)
; Parameters ....: $iFunction - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_QueryFunctionList($iFunction)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsInt($iFunction) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If ($iFunction >= 200 And $iSFXType <= 209) Then Return 1
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipQueryFunctionList', 'int', $iFunction)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetBackGroundMode
; Description ...:
; Syntax.........: _7Zip_SetBackGroundMode([$iBackGroundMode])
; Parameters ....: $iBackGroundMode - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetBackGroundMode($iBackGroundMode = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsInt($iBackGroundMode) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetBackGroundMode', 'bool', Int(0 < $iBackGroundMode))
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetCursorInterval
; Description ...:
; Syntax.........: _7Zip_SetCursorInterval([$iInterval])
; Parameters ....: $iInterval - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetCursorInterval($iInterval = 80)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsInt($iInterval) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetCursorInterval', 'word', $iInterval)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetCursorMode
; Description ...:
; Syntax.........: _7Zip_SetCursorMode([$iCursorMode])
; Parameters ....: $iCursorMode - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetCursorMode($iCursorMode = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsInt($iCursorMode) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetCursorMode', 'bool', Int(0 < $iCursorMode))
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetDefaultPassword
; Description ...:
; Syntax.........: _7Zip_SetDefaultPassword($hWnd, $sPassword)
; Parameters ....: $hWnd   - HWnd:
;                  $sPassword - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetDefaultPassword($hWnd, $sPassword)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sPassword) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'int', 'SevenZipSetDefaultPassword', 'hwnd', $hWnd, 'str', $sPassword)
    Return SetError(@error, 0, $aRes[0])
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetOwnerWindow
; Description ...:
; Syntax.........: _7Zip_SetOwnerWindow($hWnd)
; Parameters ....: $hWnd   - HWnd:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetOwnerWindow($hWnd)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetOwnerWindow', 'hwnd', $hWnd)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetOwnerWindowEx
; Description ...:
; Syntax.........: _7Zip_SetOwnerWindowEx($hWnd, $sArcProc)
; Parameters ....: $hWnd   - HWnd:
;                  $sArcProc - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetOwnerWindowEx($hWnd, $sArcProc)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sArcProc) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If $__7Zip_hArchiveProc Then DllCallbackFree($__7Zip_hArchiveProc)
    $__7Zip_hArchiveProc = DllCallbackRegister($sArcProc, 'int', 'hwnd;uint;uint;ptr')
    If 0 = $__7Zip_hArchiveProc Then Return SetError(1, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetOwnerWindowEx', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($__7Zip_hArchiveProc))
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetOwnerWindowEx64
; Description ...:
; Syntax.........: _7Zip_SetOwnerWindowEx64($hWnd, $sArcProc)
; Parameters ....: $hWnd   - HWnd:
;                  $sArcProc - String:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetOwnerWindowEx64($hWnd, $sArcProc)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If 0 <> $hWnd And Not IsPtr($hWnd) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not IsString($sArcProc) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    If $__7Zip_hArchiveProc Then DllCallbackFree($__7Zip_hArchiveProc)
    $__7Zip_hArchiveProc = DllCallbackRegister($sArcProc, 'int', 'hwnd;uint;uint;ptr')
    If 0 = $__7Zip_hArchiveProc Then Return SetError(1, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetOwnerWindowEx64', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($__7Zip_hArchiveProc), 'dword', 24) ; 'hwnd;uint;uint;ptr' ?
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetPriority
; Description ...:
; Syntax.........: _7Zip_SetPriority([$iPriority])
; Parameters ....: $iPriority - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetPriority($iPriority = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsInt($iPriority) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetPriority', 'int', $iPriority)
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc

; #FUNCTION# ===================================================================
; Name...........: _7Zip_SetUnicodeMode
; Description ...:
; Syntax.........: _7Zip_SetUnicodeMode([$iUnicode])
; Parameters ....: $iUnicode - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7ZIP_DLL_FILE_UNUSABLE
;                  |2 $E_7ZIP_DLL_UNKNOWN_RETURN_TYPE
;                  |3 $E_7ZIP_DLL_FUNCTION_NOT_FOUND
;                  |4 $E_7ZIP_DLL_BAD_NUMBER_OF_PARAMETERS
;                  |5 E_7ZIP_Dll_BAD_PARAMETER
;                  |6 $E_7ZIP_BAD_FUNCTION_ARGUMENT
;                  |10 $E_7ZIP_DLL_NOT_LOADED
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7Zip_SetUnicodeMode($iUnicode = 0)
    If -1 = $__7Zip_hDll Then Return SetError($E_7ZIP_DLL_NOT_LOADED, 0, 0)
    If Not IsInt($iUnicode) Then Return SetError($E_7ZIP_BAD_FUNCTION_ARGUMENT, 0, 0)
    Local $aRes = DllCall($__7Zip_hDll, 'bool', 'SevenZipSetUnicodeMode', 'bool', Int(0 < $iUnicode))
    Return SetError(@error, 0, (0 < $aRes[0]))
EndFunc
#EndRegion 7-zip Dll API.

#Region Private functions.
; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_SetDllPath
; Description ...:
; Syntax.........: __7Zip_SetDllPath($sDllPath)
; Parameters ....:
; Return values .:
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: _7Zip_Startup, _7Zip_Download7Zip32Dll
; ==============================================================================
Func __7Zip_SetDllPath($sDllPath)
    $__7Zip_sDllPath = StringReplace($sDllPath, '/', '\') ; Normalize.
    $__7Zip_sDllDir = StringReplace($__7Zip_sDllPath, $__7ZIP_DLL, '')
    If StringLen($__7Zip_sDllDir) And '\' = StringRight($__7Zip_sDllDir, 1) Then $__7Zip_sDllDir = StringTrimRight($__7Zip_sDllDir, 1)
    Return 1
EndFunc   ;==>__7Zip_SetDllPath

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_COMErrorFunc
; Description ...: COM error handler stub.
; Syntax.........: __7Zip_COMErrorFunc($oError)
; Parameters ....:
; Return values .:
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: _7Zip_Download7Zip32Dll
; ==============================================================================
Func __7Zip_COMErrorFunc($oError)
EndFunc   ;==>__7Zip_COMErrorFunc

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_GetCommand
; Description ...:
; Syntax.........: __7Zip_GetCommand($iHide, $iCompress, $iRecurse, $iOverWrite, $sIncludeArcs, $sExcludeArcs, $sIncludeFiles, $sExcludeFiles, $sPassword, $iVolume, $sWorkDir, $iYes)
; Parameters ....:
; Return values .:
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: _7Zip_Add, _7Zip_Archive, _7Zip_Delete, _7Zip_Extract, _7Zip_ExtractEx, _7Zip_Update
; ==============================================================================
Func __7Zip_GetCommand($iHide, $iCompress, $iRecurse, $iOverWrite, $sIncludeArcs, $sExcludeArcs, $sIncludeFiles, $sExcludeFiles, $sPassword, $iVolume, $sWorkDir, $iYes)
    Local $sCopyCMD = ''
    $sCopyCMD &= ' -mx' & $iCompress
    $sCopyCMD &= _RecursionSet($iRecurse)
    If $iHide Then $sCopyCMD &= ' -hide'
    If $iOverwrite Then $sCopyCMD &= _OverwriteSet($iOverwrite)
    If $sIncludeArcs Then $sCopyCMD &= _IncludeArcSet($sIncludeArcs)
    If $sExcludeArcs Then $sCopyCMD &= _ExcludeArcSet($sExcludeArcs)
    If $sIncludeFiles Then $sCopyCMD &= _IncludeFileSet($sIncludeFiles)
    If $sExcludeFiles Then $sCopyCMD &= _ExcludeFileSet($sExcludeFiles)
    If $sPassword Then $sCopyCMD &= ' -p' & $sPassword
    If $iVolume Then $sCopyCMD &= ' -v' & $iVolume
    If $sWorkDir Then $sCopyCMD &= ' -w' & __7Zip_Quote($sWorkDir)
    If $iYes Then $sCopyCMD &= ' -y'
    Return $sCopyCMD
EndFunc   ;==>__7Zip_GetCommand

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_Quote
; Description ...:
; Syntax.........: __7Zip_Quote($sStr)
; Parameters ....:
; Return values .:
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_Quote($sStr)
    If Not StringInStr($sStr, '"') Then Return '"' & $sStr & '"'
    Return $sStr
EndFunc   ;==>__7Zip_Quote

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_RecursionSet
; Description ...:
; Syntax.........: __7Zip_RecursionSet($iVal)
; Parameters ....:
; Return values .:
; Author ........: R. Gilman (rasim)
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_RecursionSet($iVal)
    Switch $iVal
        Case 1
            Return " -r"
        Case 2
            Return " -r0"
        Case Else
            Return " -r-"
    EndSwitch
EndFunc   ;==>__7Zip_RecursionSet

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_OverwriteSet
; Description ...:
; Syntax.........: __7Zip_OverwriteSet($sVal)
; Parameters ....:
; Return values .:
; Author ........: R. Gilman (rasim)
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_OverwriteSet($sVal)
    Switch $sVal
        Case 1
            Return " -aos"
        Case 2
            Return " -aou"
        Case 3
            Return " -aot"
        Case Else
            Return " -aoa"
    EndSwitch
EndFunc   ;==>__7Zip_OverwriteSet

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_IncludeFileSet
; Description ...:
; Syntax.........: __7Zip_IncludeFileSet($sVal)
; Parameters ....:
; Return values .:
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_IncludeFileSet($sVal)
    If StringLeft($sVal, 1) = "@" Then
        Return ' -i' & __7Zip_Quote($sVal)
    Else
        Return ' -i!' & __7Zip_Quote($sVal)
    EndIf
EndFunc   ;==>__7Zip_IncludeFileSet

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_ExcludeFileSet
; Description ...:
; Syntax.........: __7Zip_ExcludeFileSet($sVal)
; Parameters ....:
; Return values .:
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_ExcludeFileSet($sVal)
    If StringLeft($sVal, 1) = "@" Then
        Return ' -x' & __7Zip_Quote($sVal)
    Else
        Return ' -x!' & __7Zip_Quote($sVal)
    EndIf
EndFunc   ;==>__7Zip_ExcludeFileSet

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_IncludeArcSet
; Description ...:
; Syntax.........: __7Zip_IncludeArcSet($sVal)
; Parameters ....:
; Return values .:
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_IncludeArcSet($sVal)
    If StringLeft($sVal, 1) = "@" Then
        Return ' -ai' & __7Zip_Quote($sVal)
    Else
        Return ' -ai!' & __7Zip_Quote($sVal)
    EndIf
EndFunc   ;==>__7Zip_IncludeArcSet

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_ExcludeArcSet
; Description ...:
; Syntax.........: __7Zip_ExcludeArcSet($sVal)
; Parameters ....:
; Return values .:
; Author ........: R. Gilman (rasim)
; Modified ......: dany
; Remarks .......: For Internal Use Only.
; Related .......: __7Zip_GetCommand
; ==============================================================================
Func __7Zip_ExcludeArcSet($sVal)
    If StringLeft($sVal, 1) = "@" Then
        Return ' -ax' & __7Zip_Quote($sVal)
    Else
        Return ' -ax!' & __7Zip_Quote($sVal)
    EndIf
EndFunc   ;==>__7Zip_ExcludeArcSet

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7Zip_GetSFXCommand
; Description ...:
; Syntax.........: __7Zip_GetSFXCommand($sArcFile, $sOutFile, $iSFXType, $sConfigFile)
; Parameters ....:
; Return values .:
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......: _7Zip_CreateSFX, _7Zip_CreateSFXEx
; ==============================================================================
Func __7Zip_GetSFXCommand($sArcFile, $iSFXType, $sOutFile, $sConfigFile)
    Local $sCopyCMD, $sSFX[5] = [0, '7zSD.sfx', '7zS.sfx', '7zS2.sfx', '7zS2con.sfx']
    $sSFX = $__7Zip_sDllDir & '\' & $sSFX[$iSFXType]
    If Not FileExists($sSFX) Then Return False
    $sCopyCMD = @ComSpec & ' /c COPY /B /Y ' & __7Zip_Quote($sSFX)
    If StringLen($sConfigFile) Then $sCopyCMD &= ' + ' & __7Zip_Quote($sConfigFile)
    Return $sCopyCMD & ' + ' & __7Zip_Quote($sArcFile) & ' ' & __7Zip_Quote($sOutFile)
EndFunc   ;==>__7Zip_GetSFXCommand
#EndRegion Private functions.
