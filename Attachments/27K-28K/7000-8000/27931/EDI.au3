#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <GuiComboBox.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ListviewConstants.au3>
#include <WinAPI.au3>
#include <GuiEdit.au3>
#include <GuiListView.au3>
#include <GuiTab.au3>
#include <Constants.au3>
#include <SendMessage.au3>
#include <FontConstants.au3>
#include <Misc.au3>
Opt("MustDeclareVars", 1)
Opt("ExpandEnvStrings", 1)

; Registry keys we use throughout the script
Global Const $sHKCR = "HKCR\CLSID\"
Global Const $sHKCU = "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\"
Global Const $sDefIcon = "\DefaultIcon\"
Global Const $sShell = "\Shell\"
Global Const $sCMD = "\Command\"
Global Const $sShFld = "\ShellFolder"
Global Const $sTag = "EDI_Created_Icon" ;Tag every NameSpace Key that's created. Check for it before removing any entries
Global Const $sInfo = "InfoTip"
Global Const $sAttr = "Attributes"

; Button text depending on what we're doing at any given time
Global Const $sLoadPreset = '|----> Load Preset <----|'
Global Const $sClear = "Clear All Fields"
Global Const $sCancel = "Cancel Edit"
Global Const $sUpdate = "Update Icon Now!"
Global Const $sCreate = "Create New Icon Now!"

; Save our Presets here
Global $sIni = @ScriptDir & "\EDIPresets.ini"

; Default paths for the ComboBox Presets (used in $aCombo array)
Global $sAutoItIcon = "HKLM\SOFTWARE\AutoIt v3\AutoIt"
Global $sHD = @HomeDrive & "\", $sWD = @WindowsDir & "\", $sSD = @SystemDir & "\"
Global $sUrl = $sSD & 'Rundll32.exe Url,FileProtocolHandler http://www.autoitscript.com/forum/index.php?'

If StringInStr("X64IA64", @OSArch) Then $sAutoItIcon = StringReplace($sAutoItIcon, "SOFTWARE", "SOFTWARE\Wow6432Node")
$sAutoItIcon = RegRead($sAutoItIcon, "InstallDir") & "\Icons\au3.ico,0"

; ComboBox array of Presets _LoadPreset() uses this array.
Global $aCombo[5][4] = [[$sLoadPreset], _
		['AutoIt Forum', 'Go to AutoIt Forum', $sAutoItIcon, 'Forum Index|' & $sUrl & Chr(0) & 'Example Scripts|' & $sUrl & 'showforum=9' & Chr(0) & 'General Help and Support|' & $sUrl & 'showforum=2'], _
		['Command Prompt', 'Open Command Prompt', $sSD & 'cmd.exe,0', $sHD & '>|cmd.exe /k cd ' & $sHD & Chr(0) & $sWD & '>|cmd.exe /k cd ' & $sWD & Chr(0) & $sSD & '>|cmd.exe /k cd ' & $sSD], _
		['Computer Management', 'Manage components of my pc.', $sSD & 'mycomput.dll,2', 'Manage|' & $sSD & 'mmc.exe compmgmt.msc /s' & Chr(0) & 'Services|' & $sSD & 'mmc.exe services.msc /s' & Chr(0) & 'Event Viewer|' & $sSD & 'mmc.exe eventvwr.msc /s'], _
		['Explorer', 'Open Explorer', $sWD & 'explorer.exe,0', $sHD & '|explorer.exe /e,' & $sHD & Chr(0) & $sWD & '|explorer.exe /e,' & $sWD & Chr(0) & $sSD & '|explorer.exe /e,' & $sSD]]

; Use this when editing an installed icon, _Create() function checks it to see if it should edit or create new.
; A few other functions check it as well along the way so they know to edit or create new.
Global $sUUID

; Gui and control variables
Global $iAppW = 598, $iAppH = 382
Global $hGui, $aInput[4] = ["Name:", "Info Tip:", "Icon File:"], $iW = 390, $iBrowse, $iIcon, $aContext1[1], $iLabel, $iLV1
Global $iClear, $iCreate, $aTab[3] = [0, "Edit", "Uninstall"], $iLV2
Global $Msg, $iCombo, $iSave, $iDelete
Global $aContext2[4] = [0, "Add New Item", "", "Delete Selected"], $aContext3[2] = [0, "Uninstall Selected"]

; Default Width of LV columns (header width is default), _SetColumnLV() sets and uses these arrays
Global $aDefWidthLV1, $aDefWidthLV2

; These are only set by LV1 double click for in place edit. _KillEditLV() will check and set them back again
Global $hEdit, $hFont, $Item = -1, $SubItem = 0

; Used for dragging items in $iLV1
Global $iDrag = -1

