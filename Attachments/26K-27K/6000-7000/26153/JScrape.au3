 
; ============================================================================
; 							  	 JScrape v0.2
;   							 14th May 2009
; 							Copyright 2009, JLab
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; ============================================================================

; This script is only half-finished
; Brief instructions
; 1 Use "capture image" to capture an image
; 2 Use "target colour" to choose the text colour to process
; 3 Ignore "enlarge image" and "save details", not implemented yet
; 4 Use "scrape text" to search the image for characters
; 5 Use "up", "down" to see the characters found, and "delete" to remove anything unusable
; 6 For complete characters, enter the symbol in the "Enter char" box - if you see the letter capital J, enter that letter
; 7 Enter or delete all characters until all "unknowns" become "knowns"
; 8 Ignore the "save" button and the remaining buttons - not implemented yet

#include <GUIConstants.au3>
#include <Date.au3>
#include <GuiEdit.au3>
#Include <ScreenCapture.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>	
#include <WindowsConstants.au3>
#include <ButtonConstants.au3> 	

; Script variables
Global $Script_name = "JScrape"
Global $Script_version = "0.1"

; Window variables

; Main window
Global $Mwin_width = 800
Global $Mwin_height = 525
Global $Mwin_handle
; Image box
Global $Mwin_imagebox
Global $Mwin_imagebox_maxwidth = 780
Global $Mwin_imagebox_maxheight = 265
Global $Mwin_imagebox_xposition
Global $Mwin_imagebox_yposition
Global $Mwin_imagebox_info[5 + 1]
Global $Mwin_imagebox_label[5 + 1]
; Char box
Global $Mwin_charbox
; Buttons
Global $Mwin_maxbuttons = 32
Global $Mwin_button[$Mwin_maxbuttons + 1]
; Boxes
Global $Mwin_maxboxes = 32
Global $Mwin_info[$Mwin_maxboxes + 1]
Global $Mwin_label[$Mwin_maxboxes + 1]
; Hidden button to make the input boxes work
Global $Mwin_hiddenbutton1, $Mwin_hiddenbutton2

; Image variables
Global $Image_handle 
Global $Image_filecount = 0
Global $Image_currentfile
Global $Image_checksum 
Global $Image_topx_absolute, $Image_topy_absolute
Global $Image_topx_window, $Image_topy_window
Global $Image_topx_client, $Image_topy_client
Global $Image_bottomx_absolute, $Image_bottomy_absolute
Global $Image_bottomx_window, $Image_bottomy_window
Global $Image_bottomx_client, $Image_bottomy_client
Global $Image_width, $Image_height

; Target text colour variables 
Global $Pixel_target

; The character array
Global $Char_maxwidth = 16
Global $Char_maxheight = 16
Global $Char_maxchars = 1024
Global $Char_array[$Char_maxchars + 1][$Char_maxheight + 1]
Global $Char_array_chr[$Char_maxchars + 1]
Global $Char_array_width[$Char_maxchars + 1]
Global $Char_array_height[$Char_maxchars + 1]
Global $Char_array_xpos[$Char_maxchars + 1]
Global $Char_array_ypos[$Char_maxchars + 1]

Global $Char_foundstring
Global $Char_foundstringextra
Global $Char_notfoundstring

; The current char number show in the char box
Global $Char_current = 0

; Misc variables
Global $Misc_exitscriptflag = 0
Global $checkflag = 0

; things that have been done
Global $Flag_imagecaptured = 0
Global $Flag_pixelcolourchosen = 0

; Set the hotkey for taking photos and exiti
HotKeySet("{F1}",	"Hotkey_TakePhoto")
HotKeySet('{esc}',	"Hotkey_Escape")
Global $Hotkey_press 

; Main script
; -----------

; Set up the window
CreateMainWindow()

; The main loop
Do
	CheckButtons()
	CheckCursor()
Until $Misc_exitscriptflag = 1

; Clean up windows API by deleting any bitmap handles
If $Image_handle <> "" Then 
	_WinAPI_DeleteObject($Image_handle)
EndIf
	
; Exit the script
Exit

; Window functions

