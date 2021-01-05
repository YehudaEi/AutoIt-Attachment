#include <GuiConstants.au3>
Opt ("GUIOnEventMode", 1)
;Declare Variables - I tend to declare most variables 
;here and Globalise them, rather than use variables only 
;locally in seperate functions. I'm a freak like that. 
Global $FS = 9 ;;Font size 9
Global $B = 800 ;;Bold Text
GUISetFont($FS, 400) ;;Set general window font
;read KAV installation directory from registry
Global $KAV_Src = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\KasperskyLab\InstalledProducts\Kaspersky Anti-Virus Personal", "Folder")
;grab the info from above and trim it to get the drive root (the first 3 characters)
Global $KAV_Drv = StringLeft($KAV_Src, 3)
;Get plugin folder location
Global $KAV_Plugin_Dir = @ScriptDir
;Open the plugin's Inf file
Global $KAV_Inf = FileOpen($KAV_Plugin_Dir & "\Kav_personal.inf", 1)
;Open the localisation txt file (contains only the stuff that needs to be localised)
Global $Localise_Txt = FileOpen($KAV_Plugin_Dir & "\extractopts2.diz", 0)	
;We'll use the above variables to get the users Documents And settings directory
;in their own language and we'll trim the first three characters now, the x:\, before using them 
;later in the script 
Global $Replace_AppData = StringTrimLeft(@AppDataCommonDir, 3)
;Get winrar's path, we will use the command line console to compress the Livestate files a bit later,
;yet another step people won't have to do.
Global $WinRAR_Dir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinRAR.exe", "")
Global $KAV_Temp_Dir = @TempDir & "\KAVtemp"
Global $KAV_Bases_Temp_Dir = @TempDir & "\KAVBasestemp"

;Create GUI Elements
GUICreate("Kaspersky Personal 5.0.325 Plugin Setup", 440, 440, 0, 0, $WS_CAPTION + $WS_SIZEBOX)
$Title = GUICtrlCreateLabel("Kaspersky Personal 5.0.325 Plugin Setup", 59, 8, 340, 25)
GUICtrlSetFont($Title, 12, $B)
;Start group 1
$Group_1 = GUICtrlCreateGroup("Details", 10, 30, 420, 185)
GUICtrlSetFont($Group_1, 10, $B)
$Label_1 = GUICtrlCreateLabel("KAV Installation Folder:", 20, 50, 130, 45)
GUICtrlSetResizing($Label_1, $GUI_DOCKLEFT + $GUI_DOCKWIDTH)
$Label_1_2 = GUICtrlCreateLabel($KAV_Src, 150, 50, 250, 45)
GUICtrlSetResizing($Label_1_2, $GUI_DOCKLEFT)
GUICtrlSetFont($Label_1_2, $FS, $B)
$Label_2 = GUICtrlCreateLabel("KAV Plugin Folder:", 20, 100, 130, 20)
GUICtrlSetResizing($Label_2, $GUI_DOCKLEFT + $GUI_DOCKWIDTH)
$Label_2_2 = GUICtrlCreateLabel($KAV_Plugin_Dir, 150, 100, 250, 45)
GUICtrlSetResizing($Label_2_2, $GUI_DOCKLEFT)
GUICtrlSetFont($Label_2_2, $FS, $B)
;$Label_3 = GUICtrlCreateLabel("KAV Locale:", 20, 150, 130, 20)
;GUICtrlSetResizing($Label_3, $GUI_DOCKLEFT + $GUI_DOCKWIDTH)
;$Label_3_2 = GUICtrlCreateLabel($KAV_Locale, 150, 150, 180, 20)
;GUICtrlSetResizing($Label_3_2, $GUI_DOCKLEFT)
;GUICtrlSetFont($Label_3_2, $FS, $B)
$Label_4 = GUICtrlCreateLabel("WinRAR Folder:", 20, 160, 130, 20)
GUICtrlSetResizing($Label_4, $GUI_DOCKLEFT + $GUI_DOCKWIDTH)
$Label_4_2 = GUICtrlCreateLabel($WinRAR_Dir, 150, 160, 250, 45)
GUICtrlSetResizing($Label_4_2, $GUI_DOCKLEFT)
GUICtrlSetFont($Label_4_2, $FS, $B)
GUICtrlCreateGroup("", -99, -99, 1, 1)  
;close group
;Start group 2
$Group_2 = GUICtrlCreateGroup("Setup Progress", 10, 225, 420, 165)
GUICtrlSetResizing($Group_2, $GUI_DOCKALL)
GUICtrlSetFont($Group_2, 10, $B)
$Label_5 = GUICtrlCreateLabel("Localise Settings", 20, 245, 280, 20)
GUICtrlSetResizing($Label_5, $GUI_DOCKALL)
$Label_5_2 = GUICtrlCreateLabel("Idle", 320, 245, 80, 20)
GUICtrlSetResizing($Label_5_2, $GUI_DOCKALL)
$Label_6 = GUICtrlCreateLabel("Copy KAV Files To Temp Folder", 20, 265, 280, 20)
GUICtrlSetResizing($Label_6, $GUI_DOCKALL)
$Label_6_2 = GUICtrlCreateLabel("Idle", 320, 265, 80, 20)
GUICtrlSetResizing($Label_6_2, $GUI_DOCKALL)
$Label_7 = GUICtrlCreateLabel("Delete Uneccessary Files", 20, 285, 280, 20)
GUICtrlSetResizing($Label_7, $GUI_DOCKALL)
$Label_7_2 = GUICtrlCreateLabel("Idle", 320, 285, 80, 20)
GUICtrlSetResizing($Label_7_2, $GUI_DOCKALL)
$Label_8 = GUICtrlCreateLabel("Compress KAV Files", 20, 305, 280, 20)
GUICtrlSetResizing($Label_8, $GUI_DOCKALL)
$Label_8_2 = GUICtrlCreateLabel("Idle", 320, 305, 80, 20)
GUICtrlSetResizing($Label_8_2, $GUI_DOCKALL)
;$Label_9 = GUICtrlCreateLabel("Copy HPC File (FAT32 Only)", 20, 345, 280, 20)
;GUICtrlSetResizing($Label_9, $GUI_DOCKALL)
;$Label_9_2 = GUICtrlCreateLabel("Idle", 320, 345, 80, 30)
;GUICtrlSetResizing($Label_9_2, $GUI_DOCKALL)
$Label_10 = GUICtrlCreateLabel("Copy Files To Plugin Folder", 20, 325, 280, 20)
GUICtrlSetResizing($Label_10, $GUI_DOCKALL)
$Label_10_2 = GUICtrlCreateLabel("Idle", 320, 325, 80, 20)
GUICtrlSetResizing($Label_10_2, $GUI_DOCKALL)
$Label_11 = GUICtrlCreateLabel("Clean Up Temp Folder", 20, 345, 280, 20)
GUICtrlSetResizing($Label_11, $GUI_DOCKALL)
$Label_11_2 = GUICtrlCreateLabel("Idle", 320, 345, 80, 20)
GUICtrlSetResizing($Label_11_2, $GUI_DOCKALL)
$Label_12 = GUICtrlCreateLabel("Confirm All Files Present In Plugin Folder", 20, 365, 280, 20)
GUICtrlSetResizing($Label_12, $GUI_DOCKALL)
$Label_12_2 = GUICtrlCreateLabel("Idle", 320, 365, 80, 20)
GUICtrlSetResizing($Label_12_2, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;$Checkbox_1 = GUICtrlCreateCheckbox("Force ENGLISH Locale", 20, 465, 140, 25)
;GUICtrlSetResizing($Checkbox_1, $GUI_DOCKALL)
$Button_GO = GUICtrlCreateButton("Go", 260, 405, 80, 25)
GUICtrlSetResizing($Button_GO, $GUI_DOCKALL)
GUICtrlSetOnEvent($Button_GO, "GoPressed")
Func GOPressed()
   Set_Locale()
EndFunc
$Button_Exit = GUICtrlCreateButton("Exit", 350, 405, 80, 25)
GUICtrlSetResizing($Button_Exit, $GUI_DOCKALL)
GUICtrlSetOnEvent($Button_Exit, "ExitPressed")
Func ExitPressed()
   Exit
EndFunc
GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case Else
         ;;;;
   EndSelect
WEnd
Exit

;
; ===============================================================================
; All Localisation stuff is done here
Func Set_Locale()
   $Label_5 = GUICtrlCreateLabel(Chr(62) & " Localise Settings", 20, 245, 280, 20)
   GUICtrlSetResizing($Label_5, $GUI_DOCKALL)
   GUICtrlSetFont($Label_5, $FS, $B)
   $Label_5_2 = GUICtrlCreateLabel("In Progress", 320, 245, 80, 20)
   GUICtrlSetResizing($Label_5_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_5_2, $FS, $B)
   IniWrite($KAV_Plugin_Dir & "\extractopts2.diz", "comments", "Path", ".\%Temp%\" & $Replace_AppData & "\Kaspersky Anti-Virus Personal\5.0")
   $Label_5_2 = GUICtrlCreateLabel("Completed", 320, 245, 80, 20)
   GUICtrlSetResizing($Label_5_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_5_2, $FS, $B)
   $Label_5 = GUICtrlCreateLabel("Localise Settings", 20, 245, 280, 20)
   GUICtrlSetResizing($Label_5, $GUI_DOCKALL)
   KavTempCopy()
EndFunc
; End of Localisation stuff
; ===============================================================================
;
; ===============================================================================
; Copying of KAV files to Temp folder is done here
Func KavTempCopy()
   $Label_6 = GUICtrlCreateLabel(Chr(62) & " Copy KAV Files To Temp Folder", 20, 265, 280, 20)
   GUICtrlSetResizing($Label_6, $GUI_DOCKALL)
   GUICtrlSetFont($Label_6, $FS, $B)
   $Label_6_2 = GUICtrlCreateLabel("In Progress", 320, 265, 80, 20)
   GUICtrlSetResizing($Label_6_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_6_2, $FS, $B)
   ;copies all files from the Livestate installation to %Temp%\livestatetemp
   $KAV_Copy = DirCopy($KAV_Src, $KAV_Temp_Dir, 1)
   $KAV_Bases_Copy = DirCopy(@AppDataCommonDir & "\Kaspersky Anti-Virus Personal\5.0", $KAV_Bases_Temp_Dir, 1) 
   ;In the Agent folder copy the relevant gwlangXX.dll to the root %Temp% folder for safe keeping
   $Label_6_2 = GUICtrlCreateLabel("Completed", 320, 265, 80, 20)
   GUICtrlSetResizing($Label_6_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_6_2, $FS, $B)
   $Label_6 = GUICtrlCreateLabel("Copy KAV Files To Temp Folder", 20, 265, 280, 20)
   GUICtrlSetResizing($Label_6, $GUI_DOCKALL)
   Delete_Junk()
EndFunc
; End of Copying of Livestate files to Temp folder
; ===============================================================================
;
; ===============================================================================
; Deleting of unneeded Livestate files in Temp Livestate folder is done here
Func Delete_Junk()
   $Label_7 = GUICtrlCreateLabel(Chr(62) & " Delete Uneccessary Files", 20, 285, 280, 20)
   GUICtrlSetResizing($Label_7, $GUI_DOCKALL)
   GUICtrlSetFont($Label_7, $FS, $B)
   $Label_7_2 = GUICtrlCreateLabel("In Progress", 320, 285, 80, 20)
   GUICtrlSetResizing($Label_7_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_7_2, $FS, $B)
   ;Delete unnecessary gwlandXX.dll files
   FileDelete($KAV_Temp_Dir & "\Uninstall.exe")
   FileDelete($KAV_Temp_Dir & "\Uninstall.ini")
   FileDelete($KAV_Bases_Temp_Dir & "\sfdb.dat")
   FileDelete($KAV_Bases_Temp_Dir & "\backup\*.*")
   FileDelete($KAV_Bases_Temp_Dir & "\Quarantine\*.*")
   FileDelete($KAV_Bases_Temp_Dir & "\Reports\*.*")
   FileDelete($KAV_Bases_Temp_Dir & "\Updater reserved files\*.*")
   FileDelete($KAV_Bases_Temp_Dir & "\Updater update files\*.*")
   $Label_7_2 = GUICtrlCreateLabel("Completed", 320, 285, 80, 20)
   GUICtrlSetResizing($Label_7_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_7_2, $FS, $B)
   $Label_7 = GUICtrlCreateLabel("Delete Uneccessary Files", 20, 285, 280, 20)
   GUICtrlSetResizing($Label_7, $GUI_DOCKALL)
   Compress_Kav()
EndFunc
; End of Deleting of unneeded KAV files in Temp KAV folder
; ===============================================================================
;
; ===============================================================================
; Compressing of KAV files in Temp KAV folder is done here
Func Compress_Kav()
   $Label_8 = GUICtrlCreateLabel( Chr(62) & " Compress KAV Files", 20, 305, 280, 20)
   GUICtrlSetResizing($Label_8, $GUI_DOCKALL)
   GUICtrlSetFont($Label_8, $FS, $B)
   $Label_8_2 = GUICtrlCreateLabel("In Progress", 320, 305, 80, 20)
   GUICtrlSetResizing($Label_8_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_8_2, $FS, $B)
   ;Compress the folders into kavp5r.exe and make it self extracting
   ;the -zextractopts.diz (the -z" & $KAV_Plugin_Dir & "\extractopts.diz ") in the first line adds comments to the archive to set the extraction path and hide dialog options
   RunWait($WinRAR_Dir & " a -r -m5 -o+ -s -ep1 -sfx -z" & Chr(34) & $KAV_Plugin_Dir & "\extractopts.diz" & Chr(34) & "  " & Chr(34) & $KAV_Temp_Dir & "\kavp5r.exe" & Chr(34) & "  " & Chr(34) & $KAV_Temp_Dir & "\*.*" & Chr(34))
   ;Compress the KAV BAses into kavp5rbases.exe and make it self extracting
   ;the -extractopts.diz (the -z" & $KAV_Plugin_Dir & "\extractopts2.diz ") in the first line adds comments to the archive to set the extraction path and hide dialog options
   
   RunWait($WinRAR_Dir & " a -r -m5 -o+ -s -ep1 -sfx -z" & Chr(34) & $KAV_Plugin_Dir & "\extractopts2.diz" & Chr(34) & "  " & Chr(34) & $KAV_Temp_Dir & "\kavp5rbases.exe" & Chr(34) & "  " & Chr(34) & $KAV_Bases_Temp_Dir & "\*.*" & Chr(34))
   ;RunWait($WinRAR_Dir & " a -r -m5 -o+ -s -ep1 " & Chr(34) & $KAV_Temp_Dir & "\v2ibr.exe" & Chr(34) & "  " & Chr(34) & $KAV_Temp_Dir & "\Utility" & Chr(34))
   $Label_8_2 = GUICtrlCreateLabel("Completed", 320, 305, 80, 20)
   GUICtrlSetResizing($Label_8_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_8_2, $FS, $B)
   $Label_8 = GUICtrlCreateLabel("Compress KAV Files", 20, 305, 280, 20)
   GUICtrlSetResizing($Label_8, $GUI_DOCKALL)
   Copy_To_Folder()
EndFunc
; End of Compressing of KAV files in Temp KAV folder
; ===============================================================================
;
; ===============================================================================
; Copying of files from Temp KAV folder to plugin folders is done here
Func Copy_To_Folder()
   $Label_10 = GUICtrlCreateLabel(Chr(62) & " Copy Files To Plugin Folder", 20, 325, 280, 20)
   GUICtrlSetResizing($Label_10, $GUI_DOCKALL)
   GUICtrlSetFont($Label_10, $FS, $B)
   $Label_10_2 = GUICtrlCreateLabel("In Progress", 320, 325, 80, 20)
   GUICtrlSetResizing($Label_10_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_10_2, $FS, $B)
   ;Copy the archives to the plugin folder
   FileMove($KAV_Temp_Dir & "\kavp5r.exe", $KAV_Plugin_Dir & "\files", 1)
   FileMove($KAV_Temp_Dir & "\kavp5rbases.exe", $KAV_Plugin_Dir & "\files", 1)
   ;Copy the .sys and other files that need to be present in the system32 $ drivers folders on the CD
   FileCopy(@SystemDir & "\drivers\kl1.sys", $KAV_Plugin_Dir & "\files\system32\drivers", 1)
   FileCopy(@SystemDir & "\drivers\klick.sys", $KAV_Plugin_Dir & "\files\system32\drivers", 1)
   FileCopy(@SystemDir & "\drivers\klif.sys", $KAV_Plugin_Dir & "\files\system32\drivers", 1)
   FileCopy(@SystemDir & "\drivers\klin.sys", $KAV_Plugin_Dir & "\files\system32\drivers", 1)
   FileCopy(@SystemDir & "\drivers\klmc.sys", $KAV_Plugin_Dir & "\files\system32\drivers", 1)
   $Label_10_2 = GUICtrlCreateLabel("Completed", 320, 325, 80, 20)
   GUICtrlSetResizing($Label_10_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_10_2, $FS, $B)
   $Label_10 = GUICtrlCreateLabel("Copy Files To Plugin Folder", 20, 325, 280, 20)
   GUICtrlSetResizing($Label_10, $GUI_DOCKALL)
   Cleanup_Temp()
EndFunc
;End of Copying of files from Temp KAV folder to plugin folders
; ===============================================================================
;
; ===============================================================================
;Cleaning up of temp KAV folder is done here
Func Cleanup_Temp()
   $Label_11 = GUICtrlCreateLabel(Chr(62) & " Clean Up Temp Folder", 20, 345, 280, 20)
   GUICtrlSetResizing($Label_11, $GUI_DOCKALL)
   GUICtrlSetFont($Label_11, $FS, $B)
   $Label_11_2 = GUICtrlCreateLabel("In Progress", 320, 345, 80, 20)
   GUICtrlSetResizing($Label_11_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_11_2, $FS, $B)
   DirRemove($KAV_Temp_Dir, 1)
   DirRemove($KAV_Bases_Temp_Dir, 1)
   $Label_11_2 = GUICtrlCreateLabel("Completed", 320, 345, 80, 20)
   GUICtrlSetResizing($Label_11_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_11_2, $FS, $B)
   $Label_11 = GUICtrlCreateLabel("Clean Up Temp Folder", 20, 345, 280, 20)
   GUICtrlSetResizing($Label_11, $GUI_DOCKALL)
   Confirm_Files()
;End of Cleaning up of temp KAV folder
; ===============================================================================
;
; ===============================================================================
;Confirming of files in plugin folder is done here
;doesnt really check anything yet, it will one day...
EndFunc
Func Confirm_Files()
   $Label_12 = GUICtrlCreateLabel(Chr(62) & " Confirm All Files Present In Plugin Folder", 20, 365, 280, 20)
   GUICtrlSetResizing($Label_12, $GUI_DOCKALL)
   GUICtrlSetFont($Label_12, $FS, $B)
   $Label_12_2 = GUICtrlCreateLabel("In Progress", 320, 365, 80, 20)
   GUICtrlSetResizing($Label_12_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_12_2, $FS, $B)
   FileExists($KAV_Plugin_Dir & "\files\kavp5r.exe")
   FileExists($KAV_Plugin_Dir & "\files\kavp5rbases.exe")
   FileExists($KAV_Plugin_Dir & "\files\kav.ico")
   FileExists($KAV_Plugin_Dir & "\files\system32\drivers\kl1.sys")
   FileExists($KAV_Plugin_Dir & "\files\system32\drivers\klick.sys")
   FileExists($KAV_Plugin_Dir & "\files\system32\drivers\klif.sys")
   FileExists($KAV_Plugin_Dir & "\files\system32\drivers\klin.sys")   
   FileExists($KAV_Plugin_Dir & "\files\system32\drivers\klmc.sys")   
  Done()
EndFunc  
;End of Confirming of files in plugin folder
; ===============================================================================
;
Func Done()
   $Label_12_2 = GUICtrlCreateLabel("Completed", 320, 365, 80, 20)
   GUICtrlSetResizing($Label_12_2, $GUI_DOCKALL)
   GUICtrlSetFont($Label_12_2, $FS, $B)
   $Label_12 = GUICtrlCreateLabel("Confirm All Files Present In Plugin Folder", 20, 365, 280, 20)
   GUICtrlSetResizing($Label_12, $GUI_DOCKALL)
   MsgBox(0, "Setup Complete", "Kaspersky Personal 5.0.325 Plugin Setup is finished" & @CRLF & "Make sure its enabled")
   Exit
EndFunc
