; This is a demonstration for Object Create.

#include <GuiConstants.au3>; include GUI constants when using a GUI.

GUICreate("Object Test", 614, 370); Create the GUI with a title of, Object Test.

GUISetFont(9, 400, -1, "MS Sans Serif"); set the font size to number 9, the weight, and the style.

$B_oIE1 = ObjCreate("Shell.Explorer.2"); create the, explorer object.

$Breaktime = GUICtrlCreateObj($B_oIE1, -1, -1, 500, 370); create the, embeded, object control.

; set the text in a variable called html.
$html = "about:Welcome to AutoIt 1-2-3, by Valuater"

$B_oIE1.navigate ( $html); navigate the explorer object to the html variable, ( known as about ).

; create the two buttons.
$BrkStart = GUICtrlCreateButton("&Enter", 515, 300, 80, 25)
$BrkEnd = GUICtrlCreateButton("&Exit", 515, 330, 80, 25)

GUISetState(); set the GUI as Visible.

While 1; start loop, so the script continues and does not exit.
    
    $msg = GUIGetMsg(); listen for a message.
    
    If $msg = $GUI_EVENT_CLOSE Or $msg = $BrkEnd Then; if exit is pressed, then exit the script.
        Exit
    EndIf
    
    If $msg = $BrkStart Then; if this button is pushed, we navigate the object to the site.
        $B_oIE1.navigate ("                      ")
    EndIf
    
WEnd; end loop.
