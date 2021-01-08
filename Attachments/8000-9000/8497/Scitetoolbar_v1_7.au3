;SciTE toolbar version 1.7
;Concept by Volly
;Written by JdeB, Gafrost, and Volly
;contributers include: Valuater, thatsgreat2345, JSThePatriot: for helping with either
;					   bug discovery, or fix suggestions. THANK YOU!
;----------------------------------------------------------------------------------------

#cs
Notes:
Changes from 1.6:
	1. Icon folder name changed to bin
	2. INI file is now located in bin folder
	3. Options menu added to allow for adding or removing buttons
	4. Divider bars now more closely match SciTE's built in toolbar
	5. Dividers will now divide by group instead of 4 icons
	6. No need to make the ini file anymore. If one doesn't exist, the script will make one, then open
	   the options menu to allw for you to pick the buttons you want to use.
	6. Icons added.
	If you wish to add icons of your choosing, goto http://www.iconarchive.com to download icons for free

#ce
#NoTrayIcon
#include<guiconstants.au3>
#include<misc.au3>
#include<string.au3>
Opt("MouseCoordMode", 2)
Opt("WinSearchChildren", 1)
Opt("WinTitleMatchMode", 4)
$item32="Pinchers.ICO|Options"  ;moved from list below. 
$item33="Door2.ico|Exit Toolbar"  ;moved from list below
;INI file check. If INI doesn't exist, one is made.
$chkF=FileExists(@ScriptDir & "\bin\SciteToolbar.ini")
if $chkF = 0 then 
	IniWrite(@ScriptDir & "\bin\SciteToolbar.ini","bar", "top", "54")
	IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "bar", "")
	IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "108", $item32)
	IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "9999", $item33)	
	FileWriteLine(@ScriptDir & "\bin\SciteToolbar.ini", "bar=")
    IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "bar", "new", "1")
endif	
;Check if SciTE is running and start it if needed.
If Not ProcessExists("SciTE.exe") Then
	Global $SciTE_Dir = RegRead('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\SciTE.exe', '')
	Run($SciTE_Dir)
	If Not WinWait("classname=SciTEWindow", 3000) Then Exit
EndIf

If _Singleton("SciTEAdditionalIcons", 1) = 0 Then Exit
Global $WM_COPYDATA = 74
Global $SciTECmd
Global $last_SciTE_Pos_x = -99999
Global $last_SciTE_Pos_y = -99999
Global $Scite_Hwnd = WinGetHandle("classname=SciTEWindow")
Global $Scite_pos = WinGetPos($Scite_Hwnd)
Global $w_size = WinGetClientSize($Scite_Hwnd)
; Get SciTE DirectorHandle
Global $Scite_Dir_hwnd = WinGetHandle("DirectorExtension")
; Get My GUI Handle numeric
Global $My_Hwnd = GUICreate("SciTE interface", 100, 18, Default, Default,$WS_POPUP, $WS_EX_TOOLWINDOW, $Scite_hwnd)
Global $My_Gui_Width = 0
Global $go[1][2]
;
$Toolbar_Info = IniReadSection(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar")
$BarTop_Add = Int(IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "Bar", "Top", 54))
;GUISetState()
_Adjust_Toolbar_Info($Toolbar_Info)
_CreateToolbar($go, $Toolbar_Info, $My_Gui_Width)
$My_Dec_Hwnd = Dec(StringTrimLeft($My_Hwnd, 2))
;Register COPYDATA message.
GUIRegisterMsg($WM_COPYDATA, "MY_WM_COPYDATA")
While 1
	If Not WinExists($Scite_Hwnd) Then Exit
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	If $msg > 1 Then
		For $x = 0 To UBound($go) - 1
			If $msg = $go[$x][0] Then
				If $go[$x][1] = 9999 Then Exit
				if $go[$x][1] = 961 then Send ("{F11}")
				if $go[$x][1] = 107 then
					$Url = "http://www.autoitscript.com/forum/index.php?act=idx"
		            DllCall("shell32.dll", "long", "ShellExecute", "hwnd", 0, "string", 'open', "string", $Url, "string", '', "string", @ScriptDir, "long", @SW_SHOWNORMAL)
				endif
				if $go[$x][1] = 108 then
					_options()
				endif	
				SendSciTE_Command($My_Hwnd, $Scite_Dir_hwnd, StringFormat("menucommand:%04d", $go[$x][1]))
				_tiprefresh()
				ExitLoop
			EndIf
		Next
	EndIf
	; set position of window correct
	If WinActive($Scite_Hwnd) Or WinActive($My_Hwnd) Then
		$Scite_pos = WinGetPos($Scite_Hwnd)
		If $Scite_pos[0] <> $last_SciTE_Pos_x Or $Scite_pos[1] <> $last_SciTE_Pos_y Then
			$last_SciTE_Pos_x = $Scite_pos[0]
			$last_SciTE_Pos_y = $Scite_pos[1]
			$w_size = WinGetClientSize($Scite_Hwnd)
			WinMove($My_Hwnd, '', $Scite_pos[0] + 360, $Scite_pos[1] + ($Scite_pos[3] - $w_size[1]), $My_Gui_Width, 18)
			GUISetState(@SW_SHOW)
		EndIf
	EndIf
	; Re activate SciTE when Buttn window is activated
	If WinActive($My_Hwnd) Then 
		WinActivate($Scite_Hwnd)
	EndIf
	if IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "bar", "new", "") = 1 then _options()
