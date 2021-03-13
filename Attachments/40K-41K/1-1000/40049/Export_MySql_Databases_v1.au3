#include <Array.au3>
#include <Constants.au3>

; ------------------------------------------------------------------------
; BACKUP MYSQL DATABASES ON LOCALHOST
; ------------------------------------------------------------------------
; Definition and meaning:
; $export_defs .....	combine two constants: $cEXPORT_DB + ($cEXPORT_TO_... or $cEXPORT_AS_...)
;    e.g. [ $cEXPORT_DB_ALL_DATABASES + $cEXPORT_TO_SINGLE_FILE ] => export all dbs to one file
; $custom_dbs ...... user-created databases. Use comma as separator, e.g. "drupal, joomla"
; $export_path ..... an export destination folder
; $dbUsr ........... user login credentials, usually 'root'
; $dbPwd ........... passwords for MySQL accounts
; $dbSrv ........... MySQL server, 127.0.0.1 for localhost
; $sMySqlPath ...... full path to MySQL bin directory
; $sSytemDbs ....... list of databases created during installation MySql app

; use this constants in variable $export_defs:
Const $cEXPORT_DB_SYSTEMS_ONLY		= 1		; export default databases (e.g. XAMPP default databases)
Const $cEXPORT_DB_NON_SYSTEMS		= 2		; export user-created databases (e.g. all non XAMPP default dbs)
Const $cEXPORT_DB_ALL_DATABASES		= 4		; export all databases
Const $cEXPORT_DB_CUSTOM_DATABASES	= 8		; export selected databases (e.g. 'Drupal' database only)

Const $cEXPORT_TO_SINGLE_FILE		= 128	; export databases as one .sql file
Const $cEXPORT_AS_SEPARATE_FILES	= 256	; export each stored database as separate .sql file

;=== user definition ===================================================>>
Local $export_defs	= $cEXPORT_DB_CUSTOM_DATABASES + $cEXPORT_AS_SEPARATE_FILES
;Local $export_defs	= $cEXPORT_DB_NON_SYSTEMS + $cEXPORT_TO_SINGLE_FILE
Local $custom_dbs	= "drupal" ; as separator use comma, e.g. "drupal, joomla"
Local $export_path 	= "E:\Backup\FullBackup\Aplikace\MySQL"
Local $dbUsr 		= "root"
Local $dbPwd 		= "123456"
Local $dbSrv 		= "127.0.0.1"
Local $sMySqlPath	= "C:\xampp\mysql\bin\"
Local $sSytemDbs 	= "cdcol, information_schema, mysql, performance_schema , phpmyadmin, test, webauth"
;=== user definition ====  (Do not change anything below this line) ====<<

$export_path		= StringRegExpReplace($export_path, "[\\/]+\z", "") & "\"
$sMySqlPath			= StringRegExpReplace($sMySqlPath, "[\\/]+\z", "") & "\"
Local $sMySqlExe	= FileGetShortName($sMySqlPath & "mysql.exe")
Local $sMySqlDmpExe	= FileGetShortName($sMySqlPath & "mysqldump.exe")
Local $sFormat 		= "%s -u %s -p%s -h%s %s -e ""show databases"" -s -N"
Local $sExtCmd 		= StringFormat($sFormat, $sMySqlExe, $dbUsr, $dbPwd, $dbSrv)
Local $aSytemDbs	= StringSplit(StringStripWS($sSytemDbs, 8), ",", 2)
Const $2L 			= @LF & @LF

If FileExists($sMySqlExe) <> 1 Then
	MsgBox(8240, "MySql.exe not found", "The mysql.exe not found!" & $2L & _
	  "The path '$export_path' is probably not being set properly.")
	Exit
EndIf

; run in cmd
Local $CMD = Run(@ComSpec & " /c " & $sExtCmd, "", @SW_HIDE, $STDERR_CHILD+$STDOUT_CHILD)
ProcessWaitClose($CMD)
Local $sMsg = StdoutRead($CMD)
Local $sErr = StderrRead($CMD)

; if an error in mysql.exe (eg. server is not running)
If StringInStr($sErr, "ERROR") <> 0 Then
	MsgBox(8208, "Error", $sErr)
	Exit
EndIf
If StringLen($sMsg) = 0 Then
	MsgBox(8208, "Error", "Failed to get databases names")
	Exit
EndIf

; read all installed databases to $aAllDbs array
Local $aAllDbs = StringSplit($sMsg, Chr(13), 2)
For $i = UBound($aAllDbs) - 1 To 0 Step -1
	$aAllDbs[$i] = StringStripWS($aAllDbs[$i],3)
    If StringLen($aAllDbs[$i]) = 0 Then
        _ArrayDelete($aAllDbs, $i)
    EndIf
Next

