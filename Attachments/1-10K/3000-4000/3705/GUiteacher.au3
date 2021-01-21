
#include <GuiConstants.au3> ; Include the constants required for the gui.

GuiCreate("Test", 316, 105,(@DesktopWidth-316)/2, (@DesktopHeight-105)/2) ;Create The GUI window.

$Button_MessageBox = GuiCtrlCreateButton("Show MsgBox", 10, 10, 300, 30) ;Create messagebox the button
$Button_InputBox = GuiCtrlCreateButton("InputBox", 10, 50, 300, 30) ; create the inputbox Button.

GuiSetState() ; Show the GUI now that the buttons are there
While 1 ;begin while loop
	$msg = GuiGetMsg() ; get the current message from the GUI
	Select ;begin the select statement
	Case $msg = $GUI_EVENT_CLOSE ; If the X in the corner of the window is clicked do the lines until the next case statment.
		Exit ;quit the script.
	Case $msg = $Button_InputBox ; If the InputBox button  is clicked do the lines until the next case statment.
		$Input=InputBox("InputBox"," ") ; open an input box and save its input to $Input
		If @Error then ContinueLoop ;Dont execute the lines below if cancel is pressed.
		GuiCtrlSetData($Button_InputBox,$Input) ;Change the caption of the inputbox button to the data contained in $Input
	Case $msg=$Button_MessageBox ; If the messagebox button  is clicked do the lines until the endselect statement.
	MsgBox(0,"Hello","Hi") ;Pop up a message ox that says hello.
	EndSelect ;end select statement
WEnd ;end while loop