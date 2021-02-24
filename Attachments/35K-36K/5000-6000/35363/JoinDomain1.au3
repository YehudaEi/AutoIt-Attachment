

;------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
;
;  Funccion del Script:
;  Join Domain - Una Interfaz Grafica para Joinear un PC al Dominio de Active Directory especificando la OU
;
;  Requiere:
;  LUltima Version de AutoIT con Soporte para  COM
;
;
; Author:         Shayro Kabir Mendez
;
; Version 1.0   10/03/2009 Release Inicial
;------------------------------------------------------------------------------
$name1 = "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\ComputerName\ComputerName"
$name2 = "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters"
$name3 = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName"
$name4 = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

$rebootok = 0

$actualname = EnvGet("COMPUTERNAME")

$antwort = InputBox ( "Cambiar Nombre del PC", "Nombre Actual: " & $actualname & @CRLF & @CRLF & "Escriba el nuevo nombre si desea cambiarlo. Necesita Reiniciar para hacerse efectivo.", $actualname, "")

If $antwort = $actualname Then
   $tray_title = "El nombre no fue cambiado !"
   $tray_prompt1 = "El nombre elegido es el mismo que el nombre actual."
   $tray_prompt2 = "No se requieren cambios!"

ElseIf $antwort = "" Then
   $tray_title = "El nombre del PC no fue Cambiado!"
   $tray_prompt1 = "Cancelado"
   $tray_prompt2 = ""

Else
   $antwort2 = MsgBox(36, "Confirmado cambio de Nombre", "Nuevo Nombre " & $antwort & " ?")

   If $antwort2 = 6 Then
      RegWrite($name1,"ComputerName","REG_SZ",$antwort)
      RegWrite($name2,"NV Hostname","REG_SZ",$antwort)
      RegWrite($name3,"ComputerName","REG_SZ",$antwort)
      RegWrite($name4,"NV Hostname","REG_SZ",$antwort)
      $reboot = MsgBox(36, "Nombre del PC escrito en el Sistema ", "Reiniciar ahora ?")
         If $reboot = 6 Then
            $rebootok = 1
            $tray_title = "Nombre del PC Cambiado!"
            $tray_prompt1 = "Preparando para Reiniciar."
            $tray_prompt2 = "Nombre despues de Reiniciar: " & @CRLF & $antwort

         ElseIf $reboot = 7 Then
            $rebootok = 0
            $tray_title = "Nombre del PC Cambiado!"
            $tray_prompt1 = "No Reiniciar por ahora"
            $tray_prompt2 = "Nombre despues de Reiniciar: " & @CRLF & $antwort

         EndIf

   ElseIf $antwort2 = 7 Then
      $tray_title = "El nombre del PC no fue cambiado !"
      $tray_prompt1 = "Cambio de Opinion ?"
      $tray_prompt2 = "No te gusto " & $antwort & ", hmmmm ?!??!?!?"

   EndIf

EndIf
TrayTip ( $tray_title, $tray_prompt1 & @CRLF & $tray_prompt2,"",1)
Sleep (3000)
If $rebootok = 1 Then
Shutdown ( 2 )
EndIf

;------------------------------------------------------------------------------
; Includes and AutoIT Options
;------------------------------------------------------------------------------
#NoTrayIcon
#Include <GUIConstants.au3>
#Include <GuiListView.au3>
#Include <Array.au3>


;------------------------------------------------------------------------------
; Detalles del Dominio
;
; Cambiar estas tres lineas para reflejar su ambiente de produccion
;------------------------------------------------------------------------------
$adDefaultContext	= "DC=Litwareinc,DC=com"
$adDomainController	= "EX07SP1"
$adDomain		= "Litwareinc"


;------------------------------------------------------------------------------
; Nombre de Usuario y Password
;
; Si quiere que se le consulten estos valores en vez de  hardcodearlos aqui entonces
; dejar estos valores en blanco
;------------------------------------------------------------------------------
$adUsername		= ""
$adPassword		= ""

