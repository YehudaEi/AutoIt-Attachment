; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.2.4.9
; Author:         Holger Kotsch
;
; Script Function:
;	IconFileScanner 1.3
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>

Global Const $LVM_SETCOLUMN			= 0x101A
Global Const $LVM_GETITEM           = $LVM_FIRST + 5

Global $arIconFiles[1000]

Global $szDirType		= RegRead("HKCR\Directory", "")
If $szDirType = "" Then $szDirType = "Directory"
Global $nFirstEntry		= 0, $nLastEntry = 0
Global $szCurrentPath	= @WindowsDir
Global $szVersion		= "1.3"
Global $nCurCol			= -1
Global $nSortDir		= 1
Global $bSet			= 0
Global $nCol			= -1


$hGUI			= GUICreate("Icon File Scanner", 585, 342, -1, -1, BitOr($WS_SIZEBOX, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU))

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
$nCurPath	= GUICtrlCreateCombo($szCurrentPath, 35, 2, 350, 20)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
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
GUICtrlCreateMenuItem("",$nContext)
$nInfoItem	= GUICtrlCreateMenuItem("Info", $nContext)
$nDirItem0	= GUICtrlCreateMenuItem("Icons", $viewitem, -1, 1)
$nDirItem1	= GUICtrlCreateMenuItem("Report", $viewitem, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$nDirItem2	= GUICtrlCreateMenuItem("SmallIcons", $viewitem,-1, 1)
$nDirItem3	= GUICtrlCreateMenuItem("List", $viewitem, -1, 1)

$nIconList	= GUICtrlCreateListView("Icon", 395, 23, 190, 280)
GUICtrlSetStyle(-1, BitOr($LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP)) ; set this ListView to LVS_ICON-style cause LVS_ICON = 0x0000
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
	$nMsg = GUIGetMsg ()
     
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $GUI_EVENT_RESIZED
			GUISetState(@SW_LOCK, $hGUI)
			$nStyle = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", GUICtrlGetHandle($nIconList), "int", -16)
			$nStyle = BitAnd($nStyle[0], 0x0003)
			GUICtrlSetStyle($nIconList, BitOr(1, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
			GUICtrlSetStyle($nIconList, BitOr($nStyle, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
			GUISetState(@SW_UNLOCK, $hGUI)
			
		Case $nAboutItem, $nInfoItem
			Msgbox(0 ,"About", "IconFileScanner " & $szVersion & " by Holger Kotsch")
			
		Case $nPathButton, $nFileSelFolder, $nGoButton, $nCurPath
			If $nMsg = $nGoButton Or $nMsg = $nCurPath Then
				$szFolder = GUICtrlRead($nCurPath)
				If Not FileExists($szFolder) Then ContinueLoop
			Else
				$szFolder = FileSelectFolder("Select folder to scan", "", 0, $szCurrentPath)
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
			
		Case $nDirItem0 To $nDirItem3,  $nViewMenuItem0 To $nViewMenuItem3
			If $nMsg >= $nDirItem0 And $nMsg <= $nDirItem3 Then
				$nMsgItem = $nDirItem0
				For $i = 0 To 3
					GUICtrlSetState($nViewMenuItem0 + $i, $GUI_UNCHECKED)
				Next
				GUICtrlSetState($nViewMenuItem0 + $nMsg - $nMsgItem, $GUI_CHECKED)
			Else
				$nMsgItem = $nViewMenuItem0
				For $i = 0 To 3
					GUICtrlSetState($nDirItem0 + $i, $GUI_UNCHECKED)
				Next
				GUICtrlSetState($nDirItem0 + $nMsg - $nMsgItem, $GUI_CHECKED)
			EndIf
			GUICtrlSetStyle($nDirList, BitOr($nMsg - $nMsgItem, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
			If BitAnd($nMsg - $nMsgItem, $LVS_REPORT) Then
				GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH,0,200)
				For $i = 1 To 3
					GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, $i,-1)
					GUICtrlSendMsg($nDirList, $LVM_SETCOLUMNWIDTH, $i,-2)
				Next
			EndIf
			
		Case $nIconItem0 To $nIconItem3
			GUICtrlSetStyle($nIconList, BitOr($nMsg - $nIconItem0, $LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $WS_TABSTOP))
		
		Case $nFirstItem To $nLastItem
			If $nMsg <> $nOldItem Then
				$nOldItem = $nMsg
				$szFileInfo = StringSplit(GUICtrlRead($nMsg),"|")
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
				For $i = 0 To $nIcons - 1
					$nIcon = GUICtrlCreateListViewItem($i, $nIconList)
					GUICtrlSetImage(-1,$szCurrentPath & "\" & $szFile,$i)
					If $nFirstIcon = 0 Then $nFirstIcon = $nIcon
				Next
				GUICtrlSetData($nIconInfo, "Icons: " & $nIcons)
				GUISetCursor(2)
				GUICtrlSetCursor($nIconList,2)
				$nLastIcon = $nIcon
			EndIf
		
		Case $nDirList
            $bSet = 0
            $nCurCol = $nCol
            GUICtrlSendMsg($nDirList, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($nDirList), 0)
            DllCall("user32.dll", "int", "InvalidateRect", "hwnd", GUICtrlGetHandle($nDirList), "int", 0, "int", 1)

	EndSwitch
WEnd


Exit


Func FileGetIconCount($szFile)
	Local $nCount = 0

	Local $LPCTSTR = DllStructCreate("char[260]")
	DllStructSetData($LPCTSTR, 1, $szFile)
	$nCount = DllCall("shell32.dll", "int", "ExtractIconEx", "ptr", DllStructGetPtr($LPCTSTR), "int", -1, "int", 0, "int", 0, "int", 0)

	Return $nCount[0]
EndFunc


Func DirToList($szPath)
	Local $hSearch, $szFile, $szDate, $szType, $nItem
	
	$hSearch = FileFindFirstFile($szPath & "\*.*")
	If $hSearch <> -1 Then
		$nItem = -1
		While 1
			$szFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			If $szFile <> "." And $szFile <> ".." And Not StringInStr(FileGetAttrib($szPath & "\" & $szFile),"D") Then
				
				$szExt = ".ani|.cpl|.ico|.icl|.dll|.exe"
				$szExt = StringSplit($szExt,"|")
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
							If IsArray($arDate) Then $szDate = $arDate[2] & "." & $arDate[1] & "." & $arDate[0] & " " & $arDate[3] & ":" & $arDate[4]
							$nItem = GUICtrlCreateListViewItem($szFile & "|" & $szSize & "|" & $szType & "|" & $szDate, $nDirList)
							GUICtrlSetImage(-1,$szIconFile,$nIcon)
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
