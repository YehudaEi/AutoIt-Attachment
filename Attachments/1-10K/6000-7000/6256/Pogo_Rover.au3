; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author: HHCORY <>
;
; Script Function: Rover's From room to room on pogo. User defined amount of time with IE option and Mozilla.
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------
#include <guiconstants.au3>
Global $DumpOut = 0
HotKeySet ( '{esc}', "MyExitLoop" )

$MainGUI = GUICreate('PoGo RoVeR', 300, 500)
GUICtrlCreateLabel ("How many minutes would you like to play?", 30, 475, 250, 20)
$input = GUICtrlCreateInput("", 240, 473, 30, 17, $ES_NUMBER)
GUICtrlSetLimit( -1, 3, 1 )
GuiCtrlCreateTab(5, 5, 300, 470)
GuiCtrlCreateTabItem("IE")
  $Button1 = GUICtrlCreateButton('First Class Solitare', 10, 30, 100, 17)
  $Button3 = GUICtrlCreateButton('PopFoo', 10, 47, 100, 17)
  $Button4 = GUICtrlCreateButton('World Class Solitare', 10, 64, 100, 17)
;GuiCtrlCreateLabel("", 250, 40)
GuiCtrlCreateTabItem("Mozilla")
  $Button5 = GUICtrlCreateButton('3-Point Showdown', 10, 30, 100, 17)
  $Button6 = GUICtrlCreateButton('6th Street Omaha', 10, 47, 100, 17)
  $Button7 = GUICtrlCreateButton('Aces Up', 10, 64, 100, 17)
  $Button8 = GUICtrlCreateButton('Ali Baba Slots', 10, 81, 100, 17)
  $Button9 = GUICtrlCreateButton('Backgammon', 10, 98, 100, 17)
  $Button10 = GUICtrlCreateButton('Battle Phlinx', 10, 115, 100, 17)
  $Button11 = GUICtrlCreateButton('Buckaroo Blackjack', 10, 133, 100, 17)
  $Button12 = GUICtrlCreateButton('Canasta', 10, 150, 100, 17)
  $Button13 = GUICtrlCreateButton('Casino Island', 10, 167, 100, 17)
  $Button14 = GUICtrlCreateButton('Checkers', 10, 184, 100, 17)
  $Button57 = GUICtrlCreateButton('First Class ', 10, 201, 100, 17)
  $Button16 = GUICtrlCreateButton('Dice Derby', 10, 218, 100, 17)
  $Button17 = GUICtrlCreateButton('Dominoes', 10, 235, 100, 17)
  $Button18 = GUICtrlCreateButton('Double Duce', 10, 252, 100, 17)
  $Button19 = GUICtrlCreateButton('Euchre', 10, 269, 100, 17)
  $Button20 = GUICtrlCreateButton('Fortune Bingo', 10, 286, 100, 17)
  $Button21 = GUICtrlCreateButton('Greenback Bayoe', 10, 303, 100, 17)
  $Button22 = GUICtrlCreateButton('Harvest Maina', 10, 320, 100, 17)
  $Button23 = GUICtrlCreateButton('Hearts', 10, 337, 100, 17)
  $Button24 = GUICtrlCreateButton('Jacks or Better', 10, 355, 100, 17)
  $Button25 = GUICtrlCreateButton('Jigsay Detective', 10, 371, 100, 17)
  $Button26 = GUICtrlCreateButton('Jokers Wild', 10, 388, 100, 17)
  $Button27 = GUICtrlCreateButton('Jungle Gin', 10, 405, 100, 17)
  $Button28 = GUICtrlCreateButton('Lottso!', 10, 422, 100, 17)
  $Button29 = GUICtrlCreateButton('Mahjong Garden', 10, 439, 100, 17)
  $Button56 = GUICtrlCreateButton('Ride The Tide', 10, 456, 100, 17)
  $Button30 = GUICtrlCreateButton('Panda Pia Gow ', 110, 30, 100, 17)
  $Button31 = GUICtrlCreateButton('Payday Freecell', 110, 47, 100, 17)
  $Button32 = GUICtrlCreateButton('Penguin Blocks', 110, 64, 100, 17)
  $Button33 = GUICtrlCreateButton('Perfect Pair', 110, 81, 100, 17)
  $Button34 = GUICtrlCreateButton('Phlinx', 110, 98, 100, 17)
  $Button35 = GUICtrlCreateButton('Pinochle', 110, 115, 100, 17)
  $Button36 = GUICtrlCreateButton('PopFu', 110, 133, 100, 17)
  $Button37 = GUICtrlCreateButton('PappaZappa', 110, 150, 100, 17)
  $Button38 = GUICtrlCreateButton('Poppit!', 110, 167, 100, 17)
  $Button39 = GUICtrlCreateButton('Quick Quack', 110, 184, 100, 17)
  $Button40 = GUICtrlCreateButton('QWERTY', 110, 201, 100, 17)
  $Button41 = GUICtrlCreateButton('Rainy Day Spider', 110, 218, 100, 17)
  $Button42 = GUICtrlCreateButton('Sci-fi Slots', 110, 235, 100, 17)
  $Button43 = GUICtrlCreateButton('Showbiz Slots', 110, 252, 100, 17)
  $Button44 = GUICtrlCreateButton('Squelchies', 110, 269, 100, 17)
  $Button45 = GUICtrlCreateButton('Stackem', 110, 286, 100, 17)
  $Button46 = GUICtrlCreateButton('Stellar Sweeper', 110, 303, 100, 17)
  $Button47 = GUICtrlCreateButton('Texas Holdem', 110, 320, 100, 17)
  $Button48 = GUICtrlCreateButton('Tri-Peaks', 110, 337, 100, 17)
  $Button49 = GUICtrlCreateButton('Tumble Bee', 110, 355, 100, 17)
  $Button50 = GUICtrlCreateButton('Turbo 21', 110, 371, 100, 17)
  $Button51 = GUICtrlCreateButton('Vaults of Atlantis', 110, 388, 100, 17)
  $Button52 = GUICtrlCreateButton('Word Whomp', 110, 405, 100, 17)
  $Button53 = GUICtrlCreateButton('Whackdown', 110, 422, 100, 17)
  $Button54 = GUICtrlCreateButton('WordJong', 110, 439, 100, 17)
  $Button55 = GUICtrlCreateButton('World Class', 110, 456, 100, 17)

