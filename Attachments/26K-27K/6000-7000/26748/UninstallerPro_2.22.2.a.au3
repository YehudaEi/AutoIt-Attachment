#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\vrr.ico
#AutoIt3Wrapper_Outfile=UninstallerPro.exe
#AutoIt3Wrapper_Res_Description=A Convinient and fast uninstaller interface...
#AutoIt3Wrapper_Res_Fileversion=2.22.2
#AutoIt3Wrapper_Res_LegalCopyright=rajeshwithsoftware at gmail dot com
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf 1 /striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ChangeLog (v1.13 &  later only)
; v2.22.2 just code cleanup...
; v2.22.1 refined icon search , more comprehensive search and fixed a lot of icon bugs. (was able to add only few more icons, though :-( )
; v2.21.1 sort and icons being sorted out..
; v2.20.1 few missing icons were due to fourth subitem added - sorted
; v2.19.1--13 June 2009========================================
; Minor update - now listview change monitoring occurs only if the window is active!
; code cleanup again!
; v2.18.1--13 June 2009 ========================================
; great step ahead - as planned now adding list view change event control!! - not using WM_Notify (will switch to wm command later probably..)
; minor version will remain the same, major version changed to reflect milestone!!!
; v1.17--11 June 2009 ========================================
;Sort order stuff fixed (more or less!)
;v 1.16--10 June 2009 ==========================================
; more code cleanup, now icon changing deletes the control & brings it back (save icon space bug)
; v1.14--09 June 2009 ===========================================
; more code cleanup
; important validity of searching icons changed to use a dummy control rather than actual gui (causes flicker not easily noticed)
; sort list is a seperate function for ease of usage.
; v 1.13--08 June 2009 ========================================
; general minor gui modifications , sort / show updates checkboxes
; version info available in title bar now
; to make it best for novice users, hidden software wont be shown! - hidden software put pending for advanced verison due some time later..
#EndRegion ChangeLog (v1.13 &  later only)
;

#include <File.au3>
#include <String.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <comboConstants.au3>
#include <WindowsConstants.au3>
#include <_EnumInstalledSoftware_UDF9.au3>
#include <array.au3>

Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

Global $AppTitle, $AppVersion = ""

$AppTitle = "Uninstaller Pro by vrr"
$AppVersion = _GetAPPVersion()
If StringLen($AppVersion) > 0 Then $AppTitle = StringReplace($AppTitle, " by vrr", " (v" & $AppVersion & ") by vrr")

Global $lstViewSoftware


#Region ### START Koda GUI section ###

Dim $frmMain = GUICreate($AppTitle, 606, 609, 196, 133)
GUISetBkColor(0xFFFFFF, $frmMain)
GUISetOnEvent($GUI_EVENT_CLOSE, "frmMainClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "frmMainMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "frmMainMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "frmMainRestore")

Dim $lstViewSoftware = _CreateListView()

Dim $chkLoadIcons, $chkShowUpdates
$chkShowUpdates = GUICtrlCreateCheckbox("Show Software Updates", 120, 25, 150, 18)
GUICtrlSetOnEvent(-1, "chkShowUpdatesClick")
$chkLoadIcons = GUICtrlCreateCheckbox("Load Program Icons", 280, 25, 137, 18)
GUICtrlSetOnEvent(-1, "chkLoadIconsClick")

Dim $lblSortOrder, $cboSortOrder
$lblSortOrder = GUICtrlCreateLabel("Sort by:", 423, 28, 40, 20)
$cboSortOrder = GUICtrlCreateCombo("", 470, 25, 125, 19, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Title (Ascending)|Title (Descending)|Publisher (Ascending)|Publisher (Descending)", "Title (Ascending)")
GUICtrlSetOnEvent(-1, "cboSortOrderClick")

Dim $lblListBoxTitle, $lblStatus, $lblDispOptions
$lblListBoxTitle = GUICtrlCreateLabel("", 20, 58, 400, 17)
$lblStatus = GUICtrlCreateLabel("Ready", 12, 578, 580, 17)
$lblDispOptions = GUICtrlCreateLabel("Display Options", 20, 25, 77, 18)


Dim $btnRefresh, $btnChange, $btnQuietUninst, $btnRemove
$btnRefresh = GUICtrlCreateButton("Refresh", 46, 530, 110, 30, 0)
GUICtrlSetOnEvent(-1, "_RefreshList")
$btnChange = GUICtrlCreateButton("Modify (Change)", 232, 530, 110, 30, 0)
GUICtrlSetOnEvent(-1, "btnChangeClick")
$btnRemove = GUICtrlCreateButton("Uninstall (Remove)", 352, 530, 110, 30, 0)
GUICtrlSetOnEvent(-1, "btnRemoveClick")
$btnQuietUninst = GUICtrlCreateButton("Silent Uninstall", 473, 530, 110, 30, 0)
GUICtrlSetOnEvent(-1, "btnQuietUninstClick")

GUISetState(@SW_SHOW)

#EndRegion ### END Koda GUI section ###
;

_GetSoftwareList()
_PopulateListView()
_SortList()
_lstViewSoftware_SelectionChanged()

Dim $LVI_Mark = _GUICtrlListView_GetSelectionMark($lstViewSoftware)

While 1
	Sleep(250)
	If WinActive($AppTitle) Then
		If _GUICtrlListView_SelectionChanged($LVI_Mark, $lstViewSoftware) Then
			_lstViewSoftware_SelectionChanged()
		EndIf
	EndIf
WEnd

#Region GUI Related Functions

Func _CreateListView()
	Local $iExWindowStyle = $WS_EX_CLIENTEDGE ;BitOR($WS_EX_DLGMODALFRAME, $WS_EX_CLIENTEDGE)
	Local $iExListViewStyle = BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_DOUBLEBUFFER)
	$lstViewSoftware = GUICtrlCreateListView("Name|Version|Company", 12, 92, 585, 325, -1, $iExWindowStyle)
	_GUICtrlListView_SetExtendedListViewStyle($lstViewSoftware, $iExListViewStyle)
	_GUICtrlListView_SetColumnWidth(-1, 0, 235)
	_GUICtrlListView_SetColumnWidth(-1, 1, 85)
	_GUICtrlListView_SetColumnWidth(-1, 2, 235)
	GUICtrlSetOnEvent(-1, "lstSoftwareClick")
	_GUICtrlListView_RegisterSortCallBack(-1, False, False)
	Return $lstViewSoftware
EndFunc   ;==>_CreateListView
#EndRegion GUI Related Functions


#Region EventHandlers

Func _GUICtrlListView_SelectionChanged(ByRef $CurrentMark, $LV_CtrlID)
	; Author Rajesh VR , June 2009
	Local $oldMark = $CurrentMark
	Local $NewMark = _GUICtrlListView_GetSelectionMark($LV_CtrlID)
	If $CurrentMark <> $NewMark Then
		$CurrentMark = $NewMark
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_GUICtrlListView_SelectionChanged

Func btnChangeClick()
	Local $Selection = _GetSelectedItem()
	_DoAction($Selection, $btnChange)
EndFunc   ;==>btnChangeClick

Func btnQuietUninstClick()
	Local $Selection = _GetSelectedItem()
	_DoAction($Selection, $btnQuietUninst)
EndFunc   ;==>btnQuietUninstClick

Func btnRemoveClick()
	Local $Selection = _GetSelectedItem()
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

Func lstSoftwareClick()
	Local $tmp = _GetSelectedItem()
	If GUICtrlGetState($lstViewSoftware) <> 1 Then
		If GUICtrlGetState($lstViewSoftware) = 0 Then
			_SetSortOrder(1)
		EndIf
		If GUICtrlGetState($lstViewSoftware) = 2 Then
			_SetSortOrder(3)
		EndIf
		_SortList()
	EndIf
EndFunc   ;==>lstSoftwareClick

Func cboSortOrderClick()
	_SortList()
EndFunc   ;==>cboSortOrderClick

Func _lstViewSoftware_SelectionChanged()
	Local $Selection = _GetSelectedItem()
	If StringStripWS($Selection[5], 3) = "" Then
		GUICtrlSetState($btnChange, $GUI_DISABLE)
	Else
		GUICtrlSetState($btnChange, $GUI_ENABLE)
	EndIf
	If StringStripWS($Selection[3], 3) = "" Then
		GUICtrlSetState($btnRemove, $GUI_DISABLE)
	Else
		GUICtrlSetState($btnRemove, $GUI_ENABLE)
	EndIf
	If StringStripWS($Selection[4], 3) = "" Then
		GUICtrlSetState($btnQuietUninst, $GUI_DISABLE)
	Else
		GUICtrlSetState($btnQuietUninst, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_lstViewSoftware_SelectionChanged

#EndRegion EventHandlers
;

#Region OtherFunctions

Func _RefreshList()
	_PopulateListView(@GUI_CtrlId)
	_SortList()
EndFunc   ;==>_RefreshList

Func _GetSoftwareList()
	Local $retVal = _Enum_InstalledApps(GUICtrlRead($chkShowUpdates))
;~ 	REDim $retVal[
;~ 	For $i = 1 to
	Return $retVal
EndFunc   ;==>_GetSoftwareList

Func _GetSelectedItem()
	Local $retVal[13]
	Local $LVI_selected = StringSplit(GUICtrlRead(GUICtrlRead($lstViewSoftware)), "|")
	Local $SoftwareList = _GetSoftwareList()
	For $i = 0 To $SoftwareList[0][0]
		If $SoftwareList[$i][1] = $LVI_selected[1] And $SoftwareList[$i][2] = $LVI_selected[2] And $SoftwareList[$i][4] = $LVI_selected[3] Then
			$retVal[00] = $i
			$retVal[01] = $SoftwareList[$i][0] ; GUID or registry hive path - even if the display name is changed, this is bound to stay permanent
			$retVal[02] = $SoftwareList[$i][1] ; DisplayName
			$retVal[03] = $SoftwareList[$i][3] ; uninstallstring
			$retVal[04] = $SoftwareList[$i][11] ; QuietUninstallString
			$retVal[05] = $SoftwareList[$i][6] ; ModifyPath
			$retVal[06] = $SoftwareList[$i][7] ; NoRemoveTag
			$retVal[07] = $SoftwareList[$i][5] ; NoModifyPtag
			$retVal[08] = $SoftwareList[$i][9] ; IsHidden
			$retVal[09] = $SoftwareList[$i][8] ; display icon.
			$retVal[10] = $SoftwareList[$i][13] ; UpdateIdentifier Parent
			$retVal[11] = $SoftwareList[$i][2] ; Version
			$retVal[12] = $SoftwareList[$i][4] ; CompanyName
		EndIf
	Next
	Return $retVal
EndFunc   ;==>_GetSelectedItem
;

Func _SetPreviousSelection($lastSelection)
	Local $SoftwareList = _GetSoftwareList()
	For $i = 0 To $SoftwareList[0][0]
		If $SoftwareList[$i][0] = $lastSelection[1] And $SoftwareList[$i][0] = $lastSelection[11] And $SoftwareList[$i][0] = $lastSelection[12] Then
			_GUICtrlListView_SetItemSelected($lstViewSoftware, $i - 1, True, True)
		EndIf
	Next
EndFunc   ;==>_SetPreviousSelection
;

Func _PopulateListView($GUI_CtrlID = 0)
	Local $iconPath[3], $SoftwareList, $colWidth[3], $LVItem
	Local $SoftwareList = _GetSoftwareList()
	$colWidth[0] = _GUICtrlListView_GetColumnWidth($lstViewSoftware, 0)
	$colWidth[1] = _GUICtrlListView_GetColumnWidth($lstViewSoftware, 1)
	$colWidth[2] = _GUICtrlListView_GetColumnWidth($lstViewSoftware, 2)
	
	If $GUI_CtrlID = $chkLoadIcons Or $GUI_CtrlID = $btnRefresh Or $GUI_CtrlID = $chkShowUpdates Then
		GUICtrlDelete($lstViewSoftware)
		$lstViewSoftware = _CreateListView()
		If $GUI_CtrlID = $chkShowUpdates Then _GUICtrlListView_BeginUpdate($lstViewSoftware)
	Else
		_GUICtrlListView_DeleteAllItems($lstViewSoftware)
		_GUICtrlListView_BeginUpdate($lstViewSoftware)
		GUICtrlSetState($lstViewSoftware, $GUI_HIDE)
	EndIf
	
;~ 	there is plans in future to use GUICtrlListView_AddArray but icons would be a little tough - once icons are sorted , will use GUIImageList for icons...
	For $i = 1 To $SoftwareList[0][0]
		$LVItem = GUICtrlCreateListViewItem($SoftwareList[$i][1] & "|" & $SoftwareList[$i][2] & "|" & $SoftwareList[$i][4], $lstViewSoftware)
		If GUICtrlRead($chkLoadIcons) = 1 Then
			$iconPath = _GetIcon($SoftwareList, $i)
			_SetIcon($LVItem, $iconPath)
		EndIf
	Next
	_GUICtrlListView_SetColumnWidth($lstViewSoftware, 0, $colWidth[0])
	_GUICtrlListView_SetColumnWidth($lstViewSoftware, 1, $colWidth[1])
	_GUICtrlListView_SetColumnWidth($lstViewSoftware, 2, $colWidth[2])
	GUICtrlSetState($lstViewSoftware, $GUI_SHOW)
	_GUICtrlListView_EndUpdate($lstViewSoftware)
	If GUICtrlRead($chkShowUpdates) = 1 Then
		GUICtrlSetData($lblListBoxTitle, "Showing Installed applications and updates (" & $SoftwareList[0][0] & " Titles Found )")
	Else
		GUICtrlSetData($lblListBoxTitle, "Showing Installed applications (" & $SoftwareList[0][0] & " Titles Found )")
	EndIf
EndFunc   ;==>_PopulateListView
;

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

		Local $response = MsgBox(4096 + 32 + 4, "Confirm " & $ActionTag, $message & @CRLF & "Are you sure you want to proceed ?")
		If $response = 6 Then
			GUICtrlSetData($lblStatus, "Executing: " & $ActionTag & " on " & $Selection[2])
			RunWait($ActionString)
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
;

Func _CreateMenuControl()
;~ 	$mnuUninstOptions = GUICtrlCreateContextMenu($lstViewSoftware)
EndFunc   ;==>_CreateMenuControl
;

Func _GetAPPVersion()
	; author rajesh v r
	Local $retVal
	If @Compiled Then
		$retVal = FileGetVersion(@ScriptFullPath, "FileVersion")
	Else
		Local $ScriptFileHandle, $Line
		$ScriptFileHandle = FileOpen(@ScriptFullPath, 0)
		If $ScriptFileHandle = -1 Then
			SetError(@error, "File Could not be opened for reading")
			$retVal = ""
		Else
			While 1
				$Line = FileReadLine($ScriptFileHandle)
				If StringInStr($Line, "#AutoIt3Wrapper_Res_Fileversion=") Then
					If Not StringInStr($Line, "StringInStr($Line,") Then
						$retVal = StringTrimLeft(StringStripWS($Line, 3), 32)
						ExitLoop
					EndIf
					If StringInStr($Line, "#EndRegion") Then ExitLoop
					If @error = -1 Then ExitLoop
				EndIf
			WEnd
		EndIf
	EndIf
	Return $retVal
EndFunc   ;==>_GetAPPVersion

#EndRegion OtherFunctions
;

#Region Struggling for icons!!!!

Func _GetIcon($SoftwareList, $i)
	; next level try to browse through program files folder to check if folder name = displayname, that will get a few more icons.


	
	Local $iconPath[3], $iconFromPath
	
	If StringStripWS($SoftwareList[$i][8], 8) <> "" Then
		If StringInStr($SoftwareList[$i][8], ",") Then
			$iconPath = StringSplit($SoftwareList[$i][8], ",") ; iconpath[0] will 2 indicating its from regicon path
		Else
			$iconPath[0] = 1 ; type 1 indicates it is from reg icon path
			$iconPath[1] = $SoftwareList[$i][8]
		EndIf
		
	Else
		
		If StringStripWS($SoftwareList[$i][10], 8) <> "" Then ; iconpath is empty or specified icon file not found
			
			$iconFromPath = _GetIconFromInstallLocation($SoftwareList, $i, $SoftwareList[$i][10], "Normal")
			
			
			If $iconFromPath = False Then
				
				$iconFromPath = _GetIconFromInstallLocation($SoftwareList, $i, $SoftwareList[$i][10], "Extended")
				
			EndIf
			
			
			If $iconFromPath <> False Then
				$iconPath[0] = 3 ; type 3 indicates its from install path
				$iconPath[1] = FileGetShortName($iconFromPath) ; be careful when using on remote pcs....
				$iconPath[2] = -1
			EndIf
		EndIf
	EndIf
	
	
	If IsArray($iconPath) = 0 Or StringStripWS($iconPath[1], 3) = "" Then
		$iconPath[0] = 4 ; type 4 indicates it is derived from windir setup.exe
		$iconPath[1] = @SystemDir & "\setup.exe"
		$iconPath[2] = 0
	EndIf
	
	Return $iconPath
EndFunc   ;==>_GetIcon

Func _GetIconFromInstallLocation($SoftwareList, $i, $installPath, $iMode)
	Local $FileFound, $FileAttributes, $FullFilePath, $Found = False
	;Remove the end \ If specified
	If StringRight($installPath, 1) = "\" Then $installPath = StringTrimRight($installPath, 1)
	
	Local $Search = FileFindFirstFile($installPath & "\*.*")
	
	While 1
		If $Search = -1 Then ExitLoop
		
		$FileFound = FileFindNextFile($Search)
		
		If @error Then ExitLoop
		
		$FullFilePath = $installPath & "\" & $FileFound
		$FileAttributes = FileGetAttrib($FullFilePath)
;~ 		If StringInStr($FileFound, "Google") Then ConsoleWrite(@CRLF & @TAB & $FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			_GetIconFromInstallLocation($SoftwareList, $i, $FullFilePath, $iMode) ; this will make it more time consuming...
		Else
			If StringRight($FileFound, 3) = "exe" Then
				Switch $iMode
					Case "Normal"
						If _CheckFileForIcons($SoftwareList, $installPath, $FileFound, $i) = True Then
							$Found = True
							Return $FullFilePath
							ExitLoop
						EndIf
					Case "Extended"
						
						
						If _CheckFileForIconsEx($SoftwareList, $installPath, $FileFound, $i) Then
							$Found = True
							Return $FullFilePath
							ExitLoop
						EndIf
						
						
						If _CheckFileForIconsExt($SoftwareList, $installPath, $FileFound, $i) Then
							$Found = True
							Return $FullFilePath
							ExitLoop
						EndIf
						
				EndSwitch
			EndIf
		EndIf

	WEnd
	FileClose($Search)
	If $Found = False Then Return False
EndFunc   ;==>_GetIconFromInstallLocation

Func _CheckFileForIcons($SoftwareList, $installPath, $FileFound, $i)
	
	Local $DisplayName = $SoftwareList[$i][1]
;~ 	Local $installPath = $SoftwareList[$i][10]
	
	Local $InternalName = StringStripWS(FileGetVersion($installPath & "\" & $FileFound, "InternalName"), 3)
	
	
	
	Local $ProductName = StringStripWS(FileGetVersion($installPath & "\" & $FileFound, "ProductName"), 3)
	
	
	Local $retVal = False
	Select
		Case StringLen($InternalName) > 0 And (StringInStr($DisplayName, $InternalName) Or StringInStr($DisplayName, $InternalName))

			GUICtrlCreateIcon($installPath & "\" & $FileFound, 0, 0, 1, 1)
			If Not @error Then $retVal = True

		Case StringLen($ProductName) > 0 And (StringInStr($DisplayName, $ProductName) Or StringInStr($DisplayName, $ProductName))

			GUICtrlCreateIcon($installPath & "\" & $FileFound, 0, 0, 1, 1)
			If Not @error Then $retVal = True

	EndSelect
	
	
	Return $retVal
EndFunc   ;==>_CheckFileForIcons

Func _CheckFileForIconsEx($SoftwareList, $installPath, $FileFound, $i)
	Local $retVal = False, $DisplayName = $SoftwareList[$i][1]
	If StringInStr($FileFound, $DisplayName) Or StringInStr($DisplayName, $FileFound) Then
		GUICtrlCreateIcon($installPath & "\" & $FileFound, 0, 0, 1, 1)
		If Not @error Then $retVal = True
	EndIf
	
	Return $retVal
EndFunc   ;==>_CheckFileForIconsEx

Func _CheckFileForIconsExt($SoftwareList, $installPath, $FileFound, $i)
	Local $retVal = False
	If StringInStr($FileFound, "Google") Then ConsoleWrite(@CRLF & @TAB & " _IconsExt Called ")
	; exclude uninst files then use any file publised by the company to check for icons !!
	; of course this can cause wrong icon to display sometimes but the probability is low , lets go for it then!
	Local $PublisherName = StringStripWS($SoftwareList[$i][4], 3)
	Local $CompanyName = StringStripWS(FileGetVersion($installPath & "\" & $FileFound, "CompanyName"), 3)
	
	If StringLen($CompanyName) > 0 And (StringInStr($CompanyName, $PublisherName) Or StringInStr($PublisherName, $CompanyName)) Then
		GUICtrlCreateIcon($installPath & "\" & $FileFound, 0, 0, 1, 1)
		If Not @error Then $retVal = True
	EndIf
	Return $retVal
EndFunc   ;==>_CheckFileForIconsExt

Func _SetIcon($ControlID, $iconPath)
;~ 	ConsoleWrite(@CRLF & $iconPath[1])
	Local $tag
	Switch $iconPath[0]
		Case 3
			$tag = GUICtrlSetImage($ControlID, $iconPath[1])
		Case 1
			$tag = GUICtrlSetImage($ControlID, $iconPath[1])
		Case Else
			$tag = GUICtrlSetImage($ControlID, $iconPath[1], $iconPath[2])
	EndSwitch
;~ 	ConsoleWrite(@TAB & $tag)
	If $tag = 0 Then
		GUICtrlSetImage($ControlID, @SystemDir & "\Setup.exe", 0)
	EndIf
;~ 	ConsoleWrite(" " & GUICtrlRead($ControlID) & @TAB & $tag)
EndFunc   ;==>_SetIcon

#EndRegion Struggling for icons!!!!
;

#Region Sort Functions

Func _SetSortOrder($SortOrder = 1)
	GUICtrlSetData($cboSortOrder, "")
	Local $SortOptions = "Title (Ascending)|Title (Descending)|Publisher (Ascending)|Publisher (Descending)"
	Switch $SortOrder
		Case 1
			GUICtrlSetData($cboSortOrder, $SortOptions, "Title (Ascending)")
		Case 2
			GUICtrlSetData($cboSortOrder, $SortOptions, "Title (Descending)")
		Case 3
			GUICtrlSetData($cboSortOrder, $SortOptions, "Publisher (Ascending)")
		Case 4
			GUICtrlSetData($cboSortOrder, $SortOptions, "Publisher (Descending)")
		Case Else
			GUICtrlSetData($cboSortOrder, $SortOptions, "Title (Ascending)")
	EndSwitch
EndFunc   ;==>_SetSortOrder

Func _SortList()
	Switch GUICtrlRead($cboSortOrder)
		Case "Title (Ascending)"
			If _GetSortOrder() = -1 Or _GetSortHeader() <> 0 Then _GUICtrlListView_SortItems($lstViewSoftware, 0)
			If _GetSortOrder() = -1 Or _GetSortHeader() <> 0 Then _GUICtrlListView_SortItems($lstViewSoftware, 0) ; a recheck coz sortorder isnt changed?
		Case "Title (Descending)"
			If _GetSortOrder() = 1 Or _GetSortHeader() <> 0 Then _GUICtrlListView_SortItems($lstViewSoftware, 0)
			If _GetSortOrder() = 1 Or _GetSortHeader() <> 0 Then _GUICtrlListView_SortItems($lstViewSoftware, 0)
		Case "Publisher (Ascending)"
			If _GetSortOrder() = -1 Or _GetSortHeader() <> 2 Then _GUICtrlListView_SortItems($lstViewSoftware, 2)
			If _GetSortOrder() = -1 Or _GetSortHeader() <> 2 Then _GUICtrlListView_SortItems($lstViewSoftware, 2)
		Case "Publisher (Descending)"
			If _GetSortOrder() = 1 Or _GetSortHeader() <> 2 Then _GUICtrlListView_SortItems($lstViewSoftware, 2)
			If _GetSortOrder() = 1 Or _GetSortHeader() <> 2 Then _GUICtrlListView_SortItems($lstViewSoftware, 2)
	EndSwitch
EndFunc   ;==>_SortList

Func _GetSortHeader()
;~ 	thanks to melba23 , detected sort order from http://www.autoitscript.com/forum/index.php?showtopic=93951&view=findpost&p=675235
	Return $aListViewSortInfo[$aListViewSortInfo[0][0]][3]
EndFunc   ;==>_GetSortHeader

Func _GetSortOrder()
;~ 	thanks to melba23 , detected sort order from http://www.autoitscript.com/forum/index.php?showtopic=93951&view=findpost&p=675235
	Return $aListViewSortInfo[$aListViewSortInfo[0][0]][5] ; sortorder (1 = ascending, -1 =  descending)
EndFunc   ;==>_GetSortOrder

#EndRegion Sort Functions
;;### Tidy Error -> func is never closed in your script.