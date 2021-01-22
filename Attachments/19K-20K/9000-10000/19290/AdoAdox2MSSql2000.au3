AutoItSetOption("MustDeclareVars",1)

Dim $oConn1
Dim $oRS1

Dim $server = "."; local server
Dim $user = "sa";The user
Dim $pass = "password";The ......... password !!!
Dim $dbname = "NorthWind";the database

Dim $adCmdUnspecified = -1 ;Ne spécifie pas l'argument type de la commande. 
Dim $adCmdText = 1 ;CommandText correspond à la définition textuelle d'une commande ou d'un appel de procédure stockée. 
Dim $adCmdTable = 2 ;CommandText correspond au nom de la table dont les colonnes sont toutes renvoyées par une requête SQL générée en interne. 
Dim $adCmdStoredProc = 4 ;CommandText correspond au nom d'une procédure stockée. 
Dim $adCmdUnknown = 8 ;Valeur par défaut. Indique que le type de commande spécifié dans la propriété CommandText n'est pas connu. 
Dim $adCmdFile = 256 ;CommandText correspond au nom de fichier d'un Recordset stocké de façon permanente. 
Dim $adCmdTableDirect = 512 ;CommandText correspond au nom d'une table dont les colonnes sont toutes renvoyées. 

Dim $adOpenForwardOnly = 0 ;Valeur par défaut. Utilise un curseur à défilement en avant. Identique à un curseur statique mais ne permettant que de faire défiler les enregistrements vers l'avant. Ceci accroît les performances lorsque vous ne devez effectuer qu'un seul passage dans un Recordset. 
Dim $adOpenKeyset = 1 ;Utilise un curseur à jeu de clés. Identique à un curseur dynamique mais ne permettant pas de voir les enregistrements ajoutés par d'autres utilisateurs (les enregistrements supprimés par d'autres utilisateurs ne sont pas accessibles à partir de votre Recordset). Les modifications de données effectuées par d'autres utilisateurs demeurent visibles. 
Dim $adOpenDynamic = 2 ;Utilise un curseur dynamique. Les ajouts, modifications et suppressions effectués par d'autres utilisateurs sont visibles et tous les déplacements sont possibles dans le Recordset à l'exception des signets, s'ils ne sont pas pris en charge par le fournisseur. 
Dim $adOpenStatic = 3 ;Utilise un curseur statique. Copie statique d'un jeu d'enregistrements qui permet de trouver des données ou de générer des états. Les ajouts, modifications ou suppressions effectués par d'autres utilisateurs ne sont pas visibles. 
Dim $adOpenUnspecified = -1 

Dim $adLockBatchOptimistic =4 ;Mise à jour par lot optimiste. Obligatoire en mode de mise à jour par lots. 
Dim $adLockOptimistic =3 ;Verrouillage optimiste, un enregistrement à la fois. Le fournisseur utilise le verrouillage optimiste et ne verrouille les enregistrements qu'à l'appel de la méthode Update. 
Dim $adLockPessimistic =2 ;Verrouillage pessimiste, un enregistrement à la fois. Le fournisseur assure une modification correcte des enregistrements, et les verrouille généralement dans la source de données dès l'édition. 
Dim $adLockReadOnly =1 ;Enregistrements en lecture seule. Vous ne pouvez pas modifier les données. 
Dim $adLockUnspecified =-1 

Dim $strConnexion = "DRIVER={SQL Server};SERVER=" & $server & ";DATABASE=" & $dbname & ";uid=" & $user & ";pwd=" & $pass & ";"
Dim $strSqlQuery = "sp_oledb_database" ; a MsSql2000 stored proc of master database !
Dim $IntRetour = 0
Dim $intNbLignes = 0
Dim $Sepa = String(@TAB&"  "&@TAB)

$oConn1 = ObjCreate("ADODB.Connection")
$oRS1 = ObjCreate("ADODB.Recordset")

$oConn1.open($strConnexion)
$oRS1.open($strSqlQuery,$oConn1,$adOpenKeyset,$adLockOptimistic,$adCmdStoredProc)
$intNbLignes = $oRS1.recordCount
$oRS1.MoveFirst
For $i = 0 To $intNbLignes -1
	ConsoleWrite($oRS1.Fields.Item(0).value & @CRLF)
$oRS1.MoveNext
Next 
$oRS1.close
$oConn1.close