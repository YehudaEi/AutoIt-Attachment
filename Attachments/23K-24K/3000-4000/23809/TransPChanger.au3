#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Zutto
 Script version: 1.1 <_-_> second release <_-_> 
 
 tested on: winxp sp2
 why i made this: to play & watch movie same time ;)
#ce ----------------------------------------------------------------------------

hotkeyset("+e","winn")
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <WindowsConstants.au3>
#Include <Misc.au3>
$x1 = FileExists(@ScriptDir & "\" & "stings.ini")
if $x1 = 0 Then
		iniwrite("stings.ini", "info", "winname", "")
		iniwrite("stings.ini", "info", "win", "0")
		iniwrite("stings.ini", "info", "sot", "0")
		iniwrite("stings.ini", "info", "twaot", "1")
		iniwrite("stings.ini", "info", "hs", "0")
Else
	sleep(10)
EndIf
$in0 = iniread("stings.ini", "info", "winname", "default")
Opt("GUIOnEventMode", 1)

$Form1_1 = GUICreate("Transperency changer", 158, 167, 193, 115)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
$Slider1 = GUICtrlCreateSlider(0, 0, 150, 45)
GUICtrlSetOnEvent($Slider1, "Slider1Change")
$sld = guictrlread($Slider1)
GUICtrlSetLimit(3, 255, 0)
$Alwaysontop = GUICtrlCreateCheckbox("Always on top", 56, 48, 97, 17)
GUICtrlSetOnEvent($Alwaysontop, "AlwaysontopClick")
$Windowname = GUICtrlCreateButton("window name", 0, 72, 155, 25, 0)
GUICtrlSetOnEvent($Windowname, "WindownameClick")
$HideShow = GUICtrlCreateButton("Hide/Show", 0, 96, 155, 25, 0)
GUICtrlSetOnEvent($HideShow, "HideShowClick")
$Thiswindowalwaysontop = GUICtrlCreateCheckbox("This window always on top", 0, 120, 153, 17)
GUICtrlSetOnEvent($Thiswindowalwaysontop, "ThiswindowalwaysontopClick")
$a = GUICtrlCreateLabel($sld, 0, 48, 50, 17)
$WinName = GUICtrlCreateLabel($in0, 0, 144, 155, 17)
GUISetState(@SW_SHOW)


func winn()
	$info = iniread("stings", "info", "win", "default")
	if $info = 1 Then
		$win = WinGetTitle("")
		iniwrite("stings.ini", "info", "winname", $win)
		iniwrite("stings.ini", "info", "win", "0")
		$a = GUICtrlSetData("9",$win)
	Else
		sleep(10)
	EndIf
EndFunc


Func AlwaysontopClick()
$in = iniread("stings.ini", "info", "winname", "default")
$inn = iniread("stings.ini", "info", "sot", "default")
if $inn = 0 Then
winactivate($in)
winsetontop($in, "", 1)
iniwrite("stings.ini", "info", "sot", "1")
Else
winsetontop($in, "", 0)
iniwrite("stings.ini", "info", "sot", "0")
EndIf
EndFunc


Func Form1_1Close() 
exit
EndFunc


Func Slider1Change()
	$ins = iniread("stings.ini", "info", "winname", "default")
$sld = guictrlread($Slider1)
WinSetTrans($ins, "", $sld)
$a = GUICtrlSetData("8",$sld)
EndFunc

while 1
	sleep(1)
WEnd
Func WindownameClick()
msgbox(0, "", "activate window, press SHIFT + E to choose it..")
sleep(50)
iniwrite("stings.ini", "info", "win", "1")
EndFunc

func HideShowClick()
$hs = iniread("stings.ini", "info", "hs", "default")
$in3 = iniread("stings.ini", "info", "winname", "default")
if $hs = 0 Then
	WinSetState($in3, "", @SW_HIDE)
	iniwrite("stings.ini", "info", "hs", "1")
Else
	WinSetState($in3, "", @SW_SHOW)
	iniwrite("stings.ini", "info", "hs", "0")
EndIf

EndFunc

func ThiswindowalwaysontopClick()
$inn2 = iniread("stings.ini", "info", "twaot", "default")
if $inn2 = 0 Then
winactivate($Form1_1)
winsetontop($Form1_1, "", 1)
iniwrite("stings.ini", "info", "twaot", "1")
Else
winsetontop($Form1_1, "", 0)
iniwrite("stings.ini", "info", "twaot", "0")
EndIf
EndFunc


