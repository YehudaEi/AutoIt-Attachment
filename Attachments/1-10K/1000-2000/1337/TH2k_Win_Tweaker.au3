#region Description
; AutoIt Version: 3.1
; Language:	English
; Platform:	Win NT
; Author:		CodeJUnkie <parsons151185@hotmail.com>
#endregion Description


#Region Globle_Variables

$iniFileName = "cust_winnt.ini"
$iniFileLoc = @ScriptDir & "\"
$logging = "1"
$EndSummary = "0"
$LogFile = "-1"
$Ver = "1.1005beta1"
$DateTime = @Hour &"-"& @Min &"-"& @SEC & " " & @Mday &"-"& @Mon &"-"& @Year
$CriticalErrors ="0"
$Operations = "0"
$LogFileName = "TH2k WinNT Tweaker - v" & $Ver & ".log"
$LogFileLoc = @TempDir & "\"
$Error_Messages = "0"
$current_user_only = "0"
$Commands = "0"
$CurrentWindows = "Error Windows Not Detected"
$NotImplomented = 0

#EndRegion Globle_Variables

#Region Script_Starter
; ----------------------------------------------------------------------------
StartDebug()
StartLogging()
Main()
Test()
StopLogging()
Windows()
#EndRegion Script_Starter


#region Start Tweaker Debugging

  Func StartDebug()
    If Read_ini("tweaker_debug","datetime_log_file") = 1 Then $LogFileName = "TH2k Tweaker - v" & $Ver & " - " & $DateTime & ".log"
    If Read_ini("tweaker_debug","log_on_desktop") = 1 Then $LogFileLoc = @DesktopCommonDir & "\"
    If Read_ini("tweaker_debug","end_summary") = 1 Then $EndSummary = 1
    If Read_ini("tweaker_debug","create_log ") = 0 Then $logging = 0
    If Read_ini("Tweaker_debug","error_messages") = 1 Then $error_messages = 1
    If Read_ini("Tweaker_debug","current_user_only") = 1 then $current_user_only = 1
  EndFunc
  
#Endregion Start Tweaker Debugging


#region Apply Tweaks
  Func Main()
     Notepad_Status(Read_ini("windows","notepad_status"))
     DesktopDraw_WinVer(Read_ini("desktop","paintdesktopversion"))
  EndFunc


  Func Test()
     WinAutoEndTask(Read_ini("desktop","autoendtasks"))
     IE_StartPage(Read_ini("ie","start_page"))
     StartMenuDelay(Read_ini("windows","showmenudelay")) 
     ShortcutArrows(Read_ini("windows","shortcut_arrows"))
     MyComputer_SharedDocuments(Read_ini("my_computer","shared_docs"))
     WinTourBubble(Read_ini("windows","tour_bubble"))
     DesktopCleanup(Read_ini("desktop","desktop_clean"))
     WinPictureAndFax_Viewer(Read_ini("windows","picture_fax_viewer"))
     WinControlPanel(Read_ini("windows","classic_control_panel"))
     Logon_Type(Read_ini("windows","logon_type"))
     IndexService(Read_ini("services","indexing"))
     Win_Messanger(Read_ini("services","Win_Messanger"))
     Win_Time(Read_ini("services","win_time"))
     Universal_PnP(Read_ini("services","universal_pnp"))
     AutoRestart_On_BSOD(Read_ini("windows","bsod_autorestart"))
     ErrorReporter(Read_ini("windows","error_reports"))
     MSI_Installer_Rollback(Read_ini("windows","ms_installer_rollback"))
     MS_SC_Firewall_Watch(Read_ini("security_center","firewall_watch"))
     MS_SC_First_Run(Read_ini("security_center","first_run"))
     MS_SC_Disable_All(Read_ini("security_center","disable_all"))
     MS_SC_AntiVirus_Watch(Read_ini("security_center","antivirus_watch"))
     MS_SC_WinUpdate_Watch(Read_ini("security_center","win_update_watch"))
     IE_HistoryDays(Read_ini("ie","history_days"))
     IE_File_StatusBar(Read_ini("windows","statusbar"))
     IE_web_StatusBar(Read_ini("ie","statusbar"))
     Internet_Connection_Wizard(Read_ini("ie","connection_wiz"))
     Reverse_Mouse(Read_ini("windows","reverse_mouse"))
     unix_x_mouse(Read_ini("windows","x-mouse"))
     Hide_Drives_Local(Read_ini("my_computer","hidedrives_local"))
     Hide_Drives_CUrrentUser(Read_ini("my_computer","hidedrives_currentuser"))
     Deny_Access_To_Local(Read_ini("my_computer","denydrive_local"))
     Deny_Access_To_CurrentUser(Read_ini("my_computer","denydrive_currrentuser"))
     Remote_Desktop(Read_ini("windows","remote_desktop"))
     System_Restore(Read_ini("windows","system_retore"))
     TaskBar_Hide_Inactive_Icons(Read_ini("windows","hide_inactive_icons"))
     NumLock(Read_ini("windows","num_lock"))
     FontSmoothing(Read_ini("windows","fontsmoothing"))
     MyComp_Services(Read_ini("my_computer_rightclick","services"))
     MyComp_ControlPanel(Read_ini("my_computer_rightclick","control_panel"))
     MyComp_AddRemove(Read_ini("my_computer_rightclick","add_remove"))
     MyComp_Logoff(Read_ini("my_computer_rightclick","logoff"))
     MyComp_Restart(Read_ini("my_computer_rightclick","restart"))
     MyComp_Shutdown(Read_ini("my_computer_rightclick","shutdown"))
     MyComp_DeviceMan(Read_ini("my_computer_rightclick","device_man"))
     MyComp_DriveClean(Read_ini("my_computer_rightclick","drive_clean"))
     FS_UnknownFiles_In_Notepad(Read_ini("file_system","unknown_files_in_notepad"))
     FS_DLL_Registration(Read_ini("file_system","dll_registration"))
     FS_OCX_Registration(Read_ini("file_system","ocx_registration"))
     MyComp_CloseDVDTray(Read_ini("my_computer","close_optical_drive_tray"))
     Windows_QuickReboot(Read_ini("windows","quick_reboot"))
     Windows_NoInternetOpenWith(Read_ini("windows","no_internet_open_with"))
     Windows_NoPageFiles(Read_ini("windows","disable_page_files"))
     Windows_SystemCache(Read_ini("windows","system_cache"))
     Windows_Auto_BootOptize(Read_ini("windows","auto_boot_optimize"))
     FS_NTFS_LastAccessUpdate(Read_ini("file_system","ntfs_last_access_update"))
     FS_NTFS_8_3_Name_Creation(Read_ini("file_system","ntfs_8_3_name_creation"))
     FS_RecycleBin(Read_ini("file_system","recycle_bin"))
     Desktop_RemoteConnecton(Read_ini("desktop","allow_remote_connection"))
     Desktop_ShutdownReasonUI(Read_ini("desktop","shutdown_reason_ui"))
     Networking_LogoffSync(Read_ini("networking","Logoff_Sync"))
     Networking_ForceGuested(Read_ini("networking","force_guest"))
     DevMgr_ShowNonpressent_Devices(Read_ini("device_manager","show_nonpressent_devices"))
     DevMgr_ShowDetails(Read_ini("device_manager","show_details"))
     Windows_DriverSearch(Read_ini("windows","web_driver_search"))
     Windows_Prefetcher(Read_ini("windows","prefetcher"))
     Windows_ReportBootOk(Read_ini("windows","report_boot_ok"))
     ;Network_DefaultHiddenShares(Read_ini("networking","default_hidden_shares"))
     Network_Throughput(Read_ini("networking","net_throughput"))
     IE_AutoImageResize(Read_ini("ie","auto_image_resize"))
     Windows_PasswordOnResume(Read_ini("windows","password_on_resume"))
  EndFunc
