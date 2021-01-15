#include<GUIConstants.au3>
#include<GUIStatusbar.au3>
#include<GuiCombo.au3>
#include<GuiListView.au3>
#include<IE.au3>
#include<INet.au3>
#include<Misc.au3>

_Singleton("Web Browser")

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
Opt("GUICloseOnEsc", 0)
Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 1)
TrayCreateItem("Quit")
TrayItemSetOnEvent(-1, "_Exit")
TraySetState()

Global $Width = 800, $Height = 600, $Homeurl = "about:blank", $ScreenMode = 0, $a_PartsRightEdge[2] = [600, -1], $s_PartText[2] = ["", ""]
Global $Bool = 1, $Bookmark[256], $BookmarkDir[256], $Amount = 0, $configuse = 0, $config_frm, $main_frm, $sourceuse = 0, $source_frm, $source_edit, $History_frm
Global $Home_Input, $urlinput, $Blank = "", $historystate = 0, $Listview, $find_input

_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()
$main_frm = GUICreate("Web Browser", $Width, $Height, -1, -1, $WS_SIZEBOX + $WS_MINIMIZEBOX + $WS_CAPTION + $WS_POPUP + $WS_SYSMENU + $WS_MAXIMIZEBOX)
$filemenu = GUICtrlCreateMenu("File")
$fileopen = GUICtrlCreateMenuItem("Open", $filemenu)
$filesave = GUICtrlCreateMenuItem("Save As", $filemenu)
$Seperator1 = GUICtrlCreateMenuItem("", $filemenu)
$fileexit = GUICtrlCreateMenuItem("Exit", $filemenu)
$viewmenu = GUICtrlCreateMenu("View")
$viewsource = GUICtrlCreateMenuItem("View Source", $viewmenu)
$viewhistory = GUICtrlCreateMenuItem("View History", $viewmenu)
$Seperator2 = GUICtrlCreateMenuItem("", $viewmenu)
$viewstatus = GUICtrlCreateMenuItem("View Statusbar", $viewmenu)
$favmenu = GUICtrlCreateMenu("Favorite")
$favadd = GUICtrlCreateMenuItem("Add current page as favorite", $favmenu)
$Seperator3 = GUICtrlCreateMenuItem("", $favmenu)
$optionmenu = GUICtrlCreateMenu("Options")
$optionconfig = GUICtrlCreateMenuItem("Configuration", $optionmenu)
$IEObj = GUICtrlCreateObj($oIE, 10, 2, 780, 490)
$backbtn = GUICtrlCreateButton("", 10, 495, 40, 40, $BS_ICON)
$forwardbtn = GUICtrlCreateButton("", 55, 495, 40, 40, $BS_ICON)
$stopbtn = GUICtrlCreateButton("", 100, 495, 40, 40, $BS_ICON)
$homebtn = GUICtrlCreateButton("", 145, 495, 40, 40, $BS_ICON)
$Printbtn = GUICtrlCreateButton("", 190, 495, 40, 40, $BS_ICON)
$configbtn = GUICtrlCreateButton("", 235, 495, 40, 40, $BS_ICON)
$searchbtn = GUICtrlCreateButton("", 280, 495, 40, 40, $BS_ICON)
$helpbtn = GUICtrlCreateButton("", 750, 495, 40, 40, $BS_ICON)
$searchinput = GUICtrlCreateInput("Search for...Supported by Google(C)", 325, 495, 375, 20)
$urlinput = GUICtrlCreateCombo("", 325, 517, 375, 20, -1)
$loadurl = GUICtrlCreateButton("", 705, 495, 40, 40, $BS_ICON)
$statusbar = _GUICtrlStatusBarCreate($main_frm, $a_PartsRightEdge, $s_PartText)
$progress = _GUICtrlStatusBarCreateProgress($statusbar, 1)
GUICtrlSetOnEvent($backbtn, "_NavigateBack")
GUICtrlSetOnEvent($forwardbtn, "_NavigateFoward")
GUICtrlSetOnEvent($stopbtn, "_NavigateStop")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_RESIZED, "_Resize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "_Resize")
GUISetOnEvent($GUI_EVENT_RESTORE, "_Resize")
GUICtrlSetOnEvent($fileopen, "_OpenFile")
GUICtrlSetOnEvent($filesave, "_SaveAs")
GUICtrlSetOnEvent($fileexit, "_Exit")
GUICtrlSetOnEvent($viewsource, "_ViewSource")
GUICtrlSetOnEvent($homebtn, "_ViewHome")
GUICtrlSetOnEvent($Printbtn, "_PrintPage")
GUICtrlSetOnEvent($searchbtn, "_Search")
GUICtrlSetOnEvent($loadurl, "_LoadURL")
GUICtrlSetOnEvent($viewstatus, "_StatusBar")
GUICtrlSetOnEvent($helpbtn, "_HelpInfo")
GUICtrlSetOnEvent($favadd, "_AddFavor")
GUICtrlSetOnEvent($configbtn, "_Configuration")
GUICtrlSetOnEvent($optionconfig, "_Configuration")
GUICtrlSetOnEvent($viewhistory, "_ViewHistory")
GUICtrlSetState($viewstatus, $GUI_CHECKED)
GUICtrlSetImage($backbtn, "shell32.dll", 146)
GUICtrlSetImage($forwardbtn, "shell32.dll", 137)
GUICtrlSetImage($stopbtn, "shell32.dll", 109)
GUICtrlSetImage($homebtn, "shell32.dll", 150)
GUICtrlSetImage($Printbtn, "shell32.dll", 16)
GUICtrlSetImage($configbtn, "shell32.dll", 165)
GUICtrlSetImage($searchbtn, "shell32.dll", 22)
GUICtrlSetImage($helpbtn, "shell32.dll", 23)
GUICtrlSetImage($loadurl, "shell32.dll", 137)
GUICtrlSetData($urlinput, $Homeurl, $Homeurl)
GUISetState()

