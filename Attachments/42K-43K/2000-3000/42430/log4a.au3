#include-once

; #INDEX# =======================================================================================================================
; Title .........: log4a
; AutoIt Version : 3.2
; Language ......: English
; Description ...: Functions that assist with logging.
; Author(s) .....: Michael Mims (zorphnog)
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_log4a_Debug
;_log4a_Error
;_log4a_Fatal
;_log4a_Info
;_log4a_Message
;_log4a_SetCompiledOutput
;_log4a_SetEnable
;_log4a_SetErrorStream
;_log4a_SetFormat
;_log4a_SetLogFile
;_log4a_SetMaxLevel
;_log4a_SetMinLevel
;_log4a_SetOutput
;_log4a_Trace
;_log4a_Warn
; ===============================================================================================================================

; Logging Enumerations
Global Enum $LOG4A_OUTPUT_CONSOLE,$LOG4A_OUTPUT_FILE,$LOG4A_OUTPUT_BOTH
Global Enum $LOG4A_LEVEL_TRACE,$LOG4A_LEVEL_DEBUG,$LOG4A_LEVEL_INFO, _
	$LOG4A_LEVEL_WARN,$LOG4A_LEVEL_ERROR,$LOG4A_LEVEL_FATAL

; Internal variables
Global Const $__aLog4aLevels[6] = ["Trace","Debug","Info","Warning","Error","Fatal"]
Global Const $__LOG4A_VERSION = "0.4"

; Internal - Default configuration options
Global $__LOG4A_LOG_FILE = StringFormat("%s.log", @ScriptFullPath) _
	 , $__LOG4A_ENABLED = False _
	 , $__LOG4A_WRITE_ERRSTREAM = True _
	 , $__LOG4A_OUTPUT = $LOG4A_OUTPUT_CONSOLE _
	 , $__LOG4A_COMPILED_OUTPUT = $LOG4A_OUTPUT_FILE _
	 , $__LOG4A_FORMAT = "${date} ${level} ${message}" _
	 , $__LOG4A_LEVEL_MIN = $LOG4A_LEVEL_TRACE _
	 , $__LOG4A_LEVEL_MAX = $LOG4A_LEVEL_FATAL


