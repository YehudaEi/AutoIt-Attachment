#include <GUIConstants.au3>
#include <Date.au3>
#include <GuiEdit.au3>
#Include <ScreenCapture.au3>
#include <StaticConstants.au3>

; Script variables
Global $Script_name = "photographer"
Global $Script_version = "1"

; Window variables
Global $Mwin_width = 800
Global $Mwin_height = 550
Global $Mwin_handle
Global $Mwin_imagebox
Global $Mwin_imagebox_maxwidth = 780
Global $Mwin_imagebox_maxheight = 300
Global $Mwin_imagebox_xposition
Global $Mwin_imagebox_yposition
Global $Mwin_imagebox_info[5 + 1]
Global $Mwin_imagebox_label[5 + 1]

; Image variables
Global $Image_handle 
Global $Image_currentfile
Global $Image_checksum 
Global $Image_width
Global $Image_height 
Global $Image_count = 0

; Buttons
Global $Mwin_maxbuttons = 4
Global $Mwin_button[$Mwin_maxbuttons + 1]

; Misc variables
Global $Misc_exitscriptflag = 0

; Set the hotkey for taking photos and exiti
HotKeySet("{F1}",	"Hotkey_TakePhoto")
HotKeySet('{esc}',	"Hotkey_Escape")
Global $Keypress 

Opt("MouseCoordMode", 0)

; Main script
; -----------
CreateMainWindow()

Do
	CheckButtons()
	CheckCursor()
Until $Misc_exitscriptflag = 1

Exit

Func CreateMainWindow()
	
	; Create the main window
	
	$Mwin_handle = GuiCreate($Script_name & " v" & $Script_version, $Mwin_width, $Mwin_height)
	GUISetState(@SW_SHOW)
	
	; Create an area for displaying captured images
	$Mwin_imagebox = 	GUICtrlCreatePic("", 10, 10, 0, 0, $SS_SUNKEN)
	; Create info boxes to describe it
	$Mwin_imagebox_info[1] = GUICtrlCreateInput("", 			10, ($Mwin_imagebox_maxheight + 20), 	90, 20, $ES_READONLY)
	$Mwin_imagebox_label[1] = GUICtrlCreateLabel("Checksum", 	10, ($Mwin_imagebox_maxheight + 40), 	90, 20, $ES_READONLY)
	
	$Mwin_imagebox_info[2] = GUICtrlCreateInput("", 			110, ($Mwin_imagebox_maxheight + 20), 	40, 20, $ES_READONLY)
	$Mwin_imagebox_label[2] = GUICtrlCreateLabel("Width",		110, ($Mwin_imagebox_maxheight + 40), 	40, 20, $ES_READONLY)
	$Mwin_imagebox_info[3] = GUICtrlCreateInput("", 			160, ($Mwin_imagebox_maxheight + 20), 	40, 20, $ES_READONLY)
	$Mwin_imagebox_label[3] = GUICtrlCreateLabel("Height", 		160, ($Mwin_imagebox_maxheight + 40), 	40, 20, $ES_READONLY)
	$Mwin_imagebox_info[4] = GUICtrlCreateInput("", 			210, ($Mwin_imagebox_maxheight + 20), 	90, 20, $ES_READONLY)
	$Mwin_imagebox_label[4] = GUICtrlCreateLabel("Image file", 	210, ($Mwin_imagebox_maxheight + 40), 	90, 20, $ES_READONLY)
	$Mwin_imagebox_info[5] = GUICtrlCreateInput("", 			310, ($Mwin_imagebox_maxheight + 20), 	80, 20, $ES_READONLY)
	$Mwin_imagebox_label[5] = GUICtrlCreateLabel("Cursor", 		310, ($Mwin_imagebox_maxheight + 40), 	80, 20, $ES_READONLY)
	
; Create buttons
	$Mwin_button[1] =    GUICtrlCreateButton("Capture", 		10, ($Mwin_imagebox_maxheight + 70), 80, 20)
	
	Return "success"
	
EndFunc

Func CheckButtons()
	
	; Check the buttons
	$msg = GUIGetMsg()
	
	; React to mouse clicks
	Select
		
		Case $msg = $GUI_EVENT_CLOSE
			$Misc_exitscriptflag = 1
			Return "exit"
		Case $msg = $Mwin_button[1]
			CaptureImage()
	EndSelect

	Return "success"
	
EndFunc

