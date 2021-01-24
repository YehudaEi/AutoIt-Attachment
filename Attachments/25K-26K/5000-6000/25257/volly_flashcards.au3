#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#cs
notes - 
*.fcf is a ini file. 
Format:
[1] - question number
1= Question goes here
2= Answer goes here

Each fcf file is considered a deck. This allows for different test.
When loading, read INI section headers to get card count. (except first header)
Put all data into an array from fcf file
Random switch will pull from array then remove that item fom the array.
All wrongs will be saved to new array.
There can be only ONE wrongs file.
Wrongs file will be replaced each time it is saved. NO appending to end of file.
Use input box set description when saving deck. Use description in titlebar when deck is loaded.
Starting new deck will require saving the empty deck first, along with description. 
First header will be used for description


#ce


DIM $fileDeck
DIM $missed
DIM $Count
DIM $current_card
DIM $ini_random
$missed = "0"
$Count = "1"
$current_card = "1"
$ini_random = 1
$MainGUI = GUICreate("Volly Flash Cards 1.0", 857, 548, 187, 114)
GUISetFont(14, 400, 0, "Comic Sans MS")
GUISetBkColor(0x000080)
$Question_FM = GUICtrlCreateEdit("", 8, 32, 841, 217, $ES_MULTILINE + $ES_READONLY) ;for flash mode - when testing
$Answer_FM = GUICtrlCreateEdit("", 8, 288, 841, 193, $ES_MULTILINE + $ES_READONLY) ;for flash mode - when testing
$Question_EM = GUICtrlCreateEdit("", 8, 32, 841, 217, $ES_MULTILINE) ;for edit mode - when making cards
$Answer_EM = GUICtrlCreateEdit("", 8, 288, 841, 193, $ES_MULTILINE)  ;for edit mode - when making cards
GUICtrlSetState($Question_EM, $GUI_HIDE)
GUICtrlSetState($Answer_EM, $GUI_HIDE)
$Button1 = GUICtrlCreateButton("<<< Previous Card", 8, 488, 145, 33, 0)
GUICtrlSetFont(-1, 12, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x00FF00)
$Button2 = GUICtrlCreateButton("Next Card >>>", 168, 488, 137, 33, 0)
GUICtrlSetFont(-1, 12, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0xA6CAF0)
$Button3 = GUICtrlCreateButton("Show", 384, 488, 81, 33, 0) ;shows answer in field
GUICtrlSetFont(-1, 12, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x3A6EA5)
$Button4 = GUICtrlCreateButton("Right", 648, 488, 89, 33, 0) ;click when you get it right
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x008000)
$Button5 = GUICtrlCreateButton("Wrong", 752, 488, 97, 33, 0) ;click when you get it wrong. Save wrongs in array for saving to wrong file if desired.
GUICtrlSetBkColor(-1, 0xFF0000)
$Label1 = GUICtrlCreateLabel("Question "&$Count&" of "&$current_card, 8, 0, 250, 30) ;show number of cards in the deck that is loaded. 
																					 ;nees to change with each card
GUICtrlSetColor(-1, 0xFFFFFF)
$Label2 = GUICtrlCreateLabel("Answer", 8, 256, 69, 30)  ;392
GUICtrlSetColor(-1, 0xFFFFFF)
$Label3 = GUICtrlCreateLabel("# Missed:  "&$missed, 720, 0, 160, 30) ;shows number of missed cards
GUICtrlSetColor(-1, 0xFFFFFF)

;menu controls. All controls will have hotsetkeys for ease of use. 
$MenuList_1 = GUICtrlCreateMenu("&File")
$MenuList_1_Item_1 = GUICtrlCreateMenuItem("Load Set   (CTRL + L)",$MenuList_1)
$MenuList_1_Item_2 = GUICtrlCreateMenuItem("Save My Wrongs   (CTRL + Q)",$MenuList_1)
$MenuList_1_Item_3 = GUICtrlCreateMenuItem("Load My Wrongs   (CTRL + W)",$MenuList_1)
$MenuList_1_Item_4 = GUICtrlCreateMenuItem("Random OFF (CTRL + R)",$MenuList_1) ;toggle on or off, have labe change when ON.
                                                                                ;when ON, puts cards in random array and selects cards at random
																				;random array is reduced each time a card is selected.
$MenuList_1_Item_5 = GUICtrlCreateMenuItem("Flash Mode   (CTRL + F)",$MenuList_1) ;test mode. 
                                                                                  ;use check to note which mode or would title work better to mark?
$MenuList_1_Item_6 = GUICtrlCreateMenuItem("Edit Mode   (CTRL + E)",$MenuList_1) ;edit mode, used to make cards
$MenuList_2 = GUICtrlCreateMenu("&Edit")
$MenuList_2_Item_1 = GUICtrlCreateMenuItem("New Set   (CTRL+S)",$MenuList_2)
$MenuList_2_Item_2 = GUICtrlCreateMenuItem("New Card   (CTRL+N)",$MenuList_2)
$MenuList_2_Item_3 = GUICtrlCreateMenuItem("Save Set   (ALT+S)",$MenuList_2)
$MenuList_2_Item_4 = GUICtrlCreateMenuItem("Cut",$MenuList_2)
$MenuList_2_Item_5 = GUICtrlCreateMenuItem("Copy",$MenuList_2)
$MenuList_2_Item_6 = GUICtrlCreateMenuItem("Paste",$MenuList_2)
$MenuList_2_Item_7 = GUICtrlCreateMenuItem("Delete",$MenuList_2)
$MenuList_3 = GUICtrlCreateMenu("&Controls")
$MenuList_3_Item_1 = GUICtrlCreateMenuItem("<<< Previous Card   (CTRL + left arrow)",$MenuList_3)
$MenuList_3_Item_2 = GUICtrlCreateMenuItem(">>> Next Card   (CTRL + right arrow)",$MenuList_3)
$MenuList_3_Item_3 = GUICtrlCreateMenuItem("Show   (CTRL + up arrow)",$MenuList_3)
$MenuList_3_Item_4 = GUICtrlCreateMenuItem("Right   (CTRL + Y)",$MenuList_3)
$MenuList_3_Item_5 = GUICtrlCreateMenuItem("Wrong   (CTRL + U)",$MenuList_3)

;hotsetkeys

;------------------------
GUISetState(@SW_SHOW)
HotKeySet("^l", "HotKeyFunc")
HotKeySet("^q", "HotKeyFunc")
HotKeySet("{ESC}", "HotKeyFunc")


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func HotKeyFunc()
    If WinActive($MainGUI) Then; Set the window
        Switch @HotKeyPressed
            Case "^l"
                _loadset()
			Case "^q"
				_SaveMyWrongs()
            Case "{ESC}"
                Exit
        EndSwitch
    Else
        HotKeySet(@HotKeyPressed)
        Send(@HotKeyPressed)
        HotKeySet(@HotKeyPressed, "HotKeyFunc")
    EndIf
EndFunc

Func _loadset() ;loads deck, updates $Label1 with count. 
	$filedeck = FileOpenDialog("Open Flash Deck", @ScriptDir&"\Bin\", "Flash Card File (*.fcf)", 1)
	;read config.ini for random setting
	_randomcard($ini_random)
EndFunc	

Func _randomcard($r) ;puts deck in array to allow for possible random. If $r = 1 then random is turned on. $r = 0 is off
	;;;
EndFunc	

Func _SaveMyWrongs()
	$msg = MsgBox(33, "Warning!", "This will overwrite your previous set of wrong cards. Do you wish to do this?")
	;save array to *.fcf file. 
EndFunc	