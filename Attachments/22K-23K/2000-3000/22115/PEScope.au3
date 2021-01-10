#cs
	TITLE: PE-Scope - Portable Executable Information Analyzer
	AUTHOR: Crash Daemonicus
	VERSION: 1.2
	(Upgraded Replacement for my "Application Headers" example)
	INFORMATION:
	Retrieves Information on Windows PE (Windows NT) Applications
	CREDIT:
	Iczelion's PE Tutorials
	http://win32assembly.online.fr/pe-tut1.html
	...
	http://win32assembly.online.fr/pe-tut7.html
	Numerous MSDN documents.
#ce
;GUI Constants
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ListViewConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
;GUI Functions
#include <GuiTreeView.au3>
#include <GuiListView.au3>
;Required Data Functions
#include <String.au3>
;PEApp Info
#include <PEAppConstants.au3>
#include <PEAppLib.au3>


Global $ExeDos,$ExeNT,$ExeFile,$ExeOpti,$ExeData,$ExeImpt,$ExeExpt
Global $ExeSect,$exe_path,$SectItems,$ExeDataItems,$ExeImptItems,$ExeExptItem
Global $ImptMax=0
Global $SectMax=0



Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Ken\Desktop\projects\~unfinished\PEAppAn\form.kxf
$Title = 'PE-Scope - '
$Form1 = GUICreate($Title, 942, 286 + 43, 43, 295, $WS_CAPTION + $WS_SYSMENU + $WS_MINIMIZEBOX)
$Form1h = WinGetHandle($Form1)
GUISetOnEvent(-3, 'Ext')
$TreeView1 = GUICtrlCreateTreeView(0, 4, 201, 280, -1, $WS_EX_CLIENTEDGE)
$ListView1 = GUICtrlCreateListView("", 204, 4, 737, 280, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_SORTASCENDING, $LVS_AUTOARRANGE))
$Label1 = GUICtrlCreateLabel('Ready.', 0, 3 + 282, 942, 20)

$Xoff = 204
$Yoff = 4
Global $infc[11]
$infc[00] = GUICtrlCreateLabel("File Size", $Xoff, $Yoff, 122, 21, -1, $WS_EX_CLIENTEDGE)
$infc[01] = GUICtrlCreateLabel("File Creation Time", $Xoff, $Yoff + 22, 122, 21, -1, $WS_EX_CLIENTEDGE)
$infc[02] = GUICtrlCreateLabel("File Modification Time", $Xoff, $Yoff + 44, 122, 21, -1, $WS_EX_CLIENTEDGE)
$infc[03] = GUICtrlCreateLabel("File Access Time", $Xoff, $Yoff + 66, 122, 21, -1, $WS_EX_CLIENTEDGE)
$infc[04] = GUICtrlCreateLabel("File Attributes", $Xoff, $Yoff + 88, 122, 21, -1, $WS_EX_CLIENTEDGE)
$infc[09] = GUICtrlCreateInput("Input1", $Xoff + 123, $Yoff + 0, 121, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY));filesize
$infc[05] = GUICtrlCreateInput("Input1", $Xoff + 123, $Yoff + 22, 121, 21);create
$infc[06] = GUICtrlCreateInput("Input1", $Xoff + 123, $Yoff + 44, 121, 21);modify
$infc[07] = GUICtrlCreateInput("Input1", $Xoff + 123, $Yoff + 66, 121, 21);access
$infc[08] = GUICtrlCreateInput("Input1", $Xoff + 123, $Yoff + 88, 121, 21);attrib
$infc[10] = GUICtrlCreateButton("Set Information", $Xoff, $Yoff + 110, 243, 21)
GUICtrlSetOnEvent($infc[10], '_infoset')


$mFile = GUICtrlCreateMenu("&File")
$mFO = GUICtrlCreateMenuItem("&Open...", $mFile)
GUICtrlSetOnEvent(-1, '_LoadFile')
$mFC = GUICtrlCreateMenuItem("&Close", $mFile)
GUICtrlSetOnEvent(-1, '_UnloadFile')
GUICtrlCreateMenuItem("", $mFile)
$mFX = GUICtrlCreateMenuItem("E&xit", $mFile)
GUICtrlSetOnEvent(-1, 'Ext')
$mSearch=GUICtrlCreateMenu("&Search")
$mSVirt = GUICtrlCreateMenuItem("Find &Virtual Address Offset ...", $mSearch)
GUICtrlSetOnEvent(-1, 'RVAConvert')
#cs
	- to be added -
	$mEdit=GUICtrlCreateMenu("&Edit")
	$mView=GUICtrlCreateMenu("&View")
	$mHelp=GUICtrlCreateMenu("&Help")
