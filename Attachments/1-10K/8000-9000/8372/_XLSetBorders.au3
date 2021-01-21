;_XLSetBorders.au3
#include"ExcelCom.au3"
$XLSFile = @TempDir & "\Blank.xls"
_XLCreateBlank($XLSFile)
_XLPaste($XLSFile, 1, "A", 1, "File Name" & @TAB & "Size" & @TAB & "Date" & @TAB & "Time" & @TAB & "Version", 1)
_XLPaste($XLSFile, 1, "A", 2, "This is a file name" & @TAB & "1.234.567" & @TAB & "12/10/2005" & @TAB & "11:19" & @TAB & "1..0.0.9", 1)
_XLSetCellColor($XLSFile, 1, "A1:E1", 0, 27, 1)
_XLSetColumnWidth($XLSFile, 1, "A:E",1, "Autofit", 1)
_XLSetHorizontalAlign($XLSFile, 1, "A1:E1", 0, "Center", 1)
_XLSetFontType($XLSFile, 1, "A1:E1", 0, "Bold", 1)
_XLSetFontType($XLSFile, 1, "A1:E1", 0, "Italic", 1)
_XLSetBorders($XLSFile, 1, "A1:E1", 0, "BottomEdge,1,3,Default;RightEdge,1,3,Default;InsideVertical,1,2,3", 1)