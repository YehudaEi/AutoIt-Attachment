#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\vrr.ico
#AutoIt3Wrapper_outfile=UninstallerPro.exe
#AutoIt3Wrapper_Res_Description=A Convinient and fast uninstaller interface...
#AutoIt3Wrapper_Res_Fileversion=1.11
#AutoIt3Wrapper_Res_LegalCopyright=rajeshwithsoftware at gmail dot com
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf 1 /striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <String.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <comboConstants.au3>
#include <WindowsConstants.au3>
#include <_EnumInstalledSoftware_UDF8.au3>
#include <array.au3>

Opt("GUIOnEventMode", 1)

#include <GuiImageList.au3>

#Region ### START Koda GUI section ###

Local $iExWindowStyle = $WS_EX_CLIENTEDGE ;BitOR($WS_EX_DLGMODALFRAME, $WS_EX_CLIENTEDGE)
Local $iExListViewStyle = BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER)

$frmMain = GUICreate("Smart Uninstaller", 606, 609, 196, 133)
GUISetBkColor(0xFFFFFF, $frmMain)
GUISetOnEvent($GUI_EVENT_CLOSE, "frmMainClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "frmMainMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "frmMainMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "frmMainRestore")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_MonitorSelectionChange")

$lstViewSoftware = GUICtrlCreateListView("Name|Version|Company", 12, 92, 585, 325, -1, $iExWindowStyle)
_GUICtrlListView_SetExtendedListViewStyle($lstViewSoftware, $iExListViewStyle)
_GUICtrlListView_SetColumnWidth(-1, 0, 235)
_GUICtrlListView_SetColumnWidth(-1, 1, 85)
_GUICtrlListView_SetColumnWidth(-1, 2, 235)
GUICtrlSetOnEvent(-1, "lstSoftwareClick")
_GUICtrlListView_RegisterSortCallBack(-1, False, False)