WEnd
Exit	

Func _Adjust_Toolbar_Info(ByRef $Toolbar_Info)
	ReDim $Toolbar_Info[UBound($Toolbar_Info) - 1][3]
	Local $tmp_string
	For $x = 1 To UBound($Toolbar_Info) - 1
		If $Toolbar_Info[$x][0] <> "bar" Then
			$tmp_string = StringSplit($Toolbar_Info[$x][1], "|")
			$Toolbar_Info[$x][1] = $tmp_string[1]
			$Toolbar_Info[$x][2] = $tmp_string[2]
		EndIf
	Next
EndFunc   ;==>_Adjust_Toolbar_Info
;
Func _CreateToolbar(ByRef $go, ByRef $Toolbar_Info, ByRef $My_Gui_Width)
	Local $x, $y, $bar
	ReDim $go[UBound($Toolbar_Info) ][2]
	$y = 1
	For $x = 1 To UBound($Toolbar_Info) - 1
		If $Toolbar_Info[$x][0] = "bar" Then
			$vbar1=GUICtrlCreateGraphic($y, 1, 1, 24, $SS_GRAYFRAME)
			GUICtrlSetBkColor($vbar1, 0xFF0000)
			GUICtrlSetResizing($vbar1, $GUI_DOCKALL)
			$vbar2=GUICtrlCreateGraphic(($y+1), 1, 1, 24)
			GUICtrlSetBkColor($vbar2, 0xffffff)
			GUICtrlSetResizing($vbar2, $GUI_DOCKALL)			
			$y += 5
			
		Else
			$go[$x][0] = GUICtrlCreateIcon(@ScriptDir & "\bin\" & $Toolbar_Info[$x][1], -1, $y + 4, 1, 16, 16, Default, $SS_LEFT)
			$go[$x][1] = Number($Toolbar_Info[$x][0])
			GUICtrlSetTip($go[$x][0], $Toolbar_Info[$x][2])
			$y += 24
		EndIf
	Next
	$My_Gui_Width = $y
EndFunc   ;==>_CreateToolbar

; Refreshes tip on icon after icon is clicked.
Func _tiprefresh()
	For $x = 1 To UBound($Toolbar_Info) - 1
		GUICtrlSetTip($go[$x][0], $Toolbar_Info[$x][2])
	Next
EndFunc   ;==>_tiprefresh

; Send command to SciTE
Func SendSciTE_Command($My_Hwnd, $Scite_Dir_hwnd, $sCmd)
	Sleep(100)
	ConsoleWrite('-->' & $sCmd & @LF)
	Local $CmdStruct = DllStructCreate('Char[' & StringLen($sCmd) + 1 & ']')
	DllStructSetData($CmdStruct, 1, $sCmd)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr')
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, StringLen($sCmd) + 1)
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($CmdStruct))
	DllCall('User32.dll', 'None', 'SendMessage', 'HWnd', $Scite_Dir_hwnd, _
			'Int', $WM_COPYDATA, 'HWnd', $My_Hwnd, _
			'Ptr', DllStructGetPtr($COPYDATA))
EndFunc   ;==>SendSciTE_Command

; Received Data from SciTE
Func MY_WM_COPYDATA($hWnd, $msg, $wParam, $lParam)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr', $lParam)
	$SciTECmdLen = DllStructGetData($COPYDATA, 2)
	Local $CmdStruct = DllStructCreate('Char[255]', DllStructGetData($COPYDATA, 3))
	$SciTECmd = StringLeft(DllStructGetData($CmdStruct, 1), $SciTECmdLen)
	ConsoleWrite('<--' & $SciTECmd & @LF)
	;GUICtrlSetData($list,GUICtrlRead($list) & '<--' & $SciTECmd & @CRLF )
