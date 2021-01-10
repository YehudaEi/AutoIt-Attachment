#include-once
; Active Directory Function Library. Include this to allow access to Active Directory Functions

; Author : Jonthan Clelland
; Email : jclelland@statestreet.com
; Version : 3.1.1

;Version History -- Starting from v3.1

; 3.1 -- First released version
; 3.1.1 -- Bugfix to _ADGetObjectsInOU, default $filter value caused errors. Has been changed.
; 3.1.2 -- Corrections made to comments, replaced occurrences of 'Samaccountname' with 'Full Distringuished Name' where this had changed ibn the code.
; 3.1.2 -- Change to '_ADUserCreateMailbox', added '$emaildomain' and removed the hard-coded Email Domain name.
; 3.1.3 -- Change to '_ADCreateUser', added .Put("userPrincipalName", $user & "@" & $domainext), where $domainext is the Domain in the form 'domain.mydomain.com'

; _ADDoError  : Error event handler for COM errors. This is global so will pick up errors from your program if you include this library
; _ADCreateUser : Creates a user in a particular OU
; _ADCreateGroup : Creates a group in a particular OU
; _ADAddUserToGroup : Adds a user to a group (if the user is not already a member of the group)
; _ADRemoveUserFromGroup : Removes a user from a group
; _ADObjectExists : Returns 1 if the given object (SamAccountName) exists in the local AD Tree
; _ADModifyAttribute : Sets the attribute of the given object to the value specified
; _ADIsMemberOf : Returns 1 if the user is a member of the group
; _ADGetUserGroups : Returns an array (byreference) containing the groups that the user is a member of
; _ADRecursiveGetMemberOf : Returns a recursed list of group membership for a group or user
; _ADGetGroupMembers : Returns an array of the group members
; _ADGetGroupMemberOf : Returns a simple list of group membership for a group
; _ADHasFullRights : Returns 1 if the given user has full rights over the given group/user
; _ADHasUnlockResetRights; Returns 1 if the given user has Unlock and Reset rights over the given user
; _ADHasGroupUpdateRights; Returns 1 if the given user has membership update rights for the given group
; _ADGroupMailEnable : Mail enables a group
; _ADUserCreateMailbox : Creates a mailbox for a user
; _ADUserDeleteMailbox : Deletes the mailbox for a user
; _ADGetObjectsInOU : Returns a filtered list of objects and attributes in a given OU
; _ADDNToSamAccountName : Returns the SamAccountName of an FQDN
; _ADSamAccountNameToFQDN : Returns a FQDN from a SamAccountName
; _ADDNToDisplayName :Returns the Display Name of an FQDN
; _ADCreateObject : Creates an object of a specified type
; _ADCreateComputer : Creates a computer and assigns permissions for a user/group to add the computer
; _ADDeleteObject : Deletes an object
; _ADGetObjectClass : Returns the class of an object
; _ADGetObjectClassFromFQDN : Returns the class of an object from it's FQDN
; _ADGetObjectAttribute : Returns a (single-value) attribute of an object
; _ADListDomainControllers : Returns a list of Domain Controllers for the current domain
; _ADOUObjectNames : Returns display names of filtered objects within an OU
; _ADGroupManagerCanModify : Returns 1 if the manager of the group can modify the member list, 0 if not, -1 if there is no manager assigned
; _ADAddAccountToMailboxRights : Adds useraccount to mailbox with full rights and send as permissions.
; _ADRemoveMailboxRights : Remove mailbox rights for an account.
; _ADGetMailboxPerms : Takes a mailbox and an array, returns a list of SAMIDs with un-inherited permissions on the mailbox
; _ADRenameObject : Renames an object within an OU.
; _ADAlternativeLogon : Use this to switch the logon credentials to the domain.

; NOTES : Please use the following command to store the local user's groups for the function 'HasFullRights'. This is to allow cross-domain
; permission checks. $loggedonusergroups is a global variable declared in the 'Define AD Constants' region. If you are using this command
; in this library, move the command below the declaration of the variable and remove the comment charcater.

; _ADRecursiveGetMemberOf ($loggedonusergroups, _ADSamAccountNameToFQDN (@UserName))

; include array functions (we use _arraysearch in some functions)
#include <Array.au3>

#Region  ; Define AD Constants

