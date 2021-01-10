;===============================================================================
;
; File: Coroutine.au3
; Description: UDF Library used for coroutine multithreading
; Version: 1.0.4
; Date: 7/19/06
; Author: Ben Brightwell
; Credit: ChrisL for the base idea of deploying files as child scripts. Topic
;			can be found here:
;			http://www.autoitscript.com/forum/index.php?showtopic=22048
;
;===============================================================================

;===============================================================================
#cs
	Changelog:
	
	7/19/06 (1.0.4) - Fixed bug where using the substring "func" anywhere in a
						line of code caused it to be truncated. Now the only
						limitation is that the substrings "func" and "endfunc"
						cannot be found at the beginning of a line of code.
	
	4/25/06 (1.0.3) - Fixed bug with using variables that contained the word
						"return"
					- Fixed bug with StringLower()-ing every line of code
						in coroutine script, now case is untouched
					- Fixed the way _CoInclude() works so that included code
						is placed at the top of the file instead of the bottom
					- Fixed a bug with passing a simple string to the script
						an extra dimension indicator was present
	
	4/15/06 (1.0.2) - Truncated version number (Builds are irrelevant)
					- Added support for expressions in the return statement
						of a coroutine
						
	3/23/06 (1.0.1.0) - Modified _CoCreate() to handle a function with no 
							parameters
					  - Added "Core Function List" and "Miscellaneous Function 
							List"
					  - Added this Changelog
					  - Changed _CoAddHelper() to _CoInclude()
					  - Fixed a bug in _CoInclude() where the last line of code
							was not being read into the script file
#ce
;===============================================================================

;===============================================================================
#cs
	Core Function List:
	
	_CoCreate()
	Create a coroutine script which can be instanced by _CoStart()
	
	_CoInclude()
	Include helper/wrapper functions to compliment the main body created by
		_CoCreate()
	
	_CoStart()
	Create an instance of a threaded function as created by _CoCreate()
	
	_CoYield()
	NOTE: Only to be used in coroutine scripts
		Pauses the coroutine and yields a value to the main script, returns
		any value passed by the corresponding call to _CoResume()
	
	_CoStatus()
	Returns the status of a coroutine
	
	_CoSend()
	Sends a variable into a child script
	
	_CoResume()
	Unpauses a coroutine, optionally sends a value back to the yielded
		coroutine
	
	_CoGetReturn()
	Retrieves a variable returned by a coroutine
	
	_CoKill()
	Closes a coroutine
	
	_CoCleanup()
	Closes all running coroutines, and deletes their respective temporary script
		files
	
	_CoChangeWorkingDir
	Changes the working directory for storing the temporary script files.
		NOTE: Default is @TempDir
	
	Miscellaneous Function List:
		NOTE: These functions are meant to be called internally by Coroutine.au3
	
	_PackVarToStr()
	Packs a variable into a string for transmission between scripts.
	
	_UnpackStrToVar()
	Unpacks a packed variable-string into its original structure, whether it be
		a string or array.
	
	_RandomFileName()
	Generates a random unused filename for use with _CoCreate()
#ce
;===============================================================================

Local $avCoThreads[1][2] ;[n] == iCoThreadID [n][0] == sFilePath [n][1] == iNumParams
$avCoThreads[0][0] = 0 ;Number of Multi-threaded Functions
Local $avPIDs[1][2] ;[n][0] == iPID [n][1] == iCoThreadID
$avPIDs[0][0] = 0 ;Number of iPID's created
Local $sWorkingDir = @TempDir

;===============================================================================
;
; Function Name:    _CoCreate()
; Description:      Create a child script for use with _CoStart()
; Parameter(s):     $sFuncRawText - A delimited string containing the lines of
;						the threaded function. Default delimiter is "|". Example:
;						"Func MyFunc($test1)|Return $test1|EndFunc"
;					$sDelimiter - A string containing the delimiter used in
;						$sFuncRawText (Default = "|")
; Return Value(s):  On Success - Returns the CoThreadID associated with the 
;									created thread.
;                   On Failure - 0 and @error set to:
;									1 - Invalid delimiter or delimiter not found
;									2 - File could not be created, check working 
;										directory access permissions
;									3 - Function parameters not formatted 
;										correctly. Try eliminating white space:
;										Ex: Func MyFunc($test1,$test2,$test3)
;									4 - Return line not formatted correctly.
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoCreate($sFuncRawText, $sDelimiter = "|")
	Local $asFuncLines = StringSplit($sFuncRawText, $sDelimiter)
	Local $bUnpackStrToVarUsed = 1 ; Determines if source for _UnpackStrToVar() is required in child script
	Local $bPackVarToStrUsed = 0 ; Determines if source for _PackVarToStr() is required in child script
	Local $bCoYieldUsed = 0 ; Determines if source for _CoYield() is required in child script
	Local $hFile = "" ; For writing to the child script file
	Local $asParams = "" ; Array of parameters pulled from the line: "Func MyFunction($test1, $test2, $test3)" in $sFuncRawText
	Local $asReturnLine = "" ; Line parsed from $sFuncRawText to contain the value that is passed as "Return $value"
	If IsArray($asFuncLines) Then
		ReDim $avCoThreads[$avCoThreads[0][0] + 2][2]
		$avCoThreads[0][0] += 1
		$avCoThreads[$avCoThreads[0][0]][0] = _RandomFileName()
		$hFile = FileOpen($avCoThreads[$avCoThreads[0][0]][0], 2)
		If $hFile == -1 Then
			SetError(2) ; File could not be created, check working directory access permissions
			Return 0 ; failure
		EndIf
		$asParams = StringRegExp($asFuncLines[1] & " ", "(\$.*?)(?:[ ,\\)])", 3)
		If IsArray($asParams) Then
			$avCoThreads[$avCoThreads[0][0]][1] = UBound($asParams)
			If IsArray($asParams) Then
				FileWriteLine($hFile, 'Local $sParamsInStr = "" ; Used to pass in parameters')
				FileWriteLine($hFile, 'Local $iNumChrsToRead = 0 ; Used for parameter strings longer than 64Kb')
				FileWriteLine($hFile, 'Local $sReturnStr = ""')
				FileWriteLine($hFile, 'While ConsoleRead(0,true) == 0')
				FileWriteLine($hFile, '	 Sleep(10)')
				FileWriteLine($hFile, 'WEnd')
				FileWriteLine($hFile, '$sParamsInStr = ConsoleRead()')
				FileWriteLine($hFile, '$iNumChrsToRead = StringRegExp($sParamsInStr, "(\d*?)(\#)(?:\$\[)", 1)')
				FileWriteLine($hFile, '$sParamsInStr = StringTrimLeft($sParamsInStr, $iNumChrsToRead[1])')
				FileWriteLine($hFile, 'While StringLen($sParamsInStr) < $iNumChrsToRead[0]')
				FileWriteLine($hFile, '	 $sParamsInStr &= ConsoleRead()')
				FileWriteLine($hFile, 'WEnd')
				For $i = 0 To UBound($asParams) - 1
					FileWriteLine($hFile, $asParams[$i] & " = _UnpackStrToVar($sParamsInStr)")
				Next
			EndIf
		ElseIf Not StringInStr($asFuncLines[1], "$") Then
			FileWriteLine($hFile, ';No function parameters')
		Else
			SetError(3) ; Function parameters not formatted correctly
			Return 0 ; failure
		EndIf
		For $i = 1 To $asFuncLines[0] - 1
			If StringInStr($asFuncLines[$i], "return ") And Not StringInStr($asFuncLines[$i], ";") And Not StringInStr($asFuncLines[$i], "=") Then
				$asReturnLine = StringRegExp($asFuncLines[$i], "(?i:return[:space:]*)(.*)", 1)
				If IsArray($asReturnLine) Then
					FileWriteLine($hFile, '$sExpStr = ' &$asReturnLine[0])
					FileWriteLine($hFile, '$sExpStr = _PackVarToStr($sExpStr)')
					FileWriteLine($hFile, 'ConsoleWrite("return" & StringLen($sExpStr) & $sExpStr)')
					$bPackVarToStrUsed = 1
				Else
					SetError(4) ; Return line not formatted correctly
					Return 0 ; failure
				EndIf
			ElseIf StringInStr($asFuncLines[$i], "func") == 1 Or StringInStr($asFuncLines[$i], "endfunc") == 1 Then
				FileWriteLine($hFile, $asFuncLines[$i])
				If StringInStr($asFuncLines[$i], "_coyield") Then
					$bCoYieldUsed = 1
				EndIf
			EndIf
		Next
		If $bCoYieldUsed == 1 Then
			FileWriteLine($hFile, 'Func _CoYield($bPeek, $sVarName = "")')
			FileWriteLine($hFile, '	 If $bPeek == 1 Then')
			FileWriteLine($hFile, '	 	If ConsoleRead(0,true) <> 0 Then')
			FileWriteLine($hFile, '	 		$vResumeVar = ConsoleRead()')
			FileWriteLine($hFile, '	 		$vResumeVar = _UnpackStrToVar($vResumeVar)')
			FileWriteLine($hFile, '	 		SetExtended(1)')
			FileWriteLine($hFile, '	 		Return $vResumeVar')
			FileWriteLine($hFile, '	 	Else')
			FileWriteLine($hFile, '	 		SetExtended(0)')
			FileWriteLine($hFile, '	 		Return ""')
			FileWriteLine($hFile, '	 	EndIf')
			FileWriteLine($hFile, '	 Else')
			FileWriteLine($hFile, '	 	Local $vVarNameEval = "" ; If $sVarName equates to a declared variable, a copy of it is stored here')
			FileWriteLine($hFile, '	 	Local $vResumeVar = "" ; When _CoResume() is called to unpause script, a variable can be passed')
			FileWriteLine($hFile, '	 	If StringLeft($sVarName, 1) == "$" Then StringReplace($sVarName, "$", "")')
			FileWriteLine($hFile, '	 	If IsDeclared($sVarName) Then')
			FileWriteLine($hFile, '			$vVarNameEval = Eval($sVarName)')
			FileWriteLine($hFile, '			$vVarNameEval = _PackVarToStr($vVarNameEval)')
			FileWriteLine($hFile, '			ConsoleWrite("yield" & StrLen($vVarNameEval) & $vVarNameEval)')
			FileWriteLine($hFile, '	 	Else')
			FileWriteLine($hFile, '			$vVarName = _PackVarToStr($vVarName)')
			FileWriteLine($hFile, '			ConsoleWrite("yield" & StrLen($vVarName) & $vVarName')
			FileWriteLine($hFile, '	 	EndIf')
			FileWriteLine($hFile, '	 	While ConsoleRead(0,true) == 0')
			FileWriteLine($hFile, '			Sleep(10)')
			FileWriteLine($hFile, '	 	WEnd')
			FileWriteLine($hFile, '	 	$vResumeVar = ConsoleRead()')
			FileWriteLine($hFile, '	 	$vResumeVar = _UnpackStrToVar($vResumeVar)')
			FileWriteLine($hFile, '	 	Return $vResumeVar')
			FileWriteLine($hFile, '	 EndIf')
			FileWriteLine($hFile, 'EndFunc')
		EndIf
		If $bUnpackStrToVarUsed == 1 Then
			FileWriteLine($hFile, 'Func _UnpackStrToVar(ByRef $sVarStr)')
			FileWriteLine($hFile, '	Local $aiNumDims = StringRegExp($sVarStr, ''(?:\$\[)(\d*)(?:\]\$)(\#)'', 1)')
			FileWriteLine($hFile, '	Local $aiDimSizes[1] ; To contain the size of each dimension as passed through $sVarStr')
			FileWriteLine($hFile, '	Local $aiDimSize = "" ; To contain the size of current dimension and string position for stripping')
			FileWriteLine($hFile, '	Local $avRetArr[1] ; To be redimensioned and have $sVarStr parsed and stored into as an array')
			FileWriteLine($hFile, '	Local $avElementStr = "" ; To contain each element as a string as it is parsed from $sVarStr')
			FileWriteLine($hFile, '	If IsArray($aiNumDims) Then')
			FileWriteLine($hFile, '		$sVarStr = StringTrimLeft($sVarStr, $aiNumDims[1])')
			FileWriteLine($hFile, '		If $aiNumDims[0] > 0 Then')
			FileWriteLine($hFile, '			ReDim $aiDimSizes[$aiNumDims[0]]')
			FileWriteLine($hFile, '			For $iCounter1 = 0 To $aiNumDims[0] - 1')
			FileWriteLine($hFile, '				$aiDimSize = StringRegExp($sVarStr, ''(?:\$\[)(\d*)(?:\]\$)(\#)'', 1)')
			FileWriteLine($hFile, '				$aiDimSizes[$iCounter1] = $aiDimSize[0]')
			FileWriteLine($hFile, '				$sVarStr = StringTrimLeft($sVarStr, $aiDimSize[1])')
			FileWriteLine($hFile, '			Next')
			FileWriteLine($hFile, '		EndIf')
			FileWriteLine($hFile, '		Select')
			FileWriteLine($hFile, '			Case $aiNumDims[0] == 0')
			FileWriteLine($hFile, '				If StringInStr($sVarStr, "$[") Then')
			FileWriteLine($hFile, '					$avElementStr = StringRegExp($sVarStr, ''(.*?)(\#)(?:\$\[)'', 1)')
			FileWriteLine($hFile, '					$sVarStr = StringTrimLeft($sVarStr, $avElementStr[1])')
			FileWriteLine($hFile, '					If $avElementStr[0] <> "<nil>" Then')
			FileWriteLine($hFile, '						Return $avElementStr[0]')
			FileWriteLine($hFile, '					Else')
			FileWriteLine($hFile, '						Return ""')
			FileWriteLine($hFile, '					EndIf')
			FileWriteLine($hFile, '				Else')
			FileWriteLine($hFile, '					If $sVarStr == "<nil>" Then')
			FileWriteLine($hFile, '						Return ""')
			FileWriteLine($hFile, '					Else')
			FileWriteLine($hFile, '						Return $sVarStr')
			FileWriteLine($hFile, '					EndIf')
			FileWriteLine($hFile, '				EndIf')
			FileWriteLine($hFile, '			Case $aiNumDims[0] == 1')
			FileWriteLine($hFile, '				ReDim $avRetArr[$aiDimSizes[0]]')
			FileWriteLine($hFile, '				For $iCounter1 = 0 To $aiDimSizes[0] - 1')
			FileWriteLine($hFile, '					$avRetArr[$iCounter1] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '			Case $aiNumDims[0] == 2')
			FileWriteLine($hFile, '				ReDim $avRetArr[$aiDimSizes[0]][$aiDimSizes[1]]')
			FileWriteLine($hFile, '				For $iCounter1 = 0 To $aiDimSizes[0] - 1')
			FileWriteLine($hFile, '					For $iCounter2 = 0 To $aiDimSizes[1] - 1')
			FileWriteLine($hFile, '						$avRetArr[$iCounter1][$iCounter2] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)')
			FileWriteLine($hFile, '					Next')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '			Case $aiNumDims[0] == 3')
			FileWriteLine($hFile, '				ReDim $avRetArr[$aiDimSizes[0]][$aiDimSizes[1]][$aiDimSizes[2]]')
			FileWriteLine($hFile, '				For $iCounter1 = 0 To $aiDimSizes[0] - 1')
			FileWriteLine($hFile, '					For $iCounter2 = 0 To $aiDimSizes[1] - 1')
			FileWriteLine($hFile, '						For $iCounter3 = 0 To $aiDimSizes[2] - 1')
			FileWriteLine($hFile, '							$avRetArr[$iCounter1][$iCounter2][$iCounter3] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)')
			FileWriteLine($hFile, '						Next')
			FileWriteLine($hFile, '					Next')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '			Case $aiNumDims[0] == 4')
			FileWriteLine($hFile, '				ReDim $avRetArr[$aiDimSizes[0]][$aiDimSizes[1]][$aiDimSizes[2]][$aiDimSizes[3]]')
			FileWriteLine($hFile, '				For $iCounter1 = 0 To $aiDimSizes[0] - 1')
			FileWriteLine($hFile, '					For $iCounter2 = 0 To $aiDimSizes[1] - 1')
			FileWriteLine($hFile, '						For $iCounter3 = 0 To $aiDimSizes[2] - 1')
			FileWriteLine($hFile, '							For $iCounter4 = 0 To $aiDimSizes[3] - 1')
			FileWriteLine($hFile, '								$avRetArr[$iCounter1][$iCounter2][$iCounter3][$iCounter4] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)')
			FileWriteLine($hFile, '							Next')
			FileWriteLine($hFile, '						Next')
			FileWriteLine($hFile, '					Next')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '		EndSelect')
			FileWriteLine($hFile, '		Return $avRetArr')
			FileWriteLine($hFile, '	EndIf')
			FileWriteLine($hFile, 'EndFunc   ;==>_UnpackStrToVar')
		EndIf
		If $bPackVarToStrUsed == 1 Then
			FileWriteLine($hFile, 'Func _PackVarToStr(ByRef $vPackVar)')
			FileWriteLine($hFile, '	Local $iNumDims = UBound($vPackVar, 0) ; Number of dimensions of $vPackVar')
			FileWriteLine($hFile, '	Local $sVarStr = "$[" & $iNumDims & "]$" ; Return string of packed variable')
			FileWriteLine($hFile, '	Local $iCounter1 = "" ; Nested Counter')
			FileWriteLine($hFile, '	Local $iCounter2 = "" ; Nested Counter')
			FileWriteLine($hFile, '	Local $iCounter3 = "" ; Nested Counter')
			FileWriteLine($hFile, '	Local $iCounter4 = "" ; Nested Counter')
			FileWriteLine($hFile, '	For $i = 1 To $iNumDims')
			FileWriteLine($hFile, '		$sVarStr &= "$[" & UBound($vPackVar, $i) & "]$"')
			FileWriteLine($hFile, '	Next')
			FileWriteLine($hFile, '	Select')
			FileWriteLine($hFile, '		Case $iNumDims == 0')
			FileWriteLine($hFile, '			If $vPackVar == "" Then')
			FileWriteLine($hFile, '				$sVarStr &= "<nil>"')
			FileWriteLine($hFile, '			Else')
			FileWriteLine($hFile, '				$sVarStr &= $vPackVar')
			FileWriteLine($hFile, '			EndIf')
			FileWriteLine($hFile, '		Case $iNumDims == 1')
			FileWriteLine($hFile, '			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1')
			FileWriteLine($hFile, '				If $vPackVar[$iCounter1] == "" And UBound($vPackVar[$iCounter1], 0) == 0 Then')
			FileWriteLine($hFile, '					$sVarStr &= "$[0]$<nil>"')
			FileWriteLine($hFile, '				Else')
			FileWriteLine($hFile, '					$sVarStr &= _PackVarToStr($vPackVar[$iCounter1])')
			FileWriteLine($hFile, '				EndIf')
			FileWriteLine($hFile, '			Next')
			FileWriteLine($hFile, '		Case $iNumDims == 2')
			FileWriteLine($hFile, '			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1')
			FileWriteLine($hFile, '				For $iCounter2 = 0 To UBound($vPackVar, 2) - 1')
			FileWriteLine($hFile, '					If $vPackVar[$iCounter1][$iCounter2] == "" And UBound($vPackVar[$iCounter1][$iCounter2], 0) == 0 Then')
			FileWriteLine($hFile, '						$sVarStr &= "$[0]$<nil>"')
			FileWriteLine($hFile, '					Else')
			FileWriteLine($hFile, '						$sVarStr &= _PackVarToStr($vPackVar[$iCounter1][$iCounter2])')
			FileWriteLine($hFile, '					EndIf')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '			Next')
			FileWriteLine($hFile, '		Case $iNumDims == 3')
			FileWriteLine($hFile, '			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1')
			FileWriteLine($hFile, '				For $iCounter2 = 0 To UBound($vPackVar, 2) - 1')
			FileWriteLine($hFile, '					For $iCounter3 = 0 To UBound($vPackVar, 3) - 1')
			FileWriteLine($hFile, '						If $vPackVar[$iCounter1][$iCounter2][$iCounter3] == "" And UBound($vPackVar[$iCounter1][$iCounter2][$iCounter3], 0) == 0 Then')
			FileWriteLine($hFile, '							$sVarStr &= "$[0]$<nil>"')
			FileWriteLine($hFile, '						Else')
			FileWriteLine($hFile, '							$sVarStr &= _PackVarToStr($vPackVar[$iCounter1][$iCounter2][$iCounter3])')
			FileWriteLine($hFile, '						EndIf')
			FileWriteLine($hFile, '					Next')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '			Next')
			FileWriteLine($hFile, '		Case $iNumDims == 4')
			FileWriteLine($hFile, '			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1')
			FileWriteLine($hFile, '				For $iCounter2 = 0 To UBound($vPackVar, 2) - 1')
			FileWriteLine($hFile, '					For $iCounter3 = 0 To UBound($vPackVar, 3) - 1')
			FileWriteLine($hFile, '						For $iCounter4 = 0 To UBound($vPackVar, 4) - 1')
			FileWriteLine($hFile, '							If $vPackVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4] == "" And UBound($vPackVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4], 0) == 0 Then')
			FileWriteLine($hFile, '								$sVarStr &= "$[0]$<nil>"')
			FileWriteLine($hFile, '							Else')
			FileWriteLine($hFile, '								$sVarStr &= _PackVarToStr($vPackVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4])')
			FileWriteLine($hFile, '							EndIf')
			FileWriteLine($hFile, '						Next')
			FileWriteLine($hFile, '					Next')
			FileWriteLine($hFile, '				Next')
			FileWriteLine($hFile, '			Next')
			FileWriteLine($hFile, '	EndSelect')
			FileWriteLine($hFile, '	Return $sVarStr')
			FileWriteLine($hFile, 'EndFunc   ;==>_PackVarToStr')
		EndIf
		FileClose($hFile)
		Return $avCoThreads[0][0]
	Else
		SetError(1) ; Invalid delimiter or delimiter not found
		Return 0 ; failure
	EndIf
