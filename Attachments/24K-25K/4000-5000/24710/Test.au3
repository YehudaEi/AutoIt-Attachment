#include <ButtonConstants.au3>
#include <GUIConstantsEX.au3>
#include <GUIConstants.au3>
#include <GuiEdit.au3>
#include <Misc.au3>
Opt("WinTitleMatchMode", 2) 

HotKeySet("{F2}", "Form1") 	;F2
HotKeySet("{ESC}", "MenuClose")	;ESC

While 1
	Sleep(100)
WEnd

Func Form1()
$GUI = GUICreate("Menu", 246, 421, 455, 198)
GUISetOnEvent($GUI_EVENT_CLOSE, "MenuClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "MenuMinimize")

$QuestLabel = GUICtrlCreateInput("", 8, 48, 65, 21)
GUICtrlCreateLabel("How Many Questions?", 8, 24, 111, 17)

$QuestStartLabel = GUICtrlCreateInput("", 8, 104, 65, 21)
GUICtrlCreateLabel("Starting Question #", 8, 80, 95, 17)

$LayLabel = GUICtrlCreateInput("", 8, 160, 65, 21)
GUICtrlCreateLabel("Layout: Enter 1 or 2", 8, 136, 111, 17)

$TitleLabel = GUICtrlCreateInput("", 8, 232, 209, 21)
GUICtrlCreateLabel("Title", 8, 208, 24, 17)

$DirLabel = GUICtrlCreateInput("", 8, 288, 209, 21)
GUICtrlCreateLabel("Directions", 8, 264, 51, 17)

$PassLabel = GUICtrlCreateInput("", 8, 344, 209, 21)
GUICtrlCreateLabel("Passage", 8, 320, 45, 17)

$Button_1 = GUICtrlCreateButton("OK", 24, 384, 75, 25, 0)
$Button_2 = GUICtrlCreateButton("Cancel", 124, 384, 75, 25, 0)

GUISetState()

While 1
    $nMsg = GUIGetMsg()
    Select
    Case $nMsg = $GUI_EVENT_CLOSE
        Exit
    Case $nMsg = $Button_1
		$Read1 = GUICtrlRead($QuestLabel) 
		$Read2 = GUICtrlRead($QuestStartLabel)
		$Read3 = GUICtrlRead($LayLabel)
		$Read4 = GUICtrlRead($TitleLabel)
		$Read5 = GUICtrlRead($DirLabel)
		$Read6 = GUICtrlRead($PassLabel)
		QuestionAnswer()
	Case $nMsg = $Button_2
		GUISetState(@SW_HIDE,$GUI)
		GUISetState(@SW_SHOW,MAIN_MENU())
    EndSelect
WEnd
EndFunc

Func GetULTRA(); UltraEdit is the Application
WinWait("UltraEdit-32 - ","")
If Not WinActive("UltraEdit-32 - ","") Then WinActivate("UltraEdit-32 - ","")
WinWaitActive("UltraEdit-32 - ","")
	Sleep(500)
EndFunc;==>UltraEdit

Func GetWORD(); Looks for Microsoft Word Document
WinWait("Microsoft Word","")
If Not WinActive("Microsoft Word","") Then WinActivate("Microsoft Word","")
WinWaitActive("Microsoft Word","")
	Sleep(500)
EndFunc;==>Microsoft Word

Func QuestionAnswer();==>Copy from Word to Ultra Edit
;~  Copy Question Text and Answers in Word and pastes it into Ultra Edit
Global $Count, $Read1, $Read2, $Read3, $Read4, $Read5, $Read6
	GetULTRA()
	$Count = 1

	Do	
		GetULTRA()
		Send('<question id="')
		Send(""&$Read2)
		Send('"{TAB}correct=""{TAB}layout="')
		Send(""&$Read3)
		Send('"{TAB}title="')
		Send(""&$Read4)
		Send('"{TAB}directions="')
		Send(""&$Read5)
		Send('"{TAB}passage="')
		Send(""&$Read6)
		Send('">{ENTER}')
		Send('<text>{CTRLDOWN}v{CTRLUP}</text>{ENTER}<explanation>{ENTER}<text></text>{ENTER}</explanation>{ENTER}')
		GetWORD()
		Send('{HOME}{SHIFTDOWN}{END}{SHIFTUP}{CTRLDOWN}c{CTRLUP}{DOWN}')
		GetULTRA()
		Send('<answer id="A"><text>{CTRLDOWN}v{CTRLUP}</text></answer>{ENTER}')
		GetWORD()
		Send('{HOME}{SHIFTDOWN}{END}{SHIFTUP}{CTRLDOWN}c{CTRLUP}{DOWN}')
		GetULTRA()
		Send('<answer id="B"><text>{CTRLDOWN}v{CTRLUP}</text></answer>{ENTER}')
		GetWORD()
		Send('{HOME}{SHIFTDOWN}{END}{SHIFTUP}{CTRLDOWN}c{CTRLUP}{DOWN}')
		GetULTRA()
		Send('<answer id="C"><text>{CTRLDOWN}v{CTRLUP}</text></answer>{ENTER}')
		GetWORD()
		Send('{HOME}{SHIFTDOWN}{END}{SHIFTUP}{CTRLDOWN}c{CTRLUP}{DOWN}')
		GetULTRA()
		Send('<answer id="D"><text>{CTRLDOWN}v{CTRLUP}</text></answer>{ENTER}')
		GetWORD()
		Send('{HOME}{SHIFTDOWN}{END}{SHIFTUP}{CTRLDOWN}c{CTRLUP}{DOWN 2}')
		GetULTRA()
		Send('<answer id="E"><text>{CTRLDOWN}v{CTRLUP}</text></answer>{ENTER}</question>{ENTER 2}')
	; Increase the count by one
	$Count = $Count + 1 
	$Read2 = $Read2 + 1
Until $Count > $Read1
				
	MsgBox(0, "Finished", "You Finished")
EndFunc;==>Copy from Word to Ultra Edit

Func MenuClose()
	Exit 0
EndFunc

Func MenuMinimize()
	GUISetState(@SW_MINIMIZE,$GUI_EVENT_MINIMIZE)
EndFunc