$chkShowUpdates = GUICtrlCreateCheckbox("Show Software Updates", 120, 25, 153, 18)
GUICtrlSetOnEvent(-1, "chkShowUpdatesClick")
ConsoleWrite(GUICtrlRead(-1) & @CRLF)
$chkShowHidden = GUICtrlCreateCheckbox("Show Hidden Software", 288, 25, 137, 18)
GUICtrlSetOnEvent(-1, "chkShowHiddenClick")
ConsoleWrite(GUICtrlRead(-1) & @CRLF)
$lblListBoxTitle = GUICtrlCreateLabel("lblListBoxTitle", 20, 58, 400, 17)
GUICtrlSetOnEvent(-1, "lblListBoxTitleClick")
$lblStatus = GUICtrlCreateLabel("Ready", 12, 578, 580, 17)
GUICtrlSetOnEvent(-1, "lblStatusClick")
$lblDispOptions = GUICtrlCreateLabel("Display Options", 24, 25, 77, 18)
GUICtrlSetOnEvent(-1, "lblDispOptionsClick")
;~ $Input1 = GUICtrlCreateInput("inputSearch", 112, 55, 209, 20)
;~ GUICtrlSetOnEvent(-1, "inputSearchClick")
;~ $lblSearch = GUICtrlCreateLabel("Search", 34, 55, 38, 20)
;~ GUICtrlSetOnEvent(-1, "lblSearchClick")
;~ $lblDisplayName = GUICtrlCreateLabel("lblDisplayName", 20, 430, 76, 17)
;~ GUICtrlSetOnEvent(-1, "lblDisplayNameClick")
;~ $lblURLUpdateInfo = GUICtrlCreateLabel("lblURLUpdateInfo", 19, 447, 89, 17)
;~ GUICtrlSetOnEvent(-1, "lblURLUpdateInfoClick")
$btnChange = GUICtrlCreateButton("Modify (Change)", 232, 530, 110, 33, 0)
GUICtrlSetOnEvent(-1, "btnChangeClick")
$btnRemove = GUICtrlCreateButton("Uninstall (Remove)", 352, 530, 110, 33, 0)
GUICtrlSetOnEvent(-1, "btnRemoveClick")
$btnQuietUninst = GUICtrlCreateButton("Silent Uninstall", 473, 530, 110, 33, 0)
GUICtrlSetOnEvent(-1, "btnQuietUninstClick")
$btnRefresh = GUICtrlCreateButton("Refresh", 46, 530, 110, 33, 0)
GUICtrlSetOnEvent(-1, "_RefreshList")
$cboSortOrder = GUICtrlCreateCombo("", 470, 55, 125, 19, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Software Title|Software Publisher", "Software Title")
GUICtrlSetOnEvent(-1, "cboSortOrderClick")
$lblSortOrder = GUICtrlCreateLabel("Sort by:", 423, 58, 40, 20)
$chkLoadIcons = GUICtrlCreateCheckbox("Load Program Icons", 450, 25, 137, 18)
GUICtrlSetOnEvent(-1, "chkLoadIconsClick")
_GetSoftwareList()
GUISetState(@SW_SHOW)

#EndRegion ### END Koda GUI section ###
;
_PopulateGUIList()


While 1
	Sleep(100)
WEnd

Func _CreateMenuControl()
;~ 	$mnuUninstOptions = GUICtrlCreateContextMenu($lstViewSoftware)
EndFunc   ;==>_CreateMenuControl

Func _PopulateGUIList()
	Local $iconPath[3], $SoftwareList, $colWidth[3]
	GUICtrlSetState($lstViewSoftware, $GUI_HIDE)
	_GUICtrlListView_DeleteAllItems($lstViewSoftware)
	$SoftwareList = _GetSoftwareList()
	$colWidth[0] = _GUICtrlListView_GetColumnWidth($lstViewSoftware, 0)
	$colWidth[1] = _GUICtrlListView_GetColumnWidth($lstViewSoftware, 1)
	$colWidth[2] = _GUICtrlListView_GetColumnWidth($lstViewSoftware, 2)
;~ 	there is plans in future to use GUICtrlListView_AddArray but icons would be a little tough - once icons are sorted , will use GUIImageList for icons...
	For $i = 1 To $SoftwareList[0][0]
		GUICtrlCreateListViewItem($SoftwareList[$i][1] & "|" & $SoftwareList[$i][2] & "|" & $SoftwareList[$i][4], $lstViewSoftware)
		If GUICtrlRead($chkLoadIcons) = 1 Then
			$iconPath = _GetIcon($SoftwareList, $i)
			_SetIcon(-1, $iconPath)
		EndIf
	Next
	_GUICtrlListView_SetColumnWidth($lstViewSoftware, 0, $colWidth[0])
	_GUICtrlListView_SetColumnWidth($lstViewSoftware, 1, $colWidth[1])
	_GUICtrlListView_SetColumnWidth($lstViewSoftware, 2, $colWidth[2])
	GUICtrlSetState($lstViewSoftware, $GUI_SHOW)
	GUICtrlSetData($lblListBoxTitle, $SoftwareList[0][0] & " Software Title(s) Found")
EndFunc   ;==>_PopulateGUIList
;

#Region EventHandlers
Func btnChangeClick()
	Local $Selection = _GetSelectedItem()
;~ 	GUICtrlSetData($lblStatus, $Selection[3])
	_DoAction($Selection, $btnChange)
EndFunc   ;==>btnChangeClick

Func btnQuietUninstClick()
	Local $Selection = _GetSelectedItem()
;~ 	GUICtrlSetData($lblStatus, $Selection[3])
	_DoAction($Selection, $btnQuietUninst)
EndFunc   ;==>btnQuietUninstClick

Func btnRemoveClick()
	Local $Selection = _GetSelectedItem()
;~ 	GUICtrlSetData($lblStatus, $Selection[3])
	_DoAction($Selection, $btnRemove)
EndFunc   ;==>btnRemoveClick

Func chkLoadIconsClick()
	_RefreshList()
EndFunc   ;==>chkLoadIconsClick

Func chkShowHiddenClick()
	_RefreshList()
EndFunc   ;==>chkShowHiddenClick

Func chkShowUpdatesClick()
	_RefreshList()
EndFunc   ;==>chkShowUpdatesClick

Func frmMainClose()
	_GUICtrlListView_UnRegisterSortCallBack($lstViewSoftware)
	GUIDelete()
	Exit
EndFunc   ;==>frmMainClose

Func frmMainMaximize()
EndFunc   ;==>frmMainMaximize

Func frmMainMinimize()

EndFunc   ;==>frmMainMinimize

Func frmMainRestore()

EndFunc   ;==>frmMainRestore

Func inputSearchClick()

EndFunc   ;==>inputSearchClick


Func lblDispOptionsClick()

EndFunc   ;==>lblDispOptionsClick

Func lblListBoxTitleClick()

EndFunc   ;==>lblListBoxTitleClick

Func lblSearchClick()

EndFunc   ;==>lblSearchClick

Func lblSortOrderClick()

EndFunc   ;==>lblSortOrderClick

Func lblStatusClick()

EndFunc   ;==>lblStatusClick

Func lblURLUpdateInfoClick()

EndFunc   ;==>lblURLUpdateInfoClick

Func lstSoftwareClick()
	Local $tmp = _GetSelectedItem()
;~ 	ConsoleWrite(@CRLF & $tmp[1])
;~ 	ConsoleWrite(@CRLF & @MSEC & "lstSoftwareClick called")
	; use a variable or hidden column in the list view to identify original populated index because it is important for getselecteitem function...
	If GUICtrlGetState($lstViewSoftware) <> 1 Then
		If GUICtrlGetState($lstViewSoftware) = 0 Then
			GUICtrlSetData($cboSortOrder, "")
			GUICtrlSetData($cboSortOrder, "Software Title|Software Publisher", "Software Title")
		EndIf
		If GUICtrlGetState($lstViewSoftware) = 2 Then
			GUICtrlSetData($cboSortOrder, "")
			GUICtrlSetData($cboSortOrder, "Software Title|Software Publisher", "Software Publisher")
		EndIf
		_GUICtrlListView_SortItems($lstViewSoftware, GUICtrlGetState($lstViewSoftware))
	EndIf
EndFunc   ;==>lstSoftwareClick

Func cboSortOrderClick()
	; later on , need to set the selected item into focus...
	ConsoleWrite(@CRLF & @MSEC & " lstsortorderclick called")
	If GUICtrlRead($cboSortOrder) = "Software Title" Then _GUICtrlListView_SortItems($lstViewSoftware, 0)
	If GUICtrlRead($cboSortOrder) = "Software Publisher" Then _GUICtrlListView_SortItems($lstViewSoftware, 2)
EndFunc   ;==>cboSortOrderClick

Func _RefreshList()
	$Selection = _GetSelectedItem()
	_PopulateGUIList()
	_SetPreviousSelection($Selection)
EndFunc   ;==>_RefreshList

#EndRegion EventHandlers

#Region OtherFunctions

Func _GetSoftwareList()
	Local $retVal = _Enum_InstalledApps(GUICtrlRead($chkShowUpdates), GUICtrlRead($chkShowHidden))
	Switch GUICtrlRead($cboSortOrder)
		Case "Software Title"
			_ArraySort($retVal, 0, 1, 0, 1)
		Case "Software Publisher"
			_ArraySort($retVal, 0, 1, 0, 4)
	EndSwitch
	Return $retVal
EndFunc   ;==>_GetSoftwareList

Func _GetSelectedItem()
	Local $retVal[10]
	$SoftwareList = _GetSoftwareList()
	For $i = 0 To $SoftwareList[0][0]
		If _GUICtrlListView_GetItemSelected($lstViewSoftware, $i) Then
			$retVal[0] = $i
			$retVal[1] = $SoftwareList[$i + 1][0] ; GUID or registry hive path - even if the display name is changed, this is bound to stay permanent
			$retVal[2] = $SoftwareList[$i + 1][1] ; DisplayName
			$retVal[3] = $SoftwareList[$i + 1][3] ; uninstallstring
			$retVal[4] = $SoftwareList[$i + 1][11] ; QuietUninstallString
			$retVal[5] = $SoftwareList[$i + 1][6] ; ModifyPath
			$retVal[6] = $SoftwareList[$i + 1][7] ; NoRemoveTag
			$retVal[7] = $SoftwareList[$i + 1][5] ; NoModifyPtag
			$retVal[8] = $SoftwareList[$i + 1][9] ; IsHidden
			$retVal[9] = $SoftwareList[$i + 1][8] ; display icon.
		EndIf
	Next
	Return $retVal
EndFunc   ;==>_GetSelectedItem

Func _SetPreviousSelection($selArray)
	$SoftwareList = _GetSoftwareList()
	For $i = 0 To $SoftwareList[0][0]
		If $SoftwareList[$i][0] = $selArray[1] Then
			_GUICtrlListView_SetItemSelected($lstViewSoftware, $i - 1, True, True)
		EndIf
	Next
EndFunc   ;==>_SetPreviousSelection

#EndRegion OtherFunctions
;

Func _MonitorSelectionChange()
	;Local $t = _GetSelectedItem()
	;GUICtrlSetData($lblStatus, "Clicked at " & @MSEC & ":" & ":" & GUICtrlRead($lstViewSoftware) & ":" & $t[4]) ;_GUICtrlListView_GetItemState($lstViewSoftware,,$LVIS_FOCUSED))
