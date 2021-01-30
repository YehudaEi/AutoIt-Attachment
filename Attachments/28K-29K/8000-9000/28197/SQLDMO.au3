#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\favicon.ico
#AutoIt3Wrapper_outfile=C:\Documents and Settings\User\Desktop\sql.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
;	All variables must be declared before using
Opt("MustdeclareVars", 1)
; =======================================================================
; SQLDMO Object wrapper
; =======================================================================
; ------------------------------------------------------------------------------
Global $objSQLDMO
Global $objDatabase
Global $strLastDatabase = ""
Global $bCommError = 0  		; to be checked to know if com error occurs. Must be reset after handling.
Local $bSQLConnected = False	;	Currently not connected to SQL
Local $oCOMError = ObjEvent("AutoIt.Error","MyErrFunc") ; Install a custom error handler


Func SQLSERVER_OpenConnection($strServer="(local)",$strUserName="sa",$strPassword="")
Local $bReturn = True
	$bCommError = 0  ;	Reset Comm Error
	$objSQLDMO = ObjCreate("SQLDMO.SQLServer")
	If IsObj($objSQLDMO) Then
		;	Attempt Log In
		$objSQLDMO.Connect($strServer,$strUserName,$strPassword)
		;	Check for errors
		if $bCommError Then
			MsgBox(0,"SQL Server","Could Not Connect to Server")
			$bSQLConnected = False
			$bReturn = False
		Else
			$bSQLConnected = True
		EndIf
	Else
		msgbox(0,"SQL Server","SQL Enterprise Manager has not been installed on this computer")
	EndIf
	return $bReturn
EndFunc

Func SQLSERVER_BackupDatabase($strDatabase,$strBackupFolder)
	;	Setup Backup Command
	local $objBackup = ObjCreate("SQLDMO.Backup")
	$objBackup.Database = $strDatabase
	$objBackup.Files = $strBackupFolder & "\" & $strDatabase & ".BAK"
	$objBackup.SQLBackup($objSQLDMO)
EndFunc

Func SQLSERVER_RestoreDatabase($strDatabase,$strBackupFile)
	;	Check that Backup File Exists
	if not FileExists($strBackupFile) Then
		MsgBox(0,"SQL Server","SQL Backup does not exist")
		Return False
	EndIf
	;	Check that database exists within SQL Server
	local $tmpDatabase = LocateDatabase($strDatabase)
	if not IsObj($tmpDatabase) Then
		MsgBox(0,"SQL Server","Could not locate database")
		Return False
	EndIf
	$tmpDatabase = 0
	;	Setup Backup Command
	local $objRestore = ObjCreate("SQLDMO.Restore")
	$objRestore.Database = $strDatabase
	$objRestore.Files = $strBackupFile
	$objRestore.ReplaceDatabase = True
	$objRestore.SQLRestore($objSQLDMO)
EndFunc

Func SQLSERVER_CompileSQLJob($strSQLJobFile)
	$bCommError = 0  ;	Reset Comm Error
	if $bSQLConnected = True Then
		if FileExists($strSQLJobFile) Then
			;	Load SQL Job
			local $hFileHandle = FileOpen($strSQLJobFile,0)
			;	Load SQLScript
			local $strSQLScript = FileRead($hFileHandle)
			FileClose($hFileHandle)
			;	Run Compile Scripts
			SQLSERVER_ExecuteScript($strSQLScript)
		Else
			MsgBox(0,"SQL Server","SQL Job does not exist")
			Return False
		EndIf
	Else
		MsgBox(0,"SQL Server","Not Connected to SQL Server")
		Return False
	EndIf
	return True
EndFunc

Func SQLSERVER_ExecuteScript($strSQLScript)
	$bCommError = 0  ;	Reset Comm Error
	if $bSQLConnected = True Then
		;	Run Compile Scripts
		$objSQLDMO.ExecuteImmediate($strSQLScript,0)
	Else
		MsgBox(0,"SQL Server","Not Connected to SQL Server")
		Return False
	EndIf
	return True
EndFunc

Func SQLSERVER_ExecuteDatabaseScript($strDatabase,$strSQLScript)
	$bCommError = 0  ;	Reset Comm Error
	if $bSQLConnected = True Then
		;	Pick Up Database
		if $strLastDatabase<>$strDatabase Then
			$objDatabase = LocateDatabase($strDatabase)
			if not IsObj($objDatabase) Then
				MsgBox(0,"SQL Server","Could not locate database")
				Return False
			EndIf
			$strLastDatabase = $strDatabase
		EndIf
		;	Run Compile Scripts
		$objDatabase.ExecuteImmediate($strSQLScript,0)
	Else
		MsgBox(0,"SQL Server","Not Connected to SQL Server")
		Return False
	EndIf
	return True
EndFunc

Func LocateDatabase($strDatabase)
	$objDatabase = 0
	for $lDB in $objSQLDMO.Databases
		if $lDB.Name = $strDatabase Then
			$objDatabase = $lDB
		EndIf
	Next
	return $objDatabase
EndFunc

; This is my custom error handler
Func MyErrFunc()
	Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"      & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oCOMError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oCOMError.windescription & @CRLF & _
             "err.number is: "         & @TAB & hex($oCOMError.number,8)  & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oCOMError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oCOMError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oCOMError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oCOMError.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $oCOMError.helpcontext _
            )


   $bCommError = 1 ; something to check for when this function returns
Endfunc