GUISetState()
opt("TrayMenuMode", 1)
opt("TrayOnEventMode", 1)

$show_tray = TrayCreateItem("About this Program")
TrayItemSetOnEvent(-1, "Set_Show")
TrayCreateItem("")
$exit_tray = TrayCreateItem("Exit this Program")
TrayItemSetOnEvent(-1, "Set_Exit")
TraySetState()
While 1
    $MainMsg = GUIGetMsg()
    Select
    Case $MainMsg = $GUI_EVENT_CLOSE
        Exit
	Case $MainMsg = $Button5  ;Mozilla 3-Point Shootout
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button6  ;6th Street Omaha Poker
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                             ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button7  ;Mozilla Aces Up
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                            ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button8  ;Ali Baba Slots
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                             ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button9  ;Backgammon
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                       ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button10  ;Battle Phlinx
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                                     .')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button11 ;Buckaroo Blackjack
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                              ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button12   ;Canasta
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                        ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button13   ;Casino Island Blackjack
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                 ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button14  ;Checkers
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                         ')
			Sleep (30000)
	Case $MainMsg = $Button16   ;Dice Derby
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                     ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button17   ;Dominoes
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                       ')
			Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1
	Case $MainMsg = $Button18   ;Double Duce Poker
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                   ')
            Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1	

	Case $MainMsg = $Button19   ;Eucher
			Do
			Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                       ')
            Sleep((GUICtrlRead($input)) * 60 * 1000)
            Until $DumpOut = 1	

	Case $MainMsg = $Button20   ;Fortune Bingo
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1	
	Case $MainMsg = $Button21   ;GreenBack Bayoe
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                 ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button22   ;Harvest Mania
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                               ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button23   ;Hearts
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                       ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button24   ;Jacks or Better
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button25   ;Jigsaw Detective
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                              ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button26   ;Jokers Wild
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button27   ;Jungle Gin
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                    ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button28   ;Lottso!
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                                      .')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button29   ;Mahjong Garden
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                               ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button30   ;Pand Pai Gow Poker
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                              ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button31   ;Payday Freecell
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button32   ;Penguin blocks
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button33   ;Perfect Pair Solitaire
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button34   ;Phlinx
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                               ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button35   ;Pinochle
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                         ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1		
	Case $MainMsg = $Button36   ;PopFoo
            Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                             ')
            Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button37   ;PappaZappa
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                                          .')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button38   ;Poppit!
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                      .','game')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button39   ;Quick Quack
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                 ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button40   ;QWERTY
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                        ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button41   ;Rainy Day Spider Solitare
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                              ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button42   ;Sci-Fi Slots
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                             ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button43   ;Showbiz Slots
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                               ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button44   ;Squelchies
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                  ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button45   ;Stack'em
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                            ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button46   ;Stellar Sweeper
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                                .')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button47   ;Texas Hold'em poker
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                              .') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button48   ;Tri-Peak Solitare
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                             ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button49   ;Tumble Bees
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                              ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button50   ;Turbo 21
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                               ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button51   ;Vaults of Atlantis Slots
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                               ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button52   ;Word Whomp
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                     .')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button53   ;Word Whomp Whackdown
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                 ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button54   ;Word Jong
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button55   ;World Class Solitaire
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                ')
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button57   ;First Class Solitare
            Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                                                                          .')
            Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1
	Case $MainMsg = $Button56   ;Ride The Tide
			Do
			$pid = Run('"C:\Program Files\Mozilla Firefox\firefox.exe"                                                                            ') 
		    Sleep((GUICtrlRead($input)) * 60 * 1000)
		Until $DumpOut = 1	
    EndSelect
WEnd

; ------------- Functions ----------------------

Func MyExitLoop()
    $DumpOut = 1
EndFunc
Func Set_Exit()
Exit
EndFunc

Func Set_Show()
MsgBox(64, " About this Program"," this Program was designed by............ me!!! ")
EndFunc 

