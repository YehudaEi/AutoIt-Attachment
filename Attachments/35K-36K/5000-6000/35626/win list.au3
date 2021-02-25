#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Window.ico
#AutoIt3Wrapper_outfile=Window Detector.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Window Detector
#AutoIt3Wrapper_Res_Description=Detect All Windows
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=© Z -Tech 2011. All Rights Reserved.
#AutoIt3Wrapper_Res_Language=1056
#AutoIt3Wrapper_Res_Field=Made By|Zohran Arif Butt
#AutoIt3Wrapper_Res_Icon_Add=empty.ico
#AutoIt3Wrapper_Res_Icon_Add=moneybookers.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <GUIImageList.au3>
#include <WinAPIEx.au3>
#include <SendMessage.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include "C:\AutoIt3\AutoResources\Thread\[Includes]\_ProcessFunctions.au3"
#include "C:\AutoIt3\AutoResources\Thread\[Includes]\_ThreadUndocumentedList.au3"
#include "C:\AutoIt3\AutoResources\Thread\[Includes]\_WinTimeFunctions.au3"
#include "C:\AutoIt3\AutoResources\App\_GUICtrlListView_SaveHTML.au3"

If _WinAPI_GetVersion() < '5.1' Then
	MsgBox(16, 'Error', 'Requires Windows XP Or Later.')
	Exit
EndIf

Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
TraySetState()
TraySetToolTip("Window Detector")

Global $var, $z
Global $HideWmin, $Form4
Global $Start, $now = 1
Global $hicon = 0, $Form3
Global $arraycount, $Form2
Global $IniPath = @ScriptDir & "\WinDSettings.ini"
Global $AllWin, $VisWin, $HidWin
Global $User32 = DllOpen("user32.dll")
Global $status, $processpid, $username, $states, $time, $processpath, $thandle, $size
Global $cwinsize, $cstatsize, $cprocsize, $cusersize, $cdosize, $chsize, $cpathsize, $cstsize, $ctsize

DllCall("ntdll.dll.dll", "long", "RtlAdjustPrivilege", "ulong", 20, "bool", True, "bool", False, "bool*", 0) ;SeDebug privilege...

$Form1 = GUICreate("Window Detector", 731, 521, 219, 121, BitOR($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_GROUP, $WS_BORDER, $WS_CLIPSIBLINGS))

$File = GUICtrlCreateMenu("File")
$Hwm = GUICtrlCreateMenuItem("Hide When Mininmized", $File)
$idExit = GUICtrlCreateMenuItem("Exit", $File)

$Options = GUICtrlCreateMenu("Options")
$idOptions1 = GUICtrlCreateMenuItem("Show All Windows", $Options)
$idOptions2 = GUICtrlCreateMenuItem("Show Visible Windows", $Options)
$idOptions3 = GUICtrlCreateMenuItem("Show Hidden Windows", $Options)
$idOptions4 = GUICtrlCreateMenuItem("Select Columns", $Options)

$Help = GUICtrlCreateMenu("Help")
$idAbout = GUICtrlCreateMenuItem("About", $Help)

$showitem = TrayCreateItem("Show")
TrayCreateItem("")
$hideitem = TrayCreateItem("Hide")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")

$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
_GUICtrlStatusBar_SetMinHeight($StatusBar1, 20)

$ListView1 = GUICtrlCreateListView("", 0, 0, 730, 480, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_NOSORTHEADER, $LVS_SHOWSELALWAYS, $LVS_AUTOARRANGE))
_GUICtrlListView_SetExtendedListViewStyle($ListView1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_LABELTIP, $LVS_EX_DOUBLEBUFFER))
GUICtrlSetResizing($ListView1, $GUI_DOCKBORDERS)

$hImageList = _GUIImageList_Create(16, 16, 5, 3)
_GUIImageList_AddIcon($hImageList, @ScriptFullPath, 201)
_GUICtrlListView_SetImageList($ListView1, $hImageList, 1)

$contextmenu = GUICtrlCreateContextMenu($ListView1)
$openitem = GUICtrlCreateMenuItem("Open Containing Folder", $contextmenu)
$front = GUICtrlCreateMenuItem("Bring To Front", $contextmenu)
$endtask = GUICtrlCreateMenuItem("Close Window", $contextmenu)
GUICtrlCreateMenuItem("", $contextmenu)
$max = GUICtrlCreateMenuItem("Maximize", $contextmenu)
$min = GUICtrlCreateMenuItem("Mininmize", $contextmenu)
$enable = GUICtrlCreateMenuItem("Enable", $contextmenu)
$disable = GUICtrlCreateMenuItem("Disable", $contextmenu)
$show = GUICtrlCreateMenuItem("Show", $contextmenu)
$hide = GUICtrlCreateMenuItem("Hide", $contextmenu)
GUICtrlCreateMenuItem("", $contextmenu)
$title = GUICtrlCreateMenuItem("Change Window Title", $contextmenu)
$trans = GUICtrlCreateMenuItem("Change Window Transparency", $contextmenu)
GUICtrlCreateMenuItem("", $contextmenu)
$properties = GUICtrlCreateMenuItem("Properties", $contextmenu)
$export = GUICtrlCreateMenuItem("Generate Html Report", $contextmenu)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "MinD")

GUICtrlSetOnEvent($Hwm, "Hwm")
GUICtrlSetOnEvent($idExit, "_Exit")
GUICtrlSetOnEvent($idOptions1, "idOptions1")
GUICtrlSetOnEvent($idOptions2, "idOptions2")
GUICtrlSetOnEvent($idOptions3, "idOptions3")
GUICtrlSetOnEvent($idOptions4, "SelectColumns")
GUICtrlSetOnEvent($openitem, "OpenC")
GUICtrlSetOnEvent($front, "Front")
GUICtrlSetOnEvent($endtask, "EndTask")
GUICtrlSetOnEvent($max, "Max")
GUICtrlSetOnEvent($min, "Min")
GUICtrlSetOnEvent($enable, "Enable")
GUICtrlSetOnEvent($disable, "Disable")
GUICtrlSetOnEvent($show, "Show")
GUICtrlSetOnEvent($hide, "Hide")
GUICtrlSetOnEvent($title, "Title")
GUICtrlSetOnEvent($trans, "Trans")
GUICtrlSetOnEvent($idAbout, "About")
GUICtrlSetOnEvent($properties, "Properties")
GUICtrlSetOnEvent($export, "Export")

TrayItemSetOnEvent($exititem, "_Exit")
TrayItemSetOnEvent($showitem, "_Show")
TrayItemSetOnEvent($hideitem, "_Hide")

