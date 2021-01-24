#include <Array.au3>
#include <IE.au3>
#include <Textract.au3>

$oIE = _IECreate("                                                             ")
WinWait("ListDemo")

$listbox1_index = _TextractFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 5", 1, @CRLF)
MsgBox(0, "_TextractFind.au3", $listbox1_index)

WinClose("ListDemo")
_IEQuit($oIE)
