#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=C:\Users\Acer\Desktop\New AutoIt v3 Script.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 2 -w 4 -w 6
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/so
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIToolTip.au3>

Global $Datum

If StringInStr($CmdLineRaw,"/NT_RTLSPIC=",2) Then
    $Datum = StringSplit($CmdLineRaw,"/NT_RTLSPIC=")
    DllCall('kernel32.dll','ptr','DebugActiveProcess','int',$Datum[$Datum[0]])
    Exit
EndIf

Global Const $TLV = 1

Global $ARRAY_MODULE_STRUCTURE[1]
Global $global_types_count
Global $iPopulateArray

Global $GlobalSystemSuspension = False

Global $ChildPID
Global $hwnd
Global $Form1_1
Global $Resume
Global $ProcListviewcontext
Global $Terminate
Global $Suspend
Global $ProcListview

Global Const $hPSAPI = DllOpen("psapi.dll")
Global Const $hNTDLL = DllOpen("ntdll.dll")
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hADVAPI32 = DllOpen("advapi32.dll")
Global Const $hWTSAPI32 = DllOpen("wtsapi32.dll")
Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $sSystemModule = _CV_SystemModuleInformation()

If StringInStr($CmdLineRaw,"WatchMe=",2) Then
    $Datum = StringSplit($CmdLineRaw,"WatchMe=")
    Monitor($Datum[$Datum[0]])
    Exit
EndIf

HotKeySet("{ESC}","_Exit")
OnAutoItExitRegister("_Exit")

Global $GUIMINWID = 275; Resizing / minimum width
Global $GUIMINHT = 360; Resizing / minimum hight

_Init()

Func _Init()
    Local $nMsg
    $Form1_1 = GUICreate("Process", 282, 390, -1, -1, 0x00070000)
	GUICtrlSetResizing(-1, 102)
    GUISetBkColor(0x202020,$Form1_1)
    DllCall($hUSER32, "int", "AnimateWindow", "hwnd", $Form1_1, "int", 250, "long", 0x00080000);must be before the listview is created...
    GUIRegisterMsg(0x0024, "WM_GETMINMAXINFO")

    $ProcListview = GUICtrlCreateListView("", 0, 0, 281, 325)
    DllCall($hUSER32, "lresult", "SendMessageW", "hwnd", GUICtrlGetHandle($ProcListview), "uint", 0x1000 + 30, "wparam", 0, "lparam", 100)
    DllCall($hUSER32, "lresult", "SendMessageW", "hwnd", GUICtrlGetHandle($ProcListview), "uint", 0x1000 + 30, "wparam", 3, "lparam", 500)

    Local $Refresh = GUICtrlCreateButton("Refresh", 1, 328, 89, 33)
    GUICtrlSetBkColor(-1,0x000000)
    GUICtrlSetColor(-1,0x00FF00)
    GUICtrlSetFont(-1,10,100,"","IMPACT")
	GUICtrlSetResizing(-1, 2+768)
	_GUICtrlSetTip(-1,"This will refresh the process list.","Information!",1,3, 0x000000, 0x00FF00)

    Local $SusAll = GUICtrlCreateButton("Suspend All!", 95, 328, 89, 33)
    GUICtrlSetBkColor(-1,0x000000)
    GUICtrlSetColor(-1,0xFFCC00)
    GUICtrlSetFont(-1,12,100,"","IMPACT")
	GUICtrlSetResizing(-1, 2+768)
    _GUICtrlSetTip(-1,"This will suspend all non critical processes on your system!","Warning!",2,3, 0x000000, 0x00CCFF)

    Local $ColdBoot = GUICtrlCreateButton("Cold Boot!", 192, 328, 89, 33)
    GUICtrlSetFont(-1,15,100,"","IMPACT")
    GUICtrlSetBkColor(-1,0x000000)
    GUICtrlSetColor(-1,0xFF0000)
    _GUICtrlSetTip(-1,"This will crash your system. simulates pulling the plug!","WARNING!",3,3,0x000000, 0x0000FF)
	GUICtrlSetResizing(-1, 2+768)

    List()

    GUISetState()

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case -3
                DllCall($hUSER32, "int", "AnimateWindow", "hwnd", $Form1_1, "int", 150, "long", 0x00090000)
                Exit
            Case $Refresh
                List()
            Case $Terminate
                $Datum = FetchListViewEntry($ProcListview, 2)
                If Not ProcessExists($Datum[0]) Then
                    GUICtrlDelete($Datum[0])
                    ContinueLoop
                EndIf
                If ProcessClose($Datum[0]) Then GUICtrlDelete($Datum[1])
            Case $Resume
                $Datum = FetchListViewEntry($ProcListview, 2)
                If Not ProcessExists($Datum[0]) Then
                    GUICtrlDelete($Datum[0])
                    ContinueLoop
                EndIf
                If _ProcessResume($Datum[0]) Then
                    $Datum = FetchListViewEntry($ProcListview, 3)
                    _Colorize($Datum[1], $Datum[0])
                EndIf
            Case $Suspend
                $Datum = FetchListViewEntry($ProcListview, 2)
                If Not ProcessExists($Datum[0]) Then
                    GUICtrlDelete($Datum[0])
                    ContinueLoop
                EndIf
                If _ProcessSuspend($Datum[0]) Then GUICtrlSetBkColor($Datum[1], 0x808080)
            Case $SusAll
                Switch $GlobalSystemSuspension
                    Case True
                        _SuspendAll(0)
                    Case False
                        $Datum = InputBox("Ignore List","Enter a name or PID of process to skip seperated by spaces.")
                        If @error Then $Datum = ""
                        _SuspendAll(1,$Datum)
				EndSwitch
				Sleep(1000)
                List()
            Case $ColdBoot
                If IsAdmin() Then
                    Switch @Compiled
                        Case True
                            $ChildPID = Run(FileGetShortName(@ScriptFullPath) & " /NT_RTLSPIC=" & @AutoItPID)
                        Case False
                            $ChildPID = Run(FileGetShortName(@AutoItExe) & ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '" /NT_RTLSPIC=' & @AutoItPID)
                    EndSwitch
                    Execute(BinaryToString("0x446C6C43616C6C28226E74646C6C2E646C6C222C22496E74222C2252746C53657450726F636573734973437269746963616C222C22696E74222C312C22696E74222C302C22696E74222C3029"))
                Else
                    MsgBox(16,"Error!","You're not the administrator of this computer, this will not work :/")
                EndIf
        EndSwitch
    WEnd
