#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Dai ca TOXICVN

 Script Function:
	get avatar yahoo 

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
#include <Misc.au3>

$iChecker = GUICreate("get avatar by toxicvn", 211, 135, 221, 209)

$on_off=GUICtrlCreatePic("",190,73,20,20)

$ID = GUICtrlCreateInput("", 16, 72, 169, 21)
$Check = GUICtrlCreateButton("Get !", 16, 104, 65, 25, 0)
$Exit = GUICtrlCreateButton("Exit", 112, 104, 73, 25, 0)
GUICtrlCreateLabel("Enter the Yahoo ! ID here :", 32, 53, 131, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Select
		
			
		Case $nMsg=$Check or _IsPressed("0D")
			If GuiCtrlRead($ID)="" Then
				MsgBox(0,"Error !", "Please enter an ID !")
			Else
				InetGet("                                         " & GuiCtrlRead($ID),"avatar.JPG", 1)
				 
				Exitloop
			EndIf	
	EndSelect
WEnd


GUICreate("My GUI picture", 350, 300, -1, -1)  ; will create a dialog box that when displayed is centerGUISetBkColor(0xE0FFFF)
$n = GUICtrlCreatePic(@scriptdir & "\avatar.gif", 50, 50, 200, 50)

GUISetState()
; Run the GUI until the dialog is closed
While 1
$msg2 = GUIGetMsg()
		
If $msg2 = $GUI_EVENT_CLOSE Then ExitLoop
WEnd
					