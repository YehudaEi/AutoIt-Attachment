#include <File.au3>

;Declare Variables
$FireFoxDir = @ProgramFilesDir & '\Mozilla FireFox\'
$FireFoxExe = $FireFoxDir & 'FireFox.exe'
$AddonsDir = @ScriptDir & '\Addons\'
$AddonsFiles = _FileListToArray($AddonsDir)
$FireFoxSetup = 0

;Finding firefox setup
$ScriptEXEs = _FileListToArray(@ScriptDir, '*.exe', 1)
For $i = 1 To $Files[0]
	$CompanyName = FileGetVersion('FireFox.exe', 'CompanyName')
	$FileDescription = FileGetVersion('FireFox.exe', 'FileDescription')
	If $CompanyName = 'Mozilla' And $FileDescription = 'Firefox' Then $FireFox = $Files[$i]
Next

;Create full path array for later commands
For $i = 1 To $AddonsFiles[0]
	$AddonsFiles[$i] = $AddonsDir & $AddonsFiles[$i]
Next

;Install firefox
RunWait($FireFox & ' /S')
ProcessClose('FireFox.exe')

;create default profile
RunWait($FireFoxExe & ' -CreateProfile default', $FireFoxDir)
ProcessClose('FireFox.exe')

;install themes and extensions
For $i = 1 To $AddonsFiles[0]
	Switch StringRight($AddonsFiles[$i], 3)
		Case 'xpi'
			RunWait($FireFoxExe & ' -install-global-extension "' & $AddonsFiles[$i] & '"', $FireFoxDir)
		Case 'jar'
			RunWait($FireFoxExe & ' -install-global-theme "' & $AddonsFiles[$i] & '"', $FireFoxDir)
		Case Else
			Sleep(0)
	EndSwitch
	;close firefox
	ProcessClose('FireFox.exe')
Next