#ce
GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###
_GUICtrlListView_AddColumn ($ListView1, ' ')

Global $colt = -2
Global $LVShowing = 0
_UnloadFile()
_infohide()
_listshow()
GUISetState(@SW_SHOW)
While 1
	Sleep(100)
WEnd

Func RVAConvert()
	if IsArray($ExeSect)=0 Then Return MsgBox(0,'Virtual Address','You must load a file with valid Section headers before using this feature.')
	$rva=InputBox("Get Offset","Please enter a virtual address to convert."&@CRLF&"(Please start hex values with '0x')")
	$rva=StringLower($rva)
	If StringMid($rva,1,2)=='0x' Then
		$rva=Dec(StringMid($rva,3))
	Else
		$rva=Int($rva)
	EndIf
	MsgBox(0,'Virtual Address','My best guess for an offset would be: '&@CRLF&'0x'&_getaddr($rva))
EndFunc
Func Ext()
	_UnloadFile()
	Exit
EndFunc   ;==>Ext

Func _PEAppLib_OnStatusChange($NewStatusText)
	Global $oldText
	Global $Timer
	If StringLen($NewStatusText) < 1 Then Return 0
	If TimerDiff($Timer) < 60 Then Return 0
	If $oldText == $NewStatusText Then Return 0
	$oldText = $NewStatusText
	$Timer = TimerInit()
	GUICtrlSetData($Label1, $NewStatusText)
EndFunc   ;==>_PEAppLib_OnStatusChange


Func _LoadFile()
	_PEAppLib_OnStatusChange('Loading...')
	$filed = FileOpenDialog("Open Executable", @ScriptDir, 'Portable Executables (*.exe;*.dll;*.ocx;*.vbx;*.sys;*.cpl)', 1)
	If @error Then Return
	If FileExists($filed) = 0 Then Return
	_UnloadFile()
	Global $exe_path = $filed

	$exea = StringSplit($exe_path & '/', '\/')
	$fi = UBound($exea) - 2
	If $fi > 0 Then
		WinSetTitle($Form1h, '', $Title & $exea[$fi])
	EndIf
	$exea = 0
	$fi = 0

	Global $exe_data = FileRead($exe_path)
	Global $ExeInfo = _LoadExecutableInfo ($exe_data)
	$Extended = @extended
	$Error = @error
	Switch $Error
		Case 1
			_OMG('The file you chose is not a valid Win32 application.' & @CRLF & 'Program Signature: ' & $Extended)
			Return _UnloadFile()
		Case 2
			_OMG('The file you chose is does not have a WinNT Header.' & @CRLF & "The program will still be analyzed, but information may be limited.")
		Case 3
			_OMG('The file you chose has an unknown WinNT Header Signature.' & @CRLF & "The program will still be analyzed, but information may be incorrect." & @CRLF & 'Header Signature: ' & $Extended)
	EndSwitch
	If $Error = 0 Or $Error = 2 Or $Error = 3 Then
		ConsoleWrite('known EXE' & @CRLF)
		Global $ExeDos = $ExeInfo[0]
	EndIf
	If $Error = 0 Then
		ConsoleWrite('known NT' & @CRLF)
		Global $ExeNT = $ExeInfo[1]
		Global $ExeFile = $ExeInfo[2]
		Global $ExeOpti = $ExeInfo[3]
		Global $ExeData = $ExeInfo[4]
		Global $ExeSect = $ExeInfo[5]
		Global $ExeImpt = $ExeInfo[6]
		Global $ExeExpt = $ExeInfo[7]
		$ExeImpt = StringSplit($ExeImpt, Chr(0))
		$ExeExpt = StringSplit($ExeExpt, Chr(0))
	EndIf
	If $Error = 2 Then
		Global $ExeNT = ''
		ConsoleWrite('not NT' & @CRLF)
	EndIf
	If $Error = 3 Or $Error = 2 Then
		ConsoleWrite('unknown NT' & @CRLF)
		Global $ExeFile = ''
		Global $ExeOpti = ''
		Global $ExeData = ''
		Global $ExeSect = ''
		Global $ExeImpt = ''
		Global $ExeExpt = ''
		Global $ExeInfo = ''
	EndIf
	_LoadFileHead()
