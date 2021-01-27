
;**********************************************************************************************************************
;**********************************************************************************************************************
;Programa que borra las unidades de red mapeadas por defecto del usuario logueado en la máquina
;y le asigna unas nuevas unidades dependiendo de los grupos a los que pertenezca en el Active Directory de Windows
;Las nuevas unidades se buscarán en una Base de Datos Access 2003
;Y serán montadas según algunas preferencias del Usuario o según sus permisos o las que tenga asignadas.
;**********************************************************************************************************************
;**********************************************************************************************************************

#include <WinNet.au3>
#include <AD.au3>
#include <Array.au3>
#Include <WinAPI.au3>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global $asGroups[1] 
_ADGetUserGroups($asGroups, @UserName) 
_ArrayDisplay($asGroups)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-------------------------------------------------------------
Dim $usuario = @UserName															; Guarda el Nombre de Usuario
Dim $nombrecomputadora = @ComputerName 												; Guarda el Nombre de la Computadora
																					; Lista las unidades
$var = DriveGetDrive( "all" )
If NOT @error Then
	MsgBox(4096,"", "Encontrada " & $var[0] & " Unidades")
	For $i = 1 to $var[0]
		MsgBox(4096,"Unidad " & $i, $var[$i])
	Next
EndIf
;--------------------------------------------------------------



MsgBox(0, "Usuario actual conectado:", $usuario)									; Muestra el usuario logueado
MsgBox(0, "Nombre computadora desde la que se conecta:", $nombrecomputadora)		; Muestra el terminal

																					; Desconectamos todas las unidades virtuales
RunWait(@COMSPEC & " /c echo Desconectando unidades")
RunWait(@COMSPEC & " /c net use * /d /y") 											; net use [/DELETE:{yes | no}]]

;(Variables para la BBDD)
$prueba="Informatica-Sistemas"
Dim $salida2
Dim $nombredbuser = "E:\mapeando.mdb"												; Ruta de la BBDD de los usuarios
Dim $nombredbdepart = "E:\mapeando2.mdb"											; Ruta de la BBDD de los departamentos
Dim $nombretabla = "MAPEO"															; Nombre de la tabla
Dim $query = "SELECT UNIDAD FROM "& $nombretabla &" WHERE USUARIO = "& $usuario		; Consulta Access
Dim $query2 = "SELECT UNIDAD FROM "& $nombredbdepart &" WHERE DEPARTAMENTO = "& $prueba
Dim $title


 MsgBox(0,"Consulta en la Base de Datos...",$query)									; Muestra la consulta

;Obtiene Unidades asignadas al USUARIO por su *** USERNAME ***
Dim $salida
    $adoCon = ObjCreate("ADODB.Connection")
    $adoCon.Open("Driver={Microsoft Access Driver (*.mdb)}; DBQ=" & $nombredbuser)
    $adoRs = $adoCon.Execute($query)
					 MsgBox(0, "Dentro de funcion",$query)
    While Not $adoRs.EOF
		$salida = $adoRs.Fields("UNIDAD").value 
		DriveMapAdd("*",$salida)
		$len = StringLen($salida)
		MsgBox(0, "Longitud de la cadena:", $len)
		
		$result = StringTrimRight($salida, $len)
		MsgBox(0, "Cadena sin los caracteres:", $result)
        $adoRs.MoveNext
    WEnd
	
	$var = DriveGetDrive( "all" )
	If NOT @error Then
		MsgBox(4096,"", "Encontradas " & $var[0] & " Unidades")
		For $i = 1 to $var[0]
			MsgBox(4096,"Drive " & $i, $var[$i])
		Next
	EndIf
	
	MsgBox(0, "DOMINIO", $strDNSDomain)
	MsgBox(0, "SERVIDOR", $strHostServer)
	
    $adoCon.Close




;Obtiene Unidades asignadas al USUARIO por su *** DEPARTAMENTO ***



Local $oUsr   
    $strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $usuario & ");ADsPath;subtree"
    $objRecordSet = $objConnection.Execute ($strQuery)  ; Retrieve the FQDN for the logged on user
    $ldap_entry = $objRecordSet.fields (0).value
    $oUsr = ObjGet($ldap_entry)  ; Retrieve the COM Object for the logged on user
	$usergroups = $oUsr.GetEx ("memberof")
    $count = UBound($usergroups)
MsgBox(0,"strQuery",$strQuery)
MsgBox(0,"strHostServer",$strHostServer)
MsgBox(0,"String DNS Domain",$strDNSDomain)

MsgBox(0, "Perteneces a estos grupos", $count)
MsgBox(0, "Nombre de los grupos???", $ldap_entry)


MsgBox(0, "?", $oUsr.CN)


$stringa=StringSplit($oUsr.CN,".")
$result = StringCompare($stringa[2], "Informatica-Sistemas", 0) ; "0" Not case sensitive
MsgBox(0, "Resultante", $result)
MsgBox(0, "String separado [1]?", $stringa[1])
MsgBox(0, "String separado [2]?", $stringa[2])
MsgBox(0, "String separado [3]?", $stringa[3])
MsgBox(0, "Cadena de prueba para comparar", $prueba)

	

    $adoCon = ObjCreate("ADODB.Connection")
    $adoCon.Open("Driver={Microsoft Access Driver (*.mdb)}; DBQ=" & $nombredbdepart)
					$adoRs = $adoCon.Execute($query2)
					MsgBox(0, "Dentro de funcion",$query2)
					$usergroups = $oUsr.GetEx ("memberof")
					MsgBox(0, "Dentro de funcion",$usergroups)
			While Not $adoRs.EOF
				$salida2 = $adoRs.Fields("UNIDAD").value 
				DriveMapAdd("*",$salida2)
				$len2 = StringLen($salida2)
				MsgBox(0, "Longitud de la cadena:", $len2)		
				$result = StringTrimRight($salida2, $len2)
				MsgBox(0, "Cadena sin los caracteres:", $result)
				$adoRs.MoveNext
			WEnd
	$adoCon.Close
