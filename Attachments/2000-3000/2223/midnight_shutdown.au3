#include <process.au3>
opt('WinTitleMatchMode', 4)

#Region Variables and Constants
;Changable settings
Dim Const $timetosleep = 2230 ;;What time should the monitors(s) be disabled?
Dim Const $timetowake = 0600  ;;What time should the monitor(s) be enabled again?

;Do Not Change
Dim Const $WM_SYSCOMMAND = 274
Dim Const $SC_MONITORPOWER = 61808
Dim Const $POWERON = -1
Dim Const $POWEROFF = 2
Global $x = 0, $y = 0, $hidemonitor = 0, $currenttime
Dim $hwnd = WinGetHandle('classname=Progman')
#EndRegion Variables and Constants

#Region Functions and Hotkeys
HotKeySet("{F7}", "key1")
HotKeySet("{F9}", "key2")
HotKeySet("{ESC}", "continue")

Func continue()
	$hidemonitor = 1
EndFunc   ;==>continue
Func pausemonitor()
	$x = 0
	$y = 0
	Do
		Sleep(10000)
		If $currenttime >= 0100 And $currenttime <= 0500 Then $hidemonitor = 1
	Until $hidemonitor = 1
EndFunc   ;==>pausemonitor
Func key1()
	$y = 1
	If $x <> 0 Then pausemonitor()
EndFunc   ;==>key1
Func key2()
	$x = 1
	If $y <> 0 Then pausemonitor()
EndFunc   ;==>key2

Func atimmc()
	If ProcessExists("ATIMMC.exe") Then
		MouseClick("right", 512, 384)
		Sleep(200)
		MouseClick("left", 535, 710)
		Sleep(1000)
	EndIf
EndFunc   ;==>atimmc
#EndRegion Functions and Hotkeys


Do
	Sleep(10000)
	$currenttime = @HOUR & @MIN
Until $currenttime >= $timetosleep Or $currenttime <= $timetowake

#Region Time to Sleep!
atimmc()

While $currenttime >= $timetosleep Or $currenttime < $timetowake
	DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hwnd, 'int', $WM_SYSCOMMAND, 'int', $SC_MONITORPOWER, 'int', $POWEROFF)
	If ProcessExists("ATIMMC.exe") Then atimmc()
	Sleep(100)
	$currenttime = @HOUR & @MIN
WEnd
#EndRegion Time to Sleep!

DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hwnd, 'int', $WM_SYSCOMMAND, 'int', $SC_MONITORPOWER, 'int', $POWERON)
_RunDos('start                                                                     ')
Exit