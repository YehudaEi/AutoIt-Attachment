#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 0)
Global $start
Global $n = 0
Global $MousePos = True
Global $pos
Global $clickspeed = RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "DoubleClickSpeed")

$Form1 = GUICreate("Form1 - Testing DoubleClick For Each Control", 400, 350, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, '_PRIMARYdown')
GUISetOnEvent($GUI_EVENT_PRIMARYUP, '_PRIMARYup')
$Label1 = GUICtrlCreateLabel("Label1", 30, 40, 40, 17, $SS_SUNKEN)
$Label2 = GUICtrlCreateLabel("Label2", 30, 80, 40, 17, $SS_SUNKEN)
$Input1 = GUICtrlCreateInput("Input1", 90, 40, 70, 20)
$Input2 = GUICtrlCreateInput("Input2", 90, 80, 70, 20)
$Group1 = GUICtrlCreateGroup("Group1", 190, 30, 190, 80)
$Pic1 = GUICtrlCreatePic(@Systemdir & "\oobe\images\mslogo.jpg", 30, 130, 200, 50)
$Avi1 = GUICtrlCreateAvi (@SystemDir & "\shell32.dll", 150, 270, 130)
$Edit1 = GUICtrlCreateEdit("Edit1", 30, 200, 340, 130)
GUICtrlSetState($Avi1, 1)
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func Form1Close()
	Exit
EndFunc

#region DoubleClick Check
Func _PRIMARYdown()
	$pos = MouseGetPos()
	Select
		Case _CheckCtrlDblClick($Form1, $Label1)
			_Lbl_1_DblClick()
		Case _CheckCtrlDblClick($Form1, $Label2)
			_Lbl_2_DblClick()
		Case _CheckCtrlDblClick($Form1, $Input1)
			_Inp_1_DblClick()
		Case _CheckCtrlDblClick($Form1, $Input2)
			_Inp_2_DblClick()
		Case _CheckCtrlDblClick($Form1, $Group1)
			_Group_1_DblClick()
		Case _CheckCtrlDblClick($Form1, $Pic1)
			_Pic_1_DblClick()
		Case _CheckCtrlDblClick($Form1, $Avi1)
			_Avi_1_DblClick()
		Case _CheckCtrlDblClick($Form1, $Edit1)
			_Edit_1_DblClick()
		Case Else 
			$MousePos = False
	EndSelect
EndFunc

Func _PRIMARYup()
	If $MousePos Then
		If $n = 2 Then 
			$n = 0
		Else
			$start = TimerInit()
		EndIf
	EndIf
EndFunc

Func _CheckCtrlDblClick($GUI, $CTRL)
	Local $CtrlPos = ControlGetPos($GUI, '', $CTRL)
	If 	($pos[0] >= $CtrlPos[0] And $pos[0] <= $CtrlPos[0] + $CtrlPos[2]) And _
		($pos[1] >= $CtrlPos[1] +20 And $pos[1] <= $CtrlPos[1] +20 + $CtrlPos[3]) Then
		$n += 1
		$MousePos = True
		If $n = 2 And (TimerDiff($start) < $clickspeed) Then 
			Return True
		Else
			$start = TimerInit()
			$n = 1
		EndIf
	EndIf
EndFunc
#endregion DoubleClick Check
#region DoubleClick Functions
Func _Lbl_1_DblClick()
	MsgBox(0, '', 'Doubleclick Label 1')
EndFunc	

Func _Lbl_2_DblClick()
	MsgBox(0, '', 'Doubleclick Label 2')
EndFunc	

Func _Inp_1_DblClick()
	MsgBox(0, '', 'Doubleclick Input 1')
EndFunc

Func _Inp_2_DblClick()
	MsgBox(0, '', 'Doubleclick Input 2')
EndFunc

Func _Group_1_DblClick()
	MsgBox(0, '', 'Doubleclick Group 1')
EndFunc

Func _Pic_1_DblClick()
	MsgBox(0, '', 'Doubleclick Picture 1')
EndFunc 
	
Func _Avi_1_DblClick()
	MsgBox(0, '', 'Doubleclick Avi 1')
EndFunc

Func _Edit_1_DblClick()
	MsgBox(0, '', 'Doubleclick Edit 1')
EndFunc
#endregion DoubleClick Functions