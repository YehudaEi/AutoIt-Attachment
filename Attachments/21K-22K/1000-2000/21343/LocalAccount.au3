#include-once

#region Global constant declaration

; Constants for use in _AccountDisableProperty and _AccountEnableProperty functions, $bProperty parameter

Global Const $ADS_UF_SCRIPT = 0x0001							; Logon script will be executed
Global Const $ADS_UF_ACCOUNTDISABLE = 0x0002					; Account is disabled
Global Const $ADS_UF_HOMEDIR_REQUIRED = 0x0008					; Account requires a home directory
Global Const $ADS_UF_LOCKOUT = 0x0010							; Account is locked out
Global Const $ADS_UF_PASSWD_NOTREQD = 0x0020					; Account does not require a password
Global Const $ADS_UF_PASSWD_CANT_CHANGE = 0x0040				; User cannot change password
Global Const $ADS_UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED = 0x0080	; Encrypted text password allowed
Global Const $ADS_UF_DONT_EXPIRE_PASSWD = 0x10000				; Account password never expires
Global Const $ADS_UF_SMARTCARD_REQUIRED = 0x40000				; Smartcard required for logon
Global Const $ADS_UF_PASSWORD_EXPIRED = 0x800000				; Password has expired

#endregion Global constant declaration

#region COM error handler

Global $IADsError = 0

$objIADsError = ObjEvent("AutoIt.Error", "objIADsErrFunc")

Func objIADsErrFunc()
	$IADsError = -1
EndFunc ;==> objIADsErrFunc

#endregion COM error handler