If Not FileExists($IniPath) Then
	GUICtrlSetState($idOptions2, $GUI_CHECKED)
	IniWrite($IniPath, "Settings", "AllWin", 0)
	IniWrite($IniPath, "Settings", "VisWin", 1)
	IniWrite($IniPath, "Settings", "HidWin", 0)
	IniWrite($IniPath, "Settings", "Hwm", 0)
	FileWriteLine($IniPath, @CRLF)
	IniWrite($IniPath, "Columns", "Status", 1)
	IniWrite($IniPath, "Columns", "Processpid", 1)
	IniWrite($IniPath, "Columns", "Username", 1)
	IniWrite($IniPath, "Columns", "States", 0)
	IniWrite($IniPath, "Columns", "Time", 0)
	IniWrite($IniPath, "Columns", "Processpath", 0)
	IniWrite($IniPath, "Columns", "Size", 0)
	IniWrite($IniPath, "Columns", "Handle", 0)
	FileWriteLine($IniPath, @CRLF)
	IniWrite($IniPath, "CSize", "Window", 300)
	IniWrite($IniPath, "CSize", "Status", 90)
	IniWrite($IniPath, "CSize", "Processpid", 200)
	IniWrite($IniPath, "CSize", "Username", 120)
	IniWrite($IniPath, "CSize", "Size", 140)
	IniWrite($IniPath, "CSize", "Handle", 80)
	IniWrite($IniPath, "CSize", "Processpath", 300)
	IniWrite($IniPath, "CSize", "State", 200)
	IniWrite($IniPath, "CSize", "Time", 300)
Else
	Ini_Read()
	GUICtrlSetState($Hwm, $HideWmin)
	GUICtrlSetState($idOptions1, $AllWin)
	GUICtrlSetState($idOptions2, $VisWin)
	GUICtrlSetState($idOptions3, $HidWin)
EndIf

Ini_Read()
_GUICtrlListView_InsertColumn($ListView1, 0, "Window Title", $cwinsize)

If $status = 1 Then _GUICtrlListView_AddColumn($ListView1, "Status", $cstatsize)
If $processpid = 1 Then _GUICtrlListView_AddColumn($ListView1, "Process / Pid", $cprocsize)
If $username = 1 Then _GUICtrlListView_AddColumn($ListView1, "Username", $cusersize)
If $size = 1 Then _GUICtrlListView_AddColumn($ListView1, "Size", $cdosize)
If $thandle = 1 Then _GUICtrlListView_AddColumn($ListView1, "Handle", $chsize)
If $processpath = 1 Then _GUICtrlListView_AddColumn($ListView1, "Process Path", $cpathsize)
If $states = 1 Then _GUICtrlListView_AddColumn($ListView1, "State", $cstsize)
If $time = 1 Then _GUICtrlListView_AddColumn($ListView1, "Creation Time", $ctsize)

Func Ini_Read()
	$AllWin = IniRead($IniPath, "Settings", "AllWin", 0)
	$VisWin = IniRead($IniPath, "Settings", "VisWin", 1)
	$HidWin = IniRead($IniPath, "Settings", "HidWin", 0)
	$HideWmin = IniRead($IniPath, "Settings", "Hwm", 0)
	$status = IniRead($IniPath, "Columns", "Status", 1)
	$processpid = IniRead($IniPath, "Columns", "Processpid", 1)
	$processpath = IniRead($IniPath, "Columns", "Processpath", 0)
	$username = IniRead($IniPath, "Columns", "Username", 1)
	$size = IniRead($IniPath, "Columns", "Size", 0)
	$thandle = IniRead($IniPath, "Columns", "Handle", 0)
	$states = IniRead($IniPath, "Columns", "States", 0)
	$time = IniRead($IniPath, "Columns", "Time", 0)
	$cwinsize = IniRead($IniPath, "CSize", "Window", 300)
	$cstatsize = IniRead($IniPath, "CSize", "Status", 90)
	$cprocsize = IniRead($IniPath, "CSize", "Processpid", 200)
	$cusersize = IniRead($IniPath, "CSize", "Username", 120)
	$cdosize = IniRead($IniPath, "CSize", "Size", 140)
	$chsize = IniRead($IniPath, "CSize", "Handle", 80)
	$cpathsize = IniRead($IniPath, "CSize", "Processpath", 300)
	$cstsize = IniRead($IniPath, "CSize", "State", 200)
	$ctsize = IniRead($IniPath, "CSize", "Time", 300)
EndFunc   ;==>Ini_Read

Func Idice()
	$Smark = _GUICtrlListView_GetSelectionMark($ListView1)
	If $Smark <> -1 Then
		$sSplit = StringSplit($winarray[$Smark], "/\/\", 1)
		Return HWnd($sSplit[1])
	EndIf
EndFunc   ;==>Idice

Func OpenC()
	If Idice() <> 0 Then
		$hProcess = _ProcessOpen(WinGetProcess(Idice()), 0x00000400)
		If IsPtr($hProcess) Then
			$result = _ProcessGetPathname($hProcess)
			If @error = 0 Then _WinAPI_ShellOpenFolderAndSelectItems($result)
		EndIf
	EndIf
EndFunc   ;==>OpenC

Func Front()
	WinActivate(Idice())
EndFunc   ;==>Front

Func EndTask()
	WinKill(Idice())
EndFunc   ;==>EndTask

Func Max()
	WinSetState(Idice(), "", @SW_MAXIMIZE)
EndFunc   ;==>Max

Func Min()
	WinSetState(Idice(), "", @SW_MINIMIZE)
EndFunc   ;==>Min

Func Enable()
	WinSetState(Idice(), "", @SW_ENABLE)
EndFunc   ;==>Enable

Func Disable()
	WinSetState(Idice(), "", @SW_DISABLE)
EndFunc   ;==>Disable

Func Show()
	WinSetState(Idice(), "", @SW_SHOW)
EndFunc   ;==>Show

Func Hide()
	WinSetState(Idice(), "", @SW_HIDE)
EndFunc   ;==>Hide

Func Title()
	$answer = InputBox("Enter New Title", " ", WinGetTitle(Idice()), "", 400, 100, 300, 300, "", $Form1)
	If $answer <> "" Then WinSetTitle(Idice(), "", $answer)
EndFunc   ;==>Title

Func Trans()
	$info = "Enter A Number In The Range 0 - 255. The Lower The Number The More Transparent The Window Will Become. "
	$answer = InputBox("Change Window Transparency", $info & @CRLF & "255 = Solid, 0 = Invisible", "", "", 400, 150, 300, 300, "", $Form1)
	If $answer <> "" Then
		If StringIsFloat($answer) Or StringIsDigit($answer) Then
			If $answer >= 0 Or $answer <= 255 Then WinSetTrans(Idice(), "", $answer)
		EndIf
	EndIf
EndFunc   ;==>Trans


GUIRegisterMsg($WM_SIZE, "WM_SIZE")
GUISetState(@SW_SHOW)

AdlibRegister("StatusBarUpdate", 250)
WindowList()
_ReduceMemory()

AdlibRegister("_ReduceMemory", 30000)
AdlibRegister("UpdateWindowListCall", 50)

While 1 = 1

	Sleep(1)

WEnd

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible

Func _Exit()
	DllClose($User32)

	For $k = 0 To (_GUICtrlListView_GetColumnCount($ListView1) - 1)
		$aInfo = _GUICtrlListView_GetColumn($ListView1, $k)
		If $aInfo[5] == "Window Title" Then IniWrite($IniPath, "CSize", "Window", $aInfo[4])
		If $aInfo[5] == "Status" Then IniWrite($IniPath, "CSize", "Status", $aInfo[4])
		If $aInfo[5] == "Process / Pid" Then IniWrite($IniPath, "CSize", "Processpid", $aInfo[4])
		If $aInfo[5] == "Username" Then IniWrite($IniPath, "CSize", "Username", $aInfo[4])
		If $aInfo[5] == "Size" Then IniWrite($IniPath, "CSize", "Size", $aInfo[4])
		If $aInfo[5] == "Handle" Then IniWrite($IniPath, "CSize", "Handle", $aInfo[4])
		If $aInfo[5] == "Process Path" Then IniWrite($IniPath, "CSize", "Processpath", $aInfo[4])
		If $aInfo[5] == "State" Then IniWrite($IniPath, "CSize", "State", $aInfo[4])
		If $aInfo[5] == "Creation Time" Then IniWrite($IniPath, "CSize", "Time", $aInfo[4])
	Next

	Exit
EndFunc   ;==>_Exit

Func ImageList()
	_GUIImageList_Destroy($hImageList)
	$hImageList = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hImageList, @ScriptDir & "\empty.ico")
	_GUICtrlListView_SetImageList($ListView1, $hImageList, 1)
