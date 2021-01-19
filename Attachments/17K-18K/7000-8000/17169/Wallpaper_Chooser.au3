#include <GUIConstants.au3>
#Include <GuiList.au3>

$WallpaperMain = GUICreate("Wallpaper Selector", 350, 406)
$WallpaperList = GUICtrlCreateList("", 16, 208, 313, 149, $WS_VSCROLL)
$WallpaperPreview = GUICtrlCreatePic("", 50, 16, 257, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$About = GUICtrlCreateLabel("?", 339, 389, 15, 15)
$Browse = GUICtrlCreateButton("Browse", 24, 368, 70, 25, 0)
$Preview = GUICtrlCreateButton("Preview", 98, 368, 70, 25, 0)
$Save = GUICtrlCreateButton("Save", 172, 368, 70, 25, 0)
$Cancel = GUICtrlCreateButton("Cancel", 246, 368, 70, 25, 0)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Browse
			$SelectWP = FileOpenDialog("Please select an image(s) to add to the list.", @DesktopDir, "Images (*.jpg;*.bmp)", 1)
			_GUICtrlListAddItem($WallpaperList, $SelectWP)
			GUICtrlDelete($WallpaperPreview)
			$WallpaperPreview = GUICtrlCreatePic($SelectWP, 50, 16, 257, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
		Case $Preview
			GUICtrlDelete($WallpaperPreview)
			$NewPic = _GUICtrlListGetText($WallpaperList, _GUICtrlListSelectedIndex($WallpaperList))
			$WallpaperPreview = GUICtrlCreatePic($NewPic, 50, 16, 257, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
		Case $Save
			$GetPic = _GUICtrlListGetText($WallpaperList, _GUICtrlListSelectedIndex($WallpaperList))
			$Background = GUICtrlCreatePic($GetPic, 0, 0, 350, 406) ; Tweak this to your needs
		Case $Cancel
			GUIDelete($WallpaperMain)
			ExitLoop
		Case $About
			MsgBox(32, "About", "Wallpaper Selector" & @CRLF & "Made by alien13 -                       ")
	EndSwitch
WEnd