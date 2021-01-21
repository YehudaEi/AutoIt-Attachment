; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.126
; Author:    Matrix112
;
; Script Function: Lock PC for Remote Desktop users. If somone types wrong
; pass or not allowed key like Crtl, Pc makes forced restart.
; It is useful if the remote user has encrypted hard disks.
; This Script prevents that other not entitled persons can use the PC.
; ----------------------------------------------------------------------------
#NoTrayIcon
Global $pass
Global $len
Global $check
Global $lencheck
#include <GuiConstants.au3>
#include <string.au3>
#include <Misc.au3>
Dim $pressed[75][2]
$pressed[0][0] = '41'
$pressed[0][1] = "a"
$pressed[1][0] = '42'
$pressed[1][1] = "b"
$pressed[2][0] = '43'
$pressed[2][1] = "c"
$pressed[3][0] = '44'
$pressed[3][1] = "d"
$pressed[4][0] = '45'
$pressed[4][1] = "e"
$pressed[5][0] = '46'
$pressed[5][1] = "f"
$pressed[6][0] = '47'
$pressed[6][1] = "g"
$pressed[7][0] = '48'
$pressed[7][1] = "h"
$pressed[8][0] = '49'
$pressed[8][1] = "i"
$pressed[9][0] = '4a'
$pressed[9][1] = "j"
$pressed[10][0] = '4b'
$pressed[10][1] = "k"
$pressed[11][0] = '4c'
$pressed[11][1] = "l"
$pressed[12][0] = '4d'
$pressed[12][1] = "m"
$pressed[13][0] = '4e'
$pressed[13][1] = "n"
$pressed[14][0] = '4f'
$pressed[14][1] = "o"
$pressed[15][0] = '50'
$pressed[15][1] = "p"
$pressed[16][0] = '51'
$pressed[16][1] = "q"
$pressed[17][0] = '52'
$pressed[17][1] = "r"
$pressed[18][0] = '53'
$pressed[18][1] = "s"
$pressed[19][0] = '54'
$pressed[19][1] = "t"
$pressed[20][0] = '55'
$pressed[20][1] = "u"
$pressed[21][0] = '56'
$pressed[21][1] = "v"
$pressed[22][0] = '57'
$pressed[22][1] = "w"
$pressed[23][0] = '58'
$pressed[23][1] = "x"
$pressed[24][0] = '59'
$pressed[24][1] = "y"
$pressed[25][0] = '5a'
$pressed[25][1] = "z"
$pressed[26][0] = '5f'
$pressed[26][1] = "_"
$pressed[27][0] = '6d'
$pressed[27][1] = "-"
$pressed[28][0] = '2e'
$pressed[28][1] = "."
$pressed[29][0] = '7e'
$pressed[29][1] = "~"
$pressed[30][0] = '30'
$pressed[30][1] = "0"
$pressed[31][0] = '31'
$pressed[31][1] = "1"
$pressed[32][0] = '32'
$pressed[32][1] = "2"
$pressed[33][0] = '33'
$pressed[33][1] = "3"
$pressed[34][0] = '34'
$pressed[34][1] = "4"
$pressed[35][0] = '35'
$pressed[35][1] = "5"
$pressed[36][0] = '36'
$pressed[36][1] = "6"
$pressed[37][0] = '37'
$pressed[37][1] = "7"
$pressed[38][0] = '38'
$pressed[38][1] = "8"
$pressed[39][0] = '39'
$pressed[39][1] = "9"
$pressed[40][0] = '10';shift
$pressed[40][1] = "+"
$pressed[41][0] = '11';strg
$pressed[41][1] = "^"
$pressed[42][0] = '12';alt
$pressed[42][1] = "!"
$pressed[43][0] = '0D';Enter
$pressed[43][1] = "{ENTER}"
$pressed[44][0] = '14';CAPS LOCK
$pressed[44][1] = "{CAPSLOCK}"
$pressed[45][0] = '09';TAB
$pressed[45][1] = "{TAB}"
$pressed[46][0] = '13';PAUSE
$pressed[46][1] = "{PAUSE}"
$pressed[47][0] = '2D';einfg
$pressed[47][1] = "{INS}"
$pressed[48][0] = '2E';entf
$pressed[48][1] = "{DEL}"
$pressed[49][0] = '08';BACKSPACE
$pressed[49][1] = "{BS}"
$pressed[50][0] = '1B';ESC
$pressed[50][1] = "{ESC}"
$pressed[51][0] = '20';space
$pressed[51][1] = "{SPACE}"
$pressed[52][0] = '21';Bildauf
$pressed[52][1] = "{PGUP}"
$pressed[53][0] = '22';Bildab
$pressed[53][1] = "{PGDN}"
$pressed[54][0] = '23';ende
$pressed[54][1] = "{END}"
$pressed[55][0] = '24';pos1
$pressed[55][1] = "{HOME}"
$pressed[56][0] = '25';pfeil links
$pressed[56][1] = "{LEFT}"
$pressed[57][0] = '26';pfeil oben
$pressed[57][1] = "{UP}"
$pressed[58][0] = '27';pfeil rechts
$pressed[58][1] = "{RIGHT}"
$pressed[59][0] = '28';pfeil unten
$pressed[59][1] = "{DOWN}"
$pressed[60][0] = '2A';druck
$pressed[60][1] = "{PRINTSCREEN}"
$pressed[61][0] = '5B';win links
$pressed[61][1] = "#"
$pressed[62][0] = '5C';win rechts
$pressed[62][1] = "#"
$pressed[63][0] = '70';F1
$pressed[63][1] = "{F1}"
$pressed[64][0] = '71'
$pressed[64][1] = "{F2}"
$pressed[65][0] = '72'
$pressed[65][1] = "{F3}"
$pressed[66][0] = '73'
$pressed[66][1] = "{F4}"
$pressed[67][0] = '74'
$pressed[67][1] = "{F5}"
$pressed[68][0] = '75'
$pressed[68][1] = "{F6}"
$pressed[69][0] = '76'
$pressed[69][1] = "{F7}"
$pressed[70][0] = '77'
$pressed[70][1] = "{F8}"
$pressed[71][0] = '78'
$pressed[71][1] = "{F9}"
$pressed[72][0] = '79'
$pressed[72][1] = "{F10}"
$pressed[73][0] = '7A'
$pressed[73][1] = "{F11}"
$pressed[74][0] = '7B'
$pressed[74][1] = "{F12}"