EndFunc   ;==>MY_WM_COPYDATA

Func _options()
if WinExists("SciTE interface") then GUIDelete($My_Hwnd)
$opt1=GuiCreate("SciTE Toolbar Options", 400, 420,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
;GUI CONTROLS SECTION---------------------------------------------------------
;standard release 
$Checkbox_1 = GuiCtrlCreateCheckbox("Run", 15, 20, 96, 14)
$Checkbox_2 = GuiCtrlCreateCheckbox("Compile", 15, 40, 93, 14)
$Checkbox_3 = GuiCtrlCreateCheckbox("AutoIt Helpfile V3.1.1", 15, 60, 120, 14)
$Checkbox_4 = GuiCtrlCreateCheckbox("SyntaxCheck", 15, 80, 120, 14)
$group1 = GUICtrlCreateGroup("Standard", 10, 0, 140, 100)
GUICtrlSetBkColor($group1,0x00ff00)
;beta release
$Checkbox_5 = GuiCtrlCreateCheckbox("Run with Beta", 15, 125, 120, 14)
$Checkbox_6 = GuiCtrlCreateCheckbox("Compile with Beta", 15, 145, 120, 14)
$Checkbox_7 = GuiCtrlCreateCheckbox("Beta AutoIt Helpfile", 15, 165, 120, 14)
$Checkbox_8 = GuiCtrlCreateCheckbox("Syntax Check Beta", 15, 185, 120, 14)
$group2 = GUICtrlCreateGroup("Beta", 10, 105, 140, 100)
GUICtrlSetBkColor($group2,0x00ffff)
;external tools
$Checkbox_9 = GuiCtrlCreateCheckbox("Function Popup", 15, 230, 120, 14)
$Checkbox_10 = GuiCtrlCreateCheckbox("AutoIt Window Info", 15, 250, 120, 14)
$Checkbox_11 = GuiCtrlCreateCheckbox("AU3Recorder", 15, 270, 120, 14)
$Checkbox_12 = GuiCtrlCreateCheckbox("Macro Generator", 15, 290, 120, 14)
$Checkbox_13 = GuiCtrlCreateCheckbox("Tidy AutoIt Source", 15, 310, 120, 14)
$Checkbox_14 = GuiCtrlCreateCheckbox("Code Wizard", 15, 330, 120, 14)
$Checkbox_15 = GuiCtrlCreateCheckbox("GUI Builder", 15, 350, 120, 14)
$Checkbox_16 = GuiCtrlCreateCheckbox("Koda(FormDesigner)", 15, 370, 120, 14)
$Checkbox_17 = GuiCtrlCreateCheckbox("AutoIt Forum", 15, 390, 120, 14)
$group3 = GUICtrlCreateGroup("External Tools", 10, 210, 140, 200)
GUICtrlSetBkColor($group3,0x0000ff)
;SciTE shortcut tools
$Checkbox_18 = GuiCtrlCreateCheckbox("Insert Bookmarked Line(s)", 165, 20, 180, 14)
$Checkbox_19 = GuiCtrlCreateCheckbox("Debug to MsgBox", 165, 40, 150, 14)
$Checkbox_20 = GuiCtrlCreateCheckbox("Debug to Console", 165, 60, 120, 14)
$Checkbox_21 = GuiCtrlCreateCheckbox("Debug Remove Lines", 165, 80, 120, 14)
$Checkbox_22 = GuiCtrlCreateCheckbox("Full Screen", 165, 100, 120, 14)
$Checkbox_23 = GuiCtrlCreateCheckbox("Show Call tip", 165, 120, 120, 14)
$Checkbox_24 = GuiCtrlCreateCheckbox("Complete Symble", 165, 140, 120, 14)
$Checkbox_25 = GuiCtrlCreateCheckbox("Selected text Uppercase", 165, 160, 150, 14)
$Checkbox_26 = GuiCtrlCreateCheckbox("Selected text Lowercase", 165, 180, 150, 14)
$Checkbox_27 = GuiCtrlCreateCheckbox("Block comment or uncomment", 165, 200, 165, 14)
$Checkbox_28 = GuiCtrlCreateCheckbox("Box Comment", 165, 220, 120, 14)
$Checkbox_29 = GuiCtrlCreateCheckbox("Insert Abbrevation", 165, 240, 120, 14)
$Checkbox_30 = GuiCtrlCreateCheckbox("Clear output", 165, 260, 120, 14)
$Checkbox_31 = GuiCtrlCreateCheckbox("Macro list", 165, 280, 120, 14)
$group4 = GUICtrlCreateGroup("Built in SciTE Tools", 160, 0, 180, 300)
GUICtrlSetBkColor($group4,0xff0000)
$button1=GUICtrlCreateButton("Select All", 160, 310, 85, 25) 
$button2=GUICtrlCreateButton("Remove All", 160, 340, 85, 25)
$button3=GUICtrlCreateButton("Apply and Close", 255, 310, 85, 25)
$button4=GUICtrlCreateButton("Cancel", 255, 340, 85, 25)
#region -GUI STARTUP SETTINGS SECTION
;standard
$item1="Rocket.ico|Run"
$item2="Tools1.ico|Compile"
$item3="Qmark.ico|AutoIt Helpfile V3.1.1"
$item4="Envel.ico|SyntaxCheck"
$item5="go.ico|Run with Beta"
$item6="toolbox.ico|Compile with Beta"
$item7="Book07.ico|Beta AutoIt Helpfile"
$item8="SafetyHelmet.ico|Syntax Check Beta"
$item9="FuncPopUp.ico|Function Popup"
$item10="Binoculars1c.ico|AutoIt Window Info"
$item11="SonyTRV99.ico|AU3Recorder"
$item12="Etchasketch.ico|Macro Generator"
$item13="tidy.ico|Tidy AutoIt Source"
$item14="Wizard.ico|Code Wizard"
$item15="CodelessDrill.ico|GUI Builder"
$item16="Crayons.ico|Koda(FormDesigner)"
$item17="au3.ico|AutoIt Forum"
$item18="NotePad.ico|Insert Bookmarked Line(s)"
$item19="IDBadge.ico|Debug to MsgBox"
$item20="Zvaiofu045.ico|Debug to Console"
$item21="Papertowels.ico|Debug Remove Lines"
$item22="full.ico|Full Screen"
$item23="text.ico|Show Call tip"
$item24="incid.ICO|Complete Symble"
$item25="upper.ico|Selected text Uppercase"
$item26="lower.ico|Selected text Lowercase"
$item27="padlock.ICO|Block comment or uncomment"
$item28="OpenBox.ico|Box Comment"
$item29="insert_abb.ICO|Insert Abbrevation"
$item30="cleaner.ICO|Clear output"
$item31="macro1.ico|Macro list"


#endregion
#region - ini check to see what needs to be checked before GUI is enabled
$check1 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","303","")
if $check1 = $item1 then GUICtrlSetState($Checkbox_1,$GUI_CHECKED)
$check2 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","301","")
if $check2 = $item2 then GUICtrlSetState($Checkbox_2,$GUI_CHECKED)
$check3 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","901","")
if $check3 = $item3 then GUICtrlSetState($Checkbox_3,$GUI_CHECKED)
$check4 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1103","")
if $check4 = $item4 then GUICtrlSetState($Checkbox_4,$GUI_CHECKED)	
$check5 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1100","")
if $check5 = $item5 then GUICtrlSetState($Checkbox_5,$GUI_CHECKED)
$check6 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1101","")
if $check6 = $item6 then GUICtrlSetState($Checkbox_6,$GUI_CHECKED)	
$check7 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1102","")
if $check7 = $item7 then GUICtrlSetState($Checkbox_7,$GUI_CHECKED)
$check8 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1104","")
if $check8 = $item8 then GUICtrlSetState($Checkbox_8,$GUI_CHECKED)	
$check9 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1105","")
if $check9 = $item9 then GUICtrlSetState($Checkbox_9,$GUI_CHECKED)	
$check10 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1106","")
if $check10 = $item10 then GUICtrlSetState($Checkbox_10,$GUI_CHECKED)
$check11 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1107","")
if $check11 = $item11 then GUICtrlSetState($Checkbox_11,$GUI_CHECKED)
$check12 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1108","")
if $check12 = $item12 then GUICtrlSetState($Checkbox_12,$GUI_CHECKED)	
$check13 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1109","")
if $check13 = $item13 then GUICtrlSetState($Checkbox_13,$GUI_CHECKED)
$check14 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1110","")
if $check14 = $item14 then GUICtrlSetState($Checkbox_14,$GUI_CHECKED)
$check15 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1111","")
if $check15 = $item15 then GUICtrlSetState($Checkbox_15,$GUI_CHECKED)
$check16 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1112","")
if $check16 = $item16 then GUICtrlSetState($Checkbox_16,$GUI_CHECKED)	
$check17 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","107","")
if $check17 = $item17 then GUICtrlSetState($Checkbox_17,$GUI_CHECKED)
$check18 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1123","")
if $check18 = $item18 then GUICtrlSetState($Checkbox_18,$GUI_CHECKED)
$check19 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1124","")
if $check19 = $item19 then GUICtrlSetState($Checkbox_19,$GUI_CHECKED)	
$check20 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1125","")
if $check20 = $item20 then GUICtrlSetState($Checkbox_20,$GUI_CHECKED)
$check21 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","1126","")
if $check21 = $item21 then GUICtrlSetState($Checkbox_21,$GUI_CHECKED)
$check22 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","961","")
if $check22 = $item22 then GUICtrlSetState($Checkbox_22,$GUI_CHECKED)
$check23 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","232","")
if $check23 = $item23 then GUICtrlSetState($Checkbox_23,$GUI_CHECKED)	
$check24 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","233","")
if $check24 = $item24 then GUICtrlSetState($Checkbox_24,$GUI_CHECKED)
$check25 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","240","")
if $check25 = $item25 then GUICtrlSetState($Checkbox_25,$GUI_CHECKED)
$check26 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","241","")
if $check26 = $item26 then GUICtrlSetState($Checkbox_26,$GUI_CHECKED)		
$check27 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","243","")
if $check27 = $item27 then GUICtrlSetState($Checkbox_27,$GUI_CHECKED)
$check28 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","246","")
if $check28 = $item28 then GUICtrlSetState($Checkbox_28,$GUI_CHECKED)
$check29 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","247","")
if $check29 = $item29 then GUICtrlSetState($Checkbox_29,$GUI_CHECKED)
$check30 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","420","")
if $check30 = $item30 then GUICtrlSetState($Checkbox_30,$GUI_CHECKED)
$check31 = IniRead(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar","314","")
if $check31 = $item31 then GUICtrlSetState($Checkbox_31,$GUI_CHECKED)
#endregion

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $button1
		GUICtrlSetState($Checkbox_1,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_2,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_3,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_4,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_5,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_6,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_7,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_8,$GUI_CHECKED)		
		GUICtrlSetState($Checkbox_9,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_10,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_11,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_12,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_13,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_14,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_15,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_16,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_17,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_18,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_19,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_20,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_21,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_22,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_23,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_24,$GUI_CHECKED)		
		GUICtrlSetState($Checkbox_25,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_26,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_27,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_28,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_29,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_30,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_31,$GUI_CHECKED)
		
	Case $msg = $button2
		GUICtrlSetState($Checkbox_1,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_2,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_3,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_4,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_5,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_6,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_7,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_8,$GUI_UNCHECKED)		
		GUICtrlSetState($Checkbox_9,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_10,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_11,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_12,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_13,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_14,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_15,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_16,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_17,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_18,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_19,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_20,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_21,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_22,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_23,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_24,$GUI_UNCHECKED)		
		GUICtrlSetState($Checkbox_25,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_26,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_27,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_28,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_29,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_30,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_31,$GUI_UNCHECKED)
		
	Case $msg = $button3
		IniDelete(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar")
		IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "bar", "")
		$ch1=GUICtrlRead($Checkbox_1)
		$ch2=GUICtrlRead($Checkbox_2)
		$ch3=GUICtrlRead($Checkbox_3)
		$ch4=GUICtrlRead($Checkbox_4)
		if $ch1 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "303", $item1)
		if $ch2 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "301", $item2)	
		if $ch3 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "901", $item3)	
		if $ch4 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1103", $item4)	
		if $ch1=1 or $ch2=1	or $ch3=1 or $ch4=1 then FileWriteLine(@ScriptDir & "\bin\SciteToolbar.ini", "bar=")
		$ch5=GUICtrlRead($Checkbox_5)
		$ch6=GUICtrlRead($Checkbox_6)
		$ch7=GUICtrlRead($Checkbox_7)
		$ch8=GUICtrlRead($Checkbox_8)
		if $ch5 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1100", $item5)
		if $ch6 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1101", $item6)	
		if $ch7 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1102", $item7)	
		if $ch8 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1104", $item8)	
		if $ch5=1 or $ch6=1	or $ch7=1 or $ch8=1 then FileWriteLine(@ScriptDir & "\bin\SciteToolbar.ini", "bar=")
		$ch9=GUICtrlRead($Checkbox_9)
		$ch10=GUICtrlRead($Checkbox_10)
		$ch11=GUICtrlRead($Checkbox_11)
		$ch12=GUICtrlRead($Checkbox_12)
		$ch13=GUICtrlRead($Checkbox_13)
		$ch14=GUICtrlRead($Checkbox_14)
		$ch15=GUICtrlRead($Checkbox_15)
		$ch16=GUICtrlRead($Checkbox_16)	
		$ch17=GUICtrlRead($Checkbox_17)	
		if $ch9 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1105", $item9)
		if $ch10 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1106", $item10)	
		if $ch11 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1107", $item11)	
		if $ch12 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1108", $item12)
		if $ch13 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1109", $item13)
		if $ch14 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1110", $item14)	
		if $ch15 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1111", $item15)	
		if $ch16 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1112", $item16)
		if $ch17 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "107", $item17)
		if $ch9=1 or $ch10=1 or $ch11=1 or $ch12=1 or $ch13=1 or $ch14=1 or $ch15=1 or $ch16=1 or $ch17=1 then FileWriteLine(@ScriptDir & "\bin\SciteToolbar.ini", "bar=")			
		$ch18=GUICtrlRead($Checkbox_18)
		$ch19=GUICtrlRead($Checkbox_19)
		$ch20=GUICtrlRead($Checkbox_20)
		$ch21=GUICtrlRead($Checkbox_21)
		$ch22=GUICtrlRead($Checkbox_22)
		$ch23=GUICtrlRead($Checkbox_23)
		$ch24=GUICtrlRead($Checkbox_24)
		$ch25=GUICtrlRead($Checkbox_25)	
		$ch26=GUICtrlRead($Checkbox_26)
		$ch27=GUICtrlRead($Checkbox_27)
		$ch28=GUICtrlRead($Checkbox_28)
		$ch29=GUICtrlRead($Checkbox_29)
		$ch30=GUICtrlRead($Checkbox_30)	
		$ch31=GUICtrlRead($Checkbox_31)
		if $ch18 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1123", $item18)	
		if $ch19 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1124", $item19)	
		if $ch20 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1125", $item20)	
		if $ch21 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "1126", $item21)
		if $ch22 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "961", $item22)
		if $ch23 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "232", $item23)
		if $ch24 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "233", $item24)
		if $ch25 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "240", $item25)
		if $ch26 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "241", $item26)
		if $ch27 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "243", $item27)
		if $ch28 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "246", $item28)
		if $ch29 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "247", $item29)
		if $ch30 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "420", $item30)	
		if $ch31 = 1 then IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "314", $item31)	
		if $ch18=1 or $ch19=1 or $ch20=1 or $ch21=1 or $ch22=1 or $ch23=1 or $ch24=1 or $ch25=1 or $ch26=1 or $ch27=1 or $ch28=1 or $ch29=1 or $ch30=1 or $ch31=1 then FileWriteLine(@ScriptDir & "\bin\SciteToolbar.ini", "bar=")			
		IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "108", $item32)
		IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "ToolBar", "9999", $item33)	
		FileWriteLine(@ScriptDir & "\bin\SciteToolbar.ini", "bar=")
		GUIDelete($opt1)
		;_Adjust_Toolbar_Info($Toolbar_Info)
		_CreateToolbar($go, $Toolbar_Info, $My_Gui_Width)
		$My_Dec_Hwnd = Dec(StringTrimLeft($My_Hwnd, 2))
		;Register COPYDATA message.
		GUIRegisterMsg($WM_COPYDATA, "MY_WM_COPYDATA")
		IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "bar", "new", "0")
		_restart()
			
		Case $msg = $button4
		GUIDelete($opt1)
		;_Adjust_Toolbar_Info($Toolbar_Info)
		_CreateToolbar($go, $Toolbar_Info, $My_Gui_Width)
		$My_Dec_Hwnd = Dec(StringTrimLeft($My_Hwnd, 2))
		;Register COPYDATA message.
		GUIRegisterMsg($WM_COPYDATA, "MY_WM_COPYDATA")	
		IniWrite(@ScriptDir & "\bin\SciteToolbar.ini", "bar", "new", "0")
		MsgBox(0, "Important!", "You will need to click on the options icon to configure what buttons you want on the toolbar")
		_restart()		
