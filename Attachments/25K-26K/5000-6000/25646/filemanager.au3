#include <GuiImageList.au3>
#include <GUIListView.au3>
#include <ListViewConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <File.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <Array.au3>
#include <Winapi.au3>
#include<Misc.au3>
#include <Process.au3>
#include <StaticConstants.au3>
#include <GuiConstants.au3>
#include <ScreenCapture.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <sendmessage.au3>

Global Const $tagSHFILEINFO = "dword hIcon; int iIcon; DWORD dwAttributes; CHAR szDisplayName[255]; CHAR szTypeName[80];"
Global Const $SHGFI_USEFILEATTRIBUTES = 0x10
Global Const $SHGFI_SYSICONINDEX = 0x4000
;Global Const $FILE_ATTRIBUTE_NORMAL = 0x80
Global Const $SHGFI_SMALLICON = 0x1
Global Const $SHGFI_LARGEICON = 0x0
Global Const $FOLDER_ICON_INDEX = _GUIImageList_GetFileIconIndex(@SystemDir, 0, 1)
Global Const $NOICON_ICON_INDEX = _GUIImageList_GetFileIconIndex("nb lgl", 0, 0)

Opt("GUIOnEventMode", 1)

Global $GUI_MAIN = GUICreate("", 250, 550, 0, 0, $WS_POPUP, $WS_EX_LAYERED)
GUISetBkColor(0xABCDEF)
GUISetOnEvent(-3,"GUI_Close")
Global $ListView1 = GUICtrlCreateListView("Name|Date", 0, 0, 248, 548)
GUIctrlSetBkColor($ListView1,0xABCDEF)
Global $SHELLLISTVIEWHANDLE = GUICtrlGetHandle($ListView1) ; Get the Handle
_WinAPI_SetLayeredWindowAttributes($GUI_MAIN, 0xABCDEF, 250)
GUICtrlSendMsg($ListView1, 0x101E, 0, 150)
GUICtrlSendMsg($ListView1, 0x101E, 1, 75)

GUIRegisterMsg($WM_NOTIFY, "_SHLV_WM_NOTIFY")

_GUICtrlListView_SetImageList($ListView1, _GUIImageList_GetSystemImageList(), 1)
Global $DIRECTORY_LOCAL = "C:\"
_SHLV_PopulateLocalListView($SHELLLISTVIEWHANDLE,$DIRECTORY_LOCAL)
GUISetState(@SW_SHOW)



While 1
	    $nMsg = GUIGetMsg(1)
    Switch $nMsg[0]
        Case $GUI_EVENT_CLOSE
            Exit
        Case $GUI_EVENT_PRIMARYDOWN
            $hWnd = _SendMessage($nMsg[1], 274, 0xF012, 2,1)
            GUISwitch($nMsg[1])
    EndSwitch
    Sleep(100)
WEnd

Func GUI_Close()
    Exit
EndFunc

Func _Exit()
    Exit
EndFunc

Func _WinAPI_SetLayeredWindowAttributes($hwnd, $i_transcolor, $Transparency = 255, $dwFlages = 0x03, $isColorRef = False)
; #############################################
; You are NOT ALLOWED to remove the following lines
; Function Name: _WinAPI_SetLayeredWindowAttributes
; Author(s): Prog@ndy
; #############################################
    If $dwFlages = Default Or $dwFlages = "" Or $dwFlages < 0 Then $dwFlages = 0x03

    If Not $isColorRef Then
        $i_transcolor = Hex(String($i_transcolor), 6)
        $i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))
    EndIf
    Local $Ret = DllCall("user32.dll", "int", "SetLayeredWindowAttributes", "hwnd", $hwnd, "long", $i_transcolor, "byte", $Transparency, "long", $dwFlages)
    Select
        Case @error
            Return SetError(@error, 0, 0)
        Case $Ret[0] = 0
            Return SetError(4, _WinAPI_GetLastError(), 0)
        Case Else
            Return 1
    EndSelect
EndFunc  ;==>_WinAPI_SetLayeredWindowAttributes

