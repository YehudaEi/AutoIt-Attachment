; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

#include-once

Dim $oDebug
;Try to attach to an existing debugger
;$oDebug = ObjGet("","AutoIt_Debugger.clsDebug")
;If IsObj($oDebug) = 0 Then
;	MsgBox(48, "AutoIt Debugger", "The AutoIt Debugger could not attach to an existing debugger.")
	;Create a new debugger instance
	$oDebug = ObjCreate("AutoIt_Debugger.clsDebug")
	If IsObj($oDebug) = 0 Then
		MsgBox(48, "AutoIt Debugger", "The AutoIt Debugger was not sucessfully created. Debugging will stop.")
		Exit
	EndIf
;EndIf

Dim $AutoItDebugger_ClosedByUser
Dim $AutoItDebugger_LastError
Dim $AutoItDebugger_LastExtended

Func AutoItDebuggerEvent_ChangeVariable($VariableName)
	;MsgBox(0, "_AutoIt Debugger Include", "Entered 'AutoItDebuggerEvent_ChangeVariable'")
	
	;Convert array variables from $asMyArray[1] format to $asMyArray
	Local $iOpenSquareBracketPos
	$iOpenSquareBracketPos = StringInStr($VariableName, "[")
	If $iOpenSquareBracketPos <> 0 Then
		$VariableName = StringLeft($VariableName, $iOpenSquareBracketPos - 1)
	EndIf
	
	;Check if the variable is actually a variable
	If Not IsDeclared($VariableName) Then
		CheckForVariableChange($VariableName)
	Else
		#Region --- CodeWizard generated code Start ---
		;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Warning
		MsgBox(48, "_AutoIt Debugger Include", "AutoIt Debugger GUI sent attempted to change the value of an undeclared variable (" & $VariableName & ")")
		#EndRegion --- CodeWizard generated code End ---
	EndIf
EndFunc   ;==>AutoItDebuggerEvent_ChangeVariable

;Func AutoItDebuggerEvent_Quit()
;	;MsgBox(0,"AutoIt Debugger", "Call to exit.")
;	$AutoItDebugger_ClosedByUser = 1
;	Exit
;EndFunc


Func AutoIt_Debugger_NextLine($Filepath, $Filename, $LineNumber, $SkipLine)
	Local $sChangedVariableName
	
	;Skip the wait if necessary
	;If Not $SkipLine Then
	;Send new line status to the Debug GUI
	$oDebug.NewLine ($Filepath, $Filename, $LineNumber, $SkipLine)

	;Wait for the GUI to come off pause
	While $oDebug.Paused
		
		;Quit if necessary
		If $oDebug.ReadyToQuit Then
			;MsgBox(0, "_AutoIt Debugger Include", "ReadyToQuit")
			Exit
		EndIf
		
		;Check if any variables need to change
		$sChangedVariableName = $oDebug.ChangedVariableName
		While $sChangedVariableName <> ""
			;Run change variable code
			;MsgBox(0, "_AutoIt Debugger Include", "Detected a change in variable: " & $sChangedVariableName)
			AutoItDebuggerEvent_ChangeVariable($sChangedVariableName)
			;Get the next variable
			$sChangedVariableName = $oDebug.ChangedVariableName
		WEnd
	WEnd
	;EndIf
EndFunc   ;==>AutoIt_Debugger_NextLine


Func AutoIt_Debugger_FinishedLine($Filepath, $Filename, $LineNumber, $SkipLine, _
		$NextLine_Error, $NextLine_Extended)
	
	;If Not $SkipLine Then
	;Send new line status to the Debug GUI
	$oDebug.FinishedLine ($Filepath, $Filename, $LineNumber, $SkipLine)
	
	;Send the @error and @extended data on each new line
	$oDebug.SendVariable ("@error", $NextLine_Error)
	$oDebug.SendVariable ("@extended", $NextLine_Extended)
	;EndIf

	;Set error codes for the rest of the program
	SetError($NextLine_Error, $NextLine_Extended)
EndFunc   ;==>AutoIt_Debugger_FinishedLine


Func AutoIt_Debugger_WaitForExit()
	If IsObj($oDebug) = 1 Then
		;Send script finished message
		$oDebug.ScriptFinished ()
		
		;Wait for user to close the debugger
		While Not $oDebug.ReadyToQuit
		WEnd
		
		$oDebug.ExitProgram ()
		$oDebug = 0
	EndIf
EndFunc   ;==>AutoIt_Debugger_WaitForExit


Func AutoIt_Debugger_LoadFile($ORiginalScriptFilePath, $ORiginalScriptFileName)
	$oDebug.LoadFile($ORiginalScriptFilePath, $ORiginalScriptFileName)
EndFunc   ;==>AutoIt_Debugger_LoadFile


Func AutoIt_Debugger_DebugFile($DebugScriptFilePath)
	$oDebug.DebugFile($DebugScriptFilePath)
EndFunc   ;==>AutoIt_Debugger_LoadFile


