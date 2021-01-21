;XLChart11.au3
#include"ExcelCom.au3";
;more work with no axis titles; not bubble, though
;$Type options are"Line", "Pie","Column","Bar","XYScatter","Surface","Area"
;$Special options are "BarOf","PieOf","Lines","Smooth"; all others are 0/1
;Syntax; _XLPaste($sFilePath,$Sheet,$Column,$Row,$ExcelValue1,$Save,$ToColumn)
;Syntax; $XLChartType=_XLChartType([$Type,[$Special,[$3D,[$Clustered,[$Stacked,[$100,[$Markers,[$Exploded]]]]]]]])
;Syntax; _XLChart($FilePath,$ChartType,$PlotBy,$Title,$Xaxis,$Yaxis,$Zdata,$DataRange,$Sheet)
;other examples;
;$XLChartType=_XLChartType("Area",0,1);,0,0,0,0,0)
;$XLChartType=_XLChartType("Pie",0,1,0,0,0,1,0)
;$XLChartType=_XLChartType("Surface");,0,0,0,1,0)

$FilePath=@ScriptDir&"\MyNewSheet.xls"
;_XLCreateBlank($FilePath)
;$DataString="Bolts,12,7,6,9,23,45,3,17,18,9"&@CRLF&"Nuts,3,12,7,6,9,23,45,3,17,18"
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$PasteRange=_XLpaste($FilePath,1,"A",1,$DataString,1,"NotToColumn",1)
;msgbox (0," visible if shown", "$DataString="&$DataString)
$xlRows=1;$xlColumns=2;
$XLChartType=_XLChartType()
$azData="Series1Ch|Series2Ch|Series3Ch|Series4Ch"
_XLChart($FilePath,$XLChartType,$xlRows,"aTitle","aXaxis","aYaxis","aZdata",$PasteRange,1)
_XLshow($FilePath,1,1,1,1)
msgbox (0," visible if shown", " visible if shown")
;_XLclose($FilePath,"NoSave");  no save or changes and close workboot; not  Excel

