#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=CSV-Editor.ico
#AutoIt3Wrapper_outfile=CSV-Editor.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Thanks to autoit.de and autoitscript.com
#AutoIt3Wrapper_Res_Description=CSV-Editor
#AutoIt3Wrapper_Res_Fileversion=0.8.0.0
#AutoIt3Wrapper_Res_LegalCopyright=funkey
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=3079
#AutoIt3Wrapper_Res_Field=Author|funkey
#AutoIt3Wrapper_Res_Field=Author eMail|5tao (ät) gmx.at
#AutoIt3Wrapper_Res_Field=Orginal filename|CSV-Editor.exe
#AutoIt3Wrapper_Res_Field=Productname|CSV-Editor
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#region Description
;Programname: 	CSV-Editor
;Started: 		February 17, 2010
;Author: 		funkey
;Version 0.1:	February 19, 2010
				;First running script
;Version 0.2:	February 20, 2010
				;Use first row as header
;Version 0.3:	February 21, 2010
				;Edit header
				;Open file direct with the program
				;Filename is in Window title
				;Inifile to save the options
;Version 0.4:	February 25, 2010
				;Changed the LV-Color
				;Optional WinSetOnTop
				;Drop files in listview to load
				;Resizing
				;HTML-Export
;Version 0.5:	March 04, 2010
				;Added optional index in first column
				;Updated color in listview with $GUI_BKCOLOR_LV_ALTERNATE
;Version 0.6:	April 03, 2010
				;Improved saving speed
				;Added saving the window position and size
				;Added progressbar during saving and opening
				;Added 'Delete rows' for selected rows in context menu
				;Added 'Delete column' for selected column in context menu
				;Added inserting of new columns and rows
				;Added making backup files when saving
				;Added toolbar
				;Fixed some bugs
				;Changed index showing
;Version 0.7:	April 08, 2010
				;Fixed bugs
				;Added: Icon
				;Added: Save file when exiting
				;Added asterisk (star) to see if file has changed
				;Added in context menu: row to clip
				;Added in context menu: column to clip
				;Added: Support full CSV format	<-- thanks a lot to progandy!!
				;Added: Enter @CRLF to item with Ctrl+{Enter}
;Version 0.8:	April 23, 2010
				;Fixed bugs
				;Added: Cut, copy and paste rows
				;Added: Renew index after changing row(s)
				;Added: Accelerators
				;Added: Search and replace strings
				;Added: Hide toolbar if you want
				;Added: Buttons for row up / row down
				;Added: Create new file

;Next versions will probably contain:
				;Sorting
				;Try to auto-detect separator
				;Replace all

;Thanks to UEZ for beta-testing
#EndRegion Description

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <Misc.au3>
#include <GuiHeader.au3>
#include <GuiToolBar.au3>
#Include <GDIPlus.au3>

Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 2 + 64 + 256 + 512)

Global Const $WM_ENTERSIZEMOVE = 0x231, $WM_EXITSIZEMOVE = 0x232

Global $sTitle = "Autoit CSV-Editor"
Global $sFileName
Global $sIniFile = @ScriptDir & "\CSV-Editor.ini"
Global $aElement[2], $iHeaderSel
Global $hActive, $aCSV, $iChanged = 0, $aCut[1]
Global $LVColor = IniRead($sIniFile, "Options", "LVColor", "0xFFFF80")
Global $AlwaysOnTop = IniRead($sIniFile, "Options", "AlwaysOnTop", "1")
Global $ShowToolbar = IniRead($sIniFile, "Options", "ShowToolbar", "1")
Global $MakeBackup = IniRead($sIniFile, "Options", "MakeBackup", "1")
Global $StartDialog = IniRead($sIniFile, "Options", "StartDialog", "1")
Global $iWidth = IniRead($sIniFile, "Options", "Width", "800"), $iHeight = IniRead($sIniFile, "Options", "Height", "800")
Global $iX = IniRead($sIniFile, "Options", "X", "-1"), $iY = IniRead($sIniFile, "Options", "Y", "-1")
Global Enum $idNew = 1000, $idOpen, $idSave, $idClose, $idFind, $idReplace
Global $iItem
Global $sSearch, $sSearchOld, $aFound[1], $iFoundAct, $iSearchPartial, $nDrawn, $aMarkedItem[2], $k

If $iWidth > @DesktopWidth Then $iWidth = @DesktopWidth
If $iHeight > @DesktopHeight Then $iHeight = @DesktopHeight

Global $hGui = GUICreate($sTitle, $iWidth, $iHeight, $iX, $iY, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX), 0x00000010)
WinSetOnTop($hGui, "", $AlwaysOnTop)
GUISetOnEvent(-3, '_Exit')
GUISetOnEvent($GUI_EVENT_DROPPED, "_DropFiles")

#region Menu
Global $hMenu = GUICtrlCreateMenu("&File")
Global $hMenu1 = GUICtrlCreateMenuItem("&New               Ctrl+N", $hMenu)
GUICtrlSetOnEvent(-1, '_NewFile')
Global $hMenu2 = GUICtrlCreateMenuItem("&Open             Ctrl+O", $hMenu)
GUICtrlSetOnEvent(-1, '_OpenFile')
Global $hMenu3 = GUICtrlCreateMenuItem("&Save              Ctrl+S", $hMenu)
GUICtrlSetOnEvent(-1, '_SaveFile')
GUICtrlSetState(-1, $GUI_DISABLE)
Global $hMenu4 = GUICtrlCreateMenuItem("Save &As", $hMenu)
GUICtrlSetOnEvent(-1, '_SaveFileAs')
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateMenuItem("", $hMenu)
Global $hMenu5 = GUICtrlCreateMenuItem("Export to &HTML", $hMenu)
GUICtrlSetOnEvent(-1, '_HTMLExport')
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateMenuItem("", $hMenu)
Global $hMenu6 = GUICtrlCreateMenuItem("E&xit", $hMenu)
GUICtrlSetOnEvent(-1, '_Exit')
Global $hSearch = GUICtrlCreateMenu("&Search")
Global $hSearch1 = GUICtrlCreateMenuItem("&Find               Ctrl+F", $hSearch)
GUICtrlSetOnEvent(-1, '_ShowFind')
Global $hSearch2 = GUICtrlCreateMenuItem("Find &Next       F3", $hSearch)
GUICtrlSetOnEvent(-1, '_Find')
Global $hSearch3 = GUICtrlCreateMenuItem("R&eplace         Ctrl+H", $hSearch)
GUICtrlSetOnEvent(-1, '_ShowReplace')
Global $hView = GUICtrlCreateMenu("&View")
Global $hView1 = GUICtrlCreateMenuItem("&Color", $hView)
GUICtrlSetOnEvent(-1, '_Change_LV_Color')
Global $hView2 = GUICtrlCreateMenuItem("&Tool Bar", $hView)
GUICtrlSetOnEvent(-1, '_ShowToolbar')
If $ShowToolbar = "1" Then GUICtrlSetState(-1, $GUI_CHECKED)
Global $hView3 = GUICtrlCreateMenuItem("Always On &Top", $hView)
GUICtrlSetOnEvent(-1, '_AlwaysOnTop')
If $AlwaysOnTop = "1" Then GUICtrlSetState(-1, $GUI_CHECKED)
Global $hOption = GUICtrlCreateMenu("&Options")
Global $hOption1 = GUICtrlCreateMenuItem("Make &backupfiles", $hOption)
GUICtrlSetOnEvent(-1, '_MakeBackup')
If $MakeBackup = "1" Then GUICtrlSetState(-1, $GUI_CHECKED)
Global $hOption2 = GUICtrlCreateMenuItem("FileOpenDialog at start", $hOption)
GUICtrlSetOnEvent(-1, '_StartDialog')
If $StartDialog = "1" Then GUICtrlSetState(-1, $GUI_CHECKED)
Global $hInfo = GUICtrlCreateMenu("&Info")
Global $hInfo1 = GUICtrlCreateMenuItem("A&bout", $hInfo)
GUICtrlSetOnEvent(-1, '_About')
#endregion Menu

#region ContextMenu
Global $ContextLVItem = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
GUICtrlCreateMenuItem("Delete selected rows", $ContextLVItem)
GUICtrlSetOnEvent(-1, "_DelRows")
GUICtrlCreateMenuItem("", $ContextLVItem)
GUICtrlCreateMenuItem("Cut this rows", $ContextLVItem)
GUICtrlSetOnEvent(-1, "_CutRow")
GUICtrlCreateMenuItem("", $ContextLVItem)
GUICtrlCreateMenuItem("Put this rows to clip", $ContextLVItem)
GUICtrlSetOnEvent(-1, "_PutRowClip")

