;~ #include <GUIConstantsEx.au3>
;~ #include <WindowsConstants.au3>
;~ #include <EditConstants.au3>
;~ #include <ButtonConstants.au3>
;~ #include <ProgressConstants.au3>
;~ #include <TokenGroup.au3>
;~ #include <File.au3>

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <ProgressConstants.au3>
#include <TokenGroup.au3>
#include <File.au3>

;Checks to see if the file exists and then deletes it
FileDelete('%TEMP%\ServersList')


   ; Declare Global variables
    Global $Username
	Global $Password
	Global $ComputerNamingLizardLocalRemote
    Global $ComputerNamingLizardLocal
   Run('taskkill.exe /IM AISD-411*','',@SW_HIDE)
   
   ;Checks to see if this is running in Windows PE while imaging a computer from a thumb drive
   If FileExists('X:\Windows\System32\Sysprep') THen
	  $ImagingComputer = '1'
	  Menu01()
   EndIf

;GUI for user to input username and password to check if they have network access
ComputerNamingLizardCreds()
Func ComputerNamingLizardCreds()
    Local $msg
    Global $CNLRA = GUICreate("Computer Naming Lizard RunAs", 320, 150) ; will create a dialog box that when displayed is centered
    GUISetState(@SW_SHOW) ; will display an empty dialog box 
  $Username = GUICtrlCreateInput('',80, 30,220, 20)
  $Password =GUICtrlCreateInput('',80,60,220,20,$ES_PASSWORD)
	  GUICtrlSetState($Password,$GUI_DISABLE)
	  GUICtrlCreateLabel('Username and Password to RunAs', 5, 10, 200, 20 )
	  GUICtrlCreateLabel('Username:', 20, 32.5, 50, 20)
	  GUICtrlCreateLabel('Password:',20,62.5, 50,20)
  
	  $GOButton = GUICtrlCreateButton('GO!', 110, 90, 100, 40 )
	    GUICtrlSetState($GOButton, $GUI_DISABLE + $GUI_DEFBUTTON)
	  Do
		 Sleep(100)
	  Until StringLen(GUICtrlRead($Username)) = 5 ;Then
	  GUICtrlSetState($Password,$GUI_ENABLE)
	  Do
		 Sleep(100)
	  Until StringLen(GUICtrlRead($Password)) = 8 ;Then
	  GUICtrlSetState($GOButton,$GUI_ENABLE)
	  
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			 Case $GOButton
				;runs as user supplied credentials, ComputerNamingLizardCredentialsCheck.exe just opens and closes notepad.exe
				$CredCheck = RunAs(GUICtrlRead($Username),'domainname',GUICtrlRead($Password),0,'\\network\location\ComputerNamingLizardCredentialsCheck.exe','',@SW_HIDE)
				If $CredCheck = 0 Then
				   MsgBox(48,'Error','Incorrect username and/or password')
				   GUICtrlSetState($GOButton,$GUI_ENABLE)
				   GUIDelete($CNLRA)
				   ComputerNamingLizardCreds()
				EndIf
				If $CredCheck <> 0 Then
				CheckPermissions()
				Exit
			   EndIf
	     EndSwitch
		 				
	WEnd
EndFunc
 
 ;Checks to see if the supplied user credentials is a memeber of a specific network security group
 ;If the user is a memeber of 'Scripts Computer Naming Lizard Local & Remote' then they are able to change a local or remote computer
 ;If the user is a memeber of 'Scripts Computer Naming Lizard Local' then they are able to ONLY change local computers, REMOTE and LOCAL options never show, just the CHANGE LOCAL NAME NOW button
CheckPermissions()
Func CheckPermissions()
   
Global $ComputerNamingLizardLocalRemote = _ismembertoken('Scripts Computer Naming Lizard Local & Remote', GUICtrlRead($UserName))
Global $ComputerNamingLizardLocal = _ismembertoken('Scripts Computer Naming Lizard Local', GUICtrlRead($UserName) )

GUIDelete($CNLRA)
If $ComputerNamingLizardLocalRemote = 'True' Then Menu01()
If $ComputerNamingLizardLocal = 'True' Then Menu01()

Local $ComputerNamingLizardLocalRemote = '0'
Local $ComputerNamingLizardLocal = '0'