; On XP the listview I notice the in place edit that the text was chopped off (height wise bottom).
; I check this flag when creating the edit control.
; So if I'm in XP/2003/2000 then I set the font a touch smaller in the edit control on the listview.
; It seems to be fine in Win 7 so I don't set the font smaller, not sure about Vista, but I'll treat Vista the same as Win 7 until I know otherwise.
Global $iOS_Flag = StringInStr("WIN_2003,WIN_XP,WIN_2000", @OSVersion)

; Checks for an Ini, if it finds one it'll update the $aCombo array
_LoadEDIPresets()

$hGui = GUICreate("Enhanced Desktop Icons", $iAppW, $iAppH, -1, -1, $WS_OVERLAPPEDWINDOW)

$aTab[0] = GUICtrlCreateTab(5, 5, 590, 372)
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

; >>>> Edit tab
$aTab[1] = GUICtrlCreateTabItem($aTab[1])

; Icon Details
GUICtrlCreateGroup("Icon Details", 15, 35, 460, 100)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
For $i = 0 To 2
	GUICtrlCreateLabel($aInput[$i], 25, (25 * $i) + 55, 45, 20, $BS_CENTER)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKSIZE, $GUI_DOCKTOP))
	If $i = 2 Then $iW = 365
	$aInput[$i] = GUICtrlCreateInput("", 75, (25 * $i) + 55, $iW, 20)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKHEIGHT, $GUI_DOCKTOP))
Next
GUICtrlSetStyle($aInput[2], $ES_READONLY)
GUICtrlSetBkColor($aInput[2], 0xFFFFFF)
$iBrowse = GUICtrlCreateButton("...", 445, (25 * $i) + 30, 20, 20)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKSIZE, $GUI_DOCKTOP))
GUICtrlSetTip(-1, "Browse for an icon to use")

; Preview Icon
GUICtrlCreateGroup("Icon Preview", 485, 35, 100, 100)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKSIZE, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
$iIcon = GUICtrlCreateIcon("", 0, 519, (25 * $i) - 23, 32, 32)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKSIZE, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
$aContext1[0] = GUICtrlCreateContextMenu($iIcon)
$iLabel = GUICtrlCreateLabel("", 495, (25 * $i) + 11, 80, 40, $SS_CENTER)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKSIZE, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))

; Context Menu ListView
GUICtrlCreateGroup("Context Menu", 15, 140, 570, 165)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKBOTTOM))
$iLV1 = GUICtrlCreateListView("Item Text|Item Command", 25, 160, 550, 133, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKBOTTOM))
GUICtrlSetTip(-1, "Right Click to Add or Delete Items." & @LF & "Double Click an item Text or Command to edit it." & @LF & "Drag an item to move it Up or Down." & @LF)
$aDefWidthLV1 = _SetColumnLV($iLV1, 1)
$aContext2[0] = GUICtrlCreateContextMenu($iLV1)
For $i = 1 To UBound($aContext2) - 1
	$aContext2[$i] = GUICtrlCreateMenuItem($aContext2[$i], $aContext2[0])
Next

; Load/save/delete Presets ComboBox
GUICtrlCreateGroup("Presets", 15, 310, 320, 56)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))
$iCombo = GUICtrlCreateCombo($aCombo[0][0], 25, 332, 130, 20, $CBS_DROPDOWNLIST)
For $i = 0 To UBound($aCombo, 1) - 1
	GUICtrlSetData($iCombo, $aCombo[$i][0], $aCombo[0][0])
Next
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))
$iSave = GUICtrlCreateButton("Save Preset", 165, 329, 75, 25)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))
$iDelete = GUICtrlCreateButton("Delete Preset", 250, 329, 75, 25)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))

; Clear & Create
GUICtrlCreateGroup("Clear/Cancel or Create/Update", 345, 310, 240, 56)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))
$iClear = GUICtrlCreateButton($sClear, 355, 329, 85, 25)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))
$iCreate = GUICtrlCreateButton($sCreate, 450, 329, 125, 25)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKSIZE, $GUI_DOCKBOTTOM))

; >>>> Uninstall Tab
$aTab[2] = GUICtrlCreateTabItem($aTab[2])

; Installed Icons Listview
GUICtrlCreateGroup("Installed Icons", 15, 35, 570, 332)
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
$iLV2 = GUICtrlCreateListView("Name|Info Tip|Icon File|First Context Item Text & Command|GUID", 25, 55, 550, 300, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
GUICtrlSetTip(-1, "Right Click to Uninstall selected items." & @LF & "Double Click an Item to send it to the Edit tab.")
$aDefWidthLV2 = _SetColumnLV($iLV2, 1)
$aContext3[0] = GUICtrlCreateContextMenu($iLV2)
$aContext3[1] = GUICtrlCreateMenuItem($aContext3[1], $aContext3[0])
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW, $hGui)

