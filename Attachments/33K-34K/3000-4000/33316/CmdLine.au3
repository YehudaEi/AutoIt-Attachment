#include-once
; #FUNCTION# ====================================================================================================================
; Name...........: _CmdLine_GetClean
; Description ...: Strips leading AutoIt-parameters from $CMDLINERAW
; Syntax.........: _CmdLine_GetClean()
; Parameters ....:
; Return values .: $CMDLINERAW without AutoIt-parameters
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CmdLine_GetClean()
	Local Static $sLine=-1
	If IsString($sLine) Then Return $sLine
	$sLine = StringStripWS($CMDLINERAW, 2)
	Local $aRes
	While $sLine<>""
		$sLine = StringStripWS($sLine, 1)
		Switch StringLeft($sLine, 1)
			Case '"'
				$aRes = StringRegExp($sLine, '^"((?:[^"]|"")*)"(?!")', 1)
				If @error Then ExitLoop
				If FileGetLongName($aRes[0], 1) = FileGetLongName(@ScriptFullPath) Then
					$sLine = StringRegExpReplace($sLine, '^"(.*?)(?<!")"(?!")', "", 1)
				Else
					ExitLoop
				EndIf
			Case "/"
				$aRes = StringRegExp($sLine, "^(/\S*)", 1)
				If @error Then ExitLoop
				If $aRes[0] = "/ErrorStdOut" Then
					$sLine = StringTrimLeft($sLine, 12)
				ElseIf $aRes[0] = "/AutoIt3ExecuteScript" Or $aRes[0] = "/AutoIt3ExecuteLine" Then
					$sLine = StringRegExpReplace($sLine, '^/\S*\s*"(?:[^"]|"")*"(?!")|\S*', "", 1)
				Else
					ContinueCase
				EndIf
			Case Else
				$aRes = StringRegExp($sLine, '^(\S*)', 1)
				If @error Then ExitLoop
				If FileGetLongName($aRes[0], 1) = FileGetLongName(@ScriptFullPath) Then
					$sLine = StringRegExpReplace($sLine, '^(\S*)', "", 1)
				Else
					ExitLoop
				EndIf
		EndSwitch
	WEnd
	Return $sLine
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CmdLine_ParseParameters
; Description ...: Parses commandline parameters
; Syntax.........: _CmdLine_ParseParameters($sParameters [, $fSpaceForValue = True])
; Parameters ....: $sParameters     - string with parameters in commandline form
;                  $fSpaceForValue  - [optional] Allow space between a parameter and its value. (default: True)
;                  |If this parameter is false, a value must be separated via :, = or | from the argumentname.
;                  +Also, parameters are not required to be prefixed with --, +, -, /, | but it is allowed.
;                  |If it is true, also a space is allowed to separate argument and value, but all
;                  +parameters must be prefixed with --, +, -, / or |.
;                  $fUnescapeQuotes - [optional] Specify whether quotes in quote values are unescaped (default: false)
; Return values .: Success      - 2D-Array in the following format:
;                  |    $array[$i][0] : prefix
;                  |    $array[$i][1] : Parameter without prefix
;                  |    $array[$i][2] : Value with quotation marks (only if value has quotaion marks)
;                  |    $array[$i][3] : Value without quotation marks
;                  Failure      - 0 and @error <> 0
; Author ........: ProgAndy
; Modified.......:
; Remarks .......: Quotes inside of double quotes must be doubled to get them through: /param="Value with ""some"" quotes"
;                  This can be automatically reversed by setting $fUnescapeQuotes to True.
;                  Then $array[$i][3] will contain 'Value with "some" quotes'.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CmdLine_ParseParameters($sParameters, $fSpaceForValue=True, $fUnescapeQuotes=False)
    Local $y, $j, $i, $entry, $sRegex
	If $fSpaceForValue Then
		$sRegex = '\s*([-+|/]+)([^\s:|=]*)(?:(?:[:|=]|\h+(?![-+|/]))(?:("((?:[^"]|"")*)"(?!"))|(\S*)))?'
	Else
		$sRegex = '\s*([-+|/]*)([^\s:|=]*)(?:[:|=](?:("((?:[^"]|"")*)"(?!"))|(\S*)))?'
	EndIf
    Local $x = StringRegExp($sParameters,$sRegex,4)
    If @error Then Return SetError(@error,0,0)
    Local $ResultArray[UBound($x)][4]
    For $i = 0 To UBound($x)-1
        $entry = $x[$i]
        For $y = 1 To UBound($entry)-1
            $j = $y-1
            If $y > 4 Then $j = 3
            $ResultArray[$i][$j] = $entry[$y]
        Next
		If $fUnescapeQuotes And $ResultArray[$i][2] Then $ResultArray[$i][3] = StringReplace($ResultArray[$i][3], '""', '"', 0, 1)
    Next
    Return $ResultArray
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CmdLine_Split
; Description ...: Separates a filename and the given parameters
; Syntax.........: _CmdLine_Split($sCommand)
; Parameters ....: $sCommand     - string with command (filename + parameters)
; Return values .: Success - Array with 2 values.
;                  |[0] - the found filename.
;                  |[1] - the parameters
;                  Error  - 0 (No filename was found)
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CmdLine_Split($sCommand)
	Return StringRegExp($sCommand, '^\s*"?((?<=")[^"]+(?=")|\S+)"?\s*(.*)$', 3)
EndFunc