Func CreateMainWindow()	; Check done
	
	; Create the main window
	
	$Mwin_handle = GuiCreate($Script_name & " v" & $Script_version, $Mwin_width, $Mwin_height)
	GUISetState(@SW_SHOW)
	
	; Create the image box
	$Mwin_imagebox = 	GUICtrlCreatePic("", 10, 10, 0, 0)
	
	; Create the left hand side of the screen
	$Mwin_button[1] =   GUICtrlCreateButton("Capture Image",10, ($Mwin_imagebox_maxheight + 20), 	90, 32)
	$Mwin_button[2] =   GUICtrlCreateButton("Enlarge Image",10, ($Mwin_imagebox_maxheight + 60), 	90, 32)
	$Mwin_button[3] =   GUICtrlCreateButton("Target colour",10, ($Mwin_imagebox_maxheight + 100),	90, 32)
	$Mwin_button[4] =   GUICtrlCreateButton("Save details", 10, ($Mwin_imagebox_maxheight + 140),	90, 32)
	$Mwin_button[5] =   GUICtrlCreateButton("Scrape Text", 	10, ($Mwin_imagebox_maxheight + 180),	90, 32)
	
	$Mwin_info[1] = GUICtrlCreateInput("", 					110, ($Mwin_imagebox_maxheight + 20), 	50, 20, $ES_READONLY)
	$Mwin_label[1] = GUICtrlCreateLabel("Width", 			110, ($Mwin_imagebox_maxheight + 40), 	50, 20, $ES_READONLY)
	$Mwin_info[2] = GUICtrlCreateInput("", 					170, ($Mwin_imagebox_maxheight + 20), 	50, 20, $ES_READONLY)
	$Mwin_label[2] = GUICtrlCreateLabel("Height", 			170, ($Mwin_imagebox_maxheight + 40), 	50, 20, $ES_READONLY)
	$Mwin_info[3] = GUICtrlCreateInput("", 					230, ($Mwin_imagebox_maxheight + 20), 	70, 20, $ES_READONLY)
	$Mwin_label[3] = GUICtrlCreateLabel("Cursor", 			230, ($Mwin_imagebox_maxheight + 40), 	70, 20, $ES_READONLY)
	
	$Mwin_info[4] = GUICtrlCreateInput("", 					110, ($Mwin_imagebox_maxheight + 60), 	70, 20, $ES_READONLY)
	$Mwin_label[4] = GUICtrlCreateLabel("Absolute XY",		110, ($Mwin_imagebox_maxheight + 80), 	70, 20, $ES_READONLY)
	$Mwin_info[5] = GUICtrlCreateInput("", 					190, ($Mwin_imagebox_maxheight + 60), 	50, 20, $ES_READONLY)
	$Mwin_label[5] = GUICtrlCreateLabel("Window", 			190, ($Mwin_imagebox_maxheight + 80), 	50, 20, $ES_READONLY)
	$Mwin_info[6] = GUICtrlCreateInput("", 					250, ($Mwin_imagebox_maxheight + 60), 	50, 20, $ES_READONLY)
	$Mwin_label[6] = GUICtrlCreateLabel("Client", 			250, ($Mwin_imagebox_maxheight + 80), 	50, 20, $ES_READONLY)
	
	$Mwin_info[7] = GUICtrlCreateGraphic(					110, ($Mwin_imagebox_maxheight + 100), 	90, 20)
	GuiCtrlSetColor($Mwin_info[7], 0x000000)
	GUICtrlSetBkColor($Mwin_info[7], 0x000000)	
	$Mwin_label[7] = GUICtrlCreateLabel("", 				110, ($Mwin_imagebox_maxheight + 120), 	90, 20, $ES_READONLY)
	$Mwin_info[8] = GUICtrlCreateInput("", 					210, ($Mwin_imagebox_maxheight + 100), 	90, 20, $ES_READONLY)
	$Mwin_label[8] = GUICtrlCreateLabel("Checksum", 		210, ($Mwin_imagebox_maxheight + 120), 	90, 20, $ES_READONLY)
	
	$Mwin_info[9] = GUICtrlCreateInput("", 					110, ($Mwin_imagebox_maxheight + 140), 	90, 20)
	GUICtrlSetState($Mwin_info[9], $GUI_DISABLE)
	$Mwin_hiddenbutton1 = GUICtrlCreateButton("", 			10, ($Mwin_height - 90), 10, 10, $BS_DEFPUSHBUTTON)
	GUICtrlSetState(-1, $GUI_HIDE)	
	$Mwin_label[9] = GUICtrlCreateLabel("Image name", 		110, ($Mwin_imagebox_maxheight + 160), 	90, 20, $ES_READONLY)
	$Mwin_info[10] = GUICtrlCreateInput("", 				210, ($Mwin_imagebox_maxheight + 140), 	90, 20, $ES_READONLY)
	$Mwin_label[10] = GUICtrlCreateLabel("Image file", 		210, ($Mwin_imagebox_maxheight + 160), 	90, 20, $ES_READONLY)
	
	$Mwin_info[11] = GUICtrlCreateProgress( 				110, ($Mwin_imagebox_maxheight + 180), 	90, 20)
	$Mwin_label[11] = GUICtrlCreateLabel("Scrape characters",110,($Mwin_imagebox_maxheight + 200), 	90, 20, $ES_READONLY)
	$Mwin_info[12] = GUICtrlCreateProgress(					210, ($Mwin_imagebox_maxheight + 180), 	90, 20)
	$Mwin_label[12] = GUICtrlCreateLabel("Delete duplicates",210,($Mwin_imagebox_maxheight + 200), 	90, 20, $ES_READONLY)
	
	; Create the character box
	$Mwin_charbox = GUICtrlCreateEdit("", 310, ($Mwin_imagebox_maxheight + 20), 200, 192, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL))
	GUICtrlSetColor($Mwin_charbox, 0xFFFFFF)
	GUICtrlSetBkColor($Mwin_charbox, 0x000000)

	; Create the right hand side of the screen
	$Mwin_button[11] =   GUICtrlCreateButton("Up",			520, ($Mwin_imagebox_maxheight + 20), 	90, 32)
	$Mwin_button[12] =   GUICtrlCreateButton("Down",		520, ($Mwin_imagebox_maxheight + 60), 	90, 32)
	$Mwin_button[13] =   GUICtrlCreateButton("Splice",		520, ($Mwin_imagebox_maxheight + 100),	90, 32)
	$Mwin_button[14] =   GUICtrlCreateButton("Delete",		520, ($Mwin_imagebox_maxheight + 140),	90, 32)
	$Mwin_button[15] =   GUICtrlCreateButton("Size sort",	620, ($Mwin_imagebox_maxheight + 140),	80, 32)
	$Mwin_button[16] =   GUICtrlCreateButton("ASCII sort",	710, ($Mwin_imagebox_maxheight + 140),	80, 32)
	$Mwin_button[17] =   GUICtrlCreateButton("Undo", 		520, ($Mwin_imagebox_maxheight + 180),	90, 32)
	$Mwin_button[18] =   GUICtrlCreateButton("Undo all", 	620, ($Mwin_imagebox_maxheight + 180),	80, 32)
	$Mwin_button[19] =   GUICtrlCreateButton("Save", 		710, ($Mwin_imagebox_maxheight + 180),	80, 32)
	
	$Mwin_info[14] = GUICtrlCreateInput("", 				620, ($Mwin_imagebox_maxheight + 20),   70, 20)
	GUICtrlSetState($Mwin_info[14], $GUI_DISABLE)
	$Mwin_hiddenbutton2 = GUICtrlCreateButton("", 			10, ($Mwin_height - 50), 10, 10, $BS_DEFPUSHBUTTON)
	GUICtrlSetState(-1, $GUI_HIDE)	
	$Mwin_label[14] = GUICtrlCreateLabel("Enter char",		620, ($Mwin_imagebox_maxheight + 40), 	70, 20, $ES_READONLY)
	$Mwin_info[15] = GUICtrlCreateInput("", 				700, ($Mwin_imagebox_maxheight + 20), 	40, 20, $ES_READONLY)
	$Mwin_label[15] = GUICtrlCreateLabel("Symbol",			700, ($Mwin_imagebox_maxheight + 40), 	40, 20, $ES_READONLY)
	$Mwin_info[16] = GUICtrlCreateInput("", 				750, ($Mwin_imagebox_maxheight + 20), 	40, 20, $ES_READONLY)
	$Mwin_label[16] = GUICtrlCreateLabel("Char #",			750, ($Mwin_imagebox_maxheight + 40), 	40, 20, $ES_READONLY)	
	
	$Mwin_info[17] = GUICtrlCreateInput("", 				620, ($Mwin_imagebox_maxheight + 60), 	50, 20, $ES_READONLY)
	$Mwin_label[17] = GUICtrlCreateLabel("Known",			620, ($Mwin_imagebox_maxheight + 80), 	50, 20, $ES_READONLY)	
	$Mwin_info[18] = GUICtrlCreateInput("", 				680, ($Mwin_imagebox_maxheight + 60), 	50, 20, $ES_READONLY)
	$Mwin_label[18] = GUICtrlCreateLabel("Unknown",			680, ($Mwin_imagebox_maxheight + 80), 	50, 20, $ES_READONLY)
	$Mwin_info[19] = GUICtrlCreateInput("", 				740, ($Mwin_imagebox_maxheight + 60), 	50, 20, $ES_READONLY)
	$Mwin_label[19] = GUICtrlCreateLabel("Total",			740, ($Mwin_imagebox_maxheight + 80), 	50, 20, $ES_READONLY)	

	$Mwin_info[20] = GUICtrlCreateInput("", 				620, ($Mwin_imagebox_maxheight + 100), 	35, 20, $ES_READONLY)
	$Mwin_label[20] = GUICtrlCreateLabel("Width",			620, ($Mwin_imagebox_maxheight + 120), 	35, 20, $ES_READONLY)
	$Mwin_info[21] = GUICtrlCreateInput("", 				665, ($Mwin_imagebox_maxheight + 100), 	35, 20, $ES_READONLY)
	$Mwin_label[21] = GUICtrlCreateLabel("Height",			665, ($Mwin_imagebox_maxheight + 120), 	35, 20, $ES_READONLY)
	$Mwin_info[22] = GUICtrlCreateInput("", 				710, ($Mwin_imagebox_maxheight + 100), 	35, 20, $ES_READONLY)
	$Mwin_label[22] = GUICtrlCreateLabel("XPos",			710, ($Mwin_imagebox_maxheight + 120), 	35, 20, $ES_READONLY)
	$Mwin_info[23] = GUICtrlCreateInput("", 				755, ($Mwin_imagebox_maxheight + 100), 	35, 20, $ES_READONLY)
	$Mwin_label[23] = GUICtrlCreateLabel("YPos",			755, ($Mwin_imagebox_maxheight + 120), 	35, 20, $ES_READONLY)	

	$Mwin_info[31] = GUICtrlCreateInput("", 				10, ($Mwin_imagebox_maxheight + 220),  385, 20, $ES_READONLY)
	$Mwin_label[31] = GUICtrlCreateLabel("Chars not found",	10, ($Mwin_imagebox_maxheight + 240),  385, 20, $ES_READONLY)
	
	$Mwin_info[32] = GUICtrlCreateInput("", 				405, ($Mwin_imagebox_maxheight + 220), 385, 20, $ES_READONLY)
	$Mwin_label[32] = GUICtrlCreateLabel("Chars found",		405, ($Mwin_imagebox_maxheight + 240), 385, 20, $ES_READONLY)
	
	Return "success"
	
