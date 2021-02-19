#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#Region ### START Koda GUI section ### Form=
#include <filename.txt>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
$Form1 = GUICreate("Password Dialog", 396, 228, -1, -1)
GUISetIcon("D:\008.ico")
$Input1 = GUICtrlCreateInput("", 38, 88, 233, 21)
$PasswordEdit = GUICtrlCreateInput("", 38, 144, 233, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$ButtonOk = GUICtrlCreateButton("Login", 294, 72, 75, 57, 0)
$ButtonCancel = GUICtrlCreateButton("Register", 295, 136, 75, 33, 0)
$EnterPassLabel = GUICtrlCreateLabel("Pw", 38, 124, 19, 17)
$Label1 = GUICtrlCreateLabel("Id", 38, 65, 13, 17)
$Register = GUICtrlCreateLabel("Login", 160, 8, 106, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Pic1 = GUICtrlCreatePic("D:\ice_dragons.jpg", 8, 8, 380, 212, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $buttonok
			$Id1 = GUICtrlRead($input1)
			$Pw1 = GUICtrlRead($passwordedit)
			if $pw1 = $pw and $Id1 = $id Then
				msgbox(0,"","Login Seccesfull" & @crlf &"Have Fun!")
				exit
			Else
				msgbox(0,"","Invalid Id or Pw" & @crlf & "Please try again!")
			EndIf
	EndSwitch
WEnd
