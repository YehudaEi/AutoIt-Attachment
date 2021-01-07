;===============================================================================
;
; Function Name:    _CpuRole()
; Description:      Returns the role of the computer as an integer or string
; Parameter(s):     $strComputer = 'localhost' - Default is current computer (localhost)
;									Can be remote computer name or IP address (NOT WELL TESTED)
;
;					$iRetType = 1 - 1 = Return a string,
;										anything else will return an integer as follows:
;										0 = 'Standalone Workstation'
;										1 = 'Member Workstation'
;										2 = 'Standalone Server'
;										3 = 'Member Server'
;										4 = 'Backup Domain Controller'
;										5 = 'Primary Domain Controller'
;
; Requirement(s):   AutoIt 3.1.1 Beta
; Return Value(s):  On Success Returns the computer role as either a string or integer
;                   On Failure Returns an empty string ('')  and sets @ERROR = 1
;
; Reference:		WMI ScriptOMatic tool for AutoIt by SvenP
;					http://www.autoitscript.com/forum/index.php?showtopic=10534&hl
; Author(s):        JerryD
;
;===============================================================================
;
Func _CpuRole($strComputer = 'localhost', $iRetType = 1)
	Dim $aRoles[6]
	$aRoles[0] = 'Standalone Workstation'
	$aRoles[1] = 'Member Workstation'
	$aRoles[2] = 'Standalone Server'
	$aRoles[3] = 'Member Server'
	$aRoles[4] = 'Backup Domain Controller'
	$aRoles[5] = 'Primary Domain Controller'
	Const $wbemFlagReturnImmediately = 0x10
	Const $wbemFlagForwardOnly = 0x20
	Local $colItems = '', $Output = '', $objWMIService, $colItems
	
	; This sets defaults in case they're specified by either '' or -1
	If $strComputer = '' Or $strComputer = -1 Then
		$strComputer = 'localhost'
	EndIf
	If $iRetType = '' Or $iRetType = -1 Then
		$iRetType = 1
	ElseIf $iRetType <> 1 Then
		$iRetType = 0
	EndIf
	
	; Get the info
	$objWMIService = ObjGet('winmgmts:\\' & $strComputer & '\root\CIMV2')
	$colItems = $objWMIService.ExecQuery ('SELECT * FROM Win32_ComputerSystem', 'WQL', $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	; Return what's found
	If Not IsObj($colItems) Then
		$objWMIService = ''
		$colItems = ''
		SetError(1)
		Return ''
	Else
		For $objItem In $colItems
			$Output = $objItem.DomainRole
		Next
		$objWMIService = ''
		$colItems = ''
		If $iRetType Then
			Return $aRoles[$Output]
		Else
			Return $Output
		EndIf
	EndIf
EndFunc   ;==>_CpuRole
