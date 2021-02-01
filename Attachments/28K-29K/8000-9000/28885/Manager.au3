#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
$windowname = ("") ;Enter the name of your silkroad window here
$sbotdirect = ("") ;Enter the path to your sbot directory
$silkroadpath = ("C:\Program Files (x86)\Silkroad\Silkroad.exe") ;Enter the path to your silkroad directory
$loaderpath = ("") ;Enter the path to your loader
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Silkroad Manager", 437, 337, 192, 124)
$Button1 = GUICtrlCreateButton("Minimize", 16, 48, 75, 25, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Maximize", 16, 80, 75, 25, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Show", 16, 112, 75, 25, $WS_GROUP)
$Button4 = GUICtrlCreateButton("Hide", 16, 144, 75, 25, $WS_GROUP)
$Button5 = GUICtrlCreateButton("Start Sbot", 16, 176, 75, 25, $WS_GROUP)
$Button6 = GUICtrlCreateButton("Start Silkroad", 16, 208, 75, 25, $WS_GROUP)
$Button7 = GUICtrlCreateButton("Start Sbot + Silkroad", 16, 272, 123, 25, $WS_GROUP)
$Button8 = GUICtrlCreateButton("Start Silkroad + Loader", 16, 240, 123, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("You need to Start Silkroad with Loader so all functions work!", 8, 8, 288, 17)
$Label2 = GUICtrlCreateLabel("By: San_Bow", 144, 304, 68, 17)
$ID = GUICtrlCreateInput("ID", 112, 48, 121, 21)
$Password = GUICtrlCreateInput("Password", 112, 80, 121, 21)
$Character = GUICtrlCreateInput("Character", 112, 112, 121, 21)
$Edit1 = GUICtrlCreateEdit("", 176, 56, 1, 9)
GUICtrlSetData(-1, "Edit1")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

;Loop Statament

While 1
    $msg = GUIGetMsg()

If $msg = $min Then
	min()
EndIf

If $msg = $max Then
    max()
EndIf

If $msg = $hide Then
    hide()
EndIf

If $msg = $show Then
    show()
EndIf

If $msg = $startsbot Then
	startsbot()
EndIf

If $msg = $startsilkroad Then
	startsilkroad()
EndIf

If $msg = $startloader Then
	startloader()
EndIF

WEnd

Func min()
    WinSetState("$windowname","",@SW_MINIMIZE)
EndFunc

Func max()
    WinSetState("$windowname","",@SW_MAXIMIZE)
EndFunc

Func hide()
    WinSetState("$windowname","",@SW_HIDE)
EndFunc

Func show()
    WinSetState("$windowname","",@SW_SHOW)
EndFunc

Func startsbot()
	Run ($sbotdirect)
EndFunc

Func startsilkroad ()
	Run ($silkroadpath)
EndFunc

Func startloader()
	Run ($loaderpath)
EndFunc
