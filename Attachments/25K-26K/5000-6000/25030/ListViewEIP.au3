#include <GuiConstants.au3>
#include <GuiTab.au3>
#include <_EIPListView.au3>
#include <staticconstants.au3>
#AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
Global $count = 0
;===============================================================================
; Name				:	ListViewEIP
; Description		:	An example of editing a ListView by overlaying editing controls.
; 						:
; Requirement(s)	:	_EIPListView.au3
; 						:
;						:
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:
;===============================================================================
Global $Checkbox1, $Checkbox2, $HelpContext, $bProgressShowing, $Tab1;,$Status1,$Status2
Opt("GUICloseOnESC", 0);turn off exit on esc.
Opt("GUIOnEventMode", 1)
_Main()
Func _Main()
	;	======>>> set the type of control for each column <<<======
	;0= ignore, 1= edit, 2= combo, 4= calendar, 256= use callback.
	Global $LVcolControl[5] = [1, 8, 256, 2, 4] ;left click actions
	;0 = ignore, 1= use context callback
	Global $LVcolRControl[5] = [256, 256, 0, 0, 0] ; right click actions
	_SetLvCallBack ("MyCallBack") ;set callback function
	_SetLvContext ("MyContext") ;set context fuction
	Local $guiw = 800
	Local $guih = 400
	Local $deskh = @DesktopHeight - _GetTaskBarHeight()
	Local $aWinPos[4] = [(@DesktopWidth - $guiw) / 2, ($deskh - $guih) / 2, 800, 400]
	$Gui = GUICreate("Edit In Place Demo", $aWinPos[2], $aWinPos[3], $aWinPos[1], $aWinPos[0], BitOR($GUI_SS_DEFAULT_GUI, $WS_CLIPSIBLINGS));, 424, 280, 200, 110)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")
	;---------------------------------------------
	;create the editing controls before the ListView.
	Local $Tab1 = GUICtrlCreateTab(3, 3, $guiw - 5, $guih - 5, BitOR($TCS_FOCUSNEVER, $WS_CLIPCHILDREN))
	GUICtrlSetOnEvent(-1, "TabHandler")
	Local $TabItem = GUICtrlCreateTabItem("Tab1")
	#forceref $Tab1, $TabItem
	;---------------------------------------------
	Local $ListView = GUICtrlCreateListView("Items|Items2|Third|Fourth|Startdate", 10, 35, $guiw - 220, $guih - 100)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	$__LISTVIEWCTRL = $ListView
	
	$Checkbox1 = GUICtrlCreateCheckbox("Update On Focus Change", 30, $guih - 60, 147, 17)
	GUICtrlSetTip($Checkbox1, "Checking this box means that if a cell is being actively edited" & @LF & _
			"and another cell is clicked, the edited cell is updated with the new data." & @LF & _
			"If unchecked, the original data is preserved.")
	
	GUICtrlSetOnEvent($Checkbox1, "SetUpdateOptions")
	$Checkbox2 = GUICtrlCreateCheckbox("DblClick to Init Edit ", 30, $guih - 40, 147, 17)
	GUICtrlSetTip($Checkbox2, "Checking this box means that one must double click the cell to get the edit control.")
	GUICtrlSetOnEvent($Checkbox2, "SetUpdateOptions")
	GUICtrlCreateTabItem("Tab2")
	GUICtrlCreateTabItem("")
	Local $Status1 = GUICtrlCreateLabel("", 1, $guih - 17, $guiw / 2, 17, $SS_SUNKEN)
	Local $Status2 = GUICtrlCreateLabel("", ($guiw / 2) + 2, $guih - 17, ($guiw / 2) - 2, 17, $SS_SUNKEN)
	; Populate list and make it wide enough to see
	;======>>>  Populate controls with test data<<<======
	GUICtrlSetOnEvent($__LISTVIEWCTRL, "lvListViewHandler")
	Local $c
	For $i = 1 To 18
		$c = $c & Chr($i + 66) & "|"
		GUICtrlCreateListViewItem("DoubleClick or press F2, then press Enter|Something|MsgBox|" & $i & "|01/07/1969", $ListView)
	Next
	$c = StringTrimRight($c, 1)
	GUICtrlSendMsg($ListView, 0x101E, 0, 300);$listview, LVM_SETCOLUMNWIDTH, 0, resize to widest value
	GUICtrlSendMsg($ListView, 0x101E, 1, 100);$listview, LVM_SETCOLUMNWIDTH, 0, resize to widest value
	GUICtrlSendMsg($ListView, 0x101E, 2, 100);$listview, LVM_SETCOLUMNWIDTH, 0, resize to widest value
	;======>>>  End  Populate  <<<======
	$__LISTVIEWCTRL = $ListView ;<<<====== Set $__LISTVIEWCTRL to the ctrlID of the ListView control
	WinMove($Gui, "", 1, @DesktopHeight)
	GUISetState(@SW_SHOW, $Gui)
	_InitEditLib ("", "", "", "Whatever", $Gui);
	GUICtrlSetOnEvent($lvList, "lvListHandler")
	GUICtrlSetData($lvList, "Something|Nothing|Other|Nada|Zip|Ziltch|A Lot|Mucho|Smidge|Pinch"); <<<====== populate list.
	GUICtrlSetData($lvCombo, $c)
	_AnimateWindow($Gui, $aWinPos)
	$bInitiated = True
	ConsoleWrite("Initiate Done." & @LF)
	While 1
		_MonitorEditState ($editCtrl, $editFlag, $__LISTVIEWCTRL, $LVINFO);<<<======  add this in your message loop<<<======
		If $bCALLBACK_EVENT = True Then
			$bCALLBACK_EVENT = False
			
			Call($LVCALLBACK, $LVINFO)
		EndIf
		Local $statMsg1 = StringFormat("Row: %s Col: %s Ckd: %s", $LVINFO[8] & @TAB, $LVINFO[9] & @TAB, $LVCHECKEDCNT)
		Local $statMsg2 = StringFormat("Update: %s  DblClick: %s", $bLVUPDATEONFOCUSCHANGE, $bLVEDITONDBLCLICK)
		If GUICtrlRead($Status1) <> $statMsg1 Then GUICtrlSetData($Status1, $statMsg1)
		If GUICtrlRead($Status2) <> $statMsg2 Then GUICtrlSetData($Status2, $statMsg2)
		Sleep(25)
	WEnd
	
	_TermEditLib ();<<<====== add this after your message loop<<<======
