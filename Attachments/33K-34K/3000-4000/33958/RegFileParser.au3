#include-once
#include <file.au3>

; #INDEX# =======================================================================================================================
; Title .........: RegFileParser
; AutoIt Version : 3.1.1++
; Language ......: English
; Description ...: Functions that assist in reading .reg registry files.
; Author(s) .....: Zinthose <danerjones@gmail.com>
; Dll(s) ........:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_RegFileParser_RegParse
;_RegFileParser_BinaryToValue
; ===============================================================================================================================

#cs - Example
	#include <Array.au3>
	#include "RegFileParser.au3"

	$Files = FileOpenDialog("Import Registry Files", @WorkingDir, "Windows Registry Files (*.reg)", 7)

	Dim $return = _RegFileParser_RegParse($Files, 5)
	Dim $err[2] = [@error, @extended]

	MSG("$return="   & $return, "!")
	MSG("@error=" 	 & $err[0], "!")
	MSG("@extended=" & $err[1], "!")

	;## CallBack Functions
		Func _RegFileParser_DEBUG($Message)
			MSG($Message, "!")
		EndFunc

		Func _RegFileParser_FileOpen($File_Path, $File_Type)
			MSG('_RegFileParser_FileOpen')
			MSG('       $File_Path	:= "' & $File_Path & '"', ">")
			MSG('       $File_Type	:= ' & $File_Type, ">")
		EndFunc

		Func _RegFileParser_FileClose($File_Path)
			MSG('_RegFileParser_FileClose')
			MSG('       $File_Path	:= "' & $File_Path & '"', ">")
		EndFunc

		Func _RegFileParser_KeyDelete($HKEY_Path)
			If IsArray($HKEY_Path) Then $HKEY_Path = _ArrayToString($HKEY_Path, "\")
			MSG('_RegFileParser_KeyDelete')
			MSG('       $HKEY_Path	:= "' & $HKEY_Path & '"', ">")
		EndFunc

		Func _RegFileParser_KeyNew($HKEY_Path)
			If IsArray($HKEY_Path) Then $HKEY_Path = _ArrayToString($HKEY_Path, "\")
			MSG('_RegFileParser_KeyNew')
			MSG('       $HKEY_Path	:= "' & $HKEY_Path & '"', ">")
		EndFunc

		Func _RegFileParser_ValueDelete($HKEY_Path, $ValueName)
			If IsArray($HKEY_Path) Then $HKEY_Path = _ArrayToString($HKEY_Path, "\")
			MSG('_RegFileParser_ValueDelete')
			MSG('       $HKEY_Path	:= "' & $HKEY_Path & '"', ">")
			MSG('       $ValueName	:= "' & $ValueName & '"', ">")
		EndFunc

		Func _RegFileParser_ValueWrite($HKEY_Path, $ValueName, $Value, $ValueType)
			If IsArray($HKEY_Path) Then $HKEY_Path = _ArrayToString($HKEY_Path, "\")
			If IsArray($Value) Then $Value = _ArrayToString($Value, "|")
			MSG('_RegFileParser_ValueWrite')
			MSG('       $HKEY_Path	:= "' & $HKEY_Path & '"', ">")
			MSG('       $ValueName	:= "' & $ValueName & '"', ">")
			MSG('       $Value		:= "' & $Value & '"', ">")
			MSG('       $ValueType	:= "' & $ValueType & '"', ">")
		EndFunc

	;## Just a wrapper for ConsoleWriteError
		Func MSG($Message, $Level = "+")
			ConsoleWriteError($Level & " " & $Message & @CRLF)
		EndFunc

#ce - Example

; #FUNCTION# ====================================================================================================================
; Name...........: _RegFileParser_RegParse
; Description ...: Parser that closly matches the *.reg file import operations.
; Syntax.........: _RegParse($sFilePath[, $iFlags = 0])
; Parameters ....: $FilePath  - Specifies full path to .reg file to parse
;                  $iFlags     - Changees how _RegParse operates:
;                  |0 - Calls static function callbacks as the data is parsed.<Default>
;                  |1 - Enable Debug Callback
;                  |2 - RAW Mode (Do not preprocess binary data)
;                  |4 - Split Header into root,keyPath array
; Return values .: Success      - 0
;                  Failure:
;				   |1 - iFlags is invalid
;				   |2 - One or more files failed
;				   		@error is set to count of files that failed
;				   		@extended
;				   |3 - File not found
;				   |4 - File could not be opened
; Author ........: Dane Jones (Zinthose)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _RegFileParser_RegParse($FilePath, $iFlags = 0)
	Local $retVal, $i, $File, $File_Type, $File_Line, $errRead, $matches, $matches_MAX, $Value, $tmpValue, $NullChar, $nextLineLoaded = False, $sectionHeader = Default
	;Local Const $NS = "__RegFileParser_"
	#cs - Useful Resources

		Registry Data Types
			[http://pubs.logicalexpressions.com/pub0009/LPMArticle.asp?ID=361]
		MDGx Registry Guide + Hacks
			[http://www.mdgx.com/reg.htm]
		Windows Registry File Format (ASCII .REG format)
			[http://www.wotsit.org/download.asp?f=reg&sc=357914682]

	#ce - Useful Resources
	;## This Regular Expression is a bit of a monster so it was broken up into a multiline format to "ease" the decyphering / understanding
	#cs - Pattern Array
		\1  = "-" if delete mode else blank [HEADER]
		\2  = Root Hive Name
		\3  = Key Path
		\4  = "@" if default else blank
		\5  = Name of value unless \1 is "@"
		\6  = "-" if delete mode else blank [DATA]
		\7  = String Value
		\8  = dword hex string
		\9  = hex type
		\10 = hex 2 byte values comma delimited
		\11 = "," if data is continued on next line and is limited to hex values
	#ce - Pattern Array
	#region - Patterns
		Const $patternValueLine = _
			'(?x)(?i)\A\h*											' & _	; Start of string and ignore whitespace
			'	(?:(?=\[[^\]]+)										' & _	; If isAkeySectionStart Then
			'		\[(-)?([^\]\\]+)(?:(?:\])|(?:\\([^\]]+)))?\]	' & _	; 	Parse Header
			'	|													' & _	; Else
			'		(?:(@)|(?:"((?:[^\\"]|(?:\\\\)|(?:\\"))*)"))	' & _	; 	Get @ or Value Name
			'		\h*=\h*											' & _	; 	Equal sign and any whitespace
			'		(?(?=-)											' & _	; 	If Delete Then
			'			(-)											' & _	;		Parse delete
			'		|												' & _	; 	Else
			'			(?(?=")										' & _	; 		If String Then
			'				"((?:[^\\"]|(?:\\\\)|(?:\\"))*)"		' & _	;			Parse string value
			'			|											' & _	;		Else
			'				(?(?=dword:)							' & _	;			If dword Then
			'					dword:([A-Fa-f0-9]{1,8})(?-i)		' & _	;				Parse dword value
			'				|										' & _	;			Else
			'					(?(?=hex(?:\([0-9abAB]\))?:)		' & _	;				If hex Then
			'						hex(?:\(([0-9abAB])\))?:		' & _	;					Parse hexType
			'						(								' & _	;					Parse hexValue
			'							[A-Za-z0-9]{2}				' & _	;						First Hex Value
			'							(?:,[A-Za-z0-9]{2})*		' & _	;						Subsequent hex values
			'						)(?:(,)\\)?						' & _	;					determine if more data is on the next line
			'					)									' & _	;				End If
			'				)										' & _	;			End If
			'			)											' & _	; 		EndIf
			'		)												' & _	; 	EndIf
			'	)													' & _	; EndIf
			'	\h*(?:;|\Z)											'	    ; Match to end of string or comment delimiter
		Const $patternHexContinue = _
			'(?x)(?i)\A\h*											' & _	; Start of string and ignore whitespace
			'	(													' & _	; Parse hexValue
			'		[A-Za-z0-9]{2}									' & _	;	First Hex Value
			'		(?:,[A-Za-z0-9]{2})*							' & _	;		Subsequent hex values
			'	)(?:(,)\\)?											' & _	;	determine if more data is on the next line
			'	\h*(?:;|\Z)											'	    ; Match to end of string or comment delimiter

		Const $patternFileHeader = _
			'(?i)\A\h*(?:(?=REGEDIT4\h*(?:;|\Z))REGEDIT|(?:(?=Window' & _ 	; Match for valid/supported reg file types
			's Registry Editor Version 5\.00\h*(?:;|\Z))Windows Regi' & _ 	; ...
			'stry Editor Version ))([45])'
	#endregion - Patterns
	#region - Parameter Validation
		;## Currently $iFlags = 0 is the only supported option flag
			#cs - Accepted Flags
				0	Defaults
				1	Output Debug Information to Error Console
				2	RAW Mode (Do not preprocess binary data)
				4	Split Header into root,keyPath array
				TODO:
					8	Guestimation Mode (Attempt to correct invalid data into expected datatypes)
			#ce - Accepted Flags
			If BitShift($iFlags, 3) > 0 Then
				SetError(1)
				Return
			EndIf

		;## Validate FilePath
			If IsString($FilePath) Then
			;## Is path a FileOpenDialog Multiselect?
				If StringInStr($FilePath,"|",False,1) <> 0 Then
					$FilePath = StringSplit($FilePath, "|")
					$retVal = 0
					For $i = 2 to $FilePath[0]
						$retVal += _RegFileParser_RegParse($FilePath[1] & "\" & $FilePath[$i], $iFlags)
					Next

					If $retVal = 0 Then
						SetError(0, $FilePath[0] - 1, $retVal)
					Else
						SetError(1, $FilePath[0] - 1, $retVal)
					EndIf
					Return $retVal

			;## Is path a comma delimited list?
				ElseIf StringInStr($FilePath,",",False,1) <> 0 Then
					$FilePath = StringSplit($FilePath, ",", 2)
				EndIf
			EndIf

		;## Is Path an array?
			If IsArray($FilePath) Then
				$retVal = 0
				For $i = 2 to $FilePath[0]
					$retVal += _RegFileParser_RegParse($FilePath[1] & "\" & $FilePath[$i], $iFlags)
				Next

				If $retVal = 0 Then
					SetError(0, $FilePath[0] - 1, $retVal)
				Else
					SetError(1, $FilePath[0] - 1, $retVal)
				EndIf
				Return $retVal
			EndIf

		;## Dose the file exist?
			If Not FileExists($FilePath) Then
				If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG", "File dosen't exist: " & $FilePath)
				SetError(3,1,1)
				Return 1
			EndIf

		;## Dose path contain wildcards?
			If StringRegExp($FilePath, "\*|\?") Then
				If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG", "Wildcards not supported (YET): " & $FilePath)
				SetError(3,1,1)
				Return 1
			EndIf

	#endregion - Parameter Validation

	#region - Open .reg File
		$File = FileOpen($FilePath, 0)
		If $File = -1 Then
			SetError(4,1,1)
			Return 1
		EndIf
	#endregion - Open .reg File

	#region - Parse .reg file
		$File_Line = FileReadLine($File)
		$errRead = @error

		;## Verify file is supported type based on header
			If $errRead = -1 Or Not StringRegExp($File_Line, $patternFileHeader) Then
				If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","File is unsuppored type")
				__RegFileParser_CallBack("FileOpen", $FilePath, 0)
			Else
				$matches = StringRegExp($File_Line, $patternFileHeader, 1)
				$File_Type = Number($matches[0])

				If $File_Type > 4 Then
					$NullChar = ChrW(0)
				Else
					$NullChar = Chr(0)
				EndIf

				__RegFileParser_CallBack("FileOpen", $FilePath, $File_Type)

				$File_Line = FileReadLine($File)
				$errRead = @error

			;## Loop into file and parse
				While 1
					If $errRead = -1 Then ExitLoop

					If StringRegExp($File_Line, $patternValueLine) Then
						$matches = StringRegExp($File_Line, $patternValueLine, 2)

						;## I'm subtracting 1 here for programmer sanity.  This allows for number corelation to the matches pattern array.
							$matches_MAX = UBound($matches) - 1

						;## What kind of line is this?
							Switch $matches_MAX

							;## Is this a header?
								Case 2,3 	;<-- This is a Header line

									;## Define Header Array
										If $matches_MAX = 2 Then
											If BitAND(0x4, $iFlags) Then
												Dim $SectionHeader[1] = [$matches[2]]
											Else
												Dim $SectionHeader = $matches[2]
											EndIf
										Else
											If BitAND(0x4, $iFlags) Then
												Dim $SectionHeader[2] = [$matches[2], $matches[3]]
											Else
												Dim $SectionHeader = $matches[2] & "\" & $matches[3]
											EndIf
										EndIf

									If $matches[1] == "-" Then
									;## Delete operation
										If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","Header line detected: DELETE OPERATION")

										__RegFileParser_CallBack("KeyDelete", $SectionHeader)
										Dim $SectionHeader = Default
									Else
									;## New key line/section
										If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","Header line detected")

										__RegFileParser_CallBack("KeyNew", $SectionHeader)
									EndIf

							;## Is this a value delete?
								Case 6
									If $SectionHeader <> Default Then

										If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","Data line Detected: DELETE")
										__RegFileParser_CallBack("ValueDelete", $SectionHeader, __RegFileParser_GetValueName($matches))

									EndIf

							;## Is this a string value?
								Case 7
									If $SectionHeader <> Default Then
										If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","Data line Detected: STRING")
										__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches),  StringRegExpReplace($matches[7], '\\((?:\\)|")', '\1'),"REG_SZ")
									EndIf

							;## Is this a dword value?
								Case 8
									If $SectionHeader <> Default Then

										For $i = 1 to StringLen($matches[8]) Step 2
											If $i = 1 Then
												$Value = StringMid($matches[8],$i,2)
											Else
												$Value = StringMid($matches[8],$i,2) & $Value
											EndIf
										Next

										__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches),  Number(Binary("0x" & $Value)),"REG_DWORD")
										If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","Data line Detected: DWORD")
									EndIf

							;## Is this a hex value with multiple lines?
								Case 11
									If $SectionHeader <> Default Then
										$Value = StringReplace($matches[10], ",", "")

										$nextLineLoaded = True
										While 1
											;## Read next line and check for errors
												$File_Line = FileReadLine($File)
												$errRead = @error
												If $errRead = -1 Then ExitLoop

											;## If pattern dosn't match then we need to break out of the loop
												If Not StringRegExp($File_Line,$patternHexContinue) Then ExitLoop

											;## Parse the continues line and add to previous results
												$wrapMatches = StringRegExp($File_Line,$patternHexContinue,2)
												$Value = $Value & StringReplace($wrapMatches[1], ",", "")

											;##  If this line omits the line coninuation metacharactor then the next line is a normal line
												If UBound($wrapMatches) <> 3 Then
													$nextLineLoaded = False
													ExitLoop
												EndIf
										WEnd

										$matches[10] = $value

										ContinueCase ; <-- This allows up to continue into the "Case 9,10"
									EndIf
							;## Is this a hex value?
								Case 9,10
									If $SectionHeader <> Default Then
										$Value = StringReplace($matches[10], ",", "")

										Switch $matches[9]
											Case "0"; REG_NONE
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_NONE")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value,"REG_NONE")

											Case "1"; REG_SZ
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_SZ")
												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## RAW Mode?
													If Not BitAND(0x2, $iFlags) Then

													;## Unicode type returned here is dependant upon the filetype
														If $File_Type > 4 Then
														;## Convert to standard UTF-16LE Unicode string and remove any null characters
															$Value = _RegFileParser_BinaryToValue($Value, "REG_SZ", 1)
														Else
														;## Convert to standard ASCII string and remove any null characters
															$Value = _RegFileParser_BinaryToValue($Value, "REG_SZ", 3)
														EndIf

													EndIf

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_SZ")

											Case "2"; REG_EXPAND_SZ
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_EXPAND_SZ")
												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## RAW Mode?
													If Not BitAND(0x2, $iFlags) Then

													;## Unicode type returned here is dependant upon the filetype
														If $File_Type > 4 Then
														;## Convert to standard UTF-16LE Unicode string and remove any null characters
															$Value = _RegFileParser_BinaryToValue($Value, "REG_EXPAND_SZ", 1)
														Else
														;## Convert to standard ANSI string and remove any null characters
															$Value = _RegFileParser_BinaryToValue($Value, "REG_EXPAND_SZ", 2)
														EndIf

													EndIf

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value,"REG_EXPAND_SZ")

											Case "3", ""; REG_BINARY
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_BINARY")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value,"REG_BINARY")

											Case "4"; REG_DWORD / REG_DWORD_LITTLE_ENDIAN
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_DWORD")

												$Value = Binary("0x" & $Value)

												If Not BitAND(0x2, $iFlags) Then
													$Value = _RegFileParser_BinaryToValue($Value, "REG_DWORD")
												Else
													;## .reg files are permited to import dwords with more or less than 32bits when using this format.
													;## regedit will show "(invalid DWORD value)" in the Data field and will allow user editing via the Binary editing dialog.
													;## If the value is edited to 32bits, the value is subsiquently treated as a typical DWORD.
													;## We can either attempt to fix this or ignore for a true .reg file import experience.
													;## TODO: Enable True .reg mode or attempt to correct.
												EndIf

												__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value,"REG_DWORD")

											Case "5"; REG_DWORD_BIG_ENDIAN
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_DWORD_BIG_ENDIAN")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												#cs
													If BinaryLen($Value) = 4 And Not BitAND(0x2, $iFlags) Then
														;## This is formated as a proper DWORD
													Else
														;## .reg files are permited to import dwords with more or less than 32bits when using this format.
														;## regedit will show "(invalid DWORD value)" in the Data field and will allow user editing via the Binary editing dialog.
														;## If the value is edited to 32bits, the value is subsiquently treated as a typical DWORD.
														;## We can either attempt to fix this or ignore for a true .reg file import experience.
														;## TODO: Enable True .reg mode or attempt to correct.
													EndIf
												#ce

												__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_DWORD_BIG_ENDIAN")

											Case "6"; REG_LINK
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_LINK")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_LINK")

											Case "7"; REG_MULTI_SZ
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_MULTI_SZ")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## RAW Mode?
													If Not BitAND(0x2, $iFlags) Then
													;## Unicode type returned here is dependant upon the filetype
														If $File_Type > 4 Then
															;## Convert to standard UTF-16LE string
																$Value = _RegFileParser_BinaryToValue($Value, "REG_MULTI_SZ", 1)
														Else
															;## Convert to standard ASCII string
																$Value = _RegFileParser_BinaryToValue($Value, "REG_MULTI_SZ", 3)
														EndIf
													EndIf

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_MULTI_SZ")

											Case "8"; REG_RESOURCE_LIST
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_RESOURCE_LIST")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value,"REG_RESOURCE_LIST")

											Case "9"; REG_FULL_RESOURCE_DESCRIPTOR
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_FULL_RESOURCE_DESCRIPTOR")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_FULL_RESOURCE_DESCRIPTOR")

											Case "a","A"; REG_RESOURCE_REQUIREMENTS_LIST
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_RESOURCE_REQUIREMENTS_LIST")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_RESOURCE_REQUIREMENTS_LIST")

											Case "b","B"; REG_QWORD / REG_QWORD_LITTLE_ENDIAN
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_QWORD")

												;## Convert to binary value from hex string
													$Value = Binary("0x" & $Value)

												;## If byte length is correct then convert to number
													If BinaryLen($Value) = 8 And Not BitAND(0x2, $iFlags) Then $Value = Number($Value)

												;## Callback
													__RegFileParser_CallBack("ValueWrite", $SectionHeader, __RegFileParser_GetValueName($matches), $Value, "REG_QWORD")

											Case Else; unknown type
												If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","HEX Value detected as REG_NONE")
										EndSwitch

									EndIf
							;## Is this somthing unexpected?
								Case Else
									;## In-Joke: the error code is the hex representation of the ascii chars "WTF"
									SetError(0x575466)
									If BitAnd(0x1, $iFlags) Then __RegFileParser_CallBack("DEBUG","Data line Detected: [ERR:0x575466] UNEXPECTED Array Length[" & UBound($matches) - 1 & "]")
							EndSwitch

					EndIf

					;## Load next line if nessecary
						If $nextLineLoaded Then
							$nextLineLoaded = False
						Else
							$File_Line = FileReadLine($File)
							$errRead = @error
						EndIf
				WEnd
			EndIf
	#endregion - Parse .reg file

	#region - Close .reg file
		FileClose($File)
		SetExtended(1,0)
		__RegFileParser_CallBack("FileClose", $FilePath)
	#endregion