EndFunc

Func CheckButtons()		; Check done
	
	Local $msg
	
	; Check the buttons
	$msg = GUIGetMsg()
	
	If 	$msg = $GUI_EVENT_CLOSE Then 
		$Misc_exitscriptflag = 1
		Return "exit"
		
	ElseIf $Flag_imagecaptured = 0 OR $Flag_pixelcolourchosen = 0 Then 
		
		; React to button clicks
		Select
			
			Case $msg = $Mwin_button[1]
				CaptureImage()	
			Case $msg = $Mwin_button[3]
				CaptureColour()
		EndSelect			
			
	ElseIf $Flag_imagecaptured = 1 AND $Flag_pixelcolourchosen = 1 Then 
			
		; React to button clicks
		Select
			
			Case $msg = $Mwin_button[5]
				ScrapeText()
			Case $msg = $Mwin_button[11]
				MoveUpChar()
			Case $msg = $Mwin_button[12]
				MoveDownChar()			
			Case $msg = $Mwin_button[14]
				DeleteChar()
			Case $msg = $Mwin_hiddenbutton2
				EnterChar(GUICtrlRead($Mwin_info[14]))
		EndSelect
	EndIf
			
	Return "success"
	
EndFunc

Func CheckCursor()		; Check done
	
	Local $oldmode, $position, $xpos, $ypos
	
	; Set default mode, but remember the old one
	$oldmode = Opt("MouseCoordMode")
	Opt("MouseCoordMode", 2)		; Use the client window
	
	; If cursor is above the image, display the cursor position
	$position = MouseGetPos()
	If $position[0] >= $Mwin_imagebox_xposition AND $position[0] <= ($Mwin_imagebox_xposition + $Image_width - 1) AND $position[1] >= $Mwin_imagebox_yposition AND $position[1] <= ($Mwin_imagebox_yposition + $Image_height - 1) Then 
		; The mouse is over the image, so report its position
		$xpos = $position[0] - $Mwin_imagebox_xposition + 1
		$ypos = $position[1] - $Mwin_imagebox_yposition + 1
		GUICtrlSetData($Mwin_info[3], $xpos & "x" & $ypos)
	Else
		GUICtrlSetData($Mwin_info[3], "")
	EndIf

	; Reset default mode
	Opt("MouseCoordMode", $oldmode)		; Use the client window
	
	Return "success"
	
EndFunc

; Image capture functions

