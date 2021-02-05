#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.0.0
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <IE.au3>
#include <Array.au3>
#include <GUIConstants.au3>
#include <ComboConstants.au3>
#include <GuiComboBox.au3>
#include <GuiTreeView.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

$curSelSite = ""
$lastmin = ""
$enablechecked = ""
$ini = "torrents.ini"

$gui = GUICreate("Torrent Watchdog", 500, 400)
$left = 10
$top = 20
GUICtrlCreateGroup("Site", $left - 10, $top - 19, 320, 350)
$dropdownSitelist = GUICtrlCreateCombo("", $left, $top, 150, -1, $CBS_DROPDOWNLIST)
$checkboxEnable = GUICtrlCreateCheckbox("Enable Site", $left + 170, $top)
$treeviewRuleset = GUICtrlCreateTreeView($left, $top + 35, 300, 250)
$buttonAddRule = GUICtrlCreateButton("Add Rule", $left, $top + 295, 80)
$buttonEditRule = GUICtrlCreateButton("Edit Rule", $left + 85, $top + 295, 80)
$buttonDeleteRule = GUICtrlCreateButton("Delete Rule", $left + 85 + 85, $top + 295, 80)
$left = 370
$top = 40
GUICtrlCreateGroup("Controls", $left - 40, $top - 38, 161, 350)
$buttonCheckNow = GUICtrlCreateButton("Check Torrents", $left - 10, $top, 100, 50)
$checkboxAutoCheck = GUICtrlCreateCheckbox("Auto check", $left - 30, $top + 60)
GUICtrlSetState($checkboxAutoCheck, IniRead($ini, "Settings", "autocheck", $GUI_UNCHECKED))
GUICtrlCreateLabel("every", $left - 30, $top + 93)
GUICtrlCreateLabel("minutes", $left + 45, $top + 93)
$dropdownCheckFreq = GUICtrlCreateCombo("", $left, $top + 90, 40, -1, $CBS_DROPDOWNLIST)
$timer = TimerInit()
$labelNextCheck = GUICtrlCreateLabel("", $left - 30, $top + 120, 150, 20)
$nextvisible = 0
$checkboxVisible = GUICtrlCreateCheckbox("Visible IE Window", $left - 30, $top + 140)
GUICtrlSetState($checkboxVisible, IniRead($ini, "Settings", "visibleIE", $GUI_UNCHECKED))
$a = GetSitelist()
For $i = 1 To $a[0]
	GUICtrlSetData($dropdownSitelist, $a[$i])
Next
_GUICtrlComboBox_SetCurSel($dropdownSitelist, 0)
GUICtrlSetData($dropdownCheckFreq, "1|15|30|45|60")
_GUICtrlComboBox_SetCurSel($dropdownCheckFreq, IniRead($ini, "Settings", "timecheck", 0))
GUICtrlSetState($dropdownSitelist, $GUI_FOCUS)

$guiAdd = GUICreate("Add Rule", 400, 300)
$left = 10
$top = 10
$dropdownSiteListAdd = GUICtrlCreateCombo("", $left, $top, 150, -1, $CBS_DROPDOWNLIST)
For $i = 1 To $a[0]
	GUICtrlSetData($dropdownSiteListAdd, $a[$i])
Next
GUICtrlCreateLabel("Rule Name:", $left + 160, $top + 3)
GUICtrlCreateLabel("Category:", $left + 160, $top + 28)
$inputCategoryAdd = GUICtrlCreateInput("", $left + 160 + 60, $top + 25, 30)
$inputRuleNameAdd = GUICtrlCreateInput("", $left + 160 + 60, $top, 165)
GUICtrlCreateLabel("Include (one per line)", $left + 30, $top + 70)
GUICtrlCreateLabel("Exclude (one per line)", $left + 220, $top + 70)
$editIncludeAdd = GUICtrlCreateEdit("", $left, $top + 90, 190, 150, $ES_MULTILINE + $ES_WANTRETURN)
$editExcludeAdd = GUICtrlCreateEdit("", $left + 220 - 30, $top + 90, 190, 150, $ES_MULTILINE + $ES_WANTRETURN)
$buttonSaveAdd = GUICtrlCreateButton("Add", $left + 220, $top + 260, 80)
$buttonCancelAdd = GUICtrlCreateButton("Cancel", $left + 300, $top + 260, 80)

