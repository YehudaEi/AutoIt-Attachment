#Include <GuiListView.au3>
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC",0)
Opt("WinSearchChildren", 1)
Opt("WinDetectHiddenText", 1)
Opt("TrayIconHide", 1)
Opt("WinTitleMatchMode", 4)

#Region ### START Koda GUI section ### Form=enabler.kxf
$Form1 = GUICreate("Enabler 3.0 by lokster", 658, 196, -1, -1, -1, BitOR($WS_EX_APPWINDOW,$WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
$Label1 = GUICtrlCreateLabel("hWnd:", 0, 6, 36, 17)
$Label2 = GUICtrlCreateLabel("Text:", 0, 62, 28, 17)
$Label3 = GUICtrlCreateLabel("Class", 0, 86, 29, 17)
$Label6 = GUICtrlCreateLabel("PID:", 0, 110, 25, 17)
$Label7 = GUICtrlCreateLabel("Exe:", 0, 134, 25, 17)
$Input1 = GUICtrlCreateInput("", 32, 2, 89, 21)
GUICtrlSetOnEvent(-1, "AInput1Change")
$Button1 = GUICtrlCreateButton("+", 128, 2, 19, 21, 0)
GUICtrlSetOnEvent(-1, "AButton1Click")
$Input2 = GUICtrlCreateInput("", 32, 58, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input3 = GUICtrlCreateInput("", 32, 82, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input4 = GUICtrlCreateInput("", 32, 106, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input5 = GUICtrlCreateInput("", 32, 130, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Checkbox1 = GUICtrlCreateCheckbox("Visible", 32, 178, 49, 17)
GUICtrlSetOnEvent(-1, "ACheckbox1Click")
$Checkbox2 = GUICtrlCreateCheckbox("Enabled", 112, 178, 57, 17)
GUICtrlSetOnEvent(-1, "ACheckbox2Click")
$Checkbox4 = GUICtrlCreateCheckbox("Keep on top", 32, 40, 129, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "ACheckbox4Click")
$Checkbox3 = GUICtrlCreateCheckbox("Find only visible/active", 32, 26, 129, 15)
$Button5 = GUICtrlCreateButton("^", 152, 2, 19, 21, 0)
GUICtrlSetOnEvent(-1, "AButton5Click")
$Input6 = GUICtrlCreateInput("", 32, 154, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label5 = GUICtrlCreateLabel("Color:", 0, 158, 31, 17)
$Tab1 = GUICtrlCreateTab(176, 0, 481, 193)
$TabSheet1 = GUICtrlCreateTabItem("Child windows")
$ListView1 = GUICtrlCreateListView("Text|Class|HWND|V|Parent", 180, 24, 473, 165, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
$TabSheet2 = GUICtrlCreateTabItem("Text inside window")
$Edit1 = GUICtrlCreateEdit("", 180, 24, 473, 165, BitOR($ES_READONLY,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global Const $WM_COMMAND = 0x0111
Global Const $EN_CHANGE = 0x300

Global $down = False
Global $prev_hwnd


$user32 = DllOpen("USER32.DLL")

GUISetOnEvent($GUI_EVENT_CLOSE, "Bye")
GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")


_GUICtrlListViewSetColumnWidth($ListView1,0,100)
_GUICtrlListViewSetColumnWidth($ListView1,1,100)
_GUICtrlListViewSetColumnWidth($ListView1,2,90)
_GUICtrlListViewSetColumnWidth($ListView1,3,30)
_GUICtrlListViewSetColumnWidth($ListView1,4,90)

Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0xFFFF)
    Local $hCtrl = $lParam

    Switch $nID
        Case $Input1
            Switch $nNotifyCode
				Case $EN_CHANGE
					Find(GUICtrlRead($Input1))
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND

Func GetWindowText( $hwnd )
	dim $WinText
	$Result = DLLCall($user32, "Int", "GetWindowText", "HWnd",$hwnd, "Str", $WinText, "Int", 80)
	Return $Result[2]
EndFunc

Func GetWindowClass( $hwnd )
	dim $WinText
	$Result = DLLCall($user32, "Int", "GetClassName", "HWnd",$hwnd, "Str", $WinText, "Int", 80)
	Return $Result[2]
EndFunc

Func WindowFromPoint( $x,$y )
	$Result = DllCall( $user32, "hwnd", "WindowFromPoint", "int",$x,"int",$y)
	$point = 0
	Return $Result[0]
EndFunc

Func RealChildWindowFromPoint($hWndParent, $x,$y )
	$pos = WinGetPos($hWndParent)
	If @error Then Return 0
	$size = WinGetClientSize($hWndParent)
	If @error Then Return 0
	$pos[0] += (($pos[2] - $size[0]) / 2)
	$pos[1] += (($pos[3] - $size[1]) - (($pos[2] - $size[0]) / 2))
	$cHwnd = DLLCall($user32,"hwnd","RealChildWindowFromPoint","hwnd",$hWndParent, "int",$x - $pos[0],"int",$y - $pos[1])
	return $cHwnd[0]
EndFunc

Func ShowWindow( $hWnd,$nCmdShow )
	$Result = DllCall( $user32, "hwnd", "ShowWindow", "hwnd",$hWnd,"int",$nCmdShow)
	Return $Result
EndFunc

Func EnableWindow( $hWnd,$bEnable )
	$Result = DllCall( $user32, "hwnd", "EnableWindow", "hwnd",$hWnd,"int",$bEnable)
	Return $Result
EndFunc

Func AButton1Click()
	HotKeySet("{ESC}","CancelSearch")
	GUICtrlSetState($Button1,$GUI_DISABLE)
	$down  = True
EndFunc

Func CancelSearch()
	GUICtrlSetState($Button1,$GUI_ENABLE)
	$down  = False
	HotKeySet("{ESC}")
EndFunc


Func AInput1Change()
	Find(GUICtrlRead($Input1))
EndFunc
	
Func AButton5Click()
	Find(GetParent(GUICtrlRead($Input1)))
EndFunc

		
Func ACheckbox1Click()
	$hwnd = GUICtrlRead($Input1)
	if GUICtrlRead($Checkbox1) == $GUI_CHECKED Then
		ShowWindow($hwnd,  1)
	Else
		ShowWindow($hwnd,  0)
	EndIf
EndFunc

Func ACheckbox2Click()
	$hwnd = GUICtrlRead($Input1)
	if GUICtrlRead($Checkbox2) == $GUI_CHECKED Then
		EnableWindow($hwnd, 1)
	Else
		EnableWindow($hwnd, 0)
	EndIf
EndFunc

Func ACheckbox4Click()
	if GUICtrlRead($Checkbox4) == $GUI_CHECKED Then
		WinSetOnTop($Form1,"",1)
	Else
		WinSetOnTop($Form1,"",0)
	EndIf
EndFunc

Func GetParent($hwnd)
	$Result = DllCall( $user32, "hwnd", "GetParent", "hwnd",$hwnd)
	Return $Result[0]
EndFunc

Func Bye()
	DllClose($user32)
	Exit
EndFunc

Func IsWindowVisible($hWnd)
	$Result = DllCall( $user32, "int", "IsWindowVisible", "hwnd",$hwnd)
	Return $Result[0]
EndFunc

Func IsWindowEnabled($hWnd)
	$Result = DllCall( $user32, "int", "IsWindowEnabled", "hwnd",$hwnd)
	Return $Result[0]
EndFunc

Func AListView1DblClick()
	$item = GUICtrlRead(GUICtrlRead($ListView1,1))
	$arr = StringSplit($item,"|")
	Find($arr[3])
EndFunc

Func Find($hwnd)
	Local $pid

	if IsWindowEnabled($hwnd) Then
		GUICtrlSetState($Checkbox2,$GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox2,$GUI_UNCHECKED)
	EndIf
	
	if IsWindowVisible($hwnd) Then
		GUICtrlSetState($Checkbox1,$GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox1,$GUI_UNCHECKED)
	EndIf
	
	GUICtrlSetData($Input1,$hwnd)
	GUICtrlSetData($Input2,GetWindowText($hwnd))
	GUICtrlSetData($Input3,GetWindowClass($hwnd))
	
	
	
	$pid = WinGetProcess($hwnd)
	$list = ProcessList()
	
	For $i = 1 to $list[0][0]
		if $list[$i][1] = $pid Then
			GUICtrlSetData($Input4,$pid)
			GUICtrlSetData($Input5,$list[$i][0])
		EndIf
	Next
	
	$var = WinList()
	DllCall($user32, "int", "SendMessage", "hwnd", GUICtrlGetHandle($ListView1), "int", 0x000B, "int", 0,"int", 0); ListView BeginUpdate
	_GUICtrlListViewDeleteAllItems($ListView1)
	For $i = 1 to $var[0][0]
		if GetParent($var[$i][1]) == $hwnd then
			$item = $var[$i][0]&"|"&GetWindowClass($var[$i][1])&"|"&$var[$i][1]&"|"&IsWindowVisible($var[$i][1])&"|"&GetParent($var[$i][1])
			GUICtrlCreateListViewItem($item,$ListView1)
			GUICtrlSetOnEvent(-1, "AListView1DblClick")
		EndIf
	Next
	DllCall($user32, "int", "SendMessage", "hwnd", GUICtrlGetHandle($ListView1), "int", 0x000B, "int", 1,"int", 0); ListView EndUpdate
	GUICtrlSetData($Edit1,WinGetText($hwnd))
	GUISetState()
EndFunc

While 1
	if $down = true Then
		$pos = MouseGetPos()
		
		$hwnd = WindowFromPoint($pos[0],$pos[1])
		$color = PixelGetColor($pos[0],$pos[1])
		GUICtrlSetData($Input6,'0x'&Hex($color,6))
		GUICtrlSetColor($Input6,BitXOR($color,0xFFFFFF))
		GUICtrlSetBkColor($Input6,$color)
		if GUICtrlRead($Checkbox3) = $GUI_UNCHECKED Then
			$chwnd = RealChildWindowFromPoint($hwnd,$pos[0],$pos[1])
			if $chwnd <> 0 Then
				$hwnd = $chwnd
			EndIf		
		EndIf

		if $hwnd <> $prev_hwnd Then
			Find($hwnd)
			$prev_hwnd = $hwnd
		EndIf
		
	EndIf
	
	Sleep(10)
WEnd
