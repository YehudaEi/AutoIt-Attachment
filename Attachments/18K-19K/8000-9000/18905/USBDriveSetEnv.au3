#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=AutoIt_HighColor.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_UseX64=Y
#AutoIt3Wrapper_Res_Comment=USB Drive Set Environment (CUI)
#AutoIt3Wrapper_Res_Description=Sets the Environment Variable USBDrive to paramater passed to it.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.42
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=JerryD
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Build Date|%longdate%  %time%
#AutoIt3Wrapper_Res_Field=AutoItVersion|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Author|JerryD
#AutoIt3Wrapper_Res_Field=OS|Windows (All Versions including Vista)
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=Y
#AutoIt3Wrapper_Run_Debug_Mode=n

#Region Standard Header
; ----------------------------------------------------------------------------
; AutoIt Version: 3.2.10.0
; Language:       English
; Platform:       WinXP/Vista
; Author:         JerryD <jdellasala@gmail.com>
;
; Script Function:	(CUI) Create or remove the Environment Variable USBDrive
;					based on the drive letter passed as the first paramater
;
;					If a drive letter is passed (X or X: or X:\),
;					the environment variable is set if the drive's status is READY
;
;					If the paramater - is passed, the environment variable is removed.
; ----------------------------------------------------------------------------
#Region AutoIt Options
AutoItSetOption ( 'TrayIconHide', 1 )		; 0 = show icon (default), 1 = Hide
AutoItSetOption ( 'MustDeclareVars', 1 )
#endregion AutoIt Options
#Region Special Functions
; ----------------------------------------------------------------------------
; This will always guarentee that the source is available as part of a compiled script!
; !!! NOTE; COMPILATION WILL FAIL IF FILEINSTALL ISN'T FILLED IN !!!
; ----------------------------------------------------------------------------
If $CmdLine[0] = 2 AND $CmdLine[1] = '/source' AND $CmdLine[2] = 'password'  Then
	FileInstall ( 'USBDriveSetEnv.au3', 'USBDriveSetEnv.au3', 1 )
	FileInstall ( 'AutoIt_HighColor.ico', 'AutoIt_HighColor.ico' )
	Exit
EndIf
#endregion Special Functions
#endregion Standard Header
#Region Variables
Global $Rev
If @Compiled Then
	$Rev = FileGetVersion ( @ScriptFullPath )
Else
	$Rev = '1.0.0'
EndIf
Global Const $Title = 'Set USB Drive Environment Variable ' & $Rev
Global Const $EnvVarName = 'USBDrive'
Global Const $HelpMsg = @CRLF & @ScriptName & ': ' & $Title & @CRLF & _
						'By JerryD - based on scripts found at:' & @CRLF & _
						'http://www.microsoft.com/technet/scriptcenter/resources/qanda/mar05/hey0318.mspx' & @CRLF & @CRLF & _
						'usage: USBDriveSetEnv [DriveLetter: | -]' & @CRLF & _
						'       Drive:' & @TAB & 'Sets the environment variable USBDrive to Drive:.' & @CRLF  & _
						'       -' & @TAB & @TAB & 'Removes the environment variable USBDrive' & @CRLF & @CRLF & _
						'Driveletter can be signle letter (C), drive (C:), or root of a drive (C:\).' & @CRLF & _
						'The first three characters of the paramater will be used' & @CRLF & _
						'regardless of the lenght of the paramater.' & @CRLF & @CRLF & _
						'NOTE: The environment variable will NOT be available immediately.' & @CRLF & _
						'      The environment variable can only be cleared using this utility,' & @CRLF & _
						'      or by manually removing it from Computer Properties.' & @CRLF

Local $DriveName, $DriveRoot, $DriveStatus, $Ret, $Error, $ExtErr
#EndRegion Variables

#Region Main
Select
	Case $CmdLine[0] <> 1
		ConsoleWrite ( $HelpMsg )
		Exit 0
	Case $CmdLine[1]='-'
		$Ret = _EnvSet ( $EnvVarName )
		$Error = @error
		$ExtErr = @extended
		If $Ret Then
			EnvUpdate()
			ConsoleWrite ( @CRLF & @ScriptName & ':' & @CRLF & 'Environment variable USBDrive removed' & @CRLF )
			Exit 0
		Else
			ConsoleWrite ( @CRLF & @ScriptName & ':' & @CRLF & 'EROOR Removing environment variable USBDrive!' & @CRLF )
			ConsoleWrite ( 'Error: ' & $Error & @TAB & 'Extended: ' & $ExtErr & @CRLF )
			Exit 1
		EndIf
	Case StringInStr($CmdLine[1],'?') Or StringLeft($CmdLine[1],1)='/' Or StringLeft($CmdLine[1],1)='-'
		ConsoleWrite ( $HelpMsg )
		Exit 0
	Case StringLen($CmdLine[1])=1
		$DriveName = $CmdLine[1] & ':'
		$DriveRoot = $CmdLine[1] & ':\'
	Case StringLen($CmdLine[1])=2
		$DriveName = $CmdLine[1]
		$DriveRoot = $CmdLine[1] & '\'
	Case StringLen($CmdLine[1])=3
		$DriveName = StringLeft($CmdLine[1],2)
		$DriveRoot = $CmdLine[1]
	Case Else
		$DriveName = StringLeft($CmdLine[1],2)
		$DriveRoot = StringLeft($CmdLine[1],3)
EndSelect
$DriveStatus = DriveStatus( $DriveRoot )
If $DriveStatus<>'READY' Then
	ConsoleWrite ( @CRLF & @ScriptName & ':' & @CRLF & ' ERROR: Invalid Drive Status!' & @CRLF & ' Drive: ' & $DriveName & @CRLF & 'Status: ' & $DriveStatus & @CRLF )
	Exit 1
Else
	$DriveName = StringUpper ( $DriveName )
	$Ret = _EnvSet ( $EnvVarName, $DriveName )
	$Error = @error
	$ExtErr = @extended
	If $Ret Then
		EnvUpdate ( )
		ConsoleWrite ( @CRLF & @ScriptName & ':' & @CRLF & 'Environment variable USBDrive set to ' & $DriveName & @CRLF )
		Exit 0
	Else
		ConsoleWrite ( @CRLF & @ScriptName & ':' & @CRLF & 'EROOR Setting environment variable USBDrive!' & @CRLF )
		ConsoleWrite ( 'Error: '& $Error & @TAB & 'Extended: ' & $ExtErr & @CRLF )
	EndIf
EndIf

Func _EnvSet ( $sEnvVarName, $sEnvVarValue='', $bUser=1 )
	Const $sUserKey = 'HKEY_CURRENT_USER\Environment'
	Const $sSystemKey = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
	Local $sEnvKey, $Ret
	
	If $bUser Then
		$sEnvKey = $sUserKey
	Else
		$sEnvKey = $sSystemKey
	EndIf
	
	If $sEnvVarValue = '' Then
		$Ret = RegDelete ( $sEnvKey, $sEnvVarName )
		Return SetError ( @error, @extended, $Ret )
	Else
		$Ret = RegWrite ( $sEnvKey, $sEnvVarName, 'REG_SZ', $sEnvVarValue )
		Return SetError ( @error, @extended, $Ret )
	EndIf
EndFunc
