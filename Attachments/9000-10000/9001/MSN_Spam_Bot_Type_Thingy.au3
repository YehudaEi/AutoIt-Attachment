; ----------------------------------------------------------------------------
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
; Requirement(s):  AutoIt Beta
; Script Function:
;	Template AutoIt script.
; ----------------------------------------------------------------------------

; Call Constants Inclusion
#include <GuiConstants.au3>
AutoItSetOption("SendKeyDelay", 1)

; Set Deafult Variables
$InputFig_1 = 500
$SlideFig_1 = 500
$TempFig_1 = 500
$InputFig_2 = 0
$SlideFig_2 = 0
$TempFig_1 = 0
$Switch = 0
$RepeatType = "MSec"
$SendType = "Text"
$DurationType = "Infinite"
$RepeatRate = 500
$SendText = "You've been SPAMMED :P"
$SpammerCount = 1

Global $Duration, $RunCount, $Percent, $Factor, $Target, $SendType, $SendText

; Define & Create the GUI
; Set GUI Label and Window Size
GuiCreate("MSN SPAMBOT v2.0", 400, 454,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
; Create Target Selection Control
$Label_1 = GuiCtrlCreateLabel("TARGET:", 18, 15, 60, 20)
$Combo_1 = GuiCtrlCreateCombo("Please Select Your Target  (Press 'Refresh' to Re-Load)", 70, 10, 320, 220)
; Create Content Controls
$Edit_1 = GuiCtrlCreateEdit("You've been SPAMMED :P", 10, 86, 380, 100)
$Group_1 = GuiCtrlCreateGroup("SEND TYPE :", 10, 36, 380, 40)
	$Radio_1 = GuiCtrlCreateRadio("TEXT", 20, 49, 60, 20)
	$Radio_2 = GuiCtrlCreateRadio("NUDGE", 165, 49, 60, 20)
	$Radio_3 = GuiCtrlCreateRadio("COMBO", 320, 49, 60, 20)
		GUICtrlSetState($Radio_1, $GUI_CHECKED)
; Create Repetition Speed Controls
$Group_2 = GuiCtrlCreateGroup("REPEAT RATE", 10, 191, 380, 40)
	$Radio_4 = GuiCtrlCreateRadio("Milli-SECONDS", 20, 204, 90, 19)
	$Radio_5 = GuiCtrlCreateRadio("SECONDS", 175, 204, 70, 19)
	$Radio_6 = GuiCtrlCreateRadio("MINUTES", 310, 204, 70, 19)
		GUICtrlSetState($Radio_4, $GUI_CHECKED)
$Slider_1 = GuiCtrlCreateSlider(3, 240, 332, 40)
$Input_1 = GUICtrlCreateInput ($InputFig_1, 340, 248, 50, 20, $ES_READONLY)
	$UpDown_1 = GUICtrlCreateUpdown($Input_1, $UDS_NOTHOUSANDS)
		GUICtrlSetLimit($Slider_1, 5000,1)
		GUICtrlSetData($Slider_1, $SlideFig_1)
		GUICtrlSetLimit($UpDown_1, 5000,1)
		GUICtrlSetData($Input_1, $InputFig_1)
; Create Duration Time Controls
$Group_3 = GuiCtrlCreateGroup("DURATION :", 10, 279, 380, 40)
	$Radio_7 = GuiCtrlCreateRadio("INFINITE", 20, 292, 70, 20)
	$Radio_8 = GuiCtrlCreateRadio("SEC", 135, 292, 70, 19)
	$Radio_9 = GuiCtrlCreateRadio("MIN", 225, 292, 70, 19)
	$Radio_10 = GuiCtrlCreateRadio("NUMBER", 315, 292, 70, 20)
		GUICtrlSetState($Radio_7, $GUI_CHECKED)
$Slider_2 = GuiCtrlCreateSlider(3, 328, 332, 40)
$Input_2 = GUICtrlCreateInput ($InputFig_2, 340, 336, 50, 20, $ES_READONLY)
	$UpDown_2 = GUICtrlCreateUpdown($Input_2, $UDS_NOTHOUSANDS)
		GUICtrlSetState($Slider_2, $GUI_DISABLE)
		GUICtrlSetState($Input_2, $GUI_DISABLE)
; Create Action Control Buttons & Progress Bar
$Progress_1 = GuiCtrlCreateProgress(10, 375, 380, 40, $PBS_SMOOTH )
	GUICtrlSetData($Progress_1,100)
$Button_1 = GuiCtrlCreateButton("&Send", 10, 426, 70, 20)
$Button_2 = GuiCtrlCreateButton("S&top", 94, 426, 70, 20)
	GUICtrlSetState($Button_2, $GUI_DISABLE)
$Button_3 = GuiCtrlCreateButton("Re&fresh", 236, 426, 70, 20)
$Button_4 = GuiCtrlCreateButton("E&xit", 320, 426, 70, 20)

; Init Populate the Target List
ListMSN()

; Parse for GUI Activity
GuiSetState()
While 1 
	Switch GuiGetMsg()
		; Standard Windows 'X' Icon
		Case $GUI_EVENT_CLOSE
				Exit(0)
		; Radio Button = Send Type : Text
		Case $Radio_1
			GUICtrlSetState($Edit_1, $GUI_ENABLE)
			$SendType = "Text"
		; Radio Button = Send Type : Nudge
		Case $Radio_2
			GUICtrlSetState($Edit_1, $GUI_DISABLE)
			$SendType = "Nudge"
		; Radio Button = Send Type : Combination
		Case $Radio_3
			GUICtrlSetState($Edit_1, $GUI_ENABLE)
			$SendType = "Combo"
		; Radio Button = Repeat Rate : Milli-Seconds
		Case $Radio_4
			$SlideFig_1 = 500
			GUICtrlSetLimit($Slider_1, 5000,1)
			GUICtrlSetData($Slider_1,$SlideFig_1)
				$InputFig_1 = 500
				GUICtrlSetData($Input_1, $InputFig_1)
				GUICtrlSetLimit($UpDown_1, 5000,1)
				$RepeatType = "MSec"
		; Radio Button = Repeat Rate : Seconds
		Case $Radio_5
			$SlideFig_1 = 30
			GUICtrlSetLimit($Slider_1, 300,1)
			GUICtrlSetData($Slider_1,$SlideFig_1)
				$InputFig_1 = 30
				GUICtrlSetData($Input_1, $InputFig_1)
				GUICtrlSetLimit($UpDown_1, 300,1)
				$RepeatType = "Sec"
		; Radio Button = Repeat Rate : Minutes
		Case $Radio_6
			$SlideFig_1 = 5
			GUICtrlSetLimit($Slider_1, 60,1)
			GUICtrlSetData($Slider_1,$SlideFig_1)
				$InputFig_1 = 5
				GUICtrlSetData($Input_1, $InputFig_1)
				GUICtrlSetLimit($UpDown_1, 60,1)
				$RepeatType = "Min"
		; Radio Button = Duration : Infinite
		Case $Radio_7
				$SlideFig_2 = 0
				GUICtrlSetData($Slider_2,$SlideFig_2)
				GUICtrlSetState($Slider_2, $GUI_DISABLE)
					$InputFig_2 = 0
					GUICtrlSetData($Input_2, $InputFig_2)
					GUICtrlSetState($Input_2, $GUI_DISABLE)
					$DurationType = "Infinite"
		; Radio Button = Duration : Seconds
		Case $Radio_8
			$SlideFig_2 = 30
			GUICtrlSetLimit($Slider_2, 300,1)
			GUICtrlSetData($Slider_2,$SlideFig_2)
			GUICtrlSetState($Slider_2, $GUI_ENABLE)
				$InputFig_2 = 30
				GUICtrlSetData($Input_2, $InputFig_2)
				GUICtrlSetState($Input_2, $GUI_ENABLE)
				GUICtrlSetLimit($UpDown_2, 300,1)
				$DurationType = "Sec"
		; Radio Button = Duration : Minutes
		Case $Radio_9
			$SlideFig_2 = 5
			GUICtrlSetLimit($Slider_2, 60,1)
			GUICtrlSetData($Slider_2,$SlideFig_2)
			GUICtrlSetState($Slider_2, $GUI_ENABLE)
				$InputFig_2 = 5
				GUICtrlSetData($Input_2, $InputFig_2)
				GUICtrlSetState($Input_2, $GUI_ENABLE)
				GUICtrlSetLimit($UpDown_2, 60,1)
				$DurationType = "Min"
		; Radio Button = Duration : Fixed Number
		Case $Radio_10
			$SlideFig_2 = 100
			GUICtrlSetLimit($Slider_2, 9999,1)
			GUICtrlSetData($Slider_2,$SlideFig_2)
			GUICtrlSetState($Slider_2, $GUI_ENABLE)
				$InputFig_2 = 100
				GUICtrlSetData($Input_2, $InputFig_2)
				GUICtrlSetState($Input_2, $GUI_ENABLE)
				GUICtrlSetLimit($UpDown_2, 9999,1)
				$DurationType = "Number"
		; Button : Send
		Case $Button_1
			InitSpammer()
            AdlibEnable("SpamUp", $RepeatRate)
		; Button : Stop
		Case $Button_2
			AdlibDisable()
			GUICtrlSetState($Button_2, $GUI_DISABLE)
			GUICtrlSetData($Progress_1, 100)
		; Button : Refresh
		Case $Button_3
			ListMSN()
		; Button : Exit
		Case $Button_4
			Exit(0)
		; Loop Functions
		Case Else
			; Get Focus to Determine Master/Slave
			$Focus = ControlGetFocus("MSN SPAMBOT v2.0", "")
			; Synchronize Slider 1 to Input Box 1
			If $Focus = "Edit3" Then
				$SlideFig_1 = GUICtrlRead($Input_1)
				GUICtrlSetData($Slider_1, $SlideFig_1)
			EndIf
			; Synchronize Slider 2 to Input Box 2
			If $Focus = "Edit4" Then
				$SlideFig_2 = GUICtrlRead($Input_2)
				GUICtrlSetData($Slider_2, $SlideFig_2)
			EndIf
			; Synchronize Input Box 1 to Slider 1
			If $Focus = "msctls_trackbar321" Then
				$InputFig_1 = GUICtrlRead($Slider_1)
				GUICtrlSetData($Input_1, $InputFig_1)
			EndIf
			; Synchronize Input Box 2 to Slider 2
			If $Focus = "msctls_trackbar322" Then
				$InputFig_2 = GUICtrlRead($Slider_2)
				GUICtrlSetData($Input_2, $InputFig_2)
			EndIf
	EndSwitch
WEnd


; Check for open/visable MSN Conversation Windows
Func ListMSN()
	$MSNList = WinList()
	For $i = 1 to $MSNList[0][0]
		If $MSNList[$i][0] <> "" AND IsVisible($MSNList[$i][1]) And StringInStr($MSNList[$i][0], "- CONVERSATION") And Not StringInStr($MSNList[$i][0], "mbrosius") Then
			GUICtrlSetData($Combo_1, $MSNList[$i][0])
		EndIf
	Next
EndFunc
Func IsVisible($Handle)
	If BitAnd( WinGetState($Handle), 2 ) Then 
		Return 1
	Else
		Return 0
	EndIf
EndFunc

; Interpret & Convert GUI Selections and Create Engine Commands
Func InitSpammer()
	GUICtrlSetState($Button_2, $GUI_ENABLE)
	; Get Edit Box Text if Necessary
	If $SendType = "Combo" Or $SendType = "Text" Then
		$SendText = GUICtrlRead($Edit_1)
	EndIf
	; Calculate Repeat Rate
	$RepeatRate = GUICtrlRead($Input_1)
		If $RepeatType = "Sec" Then
			$RepeatRate = Number($RepeatRate * 1000)
		EndIf
		If $RepeatType = "Min" Then
			$RepeatRate = Number($RepeatRate * 60000)
		EndIf
	; Calculate Duration Time
	$Duration = GUICtrlRead($Input_2)
		If $DurationType = "Sec" Then
			$Duration = Number($Duration * 1000)
		EndIf
		If $DurationType = "Min" Then
			$Duration = Number($Duration * 60000)
		EndIf
		If $DurationType = "Number" Then
			$Duration = Number($Duration * $RepeatRate)
		EndIf
		If $DurationType = "Infinite" Then
			$Duration = $RepeatRate
		EndIf
	; Calculate Progress Percentiles
	$Factor = $Duration / $RepeatRate
	$Percent = "100" / $Factor
	GUICtrlSetData($Progress_1, 0)
	;Get Target Window
	$Target = GUICtrlRead($Combo_1)
	;Reset $RunCount
	$RunCount = 0
EndFunc

; Spammer Engine 
Func SpamUp()
	;Ensure Infinite Countsown never reaches Zero
	If $DurationType = "Infinite" Then
		$Duration = Number($Duration + $RepeatRate)
	EndIf
	; Count Each Pass (Approxish)
	If $Duration > 0 Then
		; Count Each Pass & Update Progress(Approxish)
		$Duration = $Duration - $RepeatRate
		$RunCount = $RunCount + 1
		$Progress = $Percent * $RunCount
			GUICtrlSetData($Progress_1, $Progress)
		; The Actual Spamming Bit, ROFL
		If $SendType <> "Nudge" Then
			WinActivate($Target)
			Send($SendText & @CRLF)
		EndIf
		If $SendType <> "Text" Then
			WinActivate($Target)
			Send("!A")
			Send("d")
		EndIf
	EndIf
	If Not $Duration > 0 Then
		GUICtrlSetData($Progress_1, 100)
		GUICtrlSetState($Button_2, $GUI_DISABLE)
		AdlibDisable()
	EndIf
EndFunc