EndFunc   ;==>_Main
Func OnExit()
	_TermEditLib ()
	_AnimateWindow($Gui, WinGetPos($Gui), 1)
	Exit
EndFunc   ;==>OnExit
Func SetUpdateOptions()
	$bLVUPDATEONFOCUSCHANGE = (BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED)
	$bLVEDITONDBLCLICK = (BitAND(GUICtrlRead($Checkbox2), $GUI_CHECKED) = $GUI_CHECKED)
EndFunc   ;==>SetUpdateOptions
Func MyCallBack($aLVInfo)
	$bProgressShowing = True
	_ArrayDisplay($aLVInfo, "LV Info")
	Local $xx1, $yy1, $LVPOS
	ClientToScreen (WinGetHandle($Gui), $xx1, $yy1)
	Local $lvProgressWin = GUICreate("LVPROGRESSWIN", $aLVInfo[4] + 1, $aLVInfo[5] - 8, ($xx1 + $aLVInfo[2]), ($yy1 + $aLVInfo[3] + 3), $WS_POPUP, -1, $Gui)
	Local $lvProgress = GUICtrlCreateProgress(0, 0, $aLVInfo[4], $aLVInfo[5] - 9)
	GUICtrlSetState($lvProgress, $GUI_ONTOP)
	GUISetState(@SW_SHOW, $lvProgressWin)
	WinSetOnTop($lvProgressWin, "", 1)
	WinActivate($lvProgressWin, "")
	Local $r1 = $LVINFO[0]
	Local $c1 = $LVINFO[1]
	ConsoleWrite($r1 & " , " & $c1 & "  " & $aLVInfo[0] & " , " & $aLVInfo[1] & @LF)
	Local $xx, $yy
	For $x = 0 To 100
		If $r1 <> $aLVInfo[0] Or $c1 <> $aLVInfo[1] Then
			_FillLV_Info ($__LISTVIEWCTRL, $r1, $c1, $aLVInfo, 0)
		Else
			For $xx = 0 To UBound($aLVInfo) - 1
				$aLVInfo[$xx] = $LVINFO[$xx]
				
			Next
		EndIf
		ConsoleWrite($r1 & " , " & $c1 & "  " & $aLVInfo[0] & " , " & $aLVInfo[1] & @LF)
		$xx = $aLVInfo[2]
		$yy = $aLVInfo[3]
		ClientToScreen ($Gui, $xx, $yy)
		$LVPOS = ControlGetPos($Gui, "", $__LISTVIEWCTRL)
		ClientToScreen ($Gui, $LVPOS[0], $LVPOS[1])
		If $xx <> $aLVInfo[2] Or $yy <> $aLVInfo[3] Then
			If $r1 = $aLVInfo[0] And $c1 = $aLVInfo[1] Then WinMove($lvProgressWin, "", ($xx), ($yy + 3))
			If $xx < $LVPOS[0] Or $xx > ($LVPOS[0] + $LVPOS[2]) Or $yy + 3 < $LVPOS[1] + 20 Or $yy + 3 > ($LVPOS[1] + $LVPOS[3] - 21) Then
				GUISetState(@SW_HIDE, $lvProgressWin)
			Else
				GUISetState(@SW_SHOW, $lvProgressWin)
			EndIf
		EndIf
		GUICtrlSetData($lvProgress, $x)
		Sleep(50)
	Next
	GUICtrlDelete($lvProgress)
	GUIDelete($lvProgressWin)
	$bProgressShowing = False
	Return 1