EndFunc   ;==>ImageList

Func _ReduceMemory() ;Reduces Memory Usage -- Special thanks to w0uter and jftuga
	Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', @AutoItPID)
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
	DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	_GUICtrlStatusBar_Resize($StatusBar1)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func _Show()
	GUISetState(@SW_SHOW, $Form1)
	GUISetState(@SW_RESTORE, $Form1)
	WinActivate($Form1)
	TrayItemSetState($showitem, 4)
EndFunc   ;==>_Show

Func _Hide()
	GUISetState(@SW_HIDE, $Form1)
	TrayItemSetState($hideitem, 4)
EndFunc   ;==>_Hide

Func MinD()
	Ini_Read()
	If $HideWmin == 1 Then GUISetState(@SW_HIDE, $Form1)
EndFunc   ;==>MinD

Func Hwm()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($Hwm, $GUI_UNCHECKED)
		IniWrite($IniPath, "Settings", "Hwm", 0)
	Else
		GUICtrlSetState($Hwm, $GUI_CHECKED)
		IniWrite($IniPath, "Settings", "Hwm", 1)
	EndIf
EndFunc   ;==>Hwm

Func idOptions1()
	If IniWrite($IniPath, "Settings", "AllWin", 1) = 1 Then
		IniWrite($IniPath, "Settings", "VisWin", 0)
		IniWrite($IniPath, "Settings", "HidWin", 0)
		GUICtrlSetState($idOptions1, $GUI_CHECKED)
		GUICtrlSetState($idOptions2, $GUI_UNCHECKED)
		GUICtrlSetState($idOptions3, $GUI_UNCHECKED)
		$Start = 0
		WindowList()
	EndIf
EndFunc   ;==>idOptions1

Func idOptions2()
	If IniWrite($IniPath, "Settings", "VisWin", 1) = 1 Then
		IniWrite($IniPath, "Settings", "HidWin", 0)
		IniWrite($IniPath, "Settings", "AllWin", 0)
		GUICtrlSetState($idOptions2, $GUI_CHECKED)
		GUICtrlSetState($idOptions3, $GUI_UNCHECKED)
		GUICtrlSetState($idOptions1, $GUI_UNCHECKED)
		$Start = 0
		WindowList()
	EndIf
EndFunc   ;==>idOptions2

Func idOptions3()
	If IniWrite($IniPath, "Settings", "HidWin", 1) = 1 Then
		IniWrite($IniPath, "Settings", "AllWin", 0)
		IniWrite($IniPath, "Settings", "VisWin", 0)
		GUICtrlSetState($idOptions3, $GUI_CHECKED)
		GUICtrlSetState($idOptions2, $GUI_UNCHECKED)
		GUICtrlSetState($idOptions1, $GUI_UNCHECKED)
		$Start = 0
		WindowList()
	EndIf
EndFunc   ;==>idOptions3

Func StatusBarUpdate()
	$var2 = WinList()

	Local $TotW = 0
	Local $VisW = 0
	Local $HidW = 0
	Local $Text = ""

	For $i = 1 To $var2[0][0]
		If $var2[$i][0] <> "" And WinGetProcess($var2[$i][1]) <> @AutoItPID Then $TotW += 1
		If $var2[$i][0] <> "" And IsVisible($var2[$i][1]) And WinGetProcess($var2[$i][1]) <> @AutoItPID Then $VisW += 1
		If $var2[$i][0] <> "" And Not IsVisible($var2[$i][1]) And WinGetProcess($var2[$i][1]) <> @AutoItPID Then $HidW += 1
	Next

	$Text = "Total Windows: " & $TotW & ", Visible Windows: " & $VisW & ", " & "Hidden Windows: " & $HidW
	_GUICtrlStatusBar_SetText($StatusBar1, $Text, 0)
EndFunc   ;==>StatusBarUpdate

Func UpdateWindowListCall()
	If $arraycount <> 0 And UBound($winarray) <> 0 Then
		Ini_Read()

		If $AllWin == 1 And $Start == 1 Then UpdateAllWindowList()
		If $VisWin == 1 And $Start == 1 Then UpdateVisWindowList()
		If $HidWin == 1 And $Start == 1 Then UpdateHidWindowList()
		UpdateWindowListDelete()

	Else
		$Start = 0
		WindowList()
	EndIf
EndFunc   ;==>UpdateWindowListCall

Func Now()
	If $now == 1 Then
		AdlibUnRegister("Now")
		WindowList()
	EndIf
EndFunc   ;==>Now

Func GetSubId($Header)
	For $r = 0 To (_GUICtrlListView_GetColumnCount($ListView1) - 1)
		$aInfoC = _GUICtrlListView_GetColumn($ListView1, $r)
		If $Header == $aInfoC[5] Then Return $aInfoC[8]
	Next
EndFunc   ;==>GetSubId

Func IsHungAppWindow($aHandle)
	$retArr = DllCall($User32, "int", "IsHungAppWindow", "hwnd", $aHandle)
	Return $retArr[0]
EndFunc   ;==>IsHungAppWindow

Func IsHungThread($aHandle)
	Local $aRet = DllCall($User32, "dword", "GetWindowThreadProcessId", "hwnd", $aHandle, "dword*", 0)
	Return _ThreadUDIsSuspended($aRet[0], WinGetProcess($aHandle))
EndFunc   ;==>IsHungThread

Func Status($Param1, $Param2)
	Local $Header = "Status"
	If IsHungAppWindow($Param1) Then
		_GUICtrlListView_SetItemText($ListView1, $Param2, "Not Responding", GetSubId($Header))
	Else
		_GUICtrlListView_SetItemText($ListView1, $Param2, "Running", GetSubId($Header))
	EndIf
EndFunc   ;==>Status

Func ProcessGetName($i_PID)
	If Not ProcessExists($i_PID) Then Return SetError(1, 0, '')
	If Not @error Then
		Local $a_Processes = ProcessList()
		For $i = 1 To $a_Processes[0][0]
			If $a_Processes[$i][1] = $i_PID Then Return $a_Processes[$i][0]
		Next
	EndIf
	Return SetError(1, 0, '')
EndFunc   ;==>ProcessGetName

Func Username($Param1, $Param2)
	Local $Header = "Username"
	$hProcess = _ProcessOpen(WinGetProcess($Param1), 0x00020000)
	If IsPtr($hProcess) Then
		$result = _ProcessGetOwner($hProcess)
		If @error = 0 Then
			_GUICtrlListView_AddSubItem($ListView1, $Param2, $result, GetSubId($Header))
		Else
			_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
		EndIf
		_ProcessCloseHandle($hProcess)
	Else
		_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
	EndIf
