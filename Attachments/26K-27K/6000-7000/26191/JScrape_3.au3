
; ============================================================================
; 							  	 JScrape v0.3
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

#include <Array.au3>
#include <GUIConstants.au3>
#include <Date.au3>
#include <GuiEdit.au3>
#include <ScreenCapture.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>
#Include <GDIPlus.au3>

Opt('MustDeclareVars', 1)

; Script variables
Global $Script_name = "JScrape"
Global $Script_version = "0.3"

; Window variables

; Main window
Global $Mwin_width = 800
Global $Mwin_height = 550
Global $Mwin_handle
; Image box
Global $Mwin_imagebox
Global $Mwin_imagebox_maxwidth = 780
Global $Mwin_imagebox_maxheight = 290
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
Global $Mwin_maxboxes = 48
Global $Mwin_info[$Mwin_maxboxes + 1]
Global $Mwin_label[$Mwin_maxboxes + 1]
; Hidden button to make the input boxes work
Global $Mwin_hiddenbutton1, $Mwin_hiddenbutton2, $Mwin_hiddenbutton3
; Menus
Global $Mwin_maxmenuhandles = 4
Global $Mwin_maxmenuitems = 64
Global $Mwin_menuhandle[$Mwin_maxmenuhandles + 1]
Global $Mwin_menuitem[$Mwin_maxmenuitems + 1]

; Image variables
Global $Image_handle
Global $Image_filecount = 0
Global $Image_currentfile
Global $Image_currentname
Global $Image_checksum
Global $Image_topx_absolute, $Image_topy_absolute
Global $Image_topx_window, $Image_topy_window
Global $Image_topx_client, $Image_topy_client
Global $Image_bottomx_absolute, $Image_bottomy_absolute
Global $Image_bottomx_window, $Image_bottomy_window
Global $Image_bottomx_client, $Image_bottomy_client
Global $Image_width, $Image_height

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

; Variables for the undo buttons, which rememeber all changes of character from 'unknown' to 'known'/'deleted',
;  	but can only undo one 'split'
; How many chanages have been made - 0 initially, 1 after the first change, n after the nth change
Global $Char_changecount = 0
; For each character in the char array, if it has been marked 'known' or 'deleted', what value $Char_undo_changecount had at
; 	the time
Global $Char_changenumber[$Char_maxchars + 1]
; The undo button can undo only one character split, this variable holds the value $Char_undo_changecount the last time
;	a character was split
Global $Char_splitnumber
; Which character was split, and which new character was created
Global $Char_splitchar1, $Char_splitchar2
; The contents of the character before it was split
Global $Char_presplit[$Char_maxheight + 1]
Global $Char_presplit_chr, $Char_presplit_width, $Char_presplit_height, $Char_presplit_xpos, $Char_presplit_ypos

Global $Char_foundstring
Global $Char_notfoundstring

; The current char number show in the char box
Global $Char_current = 0

Global $Char_locatorhandle 

; The target pixel colours
Global $Pixel_emptyboxcolour = 13947080
Global $Pixel_target[4 + 1]
$Pixel_target[1] = $Pixel_emptyboxcolour
$Pixel_target[2] = $Pixel_emptyboxcolour
$Pixel_target[3] = $Pixel_emptyboxcolour
Global $Pixel_number

; Misc variables
Global $Misc_exitscriptflag = 0
Global $checkflag = 0
Global $Misc_standardstring = "#$,.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz£€"
Global $Misc_scrapecharcount
Global $Misc_detailfile = "details.txt"
Global $Misc_rawdatafile = "rawdata.txt"
Global $Misc_autoitfile = "autoit.txt"

; Things that have been done
Global $Flag_imagecaptured = 0
Global $Flag_imagecapture_current = 0
Global $Flag_pixelcolourchosen = 0
Global $Flag_pixelcolour_current = 0

; Set the hotkey for taking photos and exiti
HotKeySet("{F1}", "Hotkey_TakePhoto")
HotKeySet('{esc}', "Hotkey_Escape")
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

Func CreateMainWindow() ; Check done

	; Create the main window

	$Mwin_handle = GUICreate($Script_name & " v" & $Script_version, $Mwin_width, $Mwin_height)
	GUISetState(@SW_SHOW)

	; Create the image box
	$Mwin_imagebox = GUICtrlCreatePic("", 10, 10, 0, 0)

	; Create the left hand side of the screen
	$Mwin_button[1] = GUICtrlCreateButton("Capture Image", 10, ($Mwin_imagebox_maxheight + 20), 90, 32)
	$Mwin_button[3] = GUICtrlCreateButton("Choose Colours", 10, ($Mwin_imagebox_maxheight + 100), 90, 32)
	$Mwin_button[4] = GUICtrlCreateButton("Save Details", 10, ($Mwin_imagebox_maxheight + 140), 90, 32)
	$Mwin_button[5] = GUICtrlCreateButton("Scrape Text", 10, ($Mwin_imagebox_maxheight + 180), 90, 32)

	$Mwin_info[1] = GUICtrlCreateInput("", 110, ($Mwin_imagebox_maxheight + 20), 40, 20, $ES_READONLY)
	$Mwin_label[1] = GUICtrlCreateLabel("Width", 110, ($Mwin_imagebox_maxheight + 40), 40, 20, $ES_READONLY)
	$Mwin_info[2] = GUICtrlCreateInput("", 160, ($Mwin_imagebox_maxheight + 20), 40, 20, $ES_READONLY)
	$Mwin_label[2] = GUICtrlCreateLabel("Height", 160, ($Mwin_imagebox_maxheight + 40), 40, 20, $ES_READONLY)
	$Mwin_info[8] = GUICtrlCreateInput("", 210, ($Mwin_imagebox_maxheight + 20), 90, 20, $ES_READONLY)
	$Mwin_label[8] = GUICtrlCreateLabel("Checksum", 210, ($Mwin_imagebox_maxheight + 40), 90, 20, $ES_READONLY)

	$Mwin_info[4] = GUICtrlCreateInput("", 10, ($Mwin_imagebox_maxheight + 60), 70, 20, $ES_READONLY)
	$Mwin_label[4] = GUICtrlCreateLabel("Desktop XY", 10, ($Mwin_imagebox_maxheight + 80), 70, 20, $ES_READONLY)
	$Mwin_info[5] = GUICtrlCreateInput("", 90, ($Mwin_imagebox_maxheight + 60), 70, 20, $ES_READONLY)
	$Mwin_label[5] = GUICtrlCreateLabel("Window", 90, ($Mwin_imagebox_maxheight + 80), 70, 20, $ES_READONLY)
	$Mwin_info[6] = GUICtrlCreateInput("", 170, ($Mwin_imagebox_maxheight + 60), 70, 20, $ES_READONLY)
	$Mwin_label[6] = GUICtrlCreateLabel("Client", 170, ($Mwin_imagebox_maxheight + 80), 70, 20, $ES_READONLY)
	$Mwin_info[3] = GUICtrlCreateInput("", 250, ($Mwin_imagebox_maxheight + 60), 50, 20, $ES_READONLY)
	$Mwin_label[3] = GUICtrlCreateLabel("Cursor", 250, ($Mwin_imagebox_maxheight + 80), 50, 20, $ES_READONLY)

	$Mwin_info[33] = GUICtrlCreateGraphic(110, ($Mwin_imagebox_maxheight + 100), 80, 20)
	GUICtrlSetColor($Mwin_info[33], 0x000000)
	GUICtrlSetBkColor($Mwin_info[33], $Pixel_emptyboxcolour)
	$Mwin_label[33] = GUICtrlCreateLabel("", 110, ($Mwin_imagebox_maxheight + 120), 80, 20, $ES_READONLY)
	$Mwin_info[34] = GUICtrlCreateGraphic(200, ($Mwin_imagebox_maxheight + 100), 45, 20)
	GUICtrlSetColor($Mwin_info[34], 0x000000)
	GUICtrlSetBkColor($Mwin_info[34], $Pixel_emptyboxcolour)
	$Mwin_label[34] = GUICtrlCreateLabel("", 200, ($Mwin_imagebox_maxheight + 120), 45, 20, $ES_READONLY)
	$Mwin_info[35] = GUICtrlCreateGraphic(255, ($Mwin_imagebox_maxheight + 100), 45, 20)
	GUICtrlSetColor($Mwin_info[35], 0x000000)
	GUICtrlSetBkColor($Mwin_info[35], $Pixel_emptyboxcolour)
	$Mwin_label[35] = GUICtrlCreateLabel("", 255, ($Mwin_imagebox_maxheight + 120), 45, 20, $ES_READONLY)

	$Mwin_info[9] = GUICtrlCreateInput("", 110, ($Mwin_imagebox_maxheight + 140), 90, 20)
	GUICtrlSetState($Mwin_info[9], $GUI_DISABLE)
	$Mwin_hiddenbutton1 = GUICtrlCreateButton("", 10, ($Mwin_height - 90), 10, 10, $BS_DEFPUSHBUTTON)
	GUICtrlSetState(-1, $GUI_HIDE)
	$Mwin_label[9] = GUICtrlCreateLabel("Image Name", 110, ($Mwin_imagebox_maxheight + 160), 90, 20, $ES_READONLY)
	$Mwin_info[10] = GUICtrlCreateInput("", 210, ($Mwin_imagebox_maxheight + 140), 90, 20, $ES_READONLY)
	$Mwin_label[10] = GUICtrlCreateLabel("Image File", 210, ($Mwin_imagebox_maxheight + 160), 90, 20, $ES_READONLY)

	$Mwin_info[11] = GUICtrlCreateProgress(110, ($Mwin_imagebox_maxheight + 180), 90, 20)
	$Mwin_label[11] = GUICtrlCreateLabel("Scrape Characters", 110, ($Mwin_imagebox_maxheight + 200), 90, 20, $ES_READONLY)
	$Mwin_info[12] = GUICtrlCreateProgress(210, ($Mwin_imagebox_maxheight + 180), 90, 20)
	$Mwin_label[12] = GUICtrlCreateLabel("Delete Duplicates", 210, ($Mwin_imagebox_maxheight + 200), 90, 20, $ES_READONLY)

	; Create the character box
	$Mwin_charbox = GUICtrlCreateEdit("", 310, ($Mwin_imagebox_maxheight + 20), 200, 192, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL))
	GUICtrlSetColor($Mwin_charbox, 0xFFFFFF)
	GUICtrlSetBkColor($Mwin_charbox, 0x000000)
	GUICtrlSetFont($Mwin_charbox, 8, 400, 0, "Courier New")

	; Create the right hand side of the screen
	$Mwin_button[11] = GUICtrlCreateButton("Up", 520, ($Mwin_imagebox_maxheight + 20), 90, 32)
	$Mwin_button[12] = GUICtrlCreateButton("Down", 520, ($Mwin_imagebox_maxheight + 60), 90, 32)
	$Mwin_button[13] = GUICtrlCreateButton("Delete", 520, ($Mwin_imagebox_maxheight + 100), 90, 32)
	$Mwin_button[14] = GUICtrlCreateButton("Split", 520, ($Mwin_imagebox_maxheight + 140), 90, 32)
	$Mwin_button[15] = GUICtrlCreateButton("Size Sort", 620, ($Mwin_imagebox_maxheight + 140), 80, 32)
	$Mwin_button[16] = GUICtrlCreateButton("Ascii Sort", 710, ($Mwin_imagebox_maxheight + 140), 80, 32)
	$Mwin_button[17] = GUICtrlCreateButton("Undo", 520, ($Mwin_imagebox_maxheight + 180), 90, 32)
	$Mwin_button[18] = GUICtrlCreateButton("Undo All", 620, ($Mwin_imagebox_maxheight + 180), 80, 32)
	$Mwin_button[19] = GUICtrlCreateButton("Save", 710, ($Mwin_imagebox_maxheight + 180), 80, 32)

	$Mwin_info[14] = GUICtrlCreateInput("", 620, ($Mwin_imagebox_maxheight + 20), 70, 20)
	GUICtrlSetState($Mwin_info[14], $GUI_DISABLE)
