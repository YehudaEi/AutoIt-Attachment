Func snmpClick()
    Local $startline = _GetLogLastLineNumber ($tterm_log)
    _SendTeraTerm($tt_hwnd, "show snmp community")
    _WaitPrompt("#", 10000, $delay, $tterm_log)
    Local $endline = _GetLogLastLineNumber ($tterm_log)
    Local $tmpfile = FileOpen("C:\TFTP Data\tmp_log12345.txt", 2)
    For $k=$startline To $endline
        Local $line = FileReadLine($tterm_log, $k)
        FileWriteLine ($tmpfile,$line)
    Next
    FileClose ($tmpfile)
    Sleep (500)
    $tmpfile = FileOpen("C:\TFTP Data\tmp_log12345.txt", 0)
    $aArray = StringSplit(StringStripCR(FileRead($tmpfile, FileGetSize("C:\TFTP Data\tmp_log12345.txt"))), @LF)
    FileClose ($tmpfile)
    MsgBox (0, "[0]", $aArray[0])    ;just for test
    For $k=1 to $aArray[0]
        If StringInStr($aArray[$k], "Community Name") Then
            $snmp_name1 = StringMid ($aArray[$k], 20)
            MsgBox (0, "name1", $snmp_name1);test
            $snmp_type = StringMid ($aArray[$k+1], 20)
            MsgBox (0, "type", $snmp_type)    ;test
            Select
                Case $snmp_type = "v1v2c_rw"
                    $comm_rw = $snmp_name1
                Case $snmp_type = "v1v2c_ro"
                    $comm_ro = $snmp_name1
                Case Else 
                    update_status(" @ SNMP Community Name ERROR")
                    SetError(1)
                    Return
            EndSelect
        EndIf
    Next
    MsgBox (0, "RW", $comm_rw)    ;test
    MsgBox (0, "Ro", $comm_ro)    ;test
EndFunc