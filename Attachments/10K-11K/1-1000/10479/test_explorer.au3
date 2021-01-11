#include <GUIConstants.au3>
; Simple example: Embedding an Internet Explorer Object inside an AutoIt GUI
;
; The full example is available in the test\ActiveX directory (TestXInternet.au3)
;
; See also: http://msdn.microsoft.com/workshop/browser/webbrowser/reference/objects/internetexplorer.asp

$oIE = ObjCreate("Shell.Explorer.2")

; Create a simple GUI for our output
GUICreate ( "Embedded Web control Test", 660, 590,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$GUIActiveX			= GUICtrlCreateObj		( $oIE,		 10, 10 , 640 , 550 )
$GUI_Button_Back	= GuiCtrlCreateButton	("Back",	 10, 560, 80,  30)
$GUI_Button_Forward	= GuiCtrlCreateButton	("Forward",	100, 560, 80,  30)
$GUI_Button_Home	= GuiCtrlCreateButton	("Home",	190, 560, 80,  30)
$GUI_Button_Stop	= GuiCtrlCreateButton	("Stop",	280, 560, 80,  30)
$GUI_Input_Address	= GuiCtrlCreateInput	("                     ",	370, 565, 220,  18)
$GUI_Button_Go		= GuiCtrlCreateButton	("Go",	590, 565, 60,  18)

GUISetState ()       ;Show GUI

$oIE.navigate("                    ")

; Waiting for user to close the window
While 1
    $msg = GUIGetMsg()
    
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $GUI_Button_Home
			$oIE.navigate("http://www.autoitscript.com")
		Case $msg = $GUI_Button_Back
			$oIE.GoBack
		Case $msg = $GUI_Button_Forward
			$oIE.GoForward
		Case $msg = $GUI_Button_Stop
			$oIE.Stop
		Case $msg = $GUI_Button_Go
			$oIE.navigate(GUICtrlRead($GUI_Input_Address))
	EndSelect
	
Wend

GUIDelete ()

Exit