Global Const $ADS_GROUP_TYPE_GLOBAL_GROUP = 0x2
Global Const $ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP = 0x4
Global Const $ADS_GROUP_TYPE_UNIVERSAL_GROUP = 0x8
Global Const $ADS_GROUP_TYPE_SECURITY_ENABLED = 0x80000000
Global Const $ADS_GROUP_TYPE_GLOBAL_SECURITY = BitOR($ADS_GROUP_TYPE_GLOBAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
Global Const $ADS_GROUP_TYPE_UNIVERSAL_SECURITY = BitOR($ADS_GROUP_TYPE_UNIVERSAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
Global Const $ADS_GROUP_TYPE_DOMAIN_LOCAL_SECURITY = BitOR($ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)

Global Const $ADS_UF_PASSWD_NOTREQD = 0x0020
Global Const $ADS_UF_WORKSTATION_TRUST_ACCOUNT = 0x1000
Global Const $ADS_ACETYPE_ACCESS_ALLOWED = 0x0
Global Const $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT = 0x5
Global Const $ADS_FLAG_OBJECT_TYPE_PRESENT = 0x1
Global Const $ADS_RIGHT_GENERIC_READ = 0x80000000
Global Const $ADS_RIGHT_DS_SELF = 0x8
Global Const $ADS_RIGHT_DS_WRITE_PROP = 0x20
Global Const $ADS_RIGHT_DS_CONTROL_ACCESS = 0x100
Global Const $ADS_UF_ACCOUNTDISABLE = 2
Global Const $ADS_OPTION_SECURITY_MASK = 3
Global Const $ADS_SECURITY_INFO_DACL = 4
Global Const $ADS_OBJECT_READWRITE_ALL = 48
Global Const $ADS_USER_UNLOCKRESETACCOUNT = 256
Global Const $ADS_OBJECT_FULLRIGHTS = 983551

Global Const $ALLOWED_TO_AUTHENTICATE = "{68B1D179-0D15-4d4f-AB71-46152E79A7BC}"
Global Const $RECEIVE_AS = "{AB721A56-1E2f-11D0-9819-00AA0040529B}"
Global Const $SEND_AS = "{AB721A54-1E2f-11D0-9819-00AA0040529B}"
Global Const $USER_CHANGE_PASSWORD = "{AB721A53-1E2f-11D0-9819-00AA0040529b}"
Global Const $USER_FORCE_CHANGE_PASSWORD = "{00299570-246D-11D0-A768-00AA006E0529}"
Global Const $USER_ACCOUNT_RESTRICTIONS = "{4C164200-20C0-11D0-A768-00AA006E0529}"
Global Const $VALIDATED_DNS_HOST_NAME = "{72E39547-7B18-11D1-ADEF-00C04FD8D5CD}"
Global Const $VALIDATED_SPN = "{F3A64788-5306-11D1-A9C5-0000F80367C1}"
Global Const $Member_SchemaIDGuid = "{BF9679C0-0DE6-11D0-A285-00AA003049E2}"

Global $objConnection = ObjCreate("ADODB.Connection") ; Create COM object to AD
$objConnection.ConnectionString = "Provider=ADsDSOObject"
$objConnection.Open("Active Directory Provider") ; Open connection to AD

Global $objRootDSE = ObjGet("LDAP://RootDSE")
Global $strDNSDomain = $objRootDSE.Get("defaultNamingContext") ; Retrieve the current AD domain name
Global $strHostServer = $objRootDSE.Get("dnsHostName") ; Retrieve the name of the connected DC
Global $strConfiguration = $objRootDSE.Get("ConfigurationNamingContext") ; Retrieve the Configuration naming context

Global $alt_userid = ""
Global $alt_password = ""
Global $objOpenDS = ObjGet("LDAP:")

Global $loggedonusergroups ; populate this with the logged on user groups in your own app

#EndRegion  

$oMyError = ObjEvent("AutoIt.Error", "_ADDoError") ; Install a custom error handler

;  MyErrFunc
Func _ADDoError()
	$HexNumber = Hex($oMyError.number, 8)
	
	If $HexNumber = 80020009 Then
		SetError(3)
		Return
	EndIf
	
	If $HexNumber = "8007203A" Then
		SetError(4)
		Return
	EndIf
	
	If $HexNumber = 80005000 Then
		SetError(5)
		Return
	EndIf
	
	MsgBox(262144, "", "We intercepted a COM Error !" & @CRLF & _
			"Number is: " & $HexNumber & @CRLF & _
			"Windescription is: " & $oMyError.windescription & @CRLF & _
			"Script Line number is: " & $oMyError.scriptline)
	
	Select
		Case $oMyError.windescription = "Access is denied."
			$objConnection.Close
			$objConnection.Open("Active Directory Provider")
			SetError(2)
		Case 1
			SetError(1)
	EndSelect
	
EndFunc   ;==>_ADDoError

; _ADCreateUser
; $userou = OU to create the group in. Form is "sampleou=ou, sampleparent=ou, sampledomain1=dc, sampledomain2=dc, sampledomain3=dc"
; $user = Username, form is SamAccountName without leading 'CN='
; $fname = First Name
; $lname = Last Name
; $description = optional - Description

Func _ADCreateUser($userou, $user, $fname, $lname, $description = "User")
	If _ADObjectExists($user) Then Return 0

	$ObjOU = _ADObjGet("LDAP://" & $strHostServer & "/" & $userou)
	If $fname = "" Then
		$cnname = "CN=" & $lname
	Else
		$cnname = "CN=" & $lname & "\, " & $fname
	EndIf
	$ObjUser = $ObjOU.Create("User", $cnname)
	
	$ObjUser.Put("sAMAccountName", $user)
	$ObjUser.Put("description", $description)
	
	$domainext = StringTrimLeft(StringReplace($strDNSDomain, ",DC=", "."), 3)
	$ObjUser.Put("userPrincipalName", $user & "@" & $domainext)

	$ObjUser.SetInfo
	
	Return 1
EndFunc   ;==>_ADCreateUser

; _ADCreateGroup
; $gruopou = OU to create the group in. Form is "sampleou=ou, sampleparent=ou, sampledomain1=dc, sampledomain2=dc, sampledomain3=dc"
; $group = groupname, form is SamAccountName without leading 'CN='
; $type = Group type. Defaults to Global Security. See the global constands for other types. NOTE Global security must be 'BitOr'ed with a scope.

Func _ADCreateGroup($groupou, $group, $type = -2147483646)
	If _ADObjectExists($group) Then Return 0
	If StringLeft($group, 3) <> "CN=" Then
		$groupcn = "CN=" & $group
	Else
		$groupcn = $group
	EndIf
	$groupcn = _ADFixSpecialChars($groupcn)
	
	$ObjOU = _ADObjGet("LDAP://" & $strHostServer & "/" & $groupou)
	$ObjGroup = $ObjOU.Create("Group", $groupcn)
	
	$groupsam = StringReplace($group, ",", "")
	$groupsam = StringReplace($groupsam, "#", "")
	$groupsam = StringReplace($groupsam, "/", "")
	$ObjGroup.Put("sAMAccountName", $groupsam)
	$ObjGroup.Put("grouptype", $type)
	
	$ObjGroup.SetInfo
	
	Return 1
EndFunc   ;==>_ADCreateGroup

; _ADAddUserToGroup
; Takes the group (Full Distringuished Name) and the user (Full Distringuished Name)
; Adds the user to the group
; Returns 0 if the user is already a member of the group,
; Returns 1 if the user was added to the group
; Returns -1 if there was an error

Func _ADAddUserToGroup($group, $user)
	If _ADIsMemberOf($group, $user) Then Return 0
	$oUsr = _ADObjGet("LDAP://" & $strHostServer & "/" & $user) ; Retrieve the COM Object for the user
	$oGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $group) ; Retrieve the COM Object for the group
	
	$oGroup.Add($oUsr.AdsPath)
	$oGroup.SetInfo
	$oGroup = 0
	$oUser = 0
	Return _ADIsMemberOf($group, $user)
EndFunc   ;==>_ADAddUserToGroup

; _ADRemoveUserFromGroup
; Takes the group (Full Distringuished Name) and the user (Full Distringuished Name)
; Removes the user from the group (if the user is a member of the group)
; Returns 0 if the user isn't a member of the group, 1 if the user was removed from the group
; Returns -1 if the removal failed.

Func _ADRemoveUserFromGroup($group, $user)
	If _ADIsMemberOf($group, $user) = 0 Then Return 0

	$oUsr = _ADObjGet("LDAP://" & $strHostServer & "/" & $user) ; Retrieve the COM Object for the user

	$oGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $group) ; Retrieve the COM Object for the group
	
	$oGroup.Remove($oUsr.AdsPath)
	$oGroup.SetInfo
	
	$oGroup = 0
	$oUser = 0
	
	If _ADIsMemberOf($group, $user) Then
		Return -1
	Else
		Return 1
	EndIf
	
EndFunc   ;==>_ADRemoveUserFromGroup

; _ADObjectExists
; Takes an object name (SamAccountName without leading 'CN=')
; Returns 1 if the object exists in the tree, 0 otherwise

Func _ADObjectExists($object)
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $object & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the group, if it exists
	
	If $objRecordSet.RecordCount = 1 Then
		$objRecordSet = 0
		Return 1
	Else
		$objRecordSet = 0
		Return 0
	EndIf
EndFunc   ;==>_ADObjectExists

; _ADModifyAttribute
; $object = Object to modify (samAccountName)
; $attribute = Attribute to modify
; $value = value to set attribute to, use a blank string "" to delete an attribute

Func _ADModifyAttribute($object, $attribute, $value = "")
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $object & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the object
	
	$ldap_entry = $objRecordSet.fields(0).value
	$oObject = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	
	$oObject.GetInfo
	
	If $value = "" Then
		$oObject.PutEx(1, $attribute, 0)
	Else
		$oObject.Put($attribute, $value)
	EndIf

	$oObject.SetInfo
	$oObject.PurgePropertyList
	
	$oObject = 0
	
	Return 1
EndFunc   ;==>_ADModifyAttribute

; _ADIsMemberOf
; Takes Full Distringuished Names for a group and a user
; Returns 1 if the the user is a member of the group, 0 otherwise, -1 if access is denied/group not found

Func _ADIsMemberOf($group, $user)
	$ObjGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $group)
	If Not IsObj($ObjGroup) Then Return -1
	$ismember = $ObjGroup.IsMember("LDAP://" & $strHostServer & "/" & $user)
	$ObjGroup = 0
	Return -$ismember
EndFunc   ;==>_ADIsMemberOf

; _ADGetUserGroups
; the currently logged on user is a member of. Returns an array of Full DNs of the Group names that the user is immediately a member of
; with element 0 containing the number of groups.
; $user - optional -- SamAccountName of a user, defaults to locally logged on user

Func _ADGetUserGroups(ByRef $usergroups, $user = @UserName)
	Local $oUsr
	
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $user & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the logged on user
	$ldap_entry = $objRecordSet.fields(0).value
	$oUsr = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the logged on user
	
	$usergroups = $oUsr.GetEx("memberof")
	
	$oUsr = 0
	
	$count = UBound($usergroups)
	_ArrayInsert($usergroups, 0, $count)
EndFunc   ;==>_ADGetUserGroups

