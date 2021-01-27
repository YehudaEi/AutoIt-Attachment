#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=H:\icons\computer-icons\printer2.ico
#AutoIt3Wrapper_outfile=..\print_migration_v7.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Dim $RunOnce, $SystemRoot, $Message, $ButtonPressed, $PID
; Get the SystemRoot variable from the computer environment to be used later in the script
$SystemRoot = EnvGet("SYSTEMROOT")
$WindowsDir = @WindowsDir
$OStat = ""

$Form2 = GUICreate("Printer Migration Tool - v7", 195, 192, 193, 125)
$AButton1 = GUICtrlCreateButton("Local Storage", 32, 24, 121, 57, 0)
$AButton2 = GUICtrlCreateButton("Network Storage", 32, 96, 121, 65, 0)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $AButton1
			$OStat = "1"
			ExitLoop
		Case $AButton2
			$OStat = "2"
			ExitLoop
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd


IF $OStat = "2" Then

$PMap = DriveMapGet ("Z:")
if @error = "1" Then
	MsgBox(0,"No mapping detected","No drive mapping detected on Z:",1)
	$PMap = "NULL"
	Else
	MsgBox(0,"A mapping was detected on Z:",$PMap,1)
EndIf

MsgBox(0,"Removing Existing Mapping",$PMap,1)
DriveMapDel ("Z:")
MsgBox(0,"Mapping Printer Migration Location","\\server\Shared\PMig",1)
DriveMapAdd("Z:","\\IP Address\Shared\PMig",0,"domain\user","password")

$folder="Z:\printer\printmig.exe"
IF FileExists($folder) Then
	msgbox (0,"Printer tool Found","Proper files found on the network",1)
Else
	msgbox (0,"Printer tool not found","Please validate network connectivity - printer tool not detected",1)
	exit
EndIf

; *******************************************************************
; ****************** Prompted Menu **********************************
; *******************************************************************

$Form1 = GUICreate("Printer Migration Tool - v5", 299, 317, 280, 137)
$BButton1 = GUICtrlCreateButton("Backup Printer Settings", 57, 16, 193, 65, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$BButton2 = GUICtrlCreateButton("Delete Printer Settings", 57, 88, 193, 65, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$BButton3 = GUICtrlCreateButton("Restore Printer Settings", 57, 160, 193, 65, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$BButton4 = GUICtrlCreateButton("Exit", 105, 240, 113, 49, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x0000FF)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $BButton1
			BKUPPR()
		Case $BButton2
			DELPR()
		Case $BButton3
			RSTPR()
		Case $BButton4
			ExitLoop
		Case $GUI_EVENT_CLOSE
	EndSwitch
WEnd


DriveMapDel ("Z:")

if $PMap = "NULL" Then
	MsgBox(0,"No mappings to restore","Null drive mapping on Z:",1)
	Else
	MsgBox(0,"Restoring Previous Mapping",$PMap,1)
	DriveMapAdd("Z:",$PMap)
EndIf


EndIf

; *******************************************************************
; *******************************************************************
; *******************************************************************
; *******************************************************************
; *******************************************************************
; *******************************************************************


IF $OStat = "1" Then

; *******************************************************************
; ****************** Prompted Menu **********************************
; *******************************************************************

FileInstall("G:\Pmig\printer\printmig.exe",@WorkingDir,1)
FileInstall("G:\Pmig\printer\prnmngr.vbs",@WorkingDir,1)


$Form1 = GUICreate("Printer Migration Tool - v7", 299, 317, 280, 137)
$CButton1 = GUICtrlCreateButton("Backup Printer Settings", 57, 16, 193, 65, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$CButton2 = GUICtrlCreateButton("Delete Printer Settings", 57, 88, 193, 65, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$CButton3 = GUICtrlCreateButton("Restore Printer Settings", 57, 160, 193, 65, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$CButton4 = GUICtrlCreateButton("Exit", 105, 240, 113, 49, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x0000FF)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $CButton1
			LBKUPPR()
		Case $CButton2
			LDELPR()
		Case $CButton3
			LRSTPR()
		Case $CButton4
			ExitLoop
		Case $GUI_EVENT_CLOSE
	EndSwitch
WEnd


EndIf



Func BKUPPR()
$BLD = ""

	While $BLD = ""
		$BLD = InputBox ("Enter Building And Department", "Enter a file descriptor for the backup file. The computer name is already included by the tool")
			If @error = 1 Then
				MsgBox(0, 'Error', 'You must enter a file description to avoid conflict')
			EndIf
	Wend

MsgBox(0, "Saving Current printer settings","Backing up current configuration to the network",1)


RunWait(@COMSPEC & " /c " & $WindowsDir &"\System32\cscript.exe Z:\printer\prnmngr.vbs -l > Z:\"& $BLD &"_%computername%.txt")

RunWait(@COMSPEC & " /c Z:\printer\printmig.exe -b Z:\"& $BLD &"_%computername%.cab")

MsgBox (0,"Printer settings backed up"," File Name: Z:\"& $BLD & "_"& @computername &".cab")

EndFunc



Func DELPR()
	MsgBox(0,"Removing all Printers","Please wait - Uninstalling local printers",1)

	If @OSVersion = "win_2000" Then
		MsgBox(0,"Windows 2000 is not supported", "You must manually remove the existing printers from this computer.", 3)
	Else
		RunWait(@COMSPEC & " /c" & $WindowsDir &"\System32\cscript.exe Z:\printer\prnmngr.vbs -x")

		RunWait(@COMSPEC & " /c net stop LPDSVC")
		RunWait(@COMSPEC & " /c net stop spooler")
		RunWait(@COMSPEC & " /c net start spooler")
		RunWait(@COMSPEC & " /c net start LPDSVC")

	MsgBox(0,"Removal Completed","All printers removed",1)
	EndIf


EndFunc


Func RSTPR()
	$message = "Select the Printer Restore CAB to begin"
    $RSTFILE = ""

	While $RSTFILE = ""
		MsgBox (1,"Please Select your restore file","Please Select a file to continue or click Cancel to exit")
		$RSTFILE = FileOpenDialog($message, "Z:","CAB(*.cab)", 1 + 4 )
			If @error = 1 Then
				MsgBox(0, '', 'The Cancel button was pushed')
			Exit
			EndIf
	Wend

	MsgBox (0,"File Selected", $RSTFILE,1)

	MsgBox(0,"Installing New Printer Settings","New printer configuration being installed",1)

	RunWait(@COMSPEC & " /c Z:\printer\printmig.exe -r "&  $RSTFILE)

RunWait(@COMSPEC & " /c net stop LPDSVC")
RunWait(@COMSPEC & " /c net stop spooler")
RunWait(@COMSPEC & " /c net start spooler")
RunWait(@COMSPEC & " /c net start LPDSVC")

MsgBox(0,"Migration Completed","You may need to reboot to see the new printers",3)
EndFunc

Func LBKUPPR()

RunWait(@COMSPEC & " /c" & $WindowsDir & "\System32\cscript.exe" & @WorkingDir & "\prnmngr.vbs -l > c:\"& @computername &".txt")


RunWait(@COMSPEC & " /c " & @WorkingDir & "\printmig.exe -b c:\"& @computername & ".cab")

MsgBox (0,"Printer settings backed up"," File Name: C:\"& @computername &".cab")

EndFunc


Func LDELPR()
	MsgBox(0,"Removing all Printers","Please wait - Uninstalling local printers",1)

	If @OSVersion = "win_2000" Then
		MsgBox(0,"Windows 2000 is not supported", "You must manually remove the existing printers from this computer.", 3)
	Else
		RunWait(@COMSPEC & " /c" & $WindowsDir & "\System32\cscript.exe " & @WorkingDir & "\prnmngr.vbs -x")
		RunWait(@COMSPEC & " /c net stop LPDSVC")
		RunWait(@COMSPEC & " /c net stop spooler")
		RunWait(@COMSPEC & " /c net start spooler")
		RunWait(@COMSPEC & " /c net start LPDSVC")

		MsgBox(0,"Removal Completed","All printers removed",1)
	EndIf


EndFunc


Func LRSTPR()
	$message = "Select the Printer Restore CAB to begin"
    $RSTFILE = ""

	While $RSTFILE = ""
		MsgBox (1,"Please Select your restore file","Please Select a file to continue or click Cancel to exit")
		$RSTFILE = FileOpenDialog($message, "c:","CAB(*.cab)", 1 + 4 )
			If @error = 1 Then
				MsgBox(0, '', 'The Cancel button was pushed')
			Exit
			EndIf
	Wend

	MsgBox (0,"File Selected", $RSTFILE,1)

	MsgBox(0,"Installing New Printer Settings","New printer configuration being installed",1)

	RunWait(@COMSPEC & " /c " & @WorkingDir & "\printmig.exe -r "&  $RSTFILE)

RunWait(@COMSPEC & " /c net stop LPDSVC")
RunWait(@COMSPEC & " /c net stop spooler")
RunWait(@COMSPEC & " /c net start spooler")
RunWait(@COMSPEC & " /c net start LPDSVC")

MsgBox(0,"Migration Completed","You may need to reboot to see the new printers",3)
EndFunc