Global $ContextLVItem1 = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
GUICtrlCreateMenuItem("Delete selected row", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_DelRows")
GUICtrlCreateMenuItem("Insert empty row before", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_InsertRowBefore")
GUICtrlCreateMenuItem("Insert empty row after", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_InsertRowAfter")
GUICtrlCreateMenuItem("", $ContextLVItem1)
GUICtrlCreateMenuItem("Cut this row", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_CutRow")
GUICtrlCreateMenuItem("Copy this row", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_CopyRow")
GUICtrlCreateMenuItem("Paste row(s) before", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_PasteRowBefore")
GUICtrlCreateMenuItem("Paste row(s) after", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_PasteRowAfter")
GUICtrlCreateMenuItem("", $ContextLVItem1)
GUICtrlCreateMenuItem("Put this row to clip", $ContextLVItem1)
GUICtrlSetOnEvent(-1, "_PutRowClip")

Global $ContextLVHeader = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
GUICtrlCreateMenuItem("Delete this column", $ContextLVHeader)
GUICtrlSetOnEvent(-1, "_DelColumn")
GUICtrlCreateMenuItem("", $ContextLVHeader)
GUICtrlCreateMenuItem("Insert column before", $ContextLVHeader)
GUICtrlSetOnEvent(-1, "_InsertColBefore")
GUICtrlCreateMenuItem("Insert column after", $ContextLVHeader)
GUICtrlSetOnEvent(-1, "_InsertColAfter")
GUICtrlCreateMenuItem("", $ContextLVHeader)
GUICtrlCreateMenuItem("Put this column to clip", $ContextLVHeader)
GUICtrlSetOnEvent(-1, "_PutColClip")
#endregion ContextMenu

#region Toolbar
Global $hToolbar = _GUICtrlToolbar_Create($hGui)
_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
_GUICtrlToolbar_AddButton($hToolbar, $idNew, $STD_FILENEW)
_GUICtrlToolbar_AddButton($hToolbar, $idOpen, $STD_FILEOPEN)
_GUICtrlToolbar_AddButton($hToolbar, $idSave, $STD_FILESAVE)
_GUICtrlToolbar_EnableButton($hToolbar, $idSave, False)
_GUICtrlToolbar_AddButtonSep($hToolbar)
_GUICtrlToolbar_AddButton($hToolbar, $idClose, $STD_DELETE)
_GUICtrlToolbar_AddButtonSep($hToolbar)
_GUICtrlToolbar_AddButton($hToolbar, $idFind, $STD_FIND)
_GUICtrlToolbar_AddButton($hToolbar, $idReplace, $STD_REPLACE)
#endregion Toolbar

Global $hInput = GUICtrlCreateInput("", 0, 0, 0, 0, 0x280)
GUICtrlSetState(-1, $GUI_HIDE)

Global $hLV = GUICtrlCreateListView("", 0, 25, $iWidth, $iHeight - 215, $LVS_SHOWSELALWAYS, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
Global $hListView = GUICtrlGetHandle(-1)
GUICtrlSetBkColor(-1, $LVColor)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_LV_ALTERNATE)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
_GUICtrlListView_SetColumnWidth($hListView, 0, 0)

If $ShowToolbar = "0" Then
	ControlHide($hGui, "", "ToolbarWindow321")
	GUICtrlSetPos($hLV, 0, 0, $iWidth, $iHeight - 190)
EndIf

GUICtrlCreateGroup("Set Separator", 10, $iHeight - 185, 130, 155)
Global $hSep1 = GUICtrlCreateRadio("; Semi Colon", 20, $iHeight - 160, 100, 20)
Global $hSep2 = GUICtrlCreateRadio(", Comma", 20, $iHeight - 140, 100, 20)
Global $hSep3 = GUICtrlCreateRadio("Tab", 20, $iHeight - 120, 100, 20)
Global $hSep4 = GUICtrlCreateRadio("| Pipe", 20, $iHeight - 100, 100, 20)
Global $hSep5 = GUICtrlCreateRadio("Other:", 20, $iHeight - 80, 50, 20)
Global $hSep5a = GUICtrlCreateInput(IniRead($sIniFile, "Options", "SeparatorOther", ""), 80, $iHeight - 80, 40, 20)
Global $hSepOption = GUICtrlCreateCheckbox("True CSV Parsing", 20, $iHeight - 55, 110, 20)
GUICtrlSetTip(-1, "If checked ALL CSV files are opened correctly, but maybe slower!")
GUICtrlSetState(-1, IniRead($sIniFile, "Options", "ParseCSV", "1"))
_SetSeparator()

GUICtrlCreateGroup("Edit Columns", 160, $iHeight - 185, 200, 155)
Global $hLVEditHeader = GUICtrlCreateListView("Header", 170, $iHeight - 170, 180, 105, 0x4000, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))

_GUICtrlListView_SetColumnWidth($hLVEditHeader, 0, 175)

GUICtrlCreateButton("Del selected columns", 190, $iHeight - 55, 135, 20, -1, 0x00000008)
GUICtrlSetOnEvent(-1, "_DelColumns")

Global $hHeader = GUICtrlCreateCheckbox("Use 1st row as header", 380, $iHeight - 175, 130, 20)
GUICtrlSetState(-1, IniRead($sIniFile, "Options", "Header", "4"))
Global $hSaveHeader = GUICtrlCreateCheckbox("Save header to file", 380, $iHeight - 155, 120, 20)
GUICtrlSetOnEvent(-1, "_ChangedOn")
GUICtrlSetState(-1, IniRead($sIniFile, "Options", "SaveHeader", "4"))
Global $hShowIndex = GUICtrlCreateCheckbox("Show index", 380, $iHeight - 135, 120, 20)
GUICtrlSetState(-1, IniRead($sIniFile, "Options", "ShowIndex", "4"))
GUICtrlSetOnEvent(-1, "_ShowIndex")
Global $hSaveIndex = GUICtrlCreateCheckbox("Save index to file", 380, $iHeight - 115, 120, 20)
GUICtrlSetOnEvent(-1, "_ChangedOn")
GUICtrlSetState(-1, IniRead($sIniFile, "Options", "SaveIndex", "4"))

Global $hProgressInfo = GUICtrlCreateLabel("Opening ... 0 %", 380, $iHeight - 70, $iWidth - 390, 20, 0x201)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetResizing(-1, 2 + 4 + 64 + 512)
Global $hProgress = GUICtrlCreateProgress(380, $iHeight - 50, $iWidth - 390, 20)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetResizing(-1, 2 + 4 + 64 + 512)
Global $hWndProgress = GUICtrlGetHandle($hProgress)

Global $hBtnRowUp = GUICtrlCreateButton("5", 520, $iHeight - 180, 30, 30)
GUICtrlSetFont(-1, 20, Default, Default, "Webdings")
GUICtrlSetTip(-1, "Row up")
GUICtrlSetOnEvent(-1, "_RowUp")
GUICtrlSetState(-1, $GUI_DISABLE)
Global $hBtnRowDown = GUICtrlCreateButton("6", 550, $iHeight - 180, 30, 30)
GUICtrlSetFont(-1, 20, Default, Default, "Webdings")
GUICtrlSetTip(-1, "Row down")
GUICtrlSetOnEvent(-1, "_RowDown")
GUICtrlSetState(-1, $GUI_DISABLE)

Global $dummy1 = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_NoSave")
Global $dummy2 = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_SaveChange")
Global $dummy3 = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_AddCRLF")
Global $dummy4 = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_ShowFind")
Global $dummy5 = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_ShowReplace")
Global $AccelKeys[9][2] = [["{ESC}", $dummy1],["{ENTER}", $dummy2],["^{ENTER}", $dummy3],["^f", $dummy4], _
				["^h", $dummy5],["^n", $hMenu1],["^o", $hMenu2],["^s", $hMenu3],["{F3}", $hSearch2]]
GUISetAccelerators($AccelKeys)

#Region ChildGuiFind
Global $hChildGuiFind = GUICreate("Find", 320, 80, -1000, 0, 0x94C800CC, 0x00000101, $hGui)
GUISetState(@SW_HIDE, $hChildGuiFind)
GUISetOnEvent(-3, '_HideChild')

GUICtrlCreateLabel("Find what:", 10, 10, 50, 20)
GUICtrlSetResizing(-1, 32 + 256 + 512)
GUICtrlCreateLabel("Replace with:", 10, 40, 70, 20)
GUICtrlSetResizing(-1, 32 + 256 + 512)
Global $hPartial = GUICtrlCreateCheckbox("Partial search", 10, 55, 90, 20)
GUICtrlSetResizing(-1, 32 + 256 + 512)
Global $hFind = GUICtrlCreateInput("", 85, 6, 150, 20)
GUICtrlSetResizing(-1, 32 + 256 + 512)
Global $hReplace = GUICtrlCreateInput("", 85, 35, 150, 20)
GUICtrlSetResizing(-1, 32 + 256 + 512)
Global $hBtnFind = GUICtrlCreateButton("Find Next", 240, 6, 70, 20, 0x0001)
GUICtrlSetOnEvent(-1, "_Find")
GUICtrlSetResizing(-1, 32 + 256 + 512)
Global $hBtnReplace = GUICtrlCreateButton("Replace", 240, 35, 70, 20)
GUICtrlSetOnEvent(-1, "_Replace")
GUICtrlSetResizing(-1, 32 + 256 + 512)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $hBtnReplaceAll = GUICtrlCreateButton("Replace All", 240, 64, 70, 20)
GUICtrlSetOnEvent(-1, "_ReplaceAll")
GUICtrlSetResizing(-1, 32 + 256 + 512)
GUICtrlSetState(-1, $GUI_DISABLE)
#EndRegion ChildGui

#Region ChildGuiNew
Global $hChildGuiNew = GUICreate("Create new file", 330, 95, -1000, 0, 0x94C800CC, 0x00000101, $hGui)
GUISetState(@SW_HIDE, $hChildGuiNew)
GUISetOnEvent(-3, '_HideChild')

GUICtrlCreateLabel("Set number of columns:", 10, 5, 130, 20)
Global $hInputCol = GUICtrlCreateInput("5", 140, 2, 60, 20)
GUICtrlSetLimit(-1, 3, 1)
Global $hUpDownCol = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 999, 1)
GUICtrlCreateLabel("Set number of rows:", 10, 30, 130, 20)
Global $hInputRow = GUICtrlCreateInput("5", 140, 27, 60, 20)
GUICtrlSetLimit(-1, 5, 1)
Global $hUpDownRow = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 32767, 1)
GUICtrlCreateLabel("Filename:", 10, 55, 130, 20)
GUICtrlCreateLabel("", 10, 70, 280, 20)
Global $hInputFile = GUICtrlCreateEdit("", 10, 70, 280, 20, BitOR(0x80, 0x800))
Global $hBtnChooseFile = GUICtrlCreateButton("...", 300, 70, 20, 20)
GUICtrlSetOnEvent(-1, "_ChooseNewFile")
Global $hBtnCreateFile = GUICtrlCreateButton("OK", 220, 2, 100, 45)
GUICtrlSetOnEvent(-1, "_CreateNewFile")
#EndRegion ChildGui

GUIRegisterMsg($WM_ENTERSIZEMOVE, "EnterSM")
GUIRegisterMsg($WM_EXITSIZEMOVE, "ExitSM")
GUIRegisterMsg(0x24, "_GETMINMAXINFO") ;$WM_GETMINMAXINFO
GUIRegisterMsg(0x4E, "_WM_NOTIFY")
GUIRegisterMsg(0xf, "_WM_PAINT")

If $CmdLine[0] > 0 Then
	$sFileName = $CmdLine[1]
	If FileExists($sFileName) Then
		If StringInStr(FileGetAttrib($sFileName), "D") Then Exit 2 ;"Dropped element was a directory and no file!"
		GUISetState(@SW_SHOW, $hGui)
		_ShowFile()
	Else
		Exit 3
	EndIf
Else
		GUISetState(@SW_SHOW, $hGui)
	If $StartDialog = "1" Then _OpenFile()
EndIf

_GUICtrlListView_RegisterSortCallBack($hListView)

While 1
	Sleep(20000)
WEnd

Func _OpenFile()
	ToolTip("")
	If $iChanged = 1 Then
		Local $iMsg = MsgBox(262144 + 35, $sTitle, 'Do you want to save the file "' & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1)) & '" before opening new file?')
		Switch $iMsg
			Case 6 ;Yes
				_SaveFile()
			Case 7 ;No
				;nothing
			Case Else ;Cancel
				Return
		EndSwitch
	EndIf
	Local $FileName = FileOpenDialog($sTitle, "", 'ASCII files (*.csv;*.txt;*.log;*.ascii)|All files (*.*)', 3, '', $hGui)
	If @error Then Return
	$sFileName = $FileName
	_GUICtrlListView_DeleteAll($hLV)
	_ShowFile()
EndFunc   ;==>_OpenFile

Func _ChooseNewFile()
	Local $NextFile = _FileGetNextBackup(@WorkingDir & "\Untitled.csv")
	$NextFile = StringTrimLeft($NextFile, StringInStr($NextFile, "\", 0, -1))
	Local $NewFile = FileSaveDialog($sTitle & " - Save file", @WorkingDir, 'ASCII files (*.csv;*.txt;*.log;*.ascii)|All files (*.*)', 18, $NextFile, $hChildGuiNew)
	If @error Then Return
	GUICtrlSetData($hInputFile, _ShortenFileName($NewFile, 285))
	GUICtrlSetData($hInputFile - 1, $NewFile)
	GUICtrlSetTip($hInputFile, $NewFile)
EndFunc

Func _ShortenFileName($sFileName, $iMaxLen)
	_GDIPlus_Startup()
	Local $a = _GetTextSize($sFileName)
	If $a[0] < $iMaxLen Then
		_GDIPlus_Shutdown()
		Return $sFileName
	EndIf

	Local $File = "..." & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1) - 1)
	Local $s, $i = 1
	Do
		$s = StringLeft($sFileName, $i) & $File
		$a = _GetTextSize($s, "Arial")
		$i +=1
	Until  $a[0] >= $iMaxLen
	_GDIPlus_Shutdown()
	Return $s
EndFunc

Func _CreateNewFile()
	GUISetState(@SW_HIDE, $hChildGuiNew)
	$sFileName = GUICtrlRead($hInputFile - 1)
	Local $s, $sep = _GetSeparator(), $hFile = FileOpen($sFileName, 10)

	For $i = 1 To GUICtrlRead($hInputRow)
		For $j = 1 To GUICtrlRead($hInputCol) - 1
			$s &= $sep
		Next
		$s &= @CRLF
	Next

	FileWrite($hFile, $s)
	FileClose($hFile)
	_GUICtrlListView_DeleteAll($hLV)
	_ShowFile()
EndFunc

Func _NewFile()
	ToolTip("")
	If $iChanged = 1 Then
		Local $iMsg = MsgBox(262144 + 35, $sTitle, 'Do you want to save the file "' & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1)) & '" before opening new file?')
		Switch $iMsg
			Case 6 ;Yes
				_SaveFile()
			Case 7 ;No
				;nothing
			Case Else ;Cancel
				Return
		EndSwitch
	EndIf

	Local $aPos = WinGetPos($hGui)
	Local $aPosChild = WinGetPos($hChildGuiNew)
	WinMove($hChildGuiNew, "", $aPos[0] - $aPosChild[2]/2 + $aPos[2]/2, $aPos[1] + 90)
	Local $NextFile = _FileGetNextBackup(@WorkingDir & "\Untitled.csv")
	GUICtrlSetData($hInputFile, _ShortenFileName($NextFile, 285))
	GUICtrlSetData($hInputFile - 1, $NextFile)
	GUICtrlSetTip($hInputFile, $NextFile)
	GUISetState(@SW_SHOW, $hChildGuiNew)
