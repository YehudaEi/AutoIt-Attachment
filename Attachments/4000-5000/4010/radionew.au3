
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

#NoTrayIcon
#include <GUIConstants.au3>
opt("GUIOnEventMode", 1)

$oMyError = ObjEvent("AutoIt.Error","Quit")
$oMediaplayer = ObjCreate("WMPlayer.OCX.7")    

If Not IsObj($oMediaplayer) Then Exit
$oMediaplayer.Enabled = true
$oMediaplayer.WindowlessVideo= true
$oMediaPlayer.UImode="invisible"
$oMediaPlayControl=$oMediaPlayer.Controls
$oMediaPlaySettings=$oMediaPlayer.Settings 

Dim $s_TempFile
$bmp = _TempFile()

FileInstall("gui.bmp", $bmp)

; Caption
$caption = "Online Radio Jukebox"
; Caption

$gui = GUICreate("Main GUI", 230, 110, -1, -1, $WS_POPUP + $WS_SYSMENU + $WS_MINIMIZEBOX, $WS_EX_LAYERED)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

$caption = GUICtrlCreateLabel($caption, 12, 4, 180, 14)
GUICtrlSetStyle($caption, -1, $WS_EX_TRANSPARENT); To show $caption text
GUICtrlSetStyle($caption, $DS_SETFOREGROUND)
GUICtrlSetFont($caption, 9, 400, -1, "Arial Bold")
GUICtrlSetColor($caption, 0xF5F5F5)
GUICtrlSetOnEvent($caption, "_Drag")

$min = GUICtrlCreateLabel("", 198, 4, 11, 11)
GUICtrlSetOnEvent($min, "Minimize")
GUICtrlSetTip($min, "Minimize")

$close = GUICtrlCreateLabel("", 210, 4, 11, 11)
GUICtrlSetOnEvent($close, "Close")
GUICtrlSetTip($close, "Close")

$combo_name = GuiCtrlCreateCombo("", 10, 30, 155, 20)
GUICtrlSetOnEvent(-1, "ComboEvent")
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
GuiCtrlSetData($combo_name, "Real Rock 101.1|Studio Brussel|Donna|Q-Music|4Fm|Contact|C-Dance|TopRadio|SkyRadio|Tmf|Noordzee|Veronica|BNN-Fm|Be-One|Oradio")

$Volume = GuiCtrlCreateSlider( 13, 77, 148, 20)
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
$VolLevel = $oMediaPlaySettings.Volume
GUICtrlSetData(-1, $VolLevel)
GUICtrlSetOnEvent(-1, "SliderEvent")

GuiCtrlCreateLabel("Volume", 69, 58, 40, 20)
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
GUICtrlSetColor(-1, 0xff)

$Play = GuiCtrlCreateButton("Play", 175, 30, 45, 22)
GUICtrlSetStyle($Play, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Play, "Play")
$Stop = GuiCtrlCreateButton("Stop", 175, 55, 45, 22)
GUICtrlSetStyle($Stop, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Stop, "Stop")
$Load = GUICtrlCreateButton("Load", 175, 80, 45, 22)
GUICtrlSetStyle($Load, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Load, "Load")

$pic = GUICtrlCreatePic($bmp, 0, 0, 230, 110)
GUICtrlSetOnEvent($pic, "_Drag")
$contextmenu = GUICtrlCreateContextMenu($pic)
$min_item = GUICtrlCreateMenuItem("Min", $contextmenu)
GUICtrlSetOnEvent($min_item, "Minimize")
$close_item = GUICtrlCreateMenuItem("Close", $contextmenu)
GUICtrlSetOnEvent($close_item, "Close")
GUICtrlCreateMenuItem("", $contextmenu); separator
$about_item = GUICtrlCreateMenuItem("About", $contextmenu)
GUICtrlSetOnEvent($about_item, "About")

GUISetState(@SW_SHOW)

While 1
    Sleep(1000)
WEnd

Func Btn()
    GUISetState(@SW_HIDE)
    SplashTextOn("btn", "Button clicked", 130, 19, -1, -1, 1, "", 12)
    Sleep(100)
    SplashOff()
    GUISetState(@SW_SHOW)
EndFunc

Func About()
    Msgbox(0, "About", "...")
EndFunc

Func Close()
    GUISetState(@SW_HIDE)
    FileDelete($bmp)
    Exit
EndFunc

Func Minimize()
    GUISetState(@SW_MINIMIZE)
EndFunc

Func _TempFile()
    Local $s_TempName
    
    Do
        $s_TempName = "~"
        While StringLen($s_TempName) < 7
            $s_TempName = $s_TempName & Chr(Round(Random(65, 90), 0))
        WEnd
        $s_TempName = @TempDir & "\" & $s_TempName & ".tmp"
    Until Not FileExists($s_TempName)
    Return ($s_TempName)
EndFunc

Func _Drag()
    DllCall("user32.dll", "int", "ReleaseCapture")
    DllCall("user32.dll", "int", "SendMessage", "hWnd", $gui, "int", 0xA1, "int", 2, "int", 0)
EndFunc

Func Play()
    $oMediaPlayControl.Play
EndFunc

Func Stop()
    $oMediaPlayControl.Stop
EndFunc

Func Load()
    $media = FileOpenDialog("Offline Radio Jukebox", " {20D04FE0-3AEA-1069-A2D8-08002B30309D} ", "Media (*.wma;*.mp3)" ,1)
        $oMediaPlayer.URL = $media
EndFunc

Func ComboEvent()
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
EndFunc

Func SliderEvent()
        If GUICtrlread($Volume) <> $VolLevel Then
            $oMediaPlaySettings.Volume = GUICtrlRead($Volume)
            $VolLevel = GUICtrlRead($Volume)
        EndIf
EndFunc