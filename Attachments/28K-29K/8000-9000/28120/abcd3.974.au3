;~ XP/Vista user account backup
;~ Coded in AutoIt 3.3.0.0
;~ Coded by Ian Maxwell
;~ Core folder recursion routine provided by OverFlow (Jeff Herre) from www.driverpacks.net forums
;~ Thanks to Melba23 and PsaltyDS for consistently great help with any question
;~ Thanks to storme for pointing out some bugs and suggesting MYOB backup

#include <EditConstants.au3> ;needed for $ES_READONLY
#include <GUIConstantsEx.au3> ;needed for $GUI_GR_COLOR, $GUI_GR_MOVE, $GUI_GR_LINE, $GUI_EVENT_CLOSE, $GUI_DISABLE, $GUI_ENABLE
#include <String.au3> ;needed for _StringAddThousandsSep
#include <WindowsConstants.au3> ;needed for $DT_End_Ellipsis
#include<array.au3>
Local $rootlen ;used to determing the string length of the root directory
Local $actionitem ;used to switch between backup modes ("docs" and "other") which affects the default save location
Local $otherextension ;the current extension of file being looked for
Local $otherfound ;used as a flag to denote that an "other" data has been found such as TurboTax, MYOB etc.  0=no 1=yes
Local $otherinfo ;the message shown in $foundinfo when $otherfound=1 (and ONLY on 1, $otherfound keep counting)
Local $savelocation ;where the data is being saved
Local $defaultsave ;the folder that an "other" data type is saved to ("\Other Saved Data\" & folder for specific data type)
Local $backupsize ;bytes of data to be saved
Local $backupcount ;number of files to be saved
Local $backupname ;the name of the backup job which is used for a folder name and log name
Local $formattedfile ;$basedir&"\"&$basefile in theheart()
Local $failed ;total number of files that failed to copy
Local $peritemfailed ;only used as a flag for if a user account encountered an error copying data, the amount doesn't matter
Local $begin ;variable for TimerInit
Local $dif ;result of TimerDiff()
Local $user ;variable for the current user account being worked on
Local $morespecified ;if 0 then no other folders were specified; if other folders are specified then $morespecified=1
Local $basedir ;the root folder being looked at
Local $findit
Local $foundright
Local $foundleft
Local $officeinst
Local $sourcefilestring
Local $morefoldername
Local $helperfiles
Local $beenchanged
Local $foundmessage
Local $usermessage
Local $failedlog
Local $callback = DllCallbackRegister('__Progress', 'int', 'uint64;uint64;uint64;uint64;dword;dword;ptr;ptr;str')
Local $ptr = DllCallbackGetPtr($callback)
$swirly="-"
FileDelete(@tempdir&"\morefolderstemp.abcd") ;temp file used to store other folder names to back up
$LBS_SORT = 0x0001 ;disable data sorting in $foundinfo
$mainwindow = GUICreate("Alliance ""Backup Computer Data"" V3.974   (ABCD3)", 466, 467, 192, 24)
$sourcelabel = GUICtrlCreateLabel("Source Drive", 16, 32, 66, 17)
$targetlabel = GUICtrlCreateLabel("Target  Destination", 160, 32, 94, 17)
$backupnamelabel = GUICtrlCreateLabel("Enter a job name here", 16, 136, 108, 17)
$backupcountlabel = GUICtrlCreateLabel("Number of files", 220, 136, 80, 17)
$backupsizelabel = GUICtrlCreateLabel("Total Size", 340, 136, 80, 17)
$sourcebutton = GUICtrlCreateButton("...", 112, 56, 33, 21)
GUICtrlSetTip(-1, "Click here to select the drive to be backed up")
$targetinfo = GUICtrlCreateInput("", 160, 56, 256, 21)
$targetbutton = GUICtrlCreateButton("...", 417, 56, 33, 21)
GUICtrlSetTip(-1, "Click here to select where to save the data")
$jobnameinput = GUICtrlCreateInput("", 16, 160, 129, 21)
$gobutton = GUICtrlCreateButton("GO", 288, 16, 75, 21)
$aboutbutton = GUICtrlCreateButton("?", 1, 1, 17, 26)
$cancelbutton = GUICtrlCreateButton("CANCEL", 376, 16, 75, 21)
$sourceinfo = GUICtrlCreateEdit("", 16, 56, 96, 21,$ES_READONLY)
$statusinfo = GUICtrlCreateLabel("", 20, 99, 315, 15,$DT_END_ELLIPSIS) ;Melba23  :)
$box=GUICtrlCreateGraphic(3,96,340,20) ;              <--|
GUICtrlSetGraphic($box, $GUI_GR_COLOR, 0x7f9db9) ;       |
GUICtrlSetGraphic($box, $GUI_GR_MOVE, 13,0) ;top         |
GUICtrlSetGraphic($box, $GUI_GR_LINE, 340,0) ;top        |
GUICtrlSetGraphic($box, $GUI_GR_MOVE, 13,20) ;bottom     needed since $DT_END_ELLIPSIS on $statusinfo kills the box around it...
GUICtrlSetGraphic($box, $GUI_GR_LINE, 340,20) ;bottom    |
GUICtrlSetGraphic($box, $GUI_GR_MOVE, 13,0) ;left        |
GUICtrlSetGraphic($box, $GUI_GR_LINE, 13,20) ;left    <--|
$foundinfo = GUICtrlCreateList("", 16, 192, 433, 265,BitOR($ES_READONLY,$LBS_SORT))
$backupcountbox = GUICtrlCreateEdit("", 220, 160, 80, 21,$ES_READONLY)
$backupsizebox = GUICtrlCreateEdit("", 340, 160, 109, 21,$ES_READONLY)
$filesizebox = GUICtrlCreateEdit("", 340, 96, 109, 21,$ES_READONLY)
GUISetState(@SW_SHOW)

dim $accelkeys[1][2]=[["{ENTER}",$gobutton]] ;Enter=go
GUISetAccelerators($accelkeys)

$otherdefault=0 ;sets the default for other specified folders to "no"; if additional folders are specified this becomes 1

$hostos=@OSVersion
if $hostos="WIN_VISTA" then
	#RequireAdmin
endif
if $hostos<>"WIN_XP" and $hostos<>"WIN_VISTA" then msgbox(16,"STOP","This application is ONLY intended to run from Windows XP and Vista.  Do NOT use it on any other operating systems, as it has not been tested to work with 7 and will not be tested on anything below XP."&@CRLF&@CRLF&"CANCEL NOW!!")

FileInstall("takeown.exe",@TempDir&"\takeown.exe",1) ;used to take ownership of private folders/files from passworded user accounts
fileinstall("Import Dialup Networking Settings.txt",@TempDir&"\Import Dialup Networking Settings.txt")
fileinstall("Import Outlook Express Address Book.txt",@TempDir&"\Import Outlook Express Address Book.txt")
fileinstall("Import Outlook Express Messages.txt",@TempDir&"\Import Outlook Express Messages.txt")
fileinstall("Import Outlook Data.txt",@TempDir&"\Import Outlook Data.txt")
fileinstall("Import Outlook Settings.txt",@TempDir&"\Import Outlook Settings.txt")
;fileinstall("XP Import Windows Live Contacts.txt",@TempDir&"\Import Windows Live Contacts.txt")
;fileinstall("XP Import Windows Live Mail.txt",@TempDir&"\Import Windows Live Mail.txt")

$sourcedrive="Drive to back up"
$target="Choose a target location (type or browse right)"
GUICtrlSetData($sourceinfo, $sourcedrive)
GUICtrlSetData($targetinfo, $target)
GUICtrlSetData($statusinfo, "Information will be displayed here")

$failed=0

While 1

	$msg = GUIGetMsg()
	Select


		Case $msg = $cancelbutton or $msg = $GUI_EVENT_CLOSE
			$yesorno=msgBox(4,"Really Cancel?","Are you sure you want to cancel?")
			if $yesorno=6 then Exit


		Case $msg = $aboutbutton
			msgbox(64,"About","Version 3 has 2 important new features:"&@CRLF&@CRLF&"The ability to take ownership of locked, private user accounts (even in XP Home and NOT in Safe Mode!!) and"&@CRLF&"The ability to verify the successful copying of files"&@CRLF&@CRLF&"These new features, along with an improved UI, should make this tool more useful.  The following data will be saved automatically:"&@CRLF&@CRLF&"All user's profiles (My Documents, Desktop, IE Favorites, and other folders)"&@crlf&"Firefox bookmarks"&@CRLF&"Emails and contacts from Outlook, Outlook Express, Windows Live Maiol, and Vista Mail"&@CRLF&"TurboTax data (*.tax)"&@crlf&"TaxCut data (all versions) (*.t01-*.t08)"&@CRLF&"Quicken data (all versions) (*.qdf *.qsd *.qel *.npc *.adb *.eml *.hcx *.qph *.qtx *.qmd *.qdt *.qif *.qdb)"&@CR&"QuickBooks (all versions) (*.qbb *.qbw *.qba *.tdb)"&@crlf&"MYOB Data (*MYO, *.DAT, *.BOX) as well as the ""Forms"" and ""Letters"" folders"&@crlf&"Microsoft Office XP, 2003, and 2007 Product Keys"&@crlf&"Any other folders that you specify"&@CRLF&@CRLF&"A log file will be saved in the same location as the data being backed up, if any files fail verification you will recieve a warning at the end of the backup process, see the log for more informatrion.")


		Case $msg = $sourcebutton
			$sourcedrive = FileSelectFolder("Choose ONLY the drive that you want to back up, do NOT try to specify any folders", "")
			if stringlen($sourcedrive)>3 then ;done incase someone did not follow the above directions!  :)
				$sourcetemp=$sourcedrive
				$sourcedrive=stringleft($sourcetemp,3) ;trims it down to just the drive letter plus ":\" to avoid an error
			EndIf
			GUICtrlSetData($sourceinfo, $sourcedrive)
				
			$xporvista="unsure" ;checks the OS on the drive being backed up, even if not the current OS drive, which
			if FileExists($sourcedrive&"ntldr") then ;is why @OSVersion is not used here
				$xporvista="XP"
				$docfolder="documents and settings"
				$oslabel = GUICtrlCreateLabel("(XP detected)", 80, 32, 78, 17)
			endif
			if FileExists($sourcedrive&"bootmgr") then 
				$xporvista="Vista"
				$docfolder="users"
				$oslabel = GUICtrlCreateLabel("(Vista detected)", 80, 32, 78, 17)
			endif
			if FileExists($sourcedrive&"mach.sym") then 
				$xporvista="OS X"
				$docfolder="users"
				$oslabel = GUICtrlCreateLabel("(OS X detected)", 80, 32, 78, 17)
			endif
			if $xporvista="unsure" then msgbox(16,"STOP","This application is ONLY intended for Windows XP and Vista.  Do NOT use it on any other operating systems, as it has not been tested to work with 7 and will not be tested on anything below XP."&@CRLF&@CRLF&"CANCEL NOW!!")


; determine if there are any private folders
			Do  
				GUICtrlSetData($statusinfo, "Checking for private folders")
				$action="own"

				;xp
				if $xporvista="vista" then ExitLoop
						
				$allusers = FileFindFirstFile($sourcedrive&$docfolder&"\*.*") ;find all users					
					
				Do
				
					$dirty=0 ;if $dirty=1 then the folder is skipped in the search
					$user = FileFindNextFile($allusers) 
					If @error Then ExitLoop(2) ;no more users

					if StringLower($user)="default user" then $dirty=1
					if StringLower($user)="guest" then $dirty=1
					if StringLower($user)="localservice" then $dirty=1
					if StringLower($user)="networkservice" then $dirty=1
					if $dirty=0 then

						$thisclean=0 ;if set to 1 then it is assumed the folder is private, though it may be damaged/incomplete

						if FileExists($sourcedrive&$docfolder&"\"&$user&"\my documents\my music")=0 and $user<>"all users" then $thisclean=1
						if $thisclean=0 then GUICtrlSetData($foundinfo, "The "&$user&" account is not private")
						if $thisclean=1 then
							$basedir=$sourcedrive&$docfolder&"\"&$user
							$formattedbasedir=""""&$basedir&""""
							$swirltime=TimerInit()
							$ownmessage="Taking ownership of "&$user&"'s account, please wait"
							SplashTextOn("Working",$ownmessage,550,50)
							theheart($basedir)
							if $action="own" then SplashOff()
							GUICtrlSetData($foundinfo, "The "&$user&" account's ownership has been transferred")
						EndIf
;~ 						$foundmessage&=$user&"'s account copied successfully"&chr(1)
						$usermessage&=$user&"'s account has been copied"&chr(1)
					EndIf
				until 1=2
			until 1=2

			Do
				if $xporvista="xp" then ExitLoop ;vista
						
				$allusers = FileFindFirstFile($sourcedrive&$docfolder&"\*.*")
					
				Do
				
					$dirty=0		
					$user = FileFindNextFile($allusers) 
					If @error Then ExitLoop(2)
													
					if StringLower($user)="default" then $dirty=1
					if StringLower($user)="default user" then $dirty=1
					if StringLower($user)="desktop.ini" then $dirty=1
					if StringLower($user)="public" then $dirty=1
					if $dirty=0 then

						$thisclean=0

						if FileExists($sourcedrive&$docfolder&"\"&$user&"\Documents")=0 and $user<>"public" then $thisclean=1
						if $thisclean=0 then GUICtrlSetData($foundinfo, "The "&$user&" account is not private")
						if $thisclean=1 then
							$basedir=$sourcedrive&$docfolder&"\"&$user
							$formattedbasedir=""""&$basedir&""""
							$swirltime=TimerInit()
							$ownmessage="Taking ownership of "&$user&"'s account, please wait"
							SplashTextOn("Working",$ownmessage,550,50)
							theheart($basedir)
							if $action="own" then SplashOff()
							GUICtrlSetData($foundinfo, "The "&$user&" account's ownership has been transferred")
						EndIf
						$usermessage&=$user&"'s account has been copied"&chr(1)
					EndIf
				until 1=2
			until 1=2

;office
;						if StringLower($sourcedrive)="c:\" Then
;							Local $product = ""
;							Dim $Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
;							Dim $key4RegisteredOwner = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
;							$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
;							$colSettings = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
;							For $objOperatingSystem In $colSettings
;							Next
;							getOfficeKey()
;							if $officeinst=1 then GUICtrlSetData($foundinfo, "Office "&$product&" Product Key was found")
;						EndIf
;end office	

			GUICtrlSetData($statusinfo, "Beginning file enumeration")
			$action="tally" ;find the files and add the number and size
			seeker()
			GUICtrlSetData($statusinfo, "Please select the target location")
			GUICtrlSetData($foundinfo, " ")
			GUICtrlSetData($foundinfo, "FILE ENUMERATION FINISHED")
			GUICtrlSetData($foundinfo, "  ")
			$actionitem="docs"

			Do
				$savemore=msgbox(4,"Specify Folders","Would you like to specify additional folders to back up?")
				if $savemore=6 Then ;yes
					$morefolders=FileSelectFolder("Choose one folder at a time!", $sourcedrive)
					if $morefolders<>"" Then ;make sure something was chosen
						if $morespecified=0 then $foundmessage&=@crlf&Chr(1)
						$morespecified=1 ;if 0 then additional folders are not backed up later
						$basedir=$morefolders
						$otherdefault=1
						$defaultsave="Other Saved Data"
						theheart($basedir)
						$defaultsave=""
						$otherdefault=0
						GUICtrlSetData($foundinfo, "Added """&$morefolders&""" to backup job")
						$foundmessage&=$morefolders&" has been copied"&chr(1)
					EndIf
				EndIf
			until $savemore=7 ;keep going until no more additional folders are specified
			sleep(150)
			send("{TAB}") ;sets focus to $targetinfo

;end sourcebutton


		Case $msg = $targetbutton
			$target = FileSelectFolder("Choose the location you want to back up to", "")
			GUICtrlSetData($targetinfo, $target)


		Case $msg = $gobutton
		
			$readytogo = "no"
			$target=GUICtrlRead($targetinfo)

			$backupname=GUICtrlRead($jobnameinput)
			if $sourcedrive="" then
				$sourcedrive="Drive to back up"
				GUICtrlSetData($sourceinfo, $sourcedrive)
			EndIf
			if $target="" then
				$target="Choose a target location (type or browse right)"
				GUICtrlSetData($targetinfo, $target)
			EndIf

			if $sourcedrive="Drive to back up" then msgbox(48,"Warning","You have not yet chosen a drive to back up!")
			if $sourcedrive="" then msgbox(48,"Warning","You have not yet chosen a drive to back up!")
			if $target="Choose a target location (type or browse right)" then msgbox(48,"Warning","You have not yet chosen a target location!")
			if $target="" then msgbox(48,"Warning","You have not yet chosen a target location!")
			if $backupname="" then msgbox(48,"Warning","You have not yet chosen a job name!")
			if $sourcedrive<>"Drive to back up" and $sourcedrive<>"" and $target<>"Choose a target location (type or browse right)" and $target<>"" and $backupname<>"" then $readytogo="yes"
			if $readytogo="yes" Then
			
				DirCreate($target&"\"&$backupname)
				do
					if FileExists($target&"\"&$backupname) then 
						GUICtrlSetData($targetinfo, $target)
						$logfile=$target&"\"&$backupname&"\"&$backupname&".log"
						fileopen($logfile,1)
						exitloop
					EndIf
					msgbox(48,"Can Not Create Destination Folder","There has been a problem creating the destination folder.  Please make sure you can write to the destination and that it is online.")
					exit
				until 1=2

				$yesornogo=msgBox(4,"Run Backup?", "Are you sure you want to proceed with backup job """&$backupname&"""?")
				if $yesornogo=7 then 
					msgbox(48,"Cancelled",$backupname&" has been cencelled")
					exit
				EndIf

				ControlFocus("","",$gobutton)
				GUICtrlDelete($cancelbutton)
				GUICtrlSetState($gobutton, $GUI_DISABLE)
				$progressbar=GUICtrlCreateProgress(16,120,433,12)
				GUICtrlSetState($progressbar,$gui_enable)
				$stopbutton = GUICtrlCreateButton("STOP", 376, 16, 75, 21)

				$ampm="AM"
				$hour=@HOUR
				if $hour>12 then 
					$hour=$hour-12
					$ampm="PM"
				EndIf
				filewriteline($logfile,"Backup job """&$backupname&""" started "&$hour&":"&@MIN&":"&@SEC&$ampm&" on "&@MON&"/"&@MDAY&"/"&@YEAR&@CRLF&@CRLF)
				filewriteline($logfile,"Operating System backed up: "&$xporvista)
				$begin = TimerInit()
				filewriteline($logfile,"Total files to back up: "&_StringAddThousandsSep($backupcount))
				filewriteline($logfile,"Total size to back up: "&_StringAddThousandsSep($backupsize)&@CRLF)

				$thelist=StringSplit($sourcefilestring,chr(1))
				for $current=1 to $thelist[0]-1 step 3
					$msg=GUIGetMsg()
					if $msg=$stopbutton Then
						$yesorno=msgBox(4,"Really Cancel?","Are you sure you want to cancel?")
						if $yesorno=6 then Exit
					EndIf
					GUICtrlSetData($statusinfo, $thelist[$current])
					GUICtrlSetData($filesizebox, _StringAddThousandsSep($thelist[$current+1]))
					$copied = _CopyWithProgress($thelist[$current], $target&"\"&$backupname&StringTrimLeft($thelist[$current+2],1))
					if $copied=0 then 
						$failed+=1
						$failedlog&=$thelist[$current]&chr(1)
					EndIf
					$backupsize=$backupsize-$thelist[$current+1]
					GUICtrlSetData($backupsizebox, _StringAddThousandsSep($backupsize))
					$backupcount=$backupcount-1
					GUICtrlSetData($backupcountbox, _StringAddThousandsSep($backupcount))
				Next

				$dif = TimerDiff($begin)

				if $helperfiles<>"" Then
					if $helperfiles<>chr(1) Then
						$placehelpers=StringSplit(StringTrimRight($helperfiles,1),chr(1))
						for $count=1 to $placehelpers[0] step 2
							filecopy($placehelpers[$count],$target&"\"&$backupname&"\"&$placehelpers[$count+1])
						Next
					EndIf
				EndIf
				
				if $usermessage<>"" Then
					filewriteline($logfile,@CRLF)
					$writelog=StringSplit($usermessage,chr(1))
					for $count=1 to $writelog[0]-1
						filewriteline($logfile,$writelog[$count])
					Next
				EndIf
				if $foundmessage<>"" Then
					filewriteline($logfile,@CRLF)
					$writelog=StringSplit($foundmessage,chr(1))
					for $count=1 to $writelog[0]-1
						filewriteline($logfile,$writelog[$count])
					Next
				EndIf
				if $failedlog<>"" Then
					filewriteline($logfile,@CRLF)
					$writelog=StringSplit($failedlog,chr(1))
					for $count=1 to $writelog[0]-1
						filewriteline($logfile,"***   "&$writelog[$count]&" failed")
					Next
				EndIf

				if $failed=0 then GUICtrlSetData($statusinfo, @CRLF&@CRLF&@CRLF&$backupname&" is complete with no errors")
				if $failed>0 then GUICtrlSetData($statusinfo, @CRLF&@CRLF&@CRLF&$backupname&" is complete WITH errors")
				$minutes=$dif/60000
				filewriteline($logfile,@CRLF&"Total time of completion: "&Round($minutes,2)&" minutes")
				filewriteline($logfile,@CRLF&"Total errors: "&$failed)
				GUICtrlSetData($filesizebox, " ")
				GUICtrlSetData($statusinfo, " ")
				GUICtrlDelete($progressbar)
				if $failed=0 then msgbox(0,"Finished With No Errors","Finished with backup job """&$backupname&"""")
				if $failed>0 then msgbox(0,"Finished WITH Errors","Finished with backup job """&$backupname&""""&@CRLF&@CRLF&"Please read the log file for information on the errors that were encountered")

				FileDelete(@TempDir&"\takeown.exe")
				FileDelete(@TempDir&"\Import Dialup Networking Settings.txt")
				FileDelete(@TempDir&"\Import Outlook Express Address Book.txt")
				FileDelete(@TempDir&"\Import Outlook Express Messages.txt")
				FileDelete(@TempDir&"\Import Outlook Data.txt")
				FileDelete(@TempDir&"\Import Outlook Settings.txt")
				FileDelete(@TempDir&"\Import Windows Live Contacts.txt")
				FileDelete(@TempDir&"\Import Windows Live Mail.txt")

				Exit
;~ 					
;~ ;office
;~ 				if StringLower($sourcedrive)="c:\" Then
;~ 					Local $product = ""
;~ 					Dim $Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
;~ 					Dim $key4RegisteredOwner = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
;~ 					$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
;~ 					$colSettings = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
;~ 					For $objOperatingSystem In $colSettings
;~ 					Next
;~ 					getOfficeKey() ;gets called twice ( next line too ) because otherwise the version number ( $product ) is not known...
;~ 					if $officeinst=1 then filewriteline($logfile,@crlf&"Office "&$product&" Product Key: "&getOfficeKey()&@crlf)
;~ 				EndIf
;~ ;end office	
			EndIf

	EndSelect
WEnd


func folderfinder()
$len=stringlen($formattedfile)
$foundright=0
$foundleft=0
$findit=$len
Do
	$findit-=1
	if stringmid($formattedfile,$findit,1)="\" then 
		$foundright=$findit
		ExitLoop
	EndIf
until $findit=1
$findit=$foundright-1
$foundleft=stringlen($basedir)+1
EndFunc


func otherfolderfinder()
$len=stringlen($formattedfile)
$foundright=0
$foundleft=0
$findit=0
Do
	$findit+=1
	if stringmid($formattedfile,$findit,1)="\" then 
		$foundright=$findit-1
		ExitLoop
	EndIf
until $findit=1
Do
	$findit+=1
	if stringmid($formattedfile,$findit,1)="\" then 
		$foundleft=$findit
		ExitLoop
	EndIf
until $findit=1
EndFunc



func seeker()
	
					$actionitem="docs"
					do    ;xp
						if $xporvista="vista" then ExitLoop
			
						$allusers = FileFindFirstFile($sourcedrive&$docfolder&"\*.*")
		
							Do
					
								$dirty=0		
								$user = FileFindNextFile($allusers) 
								If @error Then ExitLoop
										
								$peritemfailed=0
								if StringLower($user)="default user" then $dirty=1
								if StringLower($user)="guest" then $dirty=1
								if StringLower($user)="localservice" then $dirty=1
								if StringLower($user)="networkservice" then $dirty=1
								if $dirty=0 then
									
									$root=$sourcedrive&$docfolder&"\"&$user&"\"
									$rootlen=stringlen($root)+1

									$defaultsave=""
									$basedir=$root&"My Documents"
									theheart($basedir)
									$basedir=$root&"Desktop"
									theheart($basedir)
									$basedir=$root&"Favorites"
									theheart($basedir)
									$basedir=$root&"Shared"
									theheart($basedir)
									$basedir=$root&"Local Settings\Application Data\Identities"
									if DirGetSize($basedir)>303396 Then
										$defaultsave="Users\"&$user&"\Outlook Express"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Outlook Express Messages.txt"&Chr(1)&$defaultsave&"\Import Outlook Express Messages.txt"&chr(1)
									EndIf
									$basedir=$root&"Application Data\Microsoft\Address Book"
									if dirgetsize($basedir)>353188 then
										$defaultsave="Users\"&$user&"\Address Book"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Outlook Express Address Book.txt"&Chr(1)&$defaultsave&"\Import Outlook Express Address Book.txt"&Chr(1)
									EndIf
									$basedir=$root&"Local Settings\Application Data\Microsoft\Windows Live Mail"
									if dirgetsize($basedir)>31859935 then
										$defaultsave="Users\"&$user&"\Windows Live Mail"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Windows Live Mail.txt"&Chr(1)&$defaultsave&"\Import Windows Live Mail.txt"&Chr(1)
									EndIf
									$basedir=$root&"Local Settings\Application Data\Microsoft\Windows Live Contacts"
									if dirgetsize($basedir)>14966868 then
										$defaultsave="Users\"&$user&"\Windows Live Contacts"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Windows Live Contacts.txt"&Chr(1)&$defaultsave&"\Import Windows Live Contacts.txt"&Chr(1)
									EndIf
									$basedir=$root&"Local Settings\Application Data\Microsoft\Outlook"
									if FileExists($basedir) Then
										$defaultsave="Users\"&$user&"\Outlook Settings"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Outlook Settings.txt"&Chr(1)&$defaultsave&"\Import Outlook Settings.txt"&Chr(1)
									EndIf
									$basedir=$root&"Application Data\Microsoft\Outlook"
									if FileExists($basedir) Then
										$defaultsave="Users\"&$user&"\Outlook"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Outlook Data.txt"&Chr(1)&$defaultsave&"\Import Outlook Data.txt"&Chr(1)
									EndIf
									
									$otherfolders = FileFindFirstFile($sourcedrive&$docfolder&"\"&$user&"\*.*")
									Do
										$filthy=0		
										$foldersfound = FileFindNextFile($otherfolders) 
										If @error Then ExitLoop
										
										if StringLower($foldersfound)=".thumbnails" then $filthy=1
										if stringinstr(StringLower($foldersfound),".gimp-")<>0 then $filthy=1
										if stringinstr(StringLower($foldersfound),".gegl-")<>0 then $filthy=1
										if StringLower($foldersfound)="application data" then $filthy=1
										if StringLower($foldersfound)="cookies" then $filthy=1
										if StringLower($foldersfound)="desktop" then $filthy=1
										if StringLower($foldersfound)="favorites" then $filthy=1
										if StringLower($foldersfound)="IECompatCache" then $filthy=1
										if StringLower($foldersfound)="IETldCache" then $filthy=1
										if StringLower($foldersfound)="incomplete" then $filthy=1
										if StringLower($foldersfound)="local settings" then $filthy=1
										if StringLower($foldersfound)="my documents" then $filthy=1
										if StringLower($foldersfound)="nethood" then $filthy=1
										if StringLower($foldersfound)="recent" then $filthy=1
										if StringLower($foldersfound)="printhood" then $filthy=1
										if StringLower($foldersfound)="privacie" then $filthy=1
										if StringLower($foldersfound)="sendto" then $filthy=1
										if StringLower($foldersfound)="shared" then $filthy=1
										if StringLower($foldersfound)="start menu" then $filthy=1
										if StringLower($foldersfound)="templates" then $filthy=1
										if StringLower($foldersfound)="userdata" then $filthy=1
										if StringInStr(StringLower($foldersfound),"openoffice")<>0 then $filthy=1
										if $filthy=0 then 
											$basedir=$root&$foldersfound
											$defaultsave=""
											theheart($basedir)
										EndIf	
									until 1=2
								EndIf
							if $action="backup" and $dirty=0 and $peritemfailed=0 then filewriteline($logfile,$user&"'s account copied successfully")	
							if $action="backup" and $dirty=0 and $peritemfailed<>0 then filewriteline($logfile,$user&"'s account copied with errors")	
							until 1=2
						ExitLoop
					until 1=2  ;end of docfolder search
				
; xp done


; reserced for vista


					do    ;vista
						if $xporvista="xp" then ExitLoop
			
						$allusers = FileFindFirstFile($sourcedrive&$docfolder&"\*.*")
		
							Do
					
								$dirty=0		
								$user = FileFindNextFile($allusers) 
								If @error Then ExitLoop
										
								$peritemfailed=0
								if StringLower($user)="default" then $dirty=1
								if StringLower($user)="default user" then $dirty=1
								if StringLower($user)="desktop.ini" then $dirty=1
								if $dirty=0 then
									
									$root=$sourcedrive&$docfolder&"\"&$user&"\"
									$rootlen=stringlen($root)+1

									$defaultsave=""
									$basedir=$root&"Documents"
									theheart($basedir)
									$basedir=$root&"Desktop"
									theheart($basedir)
									$basedir=$root&"Contacts"
									theheart($basedir)
									$basedir=$root&"Downloads"
									theheart($basedir)
									$basedir=$root&"Favorites"
									theheart($basedir)
									$basedir=$root&"Links"
									theheart($basedir)
									$basedir=$root&"Music"
									theheart($basedir)
									$basedir=$root&"Pictures"
									theheart($basedir)
									$basedir=$root&"Saved Music"
									theheart($basedir)
									$basedir=$root&"Saved Games"
									theheart($basedir)
									$basedir=$root&"Videos"
									theheart($basedir)
									$basedir=$root&"Shared"
									theheart($basedir)
									$basedir=$root&"AppData\Local\Microsoft\Windows Live Mail"
									if FileExists($basedir) Then
										$defaultsave="Users\"&$user&"\Windows Live Mail"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Outlook Express Address Book.txt"&Chr(1)&$defaultsave&"\Import Outlook Express Address Book.txt"&Chr(1)
 									EndIf

									$basedir=$root&"AppData\Local\Microsoft\Windows Mail"
									if FileExists($basedir) Then
										$defaultsave="Windows Mail"
										theheart($basedir)
										$helperfiles&=@TempDir&"\Import Windows Mail.txt"&Chr(1)&$user&"\Windows Mail\Import Windows Mail.txt"&chr(1)
									EndIf

									$otherfolders = FileFindFirstFile($sourcedrive&$docfolder&"\"&$user&"\*.*")
									Do
										$filthy=0		
										$foldersfound = FileFindNextFile($otherfolders) 
										If @error Then ExitLoop
										if StringLower($foldersfound)="appdata" then $filthy=1
										if StringLower($foldersfound)="all users" then $filthy=1
										if StringLower($foldersfound)="application data" then $filthy=1
										if StringLower($foldersfound)="contacts" then $filthy=1
										if StringLower($foldersfound)="cookies" then $filthy=1
										if StringLower($foldersfound)="desktop" then $filthy=1
										if StringLower($foldersfound)="documents" then $filthy=1
										if StringLower($foldersfound)="downloads" then $filthy=1
										if StringLower($foldersfound)="favorites" then $filthy=1
										if StringLower($foldersfound)="incomplete" then $filthy=1
										if StringLower($foldersfound)="links" then $filthy=1
										if StringLower($foldersfound)="local settings" then $filthy=1
										if StringLower($foldersfound)="music" then $filthy=1
										if StringLower($foldersfound)="my documents" then $filthy=1
										if StringLower($foldersfound)="nethood" then $filthy=1
										if StringLower($foldersfound)="pictures" then $filthy=1
										if StringLower($foldersfound)="printhood" then $filthy=1
										if StringLower($foldersfound)="public" then $filthy=1
										if StringLower($foldersfound)="recent" then $filthy=1
										if StringLower($foldersfound)="saved games" then $filthy=1
										if StringLower($foldersfound)="searches" then $filthy=1	
										if StringLower($foldersfound)="sendto" then $filthy=1
										if StringLower($foldersfound)="shared" then $filthy=1
										if StringLower($foldersfound)="start menu" then $filthy=1
										if StringLower($foldersfound)="templates" then $filthy=1
										if StringLower($foldersfound)="videos" then $filthy=1
										if StringLower($foldersfound)="OpenOffice.org 2.1 Installation Files" then $filthy=1
										if $filthy=0 then 
											$basedir=$root&$foldersfound
											$defaultsave=""
											theheart($basedir)
										EndIf	
									until 1=2
								EndIf
							if $action="backup" and $dirty=0 then filewriteline($logfile,$user&"'s account copied successfully")	
							if $action="backup" and $dirty=0 and $peritemfailed<>0 then filewriteline($logfile,$user&"'s account copied with errors")
						until 1=2
						ExitLoop
					until 1=2  ;end of docfolder search



;reserved for vista End




; find quicken quickbooks etc here


					$actionitem="other"
;					$progdir="Program Files"

						$otherfound=0
						if FileExists($sourcedrive&"Documents and Settings\All Users\Application Data\Microsoft\Network\Connections\Pbk") then
							if dirGetSize($sourcedrive&"Documents and Settings\All Users\Application Data\Microsoft\Network\Connections\Pbk")>1000 then
								$basedir=$sourcedrive&"Documents and Settings\All Users\Application Data\Microsoft\Network\Connections\Pbk"
								$otherextension=".pbk"
								$savelocation=$target&"\"&$backupname&"Other Saved Data\Dialup Networking\"
								$otherinfo="Dialup Networking settings were found"
								theheart($basedir)
								$helperfiles&=@TempDir&"\Import Dialup Networking Settings.txt"&Chr(1)&"Other Saved Data\Dialup Networking\Import Dialup Networking Settings.txt"&Chr(1)
							EndIf
						endif
						if $otherfound>0 then $foundmessage&="Dialup Networking Settings have been copied"&Chr(1)

						$otherfound=0
						$myob=FileFindFirstFile($sourcedrive&"myob*")
						Do
							$myobfound=FileFindNextFile($myob)
							if @error then ExitLoop
							if FileExists($sourcedrive&$myobfound) then
								$basedir=$sourcedrive&$myobfound
								$extensions=StringSplit(".box,.dat,.myo",",")
								for $many=1 to $extensions[0] ;"many" extensions to look for...
									$otherextension=$extensions[$many]
									$savelocation=$target&"\"&$backupname&"Other Saved Data\"&$myobfound&"\"
									$otherinfo="MYOB data was found in "&$basedir
									theheart($basedir)
								Next
							endif
							$actionitem="docs" ;switch to docs for recursive searching of subfolders
							$basedir=$sourcedrive&$myobfound&"\forms"
							$defaultsave="Other Saved Data\"&$myobfound&"\forms"
							theheart($basedir)
							$basedir=$sourcedrive&$myobfound&"\letters"
							$defaultsave="Other Saved Data\"&$myobfound&"\letters"
							theheart($basedir)
							$actionitem="other" ;switch back to other to disable recursion
						Until 1=2
						if $otherfound>0 then $foundmessage&="MYOB data has been copied from "&$basedir&Chr(1)

						$otherfound=0
						$basedir=$sourcedrive&"quickenw"
						if FileExists($basedir) then
							$extensions=StringSplit(".qdf,.qsd,.qel,.npc,.adb,.eml,.hcx,.qph,.qtx,.qmd,.qdt,.qif,.qdb",",")
							for $many=1 to $extensions[0] ;"many" extensions to look for...
								$otherextension=$extensions[$many]
								$savelocation=$target&"\"&$backupname&"Other Saved Data\Root Quicken\"
								$otherinfo="Quicken data was found in "&$basedir
								theheart($basedir)
							Next
						endif
						if $otherfound>0 then $foundmessage&="Quicken data has been copied from "&$basedir&Chr(1)

					$progdir="Program Files"
					for $32or64=1 to 2

						$otherfound=0
						$basedir=$sourcedrive&$progdir&"\tax01"
						if FileExists($basedir) then
							$otherextension=".tax"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TurboTax01\"
							$otherinfo="TurboTax data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TurboTax data has been copied from "&$basedir&Chr(1)

						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\turbotax") then
							$basedir=$sourcedrive&$progdir&"\turbotax"
							$otherextension=".tax"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TurboTax\"
							$otherinfo="TurboTax data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TurboTax data has been copied from "&$basedir&Chr(1)

						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut01") then
							$basedir=$sourcedrive&$progdir&"\taxcut01"
							$otherextension=".t01"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2001 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2001 data has been copied from "&$basedir&Chr(1)

						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut02") then
							$basedir=$sourcedrive&$progdir&"\taxcut02"
							$otherextension=".t02"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2002 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2002 data has been copied from "&$basedir&Chr(1)
						
						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut03") then
							$basedir=$sourcedrive&$progdir&"\taxcut03"
							$otherextension=".t03"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2003 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2003 data has been copied from "&$basedir&Chr(1)
						
						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut04") then
							$basedir=$sourcedrive&$progdir&"\taxcut04"
							$otherextension=".t04"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2004 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2004 data has been copied from "&$basedir&Chr(1)
						
						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut05") then
							$basedir=$sourcedrive&$progdir&"\taxcut05"
							$otherextension=".t05"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2005 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2005 data has been copied from "&$basedir&Chr(1)

						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut06") then
							$basedir=$sourcedrive&$progdir&"\taxcut06"
							$otherextension=".t06"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2006 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2006 data has been copied from "&$basedir&Chr(1)
						
						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut07") then
							$basedir=$sourcedrive&$progdir&"\taxcut07"
							$otherextension=".t07"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2007 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2007 data has been copied from "&$basedir&Chr(1)
						
						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\taxcut08") then
							$basedir=$sourcedrive&$progdir&"\taxcut08"
							$otherextension=".t08"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\TaxCut\"
							$otherinfo="TaxCut 2008 data was found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="TaxCut 2008 data has been copied from "&$basedir&Chr(1)

						for $toomany=1 to 3
							$qfolder=StringSplit("\Quicken,\Quickenw,\Intuit\Quicken",",")
							for $toomany=1 to $qfolder[0]
								$otherfound=0
								if FileExists($sourcedrive&$progdir&$qfolder[$toomany]) then
									$basedir=$sourcedrive&$progdir&$qfolder[$toomany]
									$extensions=StringSplit(".qdf,.qsd,.qel,.npc,.adb,.eml,.hcx,.qph,.qtx,.qmd,.qdt,.qif,.qdb",",")
									for $many=1 to $extensions[0]
										$otherextension=$extensions[$many]
										$savelocation=$target&"\"&$backupname&"Other Saved Data"&$qfolder[$toomany]&"\"
										$otherinfo=StringTrimLeft($qfolder[$toomany],1)&" data was found  in "&$basedir
										theheart($basedir)
									Next
								endif
								if $otherfound>0 then $foundmessage&=StringTrimLeft($qfolder[$toomany],1)&" data has been copied from "&$basedir&Chr(1)
							Next
						Next

						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\intuit") then
							$basedir=$sourcedrive&$progdir&"\intuit"
							$extensions=StringSplit(".qbb,.qbw,.qba,tdb",",")
							for $many=1 to $extensions[0]
								$otherextension=$extensions[$many]
								$savelocation=$target&"\"&$backupname&"Other Saved Data\Intuit\"
								$otherinfo="Intuit data was found in "&$basedir
								theheart($basedir)
							Next
						endif
						if $otherfound>0 then $foundmessage&="Intuit data has been copied from "&$basedir&Chr(1)

						$otherfound=0
						if FileExists($sourcedrive&$progdir&"\Mozilla Firefox\defaults\profile") then
							$basedir=$sourcedrive&$progdir&"\Mozilla Firefox\defaults\profile"
							$otherextension="html"
							$savelocation=$target&"\"&$backupname&"Other Saved Data\Firefox Bookmarks\"
							$otherinfo="Firefox bookmarks were found in "&$basedir
							theheart($basedir)
						endif
						if $otherfound>0 then $foundmessage&="FireFox bookmarks have been copied"&Chr(1)
						
					$progdir="Program Files(x86)"
					next





; get peachtree backup info




; find quicken quickbooks etc here end



	
EndFunc








func theheart($basedir)
	
	$target=chr(2)

	if $action="own" then RunWait(@tempdir&"\takeown.exe "&$basedir,"", @SW_HIDE)

	$basesearch = fileFindFirstFile($basedir & "\*.*")
	if $basesearch==-1 then return 0 ; specified folder is empty!
 	while @error<>1
		$basefile = fileFindNextFile($basesearch)
		; skip these
		if $basefile=="." or $basefile==".." or $basefile=="" then
			continueLoop
		endIf
		; if it's a dir then call this function again (nesting the function is clever ;)
		$formattedfile=$basedir&"\"&$basefile
		if stringInStr(fileGetAttrib($formattedfile), "D") > 0 then
			
			if $action="own" then 
				RunWait(@tempdir&"\takeown.exe "&$basedir,"", @SW_HIDE)
				if TimerDiff($swirltime)>250 Then
					$swirltime=TimerInit()
					$beenchanged=0
					if $swirly="/" and $beenchanged=0 then 
						$swirly="-"
						$beenchanged=1
					endif
					if $swirly="|" and $beenchanged=0 then
						$swirly="/"
						$beenchanged=1
					EndIf
					if $swirly="\" and $beenchanged=0 then
						$swirly="|"
						$beenchanged=1
					EndIf
					if $swirly="-" and $beenchanged=0 then
						$swirly="\"
						$beenchanged=1
					EndIf
				EndIf
				$ownmessage="Taking ownership of "&$user&"'s account, please wait    "&$swirly
				ControlSetText("Working","","Static1",$ownmessage)
			EndIf
			theheart($formattedfile)
			
		else
			
			; Files we need to deal with

			if $action="own" Then
				runwait(@tempdir&"\takeown.exe "&$formattedfile,"", @SW_HIDE)
				if TimerDiff($swirltime)>250 Then
					$swirltime=TimerInit()
					$beenchanged=0
					if $swirly="/" and $beenchanged=0 then 
						$swirly="-"
						$beenchanged=1
					endif
					if $swirly="|" and $beenchanged=0 then
						$swirly="/"
						$beenchanged=1
					EndIf
					if $swirly="\" and $beenchanged=0 then
						$swirly="|"
						$beenchanged=1
					EndIf
					if $swirly="-" and $beenchanged=0 then
						$swirly="\"
						$beenchanged=1
					EndIf
				EndIf
				$ownmessage="Taking ownership of "&$user&"'s account, please wait    "&$swirly
				ControlSetText("Working","","Static1",$ownmessage)
			EndIf


			if $action="tally" or $action="backup" Then

				$filename=StringTrimLeft($formattedfile,$rootlen-1)
				$namesplit=stringsplit($formattedfile,"\")
				$last=$namesplit[0]
				$thefilename=$namesplit[$last]
				$fname2=$target&$backupname&"\Users\"&$user&"\"&$filename
				Do
					if $actionitem="other" and $otherdefault=0 and StringRight($formattedfile,4)<>$otherextension Then ExitLoop

					if $action="tally" then 
						$backupsize=$backupsize+FileGetSize($formattedfile)
						GUICtrlSetData($backupsizebox, _StringAddThousandsSep($backupsize))
						$backupcount=$backupcount+1
						GUICtrlSetData($backupcountbox, _StringAddThousandsSep($backupcount))
						$sourcefilestring&=$formattedfile&chr(1)&FileGetSize($formattedfile)&chr(1)
						if $actionitem="other" Then
							$otherfound=$otherfound+1
							if $otherfound=1 then GUICtrlSetData($foundinfo, $otherinfo)
						EndIf
					EndIf

;
						if $actionitem="other" Then	$sourcefilestring&=$savelocation&$thefilename&chr(1)
;							
						if $actionitem="docs" Then
							if $defaultsave="" then $sourcefilestring&=$fname2&chr(1)
							if $defaultsave<>"" then
								if $otherdefault=0 Then 
									folderfinder()
									$sourcefilestring=$sourcefilestring&$target&$backupname&"\"&$defaultsave&stringmid($formattedfile,$foundleft,$foundright-$foundleft)&"\"&$thefilename&chr(1)
								EndIf
								if $otherdefault=1 Then
									otherfolderfinder()
									$sourcefilestring=$sourcefilestring&$target&$backupname&"\"&$defaultsave&stringmid($formattedfile,$foundleft,$foundright-$foundleft)&chr(1)
								EndIf
							EndIf
						EndIf
				until 1=1
			EndIf
		endIf
	wEnd
	fileClose($basesearch)
	return 1
endFunc



Func _CopyWithProgress($inSource, $inDest)
    
; Function to copy a file showing a realtime progress bar
;
; By Paul Niven (NiVZ)
;
; 05/11/2008
;
; Parameters:
;
; $inSource  -   Full path to source file
; $inDest   -    Full path to destination file (structure will be created if it does not exist
;
; Returns 0 if copy is successful and 1 if it fails
;
;
; Updates:
;
; 06/11/2008 - Now shows SOURCE and DEST on seperate lines while copying
;           - Now uses Kernal32 and DllCallBackRegister to provide faster copying
;             Kernal32 and DllCallBackRegister taken from _MultiFileCopy.au3
;             See: http://www.autoit.de/index.php?page=Thread&postID=58875
      
	$DestDir = StringLeft($inDest, StringInStr($inDest, "\", "", -1))

    If Not FileExists($DestDir) Then DirCreate($DestDir)
    
    $ret = DllCall('kernel32.dll', 'int', 'CopyFileExA', 'str', $inSource, 'str', $inDest, 'ptr', $ptr, 'str', '', 'int', 0, 'int', 0)

    If $ret[0] <> 0 Then
    ; Success
        Return 1
    Else
    ; Fail
        Return 0
    EndIf
    
EndFunc


Func __Progress($FileSize, $BytesTransferred, $StreamSize, $StreamBytesTransferred, $dwStreamNumber, $dwCallbackReason, $hSourceFile, $hDestinationFile, $lpData)
    
    GUICtrlSetData($progressbar,Round($BytesTransferred / $FileSize * 100, 0))
    
EndFunc

func getOfficeKey()
    Local $List[1]
    Local $i = 1
    $var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\11.0\Common\InstallRoot", "Path")
    If $var <> "" Then
        $product = "2003"
        Dim $officeKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\11.0\Registration"
    Else
        $var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\10.0\Common\InstallRoot", "Path")
        If $var <> "" Then
            $product = "XP"
            Dim $officeKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\10.0\Registration"
        Else
            $var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\12.0\Common\InstallRoot", "Path")
            If $var <> "" Then
                $product = "2007"
                Dim $officeKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\12.0\Registration"
            EndIf
        EndIf
    EndIf
    Dim $var = RegEnumKey($officeKey, $i)
    If @error <> 0 Then
		$officeinst=0
;~         GUICtrlSetData($status_L, "Info: Unable to find REG_BINARY 'DigitalProductID', maybe no Office installed!")
        Return "No Office XP or 2003 found"
    Else
        $List[$i - 1] = RegRead($officeKey & "\" & $var, "DigitalProductID")
        If $List[$i - 1] = "" Then
			$officeinst=0
;~             GUICtrlSetData($status_L, "Info: Unable to find REG_BINARY 'DigitalProductID', maybe no Office installed!")
        Else
			$officeinst=1
            $key = $List[$i - 1]
            Return DecodeProductKey($key)
        EndIf
    EndIf
EndFunc  ;==>getOfficeKey



Func DecodeProductKey($BinaryDPID)
    Local $bKey[15]
    Local $sKey[29]
    Local $Digits[24]
    Local $Value = 0
    Local $hi = 0
    Local $n = 0
    Local $i = 0
    Local $dlen = 29
    Local $slen = 15
    Local $Result

    $Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
    $BinaryDPID = StringMid($BinaryDPID, 107, 30)
    For $i = 1 To 29 Step 2
        $bKey[Int($i / 2) ] = Dec(StringMid($BinaryDPID, $i, 2))
    Next
    For $i = $dlen - 1 To 0 Step - 1
        If Mod(($i + 1), 6) = 0 Then
            $sKey[$i] = "-"
        Else
            $hi = 0
            For $n = $slen - 1 To 0 Step - 1
                $Value = BitOR(BitShift($hi, -8), $bKey[$n])
                $bKey[$n] = Int($Value / 24)
                $hi = Mod($Value, 24)
            Next
            $sKey[$i] = $Digits[$hi + 1]
        EndIf
    Next
    For $i = 0 To 28
        $Result = $Result & $sKey[$i]
    Next
    Return $Result
EndFunc   ;==>DecodeProductKey
