#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\Icons\greg\Diamant.ico
#AutoIt3Wrapper_Outfile=..\..\..\..\Documents and Settings\Greg\Desktop\ClipCatch Pack\JDClipCatch.exe
;~ #AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ClipBoard.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <Array.au3>
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GuiButton.au3>
#include <Timers.au3>
#include <GuiStatusBar.au3>
#include <ScreenCapture.au3>
#include <StaticConstants.au3>
#Region Global
_Singleton(@ScriptName)
Global $main_pos[4], $Edit_pos[4]
If FileExists(@AppDataDir & "\JDclipcatch") = 0 Then DirCreate(@AppDataDir & "\JDclipcatch")
$laws = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "laws", 4)
$maxclips = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "maxclips", 500)
$backuplocation = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "backloc", "")
$picturefolder = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "picturefolder", @AppDataDir & "\jdclipcatch\pictures")
If FileExists($picturefolder) = 0 Then DirCreate($picturefolder)
$notifysound = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "notifysound", "")
$maxpicfolder = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "maxpicfolder", 10)
$AutoHide = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "AutoHide", 4)
$HK1 = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK1", "CTRL 0")
$HK2 = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK2", "CTRL 9")
$HK3 = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK3", "CTRL 8")
$HK4 = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK4", "SHIFT CTRL UP")
$HK5 = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK5", "SHIFT CTRL DOWN")
$main_pos[0] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_x", 85)
$main_pos[1] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_y", 84)
$main_pos[2] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_xsiz", 515)
$main_pos[3] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_ysiz", 471)
$Edit_pos[0] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_x", 607)
$Edit_pos[1] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_y", 85)
$Edit_pos[2] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_xsiz", 337)
$Edit_pos[3] = IniRead(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_ysiz", 470)
Global $ver = "3.7"
Global $firstarray
Global $array[$maxclips + 1]
Global $H_array[$maxclips + 1]
Global $HT_DAY[$maxclips + 1]
Global $monthday = @MON & @MDAY
Global $iDoubleClick = 0
Global $Click = 0
Global $HGUI_CCeditbox = 0
Global $HB_CC_ST_clippaste
Global $HB_CC_ST_target
Global $HB_CC_ST_openpicfolder
Global $HE_CC_ST_1
Global $keyindex
Global $keytime
Global $runbyreg = String($cmdline[$cmdline[0]])
Global $MainFileLocation = @AppDataDir & "\jdclipcatch\jdcc.log"
Global $HP_CC_pic
Global $mousemoved = 0
Global $HB_CC_nopic
Global $win_han = 0
Global $oldwin_han = 0
Global $HB_CC_ST_holdeditpoen
Global $HB_CC_ST_cleareditbox
Global $holdeditboxopen = 0
Global $lastselected = 0
Global $screenshotform
Global $guipicwindow
Global $winpoz_save = 0
#EndRegion Global
#Region GUI
#Region ### START Koda GUI section ### Form=Form1.kxf
$HGUI_CCmain = GUICreate("JD's Clip Catch", 515, 471, 85, 84, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_SYSMENU, $WS_CAPTION, $WS_OVERLAPPEDWINDOW, $WS_TILEDWINDOW, $WS_POPUP, $WS_POPUPWINDOW, $WS_GROUP, $WS_TABSTOP, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
$HTV_CC_1 = GUICtrlCreateTreeView(8, 48, 497, 377, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $WS_GROUP, $WS_TABSTOP, $WS_VSCROLL, $WS_BORDER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
$HB_copyclip = GUICtrlCreateButton("", 51, 8, 33, 33)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_sendT = GUICtrlCreateButton("", 8, 8, 33, 33)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_exit = GUICtrlCreateButton("", 184, 8, 33, 33)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_config = GUICtrlCreateButton("", 95, 8, 33, 33)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HI_search = GUICtrlCreateInput("", 320, 20, 185, 21)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Label1 = GUICtrlCreateLabel("Search", 464, 0, 38, 17)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_filefolder = GUICtrlCreateButton("", 138, 8, 33, 33)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HCB_AH = GUICtrlCreateCheckbox("Auto Hide", 320, 0, 129, 17)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Tick to auto hide after use")
$MenuItemqwe1 = GUICtrlCreateMenu("&Munu")
$MenuItemqwe2 = GUICtrlCreateMenuItem("Settings", $MenuItemqwe1)
$MenuItemqwe3 = GUICtrlCreateMenuItem("EXIT ClipCatch", $MenuItemqwe1)
#EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=Form2.kxf
$HGUI_CCeditbox = GUICreate("Edit Box", 337, 470, 607, 85, BitOR($WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_CAPTION, $WS_POPUP, $WS_TABSTOP, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
$HE_CC_ST_1 = GUICtrlCreateEdit("", 8, 108, 321, 337, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $WS_BORDER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
$HB_CC_ST_target = GUICtrlCreateButton("", 8, 10, 33, 33, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_CC_ST_clippaste = GUICtrlCreateButton("", 51, 10, 33, 33, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_CC_ST_openpicfolder = GUICtrlCreateButton("", 94, 10, 33, 33, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$HB_CC_nopic = GUICtrlCreateButton("Picture Removed due to folder size restrictions", 32, 208, 265, 129, BitOR($BS_MULTILINE, $BS_FLAT))
GUICtrlSetFont(-1, 16, 400, 0, "MS Sans Serif")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
$HB_CC_ST_holdeditpoen = GUICtrlCreateButton("", 293, 10, 33, 33, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Lock Edit Box - Use as Scrap Pad")
$HB_CC_ST_cleareditbox = GUICtrlCreateButton("", 250, 10, 33, 33, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Clear Edit Box")
$HE_CC_Header = GUICtrlCreateEdit("", 8, 52, 321, 53, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_BORDER))
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUICtrlSetFont($HE_CC_Header, 9, 800)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
#EndRegion ### END Koda GUI section ###
GUICtrlSetState($HB_CC_nopic, $GUI_HIDE + $GUI_DISABLE)
GUICtrlSetState($HE_CC_Header, $GUI_DISABLE)
GUICtrlSetState($HCB_AH, $AutoHide)
$HP_CC_pic = GUICtrlCreatePic("", 8, 108, 321, 337)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
GUICtrlSetStyle($HB_CC_ST_target, $BS_ICON)
GUICtrlSetStyle($HB_CC_ST_clippaste, $BS_ICON)
GUICtrlSetStyle($HB_CC_ST_openpicfolder, $BS_ICON)
GUICtrlSetStyle($HB_CC_ST_holdeditpoen, $BS_ICON)
GUICtrlSetStyle($HB_CC_ST_cleareditbox, $BS_ICON)
GUICtrlSetStyle($HB_copyclip, $BS_ICON)
GUICtrlSetStyle($HB_sendT, $BS_ICON)
GUICtrlSetStyle($HB_config, $BS_ICON)
GUICtrlSetStyle($HB_filefolder, $BS_ICON)
GUICtrlSetStyle($HB_exit, $BS_ICON)
_GUICtrlButton_SetImage($HB_CC_ST_target, "shell32.dll", 176, True)
_GUICtrlButton_SetImage($HB_CC_ST_clippaste, "shell32.dll", 21, True)
_GUICtrlButton_SetImage($HB_CC_ST_openpicfolder, "shell32.dll", 127, True)
_GUICtrlButton_SetImage($HB_CC_ST_holdeditpoen, "shell32.dll", 44, True)
_GUICtrlButton_SetImage($HB_CC_ST_cleareditbox, "shell32.dll", 54, True)
_GUICtrlButton_SetImage($HB_copyclip, "shell32.dll", 21, True)
_GUICtrlButton_SetImage($HB_sendT, "shell32.dll", 176, True)
_GUICtrlButton_SetImage($HB_config, "shell32.dll", 165, True)
_GUICtrlButton_SetImage($HB_filefolder, "shell32.dll", 4, True)
_GUICtrlButton_SetImage($HB_exit, "shell32.dll", 27, True)
GUICtrlSetTip($HB_CC_ST_clippaste, "Capture New Edit")
GUICtrlSetTip($HB_CC_ST_target, "Send to Target")
GUICtrlSetTip($HB_CC_ST_openpicfolder, "Open Picture Folder")
GUICtrlSetTip($HB_copyclip, "Copy to ClipBoard")
GUICtrlSetTip($HB_sendT, "Send to Target")
GUICtrlSetTip($HB_config, "Settings")
GUICtrlSetTip($HB_filefolder, "Open File Folder")
GUICtrlSetTip($HB_exit, "Hide App")
WinMove($HGUI_CCmain, "", $main_pos[0], $main_pos[1], $main_pos[2], $main_pos[3])
WinMove($HGUI_CCeditbox, "", $Edit_pos[0], $Edit_pos[1], $Edit_pos[2], $Edit_pos[3])
Local $aParts[3] = [170, 300, -1]
$hStatus = _GUICtrlStatusBar_Create($HGUI_CCmain)
_GUICtrlStatusBar_SetParts($hStatus, $aParts)
_GUICtrlStatusBar_SetText($hStatus, "Number of Clips = ")
_GUICtrlStatusBar_SetText($hStatus, "Version " & $ver, 1)
_GUICtrlStatusBar_SetText($hStatus, "GMW Software.", 2)
Local $aParts[2] = [100, -1]
$hStatus_edit = _GUICtrlStatusBar_Create($HGUI_CCeditbox)
_GUICtrlStatusBar_SetParts($hStatus_edit, $aParts)
_GUICtrlStatusBar_SetText($hStatus_edit, "Clip No. = ")
_GUICtrlStatusBar_SetText($hStatus_edit, "GMW Software.", 1)
If $runbyreg <> "Tray" Then
	GUISetState(@SW_SHOW, $HGUI_CCeditbox)
	GUISetState(@SW_SHOW, $HGUI_CCmain)
EndIf
#EndRegion GUI
#Region BEGIN
_ClipBoard_SetViewer($HGUI_CCmain)
HotKeySet(_HotKeyConvert($HK1), "Hot_key")
HotKeySet(_HotKeyConvert($HK2), "quicknote")
HotKeySet(_HotKeyConvert($HK3), "SS_ctrl")
HotKeySet(_HotKeyConvert($HK4), "up_key")
HotKeySet(_HotKeyConvert($HK5), "down_key")
GUIRegisterMsg($WM_DRAWCLIPBOARD, "ClipCaptured")
GUIRegisterMsg($WM_NOTIFY, "MY_WM_NOTIFY")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")
GUIRegisterMsg($WM_GETMINMAXINFO, "MY_WM_GETMINMAXINFO")
GUIRegisterMsg($WM_WINDOWPOSCHANGED, "MY_WM_WINDOWPOSCHANGED")
Opt("Trayiconhide", 1)
Opt("MouseCoordMode", 2)
read_in_array()
read_into_list()
_ReduceMemory()
$keyindex = $array[0]
_GUICtrlStatusBar_SetText($hStatus, "Number of Clips = " & $array[0])
_GUICtrlStatusBar_SetText($hStatus_edit, "Clip No. = " & $array[0])
_main()
Exit
#EndRegion BEGIN
Func _main()
	While 1
		$nMsg = GUIGetMsg(1)
		WM_act()
		Switch $nMsg[0]
			Case $MenuItemqwe3
				Exit
			Case $HB_exit, $GUI_EVENT_CLOSE
				If $nMsg[1] = $HGUI_CCmain Then
					If $holdeditboxopen = 0 Then
						GUISetState(@SW_HIDE, $HGUI_CCeditbox)
					EndIf
					GUISetState(@SW_HIDE, $HGUI_CCmain)
					_ReduceMemory()
				EndIf
			Case $HB_config
				settings()
			Case $MenuItemqwe2
				settings()
			Case $HI_search
				If GUICtrlRead($HI_search) = "" Then
					read_into_list()
					_GUICtrlStatusBar_SetText($hStatus, "Number of Clips = " & $array[0])
				Else
					_search(GUICtrlRead($HI_search))
				EndIf
			Case $HB_filefolder
				$filelocfolder = dirstructur()
				If $filelocfolder <> "0" Then ShellExecute($filelocfolder)
			Case $HB_copyclip
				clip_copy_paste()
			Case $HB_sendT
				clip_copy_paste(1)
			Case $HB_CC_ST_clippaste
				clip_copy_paste(0, 1, 0)
			Case $HB_CC_ST_target
				clip_copy_paste(1, 1)
			Case $HB_CC_ST_openpicfolder
				ShellExecute($picturefolder)
			Case $GUI_EVENT_PRIMARYDOWN
				If WinActive($HGUI_CCmain) And $holdeditboxopen = 0 Then
					$testcur = GUIGetCursorInfo($HGUI_CCmain)
					If $testcur[4] = $HTV_CC_1 Then
						click_main_item()
						_ReduceMemory()
					EndIf
				EndIf
			Case $HCB_AH
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "AutoHide", GUICtrlRead($HCB_AH))
			Case $HB_CC_ST_cleareditbox
				$box = "Month= "
				$box &= @MON & @CRLF
				$box &= "Day     = "
				$box &= @MDAY & @CRLF
				$box &= "Time   = "
				$box &= @HOUR & " " & @MIN ;& @CRLF & "-----------------------------------------------------------------" & @CRLF
				GUICtrlSetData($HE_CC_Header, $box)
				GUICtrlSetData($HE_CC_ST_1, "")
				GUICtrlSetState($HE_CC_ST_1, $GUI_FOCUS)
			Case $HB_CC_ST_holdeditpoen
				If $holdeditboxopen = 0 Then
					$holdeditboxopen = 1
					GUICtrlSetState($HP_CC_pic, $GUI_HIDE)
					GUICtrlSetState($HE_CC_ST_1, $GUI_SHOW)
					GUICtrlSetState($HE_CC_Header, $GUI_SHOW)
					_GUICtrlButton_SetImage($HB_CC_ST_holdeditpoen, "shell32.dll", 146, True)
					GUICtrlSetTip($HB_CC_ST_holdeditpoen, "Unlock Edit Box - Save as New Clip")
					GUICtrlSetBkColor($HE_CC_ST_1, 0xddffdd)
					GUICtrlSetState($HE_CC_ST_1, $GUI_FOCUS)
				Else
					$holdeditboxopen = 0
					$edittext = GUICtrlRead($HE_CC_ST_1)
					If WinGetState($HGUI_CCmain) = 5 Then GUISetState(@SW_HIDE, $HGUI_CCeditbox)
					ClipPut($edittext)
					_GUICtrlButton_SetImage($HB_CC_ST_holdeditpoen, "shell32.dll", 44, True)
					GUICtrlSetTip($HB_CC_ST_holdeditpoen, "Lock Edit Box - Use as Scrap Pad")
					GUICtrlSetBkColor($HE_CC_ST_1, 0xffffff)
				EndIf
			Case $GUI_EVENT_MOUSEMOVE
				ToolTip("")
		EndSwitch
		If $iDoubleClick Then
			clip_copy_paste(1, 0)
			$iDoubleClick = 0
		EndIf
		If _IsPressed("26") Or _IsPressed("28") Then
			If WinActive($HGUI_CCmain) And $holdeditboxopen = 0 Then
				$sel = _GUICtrlTreeView_GetSelection($HTV_CC_1)
				If $sel <> $lastselected Or $lastselected < 1 Then
					click_main_item()
					_ReduceMemory()
				EndIf
			EndIf
		EndIf
		If _IsPressed("0D") And WinActive($HGUI_CCmain) Then
			$sel = _GUICtrlTreeView_GetSelection($HTV_CC_1)
			_GUICtrlTreeView_Expand($HTV_CC_1, $sel, Not (_GUICtrlTreeView_GetExpanded($HTV_CC_1, $sel)))
			Sleep(100)
		EndIf
		If _Timer_Diff($keytime) > 15000 Then ToolTip("")
		If WinActive($HGUI_CCmain) = 0 And WinActive($HGUI_CCeditbox) = 0 And GUICtrlRead($HCB_AH) = 1 Then
			If $holdeditboxopen = 0 Then
				GUISetState(@SW_HIDE, $HGUI_CCeditbox)
			EndIf
			GUISetState(@SW_HIDE, $HGUI_CCmain)
			AdlibEnable("_reducememoryx", 60000)
			$timekeep = @WDAY
			While WinActive($HGUI_CCmain) = 0 And WinActive($HGUI_CCeditbox) = 0
				WM_act()
				$mousetest = MouseGetPos()
				If _Timer_Diff($keytime) > 15000 Or $mousetest[0] <> $mousemoved[0] Or $mousetest[1] <> $mousemoved[1] Then ToolTip("")
				Sleep(200)
				If $timekeep <> @WDAY Then
					read_in_array()
					read_into_list()
					$timekeep = @WDAY
				EndIf
			WEnd
			AdlibDisable()
		EndIf
		If $winpoz_save = 1 And Not _IsPressed("01") Then
			winpoz_save()
			$winpoz_save = 0
		EndIf
;~ 		if _IsPressed(11) and _IsPressed(20) Then
;~ 				read_in_array()
;~ 				read_into_list()
;~ 			Diagnossis()
;~ 			EndIf
	WEnd
EndFunc   ;==>_main
Func clip_copy_paste($st = 0, $edit = 0, $freereg = 1)
	If $freereg Then GUIRegisterMsg($WM_DRAWCLIPBOARD, "")
	$sel = _GUICtrlTreeView_GetSelection($HTV_CC_1)
	$iIndex = _ArraySearch($H_array, $sel)
	If $iIndex > 0 Then
		If StringInStr($array[$iIndex], "PICTURE CLIP FILE", 1) Then
			$picfile = StringLeft($array[$iIndex], 12) & StringRight($array[$iIndex], 5) & ".jpg"
			If FileExists($picturefolder & "\" & $picfile) Then
				If $holdeditboxopen = 0 Then
					GUISetState(@SW_HIDE, $HGUI_CCeditbox)
				EndIf
				GUISetState(@SW_HIDE, $HGUI_CCmain)
				ClipPut($picturefolder & "\" & $picfile)
				If $st = 1 Then Send("^v")
				_ReduceMemory()
			Else
				ClipPut("")
			EndIf
		Else
			If $edit = 0 Then $edittext = StringTrimLeft($array[$iIndex], 12)
			If $edit = 1 Then $edittext = GUICtrlRead($HE_CC_ST_1)
			If Not (GUICtrlRead($HCB_AH) <> 1 And $freereg = 0) Then
				If $holdeditboxopen = 0 Or ($st = 1 And $edit = 1) Then
					GUISetState(@SW_HIDE, $HGUI_CCeditbox)
				EndIf
				GUISetState(@SW_HIDE, $HGUI_CCmain)
			EndIf
			ClipPut($edittext)
			If $st = 1 Then Send("^v")
		EndIf
	EndIf
	If $holdeditboxopen = 1 Then
		GUISetState(@SW_SHOW, $HGUI_CCeditbox)
	EndIf
	If GUICtrlRead($HCB_AH) <> 1 Then
		GUISetState(@SW_SHOW, $HGUI_CCeditbox)
		GUISetState(@SW_SHOW, $HGUI_CCmain)
	EndIf
	_ReduceMemory()
	GUIRegisterMsg($WM_DRAWCLIPBOARD, "ClipCaptured")
EndFunc   ;==>clip_copy_paste
Func click_main_item()
	$sel = _GUICtrlTreeView_GetSelection($HTV_CC_1)
	$iIndex = _ArraySearch($H_array, $sel)
	GUICtrlSetState($HP_CC_pic, $GUI_HIDE)
	GUICtrlSetState($HB_CC_nopic, $GUI_HIDE)
	GUICtrlSetState($HE_CC_ST_1, $GUI_HIDE)
	If $iIndex > 0 Then
		_GUICtrlStatusBar_SetText($hStatus_edit, "Clip No. = " & $iIndex)
		$box = "Month= "
		$box &= StringLeft($array[$iIndex], 2) & @CRLF
		$box &= "Day     = "
		$box &= StringMid($array[$iIndex], 3, 2) & @CRLF
		$box &= "Time   = "
		$box &= StringMid($array[$iIndex], 6, 5); & @CRLF ;& "-----------------------------------------------------------------" & @CRLF
		GUICtrlSetData($HE_CC_Header, $box)
		If StringInStr($array[$iIndex], "PICTURE CLIP FILE", 1) Then
			$picfile = StringLeft($array[$iIndex], 12) & StringRight($array[$iIndex], 5) & ".jpg"
			If FileExists($picturefolder & "\" & $picfile) = 0 Then
				GUICtrlSetState($HB_CC_nopic, $GUI_SHOW)
			Else
				$picpos = ControlGetPos($HGUI_CCeditbox, "", $HP_CC_pic)
				GUICtrlSetImage($HP_CC_pic, $picturefolder & "\" & $picfile)
				GUICtrlSetPos($HP_CC_pic, $picpos[0], $picpos[1], $picpos[2], $picpos[3])
				GUICtrlSetState($HP_CC_pic, $GUI_SHOW)
			EndIf
		Else
			$Click = 0
			$box = StringTrimLeft($array[$iIndex], 12)
			GUICtrlSetData($HE_CC_ST_1, $box)
			Sleep(100)
			GUICtrlSetState($HE_CC_ST_1, $GUI_SHOW)
		EndIf
		If dirstructur() = "0" Then
			GUICtrlSetState($HB_filefolder, $GUI_DISABLE)
		Else
			GUICtrlSetState($HB_filefolder, $GUI_ENABLE)
		EndIf
	EndIf
	$lastselected = $sel
EndFunc   ;==>click_main_item
Func dirstructur($selx = 0, $iIndex = 0)
	If $selx <> -1 Then
		$selx = _GUICtrlTreeView_GetSelection($HTV_CC_1)
		$iIndex = _ArraySearch($H_array, $selx)
	EndIf
	If $iIndex < 1 Then Return 0
	$fileloc = StringTrimLeft($array[$iIndex], 12)
	If StringInStr($array[$iIndex], ".") > 0 Then
		$filelocspl = StringSplit($fileloc, "\")
		$filelocdir = ""
		For $x = 1 To $filelocspl[0] - 1
			$filelocdir &= $filelocspl[$x] & "\"
		Next
	Else
		$filelocdir = $fileloc
	EndIf
	If FileExists($filelocdir) Then Return $filelocdir
	Return 0
EndFunc   ;==>dirstructur
Func ClipCaptured()
	GUIRegisterMsg($WM_DRAWCLIPBOARD, "")
	$ispic = 0
	$time = @MON & @MDAY & "-" & @HOUR & " " & @MIN & "  "
	$fred = ClipGet()
	$errorkeep = @error
	$textlast = StringTrimLeft($array[$array[0]], 12)
	$sel = _GUICtrlTreeView_GetSelection($HTV_CC_1)
	$iIndex = _ArraySearch($H_array, $sel)
	If $iIndex < 0 Then $iIndex = 0
	$textsel = StringTrimLeft($array[$iIndex], 12)
	If (($textlast = $fred Or $textsel = $fred Or $fred = "") And $errorkeep = 0) Or StringInStr($fred, "|d|e|l|i|m|") > 0 Then
		GUIRegisterMsg($WM_DRAWCLIPBOARD, "ClipCaptured")
		Return
	EndIf
	SoundPlay($notifysound)
	If $errorkeep = 2 Then
		$pictime1 = @SEC
		$pictime2 = @MSEC
		If StringLen($pictime2) = 2 Then $pictime2 = "0" & $pictime2
		$pictime = $pictime1 & $pictime2
		$hBitmap = _ClipBoard_GetData($CF_BITMAP)
		_ScreenCapture_SaveImage($picturefolder & "\" & $time & $pictime & ".jpg", $hBitmap)
		$fred = ("PICTURE CLIP FILE " & $pictime)
		If DirGetSize($picturefolder) > $maxpicfolder * 1000000 Then
			$x = FileFindFirstFile($picturefolder & "\*.jpg")
			Do
				$x2 = FileFindNextFile($x)
				FileDelete($picturefolder & "\" & $x2)
			Until DirGetSize($picturefolder) < $maxpicfolder * 1000000
		EndIf
		$ispic = 1
	EndIf
	FileWrite($MainFileLocation, $time & $fred & "|d|e|l|i|m|")
	If $backuplocation <> "" Then _backup($fred)
	$array[0] += 1
	If $array[0] > $maxclips Then
		_StripStringsInFile($MainFileLocation, "|d|e|l|i|m|", 1)
		$catch = $array[0]
		_ArrayPush($array, "")
		_ArrayPush($H_array, "")
		_GUICtrlTreeView_Delete($HTV_CC_1, $H_array[0])
		$H_array[0] = 0
		$array[0] = $catch - 1
	EndIf
	$array[$array[0]] = $time & $fred
	If $monthday <> StringLeft($time, 4) Then
		$monthday = StringLeft($time, 4)
		read_in_array()
		read_into_list()
	Else
		$H_array[$array[0]] = _GUICtrlTreeView_AddChild($HTV_CC_1, $HT_DAY[$HT_DAY[0]], StringTrimLeft($time, 5) & StringLeft($fred, 100))
		If $ispic Then
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$array[0]], "shell32.dll", 130)
		ElseIf dirstructur(-1, $array[0]) <> "0" Then
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$array[0]], "shell32.dll", 205)
		Else
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$array[0]], "shell32.dll", 1)
		EndIf
	EndIf
	$keyindex = $array[0]
	_GUICtrlStatusBar_SetText($hStatus, "Number of Clips = " & $array[0])
	If $holdeditboxopen = 0 Then
		_GUICtrlTreeView_SelectItem($HTV_CC_1, $H_array[$array[0]])
		click_main_item()
	EndIf
	_ReduceMemory()
	GUIRegisterMsg($WM_DRAWCLIPBOARD, "ClipCaptured")
	Return $GUI_RUNDEFMSG
EndFunc   ;==>ClipCaptured
Func read_in_array()
	$H_file = FileOpen($MainFileLocation, 128)
	If $H_file <> -1 Then
		$file = FileRead($H_file)
		FileClose($H_file)
		$firstarray = StringSplit($file, "|d|e|l|i|m|", 1)
		For $x = 1 To $firstarray[0] - 1
			$array[$x] = $firstarray[$x]
		Next
		$array[0] = $firstarray[0] - 1
		Dim $firstarray = 0
	EndIf
EndFunc   ;==>read_in_array
Func read_into_list()
	Dim $H_array[$maxclips + 1]
	$HT_DAY[0] = 0
	$day = 0
	$test = 0
	_GUICtrlTreeView_DeleteAll($HTV_CC_1)
	Local $daycount
	If $array[0] = "" Then
		$HT_DAY[1] = _GUICtrlTreeView_Add($HTV_CC_1, 0, StringLeft($monthday, 2) & "-" & StringRight($monthday, 2))
		_GUICtrlTreeView_AddChild($HTV_CC_1, $HT_DAY[1], "EMPTY")
		_GUICtrlTreeView_SetIcon($HTV_CC_1, $HT_DAY[1], "shell32.dll", 1)
		$HT_DAY[0] += 1
	EndIf
	For $x = 1 To $array[0]
		$daycount = StringLeft($array[$x], 4)
		If $daycount <> $day Then
			$HT_DAY[0] += 1
			$HT_DAY[$HT_DAY[0]] = _GUICtrlTreeView_Add($HTV_CC_1, 0, StringLeft($daycount, 2) & "-" & StringRight($daycount, 2))
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $HT_DAY[$HT_DAY[0]], "shell32.dll", 4)
			$day = $daycount
			$test = 1
		EndIf
		$H_array[$x] = _GUICtrlTreeView_AddChild($HTV_CC_1, $HT_DAY[$HT_DAY[0]], StringMid($array[$x], 6, 100))
		If StringInStr($array[$x], "PICTURE CLIP FILE", 1) Then
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$x], "shell32.dll", 130)
		ElseIf dirstructur(-1, $x) <> "0" Then
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$x], "shell32.dll", 205)
		Else
			_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$x], "shell32.dll", 1)
		EndIf
	Next
	If $monthday <> $daycount And $array[0] <> "" Then
		$HT_DAY[$HT_DAY[0]] = _GUICtrlTreeView_Add($HTV_CC_1, 0, StringLeft($monthday, 2) & "-" & StringRight($monthday, 2))
		$newday = _GUICtrlTreeView_AddChild($HTV_CC_1, $HT_DAY[$HT_DAY[0]], "EMPTY")
		_GUICtrlTreeView_SetIcon($HTV_CC_1, $newday, "shell32.dll", 1)
	EndIf
	_GUICtrlTreeView_SetText($HTV_CC_1, $HT_DAY[$HT_DAY[0]], "Today")
	_GUICtrlTreeView_SetIcon($HTV_CC_1, $HT_DAY[$HT_DAY[0]], "shell32.dll", 4)
	_GUICtrlTreeView_Expand($HTV_CC_1, $HT_DAY[$HT_DAY[0]])
	_GUICtrlTreeView_SelectItem($HTV_CC_1, _GUICtrlTreeView_GetLastChild($HTV_CC_1, $HT_DAY[$HT_DAY[0]]))
	click_main_item()
EndFunc   ;==>read_into_list
Func hot_key()
	If BitAND(WinGetState($HGUI_CCmain), 2) Then
		If $holdeditboxopen = 0 Then
			GUISetState(@SW_HIDE, $HGUI_CCeditbox)
		EndIf
		GUISetState(@SW_HIDE, $HGUI_CCmain)
	Else
		GUISetState(@SW_SHOW, $HGUI_CCeditbox)
		GUISetState(@SW_SHOW, $HGUI_CCmain)
	EndIf
	_ReduceMemory()
	Return $GUI_RUNDEFMSG
EndFunc   ;==>hot_key
Func up_key()
	$keyindex -= 1
	If $keyindex < 1 Then $keyindex = 1
	tooltipintoclipboard($keyindex)
	$mousemoved = MouseGetPos()
	Return $GUI_RUNDEFMSG
EndFunc   ;==>up_key
Func down_key()
	$keyindex += 1
	If $keyindex > $array[0] Then $keyindex = $array[0]
	tooltipintoclipboard($keyindex)
	$mousemoved = MouseGetPos()
	Return $GUI_RUNDEFMSG
EndFunc   ;==>down_key
Func tooltipintoclipboard($clip_index)
	$box2 = "Month= "
	$box2 &= StringLeft($array[$clip_index], 2) & @CRLF
	$box2 &= "Day   = "
	$box2 &= StringMid($array[$clip_index], 3, 2) & @CRLF
	$box2 &= "Time  = "
	$box2 &= StringMid($array[$clip_index], 6, 5) & @CRLF & "-----------------------------------------------------------------" & @CRLF
	$box2 &= StringTrimLeft($array[$clip_index], 12)
	ToolTip($box2, Default, Default, "Clip Index " & $clip_index, 1, 5)
	$keytime = _Timer_Init()
	GUIRegisterMsg($WM_DRAWCLIPBOARD, "")
	If StringInStr($array[$clip_index], "PICTURE CLIP FILE", 1) Then
		$picfile = StringLeft($array[$clip_index], 12) & StringRight($array[$clip_index], 5) & ".jpg"
		If FileExists($picturefolder & "\" & $picfile) Then
			ClipPut($picturefolder & "\" & $picfile)
		Else
			ClipPut("")
		EndIf
	Else
		ClipPut(StringTrimLeft($array[$clip_index], 12))
	EndIf
	GUIRegisterMsg($WM_DRAWCLIPBOARD, "ClipCaptured")
	_ReduceMemory()
EndFunc   ;==>tooltipintoclipboard
Func MY_WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
	Local $tagNMHDR, $vEvent
	Switch $wParam
		Case $HTV_CC_1
			$tagNMHDR = DllStructCreate("int;int;int", $lParam)
			If @error Then Return
			$vEvent = DllStructGetData($tagNMHDR, 3)
			If $vEvent = $NM_DBLCLK Then
				$iDoubleClick = 1
			EndIf
			If $vEvent = $NM_CLICK Then
				$Click = 1
			EndIf
	EndSwitch
	_ReduceMemory()
	$tagNMHDR = 0
EndFunc   ;==>MY_WM_NOTIFY
Func WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	_GUICtrlStatusBar_Resize($hStatus)
	_GUICtrlStatusBar_Resize($hStatus_edit)
	$winpoz_save = 1
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE
Func MY_WM_WINDOWPOSCHANGED()
	$winpoz_save = 1
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_WINDOWPOSCHANGED
Func settings()
	GUIRegisterMsg($WM_NOTIFY, "")
	#Region ### START Koda GUI section ### Form=HGUI_settings.kxf
	$HGUI_settings = GUICreate("Settings", 450, 543, 192, 124, -1, -1, $HGUI_CCmain)
	$HC_laws = GUICtrlCreateCheckbox("Load at Windows Startup", 36, 32, 153, 17)
	$HB_S_OK = GUICtrlCreateButton("OK", 320, 496, 113, 33, 0)
	$HB_S_cancle = GUICtrlCreateButton("Cancel", 188, 496, 113, 33, 0)
	GUICtrlCreateGroup("", 12, 12, 421, 277)
	$HI_S_maxclips = GUICtrlCreateInput("", 152, 64, 53, 21)
	GUICtrlCreateLabel("Max Number of Clips", 36, 68, 101, 17)
	$HI_S_backloc = GUICtrlCreateInput("", 152, 148, 269, 21)
	$HB_S_backloc = GUICtrlCreateButton("BackUp Folder", 36, 147, 105, 25, 0)
	$HI_S_notsound = GUICtrlCreateInput("", 152, 228, 269, 21)
	$HB_S_picksound = GUICtrlCreateButton("Notify Sound", 36, 224, 105, 25, 0)
	$HI_S_picturefolder = GUICtrlCreateInput("", 152, 188, 269, 21)
	$HB_S_picfolder = GUICtrlCreateButton("Pictures Folder", 36, 185, 105, 25, 0)
	GUICtrlCreateLabel("Max Size of Picture", 35, 101, 95, 17)
	$HI_S_maxpicfolder = GUICtrlCreateInput("", 151, 105, 53, 21)
	GUICtrlCreateLabel("Folder (MB)", 36, 120, 58, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("HotKeys [ See Help File For More Info ]", 12, 300, 421, 189)
	GUICtrlCreateLabel("Show/Hide Clip Catch", 28, 324, 109, 17)
	GUICtrlCreateLabel("Quick Note Open/Save", 28, 356, 117, 17)
	GUICtrlCreateLabel("Screen Shot", 28, 388, 63, 17)
	GUICtrlCreateLabel("Scroll Back", 28, 420, 58, 17)
	GUICtrlCreateLabel("Scroll Forward", 28, 452, 71, 17)
	$HotkeyInput1 = GUICtrlCreateInput("", 174, 324, 249, 21)
	$HotkeyInput2 = GUICtrlCreateInput("", 174, 356, 249, 21)
	$HotkeyInput3 = GUICtrlCreateInput("", 174, 388, 249, 21)
	$HotkeyInput4 = GUICtrlCreateInput("", 174, 420, 249, 21)
	$HotkeyInput5 = GUICtrlCreateInput("", 174, 452, 249, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	$tooltiptext = "enter hot keys combos in the form below with a space between!  [See Help File For More Info] " & @CR & @CR _
			 & "CTRL" & @CR & "ALT" & @CR & "SHIFT" & @CR & "a - z" & @CR & "0 - 9" & @CR & "F1 - F12" & @CR & "UP" & @CR & "DOWN" _
			 & @CR & "LEFT" & @CR & "RIGHT" & @CR & "SPACE" & @CR & "ENTER" & @CR & "NUMPAD0 - NUMPAD9" & @CR & "NUMPADMULT" _
			 & @CR & "MUNPADADD" & @CR & "NUMPADSUB" & @CR & "NUMPADDIV" & @CR & "NUMPADDOT" & @CR & "NUMPADENTER"
	GUICtrlSetTip($HotkeyInput1, $tooltiptext)
	GUICtrlSetTip($HotkeyInput2, $tooltiptext)
	GUICtrlSetTip($HotkeyInput3, $tooltiptext)
	GUICtrlSetTip($HotkeyInput4, $tooltiptext)
	GUICtrlSetTip($HotkeyInput5, $tooltiptext)
	GUICtrlSetData($HotkeyInput1, $HK1)
	GUICtrlSetData($HotkeyInput2, $HK2)
	GUICtrlSetData($HotkeyInput3, $HK3)
	GUICtrlSetData($HotkeyInput4, $HK4)
	GUICtrlSetData($HotkeyInput5, $HK5)
	GUICtrlSetState($HC_laws, $laws)
	GUICtrlSetData($HI_S_maxclips, $maxclips)
	GUICtrlSetData($HI_S_backloc, $backuplocation)
	GUICtrlSetData($HI_S_picturefolder, $picturefolder)
	GUICtrlSetData($HI_S_notsound, $notifysound)
	GUICtrlSetData($HI_S_maxpicfolder, $maxpicfolder)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($HGUI_settings)
				GUIRegisterMsg($WM_NOTIFY, "MY_WM_NOTIFY")
				Return
			Case $HB_S_cancle
				GUIDelete($HGUI_settings)
				GUIRegisterMsg($WM_NOTIFY, "MY_WM_NOTIFY")
				Return
			Case $HB_S_backloc
				$backuplocation = FileSelectFolder("Backup Location", "", 7, @MyDocumentsDir, $HGUI_settings)
				GUICtrlSetData($HI_S_backloc, $backuplocation)
			Case $HB_S_picfolder
				$picturefolder = FileSelectFolder("Picture folder Location", "", 7, @MyDocumentsDir, $HGUI_settings)
				GUICtrlSetData($HI_S_picturefolder, $picturefolder)
			Case $HB_S_picksound
				$notifysound = FileOpenDialog("Picture Notify Sound", @WindowsDir & "\media", "wav(*.wav)", 1, "", $HGUI_settings)
				GUICtrlSetData($HI_S_notsound, $notifysound)
			Case $HB_S_OK
				HotKeySet(_HotKeyConvert($HK1))
				HotKeySet(_HotKeyConvert($HK2))
				HotKeySet(_HotKeyConvert($HK3))
				HotKeySet(_HotKeyConvert($HK4))
				HotKeySet(_HotKeyConvert($HK5))
				$HK1 = GUICtrlRead($HotkeyInput1)
				$HK2 = GUICtrlRead($HotkeyInput2)
				$HK3 = GUICtrlRead($HotkeyInput3)
				$HK4 = GUICtrlRead($HotkeyInput4)
				$HK5 = GUICtrlRead($HotkeyInput5)
				HotKeySet(_HotKeyConvert($HK1), "hot_key")
				HotKeySet(_HotKeyConvert($HK2), "quicknote")
				HotKeySet(_HotKeyConvert($HK3), "SS_ctrl")
				HotKeySet(_HotKeyConvert($HK4), "up_key")
				HotKeySet(_HotKeyConvert($HK5), "down_key")
				$laws = GUICtrlRead($HC_laws)
				$maxclips = GUICtrlRead($HI_S_maxclips)
				$backuplocation = GUICtrlRead($HI_S_backloc)
				$picturefolder = GUICtrlRead($HI_S_picturefolder)
				$notifysound = GUICtrlRead($HI_S_notsound)
				$maxpicfolder = GUICtrlRead($HI_S_maxpicfolder)
				If $maxclips < 10 Then $maxclips = 10
				$catch = $array[0]
				Dim $array[$maxclips + 1]
				$array[0] = $catch
				If $array[0] > $maxclips Then
					_StripStringsInFile($MainFileLocation, "|d|e|l|i|m|", $array[0] - $maxclips)
					_GUICtrlStatusBar_SetText($hStatus, "Number of Clips = " & $maxclips)
				EndIf
				read_in_array()
				read_into_list()
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK1", $HK1)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK2", $HK2)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK3", $HK3)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK4", $HK4)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "HK5", $HK5)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "laws", $laws)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "maxclips", $maxclips)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "backloc", $backuplocation)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "picturefolder", $picturefolder)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "notifysound", $notifysound)
				IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "main", "maxpicfolder", $maxpicfolder)
				If $laws = 1 Then
					RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "JDcc_startup", "REG_SZ", @ProgramFilesDir & "\jdClipCatch\jdClipCatch.exe tray")
				Else
					RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "jdcc_startup")
				EndIf
				GUIDelete($HGUI_settings)
				_ReduceMemory()
				GUIRegisterMsg($WM_NOTIFY, "MY_WM_NOTIFY")
				Return
		EndSwitch
	WEnd
