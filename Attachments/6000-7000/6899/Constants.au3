; Global Constants
#include <file.au3>
;Main Directories
Global Const $SystemDir = @HomeDrive & "\windows\system32"
Global Const $WinDir = @HomeDrive & "\windows"
Global Const $DocumentSettingsDir = @HomeDrive & "\documents and settings"
Global Const $CurUserDir = @HomeDrive & "\documents and settings\" & @UserName
Global Const $CookiesDir = $CurUserDir & "\cookies"
Global Const $TempDir = @HomeDrive & "\windows\temp"
;Get Java Version
$java = _FileListToArray (@ProgramFilesDir & "\java\")
If (IsArray($java)) Then
 Global $JavaVer = $java[1]
Else
 $JavaVer = "Java Not Installed"
EndIf
;Windows Version
Global Const $WindowsVer = @OSTYPE
Global Const $Build = @OSBuild
Global Const $ServicePack = @OSServicePack
Global Const $Language = @OSLang
;Processor
Global Const $Processor = @ProcessorArch
;SystemDir
;WinDir
;DocumentSettingsDir
;CurUserDir
;CookiesDir
;TempDir
;JavaVer
;WindowsVer
;Build
;ServicePack
;Processor