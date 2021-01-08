;XLBookAddExample1.au3
#include"ExcelCom.au3"
$s_File=@ScriptDir&"\book3.xls"
_XLCreateBlank($s_File)
_XLRead($s_File,1,1,1,0)
$s_NewPath=@ScriptDir&"\book4.xls"
_XLCreateBlank($s_NewPath)
_XLshow($s_NewPath,1)
msgbox (0,"$FilePath=","$s_NewPath now ="&$s_NewPath)
;_XLclose($s_NewPath,0); no changes and close workboot; not  Excel
