#include <FileLineUDF.au3>
;~ ################################
;~ ########### Examples ###########
;~ ################################

#include "Array.au3" ; For Examples
FileDelete("Example.txt")



;--------- _FileLineMerge -----------
FileDelete("Example1.txt")
FileDelete("Example2.txt")

MsgBox(0, "",'_FileLineMerge')
FileWriteLine("Example1.txt", "Ashalshaikh (1)")
FileWriteLine("Example1.txt", "Ashalshaikh (2)")
FileWriteLine("Example1.txt", "AutoIt (3)")
FileWriteLine("Example1.txt", "AutoIt (4)")
FileWriteLine("Example1.txt", "Ashalshaikh (5)")
FileWriteLine("Example1.txt", "AutoIt (6)")

FileWriteLine("Example2.txt", "Ashalshaikh (1)")
FileWriteLine("Example2.txt", "Ashalshaikh (2)")
FileWriteLine("Example2.txt", "AutoIt (3)")
FileWriteLine("Example2.txt", "AutoIt (4)")
FileWriteLine("Example2.txt", "Ashalshaikh (5)")
FileWriteLine("Example2.txt", "AutoIt (6)")

MsgBox(0, "", "Example1.txt" & @CR & FileRead("Example1.txt") & @CR & _
		"Example2.txt" & @CR & FileRead("Example2.txt"))
_FileLineMerge("Example1.txt", "Example2.txt")
MsgBox(0, 'Example1.txt', FileRead("Example1.txt"))

