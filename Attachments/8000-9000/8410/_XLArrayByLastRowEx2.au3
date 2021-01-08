;_XLArrayByLastRowEx2.au3
#include"ExcelCom.au3"
$s_FilePath=@ScriptDir&"\book1.xls"
_XLShow($s_FilePath,1)
;exit
$i_LastRow=_XLLastRow($s_FilePath,1,0)
$XLArray=_XLArrayRead($s_FilePath,1,"A1:H"&$i_LastRow-1)
;_XLClose($s_FilePath,1)
;==============================================================================
local $s_StringOfSingleLine
for $i=0 to ubound ($XLArray,2)-1
$ar_ArrayOfSingleLine=_Array2DTo1D( $XLArray, "Array contents", 0, $i,0); $s_i_Column = 0)
_ArrayDelete($ar_ArrayOfSingleLine,0)
$s_StringOfSingleLine&=_ArrayToString($ar_ArrayOfSingleLine,",")&@CRLF
Next
$s_ArrayPath=@ScriptDir&"\array.csv"
FileDelete($s_ArrayPath)
;MsgBox(0,"","$s_ArrayFileString="&@CRLF&$s_StringOfSingleLine)
FileWrite($s_ArrayPath,$s_StringOfSingleLine)
RunWait("Notepad.exe " & $s_ArrayPath)