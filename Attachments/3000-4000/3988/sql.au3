; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Functions to handle SQL databases.
;
; ------------------------------------------------------------------------------
Func _SQLConnect($server, $db, $username, $password)
	Global $adCN ;<==Declare variable
	$adCN = ObjCreate ("ADODB.Connection") ;<==Create SQL connection
	$adCN.Open ("DRIVER={SQL Server};SERVER=" & $server & ";DATABASE=" & $db & ";uid=" & $username & ";pwd=" & $password & ";") ;<==Connect with required credentials
EndFunc
Func _SQLClose ()
	$adCN.Close ;==>Close the database
EndFunc
Func _SQLExecute( $query )
	$adCN.Execute ( $query )
EndFunc