; Make it so the GUI won't be able to be resized smaller then it's original starting size. Cheers to Martin.
$iAppW = _WinAPI_GetWindowWidth($hGui)
$iAppH = _WinAPI_GetWindowHeight($hGui)
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			_SaveEDIPresets(1)
		Case $GUI_EVENT_RESIZED, $GUI_EVENT_MAXIMIZE, $GUI_EVENT_RESTORE
			_KillEditLV()
			_SetColumnLV($iLV1)
			_SetColumnLV($iLV2)
		Case $aTab[0]
			_TabHit()
		Case $iBrowse
			_Browse()
		Case $aContext2[1] ;Add New Item context menu
			_AddNewItem()
		Case $aContext2[3] ;Delete Selected context menu
			_DeleteItems()
		Case $iCombo ;Preset ComboBox
			_LoadPreset()
		Case $iSave
			_SavePreset()
		Case $iDelete
			_DeletePreset()
		Case $iClear
			_ClearAllFields()
		Case $iCreate
			_Create()
		Case $aContext3[1] ;Uninstall Selected context menu
			_UninstallSelected()
		Case Else ;Keep the buttons Enabled/Disabled or Text on a button set to whatever mode
			_SetButtonState()
			_DragItem()
	EndSwitch
WEnd

Func _TabHit()
	Local $aHT, $hTab = GUICtrlGetHandle($aTab[0])
	_KillEditLV()
	$aHT = _GUICtrlTab_HitTest($hTab, _WinAPI_GetMousePosX(True, $hTab), _WinAPI_GetMousePosY(True, $hTab))
	If $aHT[0] = 1 Then _LoadUninstall()
EndFunc   ;==>_TabHit

Func _Browse()
	_KillEditLV()
	Local $sGCR, $aPID
	$sGCR = GUICtrlRead($aInput[2])
	$aPID = _PickIconDialog($hGui, StringLeft($sGCR, StringInStr($sGCR, ",", 0, -1) - 1))
	If Not @error Then
		GUICtrlSetData($aInput[2], $aPID[0] & "," & $aPID[1])
		_SetIcon($iIcon, GUICtrlRead($aInput[2]))
	EndIf
EndFunc   ;==>_Browse

Func _AddNewItem()
	_KillEditLV()
	GUICtrlCreateListViewItem("New Text|New Command", $iLV1)
	_SetColumnLV($iLV1)
EndFunc   ;==>_AddNewItem

Func _ContextPreview()
	Local $i, $iCnt
	$iCnt = _GUICtrlListView_GetItemCount($iLV1)
	If UBound($aContext1) > 1 Then
		For $i = 1 To UBound($aContext1) - 1
			GUICtrlDelete($aContext1[$i])
		Next
		ReDim $aContext1[1]
	EndIf
	If UBound($aContext1) <= 1 And $iCnt Then
		ReDim $aContext1[$iCnt + 3]
		For $i = 0 To $iCnt - 1
			$aContext1[$i + 1] = GUICtrlCreateMenuItem(_GUICtrlListView_GetItemText($iLV1, $i), $aContext1[0])
		Next
		$aContext1[$i + 1] = GUICtrlCreateMenuItem("", $aContext1[0])
		$aContext1[$i + 2] = GUICtrlCreateMenuItem("Create Shortcut", $aContext1[0])
	EndIf
EndFunc   ;==>_ContextPreview

Func _DeleteItems()
	_KillEditLV()
	_GUICtrlListView_DeleteItemsSelected($iLV1)
	_SetColumnLV($iLV1)
	_ContextPreview()
EndFunc   ;==>_DeleteItems

Func _LoadPreset()
	Local $sGCR = GUICtrlRead($iCombo), $i, $aSS3, $j
	For $i = 1 To UBound($aCombo, 1) - 1
		If $sGCR = $aCombo[$i][0] Then
			GUICtrlSetData($aInput[0], $aCombo[$i][0])
			GUICtrlSetData($aInput[1], $aCombo[$i][1])
			GUICtrlSetData($aInput[2], $aCombo[$i][2])
			_SetIcon($iIcon, $aCombo[$i][2])
			_GUICtrlListView_DeleteAllItems($iLV1)
			$aSS3 = StringSplit($aCombo[$i][3], Chr(0), 2)
			For $j = 0 To UBound($aSS3) - 1
				GUICtrlCreateListViewItem($aSS3[$j], $iLV1)
			Next
			_SetColumnLV($iLV1)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_LoadPreset