EndFunc   ;==>_NewFile

Func _ShowFile()
	GUISetCursor(15, 1)
	AdlibUnRegister("_Redraw")
	Local $sSeparator = _GetSeparator()
	GUICtrlSetData($hProgress, 0)
	GUICtrlSetData($hProgressInfo, "Opening ... 0 %")
	GUICtrlSetState($hProgress, $GUI_SHOW)
	GUICtrlSetState($hProgressInfo, $GUI_SHOW)

	$aCSV = _CSVReadToArray($sFileName, $sSeparator)
	Local $iColumns = UBound($aCSV, 2)
	GUISetState(@SW_LOCK, $hGui)
	_SetLVEditHeader($aCSV)
	For $i = 0 To $iColumns - 1
		_GUICtrlListView_AddColumn($hListView, $aCSV[0][$i])
	Next
	_GUICtrlListView_SetColumnWidth($hListView, 0, 0)
	GUISetState(@SW_UNLOCK, $hGui)
	_GUICtrlListView_AddArrayColor($hLV, $aCSV, 0xFFFFFF)
	GUICtrlSetData($hProgressInfo, "Resizing Columns ... 0 %")
	If GUICtrlRead($hShowIndex) = "1" Then
		_GUICtrlListView_SetColumnWidth($hListView, 0, -2) ;$LVSCW_AUTOSIZE_USEHEADER
	EndIf
	Local $iInfo, $iInfoOld
	For $i = 1 To $iColumns
		_GUICtrlListView_SetColumnWidth($hListView, $i, -2) ;$LVSCW_AUTOSIZE_USEHEADER
		$iInfo = Int($i / $iColumns * 100)
		If $iInfo <> $iInfoOld Then
			GUICtrlSetData($hProgress, $iInfo)
			GUICtrlSetData($hProgressInfo, "Resizing Columns ... " & $iInfo & " %")
		EndIf
		$iInfoOld = $iInfo
	Next
	_Changed(0)
	If BitAND(GUICtrlGetState($hMenu4), 128) Then
		GUICtrlSetState($hMenu4, $GUI_ENABLE) ;Save As
		GUICtrlSetState($hMenu5, $GUI_ENABLE) ;Export to HTML
	EndIf
	GUISetCursor()
	GUICtrlSetState($hProgress, $GUI_HIDE)
	GUICtrlSetState($hProgressInfo, $GUI_HIDE)
	$sSearchOld = ""
	ReDim $aFound[1]
EndFunc   ;==>_ShowFile

Func _ShowIndex()
	If GUICtrlRead($hShowIndex) = "4" Then
		_GUICtrlListView_SetColumnWidth($hListView, 0, 0)
	Else
		_GUICtrlListView_SetColumnWidth($hListView, 0, -2) ;$LVSCW_AUTOSIZE_USEHEADER
	EndIf
EndFunc   ;==>_ShowIndex

Func _DropFiles()
	Local $FileName = @GUI_DragFile
	If StringInStr(FileGetAttrib($FileName), "D") Then
		MsgBox(0x40000 + 16, $sTitle, "Dropped element was a directory and no file!")
		Return
	EndIf
	If $iChanged = 1 Then
		Local $iMsg = MsgBox(262144 + 35, $sTitle, 'Do you want to save the file "' & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1)) & '" before opening new file?')
		Switch $iMsg
			Case 6 ;Yes
				_SaveFile()
			Case 7 ;No
				;nothing
			Case Else ;Cancel
				Return
		EndSwitch
	EndIf
	$sFileName = $FileName
	_GUICtrlListView_DeleteAll($hLV)
	_ShowFile()
EndFunc   ;==>_DropFiles

Func _SaveFileAs()
	Local $aLV, $SaveHeader = 0
	If GUICtrlRead($hSaveHeader) = 4 Then $SaveHeader = 1
	Local $sFileNameNew = FileSaveDialog($sTitle, "", 'ASCII files (*.csv;*.txt;*.log)|All files (*.*)', 18, $sFileName, $hGui)
	If @error Then Return
	GUISetCursor(15, 1)
;~ 	$start = TimerInit()
;~ 	$aLV = _ListViewToArray($hLV)
;~ 	ConsoleWrite(TimerDiff($start) & @CR)
	If GUICtrlRead($hSaveIndex) = "1" Then
		_FileWriteFromArray2D($sFileNameNew, $aCSV, $SaveHeader, 0, 0, 0, _GetSeparator())
	Else
		_FileWriteFromArray2D($sFileNameNew, $aCSV, $SaveHeader, 0, 1, 0, _GetSeparator())
	EndIf
	GUISetCursor()
	$sFileName = $sFileNameNew
	_Changed(0)
EndFunc   ;==>_SaveFileAs

Func _SaveFile()
	ToolTip("")
	Local $aLV, $SaveHeader = 0
	If GUICtrlRead($hSaveHeader) = 4 Then $SaveHeader = 1
	GUISetCursor(15, 1)
;~ 	$start = TimerInit()
;~ 	$aLV = _ListViewToArray($hLV)
;~ 	ConsoleWrite(TimerDiff($start) & @CR)
	If $MakeBackup = "1" Then FileCopy($sFileName, _FileGetNextBackup($sFileName), 0) ;make backupfile
	If GUICtrlRead($hSaveIndex) = "1" Then
		_FileWriteFromArray2D($sFileName, $aCSV, $SaveHeader, 0, 0, 0, _GetSeparator())
	Else
		_FileWriteFromArray2D($sFileName, $aCSV, $SaveHeader, 0, 1, 0, _GetSeparator())
	EndIf
	GUICtrlSetState($hMenu3, $GUI_DISABLE)
	GUISetCursor()
	_Changed(0)
EndFunc   ;==>_SaveFile

Func _FileGetNextBackup($sFile)
	;funkey 2010, April, 02
	Local $NextFile
	Local $sExt = _FileGetExt($sFile)
	For $i = 1 To 999
		$NextFile = StringFormat(StringTrimRight($sFile, StringLen($sExt)) & "(%003i)." & $sExt, $i)
		If Not FileExists($NextFile) Then ExitLoop
	Next
	Return $NextFile
EndFunc   ;==>_FileGetNextBackup

Func _FileGetExt($sFileName)
	Local $sExt = StringTrimLeft($sFileName, StringInStr($sFileName, ".", 0, -1))
	If StringInStr($sExt, "\") Or StringInStr($sExt, "/") Then Return "" ;no extension
	Return $sExt
EndFunc   ;==>_FileGetExt

Func _GUICtrlListView_DeleteAll($hWnd)
	GUISetState(@SW_LOCK, $hGui)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hWnd))
	For $i = 0 To _GUICtrlListView_GetColumnCount($hWnd)
		_GUICtrlListView_DeleteColumn($hWnd, 0)
	Next
	GUISetState(@SW_UNLOCK, $hGui)
EndFunc   ;==>_GUICtrlListView_DeleteAll

Func _SetLVEditHeader($aLV)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hLVEditHeader))
	For $i = 1 To UBound($aLV, 2) - 1
		_GUICtrlListView_AddItem($hLVEditHeader, $aLV[0][$i])
	Next ;==>_SetLVEditHeader
EndFunc   ;==>_SetLVEditHeader

Func _GetSeparator()
	Local $aSep[5] = [";", ",", "	", "|", GUICtrlRead($hSep5a)]
	For $i = $hSep1 To $hSep5
		If BitAND(GUICtrlRead($i), 1) Then ExitLoop
	Next
	Return SetExtended($i - $hSep1, $aSep[$i - $hSep1])
EndFunc   ;==>_GetSeparator

Func _SetSeparator()
	GUICtrlSetState($hSep1 + IniRead($sIniFile, "Options", "Separator", "0"), 1)
EndFunc   ;==>_SetSeparator

Func _ChangedOn()
	_Changed(1)
EndFunc

Func _Changed($OnOff)
	If Not IsArray($aCSV) Then Return
	$iChanged = $OnOff
	If $iChanged Then
		GUICtrlSetState($hMenu3, $GUI_ENABLE)
		_GUICtrlToolbar_EnableButton($hToolbar, $idSave, True)
		WinSetTitle($sTitle, "", $sTitle & " - " & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1)) & " *")
	Else
		GUICtrlSetState($hMenu3, $GUI_DISABLE)
		_GUICtrlToolbar_EnableButton($hToolbar, $idSave, False)
		WinSetTitle($sTitle, "", $sTitle & " - " & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1)))
	EndIf
EndFunc   ;==>_Changed

Func _DelColumn() ;delete single column with context menu
	If MsgBox(262148, "Delete?", "Are you sure?" & @CR & "Do you want to delete column no. " & $iHeaderSel & " (" & _GUICtrlListView_GetItemText($hLVEditHeader, $iHeaderSel - 1) & ") ?") = 7 Then Return
	_GUICtrlListView_DeleteColumn($hListView, $iHeaderSel)
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($hLVEditHeader), $iHeaderSel - 1)
	_ArrayDelete2DColumn($aCSV, $iHeaderSel)
	_Changed(1)
EndFunc   ;==>_DelColumn

Func _DelColumns() ;delete several columns with 2nd listview
	Local $sSel, $aSel = _GUICtrlListView_GetSelectedIndices($hLVEditHeader, 1)
	If $aSel[0] = 0 Then Return
	For $i = 1 To $aSel[0] - 2
		$sSel &= _GUICtrlListView_GetItemText($hLVEditHeader, $aSel[$i]) & ", "
	Next
	If $aSel[0] = 1 Then
		$sSel = _GUICtrlListView_GetItemText($hLVEditHeader, $aSel[1])
	Else
		$sSel &= _GUICtrlListView_GetItemText($hLVEditHeader, $aSel[$aSel[0] - 1]) & " and " & _GUICtrlListView_GetItemText($hLVEditHeader, $aSel[$aSel[0]])
	EndIf
	If MsgBox(262148, "Delete?", "Are you sure?" & @CR & "Do you want to delete following columns?" & @CR & @CR & $sSel) = 7 Then Return

	GUISetCursor(15, 1)
	For $i = _GUICtrlListView_GetItemCount($hLVEditHeader) - 1 To 0 Step -1
		If _GUICtrlListView_GetItemSelected($hLVEditHeader, $i) Then
			_GUICtrlListView_DeleteItem(GUICtrlGetHandle($hLVEditHeader), $i)
			_GUICtrlListView_DeleteColumn($hListView, $i + 1)
			_ArrayDelete2DColumn($aCSV, $i + 1)
		EndIf
	Next
	GUISetCursor()
	_Changed(1)
EndFunc   ;==>_DelColumns

