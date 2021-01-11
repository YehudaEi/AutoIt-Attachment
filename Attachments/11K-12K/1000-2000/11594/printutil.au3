#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         Steven Vandenhoute

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
FileInstall("P&F 27.ico", "P&F 27.ico",1)
#NoTrayIcon


Dim $server

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\b00b27\Desktop\printerutility\form1.kxf
$Form1 = GUICreate("Network Printer Utility", 269, 135, 193, 115)
GUISetFont(8, 400, 0, "Comic Sans MS")
$Icon1 = GUICtrlCreateIcon("P&F 27.ico",0, 16, 16, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
$Label1 = GUICtrlCreateLabel("NPU", 16, 48, 43, 31)
GUICtrlSetFont(-1, 14, 800, 0, "Comic Sans MS")
$Combo1 = GUICtrlCreateCombo("", 80, 20, 185, 25)
GUICtrlSetData($Combo1, "Bebrus60|Bebrus64|bebrus80")
GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")
$Combo2 = GUICtrlCreateCombo("", 80, 50, 185, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")
$Button2 = GUICtrlCreateButton("Install", 48, 100, 90, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")
$Button1 = GUICtrlCreateButton("Exit", 168, 100, 90, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")




GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$Msg = GUIGetMsg()
		Select
		Case $msg=$GUI_EVENT_CLOSE or $msg=$Button1
			ExitLoop
	
	
		Case $msg = $Combo1
			$server=GUICtrlRead($Combo1)
			if $server="Bebrus60" Then
				GUICtrlSetData($Combo2,"")
				GUICtrlSetData($Combo2, "Bebrup04|Bebrup73|Bebrup77|BebrupF9|BebrupG4|BebrupG5|BebrupG6|BebrupG7|BebrupL1|BebrupL4")
			ElseIf $server="Bebrus64" Then
				GUICtrlSetData($Combo2,"")
				GUICtrlSetData($Combo2, "Rankxerox|Xerox|Bebrup00|Bebrup01|Bebrup02|Bebrup03|Bebrup05|Bebrup07|Bebrup08|Bebrup09|Bebrup10|Bebrup11|Bebrup12|Bebrup13|Bebrup14|Bebrup15|Bebrup16|Bebrup17|Bebrup18|Bebrup19|Bebrup20|Bebrup21|Bebrup22|Bebrup23|Bebrup24|Bebrup25|Bebrup26|Bebrup27|Bebrup28|Bebrup29|Bebrup30|Bebrup31|Bebrup32|Bebrup33|Bebrup36|Bebrup38|Bebrup41|Bebrup42|Bebrup43|Bebrup44|Bebrup45|Bebrup46|Bebrup48|Bebrup49|Bebrup50|Bebrup51|Bebrup54|Bebrup55|Bebrup56|Bebrup58|Bebrup59|Bebrup60|Bebrup61|Bebrup66|Bebrup68|Bebrup70|Bebrup71|Bebrup74|Bebrup75|Bebrup76|Bebrup78|Bebrup79|Bebrup82|Bebrup85|Bebrup86|Bebrup88|Bebrup90|Bebrup91|Bebrup92|Bebrup95|Bebrup97|Bebrup99|BebrupA1|BebrupA2|BebrupA5|BebrupA7|BebrupA9|BebrupB1|BebrupB3|BebrupB4|BebrupB6|BebrupB7|BebrupB8|BebrupC0|BebrupC2|BebrupC3|BebrupC6|BebrupD1|BebrupD2|BebrupD3|BebrupD4|BebrupE3|BebrupE4|BebrupE7|BebrupE9|BebrupF4|BebrupF5|BebrupF7|BebrupG0|BebrupG1|BebrupG2|BebrupG3|BebrupG8|BebrupG9|BebrupH0|BebrupH1|Bebrup2|BebrupH3|BebrupH4|BebrupH5|BebrupH6|BebrupH7|BebrupH8|BebrupH9|BebrupI0|BebrupI1|BebrupI2|BebrupI3|BebrupI4|BebrupI5|BebrupI6|BebrupI7|BebrupI8|BebrupI9|BebrupJ0|BebrupJ1|BebrupJ2|BebrupJ3|BebrupJ4|BebrupJ5|BebrupJ6|BebrupJ7|BebrupJ8|BebrupJ9|BebrupK0|BebrupK1|BebrupK2|BebrupK3|BebrupK4|BebrupK5|BebrupK6|BebrupK7|BebrupL0|BebrupL2|BebrupL3")
			Else
				GUICtrlSetData($Combo2,"")
				GUICtrlSetData($Combo2, "BEVEP20|BEVEP21|BEVEP22|BEVEP23|BEVEP24|BEVEP25|BEVEP26|BEVEP31|BEVEP32|BEVEP35|BEVEP36")
						
					EndIf
					
				case $msg=$Button2




if GUICtrlRead($Combo1)="" or GUICtrlRead($Combo2)="" Then
	MsgBox(0,"ERROR", "Please select Server and printer")
Else
	
_addprinter()

EndIf



	EndSelect
WEnd



Func _addprinter()

$url="\\"& $server &"\"&GUICtrlRead($Combo2)
RunWait("rundll32 printui.dll,PrintUIEntry /in /q /n" & $url)



EndFunc



	
	