EndFunc   ;==>_CoCreate

;===============================================================================
;
; Function Name:    _CoYield()
; Description:      Yield a value to the main script and pause the
;						coroutine, only usable by the coroutine
; Parameter(s):     $sVarName - String containing the name of the variable
;						to pass to the main script. If string does not contain
;						the name of a declared variable, it is passed as a
;						literal string.
; Return Value(s):  The variable passed by the corresponding call to _CoResume()
; Author(s):        Ben Brightwell
;
;===============================================================================
;~ Func _CoYield($bPeek, $sVarName = "")
;~ 	If $bPeek == 1 Then
;~ 		If ConsoleRead(0,true) <> 0 Then
;~ 			$vResumeVar = ConsoleRead()
;~ 			$vResumeVar = _UnpackStrToVar($vResumeVar)
;~ 			SetExtended(1)
;~ 			Return $vResumeVar
;~ 		Else
;~ 			SetExtended(0)
;~ 			Return ""
;~ 		EndIf
;~ 	Else
;~ 		Local $vVarNameEval = "" ; If $sVarName equates to a declared variable, a copy of it is stored here
;~ 		Local $vResumeVar = "" ; When _CoResume() is called to unpause script, a variable can be passed
;~ 		If StringLeft($sVarName, 1) == "$" Then StringReplace($sVarName, "$", "")
;~ 		If IsDeclared($sVarName) Then
;~ 			$vVarNameEval = Eval($sVarName)
;~ 			$vVarNameEval = _PackVarToStr($vVarNameEval)
;~ 			ConsoleWrite("yield" & StrLen($vVarNameEval) & $vVarNameEval)
;~ 		Else
;~ 			$vVarName = _PackVarToStr($vVarName)
;~ 			ConsoleWrite("yield" & StrLen($vVarName) & $vVarName
;~ 		EndIf
;~ 		While ConsoleRead(0,true) == 0
;~ 			Sleep(50)
;~ 		WEnd
;~ 		$vResumeVar = ConsoleRead()
;~ 		$vResumeVar = _UnpackStrToVar($vResumeVar)
;~ 		Return $vResumeVar
;~ 	EndIf
;~ EndFunc

;===============================================================================
;
; Function Name:    _CoInclude()
; Description:      Include a UDF(s) in the coroutine script.
;						NOTE: #include <something.au3> will work in _CoCreate()
;						but keep in mind that the "something.au3" file must
;						exist on the computer that is running the script.
; Parameter(s):     $iCoThreadID - The thread to add the include to
;					$sFuncRawText - The function text, delimited by $sDelimiter
;					$sDelimiter - Used to delimit $sFuncRawText (Default "|")
; Return Value(s):  Success - 1
;					Failure - 0 and @error set to:
;								1 - Invalid iCoThreadID
;								2 - Invalid delimiter or delimiter not found
;								3 - Code formatted incorrectly. Namely mis-
;									matched number of "Func ..." and "EndFunc"
;									lines.
;								4 - Script file could not be opened.
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoInclude($iCoThreadID, $sFuncRawText, $sDelimiter = "|")
	Local $asFuncLines = "" ; Array holding the lines of code stripped from $sFuncRawText
	Local $sFormattedCode = "" ; String to write to the script file
	Local $iNumFuncs = 0 ; Number of lines that contain "Func ...". Used for minimal codechecking
	Local $iNumEndFuncs = 0 ; Number of lines that contain "EndFunc". Used for minimal codechecking
	Local $iFileCheck = 0 ; Used to check if file was written to correctly.
	Local $sPrevContents = "" ; Used to store contents of original coroutine script.
	Local $hFile = "" ; Handle for source file
	If $iCoThreadID <= $avCoThreads[0][0] Then
		$asFuncLines = StringSplit($sFuncRawText, $sDelimiter)
		If IsArray($asFuncLines) Then
			$sFormattedCode &= ';============' & @CRLF
			$sFormattedCode &= ';Include Code' & @CRLF
			$sFormattedCode &= ';============' & @CRLF
			For $i = 1 To $asFuncLines[0]
				If StringInStr($asFuncLines[$i], "endfunc") Then
					$iNumEndFuncs += 1
				ElseIf StringInStr($asFuncLines[$i], "func") Then
					$iNumFuncs += 1
				EndIf
			Next
			If $iNumFuncs == $iNumEndFuncs Then
				For $i = 1 To $asFuncLines[0]
					$sFormattedCode &= $asFuncLines[$i] & @CRLF
				Next
			Else
				SetError(3) ; Code formatted incorrectly
				Return 0 ; failure
			EndIf
		Else
			SetError(2) ; Delimiter not found in $sFuncRawText
			Return 0 ; failure
		EndIf
		$sPrevContents = FileRead($avCoThreads[$iCoThreadID][0])
		$hFile = FileOpen($avCoThreads[$iCoThreadID][0], 2)
		If FileWrite($hFile, $sFormattedCode) == 0 Then
			SetError(4) ; File could not be written to
			Return 0 ; failure
		Else
			FileClose($hFile)
			$hFile = FileOpen($avCoThreads[$iCoThreadID][0], 1)
			FileWrite($hFile, $sPrevContents)
		EndIf
	Else
		SetError(1) ; Invalid iCoThreadID
		Return 0 ;
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _CoStart()
; Description:      Create a coroutine from a thread created by _CoCreate()
; Parameter(s):     $iCoThreadID - as returned by _CoCreate()
;					$sParamStr - the string you would call a normal function
;						with. Example: MyFunc($test1, $test2)
;						$sParamStr = "$test1, $test2"
; Return Value(s):  On Success - the PID of the created coroutine
;                   On Failure - -1 and sets @error to:
;									1 - Invalid iCoThreadID
;									2 - Parameter string formatted incorrectly
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoStart($iCoThreadID, $sParamStr = "")
	Local $sPackedParamStr = "" ; If arrays exist in $sParamStr, then they need to be packed into a string
	Local $asParams = "" ; Holds individual parameters parsed from $sParamStr
	Local $sStrippedParam = "" ; Holds a parameter stripped of "$" and ","
	Local $vParamEval = "" ; If $sStrippedParam is a valid variable, a temporary one is evaluated to this container
	Local $sParamLiteral = "" ; If a non-variable is passed, it is interpreted as a literal
	If $iCoThreadID <= $avCoThreads[0][0] And $iCoThreadID <> 0 Then
		ReDim $avPIDs[$avPIDs[0][0] + 2][2]
		$avPIDs[0][0] += 1
		If $sParamStr <> "" Then
			If StringRight($sParamStr, 1) <> "," Then
				$sParamStr &= "," ; Makes $sParamStr easier to parse with StringRegExp
			EndIf
			$asParams = StringRegExp($sParamStr, '(".*?".*?,|[^ ]*?[ ]?,)*', 3)
			If Not IsArray($asParams) Then
				SetError(2) ; Parameter string not formatted correctly
				Return -1 ; failure
			EndIf
			For $i = 0 To UBound($asParams) - 1
				If StringInStr($asParams[$i], "$") Then
					$sStrippedParam = StringReplace(StringReplace($asParams[$i], "$", ""), ",", "")
					If IsDeclared($sStrippedParam) Then
						$vParamEval = Eval($sStrippedParam)
						$sPackedParamStr &= _PackVarToStr($vParamEval)
					Else
						$sParamLiteral = StringTrimRight($asParams[$i], 1)
						$sPackedParamStr &= _PackVarToStr($sParamLiteral)
					EndIf
				Else
					$sParamLiteral = StringTrimRight($asParams[$i], 1)
					$sPackedParamStr &= _PackVarToStr($sParamLiteral)
				EndIf
			Next
		EndIf
		$avPIDs[$avPIDs[0][0]][0] = Run(@AutoItExe & ' /AutoIt3ExecuteScript "' & $avCoThreads[$iCoThreadID][0] & '"', "", "", 7)
		If StringLen($sPackedParamStr) > 0 Then
			StdinWrite($avPIDs[$avPIDs[0][0]][0], StringLen($sPackedParamStr) & $sPackedParamStr)
		EndIf
		$avPIDs[$avPIDs[0][0]][1] = $iCoThreadID
		Return $avPIDs[$avPIDs[0][0]][0]
	Else
		SetError(1) ;Invalid iCoThreadID
		Return -1 ; failure
	EndIf
EndFunc   ;==>_CoStart

;===============================================================================
;
; Function Name:    _CoStatus()
; Description:      Determines the status of a PID returned by _CoStart()
; Parameter(s):     $iPID - PID as returned by _CoStart()
; Return Value(s):  On Success - Returns the status of the coroutine
;						Possible values: "yielded" - yielded a value, script paused
;										 "running" - running
;										 "returned" - coroutine dead, with a return value
;										 "dead" - coroutine dead with no return value
;                   On Failure - Returns empty string ("") and sets error to 1
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoStatus($iPID)
	Local $bPIDFound = 0 ; Used to search for a PID created by _CoStart()
	For $i = 1 To $avPIDs[0][0]
		If $avPIDs[$i][0] == $iPID Then
			$bPIDFound = 1
		EndIf
	Next
	If $bPIDFound == 1 Then
		Select
			Case ProcessExists($iPID) <> 0
				If StdoutRead($iPID, 5, True) == "yield" Then
					Return "yielded"
				ElseIf StdoutRead($iPID, 6, True) == "return" Then
					Return "returned" ; Coroutine returned, but return string is longer than console buffer
				Else
					Return "running"
				EndIf
			Case ProcessExists($iPID) == 0
				If StdoutRead($iPID, 0, True) <> 0 Then
					Return "returned"
				Else
					Return "dead"
				EndIf
		EndSelect
	Else
		SetError(1) ;$PID not created with _CoStart()
		Return ""
	EndIf
EndFunc   ;==>_CoStatus

;===============================================================================
;
; Function Name:    _CoSend()
; Description:      Sends a variable to the child script.
; Parameter(s):     $iPID - PID as returned by _CoStart()
; Return Value(s):  On Success - none
;                   On Failure - Returns empty string ("") and sets error to 1
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoSend($iPID, $vInVar)
	If _CoStatus($iPID) <> "dead" And _CoStatus($iPID) <> "returned" And _CoStatus($iPID) <> "yielded" Then
		StdinWrite($iPID, _PackVarToStr($vInVar))
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _CoResume()
; Description:      Resumes a paused coroutine and returns the yielded variable
; Parameter(s):     $iPID - PID as returned by _CoStart()
; Return Value(s):  On Success - Resumes paused coroutine and returns variable
;						yielded by _CoYield()
;                   On Failure - Returns empty string ("") and sets error to 1
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoResume($iPID, $vInVar = "")
	Local $sReturnStr = "" ; Contains return string
	Local $iNumChrsToRead = 0 ; Number of chars to read
	Local $iTotalChrsRead = 0 ; Total chars currently read
	If _CoStatus($iPID) == "yielded" Then
		If StdoutRead($iPID, 0, True) > 5 Then
			$sReturnStr = StringTrimLeft(StdoutRead($iPID), 5)
			$iNumChrsToRead = StringRegExp($sReturnStr, "(\d*?)(\#)(?:\$\[)", 1)
			$sReturnStr = StringTrimLeft($sReturnStr, $iNumChrsToRead[1])
			While StringLen($sReturnStr) <= $iNumChrsToRead[0]
				$sReturnStr &= StdoutRead($iPID)
			WEnd
			StdinWrite($iPID, _PackVarToStr($vInVar))
			Return _UnpackStrToVar($sReturnStr)
		EndIf
	Else
		SetError(1) ;$PID is not yielded
		Return ""
	EndIf
EndFunc   ;==>_CoResume

;===============================================================================
;
; Function Name:    _CoGetReturn()
; Description:      Returns the variable returned by a coroutine
; Parameter(s):     $iPID - PID as returned by _CoStart()
; Return Value(s):  On Success - Returns variable returned by coroutine
;                   On Failure - Returns empty string ("") and sets error to 1
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoGetReturn($iPID)
	Local $sReturnStr = "" ; Contains return string
	Local $iNumChrsToRead = 0 ; Number of chars to read
	Local $iTotalChrsRead = 0 ; Total chars currently read
	If _CoStatus($iPID) == "returned" Then
		$sReturnStr = StdoutRead($iPID)
		$iNumChrsToRead = StringRegExp($sReturnStr, "(\d*?)(\#)(?:\$\[)", 1)
		$sReturnStr = StringTrimLeft($sReturnStr, $iNumChrsToRead[1])
		While StringLen($sReturnStr) < $iNumChrsToRead[0]
			$sReturnStr &= StdoutRead($iPID)
		WEnd
		Return _UnpackStrToVar($sReturnStr)
	Else
		SetError(1) ; $PID not returned
		Return ""
	EndIf
EndFunc   ;==>_CoGetReturn

;===============================================================================
;
; Function Name:    _CoKill()
; Description:      Kills a running coroutine
; Parameter(s):     $iPID - PID as returned by _CoStart()
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoKill($iPID)
	If ProcessExists($iPID) <> 0 Then
		ProcessClose($iPID)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_CoKill

;===============================================================================
;
; Function Name:    _CoCleanup()
; Description:      Kills all coroutines and deletes their respective temp files
; Parameter(s):     none
; Return Value(s):  none
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoCleanup()
	For $i = 1 To $avPIDs[0][0]
		_CoKill($avPIDs[$i][0])
	Next
	For $i = 1 To $avCoThreads[0][0]
		FileDelete($avCoThreads[$i][0])
	Next
EndFunc   ;==>_CoCleanup

;===============================================================================
;
; Function Name:    _CoChangeWorkingDir()
; Description:      Changes the directory to store coroutine temp files in
;						NOTE: does not currently check for proper directory
;						structure
; Parameter(s):     $sDir = String representing the new working directory
; Return Value(s):  none
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _CoChangeWorkingDir($sDir)
	$workingDir = $sDir
EndFunc   ;==>_CoChangeWorkingDir

;===============================================================================
;
; Function Name:    _UnpackStrToVar()
; Description:      Turns a packed variable string back into a variable.
; Parameter(s):     $sVarStr = A packed variable string as returned by _PackVarToStr()
; Return Value(s):  Variable of type that was passed to _PackVarToStr()
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _UnpackStrToVar(ByRef $sVarStr)
	Local $aiNumDims = StringRegExp($sVarStr, '(?:\$\[)(\d*)(?:\]\$)(\#)', 1)
	Local $aiDimSizes[1] ; To contain the size of each dimension as passed through $sVarStr
	Local $aiDimSize = "" ; To contain the size of current dimension and string position for stripping
	Local $avRetArr[1] ; To be redimensioned and have $sVarStr parsed and stored into as an array
	Local $avElementStr = "" ; To contain each element as a string as it is parsed from $sVarStr
	If IsArray($aiNumDims) Then
		$sVarStr = StringTrimLeft($sVarStr, $aiNumDims[1])
		If $aiNumDims[0] > 0 Then
			ReDim $aiDimSizes[$aiNumDims[0]]
			For $iCounter1 = 0 To $aiNumDims[0] - 1
				$aiDimSize = StringRegExp($sVarStr, '(?:\$\[)(\d*)(?:\]\$)(\#)', 1)
				$aiDimSizes[$iCounter1] = $aiDimSize[0]
				$sVarStr = StringTrimLeft($sVarStr, $aiDimSize[1])
			Next
		EndIf
		Select
			Case $aiNumDims[0] == 0
				If StringInStr($sVarStr, "$[") Then
					$avElementStr = StringRegExp($sVarStr, '(.*?)(\#)(?:\$\[)', 1)
					$sVarStr = StringTrimLeft($sVarStr, $avElementStr[1])
					If $avElementStr[0] <> "<nil>" Then
						Return $avElementStr[0]
					Else
						Return ""
					EndIf
				Else
					If $sVarStr == "<nil>" Then
						Return ""
					Else
						Return $sVarStr
					EndIf
				EndIf
			Case $aiNumDims[0] == 1
				ReDim $avRetArr[$aiDimSizes[0]]
				For $iCounter1 = 0 To $aiDimSizes[0] - 1
					$avRetArr[$iCounter1] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)
				Next
			Case $aiNumDims[0] == 2
				ReDim $avRetArr[$aiDimSizes[0]][$aiDimSizes[1]]
				For $iCounter1 = 0 To $aiDimSizes[0] - 1
					For $iCounter2 = 0 To $aiDimSizes[1] - 1
						$avRetArr[$iCounter1][$iCounter2] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)
					Next
				Next
			Case $aiNumDims[0] == 3
				ReDim $avRetArr[$aiDimSizes[0]][$aiDimSizes[1]][$aiDimSizes[2]]
				For $iCounter1 = 0 To $aiDimSizes[0] - 1
					For $iCounter2 = 0 To $aiDimSizes[1] - 1
						For $iCounter3 = 0 To $aiDimSizes[2] - 1
							$avRetArr[$iCounter1][$iCounter2][$iCounter3] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)
						Next
					Next
				Next
			Case $aiNumDims[0] == 4
				ReDim $avRetArr[$aiDimSizes[0]][$aiDimSizes[1]][$aiDimSizes[2]][$aiDimSizes[3]]
				For $iCounter1 = 0 To $aiDimSizes[0] - 1
					For $iCounter2 = 0 To $aiDimSizes[1] - 1
						For $iCounter3 = 0 To $aiDimSizes[2] - 1
							For $iCounter4 = 0 To $aiDimSizes[3] - 1
								$avRetArr[$iCounter1][$iCounter2][$iCounter3][$iCounter4] = _UnpackStrToVar($sVarStr) ; In case element holds another array (Recursive)
							Next
						Next
					Next
				Next
		EndSelect
		Return $avRetArr
	EndIf
