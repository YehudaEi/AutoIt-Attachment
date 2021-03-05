#include <ListviewConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <winapi.au3>
#include <Array.au3>

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

Global $Script
Global $aListViewItem[1]

Global $GUIMINWID = 472; Resizing / minimum width
Global $GUIMINHT = 222; Resizing / minimum hight
Global Const $WS_RESIZABLE = 0x00070000

#region ### START Koda GUI section ### Form=
AutoItSetOption("GUIOnEventMode", 1)
AutoItSetOption("GUIResizeMode", 1)

$Form1 = GUICreate("Icon Resource Editor - powered by Trancexx", $GUIMINWID, $GUIMINHT, -1, -1, BitOR($WS_RESIZABLE, $WS_CAPTION, $WS_POPUP), $WS_EX_ACCEPTFILES)
GUISetOnEvent(-3, "Terminate")

$Input1 = GUICtrlCreateInput("", 8, 8, 422, 21)
GUICtrlSetResizing(-1, 512 + 32 + 4 + 2)

$Button1 = GUICtrlCreateButton("...", 438, 8, 27, 21)
GUICtrlSetResizing(-1, 768 + 32)
GUICtrlSetOnEvent(-1, "SelectFile")

Global $ListView1 = GUICtrlCreateListView("", 8, 32, 457, 153)
GUICtrlSetResizing(-1, 102)
$Button2 = GUICtrlCreateButton("Replace", 296, 192, 75, 25)
GUICtrlSetResizing(-1, 768 + 64 + 4)
GUICtrlSetOnEvent(-1, "Replace")

$Button3 = GUICtrlCreateButton("Delete", 392, 192, 75, 25)
GUICtrlSetResizing(-1, 768 + 64 + 4)
GUICtrlSetOnEvent(-1, "Delete")

$Button4 = GUICtrlCreateButton("Add", 216, 192, 75, 25)
GUICtrlSetResizing(-1, 768 + 64 + 4)
GUICtrlSetOnEvent(-1, "Add")

GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
GUIRegisterMsg ($WM_DROPFILES, "WM_DROPFILES_FUNC")

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

Sleep(999999999)

Func Delete()
    $Str = GUICtrlRead(GUICtrlRead($ListView1))
    $Str = StringRegExp($Str, "\|(.*?)\|", 3)
    If @error Then
        MsgBox(16, "Error!", "Select an item...")
        Return
    EndIf
    $Str = $Str[0]
    If $Str <> "" Then
        $File = GUICtrlRead($Input1)
        If @error Then Return
        READEOF($File)
        _ResRep($File, $Str, 0, 1)
    EndIf
EndFunc   ;==>Delete

Func Add()
    AutoItSetOption("GUIOnEventMode", 0)
    $Form2 = GUICreate("Form1", 82, 116, 321, 257, -1, -1, $Form1)
    $Type = GUICtrlCreateInput("Type", 8, 8, 65, 21)
    $Name = GUICtrlCreateInput("Name", 8, 32, 65, 21)
    $Lang = GUICtrlCreateInput("Lang", 8, 56, 65, 21)
    $AddTheResFile = GUICtrlCreateButton("Add", 8, 80, 65, 21)
    GUISetState(@SW_SHOW, $Form2)
    While 1
        $nMsg = GUIGetMsg($Form2)
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
                $File2 = GUICtrlRead($Input1)
                If Not FileExists($File2) Then
                    MsgBox(0, "Error!", "No file selected.")
                    ExitLoop
                EndIf
                READEOF($File2)
                _ResUpdate($File2, $RT, $OR, Number($LN), $File)
                ExitLoop
        EndSwitch
    WEnd
    AutoItSetOption("GUIOnEventMode", 1)
    GUIDelete($Form2)
EndFunc   ;==>Add

