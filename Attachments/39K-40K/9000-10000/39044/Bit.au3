#include-once

Global $strComputer = @ComputerName, $GName = "Administrators", $cGroups, $lusr, $cUsers
Global $adObj_displayName, $TextBody, $sub, $From, $objEmail,$cGroups,$cUsers,$VirtualDesktopWidth
Global $objItem,$objWMIService,$colItems,$bios,$modeltype
	Global $aRet[2]
	Global Const $SM_VIRTUALWIDTH = 78
	Global Const $SM_VIRTUALHEIGHT = 79
;===============================================================================
; Description:      Sends an email to the administrators.
; Parameter(s):     $TextBody - By Reference - Computer name.
; Return Value(s):  On Success - Sends email.
; ===============================================================================
;SendMail
Func SendMail($adObj_displayName, $TextBody, $sub)
	$From = StringSplit($adObj_displayName, ",")
	;	_FileWriteLog($Logpath, "INFO > Function Call >" & "Now the script is running on the function ---> mail<----")
	$objEmail = ObjCreate("CDO.Message")
		$objEmail.From = $From[2] & "." & $From[1] & "@kcc.com"
	$objEmail.To = "NiteshKumar.Garg@kcc.com"
	;$objEmail.To = "syed.ibrahim@kcc.com"
	$objEmail.Cc = "syed.ibrahim@kcc.com;Raghavendra.CM@kcc.com"
	$objEmail.Subject = $sub
	$objEmail.Textbody = $TextBody
	$objEmail.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/smtpserver") = _
			"165.28.7.146" ;  <--------------------------------------------------- CONFIGURE YOUR SMPT SERVER CORRECTLY!
	$objEmail.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	$objEmail.Configuration.Fields.Update
	$objEmail.Send
EndFunc   ;==>SendMail

Func _GetTotalScreenResolution()

	$VirtualDesktopWidth = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
	$aRet[0] = $VirtualDesktopWidth[0]
	$VirtualDesktopHeight = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALHEIGHT)
	$aRet[1] = $VirtualDesktopHeight[0]
	Return $aRet
EndFunc
;===============================================================================
; Description:      retrives the BIOS version of the current running machine
; Parameter(s):
; Return Value(s):  On Success - Returns version of the BIOS.
; On Failure: @error = 1; sets the error value as 1. which indicates $objWMIService does not return a object.
; ===============================================================================
;modeltype
Func BIOS()
Local $bios1
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
If IsObj($objWMIService) Then
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_BIOS","WQL",48)
For $objItem in $colItems
    $bios1 = $objItem.SMBIOSBIOSVersion

	$bios = StringSplit($bios1," ",1)

Next
Else
SetError(1,@error,0)
EndIf
Return $bios[3]
EndFunc
;===============================================================================
; Description:      Checks whether the GD911 account exists on local account
; Parameter(s):
; Return Value(s):  On Success - Returns True.
; On Failure: @error = 1; sets the error value as 1. which indicates unable to extract the membership.
; ===============================================================================
;modeltype
Func GD911()
	$cUsers = ObjGet("WinNT://" & $strComputer)
	If IsObj($cUsers) Then
		For $oUser In $cUsers
			$lusr = $oUser.Name
			If StringInStr($lusr, "GD911") Then
				Return True
			EndIf
		Next
	Else
		SetError(1,@error,0)

	EndIf
EndFunc   ;==>GD911
;===============================================================================
; Description:      Checks for the local GDGUEST account exists on Administrator group
; Parameter(s):
; Return Value(s):  On Success - Returns TRUE.
; On Failure: @error = 1; sets the error value as 1. which indicates unable to extract the members details.
; ===============================================================================
;modeltype
Func GDGUEST()
	$cGroups = ObjGet("WinNT://" & $strComputer)
	If IsObj($cGroups) Then
		For $oGroup In $cGroups
			If $oGroup.Name = $GName Then
				For $oUser In $oGroup.Members
					$lusr = $oUser.Name
					If StringInStr($lusr, "GDGUEST") Then
						Return True
					EndIf
				Next
			EndIf
		Next
	Else
		SetError(1,@error,0)
	EndIf

EndFunc   ;==>GDGUEST


;===============================================================================
; Description:      retrives the model type of the machine. e.g:- HP Compaq DCxxxx Micro Tower
; Parameter(s):
; Return Value(s):  On Success - Returns the model value.
; On Failure: @error = 1; sets the error value as 1. which indicates $objWMIService does not return a object.
; ===============================================================================
;modeltype
Func modeltype()
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery( "SELECT * FROM Win32_ComputerSystem","WQL",48)
If IsObj($objWMIService) Then
For $objItem in $colItems
    $modeltype = $objItem.Model
Next
Else
SetError(1, @error, 0)
EndIf
Return $modeltype
EndFunc