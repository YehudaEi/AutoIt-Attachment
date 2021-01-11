Func _IniVarReplace($text)
	;Replace ~AppDataCommonDir~ with @AppDataCommonDir
	$text = StringReplace($text,"~AppDataCommonDir~",@AppDataCommonDir,0,0)
	
	;Replace ~AppDataDir~ with @AppDataDir
	$text = StringReplace($text,"~AppDataDir~",@AppDataDir,0,0)
	
	;Replace ~AutoItExe~ with @AutoItExe
	$text = StringReplace($text,"~AutoItExe~",@AutoItExe,0,0)
	
	;Replace ~AutoItPID~ with @AutoItPID
	$text = StringReplace($text,"~AutoItPID~",@AutoItPID,0,0)
	
	;Replace ~AutoItVersion~ with @AutoItVersion
	$text = StringReplace($text,"~AutoItVersion~",@AutoItVersion,0,0)
	
	;Replace ~CommonFilesDir~ with @CommonFilesDir
	$text = StringReplace($text,"~CommonFilesDir~",@CommonFilesDir,0,0)
	
	;Replace ~Compiled~ with @Compiled
	$text = StringReplace($text,"~Compiled~",@Compiled,0,0)
	
	;Replace ~ComputerName~ with @ComputerName
	$text = StringReplace($text,"~ComputerName~",@ComputerName,0,0)
	
	;Replace ~ComSpec~ with @ComSpec
	$text = StringReplace($text,"~ComSpec~",@ComSpec,0,0)
	
	;Replace ~CR~ with @CR
	$text = StringReplace($text,"~CR~",@CR,0,0)
	
	;Replace ~CRLF~ with @CRLF
	$text = StringReplace($text,"~CRLF~",@CRLF,0,0)
	
	;Replace ~DesktopCommonDir~ with @DesktopCommonDir
	$text = StringReplace($text,"~DesktopCommonDir~",@DesktopCommonDir,0,0)
	
	;Replace ~DesktopDir~ with @DesktopDir
	$text = StringReplace($text,"~DesktopDir~",@DesktopDir,0,0)
	
	;Replace ~DesktopHeight~ with @DesktopHeight
	$text = StringReplace($text,"~DesktopHeight~",@DesktopHeight,0,0)
	
	;Replace ~DesktopWidth~ with @DesktopWidth
	$text = StringReplace($text,"~DesktopWidth~",@DesktopWidth,0,0)
	
	;Replace ~DesktopDepth~ with @DesktopDepth
	$text = StringReplace($text,"~DesktopDepth~",@DesktopDepth,0,0)
	
	;Replace ~DesktopRefresh~ with @DesktopRefresh
	$text = StringReplace($text,"~DesktopRefresh~",@DesktopRefresh,0,0)
	
	;Replace ~DocumentsCommonDir~ with @DocumentsCommonDir
	$text = StringReplace($text,"~DocumentsCommonDir~",@DocumentsCommonDir,0,0)
	
	;Replace ~error~ with @error
	$text = StringReplace($text,"~error~",@error,0,0)
	
	;Replace ~extended~ with @extended
	$text = StringReplace($text,"~extended~",@extended,0,0)
	
	;Replace ~FavoritesCommonDir~ with @FavoritesCommonDir
	$text = StringReplace($text,"~FavoritesCommonDir~",@FavoritesCommonDir,0,0)
	
	;Replace ~FavoritesDir~ with @FavoritesDir
	$text = StringReplace($text,"~FavoritesDir~",@FavoritesDir,0,0)
	
	;Replace ~HomeDrive~ with @HomeDrive
	$text = StringReplace($text,"~HomeDrive~",@HomeDrive,0,0)
	
	;Replace ~HomePath~ with @HomePath
	$text = StringReplace($text,"~HomePath~",@HomePath,0,0)
	
	;Replace ~HomeShare~ with @HomeShare
	$text = StringReplace($text,"~HomeShare~",@HomeShare,0,0)
	
	;Replace ~HOUR~ with @HOUR
	$text = StringReplace($text,"~HOUR~",@HOUR,0,0)
	
	;Replace ~HotKeyPressed~ with @HotKeyPressed
	$text = StringReplace($text,"~HotKeyPressed~",@HotKeyPressed,0,0)
	
	;Replace ~InetGetActive~ with @InetGetActive
	$text = StringReplace($text,"~InetGetActive~",@InetGetActive,0,0)
	
	;Replace ~InetGetBytesRead~ with @InetGetBytesRead
	$text = StringReplace($text,"~InetGetBytesRead~",@InetGetBytesRead,0,0)
	
	;Replace ~IPAddress1~ with @IPAddress1
	$text = StringReplace($text,"~IPAddress1~",@IPAddress1,0,0)
	
	;Replace ~IPAddress2~ with @IPAddress2
	$text = StringReplace($text,"~IPAddress2~",@IPAddress2,0,0)
	
	;Replace ~IPAddress3~ with @IPAddress3
	$text = StringReplace($text,"~IPAddress3~",@IPAddress3,0,0)
	
	;Replace ~IPAddress4~ with @IPAddress4
	$text = StringReplace($text,"~IPAddress4~",@IPAddress4,0,0)
	
	;Replace ~LF~ with @LF
	$text = StringReplace($text,"~LF~",@LF,0,0)
	
	;Replace ~LogonDNSDomain~ with @LogonDNSDomain
	$text = StringReplace($text,"~LogonDNSDomain~",@LogonDNSDomain,0,0)
	
	;Replace ~LogonDomain~ with @LogonDomain
	$text = StringReplace($text,"~LogonDomain~",@LogonDomain,0,0)
	
	;Replace ~LogonServer~ with @LogonServer
	$text = StringReplace($text,"~LogonServer~",@LogonServer,0,0)
	
	;Replace ~MDAY~ with @MDAY
	$text = StringReplace($text,"~MDAY~",@MDAY,0,0)
	
	;Replace ~MIN~ with @MIN
	$text = StringReplace($text,"~MIN~",@MIN,0,0)
	
	;Replace ~MON~ with @MON
	$text = StringReplace($text,"~MON~",@MON,0,0)
	
	;Replace ~MyDocumentsDir~ with @MyDocumentsDir
	$text = StringReplace($text,"~MyDocumentsDir~",@MyDocumentsDir,0,0)
	
	;Replace ~NumParams~ with @NumParams
	$text = StringReplace($text,"~NumParams~",@NumParams,0,0)
	
	;Replace ~OSBuild~ with @OSBuild
	$text = StringReplace($text,"~OSBuild~",@OSBuild,0,0)
	
	;Replace ~OSLang~ with @OSLang
	$text = StringReplace($text,"~OSLang~",@OSLang,0,0)
	
	;Replace ~OSServicePack~ with @OSServicePack
	$text = StringReplace($text,"~OSServicePack~",@OSServicePack,0,0)
	
	;Replace ~OSTYPE~ with @OSTYPE
	$text = StringReplace($text,"~OSTYPE~",@OSTYPE,0,0)
	
	;Replace ~OSVersion~ with @OSVersion
	$text = StringReplace($text,"~OSVersion~",@OSVersion,0,0)
	
	;Replace ~ProcessorArch~ with @ProcessorArch
	$text = StringReplace($text,"~ProcessorArch~",@ProcessorArch,0,0)
	
	;Replace ~ProgramFilesDir~ with @ProgramFilesDir
	$text = StringReplace($text,"~ProgramFilesDir~",@ProgramFilesDir,0,0)
	
	;Replace ~ProgramsCommonDir~ with @ProgramsCommonDir
	$text = StringReplace($text,"~ProgramsCommonDir~",@ProgramsCommonDir,0,0)
	
	;Replace ~ProgramsDir~ with @ProgramsDir
	$text = StringReplace($text,"~ProgramsDir~",@ProgramsDir,0,0)
	
	;Replace ~ScriptDir~ with @ScriptDir
	$text = StringReplace($text,"~ScriptDir~",@ScriptDir,0,0)
	
	;Replace ~ScriptFullPath~ with @ScriptFullPath
	$text = StringReplace($text,"~ScriptFullPath~",@ScriptFullPath,0,0)
	
	;Replace ~ScriptLineNumber~ with @ScriptLineNumber
	$text = StringReplace($text,"~ScriptLineNumber~",@ScriptLineNumber,0,0)
	
	;Replace ~ScriptName~ with @ScriptName
	$text = StringReplace($text,"~ScriptName~",@ScriptName,0,0)
	
	;Replace ~SEC~ with @SEC
	$text = StringReplace($text,"~SEC~",@SEC,0,0)
	
	;Replace ~StartMenuCommonDir~ with @StartMenuCommonDir
	$text = StringReplace($text,"~StartMenuCommonDir~",@StartMenuCommonDir,0,0)
	
	;Replace ~StartMenuDir~ with @StartMenuDir
	$text = StringReplace($text,"~StartMenuDir~",@StartMenuDir,0,0)
	
	;Replace ~StartupCommonDir~ with @StartupCommonDir
	$text = StringReplace($text,"~StartupCommonDir~",@StartupCommonDir,0,0)
	
	;Replace ~StartupDir~ with @StartupDir
	$text = StringReplace($text,"~StartupDir~",@StartupDir,0,0)
	
	;Replace ~SW_DISABLE~ with @SW_DISABLE
	$text = StringReplace($text,"~SW_DISABLE~",@SW_DISABLE,0,0)
	
	;Replace ~SW_ENABLE~ with @SW_ENABLE
	$text = StringReplace($text,"~SW_ENABLE~",@SW_ENABLE,0,0)
	
	;Replace ~SW_HIDE~ with @SW_HIDE
	$text = StringReplace($text,"~SW_HIDE~",@SW_HIDE,0,0)
	
	;Replace ~SW_LOCK~ with @SW_LOCK
	$text = StringReplace($text,"~SW_LOCK~",@SW_LOCK,0,0)
	
	;Replace ~SW_MAXIMIZE~ with @SW_MAXIMIZE
	$text = StringReplace($text,"~SW_MAXIMIZE~",@SW_MAXIMIZE,0,0)
	
	;Replace ~SW_MINIMIZE~ with @SW_MINIMIZE
	$text = StringReplace($text,"~SW_MINIMIZE~",@SW_MINIMIZE,0,0)
	
	;Replace ~SW_RESTORE~ with @SW_RESTORE
	$text = StringReplace($text,"~SW_RESTORE~",@SW_RESTORE,0,0)
	
	;Replace ~SW_SHOW~ with @SW_SHOW
	$text = StringReplace($text,"~SW_SHOW~",@SW_SHOW,0,0)
	
	;Replace ~SW_SHOWDEFAULT~ with @SW_SHOWDEFAULT
	$text = StringReplace($text,"~SW_SHOWDEFAULT~",@SW_SHOWDEFAULT,0,0)
	
	;Replace ~SW_SHOWMAXIMIZED~ with @SW_SHOWMAXIMIZED
	$text = StringReplace($text,"~SW_SHOWMAXIMIZED~",@SW_SHOWMAXIMIZED,0,0)
	
	;Replace ~SW_SHOWMINIMIZED~ with @SW_SHOWMINIMIZED
	$text = StringReplace($text,"~SW_SHOWMINIMIZED~",@SW_SHOWMINIMIZED,0,0)
	
	;Replace ~SW_SHOWMINNOACTIVE~ with @SW_SHOWMINNOACTIVE
	$text = StringReplace($text,"~SW_SHOWMINNOACTIVE~",@SW_SHOWMINNOACTIVE,0,0)
	
	;Replace ~SW_SHOWNA~ with @SW_SHOWNA
	$text = StringReplace($text,"~SW_SHOWNA~",@SW_SHOWNA,0,0)
	
	;Replace ~SW_SHOWNOACTIVATE~ with @SW_SHOWNOACTIVATE
	$text = StringReplace($text,"~SW_SHOWNOACTIVATE~",@SW_SHOWNOACTIVATE,0,0)
	
	;Replace ~SW_SHOWNORMAL~ with @SW_SHOWNORMAL
	$text = StringReplace($text,"~SW_SHOWNORMAL~",@SW_SHOWNORMAL,0,0)
	
	;Replace ~SW_UNLOCK~ with @SW_UNLOCK
	$text = StringReplace($text,"~SW_UNLOCK~",@SW_UNLOCK,0,0)
	
	;Replace ~SystemDir~ with @SystemDir
	$text = StringReplace($text,"~SystemDir~",@SystemDir,0,0)
	
	;Replace ~TAB~ with @TAB
	$text = StringReplace($text,"~TAB~",@TAB,0,0)
	
	;Replace ~TempDir~ with @TempDir
	$text = StringReplace($text,"~TempDir~",@TempDir,0,0)
	
	;Replace ~TrayIconFlashing~ with @TrayIconFlashing
	$text = StringReplace($text,"~TrayIconFlashing~",@TrayIconFlashing,0,0)
	
	;Replace ~TrayIconVisible~ with @TrayIconVisible
	$text = StringReplace($text,"~TrayIconVisible~",@TrayIconVisible,0,0)
	
	;Replace ~UserProfileDir~ with @UserProfileDir
	$text = StringReplace($text,"~UserProfileDir~",@UserProfileDir,0,0)
	
	;Replace ~UserName~ with @UserName
	$text = StringReplace($text,"~UserName~",@UserName,0,0)
	
	;Replace ~WDAY~ with @WDAY
	$text = StringReplace($text,"~WDAY~",@WDAY,0,0)
	
	;Replace ~WindowsDir~ with @WindowsDir
	$text = StringReplace($text,"~WindowsDir~",@WindowsDir,0,0)
	
	;Replace ~WorkingDir~ with @WorkingDir
	$text = StringReplace($text,"~WorkingDir~",@WorkingDir,0,0)
	
	;Replace ~YDAY~ with @YDAY
	$text = StringReplace($text,"~YDAY~",@YDAY,0,0)
	
	;Replace ~YEAR~ with @YEAR
	$text = StringReplace($text,"~YEAR~",@YEAR,0,0)

	Return $text
EndFunc