EndFunc   ;==>Username

Func WinSzie($Param1, $Param2)
	Local $Header = "Size"
	$winstate = WinGetState($Param1)
	If BitAND($winstate, 16) Then
		_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
	Else
		$winsize = WinGetPos($Param1)
		If UBound($winsize) > 3 Then
			_GUICtrlListView_AddSubItem($ListView1, $Param2, "Width: " & $winsize[2] & " , Height: " & $winsize[3], GetSubId($Header))
		Else
			_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
		EndIf
	EndIf
EndFunc   ;==>WinSzie

Func WinHandle($Param1, $Param2)
	Local $Header = "Handle"
	_GUICtrlListView_AddSubItem($ListView1, $Param2, $Param1, GetSubId($Header))
EndFunc   ;==>WinHandle

Func Processpath($Param1, $Param2)
	Local $Header = "Process Path"
	$hProcess = _ProcessOpen(WinGetProcess($Param1), 0x00000400)
	If IsPtr($hProcess) Then
		$result = _ProcessGetPathname($hProcess)
		If @error = 0 Then
			_GUICtrlListView_AddSubItem($ListView1, $Param2, $result, GetSubId($Header))
		Else
			_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
		EndIf
	Else
		_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
	EndIf
EndFunc   ;==>Processpath

Func States($Param1, $Param2)
	Local $Header = "State"
	Local $ssc = WinGetState($Param1)
	Local $result = ""

	If BitAND($ssc, 2) Then
		$result &= "Visible" & ","
	Else
		$result &= "Hidden" & ","
	EndIf

	If BitAND($ssc, 4) Then
		$result &= "Enabled" & ","
	Else
		$result &= "Disabled" & ","
	EndIf

	If BitAND($ssc, 8) Then $result &= "Active" & ","
	If BitAND($ssc, 16) Then $result &= "Minimized" & ","
	If BitAND($ssc, 32) Then $result &= "Maximized" & ","

	$result = StringTrimRight($result, 1)
	_GUICtrlListView_AddSubItem($ListView1, $Param2, $result, GetSubId($Header))
EndFunc   ;==>States

Func CreationTime($Param1, $Param2)
	Local $Header = "Creation Time"
	$hProcess = _ProcessOpen(WinGetProcess($Param1), 0x00000400)
	If IsPtr($hProcess) Then
		$result = _ProcessGetTimes($hProcess, 0)
		$result = _WinTime_UTCFileTimeFormat($result, 4 + 8, 1, True)
		If @error = 0 Then
			_GUICtrlListView_AddSubItem($ListView1, $Param2, $result, GetSubId($Header))
		Else
			_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
		EndIf
	Else
		_GUICtrlListView_AddSubItem($ListView1, $Param2, "", GetSubId($Header))
	EndIf
EndFunc   ;==>CreationTime

Func Export()
	Local $random = Random(0, 10000, 1)
	_GUICtrlListView_SaveHTML($ListView1, @ScriptDir & "\Export" & $random & ".html")
	ShellExecute(@ScriptDir & "\Export" & $random & ".html")
EndFunc   ;==>Export

Func WindowList()

	If $now <> 1 Then
		AdlibRegister("Now", 50)
		Return
	EndIf

	Ini_Read()
	ImageList()

	Global $winarray[1]
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))

	GUICtrlSetState($idOptions1, $GUI_DISABLE)
	GUICtrlSetState($idOptions2, $GUI_DISABLE)
	GUICtrlSetState($idOptions3, $GUI_DISABLE)
	GUICtrlSetState($idOptions4, $GUI_DISABLE)

	$var = WinList()
	ReDim $winarray[$var[0][0]]

	$z = 1
	$hicon = 0
	$arraycount = 0

	For $i = 1 To $var[0][0]
		If $var[$i][0] <> "" And WinGetProcess($var[$i][1]) <> @AutoItPID And $var[$i][1] <> "" Then
			If $AllWin == 1 Then

				$iIndex = IconItemAdd($i)
				$winarray[$arraycount] = $var[$i][1] & "/\/\" & $iIndex & "/\/\" & $var[$i][0]
				$arraycount += 1
			EndIf

			If $VisWin == 1 Then
				If IsVisible($var[$i][1]) Then
					$iIndex = IconItemAdd($i)
					$winarray[$arraycount] = $var[$i][1] & "/\/\" & $iIndex & "/\/\" & $var[$i][0]
					$arraycount += 1
				EndIf
			EndIf

			If $HidWin == 1 Then
				If Not IsVisible($var[$i][1]) Then
					$iIndex = IconItemAdd($i)
					$winarray[$arraycount] = $var[$i][1] & "/\/\" & $iIndex & "/\/\" & $var[$i][0]
					$arraycount += 1
				EndIf
			EndIf
		EndIf
	Next
	If $arraycount == 0 Then Return
	ReDim $winarray[$arraycount]
	$Start = 1
	GUICtrlSetState($idOptions1, $GUI_ENABLE)
	GUICtrlSetState($idOptions2, $GUI_ENABLE)
	GUICtrlSetState($idOptions3, $GUI_ENABLE)
	GUICtrlSetState($idOptions4, $GUI_ENABLE)
EndFunc   ;==>WindowList