Func _DelRows()
	Local $sSel, $aSel = _GUICtrlListView_GetSelectedIndices($hListView, 1)
	If $aSel[0] = 0 Then Return
	For $i = 1 To $aSel[0] - 2
		$sSel &= $aSel[$i] + 1 & ", "
	Next
	If $aSel[0] = 1 Then
		$sSel = $aSel[1] + 1
	Else
		$sSel &= $aSel[$aSel[0] - 1] + 1& " and " & $aSel[$aSel[0]] + 1
	EndIf
	If MsgBox(262148, "Delete?", "Are you sure?" & @CR & "Do you want to delete following rows (beginning with 1)?" & @CR & @CR & $sSel) = 7 Then Return

	GUISetCursor(15, 1)
	_GUICtrlListView_BeginUpdate($hListView)
	For $i = $aSel[0] To 1 Step -1
		_GUICtrlListView_DeleteItem($hListView, $aSel[$i])
		_ArrayDelete($aCSV, $aSel[$i] + 1)
	Next
	 _RenewIndex($aSel[0])
	_GUICtrlListView_EndUpdate($hListView)
	GUICtrlSetBkColor($hLV, $LVColor)
	GUISetCursor()
	_Changed(1)
EndFunc   ;==>_DelRows

Func _InsertRowBefore()
	GUISetCursor(15, 1)
	Local $aInsert[1]
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	_GUICtrlListView_BeginUpdate($hListView)
	_GUICtrlListView_InsertItem($hListView, "", $iIndex)
	_ArrayInsert2D($aCSV, $aInsert, $iIndex + 1)
	 _RenewIndex($iIndex + 1)
	_GUICtrlListView_EndUpdate($hListView)
	GUICtrlSetBkColor($hLV, $LVColor)
	GUISetCursor()
	_Changed(1)
EndFunc   ;==>_InsertRowBefore

Func _InsertRowAfter()
	GUISetCursor(15, 1)
	Local $aInsert[1]
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hListView) + 1
	_GUICtrlListView_BeginUpdate($hListView)
	_GUICtrlListView_InsertItem($hListView, "", $iIndex)
	_ArrayInsert2D($aCSV, $aInsert, $iIndex + 1)
	 _RenewIndex($iIndex)
	_GUICtrlListView_EndUpdate($hListView)
	GUICtrlSetBkColor($hLV, $LVColor)
	GUISetCursor()
	_Changed(1)
EndFunc   ;==>_InsertRowAfter

Func _InsertColBefore()
	GUISetCursor(15, 1)
	Local $aInsert[1]
	Local $iIndex = $iHeaderSel
	_GUICtrlListView_InsertColumn($hListView, $iIndex, "New Col " & $iIndex)
	_GUICtrlListView_SetColumnWidth($hListView, $iIndex, -2) ;$LVSCW_AUTOSIZE_USEHEADER
	_GUICtrlListView_InsertItem($hLVEditHeader, "New Col " & $iIndex, $iIndex - 1)
	_ArrayInsert2DColumn($aCSV, $aInsert, $iIndex)
	$aCSV[0][$iIndex] = "New Col " & $iIndex
	GUISetCursor()
	_Changed(1)
EndFunc   ;==>_InsertColBefore

Func _InsertColAfter()
	GUISetCursor(15, 1)
	Local $aInsert[1]
	Local $iIndex = $iHeaderSel + 1
	_GUICtrlListView_InsertColumn($hListView, $iIndex, "New Col " & $iIndex)
	_GUICtrlListView_SetColumnWidth($hListView, $iIndex, -2) ;$LVSCW_AUTOSIZE_USEHEADER
	_GUICtrlListView_InsertItem($hLVEditHeader, "New Col " & $iIndex, $iIndex - 1)
	_ArrayInsert2DColumn($aCSV, $aInsert, $iIndex)
	$aCSV[0][$iIndex] = "New Col " & $iIndex
	GUISetCursor()
	_Changed(1)
EndFunc   ;==>_InsertColAfter

Func _PutRowClip()
	Local $sIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	Local $aIndex = StringSplit($sIndex, "|")
	Local $sArray
	For $i = 1 To $aIndex[0]
		$sArray &= _Array2Dto1String($aCSV, GUICtrlRead($hSaveIndex) = "4", $aIndex[$i] + 1, 0, _GetSeparator()) & @CRLF
	Next
	ClipPut($sArray)
EndFunc   ;==>_PutRowClip

Func _PutColClip()
	Local $iIndex = $iHeaderSel
	Local $sArray = _Array2Dto1String($aCSV, GUICtrlRead($hSaveHeader) = "4", $iIndex, 1, _GetSeparator())
	ClipPut($sArray)
EndFunc   ;==>_PutColClip

Func _CutRow()
	GUISetCursor(15, 1)
	Local $sSel, $aSel = _GUICtrlListView_GetSelectedIndices($hListView, 1)
	If $aSel[0] = 0 Then Return
	ReDim $aCut[$aSel[0]]
	_GUICtrlListView_BeginUpdate($hListView)
	For $i = $aSel[0] To 1 Step -1
		$aCut[$i - 1] = _Array2Dto1String($aCSV, 1, $aSel[$i] + 1, 0)
		_GUICtrlListView_DeleteItem($hListView, $aSel[$i])
		_ArrayDelete($aCSV, $aSel[$i] + 1)
	Next
	GUICtrlSetBkColor($hLV, $LVColor)
	 _RenewIndex($aSel[1])
	_GUICtrlListView_EndUpdate($hListView)
	_Changed(1)
	GUISetCursor()
EndFunc

Func _CopyRow()
	GUISetCursor(15, 1)
	Local $sSel, $aSel = _GUICtrlListView_GetSelectedIndices($hListView, 1)
	If $aSel[0] = 0 Then Return
	ReDim $aCut[$aSel[0]]
	For $i = $aSel[0] To 1 Step -1
		$aCut[$i - 1] = _Array2Dto1String($aCSV, 1, $aSel[$i] + 1, 0)
	Next
	GUISetCursor()
EndFunc

Func _PasteRowBefore()
	GUISetCursor(15, 1)
	Local $aInsert
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	_GUICtrlListView_BeginUpdate($hListView)
	For $i = UBound($aCut) - 1 To 0 Step -1
		$aInsert = StringSplit($aCut[$i], "|")
		_GUICtrlListView_InsertItem($hListView, "", $iIndex)
		_GUICtrlListView_SetItemText($hListView, $iIndex, "|" & $aCut[$i], -1)
		_ArrayInsert2D($aCSV, $aInsert, $iIndex + 1)
	Next
	 _RenewIndex($iIndex + 1)
	_GUICtrlListView_EndUpdate($hListView)
	GUICtrlSetBkColor($hLV, $LVColor)
	_Changed(1)
	GUISetCursor()
EndFunc

Func _PasteRowAfter()
	GUISetCursor(15, 1)
	Local $aInsert
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hListView) + 1
	_GUICtrlListView_BeginUpdate($hListView)
	For $i = UBound($aCut) - 1 To 0 Step -1
		$aInsert = StringSplit($aCut[$i], "|")
		_GUICtrlListView_InsertItem($hListView, "", $iIndex)
		_GUICtrlListView_SetItemText($hListView, $iIndex, "|" & $aCut[$i], -1)
		_ArrayInsert2D($aCSV, $aInsert, $iIndex + 1)
	Next
	 _RenewIndex($iIndex)
	_GUICtrlListView_EndUpdate($hListView)
	GUICtrlSetBkColor($hLV, $LVColor)
	_Changed(1)
	GUISetCursor()
EndFunc

Func _RenewIndex($iStart = 1)
	For $i = $iStart To UBound($aCSV, 1) - 1
		$aCSV[$i][0] = $i
		_GUICtrlListView_SetItemText($hListView, $i - 1, $i)
	Next
EndFunc

Func _ShowFind()
	ToolTip("")
	GUICtrlSetState($hInput, $GUI_HIDE)
	If Not IsArray($aCSV) Then Return
	WinSetTitle($hChildGuiFind, "", "Find")
	Local $aPos = WinGetPos($hGui)
	Local $aPosChild = WinGetPos($hChildGuiFind)
	Local $aClientSize = WinGetClientSize($hChildGuiFind)
	ControlHide($hChildGuiFind, "", $hReplace)
	ControlHide($hChildGuiFind, "", $hBtnReplace)
	ControlHide($hChildGuiFind, "", $hBtnReplaceAll)
	ControlHide($hChildGuiFind, "", $hPartial - 1) ;Label 'Replace with'
	GUICtrlSetPos($hPartial, 10, 30)
	GUICtrlSetState($hFind, $GUI_FOCUS)
	WinMove($hChildGuiFind, "", $aPos[0] + $aPos[2] - $aPosChild[2], $aPos[1], $aPosChild[2], $aPosChild[3] - $aClientSize[1] + 55)
	GUISetState(@SW_SHOW, $hChildGuiFind)
	AdlibRegister("_Redraw", 50)
EndFunc

Func _ShowReplace()
	ToolTip("")
	GUICtrlSetState($hInput, $GUI_HIDE)
	If Not IsArray($aCSV) Then Return
	GUICtrlSetState($hBtnReplace, $GUI_DISABLE)
	WinSetTitle($hChildGuiFind, "", "Replace")
	Local $aPos = WinGetPos($hGui)
	Local $aPosChild = WinGetPos($hChildGuiFind)
	Local $aClientSize = WinGetClientSize($hChildGuiFind)
	ControlShow($hChildGuiFind, "", $hReplace)
	ControlShow($hChildGuiFind, "", $hBtnReplace)
	ControlShow($hChildGuiFind, "", $hBtnReplaceAll)
	ControlShow($hChildGuiFind, "", $hPartial - 1) ;Label 'Replace with'
	GUICtrlSetPos($hPartial, 10, 65)
	GUICtrlSetState($hFind, $GUI_FOCUS)
	WinMove($hChildGuiFind, "", $aPos[0] + $aPos[2] - $aPosChild[2], $aPos[1], $aPosChild[2], $aPosChild[3] - $aClientSize[1] + 90)
	GUISetState(@SW_SHOW, $hChildGuiFind)
EndFunc

Func _HideChild()
	GUISetState(@SW_HIDE, $hChildGuiFind)
	GUISetState(@SW_HIDE, $hChildGuiNew)
EndFunc

Func _Find()
	If UBound($aFound) = 1 And Not BitAND(WinGetState($hChildGuiFind), 2) Then
		_ShowFind()
		Return
	EndIf
	Local $aFoundTemp
	$sSearch = GUICtrlRead($hFind)
	If $sSearch = "" Then Return
	Local $iPartial = (GUICtrlRead($hPartial) = 1)
	If $sSearch <> $sSearchOld Or $iPartial <> $iSearchPartial Then
		ReDim $aFound[1]
		$iSearchPartial = $iPartial
		For $i = 1 To UBound($aCSV, 2) - 1	;start at 1 (without index)
			$aFoundTemp = _ArrayFindAll($aCSV, $sSearch, 1, 0, 0, $iPartial, $i)
			If Not @error Then
				For $j = 0 To UBound($aFoundTemp) -1
					$aFoundTemp[$j] = $i & ";" & $aFoundTemp[$j]
				Next
				_ArrayConcatenate($aFound, $aFoundTemp)
			EndIf
		Next
		If UBound($aFound) = 1 Then
			MsgBox(262144 + 48, $sTitle, "Can not find the string '" & $sSearch & "'")
			Return
		EndIf
		$sSearchOld = $sSearch
		$iFoundAct = 1
	Else
		$iFoundAct += 1
		If $iFoundAct = UBound($aFound) Then $iFoundAct = 1
	EndIf
	If UBound($aFound) = 1 Then Return
	If WinGetTitle($hChildGuiFind) = "Find" Then _HideChild()
	Local $aFoundPos = StringSplit($aFound[$iFoundAct], ";", 2)
	_GUICtrlListView_EnsureVisibleEx($hListView, $aFoundPos[1] - 1, $aFoundPos[0])
	$aMarkedItem[0] = $aFoundPos[1] - 1
	$aMarkedItem[1] = $aFoundPos[0]
	_RedrawControl($hLV)
	_GuiCtrlListView_MarkItem($hLV, $aMarkedItem[0], $aMarkedItem[1])
