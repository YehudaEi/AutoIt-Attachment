;	Project Name: Application Holder
;	Description	: This program is generally for me to understand some code posted by CyberSlug on creating in child
;				  window inside a parent window.
;	Written by	: Igmeou
;	Dated on	: 14 Mar 05
;	Version no.	: 0.1(template)

#region Start of #includes
#include <GUIConstants.au3>
#endregion End of #includes

#region Start of onEvent mode Setting
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
#endregion End of onEvent mode Setting

#region Start of Parent Window
;Creation of the parent window
$parentGUI = GuiCreate("Parent", 500, 350, 10, 10, $WS_CLIPSIBLINGS + $WS_OVERLAPPEDWINDOW + $WS_VISIBLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "parentClose")	

#region + Start of Parent Menu
;Creation of File menu and items
$fileMenu = GUICtrlCreateMenu ("&File")
$exitFMItem = GUICtrlCreateMenuitem ("Exit",$fileMenu)
GUICtrlSetOnEvent($exitFMItem, "parentClose")
;Creation of Create menu and items
$createMenu = GUICtrlCreateMenu ("&Create")
$childCMItem = GUICtrlCreateMenuitem ("Child Windows",$createMenu)
GUICtrlSetOnEvent($childCMItem, "createChild")
GUISetState(@SW_SHOW)
#endregion End of Parent Menu
#endregion End of Parent Window

#region Start of Child Windows Variables
;Variables for the child windows
Global $childWindows = 0, $childControlID[10], $childFuncClose[10]
#endregion End of Child Windows Variables

#region Start of Main Program
While 1
	Sleep(1000)
WEnd
#endregion End of Main Program

#region Start of Child Creation Functions
Func createChild()
	Dim $num = 1, $startXY = 10
	$num = askNumber("Enter Number of child windows to create?")
	;Return to main program if player cancel the inputbox/didn't key in value
	If $num = 0 Then
		Return
	EndIf
	MsgBox(0,"Debug",$num,1)
	;Creation of the Child Windows
	For $count = 1 To $num Step 1
		$childControlID[$childWindows] = GuiCreate("Child", 100, 100, ($startXY+($count*10)), ($startXY+($count*10)), _
										$WS_CHILD + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_CLIPCHILDREN + $WS_OVERLAPPEDWINDOW, _
										$WS_EX_APPWINDOW + $WS_EX_WINDOWEDGE , $parentGUI)
		$childFuncClose[$childWindows] = "childClose" & ($childWindows+1)
		GUISetOnEvent($GUI_EVENT_CLOSE, $childFuncClose[$childWindows])
		GUISetState(@SW_SHOW)
		$childWindows = $childWindows + 1
	Next
EndFunc
;This function will ask user a question and return the number
Func askNumber($question)
	$answer = InputBox ("Please answer the question", $question) ;can use for string only
	;Return 0 for invalid input and not a number
	If @error > 0 Then
		Return 0
	EndIf
	$answer = Number($answer)
	Return $answer
EndFunc
#endregion End of Child Creation Functions

#region Start if Closing Functions
Func parentClose()
	For $count = 1 To $childWindows Step 1
		Call("childClose" & $count)
	Next
  Exit
EndFunc

Func childClose1()
	GUIDelete($childControlID[0])
EndFunc
Func childClose2()
	GUIDelete($childControlID[1])
EndFunc
Func childClose3()
	GUIDelete($childControlID[2])
EndFunc
Func childClose4()
	GUIDelete($childControlID[3])
EndFunc
Func childClose5()
	GUIDelete($childControlID[4])
EndFunc
Func childClose6()
	GUIDelete($childControlID[5])
EndFunc
Func childClose7()
	GUIDelete($childControlID[6])
EndFunc
Func childClose8()
	GUIDelete($childControlID[7])
EndFunc
Func childClose9()
	GUIDelete($childControlID[8])
EndFunc
Func childClose10()
	GUIDelete($childControlID[9])
EndFunc
#endregion End of Closing Functions
