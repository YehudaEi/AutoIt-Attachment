#include<array.au3>
#include"_base64.au3"
#include"ByteArray2Text.au3"
Dim $objADUser, $objComputer, $strGroup, $objGroupList
Dim $objCommand, $objConnection, $strBase, $strAttributes
Global $objADObject
$timer = TimerInit()
; Bind to the user or computer object in Active Directory with the LDAP
; provider.

$strGroup = "GG-Adm-Master"
$struser = @UserName
#cs
	#region de declaration pour les requêtes
	
	$objCommand = ObjCreate("ADODB.Command")
	$objConnection = ObjCreate("ADODB.Connection")
	$objConnection.Provider = "ADsDSOObject"
	$objConnection.Open ("Active Directory Provider")
	$objCommand.ActiveConnection = $objConnection
	$objRootDSE = ObjGet("LDAP://RootDSE")
	$strDNSDomain = $objRootDSE.Get ("defaultNamingContext")
	$objCommand.Properties ("Page Size") = 100
	$objCommand.Properties ("Timeout") = 30
	$objCommand.Properties ("Cache Results") = False
	#endregion
	
	
	#region --requête pour retourner le SID du groupe
	$strquery = "<LDAP://" & $strDNSDomain & ">;(cn="&$strGroup & ");objectSid,distinguishedName;subtree"
	
	ConsoleWrite("requête => " &$strquery & @CRLF)
	$objCommand.CommandText = $strQuery
	$objRecordSet = $objCommand.Execute
	; Enumerate groups and add NT name to dictionary object.
	If Not $objRecordSet.EOF Then
	$dngroupe= $objRecordSet.fields(0).value
	;consolewrite("Sid du groupe => " & OctetToHexStr_vbs($dngroupe) &  @CRLF & "temps => " & TimerDiff($timer))
	
	Else
	Exit
	EndIf
	; Search entire domain.
	
	; Retrieve NT name of each group.
	
	#endregion
	
	#region -requête pour extraire le tokengroups de l'utilisateur
	$strquery = "<LDAP://" & $strDNSDomain & ">;(sAMAccountName="& @UserName & ");primaryGroupToken;subtree"
	
	ConsoleWrite("requête => " &$strquery & @CRLF)
	$objCommand.CommandText = $strQuery
	$objRecordSet = $objCommand.Execute
	; Enumerate groups and add NT name to dictionary object.
	If Not $objRecordSet.EOF Then
	$dngroupe= $objRecordSet.fields(0).value
	consolewrite("Sid de l'utilisateur => " & UBound($dngroupe) &  @CRLF & "temps => " & TimerDiff($timer))
	Exit
	Else
	
	EndIf
	#endregion
#ce
; Test for group membership.
$strGroup = "GG-Acces-Usb"
$objADObject1 = ObjGet("LDAP://SomePath")
If IsMember($objADObject1, $strGroup) Then
	ConsoleWrite("User " & $objADObject1.name _
			 & " is a member of group " & $strGroup & @CRLF)
Else
	ConsoleWrite("User " & $objADObject1.name _
			 & " is NOT a member of group " & $strGroup & @CRLF)
EndIf
If IsObj($objConnection) Then
	$objConnection.Close
