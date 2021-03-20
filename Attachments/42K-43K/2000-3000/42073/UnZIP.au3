; UnZIP.au3
;.......script written by trancexx (trancexx at yahoo dot com)

; Donations to help me write more are wellcome and will be accepted via PayPal address: trancexx at yahoo dot com
; Thank you for the shiny stuff :kiss:

#include-once

Global Const $hZIPFLDR_DLL = DllOpen("zipfldr.dll")
Global Const $CLSID_CZipFolder = "{e88dcce0-b7b3-11d1-a9f0-00aa0060fa31}"

;===============================================================================
#interface "IClassFactory"
Global Const $sIID_IClassFactory = "{00000001-0000-0000-C000-000000000046}"
Global Const $tagIClassFactory = "CreateInstance hresult(ptr;clsid;ptr*);" & _
		"LockServer hresult(bool);"
;===============================================================================
;===============================================================================
#interface "IPersist"
Global Const $sIID_IPersist = "{0000010c-0000-0000-C000-000000000046}"
Global $tagIPersist = "GetClassID hresult(ptr*);"
;===============================================================================
;===============================================================================
#interface "IPersistFile"
Global Const $sIID_IPersistFile = "{0000010b-0000-0000-C000-000000000046}"
Global $tagIPersistFile = $tagIPersist & _
		"IsDirty hresult();" & _
		"Load hresult(wstr;dword);" & _
		"Save hresult(wstr;bool);" & _
		"SaveCompleted hresult(wstr);" & _
		"GetCurFile hresult(ptr*);"
;===============================================================================
;===============================================================================
#interface "IPersistFolder"
Global Const $sIID_IPersistFolder = "{000214EA-0000-0000-C000-000000000046}"
Global $tagIPersistFolder = $tagIPersist & _
		"Initialize hresult(ptr);"
;===============================================================================
;===============================================================================
#interface "IShellFolder"
Global Const $sIID_IShellFolder = "{000214E6-0000-0000-C000-000000000046}"
Global $tagIShellFolder = "ParseDisplayName hresult(hwnd;ptr;wstr;ulong*;ptr*;ulong*);" & _
		"EnumObjects hresult(hwnd;dword;ptr*);" & _
		"BindToObject hresult(struct*;ptr;clsid;ptr*);" & _
		"BindToStorage hresult(struct*;ptr;clsid;ptr*);" & _
		"CompareIDs hresult(lparam;struct*;struct*);" & _
		"CreateViewObject hresult(hwnd;clsid;ptr*);" & _
		"GetAttributesOf hresult(uint:struct*;ulong*);" & _
		"GetUIObjectOf hresult(hwnd;uint;struct*;clsid;uint*;ptr*);" & _
		"GetDisplayNameOf hresult(struct*;dword;struct*);" & _
		"SetNameOf hresult(hwnd;struct*;wstr;dword;struct*);"
;===============================================================================
;===============================================================================
#interface "ISequentialStream"
Global Const $sIID_ISequentialStream = "{0c733a30-2a1c-11ce-ade5-00aa0044773d}"
Global Const $tagISequentialStream = "Read hresult(struct*;dword;dword*);" & _
		"Write hresult(struct*;dword;dword*);"
;===============================================================================
;===============================================================================
#interface "IStream"
Global Const $sIID_IStream = "{0000000c-0000-0000-C000-000000000046}"
Global Const $tagIStream = $tagISequentialStream & _
		"Seek hresult(int64;dword;uint64*);" & _
		"SetSize hresult(uint64);" & _
		"CopyTo hresult(ptr;uint64;uint64*;uint64*);" & _
		"Commit hresult(dword);" & _
		"Revert hresult();" & _
		"LockRegion hresult(uint64;uint64;dword);" & _
		"UnlockRegion hresult(uint64;uint64;dword);" & _
		"Stat hresult(struct*;dword);" & _
		"Clone hresult(ptr*);"
;===============================================================================

Func UnZIP_SaveFileToBinaryOnce($sZIP, $sFile, $iWantedSize = Default)
	Local $oShellFolder, $oPersistF
	Local $bRet = UnZIP_SaveFileToBinary($sZIP, $sFile, $oShellFolder, $oPersistF, $iWantedSize)
	Local $iErr = @error, $iExtended = @extended
	__UnZIP_Clean($oShellFolder, $oPersistF)
	Return SetError($iErr, $iExtended, $bRet)