EndFunc   ;==>settings
Func _search($find)
	Dim $H_array[$maxclips + 1]
	$findcount = 0
	_GUICtrlTreeView_DeleteAll($HTV_CC_1)
	For $x = 1 To $array[0]
		If StringInStr($array[$x], $find) Then
			$H_array[$x] = _GUICtrlTreeView_Add($HTV_CC_1, 0, $array[$x])
			If StringInStr($array[$x], "PICTURE CLIP FILE", 1) Then
				_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$x], "shell32.dll", 130)
			ElseIf dirstructur(-1, $x) <> "0" Then
				_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$x], "shell32.dll", 205)
			Else
				_GUICtrlTreeView_SetIcon($HTV_CC_1, $H_array[$x], "shell32.dll", 1)
			EndIf
			$findcount += 1
		EndIf
	Next
	If $findcount = 0 Then
		$nothing = _GUICtrlTreeView_Add($HTV_CC_1, 0, "NOTHING FOUND")
		_GUICtrlTreeView_SetIcon($HTV_CC_1, $nothing, "shell32.dll", 131)
	EndIf
	_GUICtrlStatusBar_SetText($hStatus, "Number of Found Clips = " & $findcount)
EndFunc   ;==>_search
Func _StripStringsInFile($szFileName, $dilamiter, $szNumber)
	$hFile = FileOpen($szFileName, 128)
	$s_TotFile = FileRead($hFile)
	$aFileLines = StringSplit($s_TotFile, $dilamiter, 1)
	FileClose($hFile)
	$hWriteHandle = FileOpen($szFileName, 130)
	For $x = 2 + $szNumber To $aFileLines[0]
		FileWrite($hWriteHandle, $aFileLines[$x - 1] & $dilamiter)
	Next
	FileClose($hWriteHandle)
