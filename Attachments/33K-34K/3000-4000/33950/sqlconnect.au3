#include-once


;===============================================================================
;
; Function Name:    _SQLConnect
; Description:      Initiate a connection to a SQL database
; Syntax:           $oConn = _SQLConnect($sServer, $sDatabase, $fAuthMode = 0, $sUsername = "", $sPassword = "", _
;                       $sDriver = "{SQL Server}")
; Parameter(s):     $sServer - The server your database is on
;                   $sDatabase - Database to connect to
;                   $fAuthMode - Authorization mode (0 = Windows Logon, 1 = SQL) (default = 0)
;                   $sUsername - The username to connect to the database with (default = "")
;                   $sPassword - The password to connect to the database with (default = "")
;                   $sDriver (optional) the ODBC driver to use (default = "{SQL Server}")
; Requirement(s):   Autoit 3 with COM support
; Return Value(s):  On success - returns the connection object for subsequent SQL calls
;                   On failure - returns 0 and sets @error:
;                       @error=1 - Error opening database connection
;                       @error=2 - ODBC driver not installed
;                       @error=3 - ODBC connection failed
; Author(s):        SEO and unknown
; Note(s):          None
;===============================================================================
Func _SQLConnect($sServer, $sDatabase, $fAuthMode = 0, $sUsername = "", $sPassword = "", $sDriver = "{SQL Server}")
    Local $sTemp = StringMid($sDriver, 2, StringLen($sDriver) - 2)
    Local $sKey = "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers", $sVal = RegRead($sKey, $sTemp)
    If @error or $sVal = "" Then Return SetError(2, 0, 0)
    $oConn = ObjCreate("ADODB.Connection")
	
    If NOT IsObj($oConn) Then Return SetError(3, 0, 0)
    If $fAuthMode Then $oConn.Open ("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";")
    If NOT $fAuthMode Then $oConn.Open("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase)
    If @error Then Return SetError(1, 0, 0)
    Return $oConn
EndFunc   ;==>_SQLConnect

;===============================================================================
;
; Function Name:    _SQLConnect
; Description:      Send a query to a SQL database and return the results as an object
; Syntax:           $oQuery = _SQLQuery($oConn, $sQuery)
; Parameter(s):     $oConn - A database connection object created by a previous call to _SQLConnect
;                   $sQuery - The SQL query string to be executed by the SQL server
; Requirement(s):   Autoit 3 with COM support
; Return Value(s):  On success - returns the query result as an object
;                   On failure - returns 0 and sets @error:
;                       @error=1 - Unable to process the query
; Author(s):        SEO and unknown
; Note(s):          None
;
;===============================================================================
Func _SQLQuery($oConn, $sQuery)
    If IsObj($oConn) Then Return $oConn.Execute($sQuery)
    Return SetError(1, 0, 0)
EndFunc ;==>_SQLQuery

;===============================================================================
;
; Function Name:    _SQLDisconnect
; Description:      Disconnect and close an existing connection to a SQL database
; Syntax:           _SQLDisconnect($oConn)
; Parameter(s):     $oConn - A database connection object created by a previous call to _SQLConnect
; Requirement(s):   Autoit 3 with COM support
; Return Value(s):  On success - returns 1 and closes the ODBC connection
;                   On failure - returns 0 and sets @error:
;                       @error=1 - Database connection object doesn't exist
; Author(s):        SEO and unknown
; Note(s):          None
;
;===============================================================================
Func _SQLDisconnect($oConn)
    If NOT IsObj($oConn) Then Return SetError(1, 0, 0)
    $oConn.Close
    Return 1
EndFunc   