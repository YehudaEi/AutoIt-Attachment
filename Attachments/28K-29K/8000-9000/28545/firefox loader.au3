#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=FfoxIcon.ico
#AutoIt3Wrapper_outfile=../firefox loader.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <File.au3>
#Include <Array.au3>
AutoItSetOption ("TrayIconHide", 0)
FileCreateShortcut (@scriptdir & "\firefox loader.exe", @AppDataDir & "\Microsoft\Internet Explorer\Quick Launch\firefox loader.lnk", @ScriptDir & "\firefox loader.exe")
IsAdmin ()
;==========================================================================================================
	#Region ; settigns check
	$settings = FileExists (@scriptdir & "\settings.ini")
If $settings = 0 Then
MsgBox(48,'ERROR','Please locate firefox.exe')
$firefox = FileOpenDialog ("Locate Firefox Executable", @ProgramFilesDir & "\Mozilla Firefox","forefox executable (firefox.exe)",1+2)
$foxdirwrite = IniWrite(@ScriptDir & "\settings.ini", "settings", "foxdir", $firefox)
EndIf
#EndRegion
;==========================================================================================================
	#Region ;vars
$saved = FileExists (@ScriptDir & "\Saved")
$RegCheck = RegRead ("HKEY_CURRENT_USER\Software\Firefox loader","First_Run")
If $RegCheck = "" Then
RegWrite ("HKEY_CURRENT_USER\Software\Firefox loader", "First_Run", "REG_SZ", "1")
EndIf
$FirstRun = RegRead ("HKEY_CURRENT_USER\Software\Firefox loader","First_Run")
$saved = FileExists (@ScriptDir & "\Saved")
$OS = @OSVersion
$RoamingDir = (@UserProfileDir & "\AppData\Roaming\Mozilla\Firefox")
$LocalDir = (@UserProfileDir & "\AppData\Local\Mozilla\Firefox")
$localappdir = (@UserProfileDir & "\Local Settings\Application Data\Mozilla\Firefox")
$appdir = (@UserProfileDir & "\Application Data\Mozilla\Firefox")

$inicheck = FileExists ($RoamingDir)
$inicheckXP = FileExists ($appdir)
$runcheck = ProcessExists ("firefox.exe")

;$ini = (@AppDataDir & "\Mozilla\Firefox\profiles.ini")
;$profilename = IniRead ($ini, "Profile0", "Path", "")
$getRoaming = _FileListToArray ($RoamingDir & "\Profiles")
$profilename =  _ArrayToString ($getRoaming,@TAB,1)
$getapp = _FileListToArray ($appdir & "\Profiles")
$XPprofilename =  _ArrayToString ($getapp,@TAB,1)
 
$RoamingUser = ($RoamingDir & "\Profiles\" & $profilename)
$LocalUser = ($LocalDir & "\Profiles\" & $profilename)
$XPuser = ($appdir & "\Profiles\" & $profilename)
$XPLocalUser = ($localappdir & "\Profiles\" & $XPprofilename)

#EndRegion
;===================== remove cache Vista ===========================
$cache = ('"' & $LocalUser & '\Cache"')
RunWait (@ComSpec & ' /c RD /s/q ' & $cache,@ScriptDir,@SW_HIDE)
;===================== remove cache XP ==============================
$cacheXP = ('"' & $XPLocalUser & '\Cache"')
RunWait (@ComSpec & ' /c RD /s/q ' & $cacheXP,@ScriptDir,@SW_HIDE)
;==========================================================================================================
	#Region ;ini check
If $inicheck = 0 And  $runcheck = 0 And $OS = "WIN_VISTA" And $FirstRun = "1" Then ;restore function
	DirRemove ($RoamingDir,1)
	DirRemove ($LocalDir,1)
Restore()
ElseIf $inicheck = 1 And  $runcheck = 0 And $OS = "WIN_VISTA" And $FirstRun = "1" Then ;restore function
	DirRemove ($RoamingDir,1)
	DirRemove ($LocalDir,1)
Restore()
ElseIf $inicheck = 1 and $runcheck = 0 And $OS = "WIN_VISTA"  And $FirstRun = "1"  And $saved = 0 Then;backup
Backup()
ElseIf $inicheck = 1 and $runcheck = 0 And $OS = "WIN_VISTA"  And $FirstRun = "0"  And $saved = 0 Then;backup
Backup()
ElseIf $inicheck = 1 and $runcheck > 0 And $OS = "WIN_VISTA"  Then ;run firefox as another instance
RuninstanceFox()
;XP
ElseIf $inicheckXP = 0 And  $runcheck = 0 And $OS = "WIN_XP" And $FirstRun = "1" Then ;restore function
	DirRemove ($localappdir,1)
	DirRemove ($appdir,1)
Restore()
ElseIf $inicheckXP = 1 And  $runcheck = 0 And $OS = "WIN_XP" And $FirstRun = "1" Then ;restore function
	DirRemove ($localappdir,1)
	DirRemove ($appdir,1)
Restore()
ElseIf $inicheckXP = 1 and $runcheck = 0 And $OS = "WIN_XP"  And $FirstRun = "1" And $saved = 0 Then ;backup
Backup()
ElseIf $inicheckXP = 1 and $runcheck = 0 And $OS = "WIN_XP"  And $FirstRun = "0" And $saved = 0 Then ;backup
Backup()
ElseIf $inicheckXP = 1 and $runcheck > 0 And $OS = "WIN_XP"  Then ;run firefox as another instance
RuninstanceFox()
EndIf	
#EndRegion
;==========================================================================================================
	#Region ;Restore
Func Restore()
	If $OS = "WIN_VISTA" Then ;create folders and backup
	TrayTip ("Information","Restoring new Vista/W7 data only","",1)
 DirCreate ($LocalDir)
 DirCreate ($RoamingDir)
DirCreate (@ScriptDir & "\Saved\Local")
DirCreate (@ScriptDir & "\Saved\Roaming")
		RunWait (@ComSpec & ' /c xcopy /E/D/Y Saved\Local ' & $LocalDir, @ScriptDir,@SW_HIDE)
		RunWait (@ComSpec & ' /c xcopy /E/D/Y Saved\Roaming ' & $RoamingDir, @ScriptDir,@SW_HIDE)
	ElseIf $OS = "WIN_XP" Then
		TrayTip ("Information","Restoring new Vista/W7 data only","",1)
DirCreate ($localappdir)
DirCreate ($appdir)
DirCreate (@ScriptDir & "\Saved\Local")
DirCreate (@ScriptDir & "\Saved\Roaming")
		RunWait (@ComSpec & ' /c xcopy /E/D/Y "Saved\Local" "' & $localappdir & '"', @ScriptDir,@SW_HIDE)
		RunWait (@ComSpec & ' /c xcopy /E/D/Y Saved\Roaming "' & $appdir & '"', @ScriptDir,@SW_HIDE)
EndIf
EndFunc
#EndRegion
RunFox()
;==========================================================================================================
	#Region ;Backup
Func Backup()
If $OS = "WIN_VISTA" Then ;create folders and backup Vista
TrayTip ("Information","Saving new data","",1)
DirCreate (@UserProfileDir & "\AppData\Local\Mozilla\Firefox")
DirCreate (@UserProfileDir & "\AppData\Roaming\Mozilla\Firefox")
DirCreate (@ScriptDir & "\Saved\Local")
DirCreate (@ScriptDir & "\Saved\Roaming")
RunWait (@ComSpec & ' /c xcopy /E/D/Y ' & $LocalDir &' Saved\Local',@ScriptDir,@SW_HIDE)
RunWait (@ComSpec & ' /c xcopy /E/D/Y ' & $RoamingDir & ' Saved\Roaming',@ScriptDir,@SW_HIDE)
ElseIf $OS = "WIN_XP" Then ;create folders and backup XP
	TrayTip ("Information","Saving new data","",1)
DirCreate ($localappdir)
DirCreate ($appdir)
DirCreate (@ScriptDir & "\Saved\Local")
DirCreate (@ScriptDir & "\Saved\Roaming")
	RunWait (@ComSpec & ' /c xcopy /E/D/Y "' & $localappdir &'" "Saved\Local"',@ScriptDir,@SW_HIDE)
	RunWait (@ComSpec & ' /c xcopy /E/D/Y "' & $appdir & '" Saved\Roaming',@ScriptDir,@SW_HIDE)
EndIf
EndFunc
#EndRegion
;==========================================================================================================
RunFox()
;==========================================================================================================
	#Region ;RunFox
Func RunFox()
RegWrite ("HKEY_CURRENT_USER\Software\Firefox loader", "First_Run", "REG_SZ", "0")
	TrayTip ("Information","Loading Firefox",1,1)
	$foxdirread = IniRead (@ScriptDir & "\settings.ini", "settings", "foxdir", "")
RunWait ($foxdirread)
ProcessWaitClose ("firefox.exe")
If $OS = "WIN_VISTA" Then
	TrayTip ("Information","Saving new data","",1)
	RunWait (@ComSpec & ' /c RD /s/q ' & $cache,@ScriptDir,@SW_HIDE) ;clean up
DirCreate (@ScriptDir & "\Saved\Local")
DirCreate (@ScriptDir & "\Saved\Roaming")
RunWait (@ComSpec & ' /c xcopy /E/D/Y ' & $LocalDir &' Saved\Local',@ScriptDir,@SW_HIDE) ;backup
RunWait (@ComSpec & ' /c xcopy /E/D/Y ' & $RoamingDir & ' Saved\Roaming',@ScriptDir,@SW_HIDE) ;backup
ElseIf $OS = "WIN_XP" Then
	TrayTip ("Information","Saving new data","",1)
RunWait (@ComSpec & ' /c RD /s/q ' & $cacheXP,@ScriptDir,@SW_HIDE) ;Clean up
DirCreate (@ScriptDir & "\Saved\Local")
DirCreate (@ScriptDir & "\Saved\Roaming")
	RunWait (@ComSpec & ' /c xcopy /E/D/Y "' & $localappdir &'" "Saved\Local"',@ScriptDir,@SW_HIDE) ;backup
	RunWait (@ComSpec & ' /c xcopy /E/D/Y "' & $appdir & '" Saved\Roaming',@ScriptDir,@SW_HIDE) ;backup
EndIf
exit
EndFunc
;==========================================================================================================
Func RuninstanceFox()
	$foxdirread = IniRead (@ScriptDir & "\settings.ini", "settings", "foxdir", "")
	Run ($foxdirread)
	exit
	EndFunc
#EndRegion
;==========================================================================================================