#region Configuration Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetCompiledOutput
; Description ...: Sets the logging output type for the compiled version of the script (Default: $LOG4A_OUTPUT_FILE)
; Syntax.........: _log4a_SetCompiledOutput($iOutput)
; Parameters ....: $iOutput - An integer specifying an output enumeration value. Must be one of the following:
;                  |$LOG4A_OUTPUT_CONSOLE = Direct output to the console (must compile with #AutoIt3Wrapper_Change2CUI=y directive).
;                  |$LOG4A_OUTPUT_FILE = Direct output to the log file.
;                  |$LOG4A_OUTPUT_BOTH = Direct output to both the console and the log file.
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid parameter
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetCompiledOutput($iOutput)
	If $iOutput < 0 Or $iOutput > $LOG4A_OUTPUT_BOTH Then Return SetError(1)
	$__LOG4A_COMPILED_OUTPUT = $iOutput
EndFunc   ;==>_log4a_SetCompiledOutput

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetEnable
; Description ...: Enables or disables logging messages (Default: Disabled).
; Syntax.........: _log4a_SetEnable($bEnable)
; Parameters ....: $bEnable - A boolean specifying whether logging is enabled (true) or disabled (false).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid parameter
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetEnable($bEnable = True)
	If Not IsBool($bEnable) Then Return SetError(1)
	$__LOG4A_ENABLED = $bEnable
EndFunc   ;==>_log4a_SetEnable

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetErrorStream
; Description ...: Enables or disables logging of the standard error stream (Default: Enabled).
; Syntax.........: _log4a_SetErrorStream($bEnable)
; Parameters ....: $bEnable - A boolean specifying whether error stream logging is enabled (true) or disabled (false).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid parameter
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetErrorStream($bEnable = True)
	If Not IsBool($bEnable) Then Return SetError(1)
	$__LOG4A_WRITE_ERRSTREAM = $bEnable
EndFunc   ;==>_log4a_SetErrorStream

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetFormat
; Description ...: Configures the format of logging messages (Default: "${date} ${level} ${message}").
; Syntax.........: _log4a_SetFormat($sFormat)
; Parameters ....: $sFormat - A string representing the log message format. Formats can include the following macros:
;                  |${date} = Long date (i.e. MM/DD/YYYY HH:MM:SS)
;                  |${host} = Hostname of local machine
;                  |${level} = The current log level
;                  |${message} = The log message
;                  |${newline} = Insert a newline
;                  |${shortdate} = Short date (i.e. MM/DD/YYYY)
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetFormat($sFormat)
	$__LOG4A_FORMAT = $sFormat
EndFunc   ;==>_log4a_SetFormat

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetLogFile
; Description ...: Sets the path of the log file (Default: "<ScriptFullPath>.log").
; Syntax.........: _log4a_SetLogFile($sFile)
; Parameters ....: $sFile - A string specifying the path of the log file.
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetLogFile($sFile)
	$__LOG4A_LOG_FILE = $sFile
EndFunc   ;==>_log4a_SetLogFile

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetMaxLevel
; Description ...: Configures the maximum log level to process messages (Default: $LOG4A_LEVEL_FATAL).
; Syntax.........: _log4a_SetMaxLevel($iLevel)
; Parameters ....: $iLevel - An integer specifying a level enumeration value. Must be one of the following:
;                  |$LOG4A_LEVEL_TRACE
;                  |$LOG4A_LEVEL_DEBUG
;                  |$LOG4A_LEVEL_INFO
;                  |$LOG4A_LEVEL_WARN
;                  |$LOG4A_LEVEL_ERROR
;                  |$LOG4A_LEVEL_FATAL
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid parameter
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetMaxLevel($iLevel)
	If $iLevel < 0 Or $iLevel > $LOG4A_LEVEL_FATAL Then Return SetError(1)
	$__LOG4A_LEVEL_MAX = $iLevel
EndFunc   ;==>_log4a_SetMaxLevel

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetMinLevel
; Description ...: Configures the minimum log level to process messages (Default: $LOG4A_LEVEL_TRACE).
; Syntax.........: _log4a_SetMinLevel($iLevel)
; Parameters ....: $iLevel - An integer specifying a level enumeration value. Must be one of the following:
;                  |$LOG4A_LEVEL_TRACE
;                  |$LOG4A_LEVEL_DEBUG
;                  |$LOG4A_LEVEL_INFO
;                  |$LOG4A_LEVEL_WARN
;                  |$LOG4A_LEVEL_ERROR
;                  |$LOG4A_LEVEL_FATAL
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid parameter
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetMinLevel($iLevel)
	If $iLevel < 0 Or $iLevel > $LOG4A_LEVEL_FATAL Then Return SetError(1)
	$__LOG4A_LEVEL_MIN = $iLevel
EndFunc   ;==>_log4a_SetMinLevel

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_SetOutput
; Description ...: Sets the logging output type for the non-compiled version of the script (Default: $LOG4A_OUTPUT_CONSOLE)
; Syntax.........: _log4a_SetOutput($iOutput)
; Parameters ....: $iOutput - An integer specifying an output enumeration value. Must be one of the following:
;                  |$LOG4A_OUTPUT_CONSOLE = Direct output to the console (SciTE output window if run in SciTE).
;                  |$LOG4A_OUTPUT_FILE = Direct output to the log file.
;                  |$LOG4A_OUTPUT_BOTH = Direct output to both the console and the log file.
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid parameter
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_SetOutput($iOutput)
	If $iOutput < 0 Or $iOutput > $LOG4A_OUTPUT_BOTH Then Return SetError(1)
	$__LOG4A_OUTPUT = $iOutput
EndFunc   ;==>_log4a_SetOutput

#endregion Configuration Functions

#region Message Functions
; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Message
; Description ...: Logs a message to the configured outputs.
; Syntax.........: _log4a_Message($sMessage, $eLevel, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $eLevel - An integer specifying a level enumeration value. Must be one of the following:
;                  |$LOG4A_LEVEL_TRACE
;                  |$LOG4A_LEVEL_DEBUG
;                  |$LOG4A_LEVEL_INFO
;                  |$LOG4A_LEVEL_WARN
;                  |$LOG4A_LEVEL_ERROR
;                  |$LOG4A_LEVEL_FATAL
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
;                  |1 = Invalid $eLevel parameter
;                  |2 = Level is out of range
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Message($sMessage, $eLevel = $LOG4A_LEVEL_INFO, $bOverride = False)
	If Not $__LOG4A_ENABLED And Not $bOverride Then Return
	If $eLevel < $LOG4A_LEVEL_TRACE Or $eLevel > $LOG4A_LEVEL_FATAL Then Return SetError(1)
	If ($eLevel < $__LOG4A_LEVEL_MIN Or $eLevel > $__LOG4A_LEVEL_MAX) And Not $bOverride Then Return SetError(2)

	Local $bConsole = False, $bFile = False, $iMethod = $__LOG4A_OUTPUT
	If @Compiled Then $iMethod = $__LOG4A_COMPILED_OUTPUT
	Local $sLine = __log4a_FormatMessage($sMessage, $__aLog4aLevels[$eLevel])

	Switch $iMethod
		Case $LOG4A_OUTPUT_CONSOLE
			$bConsole = True
		Case $LOG4A_OUTPUT_FILE
			$bFile = True
		Case $LOG4A_OUTPUT_BOTH
			$bConsole = True
			$bFile = True
	EndSwitch

	If $eLevel >= $LOG4A_LEVEL_ERROR Then
		If $__LOG4A_WRITE_ERRSTREAM Then
			ConsoleWriteError($sLine)
		ElseIf $bConsole Then
			ConsoleWrite($sLine)
		EndIf
	ElseIf $bConsole Then
		ConsoleWrite($sLine)
	EndIf

	If $bFile Then
		FileWrite($__LOG4A_LOG_FILE, $sLine)
	EndIf
EndFunc   ;==>_log4a_Message

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Trace
; Description ...: Logs a message at the trace level.
; Syntax.........: _log4a_Trace($sMessage, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Trace($sMessage, $bOverride = False)
	_log4a_Message($sMessage, $LOG4A_LEVEL_TRACE, $bOverride)
EndFunc   ;==>_log4a_LogTrace

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Debug
; Description ...: Logs a message at the debug level.
; Syntax.........: _log4a_Debug($sMessage, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Debug($sMessage, $bOverride = False)
	_log4a_Message($sMessage, $LOG4A_LEVEL_DEBUG, $bOverride)
EndFunc   ;==>_log4a_LogDebug

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Info
; Description ...: Logs a message at the info level.
; Syntax.........: _log4a_Info($sMessage, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Info($sMessage, $bOverride = False)
	_log4a_Message($sMessage, $LOG4A_LEVEL_INFO, $bOverride)
EndFunc   ;==>_log4a_LogInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Warn
; Description ...: Logs a message at the warn level.
; Syntax.........: _log4a_Warn($sMessage, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Warn($sMessage, $bOverride = False)
	_log4a_Message($sMessage, $LOG4A_LEVEL_WARN, $bOverride)
EndFunc   ;==>_log4a_LogWarning

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Error
; Description ...: Logs a message at the error level.
; Syntax.........: _log4a_Error($sMessage, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Error($sMessage, $bOverride = False)
	_log4a_Message($sMessage, $LOG4A_LEVEL_ERROR, $bOverride)
EndFunc   ;==>_log4a_LogError

; #FUNCTION# ====================================================================================================================
; Name...........: _log4a_Fatal
; Description ...: Logs a message at the fatal level.
; Syntax.........: _log4a_Fatal($sMessage, $bOverride)
; Parameters ....: $sMessage - A string containing the message to log.
;                  $bOverride - A boolean specifying to override log filters. If true, messages will be logged regardless of
;                               enabled status or log level range (min/max values).
; Return values .: Success - Returns 0
;                  Failure - Returns 0
;                  @Error  - 0 = No error.
; Author ........: Michael Mims (zorphnog)
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _log4a_Fatal($sMessage, $bOverride = False)
	_log4a_Message($sMessage, $LOG4A_LEVEL_FATAL, $bOverride)
EndFunc   ;==>_log4a_LogFatal

#endregion Message Functions

#region Internal Functions

Func __log4a_FormatMessage($sMessage, $sLevel)
	Local $sFormatted = $__LOG4A_FORMAT

	$sFormatted = StringReplace($sFormatted, "${date}", _
		StringFormat("%02d\\%02d\\%04d %02d:%02d:%02d", @MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC))
	$sFormatted = StringReplace($sFormatted, "${host}", @ComputerName)
	$sFormatted = StringReplace($sFormatted, "${level}", $sLevel)
	$sFormatted = StringReplace($sFormatted, "${message}", $sMessage)
	$sFormatted = StringReplace($sFormatted, "${newline}", @CRLF)
	$sFormatted = StringReplace($sFormatted, "${shortdate}", _
		StringFormat("%02d\\%02d\\%04d", @MON, @MDAY, @YEAR))
	$sFormatted &= @CRLF

	Return $sFormatted
EndFunc   ;==>__log4a_FormatMessage

#endregion Internal Functions