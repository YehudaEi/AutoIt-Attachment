#include <GUIConstants.au3>
#include <GUIEdit.au3>
HotKeySet("{enter}", "read_func")
$line = 1
$Form1 = GUICreate("Terminal", 499, 274, 201, 116)
GUISetCursor(7)
$CommandInput = GUICtrlCreateEdit("", 0, 0, 497, 273, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetData(-1, "shell:")
GUICtrlSetFont(-1, 10, 500, 0, "Terminal")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUISetState(@SW_SHOW)
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd
Func read_func ()
    $line = _GUICtrlEdit_GetLineCount ($CommandInput) - 1
    $Input = _GUICtrlEdit_GetLine ($CommandInput, $line)
    $command = StringTrimLeft($Input, 6)
    $Say = StringInStr($command, "say")
    $Exit = StringInStr($command, "exit")
    $sysinfo = StringInStr($command, "sys")
    $ip = StringInStr($command, "ip")
    $ping = StringInStr($command, "ping")
    $run = StringInStr($command, "run")
    $play = StringInStr($command, "play")
    $kill = StringInStr($command, "kill")
    $delfile = StringInStr($command, "delfile")
    $diskfree = StringInStr($command, "diskfree")
	$soundvol = StringInStr($command, "soundvol")
    If $Say Then
        HotKeySet("{enter}")
        $string = StringTrimLeft($Input, 10)
        Send(@CRLF & $string & @CRLF & "shell:")
        $line = $line + 4
        Sleep(100)
        HotKeySet("{enter}", "read_func")
    Else
        If $Exit Then
            Exit
        Else
            If $sysinfo Then
                sys ()
                ;HERE'S THE FIX========
                HotKeySet("{enter}")
                Send(@CRLF & "shell:")
                $line = $line + 30
                HotKeySet("{enter}", "read_func")
                ;==========================
            Else
                If $diskfree Then
                    df()
                    HotKeySet("{enter}")
                    Send(@CRLF & "shell:")
                    $line = $line + 6
                    HotKeySet("{enter}", "read_func")
                EndIf
                If $kill Then
                    HotKeySet("{enter}")
                    $string = StringTrimLeft($Input, 11)
                    Send(@CRLF & "Killing " & $string & "...")
                    $PID = ProcessExists($string & ".exe")
                    If $PID Then
                        ProcessClose($PID & ".exe")
                        Send(@CRLF & "Shell:")
                        $line = $line + 4
                    Else
                        Send(@CRLF & "FATAL ERROR: could not find progress" & "..." & @CRLF & "Shell:")
                        $line = $line + 6
                    EndIf
                    HotKeySet("{enter}", "read_func")
                Else
                    If $run Then
                        HotKeySet("{enter}")
                        $string = StringTrimLeft($Input, 10)
                        Send(@CRLF & "running " & $string & "..." & @CRLF & "Shell:")
                        $line = $line + 4
                        Sleep(100)
                        HotKeySet("{enter}", "read_func")
                        Run($string)
                        If @error Then
                            HotKeySet("{enter}")
                            $string = StringTrimLeft($Input, 10)
                            Send(@CRLF & "FATAL ERROR: could not find external program" & "..." & @CRLF & "Shell:")
                            $line = $line + 4
                            Sleep(100)
                            HotKeySet("{enter}", "read_func")
                        EndIf
                    Else
                        If $play Then
                            HotKeySet("{enter}")
                            $string = StringTrimLeft($Input, 11)
                            Send(@CRLF & "running " & $string & "..." & @CRLF & "Shell:")
                            $line = $line + 4
                            Sleep(100)
                            HotKeySet("{enter}", "read_func")
                            SoundPlay($string)
                            If @error Then
                                HotKeySet("{enter}")
                                $string = StringTrimLeft($Input, 10)
                                Send(@CRLF & "FATAL ERROR: could not find external program" & "..." & @CRLF & "Shell:")
                                $line = $line + 4
                                Sleep(100)
                                HotKeySet("{enter}", "read_func")
                            EndIf
                        Else
                            If $delfile Then
                                HotKeySet("{enter}")
                                $string = StringTrimLeft($Input, 11)
                                Send(@CRLF & "Deleting" & $string & "..." & @CRLF & "Shell:")
                                $line = $line + 4
                                Sleep(100)
                                HotKeySet("{enter}", "read_func")
                                FileDelete($string)
                                If @error Then
                                    HotKeySet("{enter}")
                                    $string = StringTrimLeft($Input, 10)
                                    Send(@CRLF & "FATAL ERROR: could not delete file" & "..." & @CRLF & "Shell:")
                                    $line = $line + 4
                                    Sleep(100)
                                    HotKeySet("{enter}", "read_func")
                                EndIf
                            Else
								If $soundvol Then
									HotKeySet("{enter}")
									$string = StringTrimLeft($Input, 15)
									SoundSetWaveVolume($string)
									Send(@CRLF &"Volume has been set to : " & $string & "%" & @CRLF & "shell:")
									$line = $line + 4
									Sleep(100)
									HotKeySet("{enter}", "read_func")
							Else		
                                If $ip Then
                                    HotKeySet("{enter}")
                                    Send(@CRLF & "Your IP address is :" & @IPAddress1 & @CRLF & "shell:")
                                    $line = $line + 4
                                    Sleep(100)
                                    HotKeySet("{enter}", "read_func")
                                Else
                                    HotKeySet("{enter}")
                                    Send(@CRLF & "'" & $command & "'" & "is not a valid command" & @CRLF & "shell:")
                                    $line = $line + 4
                                    Sleep(100)
                                    HotKeySet("{enter}", "read_func")
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
EndIf	
EndFunc   ;==>read_func
Func sys ()
    HotKeySet("{enter}")
;~ run("notepad")
    $VOL = DriveGetLabel("C:\")
    $SERIAL = DriveGetSerial("C:\")
    $TOTAL = DriveSpaceTotal("C:\")
    $FREE = DriveSpaceFree("C:\")
    $FS = DriveGetFileSystem("C:\")
;~ WinWaitActive("Untitled - Notepad")
;~ WinSetTitle("Untitled - Notepad","","system")
    ClipPut(@CRLF & "monitor:")
    Send("^v{enter}")
    ClipPut("Ekraanilaius: " & @DesktopWidth)
    Send("^v{enter}")
    ClipPut("Ekraanikõrgus: " & @DesktopHeight)
    Send("^v{enter}")
    ClipPut("Ekraanivärskendus: " & @DesktopRefresh)
    Send("^v{enter}")
    ClipPut("Ekraanivärvisügavus: " & @DesktopDepth)
    Send("^v{enter}")
    ClipPut("Arvuti ja süsteem")
    Send("^v{enter}")
    ClipPut("Süsteemi keel: " & @OSLang)
    Send("^v{enter}")
    ClipPut("Süsteem_tüüp: " & @OSTYPE)
    Send("^v{enter}")
    ClipPut("Süsteem_versioon: " & @OSVersion)
    Send("^v{enter}")
    ClipPut("Süsteem_ehitus: " & @OSBuild)
    Send("^v{enter}")
    ClipPut("Süsteem_SP: " & @OSServicePack)
    Send("^v{enter}")
    ClipPut("Klaviatuuri paigutus: " & @KBLayout)
    Send("^v{enter}")
    ClipPut("Protsessori arhidektuur: " & @ProcessorArch)
    Send("^v{enter}")
    ClipPut("Arvuti nimi: " & @ComputerName)
    Send("^v{enter}")
    ClipPut("Hetkel aktiivne kasutaja: " & @UserName)
    Send("^v{enter}")
    ClipPut("windows on kataloogis: " & @WindowsDir)
    Send("^v{enter}")
    ClipPut("Windows on kettal: " & @HomeDrive)
    Send("^v{enter}")
    ClipPut("Kasutaja profiilid: " & @UserProfileDir)
    Send("^v{enter}")
    ClipPut("start menüü: " & @StartMenuDir)
    Send("^v{enter}")
    ClipPut("töölaua asukoht: " & @DesktopDir)
    Send("^v{enter}")
    ClipPut("start menüü: " & @StartMenuDir)
    Send("^v{enter}")
    ClipPut("ketta C:\ nimetus: " & $VOL)
    Send("^v{enter}")
    ClipPut("ketta C:\ kogu suurus: " & $TOTAL)
    Send("^v{enter}")
    ClipPut("ketta C:\ vabaruum: " & $FREE)
    Send("^v{enter}")
    ClipPut("ketta C:\ serialli nr: " & $SERIAL)
    Send("^v{enter}")
    ClipPut("ketta C:\ failisüsteem: " & $FS)
    Send("^v{enter}")
    ClipPut("IP aadress on: " & @IPAddress1)
    Send("^v{enter}")
    HotKeySet("{enter}", "read_func")
EndFunc   ;==>sys
Func df()
    HotKeySet("{enter}")
;~ run("notepad")
    $VOL = DriveGetLabel("C:\")
    $SERIAL = DriveGetSerial("C:\")
    $TOTAL = DriveSpaceTotal("C:\")
    $FREE = DriveSpaceFree("C:\")
    $FS = DriveGetFileSystem("C:\")
	$Total2 = $TOTAL / 1000
	$free2 = $free / 1000
	$Used = $total - $free
	$Used2 = $used / 1000
	$total3 = Round($total2,2)
	$used3 = Round($used2,2)
	$free3 = Round($free2,2)
	$percentused = $used3 / $total3 * 100 
	$percentusedrounded = Round($percentused,1)
	ClipPut(@CRLF)
    Send("^v{enter}")
    ClipPut("Volume Label " & $VOL)
    Send("^v{enter}")
    ClipPut("Total size of C:\ " & $TOTAL3 & " Gb")
    Send("^v{enter}")
    ClipPut("Free space on C: " & $FREE3 & " Gb")
    Send("^v{enter}")
    ClipPut("Disk C:\ S\N " & $SERIAL)
    Send("^v{enter}")
    ClipPut("Drive C\: File System " & $FS)
    Send("^v{enter}")
	ClipPut("Drive C:\ used " & $Used3 & "Gb (" &$percentusedrounded & " %)" )
    Send("^v{enter}")
    HotKeySet("{enter}", "read_func")
EndFunc   ;==>df