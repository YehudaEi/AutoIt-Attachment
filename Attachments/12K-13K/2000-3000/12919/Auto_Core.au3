#cs
	Author: dabus
	Script function: an Auto(it) Co(ntrol-based) re(corder)
	
	Changes:
	0.0.0	- based on Larrys func ControlClassNNFromMousePos
	0.0.2 	- 11.01.2007 - added a simple gui via koda and populated some inputboxes
	0.0.3	- 11.01.2007 - added more logic to getinfo - no more flickering and no repeats if you press the hotkey 
	0.0.5	- 11.01.2007 - made gui smaller and look nicer - at least under WinXP
	0.1.0	- 11.01.2007 - added functionality for most buttons
	0.1.1	- 11.01.2007 - fixed a "bug (?)" in Larrys func, added option to make gui even smaller for recording
	0.1.5	- 12.01.2007 - fixed some typos, translated the gui, fixed ListView
#ce

#Region Compiler directives section
#Compiler_Prompt=y												;y=show compile menu
;~ #Compiler_Icon=E:\Scripts\Icons\Programs\Lexware.ico			;Filename of the Ico file to use
#Compiler_Compression=4         								;Compression parameter 0-4  0=Low 2=normal 4=High
#Compiler_Res_Comment=Created with Scite4AutoIt & AutoIt3		;Comment field
#Compiler_Res_Description=Recorder for setups based on controls	;Description field
#Compiler_Res_Fileversion=0.1.5									;File Version
#Compiler_Res_LegalCopyright=© dabus							;Copyright field
#Compiler_Res_Field1Name = Made By
#Compiler_Res_Field1Value = dabus
#Compiler_Res_Field2Name = EMail
#Compiler_res_Field2Value = dabus@gmx.net
#Compiler_Run_AU3Check=y										;Run au3check before compilation
#EndRegion

#include <GUIConstants.au3>
#include <Misc.au3>
#include <GuiListView.au3>

AutoItSetOption("GUIOnEventMode", 0)
AutoItSetOption('OnExitFunc', 'CleanUp')
AutoItSetOption('GUIResizeMode', 802); resize guis without resizing controls

Global $InfoIsActive, $Input1, $Input2, $Input3, $Label1, $LControl, $LWindow

$dll = DllOpen("user32.dll")

HotKeySet('^!f', 'ToggleInfo')
ToggleInfo()

#region GUI building
$Gui = GUICreate("Auto-Co(ntroled)Re(ecorder)", 580, 275, (@DesktopWidth-580)/2, (@DesktopHeight-275)/2, $WS_SYSMENU, $WS_EX_TOPMOST )
$Icon1 = GUICtrlCreateIcon(@SystemDir&"\shell32.dll", 19, 20, 10)
$Label1 = GUICtrlCreateLabel("To stop, press [Ctrl]+[Alt]+[F]", 70, 20, 190, 20, $SS_CENTER)

