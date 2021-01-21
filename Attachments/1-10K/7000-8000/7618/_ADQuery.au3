
Func _GetUserDN ( $sUserName = @UserName )
	Local $Ret = ''
	Local $objConnection = ObjCreate("ADODB.Connection")
	$objConnection.Provider = "ADsDSOObject"
	Local $objOpen = $objConnection.Open 
	Local $objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.CommandText = "<LDAP://DC=us,DC=deloitte,DC=com>;(&(objectCategory=User)(samAccountName=" & $sUserName & "));SAmAccountName,DisplayName,employeeID,distinguishedName;subtree"
	Local $objRecordSet = $objCommand.Execute
	If $objRecordSet.RecordCount > 0 Then
		$Ret = $objRecordSet.Fields("distinguishedName").Value
	EndIf
	$objConnection = ''
	$objCommand = ''
	Return $Ret
EndFunc

Func _GetUserDisplayName ( $sUserName = @UserName )
	Local $Ret = ''
	Local $objConnection = ObjCreate("ADODB.Connection")
	$objConnection.Provider = "ADsDSOObject"
	Local $objOpen = $objConnection.Open 
	Local $objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.CommandText = "<LDAP://DC=us,DC=deloitte,DC=com>;(&(objectCategory=User)(samAccountName=" & $sUserName & "));SAmAccountName,DisplayName,employeeID,distinguishedName;subtree"
	Local $objRecordSet = $objCommand.Execute
	If $objRecordSet.RecordCount > 0 Then
		$Ret = $objRecordSet.Fields("DisplayName").Value
	EndIf
	$objConnection = ''
	$objCommand = ''
	Return $Ret
EndFunc

Func _GetUserID ( $sUserName = @UserName )
	Local $Ret = ''
	Local $objConnection = ObjCreate("ADODB.Connection")
	$objConnection.Provider = "ADsDSOObject"
	Local $objOpen = $objConnection.Open 
	Local $objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.CommandText = "<LDAP://DC=us,DC=deloitte,DC=com>;(&(objectCategory=User)(samAccountName=" & $sUserName & "));SAmAccountName,DisplayName,employeeID,distinguishedName;subtree"
	Local $objRecordSet = $objCommand.Execute
	If $objRecordSet.RecordCount > 0 Then
		$Ret = $objRecordSet.Fields("employeeID").Value
	EndIf
	$objConnection = ''
	$objCommand = ''
	Return $Ret
EndFunc

Func _GetGroupMembership ( $sUserName = @UserName )
	Dim $aGroups[1]
	$aGroups[0] = 0
	Local $Group, $GrpName
	Local $oLdapDN = _GetUserDN($sUserName)
	If $oLdapDN = '' Then
		SetError ( 1 )
		Return $aGroups
	EndIf
	Local $objUser = ObjGet ( 'LDAP://' & $oLdapDN )
	If NOT IsObj ( $objUser ) OR @error Then
		SetError ( 2 )
		Return ''
	EndIf
	Local $arrMemberOf = $objUser.GetEx("memberOf")
	For $Group in $arrMemberOf
		ReDim $aGroups[$aGroups[0]+2]
		$aGroups[0] = $aGroups[0] + 1
		$GrpName = StringTrimLeft($Group,3)
		$GrpName = StringTrimRight($GrpName,stringlen($GrpName)-StringInStr($GrpName,',')+1)
		$GrpName = StringReplace($GrpName,'\','',-1)
		$aGroups[$aGroups[0]] = $GrpName
	Next
	$objUser = ''
	Return $aGroups
EndFunc

Func _InGroup ( $sGroupName, $sUserName = @UserName )
	; String comparison is NOT case sensative
	Local $aGroups = _GetGroupMembership ( $sUserName )
	If @error OR $aGroups[0] = 0 Then
		SetError ( @error )
		Return 0
	EndIf
	For $i = 1 To $aGroups[0]
		If $sGroupName = $aGroups[$i] Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc
