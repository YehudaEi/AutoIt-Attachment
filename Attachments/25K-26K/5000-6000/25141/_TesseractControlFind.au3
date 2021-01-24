#include <IE.au3>
#include <Tesseract.au3>

$oIE = _IECreate("                                                             ")
WinWait("ListDemo")

$button1_pos = _TesseractControlFind("ListDemo", "", "[CLASS:Button; INSTANCE:1]", "Add", 1, 1, "", 1, 1, 1, 5, 3, 2, 2, 2, 2)
MsgBox(0, "_TesseractControlFind.au3", """Add"" found at position " & $button1_pos)

$combobox1_edit_pos = _TesseractControlFind("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", "Last", 1, 1, "", 1, 1, 1, 5, 3, 2, 2, 10, 2)
MsgBox(0, "_TesseractControlFind.au3", """Last"" found at position " & $combobox1_edit_pos)

$combobox1_pos = _TesseractControlFind("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", "First", 1, 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3)
MsgBox(0, "_TesseractControlFind.au3", """First"" found at position " & $combobox1_pos)
$combobox1_pos = _TesseractControlFind("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", "Last", 1, 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3)
MsgBox(0, "_TesseractControlFind.au3", """Last"" found at position " & $combobox1_pos)
$combobox1_pos = _TesseractControlFind("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", "After Selection", 1, 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3)
MsgBox(0, "_TesseractControlFind.au3", """After Selection"" found at position " & $combobox1_pos)

$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 0", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 0"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 1", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 1"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 2", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 2"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 3", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 3"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 4", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 4"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 5", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 5"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 6", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 6"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 7", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 7"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 8", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 8"" found at index " & $listbox1_index)
$listbox1_index = _TesseractControlFind("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", "Item 9", 1, 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0)
MsgBox(0, "_TesseractControlFind.au3", """Item 9"" found at index " & $listbox1_index)

WinClose("ListDemo")
_IEQuit($oIE)