EndFunc   ;==>_MonitorSelectionChange

Func _DoAction($Selection, $btnTag)
	Local $ActionTag, $ActionString
	
	Switch $btnTag
		Case $btnChange
			$ActionTag = "Modification / Repair"
			$ActionString = StringStripWS($Selection[5], 3)
		Case $btnRemove
			$ActionTag = "Uninstallation / Removal"
			$ActionString = StringStripWS($Selection[3], 3)
		Case $btnQuietUninst
			$ActionTag = "Silent Uninstallation without further prompts"
			$ActionString = StringStripWS($Selection[4], 3)
	EndSwitch
	
	If StringLen($ActionString) = 0 Then
		GUICtrlSetData($lblStatus, $ActionTag & " not available for " & $Selection[2])
	Else
		GUICtrlSetData($lblStatus, "Awaiting user confirmation")
		Local $message = ""
		$message = $message & @CRLF & "Application: " & $Selection[2] & @CRLF; Display Name
		$message = $message & @CRLF & "Requested Action: " & $ActionTag
		$message = $message & @CRLF & "Registry Key:" & $Selection[1] ; Hive key / guid info...
;~ 		$message = $message & @CRLF & "Version: " & $Selection[1] ; Version
;~ 		$message = $message & @CRLF & "Published by : " & $Selection[1] ; Company
;~ 		$message = $message & @CRLF & "Installed on : " & $Selection[1] ; Install Date

		Local $response = MsgBox(4096 + 32 + 4, "Confirm " & $ActionTag, $message & @CRLF & "Are you sure you want to proceed ?")
		If $response = 6 Then
			GUICtrlSetData($lblStatus, "Executing: " & $ActionTag & " on " & $Selection[2])
			ShellExecuteWait($ActionString)
			If @error Then
				GUICtrlSetData($lblStatus, "There was an error processing " & $ActionTag & " on " & $Selection[2])
			Else
				GUICtrlSetData($lblStatus, $ActionTag & " of " & $Selection[2] & " Completed Successfully ")
			EndIf
			_RefreshList()
		Else
			GUICtrlSetData($lblStatus, "Ready")
		EndIf
	EndIf
