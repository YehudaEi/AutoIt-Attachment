#include <GUIConstants.au3>

Global $MyAccelTable

Global $FVIRTKEY = 0x1
Global $FNOINVERT = 0x2
Global $FSHIFT = 0x4
Global $FCONTROL = 0x8
Global $FALT = 0x10

$hGUI = GUICreate("GUI", 426, 205, -1, -1)
$hButton = GUICtrlCreateButton("Button", 170, 112, 75, 25)
$hFile = GUICtrlCreateMenu("File")
$hFileOpen = GUICtrlCreateMenuItem("Open File"&@TAB&"Ctrl+O", $hFile)
_GUICtrlSetAccelerator($MyAccelTable, $hFileOpen, "^o")
GUICtrlCreateMenuItem("", $hFile)
$hExit = GUICtrlCreateMenuItem("Exit"&@TAB&"Alt+X", $hFile)
_GUICtrlSetAccelerator($MyAccelTable, $hExit, "!X")
GUISetState(@SW_SHOW)

_GUIAcceleratorTableInit($MyAccelTable)

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND_FUNC")

GUISetState(@SW_SHOW)

While 1
    _GUIAcceleratorProcessMsg($hGUI, $MyAccelTable)
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $hFileOpen
            FileOpenDialog( "Bla", "", "All (*.*)")
        Case $hExit
            _GUIAcceleratorTableFree($MyAccelTable)
            Exit
        Case $hButton
            MsgBox (0, "Button", "Ok")
    EndSwitch
WEnd

Func WM_COMMAND_FUNC($hWnd, $Msg, $wParam, $lParam)
    If BitAND($wParam, 0xF0000) = 0x10000 Then
        ; Autoit not support WM_COMMAND sent with "accelerator" flag
        ; so remove it and post message again with the same control id
        $wParam = BitAND($wParam, BitNOT(0x10000))
        DllCall("user32.dll", "int", "PostMessage", "hwnd",   $hWnd, _
                                                    "int",    $WM_COMMAND, _
                                                    "wparam", $wParam, _
                                                    "lparam", $lParam)
        Return 0
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

Func _GUIAcceleratorProcessMsg($hWnd, $pAccel)
    Local $hDll = DllOpen("user32.dll")
    Local $MSG = DllStructCreate("hwnd;uint;int;int;dword;int;int")
    DllCall($hDll, "int", "GetMessage", "ptr", DllStructGetPtr($MSG), "hwnd", $hWnd, "uint", 0, "uint", 0)
    $ret = DllCall($hDll, "int", "TranslateAccelerator", "hwnd", $hWnd, "ptr", $pAccel, "ptr", DllStructGetPtr($MSG))
    If not $ret[0] Then
        DllCall($hDll, "int", "TranslateMessage", "ptr", DllStructGetPtr($MSG))
        DllCall($hDll, "int", "DispatchMessage", "ptr", DllStructGetPtr($MSG))
    EndIf
    DllClose($hDll)
EndFunc

Func _GUIAcceleratorTableFree($pAccel)
    DllCall("user32.dll", "int", "DestroyAcceleratorTable", "ptr", $pAccel)
EndFunc

Func _GUIAcceleratorTableInit(ByRef $pTable)
    Local $tagACCEL = "byte;short;short"
    Local $fVirt, $key
    If Not IsArray($pTable) or UBound($pTable) < 2 then SetError(1, 0, False)
    Local $sData = ""
    For $i = 1 To $pTable[0][0]
        $sData &= $tagACCEL & ";"
    Next
    $sData = StringTrimRight($sData, 1)
    Local $pData = DllStructCreate($sData)
    For $i = 1 To $pTable[0][0]
        _TranslateKeys($pTable[$i][1], $fVirt, $key)
        DllStructSetData($pData, $i*3-2, $fVirt)
        DllStructSetData($pData, $i*3-1, $key)
        DllStructSetData($pData, $i*3,   $pTable[$i][0])
    Next
    $ret = DllCall("user32.dll", "ptr", "CreateAcceleratorTable", "ptr", DllStructGetPtr($pData), "int", $pTable[0][0])
    If @Error or $ret[0] = 0 Then SetError(2, 0, 1) ; Creating table was not succeed
    $pTable = $ret[0]
    Return True
EndFunc

Func _TranslateKeys($sHotkey, ByRef $fVirt, ByRef $key)
    $fVirt = 0
    $sHotkey = StringReplace($sHotkey, "^", "", 1)
    If @extended = 1 Then $fVirt = BitOR($fVirt, $FCONTROL, $FVIRTKEY)
    $sHotkey = StringReplace($sHotkey, "!", "", 1)
    If @extended = 1 Then $fVirt = BitOR($fVirt, $FALT, $FVIRTKEY)
    $sHotkey = StringReplace($sHotkey, "+", "", 1)
    If @extended = 1 Then $fVirt = BitOR($fVirt, $FSHIFT, $FVIRTKEY)
    If StringLen($sHotkey) = 1 Then
        $key = Asc(StringUpper($sHotkey))
    Else
        ; Here become long case for special keys
        Switch $sHotkey
            Case "{SPACE}"
                $key = 32
            Case "{ENTER}"
                $key = 13
        EndSwitch
    EndIf
EndFunc

Func _GUICtrlSetAccelerator(ByRef $pTable, $nCtrlID, $sHotkey)
    If not IsArray($pTable) Then
        Local $tmpTable[1][2] = [[0,0]]
        $pTable = $tmpTable
    EndIf
    $pTable[0][0] += 1

    Local $curIdx = $pTable[0][0]

    ReDim $pTable[$curIdx+1][2]
    $pTable[$curIdx][0] = $nCtrlID
    $pTable[$curIdx][1] = $sHotkey
EndFunc

