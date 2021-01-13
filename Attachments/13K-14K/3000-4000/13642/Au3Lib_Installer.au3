#cs ----------------------------------------------------------------------------
Author:         G.Sandler a.k.a CreatoR
Script Function: Installer for Auto3Lib <by Paul Campbell (PaulIA)>
#ce ----------------------------------------------------------------------------

$AutoItDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir")
$AutioItBetaDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "betaInstallDir")

If FileExists($AutioItBetaDir) Then
	If MsgBox(36, "Question", "Are you using beta version?" & @LF & _
		"Press 'Yes' for installing Auto3Lib to beta folder (of installed AutoIt)") = 6 Then _
		$AutoItDir = $AutioItBetaDir
EndIf

If Not FileExists($AutoItDir & "\AutoIt3.exe") Then
	MsgBox(16, "Error!", "There was an error to find AutoIt install Dir." & @LF & _
	"Please choose folder with installed AutoIt...")
	$InitDir = @ProgramsDir
	While 1 
		$AutoItDir = FileSelectFolder("Please choose folder with installed AutoIt...", "", 4, $InitDir)
		If @error Then ExitLoop
		If Not FileExists($AutoItDir & "\AutoIt3.exe") Then
			MsgBox(16, "Error!", "This folder not include AutoIt files." & @LF & _
	"Please choose folder with installed AutoIt...")
			$InitDir = $AutoItDir
			ContinueLoop
		EndIf
		ExitLoop
	WEnd
	If Not FileExists($AutoItDir & "\AutoIt3.exe") Then
		MsgBox(64, "Exit...", "Sorry, can not find AutoIt install Dir." & @LF & _
	"Please install the AutoIt first (http://www.autoitscript.com/autoit3/) correctly, and then try again." & _
	@LF & @LF & "OK   --->   EXIT")
		Exit
	EndIf
EndIf

$IncludeDir = $AutoItDir & "\include"
$SciTEDir = $AutoItDir & "\SciTE"

_CopyFilesWithBackup(@ScriptDir & "\SciTE", $SciTEDir & "\api", "au3.user.calltips.api")

_CopyFilesWithBackup(@ScriptDir & "\include", $IncludeDir, "*.au3")
DirCopy(@ScriptDir & "\Examples", $AutoItDir & "\Examples\Auto3Lib", 9)
FileCopy(@ScriptDir & "\Help\Auto3Lib.chm", $AutoItDir, 1)

If MsgBox(36, "Shortcuts", "Would you like to put some shortcuts to quick launch panel and to the desktop?")=6 Then
	FileCreateShortcut($AutoItDir & "\Auto3Lib.chm", _
	@AppDataDir & "\Microsoft\Internet Explorer\Quick Launch\Auto3Lib_Help.lnk", $AutoItDir)
	FileCreateShortcut($AutoItDir & "\Examples\Auto3Lib", _
	@AppDataDir & "\Microsoft\Internet Explorer\Quick Launch\Auto3Lib_Examps.lnk", $AutoItDir)
	FileCreateShortcut($AutoItDir & "\Auto3Lib.chm", _
	@DesktopDir & "\Auto3Lib_Help.lnk", $AutoItDir)
	FileCreateShortcut($AutoItDir & "\Examples\Auto3Lib", _
	@DesktopDir & "\Auto3Lib_Examps.lnk", $AutoItDir)
EndIf

ShellExecute($AutoItDir & "\Examples\Auto3Lib")
ShellExecute($AutoItDir & "\Auto3Lib.chm")
	

Func _CopyFilesWithBackup($SourcePath, $DestPath, $Mask="*.*")
	If Not FileExists($SourcePath) Then Return SetError(1)
	If Not StringInStr(FileGetAttrib($SourcePath), "D") Then Return SetError(2)
	Local $CurrentSourceFile, $DestName, $Extended=0
	Local $FindFirstFile = FileFindFirstFile($SourcePath & "\" & $Mask)
	If $FindFirstFile = -1 Then Return SetError(3, 0, -1)
	While 1
		$CurrentSourceFile = FileFindNextFile($FindFirstFile)
		If @error Then ExitLoop
		$DestName = _NewFileName($CurrentSourceFile, $DestPath)
		$Extended += FileCopy($SourcePath & "\" & $CurrentSourceFile, $DestPath & "\" & $DestName, 8)
	WEnd
	FileClose($FindFirstFile)
	Return SetExtended($Extended)
EndFunc

Func _NewFileName($sFile, $dDir, $delim1="(", $delim2=")")
	$dDir = StringRegExpReplace ($dDir, "\\ *$", "")
	Local $sName= StringRegExpReplace ($sFile, "\.[^.]*$", "")
	Local $sExtn= StringMid ($sFile, StringLen ($sName) +1)
	Local $i=1, $dFile=$sFile
	While FileExists ($dDir & "\" & $dFile)
		$dFile = $sName & $delim1 & $i & $delim2 & $sExtn
		$i += 1
	WEnd
	Return $dFile
EndFunc