$guiEdit = GUICreate("Edit Rule", 400, 300)
$left = 10
$top = 10
$dropdownSiteListEdit = GUICtrlCreateCombo("", $left, $top, 150, -1, $CBS_DROPDOWNLIST)
For $i = 1 To $a[0]
	GUICtrlSetData($dropdownSiteListEdit, $a[$i])
Next
GUICtrlCreateLabel("Rule Name:", $left + 160, $top + 3)
GUICtrlCreateLabel("Category:", $left + 160, $top + 28)
$inputCategoryEdit = GUICtrlCreateInput("", $left + 160 + 60, $top + 25, 30)
$inputRuleNameEdit = GUICtrlCreateInput("", $left + 160 + 60, $top, 165)
GUICtrlSetState($inputRuleNameEdit, $GUI_DISABLE)
GUICtrlSetState($dropdownSiteListEdit, $GUI_DISABLE)
GUICtrlCreateLabel("Include (one per line)", $left + 30, $top + 70)
GUICtrlCreateLabel("Exclude (one per line)", $left + 220, $top + 70)
$editIncludeEdit = GUICtrlCreateEdit("", $left, $top + 90, 190, 150, $ES_MULTILINE + $ES_WANTRETURN)
$editExcludeEdit = GUICtrlCreateEdit("", $left + 220 - 30, $top + 90, 190, 150, $ES_MULTILINE + $ES_WANTRETURN)
$buttonSaveEdit = GUICtrlCreateButton("Edit", $left + 220, $top + 260, 80)
$buttonCancelEdit = GUICtrlCreateButton("Cancel", $left + 300, $top + 260, 80)

$trayexit = TrayCreateItem("Exit")
TraySetClick(8)

GUISetState(@SW_SHOW, $gui)
If IniRead($ini, "Settings", "startmin", 0) = 1 Then
	;WinSetState("Torrent Watchdog", "", @SW_HIDE)
EndIf

