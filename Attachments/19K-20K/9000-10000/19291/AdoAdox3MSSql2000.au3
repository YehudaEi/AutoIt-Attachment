AutoItSetOption("MustDeclareVars",1)

Dim $oConn1
Dim $oRS1 ;For Stored Proc test !
Dim $oRS2 ; For Sql Query test !

Dim $server = "."; local server
Dim $user = "sa";The user
Dim $pass = "password";The ......... password !!!
Dim $dbname = "NorthWind";the database

Dim $adOpenForwardOnly = 0 ;Valeur par d�faut. Utilise un curseur � d�filement en avant. Identique � un curseur statique mais ne permettant que de faire d�filer les enregistrements vers l'avant. Ceci accro�t les performances lorsque vous ne devez effectuer qu'un seul passage dans un Recordset. 
Dim $adOpenKeyset = 1 ;Utilise un curseur � jeu de cl�s. Identique � un curseur dynamique mais ne permettant pas de voir les enregistrements ajout�s par d'autres utilisateurs (les enregistrements supprim�s par d'autres utilisateurs ne sont pas accessibles � partir de votre Recordset). Les modifications de donn�es effectu�es par d'autres utilisateurs demeurent visibles. 
Dim $adOpenDynamic = 2 ;Utilise un curseur dynamique. Les ajouts, modifications et suppressions effectu�s par d'autres utilisateurs sont visibles et tous les d�placements sont possibles dans le Recordset � l'exception des signets, s'ils ne sont pas pris en charge par le fournisseur. 
Dim $adOpenStatic = 3 ;Utilise un curseur statique. Copie statique d'un jeu d'enregistrements qui permet de trouver des donn�es ou de g�n�rer des �tats. Les ajouts, modifications ou suppressions effectu�s par d'autres utilisateurs ne sont pas visibles. 
Dim $adOpenUnspecified = -1 

Dim $adLockBatchOptimistic =4 ;Mise � jour par lot optimiste. Obligatoire en mode de mise � jour par lots. 
Dim $adLockOptimistic =3 ;Verrouillage optimiste, un enregistrement � la fois. Le fournisseur utilise le verrouillage optimiste et ne verrouille les enregistrements qu'� l'appel de la m�thode Update. 
Dim $adLockPessimistic =2 ;Verrouillage pessimiste, un enregistrement � la fois. Le fournisseur assure une modification correcte des enregistrements, et les verrouille g�n�ralement dans la source de donn�es d�s l'�dition. 
Dim $adLockReadOnly =1 ;Enregistrements en lecture seule. Vous ne pouvez pas modifier les donn�es. 
Dim $adLockUnspecified =-1 

Dim $adCmdUnspecified = -1 ;Ne sp�cifie pas l'argument type de la commande. 
Dim $adCmdText = 1 ;CommandText correspond � la d�finition textuelle d'une commande ou d'un appel de proc�dure stock�e. 
Dim $adCmdTable = 2 ;CommandText correspond au nom de la table dont les colonnes sont toutes renvoy�es par une requ�te SQL g�n�r�e en interne. 
Dim $adCmdStoredProc = 4 ;CommandText correspond au nom d'une proc�dure stock�e. 
Dim $adCmdUnknown = 8 ;Valeur par d�faut. Indique que le type de commande sp�cifi� dans la propri�t� CommandText n'est pas connu. 
Dim $adCmdFile = 256 ;CommandText correspond au nom de fichier d'un Recordset stock� de fa�on permanente. 
Dim $adCmdTableDirect = 512 ;CommandText correspond au nom d'une table dont les colonnes sont toutes renvoy�es. 

Dim $IntRetour = 0
Dim $intNbLignes = 0
;~ Dim $Sepa = String(@TAB); for having tab for separator !
Dim $Sepa = ";" ;like CSV

Dim $strConnexion = "DRIVER={SQL Server};SERVER=" & $server & ";DATABASE=" & $dbname & ";uid=" & $user & ";pwd=" & $pass & ";"
$oConn1 = ObjCreate("ADODB.Connection")
$oConn1.open($strConnexion)


;For a test of a store proc in Master database of Micr@s@ft MsSql2000 
Dim $strSqlQuerySP = "sp_oledb_database" ; a MsSql2000 stored proc of master database !
$oRS1 = ObjCreate("ADODB.Recordset")
$oRS1.open($strSqlQuerySP,$oConn1,$adOpenKeyset,$adLockOptimistic,$adCmdStoredProc)
$intNbLignes = $oRS1.recordCount
$oRS1.MoveFirst
For $i = 0 To $intNbLignes -1
	ConsoleWrite($oRS1.Fields.Item(0).value & @CRLF)
$oRS1.MoveNext ; DON'T FORGET THIS OR CRASH...!!!
Next 
$oRS1.close

;For a test of a simple text Query
Dim $strSqlQuerySelect = "select * from customers"
$oRS2 = ObjCreate("ADODB.Recordset")
$oRS2.open($strSqlQuerySelect,$oConn1,$adOpenStatic,$adLockOptimistic,$adCmdText)
$intNbLignes = $oRS2.recordCount ;i re-use $intNbLignes !
;For getting Fields Header Names...
For $j = 0 To $oRS2.Fields.count -1
	ConsoleWrite($oRS2.Fields($j).name & $Sepa)
Next
ConsoleWrite (@CRLF);to rewind 
For $i = 0 To $intNbLignes -1 ; or "For $i = 0 To ($oRS2.recordCount - 1)" if you want
	For $j = 0 To $oRS2.Fields.count -1
		ConsoleWrite($oRS2.Fields($j).value & $Sepa)
	Next
	ConsoleWrite (@CRLF);to begin the next line
	$oRS2.MoveNext ; DON'T FORGET THIS OR CRASH...!!!
Next
$oRS2.close

$oConn1.close