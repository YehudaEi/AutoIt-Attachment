; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.73
; Author:         Holger Kotsch
; Version: 1.1
;
; Script Function:
;	Unfinished Explorer-like sample (Preview)
;
; !!! Self-API-created items are not supported !!!
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <GUITreeView.au3>
#include <Misc.au3>

; TV functions
Global Const $TVM_INSERTITEM			= $TV_FIRST + 0
Global Const $TVM_GETITEMRECT			= $TV_FIRST + 4
Global Const $TVM_SETIMAGELIST			= $TV_FIRST + 9
Global Const $TVM_SETITEM				= $TV_FIRST + 13
Global Const $TVM_HITTEST				= $TV_FIRST + 17

Global Const $TVI_FIRST					= 0xFFFF0001

; Masks
Global Const $TVIF_IMAGE				= 0x0002
Global Const $TVIF_HANDLE				= 0x0010
Global Const $TVIF_SELECTEDIMAGE		= 0x0020
Global Const $TVIF_CHILDREN				= 0x0040

; States
Global Const $TVIS_CUT					= 0x0004
Global Const $TVIS_DROPHILITED			= 0x0008
Global Const $TVIS_BOLD					= 0x0010
Global Const $TVIS_EXPANDED				= 0x0020

; Relationship/specific item
Global Const $TVGN_ROOT					= 0x0000
Global Const $TVGN_PREVIOUS				= 0x0002
Global Const $TVGN_FIRSTVISIBLE			= 0x0005
Global Const $TVGN_NEXTVISIBLE			= 0x0006
Global Const $TVGN_PREVIOUSVISIBLE		= 0x0007
Global Const $TVGN_DROPHILITE			= 0x0008

; Hittest infos
Global Const $TVHT_NOWHERE				= 0x0001
Global Const $TVHT_ONITEMICON			= 0x0002
Global Const $TVHT_ONITEMLABEL			= 0x0004
Global Const $TVHT_ONITEMINDENT			= 0x0008
Global Const $TVHT_ONITEMBUTTON			= 0x0010
Global Const $TVHT_ONITEMRIGHT			= 0x0020
Global Const $TVHT_ONITEMSTATEICON		= 0x0040
Global Const $TVHT_ONITEM				= BitOr($TVHT_ONITEMICON, $TVHT_ONITEMLABEL, $TVHT_ONITEMSTATEICON)
Global Const $TVHT_ABOVE				= 0x0100
Global Const $TVHT_BELOW				= 0x0200
Global Const $TVHT_TORIGHT				= 0x0400
Global Const $TVHT_TOLEFT				= 0x0800

If Not IsDeclared("LVM_SETEXTENDEDLISTVIEWSTYLE")	Then Global Const $LVM_SETEXTENDEDLISTVIEWSTYLE	= 0x1036
If Not IsDeclared("LVM_SETCOLUMN")					Then Global Const $LVM_SETCOLUMN				= 0x101A
If Not IsDeclared("LVCF_FMT")						Then Global Const $LVCF_FMT						= 0x0001
If Not IsDeclared("LVCFMT_RIGHT")					Then Global Const $LVCFMT_RIGHT					= 0x0001
If Not IsDeclared("LVM_GETHEADER")					Then Global Const $LVM_GETHEADER				= 0x101F

Global $nCtrls = 0
Global $hCurItem = 0
Global $hImageList = 0

Global $szDirType = RegRead("HKCR\Directory", "")
If $szDirType = "" Then $szDirType = "Directory"

$hGui = GUICreate("AutoIt3-Explorer V1.1 ;-)", 762, 578, -1, -1, BitOr($WS_SIZEBOX, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU))