Func _SavePreset()
	Local $iIdx, $iCnt, $i, $sTxt
	$iIdx = _GUICtrlComboBox_FindStringExact($iCombo, GUICtrlRead($aInput[0]))
	If $iIdx = -1 Then
		$iIdx = UBound($aCombo, 1)
		ReDim $aCombo[$iIdx + 1][4]
	EndIf
	If $iIdx > 0 Then
		$aCombo[$iIdx][0] = GUICtrlRead($aInput[0])
		$aCombo[$iIdx][1] = GUICtrlRead($aInput[1])
		$aCombo[$iIdx][2] = GUICtrlRead($aInput[2])
		$aCombo[$iIdx][3] = ''
		$iCnt = _GUICtrlListView_GetItemCount($iLV1) - 1
		For $i = 0 To $iCnt
			$sTxt = _GUICtrlListView_GetItemTextString($iLV1, $i)
			If $i < $iCnt Then
				$aCombo[$iIdx][3] &= $sTxt & Chr(0)
			Else
				$aCombo[$iIdx][3] &= $sTxt
			EndIf
		Next
		_SaveEDIPresets()
		GUICtrlSetData($iCombo, $aCombo[$iIdx][0], $aCombo[$iIdx][0])
	EndIf
EndFunc   ;==>_SavePreset

Func _DeletePreset()
	Local $iIdx
	$iIdx = _GUICtrlComboBox_GetCurSel($iCombo)
	If $iIdx > 0 Then
		$aCombo[$iIdx][0] = ""
		_GUICtrlComboBox_DeleteString($iCombo, $iIdx)
		GUICtrlSetData($iCombo, $aCombo[0][0], $aCombo[0][0])
		FileDelete($sIni)
		_SaveEDIPresets()
		_LoadEDIPresets()
	EndIf
EndFunc   ;==>_DeletePreset

Func _SaveEDIPresets($iExit = 0)
	Local $i, $iCnt, $j, $aSS3
	For $i = 1 To UBound($aCombo, 1) - 1
		If $aCombo[$i][0] <> "" Then
			$iCnt += 1
			IniDelete($sIni, "PRESET" & $iCnt)
			IniWrite($sIni, "PRESET" & $iCnt, "Name", $aCombo[$i][0])
			IniWrite($sIni, "PRESET" & $iCnt, "Infotip", $aCombo[$i][1])
			IniWrite($sIni, "PRESET" & $iCnt, "IconFile", $aCombo[$i][2])
			$aSS3 = StringSplit($aCombo[$i][3], Chr(0))
			For $j = 1 To $aSS3[0]
				IniWrite($sIni, "PRESET" & $iCnt, "Context" & $j, $aSS3[$j])
			Next
		EndIf
	Next
	If $iExit Then Exit
EndFunc   ;==>_SaveEDIPresets

Func _LoadEDIPresets()
	Local $aIRSN, $i, $aIRS, $j
	$aIRSN = IniReadSectionNames($sIni)
	If @error Then Return SetError(1, 0, 0)
	Dim $aCombo[$aIRSN[0] + 1][4]
	$aCombo[0][0] = $sLoadPreset
	For $i = 1 To $aIRSN[0]
		$aIRS = IniReadSection($sIni, $aIRSN[$i])
		If Not @error Then
			For $j = 1 To $aIRS[0][0]
				If $j <= 3 Then
					$aCombo[$i][$j - 1] = $aIRS[$j][1]
				ElseIf $j > 3 And $j < $aIRS[0][0] Then
					$aCombo[$i][3] &= $aIRS[$j][1] & Chr(0)
				ElseIf $j = $aIRS[0][0] Then
					$aCombo[$i][3] &= $aIRS[$j][1]
				EndIf
			Next
		EndIf
	Next
EndFunc   ;==>_LoadEDIPresets

Func _ClearAllFields()
	Local $i
	For $i = 0 To 2
		GUICtrlSetData($aInput[$i], "")
	Next
	_GUICtrlListView_DeleteAllItems($iLV1)
	_SetColumnLV($iLV1)
	GUICtrlSetData($iCombo, $aCombo[0][0])
	_ContextPreview()
	$sUUID = ""
EndFunc   ;==>_ClearAllFields

Func _Create()
	Local $sName, $sTip, $sIconIdx, $sGUID
	_KillEditLV()
	$sName = GUICtrlRead($aInput[0])
	$sTip = GUICtrlRead($aInput[1])
	$sIconIdx = GUICtrlRead($aInput[2])
	If $sUUID <> "" Then
		$sGUID = $sUUID
		RegDelete($sHKCR & $sGUID & $sShell)
	Else
		$sGUID = _UuidCreate()
	EndIf
	RegWrite($sHKCR & $sGUID, "", "REG_SZ", $sName)
	RegWrite($sHKCR & $sGUID, $sInfo, "REG_SZ", $sTip)
	RegWrite($sHKCR & $sGUID & $sDefIcon, "", "REG_SZ", $sIconIdx)
	For $i = 0 To _GUICtrlListView_GetItemCount($iLV1) - 1
		RegWrite($sHKCR & $sGUID & $sShell & $i, "", "REG_SZ", _GUICtrlListView_GetItemText($iLV1, $i))
		RegWrite($sHKCR & $sGUID & $sShell & $i & $sCMD, "", "REG_SZ", _GUICtrlListView_GetItemText($iLV1, $i, 1))
	Next
	RegWrite($sHKCR & $sGUID & $sShFld, $sAttr, "REG_BINARY", 0)
	RegWrite($sHKCU & $sGUID, "", "REG_SZ", $sTag)
	_RefreshDesktop()
	_ClearAllFields()