Func SelectFile()
    $var = FileOpenDialog("Select File", @DesktopDir & "\", "exe FILE (*.exe)", 1, "")
    If @error Then Return
    GUICtrlSetData($Input1, $var)
    _ResEnum($var)
EndFunc   ;==>SelectFile

Func Replace()
    $var = FileOpenDialog("Select Icon File", @DesktopDir & "\", "ico FILE (*.ico)", 1, "")
    If @error Then Return
    $Str = GUICtrlRead(GUICtrlRead($ListView1))
    $Str = StringRegExp($Str, "\|(.*?)\|", 3)
    If @error Then
        MsgBox(16, "Error!", "Select an item...")
        Return
    EndIf
    $Str = $Str[0]
    If $Str <> "" Then
        If StringInStr($Str, "|") Then $Str = StringReplace($Str, "|", "")
        $File = GUICtrlRead($Input1)
        If @error Then Return
        READEOF($File)
        _ResRep($File, $Str, $var)
    EndIf
EndFunc   ;==>Replace


Func _ResDelete($sModule, $iResType, $iResName, $iResLang, $lParam = 0)

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
            Local $bBinGroupIcon = _ResourceGetAsRaw($iResType, $iResName, $iResLang, $sModule, 1)
            Local $tGroupIcon = DllStructCreate("byte[" & BinaryLen($bBinGroupIcon) & "]")
            DllStructSetData($tGroupIcon, 1, $bBinGroupIcon)

            Local $tEnumGroupIcon = DllStructCreate("ushort;" & _
                    "ushort Type;" & _
                    "ushort ResCount;" & _
                    "byte Body[" & BinaryLen($bBinGroupIcon) - 6 & "]", _
                    DllStructGetPtr($tGroupIcon))

        Case $RT_GROUP_CURSOR
            Local $bBinGroupCursor = _ResourceGetAsRaw($iResType, $iResName, $iResLang, $sModule, 1)

        Case $RT_ICON
            If Not $lParam Then ; currently not available, will return
                Return SetError(0, 0, 1) ;  <------'
                For $m = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
                    If $ARRAY_MODULE_STRUCTURE[$m][0][0] = $RT_GROUP_ICON Then
                        Local $bBinGroupIcon, $iResCount
                        Local $tGroupIcon
                        Local $tHeaderGroupIcon
                        For $n = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                            $bBinGroupIcon = _ResourceGetAsRaw($RT_GROUP_ICON, $ARRAY_MODULE_STRUCTURE[$m][$n][0], $iResLang, $sModule, 1)
                            $tGroupIcon = DllStructCreate("byte[" & BinaryLen($bBinGroupIcon) & "]")
                            DllStructSetData($tGroupIcon, 1, $bBinGroupIcon)
                            $tHeaderGroupIcon = DllStructCreate("ushort;" & _
                                    "ushort Type;" & _
                                    "ushort ResCount;" & _
                                    "byte Body[" & BinaryLen($bBinGroupIcon) - 6 & "]", _
                                    DllStructGetPtr($tGroupIcon))

                            $iResCount = DllStructGetData($tHeaderGroupIcon, "ResCount")

                            If $iResCount < 2 Then
                                _ResDelete($sModule, $RT_GROUP_ICON, $ARRAY_MODULE_STRUCTURE[$m][$n][0], $iResLang)
                                If @error Then
                                    Return SetError(@error, 0, "")
                                EndIf
                                Return SetError(0, 0, 1)
                            EndIf
                        Next
                    EndIf
                Next
            EndIf

        Case $RT_CURSOR
            If Not $lParam Then
                For $m = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
                    If $ARRAY_MODULE_STRUCTURE[$m][0][0] = $RT_GROUP_CURSOR Then
                        Local $bGroupCursor

                        For $n = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                            $bGroupCursor = _ResourceGetAsRaw($RT_GROUP_CURSOR, $ARRAY_MODULE_STRUCTURE[$m][$n][0], $iResLang, $sModule, 1)

                            If $iResName = _LittleEndianBinaryToInt(BinaryMid($bGroupCursor, 19, 2)) Then
                                _ResDelete($sModule, $RT_GROUP_CURSOR, $ARRAY_MODULE_STRUCTURE[$m][$n][0], $iResLang)
                                If @error Then
                                    Return SetError(@error, 0, "")
                                EndIf
                            EndIf

                        Next

                    EndIf
                Next
                Return SetError(0, 0, 1)
            EndIf

    EndSwitch

    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

    If @error Or Not $a_hCall[0] Then
        Return SetError(1, 0, "")
    EndIf

    Local $a_iCall
    Switch IsNumber($iResType) + 2 * IsNumber($iResName)
        Case 0
            Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                    "hwnd", $a_hCall[0], _
                    "wstr", $iResType, _
                    "wstr", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
        Case 1
            Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                    "hwnd", $a_hCall[0], _
                    "int", $iResType, _
                    "wstr", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
        Case 2
            Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                    "hwnd", $a_hCall[0], _
                    "wstr", $iResType, _
                    "int", $iResName, _
                    "int", $iResLang, _
                    "ptr", 0, _
                    "dword", 0)
        Case 3
            Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
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

    Switch $iResType
        Case $RT_GROUP_ICON
            Local $iIconName
            For $i = 1 To DllStructGetData($tEnumGroupIcon, "ResCount")
                $iIconName = _LittleEndianBinaryToInt(BinaryMid(DllStructGetData($tEnumGroupIcon, "Body"), (14 * $i) - 1, 2))
                If $iIconName Then
                    _ResDelete($sModule, $RT_ICON, $iIconName, $iResLang, 1)
                EndIf
            Next
        Case $RT_GROUP_CURSOR
            _ResDelete($sModule, $RT_CURSOR, _LittleEndianBinaryToInt(BinaryMid($bBinGroupCursor, 19, 2)), $iResLang, 1)
            If @error Then
                Return SetError(@error, 0, "")
            EndIf
    EndSwitch

    Return SetError(0, 0, 1)

EndFunc   ;==>_ResDelete

Func _LittleEndianBinaryToInt($bBinary)

    Local $hex
    $bBinary = Binary($bBinary)
    Local $iBinaryLen = BinaryLen($bBinary)

    For $i = 1 To $iBinaryLen
        $hex &= Hex(BinaryMid($bBinary, $iBinaryLen + 1 - $i, 1))
    Next

    Return SetError(0, 0, Dec($hex))

EndFunc   ;==>_LittleEndianBinaryToInt

Func _ResUpdate($sModule, $iResType, $iResName, $iResLang, $sResFile, $lParam = 0)

    If Not FileExists($sModule) Then
        Return SetError(100, 0, "") ; what happened???
    EndIf

    Local $hFile = FileOpen($sModule, 1)
    If $hFile = -1 Then
        Return SetError(101, 0, "") ; cannot obtain writing rights
    EndIf

    FileClose($hFile)

    Switch $iResType

        Case $RT_GROUP_CURSOR

            Local $tBinary = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            Local $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tBinary, 1, FileRead($hResFile))
            FileClose($hResFile)

            If @error Then
                Return SetError(5, 0, "")
            EndIf

            Local $tResource = DllStructCreate("align 2;ushort;" & _
                    "ushort Type;" & _
                    "ushort ImageCount;" & _
                    "ubyte Width;" & _
                    "ubyte Height;" & _
                    "ubyte ColorCount;" & _
                    "byte;" & _
                    "ushort Xhotspot;" & _
                    "ushort Yhotspot;" & _
                    "dword BitmapSize;" & _
                    "dword BitmapOffset;" & _
                    "byte Body[" & DllStructGetSize($tBinary) - 22 & "]", _
                    DllStructGetPtr($tBinary))

            Local $tBitmap = DllStructCreate("dword HeaderSize", DllStructGetPtr($tResource, "Body"))

            Local $iHeaderSize = DllStructGetData($tBitmap, "HeaderSize")

            Switch $iHeaderSize
                Case 40
                    $tBitmap = DllStructCreate("dword HeaderSize;" & _
                            "dword Width;" & _
                            "dword Height;" & _
                            "ushort Planes;" & _
                            "ushort BitPerPixel;" & _
                            "dword CompressionMethod;" & _
                            "dword Size;" & _
                            "dword Hresolution;" & _
                            "dword Vresolution;" & _
                            "dword Colors;" & _
                            "dword ImportantColors;", _
                            DllStructGetPtr($tResource, "Body"))
                Case 12
                    $tBitmap = DllStructCreate("dword HeaderSize;" & _
                            "ushort Width;" & _
                            "ushort Height;" & _
                            "ushort Planes;" & _
                            "ushort BitPerPixel;", _
                            DllStructGetPtr($tResource, "Body"))
                Case Else
                    Return SetError(6, 0, "")
            EndSwitch

            Local $tCursorWrite = DllStructCreate("ushort Xhotspot;" & _
                    "ushort Yhotspot;" & _
                    "byte Body[" & DllStructGetSize($tResource) - 22 & "]", _
                    DllStructGetPtr($tResource) + DllStructGetData($tResource, "BitmapOffset") - 4)

            DllStructSetData($tCursorWrite, "Xhotspot", DllStructGetData($tResource, "Xhotspot"))
            DllStructSetData($tCursorWrite, "Yhotspot", DllStructGetData($tResource, "Xhotspot"))

            Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(7, 0, "")
            EndIf

            Local $iCurName = 1
            For $m = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
                If $ARRAY_MODULE_STRUCTURE[$m][0][0] = $RT_CURSOR Then
                    For $n = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                        If $iCurName = $ARRAY_MODULE_STRUCTURE[$m][$n][0] Then
                            $iCurName += 1
                        EndIf
                    Next
                    ExitLoop
                EndIf
            Next

            Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                    "hwnd", $a_hCall[0], _
                    "int", $RT_CURSOR, _
                    "int", $iCurName, _
                    "int", $iResLang, _
                    "ptr", DllStructGetPtr($tCursorWrite), _
                    "dword", DllStructGetSize($tCursorWrite))

            If @error Or Not $a_iCall[0] Then
                DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                Return SetError(8, 0, "")
            EndIf

            Local $tCursorGroupWrite = DllStructCreate("ushort;" & _
                    "ushort Type;" & _
                    "ushort ImageCount;" & _
                    "ushort Width;" & _
                    "ushort Height;" & _
                    "ushort Planes;" & _
                    "ushort BitPerPixel;" & _
                    "ushort;" & _
                    "ushort;" & _
                    "ushort OrdinalName")

            DllStructSetData($tCursorGroupWrite, 1, DllStructGetData($tResource, 1))
            DllStructSetData($tCursorGroupWrite, "Type", DllStructGetData($tResource, "Type"))
            DllStructSetData($tCursorGroupWrite, "ImageCount", DllStructGetData($tResource, "ImageCount"))

            DllStructSetData($tCursorGroupWrite, "Width", DllStructGetData($tBitmap, "Width"))
            DllStructSetData($tCursorGroupWrite, "Height", DllStructGetData($tBitmap, "Height"))

            DllStructSetData($tCursorGroupWrite, "Planes", DllStructGetData($tBitmap, "Planes"))
            DllStructSetData($tCursorGroupWrite, "BitPerPixel", DllStructGetData($tBitmap, "BitPerPixel"))

            DllStructSetData($tCursorGroupWrite, 8, 308)

            DllStructSetData($tCursorGroupWrite, "OrdinalName", $iCurName)

            Switch IsNumber($iResName)
                Case True
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $RT_GROUP_CURSOR, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tCursorGroupWrite), _
                            "dword", DllStructGetSize($tCursorGroupWrite))
                Case Else
                    $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "int", $RT_GROUP_CURSOR, _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tCursorGroupWrite), _
                            "dword", DllStructGetSize($tCursorGroupWrite))
            EndSwitch

            If @error Or Not $a_iCall[0] Then
                DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
                Return SetError(9, 0, "")
            EndIf

            $a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

            If @error Or Not $a_iCall[0] Then
                Return SetError(10, 0, "")
            EndIf


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

            For $i = 1 To $iIconCount

                $tInputIconHeader = DllStructCreate("ubyte Width;" & _
                        "ubyte Height;" & _
                        "ubyte Colors;" & _
                        "ubyte;" & _
                        "ushort Planes;" & _
                        "ushort BitPerPixel;" & _
                        "dword BitmapSize;" & _
                        "dword BitmapOffset", _
                        DllStructGetPtr($tResource, "Body") + ($i - 1) * 16)

                $tGroupIconData = DllStructCreate("ubyte Width;" & _
                        "ubyte Height;" & _
                        "ubyte Colors;" & _
                        "ubyte;" & _
                        "ushort Planes;" & _
                        "ushort BitPerPixel;" & _
                        "dword BitmapSize;" & _
                        "ushort OrdinalName;", _
                        DllStructGetPtr($tIconGroupHeader, "Body") + ($i - 1) * 14)

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

            Local $tResource = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            Local $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tResource, 1, FileRead($hResFile))
            FileClose($hResFile)

            If @error Then
                Return SetError(5, 0, "")
            EndIf

            Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Switch IsNumber($iResName)
                Case True
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case Else
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
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

            Local $tBinary = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            Local $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tBinary, 1, FileRead($hResFile))
            FileClose($hResFile)

            Local $tResource = DllStructCreate("align 2;char Identifier[2];" & _
                    "dword BitmapSize;" & _
                    "short;" & _
                    "short;" & _
                    "dword BitmapOffset;" & _
                    "byte Body[" & DllStructGetSize($tBinary) - 14 & "]", _
                    DllStructGetPtr($tBinary))

            If Not (DllStructGetData($tResource, 1) == "BM") Then
                Return SetError(5, 0, "")
            EndIf

            Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Switch IsNumber($iResName)
                Case True
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource, "Body"), _
                            "dword", FileGetSize($sResFile) - 14)
                Case Else
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
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

            Local $tResource = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
            Local $hResFile = FileOpen($sResFile, 16)
            DllStructSetData($tResource, 1, FileRead($hResFile))
            FileClose($hResFile)

            If @error Then
                Return SetError(5, 0, "")
            EndIf

            Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

            If @error Or Not $a_hCall[0] Then
                Return SetError(6, 0, "")
            EndIf

            Switch IsNumber($iResType) + 2 * IsNumber($iResName)
                Case 0
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "wstr", StringUpper($iResType), _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case 1
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "int", $iResType, _
                            "wstr", StringUpper($iResName), _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case 2
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
                            "hwnd", $a_hCall[0], _
                            "wstr", StringUpper($iResType), _
                            "int", $iResName, _
                            "int", $iResLang, _
                            "ptr", DllStructGetPtr($tResource), _
                            "dword", FileGetSize($sResFile))
                Case 3
                    Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
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

    Local $a_iCall = DllCall("kernel32.dll", "int", "SizeofResource", "hwnd", $hModule, "hwnd", $hResource)

    If @error Or Not $a_iCall[0] Then
        If $iLoaded Then
            Local $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
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
            Local $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
            If @error Or Not $a_iCall[0] Then
                Return SetError(7, 0, "")
            EndIf
        EndIf
        Return SetError(5, 0, "")
    EndIf

    Local $a_pCall = DllCall("kernel32.dll", "ptr", "LockResource", "hwnd", $a_hCall[0])

    If @error Or Not $a_pCall[0] Then
        If $iLoaded Then
            Local $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
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
        Local $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
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