#endregion Apply Tweaks
#region Beta Tweakers Undo capabilitys

Func StartMenuDelay($delay)
  If $delay < 500 Then
    If $delay <> "-1" then
      TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","MenuShowDelay","REG_SZ",$delay)
    EndIf
  EndIf
EndFunc

Func Movie_Previews($MoviePreviews)
   If $MoviePreviews = 0 then
     TweakerRegDeleteKey("HKEY_CLASSES_ROOT\.avi\ShellEx")
     TweakerRegDeleteKey("HKEY_CLASSES_ROOT\.mpg\ShellEx")
     TweakerRegDeleteKey("HKEY_CLASSES_ROOT\.mpe\ShellEx")
     TweakerRegDeleteKey("HKEY_CLASSES_ROOT\.mpeg\ShellEx")
   EndIf
EndFunc

Func DesktopCleanup($DesktopClean)
   If $DesktopClean = 0 then 
     TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz","NoRun","REG_DWORD","1")
   EndIf
EndFunc

Func WinTourBubble($WinTourBoubble)
   If $WinTourBoubble = 0 then TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Applets\Tour","RunCount","REG_DWORD","0")
EndFunc

Func IndexService($IndexService)
   If $IndexService = 0 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cisvc","Start","REG_DWORD","4")
EndFunc

Func Win_Messanger($Win_Messanger)
   If $Win_Messanger = 0 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Messenger","Start","REG_DWORD","4")
EndFunc

Func MS_SC_Disable_All($Disable_SC)
  If $Disable_SC = 1 Then
     MS_SC_First_Run("0")
     MS_SC_WinUpdate_Watch("0")
     MS_SC_AntiVirus_Watch("0")
     MS_SC_Firewall_Watch("0")
  EndIf
  If $Disable_SC = 0 Then
    FileWriteLine($LogFile, "ERROR - Windows Security Center disable all does not have an undo option")
    $CriticalErrors = $CriticalErrors + 1
  EndIf
EndFunc

Func Internet_Connection_Wizard($ConnWiz)
  If $ConnWiz = 0 Then
    TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Connection Wizard","Completed","REG_BINARY","01000000")
  EndIf
  ;-------Need Hex Value-------If $ConnWiz = 1 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Connection Wizard","Completed","REG_BINARY","01000000")
EndFunc

#endregion Beta Tweakers Undo capabilitys



#region Beta Tweaks Almost completed just not confirmed to be working


  
#region Windows Tweaker

#endregion Windows Tweaker


  #region Internet Explorer Tweaks
