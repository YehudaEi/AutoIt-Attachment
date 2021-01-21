; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         Keller Giacomarro <kgiacomarro@coppellisd.com>
;
; Script Function:
;	CISD AutoShutdown
;
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
;AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 0)
;AutoItSetOption("WinTitleMatchMode", 4)
AutoItSetOption("TrayIconHide", 1)


; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------


HotKeySet("{ESC}", "Cancel")
HotKeySet("{ENTER}", "Cancel")

If $CmdLine[0] = 0 Then
	MsgBox(0,"","Debug Mode")	
	$ShutdownTime = 10 ;seconds
	$GraceTime = 0 ;seconds, cancels persistance
Else
	$ShutdownTime = $CmdLine[1] ;seconds
	$GraceTime = $CmdLine[2] ;seconds, 1 hour
EndIf

Func Cancel()
	$CancelShutdown = 1
EndFunc

;;;;;

do

$CancelShutdown = 0

HotKeySet("{ESC}", "Cancel")
HotKeySet("{ENTER}", "Cancel")

SoundSetWaveVolume(50)
;SoundPlay("c:\novell\truck.wav")

SplashTextOn("Coppell ISD AutoShutdown", "An AutoShutdown has been initiated on this computer.  To cancel the Shutdown, press ESC or ENTER", 400, 50, -1, -1, 16)

ProgressOn ("AutoShutdown in Progress", "AutoShutdown in Progress", "Shutdown in " & Int( ($ShutdownTime )/60 ) & ":" & StringFormat ("%02.f", Mod($ShutdownTime, 60)) & " minute(s).", 10, 10, 16)

	
For $i = 1 to $ShutdownTime step 1
	Sleep (1000)
	ProgressSet(($i*100/$ShutdownTime), "Shutdown in " & Int( ($ShutdownTime - $i)/60 ) & ":" & StringFormat ("%02.f", Mod($ShutdownTime-$i, 60) )& " minute(s).")
	If $CancelShutdown = 1 Then
		ExitLoop(1)
	EndIf
Next

ProgressOff()
SplashOff()

If $CancelShutdown = 0 Then
	Shutdown (12)	
	;MsgBox(0,"", "Shutdown!")
EndIf

HotKeySet("{ESC}")
HotKeySet("{ENTER}")


Sleep($GraceTime * 1000)

Until (($CancelShutdown = 0) OR ($GraceTime = 0))