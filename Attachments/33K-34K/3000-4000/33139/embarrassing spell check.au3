#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)

Example()

;-------------------------------------------------------------------------------------
; Example - Press the button to see the value of the radio boxes
; The script also detects state changes (closed/minimized/timeouts, etc).
Func Example()
    Local $button_1, $group_1, $radio_1, $radio_2, $radio_3, $button_2, $button_3
    Local $radioval1, $radioval2, $radioval3, $msg, $oIE, $WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN, $GUIActiveX, $background

    Opt("GUICoordMode", 1)
    GUICreate("Supreme Carpet and Flooring", 600, 650)
   
    $GUIActiveX = GUICtrlCreateObj ($oIE, 10, 40, 600, 360)
    $background = GUICtrlCreatePic("C:\Supreme Carpet\Images\gui.jpg", -1, -1, 600, 600)



   
    ; Create the controls
    $button_1 = GUICtrlCreateButton("Select", 30, 20, 120, 40)

    $group_1 = GUICtrlCreateGroup("!", 20, 10, 600, 600)
    GUIStartGroup("!")
    $radio_1 = GUICtrlCreateRadio("", 450, 186)
    $radio_2 = GUICtrlCreateRadio("", 220, 595)
    $radio_3 = GUICtrlCreateRadio("", 485, 550)

    ; Init our vars that we will use to keep track of GUI events
    $radioval1 = 0    ; We will assume 0 = first radio button selected, 2 = last button
    $radioval2 = 2
    $radioval3 = 3
   
    ; Show the GUI
    GUISetState()

    ; In this message loop we use variables to keep track of changes to the radios, another
    ; way would be to use GUICtrlRead() at the end to read in the state of each control
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                MsgBox(0, "Supreme Support line", "This is embarrassing the active Window forgot your number. please Call our support line at 503 407 2687")
                Exit
            Case $msg = $GUI_EVENT_MINIMIZE
                MsgBox(0, "Supreme Support line", "This is embarrassing the active window forgot your number. please Call our support line at 503 407 2687", 2)
            Case $msg = $GUI_EVENT_MAXIMIZE
                MsgBox(0, "Supreme Support line", "This is embarrassing the active window forgot your number. please Call our support line at 503 407 2687", 2)

            Case $msg = $button_1
                MsgBox(0, "Supreme Support line", "This is embarrassing the active window forgot your number. please Call our support line at 503 407 2687")

            Case $msg = $button_1 and $radioval1
        MsgBox(0, "Supreme Support line", "This is embarrassing the active software window your number. please Call our support line at 503 407 2687")
            Case $msg = $button_1 and $radioval2
        MsgBox(0, "Supreme Support line", "This is embarrassing the active software window your number. please Call our support line at 503 407 2687")
       
             Case $msg = $button_1 and $radioval3
        MsgBox(0, "Supreme Support line", "This is embarrassing the active software window your number. please Call our support line at 503 407 2687")
               
               

        EndSelect
    WEnd
EndFunc   ;==>Example