EndIf
ConsoleWrite(Round(TimerDiff($timer), 3) & @CRLF)
Func IsMember($objADObject, $strGroupNTName)
	; Function to test for group membership.
	; objADObject is a user or computer object.
	; strGroupNTName is the NT name (sAMAccountName) of the group to test.
	; objGroupList is a dictionary object, with global scope.
	; Returns True if the user or computer is a member of the group.
	; Subroutine LoadGroups is called once for each different objADObject.
	Dim $objRootDSE, $strDNSDomain
	; The first time IsMember is called, setup the dictionary object
	; and objects required for ADO.
	;If IsString$objGroupList) Then
	$objGroupList = ObjCreate("Scripting.Dictionary")
	$objGroupList.CompareMode = 0
	$objCommand = ObjCreate("ADODB.Command")
	$objConnection = ObjCreate("ADODB.Connection")
	$objConnection.Provider = "ADsDSOObject"
	$objConnection.Open ("Active Directory Provider")
	$objCommand.ActiveConnection = $objConnection
	$objRootDSE = ObjGet("LDAP://RootDSE")
	$strDNSDomain = $objRootDSE.Get ("defaultNamingContext")
	$objCommand.Properties ("Page Size") = 100
	$objCommand.Properties ("Timeout") = 30
	$objCommand.Properties ("Cache Results") = False
	$strAttributes = "sAMAccountName,primaryGroupToken"
	$strFilter = "(objectCategory=group)"
	$strQuery = "<LDAP://" & $strDNSDomain & ">;" & $strFilter & ";" _
			 & $strAttributes & ";subtree"
	$objCommand.CommandText = $strQuery
	$objRecordSet = $objCommand.Execute
	If Not $objGroupList.Exists ($objADObject.sAMAccountName & "\") Then
		; Call LoadGroups for each different objADObject.
		; Add object name to dictionary object so groups need only be
		; enumerated once.
		
		LoadGroups($objADObject, $objADObject)
		$objGroupList ($objADObject.sAMAccountName & "\") = True
		;Determine which group is the primary group for this object.
		$intPrimaryGroupID = $objADObject.primaryGroupID
		ConsoleWrite("$intPrimaryGroupID " & $intPrimaryGroupID  & @CRLF)
		;$objRecordSet.MoveFirst
		While Not $objRecordSet.EOF
			$intPrimaryGroupToken = $objRecordSet (1).value
			consolewrite("$intPrimaryGroupToken => " & $intPrimaryGroupToken & @crlf)
			If $intPrimaryGroupToken = $intPrimaryGroupID Then
				$strPrimaryGroup = $objRecordSet.Fields (0).Value
				ConsoleWrite($strPrimaryGroup& @crlf) 
				$objGroupList ($objADObject.sAMAccountName & "\" & $strPrimaryGroup) = True
				ExitLoop
			EndIf
			$objRecordSet.MoveNext
		WEnd
	EndIf
	; Check group membership.
	ConsoleWrite("$objgrouplist=>>> "& $objgrouplist.count& @CRLF)
	
	$IsMember = $objGroupList.Exists ($objADObject.sAMAccountName & "\" _
			 & $strGroup)
			 ConsoleWrite("test groupe => " & $objADObject.sAMAccountName & "\" _
			 & $strGroup & @CRLF)
	consolewrite("ismember " & $ismember & @crlf)
	return $ismember	
EndFunc   ;==>IsMember
Func LoadGroups($objPriADObject, $objSubADObject)
	; Recursive subroutine to populate dictionary object with group
	; memberships. When this subroutine is first called by Function
	; IsMember, both objPriADObject and objSubADObject are the user or
	; computer object. On recursive calls objPriADObject still refers to the
	; user or computer object being tested, but objSubADObject will be a
	; group object. The dictionary object objGroupList keeps track of group
	; memberships for each user or computer separately.
	; For each group in the MemberOf collection, first check to see if
	; the group is already in the dictionary object. If it is not, add the
	; group to the dictionary object and recursively call this subroutine
	; again to enumerate any groups the group might be a member of (nested
	; groups). It is necessary to first check if the group is already in the
	; dictionary object to prevent an infinite loop if the group nesting is
	; "circular". The MemberOf collection does not include any "primary"
	; groups.
	  Dim $colstrGroups, $objGroup, $j
  $colstrGroups = $objSubADObject.memberOf
  If not $colstrGroups = "" Then
    ;Exit Sub
  
  If IsString($colstrGroups) Then
	  ConsoleWrite("$colstrGroups " & $colstrGroups & @crlf)
    $objGroup = Objget("LDAP://" & $colstrGroups)
    If Not $objGroupList.Exists($objPriADObject.sAMAccountName & "\" _
        & $objGroup.sAMAccountName) Then
      $objGroupList($objPriADObject.sAMAccountName & "\" _
        & $objGroup.sAMAccountName) = True
      LoadGroups($objPriADObject, $objGroup)
    EndIf
    $objGroup = ""
    ;Exit Sub
  EndIf
  For $j = 0 To UBound($colstrGroups)
    $objGroup = Objget("LDAP://" & $colstrGroups[$j])
    If Not $objGroupList.Exists($objPriADObject.sAMAccountName & "\" _
        & $objGroup.sAMAccountName) Then
      $objGroupList($objPriADObject.sAMAccountName & "\" _
        & $objGroup.sAMAccountName) = True
      LoadGroups($objPriADObject, $objGroup)
    EndIf
  Next
  EndIf
EndFunc   ;==>LoadGroups