Func IE_AutoImageResize($IE_AutoImageResize)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "13/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Internet Explorer - Auto Image Resize"
 $TweakSection = "ie"
 $TweakKey = "auto_image_resize"
  Select
  Case $IE_AutoImageResize = 1
	  TweakerRegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main","Enable AutoImageResize","REG_SZ","yes")
     Case $IE_AutoImageResize = 0
	  TweakerRegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main","Enable AutoImageResize","REG_SZ","no")
    Case $IE_AutoImageResize = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc
#endregion Internet Explorer Tweaks


  #region Services Tweaks
Func Universal_PnP($UPnP)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "N/A - B4 v1.1005"
 $TweakFirstImplomented = "N/A - B4 v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Services - Universal_PnP"
 $TweakSection = "services"
 $TweakKey = "universal_pnp"
  Select
    Case $UPnP = 0
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SSDPSRV","Start","REG_DWORD","4")
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\upnphost","Start","REG_DWORD","4")
    Case $UPnP = 1
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SSDPSRV","Start","REG_DWORD","2")
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\upnphost","Start","REG_DWORD","2")
    Case $UPnP = -1
;-------MUST UPDATE NotImplomented Logging-------
;-----Include TweakName & Version! New Func!-----
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc
Func Win_Time($TimeService)
   If $TimeService = 0 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time","Start","REG_DWORD","4")
   If $TimeService = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time","Start","REG_DWORD","2")
EndFunc
#endregion Services Tweaks
  #region My Computer
#endregion My Computer


Func Logon_Type($LoginType)
   Select
      Case $LoginType = "clasic"
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","LogonType","REG_DWORD","0")
        TweakerRegDeleteName("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","Background")
      Case $LoginType = "welcome_only"
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","LogonType","REG_DWORD","1")
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","AllowMultipleTSSessions","REG_DWORD","0")
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","Background","REG_SZ","0 0 0")
      Case $LoginType = "welcome_fast_switch"
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","LogonType","REG_DWORD","1")
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","AllowMultipleTSSessions","REG_DWORD","1")
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","Background","REG_SZ","0 0 0")
   EndSelect
EndFunc

Func WinControlPanel($ControlPanel)
   if $ControlPanel = 1 then
     TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","ForceClassicControlPanel","REG_DWORD","1")
   EndIf
   if $ControlPanel = 0 then
     TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","ForceClassicControlPanel","REG_DWORD","0")
   EndIf
EndFunc

Func WinPictureAndFax_Viewer($P_F_Viewer)
   If $P_F_Viewer = 0 Then TweakerRegDeleteKey("HKEY_CLASSES_ROOT\SystemFileAssociations\image\ShellEx\ContextMenuHandlers\ShellImagePreview")
   If $P_F_Viewer = 1 Then TweakerRegWrite("HKEY_CLASSES_ROOT\SystemFileAssociations\image\ShellEx\ContextMenuHandlers\ShellImagePreview","","REG_SZ","{e84fda7c-1d6a-45f6-b725-cb260c236066}")
EndFunc

Func MyComputer_SharedDocuments($Shared_Docs)
   if $Shared_Docs = 0 then 
     TweakerRegDeleteKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{59031a47-3f72-44a7-89c5-5595fe6b30ee}")
     TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoSharedDocuments","REG_DWORD","1")
     TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoSharedDocuments","REG_dword","1")
   EndIf
   if $Shared_Docs = 1 then
     TweakerRegDeleteKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{59031a47-3f72-44a7-89c5-5595fe6b30ee}")
     TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoSharedDocuments","REG_DWORD","0")
     TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoSharedDocuments","REG_dword","0")
   EndIf
EndFunc

Func ShortcutArrows($ShortcutArrows)
  if $ShortcutArrows = 0 then TweakerRegDeleteName("HKEY_CLASSES_ROOT\lnkfile","IsShortcut")
  If $ShortcutArrows = 1 then TweakerRegWrite("HKEY_CLASSES_ROOT\lnkfile","IsShortcut","REG_SZ","")
EndFunc

Func IE_StartPage($StartPage)
  If $StartPage <> "-1" then 
    TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","Start Page","REG_SZ",$StartPage) 
  EndIf
EndFunc

Func WinAutoEndTask($AutoEndTasks)
  If $AutoEndTasks = 1 then 
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","AutoEndTasks","REG_SZ","1")
  EndIf
  If $AutoEndTasks = 0 then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","AutoEndTasks","REG_SZ","0")
  EndIf
EndFunc

Func ScreenSaverActive($SaverActive)
     If $SaverActive = 1 then TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "ScreenSaveActive", "REG_SZ","1")
     If $SaverActive = 0 then TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "ScreenSaveActive", "REG_SZ","0")
EndFunc

Func DesktopDraw_WinVer($WinVerDraw)
     If $WinVerDraw = 1 then TweakerRegWrite( "HKEY_CURRENT_USER\Control Panel\Desktop", "PaintDesktopVersion", "REG_DWORD","1" )
     If $WinVerDraw = 0 then TweakerRegWrite( "HKEY_CURRENT_USER\Control Panel\Desktop", "PaintDesktopVersion", "REG_DWORD","0" )
EndFunc

Func AutoRestart_On_BSOD($RestartOnBSOD)
  If $RestartOnBSOD = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl","AutoReboot","REG_dword","0")
  If $RestartOnBSOD = 0 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl","AutoReboot","REG_dword","1")
EndFunc

Func ErrorReporter($ReportErrors)
  If $ReportErrors = 1 Then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","DoReport","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","ShowUI","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","IncludeKernelFaults","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","IncludeMicrosoftApps","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","IncludeWindowsApps","REG_DWORD","0")
  EndIf
  If $ReportErrors = 0 Then 
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","DoReport","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","ShowUI","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","IncludeKernelFaults","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","IncludeMicrosoftApps","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting","IncludeWindowsApps","REG_DWORD","0")
  EndIf
EndFunc

Func MS_SC_Firewall_Watch($Firewall_Watch)
  If $Firewall_Watch = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirewallOverride","REG_DWORD","1")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirewallDisableNotify","REG_DWORD","1")
  EndIf
  If $Firewall_Watch = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirewallOverride","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirewallDisableNotify","REG_DWORD","0")
  EndIf
EndFunc

Func MS_SC_First_Run($SC_FirstRun)
 ;TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirstRunDisabled","REG_DWORD","1")
  If $SC_FirstRun = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirstRunDisabled","REG_DWORD","0")
  If $SC_FirstRun = 0 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","FirstRunDisabled","REG_DWORD","1")
EndFunc

Func MS_SC_AntiVirus_Watch($antivirus_watch)
  If $antivirus_watch = 1 Then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","AntiVirusDisableNotify","REG_DWORD","1")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","AntiVirusOverride","REG_DWORD","1")
  EndIf
  If $antivirus_watch = 0 Then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","AntiVirusDisableNotify","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","AntiVirusOverride","REG_DWORD","0")
  EndIf
EndFunc

Func MS_SC_WinUpdate_Watch($Win_Update_Watch)
  If $Win_Update_Watch = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","UpdatesDisableNotify","REG_DWORD","0")
  If $Win_Update_Watch = 0 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security Center","UpdatesDisableNotify","REG_DWORD","1")
EndFunc

Func MSI_Installer_Rollback($RollBack)
  If $RollBack = 0 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer","DisableRollback","REG_dword","1")
  If $RollBack = 1 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer","DisableRollback","REG_dword","0")
EndFunc

Func IE_HistoryDays($HistoryDays)
  If IsNumber($HistoryDays) = 1 then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Url History","DaysToKeep","REG_DWORD",Hex($HistoryDays,"8"))
EndFunc

Func IE_web_StatusBar($IE_WebStatsBar)
  If $IE_WebStatsBar = 1 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","StatusBarWeb","REG_dword","1")
  If $IE_WebStatsBar = 0 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","StatusBarWeb","REG_dword","0")
EndFunc

Func IE_File_StatusBar($IE_FileStatsBar)
  If $IE_FileStatsBar = 1 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","StatusBarOther","REG_dword","1")
  If $IE_FileStatsBar = 0 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","StatusBarOther","REG_dword","0")
EndFunc

Func Reverse_Mouse($ReverseMouse)
  If $ReverseMouse = 1 Then TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Mouse","SwapMouseButtons","REG_SZ","1")
  If $ReverseMouse = 0 Then TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Mouse","SwapMouseButtons","REG_SZ","0")
EndFunc

Func unix_x_mouse($x_mouse)
  If $x_mouse = 1 Then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","UserPreferencesMask","REG_BINARY","ff3e0000")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Mouse","ActiveWindowTracking","REG_dword","1")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","ActiveWndTrkTimeout","REG_dword","3000")
  EndIf
  If $x_mouse = 0 Then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","UserPreferencesMask","REG_BINARY","1e2c0580")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Mouse","ActiveWindowTracking","REG_dword","0")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","ActiveWndTrkTimeout","REG_dword","0")
  EndIf
EndFunc

Func Hide_Drives_Local($HideDriveLocal)
  If IsNumber($HideDriveLocal) = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoDrives","REG_dword",$HideDriveLocal)
EndFunc

Func Hide_Drives_CUrrentUser($HideDriveCurrentUser)
  If IsNumber($HideDriveCurrentUser) = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoDrives","REG_dword",$HideDriveCurrentUser)
EndFunc

Func Deny_Access_To_CurrentUser($DenyDriveCurrentUser)
  If IsNumber($DenyDriveCurrentUser) = 1 Then TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoViewOnDrive","REG_dword",$DenyDriveCurrentUser)
EndFunc

Func Deny_Access_To_Local($DenyDriveLocal)
  If IsNumber($DenyDriveLocal) = 1 Then TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer","NoViewOnDrive","REG_dword",$DenyDriveLocal)
EndFunc

Func Remote_Desktop($Remote_Desktop)
  If $Remote_Desktop = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server","AllowTSConnections","REG_dword","1")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server","fDenyTSConnections","REG_dword","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server","fAllowToGetHelp","REG_dword","1")
  EndIf
  If $Remote_Desktop = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server","AllowTSConnections","REG_dword","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server","fDenyTSConnections","REG_dword","1")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server","fAllowToGetHelp","REG_dword","0")
  EndIf
EndFunc

Func System_Restore($SystemRestore)
  If $SystemRestore = 1 Then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore","DisableConfig","REG_DWORD","1")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore","DisableSR","REG_DWORD","1")
  EndIf
  If $SystemRestore = 0 Then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore","DisableConfig","REG_DWORD","0")
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore","DisableSR","REG_DWORD","0")
  EndIf
EndFunc

Func TaskBar_Hide_Inactive_Icons($TaskBar_Icon_Hide)
  If $TaskBar_Icon_Hide = 0 Then 
    TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer","EnableAutoTray","REG_dword","0")
    TweakerRegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer","EnableAutoTray","REG_dword","0")
  EndIf
  If $TaskBar_Icon_Hide = 1 Then 
    TweakerRegDeleteName("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer","EnableAutoTray")
    TweakerRegDeleteName("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer","EnableAutoTray")
  EndIf
EndFunc

Func NumLock($NumLock)
  If $NumLock = 0 Then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Keyboard","InitialKeyboardIndicators","REG_SZ","0")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Keyboard","InitialKeyboardIndicators","REG_SZ","0")
  EndIf
  If $NumLock = 1 Then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Keyboard","InitialKeyboardIndicators","REG_SZ","1")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Keyboard","InitialKeyboardIndicators","REG_SZ","1")
  EndIf
EndFunc

Func FontSmoothing($Smoothing)
  If $Smoothing = 1 then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","FontSmoothing","REG_SZ","2")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","FontSmoothingType","REG_DWORD","2")
  EndIf
  If $Smoothing = 0 then
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","FontSmoothing","REG_SZ","0")
    TweakerRegWrite("HKEY_CURRENT_USER\Control Panel\Desktop","FontSmoothingType","REG_DWORD","1")
  EndIf
EndFunc

Func MyComp_Services($MyComp_Services)
  If $MyComp_Services = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services","","REG_EXPAND_SZ","Services")
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services","SuppressionPolicy","REG_DWORD","4000003c")
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services\command","","REG_EXPAND_SZ","%windir%\system32\mmc.exe /s %SystemRoot%\system32\services.msc /s")
  EndIf
  If $MyComp_Services = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services")
  EndIf
EndFunc

Func MyComp_ControlPanel($MyComp_CP)
  If $MyComp_CP = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Control Panel\command","","REG_EXPAND_SZ","rundll32.exe shell32.dll,Control_RunDLL")
  EndIf
  If $MyComp_CP = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services")
  EndIf
EndFunc

Func MyComp_AddRemove($MyComp_AddRem)
  If $MyComp_AddRem = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Add/Remove\command","","REG_EXPAND_SZ","control appwiz.cpl")
  EndIf
  If $MyComp_AddRem = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Add/Remove")
  EndIf
EndFunc

Func MyComp_Logoff($MyComp_RC_Logoff)
  If $MyComp_RC_Logoff = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\LogOff\command","","REG_EXPAND_SZ","shutdown -l -f -t 5")
  EndIf
  If $MyComp_RC_Logoff = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\LogOff")
  EndIf
EndFunc

Func MyComp_Restart($MyComp_Restart)
  If $MyComp_Restart = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Reboot\command","","REG_EXPAND_SZ","shutdown -r -f -t 5")  
  EndIf
  If $MyComp_Restart = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Reboot")
  EndIf
EndFunc

Func MyComp_Shutdown($MyComp_Shutdown)
If $MyComp_Shutdown = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Shutdown\command","","REG_EXPAND_SZ","shutdown -s -f -t 5")
  EndIf
  If $MyComp_Shutdown = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Shutdown")
  EndIf
EndFunc

Func MyComp_DeviceMan($MyComp_DevMan)
  If $MyComp_DevMan = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Devices","","REG_EXPAND_SZ","Device Manager")
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Devices","SuppressionPolicy","REG_DWORD","4000003c")
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Devices\command","","REG_EXPAND_SZ","%windir%\system32\mmc.exe /s %SystemRoot%\system32\devmgmt.msc /s")  
  EndIf
  If $MyComp_DevMan = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Devices")
  EndIf
EndFunc

Func MyComp_DriveClean($MyComp_DriveClean)
  If $MyComp_DriveClean = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Drive Cleanup\command","","REG_EXPAND_SZ","cleanmgr")  
  EndIf
  If $MyComp_DriveClean = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Drive Cleanup")
  EndIf
EndFunc

Func FS_UnknownFiles_In_Notepad($UnknownFilesInNotepad)
  If $UnknownFilesInNotepad = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\*\shell","","REG_SZ","notepad.exe ""%1""")
    TweakerRegWrite("HKEY_CLASSES_ROOT\*\shell\open","","REG_SZ","Open &With Notepad")
    TweakerRegWrite("HKEY_CLASSES_ROOT\*\shell\open\command","","REG_SZ","notepad.exe ""%1""")
  EndIf
  If $UnknownFilesInNotepad = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\*\shell")
  EndIf

EndFunc

Func FS_DLL_Registration($FS_DLL_Registration)
If $FS_DLL_Registration = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\dllfile\Shell\Register\command","","REG_SZ","regsvr32.exe ""%1""")
    TweakerRegWrite("HKEY_CLASSES_ROOT\dllfile\Shell\UnRegister\command","","REG_SZ","regsvr32.exe /u ""%1""")
  EndIf
  If $FS_DLL_Registration = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\dllfile\Shell\Register")
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\dllfile\Shell\UnRegister")
  EndIf
EndFunc

Func FS_OCX_Registration($FS_OCX_Registration)
  If $FS_OCX_Registration = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\ocxfile\Shell\Register\command","","REG_SZ","regsvr32.exe ""%1""")
    TweakerRegWrite("HKEY_CLASSES_ROOT\ocxfile\Shell\UnRegister\command","","REG_SZ","regsvr32.exe /u ""%1""")
  EndIf
  If $FS_OCX_Registration = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\ocxfile\Shell\Register")
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\ocxfile\Shell\UnRegister")
  EndIf
EndFunc

Func MyComp_CloseDVDTray($MyComp_CloseDVDTray)
 If FileExists(@SystemDir & "\cdr.exe") then
  If $MyComp_CloseDVDTray = 1 then
    TweakerRegWrite("HKEY_CLASSES_ROOT\Drive\shell\draw","","REG_SZ","Close CD-&tray")
    TweakerRegWrite("HKEY_CLASSES_ROOT\Drive\shell\draw\command","","REG_SZ","cdr.exe close ALL")
  EndIf
  If $MyComp_CloseDVDTray = 0 then
    TweakerRegDeleteKey("HKEY_CLASSES_ROOT\Drive\shell\draw")
  EndIf
 Else
  If $Error_Messages = 1 then MsgBox(4096,"", @systemdir & "\cdr.exe does not exist.")
 EndIf
EndFunc

Func Windows_QuickReboot($Windows_QuickReboot)
  If $Windows_QuickReboot = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","EnableQuickReboot","REG_SZ","1")
  EndIf
  If $Windows_QuickReboot = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","EnableQuickReboot","REG_SZ","0")
  EndIf
EndFunc

Func FS_NTFS_LastAccessUpdate($FS_NTFS_LastAccessUpdate)
  If $FS_NTFS_LastAccessUpdate = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Filesystem","NtfsDisableLastAccessUpdate","REG_DWORD","0")
  EndIf
  If $FS_NTFS_LastAccessUpdate = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Filesystem","NtfsDisableLastAccessUpdate","REG_DWORD","1")
  EndIf
EndFunc

Func FS_NTFS_8_3_Name_Creation($FS_NTFS_8_3_Name_Creation)
  If $FS_NTFS_8_3_Name_Creation = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Filesystem","NtfsDisable8dot3NameCreation","REG_DWORD","0")
  EndIf
  If $FS_NTFS_8_3_Name_Creation = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Filesystem","NtfsDisable8dot3NameCreation","REG_DWORD","1")
  EndIf
EndFunc

Func Desktop_ShutdownReasonUI($Desktop_ShutdownReasonUI)
  If $Desktop_ShutdownReasonUI = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability","ShutdownReasonUI","REG_DWORD","1")
  EndIf
  If $Desktop_ShutdownReasonUI = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability","ShutdownReasonUI","REG_DWORD","0")
  EndIf
EndFunc

Func Desktop_RemoteConnecton($Desktop_RemoteConnecton)
  If $Desktop_RemoteConnecton = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole","EnableRemoteConnect","REG_SZ","Y")
  EndIf
  If $Desktop_RemoteConnecton = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole","EnableRemoteConnect","REG_SZ","N")
  EndIf
EndFunc

Func Windows_NoInternetOpenWith($Windows_NoInternetOpenWith)
  If $Windows_NoInternetOpenWith = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System","NoInternetOpenWith","REG_dword","1")
  EndIf
  If $Windows_NoInternetOpenWith = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System","NoInternetOpenWith","REG_dword","0")
  EndIf
EndFunc

Func Windows_NoPageFiles($Windows_NoPageFiles)
  If $Windows_NoPageFiles = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management","DisablePagingExecutive","REG_DWORD","1")
  EndIf
  If $Windows_NoPageFiles = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management","DisablePagingExecutive","REG_DWORD","0")
  EndIf
EndFunc

Func Windows_SystemCache($Windows_SystemCache)
   Select
      Case $Windows_SystemCache = "desktop"
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management","LargeSystemCache","REG_DWORD","0")
      Case $Windows_SystemCache = "server"
        TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management","LargeSystemCache","REG_DWORD","1")
   EndSelect
EndFunc

Func Windows_Auto_BootOptize($Windows_Auto_BootOptize)
  If $Windows_Auto_BootOptize = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction","Enable","REG_SZ","Y")
  EndIf
  If $Windows_Auto_BootOptize = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction","Enable","REG_SZ","N")
  EndIf
EndFunc

Func Networking_LogoffSync($Networking_LogoffSync)
   Select
      Case $Networking_LogoffSync = "quick"
        TweakerRegWrite("HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\NetCache","SyncAtLogoff","REG_DWORD","0")
      Case $Networking_LogoffSync = "full"
        TweakerRegWrite("HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\NetCache","SyncAtLogoff","REG_DWORD","1")
   EndSelect
EndFunc

Func FS_RecycleBin($FS_RecycleBin)
  If $FS_RecycleBin = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\BitBucket","NukeOnDelete","REG_DWORD","0")
  EndIf
  If $FS_RecycleBin = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\BitBucket","NukeOnDelete","REG_DWORD","1")
  EndIf
EndFunc

Func Networking_ForceGuested($Networking_ForceGuested)
  If $Networking_ForceGuested = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa","ForceGuest","REG_DWORD","1")
  EndIf
  If $Networking_ForceGuested = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa","ForceGuest","REG_DWORD","0")
  EndIf
EndFunc

Func DevMgr_ShowNonpressent_Devices($DevMgr_ShowNonpressent_Devices)
  If $DevMgr_ShowNonpressent_Devices = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment","DEVMGR_SHOW_NONPRESENT_DEVICES","REG_SZ","1")
  EndIf
  If $DevMgr_ShowNonpressent_Devices = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment","DEVMGR_SHOW_NONPRESENT_DEVICES","REG_SZ","0")
  EndIf
EndFunc

Func DevMgr_ShowDetails($DevMgr_ShowDetails)
  If $DevMgr_ShowDetails = 1 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment","DEVMGR_SHOW_DETAILS","REG_SZ","1")
  EndIf
  If $DevMgr_ShowDetails = 0 then
    TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment","DEVMGR_SHOW_DETAILS","REG_SZ","0")
  EndIf
EndFunc

Func Network_DefaultHiddenShares($Network_DefaultHiddenShares)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "13/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Networking - Default Hidden Shares"
 $TweakSection = "networking"
 $TweakKey = "default_hidden_shares"
  Select
    Case $Network_DefaultHiddenShares = 1
	  TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\parameters","AutoShareWks","REG_dword","1")
	  TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\parameters","AutoShareServer","REG_dword","1")
    Case $Network_DefaultHiddenShares = 0
	  TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\parameters","AutoShareWks","REG_dword","0")
	  TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\parameters","AutoShareServer","REG_dword","0")
    Case $Network_DefaultHiddenShares = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc

Func Windows_DriverSearch($Windows_DriverSearch)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "07/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Windows - Web Driver Search"
 $TweakSection = "windows"
 $TweakKey = "web_driver_search"
  Select
    Case $Windows_DriverSearch = 1
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching","DontSearchWindowsUpdate","REG_dword","0")
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching","DontPromptForWindowsUpdate","REG_dword","0")
    Case $Windows_DriverSearch = 0
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching","DontSearchWindowsUpdate","REG_dword","1")
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching","DontPromptForWindowsUpdate","REG_dword","1")
    Case $Windows_DriverSearch = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc

Func Windows_Prefetcher($Windows_Prefetcher)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "07/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Windows - Prefetcher"
 $TweakSection = "windows"
 $TweakKey = "prefetcher"
  Select
    Case $Windows_Prefetcher = "boot_only"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters","EnablePrefetcher","REG_DWORD","2")
    Case $Windows_Prefetcher = "disabled"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters","EnablePrefetcher","REG_DWORD","0")
    Case $Windows_Prefetcher = "app_launch_only"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters","EnablePrefetcher","REG_DWORD","1")
    Case $Windows_Prefetcher = "both"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters","EnablePrefetcher","REG_DWORD","3")
    Case $Windows_Prefetcher = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc

Func Windows_ReportBootOk($Windows_ReportBootOk)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "07/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Windows - Report Boot Ok"
 $TweakSection = "windows"
 $TweakKey = "report_boot_ok"
  Select
    Case $Windows_ReportBootOk = 1
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","ReportBootOk","REG_SZ","0")
    Case $Windows_ReportBootOk = 0
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","ReportBootOk","REG_SZ","0")
    Case $Windows_ReportBootOk = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc

Func Network_Throughput($Network_NetThroughput)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "07/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Networking - Network_Throughput"
 $TweakSection = "networking"
 $TweakKey = "web_driver_search"
  Select
    Case $Network_NetThroughput = "max_net"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters","Size","REG_DWORD","3")
    Case $Network_NetThroughput = "min_mem"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters","Size","REG_DWORD","1")
    Case $Network_NetThroughput = "balance"
      TweakerRegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters","Size","REG_DWORD","2")
    Case $Network_NetThroughput = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc

Func Windows_PasswordOnResume($Windows_PasswordOnResume)
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "13/Feb/05"
 $TweakFirstImplomented = "v1.1005"
 $TweakVer = "v1.00"
 $TweakName = "Windows - Password on Resume"
 $TweakSection = "windows"
 $TweakKey = "password_on_resume"
  Select
  Case $Windows_PasswordOnResume = 1
      TweakerRegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System\Power","PromptPasswordOnResume","REG_dword","1")
	  if $current_user_only = 0 then TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System\Power","PromptPasswordOnResume","REG_dword","1")
  Case $Windows_PasswordOnResume = 0
	  TweakerRegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System\Power","PromptPasswordOnResume","REG_dword","0")
	  if $current_user_only = 0 then TweakerRegWrite("HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System\Power","PromptPasswordOnResume","REG_dword","0")
    Case $Windows_PasswordOnResume = -1
      $NotImplomented = $NotImplomented + 1
    Case Else
      $NotImplomented = $NotImplomented + 1
  EndSelect
EndFunc

#endregion Beta Tweaks Almost completed just not confirmed to be working


#region Complete Tweaks

Func Notepad_Status($Notepad_StatBar)
     If $Notepad_StatBar = 1 then TweakerRegWrite( "HKEY_CURRENT_USER\Software\Microsoft\Notepad" ,"StatusBar", "REG_DWORD","1" )
     If $Notepad_StatBar = 0 then TweakerRegWrite( "HKEY_CURRENT_USER\Software\Microsoft\Notepad" ,"StatusBar", "REG_DWORD","0" )
EndFunc

#Endregion Complete Tweaks


#region Common Functions

Func ErrorBox($Type,$Title,$Message)
  If $Error_Messages = 1 Then ErrorBox($Type,$Title,$Message)
EndFunc

Func Windows()
  $CurrentWindows = @OSVersion & " - " & @OSServicePack & " - Build " & @OSBuild
EndFunc

Func StartLogging()
   if $logging = 1 then
      $LogFile = FileOpen($LogFileLoc & $LogFileName, 1)
      ; Check if file opened for reading OK
      If $LogFile = -1 Then
         ErrorBox(0, "Error", "Unable to open file.")
         $logging="0"
       EndIf
   EndIf
EndFunc

Func Read_ini($Section,$Key)
     $Commands = $Commands + 1
     Return IniRead($iniFileLoc & $iniFileName, $Section,$Key, "-1")
EndFunc

Func TweakerRegWrite($Key,$Name,$Type,$Value)
   $FuncVer = "v1.00"
   $CurrentVal = RegRead($Key,$Name)
   $RegWriteComplete = RegWrite($Key,$Name,$Type,$Value)
   ;--Logging Of TweakerRegWrite
   Select
       Case $CurrentVal <> ""
           FileWriteLine($LogFile, "[" & $Key & "] " & $Name & "=" & chr(34) & $CurrentVal & chr(34) & " changed to " & chr(34) & $Value & chr(34))
           If $RegWriteComplete = 1 Then
               FileWriteLine($LogFile, "RegWrite Completed Successfully") 
               $Operations = $Operations + 1
           Else
               FileWriteLine($LogFile, "RegWrite Failed")
               $CriticalErrors = $CriticalErrors + 1
           EndIf
       Case @error = 1
           FileWriteLine($LogFile, "Creating [" & $Key & "] and adding new Value " & chr(34) & $Name & chr(34) & "=" & chr(34) & $Value & chr(34))
           If $RegWriteComplete = 1 Then
               FileWriteLine($LogFile, "RegWrite Completed Successfully") 
               $Operations = $Operations + 1
           Else
               FileWriteLine($LogFile, "RegWrite Failed")
               $CriticalErrors = $CriticalErrors + 1
           EndIf
       Case @error = -1
           FileWriteLine($LogFile, "Adding " & chr(34) & $Name & chr(34) & "=" & chr(34) & $Value & chr(34) & " [" & $Key & "]")
           If $RegWriteComplete = 1 Then
               FileWriteLine($LogFile, "RegWrite Completed Successfully")
               $Operations = $Operations + 1
           Else
               FileWriteLine($LogFile, "RegWrite Failed")
               $CriticalErrors = $CriticalErrors + 1
           EndIf
       Case @error = -2
           FileWriteLine($LogFile, "[" & $Key & "] " & $Name & "=" & "{Not Supported}" & " changed to " & chr(34) & $Value & chr(34))
           If $RegWriteComplete = 1 Then
               FileWriteLine($LogFile, "RegWrite Completed Successfully") 
               $Operations = $Operations + 1
           Else
               FileWriteLine($LogFile, "RegWrite Failed")
               $CriticalErrors = $CriticalErrors + 1
           EndIf
   EndSelect
   If StringLeft($Key, 17) = "HKEY_CURRENT_USER" Then
      If $current_user_only  = 0 Then TweakerRegWrite("HKEY_USERS\.DEFAULT" & StringTrimLeft($Key, 17),$Name,$Type,$Value)
   EndIf
EndFunc

Func TweakerRegDeleteKey($Key)
     $RegDeleteComplete = RegDelete($Key)
           FileWriteLine($LogFile, "Attempting to delete [" & $Key & "]")
           If $RegDeleteComplete = 1 Then
               FileWriteLine($LogFile, "RegDelete Completed Successfully") 
               $Operations = $Operations + 1
           Else
               FileWriteLine($LogFile, "RegDelete Failed")
               $CriticalErrors = $CriticalErrors + 1
           EndIf
EndFunc

Func TweakerRegDeleteName($Key,$Name)
     $RegDeleteComplete = RegDelete($Key,$Name)
           FileWriteLine($LogFile, "Attempting to delete [" & $Key & "] " & $Name)
           If $RegDeleteComplete = 1 Then
               FileWriteLine($LogFile, "RegDelete Completed Successfully") 
               $Operations = $Operations + 1
           Else
               FileWriteLine($LogFile, "RegDelete Failed")
               $CriticalErrors = $CriticalErrors + 1
           EndIf
EndFunc

Func StopLogging()
  If $logging = 1 then 
    FileWriteLine($LogFile, "--------------------------------------------------------------------------------")
    FileWriteLine($LogFile, "-------------------------" & $CriticalErrors & " Critical Errors Encountered-----------------------------")
    FileWriteLine($LogFile, "-------------------------" & $Operations & " Successful Operations-----------------------------")
    FileWriteLine($LogFile, "--------------------------------------------------------------------------------")
    FileWriteLine($LogFile, "-----------------v" & $Ver & " Currently Contains " & $Commands &" Commands------------------")
    FileWriteLine($LogFile, "--------------------------Created By Code Junkie---------------------------")
    FileWriteLine($LogFile, "--------------------------------------------------------------------------------")
    FileClose($LogFile)
  EndIf
EndFunc

#endregion Common Functions