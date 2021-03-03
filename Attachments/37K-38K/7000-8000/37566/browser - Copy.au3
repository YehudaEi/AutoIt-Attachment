#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>

$IE = _IECreateEmbedded ()

Global $html


#Region ### START Koda GUI section ### Form=c:\program files\autoit3\scite\koda\forms\webbrowser.kxf
$Form1 = GUICreate("Webbrower - whatsupMM", 1234, 737, 208, 124)
$Menu_Datei = GUICtrlCreateMenu("&Datei")
$Menu_Einstellungen = GUICtrlCreateMenuItem("Einstellungen", $Menu_Datei)
$Menu_beenden = GUICtrlCreateMenuItem("Beenden", $Menu_Datei)
$GUI_url = GUICtrlCreateInput("http://www.tutorial4u.de", 72, 8, 801, 21)
$Label1 = GUICtrlCreateLabel("Adresse:", 8, 8, 67, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$GUI_go = GUICtrlCreateButton("Go!", 880, 8, 65, 25, $WS_GROUP)
$GUI_home = GUICtrlCreateButton("HOME", 1072, 8, 89, 25, $WS_GROUP)
$browser = GUICtrlCreateObj($IE,8, 40, 1217, 673)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_IENavigate($IE,"http://www.tutorial4u.dev")



While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit

        Case $Menu_beenden
            Exit
        case $GUI_go
            $html = GUICtrlRead($gui_url)
;~          MsgBox(0,"",$html);funzt doch...
            _IENavigate($IE,$html)
    EndSwitch
WEnd