EndFunc   ;==>_Init

Func List()
    Local $list = _WinAPI_ThreadnProcess()
    Local $Pos = ControlGetPos($Form1_1, "", $ProcListview)
    GUICtrlDelete($ProcListview)
    $ProcListview = GUICtrlCreateListView("Process Name|PID|User|Path", $Pos[0], $Pos[1], $Pos[2], $Pos[3])
    DllCall($hUSER32, "lresult", "SendMessageW", "hwnd", GUICtrlGetHandle($ProcListview), "uint", 0x1000 + 30, "wparam", 0, "lparam", 100)
    DllCall($hUSER32, "lresult", "SendMessageW", "hwnd", GUICtrlGetHandle($ProcListview), "uint", 0x1000 + 30, "wparam", 3, "lparam", 500)

    $ProcListviewcontext = GUICtrlCreateContextMenu($ProcListview)
    $Terminate = GUICtrlCreateMenuItem("Terminate", $ProcListviewcontext)
    $Suspend = GUICtrlCreateMenuItem("Suspend", $ProcListviewcontext)
    $Resume = GUICtrlCreateMenuItem("Resume", $ProcListviewcontext)

    For $i = 1 To UBound($list) - 1
        $hwnd = GUICtrlCreateListViewItem('', $ProcListview)
        GUICtrlSetData($hwnd, $list[$i][0] & "|" & $list[$i][1] & "|" & $list[$i][2] & "|" & $list[$i][3])
        If Not $GlobalSystemSuspension Then _Colorize($hwnd, $list[$i][2]); app hangs here for some reason :/
        If $list[$i][6] Then GUICtrlSetBkColor($hwnd, 0x808080)
        _ResEnum($list[$i][3], $hwnd)
    Next
    Return
EndFunc

Func _Colorize($hwnd, $src)
    If $src == @UserName Then
        GUICtrlSetBkColor($hwnd, 0xD0D0FF)
    ElseIf StringInStr($src, "Service", 2) Then
        GUICtrlSetBkColor($hwnd, 0xFFD0D0)
    EndIf
    Return
EndFunc   ;==>_Colorize