Func _SHLV_PopulateLocalListView($hListView1,ByRef $DIRECTORY_LOCAL)
    If $DIRECTORY_LOCAL = "" Then
        Local $drives = DriveGetDrive("ALL")
        GUICtrlSetData($inpLocalDirectory, "Drive Selection")
        _GUICtrlListView_BeginUpdate($hListView1)
        _GUICtrlListView_DeleteAllItems($hListView1)
        For $i = 1 To $drives[0]
            _GUICtrlListView_AddItem($hListView1, StringUpper($drives[$i]) & "\", _GUIImageList_GetFileIconIndex($drives[$i] & "\"))
        Next
        _GUICtrlListView_EndUpdate($hListView1)
        Return
    EndIf
    If StringRight($DIRECTORY_LOCAL, 1) <> "\" Then $DIRECTORY_LOCAL &= "\"
    If DriveStatus(StringLeft($DIRECTORY_LOCAL, 3)) <> "READY" Then Return 0 * MsgBox(16 + 8192, 'Error on Drive Access', "Drive " & StringLeft($DIRECTORY_LOCAL, 3) & " not ready!")

    $files = _SHLV__FileListToArray2($DIRECTORY_LOCAL, "*", 2)
    If UBound($files)==0 Then Return
    _GUICtrlListView_BeginUpdate($hListView1)
    _GUICtrlListView_DeleteAllItems($hListView1)
    _GUICtrlListView_SetItemCount($hListView1,$files[0])
    _GUICtrlListView_AddItem($hListView1, "[..]", 1)
    If IsArray($files) Then
        For $i = 1 To $files[0]
            $item = _GUICtrlListView_AddItem($hListView1, $files[$i], $FOLDER_ICON_INDEX)
        
        Next
    EndIf
    Local $foldercount
    $files = _SHLV__FileListToArray2($DIRECTORY_LOCAL, "*", 1)
    _GUICtrlListView_EndUpdate($hListView1)
    _GUICtrlListView_BeginUpdate($hListView1)
    _GUICtrlListView_SetItemCount($hListView1,$files[0]+$foldercount)
    If IsArray($files) Then
        For $i = 1 To $files[0]
            $item = _GUICtrlListView_AddItem($hListView1, $files[$i], _GUIImageList_GetFileIconIndex($files[$i]))
            _GUICtrlListView_AddSubItem($hListView1, $item, __SHLV_FileDateString2Calc(FileGetTime($DIRECTORY_LOCAL & $files[$i], 0, 1)), 1)
        Next
    EndIf
    _GUICtrlListView_EndUpdate($hListView1)
EndFunc   ;==>_SHLV_PopulateLocalListView

Func _GUIImageList_GetSystemImageList($bLargeIcons = False)
    Local $dwFlags, $hIml, $FileInfo = DllStructCreate($tagSHFILEINFO)
    $dwFlags = BitOR($SHGFI_USEFILEATTRIBUTES, $SHGFI_SYSICONINDEX)
    If Not ($bLargeIcons) Then
        $dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
    EndIf
    $hIml = _WinAPI_SHGetFileInfo(".txt", $FILE_ATTRIBUTE_NORMAL, _
            DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), $dwFlags)
    Return $hIml
EndFunc   ;==>_GUIImageList_GetSystemImageList

Func _WinAPI_SHGetFileInfo($pszPath, $dwFileAttributes, $psfi, $cbFileInfo, $uFlags)
    Local $return = DllCall("shell32.dll", "DWORD*", "SHGetFileInfo", "str", $pszPath, "DWORD", $dwFileAttributes, "ptr", $psfi, "UINT", $cbFileInfo, "UINT", $uFlags)
    If @error Then Return SetError(@error, 0, 0)
    Return $return[0]
EndFunc   ;==>_WinAPI_SHGetFileInfo

; Prog@ndy
Func _GUIImageList_GetFileIconIndex($sFileSpec, $bLargeIcons = False, $bForceLoadFromDisk = False)
    Local $dwFlags, $FileInfo = DllStructCreate($tagSHFILEINFO)

    $dwFlags = $SHGFI_SYSICONINDEX
    If $bLargeIcons Then
        $dwFlags = BitOR($dwFlags, $SHGFI_LARGEICON)
    Else
        $dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
    EndIf
    If Not $bForceLoadFromDisk Then
        $dwFlags = BitOR($dwFlags, $SHGFI_USEFILEATTRIBUTES)
    EndIf
    Local $lR = _WinAPI_SHGetFileInfo( _
            $sFileSpec, $FILE_ATTRIBUTE_NORMAL, DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), _
            $dwFlags _
            )

    If ($lR = 0) Then
        Return SetError(1, 0, -1)
    Else
        Return DllStructGetData($FileInfo, "iIcon")
    EndIf
EndFunc   ;==>_GUIImageList_GetFileIconIndex

Func __SHLV_FileDateString2Calc($filedate)
    Return StringLeft(StringRegExpReplace($filedate, "(\d{4})(\d{2})(\d{2})", "$1/$2/$3"),10)
EndFunc   ;==>_FileDateString2Calc

Func _SHLV_WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _SHLV__FileListToArray2($sPath, $sFilter = "*", $iFlag = 0)
    Local $hSearch, $sFile, $asFileList
    If Not FileExists($sPath) Then Return SetError(1, 1, "")
    If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringInStr($sFilter, "|")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
    If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
    If (StringMid($sPath, StringLen($sPath), 1) = "\") Then $sPath = StringTrimRight($sPath, 1) ; needed for Win98 for x:\  root dir
    $hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
    If $hSearch = -1 Then Return SetError(4, 4, "")
    While 1
        $sFile = FileFindNextFile($hSearch)
        If @error Then
            SetError(0)
            ExitLoop
        EndIf
        If $iFlag = 1 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
        If $iFlag = 2 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
        $asFileList &= $sFile & @CR
    WEnd
    FileClose($hSearch)
    Return StringSplit(StringTrimRight($asFileList,1),@CR)
EndFunc   ;==>_SHLV__FileListToArray2