_IENavigate($oIE, $Homeurl, 0)
_GUICtrlComboInitStorage($urlinput, 26, 50)
_CreateHistory()

While 1
	_UpdateCheck()
	_UpdateHistory()
	_ControlCheck()
	Sleep(1)
WEnd
Func _NavigateBack()
	_IEAction($oIE, "back")
EndFunc   ;==>_NavigateBack
Func _NavigateFoward()
	_IEAction($oIE, "forward")
EndFunc   ;==>_NavigateFoward
Func _NavigateStop()
	_IEAction($oIE, "stop")
EndFunc   ;==>_NavigateStop
Func _Exit()
	Exit
EndFunc   ;==>_Exit
Func _Openfile()
	Local $File
	$File = FileOpenDialog("Please select file", @DesktopDir, "html(*.html)|htm(*.htm)", 1 + 2)
	If @error = 1 Then
		Return
	Else
		_IENavigate($oIE, $File, 0)
	EndIf
EndFunc   ;==>_Openfile
Func _SaveAs()
	_IEAction($oIE, "saveas")
EndFunc   ;==>_SaveAs
Func _ViewSource()
	If $sourceuse Then Return
	$sourceuse = Not $sourceuse
	$source_frm = GUICreate("Source Viewer - " & _IEPropertyGet($oIE, "locationname"), 300, 300, -1, -1, -1, -1, $main_frm)
	$source_edit = GUICtrlCreateEdit("", 2, 2, 296, 256, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL + $WS_HSCROLL + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL)
	$refresh_btn = GUICtrlCreateButton("Update", 105, 265, 90, 30, $BS_CENTER)
	GUICtrlSetOnEvent($refresh_btn, "_RefreshSource")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_SourceDelete")
	GUICtrlSetState($viewsource, $GUI_CHECKED)
	GUISetState()
	_RefreshSource()
EndFunc   ;==>_ViewSource
Func _ViewHome()
	_IENavigate($oIE, $Homeurl, 0)
EndFunc   ;==>_ViewHome
Func _PrintPage()
	_IEAction($oIE, "print")
EndFunc   ;==>_PrintPage
Func _Search()
	Local $Read
	If GUICtrlRead($searchinput) = "" Then
		GUICtrlSetData($searchinput, "Search for...Supported by Google(C)")
		Return
	Else
		$Read = GUICtrlRead($searchinput)
		_IENavigate($oIE, "http://www.google.com", 0)
		$oForm = _IEFormGetCollection($oIE, 0)
		$oQuery = _IEFormElementGetCollection($oForm, 1)
		_IEFormElementSetValue($oQuery, $Read)
		_IEFormSubmit($oForm)
	EndIf
EndFunc   ;==>_Search
Func _LoadURL()
	Local $Read
	$Read = GUICtrlRead($urlinput)
	_IENavigate($oIE, $Read, 0)
