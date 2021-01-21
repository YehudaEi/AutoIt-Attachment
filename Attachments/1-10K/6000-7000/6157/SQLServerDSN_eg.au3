#cs
********************************************************************************************
*  This script adds system data source names (DSN) for SQL Server databases on a local
*  or remote system based on four distinct variables:
*
*	$sysnames	(Optional) Network names of the systems to add/remove the DSN(s) 
*	$dsn		Reference name of the DSN to be created/deleted, case-sensitive
*	$db			Name of the SQL Server database to connect to, not case-sensitive
*	$server		Network name of the system running the SQL Server instance
********************************************************************************************
#ce

;check OS version (untested on OS other than Win2k/WinXP)
If @OSVersion <> "WIN_2000" And @OSVersion <> "WIN_XP" Then
	MsgBox(16,"Error","This script only supports Windows 2000/XP")
	Exit
EndIf

Dim $sysnames, $dsn, $db, $server, $addlog, $dellog 

;prompt for system/network names, keeping user at dialog until name entry
While $sysnames = ""
	$sysnames = InputBox("SQL Server DSN", "- Enter the names of the systems" & @CR & _
              "- Separate multiple names with a comma (e.g. SYS01,SYS02)", @ComputerName, _
              "", 400, 150)
	If @error = 1 Then
		Exit		;if user clicks cancel button, exit
	EndIf
WEnd

$sysnames = StringStripWS($sysnames, 8)		;strip any whitespace
$sysarray = StringSplit($sysnames, ",")		;split string to an array by the "," delimeter

;*******************************************************************************************
;*  ADD DSN VARIABLES AND WRITEKEYS OR DELETEKEYS FUNCTION BELOW
;*******************************************************************************************

$dsn = "TELEFORM_DE"
$db = "TELEFORM_DE"
$server = "xxxxx"
WriteKeys()

;$dsn = "ACME_ACM101"
;$db = "TEST_ACME_DE"
;$server = "xxxxx"
;WriteKeys()

;*******************************************************************************************
;*  STOP HERE! DO NOT ADD OR EDIT ANY CODE BELOW THIS LINE
;*******************************************************************************************

;display confirmation message with log of any operations performed
If ($addlog = "") And ($dellog = "") Then
	MsgBox(64,"Done","No operations were executed on " & $sysnames)
Else
	MsgBox(64,"Done", $addlog & $dellog)
EndIf
Exit

;function to add a system DSN by writing keys to the system's registry
Func WriteKeys()
	If ($dsn = "") Or ($db = "") Or ($server = "") Then
		;display error message if any required variables are empty
		MsgBox(48,"Error","One or more required variables for a DSN is missing or blank.")
		Exit
	Else
		For $i = 1 To (UBound($sysarray) - 1)		;for each system name
			;write keys/values to the registry if a DSN for the database does not exist
			If RegRead("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "Database") = "" Then
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn)
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "Database", "REG_SZ", $db)
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "Driver", "REG_SZ", _
				@SystemDir & "\SQLSRV32.dll")
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "LastUser", "REG_SZ", _
				"administrator")
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "Server", "REG_SZ", $server)
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "Trusted_Connection", _
				"REG_SZ", "Yes")
				RegWrite("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources", $dsn, "REG_SZ", _
				"SQL Server")
				$addlog = $addlog & $dsn & "  added to  "  & $sysarray[$i] & @CR		;log operation
			EndIf
		Next
		$dsn = ""		;clean variables
		$db = ""
		$server = ""
	EndIf
EndFunc

;function to remove a system DSN by deleting keys from the system's registry
Func DeleteKeys()
	If ($dsn = "") Or ($db = "") Or ($server = "") Then
		;display error message if any required variables are empty
		MsgBox(48,"Error","One or more required variables for a DSN is missing or blank.")
		Exit
	Else
		For $i = 1 To (UBound($sysarray) - 1)		;for each system name
			;delete keys and values from the registry if a DSN for the database exists
			If RegRead("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn, "Database") = $db Then
				RegDelete("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\" & $dsn)
				RegDelete("\\" & $sysarray[$i] & "\HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources", $dsn)
				$dellog = $dellog & $dsn & "  removed from  " & $sysarray[$i] & @CR		;log operation
			EndIf
		Next
		$dsn = ""		;clean variables
		$db = ""
		$server = ""
	EndIf 
EndFunc