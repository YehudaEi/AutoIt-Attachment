Dim $err, $rmtdrive
If Not FileExists("pslist.exe") Then
	$err = "Missing pslist.exe" & @CRLF
EndIf
If Not FileExists("psexec.exe") Then
	$err &= "Missing psexec.exe" & @CRLF
EndIf
If $err Then
	MsgBox(0, "Error!", $err & @CRLF & "Please download PSTools from" & @CRLF & _
			"http://www.sysinternals.com/" & @CRLF & "and copy these files into the same" & _
			@CRLF & "directory with this program.")
	Exit
EndIf

#region --- GuiBuilder code Start ---
#include <GuiConstants.au3>

GUICreate("Admin Remote Software Installer", 350, 340, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Title_1 = GUICtrlCreateLabel("MLANS Remote Updater", 80, 10, 200, 20)
GUICtrlSetFont($Title_1, 12, 700)

$Label_2 = GUICtrlCreateLabel("Workstation Name", 20, 43, 100, 20)
$PC_Name = GUICtrlCreateInput("", 120, 40, 170, 20)

$Label_3 = GUICtrlCreateLabel("Domain\Username", 20, 73, 100, 20)
$AdminUser = GUICtrlCreateInput("", 120, 70, 170, 20)

$Label_4 = GUICtrlCreateLabel("Password", 62, 103, 50, 20)
$AdminPW = GUICtrlCreateInput("", 120, 100, 170, 20, $ES_PASSWORD)

$Title_2 = GUICtrlCreateLabel("Select Applications to Install/Update", 50, 140, 300, 20)
GUICtrlSetFont($Title_2, 10, 700)

$AcroRead = GUICtrlCreateCheckbox("Acrobat Reader", 30, 170, 95, 20)
$Firefox = GUICtrlCreateCheckbox("Firefox 2", 30, 200, 90, 20)
$Quicktime = GUICtrlCreateCheckbox("Quicktime", 30, 230, 90, 20)
$iTunes = GUICtrlCreateCheckbox("iTunes", 30, 260, 90, 20)

$JRE = GUICtrlCreateCheckbox("Java Runtime", 190, 170, 90, 20)
$Flash = GUICtrlCreateCheckbox("Adobe Flash", 190, 200, 90, 20)
$SAV = GUICtrlCreateCheckbox("Symantec Antivirus", 190, 230, 110, 20)
$NSCPP = GUICtrlCreateCheckbox("Nagios Client", 190, 260, 110, 20)

;$UVNC		= GuiCtrlCreateCheckbox("UltraVNC", 190, 260, 90, 20)

$InstallBtn = GUICtrlCreateButton("Install!", 10, 300, 50, 30, $BS_DEFPUSHBUTTON)

$ExitBtn = GUICtrlCreateButton("Exit", 280, 310, 60, 20)
$ProgLabel = GUICtrlCreateLabel("", 70, 310, 210, 20)
GUICtrlSetFont($ProgLabel, 10, 700)
GUICtrlSetColor($ProgLabel, 0x0000FF)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $ExitBtn
			ExitLoop
			Exit
		Case $msg = $InstallBtn
			If Not GUICtrlRead($PC_Name) Or Not GUICtrlRead($AdminUser) Or Not GUICtrlRead($AdminPW) Then
				MsgBox(0, "Error!", "All text fields must be filled in before proceeding.")
				ContinueLoop
			Else
				PushInstall()
			EndIf
		Case Else
			;;;
	EndSelect
WEnd
Exit
#endregion --- GuiBuilder generated code End ---

Func PushInstall()
	GUICtrlSetData($InstallBtn, "Wait...")
	GUICtrlSetState($InstallBtn, $GUI_DISABLE)
	GUICtrlSetState($ExitBtn, $GUI_DISABLE)
	GUICtrlSetData($ProgLabel, "Checking connectivity...")
	; test connectivity
	$conntest = Ping(GUICtrlRead($PC_Name))
	If $conntest = 0 Then
		MsgBox(0, "Error!", "Host unreachable.")
		GUICtrlSetState($InstallBtn, $GUI_ENABLE)
		GUICtrlSetState($ExitBtn, $GUI_ENABLE)
		GUICtrlSetData($InstallBtn, "Install!")
		GUICtrlSetData($ProgLabel, "")
		Return 0
	EndIf

	GUICtrlSetData($ProgLabel, "Connecting to C$...")
	$rmtdrive = DriveMapAdd("*", "\\" & GUICtrlRead($PC_Name) & "\C$", 8, GUICtrlRead($AdminUser), GUICtrlRead($AdminPW))
	If $rmtdrive = "" Then
		MsgBox(0, "Error!", "Could not connect to remote share." & @CRLF & "Error Code: " & @error)
		GUICtrlSetState($InstallBtn, $GUI_ENABLE)
		GUICtrlSetState($ExitBtn, $GUI_ENABLE)
		GUICtrlSetData($InstallBtn, "Install!")
		GUICtrlSetData($ProgLabel, "")

		Return 0
	EndIf

	; runinstall($label, $location, $source, $filename, $instargs, $process, $check)
	Select
		Case GUICtrlRead($AcroRead) == 1 ; Acrobat Reader
			runinstall("Acrobat Reader", "web", "http://cis-web1/files/acroread811.exe", "acroread.exe", "", "acroread", "was not found")
;			ContinueCase
		Case GUICtrlRead($JRE) == 1 ; Java Runtime
			runinstall("Java Runtime", "web", "http://cis-web1/files/Java6u3.exe", "jre.exe", "", "jre", "was not found")
;			ContinueCase
		Case GUICtrlRead($Flash) == 1 ; Adobe Flash
			runinstall("Flash Player", "web", "http://cis-web1/files/flash_activex.exe", "flash.exe", "/s", "flash", "was not found")
;			ContinueCase
		Case GUICtrlRead($iTunes) == 1 ; Apple iTunes
			runinstall("iTunes", "web", "http://cis-web1/files/iTunes75Setup.exe", "itsetup.exe", "/quiet", "itsetup", "was not found")
;			ContinueCase
		Case GUICtrlRead($Quicktime) == 1 ; Apple Quicktime
			runinstall("QuickTime", "web", "http://cis-web1/files/QuickTime73.exe", "quicktime.exe", "/quiet", "quicktime", "was not found")
;			ContinueCase
		Case GUICtrlRead($Firefox) == 1 ; Mozilla Firefox
			runinstall("Firefox", "web", "http://cis-web1/files/Firefox_2.0.0.9.exe", "firefox.exe", "-ms", "firefox", "was not found")
;			ContinueCase
		Case GUICtrlRead($NSCPP) == 1 ; Nagios NSClient++
			runinstall("NSClient++", "web", "http://cis-web1/files/NSCPP-OCSS.exe", "nscpp.exe", "", "nscpp", "was not found")
;			ContinueCase
		Case GUICtrlRead($SAV) == 1 ; Symantec Antivirus client - always put this LAST becuase it may reboot the remote PC!
			runinstall("SAV Client", "unc", "", '"\\cis-sav\savclients$\av_only\setup.exe"', "", "setup", "was not found")
	EndSelect


	DriveMapDel($rmtdrive)
	GUICtrlSetState($InstallBtn, $GUI_ENABLE)
	GUICtrlSetState($ExitBtn, $GUI_ENABLE)
	GUICtrlSetData($InstallBtn, "Install!")
	GUICtrlSetData($ProgLabel, "Install complete.")
	Sleep(3000)
	GUICtrlSetData($ProgLabel, "")
	Return 0 ; for testing only....
EndFunc   ;==>PushInstall

#cs
	runinstall($label, $location, $source, $filename, $instargs, $process, $check)
	$label - descriptive label
	$location - source type - web or unc
	$source - uri for source file (http://server/file.exe path) or blank if running from UNC
	$filename - name of file on destination or full UNC path
	$instargs - installation arguements for silent install (if any)
	$process - name of running process during installation
	$check - test for end of install process (substring from pslist)
#ce

Func runinstall($label, $location, $source, $filename, $instargs, $process, $check)
	
	GUICtrlSetData($ProgLabel, "Installing " & $label)
	If $location = "web"  Then
		$filesize = InetGetSize($source)
		InetGet($source, $rmtdrive & "\" & $filename, 1, 0)
		While 1
			If FileGetSize($rmtdrive & "\" & $filename) = $filesize Then ExitLoop
		WEnd
	EndIf
	RunWait('psexec.exe \\' & GUICtrlRead($PC_Name) & ' -u ' & GUICtrlRead($AdminUser) & ' -p "' & GUICtrlRead($AdminPW) & '" -d c:\' & $filename & " " & $instargs, 'c:\', @SW_HIDE)

	While 1
		$pslist = Run('pslist.exe \\' & GUICtrlRead($PC_Name) & ' -u ' & GUICtrlRead($AdminUser) & ' -p "' & GUICtrlRead($AdminPW) & '" ' & $process, @SystemDir, @SW_HIDE, 6) ;6 = STDOUT + STDERR
		$line = StdoutRead($pslist)
		If StringInStr($line, $check) Then
			ExitLoop
		EndIf
	WEnd
	If FileExists($rmtdrive & "\" & $filename) Then
		FileDelete($rmtdrive & "\" & $filename)
	EndIf
EndFunc   ;==>runinstall