#region - Find Icon -

Func _ResRep($Host, $Name, $Res, $doWhat = 0)
    If Not _ResInfo($Host) Then Return 0
    For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
        If $ARRAY_MODULE_STRUCTURE[$f][0][0] = 14 Then; we only want acces to GROUPICON resources
            For $g = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                If $ARRAY_MODULE_STRUCTURE[$f][$g][0] == $Name Then
                    Switch $doWhat
                        Case 0
                            If StringIsDigit($ARRAY_MODULE_STRUCTURE[$f][$g][0]) Then
                                _ResDelete($Host, 14, Int($Name), $ARRAY_MODULE_STRUCTURE[$f][$g][1])
                                If @error Then
                                    _ResDelete($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][1])
                                Else
                                    $Name = Int($Name)
                                EndIf
                            Else
                                _ResDelete($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][1])
                            EndIf
                            If @error Then
                                MsgBox(16, "Error", "Could not replace icon.")
                                Return 0
                            EndIf
                            _ResUpdate($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][1], $Res)
                        Case 1
                            If StringIsDigit($ARRAY_MODULE_STRUCTURE[$f][$g][0]) Then
                                _ResDelete($Host, 14, Int($Name), $ARRAY_MODULE_STRUCTURE[$f][$g][1])
                                If @error Then
                                    _ResDelete($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][1])
                                Else
                                    $Name = Int($Name)
                                EndIf
                            Else
                                _ResDelete($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][1])
                            EndIf
                    EndSwitch
                EndIf
            Next
        EndIf
    Next
    _ResEnum($Host)
    Return 1