EndFunc   ;==>_LoadFile

Func _getaddr($rva)
	Global $ExeSect
	Return Hex(RVA2Offset ($rva, $ExeSect), 8)
EndFunc   ;==>_getaddr



Func _UnloadFile()
	WinSetTitle($Form1h, '', $Title)
	_PEAppLib_OnStatusChange('Unloading...')
	Local $dummyvar = ''
	_Data_ClearCache ($dummyvar)
	_ClearTree()
	_ClearList()
	_ClearCols()
	;----CHECK 1
	_infohide()
	_listshow()
	;----CHECK 1: if all of the info items are set to hidden and the list is set to shown,
	;    why is the list not showing but the info items are!?
	Global $ExeDos = ''
	Global $ExeNT = ''
	Global $ExeFile = ''
	Global $ExeOpti = ''
	Global $ExeData = ''
	Global $ExeSect = ''
	Global $ExeImpt = ''
	Global $ExeInfo = ''
	GUICtrlSetData($Label1, 'Done Unloading.')
EndFunc   ;==>_UnloadFile

Func _LoadFileHead()
	_PEAppLib_OnStatusChange('Adding GUI Controls...')
	_GUICtrlTreeView_BeginUpdate ($TreeView1)
	Local $ExeInfo_l = StringSplit('Header|PE/COFF|File|Optional|Data Directory|Sections', '|')
	Local $max = UBound($ExeInfo_l) - 1
	Global $TreeItems[$max + 1]
	Local $Parent = $TreeView1
	For $i = 1 To $max
		If $i = 2 Then $Parent = $TreeItems[1]
		If $i = 3 Then $Parent = $TreeItems[2]
		$TreeItems[$i] = _treeitem($Parent, $ExeInfo_l[$i])
	Next
	GUICtrlSetOnEvent($TreeItems[1], '_evn_header')
	GUICtrlSetOnEvent($TreeItems[2], '_evn_coff')
	GUICtrlSetOnEvent($TreeItems[3], '_evn_file')
	GUICtrlSetOnEvent($TreeItems[4], '_evn_opti')
	If IsArray($ExeDos) = 0 Then _GUICtrlTreeView_Delete (GUICtrlGetHandle($TreeItems[1]))
	If IsArray($ExeNT) = 0 Then _GUICtrlTreeView_Delete (GUICtrlGetHandle($TreeItems[2]))
	If IsArray($ExeFile) = 0 Then _GUICtrlTreeView_Delete (GUICtrlGetHandle($TreeItems[3]))
	If IsArray($ExeOpti) = 0 Then _GUICtrlTreeView_Delete (GUICtrlGetHandle($TreeItems[4]))
	If IsArray($ExeData) Then
		$maxname = UBound($DataDirNames) - 1
		Global $ExeDataItems[16]
		For $i = 1 To 16
			$dirname = 'Unknown [' & $i & ']'
			If $i <= $maxname Then
				$dirname = $DataDirNames[$i]
			EndIf
			$Data = $ExeData[$i - 1]
			If Dec($Data[1]) < 1 Then ContinueLoop
			$ExeDataItems[$i - 1] = _treeitem($TreeItems[5], $dirname & ' Table')
			GUICtrlSetOnEvent($ExeDataItems[$i - 1], '_evn_tabl')
		Next
		If IsArray($ExeImpt) Then
			Global $ImptMax = UBound($ExeImpt) - 1
			Global $ExeImptItems[$ImptMax]
			For $i = 1 To $ImptMax
				$Imports = StringSplit($ExeImpt[$i], ',')
				If StringLen($Imports[1]) < 1 Then ContinueLoop
				$ExeImptItems[$i - 1] = _treeitem($ExeDataItems[1], $Imports[1])
				GUICtrlSetOnEvent($ExeImptItems[$i - 1], '_evn_impt')
			Next
		EndIf
		If IsArray($ExeExpt) Then
			Global $ExeExptItem=_treeitem($ExeDataItems[0], $ExeExpt[1])
			GUICtrlSetOnEvent($ExeExptItem,'_evn_expt')
		EndIf
	Else
		_GUICtrlTreeView_Delete (GUICtrlGetHandle($TreeItems[5]))
	EndIf


	If IsArray($ExeSect) Then
		Global $SectMax = Dec($ExeFile[1])
		Global $SectItems[$SectMax]
		For $i = 1 To $SectMax
			$Sect = $ExeSect[$i - 1]
			$SectItems[$i - 1] = _treeitem($TreeItems[6], _UnHexEntry ($Sect[0]))
			GUICtrlSetOnEvent($SectItems[$i - 1], '_evn_sect')
		Next
	Else
		_GUICtrlTreeView_Delete (GUICtrlGetHandle($TreeItems[6]))
	EndIf




	$Tree_FileInfo = _treeitem($TreeView1, 'File Info')
	GUICtrlSetOnEvent($Tree_FileInfo, '_evn_fileinfo')



	_GUICtrlTreeView_EndUpdate ($TreeView1)
	GUICtrlSetData($Label1, 'Done Loading.')
