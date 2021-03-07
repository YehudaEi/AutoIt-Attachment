#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>
#include <ListboxConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarConstants.au3>
#include <File.au3>
#include <Timers.au3>

Dim $LogWindow=0

Func CreateLogWindow($Title,$Width,$Height)
	If $LogWindow<>0 Then
		MsgBox(0,"Internal Error","Log window was already created")
		Return
		EndIf
	GUICreate($Title,$Width,$Height)
	$LogWindow=GUICtrlCreateList("",5,5,$Width-10,$Height-10,$LBS_NOSEL+$WS_VSCROLL)
	GUISetState()
	EndFunc

Func LogString($LogText)
	If $LogWindow=0 Then
		MsgBox(0,"Internal Error","Log window used but not yet created")
		CreateLogWindow("LogWindow",800,300)
		EndIf
	GUICtrlSetData($LogWindow,$LogText)
	GUICtrlSendMsg($LogWindow,$WM_VSCROLL,$SB_LINEDOWN,0)
	EndFunc

Func TimerCallback($hWnd, $Msg, $iIDTimer, $dwTime)
	LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Called TimerCallback()")
	EndFunc

; Start of program
CreateLogWindow("Log",900,500)

$MainWindow=GUICreate("Test-1",370,86) ; The main window
$Button_1=GUICtrlCreateButton("Button_1",10,53)
$Button_2=GUICtrlCreateButton("Button_2",100,53)
$Exit=GUICtrlCreateButton("Cancel (Exit)",190,53)
GUISetState()

$Timer_1=_Timer_SetTimer($MainWindow,1000,"TimerCallback",-1)
LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Started Timer_1 1000ms")
$Timer_2=_Timer_SetTimer($MainWindow,1900,"",-1)
LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Started Timer_2 1900ms")

$cnt=0

While 1
	$Msg = GUIGetMsg()
;	LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Received event"&$Msg)
	Switch $Msg
		Case $WM_TIMER
			LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Received WM_TIMER event")
		Case $Button_1
			LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Received Button_1 event")
		Case $Button_2
			LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Received Button_2 event")
		Case $Exit
			LogString(@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&": Received Exit event")
			MsgBox(0,"Handling Exit event","Exiting")
			Exit
		Case $GUI_EVENT_CLOSE
			Exit
		EndSwitch
	WEnd