EndFunc   ;==>_LoadURL
Func _UpdateCheck()
	If Not _IEPropertyGet($oIE, "busy") Then
		_GUICtrlStatusBarSetIcon($statusbar, 0, "shell32.dll", 176)
		_GUICtrlStatusBarSetText($statusbar, "Done")
		GUICtrlSetData($progress, 100)
	ElseIf _IEPropertyGet($oIE, "busy") Then
		_GUICtrlStatusBarSetIcon($statusbar, 0, "shell32.dll", 159)
		For $i = 0 To 100
			_GUICtrlStatusBarSetText($statusbar, "Loading..." & _IEPropertyGet($oIE, "locationurl"))
			ControlSetText($main_frm, "", "Edit2", _IEPropertyGet($oIE, "locationurl"))
			GUICtrlSetData($progress, $i)
			Sleep(5)
		Next
	EndIf
	_GUICtrlComboAutoComplete($urlinput, $Blank)
	WinSetTitle($main_frm, "", "Web Browser - " & _IEPropertyGet($oIE, "title"))
EndFunc   ;==>_UpdateCheck
Func _HelpInfo()
	MsgBox(64, "Version Info", "Platform & Version :" & _IEPropertyGet($oIE, "appversion"))
EndFunc   ;==>_HelpInfo
Func _StatusBar()
	$Bool = Not $Bool
	If Not $Bool Then
		_GUICtrlStatusBarShowHide($statusbar, @SW_HIDE)
		GUICtrlSetState($viewstatus, $GUI_UNCHECKED)
	Else
		_GUICtrlStatusBarShowHide($statusbar, @SW_SHOW)
		GUICtrlSetState($viewstatus, $GUI_CHECKED)
	EndIf
