#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GUIEdit.au3>
#include <WindowsConstants.au3>

Global Const $hGUI = GUICreate("Pseudo CMD Box by UEZ 2012 Alpha Version", 736, 450, -1, -1, -1, $WS_EX_CONTEXTHELP)
Global Const $idEdit = GUICtrlCreateEdit($hGUI, 0, 0, 736, 369, BitOR($ES_AUTOVSCROLL, $WS_HSCROLL, $WS_VSCROLL, $ES_MULTILINE, $ES_WANTRETURN))
Global $sPrefix = GetCMDVer()
Global $sCMDLine = @HomeDrive & @HomePath
Global $iPrefixLen = StringLen($sCMDLine & ">")

GUICtrlSetData(-1,  $sPrefix & @CRLF & _
                                    "Copyright © 2009 Microsoft Corporation.  All rights reserved." & @CRLF & @CRLF & $sCMDLine & ">")
GUICtrlSetFont(-1, 10, 600, 0, "Lucida Console")
GUICtrlSetColor(-1, 0xC0C0C0)
GUICtrlSetBkColor(-1, 0x000000)
$hEdit = GUICtrlGetHandle($idEdit)
_GUICtrlEdit_SetLimitText($hEdit, -1)
Global Const $idButton_Dir = GUICtrlCreateButton("Dir", 30, 390, 80, 40)
Global Const $idButton_IPC = GUICtrlCreateButton("IPConfig", 140, 390, 80, 40)
GUISetState()
GUISetIcon(@SystemDir & "\cmd.exe", 0, $hGUI)
ControlClick("", "", $idEdit)

Global $hEditWndProc = DllCallbackRegister ("EditWndProc", "long", "hwnd;uint;wparam;lparam")
Global $hOldEditProc = _WinAPI_SetWindowLong($hEdit, $GWL_WNDPROC, DllCallbackGetPtr($hEditWndProc))

Do
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            _WinAPI_SetWindowLong($hEdit, $GWL_WNDPROC, $hOldEditProc)
            DllCallbackFree($hEditWndProc)
            GUIDelete()
            Exit
        Case $idButton_Dir
            SendCommand2CMD("dir")
        Case $idButton_IPC
            SendCommand2CMD("chkdsk.exe  ")
    EndSwitch
Until False

Func SendCommand2CMD($sCommand)
    ControlFocus($hGUI, "", $idEdit)
    ControlSend($hGUI, "", $idEdit, $sCommand & @LF)
EndFunc

Func EditWndProc($hWnd, $iMsg, $wParam, $lParam)
    Switch $iMsg
        Case $WM_KEYDOWN
;~        ConsoleWrite($wParam & @LF)
            Switch $wParam
                Case 13
                    Local $sCMD = StringMid(_GUICtrlEdit_GetLine($hEdit, _GUICtrlEdit_LineFromChar($hEdit)), $iPrefixLen + 1)
                    _GUICtrlEdit_BeginUpdate($hEdit)
                    _GUICtrlEdit_AppendText($hEdit, Oem2Ansi(ExecuteCMD($sCMD)))
                    $sCMDLine = StringReplace(ExecuteCMD("cd"), @CRLF, "")
                    ExecuteCMD("cd /d " & $sCMDLine)
                    $iPrefixLen = StringLen($sCMDLine & ">")
                    _GUICtrlEdit_AppendText($hEdit, @CRLF & Oem2Ansi($sCMDLine) & ">")
                    _GUICtrlEdit_EndUpdate($hEdit)
                    _GUICtrlEdit_LineScroll($hEdit, 0, 0xFFFFFF)
                    Return 1
                Case 8
                    If _GUICtrlEdit_LineLength($hEdit) < $iPrefixLen Then
                         _GUICtrlEdit_AppendText($hEdit, ">")
                    EndIf
                    Return 1
            EndSwitch
    EndSwitch
    Return _WinAPI_CallWindowProc($hOldEditProc, $hWnd, $iMsg, $wParam, $lParam)
EndFunc

Func ExecuteCMD($sCommand)
    Local $iPID = Run(@ComSpec & " /c " & $sCommand, $sCMDLine, @SW_HIDE, $STDERR_MERGED)
    Local $line
    While 1
        $line &= StdoutRead($iPID)
        If @error Then ExitLoop
    WEnd
    Return $line
EndFunc

Func GetCMDVer()
    Local $foo = Run(@ComSpec & " /c ver", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
    Local $line
    While 1
        $line &= StdoutRead($foo)
        If @error Then ExitLoop
    WEnd
    Return StringStripWS(StringStripCR($line), 3)
EndFunc   ;==>GetCMDVer

Func Oem2Ansi($text)
    $text = DllCall('user32.dll','Int','OemToChar','str',$text,'str','')
    Return $text[2]
EndFunc