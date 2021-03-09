#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=amp.ico
#AutoIt3Wrapper_Res_Comment=WEBRadioPlayer
#AutoIt3Wrapper_Res_Description=The Best WEB Radio Player
#AutoIt3Wrapper_Res_Fileversion=0.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=© Copyright 2012 Mirel - www.mirel.tk
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <WMMedia.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include "GIFAnimation.au3"

$ping = Ping("www.google.com")
If $ping = 0 Then
	MsgBox(0, "Fara acces la internet", "Pentru a putea utiliza playerul radio trebuie sa fi conectat la internet")
	Exit
ElseIf $ping <> 0 Then
EndIf

Global Const $WM_NOTIFY = 0x004E
Global $DoubleClicked = False

Opt("TrayMenuMode", 1)
$restore = TrayCreateItem("Restore")
TrayCreateItem("")
$exit = TrayCreateItem("Exit")
TraySetState()
Opt("TrayIconHide", 1)
TraySetClick(8) ; Pressing secondary mouse button

$version = "Ultimate" ; Version
Global $play, $play2, $play3, $play4, $play5, $play6, $stop, $exit, $label, $slider, $WEB, $n1, $n2, $hGIF, $light, $chat

WMStartPlayer()

$hGui = GUICreate("WEBRadioPlayer " & $version, 430, 270, (@DesktopWidth - 450) / 2, (@DesktopHeight - 650) / 2)

$play = GUICtrlCreateButton("DANCE", 75, 175, 70, 23)
GUICtrlSetTip($play, "WEBRadioPlayer DANCE Channel")

$play2 = GUICtrlCreateButton("RETRO", 145, 175, 70, 23)
GUICtrlSetTip($play2, "WEBRadioPlayer RETRO Channel")

$play3 = GUICtrlCreateButton("ROCK", 285, 175, 70, 23)
GUICtrlSetTip($play3, "WEBRadioPlayer ROCK Channel")

$play4 = GUICtrlCreateButton("SOFT", 215, 175, 70, 23)
GUICtrlSetTip($play4, "WEBRadioPlayer SOFT Channel")

$play5 = GUICtrlCreateButton("MANELE", 355, 175, 70, 23)
GUICtrlSetTip($play5, "WEBRadioPlayer MANELE Channel")

$play6 = GUICtrlCreateButton("CLUB", 5, 175, 70, 23)
GUICtrlSetTip($play6, "WEBRadioPlayer CLUB Channel")

$stop = GUICtrlCreateButton("STOP", 285, 200, 70, 23)
GUICtrlSetFont(-1, 12, 30, 0, "Arial Black")
GUICtrlSetTip($stop, "Click pentru a opri muzica")

$exit = GUICtrlCreateButton("EXIT", 355, 200, 70, 23)
GUICtrlSetFont(-1, 12, 30, 0, "Arial Black")
GUICtrlSetTip($exit, "Click pentru a inchide playerul")

$light = GUICtrlCreateButton("LIGHT'S", 285, 150, 70, 23)
GUICtrlSetTip($light, "WEBRadioPlayer Disco Light")

$chat = GUICtrlCreateButton("CHAT", 355, 150, 70, 23)
GUICtrlSetTip($chat, "WEBRadioPlayer - LIVE CHAT")

$label = GUICtrlCreateLabel("Playing: ", 5, 118, 280, 22)
GUICtrlSetFont(-1, 12, 30, 0, "Arial Black")
GUICtrlSetTip($label, "WEBRadioPlayer - The Best Web Radio Player")
GUICtrlCreateLabel("Volume: ", 5, 145, 50, 20)
GUICtrlCreateLabel("-", 47, 139, 20, 20)
GUICtrlSetFont(-1, 15)
$slider = GUICtrlCreateSlider(54, 144, 210, 30)
GUICtrlSetData($slider, 80)
GUICtrlCreateLabel("+", 263, 140, 20, 20)
GUICtrlSetFont(-1, 15)
GUICtrlSetTip($slider, "Muta cursorul pentru a seta volumul")

Global $hGIF = GUICtrlCreatePic("", -3, 0, 435, 120)
TrayTip("WEBRadioPlayer Player", "Pornire WEBRadioPlayer va rugam sa asteptati...", 0)
_GUICtrlSetGIF($hGIF, InetRead("http://www.mirel.tk/WEB-PLAYER/logo.gif", 16), Default, 1)
GUICtrlSetTip($hGIF, "Informatii despre player")

$WEB = GUICtrlCreateLabel("© Mirel Serban www.mirel.tk", 6, 200, 280, 22)
GUICtrlSetFont(-1, 13, 30, 0, "Arial Black")
GUICtrlSetTip($WEB, "© Copyright Mirel Serban - www.mirel.tk")

_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()
$GUIActiveX = GUICtrlCreateObj($oIE, -12, 225, 500, 50)
_IENavigate($oIE, "http://www.mirel.tk/WEB-PLAYER/ANUNTURI/Anunt.php?tip=player")

GUICtrlSetState(-1, $GUI_DISABLE)

Global $n1 = @ScriptDir & "\LIGHT.exe"
If Not FileExists($n1) Then
	TrayTip("WEBRadioPlayer", "Pornire WEBRadioPlayer va rugam sa asteptati...", 0)
	InetGet("http://www.mirel.tk/WEB-PLAYER/LIGHT.exe", $n1)
	TrayTip("", "", 0)
EndIf

Global $n2 = @ScriptDir & "\CHAT.exe"
If Not FileExists($n2) Then
	TrayTip("WEBRadioPlayer", "Pornire WEBRadioPlayer va rugam sa asteptati...", 0)
	InetGet("http://www.mirel.tk/WEB-PLAYER/CHAT.exe", $n2)
	TrayTip("", "", 0)
EndIf

GUISetState()

Func _Play()
	$Title = ("DANCE Channel")
	$URL = ("http://www.mirel.tk/WEB-PLAYER/Dance.m3u")
	WMOpenFile($URL)
	WMPlay($URL)
	GUICtrlSetData($label, "Playing: " & $Title)
	WinActivate("WEBRadioPlayer")
EndFunc   ;==>_Play

Func _Play2()
	$Title = ("RETRO Channel")
	$URL = ("http://www.mirel.tk/WEB-PLAYER/Retro.m3u")
	WMOpenFile($URL)
	WMPlay($URL)
	GUICtrlSetData($label, "Playing: " & $Title)
	WinActivate("WEBRadioPlayer")
EndFunc   ;==>_Play2

Func _Play3()
	$Title = ("ROCK Channel")
	$URL = ("http://www.mirel.tk/WEB-PLAYER/Rock.m3u")
	WMOpenFile($URL)
	WMPlay($URL)
	GUICtrlSetData($label, "Playing: " & $Title)
	WinActivate("WEBRadioPlayer")
EndFunc   ;==>_Play3

Func _Play4()
	$Title = ("SOFT Channel")
	$URL = ("http://www.mirel.tk/WEB-PLAYER/Soft.m3u")
	WMOpenFile($URL)
	WMPlay($URL)
	GUICtrlSetData($label, "Playing: " & $Title)
	WinActivate("WEBRadioPlayer")
EndFunc   ;==>_Play4

Func _Play5()
	$Title = ("MANELE Channel")
	$URL = ("http://www.mirel.tk/WEB-PLAYER/Manele.m3u")
	WMOpenFile($URL)
	WMPlay($URL)
	GUICtrlSetData($label, "Playing: " & $Title)
	WinActivate("WEBRadioPlayer")
EndFunc   ;==>_Play5

Func _Play6()
	$Title = ("CLUB Channel")
	$URL = ("http://www.mirel.tk/WEB-PLAYER/Club.m3u")
	WMOpenFile($URL)
	WMPlay($URL)
	GUICtrlSetData($label, "Playing: " & $Title)
	WinActivate("WEBRadioPlayer")
EndFunc   ;==>_Play6

Func _Stop()
	WMStop()
	GUICtrlSetData($label, "Playing: ")
EndFunc   ;==>_Stop

Func _exit()
	Exit
EndFunc   ;==>_exit

Func _About()
	MsgBox(80 + 8192, "About", "   WEBRadioPlayer - The Best Web Radio Player !" & @CRLF & @CRLF _
			 & "   WEBRadioPlayer - versiunea: Ultimate" & @CRLF & @CRLF _
			 & "   Copyright © 2012 Mirel Serban - www.mirel.tk")
EndFunc   ;==>_About

While 1
	WmSetVolume(GUICtrlRead($slider))

	$mMsg = GUIGetMsg()
	$tMsg = TrayGetMsg()

	If $DoubleClicked Then
		_Play()
		$DoubleClicked = False
	EndIf

	Select
		Case $mMsg = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE)
			Opt("TrayIconHide", 0)
		Case $mMsg = $WEB
			ShellExecute("http://www.mirel.tk/")
		Case $mMsg = $play
			_Play()
		Case $mMsg = $stop
			_Stop()
		Case $mMsg = $play2
			_Play2()
		Case $mMsg = $play3
			_Play3()
		Case $mMsg = $play4
			_Play4()
		Case $mMsg = $play5
			_Play5()
		Case $mMsg = $play6
			_Play6()
		Case $mMsg = $hGIF
			_About()
		Case $mMsg = $light
			Run("LIGHT.exe")
		Case $mMsg = $chat
			Run("CHAT.exe")
		Case $mMsg = $exit
			If ProcessExists("LIGHT.exe") Then
				ProcessClose("LIGHT.exe")
				ProcessWaitClose("LIGHT.exe")
			EndIf
			If ProcessExists("CHAT.exe") Then
				ProcessClose("CHAT.exe")
				ProcessWaitClose("CHAT.exe")
			EndIf
			_exit()
		Case $tMsg = $restore
			GUISetState(@SW_RESTORE)
			GUISetState(@SW_SHOW)
			Opt("TrayIconHide", 1)
		Case $tMsg = $exit
			WMClosePlayer()
			Exit
		Case $tMsg = $TRAY_EVENT_PRIMARYDOWN
			GUISetState(@SW_RESTORE)
			GUISetState(@SW_SHOW)
			Opt("TrayIconHide", 1)
	EndSelect
WEnd