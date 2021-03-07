#include-once

; #INDEX# ======================================================================
; Title .........: GetOpt.au3
; Version  ......: 1.3
; Language ......: English
; Author(s) .....: dany
; Link ..........: http://www.autoitscript.com/forum/topic/143167-getoptau3-udf-to-parse-the-command-line/
; Description ...: AutoIt3 port of getopt(). Parse a command line c-style like
;                  using _GetOpt in a loop. GNU style options with - (and -- for
;                  long options) are supported as well as Windows / style options.
;                  See Forum link for an example.
;                  See http://www.gnu.org/software/libc/manual/html_node/Getopt.html
;                  for more information.
; Remarks .......: TODO:
;                  + Optionally enforce use of one option style only, no mixing.
;                  * Rewrite code to use a ByRef array as return value(s) where
;                    possible and Local-ize the rest. This would be version 2.0
;                    to mark fundamental difference in implementation.
;                  * More documentation in the source.
;                  CHANGELOG:
;                  Version 1.3:
;                  + Added support for -- (marks end of options).
;                  + Added support for + option modifiers e.g. +x.
;                  + Added support for /- option modifiers e.g. /-X.
;                  + Added _GetOpt_Sub to iterate through comma-separated
;                    suboptions like -s=a=foo,b=bar.
;                  * Changed $GETOPT_REQUIRED_ARGUMENT from keyword Default to
;                    Chr(127), keyword can now be used as an option argument.
;                  * Standardized comments and function headers.
;                  * Tidy-ed up source code.
;                  Version 1.2:
;                  + Support for required arguments with options, e.g.
;                    _GetOpt('ab:c') where -b=foo is valid and -b will return
;                    an error.
;                  + Added support for /C:foo (colon) when using DOS style.
;                  + Added optional auto-casting of command line arguments from
;                    Strings to AutoIt variants, e.g. -a=yes on the CLI would set
;                    the $GetOpt_Arg to True and not 'yes'. See __GetOpt_Cast
;                  * Private __GetOpt_DOSToGNU to simplify code.
;                  Version 1.1:
;                  * Initial public release.
; ==============================================================================

; #CURRENT# ====================================================================
;_GetOpt_Set
;_GetOpt
;_GetOpt_Raw
;_GetOpt_Oper
;_GetOpt_Sub
;_GetOpt_Rewind
; ==============================================================================

; #INTERNAL_USE_ONLY# ==========================================================
;__GetOpt_StartUp
;__GetOpt_DOSToGNU
;__GetOpt_ParseOpt
;__GetOpt_SubStart
;__GetOpt_SubStop
;__GetOpt_Cast
; ==============================================================================

; #CONSTANTS# ==================================================================
Global Const $GETOPT_VERSION = '1.3' ;  String: Version number.
Global Const $GETOPT_REQUIRED_ARGUMENT = Chr(127) ; String: Value to use for required arguments.
Global Const Enum $GETOPT_MOD_NONE = 0, $GETOPT_MOD_PLUS, $GETOPT_MOD_MINUS ; Int: Option modifiers.

; Int: @extended error return codes.
Global Const Enum $E_GETOPT_BAD_FUNCTION_ARGUMENT = 1, _
		$E_GETOPT_INVALID_OPTIONS, $E_GETOPT_NO_OPTIONS_SET, _
		$E_GETOPT_NO_COMMAND_LINE, $E_GETOPT_NO_OPTIONS, $E_GETOPT_NO_OPERANDS, _
		$E_GETOPT_UNKNOWN_OPTION, $E_GETOPT_MISSING_ARGUMENT, _
		$E_GETOPT_SUBOPTION_MISMATCH, $E_GETOPT_NO_SUBOPTIONS, $E_GETOPT_UNKNOWN_SUBOPTION

; #VARIABLES# ==================================================================
;Global $GetOpt_OptionStyle = 0 ; 0 = Mix (default), 1 = /Windows, 2 = --gnu ; Force style, not yet implemented.
Global $GetOpt_CastArguments = True ; Boolean: Whether or not to attempt to cast arguments to AutoIt variants when quering them. Default True.
Global $GetOpt_SubOptSeparator = ',' ; String: Suboption separator. Default ',' (comma).

