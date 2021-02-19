#include-once

; #INDEX# =======================================================================================================================
; Title .........: ExitCodes
; AutoIt Version : 3.3.6.1++
; Language ......: English
; Description ...: Functions for using index strings to exit instead of remembering what exit codes you used already in your code
; Author(s) .....: c0deWorm
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not documented - function(s) no longer needed, will be worked out of the file at a later date
;
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ExitCount
;_ExitGetCode
;_ExitGetFunc
;_ExitGetIndex
;_ExitGetList
;_ExitGetLongDesc
;_ExitGetShortDesc
;_ExitListOnExit
;_ExitRegister
;_ExitUnregister
;_ExitUsing
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
;__ExitCodePadding
;__ExitGetListOnExit
; ===============================================================================================================================


; Notes on variable names:
; I used the data types listed in the UDF standards, but inserted a character for the scope.
; Scopes:   g=global, l=local, a=argument to a function
; Examples: $gavExitCodes  is a global array of variants
;           $liCode        is a function's local integer
;           $asIndexString is a string passed as a parameter to a function


Global $__gbExitListOnExitEnabled = True
Global $__gavExitCodes[1][5] = [[0]]
; $__gavExitCodes[x][0] = Index string (e.g. "invalid command line parameter")
; $__gavExitCodes[x][1] = Short description for help
; $__gavExitCodes[x][2] = Description to output to the console before exiting
; $__gavExitCodes[x][3] = Exit code (so you can have multiple "success" statuses with @ExitCode=0)
; $__gavExitCodes[x][4] = Function to call (perhaps to output a list of codes for help)
; Exit code, if not overridden in [x][3], is determined by the array index

OnAutoItExitRegister("__ExitGetListOnExit")

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitCount
; Description....: Returns a count of registered exit codes
; Syntax.........: _ExitCount()
; Parameters.....: None
; Return values..: Returns a count of registered exit codes
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
;
;==========================================================================================
Func _ExitCount()
	Return SetError(0, 0, $__gavExitCodes[0][0])
EndFunc   ;==>_ExitCount

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitGetCode
; Description....: Returns the exit code for a given index string
; Syntax.........: _ExitGetCode( "index string" )
; Parameters.....: index string
;                  |A text index to be referred to when calling _ExitUsing()
; Return values..: Success:
;                  Returns the exit code of the entry matching the index string
;                  Failure:
;                  |Returns -1 and sets @error:
;                  |1 - Index string not found
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitGetCode($asIndexString) ; Returns the exit code for a text index
	Local $i
	For $i = 1 To UBound($__gavExitCodes) - 1
		If $__gavExitCodes[$i][0] = $asIndexString Then
			If $__gavExitCodes[$i][3] = -1 Then ; Not overridden
				Return SetError(0, 0, $i)
			Else
				Return SetError(0, 0, $__gavExitCodes[$i][3])
			EndIf
		EndIf
	Next
	Return SetError(1, 0, -1)
EndFunc   ;==>_ExitGetCode

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitGetFunc
; Description....: Returns the name of the function to be called for the given index string
; Syntax.........: _ExitGetFunc( "index string" )
; Parameters.....: index string
;                  |A text index to be referred to when calling _ExitUsing()
; Return values..: Success:
;                  |Returns the name of the function to be called for the given index string
;                  Failure:
;                  |Returns an empty string and sets @error=1
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitGetFunc($asIndexString)
	Local $i
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][0] = $asIndexString Then Return SetError(0, 0, $__gavExitCodes[$i][4])
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>_ExitGetFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitGetIndex
; Description....: Returns a string or array of all the index strings that will result in a given exit code
; Syntax.........: _ExitGetIndex( code [, array] )
; Parameters.....: code
;                  |A numeric exit code to find all matching index strings
;                  |-1 will return all entries that use auto-assigned codes (have not been overridden)
;                  |Any other value will return entries with a matching exit code (including auto-generated values)
;                  array
;                  |Default is True - Set to false if you'd rather get a @CRLF delimited string back
; Return values..: Success:
;                  |Returns an array of index strings and sets @extended to a count of matches
;                  Failure:
;                  |Returns an empty string or array ([0]=0) and sets @error=1
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitGetIndex($aiCode, $abArray = True)
	Local $i, $lsReturn = "", $laEmpty[1] = [0]
	If $aiCode < -1 Then Return SetError(1, 0, $laEmpty)
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][3] = $aiCode Then $lsReturn &= $__gavExitCodes[$i][0] & @LF
		; If you're looking for a specific value and this one is auto-generated, see if the auto-generated value matches
		If $aiCode > -1 And $__gavExitCodes[$i][3] = -1 And $i = $aiCode Then $lsReturn &= $__gavExitCodes[$i][0] & @LF
	Next
	$laReturn = StringSplit(StringTrimRight($lsReturn, 1), @LF)
	If StringLen($lsReturn) = 0 Then
		If $abArray = True Then
			Return SetError(1, 0, $laEmpty)
		Else
			Return SetError(1, 0, "")
		EndIf
	Else
		If $abArray = True Then
			$laReturn = StringSplit(StringTrimRight($lsReturn, 1), @LF)
			Return SetError(0, $laReturn[0], $laReturn)
		Else
			$lsReturn = StringReplace($lsReturn, @LF, @CRLF) ; Instead of StringAddCR so @extended is the count of replacements
			Return SetError(0, @extended, $lsReturn)
		EndIf
	EndIf
