#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=CC.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=2.3.3.0
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Alexander Samuelsson (AdmiralAlkex at the AutoIt forums)

 Script Function:
	Enabled/Disables DirectShow filters
	Set buffers for ffdshow

 ToDo:
	Gather anonymous statistics? (To know the optimal array size and such?) (array removed, so concentrate on "such")
	Automatic updater?

 Known bugs/"bugs":
	*The "live search inputs" get EN_SETFOCUS sent when the window is restored, but only occasionally, not always (intended or bug in AutoIt? Should I do something about it?).
		*Why this happens: Unknown, a reproducer failed to reproduce this.
	*FilteredListview is not 100% fool proof (but it probably is 99%, so should I bother with it?)   (may be fixed with 2.2.3, someone good at logic check?)

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include "AutoItObject.au3"
#include "oLinkedList.au3"
#include "_RegFunc.au3"
#include "GUICtrlHyperLink.au3"

If Not _AutoItObject_Startup(False) Then Exit _CW("AutoItObject failed to start")

Global $odX86, $odX64
Global $ofX86, $ofX64

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", (@Compiled = False))
Opt("GUIResizeMode", $GUI_DOCKALL)
If Not @Compiled Then Opt("TrayIconHide", 0)

Global Const $sDisDShow = ":"   ;Same as used by other tools
Global $hTab, $hGUI

_CreateGui()

