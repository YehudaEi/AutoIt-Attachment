;===============================================================================
;
; Description:			Returns the requested property or an array of all properties
;							for the specified file.
; Syntax:				_GetFileProperty( $sPath, optional $sProp )
; Parameter(s):		$sPath -	Path and filename of the file to query
;							$sProp -	(optional) Name of property to return
;										if not specified will return array of all properties
; Requirement(s):		AutoIt 3.2 or higher
; Return Value(s):	On Success - Returns string value of property OR
;											 Returns 2 dimensional array (property name,value)
;							On Failure - Returns nothing
;											 @error = 1 - file does not exist
;											 @error = 2 - unable to get property
; Author(s):			Sean Hart (autoit AT hartmail DOT ca)
;							(idea from GetExtProperty by Simucal, thanks)
; Note(s):				Special 
;
;===============================================================================
Func _GetFileProperty($sPath, $sProp = "")
	; Declare local variables
	Local $sFile, $sDir, $oShell, $oDir, $oFile, $i, $count, $aProps[1][3]
	
	; Init counter used for array of properties
	$count = 0
	
	; Check file exists first
	If Not FileExists($sPath) Then
		SetError(1)
		Return
	Else
		; Pull file name and directory from full file path
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		
		; Create required objects
		$oShell = ObjCreate("shell.application")
		$oDir = $oShell.NameSpace($sDir)
		$oFile = $oDir.Parsename($sFile)
		
		; Loop through 99 possible property numbers (allows for future additions to property fields)
		For $i = 0 to 99
			; If no property specified then add to array
			If ($sProp = "") Then
				; Only add if property name is not blank
				If ($oDir.GetDetailsOf($oDir.Items, $i) <> "") Then
					; Increase counter and redimension array
					$count = $count + 1
					ReDim $aProps[$count + 1][3]
					
					; Add property name and value to array
					$aProps[$count][1] = $oDir.GetDetailsOf($oDir.Items, $i)
					$aProps[$count][2] = $oDir.GetDetailsOf($oFile, $i)
				EndIf
				
			; If property name matches property being requested, return value
			ElseIf $oDir.GetDetailsOf($oDir.Items, $i) = $sProp Then
				Return $oDir.GetDetailsOf($oFile, $i)
			EndIf
		Next
		
		; If array was populated return array, otherwise return error 2
		If $count > 0 Then
			Return $aProps
		Else
			SetError(2)
			Return
		EndIf
	EndIf
EndFunc   ;==>_GetFileProperty