EndFunc   ;==>_ExitGetIndex

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitGetList
; Description....: Returns an array or a string with a formatted list of current exit codes and their short descriptions
; Syntax.........: _ExitGetList( array [, pad [, "indent" [, "separator"]] )
; Parameters.....: array
;                  |Default is False - Set to true if you'd like to get an array back instead of a string
;                  pad
;                  |Default is True - Set to false if you do not want the exit codes padded to be right-justified
;                  indent
;                  |Characters prepend to each line of the output (spaces or a @TAB perhaps)
;                  separator
;                  |Text to separate the code from the description (Default is "=")
; Return values..: Success:
;                  |Returns an array or a string
;                  Failure:
;                  |Returns an empty array ([0]=0) or string and sets @error=1
; Author.........: c0deWorm
; Modified.......:
; Remarks........: Useful in usage output to show the user what exit codes to expect while scripting. Running your script with /listexitcodes will ConsoleWrite this list upon a normal script exit.
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitGetList($abArray = Default, $abPad = Default, $asIndent = "", $asSeparator = "=")
	Local $i, $liLen = 0
	If $abArray = Default Then $abArray = False
	If $abPad = Default Then $abPad = True
	If Not ($abArray = True Or $abArray = False) Then Return SetError(1, 0, "")
	If Not ($abPad = True Or $abPad = False) Then Return SetError(1, 0, "")
	If $abPad Then ; Find the exit code with the longest StringLen
		Local $liCode
		For $i = 1 To $__gavExitCodes[0][0]
			$liCode = $__gavExitCodes[$i][3]
			If $liCode = -1 Then $liCode = $i
			If StringLen($liCode) > StringLen($liLen) Then $liLen = StringLen($liCode)
		Next
	EndIf
	If $abArray Then
		Local $laReturn[UBound($__gavExitCodes)][2] ; New array of the same rows that will contain only the code and short description
		$laReturn[0][0] = $__gavExitCodes[0][0]
		For $i = 1 To $__gavExitCodes[0][0]
			If $__gavExitCodes[$i][3] = -1 Then
				$laReturn[$i][0] = $i ; Auto-generated (code is the index in the array)
			Else
				$laReturn[$i][0] = $__gavExitCodes[$i][3] ; Override code
			EndIf
			$laReturn[$i][1] = $__gavExitCodes[$i][1] ; Short description
		Next
		Return SetError(0, $laReturn[0][0], $laReturn)
	Else ; Return a string
		Local $lsReturn = ""
		For $i = 1 To $__gavExitCodes[0][0]
			If $__gavExitCodes[$i][3] = -1 Then
				$lsReturn &= $asIndent & __ExitCodePadding($i, " ", $liLen) & $asSeparator & $__gavExitCodes[$i][1] & @CRLF
			Else
				$lsReturn &= $asIndent & __ExitCodePadding($__gavExitCodes[$i][3], " ", $liLen) & $asSeparator & $__gavExitCodes[$i][1] & @CRLF
			EndIf
		Next
		Return SetError(0, $__gavExitCodes[0][0], $lsReturn)
	EndIf
EndFunc   ;==>_ExitGetList

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitGetLongDesc
; Description....: Returns the exit code for a given index string
; Syntax.........: _ExitGetLongDesc( "index string" )
; Parameters.....: index string
;                  |A text index to be referred to when calling _ExitUsing()
; Return values..: Success:
;                  |Returns the long description and sets @extended to the exit code of the entry
;                  Failure:
;                  |Returns an empty string and sets @error:
;                  |1 - Index string not found
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitGetLongDesc($asIndexString) ; Returns the long description for an index string
	Local $i
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][0] = $asIndexString Then Return SetError(0, $__gavExitCodes[$i][3], $__gavExitCodes[$i][2])
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>_ExitGetLongDesc

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitGetShortDesc
; Description....: Returns the exit code for a given index string
; Syntax.........: _ExitGetShortDesc( "index string" )
; Parameters.....: index string
;                  |A text index to be referred to when calling _ExitUsing()
; Return values..: Success:
;                  |Returns the Short description and sets @extended to the exit code of the entry
;                  Failure:
;                  |Returns an empty string and sets @error:
;                  |1 = Index string not found
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitGetShortDesc($asIndexString) ; Returns the short description for an index string
	Local $i
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][0] = $asIndexString Then Return SetError(0, $__gavExitCodes[$i][3], $__gavExitCodes[$i][1])
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>_ExitGetShortDesc

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitListOnExit
; Description....: Sets or retrieves the check for "/listexitcodes" is enabled upon exit
; Syntax.........: _ExitListOnExit( [enabled] )
; Parameters.....: enabled
;                  |True or False to force it on or off
; Return values..: Success:
;                  |Returns the current value (True or False)
;                  Failure:
;                  |Sets @error=1
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitListOnExit($abEnable = Default)
	Local $lbReturn
	If $abEnable = Default Then Return SetError(0, 0, $__gbExitListOnExitEnabled)
	If Not ($abEnable = True Or $abEnable = False) Then Return SetError(1, 0, -1)
	If $abEnable = True Then
		$__gbExitListOnExitEnabled = True
	Else
		$__gbExitListOnExitEnabled = False
	EndIf
	Return SetError(0, 0, $__gbExitListOnExitEnabled)