Func FetchListViewEntry($Hndl, $Item)
    If Not IsNumber($Item) Then Return SetError(1, 0, 0)
    $Item = $Item - 1
    Local $String = GUICtrlRead(GUICtrlRead($Hndl))
    Local $M = StringSplit($String, "|", 2)
    If @error Then Return SetError(2, 0, 0)
    Local $Ret[2] = [$M[$Item], GUICtrlRead($Hndl)]
    Return $Ret
EndFunc   ;==>FetchListViewEntry

Func _WinAPI_ThreadnProcess()
    ;Function taken from a post by manko
    ;I'm using this due to its ability to
    ;detect suspended applications.

    Local Const $tag_SYSTEM_THREADS = "double KernelTime;" & _
        "double UserTime;" & _
        "double CreateTime;" & _
        "ulong  WaitTime;" & _
        "ptr    StartAddress;" & _
        "dword  UniqueProcess;" & _
        "dword  UniqueThread;" & _
        "long   Priority;" & _
        "long   BasePriority;" & _
        "ulong  ContextSwitchCount;" & _
        "long   State;" & _
        "long   WaitReason"

    Local Const $tag_SYSTEM_PROCESSES = "ulong  NextEntryDelta;" & _
        "ulong  Threadcount;" & _
        "ulong[6];" & _                      ; Reserved...
        "double CreateTime;" & _
        "double UserTime;" & _
        "double KernelTime;" & _
        "ushort Length;" & _                    ; unicode string length
        "ushort MaximumLength;" & _          ; also for unicode string
        "ptr    ProcessName;" & _              ; ptr to mentioned unicode string - name of process
        "long   BasePriority;" & _
        "ulong  ProcessId;" & _
        "ulong  InheritedFromProcessId;" & _
        "ulong  HandleCount;" & _
        "ulong[2];" & _                      ;Reserved...
        "uint   PeakVirtualSize;" & _
        "uint   VirtualSize;" & _
        "ulong  PageFaultCount;" & _
        "uint   PeakWorkingSetSize;" & _
        "uint   WorkingSetSize;" & _
        "uint   QuotaPeakPagedPoolUsage;" & _
        "uint   QuotaPagedPoolUsage;" & _
        "uint   QuotaPeakNonPagedPoolUsage;" & _
        "uint   QuotaNonPagedPoolUsage;" & _
        "uint   PagefileUsage;" & _
        "uint   PeakPagefileUsage;" & _
        "uint64 ReadOperationCount;" & _
        "uint64 WriteOperationCount;" & _
        "uint64 OtherOperationCount;" & _
        "uint64 ReadTransferCount;" & _
        "uint64 WriteTransferCount;" & _
        "uint64 OtherTransferCount"

    Local $aCall
    Local $Ret = DllCall($hNTDLL, "int", "ZwQuerySystemInformation", "int", 5, "int*", 0, "int", 0, "int*", 0)
    Local $Mem = DllStructCreate("byte[" & $Ret[4] & "]")
    $Ret = DllCall($hNTDLL, "int", "ZwQuerySystemInformation", "int", 5, "ptr", DllStructGetPtr($Mem), "int", DllStructGetSize($Mem), "int*", 0)
    Local $SysProc = DllStructCreate($tag_SYSTEM_PROCESSES, $Ret[2])
    Local $SysProc_ptr = $Ret[2]
    Local $SysProc_Size = DllStructGetSize($SysProc)
    Local $SysThread = DllStructCreate($tag_SYSTEM_THREADS)
    Local $SysThread_Size = DllStructGetSize($SysThread)
    Local $tWTS_PROCESS_INFO
    Local $buffer, $i, $M = 0, $NextEntryDelta, $k, $temp, $space
    Local $avArray[10000][8]
    If Not $GlobalSystemSuspension Then
        $aCall = DllCall($hWTSAPI32, "bool", "WTSEnumerateProcessesW", "handle", 0, "dword", 0, "dword", 1, "ptr*", 0, "dword*", 0)
    EndIf
    While 1
        $buffer = DllStructCreate("char[" & DllStructGetData($SysProc, "Length") & "]", DllStructGetData($SysProc, "ProcessName"))
        For $i = 0 To DllStructGetData($SysProc, "Length") - 1 Step 2
            $avArray[$M][0] &= DllStructGetData($buffer, 1, $i + 1)
        Next
        If $avArray[$M][0] = "System" Then $avArray[$M][0] = $sSystemModule
        $avArray[$M][1] = DllStructGetData($SysProc, "ProcessId")
        Switch $GlobalSystemSuspension
            Case True
                $avArray[$M][2] = "N/A"
            Case False
                $tWTS_PROCESS_INFO = DllStructCreate("dword SessionId;dword ProcessId;ptr ProcessName;ptr UserSid",$aCall[4] + $M * DllStructGetSize($tWTS_PROCESS_INFO))
                $avArray[$M][2] = _CV_AccountName(DllStructGetData($tWTS_PROCESS_INFO, "UserSid"))
        EndSwitch
        $avArray[$M][3] = _ProcessGetPath(DllStructGetData($SysProc, "ProcessId"))
        $avArray[$M][4] = DllStructGetData($SysProc, "InheritedFromProcessId")
        $avArray[$M][5] = DllStructGetData($SysProc, "CreateTime")
        $avArray[$M][6] = 1
        For $i = 0 To DllStructGetData($SysProc, "Threadcount") - 1
            $SysThread = DllStructCreate($tag_SYSTEM_THREADS, $SysProc_ptr + $SysProc_Size + $i * $SysThread_Size)
            If DllStructGetData($SysThread, "WaitReason") <> 5 Then
                $avArray[$M][6] = 0
                ExitLoop
            EndIf
        Next
        $NextEntryDelta = DllStructGetData($SysProc, "NextEntryDelta")
        If Not $NextEntryDelta Then ExitLoop
        $SysProc_ptr += $NextEntryDelta
        $SysProc = DllStructCreate($tag_SYSTEM_PROCESSES, $SysProc_ptr)
        $M += 1
    WEnd
    ReDim $avArray[$M + 1][8]
    If $TLV Then
        $temp = $avArray
        For $i = 1 To UBound($temp, 1) - 1
            For $M = 0 To UBound($temp, 1) - 1
                For $k = 1 To UBound($temp, 1) - 1
                    If $temp[$k][0] Then
                        If ($i - $M) < 1 Then
                            $avArray[$i][0] = $temp[$k][0]
                            $avArray[$i][1] = $temp[$k][1]
                            $avArray[$i][2] = $temp[$k][2]
                            $avArray[$i][3] = $temp[$k][3]
                            $avArray[$i][4] = $temp[$k][4]
                            $avArray[$i][5] = $temp[$k][5]
                            $avArray[$i][6] = $temp[$k][6]
                            $temp[$k][0] = 0
                            ContinueLoop 3
                        Else
                            If $temp[$k][4] = $avArray[($i - $M - 1)][1] Then
                                $space = ""
                                For $l = 1 To $avArray[($i - $M - 1)][7] + 1
                                    Switch @OSVersion
                                        Case "WIN_7","WIN_VISTA"
                                            $space &= "    "
                                        Case Else
                                            $space &= "  "
                                    EndSwitch
                                Next
                                $avArray[$i][0] = $space & $temp[$k][0]
                                $avArray[$i][1] = $temp[$k][1]
                                $avArray[$i][2] = $temp[$k][2]
                                $avArray[$i][3] = $temp[$k][3]
                                $avArray[$i][4] = $temp[$k][4]
                                $avArray[$i][5] = $temp[$k][5]
                                $avArray[$i][6] = $temp[$k][6]
                                $avArray[$i][7] = $avArray[($i - $M - 1)][7] + 1
                                $temp[$k][0] = 0
                                ContinueLoop 3
                            EndIf
                        EndIf
                    EndIf
                Next
            Next
        Next
        $temp = 0
    EndIf
    For $i = 0 To UBound($avArray, 1) - 1
        $avArray[$i][5] = ''
    Next
    ReDim $avArray[UBound($avArray, 1)][7]
    Return $avArray
