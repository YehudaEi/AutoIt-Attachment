; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.8.2.1
; Author:         Holger Kotsch
;
; Script Function:
;	IconFileScanner 1.3.1 (added few features by G.Sandler (MsCreatoR), and "correction fix" for 3.8.2.1 by ptrex)
;
; ----------------------------------------------------------------------------

#NoTrayIcon
#include <GUIConstants.au3>
Opt("GuiOnEventMode", 1)

HotKeySet("{ESC}", "QuitApp")
HotKeySet("{DOWN}", "UpDownPressed")
HotKeySet("{UP}", "UpDownPressed")

Global Const $LVM_SETCOLUMN			= 0x101A
Global Const $LVM_GETITEM           = $LVM_FIRST + 5

Global $ConfigFile		= StringTrimRight(@ScriptFullPath, 3) & "ini"
Global $szDirType		= RegRead("HKCR\Directory", "")
If $szDirType = "" Then $szDirType = "Directory"
Global $nFirstEntry		= 0, $nLastEntry = 0
Global $szVersion		= "1.3.1"
Global $nCurCol			= -1
Global $nSortDir		= 1
Global $bSet			= 0
Global $nCol			= -1
Global $nIcon			= -1

Global $szCurrentPath 	= IniRead($ConfigFile, "Main Prefs", "Current Folder To Scan", @WindowsDir)
Global $FoldersToScan 	= IniRead($ConfigFile, "Main Prefs", "Folders To Scan", $szCurrentPath)

$hGUI = GUICreate("Icon File Scanner", 585, 342, -1, -1, _
	BitOr($WS_SIZEBOX, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU), $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_CLOSE, "QuitApp")
GUISetOnEvent($GUI_EVENT_RESIZED, "MainEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "MainEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "MainEvents")
GUISetOnEvent($GUI_EVENT_DROPPED, "MainEvents")

GUISetIcon("shell32.dll", -219)

$nFileMenu		= GUICtrlCreateMenu("&File")
$nFileSelFolder	= GUICtrlCreateMenuItem("Select Folder...",$nFileMenu)
$nViewMenu		= GUICtrlCreateMenu("&View")
$nViewMenuItem0	= GUICtrlCreateMenuItem("Icons", $nViewMenu, -1, 1)
$nViewMenuItem1	= GUICtrlCreateMenuItem("Report", $nViewMenu, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$nViewMenuItem2	= GUICtrlCreateMenuItem("SmallIcons", $nViewMenu,-1, 1)
$nViewMenuItem3	= GUICtrlCreateMenuItem("List", $nViewMenu, -1, 1)
$nHelpMenu		= GUICtrlCreateMenu("&Help")
$nAboutItem		= GUICtrlCreateMenuItem("About",$nHelpMenu)

GUICtrlCreateLabel("", 0, 0, 701, 2, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKHEIGHT)

$nPathLabel	= GUICtrlCreateLabel("Path:",5, 5, 30, 18)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$nCurPath	= GUICtrlCreateCombo("", 35, 2, 350, 20)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
If $FoldersToScan <> "" Then GUICtrlSetData(-1, $FoldersToScan, $szCurrentPath)

$nGoButton= GUICtrlCreateButton("Go", 385, 2, 25, 20, $BS_FLAT)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$nPathButton= GUICtrlCreateButton("...", 410, 2, 25, 20, BitOr($BS_ICON, $BS_FLAT))
GUICtrlSetImage(-1, "shell32.dll", 3, 0)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$nDirList	= GUICtrlCreateListView("Name|Size|Type|Changed", 0, 23, 390, 280)
GUICtrlRegisterListViewSort(-1, "LVSort")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlListViewSetColumnFormat($nDirList, 1, $LVCFMT_RIGHT)
GUICtrlSetImage(-1, "shell32.dll", 0)

$nContext	= GUICtrlCreateContextMenu($nDirList)
$viewitem	= GUICtrlCreateMenu("View", $nContext)
$nDirItem0	= GUICtrlCreateMenuItem("Icons", $viewitem, -1, 1)
$nDirItem1	= GUICtrlCreateMenuItem("Report", $viewitem, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$nDirItem2	= GUICtrlCreateMenuItem("SmallIcons", $viewitem,-1, 1)
$nDirItem3	= GUICtrlCreateMenuItem("List", $viewitem, -1, 1)

$OpenWithItem = GUICtrlCreateMenuItem("Open with...", $nContext)
$ShowPropertiesItem = GUICtrlCreateMenuItem("Properties...", $nContext)
GUICtrlCreateMenuItem("", $nContext)
$nInfoItem	= GUICtrlCreateMenuItem("Info", $nContext)

$nIconList	= GUICtrlCreateListView("Icon", 395, 23, 190, 280)
GUICtrlSetStyle(-1, BitOr($LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP)) ;set this LView to LVS_ICON-style cause LVS_ICON=0x0000
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM)

$nIconMenu	= GUICtrlCreateContextMenu($nIconList)
$nIconItem0	= GUICtrlCreateMenuItem("Icons", $nIconMenu, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)

$nIconItem1	= GUICtrlCreateMenuItem("Report", $nIconMenu, -1, 1)
$nIconItem2	= GUICtrlCreateMenuItem("SmallIcons", $nIconMenu,-1, 1)
$nIconItem3	= GUICtrlCreateMenuItem("List", $nIconMenu, -1, 1)

$nFileInfo	= GUICtrlCreateLabel("File:", 0, 305, 390, 18, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT)

$nIconInfo	= GUICtrlCreateLabel("Icons:", 395, 305, 190, 18, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT)

For $i = $nFileSelFolder To $nIconItem3
	GUICtrlSetOnEvent($i, "MainEvents")
Next

GUISetState()

$nFirstItem	= 0
$nLastItem	= 0
$nFirstIcon	= 0
$nLastIcon	= 0
$nOldItem	= 0

DirToList($szCurrentPath)
GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, 0, -1)
GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, 0, -2)