EndFunc	;==>_RegParse

; #FUNCTION# ====================================================================================================================
; Name...........: _RegFileParser_BinaryToValue
; Description ...: Function which attempts to convert a binary data stream into the targeted Reg_* types value.
; Syntax.........: _RegFileParser_BinaryToValue($bBinaryData[, $sDataType[, $iFlags = 0]])
; Parameters ....: $bBinaryData - Binary data stream of value to be converted
;				   $$sDataType  - Can be one of the 12 known/supporedt registry value types
;                  |REG_NONE 						- No type (the stored value, if any)
;                  |REG_SZ							- A string value, normally stored and exposed in UTF-16LE (when using the Unicode version of Win32 API functions), usually terminated by a null character
;                  |REG_EXPAND_SZ					- An "expandable" string value that can contain environment variables, normally stored and exposed in UTF-16LE, usually terminated by a null character
;                  |REG_BINARY						- Binary data (any arbitrary data)
;                  |REG_DWORD						- A DWORD value, a 32-bit unsigned integer (numbers between 0 and 4,294,967,295 [2^32 – 1]) (little-endian)
;                  |REG_DWORD_LITTLE_ENDIAN			- A DWORD value, a 32-bit unsigned integer (numbers between 0 and 4,294,967,295 [2^32 – 1]) (little-endian) [Same as REG_DWORD]
;                  |REG_DWORD_BIG_ENDIAN			- A DWORD value, a 32-bit unsigned integer (numbers between 0 and 4,294,967,295 [232 – 1]) (big-endian)
;                  |REG_LINK						- A symbolic link (UNICODE) to another registry key, specifying a root key and the path to the target key
;                  |REG_MULTI_SZ					- A multi-string value, which is an ordered list of non-empty strings, normally stored and exposed in UTF-16LE, each one terminated by a null character, the list being normally terminated by a second null character.
;                  |REG_RESOURCE_LIST				- A resource list (used by the Plug-n-Play hardware enumeration and configuration)
;                  |REG_FULL_RESOURCE_DESCRIPTOR	- A resource descriptor (used by the Plug-n-Play hardware enumeration and configuration)
;                  |REG_RESOURCE_REQUIREMENTS_LIST	- A resource requirements list (used by the Plug-n-Play hardware enumeration and configuration)
;                  |REG_QWORD						- A QWORD value, a 64-bit integer (either big- or little-endian, or unspecified) (Introduced in Windows 2000)
;                  |REG_QWORD_LITTLE_ENDIAN			- A QWORD value, a 64-bit integer (either big- or little-endian, or unspecified) (Introduced in Windows 2000) [Same as REG_QWORD]
;                  $iFlags      - Changees how _RegParse operates:
;                  |0 - Heuristic weighted toward UTF16 Little Endian Strings <Default>
;                  |1 - Forces string type / skips detection
;                  |2 - Heuristic weighted toward ANSI Strings (This overides 0 flag)
; Return values .: Success      - 0
;                  Failure:
;				   |1 - Supplied data is not in required binary format
;				   |2 - Supplied data is corrupt and is not convertable to inteneded datatype
; Author ........: Dane Jones (Zinthose)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _RegFileParser_BinaryToValue($bBinaryData, $sDataType, $iFlags = 0)
	Local $ValueA, $ValueB ,$isANSI = False, $NullChar
	#cs
		---
		Error Codes:
			0: Success
			1: Supplied data is not in required binary format
			2: Supplied data is corrupt and is not convertable to inteneded datatype

		iFlags:
			0: Heuristic weighted toward UTF16 Little Endian Strings 			# Default
			1: Force String Type												#
			2: Heuristic weighted toward ANSI Strings (This overides 0 flag)	#
		...
	#ce
	If Not IsBinary($bBinaryData) Then
		SetError(1)
		Return $bBinaryData
	EndIf

	Switch $sDataType
		Case "REG_QWORD", "REG_QWORD_LITTLE_ENDIAN"
			If BinaryLen($bBinaryData) = 8 Then
				Return Number($bBinaryData)
			Else
				SetError(2)
				Return $bBinaryData
			EndIf
		Case "REG_MULTI_SZ"
			;## Determine if this is a UTF16LE string or ANSI
				If BitAND(0x1, $iFlags) Then
					;## Force StringTypeFlag is set
						$isANSI = BitAND(0x2, $iFlags) = True
				ElseIf Mod(BinaryLen($bBinaryData), 2) <> 0 Then
					;## Bitlength indicates that it is not a valid unicode value
					;## Assuming string is a ANSI
						$isANSI = True
				ElseIf BinaryMid($bBinaryData, BinaryLen($bBinaryData)-3) = Binary("0x00000000") Then
					;## Guessing string is UTF16LE encoded
						$isANSI = False
				ElseIf BinaryMid($bBinaryData, BinaryLen($bBinaryData)-2) = Binary("0x000000") Then
					;## Guessing string is UTF16LE encoded
						$isANSI = False
				ElseIf BinaryMid($bBinaryData, BinaryLen($bBinaryData)-1) = Binary("0x0000") Then
					;## Guessing string is ANSI encoded
						$isANSI = True
				ElseIf BinaryMid($bBinaryData, BinaryLen($bBinaryData)) = Binary("0x00") Then
					If BitAND(0x2, $iFlags) Then
						;## Guessing string is ANSI encoded
							$isANSI = True
					ElseIf StringRegExp($bBinaryData, "0x(?:[A-Fa-f0-9]{2}00)+") Then
						;## Guessing string is UTF16LE encoded
							$isANSI = False
					Else
						;## Guessing string is ANSI encoded
							$isANSI = True
					EndIf
				ElseIf BitAND(0x2, $iFlags) Then
					;## Guessing string is ANSI encoded
						$isANSI = True
				Else
					;## Guessing string is UTF16LE encoded
						$isANSI = False
				EndIf

				If $isANSI Then
					$ValueA = BinaryToString($bBinaryData, 1)
					$NullChar = Chr(0)
				Else
					$ValueA = BinaryToString($bBinaryData, 2)
					$NullChar = ChrW(0)
				EndIf

			;## Break string at double null and split into multi string array
				If StringRight($ValueA,2) = $NullChar & $NullChar Then _
					$ValueA = StringLeft($ValueA, StringLen($ValueA)-2)

				Return StringSplit($ValueA, $NullChar)

		Case "REG_DWORD_BIG_ENDIAN"
			If BinaryLen($bBinaryData) = 4 Then
				;## This is formated as a proper DWORD
					Return Number($bBinaryData)
			Else
				SetError(2)
				Return $bBinaryData
			EndIf
		Case "REG_DWORD", "REG_DWORD_LITTLE_ENDIAN"
			If BinaryLen($bBinaryData) = 4 Then
				;## This is formated as a proper DWORD
				;## We need to convert from LITTLE ENDIAN to BIG ENDIAN
					For $i = 1 to BinaryLen($bBinaryData)
						If $i = 1 Then
							$ValueA = BinaryMid($bBinaryData,$i,1)
						Else
							$ValueA = BinaryMid($bBinaryData,$i,1) & $ValueA
						EndIf
					Next

					Return Number($ValueA)
			Else
				SetError(2)
				Return $bBinaryData
			EndIf
		Case "REG_EXPAND_SZ"
			ContinueCase ;<-- Meh!
		Case "REG_SZ"
			;## Determine if this is a UTF16LE string or ANSI
				If BitAND(0x1, $iFlags) Then
					;## Force StringTypeFlag is set
						$isANSI = BitAND(0x2, $iFlags) = True
				ElseIf Mod(BinaryLen($bBinaryData), 2) <> 0 Then
					;## Bitlength indicates that it is not a valid unicode value
					;## Assuming string is a ANSI
						$isANSI = True
				ElseIf BinaryMid($bBinaryData, BinaryLen($bBinaryData)-1) = Binary("0x0000") Then
					;## Guessing string is UTF16LE encoded
						$isANSI = False
						$bBinaryData = BinaryMid($bBinaryData, 1, BinaryLen($bBinaryData) - 2)
				ElseIf BinaryMid($bBinaryData, BinaryLen($bBinaryData)) = Binary("0x00") Then
					If BitAND(0x2, $iFlags) Then
					;## Guessing string is ANSI encoded
							$isANSI = True
							$bBinaryData = BinaryMid($bBinaryData, 1, BinaryLen($bBinaryData) - 1)
					Else
					;## Guessing string is UTF16LE encoded
						$isANSI = False
					EndIf
				ElseIf BitAND(0x2, $iFlags) Then
					;## Guessing string is ANSI encoded
						$isANSI = True
				Else
					;## Guessing string is UTF16LE encoded
						$isANSI = False
				EndIf

				If $isANSI Then
					Return BinaryToString($bBinaryData, 1)
				Else
					Return BinaryToString($bBinaryData, 2)
				EndIf

		Case "REG_RESOURCE_REQUIREMENTS_LIST"
			ContinueCase
		Case "REG_FULL_RESOURCE_DESCRIPTOR"
			ContinueCase
		Case "REG_LINK"
			ContinueCase
		Case "REG_BINARY"
			Return $bBinaryData
	EndSwitch
