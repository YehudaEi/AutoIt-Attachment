#include <ExcelCOM_UDF.au3>

$username = InputBox("Username", "Enter your username:")
$password = InputBox("Password", "Enter your password:")
$sFilePath = @WorkingDir & "\book1.xls"	;Location of Excel spreadsheet

;Remember to make Excel spreadsheet hidden when going live.
$oExcel = _ExcelBookOpen($sFilePath, 0, False, "", "") ;Open the Excel document
$sRangeOrRowStart = "A2:A40";This is the field I want the search to start at.
$whatever = _ExcelFindInRange($oExcel, $username, $sRangeOrRowStart, 1, 800, 800, 0, 2, False, "")

If $whatever[0][0] = 1 then
	
	For $x = 1 to $whatever[0][0]
			
		$excelPassword = "B" & $whatever[$x][3]
		$field =_ExcelReadCell($oExcel, $excelPassword, 1)
		$driveMapPath = "\\Pc3\"  
		If $field = $password Then
			; Map X drive to \\Pc3\PC3
			DriveMapAdd("X:", $driveMapPath & $username) ;the drive will be mapped to the username which is the folder name
		Else
			MsgBox(0,"","Password is incorrect.") 
		EndIf
	
	Next
else
	MsgBox(0,"","Username is incorrect.")
EndIf	