FileDelete("Example1.txt")
FileDelete("Example2.txt")
;--------- _FileLineLen -----------
MsgBox(0, "",'_FileLineLen')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "AutoIt (3)")
FileWriteLine("Example.txt", "AutoIt (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "AutoIt (6)")

MsgBox(0, "", FileRead("Example.txt") & @CRLF & _
		'length Of Line Number 3 =' & _FileLineLen("Example.txt", 3))

FileDelete("Example.txt")
;--------- _FileLineDelete -----------
MsgBox(0, "",'_FileLineDelete')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "AutoIt (3)")
FileWriteLine("Example.txt", "AutoIt (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "AutoIt (6)")
MsgBox(0, "Before",FileRead("Example.txt"))
 _FileLineDelete("Example.txt",3)
 MsgBox(0, "After",FileRead("Example.txt"))
FileDelete("Example.txt")

;--------- _FileLineGetRefined -----------
MsgBox(0, "",'_FileLineGetRefined ')
FileWriteLine("Example.txt", "Ashalshaikh ")
FileWriteLine("Example.txt", "Ashalshaikh %")
FileWriteLine("Example.txt", "")
FileWriteLine("Example.txt", "Ashalshaikh")
FileWriteLine("Example.txt", " dsd       ")
FileWriteLine("Example.txt", "Ashalshaikh %")
$MM = _FileLineGetRefined("Example.txt")
_ArrayDisplay($MM)

FileDelete("Example.txt")
;--------- _FileLineAddEnd -----------
MsgBox(0, "",'_FileLineAddEnd')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "AutoIt (3)")
FileWriteLine("Example.txt", "AutoIt (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "AutoIt (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineAddEnd("Example.txt", ' -#', 2, -1)
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileLineAddStart -----------
MsgBox(0, "",'_FileLineAddStart')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "AutoIt (3)")
FileWriteLine("Example.txt", "AutoIt (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "AutoIt (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineAddStart("Example.txt", '#- ', 2, -1)
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileLineAddNumbers -----------
MsgBox(0, "",'_FileLineAddNumbers')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "AutoIt (3)")
FileWriteLine("Example.txt", "AutoIt (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "AutoIt (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineAddNumbers("Example.txt", 1, -1, 1, ")- ")
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileLineDisplay --------------
MsgBox(0, "",'_FileLineDisplay ')

FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", " dsd       ")
FileWriteLine("Example.txt", "Ashalshaikh (6)")
_FileLineDisplay("Example.txt")
FileDelete("Example.txt")

;--------- _FileLineMove -----------
MsgBox(0, "",'_FileLineMove')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineMove("Example.txt", 1, 3)
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileLineGetLonger  -----------
MsgBox(0, "",'_FileLineGetLonger')
FileWriteLine("Example.txt", "Ashalshh (1)")
FileWriteLine("Example.txt", "Ashalkh (2)")
FileWriteLine("Example.txt", "Ashalssfdfdfhaikh (3)")
FileWriteLine("Example.txt", "Ashkh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaggikh (6)")

MsgBox(0, "", FileRead("Example.txt"))
$s = _FileLineGetLonger('Example.txt')
MsgBox(0, "", 'Number Of Longer Line :' & $s[0] & @CRLF & _
		'length  Of Longer Line :' & $s[1] & ' Chr')
FileDelete("Example.txt")
;--------- _FileLineGetShorter  -----------
MsgBox(0, "",'_FileLineGetShorter')
FileWriteLine("Example.txt", "Ashalshh (1)")
FileWriteLine("Example.txt", "Ashalkh (2)")
FileWriteLine("Example.txt", "Ashalssfdfdfhaikh (3)")
FileWriteLine("Example.txt", "Ashkh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaggikh (6)")

MsgBox(0, "", FileRead("Example.txt"))
$s = _FileLineGetShorter('Example.txt')
MsgBox(0, "", 'Number Of Shorter Line :' & $s[0] & @CRLF & _
		'length  Of Shorter Line :' & $s[1] & ' Chr')
FileDelete("Example.txt")

;--------- _FileLineExists  -----------
MsgBox(0, "",'_FileLineExists')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

MsgBox(0, "", 'Is Line Number 8 Exist ? :' & _FileLineExists("Example.txt", 8))
MsgBox(0, "", 'Is Line Number 3 Exist ? :' & _FileLineExists("Example.txt", 3))

FileDelete("Example.txt")

;--------- _FileLineStripWS --------------
MsgBox(0, "",'_FileLineStripWS ')

FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", " dsd       ")
FileWriteLine("Example.txt", "Ashalshaikh (6)")
$MM = _FileLineGetInfo("Example.txt")
_ArrayDisplay($MM)


;--------- _FileLineStripWS --------------
MsgBox(0, "",'_FileLineStripWS ')
MsgBox(0, "Before", FileRead("Example.txt"))
$Res = _FileLineStripWS("Example.txt")
MsgBox(0, "After", FileRead("Example.txt"))
FileDelete("Example.txt")
;--------- _FileLineIsEmpty --------------
MsgBox(0, "",'_FileLineIsEmpty')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "      ")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", " dsd       ")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

$E = _FileLineIsEmpty("Example.txt", 1)
MsgBox(0, "Line Num 1 = Ashalshaikh (1)", $E)

$E = _FileLineIsEmpty("Example.txt", 3)
MsgBox(0, "Line Num 3 =       ", $E)

$E = _FileLineIsEmpty("Example.txt", 5)
MsgBox(0, "Line Num 5 = dsd        ", $E)

FileDelete("Example.txt")


;--------- _StringInLine --------------
MsgBox(0, "",'_StringInLine')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Autoit      (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Autoit      (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

$E = _StringInLine("Example.txt", "Ashalshaikh")

_ArrayDisplay($E)
FileDelete("Example.txt")


;--------- _FileLineSwap  -----------
MsgBox(0, "",'_FileLineSwap')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineSwap("Example.txt", 1, 3)
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileLineReplace  -----------
MsgBox(0, "",' _FileLineReplace')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineReplace("Example.txt", 1, 'New String')
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")

;~ ;--------- _FileDownLineByText  -----------
MsgBox(0, "",'_FileDownLineByText')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")

MsgBox(0, "Before", FileRead("Example.txt"))
$DD = _FileLineDownByText("Example.txt", "Ashalshaikh (2)")
MsgBox(0, @error & "After" & $DD, FileRead("Example.txt"))

FileDelete("Example.txt")

;~ ;--------- _FileDownLineByNum  -----------
MsgBox(0, "",'_FileDownLineByNum')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")

MsgBox(0, "Before", FileRead("Example.txt"))
$DD = _FileLineDownByNum("Example.txt", 3)
MsgBox(0, @error & "After" & $DD, FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileUpLineByText  -----------
MsgBox(0, "",'_FileUpLineByText')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineUpByText("Example.txt", "Ashalshaikh (3)")
MsgBox(0, "After", FileRead("Example.txt"))
FileDelete("Example.txt")

;~--------- _FileDownLineByNum  -----------
MsgBox(0, "",'_FileUpLineByNum')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Ashalshaikh (5)")
FileWriteLine("Example.txt", "Ashalshaikh (3)")

MsgBox(0, "Before", FileRead("Example.txt"))
$DD = _FileLineUpByNum("Example.txt", 3)
MsgBox(0, @error & "After" & $DD, FileRead("Example.txt"))

FileDelete("Example.txt")

;--------- _FileLineSort  -----------
MsgBox(0, "",'_FileLineSort')
FileWriteLine("Example.txt", "Ashalshaikh (1)")
FileWriteLine("Example.txt", "Ashalshaikh (2)")
FileWriteLine("Example.txt", "Autoit      (3)")
FileWriteLine("Example.txt", "Ashalshaikh (4)")
FileWriteLine("Example.txt", "Autoit      (5)")
FileWriteLine("Example.txt", "Ashalshaikh (6)")

MsgBox(0, "Before", FileRead("Example.txt"))
_FileLineSort("Example.txt")
MsgBox(0, "After", FileRead("Example.txt"))

FileDelete("Example.txt")