;~ 	$nDrawn = 1
	GUICtrlSetState($hBtnReplace, $GUI_ENABLE)
EndFunc

Func _Replace()
	Local $aFoundPos = StringSplit($aFound[$iFoundAct], ";", 2)
	If @error Then Return
	Local $sTextNew = StringReplace($aCSV[$aFoundPos[1]][$aFoundPos[0]], GUICtrlRead($hFind), GUICtrlRead($hReplace))
	$aCSV[$aFoundPos[1]][$aFoundPos[0]] = $sTextNew
	_GUICtrlListView_SetItemText($hListView, $aFoundPos[1] - 1, $sTextNew, $aFoundPos[0])
	$sSearchOld = ""
	$iFoundAct -= 1
	_ArrayDelete($aFound, $iFoundAct)
	GUICtrlSetState($hBtnReplace, $GUI_DISABLE)
	_WinAPI_RedrawWindow($hGui)
	_Changed(1)
EndFunc

Func _ReplaceAll()
	MsgBox(0x40000 + 48,"Replace All","Coming Soon")
EndFunc

Func _RowUp()
	Local $iSel = _GUICtrlListView_GetSelectedIndices($hListView)
	If $iSel = 0 Then Return
	Local $a1 = StringSplit(_Array2Dto1String($aCSV, 1, $iSel, 0), "|")
	Local $a2 = StringSplit(_Array2Dto1String($aCSV, 1, $iSel + 1, 0), "|")
	For $i = 1 To $a1[0]
		_GUICtrlListView_SetItemText($hListView, $iSel, $a1[$i], $i)
		$aCSV[$iSel + 1][$i] = $a1[$i]
	Next
	For $i = 1 To $a2[0]
		_GUICtrlListView_SetItemText($hListView, $iSel - 1, $a2[$i], $i)
		$aCSV[$iSel][$i] = $a2[$i]
	Next
	_GUICtrlListView_SetItemSelected($hListView, $iSel, 0)
	_GUICtrlListView_SetItemSelected($hListView, $iSel - 1, 1)
	_Changed(1)
EndFunc

Func _RowDown()
	Local $iSel = _GUICtrlListView_GetSelectedIndices($hListView)
	If $iSel + 2 = UBound($aCSV) Then Return
	Local $a1 = StringSplit(_Array2Dto1String($aCSV, 1, $iSel + 1, 0), "|")
	Local $a2 = StringSplit(_Array2Dto1String($aCSV, 1, $iSel + 2, 0), "|")
	For $i = 1 To $a1[0]
		_GUICtrlListView_SetItemText($hListView, $iSel + 1, $a1[$i], $i)
		$aCSV[$iSel + 2][$i] = $a1[$i]
	Next
	For $i = 1 To $a2[0]
		_GUICtrlListView_SetItemText($hListView, $iSel, $a2[$i], $i)
		$aCSV[$iSel + 1][$i] = $a2[$i]
	Next
	_GUICtrlListView_SetItemSelected($hListView, $iSel, 0)
	_GUICtrlListView_SetItemSelected($hListView, $iSel + 1, 1)
	_Changed(1)
EndFunc

Func _HTMLExport()
	GUISetCursor(15, 1)
	_Array2DToHTML()
	GUISetCursor()
EndFunc   ;==>_HTMLExport

Func _RGB2BGR($iColor)
	Local $sH = Hex($iColor, 6)
	Return '0x' & StringRight($sH, 2) & StringMid($sH, 3, 2) & StringLeft($sH, 2)
EndFunc   ;==>_RGB2BGR

Func _GUICtrlListView_EnsureVisibleEx($hwnd, $iIndex, $iSubItem = 0, $fPartialOK = False)
	;funkey	April 15, 2010
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $LVM_ENSUREVISIBLE, $iIndex, $fPartialOK)
	Local $aRect = _GUICtrlListView_GetItemRect($hWnd, $iSubItem)
	Local $iPixel
	For $i = 0 To $iSubItem - 2	; 2 means: show at second visible column
		$iPixel += _GUICtrlListView_GetColumnWidth($hWnd, $i)
	Next
	_GUICtrlListView_Scroll($hWnd, $iPixel + $aRect[0], 0)
EndFunc

Func _Array1DTo2D($a1D, $sDelim = ";", $iSeveral = 0)
	;funkey 17.02.2010
	Local $iUbound = UBound($a1D) - 1
	Local $iTemp = 0, $iColumn = 0
	For $i = 0 To $iUbound
		If $iSeveral Then
			$iTemp = UBound(StringRegExp($a1D[$i], $sDelim & "+", 3))
		Else
			$iTemp = UBound(StringSplit($a1D[$i], $sDelim, 3))
		EndIf
		If $iTemp > $iColumn Then $iColumn = $iTemp
	Next
	If GUICtrlRead($hHeader) = "1" Then ;checked
		Local $a2D[UBound($a1D)][$iColumn + 2]
	Else ;unchecked
		Local $a2D[UBound($a1D) + 1][$iColumn + 2]
		For $i = 1 To UBound($a2D, 2) - 1
			$a2D[0][$i] = "Col" & $i
		Next
	EndIf
	Local $aTemp
	For $i = 0 To $iUbound
		If $iSeveral Then
			$aTemp = StringSplit(StringRegExpReplace($a1D[$i], $sDelim & "+", $sDelim), $sDelim, 3)
		Else
			$aTemp = StringSplit($a1D[$i], $sDelim, 3)
		EndIf
		If GUICtrlRead($hHeader) = "1" Then ;checked
			For $j = 0 To UBound($aTemp) - 1
				$a2D[$i][$j + 1] = $aTemp[$j]
			Next
			$a2D[$i][0] = $i
		Else ;unchecked
			For $j = 0 To UBound($aTemp) - 1
				$a2D[$i + 1][$j + 1] = $aTemp[$j]
			Next
			$a2D[$i + 1][0] = $i + 1
		EndIf
	Next
	$a2D[0][0] = "Index"
	Return SetExtended($iColumn, $a2D)
EndFunc   ;==>_Array1DTo2D

Func _GUICtrlListView_AddArrayColor($hWnd, $aLV, $ColorRow = Default)
	Local $sText, $iInfo, $iInfoOld, $iUbound = UBound($aLV, 1)
	GUICtrlSetState($hLV, $GUI_HIDE)
	For $x = 1 To $iUbound - 1
		$sText = ""
		For $y = 0 To UBound($aLV, 2) - 2
			$sText &= $aLV[$x][$y] & "|"
		Next
		GUICtrlCreateListViewItem($sText & $aLV[$x][$y], $hLV)
		$iInfo = Int(($x + 1) / $iUbound * 100)
		If $iInfo <> $iInfoOld Then
			GUICtrlSetData($hProgress, $iInfo)
			GUICtrlSetData($hProgressInfo, "Opening ... " & $iInfo & " %")
		EndIf
		$iInfoOld = $iInfo
		GUICtrlSetBkColor(-1, $ColorRow)
	Next
	GUICtrlSetState($hLV, $GUI_SHOW)
EndFunc   ;==>_GUICtrlListView_AddArrayColor

Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $hLVHeader, $B_ASCENDING
	$hWndListView = $hLV ; ID des LV
	If Not IsHWnd($hWndListView) Then $hWndListView = GUICtrlGetHandle($hWndListView)
	$hWndListView2 = $hLVEditHeader ; ID des LV
	If Not IsHWnd($hWndListView2) Then $hWndListView2 = GUICtrlGetHandle($hWndListView2)
	$hLVHeader = _GUICtrlListView_GetHeader($hWndListView)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $NM_DBLCLK
;~ 					If $nDrawn Then
;~ 						_WinAPI_RedrawWindow($hGui)
;~ 						$nDrawn = 0
;~ 					EndIf
					Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_GUICtrlListView_EditItem($hWndListView, DllStructGetData($tInfo, "Index"), DllStructGetData($tInfo, "SubItem"))
					$hActive = $hWndListView
				Case $NM_CLICK
;~ 					If $nDrawn Then
;~ 						_WinAPI_RedrawWindow($hGui)
;~ 						$nDrawn = 0
;~ 					EndIf
					GUICtrlSetState($hInput, $GUI_HIDE)
					Local $aSel = _GUICtrlListView_GetSelectedIndices($hListView, 1)
					Switch $aSel[0]
						Case 0
							Return
						Case 1
							GUICtrlSetState($hBtnRowUp, $GUI_ENABLE)
							GUICtrlSetState($hBtnRowDown, $GUI_ENABLE)
						Case Else
							GUICtrlSetState($hBtnRowUp, $GUI_DISABLE)
							GUICtrlSetState($hBtnRowDown, $GUI_DISABLE)
					EndSwitch
		Case $NM_RCLICK
;~ 					If $nDrawn Then
;~ 						_WinAPI_RedrawWindow($hGui)
;~ 						$nDrawn = 0
;~ 					EndIf
					GUICtrlSetState($hInput, $GUI_HIDE)
					Local $aSel = _GUICtrlListView_GetSelectedIndices($hListView, 1)
					Switch $aSel[0]
						Case 0
							Return
						Case 1
							_ShowMenu($hGui, $ContextLVItem1)
						Case Else
							_ShowMenu($hGui, $ContextLVItem)
					EndSwitch
				Case $LVN_COLUMNCLICK ; A column was clicked -> sort ascendend
					GUICtrlSetState($hInput, $GUI_HIDE)
					Return
					_GUICtrlListView_SortItems($hListView, GUICtrlGetState($hLV))
;~                     Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~                     _GUICtrlListView_SimpleSort($hWndListView, $B_ASCENDING, DllStructGetData($tInfo, "SubItem"))
				Case -180	;scroll
					$k = 1
			EndSwitch
		Case $hWndListView2
			Switch $iCode
				Case $NM_DBLCLK
					Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					AdlibUnRegister("_Redraw")
					_GUICtrlListView_EditItem($hWndListView2, DllStructGetData($tInfo, "Index"), DllStructGetData($tInfo, "SubItem"))
					$hActive = $hWndListView2
				Case $NM_CLICK
					GUICtrlSetState($hInput, $GUI_HIDE)
			EndSwitch
		Case $hLVHeader
			Switch $iCode
				Case $NM_RCLICK
					Opt("MouseCoordMode", 2)
					Local $aRect = _GUICtrlListView_GetItemRect($hListView, 0)
					Local $aHeaderTest = _GUICtrlHeader_HitTest($hLVHeader, MouseGetPos(0) - $aRect[0] + 5, 5)
					$iHeaderSel = $aHeaderTest[0]
					Opt("MouseCoordMode", 1)
					If $iHeaderSel > 0 Then _ShowMenu($hGui, $ContextLVHeader) ;do not delete index and don't show context menu when no file is opened
			EndSwitch
		Case $hToolbar
			Switch $iCode
				Case $TBN_HOTITEMCHANGE
					$tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $ilParam)