Func _CreateGui()

	$hGUI = GUICreate(StringTrimRight(@ScriptName, 4), 542, 540, 0, 0, BitOr($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX))   ;Epic one liner was here

	GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")

	$hTab = GUICtrlCreateTab(2, 2, 540, 538)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)


	$odX86 = _DirectShowFilters()
	If @OSVersion = "WIN_2000" Then   ;If you have Windows 2000
		$odX86.SetUp("DirectShow Filters (x86)", "HKLM\SOFTWARE\Classes\CLSID\{083863F1-70DE-11D0-BD40-00A0C911CE86}\Instance\", "_UnregisterCallBackX86")
	Else
		$odX86.SetUp("DirectShow Filters (x86)", "HKLM32\SOFTWARE\Classes\CLSID\{083863F1-70DE-11D0-BD40-00A0C911CE86}\Instance\", "_UnregisterCallBackX86")
	EndIf

	GUICtrlCreateButton("Reload list", 335, 26, 100, 40)
	GUICtrlSetOnEvent(-1, "_DShowReloadX86")
	GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	GUICtrlCreateButton("Enable/Disable selected codec", 335, 70, 200, 40)
	GUICtrlSetOnEvent(-1, "_DShowButtonCodecX86")
	GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)


	If @OSArch = "X64" Then   ;We are only interested in x64 filters if we are on a x64 OS
		$odX64 = _DirectShowFilters()
		$odX64.SetUp("DirectShow Filters (x64)", "HKLM64\SOFTWARE\Classes\CLSID\{083863F1-70DE-11d0-BD40-00A0C911CE86}\Instance\", "_UnregisterCallBackX64")

		GUICtrlCreateButton("Reload list", 335, 26, 100, 40)
		GUICtrlSetOnEvent(-1, "_DShowReloadX64")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
		GUICtrlCreateButton("Enable/Disable selected codec", 335, 70, 200, 40)
		GUICtrlSetOnEvent(-1, "_DShowButtonCodecX64")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	EndIf


	If @OSArch = "IA64" Then _CW("Not sure what to do with IA64, contact me and we'll figure something out")


	If @OSVersion = "WIN_2000" Then   ;If you have Windows 2000
		$ofX86 = _ffdshow("ffdshow tryouts (x86)", "HKCU\Software\GNU\ffdshow\", "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ffdshow_is1")
	Else
		$ofX86 = _ffdshow("ffdshow tryouts (x86)", "HKCU32\Software\GNU\ffdshow\", "HKLM32\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ffdshow_is1")
	EndIf
	If IsObj($ofX86) Then   ;If x86 version of ffdshow installed
		GUICtrlSetOnEvent($ofX86.ComboId, "_ffdshowComboX86")

		GUICtrlSetOnEvent($ofX86.InputId +1, "_ffdshowButtonX86")   ;Cheatin' for life

		$ofX86.BuildPresets()
		$ofX86.UpdateQueueStatus()
	EndIf


	$ofX64 = _ffdshow("ffdshow tryouts (x64)", "HKCU32\Software\GNU\ffdshow64\", "HKLM64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ffdshow64_is1")
	If IsObj($ofX64) Then   ;If x64 version of ffdshow installed
		GUICtrlSetOnEvent($ofX64.ComboId, "_ffdshowComboX64")

		GUICtrlSetOnEvent($ofX64.InputId +1, "_ffdshowButtonX64")   ;Cheatin' for life

		$ofX64.BuildPresets()
		$ofX64.UpdateQueueStatus()
	EndIf


	_CreateAbout()


	GUICtrlCreateTabItem("")
	GUISetState()
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
	GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

	If @OSArch = "X64" Then
		_WhileX64()
	Else
		_WhileX86()
	EndIf
EndFunc

Func _CreateAbout()
	GUICtrlCreateTabItem("About this app")

	GUICtrlCreateLabel("Written by Alexander Samuelsson AKA AdmiralAlkex @ AutoIt Forums" & @CRLF & @CRLF & "CodecControl uses the following UDFs:", 10, 30, 400, 50)
	_GUICtrlHyperLink_Create("AutoItObject (adds OO capabilities to AutoIt)", 10, 90, 300, 20, 0x0000FF, 0x551A8B, _
	-1, "http://www.autoitscript.com/forum/index.php?showtopic=110379", 'Visit AuO on the AutoIt forums')
	_GUICtrlHyperLink_Create("_RegFunc (custom registry functions)", 10, 120, 300, 20, 0x0000FF, 0x551A8B, _
	-1, "http://www.autoitscript.com/forum/index.php?showtopic=70108", 'Visit _RegFunc on the AutoIt forums')
	_GUICtrlHyperLink_Create("GUICtrlHyperLink (creates these hyperlink looking labels)", 10, 150, 400, 20, 0x0000FF, 0x551A8B, _
	-1, "http://www.autoitscript.com/forum/index.php?showtopic=126934", 'Visit GUICtrlHyperLink on the AutoIt forums')
EndFunc

Func _WhileX86()
	While 1
		Sleep(10)
		If $odX86.ShowList <> $sDisDShow Then $odX86.FilteredListview($odX86.ShowList)
	WEnd
EndFunc

Func _WhileX64()
	While 1
		Sleep(10)
		If $odX86.ShowList <> $sDisDShow Then $odX86.FilteredListview($odX86.ShowList)
		If $odX64.ShowList <> $sDisDShow Then $odX64.FilteredListview($odX64.ShowList)
	WEnd
EndFunc

Func _CW($Whatever1, $Whatever2 = @ScriptLineNumber, $Whatever3 = @error, $Whatever4 = @extended)		;Based on _CW() from SDL.au3
	Static Local $iExist = FileExists(@ScriptDir & "\Log.txt")
	Local $sText = "(" & $Whatever2 & ") :" & " /Time:" & @YDAY & ":" & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC & " /Current@Error:" & $Whatever3 & " /Current@Extended:" & $Whatever4 & " /VarGetType:" & VarGetType($Whatever1) & " /Value:" & $Whatever1 & @CRLF
	If $iExist <> 0 Then
		FileWrite(@ScriptDir & "\Log.txt", $sText)
	Else
		ConsoleWrite($sText)
	EndIf
EndFunc

Func _Quit()
	Exit
EndFunc

Func _UnregisterCallBackX86()
	_CW("Unregister callback x86")
	_GUICtrlListView_UnRegisterSortCallBack($odX86.ListviewId)
EndFunc

Func _UnregisterCallBackX64()
	_CW("Unregister callback x64")
	_GUICtrlListView_UnRegisterSortCallBack($odX64.ListviewId)
EndFunc

Func __GUICtrlListView_SortItems($hWnd)
	Local $iIndex, $pFunction

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	For $x = 1 To $aListViewSortInfo[0][0]
		If $hWnd = $aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next

	$pFunction = DllCallbackGetPtr($aListViewSortInfo[$iIndex][2]) ; get pointer to call back
	_SendMessage($hWnd, $LVM_SORTITEMS, $hWnd, $pFunction, 0, "hwnd", "ptr")
EndFunc

#region ;AutoItObject
Func _Commons()
	Local $oSelf = _AutoItObject_Create()

	_AutoItObject_AddProperty($oSelf, "RegPath", $ELSCOPE_PRIVATE)
	_AutoItObject_AddProperty($oSelf, "ArchVar", $ELSCOPE_PRIVATE)
	_AutoItObject_AddProperty($oSelf, "InputId", $ELSCOPE_READONLY)

	_AutoItObject_AddMethod($oSelf, "Arch", "__Commons_Arch")

	Return $oSelf
EndFunc

Func __Commons_Arch($oSelf, $sArch = Default)
	If @NumParams = 2 Then
		$oSelf.ArchVar = $sArch
	Else
		Return $oSelf.ArchVar
	EndIf
EndFunc

#region ;dshow filters
Func _DirectShowFilters()
	Local $oSelf = _AutoItObject_Create(_Commons())

	_AutoItObject_AddProperty($oSelf, "TabId", $ELSCOPE_READONLY)
	_AutoItObject_AddProperty($oSelf, "ListviewId", $ELSCOPE_READONLY)
	_AutoItObject_AddProperty($oSelf, "Filters", $ELSCOPE_PRIVATE, LinkedList())
	_AutoItObject_AddProperty($oSelf, "ShowList", $ELSCOPE_PUBLIC, $sDisDShow)

	_AutoItObject_AddMethod($oSelf, "SetUp", "__Filters_SetUp")
	_AutoItObject_AddMethod($oSelf, "GenerateFilters", "__Filters_Generate")
	_AutoItObject_AddMethod($oSelf, "ReloadFilters", "__Filters_Reload")
	_AutoItObject_AddMethod($oSelf, "DisableEnable", "__Filters_DisableEnable")
	_AutoItObject_AddMethod($oSelf, "FilteredListview", "__Filters_FilteredListview")

	Return $oSelf
EndFunc

Func __Filters_SetUp($oSelf, $sTitle, $sPath, $sOnAutoItExit)
	$oSelf.RegPath = $sPath
	$oSelf.Arch = StringRight($sTitle, 5)

	$oSelf.TabId = GUICtrlCreateTabItem($sTitle)

	$oSelf.InputId = GUICtrlCreateInput('Live search', 6, 26, 250, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

	$oSelf.ListviewId = GUICtrlCreateListView("", 6, 55, 325, 476, "", BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_DOUBLEBUFFER))
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	_GUICtrlListView_AddColumn($oSelf.ListviewId, "Display Name", 250)
	_GUICtrlListView_AddColumn($oSelf.ListviewId, "Enabled", 50)
	_GUICtrlListView_RegisterSortCallBack($oSelf.ListviewId)
	OnAutoItExitRegister($sOnAutoItExit)

	$oSelf.GenerateFilters()
EndFunc

Func __Filters_Generate($oSelf)
	Local $sSubKey, $sCLSID, $sDisplay, $iTimer = TimerInit()

	_SendMessage($hGUI, $WM_SETREDRAW, False)   ;Prevent changes in the window to be redrawn (wastly speeds up Item creation) (GUISetState() doesn't work good this early in gui creation)

	_GUICtrlListView_DeleteAllItems($oSelf.ListviewId)

	For $iZeroBasedIndex = 0 To 9999   ;My guesstimate is that normal systems have 50-150...
		$sSubKey = _RegEnumKey($oSelf.RegPath, $iZeroBasedIndex)
		If @error <> 0 then ExitLoop
		$sCLSID = _RegRead($oSelf.RegPath & $sSubKey, "CLSID")
		$sDisplay = _RegRead($oSelf.RegPath & $sSubKey, "FriendlyName")

		If $sCLSID = "" Or $sDisplay = "" Then
			_CW("Failed to read :" & $sSubKey & " " & $oSelf.Arch)
			ContinueLoop
		EndIf

		$oSelf.Filters.Add(_CreateListItem($sSubKey, $sCLSID, $sDisplay))

		If StringInStr($sCLSID, $sDisDShow, 1) = 0 Then
			GUICtrlCreateListViewItem($sDisplay & "|Yes", $oSelf.ListviewId)
		Else
			GUICtrlCreateListViewItem($sDisplay & "|No", $oSelf.ListviewId)
		EndIf
	Next
	_CW("Found " & $oSelf.Filters.size & " filters " & $oSelf.Arch)
	If $iZeroBasedIndex > 9999 Then _CW("Registry broken? Only first " & $iZeroBasedIndex & " items will be displayed")   ;...so if you have 10k filters it's safe to say you have problems (never happened before, but why not?)

	_GUICtrlListView_SortItems($oSelf.ListviewId, 0)
	_SendMessage($hGUI, $WM_SETREDRAW, True)   ;Enable changes to be redrawn again
	_WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_ERASE + $RDW_FRAME + $RDW_INVALIDATE + $RDW_ALLCHILDREN)

	_CW("Generating took " & Round(TimerDiff($iTimer)) & " ms " & $oSelf.Arch)
EndFunc

Func __Filters_Reload($oSelf)
	Local $aiSelected
	$oSelf.Filters = LinkedList()
	$aiSelected = _GUICtrlListView_GetSelectedIndices($oSelf.ListviewId, True)
	$oSelf.GenerateFilters()
	For $iX = 1 To $aiSelected[0]
		_GUICtrlListView_SetItemSelected($oSelf.ListviewId, $aiSelected[$iX])
	Next
	GUICtrlSetState($oSelf.ListviewId, $GUI_FOCUS)
EndFunc

Func __Filters_DisableEnable($oSelf)
	Local $aiSelected, $sCurrent, $iIsDisabled, $iRegStatus
	$aiSelected = _GUICtrlListView_GetSelectedIndices($oSelf.ListviewId, True)

	For $G = 1 To $aiSelected[0]
		$sCurrent = _GUICtrlListView_GetItemText(GUICtrlGetHandle($oSelf.ListviewId), $aiSelected[$G])

		For $oItem In $oSelf.Filters
			If $sCurrent <> $oItem.Display Then ContinueLoop

			$iIsDisabled = StringInStr($oItem.CLSID, $sDisDShow, 1)

			Do
				If $iIsDisabled Then
					$sTrimmedString = StringTrimLeft($oItem.CLSID, 1)
					$iRegStatus = _RegWrite($oSelf.RegPath & $oItem.Filter, "CLSID", $REG_SZ, $sTrimmedString)
					If $iRegStatus = 1 Then
						_GUICtrlListView_SetItemText($oSelf.ListviewId, $aiSelected[$G], "Yes", 1)   ;write Enable to listview
						$oItem.CLSID = $sTrimmedString
					Else
						_CW("Failed to RegWrite " & $oItem.Display)
					EndIf
				Else
					$iRegStatus = _RegWrite($oSelf.RegPath & $oItem.Filter, "CLSID", $REG_SZ, $sDisDShow & $oItem.CLSID)
					If $iRegStatus = 1 Then
						_GUICtrlListView_SetItemText($oSelf.ListviewId, $aiSelected[$G], "No", 1)   ;write Disable to listview
						$oItem.CLSID = $sDisDShow & $oItem.CLSID
					Else
						_CW("Failed to RegWrite " & $oItem.Display)
					EndIf
				EndIf

				If $iRegStatus <> 1 Then   ;If Registry write failed
					Switch MsgBox(6+32, StringTrimRight(@ScriptName, 4), "Failed to enable/disable " & $oItem.Display, 0, $hGUI)
						Case 2   ;Cancel
							Return
						Case 10   ;Try again
							ContinueLoop
						Case 11   ;Continue
							ExitLoop
					EndSwitch
				EndIf
			Until True

			ExitLoop
		Next
	Next

	GUICtrlSetState($oSelf.ListviewId, $GUI_FOCUS)
EndFunc

Func __Filters_FilteredListview($oSelf, $sCurrent)
	Local $iTimer = TimerInit()

	GUISetState(@SW_LOCK)   ;Prevent changes in the window to be redrawn (wastly speeds up Item creation)
	_GUICtrlListView_DeleteAllItems($oSelf.ListviewId)

	For $oItem In $oSelf.Filters
		If $sCurrent <> $oSelf.ShowList Then Return _CW("Interrupted filtering process " & $oSelf.Arch)
		If $oItem.Display = "" Then ExitLoop   ;Is this necessary?

		If $sCurrent <> "" And StringInStr($oItem.Display, $sCurrent, 0) = 0 Then ContinueLoop

		If StringInStr($oItem.CLSID, $sDisDShow, 1) = 0 Then
			GUICtrlCreateListViewItem($oItem.Display & "|Yes", $oSelf.ListviewId)
		Else
			GUICtrlCreateListViewItem($oItem.Display & "|No", $oSelf.ListviewId)
		EndIf
	Next
	$oSelf.ShowList = $sDisDShow

	__GUICtrlListView_SortItems($oSelf.ListviewId)
	GUISetState(@SW_UNLOCK)

	_CW("Filtering took " & Round(TimerDiff($iTimer)) & " ms " & $oSelf.Arch)
EndFunc

;ProgAndy helped with this (post #195, AuO thread (110379)), big thanks to him!
Func _CreateListItem($sFilter, $sCLSID, $sDisplay)
    Local $oSelf = _AutoItObject_Create()

    _AutoItObject_AddProperty($oSelf, "Filter", $ELSCOPE_PUBLIC, $sFilter)
    _AutoItObject_AddProperty($oSelf, "CLSID", $ELSCOPE_PUBLIC, $sCLSID)
    _AutoItObject_AddProperty($oSelf, "Display", $ELSCOPE_PUBLIC, $sDisplay)

    Return $oSelf
EndFunc
#endregion

#region ;ffdshow
Func _ffdshow($sTitle, $sPath, $sInstalled)
	Local $oSelf = _AutoItObject_Create(_Commons())

	$oSelf.Arch(StringRight($sTitle, 5))

	_RegRead($sInstalled, "DisplayName")
	If @error Then
		_CW("ffdshow not found " & $oSelf.Arch)
		Return 0
	EndIf

	_AutoItObject_AddProperty($oSelf, "ComboId", $ELSCOPE_READONLY)
	_AutoItObject_AddProperty($oSelf, "LabelId", $ELSCOPE_READONLY)
	_AutoItObject_AddProperty($oSelf, "Preset", $ELSCOPE_READONLY, "default")
	_AutoItObject_AddProperty($oSelf, "queueCount", $ELSCOPE_READONLY)

	_AutoItObject_AddMethod($oSelf, "SetUp", "__ffdshow_SetUp")
	_AutoItObject_AddMethod($oSelf, "BuildPresets", "__ffdshow_BuildPresets")
	_AutoItObject_AddMethod($oSelf, "UpdateQueueStatus", "__ffdshow_UpdateQueueStatus")
	_AutoItObject_AddMethod($oSelf, "Combo", "__ffdshow_Combo")
	_AutoItObject_AddMethod($oSelf, "Button", "__ffdshow_Button")

	$oSelf.SetUp($sTitle, $sPath)

	Return $oSelf
EndFunc

Func __ffdshow_SetUp($oSelf, $sTitle, $sPath)
	$oSelf.RegPath = $sPath

	GUICtrlCreateTabItem($sTitle)

	GUICtrlCreateEdit('The only setting which isn''t available through the official configuration tools (AFAIK) is the amount of buffers used when "Queue output samples" is on and therefore thats the only setting here', 6, 26, 400, 64, BitOR($ES_READONLY, $ES_MULTILINE))

	_GUICtrlHyperLink_Create("Read online what this is about", 6, 100, 400, 20, 0x0000FF, 0x551A8B, _
	-1, "http://ffdshow-tryout.sourceforge.net/html/en/queue.htm", 'Visit ffdshow-tryout online help')

	GUICtrlCreateLabel("Choose preset to change settings to=", 6, 200, 200)
	$oSelf.ComboId = GUICtrlCreateCombo("", 206, 200, 150)

	$oSelf.LabelId = GUICtrlCreateLabel("Current amount of buffers choosed is?", 6, 240, 250, 20)
	GUICtrlSetFont(-1, Default, 800)

	$oSelf.InputId = GUICtrlCreateInput("Please write how many buffers you want to set", 6, 270, 250, Default, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
	GUICtrlCreateButton("Set buffers", 266, 265, 75, 30)
EndFunc

Func __ffdshow_BuildPresets($oSelf)
	Local $sPresets = "", $sEnumReg

	For $iZeroBasedIndex = 0 To 999   ;For safety. Most systems probably only have 1 profile/preset, but even if you have more it's usually only a handful, not thousands
		$sEnumReg = _RegEnumKey($oSelf.RegPath, $iZeroBasedIndex)
		If @error <> 0 then ExitLoop
		$sPresets &= "|" & $sEnumReg
	Next

	If $iZeroBasedIndex > 999 Then _CW("Registry broken? Only first " & $iZeroBasedIndex & " items will be displayed")
	If $sPresets <> "" Then GUICtrlSetData($oSelf.ComboId, $sPresets, "default")
EndFunc

Func __ffdshow_UpdateQueueStatus($oSelf)
	$oSelf.queueCount = _RegRead($oSelf.RegPath & $oSelf.Preset, "queueCount")

	GUICtrlSetData($oSelf.LabelId, "Current amount of buffers choosed is " & $oSelf.queueCount)
EndFunc

Func __ffdshow_Combo($oSelf)
	Local $sComboRead
	$sComboRead = GUICtrlRead($oSelf.ComboId)
	$oSelf.Preset = $sComboRead
	$oSelf.UpdateQueueStatus()
EndFunc

Func __ffdshow_Button($oSelf)
	_RegWrite($oSelf.RegPath & $oSelf.Preset, "queueCount", $REG_DWORD, GUICtrlRead($oSelf.InputId))
	If @error Then _CW("Failed to write ffdshow queueCount " & $oSelf.Arch)
	$oSelf.UpdateQueueStatus()
EndFunc
#endregion
#endregion

#region ;Events
Func _DShowReloadX86()
	$odX86.ReloadFilters()
EndFunc

Func _DShowReloadX64()
	$odX64.ReloadFilters()
EndFunc

Func _DShowButtonCodecX86()
	$odX86.DisableEnable()
EndFunc

Func _DShowButtonCodecX64()
	$odX64.DisableEnable()
EndFunc

Func _ffdshowComboX86()
	$ofX86.Combo()
EndFunc

Func _ffdshowComboX64()
	$ofX64.Combo()
EndFunc

Func _ffdshowButtonX86()
	$ofX86.Button()
EndFunc

Func _ffdshowButtonX64()
	$ofX64.Button()
EndFunc

Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iCode, $tNMHDR
	Local Static $hWndTab = GUICtrlGetHandle($hTab), $iChkX64 = IsObj($odX64), $hWndListView = GUICtrlGetHandle($odX86.ListviewId)

    If $iChkX64 Then
		Local Static $hWndListView2 = GUICtrlGetHandle($odX64.ListviewId)
	EndIf

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")

	Select
		Case $hWndFrom = $hWndTab
			If $iCode <> $NM_CLICK Then Return $GUI_RUNDEFMSG   ;Return if anything but "tab was clicked"

			Select
				Case GUICtrlRead($hTab, 1) = $odX86.TabId
					GUICtrlSetState($odX86.ListviewId, $GUI_FOCUS)   ;focus x86 listview
				Case $iChkX64 And GUICtrlRead($hTab, 1) = $odX64.TabId
					GUICtrlSetState($odX64.ListviewId, $GUI_FOCUS)   ;or x64 listview
			EndSelect

		Case $hWndFrom = $hWndListView Or ($iChkX64 And $hWndFrom = $hWndListView2)
			If $iCode <> $LVN_COLUMNCLICK Then Return $GUI_RUNDEFMSG   ;Return if anything but "column was clicked"

			Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
			_GUICtrlListView_SortItems($hWndFrom, DllStructGetData($tInfo, "SubItem"))   ;Kick off the sort callback
	EndSelect
	Return $GUI_RUNDEFMSG
EndFunc

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	Local $cId
	Local Static $iChkX64 = IsObj($odX64)

	$cId = BitAND($wParam, 0xFFFF)   ;ControlId

	Switch BitShift($wParam, 16)   ;"Notification code"
		Case $EN_CHANGE
			If $cId = $odX86.InputId Then
				$odX86.ShowList = GUICtrlRead($cId)
			ElseIf $iChkX64 = 1 And $cId = $odX64.InputId Then
				$odX64.ShowList = GUICtrlRead($cId)
			EndIf
		Case $EN_SETFOCUS
			If $cId = $odX86.InputId Then
				_WinAPI_PostMessage(GUICtrlGetHandle($cId), $EM_SETSEL, 0, -1)
			ElseIf $iChkX64 = 1 And $cId = $odX64.InputId Then
				_WinAPI_PostMessage(GUICtrlGetHandle($cId), $EM_SETSEL, 0, -1)
			ElseIf $cId = $ofX86.InputId Then
				If Number(GUICtrlRead($cId)) = 0 Then GUICtrlSetData($cId, $ofX86.queueCount)
				_WinAPI_PostMessage(GUICtrlGetHandle($cId), $EM_SETSEL, 0, -1)
			ElseIf $iChkX64 = 1 And $cId = $ofX64.InputId Then
				If Number(GUICtrlRead($cId)) = 0 Then GUICtrlSetData($cId, $ofX64.queueCount)
				_WinAPI_PostMessage(GUICtrlGetHandle($cId), $EM_SETSEL, 0, -1)
			EndIf
	EndSwitch
EndFunc
#endregion