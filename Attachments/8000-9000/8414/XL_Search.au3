;XL_Search.au3  0_2
;_XLSearch($s_FilePath,$s_i_Sheet,$s_i_ExcelValue,$s_i_Visible)
#include"ExcelCOM.au3"
;****** Create Blank Files, then add some data to XL file as example in column "Z"  on
$ReadXLPath=@ScriptDir&"\ReadXLPath.xls"
_XLCreateBlank($ReadXLPath)
_XLWrite($ReadXLPath,1,5,5,"g",0)
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"&@CRLF&"3,12,8,6,9,23,45,3,17,18"&@CRLF&"3,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$XLRange=_XLpaste($ReadXLPath,1,"Z",11,$DataString,1,"",0) ; _XLpaste($ReadXLPath,1,"Z",11,$DataString,1,0,1)

;****** Now read addresses from array or "Nothing" string*****************
;func _XLSearch($s_FilePath,$s_i_Sheet,$s_i_ExcelValue,$s_i_Visible)
$s_FoundList=_XLSearch($ReadXLPath,1,"1",0)
if $s_FoundList<> "Nothing" then
	$a_ArrayAnswer=StringSplit($s_FoundList,"|")
	_ArrayDisplay($a_ArrayAnswer,"")
Else
	msgbox(0,"","$s_FoundList="&$s_FoundList)
EndIf
