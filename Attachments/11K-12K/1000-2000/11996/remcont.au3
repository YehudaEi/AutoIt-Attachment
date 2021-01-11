;wmi remote process control
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Global Const $WM_COMMAND = 0x0111
Dim $strUserDomain, $pc[10]
Global $window[10]
Global Const $DebugIt = 1
Dim $strNameOfUser, $strComputer
Dim $ListView1[10], $Input1[10], $Button1[10], $Button2[10], $user[10], $password[10], $pass[10], $commande[10], $tab[10]
Dim $reponse[10], $commands[10], $commanderecue[10], $tabitems[10], $services[10], $ListView2[10]
Dim $tabencours = 0
#include <GUIConstants.au3>
#include<guilistview.au3>
#include<date.au3>
#include<guilist.au3>
#include<file.au3>
#include<guitreeview.au3>
#include<guitab.au3>
#Region ### START Koda GUI section ### Form=
;Opt("GUICoordMode",2)
;Opt("GUIResizeMode", 1)
Opt("guioneventmode", 1)
Opt("WinSearchChildren", 1)
global const $form = GUICreate("Remote WMI Control", 633, 700, 1, 40, $WS_OVERLAPPEDWINDOW)
GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESIZED, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "SpecialEvents")
;GUISetOnEvent($form, "_eventfunc")
GUISetState(@SW_SHOW)
$tabpc = GUICtrlCreateTab(1, 1, 630, 25)
GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "_switchtab")
$nouvelleconnexion = GUICtrlCreateButton("New connection", 5, 30, 120)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetOnEvent(-1, "_createnewconnexion")
$supprimerconnexion = GUICtrlCreateButton("Suppress connection", 145, 30, 120)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetOnEvent(-1, "_supprimerconnexion")
$log = GUICtrlCreateList("Log démarré le " & _Now(), 5, 540, 620, 120)
;GUIctrlSetOnEvent($tabpc,
;GUISetState(@SW_SHOW,$form)
;GUISetState(@SW_SHOW,$utils)
GUISwitch($form)
#EndRegion ### END Koda GUI section ###
$oLocator = ObjCreate("WbemScripting.SWbemLocator")
Global $oWMIService
$oWMIService = $oLocator.ConnectServer (".", "root\cimv2", "", "", "", "", "64")
;GUICtrlSetOnEvent($msg,"_switchcomputer()")
;_createnewconnexion(".")
_createnewconnexion()
While 1
	Sleep(10)
WEnd
#cs
	While 1
	$Msg = GUIGetMsg(1)
	$currentwindow = GUICtrlRead($tabpc)
	Select
	Case $Msg[0] = $GUI_EVENT_CLOSE
	Exit
	case $msg[0] = $nouvelleconnexion
	$var=inputbox("Enter ","enter the name or the ip to connect to")
	if not @error then _createnewconnexion()
	
	Case $Msg[0] = $tabpc
	$currentwindow = GUICtrlRead($tabpc)
	ConsoleWrite("selection => " & $currentwindow & @CRLF & "$window[$tabencours]=>>" & $window[$currentwindow] & @CRLF)
	$nombretab = _GUICtrlTabGetRowCount($tabpc)
	For $i = 0 To $currentwindow - 1
	GUISetState(@SW_HIDE, $window[$i])
	Next
	GUISetState(@SW_SHOW, $window[$currentwindow])
	If $currentwindow < $nombretab Then
	For $i = $currentwindow + 1 To $nombretab
	GUISetState(@SW_HIDE, $window[$i])
	Next
	EndIf
	GUISwitch($window[$currentwindow])
	
	case $msg[0] =$Input1[$currentwindow]
	consolewrite("ok input1 recu pour la fenêtre => " & $window[$currentwindow] & @CRLF)
	
	;		;Case $Input1[$currentwindow]
	_getprocess(GUICtrlRead($Input1[$currentwindow]), $currentwindow)
	Case $msg[0] =$Button1[$currentwindow]
	_createprocess(GUICtrlRead($Input1[$currentwindow]), $currentwindow)
	_getprocess(GUICtrlRead($Input1[$currentwindow]), $currentwindow)
	case $msg[1]=$window[$currentwindow]
	consolewrite("ok clic recu pour la fenêtre => " & $window[$currentwindow] & @CRLF)
	consolewrite("msg=> " & $msg& @CRLF)
	ConsoleWrite($Input1[$currentwindow]& @CRLF)
	
	Case $user[$currentwindow]
	_getprocess(GUICtrlRead($Input1[$currentwindow]), $window[$currentwindow])
	Case $pass[$currentwindow]
	_getprocess(GUICtrlRead($Input1[$currentwindow]), $window[$currentwindow])
	Case $Button1[$currentwindow]
	_createprocess(GUICtrlRead($Input1[$currentwindow]), $window[$currentwindow])
	_getprocess(GUICtrlRead($Input1[$currentwindow]), $window[$currentwindow])
	Case $Button2[$currentwindow]
	$rep = StringSplit(GUICtrlRead(GUICtrlRead($ListView1[$currentwindow])), "|")
	_terminateprocess(GUICtrlRead($Input1[$currentwindow]), $rep[1])
	Case $commande[$currentwindow]
	_createprocessadvanced(GUICtrlRead($Input1[$currentwindow]), GUICtrlRead($commande[$currentwindow]), $window[$currentwindow])
	;Case $getgpo
	;	_getgpo(GUICtrlRead($Input1))
	;	_getadm(GUICtrlRead($Input1))
	;Case $folderseek
	;	_getfolder(GUICtrlRead($Input1), GUICtrlRead($folderseek))
	EndSwitch
	
	EndSelect
	Sleep(10)
	WEnd
#ce
Func _switchtab()
	;guisetstate(@sw_lock,$form)
	$currentwindow = GUICtrlRead($tabpc)
	ConsoleWrite("selection => " & $currentwindow & @CRLF & "$window[$tabencours]=>>" & $window[$currentwindow] & @CRLF)
	$nombretab = _GUICtrlTabGetRowCount($tabpc)
	For $i = 0 To $nombretab
		GUISetState(@SW_HIDE, $window[$i])
	Next
	GUISetState(@SW_SHOW, $window[$currentwindow])
	;GUISwitch($window[$currentwindow])
	;guisetstate(@sw_unlock,$form)
EndFunc   ;==>_switchtab
Func _createnewconnexion()
	$strComputer = InputBox("Enter ", "enter the name or the ip to connect to")
	If Not @error Then
		;ConsoleWrite("ubound window =>> " & UBound($window) & @CRLF)
		;$tabencours  +=1
		ConsoleWrite("ubound window =>> " & UBound($window) & @CRLF)
		;redim $window [UBound($window)+1]
		;redim $tab [UBound($window)+1]
		GUIStartGroup($form)
		$tabitems[$tabencours] = GUICtrlCreateTabItem($strComputer)
		ConsoleWrite("tabitems creation " & $tabitems[$tabencours] & @CRLF)
		$window[$tabencours] = GUICreate("", 633, 550, -1, -1, $ws_child, $WS_EX_MDICHILD, $form)
		;GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT)
		;$pc[0]=guictrlcreatetabitem(@ComputerName)
		GUIStartGroup($window[$tabencours])
		Opt("guioneventmode", 1)
		$tab[$tabencours] = GUICtrlCreateTab(1, 1, 630, 470)
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT)
		GUICtrlCreateTabItem("Processus")
		$ListView1[$tabencours] = GUICtrlCreateListView("Nom du processus | Utilisateur| Utilisation mémoire | PID | Executable Path", 5, 53, 620, 401, $LVS_SORTASCENDING)
		GUICtrlSetResizing(-1, bitor($GUI_DOCKHEIGHT,$GUI_DOCKTOP))
		$Input1[$tabencours] = GUICtrlCreateInput($strComputer, 8, 25, 145, 21)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		;GUICtrlSetOnEvent(-1, "_getprocess")
		$Button1 [$tabencours] = GUICtrlCreateButton("New", 200, 25, 75, 25, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_createprocess")
		$Button2 [$tabencours] = GUICtrlCreateButton("Terminate", 320, 25, 75, 25, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_terminateprocess")
		$user [$tabencours] = GUICtrlCreateInput("", 400, 25, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		$pass [$tabencours] = GUICtrlCreateInput("", 500, 25, 75, 25, $ES_PASSWORD)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateTabItem("Processus avancé")
		$commande [$tabencours] = GUICtrlCreateInput("", 5, 30, 250, 25)
		GUICtrlSetOnEvent(-1, "_createprocessadvanced")
		$reponse [$tabencours] = GUICtrlCreateEdit("reponse", 0, 100, 620, 375)
		GUICtrlSetFont(-1, 10, 800, -1, "Lucida Console")
		GUICtrlSetColor(-1, 0xffffff)
		GUICtrlSetBkColor(-1, 0x000000)
		$commands [$tabencours] = GUICtrlCreateCombo("Ipconfig /all", 270, 30, 200, 25)
		$commanderecue[$tabencours] = GUICtrlCreateLabel("Commande reçue => ", 5, 70, 250, 25)
		$services[$tabencours] = GUICtrlCreateTabItem("Services")
		GUICtrlSetOnEvent(-1, "_getservices")
		$ListView2[$tabencours] = GUICtrlCreateListView("Nom du service | Description | Etat | StartupMode | ServiceType ", 5, 53, 620, 401, $LVS_SORTASCENDING)
		;$sauvcommand=GUICtrlCreateButton("Sauv",#region --- GuiBuilder code Start ---
		; Script generated by AutoBuilder 0.6 Prototype
		;GUICtrlCreateTabItem("Explorateur")
		;$folderseek = GUICtrlCreateInput("c:\", 5, 30, 200)
		;$explorer = GUICtrlCreatelistView("Nom             | extension | DateModi | DateCréation | DateAcces", 250, 30, 370, 400)
		;GUICtrlCreateTabItem("Règles")
		;$getgpo = GUICtrlCreateButton("Demande", 30, 30)
		;$ADM = GUICtrlCreateEdit("ADM Templates", 30, 60, 590, 100)
		ConsoleWrite("index => " & $tabencours & @CRLF & "$window[$tabencours]=>>" & $window[$tabencours] & @CRLF)
		$nombretab = _GUICtrlTabGetRowCount($tabpc)
		For $i = 0 To $nombretab
			GUISetState(@SW_HIDE, $window[$i])
		Next
		GUISetState(@SW_SHOW, $window[$tabencours])
		GUISwitch($window[$tabencours])
		GUIStartGroup($form)
		ConsoleWrite("tabitems montrage " & $tabitems[$nombretab] & @CRLF)
		GUICtrlSetState($tabitems[$nombretab], $gui_show)
		$tabencours += 1
		_setsize()
	EndIf
EndFunc   ;==>_createnewconnexion
Func _supprimerconnexion()
	$currenttab = GUICtrlRead($tabpc)
	ConsoleWrite("connexion à supprimer => " & $currenttab)
	GUIDelete($window[$currenttab])
	_GUICtrlTabDeleteItem($tabpc, $currenttab)
	#region - resync the tabs
	_ArrayDelete($tab, $currenttab)
	_ArrayDelete($window, $currenttab)
	_ArrayDelete($commande, $currenttab)
	_ArrayDelete($commanderecue, $currenttab)
	_ArrayDelete($ListView1, $currenttab)
	_ArrayDelete($Input1, $currenttab)
	_ArrayDelete($Button1, $currenttab)
	_ArrayDelete($Button2, $currenttab)
	_ArrayDelete($user, $currenttab)
	_ArrayDelete($pass, $currenttab)
	_ArrayDelete($reponse, $currenttab)
	_ArrayDelete($commands, $currenttab)
	_ArrayDelete($ListView2, $currenttab)
	;_ArrayDelete
	$tabencours -= 1
	#endregion
EndFunc   ;==>_supprimerconnexion
Func _getprocess()
	
	$cur = GUICtrlRead($tabpc)
	$strComputer = GUICtrlRead($Input1[$cur])
	ConsoleWrite("getprocess pour => " & $strComputer)
	$username = GUICtrlRead($user[$cur])
	$password = GUICtrlRead($pass[$cur])
	ConsoleWrite($username & @TAB & $password & @CRLF)
	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oLocator.Security_.AuthenticationLevel = 6
	$oWMIService = $oLocator.ConnectServer ($strComputer, "root\CIMV2", $username, $password, "", "", "128")
	If Not @error Then
		;$strComputer = "."
		_GUICtrlListViewDeleteAllItems($ListView1[$cur])
		$colProcessList = $oWMIService.ExecQuery ("SELECT * FROM Win32_Process")
		For $objProcess In $colProcessList
			$colProperties = $objProcess.GetOwner ($strNameOfUser, $strUserDomain)
			;ConsoleWrite( "Process " & $objProcess.Name & " is owned by " & $strUserDomain & "\" & $strNameOfUser & @CRLF)
			$mem = $objProcess.PageFileUsage
			Select
				Case $mem > 1024 ^ 3
					$mem = $mem / 1024 ^ 3
					$mem = Int($mem) & " Go"
				Case $mem > 1024 ^ 2
					$mem = $mem / 1024 ^ 2
					$mem = Int($mem) & " Mo"
				Case $mem > 1024
					$mem = $mem / 1024
					$mem = Int($mem) & " Ko"
				Case Else
					$mem = Int($mem) & "  o"
			EndSelect
			
			GUICtrlCreateListViewItem($objProcess.Name & "|" & $strUserDomain & "\" & $strNameOfUser & "|" & $mem & "|" & $objProcess.Handle & "|" & $objProcess.ExecutablePath, $ListView1[$cur])
		Next
	EndIf
	
EndFunc   ;==>_getprocess
Func _getservices()
	$cur = GUICtrlRead($tabpc)
	$strComputer = GUICtrlRead($Input1[$cur])
	ConsoleWrite("getservice pour => " & $strComputer)
	$username = GUICtrlRead($user[$cur])
	$password = GUICtrlRead($pass[$cur])
	ConsoleWrite($username & @TAB & $password & @CRLF)
	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oLocator.Security_.AuthenticationLevel = 6
	$oWMIService = $oLocator.ConnectServer ($strComputer, "root\CIMV2", $username, $password, "", "", "128")
	If Not @error Then
		;$strComputer = "."
		_GUICtrlListViewDeleteAllItems($ListView2[$cur])
		$colProcessList = $oWMIService.ExecQuery ("SELECT * FROM Win32_Service")
		For $objProcess In $colProcessList
			
			GUICtrlCreateListViewItem($objProcess.caption & "|" & $objProcess.description & "|" & $objProcess.state & "|" & $objProcess.startmode & "|" & $objProcess.ServiceType, $ListView2[$cur])
		Next
	EndIf
EndFunc   ;==>_getservices
Func _createprocess()
	$cur = GUICtrlRead($tabpc)
	$strComputer = GUICtrlRead($Input1[$cur])
	Const $SW_NORMAL = 0
	;$strCommand = "notepad.exe"
	Global $intProcessID
	$strCommand = InputBox("Entrer la commande", "Saisir la commande à éxécuter")
	;$oWMIService = ObjGet("winmgmts:" _
	;    & "{impersonationLevel=impersonate}!\\" _
	;    & $strComputer & "\root\cimv2")
	ConsoleWrite("comp =>> " & $strComputer & @CRLF)
	;Configure the Notepad process to show a window
	;$objStartup = $oWMIService.Get("Win32_ProcessStartup")
	;ConsoleWrite("objet => " & isobj($objStartup) & @crlf)
	;$objConfig = $objStartup.SpawnInstance_
	;$objConfig.ShowWindow = $SW_NORMAL
	;Create Notepad process
	$objProcess = $oWMIService.Get ("Win32_Process")
	$intReturn = $objProcess.Create ($strCommand);,"", $objConfig, $intProcessID)
	If $intReturn <> 0 Then
		ConsoleWrite("Processus impossible à lancer " & $intReturn & @CRLF)
		ConsoleWrite("Command line: " & $strCommand & @CRLF)
		ConsoleWrite("Process ID: " & $intProcessID & @CRLF)
	Else
		ConsoleWrite("Processus à lancé " & @CRLF)
		ConsoleWrite("Command line: " & $strCommand & @CRLF)
		ConsoleWrite("Process ID: " & $intProcessID & @CRLF)
	EndIf
	_getprocess()
EndFunc   ;==>_createprocess
Func _terminateprocess()
	$cur = GUICtrlRead($tabpc)
	$strComputer = GUICtrlRead($Input1[$cur])
	$var = _GUICtrlListViewGetCurSel($ListView1[$cur])
	$pid = _GUICtrlListViewGetItemText($ListView1[$cur], $var, 3)
	;$var=StringSplit($var,"|")
	;$pid=$var[4]
	$conf = MsgBox(308, "Confirmation", "Are you sure ?" & @CRLF & "PID : " & $pid)
	If $conf = 6 Then
		ConsoleWrite("terminate : " & $strComputer & @CRLF & $pid)
		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=Warning
		;$strDomain = "DOMAIN"
		;strUser = InputBox("Enter user name")
		;strPassword = InputBox("Enter password")
		;Set objSWbemLocator = CreateObject("WbemScripting.SWbemLocator")
		;Set objWMIService = objSWbemLocator.ConnectServer(strComputer, _
		;    "root\CIMV2", _
		;    strUser, _
		;    strPassword, _
		;    "MS_409", _
		;    "ntlmdomain:" + strDomain)
		;$process=inputbox("Nom du processus à terminer","Saisir le nom du ou des processus à terminer")
		$oWMIService = ObjGet("winmgmts:" _
				 & "{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
		$colProcessList = $oWMIService.ExecQuery _
				("SELECT * FROM Win32_Process WHERE Handle = '" & $pid & "'")
		For $objProcess In $colProcessList
			$objProcess.Terminate ()
		Next
	EndIf
EndFunc   ;==>_terminateprocess
#cs
	Func _getfolder($strComputer, $folder)
	_GUICtrlTreeViewDeleteAllItems($explorer)
	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oWMIService = $oLocator.ConnectServer ($strComputer, "root\cimv2", "", "", "", "", "128")
	$arrFolderPath = stringSplit($Folder, "\")
	ConsoleWrite("taille =>> " & $arrFolderPath[0])
	$strNewPath = ""
	$strpath = ""
	;if $arrFolderPath[0] = 2 then
	;	$strpath = "\\" & $arrFolderPath[1] & "\\"
	;Else
	For $i = 2 to Ubound($arrFolderPath)-1
	$strNewPath = $strNewPath & "\\" & $arrFolderPath[$i]
	Next
	$strPath = $strNewPath
	;EndIf
	
	ConsoleWrite("folder = > " & $strpath & @CRLF)
	;$colFiles = $oWMIService.ExecQuery ("Select * from CIM_DataFile where Path = '" & $folder & "'")
	
	$colFiles = $oWMIService.ExecQuery ("Select * from CIM_DataFile where Path = '"&$strpath& "'")
	For $objFile In $colFiles
	ConsoleWrite($objFile.Name & @CRLF)
	GUICtrlCreatelistViewItem($objFile.FileName & "." & $objfile.extension & _
	"|" & $objfile.extension & "|" & $objfile.LastModified & "|" & $objfile.LastAccessed & _
	"|" & $objfile.CreationDate,$explorer)
	Next
	ConsoleWrite("folder = subfolders > " & $folder & @CRLF)
	$colItems = $oWMIService.ExecQuery("Associators of {Win32_Directory.Name='"&$folder&"'} " & _
	"Where AssocClass = Win32_Subdirectory    "  & _
	"ResultRole = PartComponent")
	For $objItem in $colItems
	;ConsoleWrite($objItem.LastAccessed& @crlf)
	Next
	
	EndFunc   ;==>_getfolder
	Func _getgpo($strComputer)
	$objWMIService = ObjGet _
	("winmgmts:\\" & $strComputer & "\root\rsop\computer")
	$colItems = $objWMIService.ExecQuery ("Select * from RSOP_SystemService")
	For $objItem In $colItems
	ConsoleWrite("Service: " & $objItem.Service & @CRLF)
	ConsoleWrite("Precedence: " & $objItem.Precedence & @CRLF)
	ConsoleWrite("SDDL String: " & $objItem.SDDLString & @CRLF)
	ConsoleWrite("Startup Mode: " & $objItem.StartupMode & @CRLF)
	Next
	EndFunc   ;==>_getgpo
#ce
Func _createprocessadvanced()
	$cur = GUICtrlRead($tabpc)
	$strCommand = GUICtrlRead($commande[$cur])
	If Not @error Then
		$cur = GUICtrlRead($tabpc)
		$strComputer = GUICtrlRead($Input1[$cur])
		$oLocator = ObjCreate("WbemScripting.SWbemLocator")
		$oWMIService = $oLocator.ConnectServer ($strComputer, "root\cimv2", "", "", "", "", "128")
		Const $SW_NORMAL = 3
		Dim $intProcessID
		$cheminrep = "\\" & $strComputer & "\c$\windows\temp\"
		$cheminrep = StringReplace($cheminrep, ":", "$")
		$cheminrep = $cheminrep & "rem.txt"
		ConsoleWrite("cheminrep ====>>>>" & $cheminrep & @CRLF)
		$strCommand = "cmd /c " & $strCommand & " > c:\windows\temp\rem.txt"
		ConsoleWrite($strCommand & @CRLF)
		$objStartup = $oWMIService.Get ("Win32_ProcessStartup")
		;ConsoleWrite("objet => " & isobj($objStartup) & @crlf)
		$objConfig = $objStartup.SpawnInstance_
		$objConfig.ShowWindow = $SW_NORMAL
		;Create Notepad process
		$objProcess = $oWMIService.Get ("Win32_Process")
		Dim $intProcessID
		$intReturn = $objProcess.Create ($strCommand, "c:\", $objConfig, $intProcessID)
		If Not @error Then
			If $intReturn <> 0 Then
				ConsoleWrite("Processus impossible à lancer " & $intReturn & @CRLF)
				ConsoleWrite("Command line: " & $strCommand & @CRLF)
				;ConsoleWrite( "Process ID: " & $intProcessID & @CRLF)
			Else
				ConsoleWrite("Processus lancé " & @CRLF)
				ConsoleWrite("Command line: " & $strCommand & @CRLF)
				;ConsoleWrite( "Process ID: " & $intProcessID & @CRLF)
				$colProcesses = $oWMIService.ExecNotificationQuery _
						("Select * From __InstanceDeletionEvent " _
						 & "Within 1 Where TargetInstance ISA 'Win32_Process'")
				While 1
					$objProcess = $colProcesses.NextEvent
					If $objProcess.TargetInstance.ProcessID = $intProcessID Then
						ExitLoop
					EndIf
				WEnd
				GUICtrlSetData($reponse[$cur], _convertoutput(FileRead($cheminrep)))
				If FileExists($cheminrep) Then FileDelete($cheminrep)
			EndIf
			
			
			
		EndIf
	EndIf
EndFunc   ;==>_createprocessadvanced
Func MyErrFunc()
	Global $hexnumber = Hex($oMyError.number, 8)    ; for displaying purposes
	;msgbox(0,"",$omyerror.number)
	If Not $omyerror.description = "" Then _GUICtrlListInsertItem($log, GUICtrlRead($Input1) & " : " & $omyerror.description, 0)
	If Not $omyerror.windescription = "" Then _GUICtrlListInsertItem($log, GUICtrlRead($Input1) & " (win) : " & $omyerror.windescription, 0)
	#cs
		MsgBox(0, "AutoItCOM Test", "We intercepted a COM Error !" & @CRLF & @CRLF & _
		"err.description is: " & @TAB & $oMyError.description & @CRLF & _
		"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
		"err.number is: " & @TAB & $hexnumber & @CRLF & _
		"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
		"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
		"err.source is: " & @TAB & $oMyError.source & @CRLF & _
		"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
		"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
		)
	#ce
	SetError(1)  ; to check for afte
	
	;Exit
EndFunc   ;==>MyErrFunc
#cs
	Func _getadm($strComputer)
	$dtmConvertedDate = ObjCreate("WbemScripting.SWbemDateTime")
	$objWMIService = objget _
	("winmgmts:\\" & $strComputer & "\root\rsop\computer")
	$colItems = $objWMIService.ExecQuery _
	("Select * from RSOP_AdministrativeTemplateFile")
	GUICtrlSetData($ADM, "")
	For $objItem In $colItems
	$dtmConvertedDate.Value = $objItem.LastWriteTime
	$dtmCreationTime = $dtmConvertedDate.GetVarDate
	GUICtrlSetData($ADM, GUICtrlRead($ADM) & @CRLF & "GPO ID: " & $objItem.GPOID & @CRLF & _
	"Last Write Time: " & $dtmCreationTime & @CRLF & _
	"Name: " & $objItem.Name)
	Next
	EndFunc   ;==>_getadm
#ce
Func _convertoutput($string)
	ConsoleWrite("convert out en cours" & @CRLF)
	$string = StringReplace($string, "‚", "é")
	$string = StringReplace($string, "ÿ", " ")
	$string = StringReplace($string, "Š", "è")
	Return $string
EndFunc   ;==>_convertoutput
Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			;MsgBox(0, "Close Pressed", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
			Exit
		Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
			;MsgBox(0, "Window Minimized", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
		Case @GUI_CtrlId = $GUI_EVENT_RESTORE
			ConsoleWrite("restauration du gui" & @CRLF)
			_setsize("restore")
			;MsgBox(0, "Window Restored", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
		Case @GUI_CtrlId = $GUI_EVENT_RESIZED
			ConsoleWrite("redimmensionnement du gui" & @CRLF)
			_setsize()
		Case @GUI_CtrlId = $GUI_EVENT_MAXIMIZE
			ConsoleWrite("maximisation du gui" & @CRLF)
			_setsize("max")
	EndSelect
EndFunc   ;==>SpecialEvents
;==>_exit
Func _eventfunc()
	Switch @GUI_WinHandle
		Case $form ;function when parent gui is selectionned
			ConsoleWrite("fenêtre principale" & @CRLF)
		Case Else
			ConsoleWrite("fenêtre : " & @GUI_WinHandle & " et controle => " & @GUI_CtrlHandle & @CRLF)
	EndSwitch
EndFunc   ;==>_eventfunc
Func _setsize($type="") ;resize the child window
	$resdefaut=60
	if $type = "max" then $resdefaut = 60
	if $type = "restore" then $resdefaut = 0	
	$cur = GUICtrlRead($tabpc)
	$position = WinGetPos($form)
	consolewrite("type de redimmensionnement passé " & $type & @crlf) 
	consolewrite("position hor =>> " & $position[0] & @crlf)
	;WinMove($window[$cur], -1, $position[0] , $position[1] + $resdefaut, $position[2] - 10, $position[3] - 300)
	WinMove($window[$cur], -1, 0, $resdefaut, $position[2] - 10, $position[3] - 300)
	;guisetstate($window[$cur],-1)
EndFunc   ;==>_setsize
Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
	Local $nNotifyCode = _HiWord($wParam)
	Local $nID = _LoWord($wParam)
	Local $hCtrl = $lParam
	Local Const $EN_CHANGE = 0x300
	Local Const $EN_KILLFOCUS = 0x200
	Local Const $EN_SETFOCUS = 0x100
	ConsoleWrite("message => " & @CRLF & _
			"$hWnd : " & $hWnd & @CRLF & _
			"$msg : " & $msg & @CRLF & _
			"$wparam " & $wParam & @CRLF & _
			"$lparam " & $lParam & @CRLF)
	Switch $wParam
		Case 0x00000001 ;enterpressed
			$cur = GUICtrlRead($tabpc)
			Switch GUICtrlRead($tab[$cur])
				Case 0
					_getprocess()
				Case 1
					_createprocessadvanced()
				Case 2
					_getservices()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND
Func _HiWord($x)
	Return BitShift($x, 16)
EndFunc   ;==>_HiWord
Func _LoWord($x)
	Return BitAND($x, 0xFFFF)
EndFunc   ;==>_LoWord
#cs
	Func _Terminate()
	Exit
	EndFunc   ;==>_Terminate
	
	Func OKPressed()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("OK Pressed" & @LF & "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle & " CtrlHandle=" & @GUI_CtrlHandle)
	;----------------------------------------------------------------------------------------------
	EndFunc   ;==>OKPressed
	
	Func _MyInput()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("_MyInput")
	;----------------------------------------------------------------------------------------------
	EndFunc   ;==>_MyInput
	
	Func _Input_Changed()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("Input Changed:" & GUICtrlRead($input1))
	;----------------------------------------------------------------------------------------------
	EndFunc   ;==>_Input_Changed
	
	Func _Input_LostFocus()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("_Input_LostFocus")
	;----------------------------------------------------------------------------------------------
	EndFunc   ;==>_Input_LostFocus
	
	Func _Input_GotFocus()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("_Input_GotFocus")
	;----------------------------------------------------------------------------------------------
	EndFunc   ;==>_Input_GotFocus
	Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
	"+===========================================================" & @LF & _
	"-->" & $s_text & @LF & _
	"+===========================================================" & @LF)
	EndFunc   ;==>_DebugPrint
#ce