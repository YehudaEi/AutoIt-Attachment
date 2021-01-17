; *** Start added by AutoIt3Wrapper ***
#include <EditConstants.au3>
; *** End added by AutoIt3Wrapper ***
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=\\phdsso02\scripts\icons\wi0064-32.ico
#AutoIt3Wrapper_outfile=c:\temp\wksadmin.exe
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <GuiConstants.au3>
#include <Constants.au3>
#include <GuiStatusBar.au3>
#include <Date.au3>
#Include <GuiScrollBars.au3>
Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
Global $filemenu, $fileitem, $btn, $contextmenu, $pass, $top0, $txtadmin, $txtPassword, $enterbtn, $user, $menustate, $Exitbutton, $AppName 
Local $sPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") & "\Beta\Examples\GUI\Advanced\Images"

Local Enum $idNew = 1000

;Login Screen


;MENU
;GUICreate("SSO Administrative Toolkit",445,200)
;$ssofile = GuiCtrlCreateMenu("File")

;workstation tools
$ssowork = TrayCreateMenu("RunAsAdmin")
$ssoworkitem1 = TrayCreateItem("Task Manager", $ssowork)
$ssoworkitem2 = TrayCreateItem("Windows Explorer", $ssowork)
$ssoworkitem3 = TrayCreateItem("Command Prompt", $ssowork)
$ssoworkitem4 = TrayCreateItem("Logoff Windows", $ssowork)
$ssoworkitem5 = TrayCreateItem("Add/Remove Programs", $ssowork)
$ssoworkitem6 = TrayCreateItem("IE Properties", $ssowork)
$ssoworkitem7 = TrayCreateItem("Computer Properties", $ssowork)
$ssoworkitem8 = TrayCreateItem("System Date and Time", $ssowork)
$ssoworkitem9 = TrayCreateItem("Registry editor", $ssowork)
$ssoworkitem10 = TrayCreateItem("Disk Cleanup", $ssowork)

;System diagnostics
$ssodiag = TrayCreateMenu("Dianostics")
$ssodiagitem1 = TrayCreateItem("Computer & User GPO Settings", $ssodiag)
$ssodiagitem2 = TrayCreateItem("IP Configuration", $ssodiag)
$ssodiagitem3 = TrayCreateItem("Memory Statistics", $ssodiag)
$ssodiagitem4 = TrayCreateItem("Task List", $ssodiag)
$ssodiagitem5 = TrayCreateItem("System Information", $ssodiag)
$ssodiagitem6 = TrayCreateItem("Event Viewer", $ssodiag)
$ssodiagitem7 = TrayCreateItem("Hard Drive Space", $ssodiag)


;help
TrayCreateItem("")
$ssohelpitem1 = TrayCreateItem("&Help")
$ssohelpitem2 = TrayCreateItem("About") 

;set admin account
Func AuthAdmin()
	GUICreate("Admin Login",200,100)
	$user = GuiCtrlCreateInput("", 25, 25, 130, 20)
	$pass = GUICtrlCreateInput("",25, 45 + $top0, 130, 20, 0x0020)
	$enterbtn =GUICtrlCreateButton("Enter", 25, 65, 70, 20)
	GUISetState()
	$msg = 0
	While $msg <> $GUI_EVENT_CLOSE 
		$msg = GuiGetMsg()
		Select
			Case $msg = $Exitbutton
			ExitLoop
			Case $msg = $enterbtn
				$UserName = GUICtrlRead($user)
				$PassWord = GUICtrlRead($pass)
				$runout = RunAs($UserName, "Texas", $PassWord, 0, $AppName, @SystemDir)
				If @error Then 					
				MsgBox(1,"Login Error","Incorrect Credentials provided.")
				GUIDelete()
				Else
				GUIDelete()
				EndIf
			ExitLoop	
		EndSelect
		WEnd
EndFunc

TrayCreateItem("")  
$Exitbutton = TrayCreateItem("Exit")


TraySetState()