EndFunc   ;==>_DoAction

#Region Struggling for icons!!!!

Func __AddIcon2ImageList($imageList, $iconPath)
;~ 	Local $retVal, $tmp_icon
;~ 	$tmp_icon = _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 110)
;~ 	If $tmp_icon = -1 Then
EndFunc   ;==>__AddIcon2ImageList

Func _GetIcon($SoftwareList, $i)
	Local $iconPath[3], $IconFromPath
	If StringStripWS($SoftwareList[$i][8], 8) <> "" Then
;~ 		ConsoleWrite(@CRLF & $SoftwareList[$i][1] & @LF & "  Icon :" & $SoftwareList[$i][8])
		If StringInStr($SoftwareList[$i][8], ",") Then
			$iconPath = StringSplit($SoftwareList[$i][8], ",") ; iconpath[0] will 2 indicating its from regicon path
		Else
			$iconPath[0] = 1 ; type 1 indicates it is from reg icon path
			$iconPath[1] = $SoftwareList[$i][8]
		EndIf
	Else
		If StringStripWS($SoftwareList[$i][10], 8) <> "" Then
;~ 			ConsoleWrite(@CRLF & $SoftwareList[$i][1])
			$IconFromPath = _GetIconFromInstallLocation($SoftwareList, $i, $SoftwareList[$i][10])
			If $IconFromPath <> False Then
				$iconPath[0] = 3 ; type 3 indicates its from install path
				$iconPath[1] = $IconFromPath
				$iconPath[2] = 1
			EndIf
		EndIf
	EndIf
	If Not IsArray($iconPath) Then
		$iconPath[0] = 4 ; type 4 indicates it is derived from windir setup.exe
		$iconPath[1] = @SystemDir & "\setup.exe"
		$iconPath[2] = 0
	EndIf
	If StringStripWS($iconPath[1], 3) = "" Then
		$iconPath[0] = 4 ; type 4 indicates it is derived from windir setup.exe
		$iconPath[1] = @SystemDir & "\setup.exe"
		$iconPath[2] = 0
	EndIf
	Return $iconPath
