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
;#Include <File.au3> ; Uncomment line for debug

;$MinVersion = "3.1.1.100"
;MsgBox 0,"",$MinVersion
;If Not VersionCheck($MinVersion) Then
;	MsgBox(48, "AutoIt Debugger","You need a minimum of AutoIt v" & $MinVersion & " to run the debugger. You have v" & @AutoItVersion & ".")
;	Exit
;EndIf

;FileDelete("C:\Program Files\AutoIt3\AutoIt Debugger\_AutoIt Debugger Include.au3.log") ; Uncomment line for debug

Dim $oDebugWrapper
$oDebugWrapper = ObjCreate ("AutoItDebuggerWrapper.clsWrapper")   
If IsObj($oDebugWrapper) = 0 Then
	MsgBox(48,"AutoIt Debugger","The AutoIt Debugger Wrapper was not sucessfully created. Debugging will stop.")
	Exit
EndIf

Dim $EventObject
$EventObject = ObjEvent($oDebugWrapper, "AutoItDebuggerEvent_")
If (IsObj($EventObject) = 0) Then
	MsgBox(48,"AutoIt Debugger","The AutoIt Debugger Event Handler was not sucessfully registered ($EventObject =0).")
	Exit
EndIf
If (@error = 1) Then
	MsgBox(48,"AutoIt Debugger","The AutoIt Debugger Event Handler was not sucessfully registered (@error = 1).")
	Exit
EndIf

Dim $AutoItDebugger_ClosedByUser
Dim $AutoItDebugger_LastError
Dim $AutoItDebugger_LastExtended

Func AutoItDebuggerEvent_ChangeVariable($VariableName, $VariableValue)
	;_FileWriteLog("C:\Program Files\AutoIt3\AutoIt Debugger\_AutoIt Debugger Include.au3.log", "AutoItDebuggerEvent_ChangeVariable Event detected for " & $VariableName & "(new value " & $VariableValue & ").")
	
	;Convert array variables from $asMyArray[1] format to $asMyArray
	Local $iOpenSquareBracketPos
	$iOpenSquareBracketPos = StringInStr($VariableName,"[")
	If $iOpenSquareBracketPos <> 0 Then
		$VariableName = StringLeft($VariableName, $iOpenSquareBracketPos - 1)
	EndIf
	
	;Check if the variable os actually a variable
	If IsDeclared($VariableName) <> 1 Then
		CheckForVariableChange($VariableName)
	Else
		#Region --- CodeWizard generated code Start ---
		;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Warning
		MsgBox(48,"_AutoIt Debugger Include","AutoIt Debugger GUI sent attempted to change the value of an undeclared variable (" & $VariableName & ")")
		#EndRegion --- CodeWizard generated code End ---
	EndIf
EndFunc

Func AutoItDebuggerEvent_Quit()
	;MsgBox(0,"AutoIt Debugger", "Call to exit.")
	$AutoItDebugger_ClosedByUser = 1
	Exit
EndFunc

Func AutoIt_Debugger_NextLine($Filepath, $LineNumber, $NextLine_Error, $NextLine_Extended)
	;Send the @error and @extended data on each new line
	$oDebugWrapper.SendVariable("@error", $NextLine_Error)
	$oDebugWrapper.SendVariable("@extended", $NextLine_Extended)
	;$oDebugWrapper.SendVariable("@error" & $LineNumber, $NextLine_Error)
	;$oDebugWrapper.SendVariable("@extended" & $LineNumber, $NextLine_Extended)

	;Send new line status to the Debug GUI
	$oDebugWrapper.NewLine($Filepath, $LineNumber)

	;Wait for the GUI to come off pause
	While $oDebugWrapper.Paused
	WEnd

	;Set error codes for the rest of the program
	SetError($NextLine_Error, $NextLine_Extended)
EndFunc

Func AutoIt_Debugger_WaitForExit()
	If IsObj($oDebugWrapper) = 1 Then
		If Not $AutoItDebugger_ClosedByUser Then
			MsgBox(0,"AutoIt Debugger", "Script has finished. Click to OK to close the debug window.")
		EndIf
		
		$oDebugWrapper.ExitProgram()
		$oDebugWrapper = 0
	EndIf
EndFunc

Func AutoIt_Debugger_LoadFile($ORiginalScriptFilePath, $ORiginalScriptFileName)
	$oDebugWrapper.LoadFile($ORiginalScriptFilePath, $ORiginalScriptFileName)