Func CaptureImage()		; Check done
	
	Local $xy_window, $xy_client, $xy_absolute, $currentpixel, $text
	Local $exitloopflag 
	
	Local $region_topx_absolute, $region_topx_window, $region_topx_client
	Local $region_topy_absolute, $region_topy_window, $region_topy_client
	Local $region_bottomx_absolute, $region_bottomx_window, $region_bottomx_client
	Local $region_bottomy_absolute, $region_bottomy_window, $region_bottomy_client
	Local $region_width, $region_height
	
	; Default mode
	Opt("MouseCoordMode", 1)		; Use the whole screen
	Opt("PixelCoordMode", 1)		; Use the whole screen
	
	; Search for images in a loop until the escape hotkey is pressed, or an image within the maximum
	; size allowed is selected
	Do
		
		$Hotkey_press = ""
		Do
			; Find the mouse's coordinates in the active window
			Opt("MouseCoordMode", 0)
			$xy_window = MouseGetPos()
			; Find the mouse's coordinates in the client window
			Opt("MouseCoordMode", 2)
			$xy_client = MouseGetPos()
			; Find the mouse's absolute coordinates
			Opt("MouseCoordMode", 1)
			$xy_absolute = MouseGetPos()
			; Find the current pixel, using whole-screen coordinates
			$currentpixel = PixelGetColor($xy_absolute[0],$xy_absolute[1])
			$text = "Find the top-left corner" & @LF & " and press F1 (ESC to quit)" & @LF
			$text = $text & "Pixel color = " & $currentpixel & @LF
			$text = $text & "Absolute coords = " & $xy_absolute[0] & "x" & $xy_absolute[1] & @LF
			$text = $text & "Window coords = " & $xy_window[0] & "x" & $xy_window[1] & @LF
			$text = $text & "Client coords = " & $xy_client[0] & "x" & $xy_client[1]
			ToolTip($text)
			Sleep(100)
		Until $Hotkey_press <> ""
		
		If $Hotkey_press = "escape" Then 
			ToolTip("")
			Return "fail"
		Else	
			; Remember the location of the mouse when the hotkey was pressed
			$region_topx_absolute = $xy_absolute[0]
			$region_topy_absolute = $xy_absolute[1]
			$region_topx_window = $xy_window[0]
			$region_topy_window = $xy_window[1]
			$region_topx_client = $xy_client[0]
			$region_topy_client = $xy_client[1]			
		EndIf
		
		$Hotkey_press = ""
		Do
			; Find the mouse's coordinates in the active window
			Opt("MouseCoordMode", 0)
			$xy_window = MouseGetPos()
			; Find the mouse's coordinates in the client window
			Opt("MouseCoordMode", 2)
			$xy_client = MouseGetPos()
			; Find the mouse's absolute coordinates
			Opt("MouseCoordMode", 1)
			$xy_absolute = MouseGetPos()
			; Find the current pixel, using whole-screen coordinates
			$currentpixel = PixelGetColor($xy_absolute[0],$xy_absolute[1])
			$text = "Find the bottom-right corner" & @LF & " and press F1 (ESC to quit)" & @LF
			$text = $text & "Pixel color = " & $currentpixel & @LF
			$text = $text & "Absolute coords = " & $xy_absolute[0] & "x" & $xy_absolute[1] & @LF
			$text = $text & "Window coords = " & $xy_window[0] & "x" & $xy_window[1] & @LF
			$text = $text & "Client coords = " & $xy_client[0] & "x" & $xy_client[1]
			ToolTip($text)
			Sleep(100)
		Until $Hotkey_press <> ""

		If $Hotkey_press = "escape" Then 
			ToolTip("")
			Return "fail"
		Else	
			; Remember the location of the mouse when the hotkey was pressed
			$region_bottomx_absolute = $xy_absolute[0]
			$region_bottomy_absolute = $xy_absolute[1]
			$region_bottomx_window = $xy_window[0]
			$region_bottomy_window = $xy_window[1]
			$region_bottomx_client = $xy_client[0]
			$region_bottomy_client = $xy_client[1]			
		EndIf

		; Check the image isn't too big
;		$region_width = $region_bottomx_absolute - $region_topx_absolute + 1
;		$region_height = $region_bottomy_absolute - $region_topy_absolute + 1
		$region_width = $region_bottomx_absolute - $region_topx_absolute 
		$region_height = $region_bottomy_absolute - $region_topy_absolute
		If $region_width > $Mwin_imagebox_maxwidth OR $region_height > $Mwin_imagebox_maxheight Then 
			ToolTip("Image is too big!" & @LF & "Image: " & $region_width & "x" & $region_height & ", max: " & $Mwin_imagebox_maxwidth & "x" & $Mwin_imagebox_maxheight)
			Sleep(2000)
		Else
			$exitloopflag = 1
		EndIf
	
	; If the image was too big, try again
	Until $exitloopflag = 1
	
	; Before capturing the image, keep windows tidy by deleting the old image handle
	If $Image_handle <> "" Then 
		_WinAPI_DeleteObject($Image_handle)
	EndIf

	; Capture the image
	$Image_handle = _ScreenCapture_Capture("", $region_topx_absolute, $region_topy_absolute, $region_bottomx_absolute, $region_bottomy_absolute, False)
	
	; Save the image as a file
	$Image_filecount = $Image_filecount + 1
	$Image_currentfile = "image-" & $Image_filecount & ".bmp"
	_ScreenCapture_SaveImage($Image_currentfile, $Image_handle)
	
	; Remember the image's details in global variables
	$Image_checksum = PixelChecksum($region_topx_absolute, $region_topy_absolute, $region_bottomx_absolute, $region_bottomy_absolute)
	$image_topx_absolute = $region_topx_absolute
	$image_topy_absolute = $region_topy_absolute
	$image_topx_window = $region_topx_window
	$image_topy_window = $region_topy_window
	$image_topx_client = $region_topx_client
	$image_topy_client = $region_topy_client
	$image_bottomx_absolute = $region_bottomx_absolute
	$image_bottomy_absolute = $region_bottomy_absolute
	$image_bottomx_window = $region_bottomx_window
	$image_bottomy_window = $region_bottomy_window
	$image_bottomx_client = $region_bottomx_client
	$image_bottomy_client = $region_bottomy_client
	$Image_width = $region_width
	$Image_height = $region_height
	
	; Show the image in the main window
	RefreshImage()		
	; Display tooltip confirmation			
	ToolTip("Image captured!")
	Sleep(1000)
	ToolTip("")

	; Set the "image captured" flag
	$Flag_imagecaptured = 1
	
	Return "success"
	
EndFunc

Func RefreshImage()		; Check done

	Local $xposition, $yposition

	; Default mode
	Opt("MouseCoordMode", 2)		; Use the client area
	Opt("PixelCoordMode", 2)		; Use the client area

	; Destroy and recreate the image control
	GUICtrlDelete($Mwin_imagebox)
    $Mwin_imagebox =  GUICtrlCreatePic("", 10, 10, 0, 0)    
	
	; Remember the x,y position of the top-left corner of the image
	$Mwin_imagebox_xposition = 10 + Floor(($Mwin_imagebox_maxwidth - $Image_width) / 2)
	$Mwin_imagebox_yposition = 10 + Floor(($Mwin_imagebox_maxheight - $Image_height) / 2)
;	; Refresh the image from the bitmap handle
;	GUICtrlSetPos($Mwin_imagebox, $Mwin_imagebox_xposition, $Mwin_imagebox_yposition)	
;	GUICtrlSetImage($Mwin_imagebox, $Image_handle)
	
	; Refresh the image from the bitmap file
