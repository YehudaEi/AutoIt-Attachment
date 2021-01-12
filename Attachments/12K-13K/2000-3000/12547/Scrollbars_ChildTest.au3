#include <GUIConstants.au3>
Opt("MustDeclareVars", 1)

; need these as global for the functions
; for main gui
Global $m_width = 400, $m_height = 400
; child gui
Global $c_width = 200, $c_height = 200, $c_left = 215, $c_top = 200
; no child gui or no controls exceeding the width/height of the window
;~ Global $c_width = 0, $c_height = 0, $c_left = 0, $c_top = 0

#include <GUIScrollBars.au3>


_Main()

Func _Main()
    Local $nFileMenu, $nExititem, $GUIMsg, $hGUI, $h_cGUI, $h_cGUI2
    Local $listview, $button, $button2

    GUIRegisterMsg($WM_CREATE, "MY_WM_CREATE")
    GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")

    $hGUI = GUICreate("My GUI", 500, 500, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
    GUISetBkColor(0x88AABB)
    $nFileMenu = GUICtrlCreateMenu("File")
    $nExititem = GUICtrlCreateMenuitem("Exit", $nFileMenu)
	 
    GUIRegisterMsg($WM_CREATE, "MY_WM_CREATE")
	 
    $h_cGUI = GUICreate("Child GUI 1", $m_width, $m_height, 0, 0, BitOR($WS_CAPTION, $WS_CHILD,$WS_HSCROLL,$WS_VSCROLL), $WS_EX_CLIENTEDGE, $hGUI)
    GUISetBkColor(0X006400)
    $listview = GUICtrlCreateListView("col1  |col2|col3  ", 10, 10, 200, 150);,$LVS_SORTDESCENDING)
    $button = GUICtrlCreateButton("Value?", 75, 170, 70, 20)
    For $x = 1 To 30
        GUICtrlCreateListViewItem("item" & $x & "|col2|col3", $listview)
    Next
    GUISetState(@SW_SHOW, $h_cGUI)

    GUISwitch($hGUI)

    GUIRegisterMsg($WM_CREATE, "MY_WM_CREATE")
	 
    $h_cGUI2 = GUICreate("Child GUI 2", $c_width, $c_height, $c_left, 10, BitOR($WS_CAPTION, $WS_CHILD,$WS_HSCROLL,$WS_VSCROLL), $WS_EX_CLIENTEDGE, $h_cGUI)
    $button2 = GUICtrlCreateButton("Value?", 75, 170, 70, 20)
    GUISetBkColor(0x88AABB)
    GUISetState(@SW_SHOW, $h_cGUI2)

    GUISwitch($hGUI)

    GUIRegisterMsg($WM_VSCROLL, "MY_WM_VSCROLL")
    GUIRegisterMsg($WM_HSCROLL, "MY_WM_HSCROLL")
    GUISetState(@SW_SHOW, $hGUI)
    Local $RangeMinMax = _GetScrollRange($h_cGUI, $SB_VERT)
    ConsoleWrite("Vert Min/Max: " & $RangeMinMax[0] & "/" & $RangeMinMax[1] & @LF)
    $RangeMinMax = _GetScrollRange($h_cGUI, $SB_HORZ)
    ConsoleWrite("Horz Min/Max: " & $RangeMinMax[0] & "/" & $RangeMinMax[1] & @LF)
;~     Sleep(3000)
;~     _SetScrollRange($h_cGUI, $SB_VERT, 0, 400)
;~     Sleep(3000)
;~     _SetScrollRange($h_cGUI, $SB_HORZ, 0, 400)
;~    
;~     _EnableScrollBar ($h_cGUI, $SB_HORZ, False)
;~     Sleep(3000)
;~     _EnableScrollBar ($h_cGUI, $SB_HORZ)
;~    
;~     _EnableScrollBar ($h_cGUI, $SB_VERT, False)
;~     Sleep(3000)
;~     _EnableScrollBar ($h_cGUI, $SB_VERT)
;~    
;~     _ShowScrollBar ($h_cGUI, $SB_HORZ, False)
;~     Sleep(3000)
;~     _ShowScrollBar ($h_cGUI, $SB_HORZ)
;~     Sleep(3000)
;~     _ShowScrollBar ($h_cGUI, $SB_VERT, False)
;~     Sleep(3000)
;~     _ShowScrollBar ($h_cGUI, $SB_VERT)
;~    
;~     _SetScrollPos ($h_cGUI, $SB_HORZ, 10)
;~     Sleep(3000)
;~     _SetScrollPos ($h_cGUI, $SB_HORZ, 0)
;~     Sleep(3000)
;~     _SetScrollPos ($h_cGUI, $SB_VERT, 10)
;~     Sleep(3000)
;~     _SetScrollPos ($h_cGUI, $SB_VERT, 0)
;~    
;~     _SetScrollRange($h_cGUI, $SB_HORZ, 0, 400)
;~     _SetScrollRange($h_cGUI, $SB_VERT, 0, 400)
;~    
;~     $RangeMinMax = _GetScrollRange($h_cGUI, $SB_VERT)
;~     ConsoleWrite("Vert Min/Max: " & $RangeMinMax[0] & "/" & $RangeMinMax[1] & @LF)
;~     $RangeMinMax = _GetScrollRange($h_cGUI, $SB_HORZ)
;~     ConsoleWrite("Horz Min/Max: " & $RangeMinMax[0] & "/" & $RangeMinMax[1] & @LF)
   
    While 1
        $GUIMsg = GUIGetMsg()

        Switch $GUIMsg
            Case $GUI_EVENT_CLOSE, $nExititem
                ExitLoop
        EndSwitch
    WEnd

    Exit
EndFunc   ;==>_Main