;	$Mwin_hiddenbutton2 = GUICtrlCreateButton("", 10, ($Mwin_height - 50), 10, 10, $BS_DEFPUSHBUTTON)
;	GUICtrlSetState(-1, $GUI_HIDE)
	$Mwin_label[14] = GUICtrlCreateLabel("Enter Char", 620, ($Mwin_imagebox_maxheight + 40), 70, 20, $ES_READONLY)
	$Mwin_info[15] = GUICtrlCreateInput("", 700, ($Mwin_imagebox_maxheight + 20), 40, 20, $ES_READONLY)
	$Mwin_label[15] = GUICtrlCreateLabel("Symbol", 700, ($Mwin_imagebox_maxheight + 40), 40, 20, $ES_READONLY)
	$Mwin_info[16] = GUICtrlCreateInput("", 750, ($Mwin_imagebox_maxheight + 20), 40, 20, $ES_READONLY)
	$Mwin_label[16] = GUICtrlCreateLabel("Char #", 750, ($Mwin_imagebox_maxheight + 40), 40, 20, $ES_READONLY)

	$Mwin_info[17] = GUICtrlCreateInput("", 620, ($Mwin_imagebox_maxheight + 60), 50, 20, $ES_READONLY)
	$Mwin_label[17] = GUICtrlCreateLabel("Known", 620, ($Mwin_imagebox_maxheight + 80), 50, 20, $ES_READONLY)
	$Mwin_info[18] = GUICtrlCreateInput("", 680, ($Mwin_imagebox_maxheight + 60), 50, 20, $ES_READONLY)
	$Mwin_label[18] = GUICtrlCreateLabel("Unknown", 680, ($Mwin_imagebox_maxheight + 80), 50, 20, $ES_READONLY)
	$Mwin_info[19] = GUICtrlCreateInput("", 740, ($Mwin_imagebox_maxheight + 60), 50, 20, $ES_READONLY)
	$Mwin_label[19] = GUICtrlCreateLabel("Total", 740, ($Mwin_imagebox_maxheight + 80), 50, 20, $ES_READONLY)

	$Mwin_info[20] = GUICtrlCreateInput("", 620, ($Mwin_imagebox_maxheight + 100), 35, 20, $ES_READONLY)
	$Mwin_label[20] = GUICtrlCreateLabel("Width", 620, ($Mwin_imagebox_maxheight + 120), 35, 20, $ES_READONLY)
	$Mwin_info[21] = GUICtrlCreateInput("", 665, ($Mwin_imagebox_maxheight + 100), 35, 20, $ES_READONLY)
	$Mwin_label[21] = GUICtrlCreateLabel("Height", 665, ($Mwin_imagebox_maxheight + 120), 35, 20, $ES_READONLY)
	$Mwin_info[22] = GUICtrlCreateInput("", 710, ($Mwin_imagebox_maxheight + 100), 35, 20, $ES_READONLY)
	$Mwin_label[22] = GUICtrlCreateLabel("XPos", 710, ($Mwin_imagebox_maxheight + 120), 35, 20, $ES_READONLY)
	$Mwin_info[23] = GUICtrlCreateInput("", 755, ($Mwin_imagebox_maxheight + 100), 35, 20, $ES_READONLY)
	$Mwin_label[23] = GUICtrlCreateLabel("YPos", 755, ($Mwin_imagebox_maxheight + 120), 35, 20, $ES_READONLY)

	$Mwin_info[31] = GUICtrlCreateInput("", 10, ($Mwin_imagebox_maxheight + 220), 385, 20, $ES_READONLY)
	$Mwin_label[31] = GUICtrlCreateLabel("Chars Not Found", 10, ($Mwin_imagebox_maxheight + 240), 385, 20, $ES_READONLY)
	GUICtrlSetFont($Mwin_info[31], 7, 400, 0)

	$Mwin_info[32] = GUICtrlCreateInput("", 405, ($Mwin_imagebox_maxheight + 220), 385, 20, $ES_READONLY)
	$Mwin_label[32] = GUICtrlCreateLabel("Chars Found", 405, ($Mwin_imagebox_maxheight + 240), 385, 20, $ES_READONLY)
	GUICtrlSetFont($Mwin_info[32], 7, 400, 0)

	Return "success"

EndFunc   ;==>CreateMainWindow

Func CheckButtons() ; Check done

	Local $msg, $result

	; Check the buttons
	$msg = GUIGetMsg()

	; Close the window
	If $msg = $GUI_EVENT_CLOSE Then
		$Misc_exitscriptflag = 1
		Return "exit"

		; Buttons allowed at any stage

	ElseIf $msg = $Mwin_button[1] Then
		; Don't allow image capture if pixel colour is being chosen
		If $Flag_pixelcolour_current = 0 Then
			$Flag_imagecapture_current = 1
			CaptureImage()
			$Flag_imagecapture_current = 0
		EndIf

	ElseIf $msg = $Mwin_button[3] Then
		; Don't allow pixel colour choice if image capture is being done
		If $Flag_imagecapture_current = 0 Then
			$Flag_pixelcolour_current = 1
			CaptureColour()
			$Flag_pixelcolour_current = 0
		EndIf
		
		; Buttons allowed only when an image and target colours have been chosen
	ElseIf $Flag_imagecaptured = 1 And $Flag_pixelcolourchosen = 1 Then

		; React to button clicks
		Switch $msg

			Case $Mwin_hiddenbutton1
				$Image_currentname = GUICtrlRead($Mwin_info[9])	
				GUICtrlSetData($Mwin_info[9], "SAVED")
				Sleep(500)
				GUICtrlSetData($Mwin_info[9], "")
			Case $Mwin_button[4] ; Save details
				SaveDetails()
			Case $Mwin_button[5] ; Scrape Text
				ScrapeText()
			Case $Mwin_button[11] ; Up
				MoveUpChar()
			Case $Mwin_button[12] ; Down
				MoveDownChar()
			Case $Mwin_button[13] ; Delete
				DeleteChar()
			Case $Mwin_button[14] ; Split
				SplitChar()
			Case $Mwin_button[15] ; Size Sort
				SortChars("size")
			Case $Mwin_button[16] ; Ascii Sort
				SortChars("ascii")
			Case $Mwin_button[17] ; Undo
				UndoLastChange()
			Case $Mwin_button[18] ; Undo All
				UndoAllChanges()
			Case $Mwin_button[19] ; Save
				$result = SaveData_Raw()
				If $result <> "fail" Then 
					SaveData_AutoIT()
					If $result <> "fail" Then 
						MsgBox(1, $Script_name, "Character save completed")
					EndIf
				EndIf
			Case $Mwin_hiddenbutton2
				EnterChar(GUICtrlRead($Mwin_info[14])) ; Enter char edit control
		EndSwitch
	EndIf

	Return "success"

EndFunc   ;==>CheckButtons

