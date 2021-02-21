#include <SQLite.au3>
#include <SQLite.dll.au3>
#comments-start
Script's data:
    Name:       CheckDataBase (SQLite)
    Version:    0.05
    Date:       14 July 2.011
Script's author
    Name:       Detefon
    e-mail:     herbivoro@ig.com.br

This is a very simple script to validate some parts of your database.
The error code is a hex number of sum of all decimal errors.
#comments-end
ConsoleWrite(CheckDataBase("BannerCliente.db","CLIENTES","NOME"))

Func CheckDataBase($DataBase,$Table,$Fields)

;	Versao:	0.05
;	If everything is ok, the script return 0.
;	Have a error, return the error code.
;		Error code: 1 (don't exist SQLite)
;		Error code: 2 (SQLite error version )
;		Error code: 4 (does not exist file '$DataBase')
;		Error code: 8 (error to open '$DataBase')
;		Error code: 16 (error in _SQLite_QuerySingleRow)
;		Error code: 32 (does not exist '$Table' in '$DataBase')
;		Error code: 64 (some field required does not exist)
;		Error code: 128 (error to clos database) (not test yet)
;	$Fields must be like = "name" or "name,age" or "name,age,city,country"

Local $ErrorCode = 0
Local $Query
Local $TableTemp = ""
Local $Banco, $QueryResultado, $SQL, $SQLConsulta, $SQLConsultaQuantidade
Local $Consulta = 0
;	Check if exist SQLite
Local $SQLiteDll = _SQLite_Startup ()
If @error Then $ErrorCode += 1
;	Check version's SQLite
Local $SQLiteVersao = _SQLite_LibVersion()
If @error Then $ErrorCode += 2
;	Check if exist 'database.db'
If FileExists($DataBase) = 0 Then
$ErrorCode += 4
$TableTemp = " Erro:" & $DataBase
Else
;	Check if exist the 'Table' in the 'database.db'
$Banco = _SQLite_Open ($DataBase)
If @error Then $ErrorCode += 8
Local $Query = _SQLite_QuerySingleRow(-1,"SELECT name FROM sqlite_master where name='" & $Table & "';",$QueryResultado)
If @error Then $ErrorCode += 16
If $Table <> $QueryResultado[0] Then
$ErrorCode += 32
$TableTemp = " Erro:" & $Table
Else
;	Verificando os campos na tabela
;	Se existirem um (ou todos) os campos consultados na tabela, a respostar afirmativa deverá ser ZERO
;	Caso contrário, algum campo consultado inexiste na tabela.
;	Check all fields in the table
;	If exist one (or all), the fields required in the table, in afirmative case, the answer must be zero.
;	If miss one or more filds in the consult the error code is showed.
$Query = _SQLite_QuerySingleRow(-1,"SELECT sql FROM sqlite_master where name='" & $Table & "';",$QueryResultado)
$SQL = StringSplit($QueryResultado[0],"(")
$SQL = StringReplace($SQL[2],")","")
$SQL = StringReplace($SQL," INTEGER PRIMARY KEY","")
$SQL = StringReplace($SQL," TEXT","")
$SQL = StringReplace($SQL," INTEGER","")
$SQL = StringReplace($SQL," REAL","")
$SQL = StringReplace($SQL," BLOB","")
$SQL = StringReplace($SQL," ","")
$SQL = StringSplit($SQL,",")
$SQLConsulta = StringSplit($Fields,",")
$SQLConsultaQuantidade = $SQLConsulta[0]
For $a = 1 to $SQLConsultaQuantidade
	For $b = 1 to $SQL[0]
		If $SQL[$b] = $SQLConsulta[$a] Then $Consulta +=1
	Next
Next
IF $Consulta < $SQLConsultaQuantidade Then $ErrorCode += 64
EndIf
EndIf
_SQLite_QueryFinalize($Query)
_SQLite_Close($DataBase)
;If @error Then $ErrorCode += 128  (verificar)
_SQLite_Shutdown()
Return "0x" & Hex($ErrorCode,6) & $TableTemp
EndFunc