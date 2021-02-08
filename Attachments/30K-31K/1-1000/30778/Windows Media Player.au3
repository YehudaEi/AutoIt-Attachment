#include <GUIConstants.au3>
$gui = GUICreate("",250,255)
$oMP = ObjCreate("WMPlayer.OCX")
$mediaplayer = GUICtrlCreateObj($oMP, 5, 5, 300, 300)
GUISetState(@SW_SHOW)
With $oMP
    .fullScreen = True
    .windowlessVideo = False
    .enableContextMenu = True
    .enabled = True
    .uiMode = "full"
    .settings.autostart = True
    .settings.mute = False
    .settings.volume = 100
    .settings.Balance = 0
    .URL = "http://blackbeats.fm/listen.asx"
EndWith

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd