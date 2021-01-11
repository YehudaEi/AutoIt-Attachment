; AutoMagnifier by spyrorocks



#include <GUIConstants.au3>

$gui = GUICreate("AutoMagnifier", 192, 159, 193, 126)
$box0 = GUICtrlCreateLabel("", 0, 0, 32, 32)

$box1 = GUICtrlCreateLabel("", 32, 0, 32, 32)

$box2 = GUICtrlCreateLabel("", 64, 0, 32, 32)

$box3 = GUICtrlCreateLabel("", 96, 0, 32, 32)

$box4 = GUICtrlCreateLabel("", 128, 0, 32, 32)

$box5 = GUICtrlCreateLabel("", 160, 0, 32, 32)

$box6 = GUICtrlCreateLabel("", 0, 32, 32, 32)

$box7 = GUICtrlCreateLabel("", 32, 32, 32, 32)

$box8 = GUICtrlCreateLabel("", 64, 32, 32, 32)

$box9 = GUICtrlCreateLabel("", 96, 32, 32, 32)

$box10 = GUICtrlCreateLabel("", 128, 32, 32, 32)

$box11 = GUICtrlCreateLabel("", 160, 32, 32, 32)

$box12 = GUICtrlCreateLabel("", 0, 64, 32, 32)

$box13 = GUICtrlCreateLabel("", 32, 64, 32, 32)

$box14 = GUICtrlCreateLabel("", 64, 64, 32, 32)

$box15 = GUICtrlCreateLabel("", 96, 64, 32, 32)

$box16 = GUICtrlCreateLabel("", 128, 64, 32, 32)

$box17 = GUICtrlCreateLabel("", 160, 64, 32, 32)

$box18 = GUICtrlCreateLabel("", 0, 96, 32, 32)

$box19 = GUICtrlCreateLabel("", 32, 96, 32, 32)

$box20 = GUICtrlCreateLabel("", 64, 96, 32, 32)

$box21 = GUICtrlCreateLabel("", 96, 96, 32, 32)

$box22 = GUICtrlCreateLabel("", 128, 96, 32, 32)

$box23 = GUICtrlCreateLabel("", 160, 96, 32, 32)

$box24 = GUICtrlCreateLabel("", 0, 128, 32, 32)

$box25 = GUICtrlCreateLabel("", 32, 128, 32, 32)

$box26 = GUICtrlCreateLabel("", 64, 128, 32, 32)

$box27 = GUICtrlCreateLabel("", 96, 128, 32, 32)

$box28 = GUICtrlCreateLabel("", 128, 128, 32, 32)

$box29 = GUICtrlCreateLabel("", 160, 128, 32, 32)

GUISetState(@SW_SHOW)

### Koda GUI section end   ###
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch


	setcolors()

WEnd


func setcolors()
	$color = MouseGetPos ()

	GUICtrlSetBkColor ( $box14, PixelGetColor ( $color[0], $color[1]))
	GUICtrlSetBkColor ( $box13, PixelGetColor ( $color[0] - 1, $color[1]))
	GUICtrlSetBkColor ( $box12, PixelGetColor ( $color[0] - 2, $color[1]))
	GUICtrlSetBkColor ( $box15, PixelGetColor ( $color[0] + 1, $color[1]))
	GUICtrlSetBkColor ( $box16, PixelGetColor ( $color[0] + 2, $color[1]))
	GUICtrlSetBkColor ( $box17, PixelGetColor ( $color[0] + 3, $color[1]))

	GUICtrlSetBkColor ( $box8, PixelGetColor ( $color[0], $color[1] - 1))
	GUICtrlSetBkColor ( $box7, PixelGetColor ( $color[0] - 1, $color[1] - 1))
	GUICtrlSetBkColor ( $box6, PixelGetColor ( $color[0] - 2, $color[1] - 1))
	GUICtrlSetBkColor ( $box9, PixelGetColor ( $color[0] + 1, $color[1] - 1))
	GUICtrlSetBkColor ( $box10, PixelGetColor ( $color[0] + 2, $color[1] - 1))
	GUICtrlSetBkColor ( $box11, PixelGetColor ( $color[0] + 3, $color[1] - 1))

	GUICtrlSetBkColor ( $box2, PixelGetColor ( $color[0], $color[1] - 2))
	GUICtrlSetBkColor ( $box1, PixelGetColor ( $color[0] - 1, $color[1] - 2))
	GUICtrlSetBkColor ( $box0, PixelGetColor ( $color[0] - 2, $color[1] - 2))
	GUICtrlSetBkColor ( $box3, PixelGetColor ( $color[0] + 1, $color[1] - 2))
	GUICtrlSetBkColor ( $box4, PixelGetColor ( $color[0] + 2, $color[1] - 2))
	GUICtrlSetBkColor ( $box5, PixelGetColor ( $color[0] + 3, $color[1] - 2))


	GUICtrlSetBkColor ( $box20, PixelGetColor ( $color[0], $color[1] + 1))
	GUICtrlSetBkColor ( $box19, PixelGetColor ( $color[0] - 1, $color[1] + 1))
	GUICtrlSetBkColor ( $box18, PixelGetColor ( $color[0] - 2, $color[1] + 1))
	GUICtrlSetBkColor ( $box21, PixelGetColor ( $color[0] + 1, $color[1] + 1))
	GUICtrlSetBkColor ( $box22, PixelGetColor ( $color[0] + 2, $color[1] + 1))
	GUICtrlSetBkColor ( $box23, PixelGetColor ( $color[0] + 3, $color[1] + 1))


	GUICtrlSetBkColor ( $box26, PixelGetColor ( $color[0], $color[1] + 2))
	GUICtrlSetBkColor ( $box25, PixelGetColor ( $color[0] - 1, $color[1] + 2))
	GUICtrlSetBkColor ( $box24, PixelGetColor ( $color[0] - 2, $color[1] + 2))
	GUICtrlSetBkColor ( $box27, PixelGetColor ( $color[0] + 1, $color[1] + 2))
	GUICtrlSetBkColor ( $box28, PixelGetColor ( $color[0] + 2, $color[1] + 2))
	GUICtrlSetBkColor ( $box29, PixelGetColor ( $color[0] + 3, $color[1] + 2))
endfunc