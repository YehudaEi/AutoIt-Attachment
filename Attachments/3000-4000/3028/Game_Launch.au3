#cs
vi:ts=4 sw=4:
Game Launch.au3
Used to launch games from an INI via joystick input, useful if you have no Keyboard or Mouse.  I use shortcuts to setup all the working directory and parameters so if you need to set either or those, I suggest making a shortcut and putting the path to the shortcut in the INI file.
Ejoc


Game Launch.ini should contain:
[GENERAL]
Grand Theft Auto San Andreas	= C:\Documents and Settings\All Users\Desktop\GTA San Andreas.lnk
Mame32	= C:\Documents and Settings\Ejoc\Application Data\Microsoft\Internet Explorer\Quick Launch\Mame.lnk
GAME #3	= PATH TO SHORTCUT
GAME #4	= PATH TO SHORTCUT
GAME #5	= PATH TO SHORTCUT
#ce
#include <GUIConstants.au3>

;Read the ini file and get the list of games
$Games	= INIReadSection("Game Launch.ini","GENERAL")
If @error Then
	MsgBox(0,"NO INI FILE","Could not open Game Launch.ini")
	Exit
EndIf

;Build the GUI
$hGUI	= GUICreate("Game Launcher",@DeskTopWidth,@DeskTopHeight)
GuiSetFont(24)
$hList	= GUICtrlCreateList($games[1][0],5,5,@DesktopWidth-10,@DeskTopHeight-10)

For $i = 2 To $Games[0][0]
	GUICtrlSetData($hList,$Games[$i][0])
Next

;show the GUI
GuiSetState()
GUISetState(@SW_MAXIMIZE)
ControlSend("Game Launcher","",$hList,"{UP}{DOWN}")

$joy	= _JoyInit()
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
;	If WinGetTitle("") = "Game Launcher" Then
	If 1 Then
		$j	= _GetJoy($joy,0)
		If $j[1] > 65000 Or $j[6] = 18000 Then ; pushed down on D-Pad or joystick
			ControlSend("Game Launcher","",$hList,"{Down}")
			Sleep(250)
		EndIf
		If $j[1] < 500 Or $j[6] = 0 Then ; pushed up on D-Pad or joystick
			ControlSend("Game Launcher","",$hList,"{UP}")
			Sleep(250)
		EndIf
		If $j[7] Then ; they pushed a button
			For $i = 1 To $Games[0][0]
				If GUICtrlRead($hList) = $Games[$i][0] Then
					$plist = ProcessList()
					$pNumBeforeLaunch = $plist[0][0]
					RunWait(@comspec & ' /c START /WAIT "" "' & $Games[$i][1] & '"',"",@SW_HIDE)
					Do ; some games will spawn process' so the RunWait doesn't catch all of them
						$plist	= ProcessList()
						Sleep(250)
					Until $plist[0][0] = $pNumBeforeLaunch
					$i = $Games[0][0]
				EndIf
			Next
		EndIf
	EndIf
Wend

_JoyClose($joy)

;======================================
;	_JoyInit()
;======================================
Func _JoyInit()
	Local $joy
	Global $JOYINFOEX_struct	= "dword[13]"

	$joy	= DllStructCreate($JOYINFOEX_struct)
	if @error Then Return 0
	DllStructSetData($joy,1,DllStructGetSize($joy),1)	;dwSize = sizeof(struct)
	DllStructSetData($joy,1,255,2)						;dwFlags = GetAll
	return $joy
EndFunc

;======================================
;	_GetJoy($lpJoy,$iJoy)
;	$lpJoy	Return from _JoyInit()
;	$iJoy	Joystick # 0-15
;	Return	Array containing X-Pos, Y-Pos, Z-Pos, R-Pos, U-Pos, V-Pos,POV
;			Buttons down
;
;			*POV This is a digital game pad, not analog joystick
;			65535	= Not pressed
;			0		= U
;			4500	= UR
;			9000	= R
;			Goes around clockwise increasing 4500 for each position
;======================================
Func _GetJoy($lpJoy,$iJoy)
	Local $coor,$ret

	Dim $coor[8]
	DllCall("Winmm.dll","int","joyGetPosEx",_
			"int",$iJoy,_
			"ptr",DllStructGetPtr($lpJoy))

	if Not @error Then
		$coor[0]	= DllStructGetData($lpJoy,1,3)
		$coor[1]	= DllStructGetData($lpJoy,1,4)
		$coor[2]	= DllStructGetData($lpJoy,1,5)
		$coor[3]	= DllStructGetData($lpJoy,1,6)
		$coor[4]	= DllStructGetData($lpJoy,1,7)
		$coor[5]	= DllStructGetData($lpJoy,1,8)
		$coor[6]	= DllStructGetData($lpJoy,1,11)
		$coor[7]	= DllStructGetData($lpJoy,1,9)
	EndIf

	return $coor
EndFunc

;======================================
;	_JoyClose($lpJoy)
;	Free the memory allocated for the joystick struct
;======================================
Func _JoyClose($lpJoy)
	DllStructDelete($lpJoy)
EndFunc