;------------------------------------------------------------------------------
;  Constantes de Active Directory
;------------------------------------------------------------------------------
Const $ldapConnectionString 	= "LDAP://" & $adDomainController & "/" & $adDefaultContext
Const $ouIdentifier		= "OU="
Const $cnIdentifier		= "CN="
Const $ouSeparator		= ","

;------------------------------------------------------------------------------
; Configuration de la Interfaz grafica
;------------------------------------------------------------------------------
$guiWidth		= 790
$guiHeight		= $guiWidth * 0.75
$guiOffset		= $guiHeight / 32
$guiBannerMessage	= "Herramineta para unir PC al Dominio"
$guiWindowTitle		= "Herramineta para unir PC al Dominio"
$guiTooManyResultsTitle	= "Demasiados resultados encontrados seleccionar uno"
$guiJoinButtonTitle	= "Unir al Dominio"
$guiListOUSButtonTitle	= "Listar todas las OUs"
$guiProgressMessage	= "Esperar mientras se consulta el  Active Directory"

;------------------------------------------------------------------------------
; Pedir Nombre de Usuario
;------------------------------------------------------------------------------
If $adUsername = "" Then
	$adUsername        = InputBox("Ingresar nombre de Usuario", "Ingresar el nombre de usuario de la cuenta que quiere usar para " & _
					"unir al dominio el PC. Solo nombre de Usuario" & @LF & @LF & _
					"Ejemplo:" & @LF & "d101715")
	If @error Then
		MsgBox(0, "Error con el nombre de Uusuario - " & @error, "Error procesando nombre de Usuario." & @LF & @LF & _
				"El nombre de Usuario recibido fue:" & @LF & _
				$adUsername & @LF & @LF & _
				"Favor Reiniciar la aplicacion he intentar nuevamente. Si el problema persiste " & _
				"Ingresar la informacion manualemnte en el Script editando el achivo directamente.")
		Exit(900)
	EndIf
EndIf

;------------------------------------------------------------------------------
; Pedir Password
;------------------------------------------------------------------------------
If $adPassword = "" Then
	$adPassword        = InputBox("Insertar Password","Favor Ingresar el  Password:",'','*')
	If @error Then
		MsgBox(0, "Error en el password - " & @error, "Ocurrio un error procesando su password." & @LF & @LF & _
				"Favor Reiniciar la aplicacion he intentar nuevamente. Si el problema persiste " & _
				"Ingresar la informacion manualemnte en el Script editando el achivo directamente.")
		Exit(901)
	EndIf
EndIf

;------------------------------------------------------------------------------
; Inicair el objeto COM para conectarse al Active Directory
;------------------------------------------------------------------------------
$comError 		= ObjEvent("AutoIt.Error", "comError")
$ldapObj		= ObjGet("LDAP:")
$domain 		= $ldapObj.OpenDsObject($ldapConnectionString, $adUsername, $adPassword, 1)
If @error Then
	MsgBox(0,	"Error conectando con el Active Directory", "Error - " & @error & @LF & @LF & _
			"No se puede conectar con el Active Directory." & @LF & @LF & _
			"Favor revisar su Conectividad de red, revisar que su coneccion LDAP " & @LF & _
			"es correcta y que las credenciales suministradas al Script son correctas." & @LF & @LF & _
			"Coneccion LDAP:" & @LF & _
			$ldapConnectionString & @LF & @LF & _
			"Nombre de Usuario:" & @LF & _
			$adUsername)
	GUIDelete()
	Exit(1000)
EndIf

