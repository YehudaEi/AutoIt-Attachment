#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hPSAPI = DllOpen("psapi.dll")
Global Const $hNTDLL = DllOpen("ntdll.dll")

;AdjustPrivilege(20)
Global Const $Is64 = @AutoItX64

Global $FileObject = 0;ignore this var, it is used for determaning what we will look for

Global $ReturnInf = _UnlockFile(0, @ScriptDir); will unlock the directory our script is in..
;specifying 0 as PID above will look for the handle in all processes except system and system idle process which are PIDs 0 and 4

Func _UnlockFile($PID, $FileToUnlock)
    If $PID Then
        $PID = ProcessExists($PID)
        If Not $PID Then Return SetError(1, 0, 0)
    EndIf

    Local $tSHI
    Local $tHandle
    Local $pData
    Local $Ret
    Local $Temporariis
    Local $OS
    Local $Value
    Local Const $PROCESS_DUP_HANDLE = 0x0040
    Local Const $DUPLICATE_CLOSE_SOURCE = 0x01
    Local Const $DUPLICATE_SAME_ACCESS = 0x02

    $tSHI = DllStructCreate('ulong;byte[4194304]')
    $Ret = DllCall($hNTDLL, 'uint', 'NtQuerySystemInformation', 'uint', 16, 'ptr', DllStructGetPtr($tSHI), 'ulong', DllStructGetSize($tSHI), 'ulong*', 0); thanks to yashied for this code
    If @error Then
        Return SetError(2, 0, 0)
    Else
        If $Ret[0] Then
            Return SetError(3, 0, 0)
        EndIf
    EndIf

    $pData = DllStructGetPtr($tSHI, 2)
;~     $Size = DllStructGetSize(DllStructCreate('ulong;ubyte;ubyte;ushort;ptr;ulong'))

    #region - Globalization -

    If Not $FileObject Then
        #cs
            In an attempt to make this globally operable with on a multitude of varying operating system types
            I have taken the approach of discovering the system file object type by using this messy code
            below in order to avoide depending on a static value that may not be accurate.
        #ce
        Local $tPOTI = DllStructCreate('ushort;ushort;ptr;byte[128]')
        Local $iNumber = DllStructGetData($tSHI, 1)
        For $I = 1 To $iNumber
            ;If Random(0,5,1) = 3 Then DllCall($hNTDLL, "dword", "NtDelayExecution", "int", 0, "ptr", $1MS)

            If $Is64 Then
                $Value = 4 + ($i - 1) * 24
            Else
                $Value = ($i - 1) * 16
            EndIf

            $tHandle = DllStructCreate('align 4;ulong;ubyte;ubyte;ushort;ptr;ulong', $pData + $Value)
            If DllStructGetData($tHandle, 1) <> @AutoItPID Then ContinueLoop; only search our process for now
            $temporariis = Ptr(DllStructGetData($tHandle, 4))
            Local $Ret2 = DllCall($hNTDLL, 'uint', 'NtQueryObject', 'ptr', $temporariis, 'uint', 2, 'ptr', DllStructGetPtr($tPOTI), 'ulong', DllStructGetSize($tPOTI), 'ptr', 0)
            If @error Then
                ContinueLoop
            Else
                If $Ret2[0] Then ContinueLoop
            EndIf

            Local $pData2 = DllStructGetData($tPOTI, 3)
            If Not $pData2 Then ContinueLoop

            Local $Length = DllCall($hKERNEL32, 'int', 'lstrlenW', 'ptr', $pData2)
            If @error Then ContinueLoop

            $Length = $Length[0]
            If @error Then  ContinueLoop
            If Not $Length Then  ContinueLoop

            Local $tString = DllStructCreate('wchar[' & ($Length + 1) & ']', $pData2)
            If @error Then ContinueLoop

            If DllStructGetData($tString, 1) == "File" Then; Or DllStructGetData($tString, 1) == "Process" Then
                ;I believe we can't really do anything with process objects so... skip them.
                $FileObject = DllStructGetData($tHandle, 2);found you :)
                ExitLoop
            EndIf
        Next
    EndIf

    #endregion - Globalization -

    Local $CurrentPID
    Local $hProcess
    Local $hObject

    Local $hTarget = DllCall($hKERNEL32, "handle", "GetCurrentProcess")
    If @error Then Return SetError(1, 0, 0)
    $hTarget = $hTarget[0]

    Local $struct = DllStructCreate("char[255];")
    Local $temp = DriveGetDrive("ALL")
    Local $drivesinfo[UBound($temp) - 1][2]
    For $i = 0 To UBound($drivesinfo) - 1
        $drivesinfo[$i][0] = $temp[$i + 1]
        DllCall($hKERNEL32, "dword", "QueryDosDevice", "str", $drivesinfo[$i][0], "ptr", DllStructGetPtr($struct), "dword", 255)
        $drivesinfo[$i][1] = DllStructGetData($struct, 1)
    Next

    Local $PUBLIC_OBJECT_TYPE_INFORMATION = "ushort Length;" & _
            "ushort MaximumLength;" & _
            "ptr Buffer;" & _ ;UNICODE_STRING struct
            "wchar Reserved[260];"
    Local $poti = DllStructCreate($PUBLIC_OBJECT_TYPE_INFORMATION)
    Local $devicestr
    Local $Solid
    Local $KillIt
    Local $Stolen

    Switch @OSVersion
        Case "WIN_XP", "WIN_7"
            $OS = 1
    EndSwitch

    Local $CurrentProcess = DllCall($hKERNEL32, "handle", "GetCurrentProcess")
    If @error Then
        DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $CurrentProcess[0])
        Return SetError(1, 0, 0)
    EndIf

    For $i = 1 To DllStructGetData($tSHI, 1)
        If $Is64 Then; yashied made some changes to his file enum handles function, hopefully it works on 64bit systems flawlessly now
            $Value = 4 + ($i - 1) * 24
        Else
            $Value = ($i - 1) * 16
        EndIf

        $tHandle = DllStructCreate('align 4;ulong;ubyte;ubyte;ushort;ptr;ulong', $pData + $Value)

        $CurrentPID = DllStructGetData($tHandle, 1)
        If $CurrentPID <> 0 And $CurrentPID <> 4 Then
            If $PID Then
                If Not ($CurrentPID == $PID) Then ContinueLoop
            EndIf

            #region - Danger Zone -
            ;We need to avoid these attributes or we will freeze indefinately.
            If DllStructGetData($tHandle, 2) <> $FileObject Then ContinueLoop
            $Temporariis = DllStructGetData($tHandle, 6)
            If $Temporariis == 0x00120189 Then ContinueLoop
            If $Temporariis == 0x0012019f Then ContinueLoop
            If $Temporariis == 0x00100000 Then ContinueLoop

            If $OS Then
                If Not 0x00100020 == $temporariis Then ContinueLoop
            Else
                ;Just include it since I don't really know what I should be looking for on any other OS...
            EndIf

            #endregion - Danger Zone -

            $hProcess = DllCall($hKERNEL32, 'int', "OpenProcess", "int", $PROCESS_DUP_HANDLE, "int", 0, "int", $CurrentPID)
            If @error Then ContinueLoop
            $hProcess = $hProcess[0]
            If Not $hProcess Then ContinueLoop

            $hObject = DllCall($hKERNEL32, _;there is a small chance that we can freeze here...
                    "bool", "DuplicateHandle", _; if we do freeze here, our script can only be killed by
                    "handle", $hProcess, _; killing the process that we tried to hijack a handle from.
                    "handle", Ptr(DllStructGetData($tHandle, 4)), _
                    "handle", $hTarget, _
                    "handle*", 0, _
                    "dword", 0, _
                    "bool", 0, _
                    "dword", $DUPLICATE_SAME_ACCESS _
                    )

            If @error Then
                DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $hProcess)
                ContinueLoop
            EndIf
            $hObject = $hObject[4]

            $Solid = False
            DllCall($hNTDLL, "ulong", "NtQueryObject", "ptr", $hObject, "int", 1, "ptr", DllStructGetPtr($poti), "ulong", DllStructGetSize($poti), "ulong*", "")
            $devicestr = DllStructCreate("wchar[" & Ceiling(DllStructGetData($poti, "Length") / 2) & "];", DllStructGetData($poti, "buffer"))
            $devicestr = DllStructGetData($devicestr, 1)

            For $y = 0 To UBound($drivesinfo) - 1
                If StringLeft($devicestr, StringLen($drivesinfo[$y][1])) = $drivesinfo[$y][1] Then
                    $Solid = StringLower($drivesinfo[$y][0] & StringTrimLeft($devicestr, StringLen($drivesinfo[$y][1])))
                    ExitLoop
                EndIf
            Next

			DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $hObject)

            If $Solid Then
                Switch IsArray($FileToUnlock)
                    Case True
                        For $i = 0 To UBound($FileToUnlock) - 1
                            $FileToUnlock[$i] = StringLower($FileToUnlock[$i])
                            If StringLower($FileToUnlock[$i]) == $Solid Then
                                $KillIt = 1
                            EndIf
                        Next
                    Case False
                        If StringLower($FileToUnlock) == StringLower($Solid) Then
                            $KillIt = 1
                        EndIf
                EndSwitch
                If $KillIt Then
                    $KillIt = 0

                    $Stolen = DllCall($hKERNEL32, _
                            "int", "DuplicateHandle", _
                            "ptr", $hProcess, _
                            "ptr", Ptr(DllStructGetData($tHandle, 4)), _
                            "ptr", $CurrentProcess[0], _
                            "ptr", 0, _
                            "dword", 2, _; I have no idea if this is the correct value that should be used but apparantly it works so whatever right?
                            "int", 0, _
                            "dword", $DUPLICATE_CLOSE_SOURCE _
                            )
                    If Not @error Then; And Not $Stolen[0] Then ; I don't get why the return value is zero even though it works :/
                        $Stolen = $Stolen[4]
                        DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $hProcess)
                        DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $Stolen)
                        MsgBox(0, "File or directory unlocked", "The path """ & $Solid & """ has probably been unlocked." & @CR & @CR & _
                                "Application which owned the lock: " & _ProcessGetPath($CurrentPID))
                    EndIf
                EndIf
            EndIf

            DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $hObject)

        EndIf
    Next

    DllCall($hKERNEL32, 'ptr', 'CloseHandle', 'ptr', $CurrentProcess[0])

    Return SetError(0, 0, 0)
EndFunc   ;==>_UnlockFile

Func _ProcessGetPath($vProcess)
    Local $i_PID, $aProcessHandle, $tDLLStruct, $iError, $sProcessPath
    $i_PID = ProcessExists($vProcess)
    If Not $i_PID Then Return SetError(1, 0, "");process doesn't exist?
    $aProcessHandle = DllCall($hKERNEL32, "int", "OpenProcess", "int", 0x1F0FFF, "int", 0, "int", $i_PID)
    $iError = @error
    If $iError Or $aProcessHandle[0] = 0 Then
        Return SetError(2, $iError, "");openprocess failed
    EndIf
    $tDLLStruct = DllStructCreate("char[1000]")
    DllCall($hPSAPI, "long", "GetModuleFileNameEx", "int", $aProcessHandle[0], "int", 0, "ptr", DllStructGetPtr($tDLLStruct), "long", DllStructGetSize($tDLLStruct))
    $iError = @error
    DllCall($hKERNEL32, "int", "CloseHandle", "int", $aProcessHandle[0])
    If $iError Then
        $tDLLStruct = 0
        Return SetError(4, $iError, "");getmodulefilenamex failed
    EndIf
    $sProcessPath = DllStructGetData($tDLLStruct, 1)
    $tDLLStruct = 0;format the output
    If StringLen($sProcessPath) < 2 Then Return SetError(5, 0, "");is empty or non readable
    If StringLeft($sProcessPath, 4) = "\??\" Then $sProcessPath = StringReplace($sProcessPath, "\??\", "")
    If StringLeft($sProcessPath, 20) = "\SystemRoot\System32" Then $sProcessPath = StringReplace($sProcessPath, "\SystemRoot\System32", @SystemDir)
    Return SetError(0, 0, $sProcessPath)
EndFunc   ;==>_ProcessGetPath

Func AdjustPrivilege($Type)
    Local $aReturn = DllCall("ntdll.dll", "int", "RtlAdjustPrivilege", "int", $Type, "int", 1, "int", 0, "int*", 0)
    If @error Or $aReturn[0] Then Return SetError(1, 0, 0)
    Return SetError(0, 0, 1)
EndFunc   ;==>AdjustPrivilege