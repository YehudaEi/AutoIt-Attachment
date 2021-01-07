;Monitoring BI Servers
;BO 5 monitoring script ressources
;Script written by Fabien Lepicard
;Business Intelligence Tools
;3M
;this script permit to use file properties
;=================================================================================================================================================================================

#include <file.au3>
;~ #include <Sql_BO5US.au3>

Func WriteDataFile($startLogon, $endLogon, $deltaLogon, $startRefresh, $endRefresh, $deltaRefresh, $status, $countryName, $placeName, $ipWorkstation, $reportName, $applicationName)
; try tto open the file if it's existing in write append mode
$file = FileOpen("metrics_BO5-US.txt", 1)
; if it's not existing create it and open it in write append mode
If $file = -1 Then
    _FileCreate("metrics_BO5-US.txt")
	$file = FileOpen("metrics_BO5-US.txt", 1)
	FileWrite($file, "metrics_BO5-US" & @CRLF)
EndIf
; write metrics in the file
FileWrite($file, $startLogon & ",")
FileWrite($file, $endLogon & ",")
FileWrite($file, $deltaLogon & ",")
FileWrite($file, $startRefresh & ",")
FileWrite($file, $endRefresh & ",")
FileWrite($file, $deltaRefresh & ",")
FileWrite($file, $status & ",")
FileWrite($file, $countryName & ",")
FileWrite($file, $placeName & ",")
FileWrite($file, $ipWorkstation & ",")
FileWrite($file, $reportName & ",")
FileWrite($file, $applicationName)
FileWrite($file, @CRLF)
; close the file
FileClose($file)
EndFunc

Func ReadValueIniFile($fileName,$section,$key,$default)
	$value=IniRead($fileName,$section,$key,$default)
	Return $value
EndFunc

;~ Func ReadDataFile($db_srv, $db_name, $db_usr, $db_pwd)
;~ 	; init variables
;~ 	$connexion=0
;~ 	$success=True
;~ 	; open the file
;~ 	$file = FileOpen("metrics_BO5_US.txt", 0)
;~ 	; read the content of the file
;~ 	While 1
;~ 		; read the line
;~ 		$line = FileReadLine($file)
;~  		; if @error=1 => EOF
;~ 		If @error = -1 Then ExitLoop
;~ 		; split the readline in an array
;~ 		$tab=StringSplit($line,",")
;~ 		; initialize variables with each array value
;~ 		$startLogon=$tab[1]		
;~ 		$endLogon=$tab[2]
;~ 		$deltaLogon=Number($tab[3])
;~ 		$startRefresh=$tab[4]
;~ 		$endRefresh=$tab[5]
;~ 		$deltaRefresh=Number($tab[6])
;~ 		$status=Number($tab[7])
;~ 		$countryName=$tab[8]
;~ 		$placeName=$tab[9]
;~ 		$ipWorkstation=$tab[10]
;~ 		$reportName=$tab[11]
;~ 		$applicationName=$tab[12]
;~ 		
;~ 		if Not ($connexion=1) then $connexion=_SQLConnect($db_srv, $db_name, $db_usr, $db_pwd)
;~ 			
;~ 		If ($connexion=1) Then
;~ 			; open the connection to the database
;~ 			; fill fields for the SQL Query
;~ 			$sqlQuery=_SQLInsertQuery($startLogon, $endLogon, $deltaLogon, $startRefresh, $endRefresh, $deltaRefresh, $status, $countryName, $placeName, $ipWorkstation, $reportName, $applicationName)
;~ 			; execute the INSERT query to plot the data
;~ 			_SQLExecute($sqlQuery)
;~ 			; close the connection to the database
;~ 			_SQLClose () 
;~ 		Else
;~ 			$success=False
;~ 			ExitLoop
;~ 		EndIf
;~ 		
;~ 	Wend
;~ 	; close the file
;~ 	FileClose($file)
;~ 	; delete the file 
;~ 	if $success==True then FileDelete ("metrics_BO5_US.txt")
;~ EndFunc