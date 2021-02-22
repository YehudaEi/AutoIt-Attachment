#RequireAdmin
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <IE.au3>
#include <Timers.au3>
#include <Process.au3>
#Include <Misc.au3>
#include <Constants.au3>
#include <INet.au3>
#Include <GuiButton.au3>
#Include <Clipboard.au3>
#Include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <file.au3>
#include <unixtime.au3>
Opt("GuiOnEventMode", 1)
Opt("WinTitleMatchMode", 3)
$maingui = GUICreate("Window Catch Vers.3", 300, 95, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "leave")
GUISetState()
$double = 0
$go = ""
$text = ""
$wcnt = ""
global $wcnt[1000]
$t1 = GUICtrlCreateLabel("offset left", 10, 40, 50, 20)
$slidx = GUICtrlCreateslider(65, 38, 170, 20)
GUICtrlSetLimit(-1, 480, 0)
$t2 = GUICtrlCreateLabel("offset top", 10, 70, 50, 20)
$slidy = GUICtrlCreateslider(65, 68, 170, 20)
GUICtrlSetLimit(-1, 640, 0)
$go = GUICtrlCreateButton("catch", 240, 70, 50, 20)
$go2 = GUICtrlCreateButton("reset", 240, 40, 50, 20)
GUICtrlSetState($slidx, $GUI_DISABLE)
GUICtrlSetState($slidy, $GUI_DISABLE)
_relist()
Opt("GUIOnEventMode", 0)
global $active = 0, $x = 0, $y = 0, $text2, $hwnd
while 1
	sleep(20)
	$mMsg = GUIGetMsg(1)
	Switch $mMsg[0]
		case $go2
			GUISwitch($maingui)
        	GUICtrlDelete($text)
	        _relist()
		case $go
			$text2 = GUICtrlRead($text)
			$old = WinGetPos($text2, "")
			$hwnd = WinGetHandle ($text2, "")
			$proc = WinGetProcess($text2, "")
            _catch()
			if $active = 1 then
			    GUICtrlSetState($text, $GUI_DISABLE)
			    GUICtrlSetState($go, $GUI_DISABLE)
			    GUICtrlSetState($go2, $GUI_DISABLE)
			    GUICtrlSetState($slidx, $GUI_enABLE)
                GUICtrlSetState($slidy, $GUI_enABLE)
			endif
		case $GUI_EVENT_CLOSE
			if $mMsg[1] = $maingui Then
			    exit
			Else
				$active = 0
				GUIDelete($mMsg[1])
				GUISwitch($maingui)
				GUICtrlSetState($go, $GUI_enABLE)
			    GUICtrlSetState($go2, $GUI_enABLE)
				GUICtrlSetState($slidx, $GUI_DISABLE)
                GUICtrlSetState($slidy, $GUI_DISABLE)
        	    GUICtrlDelete($text)
	            _relist()
			endif
	EndSwitch
	$old = WinGetPos($hwnd, "")
	if $active = 1 and ProcessExists($proc) = 0 then
		$active = 0
		GUIDelete($wcnt[$double])
		GUISwitch($maingui)
		GUICtrlSetState($go, $GUI_enABLE)
		GUICtrlSetState($go2, $GUI_enABLE)
		GUICtrlSetState($slidx, $GUI_DISABLE)
		GUICtrlSetState($slidy, $GUI_DISABLE)
		GUICtrlDelete($text)
		_relist()
	endif
	while _IsPressed(01)
		if $active = 1 then
		    if GUICtrlRead($slidx) <> $x then
			    $x = GUICtrlRead($slidx)
		        WinMove($hWnd, "", 0-$x, 0-$y, $old[2], $old[3])
		    endif
		    if GUICtrlRead($slidy) <> $y then
			    $y = GUICtrlRead($slidy)
		        WinMove($hWnd, "", 0-$x, 0-$y, $old[2], $old[3])
		    endif
		    sleep(20)
		endif
	wend
wend

func _catch()
    If $hWnd <> 0 Then
		$x = GUICtrlRead($slidx)
        $y = GUICtrlRead($slidy)
		$double += 1
		$wcnt[$double] = GUICreate("", 536, 370, -1, -1,$WS_SIZEBOX )
		GUISetState()
        $nExStyle = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $hWnd, "int", -20)
        $nExStyle = $nExStyle[0]
        DllCall("user32.dll", "int", "SetWindowLong", "hwnd", $hWnd, "int", -20, "int", BitOr($nExStyle, $WS_EX_MDICHILD))
        DllCall("user32.dll", "int", "SetParent", "hwnd", $hWnd, "hwnd", $wcnt[$double]);$maingui)
        WinSetState($hWnd, "", @SW_SHOW)
		WinMove($hWnd, "", 0-$x, 0-$y, $old[2], $old[3])
		$active = 1
	Else
		msgbox(0,"","Fehler")
	EndIf
	GUISwitch($maingui)
endfunc

Func IsVisible($handle)
	If BitAnd(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func leave()
    exit
EndFunc

func _relist()
    $first = ""
    $hwnd = ""
    $var = WinList()
    For $i = 1 to $var[0][0]
        If WinGetProcess($var[$i][0]) <> @AutoItPID and $var[$i][0] <> "" AND IsVisible($var[$i][1]) and _ProcessGetName (WinGetProcess($var[$i][0])) <> "explorer.exe" and _ProcessGetName (WinGetProcess($var[$i][0])) <> "sidebar.exe" then;and StringInStr($double, _ProcessGetName (WinGetProcess($var[$i][0]))) = 0 Then
		    if WinGetState ($var[$i][0]) = 7 or WinGetState ($var[$i][0]) = 23 or WinGetState ($var[$i][0]) = 39 then
		        if $first = "" then
				    $first = $var[$i][0]
		        else
			        $hwnd &= $var[$i][0] & "|"
	    	    endif
            endif
        EndIf
    Next
    $text = GUICtrlCreateCombo($first, 10, 10, 280, 20, $CBS_DROPDOWNLIST)
    GUICtrlSetData(-1, $hwnd, $first)
endfunc