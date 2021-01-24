#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\Desktop\missile.ico
#AutoIt3Wrapper_outfile=MissileLauncher.exe
#AutoIt3Wrapper_Res_Fileversion=1.6.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;  Author:  Tyler Cox
;  Date:    2-9-2009
;  Thanks:  Special thanks to whomever I got the API voice commands from. Not sure but a long time ago I got it from the forums!
;           Also thanks to DreamCheeky for providing the default missile launcher program. Saved work for me :-)
;  Purpose: This script uses the default missile launcher program that comes with the DreamCheeky (green and black) Missile Launcher. 
;           You can control up to 2 launchers at once or 1 at a time!!! Here is a list of the things possible running this program.
;          
;           1) Press 1 to Mute the sounds on the default missile launcher
;           2) Press 2 to Move the launchers down
;           3) Press 3 to Reset both of the launchers
;           4) Press 4 to Move the launchers left
;           5) Press 5 to Fire both of the launchers
;           6) Press 6 to Move the launchers right
;           7) Press 7 to select the left launcher to be moved independently using the ARROW keys
;           8) Press 8 to Move the launchers up
;           9) Press 9 to select the right launcher to be moved independently using the ARROW keys
;          10) Press Spacebar to fire the currently selected launcher
;
;-----------------------------------------------------------------------------------------------------------------------------------------------------

#include <Misc.au3>

$dll = DllOpen("user32.dll")
AutoItSetOption("WinTitleMatchMode", 4)
AutoItSetOption("MouseClickDownDelay",100)   ;set click delay to provide a smooth performance.
DirCreate(@TempDir & "\ML\") ;create a directory for putting the files in!

FileInstall("C:\Program Files\USb Missile Launcher\MissileLauncher.exe" , @TempDir & "\ML\MissileLauncher.exe",0) ;take the default missile launcher program.
FileInstall("C:\Program Files\USb Missile Launcher\USBHID.dll", @TempDir & "\ML\USBHID.dll",0) ;take the USBHID dll needed for the default program!

Run(@TempDir & "\ML\MissileLauncher.exe") ;launch the first instance of the default missile launcher program!
sleep(1500)
$handle1 = WinGetHandle("classname=TForm1")  ;get the handle of the first window.

WinMove($handle1,"",400,200) ;move the window for easy use.

Run(@TempDir & "\ML\MissileLauncher.exe") ;launch the second instance of the default missile launcher program!
sleep(1500)
$handle2 = WinGetHandle("classname=TForm1")  ;get the handle of the second window.

WinMove($handle2,"",590,200) ;move the window for easy use.

While 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Mute the Sounds        ;; 
;;                                    ;;
;;  This part will mute the annoying  ;;
;;  sounds that are played when using ;;
;;  the missilelauncher.exe program   ;;
;;  that comes with the launcher.     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("61", $dll) Then   ;if 1 is pressed, then mute the sounds!
	WinActivate($handle1)
	AutoItSetOption("MouseClickDownDelay",10) ;this will speed up the delay for the muting process
	MouseClick("left",563,597,1,1)
	WinActivate($handle2)
	MouseClick("left",754,597,1,1)
	AutoItSetOption("MouseClickDownDelay",100) ;speed it click delay for the rest of the time
EndIf	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Set focus              ;; 
;;                                    ;;
;;  This part will change the focus   ;;
;;  on the left or right launcher     ;;
;;  to manual move each one with the  ;;
;;  arrow keys (not the numeric key   ;;
;;  pad!)                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("67", $dll) Then   ;if 7 is pressed, then the left launcher is highlighted
	WinActivate($handle1)
EndIf	
If _IsPressed("69", $dll) Then   ;if 9 is pressed, then the right launcher is highlighted
	WinActivate($handle2)
EndIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               Reset                ;; 
;;                                    ;;
;;  This part will reset both of the  ;;
;;  launchers to position zero. There ;;
;;  are also some fun sounds played!  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("63", $dll) Then            ;if 3 is pressed, then reset
	_TalkOBJ('Scanning for HUMANOIDS',3)  ;jump to function to play sound
	WinActivate($handle1)
	MouseClick("left",503,541,1,1)
	WinActivate($handle2)
	MouseClick("left",688,542,1,1)
	Sleep(14500)                          ;allow for a long sleep to get dramatic effect
	_TalkOBJ('Target Acquired!',3)        ;jump to function to play sound 
EndIf	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               Fire!                ;; 
;;                                    ;;
;;  This part will fire both of the   ;;
;;  launchers as well as play a funny ;;
;;  sound!                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("65", $dll) Then          ;if 5 is pressed, then FIRE!
	SoundPlay("C:\Documents and Settings\user\Desktop\laser.wav")  ;play sound!
	Sleep(4000)
	MouseClick("left",502,322,1,1)
	MouseClick("left",688,322,1,1)
EndIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Move Right             ;; 
;;                                    ;;
;;  This part will move both of the   ;;
;;  launchers to the right!           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("66", $dll) Then          ;if 6 is pressed, then move right!
	MouseClick("left",525,325,1,1)
	MouseClick("left",716,320,1,1)
EndIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Move Left              ;; 
;;                                    ;;
;;  This part will move both of the   ;;
;;  launchers to the left!            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("64", $dll) Then          ;if 4 is pressed, then move left!
	MouseClick("left",478,325,1,1)
	MouseClick("left",661,320,1,1)
EndIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              Move Up               ;; 
;;                                    ;;
;;  This part will move both of the   ;;
;;  launchers to the up!              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("68", $dll) Then         ;if 8 is pressed, then move up!
	MouseClick("left",503,297,1,1)
	MouseClick("left",687,297,1,1)
EndIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Move Down              ;; 
;;                                    ;;
;;  This part will move both of the   ;;
;;  launchers to the down!            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

If _IsPressed("62", $dll) Then          ;if 2 is pressed, then move down!
	MouseClick("left",497,347,1,1)
	MouseClick("left",687,347,1,1)
EndIf

WEnd

;This function will create the Voice sequence!
;
;I'm not sure where this came from, somewhere off of the autoit forums!
;So special thanks to whomever came up with this!!!
Func _TalkOBJ($s_text, $s_voice = 3)
    Local $o_speech = ObjCreate ("SAPI.SpVoice")
        Select
            Case $s_voice == 3
                $o_speech.Voice = $o_speech.GetVoices("Name=Microsoft Sam", "Language=409").Item(0)
        EndSelect
    $o_speech.Speak ($s_text)
    $o_speech = ""		
EndFunc ;==>_TalkOBJ