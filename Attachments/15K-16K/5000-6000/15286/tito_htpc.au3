#NoTrayIcon
#include <GUIConstants.au3>
#Include <GuiStatusBar.au3> ; needed for _IsPressed
Opt("GUIOnEventMode", 1) ; enable onevent mode

Global Const $Dwidth = @DesktopWidth
Global Const $Dheight = @DesktopHeight

$runCheck = "OK" ; a check for later use...

If $runCheck = "OK" Then
	
	$FormMain = GUICreate("My HTPC Experiment", $Dwidth, $Dheight, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
	
	; create 'selected' label :
	GUICtrlCreateLabel("Selected :", 100, 200, 200, 20) ; x, y, width, height
	
	; put all menu options in array
	Dim $menu_options[30] = [ "item 1", "item 2", "item 3", "item 4", "item 5", "item 6", "item 7" ]
	Dim $menu_options_labels[30] 

	; place option labels :
	; position 200,200 will be (later) used to identify selected item
	$start_pos_y = 100
	$i = 0
	FOR $element IN $menu_options
		$menu_options_labels[$i] = GuiCtrlCreateLabel($element, 200, $start_pos_y, 100, 30)
		$start_pos_y = $start_pos_y + 100
		$i = $i + 1
	NEXT

	; set esc=close
    GUISetOnEvent($GUI_EVENT_CLOSE, "CloseApp")
   	
	; activate form
    GUISetState(@SW_SHOW)
	
	; set bgcolor
    GUISetBkColor(0x55aaff, $FormMain)
    
	; START main loop
    While 1
		sleep(100) ; to avoid multiple key presses
		
		If _IsPressed('26') = 1 Then
			;26 is UP
			MoveMenu("up")
			SoundPlay( @WindowsDir & "\media\Windows XP Menu Command.wav", 0 ) ; click
		EndIf
		
		If _IsPressed('28') = 1 Then
			;28 is UP
			MoveMenu("down")
			SoundPlay( @WindowsDir & "\media\Windows XP Menu Command.wav", 0 ) ; click
		EndIf
    WEnd
	
Else
	; nothing yet (if runcheck != ok)
    Exit
EndIf

Func MoveMenu($moveMenuDir)
 	If $moveMenuDir = "up" Then $move_y = 100
 	If $moveMenuDir = "down" Then $move_y = -100

	$i = 0
	; get ALL options current position and update position according to keypress...
	FOR $element IN $menu_options_labels
		$element_pos = ControlGetPos("", "", $menu_options_labels[$i])
		$element_pos_y = $element_pos[1]
		
		$new_y = $element_pos_y + $move_y
		; If $new_y < 0 Then $new_y = 0
		GUICtrlSetPos ( $menu_options_labels[$i], 200, $new_y )
		$i = $i + 1
	NEXT
EndFunc

Func CloseApp()
	; SoundPlay( @WindowsDir & "\media\Windows XP Balloon.wav", 1 ) ; pop
	; SoundPlay( @WindowsDir & "\media\Windows XP Start.wav", 1 ) ; click
	; SoundPlay( @WindowsDir & "\media\start.wav", 1 ) ; clack
	SoundPlay( @WindowsDir & "\media\Windows XP Menu Command.wav", 1 ) ; clock
    Exit
EndFunc