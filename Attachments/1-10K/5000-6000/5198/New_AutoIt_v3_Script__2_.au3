
;Created by NegativeNrG
;;;;created for people who have slow computers, and WMP/WINAmp tkes lots og space.
#include <GUIConstants.au3>
#notrayicon
$Form1 = GUICreate("NegativeNrG's Media Player & VIdeo Player", 307, 197, 236, 222)
$play = GUICtrlCreateButton("Play", 32, 32, 59, 25)
$filemenu = GUictrlcreatemenu ("File")
$Filexit = Guictrlcreatemenuitem ("Exit", $filemenu)
$trackmenu = GuiCtrlCreateContextMenu ()
$aboutitem = GuiCtrlCreateMenuitem ("Open",$trackmenu)
; next one creates a menu separator (line)
$exititem = GuiCtrlCreateMenuitem ("Exit",$trackmenu)
$1filemenu = Guictrlcreatemenu ("?")
$filemenu = Guictrlcreatemenuitem ("About",$1filemenu)
$helpmenu = GUIctrlcreatemenuitem ("Help",$1filemenu)
$stop = GUICtrlCreateButton("Stop", 96, 32, 59, 25)
$browse = GUICtrlCreateButton("Browse", 160, 32, 59, 25)
$exit = GUICtrlCreateButton("Exit", 224, 32, 59, 25)
$mute = GUICtrlCreateButton("Mute", 96, 72, 59, 25)
$unmute = GUICtrlCreateButton("Unmute", 160, 72, 59, 25)
$volup = GUICtrlCreateButton("Volume up", 224, 72, 59, 25)
$voldown = GUICtrlCreateButton("Volume Down", 224, 104, 75, 25)
$Button9 = GUICtrlCreateButton("About", 32, 72, 59, 25)
$Label1 = GUICtrlCreateLabel("Made by NegativeNrG, ", 16, 112, 171, 33)
$Progress1 = GUICtrlCreateProgress(8, 152, 286, 17)
GUICtrlSetColor(-1, 0x0D0000)
GUISetState(@SW_SHOW)
hotkeyset ("{END}", "open")
hotkeyset("{HOME}","play")
hotkeyset ("{PGUP","stop")


func stop()
soundplay("")
endfunc

func open()
$song = FileOpenDialog ("choose music", "", "musicfiles(*.mp3;*.wma;*.wav;*.wave;*.mid;*)",4)
Soundplay ($song)
endfunc

func play()
soundplay ($song)
endfunc


While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
   
Case $msg = $play
$read = IniReadsection("a.ini","playlist")
soundplay ($read)

Case $msg = $mute
Send ("{VOLUME_MUTE}")

Case $msg = $Button9
msgbox (0, "NegativeNrG's Media Player","Created by NegativeNrG.")

Case $msg = $unmute
Send ("{VOLUME_UP}")

Case $msg = $filemenu
msgbox (0, "NegativeNrG's Media Player", " Created by NegativeNrG, More updates coming soon")

Case $msg = $filexit
exit

Case $msg = $volup
send ("{VOLUME_UP}")

Case $msg = $voldown
send ("{VOLUME_DOWN}")

Case $msg = $helpmenu
msgbox (0,"Media Player Help", "hotkeys::END - Open      HOME - Play (This has a bug)      Page up - Stop")



Case $msg = $stop
soundplay("C:\stop.mp3")

Case $msg = $browse
$songs = FileOpenDialog ("choose music", "", "musicfiles(*.mp3;*.wma;*.wav;*.wave;*.mid;*)",4)
Soundplay ($songs)

Case $msg = $exit
exit 0


	Case Else
		;;;;;;;
	EndSelect
WEnd