EndFunc   ;==>_StripStringsInFile
Func Diagnossis()
;~ $maxclips
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $maxclips = ' & $maxclips & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	$sel = _GUICtrlTreeView_GetSelection($HTV_CC_1)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sel = ' & $sel & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	$iIndex = _ArraySearch($H_array, $sel)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iIndex = ' & $iIndex & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	_ArrayDisplay($array, "Array")
	_ArrayDisplay($H_array, "H_Array")
	_ArrayDisplay($HT_DAY, "HT_DAY")
EndFunc   ;==>Diagnossis
Func WM_act()
	$win_han = WinGetHandle("[active]")
	If $win_han <> $oldwin_han Then
		GUIRegisterMsg($WM_DRAWCLIPBOARD, "")
		_ClipBoard_SetViewer($HGUI_CCmain)
		GUIRegisterMsg($WM_DRAWCLIPBOARD, "ClipCaptured")
		$oldwin_han = $win_han
	EndIf
EndFunc   ;==>WM_act
Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	If $hWnd = $HGUI_CCmain Then
		$minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
		DllStructSetData($minmaxinfo, 7, 400); min X
		DllStructSetData($minmaxinfo, 8, 250); min Y
	EndIf
	If $hWnd = $HGUI_CCeditbox Then
		$minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
		DllStructSetData($minmaxinfo, 7, 235); min X
		DllStructSetData($minmaxinfo, 8, 250); min Y
	EndIf
	Return 0
