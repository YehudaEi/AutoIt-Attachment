;XLReadOnlyExample.au3
#include"ExcelCom.au3"
$ReadOnlyFile=@ScriptDir&"\book3.xls"
_XLReadOnly($ReadOnlyFile)
_XLshow($ReadOnlyFile,1)
_XLRead($ReadOnlyFile,1,1,1,1)
msgbox (0,"$ReadOnlyFile=","$ReadOnlyFile now ="&$ReadOnlyFile)
;_XLClose($ReadOnlyFile)
$NewPath=@ScriptDir&"\book4.xls"
_XLSaveAs($ReadOnlyFile,$NewPath,"xls")
_XLshow($NewPath,1)
msgbox (0,"$FilePath=","$FilePath now ="&$NewPath)
_XLclose($NewPath,0); no changes and close workboot; not  Excel