While 1
	$msg = TrayGetMsg()
	If $msg = $Exitbutton Then ExitLoop
	
	;help
	If $msg = $ssohelpitem1 Then Msgbox(0,"Help","Workstation Admin Toolkit Version 2.0" & @CRLF & @CRLF & "Once a user selects an application to run." & @CRLF & "They will be prompted to authenticate.")
	If $msg = $ssohelpitem2 Then Msgbox(0,"About","Workstation Admin Toolkit Version 2.0" & @CRLF & @CRLF & "Programmer: Roger Fleming" & @CRLF & @CRLF & "April 9, 2009")
	
	;workstation tools
	If $msg = $ssoworkitem1 Then
		$AppName = "taskmgr.exe"
		AuthAdmin()
		EndIf
    If $msg = $ssoworkitem2 Then 
		$AppName = "explorer.exe /separate"
		AuthAdmin()
		EndIf
	If $msg = $ssoworkitem3 Then 
		$AppName = "command.com"
		AuthAdmin()
		EndIf
	If $msg = $ssoworkitem4 Then 
		$AppName = "logoff.exe"
		AuthAdmin()
	EndIf
	If $msg = $ssoworkitem5 Then 
		$AppName = "control Appwiz.cpl"
		AuthAdmin()
	EndIf
	If $msg = $ssoworkitem6 Then 
		$AppName = "control Inetcpl.cpl"
		AuthAdmin()
	EndIf
	If $msg = $ssoworkitem7 Then 
		$AppName = "control Sysdm.cpl"
		AuthAdmin()
	EndIf
	If $msg = $ssoworkitem8 Then 
		$AppName = "control TimeDate.cpl"
		AuthAdmin()
	EndIf
	If $msg = $ssoworkitem9 Then 
		$AppName = "regedit"
		AuthAdmin()
	EndIf
	If $msg = $ssodiagitem1 Then 
		Local $hGUI
		$tCur = _Date_Time_GetLocalTime()
		$CurTime = (_Date_Time_SystemTimeToDateTimeStr($tCur))
		Local $aText[3] = ["Retrieving GPO Settings", @TAB & "", @TAB & @TAB & $CurTime]
		Local $aParts[3] = [200, 175, -1]
		
		$hGUI = GUICreate("Computer & User GPO Settings Report", 800, 600)
		$lGUI = GUICtrlCreateEdit("Report in Prgress" & @CRLF, -1, -1, 800, 580, $ES_AUTOVSCROLL + $WS_VSCROLL)
		_GUIScrollBars_Init($lGUI)
		$hStatus = _GUICtrlStatusBar_Create ($hGUI, $aParts, $aText)
		
		GUISetState()
		GUICtrlSetData($lGUI, "Generating the Report.", 1)
		
		local $foo1 = Run(@ComSpec & " /c gpresult", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line1

		GUISetState()
			While $msg <> $GUI_EVENT_CLOSE
					$msg = GuiGetMsg()
					While 1
						$line1 = StdoutRead($foo1)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line1, 1)
					Wend

					While 1
						$line1 = StderrRead($foo1)
						If @error Then ExitLoop
						MsgBox(0, "STDERR read:", $line1)
					Wend
					_GUICtrlStatusBar_SetText ($hStatus, "Retrieving GPO Settings Complete")
				WEnd
			GUIDelete()
		EndIf
		If $msg = $ssodiagitem2 Then 
		Local $hGUI
		$tCur = _Date_Time_GetLocalTime()
		$CurTime = (_Date_Time_SystemTimeToDateTimeStr($tCur))
		Local $aText[3] = ["IP Configuration Settings", @TAB & "", @TAB & @TAB & $CurTime]
		Local $aParts[3] = [200, 175, -1]
		
		$hGUI = GUICreate("IP Configuration Report", 800, 600)
		$lGUI = GUICtrlCreateEdit("Report in Prgress" & @CRLF, -1, -1, 800, 580, $ES_AUTOVSCROLL + $WS_VSCROLL)
		_GUIScrollBars_Init($lGUI)
		$hStatus = _GUICtrlStatusBar_Create ($hGUI, $aParts, $aText)
		
		GUISetState()
		GUICtrlSetData($lGUI, "Generating the Report.", 1)
		
		local $foo1 = Run(@ComSpec & " /c ipconfig /all", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line1

		GUISetState()
			While $msg <> $GUI_EVENT_CLOSE
					$msg = GuiGetMsg()
					While 1
						$line1 = StdoutRead($foo1)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line1, 1)
					Wend

					While 1
						$line1 = StderrRead($foo1)
						If @error Then ExitLoop
						MsgBox(0, "STDERR read:", $line1)
					Wend
					_GUICtrlStatusBar_SetText ($hStatus, "Retrieving IP Configuration Complete")
				WEnd
			GUIDelete()
		EndIf
		If $msg = $ssodiagitem3 Then 
		Local $hGUI
		$tCur = _Date_Time_GetLocalTime()
		$CurTime = (_Date_Time_SystemTimeToDateTimeStr($tCur))
		Local $aText[3] = ["Memory Statistics Settings", @TAB & "", @TAB & @TAB & $CurTime]
		Local $aParts[3] = [200, 175, -1]
		
		$hGUI = GUICreate("Memory Statistics Report", 800, 600)
		$lGUI = GUICtrlCreateEdit("Report in Prgress" & @CRLF, -1, -1, 800, 580, $ES_AUTOVSCROLL + $WS_VSCROLL)
		_GUIScrollBars_Init($lGUI)
		$hStatus = _GUICtrlStatusBar_Create ($hGUI, $aParts, $aText)
		
		GUISetState()
		GUICtrlSetData($lGUI, "Generating the Report.", 1)
		
		local $foo1 = Run(@ComSpec & " /c mem /debug", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line1

		GUISetState()
			While $msg <> $GUI_EVENT_CLOSE
					$msg = GuiGetMsg()
					While 1
						$line1 = StdoutRead($foo1)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line1, 1)
					Wend

					While 1
						$line1 = StderrRead($foo1)
						If @error Then ExitLoop
						MsgBox(0, "STDERR read:", $line1)
					Wend
					_GUICtrlStatusBar_SetText ($hStatus, "Retrieving Memory Statistics Complete")
				WEnd
			GUIDelete()
		EndIf
	If $msg = $ssodiagitem4 Then 
		Local $hGUI
		$tCur = _Date_Time_GetLocalTime()
		$CurTime = (_Date_Time_SystemTimeToDateTimeStr($tCur))
		Local $aText[3] = ["Process Statistics Settings", @TAB & "", @TAB & @TAB & $CurTime]
		Local $aParts[3] = [200, 175, -1]
		
		$hGUI = GUICreate("Process Statistics Report", 800, 600)
		$lGUI = GUICtrlCreateEdit("Report in Prgress" & @CRLF, -1, -1, 800, 580, $ES_AUTOVSCROLL + $WS_VSCROLL)
		_GUIScrollBars_Init($lGUI)
		$hStatus = _GUICtrlStatusBar_Create ($hGUI, $aParts, $aText)
		
		GUISetState()
		GUICtrlSetData($lGUI, "Generating the Report.", 1)
		
		local $foo1 = Run(@ComSpec & " /c tasklist /V", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line1

		GUISetState()
			While $msg <> $GUI_EVENT_CLOSE
					$msg = GuiGetMsg()
					While 1
						$line1 = StdoutRead($foo1)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line1, 1)
					Wend

					While 1
						$line1 = StderrRead($foo1)
						If @error Then ExitLoop
						MsgBox(0, "STDERR read:", $line1)
					Wend
					_GUICtrlStatusBar_SetText ($hStatus, "Retrieving Process Statistics Complete")
				WEnd
			GUIDelete()
		EndIf
If $msg = $ssodiagitem5 Then 
		Local $hGUI
		$tCur = _Date_Time_GetLocalTime()
		$CurTime = (_Date_Time_SystemTimeToDateTimeStr($tCur))
		Local $aText[3] = ["System Statistics Settings", @TAB & "", @TAB & @TAB & $CurTime]
		Local $aParts[3] = [200, 175, -1]
		
		$hGUI = GUICreate("System Statistics Report", 800, 600)
		$lGUI = GUICtrlCreateEdit("Report in Prgress" & @CRLF, -1, -1, 800, 580, $ES_AUTOVSCROLL + $WS_VSCROLL)
		_GUIScrollBars_Init($lGUI)
		$hStatus = _GUICtrlStatusBar_Create ($hGUI, $aParts, $aText)
		
		GUISetState()
		GUICtrlSetData($lGUI, "Generating the Report.", 1)
		
		local $foo1 = Run(@ComSpec & " /c systeminfo", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line1

		GUISetState()
			While $msg <> $GUI_EVENT_CLOSE
					$msg = GuiGetMsg()
					While 1
						$line1 = StdoutRead($foo1)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line1, 1)
					Wend

					While 1
						$line1 = StderrRead($foo1)
						If @error Then ExitLoop
						MsgBox(0, "STDERR read:", $line1)
					Wend
					_GUICtrlStatusBar_SetText ($hStatus, "Retrieving System Statistics Complete")
				WEnd
			GUIDelete()
	EndIf
	If $msg = $ssodiagitem6 Then
		Run(@ComSpec & " /c eventvwr", @SystemDir, @SW_HIDE)
	EndIf	
	If $msg = $ssodiagitem7 Then 
		Local $hGUI
		$tCur = _Date_Time_GetLocalTime()
		$CurTime = (_Date_Time_SystemTimeToDateTimeStr($tCur))
		Local $aText[3] = ["Hard Drive Statistics", @TAB & "", @TAB & @TAB & $CurTime]
		Local $aParts[3] = [200, 175, -1]
		
		$hGUI = GUICreate("Hard Drive Statistics Report", 800, 600)
		$lGUI = GUICtrlCreateEdit("Report in Prgress" & @CRLF, -1, -1, 800, 580, $ES_AUTOVSCROLL + $WS_VSCROLL)
		_GUIScrollBars_Init($lGUI)
		$hStatus = _GUICtrlStatusBar_Create ($hGUI, $aParts, $aText)
		
		GUISetState()
		GUICtrlSetData($lGUI, "Generating the Report.", 1)
		
		local $foo1 = Run(@ComSpec & " /c dir c:\", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line1
		local $foo2 = Run(@ComSpec & " /c fsutil fsinfo drivetype c:", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line2
		local $foo3 = Run(@ComSpec & " /c fsutil fsinfo volumeinfo c:\", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line3
		local $foo4 = Run(@ComSpec & " /c fsutil fsinfo ntfsinfo c:", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line4
		local $foo5 = Run(@ComSpec & " /c fsutil fsinfo statistics c:", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Local $line5
		

		GUISetState()
			While $msg <> $GUI_EVENT_CLOSE
					$msg = GuiGetMsg()
					;GUICtrlSetData($lGUI, "fsutil fsinfo drives", 1)
					While 1
						$line1 = StdoutRead($foo1)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line1, 1)
					Wend
					;GUICtrlSetData($lGUI, "fsutil fsinfo drivetype c:", 1)
					While 1
						$line2 = StdoutRead($foo2)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line2, 1)
					Wend
					;GUICtrlSetData($lGUI, "fsutil fsinfo volumeinfo c:", 1)
					While 1
						$line3 = StdoutRead($foo3)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line3, 1)
					Wend
					;GUICtrlSetData($lGUI, "fsutil fsinfo ntfsinfo c:", 1)
					While 1
						$line4 = StdoutRead($foo4)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line4, 1)
					Wend 
					;GUICtrlSetData($lGUI, "fsutil fsinfo statistics c:", 1)
					While 1
						$line5 = StdoutRead($foo5)
						If @error Then ExitLoop
						GUICtrlSetData($lGUI, $line5, 1)
					Wend
					While 1
						$line1 = StderrRead($foo1)
						If @error Then ExitLoop
						MsgBox(0, "STDERR read:", $line1)
					Wend
					_GUICtrlStatusBar_SetText ($hStatus, "Retrieving Hard Drive Statistics Complete")
				WEnd
			GUIDelete()
	EndIf
WEnd
Exit