#include <GUIConstants.au3>

HotKeySet("{ENTER}", "PressButton")

HotKeySet("{Esc}", "Terminate")

GUICreate("Timer", 160, 175)  

GUISetBkColor (0xA0AAAA)

$file = GUICtrlCreateMenu ("File")

$help = GUICtrlCreateMenu ("Help")

$exit = GUICtrlCreateMenuitem ("Exit", $file)

$info = GUICtrlCreateMenuitem ("Info", $help)

$shut = GUICtrlCreateRadio ("Shutdown", 10, 10, 70, 25)

$rest = GUICtrlCreateRadio ("Reboot", 10, 40, 70, 25)

$log = GUICtrlCreateRadio ("Logoff", 10, 70, 70, 25)

$power = GUICtrlCreateRadio ("Power down", 80, 10, 80, 25)

$suspend = GUICtrlCreateRadio ("Suspend", 80, 40, 80, 25)

$hibernate = GUICtrlCreateRadio ("Hibernate", 80, 70, 80, 25)

$ok = GUICtrlCreateButton ("OK", 80, 130, 40, 20)

$force = GUICtrlCreateButton("Force to...", 10, 100, 65, 25)

GUICtrlSetTip(-1, "Force to shutdown, reboot, logoff...")

$input = GUICtrlCreateInput ("", 10, 130, 60, 20, $ES_NUMBER)

GUICtrlSetTip(-1, "Set how seconds till Shutdown, Reboot, Logoff, Power down, Suspend or Hibernate waits.")

$sec = GUICtrlCreateUpdown($input)

GUICtrlSetLimit ( $sec, 999999, 0)

GUISetState ()     


Do
    $msg = GUIGetMsg()
    
   If $msg = $info Then
MsgBox(4096, "Info", "Welcome to my Timer info!")
MsgBox(4096, "Info", "First press Shutdown, Reboot, Logoff, Power down, Suspend or Hibernate button.")
MsgBox(4096, "Info", "Then write to input how many seconds Shutdown," & @CRLF & "Reboot, Logoff, Power down, Suspend" & @CRLF & "_
or Hibernate waits")
MsgBox(4096, "Info", "And thats all!")
   EndIf 
Select
Case $msg = $ok
GUISetState (@SW_HIDE)
If GUICtrlRead($shut) = GUICtrlSetData ($shut,$GUI_CHECKED) Then
DoThing(1)
ExitLoop
Else
	EndIf
	
If GUICtrlRead($rest) = GUICtrlSetData ($rest,$GUI_CHECKED) Then
DoThing(2)
	ExitLoop
Else
	EndIf
	
If GUICtrlRead($log) = GUICtrlSetData ($log,$GUI_CHECKED) Then
DoThing(0)
	ExitLoop
Else
	EndIf

If GUICtrlRead($power) = GUICtrlSetData ($power,$GUI_CHECKED) Then
DoThing(8)
	ExitLoop
Else
	EndIf

If GUICtrlRead($suspend) = GUICtrlSetData ($suspend,$GUI_CHECKED) Then
DoThing(32)
	ExitLoop
Else
	EndIf

If GUICtrlRead($hibernate) = GUICtrlSetData ($hibernate,$GUI_CHECKED) Then
DoThing(64)
	ExitLoop
Else
	EndIf
Exit
Case $msg = $force
	GUISetState(@SW_HIDE)
	GUICreate("Force to...", 160, 130)
	GUISetBkColor (0xA0AAAA)
	$shut = GUICtrlCreateRadio ("Shutdown", 10, 10, 70, 25)

$rest = GUICtrlCreateRadio ("Reboot", 10, 40, 70, 25)

$log = GUICtrlCreateRadio ("Logoff", 10, 70, 70, 25)

$power = GUICtrlCreateRadio ("Power down", 80, 10, 80, 25)

$suspend = GUICtrlCreateRadio ("Suspend", 80, 40, 80, 25)

$hibernate = GUICtrlCreateRadio ("Hibernate", 80, 70, 80, 25)

$ok = GUICtrlCreateButton ("OK", 80, 100, 40, 20)
	
$input = GUICtrlCreateInput ("", 10, 100, 60, 20, $ES_NUMBER)

GUICtrlSetTip(-1, "Set how much seconds Shutdown, Reboot, Logoff, Power down, Suspend or Hibernate waits.")

$sec = GUICtrlCreateUpdown($input)

GUICtrlSetLimit ( $sec, 999999, 0)

GUISetState()
	Do
		$msg = GUIGetMsg()
		Select
Case $msg = $ok
GUISetState (@SW_HIDE)
If GUICtrlRead($shut) = GUICtrlSetData ($shut,$GUI_CHECKED) Then
Sleep(GUICtrlRead($input) &"000")
	MsgBox(16, "", "Force to Shutdown")
	Exit
Else
	EndIf
	
If GUICtrlRead($rest) = GUICtrlSetData ($rest,$GUI_CHECKED) Then
Sleep(GUICtrlRead($input) &"000")
	MsgBox(16, "", "Force to Restart")
	Exit
Else
	EndIf
	
If GUICtrlRead($log) = GUICtrlSetData ($log,$GUI_CHECKED) Then
Sleep(GUICtrlRead($input) &"000")
	MsgBox(16, "", "Force to Logoff")
	Exit
Else
	EndIf

If GUICtrlRead($power) = GUICtrlSetData ($power,$GUI_CHECKED) Then
Sleep(GUICtrlRead($input) &"000")
	MsgBox(16, "", "Force to Power down")
	Exit
Else
	EndIf

If GUICtrlRead($suspend) = GUICtrlSetData ($suspend,$GUI_CHECKED) Then
Sleep(GUICtrlRead($input) &"000")
	MsgBox(16, "", "Force to Suspend")
	Exit
Else
	EndIf

If GUICtrlRead($hibernate) = GUICtrlSetData ($hibernate,$GUI_CHECKED) Then
Sleep(GUICtrlRead($input) &"000")
	MsgBox(16, "", "Force to Hibernate")
	Exit
Else
	EndIf
		Exit
		EndSelect
		Until $msg = $GUI_EVENT_CLOSE

EndSelect

Until $msg = $GUI_EVENT_CLOSE Or $msg = $exit


Func PressButton()
	$msg = $ok
EndFunc

Func Terminate()
	Exit 0
EndFunc
Func DoThing($_num)
	Sleep(GUICtrlRead($input) &"000")
	ShutDown($_num)
	EndFunc
	