EndFunc

Func UnZIP_SaveFileToFileOnce($sZIP, $sFile, $sDestination)
	Local $oShellFolder, $oPersistF
	Local $sRet = UnZIP_SaveFileToBinary($sZIP, $sFile, $oShellFolder, $oPersistF)
	Local $iErr = @error, $iExtended = @extended
	__UnZIP_Clean($oShellFolder, $oPersistF)
	Return SetError($iErr, $iExtended, $sRet)
EndFunc

Func UnZIP_SaveFileToFile($sZIP, $sFile, $sDestination, ByRef $oShellFolder, ByRef $oPersistF)
	Local $bBinary = UnZIP_SaveFileToBinary($sZIP, $sFile, $oShellFolder, $oPersistF)
	If @error Then Return SetError(1, @error, "")
	Local $hFile = FileOpen($sDestination, 26) ; open in binary mode and erase previous content
	If $hFile <> -1 Then
		FileWrite($hFile, $bBinary)
		FileClose($hFile)
		Return $sDestination
	EndIf
	Return SetError(1, 0, "")
EndFunc

Func UnZIP_SaveFileToBinary($sZIP, $sFile, ByRef $oShellFolder, ByRef $oPersistF, $iWantedSize = Default)
	Local $bNoRelease = IsObj($oShellFolder) And IsObj($oPersistF)
	Local Const $S_OK = 0, $S_FALSE = 1
	Local $oStream = UnZIP_SaveFileToStream($sZIP, $sFile, $oShellFolder, $oPersistF, Not $bNoRelease)
	If @error Then
		Local $iErr = @error
		__UnZIP_Clean($oShellFolder, $oPersistF, $bNoRelease)
		Return SetError(1, $iErr, 0)
	EndIf
	$bNoRelease = True
	Local Enum $STREAM_SEEK_SET = 0, $STREAM_SEEK_CUR, $STREAM_SEEK_END
	; Set stream position to the start in case it wouldn't be
	$oStream.Seek(0, $STREAM_SEEK_SET, 0)
	; Determine the size of the stream
	Local $iSize
	$oStream.Seek(0, $STREAM_SEEK_END, $iSize)
	If $iSize = 0 Then ; empty
		$oStream = 0 ; Stream object needs released first
		__UnZIP_Clean($oShellFolder, $oPersistF, $bNoRelease)
		Return SetError(2, 0, 0)
	EndIf
	; Back to start for reading correctly
	$oStream.Seek(0, $STREAM_SEEK_SET, 0)
	; Make structure in size of binary data
	If $iSize = -1 Then $iSize = 262144 ; IStream my not be fair and return the size. In that case I'll use some reasonably sized buffer and read in loop.
	If ($iWantedSize <> Default) And ($iWantedSize < $iSize) Then $iSize = $iWantedSize
	Local $tBinary = DllStructCreate("byte[" & $iSize & "]")
	; Read to it
	Local $bBinary = Binary(""), $iRead, $iOverallRead
	While 1
		Switch $oStream.Read($tBinary, $iSize, $iRead)
			Case $S_OK
				$iOverallRead += $iRead
				$bBinary &= DllStructGetData($tBinary, 1)
			Case $S_FALSE
				$iOverallRead += $iRead
				$bBinary &= BinaryMid(DllStructGetData($tBinary, 1), 1, $iRead)
				ExitLoop
			Case Else
				ExitLoop
		EndSwitch
		If $iOverallRead <= $iSize Then ExitLoop
	WEnd
	$oStream = 0 ; Stream object needs released first
	__UnZIP_Clean($oShellFolder, $oPersistF, $bNoRelease)
	; Return binary data
	Return $bBinary
EndFunc

