#include <IE.au3>
#include <Tesseract.au3>

$oIE = _IECreate("                                                             ")
WinWait("ListDemo")

$button1_text = _TesseractControlCapture("ListDemo", "", "[CLASS:Button; INSTANCE:1]", 1, "", 1, 1, 1, 5, 3, 2, 2, 2, 2, 1)
$combobox1_edit_text = _TesseractControlCapture("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", 1, "", 1, 1, 1, 5, 3, 2, 2, 10, 2, 1)
$combobox1_text = _TesseractControlCapture("ListDemo", "", "[CLASS:ComboBox; INSTANCE:1]", 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3, 1)
$listbox1_text = _TesseractControlCapture("ListDemo", "", "[CLASS:ListBox; INSTANCE:1]", 1, @CRLF, 1, 1, 1, 5, 3, 2, 2, 200, 0, 1)

WinClose("ListDemo")
_IEQuit($oIE)
