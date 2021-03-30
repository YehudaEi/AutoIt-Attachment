#include-once

Global Enum $LOG_TRACE, $LOG_DEBUG, $LOG_INFO, $LOG_WARN, $LOG_ERROR, $LOG_FATAL
Local Const $LOG_LEVELSTRING[6] = ["TRACE", "DEBUG", "INFO ", "WARN ", "ERROR", "FATAL"]
Local $lastLogHandle = -1
Local $minLevel = $LOG_TRACE
Local $logFormat = _LogFormatDefault

Func LogFile($sFileName)
	$lastLogHandle = FileOpen($sFileName, 1 + 8)
EndFunc

Func LogLevel($iMinLevel)
	$minLevel = $iMinLevel
EndFunc

Func LogStart()
	LogMessageUnformatted("")
	LogMessageUnformatted("")
	LogInfo(@ScriptFullPath & " started.")
	LogMessageUnformatted("")
EndFunc

Func LogTrace($sMessage)
	LogMessage($LOG_TRACE, $sMessage)
EndFunc

Func LogDebug($sMessage)
	LogMessage($LOG_DEBUG, $sMessage)
EndFunc

Func LogInfo($sMessage)
	LogMessage($LOG_INFO, $sMessage)
EndFunc

Func LogWarn($sMessage)
	LogMessage($LOG_WARN, $sMessage)
EndFunc

Func LogError($sMessage)
	LogMessage($LOG_ERROR, $sMessage)
EndFunc

Func LogFatal($sMessage)
	LogMessage($LOG_FATAL, $sMessage)
EndFunc

Func LogMessage($iLevel = $LOG_INFO, $sMessage = "")
	If $lastLogHandle == -1 Then
		LogFile(@ScriptName & ".log")
	EndIf

	If $iLevel < $minLevel Then
		Return
	EndIf

	Local $sLevel = LogLevelToString($iLevel)
	If @error Then
		ConsoleWriteError("Log.au3: Invalid log level given!")
		Return SetError(2, 0, -1)
	EndIf

	$sMessage = $logFormat($sLevel, $sMessage)

	If $iLevel >= $LOG_ERROR Then
		ConsoleWriteError($sMessage & @CRLF)
	Else
		ConsoleWrite($sMessage & @CRLF)
	EndIf
	FileWriteLine($lastLogHandle, $sMessage)
EndFunc

Func LogMessageUnformatted($sMessage)
	If $lastLogHandle == -1 Then
		LogFile(@ScriptName & ".log")
	EndIf

	ConsoleWrite($sMessage & @CRLF)
	FileWriteLine($lastLogHandle, $sMessage)
EndFunc

Func LogLevelToString($iLevel)
	If $iLevel < 0 Or $iLevel > UBound($LOG_LEVELSTRING)-1 Then
		Return SetError(1, 0, "")
	EndIf

	Return $LOG_LEVELSTRING[$iLevel]
EndFunc

Func LogClose()
	FileClose($lastLogHandle)
	$lastLogHandle = -1
EndFunc

Func LogFormat($fFormatFunc)
	$logFormat = $fFormatFunc
EndFunc

Func _LogFormatDefault($sLevel, $sMessage)
	Return "[" & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " " & $sLevel & "] " & $sMessage
EndFunc