; _ADRecursiveGetMemberOf
; Takes a Full DN of a group or user and returns a recursively searched list of groups the object is a member of to the array
; This will traverse through groups that the object is immediately a member of and check their group membership as well.
; The return values are full DNs. For groups that are inherited, the return is the DN of the group, and the DN of the first group
; it was inherited from, seperated by '|'.
Func _ADRecursiveGetMemberOf(ByRef $memberof, $fqdn)
	Local $objItem, $tempmemberof, $i = 0
	
	$objItem = _ADObjGet("LDAP://" & $strHostServer & "/" & $fqdn) ; Retrieve the COM Object for the logged on user
	
	$memberof = $objItem.GetEx("memberof")
	
	$objItem = 0
	
	If $memberof = 0 Then
		Dim $memberof[1] = [0]
		Return 0
	EndIf
	
	Do
		If StringInStr($memberof[$i], "|") Then
			$currgroup = StringLeft($memberof[$i], StringInStr($memberof[$i], "|") - 1)
		Else
			$currgroup = $memberof[$i]
		EndIf
		$currgroup = StringReplace($currgroup, "/", "\/")
		_ADGetGroupMemberOf($tempmemberof, $currgroup)
		For $j = 1 To $tempmemberof[0]
			$exists = 0
			$k = UBound($memberof)
			Do
				$k -= 1
				If StringInStr($memberof[$k], $tempmemberof[$j]) Then $exists = 1
			Until $exists = 1 Or $k = 0
			If $exists = 0 Then _ArrayAdd($memberof, $tempmemberof[$j] & "|" & $currgroup)
		Next
		$i += 1
	Until $i = UBound($memberof)
	
	$count = UBound($memberof)
	_ArrayInsert($memberof, 0, $count)
	
	Return 1
EndFunc   ;==>_ADRecursiveGetMemberOf

; _ADRecursiveGetGroupMembers
; Takes a Full DN of a group and returns a recursively searched list of members of that group (and groups that are members of the group)
; The return values are full DNs. For groups that are inherited, the return is the DN of the group, and the DN of the first group
; it was inherited from, seperated by '|'.
Func _ADRecursiveGetGroupMembers(ByRef $members, $fqdn)
	Local $objItem, $tempmembers, $i = 1
	
	_ADGetGroupMembers($members, $fqdn)
	
	If $members[0] = 0 Then
		Return 0
	EndIf
	
	Do
		If StringInStr($members[$i], "|") Then
			$currgroup = StringLeft($members[$i], StringInStr($members[$i], "|") - 1)
		Else
			$currgroup = $members[$i]
		EndIf
		$currgroup = StringReplace($currgroup, "/", "\/")
		If _ADGetObjectClassFromFQDN($currgroup) = "group" Then
			_ADGetGroupMembers($tempmembers, $currgroup)
			For $j = 1 To $tempmembers[0]
				$exists = 0
				$k = UBound($members)
				Do
					$k -= 1
					If StringInStr($members[$k], $tempmembers[$j]) Then $exists = 1
				Until $exists = 1 Or $k = 0
				If $exists = 0 Then _ArrayAdd($members, $tempmembers[$j] & "|" & $currgroup)
			Next
		EndIf
		$i += 1
	Until $i = UBound($members)
	
	$count = UBound($members)
	
	$members[0] = $count - 1
	
	Return 1
EndFunc   ;==>_ADRecursiveGetGroupMembers

; _ADGetGroupMembers
; Arguments,
; $members - Array that the result will be stored in
; $groupdn - Group (Full Distringuished Name) to retrieve members from
; $sort - optional, default 0 : Set to 1 to sort the array
; Returns an array to $members where $members[0] will be the number of users in the group and
; $members[1] to $members[$members[0]] are the distinguished names of the users

Func _ADGetGroupMembers(ByRef $members, $groupdn, $sort = 0)
	;If _ADObjectExists($group) = 0 Then Return 0
	
	Local $oUsr, $objCommand, $groups, $i

	$objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.Properties("Searchscope") = 2

	Dim $members[1]
	$i = 0

	While 1
		$rangemodifier = $i * 1000
		$range = "Range=" & $rangemodifier & "-" & $rangemodifier + 999
		$strCmdText = "<LDAP://" & $strHostServer & "/" & $groupdn & ">;;member;" & $range & ";base"
		$objCommand.CommandText = $strCmdText
		$objRecordSet = $objCommand.Execute
		$membersadd = $objRecordSet.fields(0).Value
		If $membersadd = 0 Then ExitLoop
		ReDim $members[UBound($members) + 1000]
		For $j = $rangemodifier + 1 To $rangemodifier + 1000
			$members[$j] = $membersadd[$j - $rangemodifier - 1]
		Next
		$i += 1
		$objRecordSet.Close
		$objRecordSet = 0
	WEnd

	$rangemodifier = $i * 1000
	$range = "Range=" & $rangemodifier & "-*"
	$strCmdText = "<LDAP://" & $strHostServer & "/" & $groupdn & ">;;member;" & $range & ";base"
	$objCommand.CommandText = $strCmdText
	$objRecordSet = $objCommand.Execute
	$membersadd = $objRecordSet.fields(0).Value

	ReDim $members[UBound($members) + UBound($membersadd)]

	For $j = $rangemodifier + 1 To $rangemodifier + UBound($membersadd)
		$members[$j] = $membersadd[$j - $rangemodifier - 1]
	Next

	$objRecordSet.Close
	
	$objCommand = 0
	$objRecordSet = 0
	
	$members[0] = UBound($members) - 1
	
	If $sort = 1 Then
		_ArraySort($members, 0, 1)
	EndIf
	
	Return 1
EndFunc   ;==>_ADGetGroupMembers

; _ADGetGroupMemberOf
Func _ADGetGroupMemberOf(ByRef $memberof, $groupdn, $sort = 0)
	Local $oUsr, $objCommand, $groups

	$objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.Properties("Searchscope") = 2
	
	Dim $memberof[1]
	$i = 0

	While 1
		$rangemodifier = $i * 1000
		$range = "Range=" & $rangemodifier & "-" & $rangemodifier + 999
		$strCmdText = "<LDAP://" & $strHostServer & "/" & $groupdn & ">;;memberof;" & $range & ";base"
		$objCommand.CommandText = $strCmdText
		$objRecordSet = $objCommand.Execute
		$membersadd = $objRecordSet.fields(0).Value
		If $membersadd = 0 Then ExitLoop
		ReDim $memberof[UBound($memberof) + 1000]
		For $j = $rangemodifier + 1 To $rangemodifier + 1000
			$memberof[$j] = $membersadd[$j - $rangemodifier - 1]
		Next
		$i += 1
		$objRecordSet.Close
	WEnd

	$rangemodifier = $i * 1000
	$range = "Range=" & $rangemodifier & "-*"
	$strCmdText = "<LDAP://" & $strHostServer & "/" & $groupdn & ">;;memberof;" & $range & ";base"
	$objCommand.CommandText = $strCmdText
	$objRecordSet = $objCommand.Execute
	$membersadd = $objRecordSet.fields(0).Value
	ReDim $memberof[UBound($memberof) + UBound($membersadd)]

	For $j = $rangemodifier + 1 To $rangemodifier + UBound($membersadd)
		$memberof[$j] = $membersadd[$j - $rangemodifier - 1]
	Next
	$objRecordSet.Close
	
	$objCommand = 0
	$objRecordSet = 0
	
	$memberof[0] = UBound($memberof) - 1
	
	If $sort = 1 Then
		_ArraySort($memberof, 0, 1)
	EndIf
	
	Return $memberof[0]
	
EndFunc   ;==>_ADGetGroupMemberOf

; _ADHasFullRights
; Take an object's Full Distringuished Name and a user's SamAccountName
; Returns 1 if User has full rights on the object
; Returns 0 otherwise

