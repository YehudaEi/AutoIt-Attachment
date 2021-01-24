#include <Array.au3>
#include <IE.au3>
#include <Textract.au3>

$oIE = _IECreate("                                                             ")
WinWait("ListDemo")

$button1_text = _TextractCapture("ListDemo", "", "[CLASS:Button; INSTANCE:1]", "")
MsgBox(0, "_TextractCapture.au3", $button1_text)

$combobox1_edit_text = _TextractCapture("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", "")
MsgBox(0, "_TextractCapture.au3", $combobox1_edit_text)

$combobox1_text = _TextractCapture("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", @CRLF)
_ArrayDisplay($combobox1_text)

$listbox1_text = _TextractCapture("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", @CRLF)
_ArrayDisplay($listbox1_text)

WinClose("ListDemo")
_IEQuit($oIE)
