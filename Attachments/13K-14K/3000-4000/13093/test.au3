#include <GUIConstants.au3>

$Form1 = GUICreate("AForm1", 146, 98, 448, 296)
$Button1 = GUICtrlCreateButton("AButton1", 8, 64, 129, 25, 0)
$Label1 = GUICtrlCreateLabel("", 8, 8, 129, 49, BitOR($SS_CENTER,$SS_SUNKEN))
$SpacePressed = false;

GUICtrlSetFont(-1, 24, 800, 0, "Comic Sans MS")
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button1
            $Pressed = 0
            GUICtrlSetState($Button1, $GUI_DISABLE)
            HotKeySet("{SPACE}", "_TrackKey")
            For $i = 5 To 0 Step -1
                GUICtrlSetData($Label1, $i)
                Sleep(1000)
            Next
            HotKeySet("{SPACE}")
            MsgBox(0, "", "Pressed Space " & $Pressed & " Times.")
            GUICtrlSetState($Button1, $GUI_ENABLE)
    EndSwitch
WEnd

Func _TrackKey()
    if $SpacePressed = true then
        msgbox( 0 , "" , "Cheater!!!!" )
    	return
    endif
    	
    $SpacePressed = true
    sleep(50)
    $Pressed = $Pressed + 1
    $SpacePressed = false
EndFunc