; ===============================================================================================================================
;==============================================================================================================================
; #CURRENT# =====================================================================================================================
;_AccountAddToGroup
;_AccountChangePassword
;_AccountCreate
;_AccountDelete
;_AccountDisableProperty
;_AccountEnableProperty
;_AccountEnum
;_AccountEnumGroups
;_AccountExists
;_AccountIsMember
;_AccountRemoveFromGroup
;_AccountRename
;_AccountSetExpirationDate
;_AccountSetInfo
;_AccountSetPassword
;_GroupCreate
;_GroupDelete
;_GroupEnum
;_GroupEnumMembers
;_GroupExists
;_GroupRename
;_GroupSetInfo
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountAddToGroup
; Description ...:	Adds a local user account to an existing local group
; Syntax.........:	_AccountAddToGroup($sUserName, $sGroup [, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$sGroup - Local group name
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountAddToGroup($sUserName, $sGroup, $sComputer = @ComputerName)
	Local $objGroup = ObjGet("WinNT://" & $sComputer & "/" & $sGroup & ", group")
	$objGroup.Add("WinNT://" & $sComputer & "/" & $sUserName)
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountAddToGroup

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountChangePassword
; Description ...:	Changes the password of a local user account
; Syntax.........:	_AccountChangePassword($sUserName, $sOldPassword, $sNewPassword [, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$sOldPassword - Old password
;					$sNewPassword - New password
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountChangePassword($sUserName, $sOldPassword, $sNewPassword, $sComputer = @ComputerName)
	Local $objUser = ObjGet("WinNT://" & $sComputer & "/" & $sUserName & ", user")
	$objUser.ChangePassword($sOldPassword, $sNewPassword)
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountChangePassword

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountCreate
; Description ...:	Creates a local user account on a computer
; Syntax.........:	_AccountCreate($sUserName [, $sPassword, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$sPassword - [Optional] Desired password
;								Default is no password
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountCreate($sUserName, $sPassword = "", $sComputer = @ComputerName)
	Local $objSystem = ObjGet("WinNT://" & $sComputer)
	Local $objUser = $objSystem.Create("user", $sUserName)
	$objUser.SetPassword($sPassword)
	$objUser.SetInfo
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountCreate

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountDelete
; Description ...:	Deletes a local user account from a computer
; Syntax.........:	_AccountDelete($sUserName [, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountDelete($sUserName, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("WinNT://" & $sComputer)
	$objSystem.Delete("user", $sUserName)
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountDelete

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountDisableProperty
; Description ...:	Disables a local user account property
; Syntax.........:	_AccountDisableProperty($sUserName, $bProperty [, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$bProperty - One of the following constants:
;								$ADS_UF_SCRIPT							; Logon script will be executed
;								$ADS_UF_ACCOUNTDISABLE					; Account is disabled
;								$ADS_UF_HOMEDIR_REQUIRED				; Account requires a home directory
;								$ADS_UF_LOCKOUT							; Account is locked out
;								$ADS_UF_PASSWD_NOTREQD					; Account does not require a password
;								$ADS_UF_PASSWD_CANT_CHANGE				; User cannot change password
;								$ADS_UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED	; Encrypted text password allowed
;								$ADS_UF_DONT_EXPIRE_PASSWD				; Account password never expires
;								$ADS_UF_SMARTCARD_REQUIRED				; Smartcard required for logon
;								$ADS_UF_PASSWORD_EXPIRED				; Password has expired
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountDisableProperty($sUserName, $bProperty, $sComputer = @ComputerName)
	Local $objUser = ObjGet("WinNT://" & $sComputer & "/" & $sUserName & ", user")
	Local $objUserFlags = $objUser.Get("UserFlags")
	If BitAND($objUserFlags, $bProperty) Then
		$objUser.Put( "UserFlags", BitXOR($objUserFlags, $bProperty) )
		$objUser.SetInfo
	EndIf
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountDisableProperty

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountEnableProperty
; Description ...:	Enables a local user account property
; Syntax.........:	_AccountEnableProperty($sUserName, $bProperty [, $sComputer])
; Parameters ....:	$sUserName - Local user account name
;					$bProperty - One of the following constants:
;								$ADS_UF_SCRIPT							; Logon script will be executed
;								$ADS_UF_ACCOUNTDISABLE					; Account is disabled
;								$ADS_UF_HOMEDIR_REQUIRED				; Account requires a home directory
;								$ADS_UF_LOCKOUT							; Account is locked out
;								$ADS_UF_PASSWD_NOTREQD					; Account does not require a password
;								$ADS_UF_PASSWD_CANT_CHANGE				; User cannot change password
;								$ADS_UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED	; Encrypted text password allowed
;								$ADS_UF_DONT_EXPIRE_PASSWD				; Account password never expires
;								$ADS_UF_SMARTCARD_REQUIRED				; Smartcard required for logon
;								$ADS_UF_PASSWORD_EXPIRED				; Password has expired
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountEnableProperty($sUserName, $bProperty, $sComputer = @ComputerName)
	Local $objUser = ObjGet("WinNT://" & $sComputer & "/" & $sUserName & ", user")
	Local $objUserFlags = $objUser.Get("UserFlags")
	If Not BitAND($objUserFlags, $bProperty) Then
		$objUser.Put( "UserFlags", BitXOR($objUserFlags, $bProperty) )
		$objUser.SetInfo
	EndIf
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountEnableProperty

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountEnum
; Description ...:	Enumerates local user accounts
; Syntax.........:	_AccountEnum([$sComputer])
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns an array of local user accounts existent on $sComputer
;							$Array[0] = number of accounts
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountEnum($sComputer = @ComputerName)
	Local $iUbound, $asArray[1]
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objUserList = $objSystem.ExecQuery('Select * from Win32_UserAccount Where Domain="' & $sComputer & '"')
	For $objUser In $objUserList
		$iUbound = UBound($asArray)
		ReDim $asArray[$iUbound + 1]
		$asArray[$iUbound] = $objUser.Name
	Next
	$asArray[0] = UBound($asArray) - 1
	Return $asArray
EndFunc ;==> _AccountEnum

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountEnumGroups
; Description ...:	Enumerates local user groups the local user account is associated with
; Syntax.........:	_AccountEnumGroups($sUserName [ ,$sComputer])
;					$sUserName - Local user account name
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns an array of local user groups associated with $sUserName
;							$Array[0] = number of groups
;					Failure - Returns 0 and sets @error to -2 if the local user account does no exist
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountEnumGroups($sUserName, $sComputer = @ComputerName)
	If Not _AccountExists($sUserName, $sComputer) Then Return SetError(-2, 0, 0)
	Local $iUbound, $asArray[1]
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objGroupList = $objSystem.ExecQuery('Associators of {Win32_UserAccount.Domain="' & $sComputer & _
	'",Name="' & $sUserName & '"} Where AssocClass=Win32_GroupUser')
	For $objGroup In $objGroupList
		$iUbound = UBound($asArray)
		ReDim $asArray[$iUbound + 1]
		$asArray[$iUbound] = $objGroup.Name
	Next
	$asArray[0] = UBound($asArray) - 1
	Return $asArray
EndFunc ;==> _AccountEnumGroups

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountExists
; Description ...:	Checks if a local user account exists on a computer
; Syntax.........:	_AccountExists($sUserName [ ,$sComputer])
;					$sUserName - Local user account name
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1 if the local account exists
;							Returns 0 if the local account does not exist
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountExists($sUserName, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objUserList = $objSystem.ExecQuery('Select * from Win32_UserAccount Where Domain="' & $sComputer & _
	'" And Name="' & $sUserName & '"')
	For $objUser In $objUserList
		Return 1
	Next
	Return 0
EndFunc ;==> _AccountExists

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountIsMember
; Description ...:	Checks if a local user account is member of a local group
; Syntax.........:	_AccountIsMember($sUserName, $sGroup [ ,$sComputer])
;					$sUserName - Local user account name
;					$sGroup - Local group name
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1 if the user account is member of the group
;							Returns 0 if the user account isn't member of the group
;					Failure - Returns 0 and sets @error to -2 if either the account or group does not exist
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountIsMember($sUserName, $sGroup, $sComputer = @ComputerName)
	Local $asGroup = _AccountEnumGroups($sUserName, $sComputer)
	If @error Or Not _GroupExists($sGroup, $sComputer) Then Return SetError(-2, 0, 0)
	For $g = 1 To $asGroup[0]
		If $asGroup[$g] = $sGroup Then Return 1
	Next
	Return 0
EndFunc ;==> _AccountIsMember

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountRemoveFromGroup
; Description ...:	Removes a local user account from a local group
; Syntax.........:	_AccountRemoveFromGroup($sUserName, $sGroup [ ,$sComputer])
;					$sUserName - Local user account name
;					$sGroup - Local group name
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountRemoveFromGroup($sUserName, $sGroup, $sComputer = @ComputerName)
	Local $objGroup = ObjGet("WinNT://" & $sComputer & "/" & $sGroup & ", group")
	$objGroup.Remove("WinNT://" & $sComputer & "/" & $sUserName)
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountRemoveFromGroup

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountRename
; Description ...:	Renames a local user account
; Syntax.........:	_AccountRename($sUserName, $sNewName [ ,$sComputer])
;					$sUserName - Current local user account name
;					$sNewName - New name for the local user account
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to one of the following values
;							-2 	User or Domain not found
;							1 	Instance not found
;							2 	Instance required
;							3 	Invalid parameter
;							4 	User not found
;							5 	Domain not found
;							6 	Operation is allowed only on the primary domain controller of the domain
;							7 	Operation is not allowed on the last administrative account
;							8 	Operation is not allowed on specified special groups: user, admin, local, or guest
;							9 	Other API error
;							10 	Internal error
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountRename($sUserName, $sNewName, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objUserList = $objSystem.ExecQuery('Select * from Win32_UserAccount Where Domain="' & $sComputer & _
	'" And Name="' & $sUserName & '"')
	For $objUser In $objUserList
		If $objUser.Rename($sNewName) = 0 Then Return 1
	Next
	Return SetError(-2, 0, 0)
EndFunc ;==> _AccountRename

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountSetExpirationDate
; Description ...:	Sets the expiration date of a local user account
; Syntax.........:	_AccountSetExpirationDate($sUserName, $sDate [ ,$sComputer])
;					$sUserName - Local user account name
;					$sDate - Desired expiration date in the form 'Month/Day/Year Hour:Minute AM/PM'
;							'0' will disable account expiration
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;	_AccountSetExpirationDate("User", "11/01/2008 08:30 PM")
;
; ===============================================================================================================================

Func _AccountSetExpirationDate($sUserName, $sDate, $sComputer = @ComputerName)
	Local $objUser = ObjGet("WinNT://" & $sComputer & "/" & $sUserName & ", user")
	$objUser.AccountExpirationDate = $sDate
	$objUser.SetInfo
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountSetExpirationDate

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountSetInfo
; Description ...:	Defines information related to a local user account
; Syntax.........:	_AccountSetInfo($sUserName [, $sFullName, $sDescr, $sComputer])
;					$sUserName - Local user account name
;					$sFullName - [Optional] Complete name of the local user account holder
;								Use Default keyword if you don't want to set a full name
;					$sDescr - [Optional] Description of the local user account
;							Use Default keyword if you don't want to set a description
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountSetInfo($sUserName, $sFullName = Default, $sDescr = Default, $sComputer = @ComputerName)
	Local $objUser = ObjGet("WinNT://" & $sComputer & "/" & $sUserName & ", user")
	With $objUser
		If $sFullName <> Default Then .FullName = $sFullName
		If $sDescr <> Default Then .Description = $sDescr
		.SetInfo
	EndWith
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountSetInfo

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_AccountSetPassword
; Description ...:	Sets a local user account password
; Syntax.........:	_AccountSetPassword($sUserName [, $sPassword, $sDate, $sComputer])
;					$sUserName - Local user account name
;					$sPassword - [Optional] Desired password
;								Use Default keyword if don't want to set the password
;					$sDate - [Optional] Desired password expiration date in the form 'Month/Day/Year Hour:Minute AM/PM'
;							'0' will disable password expiration
;							Use Default keyword if don't want to set a password expiration date
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _AccountSetPassword($sUserName, $sPassword = Default, $sDate = Default, $sComputer = @ComputerName)
	Local $objUser = ObjGet("WinNT://" & $sComputer & "/" & $sUserName & ", user")
	With $objUser
		If $sPassword <> Default Then .SetPassword($sPassword)
		If $sDate <> Default Then .PasswordExpirationDate = $sDate
		.SetInfo
	EndWith
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _AccountSetPassword

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupCreate
; Description ...:	Creates a local group on a computer
; Syntax.........:	_GroupCreate($sGroup [,$sComputer])
; Parameters ....:	$sGroup - Local group name
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupCreate($sGroup, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("WinNT://" & $sComputer)
	Local $objGroup = $objSystem.Create("group", $sGroup)
	$objGroup.SetInfo
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _GroupCreate

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupDelete
; Description ...:	Deletes a local group from a computer
; Syntax.........:	_GroupDelete($sGroup [,$sComputer])
; Parameters ....:	$sGroup - Local group name
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupDelete($sGroup, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("WinNT://" & $sComputer)
	$objSystem.Delete("group", $sGroup)
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _GroupDelete

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupEnum
; Description ...:	Enumerates local groups on a computer
; Syntax.........:	_GroupEnum([$sComputer])
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns an array of local groups existent on $sComputer
;							$Array[0] = number of groups
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupEnum($sComputer = @ComputerName)
	Local $iUbound, $asArray[1]
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objGroupList = $objSystem.ExecQuery('Select * from Win32_Group Where Domain="' & $sComputer & '"')
	For $objGroup In $objGroupList
		$iUbound = UBound($asArray)
		ReDim $asArray[$iUbound + 1]
		$asArray[$iUbound] = $objGroup.Name
	Next
	$asArray[0] = UBound($asArray) - 1
	Return $asArray
EndFunc ;==> _GroupEnum

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupEnumMembers
; Description ...:	Enumerates local accounts that are members of a local group
; Syntax.........:	_GroupEnumMembers($sGroup [ ,$sComputer])
; Parameters ....:	$sGroup - Local group name
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns an array of local user accounts associated with the local group
;							$Array[0] = number of local user accounts
;					Failure - Returns 0 and sets @error to -2 if the local group does no exist
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupEnumMembers($sGroup, $sComputer = @ComputerName)
	If Not _GroupExists($sGroup, $sComputer) Then Return SetError(-2, 0, 0)
	Local $iUbound, $asArray[1]
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objUserList = $objSystem.ExecQuery('Associators of {Win32_Group.Domain="' & $sComputer & _
		'",Name="' & $sGroup & '"} Where AssocClass=Win32_GroupUser')
	For $objUser In $objUserList
		$iUbound = UBound($asArray)
		ReDim $asArray[$iUbound + 1]
		$asArray[$iUbound] = $objUser.Name
	Next
	$asArray[0] = UBound($asArray) - 1
	Return $asArray
EndFunc ;==> _GroupEnumMembers

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupExists
; Description ...:	Checks if a local group exists on a computer
; Syntax.........:	_GroupExists($sGroup [ ,$sComputer])
;					$sGroup - Local group name
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1 if the local group exists
;							Returns 0 if the local group does not exist
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupExists($sGroup, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objGroupList = $objSystem.ExecQuery('Select * from Win32_Group Where Domain="' & $sComputer & _
	'" And Name="' & $sGroup & '"')
	For $objGroup In $objGroupList
		Return 1
	Next
	Return 0
EndFunc ;==> _GroupExists

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupRename
; Description ...:	Renames a local group
; Syntax.........:	_GroupRename($sGroup, $sNewName [ ,$sComputer])
;					$sGroup - Current local group name
;					$sNewName - New name for the local group
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to one of the following values
;							-2 Group or Domain not found
;							1 Instance not found
;							2 Instance required
;							3 Invalid parameter
;							4 Group not found
;							5 Domain not found
;							6 Operation is allowed only on the primary domain controller
;							7 Operation not allowed on special groups: user, admin, local, or guest
;							8 Other API error
;							9 Internal error
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupRename($sGroup, $sNewName, $sComputer = @ComputerName)
	Local $objSystem = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
	Local $objGroupList = $objSystem.ExecQuery('Select * from Win32_Group Where Domain="' & $sComputer & _
	'" And Name="' & $sGroup & '"')
	For $objGroup In $objGroupList
		If $objGroup.Rename($sNewName) = 0 Then Return 1
	Next
	Return SetError(-2, 0, 0)
EndFunc ;==> _GroupRename

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_GroupSetInfo
; Description ...:	Defines information related to a local group
; Syntax.........:	_GroupSetInfo($sGroup, $sDescr [ ,$sComputer])
;					$sGroup - Local user group name
;					$sDescr - Description of the local group
; Parameters ....:	$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to -1
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _GroupSetInfo($sGroup, $sDescr, $sComputer = @ComputerName)
	Local $objGroup = ObjGet("WinNT://" & $sComputer & "/" & $sGroup & ", group")
	$objGroup.Description = $sDescr
	$objGroup.SetInfo
	Return SetError($IADsError, 0, $IADsError + 1)
EndFunc ;==> _GroupSetInfo