$nFileMenu		= GUICtrlCreateMenu("&File")
$editMenu		= GUICtrlCreateMenu("&Edit")
$nViewMenu		= GUICtrlCreateMenu("&View")
$nViewItem1		= GUICtrlCreateMenuItem("Icons", $nViewMenu, -1, 1)
$nViewItem2		= GUICtrlCreateMenuItem("Report", $nViewMenu, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$nViewItem3		= GUICtrlCreateMenuItem("Small Icons", $nViewMenu, -1, 1)
$nViewItem4		= GUICtrlCreateMenuItem("List", $nViewMenu, -1, 1)
$nExtraMenu		= GUICtrlCreateMenu("E&xtra")
$nHelpMenu		= GUICtrlCreateMenu("&?")
$nExitItem		= GUICtrlCreateMenuItem("Exit",$nFileMenu)
$nAboutItem		= GUICtrlCreateMenuItem("About",$nHelpMenu)

GUICtrlCreateLabel("", 0, 0, 800, 2, BitOr($SS_SUNKEN, $SS_BLACKRECT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)

GUICtrlCreateLabel("Address", 5, 5, 50, 20)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

$nAddressbar	= GUICtrlCreateCombo("C:\", 50, 3, 600, 20)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)

$arDrives		= DriveGetDrive("ALL")

$nTreeView		= GUICtrlCreateTreeView(0, 25, 310, 513, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
GUICtrlSetState(-1, $GUI_FOCUS)
GUICtrlSetImage(-1, "shell32.dll", 3, 4)	;
GUICtrlSetImage(-1, "shell32.dll", 4, 2)	;
GUICtrlSetImage(-1, "shell32.dll", 7)		; Removable
GUICtrlSetImage(-1, "shell32.dll", 8)		; Fixed
GUICtrlSetImage(-1, "shell32.dll", 9)		; Network
GUICtrlSetImage(-1, "shell32.dll", 11)		; CD-ROM

$nListView		= GUICtrlCreateListView("Name|Size|Type|Changed",314, 25, 447, 513)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlListViewSetColumnFormat($nListView, 1, $LVCFMT_RIGHT)
GUICtrlSetImage(-1, "shell32.dll", 0)

$statusbarobj	= GUICtrlCreateLabel(" Object(s)",0, 540, 150, 18, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
$statusbarsize	= GUICtrlCreateLabel(" MB (Free Space: 0 MB)", 152, 540, 610, 18, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)

$nSplitter		= GUICtrlCreateLabel("", 310, 29, 4, 509)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
GUICtrlSetCursor(-1, 13)

GUISetState()

FillTreeRoot($arDrives)
UpdateWindow($nTreeView)

$nFirstItem	= 0
$nLastItem	= 0
$nOldItem	= 0

DirToList("C:")
$szCurrentPath = "C:"
$szOldPath = ""

$curx = 0
$curpressed = 0
$splitx1 = 48
$splitx2 = 52
$savex = 310
$pressed = 0

While 1
	$nMsg = GUIGetMsg()
	$arInfo = GUIGetCursorInfo()
	If $pressed = 1 And $arInfo[2] = 0 Then $pressed = 0
	If $pressed = 1 And $arInfo[2] = 1 Then
		$arPos = WinGetPos($hGui)
		If $arInfo[0] > 100 And $arInfo[0] < $arPos[2] - 100 Then
			If $arInfo[0] <> $savex Then
				ControlMove($hGui, "", $nSplitter, $arInfo[0] - 2, 29)
				ControlMove($hGui, "", $nTreeView, 0, 25, $arInfo[0] - 2)
				ControlMove($hGui, "", $nListView, $arInfo[0] + 2, 25, $arPos[2] - $arInfo[0] - 10)
				$savex = $arInfo[0]
			EndIf
		EndIf
	EndIf
	
	If $arInfo[4] = $nTreeView And $arInfo[2] And WinActive($hGui) Then
		$nFlag = 0
		$hItem = TV_Hittest($nTreeView, $nFlag)
				
		If BitAnd($nFlag, $TVHT_ONITEMBUTTON) Or BitAnd($nFlag, $TVHT_ONITEM) Then
			GUISetState(@SW_LOCK)
			CheckTreeFill($nTreeView, $hItem)
			GUISetState(@SW_UNLOCK)
			GUICtrlSetData($nAddressbar, GetTreePath($nTreeView, $hItem, "\"))
		EndIf
		$hItem = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
		$szCurrentPath = GetTreePath($nTreeView, $hItem, "\")
		
		If BitAnd($nFlag, $TVHT_ONITEM) Then GUICtrlSetData($nAddressbar, $szCurrentPath)
		
		If $szOldPath <> $szCurrentPath Then
			$szOldPath = $szCurrentPath
			GUISetState(@SW_LOCK)
			For $i = $nFirstItem To $nLastItem
				GUICtrlDelete($i)
			Next
			GUISetState(@SW_UNLOCK)
			;UpdateCtrl($hGui, $nListView)
			$nFirstItem	= 0
			$nLastItem	= 0
			$nOldItem	= 0
			GUICtrlSetData($nAddressbar, $szCurrentPath)
			GUICtrlSetCursor($nListView,1)
			GUICtrlSetCursor($nTreeView,1)
			DirToList($szCurrentPath)
			GUICtrlSetCursor($nListView,2)
			GUICtrlSetCursor($nTreeView,2)
		EndIf
	ElseIf _IsPressed("6B") And ControlGetFocus($hGui) = "SysTreeView321" Then
		$hItem = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
		CheckTreeFill($nTreeView, $hItem)
	EndIf
	
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $nExitItem
			ExitLoop
		
		Case $nAboutItem
			Msgbox(64,"About","Demo by Holger")
			
		Case $nSplitter
			$cinfo = GUIGetCursorInfo()
			If $cinfo[2] = 1 Then $pressed = 1
			
		Case $nViewItem1 To $nViewItem4
			GUICtrlSetStyle($nListView, BitOr($LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $nMsg - $nViewItem1))
	EndSwitch
WEnd

Exit


Func CheckTreeFill($nCtrl, $hItem)
	If $hItem > 0 Then
		$hChild = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem)
		If $hChild > 0 Then
			$szText = GetItemText($nTreeView, $hChild)
			If $szText = "" Then
				$szPath = GetTreePath($nTreeView, $hItem, "\")
				If StringRight($szPath, 1) = "\" Then $szPath = StringTrimRight($szPath, 1)
				GUICtrlSetCursor($nTreeView, 1)
				FillTree($szPath, $hItem, $hChild)
				GUICtrlSetCursor($nTreeView, 2)
			EndIF
		EndIf
	EndIf
EndFunc


Func FillTreeRoot($arDrives)
	Local $hSearch, $szFile, $nChildren, $szDriveLabel
	
	$hParent = 0
	For $i = 1 To $arDrives[0]
		$nChildren = 0
		If GetSubFolder($arDrives[$i]) Then $nChildren = 1
		$szType = DriveGetType($arDrives[$i])
		Switch $szType
			Case "Removable"
				$iImage = 2
				$iSelectedImage = 2
			Case "Fixed"
				$iImage = 3
				$iSelectedImage = 3
			Case "Network"
				$iImage = 4
				$iSelectedImage = 4
			Case "CDROM"
				$iImage = 5
				$iSelectedImage = 5
			Case Else
				$iImage = 0
				$iSelectedImage = 0
		EndSwitch
		
		If $szType = "Removable" Then
			$szText = "Removable"
		ElseIf $szType = "Network" Then
			$szLabel = DriveMapGet($arDrives[$i])
			$nPos = StringInStr($szLabel, "\", 0, -1)
			$szText = StringRight($szLabel, StringLen($szLabel) - $nPos) & " on """ & StringTrimLeft(StringLeft($szLabel, $nPos - 1), 2) & """"
			 
		Else
			$szText = DriveGetLabel($arDrives[$i])
		EndIf
		$szDriveLabel =  $szText & " (" & StringUpper($arDrives[$i]) & ")"
		$hItem = InsertItem($szDriveLabel, $hParent, $hCurItem, $nChildren, $iImage, $iSelectedImage)
		If $nChildren = 1 Then InsertDummyItem($nTreeView, $hItem)
	Next
	$hItem = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TVGN_ROOT, 0)
	GUICtrlSendMsg($nTreeView, $TVM_SELECTITEM, $TVGN_CARET, $hItem)

EndFunc


Func FillTree($szPath, $hParent = 0, $hDelete = 0)
	Local $hSearch, $szFile, $nChildren
	
	If $hDelete > 0 Then
		GUICtrlSendMsg($nTreeView, $TVM_DELETEITEM, 0, $hDelete)
		SetItemChildren($hParent)
	EndIf
	
	$hSearch = FileFindFirstFile($szPath & "\*.*")  
	If $hSearch = -1 Then Return

	While 1
    	$szFile = FileFindNextFile($hSearch) 
	    If @error Then ExitLoop
	    If StringInStr(FileGetAttrib($szPath & "\" & $szFile), "D") Then
	    	$nChildren = 0
	    	If GetSubFolder($szPath & "\" & $szFile) Then $nChildren = 1
			
	    	$hItem = InsertItem($szFile, $hParent, $hCurItem, $nChildren)
	    	If $nChildren = 1 Then InsertDummyItem($nTreeView, $hItem)
	    	$nCtrls = $nCtrls + 1
    	EndIf
	WEnd
	FileClose($hSearch)
EndFunc


Func GetSubFolder($szPath)
	Local $hSearch, $szFile, $nChildren = 0
	
	$hSearch = FileFindFirstFile($szPath & "\*.*")  
	If $hSearch = -1 Then Return

	While 1
    	$szFile = FileFindNextFile($hSearch) 
	    If @error Then ExitLoop
	    If StringInStr(FileGetAttrib($szPath & "\" & $szFile), "D") Then
	    	$nChildren = 1
	    	ExitLoop
    	EndIf    	
	WEnd
	FileClose($hSearch)
	
	Return $nChildren
EndFunc


Func InsertItem($szText, $hParent, $hInsertAfter, $nChildren, $iImage = 0, $iSelectedImage = 1)

	$pszText = DllStructCreate("char[260]")
	DllStructSetData($pszText, 1, $szText)
	
	$tvItem = TVITEM()
	$tvInsertStruct = DllStructCreate("int;int;int[10]")

	If $hCurItem = 0 Then
		$hInsertAfter = $TVI_FIRST
	Else
		$hInsertAfter = $hCurItem
	EndIf
	DllStructSetData($tvInsertStruct, 1, $hParent)
	DllStructSetData($tvInsertStruct, 2, $hInsertAfter)
	DllStructSetData($tvInsertStruct, 3, $tvItem)
	
	$hItem = GUICtrlSendMsg($nTreeView, $TVM_INSERTITEM, 0, DllStructGetPtr($tvInsertStruct))
	If $hItem > 0 Then
		$hCurItem = $hItem
		
		DllStructSetData($tvItem, 1, BitOr($TVIF_TEXT, $TVIF_IMAGE, $TVIF_SELECTEDIMAGE))
		DllStructSetData($tvItem, 2, $hItem)
		DllStructSetData($tvItem, 5, DllStructGetPtr($pszText))
		DllStructSetData($tvItem, 7, $iImage)
		DllStructSetData($tvItem, 8, $iSelectedImage)
		GUICtrlSendMsg($nTreeView, $TVM_SETITEM, 0, DllStructGetPtr($tvItem))
	EndIf

	DllStructDelete($tvInsertStruct)
	DllStructDelete($tvItem)
	DllStructDelete($pszText)
	
	Return $hItem
EndFunc


Func InsertDummyItem($nCtrl, $hItem)
	InsertItem("", $hItem, $hCurItem, 0)
EndFunc


Func TV_Hittest($nCtrl, ByRef $nFlag = 0)

	$hItem	= 0
	$point = DllStructCreate("int;int")
	DllCall("user32.dll", "int", "GetCursorPos", "ptr", DllStructGetPtr($point))
	
	$hWnd = ControlGetHandle("", "", $nCtrl)
	DllCall("user32.dll", "int", "ScreenToClient", "hwnd", $hWnd, "ptr", DllStructGetPtr($point))
	
	$tvHit = DllStructCreate("int[2];uint;int")
	DllStructSetData($tvHit, 1, DllStructGetData($point, 1), 1)
	DllStructSetData($tvHit, 1, DllStructGetData($point, 2), 2)
	
	If GUICtrlSendMsg($nCtrl, $TVM_HITTEST, 0, DllStructGetPtr($tvHit)) Then
		$nFlag = DllStructGetData($tvHit, 2)
		$hItem = DllStructGetData($tvHit, 3)
	EndIf
 
	DllStructDelete($tvHit)
	DllStructDelete($point)
	
	Return $hItem		
EndFunc


Func ItemHasChildren($nCtrl, $hItem)
	$nChildren = 0
	If GUICtrlSendMsg($nCtrl, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem) > 0 Then $nChildren = 1
	Return $nChildren
EndFunc


Func ExpandTree($nCtrl, $hItem)
	$result = GUICtrlSendMsg($nCtrl, $TVM_EXPAND, 0x0002, $hItem)
EndFunc


Func GetTreePath($nCtrl, $hItem, $szSepChar)
	Local $szPath = "", $hParent, $hWnd, $szText
   
	While $hItem > 0
		$szText = GetItemText($nCtrl, $hItem)
		$hParent = GUICtrlSendMsg($nCtrl, $TVM_GETNEXTITEM, $TVGN_PARENT, $hItem)
		If $hParent = 0 Then $szText = StringRight(StringTrimRight($szText, 1), 2)
		$szPath = $szText & $szSepChar & $szPath
		$hItem = $hParent
	WEnd
	
	Return $szPath
EndFunc


Func GetItemText($nCtrl, $hItem)
	Local $szText = "", $pszText, $tvItem
	
	$pszText = DllStructCreate("char[260]")

	$tvItem = TVITEM()
	   
	DllStructSetData($tvItem, 1, $TVIF_TEXT)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 5, DllStructGetPtr($pszText))
	DllStructSetData($tvItem, 6, 260)

	GUICtrlSendMsg($nTreeView, $TVM_GETITEM, 0, DllStructGetPtr($tvItem))
	$szText = DllStructGetData($pszText, 1)

	DllStructDelete($tvItem)
	DllStructDelete($pszText)
   
	Return $szText
EndFunc 


Func GetItemState($nCtrl, $hItem)
	Local $nState = 0, $tvItem
	
	$tvItem = TVITEM()
	   
	DllStructSetData($tvItem, 1, $TVIF_STATE)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 4, $TVIS_STATEIMAGEMASK)

	GUICtrlSendMsg($nTreeView, $TVM_GETITEM, 0, DllStructGetPtr($tvItem))
	$nState = DllStructGetData($tvItem, 3)

	DllStructDelete($tvItem)
   
	Return $nState
EndFunc


Func TVITEM()
	Return DllStructCreate("uint;int;uint;uint;ptr;int;int;int;int;int")
EndFunc


Func UpdateWindow($nCtrl)
	$hWnd = ControlGetHandle("", "", $nCtrl)
	$rect = DllStructCreate("int;int;int;int")
	DllCall("user32.dll", "int", "InvalidateRect", "hwnd", $hWnd, "int", 0, "int", 0)

EndFunc


Func SetItemChildren($hItem, $nFlag = 1)
	Local $tvItem
	
	$tvItem = TVITEM()
	   
	DllStructSetData($tvItem, 1, $TVIF_CHILDREN)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 9, $nFlag)

	GUICtrlSendMsg($nTreeView, $TVM_SETITEM, 0, DllStructGetPtr($tvItem))

	DllStructDelete ($tvItem)

EndFunc


Func FileGetIconCount($szFile)
	Dim $szFile, $nCount = 0

	$LPCTSTR = DllStructCreate("char[260]")
	DllStructSetData($LPCTSTR, 1, $szFile)
	$nCount = DllCall("shell32.dll", "int", "ExtractIconEx", "ptr", DllStructGetPtr($LPCTSTR), "int", -1, "int", 0, "int", 0, "int", 0)
	$nCount = $nCount[0]
	DllStructDelete($LPCTSTR)

	Return $nCount
EndFunc


Func DirToList($szPath)
	Dim $hSearch, $szFile, $szDate, $szType, $nItem
	
	If StringRight($szPath, 1) = "\" Then $szPath = StringTrimRight($szPath, 1)
	$hSearch = FileFindFirstFile($szPath & "\*.*")
	If $hSearch <> -1 Then
		$nItem = -1
		While 1
			$szFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			$nIcon = 0
			$szIconFile = $szPath & "\" & $szFile
			FileGetIcon($szIconFile, $nIcon, $szFile)
			$IsDir = StringInStr(FileGetAttrib($szPath & "\" & $szFile),"D")
			$szSize = ""
			If $IsDir Then
				$szType = $szDirType
			Else
				$szSize = Round(FileGetSize($szPath & "\" & $szFile) / 1000) & " KB"
				$szType = FileGetType($szFile)
			EndIf
			$arDate = FileGetTime($szPath & "\" & $szFile)
			If IsArray($arDate) Then $szDate = $arDate[2] & "." & $arDate[1] & "." & $arDate[0] & " " & $arDate[3] & ":" & $arDate[4]
			$nItem = GUICtrlCreateListViewItem($szFile & "|" & $szSize & "|" & $szType & "|" & $szDate, $nListView)
			If $IsDir Then
				GUICtrlSetImage(-1,$szIconFile, 3)
			Else
				GUICtrlSetImage(-1,$szIconFile,$nIcon)
			EndIf
			If $nFirstItem = 0 Then $nFirstItem = $nItem
		WEnd
		FileClose($hSearch)
		$nLastItem = $nItem
		If $nLastItem > 0 Then
			GUICtrlSetData($statusbarobj, $nLastItem - $nFirstItem & " Objects")
		Else
			GUICtrlSetData($statusbarobj, "Ready")
		EndIf
	EndIf
EndFunc


Func FileGetType($szFile)
	Dim $szFile, $szRegDefault = "", $szRegType = ""
	
	$szExt = StringRight($szFile,4)
	$szRegDefault = RegRead("HKCR\" & $szExt,"")
	If $szRegDefault <> "" Then $szRegType = RegRead("HKCR\" & $szRegDefault,"")
	If $szRegType = "" Then $szRegType = $szExt & "-File"
	
	Return $szRegType
EndFunc


Func FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile)
	Dim $szFile, $szRegDefault = "", $szDefIcon = ""
	
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
	
	$LVCOLUMN = DllStructCreate("uint;int;int;ptr;int;int;int;int")
	DllStructSetData($LVCOLUMN, 1, $LVCF_FMT)
	DllStructSetData($LVCOLUMN, 2, $nFormat)
	GUICtrlSendMsg($hListView, $LVM_SETCOLUMN, $nCol, DllStructGetPtr($LVCOLUMN))
	DllStructDelete($LVCOLUMN)
EndFunc


Func UpdateCtrl($hWnd, $nCtrl)
	$hCtrl = ControlGetHandle($hWnd, "", $nCtrl)
	
	$point	= DllStructCreate("int;int")
	$rect	= DllStructCreate("int;int;int;int")
	
	DllCall("user32.dll", "int", "GetWindowRect", "hwnd", $hCtrl, "ptr", DllStructGetPtr($rect))
	DllStructSetData($point, 1, DllStructGetData($rect, 1))
	DllStructSetData($point, 2, DllStructGetData($rect, 2))
	DllCall("user32.dll", "int", "ScreenToClient", "hwnd", $hCtrl, "ptr", DllStructGetPtr($point))
	DllStructSetData($rect, 1, DllStructGetData($point, 1))
	DllStructSetData($rect, 2, DllStructGetData($point, 2))
	
	DllStructSetData($point, 1, DllStructGetData($rect, 3))
	DllStructSetData($point, 2, DllStructGetData($rect, 4))
	DllCall("user32.dll", "int", "ScreenToClient", "hwnd", $hCtrl, "ptr", DllStructGetPtr($point))
	DllStructSetData($rect, 3, DllStructGetData($point, 1))
	DllStructSetData($rect, 4, DllStructGetData($point, 2))

	DllCall("user32.dll", "int", "InvalidateRect", "hwnd", $hWnd, "ptr", DllStructGetPtr($rect), "int", 1);

	DllStructDelete($point)
	DllStructDelete($rect)
EndFunc