EndFunc   ;==>MY_WM_GETMINMAXINFO
Func _backup($fredx)
	$H_file = FileOpen($backuplocation & "\jdcc_backup.log", 129)
	FileWrite($H_file, @YEAR & " " & @MON & " " & @MDAY & "  " & @HOUR & ":" & @MIN & ":" & @SEC & "  " & $fredx & @CRLF & @CRLF)
	FileClose($H_file)
	If (FileGetSize($backuplocation & "\jdcc_backup.log") / 1024) > 1000 Then
		FileCopy($backuplocation & "\jdcc_backup.log", $backuplocation & "\" & @YEAR & " " & @MON & " " & @MDAY & "  jdcc_backup.log")
		FileDelete($backuplocation & "\jdcc_backup.log")
	EndIf
EndFunc   ;==>_backup
Func quicknote()
	If $holdeditboxopen = 0 Then
		$holdeditboxopen = 1
		GUISetState(@SW_SHOW, $HGUI_CCeditbox)
		GUICtrlSetState($HP_CC_pic, $GUI_HIDE)
		GUICtrlSetState($HE_CC_ST_1, $GUI_SHOW)
		GUICtrlSetState($HE_CC_Header, $GUI_SHOW)
		_GUICtrlButton_SetImage($HB_CC_ST_holdeditpoen, "shell32.dll", 146, True)
		GUICtrlSetTip($HB_CC_ST_holdeditpoen, "Unlock Edit Box - Save as New Clip")
		GUICtrlSetBkColor($HE_CC_ST_1, 0xddffdd)
		$box = "Month= "
		$box &= @MON & @CRLF
		$box &= "Day     = "
		$box &= @MDAY & @CRLF
		$box &= "Time   = "
		$box &= @HOUR & " " & @MIN ;& @CRLF & "-----------------------------------------------------------------" & @CRLF
		GUICtrlSetData($HE_CC_Header, $box)
		GUICtrlSetData($HE_CC_ST_1, "")
		GUICtrlSetState($HE_CC_ST_1, $GUI_FOCUS)
	Else
		$holdeditboxopen = 0
		$edittext = GUICtrlRead($HE_CC_ST_1)
		ClipPut($edittext)
		_GUICtrlButton_SetImage($HB_CC_ST_holdeditpoen, "shell32.dll", 44, True)
		GUICtrlSetTip($HB_CC_ST_holdeditpoen, "Lock Edit Box - Use as Scrap Pad")
		GUICtrlSetBkColor($HE_CC_ST_1, 0xffffff)
		If WinGetState($HGUI_CCmain) = 5 Then GUISetState(@SW_HIDE, $HGUI_CCeditbox)
	EndIf
EndFunc   ;==>quicknote
Func _reducememoryx()
	_ReduceMemory()
EndFunc   ;==>_reducememoryx
Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
Func SS_Ctrl()
	HotKeySet(_HotKeyConvert($HK3))
	$oldWhnd = 0
	Opt("MouseCoordMode", 1)
	$screenshotform = GUICreate("Form1", 216, 80, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	GUISetBkColor(0x000000)
	GUICtrlSetDefColor(0x00ff00)
	$Label1 = GUICtrlCreateLabel("ESCAPE KEY - Cancel", 4, 4, 210, 28, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("MOUSE BUTTON - take shot", 4, 28, 210, 28, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("HOLD SHIFT - Freehand", 4, 52, 210, 28, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUISetState()
	While 1
		Sleep(50)
		$pos = _WinAPI_GetMousePos()
		$W_or_ctrl_hnd = _WinAPI_WindowFromPoint($pos)
		If DllStructGetData($pos, "X") < 276 And DllStructGetData($pos, "Y") < 94 Then
			GUISetState(@SW_HIDE, $screenshotform)
		Else
			GUISetState(@SW_SHOW, $screenshotform)
		EndIf
		If $W_or_ctrl_hnd <> $oldWhnd Then
			_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
			Sleep(200)
			If WinExists($W_or_ctrl_hnd) Then
				$winpos = hilightwin($W_or_ctrl_hnd)
				$oldWhnd = $W_or_ctrl_hnd
			EndIf
		EndIf
		If _IsPressed("01") Then
			SS_return()
			Sleep(200)
			$Hbit = _ScreenCapture_Capture("", $winpos[0], $winpos[1], $winpos[2], $winpos[3], False)
			_ClipBoard_SetData($Hbit, $CF_BITMAP)
			Return
		EndIf
		If _IsPressed("1B") Then
			SS_return()
			Return
		EndIf
		If _IsPressed("10") Then
			$oldWhnd = 0
			GUISetState(@SW_HIDE, $screenshotform)
			If freehand() = 1 Then
				SS_return()
				Return
			EndIf
			GUISetState(@SW_SHOW, $screenshotform)
		EndIf
	WEnd
EndFunc   ;==>SS_Ctrl
Func SS_return()
	_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	GUIDelete($screenshotform)
	GUIDelete($guipicwindow)
	Opt("MouseCoordMode", 2)
	HotKeySet(_HotKeyConvert($HK3), "SS_ctrl")
	_ReduceMemory()
EndFunc   ;==>SS_return
Func hilightwin($Hwin)
	Local $hDC, $hPen, $obj_orig
	Local $winposx[4]
	$winpos = WinGetPos($Hwin)
	$hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
	$hPen = _WinAPI_CreatePen($PS_SOLID, 5, 0x00ff00)
	$obj_orig = _WinAPI_SelectObject($hDC, $hPen)
	$winposx[0] = $winpos[0]
	$winposx[1] = $winpos[1]
	$winposx[2] = $winpos[0] + $winpos[2]
	$winposx[3] = $winpos[1] + $winpos[3]
	_WinAPI_DrawLine($hDC, $winposx[0] + 3, $winposx[1] + 3, $winposx[2] - 3, $winposx[1] + 3)
	_WinAPI_DrawLine($hDC, $winposx[2] - 3, $winposx[1] + 3, $winposx[2] - 3, $winposx[3] - 3)
	_WinAPI_DrawLine($hDC, $winposx[2] - 3, $winposx[3] - 3, $winposx[0] + 3, $winposx[3] - 3)
	_WinAPI_DrawLine($hDC, $winposx[0] + 3, $winposx[3] - 3, $winposx[0] + 3, $winposx[1] + 3)
	_WinAPI_SelectObject($hDC, $obj_orig)
	_WinAPI_DeleteObject($hPen)
	_WinAPI_ReleaseDC(0, $hDC)
	Return $winposx
EndFunc   ;==>hilightwin
Func freehand()
	_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp, $take_shot = 0, $check = 0
	Local $UserDLL = DllOpen("user32.dll")
	$VirtualDesktopWidth = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 78)
	$VirtualDesktopWidth = $VirtualDesktopWidth[0]
	$screenshotformfreehand = GUICreate("", 210, 64, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW), $guipicwindow)
	GUISetBkColor(0x000000)
	GUICtrlSetDefColor(0x00ff00)
	$Label1 = GUICtrlCreateLabel("FREEHAND MODE", 12, 6, 210, 14, $SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	$Label1 = GUICtrlCreateLabel("Select area by dragging mouse" & @CR & "Release shif to cancel", 12, 24, 197, 38)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW, $screenshotformfreehand)
	$hCross_GUI = GUICreate("Test", $VirtualDesktopWidth, @DesktopHeight - 20, @DesktopWidth - $VirtualDesktopWidth, 0, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	WinSetTrans($hCross_GUI, "", 8)
	GUISetState(@SW_SHOW, $hCross_GUI)
	GUISetCursor(3, 1, $hCross_GUI)
	Global $hRectangle_GUI = GUICreate("FreeHand", $VirtualDesktopWidth, @DesktopHeight, @DesktopWidth - $VirtualDesktopWidth, 0, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	GUISetBkColor(0x00ff00)
	While _IsPressed("10")
		Opt("MouseCoordMode", 0)
		$aMouse_Pos = MouseGetPos()
		$iX1 = $aMouse_Pos[0]
		$iY1 = $aMouse_Pos[1]
		While _IsPressed("01", $UserDLL)
			$take_shot = 1
			$aMouse_Pos = MouseGetPos()
			$hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
			$hMask = _WinAPI_CreateRectRgn($iX1, $aMouse_Pos[1], $aMouse_Pos[0], $aMouse_Pos[1] + 3); Bottom of rectangle
			_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
			$hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 3, $aMouse_Pos[1]); Left of rectangle
			_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
			$hMask = _WinAPI_CreateRectRgn($iX1 + 3, $iY1 + 3, $aMouse_Pos[0], $iY1); Top of rectangle
			_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
			$hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 3, $aMouse_Pos[1]); Right of rectangle
			_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
			_WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)
			If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
			If Not _IsPressed("10") Then
				$take_shot = 0
				Do
					Sleep(50)
				Until Not _IsPressed("01")
				ExitLoop
			EndIf
			Sleep(10)
		WEnd
		$iX2 = $aMouse_Pos[0]
		$iY2 = $aMouse_Pos[1]
		If $iX2 < $iX1 Then
			$iTemp = $iX1
			$iX1 = $iX2
			$iX2 = $iTemp
		EndIf
		If $iY2 < $iY1 Then
			$iTemp = $iY1
			$iY1 = $iY2
			$iY2 = $iTemp
		EndIf
		If $take_shot = 1 Then
			GUISetState(@SW_HIDE, $hRectangle_GUI)
			GUISetState(@SW_HIDE, $screenshotformfreehand)
			Sleep(100)
			$Hbit = _ScreenCapture_Capture("", $iX1 - ($VirtualDesktopWidth - @DesktopWidth), $iY1, $iX2 - ($VirtualDesktopWidth - @DesktopWidth), $iY2, False)
			_ClipBoard_SetData($Hbit, $CF_BITMAP)
			$check = 1
			$take_shot = 0
			GUISetState(@SW_SHOW, $screenshotformfreehand)
			GUISetState(@SW_SHOW, $hRectangle_GUI)
		EndIf
	WEnd
	GUIDelete($screenshotformfreehand)
	GUIDelete($hCross_GUI)
	GUIDelete($hRectangle_GUI)
	DllClose($UserDLL)
	_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	Return $check
EndFunc   ;==>freehand
Func _HotKeyConvert($iKey)
	$ikey_split = StringSplit($iKey, " ")
	Local $sKey = ""
	For $x = 1 To $ikey_split[0] - 1
		Switch $ikey_split[$x]
			Case "SHIFT"
				$sKey &= "+"
			Case "CTRL"
				$sKey &= "^"
			Case "ALT"
				$sKey = "!"
		EndSwitch
	Next
	Switch $ikey_split[$ikey_split[0]]
		Case "UP"
			$sKey &= "{UP}"
			Return $sKey
		Case "DOWN"
			$sKey &= "{DOWN}"
			Return $sKey
		Case "LEFT"
			$sKey &= "{LEFT}"
			Return $sKey
		Case "RIGHT"
			$sKey &= "{RIGHT}"
			Return $sKey
		Case "SPACE"
			$sKey &= "{SPACE}"
			Return $sKey
		Case "ENTER"
			$sKey &= "{ENTER}"
			Return $sKey
		Case "F1"
			$sKey &= "{F1}"
			Return $sKey
		Case "F2"
			$sKey &= "{F2}"
			Return $sKey
		Case "F3"
			$sKey &= "{F3}"
			Return $sKey
		Case "F4"
			$sKey &= "{F4}"
			Return $sKey
		Case "F5"
			$sKey &= "{F5}"
			Return $sKey
		Case "F6"
			$sKey &= "{F6}"
			Return $sKey
		Case "F7"
			$sKey &= "{F7}"
			Return $sKey
		Case "F8"
			$sKey &= "{F8}"
			Return $sKey
		Case "F9"
			$sKey &= "{F9}"
			Return $sKey
		Case "F10"
			$sKey &= "{F10}"
			Return $sKey
		Case "F11"
			$sKey &= "{F11}"
			Return $sKey
		Case "F12"
			$sKey &= "{F12}"
			Return $sKey
		Case "NUMPAD0"
			$sKey &= "{NUMPAD0}"
			Return $sKey
		Case "NUMPAD1"
			$sKey &= "{NUMPAD1}"
			Return $sKey
		Case "NUMPAD2"
			$sKey &= "{NUMPAD2}"
			Return $sKey
		Case "NUMPAD3"
			$sKey &= "{NUMPAD3}"
			Return $sKey
		Case "NUMPAD4"
			$sKey &= "{NUMPAD4}"
			Return $sKey
		Case "NUMPAD5"
			$sKey &= "{NUMPAD5}"
			Return $sKey
		Case "NUMPAD6"
			$sKey &= "{NUMPAD6}"
			Return $sKey
		Case "NUMPAD7"
			$sKey &= "{NUMPAD7}"
			Return $sKey
		Case "NUMPAD8"
			$sKey &= "{NUMPAD8}"
			Return $sKey
		Case "NUMPAD9"
			$sKey &= "{NUMPAD9}"
			Return $sKey
		Case "NUMPADMULT"
			$sKey &= "{NUMPADMULT}"
			Return $sKey
		Case "NUMPADADD"
			$sKey &= "{NUMPADADD}"
			Return $sKey
		Case "NUMPADSUB"
			$sKey &= "{NUMPADSUB}"
			Return $sKey
		Case "NUMPADDIV"
			$sKey &= "{NUMPADDIV}"
			Return $sKey
		Case "NUMPADDOT"
			$sKey &= "{NUMPADDOT}"
			Return $sKey
		Case "NUMPADENTER"
			$sKey &= "{NUMPADENTER}"
			Return $sKey
	EndSwitch
	$sKey &= StringLower($ikey_split[$ikey_split[0]])
	Return $sKey
EndFunc   ;==>_HotKeyConvert
Func winpoz_save()
	$mainpos = WinGetPos($HGUI_CCmain)
	$Editpos = WinGetPos($HGUI_CCeditbox)
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_x", $mainpos[0])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_y", $mainpos[1])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_xsiz", $mainpos[2])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Main_ysiz", $mainpos[3])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_x", $Editpos[0])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_y", $Editpos[1])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_xsiz", $Editpos[2])
	IniWrite(@AppDataDir & "\JDclipcatch\JDcc.ini", "Pos", "Edit_ysiz", $Editpos[3])
EndFunc   ;==>winpoz_save