;~ 					$i_idOld = DllStructGetData($tNMTBHOTITEM, "idOld")
					Local $i_idNew = DllStructGetData($tNMTBHOTITEM, "idNew")
					Local $dwFlags = DllStructGetData($tNMTBHOTITEM, "dwFlags")
					If BitAND($dwFlags, $HICF_LEAVING) = $HICF_LEAVING Then
						ToolTip("")
					Else
						Switch $i_idNew
							Case $idNew
								ToolTip("New file")
							Case $idOpen
								ToolTip("Open file")
							Case $idSave
								If $i_idNew <> $iItem Then ToolTip("Save file")
							Case $idClose
								ToolTip("Close application")
							Case $idFind
								ToolTip("Find string")
							Case $idReplace
								ToolTip("Replace string")
						EndSwitch
					EndIf
					$iItem = $i_idNew ; Save new hotitem ID to global
				Case $NM_CLICK
					Switch $iItem
						Case $idNew
							_NewFile()
						Case $idOpen
							_OpenFile()
						Case $idSave
							_SaveFile()
						Case $idClose
							_Exit()
						Case $idFind
							_ShowFind()
						Case $idReplace
							_ShowReplace()
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY

Func _WM_PAINT($hWnd, $Msg, $wParam, $lParam)
	If $aMarkedItem[0] = "" And $aMarkedItem[1] = "" Then Return
	$k = 1
	Return
EndFunc

Func _GUICtrlListView_EditItem($hWnd, $iIndex, $iSubItem)
	;funkey 19.02.2010
	If $iIndex < 0 Then Return
	Local $aPos, $aRect, $iSum = 0
	Local $x, $y, $w, $h
	For $i = 0 To $iSubItem - 1
		$iSum += _GUICtrlListView_GetColumnWidth($hWnd, $i)
	Next
	$aRect = _GUICtrlListView_GetItemRect($hWnd, $iIndex)
	$aPos = ControlGetPos($sTitle, "", $hWnd)
	$x = $iSum + $aPos[0] + $aRect[0]
	$y = $aPos[1] + $aRect[1]
	$w = _GUICtrlListView_GetColumnWidth($hWnd, $iSubItem)
	$h = $aRect[3] - $aRect[1]
	GUICtrlSetPos($hInput, $x + 3, $y + 1, $w, $h + 4)
	GUICtrlSetData($hInput, _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem))
	GUICtrlSetState($hInput, $GUI_SHOW)
	GUICtrlSetState($hInput, $GUI_FOCUS)
	$aElement[0] = $iIndex
	$aElement[1] = $iSubItem
EndFunc   ;==>_GUICtrlListView_EditItem

Func _AddCRLF()
	If Not BitAND(GUICtrlGetState($hInput), $GUI_SHOW) Then Return
	ControlCommand($sTitle, "", $hInput, "EditPaste", @CRLF)
EndFunc   ;==>_AddLF

Func _SaveChange()
	Local $sText = GUICtrlRead($hInput)
	Local $MadeChange
	If StringInStr($sText, @CR) Or StringInStr($sText, @LF) Then
		If StringLeft($sText, 1) <> '"' And StringInStr(StringMid($sText, 2, StringLen($sText) - 2), '"') Then $sText = StringReplace($sText, '"', "'")
		$sText = '"' & StringReplace($sText, '"', '') & '"'
	EndIf
	_GUICtrlListView_BeginUpdate($hActive)
	_GUICtrlListView_SetItemText($hActive, $aElement[0], $sText, $aElement[1])
	GUICtrlSetState($hInput, $GUI_HIDE)
	If $hActive = GUICtrlGetHandle($hLVEditHeader) Then
		_GUICtrlListView_SetColumn($hListView, $aElement[0] + 1, $sText)
		_GUICtrlListView_SetColumnWidth($hListView, $aElement[0] + 1, -2) ;$LVSCW_AUTOSIZE_USEHEADER
		If $aCSV[0][$aElement[0]] <> $sText Then $MadeChange = 1
		$aCSV[0][$aElement[0]] = $sText
	Else
		If $aCSV[$aElement[0] + 1][$aElement[1]] <> $sText Then $MadeChange = 1
		$aCSV[$aElement[0] + 1][$aElement[1]] = $sText
		_GUICtrlListView_SetColumnWidth($hListView, $aElement[1], -2) ;$LVSCW_AUTOSIZE_USEHEADER
	EndIf
	_GUICtrlListView_EndUpdate($hActive)
	If $MadeChange Then _Changed(1)
;~ 	_ArrayDisplay($aFound)
	Local $Test = _ArraySearch($aFound, $aElement[1] & ";" & $aElement[0] + 1)
	If $Test >= 0 And Not StringInStr($sText, GUICtrlRead($hFind)) Then _ArrayDelete($aFound, $Test)
;~ 	_ArrayDisplay($aFound)
EndFunc   ;==>_SaveChange

Func _NoSave()
	GUICtrlSetState($hInput, $GUI_HIDE)
EndFunc   ;==>_NoSave

Func _About()
	MsgBox(0x40000 + 64, $sTitle, "This Software is used to easy edit CSV-files" & @CR & _
			"and other compatible text files that can be splitted by a delimiter." & @CR & _
			@CR & _
			"Copyright by funkey" & @CR & _
			"Have fun!", 5)
EndFunc   ;==>_About

Func _SaveOptions()
	Local $sSeparator = _GetSeparator()
	Local $iSeparator = @extended
	Local $aWinPos = WinGetPos($sTitle)
	Local $aClientSize = WinGetClientSize($sTitle)
	Local $aMenu = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 15) ;SM_CYMENU

	IniWrite($sIniFile, "Options", "Separator", $iSeparator)
	IniWrite($sIniFile, "Options", "SeparatorOther", GUICtrlRead($hSep5a))
	IniWrite($sIniFile, "Options", "ParseCSV", GUICtrlRead($hSepOption))
	IniWrite($sIniFile, "Options", "Header", GUICtrlRead($hHeader))
	IniWrite($sIniFile, "Options", "ShowIndex", GUICtrlRead($hShowIndex))
	IniWrite($sIniFile, "Options", "SaveIndex", GUICtrlRead($hSaveIndex))
	IniWrite($sIniFile, "Options", "SaveHeader", GUICtrlRead($hSaveHeader))
	IniWrite($sIniFile, "Options", "X", $aWinPos[0])
	IniWrite($sIniFile, "Options", "Y", $aWinPos[1])
	IniWrite($sIniFile, "Options", "Width", $aClientSize[0])
	IniWrite($sIniFile, "Options", "Height", $aClientSize[1] + $aMenu[0])
EndFunc   ;==>_SaveOptions

Func _Change_LV_Color()
	Local $NewCol = _ChooseColor(2, _RGB2BGR($LVColor))
	If $NewCol > -1 Then
		IniWrite($sIniFile, "Options", "LVColor", $NewCol)
		$LVColor = $NewCol
		GUICtrlSetBkColor($hLV, $LVColor)
	EndIf
EndFunc   ;==>_Change_LV_Color

Func _ShowToolbar()
	Local $aPos = ControlGetPos($hGui, "", $hListView)
	If $ShowToolbar = "1" Then
		$ShowToolbar = "0"
		GUICtrlSetState($hView2, $GUI_UNCHECKED)
		ControlHide($hGui, "", "ToolbarWindow321")
		GUICtrlSetPos($hLV, 0, 0, $aPos[2], $aPos[3] + 25)
	Else
		$ShowToolbar = "1"
		GUICtrlSetState($hView2, $GUI_CHECKED)
		GUICtrlSetPos($hLV, 0, 25, $aPos[2], $aPos[3] - 25)
		ControlShow($hGui, "", "ToolbarWindow321")
	EndIf
	IniWrite($sIniFile, "Options", "ShowToolbar", $ShowToolbar)
EndFunc

Func _AlwaysOnTop()
	If $AlwaysOnTop = "1" Then
		$AlwaysOnTop = "0"
		GUICtrlSetState($hView3, $GUI_UNCHECKED)
	Else
		$AlwaysOnTop = "1"
		GUICtrlSetState($hView3, $GUI_CHECKED)
	EndIf
	WinSetOnTop($hGui, "", $AlwaysOnTop)
	IniWrite($sIniFile, "Options", "AlwaysOnTop", $AlwaysOnTop)
EndFunc   ;==>_AlwaysOnTop

Func _MakeBackup()
	If $MakeBackup = "1" Then
		$MakeBackup = "4"
		GUICtrlSetState($hOption1, $GUI_UNCHECKED)
	Else
		$MakeBackup = "1"
		GUICtrlSetState($hOption1, $GUI_CHECKED)
	EndIf
	IniWrite($sIniFile, "Options", "MakeBackup", $MakeBackup)
EndFunc   ;==>_MakeBackup

Func _StartDialog()
	If $StartDialog = "1" Then
		$StartDialog = "4"
		GUICtrlSetState($hOption2, $GUI_UNCHECKED)
	Else
		$StartDialog = "1"
		GUICtrlSetState($hOption2, $GUI_CHECKED)
	EndIf
	IniWrite($sIniFile, "Options", "StartDialog", $StartDialog)
EndFunc   ;==>_StartDialog

Func _GETMINMAXINFO($hWnd, $msg, $wParam, $lParam)
	Local $minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
	DllStructSetData($minmaxinfo, 7, 600) ; min X
	DllStructSetData($minmaxinfo, 8, 390) ; min Y
;~     DllStructSetData($minmaxinfo, 9, 500) ; max X
;~     DllStructSetData($minmaxinfo, 10, 700) ; max Y
EndFunc   ;==>_GETMINMAXINFO

Func EnterSM($hW, $iM, $wP, $lP)
;~     GUICtrlSetState($hLV, $GUI_HIDE)
;~     GUICtrlSetState($hLVEditHeader, $GUI_HIDE)
;~     _WinAPI_SetWindowLong($hGui, $GWL_EXSTYLE, $WS_EX_COMPOSITED)
EndFunc   ;==>EnterSM


Func ExitSM($hW, $iM, $wP, $lP)
;~     GUICtrlSetState($hLV, $GUI_SHOW)
;~     GUICtrlSetState($hLVEditHeader, $GUI_SHOW)
;~     _WinAPI_SetWindowLong($hGui, $GWL_EXSTYLE, 0)
EndFunc   ;==>ExitSM

