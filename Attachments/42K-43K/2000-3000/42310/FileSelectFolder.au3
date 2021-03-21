; FileSelectFolder.au3
;.......script written by trancexx (trancexx at yahoo dot com)

; Donations to help me write more are very welcome. I can receive them via PayPal address: trancexx at yahoo dot com
; Thank you for the shiny stuff :kiss:

#include-once

;===============================================================================
#interface "IShellItem"
Global Const $sIID_IShellItem = "{43826d1e-e718-42ee-bc55-a1e261c37bfe}"
Global $tagIShellItem = "BindToHandler hresult(ptr;clsid;clsid;ptr*);" & _
		"GetParent hresult(ptr*);" & _
		"GetDisplayName hresult(int;ptr*);" & _
		"GetAttributes hresult(int;int*);" & _
		"Compare hresult(ptr;int;int*);"
;===============================================================================
;===============================================================================
#interface "IShellItemArray"
Global Const $sIID_IShellItemArray = "{b63ea76d-1f85-456f-a19c-48159efa858b}"
Global $tagIShellItemArray = "BindToHandler hresult(ptr;clsid;clsid;ptr*);" & _
		"GetPropertyStore hresult(int;clsid;ptr*);" & _
		"GetPropertyDescriptionList hresult(struct*;clsid;ptr*);" & _
		"GetAttributes hresult(int;int;int*);" & _
		"GetCount hresult(dword*);" & _
		"GetItemAt hresult(dword;ptr*);" & _
		"EnumItems hresult(ptr*);"
;===============================================================================
;===============================================================================
#interface "IModalWindow"
Global Const $sIID_IModalWindow = "{b4db1657-70d7-485e-8e3e-6fcb5a5c1802}"
Global $tagIModalWindow = "Show hresult(hwnd);"
;===============================================================================
;===============================================================================
#interface "IFileDialog"
Global Const $sIID_IFileDialog = "{42f85136-db7e-439c-85f1-e4075d135fc8}"
Global $tagIFileDialog = $tagIModalWindow & _
		"SetFileTypes hresult(uint;ptr);" & _
		"SetFileTypeIndex hresult(uint);" & _
		"GetFileTypeIndex hresult(uint*);" & _
		"Advise hresult(ptr;dword*);" & _
		"Unadvise hresult(dword);" & _
		"SetOptions hresult(int);" & _
		"GetOptions hresult(int*);" & _
		"SetDefaultFolder hresult(ptr);" & _
		"SetFolder hresult(ptr);" & _
		"GetFolder hresult(ptr*);" & _
		"GetCurrentSelection hresult(ptr*);" & _
		"SetFileName hresult(wstr);" & _
		"GetFileName hresult(ptr*);" & _
		"SetTitle hresult(wstr);" & _
		"SetOkButtonLabel hresult(wstr);" & _
		"SetFileNameLabel hresult(wstr);" & _
		"GetResult hresult(ptr*);" & _
		"AddPlace hresult(ptr;int);" & _
		"SetDefaultExtension hresult(wstr);" & _
		"Close hresult();" & _
		"SetClientGuid hresult(clsid);" & _
		"ClearClientData hresult();" & _
		"SetFilter hresult(ptr);"
;===============================================================================
;===============================================================================
#interface "IFileOpenDialog"
Global Const $sCLSID_FileOpenDialog = "{DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7}"
Global Const $sIID_IFileOpenDialog = "{d57c7288-d4ad-4768-be02-9d969532d960}"
Global $tagIFileOpenDialog = $tagIFileDialog & _
		"GetResults hresult(ptr*);" & _
		"GetSelectedItems hresult(ptr*);"
;===============================================================================

; Initiates a Browse For Folder dialog - new Windows style - if available. If not available old style gets invoked.
; Same parameters as built-in functions plus few more :P.
Func FileSelectFolder2($sDialogText, $sRootDir, $iFlag = 0, $sInitialDir = "", $hWindow = 0, $iFlags = Default, $sButtonText = Default)
	Local $oIFileDialog = ObjCreateInterface($sCLSID_FileOpenDialog, $sIID_IFileOpenDialog, $tagIFileOpenDialog)
	If @error Then Return FileSelectFolder($sDialogText, $sRootDir, $iFlag, $sInitialDir, $hWindow)

	$oIFileDialog.SetTitle($sDialogText)
	If $sButtonText <> Default Then $oIFileDialog.SetOkButtonLabel($sButtonText)
	If $sRootDir = "" Then $sRootDir = @DesktopDir

	Local $pIDL = FSF_SHParseDisplayName($sRootDir)
	Local $oRoot = ObjCreateInterface(FSF_SHCreateShellItem($pIDL), $sIID_IShellItem, $tagIShellItem)
	If @error Then Return FileSelectFolder($sDialogText, $sRootDir, $iFlag, $sInitialDir, $hWindow)
	FSF_CoTaskMemFree($pIDL)

	$oIFileDialog.SetFolder($oRoot())
	$oIFileDialog.SetFileName($sInitialDir)
	Local Const $FOS_PICKFOLDERS = 0x20
	if $iFlags = Default Then $iFlags = $FOS_PICKFOLDERS
	$oIFileDialog.SetOptions($iFlags)
	$oIFileDialog.Show($hWindow) ; Tada mtfk!

	Local $pShellItemArray
	$oIFileDialog.GetResults($pShellItemArray)
	Local $oShellItemArray = ObjCreateInterface($pShellItemArray, $sIID_IShellItemArray, $tagIShellItemArray)
	If @error Then Return SetError(1, 0, "")
	Local $iCount
	$oShellItemArray.GetCount($iCount)
	Local $pShellItem, $oIShellItem, $pName, $sName
	Local Const $S_OK = 0
	Local Const $SIGDN_DESKTOPABSOLUTEEDITING = 0x8004c000, $SIGDN_FILESYSPATH = 0x80058000
	For $i = 0 To $iCount - 1
		$oShellItemArray.GetItemAt($i, $pShellItem)
		$oIShellItem = ObjCreateInterface($pShellItem, $sIID_IShellItem, $tagIShellItem)
		If @error Then ContinueLoop
		If $oIShellItem.GetDisplayName($SIGDN_FILESYSPATH, $pName) <> $S_OK Then
			If $oIShellItem.GetDisplayName($SIGDN_DESKTOPABSOLUTEEDITING, $pName) <> $S_OK Then Return SetError(2, 0, "")
		EndIf
		$sName &= DllStructGetData(DllStructCreate("wchar[" & FSF_StringLenW($pName) + 1 & "]", $pName), 1) & "|"
		FSF_CoTaskMemFree($pName)
	Next

	Return StringTrimRight($sName, 1)
EndFunc

; Few helper functions down below...
Func FSF_SHParseDisplayName($sPath)
	Local $aCall = DllCall("shell32.dll", "long", "SHParseDisplayName", "wstr", $sPath, "ptr", 0, "ptr*", 0, "ulong", 0, "ulong*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc
Func FSF_SHCreateShellItem($pPIDL)
	Local $aCall = DllCall("shell32.dll", "long", "SHCreateShellItem", "ptr", 0, "ptr", 0, "ptr", $pPIDL, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[4]
EndFunc
Func FSF_CoTaskMemFree($pMemory)
	DllCall("ole32.dll", "none", "CoTaskMemFree", "ptr", $pMemory)
	If @error Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func FSF_StringLenW($vString)
	Local $aCall = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $vString)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc
