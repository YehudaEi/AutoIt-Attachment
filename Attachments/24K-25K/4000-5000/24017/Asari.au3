#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Ikaika Honda <ikaika@hondadesigns.com>
 
 Thanks to google for their Defining abilities haha
 

 Script Function:
	uses Googles define ability to search quickly without the need to load a browser
	

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $oIE
Global $Term


$oIE = ObjCreate("Shell.Explorer.2")
InetGet("                                                         ",@ScriptDir & "\splash_image.jpg")
SplashImageOn("Asari",@ScriptDir & "\splash_image.jpg", 550,370,-1,-1,3)
Sleep(4000)
SplashOff()


#Region ### START Koda GUI section ### Form=
$Asari = GUICreate("Asari | Alpha Version", 701, 551, -1, -1)
$Term = GUICtrlCreateInput("", 32, 24, 489, 21)
$Search = GUICtrlCreateButton("Define", 560, 16, 105, 33, 0)
$Definition = GUICtrlCreateObj($oIE,20,60,650,470)
GUICtrlSetState($Search, $GUI_DEFBUTTON)
GUICtrlSetState($Term, $GUI_FOCUS)
GUISetState(@SW_SHOW)
$oIE.navigate("                              ")
#EndRegion ### END Koda GUI section ###

While 1
$nMsg = GUIGetMsg()
Switch $nMsg

	Case $Search
		_Define()
	
Case $GUI_EVENT_CLOSE
Exit

EndSwitch
WEnd


Func _Define()
	$gTerm = GUICtrlRead($Term)
	$oIE.navigate("http://www.google.com/search?q=define%3A+" & $gTerm)
EndFunc
	