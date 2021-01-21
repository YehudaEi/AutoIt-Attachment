;XLFormatCurrency.au3 format so dates can be read and sorted
#include"ExcelCom.au3"
$DateSort="yyyy/mm/dd;@"
$DateUSA="mm/dd/yyyy;@"
$DateWorld="dd/mm/yyyyy;@"
$DateLong="[$-F800]dddd, mmmm dd, yyyy"
$DateWorld="dd/mm/yyyyy;@"
$Currency="$#,##0.00"
;$FilePath=@ScriptDir&"\Blank.xls"
;_XLCreateBlank($FilePath)
;$tFilePath=@ScriptDir&"\Err_NC.txt"
$cFilePath=@ScriptDir&"\Err_NC.csv"
$cFilePath=FileOpenDialog("File?",@ScriptDir,"Csv files (*.csv)",1,$cFilePath)
_XLShow($cFilePath,1)
MsgBox(0,"","")
;FileCopy($tFilePath,$cFilePath)
$SortedFileText=@ScriptDir&"\Curr.txt"
;****************************Read Array from csv*****************************
;$var1=_XLFormat($cFilePath,1,"A:A",1,"")
;$XLArray=_XLArrayRead($cFilePath,1,"")
;_XLClose($cFilePath,1)
;****************************Write Array to Excel*****************************
;_XLRowToArray($FilePath,$Sheet,$XLRange,$Line)
$XLRowToArray=_XLRowToArray($cFilePath,1,"A:G",3)
_XLShow($cFilePath,1)
_ArrayDisplay($XLRowToArray,"Row")

;$XLArrayAddress=_XLArrayWrite($XLArray,$FilePath,1,"A1",1)
$var1=_XLFormat($cFilePath,1,"B:B",1,$Currency); or $DateUSA or $DateWorld for save;;
_XLShow($cFilePath,1)
MsgBox(0,"","")
$XLRowToArray=_XLRowToArray($cFilePath,1,"A:G",3)
_XLShow($cFilePath,1)
_ArrayDisplay($XLRowToArray,"Row")
;_XLSort($FilePath,"B1",1,"A1",2,$XLArrayAddress,1)
;****************************Save Sorted Array to sorted.cvs *****************************
_XLSaveAs($cFilePath,$SortedFileText,"csv")
_XLClose($SortedFileText,1)
runwait("notepad.exe "&$SortedFileText,@ScriptDir,@SW_MAXIMIZE)





