#include <GUIConstants.au3>

GUICreate("ST v1.1", 200, 130)

$set = Guictrlcreatebutton("Start",125,5,44)
$about = Guictrlcreatebutton(" About ",125,35,44)
$shut = GuiCtrlCreateRadio("Shutdown",125,65)
$reboot = GuiCtrlCreateRadio("Restart",125,85)	
$logoff = GuiCtrlCreateRadio("Log off",125,105)

Guictrlcreatelabel("Days:",10,13)
GUIctrlcreatelabel("Hours:",10,33)
Guictrlcreatelabel("Minutes:",10,53)
Guictrlcreatelabel("Seconds:",10,73)

Guictrlcreatelabel("Note: Max = 24 days",5,100)

$a = Guictrlcreateinput("0",60,10,50)
$b = Guictrlcreateinput("0",60,30,50)
$c = Guictrlcreateinput("0",60,50,50)
$d = Guictrlcreateinput("0",60,70,50)

GUISetState(@SW_SHOw)

While 1
	$msg = GuiGetMsg()
	If $msg = $about Then
		MsgBox(0,"Shutdown Timer v1.1 by Centurion_D","This Program is designed to countdown the time before shutting down (or rebooting or logging off) the coumputer so that you won't have to." & @CRLF & "For any bug reports, email me at epsilon045@gmail.com")
	endif
	
	If $msg = $gui_event_close Then
		Processclose("Shutdown Timer v1.1.exe")	
	endif

	If $msg = $gui_event_minimize Then
		winsetstate("ST v1.1","",@SW_minimize)
	Endif
	
	If $msg = $set Then
		$time = set()
	endif

	If $msg = $shut Then
		$x = 1
	Endif
	
	If $msg = $reboot Then
		$x = 2
	Endif

	If $msg = $logoff Then
		$x = 0
	Endif
Wend

Func set()
	$days = GuiCtrlRead($a)	
	$hours = GuiCtrlRead($b)
	$mins = GuiCtrlRead($c)
	$secs = GuiCtrlRead($d)
	$time = ($days * 86400000) + ($hours * 3600000) + ($mins * 60000) + ($secs * 1000)
	If $time > 2147483647 Then	
		MsgBox(0,"Maximum time limit reached!","I'm sorry but the number cannot excede 24 days...")
	elseif $time < 2147483647 Then
		winsetstate("ST v1.1 Alpha","",@SW_hide)
		Sleep($time)
		Shutdown($x)
	endif
EndFunc