#include"_CSVLib.au3"
#include <Array.au3>
; open a csv file
$File = FileOpenDialog('Open csv', @ScriptDir & '\', 'Csv files (*.csv)', 1, 'TestCSVFile.csv')
; get records separated by |
$Records = _CSVGetRecords ($File, -1, -1, 1)
_ArrayDisplay($Records, 'Your file with "|" as delimiter')
; get recrords separated by ,
$Records = _CSVGetRecords ($File, -1, -1, 0)
_ArrayDisplay($Records, 'Your file with "," as delimiter')
; get single column
$Column = _CSVGetColumn ($File, 2, -1, -1, 0)
_ArrayDisplay($Column, 'The second column')
; get single field
$Field = _CSVGetField ($File, 3, 2, -1, -1, 0)
MsgBox(0, 'field in col 3 row 2', $Field)
; get an array of fields of record 5
$FieldsInRecord = _CSVRecordToFields ($Records[5], -1, -1, 0)
_ArrayDisplay($FieldsInRecord, 'fields in Record 5')
