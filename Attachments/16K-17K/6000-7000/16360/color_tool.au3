#include <GUIconstants.au3>
#NoTrayIcon

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")

GUICreate("Pixel Color", 180, 305, -1, -1, -1, $WS_EX_TOPMOST)

GUICtrlCreateGroup(" Mouse Coordinates ", 10, 10, 160, 50)
GUICtrlCreateLabel("X:", 25, 33, 15, 15)
$MousePosX=GUICtrlCreateInput("", 40, 30, 40, 20, $ES_READONLY)
GUICtrlCreateLabel("Y:", 90, 33, 15, 15)
$MousePosY=GUICtrlCreateInput("", 105, 30, 40, 20, $ES_READONLY)

GUICtrlCreateGroup(" Color Data ", 10, 70, 160, 110)
GUICtrlCreateLabel("Decimal:", 25, 93, 50, 15)
$PixelColor=GUICtrlCreateInput("", 80, 90, 70, 20, $ES_READONLY)
GUICtrlCreateLabel("Hex:", 25, 123, 50, 15)
$hexColor=GUICtrlCreateInput("", 80, 120, 70, 20,$ES_READONLY)
GUICtrlCreateLabel("Color:", 25, 153, 50, 15)
$MostrarColor=GUICtrlCreateLabel("", 80, 150, 70, 20,$ES_READONLY)

GUICtrlCreateGroup(" Coordinate Options ", 10, 190, 160, 90)
$RB_Full = GUICtrlCreateRadio(" Full Screen", 25, 210, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$RB_Window = GUICtrlCreateRadio(" Active Window", 25, 230, 100, 20)
GUICtrlCreateLabel("Window:", 25, 255, 50, 15)
$Window = GUICtrlCreateLabel("(full screen)", 75, 255, 70, 15)



GUICtrlCreateLabel("Press PAUSE to freeze/unfreeze.", 0, 285 ,180, 15, $SS_CENTER)
GUICtrlSetColor(-1,0x00808080)


GUISetState()
While 1
    $msg=GUIGetMsg()
    data()
    Select
		Case $msg=$GUI_EVENT_CLOSE
            $loop=0
            Exit
    EndSelect
WEnd


Func data()
    While 1
        $msg=GUIGetMsg()
        Select
            Case $msg=$GUI_EVENT_CLOSE
                Exit
		EndSelect
        Sleep(25)
		If GUICtrlRead($RB_Full) = $GUI_CHECKED Then
			Opt("MouseCoordMode", 1)
			Opt("PixelCoordMode", 1)
			GUICtrlSetData($Window, "(full screen)")
			$pos=MouseGetPos()
			$color=PixelGetColor($pos[0],$pos[1])
			GUICtrlSetData($MousePosX, $pos[0])
			GUICtrlSetData($MousePosY, $pos[1])
			GUICtrlSetData($PixelColor,$color)
			$HEX6=StringRight(Hex($color),6)
			GUICtrlSetData($hexColor,"0x"&$HEX6)
			GUICtrlSetBkColor($MostrarColor,"0x"&Hex($color))
		Else
			Opt("MouseCoordMode", 0)
			Opt("PixelCoordMode", 0)
			GUICtrlSetData($Window, WinGetTitle(""))
			$win = WinGetPos("")
			$pos=MouseGetPos()
			If $pos[0] >= 0 And $pos[0] <= $win[2] and $pos[1] >= 0 And $pos[1] <= $win[3] Then
				$color=PixelGetColor($pos[0],$pos[1])
				GUICtrlSetData($MousePosX, $pos[0])
				GUICtrlSetData($MousePosY, $pos[1])
				GUICtrlSetData($PixelColor,$color)
				$HEX6=StringRight(Hex($color),6)
				GUICtrlSetData($hexColor,"0x"&$HEX6)
				GUICtrlSetBkColor($MostrarColor,"0x"&Hex($color))
			Else
				GUICtrlSetData($MousePosX, "----")
				GUICtrlSetData($MousePosY, "----")
				GUICtrlSetData($PixelColor,"")
				GUICtrlSetData($hexColor,"")
			EndIf
		EndIf
    WEnd
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(10)
		$msg=GUIGetMsg()
        Select
            Case $msg=$GUI_EVENT_CLOSE
                Exit
		EndSelect
    WEnd
EndFunc