If $ComputerNamingLizardLocalRemote And $ComputerNamingLizardLocal = '0' Then
   MsgBox(16, 'Permission Required', 'You do not have appropriate permissions to run this utility')
   Exit
EndIf
EndFunc

;The very clean code you provided me goes here... thank you for all your hard work and all your assistance!

			 Case $ContinueNamingLizardButton
				;Disable Button
				GUICtrlSetState($RestartNamingLizardButton,$GUI_DISABLE)
				GUICtrlSetState($ContinueNamingLizardButton,$GUI_DISABLE)
				;Show OptionsGUICtrlSetState($ChangeNameNowButton,$GUI_SHOW)
				If $ComputerNamingLizardLocalRemote = '1' Then
					;GUICtrlSetState($ChangeNameNowButton,$GUI_SHOW) 
					GUICtrlSetState($NameLocalComputerRadio,$GUI_SHOW)
					GUICtrlSetState($NameRemoteComputerLabel,$GUI_SHOW)
					GUICtrlSetState($NameRemoteComputerRadio,$GUI_SHOW)
					GUICtrlSetState($NameRemoteComputerInput,$GUI_SHOW+$GUI_DISABLE)
					GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_SHOW+$GUI_DISABLE)
				EndIf
				If $ComputerNamingLizardLocal = '1' Then GUICtrlSetState($ChangeLocalNameNowButton,$GUI_SHOW)
				 If $ImagingComputer = '1' Then GUICtrlSetState($ChangeImageNameNowButton,$GUI_SHOW)
			 Case $NameLocalComputerRadio
				;Disable Options
				GUICtrlSetState($NameLocalComputerRadio,$GUI_DISABLE)
				GUICtrlSetState($NameRemoteComputerRadio,$GUI_DISABLE)
				;Show Options
				GUICtrlSetState($ChangeLocalNameNowButton,$GUI_SHOW)
			 Case $NameRemoteComputerRadio
				;Disable Options
				GUICtrlSetState($NameLocalComputerRadio,$GUI_DISABLE)
				GUICtrlSetState($NameRemoteComputerRadio,$GUI_DISABLE)
				;Enable Options
				GUICtrlSetState($NameRemoteComputerInput,$GUI_ENABLE)
				GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_ENABLE)
			 Case $NameRemoteComputerCheckBox
				GUICtrlSetState($NameRemoteComputerInput,$GUI_DISABLE)
				GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_DISABLE)
				$PleaseWait = GUICtrlCreateLabel('Checking Computer Account Type', 30, 505, 100, 50)
				$ProgressBar = GUICtrlCreateProgress(30, 535, 100, 5, $PBS_MARQUEE)
				  GUICtrlSendMsg(-1, $PBM_SETMARQUEE, True, 50)
			   ;runs a DSQUERY to get names of servers and not allow the program to continue, we don't want servers renamed, this runs a dsquery from a specified location
			    RunWait('cmd /c \Specified\Location\dsquery.exe * "DC=domainname,DC=org" -limit 0 -filter "(&(OperatingSystem=*server*))" > %TEMP%\ServersList','', @SW_HIDE)
				Do
				 Sleep(1000)
				Until FileExists('%TEMP%\ServersList') 
				$FileOpen = FileOpen('%TEMP%\ServersList', 0 )
				$ReadFile = FileRead($FileOpen)
				$String = StringInStr($ReadFile,GUICtrlRead($NameRemoteComputerInput))
			    If $String > 0 Then 
				   GUICtrlSetState($ProgressBar,$GUI_HIDE)
				   FileClose($FileOpen)
					 MsgBox(16,'Remote Computer Error!', 'Computer Account Type Does Not Allow Changing Name')
					 FileDelete('%TEMP%\ServersList')
					 GUICtrlSetData($NameRemoteComputerInput,'')
					 GUICtrlSetState($NameRemoteComputerInput,$GUI_ENABLE)
					 GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
					 GUICtrlSetState($PleaseWait,$GUI_HIDE)
					 EndIf
				IF $String = 0 Then GUICtrlSetState($ChangeRemoteNameNowButton,$GUI_SHOW)
					 GUICtrlSetState($PleaseWait,$GUI_HIDE)
					 GUICtrlSetState($ProgressBar,$GUI_HIDE)
			Case $ChangeLocalNameNowButton
			   Local $LizardComputerName = GUICtrlRead($1stNameInput) & '-' & GUICtrlRead($2ndNameInput) & '-' & GUICtrlRead($3rdNameInput) & '-' & GUICtrlRead($4thNameInput) & GUICtrlRead($5thNameInput)
			   Local $RemoteComputerName = GUICtrlRead($NameRemoteComputerInput)
			   $NameLocalComputerInfo = GUICtrlCreateLabel('Changing Local Computer Name From: ' & @ComputerName & ' To: ' & GUICtrlRead($1stNameInput) & '-' & GUICtrlRead($2ndNameInput) & '-' & GUICtrlRead($3rdNameInput) & '-' & GUICtrlRead($4thNameInput) & GUICtrlRead($5thNameInput),55, 545, 377, 20)
			   GUICtrlSetState($ChangeRemoteNameNowButton, $GUI_DISABLE)
			   $ProgressBar = GUICtrlCreateProgress(50, 568, 377, 20, $PBS_MARQUEE)
				  GUICtrlSendMsg(-1, $PBM_SETMARQUEE, True, 50)
				  $NetdomLocalComputer = RunWait('\Specified\Location\netdom.exe renamecomputer ' & @ComputerName & ' /NewName:' &  $LizardComputerName & ' /UserD:domainname\namer /PasswordD:password /Force /REBoot:10', '', @SW_HIDE)
				
			   ;Below are possible error codes that netdom will pass, I would like for these to popup a msgbox indicating errors. Error 0 is success
 			   Switch $NetDomLocalComputer
 			   Case 0
 				  MsgBox(64,'Computer Naming Lizard', 'Name Change Completed Successfully' & @CRLF & @CRLF & 'Reboot Command Sent To Remote Computer')
				  GUICtrlSetState($ProgressBar,$GUI_HIDE)
				  GUICtrlSetState($NameLocalComputerInfo,$GUI_HIDE)
				  GUICtrlSetState($ChangeLocalNameNowButton,$GUI_DISABLE)
				  GUICtrlSetState($ExitNamingLizard,$GUI_SHOW)
 			   Case 53
 				  MsgBox(48,'Computer Naming Lizard', 'Local Computer Not Found' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameLocalComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeLocalNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameLocalComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameLocalComputerInput,'')
 				  GUICtrlSetState($NameLocalComputerInput,$GUI_ENABLE)
 			   Case 87
 				  MsgBox(64,'Computer Naming Lizard', 'Local Computer Name Alread Exists' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameLocalComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeLocalNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameLocalComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameLocalComputerInput,'')
 				  GUICtrlSetState($NameLocalComputerInput,$GUI_ENABLE))
 			   Case 2227
 				  MsgBox(64,'Computer Naming Lizard', 'Account Already Exists' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameLocalComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeLocalNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameLocalComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameLocalComputerInput,'')
 				  GUICtrlSetState($NameLocalComputerInput,$GUI_ENABLE)
 			   Case 2697
 				  MsgBox(64,'Computer Naming Lizard', 'Local Computer Could Not Be Contacted' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameLocalComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeLocalNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameLocalComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameLocalComputerInput,'')
 				  GUICtrlSetState($NameLocalComputerInput,$GUI_ENABLE)
 			   EndSwitch
				  GUICtrlCreateLabel('Local Computer Renamed:' & @CRLF & 'From: ' & @ComputerName & @CRLF & 'To: ' & $LizardComputerName, 250, 542, 250, 60)
			
			;Remote computer name change
			Case $ChangeRemoteNameNowButton
			   Local $LizardComputerName = GUICtrlRead($1stNameInput) & '-' & GUICtrlRead($2ndNameInput) & '-' & GUICtrlRead($3rdNameInput) & '-' & GUICtrlRead($4thNameInput) & GUICtrlRead($5thNameInput)
			   Local $RemoteComputerName = GUICtrlRead($NameRemoteComputerInput)
			   GUICtrlSetState($ChangeRemoteNameNowButton, $GUI_DISABLE)
			   $NameRemoteComputerInfo = GUICtrlCreateLabel('Changing Remote Computer Name From: ' & GUICtrlRead($NameRemoteComputerInput) & ' To: ' & GUICtrlRead($1stNameInput) & '-' & GUICtrlRead($2ndNameInput) & '-' & GUICtrlRead($3rdNameInput) & '-' & GUICtrlRead($4thNameInput) & GUICtrlRead($5thNameInput),25, 545, 500, 20)
			   GUICtrlSetState($ChangeLocalNameNowButton, $GUI_DISABLE)
			   $ProgressBar = GUICtrlCreateProgress(50, 568, 377, 20, $PBS_MARQUEE)
				  GUICtrlSendMsg(-1, $PBM_SETMARQUEE, True, 50)
				  $NetdomRemoteComputer = RunWait('cmd /c \Specified\Location\netdom.exe renamecomputer ' & GUICtrlRead($NameRemoteComputerInput) & ' /NewName:' & $LizardComputerName & ' /UserD:domainname\namer /PasswordD:password /Force /REBoot:05', '', @SW_HIDE)
				  GUICtrlSetState($ProgressBar, $GUI_HIDE)
				  
			   ;again showing error codes passed from the netdom Executable
 			   Switch $NetDomRemoteComputer
 			   Case 0
 				  MsgBox(64,'Computer Naming Lizard', 'Name Change Completed Successfully' & @CRLF & @CRLF & 'Reboot Command Sent To Remote Computer')
        		  GUICtrlSetState($NameRemoteComputerInfo,$GUI_HIDE)
				  GUICtrlSetState($ChangeRemoteNameNowButton,$GUI_DISABLE)
				  GUICtrlSetState($ExitNamingLizard,$GUI_SHOW)
 			   Case 53
 				  MsgBox(48,'Computer Naming Lizard', 'Remote Computer Not Found' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameRemoteComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeRemoteNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameRemoteComputerInput,'')
 				  GUICtrlSetState($NameRemoteComputerInput,$GUI_ENABLE)
			   Case 87
 				  MsgBox(64,'Computer Naming Lizard', 'Remote Computer Name Alread Exists' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameRemoteComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeRemoteNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameRemoteComputerInput,'')
 				  GUICtrlSetState($NameRemoteComputerInput,$GUI_ENABLE))
 			   Case 2227
 				  MsgBox(64,'Computer Naming Lizard', 'Account Already Exists' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameRemoteComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeRemoteNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameRemoteComputerInput,'')
 				  GUICtrlSetState($NameRemoteComputerInput,$GUI_ENABLE)
 			   Case 2697
 				  MsgBox(64,'Computer Naming Lizard', 'Remote Computer Could Not Be Contacted' & @CRLF & @CRLF & 'Try Again' & @CRLF & @CRLF & 'No Changes Made')
 				  GUICtrlSetState($NameRemoteComputerInfo,$GUI_HIDE)
 				  GUICtrlSetState($ChangeRemoteNameNowButton,$GUI_HIDE+$GUI_ENABLE)
 				  GUICtrlSetState($NameRemoteComputerCheckbox,$GUI_UNCHECKED+$GUI_ENABLE)
 				  GUICtrlSetData($NameRemoteComputerInput,'')
 				  GUICtrlSetState($NameRemoteComputerInput,$GUI_ENABLE)
 			   EndSwitch
			   
			   ;Unable to get this working with sysprep at the moment, it does change the line I want it to change it's just that Sysprep still names the computer whatever it desires! HAHA
     		   Case $ChangeImageNameNowButton
				  _FileWriteToLine('E:\Windows\System32\sysprep\AISDUnattend.Enterprise.x86.xml', 31, '<ComputerName>' & GUICtrlRead($1stNameInput) & '-' & GUICtrlRead($2ndNameInput) & '-' & GUICtrlRead($3rdNameInput) & '-' & GUICtrlRead($4thNameInput) & GUICtrlRead($5thNameInput) & '</ComputerName>', 0)
				  GUICtrlCreateLabel('Computer Name Set To: ' &  GUICtrlRead($1stNameInput) & '-' & GUICtrlRead($2ndNameInput) & '-' & GUICtrlRead($3rdNameInput) & '-' & GUICtrlRead($4thNameInput) & GUICtrlRead($5thNameInput),25, 545, 500, 20)
				  GUICtrlSetState($ChangeImageNameNowButton,$GUI_DISABLE)
				  GUICtrlSetState($ExitNamingLizard,$GUI_SHOW)
		 Case $ExitNamingLizard
			Exit
	     EndSwitch
	WEnd
 EndFunc