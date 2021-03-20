#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Uninstall.exe
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
RunWait(@ComSpec & " /c " & 'net stop BRSHAGENT', "", @SW_HIDE)

if @osarch="X86" Then
	#RequireAdmin
RunWait(@ComSpec & " /c " &'nssm32 remove "BRSHAGENT" confirm', "", @SW_HIDE)
Else
	#RequireAdmin
RunWait(@ComSpec & " /c " &'nssm64 remove "BRSHAGENT" confirm', "", @SW_HIDE)
endif

Msgbox(0,"BRSH AGENT UNINSTALL",'BRSH AGENT Successfully uninstalled.',10)