Global $GetOpt_Opt = '' ; String: Current option.
Global $GetOpt_Long = '' ; String: Current long option, if any.
Global $GetOpt_Arg = '' ; Mixed: Argument for current option, if any.
Global $GetOpt_Ind = 0 ; Int: Option index in $GetOpt_Opts.
Global $GetOpt_Mod = 0 ; Int: Indicates option modifier. See $GETOPT_MOD_* constants.
Global $GetOpt_IndRaw = 0 ; Int: Raw option index in $GetOpt_Opts.
Global $GetOpt_OperInd = 0 ; Int: Operand index in $GetOpt_Opers.
Global $GetOpt_Opts[1] = [0] ; Array: Options.
Global $GetOpt_Opers[1] = [0] ; Array: Operands (non-options).
Global $GetOpt_SubOpt = '' ; String: Current suboption, if any.
Global $GetOpt_SubArg = '' ; Mixed: Current argument for suboption, if any.
Global $GetOpt_SubInd = 0 ; Int: Suboption index in $GetOpt_SubOpts.
Global $GetOpt_SubOpts[1] = [0] ; Array: Suboptions.

Global $GetOpt_ArgC = 0 ; Int: Number of arguments passed, this includes the running script/program ($CmdLine[0] + 1).
Global $GetOpt_ArgV[1] = [@ScriptName] ; Array: Array of arguments passed, this includes the running script/program at index 0 (modified $CmdLine).

; #INTERNAL_USE_ONLY# ==========================================================
Local $__GetOpt_fStartUp = False
Local $__GetOpt_aOpts[1][3] = [[0, 0, 0]]
Local $__GetOpt_fSubStart = False
Local $__GetOpt_sSubOpt = ''

; #FUNCTION# ===================================================================
; Name...........: _GetOpt_Set
; Description ...: Set an array of options used by the program.
; Syntax.........: _GetOpt_Set($aOpts)
; Parameters ....: $aOpts  - Array: 2-dim array with program options.
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0, sets @error to 1 and sets @extended:
;                  |1 $E_GETOPT_BAD_FUNCTION_ARGUMENT Argument is wrong variant.
;                  |2 $E_GETOPT_INVALID_OPTIONS The options array has a wrong
;                  +number of subscripts.
;                  |4 $E_GETOPT_NO_COMMAND_LINE No command line to parse.
; Author ........: dany
; Modified ......:
; Remarks .......: The options array has three entries:
;                  |[0][0] Short option.
;                  |[0][1] Long option version.
;                  |[0][2] Default value.
;                  |Set the value to $GETOPT_REQUIRED_ARGUMENT if the option
;                  +requires an argument to be passed.
; Related .......: _GetOpt, _GetOpt_Raw, _GetOpt_Oper, _GetOpt_Rewind
;===============================================================================
Func _GetOpt_Set($aOpts)
	If 0 = $CmdLine[0] Then Return SetError(1, $E_GETOPT_NO_COMMAND_LINE, 0)
	If Not IsArray($aOpts) Then Return SetError(1, $E_GETOPT_BAD_FUNCTION_ARGUMENT, 0)
	If 3 > UBound($aOpts, 2) Then Return SetError(1, $E_GETOPT_INVALID_OPTIONS, 0)
	Local $i, $iMax = UBound($aOpts)
	ReDim $__GetOpt_aOpts[$iMax + 1][3]
	$__GetOpt_aOpts[0][0] = $iMax
	For $i = 0 To $iMax - 1
		$aOpts[$i][0] = __GetOpt_DOSToGNU($aOpts[$i][0])
		$aOpts[$i][1] = __GetOpt_DOSToGNU($aOpts[$i][1])
		$__GetOpt_aOpts[$i + 1][0] = $aOpts[$i][0]
		$__GetOpt_aOpts[$i + 1][1] = $aOpts[$i][1]
		$__GetOpt_aOpts[$i + 1][2] = $aOpts[$i][2]
	Next
	__GetOpt_StartUp()
	Return 1
EndFunc   ;==>_GetOpt_Set

; #FUNCTION# ===================================================================
; Name...........: _GetOpt
; Description ...: Get the next available option from the command line.
; Syntax.........: _GetOpt($sOpts)
; Parameters ....: $sOpts  - String: Containing all available options.
; Return values .: Success - String: The current option.
;                  Failure - String: '?' in case the option is not recognized.
;                  |- String: ':' in case the option is missing a required argument.
;                  |- Int: 0 if anything else went wrong or no options are left.
;                  |Sets @error to 1 and sets @extended:
;                  |1 $E_GETOPT_BAD_FUNCTION_ARGUMENT Argument is wrong variant.
;                  |2 $E_GETOPT_NO_OPTIONS_SET No program options set.
;                  |4 $E_GETOPT_NO_COMMAND_LINE No command line to parse.
;                  |5 $E_GETOPT_NO_OPTIONS No options passed.
;                  |7 $E_GETOPT_UNKNOWN_OPTION Current option is unknown.
;                  |8 $E_GETOPT_MISSING_ARGUMENT The current option is missing a
;                  +required argument.
; Author ........: dany
; Modified ......:
; Remarks .......: $sOpts Something like 'abc' where each letter represents an
;                  +option as set with _GetOpt_Set. Options with a colon : require
;                  +an argument ('ab:c').
; Related .......: _GetOpt_Raw, _GetOpt_Oper
;===============================================================================
Func _GetOpt($sOpts)
	If 0 = $CmdLine[0] Then Return SetError(1, $E_GETOPT_NO_COMMAND_LINE, 0)
	If Not IsString($sOpts) Then Return SetError(1, $E_GETOPT_BAD_FUNCTION_ARGUMENT, 0)
	__GetOpt_StartUp()
	If 0 = $GetOpt_Opts[0] Then Return SetError(1, $E_GETOPT_NO_OPTIONS, 0)
	If $GetOpt_Ind + 1 > $GetOpt_Opts[0] Then Return 0
	Local $i, $aOpt, $iLong = 0, $sLongOpt = ''
	$GetOpt_Opt = ''
	$GetOpt_Long = ''
	$GetOpt_Arg = ''
	$GetOpt_Mod = $GETOPT_MOD_NONE
	$aOpt = __GetOpt_ParseOpt($GetOpt_Opts[$GetOpt_Ind + 1])
	If '--' = $aOpt[0] Then Return 0
	If IsArray($__GetOpt_aOpts) Then
		If '+' = StringLeft($aOpt[0], 1) Then
			$aOpt[0] = StringReplace($aOpt[0], '+', '-', 1)
			$GetOpt_Mod = $GETOPT_MOD_PLUS
		ElseIf '*' = StringLeft($aOpt[0], 1) Then
			$aOpt[0] = StringReplace($aOpt[0], '*', '-', 1)
			$GetOpt_Mod = $GETOPT_MOD_MINUS
		EndIf
		If '--' = StringLeft($aOpt[0], 2) Then $iLong = 1
		For $i = 1 To $__GetOpt_aOpts[0][0]
			If $aOpt[0] = $__GetOpt_aOpts[$i][$iLong] Then
				$aOpt[0] = $__GetOpt_aOpts[$i][0]
				$sLongOpt = $__GetOpt_aOpts[$i][1]
				If '' = $aOpt[1] Then
					$aOpt[1] = $__GetOpt_aOpts[$i][2]
				Else
					If $GetOpt_CastArguments Then $aOpt[1] = __GetOpt_Cast($aOpt[1])
				EndIf
				ExitLoop
			EndIf
		Next
	Else
		Return SetError(1, $E_GETOPT_NO_OPTIONS_SET, 0)
	EndIf
	$aOpt[0] = StringReplace($aOpt[0], '-', '')
	$GetOpt_Opt = $aOpt[0]
	$GetOpt_Long = $sLongOpt
	$GetOpt_Arg = $aOpt[1]
	$GetOpt_Ind += 1
	; recycle
	$iLong = StringInStr($sOpts, $aOpt[0])
	If Not $iLong Then Return SetError(1, $E_GETOPT_UNKNOWN_OPTION, '?')
	If ':' = StringMid($sOpts, $iLong + 1, 1) Then
		If $GETOPT_REQUIRED_ARGUMENT = $aOpt[1] Then Return SetError(1, $E_GETOPT_MISSING_ARGUMENT, ':')
	EndIf
	Return $GetOpt_Opt
EndFunc   ;==>_GetOpt

; #FUNCTION# ===================================================================
; Name...........: _GetOpt_Raw
; Description ...: Get the next available option from the command line.
; Syntax.........: _GetOpt_Raw()
; Return values .: Success - String: The current raw option as in $CmdLine.
;                  Failure - Int: Returns 0, sets @error to 1 and sets @extended:
;                  |4 $E_GETOPT_NO_COMMAND_LINE No command line to parse.
;                  |5 $E_GETOPT_NO_OPTIONS No options passed.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _GetOpt, _GetOpt_Oper
;===============================================================================
Func _GetOpt_Raw()
	If 0 = $CmdLine[0] Then Return SetError(1, $E_GETOPT_NO_COMMAND_LINE, 0)
	__GetOpt_StartUp()
	If 0 = $GetOpt_Opts[0] Then Return SetError(1, $E_GETOPT_NO_OPTIONS, 0)
	If $GetOpt_IndRaw + 1 > $GetOpt_Opts[0] Then Return 0
	$GetOpt_IndRaw += 1
	Return $GetOpt_Opts[$GetOpt_IndRaw]
EndFunc   ;==>_GetOpt_Raw

; #FUNCTION# ===================================================================
; Name...........: _GetOpt_Oper
; Description ...: Get the next available operand from the command line.
; Syntax.........: _GetOpt_Oper()
; Return values .: Success - String: The current operand.
;                  Failure - Int: Returns 0, sets @error to 1 and sets @extended:
;                  |4 $E_GETOPT_NO_COMMAND_LINE No command line to parse.
;                  |6 $E_GETOPT_NO_OPERANDS No operands passed.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _GetOpt, _GetOpt_Raw
;===============================================================================
Func _GetOpt_Oper()
	If 0 = $CmdLine[0] Then Return SetError(1, $E_GETOPT_NO_COMMAND_LINE, 0)
	__GetOpt_StartUp()
	If 0 = $GetOpt_Opers[0] Then Return SetError(1, $E_GETOPT_NO_OPERANDS, 0)
	If $GetOpt_OperInd + 1 > $GetOpt_Opers[0] Then Return 0
	$GetOpt_OperInd += 1
	Return $GetOpt_Opers[$GetOpt_OperInd]
EndFunc   ;==>_GetOpt_Oper

; #FUNCTION# ===================================================================
; Name...........: _GetOpt_Sub
; Description ...: Get the next available suboption from an option.
; Syntax.........: _GetOpt_Sub($sSubOption, $aSubOpts)
; Parameters ....: $sSubOption - String:
;                  $aSubOpts - Array:
; Return values .: Success - String: The current suboption.
;                  Failure - Int: Returns 0, sets @error to 1 and sets @extended:
;                  |1 $E_GETOPT_BAD_FUNCTION_ARGUMENT Argument is wrong variant.
;                  |4 $E_GETOPT_NO_COMMAND_LINE No command line to parse.
;                  |9 $E_GETOPT_SUBOPTION_MISMATCH Passed suboption is different
;                  +from the one stored internally.
;                  |10 $E_GETOPT_NO_SUBOPTIONS No suboptions to parse.
;                  |11 $E_GETOPT_UNKNOWN_SUBOPTION Current suboption is unknown.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _GetOpt
;===============================================================================
Func _GetOpt_Sub($sSubOption, $aSubOpts)
	If 0 = $CmdLine[0] Then Return SetError(1, $E_GETOPT_NO_COMMAND_LINE, 0)
	If Not IsString($sSubOption) Then Return SetError(1, $E_GETOPT_BAD_FUNCTION_ARGUMENT, 0)
	If Not IsArray($aSubOpts) Then Return SetError(1, $E_GETOPT_BAD_FUNCTION_ARGUMENT, 0)
	If Not $__GetOpt_fSubStart Then __GetOpt_SubStart($sSubOption)
	If $__GetOpt_sSubOpt <> $sSubOption Then Return SetError(1, $E_GETOPT_SUBOPTION_MISMATCH, 0)
	If 0 = $GetOpt_SubOpts[0] Then
		__GetOpt_SubStop()
		Return SetError(1, $E_GETOPT_NO_SUBOPTIONS, 0)
	EndIf
	If $GetOpt_SubInd + 1 > $GetOpt_SubOpts[0] Then
		__GetOpt_SubStop()
		Return 0
	EndIf
	Local $i, $iMax = UBound($aSubOpts) - 1
	Local $aParsed = __GetOpt_ParseOpt($GetOpt_SubOpts[$GetOpt_SubInd + 1])
	$GetOpt_SubInd += 1
	$GetOpt_SubOpt = $aParsed[0]
	$GetOpt_SubArg = $aParsed[1]
	For $i = 0 To $iMax
		If $aSubOpts[$i][0] = $aParsed[0] Then
			If '' = $GetOpt_SubArg Then
				$GetOpt_SubArg = $aSubOpts[$i][1]
			Else
				If $GetOpt_CastArguments Then $GetOpt_SubArg = __GetOpt_Cast($GetOpt_SubArg)
			EndIf
			Return $GetOpt_SubOpt
		EndIf
	Next
	Return SetError(1, $E_GETOPT_UNKNOWN_SUBOPTION, '?')
EndFunc   ;==>_GetOpt_Sub

; #FUNCTION# ===================================================================
; Name...........: _GetOpt_Rewind
; Description ...: Rewind all iteration functions and variables.
; Syntax.........: _GetOpt_Rewind()
; Return values .: 1, always.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _GetOpt, _GetOpt_Raw, _GetOpt_Oper
;===============================================================================
Func _GetOpt_Rewind()
	__GetOpt_StartUp()
	$GetOpt_Opt = ''
	$GetOpt_Long = ''
	$GetOpt_Arg = ''
	$GetOpt_Ind = 0
	$GetOpt_Mod = 0
	$GetOpt_IndRaw = 0
	$GetOpt_OperInd = 0
	__GetOpt_SubStop()
	Return 1
EndFunc   ;==>_GetOpt_Rewind

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __GetOpt_StartUp
; Description ...: Parses raw command line and normalizes arguments to GNU style.
; Syntax.........: __GetOpt_StartUp()
; Return values .: 1, always.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only
;===============================================================================
Func __GetOpt_StartUp()
	If $__GetOpt_fStartUp Then Return 1
	Local $i, $fEndOfOpts = False, $aParsed = $CmdLine
	$GetOpt_ArgC = $CmdLine[0] + 1
	ReDim $GetOpt_ArgV[$GetOpt_ArgC]
	For $i = 1 To $aParsed[0]
		$GetOpt_ArgV[$i] = $aParsed[$i]
		$aParsed[$i] = __GetOpt_DOSToGNU($aParsed[$i])
		If Not $fEndOfOpts And StringRegExp($aParsed[$i], '^[-+*]') Then
			$GetOpt_Opts[0] += 1
			ReDim $GetOpt_Opts[$GetOpt_Opts[0] + 1]
			$GetOpt_Opts[$GetOpt_Opts[0]] = $aParsed[$i]
			If '--' = $aParsed[$i] Then $fEndOfOpts = True
		EndIf
	Next
	For $i = 1 To $aParsed[0]
		If Not StringInStr('-+*', StringLeft($aParsed[$i], 1)) Then
			$GetOpt_Opers[0] += 1
			ReDim $GetOpt_Opers[$GetOpt_Opers[0] + 1]
			$GetOpt_Opers[$GetOpt_Opers[0]] = $aParsed[$i]
		EndIf
	Next
	$__GetOpt_fStartUp = True
	Return _GetOpt_Rewind()
