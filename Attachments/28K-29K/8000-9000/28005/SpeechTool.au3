#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Paul Rabahy

 Script Function:
	Play a sound when a picture is clicked.

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Array.au3>

Opt("TrayAutoPause", 0)
Opt("GUIOnEventMode", 1)

$MAXROWS = 4
$MAXCOLUMNS = 5

$screens = IniReadSectionNames("settings.ini")
If @error Then
	MsgBox(0,"Settings file not found.","Please make a settings.ini file.")
	Exit(1)
EndIf
If $screens[0] > $MAXROWS * $MAXCOLUMNS Then MsgBox(0,"Settings Warning","Only " & $MAXROWS * $MAXCOLUMNS & " out of " & $screens[0] & " will be shown.")

Global $mainMenuButtons[$MAXROWS * $MAXCOLUMNS + 1]
Global $subMenuButtons[$MAXROWS * $MAXCOLUMNS + 1]
Global $pics[$MAXROWS * $MAXCOLUMNS + 1][2]

Global $mainMenu = GUICreate("Speech Tool - Main Menu", 600, 475, -1, -1, $WS_SIZEBOX)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")


For $row = 0 to $MAXROWS - 1
	For $column = 0 to $MAXCOLUMNS - 1
		$currentScreen = $row * $MAXCOLUMNS + $column
		If $currentScreen > $screens[0]-1 Then ExitLoop(2)
		$mainMenuButtons[$currentScreen] = GUICtrlCreatePic($screens[$currentScreen + 1], $column * 112 + 8, $row * 110 + 8, 100, 100)
		GUICtrlSetOnEvent(-1, "ScreenClick")
	Next
Next
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func ScreenClick()

	$section = ""
	For $i = 0 To UBound($mainMenuButtons) - 1
		If $mainMenuButtons[$i] = @GUI_CtrlId Then
			$section = $screens[$i+1]
		EndIf
	Next		
		
	$pics = IniReadSection("settings.ini", $section)

	If @error Or $pics[0][0] <= 0 Then
		MsgBox(0,"Could not open screen","There were no buttons to put on the screen")
		Return
	EndIf
	
	GUISetState(@SW_HIDE, $mainMenu)
	$subMenu = GUICreate("Speech Tool - " & $section, 600, 475, -1, -1, $WS_SIZEBOX)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

	For $row = 0 to $MAXROWS - 1
		For $column = 0 to $MAXCOLUMNS - 1
			$currentPic = $row * $MAXCOLUMNS + $column
			If $currentPic > $pics[0][0]-1 Then ExitLoop(2)
			$subMenuButtons[$currentPic] = GUICtrlCreatePic($pics[$currentPic + 1][0], $column * 112 + 8, $row * 110 + 8, 100, 100)
			GUICtrlSetOnEvent(-1, "PicClick")
		Next
	Next
	GUISetState(@SW_SHOW)
EndFunc

Func PicClick()
	$index = 0
	For $i = 0 To UBound($subMenuButtons) - 1
		If $subMenuButtons[$i] = @GUI_CtrlId Then
			$index = $i + 1
		EndIf
	Next
	
	SoundPlay($pics[$index][1])
	
EndFunc

Func Close()
	If @GUI_WinHandle = $mainMenu Then
		Exit
	Else
		GUIDelete()
		GUISetState(@SW_SHOW, $mainMenu)
	EndIf
EndFunc