;	GUICtrlSetPos($Mwin_imagebox, $Mwin_imagebox_xposition, $Mwin_imagebox_yposition, $Image_width, $Image_height)	
	GUICtrlSetPos($Mwin_imagebox, $Mwin_imagebox_xposition, $Mwin_imagebox_yposition)	
	GUICtrlSetImage($Mwin_imagebox, $Image_currentfile)

	; Refresh the info boxes
	GUICtrlSetData($Mwin_info[1], $Image_width)
	GUICtrlSetData($Mwin_info[2], $Image_height)
	GUICtrlSetData($Mwin_info[4], $Image_topx_absolute & "x" & $Image_topy_absolute)
	GUICtrlSetData($Mwin_info[5], $Image_topx_window & "x" & $Image_topy_window)
	GUICtrlSetData($Mwin_info[6], $Image_topx_client & "x" & $Image_topy_client)
	GUICtrlSetData($Mwin_info[8], $Image_checksum)

	Return "success"
	
EndFunc

; Colour capture functions

Func CaptureColour()	; Check done

	; Default mode
	Opt("MouseCoordMode", 1)		; Use the whole screen
	Opt("PixelCoordMode", 1)		; Use the whole screen
	
	$Hotkey_press = ""
	Do
		$xy = MouseGetPos()
		$currentpixel = PixelGetColor($xy[0],$xy[1])
		ToolTip("Find the text colour" & @LF & "	and press F1 (ESC to quit)" & @LF & "Pixel color = " & $currentpixel)
		GUICtrlSetBkColor($Mwin_info[7], $currentpixel)	
		; Update the display of the mouse's position in the client window
		CheckCursor()
		Sleep(100)
	Until $Hotkey_press <> ""
	
	If $Hotkey_press = "escape" Then 
		Opt("MouseCoordMode", 0)
		GUICtrlSetBkColor($Mwin_info[7], 0x000000)		
		Return "fail"
	Else
		ToolTip("")
		$xy = MouseGetPos()
		$Pixel_target = PixelGetColor($xy[0],$xy[1])
		
		GUICtrlSetBkColor($Mwin_info[7], $Pixel_target)
		GUICtrlSetData($Mwin_label[7], $Pixel_target)		

		$Flag_pixelcolourchosen = 1
		
		Return "success"
	EndIf
	
EndFunc

; Text scraping functions

Func ScrapeText()		; Check done
	
	Local $region_topx, $region_topy, $region_bottomx, $region_bottomy, $a
	Local $match, $count, $duplicatecount

	; Default mode
	Opt("PixelCoordMode", 2)		; Use the client window
	
	; Set the coordinates of the region to be searched
	$region_topx = $Mwin_imagebox_xposition
	$region_topy = $Mwin_imagebox_yposition
	$region_bottomx = $Mwin_imagebox_xposition + $Image_width - 1
	$region_bottomy = $Mwin_imagebox_yposition + $Image_height - 1
	
	; Reset the progress labels
	GUICtrlSetData($Mwin_label[11], "Scrape characters")
	GUICtrlSetData($Mwin_label[12], "Delete duplicates")
	
	; Search the region, horizontal strip after horizontal strip
	ScrapeText_Stage0($region_topx, $region_topy, $region_bottomx, $region_bottomy)
	
	; Count scraped chars
	$count = 0
	For $a = 1 to $Char_maxchars
		If $Char_array[$a][1] <> "" Then 
			$count = $count + 1
		EndIf
	Next

	; Set the progress bar to 100%
	GUICtrlSetData($Mwin_info[11], 100)
	GUICtrlSetData($Mwin_label[11], "Scraped " & $count & " chars")
	
	; If at least one char was scraped...
	If $count > 0 Then 
		
		; Search the character array, and remove duplicates
		$duplicatecount = ScrapeText_Stage5()
		GUICtrlSetData($Mwin_label[12], $duplicatecount & " duplicates")

		; Display the first char in the char box
		MoveDownChar()

		; Set and display the not found string
		$Char_notfoundstring = "#$,.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz£€"
		GUICtrlSetData($Mwin_info[31], $Char_notfoundstring)
		
		; Disable the file save box
		GUICtrlSetState($Mwin_info[9], $GUI_DISABLE)		
		; Enable the character entry box
		GUICtrlSetState($Mwin_info[14], $GUI_ENABLE)		

		; Set the mode to 2
		$Misc_mode = 2
	EndIf
		
	Return "success"
	
EndFunc

Func ScrapeText_Stage0($topx, $topy, $bottomx, $bottomy)	
	
	; First narrow the search region hoping to remove any partially-visible characters at the top and bottom of the search region

	Local $line, $matchline, $count, $result, $newtopy
	Local $newbottomy
	
	; Lower the top horizontal line until a line without the target pixel is found, but don't lower it
	; at all if a line can't be found within the maximum character height, or within the search region
	$line = $topy - 1
	$matchline = ""
	$count = 0
	Do
		
		$line = $line + 1
		$count = $count + 1
		If $count > $Char_maxheight OR $line > $bottomy Then 
			; Give up, use the old top horizontal line
			If $count > $Char_maxheight Then 
				MsgBox(1, "", "count > charmaxh")
			Else
				MsgBox(1, "", "line > bottomy")
			EndIf
			$matchline = $topy
		Else
			$result = PixelSearch($topx, $line, $bottomx, $line, $Pixel_target)
			If @error Then 
				; No pixels of the right colour found on this line
				$matchline = $line
			Else
				; Target pixel was found, ignore this line
			EndIf		
		EndIf
	Until $matchline > 0
	
	$newtopy = $matchline
	
	; Raise the bottom horizontal line
	$line = $bottomy + 1
	$matchline = ""
	$count = 0
	Do
		
		$line = $line - 1
		$count = $count + 1
		If $count > $Char_maxheight OR $line < $topy Then 
			; Give up
			$matchline = $bottomy
		Else
			$result = PixelSearch($topx, $line, $bottomx, $line, $Pixel_target)
			If @error Then 
				$matchline = $line
			EndIf		
		EndIf
	Until $matchline > 0
	
	$newbottomy = $matchline

	; Make the changes to the search region
;	MsgBox(1, "Stage1", "Old y " & $topy & "/" & $bottomy & ", new y " & $newtopy & "/" & $newbottomy)
	$topy = $newtopy
	$bottomy = $newbottomy

	; Begin the search proper
	ScrapeText_Stage1($topx, $topy, $bottomx, $bottomy)
	
	Return "success"
	
