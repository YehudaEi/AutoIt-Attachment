#include <SQLite.au3>
#include <Date.au3>

Dim $Path = "C:\_\Apps\AutoIT3\_Development\SMART\smart.exe"
Dim $sRecord, $sDataOut
Dim $Column1,$Column2,$Column3,$Column4,$Column5,$Column6,$Column7,$Column8
Dim $hQuery, $iRval, $aResult, $iRows, $aRow, $iColumns

_SQLite_Startup ()
_SQLite_Open () ; open :memory: Database
_SQLite_Exec (-1, "CREATE TABLE Smart_data (Timestamp,ID,Attribute,Type,Threshold,Value,Worst,Raw,Status);") ; CREATE a Table

_Smart()
_PopulateColumns()
	
$iRval = _SQLite_GetTable2d (-1, "SELECT * FROM Smart_data ORDER BY Type DESC;", $aResult, $iRows, $iColumns) ; Query

If $iRval = $SQLITE_OK Then
	_SQLite_Display2DResult($aResult)
	$iRval2 = _SQlite_Query (-1, "SELECT * FROM Smart_data WHERE Status <> 'OK';", $hQuery)
		While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK ; This get 1 row at a time
				MsgBox(0,"SQLite","Drive Status NOT OK : "&$aRow[0]&" "&$aRow[1]&" "&$aRow[2]&" "&$aRow[3]&" "&$aRow[4]&" " _
				&$aRow[5]&" "&$aRow[6]&" "&$aRow[7]&" "&$aRow[8])
		WEnd	
Else
	MsgBox(16, "SQLite Error: " & $iRval, _SQLite_ErrMsg ())
EndIf

_SQLite_Exec (-1, "DROP TABLE Smart_data;") ; Remove the table
_SQLite_Close()
_SQLite_Shutdown()

Func _Smart()
$Smart = Run($Path, "", @SW_HIDE, 2)
Local $sDataOut = ""
    Sleep(500)
    While 1
        $sDataOut &= StdOutRead($Smart)
		If @error = -1 Then ExitLoop
		$sRecord = stringsplit($sDataOut,@CRLF)
		
	WEnd
	
	Return $sRecord
EndFunc

Func _PopulateColumns()
	For $i = 27 to 59 Step 2
		$Column0 = _Now()
		$Column1 = Stringleft($sRecord[$i],4)
		$Column2 = stringmid($sRecord[$i],6,26)
		$Column3 = stringmid($sRecord[$i],33,10)
		$Column4 = stringmid($sRecord[$i],45,3)
		$Column5 = stringmid($sRecord[$i],51,3)
		$Column6 = stringmid($sRecord[$i],57,3)
		$Column7 = stringmid($sRecord[$i],62,9)
		$Column8 = stringmid($sRecord[$i],72,2)
		_SQLite_Exec (-1, "INSERT INTO Smart_data (Timestamp,ID,Attribute,Type,Threshold,Value,Worst,Raw,Status) VALUES ('"&$Column0&"','"& _
		$Column1&"','"&$Column2&"','"&$Column3&"','"&$Column4&"','"&$Column5&"','"&$Column6&"','"&$Column7&"','"&$Column8&"');") ; INSERT Data
	Next
		
EndFunc