EndFunc   ;==>_LoadFileHead

Func _ClearTree()
	Global $sect_hmax, $Tree_Header_SECT_A, $Tree_Header_COFF, $Tree_Header_EXEH, $Tree_Header_OPTI, $Tree_Header_SECT, $Tree_Header
	For $i = 1 To $sect_hmax
		If IsArray($Tree_Header_SECT_A) Then GUICtrlDelete($Tree_Header_SECT_A[$i])
	Next
	_GUICtrlTreeView_DeleteAll ($TreeView1)
EndFunc   ;==>_ClearTree
Func _ClearList()
	_GUICtrlListView_DeleteAllItems ($ListView1)
EndFunc   ;==>_ClearList
Func _ClearCols($op = -1)
	$colmax = _GUICtrlListView_GetColumnCount ($ListView1)
	For $i = $colmax To 1 Step - 1  ;delete col0 ?
		_GUICtrlListView_DeleteColumn ($ListView1, $i)
	Next
	_GUICtrlListView_SetColumn ($ListView1, 0, "Pay no attention to that man behind the curtain!", 1)
	If $op < 0 Then $colt = -1
EndFunc   ;==>_ClearCols
Func _listitem($text, $dummyval = '')
	Return GUICtrlCreateListViewItem($text, $ListView1)
EndFunc   ;==>_listitem
Func _treeitem($treeid, $text)
	$item = GUICtrlCreateTreeViewItem($text, $treeid)
	GUICtrlSetOnEvent($item, '_evn_head')
	Return $item
EndFunc   ;==>_treeitem
Func _list_cols($listname = '')
	_listshow()
	If _vold($colt, 1 & $listname) Then Return 0
	_ClearCols(1)
	_GUICtrlListView_SetColumn ($ListView1, 0, '#', 40)
	_GUICtrlListView_AddColumn ($ListView1, $listname, 500)
	$colt = 1
EndFunc   ;==>_list_cols
Func _header_cols()
	_listshow()
	If _vold($colt, 2) Then Return 0
	_ClearCols(1)
	_GUICtrlListView_SetColumn ($ListView1, 0, '#', 40)
	_GUICtrlListView_AddColumn ($ListView1, 'Value', 200)
	_GUICtrlListView_AddColumn ($ListView1, 'Meaning', 450)
EndFunc   ;==>_header_cols
Func _table_cols()
	_listshow()
	If _vold($colt, 5) Then Return 0
	_ClearCols(1)
	_GUICtrlListView_SetColumn ($ListView1, 0, 'Virtual Address', 200)
	_GUICtrlListView_AddColumn ($ListView1, 'Size', 400)
EndFunc   ;==>_table_cols
Func _import_cols()
	_listshow()
	If _vold($colt, 6) Then Return 0
	_ClearCols(1)
	_GUICtrlListView_SetColumn ($ListView1, 0, '#', 40)
	_GUICtrlListView_AddColumn ($ListView1, 'Hint', 100)
	_GUICtrlListView_AddColumn ($ListView1, 'Name', 400)
EndFunc   ;==>_import_cols
Func _listhide()
	Global $LVShowing
	If $LVShowing == 0 Then Return
	GUICtrlSetState($ListView1, $GUI_HIDE)
	$LVShowing = 0
EndFunc   ;==>_listhide
Func _listshow()
	Global $LVShowing
	If $LVShowing == 1 Then Return
	_infohide()
	GUICtrlSetState($ListView1, $GUI_SHOW)
	$LVShowing = 1
EndFunc   ;==>_listshow
Func _infoshow()
	_infohide()
	_inforead()
	Global $infc
	If IsArray($infc) = 0 Then Return
	For $i = 0 To UBound($infc) - 1
		GUICtrlSetState($infc[$i], $GUI_SHOW)
	Next
