#include <GUIConstants.au3>
;creates a dialog box
$mainwindow=GUICreate("Can't Select All Text!",800,400,200,200)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode   
Opt("GUICoordMode",1); Use absolute positioning
;Create the text input box
$sourcetext=GUICtrlCreateEdit ("",200,50,200,300,$ES_AUTOVSCROLL+$WS_VSCROLL+$ES_MULTILINE+$ES_WANTRETURN)
;Displays the Window because it's normally hidden
GUISetState ()
GUISetState(@SW_SHOW)
; Run the GUI until the dialog is closed
While 1
  Sleep(1000)  ; Idle around
WEnd
Func CLOSEClicked()
  Exit
EndFunc
