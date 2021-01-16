 #Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=Fish Progression.exe
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WINAPI.au3>
#Include <Misc.au3>
opt("SendKeyDelay",50)
HotKeySet("{pause}", "Quit")
Global $searchL, $searchT, $searchR, $searchB, $color, $numofcasts, $castfail, $bait, $Pole, $numofbait, $Baittimer, $Baitnum
$prog = "Fish Progression"

#Region ### START Koda GUI section ### Form=
$MainGUI = GUICreate($prog & " - Setup", 237, 163)
$Group1 = GUICtrlCreateGroup("Bait?", 8, 8, 217, 49)
$Baitbox = GUICtrlCreateCombo("None", 16, 24, 201, 25)
GUICtrlSetData(-1, "Shiny Bauble|Sharpened Fish Hook|Nightcrawlers|Flesh Eating Worm|Bright Baubles|Aquadynamic Fish Lens|Aquadynamic Fish Attractor")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("Pole?  *", 8, 50, 217, 49)
$polebox = GUICtrlCreateCombo("", 16, 66, 201, 25)
GUICtrlSetData(-1, "Fishing Pole|Blump Family Fishing Pole|Strong Fishing Pole|Darkwood Fishing Pole|Big Iron Fishing Pole|Seth's Graphite Fishing Pole|Nat Pagle's Extreme Angler FC-5000|Nat's Lucky Fishing Pole|Bone Fishing Pole|Jeweled Fishing Pole|Mastercraft Kalu'ak Fishing Pole|Arcanite Fishing Pole")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label1 = GUICtrlCreateLabel("To stop the bot at anytime press the Pause key", 8, 102, 226, 17)
$Label1 = GUICtrlCreateLabel("* Required Feild", 8, 119, 226, 17)
$Start = GUICtrlCreateButton("Start", 8, 138, 219, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Start
		If GUICtrlRead($polebox) = "" Then
			MsgBox(64, $prog, "Please Select the Fishing Pole you are using")
		Else
			runbot()
		EndIf
	EndSwitch
WEnd

Func runbot()
	$Pole = GUICtrlRead($polebox)
	$bait = GUICtrlRead($baitbox)
	GUISetState(@SW_HIDE, $MainGUI)
	MsgBox(64, $prog, "Please follow the instructions in the top left cornor")
	ToolTip('Making sure World of Warcraft is Active, and zooming in',0,0,"",2)
	If WinActive("World of Warcraft") = 0 Then WinActivate("World of Warcraft")
	Sleep(2000)
	Send("{Home}") ; Zoom in WoW
		Send("{Home}")
			Send("{Home}")
				Send("{Home}") 
					Send("{Home}")
					
	sleep(2000)
	$dll = DllOpen("user32.dll") ; Read somewhere thats User32.ddl speeds up _IsPressed detection?
	ToolTip('Equiping ' & $Pole & "! Please wait...",0,0,"",2)
	Send("/equip [noequipped:Fishing Pole] " & $Pole & "{enter}") ; Equip Fishing Pole
	; Select the upper left of the search area
	ToolTip('Click in the top left corner of the search area',0,0,"",2)
	While -1
		If WinActive("World of Warcraft") = 0 Then WinActivate("World of Warcraft") ; Make sure WoW stays active while user is selecting position
		If _IsPressed("01",$dll) Then ExitLoop ; Exit loop when user left clicks
	WEnd
	$mouse = MouseGetPos()
	$searchL = $mouse[0]
	$searchT = $mouse[1]
	
	Sleep(1000)

	; Select the lower right of the search area
	ToolTip('Click in the bottom right corner of the search area',0,0,"",2)
	While -1
		If WinActive("World of Warcraft") = 0 Then WinActivate("World of Warcraft") ; Make sure Wow stays active while user is selecting position
		If _IsPressed("01",$dll) Then ExitLoop ; Exit loop when user left clicks
	WEnd
	$mouse = MouseGetPos()
	$searchR = $mouse[0]
	$searchB = $mouse[1]
	
	Sleep(1000)

	ToolTip('',0,0,"",2)
	Send(1) ; Cast fishing
	Sleep(2000) ; Gives enough time for blobber to deploy
	
	; Present a GUI to show the color at the mouse cursor
	$colourgui = GUICreate("",200,100,(@DesktopWidth/4)-100,@DesktopHeight-125,$WS_POPUP,$WS_EX_TOPMOST) ; Create a large borderless GUI that is always on top so user can see the color
	GUISetState(@SW_SHOW)

; Wait for a colour to be clicked on
While -1
    If WinActive("World of Warcraft") = 0 Then WinActivate("World of Warcraft") ; Make sure Wow stays active while user is selecting color
    $mouse = MouseGetPos()
    $color = PixelGetColor($mouse[0],$mouse[1])
    ToolTip("Find the Dark Red and click it, if Fishing timer runs out press 1 on your keyboard and try again.",0,0) ; Create a Tooltip away from cursor that the user can use to select a color, mousing over bobber changes its color!
    GUISetBkColor("0x" & Hex($color,6),$colourgui) ; Update gui with color seen
    If _IsPressed("01",$dll) Then ExitLoop; Exit loop when user left clicks
WEnd

ToolTip("Thank you for selecting the colour!",0,0,"",2)
Sleep(500)
GUISetState(@SW_HIDE) ;hide $ColourGUI

; Wait for the first right-click to begin
ToolTip('Wait for the splash and catch the fish',0,0,"",2)
While _IsPressed("02",$dll) = 0 ; Wait until the user right-click
    Sleep(10)
Wend
DllClose($dll) ; Close DLL

Sleep(500)
; sleep while Auto-looting <<< Thank you Blizzard xD
ToolTip("Initializing Bot...",0,0,"",2)
Sleep(Random(1890,3124))
Fishforreal()
EndFunc

Func Fishforreal()
If $bait = "None" Then
	ToolTip("No bait selected... Loading Paint Window",0,0,"",2)
	sleep(1000)
Else
ToolTip("Equiping " & $bait & "! Please Wait...",0,0,"",2)
Send("/use " & $bait &  "{Enter}")
Send("/use 16 {Enter}")
$Baittimer = TimerInit()
Sleep(4000)
$numofbait +=1
EndIf
$ColourGUI = GUICreate("PaintWindow", 600, 85, (@DesktopWidth/2 - 300), 25, $WS_POPUP, $WS_EX_LAYERED)
GUISetBkColor(0x0000F4)
GUISetFont(12, 800, 0, "Comic Sans MS")
$title = GUICtrlCreateLabel($prog, 8, 8, 140, 24)
GUICtrlSetColor(-1, 0x0000FF)
$Statuslable = GUICtrlCreateLabel("Status: Idle", 182, 8, 400, 24)
GUICtrlSetColor(-1, 0x0000FF)
$castnum = GUICtrlCreateLabel("Number of casts: 0", 8, 32, 190, 24)
GUICtrlSetColor(-1, 0x0000FF)
$Baitnum = GUICtrlCreateLabel("Bait used: 0", 182, 32, 190, 24)
GUICtrlSetColor(-1, 0x0000FF)
$Accurseynum = GUICtrlCreateLabel("Percentage Caught: N/A", 8, 56, 300, 24)
GUICtrlSetColor(-1, 0x0000FF)
WinSetOnTop("PaintWindow","",1)
ToolTip("Paint Window Loaded",0,0,"",2)
sleep(500)
ToolTip("",0,0,"",2)
GUICtrlSetData($Baitnum, "Bait used: 0 " & $numofbait)
_WinAPI_SetLayeredWindowAttributes($ColourGUI, 0x0000F4, 250)
GUISetState()
; The actual bot
While -1
    While -1
		_checkbait()
		GUICtrlSetData($Accurseynum, "Percentage Caught: " & ($numofcasts-$castfail)*100/$numofcasts & "%")
		GUICtrlSetData($Accurseynum, "Percentage Caught: " & ($numofcasts-$castfail)*100/$numofcasts & "%") ; coding it twice seems to fix the display error
		WinActivate("World of Warcraft")
		GUICtrlSetData($Statuslable, "Status: Casting...")
        Sleep(1000)
        Send("1") ; Use the first slot of the cast bar to start fishing
		$numofcasts += 1
		GUICtrlSetData($castnum, "Number of casts: " & $numofcasts)
		GUICtrlSetData($Statuslable, "Status: Waiting for Blobber...")
        Sleep(3000)
		GUICtrlSetData($Statuslable, "Status: Searching for Bobber...")
        $timer = TimerInit() ; Set a timeout for finding bobber
        While -1
            $bobber = PixelSearch($searchL,$searchT,$searchR,$searchB,"0x" & Hex($color,6),10,1) ; Look for user selected color in a large area in the center of the screen
            ;$bobber = PixelSearch($searchL,$searchT,$searchR,$searchB,"0x" & Hex(0x461B0E,6),10,1) ; Look for user selected color in a large area in the center of the screen
            
			If @error <> 1 Then ExitLoop ; When color is found, bail out of the loop to start looking for splash
            If TimerDiff($timer) > 10000 Then
				GUICtrlSetData($Statuslable, "Status: Blobber not found!")
				$castfail += 1
				;----------------------------------------
				Sleep(1000)
                WinActivate("World of Warcraft")
                ExitLoop 2
            EndIf
        Wend
        $timer = TimerInit() ; Set a timeout for finding splash
		MouseMove($bobber[0], $bobber[1]) ; Move the mouse to the bobber (so the user knows what this script is looking at, and hopefully doesn't move the mouse)
        While -1
			GUICtrlSetData($Statuslable, "Status: Searching for Splash...")
            $splash = PixelSearch($bobber[0]-10,$bobber[1]-10,$bobber[0]+10,$bobber[1]+10,"0x" & Hex($color,6),10,1) ; Search a tiny 20x20 square for the bobber color
            If @error = 1 Then ExitLoop ; When the color isn't found, the bobber just bobbed (Splash Detected!)
            If TimerDiff($timer) > 13150 Then
				GUICtrlSetData($Statuslable, "Status: Splash not found!")
				$castfail += 1
				;------------------------------------
				Sleep(1000)
                WinActivate("World of Warcraft")
                Exitloop 2
            EndIf
        Wend
		GUICtrlSetData($Statuslable, "Status: Splash Detected!")
        Sleep(Random(75,175))
        MouseClick("Right", $bobber[0], $bobber[1], 1, 0) ; Even if the user moves the mouse, this instantly moves it to the bobber and right-clicks
        Sleep(2000)
		GUICtrlSetData($Statuslable, "Status: Waiting to fish again")
        Sleep(1000)
    Wend
Wend
EndFunc

; Quit the script when the user presses {pause}
Func Quit()
    Exit
EndFunc


Func _WinAPI_SetLayeredWindowAttributes($hwnd, $i_transcolor, $Transparency = 255, $dwFlages = 0x03, $isColorRef = False)
; #############################################
; You are NOT ALLOWED to remove the following lines
; Function Name: _WinAPI_SetLayeredWindowAttributes
; Author(s): Prog@ndy
; #############################################
    If $dwFlages = Default Or $dwFlages = "" Or $dwFlages < 0 Then $dwFlages = 0x03

    If Not $isColorRef Then
        $i_transcolor = Hex(String($i_transcolor), 6)
        $i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))
    EndIf
    Local $Ret = DllCall("user32.dll", "int", "SetLayeredWindowAttributes", "hwnd", $hwnd, "long", $i_transcolor, "byte", $Transparency, "long", $dwFlages)
    Select
        Case @error
            Return SetError(@error, 0, 0)
        Case $Ret[0] = 0
            Return SetError(4, _WinAPI_GetLastError(), 0)
        Case Else
            Return 1
    EndSelect
EndFunc  ;==>_WinAPI_SetLayeredWindowAttributes


Func _checkbait()
    $TimeMil = TimerDiff($Baittimer)
    If $TimeMil>=10 * 60 * 1000 Then ; check if bait is gone
		If $bait = "None" Then
				sleep(1000)
		Else
		ToolTip("Equiping " & $bait & "! Please Wait...",0,0,"",2)
		Send("/use " & $bait &  "{Enter}")
		Send("/use 16 {Enter}")
		$Baittimer = TimerInit()
		$numofbait +=1
        GUICtrlSetData($Baitnum, "Bait used: 0 " & $numofbait)
		Sleep(4000)
        $Baittimer = TimerInit(); RESET TIMER
		EndIf
    EndIf
EndFunc