EndFunc   ;==>_Create

Func _SendToEditTab($sGUID)
	Local $i, $sKey
	GUICtrlSetData($aInput[0], RegRead($sHKCR & $sGUID, ""))
	GUICtrlSetData($aInput[1], RegRead($sHKCR & $sGUID, $sInfo))
	GUICtrlSetData($aInput[2], RegRead($sHKCR & $sGUID & $sDefIcon, ""))
	_GUICtrlListView_DeleteAllItems($iLV1)
	While 1
		$i += 1
		$sKey = RegEnumKey($sHKCR & $sGUID & $sShell, $i)
		If @error Then ExitLoop
		GUICtrlCreateListViewItem(RegRead($sHKCR & $sGUID & $sShell & $sKey, "") & "|" & RegRead($sHKCR & $sGUID & $sShell & $sKey & $sCMD, ""), $iLV1)
	WEnd
	_SetColumnLV($iLV1)
	$sUUID = $sGUID
	GUICtrlSetData($iCombo, $aCombo[0][0])
	GUICtrlSetState($aTab[1], $GUI_SHOW)
	_ContextPreview()
EndFunc   ;==>_SendToEditTab

Func _UninstallSelected()
	Local $sGUID, $iCnt
	If _GUICtrlListView_GetSelectedCount($iLV2) Then
		$iCnt = _GUICtrlListView_GetItemCount($iLV2)
		For $i = $iCnt - 1 To 0 Step -1
			If _GUICtrlListView_GetItemSelected($iLV2, $i) Then
				$sGUID = _GUICtrlListView_GetItemText($iLV2, $i, 4)
				If $sUUID = $sGUID Then $sUUID = ""
				RegDelete($sHKCR & $sGUID)
				RegDelete($sHKCU & $sGUID)
				_GUICtrlListView_DeleteItem($iLV2, $i)
			EndIf
		Next
		_SetColumnLV($iLV2)
		_RefreshDesktop()
	EndIf
EndFunc   ;==>_UninstallSelected

Func _UninstallAll()
	Local $i, $sGUID, $sTmp, $aGUID
	If _GUICtrlListView_GetItemCount($iLV2) Then
		While 1
			$i += 1
			$sGUID = RegEnumKey($sHKCU, $i)
			If @error Then ExitLoop
			If RegRead($sHKCU & $sGUID, "") = $sTag Then $sTmp &= $sGUID & "|"
		WEnd
		$aGUID = StringSplit(StringTrimRight($sTmp, 1), "|", 2)
		For $i = 0 To UBound($aGUID) - 1
			RegDelete($sHKCR & $aGUID[$i])
			RegDelete($sHKCU & $aGUID[$i])
		Next
		_GUICtrlListView_DeleteAllItems($iLV2)
		_SetColumnLV($iLV2)
		$sUUID = ""
		_RefreshDesktop()
	EndIf
EndFunc   ;==>_UninstallAll

Func _SetButtonState()
	Local $iCnt1, $iCnt2, $iSelCnt1, $iSelCnt2, $sName, $sTip, $sIconIdx, $sConTxt, $sConCmd, $i, $iState = $GUI_ENABLE
