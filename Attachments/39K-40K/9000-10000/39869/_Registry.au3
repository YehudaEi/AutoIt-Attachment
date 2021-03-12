#include-once


; #FUNCTION# =========================================================================================
; Function Name:	_RegReplace()
; Description:		(Recursively searches for registry keys and) replaces substrings in a registry value data string.
; Syntax:			_RegReplace($sRR_HKEY, $sRR_SearchString, $sRR_ReplaceString [, $bRR_Recursive = False [, $sRR_Value = ""]])
; Parameter(s):		$sRR_HKEY			- A registry key to evaluate.
;					$sRR_SearchString	- A string to search for.
;					$sRR_ReplaceString	- A string to replace with.
;					$bRR_Recursive		- Allow a recursive registry key search:
;					| False (default).
;					| True.
;					$sRR_Value			- A registry value to evaluate.
; Requirement(s):	#include "_RegEnumKey.au3"
; Return Value(s):	On success - Returns 1, @error = 0, @extended:
;					| n - The number of replacements performed.
;					On failure - Returns 0, @extended = 0, @error:
;					| 0 - No error.
;					| 1 - '$sRR_HKEY' failure.
;					| 2 - '_RegEnumKey()' failure.
;					| 3 - 'RegEnumVal()' failure.
;					| 4 - 'RegRead()' failure.
;					| 5 - 'BinaryToString()' failure.
;					| 6 - '$sRR_RegType' failure.
;					| 7 - 'RegWrite()' failure.
; Author(s):		Supersonic!
; ====================================================================================================
Func _RegReplace($sRR_HKEY, $sRR_SearchString, $sRR_ReplaceString, $bRR_Recursive = False, $sRR_Value = "")
	Local $iRR_Return = 0
	If $sRR_HKEY <> "" Then
		Local $aRR_HKEY[1] = [0]
		Switch (String($bRR_Recursive) = "True") ; !!!
			Case True
				_RegEnumKey($sRR_HKEY, $aRR_HKEY, True)
				If Not @error Then
					ContinueCase
				Else ; Error
					SetError(2, 0)
				EndIf
			Case Else
				Switch (UBound($aRR_HKEY) - 1 = 0)
					Case True
						ReDim $aRR_HKEY[UBound($aRR_HKEY) + 1]
						$aRR_HKEY[UBound($aRR_HKEY) - 1] = $sRR_HKEY
						ContinueCase
					Case Else
						Local $iRR_Instance = 0
						Local $iRR_RegType = 0
						Local $iRR_Replacements = 0
						Local $sRR_RegData = ""
						Local $sRR_RegType = "" ; [http://en.wikipedia.org/wiki/Windows_Registry].
						Local $sRR_RegValue = ""
						For $i = 1 To UBound($aRR_HKEY) - 1 Step 1
							$iRR_Instance = 1
							While 1
								$sRR_RegValue = RegEnumVal($aRR_HKEY[$i], $iRR_Instance)
								Switch @error
									Case -1
										SetExtended($iRR_Replacements)
										ExitLoop
									Case 0
										If $sRR_Value = "" Or $sRR_Value = $sRR_RegValue Then
											$sRR_RegData = RegRead($aRR_HKEY[$i], $sRR_RegValue)
											If Not @error Then
												$iRR_RegType = @extended
												Switch $iRR_RegType
													Case 1
														$sRR_RegType = "REG_SZ"
													Case 2
														$sRR_RegType = "REG_EXPAND_SZ"
													Case 3
														$sRR_RegData = BinaryToString($sRR_RegData, 4) ; UTF-8.
														If Not @error Then
															$sRR_RegType = "REG_BINARY"
														Else ; Error.
															SetError(5, 0)
															ExitLoop
														EndIf
													Case 4
														$sRR_RegType = "REG_DWORD"
													Case 7
														$sRR_RegType = "REG_MULTI_SZ"
													Case 11
														$sRR_RegType = "REG_QWORD"
													Case Else
														$sRR_RegType = ""
												EndSwitch
												If $sRR_RegType <> "" Then
													$sRR_RegData = StringReplace($sRR_RegData, $sRR_SearchString, $sRR_ReplaceString, 0, 0)
													Switch (@extended <> 0)
														Case True
															$iRR_Replacements += @extended
															RegWrite($aRR_HKEY[$i], $sRR_RegValue, $sRR_RegType, $sRR_RegData)
															If Not @error Then
																$iRR_Return = 1
																ContinueCase
															Else ; Error.
																SetError(7, 0)
																ExitLoop
															EndIf
														Case Else
															ConsoleWrite("_RegReplace() -> [" & $aRR_HKEY[$i] & "\<" & $sRR_RegValue & "><" & $iRR_RegType & ">][" & $iRR_Instance & "][" & $iRR_Replacements & "]" & @CRLF) ; Debug output.
															$iRR_Instance += 1
													EndSwitch
												Else ; Error.
													SetError(6, 0)
													ExitLoop
												EndIf
											Else ; Error.
												SetError(4, 0)
												ExitLoop
											EndIf
										Else ; Non-error.
											$iRR_Instance += 1
										EndIf
									Case Else
										SetError(3, 0)
										ExitLoop
								EndSwitch
								; Sleep(10)
							WEnd
						Next
				EndSwitch
		EndSwitch
	Else ; Error.
		SetError(1, 0)
	EndIf
	Return $iRR_Return
EndFunc   ;==>_RegReplace


; #FUNCTION# =========================================================================================
; Function Name:	_RegEnumKey()
; Description:		Recursively searches for registry keys
;					[http://www.autoitscript.com/wiki/Recursion].
; Syntax:			_RegEnumKey($sREK_HKEY, ByRef $aREK_HKEY [, $bREK_Include = False])
; Parameter(s):		$sREK_HKEY		- A registry key to read.
;					$aREK_HKEY		- An 1D-array to store results.
;					$bREK_Include	- Allow to include registry key root:
;					| False (default).
;					| True.
; Requirement(s):	None.
; Return Value(s):	On success - Returns 1, @error = 0, @extended:
;					| n - Debug output.
;					On failure - Returns 0, @extended = 0, @error:
;					| 0 - No error.
;					| 1 - '$sREK_HKEY' failure.
;					| 2 - 'IsArray()' failure.
;					| 3 - 'RegEnumKey()' failure.
;					| 4 - '_RegEnumKey()' failure.
; Author(s):		Supersonic!
; ====================================================================================================
Func _RegEnumKey($sREK_HKEY, ByRef $aREK_HKEY, $bREK_Include = False)
	Local $iREK_Return = 0
	If $sREK_HKEY <> "" Then
		If IsArray($aREK_HKEY) = 1 Then
			Local $iREK_Instance = 0
			Local $sREK_Result = ""
			Switch (String($bREK_Include) = "True") ; !!!
				Case True
					ReDim $aREK_HKEY[UBound($aREK_HKEY) + 1]
					$aREK_HKEY[UBound($aREK_HKEY) - 1] = $sREK_HKEY
					ConsoleWrite("_RegEnumKey() -> [" & $sREK_HKEY & "][" & @error & "][" & @extended & "][" & UBound($aREK_HKEY) - 1 & "][" & $iREK_Instance & "]" & @CRLF) ; Debug output.
					ContinueCase
				Case Else
					$iREK_Instance += 1
					While 1
						$sREK_Result = RegEnumKey($sREK_HKEY, $iREK_Instance)
						Switch @error
							Case -1
								$aREK_HKEY[0] = UBound($aREK_HKEY) - 1
								$iREK_Return = $aREK_HKEY[0]
								SetExtended($iREK_Instance - 1)
								ExitLoop
							Case 0
								ReDim $aREK_HKEY[UBound($aREK_HKEY) + 1]
								$aREK_HKEY[UBound($aREK_HKEY) - 1] = $sREK_HKEY & "\" & $sREK_Result
								_RegEnumKey($sREK_HKEY & "\" & $sREK_Result, $aREK_HKEY, False)
								If Not @error Then
									ConsoleWrite("_RegEnumKey() -> [" & $sREK_HKEY & "\" & $sREK_Result & "][" & @error & "][" & @extended & "][" & UBound($aREK_HKEY) - 1 & "][" & $iREK_Instance & "]" & @CRLF) ; Debug output.
									$iREK_Instance += 1
								Else ; Error.
									SetError(4, 0)
									ExitLoop
								EndIf
							Case Else
								SetError(3, 0)
								ExitLoop
						EndSwitch
						; Sleep(10)
					WEnd
			EndSwitch
		Else ; Error.
			SetError(2, 0)
		EndIf
	Else ; Error.
		SetError(1, 0)
	EndIf
	Return $iREK_Return
EndFunc   ;==>_RegEnumKey