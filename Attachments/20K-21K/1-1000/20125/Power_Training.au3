;Made by Generator in AutoIt Forums
;UDF by Developers of AutoIt
#NoTrayIcon
#include<GUIConstants.au3>
#include<IE.au3>
#include<Misc.au3>
#include<GuiComboBox.au3>

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Dim $mode = 0, $version = "", $start = 0
Dim $DataClt[4], $Color[2]
$DataClt[0] = "Number of tree/rock(s) to find before dropping inventory,4,28,16"
$DataClt[1] = "Number of second(s) to wait before next tree/rock,5,200,60"
$DataClt[2] = "Number of second(s) delay after right click dropping,1,5,3"
$DataClt[3] = "Number of second(s) delay after each drop,1,5,3"
HotKeySet("{ESC}", "_StopBot")
_Singleton("Power Training")
_IEErrorHandlerRegister()
#region Welcome GUI
$form0 = GUICreate("Power Training", 400, 70, -1, -1, $WS_CAPTION, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
$label0 = GUICtrlCreateLabel("Welcome to Power Training...Please wait for vertification....", 10, 5, 390, 20, -1)
$progress0 = GUICtrlCreateProgress(10, 25, 240, 20, $PBS_SMOOTH)
$label1 = GUICtrlCreateLabel("Looking for Java plug-in....", 10, 50, 240, 20, -1)
GUISetState(@SW_SHOW, $form0)
For $i = 1 To 100
	GUICtrlSetData($progress0, $i)
	Sleep(5)
Next
If Not _CheckJava() Then
	$label3 = GUICtrlCreateLabel("Get the latest Java", 260, 25, 140, 20, -1)
	GUICtrlSetData($label1, "Please install Java before continuing...")
	_HyperLink($label3)
Else
	GUICtrlCreateLabel("Version: " & $version, 260, 25, 140, 20, -1)
	$label4 = GUICtrlCreateLabel("Start", 370, 50, 30, 20, -1)
	_HyperLink($label4)
EndIf

While Not $mode
	$Info0 = GUIGetCursorInfo($form0)
	If $version == "" Then
		If $Info0[2] And $Info0[4] = $label3 Then
			While _IsPressed("01")
				Sleep(1)
			WEnd
			_GetJava()
			Exit
		EndIf
	ElseIf $Info0[2] And $Info0[4] = $label4 Then
		While _IsPressed("01")
			Sleep(1)
		WEnd
		$mode = 1
		GUIDelete($form0)
	EndIf
	Sleep(1)
WEnd
#endregion Welcome GUI
#region Main GUI
$form1 = GUICreate("Power Training", 830, 600, -1, -1, -1, $WS_EX_TOPMOST)
$oIE = _IECreateEmbedded()
$guiactivex = GUICtrlCreateObj($oIE, 20, 10, 790, 513)
_IENavigate($oIE, "www.runescape.com", 0)
$combo0 = GUICtrlCreateCombo("", 20, 530, 400, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData($combo0, String(_GetComboTxt()))
GUICtrlSetFont($combo0, 9, 400, 0, "Tahoma")
_GUICtrlComboBox_SetCurSel($combo0, 0)
$slider0 = GUICtrlCreateSlider(20, 555, 400, 20, $TBS_NOTICKS)
$label2 = GUICtrlCreateLabel("", 20, 575, 20, 20, -1)
$label5 = GUICtrlCreateLabel("", 400, 575, 25, 20, -1)
$label6 = GUICtrlCreateLabel("", 160, 575, 200, 20, -1)
GUICtrlSetFont($label6, 9.5, 400,0,"Tahoma")
_SelectCombo($label2, $label5, $label6, $slider0, $DataClt, _GUICtrlComboBox_GetCurSel($combo0))
GUICtrlSetCursor($slider0, 0)
$button0 = GUICtrlCreateButton("+", 430, 555, 100, 40, -1)
GUICtrlSetFont(-1, 30, 400)
GUICtrlSetCursor(-1, 3)
$button1 = GUICtrlCreateButton("+", 535, 555, 100, 40, -1)
GUICtrlSetCursor(-1, 3)
GUICtrlSetFont(-1, 30, 400)
$label7 = GUICtrlCreateLabel("Tree/Rock Color", 430, 530, 100, 20, $SS_CENTER)
GUICtrlSetFont(-1, 9.5, 400,0,"Tahoma")
$label8 = GUICtrlCreateLabel("Log/Ore Color", 535, 530, 100, 20, $SS_CENTER)
GUICtrlSetFont(-1, 9.5, 400,0,"Tahoma")
$button2 = GUICtrlCreateButton("Start Training", 640, 530, 170, 65, -1)
GUICtrlSetFont(-1, 16, 400,0,"Century Gothic")
GUICtrlSetOnEvent($button2, "_Start")
GUICtrlSetOnEvent($slider0, "_UpdateSlider")
GUICtrlSetOnEvent($combo0, "_Combo")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_StopBot")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW, $form1)
While 1
	$Info1 = GUIGetCursorInfo($form1)
	If $Info1[2] And $Info1[4] = $button0 Then
		While _IsPressed("01")
			Sleep(1)
		WEnd
		_GetColor(0)
	ElseIf $Info1[2] And $Info1[4] = $button1 Then
		While _IsPressed("01")
			Sleep(1)
		WEnd
		_GetColor(1)
	EndIf
	While $start
		$amount0 = StringSplit($DataClt[0], ",", 1)		
		For $i = 1 To $amount0[4]
			If $start = 0 Then ExitLoop
			$Winpos = WinGetPos($form1, "")
			$Search0 = PixelSearch($Winpos[0]+20, $Winpos[1]+10, $Winpos[0] + 810, $Winpos[1] + 523, $Color[0], 0, 1)
			If Not @error Then
				MouseMove( $Search0[0]+2, $Search0[1]+2,2)
				Sleep(Random(900,1500,1))
				MouseClick("Left")
				$amount1 = StringSplit($DataClt[1], ",", 1)
				$Timer = TimerInit()
				Do
					Sleep(1)
					If $start = 0 Then ExitLoop
				Until TimerDiff($Timer) > Number($amount1[4] * 1000)
			EndIf			
			Sleep(1)
		Next
		$amount2 = StringSplit($DataClt[2], ",", 1)
		$amount3 = StringSplit($DataClt[3], ",", 1)
		For $ii = 1 To 28			
			If $start = 0 Then ExitLoop			
			$WinPos0 = WinGetPos($form1, "")
			$Search1 = PixelSearch($Winpos0[0]+20 + 545, $Winpos0[1]+10 + 205, $Winpos0[0] + 810, $Winpos0[1] + 523, $Color[1], 0, 1)
			If Not @error Then
				MouseMove($Search1[0]+2, $Search1[1]+2,2)
				Sleep(Random(900,1500,1))
				MouseClick("Right")
				Sleep($amount2[4] * 1000)
				MouseMove($Search1[0]+2,$Search1[1]+35+3,2)
				MouseClick("Left")
				Sleep($amount3[4] * 1000)
			EndIf
			Sleep(1)
		Next
		Sleep(1)
	WEnd
	Sleep(1)
WEnd
#endregion Main GUI
Func _HyperLink($label)
	GUICtrlSetColor($label, 0x1B2392)
	GUICtrlSetFont($label, 8.5, 400, 4, "Arial")
	GUICtrlSetCursor($label, 0)
EndFunc   ;==>_HyperLink
Func _CheckJava()
	$regread = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Web Start", "CurrentVersion")
	$version = String($regread)
	If Not @error Then
		Return $version And 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_CheckJava
Func _GetJava()
	_IECreate("www.java.com/getjava/", 0, 1, 0, 0)
EndFunc   ;==>_GetJava
Func _Exit()
	Exit
EndFunc   ;==>_Exit
Func _GetComboTxt()
	Local $split, $combotxt = ""
	For $i = 0 To UBound($DataClt, 1) - 1
		$split = StringSplit($DataClt[$i], ",", 1)
		$combotxt = $combotxt & $split[1] & "|"
		If $i = UBound($DataClt, 1) - 1 Then StringTrimRight($combotxt, 1)
	Next
	Return $combotxt
EndFunc   ;==>_GetComboTxt
Func _SelectCombo($min, $max, $current, $slider, $array, $index)
	Local $split
	$split = StringSplit($array[$index], ",", 1)
	GUICtrlSetData($min, $split[2])
	GUICtrlSetData($max, $split[3])
	GUICtrlSetData($current, "Current Value: " & $split[4])
	GUICtrlSetLimit($slider, $split[3], $split[2])
	GUICtrlSetData($slider, $split[4])
EndFunc   ;==>_SelectCombo
Func _Combo()
	_SelectCombo($label2, $label5, $label6, $slider0, $DataClt, _GUICtrlComboBox_GetCurSel($combo0))
EndFunc   ;==>_Combo
Func _UpdateSlider()
	Local $split, $trimright
	$split = StringSplit($DataClt[_GUICtrlComboBox_GetCurSel($combo0)], ",", 1)
	$trimright = String(StringTrimRight($DataClt[_GUICtrlComboBox_GetCurSel($combo0)], StringLen($split[4])) & GUICtrlRead($slider0))
	$DataClt[_GUICtrlComboBox_GetCurSel($combo0)] = $trimright
	GUICtrlSetData($label6, "Current Value: " & GUICtrlRead($slider0))
EndFunc   ;==>_UpdateSlider
Func _GetColor($number)
	Local $Colordata
	$Colordata = PixelGetColor(MouseGetPos(0), MouseGetPos(1))
	$Color[$number] = $Colordata
EndFunc   ;==>_GetColor
Func _Start()
	GUICtrlSetState($button0, $GUI_DISABLE)
	GUICtrlSetState($button1, $GUI_DISABLE)
	GUICtrlSetState($button2, $GUI_DISABLE)
	GUICtrlSetState($slider0, $GUI_DISABLE)
	GUICtrlSetState($combo0, $GUI_DISABLE)
	$start = 1
EndFunc   ;==>_Start
Func _StopBot()
	If $start Then
		$start = 0
		GUICtrlSetState($button0, $GUI_ENABLE)
		GUICtrlSetState($button1, $GUI_ENABLE)
		GUICtrlSetState($button2, $GUI_ENABLE)
		GUICtrlSetState($slider0, $GUI_ENABLE)
		GUICtrlSetState($combo0, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_StopBot