;~ 	$iCnt1 = _GUICtrlListView_GetItemCount($iLV1)
;~ 	$iCnt2 = _GUICtrlListView_GetItemCount($iLV2)
	$iSelCnt1 = _GUICtrlListView_GetSelectedCount($iLV1)
	$iSelCnt2 = _GUICtrlListView_GetSelectedCount($iLV2)
	$sName = GUICtrlRead($aInput[0])
	$sTip = GUICtrlRead($aInput[1])
	$sIconIdx = GUICtrlRead($aInput[2])
	$sConTxt = _GUICtrlListView_GetItemText($iLV1, 0)
	$sConCmd = _GUICtrlListView_GetItemText($iLV1, 0, 1)
	If ($sName <> "") And ($sIconIdx <> "") And ($sConTxt <> "") And ($sConCmd <> "") Then
		If Not BitAND(GUICtrlGetState($iSave), $GUI_ENABLE) Then GUICtrlSetState($iSave, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($iCreate), $GUI_ENABLE) Then GUICtrlSetState($iCreate, $GUI_ENABLE)
	Else
		If Not BitAND(GUICtrlGetState($iSave), $GUI_DISABLE) Then GUICtrlSetState($iSave, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($iCreate), $GUI_DISABLE) Then GUICtrlSetState($iCreate, $GUI_DISABLE)
	EndIf
	If ($sName = "") And ($sIconIdx = "") And ($sTip = "") And Not $iCnt1 Then
		If Not BitAND(GUICtrlGetState($iClear), $GUI_DISABLE) Then GUICtrlSetState($iClear, $GUI_DISABLE)
	Else
		If Not BitAND(GUICtrlGetState($iClear), $GUI_ENABLE) Then GUICtrlSetState($iClear, $GUI_ENABLE)
	EndIf
	If GUICtrlRead($iCombo) = $aCombo[0][0] Then
		If Not BitAND(GUICtrlGetState($iDelete), $GUI_DISABLE) Then GUICtrlSetState($iDelete, $GUI_DISABLE)
	Else
		If Not BitAND(GUICtrlGetState($iDelete), $GUI_ENABLE) Then GUICtrlSetState($iDelete, $GUI_ENABLE)
	EndIf
	If $sUUID = "" Then
		If GUICtrlRead($iClear) = $sCancel Then GUICtrlSetData($iClear, $sClear)
		If GUICtrlRead($iCreate) = $sUpdate Then GUICtrlSetData($iCreate, $sCreate)
	Else
		If GUICtrlRead($iClear) = $sClear Then GUICtrlSetData($iClear, $sCancel)
		If GUICtrlRead($iCreate) = $sCreate Then GUICtrlSetData($iCreate, $sUpdate)
	EndIf
	If $iSelCnt1 Then
		If Not BitAND(GUICtrlRead($aContext2[3]), $GUI_ENABLE) Then GUICtrlSetState($aContext2[3], $GUI_ENABLE)
	Else
		If Not BitAND(GUICtrlRead($aContext2[3]), $GUI_DISABLE) Then GUICtrlSetState($aContext2[3], $GUI_DISABLE)
	EndIf
	If $iSelCnt2 Then
		If Not BitAND(GUICtrlRead($aContext3[1]), $GUI_ENABLE) Then GUICtrlSetState($aContext3[1], $GUI_ENABLE)
	Else
		If Not BitAND(GUICtrlRead($aContext3[1]), $GUI_DISABLE) Then GUICtrlSetState($aContext3[1], $GUI_DISABLE)
	EndIf
EndFunc   ;==>_SetButtonState

Func _DragItem()
	Local $aHT, $sDrag, $sHit, $i, $sOp = "+1"
	If $iDrag > -1 Then
		While _IsPressed("01")
			Sleep(10)
		WEnd
		$aHT = _GUICtrlListView_HitTest(GUICtrlGetHandle($iLV1))
		If $aHT[0] <> -1 And $aHT[0] <> $iDrag Then
			$sDrag = _GUICtrlListView_GetItemTextString($iLV1, $iDrag)
			$sHit = _GUICtrlListView_GetItemTextString($iLV1, $aHT[0])
			If $iDrag > $aHT[0] Then $sOp = "-1"
			For $i = $iDrag To $aHT[0] Step $sOp
				GUICtrlSetData(_GUICtrlListView_GetItemParam($iLV1, $i), _GUICtrlListView_GetItemTextString($iLV1, Execute($i & $sOp)))
			Next
			GUICtrlSetData(_GUICtrlListView_GetItemParam($iLV1, $aHT[0]), $sDrag)
			_GUICtrlListView_SetItemSelected($iLV1, $iDrag, False)
			_GUICtrlListView_SetItemSelected($iLV1, $aHT[0])
		EndIf
		$iDrag = -1
	EndIf
EndFunc   ;==>_DragItem

Func _SetColumnLV($iCID, $iFlag = 0)
	Local $iCnt1, $iCnt2, $i, $aRet, $iCW, $j, $iLen1, $iLen2, $aDefW
	$iCnt1 = _GUICtrlListView_GetItemCount($iCID)
	$iCnt2 = _GUICtrlListView_GetColumnCount($iCID)
	If $iFlag Then
		Dim $aRet[$iCnt2]
		$iCW = $LVSCW_AUTOSIZE_USEHEADER
	EndIf
	If $iCID = $iLV1 Then
		$aDefW = $aDefWidthLV1
	Else
		$aDefW = $aDefWidthLV2
	EndIf
	For $i = 0 To $iCnt2 - 1
		If Not $iFlag Then
			For $j = 0 To $iCnt1 - 1
				$iLen2 = _GUICtrlListView_GetStringWidth($iCID, _GUICtrlListView_GetItemText($iCID, $j, $i))
				If $iLen1 < $iLen2 Then $iLen1 = $iLen2
			Next
			If $iLen1 < $aDefW[$i] Then
				$iCW = $LVSCW_AUTOSIZE_USEHEADER
			Else
				$iCW = $LVSCW_AUTOSIZE
			EndIf
		EndIf
		_GUICtrlListView_SetColumnWidth($iCID, $i, $iCW)
		If $iFlag Then $aRet[$i] = _GUICtrlListView_GetColumnWidth($iCID, $i)
	Next
	If $iFlag Then Return $aRet