EndFunc
	
Func ScrapeText_Stage1($topx, $topy, $bottomx, $bottomy)		; check done
	
	; Search the region, horizontal strip after horizontal strip

	Local $startline, $endline, $line, $result, $matchline
	Local $finishedflag = 0

	$startline = $topy - 1
	$endline = $topy - 1
	Do
		
		; Set the progress bar
		GUICtrlSetData($Mwin_info[11], ($endline / $bottomy) * 100)
				
		; Find the start line, starting one below the last endline
		$line = $endline 
		$matchline = ""
		Do
			$line = $line + 1
			$result = PixelSearch($topx, $line, $bottomx, $line, $Pixel_target)
			If @error Then 
				; No pixels of the right colour found on this line
			Else
				; Target pixel was found, make this the start line
				$matchline = $line
			EndIf
			; Check if this is the end of the search region
			If $line >= $bottomy Then 
				$finishedflag = 1
			EndIf
		; Continue until a match is found, or the end of the search region is reached
		Until $finishedflag = 1 OR $matchline <> ""
	
		If $finishedflag = 0 AND $matchline <> "" Then 
			
			; Set the start line
			$startline = $matchline
			
			; Find the end line, the last line containing the pixel colour, starting one below the start line
			$line = $startline
			$matchline = ""
			Do
				$line = $line + 1
				$result = PixelSearch($topx, $line, $bottomx, $line, $Pixel_target)
				If @error Then 
					; Target pixel wasn't found in this line, make it the end line plus one
					$matchline = $line
				ElseIf $line >= $bottomy Then 
					; We have reached the end of the search region, end the search
					$finishedflag = 1
				EndIf
			; Continue until a line without the pixel is found, or the end of the search region is reached
			Until $finishedflag = 1 OR $matchline <> "" 
		
			If $matchline <> "" Then 
				; Set the end line to be one above the match line
				$endline = $matchline - 1
			ElseIf $finishedflag = 1 Then 
				; Set the end line to be the bottom of the search region
				$endline = $bottomy
			EndIf

			; If a start line and end line was found, search the region enclosed by them
			If $endline <> "" Then 
				ScrapeText_Stage2($topx, $startline, $bottomx, $endline)
			EndIf
		EndIf
		
	; Repeat the loop until the end of the search region has been reached
	Until $finishedflag = 1
		
	Return "success"
	
EndFunc

Func ScrapeText_Stage2($topx, $topy, $bottomx, $bottomy)		; check done
	
	; Search the region, vertical strip after vertical strip

	Local $startcolumn, $endcolumn, $column, $result, $matchcolumn
	Local $finishedflag = 0

	; First narrow the search region hoping to remove any partially-visible characters at the left and right of the search region

	; Move the leftmost vertical line to the right
	$line = $topx - 1
	$matchline = ""
	$count = 0
	Do
		
		$line = $line + 1
		$count = $count + 1
		If $count > $Char_maxwidth OR $line > $bottomx Then 
			; Give up
			$matchline = $topx
		Else
			$result = PixelSearch($line, $topy, $line, $bottomy, $Pixel_target)
			If @error Then 
				$matchline = $line
			EndIf		
		EndIf
	Until $matchline > 0	
	
	$newtopx = $matchline
	
	; Move the rightmost vertical line to the left
	$line = $bottomx + 1
	$matchline = ""
	$count = 0
	Do
		
		$line = $line - 1
		$count = $count + 1
		If $count > $Char_maxwidth OR $line < $topy Then 
			; Give up
			$matchline = $bottomx
		Else
			$result = PixelSearch($line, $topy, $line, $bottomy, $Pixel_target)
			If @error Then 
				$matchline = $line
			EndIf		
		EndIf
	Until $matchline > 0	

	$newbottomx = $matchline
	
	; Make the changes to the search region
;	If $topx <> $newtopx OR $bottomx <> $newbottomx Then 
;		MsgBox(1, "Stage1", "Old x " & $topx & "/" & $bottomx & ", new x " & $newtopx & "/" & $newbottomx)
;	EndIf
	$topx = $newtopx
	$bottomx = $newbottomx

	; Now do the search itself

	$startcolumn = $topx - 1
	$endcolumn = $topx - 1
	Do
		
		; Find the start column, starting one to the right of the last end column
		$column = $endcolumn
		$matchcolumn = ""
		Do
			$column = $column + 1
			$result = PixelSearch($column, $topy, $column, $bottomy, $Pixel_target)
			IF @error Then 
				; Target pixel wasn't found in this column, move on to the next one
			Else
				; Target pixel was found, make this the start column
				$matchcolumn = $column
			EndIf
			; Check if this is the end of the search region
			If $column >= $bottomx Then 
				$finishedflag = 1
			EndIf
		; Continue until a match is found, or the end of the search region is reached
		Until $finishedflag = 1 OR $matchcolumn <> ""

		If $finishedflag = 0 AND $matchcolumn <> "" Then 
		
			; Set the start column
			$startcolumn = $matchcolumn
		
			; Find the end column, the last column containing the target pixel colour, starting one to the right
			; of the start column
			$column = $startcolumn
			$matchcolumn = ""
			Do
				$column = $column + 1
				$result = PixelSearch($column, $topy, $column, $bottomy, $Pixel_target)
				IF @error Then 
					; Target pixel wasn't found in this column, make this the end column plus one
					$matchcolumn = $column
				ElseIf $column >= $bottomx Then 
					; We have reached the end of the search region, end the search
					$finishedflag = 1
				EndIf
			; Continue until a column without the pixel is found, or the end of the search region is reached
			Until $finishedflag = 1 OR $matchcolumn <> ""		
		
			If $matchcolumn <> "" Then
				; Set the end column to be one to the left of the match column
				$endcolumn = $matchcolumn - 1
			ElseIf $finishedflag = 1 Then 
				; Set the end column to be the right boundary of the search region
				$endcolumn = $bottomx
			EndIf

			; If a start column and end column were found, search the region enclosed by them
			If $endcolumn <> "" Then 
				ScrapeText_Stage3($startcolumn, $topy, $endcolumn, $bottomy)
			EndIf
		EndIf
		
	; Repeat the loop until the end of the search region has been reached
	Until $finishedflag = 1
		
	Return "success"
	
EndFunc

