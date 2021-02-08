;~ #############################################################################################################################################################
;~																	IIS Automated Installer
;~

;~ Description:	This script is used to install IIS7 onto a Windows 7 PC
;~ 				in silent mode.  Even though IIS7 does have the ability For
;~ 				silent mode, the application deployment software we currently
;~ 				use (LANDesk Management Suite 9), is limited with the types of
;~ 				switches the instller uses, much simpler to deploy the software
;~ 				using a script file then mess around with the installer and LDMS.
;~ 			
;~ Resources:		http://learn.iis.net/page.aspx/133/using-unattended-setup-to-install-iis-70/

;~ Use:			Executing the application with no parameters defined will result 
;~ 				in the default installation of IIS7.  The script will take parameters of
;~ 				installer options to install.
;~ 				
;~ 				Default Installation consists of:
;~ 					IIS-WebServerRole;IIS-WebServer;WAS-WindowsActivationService;WAS-ProcessModel;WAS-NetFxEnvironment;WAS-ConfigurationAPI
;~					IIS-StaticContent;IIS-DefaultDocument;IIS-DirectoryBrowsing;IIS-HttpErrors;IIS-BasicAuthentication;IIS-WindowsAuthentication;
;~					IIS-HttpCompressionStatic;IIS-WebServerManagementTools;IIS-IIS6ManagementCompatibility;

;~ 				Additional options are:
;~ 					IIS-WebServerRole;IIS-WebServer;IIS-CommonHttpFeatures;IIS-StaticContent;IIS-DefaultDocument;IIS-DirectoryBrowsing;IIS-HttpErrors;IIS-HttpRedirect;
;~ 					IIS-ApplicationDevelopment;IIS-ASPNET;IIS-NetFxExtensibility;IIS-ASP;IIS-CGI;IIS-ISAPIExtensions;IIS-ISAPIFilter;IIS-ServerSideIncludes;
;~ 					IIS-HealthAndDiagnostics;IIS-HttpLogging;IIS-LoggingLibraries;IIS-RequestMonitor;IIS-HttpTracing;IIS-CustomLogging;IIS-ODBCLogging;IIS-Security;
;~ 					IIS-BasicAuthentication;IIS-WindowsAuthentication;IIS-DigestAuthentication;IIS-ClientCertificateMappingAuthentication;
;~ 					IIS-IISCertificateMappingAuthentication;IIS-URLAuthorization;IIS-RequestFiltering;IIS-IPSecurity;IIS-Performance;IIS-HttpCompressionStatic;
;~ 					IIS-HttpCompressionDynamic;IIS-WebServerManagementTools;IIS-ManagementConsole;IIS-ManagementScriptingTools;IIS-ManagementService;
;~ 					IIS-IIS6ManagementCompatibility;IIS-Metabase;IIS-WMICompatibility;IIS-LegacyScripts;IIS-LegacySnapIn;IIS-FTPPublishingService;IIS-FTPServer;
;~ 					IIS-FTPManagement;WAS-WindowsActivationService;WAS-ProcessModel;WAS-NetFxEnvironment;WAS-ConfigurationAPI

;~ 				The parameters should be defined as options seperated with a semicolon with no spaces in between.

;~ 				Example:
;~ 					IIS-WebServerRole;WAS-WindowsActivationService;WAS-ProcessModel

;~ Error Codes:	http://desktopengineer.com/windowsinstallererrorcodes
;~
;~ #############################################################################################################################################################


;~ Define Global Varialbes
	#AutoIt3Wrapper_icon=iis7_icon.ico
	Global $nOSversion = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentVersion") ; Assign OS version number to variable
		;~	$nOSversion = 6.1	Windows 7
		;~	$nOSversion = 6.0	Windows Vista
		;~	$nOSversion = 5.1	Windows XP
	
	$qtyParameters = 0
	
	If $cmdLine[0] >0 Then
		$parmApplications = $cmdLine[1]
	Else
		$parmApplications = "IIS-WebServerRole;IIS-WebServer;WAS-WindowsActivationService;WAS-ProcessModel;WAS-NetFxEnvironment;WAS-ConfigurationAPI;IIS-StaticContent;IIS-DefaultDocument;IIS-DirectoryBrowsing;IIS-HttpErrors;IIS-BasicAuthentication;IIS-WindowsAuthentication;IIS-HttpCompressionStatic;IIS-WebServerManagementTools;IIS-IIS6ManagementCompatibility"
	EndIf	
	
;~	Only install onto Windows 7 or Windows Vista.
 	If $nOSversion = 6.1 Then
		If $parmApplications<>"" Then
			$result = RunWait(@ComSpec & " /c ""start /w pkgmgr.exe /l:log.etw /iu:IIS-WebServerRole;WAS-WindowsActivationService;WAS-ProcessModel;WAS-NetFxEnvironment;WAS-ConfigurationAPI"" ","",@SW_SHOW)

;~ 			start /w pkgmgr /l:log.etw /iu:IIS-WebServerRole;WAS-WindowsActivationService;WAS-ProcessModel;WAS-NetFxEnvironment;WAS-ConfigurationAPI
			MsgBox(0, "Results", $result)
			Exit $result
		Else
			Exit 87 ;87 = One of the Parameters was incorrect.
		EndIf
	Else
		Exit 1259 ;1259 = Incompatible with the OS.
	EndIf
	
	