#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

local $email, $number, $2007 = 'U', $2003 = 'J', $outlook, $submit1, $submit1, $gui1, $result,$var1
local $sec

Opt("GUIOnEventMode",1)

$Form1_1 = GUICreate("Outlook emailer", 532, 231, 168, 130)

$input1 = GUICtrlCreateInput("Email", 24, 40, 481, 21)
$Label1 = GUICtrlCreateLabel("Enter Email address to send to:-", 16, 8, 193, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

$Label2 = GUICtrlCreateLabel("How many messages to be sent", 8, 80, 195, 20)
$input2 = GUICtrlCreateInput("1", 24, 104, 73, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))

GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetLimit(-1, 3)

$Label3 = GUICtrlCreateLabel("Time duratation in Seconds", 288, 80, 133, 17)
$input3 = GUICtrlCreateInput("3", 288, 104, 41, 21,BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
GUICtrlSetLimit($input3, 3)

$radio1 = GUICtrlCreateRadio("Outlook 2003", 24, 152, 113, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState($radio1, $GUI_CHECKED)

$radio2 = GUICtrlCreateRadio("Outlook 2007", 24, 192, 113, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

$Start = GUICtrlCreateButton("Start", 336, 168, 137, 41, $WS_GROUP)
GUICtrlSetOnEvent($Start,"start")

$filemenu = GUICtrlCreateMenu("File")
$fileitem = GUICtrlCreateMenuItem("Open...", $filemenu)
$recentfilesmenu = GUICtrlCreateMenu("Recent Files", $filemenu)
$separator1 = GUICtrlCreateMenuItem("", $filemenu)
$exititem = GUICtrlCreateMenuItem("Exit", $filemenu)

GUISetState (@SW_SHOW)
While 1

$Msg = GUIGetMsg()
Sleep(1000)
if $Msg -0 Then exit
if $Msg=$Start then Start()
WEnd

Func start()
$email=GUICtrlRead($input1)
msgbox (0, "read", "User Input is " & $email)

$number=GUICtrlRead($input2)
msgbox (0, "read", "User Input is " & $number)

$sec=GUICtrlRead($input3)
msgbox (0, "read", "User Input is " & $sec)


;	While 1
;		$msg = GUIGetMsg(1)
;	Select
;	Case $msg[0] = $submit1
;	ExitLoop

;EndSelect

;WEnd
	Select
	Case GUICtrlRead($radio1) = $GUI_CHECKED
		$var1 = $2003
	Case GUICtrlRead($radio2) = $GUI_CHECKED
		$var1 = $2007 ;Or another var
EndSelect

;GUIDelete($gui1)
;Process result
$outlook = $var1
MsgBox(0,"Result",$outlook)


GUISetState()

	While 1
		$Msg = GUIGetMsg(2)

	Select
		Case $Msg = $GUI_EVENT_CLOSE
				ExitLoop

			Case $Msg = $fileitem
				$file = FileOpenDialog("Choose file...", @WorkingDir & "\",  "All (*.*)")
				If @error <> 1 Then GUICtrlCreateMenuItem($file, $recentfilesmenu)
				ExitLoop

		EndSelect
	WEnd

	GUIDelete()
	Exit

			Sleep (500)
$x=0

Do

	WinActivate("Inbox - Microsoft Outlook", "")
		Send("^n") ; Ctrl N "for  new email window"
	WinActivate("Untitled - Message (Rich Text) ", "")
		Send ($input1)
		Send ("!" & $outlook) ; "Alt J"  key pressed for subject box
		Send ("Message" &  $input2)
		Send("!if") ; Alt I F keys " to open Attachment window "
	WinWait("", "",5)
		send ($fileitem)
	;Send ("C:\Program Files\test.txt")
	WinWait("", "", 5)
		Send("{ENTER}")
		Send("{ENTER}")
	WinWait("", "", 5)
		Send("^{ENTER}")
		Sleep (1000 * $sec)
			$x=$x+1
Until $x=$input2
	MsgBox (0, "Message Sent", "Total of "& $x & " messages has been sent to " & $input1)

Exit

EndFunc
