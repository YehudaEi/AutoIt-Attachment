#cs

Admin_Popup
Show computer information or launch shell when hotkey is pressed
-John Taylor
May-24-2005

#ce

#include <GUICONSTANTS.au3>
#notrayicon
Opt ("GUIOnEventMode", 1)
Opt ("MustDeclareVars", 1)
Opt ("RunErrorsFatal", 0 )

Dim $Info_Title="System Info"
Dim $Shell_Title="Run Shell"
Dim $UsernameID
Dim $PasswordID
Dim $Shell_Win
Dim $_In_Shell = 0

HotKeySet("^!~", "OnInfo")           ; control alt ~
HotKeySet("+^!{TAB}", "OnShell")     ; shift control alt tab
while 1
	sleep(1000)
wend


func OnShell()
	Dim $SubmitID
	$_In_Shell = 1

	$Shell_Win = GUICreate($Shell_Title, 270, 150)
	GUISetState ()

	GUICtrlCreateLabel ("Username:", 10, 30 )
	$UsernameID = GUICtrlCreateInput ("Administrator", 65, 30, 120)

	GUICtrlCreateLabel ("Password:", 10, 60 )
	$PasswordID = GUICtrlCreateInput ("", 65, 60, 120, -1, $ES_PASSWORD)

	$SubmitID = GUICtrlCreateButton("Submit", 10, 90)
	GUICtrlSetOnEvent($SubmitID,"OnSubmit")

	GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
	ControlFocus($Shell_Title, "", $PasswordID)

	while 1 = $_In_Shell 
		sleep(1000)
	wend

endfunc

Func OnSubmit()
	Dim $u, $p
	$u = GUICtrlRead($UsernameID)
	$p = GUICtrlRead($PasswordID)
	RunAsSet( $u, "", $p, 1 )
	Run(@ComSpec, "C:\") 
	OnExit()
endfunc

Func OnExit()
	$_In_Shell = 0
	;MsgBox(0,"Debug","starting OnExit()")
	GUIDelete( $Shell_Win )
endfunc

func OnInfo()

	Dim $data[15]
	Dim $i = 0
	Dim $output = ""

	$data[1] = "Computer name: " & @ComputerName
	$data[2] = "User name:" & @UserName
	$data[3] = "---------------------------------------"
	$data[4] = "1st IP: " & @IPAddress1
	$data[5] = "2nd IP: " & @IPAddress2
	$data[6] = "---------------------------------------"
	$data[7] = "OS: " & @OSVersion & "  " & @OSServicePack

	for $i = 1 to 7
		$output = $output & $data[$i] & @CR
	next
	
	MsgBox(0,$Info_Title, $output, 7)
endfunc

; end of script

