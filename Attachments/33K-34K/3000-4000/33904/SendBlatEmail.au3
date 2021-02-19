#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /Convert_Vars=1 /Convert_Funcs=1 /Convert_Strings=1 /Convert_Numerics=1 /SCI=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.5.6 (beta)
 Author:         Sn3akyP3t3

 Script Function:
	Send text only email from Gmail SMTP with SSL authentication.

 Requirements:
  Blat and Stunnel executables.  Stunnel configuration file must be configured properly.

#ce ----------------------------------------------------------------------------
; Set these values
; Note that I don't recommend hardcoding username and password into the script.  If saved as clear text in the script then it is up to you to safely guard them.
; If anyone has suggestions on how to properly do this securely then please contact me via the Autoit Forums.
$sPassword = "" ; smtp authentication pwd
$sUsername = "@gmail.com" ; full gmail email address required
;smtp server and port given to stunnel config
$sSmptServerAddress = "127.0.0.1"
$sSmptPort = "1099"
$sBlatDirectory = "Q:\My Dropbox\Utilities\blat262\full"
$sStunnelDirectory = "Q:\My Dropbox\Utilities\blat262\stunnel-4.36"
$sSubject = "Subject is missing from command line"
$sBody = "Body is missing from the command line"

If $CmdLine[0] == 2 Then
	$sSubject = $CmdLine[1]
	$sBody = $CmdLine[2]
EndIf

startStunnel($sStunnelDirectory)
pullPassword()
EmailUsingBlat($sBlatDirectory, $sUsername, $sPassword, $sSmptServerAddress, $sSmptPort, "toEmailAddress12345678@reallyDoesNotExist.com", "fromEmailAddress12345678@reallyDoesNotExist.com", $sSubject, $sBody)
killStunnel()

Func startStunnel($sStunnelDir)
	; Usage: stunnel [ [-install | -uninstall | -start | -stop] [-quiet] [<filename>] ] | -help | -version | -sockets
	Run($sStunnelDir & "\stunnel.exe")
EndFunc

Func killStunnel()
	ProcessClose("stunnel.exe")
	If ProcessExists("stunnel.exe") Then ProcessClose("stunnel.exe")
EndFunc

Func EmailUsingBlat($sBlatDir, $sUn, $sPw, $sSmtpSvr, $sSmtpPt, $sTo, $sFrm, $sSubj, $sBdy)
	; If you are trying to debug then I suggest temporary enabling of logging add the next line to the last of the parameters
	;  & '" -log "' & @ScriptDir & '\blat.log"'
	ShellExecuteWait($sBlatDir & "\blat.exe", "-u " & $sUn & " -pw " & $sPw & " -serverSMTP " & $sSmtpSvr & " -portSMTP " & $sSmtpPt	& " -to " & $sTo & " -f " & $sFrm & ' -subject "' & $sSubj & '" -body "' & $sBdy, $sBlatDirectory, "", @SW_HIDE)
EndFunc