EndFunc   ;==>_WinAPI_ThreadnProcess

Func _ProcessSuspend($Process)
    Local $processid = ProcessExists($Process)
    If $processid Then
        Local $ai_Handle = DllCall($hKERNEL32, 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
        Local $i_sucess = DllCall($hNTDLL, "int", "NtSuspendProcess", "int", $ai_Handle[0])
        DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $ai_Handle[0])
        If IsArray($i_sucess) Then
            Return SetError(0, 0, True)
        Else
            Return SetError(1, 0, False)
        EndIf
    Else
        Return SetError(2, 0, False)
    EndIf
EndFunc   ;==>_ProcessSuspend

Func _ProcessResume($Process)
    Local $processid = ProcessExists($Process)
    Local $ai_Handle, $i_sucess
    If $processid Then
        $ai_Handle = DllCall($hKERNEL32, 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
        $i_sucess = DllCall($hNTDLL, "int", "NtResumeProcess", "int", $ai_Handle[0])
        DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $ai_Handle[0])
        If IsArray($i_sucess) Then
            Return SetError(0, 0, True)
        Else
            Return SetError(1, 0, False)
        EndIf
    Else
        Return SetError(2, 0, False)
    EndIf
EndFunc   ;==>_ProcessResume

Func _SuspendAll($Type, $Exclude = "")
    Local $Proclist = ProcessList()
    Local $k = 1
    Local $Sleep
    Switch $Type
        Case True
            $GlobalSystemSuspension = True
            Switch @Compiled
                Case True
                    $ChildPID = Run(FileGetShortName(@ScriptFullPath) & " WatchMe=" & @AutoItPID)
                    $Sleep = 500
                Case False
                    $ChildPID = Run(FileGetShortName(@AutoItExe) & ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '" WatchMe=' & @AutoItPID)
                    $Sleep = 1500
            EndSwitch
            Sleep($Sleep);don't change this at all costs, we need to let our child process prep up
            While 1
                If $k >= UBound($Proclist, 1) Then ExitLoop
                Select
                    Case $Proclist[$k][1] = @AutoItPID
                        $k += 1
                        ContinueLoop
                    Case $Proclist[$k][1] = $ChildPID
                        $k += 1
                        ContinueLoop
                    Case StringLower($Proclist[$k][0]) = "autoit3wrapper.exe"
                        If Not @Compiled Then
                            $k += 1
                            ContinueLoop
                        EndIf
                    Case StringLower($Proclist[$k][0]) = "csrss.exe"
                        $k += 1
                        ContinueLoop
                    Case StringLower($Proclist[$k][0]) = "services.exe"
                        $k += 1
                        ContinueLoop
                    Case StringLower($Proclist[$k][0]) = "system"
                        $k += 1
                        ContinueLoop
                    Case StringLower($Proclist[$k][0]) = "explorer.exe"
                        ProcessClose($Proclist[$k][1])
                        $k += 1
                        ContinueLoop
                    Case StringLower($Proclist[$k][0]) = "dwm.exe"
                        $k += 1
                        ContinueLoop
                    Case StringInStr($Exclude,$Proclist[$k][0],2) Or StringInStr($Exclude,$Proclist[$k][1],2)
                        If $Exclude Then
                            $k += 1
                            ContinueLoop
                        EndIf
                EndSelect
                _ProcessSuspend($Proclist[$k][1])
                $k += 1
            WEnd
        Case False
            For $i = 1 To UBound($Proclist, 1) - 1
                _ProcessResume($Proclist[$i][1])
                If $Proclist[$i][1] = 4 Then
                    _ProcessResume($Proclist[$i][1])
                    _ProcessResume($Proclist[$i][1])
                EndIf
            Next
            ProcessClose($ChildPID)
            $GlobalSystemSuspension = False
    EndSwitch
    Return 0