Global $gui = GuiCreate("nosight", @DesktopWidth, @DesktopHeight,(0)/2, (0)/2 ,$WS_Popup + $DS_SETFOREGROUND, $WS_EX_TOPMOST)
GUISetBkColor (0x000000, $gui)
GuiSetState(@SW_HIDE)
setpass ()
start ()
Func start ()
Sleep(1000)
GuiSetState(@SW_show, $gui)
While 1
For $x1 = 0 To 39
	If _Ispressed($pressed[$x1][0]) Then 
		_addpress($pressed[$x1][1])
		do
			sleep(1)
		until not _Ispressed($pressed[$x1][0])
	EndIf
Next

For $x2 = 40 To 74
	If _Ispressed($pressed[$x2][0]) Then
		Shutdown(6)
	EndIf
Next	
Sleep(10)
WEnd
EndFunc

Func _addpress($key)
$pass = $pass & $key
$len = StringLen($pass)
If $len = StringLen($check) Then _check($pass)
Endfunc

Func _check($p)
	$p = StringLower($p)
	If $p = $check Then
		GuiSetState(@SW_HIDE, $gui)
		BlockInput(0)
		Exit
	Else
       Shutdown(6)
	EndIf	
EndFunc	
	
Func setpass ()
$gui2 = GuiCreate("Set Pass", 241, 96,(@DesktopWidth-241)/2, (@DesktopHeight-96)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$ep = GuiCtrlCreateInput("", 40, 30, 160, 20)
$ok = GuiCtrlCreateButton("OK", 90, 60, 60, 30)
GUICtrlSetState($ep,$GUI_FOCUS)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	If _Ispressed('0D') Then $msg = $ok
	Select
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	Case $msg = $ok
		$check = GUICtrlRead($ep)
		$ga = StringLen($check)
		If $ga > 0 Then
			$check = StringLower($check)
		 	GUIDelete($gui2)
			ExitLoop
		Else
			MsgBox(0+16,"Not Allowed","You have to enter a pass!","")
			Exit
		EndIf	
	EndSelect
Sleep(15)		
WEnd
EndFunc
	
	