Func ScrapeText_Stage3($topx, $topy, $bottomx, $bottomy)		; check done
	
	; Search the region, horizontal level after horizontal level

	Local $startlevel, $endlevel, $level, $result, $matchlevel
	Local $finishedflag = 0

	$startlevel = $topy - 1
	$endlevel = $topy - 1
	Do
		
		; Find the start level, starting one above the top of the region
		$level = $endlevel 
		$matchlevel = ""
		Do
			$level = $level + 1
			$result = PixelSearch($topx, $level, $bottomx, $level, $Pixel_target)
			If @error Then 
				; No pixels of the right colour found on this level
			Else
				; Target pixel was found, make this the start level
				$matchlevel = $level
			EndIf
			; Check if this is the end of the search region
			If $level >= $bottomy Then 
				$finishedflag = 1
			EndIf
		; Continue until a match is found, or the end of the search region is reached
		Until $finishedflag = 1 OR $matchlevel <> ""
	
		If $finishedflag = 0 AND $matchlevel <> "" Then 
			
			; Set the start level
			$startlevel = $matchlevel
			
			; Find the end level, the last level containing the pixel colour, starting one below the start level
			$level = $startlevel
			$matchlevel = ""
			Do
				$level = $level + 1
				$result = PixelSearch($topx, $level, $bottomx, $level, $Pixel_target)
				If @error Then 
					; Target pixel wasn't found in this level, make it the end level plus one
					$matchlevel = $level
				ElseIf $level >= $bottomy Then 
					; We have reached the end of the search region, end the search
					$finishedflag = 1
				EndIf
			; Continue until no match is found, or the end of the search region is reached
			Until $finishedflag = 1 OR $matchlevel <> "" 
		
			If $matchlevel <> "" Then 
				; Set the end level to be one above the match level
				$endlevel = $matchlevel - 1
			ElseIf $finishedflag = 1 Then 
				; Set the end level to be the bottom of the search region
				$endlevel = $bottomy
			EndIf
			
			; If a start level and end level were found, scrape the character contained in the region
			; enclosed by them
			If $endlevel <> "" Then 
				ScrapeText_Stage4($topx, $startlevel, $bottomx, $endlevel)
			EndIf
		EndIf
		
	; Repeat the loop until the end of the search region has been reached
	Until $finishedflag = 1
		
	Return "success"
	
EndFunc

Func ScrapeText_Stage4($topx, $topy, $bottomx, $bottomy)		; check done
	
	; Scrape the character occupying the region bounded by the function arguments
	
	Local $match, $count, $pixel, $window_countx, $window_county
	Local $char_countx, $char_county

;	MsgBox(1, "ST_Stage 4", "Called with topx/y " & $topx & "/" & $topy & ", bottomx/y " & $bottomx & "/" & $bottomy, 0.01)

	; Find a gap in the character array
	$match = 0
	$count = 0
	Do
		$count = $count + 1
		If $Char_array[$count][1] = "" Then 
			$match = $count
		EndIf
	Until $match > 0 OR $count = $Char_maxchars
		
	If $match = 0 Then 
		Return "fail"
	Else
		
		; Scrape the character and store it in char array position $match, but ignore anything outside
		; the maximum character size
		$window_county = $topy - 1						; Count the window pixels from top to bottom
		$char_county = 0								; Count the char pixels from top to bottom
		Do
			$window_county = $window_county + 1
			$char_county = $char_county + 1
			If $char_county <= $Char_maxheight Then 
				
				$window_countx = $topx - 1				; Count the window pixels from left to right
				$char_countx = 0						; Count the char pixels from left to right
				Do
					$window_countx = $window_countx + 1
					$char_countx = $char_county + 1
					If $char_countx <= $Char_maxwidth Then 
						
						$pixel = PixelGetColor($window_countx, $window_county)
						If $pixel = $Pixel_target Then 
							$Char_array[$match][$char_county] = $Char_array[$match][$char_county] & "x"
						Else
							$Char_array[$match][$char_county] = $Char_array[$match][$char_county] & " "
						EndIf
					EndIf
				Until $window_countx = $bottomx
			EndIf
		Until $window_county = $bottomy
		
		; Mark the character as unknon
		$Char_array_chr[$match] = "^"
		; Set the position of the found char
		$Char_array_width[$match] = $bottomx - $topx + 1
		$Char_array_height[$match] = $bottomy - $topy + 1
		$Char_array_xpos[$match] = $topx
		$Char_array_ypos[$match] = $topy
		
		Return "success"
	EndIf
	
EndFunc

Func ScrapeText_Stage5()										; check done
	
	; Remove duplicates from the character array
	
	Local $char, $compare, $match, $count, $a
	Local $duplicatecount
	
	$duplicatecount = 0
	
	For $char = 1 to $Char_maxchars
		
		; Set the progress bar
		GUICtrlSetData($Mwin_info[12], (($char / $Char_maxchars) * 100))	
		
		; Process only full elements in the array
		If $Char_array[$char][1] <> "" Then 
			
			For $compare = $char to $Char_maxchars
				
				; Don't compare the char to itself, and only process full elements in the array
				If $char <> $compare AND $Char_array[$compare][1] <> "" Then 
					
					$match = 0
					$count = 0
					Do 
						$count = $count + 1
						If $Char_array[$char][$count] <> $Char_array[$compare][$count] Then 
							$match = $count
						EndIf
					Until $match > 0 OR $count = $Char_maxheight
					
					; If match is 0, the chars are identical, so delete the higher one
					If $match = 0 Then 
						$duplicatecount = $duplicatecount + 1
						For $a = 0 to $Char_maxheight
							$Char_array[$compare][$a] = ""
						Next
						$Char_array_chr[$compare] = ""
						$Char_array_width[$compare] = ""
						$Char_array_height[$compare] = ""
						$Char_array_xpos[$compare] = ""
						$Char_array_ypos[$compare] = ""
					EndIf
				EndIf
			Next
		EndIf
	Next

	Return $duplicatecount
	
EndFunc

; Char set functions