EndFunc   ;==>_StatusBar
Func _AddFavor()
	If _IEPropertyGet($oIE, "locationurl") = "about:blank" Then Return
	$Bookmark[$Amount] = GUICtrlCreateMenuItem(_IEPropertyGet($oIE, "title"), $favmenu)
	$BookmarkDir[$Amount] = _IEPropertyGet($oIE, "locationurl")
	GUICtrlSetOnEvent(-1, "_LoadFavor")
	$Amount += 1
	If $Amount > 253 Then
		GUICtrlSetState($favadd, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_AddFavor
Func _LoadFavor()
	Local $Id = @GUI_CtrlHandle
	For $i = 0 To UBound($Bookmark, 1) - 1
		If GUICtrlGetHandle($Bookmark[$i]) = $Id Then
			_IENavigate($oIE, $BookmarkDir[$i])
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_LoadFavor
Func _Configuration()
	If $configuse Then Return
	$configuse = Not $configuse
	$config_frm = GUICreate("Configuration", 500, 45, -1, -1, -1, -1, $main_frm)
	$Home_SetBlank = GUICtrlCreateButton("", 2, 2, 40, 40, $BS_ICON)
	$Home_Show = GUICtrlCreateButton("", 47, 2, 40, 40, $BS_ICON)
	$Apply_Button = GUICtrlCreateButton("", 455, 2, 40, 40, $BS_ICON)
	$Home_Input = GUICtrlCreateInput($Homeurl, 90, 12, 360, 20)
	GUICtrlSetImage($Apply_Button, "shell32.dll", 137)
	GUICtrlSetImage($Home_Show, "shell32.dll", 150)
	GUICtrlSetImage($Home_SetBlank, "shell32.dll", 0)
	GUICtrlSetOnEvent($Home_SetBlank, "_SetBlank")
	GUICtrlSetOnEvent($Home_Show, "_ShowHome")
	GUICtrlSetOnEvent($Apply_Button, "_ApplyConfig")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_ConfigDelete")
	GUISetState()
EndFunc   ;==>_Configuration
Func _ConfigDelete()
	$configuse = Not $configuse
	GUIDelete($config_frm)
EndFunc   ;==>_ConfigDelete
Func _SourceDelete()
	$sourceuse = Not $sourceuse
	GUICtrlSetState($viewsource, $GUI_UNCHECKED)
	GUIDelete($source_frm)
EndFunc   ;==>_SourceDelete
Func _ShowHome()
	GUICtrlSetData($Home_Input, $Homeurl)
EndFunc   ;==>_ShowHome
Func _SetBlank()
	GUICtrlSetData($Home_Input, "about:blank")
EndFunc   ;==>_SetBlank
Func _ApplyConfig()
	$Homeurl = GUICtrlRead($Home_Input)
	_ConfigDelete()
EndFunc   ;==>_ApplyConfig
Func _Resize()
	_GUICtrlStatusBarResize($statusbar)
EndFunc   ;==>_Resize
Func _RefreshSource()
	WinSetTitle($source_frm, "", "Source Viewer - " & _IEPropertyGet($oIE, "locationname"))
	GUICtrlSetData($source_edit, StringReplace(_INetGetSource(_IEPropertyGet($oIE, "locationurl")), ">", ">" & @CRLF))
EndFunc   ;==>_RefreshSource
Func _ControlCheck()
	If ControlGetFocus($main_frm, "") = "Edit2" And _IsPressed("0D") Then
		If GUICtrlRead($urlinput) = "" Then Return
		Do
			Sleep(1)
		Until Not _IsPressed("0D")
		_LoadURL()
		_ComboStringManage()
	EndIf
EndFunc   ;==>_ControlCheck
Func _ComboStringManage()
	Local $Read
	$Read = GUICtrlRead($urlinput)
	If _GUICtrlComboGetCount($urlinput) > 25 Then
		_GUICtrlComboDeleteString($urlinput, 24)
		_ComboStringSearch($Read)
	Else
		_ComboStringSearch($Read)
	EndIf
EndFunc   ;==>_ComboStringManage
Func _ComboStringSearch($Read)
	If _GUICtrlComboFindString($urlinput, $Read) = $CB_ERR Then
		_GUICtrlComboAddString($urlinput, $Read)
		_GUICtrlComboSelectString($urlinput, 0, $Read)
	Else
		_GUICtrlComboSelectString($urlinput, 0, $Read)
	EndIf
EndFunc   ;==>_ComboStringSearch
Func _CreateHistory()
	$History_frm = GUICreate("View History", 400, 400, -1, -1, -1, -1, $main_frm)
	$Listview = GUICtrlCreateListView("Title|URL", 2, 2, 396, 350, -1)
	$find_btn = GUICtrlCreateButton("", 2, 355, 40, 40, $BS_ICON)
	$find_input = GUICtrlCreateInput("Enter Keyword to search....", 45, 365, 260, 20)
	$delete_history = GUICtrlCreateButton("", 310, 355, 40, 40, $BS_ICON)
	$load_history = GUICtrlCreateButton("", 355, 355, 40, 40, $BS_ICON)
	GUICtrlSetImage($delete_history, "shell32.dll", 131)
	GUICtrlSetImage($find_btn, "shell32.dll", 22)
	GUICtrlSetImage($load_history, "shell32.dll", 137)
	GUICtrlSetOnEvent($find_btn, "_FindHistory")
	GUICtrlSetOnEvent($load_history, "_LoadHistory")
	GUICtrlSetOnEvent($delete_history, "_DeleteHistory")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_ViewHistory")
	GUISetState(@SW_HIDE)
	_GUICtrlListViewSetColumnWidth($Listview, 0, 100)
	_GUICtrlListViewSetColumnWidth($Listview, 1, 250)
EndFunc   ;==>_CreateHistory
Func _UpdateHistory()
	If _IEPropertyGet($oIE, "locationurl") = _GUICtrlListViewGetItemText($Listview, _GUICtrlListViewGetItemCount($Listview) - 1, 1) Then
		Return
	Else
		_GUICtrlListViewInsertItem($Listview, -1, _IEPropertyGet($oIE, "locationname") & "|" & _IEPropertyGet($oIE, "locationurl"))
	EndIf
EndFunc   ;==>_UpdateHistory
Func _ViewHistory()
	$historystate = Not $historystate
	If $historystate Then
		GUICtrlSetState($viewhistory, $GUI_CHECKED)
		GUISetState(@SW_SHOW, $History_frm)
	Else
		GUICtrlSetState($viewhistory, $GUI_UNCHECKED)
		GUISetState(@SW_HIDE, $History_frm)
	EndIf
EndFunc   ;==>_ViewHistory
Func _FindHistory()
	For $i = 0 To _GUICtrlListViewGetItemCount($Listview)
		If StringInStr(_GUICtrlListViewGetItemText($Listview, $i, -1), GUICtrlRead($find_input)) > 0 Then
			_GUICtrlListViewSetItemSelState($Listview, $i)
			Return
		EndIf
	Next
	GUICtrlSetData($find_input, "No Result..ReEnter Keyword..")
EndFunc   ;==>_FindHistory
Func _LoadHistory()
	_IENavigate($oIE, _GUICtrlListViewGetItemText($Listview, -1, 1), 0)
EndFunc   ;==>_LoadHistory
Func _DeleteHistory()
	_GUICtrlListViewDeleteItemsSelected($Listview)
EndFunc   ;==>_DeleteHistory