EndFunc   ;==>_SetColumnLV

Func _KillEditLV()
	Local $sEdText, $sLV1Txt
	If $hEdit <> 0 Then
		$sEdText = _GUICtrlEdit_GetText($hEdit)
		If $sEdText <> "" Then
			_GUICtrlListView_SetItemText($iLV1, $Item, $sEdText, $SubItem)
			_SetColumnLV($iLV1)
			If Not $SubItem Then _ContextPreview()
		EndIf
		If $hFont Then _WinAPI_DeleteObject($hFont)
		_WinAPI_DestroyWindow($hEdit)
		$Item = -1
		$SubItem = 0
		$hFont = 0
		$hEdit = 0
	EndIf
EndFunc   ;==>_KillEditLV

Func _LoadUninstall()
	Local $i, $sGUID, $sIconIdx, $sFile, $iIndex, $sKey, $sLV2_Info, $iInList, $iCID
	While 1
		$i += 1
		$sGUID = RegEnumKey($sHKCU, $i)
		If @error Then ExitLoop
		If RegRead($sHKCU & $sGUID, "") = $sTag Then
			$sIconIdx = RegRead($sHKCR & $sGUID & $sDefIcon, "")
			$sFile = StringLeft($sIconIdx, StringInStr($sIconIdx, ",", 0, -1) - 1)
			$iIndex = Int(StringTrimLeft($sIconIdx, StringInStr($sIconIdx, ",", 0, -1)))
			If $iIndex <> 0 Then $iIndex = -($iIndex + 1)
			$sKey = RegEnumKey($sHKCR & $sGUID & $sShell, 1)
			If @error Then
				$sKey = "Error: No first entry found!"
			Else
				$sKey = RegRead($sHKCR & $sGUID & $sShell & $sKey, "") & " & " & RegRead($sHKCR & $sGUID & $sShell & $sKey & $sCMD, "")
			EndIf
			$sLV2_Info = RegRead($sHKCR & $sGUID, "") & "|" & RegRead($sHKCR & $sGUID, $sInfo) & "|" & $sIconIdx & "|" & $sKey & "|" & $sGUID
			$iInList = _GUICtrlListView_FindInText($iLV2, $sGUID, -1)
			If $iInList = -1 Then
				GUICtrlCreateListViewItem($sLV2_Info, $iLV2)
				GUICtrlSetImage(-1, $sFile, $iIndex)
			Else
				$iCID = _GUICtrlListView_GetItemParam($iLV2, $iInList)
				GUICtrlSetData($iCID, $sLV2_Info)
				GUICtrlSetImage($iCID, $sFile, $iIndex)
			EndIf
		EndIf
	WEnd
	_SetColumnLV($iLV2)
EndFunc   ;==>_LoadUninstall

Func _PickIconDialog($hWnd, $sFile)
	Local $tIcon, $tString, $aResult, $aReturn[2]
	$tIcon = DllStructCreate("int")
	$tString = DllStructCreate("wchar[260]")
	DllStructSetData($tString, 1, $sFile)
	$aResult = DllCall("shell32.dll", "int", "PickIconDlg", "hwnd", $hWnd, "ptr", DllStructGetPtr($tString), "int", 260, "ptr", DllStructGetPtr($tIcon))
	If @error Then Return SetError(@error, 0, "")
	$aReturn[0] = DllStructGetData($tString, 1)
	$aReturn[1] = DllStructGetData($tIcon, 1)
	Return SetError($aResult[0] <> 1, 0, $aReturn)
EndFunc   ;==>_PickIconDialog

Func _UuidCreate()
	Local $tGUID, $aReturn
	$tGUID = DllStructCreate($tagGUID)
	$aReturn = DllCall("rpcrt4.dll", "int", "UuidCreate", "ptr", DllStructGetPtr($tGUID))
	If @error Then Return SetError(@error, 0, 0)
	Return SetError($aReturn[0], 0, _WinAPI_StringFromGUID($aReturn[1]))
EndFunc   ;==>_UuidCreate