EndFunc   ;==>_ResRep

Func _ResEnum($Host)

    Local $aListViewPos = ControlGetPos($Form1, 0, $ListView1)
    If @error Then
        Return SetError(1, 0, 0)
    EndIf

    GUICtrlDelete($ListView1) ; the easiest way to stop leak
    $ListView1 = 0
    $ListView1 = GUICtrlCreateListView("Icons|name", $aListViewPos[0], $aListViewPos[1], $aListViewPos[2], $aListViewPos[3])

    GUICtrlSetFont($ListView1, 8)
    GUICtrlSetColor($ListView1, 0x0000C0)
    GUICtrlSetResizing($ListView1, 70)

    GUICtrlSetStyle($ListView1, 256) ; LVS_ICON|LVS_AUTOARRANGE
    GUICtrlSetState($ListView1, 32)

    Local $aClientSize = WinGetClientSize($Form1)
    If Not _ResInfo($Host) Then Return 0
    For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
        If $ARRAY_MODULE_STRUCTURE[$f][0][0] = 14 Then ; we only want acces to GROUPICON resources
            For $g = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
                If $ARRAY_MODULE_STRUCTURE[$f][$g][0] Then
                    For $h = 1 To UBound($ARRAY_MODULE_STRUCTURE, 3) - 1
                        ;MsgBox(0,"",$ARRAY_MODULE_STRUCTURE[$f][$g][0])
                        ;GUICtrlCreateListViewItem($ARRAY_MODULE_STRUCTURE[$f][$g][0], $CTRL)
                        ;GUICtrlSetImage(-1, $Host, $ARRAY_MODULE_STRUCTURE[$f][$g][0], 0)
                        Local $aIconData = _CrackIcon($ARRAY_MODULE_STRUCTURE[$f][$g][0], $ARRAY_MODULE_STRUCTURE[$f][$g][1], $Host)
                        If @error Then
                            Return SetError(2, 0, "")
                        EndIf
                        If Not IsArray($aIconData) Then
                            Return SetError(0, 1, "")
                        EndIf

                        Local $iWidth
                        Local $iHeight
                        For $i = 0 To UBound($aIconData) - 1
                            $iWidth = $aIconData[$i][0]
                            $iHeight = $aIconData[$i][1]
                            If $iWidth Then
                                ExitLoop
                            EndIf
                        Next




                        ReDim $aListViewItem[UBound($aIconData)]

                        Local $bBinary
                        Local $tBinary
                        Local $tIcon, $iPNGIcon
                        Local $sTempFile = @DesktopDir & "\" & _GenerateGUID() & ".ico"
                        If @error Then
                            Return SetError(3, 0, "")
                        EndIf
                        Local $hTempFile
                        Local $iBitmapSize

                        For $i = 0 To UBound($aIconData) - 1

                            $bBinary = _ResourceGetAsRaw($RT_ICON, $aIconData[$i][6], $ARRAY_MODULE_STRUCTURE[$f][$g][1], $Host, 1)
                            If @error Then
                                ContinueLoop
                            EndIf

                            $iBitmapSize = BinaryLen($bBinary)
                            $tBinary = DllStructCreate("byte[" & $iBitmapSize & "]")
                            DllStructSetData($tBinary, 1, $bBinary)

                            $tIcon = DllStructCreate("align 2;ushort;" & _
                                    "ushort Type;" & _
                                    "ushort ImageCount;" & _
                                    "ubyte Width;" & _
                                    "ubyte Height;" & _
                                    "ubyte Colors;" & _
                                    "ubyte;" & _
                                    "ushort Planes;" & _
                                    "ushort BitPerPixel;" & _
                                    "dword BitmapSize;" & _
                                    "dword BitmapOffset;" & _
                                    "byte Body[" & $iBitmapSize & "]")

                            DllStructSetData($tIcon, "Type", 1)
                            DllStructSetData($tIcon, "ImageCount", 1)
                            DllStructSetData($tIcon, "Width", $aIconData[$i][0])
                            DllStructSetData($tIcon, "Height", $aIconData[$i][1])
                            DllStructSetData($tIcon, "Colors", $aIconData[$i][2])
                            DllStructSetData($tIcon, "Planes", $aIconData[$i][3])
                            DllStructSetData($tIcon, "BitPerPixel", $aIconData[$i][4])
                            DllStructSetData($tIcon, "BitmapSize", $iBitmapSize) ; $aIconData[$i][5])
                            DllStructSetData($tIcon, "BitmapOffset", 22)
                            DllStructSetData($tIcon, "Body", DllStructGetData($tBinary, 1))

                            $tBinary = DllStructCreate("byte[" & DllStructGetSize($tIcon) & "]", DllStructGetPtr($tIcon))

                            $hTempFile = FileOpen($sTempFile, 26)
                            FileWrite($hTempFile, DllStructGetData($tBinary, 1))
                            FileClose($hTempFile)

                            If $aIconData[$i][6] Then
                                If Not $aIconData[$i][2] Then
                                    $aIconData[$i][2] = ">256"
                                EndIf
                                If Not $aIconData[$i][0] Then
                                    $aIconData[$i][0] = 256
                                EndIf
                                If Not $aIconData[$i][1] Then
                                    $aIconData[$i][1] = 256
                                EndIf
                            EndIf

                            $aListViewItem[$i] = GUICtrlCreateListViewItem("Width: " & $aIconData[$i][0] & @LF & _
                                    "Height: " & $aIconData[$i][1] & @LF & _
                                    "Colors: " & $aIconData[$i][2] & @LF & _
                                    "Planes: " & $aIconData[$i][3] & @LF & _
                                    "BitPerPixel: " & $aIconData[$i][4] & @LF & _
                                    "ImageSize: " & $aIconData[$i][5] & " bytes" & @LF & _
                                    "RTIcon name: " & $aIconData[$i][6] & "|" & $ARRAY_MODULE_STRUCTURE[$f][$g][0], _
                                    $ListView1)

                            If Not GUICtrlSetImage($aListViewItem[$i], $sTempFile, -1) Then
                                $iPNGIcon += 1
                            EndIf
                        Next

                        FileDelete($sTempFile)

                        GUICtrlSetState($ListView1, 16)

                        ;Return SetError(0, 0, 1)

                    Next
                EndIf
            Next
        EndIf
    Next
    Return 1
