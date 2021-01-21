#comments-start
	autoinstall v2.0
	POC SrA Justin Pounders 17 SOS/SC Kadena AB, Japan
	current build date: June 12 2006
#comments-end
;////////////////////////HEADER//////////////////////////////////////////
#include <guiconstants.au3>
#include <process.au3>
;////////////////////////GUI VARS////////////////////////////////////////
$main_window = GUICreate("AutoInstall", 410, 75) ;primary window construct
$sec_window = GUICreate("Working...", 410, 75) ;installation window construct
$wri_window = GUICreate("File Adder", 320, 60) ;write to file window construct
$wri_sub1 = GUICreate("Switches", 150, 160) ;switches window construct
$vis = 1 ;determines window
;////////////////////////DATABASE VARS///////////////////////////////////
$file_r = FileOpen("filelist.bat", 0) ;open database read only
$file_w = FileOpen("filelist.bat", 1) ;open database append
$line = FileReadLine($file_r); read database line
;////////////////////////ERROR CODE VARS/////////////////////////////////
$error1 = StringFormat('The computer %s is not part of the "KADENA" domain. Please add this computer to the domain before proceeding.', @ComputerName) ;wrong domain
$error2 = StringFormat("%s", $line) ;used for troubleshooting only - gives name of return value from '$line'
$error3 = StringFormat("File error: %s") ;generic error code
;////////////////////////MISC. VARS//////////////////////////////////////
$date = "12 June, 2006" ;sets date
$confirm1 = StringFormat('This will install all applications and updates required as of %s.  Continue?', $date) ;date/confirm
$list_chk = 1 ;is database file there?
$silent1 = "" ;add command line parameter
$quiet1 = "" ;add command line parameter
$passive1 = "" ;add command line parameter
$norestart1 = "" ;add command line parameter
$cap_s1 = "" ;add command line parameter
$s1 = "" ;add command line parameter
$q1 = "" ;add command line parameter
$v1 = "" ;add command line parameter
$qn1 = "" ;add command line parameter
$u1 = "" ;add command line parameter
$z1 = "" ;add command line parameter
$switch = "" ;detect if switches have been selected
;////////////////////////OPTIONS/////////////////////////////////////////
Opt("guioneventmode", 1)
AutoItSetOption("RunErrorsFatal", 0)
;///////////////////////DOMAIN CHECK AND PERMISSIONS/////////////////////
If @LogonDomain = "KADENA" Then
	_RunDOS("cacls c:\windows\temp /e /p builtin\users:c")
Else
	MsgBox(0, "Error", $error1)
	Exit
EndIf
;////////////////////////START GUI///////////////////////////////////////
Call("win")
;////////////////////////STALL LOOP//////////////////////////////////////
While 1
	Sleep(500)
WEnd
;////////////////////////FUNCTIONS///////////////////////////////////////
Func win()
	Select
		Case $vis = 1 ;primary window
			GUISetState(@SW_SHOW, $main_window)
			GUISetState(@SW_HIDE, $sec_window)
			GUISetState(@SW_HIDE, $wri_window)
			GUISetState(@SW_HIDE, $wri_sub1)
			GUISwitch($main_window)
			$ok = GUICtrlCreateButton("Continue", 10, 40, 75)
			$write = GUICtrlCreateButton("Edit File List", 105, 40, 75)
			$cancel = GUICtrlCreateButton("Exit", 325, 40, 75)
			GUICtrlCreateLabel($confirm1, 10, 10)
			GuiCtrlSetOnEvent($ok, "ok")
			GuiCtrlSetOnEvent($cancel, "close")
			GuiCtrlSetOnEvent($write, "call_edit_window")
			GUISetOnEvent($gui_event_close, "close")
		Case $vis = 2 ;installation window
			GUISetState(@SW_HIDE, $main_window)
			GUISetState(@SW_SHOW, $sec_window)
			GUISetState(@SW_HIDE, $wri_window)
			GUISetState(@SW_HIDE, $wri_sub1)
			GUISwitch($sec_window)
			$cancel = GUICtrlCreateButton("Cancel", 10, 40, 80)
			GUICtrlCreateLabel("This process may take several minutes depending on the speed of the workstation.", 10, 10)
			GuiCtrlSetOnEvent($cancel, "close")
			GUISetOnEvent($gui_event_close, "close")
		Case $vis = 3 ;file edit window
			GUISetState(@SW_HIDE, $main_window)
			GUISetState(@SW_HIDE, $sec_window)
			GUISetState(@SW_SHOW, $wri_window)
			GUISetState(@SW_HIDE, $wri_sub1)
			GUISwitch($wri_window)
			GUICtrlCreateLabel('Input FULL path and filename in this format "C:\Path\Filename"', 10, 10)
			$ok = GUICtrlCreateButton("OK", 10, 30, 50)
			Global $input1 = GUICtrlCreateInput("C:\Path\File.exe", 70, 30, 230)
			GUISetOnEvent($gui_event_close, "close")
			GuiCtrlSetOnEvent($ok, "write")
		Case $vis = 4 ;file edit sub1
			GUISetState(@SW_HIDE, $main_window)
			GUISetState(@SW_HIDE, $sec_window)
			GUISetState(@SW_HIDE, $wri_window)
			GUISetState(@SW_SHOW, $wri_sub1)
			GUISetOnEvent($gui_event_close, "close")
			Global $silent = GUICtrlCreateCheckbox("/Silent", 10, 10)
			Global $quiet = GUICtrlCreateCheckbox("/Quiet", 10, 30)
			Global $passive = GUICtrlCreateCheckbox("/Passive", 10, 50)
			Global $norestart = GUICtrlCreateCheckbox("/Norestart", 10, 70)
			Global $cap_s = GUICtrlCreateCheckbox("/S", 10, 90)
			Global $s = GUICtrlCreateCheckbox("/s", 10, 110)
			Global $q = GUICtrlCreateCheckbox("/q", 100, 10)
			Global $v = GUICtrlCreateCheckbox("/v", 100, 30)
			Global $qn = GUICtrlCreateCheckbox("/qn", 100, 50)
			Global $u = GUICtrlCreateCheckbox("/u", 100, 70)
			Global $z = GUICtrlCreateCheckbox("/z", 100, 90)
			Global $ok = GUICtrlCreateButton("OK", 5, 135, 70)
			GuiCtrlSetOnEvent($ok, "switch_win")
			GUISetOnEvent($gui_event_close, "close")
			
		Case $vis = 5 ;complete
			MsgBox(0, "Done", "Operation Complete!")
	EndSelect