;------------------------------------------------------------------------------
; Iniciar coneccion ADO al Active Directory
;------------------------------------------------------------------------------
$connObj		= ObjCreate("ADODB.Connection")
$connObj.Provider	= "ADsDSOObject"
$connObj.ConnectionTimeout = "1"
$connObj.Open("Proveedor del Active Directory", $adDomain & "\" & $adUsername, $adPassword)

;------------------------------------------------------------------------------
; Consultando y guardando el nombre del PC que esta ejecutando esta aplicacion
;------------------------------------------------------------------------------
$computername	= returnComputerName()

;------------------------------------------------------------------------------
; Creando Interfaz Grafica
;------------------------------------------------------------------------------
$joinDomainGUI		= GUICreate($guiWindowTitle,$guiWidth,$guiHeight,-1,-1,BitOR($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_GROUP,$WS_CAPTION,$WS_POPUP,$WS_SYSMENU))

;------------------------------------------------------------------------------
; Creando Banner
;------------------------------------------------------------------------------
$bannerText		= GUICtrlCreateLabel($guiBannerMessage, $guiOffset,$guiOffset, $guiWidth*0.75)
$bannerTextFont		= GUICtrlSetFont($bannerText, 10, 600)

;------------------------------------------------------------------------------
; Creando Boton "Unir al Dominio"
;------------------------------------------------------------------------------
$joinButton 		= GUICtrlCreateButton ($guiJoinButtonTitle,$guiOffset,$guiOffset*3,($guiWidth/3),$guiOffset*2)

;------------------------------------------------------------------------------
; Creando Arbol de AD  - Donde seran listadas las OUs
;------------------------------------------------------------------------------
$defaultTreeView	= GUICtrlCreateTreeView ($guiOffset,$guiOffset*10,($guiWidth-($guiOffset*2)),($guiHeight-($guiOffset*11)) )

;------------------------------------------------------------------------------
; Creando el control para manejar demasiados resultados de la busqueda de objetos
; Esto estara oculto hasta que la busqueda arroje demasiados resultados
;------------------------------------------------------------------------------
$tooManyObjectsList 	= GUICtrlCreateListView("Nombre|OU", $guiOffset,$guiOffset*10,($guiWidth-($guiOffset*2)),($guiHeight-($guiOffset*11)))
$hideTooManyObjectsList	= GUICtrlSetState($tooManyObjectsList, $GUI_HIDE);

;------------------------------------------------------------------------------
; Creando la Barra de progreso y textos
;------------------------------------------------------------------------------
$progressGroup		= GUICtrlCreateGroup("Progreso", $guiOffset, $guiOffset*6, $guiWidth-($guiOffset*2), "54")
$progressBar		= GUICtrlCreateProgress($guiOffset*1.5,$guiOffset*7,($guiWidth-($guiOffset*3)),$guiOffset*1)
$progessBarStartAtZero  = GUICtrlSetData ($progressBar, 0)
$progressText		= GUICtrlCreateLabel($guiProgressMessage, $guiOffset*1.5,$guiOffset*8.5,($guiWidth-($guiOffset*3)),$guiOffset*1)

;------------------------------------------------------------------------------
; Creando el Objeto para los controles de busqueda
;------------------------------------------------------------------------------
$objectSearchGroup	= GUICtrlCreateGroup("Buscar", $guiWidth-($guiOffset*14), $guiOffset-5, "195", "80")
$objectSearchLabel	= GUICtrlCreateLabel("Ingresar usuario, PC u OU:", $guiWidth-($guiOffset*13), $guiOffset*2)
$objectSearchInput	= GUICtrlCreateInput("", $guiWidth-($guiOffset*13), $guiOffset*3, "100")
$objectSearchButton	= GUICtrlCreateButton("Buscar", $guiWidth-($guiOffset*5), $guiOffset*3)

;------------------------------------------------------------------------------
; Disabilitando botones hasta que la busqueda de OUs se alla realizado
;------------------------------------------------------------------------------
$disableJoinButton		= GUICtrlSetState($joinButton, $GUI_DISABLE);
$disableObjectSearchButton 	= GUICtrlSetState($objectSearchButton, $GUI_DISABLE);

;------------------------------------------------------------------------------
; Hacer la Interfaz grafica visible
;------------------------------------------------------------------------------
$joinDomainGUIVisible	= GUISetState(@SW_SHOW, $joinDomainGUI)

;------------------------------------------------------------------------------
; consultando todas las Unidades Organisativas
;------------------------------------------------------------------------------
$allOUStringSepByLF	= returnObjectDN("*", "organizationalUnit");
If $allOUStringSepByLF <> "0" Then
	$allOUsArray 		= StringSplit($allOUStringSepByLF, @LF, 1)
	$deleteStringSplitCount	= _ArrayDelete($allOUsArray, 0)
Else
	MsgBox(0,	"No se puede consultar al Active Directory", "No se puede consultar al Active Directory ADO." & @LF & @LF & _
			"Favor revisar su Conectividad de red, revisar que su coneccion LDAP" & @LF & _
			"es correcta y que las credenciales suministradas al Script son correctas." & @LF & @LF & _
			"LDAP Connection String:" & @LF & _
			$ldapConnectionString & @LF & @LF & _
			"Nombre de Uusario:" & @LF & _
			$adUsername & @LF & @LF & _
			"Password:" & @LF & _
			$adPassword)
	GUIDelete()
	Exit(1001)
EndIf

;------------------------------------------------------------------------------
; Dando vuelta el orden de las OUs para poder ordenar alfabeticamente los nombres
;------------------------------------------------------------------------------
Dim $reversedAllOUsArray[1]
For $ou in $allOUsArray
	$reversedOU 	= returnReversedOU($ou)
	$arrayAddStatus = _ArrayAdd($reversedAllOUsArray, $reversedOU)
Next

;------------------------------------------------------------------------------
; Ordenando el array alfabeticamente
;------------------------------------------------------------------------------
$sortRevArrayStatus	= _ArraySort($reversedAllOUsArray)

;------------------------------------------------------------------------------
; Initialize our treeIDArray
; This will be used to look up the ID number of the GUI TreeView entries
; We need this to make nesting/child-parent relationships work.
;------------------------------------------------------------------------------
Dim $treeIDArray[UBound($reversedAllOUsArray)*2]

;------------------------------------------------------------------------------
; Return the OUs to their original format and create the TreeView Entries.
;------------------------------------------------------------------------------
$adCurrentObjectNumber = 0
For $reversedOU in $reversedAllOUsArray
	If $reversedOU = "" Then
		ContinueLoop
	EndIf

	;------------------------------------------------------------------------------
	; Reverse the order back to the orginal format
	;------------------------------------------------------------------------------
	$ou				= returnReversedOU($reversedou)

	;------------------------------------------------------------------------------
	; Calculate the additional values for this OU and check to see if its
	; parentou has a GUI TreeID
	;------------------------------------------------------------------------------
	$fullOU				= StringStripWS($ou, 3)
	$friendlyOU			= returnFriendlyName($fullOU)
	$parentFullOU			= returnParentOU($fullOU)
	$parentTreeID			= _ArraySearch($treeIDArray, $parentFullOU)

	;------------------------------------------------------------------------------
	; Check if this OU has a parent. If it does make this TreeView item a child
	; of that parent.
	;------------------------------------------------------------------------------
	If ( $parentTreeID <> "-1" ) Then
		$treeID 		= GUICtrlCreateTreeViewItem ($friendlyOU, $parentTreeID)
	Else
		$treeID			= GUICtrlCreateTreeViewItem ($friendlyOU, $defaultTreeView)
	EndIf

	;------------------------------------------------------------------------------
	; The returned $treeID is sequential. We can use this to cheat and emulate
	; a hashtable.
	;------------------------------------------------------------------------------
	;$treeIDArray[$treeID] = $fullOU

	;------------------------------------------------------------------------------
	; Update the progress bar and increment the object count
	;------------------------------------------------------------------------------
	UpdateProgressBar(($adCurrentObjectNumber / UBound($allOUsArray)) * 100)
	UpdateProgressText($guiProgressMessage & " - Currently querying " & $friendlyOU)
	$adCurrentObjectNumber = $adCurrentObjectNumber + 1
Next

;------------------------------------------------------------------------------
; Query is complete, update Progress Text
;------------------------------------------------------------------------------
UpdateProgressText("Seleccionar una OU a la cual unirse de la lista inferior.")

;------------------------------------------------------------------------------
; Check and see if this computername is already present in AD
;------------------------------------------------------------------------------
$computersCN = returnObjectDN($computername, "computer")
If $computersCN <> "0" Then
	$computersOU = returnFullOUfromDN($computersCN)
	UpdateProgressText("Se encontro este PC (" & $computername & ") en la OU " & _
				returnFriendlyName($computersOU) & " Esta OU - Habia sido selecionada previamente " & _
				"por Ud.")
	GUICtrlSetState(_ArraySearch($treeIDArray, $computersOU), $GUI_FOCUS)
EndIf

;------------------------------------------------------------------------------
; Enable the buttons
;------------------------------------------------------------------------------
$enableJoinButton		= GUICtrlSetState($joinButton, $GUI_ENABLE);
$enableObjectSearchButton 	= GUICtrlSetState($objectSearchButton, $GUI_ENABLE);

;------------------------------------------------------------------------------
; GUI Message Loop
;------------------------------------------------------------------------------
While 1
	$msg 		= GUIGetMsg()
	Select
		;-----------------------------------------------------------------------------------
		; User clicked "Close" button
		;-----------------------------------------------------------------------------------
		Case $msg = -3 Or $msg = -1

			GUIDelete()
			ExitLoop

		;-----------------------------------------------------------------------------------
		; User clicked "Join Domain" button
		;-----------------------------------------------------------------------------------
		Case $msg = $joinButton
			If GUICtrlRead($defaultTreeView) <> 0 Then
				$selectedOU	= $OU 

				;-----------------------------------------------------------------------------------
				; Check if the OU selected matches OU in which this computer already exists (if any)
				;
				; If so prompt the user to see if they really want to join this different OU
				;-----------------------------------------------------------------------------------
				$computername	= returnComputerName()
				$computerDN	= returnObjectDN($computername, "computer")
				$existingOU	= returnFullOUfromDN($computerDN)
				If $existingOU <> "0" And $existingOU <> $selectedOU Then
					$attemptJoin = MsgBox(4, "La computadora existe en otra OU", "Esta computadora ya existe en una OU diferente." & @LF & @LF & _
					"Una computadora con este nombre (" & $computername & ") ya existe en otra OU." & @LF & @LF & _
					"la OU es::" & @LF & _
					$existingOU & @LF & @LF & _
					"La OU que seleccionaste es:" & @LF & _
					$selectedOU & @LF & @LF & _
					"Quieres intentar unirte al Dominio en esta OU de todas formas?")

					;------------------------------------------------------------------------------
					; If user clicked "No" skip out of the loop
					;------------------------------------------------------------------------------
					If $attemptJoin = 7 Then
						ContinueLoop
					EndIf
				EndIf

				;------------------------------------------------------------------------------
				; Join the system to the domain
				;------------------------------------------------------------------------------
				$joinDomainResult = joinDomain($selectedOU)

				;------------------------------------------------------------------------------
				; If domain join was successfull ask user if they want to restart system
				;------------------------------------------------------------------------------
				If $joinDomainResult = 0 Then
					$restartQuery = MsgBox(4, "Reiniciar el Sistema", "Te has unido al Dominio Satisfactoriamente." & @LF & @LF & _
									"Quieres Reiniciar ahora?")

					If $restartQuery = 6 Then
						Shutdown(6)
					EndIf

					GUIDelete()
					Exit
				;------------------------------------------------------------------------------
				; If domain join failed notify user and try to give them a pertitent error
				; message
				;------------------------------------------------------------------------------
				Else
					MsgBox(0, "Union al Dominio fallo (" & $joinDomainResult & ")", "No fue posible unirse al dominio Satisfactoriamente." & @LF & @LF & _
						$joinDomainResultText)
				EndIf
			Else
				;------------------------------------------------------------------------------
				; If the user forgot to select an OU from the TreeView
				;------------------------------------------------------------------------------
				MsgBox(0, "Oops", "Debes seleccionar una OU a la cual unirte. Por favor selecciona una de la lista inferior.")
			EndIf
		;-----------------------------------------------------------------------------------
		; User searched for an Object
		;-----------------------------------------------------------------------------------
		Case $msg = $objectSearchButton
			$objectSearchedFor 	= StringStripWS(GUICtrlRead($objectSearchInput), 3)
			$objectsDN 		= returnObjectDN($objectSearchedFor, "*")
			$objectsDNArray		= StringSplit($objectsDN, @LF)
			$deleteStringSplitCount = _ArrayDelete($objectsDNArray, 0)

			;-----------------------------------------------------------------------------------
			; If we found just one record, highlight it in the TreeView
			;-----------------------------------------------------------------------------------
			If $objectsDN <> "0" And UBound($objectsDNArray) = 1 Then
				$objectsOU = returnFullOUfromDN($objectsDN)

				GUICtrlSetState(_ArraySearch($treeIDArray, $objectsOU), $GUI_FOCUS)

				UpdateProgressText("Found this object (" & $objectSearchedFor & ") in the " & _
						     returnFriendlyName($objectsOU) & " OU - This has been selected " & _
						     "for you below.")
			;-----------------------------------------------------------------------------------
			; If we found more then one record let the user choose which one they wanted
			;-----------------------------------------------------------------------------------
			ElseIf $objectsDN <> "0" And UBound($objectsDNArray) > 1 Then
				MsgBox(0, "Too many matching objects found", "Too many matching objects found for your search term (" & $objectSearchedFor & ")" & @LF & @LF & _
					     "Please enter enough information to uniquely identify"  & @LF & _
					     "a single object." & @LF & @LF & _
					     "Objects that matches your search:" & @LF & _
					      $objectsDN)

				;-----------------------------------------------------------------------------------
				; Delete any entries from the ListView control and then show the control
				;-----------------------------------------------------------------------------------
				;$deleteAllListViewItems	= _GUICtrlListViewDeleteAllItems($tooManyObjectsList)
				;$showTooManyObjectsList	= GUICtrlSetState($tooManyObjectsList, $GUI_SHOW)

				;-----------------------------------------------------------------------------------
				; Disable the TreeView list of OUs and the JoinDomain button
				;-----------------------------------------------------------------------------------
				;$hideTreeView		= GUICtrlSetState($defaultTreeView, $GUI_HIDE)
				;$disableJoinButton	= GUICtrlSetState($joinButton, $GUI_DISABLE)

				;-----------------------------------------------------------------------------------
				; Update Progress Text
				;-----------------------------------------------------------------------------------
				;UpdateProgressText("Please select the object you were searching for from the list below:")

				;For $objectName in $objectsDNArray
				;	$name 	= returnFriendlyName($objectname);
				;	$ou	= returnFullOUfromDN($objectname)
				;	GuiCtrlCreateListViewItem($name & "|" & $ou, $tooManyObjectsList)
				;Next
			;-----------------------------------------------------------------------------------
			; If we didn't find any records
			;-----------------------------------------------------------------------------------
			ElseIf $objectsDN = 0 Then
				MsgBox(0, "No se encontraron objetos que concuerden", "No se encontraron objetos para su busqueda (" & $objectSearchedFor & ")" & @LF & @LF & _
					     "Por favor ingrese el nombre del objeto."  & @LF & @LF & _
					     "Ejemplo:" & @LF & _
					     "Shayro" & @LF & @LF & _
					     "Puede usar comodines en su busqueda." & @LF & @LF & _
					     "Ejemplo:" & @LF & _
					     "shayro*")
			EndIf
	EndSelect
WEnd
GUIDelete()

;------------------------------------------------------------------------------
; Shared Functions
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Joins the computer running this script to the domain $adDomain in the
; OU passed to the function
;------------------------------------------------------------------------------
Func joinDomain($joinDomainOU)

	;------------------------------------------------------------------------------
	; Make sure we got *something* passed as an OU
	;------------------------------------------------------------------------------
	If $joinDomainOU = "" Or ( StringLen($joinDomainOU) < StringLen($adDomain) ) Then
		MsgBox(0, "OU invalida o no especificada", "No fue seleccionada ninguna OU para unir el PC." & @LF & @LF & _
				"Parece que la OU no fue especificada OU correctamente." & @LF & @LF & _
				"Favor reintentar nuevamente y si persiste el error chekear los datos ingresados.")
	EndIf

	;------------------------------------------------------------------------------
	; Create our WMI object
	;------------------------------------------------------------------------------
	$computerObj 	= ObjGet("winmgmts:{impersonationLevel=Impersonate}!\\" & _
			  $computername & "\root\cimv2:Win32_ComputerSystem.Name='" & _
			  $computername & "'")

	;------------------------------------------------------------------------------
	; Attempt domain join
	;------------------------------------------------------------------------------
	$joinDomainResultNumber	= $computerObj.JoinDomainOrWorkGroup($adDomain, $adPassword, $adDomain & "\" & $adUsername, $joinDomainOU, 3)

	;------------------------------------------------------------------------------
	; Check our results
	;------------------------------------------------------------------------------
	Select
		Case $joinDomainResultNumber  = 0
			Global $joinDomainResultText = "La union al Dominio se realizo correctamente."
		Case $joinDomainResultNumber  = 5
			Global $joinDomainResultText = "la cuenta " & $adUsername & " no tiene permsisos. Al parecer la cuenta que esta utilizando no tiene permisos para sobrescrivir el objeto en el AD"
		Case $joinDomainResultNumber  = 86 Or $joinDomainResultNumber = 1326
			Global $joinDomainResultText = "El usuario y el password que prioporciono son incorrectos. Checkear el nombre de usuario y el password que aparecen mas abajo."
		Case $joinDomainResultNumber  = 1909
			Global $joinDomainResultText = "La cuenta " & $adUsername & " esta bloqueada."
		Case $joinDomainResultNumber  = 2224
			Global $joinDomainResultText = "La cuenta del equipo ya existe en el Dominio y no puede ser sobrescrita."
		Case $joinDomainResultNumber  = 2453
			Global $joinDomainResultText = "No se puede encontrar un controlador de Dominio."
		Case $joinDomainResultNumber  = 2102
			Global $joinDomainResultText = "El servicio de la estacion de trabajo no se encuentra iniciado. Iniciar el Servicio e intentar nuevamente."
		Case $joinDomainResultNumber  = 2691
			Global $joinDomainResultText = "Etsa PC ya se encuentra unida al Dominio."
	EndSelect

	Return $joinDomainResultNumber

EndFunc

;------------------------------------------------------------------------------
; Searches AD via ADO for the DN of an object
;
;
; If the DN is found then it is returned.
;
; If no match is found then 0 is returned
;
;
; If more then one match is found then they are returned
; as a single string, separated by linebreaks.
;
; The second paramter dictates the object type to
; search for. It can either by user, computer, or
; organizationalunit. Alternatively it can be an objectclass
; your AD structure supports.
;
;------------------------------------------------------------------------------
Func returnObjectDN($objectName, $objectClass)
	$objectsFoundCount			= 0
	Dim $objectsFoundNames

	;------------------------------------------------------------------------------
	; Create the ADO object and execute the search
	;------------------------------------------------------------------------------
	$commandObj				= ObjCreate("ADODB.Command")
	$commandObj.ActiveConnection 		= $connObj
	$commandObj.CommandText 		= "SELECT distinguishedName FROM '" & $ldapConnectionString & "' " & _
						  "WHERE objectClass='" & $objectClass & "' AND name ='" & $objectName & "'"
	$commandObj.Properties("Page Size") 	= 10000
	$commandObj.Properties("Cache Results") = True
	$commandObj.Properties("SearchScope") 	= 2

	$objRecordSet				= ObjCreate("ADODB.Recordset")
	$objRecordSet				= $commandObj.Execute

	If($objRecordSet.RecordCount <> "") Then
		;------------------------------------------------------------------------------
		; Loop through the record set
		;------------------------------------------------------------------------------
		$objRecordSet.MoveFirst
		While Not $objRecordSet.EOF
			If $objectsFoundCount > 0 Then
				$objectsFoundNames	= $objectsFoundNames & @LF & $objRecordSet.Fields("distinguishedName").Value
			Else
				$objectsFoundNames	= $objRecordSet.Fields("distinguishedName").Value
			EndIf

			$objRecordSet.MoveNext
			$objectsFoundCount= $objectsFoundCount+1
		WEnd

		If $objectsFoundCount > 0 Then
			Return $objectsFoundNames
		Else
			Return 0;
		EndIf
	Else
		Return 0;
	EndIf
EndFunc

;------------------------------------------------------------------------------
;Reverse the order of all the OUs
;
; Example:
;
; The full OU of:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; DC=com,DC=domain,OU=Service Groups,OU=IT Shop
;
; We do this so we can do an easy alphabetical sort
;
; At this time ADO/ADSI doesn't support ORDER BY for
; organizational units
;------------------------------------------------------------------------------
Func returnReversedOU($ou)
	$subOUArray = StringSplit($ou, $ouSeparator)
	$reversedOU = ""
	For $i = (UBound($subOUArray) - 1 ) To 1 Step -1
		If $i = (UBound($subOUArray) -  1 ) Then
			$reversedOU = $reversedOU & $subOUArray[$i]
		Else
			$reversedOU = $reversedOU & $ouSeparator & $subOUArray[$i]
		EndIf
	Next
	Return $reversedOU
EndFunc

;------------------------------------------------------------------------------
; Replaces the Progress Text control with supplied text
;------------------------------------------------------------------------------
Func UpdateProgressText($text)
	GUICtrlSetData($progressText, $text)
EndFunc

;------------------------------------------------------------------------------
; Updates the progress bar to the passed percentage
;------------------------------------------------------------------------------
Func UpdateProgressBar($percentage)
	GUICtrlSetData($progressBar, $percentage)
EndFunc

;------------------------------------------------------------------------------
; Will return the current computername of the system running this script
;------------------------------------------------------------------------------
Func returnComputerName()
	$networkObj 		= ObjCreate("WScript.Network")
	$computerName 		= $networkObj.ComputerName
	Return $computerName
EndFunc

;------------------------------------------------------------------------------
; Returns the friendly object name:
;
; Example:
;
; The full OU of:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; IT Shop
;------------------------------------------------------------------------------
Func returnFriendlyName($dn)
	Return StringMid($dn, StringInStr($dn, "=")+1, StringInStr($dn, $ouSeparator)-(StringInStr($dn, "=")+1))
EndFunc

;------------------------------------------------------------------------------
; Returns the full OU name from a DN record:
;
; Example:
;
; The DN:
; CN=Paula,OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;------------------------------------------------------------------------------
Func returnFullOUfromDN($dn)
	If $dn <> "0" Then
		Return StringRight($dn, StringLen($dn)-StringInStr($dn, $ouIdentifier)+1)
	Else
		Return 0
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Returns the parent OU name:
;
; Example:
;
; The full OU of:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; OU=Service Groups,DC=domain,DC=com
;------------------------------------------------------------------------------
Func returnParentOU($fullOU)
	Return StringRight($fullOU, ( StringLen($fullOU)-StringInStr($fullOU, $ouSeparator) ) )
EndFunc

;------------------------------------------------------------------------------
; Custom COM error handler
;
; Needs to be trapped with:
; $comError 		= ObjEvent("AutoIt.Error", "comError")
;------------------------------------------------------------------------------
Func comError()
    If IsObj($comError) Then
        $hexNumber = Hex($comError.number, 8)
        SetError($hexNumber)
    EndIf
    Return 0
EndFunc