Func UnZIP_SaveFileToStream($sZIP, $sFile, ByRef $oShellFolder, ByRef $oPersistF, $bInit = True)
	Local Const $S_OK = 0
	If $bInit Then
		; Create IClassFactory interface object directly from zipfldr.dll
		Local $oClassFactory = __UnZIP_DllGetClassObject($hZIPFLDR_DLL, $CLSID_CZipFolder, $sIID_IClassFactory, $tagIClassFactory)
		If @error Then Return SetError(1, 0, 0)
		; Create instance of IShellFolder
		Local $pShellFolder
		$oClassFactory.CreateInstance(0, $sIID_IShellFolder, $pShellFolder)
		$oShellFolder = ObjCreateInterface($pShellFolder, $sIID_IShellFolder, $tagIShellFolder)
		If @error Then Return SetError(2, 0, 0)
		; Ask for IPersistFile object interface to load ZIP
		$oPersistF = ObjCreateInterface($pShellFolder, $sIID_IPersistFile, $tagIPersistFile)
		If @error Then
			; Try IPersistFolder
			$oPersistF = ObjCreateInterface($pShellFolder, $sIID_IPersistFolder, $tagIPersistFolder)
			If @error Then
				Return SetError(3, 0, 0) ; Dammit!
			Else
				If $oPersistF.Initialize(__UnZIP_SHParseDisplayName($sZIP)) < $S_OK Then Return SetError(4, 0, 0)
			EndIf
		Else
			Local Const $STGM_READ = 0x00000000
			If $oPersistF.Load($sZIP, $STGM_READ) < $S_OK Then Return SetError(4, 0, 0)
		EndIf
	EndIf
	; IShellFolder's ParseDisplayName method is used to "browse" inside the ZIP
	Local Const $SFGAO_STREAM = 0x00400000
	Local $pPidl = 0
	Local $iAttributes = $SFGAO_STREAM
	; Find the file inside the ZIP
	If $oShellFolder.ParseDisplayName(0, 0, $sFile, 0, $pPidl, $iAttributes) < $S_OK Then
		$sFile = StringReplace($sFile, "\", "/") ; XP uses forward slash apparently
		If $oShellFolder.ParseDisplayName(0, 0, $sFile, 0, $pPidl, $iAttributes) < $S_OK Then Return SetError(5, 0, 0)
	EndIf
	; $iAttributes were initially set to SFGAO_STREAM to check if there is stream available
	; I won't be checking $iAttributes if API said "yes", I'll just try to bind:
	Local $pStream
	If $oShellFolder.BindToStorage($pPidl, 0, $sIID_IStream, $pStream) <> $S_OK Then Return SetError(6, __UnZIP_CoTaskMemFree($pPidl), 0)
	__UnZIP_CoTaskMemFree($pPidl)
	; Make IStream interface object out of get pointer
	Local $oStream = ObjCreateInterface($pStream, $sIID_IStream, $tagIStream)
	If @error Then Return SetError(7, 0, 0)
	Return $oStream
EndFunc

Func __UnZIP_Clean(ByRef $vParam1, ByRef $vParam2, $bNoRelease = False)
	If $bNoRelease Then Return
	$vParam1 = 0
	$vParam2 = 0
EndFunc

Func __UnZIP_DllGetClassObject($sDll, $sCLSID, $sIID, $tagInterface = "")
	Local $tCLSID = __UnZIP_GUIDFromString($sCLSID)
	Local $tIID = __UnZIP_GUIDFromString($sIID)
	Local $aCall = DllCall($sDll, "long", "DllGetClassObject", "struct*", $tCLSID, "struct*", $tIID, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Local $oObj = ObjCreateInterface($aCall[3], $sIID, $tagInterface)
	If @error Then Return SetError(2, 0, 0)
	Return $oObj
EndFunc

Func __UnZIP_SHParseDisplayName($sPath)
	Local $aCall = DllCall("shell32.dll", "long", "SHParseDisplayName", "wstr", $sPath, "ptr", 0, "ptr*", 0, "ulong", 0, "ulong*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc

Func __UnZIP_CoTaskMemFree($pMemory)
	DllCall("ole32.dll", "none", "CoTaskMemFree", "ptr", $pMemory)
	If @error Then Return SetError(1, 0, 0)
	Return 1
EndFunc

Func __UnZIP_GUIDFromString($sGUID)
	Local $tGUID = DllStructCreate("byte[16]")
	DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
	If @error Then Return SetError(1, 0, 0)
	Return $tGUID
EndFunc

Func __UnZIP_StringLenW($vString)
	Local $aCall = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $vString)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc