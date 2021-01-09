#include-once

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_VirtualDirectoryProperties
; Description ...:	Modifies select properties for FTP Virtual Directories
; Syntax.........:	_VirtualDirectoryProperties($sUserName, $sProperty, $bAccess [, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$sProperty - One of the following:
;								"AccessWrite"							; Allows Write Access
;					$bAccess - True or False
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	
; Author ........:	Colin Flanders
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================
Func _VirtualDirectoryProperties($sUserName, $sProperty, $bAccess, $sComputer = @ComputerName)
	Local $objWMIService = ObjGet("winmgmts:{authenticationLevel=pktPrivacy}\\" & $sComputer & "\root\microsoftiisv2")
	Local $colItems = $objWMIService.ExecQuery('Select * from IIsFtpVirtualDirSetting Where Name like "%' & $sUserName & '%"')
	
	For $objItem In $colItems
		Select
			Case $sProperty = "AccessWrite"
				$objItem.AccessWrite = $bAccess
		EndSelect
		$objItem.Put_
	Next
EndFunc ;==> _VirtualDirectoryProperties()