EndFunc   ;==>_ResEnum

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

Func _CallbackEnumResTypeProc($hModule, $pType, $lParam)
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
            "ptr", $lParam, _
            "ptr", DllCallbackGetPtr($h_CB))
    DllCallbackFree($h_CB)
    Return 1
EndFunc   ;==>_CallbackEnumResTypeProc

Func _CallbackEnumResLangProc($hModule, $pType, $pName, $iLang, $lParam)
    $lang_count += 1
    If $lang_count > $global_langs_count - 1 Then
        $global_langs_count += 1
    EndIf
    If $iPopulateArray Then
        $ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$lParam][$lang_count] = $iLang
    EndIf
    Return 1
EndFunc   ;==>_CallbackEnumResLangProc

Func _CallbackEnumResNameProc($hModule, $pType, $pName, $lParam)
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
            "ptr", $lParam, _
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

Func _GenerateGUID()

    Local $GUIDSTRUCT = DllStructCreate("int;short;short;byte[8]")

    Local $a_iCall = DllCall("rpcrt4.dll", "int", "UuidCreate", "ptr", DllStructGetPtr($GUIDSTRUCT))

    If @error Or $a_iCall[0] Then
        Return SetError(1, 0, "")
    EndIf

    $a_iCall = DllCall("ole32.dll", "int", "StringFromGUID2", _
            "ptr", DllStructGetPtr($GUIDSTRUCT), _
            "wstr", "", _
            "int", 40)

    If @error Or Not $a_iCall[0] Then
        Return SetError(2, 0, "")
    EndIf

    Return SetError(0, 0, $a_iCall[2])

