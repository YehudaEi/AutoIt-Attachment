#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Timers.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <StaticConstants.au3>

#include "ExtMsgBox.au3"
#include "_NetworkStatistics.au3"

$BandwidthCheck = False

$IdleTimer = 0
While 1
	$aIPStats = _Network_IPStatistics()
	; Received = $aIPStats[2], Sent = $aIPStats[9]
	Sleep(995)
	$aIPStatsDelta = _Network_IPStatistics()
	$IPStatsDiff = ($aIPStatsDelta[2] - $aIPStats[2])
	ConsoleWrite($IPStatsDiff & @CRLF)
	If $IPStatsDiff < 100 And $BandwidthCheck = False Then
		$IdleTimer = TimerInit()
		$BandwidthCheck = True
		ConsoleWrite ($BandwidthCheck & @CRLF)
	ElseIf $IPStatsDiff > 100 And $BandwidthCheck = True Then
		$BandwidthCheck = False
		ConsoleWrite ($BandwidthCheck & @CRLF)
	EndIf
	If $BandwidthCheck = True Then Check()
WEnd

Func Check()
	$IdleTimerDiff = TimerDiff($IdleTimer)
	$Idle = _Timer_GetIdleTime()
	ConsoleWrite("Checking for system idle time. $Idle: " & $Idle & @CRLF & "$IdleTimerDiff: " & $IdleTimerDiff & @CRLF)
	If $IdleTimerDiff > (1000 * 60 * 5) And $Idle >= (1000 * 60 * 5) Then
		$sMsg  = "Your computer has been idle for over 5 minutes."  & @CRLF
		$sMsg &= "It appears that you are not downloading or uploading." & @CRLF & @CRLF
		$sMsg &= "If you wish to continue using your computer, click 'OK' and the timer will reset." & @CRLF & @CRLF
		$iRetValue = _ExtMsgBox (128, "&OK", "Auto Shutdown", $sMsg, 60)
		If $iRetValue = 9 Then Shutdown(32)
	EndIf
EndFunc

