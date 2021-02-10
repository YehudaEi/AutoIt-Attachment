#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <../media/video.au3>


Opt('MustDeclareVars', 1)

Global $hAVI
Global $Input1
Global $Input2
Global $Login
Global $Settings
Global $Help
Global $Exit
Global $List1

_Example1()



Func _Example1()
	Local $hGUI
    ; Create GUI
    $hGUI = GUICreate("(External 1) AVI Create", 720, 480)
	_GUICtrl_CreateWMPlayer("cm2sd_001.avi", 0, 0, 720, 480)

	
 
	$Input1 = GUICtrlCreateInput("", 296, 264, 297, 21)
	$Input2 = GUICtrlCreateInput("", 296, 312, 297, 21)

	$Login = GUICtrlCreateLabel("Login", 552, 376, 67, 73, BitOR($BS_PUSHBOX,$WS_GROUP))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Settings = GUICtrlCreateLabel("Settings", 		353, 375, 67, 73, BitOR($BS_PUSHBOX,$WS_GROUP))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Help = GUICtrlCreateLabel("Help", 				265, 374, 67, 73, BitOR($BS_PUSHBOX,$WS_GROUP))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Exit = GUICtrlCreateLabel("Exit", 				173, 378, 67, 73, BitOR($BS_PUSHBOX,$WS_GROUP))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$List1 = GUICtrlCreateList("", 34, 50, 246, 291)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

    GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
    GUISetState()
    ; Play the sample AutoIt AVI

    ; Loop until user exits
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE

    ; Close AVI clip


    GUIDelete()
EndFunc   ;==>_Example1