Func _SetIcon($iCID, $sIconIdx = "")
	Local Const $STM_SETIMAGE = 0x0172
	Local $sFile, $iIndex, $aRet, $hIcon = 0, $hOldIcon = 0
	If $sIconIdx <> "" Then
		$sFile = StringLeft($sIconIdx, StringInStr($sIconIdx, ",", 0, -1) - 1)
		$iIndex = Int(StringTrimLeft($sIconIdx, StringInStr($sIconIdx, ",", 0, -1)))
		$aRet = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sFile, 'int', $iIndex, 'int', 32, 'int', 32, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
		If Not @error Then $hIcon = $aRet[5]
	EndIf
	$hOldIcon = GUICtrlSendMsg($iCID, $STM_SETIMAGE, $IMAGE_ICON, $hIcon)
	If $hOldIcon Then _WinAPI_DestroyIcon($hOldIcon)
EndFunc   ;==>_SetIcon

Func _RefreshDesktop()
	Local Const $SHCNE_ASSOCCHANGED = 0x8000000
	Local Const $SHCNF_IDLIST = 0x0
	DllCall("shell32.dll", "int", "SHChangeNotify", "int", $SHCNE_ASSOCCHANGED, "int", $SHCNF_IDLIST, "ptr", 0, "ptr", 0)
	If @error Then Return SetError(@error, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>_RefreshDesktop

Func WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	Local $tMaxinfo
	$tMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
	DllStructSetData($tMaxinfo, 7, $iAppW)
	DllStructSetData($tMaxinfo, 8, $iAppH)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_GETMINMAXINFO

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode, $hInput1, $hInput2, $hInput3
	$hInput1 = GUICtrlGetHandle($aInput[0])
	$hInput2 = GUICtrlGetHandle($aInput[1])
	$hInput3 = GUICtrlGetHandle($aInput[2])
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hInput1
			_KillEditLV()
			Switch $iCode
				Case $EN_CHANGE
					GUICtrlSetData($iLabel, GUICtrlRead($aInput[0]))
			EndSwitch
		Case $hInput2
			_KillEditLV()
			Switch $iCode
				Case $EN_CHANGE
					GUICtrlSetTip($iIcon, GUICtrlRead($aInput[1]))
			EndSwitch
		Case $hInput3
			_KillEditLV()
			Switch $iCode
				Case $EN_UPDATE
					_SetIcon($iIcon, GUICtrlRead($aInput[2]))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hLV1, $hLV2, $aHT, $iSubItemText, $aRect, $iW
	$hLV1 = GUICtrlGetHandle($iLV1)
	$hLV2 = GUICtrlGetHandle($iLV2)
	$tNMHDR = DllStructCreate("hwnd hWndFrom;int_ptr IDFrom;int Code", $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hLV1
			Switch $iCode
				Case $LVN_BEGINDRAG
					$aHT = _GUICtrlListView_SubItemHitTest($hLV1)
					If $aHT[0] <> -1 Then
						$iDrag = $aHT[0]
						For $i = 0 To _GUICtrlListView_GetItemCount($iLV1) - 1
							If $i <> $iDrag Then _GUICtrlListView_SetItemSelected($iLV1, $i, False)
						Next
						_GUICtrlListView_SetItemSelected($iLV1, $iDrag)
					EndIf
				Case $NM_SETFOCUS, $LVN_BEGINSCROLL, $LVN_ITEMCHANGED
					_KillEditLV()
				Case $NM_DBLCLK
					$aHT = _GUICtrlListView_SubItemHitTest($hLV1)
					If $aHT[0] <> -1 Then
						$Item = $aHT[0]
						$SubItem = $aHT[1]
						$iSubItemText = _GUICtrlListView_GetItemText($hLV1, $Item, $SubItem)
						$aRect = _GUICtrlListView_GetSubItemRect($hLV1, $Item, $SubItem)
						$iW = _GUICtrlListView_GetColumnWidth($hLV1, $aHT[1]) - 8
						$hEdit = _GUICtrlEdit_Create($hLV1, $iSubItemText, $aRect[0] + 4, $aRect[1], $iW, $aRect[3] - $aRect[1], BitOR($WS_CHILD, $WS_VISIBLE, $ES_AUTOHSCROLL, $ES_LEFT))
						If $iOS_Flag Then
							$hFont = _WinAPI_CreateFont(12, 0, 0, 0, 400, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, 'Arial')
							_WinAPI_SetFont($hEdit, $hFont)
						EndIf
						_GUICtrlEdit_SetSel($hEdit, 0, -1)
						_WinAPI_SetFocus($hEdit)
					EndIf
				Case $LVN_INSERTITEM
					_ContextPreview()
				Case $NM_RCLICK
					_SetButtonState()
			EndSwitch
		Case $hLV2
			Switch $iCode
				Case $NM_DBLCLK
					$aHT = _GUICtrlListView_HitTest($hLV2)
					If $aHT[0] <> -1 Then _SendToEditTab(_GUICtrlListView_GetItemText($hLV2, $aHT[0], 4))
				Case $NM_RCLICK
					_SetButtonState()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY