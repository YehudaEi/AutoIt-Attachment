#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 6
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <winapi.au3>

Global $ARRAY_MODULE_STRUCTURE[1][1][1]
Global $global_types_count
Global $iPopulateArray
Global $global_langs_count
Global $lang_count
Global $global_names_count
Global $name_count

Global Const $RT_CURSOR = 1
Global Const $RT_BITMAP = 2
Global Const $RT_ICON = 3
Global Const $RT_MENU = 4
Global Const $RT_DIALOG = 5
Global Const $RT_STRING = 6
Global Const $RT_FONTDIR = 7
Global Const $RT_FONT = 8
Global Const $RT_ACCELERATOR = 9
Global Const $RT_RCDATA = 10
Global Const $RT_MESSAGETABLE = 11
Global Const $RT_GROUP_CURSOR = 12
Global Const $RT_GROUP_ICON = 14
Global Const $RT_VERSION = 16
Global Const $RT_DLGINCLUDE = 17
Global Const $RT_PLUGPLAY = 19
Global Const $RT_VXD = 20
Global Const $RT_ANICURSOR = 21
Global Const $RT_ANIICON = 22
Global Const $RT_HTML = 23
Global Const $RT_MANIFEST = 24

Global $LangCodeCurrent
Global $langNameCurrent[2]
Global $TypeCurrent
Global $TypeNameCurrent[2]

Global $File2
Global $Script = False
Global $PresentIcons[1]

_Main()

;Opt("GUIEventOptions",1)
Func _Main()
    #region ### START Koda GUI section ### Form=
    Local $Form2 = GUICreate("Icons", 192, 157, 269, 171, -1, 16)
    Local $Input = GUICtrlCreateInput("", 8, 8, 137, 21)
    GUICtrlSetState(-1, 8)
    Local $ListView1 = GUICtrlCreateListView("Ordinal / Name", 8, 40, 97, 105)

    Local $SelectFile = GUICtrlCreateButton("...", 152, 8, 35, 21)
    Local $ReplaceIt = GUICtrlCreateButton("Replace", 112, 40, 75, 25)
    Local $DeleteIt = GUICtrlCreateButton("Delete", 112, 72, 75, 25)
    Local $AddResFile = GUICtrlCreateButton("Add", 112, 104, 75, 25)

    GUISetState(@SW_SHOW, $Form2)
    #endregion ### END Koda GUI section ###

    Local $nMsg
    Local $File
    Local $File2
    Local $var
    Local $Form1
    Local $Str
    Local $Htmp
    Local $Type
    Local $Name
    Local $Lang
    Local $AddTheResFile

    While 1
        $nMsg = GUIGetMsg($Form2)
        ;If $nMsg <> 0 And $nMsg <> -11 Then ConsoleWrite("GUI Msg : "&$nMsg & @CR)
        Switch $nMsg
            Case -3
                Exit
            Case $ListView1
                ConsoleWrite("ListViewClicked: " & StringReplace(GUICtrlRead(GUICtrlRead($ListView1)), "|", "") & @CR)
            Case -13
                $File = GUICtrlRead($Input)
                GUICtrlDelete($ListView1)
                $ListView1 = GUICtrlCreateListView("IconName", 8, 40, 97, 105)
                _ResEnum($File, $ListView1)
            Case $SelectFile
                $var = FileOpenDialog("Select File", @DesktopDir & "\", "exe FILE (*.exe)", 1, "")
                If @error Then ContinueLoop
                GUICtrlSetData($Input, $var)
                GUICtrlDelete($ListView1)
                $ListView1 = GUICtrlCreateListView("IconName", 8, 40, 97, 105)
                _ResEnum($var, $ListView1)
            Case $ReplaceIt
                $var = FileOpenDialog("Select Icon File", @DesktopDir & "\", "ico FILE (*.ico)", 1, "")
                If @error Then ContinueLoop
                $Str = GUICtrlRead(GUICtrlRead($ListView1))
                If $Str <> "" Then
                    If StringInStr($Str, "|") Then $Str = StringReplace($Str, "|", "")
                    $File = GUICtrlRead($Input)
                    If @error Or Not FileExists($File) Then ContinueLoop
                    $Script = _GetScriptData($File)
                    If Not @error Or $Script Then
                        _Process($File, StringStripWS($Str, 3), $var)
                        If @error Then ContinueLoop
                        $Htmp = FileOpen($File, 17)
                        FileWrite($Htmp, $Script)
                        FileClose($Htmp)
                        ContinueLoop
                    EndIf
                    _Process($File, $Str, $var)
                EndIf
                GUICtrlDelete($ListView1)
                $ListView1 = GUICtrlCreateListView("IconName", 8, 40, 97, 105)
                _ResEnum($var, $ListView1)
            Case $DeleteIt
                $Str = GUICtrlRead(GUICtrlRead($ListView1))
                If $Str <> "" Then
                    If StringInStr($Str, "|") Then $Str = StringReplace($Str, "|", "")
                    $File = GUICtrlRead($Input)
                    If @error Or Not FileExists($File) Then ContinueLoop
                    $Script = _GetScriptData($File)
                    If Not @error Or $Script Then
                        _Process($File, $Str, '')
                        If @error Then ContinueLoop
                        $Htmp = FileOpen($File, 17)
                        FileWrite($Htmp, $Script)
                        FileClose($Htmp)
                    EndIf
                EndIf
                GUICtrlDelete($ListView1)
                $ListView1 = GUICtrlCreateListView("IconName", 8, 40, 97, 105)
                _ResEnum($File, $ListView1)
            Case $AddResFile
                $Form1 = GUICreate("Form1", 82, 116, 321, 257)
                $Type = GUICtrlCreateInput("Type", 8, 8, 65, 21)
                $Name = GUICtrlCreateInput("Name", 8, 32, 65, 21)
                $Lang = GUICtrlCreateInput("Lang", 8, 56, 65, 21)
                $AddTheResFile = GUICtrlCreateButton("Add", 8, 80, 65, 21)
                GUISetState(@SW_SHOW, $Form1)
                While 1
                    $nMsg = GUIGetMsg($Form1)
                    Switch $nMsg
                        Case -3
                            ExitLoop
                        Case $AddTheResFile
                            Local $RT = GUICtrlRead($Type)
                            Local $OR = GUICtrlRead($Name)
                            Local $LN = GUICtrlRead($Lang)
                            If Not $RT Or Not $OR Then
                                MsgBox(0, "Error!", "Empty value.")
                                ContinueLoop
                            EndIf
                            If Not $LN Then $LN = 0
                            If Not Number($LN) And Not Number($LN) = 0 Then
                                MsgBox(0, "Error!", "Wrong language code type.")
                                ContinueLoop
                            EndIf
                            $File = FileOpenDialog("Select a file to add", "", "(*)")
                            If @error Then ExitLoop
                            $File2 = GUICtrlRead($Input)
                            If Not FileExists($File2) Then
                                MsgBox(0, "Error!", "No file selected.")
                                ExitLoop
                            EndIf
                            $Script = _GetScriptData($File2)
                            If Not @error Or $Script Then
                                _ResUpdate($File2, $RT, $OR, $LN, $File)
                                If @error Then
                                    MsgBox(0, "Error!", "Error updating resource!")
                                    ExitLoop
                                EndIf
                                $Htmp = FileOpen($File2, 17)
                                FileWrite($Htmp, $Script)
                                FileClose($Htmp)
                                ExitLoop
                            EndIf
                            _ResUpdate($File2, $RT, $OR, Number($LN), $File)
                            ExitLoop
                    EndSwitch
                WEnd
                GUIDelete($Form1)
        EndSwitch
    WEnd
EndFunc   ;==>_Main
#region - Find Icon -

Func _Process($Host, $Name, $Res)
    If Number($Name) Then $Name = Number($Name)
    Local $Crack = _CrackIcon($Name, 0, $Host, $RT_GROUP_ICON)
    If @error Then Return SetError(1, 0, 0)
    If Not _ResInfo($Host) Then Return 0
    For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
        If ($ARRAY_MODULE_STRUCTURE[$f][0][0] = 3) Or ($ARRAY_MODULE_STRUCTURE[$f][0][0] = 14) Then
            For $g = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                If $ARRAY_MODULE_STRUCTURE[$f][$g][0] Then
                    For $h = 1 To UBound($ARRAY_MODULE_STRUCTURE, 3) - 1
                        For $I = 0 To UBound($Crack) - 1
                            If ($ARRAY_MODULE_STRUCTURE[$f][$g][0] = $Crack[$I][6]) Then
                                _ResDelete($Host, _
                                    $ARRAY_MODULE_STRUCTURE[$f][0][0], _
                                    $ARRAY_MODULE_STRUCTURE[$f][$g][0], _
                                    $ARRAY_MODULE_STRUCTURE[$f][$g][$h] _
                                )
;~                                 _Res_Update($Host, '', _
;~                                     $ARRAY_MODULE_STRUCTURE[$f][0][0], _
;~                                     $ARRAY_MODULE_STRUCTURE[$f][$g][0], _
;~                                     $ARRAY_MODULE_STRUCTURE[$f][$g][$h] _
;~                                 )
                            EndIf
                        Next
                        If ($ARRAY_MODULE_STRUCTURE[$f][0][0] = 14) And ($ARRAY_MODULE_STRUCTURE[$f][$g][0] = $Name) Then
                            _ResDelete($Host, _
                                $ARRAY_MODULE_STRUCTURE[$f][0][0], _
                                $ARRAY_MODULE_STRUCTURE[$f][$g][0], _
                                $ARRAY_MODULE_STRUCTURE[$f][$g][$h] _
                            )
;~                             _Res_Update($Host, '', _
;~                                 $ARRAY_MODULE_STRUCTURE[$f][0][0], _
;~                                 $ARRAY_MODULE_STRUCTURE[$f][$g][0], _
;~                                 $ARRAY_MODULE_STRUCTURE[$f][$g][$h] _
;~                             )
                        EndIf
                    Next
                EndIf
            Next
        EndIf
    Next
    If Not _ResInfo($Host) Then Return 0
    If $Res Then _ResUpdate($Host, $RT_GROUP_ICON, $Name, 0, $Res)
    ;_Res_Update($Host, $Res, 3, $Name, 0)
    Return 1
EndFunc   ;==>_Process

Func _GetScriptData($sModule)
    Local $iLoaded
    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", $sModule)
    If @error Then
        Return SetError(1, 0, "")
    EndIf
    Local $pPointer = $a_hCall[0]

    If Not $a_hCall[0] Then
        $a_hCall = DllCall("kernel32.dll", "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 1)
        If @error Or Not $a_hCall[0] Then
            Return SetError(2, 0, "")
        EndIf
        $iLoaded = 1
        $pPointer = $a_hCall[0]
    EndIf


    Local $hModule = $a_hCall[0]
    Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
            "ushort BytesOnLastPage;" & _
            "ushort Pages;" & _
            "ushort Relocations;" & _
            "ushort SizeofHeader;" & _
            "ushort MinimumExtra;" & _
            "ushort MaximumExtra;" & _
            "ushort SS;" & _
            "ushort SP;" & _
            "ushort Checksum;" & _
            "ushort IP;" & _
            "ushort CS;" & _
            "ushort Relocation;" & _
            "ushort Overlay;" & _
            "char Reserved[8];" & _
            "ushort OEMIdentifier;" & _
            "ushort OEMInformation;" & _
            "char Reserved2[20];" & _
            "dword AddressOfNewExeHeader", _
            $pPointer)
    $pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader")
    Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer)
    If Not (DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") = 17744) Then
        If $iLoaded Then
            DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
        EndIf
        Return SetError(3, 0, "")
    EndIf
    $pPointer += 4
    Local $tIMAGE_FILE_HEADER = DllStructCreate("ushort Machine;" & _
            "ushort NumberOfSections;" & _
            "dword TimeDateStamp;" & _
            "dword PointerToSymbolTable;" & _
            "dword NumberOfSymbols;" & _
            "ushort SizeOfOptionalHeader;" & _
            "ushort Characteristics", _
            $pPointer)

    Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
    $pPointer += 20
;~     Local $tIMAGE_OPTIONAL_HEADER = DllStructCreate("ushort Magic;" & _
;~             "ubyte MajorLinkerVersion;" & _
;~             "ubyte MinorLinkerVersion;" & _
;~             "dword SizeOfCode;" & _
;~             "dword SizeOfInitializedData;" & _
;~             "dword SizeOfUninitializedData;" & _
;~             "dword AddressOfEntryPoint;" & _
;~             "dword BaseOfCode;" & _
;~             "dword BaseOfData;" & _
;~             "dword ImageBase;" & _
;~             "dword SectionAlignment;" & _
;~             "dword FileAlignment;" & _
;~             "ushort MajorOperatingSystemVersion;" & _
;~             "ushort MinorOperatingSystemVersion;" & _
;~             "ushort MajorImageVersion;" & _
;~             "ushort MinorImageVersion;" & _
;~             "ushort MajorSubsystemVersion;" & _
;~             "ushort MinorSubsystemVersion;" & _
;~             "dword Win32VersionValue;" & _
;~             "dword SizeOfImage;" & _
;~             "dword SizeOfHeaders;" & _
;~             "dword CheckSum;" & _
;~             "ushort Subsystem;" & _
;~             "ushort DllCharacteristics;" & _
;~             "dword SizeOfStackReserve;" & _
;~             "dword SizeOfStackCommit;" & _
;~             "dword SizeOfHeapReserve;" & _
;~             "dword SizeOfHeapCommit;" & _
;~             "dword LoaderFlags;" & _
;~             "dword NumberOfRvaAndSizes", _
;~             $pPointer)
    $pPointer += 96
;~     Local $tIMAGE_DIRECTORY_ENTRY_EXPORT = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_RESOURCE = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_EXCEPTION = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_SECURITY = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_DEBUG = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_COPYRIGHT = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_GLOBALPTR = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_TLS = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
;~     Local $tIMAGE_DIRECTORY_ENTRY_LOAD_CONFIG = DllStructCreate("dword VirtualAddress;" & _
;~             "dword Size", _
;~             $pPointer)
    $pPointer += 8
    $pPointer += 40
    Local $tIMAGE_SECTION_HEADER
    For $I = 1 To $iNumberOfSections
        $tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
                "dword UnionOfData;" & _
                "dword VirtualAddress;" & _
                "dword SizeOfRawData;" & _
                "dword PointerToRawData;" & _
                "dword PointerToRelocations;" & _
                "dword PointerToLinenumbers;" & _
                "ushort NumberOfRelocations;" & _
                "ushort NumberOfLinenumbers;" & _
                "dword Characteristics", _
                $pPointer)
        If $I = $iNumberOfSections Then
            Local $array[2]
            $array[0] = Hex(DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData"))
            $array[1] = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
            Local $FilePath = $sModule
            Local $Offset = Dec($array[0]) + $array[1]
            Local $Length = FileGetSize($sModule) - $Offset

            Local $Buffer, $ptr, $fLen, $hFile, $Result, $Read, $err, $Pos

            If Not FileExists($FilePath) Then Return SetError(1, @error, 0)
            $fLen = FileGetSize($FilePath)
            If $Offset > $fLen Then Return SetError(2, @error, 0)
            If $fLen < $Offset + $Length Then Return SetError(3, @error, 0)

            $Buffer = DllStructCreate("byte[" & $Length & "]")
            $ptr = DllStructGetPtr($Buffer)

            $hFile = _WinAPI_CreateFile($FilePath, 2, 2, 0)
            If $hFile = 0 Then Return SetError(5, @error, 0)

            $Pos = $Offset
            $Result = _WinAPI_SetFilePointer($hFile, $Pos)
            $err = @error
            If $Result = 0xFFFFFFFF Then
                _WinAPI_CloseHandle($hFile)
                Return SetError(6, $err, 0)
            EndIf

            $Read = 0
            $Result = _WinAPI_ReadFile($hFile, $ptr, $Length, $Read)
            $err = @error
            If Not $Result Then
                _WinAPI_CloseHandle($hFile)
                Return SetError(7, $err, 0)
            EndIf

            _WinAPI_CloseHandle($hFile)
            If Not $Result Then Return SetError(8, @error, 0)

            $Result = DllStructGetData($Buffer, 1)
            DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            Return $Result
        EndIf

        $pPointer += 40

    Next

EndFunc   ;==>_GetScriptData

Func _ResDelete($sModule, $iResType, $iResName, $iResLang)

    If Not FileExists($sModule) Then
        MsgBox(0, "", "not found")
        Return SetError(100, 0, "") ; what happened???
    EndIf

    Local $hFile = FileOpen($sModule, 1)
    If $hFile = -1 Then
        MsgBox(0, "", "open error")
        Return SetError(101, 0, "") ; cannot obtain writing rights
    EndIf

    FileClose($hFile)

    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

    If @error Or Not $a_hCall[0] Then
        Return SetError(1, 0, "")
    EndIf

    Local $a_iCall
    Switch IsNumber($iResType) + 2 * IsNumber($iResName)
        Case 0
            $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                    "hwnd", $a_hCall[0], _
                    "wstr", $iResType, _
                    "wstr", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
        Case 1
            $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                    "hwnd", $a_hCall[0], _
                    "int", $iResType, _
                    "wstr", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
        Case 2
            $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                    "hwnd", $a_hCall[0], _
                    "wstr", $iResType, _
                    "int", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
        Case 3
            $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                    "hwnd", $a_hCall[0], _
                    "int", $iResType, _
                    "int", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
    EndSwitch

    If @error Or Not $a_iCall[0] Then
        DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
        Return SetError(2, 0, "")
    EndIf

    $a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

    If @error Or Not $a_iCall[0] Then
        Return SetError(3, 0, "")
    EndIf

    Return SetError(0, 0, 1)

EndFunc   ;==>_ResDelete

Func _ResEnum($Host, $CTRL)
    Local $Tmp
    If Not _ResInfo($Host) Then Return 0
    For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
        If $ARRAY_MODULE_STRUCTURE[$f][0][0] Then
            For $g = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                If $ARRAY_MODULE_STRUCTURE[$f][$g][0] Then
                    ;For $h = 1 To UBound($ARRAY_MODULE_STRUCTURE, 3) - 1
                    If $ARRAY_MODULE_STRUCTURE[$f][0][0] = 14 Then ; we only want acces to GROUPICON resources
                        $Tmp = GUICtrlCreateListViewItem($ARRAY_MODULE_STRUCTURE[$f][$g][0], $CTRL)
                        GUICtrlSetImage($Tmp, $Host, $ARRAY_MODULE_STRUCTURE[$f][$g][0], 0)
                        ;MsgBox(0,'',$ARRAY_MODULE_STRUCTURE[$f][$g][0])
                    EndIf
                    ;Next
                EndIf
            Next
        EndIf
    Next
    Return 1
EndFunc   ;==>_ResEnum

Func _CrackIcon($iIconName, $iResLang, $sModule, $Type)

    Local $bBinary = _ResourceGetAsRaw($Type, $iIconName, $iResLang, $sModule, 1)

    If @error Then
        Return SetError(@error, 0, "")
    EndIf

    Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
    DllStructSetData($tBinary, 1, $bBinary)

    Local $tResource = DllStructCreate("ushort;" & _
            "ushort Type;" & _
            "ushort ImageCount;" & _
            "byte Body[" & DllStructGetSize($tBinary) - 6 & "]", _
            DllStructGetPtr($tBinary))

    Local $iIconCount = DllStructGetData($tResource, "ImageCount")

    If Not $iIconCount Or $iIconCount > 50 Then ; this likely indicates usage of exe compressor
        Return SetError(0, 1, "")
    EndIf

    Local $iWidth, $iHeight
    Local $aIconsData[$iIconCount][7]
    Local $tGroupIconData

    For $I = 0 To $iIconCount - 1
        $tGroupIconData = DllStructCreate("ubyte Width;" & _
                "ubyte Height;" & _
                "ubyte Colors;" & _
                "ubyte;" & _
                "ushort Planes;" & _
                "ushort BitPerPixel;" & _
                "dword BitmapSize;" & _
                "ushort OrdinalName;", _
                DllStructGetPtr($tResource, "Body") + $I * 14)

        $iWidth = DllStructGetData($tGroupIconData, "Width")
        If Not $iWidth Then
            $iWidth = 256
        EndIf

        $iHeight = DllStructGetData($tGroupIconData, "Height")
        If Not $iHeight Then
            $iHeight = 256
        EndIf

        $aIconsData[$I][0] = $iWidth
        $aIconsData[$I][1] = $iHeight
        $aIconsData[$I][2] = DllStructGetData($tGroupIconData, "Colors")
        $aIconsData[$I][3] = DllStructGetData($tGroupIconData, "Planes")
        $aIconsData[$I][4] = DllStructGetData($tGroupIconData, "BitPerPixel")
        $aIconsData[$I][5] = DllStructGetData($tGroupIconData, "BitmapSize")
        $aIconsData[$I][6] = DllStructGetData($tGroupIconData, "OrdinalName")
    Next

    Return SetError(0, 0, $aIconsData)

EndFunc   ;==>_CrackIcon

Func _ResourceGetAsRaw($iResType, $iResName, $iResLang, $sModule, $iMode = 0, $iSize = 0)

    Local $iLoaded
    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", $sModule)

    If @error Then
        Return SetError(1, 0, "")
    EndIf

    If Not $a_hCall[0] Then
        $a_hCall = DllCall("kernel32.dll", "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 34)
        If @error Or Not $a_hCall[0] Then
            Return SetError(2, 0, "")
        EndIf
        $iLoaded = 1
    EndIf

    Local $hModule = $a_hCall[0]

    Switch IsNumber($iResType) + 2 * IsNumber($iResName)
        Case 0
            $a_hCall = DllCall("kernel32.dll", "hwnd", "FindResourceExW", _
                    "hwnd", $hModule, _
                    "wstr", $iResType, _
                    "wstr", $iResName, _
                    "int", $iResLang)
        Case 1
            $a_hCall = DllCall("kernel32.dll", "hwnd", "FindResourceExW", _
                    "hwnd", $hModule, _
                    "int", $iResType, _
                    "wstr", $iResName, _
                    "int", $iResLang)
        Case 2
            $a_hCall = DllCall("kernel32.dll", "hwnd", "FindResourceExW", _
                    "hwnd", $hModule, _
                    "wstr", $iResType, _
                    "int", $iResName, _
                    "int", $iResLang)
        Case 3
            $a_hCall = DllCall("kernel32.dll", "hwnd", "FindResourceExW", _
                    "hwnd", $hModule, _
                    "int", $iResType, _
                    "int", $iResName, _
                    "int", $iResLang)
    EndSwitch

    If @error Or Not $a_hCall[0] Then
        If $iLoaded Then
            Local $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(7, 0, "")
            EndIf
        EndIf
        Return SetError(3, 0, "")
    EndIf

    Local $hResource = $a_hCall[0]

    $a_iCall = DllCall("kernel32.dll", "int", "SizeofResource", "hwnd", $hModule, "hwnd", $hResource)

    If @error Or Not $a_iCall[0] Then
        If $iLoaded Then
            $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(7, 0, "")
            EndIf
        EndIf
        Return SetError(4, 0, "")
    EndIf

    Local $iSizeOfResource = $a_iCall[0]

    $a_hCall = DllCall("kernel32.dll", "hwnd", "LoadResource", "hwnd", $hModule, "hwnd", $hResource)

    If @error Or Not $a_hCall[0] Then
        If $iLoaded Then
            $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(7, 0, "")
            EndIf
        EndIf
        Return SetError(5, 0, "")
    EndIf

    Local $a_pCall = DllCall("kernel32.dll", "ptr", "LockResource", "hwnd", $a_hCall[0])

    If @error Or Not $a_pCall[0] Then
        If $iLoaded Then
            $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(7, 0, "")
            EndIf
        EndIf
        Return SetError(6, 0, "")
    EndIf

    Local $tOut
    Switch $iMode
        Case 0
            $tOut = DllStructCreate("char[" & $iSizeOfResource + 1 & "]", $a_pCall[0])
        Case 1
            $tOut = DllStructCreate("byte[" & $iSizeOfResource & "]", $a_pCall[0])
    EndSwitch

    Local $sReturnData = DllStructGetData($tOut, 1)

    If $iLoaded Then
        $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
        If @error Or Not $a_iCall[0] Then
            Return SetError(7, 0, "")
        EndIf
    EndIf

    Switch $iSize
        Case 0
            Return SetError(0, 0, $sReturnData)
        Case Else
            Switch $iMode
                Case 0
                    Return SetError(0, 0, StringLeft($sReturnData, $iSize))
                Case 1
                    Return SetError(0, 0, BinaryMid($sReturnData, 1, $iSize))
            EndSwitch
    EndSwitch

EndFunc   ;==>_ResourceGetAsRaw

Func _ResUpdate($sModule, $iResType, $iResName, $iResLang, $sResFile)
    If Not _ResInfo($sModule) Then Return SetError(99, 0, "")
    If Not FileExists($sModule) Then
        Return SetError(100, 0, "") ; what happened???
    EndIf

    Local $hFile = FileOpen($sModule, 1)
    If $hFile = -1 Then
        Return SetError(101, 0, "") ; cannot obtain writing rights
    EndIf

    FileClose($hFile)

    Switch $iResType

        Case $RT_GROUP_ICON

            Local $tBinary = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            Local $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tBinary, 1, FileRead($hResFile))
            FileClose($hResFile)

            Local $tResource = DllStructCreate("ushort;" & _
                    "ushort Type;" & _
                    "ushort ImageCount;" & _
                    "byte Body[" & DllStructGetSize($tBinary) - 6 & "]", _
                    DllStructGetPtr($tBinary))

            Local $iIconCount = DllStructGetData($tResource, "ImageCount")

            If Not $iIconCount Then
                Return SetError(5, 0, "")
            EndIf

            Local $tIconGroupHeader = DllStructCreate("ushort;" & _
                    "ushort Type;" & _
                    "ushort ImageCount;" & _
                    "byte Body[" & $iIconCount * 14 & "]")

            DllStructSetData($tIconGroupHeader, 1, DllStructGetData($tResource, 1))
            DllStructSetData($tIconGroupHeader, "Type", DllStructGetData($tResource, "Type"))
            DllStructSetData($tIconGroupHeader, "ImageCount", DllStructGetData($tResource, "ImageCount"))

            Local $tInputIconHeader
            Local $tGroupIconData

            Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Local $iEnumIconName

            For $I = 1 To $iIconCount
                ;MsgBox(0,$I,$iIconCount)
                $tInputIconHeader = DllStructCreate("ubyte Width;" & _
                        "ubyte Height;" & _
                        "ubyte Colors;" & _
                        "ubyte;" & _
                        "ushort Planes;" & _
                        "ushort BitPerPixel;" & _
                        "dword BitmapSize;" & _
                        "dword BitmapOffset", _
                        DllStructGetPtr($tResource, "Body") + ($I - 1) * 16)

                $tGroupIconData = DllStructCreate("ubyte Width;" & _
                        "ubyte Height;" & _
                        "ubyte Colors;" & _
                        "ubyte;" & _
                        "ushort Planes;" & _
                        "ushort BitPerPixel;" & _
                        "dword BitmapSize;" & _
                        "ushort OrdinalName;", _
                        DllStructGetPtr($tIconGroupHeader, "Body") + ($I - 1) * 14)

                DllStructSetData($tGroupIconData, "Width", DllStructGetData($tInputIconHeader, "Width"))
                DllStructSetData($tGroupIconData, "Height", DllStructGetData($tInputIconHeader, "Height"))
                DllStructSetData($tGroupIconData, "Colors", DllStructGetData($tInputIconHeader, "Colors"))
                DllStructSetData($tGroupIconData, 4, DllStructGetData($tInputIconHeader, 4))
                DllStructSetData($tGroupIconData, "Planes", DllStructGetData($tInputIconHeader, "Planes"))
                DllStructSetData($tGroupIconData, "BitPerPixel", DllStructGetData($tInputIconHeader, "BitPerPixel"))
                DllStructSetData($tGroupIconData, "BitmapSize", DllStructGetData($tInputIconHeader, "BitmapSize"))

                $iEnumIconName += 1
                For $m = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
                    If $ARRAY_MODULE_STRUCTURE[$m][0][0] = $RT_ICON Then
                        For $n = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                            If $iEnumIconName = $ARRAY_MODULE_STRUCTURE[$m][$n][0] Then
                                $iEnumIconName += 1
                            EndIf
                        Next
                        ExitLoop
                    EndIf
                Next

                DllStructSetData($tGroupIconData, "OrdinalName", $iEnumIconName)

                Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                        "hwnd", $a_hCall[0], _
                        "int", $RT_ICON, _
                        "int", $iEnumIconName, _
                        "int", $iResLang, _
                        "ptr", DllStructGetPtr($tResource) + DllStructGetData($tInputIconHeader, "BitmapOffset"), _
                        "dword", DllStructGetData($tInputIconHeader, "BitmapSize"))

                If @error Or Not $a_iCall[0] Then
                    DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                    Return SetError(7, $iEnumIconName, "")
                EndIf

            Next

            Switch IsNumber($iResName)
                Case True
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $RT_GROUP_ICON, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tIconGroupHeader), _
                            "dword", DllStructGetSize($tIconGroupHeader))
                Case Else
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "int", $RT_GROUP_ICON, _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tIconGroupHeader), _
                            "dword", DllStructGetSize($tIconGroupHeader))
            EndSwitch

            If @error Or Not $a_iCall[0] Then
                DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                Return SetError(8, 0, "")
            EndIf

            $a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

            If @error Or Not $a_iCall[0] Then
                Return SetError(9, 0, "")
            EndIf


        Case $RT_RCDATA, $RT_MANIFEST, $RT_ANICURSOR, $RT_ANIICON, $RT_HTML

            $tResource = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tResource, 1, FileRead($hResFile))
            FileClose($hResFile)

            If @error Then
                Return SetError(5, 0, "")
            EndIf

            $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Switch IsNumber($iResName)
                Case True
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case Else
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
            EndSwitch

            If @error Or Not $a_iCall[0] Then
                DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                Return SetError(7, 0, "")
            EndIf

            $a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

            If @error Or Not $a_iCall[0] Then
                Return SetError(8, 0, "")
            EndIf

        Case $RT_BITMAP

            $tBinary = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tBinary, 1, FileRead($hResFile))
            FileClose($hResFile)

            $tResource = DllStructCreate("align 2;char Identifier[2];" & _
                    "dword BitmapSize;" & _
                    "short;" & _
                    "short;" & _
                    "dword BitmapOffset;" & _
                    "byte Body[" & DllStructGetSize($tBinary) - 14 & "]", _
                    DllStructGetPtr($tBinary))

            If Not (DllStructGetData($tResource, 1) == "BM") Then
                Return SetError(5, 0, "")
            EndIf

            $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Switch IsNumber($iResName)
                Case True
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource, "Body"), _
                            "dword", FileGetSize($sResFile) - 14)
                Case Else
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource, "Body"), _
                            "dword", FileGetSize($sResFile) - 14)
            EndSwitch

            If @error Or Not $a_iCall[0] Then
                DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                Return SetError(7, 0, "")
            EndIf

            $a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

            If @error Or Not $a_iCall[0] Then
                Return SetError(8, 0, "")
            EndIf


        Case Else

            $tResource = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tResource, 1, FileRead($hResFile))
            FileClose($hResFile)

            If @error Then
                Return SetError(5, 0, "")
            EndIf

            $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Switch IsNumber($iResType) + 2 * IsNumber($iResName)
                Case 0
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "wstr", StringUpper($iResType), _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case 1
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case 2
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "wstr", StringUpper($iResType), _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case 3
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
            EndSwitch

            If @error Or Not $a_iCall[0] Then
                DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                Return SetError(7, 0, "")
            EndIf

            $a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

            If @error Or Not $a_iCall[0] Then
                Return SetError(8, 0, "")
            EndIf

    EndSwitch

    Return SetError(0, 0, 1) ; all done

EndFunc   ;==>_ResUpdate

Func _ResourceEnumerate(ByRef $sModule)

    DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 1) ; SEM_FAILCRITICALERRORS
    Local $iLoaded
    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", $sModule)
    If @error Then
        Return SetError(2, 0, "")
    EndIf
    If Not $a_hCall[0] Then
        $a_hCall = DllCall("kernel32.dll", "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 34) ; LOAD_LIBRARY_AS_IMAGE_RESOURCE|LOAD_LIBRARY_AS_DATAFILE
        If @error Or Not $a_hCall[0] Then
            Return SetError(3, 0, "")
        EndIf
        $iLoaded = 1
    EndIf
    Local $hModule = $a_hCall[0]
    $ARRAY_MODULE_STRUCTURE[0][0][0] = ""
    $global_names_count = 1
    $name_count = 0
    $global_langs_count = 1
    $lang_count = 0
    $global_types_count = 1
    Local $h_CB = DllCallbackRegister("_CallbackEnumResTypeProc", "int", "hwnd;ptr;ptr")
    If Not $h_CB Then
        Return SetError(4, 0, "")
    EndIf
    Local $h_CB1 = DllCallbackRegister("_CallbackEnumResNameProc", "int", "hwnd;ptr;ptr;ptr")
    If Not $h_CB1 Then
        Return SetError(4, 0, "")
    EndIf
    Local $a_iCall = DllCall("kernel32.dll", "int", "EnumResourceTypesW", _
            "hwnd", $hModule, _
            "ptr", DllCallbackGetPtr($h_CB), _
            "ptr", DllCallbackGetPtr($h_CB1)) ; 0
    If @error Then
        DllCallbackFree($h_CB)
        If $iLoaded Then
            $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(6, 0, "")
            EndIf
        EndIf
        Return SetError(5, 0, "")
    EndIf
    DllCallbackFree($h_CB1)
    DllCallbackFree($h_CB)
    If $iLoaded Then
        $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
        If @error Or Not $a_iCall[0] Then
            Return SetError(6, 0, "")
        EndIf
    EndIf
    Return SetError(0, 0, 1)
EndFunc   ;==>_ResourceEnumerate

Func _CallbackEnumResTypeProc($hModule, $pType, $LParam)
    $global_types_count += 1
    $name_count = 0
    If $iPopulateArray Then
        Local $a_iCall = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pType)
        If $a_iCall[0] Then
            Local $tType = DllStructCreate("wchar[" & $a_iCall[0] + 1 & "]", $pType)
            $ARRAY_MODULE_STRUCTURE[$global_types_count - 1][0][0] = DllStructGetData($tType, 1)
        Else
            $ARRAY_MODULE_STRUCTURE[$global_types_count - 1][0][0] = BitOR($pType, 0)
        EndIf
    EndIf
    Local $h_CB = DllCallbackRegister("_CallbackEnumResLangProc", "int", "hwnd;ptr;ptr;ushort;int")
    $a_iCall = DllCall("kernel32.dll", "int", "EnumResourceNamesW", _
            "hwnd", $hModule, _
            "ptr", $pType, _
            "ptr", $LParam, _
            "ptr", DllCallbackGetPtr($h_CB))
    DllCallbackFree($h_CB)
    Return 1
EndFunc   ;==>_CallbackEnumResTypeProc

Func _CallbackEnumResLangProc($hModule, $pType, $pName, $iLang, $LParam)
    $lang_count += 1
    If $lang_count > $global_langs_count - 1 Then
        $global_langs_count += 1
    EndIf
    If $iPopulateArray Then
        $ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$LParam][$lang_count] = $iLang
    EndIf
    Return 1
EndFunc   ;==>_CallbackEnumResLangProc

Func _CallbackEnumResNameProc($hModule, $pType, $pName, $LParam)
    $lang_count = 0
    $name_count += 1
    If $iPopulateArray Then
        Local $a_iCall = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pName)
        If $a_iCall[0] Then
            Local $tName = DllStructCreate("wchar[" & $a_iCall[0] + 1 & "]", $pName)
            $ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$name_count][0] = DllStructGetData($tName, 1)
        Else
            $ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$name_count][0] = BitOR($pName, 0)
        EndIf
    Else
        If $name_count > $global_names_count - 1 Then
            $global_names_count += 1
        EndIf
    EndIf
    $a_iCall = DllCall("kernel32.dll", "int", "EnumResourceLanguagesW", _
            "hwnd", $hModule, _
            "ptr", $pType, _
            "ptr", $pName, _
            "ptr", $LParam, _
            "int", $name_count)
    Return 1
EndFunc   ;==>_CallbackEnumResNameProc

Func _ResInfo($sFile)
    If $sFile Then
        Local $hFile = FileOpen($sFile, 16)
        If $hFile = -1 Then
            MsgBox(48, "Error", "Inernal error")
            Return 0
        EndIf
        Local $bFile = FileRead($hFile)
        FileClose($hFile)
        If Not (BinaryToString(BinaryMid($bFile, 1, 2)) == "MZ") Then
            MsgBox(48, "Error", "Invalid file type! Choose another.")
            Return 0
        EndIf
        $iPopulateArray = 0
        ReDim $ARRAY_MODULE_STRUCTURE[1][1][1]
        _ResourceEnumerate($sFile) ; to determine $ARRAY_MODULE_STRUCTURE size
        Switch @error
            Case 2, 4, 6
                MsgBox(48, "Error", "Inernal error")
                Return 0
            Case 3
                MsgBox(48, "Error", "Unable to load " & FileGetLongName($sFile))
                Return 0
            Case 5
                MsgBox(48, "Error", "Error enumerating")
                Return 0
        EndSwitch
        $iPopulateArray = 1
        ReDim $ARRAY_MODULE_STRUCTURE[$global_types_count][$global_names_count][$global_langs_count]
        _ResourceEnumerate($sFile)
        Switch @error
            Case 2, 4, 6
                MsgBox(48, "Error", "Inernal error")
                Return 0
            Case 3
                MsgBox(48, "Error", "Unable to load " & FileGetLongName($sFile))
                Return 0
            Case 5
                MsgBox(48, "Error", "Error enumerating")
                Return 0
        EndSwitch
    Else
        Return 0
    EndIf
    Return 1
EndFunc   ;==>_ResInfo

#endregion - Find Icon -

Func _Res_Update($FileIn, $InpResFile, $RType, $RName, $RLanguage = 1033)
    Local $result, $hFile, $tSize, $tBuffer, $pBuffer, $bread = 0
    Local $RType_Type, $RName_Type, $rc, $IconResBase
    Local $aRESOURCE_TYPES[24] = ["RT_CURSOR", "RT_BITMAP", "RT_ICON", "RT_MENU", "RT_DIALOG", "RT_STRING", "RT_FONTDIR", "RT_FONT", "RT_ACCELERATOR", _
            "RT_RCDATA", "RT_MESSAGETABLE", "RT_GROUPCURSOR", "", "RT_GROUPICON", "", "RT_VERSION", "RT_DLGINCLUDE", "", "RT_PLUGPLAY", _
            "RT_VXD", "RT_ANICURSOR", "RT_ANIICON", "RT_HTML", "RT_MANIFEST"]
    ; did we really get a number?
    If StringIsDigit($RType) Then $RType = Number($RType)
    If StringIsDigit($RName) Then $RName = Number($RName)
    ; check for known resource types and convert to ordinal
    If IsString($RType) Then
        For $k = 0 To UBound($aRESOURCE_TYPES) - 1
            If $RType = $aRESOURCE_TYPES[$k] Then
                $RType = $k + 1
                $RType_Type = "long"
            EndIf
        Next
    EndIf

    ; set parameter types
    If IsString($RType) Then
        $RType_Type = "wstr"
        $RType = StringUpper($RType)
    Else
        $RType_Type = "long"
    EndIf
    If IsString($RName) Then
        $RName_Type = "wstr"
        $RName = StringUpper($RName)
    Else
        $RName_Type = "long"
    EndIf

    Local $rh = DllCall("kernel32.dll", "ptr", "BeginUpdateResourceW", "wstr", $FileIn, "int", 0)
    If @error Or Not $rh[0] Then
        Return SetError(1,0,"")
    EndIf

    $rh = $rh[0]

    ; Remove requested Section from the program resources.
    If $InpResFile = "" Then
        ; No resource file defined thus delete the existing resource
        $result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, $RName_Type, $RName, "ushort", $RLanguage, "ptr", 0, 'dword', 0)
        $result = DllCall("kernel32.dll", "int", "EndUpdateResourceW", "ptr", $rh, "int", 0)
        If $result[0] <> 1 Then Return SetError(2, 0, $result[0])
        Return SetError(0, 0, $result[0])
    EndIf

    ; Make sure the input res file exists
    If Not FileExists($InpResFile) Then
        ConsoleWrite("Resource Update skipped: missing Resfile :" & $InpResFile)
        Return
    EndIf

    ; Open the Resource File
    If ($RType <> 6) Then ; not for RT_STRING
        $hFile = _WinAPI_CreateFile($InpResFile, 2, 2)
        If Not $hFile Then
            ConsoleWrite("Resource Update skipped: error opening Resfile :" & $InpResFile)
            Return
        EndIf
    EndIf

    ; Process the different Update types
    Switch $RType
        Case 2 ; *** RT_BITMAP
            $tSize = FileGetSize($InpResFile) - 14 ; file size minus the bitmap header
            $tBuffer = DllStructCreate("char Text[" & $tSize & "]") ; Create the buffer.
            $pBuffer = DllStructGetPtr($tBuffer)
            _WinAPI_SetFilePointer($hFile, 14) ; skip reading the bitmap header
            _WinAPI_ReadFile($hFile, $pBuffer, $tSize, $bread, 0)
            If $hFile Then _WinAPI_CloseHandle($hFile)
            If $bread > 0 Then
                $result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, $RName_Type, $RName, "ushort", $RLanguage, "ptr", $pBuffer, 'dword', $tSize)
                If $result[0] <> 1 Then ConsoleWrite('UpdateResources other: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
            EndIf
        Case 3 ; *** RT_ICON
            ;ICO section
            $tSize = FileGetSize($InpResFile) - 6
            Local $tB_Input_Header = DllStructCreate("short res;short type;short ImageCount;char rest[" & $tSize + 1 & "]") ; Create the buffer.
            Local $pB_Input_Header = DllStructGetPtr($tB_Input_Header)
            _WinAPI_ReadFile($hFile, $pB_Input_Header, FileGetSize($InpResFile), $bread, 0)
            If $hFile Then
                $rc = _WinAPI_CloseHandle($hFile)
            EndIf
            ; Read input file header
            Local $IconType = DllStructGetData($tB_Input_Header, "Type")
            Local $IconCount = DllStructGetData($tB_Input_Header, "ImageCount")
            ; Created IconGroup Structure
            Local $tB_IconGroupHeader = DllStructCreate("short res;short type;short ImageCount;char rest[" & $IconCount * 14 & "]") ; Create the buffer.
            Local $pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader)
            DllStructSetData($tB_IconGroupHeader, "Res", 0)
            DllStructSetData($tB_IconGroupHeader, "Type", $IconType)
            DllStructSetData($tB_IconGroupHeader, "ImageCount", $IconCount)
            ; process all internal Icons
            For $x = 1 To $IconCount
                ;MsgBox(0,$X,$IconCount)
                ; Set pointer correct in the input struct
                Local $pB_Input_IconHeader = DllStructGetPtr($tB_Input_Header, 4) + ($x - 1) * 16
                Local $tB_Input_IconHeader = DllStructCreate("byte Width;byte Heigth;Byte Colors;Byte res;Short Planes;Short BitPerPixel;dword ImageSize;dword ImageOffset", $pB_Input_IconHeader) ; Create the buffer.
                ; get info form the input
                Local $IconWidth = DllStructGetData($tB_Input_IconHeader, "Width")