EndFunc   ;==>_infoshow
Func _inforead()
	GUICtrlSetData($infc[09], FileGetSize($exe_path))
	GUICtrlSetData($infc[05], _formatdate(FileGetTime($exe_path, 1, 0)))
	GUICtrlSetData($infc[06], _formatdate(FileGetTime($exe_path, 0, 0)))
	GUICtrlSetData($infc[07], _formatdate(FileGetTime($exe_path, 2, 0)))
	GUICtrlSetData($infc[08], '+' & FileGetAttrib($exe_path))
EndFunc   ;==>_inforead
Func _infohide()
	Global $infc
	If IsArray($infc) = 0 Then Return
	For $i = 0 To UBound($infc) - 1
		GUICtrlSetState($infc[$i], $GUI_HIDE)
	Next
EndFunc   ;==>_infohide
Func _infoset()
	Global $infc
	If IsArray($infc) = 0 Then Return
	For $i = 0 To UBound($infc) - 1
		GUICtrlSetState($infc[$i], $GUI_DISABLE)
	Next
	$create = _unformatedate(GUICtrlRead($infc[05]))
	$modify = _unformatedate(GUICtrlRead($infc[06]))
	$access = _unformatedate(GUICtrlRead($infc[07]))
	$attrib = GUICtrlRead($infc[08])
	FileSetTime($exe_path, $create, 1)
	FileSetTime($exe_path, $modify, 0)
	;MsgBox(0,@error,$modify&@CRLF&$m)
	FileSetTime($exe_path, $access, 2)
	FileSetAttrib($exe_path, $attrib)
	Sleep(100)
	_inforead()
	For $i = 0 To UBound($infc) - 1
		GUICtrlSetState($infc[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_infoset
Func _formatattr($s)
EndFunc   ;==>_formatattr
Func _formatdate($a)
	Return $a[1] & '-' & $a[2] & '-' & $a[0] & ' ' & $a[3] & ':' & $a[4] & ':' & $a[5]
EndFunc   ;==>_formatdate
Func _unformatedate($s)
	$a0 = StringSplit($s & ' ', ' ')
	$a1 = StringSplit($a0[1] & '--', '-/\')
	$a2 = StringSplit($a0[2] & '::', ':,.;')
	Return _DigitExtend($a1[3], 4) & _
			_DigitExtend($a1[1], 2) & _
			_DigitExtend($a1[2], 2) & _
			_DigitExtend($a2[1], 2) & _
			_DigitExtend($a2[2], 2) & _
			_DigitExtend($a2[3], 2)
EndFunc   ;==>_unformatedate

Func _evn_fileinfo()
	_listhide()
	_infoshow()
EndFunc   ;==>_evn_fileinfo
Func _evn_header()
	_ClearList()
	_header_cols()
	For $i = 0 To UBound($ExeDos) - 1
		$entry = $ExeDos[$i]
		$text = _DigitExtend($i + 1, 4) & '|' & $entry & '|'
		$val = Dec($entry)
		If $i <> 0 Then $text &= _TagStruct_GetElementName ($tagIMAGE_DOS_HEADER, $i)
		Switch $i
			Case 0
				$text &= 'Signature: "'
				$sign = StringReplace(_UnHexEntry ($entry), Chr(0), '')
				$text &= $sign & '"     (' & _PEAppLib_ConstNameFromVal($IMAGE_Signatures,$val) & ')'
			Case 1 To 6
				$text &= '     (' & $val & ')'
		EndSwitch
		_listitem($text)
	Next
EndFunc   ;==>_evn_header
Func _evn_coff()
	_ClearList()
	_header_cols()
	For $i = 0 To UBound($ExeNT) - 1
		$entry = $ExeNT[$i]
		$text = _DigitExtend($i + 1, 4) & '|' & $entry & '|'
		$val=Dec($entry)
		If $i = 0 Then
			$text &= 'Signature: "'
			$sign = StringReplace(_UnHexEntry ($entry), Chr(0), '')
			$text &= $sign & '"     (' & _PEAppLib_ConstNameFromVal($IMAGE_Signatures,$val) & ')'
		EndIf
		_listitem($text)
	Next
EndFunc   ;==>_evn_coff
Func _evn_file()
	_ClearList()
	_header_cols()
	For $i = 0 To UBound($ExeFile) - 1
		$entry = $ExeFile[$i]
		$text = _DigitExtend($i + 1, 4) & '|' & $entry & '|'
		$text &= _TagStruct_GetElementName ($tagIMAGE_FILE_HEADER, $i)
		$val = Dec($entry)
		Switch $i
			Case 0
				$text &= '     (' &_PEAppLib_ConstNameFromVal($IMAGE_FILE_Machines,$val)&')'
			Case 1, 4
				$text &= '     (' & $val & ')'
			Case 3
				If $val = 0 Then $text &= '     (No Coff Symbol Table)'
			Case 5
				$text &= '     (' & FileSizeDisplay($val, 2, False) & ')'
			Case 6
				$text &= '     ('&_PEAppLib_ConstNamesFromVal($IMAGE_FILE_Characteristics,$val)&')'
				
		EndSwitch
		_listitem($text)
	Next
EndFunc   ;==>_evn_file
Func checkval($v, $v2)
	If BitAND($v, $v2) = $v2 Then Return True
	Return False
EndFunc   ;==>checkval
Func _evn_opti()
	_ClearList()
	_header_cols()
	For $i = 0 To UBound($ExeOpti) - 1
		$entry = $ExeOpti[$i]
		$text = _DigitExtend($i + 1, 4) & '|' & $entry & '|'
		$text &= _TagStruct_GetElementName ($tagIMAGE_OPTIONAL_HEADER, $i)
		$val = Dec($entry)
		Switch $i
			Case 0
				$text &= '    ('&_PEAppLib_ConstNameFromVal($IMAGE_OPTIONAL_Magics,$val)&')'
			Case 22
				$text &= '    ('&_PEAppLib_ConstNameFromVal($IMAGE_OPTIONAL_Subsystems,$val)&')'
			Case 29
				$text &= '     (' & $val & ')'
			Case 3 To 5, 19 To 20, 24 To 27
				$text &= '     (' & FileSizeDisplay($val, 2, False) & ')'
		EndSwitch
		_listitem($text)
	Next
EndFunc   ;==>_evn_opti

Func _evn_sect()
	_ClearList()
	_header_cols()
	$hItem = _GUICtrlTreeView_GetSelection ($TreeView1)
	For $i = 1 To $SectMax
		$hndl = GUICtrlGetHandle($SectItems[$i - 1])
		$Data = $ExeSect[$i - 1]
		If $hItem = $hndl Then ExitLoop
	Next
	If $hItem = $hndl Then
		$Data[0] = StringReplace(_UnHexEntry ($Data[0]), Chr(0), '')
		For $i = 0 To UBound($Data) - 1
			$entry = $Data[$i]
			$text = _DigitExtend($i + 1, 4) & '|' & $entry & '|'
			$text &= _TagStruct_GetElementName ($tagIMAGE_SECTION_HEADER, $i)
			$val = Dec($entry)
			Switch $i
				Case 2
					$text &= '     (Offset: ' & _getaddr($val) & ')'
				Case 3
					$text &= '     (' & FileSizeDisplay($val, 2, False) & ')'
				Case 7, 8
					$text &= '     (' & $val & ')'
				Case 9
					;;;Check Section values!!!!
					$text &= '    (' &_PEAppLib_ConstNamesFromVal($IMAGE_SCN_Characteristics,$val)& ')'
			EndSwitch
			_listitem($text)
		Next
	EndIf
EndFunc   ;==>_evn_sect
Func _evn_tabl()
	$hItem = _GUICtrlTreeView_GetSelection ($TreeView1)
	For $i = 1 To 16
		$hndl = GUICtrlGetHandle($ExeDataItems[$i - 1])
		$Data = $ExeData[$i - 1]
		If $hItem = $hndl Then ExitLoop
	Next
	If $hItem = $hndl Then
		_ClearList()
		_table_cols()
		$val = Dec($Data[0])
		$Data[0] &= '     (Offset: ' & _getaddr($val) & ')'
		$Data[1] &= '     (' & FileSizeDisplay(Dec($Data[1]), 2, False) & ')'
		_listitem($Data[0] & '|' & $Data[1])
	EndIf
EndFunc   ;==>_evn_tabl
Func _evn_expt()
	_ClearList()
	_import_cols()
	$max=UBound($ExeExpt)-1
	For $i=2 To $max
		if StringLen($ExeExpt[$i])<1 Then ContinueLoop
		$exporta = StringSplit($ExeExpt[$i] & '|', '|')
		If StringLen($exporta[2])<1 Then $exporta[2]='   (No Name; Ordinal Only)'
		$exporta[1]=Hex(Int($exporta[1]),4)
		
		$text = _DigitExtend(($i - 1), 4) & '|' & $exporta[1]&'|'&$exporta[2]
		_listitem($text)
	Next
EndFunc
Func _evn_impt()
	$hItem = _GUICtrlTreeView_GetSelection ($TreeView1)
	For $i = 1 To $ImptMax
		$hndl = GUICtrlGetHandle($ExeImptItems[$i - 1])
		$Impt = StringSplit($ExeImpt[$i], ',')
		If $hItem = $hndl Then ExitLoop
	Next
	If $hItem = $hndl Then
		_ClearList()
		_import_cols()
		$max = UBound($Impt) - 1
		For $i = 2 To $max
			$import = $Impt[$i]
			If StringLen($import) < 1 Then ExitLoop
			$importa = StringSplit($import & '|', '|')
			If StringLen($importa[1]) > 4 Then
				$import = StringTrimLeft($importa[1], StringLen($importa[1]) - 4) & '|' & $importa[2]
			EndIf
			If StringLen($importa[2]) < 1 Then
				$import &= '   (No Name; Ordinal Only)'
			Else
				;$import&=' ( )'; - function paren's? ugh.
			EndIf
			$text = _DigitExtend(($i - 1), 4) & '|' & $import
			_listitem($text)
		Next
	EndIf
EndFunc   ;==>_evn_impt
Func _evn_head()
	_ClearList()
	;Dim $hItem
	Local $hItem = @GUI_CtrlId
	;If $hItem = -1 Then $hItem = @GUI_CtrlId
	$hItem = _GUICtrlTreeView_GetSelection ($TreeView1)
	$hText = _GUICtrlTreeView_GetText ($TreeView1, $hItem)
	ConsoleWrite('>TreeSelect ' & $hText & @CRLF)
	_list_cols($hText)
	$children = 999;_GUICtrlTreeView_GetChildCount($ListView1,$hItem)
	For $i = 0 To $children - 1
		If $i = 0 Then
			$hChild = _GUICtrlTreeView_GetFirstChild ($TreeView1, $hItem)
		Else
			$hChild = _GUICtrlTreeView_GetNextChild ($TreeView1, $hChild)
		EndIf
		If $hChild = 0 Then ExitLoop
		$hCText = _GUICtrlTreeView_GetText ($TreeView1, $hChild)
		_listitem(_DigitExtend($i + 1, 4) & '|' & $hCText)
	Next
EndFunc   ;==>_evn_head







Func _OMG($t) ; minor warnings
	MsgBox(0, 'OMG! Warning', $t)
EndFunc   ;==>_OMG
Func _WTF($e, $et) ; major errors
	MsgBox(0, 'WTF!?!?!?', 'A Total WTF Error Has Occured.' & @CRLF & $et & @CRLF & @CRLF & 'Error at: ' & $e)
EndFunc   ;==>_WTF

Func _vold(ByRef $old, $new); determine if a variable value is new or old
	If $old == $new Then Return True
	$old = $new
	Return False
EndFunc   ;==>_vold
Func _DigitExtend($string, $digits)
	Local $stringx = $string
	If StringLen($string) < $digits Then
		$dist = $digits - StringLen($string)
		$stringx = StringMid($string, 1)
		For $g = 1 To $dist
			$stringx = "0" & $stringx
		Next
	EndIf
	Return $stringx
EndFunc   ;==>_DigitExtend


Func FileSizeUnits($iBytes, $iu, $longname = True, $USet = "SI")
	; This function determines the unit-names and pluralty for FileSizeDisplay()
	;	given the byte value, Unit #, long/short setting, and Unit Set
	;Dim $USet, $longname
	Local $UnitSet = ''
	Local $sUnits = ''
	;$iBytes=Int($iBytes)
	If $longname And $USet = "SI" Then $UnitSet = "Byte|Kilobyte|Megabyte|Gigabyte|Terabyte|Petabyte|Exabyte|Zettabyte|Yottabyte"
	If $longname And $USet = "IEC" Then $UnitSet = "Byte|Kibibyte|Mebibyte|Gibibyte|Tebibyte|Pebibyte|Exbibyte|Zebibyte|Yobibyte"
	If $longname = False And $USet = "SI" Then $UnitSet = "B|KB|MB|GB|TB|PB|EB|ZB|YB"
	If $longname = False And $USet = "IEC" Then $UnitSet = "B|KiB|MiB|GiB|TiB|PiB|EiB|ZiB|YiB"
	$UnitSet = StringSplit($UnitSet, "|")
	If $iu > ($UnitSet[0]) Then Return ''
	$sUnits = $UnitSet[$iu]
	If $longname And $iBytes <> 1 Then $sUnits &= 's'
	Return $sUnits
EndFunc   ;==>FileSizeUnits
Func FileSizeDisplay($iBytes, $Round = 2, $longname = True, $Start = 1, $USet = "IEC", $iBase = "IEC", $forceUnits = -1)
	#cs
		This function displays a converts (?)byte value as you would have it seen in your program
		- It adds unit notations and normalizes the number
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Input Values
		iBytes		= Number of (?)bytes to be converted/normalized
		Round		= Number of decimal places to allow, set to -1 to allow all
		longname	= Show unit names (True) or abbreviations (False)
		Start		= Units of inputted iBytes value
		1 - Bytes
		2 - KiloB	/ KibiB
		3 - MegaB	/ MebiB
		4 - GigaB	/ GibiB
		5 - TeraB	/ TebiB
		...
		9 - YottaB	/ YobiB
		USet		= Unit Name Set - can be SI or IEC
		SI (decimal): byte, kilobyte...		This is default because it is used the most
		- used oftenly (and incorrectly) with a base of 10 (iBase 1000)
		but in general, it can be either 10 or 16
		IEC (binary): byte, kebibyte...		These units were created to distinguish against the changeable value of SI units.
		- used always with a base of 16 (iBase 1024) - although this function will not force it.
		iBase		= Unit Base Value - determines what value of bytes equals a kilobyte, etc.
		1024 is the correct value
		Alternatively, you can use several strings as defaults:
		SI		- 1000
		IEC		- 1024 		This is default because it correctly portrays data size
		decimal	- 1000
		binary	- 1024
		forceUnits	= Determines the forced units of the output, set to -1 or 0 to disable
		-refer to Start values-
	#ce
	;Dim $Round, $longname, $USet, $iBase, $Start, $forceUnits
	Local $tmp, $sUnits
	Local $iu = $Start
	Local $riBytes = $iBytes
	Local $iud = 0
	Switch $USet
		Case "decimal"
			$USet = "SI"
		Case "binary"
			$USet = "IEC"
	EndSwitch
	Switch $iBase
		Case "SI"
			$iBase = 1000
		Case "IEC"
			$iBase = 1024
		Case "decimal"
			$iBase = 1000
		Case "binary"
			$iBase = 1024
	EndSwitch
	If $Round > -1 Then
		$riBytes = Round($iBytes, $Round)
	Else
		$riBytes = $iBytes
	EndIf
	$sUnits = FileSizeUnits($riBytes, $iu, $longname, $USet)

	If $forceUnits >= 1 Then
		$iud = Abs($Start - $forceUnits)
		Select
			Case $Start > $forceUnits
				$iBytes *= $iBase ^ $iud
			Case $Start < $forceUnits
				$iBytes /= $iBase ^ $iud
			Case $Start = $forceUnits
				Return $riBytes & ' ' & $sUnits
		EndSelect
		If $Round > -1 Then
			$riBytes = Round($iBytes, $Round)
		Else
			$riBytes = $iBytes
		EndIf
		$sUnits = FileSizeUnits($riBytes, $forceUnits, $longname, $USet)
		Return $riBytes & ' ' & $sUnits
	EndIf
	While $iBytes >= $iBase
		$iu += 1
		$iBytes /= $iBase
		$tmp = $sUnits
		If $Round > -1 Then
			$riBytes = Round($iBytes, $Round)
		Else
			$riBytes = $iBytes
		EndIf
		$sUnits = FileSizeUnits($riBytes, $iu, $longname, $USet)
		If $sUnits = '' Then
			$iBytes *= $iBase
			$iu -= 1
			If $Round > -1 Then
				$riBytes = Round($iBytes, $Round)
			Else
				$riBytes = $iBytes
			EndIf
			$sUnits = $tmp
			ExitLoop
		EndIf
	WEnd
	Return $riBytes & ' ' & $sUnits
EndFunc   ;==>FileSizeDisplay


