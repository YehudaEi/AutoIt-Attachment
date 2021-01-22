#include <GUIConstants.au3>

MsgBox(4096, "Auto Potter V1.0", "Made by DemonSlayer and JokerzWyld")

Opt("GUIOnEventMode", 1)

GUICreate("Auto Potter V1.0", 300, 200)

$Label1 = GUICtrlCreateLabel("Please select the % to pot at.", 10, 10)
$Label2 = GUICtrlCreateLabel("Make sure Cabal is already running.", 10, 30)
$Label3 = GUICtrlCreateLabel("Make sure your character is logged in.", 10, 50)
$Label4 = GUICtrlCreateLabel("Make sure Cabal window is named CABAL.", 10, 70)
$Label5 = GUICtrlCreateLabel("Make sure you are not using a window renamer.", 10, 90)
$BrkOne = GUICtrlCreateButton("&75%", 20, 150, 50, 30)
GUICtrlSetOnEvent($BrkOne, "On75")
$BrkTwo = GUICtrlCreateButton("&50%", 95, 150, 50, 30)
GUICtrlSetOnEvent($BrkTwo, "On50")
$BrkThree = GUICtrlCreateButton("&25%", 170, 150, 50, 30)
GUICtrlSetOnEvent($BrkThree, "On25")
$BrkEnd = GUICtrlCreateButton("&Exit", 245, 150, 50, 30)
GUICtrlSetOnEvent($BrkEnd, "OnExit")

GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

GUISetState() ; display the GUI

While 1
	Sleep(1000)
WEnd

;--------------- Functions ---------------
Func On75()
	If @GUI_CtrlId = $BrkOne Then
		MsgBox(4096, "Auto Potter V1.0", "make sure u got potions set to - hotkey ")
		WinActivate("CABAL")
		WinWaitActive("CABAL")
		While 1
			$SearchResult = PixelSearch(250, 60, 270, 70, 0x1A1A1A, 10, 1)
			If Not @error Then
				Send("{-}")
			EndIf
		WEnd
	EndIf
EndFunc   ;==>On75


Func On50()
	If @GUI_CtrlId = $BrkTwo Then
		MsgBox(4096, "Auto Potter V1.0", "make sure u got potions set to - hotkey ")
		WinActivate("CABAL")
		WinWaitActive("CABAL")
		While 1
			$SearchResult = PixelSearch(190, 60, 210, 70, 0x1A1A1A, 10, 1)
			If Not @error Then
				Send("{-}")
			EndIf
		WEnd
	EndIf
EndFunc   ;==>On50

Func On25()
	If @GUI_CtrlId = $BrkThree Then
		MsgBox(4096, "Auto Potter V1.0", "make sure u got potions set to - hotkey ")
		WinActivate("CABAL")
		WinWaitActive("CABAL")
		While 1
			$SearchResult = PixelSearch(130, 60, 150, 70, 0x1A1A1A, 10, 1)
			If Not @error Then
				Send("{-}")
			EndIf
		WEnd
	EndIf
EndFunc   ;==>On25

Func OnExit()
	If @GUI_CtrlId = $BrkEnd Then
		MsgBox(0, "Auto Potter V1.0", "Thanks for using")
	Else
		MsgBox(0, "Auto Potter V1.0", "Thanks for using")
	EndIf

	Exit
EndFunc   ;==>OnExit