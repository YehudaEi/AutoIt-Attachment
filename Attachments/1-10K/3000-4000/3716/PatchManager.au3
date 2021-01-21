#comments-start
File:		OEMPatch.au3

DESCRIPTION:
	To install software patches.

COMMENTS:
	Original source by S.A. Pechler

LIBRARY OF SYNTAX:
Script Functions:
	Checks for missing patches and:
		- returns only the number of patches missing
		- or asks the user if he wants to install them

	Can be used to deploy:
		-Microsoft Windows hotfixes
		-Microsoft Office hotfixes
		-Or any other program you choose.

Features:
	Can be used in a login script or 'stand alone'
	Can be used on a CD/DVD-ROM
	Can be run from Windows 95 onto Windows 2003 (not WindowsCE  :-) )
	You can easily add support for different operating system languages.

Requirements:
	A CSV-File containing the patch descriptions, their locations
	and their installation criteria.

	See patchlist.csv/patchlist.xls for an example.

	A directory-tree that contains the executables you use in the CSV-file
	An example: 
	D:\PATCHES\WIN95
	D:\PATCHES\WIN98
	D:\PATCHES\WINME
	D:\PATCHES\WIN2000
	D:\PATCHES\WINXP
	D:\PATCHES\WIN2003

	This script currently detects the operating system languages:
	Dutch, Spanish and Simplified Chinese.
	It will then add the suffix NL, ESP or CHS to the directory names, so 
	you could extend your directory tree with:
	D:\PATCHES\WIN2000NL
	D:\PATCHES\WIN2000ESP
	D:\PATCHES\WINXPNL
	..etc..

	And most work is of course copying all your patch-executables into the
	directories.  A hint to save a lot of typing in the patchlist: 
	keep the filename of a patch-executable the same in all operating
	system versions.

Notes:
 The performance of this script depends heavily on a modified Eval() function.
 This function normally evaluates variables only, but I modified it to 
 evaluate full AutoIt expressions.

 The modified Eval-Function only exists in my own AutoIT 3.0.103 executable.

 If you don't have this AutoIT version, then the script will AUTOMATICALLY revert
 to the UDF _Execute(), written by SlimShady.  Which will however dramatically
 decrease the performance of this script. (In my patchlist I have about
 210 evaluations to perform).

HISTORY:
Date		Version	Description
----------------	-------	--------------------------------------------------------------------------------------------
1/Oct/2004	1.0.0	First created
1/Oct/2004	1.0.0	First Release
24-NOV-2004	2.0	Second version
18-JAN-2005	3.0	Third version
12-APR-2005	4.0	Fourth version
16/May/2005	5.0	Firth version modified by JPM
---------------------------------------------------------+---------------------------------------------------------
 Copyright© John Metatron, DataActive Systems 1989-2005. All rights reserved.
---------------------------------------------------------+---------------------------------------------------------
#comments-end

; ----------------------------------------------------------------------------
; First set up our AutoIt defaults
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)		
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
AutoItSetOption("RunErrorsFatal", 0)		; Run errors are not fatal.
AutoItSetOption("TrayIconDebug", 1)		; Display a tray icon.
AutoItSetOption("WinTitleMatchMode", 4)

; ----------------------------------------------------------------------------
; Include Helper Functions
; ----------------------------------------------------------------------------
#include "mspatchfunctions.au3"
#notrayicon

; ----------------------------------------------------------------------------
; Variable declarations
; ----------------------------------------------------------------------------

Dim $CommParam		; A command line parameter
Dim $NumParams		; Number of command line parameters
Dim $CalculateOnly		; Flag to calculate only number of hotfixes required.
Dim $ShowRebootMessage	; Flag to show a reboot message if a reboot is needed.
Dim $ForceInstall		; Flag to force hotfix installation when no input from user.
Dim $PListFilename		; File name for the patch-list 
Dim $PatchDir		; Base directory where the hotfix files are located
Dim $PatchSubDir		; Subdirectory under base directory (=OS-type and language)
Dim $SDatLocation		; Location of McAfee Super DAT file
Dim $PFilename		; Patch filename to run (including silent setup params)
Dim $aLine		; Array to one line of the results file (delimiter = ;)
Dim $QNumber		; Knowledgebase number of an uninstalled hotfix
Dim $NumberTofix		; Number of hotfixes to be installed.
Dim $HotfixCounter		; counter for each hotfix
Dim $UserMessage		; Message shown to user how many hotfixes have to be installed
Dim $aHeader[30]		; Array containing the column header of the patchlist file
Dim $aArray[200]		; Array in an array containing each line and colums of the patchlist.csv
Dim $PArray[200]		; Array with index numbers to $aArray for required patches.
Dim $TitleMessage		; Custom title when a messagebox is shown to the user

; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

; Initialize some variables

$PListFilename = "OEMPatch.csv"	; Default name of the hotfix-list file
$PatchDir      = "E:\Active.OEM\WinPatches"		; Base-Location of the hotfixes files (subdirs, win2000, winxp and winnt4)
$SDatLocation  = "."		; McAfee Superdat location default in this directory 
$NumberToFix   = 0			; We start optimistic, no hotfixes to be installed.
$PatchDebug    = 0			; No debug messages.
$NumParams     = 0			; Number of command line parameters
$ShowRebootMessage= 0		; Don't reboot and don't show a reboot message.
$CalculateOnly = 0			; Detect number of hotfixes AND install them.
$ForceInstall  = 0			; Don't install hotfixes by default
$ShowErrors    = 0			; Never show any errors
$TitleMessage  = "Message from your system administrator"  ; Custom string to show to the user


; A special case to determine win2003, because @OSversion reports this as being WIN_XP

if @OSVersion="WIN_XP" and @OSBuild="3790" then	; Windows 2003 ?
   $PatchSubdir="WIN2003"
else
   $PatchSubdir=StringReplace(@OSVersion,"_","")  	; Sub directories: Win2000, winxp, etc.
endif


; Check for command line parameters

while $NumParams < $CmdLine[0]		    ; Go through each parameter

	$NumParams = $NumParams + 1	    ; Skip to next Parameter

	$CommParam=$CmdLine[$NumParams]     ; Get this command line parameter

	$CommParam=StringLower($CommParam)  ; Every character to lower case

	if StringLeft($CommParam,1) = "/" or StringLeft($CommParam,1) = "-" then _
	    $CommParam=StringRight($CommParam,StringLen($CommParam)-1)		; Remove any preceding / or - signs

	select
	  Case $CommParam = "?" or $CommParam = "help" or $CommParam = "h"
		MsgBox(0,"Usage of MSpatch","This program will check your system for missing patches and install" & @CRLF & _
		 "them when necessary." & @CRLF & @CRLF & _
		 "Command line parameters:" & @CRLF & _
		 "-h or -help"     & @TAB &": This screen." & @CRLF & _
		 "-i or -install"  & @TAB &": When no user input, force install patches." & @CRLF & _
		 "-r or -reboot"   & @TAB &": Show reboot message if necessary." & @CRLF & _
		 "-s or -source"   & @TAB &": Choose a different source directory." & @CRLF & _
		 "-l or -list"     & @TAB & @TAB &": Choose a different patch list file." & @CRLF & _
		 "-v or -virusdat" & @TAB &": Choose a different location for the McAfee SDAT file." & @CRLF & _
		 "-c or -calculate"& @TAB &": Only calculate the number of patches required." & @CRLF & _
		 "-d or -debug"    & @TAB &": Show debug information." & @CRLF & _
		 "-e or -error"    & @TAB &": Show error information if something goes wrong." & @CRLF & @CRLF & _
		 "Example: MSPATCH.EXE -d -s d:\patches -l patchlist.csv -v d:\antivirus -i" & @CRLF & @CRLF & _
		 "Default settings: no forced install, no reboot message, source is current directory, " & @CRLF & _ 
		 "      display no errors, list is patchlist.csv, virusdat location is current dir, no calculate, no debug.")
		exit

	  Case $CommParam = "d" or $CommParam = "debug" 
		$PatchDebug = 1

	  Case $CommParam = "s" or $CommParam = "source" 
		$NumParams = $NumParams + 1		; Next parameter is location of patches
		; $PatchDir = $CmdLine[$NumParams]   -  original code
		$PatchDir = $PatchDir & "\" & $CmdLine[$NumParams]   ; 13/Jun/2005 added as per ng updates
		
	  Case $CommParam = "l" or $CommParam = "list" 
		$NumParams = $NumParams + 1		; Next parameter is name of hotfix list file
		$PListFilename = $CmdLine[$NumParams]

	  Case $CommParam = "v" or $CommParam = "virusdat" 
		$NumParams = $NumParams + 1		; Next parameter is location of virus sdat file
		$SDatLocation = $CmdLine[$NumParams]

	  Case $CommParam = "c" or $CommParam = "calculate" 
		$CalculateOnly=1

	  Case $CommParam = "r" or $CommParam = "reboot" 
		$ShowRebootMessage=1

	  Case $CommParam = "i" or $CommParam = "install" 
		$ForceInstall=1

	  Case $CommParam = "e" or $CommParam = "error" 
		$ShowErrors=1

	EndSelect

Wend


; Do some sanity checks

if not FileExists($PatchDir) then
	ShowError("Error: Could not find source directory: " & $PatchDir, 0)
	exit
endif


if StringRight($PatchDir,1) <> "\" then $PatchDir = $Patchdir & "\"


if not FileExists($PListFilename) then
	ShowError("Error: Could not find hotfix list file: " & $PListFilename, 0)
	exit
endif


;Here it starts
;--------------

if ReadPatchList($PListFilename, $aArray, $aHeader) > 0 then	; Read list of patches into $aArray
							; $aArray is an that contains every line.
							; every line is a nested(!) array containing the separate columns.
  ;CSV-File read ok

  $pArray=GetRequiredPatches($aArray)		; Read list of required patches into $pArray 
						; ($pArray contains only indexnumbers to $aArray)

  $NumberToFix=$pArray[0]			; Number of patches 

  if $CalculateOnly = 1 then exit($NumberToFix)  ; Return number of hotfixes needed in 'errorlevel' number

  if $NumberToFix > 0 then	; Read the list of hotfixes and check if they are installed

   if IsAdmin() then


    ; First Check the Operating system language to see if we have any patches available

    if StringRight(@OSLang,2)="13" then $PatchSubdir= $PatchSubdir & "NL"  ; Dutch:   Different patch directory
    if StringRight(@OSLang,2)="0a" then $PatchSubdir= $PatchSubdir & "SP"  ; Spanish: Different patch directory
    if StringRight(@OSLang,2)="04" then $PatchSubdir= $PatchSubdir & "CHS" ; Chinese: Different patch directory

    if ( StringRight(@OSLang,2)<>"09" ) and not FileExists($PatchDir & $PatchSubdir ) then
	ShowError($NumberToFix & " Windows hotfix(es) had to be installed, but we don't have the files for this operating system language." _
			& @CRLF & @CRLF & "Please use the web page http://windowsupdate.microsoft.com to update this computer.",20)
	exit
    endif


    ; Now show the user how many hotfixes have to be installed.

    if $NumberToFix = 1 then
	$UserMessage="A Windows hotfix is required. Do you wish to install it now ?"
    else
	$UserMessage=$NumberToFix & " Windows hotfixes are required. Do you wish to install them now ?"
    endif
 
    ;$InstallPatches = Msgbox(4, $TitleMessage, $UserMessage ,40)	; Show the question to the user

    $InstallPatches=ShowInstallMessage($TitleMessage,$UserMessage,40)


    if ($InstallPatches = 6) or ($ForceInstall = 1) then      	 ; User chosen 'yes' for install?

      ProgressOn( "Installing hotfixes", "Installing Windows hotfixes...", _
   			$NumberToFix & " hotfix(es) to go.", -1, 60, 16)	; 5/Jul/2005 altered so we can see installation message  org:-1,-1,16

      for $HotfixCounter = 1 to $NumberToFix

	$TempArray=$aArray[$pArray[$HotfixCounter]]

	if $PatchDebug = 1 then Msgbox(0,"", "Going to run: " & $PatchDir & $PatchSubdir & "\" & $TempArray[$c_Commandline])

	ProgressSet( $HotfixCounter / $NumberToFix * 100, $NumberToFix - $HotfixCounter + 1 & _
		     " hotfix(es) to go.","Installing hotfix " & $TempArray[$c_QNumber])

	runwait($PatchDir & $PatchSubdir & "\" & $TempArray[$c_CommandLine], $PatchDir & $PatchSubdir)
        if @error=1 then
		ShowError("Error: Could not run hotfix number: " & $TempArray[$c_QNumber] & "(" & $TempArray[$c_Description] & ")",15)
	endif

      next	

      ProgressOff()

      if $ShowRebootMessage=1 then

	  if Msgbox(4,$TitleMessage, "Some hotfixes require a reboot." & _
		      @CRLF & "Do you wish to reboot now ?",120) = 6 then Shutdown(2)
	  exit(0)  ; To prevent continue running this script.

      endif ; $Showrebootmessage

    endif  ; Chosen to install the patches

   else

      Msgbox(0,$TitleMessage, _
	       "Some Windows Hotfixes had to be installed, but you do not seem to have administrator rights on this computer." & _
	       @CRLF & "Please contact your system administrator.",20)

   endif ; IsAdmin

  else

	if $PatchDebug = 1 then MsgBox(0,"MSPatch","Hotfixes on this system are up to date.")

  endif ; NumberToFix

 else
   
   ShowError("Error: Could not read the list of patches.",0)

endif ;ReadPatchFile


; McAfee Antivirus super datfile update.

UpDateAntivirus($SDatLocation)


exit



;===============================================================================
;	F U N C T I O N S
;===============================================================================

;===============================================================================
Func ForThisOS($LineArray)

; Checks if line applies to this operating system

 select

   case @OSversion = "WIN_95"
		if $LineArray[$c_win95]<>"" then return 1

   case @OSVersion = "WIN_98"
		if $LineArray[$c_win98]<>"" then return 1

   case @OSVersion = "WIN_ME"
		if $LineArray[$c_winme]<>"" then return 1

   case @OSVersion = "WIN_NT4"
		if @OSServicepack <> "Service Pack 6" then
		   if $LineArray[$c_winnt4sp1to5]<>"" then return 1
		else
		   if $LineArray[$c_winnt4sp6]<>"" then return 1
		endif
   case @OSVersion = "WIN_2000"
		if (@OSServicepack <> "Service Pack 3") and (@OSServicepack <> "Service Pack 4") then
		   if $LineArray[$c_win2ksp1to2]<>"" then return 1
		else
		   if $LineArray[$c_win2ksp3to4]<>"" then return 1
		endif

   ; AutoIt V3.1.0
   case @OSVersion = "WIN_XP" and @OSBuild="3790"  ; Windows 2003
		if @OSServicepack = "Service Pack 1" then
		  if $LineArray[$c_win2003sp1]<>"" then return 1
		else
		  if $LineArray[$c_win2003]<>"" then return 1
		endif

   ; AutoIt V3.1.1
   case @OSVersion = "WIN_2003"  ; Windows 2003
		if @OSServicepack = "Service Pack 1" then
		  if $LineArray[$c_win2003sp1]<>"" then return 1
		else
		  if $LineArray[$c_win2003]<>"" then return 1
		endif

   case @OSVersion = "WIN_XP"
		if @OSServicepack = "Service Pack 2" then
		   if $LineArray[$c_winXPsp2]<>"" then return 1
		else 
		   if @OSServicepack = "Service Pack 1" then 
		     if $LineArray[$c_winXPsp1]<>"" then return 1
		   else
		     if $LineArray[$c_winXP]<>"" then return 1
		   endif
		endif
	
 endselect

 return 0

Endfunc


;===============================================================================
Func GetRequiredPatches (ByRef $nArray)

; Reads the criteria in the given Array
; Returns a new Array with index numbers to the given Array for patches that apply

Local $Number		; To track the number of required patches
Local $Linecounter	; Counter for linenumbers in given array
Local $pArray[100]	; Return array with index numbers to given array
Local $LineArray[50]	; One line from $nArray

$Number = 0
$LineCounter = 1

while $LineCounter <= $nArray[0]	; For each element in $nArray

 $LineArray = $nArray[$LineCounter]	; Get a line from $nArray

 ;ShowDebugMessage ("GetRequiredPatches: counter: " & $LineCounter & " neweval( " & $LineArray[$c_RequiredCrit] &   _
;			") required: " &  NewEval($LineArray[$c_RequiredCrit]) )

 $HSM="HKLM\SOFTWARE\Microsoft"		; I use this as a shortening 'macro-like' replacement in the CSV file, 

					; otherwise the criteria-lines look very long !

					; Test the ticks in the OS-columns;  TRUE = patch applies
					; Test the 'Patch installed' criteria; FALSE = patch applies
					; Test the 'is Required' criteria; TRUE = patch applies

 if ForThisOS($LineArray) and _				
    not NewEval($LineArray[$c_InstalledCrit]) and _	
    NewEval($LineArray[$c_RequiredCrit]) 	then		

    $Number = $Number + 1		; We have a required patch found

    $pArray[$Number]=$LineCounter	; Save the index number

    ShowDebugMessage ("GetRequiredPatches: Number: " & $Number & " LineCounter: " & $LineCounter)

 endif

 $LineCounter=$LineCounter + 1		; Next line

Wend

$pArray[0]=$Number			; Total number of required patches


Return $pArray				; Return our 'Required-patches' Array

endfunc


;===============================================================================
Func UpdateAntivirus($SDatPath)

; Update McAfee Antivirus using a superdat file
;
; If a location is given in $SDATPath then the SDAT file will be taken from that path.
; Otherwise the newest SDAT will be searched in the following paths:
; 1. Current Directory
; 2. H:\Appl95\Mcafee\Autoupdate
; 3. \\campusmp\software\McAfee\Anti4us\idat


Dim $RegLocation
Dim $RegValue1
Dim $RegValue2
Dim $VersionString
Dim $CurrentDatVersion
Dim $DatVersion
Dim $NewestDatVersion
Dim $InstallPath

$RegLocation="HKLM\SOFTWARE\Network Associates\TVD\Shared Components\VirusScan Engine\4.0.xx"
$RegValue1="szDatVersion"
$RegValue2="szVirDefVer"
$NewestDatVersion=""
$InstallPath=""


;First check which anti virus version we run. 

;Registry Location for version 4.x
$VersionString=RegRead($RegLocation,$RegValue1)

if @ERROR <> 0 then 
; 	No 4.x found, check for 7.x

	$VersionString=RegRead($RegLocation,$RegValue2)
	if @ERROR <> 0 then 
		if $PatchDebug = 1 then MsgBox(0,"MSPATCH","WARNING: Could not find McAfee Anti virus version on this system!!")
		return 0	; No McAfee antivirus found!!
	endif
endif

if StringLen($VersionString) < 4 then
	if $PatchDebug = 1 then MsgBox(0,"MSPATCH","WARNING: McAfee Anti Virus registry version is empty !!")
	return 0	; No McAfee antivirus found!!
endif


$CurrentDatVersion=StringRight($VersionString,4)

if $PatchDebug = 1 then MsgBox(0,"MSPATCH","INFO: Your Current Antivirus version is: " & $CurrentDatVersion )

;Now check if a SDAT file exists


;First in the given directory

if $SDatPath="" then $SDatPath="."	; No path given, then search in use current directory.

$DatVersion=FindDatFile($SDatPath,$CurrentDatVersion)

if $DatVersion > $NewestDatVersion then 
   $NewestDatVersion = $DatVersion
   $InstallPath = $SDatPath
endif


if $NewestDatVersion <> "" then

  ; Install the most current SDAT file found

  if $PatchDebug = 1 then MsgBox (0,"MSPATCH","INFO: Going to run: " & $InstallPath & "\" &  _
					$NewestDatVersion & " /logfile " & @TEMPDIR & _
					"\nailog.txt /F /silent")

  run( $InstallPath & "\" & $NewestDatVersion & " /logfile " & @TEMPDIR & "\nailog.txt /F /silent")

else ;No newer updates found.

  if $PatchDebug = 1 then MsgBox (0,"MSPATCH","INFO: No newest antivirus updates found.")

endif


endfunc


;============================================
Func FindDatFile($dirname,$CurrentDatVersion)

;
; Checks for highest version of SDAT????.EXE file in a given directory
; And compares it to the given $CurrentDatVersion
;
; Returns: 
; If the version of the DAT file is higher than the given version: The name of the SDAT file
; Otherwise:                                                       An empty string

Dim $DatVersion			; SDAT version found in $dirname
Dim $NewestDatFilename		; Filename of the newest SDAT version found so far in $dirname
Dim $SearchResult		; Temporary Result value from FindFile..
Dim $DatFileName		; Temporary filename of a found SDAT file in $dir (not necessarily the newest one)

$NewestDatFileName=""

$SearchResult = FileFindFirstFile($dirname & "\sdat????.exe")  

; No SDAT file found in this directory
If $SearchResult = -1 Then
    Return ""
EndIf

While 1
    $DatFileName = FileFindNextFile($SearchResult) 

    if $Datfilename > $NewestDatFilename then $NewestDatFilename = $DatFileName

    If @error Then ExitLoop 

WEnd

; Close the search handle
FileClose($SearchResult)


$DatVersion = StringMid($NewestDatFilename,5,4)

; ShowDebugMessage ("FindDatFile: Newest datfilename in " & $dirname & " : " & $NewestDatFilename & " DatVersion: " & $DatVersion & " current virversion: " & $CurrentDatVersion )


if $DatVersion > $CurrentDatVersion then 
	Return $NewestDatFileName
else
	Return ""
endif

endfunc



;============================================
Func ShowInstallMessage($TitleMessage,$UserMessage,$TimeOut)

 do

   $InstallPatches=0
   $ShowDetails=0

   $InstallHandle=GuiCreate($TitleMessage, 350, 90)

   GuiCtrlCreateLabel($UserMessage, 10, 10, 400, 50)

   $YesButton=GuiCtrlCreateButton(" Yes ", 20, 50 , 90, 25)	
   $NoButton=GuiCtrlCreateButton(" No ", 130, 50, 90, 25)
   $DetailsButton=GuiCtrlCreateButton(" Details.. ", 240, 50, 90, 25)

   GuiSetState(@SW_SHOW,$InstallHandle)				; Show GUI

   $begin = TimerInit()

   ; Run the GUI until the dialog is closed
   While 1

      $dif = TimerDiff($begin)/1000

      $msg = GUIGetMsg()

      select

  	case $msg = $YesButton
		$InstallPatches=6
    		ExitLoop

  	case $msg = $NoButton
		$InstallPatches=7
    		ExitLoop

	case $msg = $DetailsButton
 		$ShowDetails=1
		ExitLoop

	case $dif > $Timeout
		ExitLoop

      endselect

      sleep(100)	; Give CPU some time.
   WEnd

   GUIDelete($InstallHandle)

   if $ShowDetails = 1 then ShowDetails()

 until $ShowDetails = 0 

 Return $InstallPatches

EndFunc



;============================================
Func ShowDetails()

Const $GUI_EVENT_CLOSE			= -3

Const $LVS_REPORT = 0x0001
$DetailsHandle=GuiCreate("MSPatch Details", 400, 400)

GuiCtrlCreateLabel("The following patches will be installed on this computer:", 15, 10, 400, 30)

$listView = GuiCtrlCreateListView("Q-Number|Bulletin|Date|Description", 15, 30, 370, 320, $LVS_REPORT)	; 13/Jun/2005 modified to accept date field

for $HotfixCounter = 1 to $NumberToFix

   $TempArray=$aArray[$pArray[$HotfixCounter]]
   
   GuiCtrlCreateListViewItem($TempArray[$c_QNumber] & "|" & $TempArray[$c_PatchNumber] & "|" & $TempArray[$c_Date] & "|" & $TempArray[$c_Description], $listView) ; 13/Jun/2005 modified to accept date field

next

$CloseButton=GuiCtrlCreateButton(" Close ", 150, 360, 100, 30)    ; Close button


GuiSetState(@SW_SHOW,$DetailsHandle)				; Show GUI

; Run the GUI until the dialog is closed
While 1

   $msg = GUIGetMsg()

   select

	case $msg = $CloseButton
    		ExitLoop

	case $msg = $GUI_EVENT_CLOSE 
		ExitLoop
   endselect

   
WEnd

GUIDelete($DetailsHandle)

EndFunc

;============================================
; Evaluates an AutoIT expression in $string
; Returns 1 if the expression is valid and true
; Returns 0 otherwise

; THIS FUNCTION DEPENDS HEAVILY ON A MODIFIED EVAL() FUNCTION.
; THE MODIFIED EVAL() FUNCTION ONLY EXISTS IN THE BETA V3.1.1.xx versions of AUTOIT !
;
; If you have a regular AutoIt version, it will revert to the _Execute() UDF
; which is written by SlimShady
Func NewEval($String)

 $HSM="HKLM\SOFTWARE\Microsoft"		; I use this as a shortening 'macro-like' replacement in the CSV file, 
					; otherwise the criteria-lines become very long !

 IF eval("1=1") = 1 then		; Check if we have the extended Eval() function
	Return Eval($String)

 ELSE					; No extended eval, then use _Execute()
	Return _Execute($String)
 ENDIF

EndFunc


Func _Execute($LineofCode)
;
; _Execute function written by: SlimShady
; See: http://www.autoitscript.com/forum/index.php?showtopic=7607
;
; Slightly modified using the Exit() function

   Local $RetVal
   Local $NewLineofCode = $LineofCode
   $NewLineofCode = StringReplace($NewLineofCode, '$HSM', '"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft"' )
   $NewLineofCode = StringReplace($NewLineofCode, '""', '"')
   $NewLineofCode = StringReplace($NewLineofCode, "'", "''")
   $NewLineofCode = StringReplace($NewLineofCode, '"', "'")
   $RetVal = RunWait(@AutoItExe & ' /c "Exit(' & $NewLineofCode & ')"', @SystemDir)
   Return $RetVal
EndFunc

; If you want to compile MSPatch.au3 into MSPatch.exe using the 'regular' AutoIt version,
; place AutoIT.exe in the same directory as MSPatch.au3 and modify the last lines of
; the _Execute function into:
;
; FileInstall("AutoIt.exe",@Temp & "\AutoIt.exe",1 )
; $RetVal = RunWait(@Temp & "\AutoIt.exe" & ' /c "Exit(' & $NewLineofCode & ')"', @SystemDir)
;





;=========================================================
;That's all !


