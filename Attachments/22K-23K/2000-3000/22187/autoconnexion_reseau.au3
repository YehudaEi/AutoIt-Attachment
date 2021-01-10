;mount network to drive lettre automatically

#cs
Subject
Mount network drive

Goal
Do automatically mounting network drive and retrying if the hist is not avaible.

Why
I use this whith my Media Center.
Media Center start and my program mount automatically drive when they avaible. Not need to return windows to mount/remount manualy.

Install
Create a INI file which contains all drive to mounting.
Put this INI file to program' parameter
#ce

#cs
	History
	V110 : Add 'umountfirst' option to force the umount drive letter when you run program for the 1st
	V100 : initial program
#ce

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icone.ico
#AutoIt3Wrapper_Outfile=autoconnexion_reseau.exe
#AutoIt3Wrapper_UseUpx=Y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Array.au3>
#include "../../mylib/_file.au3"
Dim $iniFile = ""

dim $g_daemon = 0		;En tache de fond
dim $g_checkevery = 0	;Check le mapping toutes les x secondes
dim $g_umountfirst = 0	;For the 1st run, umount drive if letter is mapped
dim $g_mindelay=10		;Delai minimum avant reconnexion (sec)
dim $g_remount = 0		;Refait le montage en cas de deconnexion
dim $g_amount[1]

if $CmdLine[0]=1 Then
	$iniFile=$CmdLine[1]
Else
	$iniFile=@ScriptDir & "\autoconnexion_reseau.ini"
EndIf

$listSection = IniReadSectionNames($iniFile)
If @error Then
	$help="[GLOBAL]"&@LF
	$help&="checkevery=[toutes les x secondes. (defaut=0)]"&@LF
	$help&="remount=[1:Reconnexion continue, 0(defaut):Un seul essai]"&@LF
	$help&="umountfirst=[1:For the init program, force umount drive, 0(defaut):Keep drive if letter already exists]"&@LF
	$help&=""&@LF
	$help&="[<MOUNT NAME>]"&@LF
	$help&="host=<nom de la machine>"&@LF
	$help&="dir=<dossier à monter>"&@LF
	$help&="driveletter=<drive:>"&@LF
	$help&="user=[user]"&@LF
	$help&="pass=[pass|*:Show prompt for password]"&@LF
	$help&="remount=[1|0]"&@LF
	$help&="umountfirst=[1|0]"&@LF
	$help&=""&@LF
    MsgBox(4096, "AutoConnexion_Reseau", "Erreur dans le fichier " & $iniFile & ", script arrêté."&@LF&$help)
	Exit 1
EndIf

$section_GLOBAL = IniReadSection ( $iniFile, "GLOBAL" )
For $i = 1 To $section_GLOBAL[0][0]
	Switch $section_GLOBAL[$i][0]
		case "checkevery"
			$g_checkevery=$section_GLOBAL[$i][1]
		case "remount"
			$g_remount=$section_GLOBAL[$i][1]
		case "umountfirst"
			$g_umountfirst=$section_GLOBAL[$i][1]
	EndSwitch
Next

if $g_checkevery > 0 and $g_checkevery < $g_mindelay Then $g_checkevery = $g_mindelay
$g_amount[0]=$g_checkevery;

For $isection = 1 To $listSection[0]
	$section=$listSection[$isection]
	
	;Ignore le choix GRLOBAL, géré précédemment
	if $section = "GLOBAL" then ContinueLoop
	
	;=======================================================MOUNT
	$host = IniRead($iniFile, $section, "host", "")
	$dir = IniRead($iniFile, $section, "dir", "")
	$driveletter = IniRead($iniFile, $section, "driveletter", "")
	$user = IniRead($iniFile, $section, "user", "")
	$pass = IniRead($iniFile, $section, "pass", "")
	$remount = IniRead($iniFile, $section, "remount", $g_remount)
	$umountfirst = IniRead($iniFile, $section, "umountfirst", $g_umountfirst)
	
	if $host = "" or $dir = "" or $driveletter = "" Then
		MsgBox(0,"Alerte FILE", "Erreur de paramétrage dans la section: "&$section)
	EndIf
	
	_ArrayAdd($g_amount, $host&";"&$dir&";"&$driveletter&";"&$user&";"&$pass&";"&$remount)
Next

$init=1	;Comportement normal pour le 1er montage
while (1)
	for $i=1 to ubound($g_amount)-1
		$amount = StringSplit($g_amount[$i],";")
		
		$host = $amount[1]
		$dir = $amount[2]
		$driveletter = $amount[3]
		$user = $amount[4]
		$pass = $amount[5]
		$remount = $amount[6]
		
		;Force umount drive for the init run
		if $init=1 and $umountfirst=1 Then
			$app="net"
			$param=" use " & $driveletter & " /delete"
			;RunWait($removedrive,"",@SW_HIDE)
			ShellExecuteWait($app, $param, "", "", @SW_HIDE)
		EndIf
		
		;Pas de reconnexion pour ce montage
		if $init = 0 and $remount = 0 then ContinueLoop
		
		;Check if user needed to connect drive
		if $user <> "" then $user="/user:"&$user
			
		;Show the Inputbox if pass variable is egal to '*'
		if $pass = "*" then
			$pass = InputBox("Mount of " & $section, "Password to mount", "", "X", 400, 80)
			if @error <> 0 then ContinueLoop
		EndIf
		
		;Continue if drive es already connected
		if DriveStatus($driveletter) = "READY" Then ContinueLoop
		
		;umount drive lettre
		$app="net"
		$param=" use " & $driveletter & " /delete"
		;RunWait($removedrive,"",@SW_HIDE)
		ShellExecuteWait($app, $param, "", "", @SW_HIDE)
		
		;mount drive
		$app="net"
		$param=" use " & $driveletter & " \\" & $host & $dir & " " & $user & " " & $pass
		;RunWait($mountdrive,"",@SW_HIDE)
		ShellExecuteWait($app, $param, "", "", @SW_HIDE)
		
	Next
	
	$init = 0
	
	;Pas d'auto reconnexion
	if $g_checkevery = 0 Then ExitLoop
		
	sleep($g_checkevery * 1000)
WEnd

Exit