EndFunc   ;==>_ExitListOnExit

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitRegister
; Description....: Registers a set of exit data in the global array for use when exiting
; Syntax.........: _ExitRegister( "index string" [, "short description" [, "long description" [, code [, "function"]]]] )
; Parameters.....: index string
;                  |A text index to be referred to when calling _ExitUsing()
;                  short description
;                  |A short description for the command line help (Should be less than 70 characters to avoid line wrapping in a console window)
;                  long description
;                  |A long description to be written to the console when using _ExitUsing
;                  code
;                  |The exit code to be used with _ExitUsing()
;                  |-1 = The array index of the entry will be used as the exit code
;                  |0 = Exit code will be zero, so the long description may be used and still have a "successful" exit
;                  |1+ = A positive value will be used as the exit code instead of the array index
;                  function
;                  |A function to call just before exiting (parameters for this function are passed to _ExitUsing)
; Return values..: Returns the the array index of the entry and sets @extended to:
;                  |0 = New entry created
;                  |1 = Updated existing entry
; Author.........: c0deWorm
; Modified.......:
; Remarks........: Be careful that the function you call doesn't cause the script to crash, exit, or continue to run for a long period. This is designed to let you perform one last-ditch operation quickly before the script exits nicely.
; Related........:
; Link...........:
; Example........: Yes
;==========================================================================================
Func _ExitRegister($asIndexString, $asShortDescription = Default, $asLongDescription = Default, $aiOverrideCode = Default, $asFunction = Default)
	Local $i, $lbFound = False
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][0] = $asIndexString Then ; Search for an existing entry to update
			$lbFound = True
			ExitLoop
		EndIf
	Next
	If $lbFound = False Then ; Create a new entry and jump to it
		ReDim $__gavExitCodes[UBound($__gavExitCodes) + 1][UBound($__gavExitCodes, 2)]
		$i = UBound($__gavExitCodes) - 1
	EndIf
	If StringRight($asLongDescription, 2) <> @CRLF Then $asLongDescription &= @CRLF
	If $aiOverrideCode = Default Then $aiOverrideCode = -1
	$__gavExitCodes[$i][0] = $asIndexString
	$__gavExitCodes[$i][1] = $asShortDescription
	$__gavExitCodes[$i][2] = $asLongDescription
	$__gavExitCodes[$i][3] = $aiOverrideCode
	$__gavExitCodes[$i][4] = $asFunction
	$__gavExitCodes[0][0] += 1
	Return SetError(0, $lbFound, True)