EndFunc   ;==>__GetOpt_StartUp

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __GetOpt_DOSToGNU
; Description ...: Translates DOS style options to GNU style.
; Syntax.........: __GetOpt_DOSToGNU($sOpt)
; Parameters ....: $sOpt   - String: Current raw option.
; Return values .: String: Translated GNU style option.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only
;===============================================================================
Func __GetOpt_DOSToGNU($sOpt)
	If StringInStr($sOpt, ':') And Not StringInStr($sOpt, '=') Then
		If StringRegExp($sOpt, '^[/+-]') Then $sOpt = StringReplace($sOpt, ':', '=', 1)
	EndIf
	If '/' = StringLeft($sOpt, 1) And '//' <> StringLeft($sOpt, 2) Then
		$sOpt = StringReplace($sOpt, '/-', '*', 1)
		If 0 = @extended Then $sOpt = StringReplace($sOpt, '/', '-', 1)
		If 2 < StringLen($sOpt) And '=' <> StringMid($sOpt, 3, 1) Then
			$sOpt = StringReplace($sOpt, '-', '--', 1)
		EndIf
	EndIf
	Return $sOpt
EndFunc   ;==>__GetOpt_DOSToGNU

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __GetOpt_ParseOpt
; Description ...: Splits raw option into option and passed argument.
; Syntax.........: __GetOpt_ParseOpt($sOpt)
; Parameters ....: $sOpt   - String: Current raw option.
; Return values .: Array: With index 0 = option and 1 = argument.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only
;===============================================================================
Func __GetOpt_ParseOpt($sOpt)
	Local $iPos, $aParsed[2]
	$iPos = StringInStr($sOpt, '=')
	If 0 = $iPos Then $iPos = StringLen($sOpt) + 1
	$aParsed[0] = StringMid($sOpt, 1, $iPos - 1)
	$aParsed[1] = StringMid($sOpt, $iPos + 1)
	Return $aParsed
EndFunc   ;==>__GetOpt_ParseOpt

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __GetOpt_SubStart
; Description ...: Sets variables for use with _GetOpt_Sub.
; Syntax.........: __GetOpt_SubStart($sSubOption)
; Return values .: 1, always.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only
;===============================================================================
Func __GetOpt_SubStart($sSubOption)
	If $__GetOpt_fSubStart Then Return 1
	__GetOpt_SubStop()
	Local $i, $aSubOpts = StringSplit($sSubOption, $GetOpt_SubOptSeparator)
	$__GetOpt_sSubOpt = $sSubOption
	ReDim $GetOpt_SubOpts[1]
	$GetOpt_SubOpts[0] = 0
	For $i = 1 To $aSubOpts[0]
		$GetOpt_SubOpts[0] += 1
		ReDim $GetOpt_SubOpts[$GetOpt_SubOpts[0] + 1]
		$GetOpt_SubOpts[$GetOpt_SubOpts[0]] = $aSubOpts[$i]
	Next
	$__GetOpt_fSubStart = True
	Return 1
EndFunc   ;==>__GetOpt_SubStart

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __GetOpt_SubStop
; Description ...: Resets all variables dealing with suboptions.
; Syntax.........: __GetOpt_SubStop()
; Return values .: 1, always.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only
;===============================================================================
Func __GetOpt_SubStop()
	ReDim $GetOpt_SubOpts[1]
	$GetOpt_SubOpts[0] = 0
	$GetOpt_SubOpt = ''
	$GetOpt_SubArg = ''
	$GetOpt_SubInd = 0
	$__GetOpt_sSubOpt = ''
	$__GetOpt_fSubStart = False
	Return 1
EndFunc   ;==>__GetOpt_SubStop

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __GetOpt_Cast
; Description ...: Attempt to cast a String to a different AutoIt variant based
;                  on it's content.
; Syntax.........: __GetOpt_Cast($sArg)
; Parameters ....: $sArg   - String: Current argument.
; Return values .: Mixed: Float, Int, Default, True, False or String variant.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only
;===============================================================================
Func __GetOpt_Cast($sArg)
	If StringIsFloat($sArg) Then Return Number($sArg)
	If StringIsInt($sArg) Then Return Int($sArg)
	If 'Default' = $sArg Then Return Default
	If StringRegExp($sArg, '^(?i)(true|y(es)?)$') Then Return True
	If StringRegExp($sArg, '^(?i)(false|no?)$') Then Return False
	Return String($sArg)
EndFunc   ;==>__GetOpt_Cast