Func CheckCursor() ; Check done

	Local $oldmode, $position, $xpos, $ypos

	; Set default mode, but remember the old one
	$oldmode = Opt("MouseCoordMode")
	Opt("MouseCoordMode", 2) ; Use the client window

	; If cursor is above the image, display the cursor position
	$position = MouseGetPos()
	If $position[0] >= $Mwin_imagebox_xposition And $position[0] <= ($Mwin_imagebox_xposition + $Image_width - 1) And $position[1] >= $Mwin_imagebox_yposition And $position[1] <= ($Mwin_imagebox_yposition + $Image_height - 1) Then
		; The mouse is over the image, so report its position
		$xpos = $position[0] - $Mwin_imagebox_xposition + 1
		$ypos = $position[1] - $Mwin_imagebox_yposition + 1
		GUICtrlSetData($Mwin_info[3], $xpos & "x" & $ypos)
	Else
		GUICtrlSetData($Mwin_info[3], "")
	EndIf

	; Reset default mode
	Opt("MouseCoordMode", $oldmode) ; Use the client window

	Return "success"

EndFunc   ;==>CheckCursor

; Image capture functions

Func CaptureImage() ; Check done

	Local $xy_window, $xy_client, $xy_absolute, $currentpixel, $text
	Local $exitloopflag

	Local $region_topx_absolute, $region_topx_window, $region_topx_client
	Local $region_topy_absolute, $region_topy_window, $region_topy_client
	Local $region_bottomx_absolute, $region_bottomx_window, $region_bottomx_client
	Local $region_bottomy_absolute, $region_bottomy_window, $region_bottomy_client
	Local $region_width, $region_height

	; Default mode
	Opt("MouseCoordMode", 1) ; Use the whole screen
	Opt("PixelCoordMode", 1) ; Use the whole screen

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
			$currentpixel = PixelGetColor($xy_absolute[0], $xy_absolute[1])
			$text = "Find the top-left corner" & @LF & "   and press F1 (ESC to quit)" & @LF
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
			$currentpixel = PixelGetColor($xy_absolute[0], $xy_absolute[1])
			$text = "Find the bottom-right corner" & @LF & "   and press F1 (ESC to quit)" & @LF
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
		If $region_width > $Mwin_imagebox_maxwidth Or $region_height > $Mwin_imagebox_maxheight Then
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
	$Image_topx_absolute = $region_topx_absolute
	$Image_topy_absolute = $region_topy_absolute
	$Image_topx_window = $region_topx_window
	$Image_topy_window = $region_topy_window
	$Image_topx_client = $region_topx_client
	$Image_topy_client = $region_topy_client
	$Image_bottomx_absolute = $region_bottomx_absolute
	$Image_bottomy_absolute = $region_bottomy_absolute
	$Image_bottomx_window = $region_bottomx_window
	$Image_bottomy_window = $region_bottomy_window
	$Image_bottomx_client = $region_bottomx_client
	$Image_bottomy_client = $region_bottomy_client
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
	; If the complementary flag is also set, make the input box available
	If $Flag_pixelcolourchosen = 1 Then 
		GUICtrlSetState($Mwin_info[9], $GUI_DISABLE)
	EndIf
	
	Return "success"

EndFunc   ;==>CaptureImage

Func RefreshImage() ; Check done

	Local $xposition, $yposition

	; Default mode
	Opt("MouseCoordMode", 2) ; Use the client area
	Opt("PixelCoordMode", 2) ; Use the client area

	; Destroy and recreate the image control
	GUICtrlDelete($Mwin_imagebox)
	$Mwin_imagebox = GUICtrlCreatePic("", 10, 10, 0, 0)

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
	GUICtrlSetData($Mwin_info[10], $Image_currentfile)
	
	Return "success"

EndFunc   ;==>RefreshImage

Func RefreshLocator()
	
	Local $bitmap, $graphics
	
	; Make sure there is a character to locate
	If $Char_current = 0 OR $Char_current = "" Then 
		Return "fail"
	ElseIf $Char_array_xpos[$Char_current] = "" Then 
		Return "fail"
	EndIf
		
	; Initialize GDI+ library
    _GDIPlus_Startup ()
	
	; Draw the locator
	$bitmap = _GDIPlus_BitmapCreateFromHBITMAP($Image_handle)
	$graphics = _GDIPlus_ImageGetGraphicsContext($bitmap)
	
	_GDIPlus_GraphicsDrawRect($graphics, ($Char_array_xpos[$Char_current] - 1), ($Char_array_ypos[$Char_current] - 1), ($Char_array_width[$Char_current] + 2),  ($Char_array_height[$Char_current] + 2))
	
;	; Refresh the image?
;	$Image_handle = $graphics
;	RefreshImage()
	
   ; Initialize GDI+ library
   _GDIPlus_ShutDown () 

	Return "success"

EndFunc

; Colour capture functions

Func CaptureColour() ; Check done

	Local $xy, $currentpixel

	; Default mode
	Opt("MouseCoordMode", 1) ; Use the whole screen
	Opt("PixelCoordMode", 1) ; Use the whole screen

	; Move the currently selected colours one to the right, making the third (now fourth) colour invisible on the screen
	$Pixel_target[4] = $Pixel_target[3]
	$Pixel_target[3] = $Pixel_target[2]
	$Pixel_target[2] = $Pixel_target[1]
	GUICtrlSetBkColor($Mwin_info[33], $Pixel_emptyboxcolour)
	GUICtrlSetBkColor($Mwin_info[34], $Pixel_target[2])
	GUICtrlSetBkColor($Mwin_info[35], $Pixel_target[3])

	$Hotkey_press = ""
	Do
		$xy = MouseGetPos()
		$currentpixel = PixelGetColor($xy[0], $xy[1])
		ToolTip("Find the text colour" & @LF & "   and press F1 (ESC to quit)" & @LF & "Pixel color = " & $currentpixel)
		GUICtrlSetBkColor($Mwin_info[33], $currentpixel)
		; Update the display of the mouse's position in the client window
		CheckCursor()
		Sleep(100)
	Until $Hotkey_press <> ""

	If $Hotkey_press = "escape" Then
		ToolTip("")
		; Move the currently selected colours back to the left
		$Pixel_target[1] = $Pixel_target[2]
		$Pixel_target[2] = $Pixel_target[3]
		$Pixel_target[3] = $Pixel_target[4]
		GUICtrlSetBkColor($Mwin_info[33], $Pixel_target[1])
		GUICtrlSetBkColor($Mwin_info[34], $Pixel_target[2])
		GUICtrlSetBkColor($Mwin_info[35], $Pixel_target[3])
		Return "fail"
	Else
		ToolTip("")
		$xy = MouseGetPos()
		$Pixel_target[1] = PixelGetColor($xy[0], $xy[1])
		GUICtrlSetBkColor($Mwin_info[33], $Pixel_target[1])
		GUICtrlSetData($Mwin_label[33], $Pixel_target[1])

		$Pixel_number = $Pixel_number + 1
		If $Pixel_number > 3 Then
			$Pixel_number = 3
			$Pixel_target[4] = 0
		EndIf
		
		; Set the "colour chosen" flag
		$Flag_pixelcolourchosen = 1
		; If the complementary flag is also set, make the input box available
		If $Flag_imagecaptured = 1 Then 
			GUICtrlSetState($Mwin_info[9], $GUI_ENABLE)
		EndIf
	
		Return "success"
	EndIf

EndFunc   ;==>CaptureColour

; Text scraping functions

Func ScrapeText() ; Check done

	Local $region_topx, $region_topy, $region_bottomx, $region_bottomy, $a
	Local $match, $count, $duplicatecount

	; Default mode
	Opt("PixelCoordMode", 2) ; Use the client window

	; Set the coordinates of the region to be searched
	$region_topx = $Mwin_imagebox_xposition
	$region_topy = $Mwin_imagebox_yposition
	$region_bottomx = $Mwin_imagebox_xposition + $Image_width - 1
	$region_bottomy = $Mwin_imagebox_yposition + $Image_height - 1

	; Reset the progress labels
	GUICtrlSetData($Mwin_label[11], "Scrape characters")
	GUICtrlSetData($Mwin_label[12], "Process duplicates")

	; Search the region, horizontal strip after horizontal strip
	$Misc_scrapecharcount = 0
	ScrapeText_SearchStage1($region_topx, $region_topy, $region_bottomx, $region_bottomy)

	; Set the progress bar to 100%
	GUICtrlSetData($Mwin_info[11], 100)
	GUICtrlSetData($Mwin_label[11], "Scraped " & $Misc_scrapecharcount & " chars")

	; If at least one char was scraped...
	If $Misc_scrapecharcount > 0 Then

		; Search the character array, and remove duplicates - first 50% of the progress bar
		$duplicatecount = ScrapeText_RemoveDuplicates()
		; Search the character array, and move all non-blank elements to the top of the array - second 50%
		ScrapeText_RemoveBlanks()
		; If this isn't the first scrape, remove any undo information
		If $Char_changenumber > 0 Then
			ScrapeText_ResetUndo()
		EndIf
		; Now that the progress bar has reached 100%, show the number of duplicates
		GUICtrlSetData($Mwin_label[12], $duplicatecount & " duplicates")

		; Display the first char in the char box
		MoveDownChar()

		; Set and display the not found string
		$Char_notfoundstring = $Misc_standardstring
		GUICtrlSetData($Mwin_info[31], $Char_notfoundstring)

		; Disable the file save box
		GUICtrlSetState($Mwin_info[9], $GUI_DISABLE)
		; Enable the character entry box
		GUICtrlSetState($Mwin_info[14], $GUI_ENABLE)
		$Mwin_hiddenbutton2 = GUICtrlCreateButton("", 10, ($Mwin_height - 50), 10, 10, $BS_DEFPUSHBUTTON)
		GUICtrlSetState(-1, $GUI_HIDE)
		
	EndIf

	Return "success"

EndFunc   ;==>ScrapeText