Func IconItemAdd($i)
	$hicon = 0
	If Not IsHungThread($var[$i][1]) Then
		$hicon = _SendMessage($var[$i][1], $WM_GETICON, False, 0)
		If $hicon == 0 Then
			$hicon = _SendMessage($var[$i][1], $WM_GETICON, True, 0)
		EndIf

		If $hicon <> 0 Then
			$ret = _GUIImageList_ReplaceIcon($hImageList, -1, $hicon)
			If $ret == -1 Then
				$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], 0)
			Else
				$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], $z)
				$z += 1
			EndIf

			If $status == 1 Then
				Local $Header = "Status"
				If IsHungAppWindow($var[$i][1]) Then
					_GUICtrlListView_AddSubItem($ListView1, $iIndex, "Not Responding", GetSubId($Header))
				Else
					_GUICtrlListView_AddSubItem($ListView1, $iIndex, "Running", GetSubId($Header))
				EndIf
			EndIf

			If $processpid == 1 Then
				Local $Header = "Process / Pid"
				$result = ProcessGetName(WinGetProcess($var[$i][1])) & " / " & WinGetProcess($var[$i][1])
				_GUICtrlListView_AddSubItem($ListView1, $iIndex, $result, GetSubId($Header))
			EndIf

			If $username == 1 Then
				Username($var[$i][1], $iIndex)
			EndIf

			If $size == 1 Then
				WinSzie($var[$i][1], $iIndex)
			EndIf

			If $thandle == 1 Then
				WinHandle($var[$i][1], $iIndex)
			EndIf

			If $processpath == 1 Then
				Processpath($var[$i][1], $iIndex)
			EndIf

			If $states == 1 Then
				States($var[$i][1], $iIndex)
			EndIf

			If $time == 1 Then
				CreationTime($var[$i][1], $iIndex)
			EndIf

			Return $iIndex
		EndIf

		If $hicon == 0 Then
			$hicon = _WinAPI_GetClassLongEx($var[$i][1], $GCL_HICONSM)
		EndIf

		If $hicon <> 0 Then
			$ret = _GUIImageList_ReplaceIcon($hImageList, -1, $hicon)
			If $ret == -1 Then
				$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], 0)
			Else
				$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], $z)
				$z += 1
			EndIf

			If $status == 1 Then
				Local $Header = "Status"
				If IsHungAppWindow($var[$i][1]) Then
					_GUICtrlListView_AddSubItem($ListView1, $iIndex, "Not Responding", GetSubId($Header))
				Else
					_GUICtrlListView_AddSubItem($ListView1, $iIndex, "Running", GetSubId($Header))
				EndIf
			EndIf

			If $processpid == 1 Then
				Local $Header = "Process / Pid"
				$result = ProcessGetName(WinGetProcess($var[$i][1])) & " / " & WinGetProcess($var[$i][1])
				_GUICtrlListView_AddSubItem($ListView1, $iIndex, $result, GetSubId($Header))
			EndIf

			If $username == 1 Then
				Username($var[$i][1], $iIndex)
			EndIf

			If $size == 1 Then
				WinSzie($var[$i][1], $iIndex)
			EndIf

			If $thandle == 1 Then
				WinHandle($var[$i][1], $iIndex)
			EndIf

			If $processpath == 1 Then
				Processpath($var[$i][1], $iIndex)
			EndIf

			If $states == 1 Then
				States($var[$i][1], $iIndex)
			EndIf

			If $time == 1 Then
				CreationTime($var[$i][1], $iIndex)
			EndIf

			Return $iIndex
		EndIf
	EndIf

	If $hicon == 0 Then
		$hProcess = _ProcessOpen(WinGetProcess($var[$i][0]), 0x00000400)
		If IsPtr($hProcess) Then

			$ProcPath = _ProcessGetPathname($hProcess)
			_ProcessCloseHandle($hProcess)

			If $ProcPath <> "" Then
				$ret = _GUIImageList_AddIcon($hImageList, $ProcPath)

				If $ret == 0 Then
					$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], 0)
				Else
					$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], $z)
					$z += 1
				EndIf
			Else
				$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], 0)
			EndIf
		Else
			$iIndex = _GUICtrlListView_AddItem($ListView1, $var[$i][0], 0)
		EndIf
	EndIf

	If $status == 1 Then
		Local $Header = "Status"
		If IsHungAppWindow($var[$i][1]) Then
			_GUICtrlListView_AddSubItem($ListView1, $iIndex, "Not Responding", GetSubId($Header))
		Else
			_GUICtrlListView_AddSubItem($ListView1, $iIndex, "Running", GetSubId($Header))
		EndIf
	EndIf

	If $processpid == 1 Then
		Local $Header = "Process / Pid"
		$result = ProcessGetName(WinGetProcess($var[$i][1])) & " / " & WinGetProcess($var[$i][1])
		_GUICtrlListView_AddSubItem($ListView1, $iIndex, $result, GetSubId($Header))
	EndIf

	If $username == 1 Then
		Username($var[$i][1], $iIndex)
	EndIf

	If $size == 1 Then
		WinSzie($var[$i][1], $iIndex)
	EndIf

	If $thandle == 1 Then
		WinHandle($var[$i][1], $iIndex)
	EndIf

	If $processpath == 1 Then
		Processpath($var[$i][1], $iIndex)
	EndIf

	If $states == 1 Then
		States($var[$i][1], $iIndex)
	EndIf

	If $time == 1 Then
		CreationTime($var[$i][1], $iIndex)
	EndIf

	Return $iIndex
EndFunc   ;==>IconItemAdd

