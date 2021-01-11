#Include <GUIConstants.au3>
#Include <Rad.au3>
#Include <Misc.au3>
#include <IE.au3> 

$GUI = GUICreate("Rads Window",256,256)
$Label = GUICtrlCreateLabel("Pan me", 2, 22, 60, 20, $SS_Center)
GUICtrlSetBkColor(-1,0xe4ebef)
$Button = GUICtrlCreateButton("Click me", 64, 2, 60, 60, $BS_Multiline)
$waspressed = _IsPressed("01")
$buttonstate = "idle"
$SearchButton = GUICtrlCreateButton("Search", 2, 64, 60, 60)

$LabelData = "                  This program isnt that great...   NOT"
$LabelView = _StringSeed($LabelData, " ")
$TrackLabel	= 	GUICtrlCreateLabel("", 64, 64, 118, 18, -1, $WS_EX_CLIENTEDGE)

GUISetState()
$timer = TimerInit()


While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	If $msg = $Label Then _PanWindow("Rads Window", "", $Label)
	If _ControlGetActive() = $Button And $Buttonstate = "idle" Then 
		GUICtrlSetData($Button, "Just click me!")
		$buttonstate = "hover"
	ElseIf $buttonstate = "hover" And _ControlGetActive() <> $Button Then
		GUICtrlSetData($Button, "Click me")
		$buttonstate = "idle"
	Endif
	If _ControlIsActive($Button) And _IsPressed("01") = 1 And $waspressed = 0 Then
		$Buttonstate = "pressed"
		GUICtrlSetData($Button, "Good job")
		sleep(10)
		Do
		Until _IsPressed("01") = 0 OR Not _ControlIsActive($Button)
		GUICtrlSetData($Button, "Click me")
		$buttonstate = "idle"
	EndIf
	If $msg = $SearchButton Then
		$File = FileOpenDialog("Select a .txt file", @DesktopDir, "Text Document (*.txt)")
		$String = InputBox("What string to search for?", "Enter a string to search for","the")
		Msgbox(0,"",$string & ' occured on ' &  _FileCountOccurrences($File, $String) & " lines")
		FileClose($File)
	Endif
	If TimerDiff($timer) > 100 Then
		TimerStop($timer)
		$timer = TimerStart()
		If $LabelView = _StringSeed($LabelData, " ") Then
			$LabelView = _StringSlideLtoR($LabelView, "              ")
			GUICtrlSetData($TrackLabel,$LabelView)
		Else
			$LabelView = _StringSlideLtoR($LabelView, "")
			GUICtrlSetData($TrackLabel,$LabelView)
		EndIf
	EndIf
	$waspressed = _IsPressed("01")
WEnd