#include "WindowsConstants.au3"
#include "GUIConstantsEx.au3"
#include "ListViewConstants.au3"
#include "Process.au3"

Opt('MustDeclareVars', 1)
Local $listview, $start, $close, $msg, $word, $double_click

Execute_process()
Func Execute_process()
    GUICreate("Execute program", 380, 400, -1, -1)
    $listview = GUICtrlCreateListView("Program|Status", 40, 30, 300, 300, $WS_EX_ACCEPTFILES)
    GUICtrlSendMsg($listview, 0x101E, 0, 140)
    GUICtrlSendMsg($listview, 0x101E, 1, 140)
   
    $word = GUICtrlCreateListViewItem("Word | Not running", $listview)
    GUICtrlSetColor(-1, 0x0000CC)
	
    $start = GUICtrlCreateButton("Start", 40, 350, 100, 25)
    $close = GUICtrlCreateButton("Close", 240, 350, 100, 25)
    
	GUISetState()
    checkprocess()
    Global $last_forcus_list_view
    AdlibRegister('checkprocess', 2000)
	While 1
        $msg = GUIGetMsg()
        Switch $msg
            Case -3, $close
                ExitLoop
            Case $start
                Switch $last_forcus_list_view
                     Case $word
						ShellExecute("winword.exe")
                    Case Else
                        MsgBox(0, "", "Start ?")
                EndSwitch
            
			 Case $word
				$last_forcus_list_view = $word
        EndSwitch
    WEnd
EndFunc
AdlibUnRegister('checkprocess')
GUIDelete()
Exit
Func checkprocess()
    	 
    If ProcessExists("winword.exe") Then
        GUICtrlSetData($word, "Word | Running")
    Else
        GUICtrlSetData($word, "Word | Not Running")
    EndIf

EndFunc