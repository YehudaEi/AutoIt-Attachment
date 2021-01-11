#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

HotKeySet("{F12}", "Stop")
HotKeySet("{F11}", "Start")

winwait("Nostale")
winactivate("Nostale")
winwaitactive("Nostale")

While 1
    Sleep(100)
WEnd

Func Stop()
    Exit 0
EndFunc  ;==>Stop

Func Start()
    While 1
		controlsend("Nostale","","","{SPACE}")
        Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
		Sleep(19000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
        Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
		Sleep(19000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
        Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
		Sleep(19000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
        Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
		Sleep(19000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
        Sleep(1000)
		controlsend("Nostale","","","{SPACE}")
		Sleep(19000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{E}")
		Sleep(1000)
		controlsend("Nostale","","","{T}")
        Sleep(20000)
		controlsend("Nostale","","","{T}")
		Sleep(1000)

    WEnd
EndFunc  ;==>StartT