EndFunc

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
					$oDebugWrapper.SendVariable($VariableName & "[" & $iDimXIndex & "]", AutoIt_Debugger_ReturnVariableValue($VariableValue[$iDimXIndex]))
				Next
				
			Case $iNumberOfDims = 2
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($VariableValue, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($VariableValue, 2) - 1
						$oDebugWrapper.SendVariable($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "]", AutoIt_Debugger_ReturnVariableValue($VariableValue[$iDimXIndex][$iDimYIndex]))
					Next
				Next
				
			Case $iNumberOfDims = 3
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($VariableValue, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($VariableValue, 2) - 1
						;Repeat for each Z dimension
						For $iDimZIndex = 0 To UBound($VariableValue, 3) - 1
							$oDebugWrapper.SendVariable($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "][" & $iDimZIndex & "]", AutoIt_Debugger_ReturnVariableValue($VariableValue[$iDimXIndex][$iDimYIndex][$iDimZIndex]))
						Next
					Next
				Next
		
			Case Else
				$oDebugWrapper.SendVariable($VariableName, "<Array has too many dims>")
		EndSelect
	Else
		$oDebugWrapper.SendVariable($VariableName, AutoIt_Debugger_ReturnVariableValue($VariableValue))
	EndIf

	;Set error codes for the rest of the program
	SetError($SendVariable_Error, $SendVariable_Extended)
EndFunc

Func AutoIt_Debugger_ReturnVariableValue($VariableValue)
	If IsBool($VariableValue) OR IsFloat($VariableValue) OR IsInt($VariableValue) OR IsNumber($VariableValue) OR IsString($VariableValue) Then
		Return $VariableValue
	ElseIf IsArray($VariableValue) Then
		Return "<Array>"
	ElseIf IsObj($VariableValue) Then
		Return "<Object>"
	ElseIf IsBinaryString($VariableValue) Then
		Return "<BinaryString>(" & String($VariableValue) & ")"
	ElseIf IsHWnd($VariableValue) Then
		Return "<HWnd>(" & String($VariableValue) & ")"
	ElseIf IsKeyword($VariableValue) Then
		Return $VariableValue
	ElseIf Not IsDeclared($VariableValue) Then
		Return "<Undeclared>"
	EndIf
EndFunc

Func AutoIt_Debugger_GetVariableFromEvent($VariableName, ByRef $Variable)
	;_FileWriteLog("C:\Program Files\AutoIt3\AutoIt Debugger\_AutoIt Debugger Include.au3.log", "AutoIt_Debugger_GetVariableFromEvent Function call for " & $VariableName)

	Local $iNumberOfDims
	Local $iDimXIndex
	Local $iDimYIndex
	Local $iDimZIndex
	
	If IsBool($Variable) OR IsFloat($Variable) OR IsInt($Variable) OR IsNumber($Variable) OR IsString($Variable) Then
		$Variable = $oDebugWrapper.ReadVariable($VariableName)
	ElseIf IsArray($Variable) Then
		;Find the number of dimensions
		$iNumberOfDims = UBound($Variable, 0)
		Select
			Case $iNumberOfDims = 1
				;Send each array index seperatly
				For $iDimXIndex = 0 To UBound($Variable, 1) - 1
					$Variable[$iDimXIndex] = $oDebugWrapper.ReadVariable($VariableName & "[" & $iDimXIndex & "]")
				Next
				
			Case $iNumberOfDims = 2
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($Variable, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($Variable, 2) - 1
						$Variable[$iDimXIndex][$iDimYIndex] = $oDebugWrapper.ReadVariable($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "]")
					Next
				Next
				
			Case $iNumberOfDims = 3
				;Repeat for each X dimension
				For $iDimXIndex = 0 To UBound($Variable, 1) - 1
					;Repeat for each Y dimension
					For $iDimYIndex = 0 To UBound($Variable, 2) - 1
						;Repeat for each Z dimension
						For $iDimZIndex = 0 To UBound($Variable, 3) - 1
							$Variable[$iDimXIndex][$iDimYIndex][$iDimZIndex] = $oDebugWrapper.ReadVariable($VariableName & "[" & $iDimXIndex & "][" & $iDimYIndex & "][" & $iDimZIndex & "]")
						Next
					Next
				Next
		
			Case Else
				;Do nothing
		EndSelect		

	ElseIf IsObj($Variable) Then
		;Do nothing
	ElseIf IsBinaryString($Variable) Then
		;Do nothing
	ElseIf IsHWnd($Variable) Then
		;Do nothing
	ElseIf IsKeyword($Variable) Then
		;Do nothing
	EndIf
EndFunc

;Func VersionCheck($MinimumVersion)
;	Local $CurrentVersion[3] ; [0] - Major, [1] - Minor, [2] - Revision, [3] - Build
;	Local $MinimumVersion[3] ; [0] - Major, [1] - Minor, [2] - Revision, [3] - Build
;	
;	$CurrentVersion = StringSplit(@AutoItVersion, ".")
;	$MinimumVersion = StringSplit($MinimumVersion, ".")
;	
;	If $CurrentVersion[0] > $MinimumVersion[0] Then
;		; Major build is newer
;		Return 1
;	ElseIf $CurrentVersion[0] = $MinimumVersion[0] Then
;		; Major build is same, check the rest
;		If $CurrentVersion[1] > $MinimumVersion[1] Then
;			; Minor build is newer
;			Return 1
;		ElseIf $CurrentVersion[1] = $MinimumVersion[1] Then
;			; Minor build is same, check the rest
;			If $CurrentVersion[2] > $MinimumVersion[2] Then
;				; Revision build is newer
;				Return 1
;			ElseIf $CurrentVersion[2] = $MinimumVersion[2] Then
;				; Revision build is same, check the rest
;				If $CurrentVersion[3] > $MinimumVersion[3] Then
;					; Revision build is newer
;					Return 1
;				ElseIf $CurrentVersion[3] = $MinimumVersion[3] Then
;					; Revision build is same
;					Return 1
;				Else
;					; Revision build is older
;					Return 0
;				EndIf
;			Else
;				; Revision build is older
;				Return 0
;			EndIf
;		Else
;			; Minor build is older
;			Return 0
;		EndIf
;	Else
;		; Major build is older
;		Return 0
;	EndIf
;	
;EndFunc
