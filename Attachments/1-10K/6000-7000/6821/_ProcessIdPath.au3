
MsgBox ( 0, 'This proccess path:', _ProcessIdPath(@AutoItPID) ) 

;===============================================================================
;
; Function Name:		_ProcessIdPath () 
; Description:			Returns the full path of a Process ID
; Parameter ( s ):		$vPID	- Process ID  (String or Integer) 
; Requirement ( s ):	AutIt 3.1.1 (tested with version 3.1.1.107)
; Return Value ( s ):	On Success - Returns the full path of the PID Executeable
;						On Failure - returns a blank string
;						@ERROR = 1 - Process doesn't exist  ( ProcessExist ( $vPID ) =0 ) 
;						@ERROR = 2 - Path is unknown
;									 $objItem.ExecutablePath=0
;												AND
;									 @SystemDir\$objItem.Caption doesn't exist
;						@ERROR = 3 - Process Not Found  ( in WMI ) 
;						@ERROR = 4 - WMI Object couldn't be created
;						@ERROR = 5 - Unknown Error
; Author:				JerryD
;
;===============================================================================
;
Func _ProcessIdPath ( $vPID ) 
	Local $objWMIService, $oColItems
	Local $sNoExePath = ''
	Local Const $wbemFlagReturnImmediately = 0x10
	Local Const $wbemFlagForwardOnly = 0x20
	
	Local $RetErr_ProcessDoesntExist = 1
	Local $RetErr_ProcessPathUnknown = 2
	Local $RetErr_ProcessNotFound = 3
	Local $RetErr_ObjCreateErr = 4
	Local $RetErr_UnknownErr = 5
	
	If Not ProcessExists ( $vPID )  Then
		SetError ( $RetErr_ProcessDoesntExist ) 
		Return $sNoExePath
	EndIf
	
	$objWMIService = ObjGet ( 'winmgmts:\\localhost\root\CIMV2' ) 
	$oColItems = $objWMIService.ExecQuery  ( 'SELECT * FROM Win32_Process', 'WQL', $wbemFlagReturnImmediately + $wbemFlagForwardOnly ) 
	
	If IsObj ( $oColItems )  Then
		For $objItem In $oColItems
			If $vPID = $objItem.ProcessId Then
				If $objItem.ExecutablePath = '0' Then
					If FileExists ( @SystemDir & '\' & $objItem.Caption )  Then
						Return @SystemDir & '\' & $objItem.Caption
					Else
						SetError ( $RetErr_ProcessPathUnknown ) 
						Return $sNoExePath
					EndIf
				Else
					Return $objItem.ExecutablePath
				EndIf
			EndIf
		Next
		SetError ( $RetErr_ProcessNotFound ) 
		Return $sNoExePath
	Else
		SetError ( $RetErr_ObjCreateErr ) 
		Return $sNoExePath
	EndIf
	
	SetError ( $RetErr_UnknownErr ) 
	Return $sNoExePath
EndFunc   ;==>_ProcessIdPath