Func _ADHasFullRights($object, $user = @UserName)
	Dim $hfr_groups
	If $user = @UserName Then
		$hfr_groups = $loggedonusergroups
	Else
		_ADGetUserGroups($hfr_groups, $user)
	EndIf

	
	$oObject = _ADObjGet("LDAP://" & $strHostServer & "/" & $object)
	
	If IsObj($oObject) Then
		$security = $oObject.Get("ntSecurityDescriptor")
		$dacl = $security.DiscretionaryAcl
		For $ace In $dacl
			$trusteearray = StringSplit($ace.Trustee, "\")
			$trusteegroup = $trusteearray[$trusteearray[0]]
			For $i = 0 To UBound($hfr_groups) - 1
				If StringInStr($hfr_groups[$i], "CN=" & $trusteegroup) And $ace.AccessMask = 983551 Then Return 1
			Next
		Next
	EndIf
	
	$oObject = 0
	$security = 0
	$dacl = 0
	
	Return 0
EndFunc   ;==>_ADHasFullRights

; _ADHasUnlockResetRights
; Take an object's Full Distringuished Name and a user's SamAccountName
; Returns 1 if User has unlock and Password reset rights on the object
; Returns 0 otherwise

Func _ADHasUnlockResetRights($object, $user = @UserName)
	Dim $hfr_groups
	If $user = @UserName Then
		$hfr_groups = $loggedonusergroups
	Else
		_ADGetUserGroups($hfr_groups, $user)
	EndIf

	
	$oObject = _ADObjGet("LDAP://" & $strHostServer & "/" & $object)
	
	If IsObj($oObject) Then
		$security = $oObject.Get("ntSecurityDescriptor")
		$dacl = $security.DiscretionaryAcl
		For $ace In $dacl
			$trusteearray = StringSplit($ace.Trustee, "\")
			$trusteegroup = $trusteearray[$trusteearray[0]]
			For $i = 0 To UBound($hfr_groups) - 1
				If StringInStr($hfr_groups[$i], "CN=" & $trusteegroup) And _
						BitAND($ace.AccessMask, $ADS_USER_UNLOCKRESETACCOUNT) = $ADS_USER_UNLOCKRESETACCOUNT Then Return 1
			Next
		Next
	EndIf
	
	$oObject = 0
	$security = 0
	$dacl = 0
	
	Return 0
EndFunc   ;==>_ADHasUnlockResetRights

; _ADHasRequiredRights
; Take an object's Full Distringuished Name, a required AccessMask constant and a user's SamAccountName
; Returns 1 if User has required rights on the object
; Returns 0 otherwise

Func _ADHasRequiredRights($object, $requiredRight = 983551, $user = @UserName)
	Dim $hfr_groups
	If $user = @UserName Or $user = $alt_userid Then
		$hfr_groups = $loggedonusergroups
	Else
		_ADGetUserGroups($hfr_groups, $user)
	EndIf

	$oObject = _ADObjGet("LDAP://" & $strHostServer & "/" & $object)
	
	If IsObj($oObject) Then
		$security = $oObject.Get("ntSecurityDescriptor")
		$dacl = $security.DiscretionaryAcl
		For $ace In $dacl
			$trusteearray = StringSplit($ace.Trustee, "\")
			$trusteegroup = $trusteearray[$trusteearray[0]]
			For $i = 0 To UBound($hfr_groups) - 1
				If StringInStr($hfr_groups[$i], "CN=" & $trusteegroup) And _
						BitAND($ace.AccessMask, $requiredRight) = $requiredRight Then
					$oObject = 0
					$security = 0
					$dacl = 0
					Return 1
				EndIf
			Next
		Next
	EndIf
	
	$oObject = 0
	$security = 0
	$dacl = 0
	
	Return 0
EndFunc   ;==>_ADHasRequiredRights

; _ADHasGroupUpdateRights
; Take an object's Full Distringuished Name and a user's SamAccountName
; Returns 1 if User has rights to update the group membership on the object
; Returns 0 otherwise
Func _ADHasGroupUpdateRights($object, $user = @UserName)
	Dim $hfr_groups
	If $user = @UserName Then
		$hfr_groups = $loggedonusergroups
	Else
		_ADGetUserGroups($hfr_groups, $user)
	EndIf
	
	$oObject = _ADObjGet("LDAP://" & $strHostServer & "/" & $object)
	If IsObj($oObject) Then
		$security = $oObject.Get("ntSecurityDescriptor")
		$dacl = $security.DiscretionaryAcl
		For $ace In $dacl
			$trusteearray = StringSplit($ace.Trustee, "\")
			$trusteegroup = $trusteearray[$trusteearray[0]]
			For $i = 0 To UBound($hfr_groups) - 1
				If StringInStr($hfr_groups[$i], "CN=" & $trusteegroup) And _
						BitAND($ace.AccessMask, $ADS_OBJECT_READWRITE_ALL) = $ADS_OBJECT_READWRITE_ALL Then Return 1
			Next
		Next
	EndIf
	
	$oObject = 0
	$security = 0
	$dacl = 0
	
	Return 0
EndFunc   ;==>_ADHasGroupUpdateRights

; _ADGroupMailEnable
; Takes a group (samaccountname) and enables mail on that group
Func _ADGroupMailEnable($group)
	If _ADObjectExists($group) = 0 Then Return 0
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $group & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the group, if it exists
	
	$ldap_entry = $objRecordSet.fields(0).value
	$oGroup = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	
	$oGroup.Put("grouptype", $ADS_GROUP_TYPE_UNIVERSAL_SECURITY)
	$oGroup.MailEnable
	$oGroup.SetInfo
	
	$oGroup = 0
	
	Return 1
EndFunc   ;==>_ADGroupMailEnable

; _ADUserCreateMailbox
; $user - User to add mailbox to
; $mdbstore - Mailbox storename
; $store - Information store
; $server - Email server
; $admingroup - Administrative group in Exchange
; $domain - Domain name
; $emaildomain - Exchange Server Group name e.g. "My Company"
Func _ADUserCreateMailbox($user, $mdbstore, $store, $server, $admingroup, $domain, $emaildomain)
	If _ADObjectExists($user) = 0 Then Return 0
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $user & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the group, if it exists
	
	$ldap_entry = $objRecordSet.fields(0).value
	$oUser = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	
	If $oUser.HomeMDB <> "" Then Return 0
	
	$mailboxpath = "LDAP://CN="
	$mailboxpath = $mailboxpath & $mdbstore
	$mailboxpath = $mailboxpath & ",CN="
	$mailboxpath = $mailboxpath & $store
	$mailboxpath = $mailboxpath & ",CN=InformationStore"
	$mailboxpath = $mailboxpath & ",CN="
	$mailboxpath = $mailboxpath & $server
	$mailboxpath = $mailboxpath & ",CN=Servers,CN="
	$mailboxpath = $mailboxpath & $admingroup
	$mailboxpath = $mailboxpath & ",CN=Administrative Groups,CN=" & $emaildomain & ",CN=Microsoft Exchange,CN=Services,CN=Configuration,"
	$mailboxpath = $mailboxpath & $domain
	
	$oUser.CreateMailbox($mailboxpath)
	$oUser.SetInfo
	
	$oUser = 0
	
	Return 1
EndFunc   ;==>_ADUserCreateMailbox

; _ADUserDeleteMailbox
; Deletes a user's mailbox
Func _ADUserDeleteMailbox($user)
	If _ADObjectExists($user) = 0 Then Return 0

	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $user & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the group, if it exists
	
	$ldap_entry = $objRecordSet.fields(0).value
	$oUser = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	
	If $oUser.HomeMDB = "" Then Return 0
	
	$oUser.DeleteMailbox
	$oUser.SetInfo
	
	$oUser = 0
	
	Return 1
EndFunc   ;==>_ADUserDeleteMailbox

; _ADGetObjectsInOU
; Returns an array of the objects in an OU
; $ou : The OU to retrieve from
; $filter : optional, default "name'*'". An additional LDAP filter if required.
; $searchscope : optional, default 2. 0 = base, 1 = one-level, 2 = sub-tree
; $datatoretrieve : optional, default "Name". A comma-seperated list of values to retrieve. More than one value will create
; a 2-dimensional array, array[0][0] will contain the number of items returned, which start at array[1][0]

Func _ADGetObjectsInOU(ByRef $ObjectArray, $ou, $filter = "(name=*)", $searchscope = 2, $datatoretrieve = "sAMAccountName", $sortby = "sAMAccountName")
	Local $objRecordSet
	$objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.Properties("Page Size") = 256
	$objCommand.Properties("Searchscope") = $searchscope
	$objCommand.Properties("TimeOut") = 20
	
	$strCmdText = "<LDAP://" & $strHostServer & "/" & $ou & ">;" & $filter & ";" & $datatoretrieve & ";subtree"
	
	$objCommand.CommandText = $strCmdText
	$objRecordSet = $objCommand.Execute

	$recordcount = $objRecordSet.RecordCount
	If $recordcount = 0 Then
		$objCommand = 0
		$objRecordSet = 0
		Return 0
	EndIf
	
	If StringInStr($datatoretrieve, ",") Then

		$dtrArray = StringSplit($datatoretrieve, ",")
		
		Dim $ObjectArray[$recordcount + 1][$dtrArray[0]]
		
		$ObjectArray[0][0] = $recordcount
		$ObjectArray[0][1] = $dtrArray[0]
		
		$count = 1
		$objRecordSet.MoveFirst
		Do
			For $i = 1 To $dtrArray[0]
				$ObjectArray[$count][$i - 1] = $objRecordSet.Fields($dtrArray[$i] ).Value
			Next
			$objRecordSet.MoveNext
			$count += 1
		Until $objRecordSet.EOF
	Else
		Dim $ObjectArray[$recordcount + 1]
		$ObjectArray[0] = UBound($ObjectArray) - 1
		If $ObjectArray[0] = 0 Then
			$ObjectArray = 0
			Return 0
		Else
			$count = 1
			$objRecordSet.MoveFirst
			Do
				$ObjectArray[$count] = $objRecordSet.Fields($datatoretrieve).Value
				$objRecordSet.MoveNext
				$count += 1
			Until $objRecordSet.EOF
		EndIf
	EndIf
	
	$objCommand = 0
	$objRecordSet = 0
	
	Return 1
	
EndFunc   ;==>_ADGetObjectsInOU

; _ADDNToSamAccountName
; Takes a FQDN and returns the SamID of the account

Func _ADDNToSamAccountName($fqdn)
	$obj = _ADObjGet("LDAP://" & $strHostServer & "/" & $fqdn)
	If $obj = 0 Then
		MsgBox(262144, "", "Failed to retrieve AD object")
		Return 0
	EndIf
	
	$samname = $obj.sAMAccountName
	
	$obj = 0
	
	Return $samname
EndFunc   ;==>_ADDNToSamAccountName

; _ADSamAccountNameToFQDN
; Takes a SamID and returns the FQDN of the account

Func _ADSamAccountNameToFQDN($samname)
	
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $samname & ");distinguishedName;subtree"
	$objRecordSet = $objConnection.Execute($strQuery)
	
	If $objRecordSet.RecordCount = 1 Then
		$fqdn = $objRecordSet.fields(0).value
		$objRecordSet = 0
		Return StringReplace($fqdn, "/", "\/")
	Else
		$objRecordSet = 0
		Return ""
	EndIf
EndFunc   ;==>_ADSamAccountNameToFQDN

; _ADDNToDisplayName
; Returns the Display Name of an FQDN
Func _ADDNToDisplayName($fqdn)
	$objItem = _ADObjGet("LDAP://" & $strHostServer & "/" & $fqdn)
	$name = $objItem.name
	$name = StringTrimLeft($name, 3)
	$name = StringReplace($name, "\,", ",")
	$objItem = 0
	Return $name
EndFunc   ;==>_ADDNToDisplayName

; _ADCreateObject
; $objectou = OU to create the group in. Form is "sampleou=ou, sampleparent=ou, sampledomain1=dc, sampledomain2=dc, sampledomain3=dc"
; $object = Object name, form is SamAccountName without leading 'CN='
; $type = Type of object to create

Func _ADCreateObject($objectou, $object, $type)
	If _ADObjectExists($object) Then Return 0
	
	If StringLeft($object, 3) <> "CN=" Then
		$object = "CN=" & $object
	EndIf

	$ObjOU = _ADObjGet("LDAP://" & $strHostServer & "/" & $objectou)
	$ObjADObj = $ObjOU.Create($type, $object)
	
	$ObjADObj.Put("sAMAccountName", StringTrimLeft($object, 3))
	If $type = "Computer" Then
		$ObjADObj.Put("UserAccountControl", BitOR(0x0020, 0x1000))
	EndIf
	
	$ObjADObj.SetInfo
	
	$ObjADObj = 0
	
	Return 1
EndFunc   ;==>_ADCreateObject

; _ADCreateComputer
; $strComputer = Name of the computer object to create
; $computerOU = Full DN of the OU to create the computer in
; $strComputerUser = User or group that will be allowed to add the computer to the domain (SamAccountName)
Func _ADCreateComputer($strComputer, $computerOU, $strComputerUser)

	$objContainer = _ADObjGet("LDAP://" & $strHostServer & "/" & $computerOU)

	$objComputer = $objContainer.Create("Computer", "cn=" & $strComputer)
	$objComputer.Put("sAMAccountName", $strComputer & "$")
	$objComputer.Put("userAccountControl", BitOR($ADS_UF_PASSWD_NOTREQD, $ADS_UF_WORKSTATION_TRUST_ACCOUNT))
	$objComputer.SetInfo

	$objSecurityDescriptor = $objComputer.Get("ntSecurityDescriptor")
	$objDACL = $objSecurityDescriptor.DiscretionaryAcl

	$objACE1 = ObjCreate("AccessControlEntry")
	$objACE1.Trustee = $strComputerUser
	$objACE1.AccessMask = $ADS_RIGHT_GENERIC_READ
	$objACE1.AceFlags = 0
	$objACE1.AceType = $ADS_ACETYPE_ACCESS_ALLOWED

	$objACE2 = ObjCreate("AccessControlEntry")
	$objACE2.Trustee = $strComputerUser
	$objACE2.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$objACE2.AceFlags = 0
	$objACE2.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE2.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE2.ObjectType = $ALLOWED_TO_AUTHENTICATE

	$objACE3 = ObjCreate("AccessControlEntry")
	$objACE3.Trustee = $strComputerUser
	$objACE3.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$objACE3.AceFlags = 0
	$objACE3.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE3.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE3.ObjectType = $RECEIVE_AS

	$objACE4 = ObjCreate("AccessControlEntry")
	$objACE4.Trustee = $strComputerUser
	$objACE4.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$objACE4.AceFlags = 0
	$objACE4.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE4.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE4.ObjectType = $SEND_AS

	$objACE5 = ObjCreate("AccessControlEntry")
	$objACE5.Trustee = $strComputerUser
	$objACE5.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$objACE5.AceFlags = 0
	$objACE5.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE5.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE5.ObjectType = $USER_CHANGE_PASSWORD

	$objACE6 = ObjCreate("AccessControlEntry")
	$objACE6.Trustee = $strComputerUser
	$objACE6.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$objACE6.AceFlags = 0
	$objACE6.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE6.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE6.ObjectType = $USER_FORCE_CHANGE_PASSWORD

	$objACE7 = ObjCreate("AccessControlEntry")
	$objACE7.Trustee = $strComputerUser
	$objACE7.AccessMask = $ADS_RIGHT_DS_WRITE_PROP
	$objACE7.AceFlags = 0
	$objACE7.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE7.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE7.ObjectType = $USER_ACCOUNT_RESTRICTIONS

	$objACE8 = ObjCreate("AccessControlEntry")
	$objACE8.Trustee = $strComputerUser
	$objACE8.AccessMask = $ADS_RIGHT_DS_SELF
	$objACE8.AceFlags = 0
	$objACE8.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE8.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE8.ObjectType = $VALIDATED_DNS_HOST_NAME

	$objACE9 = ObjCreate("AccessControlEntry")
	$objACE9.Trustee = $strComputerUser
	$objACE9.AccessMask = $ADS_RIGHT_DS_SELF
	$objACE9.AceFlags = 0
	$objACE9.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objACE9.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objACE9.ObjectType = $VALIDATED_SPN

	$objDACL.AddAce($objACE1)
	$objDACL.AddAce($objACE2)
	$objDACL.AddAce($objACE3)
	$objDACL.AddAce($objACE4)
	$objDACL.AddAce($objACE5)
	$objDACL.AddAce($objACE6)
	$objDACL.AddAce($objACE7)
	$objDACL.AddAce($objACE8)
	$objDACL.AddAce($objACE9)

	$objSecurityDescriptor.DiscretionaryAcl = $objDACL
	$objComputer.Put("ntSecurityDescriptor", $objSecurityDescriptor)
	$objComputer.SetInfo

EndFunc   ;==>_ADCreateComputer

; _ADDeleteObject
; $object = DisplayName of object to delete. $type="user" or "group".

Func _ADDeleteObject($ou, $object, $type)
	If StringLeft($object, 3) <> "CN=" Then
		$object = "CN=" & StringReplace($object, ",", "\,")
	EndIf
	$ObjOU = _ADObjGet("LDAP://" & $strHostServer & "/" & $ou)
	$ObjOU.Delete($type, $object)
	$ObjOU = 0
	Return 1
EndFunc   ;==>_ADDeleteObject

; _ADGetObjectClass
; Returns the Class of an object. Returns 0 if the object does not exist.
Func _ADGetObjectClass($object)
	If _ADObjectExists($object) = 0 Then Return 0

	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $object & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the object
	$ldap_entry = $objRecordSet.fields(0).value
	$oObject = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	
	$class = $oObject.Class
	$oObject = 0
	
	Return $class
	
EndFunc   ;==>_ADGetObjectClass

; _ADGetObjectClassFromFQDN
; Returns the Class of an objectfrom an objects FQDN. Returns 0 if the object does not exist.
Func _ADGetObjectClassFromFQDN($object)
	$oObject = _ADObjGet("LDAP://" & $strHostServer & "/" & $object) ; Retrieve the COM Object for the object
	If IsObj($oObject) = 0 Then
		Return ""
	EndIf
	$class = $oObject.Class
	$oObject = 0
	Return $class
EndFunc   ;==>_ADGetObjectClassFromFQDN

; _ADGetObjectAttribute
; Retrieves the specified (single-value) attribute for the given SamAccountName
; Returns 0 if the object does not exist, the attribute does not exist for that
; object or if the value is multi-string.
; Otherwise returns the result
Func _ADGetObjectAttribute($object, $attribute)
	If _ADObjectExists($object) = 0 Then Return 0

	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $object & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the object
	$ldap_entry = $objRecordSet.fields(0).value
	$oObject = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	$result = $oObject.Get($attribute)
	$oObject.PurgePropertyList
	$oObject = 0
	If $result = "" Then
		Return ""
	Else
		Return $result
	EndIf
	
EndFunc   ;==>_ADGetObjectAttribute

; _ADListDomainControllers
; Retrieves the names of all domain controllers in the current Domain
Func _ADListDomainControllers(ByRef $DCList)
	$objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.Properties("Page Size") = 1000
	$objCommand.Properties("Searchscope") = 2
	
	$objCommand.CommandText = "Select distinguishedName FROM 'LDAP://" & $strHostServer & "/ou=Domain Controllers," & $strDNSDomain & "' WHERE objectclass='computer'"
	
	$objRecordSet = $objCommand.Execute
	Dim $DCList[$objRecordSet.RecordCount + 1]
	$objRecordSet.MoveFirst
	
	Do
		$DCList[0] += 1
		
		$objCommand.CommandText = "<LDAP://" & $strHostServer & "/" & $objRecordSet.Fields("distinguishedName" ).Value & ">;;serverReferenceBL;Range=0-*;base"
		$objRecSet2 = $objCommand.Execute
		
		$objRecSet2.MoveFirst
		Do
			$temparray = $objRecSet2.Fields(0).Value
			$DCList[$DCList[0]] = $temparray[0]
			$objRecSet2.MoveNext
		Until $objRecSet2.EOF
		
		$objRecordSet.MoveNext
	Until $objRecordSet.EOF
	
	$objCommand = 0
	$objRecordSet = 0
	Return
EndFunc   ;==>_ADListDomainControllers

; _ADOUObjectNames
; A faster call for returning the Display Name of objects in a given OU
Func _ADOUObjectNames(ByRef $objects, $ou, $filter = 0, $statusbar = 0, $maxobjects = 1000)
	Local $i
	
	If $statusbar <> 0 Then GUICtrlSetData($statusbar, 0)
	
	$ObjOU = _ADObjGet("LDAP://" & $strHostServer & "/" & $ou)
	
	If $statusbar <> 0 Then GUICtrlSetData($statusbar, 10)
	
	If $filter <> 0 Then $ObjOU.Filter = $filter
	
	If $statusbar <> 0 Then GUICtrlSetData($statusbar, 20)
	
	Dim $objects[$maxobjects + 1]
	
	$i = 1
	Select
		Case $statusbar = 0
			For $object In $ObjOU
				If $i = $maxobjects Then
					ExitLoop
				EndIf
				$name = StringTrimLeft($object.name, 3)
				$objects[$i] = StringReplace($name, "\,", ",")
				$i += 1
			Next
		Case $statusbar <> 0
			For $object In $ObjOU
				If $i = $maxobjects Then
					ExitLoop
				EndIf
				GUICtrlSetData($statusbar, 30 + (($i / $maxobjects) * 80))
				$name = StringTrimLeft($object.name, 3)
				$objects[$i] = StringReplace($name, "\,", ",")
				$i += 1
			Next
	EndSelect
	
	If $i = 0 Then
		$objects = 0
		$ObjOU = 0
		Return
	EndIf
	
	ReDim $objects[$i]
	$objects[0] = $i - 1
	#cs
		For $j = 1 To $i
		If $statusbar <> 0 Then GUICtrlSetData($statusbar, 70 + (($j/$i)*30))
		$tempstr = $tempobjects[$j - 1]
		$tempstr = StringTrimLeft($tempstr, 3)
		$objects[$j] =
		Next
		
		$tempobjects = 0
	#ce
	$ObjOU = 0
EndFunc   ;==>_ADOUObjectNames

; _ADGroupManagerCanModify :
; Returns 1 if the manager of the group can modify the member list, 0 if not, -1 if there is no manager assigned
; Takes full DNs to the group and user

Func _ADGroupManagerCanModify($groupdn)
	$ObjGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $groupdn)
	$managedBy = $ObjGroup.Get("managedBy")
	
	If $managedBy = "" Then Return -1
	
	$ObjUser = _ADObjGet("LDAP://" & $strHostServer & "/" & $managedBy)
	
	$arrUserDN = StringSplit($managedBy, "DC=", 1)
	$strDomain = StringTrimRight($arrUserDN[2], 1)
	$strSamAccountName = $ObjUser.Get("sAMAccountName")
	
	$objNTSecurityDescriptor = $ObjGroup.Get("ntSecurityDescriptor")
	$objDiscretionaryAcl = $objNTSecurityDescriptor.DiscretionaryAcl
	
	$blnMatch = False
	For $objAce In $objDiscretionaryAcl
		If StringLower($objAce.Trustee) = StringLower($strDomain & "\" & $strSamAccountName) And _
				$objAce.ObjectType = $Member_SchemaIDGuid And _
				$objAce.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT And _
				BitAND($objAce.AccessMask, $ADS_RIGHT_DS_WRITE_PROP) = $ADS_RIGHT_DS_WRITE_PROP Then $blnMatch = True
	Next
	
	$ObjGroup = 0
	$ObjUser = 0
	$objNTSecurityDescriptor = 0
	$objDiscretionaryAcl = 0
	
	If $blnMatch Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_ADGroupManagerCanModify

; _ADSetGroupManagerCanModify - Sets the Group manager to be able to modify the member list
; Takes a group DN
; Returns
; -1 if no manager is assigned
; 0 if the manager can already modify the list
; 1 if successful


Func _ADSetGroupManagerCanModify($groupdn)
	If _ADGroupManagerCanModify($groupdn) = 1 Then Return 0
	
	$ObjGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $groupdn)
	$managedBy = $ObjGroup.Get("managedBy")
	
	If $managedBy = "" Then Return -1
	
	$ObjUser = _ADObjGet("LDAP://" & $strHostServer & "/" & $managedBy)
	
	$arrUserDN = StringSplit($managedBy, "DC=", 1)
	$strDomain = StringTrimRight($arrUserDN[2], 1)
	$strSamAccountName = $ObjUser.Get("sAMAccountName")
	
	$objNTSecurityDescriptor = $ObjGroup.Get("ntSecurityDescriptor")
	
	$objNTSecurityDescriptor.Owner = $strDomain & "\" & @UserName
	$objDiscretionaryAcl = $objNTSecurityDescriptor.DiscretionaryAcl
	
	$objAce = ObjCreate("AccessControlEntry")
	$objAce.Trustee = $strDomain & "\" & $strSamAccountName
	$objAce.AccessMask = $ADS_RIGHT_DS_WRITE_PROP
	$objAce.AceFlags = 0
	$objAce.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$objAce.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$objAce.ObjectType = $Member_SchemaIDGuid
	
	$objDiscretionaryAcl.AddAce($objAce)
	$objNTSecurityDescriptor.DiscretionaryAcl = $objDiscretionaryAcl
	$ObjGroup.Put("ntSecurityDescriptor", $objNTSecurityDescriptor)
	$ObjGroup.SetInfo
	If @error = 3 Then
		MsgBox(262144, "Error", "An error occurred assigning permissions on the group.")
		$ObjGroup = 0
		$objDiscretionaryAcl = 0
		$objNTSecurityDescriptor = 0
		$objAce = 0
		Return 0
	EndIf
	$ObjGroup = 0
	$objDiscretionaryAcl = 0
	$objNTSecurityDescriptor = 0
	$objAce = 0
	Return 1
EndFunc   ;==>_ADSetGroupManagerCanModify

; _ADGroupAssignManager
; Takes a group DN and a User DN, assigns the user as the manager of the group

Func _ADGroupAssignManager($groupdn, $userdn)
	$ObjGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $groupdn)
	
	$ObjGroup.Put("managedBy", $userdn)
	$ObjGroup.SetInfo
	$ObjGroup = 0
	Return 1
EndFunc   ;==>_ADGroupAssignManager

; _ADGroupRemoveManager
; Takes a group DN and deletes the group's manager
; arg $option -- 0 (default) removes the manager; 1 only removes manager's modify permission

Func _ADGroupRemoveManager($groupdn, $option = 0)
	$ObjGroup = _ADObjGet("LDAP://" & $strHostServer & "/" & $groupdn)
	
	$managedBy = $ObjGroup.Get("managedBy")
	
	If $managedBy = "" Then Return -1
	
	$ObjUser = _ADObjGet("LDAP://" & $strHostServer & "/" & $managedBy)
	
	$arrUserDN = StringSplit($managedBy, "DC=", 1)
	$strDomain = StringTrimRight($arrUserDN[2], 1)
	$strSamAccountName = $ObjUser.Get("sAMAccountName")
	
	$objNTSecurityDescriptor = $ObjGroup.Get("ntSecurityDescriptor")
	
	$objNTSecurityDescriptor.Owner = $strDomain & "\" & @UserName
	$objDiscretionaryAcl = $objNTSecurityDescriptor.DiscretionaryAcl
	$objTempAcl = ObjCreate("AccessControlList")
	
	$blnMatch = False
	For $objAce In $objDiscretionaryAcl
		If StringLower($objAce.Trustee) = StringLower($strDomain & "\" & $strSamAccountName) And _
				$objAce.ObjectType = $Member_SchemaIDGuid And _
				$objAce.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT And _
				$objAce.AccessMask = $ADS_RIGHT_DS_WRITE_PROP Then _
				$objDiscretionaryAcl.RemoveAce($objAce)
	Next
	
	$objNTSecurityDescriptor.DiscretionaryAcl = $objDiscretionaryAcl
	$ObjGroup.Put("ntSecurityDescriptor", $objNTSecurityDescriptor)
	If Not $option Then $ObjGroup.PutEx(1, "managedBy", 0)
	$ObjGroup.SetInfo
	
	$ObjGroup = 0
	$ObjUser = 0
	$objNTSecurityDescriptor = 0
	$objDiscretionaryAcl = 0
	
EndFunc   ;==>_ADGroupRemoveManager

; _ADEnableAccount
; Takes a DN of an object and enables it if the user has permissions
; Returns 1 if successful, @error otherwise

Func _ADEnableAccount($fqdn)
	$objAccount = _ADObjGet("LDAP://" & $strHostServer & "/" & $fqdn)
	
	$objAccount.AccountDisabled = False
	$objAccount.SetInfo
	$loc_error = @error
	$objAccount = 0
	If $loc_error = 0 Then
		Return 1
	Else
		Return $loc_error
	EndIf
EndFunc   ;==>_ADEnableAccount

; _ADDisableAccount
; Takes a DN of an object and disables it if the user has permissions
; Returns 1 if successful, @error otherwise

Func _ADDisableAccount($fqdn)
	$objAccount = _ADObjGet("LDAP://" & $strHostServer & "/" & $fqdn)
	
	$intUAC = $objAccount.Get("userAccountControl")
	
	$objAccount.Put("userAccountControl", BitOR($intUAC, $ADS_UF_ACCOUNTDISABLE))
	$objAccount.SetInfo
	$loc_error = @error
	$objAccount = 0
	If $loc_error = 0 Then
		Return 1
	Else
		Return $loc_error
	EndIf
EndFunc   ;==>_ADDisableAccount

; _ADGetLastLoginDate
; Takes a SamAccountName of a user account and returns the .lastlogin information for the current DC
Func _ADGetLastLoginDate($user)
	If _ADObjectExists($user) = 0 Then Return 0

	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $user & ");ADsPath;subtree"
	$objRecordSet = $objConnection.Execute($strQuery) ; Retrieve the FQDN for the object
	$ldap_entry = $objRecordSet.fields(0).value
	$oObject = _ADObjGet($ldap_entry) ; Retrieve the COM Object for the object
	$result = $oObject.LastLogin
	$oObject.PurgePropertyList
	
	If $result = "" Then
		Return ""
	Else
		Return $result
	EndIf
EndFunc   ;==>_ADGetLastLoginDate

; _ADAddAccountToMailboxRights
; Takes $mailbox as FQDN and $accountsam as "domain\username"
; Adds Full mailbox rights and 'send as' permission for $accountsam on $mailbox.
; Returns 2 if account already has rights, otherwise returns @error (should be 0 for success, 1 for failure)
Func _ADAddAccountToMailboxRights($mailbox, $accountsam)
	$obj_mailbox = _ADObjGet("LDAP://" & $strHostServer & "/" & $mailbox)
	If Not IsObj($obj_mailbox) Then
		;MsgBox(0, "Error", "Mailbox was not a FQDN or was not found.")
		SetError(3)
		Return
	EndIf
	$obj_mailboxsecurity = $obj_mailbox.MailboxRights
	$mailbox_dacl = $obj_mailboxsecurity.DiscretionaryAcl
	
	For $ace In $mailbox_dacl
		If $ace.trustee = $accountsam Then
			;MsgBox(0, "", "User already has full rights to mailbox")
			SetError(2)
			Return @error
		EndIf
	Next
	
	$obj_ace1 = ObjCreate("AccessControlEntry")
	$obj_ace1.Trustee = $accountsam
	$obj_ace1.AccessMask = 1
	$obj_ace1.AceType = 0
	$obj_ace1.AceFlags = 2
	$obj_ace1.ObjectType = 0
	$obj_ace1.InheritedObjectType = 0
	$obj_ace1.Flags = 0
	
	$mailbox_dacl.AddAce($obj_ace1)
	
	$obj_mailboxsecurity.DiscretionaryAcl = $mailbox_dacl
	$obj_mailbox.MailboxRights = $obj_mailboxsecurity
	
	$obj_ntsecurity = $obj_mailbox.Get("ntSecurityDescriptor")
	$ntsecurity_dacl = $obj_ntsecurity.DiscretionaryAcl
	
	$obj_ace2 = ObjCreate("AccessControlEntry")
	$obj_ace2.Trustee = $accountsam
	$obj_ace2.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$obj_ace2.AceFlags = 0
	$obj_ace2.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$obj_ace2.Flags = 1 ;$ADS_FLAG_OBJECT_TYPE_PRESENT
	$obj_ace2.ObjectType = $SEND_AS
	
	$ntsecurity_dacl.AddAce($obj_ace2)
	
	$obj_ntsecurity.DiscretionaryAcl = $ntsecurity_dacl
	$obj_mailbox.Put("ntSecurityDescriptor", $obj_ntsecurity)
	$obj_mailbox.SetOption($ADS_OPTION_SECURITY_MASK, $ADS_SECURITY_INFO_DACL)
	$obj_mailbox.SetInfo
	
	Return @error
EndFunc   ;==>_ADAddAccountToMailboxRights

Func _ADRemoveMailboxRights($mailbox, $accountsam)
	$obj_mailbox = _ADObjGet("LDAP://" & $strHostServer & "/" & $mailbox)
	If Not IsObj($obj_mailbox) Then
		;MsgBox(0, "Error", "Mailbox was not a FQDN or was not found.")
		SetError(3)
		Return
	EndIf
	$obj_mailboxsecurity = $obj_mailbox.MailboxRights
	$mailbox_dacl = $obj_mailboxsecurity.DiscretionaryAcl
	
	For $ace In $mailbox_dacl
		If $ace.trustee = $accountsam Then
			$mailbox_dacl.RemoveAce($ace)
		EndIf
	Next
	
	$obj_mailboxsecurity.DiscretionaryAcl = $mailbox_dacl
	$obj_mailbox.MailboxRights = $obj_mailboxsecurity
	
	$obj_ntsecurity = $obj_mailbox.Get("ntSecurityDescriptor")
	$ntsecurity_dacl = $obj_ntsecurity.DiscretionaryAcl
	
	For $ace In $ntsecurity_dacl
		If $ace.trustee = $accountsam Then
			$ntsecurity_dacl.RemoveAce($ace)
		EndIf
	Next
	
	$obj_ntsecurity.DiscretionaryAcl = $ntsecurity_dacl
	$obj_mailbox.Put("ntSecurityDescriptor", $obj_ntsecurity)
	$obj_mailbox.SetOption($ADS_OPTION_SECURITY_MASK, $ADS_SECURITY_INFO_DACL)
	$obj_mailbox.SetInfo
	Return @error
	
EndFunc   ;==>_ADRemoveMailboxRights

; _ADGetMailboxPerms
; Takes a mailbox and an array.
; Returns all SamIDs for non-inherited ACEs on the mailbox (stored in the specified array as SamIds)
; Can be filtered on an accessmask value (default = 1, full permissions)
Func _ADGetMailboxPerms($mailbox, ByRef $outputarray, $filter = 1)
	$obj_mailbox = _ADObjGet("LDAP://" & $strHostServer & "/" & $mailbox)
	If Not IsObj($obj_mailbox) Then
		;MsgBox(0, "Error", "Mailbox was not a FQDN or was not found.")
		SetError(3)
		Return
	EndIf
	$obj_mailboxsecurity = $obj_mailbox.MailboxRights
	If Not IsObj($obj_mailboxsecurity) Then
		Return -1
	EndIf
	$mailbox_dacl = $obj_mailboxsecurity.DiscretionaryAcl
	
	For $ace In $mailbox_dacl
		If $ace.AceFlags = 2 Then
			If BitAND($ace.AccessMask, 1) = 1 And $ace.AceType = 0 Then
				_ArrayAdd($outputarray, $ace.Trustee)
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>_ADGetMailboxPerms

; _ADFixSpecialChars
; Takes text and returns either corrected (with 'escaped' chars) or uncorrected (removes 'escapes' for chars) text
; $text = text to fix/unfix
; $option = 0 (default) inserts the escape char, 1 removes it
Func _ADFixSpecialChars($text, $option = 0)
	If $option = 0 Then
		$text = StringReplace($text, "#", "\#")
		$text = StringReplace($text, ",", "\,")
		$text = StringReplace($text, "/", "\/")
		Return $text
	Else
		$text = StringReplace($text, "\#", "#")
		$text = StringReplace($text, "\,", ",")
		$text = StringReplace($text, "\/", "/")
		Return $text
	EndIf
EndFunc   ;==>_ADFixSpecialChars

; _ADRenameObject
; Takes a FQDN of an Object and a new Display name.
; Renames the object.
; Returns 0 for success, 1 if the OU object was not found.
Func _ADRenameObject($oldfqdn, $newdisplayname)
	$OUName = StringTrimLeft($oldfqdn, StringInStr($oldfqdn, "OU=") - 1)
	
	$obj_OU = _ADObjGet("LDAP://" & $strHostServer & "/" & $OUName)
	If IsObj($obj_OU) Then
		$newdisplayname = StringReplace($newdisplayname, ",", "\,")
		$obj_OU.MoveHere("LDAP://" & $oldfqdn, "CN=" & $newdisplayname)
		Return 0
	Else
		SetError(1)
		Return @error
	EndIf
EndFunc   ;==>_ADRenameObject

; _ADAlternativeLogon
; Pass a valid username and password to this function to change the logon context for the current domain

Func _ADAlternativeLogon($user = "", $password = "")
	$objConnection.Close
	$objConnection = 0
	$objConnection = ObjCreate("ADODB.Connection") ; Create COM object to AD
	$objConnection.ConnectionString = "Provider=ADsDSOObject"
	If $user <> "" Then
		$objConnection.Open("Active Directory Provider", $user, $password)
	Else
		$objConnection.Open("Active Directory Provider")
	EndIf
	Return @error
EndFunc   ;==>_ADAlternativeLogon

; _ADObjGet
; Takes a FQDN and returns the LDAP object from that
; Will use the alternative credentials $alt_userid/$alt_password if they exist.

Func _ADObjGet($dn)
	If $alt_userid = "" Then
		Return ObjGet($dn)
	Else
		Return $objOpenDS.OpenDSObject($dn, $alt_userid, $alt_password, BitOR(0x200, 0x1))
	EndIf
EndFunc   ;==>_ADObjGet

Func _ADGetAllOUs($root = "")
	If $root = "" Then $root = $strDNSDomain
	
	Local $objRecordSet
	
	$objCommand = ObjCreate("ADODB.Command")
	$objCommand.ActiveConnection = $objConnection
	$objCommand.Properties("Page Size") = 256
	$objCommand.Properties("Searchscope") = 2
	$objCommand.Properties("TimeOut") = 20

	$strCmdText = "<LDAP://" & $strHostServer & "/" & $root & ">;" & "(objectCategory=organizationalUnit)" & ";distinguishedName,name;subtree"

	$objCommand.CommandText = $strCmdText
	$objRecordSet = $objCommand.Execute

	$recordcount = $objRecordSet.RecordCount
	If $recordcount = 0 Then
		$objCommand = 0
		$objRecordSet = 0
		$results = 0
	Else
		Dim $arr_results[$objRecordSet.RecordCount]
		$i = 0
		$objRecordSet.MoveFirst
		Do
			$arr_results[$i] = $objRecordSet.Fields("distinguishedName" ).Value
			$objRecordSet.MoveNext
			$i += 1
		Until $objRecordSet.EOF
		$results = $arr_results
	EndIf

	If IsArray($results) Then
		For $i = 0 To UBound($results) - 1
			$results[$i] = "," & StringTrimRight($results[$i], StringLen($strDNSDomain) + 1)
			$arr_ou = StringSplit($results[$i], ",OU=", 1)
			_ArrayReverse($arr_ou)
			$results[$i] = StringTrimRight(_ArrayToString($arr_ou, "\"), 3)
		Next
		_ArraySort($results)
		Return $results
	Else
		Return 0
	EndIf

EndFunc   ;==>_ADGetAllOUs