Func ScrapeText_SearchStage1($topx, $topy, $bottomx, $bottomy)

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
		If $count > $Char_maxheight Or $line > $bottomy Then
			; Give up, use the old top horizontal line
			$matchline = $topy
		Else
			$result = JPixelSearch($topx, $line, $bottomx, $line)
			If $result = "fail" Then
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
		If $count > $Char_maxheight Or $line < $topy Then
			; Give up
			$matchline = $bottomy
		Else
			$result = JPixelSearch($topx, $line, $bottomx, $line)
			If $result = "fail" Then
				$matchline = $line
			EndIf
		EndIf
	Until $matchline > 0

	$newbottomy = $matchline

	; Make the changes to the search region
	$topy = $newtopy
	$bottomy = $newbottomy

	; Now search the narrowed region
	ScrapeText_SearchStage2($topx, $topy, $bottomx, $bottomy)

	Return "success"

EndFunc   ;==>ScrapeText_SearchStage1

Func ScrapeText_SearchStage2($topx, $topy, $bottomx, $bottomy) ; check done

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
			$result = JPixelSearch($topx, $line, $bottomx, $line)
			If $result = "fail" Then
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
		Until $finishedflag = 1 Or $matchline <> ""

		If $finishedflag = 0 And $matchline <> "" Then

			; Set the start line
			$startline = $matchline

			; Find the end line, the last line containing the pixel colour, starting one below the start line
			$line = $startline
			$matchline = ""
			Do
				$line = $line + 1
				$result = JPixelSearch($topx, $line, $bottomx, $line)
				If $result = "fail" Then
					; Target pixel wasn't found in this line, make it the end line plus one
					$matchline = $line
				ElseIf $line >= $bottomy Then
					; We have reached the end of the search region, end the search
					$finishedflag = 1
				EndIf
				; Continue until a line without the pixel is found, or the end of the search region is reached
			Until $finishedflag = 1 Or $matchline <> ""

			If $matchline <> "" Then
				; Set the end line to be one above the match line
				$endline = $matchline - 1
			ElseIf $finishedflag = 1 Then
				; Set the end line to be the bottom of the search region
				$endline = $bottomy
			EndIf

			; If a start line and end line was found, search the region enclosed by them
			If $endline <> "" Then
				ScrapeText_SearchStage3($topx, $startline, $bottomx, $endline)
			EndIf
		EndIf

		; Repeat the loop until the end of the search region has been reached
	Until $finishedflag = 1

	Return "success"

EndFunc   ;==>ScrapeText_SearchStage2

Func ScrapeText_SearchStage3($topx, $topy, $bottomx, $bottomy)

	; First narrow the search region hoping to remove any partially-visible characters at the left and right of the search region

	Local $column, $matchcolumn, $count, $result, $newtopx
	Local $newbottomx

	; Move the leftmost vertical column to the right
	$column = $topx - 1
	$matchcolumn = ""
	$count = 0
	Do

		$column = $column + 1
		$count = $count + 1
		If $count > $Char_maxwidth Or $column > $bottomx Then
			; Don't narrow the search region from the left side
			$matchcolumn = $topx
		Else
			$result = JPixelSearch($column, $topy, $column, $bottomy)
			If $result = "fail" Then
				$matchcolumn = $column
			EndIf
		EndIf
	Until $matchcolumn > 0

	$newtopx = $matchcolumn

	; Move the rightmost vertical column to the left
	$column = $bottomx + 1
	$matchcolumn = ""
	$count = 0
	Do

		$column = $column - 1
		$count = $count + 1
		If $count > $Char_maxwidth Or $column < $topy Then
			; Don't narrow the search region from the right side
			$matchcolumn = $bottomx
		Else
			$result = JPixelSearch($column, $topy, $column, $bottomy)
			If $result = "fail" Then
				$matchcolumn = $column
			EndIf
		EndIf
	Until $matchcolumn > 0

	$newbottomx = $matchcolumn

	; Make the changes to the search region
	$topx = $newtopx
	$bottomx = $newbottomx

	; Now search the narrowed region
	ScrapeText_SearchStage4($topx, $topy, $bottomx, $bottomy)

	Return "success"

EndFunc   ;==>ScrapeText_SearchStage3

Func ScrapeText_SearchStage4($topx, $topy, $bottomx, $bottomy) ; check done

	; Search the region, vertical strip after vertical strip

	Local $startcolumn, $endcolumn, $column, $result, $matchcolumn
	Local $finishedflag = 0

	$startcolumn = $topx - 1
	$endcolumn = $topx - 1
	Do

		; Find the start column, starting one to the right of the last end column
		$column = $endcolumn
		$matchcolumn = ""
		Do
			$column = $column + 1
			$result = JPixelSearch($column, $topy, $column, $bottomy)
			If $result = "fail" Then
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
		Until $finishedflag = 1 Or $matchcolumn <> ""

		If $finishedflag = 0 And $matchcolumn <> "" Then

			; Set the start column
			$startcolumn = $matchcolumn

			; Find the end column, the last column containing the target pixel colour, starting one to the right
			; of the start column
			$column = $startcolumn
			$matchcolumn = ""
			Do
				$column = $column + 1
				$result = JPixelSearch($column, $topy, $column, $bottomy)
				If $result = "fail" Then
					; Target pixel wasn't found in this column, make this the end column plus one
					$matchcolumn = $column
				ElseIf $column >= $bottomx Then
					; We have reached the end of the search region, end the search
					$finishedflag = 1
				EndIf
				; Continue until a column without the pixel is found, or the end of the search region is reached
			Until $finishedflag = 1 Or $matchcolumn <> ""

			If $matchcolumn <> "" Then
				; Set the end column to be one to the left of the match column
				$endcolumn = $matchcolumn - 1
			ElseIf $finishedflag = 1 Then
				; Set the end column to be the right boundary of the search region
				$endcolumn = $bottomx
			EndIf

			; If a start column and end column were found, search the region enclosed by them
			If $endcolumn <> "" Then
				ScrapeText_SearchStage5($startcolumn, $topy, $endcolumn, $bottomy)
			EndIf
		EndIf

		; Repeat the loop until the end of the search region has been reached
	Until $finishedflag = 1

	Return "success"

EndFunc   ;==>ScrapeText_SearchStage4

Func ScrapeText_SearchStage5($topx, $topy, $bottomx, $bottomy) ; check done

	; Narrow the search region to contain only the top and bottom of the character, and if this is larger
	; than the maximum height, reduce it

	Local $startlevel, $endlevel, $level, $result
	Local $finishedflag = 0

	; Find the start level, starting one above the top of the region
	$level = $topy - 1
	Do
		$level = $level + 1
		$result = JPixelSearch($topx, $level, $bottomx, $level)
		If $result = "fail" Then
			; No pixels of the right colour found on this level
		Else
			; Target pixel was found, make this the start level
			$startlevel = $level
		EndIf
		; If the bottom of the search region is reached, forget about scraping characters in this region
		If $level >= $bottomy Then
			$finishedflag = 1
		EndIf
		; Continue until a match is found, or the end of the search region is reached
	Until $finishedflag = 1 Or $startlevel <> ""

	If $finishedflag = 0 Then

		$level = $bottomy + 1
		Do
			$level = $level - 1
			$result = JPixelSearch($topx, $level, $bottomx, $level)
			If $result = "fail" Then
				; No pixels of the right colour found on this level
			Else
				; Target pixel was found, make this the end level
				$endlevel = $level
			EndIf
			; If the bottom of the search region is reached, mark it as the endline
			If $level >= $bottomy Then
				$endlevel = $bottomy
			EndIf
		; Continue until a match is found, or the end of the search region is reached
		Until $endlevel <> ""

		; Check that the search region isn't bigger than the maximum character size
		ScrapeText_SearchStage6($topx, $startlevel, $bottomx, $endlevel)
	EndIf

	Return "success"

EndFunc   ;==>ScrapeText_SearchStage5

Func ScrapeText_SearchStage6($topx, $topy, $bottomx, $bottomy)
	
	; The search region should now contain a single character. If the region is bigger than the maximum allowed
	; character size, reduce the size of the region by raising the bottom line and moving the right line to the left

	; Raise the bottom line, if necessary
	If ($bottomy - $topy + 1) > $Char_maxheight Then 
		$bottomy = $topy + $Char_maxheight - 1
		Beep(2000, 100)
	EndIf
	; Move the right line to the left, if necessary
	If ($bottomx - $topx + 1) > $Char_maxwidth Then 
		$bottomx = $topx + $Char_maxwidth - 1
		Beep(2000, 100)
	EndIf
	
	; Scrape the character contained in the region enclosed by the start and end levels
	ScrapeText_ScrapeChar($topx, $topy, $bottomx, $bottomy)
	
	Return "success"
	
EndFunc
		
Func ScrapeText_ScrapeChar($topx, $topy, $bottomx, $bottomy) ; check done

	; Scrape the character occupying the region bounded by the function arguments

	Local $match, $count, $pixel, $window_countx, $window_county
	Local $char_countx, $char_county

	; Find a gap in the character array
	$match = 0
	$count = 0
	Do
		$count = $count + 1
		If $Char_array_chr[$count] = "" Then
			$match = $count
		EndIf
	Until $match > 0 Or $count = $Char_maxchars

	If $match = 0 Then
		Return "fail"
	Else

		; Scrape the character and store it in char array position $match, but ignore anything outside
		; the maximum character size
		$window_county = $topy - 1 ; Count the window pixels from top to bottom
		$char_county = 0 ; Count the char pixels from top to bottom
		Do
			$window_county = $window_county + 1
			$char_county = $char_county + 1
			If $char_county <= $Char_maxheight Then

				$window_countx = $topx - 1 ; Count the window pixels from left to right
				$char_countx = 0 ; Count the char pixels from left to right
				Do
					$window_countx = $window_countx + 1
					$char_countx = $char_county + 1
					If $char_countx <= $Char_maxwidth Then

						$pixel = PixelGetColor($window_countx, $window_county)
						If $pixel = $Pixel_target[1] Or $pixel = $Pixel_target[2] Or $pixel = $Pixel_target[3] Then
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

		; Set the total number of scraped chars during this pass
		$Misc_scrapecharcount = $Misc_scrapecharcount + 1

		Return "success"
	EndIf

EndFunc   ;==>ScrapeText_ScrapeChar

Func ScrapeText_RemoveDuplicates() ; check done

	; Remove duplicates from the character array

	Local $char, $compare, $match, $count, $a
	Local $duplicatecount

	$duplicatecount = 0

	For $char = 1 To $Char_maxchars

		; Set the progress bar - this stage represents the first 50% of the bar
		GUICtrlSetData($Mwin_info[12], (($char / $Char_maxchars) * 50))

		; Process only full elements in the array
		If $Char_array[$char][1] <> "" Then

			For $compare = $char To $Char_maxchars

				; Don't compare the char to itself, and only process full elements in the array
				If $char <> $compare And $Char_array[$compare][1] <> "" Then

					$match = 0
					$count = 0
					Do
						$count = $count + 1
						If $Char_array[$char][$count] <> $Char_array[$compare][$count] Then
							$match = $count
						EndIf
					Until $match > 0 Or $count = $Char_maxheight

					; If match is 0, the chars are identical, so delete the higher one
					If $match = 0 Then
						$duplicatecount = $duplicatecount + 1
						For $a = 0 To $Char_maxheight
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

EndFunc   ;==>ScrapeText_RemoveDuplicates

Func ScrapeText_RemoveBlanks()

	Local $maincount, $match, $count, $a

	$maincount = 0

	Do
		$maincount = $maincount + 1

		; Set the progress bar - this stage represents the second 50% of the bar
		GUICtrlSetData($Mwin_info[12], (($maincount / $Char_maxchars) * 50) + 50)

		; If this array element is empty, find the next non-empty element and move it here
		If $Char_array_chr[$maincount] = "" Then

			$match = 0
			$count = $maincount

			Do
				$count = $count + 1
				If $Char_array_chr[$count] <> "" Then
					$match = $count
				EndIf
			Until $match > 0 Or $count = $Char_maxchars

			If $match > 0 Then
				; Copy the character
				For $a = 1 To $Char_maxheight
					$Char_array[$maincount][$a] = $Char_array[$match][$a]
				Next
				$Char_array_chr[$maincount] = $Char_array_chr[$match]
				$Char_array_width[$maincount] = $Char_array_width[$match]
				$Char_array_height[$maincount] = $Char_array_height[$match]
				$Char_array_xpos[$maincount] = $Char_array_xpos[$match]
				$Char_array_ypos[$maincount] = $Char_array_ypos[$match]
				; Delete the old copy
				For $a = 1 To $Char_maxheight
					$Char_array[$match][$a] = ""
				Next
				$Char_array_chr[$match] = ""
				$Char_array_width[$match] = ""
				$Char_array_height[$match] = ""
				$Char_array_xpos[$match] = ""
				$Char_array_ypos[$match] = ""
			EndIf
		EndIf

		; Continue until the last-but-one element
	Until $maincount = $Char_maxchars - 1

	Return "success"

EndFunc   ;==>ScrapeText_RemoveBlanks

Func ScrapeText_ResetUndo()

	; Scraping for the second or subsequent times removes the ability to undo changes

	$Char_changecount = 0
	$Char_splitnumber = ""
	$Char_splitchar1 = ""
	$Char_splitchar2 = ""
	$Char_presplit_chr = ""
	$Char_presplit_width = ""
	$Char_presplit_height = ""
	$Char_presplit_xpos = ""
	$Char_presplit_ypos = ""
	For $a = 1 To $Char_maxchars
		$Char_changenumber[$a] = ""
	Next
	For $a = 1 To $Char_maxheight
		$Char_presplit[$a] = ""
	Next

	Return "success"

EndFunc   ;==>ScrapeText_ResetUndo

Func JPixelSearch($topx, $topy, $bottomx, $bottomy)

	; A replacement for PixelSearch() that finds pixels of up to three different colours
	; Look for one of the up to three pixel colours in the specified region
	; First look for colour 1, then colour 2, then colour 3
	; If the pixel is found on any search, returns the result of PixelSearch(), otherwise returns "fail"
	
	Local $result
			
	If $Pixel_number = 0 Then
		Return "fail"

	ElseIf $Pixel_number = 1 Then
		$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Pixel_target[1])
		If @error Then 
			Return "fail"
		Else
			Return $result
		EndIf
		
	ElseIf $Pixel_number = 2 Then
		$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Pixel_target[1])
		If @error Then
			$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Pixel_target[2])
			If @error Then 
				Return "fail"
			Else
				Return $result
			EndIf
		Else
			Return $result
		EndIf

	ElseIf $Pixel_number = 3 Then
		$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Pixel_target[1])
		If @error Then
			$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Pixel_target[2])
			If @error Then
				$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Pixel_target[3])
				If @error Then 
					Return "fail"
				Else
					Return $result
				EndIf
			Else
				Return $result
			EndIf
		Else
			Return $result
		EndIf

	EndIf

EndFunc   ;==>JPixelSearch

; Char set functions

Func DisplayChar($number) ; check done

	Local $text, $line, $x, $y, $known
	Local $unknown, $count, $width, $height

	; Default mode
	Opt("PixelCoordMode", 2) ; Use the client window

	; If $number is 0, (probably because all characters are known) display a blank character
	If $number = 0 Then

		; Update the display
		GUICtrlSetData($Mwin_charbox, $text)

		; Count the number of known and unknown chars
		$unknown = 0
		$known = 0
		For $a = 1 To $Char_maxchars
			If $Char_array[$a][1] <> "" Then
				If $Char_array_chr[$a] = "^" Then
					$unknown = $unknown + 1
				Else
					$known = $known + 1
				EndIf
			EndIf
		Next

		; Update the accompanying info boxes
		GUICtrlSetData($Mwin_info[15], "")
		GUICtrlSetData($Mwin_info[16], "")
		GUICtrlSetData($Mwin_info[17], $known)
		GUICtrlSetData($Mwin_info[18], $unknown)
		GUICtrlSetData($Mwin_info[19], $known + $unknown)
		GUICtrlSetData($Mwin_info[20], "")
		GUICtrlSetData($Mwin_info[21], "")
		GUICtrlSetData($Mwin_info[22], "")
		GUICtrlSetData($Mwin_info[23], "")

		; Refresh the image to remove the locator
		RefreshImage()
		
	; Otherwise, display the character
	Else

		; Display a line of height numbers above the character
		$count = 0
		$width = 0
		$line = "  "
		Do
			$width = $width + 1
			$count = $count + 1
			If $count = 10 Then
				$count = 0
			EndIf
			$line = $line & $count
		Until $width = $Char_array_width[$number]
		$text = $line 

		; Prepare the text to display, starting with the width number
		$height = 0
		For $y = 1 To $Char_array_height[$number]

			$height = $height + 1
			If $height = 10 Then
				$height = 0
			EndIf

			; Compose a line that's more easily readable
			$line = $height & " "

			If StringLen($Char_array[$number][$y]) > 0 Then
				For $x = 1 To StringLen($Char_array[$number][$y])
					If StringMid($Char_array[$number][$y], $x, 1) = "x" Then
						$line = $line & "#"
					Else
						$line = $line & " "
					EndIf
				Next
			EndIf

			; Add the line to the text that will be displayed
			$text = $text & @CRLF & $line 
		Next

	EndIf

	; Update the display
	GUICtrlSetData($Mwin_charbox, $text)

	; Count the number of known and unknown chars
	$unknown = 0
	$known = 0
	For $a = 1 To $Char_maxchars
		If $Char_array[$a][1] <> "" Then
			If $Char_array_chr[$a] = "^" Then ; Marked unknown
				$unknown = $unknown + 1
			ElseIf $Char_array_chr[$a] <> "|" Then ; Not marked deleted
				$known = $known + 1
			EndIf
		EndIf
	Next

	; Update the accompanying info boxes
	If $Char_array_chr[$number] = "^" Then
		GUICtrlSetData($Mwin_info[15], "???")
	Else
		GUICtrlSetData($Mwin_info[15], $Char_array_chr[$number])
	EndIf
	GUICtrlSetData($Mwin_info[16], $number)
	GUICtrlSetData($Mwin_info[17], $known)
	GUICtrlSetData($Mwin_info[18], $unknown)
	GUICtrlSetData($Mwin_info[19], $known + $unknown)
	GUICtrlSetData($Mwin_info[20], $Char_array_width[$number])
	GUICtrlSetData($Mwin_info[21], $Char_array_height[$number])
	GUICtrlSetData($Mwin_info[22], $Char_array_xpos[$number])
	GUICtrlSetData($Mwin_info[23], $Char_array_ypos[$number])

	; Refresh the image to remove the old locator
	RefreshImage()
	; Draw a new locator
	RefreshLocator()
	
	Return "success"

EndFunc   ;==>DisplayChar

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
	Until $match > 0 Or $count = $Char_current

	If $count = $Char_current Then
		; Display an empty character
		DisplayChar(0)
	Else
		$Char_current = $match
		; Display the char
		DisplayChar($Char_current)
		; Disable the input box
		GUICtrlSetState($Mwin_info[14], $GUI_DISABLE)
	EndIf

	Return "success"

EndFunc   ;==>MoveUpChar

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
		If $Char_array_chr[$count] = "^" Then
			$match = $count
		EndIf
	Until $match > 0 Or $count = $Char_current

	If $count = $Char_current Then
		; Display an empty character
		DisplayChar(0)
		; Disable the input box
		GUICtrlSetState($Mwin_info[14], $GUI_DISABLE)
	Else
		$Char_current = $match
		; Display the char
		DisplayChar($Char_current)
	EndIf

	Return "success"

EndFunc   ;==>MoveDownChar

Func EnterChar($string)

	; If the string is empty, ignore it
	If StringLen($string) = 0 Then
		Return "fail"
	Else

		; Mark the current character as known
		$Char_array_chr[$Char_current] = $string
		$Char_changecount = $Char_changecount + 1
		$Char_changenumber[$Char_current] = $Char_changecount

		; Move the character or characters $string from the not found list to the found list
		CharNotfoundToFound($string)

		; Find and display the next character
		MoveDownChar()

		; Empty the input box
		GUICtrlSetData($Mwin_info[14], "")

	EndIf

	Return "success"

EndFunc   ;==>EnterChar

Func CharNotfoundToFound($string)

	; Move the character $string from the not found to the found list

	Local $position, $match, $count

	; If the entered string is just one character long...
	If StringLen($string) = 1 Then

		; Look for the string in the unknown character list, '1' makes the search case sensitive
		$position = StringInStr($Char_notfoundstring, $string, 1)
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
			Until $match > 0 Or $count = StringLen($Char_foundstring) Or StringMid($Char_foundstring, $count, 1) = "["
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

	Return "success"

EndFunc   ;==>CharNotfoundToFound

Func CharFoundToNotFound($string)

	; Move the character $string from the found to the not found list

	Local $position, $match, $count

	; If the entered string is just one character long...
	If StringLen($string) = 1 Then

		; Look for the string in the found character list, '1' makes the search case sensitive
		$position = StringInStr($Char_foundstring, $string, 1)
		If $position <> 0 Then
			; If it's there, remove it
			$Char_foundstring = StringLeft($Char_foundstring, ($position - 1)) & StringRight($Char_foundstring, (StringLen($Char_foundstring) - $position))
		EndIf
		; Transfer $string to the not found character list
		If StringLen($Char_notfoundstring) = 0 Then
			$Char_notfoundstring = $string
		Else
			; Find the first character which has a higher ASCII than $string, and put $string just before it,
			; but stop when [..] is reached
			$match = 0
			$count = 0
			Do
				$count = $count + 1
				If Asc(StringMid($Char_notfoundstring, $count, 1)) > Asc($string) Then
					$match = $count
				EndIf
			Until $match > 0 Or $count = StringLen($Char_notfoundstring)
			If $match = 0 Then
				$Char_notfoundstring = $Char_notfoundstring & $string
			Else
				$Char_notfoundstring = StringLeft($Char_notfoundstring, ($match - 1)) & $string & StringRight($Char_notfoundstring, (StringLen($Char_notfoundstring) - $match + 1))
			EndIf
		EndIf

		; If the entered string is longer than one character, delete it and its brackets from the found character list
	ElseIf StringLen($string) > 1 Then

		$string = "[" & $string & "]"
		$position = StringInStr($Char_foundstring, $string, 1)
		If $position <> 0 Then
			; If it's there (no reason why it shouldn't be), remove it
			$Char_foundstring = StringLeft($Char_foundstring, ($position - 1)) & StringRight($Char_foundstring, (StringLen($Char_foundstring) - $position - StringLen($string) + 1))
			$Char_foundstring = StringLeft($Char_foundstring, ($position - 1))
		EndIf
	EndIf

	; Update the foundstring/notfoundstring boxes
	GUICtrlSetData($Mwin_info[31], $Char_notfoundstring)
	GUICtrlSetData($Mwin_info[32], $Char_foundstring)

	Return "success"

EndFunc   ;==>CharFoundToNotFound

Func DeleteChar()

	Local $a

	; Mark the current char as "deleted" and move to the next one
	$Char_array_chr[$Char_current] = "|"
	$Char_changecount = $Char_changecount + 1
	$Char_changenumber[$Char_current] = $Char_changecount

	; Find and display the next character
	MoveDownChar()

	Return "success"

EndFunc   ;==>DeleteChar

Func UndoLastChange()

	; Undo the last action in which a character was marked "found" or "deleted", and make that the current character

	Local $originalnumber, $match, $count

	; Don't do anything if no characters have been changed
	If $Char_changecount = 0 Then
		Return "fail"

		; If the last change was a character split, reverse it
	ElseIf $Char_changecount = $Char_splitnumber Then

		$originalnumber = $Char_splitchar1
		UndoSplit()

		; Reset the change count
		$Char_changecount = $Char_changecount - 1

		; Display the recombined character
		$Char_current = $originalnumber
		DisplayChar($Char_current)
		; Reenable the input box, if it was disabled before the undo
		GUICtrlSetState($Mwin_info[14], $GUI_ENABLE)
		
	Else

		; Find the last character changed
		$match = 0
		$count = 0
		Do
			$count = $count + 1
			If $Char_changenumber[$count] = $Char_changecount Then
				$match = $count
			EndIf
		Until $match > 0 Or $count = $Char_maxchars

		If $match > 0 Then
			; Move the character from the found list back to the not found list
			CharFoundToNotFound($Char_array_chr[$match])
			; Mark the character as unknown, and unchanged
			$Char_array_chr[$match] = "^"
			$Char_changenumber[$match] = ""
			; Reset the last changed character
			$Char_changecount = $Char_changecount - 1
			; Display this character
			$Char_current = $match
			DisplayChar($match)

			; Reenable the input box, if it was disabled before the undo
			GUICtrlSetState($Mwin_info[14], $GUI_ENABLE)
		
		EndIf
	EndIf

	Return "success"

EndFunc   ;==>UndoLastChange

Func UndoAllChanges()

	; Mark all characters as "unknown" which might be marked as "found" or "deleted"

	Local $result, $a, $match, $count

	; Don't do anything if no characters have been marked
	If $Char_changecount = 0 Then
		Return "fail"

	Else

		; Get confirmation
		$result = MsgBox(4, $Script_name, "Are you sure? 'Undo all' will mark all scraped characters as 'unknown'")
		; 'no' button was clicked
		If $result = 7 Then
			Return "fail"

			; 'yes' button was clicked
		ElseIf $result = 6 Then

			; If a character has been split, reverse it
			If $Char_changecount = $Char_splitnumber Then
				UndoSplit()
			EndIf

			; Mark all non-empty elements in the character array as "unknown"
			For $a = 1 To $Char_maxchars
				If $Char_array_chr[$a] <> "" Then
					$Char_array_chr[$a] = "^"
					$Char_changenumber[$a] = ""
				EndIf
			Next
			; Reset the not found list
			$Char_notfoundstring = $Misc_standardstring

			; Set the number of changes back to zero
			$Char_changecount = 0

			; Reenable the input box, if it was disabled before the undo
			GUICtrlSetState($Mwin_info[14], $GUI_ENABLE)
			
			; Find the first non-empty element in the array and display it
			$match = 0
			$count = 0
			Do
				$count = $count + 1
				If $Char_array_chr[$count] <> "" Then
					$match = $count
				EndIf
			Until $match > 0 Or $count = $Char_maxchars
			If $match > 0 Then
				$Char_current = $match
				DisplayChar($match)
			EndIf
		EndIf
	EndIf

	Return "success"

EndFunc   ;==>UndoAllChanges

Func UndoSplit()

	; Restore the original char
	For $a = 1 To $Char_maxheight
		$Char_array[$Char_splitchar1][$a] = $Char_presplit[$a]
	Next
	$Char_array_chr[$Char_splitchar1] = "^"
	$Char_array_width[$Char_splitchar1] = $Char_presplit_width
	$Char_array_height[$Char_splitchar1] = $Char_presplit_height
	$Char_array_xpos[$Char_splitchar1] = $Char_presplit_xpos
	$Char_array_ypos[$Char_splitchar1] = $Char_presplit_ypos
	$Char_changenumber[$Char_splitchar1] = ""
	; Remove the secondary char completely
	For $a = 1 To $Char_maxheight
		$Char_array[$Char_splitchar2][$a] = ""
	Next
	$Char_array_chr[$Char_splitchar2] = ""
	$Char_array_width[$Char_splitchar2] = ""
	$Char_array_height[$Char_splitchar2] = ""
	$Char_array_xpos[$Char_splitchar2] = ""
	$Char_array_ypos[$Char_splitchar2] = ""
	$Char_changenumber[$Char_splitchar2] = ""
	; Empty the split variables
	For $a = 1 To $Char_maxheight
		$Char_presplit[$a] = ""
	Next
	$Char_presplit_chr = ""
	$Char_presplit_width = ""
	$Char_presplit_height = ""
	$Char_presplit_xpos = ""
	$Char_presplit_ypos = ""
	$Char_splitchar1 = ""
	$Char_splitchar2 = ""
	$Char_splitnumber = 0

	Return "success"

EndFunc   ;==>UndoSplit

Func SortChars($sorttype)

	; Sort the characters in the char array, smallest first
	; If $sorttype is "size", the array will be sorted by character size, smallest first	( SortChars() returns "success" )
	; If $sorttype is "ascii", the array will be sorted by ASCII code, lowest first 		( SortChars() returns "success" )
	; Other $sorttype strings will be rejected, and sorts will not be done on empty arrays 	( SortChars() returns "fail" )

	Local $match, $count, $number, $a, $b

	; Count the number of non-empty elements in the array
	$count = 0
	For $a = 1 To $Char_maxchars
		If $Char_array_chr[$a] <> "" Then
			$count = $count + 1
		EndIf
	Next
	; Don't do a sort on an empty array
	If $count = 0 Then
		Return "fail"
	EndIf

	; Prepare the local arrays
	Local $sortarray[$count + 1][2]
	Local $local_array[$count + 1][$Char_maxheight + 1]
	Local $local_array_chr[$count + 1]
	Local $local_array_width[$count + 1]
	Local $local_array_height[$count + 1]
	Local $local_array_xpos[$count + 1]
	Local $local_array_ypos[$count + 1]
	Local $local_changenumber[$count + 1]

	; Compile a list of characters and their properties; the routine sorts by $sortarray[n][0]
	For $a = 1 To $count
		If $sorttype = "size" Then
			$sortarray[$a][0] = $Char_array_width[$a] * $Char_array_height[$a]
		ElseIf $sorttype = "ascii" Then
			$sortarray[$a][0] = Asc($Char_array_chr[$a])
		EndIf
		$sortarray[$a][1] = $a
	Next

	; Sort the list, smallest size first
	_ArraySort($sortarray, 0, 0, 0, 0)

	; Copy the char array into a local char array, in the right order
	For $a = 1 To $count

		$number = $sortarray[$a][1]

		For $b = 1 To $Char_maxheight
			$local_array[$a][$b] = $Char_array[$number][$b]
		Next
		$local_array_chr[$a] = $Char_array_chr[$number]
		$local_array_width[$a] = $Char_array_width[$number]
		$local_array_height[$a] = $Char_array_height[$number]
		$local_array_xpos[$a] = $Char_array_xpos[$number]
		$local_array_ypos[$a] = $Char_array_ypos[$number]
		$local_changenumber[$a] = $Char_changenumber[$number]
	Next

	; Copy everything back
	For $a = 1 To $count

		For $b = 1 To $Char_maxheight
			$Char_array[$a][$b] = $local_array[$a][$b]
		Next
		$Char_array_chr[$a] = $local_array_chr[$a]
		$Char_array_width[$a] = $local_array_width[$a]
		$Char_array_height[$a] = $local_array_height[$a]
		$Char_array_xpos[$a] = $local_array_xpos[$a]
		$Char_array_ypos[$a] = $local_array_ypos[$a]
		$Char_changenumber[$a] = $local_changenumber[$a]
	Next

	; Find the first not-found char in the array, and display it
	$match = 0
	$count = 0
	Do
		$count = $count + 1
		If $Char_array_chr[$count] = "^" Then
			$match = $count
		EndIf
	Until $match > 0 Or $count = $Char_maxchars

	If $match > 0 Then
		DisplayChar($match)
	Else
		DisplayChar(0)
	EndIf

	; For ASCII sort, display a popup to confirm the sort is done
	If $sorttype = "ascii" Then
		MsgBox(1, $Script_name, "ASCII sort completed")
	EndIf

	Return "success"

EndFunc   ;==>SortChars

Func SplitChar()

	Local $match, $count, $emptyelement, $msg, $result
	Local $dialogue, $guiquestion, $guibox, $hiddenbutton, $guierrorlabel
	Local $column

	Local $guiwidth = 300
	Local $guiheight = 80

	; Check that the char array isn't full
	$match = 0
	$count = 0
	Do
		$count = $count + 1
		If $Char_array_chr[$count] <> "" Then
			$match = $count
		EndIf
	Until $match > 0 Or $count = $Char_maxchars

	If $match = 0 Then
		MsgBox(0, $Script_name, "Cannot splice: the character list is full")
		Return "fail"
	EndIf

	; Find the first spare place in the character array after the current character
	; If the end of the array is reached, go back to the beginning
	$emptyelement = 0
	$count = $Char_current
	Do
		$count = $count + 1
		If $count = $Char_maxchars Then
			$count = 1
		EndIf
		If $Char_array_chr[$count] = "" Then
			$emptyelement = $count
		EndIf
	Until $emptyelement > 0

	; Ask the user where to split the current character
	$dialogue = GUICreate($Script_name, $guiwidth, $guiheight, -1, -1)
	GUISetState(@SW_SHOW)
	; Ask the question
	$guiquestion = GUICtrlCreateLabel("Which column is the right-most column of the first letter?", 10, 10, ($guiwidth - 20), 20)
	$guibox = GUICtrlCreateInput("", 10, 30, ($guiwidth - 20), 20)
	GUICtrlSetState($guibox, $GUI_ENABLE)
	$hiddenbutton = GUICtrlCreateButton("", 10, (1 - 50), 10, 10, $BS_DEFPUSHBUTTON)
	GUICtrlSetState(-1, $GUI_HIDE)
	$guierrorlabel = GUICtrlCreateLabel("", 10, 50, ($guiwidth - 20), 20)

	; Run the GUI until the dialogue is closed, or a valid value is entered
	While 1

		$result = ""
		Do
			$msg = GUIGetMsg()
			If $msg = $GUI_EVENT_CLOSE Then
				$result = "fail"
			ElseIf $msg = $hiddenbutton Then
				$result = GUICtrlRead($guibox)
				If StringIsInt($result) = 0 Or $result < 1 Or $result > ($Char_array_width[$Char_current] - 1) Then
					GUICtrlSetData($guierrorlabel, "Character is " & $Char_array_width[$Char_current] & " pixels wide, so valid range is 1-" & ($Char_array_width[$Char_current] - 1))
					$result = ""
				EndIf
			EndIf
		Until $result <> ""

		GUIDelete($dialogue)
		; If the user tried to close the GUI, simply return "fail"
		If $result = "fail" Then
			GUIDelete($dialogue)
			Return $result
			; Perform the split char operation on the column $result, and put the new char in element # $empty
		Else

			$column = $result

			; Remember the contents of the current char, so that the operation can be undone with the 'undo' button
			$Char_changecount = $Char_changecount + 1
			$Char_splitnumber = $Char_changecount
			$Char_splitchar1 = $Char_current
			$Char_splitchar2 = $emptyelement
			For $a = 1 To $Char_maxheight
				$Char_presplit[$a] = $Char_array[$Char_current][$a]
			Next
			$Char_presplit_chr = $Char_array_chr[$Char_current]
			$Char_presplit_width = $Char_array_width[$Char_current]
			$Char_presplit_height = $Char_array_height[$Char_current]
			$Char_presplit_xpos = $Char_array_xpos[$Char_current]
			$Char_presplit_ypos = $Char_array_ypos[$Char_current]

			; Now create the new char
			For $a = 1 To $Char_array_height[$Char_current]
				$Char_array[$emptyelement][$a] = StringRight($Char_array[$Char_current][$a], $Char_array_width[$Char_current] - $column)
			Next
			; Remove any blank lines at the top and bottom of the new char
			$Char_array_height[$emptyelement] = RejigChar($emptyelement, ($Char_array_width[$Char_current] - $column), $Char_array_height[$Char_current], $Char_array_ypos[$Char_current])
			; Store the other details ($Char_array_ypos is set by RejigChar() )
			$Char_array_chr[$emptyelement] = "^"
			$Char_array_width[$emptyelement] = $Char_array_width[$Char_current] - $column
			$Char_array_xpos[$emptyelement] = $Char_array_xpos[$Char_current] + $column

			; Now reset the current char
			For $a = 1 To $Char_array_height[$Char_current]
				$Char_array[$Char_current][$a] = StringLeft($Char_array[$Char_current][$a], $column)
			Next
			; Remove any blank lines at the top and bottom of the new char
			$Char_array_height[$Char_current] = RejigChar($Char_current, $column, $Char_array_height[$Char_current], $Char_array_ypos[$Char_current])
			; Store the other details ($Char_array_ypos is set by RejigChar() , $Char_array_xpos stays the same)
			$Char_array_chr[$Char_current] = "^"
			$Char_array_width[$Char_current] = $column

			; Close the dialogue window and re-display the current char
			GUIDelete($dialogue)
			DisplayChar($Char_current)
			Return "success"
		EndIf
	WEnd

EndFunc   ;==>SplitChar

Func RejigChar($element, $oldwidth, $oldheight, $oldypos)

	; Remove any blank lines from the top and bottom of a newly-split character

	Local $count, $a, $startline, $matchline, $endline

	; Find the first non-blank line
	$count = 0
	$startline = 0
	Do
		$count = $count + 1
		If StringInStr($Char_array[$element][$count], "x") <> 0 Then
			$startline = $count
		EndIf
	Until $startline > 0 Or $count = $oldheight

	; Find the next blank line
	$count = $startline
	$matchline = 0
	Do
		$count = $count + 1
		If StringInStr($Char_array[$element][$count], "x") = 0 Then
			$matchline = $count
		EndIf
	Until $matchline <> 0 Or $count = $oldheight

	; Use either the last non-blank line, or the last line altogether
	If $matchline = 0 Then
		$endline = $oldheight
	Else
		$endline = $matchline - 1
	EndIf

	; If the start line is the top line and the endline is the bottom line, do nothing
	If $startline = 1 And $endline = $oldheight Then

		; If the start line is the top line, just remove everything below the endline
	ElseIf $startline = 1 And $endline < $oldheight Then
		If $endline < $oldheight Then
			For $a = $endline + 1 To $oldheight
				$Char_array[$element][$a] = ""
			Next
		EndIf

		; Otherwise move the character to the top
	Else
		$count = 0
		For $a = $startline To $endline
			$count = $count + 1
			$Char_array[$element][$count] = $Char_array[$element][$a]
		Next

		; Blank any old lines
		For $a = ($count + 1) To $Char_maxheight
			$Char_array[$element][$a] = ""
		Next
	EndIf

	; Reset the char's y position
	$Char_array_ypos[$element] = $oldypos + ($startline - 1)

	; Return the new height of the character
	Return ($endline - $startline + 1)