EndFunc   ;==>MyCallBack
Func MyContext($aLVInfo)
	Local $ret = 0, $oldText
	
	;create context menu on demand.
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader (StringFormat("MyContext Row:%d Col:%d", $aLVInfo[0], $aLVInfo[1])))
	;----------------------------------------------------------------------------------------------
	If ($aLVInfo[0] < 0 Or $aLVInfo[1] < 0) Then Return
	Local $HelpCtx[7]
	$HelpCtx[0] = GUICtrlCreateDummy()
	$HelpCtx[1] = GUICtrlCreateContextMenu($HelpCtx[0])
	$HelpCtx[2] = GUICtrlCreateMenuItem("String Upper", $HelpCtx[1])
	$HelpCtx[3] = GUICtrlCreateMenuItem("", $HelpCtx[1])
	$HelpCtx[4] = GUICtrlCreateMenuItem("String Lower", $HelpCtx[1])
	$HelpCtx[5] = GUICtrlCreateMenuItem("", $HelpCtx[1])
	$HelpCtx[6] = GUICtrlCreateMenuItem("About...", $HelpCtx[1])
	GUISetState(@SW_SHOW)
	Local $hMenu = GUICtrlGetHandle($HelpCtx[1])
	Local $xx, $yy
	$xx = 0
	$yy = 0
	ClientToScreen (WinGetHandle($Gui), $xx, $yy)
	Local $ctx = TrackPopupMenu(WinGetHandle($Gui), $hMenu, $xx + $aLVInfo[2], $yy + $aLVInfo[3])
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader ("MenuItem=" & $ctx))
	;----------------------------------------------------------------------------------------------
	;; do something with the result.
	Switch $ctx
		Case $HelpCtx[2]
			$oldText = _GUICtrlListView_GetItemText($__LISTVIEWCTRL, $aLVInfo[0], $aLVInfo[1])
			$ret = _GUICtrlListView_SetItemText($__LISTVIEWCTRL, $aLVInfo[0], $aLVInfo[1], StringUpper($oldText))
		Case $HelpCtx[4]
			$oldText = _GUICtrlListView_GetItemText($__LISTVIEWCTRL, $aLVInfo[0], $aLVInfo[1])
			$ret = _GUICtrlListView_SetItemText($__LISTVIEWCTRL, $aLVInfo[0], $aLVInfo[1], StringLower($oldText))
		Case $HelpCtx[6]
			MsgBox(266288, "EIP ListView", "Called from context menu.")
	EndSwitch
	;; clean up the context menu.
	For $x = 0 To UBound($HelpCtx) - 1
		GUICtrlDelete($HelpCtx[$x])
	Next
	Return $ret
EndFunc   ;==>MyContext
; added TPM_RETURNCMD to uflags to get menu item return value.
; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	Local $v_ret = DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0X100, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
	Return $v_ret[0]
EndFunc   ;==>TrackPopupMenu
Func TabHandler()
	;cancel edit if tab changes.
	If _GUICtrlTab_GetCurFocus($Tab1) <> 1 Then
		If $editFlag Then _CancelEdit ()
	EndIf
EndFunc   ;==>TabHandler
Func lvListHandler()
	ConsoleWrite("List control handler" & @LF)
	If $bLVDBLCLICK Then
		ConsoleWrite("DblClick" & @LF)
		$bLVDBLCLICK = False
	Else
		ConsoleWrite("Click" & @LF)
	EndIf
EndFunc   ;==>lvListHandler
Func lvListViewHandler()
	ConsoleWrite("lvListViewHandler>>" & @LF)
EndFunc   ;==>lvListViewHandler
Func _AnimateWindow($hWnd, $aPos, $iFlag = 0)
	If $hWnd = 0 Then Return 0
	If IsArray($aPos) Then
		If UBound($aPos) <> 4 Then Return 0
	EndIf
	Local $tstep, $lstep
	If $iFlag Then
		$tstep = (@DesktopHeight - $aPos[1]) / 50
		$lstep = $aPos[0] / 50
		For $x = 50 To 0 Step - .5
			WinMove($Gui, "", $lstep * $x, @DesktopHeight - ($tstep * $x), $aPos[2] / 4, $aPos[3] / 4)
		Next
	Else
		WinMove($Gui, "", 1, 1, 1, 1)
		$tstep = (@DesktopHeight - $aPos[1]) / 50
		$lstep = $aPos[0] / 50
		For $x = 0 To 50 Step .5
			WinMove($Gui, "", $lstep * $x, @DesktopHeight - ($tstep * $x), $aPos[2] / 4, $aPos[3] / 4)
		Next
		WinMove($Gui, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
	EndIf
	Return
EndFunc   ;==>_AnimateWindow
Func _GetTaskBarHeight()
	Local $oldOpt = Opt("WinTitleMatchMode", 4)
	Local $TrayPos = WinGetPos("classname=Shell_TrayWnd")
	Opt("WinTitleMatchMode", $oldOpt)
	Return $TrayPos[3]
EndFunc   ;==>_GetTaskBarHeight