EndFunc   ;==>_GenerateGUID

Func _CrackIcon($iIconName, $iResLang, $sModule, $doWhat = 0)

    Local $bBinary = _ResourceGetAsRaw($RT_GROUP_ICON, $iIconName, $iResLang, $sModule, 1)

    If @error Then
        Return SetError(@error + 3, 0, "")
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

    For $i = 0 To $iIconCount - 1
        $tGroupIconData = DllStructCreate("ubyte Width;" & _
                "ubyte Height;" & _
                "ubyte Colors;" & _
                "ubyte;" & _
                "ushort Planes;" & _
                "ushort BitPerPixel;" & _
                "dword BitmapSize;" & _
                "ushort OrdinalName;", _
                DllStructGetPtr($tResource, "Body") + $i * 14)

        $iWidth = DllStructGetData($tGroupIconData, "Width")
        If Not $iWidth Then
            $iWidth = 256
        EndIf

        $iHeight = DllStructGetData($tGroupIconData, "Height")
        If Not $iHeight Then
            $iHeight = 256
        EndIf

        $aIconsData[$i][0] = $iWidth
        $aIconsData[$i][1] = $iHeight
        $aIconsData[$i][2] = DllStructGetData($tGroupIconData, "Colors")
        $aIconsData[$i][3] = DllStructGetData($tGroupIconData, "Planes")
        $aIconsData[$i][4] = DllStructGetData($tGroupIconData, "BitPerPixel")
        $aIconsData[$i][5] = DllStructGetData($tGroupIconData, "BitmapSize")
        $aIconsData[$i][6] = DllStructGetData($tGroupIconData, "OrdinalName")
        If $doWhat Then
        EndIf
    Next

    Return SetError(0, 0, $aIconsData)