$Group1 = GUICtrlCreateGroup("Control", 10, 150, 90, 50)
$Button1 = GUICtrlCreateButton("C", 20, 170, 20, 20, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",120, 0)
GUICtrlSetTip(-1, 'ControlClick')
$Button2 = GUICtrlCreateButton("S", 45, 170, 20, 20, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",44, 0)
GUICtrlSetTip(-1, 'ControlSend')

$Group2 = GUICtrlCreateGroup("Windows", 110, 150, 90, 50)
$Button3 = GUICtrlCreateButton("WWA", 120, 170, 20, 20, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",22, 0)
GUICtrlSetTip(-1, 'WinWaitActive')
$Button4 = GUICtrlCreateButton("WWC", 145, 170, 20, 20, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",31, 0)
GUICtrlSetTip(-1, 'WinWaitExit')
$Button5 = GUICtrlCreateButton("WC", 170, 170, 20, 20, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",27, 0)
GUICtrlSetTip(-1, 'WinClose')

$Group3 = GUICtrlCreateGroup("Common", 210, 150, 90, 50)
$Button6 = GUICtrlCreateButton("S", 220, 170, 20, 20, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",44, 0)
GUICtrlSetTip(-1, 'Send')

GUICtrlCreateLabel("Window", 10, 50, 60, 20)
GUICtrlCreateLabel("Text", 10, 75, 60, 20)
GUICtrlCreateLabel("Control", 10, 100, 60, 20)
GUICtrlCreateLabel("Send", 10, 125, 60, 20)
$Input1 = GUICtrlCreateInput("", 80, 50, 220, 20, -1, $WS_EX_CLIENTEDGE)
$Input2 = GUICtrlCreateCombo("", 80, 75, 220, 20, -1, $WS_EX_CLIENTEDGE)
$Input3 = GUICtrlCreateInput("", 80, 100, 220, 20, -1, $WS_EX_CLIENTEDGE)
$Input4 = GUICtrlCreateInput("", 80, 125, 220, 20, -1, $WS_EX_CLIENTEDGE)

$Button7 = GUICtrlCreateButton("Test", 10, 210, 90, 25)
$Button8 = GUICtrlCreateButton("Clipboard", 110, 210, 90, 25)
$Button9 = GUICtrlCreateButton("Delete", 210, 210, 90, 25)
$Button10 = GUICtrlCreateButton("Exit", 310, 210, 260, 25)
$Button11 = GUICtrlCreateButton('>', 280, 10, 20, 30, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",217, 0)
GUICtrlSetTip(-1, 'Modus')

$List1 = GUICtrlCreateListView("Window           |Text          |Control|Action|Send      ", 310, 10, 260, 190, -1, $WS_EX_CLIENTEDGE)

GUISetState(@SW_SHOW)
#endregion GUI building
$DefaultSize=WinGetPos($Gui)
While 1
	$msg = GuiGetMsg()
	Switch $msg
	Case $GUI_EVENT_CLOSE
		ExitLoop
	Case $Button1 ; ControlClick
		GUICtrlCreateListViewItem(GUICtrlRead($Input1)&'|'&GUICtrlRead($Input2)&'|'&GUICtrlRead($Input3)&'|CC|-', $List1)
	Case $Button2 ; ControlSend
		If GUICtrlRead($Input4) <> '' Then _
		GUICtrlCreateListViewItem(GUICtrlRead($Input1)&'|'&GUICtrlRead($Input2)&'|'&GUICtrlRead($Input3)&'|CS|'&GUICtrlRead($Input4), $List1)
	Case $Button3 ; WinWaitActive
		GUICtrlCreateListViewItem(GUICtrlRead($Input1)&'|'&GUICtrlRead($Input2)&'|-|WWA|-', $List1)
	Case $Button4 ; WinWaitClose
		GUICtrlCreateListViewItem(GUICtrlRead($Input1)&'|'&GUICtrlRead($Input2)&'|-|WWC|-', $List1)
	Case $Button5 ; WinClose
		GUICtrlCreateListViewItem(GUICtrlRead($Input1)&'|'&GUICtrlRead($Input2)&'|-|WC|-', $List1)
	Case $Button6 ; Send
		If GUICtrlRead($Input4) <> '' Then _
		GUICtrlCreateListViewItem('-|-|-|S|'&GUICtrlRead($Input4), $List1)
	Case $Button7 ; Test
		$Selection = _GUICtrlListViewGetItemTextArray ($List1)
		If IsArray($Selection) Then
			Switch $Selection[4]
			Case 'CC'
				ControlClick($Selection[1], $Selection[2], $Selection[3])
			Case 'CS'
				ControlSend($Selection[1], $Selection[2], $Selection[3], $Selection[5])
			Case 'WWA'
				$Test=WinWaitActive($Selection[1], $Selection[2], 10)
				If $Test=1 Then 
					MsgBox(64, 'Auto-Core', $Selection[1] & ' found.', 2)
				Else
					MsgBox(16, 'Auto-Core', $Selection[1] & ' not found.', 2)
				EndIf	
			Case 'WWE'
				$Test=WinWaitClose($Selection[1], $Selection[2], 10)
				If $Test=1 Then 
					MsgBox(64, 'Auto-Core', $Selection[1] & ' closed.', 2)
				Else
					MsgBox(16, 'Auto-Core', $Selection[1] & ' did not close.', 2)
				EndIf	
			Case 'WC'
				WinClose($Selection[1], $Selection[2])
				Sleep(500)
				$Test=WinExists($Selection[1], $Selection[2])
				If $Test=1 Then 
					MsgBox(64, 'Auto-Core', $Selection[1] & ' was closed.', 2)
				Else
					MsgBox(16, 'Auto-Core', $Selection[1] & ' could not be closed.', 2)
				EndIf	
			Case 'S'
				Send($Selection[5])
			EndSwitch
		EndIf
	Case $Button8 ; Copy to clipboard
		Local $Output=''
		For $i=0 To _GUICtrlListViewGetItemCount($List1)
			$Selection = _GUICtrlListViewGetItemTextArray ($List1, $i)
			If IsArray($Selection) Then
				Switch $Selection[4]
				Case 'CC'
					$Line='ControlClick("'&$Selection[1]&'", "'&$Selection[2]&'", "'&$Selection[3]&'")'
				Case 'CS'
					$Line='ControlSend("'&$Selection[1]&'", "'&$Selection[2]&'", "'&$Selection[3]&'", "'&$Selection[5]&'")'
				Case 'WWA'
					$Line='WinWaitActive("'&$Selection[1]&'", "'&$Selection[2]&'")'
				Case 'WWC'
					$Line='WinWaitClose("'&$Selection[1]&'", "'&$Selection[2]&'")'
				Case 'WC'
					$Line='WinClose("'&$Selection[1]&'", "'&$Selection[2]&'")'
				Case 'S'
					$Line='Send("'&$Selection[5]&'")'
				EndSwitch
			$Output=$Output&@CR&$Line
			EndIf
		Next
		ClipPut($Output&@CR)
	Case $Button9 ; Delete
		_GUICtrlListViewDeleteItemsSelected($List1)
	Case $Button10 ; Exit		
		ExitLoop
	Case $Button11 ; Resize
		$Pos=WinGetPos($Gui)
		If $Pos[2] = $DefaultSize[2] Then
			WinMove($Gui, '', $Pos[0], $Pos[1], 310, 240)
		Else
			WinMove($Gui, '', $Pos[0], $Pos[1], $DefaultSize[2], $DefaultSize[3])
		EndIf	 
	EndSwitch
WEnd
DllClose($dll)
Exit

Func ControlClassNNFromMousePos()
    Local $n = 0
    Local $ctrl_ret = ""
    Local $hWin = WinGetHandle('')
    Local $MCM = Opt("MouseCoordMode",2)
    Local $mPos = MouseGetPos()
    Opt("MouseCoordMode",$MCM)
    Local $wPos = WinGetPos($hWin)
    If Not IsArray($mPos) Or Not IsArray($wPos) Then Return ""
    $wPos[0] = 0
    $wPos[1] = 0
    
    If Not PointInRect($mPos,$wPos) Then Return ""
    
    Local $sClassList = @LF & WinGetClassList($hWin)

    While $sClassList <> @LF
        $ctrl = Pop($sClassList)
        $n = 1
        While 1
            $wPos = ControlGetPos($hWin,"",$ctrl & $n)
			; just added this since some controls (like in speedcommander) won't return propper results and cause a crash right here
			If $wPos = 0 Then ContinueLoop(2)
            If PointInRect($mPos,$wPos) Then $ctrl_ret = $ctrl & $n
			If StringInStr($sClassList,@LF & $ctrl & @LF) Then
                $sClassList = StringReplace($sClassList,@LF & $ctrl & @LF,@LF,1)
                $n += 1
            Else
                ExitLoop
            EndIf
        WEnd
    WEnd
    Return $ctrl_ret
EndFunc

Func GetInfo()
	$Window=WinGetTitle('')
	$Control=ControlClassNNFromMousePos()
	If $Window <> $LWindow Then 
		$LWindow=$Window
		$Text=WinGetText($Window)
		GUICtrlSetData($Input2, '')
		GUICtrlSetData($Input2, StringReplace($Text, @LF, '|', ''))
		GUICtrlSetData ($Input1, $Window)
	EndIf
	If $Control <>$LControl Then
		$LControl=$Control
		GUICtrlSetData ($Input3, $Control)
	EndIf	
EndFunc

Func Pop(ByRef $szList)
    Local $buff = StringTrimLeft($szList,1)
    $buff = StringLeft($buff,StringInStr($buff,@LF)-1)
    $szList = StringTrimLeft($szList,StringLen($buff)+1)
    Return $buff
EndFunc

Func PointInRect(ByRef $mPoint, ByRef $wPoint)
    If $mPoint[0] < $wPoint[0] Or _
		$mPoint[1] < $wPoint[1] Or _
        $mPoint[0] > ($wPoint[0] + ($wPoint[2]-1)) Or _
        $mPoint[1] > ($wPoint[1] + ($wPoint[3]-1)) Then Return 0
    Return 1
EndFunc

Func ToggleInfo()
	If $InfoIsActive=1 Then
		AdlibDisable()
		GUICtrlSetBkColor($Input1, 0x00ff00)
		GUICtrlSetBkColor($Input2, 0x00ff00)
		GUICtrlSetBkColor($Input3, 0x00ff00)
		GUICtrlSetData($Label1, "To start, press [Ctrl]+[Alt]+[f]")
		$InfoIsActive=0
		While _IsPressed('11', $dll)
			Sleep(10)
		WEnd	
	Else
		AdlibEnable('GetInfo', 250)
		GUICtrlSetBkColor($Input1, 0xffffff)
		GUICtrlSetBkColor($Input2, 0xffffff)
		GUICtrlSetBkColor($Input3, 0xffffff)
		GUICtrlSetData($Label1, "To stop, press [Ctrl]+[Alt]+[f]")
		$InfoIsActive=1
		While _IsPressed('11', $dll)
			Sleep(10)
		WEnd
	EndIf
EndFunc	