#include <GUIConstantsEx.au3>
#include <memory.au3>
#include <Array.au3>
Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)

_Main()

Func _Main()
	Global $exititem, $okbutton, $pausebutton
	Global $answer, $timer, $RndPause
	Global $Start, $Pause, $Notepad
	
	Opt("SendKeyDelay", 250)
	Opt("SendKeydownDelay", 100)

	GUICreate("SendKeys Broken GUI", 480, 300)

	BuildGui()
	
	GUISetState()
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	GUIctrlSetOnEvent($okbutton, "_setstart")
	GUIctrlSetOnEvent($pausebutton, "_Pause")
	
	$Start = False
	$Pause = False
	
	While 1
		sleep(100)
		if $Start Then
			StartCrunching()
			$Start = False
		EndIf
	WEnd

	GUIDelete()

	Exit
EndFunc

Func StartCrunching()
	For $i = 8 To 1 Step -1
		Nuuu(2)
	Next
EndFunc

Func Nuuu($NuuuNumber)
	While $Pause
		WaitRND(1,2)
	WEnd
		ControlSend("Untitled - Notepad", "", "", "{left}{down}")
	
		ControlSend("Untitled - Notepad", "", "", "{enter}")
		WaitRND(3,4)
		
		For $iii = 0 to 8 Step 1
				ControlSend("Untitled - Notepad", "", "", "{down}")
		Next
	While $Pause
		WaitRND(1,2)
	WEnd
		ControlSend("Untitled - Notepad", "", "", "{enter}")
		WaitRND(3,4)
		While $Pause
			WaitRND(1,2)
		WEnd
		ControlSend("Untitled - Notepad", "", "", "{enter}") 
		WaitRND(3,4)
		While $Pause
			WaitRND(1,2)
		WEnd
		ControlSend("Untitled - Notepad", "", "", "{left}{down}")
		WaitRND(1,2)
		While $Pause
			WaitRND(1,2)
		WEnd
		ControlSend("Untitled - Notepad", "", "", "{enter}")
		WaitRND(2,3)
		ControlSend("Untitled - Notepad", "", "", "{left}")
		For $ii = 0 to 8 Step 1
			If ($ii > 0) Then
				ControlSend("Untitled - Notepad", "", "", "{down}")
			EndIf
		Next
		While $Pause
			WaitRND(1,2)
		WEnd
		ControlSend("Untitled - Notepad", "", "", "{enter}")
		While $Pause
			WaitRND(1,2)
		WEnd
		ControlSend("Untitled - Notepad", "", "", "{enter}")
	
	WaitRND(6,8)
	ControlSend("Untitled - Notepad", "", "", "{left}{pgdn}")
	ControlSend("Untitled - Notepad", "", "", "{left}{down}{down}{down}")
	ControlSend("Untitled - Notepad", "", "", "{left}{pgdn}")
	ControlSend("Untitled - Notepad", "", "", "{left}{down}{down}")
	WaitRND(5,8)
EndFunc

Func BuildGui()
	$Notepad = FindNotepad()
	
	$okbutton =     GUIctrlCreateButton("Start",  10, 250, 40, 20)
	$pausebutton =  GUIctrlCreateButton("Pause",  160, 250, 40, 20)

EndFunc

Func FindNotepad()
	Local $pid
	$pid = WinGetProcess("Untitled - Notepad")
	If $pid = -1 Then
		MsgBox(0, "ERROR", "Notepad is not runing or cannot be found")
		Exit
	EndIf
	Return $pid
EndFunc

Func WaitRND($low, $high)
	Local $timer, $RndPause
		$timer = TimerInit()
		$RndPause = 1000*Random($low, $high,.05)
		While (TimerDiff($timer) < $RndPause)
		WEnd
EndFunc

Func _setstart()
	$start = True
EndFunc

Func _Exit()
	Exit
EndFunc