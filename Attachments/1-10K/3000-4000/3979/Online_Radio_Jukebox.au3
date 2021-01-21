#include <GuiConstants.au3>

opt("TrayMenuMode", 1) 
opt("TrayOnEventMode", 1)

$show_tray = TrayCreateItem ("Show |Online Radio Jukebox|F9|")
TrayItemSetOnEvent (-1, "Show")
TrayCreateItem ("")
$hide_tray = TrayCreateItem ("Hide |Online Radio Jukebox|F8|")
TrayItemSetOnEvent (-1, "Hide")
TrayCreateItem ("")
$exit_tray = TrayCreateItem ("Exit |Online Radio Jukebox|")
TrayItemSetOnEvent (-1, "_Exit")
    
TraySetState ()

FileInstall("C:\close.bmp", @TempDir & "\close.bmp",1)
$Close = @TempDir & "\close.bmp"

$oMyError = ObjEvent("AutoIt.Error","Quit")
$oMediaplayer = ObjCreate("WMPlayer.OCX.7")    

If Not IsObj($oMediaplayer) Then Exit
$oMediaplayer.Enabled = true
$oMediaplayer.WindowlessVideo= true
$oMediaPlayer.UImode="invisible"
$oMediaPlayControl=$oMediaPlayer.Controls
$oMediaPlaySettings=$oMediaPlayer.Settings	

GuiCreate("Online Radio Jukebox", 215, 140, -1, -1, BitOR($WS_POPUP,$WS_DLGFRAME),$WS_EX_TOPMOST)
GuiCtrlCreateLabel("Online Radio Jukebox", 55, 10, 200, 20)
GUICtrlSetColor(-1, 0xff0000)
$combo_name = GuiCtrlCreateCombo("", 20, 30, 175, 20)
GuiCtrlSetData($combo_name, "Real Rock 101.1|Studio Brussel|Donna|Q-Music|4Fm|Contact|C-Dance|TopRadio|SkyRadio|Tmf|Noordzee|Veronica|BNN-Fm|Be-One|Oradio")
$Volume = GuiCtrlCreateSlider( 17,110, 180, 20)
GuiCtrlCreateLabel("Volume", 85, 95, 40, 20)
GUICtrlSetColor(-1, 0xff)
$VolLevel = $oMediaPlaySettings.Volume
GUICtrlSetData($Volume, $VolLevel)
$Play = GuiCtrlCreateButton("Play", 30, 60, 50, 25)
$Stop = GuiCtrlCreateButton("Stop", 80, 60, 50, 25)
$Load = GUICtrlCreateButton("Load", 130, 60, 50, 25)
$Cancel = GUICtrlCreateButton("Exit", 195, 0, 20, 20, $BS_BITMAP)
GUICtrlSetImage(-1, $Close)
GUICtrlSetTip(-1,"Exit")

GuiSetState()
HotKeySet("{F8}", "Hide")
HotKeySet("{F9}", "Show")

While 1
    $msg = GuiGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
	Case $msg = $combo_name
        $Radio = GuiCtrlRead($combo_name)
		If $Radio = "Real Rock 101.1" Then
		   $oMediaPlayer.URL="                                                                                       "
	    EndIf
        If $Radio = "Studio Brussel" Then
		   $oMediaPlayer.URL="mms://streampower.belgacom.be/stubruhigh"
	    EndIf
	    If $Radio = "Donna" Then
		   $oMediaPlayer.URL="mms://streampower.belgacom.be/donnahigh"
		EndIf
		If $Radio = "Q-Music" Then
		   $oMediaPlayer.URL="                                         "
	    EndIf
	    If $Radio = "4Fm" Then
		   $oMediaPlayer.URL="mms://wm.streampower.be/4fm"
	    EndIf
	    If $Radio = "Contact" Then
		   $oMediaPlayer.URL="mms://mediaserver02.cybernet.be/contactnl"
	    EndIf
	    If $Radio = "C-Dance" Then
		   $oMediaPlayer.URL="                                     "
	    EndIf
	    If $Radio = "TopRadio" Then
		   $oMediaPlayer.URL="                                        "
	    EndIf
	    If $Radio = "SkyRadio" Then
		   $oMediaPlayer.URL="                                                         "
	    EndIf
	    If $Radio = "Tmf" Then
		   $oMediaPlayer.URL="                                      "
	    EndIf
	    If $Radio = "Noordzee" Then
		   $oMediaPlayer.URL="mms://hollywood.win2k.vuurwerk.nl/noordzee"
	    EndIf
	    If $Radio = "Veronica" Then
		   $oMediaPlayer.URL="                                                                   "
	    EndIf
	    If $Radio = "BNN-Fm" Then
		   $oMediaPlayer.URL="                      "
	    EndIf
	    If $Radio = "Be-One" Then
		   $oMediaPlayer.URL="                                                                 "
	    EndIf
	    If $Radio = "Oradio" Then
		   $oMediaPlayer.URL="                                          "
	    EndIf
	
	Case $msg = $Cancel
		$oMediaPlayControl.Stop
       Exit
    Case $msg = $Load
		$media = FileOpenDialog("Offline Radio Jukebox", " {20D04FE0-3AEA-1069-A2D8-08002B30309D} ", "Media (*.wma;*.mp3)" ,1)
		$oMediaPlayer.URL = $media
    Case $msg = $Play
        $oMediaPlayControl.Play
    Case $msg = $Stop
        $oMediaPlayControl.Stop
    Case Else
        If GUICtrlread($Volume) <> $VolLevel Then
            $oMediaPlaySettings.Volume = GUICtrlRead($Volume)
            $VolLevel = GUICtrlRead($Volume)
        EndIf
    EndSelect
WEnd

Func Hide()
    GUISetState(@SW_HIDE)
EndFunc

Func Show()
    GUISetState(@SW_SHOW)
EndFunc

Func _Exit()
    Exit
EndFunc