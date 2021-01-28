#Include <Date.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Dim $whichbutton

$NowDate=(@YEAR & @MON & @MDAY)

;$Form1_1 = GUICreate("Log Launch", 1001, 649, 3, 20)

$Form1_1 = GuiCreate("Log Launch",@DesktopWidth,@DesktopHeight,0,0 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS) 

$iniBut1 = IniRead(@ScriptDir & "\LogLaunch.ini", "Main", "Button1","")
$iniBut2 = IniRead(@ScriptDir & "\LogLaunch.ini", "Main", "Button2","")
$iniBut3 = IniRead(@ScriptDir & "\LogLaunch.ini", "Main", "Button3","")
$iniBut4 = IniRead(@ScriptDir & "\LogLaunch.ini", "Main", "Button4","")
$iniBut5 = IniRead(@ScriptDir & "\LogLaunch.ini", "Main", "Button5","")
$iniBut6 = IniRead(@ScriptDir & "\LogLaunch.ini", "Main", "Button6","")

$Button1 = GUICtrlCreateButton($iniBut1, 72, 112, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Button2 = GUICtrlCreateButton($iniBut2, 405, 111, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Button3 = GUICtrlCreateButton($iniBut3, 730, 108, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Button4 = GUICtrlCreateButton($iniBut4, 71, 379, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Button5 = GUICtrlCreateButton($iniBut5, 410, 382, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Button6 = GUICtrlCreateButton($iniBut6, 731, 379, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("Log Launcher", 416, 16, 166, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)


While 1
	$msg = GUIGetMsg()
	Select
		Case $Msg = $Button1
			MDIOPEN()
			$Whichbutton = "Button1"
			GUISetState(@SW_HIDE, $form1_1)
			;GUISetState(@SW_SHOW, $form1_2)
			Form2()
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			;;;
	EndSelect
WEnd
Exit

;Functions
Func Form2()
;$Form1_2 = GUICreate("Channel Launch", 1001, 649, 3, 20)
$Form1_2 = GUICreate("Channel Launch",@DesktopWidth,@DesktopHeight,0,0 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS) 
;GUISetState(@SW_HIDE)
$iniButC1 = IniRead(@ScriptDir & "\LogLaunch.ini", $WhichButton, "Button1", "")
$iniButC2 = IniRead(@ScriptDir & "\LogLaunch.ini", $WhichButton, "Button2", "")
$iniButC3 = IniRead(@ScriptDir & "\LogLaunch.ini", $WhichButton, "Button3", "")
$iniButC4 = IniRead(@ScriptDir & "\LogLaunch.ini", $WhichButton, "Button4", "")
$iniButC5 = IniRead(@ScriptDir & "\LogLaunch.ini", $WhichButton, "Button5", "")
$iniButC6 = IniRead(@ScriptDir & "\LogLaunch.ini", $WhichButton, "Button6", "")

$ButtonC1 = GUICtrlCreateButton($iniButC1, 72, 112, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$ButtonC2 = GUICtrlCreateButton($iniButC2, 405, 111, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$ButtonC3 = GUICtrlCreateButton($iniButC3, 730, 108, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$ButtonC4 = GUICtrlCreateButton($iniButC4, 71, 379, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$ButtonC5 = GUICtrlCreateButton($iniButC5, 410, 382, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$ButtonC6 = GUICtrlCreateButton($iniButC6, 731, 379, 257, 185, $WS_GROUP)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Channel Launcher", 416, 16, 166, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
ENDFUNC

Func MDIOPEN()
$INIMDI1 = IniRead(@ScriptDir & "\LogLaunch.ini", $iniBut1, "Log1","")
$LogFile=$INIMDI1 & $NOWDATE & ".MDI"
Run('"C:\Program Files\Common Files\Microsoft Shared\MODI\12.0\mspview.exe" "c:\log\AB\' & $LogFILE & '"',"",@SW_MINIMIZE)
ENDFUNC