EndFunc

#region - Private Functions
	Func __RegFileParser_CallBack($functionName, $param1 = Default, $param2 = Default, $param3 = Default, $param4 = Default, $param5 = Default, $param6 = Default, $param7 = Default, $param8 = Default, $param9 = Default)
		Dim $i, $arrParams[1] = ["CallArgArray"]

		$functionName = "_RegFileParser_" & $functionName

		If @NumParams > 1 Then
			ReDim $arrParams[@NumParams]
			For $i = 1 to @NumParams - 1
				$arrParams[$i] = Eval("param" & $i)
			Next
			Call($functionName, $arrParams)
			If $functionName <> "DEBUG" And @error = 0xDEAD And @extended = 0xBEEF Then __RegFileParser_CallBack("DEBUG","CallBack Failed[" & $functionName & "}")
		Else
			Call("_RegFileParser_" & $functionName)
			If $functionName <> "DEBUG" And @error = 0xDEAD And @extended = 0xBEEF Then __RegFileParser_CallBack("DEBUG","CallBack Failed[" & $functionName & "}")
		EndIf
	EndFunc

	Func __RegFileParser_GetValueName($matches)
		If Not IsArray($matches) Or ubound($matches) < 4 Then
			SetError(0x575446) ;<-- Yep it's a "WTf" Error
			Return
		EndIf

		If $matches[4] == "@" Then
			Return Default
		Else
			If $matches[5] <> "" Then $matches[5] = StringRegExpReplace($matches[5], '\\((?:\\)|")', '\1') ; Pattern replaces \\ with \ and \" with "
			Return $matches[5]
		EndIf
	EndFunc
#endregion - Private Functions