;~                 If $IconWidth = 0 then $IconWidth = 256
                Local $IconHeigth = DllStructGetData($tB_Input_IconHeader, "Heigth")
;~                 If $IconHeigth = 0 then $IconHeigth = 256
                Local $IconColors = DllStructGetData($tB_Input_IconHeader, "Colors")
                Local $IconPlanes = DllStructGetData($tB_Input_IconHeader, "Planes")
                Local $IconBitPerPixel = DllStructGetData($tB_Input_IconHeader, "BitPerPixel")
                Local $IconImageSize = DllStructGetData($tB_Input_IconHeader, "ImageSize")
                Local $IconImageOffset = DllStructGetData($tB_Input_IconHeader, "ImageOffset")
                ; Update the ICO Group header struc
                $pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader, 4) + ($x - 1) * 14
                Local $tB_GroupIcon = DllStructCreate("byte Width;byte Heigth;Byte Colors;Byte res;Short Planes;Short BitPerPixel;dword ImageSize;word ResourceID", $pB_IconGroupHeader) ; Create the buffer.
                DllStructSetData($tB_GroupIcon, "Width", $IconWidth)
                DllStructSetData($tB_GroupIcon, "Heigth", $IconHeigth)
                DllStructSetData($tB_GroupIcon, "Colors", $IconColors)
                DllStructSetData($tB_GroupIcon, "res", 0)
                DllStructSetData($tB_GroupIcon, "Planes", $IconPlanes)
                DllStructSetData($tB_GroupIcon, "BitPerPixel", $IconBitPerPixel)
                DllStructSetData($tB_GroupIcon, "ImageSize", $IconImageSize)

                $IconResBase += 1
                For $m = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
                    If $ARRAY_MODULE_STRUCTURE[$m][0][0] = $RT_ICON Then
                        For $n = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                            If $IconResBase = $ARRAY_MODULE_STRUCTURE[$m][$n][0] Then
                                $IconResBase += 1
                            EndIf
                        Next
                        ExitLoop
                    EndIf
                Next

                DllStructSetData($tB_GroupIcon, "ResourceID", $IconResBase)
                ; Get data pointer
                Local $pB_IconData = DllStructGetPtr($tB_Input_Header) + $IconImageOffset
                ; add Icon

                $result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, "long", 3, "long", $IconResBase, "ushort", $RLanguage, "ptr", $pB_IconData, 'dword', $IconImageSize)
                If $result[0] <> 1 Then
                    ConsoleWrite('Icon UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
                Else
                    ConsoleWrite('Icon UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
                EndIf
            Next
            ; Add Icongroup entry
            $pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader)
            $result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, "long", 14, $RName_Type, $RName, "ushort", $RLanguage, "ptr", $pB_IconGroupHeader, 'dword', DllStructGetSize($tB_IconGroupHeader))
            If $result[0] <> 1 Then ConsoleWrite('GroupIconUpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
        Case 6 ; RT_STRING
            Local $aLangs = IniReadSectionNames($InpResFile)
            If @error Then
                ConsoleWrite("Resource Update skipped: string file did not contain valid input")
                Return
            EndIf
            ; loop each language section
            Local $aStrings, $aBlocks, $aBlock
            Local $iBlock, $iIdx, $iID, $sStr, $iBlockIdx
            Local $iElem, $sStruct, $oStruct
            For $i = 1 To $aLangs[0]
                ; aLangs[i] = current language
                $aStrings = IniReadSection($InpResFile, $aLangs[$i])
                If @error Then
                    ConsoleWrite("Resource Update skipped: language '" & $aLangs[$i] & "' is not valid")
                    ContinueLoop
                EndIf
                ; reset block array
                Dim $aBlocks[1] = [0]
                ; loop strings, create blocks and update resources
                ; string ID is as follows:
                ; ID is a WORD (16 bits)
                ; first 4 bits = string index in block, 0-15
                ; top 12 bits = block ID, starting at 1
                ; string IDX = BitAND(ID, 0xF)
                ; block ID = BitAND(BitShift(ID, 4), 0xFFF) + 1
                ;
                ; aBlocks will contain all the string blocks
                ; aBlocks[0] = count
                ; aBlocks[n] = block array
                ; aBlock[0] = block ID
                ; aBlock[1] to [16] = string
                For $j = 1 To $aStrings[0][0]
                    ; iID = string ID
                    ; sStr = string
                    ; iBlock = block ID
                    ; iIdx = string index in block
                    ; iBlockIdx = string block index in aBlocks container array
                    $iID = Number($aStrings[$j][0])
                    $sStr = $aStrings[$j][1]
                    $iBlock = BitAND(BitShift($iID, 4), 0xFFF) + 1
                    $iIdx = BitAND($iID, 0xF)
                    ; check if we created the block that contains the string, if not, initialize it
                    $iBlockIdx = _GetBlockIDIdx($aBlocks, $iBlock)
                    If $iBlockIdx = -1 Then
                        ; initialize the block and resize aBlocks array
                        Dim $aBlock[17] = [$iBlock]
                        $aBlocks[0] += 1
                        ReDim $aBlocks[$aBlocks[0] + 1]
                        $iBlockIdx = $aBlocks[0]
                    Else
                        $aBlock = $aBlocks[$iBlockIdx]
                    EndIf
                    ; we have the string block, set new string in block
                    $aBlock[$iIdx + 1] = $sStr
                    ; set the updated array into aBlocks container
                    $aBlocks[$iBlockIdx] = $aBlock
                Next
                ; all string blocks for this language have been created, update the resource
                ; create the data structure <word;text;word...>
                ; empty strings have length 0
                For $j = 1 To $aBlocks[0]
                    ; get each block
                    $aBlock = $aBlocks[$j]
                    ; we have to loop each block twice, once to create the structure, then once to fill it
                    ; reset structure
                    $sStruct = ""
                    For $k = 1 To 16
                        $sStruct &= "word;"
                        If ($aBlock[$k] <> "") Then
                            ; there is a string
                            $sStruct &= "wchar[" & StringLen($aBlock[$k]) & "];"
                        EndIf
                    Next
                    ; create the structure
                    $oStruct = DllStructCreate($sStruct)
                    ; reset element counter
                    $iElem = 1
                    For $k = 1 To 16
                        If ($aBlock[$k] <> "") Then
                            ; there is a string
                            ; set count
                            DllStructSetData($oStruct, $iElem, StringLen($aBlock[$k]))
                            ; set string
                            DllStructSetData($oStruct, $iElem + 1, $aBlock[$k])
                            ; increment counter
                            $iElem += 2
                        Else
                            ; no string, set count to 0 and increment counter
                            DllStructSetData($oStruct, $iElem, 0)
                            $iElem += 1
                        EndIf
                    Next
                    ; the block structure is created, update the resource
                    ; aLangs[i] is the language, aBlock[0] is the block ID
                    $tSize = DllStructGetSize($oStruct)
                    $pBuffer = DllStructGetPtr($oStruct)
                    $result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, "long", $aBlock[0], "ushort", $aLangs[$i], "ptr", $pBuffer, 'dword', $tSize)
                    If $result[0] <> 1 Then ConsoleWrite('String UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
                Next
            Next
        Case Else ; 10, 16, 24 *** RT_RCDATA, RT_VERSION and RT_MANIFEST *** and Other
            $tSize = FileGetSize($InpResFile)
            $tBuffer = DllStructCreate("char Text[" & $tSize & "]") ; Create the buffer.
            $pBuffer = DllStructGetPtr($tBuffer)
            _WinAPI_ReadFile($hFile, $pBuffer, $tSize, $bread, 0)
            If $hFile Then _WinAPI_CloseHandle($hFile)
            If $bread > 0 Then
                $result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, $RName_Type, $RName, "ushort", $RLanguage, "ptr", $pBuffer, 'dword', $tSize)
                If $result[0] <> 1 Then ConsoleWrite('UpdateResources other: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
            EndIf
    EndSwitch
    $result = DllCall("kernel32.dll", "int", "EndUpdateResourceW", "ptr", $rh, "int", 0)
    If $result[0] <> 1 Then Return SetError(3, 0, $result[0])
    Return SetError(0, 0, True)
EndFunc   ;==>_Res_Update

Func _GetBlockIDIdx(ByRef $aBlocks, $iBlock)
    Local $aBlock
    For $i = 1 To $aBlocks[0]
        $aBlock = $aBlocks[$i]
        If $aBlock[0] = $iBlock Then
            ; found the block
            Return $i
        EndIf
    Next
    Return -1
EndFunc   ;==>_GetBlockIDIdx