EndFunc   ;==>_CrackIcon

#endregion - Find Icon -

Func READEOF($sModule)
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
    For $i = 1 To $iNumberOfSections
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
        If $i = $iNumberOfSections Then
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

            If Not StringIsDigit($Result) Then
                $Tempname = @TempDir & "\SCRIPT_DATUM.bin"
                $Num = 0
                If FileExists($Tempname) Then
                    While FileExists($Tempname)
                        $Tempname = @TempDir & "\SCRIPT_DATUM(" & $Num & ").bin"
                        $Num += 1
                    WEnd
                EndIf
                $Htmp = FileOpen($Tempname, 2)
                FileWrite($Htmp, $Result)
                FileClose($Htmp)
                _ResUpdate($sModule, 10, "SCRIPT_DATUM", 0, $Tempname);Add as resource so nothing is lost
                FileDelete($Tempname)
            EndIf
        EndIf

        $pPointer += 40

    Next

EndFunc   ;==>READEOF

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
    Local $nSize, $pFileName, $aDropFiles[1]
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    $nAmt = $nAmt[0] - 1
    If $nAmt > 0 Then Return MsgBox(64,"Advisory!","Only one file at a time!")
    $nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0, "ptr", 0, "int", 0)
    $nSize = $nSize[0] + 1
    $pFileName = DllStructCreate("char[" & $nSize & "]")
    DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
    Local $sTarget = DllStructGetData($pFileName, 1)
    If StringRight($sTarget,4) == ".lnk" Then
        $aInfo = FileGetShortcut($sTarget)
        If Not @error Then
            $sTarget = $aInfo[0]
        EndIf
    EndIf
    GUICtrlSetData($Input1, $sTarget)
    $pFileName = 0
    _ResEnum(GUICtrlRead($Input1))
EndFunc

Func WM_GETMINMAXINFO($hWnd, $iMsg, $WPARAM, $lParam)
    #forceref $hwnd, $iMsg, $WPARAM
    Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
    DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
    DllStructSetData($tagMaxinfo, 8, $GUIMINHT + 15) ; min Y
    DllStructSetData($tagMaxinfo, 9, 99999) ; max X
    DllStructSetData($tagMaxinfo, 10, 99999) ; max Y
    Return 'GUI_RUNDEFMSG'
EndFunc   ;==>WM_GETMINMAXINFO

Func Terminate()
    Exit
EndFunc   ;==>Terminate