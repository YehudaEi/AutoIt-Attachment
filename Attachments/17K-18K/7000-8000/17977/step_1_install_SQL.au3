#include <GUIConstants.au3>
#include <IE.au3>
#include <Misc.au3>

Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 


	$I_read_sapass = IniRead(@ScriptDir & "\_macro_conf.ini", "Sa", "pass",'')

#Region ### START Koda GUI section ### Form=
$Mainwindow = GUICreate("Automated Microsoft SQL Server 2000 installer", 375, 314, 315, 339)
$Label1 = GUICtrlCreateLabel("Authentication Mode:", 8, 31, 105, 17)

$Radio_mode_local = GUICtrlCreateRadio("Windows local", 8, 50, 129, 25)
$Radio_mode_mixed = GUICtrlCreateRadio("Mixed Mode (Windows Authentication and SQL Server Authentication)", 8, 71, 361, 25)

$Label2 = GUICtrlCreateLabel("Set sa password:", 16, 99, 85, 17)
$Input_sa_pass = GUICtrlCreateInput($I_read_sapass, 16, 117, 153, 21)
If $I_read_sapass <> '' Then
	GUICtrlSetState($Radio_mode_mixed, $GUI_CHECKED)
Else
	GUICtrlSetState(-1, $GUI_DISABLE)
EndIf

$Download_SQL = GUICtrlCreateButton("Go get SQL..from microsoft", 186, 24, 177, 25, 0)

$Checkbox_install_from_folder = GUICtrlCreateCheckbox("Browse existing SQLEVAL folder to install from", 8, 180, 345, 17)
$Input_install_from_folder = GUICtrlCreateInput("@ScriptDir\SQLEVAL\", 77, 203, 281, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button_Install_SQL_fromfolder = GUICtrlCreateButton("Go", 8, 202, 65, 25, 0)

$Checkbox_Install_from_file = GUICtrlCreateCheckbox("Browse SQLEVAL.exe, choose where to Extract it", 7, 242, 345, 17)
$Input_Install_from_file = GUICtrlCreateInput("@ScriptDir\SQLEVAL.EXE", 78, 264, 281, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button_Install_SQL_fromfile = GUICtrlCreateButton("Go", 6, 263, 65, 25)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;=============================================================================
;GUI Events
;=============================================================================
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "_Maximize") 
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_Minimize") 
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
GUICtrlSetOnEvent($Download_SQL, "_Download_SQL") 
GUICtrlSetOnEvent($Button_Install_SQL_fromfile, "_install_SQL_file") 
GUICtrlSetOnEvent($Button_Install_SQL_fromfolder, "_install_SQL_folder") ; no extract


GUICtrlSetOnEvent($Radio_mode_local, "_local_mode")
GUICtrlSetOnEvent($Radio_mode_mixed, "_mixed_mode") 

GUICtrlSetOnEvent($Checkbox_install_from_folder, "_install_from_folder")
GUICtrlSetOnEvent($Checkbox_Install_from_file, "_Install_from_file") 



;=============================================================================
;GUI functions
;=============================================================================
func _install_from_folder()
	GUICtrlSetState($Button_Install_SQL_fromfolder, $GUI_ENABLE)
	GUICtrlSetState($Input_Install_from_file, $GUI_DISABLE)
	GUICtrlSetState($Button_Install_SQL_fromfile, $GUI_DISABLE)	
	GUICtrlSetData($Input_Install_from_file,'')
	GUICtrlSetState($Checkbox_Install_from_file, $GUI_UNCHECKED)	
EndFunc
func _Install_from_file()
	GUICtrlSetState($Button_Install_SQL_fromfile, $GUI_ENABLE)
	GUICtrlSetState($Input_install_from_folder, $GUI_DISABLE)
	GUICtrlSetState($Button_Install_SQL_fromfolder, $GUI_DISABLE)
	GUICtrlSetData($Input_install_from_folder,'')
	GUICtrlSetState($Checkbox_install_from_folder, $GUI_UNCHECKED)	
EndFunc

func _local_mode()
	GUICtrlSetState($Input_sa_pass, $GUI_DISABLE)
EndFunc
func _mixed_mode()
	GUICtrlSetState($Input_sa_pass, $GUI_ENABLE)
EndFunc
	
func _Minimize()
	GUISetState(@SW_HIDE, $Mainwindow)
EndFunc

func _Maximize()
	If WinActive("Getlinks_v1.4") Then
		GUISetState(@SW_HIDE, $Mainwindow) 
	Else
		GUISetState(@SW_SHOW, $Mainwindow) 
		GUISetState(@SW_RESTORE,$Mainwindow)
	EndIf
EndFunc

;~ =================================================================================
;Download SQL Server 2000 Evaluation Edition Release A 
;~ =================================================================================
func _Download_SQL()
	$oIE = _IECreate ("http://www.microsoft.com/downloads/details.aspx?FamilyID=d20ba6e1-f44c-4781-a6bb-f60e02dc1335&displaylang=en",0,1,0,1)
EndFunc


func _install_SQL_folder()
		If GUICtrlRead($Radio_mode_mixed) <> $GUI_CHECKED And GUICtrlRead($Radio_mode_local) <> $GUI_CHECKED  Then
			MsgBox(0, "", "Please select Authentication Mode.")
			Return
		EndIf
		If GUICtrlRead($Checkbox_Install_from_file) <> $GUI_CHECKED And GUICtrlRead($Checkbox_install_from_folder) <> $GUI_CHECKED  Then
			MsgBox(0, "", "Please select eather to extract SQLEVAL.exe & install SQL server or" & @CRLF & @CRLF & " if SQLEVAL.exe was already extracted, then show me the folder where was it extracted.")
			Return
		EndIf		
		;~ =================================================================================
		; Browse where was SQLEVAL.exe extrcted
		;~ =================================================================================
		MsgBox(0, "", "Choose where was SQLEVAL.exe extrcted")
		$message_SQL_va0 = "Choose existing Folder"
		$SQL_val_path0 = FileopenDialog($message_SQL_va0, @DesktopDir & "\", "plz Enter Existing Folder(*.SQLVAL)",2,'plz Enter Existing Folder and press open')
		If @error Then
			Return ; if hit cancel Exit function
		Else
			$split = StringSplit($SQL_val_path0,'\')
			$S_replace = StringReplace($SQL_val_path0,$split[$split[0]],''); get the existing folder
			$SQL_val_path0 = $S_replace
			
			$msbox_deletefolder = MsgBox(1,'','Is this Correct ?'& @CRLF & @CRLF & $SQL_val_path0)			
			If $msbox_deletefolder = 2 Then Return ; if pressed cancel try again			
				GUICtrlSetData($Input_install_from_folder,$SQL_val_path0)
			EndIf
			
		;~ =================================================================================
		;Starting installation
		;~ =================================================================================
		ToolTip('Starting Installation please wait it may take a while..',0,0) ; remove tooltip
		ShellExecute($SQL_val_path0 & 'x86\setup\setupsql.exe') ; start setup
	
		While 1
			Sleep(500)
			 If WinWait('Enterprise Evaluation Edition') Then
			 ToolTip('') ; remove tooltip
				 ExitLoop ; if done extractiing continue
			 EndIf
		WEnd	
				 WinWait('Welcome')
				 WinActivate('Welcome')
				 ControlClick('Welcome', "", "Button1") ; NExt
				 
				 WinWait('Computer Name')
				 ControlClick('Computer Name', "", "Button7") ; Choose local computer & NExt
				 
				 WinWait('Installation Selection')
				 ControlClick('Installation Selection', "", "Button6") ;Select new instance & NExt

				 WinWait('User Information')
				 ControlClick('User Information', "", "Button2") ; NExt
				 
				 WinWait('Software License Agreement')
				 ControlClick('Software License Agreement', "", "Button2") ; yes

				 WinWait('Installation Definition')
				 ControlClick('Installation Definition', "", "Button6") ; Choose sever & client tools

				 WinWait('Instance Name')
				 ControlClick('Instance Name', "", "Button3")  ; Default NExt

				 WinWait('Setup Type')
				 ControlClick('Setup Type', "", "Button9") ; Typical NExt
				 
				 ;hire we choose to use system Local account
				 WinWait('Services Accounts')
				 WinActivate('Services Accounts')
				 Sleep(1000)
				 ControlClick('Services Accounts', "", "Button8") 
				 Sleep(1000)
				 ControlClick('Services Accounts', "", "Button13") ; next
				 
				 ; Hire we set sa pass
				 WinWait('Authentication Mode')
				 WinActivate('Authentication Mode')
				 Sleep(1000)
				If GUICtrlRead($Radio_mode_mixed) = $GUI_CHECKED Then
					ControlClick('Authentication Mode', "", "Button2") ;choose mixed radio
					ControlsetText('Authentication Mode', "", "Edit1",GUICtrlRead($Input_sa_pass)) 
					ControlsetText('Authentication Mode', "", "Edit2",GUICtrlRead($Input_sa_pass)) ; set sa pass
					Sleep(1000)
					ControlClick('Authentication Mode', "", "Button5") ;next
				Else
					ControlClick('Authentication Mode', "", "Button1") ;choose local radio
				EndIf
					
				 WinWait('Start Copying Files')
				 ControlClick('Start Copying Files', "", "Button1") ; NExt


				 WinWait('Setup Complete')
				 ControlClick('Setup Complete', "", "Button4") ; FINISH
			 
			$msbox_deletefolder = MsgBox(1,'','Setup Complete, The SQLEVAL folder is not needed anymore'& @CRLF & @CRLF & 'Delete it?' )			
EndFunc


func _install_SQL_file()
		If GUICtrlRead($Radio_mode_mixed) <> $GUI_CHECKED And GUICtrlRead($Radio_mode_local) <> $GUI_CHECKED  Then
			MsgBox(0, "", "Please select Authentication Mode.")
			Return
		EndIf
		If GUICtrlRead($Checkbox_Install_from_file) <> $GUI_CHECKED And GUICtrlRead($Checkbox_install_from_folder) <> $GUI_CHECKED  Then
			MsgBox(0, "", "Please select eather to extract SQLEVAL.exe & install SQL server or" & @CRLF & @CRLF & " if SQLEVAL.exe was already extracted, then show me the folder where was it extracted.")
			Return
		EndIf		
		;~ =================================================================================
		; Browse where to Extract SQLEVAL.exe 
		;~ =================================================================================
		MsgBox(0, "", "Choose where we should extract SQLEVAL.exe ")
		$message_SQL_va0 = "Choose Folder to extract"
		$SQL_val_path0 = FilesaveDialog($message_SQL_va0, @DesktopDir & "\", "Folder to Unzip(*.SQLVAL)",16,'SQLEVAL')
		If @error Then
			Return ; if hit cancel Exit function
		Else
			$msbox_deletefolder = MsgBox(1,'','Extract it to:'& @CRLF & @CRLF & $SQL_val_path0 & ' ?')			
			If $msbox_deletefolder = 2 Then Return ; if pressed cancel try again			
				GUICtrlSetData($Input_Install_from_file,$SQL_val_path0)
		EndIf

		;~ =================================================================================
		; Browse SQLEVAL.exe Microsoft SQL Server 2000
		;~ =================================================================================
		$message_SQL_val = "Choose SQLEVAL.exe"
		$SQL_val_path1 = FileOpenDialog($message_SQL_val, @ScriptDir & "\", "loacate SQLEVAL(*.exe)", 1 + 4 ,'SQLEVAL.exe')
		If @error Then Return ; if hit cancel Exit function

		ToolTip('Extracting SQLEVAL.exe, it may take a while ... Please wait!',0,0)
		Run($SQL_val_path1)
		ToolTip('') ; remove tooltip

		
		$extract_ = 'Installation Folder' ; wait for install window to be active
		WinWait($extract_)
		WinActivate($extract_)
			ControlsetText($extract_, "", "Edit1",$SQL_val_path0) ; get the extraxt folder
			ControlClick($extract_, "", "Button4") ; press Finish


		While 1
			Sleep(500)
			 If WinActive('PackageForTheWeb','The specified output folder does not exist.  Create it?') Then ControlClick('PackageForTheWeb', "", "Button1") ;press OK if folder not exist			
			 If WinWait('PackageForTheWeb','The package has been delivered successfully.') Then
				 ControlClick('PackageForTheWeb', "", "Button1")
				 ExitLoop ; if done extractiing continue
			 EndIf
		WEnd	
			 
		;~ =================================================================================
		;Starting installation
		;~ =================================================================================
		ToolTip('Starting Installation please wait it may take a while..',0,0) ; remove tooltip
		ShellExecute($SQL_val_path0 & '\x86\setup\setupsql.exe') ; start setup
	
		While 1
			Sleep(500)
			 If WinWait('Enterprise Evaluation Edition') Then
			 ToolTip('') ; remove tooltip
				 ExitLoop ; if done extractiing continue
			 EndIf
		WEnd	
				 WinWait('Welcome')
				 WinActivate('Welcome')
				 ControlClick('Welcome', "", "Button1") ; NExt
				 
				 WinWait('Computer Name')
				 ControlClick('Computer Name', "", "Button7") ; Choose local computer & NExt
				 
				 WinWait('Installation Selection')
				 ControlClick('Installation Selection', "", "Button6") ;Select new instance & NExt

				 WinWait('User Information')
				 ControlClick('User Information', "", "Button2") ; NExt
				 
				 WinWait('Software License Agreement')
				 ControlClick('Software License Agreement', "", "Button2") ; yes

				 WinWait('Installation Definition')
				 ControlClick('Installation Definition', "", "Button6") ; Choose sever & client tools

				 WinWait('Instance Name')
				 ControlClick('Instance Name', "", "Button3")  ; Default NExt

				 WinWait('Setup Type')
				 ControlClick('Setup Type', "", "Button9") ; Typical NExt
				 
				 ;hire we choose to use system Local account
				 WinWait('Services Accounts')
				 WinActivate('Services Accounts')
				 Sleep(1000)
				 ControlClick('Services Accounts', "", "Button8") 
				 Sleep(1000)
				 ControlClick('Services Accounts', "", "Button13") ; next
				 
				 ; Hire we set sa pass
				 WinWait('Authentication Mode')
				 WinActivate('Authentication Mode')
				 Sleep(1000)
				If GUICtrlRead($Radio_mode_mixed) = $GUI_CHECKED Then
					ControlClick('Authentication Mode', "", "Button2") ;choose mixed radio
					ControlsetText('Authentication Mode', "", "Edit1",GUICtrlRead($Input_sa_pass)) 
					ControlsetText('Authentication Mode', "", "Edit2",GUICtrlRead($Input_sa_pass)) ; set sa pass
					Sleep(1000)
					ControlClick('Authentication Mode', "", "Button5") ;next
				Else
					ControlClick('Authentication Mode', "", "Button1") ;choose local radio
				EndIf
					
				 WinWait('Start Copying Files')
				 ControlClick('Start Copying Files', "", "Button1") ; NExt


				 WinWait('Setup Complete')
				 ControlClick('Setup Complete', "", "Button4") ; FINISH
;~ 				 
			$msbox_deletefolder = MsgBox(1,'','Setup Complete, The SQLEVAL folder is not needed anymore'& @CRLF & @CRLF & 'Delete it?' )			
			If $msbox_deletefolder = 1 Then DirRemove($SQL_val_path0, 1); if pressed OK then
EndFunc


func _EXIT()
;~ 	IniWrite(@ScriptDir & "\_macro_conf.ini", "Sa", "pass",GUICtrlRead($Input_sa_pass))
	Exit
EndFunc
While 1
	Sleep(100)
WEnd