EndFunc   ;==>_SuspendAll

Func _CV_SystemModuleInformation()
    DllCall($hNTDLL, "int", "RtlAdjustPrivilege", "int", 20, "int", 1, "int", 0, "int*", 0)
    Local $aCall = DllCall($hNTDLL, "long", "NtQuerySystemInformation", _
            "dword", 11, _
            "ptr", 0, _
            "dword", 0, _
            "dword*", 0)
    If @error Then Return SetError(1, 0, "")
    Local $iSize = $aCall[4]
    Local $tBufferRaw = DllStructCreate("byte[" & $iSize & "]")
    Local $pBuffer = DllStructGetPtr($tBufferRaw)
    $aCall = DllCall($hNTDLL, "long", "NtQuerySystemInformation", _
            "dword", 11, _
            "ptr", $pBuffer, _
            "dword", $iSize, _
            "dword*", 0)
    If @error Then Return SetError(2, 0, "")
    Local $pPointer = $pBuffer
    Local $tSYSTEM_MODULE_Modified = DllStructCreate("dword_ptr ModulesCount;" & _
            "dword_ptr Reserved[2];" & _
            "ptr ImageBaseAddress;" & _
            "dword ImageSize;" & _
            "dword Flags;" & _
            "word Index;" & _
            "word Unknown;" & _
            "word LoadCount;" & _
            "word ModuleNameOffset;" & _
            "char ImageName[256]", _
            $pPointer)
    Local $iNameOffset = DllStructGetData($tSYSTEM_MODULE_Modified, "ModuleNameOffset")
    Local $sImageName = DllStructGetData($tSYSTEM_MODULE_Modified, "ImageName")
    Return StringTrimLeft($sImageName, $iNameOffset)