Func DisplayChar($number)										; check done
	
	Local $text, $line, $x, $y, $known
	Local $unknown
	
	; Default mode
	Opt("PixelCoordMode", 2)		; Use the client window

	If $Char_array[$number][1] <> "" Then 
		
		; Prepare the text to display
		For $y = 1 to $Char_array_height[$number]

			; Compose a line that's more easily readable
			$line = ""
			If StringLen($Char_array[$number][$y]) > 0 Then 
				For $x = 1 to StringLen($Char_array[$number][$y])
					If StringMid($Char_array[$number][$y], $x, 1) = "x" Then 
						$line = $line & "$"
					Else
						$line = $line & "1"
					EndIf
				Next
			EndIf
			
			; Add the line to the text that will be displayed
			$text = $text & $line & @CRLF
		Next
		
	Else
		; For empty elements in the char array, display a blank string
		$text = ""
	EndIf
	
	; Update the display
	GuiCtrlSetData($Mwin_charbox, $text)	
	
	; Count the number of known and unknown chars
	$unknown = 0
	$known = 0
	For $a = 1 to $Char_maxchars
		If $Char_array[$a][1] <> "" Then 
			If $Char_array_chr[$a] = "^" Then 
				$unknown = $unknown + 1
			Else
				$known = $known + 1
			EndIf
		EndIf
	Next
	
	; Update the accompanying info boxes
	If $Char_array_chr[$number] = "^" Then 
		GuiCtrlSetData($Mwin_info[15], "???")
	Else
		GuiCtrlSetData($Mwin_info[15], $Char_array_chr[$number])
	EndIf
	GuiCtrlSetData($Mwin_info[16], $number)
	GuiCtrlSetData($Mwin_info[17], $known)
	GuiCtrlSetData($Mwin_info[18], $unknown)
	GuiCtrlSetData($Mwin_info[19], $known + $unknown)
	GuiCtrlSetData($Mwin_info[20], $Char_array_width[$number])
	GuiCtrlSetData($Mwin_info[21], $Char_array_height[$number])
	GuiCtrlSetData($Mwin_info[22], $Char_array_xpos[$number])
	GuiCtrlSetData($Mwin_info[23], $Char_array_ypos[$number])
	
	Return "success"
	
EndFunc

Func MoveUpChar()
	
	; Display the previous char in the character array, starting from $Char_current
	
	Local $match, $count
	
	$match = 0
	$count = $Char_current
	Do
		$count = $count - 1
		If $count = 0 Then 
			$count = $Char_maxchars
		EndIf
		; If this element is full but unknown, exit the loop
		If $Char_array_chr[$count] = "^" Then 
			$match = $count
		EndIf
	Until $match > 0 OR $count = $Char_current
	
	If $count = $Char_current Then 
		; The array is empty
		MsgBox(1, "Error", "Array empty")
		Return "fail"
	Else
		$Char_current = $match
		; Display the char
		DisplayChar($Char_current)
	EndIf
	
	Return "success"
		
EndFunc

Func MoveDownChar()
	
	; Display the next char in the character array, starting from $Char_current
	
	Local $match, $count
	
	$match = 0
	$count = $Char_current
	Do
		$count = $count + 1
		If $count > $Char_maxchars Then 
			$count = 1
		EndIf
		; If this element is full but unknown, exit the loop
		If $Char_array_chr[$count] = "^" THen 
			$match = $count
		EndIf
	Until $match > 0 OR $count = $Char_current
	
	If $count = $Char_current Then 
		; The array is empty
		MsgBox(1, "Error", "Array empty")
		Return "fail"
	Else
		$Char_current = $match
		; Display the char
		DisplayChar($Char_current)
	EndIf
	
	Return "success"
		
EndFunc

Func EnterChar($string)
	
	Local $position, $match, $count
	
	; If the string is empty, ignore it
	If StringLen($string) = 0 Then 
		Return "fail"
	Else
				
		; If the entered string is just one character long...
		If StringLen($string) = 1 Then 
		
			; Look for the string in the unknown character list
			$position = StringInStr($Char_notfoundstring, $string)
			If $position <> 0 Then 
				; If it's there, remove it
				$Char_notfoundstring = StringLeft($Char_notfoundstring, ($position - 1)) & StringRight($Char_notfoundstring, (StringLen($Char_notfoundstring) - $position)) 
			EndIf
			; Transfer $string to the known character list
			If StringLen($Char_foundstring) = 0 Then 
				$Char_foundstring = $string
			Else
				; Find the first character which has a higher ASCII than $string, and put $string just before it, 
				; but stop when [..] is reached
				$match = 0
				$count = 0 
				Do
					$count = $count + 1
					If Asc(StringMid($Char_foundstring, $count, 1)) > Asc($string) Then 
						$match = $count
					EndIf
				Until $match > 0 OR $count = StringLen($Char_foundstring) OR StringMid($Char_foundstring, $count, 1) = "["
				If StringMid($Char_foundstring, $count, 1) = "[" Then 
					$Char_foundstring = StringLeft($Char_foundstring, ($count - 1)) & $string & StringRight($Char_foundstring, (StringLen($Char_foundstring) - $count + 1))				
				ElseIf $match = 0 Then 
					$Char_foundstring = $Char_foundstring & $string
				Else
					$Char_foundstring = StringLeft($Char_foundstring, ($match - 1)) & $string & StringRight($Char_foundstring, (StringLen($Char_foundstring) - $match + 1))
				EndIf
			EndIf
		
		; If the entered string is longer than one character, add it to the end of the found character list, in brackets
		ElseIf StringLen($string) > 1 Then 	
			$Char_foundstring = $Char_foundstring & "[" & $string & "]"
		EndIf
	
		; Update the foundstring/notfoundstring boxes
		GUICtrlSetData($Mwin_info[31], $Char_notfoundstring)
		GUICtrlSetData($Mwin_info[32], $Char_foundstring)
		
		; Mark the current character as known
		$Char_array_chr[$Char_current] = $string
		; Find and display the next character
		MoveDownChar()
	EndIf
	
	Return "success"

EndFunc

Func DeleteChar()
	
	Local $a
	
	; Delete the current char and move to the next one
	For $a = 1 to $Char_maxheight
		$Char_array[$Char_current][$a] = ""
	Next
	$Char_array_chr[$Char_current] = ""
	$Char_array_width[$Char_current] = ""
	$Char_array_height[$Char_current] = ""
	$Char_array_xpos[$Char_current] = ""
	$Char_array_ypos[$Char_current] = ""
	; Find and display the next character
	MoveDownChar()	

	Return "success"
	
EndFunc

; Hotkey functions

Func Hotkey_TakePhoto()
	
	; Whenever the hotkey is pressed, sets the global variable $Keypress
	$Hotkey_press = "takephoto"
	
	Return "success"
	
EndFunc

Func Hotkey_Escape()
	
	; Whenever the hotkey is pressed, sets the global variable $Keypress
	$Hotkey_press = "escape"
	
	Return "success"

EndFunc

			