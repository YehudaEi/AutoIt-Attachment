#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

$sides=Number(InputBox("Polygon","Enter number of sites"))
Local $all[$sides+1][2]
GUICreate("Polygon",(20*$sides)+121,(26*$sides)+77)
$ok_button=GUICtrlCreateButton("OK",20*$sides+80,26*$sides+50,40,20)
GUICtrlCreateLabel("x(i)",15,10)
GUICtrlCreateLabel("y(i)",60,10)
For $i=1 To $sides
	GUICtrlCreateInput("",15,30*$i,30,20)
 	GUICtrlCreateInput("",50,30*$i,30,20)
Next

GUISetState()

While 1
	$msg=GUIGetMsg()
	Select
	Case $msg=$GUI_EVENT_CLOSE
		ExitLoop
	EndSelect
WEnd

	