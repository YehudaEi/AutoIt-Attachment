;XLFormatSortExample.au3
#include"ExcelCom.au3"
; format so dates can be read and sorted
$DateSort="yyyy/mm/dd;@"
$DateUSA="mm/dd/yyyy;@"
$DateWorld="dd/mm/yyyyy;@"
$DateLong="[$-F800]dddd, mmmm dd, yyyy"
$Numbers="#,##0.00_ ;[Red]-#,##0.00 "
;$Currency="$#,##0.00_);[Red]($#,##0.00)"
$Currency1="$###0.00_);[Red]($###0.00)"
$DateMonth="[$-C09]d mmmm yyyy;@"
$TimeAMPM="[$-409]h:mm:ss AM/PM;@"
$PerCent="0.00%"
$Text="@"
;$tFilePath=@ScriptDir&"\Err_NC6.csv"
$tFilePath=@ScriptDir&"\Err_NC.txt"
;$tFilePath=@ScriptDir&"\Err_NCorg.txt"
;$tFilePath=@ScriptDir&"\Err_NC_large8Mb.txt"
$cFilePath=@ScriptDir&"\Err_NC.csv"
;RunWait("notepad.exe "&$tFilePath)
$cFilePath=@ScriptDir&"\Err_NC.csv"
FileDelete($cFilePath)
FileCopy($tFilePath,$cFilePath)
$SortedFileText=@ScriptDir&"\Err_NC_sorted.txt"
$Time1=@HOUR&"Time1:"&@MIN&":"&@sec&":";&$Ready
;****************************If the date is readabvle format for local Date style, this format gives date number for sorting; "General" 
$var1=_XLFormat($cFilePath,1,"A:A",1,"General")
;****************************Save Sorted Array to sorted.txt *****************************
_XLSort($cFilePath,"B1",1,"A1",2,"",1)
$var1=_XLFormat($cFilePath,1,"A:A",1,$DateSort)	; or $DateUSA or $DateWorld for save;;
_XLSaveAs($cFilePath,$SortedFileText,"csv")		; "csv" meaning dos-style csv file, in this case with "txt" ending; if "txt" then has tabs.
_XLClose($SortedFileText,1)
$Time2=@HOUR&"Time2:"&@MIN&":"&@sec&":"
MsgBox(0,"_XLcsvPaste=","$Time1="&$Time1&@CRLF&"$Time2="&$Time2);&"$varr="&$varr)
run("notepad.exe "&$SortedFileText)





