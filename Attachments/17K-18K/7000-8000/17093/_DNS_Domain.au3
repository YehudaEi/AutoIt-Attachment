;===============================================================================
; Description:		Returns the "Connection-specific DNS Suffix"
; Parameter(s):		$iFullName - Return full name or just Domain
;						Default: 0 returns just the domain (e.g. domain.com)
;						Any other value returns the full domain (e.g. something.domain.com)
; Requirement(s):	None
; Return Value(s):	On Success - String: Connection-specific DNS Domain
;					On Failure - 0  and Set
;						@ERROR to:	1 - Error getting WMI Service Object
;									2 - No DNS entries found
;									3 - Return from query was not an object
; Author(s):		JerryD
; Note(s):
;===============================================================================
Func _DNS_Domain( $iFullName = 0 )
	Local $sRet = '', $colItems = '', $objItem = ''
	Local $objWMIService = ObjGet('winmgmts:\\localhost\root\CIMV2'    )
	If @error Then
		SetError( 1, 0, $sRet ) 	; Error creating WMI Object
	Else
		$colItems = $objWMIService.ExecQuery ('SELECT * FROM Win32_NetworkAdapterConfiguration'    , 'WQL'    , 0x10 + 0x20 )
		If IsObj( $colItems ) Then
			For $objItem In $colItems
				If $objItem.DNSDomain Then
					If $iFullName Then
						$sRet = $objItem.DNSDomain
					Else
						$sRet = StringTrimLeft( $objItem.DNSDomain, StringInStr($objItem.DNSDomain, '.'    , 0, -2) )
					EndIf
					ExitLoop
				EndIf
			Next
			If Not $sRet Then
				SetError( 2, 0, $sRet )
			EndIf
		Else
			SetError( 3, 0, $sRet ) 	; Return from WMI Query was not an Object
		EndIf
	EndIf
	$objWMIService = ''
	$colItems = ''
	$objItem = ''
	Return $sRet
EndFunc   ;==>_DNS_Domain
