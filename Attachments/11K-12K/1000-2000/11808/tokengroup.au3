; ====================================================================================================
; Author........: Yoan Roblet
; Date..........: 11-02-2006
; Description ..: Test if the specified user is a member of the specified groupname
; Parameters ...:
;                 $groupname    - Name of the group
;				  $username        - Username
; Return values : Return True is the membership is found
; ====================================================================================================
#include-once
#include<array.au3>
Dim $strBase, $strAttributes, $vbs
Global $objGroupList, $objConnection, $objCommand
$objGroupList = ObjCreate("Scripting.Dictionary")
$objGroupList.CompareMode = 1
$objCommand = ObjCreate("ADODB.Command")
$objConnection = ObjCreate("ADODB.Connection")
$objConnection.Provider = "ADsDSOObject"
$objConnection.Open ("Active Directory Provider")
$objCommand.ActiveConnection = $objConnection
$objCommand.Properties ("Page Size") = 100
$objCommand.Properties ("Timeout") = 30
$objCommand.Properties ("Cache Results") = False
Func _ismembertoken($groupname, $username = @UserName)
	$timer = TimerInit()
	
	;Dim $objADUser, $objComputer, $strGroup, $objGroupList
	;Dim $objCommand, $objConnection, $strBase, $strAttributes
	Global $vbs
	OctetToHexStr_vbs_declare()
	; Bind to the user or computer object in Active Directory with the LDAP
	; provider.
	#region-defaultdomain
	$objRootDSE = ObjGet("LDAP://RootDSE")
	Global $strDNSDomain = $objRootDSE.Get ("defaultNamingContext")
	#endregion
	#region -requête pour extraire le DN de l'utilisateur
	$strQuery = "<LDAP://" & $strDNSDomain & ">;(sAMAccountName=" & $username & ");distinguishedName;subtree"
	
	ConsoleWrite("requête => " & $strQuery & @CRLF)
	$objCommand.CommandText = $strQuery
	$objRecordSet = $objCommand.Execute
	; Enumerate groups and add NT name to dictionary object.
	If Not $objRecordSet.EOF Then
		$dnuser = $objRecordSet.fields (0).value
		ConsoleWrite("DN de l'utilisateur => " & $dnuser & @CRLF & "temps => " & TimerDiff($timer))
		$objADUser = ObjGet("LDAP://" & $dnuser)
	Else
		Exit
	EndIf
	#endregion
	; Test for group membership.
	$strGroup = $groupname
	If IsMember($objADUser, $strGroup) Then
		ConsoleWrite("User " & $objADUser.name _
				 & " is a member of group " & $strGroup & @CRLF)
	Else
		ConsoleWrite("User " & $objADUser.name _
				 & " is NOT a member of group " & $strGroup & @CRLF)
	EndIf
	If IsObj($objConnection) Then
		$objConnection.Close
	EndIf
	ConsoleWrite(Round(TimerDiff($timer), 3) & @CRLF)