Func _Exit()
	If $iChanged = 1 Then
		Local $iMsg = MsgBox(262144 + 35, $sTitle, 'Do you want to save the file "' & StringTrimLeft($sFileName, StringInStr($sFileName, "\", 0, -1)) & '" before closing application?')
		Switch $iMsg
			Case 6 ;Yes
				_SaveFile()
			Case 7 ;No
				;nothing
			Case Else ;Cancel
				Return
		EndSwitch
	EndIf
	_GUICtrlListView_UnRegisterSortCallBack($hListView)
	_SaveOptions()
	Exit 0
EndFunc   ;==>_Exit

Func _ListViewToArray($hWnd)
	GUICtrlSetData($hProgress, 0)
	GUICtrlSetData($hProgressInfo, "Saving ... 0 %")
	GUICtrlSetState($hProgress, $GUI_SHOW)
	GUICtrlSetState($hProgressInfo, $GUI_SHOW)
	Local $sString = "", $iInfo, $iInfoOld, $iCount = _GUICtrlListView_GetItemCount($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	For $i = 0 To $iCount - 1
		$iInfo = Int(($i + 1) / $iCount * 100)
		If $iInfo <> $iInfoOld Then
			GUICtrlSetData($hProgress, $iInfo)
			GUICtrlSetData($hProgressInfo, "Saving ... " & $iInfo & " %")
		EndIf
		$iInfoOld = $iInfo
		$sString &= _GUICtrlListView_GetItemTextString($hWnd, $i)
		$sString &= ";"
	Next
	$aSplit = StringSplit(StringTrimRight($sString, 1), ";", 2)
	$iUB1 = UBound($aSplit)
	Dim $aRet[$iUB1][1]
	For $i = 0 To $iUB1 - 1
		$aSplit2 = StringSplit($aSplit[$i], "|", 2)
		$iUB2 = UBound($aSplit2)
		If $iUB2 > UBound($aRet, 2) Then ReDim $aRet[$iUB1][$iUB2]
		For $j = 0 To $iUB2 - 1
			$aRet[$i][$j] = $aSplit2[$j]
		Next
	Next
	GUICtrlSetState($hProgress, $GUI_HIDE)
	GUICtrlSetState($hProgressInfo, $GUI_HIDE)
	Return $aRet
EndFunc   ;==>_ListViewToArray

;==========================================================================================================================================
; Function:            _FileWriteFromArray2D($FILEPATH, $ARRAY [, $iROWstart=0 [, $iROWend=0 [, $iCOLstart=0 [, $iCOLend=0 [, $DELIM='|']]]]])
;
; Description:      Write 1D/2D array to file, 2D with delimiter between every entry
;
; Parameter(s):     $FILEPATH    - path/filename of the file to be write
;                   $ARRAY        - array to write from
;      optional     $iROWstart    - start row-index, default 0
;      optional     $iROWend    - end row-index, default Ubound(array)-1
;      optional     $iCOLstart    - start column-index, default 0
;      optional     $iCOLend    - end column-index, default Ubound(array,2)-1
;      optional     $DELIM        - delimiter for 2D-array entries, default '|'
;
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns -1
;                   On Failure - Returns 0 and sets @error = 1 (given array is'nt array); @error = 2 (unable to open filepath)
;
; Note:                If $iROWstart > $iROWend or $iCOLstart > $iCOLend the values will be swapped among
;
; Author(s):        BugFix ( [EMAIL]bugfix@autoit.de[/EMAIL] )
;==========================================================================================================================================
Func _FileWriteFromArray2D($FILEPATH, $ARRAY, $iROWstart = 0, $iROWend = 0, $iCOLstart = 0, $iCOLend = 0, $DELIM = '|')
	If Not IsArray($ARRAY) Then
		SetError(1)
		Return 0
	EndIf
	Local $Ubound = UBound($ARRAY)
	If $iROWend = 0 Then $iROWend = $Ubound - 1
	Local $fh = FileOpen($FILEPATH, 2)
	If $fh = -1 Then
		SetError(2)
		Return 0
	EndIf
	Select
		Case $iROWstart < 0 Or $iROWstart > $Ubound - 1
			$iROWstart = 0
			ContinueCase
		Case $iROWend < 0 Or $iROWend > $Ubound - 1
			$iROWend = $Ubound - 1
			ContinueCase
		Case $iROWstart > $iROWend
			$tmp = $iROWstart
			$iROWstart = $iROWend
			$iROWend = $tmp
	EndSelect
	Local $Ubound2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		For $i = $iROWstart To $iROWend
			FileWriteLine($fh, $ARRAY[$i])
		Next
	Else
		If $iCOLend = 0 Then $iCOLend = $Ubound2nd - 1
		Select
			Case $iCOLstart < 0 Or $iCOLstart > $Ubound2nd - 1
				$iCOLstart = 0
				ContinueCase
			Case $iCOLend < 0 Or $iCOLend > $Ubound2nd - 1
				$iCOLend = $Ubound2nd - 1
				ContinueCase
			Case $iCOLstart > $iCOLend
				$tmp = $iCOLstart
				$iCOLstart = $iCOLend
				$iCOLend = $tmp
		EndSelect
		For $i = $iROWstart To $iROWend
			$tmp = ''
			For $k = $iCOLstart To $iCOLend
				If $k < $iCOLend Then
					$tmp &= $ARRAY[$i][$k] & $DELIM
				Else
					$tmp &= $ARRAY[$i][$k]
				EndIf
			Next
			FileWriteLine($fh, $tmp)
		Next
	EndIf
	FileClose($fh)
	Return -1
EndFunc   ;==>_FileWriteFromArray2D

Func _Array2DToHTML()
	;funkey 25.02.2010
	Local $FileNameDefault = @ScriptDir & "\" & StringTrimLeft(StringLeft($sFileName, StringInStr($sFileName, ".", 0, -1)), StringInStr($sFileName, "\", 0, -1)) & "html"
	Local $sFileNameNew = FileSaveDialog($sTitle, "", 'HTML file (*.html)', 18, $FileNameDefault, $hGui)
	If @error Then Return
	Local $start = (GUICtrlRead($hSaveIndex) = "4") + 0
	Local $sMiddle = '   <TR BGCOLOR="#336699">' & @CRLF
	Local $sHeader = '<!-- THIS FILE WAS CREATED BY ' & $sTitle & ' -->' & @CRLF & _
			'<!-- DOCTYPE html PUBLIC -->' & @CRLF & _
			'<HTML>' & @CRLF & _
			' <HEAD>' & @CRLF & _
			'  <META HTTP - EQUIV = "Content - Type" CONTENT = "TEXT/HTML">' & @CRLF & _
			'  <META NAME = "GENERATOR" CONTENT = "' & $sTitle & '" >' & @CRLF & _
			'  <TITLE></TITLE>' & @CRLF & _
			' </HEAD>' & @CRLF & _
			' <BODY BGCOLOR="#FFFFFF" LINK="#0000FF" ALINK="#FF0000" VLINK="#FFFF00" TEXT="#000000">' & @CRLF & _
			' <FONT COLOR="#000000" FACE="Arial,Helvetica">' & @CRLF & _
			'  <HR>' & @CRLF & _
			'  <TABLE WIDTH="100%" CELLPADDING="4" CELLSPACING="0" BORDER="1" BGCOLOR="#FFFFCF">' & @CRLF & _
			'  <FONT COLOR="#000000" FACE="Arial,Helvetica">' & @CRLF
	Local $sBottom = '  </FONT>' & @CRLF & _
			'  </TABLE>' & @CRLF & _
			'  <HR>' & @CRLF & _
			'Created: ' & StringFormat("%s.%s.%s %s:%s:%s", @MDAY, @MON, @YEAR, @HOUR, @MIN, @SEC) & @CRLF & _		; (dd.mm.yyyy hh:mm:ss)
			' </FONT>' & @CRLF & _
			' </BODY>' & @CRLF & _
			'</HTML>' & @CRLF & @CRLF
	If GUICtrlRead($hSaveHeader) = "1" Then
		For $h = $start To UBound($aCSV, 2) - 1
			$sMiddle &= '    <TD><B><FONT COLOR="#FFFFFF"><small>' & $aCSV[0][$h] & '</small></FONT></B></TD>' & @CRLF
		Next
	EndIf
	$sMiddle &= '   </TR>' & @CRLF
	For $l = 1 To UBound($aCSV, 1) - 1
		If Mod($l, 2) Then
			$sMiddle &= '   <TR>' & @CRLF
		Else
			$sMiddle &= '   <TR BGCOLOR="#FFFFFF">' & @CRLF
		EndIf
		For $c = $start To UBound($aCSV, 2) - 1
			If StringReplace($aCSV[$l][$c], " ", "") = "" Then $aCSV[$l][$c] = " "
			$sMiddle &= '    <TD><small>' & $aCSV[$l][$c] & '</small></TD>' & @CRLF
		Next
		$sMiddle &= '   </TR>' & @CRLF
	Next

	Local $hFile = FileOpen($sFileNameNew, 2)
	FileWrite($hFile, $sHeader & $sMiddle & $sBottom)
	FileClose($hFile)
	ShellExecute($sFileNameNew)
EndFunc   ;==>_Array2DToHTML

Func _ArrayDelete2DColumn(ByRef $avArray, $nColumn = 0)
	_Array2DTransposeAU3($avArray)
	_ArrayDelete($avArray, $nColumn)
	_Array2DTransposeAU3($avArray)
	Return @error
EndFunc   ;==>_ArrayDelete2DColumn

Func _Array2DTransposeAU3(ByRef $ar_Array)
	If IsArray($ar_Array) Then
		Local $ar_ExcelValueTrans[UBound($ar_Array, 2)][UBound($ar_Array, 1)] ;ubound($s_i_ExcelValue,2)-1, ubound($s_i_ExcelValue,1)-1)
		For $j = 0 To UBound($ar_Array, 2) - 1
			For $numb = 0 To UBound($ar_Array, 1) - 1
				$ar_ExcelValueTrans[$j][$numb] = $ar_Array[$numb][$j]
			Next
		Next
		$ar_Array = $ar_ExcelValueTrans
	Else
		;MsgBox(0, "", "No Array to transpose")
	EndIf
EndFunc   ;==>_Array2DTransposeAU3

Func _ArrayInsert2D(ByRef $avArray, $aRowArray, $nRow = '')
	Local $number_of_columns = UBound($avArray, 2), $number_of_rows = UBound($avArray), $nSize = 0, $arraysize
	If $number_of_columns < (UBound($aRowArray)) Then $number_of_columns = UBound($aRowArray)
;~ 	If $nRow > $number_of_rows - 1 Then	;orig
	If $nRow > $number_of_rows Then ;modified by funkey
		SetError(2)
		Return (2)
	EndIf
	If $avArray[0][0] <> '' Or UBound($avArray) - 1 > 0 Then $number_of_rows = $number_of_rows + 1
	If $number_of_columns < UBound($aRowArray) Then $number_of_columns = UBound($aRowArray)
	ReDim $avArray[$number_of_rows][$number_of_columns]
	If $nRow == '' Then
		$arraysize = UBound($aRowArray);Find array size
		For $c = 0 To $arraysize - 1
			$avArray[$number_of_rows - 1][$c] = $aRowArray[$c]
		Next
		SetError(0)
		Return (0)
	EndIf
	For $r = $number_of_rows - 1 To $nRow Step -1
		For $c = 0 To UBound($avArray, 2) - 1
			If $r <> $nRow Then
				$avArray[$r][$c] = $avArray[$r - 1][$c]
				$avArray[$r - 1][$c] = ''
			Else
				If Not ($c > UBound($aRowArray) - 1) Then
					$avArray[$r][$c] = $aRowArray[$c]
				EndIf
			EndIf
		Next
	Next
	SetError(0)
	Return (0)
EndFunc   ;==>_ArrayInsert2D

Func _ArrayInsert2DColumn(ByRef $avArray, $aRowArray = "", $nColumn = '')
	_Array2DTransposeAU3($avArray)
	_ArrayInsert2D($avArray, $aRowArray, $nColumn)
	_Array2DTransposeAU3($avArray)
	Return @error
EndFunc   ;==>_ArrayInsert2DColumn

Func _ShowMenu($hWnd, $nContextID)
	Local $x, $y
	Local $hMenu = GUICtrlGetHandle($nContextID)
	$x = MouseGetPos(0)
	$y = MouseGetPos(1)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>_ShowMenu

Func _Array2Dto1String(ByRef $ar2ArrayStrings, $Index, $row, $column = 0, $iDelim = "|")
	Local $ar1String
	If $column <> 0 Then
		For $c = $Index To UBound($ar2ArrayStrings) - 1
			$ar1String &= $iDelim & $ar2ArrayStrings[$c][$row]
		Next
	Else
		For $r = $Index To UBound($ar2ArrayStrings, 2) - 1
			$ar1String &= $iDelim & $ar2ArrayStrings[$row][$r]
		Next
	EndIf
	Return StringMid($ar1String, 2, StringLen($ar1String) - 1)
EndFunc   ;==>_Array2Dto1String

; #FUNCTION# ====================================================================================================================
; Name...........: _ParseCSV
; Description ...: Reads a CSV-file
; Syntax.........: _ParseCSV($sFile, $sDelimiters=',', $sQuote='"', $iFormat=0)
; Parameters ....: $sFile       - File to read or string to parse
;                  $sDelimiters - [optional] Fieldseparators of CSV, mulitple are allowed (default: ,;)
;                  $sQuote      - [optional] Character to quote strings (default: ")
;                  $iFormat     - [optional] Encoding of the file (default: 0):
;                  |-1     - No file, plain data given
;                  |0 or 1 - automatic (ASCII)
;                  |2      - Unicode UTF16 Little Endian reading
;                  |3      - Unicode UTF16 Big Endian reading
;                  |4 or 5 - Unicode UTF8 reading
;                  $iAddIndex     - [optional] Adds an index in first column
;                  $AddHeader     - [optional] Adds an automatic header ("Col1", "Col2", ....)
; Return values .: Success - 2D-Array with CSV data (0-based)
;                  Failure - 0, sets @error to:
;                  |1 - could not open file
;                  |2 - error on parsing data
;                  |3 - wrong format chosen
; Author ........: ProgAndy
; Modified.......: funkey (to fit the function to the CSV-Editor)
; Remarks .......:
; Related .......: _WriteCSV
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _ParseCSV($sFile, $sDelimiters = ',;', $sQuote = '"', $iFormat = 0, $iAddIndex = 0, $AddHeader = 0)
    Local Static $aEncoding[6] = [0, 0, 32, 64, 128, 256]
    If $iFormat < -1 Or $iFormat > 6 Then
        Return SetError(3, 0, 0)
    ElseIf $iFormat > -1 Then
        Local $hFile = FileOpen($sFile, $aEncoding[$iFormat]), $sLine, $aTemp, $aCSV[1], $iReserved, $iCount
        If @error Then Return SetError(1, @error, 0)
        $sFile = FileRead($hFile)
        FileClose($hFile)
    EndIf
    If $sDelimiters = "" Or IsKeyword($sDelimiters) Then $sDelimiters = ',;'
    If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
    $sQuote = StringLeft($sQuote, 1)
    $iAddIndex = Number($iAddIndex=True)
    $AddHeader = Number($AddHeader=True)
    Local $srDelimiters = StringRegExpReplace($sDelimiters, '[\\\^\-\[\]]', '\\\0')
    Local $srQuote = StringRegExpReplace($sQuote, '[\\\^\-\[\]]', '\\\0')
    Local $sPattern = StringReplace(StringReplace('(?m)(?:^|[,])\h*(["](?:[^"]|["]{2})*["]|[^,\r\n]*)(\v+)?', ',', $srDelimiters, 0, 1), '"', $srQuote, 0, 1)
    Local $aREgex = StringRegExp($sFile, $sPattern, 3)
    If @error Then Return SetError(2, @error, 0)
    $sFile = '' ; save memory
    Local $iBound = UBound($aREgex), $iIndex = $AddHeader, $iSubBound = 1+$iAddIndex, $iSub = $iAddIndex, $sLast='' ;changed
    If $iBound Then $sLast = $aREgex[$iBound-1]
    Local $aResult[$iBound + $iAddIndex][$iSubBound] ;changed
    For $i = 0 To $iBound - 1
        If $iSub = $iSubBound Then
            $iSubBound += 1
            ReDim $aResult[$iBound][$iSubBound]
        EndIf
        Select
            Case StringLeft(StringStripWS($aREgex[$i], 1), 1) = $sQuote
                $aREgex[$i] = StringStripWS($aREgex[$i], 3)
                $aResult[$iIndex][$iSub] = $aREgex[$i]
;~                 $aResult[$iIndex][$iSub] = StringReplace(StringMid($aREgex[$i], 2, StringLen($aREgex[$i])-2), $sQuote&$sQuote, $sQuote, 0, 1)
            Case StringRegExp($aREgex[$i], '^\v+$') ; StringLen($aREgex[$i]) < 3 And StringInStr(@CRLF, $aREgex[$i]) ;new line found
                StringReplace($aREgex[$i], @LF, "", 0, 1)
                $iIndex += @extended
                $iSub = $iAddIndex ;changed
                ContinueLoop
            Case Else
                $aResult[$iIndex][$iSub] = $aREgex[$i]
        EndSelect
        $aREgex[$i] = 0 ; save memory
        $iSub += 1
        If $iAddIndex Then $aResult[$iIndex][0] = $iIndex ;added
    Next
    If Not StringRegExp($sLast, '^\v+$') Then $iIndex+=1
    ReDim $aResult[$iIndex][$iSubBound - 1]
    If $iAddIndex Then $aResult[0][0] = "Index" ;added
    If $AddHeader Then
        For $i = 1 To $iSubBound - 2
            $aResult[0][$i] = "Col" & $i
        Next
    EndIf
    Return $aResult
EndFunc   ;==>_ParseCSV

Func _CSVReadToArray($sFile, $sSeparator, $sQuote = '"')
	Switch GUICtrlRead($hSepOption)
		Case 1
			Return _ParseCSV($sFile, $sSeparator, $sQuote, 0, 1, (GUICtrlRead($hHeader) = "4") + 0)
		Case 4
			Local $hFile = FileOpen($sFile, 0)
			Local $sText = FileRead($hFile)
			FileClose($hFile)
			Local $aArray
			If StringRight($sText, 1) = @LF Then $sText = StringTrimRight($sText, 1)
			If StringRight($sText, 1) = @CR Then $sText = StringTrimRight($sText, 1)

			If StringInStr($sText, @LF) Then
				$aArray = StringSplit(StringStripCR($sText), @LF, 2)
			ElseIf StringInStr($sText, @CR) Then ;; @LF does not exist so split on the @CR
				$aArray = StringSplit($sText, @CR, 2)
			Else ;; unable to split the file
				If StringLen($sText) Then
					Dim $aArray[1] = [$sText]
				Else
					Return SetError(2, 0, 0)
				EndIf
			EndIf
			$aArray = _Array1DTo2D($aArray, $sSeparator)
			ReDim $aArray[UBound($aArray, 1)][UBound($aArray, 2) - 1]
			Return $aArray
	EndSwitch
EndFunc   ;==>_CSVReadToArray

Func _GuiCtrlListView_MarkItem($hWnd, $iIndex, $iSubItem, $Color = 0xFF)
    ;funkey    April 23, 2010
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $hWndGui = _WinAPI_GetParent($hWnd)
    Local $aWndSize = WinGetPos($hWndGui)
    Local $aWndClientSize = WinGetClientSize($hWndGui)
    Local $aPos = ControlGetPos($hWndGui, "", $hWnd)
	Local $hHeader = HWnd(_GUICtrlListView_GetHeader($hWnd))
	Local $aPosHeader = ControlGetPos($hWndGui, "", $hHeader)
	Local $iSubItemHelp = $iSubItem
	If $iSubItem = -1 Then $iSubItemHelp = 0
    Local $aRect = _GUICtrlListView_GetSubItemRect($hWnd, $iIndex, $iSubItemHelp)
	If $iSubItem = 0 Then $aRect[2] = _GUICtrlListView_GetColumnWidth($hWnd, 0)
	
	Local $a = 1, $b = 1, $c = 1, $d = 1
	Local $arrowXL, $arrowXR, $arrowYU, $arrowYD
	Local $bInCtrl = 1
	Local $s = _WinAPI_GetSystemMetrics(21)	;SM_CXHSCROLL	The width of the arrow bitmap on a horizontal scroll bar, in pixels.
	Local $o = $aWndSize[2] - $aWndClientSize[0]
	Local $p = $aWndSize[3] - $aWndClientSize[1]
	$s += $o
	
    Local $hDC, $hPen, $obj_orig
    $hDC = _WinAPI_GetWindowDC($hWndGui)
    $hPen = _WinAPI_CreatePen($PS_SOLID, 1, $Color)
    $obj_orig = _WinAPI_SelectObject($hDC, $hPen)
	
	If $aRect[0] > $aPos[2] - $s Then
		$bInCtrl = 0
		$arrowXL = 1
	EndIf
	If $aRect[1] > $aPos[3] - $s Then
		$bInCtrl = 0
		$arrowYU = 1
	EndIf
	If $aRect[2] < 0 Then
		$bInCtrl = 0
		$arrowXR = 1
	EndIf
	If $aRect[3] < $aPosHeader[3] Then
		$bInCtrl = 0
		$arrowYD = 1
	EndIf
	If $bInCtrl Then
		If $aRect[0] < 0 Then
			$a = 0
			$aRect[0] = 0
		EndIf
		If $aRect[1] < $aPosHeader[3] Then
			$b = 0
			$aRect[1] = $aPosHeader[3]
		EndIf
		If $aRect[2] > $aPos[2] - $s Then
			$c = 0
			$aRect[2] = $aPos[2] - $s
		EndIf
		If $aRect[3] > $aPos[3] - $s Then
			$d = 0
			$aRect[3] = $aPos[3] - $s
		EndIf

		Local $x1 = $aRect[0] + $aPos[0] + $o - 1
		Local $y1 = $aRect[1] + $aPos[1] + $p
		Local $x2 = $aRect[2] + $aPos[0] + $o - 1
		Local $y2 = $aRect[3] + $aPos[1] + $p
		
		If $a Then _WinAPI_DrawLine($hDC, $x1 + 1, $y1, $x1 + 1, $y2 - 1)
		If $b Then _WinAPI_DrawLine($hDC, $x1 + 1, $y1, $x2 - 1, $y1)
		If $c Then _WinAPI_DrawLine($hDC, $x2 - 1, $y1, $x2 - 1, $y2 - 1)
		If $d Then _WinAPI_DrawLine($hDC, $x1 + 1, $y2 - 2, $x2 - 1, $y2 - 2)
	Else
		;maybe show the direction to scroll (draw arrows)
	EndIf

	; clear resources
    _WinAPI_SelectObject($hDC, $obj_orig)
    _WinAPI_DeleteObject($hPen)
    _WinAPI_ReleaseDC($hWndGui, $hDC)
EndFunc   ;==>_GuiCtrlListView_MarkItem

Func _GetTextSize($nText, $sFont = 'Microsoft Sans Serif', $iFontSize = 8.5, $iFontAttributes = 0)
	;Author: Bugfix
	;Modified: funkey
	If $nText = '' Then Return 0
;~ 	_GDIPlus_Startup()
	Local $hFormat = _GDIPlus_StringFormatCreate(0)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $iFontSize, $iFontAttributes, 3)
	Local $tLayout = _GDIPlus_RectFCreate(15, 171, 0, 0)
	Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND(0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $nText, $hFont, $tLayout, $hFormat)
	Local $iWidth = Ceiling(DllStructGetData($aInfo[0], "Width"))
	Local $iHeight = Ceiling(DllStructGetData($aInfo[0], "Height"))
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_GraphicsDispose($hGraphic)
;~ 	_GDIPlus_Shutdown()
	Local $aSize[2] = [$iWidth, $iHeight]
	Return $aSize
EndFunc   ;==>_GetTextSize

Func _RedrawControl($hCtrl)
	;funkey	April 22, 2010
	If Not IsHWnd($hCtrl) Then $hCtrl = GUICtrlGetHandle($hCtrl)
	Local $hWnd = _WinAPI_GetParent($hCtrl)
    Local $aPos = ControlGetPos($hWnd, "", $hWnd)
	Local $hRegion = _WinAPI_CreateRectRgn($aPos[0], $aPos[1], $aPos[0] + $aPos[2], $aPos[1] + $aPos[3])
	_WinAPI_RedrawWindow($hWnd, 0, $hRegion)
EndFunc

Func _Redraw()
	Switch $k
		Case 0
			Return
		Case 1
			_GuiCtrlListView_MarkItem($hLV, $aMarkedItem[0], $aMarkedItem[1])
			$k = 0
	EndSwitch
EndFunc