EndFunc   ;==>_GetIcon

Func _GetIconFromInstallLocation($SoftwareList, $i, $installPath)
	Local $FileFound, $FileAttributes, $FullFilePath
	;Remove the end \ If specified
	If StringRight($installPath, 1) = "\" Then $installPath = StringTrimRight($installPath, 1)
	;ConsoleWrite(@CRLF  & $installPath & @TAB )
	$Search = FileFindFirstFile($installPath & "\*.*")
	While 1
		If $Search = -1 Then ExitLoop
		$FileFound = FileFindNextFile($Search)
		If @error Then ExitLoop
		$FullFilePath = $installPath & "\" & $FileFound
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			;_GetIconFromInstallLocation($SoftwareList,$i ,$FullFilePath)
		Else
			If StringRight($FileFound, 3) = "exe" Then
				If _CheckFileForIcons($SoftwareList, $installPath, $FileFound, $i) = True Then
					Return $FullFilePath
					ExitLoop
				EndIf
			EndIf
		EndIf
	WEnd
	FileClose($Search)
EndFunc   ;==>_GetIconFromInstallLocation

Func _CheckFileForIcons($SoftwareList, $installPath, $FileFound, $i)
	$DisplayName = $SoftwareList[$i][1]
	$installPath = $SoftwareList[$i][10]
;~ 	If StringInStr($installPath,"Nokia") Then ConsoleWrite( @CRLF & $installPath & $FileFound)
	$InternalName = StringStripWS(FileGetVersion($installPath & $FileFound, "InternalName"), 3)
	$ProductName = StringStripWS(FileGetVersion($installPath & $FileFound, "ProductName"), 3)
;~ 	ConsoleWrite(  @TAB & "F " & $FileFound & " I " &$InternalName & " P " &$ProductName )
	Local $retVal = False
	Select
		Case StringLen($InternalName) > 0 And (StringInStr($DisplayName, $InternalName) Or StringInStr($DisplayName, $InternalName))
			;ConsoleWrite(@CRLF & @TAB & "DispName : " & $DisplayName & ",FileName: " & $FileFound & ",IntName:" & $InternalName)
			GUICtrlCreateIcon($installPath & $FileFound, 0, 0, 1, 1)
			If Not @error Then $retVal = True ; ConsoleWrite ( @TAB & "Icon Available")
		Case StringLen($ProductName) > 0 And (StringInStr($DisplayName, $ProductName) Or StringInStr($DisplayName, $ProductName))
			;ConsoleWrite(@CRLF & @TAB & "DispName : " & $DisplayName & ",FileName: " & $FileFound & ",ProdName: " & $ProductName)
			GUICtrlCreateIcon($installPath & $FileFound, 0, 0, 1, 1)
			If Not @error Then $retVal = True ; ConsoleWrite ( @TAB & "Icon Available")
		Case StringInStr($FileFound, $DisplayName) Or StringInStr($DisplayName, $FileFound)
			;ConsoleWrite(@CRLF & @TAB & "DispName : " & $DisplayName & ",FileName: " & $FileFound)
			GUICtrlCreateIcon($installPath & $FileFound, 0, 0, 1, 1)
			If Not @error Then $retVal = True ; ConsoleWrite ( @TAB & "Icon Available")
	EndSelect
	Return $retVal
EndFunc   ;==>_CheckFileForIcons

Func _SetIcon($ControlID, $iconPath)
	Local $tag
;~ 	ConsoleWrite(@CRLF & @TAB & $iconPath[0] & @TAB & $iconPath[1] & "," & $iconPath[2])
	Switch $iconPath[0]
		Case 3 ; for some reason this piece of code isnt working....
			For $j = -1 To 1
				$tag = GUICtrlSetImage($ControlID, Chr(34) & $iconPath[1] & Chr(34), $j)
			Next
		Case 1
			$tag = GUICtrlSetImage($ControlID, $iconPath[1])
		Case Else
			$tag = GUICtrlSetImage($ControlID, $iconPath[1], $iconPath[2])
	EndSwitch
	If $tag = 0 Then
		GUICtrlSetImage($ControlID, @SystemDir & "\Setup.exe", 0)
	EndIf
;~ 	ConsoleWrite(@TAB & $tag)
EndFunc   ;==>_SetIcon

#EndRegion Struggling for icons!!!!