EndFunc   ;==>_UnpackStrToVar

;===============================================================================
;
; Function Name:    _PackVarToStr()
; Description:      Packs a variable into a string form for sending to another
;						script. Maintains array integrity up to 4 dimensions.
;						Also supports nested arrays inside array elements.
; Parameter(s):     $vPackVar = Variable to be packed into a string.
;						NOTE: Variables of type Object or DllStructs are not yet
;						supported.
; Return Value(s):  Returns packed string to be unpacked by _UnpackStrToVar()
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _PackVarToStr(ByRef $vPackVar)
	Local $iNumDims = UBound($vPackVar, 0) ; Number of dimensions of $vPackVar
	Local $sVarStr = "$[" & $iNumDims & "]$" ; Return string of packed variable
	Local $iCounter1 = "" ; Nested Counter
	Local $iCounter2 = "" ; Nested Counter
	Local $iCounter3 = "" ; Nested Counter
	Local $iCounter4 = "" ; Nested Counter
	For $i = 1 To $iNumDims
		$sVarStr &= "$[" & UBound($vPackVar, $i) & "]$"
	Next
	Select
		Case $iNumDims == 0
			If $vPackVar == "" Then
				$sVarStr &= "<nil>"
			Else
				$sVarStr &= $vPackVar
			EndIf
		Case $iNumDims == 1
			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1
				If $vPackVar[$iCounter1] == "" And UBound($vPackVar[$iCounter1], 0) == 0 Then
					$sVarStr &= "$[0]$<nil>"
				Else
					$sVarStr &= _PackVarToStr($vPackVar[$iCounter1])
				EndIf
			Next
		Case $iNumDims == 2
			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1
				For $iCounter2 = 0 To UBound($vPackVar, 2) - 1
					If $vPackVar[$iCounter1][$iCounter2] == "" And UBound($vPackVar[$iCounter1][$iCounter2], 0) == 0 Then
						$sVarStr &= "$[0]$<nil>"
					Else
						$sVarStr &= _PackVarToStr($vPackVar[$iCounter1][$iCounter2])
					EndIf
				Next
			Next
		Case $iNumDims == 3
			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1
				For $iCounter2 = 0 To UBound($vPackVar, 2) - 1
					For $iCounter3 = 0 To UBound($vPackVar, 3) - 1
						If $vPackVar[$iCounter1][$iCounter2][$iCounter3] == "" And UBound($vPackVar[$iCounter1][$iCounter2][$iCounter3], 0) == 0 Then
							$sVarStr &= "$[0]$<nil>"
						Else
							$sVarStr &= _PackVarToStr($vPackVar[$iCounter1][$iCounter2][$iCounter3])
						EndIf
					Next
				Next
			Next
		Case $iNumDims == 4
			For $iCounter1 = 0 To UBound($vPackVar, 1) - 1
				For $iCounter2 = 0 To UBound($vPackVar, 2) - 1
					For $iCounter3 = 0 To UBound($vPackVar, 3) - 1
						For $iCounter4 = 0 To UBound($vPackVar, 4) - 1
							If $vPackVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4] == "" And UBound($vPackVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4], 0) == 0 Then
								$sVarStr &= "$[0]$<nil>"
							Else
								$sVarStr &= _PackVarToStr($vPackVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4])
							EndIf
						Next
					Next
				Next
			Next
	EndSelect
	Return $sVarStr
EndFunc   ;==>_PackVarToStr

;===============================================================================
;
; Function Name:    _RandomFileName()
; Description:      Generates a random file name in the working directory so that
;						the a filename is not repeated for up to 10000 coroutine
;						scripts per main script.
; Parameter(s):     none
; Return Value(s):  FileGetShortName-converted string representing the full path
;						to the temporary file, including the .au3 extension
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _RandomFileName()
	$name = FileGetShortName($sWorkingDir) & "\" & StringTrimRight(@ScriptName, 4) & Random(0, 10000, 1) & ".au3"
	$found = 0
	For $i = 1 To $avCoThreads[0][0]
		If $name == $avCoThreads[$i][0] Then
			$found = 1
		EndIf
	Next
	While $found == 1
		$found = 0
		$name = FileGetShortName(@TempDir) & "\" & StringTrimRight(@ScriptName, 4) & Random(0, 10000, 1) & ".au3"
		For $i = 1 To $avCoThreads[0][0]
			If $name == $avCoThreads[$i][0] Then
				$found = 1
			EndIf
		Next
	WEnd
	Return $name
EndFunc   ;==>_RandomFileName