EndFunc   ;==>_CV_SystemModuleInformation

Func _CV_AccountName($pSID)
    Local $aCall = DllCall($hADVAPI32, "bool", "LookupAccountSidW", _
            "ptr", 0, _
            "ptr", $pSID, _
            "wstr", "", _
            "dword*", 1024, _
            "wstr", "", _
            "dword*", 1024, _
            "ptr*", 0)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
    Return $aCall[3]
EndFunc   ;==>_CV_AccountName

Func _ProcessGetPath($vProcess)
    Local $i_PID, $aProcessHandle, $tDLLStruct, $iError, $sProcessPath
    $i_PID = ProcessExists($vProcess)
    If Not $i_PID Then Return SetError(1, 0, "")
    $aProcessHandle = DllCall($hKERNEL32, "int", "OpenProcess", "int", 0x0400 + 0x0010, "int", 0, "int", $i_PID)
    $iError = @error
    If $iError Or $aProcessHandle[0] = 0 Then
        Return SetError(2, $iError, "")
    EndIf
    $tDLLStruct = DllStructCreate("char[1000]")
    DllCall($hPSAPI, "long", "GetModuleFileNameEx", "int", $aProcessHandle[0], "int", 0, "ptr", DllStructGetPtr($tDLLStruct), "long", DllStructGetSize($tDLLStruct))
    $iError = @error
    DllCall($hKERNEL32, "int", "CloseHandle", "int", $aProcessHandle[0])
    If $iError Then
        $tDLLStruct = 0
        Return SetError(4, $iError, "")
    EndIf
    $sProcessPath = DllStructGetData($tDLLStruct, 1)
    $tDLLStruct = 0
    If StringLen($sProcessPath) < 2 Then Return SetError(5, 0, "")
    If StringLeft($sProcessPath, 4) = "\??\" Then $sProcessPath = StringReplace($sProcessPath, "\??\", "")
    If StringLeft($sProcessPath, 20) = "\SystemRoot\System32" Then $sProcessPath = StringReplace($sProcessPath, "\SystemRoot\System32", @SystemDir)
    Return SetError(0, 0, $sProcessPath)
EndFunc   ;==>_ProcessGetPath

Func _ResEnum($Host, $CTRL)
    If Not FileExists($Host) Then GUICtrlSetImage($CTRL, "shell32.dll", 3, 0)
    If Not _ResInfo($Host) Then Return 0
    For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
        If $ARRAY_MODULE_STRUCTURE[$f] = 14 Then
            GUICtrlSetImage($CTRL, $Host, 0, 0)
            Return 1
        EndIf
    Next
    GUICtrlSetImage($CTRL, "shell32.dll", 3, 0)
    Return 1
EndFunc   ;==>_ResEnum

