#include <GuiConstants.au3>
Global $DumpOut = 0
HotKeySet ( '{esc}', "MyExitLoop" )
$InetActive = Ping("www.google.com")
If Not $InetActive > 0 Then
	MsgBox(4112, "Connection Not Found!", "You must be connected to the Internet" & @CRLF & "to use this program")
	Exit
EndIf

MsgBox(0, "Help File", "To Run this auto first select the time you want this game to run" & @CRLF & "Then Select the game you want to play and Press Go" & @CRLF & "The agent will then run for the time you selected then it will close " & @CRLF & "and reload the game window." & @CRLF & "To stop the Auto Close progam in system Menu")
; GUI
GUICreate("RoomMate", 175, 90, (@DesktopWidth - 191) / 2, (@DesktopHeight - 157) / 2)
GUISetState()
opt ("TrayMenuMode", 1)
opt ("TrayOnEventMode", 1)



$show_tray = TrayCreateItem ("About this Program")
TrayItemSetOnEvent (-1, "Set_Show")
TrayCreateItem ("")
$exit_tray = TrayCreateItem ("Exit this Program")
TrayItemSetOnEvent (-1, "Set_Exit")
TraySetState ()

$Combo_1 = GUICtrlCreateCombo("Select Game", 10, 10, 150, 21)
GUICtrlSetData($Combo_1, "|3-Point Showdown|6th Street Omaha Poker") 
$Button1 = GUICtrlCreateButton('GO', 35, 35, 100, 17)
GUICtrlCreateLabel("Minutes to play?", 10, 55, 250, 20)
$input = GUICtrlCreateInput(60, 125, 53, 30, 17, $ES_NUMBER)

While 1
	$MainMsg = GUIGetMsg()
	Select
		Case $MainMsg = $GUI_EVENT_CLOSE
			Exit
		Case $MainMsg = $Button1 
			Do
				If GuiCtrlread($Combo_1) = '3-Point Shootout' Then Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ')
				If GUICtrlRead($Combo_1) = '6th Street Omaha Poker' Then Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                             ')
					Sleep((GUICtrlRead($input)) * 60 * 1000)
			Until $DumpOut = 1
	EndSelect
WEnd





;------------- Functions ----------------------

Func MyExitLoop()
	$DumpOut = 1
EndFunc   ;==>MyExitLoop
Func Set_Exit()
	Exit
EndFunc   ;==>Set_Exit

Func Set_Show()
	MsgBox(64, " About this Program", " this Program was designed by HHCORY!!!")
EndFunc   ;==>Set_Show
; GUI MESSAGE LOOP
GUISetState()
While GUIGetMsg() <> $GUI_EVENT_CLOSE
WEnd
