GuiCreate("Riddle Box-Another Krazyk's Kreation",400,500,200,200) ;make a Graphic User Interface (gui)
$button1=GuiCtrlCreateButton("Random Riddle",40,45,150,25)
$button2=GuiCtrlCreateButton("Submit Riddle", 210,45,150,25)
$Box1= GUICtrlCreateEdit("Display Riddle here",40,130,320,150)
$Box2=GUICtrlCreateEdit("Display Answer Here",40,300,320,150)
GuiSetState()
While 1
$msg=GuiGetMsg() ;get input from gui
If $msg=-3 Then Exit
If $msg=$button1 Then Run("notepad.exe")
WEnd