;;;
	EndSelect
WEnd
Exit
EndFunc

Func _restart()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc

#cs
	Here are the other values that could be useful for you:
	Go = 301
	Compile = 302
	
	
	Complete list from the SciTE source file scite.h
	// Menu IDs.
	// These are located 100 apart. No one will want more than 100 in each menu
	#define IDM_MRUFILE 1000
	#define IDM_TOOLS 1100
	#define IDM_BUFFER 1200
	#define IDM_IMPORT 1300
	#define IDM_LANGUAGE 1400
	
	// File
	#define IDM_NEW 101
	#define IDM_OPEN 102
	#define IDM_OPENSELECTED 103
	#define IDM_REVERT 104
	#define IDM_CLOSE 105
	#define IDM_SAVE 106
	#define IDM_SAVEAS 110
	#define IDM_SAVEASHTML 111
	#define IDM_SAVEASRTF 112
	#define IDM_SAVEASPDF 113
	#define IDM_FILER 114
	#define IDM_SAVEASTEX 115
	#define IDM_SAVEACOPY 116
	#define IDM_SAVEASXML 117
	#define IDM_MRU_SEP 120
	#define IDM_PRINTSETUP 130
	#define IDM_PRINT 131
	#define IDM_LOADSESSION 132
	#define IDM_SAVESESSION 133
	#define IDM_QUIT 140
	#define IDM_ENCODING_DEFAULT 150
	#define IDM_ENCODING_UCS2BE 151
	#define IDM_ENCODING_UCS2LE 152
	#define IDM_ENCODING_UTF8 153
	#define IDM_ENCODING_UCOOKIE 154
	
	#define MRU_START 16
	#define IMPORT_START 19
	#define TOOLS_START 3
	
	
	// Edit
	#define IDM_UNDO 201
	#define IDM_REDO 202
	#define IDM_CUT 203
	#define IDM_COPY 204
	#define IDM_PASTE 205
	#define IDM_CLEAR 206
	#define IDM_SELECTALL 207
	#define IDM_PASTEANDDOWN 208
	#define IDM_FIND 210
	#define IDM_FINDNEXT 211
	#define IDM_FINDNEXTBACK 212
	#define IDM_FINDNEXTSEL 213
	#define IDM_FINDNEXTBACKSEL 214
	#define IDM_FINDINFILES 215
	#define IDM_REPLACE 216
	#define IDM_GOTO 220
	#define IDM_BOOKMARK_NEXT 221
	#define IDM_BOOKMARK_TOGGLE 222
	#define IDM_BOOKMARK_PREV 223
	#define IDM_BOOKMARK_CLEARALL 224
	#define IDM_BOOKMARK_NEXT_SELECT 225
	#define IDM_BOOKMARK_PREV_SELECT 226
	#define IDM_MATCHBRACE 230
	#define IDM_SELECTTOBRACE 231
	#define IDM_SHOWCALLTIP 232
	#define IDM_COMPLETE 233
	#define IDM_COMPLETEWORD 234
	#define IDM_EXPAND 235
	#define IDM_TOGGLE_FOLDALL 236
	#define IDM_TOGGLE_FOLDRECURSIVE 237
	#define IDM_EXPAND_ENSURECHILDRENVISIBLE 238
	#define IDM_UPRCASE 240
	#define IDM_LWRCASE 241
	#define IDM_ABBREV 242
	#define IDM_BLOCK_COMMENT 243
	#define IDM_STREAM_COMMENT 244
	#define IDM_COPYASRTF 245
 	#define IDM_BOX_COMMENT 246
   	#define IDM_INS_ABBREV 247
   	#define IDM_JOIN 248
   	#define IDM_SPLIT 249
   	#define IDM_DUPLICATE 250
   	#define IDM_INCSEARCH 252
   	#define IDM_ENTERSELECTION 256 


	
	#define IDC_INCFINDTEXT 253
	#define IDC_INCFINDBTNOK 254
	#define IDD_FIND2 255
	#define IDC_EDIT1 1000
	#define IDC_STATIC -1
	
	
	#define IDM_PREVMATCHPPC 260
	#define IDM_SELECTTOPREVMATCHPPC 261
	#define IDM_NEXTMATCHPPC 262
	#define IDM_SELECTTONEXTMATCHPPC 263
	
	// Tools
	#define IDM_COMPILE 301
	#define IDM_BUILD 302
	#define IDM_GO 303
	#define IDM_STOPEXECUTE 304
	#define IDM_FINISHEDEXECUTE 305
	#define IDM_NEXTMSG 306
	#define IDM_PREVMSG 307
	
	#define IDM_MACRO_SEP 310
	#define IDM_MACRORECORD 311
	#define IDM_MACROSTOPRECORD 312
	#define IDM_MACROPLAY 313
	#define IDM_MACROLIST 314
	
	#define IDM_ACTIVATE 320
	
	#define IDM_SRCWIN 350
	#define IDM_RUNWIN 351
	#define IDM_TOOLWIN 352
	#define IDM_STATUSWIN 353
	#define IDM_TABWIN 354
	
	// Options
	#define IDM_SPLITVERTICAL 401
	#define IDM_VIEWSPACE 402
	#define IDM_VIEWEOL 403
	#define IDM_VIEWGUIDES 404
	#define IDM_SELMARGIN 405
	#define IDM_FOLDMARGIN 406
	#define IDM_LINENUMBERMARGIN 407
	#define IDM_VIEWTOOLBAR 408
	#define IDM_TOGGLEOUTPUT 409
	#define IDM_VIEWTABBAR 410
	#define IDM_VIEWSTATUSBAR 411
	#define IDM_TOGGLEPARAMETERS 412
	#define IDM_OPENFILESHERE 413
	#define IDM_WRAP 414
	#define IDM_WRAPOUTPUT 415
	#define IDM_READONLY 416
	
	#define IDM_CLEAROUTPUT 420
	#define IDM_SWITCHPANE 421
	
	#define IDM_EOL_CRLF 430
	#define IDM_EOL_CR 431
	#define IDM_EOL_LF 432
	#define IDM_EOL_CONVERT 433
	
	#define IDM_TABSIZE 440
	
	#define IDM_MONOFONT 450
	
	#define IDM_OPENLOCALPROPERTIES 460
	#define IDM_OPENUSERPROPERTIES 461
	#define IDM_OPENGLOBALPROPERTIES 462
	#define IDM_OPENABBREVPROPERTIES 463
	#define IDM_OPENLUAEXTERNALFILE 464
	
	//#define IDM_SELECTIONMARGIN 490
	//#define IDM_BUFFEREDDRAW 491
	//#define IDM_USEPALETTE 492
	
	// Buffers
	#define IDM_PREVFILE 501
	#define IDM_NEXTFILE 502
	#define IDM_CLOSEALL 503
	#define IDM_SAVEALL 504
	#define IDM_BUFFERSEP 505
	#define IDM_PREVFILESTACK 506
	#define IDM_NEXTFILESTACK 507
	
	// Help
	#define IDM_HELP 901
	#define IDM_ABOUT 902
	#define IDM_HELP_SCITE 903
	
	// Windows specific windowing options
	#define IDM_ONTOP 960
	#define IDM_FULLSCREEN 961
	
	// Dialog control IDs
	#define IDGOLINE 220
	#define IDABOUTSCINTILLA 221
	#define IDFINDWHAT 222
	#define IDFILES 223
	#define IDDIRECTORY 224
	#define IDCURRLINE 225
	#define IDLASTLINE 226
	#define IDEXTEND 227
	#define IDTABSIZE 228
	#define IDINDENTSIZE 229
	#define IDUSETABS 230
	
	#define IDREPLACEWITH 231
	#define IDWHOLEWORD 232
	#define IDMATCHCASE 233
	#define IDDIRECTIONUP 234
	#define IDDIRECTIONDOWN 235
	#define IDREPLACE 236
	#define IDREPLACEALL 237
	#define IDREPLACEINSEL 238
	#define IDREGEXP 239
	#define IDWRAP 240
	
	#define IDUNSLASH 241
	#define IDCMD 242
	
	// id for the browse button in the grep dialog
	#define IDBROWSE 243
	
	#define IDABBREV 244
	
	#define IDREPLACEINBUF 244
	#define IDMARKALL 245
	
	#define IDGOLINECHAR 246
	#define IDCURRLINECHAR 247
	#define IDREPLDONE 248
	
	#define IDDOTDOT 249
	#define IDFINDINSTYLE 250
	#define IDFINDSTYLE 251
	
 	#define IDPARAMSTART 300
	
	// Dialog IDs
	#define IDD_FIND 400
	#define IDD_REPLACE 401
	#define IDD_BUFFERS 402
	#define IDD_FIND_ADV 403
	#define IDD_REPLACE_ADV 404
	#define IDR_CLOSEFILE 100
	
#ce