EndFunc   ;==>win
Func ok()
	$vis = 2
	Call("win")
	Call("listread")
	$vis = 1
	Call("win")
EndFunc   ;==>ok
Func listread()
	If $file_r = -1 Then
		MsgBox(0, "Error", $error3 & "Filelist.dat")
		$list_chk = 0
	EndIf
	Run("cmd /K title Auto", "", @SW_SHOW)
	WinWaitActive("Auto")
	while 1
	$line = FileReadLine ($file_r)
	if @error = -1 then ExitLoop
	ControlSend("Auto", "", "", $line & "{ENTER}")
	WEnd
	$vis = 5
	Call("win")
EndFunc   ;==>listread
Func call_edit_window()
	$vis = 3
	Call("win")
EndFunc   ;==>call_edit_window
Func write()
	If @GUI_WinHandle <> $wri_sub1 Then
		Global $input2 = GUICtrlRead($input1)
		MsgBox(0, "Instructions", "AutoInstall will now try to determine the switches associated with " & $input2 & ".  Afterwords, a screen will pop up asking you to select the switches that will make the program you are adding run in silent mode.  Select the values from the first screen and click ""OK"" and the file will be added to a database with the correct directory and switches.")
		Run(@ComSpec & " /c " & $input2 & " /?")
		$vis = 4
		Call("win")
	EndIf
	If @GUI_WinHandle = $wri_sub1 Then
		$msg = StringFormat('File "%s" added to File List.', $input2)
		FileWriteLine($file_w, $input2 & $silent1 & $quiet1 & $passive1 & $norestart1 & $cap_s1 & $s1 & $q1 & $v1 & $qn1 & $u1 & $z1)
		MsgBox(0, "Successful!", "File " & $input2 & " add to file list.")
		$switch = 0
		$vis = 3
		Call("win")
	EndIf
EndFunc   ;==>write
Func switch_win()
	If GUICtrlRead($silent) = $gui_checked Then
		$silent1 = "/silent "
	EndIf
	If GUICtrlRead($quiet) = $gui_checked Then
		$quiet1 = "/quiet "
	EndIf
	If GUICtrlRead($passive) = $gui_checked Then
		$passive1 = "/passive "
	EndIf
	If GUICtrlRead($norestart) = $gui_checked Then
		$norestart1 = "/norestart "
	EndIf
	If GUICtrlRead($cap_s) = $gui_checked Then
		$cap_s1 = "/S "
	EndIf
	If GUICtrlRead($s) = $gui_checked Then
		$s1 = "/s "
	EndIf
	If GUICtrlRead($q) = $gui_checked Then
		$q1 = "/q "
	EndIf
	If GUICtrlRead($v) = $gui_checked Then
		$v1 = "/v "
	EndIf
	If GUICtrlRead($qn) = $gui_checked Then
		$qn1 = "/qn "
	EndIf
	If GUICtrlRead($u) = $gui_checked Then
		$u1 = "/u "
	EndIf
	If GUICtrlRead($z) = $gui_checked Then
		$z1 = "/z "
	EndIf
	Call("write")
EndFunc   ;==>switch_win
Func close()
	If @GUI_WinHandle <> $main_window Then
		$vis = 1
		Call("win")
	Else
		Exit
	EndIf
EndFunc   ;==>close
;////////////////////////EOF/////////////////////////////////////////////