; move requested names of databases to $aDbs array
Select
	Case BitAND($export_defs, $cEXPORT_DB_SYSTEMS_ONLY) <> 0
		$aDbs = $aSytemDbs
		Local $sResult = fncItemsInArray($aDbs, $aAllDbs)
		If @error Then
			MsgBox(8240, "Error", "Defined system database name '" & $sResult & "' not found!")
			Exit
		EndIf
	Case BitAND($export_defs, $cEXPORT_DB_NON_SYSTEMS) <> 0
		$aDbs = fncArrayExclude($aAllDbs, $aSytemDbs)
	Case BitAND($export_defs, $cEXPORT_DB_ALL_DATABASES) <> 0
		$aDbs = $aAllDbs
	Case BitAND($export_defs, $cEXPORT_DB_CUSTOM_DATABASES) <> 0
		$aDbs = StringSplit(StringStripWS($custom_dbs, 8), ",", 2)
		Local $sResult = fncItemsInArray($aDbs, $aAllDbs)
		If @error Then
			MsgBox(8240, "Error", "Defined custom database name '" & $sResult & "' not found!")
			Exit
		EndIf
EndSelect

; export
Local $sOutFile
Local $sFileFirstPart = $export_path & @YEAR & @MON & @MDAY & "." & @HOUR & @MIN & @SEC
$sFormat = "%s --lock-all-tables -u %s -p%s -h%s %s > " & """" & "%s" & """"
Select
	Case BitAND($export_defs, $cEXPORT_TO_SINGLE_FILE) <> 0
		$sOutFile = FileGetShortName($sFileFirstPart & "_" & _ArrayToString($aDbs, ",") & ".sql")
		$sExtCmd  = StringFormat($sFormat, $sMySqlDmpExe, $dbUsr, $dbPwd, $dbSrv, "-B " & _
		  _ArrayToString($aDbs, " "), $sOutFile)
		$CMD = RunWait(@ComSpec & " /c " & $sExtCmd, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		If FileExists($sOutFile) = 0 Then
			MsgBox(8208, "Error", "An error occurring during the export..." & $2L & "databases: " & _
			  _ArrayToString($aDbs, ", ") & @LF & "destination: " & $sOutFile)
			Exit
		EndIf

	Case BitAND($export_defs, $cEXPORT_AS_SEPARATE_FILES) <> 0
		For $x = 0 To UBound($aDbs) - 1
			$sOutFile = FileGetShortName($sFileFirstPart & "_" & $aDbs[$x] & ".sql")
			$sExtCmd  = StringFormat($sFormat, $sMySqlDmpExe, $dbUsr, $dbPwd, $dbSrv, $aDbs[$x], $sOutFile)
			$CMD = RunWait(@ComSpec & " /c " & $sExtCmd, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			If FileExists($sOutFile) = 0 Then
				MsgBox(8208, "Error", "An error occurring during the export..." & $2L & "database: " & _
				  $aDbs[$x] & @LF & "destination: " & $sOutFile)
				Exit
			EndIf
		Next
	EndSelect

; final msg
$sFormat = "%s database%s was exported:%s%s%sTo destination:%s%s"
$sMsg = StringFormat($sFormat, UBound($aDbs), _iIf(UBound($aDbs) > 1, "s", ""), $2L, "- " & _
  _ArrayToString($aDbs, @LF & "- "), $2L, $2L, $export_path)
MsgBox(8256, "Done", $sMsg)

Exit
; -------------------------------------------------------------------
; Check if all items from $aSrc are included in $aCmp
; -------------------------------------------------------------------
Func fncItemsInArray($aSrc, $aCmp)
	Local $bFound, $i, $j
	For $i = 0 To UBound($aSrc) - 1
		$bFound = False
		For $j = 0 To UBound($aCmp) - 1
			If $aSrc[$i] = $aCmp[$j] Then
				$bFound = True
				ExitLoop
			EndIf
		Next
		If $bFound = False Then
			SetError(1)
			Return $aSrc[$i]
		EndIf
	Next
	Return 1
EndFunc ;==>> fncItemsInArray

; -------------------------------------------------------------------
; Exclude items from array based on another array
; $iFirstIdx1: ... first index of $aAll
; $iFirstIdx2: ... first index of $aExclude
; -------------------------------------------------------------------
Func fncArrayExclude($aAll, $aExclude, $iFirstIdx1=0, $iFirstIdx2=0)
	Local $bFound, $i, $j, $aResult[1]
	For $i = $iFirstIdx1 To UBound($aAll) - 1
		$bFound = False
		For $j = $iFirstIdx2 To UBound($aExclude) - 1
			If $aAll[$i] = $aExclude[$j] Then
				$bFound = True
				ExitLoop
			EndIf
		Next
		If $bFound = False Then
			If StringLen($aResult[0]) <> 0 Then
				ReDim $aResult[UBound($aResult) + 1]
			EndIf
			$aResult[UBound($aResult)-1] = $aAll[$i]
		EndIf
	Next
	Return $aResult
EndFunc ; ==>> fncArrayExclude

; -------------------------------------------------------------------
; _Iif from MISC
; -------------------------------------------------------------------
Func _Iif($fTest, $vTrueVal, $vFalseVal)
	If $fTest Then
		Return $vTrueVal
	Else
		Return $vFalseVal
	EndIf
EndFunc ;==>_Iif
