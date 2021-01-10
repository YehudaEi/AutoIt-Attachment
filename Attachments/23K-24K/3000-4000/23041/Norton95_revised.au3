#cs

	Norton Commander 95/NT Install + Deinstall
	------------------------------------------

#ce

#include <Constants.au3>
#include <File.au3>

$sCmdLine = "C:\Drivers\Norton5\Setup32\SETUP.EXE"  ;	V.4.20.6  01.10.96  42.572 Byte
$sWorkDir = "C:\Drivers\Norton5\Setup32"
$sPath = "I:\Patch\NC95"  ; @ProgramFilesDir & "\Norton Commander" --- MUSS Wert enthalten!
$sEditor = "I:\Program Files\UltraEdit\Uedit32.exe"  ;externer Editor
$sName = "dutCh"
$sOrg = "ACM Inc."

$iCmdDelay = 800  ;Sleep() in Loop --- z.B. Ablaufverfolgung
$iCntDlg = 2  ;Install-Dialogs --- Dialoge maximal 4000 Zeichen!
$iCntDel = 1  ;Deinstall-Dialogs

Dim $aDlg[100][8], $aDel[100][8]  ;100 Lines x 8 Commands pro Dialog

;================================ Installation ============================================================
;
; r = _RunLog(3)  w = WinWaitActive(3)  c = ControlCommand(5)  k = ControlClick(7)  s = Send(2)  1 = extra1
;
;==========================================================================================================

Dim $aDlg1[100][1 + 7] = [ _
	["r",  $sCmdLine, $sWorkDir, "0", "", "", "", ""], _  ;start install
	["w",  "Norton Commander", "Willkommen bei Symantec Setup", "", "", "", "", ""], _
	["c",  "Norton", "", "Edit1", "EditPaste", $sName, "", ""], _
	["s",  "{TAB}", "", "", "", "", "", ""], _
	["s",  "+{END}", "", "", "", "", "", ""], _
	["c",  "Norton", "", "Edit2", "EditPaste", $sOrg, "", ""], _
	["s",  "!w", "", "", "", "", "", ""], _
	["s",  "!w", "", "", "", "", "", ""], _
	["s",  "!a", "", "", "", "", "", ""], _
	["s",  "+{END}", "", "", "", "", "", ""], _
	["c",  "Norton", "Speicherort des Programms", "Edit1", "EditPaste", $sPath, "", ""], _
	["s",  "!w", "", "", "", "", "", ""], _
	["s",  "!w", "", "", "", "", "", ""], _
	["c",  "", "&NC starten", "Button2", "UnCheck", "", "", ""], _  ;diff in W9x und W2k
	["s",  "!w", "", "", "", "", "", ""], _
	["s",  "!w", "", "", "", "", "", ""], _
	["w",  "Norton", "StandardCare Support", "", "", "", "", ""], _  ;installiert...
	["s",  "!w", "", "", "", "", "", ""], _
	["s",  "{SPACE}", "", "", "", "", "", ""], _
	["s",  "{SPACE}", "", "", "", "", "", ""], _  ;diff in Win9x!
	["1",  "", "", "", "", "", "", ""], _  ;delete Temp Files
	["",  "", "", "", "", "", "", ""]]  ;letzte Zeile special

Dim $aDlg2[100][1 + 7] = [ _
	["r",  $sPath & "\NC.EXE", $sPath, "0", "", "", "", ""], _  ;start NC
	["w",  "NC Rechts", "1-Hilfe", "", "", "", "", ""], _
	["s",  "{F9}", "", "", "", "", "", ""], _
	["s",  "b", "", "", "", "", "", ""], _
	["s",  "o", "", "", "", "", "", ""], _
	["w",  "Konfigurationsoptionen", "Allg. Einstell.", "3", "", "", "", ""], _
	["c",  "", "&Kopieren",                          "Button2",  "UnCheck", "", "", ""], _  ;Bestätigungen
	["c",  "", "&Bewegen",                           "Button3",  "UnCheck", "", "", ""], _
	["c",  "", "&Löschen",                           "Button4",  "Check", "", "", ""], _
	["c",  "", "B&eenden",                           "Button5",  "UnCheck", "", "", ""], _
	["k",  "", "&Integriert",                        "Button7",  "", "", "", ""], _  ;Editor 1
	["k",  "", "E&xtern",                            "Button8",  "", "", "", ""], _  ;Editor 2
	["c",  "", "&Durch Kennwort schützen",           "Button10", "UnCheck", "", "", ""], _  ;Komprimierung
	["c",  "", "Ei&nrichtung automatisch speichern", "Button12", "Check", "", "", ""], _
	["c",  "", "Editor", "Edit1", "EditPaste", $sEditor, "", ""], _
	["s",  "^{TAB}", "", "", "", "", "", ""], _
	["w",  "Konfigurationsoptionen", "Bildschirm", "3", "", "", "", ""], _
	["c",  "", "&Werkzeugleiste",                 "Button2",  "Check", "", "", ""], _
	["c",  "", "&Statusleiste",                   "Button3",  "Check", "", "", ""], _
	["c",  "", "&Fensterstatusleiste",            "Button4",  "Check", "", "", ""], _
	["c",  "", "&DOS-Befehlszeile",               "Button5",  "Check", "", "", ""], _
	["c",  "", "&Registerleiste",                 "Button6",  "Check", "", "", ""], _
	["c",  "", "Fens&tertitelleiste",             "Button7",  "Check", "", "", ""], _
	["c",  "", "Fun&ktionstastenleiste",          "Button8",  "Check", "", "", ""], _
	["c",  "", "&Uhr",                            "Button9",  "Check", "", "", ""], _
	["c",  "", "&Versteckte Dateien anzeigen",    "Button10", "Check", "", "", ""], _
	["c",  "", "Ver&zeichnisse auswählen",        "Button11", "Check", "", "", ""], _
	["c",  "", "&Original Groß-/Kleinschreibung", "Button12", "Check", "", "", ""], _
	["c",  "", "&Einfügen bewegt nach unten",     "Button13", "Check", "", "", ""], _
	["c",  "", "&Auto-Verzeichniswechsel",        "Button14", "Check", "", "", ""], _
	["c",  "", "Auto&matische Menüs",             "Button15", "UnCheck", "", "", ""], _
	["c",  "", "Akt&iv",                          "Button18", "UnCheck", "", "", ""], _  ;Bildschirmschoner
	["s",  "^{TAB 2}", "", "", "", "", "", ""], _
	["w",  "Konfigurationsoptionen", "Kompatibilität", "3",  "", "", "", ""], _
	["k",  "", "A&nfangsbuchstabe (Umgeht DOS-Eingabeaufforderung)", "Button4",  "", "", "", ""], _  ;Schnellsuche in Fenstern 3
	["k",  "", "<&ALT>  (Setzt Windows-Standard außer Kraft)",       "Button3",  "", "", "", ""], _  ;Schnellsuche in Fenstern 2
	["k",  "", "<&STRG-ALT>",                                        "Button2",  "", "", "", ""], _  ;Schnellsuche in Fenstern 1
	["k",  "", "&Rechtsklicken wählt Dateien aus",                   "Button5",  "", "", "", ""], _  ;Maus 1
	["k",  "", "R&echtsklicken zeigt Menü an",                       "Button6",  "", "", "", ""], _  ;Maus 2
	["c",  "", "&In den Papierkorb verschieben",                     "Button7",  "Check", "", "", ""], _  ;Löschen
	["s",  "{ENTER}", "", "", "", "", "", ""], _
	["s",  "^q", "", "", "", "", "", ""], _  ;kick Qickview
	["w",  "Testen Sie Quick View Plus", "Für diesen Dateityp", "", "", "", "", ""], _
	["s",  "{SPACE}", "", "", "", "", "", ""], _
	["s",  "{ENTER}", "", "", "", "", "", ""], _
	["s",  "^q", "", "", "", "", "", ""], _
	["s",  "{F10}", "", "", "", "", "", ""], _
	["",  "", "", "", "", "", "", ""]]  ;letzte Zeile special

;==================================================== Deinstallation ====================================================
;
; dm = DirMove(2)  fm = FileMove(2)  dr = DirRemove(1)  fd = FileDelete(1) rk = RegDelete(1)  rv = RegDelete(2) key/value
;
;========================================================================================================================

Dim $aDel1[100][1 + 2] = [ _
	["dr",  $sPath, ""], _
	["dr",  @ProgramFilesDir & "\Norton Commander", ""], _  ;Default-Vorgabe, mit $sPath überschrieben
	["dr",  @ProgramsCommonDir & "\Norton Commander", ""], _  ;Startmenü
	["fd",  @DesktopDir & "\Norton Commander.LNK", ""], _
	["fd",  @WindowsDir & "\siwini.ini", ""], _
	["fd",  @WindowsDir & "\~SYMSHEL.EXE", ""], _
	["fd",  @WindowsDir & "\~SYMINST.EXE", ""], _
	["fd",  @WindowsDir & "\~SYMINST.PIF", ""], _
	["fd",  @WindowsDir & "\_SYMINST.BAT", ""], _
	["fd",  @WindowsDir & "\WININIT.SIW", ""], _
	["fm",  @WindowsDir & "\WININIT.INI", @WindowsDir & "\WININIT.BAK"], _
	["fd",  @SystemDir & "\Norton Commander-Logo-Animation.Scr", ""], _
	["fd",  @SystemDir & "\Norton Commander Sternenhimmel.Scr", ""], _
	["fd",  @SystemDir & "\SERIAL.SYS", ""], _
	["fd",  @SystemDir & "\PARPORT.SYS", ""], _
	["rk",  "HKLM\Software\Symantec", ""], _
	["rk",  "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Norton Commander", ""], _
	["rv",  "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager", "PendingFileRenameOperations"], _
	["rv",  "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce", "Symantec Installer for Windows"], _
	["rv",  "HKLM\System\CurrentControlSet\Control\Shutdown", "SetupProgramRan"], _
	["rk",  "HKCU\Software\Symantec", ""], _
	["",  "", ""]]  ;letzte Zeile special

;################################# ab hier keine Änderungen nötig #################################

$sLogFile = @ScriptDir & "\" & @ComputerName & "-" & @UserName & ".log"

Func _Log($string, $exit)
	_FileWriteLog($sLogFile, $string)
	If $exit Then Exit
EndFunc

Func _RunLog($cmdline, $workdir, $wait)
	_Log($cmdline, 0)

	If $wait Then
		RunWait($cmdline, $workdir)
	Else
		Run($cmdline, $workdir)
	EndIf

	If @error Then _Log("Ablauffehler!", 1)
EndFunc

_Log("-------------------------------------------------------", 0)
_Log(@OSVersion & " " & @OSServicePack & " Build: " & @OSBuild, 0)

Switch MsgBox($MB_YESNOCANCEL + $MB_ICONQUESTION, "AutoIt-Script", "Norton Commander 95/NT Install (Yes) oder Deinstall (No)?")
	Case $IDYES
		For $z = 1 To $iCntDlg
			For $y = 0 To 99
				For $x = 0 To 7
					$aDlg[$y][$x] = Execute("$aDlg" & $z & "[$y][$x]")
				Next
			Next

			For $cnt = 0 To UBound($aDlg) - 1
				Dim $p0 = $aDlg[$cnt][0], $p1 = $aDlg[$cnt][1], $p2 = $aDlg[$cnt][2], $p3 = $aDlg[$cnt][3]
				Dim $p4 = $aDlg[$cnt][4], $p5 = $aDlg[$cnt][5], $p6 = $aDlg[$cnt][6], $p7 = $aDlg[$cnt][7]

				Switch $p0
					Case "r"
						If $p3 = "0" Then $p3 = ""  ;Falle!
						_RunLog($p1, $p2, $p3)

					Case "w"
						If Not $p3 Then $p3 = 9  ;default timeout
						If Not WinWaitActive($p1, $p2, $p3) Then _Log("TimeOut: " & $p1 & " - " & $p2, 1)

					Case "c"
						ControlCommand($p1, $p2, $p3, $p4, $p5)

					Case "k"
						If Not $p5 Then $p5 = 1  ;single-click
						ControlClick($p1, $p2, $p3, $p4, $p5, $p6, $p7)

					Case "s"
						Send($p1, $p2)
					
					Case "1"
						FileDelete(@WindowsDir & "\~SYMINST.EXE")
							
						RegDelete("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager", "PendingFileRenameOperations")
					
						$fh = FileFindFirstFile("\~SIW*")
						If $fh = -1 Then ContinueLoop
						
						While 1 
							$tmp = FileFindNextFile($fh)
							If @error Then ExitLoop
							
							If FileExists("\" & $tmp & "\SIWDLL32.DLL") Then
								DirRemove("\" & $tmp, 1)
							EndIf
						WEnd
						
						FileClose($fh)
						
					Case ""
						ExitLoop

					Case Else
						_Log("Invalid Command: " & $p0, 1)
				EndSwitch

				Sleep($iCmdDelay)
			Next
		Next
		
		_Log("Installation erfolgreich.", 0)

	Case $IDNO
		_Log("Uninstall...", 0)

		For $z = 1 To $iCntDel
			For $y = 0 To 99
				For $x = 0 To 7
					$aDel[$y][$x] = Execute("$aDel" & $z & "[$y][$x]")
				Next
			Next

			$dir = IniRead(@WindowsDir & "\siwini.ini", "install", "tempdir", "")  ;bei Install-Abbruch
			If $dir Then DirRemove($dir, 1)

			For $cnt = 0 To UBound($aDel) - 1
				Dim $p0 = $aDel[$cnt][0], $p1 = $aDel[$cnt][1], $p2 = $aDel[$cnt][2]
				
				Switch $p0
					Case "dm"
						DirMove($p1, $p2, 1)  ;overwrite
					
					Case "fm"
						FileMove($p1, $p2, 1 + 8)  ;overwrite + create
					
					Case "dr"
						DirRemove($p1, 1)  ;files and dirs
					
					Case "fd"
						FileDelete($p1)
					
					Case "rk"
						RegDelete($p1)  ;complete key
					
					Case "rv"
						RegDelete($p1, $p2)  ;single value, (Default) value is ""
					
					Case ""
						ExitLoop
					
					Case Else
						_Log("Invalid Command: " & $p0, 1)

				EndSwitch
			Next
		Next

		_Log("Deinstallation erfolgreich.", 0)
		
	Case Else
		_Log("Abbruch!", 0)

EndSwitch