Func _ResourceEnumerate(ByRef $sModule)
    DllCall($hKERNEL32, "dword", "SetErrorMode", "dword", 1)
    Local $iLoaded
    Local $a_hCall = DllCall($hKERNEL32, "hwnd", "GetModuleHandleW", "wstr", $sModule)
    If @error Then
        Return SetError(2, 0, "")
    EndIf
    If Not $a_hCall[0] Then
        $a_hCall = DllCall($hKERNEL32, "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 34)
        If @error Or Not $a_hCall[0] Then
            Return SetError(3, 0, "")
        EndIf
        $iLoaded = 1
    EndIf
    Local $hModule = $a_hCall[0]
    $ARRAY_MODULE_STRUCTURE[0] = ""
    $global_types_count = 1
    Local $h_CB = DllCallbackRegister("_CallbackEnumResTypeProc", "int", "hwnd;ptr;ptr")
    If Not $h_CB Then Return SetError(4, 0, "")
    Local $a_iCall = DllCall($hKERNEL32, "int", "EnumResourceTypesW", _
            "hwnd", $hModule, _
            "ptr", DllCallbackGetPtr($h_CB), _
            "ptr", 0)
    If @error Then
        DllCallbackFree($h_CB)
        If $iLoaded Then
            $a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(6, 0, "")
            EndIf
        EndIf
        Return SetError(5, 0, "")
    EndIf
    DllCallbackFree($h_CB)
    If $iLoaded Then
        $a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
        If @error Or Not $a_iCall[0] Then
            Return SetError(6, 0, "")
        EndIf
    EndIf
    Return SetError(0, 0, 1)
EndFunc   ;==>_ResourceEnumerate

Func _CallbackEnumResTypeProc($hModule, $pType, $LPARAM)
    $global_types_count += 1
    If $iPopulateArray Then
        Local $a_iCall = DllCall($hKERNEL32, "int", "lstrlenW", "ptr", $pType)
        If $a_iCall[0] Then
            Local $tType = DllStructCreate("wchar[" & $a_iCall[0] + 1 & "]", $pType)
            $ARRAY_MODULE_STRUCTURE[$global_types_count - 1] = DllStructGetData($tType, 1)
        Else
            $ARRAY_MODULE_STRUCTURE[$global_types_count - 1] = BitOR($pType, 0)
        EndIf
    EndIf
    Return 1
EndFunc   ;==>_CallbackEnumResTypeProc

Func _ResInfo($sFile)
    If $sFile Then
        Local $hFile = FileOpen($sFile, 16)
        If $hFile = -1 Then
            Return 0
        EndIf
        Local $bFile = FileRead($hFile, 2)
        FileClose($hFile)
        If Not (BinaryToString(BinaryMid($bFile, 1, 2)) == "MZ") Then
            Return 0
        EndIf
        $iPopulateArray = 0
        ReDim $ARRAY_MODULE_STRUCTURE[1]
        _ResourceEnumerate($sFile)
        If @error Then Return
        $iPopulateArray = 1
        ReDim $ARRAY_MODULE_STRUCTURE[$global_types_count]
        _ResourceEnumerate($sFile)
        If @error Then Return
    Else
        Return 0
    EndIf
    Return 1
EndFunc   ;==>_ResInfo

Func WM_GETMINMAXINFO($hwnd, $Msg, $wParam, $lParam)
    Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
    DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
    DllStructSetData($tagMaxinfo, 8, $GUIMINHT) ; min Y
    DllStructSetData($tagMaxinfo, 9, 99999 ); max X
    DllStructSetData($tagMaxinfo, 10, 99999 ) ; max Y
    Return 0
EndFunc   ;==>WM_GETMINMAXINFO

Func Monitor($PID)
    Local $aReturn
    While ProcessExists($PID)
        Sleep(500)
        $aReturn = DllCall($hUSER32, "Int", "IsHungAppWindow", "Hwnd", WinGetHandle(WinActive("")))
        If @error Or $aReturn[0] Then ExitLoop
    WEnd
    ProcessClose($PID)
    _SuspendAll(0)
    MsgBox(64,"Whoa!","Seems like something went wrong with the script!" & @CR & @CR & "A well trained team of monkeys was dispatched to take care of the problem.")
    Exit
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlSetTip
; Description ...: Easy to use wrapper for the GUIToolTip UDF.
; Syntax ........: _GuiCtrlSetTip($hControl, $sText[, $sTitle = ""[, $iIcon = 0[, $iOptions = 0[, $iBackGroundColor = -1[,
;                  $itextColor = -1[, $iDelay = 500]]]]]])
; Parameters ....: $hControl            - A handle to the control, use -1 to assign to the last recently created control.
;                  $sText               - Tip text that will be displayed when the mouse is hovered over the control.
;                  $sTitle              - [optional] The title for the tooltip Requires IE5+
;                  $iIcon               - [optional] Pre-defined icon to show next to the title: Requires IE5+. Requires a title.
;                                        	 | 0 = No icon
;											 | 1 = Info icon
;											 | 2 = Warning icon
; 											 | 3 = Error Icon
;                                        	 | - This parameter can also be a string in the below example format~
;                                        	 | [@WindowsDir & "\Explorer.exe,100"] where 100 is the icon index in the file that
;                                        	 | contains the icon resource to use, this can be any file with icon resources.
;                  $iOptions            - [optional] Sets different options for how the tooltip will be displayed
;											 | (Can be added together):
;											 | 1 = Display as Balloon Tip Requires IE5+
;											 | 2 = Center the tip horizontally along the control.
;                  $iBackGroundColor    - [optional] A hex RGB color value to use for the tip background color.
;                  $itextColor          - [optional] A hex RGB color value to use for the tip text color.
;                  $iDelay              - [optional] A positive vale in miliseconds to set the tips delay time. Default is 500.
; Return values .: The newly created tooltip handle
; Author ........: THAT1ANONYMOUSDUDE
; Modified ......:
; Remarks .......: Just a wrapper for the GUIToolTip UDF.
; Related .......: None
; Link ..........:
; Example .......: _GUICtrlSetTip(-1,"Test tip with text, title, Icon & balloon style.","Optional title",1,1)
; ===============================================================================================================================
Func _GuiCtrlSetTip($hControl, $sText, $sTitle = "", $iIcon = 0, $iOptions = 0, $iBackGroundColor = -1, $itextColor = -1, $iDelay = 500)
	If Not IsHWnd($hControl) Then $hControl = GUICtrlGetHandle($hControl)
	If Not IsHWnd($hControl) Then Return SetError(1, 0, 0)
	If $sText = "" Then Return SetError(1, 0, 0)
	Local $hicon, $Ret
	Local $ExtStyle = 0
	Switch $iOptions
		Case 0
			$iOptions = 9
			$ExtStyle = 0
		Case 1
			$iOptions = 9
			$ExtStyle = $TTS_BALLOON
		Case 2
			$iOptions = 11
			$ExtStyle = 0
		Case 3
			$iOptions = 11
			$ExtStyle = $TTS_BALLOON
		Case Else
			$iOptions = 9
	EndSwitch
	Local $hToolTip = _GUIToolTip_Create($hControl, BitOR($ExtStyle, $TTS_ALWAYSTIP, $TTS_NOPREFIX))
	_GUIToolTip_AddTool($hToolTip, 0, $sText, $hControl, 0, 0, 0, 0, $iOptions, 0)
	$hicon = DllStructCreate('ptr')
	If IsNumber($iIcon) And $iIcon <= 3 Then
		Switch $iIcon
			Case 1
				$iIcon = -104
			Case 2
				$iIcon = -101
			Case 3
				$iIcon = -103
			Case Else
				$iIcon = 0
		EndSwitch
		If $iIcon <> 0 Then
			$Ret = DllCall('shell32.dll', 'uint', 'ExtractIconExW', 'wstr', @SystemDir & "\user32.dll", 'int', $iIcon, 'ptr', 0, 'ptr', DllStructGetPtr($hicon), 'uint', 1)
			If Not @error And $Ret[0] Then
				$hicon = DllStructGetData($hicon, 1)
			Else
				$hicon = 0
			EndIf
		Else
			$hicon = 0
		EndIf
		_GUIToolTip_SetTitle($hToolTip, $sTitle, $hicon)
		DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
	Else
		$iIcon = StringSplit($iIcon, ",")
		If $iIcon[0] > 1 Then
			$Ret = DllCall('shell32.dll', 'uint', 'ExtractIconExW', 'wstr', $iIcon[$iIcon[0] - 1], 'int', -1 * (Int($iIcon[$iIcon[0]])), 'ptr', 0, 'ptr', DllStructGetPtr($hicon), 'uint', 1)
			If Not @error And $Ret[0] Then
				$hicon = DllStructGetData($hicon, 1)

			Else
				$hicon = 0
			EndIf

			_GUIToolTip_SetTitle($hToolTip, $sTitle, $hicon)
			DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
		Else
			_GUIToolTip_SetTitle($hToolTip, $sTitle)
		EndIf
	EndIf

	If $iBackGroundColor <> -1 Or $itextColor <> -1 Then DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", $hToolTip, "wstr", "", "wstr", "")
	If $iBackGroundColor <> -1 Then _GUIToolTip_SetTipBkColor($hToolTip, $iBackGroundColor)
	If $itextColor <> -1 Then _GUIToolTip_SetTipTextColor($hToolTip, $itextColor)
	_GUIToolTip_SetDelayTime($hToolTip, 0, $iDelay)
	Return $hToolTip
EndFunc   ;==>_GuiCtrlSetTip

Func _Exit()
    If $GlobalSystemSuspension Then
        _SuspendAll(0)
    EndIf
    DllClose("psapi.dll")
    DllClose("ntdll.dll")
    DllClose("user32.dll")
    DllClose("advapi32.dll")
    DllClose("wtsapi32.dll")
    DllClose("kernel32.dll")
    Exit
EndFunc