While 1
	Sleep(100)
WEnd

Func MainEvents()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_RESIZED, $GUI_EVENT_MAXIMIZE, $GUI_EVENT_RESTORE
			GUISetState(@SW_LOCK, $hGUI)
			$nStyle = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", GUICtrlGetHandle($nIconList), "int", -16)
			$nStyle = BitAnd($nStyle[0], 0x0003)
			GUICtrlSetStyle($nIconList, BitOr(1, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
			GUICtrlSetStyle($nIconList, BitOr($nStyle, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
			GUISetState(@SW_UNLOCK, $hGUI)
		Case $GUI_EVENT_DROPPED
			If Not StringInStr(FileGetAttrib(@GUI_DragFile), "D") Then Return
			GUICtrlSetData($nCurPath, @GUI_DragFile, @GUI_DragFile)
			ControlClick($hGUI, "", $nGoButton)
		Case $OpenWithItem
			Local $sListStr = GUICtrlRead(GUICtrlRead($nDirList))
			If $sListStr = "" Then Return
			
			RefreshItem(@GUI_CtrlId)
			
			Local $GetFullPath = $szCurrentPath & '\' & StringLeft($sListStr, StringInStr($sListStr, "|")-1)
			Run('rundll32 shell32,OpenAs_RunDLL ' & $GetFullPath)
		Case $ShowPropertiesItem
			Local $sListStr = GUICtrlRead(GUICtrlRead($nDirList))
			If $sListStr = "" Then Return
			
			RefreshItem(@GUI_CtrlId)
			
			Local $GetFullPath = $szCurrentPath & '\' & StringLeft($sListStr, StringInStr($sListStr, "|")-1)
			_ShellExecuteEx($GetFullPath, "", "", "Properties")
		Case $nAboutItem, $nInfoItem
			RefreshItem(@GUI_CtrlId)
			_Msgbox(64, "About", "IconFileScanner " & $szVersion & " by Holger Kotsch", $hGUI)
		Case $nPathButton, $nFileSelFolder, $nGoButton, $nCurPath
			If @GUI_CtrlId = $nGoButton Or @GUI_CtrlId = $nCurPath Then
				$szFolder = GUICtrlRead($nCurPath)
				If Not FileExists($szFolder) Then Return
				$FoldersToScan &= "|" & $szFolder
			Else
				GUISetState(@SW_DISABLE)
				$szFolder = FileSelectFolder("Select folder to scan", "", 0, $szCurrentPath)
				GUISetState(@SW_ENABLE)
			EndIf
			If $szFolder <> "" Then
				$szCurrentPath = $szFolder
				GUICtrlSetData($nCurPath, $szCurrentPath, $szCurrentPath)
				GUICtrlSetData($nFileInfo, "Scanning folder...")
				GUICtrlSetData($nIconInfo, "Icons:")
				For $i = $nFirstIcon To $nLastIcon
					GUICtrlDelete($i)
				Next
				For $i = $nFirstItem To $nLastItem
					GUICtrlDelete($i)
				Next
				$nFirstItem	= 0
				$nLastItem	= 0
				$nFirstIcon	= 0
				$nLastIcon	= 0
				$nOldItem	= 0
				GUISetCursor(1)
				GUICtrlSetCursor($nDirList,1)
				DirToList($szCurrentPath)
				GUISetCursor(2)
				GUICtrlSetCursor($nDirList,2)
			EndIf
		Case $nDirItem0 To $nDirItem3, $nViewMenuItem0 To $nViewMenuItem3
			If @GUI_CtrlId >= $nDirItem0 And @GUI_CtrlId <= $nDirItem3 Then
				$nMsgItem = $nDirItem0
				For $i = 0 To 3
					GUICtrlSetState($nViewMenuItem0 + $i, $GUI_UNCHECKED)
				Next
				GUICtrlSetState($nViewMenuItem0 + @GUI_CtrlId - $nMsgItem, $GUI_CHECKED)
			Else
				$nMsgItem = $nViewMenuItem0
				For $i = 0 To 3
					GUICtrlSetState($nDirItem0 + $i, $GUI_UNCHECKED)
				Next
				GUICtrlSetState($nDirItem0 + @GUI_CtrlId - $nMsgItem, $GUI_CHECKED)
			EndIf
			GUICtrlSetStyle($nDirList, BitOr(@GUI_CtrlId - $nMsgItem, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
			If BitAnd(@GUI_CtrlId - $nMsgItem, $LVS_REPORT) Then
				GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, 0, 200)
				For $i = 1 To 3
					GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, $i, -1)
					GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, $i, -2)
				Next
			EndIf
		Case $nIconItem0 To $nIconItem3
			GUICtrlSetStyle($nIconList, BitOr(@GUI_CtrlId - $nIconItem0, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
		Case $nFirstItem To $nLastItem
			RefreshItem(@GUI_CtrlId)
		Case $nDirList
            $bSet = 0
            $nCurCol = $nCol
            GUICtrlSendMsg($nDirList, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($nDirList), 0)
            DllCall("user32.dll", "int", "InvalidateRect", "hwnd", GUICtrlGetHandle($nDirList), "int", 0, "int", 1)
	EndSwitch
EndFunc

Func RefreshItem($nMsg)
	Local $sListStr = GUICtrlRead(GUICtrlRead($nDirList))
	If Not StringInStr($sListStr, "|") Then Return
	
	If $nOldItem = $nMsg Then Return
	
	$nOldItem = $nMsg
	$szFileInfo = StringSplit($sListStr, "|")
	$szFile = $szFileInfo[1]
	
	If $nFirstIcon > 0 Then
		For $i = $nFirstIcon To $nLastIcon
			GUICtrlDelete($i)
		Next
	EndIf
	
	GUICtrlSetData($nFileInfo, "Type: " & $szFileInfo[3] & "  Changed at: " & $szFileInfo[4] & "  Size: " & $szFileInfo[2])
	$nIcons = FileGetIconCount($szCurrentPath & "\" & $szFile)
	GUICtrlSetData($nIconInfo, "Extracting icons...")
	GUISetCursor(1)
	GUICtrlSetCursor($nIconList,1)
	
	For $i = 1 To $nIcons
		$nIcon = GUICtrlCreateListViewItem($i, $nIconList)
		GUICtrlSetImage(-1, $szCurrentPath & "\" & $szFile, $i * -1)
		If $nFirstIcon = 0 Then $nFirstIcon = $nIcon
	Next
	GUICtrlSetData($nIconInfo, "Icons: " & $nIcons)
	GUISetCursor(2)
	GUICtrlSetCursor($nIconList, 2)
	$nLastIcon = $nIcon
EndFunc

Func UpDownPressed()
	If Not HotKeysHandler($hGUI, "UpDownPressed") Then Return
	
	Local $CountItems = ControlListView($hGUI, "", $nDirList, "GetItemCount")
	Local $SelectedIndex = ControlListView($hGUI, "", $nDirList, "GetSelected")
	Local $NewIndex = $SelectedIndex
	
	Switch @HotKeyPressed
		Case "{DOWN}"
			$NewIndex += 1
		Case "{UP}"
			$NewIndex -= 1
	EndSwitch
	
	If $NewIndex >= $CountItems Or $NewIndex < 0 Then Return
	
	ControlListView($hGui, "", $nDirList, "Select", $NewIndex)
	RefreshItem(GUICtrlRead($nDirList))
	
	Local $hList = GUICtrlGetHandle($nDirList)
	DllCall("user32.dll", "long", "SendMessage", "hwnd", $hList, "int", 0x1013, "int", $NewIndex, "int", 0) ;$LVM_ENSUREVISIBLE
EndFunc

Func HotKeysHandler($hWnd, $FuncName)
	If Not WinActive($hWnd) Then
		HotKeySet(@HotKeyPressed)
		Send(@HotKeyPressed)
		HotKeySet(@HotKeyPressed, $FuncName)
		Return 0
	EndIf
	Return 1
EndFunc

Func _ShellExecuteEx($sCmd, $Args = "", $sFolder = "", $Verb = "", $rState = @SW_SHOWNORMAL, $hWnd = 0)
	Local $struINFO = DllStructCreate("long;long;long;ptr;ptr;ptr;ptr;long;long;long;ptr;long;long;long;long")
	Local $struVerb = DllStructCreate("char[15];char")
	Local $struPath = DllStructCreate("char[255];char")
	Local $struArgs = DllStructCreate("char[255];char")
	Local $struWDir = DllStructCreate("char[255];char")
	
	DllStructSetData($struVerb, 1, $Verb)
	If StringRight($sCmd, 3) = "lnk" Then
		Local $aShortcutInfo = FileGetShortcut($sCmd)
		If IsArray($aShortcutInfo) Then
			DllStructSetData($struPath, 1, $aShortcutInfo[0])
			DllStructSetData($struWDir, 1, $aShortcutInfo[1])
			DllStructSetData($struArgs, 1, $aShortcutInfo[2])
			$rState = $aShortcutInfo[6]
		Else
			Return 0
		EndIf
	Else
		DllStructSetData($struPath, 1, $sCmd)
		DllStructSetData($struWDir, 1, $sFolder)
		DllStructSetData($struArgs, 1, $Args)
	EndIf

	DllStructSetData($struINFO, 1, DllStructGetSize($struINFO))
	DllStructSetData($struINFO, 2, BitOR(0xC, 0x40, 0x400))
	DllStructSetData($struINFO, 3, $hWnd)
	DllStructSetData($struINFO, 4, DllStructGetPtr($struVerb))
	DllStructSetData($struINFO, 5, DllStructGetPtr($struPath))
	DllStructSetData($struINFO, 6, DllStructGetPtr($struArgs))
	DllStructSetData($struINFO, 7, DllStructGetPtr($struWDir))
	DllStructSetData($struINFO, 8, $rState)

	Local $iRet = DllCall("shell32.dll", "int", "ShellExecuteEx", "ptr", DllStructGetPtr($struINFO))
	Return $iRet[0]
EndFunc

Func FileGetIconCount($szFile)
	Local $nCount = 0

	Local $LPCTSTR = DllStructCreate("char[260]")
	DllStructSetData($LPCTSTR, 1, $szFile)
	$nCount = DllCall("shell32.dll", "int", "ExtractIconEx", "ptr", DllStructGetPtr($LPCTSTR), "int", -1, "int", 0, "int", 0, "int", 0)

	Return $nCount[0]
EndFunc

Func DirToList($szPath)
	Dim $hSearch, $szFile, $szDate, $szType, $nItem
	
	$hSearch = FileFindFirstFile($szPath & "\*.*")
	If $hSearch <> -1 Then
		$nItem = -1
		While 1
			$szFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			If $szFile <> "." And $szFile <> ".." And Not StringInStr(FileGetAttrib($szPath & "\" & $szFile), "D") Then
				$szExt = ".ani|.cpl|.ico|.icl|.dll|.exe"
				$szExt = StringSplit($szExt, "|")
				$nExtFound = 0
				For $i = 1 To $szExt[0]
					If StringInStr($szFile, $szExt[$i]) Then
						$nExtFound = 1
						ExitLoop
					EndIf
				Next

				If $nExtFound Then
					$nIcon = 0
					$szIconFile = $szPath & "\" & $szFile
					If FileGetIconCount($szIconFile) > 0 Then
						If FileGetIcon($szIconFile, $nIcon, $szFile) Then
							$szSize = Round(FileGetSize($szPath & "\" & $szFile) / 1000) & " KB"
							$szType = FileGetType($szFile)
							$arDate = FileGetTime($szPath & "\" & $szFile)
							If IsArray($arDate) Then $szDate = $arDate[2] & "." & $arDate[1] & "." & _
								$arDate[0] & " " & $arDate[3] & ":" & $arDate[4]
							$nItem = GUICtrlCreateListViewItem($szFile & "|" & $szSize & "|" & $szType & "|" & $szDate, $nDirList)
							GUICtrlSetImage($nItem, $szIconFile, -$nIcon)
							GUICtrlSetOnEvent($nItem, "MainEvents")
							If $nFirstItem = 0 Then $nFirstItem = $nItem
						EndIf
					EndIf
				EndIf
			EndIf
		WEnd
		FileClose($hSearch)
		$nLastItem = $nItem
		If $nLastItem > 0 Then
			GUICtrlSetData($nFileInfo, $nLastItem - $nFirstItem & " Objects")
		Else
			GUICtrlSetData($nFileInfo, "Ready")
		EndIf
	EndIf
EndFunc

Func FileGetType($szFile)
	Local $szRegDefault = "", $szRegType = ""
	
	$szExt = StringRight($szFile,4)
	$szRegDefault = RegRead("HKCR\" & $szExt,"")
	If $szRegDefault <> "" Then $szRegType = RegRead("HKCR\" & $szRegDefault,"")
	If $szRegType = "" Then $szRegType = $szExt & "-File"
	
	Return $szRegType
EndFunc

Func FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile)
	Local $szRegDefault = "", $szDefIcon = ""
	
	$nIcon = 0
	$szExt = StringRight($szFile,4)
	$szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $szExt,"ProgID")
	If $szRegDefault = "" Then $szRegDefault = RegRead("HKCR\" & $szExt,"")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon","")
	If $szDefIcon = "" Then
		$szIconFile = "shell32.dll"
	ElseIf $szDefIcon <> "%1" Then
		$arSplit = StringSplit($szDefIcon,",")
		If IsArray($arSplit) Then
			$szIconFile = $arSplit[1]
			If $arSplit[0] > 1 Then $nIcon = $arSplit[2]
		Else
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc

Func GUICtrlListViewSetColumnFormat($hListView, $nCol, $nFormat)
	$hListViewHeader = GUICtrlSendMsg($hListView, $LVM_GETHEADER, 0, 0)
	
	Local $LVCOLUMN = DllStructCreate("uint;int;int;ptr;int;int;int;int")
	
	DllStructSetData($LVCOLUMN, 1, $LVCF_FMT)
	DllStructSetData($LVCOLUMN, 2, $nFormat)
	
	GUICtrlSendMsg($hListView, $LVM_SETCOLUMN, $nCol, DllStructGetPtr($LVCOLUMN))
EndFunc

Func LVSort($hWnd, $nItem1, $nItem2, $nColumn)
	Local $nSort
	
	GUICtrlSetCursor($nDirList, 1)
	
	If $nColumn = $nCurCol Then
		If Not $bSet Then
			$nSortDir = $nSortDir * -1
			$bSet = 1
		EndIf
	Else
		$nSortDir = 1
	EndIf
	$nCol = $nColumn
	    
	$val1   = GetSubItemText($nDirList, $nItem1, $nColumn)
	$val2   = GetSubItemText($nDirList, $nItem2, $nColumn)
	
	If $nColumn = 1 Then
		$val1 = Number(StringTrimRight($val1, 3))
		$val2 = Number(StringTrimRight($val2, 3))
	ElseIf $nColumn = 3 Then
		$val1 = StringRight(StringTrimRight($val1, 6), 4) & StringMid($val1, 4, 2) & StringLeft($val1, 2)
		$val2 = StringRight(StringTrimRight($val2, 6), 4) & StringMid($val2, 4, 2) & StringLeft($val2, 2)
	EndIf
	
	$nResult = 0
	
	If $val1 < $val2 Then
		$nResult = -1
	ElseIf  $val1 > $val2 Then
		$nResult = 1
	EndIf
	
	$nResult = $nResult * $nSortDir
	
	GUICtrlSetCursor($nDirList, 2)
	
	Return $nResult
EndFunc

Func GetSubItemText($nCtrlID, $nItemID, $nColumn)
	Local $stLvfi       = DllStructCreate("uint;ptr;int;int[2];int")
	DllStructSetData($stLvfi, 1, $LVFI_PARAM)
	DllStructSetData($stLvfi, 3, $nItemID)
	
	Local $stBuffer     = DllStructCreate("char[260]")
	
	$nIndex = GUICtrlSendMsg($nCtrlID, $LVM_FINDITEM, -1, DllStructGetPtr($stLvfi));
	
	Local $stLvi        = DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int")
	
	DllStructSetData($stLvi, 1, $LVIF_TEXT)
	DllStructSetData($stLvi, 2, $nIndex)
	DllStructSetData($stLvi, 3, $nColumn)
	DllStructSetData($stLvi, 6, DllStructGetPtr($stBuffer))
	DllStructSetData($stLvi, 7, 260)
	
	GUICtrlSendMsg($nCtrlID, $LVM_GETITEM, 0, DllStructGetPtr($stLvi));
	
	Return DllStructGetData($stBuffer, 1)
EndFunc

Func GetComboString($hComboBox, $sDelimiter = "|")
	Local $sDelim = $sDelimiter, $sResult, $nItem, $Struct
	For $i = 0 To GUICtrlSendMsg($hComboBox, $CB_GETCOUNT, 0, 0) - 1
		$Struct = DllStructCreate("char[" & GUICtrlSendMsg($hComboBox, $CB_GETLBTEXTLEN, $i, 0) + 1 & "]")
		DllCall("user32.dll", "int", "SendMessageA", "hwnd", GUICtrlGetHandle($hComboBox), _
			"int", $CB_GETLBTEXT, "int", $i, "ptr", DllStructGetPtr($Struct))
		
		$nItem = DllStructGetData($Struct, 1)
		If $nItem <> "" Then $sResult &= $nItem & $sDelimiter
	Next
	Return StringRegExpReplace($sResult, "\A\" & $sDelim & "+|\" & $sDelim & "+$|(\" & $sDelim & ")+", "\1")
EndFunc

Func _MsgBox($MsgBoxType, $MsgBoxTitle, $MsgBoxText, $hWnd=0)
	Local $iRet = DllCall ("user32.dll", "int", "MessageBox", _
			"hwnd", $hWnd, _
			"str", $MsgBoxText , _
			"str", $MsgBoxTitle, _
			"int", $MsgBoxType)
	Return $iRet[0]
EndFunc

Func QuitApp()
	If Not HotKeysHandler($hGUI, "QuitApp") Then Return
	
	$FoldersToScan = GetComboString($nCurPath, "|")
	$FoldersToScan = StringRegExpReplace($FoldersToScan, "\A\|+|\|+$|(\|)+", "\1")
	
	IniWrite($ConfigFile, "Main Prefs", "Folders To Scan", $FoldersToScan)
	IniWrite($ConfigFile, "Main Prefs", "Current Folder To Scan", GUICtrlRead($nCurPath))
	
	Exit
EndFunc
