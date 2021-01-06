#include <GuiConstants.au3>

If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000

$GUI = GuiCreate("MyGUI", 609, 527,(@DesktopWidth-609)/2, (@DesktopHeight-527)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Group_1 = GuiCtrlCreateGroup("", 0, -10, 610, 80)
$Buttons = GuiCtrlCreateCheckbox("Buttons", 10, 10, 80, 20)
$Labels = GuiCtrlCreateCheckbox("Labels", 10, 40, 90, 20)
$Radios = GuiCtrlCreateCheckbox("Radios", 120, 10, 80, 20)
$Input = GuiCtrlCreateCheckbox("Input", 120, 40, 80, 20)
$GUISize = GuiCtrlCreateCheckbox("GUISize", 220, 10, 80, 20)
$GUISizeWidth = GuiCtrlCreateInput("", 220, 40, 70, 20)
GUICtrlSetState(-1,$GUI_DISABLE)
$GUISizeHight = GuiCtrlCreateInput("", 300, 40, 70, 20)
GUICtrlSetState(-1,$GUI_DISABLE)
$AddItems = GuiCtrlCreateButton("Add items", 480, 20, 90, 40)
$Group_9 = GuiCtrlCreateGroup("Buttons", 10, 100, 580, 80)
$Group_10 = GuiCtrlCreateGroup("Labels", 10, 200, 580, 80)
$Group_11 = GuiCtrlCreateGroup("Radios", 10, 300, 580, 80)
$Group_12 = GuiCtrlCreateGroup("Input", 10, 400, 580, 80)

$Button1 = GUICtrlCreateButton("A button",20,120,80,22)
$Button2 = GUICtrlCreateButton("A button",20,150,80,22)
GUICtrlSetState($Button1,$GUI_HIDE)
GUICtrlSetState($Button2,$GUI_HIDE)

$Label1 = GUICtrlCreateLabel("A Label",20,220,80,22)
$Label2 = GUICtrlCreateLabel("A Label",20,250,80,22)
GUICtrlSetState($Label1,$GUI_HIDE)
GUICtrlSetState($Label2,$GUI_HIDE)

$Radio1 = GUICtrlCreateRadio("A Radio",20,320,80,22)
$Radio2 = GUICtrlCreateRadio("A Radio",20,350,80,22)
GUICtrlSetState($Radio1,$GUI_HIDE)
GUICtrlSetState($Radio2,$GUI_HIDE)

$Input1 = GUICtrlCreateInput("An Input",20,420,80,22)
$Input2 = GUICtrlCreateInput("An Input",20,450,80,22)
GUICtrlSetState($Input1,$GUI_HIDE)
GUICtrlSetState($Input2,$GUI_HIDE)

GuiSetState()
While 1
    $msg = GuiGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
   
   Case $msg = $AddItems
		If GUICtrlRead($Buttons) = $GUI_CHECKED Then
			GUICtrlSetState($Button1,$GUI_SHOW)
			GUICtrlSetState($Button2,$GUI_SHOW)
		Else	
			GUICtrlSetState($Button1,$GUI_HIDE)
			GUICtrlSetState($Button2,$GUI_HIDE)
		EndIf	

		If GUICtrlRead($Labels) = $GUI_CHECKED Then
			GUICtrlSetState($Label1,$GUI_SHOW)
			GUICtrlSetState($Label2,$GUI_SHOW)
		Else
			GUICtrlSetState($Label1,$GUI_HIDE)
			GUICtrlSetState($Label2,$GUI_HIDE)		
		EndIf
		
		If GUICtrlRead($Radios) = $GUI_CHECKED Then
			GUICtrlSetState($Radio1,$GUI_SHOW)
			GUICtrlSetState($Radio2,$GUI_SHOW)
		Else
			GUICtrlSetState($Radio1,$GUI_HIDE)
			GUICtrlSetState($Radio2,$GUI_HIDE)
		EndIf

		If GUICtrlRead($Input) = $GUI_CHECKED Then
			GUICtrlSetState($Input1,$GUI_SHOW)
			GUICtrlSetState($Input2,$GUI_SHOW)
		Else
			GUICtrlSetState($Input1,$GUI_HIDE)
			GUICtrlSetState($Input2,$GUI_HIDE)
		EndIf
	
	
	Case $msg = $GUISize
		If  GUICtrlRead($GUISize) = $GUI_CHECKED Then  
			GUICtrlSetState($GUISizeWidth,$GUI_ENABLE)
			GUICtrlSetState($GUISizeHight,$GUI_ENABLE)
		Else
			GUICtrlSetState($GUISizeWidth,$GUI_DISABLE)
			GUICtrlSetState($GUISizeHight,$GUI_DISABLE)
		EndIf	
	
	
	
	EndSelect
WEnd
Exit
