#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Setup.exe
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Opt("TrayIconHide", 1) ;0=show, 1=hide tray icon
Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
	#RequireAdmin
RunWait(@ComSpec & " /c " & 'COPY /Y'&' "'&@ScriptDir&'\Data\nssm32.exe"'&' "'&@HomeDrive&'\windows\system32\'&'"', "", @SW_HIDE)
	#RequireAdmin
RunWait(@ComSpec & " /c " & 'COPY /Y'&' "'&@ScriptDir&'\Data\nssm64.exe"'&' "'&@HomeDrive&'\windows\system32\'&'"', "", @SW_HIDE)

if @osarch="X86" Then
	#RequireAdmin
RunWait(@ComSpec & " /c " & 'nssm32 install BRSHAGENT'&' "'&@ScriptDir&'\Data\brshwindowsagent.exe"'&' """BRSH WINDOWS AGENT"""', "", @SW_HIDE);If x86 OS then install 32bit Windows Service with NSSM32 tool.
Else
	#RequireAdmin
RunWait(@ComSpec & " /c " & 'nssm64 install BRSHAGENT'&' "'&@ScriptDir&'\Data\brshwindowsagent.exe"'&' """BRSH WINDOWS AGENT"""', "", @SW_HIDE);If x64 OS then install 64bit Windows Service with NSSM64 tool.
endif

	#RequireAdmin
RunWait(@ComSpec & " /c " & 'net start BRSHAGENT', "", @SW_HIDE)


if Not FileExists(@ScriptDir&"\Data\authentication.ini") then
Msgbox(0,"BRSH AGENT INSTALL","Authentication.ini file not found please control the file or create new one using info: first line= [AUTH] second line= KEY=YOURKEY"&@crlf,10)
else
Msgbox(0,"BRSH AGENT INSTALL",'BRSH AGENT Successfully installed.You can change the KEY file from address "'&@ScriptDir&'\Data\authentication.ini"',10)
endif

