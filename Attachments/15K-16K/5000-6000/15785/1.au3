

#include <GUIConstants.au3>
#include <misc.au3>
#include <date.au3>
AutoItSetOption("WinTitleMatchMode", 4)
Global $pos
Global $winpos
Global $handle
Global $bottomleft
GLobal $startpos
Global $end
Global $time
HotKeySet ("{pause}", "_endgame")
HotKeySet ("{esc}", "_cheater")

$begin = TimerInit ()
$taskbar = WinGetHandle ("[classe:Shell_TrayWnd", "")
WinSetState ($taskbar, "", @SW_HIDE)
WinKill ("[class:#32770]")



$Form1 = GUICreate("Game", 212, 61, 314, 201)
$Label1 = GUICtrlCreateLabel("Try to close me!!!", 0, 16, 206, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
WinWait ("Game")
$handle = WinGetHandle ("Game")
WinSetOnTop ($handle, "", 1)
_windowinfo ()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete ()
			$End = TimerDiff ($begin)
			$time = $end / 1000
			Msgbox (0, "Win", "You Won in " & $time & " Seconds")
			Exit
			
		Case Else
			_X ()
			If WinExists ("Windows Task Manager") Then 
				WinSetState ($handle, "", @SW_HIDE)
				Winkill ("Windows Task Manager")
				MsgBox (0, "Cheater", "No Cheating")
				WinSetState ($handle, "", @SW_SHOW)
			EndIf
			_X()
			If _IsPressed (02) Then
				WinSetState ($handle, "", @SW_HIDE)
				MsgBox (0, "Cheater", "No Right Clicking")
				WinSetState ($handle, "", @SW_SHOW)
			Endif
			_X()
			If _IsPressed (12) Then
				WinSetState ($handle, "", @SW_HIDE)
				MsgBox (0, "Cheater", "No cheating")
				WinSetState ($handle, "", @SW_SHOW)
			EndIf
			_X()
			_X()
	EndSwitch
WEnd


Func _X ()
	$pos = MouseGetPos ()
	If $pos[0] > $startpos[0] and $pos[0] < $bottomleft[0] and $pos[1] > $startpos[1] and $pos[1] < $bottomleft[1] Then
		WinMove ($handle, "", Random (0, 900), Random (0, 700))
		_windowinfo ()		
	Endif
	Sleep (1)
EndFunc



Func _windowinfo ()
	$startpos = Wingetpos ($handle)
$startpos[1] = $startpos[1] - 50
$bottomleft = Mousegetpos ()
$bottomleft[0] = $startpos[0] + $startpos[2] + 50
$bottomleft[1] = $startpos[1] + $startpos[3]
Endfunc

Func _cheater ()
			WinSetState ($handle, "", @SW_HIDE)
			MsgBox (0, "Cheater", "No Cheating")
			WinSetState ($handle, "", @SW_SHOW)
Endfunc



Func _endgame ()
	WinSetState ($taskbar, "", @SW_SHOW)
	WinSetState ($handle, "", @SW_HIDE)
	MsgBox (0, "Lost", "You lose")
	Exit
EndFunc




