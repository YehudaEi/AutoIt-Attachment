#include <GuiConstants.au3>
#include <file.au3>
#include <array.au3>
Dim $msg = ""
Dim $file = "logfile1.ini"

Dim $TreeView = _CreateGUI()

_IniGetSectionNames( $file, $TreeView )
GuiSetState()
While 1
    $msg = GuiGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
    Case Else
   ;;;
    EndSelect
WEnd
Exit

Func _IniGetSectionNames( $file, $TreeView )
    Local $varx = IniReadSectionNames( $file )
    If @error Then
        MsgBox(4096, "", "Error occured, probably no INI file.")
    Else
        For $i_SectionIndex = 1 To $varx[0]
            MsgBox(4096, "", $varx[$i_SectionIndex])
            _IniReadInfo( $file, $varx, $TreeView, $i_SectionIndex )
        Next
    EndIf
EndFunc

Func _IniReadInfo( $file, $varx, $TreeView, $i_SectionIndex )
    Local $var = IniReadSection($file,$varx[$i_SectionIndex])

    ;MsgBox(32,"VarX","Varx = " & $varx[$i_SectionIndex])

    If @error Then
        MsgBox(4096, "", "Error occured, probably no INI file.")
    Else
        Local $TreeView2 = GUICtrlCreateTreeViewitem($varx[$i_SectionIndex],$TreeView )
        For $i = 1 To $var[0][0]
            GUICtrlCreateTreeViewItem($var[$i][0], $TreeView2)
            MsgBox(4096, "", "Key: " & $var[$i][0] & @CRLF );& "Value: " & $var[$i][1])
        Next
    EndIf
EndFunc

Func _CreateGUI()
    If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000
    GuiCreate("Form2", 420, 331, 430,346 ,BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
    Return GUICtrlCreateTreeView(16, 16, 353, 217)
EndFunc