EndFunc   ;==>_ExitRegister

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitUnregister
; Description....: Registers a set of exit data in the global array for use when exiting
; Syntax.........: _ExitUnregister( "index string" )
; Parameters.....: index string
;                  |A text index to be referred to when calling _ExitUsing()
; Return values..: Success:
;                  |Returns True
;                  Failure:
;                  |Returns False and sets @error=1
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
;==========================================================================================
Func _ExitUnregister($asIndexString)
	Local $i, $j
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][0] = $asIndexString Then
			For $j = $i + 1 To $__gavExitCodes[0][0]
				$__gavExitCodes[$j - 1][0] = $__gavExitCodes[$j][0]
				$__gavExitCodes[$j - 1][1] = $__gavExitCodes[$j][1]
				$__gavExitCodes[$j - 1][2] = $__gavExitCodes[$j][2]
				$__gavExitCodes[$j - 1][3] = $__gavExitCodes[$j][3]
				$__gavExitCodes[$j - 1][4] = $__gavExitCodes[$j][4]
			Next
			$__gavExitCodes[0][0] -= 1
			ReDim $__gavExitCodes[UBound($__gavExitCodes) - 1][UBound($__gavExitCodes, 2)] ; Shrink dim 1, keep dim 2 the same
			Return SetError(0, 0, True)
		EndIf
	Next
	Return SetError(1, 0, False)
EndFunc   ;==>_ExitUnregister

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExitUsing
; Description....: ConsoleWrites the corresponding long description and exits using the assigned code
; Syntax.........: _ExitUsing( "index string" [, param [, "function"]] )
; Parameters.....: index string
;                  |The index string of an existing entry
;                  param
;                  |A variable to pass to your custom function (Use an array if you need to pass more than one parameter)
;                  function
;                  |A function to call instead of the one registered
; Return values..: Success:
;                  |The long description is written to the console and the script exits using the appropriate code
;                  Failure:
;                  |Sets @error=1 if the index string isn't registered
; Author.........: c0deWorm
; Modified.......:
; Remarks........: Be careful that the function you call doesn't cause the script to crash, exit, or continue to run for a long period. This is designed to let you perform one last-ditch operation quickly before the script exits nicely.
; Related........:
; Link...........:
; Example........: Yes
;
;==========================================================================================
Func _ExitUsing($asIndexString, $avFuncParam = Default, $asFuncName = Default)
	Local $i, $j
	For $i = 1 To $__gavExitCodes[0][0]
		If $__gavExitCodes[$i][0] = $asIndexString Then
			If $__gavExitCodes[$i][2] <> Default Then ConsoleWrite($__gavExitCodes[$i][2])
			If $asFuncName = Default Then
				If $__gavExitCodes[$i][4] <> Default Then Call($__gavExitCodes[$i][4], $avFuncParam)
			Else
				Call($asFuncName, $avFuncParam) ; Override the one registered for this event
			EndIf
			If $__gavExitCodes[$i][3] = -1 Then
				Exit $i ; Exit code is the location of the index in the array
			Else
				Exit $__gavExitCodes[$i][3] ; Use override code
			EndIf
		EndIf
	Next
	Return SetError(1, 0, False)
EndFunc   ;==>_ExitUsing

; #INTERNAL_USE_ONLY# ===========================================================================================================
;
; Name...........: __ExitCodePadding
; Description....: Help function to right-justify the exit codes in _ExitGetList
; Syntax.........: __ExitCodePadding( code [, "padding" [, length]] )
; Parameters.....: code
;                  |Exit code to be padded
;                  padding
;                  |Characters to use for padding, default is a space character
;                  length
;                  |Minimum length of the string returned, default is 4 (Specifying "padding" longer than one character could result in over-padding)
; Return values..: A string with the padded number
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
;
;==========================================================================================
Func __ExitCodePadding($aiCode, $asPadding = " ", $anLength = 4)
	Local $i, $lsReturn = $aiCode
	While StringLen($lsReturn) < $anLength
		$lsReturn = $asPadding & $lsReturn
	WEnd
	Return SetError(0, 0, $lsReturn)
EndFunc   ;==>__ExitCodePadding

; #INTERNAL_USE_ONLY# ===========================================================================================================
;
; Name...........: __ExitGetListOnExit
; Description....: Helper function - Simply including this UDF file enables the use of "/listexitcodes" on the command-line to ConsoleWrite a list of exit codes upon normal exit.
; Syntax.........:
; Parameters.....: None
; Return values..: None
; Author.........: c0deWorm
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
;
;==========================================================================================
Func __ExitGetListOnExit()
	If $__gbExitListOnExitEnabled = True And StringInStr($CmdLineRaw, "/listexitcodes") Then ConsoleWrite("Exit codes (%ERRORLEVEL%): " & @CRLF & _ExitGetList())
EndFunc   ;==>__ExitGetListOnExit