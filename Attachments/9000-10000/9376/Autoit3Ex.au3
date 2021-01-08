;Autoit3Ex.au3  v 0_16
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
#include <file.au3>
#include <Array.au3>
#Include <GuiListView.au3>
#region declares
; TV functions
global $TotalRows=34, $nMsg,$down,$szPath,$current
Global Const $TV2M_INSERTITEM			= $TV_FIRST + 0
Global Const $TV2M_GETITEMRECT			= $TV_FIRST + 4
Global Const $TV2M_SETIMAGELIST			= $TV_FIRST + 9
Global Const $TV2M_SETITEM				= $TV_FIRST + 13
Global Const $TV2M_HITTEST				= $TV_FIRST + 17
Global Const $TV2I_FIRST					= 0xFFFF0001
; Masks
Global Const $TV2IF_IMAGE				= 0x0002
Global Const $TV2IF_HANDLE				= 0x0010
Global Const $TV2IF_SELECTEDIMAGE		= 0x0020
Global Const $TV2IF_CHILDREN				= 0x0040
; States
Global Const $TV2IS_CUT					= 0x0004
Global Const $TV2IS_DROPHILITED			= 0x0008
Global Const $TV2IS_BOLD					= 0x0010
Global Const $TV2IS_EXPANDED				= 0x0020
; Relationship/specific item
Global Const $TV2GN_ROOT					= 0x0000
Global Const $TV2GN_PREVIOUS				= 0x0002
Global Const $TV2GN_FIRSTVISIBLE			= 0x0005
Global Const $TV2GN_NEXTVISIBLE			= 0x0006
Global Const $TV2GN_PREVIOUSVISIBLE		= 0x0007
Global Const $TV2GN_DROPHILITE			= 0x0008
; Hittest infos
Global Const $TV2HT_NOWHERE				= 0x0001
Global Const $TV2HT_ONITEMICON			= 0x0002
Global Const $TV2HT_ONITEMLABEL			= 0x0004
Global Const $TV2HT_ONITEMINDENT			= 0x0008
Global Const $TV2HT_ONITEMBUTTON			= 0x0010
Global Const $TV2HT_ONITEMRIGHT			= 0x0020
Global Const $TV2HT_ONITEMSTATEICON		= 0x0040
Global Const $TV2HT_ONITEM				= BitOr($TV2HT_ONITEMICON, $TV2HT_ONITEMLABEL, $TV2HT_ONITEMSTATEICON)
Global Const $TV2HT_ABOVE				= 0x0100
Global Const $TV2HT_BELOW				= 0x0200
Global Const $TV2HT_TORIGHT				= 0x0400
Global Const $TV2HT_TOLEFT				= 0x0800
;If Not IsDeclared("LVM_SETEXTENDEDLISTVIEWSTYLE")	Then Global Const $LVM_SETEXTENDEDLISTVIEWSTYLE	= 0x1036
If Not IsDeclared("LVM_SETCOLUMN")					Then Global Const $LVM_SETCOLUMN				= 0x101A
;If Not IsDeclared("LVCF_FMT")						Then Global Const $LVCF_FMT						= 0x0001
;If Not IsDeclared("LVCFMT_RIGHT")					Then Global Const $LVCFMT_RIGHT					= 0x0001
;If Not IsDeclared("LVM_GETHEADER")					Then Global Const $LVM_GETHEADER				= 0x101F
Global $nCtrls = 0
Global $hCurItem = 0
Global $hImageList = 0
Global $szDirType = RegRead("HKCR\Directory", "")
If $szDirType = "" Then $szDirType = "Directory"
;$indexingGUI = GUICreate("Sorry.. Finding Folder structure!", 300, 50, (@DesktopWidth - 300) / 2, (@DesktopHeight - 50) / 2)
;$indexingLabel=GUICtrlCreateLabel("Sorry..Only time you'll have to wait!  Please Wait...", 30, 1, 250, 25)
;$indexstatuslabel = GUICtrlCreateLabel("", 20, 25, 280, 20)
;GUISetState()
$hGui = GUICreate("AutoIt3-Explorer V1.1a ;-)", 762, 578, -1, -1, BitOr($WS_SIZEBOX, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
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
$nAddressbar	= GUICtrlCreateCombo("C:\", 50, 3, 300, 20)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Tab1combo1 = GUICtrlCreateCombo("# Rows", 400, 3, 50, 30);, $CBS_SIMPLE)
GUICtrlSetData(-1, "10|20|34|50|100|150|300|500|1000|1200|1500|2000|3000|4000", "34")     ;Set default 10
GUICtrlCreateLabel("Rows",360, 3)
$TopButton = GuiCtrlCreateButton("|<", 460, 3 ,30, 20)
GUICtrlSetTip($TopButton,"$TopButton")
$UpButton = GuiCtrlCreateButton("<", 500, 3, 30, 20)
GUICtrlSetTip($UpButton,"$UpButton")
GUICtrlCreateLabel("Pg Up", 580, 6,35,15)
$updown = GUICtrlCreateInput("0", 540, 3, 35, 20)
$UpOneScreen = GUICtrlCreateUpdown($updown)
GUICtrlSetTip($UpOneScreen, "$UpOneScreen")
$DownButton = GuiCtrlCreateButton(">", 620, 3, 30, 20)
GUICtrlSetTip($DownButton,"$DownButton")
$Bottom = GuiCtrlCreateButton(">|", 660, 3, 30, 20)
GUICtrlSetTip($Bottom,"$Bottom")
;GUICtrlCreateLabel("Dn", 680, 3)
;$down = GUICtrlCreateInput("0", 580, 3, 35, 20)
;$down = GUICtrlCreateInput("0", 540, 540, 150, 18)
;$DownOneScreen = GUICtrlCreateUpdown($down)
;GUICtrlSetTip($DownOneScreen, "$DownOneScreen")
$Value = GUICtrlCreateCombo("0", 700, 3, 55, 20);, $CBS_SIMPLE)
GUICtrlCreateLabel("Num row",  780, 3)
GUICtrlSetTip($Value, "Show Control cursor, hold cursor for sample label")
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
$nListView		= GUICtrlCreateListView("Name|Size|Type|Changed|No.",314, 25, 447, 513)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlListViewSetColumnFormat($nListView, 1, $LVCFMT_RIGHT)
GUICtrlListViewSetColumnFormat($nListView, 4, $LVCFMT_RIGHT)
GUICtrlSetImage(-1, "shell32.dll", 0)
$statusbarobj	= GUICtrlCreateLabel(" Object(s)",0, 540, 150, 18, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
$statusbarsize	= GUICtrlCreateLabel(" MB (Free Space: 0 MB)", 152, 540, 610, 18, $SS_SUNKEN)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
;$down = GUICtrlCreateInput("0", 540, 540, 35, 20)
$down = GUICtrlCreateLabel("0", 540, 544,35,13)
$DownOneScreen = GUICtrlCreateUpdown($down)
GUICtrlSetTip($DownOneScreen, "$DownOneScreen")
GUICtrlCreateLabel("Pg Dn", 580, 544,45,13)
$nSplitter		= GUICtrlCreateLabel("", 310, 29, 4, 509)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
GUICtrlSetCursor(-1, 13)
GUICtrlSetData($Tab1combo1,$TotalRows)
GUISetState(@SW_SHOW, $hGui)
FillTreeRoot($arDrives)
_GUICtrlListViewSetColumnWidth ($nListView, 0, 180)                 ;Set Column with
_GUICtrlListViewSetColumnWidth ($nListView, 4, 20)                 ;Set Column with
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
#endregion declares
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
		If BitAnd($nFlag, $TV2HT_ONITEMBUTTON) Or BitAnd($nFlag, $TV2HT_ONITEM) Then
			GUISetState(@SW_LOCK)
			CheckTreeFill($nTreeView, $hItem)
			GUISetState(@SW_UNLOCK)
			GUICtrlSetData($nAddressbar, GetTreePath($nTreeView, $hItem, "\"))
		EndIf
		$hItem = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
		$szCurrentPath = GetTreePath($nTreeView, $hItem, "\")
		If BitAnd($nFlag, $TV2HT_ONITEM) Then GUICtrlSetData($nAddressbar, $szCurrentPath)
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
				Case $GUI_EVENT_PRIMARYDOWN
							$pos = GUIGetCursorInfo()
							If ($pos[4] == $nListView) Then
								If ($current <> _GUICtrlListViewGetHotItem ($nListView) And _GUICtrlListViewGetHotItem ($nListView) >= 0) Then
									;msgbox("", "Hot Item:" , _GUICtrlListViewGetHotItem ($searchlistView))
									$current = _GUICtrlListViewGetHotItem ($nListView)
									;msgbox(0,"",_GUICtrlListViewGetItemText($searchlistView, $current, 1))
								ElseIf ($current = _GUICtrlListViewGetHotItem ($nListView) And _GUICtrlListViewGetHotItem ($nListView) >= 0) Then
									$s_NewPath=GUICtrlRead($nAddressbar)&_GUICtrlListViewGetItemText ($nListView, $current, 0)
									if not StringInStr($s_NewPath, ".") then $s_NewPath&="\"
									Run("explorer.exe /select, " & $s_NewPath , "", @SW_MAXIMIZE)
								ElseIf (_GUICtrlListViewGetHotItem ($nListView == -1)) Then
									;msgbox("", "Hot Item:" , "None")
								EndIf
							EndIf
		Case $GUI_EVENT_CLOSE, $nExitItem
			ExitLoop
		Case $nAboutItem
			Msgbox(64,"About","Demo by Holger; modified display by Randallc")
		Case $nSplitter
			$cinfo = GUIGetCursorInfo()
			If $cinfo[2] = 1 Then $pressed = 1
		Case $nViewItem1 To $nViewItem4
			GUICtrlSetStyle($nListView, BitOr($LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $nMsg - $nViewItem1))
		Case $updown
			;MsgBox(0,"","$updown="&$nMsg)
			$i_UpRead=Number(GUICtrlRead($updown))
			$i_OldUpRead=-Number(GUICtrlRead($down))
			$nMsg = $updown
			Re_List($szPath)
		Case  $UpButton
			;MsgBox(0,"","$UpButton="&$nMsg)
			GUICtrlSetData($updown,Number(GUICtrlRead($updown))+1)
			$i_UpRead=Number(GUICtrlRead($updown))
			$i_OldUpRead=-Number(GUICtrlRead($down))
			$nMsg = $updown
			Re_List($szPath)
		Case $TopButton
			;MsgBox(0,"","$TopButton="&$nMsg)
			GUICtrlSetData($updown,0)
			GUICtrlSetData($down,0)
			GUICtrlSetData($Value,0)
			$i_UpRead=Number(GUICtrlRead($updown))
			$i_OldUpRead=-Number(GUICtrlRead($down))
			$nMsg = $updown
			Re_List($szPath)
			GUICtrlSetData($down,0)
			GUICtrlSetData($Updown,0)
		Case $down
		;	MsgBox(0,"","$down="&$nMsg)
			$i_DownRead=Number(GUICtrlRead($down))
			$i_OldDownRead=-Number(GUICtrlRead($updown))
			if $nMsg<> $Bottom then GUICtrlSetData($down,_iif($i_DownRead<$i_OldDownRead,$i_DownRead+2,$i_DownRead-2))
			$nMsg = $down
			Re_List($szPath)
		Case  $DownButton
			;MsgBox(0,"","$DownButton="&$nMsg)
			GUICtrlSetData($down,Number(GUICtrlRead($down))-1)
			GUICtrlSetData($updown,Number(GUICtrlRead($updown))-1)
			$i_DownRead=Number(GUICtrlRead($down))
			$i_OldDownRead=-Number(GUICtrlRead($updown))
			if $nMsg<> $Bottom then GUICtrlSetData($down,_iif($i_DownRead<$i_OldDownRead,$i_DownRead+2,$i_DownRead-2))
			$nMsg = $down
			Re_List($szPath)
		Case $Bottom
			;MsgBox(0,"","$Bottom="&$nMsg)
			GUICtrlSetData($down,0)
			GUICtrlSetData($Updown,0)
			GUICtrlSetData($Value,$TotalRows)
			$i_DownRead=Number(GUICtrlRead($down))
			$i_OldDownRead=-Number(GUICtrlRead($updown))
			if $nMsg<> $Bottom then GUICtrlSetData($down,_iif($i_DownRead<$i_OldDownRead,$i_DownRead+2,$i_DownRead-2))
			$nMsg = $down
			Re_List($szPath)
			GUICtrlSetData($down,0)
			GUICtrlSetData($Updown,0)
		Case  $Tab1combo1   ,$Value , $updown , $down
			;MsgBox(0,"","many="&$nMsg)
			;MsgBox(0,"","$Value="&$nMsg)
			;MsgBox(0,"","$Tab1combo1="&$nMsg)
			;MsgBox(0,"","$down="&$nMsg)
			;MsgBox(0,"","$updown="&$nMsg)
			Re_List($szPath)
	EndSwitch
WEnd
Func CheckTreeFill($nCtrl, $hItem)
	If $hItem > 0 Then
		$hChild = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem)
		If $hChild > 0 Then
			$szText = GetItemText($nTreeView, $hChild)
			If $szText == "" Then
				$szPath = GetTreePath($nTreeView, $hItem, "\")
				If StringRight($szPath, 1) == "\" Then $szPath = StringTrimRight($szPath, 1)
				GUICtrlSetCursor($nTreeView, 1)
				FillTree($szPath, $hItem, $hChild)
				GUICtrlSetCursor($nTreeView, 2)
			EndIF
		EndIf
	EndIf
EndFunc   ;==>CheckTreeFill
Func FillTreeRoot($arDrives)
	Local $hSearch, $szFile, $nChildren, $szDriveLabel
	$hParent = 0
	For $i = 1 To $arDrives[0]
		$nChildren = 0
		;MsgBox(0,"",$arDrives[$i])
		$s_Directories=@ScriptDir&"\Dir_"&StringLower(StringLeft($arDrives[$i],1))&".txt"
		;FileDelete($s_Directories)
		filemove(@ScriptDir&"\Dir_*.*",@ScriptDir&"\backup\",9)
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
	$hItem = GUICtrlSendMsg($nTreeView, $TVM_GETNEXTITEM, $TV2GN_ROOT, 0)
	GUICtrlSendMsg($nTreeView, $TVM_SELECTITEM, $TVGN_CARET, $hItem)
EndFunc   ;==>FillTreeRoot
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
EndFunc   ;==>GetSubFolder
Func FillTree($szPath, $hParent = 0, $hDelete = 0)
	Local $hSearch, $szFile, $nChildren,$s_DirExist,$s_Directories
	If $hDelete > 0 Then
		GUICtrlSendMsg($nTreeView, $TVM_DELETEITEM, 0, $hDelete)
		SetItemChildren($hParent)
	EndIf
	local $s_AnswerFile=@ScriptDir & '\au3.txt',$s_AnswerFile2=@ScriptDir & '\au32.txt'
	$s_Switches1=" /ad  /b "
	$s_Switches2=" /ad  /b/s "
	$szPath=FileGetShortName($szPath)
	If (StringRight($szPath, 1) == "\") Then $szPath = StringTrimRight($szPath, 1)
	if not (StringRight($szPath, 1) == ":") Then
		;$nPos = StringInStr($szPath, "\", 0, 2)
		;$szPathBase=StringLeft($szPath,$nPos-1)
		;if  (StringRight($szPathBase, 1) == ":") or $nPos=0 Then $szPathBase=$szPath
		$szPathBase=$szPath
		$szPathBaseName=StringReplace(StringReplace(StringLower($szPathBase),":","_"),"\","_")
		$s_Directories=@ScriptDir&"\Dir_"&$szPathBaseName&".txt"
		if not FileExists($s_Directories) then
			$s_DirExist=0
		Else
			$s_DirExist=1
		EndIf
	EndIf
	$s_Command=	' dir ' & $szPath & '\* '&$s_Switches1 & '   > "' &  $s_AnswerFile&'"'
	;if not $s_DirExist=1 then $s_Command&=	' |dir ' & $szPath & '\* '&$s_Switches2 & '   > "' &  $s_Directories&'"'
	RunWait(@ComSpec & ' /c ' & $s_Command, '', @SW_HIDE)
	if not StringRight($szPath, 1) = ":" Then
		;MsgBox(0,"","StringRight($szPath, 1)="&StringRight($szPath, 1))
		;MsgBox(0,"","so $s_Directories="&$s_Directories)
		$s_DirString=FileRead($s_Directories,FileGetSize($s_Directories))
		$s_DirExist=1
	EndIf
	$hSearch = FileOpen($s_AnswerFile,0)
	While 1
		$szFile=FileReadLine($hSearch)
		If @error = -1 Then ExitLoop
		$nChildren = 0
		if not StringRight($szPath, 1) = ":" and $s_DirExist=1 Then
			;MsgBox(0,"","StringRight($szPath, 1)="&StringRight($szPath, 1))
			;MsgBox(0,"","so $s_Directories="&$s_Directories)
			if StringInStr($s_DirString,StringReplace(StringReplace($szPath & "\" & $szFile,"\","_"),":","_")) Then $nChildren = 1
		Else
			If GetSubFolder($szPath & "\" & $szFile) Then $nChildren = 1
		EndIf
		$hItem = InsertItem($szFile, $hParent, $hCurItem, $nChildren)
		If $nChildren = 1 Then InsertDummyItem($nTreeView, $hItem)
		$nCtrls = $nCtrls + 1
	WEnd
	FileClose($hSearch)
EndFunc   ;==>FillTree
Func FillTreeOld($szPath, $hParent = 0, $hDelete = 0)
	Local $hSearch, $szFile, $nChildren,$s_DirExist,$s_Directories
	If $hDelete > 0 Then
		GUICtrlSendMsg($nTreeView, $TVM_DELETEITEM, 0, $hDelete)
		SetItemChildren($hParent)
	EndIf
	local $s_AnswerFile=@ScriptDir & '\au3.txt',$s_AnswerFile2=@ScriptDir & '\au32.txt'
	$s_Switches1=" /ad  /b "
	$s_Switches2=" /ad  /b/s "
	$szPath=FileGetShortName($szPath)
	If (StringRight($szPath, 1) == "\") Then $szPath = StringTrimRight($szPath, 1)
	if not (StringRight($szPath, 1) == ":") Then
		$nPos = StringInStr($szPath, "\", 0, 2)
		$szPathBase=StringLeft($szPath,$nPos-1)
		if  (StringRight($szPathBase, 1) == ":") or $nPos=0 Then $szPathBase=$szPath
		$szPathBaseName=StringReplace(StringReplace(StringLower($szPathBase),":","_"),"\","_")
		$s_Directories=@ScriptDir&"\Dir_"&$szPathBaseName&".txt"
		if not FileExists($s_Directories) then
			$s_DirExist=0
		Else
			$s_DirExist=1
		EndIf
	EndIf
	$s_Command=	' dir ' & $szPath & '\* '&$s_Switches1 & '   > "' &  $s_AnswerFile&'"'
	if not $s_DirExist=1 then $s_Command&=	' |dir ' & $szPath & '\* '&$s_Switches2 & '   > "' &  $s_Directories&'"'
	RunWait(@ComSpec & ' /c ' & $s_Command, '', @SW_HIDE)
	if not StringRight($szPath, 1) = ":" Then
		;MsgBox(0,"","StringRight($szPath, 1)="&StringRight($szPath, 1))
		;MsgBox(0,"","so $s_Directories="&$s_Directories)
		$s_DirString=FileRead($s_Directories,FileGetSize($s_Directories))
		$s_DirExist=1
	EndIf
	$hSearch = FileOpen($s_AnswerFile,0)
	While 1
		$szFile=FileReadLine($hSearch)
		If @error = -1 Then ExitLoop
		$nChildren = 0
		if not StringRight($szPath, 1) = ":" and $s_DirExist=1 Then
			;MsgBox(0,"","StringRight($szPath, 1)="&StringRight($szPath, 1))
			;MsgBox(0,"","so $s_Directories="&$s_Directories)
			if StringInStr($s_DirString,StringReplace(StringReplace($szPath & "\" & $szFile,"\","_"),":","_")) Then $nChildren = 1
		Else
			If GetSubFolder($szPath & "\" & $szFile) Then $nChildren = 1
		EndIf
		$hItem = InsertItem($szFile, $hParent, $hCurItem, $nChildren)
		If $nChildren = 1 Then InsertDummyItem($nTreeView, $hItem)
		$nCtrls = $nCtrls + 1
	WEnd
	FileClose($hSearch)
EndFunc   ;==>FillTree
Func InsertItem($szText, $hParent, $hInsertAfter, $nChildren, $iImage = 0, $iSelectedImage = 1)
	$pszText = DllStructCreate("char[260]")
	DllStructSetData($pszText, 1, $szText)
	$tvItem = TVITEM()
	$tvInsertStruct = DllStructCreate("int;int;int[10]")
	If $hCurItem = 0 Then
		$hInsertAfter = $TV2I_FIRST
	Else
		$hInsertAfter = $hCurItem
	EndIf
	DllStructSetData($tvInsertStruct, 1, $hParent)
	DllStructSetData($tvInsertStruct, 2, $hInsertAfter)
	DllStructSetData($tvInsertStruct, 3, $tvItem)
	$hItem = GUICtrlSendMsg($nTreeView, $TV2M_INSERTITEM, 0, DllStructGetPtr($tvInsertStruct))
	If $hItem > 0 Then
		$hCurItem = $hItem
		DllStructSetData($tvItem, 1, BitOr($TVIF_TEXT, $TV2IF_IMAGE, $TV2IF_SELECTEDIMAGE))
		DllStructSetData($tvItem, 2, $hItem)
		DllStructSetData($tvItem, 5, DllStructGetPtr($pszText))
		DllStructSetData($tvItem, 7, $iImage)
		DllStructSetData($tvItem, 8, $iSelectedImage)
		GUICtrlSendMsg($nTreeView, $TV2M_SETITEM, 0, DllStructGetPtr($tvItem))
	EndIf
	;;DllStructDelete($tvInsertStruct)
	;;DllStructDelete($tvItem)
	;;DllStructDelete($pszText)
	Return $hItem
EndFunc   ;==>InsertItem
Func InsertDummyItem($nCtrl, $hItem)
	InsertItem("", $hItem, $hCurItem, 0)
EndFunc   ;==>InsertDummyItem
Func TV_Hittest($nCtrl, ByRef $nFlag )
	$hItem	= 0
	$point = DllStructCreate("int;int")
	DllCall("user32.dll", "int", "GetCursorPos", "ptr", DllStructGetPtr($point))
	$hWnd = ControlGetHandle("", "", $nCtrl)
	DllCall("user32.dll", "int", "ScreenToClient", "hwnd", $hWnd, "ptr", DllStructGetPtr($point))
	$tvHit = DllStructCreate("int[2];uint;int")
	DllStructSetData($tvHit, 1, DllStructGetData($point, 1), 1)
	DllStructSetData($tvHit, 1, DllStructGetData($point, 2), 2)
	If GUICtrlSendMsg($nCtrl, $TV2M_HITTEST, 0, DllStructGetPtr($tvHit)) Then
		$nFlag = DllStructGetData($tvHit, 2)
		$hItem = DllStructGetData($tvHit, 3)
	EndIf
	;DllStructDelete($tvHit)
	;DllStructDelete($point)
	Return $hItem
EndFunc   ;==>TV_Hittest
Func ItemHasChildren($nCtrl, $hItem)
	$nChildren = 0
	If GUICtrlSendMsg($nCtrl, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem) > 0 Then $nChildren = 1
	Return $nChildren
EndFunc   ;==>ItemHasChildren
Func ExpandTree($nCtrl, $hItem)
	$result = GUICtrlSendMsg($nCtrl, $TVM_EXPAND, 0x0002, $hItem)
EndFunc   ;==>ExpandTree
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
EndFunc   ;==>GetTreePath
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
	;DllStructDelete($tvItem)
	;DllStructDelete($pszText)
	Return $szText
EndFunc   ;==>GetItemText
Func GetItemState($nCtrl, $hItem)
	Local $nState = 0, $tvItem
	$tvItem = TVITEM()
	DllStructSetData($tvItem, 1, $TVIF_STATE)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 4, $TVIS_STATEIMAGEMASK)
	GUICtrlSendMsg($nTreeView, $TVM_GETITEM, 0, DllStructGetPtr($tvItem))
	$nState = DllStructGetData($tvItem, 3)
	;DllStructDelete($tvItem)
	Return $nState
EndFunc   ;==>GetItemState
Func TVITEM()
	Return DllStructCreate("uint;int;uint;uint;ptr;int;int;int;int;int")
EndFunc   ;==>TVITEM
Func UpdateWindow($nCtrl)
	$hWnd = ControlGetHandle("", "", $nCtrl)
	$rect = DllStructCreate("int;int;int;int")
	DllCall("user32.dll", "int", "InvalidateRect", "hwnd", $hWnd, "int", 0, "int", 0)
EndFunc   ;==>UpdateWindow
Func SetItemChildren($hItem, $nFlag = 1)
	Local $tvItem
	$tvItem = TVITEM()
	DllStructSetData($tvItem, 1, $TV2IF_CHILDREN)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 9, $nFlag)
	GUICtrlSendMsg($nTreeView, $TV2M_SETITEM, 0, DllStructGetPtr($tvItem))
	;DllStructDelete ($tvItem)
EndFunc   ;==>SetItemChildren
Func FileGetIconCount($szFile)
	Dim $nCount = 0;
	;redim $szFile
	$LPCTSTR = DllStructCreate("char[260]")
	DllStructSetData($LPCTSTR, 1, $szFile)
	$nCount = DllCall("shell32.dll", "int", "ExtractIconEx", "ptr", DllStructGetPtr($LPCTSTR), "int", -1, "int", 0, "int", 0, "int", 0)
	$nCount = $nCount[0]
	;DllStructDelete($LPCTSTR)
	Return $nCount
EndFunc   ;==>FileGetIconCount
Func FileGetType($szFile)
	Dim  $szRegDefault = "", $szRegType = ""
	;redim $szFile
	$szExt = StringRight($szFile,4)
	$szRegDefault = RegRead("HKCR\" & $szExt,"")
	If $szRegDefault <> "" Then $szRegType = RegRead("HKCR\" & $szRegDefault,"")
	If $szRegType = "" Then $szRegType = $szExt & "-File"
	Return $szRegType
EndFunc   ;==>FileGetType
Func FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile)
	Dim  $szRegDefault = "", $szDefIcon = ""
	;redim $szFile
	;$nIcon = 0
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
EndFunc   ;==>FileGetIcon
Func GUICtrlListViewSetColumnFormat($hListView, $nCol, $nFormat)
	$hListViewHeader = GUICtrlSendMsg($hListView, $LVM_GETHEADER, 0, 0)
	$LVCOLUMN = DllStructCreate("uint;int;int;ptr;int;int;int;int")
	DllStructSetData($LVCOLUMN, 1, $LVCF_FMT)
	DllStructSetData($LVCOLUMN, 2, $nFormat)
	GUICtrlSendMsg($hListView, $LVM_SETCOLUMN, $nCol, DllStructGetPtr($LVCOLUMN))
	;;DllStructDelete($LVCOLUMN)
EndFunc   ;==>GUICtrlListViewSetColumnFormat
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
	;DllStructDelete($point)
	;DllStructDelete($rect)
EndFunc   ;==>UpdateCtrl
Func DirToList($szPath)
	$s_MsgValue=GUICtrlRead($Value)
	local $s_AnswerFile=@ScriptDir & '\au3.txt',$s_AnswerFile2=@ScriptDir & '\au32.txt'
	$s_Switches1=" /ad  /b "
	$s_Switches2=" /a-d  /b "
	$szPath=FileGetShortName($szPath)
	If StringRight($szPath, 1) = "\" Then $szPath = StringTrimRight($szPath, 1)
	$s_Command=	' dir ' & $szPath & '\* '&$s_Switches1 & '   > "' &  $s_AnswerFile&'"'& _
			'|dir ' & $szPath & '\* '&$s_Switches2 & '   > "' &  $s_AnswerFile2	&'"'
	RunWait(@ComSpec & ' /c ' & $s_Command, '', @SW_HIDE)
	$s_StringAns=FileRead($s_AnswerFile,FileGetSize($s_AnswerFile))&FileRead($s_AnswerFile2,FileGetSize($s_AnswerFile2))
	$file = FileOpen($s_AnswerFile, 2)
	FileWrite($file,$s_StringAns)
	FileClose($file)
	$sTXTLOGFile2="Table.txt"
	Dim $hSearch, $szFile, $szDate, $szType, $nItem
	If StringRight($szPath, 1) = "\" Then $szPath = StringTrimRight($szPath, 1)
	$hSearch = FileOpen($s_AnswerFile,0)
	$nItem = -1
	$i_numItems=0
	;====================================================CountRows
	$TotalRows=_FileCountLines( $s_AnswerFile )
	$s_IntervalString=""
	$i_IntervalCombo=$TotalRows/20
	for $i=0 to 20
		$s_IntervalString&="|"&int($i*$i_IntervalCombo)
	Next
	;GUICtrlSetData($Value, $s_IntervalString, $TotalRows-(GUICtrlRead($Value))-1)
	;====================================================Rows
	;if $nMsg <> $Value and $nMsg <> $updown  and $nMsg <> $down and $nMsg <>  $Tab1combo1   then GUICtrlSetData($Value, $s_IntervalString, $TotalRows-(GUICtrlRead($Value))-1)
	if $nMsg <> $Value and $nMsg <> $updown   and $nMsg <>  $Tab1combo1  and $nmsg<> $down then GUICtrlSetData($Value, $s_IntervalString, GUICtrlRead($Value)-1)
	if $nMsg =$Value  then
		GUICtrlSetData($down,0)
		GUICtrlSetData($updown,0)
	EndIf
	if $nMsg = $updown then GUICtrlSetData($down,-GUICtrlRead($updown))
	if $nMsg = $down then GUICtrlSetData($updown,-GUICtrlRead($down) )
	$i_FromUpDownT=int(number(GUICtrlRead($updown))*number(GUICtrlRead($Tab1combo1)))
	$i_FromDownT=int(number(GUICtrlRead($down))*number(GUICtrlRead($Tab1combo1)))
	$i_NewStart=number(GUICtrlRead($Value))-_iif(number(GUICtrlRead($Value))=0,0,1)-$i_FromUpDownT
	if $TotalRows-$i_NewStart<number(GUICtrlRead($Tab1combo1)) then $i_NewStart=$TotalRows-number(GUICtrlRead($Tab1combo1))
	;====================================================Cols
	$i_TotalNumRowsToShow=GUICtrlRead($Tab1combo1)
	$i_FirstItem=$i_NewStart
	$i_ItemsNumber=$i_NewStart
	_LockAndWait2()
	While $i_numItems<$i_TotalNumRowsToShow+1
		$i_numItems+=1
		$szFile=FileReadLine($hSearch)
		If @error = -1 Then ExitLoop
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
		$arDate = FileGetTime($szPath &"\" & $szFile)
		If IsArray($arDate) Then $szDate = $arDate[2] & "." & $arDate[1] & "." & $arDate[0] & " " & $arDate[3] & ":" & $arDate[4]
		$nItem = GUICtrlCreateListViewItem($szFile & "|" & $szSize & "|" & $szType & "|" & $szDate& "|" & $i_numItems, $nListView)
		If $IsDir Then
			GUICtrlSetImage(-1,$szIconFile, 3)
		Else
			GUICtrlSetImage(-1,$szIconFile,$nIcon)
		EndIf
		If $nFirstItem = 0 Then $nFirstItem = $nItem
	WEnd
	_ResetLockWait2()
	$nLastItem = $nItem
	If $nLastItem > 0 Then
		GUICtrlSetData($statusbarobj, $nLastItem - $nFirstItem & " Objects")
	Else
		GUICtrlSetData($statusbarobj, "Ready")
	EndIf
	FileClose($hSearch)
	$s_MsgValue=GUICtrlRead($Value)
	;MsgBox(0,"","$s_MsgValue="&$s_MsgValue)
	GUICtrlSetData($Value, 0)
EndFunc   ;==>DirToList
Func Re_List($szPath)
	local $s_AnswerFile=@ScriptDir & '\au3.txt'
	Dim $hSearch, $szFile, $szDate, $szType, $nItem
	If StringRight($szPath, 1) == "\" Then $szPath = StringTrimRight($szPath, 1)
	$hSearch = FileOpen($s_AnswerFile,0)
	$nItem = -1
	$i_numItems=0
	;====================================================CountRows
	$TotalRows=_FileCountLines( $s_AnswerFile )
	$s_IntervalString=""
	$i_IntervalCombo=$TotalRows/20
	for $i=0 to 20
		$s_IntervalString&="|"&int($i*$i_IntervalCombo)
	Next
	;====================================================Rows
	if $nMsg <> $Value and $nMsg <> $updown  and $nMsg <>  $Tab1combo1  and $nMsg <> $down then GUICtrlSetData($Value, $s_IntervalString, $TotalRows-(GUICtrlRead($Value))-1)
	if $nMsg =$Value  then
		GUICtrlSetData($down,0)
		GUICtrlSetData($updown,0)
	EndIf
	if $nMsg = $updown then GUICtrlSetData($down,-GUICtrlRead($updown))
	if $nMsg = $down then GUICtrlSetData($updown,GUICtrlRead($updown)-1 )
	$i_FromUpDownT=int(number(GUICtrlRead($updown))*number(GUICtrlRead($Tab1combo1)))
	$i_FromDownT=int(number(GUICtrlRead($down))*number(GUICtrlRead($Tab1combo1)))
	$i_NewStart=number(GUICtrlRead($Value))-_iif(number(GUICtrlRead($Value))=0,0,1)-$i_FromUpDownT
	if ($TotalRows-$i_NewStart)<number(GUICtrlRead($Tab1combo1)) then $i_NewStart=$TotalRows-number(GUICtrlRead($Tab1combo1))
	if $i_NewStart<0 then $i_NewStart=0
	;====================================================Cols
	$i_TotalNumRowsToShow=GUICtrlRead($Tab1combo1)
	$i_FirstItem=$i_NewStart
	$i_ItemsNumber=$i_NewStart
	_LockAndWait2()
	_GUICtrlListViewDeleteAllItems ($nListView)
	While $i_numItems<$i_TotalNumRowsToShow+1
		$i_numItems+=1
		$i_ItemsNumber+=1
		$szFile=FileReadLine($hSearch,$i_ItemsNumber)
		If @error = -1 Then ExitLoop
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
		$arDate = FileGetTime($szPath &"\" & $szFile)
		If IsArray($arDate) Then $szDate = $arDate[2] & "." & $arDate[1] & "." & $arDate[0] & " " & $arDate[3] & ":" & $arDate[4]
		$nItem = GUICtrlCreateListViewItem($szFile & "|" & $szSize & "|" & $szType & "|" & $szDate& "|" &$i_ItemsNumber , $nListView)
		If $IsDir Then
			GUICtrlSetImage(-1,$szIconFile, 3)
		Else
			GUICtrlSetImage(-1,$szIconFile,$nIcon)
		EndIf
		If $nFirstItem = 0 Then $nFirstItem = $nItem
	WEnd
	_ResetLockWait2()
	$nLastItem = $nItem
	If $nLastItem > 0 Then
		GUICtrlSetData($statusbarobj, $nLastItem - $nFirstItem & " Objects")
	Else
		GUICtrlSetData($statusbarobj, "Ready")
	EndIf
	FileClose($hSearch)
	;MsgBox(0,"","Done once at least!")
EndFunc   ;==>Re_List
Func _LockAndWait2()
	Local $Cursor_WAIT
	GUISetState(@SW_LOCK)
	GUISetCursor($Cursor_WAIT, 1)
EndFunc   ;==>_LockAndWait2
Func _ResetLockWait2()
	Local $Cursor_ARROW
	GUISetState(@SW_UNLOCK)
	GUISetCursor($Cursor_ARROW, 1)
EndFunc   ;==>_ResetLockWait2
