;; SQLiteExtLoad.au3

#include-once

; #FUNCTION# ====================================================================================================================
; Name...........: _SQLite_EnableExtensions
; Description ...: Enables or disables loading of SQLite extensions
; Syntax.........: _SQLite_EnableExtensions($hConn, $Enable = 1)
; Parameters ....: $hConn		handle of connection
;                  $Enable		1 to enable (default) or 0 to disable
; Return values .: none
;                  @error Value(s):       -1 - SQLite Reported an Error (Check @extended Value)
;                  1 - Call prevented by safe mode (invalid handle)
;                  2 - Error calling SQLite API 'sqlite3_enable_load_extension'
;                  @extended Value(s): Can be compared against $SQLITE_* Constants
; Author ........: jchd
; ===============================================================================================================================

Func _SQLite_EnableExtensions($hConn, $Enable = 1)
    If __SQLite_hChk($hConn, 1) Then Return SetError(@error, 0, $SQLITE_MISUSE)
	Local $RetVal = DllCall($g_hDll_SQLite, "int:cdecl", "sqlite3_enable_load_extension", "ptr", $hConn, "int", $Enable)
	If @error Then
		Return(SetError(2, 0, 0))
	Else
		If $RetVal[0] <> $SQLITE_OK Then Return(SetError(-1, $RetVal[0], 0))
	EndIf
EndFunc   ;==>__SQLite_EnableExtensions


; #FUNCTION# ====================================================================================================================
; Name...........: _SQLite_LoadExtension
; Description ...: Loads an SQLite extension for current connection
; Syntax.........: _SQLite_LoadExtension($hConn, $sFullPath [, $sEntry = ''])
; Parameters ....: $hConn		handle of the connection for which the extension will be loaded
;                  $sFullPath	path and name of the extension DLL
;                  $sEntry		name of entry point, defaults to 'sqlite3_extension_init'
; Return values .: none
;                  @error Value(s):       -1 - SQLite Reported an Error (Check @extended Value)
;                  1 - Call prevented by safe mode (invalid handle)
;                  2 - Error while converting path to UTF-8
;                  3 - Error calling SQLite API 'sqlite3_load_extension'
;                  @extended Value(s): Can be compared against $SQLITE_* Constants
; Author ........: jchd
; ===============================================================================================================================

Func _SQLite_LoadExtension($hConn, $sFullPath, $sEntry = 'sqlite3_extension_init')
    If __SQLite_hChk($hConn, 1) Then Return SetError(@error, 0, $SQLITE_MISUSE)
	Local $tDllPath = __SQLite_StringToUtf8Struct($sFullPath)
	If @error Then Return(SetError(2, @extended, 0))
	Local $RetVal = DllCall($g_hDll_SQLite, "int:cdecl", "sqlite3_load_extension", _
												"ptr", $hConn, _
												"ptr", DllStructGetPtr($tDllPath), _
												"str", $sEntry, _
												"ptr", 0)
	If @error Then
		Return(SetError(3, 0, 0))
	Else
		If $RetVal[0] <> $SQLITE_OK Then Return(SetError(-1, $RetVal[0], 0))
	EndIf
EndFunc   ;==>_SQLiteLoadExtension


; #FUNCTION# ====================================================================================================================
; Name...........: _SQLite_LoadAutoExtension
; Description ...: Permanently loads an SQLite extension for current session
; Syntax.........: _SQLite_LoadAutoExtension($sFullPath [, $sEntry = ''])
; Parameters ....: $sDllPath	path of the extension DLL
;                  $sEntry		optional name of entry point, defaults to 'sqlite3_extension_init'
; Return values .: none
;                  @error Value(s):       -1 - SQLite Reported an Error (Check @extended Value)
;                  1 - Error while loading extension DLL
;                  2 - Error obtaining address of named entry point
;                  3 - Error calling SQLite API 'sqlite3_auto_extension'
;                  @extended Value(s): Can be compared against $SQLITE_* Constants
; Author ........: jchd
; ===============================================================================================================================

Func _SQLite_LoadAutoExtension($sFullPath, $sEntry = 'sqlite3_extension_init')
	Local $RetVal = DllCall("kernel32.dll", "ptr", "LoadLibraryW", "wstr", $sFullPath)
	If (@error Or $RetVal[0] = 0) Then Return(SetError(1, 0, 0))
	$RetVal = DllCall('kernel32.dll', 'ptr', 'GetProcAddress', 'ptr', $RetVal[0], 'str', $sEntry)
	If (@error Or $RetVal[0] = 0) Then Return(SetError(2, 0, 0))
	$RetVal = DllCall($g_hDll_SQLite, "none:cdecl", "sqlite3_auto_extension", "ptr", $RetVal[0])
	If @error Then
		Return(SetError(3, 0, 0))
	Else
		If $RetVal[0] <> $SQLITE_OK Then Return(SetError(-1, $RetVal[0], 0))
	EndIf
EndFunc   ;==>_SQLite_LoadAutoExtension
