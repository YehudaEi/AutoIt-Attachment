#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.9.13 (Beta)
 Author:         jpm

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

FileChangeDir(@ScriptDir)

Local $nSleep = InputBox("Sleep setting", "give Sleep time in mSec?", 0)

Local $AutoItExe_x86 = StringReplace(@AutoItExe, 'autoit3_x64.exe', 'autoit3.exe')
Local $AutoItExe_x64= StringReplace(@AutoItExe, 'autoit3.exe', 'autoit3_x64.exe')

RunWait($AutoItExe_x86 & ' "#2367 $oIE.document twice (Sleep).au3" ' & $nSleep)

Sleep(1000) ; in case someting not really terminated ...

RunWait($AutoItExe_x64 & ' "#2367 $oIE.document twice (Sleep).au3" ' & $nSleep)
