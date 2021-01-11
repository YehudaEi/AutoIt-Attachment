#include <GuiConstants.au3>
$GUI_Handle = GuiCreate("Admin Tools by ~The BISD Rebel~", 445, 175,(@DesktopWidth-445)/2, (@DesktopHeight-175)/2)
$IE = GuiCtrlCreateButton("Internet Explorer", 5, 5, 100, 30)
$cmd = GuiCtrlCreateButton("Command Prompt", 5, 40, 100, 30)
$regedit = GuiCtrlCreateButton("Regedit", 5, 75, 100, 30)
$lock = GuiCtrlCreateButton("Lock Workstation", 115, 5, 100, 30)
$display = GuiCtrlCreateButton("Display Properties", 115, 40, 100, 30)
$standby = GuiCtrlCreateButton("Standby", 115, 75, 100, 30)
$remove = GuiCtrlCreateButton("Remove Programs", 225, 5, 100, 30)
$pws = GuiCtrlCreateButton("User Passwords", 225, 40, 100, 30)
$devman = GuiCtrlCreateButton("Device Manager", 335, 5, 100, 30)
$ieprop = GuiCtrlCreateButton("IE Properties", 225, 75, 100, 30)
$telnet = GuiCtrlCreateButton("Telnet", 335, 40, 100, 30)
$datetime = GuiCtrlCreateButton("Date/Time", 335, 75, 100, 30)
$Browse = GuiCtrlCreateButton("Browse", 5, 135, 100, 30)
$selectedfile = GuiCtrlCreateLabel("Click ""Browse"" to select a file to run.", 114, 133, 210, 43)
$run = GuiCtrlCreateButton("Run", 335, 135, 100, 30)
$custom = GuiCtrlCreateGroup("Custom Program", 0, 115, 440, 60)
Opt("RunErrorsFatal", 0)
$text = "empty"
Func  _ra($file)
		RunAsSet("Admin", @Computername, "a")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "b")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "c")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "d")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "e")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "f")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "g")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "h")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "i")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "j")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "k")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "l")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "m")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "n")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "o")
			Run($file)
				if @error = "0" then $file = "null"
		RunAsSet("Administrator", @Computername, "p")
			Run($file)
				if @error = "0" then $file = "null"
	EndFunc				
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		FileDelete ("C:\~bra1tmp.tmp")
		Exit
	Case $msg = $IE
		_ra("C:\Program Files\Internet Explorer\iexplore.exe")
	Case $msg = $cmd
		_ra(@ComSpec)
	Case $msg = $regedit
		_ra(@WindowsDir & "\regedit.exe")  
	Case $msg = $lock
		_ra("rundll32.exe user32.dll, LockWorkStation")
	Case $msg = $display
		_ra("RUNDLL32.EXE SHELL32.DLL,Control_RunDLL desk.cpl,,0")
	Case $msg = $standby
		_ra("RUNDLL32.EXE PowrProf.dll,SetSuspendState")
	Case $msg = $remove
		_ra("control appwiz.cpl")
	Case $msg = $pws
		_ra("control userpasswords2")
	Case $msg = $devman
		_ra("rundll32.exe devmgr.dll DeviceManager_Execute")
	Case $msg = $ieprop
		_ra("control inetcpl.cpl")
	Case $msg = $telnet
		_ra("rundll32.exe url.dll,TelnetProtocolHandler")
	Case $msg = $datetime
		_ra("rundll32.exe shell32.dll,Control_RunDLL timedate.cpl")
	Case $msg = $browse
		$text = FileOpenDialog("Choose a program you want to run on the administrative account:", @DesktopDir, "Files (*.*)", 1 )
		GUICtrlSetData($selectedfile, $file)
	Case $msg = $run
		if $text = "empty" then MsgBox(0, "Administrator Tools", "You have to click browse to select a file to run!")
		_ra($text)
	EndSelect
Wend