EndFunc   ;==>_ismembertoken
; Clean up.
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
	
	; Search entire domain.
	$strBase = "<LDAP://" & $strDNSDomain & ">"
	; Retrieve NT name of each group.
	$strAttributes = "sAMAccountName"
	; Load group memberships for this user or computer into dictionary
	; object.
	LoadGroups($objADObject)
	$objRootDSE = ""
	;EndIf
	If Not $objGroupList.Exists ($objADObject.sAMAccountName & "\") Then
		; Dictionary object established, but group memberships for this
		; user or computer must be added.
		LoadGroups($objADObject)
	EndIf
	
	; Return True if this user or computer is a member of the group.
	$IsMember = $objGroupList.Exists ($objADObject.sAMAccountName & "\" _
			 & $strGroupNTName)
	ConsoleWrite("test groupe => " & $objADObject.sAMAccountName & "\" _
			 & $strGroupNTName & @CRLF)
	ConsoleWrite("ismember = " & $IsMember & @CRLF)
	Return $IsMember
EndFunc   ;==>IsMember
Func LoadGroups($objADObject)
	; Subroutine to populate dictionary object with group memberships.
	; objGroupList is a dictionary object, with global scope. It keeps track
	; of group memberships for each user or computer separately. ADO is used
	; to retrieve the name of the group corresponding to each objectSid in
	; the tokenGroup array. Based on an idea by Joe Kaplan.
	Dim $arrbytGroups, $k, $strFilter, $objRecordSet, $strGroupName, $strQuery
	; Add user name to dictionary object, so LoadGroups need only be
	; called once for each user or computer.
	$objGroupList ($objADObject.sAMAccountName & "\") = True
	; Retrieve tokenGroups array, a calculated attribute.
	$proplist = _ArrayCreate("tokenGroups")
	$objADObject.GetInfoEx ($proplist, 0)
	$arrbytGroups = $objADObject.Get ("tokenGroups")
	; Create a filter to search for groups with objectSid equal to each
	; value in tokenGroups array.
	$strFilter = "(|"
	;If Type(arrbytGroups) = "Byte()" Then
	; tokenGroups has one entry.
	;  strFilter = strFilter & "(objectSid=" _
	;   & OctetToHexStr(arrbytGroups) & ")"
	;Else
	If UBound($arrbytGroups) > -1 Then
		; TokenGroups is an array of two or more objectSid's.
		For $k = 0 To UBound($arrbytGroups) - 1
			$strFilter = $strFilter & "(objectSid=" _
					 & OctetToHexStr_vbs($arrbytGroups[$k]) & ")"
		Next
	Else
		; tokenGroups has no objectSid's.
		;Exit Func
	EndIf
	$strFilter = $strFilter & ")"
	; Use ADO to search for groups whose objectSid matches any of the
	; tokenGroups values for this user or computer.
	$strQuery = $strBase & ";" & $strFilter & ";" _
			 & $strAttributes & ";subtree"
	;ConsoleWrite("requête_2 => " &$strquery & @CRLF)
	$objCommand.CommandText = $strQuery
	$objRecordSet = $objCommand.Execute
	; Enumerate groups and add NT name to dictionary object.
	While Not $objRecordSet.EOF
		
		$strGroupName = $objRecordSet.Fields ("sAMAccountName").Value
		;consolewrite("sAMAccountName = " & $strGroupName & @CRLF)
		$objGroupList ($objADObject.sAMAccountName & "\" _
				 & $strGroupName) = True
		$objRecordSet.MoveNext
	WEnd
	$objRecordSet = ""
EndFunc   ;==>LoadGroups
Func OctetToHexStr_vbs_declare()
	
	Local $s_Quotes = '"'
	$code = "Function OctetToHexStr(arrbytOctet)"
	$code = $code & @CRLF & "Dim k"
	$code = $code & @CRLF & "OctetToHexStr = """""
	$code = $code & @CRLF & "For k = 1 To LenB(arrbytOctet)"
	$code = $code & @CRLF & "OctetToHexStr = OctetToHexStr & ""\"" & Right(""0"" & Hex(Ascb(Midb(arrbytOctet, k, 1))), 2)"
	;$code = $code & @CRLF & "& Right(""0"" & Hex(Ascb(Midb(arrbytOctet, k, 1))), 2)"
	$code = $code & @CRLF & "Next"
	$code = $code & @CRLF & "end Function"
	$vbs = ObjCreate("ScriptControl")
	$vbs.language = "vbscript"
	$vbs.addcode ($code)
EndFunc   ;==>OctetToHexStr_vbs_declare
Func OctetToHexStr_vbs($arrbytOctet)
	$retour = $vbs.run ("OctetToHexStr", $arrbytOctet)
	;ConsoleWrite($retour & @CRLF)
	Return $retour
EndFunc   ;==>OctetToHexStr_vbs
Func OctetToHexStr($arrbytOctet) ;doesn't Work
	; Function to convert OctetString (byte array) to Hex string,
	; with bytes delimited by \ for an ADO filter.
	;if IsBinaryString($arrbytOctet) then consolewrite ("uep" & @crlf)
	Dim $k
	$OctetToHexStr = ""
	For $k = 1 To StringLen($arrbytOctet)
		$OctetToHexStr = $OctetToHexStr & "\" _
				 & StringRight("0" & Hex(Asc(StringMid($arrbytOctet, $k, 1))), 2)
		ConsoleWrite($OctetToHexStr & @CRLF)
	Next
	Return $OctetToHexStr
EndFunc   ;==>OctetToHexStr
;Stream_BinaryToString Function
;2003 Antonin Foller, http://www.motobit.com
;Binary - VT_UI1 | VT_ARRAY data To convert To a string
;CharSet - charset of the source binary data - default is "us-ascii"
Func Stream_BinaryToString($Binary, $CharSet = "")
	Const $adTypeText = 2
	Const $adTypeBinary = 1
	;consolewrite($Binary & @crlf)
	;Create Stream object
	Dim $BinaryStream ;As New Stream
	$BinaryStream = ObjCreate("ADODB.Stream")
	;Specify stream type - we want To save text/string data.
	$BinaryStream.Type = $adTypeBinary
	;Open the stream And write text/string data To the object
	$BinaryStream.Open
	$BinaryStream.Write ($Binary)
	;Change stream type To binary
	$BinaryStream.Position = 0
	$BinaryStream.Type = $adTypeText
	;Specify charset For the source text (unicode) data.
	If StringLen($CharSet) > 0 Then
		$BinaryStream.CharSet = $CharSet
	Else
		$BinaryStream.CharSet = "us-ascii"
	EndIf
	;Open the stream And get binary data from the object
	$Stream_BinaryToString = $BinaryStream.ReadText
	ConsoleWrite($Stream_BinaryToString & @CRLF)
	Return $Stream_BinaryToString
EndFunc   ;==>Stream_BinaryToString
#cs
	Func OctetToHexStr(arrbytOctet)
	; Function to convert OctetString (byte array) to Hex string,
	; with bytes delimited by \ for an ADO filter.
	
	Dim k
	WScript.Echo LenB(arrbytOctet)
	OctetToHexStr = ""
	For k = 1 To LenB(arrbytOctet)
	OctetToHexStr = OctetToHexStr & "\" _
	& Right("0" & Hex(Ascb(Midb(arrbytOctet, k, 1))), 2)
	Next
	WScript.Echo "OctetToHex en sortie" & VbCrLf & OctetToHexStr
	EndFunc
#ce