While 1
	$msg = GUIGetMsg(1)
	Switch $msg[1]
		Case $gui
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					SaveSettings()
					Exit
				Case $GUI_EVENT_MINIMIZE
					WinSetState("Torrent Watchdog", "", @SW_HIDE)
				Case $buttonCheckNow
					StartCheck()
				Case $buttonAddRule
					$a = GetSitelist()
					$b = GUICtrlRead($dropdownSitelist)
					For $i = 1 To $a[0]
						If $a[$i] = $b Then
							_GUICtrlComboBox_SetCurSel($dropdownSiteListAdd, $i - 1)
						EndIf
					Next
					WinSetState("Add Rule", "", @SW_RESTORE)
				Case $buttonEditRule
					$a = GetSitelist()
					$b = GUICtrlRead($dropdownSitelist)
					For $i = 1 To $a[0]
						If $a[$i] = $b Then
							_GUICtrlComboBox_SetCurSel($dropdownSiteListEdit, $i - 1)
						EndIf
					Next
					$sel = _GUICtrlTreeView_GetText($treeviewRuleset, _GUICtrlTreeView_GetSelection($treeviewRuleset))
					If IniRead($ini, $sel, "site", "ERROR") = "ERROR" Then
						MsgBox(0, "Error", "Please select a top-layer item to edit.")
					Else
						GUICtrlSetData($inputCategoryEdit, IniRead($ini, $sel, "category", 0))
						GUICtrlSetData($inputRuleNameEdit, $sel)
						GUICtrlSetData($editIncludeEdit, StringReplace(IniRead($ini, $sel, "include", ""), "|", @CRLF))
						GUICtrlSetData($editExcludeEdit, StringReplace(IniRead($ini, $sel, "exclude", ""), "|", @CRLF))
						WinSetState("Edit Rule", "", @SW_RESTORE)
					EndIf
			EndSwitch
		Case $guiAdd
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					WinSetState("Add Rule", "", @SW_HIDE)
				Case $buttonCancelAdd
					WinSetState("Add Rule", "", @SW_HIDE)
			EndSwitch
		Case $guiEdit
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					WinSetState("Edit Rule", "", @SW_HIDE)
				Case $buttonCancelEdit
					MsgBox(0, "", "")
					WinSetState("Edit Rule", "", @SW_HIDE)
				Case $buttonSaveEdit
					IniWrite($ini, $sel, "category", GUICtrlRead($inputCategoryEdit))
					IniWrite($ini, $sel, "include", StringReplace(GUICtrlRead($editIncludeEdit), @CRLF, "|"))
					IniWrite($ini, $sel, "exclude", StringReplace(GUICtrlRead($editExcludeEdit), @CRLF, "|"))
					WinSetState("Edit Rule", "", @SW_HIDE)
			EndSwitch
	EndSwitch
	$msg = TrayGetMsg()
	Switch $msg
		Case $TRAY_EVENT_PRIMARYUP
			WinSetState("Torrent Watchdog", "", @SW_SHOW)
			WinSetState("Torrent Watchdog", "", @SW_RESTORE)
		Case $trayexit
			SaveSettings()
			Exit
	EndSwitch
	If GUICtrlRead($dropdownSitelist) <> $curSelSite Then
		$curSelSite = GUICtrlRead($dropdownSitelist)
		PopTreeview($curSelSite)
		If IniRead($ini, "SITE:" & $curSelSite, "enabled", 0) = 1 Then
			GUICtrlSetState($checkboxEnable, $GUI_CHECKED)
			$enablechecked = $GUI_CHECKED
		Else
			GUICtrlSetState($checkboxEnable, $GUI_UNCHECKED)
			$enablechecked = $GUI_UNCHECKED
		EndIf
	EndIf
	If GUICtrlRead($checkboxEnable) <> $enablechecked And $curSelSite = GUICtrlRead($dropdownSitelist) Then
		IniWrite($ini, "SITE:" & $curSelSite, "enabled", GUICtrlRead($checkboxEnable))
	EndIf
	If GUICtrlRead($checkboxAutoCheck) = $GUI_CHECKED Then
		If $lastmin <> GetTimeDiff() Or $nextvisible = 0 Then
			GUICtrlSetData($labelNextCheck, "Next check in " & GetTimeDiff() & " minutes")
			TraySetToolTip("Next check in " & GetTimeDiff() & " minutes")
			$lastmin = GetTimeDiff()
			$nextvisible = 1
		EndIf
		If GetTimeDiff() <= 0 Then
			StartCheck()
		EndIf
	Else
		GUICtrlSetData($labelNextCheck, "")
		$nextvisible = 0
	EndIf
WEnd

Func StartCheck()
	SaveSettings()
	$a = GetSitelist()
	For $i = 1 To $a[0]
		If IniRead($ini, "SITE:" & $a[$i], "enabled", 0) = 1 Then
			CheckTorrents(IniRead($ini, "SITE:" & $a[$i], "browse", ""), IniRead($ini, "SITE:" & $a[$i], "start", ""))
		EndIf
	Next
EndFunc   ;==>StartCheck

Func GetTimeDiff()
	Return Round((GUICtrlRead($dropdownCheckFreq) * 1000 * 60 - TimerDiff($timer)) / 1000 / 60, 2)
EndFunc   ;==>GetTimeDiff

Func GetSitelist()
	$b = ""
	$a = IniReadSectionNames($ini)
	For $i = 1 To $a[0]
		If StringInStr($a[$i], "SITE:") Then
			$b = $b & StringReplace($a[$i], "SITE:", "") & "|"
		EndIf
	Next
	Return StringSplit(StringTrimRight($b, 1), "|")
