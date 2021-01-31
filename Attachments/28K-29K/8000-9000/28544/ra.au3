Opt("GUIOnEventMode",1)
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
AutoItSetOption("WinTitleMatchMode", 2)
Opt("SendKeyDelay",0)
Opt("SendKeyDownDelay",0) 
	$handle=controlgethandle("Talisman", "", "")
	GUICreate( "Blahh", 200,350, 1000, 0, 0,0,$handle)
	$stop = GUICtrlCreateButton("Stop",0,300)
	$recount = GUICtrlCreateButton("Recount",100,300)
guictrlsetonevent($stop,"stop")
guictrlsetonevent($recount,"Recount")

GUISetstate(@SW_Show)

HotKeySet("{ESC}", "stop")
Local $button, $wait, $s, $msg, $m
	GUISetState()
	$m=0
	$i=0
	$input = GUICtrlCreateInput("5", 0, 0, 20, 20)
	$input2 = GUICtrlCreateInput("130", 25, 0,40, 20)
	

While 1
	$i=0
	$s=0

	GUICtrlCreateEdit ( $m,70, 0, 40, 20)
	Do	
		$i=$i+1
		GUICtrlCreateEdit ($i, 120, 0, 40, 20)
		controlsend("", "", $handle, "{Tab}")
		
		controlsend("", "", $handle, "1")

		Sleep(2000)
		controlsend("", "", $handle, "1")
		
		Sleep(1700)
		controlsend("", "", $handle, "2")
		Sleep(1700)
		controlsend("", "", $handle, "1")
		Sleep(1700)
		controlsend("", "", $handle, "1")
		Sleep(1700)
		controlsend("", "", $handle, "2")
		Sleep(1700)
		controlsend("", "", $handle, "1")
		Sleep(100)
		controlsend("", "", $handle, "1")
		Sleep(100)		
		
	Until $i = guictrlread($input)
	sleep(3000)
	
	$m=$m+1
	If $m = guictrlread($input2) Then
	controlsend("", "", $handle, "{F3}")
	sleep(4000)
	exit 0
		
	Else
	controlsend("", "", $handle, "{F1}")
	sleep(1000)
	
	controlsend("", "", $handle, "1")
	sleep(1500)
	controlsend("", "", $handle, "1")
	sleep(1500)
	controlsend("", "", $handle, "2")
	sleep(1500)
	controlsend("", "", $handle, "1}")
	sleep(1500)
	controlsend("", "", $handle, "1")
	sleep(1500)
	controlsend("", "", $handle, "2")
	sleep(1500)
	controlsend("", "", $handle, "1")
	sleep(1500)
	controlsend("", "", $handle, "1")
	sleep(1500)
	controlsend("", "", $handle, "2")
	sleep(1500)
	controlsend("", "", $handle, "{F5}")
	sleep(200)
	EndIf

WEnd
Func Recount()
sleep(5000)
	EndFunc
Func stop()
	exit 0
EndFunc