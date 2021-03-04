#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#include <File.au3> ; Only Needed if $TemporaryDirectory parameter is omitted. If File.au3 is included already in your main script then remove this line and specify the temporary directory parameter when calling the Tweak_FF Function.
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.7.23 (beta)
	Author:         Decipher

	Script Function:
	Tweak All Mozilla Firefox Profiles Prefs.js File for Network & Miscellanous Optimization.

	Functions:
	Tweak_FF() Requires FFConfig.txt in script directory with correctly formatted configuration entries.

	Usage:
	_Tweak_FF($PromptTitle, $BackupLocation, $TemporaryDirectory, $PromptUser)
	$PromptTitle is Optional, Defaults to ""
	$BackupLocation is Optional, Defaults to Current User's Desktop Directory \ Name of Profile Directory, will create directory structure if it does not exist.
	$TemporaryDirectory is Optional, Defaults to temporary file. The file is guaranteed not to exist yet
	$PromptUser is Optional, Defaults to 1 = Yes Prompt User to Close Firefox, 0 = No Terminate Process Automatically

	Return 1 if no error occurred otherwise Returns 0 and sets @error and @extended macros.

	@extended:
	1 = Error reading FFConfig.txt.
	2 = User canceled prompt to close firefox.
	3 = Error locating profile directories.
	4 = Could not read profiles prefs.js file.
	5 = Error opening temporary prefs.js file for writing.
	6 = Error configuration entry in FFConfig.txt is incorrectly formatted.
	7 = Error overwriting prefs.js file with the newly generated configuration file.
	8 = Error a profile directory exists but does not contain a prefs.js file.
	9 = Temporary files were not deleted.
	10 = Some other error occured.

	Example:
	_Tweak_FF("Tweaking Firefox", @DesktopDir)

	Configuration Entries inside FFConfig.txt:

	user_pref("nglayout.initialpaint.delay", 0);
	user_pref("network.http.pipelining", true);
	user_pref("network.http.proxy.pipelining", true);
	user_pref("network.http.pipelining.maxrequests", 10);
	user_pref("network.dns.disableIPv6", false);
	user_pref("content.notify.backoffcount", 5);
	user_pref("plugin.expose_full_path", true);
	user_pref("ui.submenuDelay", 0);
	user_pref("config.trim_on_minimize", false);
	user_pref("browser.chrome.favicons", false);
	user_pref("browser.blink_allowed", false);
	user_pref("network.dns.disableIPv6", true);
	user_pref("network.dnsCacheEntries", 200);
	user_pref("network.dnsCacheExpiration", 240);
	user_pref("network.http.connect.timeout", 60);
	user_pref("network.http.keep-alive.timeout", 300);
	user_pref("network.http.max-connections-per-server", 16);
	user_pref("network.http.max-persistent-connections-per-proxy", 12);
	user_pref("layout.spellcheckDefault", 0);
	user_pref("browser.startup.homepage", "https://www.google.com/");

#ce ----------------------------------------------------------------------------

;_Tweak_FF("Test", @DesktopDir & "\BackupDirectory", "", 0)
;If @error Then MsgBox(0,"Test", @extended)

Func _Tweak_FF($PromptTitle = "Tweaking Firefox", $BackupLocation = @DesktopDir, $TemporaryDirectory = "", $PromptUser = 1)
	If $TemporaryDirectory = "" Then
		$TemporaryDirectory = _TempFile()
		DirCreate($TemporaryDirectory)
	EndIf
	Local $FileWrite, $FileLine, $PrefsString, $FileContents, $ProfileDirectory, $PrefsFile, $ComparisonString, $Option, $StrPosition, $StrChars, $CharsDiff, $Profiles
	$FileContents = FileRead(@ScriptDir & "\FFConfig.txt")
	If $FileContents = "" Then Return SetError(1, 1, 0)
	Local $FFTweak = StringSplit($FileContents, @CRLF, 3)
	$FileContents = ""
	If $PromptUser = 1 Then
		$Option = MsgBox(1 + 48 + 262144, $PromptTitle, "Firefox must be closed to apply tweaks correctly. You can close it manually or forcibly close Firefox's process by selecting continue. Firefox will be terminated automatically in 30 seconds.", 30)
		If $Option = 2 Then Return SetError(1, 2, 0)
	EndIf
	FileChangeDir(@AppDataDir & "\Mozilla\Firefox\Profiles")
	$Profiles = FileFindFirstFile("*.*")
	If $Profiles = -1 Then Return SetError(1, 3, 0)
	While 1
		$ProfileDirectory = FileFindNextFile($Profiles)
		If @error Then ExitLoop
		If $ProfileDirectory <> "" And FileExists(@AppDataDir & "\Mozilla\Firefox\Profiles\" & $ProfileDirectory & "\prefs.js") Then
			Local $User_Prefs_File_Location = @AppDataDir & "\Mozilla\Firefox\Profiles\" & $ProfileDirectory & "\prefs.js"
			If FileCopy($User_Prefs_File_Location, $BackupLocation & "\" & $ProfileDirectory & "\prefs.js", 9) Then
				$FileContents = FileRead($User_Prefs_File_Location)
				If $FileContents = "" Then Return SetError(1, 4, 0)
				$PrefsFile = FileOpen($TemporaryDirectory & "\prefs.js", 10)
				If $PrefsFile = -1 Then Return SetError(1, 5, 0)
				$FileLine = StringSplit($FileContents, ";")
				For $i = 1 To $FileLine[0]
					$FileWrite = True
					For $index2 = 0 To UBound($FFTweak, 1) - 1 Step 1
						$StrPosition = StringInStr($FFTweak[$index2], ",", 2, -1)
						If $StrPosition = 0 And StringIsSpace($FFTweak[$index2]) <> 0 Then Return SetError(1, 6, 0)
						$StrChars = StringLen($FFTweak[$index2])
						$CharsDiff = $StrChars - $StrPosition
						$ComparisonString = StringTrimRight($FFTweak[$index2], $CharsDiff)
						If StringInStr($FileLine[$i], $ComparisonString, 2) Then
							$FileWrite = False
						ElseIf StringIsSpace($FileLine[$i]) Then
							$FileWrite = False
						EndIf
					Next
					$PrefsString = StringStripWS($FileLine[$i], 2)
					If $FileWrite = True Then FileWrite($PrefsFile, $PrefsString & ";")
				Next
				FileWrite($PrefsFile, @CRLF)
				For $i = 0 To UBound($FFTweak, 1) - 1 Step 1
					If StringIsSpace($FileLine[$i]) = 0 Then FileWrite($PrefsFile, $FFTweak[$i] & @CRLF)
				Next
				FileClose($PrefsFile)
				While ProcessExists("firefox.exe") Or ProcessExists("plugin-container.exe")
					If ProcessClose("firefox.exe") <> 1 Then ProcessClose("plugin-container.exe")
					Sleep(50)
				WEnd
				If FileCopy($TemporaryDirectory & "\prefs.js", $User_Prefs_File_Location, 9) <> 1 Then
					If DirRemove($TemporaryDirectory, 1) <> 1 Then Return SetError(1, 9, 0)
					Return SetError(1, 7, 1)
				EndIf
			Else
				If DirRemove($TemporaryDirectory, 1) <> 1 Then Return SetError(1, 9, 0)
				Return SetError(1, 8, 0)
			EndIf
		EndIf
	WEnd
	If DirRemove($TemporaryDirectory, 1) <> 1 Then Return SetError(1, 9, 0)
	If @error Then Return SetError(1, 10, 0)
	Return 1
EndFunc   ;==>_Tweak_FF
