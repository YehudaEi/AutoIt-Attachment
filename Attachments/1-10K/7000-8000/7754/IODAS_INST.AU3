#include <_GetFolderUse.au3>

Break(0)

;~ *********************************************************************************************************
;~ ***************************************** FONCTIONS *****************************************************
;~ *********************************************************************************************************

Func WriteFlag($Flag)

	local $handle
	if not fileexists("C:\SI") then DirCreate ("c:\SI")
	filedelete("C:\SI\" & $FLAG)
	$handle = fileopen ("C:\SI\" & $FLAG,2)
	fileclose($handle)
	return(1)
	
endfunc


;~ *********************************************************************************************************
;~ ************************************* PROGRAMME PRINCIPAL ***********************************************
;~ *********************************************************************************************************


Const $APP = "IODAS", $ExtractDir = "C:\", $ArchiveName = "Anisexec.exe", $Minuteur = 10, $Minuteur_APP = "anis"
Dim $Running_Processes, $CommandLine, $MODE, $MODE_MSG, $FILE

;~ Si on est pas Admin on quitte

if not IsAdmin() then 
	msgbox (16,"Erreur !","Vous devez disposer des droits d'administrateurs pour continuer...")
	exit
EndIf

if  @OSTYPE <> "WIN32_NT" Then
	msgbox (16,"Erreur !","Cette installation ne fonctionne que sur WinNT/2K/XP/2003...")
	Exit
endif

if not fileexists(@scriptdir & "\" & $ArchiveName ) Then
	Msgbox (16,"Erreur !","Impossible de trouver " & $ArchiveName)
	Exit
endif

;~ Si, pas de param�tres alors par d�faut, on est en mode Install

$MODE="INSTALL"

if $CmdLine[0] = 1 Then
;~ 		Si un param�tre et que c'est /UNINSTALL alors mode Uninstall
		if stringupper($CmdLine[1]) == "/UNINSTALL" Then 
			$MODE = "UNINSTALL"
		Else
			msgbox(48,"Erreur !","Syntaxe : " & @ScriptName & " [/Uninstall].")
			exit
		endif
EndIf

;~ Partie commune � Uninstall et Install

;~ L'installation par MSI poss�de l'identifateur unique {F9D7D5F4-AD2D-47FD-8A9D-2F222F5C7A09}, s'il existe dans le registre, il faut d�sinstaller cette version

$VAR=RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\{F9D7D5F4-AD2D-47FD-8A9D-2F222F5C7A09}","UninstallString")
if not @Error Then
	$VAR=StringReplace(stringupper($VAR),"MSIEXEC.EXE /X","MSIEXEC.EXE /Q /X")
	RunWait($Var,"",@SW_HIDE)
endif

;~ Normalement � ce niveau l'installation MSI n'existe pas, il peut toutefois y avoir une installation normale
;~ On commence donc par dissocier tous les OCX et DLL enregistr�es dans le registre

if fileexists("C:\ANISEXEC") then 
	$res = GetFolderUse("C:\ANISEXEC",0)
	if $res <> "" then
		$File=ouvrirfichier(@ScriptDir &"\DEBUG.LOG",2)
		FileWrite($File,$res)
		FileClose($File)
		Exit
	endif
	RunWait(@ComSpec & " /c " & "REGSVR32.EXE /U /S C:\ANISEXEC\MSXML4.DLL","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "IF EXIST " &@SYSTEMDIR  &"\MSXML4.DLL REGSVR32.EXE /I /S " & @SYSTEMDIR &"\MSXML4.DLL","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "REGSVR32.EXE /U /S C:\ANISEXEC\Roboex32.dll","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "IF EXIST " &@SYSTEMDIR  &"\Roboex32.dll REGSVR32.EXE /I /S " & @SYSTEMDIR &"\Roboex32.dll","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "FOR %I IN (C:\ANISEXEC\*.OCX) DO REGSVR32.EXE /U /S %I","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "FOR %I IN (C:\ANISEXEC\*.OCX) DO IF EXIST " &@SYSTEMDIR  &"\%~nxi REGSVR32.EXE /I /S " & @SYSTEMDIR &"\%~nxi","",@SW_HIDE)
;~ 	Et on supprime le dossier
	DirRemove("C:\ANISEXEC",1)
endif

;~ On enl�ve les raccourcis

if fileexists(@ProgramsCommonDir &"\ANIS") then DirRemove(@ProgramsCommonDir &"\ANIS",1)
if fileexists(@DesktopCommonDir & "\USAGER.LNK") then Filedelete(@DesktopCommonDir & "\USAGER.LNK")
if fileexists(@DesktopCommonDir & "\PRESTATAIRE.LNK") then Filedelete(@DesktopCommonDir & "\PRESTATAIRE.LNK")
if fileexists(@DesktopCommonDir & "\ENVIRONNEMENT.LNK") then Filedelete(@DesktopCommonDir & "\ENVIRONNEMENT.LNK")
if fileexists(@DesktopCommonDir & "\TRAITEMENTS.LNK") then Filedelete(@DesktopCommonDir & "\TRAITEMENTS.LNK")
if fileexists(@DesktopCommonDir & "\FINANCE-PAIE.LNK") then Filedelete(@DesktopCommonDir & "\FINANCE-PAIE.LNK")

;~ On enl�ve le dossier ANISSAUV et le fichier Anis.ini

if fileexists("C:\ANISSAUV") then DirRemove("C:\ANISSAUV",1)
if fileexists(@WINdowsDIR & "\ANIS.INI") then FileDelete(@Windowsdir & "\ANIS.INI")

;~ On enl�ve les entr�es ODBC

regdelete("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\IODAP")
regdelete("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\IODAV")
regdelete("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\IODAT")
regdelete("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC DATA SOURCES","IODAP")
regdelete("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC DATA SOURCES","IODAV")
regdelete("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC DATA SOURCES","IODAT")

FileDelete("C:\SI\IODAS*.OK")

if $mode = "INSTALL" Then

	FileInstall("..\DATA\IODAS_ODBC.REG",@TEMPDIR & "\IODAS_ODBC.REG",1)

;~ 	Extraction du dossier AnisExec a partir du Self Extracting Anisexec.exe
	if not FileExists($ExtractDir) Then	DirCreate($ExtractDir)
;~ 	BlockInput(1)
	Run (@scriptdir & "\" & $archiveName,$ExtractDir)
	WinWait("7-Zip self-extracting archive","",10)
	if WinExists("7-Zip self-extracting archive") then
		ControlSend("7-Zip self-extracting archive","","Edit1",$ExtractDir)
		ControlClick("7-Zip self-extracting archive","",1)
		Opt("WinTitleMatchMode", 2)
 		WinSetState("Extracting","",@SW_MINIMIZE)
		ControlDisable("Extracting","",2)
		Opt("WinTitleMatchMode", 1)
	Else
;~ 		blockinput(0)
		msgbox (16,"Erreur...","Le d�compresseur " & $ArchiveName & " n'a pas r�pondu dans les d�lais...")
		Exit
	endif
	
	while processexists($ArchiveName) 
		sleep(250)
	WEnd
	
;~ Ajout des entr�es ODBC

	RunWait(@WindowsDIr & "\regedit.exe /S " & @tempdir &"\IODAS_ODBC.REG")

;~ Enregistrement des ocx

	RunWait(@ComSpec & " /c " & "FOR %I IN (C:\ANISEXEC\*.OCX) DO REGSVR32.EXE /I /S %I","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "REGSVR32.EXE /I /S C:\ANISEXEC\MSXML4.DLL","",@SW_HIDE)
	RunWait(@ComSpec & " /c " & "REGSVR32.EXE /I /S C:\ANISEXEC\Roboex32.dll","",@SW_HIDE)
	
;~ Ajout du fichier ANIS.ANI

	FileCopy("c:\ANISEXEC\ANIS.INI",@WINDOWSDIR,1)

;~ Ajout des entr�es de registre

;~ Comme les entr�es changent � chaque mise � jour de iodas, le plus simple est d'�xecuter chacun des exe et de les fermer directement

	Run("C:\ANISEXEC\ANIS1.EXE");,"",@SW_HIDE)
	Run("C:\ANISEXEC\ANIS2.EXE");,"",@SW_HIDE)
	Run("C:\ANISEXEC\ANIS3.EXE");,"",@SW_HIDE)
	Run("C:\ANISEXEC\ANIS4.EXE");,"",@SW_HIDE)
	Run("C:\ANISEXEC\ANIS5.EXE");,"",@SW_HIDE)
	
	WinSetState("Connexion � IODAS","",@SW_MINIMIZE)
	sleep(5000) ;  On laisse 5 secondes histoire que les programmes se chargent compl�tement
	processwait("anis5.exe",15) ; Encore 5 secondes suppl�mentaires pour le dernier au cas ou
	
;~ 	On recherche tous les process commencant par anis
	$Running_Processes = ""
	$VAR=ProcessList()
	for $i = 1 to $Var[0][0]
		if StringLeft($Var[$i][0],stringlen($Minuteur_APP)) = $Minuteur_APP Then $Running_Processes= $var[$i][1] & ";" & $Running_Processes
	next
;~ 	et on les tue	
	if $Running_Processes <> "" Then
		$VAR=StringSplit($Running_Processes,";")
		for $i=1 to $VAR[0]
			ProcessClose($VAR[$i])
		next
	endif

;~ 	On redonne le clavier/souris � l'utilisateur
	blockinput(0)

;~ Ajout des raccourcis

	DirCreate(@ProgramsCommonDir & "\ANIS")

	FileCreateShortcut("C:\ANISEXEC\ANIS1.EXE",@ProgramsCommonDir & "\ANIS\ENVIRONNEMENT.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS2.EXE",@ProgramsCommonDir & "\ANIS\USAGER.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS3.EXE",@ProgramsCommonDir & "\ANIS\PRESTATAIRE.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS4.EXE",@ProgramsCommonDir & "\ANIS\FINANCE-PAIE.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS5.EXE",@ProgramsCommonDir & "\ANIS\TRAITEMENTS.LNK")

	FileCreateShortcut("C:\ANISEXEC\ANIS1.EXE",@DesktopCommonDir & "\Environnement.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS2.EXE",@DesktopCommonDir & "\Usager.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS3.EXE",@DesktopCommonDir & "\Prestataire.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS4.EXE",@DesktopCommonDir & "\Finance-Paie.LNK")
	FileCreateShortcut("C:\ANISEXEC\ANIS5.EXE",@DesktopCommonDir & "\Traitements.LNK")

	WriteFlag("IODAS-410102-a.OK")
	
endif


