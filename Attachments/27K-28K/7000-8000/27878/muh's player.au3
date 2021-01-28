#include <GUIConstants.au3>
#include <Sound.au3>
#NoTrayIcon



#Region ### START Koda GUI section ### Form=c:\documents and settings\administrator.gaco-052fa671a0\my documents\koda\forms\mp3 player.kxf
Global $Form1 = GUICreate("muh's mp3 player", 366, 315, 372, 229)
GUISetBkColor(0xA6CAF0)
$Button1 = GUICtrlCreateButton("Play", 192, 24, 57, 33, 0)
$Button2 = GUICtrlCreateButton("Stop", 296, 24, 57, 33, 0)
$Button3 = GUICtrlCreateButton("Player repeat mode", 224, 80, 89, 41, $BS_MULTILINE)
$Slider1 = GUICtrlCreateSlider(184, 168, 169, 25)
GUICtrlsetBkColor(-1, 0xA6CAF0)
GUICtrlSetData(-1, 100)
$Label1 = GUICtrlCreateLabel("Volume", 240, 144, 58, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Pic1 = GUICtrlCreatePic(@ScriptDir & "\pic.jpg", 8, 8, 169, 241, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Label2 = GUICtrlCreateLabel("File selected: ", 8, 264, 387, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$MenuItem3 = GUICtrlCreateMenu("&File")
$MenuItem4 = GUICtrlCreateMenuItem("Load file", $MenuItem3)
$MenuItem2 = GUICtrlCreateMenu("&Settings")
$MenuItem5 = GUICtrlCreateMenuItem("Exit", $MenuItem2)
$MenuItem1 = GUICtrlCreateMenu("&Help")
$MenuItem6 = GUICtrlCreateMenuItem("About us", $MenuItem1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



Global $snd=""
Global $rpd=True; true - repeat song, false - dont repeat
Global $poss[21]

SoundSetWaveVolume(100)
Global $fp="a"
While 1
	$nMsg = GUIGetMsg()
	$pos=_SoundPos($snd, 2) ;_SoundLength didn't work for me so here I check if the song has finished to play it again
	$poss[1]=$poss[2]
	$poss[2]=$poss[3]
	$poss[3]=$poss[4]
	$poss[4]=$poss[5]
	$poss[5]=$poss[6]
	$poss[6]=$poss[7]
	$poss[7]=$poss[8]
	$poss[8]=$poss[9]
	$poss[9]=$poss[10]
	$poss[10]=$poss[11]
	$poss[11]=$poss[12]
	$poss[12]=$poss[13]
	$poss[13]=$poss[14]
	$poss[14]=$poss[15]
	$poss[15]=$poss[16]
	$poss[16]=$poss[17]
	$poss[17]=$poss[18]
	$poss[18]=$poss[19]
	$poss[19]=$poss[20]
	$poss[20]=$pos
	If $pos>0 And $poss[1]==$poss[2] And $poss[1]==$poss[3] And $poss[1]==$poss[4] And $poss[1]==$poss[5] And $poss[1]==$poss[6] And $poss[1]==$poss[7] And $poss[1]==$poss[8] And $poss[1]==$poss[9] And $poss[1]==$poss[10] And $poss[1]==$poss[11] And $poss[1]==$poss[12] And $poss[1]==$poss[13] And $poss[1]==$poss[14] And $poss[1]==$poss[15] And $poss[1]==$poss[16] And $poss[1]==$poss[17] And $poss[1]==$poss[18] And $poss[1]==$poss[19] And $poss[1]==$poss[20] Then
	  _SoundStop($snd)
	  If $rpd==True Then
		  _SoundPlay($snd)
		EndIf
	EndIf
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_SoundClose($snd)
			Exit
		Case $MenuItem4
			$fp=FileOpenDialog("Music file", @ScriptDir, "MP3 Files (*.mp3)")
			$snd=_SoundOpen($fp)
			GUICtrlSetData($Label2, "File selected: " & $fp)
		Case $Button1
			_SoundPlay($snd)
		Case $Button2
			_SoundStop($snd)
		Case $Slider1
			$vm=GUICtrlRead($Slider1)
			SoundSetWaveVolume($vm)
		Case $MenuItem5
			_SoundStop($snd)
			Exit
		Case $MenuItem6
			MsgBox(0, "About us", "This is my first MP3 player yeeeeeey")
		Case $Button3
			$rpd=Not $rpd
		
	EndSwitch
WEnd