Func AutoIt_Debugger_SendVariable($VariableName, $VariableValue, $SendVariable_Error, $SendVariable_Extended)
	Local $iNumberOfDims
	Local $iDimXIndex
	Local $iDimYIndex
	Local $iDimZIndex
	
	If IsArray($VariableValue) Then
		;Find the number of dimensions
		$iNumberOfDims = UBound($VariableValue, 0)
		Select
			Case $iNumberOfDims = 1
				;Send each array index seperatly
				For $iDimXIndex = 0 To UBound($VariableValue, 1) - 1
					$oDebug.SendVariable ($VariableName & "[" & $iDimXIndex & "]", AutoIt_Debugger_ReturnVariableValue($VariableValue[$iDimXIndex]))
				Next
				
			Case $iNumberOfDims = 2
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($VariableValue, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($VariableValue, 2) - 1
						$oDebug.SendVariable ($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "]", AutoIt_Debugger_ReturnVariableValue($VariableValue[$iDimXIndex][$iDimYIndex]))
					Next
				Next
				
			Case $iNumberOfDims = 3
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($VariableValue, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($VariableValue, 2) - 1
						;Repeat for each Z dimension
						For $iDimZIndex = 0 To UBound($VariableValue, 3) - 1
							$oDebug.SendVariable ($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "][" & $iDimZIndex & "]", AutoIt_Debugger_ReturnVariableValue($VariableValue[$iDimXIndex][$iDimYIndex][$iDimZIndex]))
						Next
					Next
				Next
				
			Case Else
				$oDebug.SendVariable ($VariableName, "<Array has too many dims>")
		EndSelect
	Else
		$oDebug.SendVariable ($VariableName, AutoIt_Debugger_ReturnVariableValue($VariableValue))
	EndIf

	;Set error codes for the rest of the program
	SetError($SendVariable_Error, $SendVariable_Extended)
EndFunc   ;==>AutoIt_Debugger_SendVariable

Func AutoIt_Debugger_ReturnVariableValue($VariableValue)
	If IsBool($VariableValue) Or IsFloat($VariableValue) Or IsInt($VariableValue) Or IsNumber($VariableValue) Or IsString($VariableValue) Then
		Return $VariableValue
	ElseIf IsArray($VariableValue) Then
		Return "<Array>"
	ElseIf IsObj($VariableValue) Then
		Return "<Object>"
	ElseIf IsBinary($VariableValue) Then
		Return "<Binary>(" & String($VariableValue) & ")"
	ElseIf IsHWnd($VariableValue) Then
		Return "<HWnd>(" & String($VariableValue) & ")"
	ElseIf IsKeyword($VariableValue) Then
		Return $VariableValue
	ElseIf Not IsDeclared($VariableValue) Then
		Return "<Undeclared>"
	EndIf
EndFunc   ;==>AutoIt_Debugger_ReturnVariableValue

Func AutoIt_Debugger_GetVariableFromEvent($VariableName, ByRef $Variable)
	;MsgBox(0, "_AutoIt Debugger Include", "Entered 'AutoIt_Debugger_GetVariableFromEvent'")

	Local $iNumberOfDims
	Local $iDimXIndex
	Local $iDimYIndex
	Local $iDimZIndex
	
	If IsBool($Variable) Or IsFloat($Variable) Or IsInt($Variable) Or IsNumber($Variable) Or IsString($Variable) Then
		$Variable = $oDebug.ReadVariable ($VariableName)
		;MsgBox(0, "_AutoIt Debugger Include", "New value of '" & $VariableName & " is '" & $Variable & "'")
	ElseIf IsArray($Variable) Then
		;Find the number of dimensions
		$iNumberOfDims = UBound($Variable, 0)
		Select
			Case $iNumberOfDims = 1
				;Send each array index seperatly
				For $iDimXIndex = 0 To UBound($Variable, 1) - 1
					$Variable[$iDimXIndex] = $oDebug.ReadVariable ($VariableName & "[" & $iDimXIndex & "]")
				Next
				
			Case $iNumberOfDims = 2
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($Variable, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($Variable, 2) - 1
						$Variable[$iDimXIndex][$iDimYIndex] = $oDebug.ReadVariable ($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "]")
					Next
				Next
				
			Case $iNumberOfDims = 3
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($Variable, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($Variable, 2) - 1
						;Repeat for each Z dimension
						For $iDimZIndex = 0 To UBound($Variable, 3) - 1
							$Variable[$iDimXIndex][$iDimYIndex][$iDimZIndex] = $oDebug.ReadVariable ($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "][" & $iDimZIndex & "]")
						Next
					Next
				Next
				
			Case Else
				;Do nothing
		EndSelect

	ElseIf IsObj($Variable) Then
		;Do nothing
	ElseIf IsBinary($Variable) Then
		;Do nothing
	ElseIf IsHWnd($Variable) Then
		;Do nothing
	ElseIf IsKeyword($Variable) Then
		;Do nothing
	EndIf
EndFunc   ;==>AutoIt_Debugger_GetVariableFromEvent