EndFunc   ;==>RejigChar

; Hotkey functions

Func Hotkey_TakePhoto()

	; Whenever the hotkey is pressed, sets the global variable $Keypress
	$Hotkey_press = "takephoto"

	Return "success"

EndFunc   ;==>Hotkey_TakePhoto

Func Hotkey_Escape()

	; Whenever the hotkey is pressed, sets the global variable $Keypress
	$Hotkey_press = "escape"

	Return "success"

EndFunc   ;==>Hotkey_Escape

; File functions

Func SaveDetails()
	
	; Saves the name of the image, its filename, the image size, position and checksum to a log file

	Local $file, $result, $line
	
	$file = FileOpen($Misc_detailfile, 1)
	If $file = -1 Then
		MsgBox(1, $Script_name, "Error writing the file (FileOpen error)")
		Return "fail"
	EndIf
	
	$result = FileWriteLine($file, "Image '" & $Image_currentname & "', file " & $Image_currentfile)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileWriteLine error)")
		Return "fail"
	EndIf	

	$line =  " Checksum " & $Image_checksum
	If $Pixel_number = 1 Then 
		$line = $line & ", pixel colour " & $Pixel_target[1] 
	ElseIf $Pixel_number = 2 Then 
		$line = $line & ", pixel colours " & $Pixel_target[1] & ", " & $Pixel_target[2]
	ElseIf $Pixel_number = 3 Then 
		$line = $line & ", pixel colours " & $Pixel_target[1] & ", " & $Pixel_target[2] & ", " & $Pixel_target[3]
	EndIf
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileWriteLine error)")
		Return "fail"
	EndIf	
	
	$line = "	Width " & $Image_width & ", height " & $Image_height
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileWriteLine error)")
		Return "fail"
	EndIf	

	$line = "	Absolute coords: " & $Image_topx_absolute & "x" & $Image_topy_absolute & ", " & $Image_bottomx_absolute & "x" & $Image_bottomy_absolute
	$line = $line & ", window coords: " & $Image_topx_window & "x" & $Image_topy_window & ", " & $Image_bottomx_window & "x" & $Image_bottomy_window
	$line = $line & ", client coords: " & $Image_topx_client & "x" & $Image_topy_client & ", " & $Image_bottomx_client & "x" & $Image_bottomy_client
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileWriteLine error)")
		Return "fail"
	EndIf	
	
	$result = FileClose($file)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileClose error)")
		Return "fail"
	EndIf			

	MsgBox(1, $Script_name, "Image details saved")

	Return "success"
	
EndFunc

Func SaveData_Raw()
	
	; Saves all the scraped characters as raw data to a text file
	
	Local $count, $a, $b, $line, $result
	Local $file
	
	; Count the number of characters. Only write found characters, don't write deleted or not found characters
	$count = 0
	For $a = 1 to $Char_maxchars
		If $Char_array_chr[$a] <> "" AND $Char_array_chr[$a] <> "^" AND $Char_array_chr[$a] <> "|" Then 	
			$count = $count + 1
		EndIf
	Next
	
	; Open the file for writing, erasing the previous contents 
	$file = FileOpen($Misc_rawdatafile, 2)
	If $file = -1 Then
		MsgBox(1, $Script_name, "Error writing the raw data file (FileOpen error)")
		Return "fail"
	EndIf
	
	; Write the character array
	
	; Line 1 - write comment
	$line =  "## " & $Script_name & " v" & $Script_version & " character array, compiled: "
	$line = $line & @YEAR & "-" & @MON & "-" & @MDAY & ", no characters: " & $count
	$result = FileWriteLine($file,  $line) 
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf	

	; Line 2 - write comment
	$result = FileWriteLine($file, "## Image '" & $Image_currentname & "', file " & $Image_currentfile)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf	

	; Line 3 - write comment
	$line =  "## Checksum " & $Image_checksum
	If $Pixel_number = 1 Then 
		$line = $line & ", pixel colour " & $Pixel_target[1] 
	ElseIf $Pixel_number = 2 Then 
		$line = $line & ", pixel colours " & $Pixel_target[1] & ", " & $Pixel_target[2]
	ElseIf $Pixel_number = 3 Then 
		$line = $line & ", pixel colours " & $Pixel_target[1] & ", " & $Pixel_target[2] & ", " & $Pixel_target[3]
	EndIf
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf	
	
	; Line 4 - write the number of characters
	$result = FileWriteLine($file, $count)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf	
	
	; Line 5 - write the max width
	$result = FileWriteLine($file, $Char_maxwidth)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf			

	; Line 6 - write the max height
	$result = FileWriteLine($file, $Char_maxheight)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf			
	
	; Lines 7+ - write the characters
	For $a = 1 to $Char_maxchars
		
		If $Char_array_chr[$a] <> "" AND $Char_array_chr[$a] <> "^" AND $Char_array_chr[$a] <> "|" Then 
			
			; Line 1 - Write comment
			$result = FileWriteLine($file, "## Character " & $Char_array_chr[$a])
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
				Return "fail"
			EndIf		
			
			; Line 2 - Write character
			$result = FileWriteLine($file, $Char_array_chr[$a])
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
				Return "fail"
			EndIf					

			; Line 3 - Write width
			$result = FileWriteLine($file, $Char_array_width[$a])
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
				Return "fail"
			EndIf		
			
			; Line 4 - Write height
			$result = FileWriteLine($file, $Char_array_height[$a])
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
				Return "fail"
			EndIf		
			
			; Line 5 - Write xpos
			$result = FileWriteLine($file, $Char_array_xpos[$a])
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
				Return "fail"
			EndIf	
			
			; Line 6 - Write ypos
			$result = FileWriteLine($file, $Char_array_ypos[$a])
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
				Return "fail"
			EndIf	

			; Line 7 .. (7 + height) - Write the character, preceded and anteceded by / character
			For $b = 1 to $Char_array_height[$a]
				$result = FileWriteLine($file, "[" & $Char_array[$a][$b] & "]")
				If $result = 0 Then 
					MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
					Return "fail"
				EndIf		
			Next
		EndIf
	Next
	
	; Last line - write end of file
	$result = FileWriteLine($file, "EOF")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the raw data file (FileWriteLine error)")
		Return "fail"
	EndIf	

	; Close the file
	$result = FileClose($file)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileClose error)")
		Return "fail"
	EndIf			

	Return "success"

EndFunc

Func SaveData_AutoIT()

	; Saves all the scraped characters as an AutoIT code routine
	
	Local $count, $a, $b, $line, $result
	Local $file
	
	; Count the number of characters. Only write found characters, don't write deleted or not found characters
	$count = 0
	For $a = 1 to $Char_maxchars
		If $Char_array_chr[$a] <> "" AND $Char_array_chr[$a] <> "^" AND $Char_array_chr[$a] <> "|" Then 	
			$count = $count + 1
		EndIf
	Next
	
	; Open the file for writing, erasing the previous contents 
	$file = FileOpen($Misc_autoitfile, 2)
	If $file = -1 Then
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileOpen error)")
		Return "fail"
	EndIf

	; Write the opening section
	
	$line = "Func Somewhere_LoadCharBank_Something"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	$result = FileWriteLine($file, "")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf			
			
	$line = "	; Load characters showing ... into the scrape character bank"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	$result = FileWriteLine($file, "")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf			
	
	$line = "	Local $bankname = ""something_balance"" 	"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	$line = "	Local $numbercharacters = " & $count
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	$result = FileWriteLine($file, "")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	
	$line = "	; Don't load the bank if it's already loaded with these characters"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	$line = "	If $Scrape_charbankname = ""pacad_balance"" Then 	"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	$line = "		Return ""success""	"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	$line = "	EndIf"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	$result = FileWriteLine($file, "")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	

	$line = "	; Otherwise, empty the charbank"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	$line = "	Task_EmptyCharBank()"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	
	$result = FileWriteLine($file, "")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf	

	; Write the characters
	
	For $a = 1 to $Char_maxchars
		
		If $Char_array_chr[$a] <> "" AND $Char_array_chr[$a] <> "^" AND $Char_array_chr[$a] <> "|" Then 	
				
			$line = "	; Character " & $Char_array_chr[$a]
			$result = FileWriteLine($file, $line)
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
				Return "fail"
			EndIf				

			$line = "	$Scrape_charbank[" & $a & "][0] = """ & $Char_array_chr[$a] & """"
			$result = FileWriteLine($file, $line)
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
				Return "fail"
			EndIf		
				
			For $b = 1 to $Char_array_height[$a]
				
				$line = "	$Scrape_charbank[" & $a & "][" & $b & "] = """ & $Char_array[$a][$b] & """"
				$result = FileWriteLine($file, $line)
				If $result = 0 Then 
					MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
					Return "fail"
				EndIf		
			Next
			$result = FileWriteLine($file, "")
			If $result = 0 Then 
				MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
				Return "fail"
			EndIf			
			
		EndIf
	Next
	
	; Write the end section
	$line = "	Return ""success"" 	"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	$result = FileWriteLine($file, "")
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	$line = "EndFunc"
	$result = FileWriteLine($file, $line)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the AutoIT code file (FileWriteLine error)")
		Return "fail"
	EndIf		
	
	; Close the file
	$result = FileClose($file)
	If $result = 0 Then 
		MsgBox(1, $Script_name, "Error writing the file (FileClose error)")
		Return "fail"
	EndIf			

	Return "success"

EndFunc