Func CheckCursor()
	
	; If cursor is above the image, display the cursor position
	$position = MouseGetPos()
	
	; Correct for the window border
	$position[0] = $position[0] - 4
	$position[1] = $position[1] - 23
	
	If $position[0] >= $Mwin_imagebox_xposition AND $position[0] <= ($Mwin_imagebox_xposition + $Image_width - 1) AND $position[1] >= $Mwin_imagebox_yposition AND $position[1] <= ($Mwin_imagebox_yposition + $Image_height - 1) Then 
		; The mouse is over the image
		$xpos = $position[0] - $Mwin_imagebox_xposition + 1
		$ypos = $position[1] - $Mwin_imagebox_yposition + 1
		GUICtrlSetData($Mwin_imagebox_info[5], $xpos & "x" & $ypos & "(" & $Mwin_imagebox_xposition & "x" & $Mwin_imagebox_yposition & ")")
	Else
		GUICtrlSetData($Mwin_imagebox_info[5], "")
	EndIf
	
	Return "success"
	
EndFunc

Func CaptureImage()
	
	Opt("MouseCoordMode", 1)

	$Keypress = ""
	Do
		$xy = MouseGetPos()
		$currentpixel = PixelGetColor($xy[0],$xy[1])
		ToolTip("Click the top-left corner" & @LF & "Pixel color = " & $currentpixel & @LF & "Coords " & $xy[0] & "x" & $xy[1])
		Sleep(100)
	Until $Keypress <> ""
	
	If $Keypress = "escape" Then 
		Opt("MouseCoordMode", 0)
		Return "fail"
	Else	
		$top_x = $xy[0]
		$top_y = $xy[1]
	EndIf
	
	$Keypress = ""
	Do
		$xy = MouseGetPos()
		$currentpixel = PixelGetColor($xy[0],$xy[1])
		ToolTip("Click the bottom-right corner" & @LF & "Pixel color = " & $currentpixel & @LF & "Coords " & $xy[0] & "x" & $xy[1])
		Sleep(100)
	Until $Keypress <> ""

	If $Keypress = "escape" Then 
		Return "fail"
	Else	
		$bottom_x = $xy[0]
		$bottom_y = $xy[1]
		$width = $bottom_x - $top_x + 1
		$height = $bottom_y - $top_y + 1
	EndIf
	
	If $width > $Mwin_imagebox_maxwidth OR $height > $Mwin_imagebox_maxheight Then 
		ToolTip("Image is too big!" & @LF & "Image: " & $width & "x" & $height & ", max: " & $Mwin_imagebox_maxwidth & "x" & $Mwin_imagebox_maxheight)
		Sleep(2000)
		ToolTip("")
	Else
		$Image_count = $Image_count + 1
		$Image_currentfile = "image-" & $Image_count & ".bmp"
		$Image_handle = _ScreenCapture_Capture($Image_currentfile, $top_x, $top_y, $bottom_x, $bottom_y)
		$Image_checksum = PixelChecksum($top_x, $top_y, $bottom_x, $bottom_y)
		$Image_width = ($bottom_x - $top_x + 1)
		$Image_height = ($bottom_y - $top_y + 1)
		; Show the image in the main window
		RefreshImage()		
			
		ToolTip("Captured " & $Image_width & "x" & $Image_height & " image" & @LF & "Checksum " & $Image_checksum)
		Sleep(2000)
		ToolTip("")
	EndIf

	Opt("MouseCoordMode", 0)
	
	Return "success"
	
EndFunc

Func RefreshImage()

	Local $xposition, $yposition
	
	$Mwin_imagebox_xposition = 10 + Floor(($Mwin_imagebox_maxwidth - $Image_width) / 2)
	$Mwin_imagebox_yposition = 10 + Floor(($Mwin_imagebox_maxheight - $Image_height) / 2)
	GUICtrlSetPos($Mwin_imagebox, 0, 0)
	GUICtrlSetPos($Mwin_imagebox, $Mwin_imagebox_xposition, $Mwin_imagebox_yposition)	
	GUICtrlSetImage($Mwin_imagebox, $Image_currentfile)

	GUICtrlSetData($Mwin_imagebox_info[1], $Image_checksum)
	GUICtrlSetData($Mwin_imagebox_info[2], $Image_width)
	GUICtrlSetData($Mwin_imagebox_info[3], $Image_height)
	GUICtrlSetData($Mwin_imagebox_info[4], $Image_currentfile)
	
EndFunc

Func Hotkey_TakePhoto()
	
	; Whenever the hotkey is pressed, sets the global variable $Keypress
	$Keypress = "takephoto"
	
EndFunc

Func Hotkey_Escape()
	
	; Whenever the hotkey is pressed, sets the global variable $Keypress
	$Keypress = "escape"
	
EndFunc

			