EndFunc   ;==>GetSitelist

Func PopTreeview($site)
	_GUICtrlTreeView_DeleteAll($treeviewRuleset)
	$a = IniReadSectionNames($ini)
	For $i = 1 To $a[0]
		If IniRead($ini, $a[$i], "site", "ERROR") = $curSelSite Then
			$ruleitem = GUICtrlCreateTreeViewItem($a[$i], $treeviewRuleset)
			GUICtrlCreateTreeViewItem("Category: " & IniRead($ini, $a[$i], "category", 0), $ruleitem)
			GUICtrlCreateTreeViewItem("Include: " & IniRead($ini, $a[$i], "include", "ERROR: No INCLUDE strings found"), $ruleitem)
			GUICtrlCreateTreeViewItem("Exclude: " & IniRead($ini, $a[$i], "exclude", ""), $ruleitem)
		EndIf
	Next
	_GUICtrlTreeView_Sort($treeviewRuleset)
EndFunc   ;==>PopTreeview

Func CheckTorrents($site, $startlink)
	TraySetToolTip("Currently checking torrents...")
	Switch GUICtrlRead($checkboxVisible)
		Case $GUI_CHECKED
			$visible = 1
		Case $GUI_UNCHECKED
			$visible = 0
	EndSwitch
	$ie = _IECreate($site, 1, $visible, 1, 0)
	$links = _IELinkGetCollection($ie)
	$s = ""
	$x = 0
	For $oLink In $links
		If StringInStr($oLink.href, $startlink) Then $x = 1
		If $x = 1 And (StringInStr($oLink.href, "?cat=") Or StringInStr($oLink.href, "download.php")) Then
			$s = $s & $oLink.href & ","
		EndIf
	Next
	$s = StringSplit($s, ",")
	IniWrite($ini, "Grabbed", "none", 1)
	$rules = IniReadSectionNames($ini)
	For $i = 1 To $s[0] Step 2
		If $i = $s[0] Then ExitLoop
		For $j = 1 To $rules[0]
			If $rules[$j] = "Grabbed" Then ContinueLoop
			$cat = IniRead($ini, $rules[$j], "category", 0)
			$include = StringSplit(IniRead($ini, $rules[$j], "include", "*"), "|")
			$exclude = StringSplit(IniRead($ini, $rules[$j], "exclude", "*"), "|")
			$grabbed = IniReadSection($ini, "Grabbed")
			If $cat <> 0 And StringReplace($s[$i], $site & "?cat=", "") <> $cat Then ContinueLoop
			For $k = 1 To $include[0]
				If Not StringInStr($s[$i + 1], $include[$k]) Then ContinueLoop (2)
			Next
			For $k = 1 To $exclude[0]
				If StringInStr($s[$i + 1], $exclude[$k]) Then ContinueLoop (2)
			Next
			For $k = 1 To $grabbed[0][0]
				If $s[$i + 1] = $grabbed[$k][0] Then ContinueLoop (2)
			Next
			$m = 6
			If $m = 6 Or $m = -1 Then
				$size = InetGetSize($s[$i + 1])
				InetGet($s[$i + 1])
				ShellExecute($s[$i + 1])
				IniWrite($ini, "Grabbed", $s[$i + 1], "1")
			EndIf
		Next
	Next
	_IEQuit($ie)
	$timer = TimerInit()
	TraySetToolTip()
EndFunc   ;==>CheckTorrents

Func SaveSettings()
	IniWrite($ini, "Settings", "autocheck", GUICtrlRead($checkboxAutoCheck))
	IniWrite($ini, "Settings", "timecheck", _GUICtrlComboBox_GetCurSel($dropdownCheckFreq))
	IniWrite($ini, "Settings", "visibleIE", GUICtrlRead($checkboxVisible))
EndFunc   ;==>SaveSettings
