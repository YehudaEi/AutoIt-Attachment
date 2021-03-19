; #FUNCTION# ====================================================================================================================
; Name...........: _AD_IsMemberOf
; Description ...: Returns 1 if the object (user, group, computer) is an immediate member of the group.
; Syntax.........: _AD_IsMemberOf($sGroup[, $sObject = @Username[, $bIncludePrimaryGroup = False[, $bRecursive = False[, $iDepth = 10]]]])
; Parameters ....: $sGroup - Group to be checked for membership. Can be specified as sAMAccountName or Fully Qualified Domain Name (FQDN)
;                  $sObject - Optional: Object type (user, group, computer) to check for membership of $sGroup. Can be specified as sAMAccountName or Fully Qualified Domain Name (FQDN) (default = @UserName)
;                  $bIncludePrimaryGroup - Optional: Additionally checks the primary group for object membership (default = False)
;                  $bRecursive - Optional: Recursively check all groups of $sGroup up to the depth defined by $iDepth (default = False)
;                  $iDepth - Optional: Maximum depth of recursion (default = 10)
; Return values .: Success - 1, Specified object (user, group, computer) is a member of the specified group
;                  Failure - 0, @error set
;                  |0 - $sObject is not a member of $sGroup
;                  |1 - $sGroup does not exist
;                  |2 - $sObject does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Determines if the object is an immediate member of the group. This function does not verify membership in any nested groups.
; Related .......: _AD_GetUserGroups, _AD_GetUserPrimaryGroup, _AD_RecursiveGetMemberOf
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_IsMemberOf($sGroup, $sObject = @UserName, $bIncludePrimaryGroup = False, $bRecursive = False, $iDepth = 10)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, 0)
	If _AD_ObjectExists($sObject) = 0 Then Return SetError(2, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup)
	Local $iResult = $oGroup.IsMember("LDAP://" & $sAD_HostServer & "/" & $sObject)
	If $iResult = 0 And $bRecursive = True Then
		For $oMember In $oGroup.Members
			If StringLower($oMember.Class) = 'group' Then
				If $iDepth > 0 Then
					If _AD_IsMemberOf($oMember.distinguishedName, $sObject, $bRecursive, $iDepth - 1) Then Return 1
				EndIf
			Else
				If StringLower($oMember.distinguishedName) = $sObject Then Return 1
			EndIf
		Next
	EndIf
	; Check Primary Group if $sObject isn't a member of the specified group and the flag is set
	If $iResult = 0 And $bIncludePrimaryGroup Then $iResult = (_AD_GetUserPrimaryGroup($sObject) = $sGroup)
	; Abs is necessary to make it work for AutoIt versions < 3.3.2.0 with bug #1068
	Return Abs($iResult)

EndFunc   ;==>_AD_IsMemberOf