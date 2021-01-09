#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.0.0
 Author: goldenix        

 Script Function:
				Script is Paused at startup
				Press ALT + Esc to terminate script, Pause/Break to "pause" 
				
				Open Pictuire when clikked once on the image
				Close Picture when mouse was moved	
http://www.autoitscript.com/forum/index.php?showtopic=96846				
#ce ----------------------------------------------------------------------------
#include <Misc.au3>
;~ =========================================================================================
;~ Config
;~ =========================================================================================

;~ Change this Nr. if you want to move your mouse for longer or shorter 
;~ distance to close the image [DEFAULT is 20]
Global $range 	= 20 

HotKeySet("{pause}", "TogglePause") 	;Pause/Break HotKey
HotKeySet("!{ESC}", "Terminate")		; Alt + Esc Hotkey


;~ Do not change anything Below this line - Unless you know what you are doing!
;~ /////////////////////////////////////////////////////////////////////////////////////////
Global $Window 	= " - IrfanView"			;Sub Sting of the Irfan window DO not change this
Global $window2	= "IrfanView Thumbnails"	;Irfan Thumbnails window title Do not change

;~ =========================================================================================

Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

Global $Paused
Global $x, $y

TogglePause() ; pause the script at startup

$dll = DllOpen("user32.dll")
While 1
    Sleep(50)
    If _IsPressed("01", $dll) Then ; right mouse , 01 = left mouse

		MouseDown("left")
		Sleep(10)
		MouseUp("left")

		MouseDown("left")
		Sleep(10)
		MouseUp("left")
		
		MouseDown("left")
		Sleep(10)
		MouseUp("left")		
		
		If FileExists('nomousy.exe') Then ShellExecute("nomousy.exe","-h") ; mouse hide

		$pos = MouseGetPos()
		
		$x = $pos[0]
		$y = $pos[1]

		_close_window()				
			
    EndIf	
		
WEnd
DllClose($dll)
;;;;;;;;

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc

Func _close_window()
	
;~ 	WinWait($Window)	
	If WinExists($Window) then WinActivate($Window)
	
	While 1
		$pos = MouseGetPos()

		$x2 = $pos[0]
		$y2 = $pos[1]
		
;~ 		ToolTip($x &" "& $y & @CRLF & $x2 &" "& $y2,0,0)	
		
		If $x2 > $x+$range Or $y2 > $y+$range Then ExitLoop
		If $x2 < $x-$range Or $y2 < $y-$range Then ExitLoop	
		Sleep(5)		
	WEnd

	If FileExists('nomousy.exe') Then ShellExecute("nomousy.exe") ; mouse show
		
;~ 	----------------------------------------------------
	$hwnd2 = WinGetHandle("[CLASS:FullScreenClass]") ; returns nothing if not in fullscreen
		
		If $hwnd2 <> '' then
			ConsoleWrite('Send ESC' & @CRLF)
			Send('{esc}')
;~ 			WinClose($hwnd2)
;~ 			Opt('WINTITLEMATCHMODE', 4)
;~ 			ControlShow('classname=Shell_TrayWnd', '', '')
;~ 			Opt('WINTITLEMATCHMODE', 2)
		EndIf		
;~ 	----------------------------------------------------
		If WinExists($Window) Then 
			$hwnd1 = WinGetHandle($Window)			
			WinClose($hwnd1)
			ConsoleWrite('WinClose($hwnd1)' & @CRLF)
		EndIf
			
;~ 	----------------------------------------------------
EndFunc

Func Terminate() ; exit
    Exit 0
EndFunc