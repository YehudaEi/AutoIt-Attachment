#include"_CSVLib_V1.0.au3"
#include <Array.au3>
Dim $CSV[9] = [8]
$CSV[1] = 'Simple record with no delimiters in fields,b1,c1,d1,e1'
$CSV[2] = 'Simple record with no delimiters and some empty fields,,c2,,e2'
$CSV[3] = 'Simple record with no delimiters and with enclose chars,"b""3",c3,"d""3","e3"""'
$CSV[4] = 'Record with delimiters ,"b,4","c,4","d,4","e,4"'
$CSV[5] = 'Record with delimiters and enclose chars,"b"",5","c,""5","""d,5","e,5"""'
$CSV[6] = 'Record with multiple delimiters and multiple enclose chars,""""",,"",b"",6",",,""""c"""",""6""","""d"",""6"",","""""""e,6"""'
$CSV[7] = 'Record with fields with no delimiters, and other with multiple delimiters and multiple enclose chars,b7,",,""""c"""",""7""","""d"",""7"",",e7'
$CSV[8] = 'Record with complex combinations, delimiters and enclose chars,,",,""""c"""",""8""",,",,,,,,"","",""""""e,"","""",,,,"",8,"","'

$FileFullPath = @ScriptDir & '\CSVTestFile.csv'

If FileExists($FileFullPath) Then FileDelete($FileFullPath)
For $i = 1 To $CSV[0] Step 1
	FileWriteLine($FileFullPath, $CSV[$i])
Next
; open a csv file
$File = FileOpenDialog('Open csv', @ScriptDir & '\', 'Csv files (*.csv)', 1, 'CSVTestFile.csv')
; get records
$Records = _CSVReadRecords ($File)
_ArrayDisplay($Records, 'Records')
; get column 3
$Column = _CSVGetColumn ($Records, 3, -1, -1)
_ArrayDisplay($Column, 'Column 3')
; read fields in record
$Fields = _CSVRecordToFields ($Records[8])
_ArrayDisplay($Fields, 'Fields in record 8')
; red single field
MsgBox(0, 'Field in col 3 record 6', _CSVGetField ($Records, 3, 6))
; convert a field to string
$Field_4_2 = _CSVGetField ($Records, 2, 4)
$String_4_2 = _CSVFieldToString ($Field_4_2)
MsgBox(0, 'convert a field to string', $String_4_2)
; convert a string to field
MsgBox(0, 'convert a string to field', _CSVStringToField ($String_4_2))
; convert delimiters in records
$ConverDelimiter = _CSVConvertDelimiter ($Records)
_ArrayDisplay($ConverDelimiter, 'Delimiter Conversion on all records')
; convert delimiters in single record 8
$ConverDelimiter = _CSVConvertDelimiter ($Fields)
_ArrayDisplay($ConverDelimiter, 'Delimiter Conversion on record 8')
; convert Enclose in records
$ConverEnclose = _CSVConvertEnclose ($Records, -1, -1, '\')
_ArrayDisplay($ConverEnclose, 'Enclose Conversion on all records')
; convert Enclose in single record 8
$ConverEnclose = _CSVConvertEnclose ($Fields, -1, -1, '\')
_ArrayDisplay($ConverEnclose, 'Enclose Conversion on record 8')
; Fields array conversion to string
$FieldString = _CSVFieldsToRecord ($Fields)
MsgBox(0, 'Fields array conversion to string', $FieldString)
; Append Record 1 to end of csv file
_CSVFileAppendRecord ($FileFullPath, $Records[1])
$Records = _CSVReadRecords ($File)
_ArrayDisplay($Records, 'Append Record 1 to end of csv file')
; Append Column 3 to end of records
$Column = _CSVGetColumn ($Records, 3, -1, -1)
$ColumnAppend = _CSVFileAppendColumn ($FileFullPath, $Column)
_ArrayDisplay($ColumnAppend, 'Append Column 3 to to end of records')
; Insert a record in a file
$InsertRecord = _CSVFileInsertRecord ($FileFullPath, $Records[8], 3)
_ArrayDisplay($InsertRecord, 'Insert Record 8 in 3rd row')
; Insert a column in a file
$Records = _CSVReadRecords ($File)
$Column = _CSVGetColumn ($Records, 3)
$InsertColumn = _CSVFileInsertColumn ($FileFullPath, $Column, 5)
_ArrayDisplay($InsertColumn, 'Insert column 3 in 5th column')
; Replace record 4 with record 1
$Records = _CSVReadRecords ($File)
$UpdateRecord = _CSVFileUpdateRecord ($FileFullPath, $Records[4], 1)
_ArrayDisplay($UpdateRecord, 'Replace record 4 with record 1')
; Replace column 2 with column 6
$Records = _CSVReadRecords ($File)
$Column = _CSVGetColumn ($Records, 2)
$UpdateColumn = _CSVFileUpdateColumn ($FileFullPath, $Column, 6)
_ArrayDisplay($UpdateColumn, 'Replace column 2 with record 6')
; delete record 5
_CSVFileDeleteRecord ($FileFullPath, 5)
$Records = _CSVReadRecords ($File)
_ArrayDisplay($Records, 'Record 5 deleted')
; delete column
_CSVFileDeleteColumn ($FileFullPath, 4)
$Records = _CSVReadRecords ($File)
_ArrayDisplay($Records, 'Column 4 deleted')