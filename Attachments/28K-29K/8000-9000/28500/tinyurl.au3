#include <GUIConstantsEx.au3>

opt('MustDeclareVars', 0)

Example()

Func Example()
    Local $answer, $btn, $msg
    
    GUICreate("Tiny URL Launcher", 780, 70, @DesktopWidth / 2 - 370, @DesktopHeight / 2 - 45, -1)
	
	   $font = "Verdana"
    GUISetFont(30, 400, 4, $font)  
	GUICtrlCreateLabel ( "http://www.tinyurl.com/", 10, 10 )
    $answer = GUICtrlCreateInput("", 510, 5, 200, 60)
    GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	  GUISetFont(9, 400, 1, $font)
    $btn = GUICtrlCreateButton("GO", 710, 5, 60, 60)

    GUISetState()

    $msg = 0
    While $msg <> $GUI_EVENT_CLOSE
        $msg = GUIGetMsg()
        Select
            Case $msg = $btn
                ExitLoop
        EndSelect
    WEnd
$address = GUICtrlRead($answer)
ShellExecute("iexplore.exe", "http://www.tinyurl.com/" & $address, @SW_MAXIMIZE)
EndFunc   ;==>Example