Func UpdateWindowListDelete()
	If $arraycount == 0 Then Return
	For $i = 0 To (UBound($winarray) - 1)

		If $i > UBound($winarray) - 1 Then Return

		$Split = StringSplit($winarray[$i], "/\/\", 1)

		$delete = 0
		If $VisWin == 1 And Not IsVisible(HWnd($Split[1])) Then $delete = 1
		If $HidWin == 1 And IsVisible(HWnd($Split[1])) Then $delete = 1

		If Not WinExists(HWnd($Split[1])) Or $delete == 1 Then
			_ArrayDelete($winarray, $i)
			_GUICtrlListView_DeleteItem(GUICtrlGetHandle($ListView1), $Split[2])

			If $i <> (UBound($winarray)) Then
				Dim $winarrayDummy[UBound($winarray)]

				For $x = 0 To (UBound($winarray) - 1)
					$SplitIn = StringSplit($winarray[$x], "/\/\", 1)

					$NUM = Number($Split[2])
					$InNUM = Number($SplitIn[2])

					If $InNUM > $NUM Then
						$InNUM = $InNUM - 1
						$winarrayDummy[$x] = $SplitIn[1] & "/\/\" & String($InNUM) & "/\/\" & $SplitIn[3]
					Else
						$winarrayDummy[$x] = $SplitIn[1] & "/\/\" & $SplitIn[2] & "/\/\" & $SplitIn[3]
					EndIf
				Next

				$winarray = 0
				$winarray = $winarrayDummy
				$winarrayDummy = 0
			EndIf
		EndIf
		Sleep(10)
	Next
EndFunc   ;==>UpdateWindowListDelete

Func UpdateAllWindowList()
	$now = 0
	$var = WinList()

	For $i = 1 To $var[0][0]

		If $var[$i][0] <> "" And $var[$i][1] <> "" Then
			If WinGetProcess($var[$i][1]) <> @AutoItPID Then

				$Whandle = _ArraySearch($winarray, $var[$i][1], 0, 0, 0, 1)

				If $Whandle == -1 Then
					$iIndex = IconItemAdd($i)
					_ArrayAdd($winarray, $var[$i][1] & "/\/\" & $iIndex & "/\/\" & $var[$i][0])

					If $status == 1 Then
						Status($var[$i][1], $iIndex)
					EndIf

					If $processpid == 1 Then
						Local $Header = "Process / Pid"
						$result = ProcessGetName(WinGetProcess($var[$i][1])) & " / " & WinGetProcess($var[$i][1])
						_GUICtrlListView_AddSubItem($ListView1, $iIndex, $result, GetSubId($Header))
					EndIf

					If $username == 1 Then
						Username($var[$i][1], $iIndex)
					EndIf

					If $size == 1 Then
						WinSzie($var[$i][1], $iIndex)
					EndIf

					If $thandle == 1 Then
						WinHandle($var[$i][1], $iIndex)
					EndIf

					If $processpath == 1 Then
						Processpath($var[$i][1], $iIndex)
					EndIf

					If $states == 1 Then
						States($var[$i][1], $iIndex)
					EndIf

					If $time == 1 Then
						CreationTime($var[$i][1], $iIndex)
					EndIf
				EndIf

				If $Whandle <> -1 Then
					$Split = StringSplit($winarray[$Whandle], "/\/\", 1)
					If $Split[3] <> $var[$i][0] Then _GUICtrlListView_SetItemText($ListView1, $Split[2], $var[$i][0])
					If $Split[3] == $var[$i][0] Then _GUICtrlListView_SetItemText($ListView1, $Split[2], $var[$i][0])

					If $status == 1 Then
						Status($var[$i][1], $Split[2])
					EndIf

					If $states == 1 Then
						States($var[$i][1], $Split[2])
					EndIf

					If $size == 1 Then
						WinSzie($var[$i][1], $Split[2])
					EndIf

				EndIf
			EndIf
		EndIf
		Sleep(10)
	Next
	$now = 1
EndFunc   ;==>UpdateAllWindowList

Func UpdateVisWindowList()
	$now = 0
	$var = WinList()

	For $i = 1 To $var[0][0]

		If $var[$i][0] <> "" And IsVisible($var[$i][1]) And $var[$i][1] <> "" Then
			If WinGetProcess($var[$i][1]) <> @AutoItPID Then

				$Whandle = _ArraySearch($winarray, $var[$i][1], 0, 0, 0, 1)

				If $Whandle == -1 Then
					$iIndex = IconItemAdd($i)
					_ArrayAdd($winarray, $var[$i][1] & "/\/\" & $iIndex & "/\/\" & $var[$i][0])

					If $status == 1 Then
						Status($var[$i][1], $iIndex)
					EndIf

					If $processpid == 1 Then
						Local $Header = "Process / Pid"
						$result = ProcessGetName(WinGetProcess($var[$i][1])) & " / " & WinGetProcess($var[$i][1])
						_GUICtrlListView_AddSubItem($ListView1, $iIndex, $result, GetSubId($Header))
					EndIf

					If $username == 1 Then
						Username($var[$i][1], $iIndex)
					EndIf

					If $size == 1 Then
						WinSzie($var[$i][1], $iIndex)
					EndIf

					If $thandle == 1 Then
						WinHandle($var[$i][1], $iIndex)
					EndIf

					If $processpath == 1 Then
						Processpath($var[$i][1], $iIndex)
					EndIf

					If $states == 1 Then
						States($var[$i][1], $iIndex)
					EndIf

					If $time == 1 Then
						CreationTime($var[$i][1], $iIndex)
					EndIf
				EndIf

				If $Whandle <> -1 Then
					$Split = StringSplit($winarray[$Whandle], "/\/\", 1)
					If $Split[3] <> $var[$i][0] Then _GUICtrlListView_SetItemText($ListView1, $Split[2], $var[$i][0])
					If $Split[3] == $var[$i][0] Then _GUICtrlListView_SetItemText($ListView1, $Split[2], $var[$i][0])

					If $status == 1 Then
						Status($var[$i][1], $Split[2])
					EndIf

					If $states == 1 Then
						States($var[$i][1], $Split[2])
					EndIf

					If $size == 1 Then
						WinSzie($var[$i][1], $Split[2])
					EndIf

				EndIf
			EndIf
		EndIf
		Sleep(10)
	Next
	$now = 1
EndFunc   ;==>UpdateVisWindowList

Func UpdateHidWindowList()
	$now = 0
	$var = WinList()

	For $i = 1 To $var[0][0]

		If $var[$i][0] <> "" And Not IsVisible($var[$i][1]) And $var[$i][1] <> "" Then
			If WinGetProcess($var[$i][1]) <> @AutoItPID Then

				$Whandle = _ArraySearch($winarray, $var[$i][1], 0, 0, 0, 1)

				If $Whandle == -1 Then
					$iIndex = IconItemAdd($i)
					_ArrayAdd($winarray, $var[$i][1] & "/\/\" & $iIndex & "/\/\" & $var[$i][0])

					If $status == 1 Then
						Status($var[$i][1], $iIndex)
					EndIf

					If $processpid == 1 Then
						Local $Header = "Process / Pid"
						$result = ProcessGetName(WinGetProcess($var[$i][1])) & " / " & WinGetProcess($var[$i][1])
						_GUICtrlListView_AddSubItem($ListView1, $iIndex, $result, GetSubId($Header))
					EndIf

					If $username == 1 Then
						Username($var[$i][1], $iIndex)
					EndIf

					If $size == 1 Then
						WinSzie($var[$i][1], $iIndex)
					EndIf

					If $thandle == 1 Then
						WinHandle($var[$i][1], $iIndex)
					EndIf

					If $processpath == 1 Then
						Processpath($var[$i][1], $iIndex)
					EndIf

					If $states == 1 Then
						States($var[$i][1], $iIndex)
					EndIf

					If $time == 1 Then
						CreationTime($var[$i][1], $iIndex)
					EndIf
				EndIf

				If $Whandle <> -1 Then
					$Split = StringSplit($winarray[$Whandle], "/\/\", 1)
					If $Split[3] <> $var[$i][0] Then _GUICtrlListView_SetItemText($ListView1, $Split[2], $var[$i][0])
					If $Split[3] == $var[$i][0] Then _GUICtrlListView_SetItemText($ListView1, $Split[2], $var[$i][0])

					If $status == 1 Then
						Status($var[$i][1], $Split[2])
					EndIf

					If $states == 1 Then
						States($var[$i][1], $Split[2])
					EndIf

					If $size == 1 Then
						WinSzie($var[$i][1], $Split[2])
					EndIf

				EndIf
			EndIf
		EndIf
		Sleep(10)
	Next
	$now = 1
EndFunc   ;==>UpdateHidWindowList

Func Properties()

	$Form4 = GUICreate("Properties", 633, 317, 193, 242, BitOR($WS_CAPTION, $WS_POPUPWINDOW), "", $Form1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Form4Close", $Form4)

	$Label6 = GUICtrlCreateLabel("Window Ttitle:", 16, 25, 101, 20)
	GUICtrlSetFont($Label6, 10, 800, 0, "MS Sans Serif")
	$Label7 = GUICtrlCreateLabel("Status:", 16, 55, 51, 20)
	GUICtrlSetFont($Label7, 10, 800, 0, "MS Sans Serif")
	$Label8 = GUICtrlCreateLabel("Process / Pid:", 16, 85, 101, 20)
	GUICtrlSetFont($Label8, 10, 800, 0, "MS Sans Serif")
	$Label9 = GUICtrlCreateLabel("Usename:", 16, 115, 74, 20)
	GUICtrlSetFont($Label9, 10, 800, 0, "MS Sans Serif")
	$Label10 = GUICtrlCreateLabel("Size:", 16, 145, 38, 20)
	GUICtrlSetFont($Label10, 10, 800, 0, "MS Sans Serif")
	$Label11 = GUICtrlCreateLabel("Handle:", 16, 175, 58, 20)
	GUICtrlSetFont($Label11, 10, 800, 0, "MS Sans Serif")
	$Label12 = GUICtrlCreateLabel("Process Path:", 16, 205, 100, 20)
	GUICtrlSetFont($Label12, 10, 800, 0, "MS Sans Serif")
	$Label13 = GUICtrlCreateLabel("State:", 16, 235, 40, 20)
	GUICtrlSetFont($Label13, 10, 800, 0, "MS Sans Serif")
	$Label14 = GUICtrlCreateLabel("Creation Time:", 16, 265, 105, 20)
	GUICtrlSetFont($Label14, 10, 800, 0, "MS Sans Serif")
	$Input1 = GUICtrlCreateInput("", 136, 25, 489, 20)
	GUICtrlSetFont($Input1, 10, 800, 0, "MS Sans Serif")
	$Input2 = GUICtrlCreateInput("", 136, 55, 489, 20)
	GUICtrlSetFont($Input2, 10, 800, 0, "MS Sans Serif")
	$Input3 = GUICtrlCreateInput("", 136, 85, 489, 20)
	GUICtrlSetFont($Input3, 10, 800, 0, "MS Sans Serif")
	$Input4 = GUICtrlCreateInput("", 136, 115, 489, 20)
	GUICtrlSetFont($Input4, 10, 800, 0, "MS Sans Serif")
	$Input5 = GUICtrlCreateInput("", 136, 145, 489, 20)
	GUICtrlSetFont($Input5, 10, 800, 0, "MS Sans Serif")
	$Input6 = GUICtrlCreateInput("", 136, 175, 489, 20)
	GUICtrlSetFont($Input6, 10, 800, 0, "MS Sans Serif")
	$Input7 = GUICtrlCreateInput("", 136, 205, 489, 20)
	GUICtrlSetFont($Input7, 10, 800, 0, "MS Sans Serif")
	$Input8 = GUICtrlCreateInput("", 136, 235, 489, 20)
	GUICtrlSetFont($Input8, 10, 800, 0, "MS Sans Serif")
	$Input9 = GUICtrlCreateInput("", 136, 265, 489, 20)
	GUICtrlSetFont($Input9, 10, 800, 0, "MS Sans Serif")

	$Smark = _GUICtrlListView_GetSelectionMark($ListView1)
	If $Smark <> -1 Then
		$sSplit = StringSplit($winarray[$Smark], "/\/\", 1)
	EndIf

	GUICtrlSetData($Input1, _GUICtrlListView_GetItemText($ListView1, $Smark))

	If IsHungAppWindow(HWnd($sSplit[1])) Then
		GUICtrlSetData($Input2, "Not Responding")
	Else
		GUICtrlSetData($Input2, "Running")
	EndIf

	GUICtrlSetData($Input3, ProcessGetName(WinGetProcess(HWnd($sSplit[1]))) & " / " & WinGetProcess(HWnd($sSplit[1])))

	$hProcess = _ProcessOpen(WinGetProcess(HWnd($sSplit[1])), 0x00020000)
	If IsPtr($hProcess) Then
		$result = _ProcessGetOwner($hProcess)
		_ProcessCloseHandle($hProcess)
		GUICtrlSetData($Input4, $result)
	EndIf

	$winstate = WinGetState(HWnd($sSplit[1]))
	If BitAND($winstate, 16) Then
		GUICtrlSetData($Input5, "(Window Should Be Non-Minimized To Get Size)")
	Else
		$winsize = WinGetPos(HWnd($sSplit[1]))
		GUICtrlSetData($Input5, "Width: " & $winsize[2] & " , Height: " & $winsize[3])
	EndIf

	GUICtrlSetData($Input6, $sSplit[1])

	$hProcess = _ProcessOpen(WinGetProcess(HWnd($sSplit[1])), 0x00000400)
	If IsPtr($hProcess) Then
		$result = _ProcessGetPathname($hProcess)
		_ProcessCloseHandle($hProcess)
		GUICtrlSetData($Input7, $result)
	EndIf

	$hProcess = _ProcessOpen(WinGetProcess(HWnd($sSplit[1])), 0x00000400)
	If IsPtr($hProcess) Then
		$result = _ProcessGetTimes($hProcess, 0)
		$result = _WinTime_UTCFileTimeFormat($result, 4 + 8, 1, True)
		_ProcessCloseHandle($hProcess)
		GUICtrlSetData($Input9, $result)
	EndIf

	$ssc = WinGetState(HWnd($sSplit[1]))
	Local $result = ""

	If BitAND($ssc, 2) Then
		$result &= "Visible" & ","
	Else
		$result &= "Hidden" & ","
	EndIf

	If BitAND($ssc, 4) Then
		$result &= "Enabled" & ","
	Else
		$result &= "Disabled" & ","
	EndIf

	If BitAND($ssc, 8) Then $result &= "Active" & ","
	If BitAND($ssc, 16) Then $result &= "Minimized" & ","
	If BitAND($ssc, 32) Then $result &= "Maximized" & ","

	$result = StringTrimRight($result, 1)
	GUICtrlSetData($Input8, $result)

	GUICtrlSetState($Label6, $GUI_FOCUS)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $Form1)
	AdlibUnRegister("UpdateWindowListCall")
EndFunc   ;==>Properties

Func Form4Close()
	GUISetState(@SW_ENABLE, $Form1)
	GUIDelete($Form4)
	AdlibRegister("UpdateWindowListCall", 50)
EndFunc   ;==>Form4Close

Func SelectColumns()

	$Form2 = GUICreate("Select Columns", 270, 161, 288, 250, BitOR($WS_CAPTION, $WS_POPUPWINDOW), "", $Form1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Form2Close", $Form2)

	$Checkbox1 = GUICtrlCreateCheckbox("Window Title", 8, 16, 89, 17)

	$Checkbox2 = GUICtrlCreateCheckbox("Status", 152, 16, 97, 17)
	GUICtrlSetOnEvent($Checkbox2, "Checkbox2Click")
	$Checkbox3 = GUICtrlCreateCheckbox("Process / PID", 8, 40, 89, 17)
	GUICtrlSetOnEvent($Checkbox3, "Checkbox3Click")
	$Checkbox4 = GUICtrlCreateCheckbox("Process Path", 152, 40, 89, 17)
	GUICtrlSetOnEvent($Checkbox4, "Checkbox4Click")
	$Checkbox5 = GUICtrlCreateCheckbox("Creation Time", 8, 64, 89, 17)
	GUICtrlSetOnEvent($Checkbox5, "Checkbox5Click")
	$Checkbox6 = GUICtrlCreateCheckbox("State", 152, 64, 73, 17)
	GUICtrlSetOnEvent($Checkbox6, "Checkbox6Click")
	$Checkbox7 = GUICtrlCreateCheckbox("Handle", 8, 88, 73, 17)
	GUICtrlSetOnEvent($Checkbox7, "Checkbox7Click")
	$Checkbox8 = GUICtrlCreateCheckbox("Username", 152, 88, 73, 17)
	GUICtrlSetOnEvent($Checkbox8, "Checkbox8Click")
	$Checkbox9 = GUICtrlCreateCheckbox("Window Size (Works On Non-Minimized Windows)", 8, 112, 255, 17)
	GUICtrlSetOnEvent($Checkbox9, "Checkbox9Click")

	Ini_Read()
	GUICtrlSetState($Checkbox1, 1)
	GUICtrlSetState($Checkbox1, $GUI_DISABLE)
	GUICtrlSetState($Checkbox2, $status)
	GUICtrlSetState($Checkbox3, $processpid)
	GUICtrlSetState($Checkbox4, $processpath)
	GUICtrlSetState($Checkbox5, $time)
	GUICtrlSetState($Checkbox6, $states)
	GUICtrlSetState($Checkbox7, $thandle)
	GUICtrlSetState($Checkbox8, $username)
	GUICtrlSetState($Checkbox9, $size)

	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $Form1)
	AdlibUnRegister("UpdateWindowListCall")
EndFunc   ;==>SelectColumns

Func Form2Close()
	Ini_Read()
	Local $Header

	$Header = "Status"
	If $status == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "Process / Pid"
	If $processpid == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "Username"
	If $username == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "Size"
	If $size == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "Handle"
	If $thandle == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "Process Path"
	If $processpath == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "State"
	If $states == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	$Header = "Creation Time"
	If $time == 1 Then
		AddColumnUpdate($Header)
	Else
		DelColumnUpdate($Header)
	EndIf

	GUISetState(@SW_ENABLE, $Form1)
	GUIDelete($Form2)

	$Header = "Process / Pid"
	If $processpid == 1 Then
		For $m = 0 To (UBound($winarray) - 1)
			Local $Header = "Process / Pid"

			$zsplit = StringSplit($winarray[$m], "/\/\", 1)
			$procH = WinGetProcess(HWnd($zsplit[1]))
			If $procH <> @AutoItPID Then
				$result = ProcessGetName($procH) & " / " & $procH
				_GUICtrlListView_AddSubItem($ListView1, $m, $result, GetSubId($Header))
			EndIf
		Next
	EndIf

	$Header = "Username"
	If $username == 1 Then
		For $m = 0 To (UBound($winarray) - 1)
			$zsplit = StringSplit($winarray[$m], "/\/\", 1)
			$procH = WinGetProcess(HWnd($zsplit[1]))
			If $procH <> @AutoItPID Then
				Username(HWnd($zsplit[1]), $m)
			EndIf
		Next
	EndIf

	$Header = "Handle"
	If $thandle == 1 Then
		For $m = 0 To (UBound($winarray) - 1)
			$zsplit = StringSplit($winarray[$m], "/\/\", 1)
			$procH = WinGetProcess(HWnd($zsplit[1]))
			If $procH <> @AutoItPID Then
				WinHandle($zsplit[1], $m)
			EndIf
		Next
	EndIf

	$Header = "Process Path"
	If $processpath == 1 Then
		For $m = 0 To (UBound($winarray) - 1)
			$zsplit = StringSplit($winarray[$m], "/\/\", 1)
			$procH = WinGetProcess(HWnd($zsplit[1]))
			If $procH <> @AutoItPID Then
				Processpath(HWnd($zsplit[1]), $m)
			EndIf
		Next
	EndIf

	$Header = "Creation Time"
	If $time == 1 Then
		For $m = 0 To (UBound($winarray) - 1)
			$zsplit = StringSplit($winarray[$m], "/\/\", 1)
			$procH = WinGetProcess(HWnd($zsplit[1]))
			If $procH <> @AutoItPID Then
				CreationTime(HWnd($zsplit[1]), $m)
			EndIf
		Next
	EndIf

	AdlibRegister("UpdateWindowListCall", 50)
EndFunc   ;==>Form2Close

Func DelColumnUpdate($Header)
	For $k = 0 To (_GUICtrlListView_GetColumnCount($ListView1) - 1)
		$aInfo = _GUICtrlListView_GetColumn($ListView1, $k)
		If $aInfo[5] = $Header Then _GUICtrlListView_DeleteColumn($ListView1, $k)
	Next
EndFunc   ;==>DelColumnUpdate

Func AddColumnUpdate($Header)
	Dim $ctext[_GUICtrlListView_GetColumnCount($ListView1)]

	For $k = 0 To (_GUICtrlListView_GetColumnCount($ListView1) - 1)
		$aInfo = _GUICtrlListView_GetColumn($ListView1, $k)
		$ctext[$k] = $aInfo[5]
	Next

	If _ArraySearch($ctext, $Header) == -1 Then
		Ini_Read()
		Local $width = 300
		If $Header == "Status" Then $width = $cstatsize
		If $Header == "Process / Pid" Then $width = $cprocsize
		If $Header == "Username" Then $width = $cusersize
		If $Header == "Size" Then $width = $cdosize
		If $Header == "Handle" Then $width = $chsize
		If $Header == "Process Path" Then $width = $cpathsize
		If $Header == "State" Then $width = $cstsize
		If $Header == "Creation Time" Then $width = $ctsize
		_GUICtrlListView_InsertColumn($ListView1, _GUICtrlListView_GetColumnCount($ListView1), $Header, $width)
	EndIf
	$ctext = 0
EndFunc   ;==>AddColumnUpdate

Func Checkbox2Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Status", 1)
	Else
		IniWrite($IniPath, "Columns", "Status", 0)
	EndIf
EndFunc   ;==>Checkbox2Click

Func Checkbox3Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Processpid", 1)
	Else
		IniWrite($IniPath, "Columns", "Processpid", 0)
	EndIf
EndFunc   ;==>Checkbox3Click

Func Checkbox4Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Processpath", 1)
	Else
		IniWrite($IniPath, "Columns", "Processpath", 0)
	EndIf
EndFunc   ;==>Checkbox4Click

Func Checkbox5Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Time", 1)
	Else
		IniWrite($IniPath, "Columns", "Time", 0)
	EndIf
EndFunc   ;==>Checkbox5Click

Func Checkbox6Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "States", 1)
	Else
		IniWrite($IniPath, "Columns", "States", 0)
	EndIf
EndFunc   ;==>Checkbox6Click

Func Checkbox7Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Handle", 1)
	Else
		IniWrite($IniPath, "Columns", "Handle", 0)
	EndIf
EndFunc   ;==>Checkbox7Click

Func Checkbox8Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Username", 1)
	Else
		IniWrite($IniPath, "Columns", "Username", 0)
	EndIf
EndFunc   ;==>Checkbox8Click

Func Checkbox9Click()
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) = $GUI_CHECKED Then
		IniWrite($IniPath, "Columns", "Size", 1)
	Else
		IniWrite($IniPath, "Columns", "Size", 0)
	EndIf
EndFunc   ;==>Checkbox9Click

Func About()

	$Form3 = GUICreate("About", 318, 245, 302, 218, BitOR($WS_CAPTION, $WS_POPUPWINDOW), "", $Form1)
	$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 297, 225)
	$Image1 = GUICtrlCreateIcon(@ScriptFullPath, 99, 10, 15, 130, 130, $WS_GROUP)
	$Label0 = GUICtrlCreateLabel("Made By Zohran Arif Butt. Pakistan.", 20, 140, 200, 17, $WS_GROUP)
	$Label1 = GUICtrlCreateLabel("Window Detector", 20, 158, 87, 17, $WS_GROUP)
	$Label2 = GUICtrlCreateLabel("Version  1.0", 20, 176, 60, 17, $WS_GROUP)
	$Label3 = GUICtrlCreateLabel("Copyright: © Z -Tech 2011. All Rights Reserved.", 20, 214, 260, 17, $WS_GROUP)
	$Label4 = GUICtrlCreateLabel("For FeedBacks Mail Me At z_tech7@yahoo.com", 20, 194, 260, 17)
	$Label5 = GUICtrlCreateLabel("", 152, 30, 120, 100, $SS_NOTIFY)
	GUICtrlSetBkColor($Label5, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetCursor($Label5, 0)
	$Icon1 = GUICtrlCreateIcon(@ScriptFullPath, 202, 152, 30, 120, 100, $WS_GROUP)
	GUICtrlSetBkColor($Icon1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetCursor($Icon1, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISetOnEvent($GUI_EVENT_CLOSE, "Form3Close", $Form3)
	GUICtrlSetOnEvent($Label5, "Donate")

	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $Form1)
	AdlibUnRegister("UpdateWindowListCall")
EndFunc   ;==>About

Func Donate()
	ShellExecute("https://www.moneybookers.com/send-money/")
EndFunc   ;==>Donate

Func Form3Close()
	GUISetState(@SW_ENABLE, $Form1)
	GUIDelete($Form3)
	AdlibRegister("UpdateWindowListCall", 50)
EndFunc   ;==>Form3Close