#include <GUIConstantsEx.au3>

; for first row def

Local $VS_TM1_TM2

;top label Header
GUICreate("RDC Environment Quick keys", 450, 825)
GUICtrlCreateLabel("Environment Choices", 175, 10)
GUICtrlCreateLabel("Test Virtual Servers", 10, 30)
GUICtrlCreateLabel("Post Prod Machines", 150, 30)
GUICtrlCreateLabel("Production Disk2 Builders", 300, 30)
;GUICtrlCreateLabel("Test Farm Web", 10, 510)


Opt("GUICoordMode", 1)
$VS_TM1_TM2 = GUICtrlCreateButton("H1 - MMH1TESTVM1", 10, 50, 125)


GUISetState()


While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $VS_TM1_TM2
		
		run("mstsc.exe /console")
		;ShellExecute("C:\Program Files\Remote Desktop\mstsc.exe", "", "TPS-TRAIN-01.rpd", "")
		
		ShellExecute("mstsc.exe",'"c:\TPS-TRAIN-01.rpd"')
		
		;run("mstsc.exe c:\Remote Desktop Connections\Training room RDC\TPS-TRAIN-01.rpd")
		
		;ShellExecute("mstsc.exe")
		
		;$RDPFile = "c:\TPS-TRAIN-01.rpd"
		;run("c:\windows\system32\mstsc.exe "&$RDPFile)
		
	EndSelect
	
	
WEnd

;TPS-TRAIN-01.rpd
;C:\Remote Desktop Connections\Training room RDC\