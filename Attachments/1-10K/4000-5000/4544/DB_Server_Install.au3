; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Jason F.
;
; Script Function:
;	Automated Docubase Enterprise Installation v1.0
;
;	Eliminate majority of all user intervention during the install process. 
;	Installs: MS SQL Server 2000a, Docubase Enterprise (Server & Client) to the server machine.
;	Updates the client installation, edits all pertinent Docubase files (namely the parmsta.ini 
;	file. Basically does all steps that a technician would perform if he/she were out
;	at a customers site performing an install.
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
$dbtemp="c:\dbtemp"

if fileexists($dbtemp & "\") then
	filedelete($dbtemp & "\*.*")
	dirremove($dbtemp & "\server", 1)
	dirremove($dbtemp & "\client", 1)
endif

; Declaration of Installation variables
global $name, $company, $serial, $dbserver_name, $dbdomain, $port, $srvpath, $basket_loc, $clfolder, $basket

func checkstate($winstate, $title)
	while not bitand($winstate, 8)
		winsetstate($title, @SW_ENABLE)
		;winactivate($title)
	wend
endfunc

;Variables are read in from .ini file
 ;Constants - Variables that will be used multiple times during the installation.
  $name = iniread(@scriptdir & "\dbinstall.ini", "Constants", "Name", "")
  $company = iniread(@scriptdir & "\dbinstall.ini", "Constants", "Company", "")
  $serial = iniread(@scriptdir & "\dbinstall.ini", "Constants", "Serial", "")
  $dbserver_name = iniread(@scriptdir & "\dbinstall.ini", "Constants", "DBServer_name", "")
  $dbdomain = iniread(@scriptdir & "\dbinstall.ini", "Constants", "DBDomain_name", "")
  $port = iniread(@scriptdir & "\dbinstall.ini", "Constants", "Basket_port", "")

 ;Server Install Info - Information that will be used only once during the
 ;installation of the Docubase Server application.
  $srvpath = iniread(@scriptdir & "\dbinstall.ini", "Server_install_info", "Install_path", "")
  $basket_loc = iniread(@scriptdir & "\dbinstall.ini", "Server_install_info", "Basket_location", "")
  $srvfolder = iniread(@scriptdir & "\dbinstall.ini", "Server_install_info", "Program_folder", "")
 
 ;Client Install Info - Information that will be used only once during the
 ;installation of the Docubase Client application
  $clientpath = iniread(@scriptdir & "\dbinstall.ini", "Client_install_info", "Install_path", "")
  $basket_srv = iniread(@scriptdir & "\dbinstall.ini", "Client_install_info", "Basket_server", "")
  $clfolder = iniread(@scriptdir & "\dbinstall.ini", "Client_install_info", "Program_folder", "")

  $dbpath=stringtrimright(iniread(@scriptdir & "\dbinstall.ini", "Server_install_info", "Install_path", ""),7 )
  $ClientPathOnServer=$dbpath & "\client"

; End declaration of variables

dircreate($dbtemp)

$splash1=$dbtemp & "\Install Screen MSDE.jpg"
fileinstall("d:\dbinstall\Images\server\Install Screen MSDE.jpg", $splash1, 1)

$splash2=$dbtemp & "\Install Screen Server.jpg"
Fileinstall("d:\dbinstall\Images\server\Install Screen Server.jpg", $splash2, 1)

$splash3=$dbtemp & "\Install Screen Client.jpg"
Fileinstall("d:\dbinstall\Images\server\Install Screen Client.jpg", $splash3, 1)

$splash4=$dbtemp & "\Install Screen Configuration.jpg"
Fileinstall("d:\dbinstall\Images\server\Install Screen Configuration.jpg", $splash4, 1)

$splash5=$dbtemp & "\Install Screen Customization.jpg"
Fileinstall("d:\dbinstall\Images\server\Install Screen Customization.jpg", $splash5, 1)

$splash0=$dbtemp & "\Install Screen.jpg"
Fileinstall("d:\dbinstall\Images\server\Install Screen.jpg", $splash0, 1)



;Turn on first splash image.
;SplashImageOn("Docubase Install", $splash0, @desktopwidth, @desktopheight, -1, -1, 1)



$destination=$dbtemp & "\rar.exe"
fileinstall("d:\dbinstall\rar.exe", $destination, 1)

$destination=$dbtemp & "\DB_server.exe"
fileinstall("d:\dbinstall\DB_Server.exe", $destination, 1)

$destination=$dbtemp & "\structure.exe"
fileinstall("D:\dbinstall\structure.exe", $destination, 1)

$destination=$dbtemp & "\dao.exe"
fileinstall("d:\dbinstall\dao.exe", $destination, 1)

$destination=$dbtemp & "\DbBases.exe"
fileinstall("d:\dbinstall\DbBases.exe", $destination, 1)

$destination=$dbtemp & "\deleteme.bat"
FileInstall("D:\dbInstall\SQL & WDA\deleteme.bat", $destination, 1)

$destination=$dbtemp & "\finalize.exe"
FileInstall("D:\dbInstall\SQL & WDA\finalize.exe", $destination, 1)

$destination=$dbtemp & "\MSDEinstall.exe"
FileInstall("D:\dbInstall\SQL & WDA\MSDEinstall.exe", $destination, 1)

$destination=$dbtemp & "\dblots.bak"
fileinstall("D:\dbInstall\SQL & WDA\dblots.bak", $destination, 1)


;Install SQL Server
;SplashImageOn("Docubase Install", $splash1, @desktopwidth, @desktopheight, -1, -1, 1)

$sqldatadir=$dbpath & "\DBSQL\"

$rar=$dbtemp & "\rar.exe x " & $dbtemp &"\msdeinstall.exe -o+ -inull c:\MSDEInstall\"
RUNwait($rar, "", @SW_HIDE)


iniwrite("c:\MSDEInstall\setup.ini", "Options", "DATADIR", $sqldatadir)

Run("C:\MSDEInstall\setup.exe")
WinWaitActive("Microsoft SQL Server Desktop Engine")
WinWaitClose("Microsoft SQL Server Desktop Engine")
DirRemove("C:\MSDEInstall", 1)

$Backupdir=$sqldatadir & "backup"
dircreate($Backupdir)
filemove($dbtemp & "\dbLots.bak", $backupdir)

;Create SQL Script
$SQL = fileopen("C:\dblots_script.sql", 2)
	filewriteline($sql, "USE master")
	filewriteline($sql, "go")
	filewriteline($sql, "exec sp_addumpdevice 'disk', 'dblots_backup', '" & $Backupdir &"\dblots.bak'")
	filewriteline($sql, "go")
	filewriteline($sql, "restore database dbLots from dbLots_backup")
	filewriteline($sql, "go")
	filewriteline($sql, "exec sp_addlogin 'DBUser', 'cegedim', 'dbLots'")
	filewriteline($sql, "go")
	filewriteline($sql, "use dblots")
	filewriteline($sql, "go")
	filewriteline($sql, "exec sp_adduser 'DBUser', 'Docubase User'")
	filewriteline($sql, "go")
	filewriteline($sql, "exec sp_addrolemember 'db_owner', 'Docubase User'")
	filewriteline($sql, "go")
	filewriteline($sql, "quit")  

; Uncompress Server files and begin installation:

;SplashImageOn("Docubase Install", $splash2, @desktopwidth, @desktopheight, -1, -1, 1)

$rar=$dbtemp & "\rar.exe x " & $dbtemp &"\db_server.exe -o+ -inull c:\dbtemp\"
runwait($rar, "", @SW_HIDE)

  run("c:\dbtemp\server\setup.exe")
  
  winwaitactive("Welcome")
	$title="Welcome"
	$winstate=wingetstate("Welcome")
	checkstate($winstate, $title)
  	controlfocus("Welcome", "Next >", 1)
	ControlClick("Welcome", "Next >", 1)

  winwaitactive("Software License Agreement")
	$title="Software License Agreement"
	$winstate=wingetstate("Software License Agreement")
	checkstate($winstate, $title)
	controlfocus("Software License Agreement", "Yes", 6)
	ControlClick("Software License Agreement", "Yes", 6)
  
  winwaitactive("User Information")
	$title="User Information"
	$winstate=wingetstate("User Information")
	checkstate($winstate, $title)
	send($name & "{TAB}" & $company & "{TAB}" & $serial)
	controlfocus("User Information", "Next >", 1)
	controlclick("User Information", "Next >", 1)

  winwaitactive("Choose Destination Location")
	controlfocus("Choose Destination Location", "B&rowse...", 196)
	ControlClick("Choose Destination Location", "B&rowse...", 196)
  		winwaitactive("Choose Folder")
		$title="Choose Folder"
		$winstate=wingetstate("Choose Folder")
		checkstate($winstate, $title)
		send($srvpath)
			controlfocus("Choose Folder", "OK", 1)
			controlclick("Choose Folder", "OK", 1)
				winwaitactive("Setup")
					$title="Setup"
					$winstate=wingetstate("Setup")
					checkstate($winstate, $title)
					controlfocus("Setup", "Yes", 6)
					controlclick("Setup", "Yes", 6)
				winwaitclose("Setup")
		winwaitclose("Choose Folder")
	WinwaitActive("Choose Destination Location")
	$title="Choose Destination Location"
	$winstate=wingetstate("Choose Destination Location")
	checkstate($winstate, $title)
  	controlfocus("Choose Destination Location", "Next >", 1)
	controlclick("Choose Destination Location", "Next >", 1)
	

  WinWaitactive("Select Components")
	$title="Select Componenets"
	$winstate=wingetstate("Select Components")
	checkstate($winstate, $title)
	controlfocus("Select Components", "Next >", 1)
	controlclick("Select Components", "Next >", 1)

   ; In subsequent revisions, the Web Retrieval installation phase will have to go here.
   ; probably a good line:  if winexists("Web retrieval window") then web_install()


  winwaitactive("Server network choice")
	$title="Server network choice"
	$winstate=wingetstate("Server network choice")
	checkstate($winstate, $title)
	send($dbserver_name & "{tab}" & $dbdomain)
	controlfocus("Server network choice", "Next >", 1)
	controlclick("Server network choice", "Next >", 1)

  
;Waits to see if the Docubase Baskets Server will appear before continuing...
  if winwaitactive("Docubase baskets server name identification.", "", 3)=1 then
   $basket=1
   send("!R")
   winwaitactive("Choose Folder")
    send($basket_loc & "{enter}")
    send("!N")
   winwaitactive("Port Determination")
    send($port & "{enter}")
  endif


  winwaitactive("Select Program Folder")
	$title="Select Program Folder"
	$winstate=wingetstate("Select Program Folder")
	checkstate($winstate, $title)
   	;controlfocus("Select Program Folder", "", 301)
	send($srvfolder & "{ENTER}")
	;controlfocus("Server Program Folder", "Next >", 1)
	;controlclick("Server Program Folder", "Next >", 1)

  winwaitactive("Options")
	$title="Options"
	$winstate=wingetstate("Options")
	checkstate($winstate, $title)
	controlfocus("Options", "Create services entry in the NT registry.", 602)
	controlclick("Options", "Create services entry in the NT registry.", 602)
	controlfocus("Options", "Next >", 1)
	controlclick("Options", "Next >", 1)
    if $basket=1 then
     send("{DOWN}")
     send("{space}")
    endif
   send("{enter}")

  winwaitactive("Registry Editor")
   send("!Y")
  winwaitactive("Registry Editor")
  winwaitactive("Registry Editor")
   send("{ENTER}")
  winwaitclose("Registry Editor")
  
  sleep(2000)
  if winexists("Registry Editor") then
	controlfocus("Registry Editor", "Yes", 6)
	controlclick("Registry Editor", "Yes", 6)
   sleep(100)
	controlfocus("Registry Editor", "OK", 2)
	controlclick("registry Editor", "OK", 2)
   winwaitclose("Registry Editor")
  endif

  While 1
   If Controlcommand("Setup Complete", "Finish", 1, "IsVisible", "") Then exitloop
  wend
	ControlFocus("Setup Complete", "Finish", 1)
	ControlClick("Setup Complete", "Finish", 1)

  winwaitactive("Information")
	controlfocus("Information", "OK", 2)
	controlclick("Information", "OK", 2)

  winwaitclose("Docubase Systems")
;end server installation


;Begin Client installation
;SplashImageOn("Docubase Install", $splash3, @desktopwidth, @desktopheight, -1, -1, 1)


run("c:\dbtemp\client\setup.exe")

  winwaitactive("Welcome")
	$title="Welcome"
	$winstate=wingetstate("Welcome")
	checkstate($winstate, $title)
	controlfocus("Welcome", "Next >", 1)
	ControlClick("Welcome", "Next >", 1)
 
  winwaitactive("Software License Agreement")
	$title="Software License Agreement"
	$winstate=wingetstate("Software License Agreement")
	checkstate($winstate, $title)
	controlfocus("Software License Agreement", "Yes", 6)
	ControlClick("Software License Agreement", "Yes", 6)

  winwaitactive("User Information")
	$title="User Information"
	$winstate=wingetstate("User Information")
	checkstate($winstate, $title)
	send($name & "{TAB}" & $company & "{TAB}" & $serial)
	controlfocus("User Information", "Next >", 1)
	controlclick("User Information", "Next >", 1)

  winwaitactive("Setup type choice")
	$title="Setup type choice"
	$winstate=wingetstate("Setup type choice")
	checkstate($winstate, $title)
	controlfocus("Setup type choice", "Next >", 1)
	controlclick("Setup type choice", "Next >", 1)

  winwaitactive("Choose Destination Location")
	$title="Choose Destination Location"
	$winstate=wingetstate("Choose Destination Location")
	checkstate($winstate, $title)
	controlfocus("Choose Destination Location", "B&rowse...", 196)
	ControlClick("Choose Destination Location", "B&rowse...", 196)
  		winwaitactive("Choose Folder")
		$title="Choose Folder"
		$winstate=wingetstate("Choose Folder")
		checkstate($winstate, $title)
		send($ClientPathOnServer)
			controlfocus("Choose Folder", "OK", 1)
			controlclick("Choose Folder", "OK", 1)
				winwaitactive("Setup")
					$title="Setup"
					$winstate=wingetstate("Setup")
					checkstate($winstate, $title)
					controlfocus("Setup", "Yes", 6)
					controlclick("Setup", "Yes", 6)
				winwaitclose("Setup")
		winwaitclose("Choose Folder")
	WinwaitActive("Choose Destination Location")
	$title="Choose Destination Location"
	$winstate=wingetstate("Choose Destination Location")
	checkstate($winstate, $title)
  	controlfocus("Choose Destination Location", "Next >", 1)
	controlclick("Choose Destination Location", "Next >", 1)


  WinWaitactive("Select Components")
	$title="Select Components"
	$winstate=wingetstate("Select Components")
	checkstate($winstate, $title)
	controlfocus("Select Components", "Next >", 1)
	controlclick("Select Components", "Next >", 1)

  winwaitactive("Server name identification.")
	$title="Server name identification."
	$winstate=wingetstate("Server name identification")
	checkstate($winstate, $title)
	controlfocus("Server name identification.", "", 301)
		send($dbserver_name & "{tab}" & $dbdomain)
			controlfocus("Server name identification.", "Next >", 1)
			controlclick("Server name identification.", "Next >", 1)

  winwaitactive("Question")
	$title="Question"
	$winstate=wingetstate("Question")
	checkstate($winstate, $title)
	controlfocus("Question", "Yes", 6)
	controlclick("Question", "Yes", 6)

  winwaitactive("Select Program Folder")
	$title="Select Program Folder"
	$winstate=wingetstate("Select Program Folder")
	checkstate($winstate, $title)
	controlfocus("Select Program Folder", "", 301)
	send($clfolder & "{ENTER}")
		;controlfocus("Select Program Folder", "Next >", 1)
		;controlclick("Select Program Folder", "Next >", 1) 
  
  winwaitactive("General information")
	$title="General information"
	$winstate=wingetstate("General information")
	checkstate($winstate, $title)
	controlfocus("General information", "Next >", 1)
	controlclick("General information", "Next >", 1)

  winwaitactive("View options.")
	$title="View options."
	$winstate=wingetstate("View options.")
	checkstate($winstate, $title)
	controlfocus("View options.", "Next >", 1)
	controlclick("View options.", "Next >", 1)
  
  winwaitactive("Setup Complete")
	$title="Setup Complete"
	$winstate=wingetstate("Setup Complete")
	checkstate($winstate, $title)
	controlfocus("Setup Complete", "Finish", 1)
	controlclick("Setup Complete", "Finish", 1)
  
  winwaitactive("Information")
	$title="Information"
	$winstate=wingetstate("Information")
	checkstate($winstate, $title)
	controlfocus("Information", "OK", 2)
	controlclick("Information", "OK", 2)

 winwaitclose("Docubase Systems") 

;Install remaining directory structure:
$structure=$dbpath & "\"
$rar=$dbtemp & "\rar.exe x " & $dbtemp &"\structure.exe -o+ -inull " & $structure
runwait($rar, "", @SW_HIDE) 

;Perform updates:
;SplashImageOn("Docubase Install", $splash4, @desktopwidth, @desktopheight, -1, -1, 1)

filechangedir($ClientPathOnServer)
run("regsvr32 -u dbeditfile.ocx")
winwaitactive("RegSvr32")
 send("{enter}")

filemove("dbeditfile.ocx", "dbeditfile612sr3.ocx")
filemove("dbsearch.exe", "dbsearch612sr3.exe")


$source = $dbpath & "\DbInstallTools\DbUpdates\DocubaseC\*.*"
$destination = $ClientPathOnServer & "\"
filecopy($source, $destination, 1)


run("regsvr32 dbeditfile.ocx")
 winwaitactive("RegSvr32")
 send("{Enter}")

run("regsvr32 SsxBc30.dll")
 winwaitactive("RegSvr32")
 send("{enter}")


;Modify Scan Templates to reflect correct server locations
filechangedir($dbpath & "\DbInstallTools\DbUpdates\WindowsDIR")
	filedelete("Standard.sca")
	iniwrite("Color.sca", "DBSCAN", "PATHIMAGE", "\\" & $dbserver_name & "\DbImageIn\Batches\")
	iniwrite("Multi-page Duplex.sca", "DBSCAN", "PATHIMAGE", "\\" & $dbserver_name & "\DbImageIn\Batches\")
	iniwrite("Multi-page One Side.sca", "DBSCAN", "PATHIMAGE", "\\" & $dbserver_name & "\DbImageIn\Batches\")
	iniwrite("One Side Document.sca", "DBSCAN", "PATHIMAGE", "\\" & $dbserver_name & "\DbImageIn\Batches\")

	   
filedelete(@windowsdir & "\db*.ini")
$inisource = $dbpath & "\DbInstallTools\DbUpdates\WindowsDIR\*.*"
filecopy($inisource, @windowsdir, 1)

dirremove($ClientPathOnServer & "\DAO", 1)
$rar=$dbtemp & "\rar.exe x " & $dbtemp &"\dao.exe -o+ -inull " & $ClientPathOnServer
runwait($rar, "", @SW_HIDE)

$daopath=$ClientPathOnServer & "\DAO"
filechangedir($daopath)
runwait($daopath & "\setup.exe -s")

;End updates

sleep(5000)
;edit Client Parmsta.ini file on server

;SplashImageOn("Docubase Install", $splash5, @desktopwidth, @desktopheight, -1, -1, 1)

$parmpath=$ClientPathOnServer & "\parmsta.ini"
$srvparm=$dbpath & "\server"
iniwrite($parmpath, "DBSEARCH", "LSTRUNACTION", $ClientPathOnServer & "\dbexportcsv.DLL")
iniwrite($parmpath, "DBSEARCH", "TAGLIBRARY", $ClientPathOnServer & "\dbtagbld.dll")
iniwrite($parmpath, "DBSEARCH", "WORKINGBASKET", $ClientPathOnServer & "\Working Basket")
iniwrite($parmpath, "DBSEARCH", "SCANLIBRARY", $ClientPathOnServer & "\dbscanbase.dll")
iniwrite($parmpath, "DBSEARCH", "EMAILLIBRARY", $ClientPathOnServer & "\dbmapi.dll")
iniwrite($parmpath, "SERVICE", "SRVADMIN_0", $dbserver_name)
iniwrite($parmpath, "DBSCAN", "SCANLIBRARY", $ClientPathOnServer & "\dbscanbase.dll")
iniwrite($parmpath, "DBSCAN", "DIRLOT", "\\" & $dbserver_name & "\dbimagein\batches\")
iniwrite($parmpath, "DBPREARC", "TAGLIBRARY", $ClientPathOnServer & "\dbtagbld.dll")
iniwrite($parmpath, "DBPREARC", "ARCDIR", $ClientPathOnServer & "\documents\")
iniwrite($parmpath, "DBPREARC", "SCANLIBRARY", $ClientPathOnServer & "\dbscanbase.dll")
iniwrite($parmpath, "DBPREARC", "EMAILLIBRARY", $ClientPathOnServer & "\dbmapi.dll")
iniwrite($parmpath, "DBMANAGER", "FILEBASE", "ODBC;DSN=dbLots;Description=Batch Manager;UID=DBUser;PWD=cegedim;APP=Docubase Enterprise;WSID=" & @ComputerName & ";DATABASE=dbLots")
iniwrite($parmpath, "DWCTLVW", "EMAILLIBRARY", $ClientPathOnServer & "\dbmapi.dll")
iniwrite($parmpath, "DBTAG", "Custom Forms", $ClientPathOnServer & "\dbtagbld.dll")
iniwrite($srvparm & "\service\parmsta.ini", "SERVICE", "SRVDIR_0", $dbpath & "\DbBases")
iniwrite($srvparm & "\admin\parmsta.ini", "SERVICE", "SRVDIR_0", $dbpath & "\DbBases")



;Move DEMO base, import INSURANC base, delete original DOCUBASE.USR file (..\docubase\service\docubase.usr)

$source = $srvparm & "\service\demo.*"
$destination=$dbpath & "\DbBases\"
	filemove($source, $destination)

$rar=$dbtemp & "\rar.exe x " & $dbtemp &"\DbBases.exe -o+ -inull " & $destination
runwait($rar, "", @SW_HIDE)


dircreate($destination & "demo.dbb")
$source = $srvparm & "\service\demo.dbb\*.*"
$destination=$dbpath & "\DbBases\demo.dbb\"
	filemove($source, $destination)
dircreate($destination & "\Worm")
dircreate($destination & "\Dasd")
$source = $srvparm & "\service\demo.dbb\Worm\*.*"
$destination = $destination & "Worm\"
	filemove($source, $destination)
dirremove($srvparm & "\service\demo.dbb", 1)


$source = $srvparm & "\service\docubase.usr"
	filedelete($source)

$source=$dbpath & "\DbInstallTools\DbUpdates\DOCUBASESERVICE\*.bat"
	filecopy($source, $dbpath & "\server\service", 1)


; Update parameters : .SIM, .BDS, .SRV files and registry information.


$destination=$dbpath & "\DbBases\"

filechangedir($destination)
	iniwrite("demo.bds", "service", "DIRINDEX", $destination & "demo.dbb")
	iniwrite("demo.bds", "service", "DIRSYN", $destination & "demo.dbb")
	iniwrite("insuranc.bds", "service", "DIRINDEX", $destination & "INSURANC.DBB")
	iniwrite("insuranc.bds", "server", "SRVSTO", $dbserver_name)
	iniwrite("insuranc.bds", "server", "SRVNDX", $dbserver_name)
	iniwrite("insuranc.srv", "WORM", "NEWODDIR", $destination & "\INSURANC.DBB\WORM")
	iniwrite("insuranc.srv", "WORM", ";NEWODCOPYDIR", $destination & "\INSURANC.DBB\WORM\BACKUP\")

;Recreate .SIM files
	$sim=fileopen("DEMO.SIM", 2)
		$VAR="[" & $dbpath & "\DbBases\demo.dbb\Worm\demo.000]"
		filewrite($sim, $VAR)		
	fileclose($sim)
		$VAR=""
	$sim=fileopen("INSURANC.SIM", 2)
		$VAR="[" & $dbpath & "\DbBases\INSURANC.DBB\WORM\INSURANC.000]"
		filewrite($sim, $VAR)
	fileclose($sim)


RegWrite("HKLM\SOFTWARE\DOCUBASE\DbServNT\DEMO", "DefPath", "REG_SZ", $dbpath & "\DbBases")
;regwrite("HKLM\SOFTWARE\DOCUBASE\DbServNT", "AdminLevel", "REG_DWORD", "1")
;regwrite("HKLM\SOFTWARE\DOCUBASE\DbServNT", "AdminLog", "REG_DWORD", "1")
regwrite("HKLM\SOFTWARE\DOCUBASE\DbServNT", "AdminUsrPath", "REG_SZ", $dbpath & "\DbBases")
;regwrite("HKLM\SOFTWARE\DOCUBASE\DbServNT", "IndexLevel", "REG_DWORD", "1")
;regwrite("HKLM\SOFTWARE\DOCUBASE\DbServNT", "StoreLevel", "REG_DWORD", "1")

;Add Insuranc Database to registry
regwrite("HKLM\SOFTWARE\DOCUBASE\DBServNT\INSURANC", "BaseRun", "REG_DWORD", "1")
regwrite("HKLM\SOFTWARE\DOCUBASE\DBServNT\INSURANC", "DefPath", "REG_SZ", $dbpath & "\DbBases")
regwrite("HKLM\SOFTWARE\DOCUBASE\DBServNT\INSURANC", "StoreOdc", "REG_DWORD", "0")

;Share off the DbImagein directory allowing full access to everyone.
$run="net share DbImagein=" & $dbpath & "\dbimagein /unlimited"
run($run)



;Splashoff()

;Prepare for reboot
filecopy(@ScriptDir & "\dbinstall.ini", "c:\dbinstall.ini")
FileCopy($dbtemp & "\finalize.exe", "C:\Documents and Settings\All Users\Start Menu\Programs\Startup\")
FileCopy($dbtemp & "\deleteme.bat", "C:\*.*")

;Clean up my mess....
filedelete($dbtemp & "\*.*")
dirremove($dbtemp & "\server", 1)
dirremove($dbtemp & "\client", 1)
dirremove($dbtemp)

$reboot = msgbox(65, "Installation Complete", "The installation of Docubase Server and related applications is almost complete. This machine must be rebooted in order to finalize the remaining software. Press OK to reboot, Cancel to reboot at a later time.")
	if $reboot=1 then
	 shutdown(2)
	 exit
	endif

msgbox(48, "Reminder", "This machine MUST be rebooted in order to finalize the installation.")
winwaitclose("Reminder")
exit